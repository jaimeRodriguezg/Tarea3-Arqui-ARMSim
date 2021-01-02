.equ SWI_Open, 0x66 @open a file
.equ SWI_Close,0x68 @close a file
.equ SWI_RdInt,0x6c @ Read an Integer from a file
.equ SWI_PrInt,0x6b @ Write an Integer
.equ Stdout, 1 @ Set output mode to be Output View
.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
.equ SWI_PrStr, 0x69 @ Write a null-ending string

.text
.global main

_start:
      ldr r0, =NombreArchivo      @ set Name for input file
      mov r1, #0               @ mode is input
      swi SWI_Open             @ open file for input
      ldr r1, =InFileHandle    @ if OK, load input file handle
      str r0, [r1]             @ save the file handle
      ldr r0, =InFileHandle    @ load input file handle
      ldr r0, [r0]
      swi SWI_RdInt            @ Lee entero desde el archio y lo deja en r0.
      mov r4,r0                @mueve el entero leido y lo deja en r4.
      ldr r0, =InFileHandle @get address of file handle
      ldr r0, [r0] @get value at address
      swi SWI_Close @close file


main:
      ldr r0, =tam  @se obtiene el tamaño del arreglo
      ldr r1, [r0]  @guarda el tamaño en r1
      ldr r2, =fact1 @guarda la direccion de memoria del arreglo 1 (fact1) en r2
      ldr r3, =fact2 @guarda la direccion de memoria del arreglo 2 (fact2) en r3


@ hacemos un ciclo para ver si el numero ingresado es factorial de un numero
while:
      cmp r1, #0
      beq f1
      ldr r5, [r2], #4  @guarda el valor del numero del arreglo 1 en r5
      ldr r6, [r3], #4   @guarda el valor del numero del arreglo 2 en r6
      cmp r4, r5        @compara el dato ingresado con el archivo con el valor de r5
      beq f2          @en caso que sean iguales, se va a f2
      sub r1,r1, #1
      b while


@funcion que entrega un mensaje de que el numero no fue encontrado y se va a salir
f1:
      mov r0, #Stdout                   @print an initial message
      ldr r1, =mensaje1       @ load address of Message1 label
      swi SWI_PrStr                    @ display message to Stdout
      b salir

@ funcion que guarda el valor del numero que genera el factorial y lo imprime por pantalla
f2:
      mov r0, #Stdout                   @print an initial message
      ldr r1, =mensaje2       @ load address of Message1 label
      swi SWI_PrStr                    @ display message to Stdout
      mov r1, r6 @ integer to print
      swi SWI_PrInt
      b salir



@ejecuta la salida del programa
salir:



.data
dato: .word 1
tam: .word 6
fact1: .word 1, 2, 6, 24, 120
fact2: .word 1, 2, 3, 4, 5
res: .word 0
.align
InFileHandle: .skip 4
NombreArchivo: .asciz "input.txt"
mensaje1: .asciz "El numero no es factorial de ningun número enterno dentro del rango dado \n"
mensaje2: .asciz "El numero es factorial de "
.end
