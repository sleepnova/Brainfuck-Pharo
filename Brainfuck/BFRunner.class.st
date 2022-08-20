"
I execute bf code on the fly

## Usage:

```
BFRunner run: 'bf code'
```

## Example:

Print ""Hello World!"" to Transcript.

```
BFRunner run: '++++++++[>++++[>++>+++>+++>+<<<<-]>+>->+>>+[<]<-]>>.>>---.+++++++..+++.>.<<-.>.+++.------.--------.>+.>++.'
```
"
Class {
	#name : #BFRunner,
	#superclass : #Object,
	#instVars : [
		'arr',
		'ptr'
	],
	#classInstVars : [
		'map'
	],
	#category : #Brainfuck
}

{ #category : #'public access' }
BFRunner class >> compileMethodName: aStringName code: aStringCode [

	"BFRunner compileMethodName: 'test' code: 'bf code'"

	self
		compile: aStringName , '
		' , (self translate: aStringCode)
		classified: 'generated'
]

{ #category : #'class initialization' }
BFRunner class >> initialize [

	map := Dictionary newFrom: { 
			       ($> -> 'self incPtr.').
			       ($< -> 'self decPtr.').
			       ($+ -> 'self inc.').
			       ($- -> 'self dec.').
			       ($. -> 'self write.').
			       ($[ -> '[self positive] whileTrue: [').
			       ($] -> '].') }
]

{ #category : #'public access' }
BFRunner class >> run: aString [

	"Translate -> compile -> evaluate the code on the fly."

	Smalltalk compiler
		class: self;
		receiver: self new;
		evaluate: (self translate: aString)
]

{ #category : #running }
BFRunner class >> translate: aString [

	"Translate a bf program to a method body in text."

	^ ((aString select: [ :c | '><+-.,[]' includes: c ])
		   collect: [ :c | map at: c ]
		   as: Array) joinUsing: Character space
]

{ #category : #brainfuck }
BFRunner >> dec [
	self set: (self get) - 1
]

{ #category : #brainfuck }
BFRunner >> decPtr [
	ptr := ptr - 1
]

{ #category : #brainfuck }
BFRunner >> get [
	^ arr byteAt: ptr
]

{ #category : #brainfuck }
BFRunner >> inc [
	self set: (self get) + 1
]

{ #category : #brainfuck }
BFRunner >> incPtr [
	ptr := ptr + 1
]

{ #category : #initialization }
BFRunner >> initialize [
	arr := ByteArray new: 30000.
	ptr := 1.
]

{ #category : #brainfuck }
BFRunner >> positive [
	^ self get > 0
]

{ #category : #brainfuck }
BFRunner >> set: anInteger [
	^ arr byteAt: ptr put: anInteger \\ 256
]

{ #category : #brainfuck }
BFRunner >> write [
	Transcript
		nextPut: self get asCharacter;
		flush
]
