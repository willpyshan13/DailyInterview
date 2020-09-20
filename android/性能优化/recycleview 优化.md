recycleview 优化

阿里面试总共4轮，其中有3轮面试都问到了RecyclerView的问题。面试的点各不相同，有原理、嵌套问题、有缓存实现，但是最终都是殊途同归，所有的问题都汇集在,如何对RecyclerView做性能优化？

1.1 RecyclerView第一次layout时，会发生预布局pre-layout吗？
​ 第一次布局时，并不会触发pre-layout。pre-layout只会在每次notify change时才会被触发，目的是通过saveOldPosition方法将屏幕中各位置上的ViewHolder的坐标记录下来，并在重新布局之后，通过对比实现Item的动画效果。比如以下效果：


1.2 如果自定义LayoutManager需要注意什么？
在RecyclerView的dispatchLayoutStep1阶段，会调用自定义LayoutManager的 supportsPredictiveItemAnimations 方法判断在某些状态下是否展示predictive animation。以下LinearLayoutManager的实现：

@Override
public boolean supportsPredictiveItemAnimations() {
return mPendingSavedState == null && mLastStackFromEnd == mStackFromEnd;
}
​ 如果 supportsPredictiveItemAnimations 返回true，则LayoutManager中复写onLayoutChildren方法会被调用2次：一次是在pre-layout，另一次是real-layout。

因为会有pre-layout和real-layout，所有在自定义LayoutManager中，需要根据RecyclerView.State中的isPreLayout方法的返回值，在这两次布局中做区分。比如LinearLayoutManager中的onLayoutChildren中有如下判断：


上面代码中有一段注释：

if the child is visible and we are going to move it around, we should layout extra items in the opposite direction to make sure new items animate nicely instead of just fading in

​ 代表的意思就是如果当前正在update的item是可见状态，则需要在pre-layout阶段额外填充一个item，目的是为了保证处于不可见状态的item可以平滑的滑动到屏幕内。

1.3 举例说明
​ 比如下图中点击item2将其删除，调用notifyItemRemoved后，在pre-layout之前item5并没有被添加到RecyclerView中，而经过pre-layout之后，item5经过布局会被填充到RecyclerView中


当item移出屏幕之后，item5会随同item3和item4一起向上移动，如下图所示：



​ 如果自定义LayoutManager并没有实现pre-layout，或者实现不合理，则当item2移出屏幕时，只会将item3和item4进行平滑移动，而item5只是单纯的appear到屏幕中，如下所示：



可以看出item5并没有同item3和item4一起平滑滚动到屏幕内，这样界面上显示会给用户卡顿的感觉。

1.4 ViewHolder何时被缓存到RecycledViewPool中？
主要有以下2种情况：

当ItemView被滑动出屏幕时，并且CachedView已满，则ViewHolder会被缓存到RecycledViewPool中
当数据发生变动时，执行完disappearrance的ViewHolder会被缓存到RecycledViewPool中
1.5 CachedView和RecycledViewPool的关系
​ 当一个ItemView被滑动滚出屏幕之后，默认会先被保存在CachedView中。CachedView的默认大小为2，可以通过 setItemViewCacheSize 方法修改它的值。当CachedView已满后，后续有新的ItemView从屏幕内滑出时，会迫使CachedView根据FIFO规则，将之前的缓存的ViewHolder转移到RecycledViewPool中，效果可以参考下图：



RecycledViewPool默认大小为5，可以通过以下方式修改RecycledViewPool的缓存大小：

RecyclerView.getRecycledViewPool().setMaxRecycledViews(int viewType, int max);
1.6 CachedView和RecycledViewPool两者区别
缓存到CachedView中的ViewHolder并不会清理相关信息(比如position、state等)，因此刚移出屏幕的ViewHolder，再次被移回屏幕时，只要从CachedView中查找并显示即可，不需要重新绑定(bindViewHolder)。

而缓存到RecycledViewPool中的ViewHolder会被清理状态和位置信息，因此从RecycledViewPool查找到ViewHolder，需要重新调用bindViewHolder绑定数据。

1.7 你是从哪些方面优化RecyclerView的？
我总结了几点，主要可以从以下几个方面对RecyclerView进行优化：

尽量将复杂的数据处理操作放到异步中完成。RecyclerView需要展示的数据经常是从远端服务器上请求获取，但是在网络请求拿到数据之后，需要将数据做扁平化操作，尽量将最优质的数据格式返回给UI线程。

优化RecyclerView的布局，避免将其与ConstraintLayout使用

针对快速滑动事件，可以使用addOnScrollListener添加对快速滑动的监听，当用户快速滑动时，停止加载数据操作。

如果ItemView的高度固定，可以使用setHasFixSize(true)。这样RecyclerView在onMeasure阶段可以直接计算出高度，不需要多次计算子ItemView的高度，这种情况对于垂直RecyclerView中嵌套横向RecyclerView效果非常显著。

当UI是Tab feed流时，可以考虑使用RecycledViewPool来实现多个RecyclerView的缓存共享。