# CS61CPU

Look ma, I made a CPU! Here's what I did:



## 1. 根据Slides中的图片建立Datapath

![image-20230908130610618](/home/ytq/.config/Typora/typora-user-images/image-20230908130610618.png)

可以大致分为**5**部分(**IF/ID/EXE/MEM/WB**)

### Single CPU

1. **IF**

	* 通过Program_counter来控制PC以及取指令，从0开始将PC送入IMEM中获取相应地址的INSTRUCTION完成INSTRUCTION_FETCH，与此同时PC+4传回PC_reg中。
	* 当有branch类型的指令时写回的program_counter将是alu_result，通过PCSel在PC+4和alu_result之间选择。

2. **ID**

- 通过splitter将从IMEM中获取的INSTRUCION分为几部分(通过查表找到共通点)完成INSTRUCTION_DECODE。
- 通过将INSTRUCTION送入子电路(imm_gen)中进行立即数的生成(immediate generate)，通过查表方式得到不同指令类型的不同立即数生成方式，通过splitter解析出立即数并用bit extender扩展至32位，再通过判断opcode的方式选择生成的立即数并输出。

3. **EXE**

- reg: 根据指示在子电路regfile中填充32个register，并通过输入信号与多路选择器控制寄存器的读写。
- alu:根据Datapath图输入参数到ALU中，并通过control_logic来控制ALU的计算行为。

4. MEM

- WRITE_ADDRESS: 直接连接alu_result。
- WRITE_EN: 根据指令类型(store byte/SB    store half/SH)来写mask，即SB为1(0001)，SH为3(0011)，sw为f(1111)，再通过control_logic的MemRW控制信号选择mask为0还是store指令信号产生的mask(因为只有store指令才能写回内存MEM)。
- WRITE_DATA: 直接连接regfile的read_data_2。

5. **WB**

- 0: Data_Decode，从MEM内存中读出的数据进行解码(LW LH LB与store指令同理编写mask)
- 1: alu_result
- 2: PC+4
- 通过control_logic生成的WBSel控制信号选择写回数据，生成的WBData连接到regfile的的WRITE_DATA

### pipelined

- 在IF和ID之间建立一个IF/ID寄存器用于存储INSTRUCTION，这样就可以完成二级流水。
- 同时**通过PCSel对INSTRUCTION和0x00000013之间进行选择，因为branch以及jump等指令可能会产生hazard，通过增加bubbles(0x00000013)来消除hazard**，因此在control_logic中对相应的控制信号PCSel进行控制。



## 2. control_logic编写

大部分可以通过查表来得出控制逻辑，通过**硬连线**得到控制信号，小部分需要格外注意，通过comparater门电路与opcode、funct3、funct7等对比得出指令类型进行进一步分类控制。

- PCSel: 当branch成功时需要选择新的PC，因此在control_logic中**对branch指令进行检查后若正确则PCSel=1，同时jump以及jarl指令也需要PCSel=1**
- RegWEn: 查表查看哪些需要写回寄存器Regfile
- ImmSel: 查表查看imm生成格式进行选择，并于imm_gen子电路中的控制选择相对应。
- BrUn: 查表对应opcode、funct3得出unsigned branch
- ASel、BSel:查遍通过opcode进行硬连线
- ALUSel: 通过opcode以及funct3、funct7对R、I类型指令进行分类得出RSel，再通过多路选择器选择，若为R、I类型则选择RSel，否则默认ALU为加法即ALUSel=0
- MemRW: 只有STORE类型指令才使MemRW=1
- WBSel: 查表得到写回数据的类型选择
