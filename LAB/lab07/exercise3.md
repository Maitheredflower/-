--- not autograded ---

Part 1
    blocksize = 20, n = 100: 
    blocksize = 20, n = 1000: 
    blocksize = 20, n = 2000: 
    blocksize = 20, n = 5000: 
    blocksize = 20, n = 10000: 

![image-20230922105506534](/home/ytq/.config/Typora/typora-user-images/image-20230922105506534.png)

    Checkoff Question 1: 当n = 2000时阻塞cache的性能优于原始cache
    Checkoff Question 2: 当矩阵的规模过小时无法体现出block cache的作用，因为原始cache能够做到将小矩阵全部装下并进行转置操作，block cache方案反而会因分块而影响到操作时间。当矩阵很大而原始cache无法装下时就会体现出block cache的作用。

Part 2
    blocksize = 50, n = 10000:
    blocksize = 100, n = 10000:
    blocksize = 500, n = 10000:
    blocksize = 1000, n = 10000:
    blocksize = 5000, n = 10000:

![image-20230922110528772](/home/ytq/.config/Typora/typora-user-images/image-20230922110528772.png)

    Checkoff Question 3: 当blocksize从50增加至500时计算速度越来越快，而当blocksize从500增加到5000时计算速度越来越慢，因为当blocksize过小时计算会受到blocksize块替换太过频繁的影响导致速度变慢，而blocksize过大就会失去block cache的优势转变为原来的一整块大矩阵计算。
