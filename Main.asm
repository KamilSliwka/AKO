; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (razem z polskimi)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main
.data
tekst_pocz db 10, 'Prosz',0A9H,' napisa',86H ,' jaki',98H,' tekst '
db 'i nacisn',0A5H,86H ,' Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
.code
_main PROC
; wy�wietlenie tekstu informacyjnego
; liczba znak�w tekstu
 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz ; adres tekstu
 push 1 ; nr urz�dzenia (tu: ekran - nr 1)
 call __write ; wy�wietlenie tekstu pocz�tkowego
 add esp, 12 ; usuniecie parametr�w ze stosu
; czytanie wiersza z klawiatury
 push 80 ; maksymalna liczba znak�w
 push OFFSET magazyn
 push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
 call __read ; czytanie znak�w z klawiatury
 add esp, 12 ; usuniecie parametr�w ze stosu
; kody ASCII napisanego tekstu zosta�y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczb�
; wprowadzonych znak�w
 mov liczba_znakow, eax
; rejestr ECX pe�ni rol� licznika obieg�w p�tli
 mov ecx, eax
 mov ebx, 0 ; indeks pocz�tkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
 cmp dl, 'a'
 jb dalej ; skok, gdy znak nie wymaga zamiany
 cmp dl, 'z'
 ja dalej ; skok, gdy znak nie wymaga zamiany
 sub dl, 20H ; zamiana na wielkie litery
; odes�anie znaku do pami�ci
 mov magazyn[ebx], dl
dalej: 
cmp dl, 86H;�
jnz con1
mov dl,8FH
jmp next
con1:
cmp dl, 0A5H;�
jnz con2
mov dl,0A4H
jmp next
con2:
cmp dl, 0A9H;�
jnz con3
mov dl,0A8H
jmp next
con3:
cmp dl, 88H;�
jnz con4
mov dl,9DH
jmp next
con4:
cmp dl, 0E4H;�
jnz con5
mov dl,0E3H
jmp next
con5:
cmp dl, 0A2H;�
jnz con6
mov dl,0E0H
jmp next
con6:
cmp dl, 98H;�
jnz con7
mov dl,97H
jmp next
con7:
cmp dl, 0ABH;�
jnz con8
mov dl,8DH
jmp next
con8:
cmp dl,0BEH;�
jnz con9
mov dl,0BDH
next:
mov magazyn[ebx], dl
con9:
inc ebx ; inkrementacja indeksu
dec eax 
jnz ptl ; sterowanie p�tl�
; wy�wietlenie przekszta�conego tekstu
 push liczba_znakow
 push OFFSET magazyn
 push 1
 call __write ; wy�wietlenie przekszta�conego tekstu
 add esp, 12 ; usuniecie parametr�w ze stosu
 push 0
 call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END
