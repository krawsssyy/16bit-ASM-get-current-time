assume cs:code, ds:data

data segment
	amSir db ' AM', '$'
	pmSir db ' PM', '$'
	separator db ':'
	getTimeError db 'Eroare la obtinerea orei curente sistem!', '$'
	printError db 'Eroare la afisarea orei curente sistem!', '$'
	timeFlag db 0
data ends

code segment
	showDigits PROC
		push ax ; salvam ce avem in ax pana atunci
		mov ax, 0  ; il facem pe ax 0
		mov al, dl ; cand apelam procedura vom pregati in dl valoarea numarului de 2 cifre de afisat
		mov bl, 10
		div bl ; al = ax / 10, ah = ax mod 10
		add al, 30h ; transformarea in caracterul aferent cifrei
		add ah, 30h ; -//-
		mov bx, ax ; salvam rezultatul in bx
		mov ah, 02h ; ne pregatim sa afisam
		mov dl, bl
		int 21h ; afisam 
		mov dl, bh
		int 21h
		pop ax ; obtinem inapoi valoarea lui ax
		ret
	showDigits ENDP
	start:
		mov ax, data
		mov ds, ax

		mov ah, 2Ch
		int 21h ; obtinem ora sistem, in ch = ora, cl=minutele

		mov dl, ch
		call showDigits ; mutam ora in dl si apelam procedura

		mov ah, 02h
		mov dl, separator
		int 21h ; afisam separatorul

		mov dl, cl ; mutam minutele in dl si apelam procedura
		call showDigits

		cmp ch, 12 ; verificam daca ora e antimeridian/postmeridian
		JGE PM
		mov dx, offset amSir
		mov ah, 09h
		int 21h ; afisam terminatia AM
		jmp endProg

		PM:
			mov dx, offset pmSir
			mov ah, 09h
			int 21h ; afisam terminatia PM
		endProg:
			mov ax, 4C00h
			int 21h
code ends
	end start
