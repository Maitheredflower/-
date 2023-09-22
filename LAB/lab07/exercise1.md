# Scenario 1
       1. Because Cache_size in bytes is exactly equal to array_size in bytes
       2. hit_rate = 1 - (1 / rep_count),因为第一次是cold状态，都是complusory miss，此后都会命中，所以只有第一次是miss，即miss_rate = 1 - 4 / (4 * rep_count)
       3. 减小step_size以及增大rep_count可以增加hit_rate，array_size和option不能更改

# Scenario 2
       1. 2 read and write
       2. MHHH 3/4
       3. rep_count增加，hit_rate会增加到1.0
       4. 因为第一次循环会将所有数据装入cache中，下次以rep_count就会全部hit，hit_rate = 16 / access_times，一共只有16次miss，每个block一次
       5. 将array分成大小与cache_size相等的块，并更改array的访问方式，即改为每次访问cache_size块大小的数组，并依次完成所有rep_count的函数操作以利用局部性提高hit_rate，此后这部分数组将不再会被使用也就不会出现miss现象。

# Scenario 3
       1. [L1 0.5], [L2 0.0], [Overall 0.5]
       2. [[32 of L1 accesses], [16 of L1 misses]
       3. [[16 of L2 accesses], 当L1 cache miss时访问L2 cache
       4. 改变L2 cache的块大小可以增加L2的hit rate，因为这样可以一次载入更多数据，当L1 cache miss时从L2 cache中可以取到
       5. [1_L1], [1_L2], [2_L1], [2_L2]：(1): = =, (2): + =
