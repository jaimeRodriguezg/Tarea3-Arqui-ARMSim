@@@ OPEN INPUT FILE, READ INTEGER FROM FILE, PRINT IT, CLOSE INPUT FILE
.equ SWI_Open, 0x66 @open a file
.equ SWI_Close,0x68 @close a file
.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
.equ SWI_PrStr, 0x69 @ Write a null-ending string
.equ SWI_PrInt,0x6b @ Write an Integer
.equ SWI_RdInt,0x6c @ Read an Integer from a file
.equ Stdout, 1 @ Set output target to be Stdout
.equ SWI_Exit, 0x11 @ Stop execution
	.global _start
	.text
_start:

@ se abre el archivo para leer
		ldr r0,=NombreArchivo @ ingresa el nombre del archivo
		mov r1,#0 			@ mode is input
		swi SWI_Open @ open file for input
		ldr r1,=InFileHandle @ load input file handle
		str r0,[r1] @ save the file handle

@ Se leen enteros hasta final del archivo por primera vez

WHILE:
		ldr r0,=InFileHandle @ load input file handle
		ldr r0,[r0]
		swi SWI_RdInt @ lee el entero y lo guarda en r0
		bcs EofReached @ verifica si es el final del archivo
		mov r1,r0 @ r1 toma el valor de r0
		mov r2,r1 @r2 toma el valor de r1
		bal WHILE @ keep reading till end of file
EofReached:
		mov r0, #Stdout                   @print an initial message
      	ldr r1, =mensaje       			@ carga direccion de memoria de mensaje
      	swi SWI_PrStr                    @  hace un print del mensaje
      	mov r6,r2                          @guardamos el valor de r2 en r6 para ocuparlo posteriormente
		mov r1,r2
		mov R0,							#Stdout @ target is Stdout
		swi SWI_PrInt					@hace un print de r0

@ == cerramos el archivo
ldr R0, =InFileHandle @ get address of file handle
ldr R0, [R0] @ get value at address
swi SWI_Close

@ se abre el archivo para leer nuevamente
		ldr r0,=NombreArchivo @ ingresa el nombre del archivo
		mov r1,#0 			@ mode is input
		swi SWI_Open @ open file for input
		ldr r1,=InFileHandle @ load input file handle
		str r0,[r1] @ save the file handle

@ Se leen enteros hasta final del archivo y para poder encontrar el valor recorriendo nuevamente el archivo
mov r4,#0 @establecemos un contador
mov r5,#0 @hacemos una regla para que no tome el primer valor en nuestras comparaciones
WHILE2:
		mov r2, r6 @guardamos el valor encontrado de r6 en r2, el numero que buscamos
		ldr r0,=InFileHandle @ load input file handle
		ldr r0,[r0]
		swi SWI_RdInt @ lee el entero y lo guarda en r0
		mov r1,r0 @ r1 toma el valor de r0
		mov r3,r1 @r2 toma el valor de r1
		add r4, r4,#1
		cmp r5,#0  @nos vamos a la funcion devuelvete, para que no tome encuenta el primer elemento
		beq devuelvete
		cmp r3,r2		@comprueba si el numero que buscamos es igual al numero que recorre en la lista
		beq exitoso		@ si lo encuentra se a la funcion exitoso
		cmp r4, r7		@ comprueba si estamos al final del archivo
		beq noexitoso	@si ya estamos al final y no encontro el numero, se va la  funcion no exitoso
		bal WHILE2 @ keep reading till end of file

devuelvete:
		add r5, r5, #1  @sumamos 1 a r5 para que no vuelva mas a esta funcion
		add r2, r2, #1  @sumamos a 
		mov r7,R0    @guarda el tamaño n en r7
		b WHILE2

exitoso:
		mov r0, #Stdout                   @print an initial message
      	ldr r1, =mensaje2       			@ carga direccion de memoria de mensaje
      	swi SWI_PrStr                    @  hace un print del mensaje
      	sub r4, r4, #2
		mov r1,r4
		mov R0,							#Stdout @ target is Stdout
		swi SWI_PrInt					@hace un print de r0
		b salir		


noexitoso:
		mov r0, #Stdout                   @print an initial message
      	ldr r1, =mensaje1       			@ carga direccion de memoria de mensaje
      	swi SWI_PrStr                    @  hace un print del mensaje


salir:
.data
.align
InFileHandle: .skip 4
NombreArchivo: .asciz "input2.txt"
mensaje: .asciz "El numero a buscar es "
mensaje1: .asciz "\nNo se encontro el k en alguna posicion "
mensaje2: .asciz "\nel k se encontro en la posicion "
.end
