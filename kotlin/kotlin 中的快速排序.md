kotlin 快速排序


fun <T : Comparable<T>> List<T>.quickSort(): List<T> = 
    if(size < 2) this
    else {
        val pivot = first()
        val (smaller, greater) = drop(1).partition { it <= pivot}
        smaller.quickSort() + pivot + greater.quickSort()
    }
    
// 使用 [2,5,1] -> [1,2,5]
listOf(2,5,1).quickSort() // [1,2,5]


我想分享一个很酷的算法，用一行代码实现杨辉三角，代码来自 Marcin Moskala 大神
fun pascal() = generateSequence(listOf(1)) { prev ->
    listOf(1) + (1..prev.lastIndex).map { prev[it - 1] + prev[it] } + listOf(1)
}

fun main() {
    pascal().take(10).forEach(::println)
}

