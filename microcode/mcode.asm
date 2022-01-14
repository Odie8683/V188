%include "mcode.inc"

; %define SHOW_8086

; Прерывания, не перемещать!
	JMP trap_z
	JMP trap_d
	JMP nmi
	JMP int3
	JMP trap_o
	JMP trap_b
	JMP trap_i
	JMP int7
	JMP irq0
	JMP irq1
	JMP irq2
	JMP irq3
	JMP irq4
	JMP irq5
	JMP irq6
	JMP irq7

trap_z:
	IMM 0
	JMP interrupt
trap_d:
	IMM 1
	JMP interrupt
nmi:
	IMM 2
	JMP interrupt
int3:
	IMM 3
	JMP interrupt
trap_o:
	IMM 4
	JMP interrupt
trap_b:
	IMM 5
	JMP interrupt
trap_i:
	IMM 6
	JMP interrupt
int7:
	IMM 7
	JMP interrupt
irq0:
	IMM 8
	JMP interrupt
irq1:
	IMM 9
	JMP interrupt
irq2:
	IMM 10
	JMP interrupt
irq3:
	IMM 11
	JMP interrupt
irq4:
	IMM 12
	JMP interrupt
irq5:
	IMM 13
	JMP interrupt
irq6:
	IMM 14
	JMP interrupt
irq7:
	IMM 15
	JMP interrupt

; Начало микрокода
	; add
	ALU 00, 01, 02, 03, 04, 05, 0, 1, ALL, 0
	; or
	ALU 08, 09, 0A, 0B, 0C, 0D, 5, 1, NOA, 0
	; adc
	ALU 10, 11, 12, 13, 14, 15, 0, 1, ALL, 1
	; sbb
	ALU 18, 19, 1A, 1B, 1C, 1D, 2, 1, ALL, 1
	; and
	ALU 20, 21, 22, 23, 24, 25, 4, 1, NOA, 0
	; sub
	ALU 28, 29, 2A, 2B, 2C, 2D, 2, 1, ALL, 0
	; xor
	ALU 30, 31, 32, 33, 34, 35, 6, 1, NOA, 0
	; cmp
	ALU 38, 39, 3A, 3B, 3C, 3D, 2, 0, ALL, 0

i_06:
	; push es
	LOADREG ES
	PUSH
	END

i_07:
	; pop es
	POP
	STOREREG ES
	END

i_0E:
	; push cs
	LOADREG CS
	PUSH
	END

i_0F:
	; 286+
	JMP undefined

i_16:
	; push ss
	LOADREG SS
	PUSH
	END

i_17:
	; pop ss
	POP
	STOREREG SS
	END

i_1E:
	; push ds
	LOADREG DS
	PUSH
	END

i_1F:
	; pop ds
	POP
	STOREREG DS
	END

i_26:
	; es:
	LOADREG ES
	OVERRIDESEG
	ENDPREFIX

i_27:
	; daa
	LOADREG8 AL
	IMM 0x0F
	AND
	IMM 9
	SUB
	IMM 0x80
	AND
	JNZ i_27_1
	TESTFLAGS F_A
	JNZ i_27_1
	JMP i_27_2
i_27_1:
	IMM 6
	LOADREG8 AL
	ADD8
	STOREREG8 AL
	ALUFLAGS F_C
	ADDFLAGS F_A
i_27_2:
	LOADREG8 AL
	IMM 0x9F
	SUB
	IMM 0x80
	AND
	JNZ i_27_3
	TESTFLAGS F_C
	JNZ i_27_3
	JMP i_27_4
i_27_3:
	IMM 0x60
	LOADREG8 AL
	ADD8
	STOREREG8 AL
	ADDFLAGS F_C
i_27_4:
	LOADREG8 AL
	IMM 0
	OR
	ALUFLAGS PSZ
	END

i_2E:
	; cs:
	LOADREG CS
	OVERRIDESEG
	ENDPREFIX

i_2F:
	; das
	LOADREG8 AL
	IMM 0x0F
	AND
	IMM 9
	SUB
	IMM 0x80
	AND
	JZ i_2F_1
	TESTFLAGS F_A
	JNZ i_2F_1
	REMOVEFLAGS F_A
	JMP i_2F_2
i_2F_1:
	IMM 6
	LOADREG8 AL
	SUB
	STOREREG8 AL
	ADDFLAGS F_A
i_2F_2:
	LOADREG8 AL
	IMM 0x9F
	AND
	IMM 9
	SUB
	IMM 0x80
	AND
	JZ i_2F_3
	TESTFLAGS F_C
	JNZ i_2F_3
	REMOVEFLAGS F_C
	JMP i_2F_4
i_2F_3:
	IMM 0x60
	LOADREG8 AL
	SUB
	STOREREG8 AL
	ADDFLAGS F_C
i_2F_4:
	LOADREG8 AL
	IMM 0
	OR
	ALUFLAGS PSZ
	END

i_36:
	; ss:
	LOADREG SS
	OVERRIDESEG
	ENDPREFIX

i_37:
	; aaa
	END

i_3E:
	; ds:
	LOADREG DS
	OVERRIDESEG
	ENDPREFIX

i_3F:
	; aas
	END

i_40:
	INCREG AX
i_41:
	INCREG CX
i_42:
	INCREG DX
i_43:
	INCREG BX
i_44:
	INCREG SP
i_45:
	INCREG BP
i_46:
	INCREG SI
i_47:
	INCREG DI
i_48:
	DECREG AX
i_49:
	DECREG CX
i_4A:
	DECREG DX
i_4B:
	DECREG BX
i_4C:
	DECREG SP
i_4D:
	DECREG BP
i_4E:
	DECREG SI
i_4F:
	DECREG DI

i_50:
	LOADREG AX
	PUSH
	END
i_51:
	LOADREG CX
	PUSH
	END
i_52:
	LOADREG DX
	PUSH
	END
i_53:
	LOADREG BX
	PUSH
	END
i_54:
	IMM 2
	LOADREG SP
; Ошибка в микрокоде 8086
;%ifdef SHOW_8086
	SUB
;%endif
	PUSH
	END
i_55:
	LOADREG BP
	PUSH
	END
i_56:
	LOADREG SI
	PUSH
	END
i_57:
	LOADREG DI
	PUSH
	END
i_58:
	POP
	STOREREG AX
	END
i_59:
	POP
	STOREREG CX
	END
i_5A:
	POP
	STOREREG DX
	END
i_5B:
	POP
	STOREREG BX
	END
i_5C:
	POP
	STOREREG SP
	END
i_5D:
	POP
	STOREREG BP
	END
i_5E:
	POP
	STOREREG SI
	END
i_5F:
	POP
	STOREREG DI
	END

i_60:
	; pusha (186+)
	LOADREG SP
	LOADREG AX
	PUSH
	LOADREG CX
	PUSH
	LOADREG DX
	PUSH
	LOADREG BX
	PUSH
	PUSH
	LOADREG BP
	PUSH
	LOADREG SI
	PUSH
	LOADREG DI
	PUSH
	END

i_61:
	; popa (186+)
	POP
	STOREREG DI
	POP
	STOREREG SI
	POP
	STOREREG BP
	POP
	POP
	STOREREG BX
	POP
	STOREREG DX
	POP
	STOREREG CX
	POP
	STOREREG AX
	END

i_62:
	; bound
	JMP undefined
	MODRM
	END

i_63:
	; arpl
	JMP undefined
	MODRM
	END

i_64:
	JMP undefined

i_65:
	JMP undefined

i_66:
	JMP undefined

i_67:
	JMP undefined

i_68:
	; push i16 (186+)
	FETCH16
	PUSH
	END

i_69:
	; imul reg, i16 186+
	MODRM
	LOAD_E16
	FETCH16
i_69_start:
	IMUL
	DUP
	STORE_E16
	STOREREG FS ; AX
	STOREREG GS ; DX
	REMOVEFLAGS F_Z|F_C|F_O
	LOADREG FS
	LOADREG GS
	OR
	JNZ i_69_axnotzero
	ADDFLAGS F_Z
i_69_axnotzero:
	LOADREG GS
	JZ i_69_dx_zero
	LOADREG GS
	IMM 0xFFFF
	XOR
	JZ i_69_dx_FFFF
	ADDFLAGS F_C|F_O
	END
i_69_dx_zero:
	LOADREG FS
	IMM 0x8000
	AND
	JZ done
	ADDFLAGS F_C|F_O
	END
i_69_dx_FFFF:
	LOADREG FS
	IMM 0x8000
	AND
	JNZ done
	ADDFLAGS F_C|F_O
	END

i_6A:
	; push i8 (186+)
	FETCH8S
	PUSH
	END

i_6B:
	; imul reg, i8 186+
	MODRM
	LOAD_E16
	FETCH8S
	JMP i_69_start

i_6C:
	JMP undefined

i_6D:
	JMP undefined

i_6E:
	LOADREG DX
	SETIOPORT
	JREP i_6E_rep
	; outsb
	LOADREG SI
	SETOFS
	READ8
	WRITEIO8
	ADV_SI
	END
	; rep outsb
i_6E_rep:
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	LOADREG SI
	SETOFS
	READ8
	WRITEIO8
	ADV_SI
	JMP i_6E_rep

i_6F:
	LOADREG DX
	SETIOPORT
	JREP i_6F_rep
	; outsw
	LOADREG SI
	SETOFS
	READ8
	WRITEIO8
	ADV_SI
	LOADREG SI
	SETOFS
	READ8
	WRITEIO8
	ADV_SI
	END
	; rep outsw
i_6F_rep:
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	LOADREG SI
	SETOFS
	READ8
	WRITEIO8
	ADV_SI
	LOADREG SI
	SETOFS
	READ8
	WRITEIO8
	ADV_SI
	JMP i_6F_rep

i_70:
	; jo
	JCOND F_O
i_71:
	; jno
	JNCOND F_O
i_72:
	; jc
	JCOND F_C
i_73:
	; jnc
	JNCOND F_C
i_74:
	; jz
	JCOND F_Z
i_75:
	; jnz
	JNCOND F_Z
i_76:
	; jbe
	JCOND (F_Z|F_C)
i_77:
	; ja
	JNCOND (F_Z|F_C)
i_78:
	; js
	JCOND F_S
i_79:
	; jns
	JNCOND F_S
i_7A:
	; jp
	JCOND F_P
i_7B:
	; jnp
	JNCOND F_P

i_7C:
	; jl
	FETCH8
	SIGNEXT
	TESTFLAGS F_S
	JZ i_7C_noS
	TESTFLAGS F_O
	JZ i_7C_go
	END
i_7C_noS:
	TESTFLAGS F_O
	JNZ i_7C_go
	END
i_7C_go:
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_7D:
	; jge
	FETCH8
	SIGNEXT
	TESTFLAGS F_S
	JZ i_7D_noS
	TESTFLAGS F_O
	JNZ i_7D_go
	END
i_7D_noS:
	TESTFLAGS F_O
	JZ i_7D_go
	END
i_7D_go:
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_7E:
	; jle
	FETCH8
	SIGNEXT
	TESTFLAGS F_Z
	JNZ i_7E_go
	TESTFLAGS F_S
	JZ i_7E_noS
	TESTFLAGS F_O
	JZ i_7E_go
	END
i_7E_noS:
	TESTFLAGS F_O
	JNZ i_7E_go
	END
i_7E_go:
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_7F:
	; jg
	FETCH8
	SIGNEXT
	TESTFLAGS F_Z
	JNZ done
	TESTFLAGS F_S
	JZ i_7F_noS
	TESTFLAGS F_O
	JNZ i_7F_go
	END
i_7F_noS:
	TESTFLAGS F_O
	JZ i_7F_go
	END
i_7F_go:
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_80:
	MODRM
	FETCH8
	LOAD_E8
	JMPTABLE
	JMP i_80_0
	JMP i_80_1
	JMP i_80_2
	JMP i_80_3
	JMP i_80_4
	JMP i_80_5
	JMP i_80_6
	JMP i_80_7
i_80_0:
	; add eb, ib
	ADD8
	STORE_E8
	ALUFLAGS ALL
	END
i_80_1:
	OR8
	STORE_E8
	ALUFLAGS NOA
	END
i_80_2:
	STOREREG FS
	LOADREG FLAGS
	IMM 1
	AND
	ADD8
	LOADREG FS
	ADD8
	STORE_E8
	ALUFLAGS ALL
	END
i_80_3:
	STOREREG FS
	LOADREG FLAGS
	IMM 1
	AND
	ADD8
	LOADREG FS
	SUB8
	STORE_E8
	ALUFLAGS ALL
	END
i_80_4:
	AND8
	STORE_E8
	ALUFLAGS NOA
	END
i_80_5:
	SUB8
	STORE_E8
	ALUFLAGS ALL
	END
i_80_6:
	XOR8
	STORE_E8
	ALUFLAGS NOA
	END
i_80_7:
	; cmp eb, ib
	SUB8
	ALUFLAGS ALL
	END

i_81:
	MODRM
	FETCH16
i_81_start:
	LOAD_E16
	JMPTABLE
	JMP i_81_0
	JMP i_81_1
	JMP i_81_2
	JMP i_81_3
	JMP i_81_4
	JMP i_81_5
	JMP i_81_6
	JMP i_81_7
i_81_0:
	; add ew, iw
	ADD
	STORE_E16
	ALUFLAGS ALL
	END
i_81_1:
	OR
	STORE_E16
	ALUFLAGS NOA
	END
i_81_2:
	STOREREG FS
	LOADREG FLAGS
	IMM 1
	AND
	ADD
	LOADREG FS
	ADD
	STORE_E16
	ALUFLAGS ALL
	END
i_81_3:
	STOREREG FS
	LOADREG FLAGS
	IMM 1
	AND
	ADD
	LOADREG FS
	SUB
	STORE_E16
	ALUFLAGS ALL
	END
i_81_4:
	AND
	STORE_E16
	ALUFLAGS NOA
	END
i_81_5:
	SUB
	STORE_E16
	ALUFLAGS ALL
	END
i_81_6:
	XOR
	STORE_E16
	ALUFLAGS NOA
	END
i_81_7:
	; cmp ew, iw
	SUB
	ALUFLAGS ALL
	END

i_82:
	JMP i_80

i_83:
	MODRM
	FETCH8
	SIGNEXT
	JMP i_81_start

i_84:
	; test gb, eb
	MODRM
	LOAD_E8
	LOAD_G8
	AND8
	ALUFLAGS NOA
	END

i_85:
	; test gw, ew
	MODRM
	LOAD_E16
	LOAD_G16
	AND
	ALUFLAGS NOA
	END

i_86:
	; xchg eb, gb
	MODRM
	LOAD_G8
	LOAD_E8
	STORE_G8
	STORE_E8
	END

i_87:
	; xchg ew, gw
	MODRM
	LOAD_G16
	LOAD_E16
	STORE_G16
	STORE_E16
	END

i_88:
	MODRM
	LOAD_G8
	STORE_E8
	END

i_89:
	MODRM
	LOAD_G16
	STORE_E16
	END

i_8A:
	MODRM
	LOAD_E8
	STORE_G8
	END

i_8B:
	MODRM
	LOAD_E16
	STORE_G16
	END

i_8C:
	MODRM
	LOAD_SREG
	STORE_E16
	END

i_8D:
	; lea
	MODRM
	GETOFS
	STORE_G16
	END

i_8E:
	MODRM
	LOAD_E16
	STORE_SREG
	END

i_8F:
	MODRM
	POP
	STORE_E16
	END

i_90:
	END
i_91:
	XCHGREG CX
i_92:
	XCHGREG DX
i_93:
	XCHGREG BX
i_94:
	XCHGREG SP
i_95:
	XCHGREG BP
i_96:
	XCHGREG SI
i_97:
	XCHGREG DI

i_98:
	; cbw
	LOADREG8 AL
	SIGNEXT
	STOREREG AX
	END

i_99:
	; cwd
	LOADREG AX
	IMM 0x8000
	AND
	JZ i_99_zero
	IMM 0xFFFF
	STOREREG DX
	END
i_99_zero:
	IMM 0
	STOREREG DX
	END

i_9A:
	; call far
	FETCH16
	FETCH16
	LOADREG CS
	PUSH
	LOADREG IP
	PUSH
	STOREREG CS
	STOREREG IP
	END

i_9B:
	END

i_9C:
	; pushf
	LOADREG FLAGS
	IMM 0xFD5
	AND
%ifdef SHOW_8086
	IMM 0xF002
%else
	IMM 0x0002
%endif
	OR
	PUSH
	END

i_9D:
	; popf
	POP
	IMM 0xFD5
	AND
%ifdef SHOW_8086
	IMM 0xF002
%else
	IMM 0x0002
%endif
	OR
	STOREREG FLAGS
	END

i_9E:
	; sahf
	LOADREG FLAGS
	IMM 0xFF02
	AND
	LOADREG8 AH
	OR
	IMM 0xFD5
	AND
%ifdef SHOW_8086
	IMM 0xF002
%else
	IMM 0x0002
%endif
	OR
	STOREREG FLAGS
	END

i_9F:
	; lahf
	LOADREG FLAGS
	STOREREG8 AH
	END

i_A0:
	; mov al, [ds:ofs16]
	FETCH16
	SETOFS
	READ8
	STOREREG8 AL
	END

i_A1:
	; mov ax, [ds:ofs16]
	FETCH16
	SETOFS
	READ16
	STOREREG AX
	END

i_A2:
	; mov [ds:ofs16], al
	FETCH16
	SETOFS
	LOADREG8 AL
	WRITE8
	END

i_A3:
	; mov [ds:ofs16], ax
	FETCH16
	SETOFS
	LOADREG AX
	WRITE16
	END

i_A4:
	JREP i_A4_rep
	; movsb
	LOADREG SI
	SETOFS
	READ8
	SAVESEG_ESDI
	WRITE8
	ADV_SIDI
	END
	; rep movsb
i_A4_rep:
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [es:di] <= [ds:si]
	LOADREG SI
	SETOFS
	READ8

	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS

	WRITE8
	RESTSEG
	ADV_SIDI
	JMP i_A4_rep

i_A5:
	JREP i_A5_rep
	; movsw
	LOADREG SI
	SETOFS
	READ16
	LOADREG ES
	SETSEG
	LOADREG DI
	SETOFS
	WRITE16
	ADV_SIDI
	ADV_SIDI
	END
	; rep movsw
i_A5_rep:
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [es:di] <= [ds:si]
	LOADREG SI
	SETOFS
	READ16
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	WRITE16
	RESTSEG
	ADV_SIDI
	ADV_SIDI
	JMP i_A5_rep

i_A6:
	JREPZ i_A6_repz
	JREPNZ i_A6_repnz
	; cmpsb
	LOADREG SI
	SETOFS
	READ8
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ8
	RESTSEG
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	ADV_SIDI
	END
i_A6_repz:
	; repz cmpsb
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [ds:si] - [es:di]
	LOADREG SI
	SETOFS
	READ8
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ8
	RESTSEG
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	ADV_SIDI
	TESTFLAGS F_Z
	JNZ i_A6_repz
	END
i_A6_repnz:
	; repnz cmpsb
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [ds:si]- [es:di]
	LOADREG SI
	SETOFS
	READ8
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ8
	RESTSEG
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	ADV_SIDI
	TESTFLAGS F_Z
	JZ i_A6_repnz
	END

i_A7:
	JREPZ i_A7_repz
	JREPNZ i_A7_repnz
	; cmpsw
	LOADREG SI
	SETOFS
	READ16
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ16
	RESTSEG
	STACKSWAP
	SUB
	ALUFLAGS ALL
	ADV_SIDI
	ADV_SIDI
	END
i_A7_repz:
	; repz cmpsw
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [ds:si] - [es:di]
	LOADREG SI
	SETOFS
	READ16
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ16
	RESTSEG
	STACKSWAP
	SUB
	ALUFLAGS ALL
	ADV_SIDI
	ADV_SIDI
	TESTFLAGS F_Z
	JNZ i_A7_repz
	END
i_A7_repnz:
	; repnz cmpsb
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [ds:si]- [es:di]
	LOADREG SI
	SETOFS
	READ16
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ16
	RESTSEG
	STACKSWAP
	SUB
	ALUFLAGS ALL
	ADV_SIDI
	ADV_SIDI
	TESTFLAGS F_Z
	JZ i_A7_repnz
	END

i_A8:
	; test al, ib
	FETCH8
	LOADREG8 AL
	AND8
	ALUFLAGS NOA
	END

i_A9:
	; test ax, iw
	FETCH16
	LOADREG AX
	AND
	ALUFLAGS NOA
	END

i_AA:
	JREP i_AA_rep
	; stosb
	LOADREG ES
	SETSEG
	LOADREG DI
	SETOFS
	LOADREG8 AL
	WRITE8
	ADV_DI
	END
	; rep stosw
i_AA_rep:
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [es:di] <= ax
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	LOADREG8 AL
	WRITE8
	ADV_DI
	JMP i_AA_rep

i_AB:
	JREP i_AB_rep
	; stosw
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	LOADREG AX
	WRITE16
	ADV_DI
	ADV_DI
	END
	; rep stosw
i_AB_rep:
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; [es:di] <= ax
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	LOADREG AX
	WRITE16
	ADV_DI
	ADV_DI
	JMP i_AB_rep

i_AC:
	; lodsb
	LOADREG SI
	SETOFS
	READ8
	STOREREG8 AL
	ADV_SI
	END

i_AD:
	; lodsw
	LOADREG SI
	SETOFS
	READ16
	STOREREG AX
	ADV_SI
	ADV_SI
	END

i_AE:
	JREPZ i_AE_repz
	JREPNZ i_AE_repnz
	; scasb
	LOADREG8 AL
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ8
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	ADV_DI
	END
i_AE_repz:
	; repz scasb
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; al - [es:di]
	LOADREG8 AL
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ8
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	ADV_DI
	TESTFLAGS F_Z
	JNZ i_AE_repz
	END
i_AE_repnz:
	; repnz scasb
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; al - [es:di]
	LOADREG8 AL
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ8
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	ADV_DI
	TESTFLAGS F_Z
	JZ i_AE_repnz
	END

i_AF:
	JREPZ i_AF_repz
	JREPNZ i_AF_repnz
	; scasw
	LOADREG AX
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ16
	STACKSWAP
	SUB
	ALUFLAGS ALL
	ADV_DI
	ADV_DI
	END
i_AF_repz:
	; repz scasw
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; ax - [es:di]
	LOADREG AX
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ16
	STACKSWAP
	SUB
	ALUFLAGS ALL
	ADV_DI
	ADV_DI
	TESTFLAGS F_Z
	JNZ i_AF_repz
	END
i_AF_repnz:
	; repnz scasw
	; while (cx)
	LOADREG CX
	JZ done
	; cx--;
	DECCX
	; ax - [es:di]
	LOADREG AX
	SAVESEG_ESDI
	;SAVESEG
	;LOADREG ES
	;SETSEG
	;LOADREG DI
	; SETOFS
	READ16
	STACKSWAP
	SUB
	ALUFLAGS ALL
	ADV_DI
	ADV_DI
	TESTFLAGS F_Z
	JZ i_AF_repnz
	END

i_B0:
	; mov al, ib
	FETCH8
	STOREREG8 AL
	END

i_B1:
	; mov cl, ib
	FETCH8
	STOREREG8 CL
	END

i_B2:
	; mov dl, ib
	FETCH8
	STOREREG8 DL
	END

i_B3:
	; mov bl, ib
	FETCH8
	STOREREG8 BL
	END

i_B4:
	; mov ah, ib
	FETCH8
	STOREREG8 AH
	END

i_B5:
	; mov ch, ib
	FETCH8
	STOREREG8 CH
	END

i_B6:
	; mov dh, ib
	FETCH8
	STOREREG8 DH
	END

i_B7:
	; mov bh, ib
	FETCH8
	STOREREG8 BH
	END

i_B8:
	; mov ax, iw
	FETCH16
	STOREREG AX
	END

i_B9:
	; mov cx, iw
	FETCH16
	STOREREG CX
	END

i_BA:
	; mov dx, iw
	FETCH16
	STOREREG DX
	END

i_BB:
	; mov bx, iw
	FETCH16
	STOREREG BX
	END

i_BC:
	; mov sp, iw
	FETCH16
	STOREREG SP
	END

i_BD:
	; mov bp, iw
	FETCH16
	STOREREG BP
	END

i_BE:
	; mov si, iw
	FETCH16
	STOREREG SI
	END

i_BF:
	; mov di, iw
	FETCH16
	STOREREG DI
	END

i_C0:
	MODRM
	FETCH8
	STOREREG GS
	LOAD_E8
	STOREREG FS
	LOADREG GS
	JNZ i_D0_loop
	END

i_C1:
	MODRM
	FETCH8
	STOREREG GS
	LOAD_E16
	STOREREG FS
	LOADREG GS
	JNZ i_D1_loop
	END

i_C2:
	; ret iw
	FETCH16
	POP
	STOREREG IP
	LOADREG SP
	ADD
	STOREREG SP
	END

i_C3:
	; ret
	POP
	STOREREG IP
	END

i_C4:
	; les
	MODRM
	READ16
	GETOFS
	IMM 2
	ADD
	SETOFS
	READ16
	STOREREG ES
	STORE_G16
	END

i_C5:
	; lds
	MODRM
	READ16
	GETOFS
	IMM 2
	ADD
	SETOFS
	READ16
	STOREREG DS
	STORE_G16
	END

i_C6:
	; mov eb, ib
	MODRM
	FETCH8
	STORE_E8
	END

i_C7:
	; mov ew, iw
	MODRM
	FETCH16
	STORE_E16
	END

i_C8:
	; enter (186+)
	LOADREG AX
	FETCH16
	STOREREG FS	; fs = stack = fetch16()
	FETCH8
	IMM 0x1F
	AND
	STOREREG GS	; gs = nest = fetch() & 0x1F
	LOADREG BP
	PUSH		; push(bp)
	LOADREG SP
	STOREREG AX	; ax = frame = sp
	LOADREG GS	; if (nest)
	JZ i_C8_done_loop
i_C8_loop:
	IMM 1
	LOADREG GS
	SUB
	DUP
	STOREREG GS	; nest--;
	JZ i_C8_end_loop	; if (nest)
	IMM 2
	LOADREG BP
	SUB
	DUP
	STOREREG BP	; bp-=2
	PUSH		; push(bp)
	JMP i_C8_loop
i_C8_end_loop:
	LOADREG AX
	PUSH		; push (frame)
i_C8_done_loop:
	LOADREG AX
	STOREREG BP	; bp = frame
	LOADREG FS
	LOADREG SP
	SUB
	STOREREG SP	; sp -= stack
	STOREREG AX
	END

i_C9:
	; leave (186+)
	LOADREG BP
	STOREREG SP
	POP
	STOREREG BP
	END

i_CA:
	; retf iw
	FETCH16
	POP
	STOREREG IP
	POP
	STOREREG CS
	LOADREG SP
	ADD
	STOREREG SP
	END

i_CB:
	; retf
	POP
	STOREREG IP
	POP
	STOREREG CS
	END

i_CC:
	; int3
	IMM 3
	JMP interrupt

i_CD:
	; int n
	FETCH8
interrupt:
	SHL
	SHL
	SETOFS
	IMM 0
	SETSEG
	LOADREG FLAGS
	PUSH
	LOADREG CS
	PUSH
	LOADREG IP
	PUSH
	READ16
	STOREREG IP
	GETOFS
	IMM 2
	ADD
	SETOFS
	READ16
	STOREREG CS
	REMOVEFLAGS F_I
	END

i_CE:
	; into
	IMM 4
	TESTFLAGS F_O
	JNZ interrupt
	END

i_CF:
	; iret
	POP
	STOREREG IP
	POP
	STOREREG CS
	POP
	STOREREG FLAGS
	END

i_D0:
	IMM 1
i_D0_start:
	STOREREG GS
	MODRM
	LOAD_E8
	STOREREG FS
i_D0_loop:
	LOADREG FS
	JMPTABLE
	JMP i_D0_0
	JMP i_D0_1
	JMP i_D0_2
	JMP i_D0_3
	JMP i_D0_4
	JMP i_D0_5
	JMP i_D0_6
	JMP i_D0_7
i_D0_0:
	; rol eb, 1
	ROL8
	ALUFLAGS F_C|F_O
	JMP i_D0_next
i_D0_1:
	; ror eb, 1
	ROR8
	ALUFLAGS F_C|F_O
	JMP i_D0_next
i_D0_2:
	; rcl eb, 1
	RCL8
	ALUFLAGS F_C|F_O
	JMP i_D0_next
i_D0_3:
	; rcr eb, 1
	RCR8
	ALUFLAGS F_C|F_O
	JMP i_D0_next
i_D0_4:
	; shl eb, 1
	SHL8
	ALUFLAGS NOA
	JMP i_D0_next
i_D0_5:
	; shr eb, 1
	SHR8
	ALUFLAGS NOA
	JMP i_D0_next
i_D0_6:
	; sal eb, 1
	SHL8
	ALUFLAGS NOA
	JMP i_D0_next
i_D0_7:
	; sar eb, 1
	SAR8
	ALUFLAGS NOA
	JMP i_D0_next
i_D0_next:
	STOREREG FS
	IMM 1
	LOADREG GS
	SUB
	STOREREG GS
	LOADREG GS
	JNZ i_D0_loop
	LOADREG FS
	STORE_E8
	END

i_D1:
	IMM 1
i_D1_start:
	STOREREG GS
	MODRM
	LOAD_E16
	STOREREG FS
i_D1_loop:
	LOADREG FS
	JMPTABLE
	JMP i_D1_0
	JMP i_D1_1
	JMP i_D1_2
	JMP i_D1_3
	JMP i_D1_4
	JMP i_D1_5
	JMP i_D1_6
	JMP i_D1_7
i_D1_0:
	; rol ew, 1
	ROL
	ALUFLAGS F_C|F_O
	JMP i_D1_next
i_D1_1:
	; ror ew, 1
	ROR
	ALUFLAGS F_C|F_O
	JMP i_D1_next
i_D1_2:
	; rcl ew, 1
	RCL
	ALUFLAGS F_C|F_O
	JMP i_D1_next
i_D1_3:
	; rcr ew, 1
	RCR
	ALUFLAGS F_C|F_O
	JMP i_D1_next
i_D1_4:
	; shl ew, 1
	SHL
	ALUFLAGS NOA
	JMP i_D1_next
i_D1_5:
	; shr ew, 1
	SHR
	ALUFLAGS NOA
	JMP i_D1_next
i_D1_6:
	; sal ew, 1
	SHL
	ALUFLAGS NOA
	JMP i_D1_next
i_D1_7:
	; sar ew, 1
	SAR
	ALUFLAGS NOA
	JMP i_D1_next
i_D1_next:
	STOREREG FS
	IMM 1
	LOADREG GS
	SUB
	STOREREG GS
	LOADREG GS
	JNZ i_D1_loop
	LOADREG FS
	STORE_E16
	END

i_D2:
	MODRM
	LOADREG8 CL
	STOREREG GS
	LOAD_E8
	STOREREG FS
	LOADREG GS
	JNZ i_D0_loop
	END

i_D3:
	MODRM
	LOADREG8 CL
	STOREREG GS
	LOAD_E16
	STOREREG FS
	LOADREG GS
	JNZ i_D1_loop
	END

i_D4:
	; aam
	FETCH8
	IMM 0
	LOADREG8 AL
	DIV
	STOREREG8 AH
	STOREREG8 AL
	LOADREG8 AL
	IMM 0
	OR8
	ALUFLAGS PSZ
	END

i_D5:
	FETCH8
	END

i_D6:
	; salc
	IMM 0
	STOREREG8 AL
	LOADREG FLAGS
	IMM F_C
	JZ done
	IMM 0xFF
	STOREREG8 AL
	END

i_D7:
	; xlat
	LOADREG BX
	LOADREG8 AL
	ADD
	SETOFS
	READ8
	STOREREG8 AL
	END

i_D8:
	MODRM
	END

i_D9:
	MODRM
	END

i_DA:
	MODRM
	END

i_DB:
	MODRM
	END

i_DC:
	MODRM
	END

i_DD:
	MODRM
	END

i_DE:
	MODRM
	END

i_DF:
	MODRM
	END

i_E0:
	; loopnz s8
	FETCH8S
	DECCX
	LOADREG CX
	JZ done
	TESTFLAGS F_Z
	JNZ done
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_E1:
	; loopz s8
	FETCH8S
	DECCX
	LOADREG CX
	JZ done
	TESTFLAGS F_Z
	JZ done
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_E2:
	; loop
	FETCH8S
	DECCX
	LOADREG CX
	JZ done
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_E3:
	; jcxz
	FETCH8S
	LOADREG CX
	JNZ done
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_E4:
	; in al, port
	FETCH8
	SETIOPORT
	READIO8
	STOREREG8 AL
	END

i_E5:
	; in ax, port
	FETCH8
	DUP
	SETIOPORT
	IMM 1
	ADD
	STACKSWAP
	READIO8
	STOREREG8 AL
	SETIOPORT
	READIO8
	STOREREG8 AH
	END

i_E6:
	; out port, al
	FETCH8
	SETIOPORT
	LOADREG8 AL
	WRITEIO8
	END

i_E7:
	; out port, ax
	FETCH8
	DUP
	SETIOPORT
	IMM 1
	ADD
	STACKSWAP
	LOADREG8 AL
	WRITEIO8
	SETIOPORT
	LOADREG8 AH
	WRITEIO8
	END

i_E8:
	; call s16
	FETCH16
	LOADREG IP
	PUSH
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_E9:
	; jmp s16
	FETCH16
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_EA:
	; jmp far
	FETCH16
	FETCH16
	STOREREG CS
	STOREREG IP
	END

i_EB:
	; jmp s8
	FETCH8S
	ADD_IP
	; LOADREG IP
	; ADD
	; STOREREG IP
	END

i_EC:
	; in al, dx
	LOADREG DX
	SETIOPORT
	READIO8
	STOREREG8 AL
	END

i_ED:
	; in ax, dx
	LOADREG DX
	SETIOPORT
	READIO8
	STOREREG8 AL
	LOADREG DX
	IMM 1
	ADD
	SETIOPORT
	READIO8
	STOREREG8 AH
	END

i_EE:
	; out dx, al
	LOADREG DX
	SETIOPORT
	LOADREG8 AL
	WRITEIO8
	END

i_EF:
	; out dx, ax
	LOADREG DX
	SETIOPORT
	LOADREG8 AL
	WRITEIO8
	LOADREG DX
	IMM 1
	ADD
	SETIOPORT
	LOADREG8 AH
	WRITEIO8
	END

i_F0:
	; lock
	ENDPREFIX

i_F1:
	; int1 ?
	IMM 1
	JMP interrupt

i_F2:
	; repnz
	SETREPNZ
	ENDPREFIX

i_F3:
	; repz
	SETREPZ
	ENDPREFIX

i_F4:
	; hlt
	HLT
	END

i_F5:
	; cmc
	IMM F_C
	LOADREG FLAGS
	XOR
	STOREREG FLAGS
	END

i_F6:
	MODRM
	LOAD_E8
	JMPTABLE
	JMP i_F6_0
	JMP i_F6_1
	JMP i_F6_2
	JMP i_F6_3
	JMP i_F6_4
	JMP i_F6_5
	JMP i_F6_6
	JMP i_F6_7
i_F6_0:
	; test eb, ib
	FETCH8
	AND8
	ALUFLAGS NOA
	END

i_F6_1:
	; undefined
	JMP undefined

i_F6_2:
	; not eb
	IMM 0xFF
	XOR8
	STORE_E8
	END

i_F6_3:
	; neg eb
	IMM 0
	SUB8
	DUP
	STORE_E8
	REMOVEFLAGS F_C | F_O
	IMM 0xFF
	AND
	DUP
	JZ i_F6_3_skip
	ADDFLAGS F_C
i_F6_3_skip:
	IMM 0x80
	SUB
	JNZ done
	ADDFLAGS F_O
	END
i_F6_4:
	; mul eb
	LOADREG8 AL
	MUL
	STOREREG AX
	REMOVEFLAGS F_Z|F_C|F_O
	LOADREG AX
	JNZ i_F6_4_axnotzero
	ADDFLAGS F_Z
i_F6_4_axnotzero:
	LOADREG8 AH
	JZ done
	ADDFLAGS F_C|F_O
	END
i_F6_5:
	; imul eb
	SIGNEXT
	LOADREG8 AL
	SIGNEXT
	IMUL
	STOREREG AX
	REMOVEFLAGS F_Z|F_C|F_O
	LOADREG AX
	JNZ i_F6_5_axnotzero
	ADDFLAGS F_Z
i_F6_5_axnotzero:
	LOADREG AX
	IMM 0xFF80
	AND
	DUP
	JZ done
	IMM 0xFF80
	SUB
	JZ done
	ADDFLAGS F_C|F_O
	END
i_F6_6:
	; div eb
	IMM 0
	LOADREG AX
	DIV
	STOREREG8 AL
	STOREREG8 AH
	END
i_F6_7:
	; idiv eb
	SIGNEXT
	LOADREG AX
	IMM 0x8000
	AND
	JZ i_F6_7_1
	IMM 0xFFFF
	JMP i_F6_7_2
i_F6_7_1:
	IMM 0
i_F6_7_2:
	LOADREG AX
	IDIV
	STOREREG8 AL
	STOREREG8 AH
	END

i_F7:
	MODRM
	LOAD_E16
	JMPTABLE
	JMP i_F7_0
	JMP i_F7_1
	JMP i_F7_2
	JMP i_F7_3
	JMP i_F7_4
	JMP i_F7_5
	JMP i_F7_6
	JMP i_F7_7
i_F7_0:
	; test ew, iw
	FETCH16
	AND
	ALUFLAGS NOA
	END

i_F7_1:
	; undefined
	JMP undefined

i_F7_2:
	; not ew
	IMM 0xFFFF
	XOR
	STORE_E16
	END
i_F7_3:
	; neg ew
	IMM 0
	SUB
	DUP
	STORE_E16
	REMOVEFLAGS F_C | F_O
	DUP
	JZ i_F7_3_skip
	ADDFLAGS F_C
i_F7_3_skip:
	IMM 0x8000
	SUB
	JNZ done
	ADDFLAGS F_O
	END
i_F7_4:
	; mul ew
	LOADREG AX
	MUL
	STOREREG AX
	STOREREG DX
	REMOVEFLAGS F_Z|F_C|F_O
	LOADREG AX
	LOADREG DX
	OR
	JNZ i_F7_4_axnotzero
	ADDFLAGS F_Z
i_F7_4_axnotzero:
	LOADREG DX
	JZ done
	ADDFLAGS F_C|F_O
	END
i_F7_5:
	; imul ew
	LOADREG AX
	IMUL
	STOREREG AX
	STOREREG DX
	REMOVEFLAGS F_Z|F_C|F_O
	LOADREG AX
	LOADREG DX
	OR
	JNZ i_F7_5_axnotzero
	ADDFLAGS F_Z
i_F7_5_axnotzero:
	LOADREG DX
	JZ i_F7_5_dx_zero
	LOADREG DX
	IMM 0xFFFF
	XOR
	JZ i_F7_5_dx_FFFF
	ADDFLAGS F_C|F_O
	END
i_F7_5_dx_zero:
	LOADREG AX
	IMM 0x8000
	AND
	JZ done
	ADDFLAGS F_C|F_O
	END
i_F7_5_dx_FFFF:
	LOADREG AX
	IMM 0x8000
	AND
	JNZ done
	ADDFLAGS F_C|F_O
	END


i_F7_6:
	; div ew
	LOADREG DX
	LOADREG AX
	DIV
	STOREREG AX
	STOREREG DX
	END
i_F7_7:
	; idiv ew
	LOADREG DX
	LOADREG AX
	IDIV
	STOREREG AX
	STOREREG DX
	END

i_F8:
	; clc
	REMOVEFLAGS F_C
	END

i_F9:
	; stc
	ADDFLAGS F_C
	END

i_FA:
	; cli
	REMOVEFLAGS F_I
	END

i_FB:
	; sti
	ADDFLAGS F_I
	END

i_FC:
	; cld
	REMOVEFLAGS F_D
	END

i_FD:
	; std
	ADDFLAGS F_D
	END

i_FE:
	MODRM
	LOAD_E8
	JMPTABLE
	JMP i_FE_0
	JMP i_FE_1
	JMP i_FE_2
	JMP i_FE_3
	JMP i_FE_4
	JMP i_FE_5
	JMP i_FE_6
	JMP i_FE_7
i_FE_0:
	; inc eb
	IMM 1
	ADD8
	ALUFLAGS NOCARRY
	STORE_E8

;	REMOVEFLAGS NOCARRY
;	IMM 1
;	ADD8
;	ALUFLAGS PSZ
;	DUP
;	STORE_E8
;	DUP
;	IMM 0x80
;	SUB
;	JNZ inc_FE_skip1
;	ADDFLAGS F_O
;inc_FE_skip1:
;	IMM 0x0F
;	AND
;	JNZ inc_FE_skip2
;	ADDFLAGS F_A
;inc_FE_skip2:
	END

i_FE_1:
	; dec eb
	IMM 1
	STACKSWAP
	SUB8
	ALUFLAGS NOCARRY
	STORE_E8

;	REMOVEFLAGS NOCARRY
;	IMM 1
;	STACKSWAP
;	SUB8
;	ALUFLAGS PSZ
;	DUP
;	STORE_E8
;	DUP
;	IMM 0x7F
;	SUB
;	JNZ dec_FE_skip1
;	ADDFLAGS F_O
;dec_FE_skip1:
;	IMM 0x0F
;	AND
;	IMM 0x0F
;	SUB
;	JNZ dec_FE_skip2
;	ADDFLAGS F_A
;dec_FE_skip2:
	END

i_FE_2:
	; undefined
	JMP undefined
i_FE_3:
	; undefined
	JMP undefined
i_FE_4:
	; undefined
	JMP undefined
i_FE_5:
	; undefined
	JMP undefined
i_FE_6:
	; undefined
	JMP undefined
i_FE_7:
	; cmp eb, ib
	FETCH8
	STACKSWAP
	SUB8
	ALUFLAGS ALL
	END

i_FF:
	MODRM
	JMPTABLE
	JMP i_FF_0
	JMP i_FF_1
	JMP i_FF_2
	JMP i_FF_3
	JMP i_FF_4
	JMP i_FF_5
	JMP i_FF_6
	JMP i_FF_7
i_FF_0:
	; inc ew
	IMM 1
	LOAD_E16
	ADD
	ALUFLAGS NOCARRY
	STORE_E16

;	REMOVEFLAGS NOCARRY
;	IMM 1
;	LOAD_E16
;	ADD
;	ALUFLAGS PSZ
;	DUP
;	STORE_E16
;	DUP
;	IMM 0x8000
;	SUB
;	JNZ inc_FF_skip1
;	ADDFLAGS F_O
;inc_FF_skip1:
;	IMM 0x000F
;	AND
;	JNZ inc_FF_skip2
;	ADDFLAGS F_A
;inc_FF_skip2:
	END

i_FF_1:
	; dec ew
	IMM 1
	LOAD_E16
	SUB
	ALUFLAGS NOCARRY
	STORE_E16

;	REMOVEFLAGS NOCARRY
;	LOAD_E16
;	IMM 1
;	STACKSWAP
;	SUB
;	ALUFLAGS PSZ
;	DUP
;	STORE_E16
;	DUP
;	IMM 0x7FFF
;	SUB
;	JNZ dec_FF_skip1
;	ADDFLAGS F_O
;dec_FF_skip1:
;	IMM 0x0F
;	AND
;	IMM 0x0F
;	SUB
;	JNZ dec_FF_skip2
;	ADDFLAGS F_A
;dec_FF_skip2:
	END

i_FF_2:
	; call ew
	LOAD_E16
	LOADREG IP
	PUSH
	STOREREG IP
	END

i_FF_3:
	; call far ew
	LOADREG CS
	PUSH
	LOADREG IP
	PUSH
	READ16
	GETOFS
	IMM 2
	ADD
	SETOFS
	READ16
	STOREREG CS
	STOREREG IP
	END

i_FF_4:
	; jmp ew
	LOAD_E16
	STOREREG IP
	END

i_FF_5:
	; jmp far ew
	READ16
	GETOFS
	IMM 2
	ADD
	SETOFS
	READ16
	STOREREG CS
	STOREREG IP
	END

i_FF_6:
	; push ew
	LOAD_E16
	PUSH
	END

i_FF_7:
	; cmp ew, iw
	LOAD_E16
	FETCH16
	STACKSWAP
	SUB
	ALUFLAGS ALL
	END

done:
	END

undefined:
	LOADREG FS
	STOREREG AX
	JMP trap_i
