koin 快速排序


fun <T : Comparable<T>> List<T>.quickSort(): List<T> = 
    if(size < 2) this
    else {
        val pivot = first()
        val (smaller, greater) = drop(1).partition { it <= pivot}
        smaller.quickSort() + pivot + greater.quickSort()
    }
    
// 使用 [2,5,1] -> [1,2,5]
listOf(2,5,1).quickSort() // [1,2,5]
