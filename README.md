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
Firstly one needs to check if Exponents are matched. if not matched, then normalize it with the highest one by shifting manissa accordingly. After that based on signs on inputs A,B and sign of operation given one needs to check whether addition or subtraction needs to be performed. After that one nedds to add or subtact mantissa. In this we have used carry look ahead adder for addition. Based on cout and operation that has been performed sign of result is evaluated. If both are added, then carryout will be added to exponent. if subtracted and carryout is zero mean mantissa is negative, then one needs to take its two's complimentand and save it. If exponent has exceeded 255 then overflow is triggered. If exponent goes negative then underflow is triggered.

## Multiplication
Here there is no need of exponent matching unlike in addition/subtaction. booth multiplier is used for multiplication, here mantissa along with reduced bit and one additional bit for sign is added in both inputs. After multiplication mantissa excceds more than 23 bits that are available. So, lower bits are reduced by taking upper 23 bits in a way that there is no shft needed. if shift is done than exponent needs to be added. Sign is easly taken by inputs A & B sign bits. Exponents are added and bias(127) is subtracted. After that if 

## Division
We have implemented following circuit in design using flow as mentioned below
