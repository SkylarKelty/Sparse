all: out/boot.bin out/boot.img

out/boot.bin: src/boot.asm
	nasm -f bin src/boot.asm -o out/boot.bin

out/boot.img: out/boot.bin
	dd conv=notrunc if=out/boot.bin of=out/boot.img

clean:
	rm -rf out/*

run: out/boot.img
	qemu -fda out/boot.img