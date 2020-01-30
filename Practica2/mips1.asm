.text 0
main:
  # carga num0 a num5 en los registros 9 a 14
  lw $t1, 0($zero) # lw $r9, 0($r0)
  lw $t2, 4($zero) # lw $r10, 4($r0)
  lw $t3, 8($zero) # lw $r11, 8($r0)
  lw $t4, 12($zero) # lw $r12, 12($r0)
  lw $t5, 16($zero) # lw $r13, 16($r0)
  lw $t6, 20($zero) # lw $r14, 20($r0)
  nop
  nop
  nop
  nop
  add $t3, $t1, $t2 # en r11 un 3 = 1 + 2
  beq $t3, $t1, etiqueta
  nop
  nop
  nop
  add $t5, $t1, $t2 # en r13 un 3 = 1 + 2
  beq $t3, $t5, etiqueta2
etiqueta:
  add $t6, $t1, $t2 # en r14 un 3 = 1 + 2
etiqueta2:
  add $t6, $t1, $t2 # en r14 un 3 = 1 + 2
  nop 
  nop
  nop
  nop
  lw $t3, 20($zero)
  beq $t3, $t1, etiqueta3
  nop
  nop
  nop
  nop
  lw $t5, 20($zero)
  beq $t3, $t5, etiqueta4
etiqueta3:
  add $t6, $t4, $t5 # en r14 un 3 = 1 + 2
etiqueta4:
  add $t6, $t3, $t4 # en r14 un 3 = 1 + 2