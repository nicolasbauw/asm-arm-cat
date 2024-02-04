all:
	as -g -o cat.o cat.s
	ld -g -o cat cat.o

clean:
	rm cat cat.o

