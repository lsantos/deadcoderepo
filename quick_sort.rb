def quick_sort(list)
  return if list.size <= 0
  pivot = list[list.size / 2]
  left = list.find_all {|item| item < pivot}
  right = list.find_all {|item| item > pivot}
  
  (quick_sort(left) + quick_sort(right)) 
end

array = [10,5,1,7,2]

p quick_sort array