# Exercise 1:
       1. 32 offset一共5位
       2. 5,5,0,5
       3. NO,NO

# Exercise 2:
​    1. 10,20,40,60,80,A0,C0,E0,10,20	分解地址为 XXX XXXXX只需保证前三位在两个周期内(TLB一共可以存4组数据，因此周期为4)不一样即可。

# Exercise 3:
​    1. increase Physical Memory Size，这样使得Frame Number变多而Page Table中有更多与之对应的存储降低Page Fault。

--- lines below are ignored by the AG ---

 but result in fewer than ten page faults?Exercise 1 Checkoff Questions:
       1. 当获取一个虚拟地址后会首先查找TLB中相对应的Physical Page Number，如果存在则找到(TLB hit)对应的物理地址(Frame Number * 32 + offset)，如果不存在(TLB miss)则在Page Table中寻找，如果valid bit > 0则找到相应的frame number(Page hit)得出物理地址(Frame Number * 32 + offset)，否则(Page Fault)根据最近最少被使用原则(LRU)替换掉相应的Page Frame，并在相应的TLB和Page Table中进行更改。
       2. 物理地址的Page Frame一共有4块，所以PPN为2位；虚拟地址的virtual memory一共有8个，所以VPN一共有3位以起到扩展内存、地址隔内存保护以及虚拟内存映射的作用。

Exercise 4 Checkoff Question:
    1. P1,P2,P3,P4每次更新时TLB也会清空进行新一轮的更新导致上一组存储的TLB失去了可利用的局部性，四个模块P1,P2,P3,P4是隔离开的而不是作为一个整体共用TLB，导致TLB miss rate上升。
