# numc

Here's what I did in project 4:

## Task 1

1. 当分配内存时一定要为所有指针分配，例如**matrix**结构中的**\**data**在初始化data的值之前要先为它分配内存。

2. 当malloc分配内存失败时记得打印输出错误原因并抛出错误值，且返回前free掉前面分配的内存。

   