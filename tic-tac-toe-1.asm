; Tic-tac-toe               (tic-tac-toe.asm)
;Melanie Woe
; This program uses two-dimensional arrays to simulates the game of Tic-Tac-Toe.  
; The User will play against the computer (your assembly program) or the computer
; will play against itself.

INCLUDE Irvine32.inc

BoardDisplay PROTO
anyWin PROTO
anyWinO PROTO


.data
.code
main PROC
call mainMenu
;call resetTable

call waitmsg
	exit
main ENDP

mainMenu PROC USES EDX
.data
Prompt1 BYTE "----------------Welcome to the Tic Tac Toe game-----------------",0dh, 0ah
		BYTE "Please choose one of the option below: ", 0dh, 0ah
		BYTE "1. Player vs Computer", 0dh, 0ah
		BYTE "2. Computer vs Computer", 0
Prompt2 BYTE "Your Choice: ", 0
PromptChoose BYTE "Where do you want to move? (1,2,3,4,5,6,7,8,9)", 0
PromptTie BYTE "Tie game!", 0
userInput DWORD ?
randVal DWORD ?
player BYTE ?
computer BYTE ?
rowIndex DWORD ?
columnIndex DWORD ?
charNow DWORD ?
totalGame BYTE 0

.code
mov EDX, OFFSET Prompt1
call WriteString
call crlf
mov EDX, OFFSET Prompt2
call WriteString
call ReadInt
push EAX
INVOKE BoardDisplay
pop EAX
mov userInput, EAX
cmp userInput, 1
je pc

cc:											;computer vs compter
cmp userInput, 2
jne mainexit

cc2:
call RandomNum
call RandomPlacing
mov userInput, EAX							;mov the user input to UserInput
movzx EDX, BYTE PTR [Computer]
push EDX
;mov EDX, 1
call ValueChecker
pop EDX
call CharacterNow				
call InsertChar								; insert it to array
INVOKE BoardDisplay							;display the board
mov EAX, defaultColor
call settextcolor
INVOKE anyWin
INVOKE anyWinO
call RandomPlacing
movzx EDX, BYTE PTR [Computer]				;mov the char for computer to EDX
call CharacterNow
call InsertChar								;insert it to the array
INVOKE BoardDisplay
mov EAX, defaultColor
call settextcolor
INVOKE anyWin
INVOKE anyWinO


cmp totalGame, 8							;compare total game with 9
jl cc2										;if lower than 9 means not ended yet

mov EDX, OFFSET promptTie
call WriteString
call crlf
call EndGame
jmp mainext


pc:
call RandomNum								;player vs computer
;mov ECX, 15
pc2:
mov EDX, OFFSET PromptChoose				;display the promptChoose
call WriteString
call ReadInt								;read the user's input
mov userInput, EAX							;mov the user input to UserInput
movzx EDX, BYTE PTR [Player]
push EDX
mov EDX, 1
call ValueChecker
pop EDX
call CharacterNow				
call InsertChar								; insert it to array
INVOKE BoardDisplay							;display the board
mov EAX, defaultColor
call settextcolor
INVOKE anyWin
inc totalGame
call RandomPlacing
movzx EDX, BYTE PTR [Computer]				;mov the char for computer to EDX
call CharacterNow
call InsertChar								;insert it to the array
INVOKE BoardDisplay
mov EAX, defaultColor
call settextcolor
INVOKE anyWin
inc totalGame

cmp totalGame, 8							;compare total game with 9
jl pc2										;if lower than 9 means not ended yet

mov EDX, OFFSET promptTie
call WriteString
call crlf
call EndGame
jmp mainext

mainexit:
Exit

mainext:
ret
mainMenu ENDP

CharacterNow PROC
mov charNow,EDX
ret
CharacterNow ENDP

ValueChecker PROC
;------------------------------------------------------------------------------
; checks if the space is available or not
; receives: value chosen
; return : nothing
;------------------------------------------------------------------------------
.data
valueChosen DWORD 10 DUP (?)
promptV BYTE "Please enter an available square! New move: ", 0
.code
valueAgain:									;compare if the value is in the array
mov ESI, OFFSET valueChosen
mov ECX, LENGTHOF valueChosen				;num of loops
mov EAX, userInput

LCompare:
cmp EAX, [ESI]								;compare userInput and the array
je notEmpty									;if equal = space not available
add ESI, 4									;next element
loop LCompare

mov ESI, OFFSET valueChosen
addvalue:
;mov EAX, valueChosen[ESI]
cmp BYTE PTR[ESI], 0
je canadd
add ESI, 4
jmp addvalue

canadd:
mov EAX, UserInput
mov [ESI], EAX					;mov userinput to the array
mov EDX, 3
jmp good		

notEmpty:
cmp EDX, 1
je thisisplayer
mov EDX, 2
jmp good

thisisplayer:
mov EDX, OFFSET promptV
call WriteString
call ReadInt
mov userInput, EAX
mov EDX,1
jmp valueAgain

good:	
ret 
ValueChecker ENDP

RandomPlacing PROC
;------------------------------------------------------------------------------
; will generate random number to place the computers' move
; receives: nothing
; return : userInput (computer's move)
;------------------------------------------------------------------------------
mov UserInput, 5
jmp check
RandomAgain:
call Randomize								;init random generator
LRandom:
mov EAX, 9									;0-8
call RandomRange							;generate random number
add EAX, 1									;value 1-9	
mov UserInput,	EAX	
check:
call ValueChecker
cmp EDX, 2
je RandomAgain
ret
RandomPlacing ENDP

InsertChar PROC
;------------------------------------------------------------------------------
; will inser X or O on the user's choice of destination
; receives: user's input in EAX
; return : nothing 
;------------------------------------------------------------------------------
.data
defaultColor = lightGray + (black * 16)
.code
dec UserInput								;decrement the user input by one
cmp UserInput, 4							;compare the user input to zero
jb place3									;if = 5, go to place5
jae place4									;if = 4, go to place4

place0:
mov columnIndex, 0							;columnIndex = 0
mov rowIndex, 0								;rowIndex = 0
jmp okay

place3:
cmp UserInput, 3
jb place2
mov columnIndex, 3							;columnIndex = 3
mov rowIndex, 3								;rowIndex = 3
jmp okay

place2:
cmp UserInput, 2			
jb place1
mov columnIndex, 2							;columnIndex = 2
mov rowIndex, 2								;rowIndex = 2
jmp okay

place1:
cmp UserInput, 1
jb place0
mov columnIndex, 1							;columnIndex = 1
mov rowIndex, 1 							;rowIndex = 1
jmp okay

place4:
cmp UserInput, 4
ja place5
mov columnIndex, 4							;columnIndex = 4
mov rowIndex, 4								;rowIndex = 4
jmp okay

place5:
cmp UserInput, 5
ja place6
mov columnIndex, 5							;columnIndex = 5
mov rowIndex, 5								;rowIndex = 5
jmp okay

place6:
cmp UserInput, 6
ja place7
mov columnIndex, 6							;columnIndex = 5
mov rowIndex, 6								;rowIndex = 5
jmp okay

place7:
cmp UserInput, 7
ja place8
mov columnIndex, 7							;columnIndex = 5
mov rowIndex, 7								;rowIndex = 5
jmp okay

place8:
mov columnIndex, 8							;columnIndex = 5
mov rowIndex, 8								;rowIndex = 5
jmp okay

okay:										;SET THE COLOR
cmp charNow, 'X'
jne noX
mov EAX, blue + (white * 16)
call SetTextColor	
jmp okay1

noX:
mov EAX, white + (blue * 16)
call SetTextColor

okay1:
mov EBX, OFFSET BoardXO						;set EBX to offset boardXO
mov EDX, RowSize							;set EDX = rowsize
mul rowIndex								;mul EDX * rowIndex
add EBX, EDX								;EBX + EDX (OFFSET BoardXO+RowSize*RowIndex)
mov ESI, columnIndex						;ESI = column
mov AL, BYTE PTR[charNow]					;mov the player Char to AL			
mov [EBX + ESI], AL							;mov the char to the array pointed to


ret
InsertChar ENDP

RandomNum PROC
;------------------------------------------------------------------------------
; decide who will go first player or computer by random generator 
; receives: user's input in EAX
; return : nothing 
;------------------------------------------------------------------------------
.data
promptR1 BYTE "Player will go first (Player = X and Computer = O)!", 0
promptR2 BYTE "Computer will go first (Player = O and Computer = X)!", 0
.code
mov EAX, 2									;0-1
call RandomRange							;generate random number
mov randVal, EAX							;mov the random number to randVal
cmp randVal, 0								;0 = player will go first, 1= computer will go first
je setToX									;if equal, go to settoX
mov EDX, OFFSET promptR2
call WriteString
call crlf
mov computer, 'X'							;set computer to X, computer go first
mov player, 'O'								;set player to O
jmp next

setToX:
mov EDX, OFFSET promptR1
call WriteString
call crlf
mov player, 'X'								;set player to X
mov computer, 'O'							;set player to O

next:
ret
RandomNum ENDP

BoardDisplay PROC
;------------------------------------------------------------------------------
; display the board 
; receives: user's input in EAX
; return : nothing 
;------------------------------------------------------------------------------
.data
BoardXO BYTE '-','-','-'				;2d array of board
Rowsize = ($ - BoardXO)
        BYTE '-','-','-'
        BYTE '-','-','-'
Divider BYTE '|'
row_index = 0
column_index = 0

.code
mov ECX, 3								;set the ECX to 3
mov	ebx,OFFSET BoardXO					; table offset
add	ebx,RowSize * row_index				; row offset

RowBoard:								;loop for the rows
push ECX
mov	esi,column_index					;set esi to the column index
mov AL, BYTE PTR[Divider]				;output the |
call WriteChar

mov ECX, 3								;set the ECX to 3
ColumnBoard:										
mov AL, [ebx + esi]						;the character that is pointed to
call writeChar							;write it on screen
inc ESI									;next element
mov AL, BYTE PTR[Divider]				;|
call WriteChar
loop ColumnBoard						;loop the columnBoard
call crlf

add EBX,3									;next row
pop ECX
loop RowBoard							;loop RowBoard until ECX = 0

ret
BoardDisplay ENDP

anyWin PROC
;------------------------------------------------------------------------------
; checks if any player wins
; receives: 
; return : 
;------------------------------------------------------------------------------
.data
row BYTE 0
col BYTE 0
totalRow = 3
totalCol = 3
countTotalX BYTE 0
xwins BYTE 0
anyWin1 BYTE "X wins!", 0
promptContX BYTE "Bye!", 0

.code
sub ESI, ESI
;check for any win in rows for X
mov ESI, OFFSET BoardXO					;set ESI to offset of the board
mov row, 0
mov col, 0
LRow:
mov BL, row									;ROW offset
LCol:
;mov CL, col
mov EAX, 0
mov AL, RowSize
mul BL										;rowsize * rowindex
add AL, col
;movzx EBX, col								;column index
mov AL, [ESI+EAX]							;AL = element pointed to


cmp AL, 'X'									;compare AL with X
je equalX
jmp cont

equalX:
inc countTotalX								;inc the total X
jmp cont 			

cont:
inc col										;mov to the next column
cmp col, totalCol							;compare col with 3 
jl LCol										;if lower than 3, stays on the same row


cmp countTotalX, 3							;compare the countTotalX with 3
je winX										;if equal go to win X
mov countTotalX, 0							;set to 0
mov col, 0									;start at column 0									
inc row
cmp row, totalRow							;compare row with 3
jl LRow

;check for column X winning
mov row, 0									;reset the col and row							
mov col, 0
LCol1:
mov CL, col									;ROW offset
LRow1:
mov BL, row
mov EAX, 0
mov AL, RowSize
mul BL										;rowsize * rowindex
add AL, col
;movzx EBX, col								;column index
mov AL, [ESI+EAX]							;AL = element pointed to


cmp AL, 'X'									;compare AL with X
je equalX1
jmp cont1


equalX1:
inc countTotalX								;inc the total X
jmp cont1 	
		

cont1:
inc row										;mov to the next row
cmp row, totalRow							;compare row with 3 
jl LRow1									;if lower than 3, stays on the same row


cmp countTotalX, 3							;compare the countTotalX with 3
je winX										;if equal go to win X
mov countTotalX, 0							;set to 0
mov row, 0									;start at row 0									
inc col
cmp col, totalCol							;compare row with 3
jl LCol1

COMMENT!

;check for \ winning X
mov row, 0									;reset the col and row							
mov col, 0
LCol2:
mov CL, col									;col offset
LRow2:
mov BL, row
mov EAX, 0
mov AL, RowSize
mul BL										;rowsize * rowindex
add AL, col
mov AL, [ESI+EAX]							;AL = element pointed to
cmp AL, 'X'									;compare AL with X
je equalX2
jmp cont2

equalX2:
inc countTotalX								;inc the total X

cont2:
inc row										;mov to the next row
inc col
cmp row, totalRow							;compare row with 3 
jl LCol2									;if lower than 3, stays on the same row

cmp countTotalX, 3							;compare the countTotalX with 3
je winX										;if equal go to win X


;check for / winning X
mov row, 0									;reset the col and row							
mov col, 2
LCol3:
mov CL, col									;col offset
mov BL, row									;row offset
mov EAX, 0
mov AL, RowSize
mul BL										;rowsize * rowindex
add AL, col
mov AL, [ESI+EAX]							;AL = element pointed to
cmp AL, 'X'									;compare AL with X
je equalX3
jmp cont3

equalX3:
inc countTotalX								;inc the total X

cont3:
inc row										;mov to the next row
dec col
cmp row, totalRow							;compare row with 3 
jl LCol3									;if lower than 3, stays on the same row

cmp countTotalX, 3							;compare the countTotalX with 3
je winX										;if equal go to win X
!
jmp done

winX:
mov EDX, OFFSET anyWin1
call WriteString
inc TotalWin
call EndGame

done:
ret
anyWin ENDP

anyWinO PROC
;------------------------------------------------------------------------------
; checks if any player wins
; receives: 
; return : 
;------------------------------------------------------------------------------
.data
owins BYTE 0
countTotalO BYTE 0
anyWin2 BYTE "O wins!", 0
promptContO BYTE "Bye!", 0
.code
sub ESI, ESI
;check for any win in rows for X
mov ESI, OFFSET BoardXO					;set ESI to offset of the board
mov row, 0
mov col, 0
LRow:
mov BL, row									;ROW offset
LCol:
;mov CL, col
mov EAX, 0
mov AL, RowSize
mul BL										;rowsize * rowindex
add AL, col
;movzx EBX, col								;column index
mov AL, [ESI+EAX]							;AL = element pointed to


cmp AL, 'O'									;compare AL with X
je equalO
jmp cont

equalO:
inc countTotalO								;inc the total X
jmp cont 			

cont:
inc col										;mov to the next column
cmp col, totalCol							;compare col with 3 
jl LCol										;if lower than 3, stays on the same row


cmp countTotalO, 3							;compare the countTotalX with 3
je winO										;if equal go to win X
mov countTotalO, 0							;set to 0
mov col, 0									;start at column 0									
inc row
cmp row, totalRow							;compare row with 3
jl LRow

;check for column O winning
mov row, 0									;reset the col and row							
mov col, 0
LCol1:
mov CL, col									;ROW offset
LRow1:
mov BL, row
mov EAX, 0
mov AL, RowSize
mul BL										;rowsize * rowindex
add AL, col
;movzx EBX, col								;column index
mov AL, [ESI+EAX]							;AL = element pointed to


cmp AL, 'O'									;compare AL with X
je equalO1
jmp cont1


equalO1:
inc countTotalX								;inc the total X
jmp cont1 	
		

cont1:
inc row										;mov to the next row
cmp row, totalRow							;compare row with 3 
jl LRow1									;if lower than 3, stays on the same row


cmp countTotalO, 3							;compare the countTotalX with 3
je winO										;if equal go to win O
mov countTotalO, 0							;set to 0
mov row, 0									;start at row 0									
inc col
cmp col, totalCol							;compare row with 3
jl LCol1
jmp done1

winO:
mov EDX, OFFSET anyWin2
call WriteString
call EndGame

done1:
ret
AnyWinO ENDP

EndGame PROC
;------------------------------------------------------------------------------
; give the choices to the users if they want to enter a new game or not
;receives : nothing
;------------------------------------------------------------------------------
.data
promptE BYTE "Would you like to play another game? 1 = YES 2 = NO", 0
promptE1 BYTE "Total win: "
TotalWin DWORD 0
.code
mov EDX, OFFSET promptE
call WriteString
call ReadInt									;read the user input
cmp EAX, 1										;compare it with 1
je playagain1									;if equal = play again
mov EDX, OFFSET promptE1				
call WriteString
mov EAX, OFFSET TotalWin			
call WriteDec
call crlf
jmp end2

playagain1:
call clrscr
call resetTable
call mainMenu

end2:
exit

end1:
ret
EndGame ENDP

resetTable PROC
;------------------------------------------------------------------------------
; reset the table to a new table
; receives : nothing
; return : nothing
;------------------------------------------------------------------------------
.data
row_index = 0
column_index = 0
.code
mov ECX, 3								;set the ECX to 3
mov	ebx,OFFSET BoardXO					; table offset
add	ebx,RowSize * row_index				; row offset

RowBoard:								;loop for the rows
push ECX
mov	esi,column_index					;set esi to the column index
mov AL, '-'				;output the |
call WriteChar

mov ECX, 3								;set the ECX to 3
ColumnBoard:										
;mov AL, [ebx + esi]						;the character that is pointed to
mov [ebx+esi], AL
call writeChar							;write it on screen
inc ESI									;next element
loop ColumnBoard						;loop the columnBoard
call crlf

add EBX,3									;next row
pop ECX
loop RowBoard							;loop RowBoard until ECX = 0

mov ECX, 10
LCH:
mov ESI, OFFSET valueChosen				;clear the checker
mov BYTE PTR[ESI],' '
add ESI, 4
loop LCH

ret
resetTable ENDP

END MAIN
