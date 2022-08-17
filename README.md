# Floating_Point_ALU
IEEE754 Single precision FLoating Point ALU

## Introduction
ALU is the fundamental block of any proccessor. This ALU has high counting power comparing to normal ALU that we have implemented in risc, it can be replaced with our ALU in risc proccessor making it even stronger

## Functions in ALU
- [Addition](https://github.com/Sairamakula1999/Floating_Point_ALU/blob/main/README.md#additionsubtraction)
- [Subtraction](https://github.com/Sairamakula1999/Floating_Point_ALU/blob/main/README.md#additionsubtraction)
- [Multiplication](https://github.com/Sairamakula1999/Floating_Point_ALU/blob/main/README.md#Multiplication)
- [Division](https://github.com/Sairamakula1999/Floating_Point_ALU/blob/main/README.md#Division)

## Addition/Subtraction
Firstly one needs to see if Exponent is matched if not match it with the highest one. After that based on signs on inputs A,B and sign of operation given one needs to check whether addition or subtraction needs to be performed. After that one nedds to add or subtact mantissa and based on cout and operation that has been performed sign of result is evaluated. If both are added then carryout will be added to exponent. if subtracted and carryout is zero mean mantissa is negative. So, one needs to take its two's complimentand save it. In this we have used carry look ahead adder for addition.

## Multiplication
We have implemented following circuit in design using flow as mentioned below

## Division
We have implemented following circuit in design using flow as mentioned below
