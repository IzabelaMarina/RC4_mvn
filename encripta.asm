@ 	/0000

	JP	MAIN

;Vetores

;Vetor S (10)
VETORS	K	/0001
	K	/0002
	K	/0003
	K	/0004
	K	/0005
	K	/0006
	K	/0007
	K	/0008
	K	/0009
	K	/000A

KEY	K	/004B ;K
	K	/0045 ;E
	K	/0059 ;Y

;Guarda a parte da mensagem que está sendo encriptada (10)
MSG	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000

;Guarda o vetor chave
VETKEY	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000
	K	/0000

;Variáveis
KEYSZ	K	/0003 ;Tamanho da chave
KEYAD	K	/0016 ;Endereço inicial da chave
VETSZ	K	/000A ;Tamanho de S
VETAD	K	/0002 ;Endereço inicial de S 
MSGAD	K	/001C ;Endereço inicial da mensagem
VKAD	K	/0030 ;Endereço inicial do vetor chave
JOTA	K	/0000
I	K	/0000
UM	K	/0001
DOIS	K	/0002
CEM	K	/0100
VETAUX	K	/0000
LOAD	K	/8000
MOVE	K	/9000
JADD	K	/0000
IADD	K	/0000
GDAUX	K	/0000
CONT	K	/0000
LEN	K	/0000

QUOC	K	/0000
DIVD	K	/0000
DIVS	K	/0000

;Programa
MAIN	SC	KSA ;Inicializa o vetor S
	LV	/0000
	MM	CONT
LELOOP	GD	/301 ;Lê os primeiros 10 caracteres da msg e guarda no vetor msg
	MM	GDAUX
	LD	CONT
	ML	DOIS
	AD	MSGAD
	AD	MOVE
	MM	MSGPUT1
	LD	GDAUX
	DV	CEM
MSGPUT1	K	/9000
	JZ	FIMSG
	LD 	CONT
	AD	UM
	MM	CONT
	ML	DOIS
	AD	MSGAD
	AD	MOVE
	MM	MSGPUT2
	LD	GDAUX
	ML	CEM
	DV 	CEM
MSGPUT2	K	/9000
	JZ	FIMSG
	LD	CONT
	AD	UM
	MM	CONT
	SB	VETSZ ;Verifica se já pegou 10 caracteres
	JZ	FIMPT
	JP	LELOOP

FIMPT	LD	CONT
	MM	LEN
	SC	PRGA
	SC	ESCR
	JP	MAIN

FIMSG	LD	CONT
	MM	LEN
	SC	PRGA
	SC 	ESCR
	JP	FIM

FIM	HM	FIM ;Fim do programa

;Subrotina para escrita da msg encriptada
ESCR	K	/0000
	LV	/0000
	MM	I ;Inicializa i com 0
LOOPES	LD	LEN
	SB	I ;Verifica se chegou ao fim dos vetores
	JZ	FIMES
	JN	FIMES
	LD	I
	ML	DOIS
	AD	VKAD
	AD	LOAD
	MM	CHVK1
CHVK1	K	/8000 ;Carrega K[i] em uma variável auxiliar
	MM	KI1
	LD	I
	ML	DOIS
	AD	MSGAD
	AD	LOAD
	MM	CHMS1
CHMS1	K	/8000 ;Carrega M[i] na mesma variável auxiliar
	MM	MI1
	LV	/0003 ;Operação XOR
	JP	XOR1
KI1	K	/0000
MI1	K	/0000
XOR1	OS	/201
	ML 	CEM
	MM	GDAUX
	LD	I
	AD	UM
	MM	I ;Incrementa i em 1 unidade
	LD	LEN
	SB	I
	JZ	WRIT
	LD	I
	ML	DOIS
	AD	VKAD
	AD	LOAD
	MM	CHVK2
CHVK2	K	/8000
	MM	KI2
	LD	I
	ML	DOIS
	AD	MSGAD
	AD	LOAD
	MM	CHMS2
CHMS2	K	/8000
	MM	MI2
	LV	/0003
	JP	XOR2
KI2	K	/0000
MI2	K	/0000
XOR2	OS	/201
	AD	GDAUX
WRIT	PD	/302
	LD	I
	AD	UM
	MM	I 
	JP	LOOPES ;Reinicia

FIMES	RS	ESCR	
	
;Gera vetor chave
PRGA	K	/0000
	LV	/0000 ;Inicializa i e j com 0
	MM	JOTA
	MM	I
LOOPPR	LD	CONT ;while cont>0
	JZ	FPRGA
	LD	I
	AD	UM ;i = (i+1)%len(S)
	MM	DIVD
	LD	VETSZ
	MM	DIVS
	SC	MOD
	MM	I
	ML	DOIS ;Pega S[i]
	AD 	VETAD
	AD	LOAD
	MM	CHSI1
CHSI1	K	/8000
	AD	JOTA ;j = (j+S[i])%len(S)
	MM	DIVD
	LD	VETSZ
	MM	DIVS
	SC	MOD
	MM	JOTA
	SC	SWAP ;Swap S[i] e S[j]
	LD	I ;Pega S[i]
	ML	DOIS
	AD 	VETAD
	AD	LOAD
	MM	CHSI2
CHSI2	K	/8000
	MM 	VETAUX ;Guarda S[i]
	LD	JOTA ;Pega S[j]
	ML	DOIS
	AD	VETAD
	AD	LOAD
	MM	CHSJ
CHSJ	K	/8000
	AD	VETAUX
	MM	DIVD
	LD	VETSZ
	MM	DIVS
	SC	MOD
	MM	VETAUX ;(S[i]+S[j])%len(S)
	ML	DOIS
	AD	VETAD
	AD	LOAD
	MM	CHK
	LD	I
	ML	DOIS
	AD	VKAD
	AD	MOVE
	MM	PUTK
CHK	K	/8000
PUTK	K	/9000 ; K[i] = S[(S[i]+S[j])%len(S)], onde K é o vetor chave
	LD	CONT
	SB	UM
	MM	CONT
	JP	LOOPPR
FPRGA	RS	PRGA 
	
	

;Subrotina que inicializa o vetor S
KSA	K	/0000
	LV	/0000 ;Inicializa i e j com 0
	MM	JOTA
	MM	I
LOOPIN	ML	DOIS ; for i from 0 to len(S)
	AD	VETAD
	AD	LOAD
	MM	CHS
CHS	K 	/8000 ;Pega S[i]
	SC	NOVOJ ;Calcula j = (j+S[i]+chave[i%lenchave])%lenS
	SC	SWAP
	LD 	VETSZ
	SB	I
	JZ	FIMKS
	LD	I
	AD	UM
	MM	I
	JP	LOOPIN
FIMKS	RS	KSA

;Subrotina que troca S[i] por S[j]
SWAP	K	/0000	
	LD	JOTA ;Pega endereço de S[j]
	ML	DOIS
	AD	VETAD
	MM	JADD ;Guarda endereço de S[j]
	AD 	LOAD
	MM	JCH
JCH	K	/8000
	MM	VETAUX ;Guarda o valor de S[j] em uma variável auxiliar
	LD	I ;Pega endereço de S[i]
	ML	DOIS
	AD 	VETAD
	MM	IADD
	AD 	LOAD
	MM	ICH
	LD	JADD
	AD	MOVE
	MM	IPUT
ICH	K	/8000 ; Pega o valor em S[i]
IPUT	K	/9000 ; Guarda em S[j]
	LD	IADD
	AD	MOVE
	MM	JPUT
	LD	VETAUX ; Pega o valor de S[j]
JPUT	K	/9000 ; Guarda em S[i]
	RS	SWAP	
	
	

;Subrotina que define o novo j (j = (j+S[i]+chave[i%lenchave])%lenS)
NOVOJ	K	/0000
	AD	JOTA ;Quando a rotina é chamada S[i] está sempre no acumulador
	MM	JOTA ;j = j+S[i]
	LD	I
	MM	DIVD
	LD	KEYSZ
	MM	DIVS
	SC	MOD
	ML	DOIS
	AD	KEYAD
	AD	LOAD
	MM	CHKEY
CHKEY	K	/8000
	AD	JOTA ;j+S[i]+chave[i%lenchave]
	MM	DIVD
	LD	VETSZ
	MM	DIVS
	SC	MOD
	MM	JOTA ;j = (j+S[i]+chave[i%lenchave])%lenS
	RS	NOVOJ
	
	
;Subrotina que calcula o resto da divisão (%)
MOD	K	/0000
	LD	DIVD
	DV	DIVS
	ML	DIVS
	MM	QUOC ;Quoc não é o quociente da divisão, mas int(quociente)*divisor
	LD	DIVD
	SB	QUOC
	RS	MOD ;O resto fica armazenado no acumulador
