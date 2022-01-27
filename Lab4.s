@ Christian Vanzant
@ csv0004@uah.edu
@ CS309-01 2021

@ Use these commands to assemble, link, run and debug this program:
@    as -o Lab4.o Lab4.s
@    gcc -o Lab4 Lab4.o
@    ./Lab4 ;echo $?
@    gdb --args ./Lab4

.equ READERROR, 0  @Used to check for scanf read error. 


.global main

main:

prompt:

@ Ask the user to enter a number.
 
   ldr r0, =numInputPrompt @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 

@ Set up r0 with number 

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error, handle it. 
   ldr r1, =intInput        @ Reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 
   cmp r1, #12              @ If number is greater than 12, branch to readerror
   bgt readerror      
   cmp r1, #1               @ If Number is less than 1, branch to readerror
   blt readerror           
   ldr r1, =intInput        @ Reload r1 because it gets wiped out. 
   ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 

   mov r10, r1     @ Use new register b/c we need original user input for final output.
   mov r2, #1      @ Set to 1 as the start of the integer multiplication
                   @ Using r2 so it becomes the 2nd parameter in the final print statement

@ Loop for factorial 

loop:
   cmp r10, #1		@ If the user input number is equal to one, the factorial
   ble output           @ has been calculated, so branch to output

   mul r2, r10, r2      @ Multiply r10 with the last number generated from 
                        @ the same multiplication instruction
   sub r10, r10, #1     @ Decrement 1 to further multiply n(n-1)

   bl loop              @ Branch back to loop. Obviously. It's a loop.

@ Output Branch

output:
   ldr r0, =outputPrompt
   bl printf
   
   b myexit 


readerror:

@ In case of read error, clear out the input buffer then
@ branch back for the user to enter a value. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.

   b prompt


myexit:

@ Force the exit and return control to OS

   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call. 


.data 

@ Number/Factorial Data

.balign 4
numInputPrompt: .asciz "Input an integer from 1-12: \n"

.balign 4
outputPrompt: .asciz "Factorial of %d: %d \n"

.balign 4
numInputPattern: .asciz "%d"

@ Misc Data

.balign 4
intInput: .word 0   @ Location for storing user input

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input.

.balign 4
strInputError: .skip 100*4  @ Clear input buffer for invalid input


@ Let the assembler know these are the C library functions. 

.global printf

.global scanf

@ The End
