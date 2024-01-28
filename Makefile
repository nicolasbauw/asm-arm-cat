all:
	gcc -g -o cat cat.s -nostdlib

clean:
	rm cat