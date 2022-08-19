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

	| method |
	method := Smalltalk compiler
		          source: 'temp ' , (self translate: aString);
		          class: self;
		          compile.

	method valueWithReceiver: self new arguments: #(  )
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
	arr byteAt: ptr put: (arr byteAt: ptr) - 1
]

{ #category : #brainfuck }
BFRunner >> decPtr [
	ptr := ptr - 1
]

{ #category : #brainfuck }
BFRunner >> inc [
	arr byteAt: ptr put: (arr byteAt: ptr) + 1
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
	^ (arr byteAt: ptr) > 0
]

{ #category : #brainfuck }
BFRunner >> write [
	Transcript nextPut: (arr byteAt: ptr) asCharacter; flush.
]
