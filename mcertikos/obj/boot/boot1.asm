
obj/boot/boot1.elf:     file format elf32-i386


Disassembly of section .text:

00007e00 <start>:
	.set SMAP_SIG, 0x0534D4150	# "SMAP"

	.globl start
start:
	.code16
	cli
    7e00:	fa                   	cli
	cld
    7e01:	fc                   	cld

00007e02 <seta20.1>:

	/* enable A20 */
seta20.1:
	inb	$0x64, %al
    7e02:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7e04:	a8 02                	test   $0x2,%al
	jnz	seta20.1
    7e06:	75 fa                	jne    7e02 <seta20.1>
	movb	$0xd1, %al
    7e08:	b0 d1                	mov    $0xd1,%al
	outb	%al, $0x64
    7e0a:	e6 64                	out    %al,$0x64

00007e0c <seta20.2>:
seta20.2:
	inb	$0x64, %al
    7e0c:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7e0e:	a8 02                	test   $0x2,%al
	jnz	seta20.2
    7e10:	75 fa                	jne    7e0c <seta20.2>
	movb	$0xdf, %al
    7e12:	b0 df                	mov    $0xdf,%al
	outb	%al, $0x60
    7e14:	e6 60                	out    %al,$0x60

00007e16 <set_video_mode.2>:

	/*
	 * print starting message
	 */
set_video_mode.2:
	movw	$STARTUP_MSG, %si
    7e16:	be ab 7e e8 81       	mov    $0x81e87eab,%esi
	call	putstr
    7e1b:	00               	add    %ah,0x31(%esi)

00007e1c <e820>:

	/*
	 * detect the physical memory map
	 */
e820:
	xorl	%ebx, %ebx		# ebx must be 0 when first calling e820
    7e1c:	66 31 db             	xor    %bx,%bx
	movl	$SMAP_SIG, %edx		# edx must be 'SMAP' when calling e820
    7e1f:	66 ba 50 41          	mov    $0x4150,%dx
    7e23:	4d                   	dec    %ebp
    7e24:	53                   	push   %ebx
	movw	$(smap + 4), %di	# set the address of the output buffer
    7e25:	bf 2a 7f         	mov    $0xb9667f2a,%edi

00007e28 <e820.1>:
e820.1:
	movl	$20, %ecx		# set the size of the output buffer
    7e28:	66 b9 14 00          	mov    $0x14,%cx
    7e2c:	00 00                	add    %al,(%eax)
	movl	$0xe820, %eax		# set the BIOS service code
    7e2e:	66 b8 20 e8          	mov    $0xe820,%ax
    7e32:	00 00                	add    %al,(%eax)
	int	$0x15			# call BIOS service e820h
    7e34:	cd 15                	int    $0x15

00007e36 <e820.2>:
e820.2:
	jc	e820.fail		# error during e820h
    7e36:	72 24                	jb     7e5c <e820.fail>
	cmpl	$SMAP_SIG, %eax		# check eax, which should be 'SMAP'
    7e38:	66 3d 50 41          	cmp    $0x4150,%ax
    7e3c:	4d                   	dec    %ebp
    7e3d:	53                   	push   %ebx
	jne	e820.fail
    7e3e:	75 1c                	jne    7e5c <e820.fail>

00007e40 <e820.3>:
e820.3:
	movl	$20, -4(%di)
    7e40:	66 c7 45 fc 14 00    	movw   $0x14,-0x4(%ebp)
    7e46:	00 00                	add    %al,(%eax)
	addw	$24, %di
    7e48:	83 c7 18             	add    $0x18,%edi
	cmpl	$0x0, %ebx		# whether it's the last descriptor
    7e4b:	66 83 fb 00          	cmp    $0x0,%bx
	je	e820.4
    7e4f:	74 02                	je     7e53 <e820.4>
	jmp	e820.1
    7e51:	eb d5                	jmp    7e28 <e820.1>

00007e53 <e820.4>:
e820.4:					# zero the descriptor after the last one
	xorb	%al, %al
    7e53:	30 c0                	xor    %al,%al
	movw	$20, %cx
    7e55:	b9 14 00 f3 aa       	mov    $0xaaf30014,%ecx
	rep	stosb
	jmp	switch_prot
    7e5a:	eb 09                	jmp    7e65 <switch_prot>

00007e5c <e820.fail>:
e820.fail:
	movw	$E820_FAIL_MSG, %si
    7e5c:	be bd 7e e8 3b       	mov    $0x3be87ebd,%esi
	call	putstr
    7e61:	00 eb                	add    %ch,%bl
	jmp	spin16
    7e63:	00                 	add    %dh,%ah

00007e64 <spin16>:

spin16:
	hlt
    7e64:	f4                   	hlt

00007e65 <switch_prot>:

	/*
	 * load the bootstrap GDT
	 */
switch_prot:
	lgdt	gdtdesc
    7e65:	0f 01 16             	lgdtl  (%esi)
    7e68:	20 7f 0f             	and    %bh,0xf(%edi)
	movl	%cr0, %eax
    7e6b:	20 c0                	and    %al,%al
	orl	$CR0_PE_ON, %eax
    7e6d:	66 83 c8 01          	or     $0x1,%ax
	movl	%eax, %cr0
    7e71:	0f 22 c0             	mov    %eax,%cr0
	/*
	 * switch to the protected mode
	 */
	ljmp	$PROT_MODE_CSEG, $protcseg
    7e74:	ea 79 7e 08 00   	ljmp   $0xb866,$0x87e79

00007e79 <protcseg>:

	.code32
protcseg:
	movw	$PROT_MODE_DSEG, %ax
    7e79:	66 b8 10 00          	mov    $0x10,%ax
	movw	%ax, %ds
    7e7d:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
    7e7f:	8e c0                	mov    %eax,%es
	movw	%ax, %fs
    7e81:	8e e0                	mov    %eax,%fs
	movw	%ax, %gs
    7e83:	8e e8                	mov    %eax,%gs
	movw	%ax, %ss
    7e85:	8e d0                	mov    %eax,%ss

	/*
	 * jump to the C part
	 * (dev, lba, smap)
	 */
	pushl	$smap
    7e87:	68 26 7f 00 00       	push   $0x7f26
	pushl	$BOOT0
    7e8c:	68 00 7c 00 00       	push   $0x7c00
	movl	(BOOT0 - 4), %eax
    7e91:	a1 fc 7b 00 00       	mov    0x7bfc,%eax
	pushl	%eax
    7e96:	50                   	push   %eax
	call	boot1main
    7e97:	e8 4b 10 00 00       	call   8ee7 <boot1main>

00007e9c <spin>:

spin:
	hlt
    7e9c:	f4                   	hlt

00007e9d <putstr>:
/*
 * print a string (@ %si) to the screen
 */
	.globl putstr
putstr:
	pusha
    7e9d:	60                   	pusha
	movb	$0xe, %ah
    7e9e:	b4 0e                	mov    $0xe,%ah

00007ea0 <putstr.1>:
putstr.1:
	lodsb
    7ea0:	ac                   	lods   %ds:(%esi),%al
	cmp	$0, %al
    7ea1:	3c 00                	cmp    $0x0,%al
	je	putstr.2
    7ea3:	74 04                	je     7ea9 <putstr.2>
	int	$0x10
    7ea5:	cd 10                	int    $0x10
	jmp	putstr.1
    7ea7:	eb f7                	jmp    7ea0 <putstr.1>

00007ea9 <putstr.2>:
putstr.2:
	popa
    7ea9:	61                   	popa
	ret
    7eaa:	c3                   	ret

00007eab <STARTUP_MSG>:
    7eab:	53                   	push   %ebx
    7eac:	74 61                	je     7f0f <gdt+0x17>
    7eae:	72 74                	jb     7f24 <gdtdesc+0x4>
    7eb0:	20 62 6f             	and    %ah,0x6f(%edx)
    7eb3:	6f                   	outsl  %ds:(%esi),(%dx)
    7eb4:	74 31                	je     7ee7 <NO_BOOTABLE_MSG+0x8>
    7eb6:	20 2e                	and    %ch,(%esi)
    7eb8:	2e 2e 0d 0a 00   	cs cs or $0x7265000a,%eax

00007ebd <E820_FAIL_MSG>:
    7ebd:	65 72 72             	gs jb  7f32 <smap+0xc>
    7ec0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ec1:	72 20                	jb     7ee3 <NO_BOOTABLE_MSG+0x4>
    7ec3:	77 68                	ja     7f2d <smap+0x7>
    7ec5:	65 6e                	outsb  %gs:(%esi),(%dx)
    7ec7:	20 64 65 74          	and    %ah,0x74(%ebp,%eiz,2)
    7ecb:	65 63 74 69 6e       	arpl   %esi,%gs:0x6e(%ecx,%ebp,2)
    7ed0:	67 20 6d 65          	and    %ch,0x65(%di)
    7ed4:	6d                   	insl   (%dx),%es:(%edi)
    7ed5:	6f                   	outsl  %ds:(%esi),(%dx)
    7ed6:	72 79                	jb     7f51 <smap+0x2b>
    7ed8:	20 6d 61             	and    %ch,0x61(%ebp)
    7edb:	70 0d                	jo     7eea <NO_BOOTABLE_MSG+0xb>
    7edd:	0a 00                	or     (%eax),%al

00007edf <NO_BOOTABLE_MSG>:
    7edf:	4e                   	dec    %esi
    7ee0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee1:	20 62 6f             	and    %ah,0x6f(%edx)
    7ee4:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee5:	74 61                	je     7f48 <smap+0x22>
    7ee7:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    7eeb:	70 61                	jo     7f4e <smap+0x28>
    7eed:	72 74                	jb     7f63 <smap+0x3d>
    7eef:	69 74 69 6f 6e 2e 0d 	imul   $0xa0d2e6e,0x6f(%ecx,%ebp,2),%esi
    7ef6:	0a 
    7ef7:	00                 	add    %al,(%eax)

00007ef8 <gdt>:
    7ef8:	00 00                	add    %al,(%eax)
    7efa:	00 00                	add    %al,(%eax)
    7efc:	00 00                	add    %al,(%eax)
    7efe:	00 00                	add    %al,(%eax)
    7f00:	ff                   	(bad)
    7f01:	ff 00                	incl   (%eax)
    7f03:	00 00                	add    %al,(%eax)
    7f05:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7f0c:	00 92 cf 00 ff ff    	add    %dl,-0xff31(%edx)
    7f12:	00 00                	add    %al,(%eax)
    7f14:	00 9e 00 00 ff ff    	add    %bl,-0x10000(%esi)
    7f1a:	00 00                	add    %al,(%eax)
    7f1c:	00 92 00 00      	add    %dl,0x270000(%edx)

00007f20 <gdtdesc>:
    7f20:	27                   	daa
    7f21:	00 f8                	add    %bh,%al
    7f23:	7e 00                	jle    7f25 <gdtdesc+0x5>
    7f25:	00                 	add    %al,(%eax)

00007f26 <smap>:
    7f26:	00 00                	add    %al,(%eax)
    7f28:	00 00                	add    %al,(%eax)
    7f2a:	00 00                	add    %al,(%eax)
    7f2c:	00 00                	add    %al,(%eax)
    7f2e:	00 00                	add    %al,(%eax)
    7f30:	00 00                	add    %al,(%eax)
    7f32:	00 00                	add    %al,(%eax)
    7f34:	00 00                	add    %al,(%eax)
    7f36:	00 00                	add    %al,(%eax)
    7f38:	00 00                	add    %al,(%eax)
    7f3a:	00 00                	add    %al,(%eax)
    7f3c:	00 00                	add    %al,(%eax)
    7f3e:	00 00                	add    %al,(%eax)
    7f40:	00 00                	add    %al,(%eax)
    7f42:	00 00                	add    %al,(%eax)
    7f44:	00 00                	add    %al,(%eax)
    7f46:	00 00                	add    %al,(%eax)
    7f48:	00 00                	add    %al,(%eax)
    7f4a:	00 00                	add    %al,(%eax)
    7f4c:	00 00                	add    %al,(%eax)
    7f4e:	00 00                	add    %al,(%eax)
    7f50:	00 00                	add    %al,(%eax)
    7f52:	00 00                	add    %al,(%eax)
    7f54:	00 00                	add    %al,(%eax)
    7f56:	00 00                	add    %al,(%eax)
    7f58:	00 00                	add    %al,(%eax)
    7f5a:	00 00                	add    %al,(%eax)
    7f5c:	00 00                	add    %al,(%eax)
    7f5e:	00 00                	add    %al,(%eax)
    7f60:	00 00                	add    %al,(%eax)
    7f62:	00 00                	add    %al,(%eax)
    7f64:	00 00                	add    %al,(%eax)
    7f66:	00 00                	add    %al,(%eax)
    7f68:	00 00                	add    %al,(%eax)
    7f6a:	00 00                	add    %al,(%eax)
    7f6c:	00 00                	add    %al,(%eax)
    7f6e:	00 00                	add    %al,(%eax)
    7f70:	00 00                	add    %al,(%eax)
    7f72:	00 00                	add    %al,(%eax)
    7f74:	00 00                	add    %al,(%eax)
    7f76:	00 00                	add    %al,(%eax)
    7f78:	00 00                	add    %al,(%eax)
    7f7a:	00 00                	add    %al,(%eax)
    7f7c:	00 00                	add    %al,(%eax)
    7f7e:	00 00                	add    %al,(%eax)
    7f80:	00 00                	add    %al,(%eax)
    7f82:	00 00                	add    %al,(%eax)
    7f84:	00 00                	add    %al,(%eax)
    7f86:	00 00                	add    %al,(%eax)
    7f88:	00 00                	add    %al,(%eax)
    7f8a:	00 00                	add    %al,(%eax)
    7f8c:	00 00                	add    %al,(%eax)
    7f8e:	00 00                	add    %al,(%eax)
    7f90:	00 00                	add    %al,(%eax)
    7f92:	00 00                	add    %al,(%eax)
    7f94:	00 00                	add    %al,(%eax)
    7f96:	00 00                	add    %al,(%eax)
    7f98:	00 00                	add    %al,(%eax)
    7f9a:	00 00                	add    %al,(%eax)
    7f9c:	00 00                	add    %al,(%eax)
    7f9e:	00 00                	add    %al,(%eax)
    7fa0:	00 00                	add    %al,(%eax)
    7fa2:	00 00                	add    %al,(%eax)
    7fa4:	00 00                	add    %al,(%eax)
    7fa6:	00 00                	add    %al,(%eax)
    7fa8:	00 00                	add    %al,(%eax)
    7faa:	00 00                	add    %al,(%eax)
    7fac:	00 00                	add    %al,(%eax)
    7fae:	00 00                	add    %al,(%eax)
    7fb0:	00 00                	add    %al,(%eax)
    7fb2:	00 00                	add    %al,(%eax)
    7fb4:	00 00                	add    %al,(%eax)
    7fb6:	00 00                	add    %al,(%eax)
    7fb8:	00 00                	add    %al,(%eax)
    7fba:	00 00                	add    %al,(%eax)
    7fbc:	00 00                	add    %al,(%eax)
    7fbe:	00 00                	add    %al,(%eax)
    7fc0:	00 00                	add    %al,(%eax)
    7fc2:	00 00                	add    %al,(%eax)
    7fc4:	00 00                	add    %al,(%eax)
    7fc6:	00 00                	add    %al,(%eax)
    7fc8:	00 00                	add    %al,(%eax)
    7fca:	00 00                	add    %al,(%eax)
    7fcc:	00 00                	add    %al,(%eax)
    7fce:	00 00                	add    %al,(%eax)
    7fd0:	00 00                	add    %al,(%eax)
    7fd2:	00 00                	add    %al,(%eax)
    7fd4:	00 00                	add    %al,(%eax)
    7fd6:	00 00                	add    %al,(%eax)
    7fd8:	00 00                	add    %al,(%eax)
    7fda:	00 00                	add    %al,(%eax)
    7fdc:	00 00                	add    %al,(%eax)
    7fde:	00 00                	add    %al,(%eax)
    7fe0:	00 00                	add    %al,(%eax)
    7fe2:	00 00                	add    %al,(%eax)
    7fe4:	00 00                	add    %al,(%eax)
    7fe6:	00 00                	add    %al,(%eax)
    7fe8:	00 00                	add    %al,(%eax)
    7fea:	00 00                	add    %al,(%eax)
    7fec:	00 00                	add    %al,(%eax)
    7fee:	00 00                	add    %al,(%eax)
    7ff0:	00 00                	add    %al,(%eax)
    7ff2:	00 00                	add    %al,(%eax)
    7ff4:	00 00                	add    %al,(%eax)
    7ff6:	00 00                	add    %al,(%eax)
    7ff8:	00 00                	add    %al,(%eax)
    7ffa:	00 00                	add    %al,(%eax)
    7ffc:	00 00                	add    %al,(%eax)
    7ffe:	00 00                	add    %al,(%eax)
    8000:	00 00                	add    %al,(%eax)
    8002:	00 00                	add    %al,(%eax)
    8004:	00 00                	add    %al,(%eax)
    8006:	00 00                	add    %al,(%eax)
    8008:	00 00                	add    %al,(%eax)
    800a:	00 00                	add    %al,(%eax)
    800c:	00 00                	add    %al,(%eax)
    800e:	00 00                	add    %al,(%eax)
    8010:	00 00                	add    %al,(%eax)
    8012:	00 00                	add    %al,(%eax)
    8014:	00 00                	add    %al,(%eax)
    8016:	00 00                	add    %al,(%eax)
    8018:	00 00                	add    %al,(%eax)
    801a:	00 00                	add    %al,(%eax)
    801c:	00 00                	add    %al,(%eax)
    801e:	00 00                	add    %al,(%eax)
    8020:	00 00                	add    %al,(%eax)
    8022:	00 00                	add    %al,(%eax)
    8024:	00 00                	add    %al,(%eax)
    8026:	00 00                	add    %al,(%eax)
    8028:	00 00                	add    %al,(%eax)
    802a:	00 00                	add    %al,(%eax)
    802c:	00 00                	add    %al,(%eax)
    802e:	00 00                	add    %al,(%eax)
    8030:	00 00                	add    %al,(%eax)
    8032:	00 00                	add    %al,(%eax)
    8034:	00 00                	add    %al,(%eax)
    8036:	00 00                	add    %al,(%eax)
    8038:	00 00                	add    %al,(%eax)
    803a:	00 00                	add    %al,(%eax)
    803c:	00 00                	add    %al,(%eax)
    803e:	00 00                	add    %al,(%eax)
    8040:	00 00                	add    %al,(%eax)
    8042:	00 00                	add    %al,(%eax)
    8044:	00 00                	add    %al,(%eax)
    8046:	00 00                	add    %al,(%eax)
    8048:	00 00                	add    %al,(%eax)
    804a:	00 00                	add    %al,(%eax)
    804c:	00 00                	add    %al,(%eax)
    804e:	00 00                	add    %al,(%eax)
    8050:	00 00                	add    %al,(%eax)
    8052:	00 00                	add    %al,(%eax)
    8054:	00 00                	add    %al,(%eax)
    8056:	00 00                	add    %al,(%eax)
    8058:	00 00                	add    %al,(%eax)
    805a:	00 00                	add    %al,(%eax)
    805c:	00 00                	add    %al,(%eax)
    805e:	00 00                	add    %al,(%eax)
    8060:	00 00                	add    %al,(%eax)
    8062:	00 00                	add    %al,(%eax)
    8064:	00 00                	add    %al,(%eax)
    8066:	00 00                	add    %al,(%eax)
    8068:	00 00                	add    %al,(%eax)
    806a:	00 00                	add    %al,(%eax)
    806c:	00 00                	add    %al,(%eax)
    806e:	00 00                	add    %al,(%eax)
    8070:	00 00                	add    %al,(%eax)
    8072:	00 00                	add    %al,(%eax)
    8074:	00 00                	add    %al,(%eax)
    8076:	00 00                	add    %al,(%eax)
    8078:	00 00                	add    %al,(%eax)
    807a:	00 00                	add    %al,(%eax)
    807c:	00 00                	add    %al,(%eax)
    807e:	00 00                	add    %al,(%eax)
    8080:	00 00                	add    %al,(%eax)
    8082:	00 00                	add    %al,(%eax)
    8084:	00 00                	add    %al,(%eax)
    8086:	00 00                	add    %al,(%eax)
    8088:	00 00                	add    %al,(%eax)
    808a:	00 00                	add    %al,(%eax)
    808c:	00 00                	add    %al,(%eax)
    808e:	00 00                	add    %al,(%eax)
    8090:	00 00                	add    %al,(%eax)
    8092:	00 00                	add    %al,(%eax)
    8094:	00 00                	add    %al,(%eax)
    8096:	00 00                	add    %al,(%eax)
    8098:	00 00                	add    %al,(%eax)
    809a:	00 00                	add    %al,(%eax)
    809c:	00 00                	add    %al,(%eax)
    809e:	00 00                	add    %al,(%eax)
    80a0:	00 00                	add    %al,(%eax)
    80a2:	00 00                	add    %al,(%eax)
    80a4:	00 00                	add    %al,(%eax)
    80a6:	00 00                	add    %al,(%eax)
    80a8:	00 00                	add    %al,(%eax)
    80aa:	00 00                	add    %al,(%eax)
    80ac:	00 00                	add    %al,(%eax)
    80ae:	00 00                	add    %al,(%eax)
    80b0:	00 00                	add    %al,(%eax)
    80b2:	00 00                	add    %al,(%eax)
    80b4:	00 00                	add    %al,(%eax)
    80b6:	00 00                	add    %al,(%eax)
    80b8:	00 00                	add    %al,(%eax)
    80ba:	00 00                	add    %al,(%eax)
    80bc:	00 00                	add    %al,(%eax)
    80be:	00 00                	add    %al,(%eax)
    80c0:	00 00                	add    %al,(%eax)
    80c2:	00 00                	add    %al,(%eax)
    80c4:	00 00                	add    %al,(%eax)
    80c6:	00 00                	add    %al,(%eax)
    80c8:	00 00                	add    %al,(%eax)
    80ca:	00 00                	add    %al,(%eax)
    80cc:	00 00                	add    %al,(%eax)
    80ce:	00 00                	add    %al,(%eax)
    80d0:	00 00                	add    %al,(%eax)
    80d2:	00 00                	add    %al,(%eax)
    80d4:	00 00                	add    %al,(%eax)
    80d6:	00 00                	add    %al,(%eax)
    80d8:	00 00                	add    %al,(%eax)
    80da:	00 00                	add    %al,(%eax)
    80dc:	00 00                	add    %al,(%eax)
    80de:	00 00                	add    %al,(%eax)
    80e0:	00 00                	add    %al,(%eax)
    80e2:	00 00                	add    %al,(%eax)
    80e4:	00 00                	add    %al,(%eax)
    80e6:	00 00                	add    %al,(%eax)
    80e8:	00 00                	add    %al,(%eax)
    80ea:	00 00                	add    %al,(%eax)
    80ec:	00 00                	add    %al,(%eax)
    80ee:	00 00                	add    %al,(%eax)
    80f0:	00 00                	add    %al,(%eax)
    80f2:	00 00                	add    %al,(%eax)
    80f4:	00 00                	add    %al,(%eax)
    80f6:	00 00                	add    %al,(%eax)
    80f8:	00 00                	add    %al,(%eax)
    80fa:	00 00                	add    %al,(%eax)
    80fc:	00 00                	add    %al,(%eax)
    80fe:	00 00                	add    %al,(%eax)
    8100:	00 00                	add    %al,(%eax)
    8102:	00 00                	add    %al,(%eax)
    8104:	00 00                	add    %al,(%eax)
    8106:	00 00                	add    %al,(%eax)
    8108:	00 00                	add    %al,(%eax)
    810a:	00 00                	add    %al,(%eax)
    810c:	00 00                	add    %al,(%eax)
    810e:	00 00                	add    %al,(%eax)
    8110:	00 00                	add    %al,(%eax)
    8112:	00 00                	add    %al,(%eax)
    8114:	00 00                	add    %al,(%eax)
    8116:	00 00                	add    %al,(%eax)
    8118:	00 00                	add    %al,(%eax)
    811a:	00 00                	add    %al,(%eax)
    811c:	00 00                	add    %al,(%eax)
    811e:	00 00                	add    %al,(%eax)
    8120:	00 00                	add    %al,(%eax)
    8122:	00 00                	add    %al,(%eax)
    8124:	00 00                	add    %al,(%eax)
    8126:	00 00                	add    %al,(%eax)
    8128:	00 00                	add    %al,(%eax)
    812a:	00 00                	add    %al,(%eax)
    812c:	00 00                	add    %al,(%eax)
    812e:	00 00                	add    %al,(%eax)
    8130:	00 00                	add    %al,(%eax)
    8132:	00 00                	add    %al,(%eax)
    8134:	00 00                	add    %al,(%eax)
    8136:	00 00                	add    %al,(%eax)
    8138:	00 00                	add    %al,(%eax)
    813a:	00 00                	add    %al,(%eax)
    813c:	00 00                	add    %al,(%eax)
    813e:	00 00                	add    %al,(%eax)
    8140:	00 00                	add    %al,(%eax)
    8142:	00 00                	add    %al,(%eax)
    8144:	00 00                	add    %al,(%eax)
    8146:	00 00                	add    %al,(%eax)
    8148:	00 00                	add    %al,(%eax)
    814a:	00 00                	add    %al,(%eax)
    814c:	00 00                	add    %al,(%eax)
    814e:	00 00                	add    %al,(%eax)
    8150:	00 00                	add    %al,(%eax)
    8152:	00 00                	add    %al,(%eax)
    8154:	00 00                	add    %al,(%eax)
    8156:	00 00                	add    %al,(%eax)
    8158:	00 00                	add    %al,(%eax)
    815a:	00 00                	add    %al,(%eax)
    815c:	00 00                	add    %al,(%eax)
    815e:	00 00                	add    %al,(%eax)
    8160:	00 00                	add    %al,(%eax)
    8162:	00 00                	add    %al,(%eax)
    8164:	00 00                	add    %al,(%eax)
    8166:	00 00                	add    %al,(%eax)
    8168:	00 00                	add    %al,(%eax)
    816a:	00 00                	add    %al,(%eax)
    816c:	00 00                	add    %al,(%eax)
    816e:	00 00                	add    %al,(%eax)
    8170:	00 00                	add    %al,(%eax)
    8172:	00 00                	add    %al,(%eax)
    8174:	00 00                	add    %al,(%eax)
    8176:	00 00                	add    %al,(%eax)
    8178:	00 00                	add    %al,(%eax)
    817a:	00 00                	add    %al,(%eax)
    817c:	00 00                	add    %al,(%eax)
    817e:	00 00                	add    %al,(%eax)
    8180:	00 00                	add    %al,(%eax)
    8182:	00 00                	add    %al,(%eax)
    8184:	00 00                	add    %al,(%eax)
    8186:	00 00                	add    %al,(%eax)
    8188:	00 00                	add    %al,(%eax)
    818a:	00 00                	add    %al,(%eax)
    818c:	00 00                	add    %al,(%eax)
    818e:	00 00                	add    %al,(%eax)
    8190:	00 00                	add    %al,(%eax)
    8192:	00 00                	add    %al,(%eax)
    8194:	00 00                	add    %al,(%eax)
    8196:	00 00                	add    %al,(%eax)
    8198:	00 00                	add    %al,(%eax)
    819a:	00 00                	add    %al,(%eax)
    819c:	00 00                	add    %al,(%eax)
    819e:	00 00                	add    %al,(%eax)
    81a0:	00 00                	add    %al,(%eax)
    81a2:	00 00                	add    %al,(%eax)
    81a4:	00 00                	add    %al,(%eax)
    81a6:	00 00                	add    %al,(%eax)
    81a8:	00 00                	add    %al,(%eax)
    81aa:	00 00                	add    %al,(%eax)
    81ac:	00 00                	add    %al,(%eax)
    81ae:	00 00                	add    %al,(%eax)
    81b0:	00 00                	add    %al,(%eax)
    81b2:	00 00                	add    %al,(%eax)
    81b4:	00 00                	add    %al,(%eax)
    81b6:	00 00                	add    %al,(%eax)
    81b8:	00 00                	add    %al,(%eax)
    81ba:	00 00                	add    %al,(%eax)
    81bc:	00 00                	add    %al,(%eax)
    81be:	00 00                	add    %al,(%eax)
    81c0:	00 00                	add    %al,(%eax)
    81c2:	00 00                	add    %al,(%eax)
    81c4:	00 00                	add    %al,(%eax)
    81c6:	00 00                	add    %al,(%eax)
    81c8:	00 00                	add    %al,(%eax)
    81ca:	00 00                	add    %al,(%eax)
    81cc:	00 00                	add    %al,(%eax)
    81ce:	00 00                	add    %al,(%eax)
    81d0:	00 00                	add    %al,(%eax)
    81d2:	00 00                	add    %al,(%eax)
    81d4:	00 00                	add    %al,(%eax)
    81d6:	00 00                	add    %al,(%eax)
    81d8:	00 00                	add    %al,(%eax)
    81da:	00 00                	add    %al,(%eax)
    81dc:	00 00                	add    %al,(%eax)
    81de:	00 00                	add    %al,(%eax)
    81e0:	00 00                	add    %al,(%eax)
    81e2:	00 00                	add    %al,(%eax)
    81e4:	00 00                	add    %al,(%eax)
    81e6:	00 00                	add    %al,(%eax)
    81e8:	00 00                	add    %al,(%eax)
    81ea:	00 00                	add    %al,(%eax)
    81ec:	00 00                	add    %al,(%eax)
    81ee:	00 00                	add    %al,(%eax)
    81f0:	00 00                	add    %al,(%eax)
    81f2:	00 00                	add    %al,(%eax)
    81f4:	00 00                	add    %al,(%eax)
    81f6:	00 00                	add    %al,(%eax)
    81f8:	00 00                	add    %al,(%eax)
    81fa:	00 00                	add    %al,(%eax)
    81fc:	00 00                	add    %al,(%eax)
    81fe:	00 00                	add    %al,(%eax)
    8200:	00 00                	add    %al,(%eax)
    8202:	00 00                	add    %al,(%eax)
    8204:	00 00                	add    %al,(%eax)
    8206:	00 00                	add    %al,(%eax)
    8208:	00 00                	add    %al,(%eax)
    820a:	00 00                	add    %al,(%eax)
    820c:	00 00                	add    %al,(%eax)
    820e:	00 00                	add    %al,(%eax)
    8210:	00 00                	add    %al,(%eax)
    8212:	00 00                	add    %al,(%eax)
    8214:	00 00                	add    %al,(%eax)
    8216:	00 00                	add    %al,(%eax)
    8218:	00 00                	add    %al,(%eax)
    821a:	00 00                	add    %al,(%eax)
    821c:	00 00                	add    %al,(%eax)
    821e:	00 00                	add    %al,(%eax)
    8220:	00 00                	add    %al,(%eax)
    8222:	00 00                	add    %al,(%eax)
    8224:	00 00                	add    %al,(%eax)
    8226:	00 00                	add    %al,(%eax)
    8228:	00 00                	add    %al,(%eax)
    822a:	00 00                	add    %al,(%eax)
    822c:	00 00                	add    %al,(%eax)
    822e:	00 00                	add    %al,(%eax)
    8230:	00 00                	add    %al,(%eax)
    8232:	00 00                	add    %al,(%eax)
    8234:	00 00                	add    %al,(%eax)
    8236:	00 00                	add    %al,(%eax)
    8238:	00 00                	add    %al,(%eax)
    823a:	00 00                	add    %al,(%eax)
    823c:	00 00                	add    %al,(%eax)
    823e:	00 00                	add    %al,(%eax)
    8240:	00 00                	add    %al,(%eax)
    8242:	00 00                	add    %al,(%eax)
    8244:	00 00                	add    %al,(%eax)
    8246:	00 00                	add    %al,(%eax)
    8248:	00 00                	add    %al,(%eax)
    824a:	00 00                	add    %al,(%eax)
    824c:	00 00                	add    %al,(%eax)
    824e:	00 00                	add    %al,(%eax)
    8250:	00 00                	add    %al,(%eax)
    8252:	00 00                	add    %al,(%eax)
    8254:	00 00                	add    %al,(%eax)
    8256:	00 00                	add    %al,(%eax)
    8258:	00 00                	add    %al,(%eax)
    825a:	00 00                	add    %al,(%eax)
    825c:	00 00                	add    %al,(%eax)
    825e:	00 00                	add    %al,(%eax)
    8260:	00 00                	add    %al,(%eax)
    8262:	00 00                	add    %al,(%eax)
    8264:	00 00                	add    %al,(%eax)
    8266:	00 00                	add    %al,(%eax)
    8268:	00 00                	add    %al,(%eax)
    826a:	00 00                	add    %al,(%eax)
    826c:	00 00                	add    %al,(%eax)
    826e:	00 00                	add    %al,(%eax)
    8270:	00 00                	add    %al,(%eax)
    8272:	00 00                	add    %al,(%eax)
    8274:	00 00                	add    %al,(%eax)
    8276:	00 00                	add    %al,(%eax)
    8278:	00 00                	add    %al,(%eax)
    827a:	00 00                	add    %al,(%eax)
    827c:	00 00                	add    %al,(%eax)
    827e:	00 00                	add    %al,(%eax)
    8280:	00 00                	add    %al,(%eax)
    8282:	00 00                	add    %al,(%eax)
    8284:	00 00                	add    %al,(%eax)
    8286:	00 00                	add    %al,(%eax)
    8288:	00 00                	add    %al,(%eax)
    828a:	00 00                	add    %al,(%eax)
    828c:	00 00                	add    %al,(%eax)
    828e:	00 00                	add    %al,(%eax)
    8290:	00 00                	add    %al,(%eax)
    8292:	00 00                	add    %al,(%eax)
    8294:	00 00                	add    %al,(%eax)
    8296:	00 00                	add    %al,(%eax)
    8298:	00 00                	add    %al,(%eax)
    829a:	00 00                	add    %al,(%eax)
    829c:	00 00                	add    %al,(%eax)
    829e:	00 00                	add    %al,(%eax)
    82a0:	00 00                	add    %al,(%eax)
    82a2:	00 00                	add    %al,(%eax)
    82a4:	00 00                	add    %al,(%eax)
    82a6:	00 00                	add    %al,(%eax)
    82a8:	00 00                	add    %al,(%eax)
    82aa:	00 00                	add    %al,(%eax)
    82ac:	00 00                	add    %al,(%eax)
    82ae:	00 00                	add    %al,(%eax)
    82b0:	00 00                	add    %al,(%eax)
    82b2:	00 00                	add    %al,(%eax)
    82b4:	00 00                	add    %al,(%eax)
    82b6:	00 00                	add    %al,(%eax)
    82b8:	00 00                	add    %al,(%eax)
    82ba:	00 00                	add    %al,(%eax)
    82bc:	00 00                	add    %al,(%eax)
    82be:	00 00                	add    %al,(%eax)
    82c0:	00 00                	add    %al,(%eax)
    82c2:	00 00                	add    %al,(%eax)
    82c4:	00 00                	add    %al,(%eax)
    82c6:	00 00                	add    %al,(%eax)
    82c8:	00 00                	add    %al,(%eax)
    82ca:	00 00                	add    %al,(%eax)
    82cc:	00 00                	add    %al,(%eax)
    82ce:	00 00                	add    %al,(%eax)
    82d0:	00 00                	add    %al,(%eax)
    82d2:	00 00                	add    %al,(%eax)
    82d4:	00 00                	add    %al,(%eax)
    82d6:	00 00                	add    %al,(%eax)
    82d8:	00 00                	add    %al,(%eax)
    82da:	00 00                	add    %al,(%eax)
    82dc:	00 00                	add    %al,(%eax)
    82de:	00 00                	add    %al,(%eax)
    82e0:	00 00                	add    %al,(%eax)
    82e2:	00 00                	add    %al,(%eax)
    82e4:	00 00                	add    %al,(%eax)
    82e6:	00 00                	add    %al,(%eax)
    82e8:	00 00                	add    %al,(%eax)
    82ea:	00 00                	add    %al,(%eax)
    82ec:	00 00                	add    %al,(%eax)
    82ee:	00 00                	add    %al,(%eax)
    82f0:	00 00                	add    %al,(%eax)
    82f2:	00 00                	add    %al,(%eax)
    82f4:	00 00                	add    %al,(%eax)
    82f6:	00 00                	add    %al,(%eax)
    82f8:	00 00                	add    %al,(%eax)
    82fa:	00 00                	add    %al,(%eax)
    82fc:	00 00                	add    %al,(%eax)
    82fe:	00 00                	add    %al,(%eax)
    8300:	00 00                	add    %al,(%eax)
    8302:	00 00                	add    %al,(%eax)
    8304:	00 00                	add    %al,(%eax)
    8306:	00 00                	add    %al,(%eax)
    8308:	00 00                	add    %al,(%eax)
    830a:	00 00                	add    %al,(%eax)
    830c:	00 00                	add    %al,(%eax)
    830e:	00 00                	add    %al,(%eax)
    8310:	00 00                	add    %al,(%eax)
    8312:	00 00                	add    %al,(%eax)
    8314:	00 00                	add    %al,(%eax)
    8316:	00 00                	add    %al,(%eax)
    8318:	00 00                	add    %al,(%eax)
    831a:	00 00                	add    %al,(%eax)
    831c:	00 00                	add    %al,(%eax)
    831e:	00 00                	add    %al,(%eax)
    8320:	00 00                	add    %al,(%eax)
    8322:	00 00                	add    %al,(%eax)
    8324:	00 00                	add    %al,(%eax)
    8326:	00 00                	add    %al,(%eax)
    8328:	00 00                	add    %al,(%eax)
    832a:	00 00                	add    %al,(%eax)
    832c:	00 00                	add    %al,(%eax)
    832e:	00 00                	add    %al,(%eax)
    8330:	00 00                	add    %al,(%eax)
    8332:	00 00                	add    %al,(%eax)
    8334:	00 00                	add    %al,(%eax)
    8336:	00 00                	add    %al,(%eax)
    8338:	00 00                	add    %al,(%eax)
    833a:	00 00                	add    %al,(%eax)
    833c:	00 00                	add    %al,(%eax)
    833e:	00 00                	add    %al,(%eax)
    8340:	00 00                	add    %al,(%eax)
    8342:	00 00                	add    %al,(%eax)
    8344:	00 00                	add    %al,(%eax)
    8346:	00 00                	add    %al,(%eax)
    8348:	00 00                	add    %al,(%eax)
    834a:	00 00                	add    %al,(%eax)
    834c:	00 00                	add    %al,(%eax)
    834e:	00 00                	add    %al,(%eax)
    8350:	00 00                	add    %al,(%eax)
    8352:	00 00                	add    %al,(%eax)
    8354:	00 00                	add    %al,(%eax)
    8356:	00 00                	add    %al,(%eax)
    8358:	00 00                	add    %al,(%eax)
    835a:	00 00                	add    %al,(%eax)
    835c:	00 00                	add    %al,(%eax)
    835e:	00 00                	add    %al,(%eax)
    8360:	00 00                	add    %al,(%eax)
    8362:	00 00                	add    %al,(%eax)
    8364:	00 00                	add    %al,(%eax)
    8366:	00 00                	add    %al,(%eax)
    8368:	00 00                	add    %al,(%eax)
    836a:	00 00                	add    %al,(%eax)
    836c:	00 00                	add    %al,(%eax)
    836e:	00 00                	add    %al,(%eax)
    8370:	00 00                	add    %al,(%eax)
    8372:	00 00                	add    %al,(%eax)
    8374:	00 00                	add    %al,(%eax)
    8376:	00 00                	add    %al,(%eax)
    8378:	00 00                	add    %al,(%eax)
    837a:	00 00                	add    %al,(%eax)
    837c:	00 00                	add    %al,(%eax)
    837e:	00 00                	add    %al,(%eax)
    8380:	00 00                	add    %al,(%eax)
    8382:	00 00                	add    %al,(%eax)
    8384:	00 00                	add    %al,(%eax)
    8386:	00 00                	add    %al,(%eax)
    8388:	00 00                	add    %al,(%eax)
    838a:	00 00                	add    %al,(%eax)
    838c:	00 00                	add    %al,(%eax)
    838e:	00 00                	add    %al,(%eax)
    8390:	00 00                	add    %al,(%eax)
    8392:	00 00                	add    %al,(%eax)
    8394:	00 00                	add    %al,(%eax)
    8396:	00 00                	add    %al,(%eax)
    8398:	00 00                	add    %al,(%eax)
    839a:	00 00                	add    %al,(%eax)
    839c:	00 00                	add    %al,(%eax)
    839e:	00 00                	add    %al,(%eax)
    83a0:	00 00                	add    %al,(%eax)
    83a2:	00 00                	add    %al,(%eax)
    83a4:	00 00                	add    %al,(%eax)
    83a6:	00 00                	add    %al,(%eax)
    83a8:	00 00                	add    %al,(%eax)
    83aa:	00 00                	add    %al,(%eax)
    83ac:	00 00                	add    %al,(%eax)
    83ae:	00 00                	add    %al,(%eax)
    83b0:	00 00                	add    %al,(%eax)
    83b2:	00 00                	add    %al,(%eax)
    83b4:	00 00                	add    %al,(%eax)
    83b6:	00 00                	add    %al,(%eax)
    83b8:	00 00                	add    %al,(%eax)
    83ba:	00 00                	add    %al,(%eax)
    83bc:	00 00                	add    %al,(%eax)
    83be:	00 00                	add    %al,(%eax)
    83c0:	00 00                	add    %al,(%eax)
    83c2:	00 00                	add    %al,(%eax)
    83c4:	00 00                	add    %al,(%eax)
    83c6:	00 00                	add    %al,(%eax)
    83c8:	00 00                	add    %al,(%eax)
    83ca:	00 00                	add    %al,(%eax)
    83cc:	00 00                	add    %al,(%eax)
    83ce:	00 00                	add    %al,(%eax)
    83d0:	00 00                	add    %al,(%eax)
    83d2:	00 00                	add    %al,(%eax)
    83d4:	00 00                	add    %al,(%eax)
    83d6:	00 00                	add    %al,(%eax)
    83d8:	00 00                	add    %al,(%eax)
    83da:	00 00                	add    %al,(%eax)
    83dc:	00 00                	add    %al,(%eax)
    83de:	00 00                	add    %al,(%eax)
    83e0:	00 00                	add    %al,(%eax)
    83e2:	00 00                	add    %al,(%eax)
    83e4:	00 00                	add    %al,(%eax)
    83e6:	00 00                	add    %al,(%eax)
    83e8:	00 00                	add    %al,(%eax)
    83ea:	00 00                	add    %al,(%eax)
    83ec:	00 00                	add    %al,(%eax)
    83ee:	00 00                	add    %al,(%eax)
    83f0:	00 00                	add    %al,(%eax)
    83f2:	00 00                	add    %al,(%eax)
    83f4:	00 00                	add    %al,(%eax)
    83f6:	00 00                	add    %al,(%eax)
    83f8:	00 00                	add    %al,(%eax)
    83fa:	00 00                	add    %al,(%eax)
    83fc:	00 00                	add    %al,(%eax)
    83fe:	00 00                	add    %al,(%eax)
    8400:	00 00                	add    %al,(%eax)
    8402:	00 00                	add    %al,(%eax)
    8404:	00 00                	add    %al,(%eax)
    8406:	00 00                	add    %al,(%eax)
    8408:	00 00                	add    %al,(%eax)
    840a:	00 00                	add    %al,(%eax)
    840c:	00 00                	add    %al,(%eax)
    840e:	00 00                	add    %al,(%eax)
    8410:	00 00                	add    %al,(%eax)
    8412:	00 00                	add    %al,(%eax)
    8414:	00 00                	add    %al,(%eax)
    8416:	00 00                	add    %al,(%eax)
    8418:	00 00                	add    %al,(%eax)
    841a:	00 00                	add    %al,(%eax)
    841c:	00 00                	add    %al,(%eax)
    841e:	00 00                	add    %al,(%eax)
    8420:	00 00                	add    %al,(%eax)
    8422:	00 00                	add    %al,(%eax)
    8424:	00 00                	add    %al,(%eax)
    8426:	00 00                	add    %al,(%eax)
    8428:	00 00                	add    %al,(%eax)
    842a:	00 00                	add    %al,(%eax)
    842c:	00 00                	add    %al,(%eax)
    842e:	00 00                	add    %al,(%eax)
    8430:	00 00                	add    %al,(%eax)
    8432:	00 00                	add    %al,(%eax)
    8434:	00 00                	add    %al,(%eax)
    8436:	00 00                	add    %al,(%eax)
    8438:	00 00                	add    %al,(%eax)
    843a:	00 00                	add    %al,(%eax)
    843c:	00 00                	add    %al,(%eax)
    843e:	00 00                	add    %al,(%eax)
    8440:	00 00                	add    %al,(%eax)
    8442:	00 00                	add    %al,(%eax)
    8444:	00 00                	add    %al,(%eax)
    8446:	00 00                	add    %al,(%eax)
    8448:	00 00                	add    %al,(%eax)
    844a:	00 00                	add    %al,(%eax)
    844c:	00 00                	add    %al,(%eax)
    844e:	00 00                	add    %al,(%eax)
    8450:	00 00                	add    %al,(%eax)
    8452:	00 00                	add    %al,(%eax)
    8454:	00 00                	add    %al,(%eax)
    8456:	00 00                	add    %al,(%eax)
    8458:	00 00                	add    %al,(%eax)
    845a:	00 00                	add    %al,(%eax)
    845c:	00 00                	add    %al,(%eax)
    845e:	00 00                	add    %al,(%eax)
    8460:	00 00                	add    %al,(%eax)
    8462:	00 00                	add    %al,(%eax)
    8464:	00 00                	add    %al,(%eax)
    8466:	00 00                	add    %al,(%eax)
    8468:	00 00                	add    %al,(%eax)
    846a:	00 00                	add    %al,(%eax)
    846c:	00 00                	add    %al,(%eax)
    846e:	00 00                	add    %al,(%eax)
    8470:	00 00                	add    %al,(%eax)
    8472:	00 00                	add    %al,(%eax)
    8474:	00 00                	add    %al,(%eax)
    8476:	00 00                	add    %al,(%eax)
    8478:	00 00                	add    %al,(%eax)
    847a:	00 00                	add    %al,(%eax)
    847c:	00 00                	add    %al,(%eax)
    847e:	00 00                	add    %al,(%eax)
    8480:	00 00                	add    %al,(%eax)
    8482:	00 00                	add    %al,(%eax)
    8484:	00 00                	add    %al,(%eax)
    8486:	00 00                	add    %al,(%eax)
    8488:	00 00                	add    %al,(%eax)
    848a:	00 00                	add    %al,(%eax)
    848c:	00 00                	add    %al,(%eax)
    848e:	00 00                	add    %al,(%eax)
    8490:	00 00                	add    %al,(%eax)
    8492:	00 00                	add    %al,(%eax)
    8494:	00 00                	add    %al,(%eax)
    8496:	00 00                	add    %al,(%eax)
    8498:	00 00                	add    %al,(%eax)
    849a:	00 00                	add    %al,(%eax)
    849c:	00 00                	add    %al,(%eax)
    849e:	00 00                	add    %al,(%eax)
    84a0:	00 00                	add    %al,(%eax)
    84a2:	00 00                	add    %al,(%eax)
    84a4:	00 00                	add    %al,(%eax)
    84a6:	00 00                	add    %al,(%eax)
    84a8:	00 00                	add    %al,(%eax)
    84aa:	00 00                	add    %al,(%eax)
    84ac:	00 00                	add    %al,(%eax)
    84ae:	00 00                	add    %al,(%eax)
    84b0:	00 00                	add    %al,(%eax)
    84b2:	00 00                	add    %al,(%eax)
    84b4:	00 00                	add    %al,(%eax)
    84b6:	00 00                	add    %al,(%eax)
    84b8:	00 00                	add    %al,(%eax)
    84ba:	00 00                	add    %al,(%eax)
    84bc:	00 00                	add    %al,(%eax)
    84be:	00 00                	add    %al,(%eax)
    84c0:	00 00                	add    %al,(%eax)
    84c2:	00 00                	add    %al,(%eax)
    84c4:	00 00                	add    %al,(%eax)
    84c6:	00 00                	add    %al,(%eax)
    84c8:	00 00                	add    %al,(%eax)
    84ca:	00 00                	add    %al,(%eax)
    84cc:	00 00                	add    %al,(%eax)
    84ce:	00 00                	add    %al,(%eax)
    84d0:	00 00                	add    %al,(%eax)
    84d2:	00 00                	add    %al,(%eax)
    84d4:	00 00                	add    %al,(%eax)
    84d6:	00 00                	add    %al,(%eax)
    84d8:	00 00                	add    %al,(%eax)
    84da:	00 00                	add    %al,(%eax)
    84dc:	00 00                	add    %al,(%eax)
    84de:	00 00                	add    %al,(%eax)
    84e0:	00 00                	add    %al,(%eax)
    84e2:	00 00                	add    %al,(%eax)
    84e4:	00 00                	add    %al,(%eax)
    84e6:	00 00                	add    %al,(%eax)
    84e8:	00 00                	add    %al,(%eax)
    84ea:	00 00                	add    %al,(%eax)
    84ec:	00 00                	add    %al,(%eax)
    84ee:	00 00                	add    %al,(%eax)
    84f0:	00 00                	add    %al,(%eax)
    84f2:	00 00                	add    %al,(%eax)
    84f4:	00 00                	add    %al,(%eax)
    84f6:	00 00                	add    %al,(%eax)
    84f8:	00 00                	add    %al,(%eax)
    84fa:	00 00                	add    %al,(%eax)
    84fc:	00 00                	add    %al,(%eax)
    84fe:	00 00                	add    %al,(%eax)
    8500:	00 00                	add    %al,(%eax)
    8502:	00 00                	add    %al,(%eax)
    8504:	00 00                	add    %al,(%eax)
    8506:	00 00                	add    %al,(%eax)
    8508:	00 00                	add    %al,(%eax)
    850a:	00 00                	add    %al,(%eax)
    850c:	00 00                	add    %al,(%eax)
    850e:	00 00                	add    %al,(%eax)
    8510:	00 00                	add    %al,(%eax)
    8512:	00 00                	add    %al,(%eax)
    8514:	00 00                	add    %al,(%eax)
    8516:	00 00                	add    %al,(%eax)
    8518:	00 00                	add    %al,(%eax)
    851a:	00 00                	add    %al,(%eax)
    851c:	00 00                	add    %al,(%eax)
    851e:	00 00                	add    %al,(%eax)
    8520:	00 00                	add    %al,(%eax)
    8522:	00 00                	add    %al,(%eax)
    8524:	00 00                	add    %al,(%eax)
    8526:	00 00                	add    %al,(%eax)
    8528:	00 00                	add    %al,(%eax)
    852a:	00 00                	add    %al,(%eax)
    852c:	00 00                	add    %al,(%eax)
    852e:	00 00                	add    %al,(%eax)
    8530:	00 00                	add    %al,(%eax)
    8532:	00 00                	add    %al,(%eax)
    8534:	00 00                	add    %al,(%eax)
    8536:	00 00                	add    %al,(%eax)
    8538:	00 00                	add    %al,(%eax)
    853a:	00 00                	add    %al,(%eax)
    853c:	00 00                	add    %al,(%eax)
    853e:	00 00                	add    %al,(%eax)
    8540:	00 00                	add    %al,(%eax)
    8542:	00 00                	add    %al,(%eax)
    8544:	00 00                	add    %al,(%eax)
    8546:	00 00                	add    %al,(%eax)
    8548:	00 00                	add    %al,(%eax)
    854a:	00 00                	add    %al,(%eax)
    854c:	00 00                	add    %al,(%eax)
    854e:	00 00                	add    %al,(%eax)
    8550:	00 00                	add    %al,(%eax)
    8552:	00 00                	add    %al,(%eax)
    8554:	00 00                	add    %al,(%eax)
    8556:	00 00                	add    %al,(%eax)
    8558:	00 00                	add    %al,(%eax)
    855a:	00 00                	add    %al,(%eax)
    855c:	00 00                	add    %al,(%eax)
    855e:	00 00                	add    %al,(%eax)
    8560:	00 00                	add    %al,(%eax)
    8562:	00 00                	add    %al,(%eax)
    8564:	00 00                	add    %al,(%eax)
    8566:	00 00                	add    %al,(%eax)
    8568:	00 00                	add    %al,(%eax)
    856a:	00 00                	add    %al,(%eax)
    856c:	00 00                	add    %al,(%eax)
    856e:	00 00                	add    %al,(%eax)
    8570:	00 00                	add    %al,(%eax)
    8572:	00 00                	add    %al,(%eax)
    8574:	00 00                	add    %al,(%eax)
    8576:	00 00                	add    %al,(%eax)
    8578:	00 00                	add    %al,(%eax)
    857a:	00 00                	add    %al,(%eax)
    857c:	00 00                	add    %al,(%eax)
    857e:	00 00                	add    %al,(%eax)
    8580:	00 00                	add    %al,(%eax)
    8582:	00 00                	add    %al,(%eax)
    8584:	00 00                	add    %al,(%eax)
    8586:	00 00                	add    %al,(%eax)
    8588:	00 00                	add    %al,(%eax)
    858a:	00 00                	add    %al,(%eax)
    858c:	00 00                	add    %al,(%eax)
    858e:	00 00                	add    %al,(%eax)
    8590:	00 00                	add    %al,(%eax)
    8592:	00 00                	add    %al,(%eax)
    8594:	00 00                	add    %al,(%eax)
    8596:	00 00                	add    %al,(%eax)
    8598:	00 00                	add    %al,(%eax)
    859a:	00 00                	add    %al,(%eax)
    859c:	00 00                	add    %al,(%eax)
    859e:	00 00                	add    %al,(%eax)
    85a0:	00 00                	add    %al,(%eax)
    85a2:	00 00                	add    %al,(%eax)
    85a4:	00 00                	add    %al,(%eax)
    85a6:	00 00                	add    %al,(%eax)
    85a8:	00 00                	add    %al,(%eax)
    85aa:	00 00                	add    %al,(%eax)
    85ac:	00 00                	add    %al,(%eax)
    85ae:	00 00                	add    %al,(%eax)
    85b0:	00 00                	add    %al,(%eax)
    85b2:	00 00                	add    %al,(%eax)
    85b4:	00 00                	add    %al,(%eax)
    85b6:	00 00                	add    %al,(%eax)
    85b8:	00 00                	add    %al,(%eax)
    85ba:	00 00                	add    %al,(%eax)
    85bc:	00 00                	add    %al,(%eax)
    85be:	00 00                	add    %al,(%eax)
    85c0:	00 00                	add    %al,(%eax)
    85c2:	00 00                	add    %al,(%eax)
    85c4:	00 00                	add    %al,(%eax)
    85c6:	00 00                	add    %al,(%eax)
    85c8:	00 00                	add    %al,(%eax)
    85ca:	00 00                	add    %al,(%eax)
    85cc:	00 00                	add    %al,(%eax)
    85ce:	00 00                	add    %al,(%eax)
    85d0:	00 00                	add    %al,(%eax)
    85d2:	00 00                	add    %al,(%eax)
    85d4:	00 00                	add    %al,(%eax)
    85d6:	00 00                	add    %al,(%eax)
    85d8:	00 00                	add    %al,(%eax)
    85da:	00 00                	add    %al,(%eax)
    85dc:	00 00                	add    %al,(%eax)
    85de:	00 00                	add    %al,(%eax)
    85e0:	00 00                	add    %al,(%eax)
    85e2:	00 00                	add    %al,(%eax)
    85e4:	00 00                	add    %al,(%eax)
    85e6:	00 00                	add    %al,(%eax)
    85e8:	00 00                	add    %al,(%eax)
    85ea:	00 00                	add    %al,(%eax)
    85ec:	00 00                	add    %al,(%eax)
    85ee:	00 00                	add    %al,(%eax)
    85f0:	00 00                	add    %al,(%eax)
    85f2:	00 00                	add    %al,(%eax)
    85f4:	00 00                	add    %al,(%eax)
    85f6:	00 00                	add    %al,(%eax)
    85f8:	00 00                	add    %al,(%eax)
    85fa:	00 00                	add    %al,(%eax)
    85fc:	00 00                	add    %al,(%eax)
    85fe:	00 00                	add    %al,(%eax)
    8600:	00 00                	add    %al,(%eax)
    8602:	00 00                	add    %al,(%eax)
    8604:	00 00                	add    %al,(%eax)
    8606:	00 00                	add    %al,(%eax)
    8608:	00 00                	add    %al,(%eax)
    860a:	00 00                	add    %al,(%eax)
    860c:	00 00                	add    %al,(%eax)
    860e:	00 00                	add    %al,(%eax)
    8610:	00 00                	add    %al,(%eax)
    8612:	00 00                	add    %al,(%eax)
    8614:	00 00                	add    %al,(%eax)
    8616:	00 00                	add    %al,(%eax)
    8618:	00 00                	add    %al,(%eax)
    861a:	00 00                	add    %al,(%eax)
    861c:	00 00                	add    %al,(%eax)
    861e:	00 00                	add    %al,(%eax)
    8620:	00 00                	add    %al,(%eax)
    8622:	00 00                	add    %al,(%eax)
    8624:	00 00                	add    %al,(%eax)
    8626:	00 00                	add    %al,(%eax)
    8628:	00 00                	add    %al,(%eax)
    862a:	00 00                	add    %al,(%eax)
    862c:	00 00                	add    %al,(%eax)
    862e:	00 00                	add    %al,(%eax)
    8630:	00 00                	add    %al,(%eax)
    8632:	00 00                	add    %al,(%eax)
    8634:	00 00                	add    %al,(%eax)
    8636:	00 00                	add    %al,(%eax)
    8638:	00 00                	add    %al,(%eax)
    863a:	00 00                	add    %al,(%eax)
    863c:	00 00                	add    %al,(%eax)
    863e:	00 00                	add    %al,(%eax)
    8640:	00 00                	add    %al,(%eax)
    8642:	00 00                	add    %al,(%eax)
    8644:	00 00                	add    %al,(%eax)
    8646:	00 00                	add    %al,(%eax)
    8648:	00 00                	add    %al,(%eax)
    864a:	00 00                	add    %al,(%eax)
    864c:	00 00                	add    %al,(%eax)
    864e:	00 00                	add    %al,(%eax)
    8650:	00 00                	add    %al,(%eax)
    8652:	00 00                	add    %al,(%eax)
    8654:	00 00                	add    %al,(%eax)
    8656:	00 00                	add    %al,(%eax)
    8658:	00 00                	add    %al,(%eax)
    865a:	00 00                	add    %al,(%eax)
    865c:	00 00                	add    %al,(%eax)
    865e:	00 00                	add    %al,(%eax)
    8660:	00 00                	add    %al,(%eax)
    8662:	00 00                	add    %al,(%eax)
    8664:	00 00                	add    %al,(%eax)
    8666:	00 00                	add    %al,(%eax)
    8668:	00 00                	add    %al,(%eax)
    866a:	00 00                	add    %al,(%eax)
    866c:	00 00                	add    %al,(%eax)
    866e:	00 00                	add    %al,(%eax)
    8670:	00 00                	add    %al,(%eax)
    8672:	00 00                	add    %al,(%eax)
    8674:	00 00                	add    %al,(%eax)
    8676:	00 00                	add    %al,(%eax)
    8678:	00 00                	add    %al,(%eax)
    867a:	00 00                	add    %al,(%eax)
    867c:	00 00                	add    %al,(%eax)
    867e:	00 00                	add    %al,(%eax)
    8680:	00 00                	add    %al,(%eax)
    8682:	00 00                	add    %al,(%eax)
    8684:	00 00                	add    %al,(%eax)
    8686:	00 00                	add    %al,(%eax)
    8688:	00 00                	add    %al,(%eax)
    868a:	00 00                	add    %al,(%eax)
    868c:	00 00                	add    %al,(%eax)
    868e:	00 00                	add    %al,(%eax)
    8690:	00 00                	add    %al,(%eax)
    8692:	00 00                	add    %al,(%eax)
    8694:	00 00                	add    %al,(%eax)
    8696:	00 00                	add    %al,(%eax)
    8698:	00 00                	add    %al,(%eax)
    869a:	00 00                	add    %al,(%eax)
    869c:	00 00                	add    %al,(%eax)
    869e:	00 00                	add    %al,(%eax)
    86a0:	00 00                	add    %al,(%eax)
    86a2:	00 00                	add    %al,(%eax)
    86a4:	00 00                	add    %al,(%eax)
    86a6:	00 00                	add    %al,(%eax)
    86a8:	00 00                	add    %al,(%eax)
    86aa:	00 00                	add    %al,(%eax)
    86ac:	00 00                	add    %al,(%eax)
    86ae:	00 00                	add    %al,(%eax)
    86b0:	00 00                	add    %al,(%eax)
    86b2:	00 00                	add    %al,(%eax)
    86b4:	00 00                	add    %al,(%eax)
    86b6:	00 00                	add    %al,(%eax)
    86b8:	00 00                	add    %al,(%eax)
    86ba:	00 00                	add    %al,(%eax)
    86bc:	00 00                	add    %al,(%eax)
    86be:	00 00                	add    %al,(%eax)
    86c0:	00 00                	add    %al,(%eax)
    86c2:	00 00                	add    %al,(%eax)
    86c4:	00 00                	add    %al,(%eax)
    86c6:	00 00                	add    %al,(%eax)
    86c8:	00 00                	add    %al,(%eax)
    86ca:	00 00                	add    %al,(%eax)
    86cc:	00 00                	add    %al,(%eax)
    86ce:	00 00                	add    %al,(%eax)
    86d0:	00 00                	add    %al,(%eax)
    86d2:	00 00                	add    %al,(%eax)
    86d4:	00 00                	add    %al,(%eax)
    86d6:	00 00                	add    %al,(%eax)
    86d8:	00 00                	add    %al,(%eax)
    86da:	00 00                	add    %al,(%eax)
    86dc:	00 00                	add    %al,(%eax)
    86de:	00 00                	add    %al,(%eax)
    86e0:	00 00                	add    %al,(%eax)
    86e2:	00 00                	add    %al,(%eax)
    86e4:	00 00                	add    %al,(%eax)
    86e6:	00 00                	add    %al,(%eax)
    86e8:	00 00                	add    %al,(%eax)
    86ea:	00 00                	add    %al,(%eax)
    86ec:	00 00                	add    %al,(%eax)
    86ee:	00 00                	add    %al,(%eax)
    86f0:	00 00                	add    %al,(%eax)
    86f2:	00 00                	add    %al,(%eax)
    86f4:	00 00                	add    %al,(%eax)
    86f6:	00 00                	add    %al,(%eax)
    86f8:	00 00                	add    %al,(%eax)
    86fa:	00 00                	add    %al,(%eax)
    86fc:	00 00                	add    %al,(%eax)
    86fe:	00 00                	add    %al,(%eax)
    8700:	00 00                	add    %al,(%eax)
    8702:	00 00                	add    %al,(%eax)
    8704:	00 00                	add    %al,(%eax)
    8706:	00 00                	add    %al,(%eax)
    8708:	00 00                	add    %al,(%eax)
    870a:	00 00                	add    %al,(%eax)
    870c:	00 00                	add    %al,(%eax)
    870e:	00 00                	add    %al,(%eax)
    8710:	00 00                	add    %al,(%eax)
    8712:	00 00                	add    %al,(%eax)
    8714:	00 00                	add    %al,(%eax)
    8716:	00 00                	add    %al,(%eax)
    8718:	00 00                	add    %al,(%eax)
    871a:	00 00                	add    %al,(%eax)
    871c:	00 00                	add    %al,(%eax)
    871e:	00 00                	add    %al,(%eax)
    8720:	00 00                	add    %al,(%eax)
    8722:	00 00                	add    %al,(%eax)
    8724:	00 00                	add    %al,(%eax)
    8726:	00 00                	add    %al,(%eax)
    8728:	00 00                	add    %al,(%eax)
    872a:	00 00                	add    %al,(%eax)
    872c:	00 00                	add    %al,(%eax)
    872e:	00 00                	add    %al,(%eax)
    8730:	00 00                	add    %al,(%eax)
    8732:	00 00                	add    %al,(%eax)
    8734:	00 00                	add    %al,(%eax)
    8736:	00 00                	add    %al,(%eax)
    8738:	00 00                	add    %al,(%eax)
    873a:	00 00                	add    %al,(%eax)
    873c:	00 00                	add    %al,(%eax)
    873e:	00 00                	add    %al,(%eax)
    8740:	00 00                	add    %al,(%eax)
    8742:	00 00                	add    %al,(%eax)
    8744:	00 00                	add    %al,(%eax)
    8746:	00 00                	add    %al,(%eax)
    8748:	00 00                	add    %al,(%eax)
    874a:	00 00                	add    %al,(%eax)
    874c:	00 00                	add    %al,(%eax)
    874e:	00 00                	add    %al,(%eax)
    8750:	00 00                	add    %al,(%eax)
    8752:	00 00                	add    %al,(%eax)
    8754:	00 00                	add    %al,(%eax)
    8756:	00 00                	add    %al,(%eax)
    8758:	00 00                	add    %al,(%eax)
    875a:	00 00                	add    %al,(%eax)
    875c:	00 00                	add    %al,(%eax)
    875e:	00 00                	add    %al,(%eax)
    8760:	00 00                	add    %al,(%eax)
    8762:	00 00                	add    %al,(%eax)
    8764:	00 00                	add    %al,(%eax)
    8766:	00 00                	add    %al,(%eax)
    8768:	00 00                	add    %al,(%eax)
    876a:	00 00                	add    %al,(%eax)
    876c:	00 00                	add    %al,(%eax)
    876e:	00 00                	add    %al,(%eax)
    8770:	00 00                	add    %al,(%eax)
    8772:	00 00                	add    %al,(%eax)
    8774:	00 00                	add    %al,(%eax)
    8776:	00 00                	add    %al,(%eax)
    8778:	00 00                	add    %al,(%eax)
    877a:	00 00                	add    %al,(%eax)
    877c:	00 00                	add    %al,(%eax)
    877e:	00 00                	add    %al,(%eax)
    8780:	00 00                	add    %al,(%eax)
    8782:	00 00                	add    %al,(%eax)
    8784:	00 00                	add    %al,(%eax)
    8786:	00 00                	add    %al,(%eax)
    8788:	00 00                	add    %al,(%eax)
    878a:	00 00                	add    %al,(%eax)
    878c:	00 00                	add    %al,(%eax)
    878e:	00 00                	add    %al,(%eax)
    8790:	00 00                	add    %al,(%eax)
    8792:	00 00                	add    %al,(%eax)
    8794:	00 00                	add    %al,(%eax)
    8796:	00 00                	add    %al,(%eax)
    8798:	00 00                	add    %al,(%eax)
    879a:	00 00                	add    %al,(%eax)
    879c:	00 00                	add    %al,(%eax)
    879e:	00 00                	add    %al,(%eax)
    87a0:	00 00                	add    %al,(%eax)
    87a2:	00 00                	add    %al,(%eax)
    87a4:	00 00                	add    %al,(%eax)
    87a6:	00 00                	add    %al,(%eax)
    87a8:	00 00                	add    %al,(%eax)
    87aa:	00 00                	add    %al,(%eax)
    87ac:	00 00                	add    %al,(%eax)
    87ae:	00 00                	add    %al,(%eax)
    87b0:	00 00                	add    %al,(%eax)
    87b2:	00 00                	add    %al,(%eax)
    87b4:	00 00                	add    %al,(%eax)
    87b6:	00 00                	add    %al,(%eax)
    87b8:	00 00                	add    %al,(%eax)
    87ba:	00 00                	add    %al,(%eax)
    87bc:	00 00                	add    %al,(%eax)
    87be:	00 00                	add    %al,(%eax)
    87c0:	00 00                	add    %al,(%eax)
    87c2:	00 00                	add    %al,(%eax)
    87c4:	00 00                	add    %al,(%eax)
    87c6:	00 00                	add    %al,(%eax)
    87c8:	00 00                	add    %al,(%eax)
    87ca:	00 00                	add    %al,(%eax)
    87cc:	00 00                	add    %al,(%eax)
    87ce:	00 00                	add    %al,(%eax)
    87d0:	00 00                	add    %al,(%eax)
    87d2:	00 00                	add    %al,(%eax)
    87d4:	00 00                	add    %al,(%eax)
    87d6:	00 00                	add    %al,(%eax)
    87d8:	00 00                	add    %al,(%eax)
    87da:	00 00                	add    %al,(%eax)
    87dc:	00 00                	add    %al,(%eax)
    87de:	00 00                	add    %al,(%eax)
    87e0:	00 00                	add    %al,(%eax)
    87e2:	00 00                	add    %al,(%eax)
    87e4:	00 00                	add    %al,(%eax)
    87e6:	00 00                	add    %al,(%eax)
    87e8:	00 00                	add    %al,(%eax)
    87ea:	00 00                	add    %al,(%eax)
    87ec:	00 00                	add    %al,(%eax)
    87ee:	00 00                	add    %al,(%eax)
    87f0:	00 00                	add    %al,(%eax)
    87f2:	00 00                	add    %al,(%eax)
    87f4:	00 00                	add    %al,(%eax)
    87f6:	00 00                	add    %al,(%eax)
    87f8:	00 00                	add    %al,(%eax)
    87fa:	00 00                	add    %al,(%eax)
    87fc:	00 00                	add    %al,(%eax)
    87fe:	00 00                	add    %al,(%eax)
    8800:	00 00                	add    %al,(%eax)
    8802:	00 00                	add    %al,(%eax)
    8804:	00 00                	add    %al,(%eax)
    8806:	00 00                	add    %al,(%eax)
    8808:	00 00                	add    %al,(%eax)
    880a:	00 00                	add    %al,(%eax)
    880c:	00 00                	add    %al,(%eax)
    880e:	00 00                	add    %al,(%eax)
    8810:	00 00                	add    %al,(%eax)
    8812:	00 00                	add    %al,(%eax)
    8814:	00 00                	add    %al,(%eax)
    8816:	00 00                	add    %al,(%eax)
    8818:	00 00                	add    %al,(%eax)
    881a:	00 00                	add    %al,(%eax)
    881c:	00 00                	add    %al,(%eax)
    881e:	00 00                	add    %al,(%eax)
    8820:	00 00                	add    %al,(%eax)
    8822:	00 00                	add    %al,(%eax)
    8824:	00 00                	add    %al,(%eax)
    8826:	00 00                	add    %al,(%eax)
    8828:	00 00                	add    %al,(%eax)
    882a:	00 00                	add    %al,(%eax)
    882c:	00 00                	add    %al,(%eax)
    882e:	00 00                	add    %al,(%eax)
    8830:	00 00                	add    %al,(%eax)
    8832:	00 00                	add    %al,(%eax)
    8834:	00 00                	add    %al,(%eax)
    8836:	00 00                	add    %al,(%eax)
    8838:	00 00                	add    %al,(%eax)
    883a:	00 00                	add    %al,(%eax)
    883c:	00 00                	add    %al,(%eax)
    883e:	00 00                	add    %al,(%eax)
    8840:	00 00                	add    %al,(%eax)
    8842:	00 00                	add    %al,(%eax)
    8844:	00 00                	add    %al,(%eax)
    8846:	00 00                	add    %al,(%eax)
    8848:	00 00                	add    %al,(%eax)
    884a:	00 00                	add    %al,(%eax)
    884c:	00 00                	add    %al,(%eax)
    884e:	00 00                	add    %al,(%eax)
    8850:	00 00                	add    %al,(%eax)
    8852:	00 00                	add    %al,(%eax)
    8854:	00 00                	add    %al,(%eax)
    8856:	00 00                	add    %al,(%eax)
    8858:	00 00                	add    %al,(%eax)
    885a:	00 00                	add    %al,(%eax)
    885c:	00 00                	add    %al,(%eax)
    885e:	00 00                	add    %al,(%eax)
    8860:	00 00                	add    %al,(%eax)
    8862:	00 00                	add    %al,(%eax)
    8864:	00 00                	add    %al,(%eax)
    8866:	00 00                	add    %al,(%eax)
    8868:	00 00                	add    %al,(%eax)
    886a:	00 00                	add    %al,(%eax)
    886c:	00 00                	add    %al,(%eax)
    886e:	00 00                	add    %al,(%eax)
    8870:	00 00                	add    %al,(%eax)
    8872:	00 00                	add    %al,(%eax)
    8874:	00 00                	add    %al,(%eax)
    8876:	00 00                	add    %al,(%eax)
    8878:	00 00                	add    %al,(%eax)
    887a:	00 00                	add    %al,(%eax)
    887c:	00 00                	add    %al,(%eax)
    887e:	00 00                	add    %al,(%eax)
    8880:	00 00                	add    %al,(%eax)
    8882:	00 00                	add    %al,(%eax)
    8884:	00 00                	add    %al,(%eax)
    8886:	00 00                	add    %al,(%eax)
    8888:	00 00                	add    %al,(%eax)
    888a:	00 00                	add    %al,(%eax)
    888c:	00 00                	add    %al,(%eax)
    888e:	00 00                	add    %al,(%eax)
    8890:	00 00                	add    %al,(%eax)
    8892:	00 00                	add    %al,(%eax)
    8894:	00 00                	add    %al,(%eax)
    8896:	00 00                	add    %al,(%eax)
    8898:	00 00                	add    %al,(%eax)
    889a:	00 00                	add    %al,(%eax)
    889c:	00 00                	add    %al,(%eax)
    889e:	00 00                	add    %al,(%eax)
    88a0:	00 00                	add    %al,(%eax)
    88a2:	00 00                	add    %al,(%eax)
    88a4:	00 00                	add    %al,(%eax)
    88a6:	00 00                	add    %al,(%eax)
    88a8:	00 00                	add    %al,(%eax)
    88aa:	00 00                	add    %al,(%eax)
    88ac:	00 00                	add    %al,(%eax)
    88ae:	00 00                	add    %al,(%eax)
    88b0:	00 00                	add    %al,(%eax)
    88b2:	00 00                	add    %al,(%eax)
    88b4:	00 00                	add    %al,(%eax)
    88b6:	00 00                	add    %al,(%eax)
    88b8:	00 00                	add    %al,(%eax)
    88ba:	00 00                	add    %al,(%eax)
    88bc:	00 00                	add    %al,(%eax)
    88be:	00 00                	add    %al,(%eax)
    88c0:	00 00                	add    %al,(%eax)
    88c2:	00 00                	add    %al,(%eax)
    88c4:	00 00                	add    %al,(%eax)
    88c6:	00 00                	add    %al,(%eax)
    88c8:	00 00                	add    %al,(%eax)
    88ca:	00 00                	add    %al,(%eax)
    88cc:	00 00                	add    %al,(%eax)
    88ce:	00 00                	add    %al,(%eax)
    88d0:	00 00                	add    %al,(%eax)
    88d2:	00 00                	add    %al,(%eax)
    88d4:	00 00                	add    %al,(%eax)
    88d6:	00 00                	add    %al,(%eax)
    88d8:	00 00                	add    %al,(%eax)
    88da:	00 00                	add    %al,(%eax)
    88dc:	00 00                	add    %al,(%eax)
    88de:	00 00                	add    %al,(%eax)
    88e0:	00 00                	add    %al,(%eax)
    88e2:	00 00                	add    %al,(%eax)
    88e4:	00 00                	add    %al,(%eax)
    88e6:	00 00                	add    %al,(%eax)
    88e8:	00 00                	add    %al,(%eax)
    88ea:	00 00                	add    %al,(%eax)
    88ec:	00 00                	add    %al,(%eax)
    88ee:	00 00                	add    %al,(%eax)
    88f0:	00 00                	add    %al,(%eax)
    88f2:	00 00                	add    %al,(%eax)
    88f4:	00 00                	add    %al,(%eax)
    88f6:	00 00                	add    %al,(%eax)
    88f8:	00 00                	add    %al,(%eax)
    88fa:	00 00                	add    %al,(%eax)
    88fc:	00 00                	add    %al,(%eax)
    88fe:	00 00                	add    %al,(%eax)
    8900:	00 00                	add    %al,(%eax)
    8902:	00 00                	add    %al,(%eax)
    8904:	00 00                	add    %al,(%eax)
    8906:	00 00                	add    %al,(%eax)
    8908:	00 00                	add    %al,(%eax)
    890a:	00 00                	add    %al,(%eax)
    890c:	00 00                	add    %al,(%eax)
    890e:	00 00                	add    %al,(%eax)
    8910:	00 00                	add    %al,(%eax)
    8912:	00 00                	add    %al,(%eax)
    8914:	00 00                	add    %al,(%eax)
    8916:	00 00                	add    %al,(%eax)
    8918:	00 00                	add    %al,(%eax)
    891a:	00 00                	add    %al,(%eax)
    891c:	00 00                	add    %al,(%eax)
    891e:	00 00                	add    %al,(%eax)
    8920:	00 00                	add    %al,(%eax)
    8922:	00 00                	add    %al,(%eax)
    8924:	00 00                	add    %al,(%eax)
    8926:	00 00                	add    %al,(%eax)
    8928:	00 00                	add    %al,(%eax)
    892a:	00 00                	add    %al,(%eax)
    892c:	00 00                	add    %al,(%eax)
    892e:	00 00                	add    %al,(%eax)
    8930:	00 00                	add    %al,(%eax)
    8932:	00 00                	add    %al,(%eax)
    8934:	00 00                	add    %al,(%eax)
    8936:	00 00                	add    %al,(%eax)
    8938:	00 00                	add    %al,(%eax)
    893a:	00 00                	add    %al,(%eax)
    893c:	00 00                	add    %al,(%eax)
    893e:	00 00                	add    %al,(%eax)
    8940:	00 00                	add    %al,(%eax)
    8942:	00 00                	add    %al,(%eax)
    8944:	00 00                	add    %al,(%eax)
    8946:	00 00                	add    %al,(%eax)
    8948:	00 00                	add    %al,(%eax)
    894a:	00 00                	add    %al,(%eax)
    894c:	00 00                	add    %al,(%eax)
    894e:	00 00                	add    %al,(%eax)
    8950:	00 00                	add    %al,(%eax)
    8952:	00 00                	add    %al,(%eax)
    8954:	00 00                	add    %al,(%eax)
    8956:	00 00                	add    %al,(%eax)
    8958:	00 00                	add    %al,(%eax)
    895a:	00 00                	add    %al,(%eax)
    895c:	00 00                	add    %al,(%eax)
    895e:	00 00                	add    %al,(%eax)
    8960:	00 00                	add    %al,(%eax)
    8962:	00 00                	add    %al,(%eax)
    8964:	00 00                	add    %al,(%eax)
    8966:	00 00                	add    %al,(%eax)
    8968:	00 00                	add    %al,(%eax)
    896a:	00 00                	add    %al,(%eax)
    896c:	00 00                	add    %al,(%eax)
    896e:	00 00                	add    %al,(%eax)
    8970:	00 00                	add    %al,(%eax)
    8972:	00 00                	add    %al,(%eax)
    8974:	00 00                	add    %al,(%eax)
    8976:	00 00                	add    %al,(%eax)
    8978:	00 00                	add    %al,(%eax)
    897a:	00 00                	add    %al,(%eax)
    897c:	00 00                	add    %al,(%eax)
    897e:	00 00                	add    %al,(%eax)
    8980:	00 00                	add    %al,(%eax)
    8982:	00 00                	add    %al,(%eax)
    8984:	00 00                	add    %al,(%eax)
    8986:	00 00                	add    %al,(%eax)
    8988:	00 00                	add    %al,(%eax)
    898a:	00 00                	add    %al,(%eax)
    898c:	00 00                	add    %al,(%eax)
    898e:	00 00                	add    %al,(%eax)
    8990:	00 00                	add    %al,(%eax)
    8992:	00 00                	add    %al,(%eax)
    8994:	00 00                	add    %al,(%eax)
    8996:	00 00                	add    %al,(%eax)
    8998:	00 00                	add    %al,(%eax)
    899a:	00 00                	add    %al,(%eax)
    899c:	00 00                	add    %al,(%eax)
    899e:	00 00                	add    %al,(%eax)
    89a0:	00 00                	add    %al,(%eax)
    89a2:	00 00                	add    %al,(%eax)
    89a4:	00 00                	add    %al,(%eax)
    89a6:	00 00                	add    %al,(%eax)
    89a8:	00 00                	add    %al,(%eax)
    89aa:	00 00                	add    %al,(%eax)
    89ac:	00 00                	add    %al,(%eax)
    89ae:	00 00                	add    %al,(%eax)
    89b0:	00 00                	add    %al,(%eax)
    89b2:	00 00                	add    %al,(%eax)
    89b4:	00 00                	add    %al,(%eax)
    89b6:	00 00                	add    %al,(%eax)
    89b8:	00 00                	add    %al,(%eax)
    89ba:	00 00                	add    %al,(%eax)
    89bc:	00 00                	add    %al,(%eax)
    89be:	00 00                	add    %al,(%eax)
    89c0:	00 00                	add    %al,(%eax)
    89c2:	00 00                	add    %al,(%eax)
    89c4:	00 00                	add    %al,(%eax)
    89c6:	00 00                	add    %al,(%eax)
    89c8:	00 00                	add    %al,(%eax)
    89ca:	00 00                	add    %al,(%eax)
    89cc:	00 00                	add    %al,(%eax)
    89ce:	00 00                	add    %al,(%eax)
    89d0:	00 00                	add    %al,(%eax)
    89d2:	00 00                	add    %al,(%eax)
    89d4:	00 00                	add    %al,(%eax)
    89d6:	00 00                	add    %al,(%eax)
    89d8:	00 00                	add    %al,(%eax)
    89da:	00 00                	add    %al,(%eax)
    89dc:	00 00                	add    %al,(%eax)
    89de:	00 00                	add    %al,(%eax)
    89e0:	00 00                	add    %al,(%eax)
    89e2:	00 00                	add    %al,(%eax)
    89e4:	00 00                	add    %al,(%eax)
    89e6:	00 00                	add    %al,(%eax)
    89e8:	00 00                	add    %al,(%eax)
    89ea:	00 00                	add    %al,(%eax)
    89ec:	00 00                	add    %al,(%eax)
    89ee:	00 00                	add    %al,(%eax)
    89f0:	00 00                	add    %al,(%eax)
    89f2:	00 00                	add    %al,(%eax)
    89f4:	00 00                	add    %al,(%eax)
    89f6:	00 00                	add    %al,(%eax)
    89f8:	00 00                	add    %al,(%eax)
    89fa:	00 00                	add    %al,(%eax)
    89fc:	00 00                	add    %al,(%eax)
    89fe:	00 00                	add    %al,(%eax)
    8a00:	00 00                	add    %al,(%eax)
    8a02:	00 00                	add    %al,(%eax)
    8a04:	00 00                	add    %al,(%eax)
    8a06:	00 00                	add    %al,(%eax)
    8a08:	00 00                	add    %al,(%eax)
    8a0a:	00 00                	add    %al,(%eax)
    8a0c:	00 00                	add    %al,(%eax)
    8a0e:	00 00                	add    %al,(%eax)
    8a10:	00 00                	add    %al,(%eax)
    8a12:	00 00                	add    %al,(%eax)
    8a14:	00 00                	add    %al,(%eax)
    8a16:	00 00                	add    %al,(%eax)
    8a18:	00 00                	add    %al,(%eax)
    8a1a:	00 00                	add    %al,(%eax)
    8a1c:	00 00                	add    %al,(%eax)
    8a1e:	00 00                	add    %al,(%eax)
    8a20:	00 00                	add    %al,(%eax)
    8a22:	00 00                	add    %al,(%eax)
    8a24:	00 00                	add    %al,(%eax)
    8a26:	00 00                	add    %al,(%eax)
    8a28:	00 00                	add    %al,(%eax)
    8a2a:	00 00                	add    %al,(%eax)
    8a2c:	00 00                	add    %al,(%eax)
    8a2e:	00 00                	add    %al,(%eax)
    8a30:	00 00                	add    %al,(%eax)
    8a32:	00 00                	add    %al,(%eax)
    8a34:	00 00                	add    %al,(%eax)
    8a36:	00 00                	add    %al,(%eax)
    8a38:	00 00                	add    %al,(%eax)
    8a3a:	00 00                	add    %al,(%eax)
    8a3c:	00 00                	add    %al,(%eax)
    8a3e:	00 00                	add    %al,(%eax)
    8a40:	00 00                	add    %al,(%eax)
    8a42:	00 00                	add    %al,(%eax)
    8a44:	00 00                	add    %al,(%eax)
    8a46:	00 00                	add    %al,(%eax)
    8a48:	00 00                	add    %al,(%eax)
    8a4a:	00 00                	add    %al,(%eax)
    8a4c:	00 00                	add    %al,(%eax)
    8a4e:	00 00                	add    %al,(%eax)
    8a50:	00 00                	add    %al,(%eax)
    8a52:	00 00                	add    %al,(%eax)
    8a54:	00 00                	add    %al,(%eax)
    8a56:	00 00                	add    %al,(%eax)
    8a58:	00 00                	add    %al,(%eax)
    8a5a:	00 00                	add    %al,(%eax)
    8a5c:	00 00                	add    %al,(%eax)
    8a5e:	00 00                	add    %al,(%eax)
    8a60:	00 00                	add    %al,(%eax)
    8a62:	00 00                	add    %al,(%eax)
    8a64:	00 00                	add    %al,(%eax)
    8a66:	00 00                	add    %al,(%eax)
    8a68:	00 00                	add    %al,(%eax)
    8a6a:	00 00                	add    %al,(%eax)
    8a6c:	00 00                	add    %al,(%eax)
    8a6e:	00 00                	add    %al,(%eax)
    8a70:	00 00                	add    %al,(%eax)
    8a72:	00 00                	add    %al,(%eax)
    8a74:	00 00                	add    %al,(%eax)
    8a76:	00 00                	add    %al,(%eax)
    8a78:	00 00                	add    %al,(%eax)
    8a7a:	00 00                	add    %al,(%eax)
    8a7c:	00 00                	add    %al,(%eax)
    8a7e:	00 00                	add    %al,(%eax)
    8a80:	00 00                	add    %al,(%eax)
    8a82:	00 00                	add    %al,(%eax)
    8a84:	00 00                	add    %al,(%eax)
    8a86:	00 00                	add    %al,(%eax)
    8a88:	00 00                	add    %al,(%eax)
    8a8a:	00 00                	add    %al,(%eax)
    8a8c:	00 00                	add    %al,(%eax)
    8a8e:	00 00                	add    %al,(%eax)
    8a90:	00 00                	add    %al,(%eax)
    8a92:	00 00                	add    %al,(%eax)
    8a94:	00 00                	add    %al,(%eax)
    8a96:	00 00                	add    %al,(%eax)
    8a98:	00 00                	add    %al,(%eax)
    8a9a:	00 00                	add    %al,(%eax)
    8a9c:	00 00                	add    %al,(%eax)
    8a9e:	00 00                	add    %al,(%eax)
    8aa0:	00 00                	add    %al,(%eax)
    8aa2:	00 00                	add    %al,(%eax)
    8aa4:	00 00                	add    %al,(%eax)
    8aa6:	00 00                	add    %al,(%eax)
    8aa8:	00 00                	add    %al,(%eax)
    8aaa:	00 00                	add    %al,(%eax)
    8aac:	00 00                	add    %al,(%eax)
    8aae:	00 00                	add    %al,(%eax)
    8ab0:	00 00                	add    %al,(%eax)
    8ab2:	00 00                	add    %al,(%eax)
    8ab4:	00 00                	add    %al,(%eax)
    8ab6:	00 00                	add    %al,(%eax)
    8ab8:	00 00                	add    %al,(%eax)
    8aba:	00 00                	add    %al,(%eax)
    8abc:	00 00                	add    %al,(%eax)
    8abe:	00 00                	add    %al,(%eax)
    8ac0:	00 00                	add    %al,(%eax)
    8ac2:	00 00                	add    %al,(%eax)
    8ac4:	00 00                	add    %al,(%eax)
    8ac6:	00 00                	add    %al,(%eax)
    8ac8:	00 00                	add    %al,(%eax)
    8aca:	00 00                	add    %al,(%eax)
    8acc:	00 00                	add    %al,(%eax)
    8ace:	00 00                	add    %al,(%eax)
    8ad0:	00 00                	add    %al,(%eax)
    8ad2:	00 00                	add    %al,(%eax)
    8ad4:	00 00                	add    %al,(%eax)
    8ad6:	00 00                	add    %al,(%eax)
    8ad8:	00 00                	add    %al,(%eax)
    8ada:	00 00                	add    %al,(%eax)
    8adc:	00 00                	add    %al,(%eax)
    8ade:	00 00                	add    %al,(%eax)
    8ae0:	00 00                	add    %al,(%eax)
    8ae2:	00 00                	add    %al,(%eax)
    8ae4:	00 00                	add    %al,(%eax)
    8ae6:	00 00                	add    %al,(%eax)
    8ae8:	00 00                	add    %al,(%eax)
    8aea:	00 00                	add    %al,(%eax)
    8aec:	00 00                	add    %al,(%eax)
    8aee:	00 00                	add    %al,(%eax)
    8af0:	00 00                	add    %al,(%eax)
    8af2:	00 00                	add    %al,(%eax)
    8af4:	00 00                	add    %al,(%eax)
    8af6:	00 00                	add    %al,(%eax)
    8af8:	00 00                	add    %al,(%eax)
    8afa:	00 00                	add    %al,(%eax)
    8afc:	00 00                	add    %al,(%eax)
    8afe:	00 00                	add    %al,(%eax)
    8b00:	00 00                	add    %al,(%eax)
    8b02:	00 00                	add    %al,(%eax)
    8b04:	00 00                	add    %al,(%eax)
    8b06:	00 00                	add    %al,(%eax)
    8b08:	00 00                	add    %al,(%eax)
    8b0a:	00 00                	add    %al,(%eax)
    8b0c:	00 00                	add    %al,(%eax)
    8b0e:	00 00                	add    %al,(%eax)
    8b10:	00 00                	add    %al,(%eax)
    8b12:	00 00                	add    %al,(%eax)
    8b14:	00 00                	add    %al,(%eax)
    8b16:	00 00                	add    %al,(%eax)
    8b18:	00 00                	add    %al,(%eax)
    8b1a:	00 00                	add    %al,(%eax)
    8b1c:	00 00                	add    %al,(%eax)
    8b1e:	00 00                	add    %al,(%eax)
    8b20:	00 00                	add    %al,(%eax)
    8b22:	00 00                	add    %al,(%eax)
    8b24:	00 00                	add    %al,(%eax)

00008b26 <putc>:
 */
volatile char *video = (volatile char *) 0xB8000;

void putc(int l, int color, char ch)
{
    volatile char *p = video + l * 2;
    8b26:	e8 b2 02 00 00       	call   8ddd <__x86.get_pc_thunk.dx>
    8b2b:	81 c2 21 08 00 00    	add    $0x821,%edx
{
    8b31:	55                   	push   %ebp
    8b32:	89 e5                	mov    %esp,%ebp
    8b34:	8b 45 08             	mov    0x8(%ebp),%eax
    volatile char *p = video + l * 2;
    8b37:	01 c0                	add    %eax,%eax
    8b39:	03 82 34 00 00 00    	add    0x34(%edx),%eax
    *p = ch;
    8b3f:	8b 55 10             	mov    0x10(%ebp),%edx
    8b42:	88 10                	mov    %dl,(%eax)
    *(p + 1) = color;
    8b44:	8b 55 0c             	mov    0xc(%ebp),%edx
    8b47:	88 50 01             	mov    %dl,0x1(%eax)
}
    8b4a:	5d                   	pop    %ebp
    8b4b:	c3                   	ret

00008b4c <puts>:

int puts(int r, int c, int color, const char *string)
{
    8b4c:	55                   	push   %ebp
    8b4d:	89 e5                	mov    %esp,%ebp
    8b4f:	56                   	push   %esi
    8b50:	53                   	push   %ebx
    int l = r * 80 + c;
    8b51:	6b 75 08 50          	imul   $0x50,0x8(%ebp),%esi
{
    8b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
    int l = r * 80 + c;
    8b58:	03 75 0c             	add    0xc(%ebp),%esi
    8b5b:	89 f0                	mov    %esi,%eax
    while (*string != 0) {
    8b5d:	8b 55 14             	mov    0x14(%ebp),%edx
    8b60:	29 f2                	sub    %esi,%edx
    8b62:	0f be 14 02          	movsbl (%edx,%eax,1),%edx
    8b66:	84 d2                	test   %dl,%dl
    8b68:	74 15                	je     8b7f <puts+0x33>
        putc(l++, color, *string++);
    8b6a:	83 ec 04             	sub    $0x4,%esp
    8b6d:	8d 58 01             	lea    0x1(%eax),%ebx
    8b70:	52                   	push   %edx
    8b71:	51                   	push   %ecx
    8b72:	50                   	push   %eax
    8b73:	e8 ae ff ff ff       	call   8b26 <putc>
    8b78:	83 c4 10             	add    $0x10,%esp
    8b7b:	89 d8                	mov    %ebx,%eax
    8b7d:	eb de                	jmp    8b5d <puts+0x11>
    }
    return l;
}
    8b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8b82:	5b                   	pop    %ebx
    8b83:	5e                   	pop    %esi
    8b84:	5d                   	pop    %ebp
    8b85:	c3                   	ret

00008b86 <putline>:

char *blank =
    "                                                                                ";

void putline(char *s)
{
    8b86:	55                   	push   %ebp
    8b87:	89 e5                	mov    %esp,%ebp
    8b89:	53                   	push   %ebx
    8b8a:	50                   	push   %eax
    8b8b:	e8 49 02 00 00       	call   8dd9 <__x86.get_pc_thunk.ax>
    8b90:	05 bc 07 00 00       	add    $0x7bc,%eax
    puts(row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b95:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
    8b9b:	8b 88 38 00 00 00    	mov    0x38(%eax),%ecx
    8ba1:	8d 5a 01             	lea    0x1(%edx),%ebx
    8ba4:	83 fa 18             	cmp    $0x18,%edx
    8ba7:	7e 02                	jle    8bab <putline+0x25>
    8ba9:	31 db                	xor    %ebx,%ebx
    8bab:	51                   	push   %ecx
    8bac:	6a 00                	push   $0x0
    8bae:	6a 00                	push   $0x0
    8bb0:	53                   	push   %ebx
    8bb1:	89 98 dc 00 00 00    	mov    %ebx,0xdc(%eax)
    8bb7:	e8 90 ff ff ff       	call   8b4c <puts>
    puts(row, 0, VGA_CLR_WHITE, s);
    8bbc:	ff 75 08             	push   0x8(%ebp)
    8bbf:	6a 0f                	push   $0xf
    8bc1:	6a 00                	push   $0x0
    8bc3:	53                   	push   %ebx
    8bc4:	e8 83 ff ff ff       	call   8b4c <puts>
}
    8bc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8bcc:	83 c4 20             	add    $0x20,%esp
    8bcf:	c9                   	leave
    8bd0:	c3                   	ret

00008bd1 <roll>:

void roll(int r)
{
    row = r;
    8bd1:	e8 03 02 00 00       	call   8dd9 <__x86.get_pc_thunk.ax>
    8bd6:	05 76 07 00 00       	add    $0x776,%eax
{
    8bdb:	55                   	push   %ebp
    8bdc:	89 e5                	mov    %esp,%ebp
    row = r;
    8bde:	8b 55 08             	mov    0x8(%ebp),%edx
}
    8be1:	5d                   	pop    %ebp
    row = r;
    8be2:	89 90 dc 00 00 00    	mov    %edx,0xdc(%eax)
}
    8be8:	c3                   	ret

00008be9 <panic>:

void panic(char *m)
{
    8be9:	55                   	push   %ebp
    8bea:	89 e5                	mov    %esp,%ebp
    8bec:	83 ec 08             	sub    $0x8,%esp
    puts(0, 0, VGA_CLR_RED, m);
    8bef:	ff 75 08             	push   0x8(%ebp)
    8bf2:	6a 04                	push   $0x4
    8bf4:	6a 00                	push   $0x0
    8bf6:	6a 00                	push   $0x0
    8bf8:	e8 4f ff ff ff       	call   8b4c <puts>
    8bfd:	83 c4 10             	add    $0x10,%esp
    while (1) {
        asm volatile ("hlt");
    8c00:	f4                   	hlt
    while (1) {
    8c01:	eb fd                	jmp    8c00 <panic+0x17>

00008c03 <strlen>:

/**
 * string
 */
int strlen(const char *s)
{
    8c03:	55                   	push   %ebp
    int n;

    for (n = 0; *s != '\0'; s++)
    8c04:	31 c0                	xor    %eax,%eax
{
    8c06:	89 e5                	mov    %esp,%ebp
    8c08:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; *s != '\0'; s++)
    8c0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    8c0f:	74 03                	je     8c14 <strlen+0x11>
        n++;
    8c11:	40                   	inc    %eax
    for (n = 0; *s != '\0'; s++)
    8c12:	eb f7                	jmp    8c0b <strlen+0x8>
    return n;
}
    8c14:	5d                   	pop    %ebp
    8c15:	c3                   	ret

00008c16 <reverse>:

/* reverse: reverse string s in place */
void reverse(char s[])
{
    8c16:	55                   	push   %ebp
    8c17:	89 e5                	mov    %esp,%ebp
    8c19:	56                   	push   %esi
    8c1a:	53                   	push   %ebx
    8c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i, j;
    char c;

    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
    8c1e:	83 ec 0c             	sub    $0xc,%esp
    8c21:	51                   	push   %ecx
    8c22:	e8 dc ff ff ff       	call   8c03 <strlen>
    8c27:	83 c4 10             	add    $0x10,%esp
    8c2a:	31 d2                	xor    %edx,%edx
    8c2c:	48                   	dec    %eax
    8c2d:	39 c2                	cmp    %eax,%edx
    8c2f:	7d 13                	jge    8c44 <reverse+0x2e>
        c = s[i];
    8c31:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        s[i] = s[j];
    8c35:	8a 1c 01             	mov    (%ecx,%eax,1),%bl
    8c38:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        s[j] = c;
    8c3b:	89 f3                	mov    %esi,%ebx
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
    8c3d:	42                   	inc    %edx
        s[j] = c;
    8c3e:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
    8c41:	48                   	dec    %eax
    8c42:	eb e9                	jmp    8c2d <reverse+0x17>
    }
}
    8c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8c47:	5b                   	pop    %ebx
    8c48:	5e                   	pop    %esi
    8c49:	5d                   	pop    %ebp
    8c4a:	c3                   	ret

00008c4b <itox>:

/* itoa: convert n to characters in s */
void itox(int n, char s[], int root, char *table)
{
    8c4b:	55                   	push   %ebp
    8c4c:	89 e5                	mov    %esp,%ebp
    8c4e:	57                   	push   %edi
    8c4f:	56                   	push   %esi
    8c50:	53                   	push   %ebx
    8c51:	83 ec 1c             	sub    $0x1c,%esp
    8c54:	8b 75 08             	mov    0x8(%ebp),%esi
    8c57:	8b 45 10             	mov    0x10(%ebp),%eax
    8c5a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    8c5d:	8b 7d 14             	mov    0x14(%ebp),%edi
    8c60:	89 45 e0             	mov    %eax,-0x20(%ebp)
    int i, sign;

    if ((sign = n) < 0)            /* record sign */
    8c63:	89 f0                	mov    %esi,%eax
    8c65:	f7 d8                	neg    %eax
    8c67:	0f 48 c6             	cmovs  %esi,%eax
    8c6a:	31 c9                	xor    %ecx,%ecx
        n = -n;                    /* make n positive */
    i = 0;
    do {                           /* generate digits in reverse order */
        s[i++] = table[n % root];  /* get next digit */
    8c6c:	99                   	cltd
    8c6d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    8c70:	41                   	inc    %ecx
    } while ((n /= root) > 0);     /* delete it */
    8c71:	f7 7d e0             	idivl  -0x20(%ebp)
        s[i++] = table[n % root];  /* get next digit */
    8c74:	8a 14 17             	mov    (%edi,%edx,1),%dl
    8c77:	88 54 0b ff          	mov    %dl,-0x1(%ebx,%ecx,1)
    8c7b:	89 ca                	mov    %ecx,%edx
    } while ((n /= root) > 0);     /* delete it */
    8c7d:	85 c0                	test   %eax,%eax
    8c7f:	7f eb                	jg     8c6c <itox+0x21>
    if (sign < 0)
    8c81:	85 f6                	test   %esi,%esi
    8c83:	79 0a                	jns    8c8f <itox+0x44>
        s[i++] = '-';
    8c85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    8c88:	c6 04 13 2d          	movb   $0x2d,(%ebx,%edx,1)
    8c8c:	83 c1 02             	add    $0x2,%ecx
    s[i] = '\0';
    8c8f:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
    reverse(s);
    8c93:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    8c96:	83 c4 1c             	add    $0x1c,%esp
    8c99:	5b                   	pop    %ebx
    8c9a:	5e                   	pop    %esi
    8c9b:	5f                   	pop    %edi
    8c9c:	5d                   	pop    %ebp
    reverse(s);
    8c9d:	e9 74 ff ff ff       	jmp    8c16 <reverse>

00008ca2 <itoa>:

void itoa(int n, char s[])
{
    static char dec[] = "0123456789";
    itox(n, s, 10, dec);
    8ca2:	e8 32 01 00 00       	call   8dd9 <__x86.get_pc_thunk.ax>
    8ca7:	05 a5 06 00 00       	add    $0x6a5,%eax
{
    8cac:	55                   	push   %ebp
    8cad:	89 e5                	mov    %esp,%ebp
    8caf:	83 ec 08             	sub    $0x8,%esp
    itox(n, s, 10, dec);
    8cb2:	8d 80 28 00 00 00    	lea    0x28(%eax),%eax
    8cb8:	50                   	push   %eax
    8cb9:	6a 0a                	push   $0xa
    8cbb:	ff 75 0c             	push   0xc(%ebp)
    8cbe:	ff 75 08             	push   0x8(%ebp)
    8cc1:	e8 85 ff ff ff       	call   8c4b <itox>
}
    8cc6:	83 c4 10             	add    $0x10,%esp
    8cc9:	c9                   	leave
    8cca:	c3                   	ret

00008ccb <itoh>:

void itoh(int n, char *s)
{
    static char hex[] = "0123456789abcdef";
    itox(n, s, 16, hex);
    8ccb:	e8 09 01 00 00       	call   8dd9 <__x86.get_pc_thunk.ax>
    8cd0:	05 7c 06 00 00       	add    $0x67c,%eax
{
    8cd5:	55                   	push   %ebp
    8cd6:	89 e5                	mov    %esp,%ebp
    8cd8:	83 ec 08             	sub    $0x8,%esp
    itox(n, s, 16, hex);
    8cdb:	8d 80 14 00 00 00    	lea    0x14(%eax),%eax
    8ce1:	50                   	push   %eax
    8ce2:	6a 10                	push   $0x10
    8ce4:	ff 75 0c             	push   0xc(%ebp)
    8ce7:	ff 75 08             	push   0x8(%ebp)
    8cea:	e8 5c ff ff ff       	call   8c4b <itox>
}
    8cef:	83 c4 10             	add    $0x10,%esp
    8cf2:	c9                   	leave
    8cf3:	c3                   	ret

00008cf4 <puti>:
    itoh(i, puti_str);
    8cf4:	e8 e0 00 00 00       	call   8dd9 <__x86.get_pc_thunk.ax>
    8cf9:	05 53 06 00 00       	add    $0x653,%eax
{
    8cfe:	55                   	push   %ebp
    8cff:	89 e5                	mov    %esp,%ebp
    8d01:	53                   	push   %ebx
    itoh(i, puti_str);
    8d02:	8d 98 b4 00 00 00    	lea    0xb4(%eax),%ebx
{
    8d08:	83 ec 0c             	sub    $0xc,%esp
    itoh(i, puti_str);
    8d0b:	53                   	push   %ebx
    8d0c:	ff 75 08             	push   0x8(%ebp)
    8d0f:	e8 b7 ff ff ff       	call   8ccb <itoh>
    putline(puti_str);
    8d14:	83 c4 10             	add    $0x10,%esp
    8d17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    8d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8d1d:	c9                   	leave
    putline(puti_str);
    8d1e:	e9 63 fe ff ff       	jmp    8b86 <putline>

00008d23 <readsector>:
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */ ;
}

void readsector(void *dst, uint32_t offset)
{
    8d23:	55                   	push   %ebp
    8d24:	89 e5                	mov    %esp,%ebp
    8d26:	57                   	push   %edi
}

static inline uint8_t inb(int port)
{
    uint8_t data;
    __asm __volatile ("inb %w1,%0" : "=a" (data) : "d" (port));
    8d27:	bf f7 01 00 00       	mov    $0x1f7,%edi
    8d2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    8d2f:	89 fa                	mov    %edi,%edx
    8d31:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    8d32:	83 e0 c0             	and    $0xffffffc0,%eax
    8d35:	3c 40                	cmp    $0x40,%al
    8d37:	75 f6                	jne    8d2f <readsector+0xc>
    __asm __volatile ("outb %0,%w1" :: "a" (data), "d" (port));
    8d39:	b0 01                	mov    $0x1,%al
    8d3b:	ba f2 01 00 00       	mov    $0x1f2,%edx
    8d40:	ee                   	out    %al,(%dx)
    8d41:	ba f3 01 00 00       	mov    $0x1f3,%edx
    8d46:	89 c8                	mov    %ecx,%eax
    8d48:	ee                   	out    %al,(%dx)
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);     // count = 1
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    8d49:	89 c8                	mov    %ecx,%eax
    8d4b:	ba f4 01 00 00       	mov    $0x1f4,%edx
    8d50:	c1 e8 08             	shr    $0x8,%eax
    8d53:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
    8d54:	89 c8                	mov    %ecx,%eax
    8d56:	ba f5 01 00 00       	mov    $0x1f5,%edx
    8d5b:	c1 e8 10             	shr    $0x10,%eax
    8d5e:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
    8d5f:	89 c8                	mov    %ecx,%eax
    8d61:	ba f6 01 00 00       	mov    $0x1f6,%edx
    8d66:	c1 e8 18             	shr    $0x18,%eax
    8d69:	83 c8 e0             	or     $0xffffffe0,%eax
    8d6c:	ee                   	out    %al,(%dx)
    8d6d:	b0 20                	mov    $0x20,%al
    8d6f:	89 fa                	mov    %edi,%edx
    8d71:	ee                   	out    %al,(%dx)
    __asm __volatile ("inb %w1,%0" : "=a" (data) : "d" (port));
    8d72:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8d77:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    8d78:	83 e0 c0             	and    $0xffffffc0,%eax
    8d7b:	3c 40                	cmp    $0x40,%al
    8d7d:	75 f8                	jne    8d77 <readsector+0x54>
    return data;
}

static inline void insl(int port, void *addr, int cnt)
{
    __asm __volatile ("cld\n\trepne\n\tinsl"
    8d7f:	8b 7d 08             	mov    0x8(%ebp),%edi
    8d82:	b9 80 00 00 00       	mov    $0x80,%ecx
    8d87:	ba f0 01 00 00       	mov    $0x1f0,%edx
    8d8c:	fc                   	cld
    8d8d:	f2 6d                	repnz insl (%dx),%es:(%edi)
    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTOR_SIZE / 4);
}
    8d8f:	5f                   	pop    %edi
    8d90:	5d                   	pop    %ebp
    8d91:	c3                   	ret

00008d92 <readsection>:

// Read 'count' bytes at 'offset' from kernel into virtual address 'va'.
// Might copy more than asked
void readsection(uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
    8d92:	55                   	push   %ebp
    8d93:	89 e5                	mov    %esp,%ebp
    8d95:	57                   	push   %edi
    8d96:	56                   	push   %esi
    8d97:	53                   	push   %ebx
    8d98:	83 ec 0c             	sub    $0xc,%esp
    8d9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    end_va = va + count;
    // round down to sector boundary
    va &= ~(SECTOR_SIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 1
    offset = (offset / SECTOR_SIZE) + lba;
    8d9e:	8b 75 10             	mov    0x10(%ebp),%esi
    va &= 0xFFFFFF;
    8da1:	89 df                	mov    %ebx,%edi
    offset = (offset / SECTOR_SIZE) + lba;
    8da3:	c1 ee 09             	shr    $0x9,%esi
    va &= ~(SECTOR_SIZE - 1);
    8da6:	81 e3 00 fe ff 00    	and    $0xfffe00,%ebx
    offset = (offset / SECTOR_SIZE) + lba;
    8dac:	03 75 14             	add    0x14(%ebp),%esi
    va &= 0xFFFFFF;
    8daf:	81 e7 ff ff ff 00    	and    $0xffffff,%edi
    end_va = va + count;
    8db5:	03 7d 0c             	add    0xc(%ebp),%edi

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (va < end_va) {
    8db8:	39 fb                	cmp    %edi,%ebx
    8dba:	73 15                	jae    8dd1 <readsection+0x3f>
        readsector((uint8_t *) va, offset);
    8dbc:	50                   	push   %eax
    8dbd:	50                   	push   %eax
    8dbe:	56                   	push   %esi
        va += SECTOR_SIZE;
        offset++;
    8dbf:	46                   	inc    %esi
        readsector((uint8_t *) va, offset);
    8dc0:	53                   	push   %ebx
        va += SECTOR_SIZE;
    8dc1:	81 c3 00 02 00 00    	add    $0x200,%ebx
        readsector((uint8_t *) va, offset);
    8dc7:	e8 57 ff ff ff       	call   8d23 <readsector>
        offset++;
    8dcc:	83 c4 10             	add    $0x10,%esp
    8dcf:	eb e7                	jmp    8db8 <readsection+0x26>
    }
}
    8dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8dd4:	5b                   	pop    %ebx
    8dd5:	5e                   	pop    %esi
    8dd6:	5f                   	pop    %edi
    8dd7:	5d                   	pop    %ebp
    8dd8:	c3                   	ret

00008dd9 <__x86.get_pc_thunk.ax>:
    8dd9:	8b 04 24             	mov    (%esp),%eax
    8ddc:	c3                   	ret

00008ddd <__x86.get_pc_thunk.dx>:
    8ddd:	8b 14 24             	mov    (%esp),%edx
    8de0:	c3                   	ret

00008de1 <load_kernel>:
}

#define ELFHDR ((elfhdr *) 0x20000)

uint32_t load_kernel(uint32_t dkernel)
{
    8de1:	55                   	push   %ebp
    8de2:	89 e5                	mov    %esp,%ebp
    8de4:	57                   	push   %edi
    8de5:	56                   	push   %esi
    8de6:	53                   	push   %ebx
    8de7:	e8 b5 01 00 00       	call   8fa1 <__x86.get_pc_thunk.bx>
    8dec:	81 c3 60 05 00 00    	add    $0x560,%ebx
    8df2:	83 ec 0c             	sub    $0xc,%esp
    // load kernel from the beginning of the first bootable partition
    proghdr *ph, *eph;

    readsection((uint32_t) ELFHDR, SECTOR_SIZE * 8, 0, dkernel);
    8df5:	ff 75 08             	push   0x8(%ebp)
    8df8:	6a 00                	push   $0x0
    8dfa:	68 00 10 00 00       	push   $0x1000
    8dff:	68 00 00 02 00       	push   $0x20000
    8e04:	e8 89 ff ff ff       	call   8d92 <readsection>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC)
    8e09:	83 c4 10             	add    $0x10,%esp
    8e0c:	81 3d 00 00 02 00 7f 	cmpl   $0x464c457f,0x20000
    8e13:	45 4c 46 
    8e16:	74 12                	je     8e2a <load_kernel+0x49>
        panic("Kernel is not a valid elf.");
    8e18:	83 ec 0c             	sub    $0xc,%esp
    8e1b:	8d 83 ba fc ff ff    	lea    -0x346(%ebx),%eax
    8e21:	50                   	push   %eax
    8e22:	e8 c2 fd ff ff       	call   8be9 <panic>
    8e27:	83 c4 10             	add    $0x10,%esp

    // load each program segment (ignores ph flags)
    ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8e2a:	a1 1c 00 02 00       	mov    0x2001c,%eax
    eph = ph + ELFHDR->e_phnum;
    8e2f:	0f b7 35 2c 00 02 00 	movzwl 0x2002c,%esi
    ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8e36:	8d b8 00 00 02 00    	lea    0x20000(%eax),%edi
    eph = ph + ELFHDR->e_phnum;
    8e3c:	c1 e6 05             	shl    $0x5,%esi
    8e3f:	01 fe                	add    %edi,%esi

    for (; ph < eph; ph++) {
    8e41:	39 f7                	cmp    %esi,%edi
    8e43:	73 19                	jae    8e5e <load_kernel+0x7d>
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8e45:	ff 75 08             	push   0x8(%ebp)
    for (; ph < eph; ph++) {
    8e48:	83 c7 20             	add    $0x20,%edi
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8e4b:	ff 77 e4             	push   -0x1c(%edi)
    8e4e:	ff 77 f4             	push   -0xc(%edi)
    8e51:	ff 77 e8             	push   -0x18(%edi)
    8e54:	e8 39 ff ff ff       	call   8d92 <readsection>
    for (; ph < eph; ph++) {
    8e59:	83 c4 10             	add    $0x10,%esp
    8e5c:	eb e3                	jmp    8e41 <load_kernel+0x60>
    }

    return (ELFHDR->e_entry & 0xFFFFFF);
    8e5e:	a1 18 00 02 00       	mov    0x20018,%eax
}
    8e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8e66:	5b                   	pop    %ebx
    8e67:	5e                   	pop    %esi
    return (ELFHDR->e_entry & 0xFFFFFF);
    8e68:	25 ff ff ff 00       	and    $0xffffff,%eax
}
    8e6d:	5f                   	pop    %edi
    8e6e:	5d                   	pop    %ebp
    8e6f:	c3                   	ret

00008e70 <parse_e820>:

mboot_info_t *parse_e820(bios_smap_t *smap)
{
    8e70:	55                   	push   %ebp
    8e71:	89 e5                	mov    %esp,%ebp
    8e73:	57                   	push   %edi
    8e74:	56                   	push   %esi
    bios_smap_t *p;
    uint32_t mmap_len;
    p = smap;
    mmap_len = 0;
    8e75:	31 f6                	xor    %esi,%esi
{
    8e77:	53                   	push   %ebx
    8e78:	e8 24 01 00 00       	call   8fa1 <__x86.get_pc_thunk.bx>
    8e7d:	81 c3 cf 04 00 00    	add    $0x4cf,%ebx
    8e83:	83 ec 18             	sub    $0x18,%esp
    8e86:	8b 7d 08             	mov    0x8(%ebp),%edi
    putline("* E820 Memory Map *");
    8e89:	8d 83 d5 fc ff ff    	lea    -0x32b(%ebx),%eax
    8e8f:	50                   	push   %eax
    8e90:	e8 f1 fc ff ff       	call   8b86 <putline>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0) {
    8e95:	83 c4 10             	add    $0x10,%esp
    8e98:	83 7c 37 08 00       	cmpl   $0x0,0x8(%edi,%esi,1)
    8e9d:	8b 44 37 04          	mov    0x4(%edi,%esi,1),%eax
    8ea1:	74 11                	je     8eb4 <parse_e820+0x44>
        puti(p->base_addr);
    8ea3:	83 ec 0c             	sub    $0xc,%esp
        p++;
        mmap_len += sizeof(bios_smap_t);
    8ea6:	83 c6 18             	add    $0x18,%esi
        puti(p->base_addr);
    8ea9:	50                   	push   %eax
    8eaa:	e8 45 fe ff ff       	call   8cf4 <puti>
        mmap_len += sizeof(bios_smap_t);
    8eaf:	83 c4 10             	add    $0x10,%esp
    8eb2:	eb e4                	jmp    8e98 <parse_e820+0x28>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0) {
    8eb4:	85 c0                	test   %eax,%eax
    8eb6:	75 eb                	jne    8ea3 <parse_e820+0x33>
    8eb8:	83 7c 37 10 00       	cmpl   $0x0,0x10(%edi,%esi,1)
    8ebd:	75 e4                	jne    8ea3 <parse_e820+0x33>
    8ebf:	83 7c 37 0c 00       	cmpl   $0x0,0xc(%edi,%esi,1)
    8ec4:	75 dd                	jne    8ea3 <parse_e820+0x33>
    8ec6:	83 7c 37 14 00       	cmpl   $0x0,0x14(%edi,%esi,1)
    8ecb:	75 d6                	jne    8ea3 <parse_e820+0x33>
    }
    mboot_info.mmap_length = mmap_len;
    8ecd:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
    mboot_info.mmap_addr = (uint32_t) smap;
    return &mboot_info;
    8ed3:	8d 83 54 00 00 00    	lea    0x54(%ebx),%eax
    mboot_info.mmap_addr = (uint32_t) smap;
    8ed9:	89 bb 84 00 00 00    	mov    %edi,0x84(%ebx)
}
    8edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8ee2:	5b                   	pop    %ebx
    8ee3:	5e                   	pop    %esi
    8ee4:	5f                   	pop    %edi
    8ee5:	5d                   	pop    %ebp
    8ee6:	c3                   	ret

00008ee7 <boot1main>:
{
    8ee7:	55                   	push   %ebp
    8ee8:	89 e5                	mov    %esp,%ebp
    8eea:	56                   	push   %esi
    8eeb:	53                   	push   %ebx
    8eec:	8b 75 0c             	mov    0xc(%ebp),%esi
    8eef:	e8 ad 00 00 00       	call   8fa1 <__x86.get_pc_thunk.bx>
    8ef4:	81 c3 58 04 00 00    	add    $0x458,%ebx
    roll(3);
    8efa:	83 ec 0c             	sub    $0xc,%esp
    8efd:	6a 03                	push   $0x3
    8eff:	e8 cd fc ff ff       	call   8bd1 <roll>
    putline("Start boot1 main ...");
    8f04:	8d 83 e9 fc ff ff    	lea    -0x317(%ebx),%eax
    8f0a:	89 04 24             	mov    %eax,(%esp)
    8f0d:	e8 74 fc ff ff       	call   8b86 <putline>
    8f12:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 4; i++) {
    8f15:	31 c0                	xor    %eax,%eax
        if (mbr->partition[i].bootable == BOOTABLE_PARTITION) {
    8f17:	89 c2                	mov    %eax,%edx
    8f19:	c1 e2 04             	shl    $0x4,%edx
    8f1c:	80 bc 16 be 01 00 00 	cmpb   $0x80,0x1be(%esi,%edx,1)
    8f23:	80 
    8f24:	75 09                	jne    8f2f <boot1main+0x48>
            bootable_lba = mbr->partition[i].first_lba;
    8f26:	8b b4 32 c6 01 00 00 	mov    0x1c6(%edx,%esi,1),%esi
    if (i == 4)
    8f2d:	eb 1a                	jmp    8f49 <boot1main+0x62>
    for (i = 0; i < 4; i++) {
    8f2f:	40                   	inc    %eax
    8f30:	83 f8 04             	cmp    $0x4,%eax
    8f33:	75 e2                	jne    8f17 <boot1main+0x30>
        panic("Cannot find bootable partition!");
    8f35:	83 ec 0c             	sub    $0xc,%esp
    8f38:	8d 83 fe fc ff ff    	lea    -0x302(%ebx),%eax
    8f3e:	31 f6                	xor    %esi,%esi
    8f40:	50                   	push   %eax
    8f41:	e8 a3 fc ff ff       	call   8be9 <panic>
    8f46:	83 c4 10             	add    $0x10,%esp
    parse_e820(smap);
    8f49:	83 ec 0c             	sub    $0xc,%esp
    8f4c:	ff 75 10             	push   0x10(%ebp)
    8f4f:	e8 1c ff ff ff       	call   8e70 <parse_e820>
    putline("Load kernel ...\n");
    8f54:	8d 83 1e fd ff ff    	lea    -0x2e2(%ebx),%eax
    8f5a:	89 04 24             	mov    %eax,(%esp)
    8f5d:	e8 24 fc ff ff       	call   8b86 <putline>
    uint32_t entry = load_kernel(bootable_lba);
    8f62:	89 34 24             	mov    %esi,(%esp)
    8f65:	e8 77 fe ff ff       	call   8de1 <load_kernel>
    8f6a:	89 c6                	mov    %eax,%esi
    putline("Start kernel ...\n");
    8f6c:	8d 83 2f fd ff ff    	lea    -0x2d1(%ebx),%eax
    8f72:	89 04 24             	mov    %eax,(%esp)
    8f75:	e8 0c fc ff ff       	call   8b86 <putline>
    exec_kernel(entry, &mboot_info);
    8f7a:	58                   	pop    %eax
    8f7b:	8d 83 54 00 00 00    	lea    0x54(%ebx),%eax
    8f81:	5a                   	pop    %edx
    8f82:	50                   	push   %eax
    8f83:	56                   	push   %esi
    8f84:	e8 1c 00 00 00       	call   8fa5 <exec_kernel>
    panic("Fail to load kernel.");
    8f89:	8d 83 41 fd ff ff    	lea    -0x2bf(%ebx),%eax
    8f8f:	89 04 24             	mov    %eax,(%esp)
    8f92:	e8 52 fc ff ff       	call   8be9 <panic>
}
    8f97:	83 c4 10             	add    $0x10,%esp
    8f9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8f9d:	5b                   	pop    %ebx
    8f9e:	5e                   	pop    %esi
    8f9f:	5d                   	pop    %ebp
    8fa0:	c3                   	ret

00008fa1 <__x86.get_pc_thunk.bx>:
    8fa1:	8b 1c 24             	mov    (%esp),%ebx
    8fa4:	c3                   	ret

00008fa5 <exec_kernel>:
	.set MBOOT_INFO_MAGIC, 0x2badb002

	.globl exec_kernel
	.code32
exec_kernel:
	cli
    8fa5:	fa                   	cli
	movl	$MBOOT_INFO_MAGIC, %eax
    8fa6:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
	movl	8(%esp), %ebx
    8fab:	8b 5c 24 08          	mov    0x8(%esp),%ebx
	movl	4(%esp), %edx
    8faf:	8b 54 24 04          	mov    0x4(%esp),%edx
	jmp	*%edx
    8fb3:	ff e2                	jmp    *%edx

Disassembly of section .rodata:

00008fb5 <.rodata>:
    8fb5:	20 20                	and    %ah,(%eax)
    8fb7:	20 20                	and    %ah,(%eax)
    8fb9:	20 20                	and    %ah,(%eax)
    8fbb:	20 20                	and    %ah,(%eax)
    8fbd:	20 20                	and    %ah,(%eax)
    8fbf:	20 20                	and    %ah,(%eax)
    8fc1:	20 20                	and    %ah,(%eax)
    8fc3:	20 20                	and    %ah,(%eax)
    8fc5:	20 20                	and    %ah,(%eax)
    8fc7:	20 20                	and    %ah,(%eax)
    8fc9:	20 20                	and    %ah,(%eax)
    8fcb:	20 20                	and    %ah,(%eax)
    8fcd:	20 20                	and    %ah,(%eax)
    8fcf:	20 20                	and    %ah,(%eax)
    8fd1:	20 20                	and    %ah,(%eax)
    8fd3:	20 20                	and    %ah,(%eax)
    8fd5:	20 20                	and    %ah,(%eax)
    8fd7:	20 20                	and    %ah,(%eax)
    8fd9:	20 20                	and    %ah,(%eax)
    8fdb:	20 20                	and    %ah,(%eax)
    8fdd:	20 20                	and    %ah,(%eax)
    8fdf:	20 20                	and    %ah,(%eax)
    8fe1:	20 20                	and    %ah,(%eax)
    8fe3:	20 20                	and    %ah,(%eax)
    8fe5:	20 20                	and    %ah,(%eax)
    8fe7:	20 20                	and    %ah,(%eax)
    8fe9:	20 20                	and    %ah,(%eax)
    8feb:	20 20                	and    %ah,(%eax)
    8fed:	20 20                	and    %ah,(%eax)
    8fef:	20 20                	and    %ah,(%eax)
    8ff1:	20 20                	and    %ah,(%eax)
    8ff3:	20 20                	and    %ah,(%eax)
    8ff5:	20 20                	and    %ah,(%eax)
    8ff7:	20 20                	and    %ah,(%eax)
    8ff9:	20 20                	and    %ah,(%eax)
    8ffb:	20 20                	and    %ah,(%eax)
    8ffd:	20 20                	and    %ah,(%eax)
    8fff:	20 20                	and    %ah,(%eax)
    9001:	20 20                	and    %ah,(%eax)
    9003:	20 20                	and    %ah,(%eax)
    9005:	00 4b 65             	add    %cl,0x65(%ebx)
    9008:	72 6e                	jb     9078 <exec_kernel+0xd3>
    900a:	65 6c                	gs insb (%dx),%es:(%edi)
    900c:	20 69 73             	and    %ch,0x73(%ecx)
    900f:	20 6e 6f             	and    %ch,0x6f(%esi)
    9012:	74 20                	je     9034 <exec_kernel+0x8f>
    9014:	61                   	popa
    9015:	20 76 61             	and    %dh,0x61(%esi)
    9018:	6c                   	insb   (%dx),%es:(%edi)
    9019:	69 64 20 65 6c 66 2e 	imul   $0x2e666c,0x65(%eax,%eiz,1),%esp
    9020:	00 
    9021:	2a 20                	sub    (%eax),%ah
    9023:	45                   	inc    %ebp
    9024:	38 32                	cmp    %dh,(%edx)
    9026:	30 20                	xor    %ah,(%eax)
    9028:	4d                   	dec    %ebp
    9029:	65 6d                	gs insl (%dx),%es:(%edi)
    902b:	6f                   	outsl  %ds:(%esi),(%dx)
    902c:	72 79                	jb     90a7 <exec_kernel+0x102>
    902e:	20 4d 61             	and    %cl,0x61(%ebp)
    9031:	70 20                	jo     9053 <exec_kernel+0xae>
    9033:	2a 00                	sub    (%eax),%al
    9035:	53                   	push   %ebx
    9036:	74 61                	je     9099 <exec_kernel+0xf4>
    9038:	72 74                	jb     90ae <exec_kernel+0x109>
    903a:	20 62 6f             	and    %ah,0x6f(%edx)
    903d:	6f                   	outsl  %ds:(%esi),(%dx)
    903e:	74 31                	je     9071 <exec_kernel+0xcc>
    9040:	20 6d 61             	and    %ch,0x61(%ebp)
    9043:	69 6e 20 2e 2e 2e 00 	imul   $0x2e2e2e,0x20(%esi),%ebp
    904a:	43                   	inc    %ebx
    904b:	61                   	popa
    904c:	6e                   	outsb  %ds:(%esi),(%dx)
    904d:	6e                   	outsb  %ds:(%esi),(%dx)
    904e:	6f                   	outsl  %ds:(%esi),(%dx)
    904f:	74 20                	je     9071 <exec_kernel+0xcc>
    9051:	66 69 6e 64 20 62    	imul   $0x6220,0x64(%esi),%bp
    9057:	6f                   	outsl  %ds:(%esi),(%dx)
    9058:	6f                   	outsl  %ds:(%esi),(%dx)
    9059:	74 61                	je     90bc <exec_kernel+0x117>
    905b:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    905f:	70 61                	jo     90c2 <exec_kernel+0x11d>
    9061:	72 74                	jb     90d7 <exec_kernel+0x132>
    9063:	69 74 69 6f 6e 21 00 	imul   $0x4c00216e,0x6f(%ecx,%ebp,2),%esi
    906a:	4c 
    906b:	6f                   	outsl  %ds:(%esi),(%dx)
    906c:	61                   	popa
    906d:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    9071:	72 6e                	jb     90e1 <exec_kernel+0x13c>
    9073:	65 6c                	gs insb (%dx),%es:(%edi)
    9075:	20 2e                	and    %ch,(%esi)
    9077:	2e 2e 0a 00          	cs or  %cs:(%eax),%al
    907b:	53                   	push   %ebx
    907c:	74 61                	je     90df <exec_kernel+0x13a>
    907e:	72 74                	jb     90f4 <exec_kernel+0x14f>
    9080:	20 6b 65             	and    %ch,0x65(%ebx)
    9083:	72 6e                	jb     90f3 <exec_kernel+0x14e>
    9085:	65 6c                	gs insb (%dx),%es:(%edi)
    9087:	20 2e                	and    %ch,(%esi)
    9089:	2e 2e 0a 00          	cs or  %cs:(%eax),%al
    908d:	46                   	inc    %esi
    908e:	61                   	popa
    908f:	69 6c 20 74 6f 20 6c 	imul   $0x6f6c206f,0x74(%eax,%eiz,1),%ebp
    9096:	6f 
    9097:	61                   	popa
    9098:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    909c:	72 6e                	jb     910c <exec_kernel+0x167>
    909e:	65 6c                	gs insb (%dx),%es:(%edi)
    90a0:	2e                   	cs
    90a1:	00                   	.byte 0

Disassembly of section .eh_frame:

000090a4 <.eh_frame>:
    90a4:	14 00                	adc    $0x0,%al
    90a6:	00 00                	add    %al,(%eax)
    90a8:	00 00                	add    %al,(%eax)
    90aa:	00 00                	add    %al,(%eax)
    90ac:	01 7a 52             	add    %edi,0x52(%edx)
    90af:	00 01                	add    %al,(%ecx)
    90b1:	7c 08                	jl     90bb <exec_kernel+0x116>
    90b3:	01 1b                	add    %ebx,(%ebx)
    90b5:	0c 04                	or     $0x4,%al
    90b7:	04 88                	add    $0x88,%al
    90b9:	01 00                	add    %eax,(%eax)
    90bb:	00 1c 00             	add    %bl,(%eax,%eax,1)
    90be:	00 00                	add    %al,(%eax)
    90c0:	1c 00                	sbb    $0x0,%al
    90c2:	00 00                	add    %al,(%eax)
    90c4:	62 fa ff             	(bad) {rz-bad},{%k7}{z}
    90c7:	ff 26                	jmp    *(%esi)
    90c9:	00 00                	add    %al,(%eax)
    90cb:	00 00                	add    %al,(%eax)
    90cd:	4c                   	dec    %esp
    90ce:	0e                   	push   %cs
    90cf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90d5:	57                   	push   %edi
    90d6:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90d9:	04 00                	add    $0x0,%al
    90db:	00 24 00             	add    %ah,(%eax,%eax,1)
    90de:	00 00                	add    %al,(%eax)
    90e0:	3c 00                	cmp    $0x0,%al
    90e2:	00 00                	add    %al,(%eax)
    90e4:	68 fa ff ff 3a       	push   $0x3afffffa
    90e9:	00 00                	add    %al,(%eax)
    90eb:	00 00                	add    %al,(%eax)
    90ed:	41                   	inc    %ecx
    90ee:	0e                   	push   %cs
    90ef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90f5:	42                   	inc    %edx
    90f6:	86 03                	xchg   %al,(%ebx)
    90f8:	83 04 72 c3          	addl   $0xffffffc3,(%edx,%esi,2)
    90fc:	41                   	inc    %ecx
    90fd:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    9101:	04 04                	add    $0x4,%al
    9103:	00 20                	add    %ah,(%eax)
    9105:	00 00                	add    %al,(%eax)
    9107:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    910b:	00 7a fa             	add    %bh,-0x6(%edx)
    910e:	ff                   	(bad)
    910f:	ff 4b 00             	decl   0x0(%ebx)
    9112:	00 00                	add    %al,(%eax)
    9114:	00 41 0e             	add    %al,0xe(%ecx)
    9117:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    911d:	42                   	inc    %edx
    911e:	83 03 02             	addl   $0x2,(%ebx)
    9121:	45                   	inc    %ebp
    9122:	c5 c3 0c             	(bad)
    9125:	04 04                	add    $0x4,%al
    9127:	00 1c 00             	add    %bl,(%eax,%eax,1)
    912a:	00 00                	add    %al,(%eax)
    912c:	88 00                	mov    %al,(%eax)
    912e:	00 00                	add    %al,(%eax)
    9130:	a1 fa ff ff 18       	mov    0x18fffffa,%eax
    9135:	00 00                	add    %al,(%eax)
    9137:	00 00                	add    %al,(%eax)
    9139:	4b                   	dec    %ebx
    913a:	0e                   	push   %cs
    913b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9141:	44                   	inc    %esp
    9142:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9145:	04 00                	add    $0x0,%al
    9147:	00 18                	add    %bl,(%eax)
    9149:	00 00                	add    %al,(%eax)
    914b:	00 a8 00 00 00 99    	add    %ch,-0x67000000(%eax)
    9151:	fa                   	cli
    9152:	ff                   	(bad)
    9153:	ff 1a                	lcall  *(%edx)
    9155:	00 00                	add    %al,(%eax)
    9157:	00 00                	add    %al,(%eax)
    9159:	41                   	inc    %ecx
    915a:	0e                   	push   %cs
    915b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9161:	00 00                	add    %al,(%eax)
    9163:	00 1c 00             	add    %bl,(%eax,%eax,1)
    9166:	00 00                	add    %al,(%eax)
    9168:	c4 00                	les    (%eax),%eax
    916a:	00 00                	add    %al,(%eax)
    916c:	97                   	xchg   %eax,%edi
    916d:	fa                   	cli
    916e:	ff                   	(bad)
    916f:	ff 13                	call   *(%ebx)
    9171:	00 00                	add    %al,(%eax)
    9173:	00 00                	add    %al,(%eax)
    9175:	41                   	inc    %ecx
    9176:	0e                   	push   %cs
    9177:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
    917d:	4d                   	dec    %ebp
    917e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9181:	04 00                	add    $0x0,%al
    9183:	00 24 00             	add    %ah,(%eax,%eax,1)
    9186:	00 00                	add    %al,(%eax)
    9188:	e4 00                	in     $0x0,%al
    918a:	00 00                	add    %al,(%eax)
    918c:	8a fa                	mov    %dl,%bh
    918e:	ff                   	(bad)
    918f:	ff 35 00 00 00 00    	push   0x0
    9195:	41                   	inc    %ecx
    9196:	0e                   	push   %cs
    9197:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    919d:	42                   	inc    %edx
    919e:	86 03                	xchg   %al,(%ebx)
    91a0:	83 04 6d c3 41 c6 41 	addl   $0xffffffc5,0x41c641c3(,%ebp,2)
    91a7:	c5 
    91a8:	0c 04                	or     $0x4,%al
    91aa:	04 00                	add    $0x0,%al
    91ac:	28 00                	sub    %al,(%eax)
    91ae:	00 00                	add    %al,(%eax)
    91b0:	0c 01                	or     $0x1,%al
    91b2:	00 00                	add    %al,(%eax)
    91b4:	97                   	xchg   %eax,%edi
    91b5:	fa                   	cli
    91b6:	ff                   	(bad)
    91b7:	ff 57 00             	call   *0x0(%edi)
    91ba:	00 00                	add    %al,(%eax)
    91bc:	00 41 0e             	add    %al,0xe(%ecx)
    91bf:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91c5:	46                   	inc    %esi
    91c6:	87 03                	xchg   %eax,(%ebx)
    91c8:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    91cb:	05 02 46 c3 41       	add    $0x41c34602,%eax
    91d0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    91d4:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    91d7:	04 1c                	add    $0x1c,%al
    91d9:	00 00                	add    %al,(%eax)
    91db:	00 38                	add    %bh,(%eax)
    91dd:	01 00                	add    %eax,(%eax)
    91df:	00 c2                	add    %al,%dl
    91e1:	fa                   	cli
    91e2:	ff                   	(bad)
    91e3:	ff 29                	ljmp   *(%ecx)
    91e5:	00 00                	add    %al,(%eax)
    91e7:	00 00                	add    %al,(%eax)
    91e9:	4b                   	dec    %ebx
    91ea:	0e                   	push   %cs
    91eb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91f1:	5b                   	pop    %ebx
    91f2:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    91f5:	04 00                	add    $0x0,%al
    91f7:	00 1c 00             	add    %bl,(%eax,%eax,1)
    91fa:	00 00                	add    %al,(%eax)
    91fc:	58                   	pop    %eax
    91fd:	01 00                	add    %eax,(%eax)
    91ff:	00 cb                	add    %cl,%bl
    9201:	fa                   	cli
    9202:	ff                   	(bad)
    9203:	ff 29                	ljmp   *(%ecx)
    9205:	00 00                	add    %al,(%eax)
    9207:	00 00                	add    %al,(%eax)
    9209:	4b                   	dec    %ebx
    920a:	0e                   	push   %cs
    920b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9211:	5b                   	pop    %ebx
    9212:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9215:	04 00                	add    $0x0,%al
    9217:	00 20                	add    %ah,(%eax)
    9219:	00 00                	add    %al,(%eax)
    921b:	00 78 01             	add    %bh,0x1(%eax)
    921e:	00 00                	add    %al,(%eax)
    9220:	d4 fa                	aam    $0xfa
    9222:	ff                   	(bad)
    9223:	ff 2f                	ljmp   *(%edi)
    9225:	00 00                	add    %al,(%eax)
    9227:	00 00                	add    %al,(%eax)
    9229:	4b                   	dec    %ebx
    922a:	0e                   	push   %cs
    922b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9231:	41                   	inc    %ecx
    9232:	83 03 5c             	addl   $0x5c,(%ebx)
    9235:	c5 c3 0c             	(bad)
    9238:	04 04                	add    $0x4,%al
    923a:	00 00                	add    %al,(%eax)
    923c:	20 00                	and    %al,(%eax)
    923e:	00 00                	add    %al,(%eax)
    9240:	9c                   	pushf
    9241:	01 00                	add    %eax,(%eax)
    9243:	00 df                	add    %bl,%bh
    9245:	fa                   	cli
    9246:	ff                   	(bad)
    9247:	ff 6f 00             	ljmp   *0x0(%edi)
    924a:	00 00                	add    %al,(%eax)
    924c:	00 41 0e             	add    %al,0xe(%ecx)
    924f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9255:	41                   	inc    %ecx
    9256:	87 03                	xchg   %eax,(%ebx)
    9258:	02 69 c7             	add    -0x39(%ecx),%ch
    925b:	41                   	inc    %ecx
    925c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    925f:	04 28                	add    $0x28,%al
    9261:	00 00                	add    %al,(%eax)
    9263:	00 c0                	add    %al,%al
    9265:	01 00                	add    %eax,(%eax)
    9267:	00 2a                	add    %ch,(%edx)
    9269:	fb                   	sti
    926a:	ff                   	(bad)
    926b:	ff 47 00             	incl   0x0(%edi)
    926e:	00 00                	add    %al,(%eax)
    9270:	00 41 0e             	add    %al,0xe(%ecx)
    9273:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9279:	46                   	inc    %esi
    927a:	87 03                	xchg   %eax,(%ebx)
    927c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    927f:	05 7a c3 41 c6       	add    $0xc641c37a,%eax
    9284:	41                   	inc    %ecx
    9285:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
    928c:	10 00                	adc    %al,(%eax)
    928e:	00 00                	add    %al,(%eax)
    9290:	ec                   	in     (%dx),%al
    9291:	01 00                	add    %eax,(%eax)
    9293:	00 45 fb             	add    %al,-0x5(%ebp)
    9296:	ff                   	(bad)
    9297:	ff 04 00             	incl   (%eax,%eax,1)
    929a:	00 00                	add    %al,(%eax)
    929c:	00 00                	add    %al,(%eax)
    929e:	00 00                	add    %al,(%eax)
    92a0:	10 00                	adc    %al,(%eax)
    92a2:	00 00                	add    %al,(%eax)
    92a4:	00 02                	add    %al,(%edx)
    92a6:	00 00                	add    %al,(%eax)
    92a8:	35 fb ff ff 04       	xor    $0x4fffffb,%eax
    92ad:	00 00                	add    %al,(%eax)
    92af:	00 00                	add    %al,(%eax)
    92b1:	00 00                	add    %al,(%eax)
    92b3:	00 28                	add    %ch,(%eax)
    92b5:	00 00                	add    %al,(%eax)
    92b7:	00 14 02             	add    %dl,(%edx,%eax,1)
    92ba:	00 00                	add    %al,(%eax)
    92bc:	25 fb ff ff 8f       	and    $0x8ffffffb,%eax
    92c1:	00 00                	add    %al,(%eax)
    92c3:	00 00                	add    %al,(%eax)
    92c5:	41                   	inc    %ecx
    92c6:	0e                   	push   %cs
    92c7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    92cd:	43                   	inc    %ebx
    92ce:	87 03                	xchg   %eax,(%ebx)
    92d0:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    92d3:	05 02 80 c3 41       	add    $0x41c38002,%eax
    92d8:	c6 46 c7 41          	movb   $0x41,-0x39(%esi)
    92dc:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    92df:	04 2c                	add    $0x2c,%al
    92e1:	00 00                	add    %al,(%eax)
    92e3:	00 40 02             	add    %al,0x2(%eax)
    92e6:	00 00                	add    %al,(%eax)
    92e8:	88 fb                	mov    %bh,%bl
    92ea:	ff                   	(bad)
    92eb:	ff 77 00             	push   0x0(%edi)
    92ee:	00 00                	add    %al,(%eax)
    92f0:	00 41 0e             	add    %al,0xe(%ecx)
    92f3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    92f9:	42                   	inc    %edx
    92fa:	87 03                	xchg   %eax,(%ebx)
    92fc:	86 04 43             	xchg   %al,(%ebx,%eax,2)
    92ff:	83 05 02 6b c3 41 c6 	addl   $0xffffffc6,0x41c36b02
    9306:	41                   	inc    %ecx
    9307:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
    930e:	00 00                	add    %al,(%eax)
    9310:	24 00                	and    $0x0,%al
    9312:	00 00                	add    %al,(%eax)
    9314:	70 02                	jo     9318 <exec_kernel+0x373>
    9316:	00 00                	add    %al,(%eax)
    9318:	cf                   	iret
    9319:	fb                   	sti
    931a:	ff                   	(bad)
    931b:	ff                   	(bad)
    931c:	ba 00 00 00 00       	mov    $0x0,%edx
    9321:	41                   	inc    %ecx
    9322:	0e                   	push   %cs
    9323:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9329:	42                   	inc    %edx
    932a:	86 03                	xchg   %al,(%ebx)
    932c:	83 04 02 b2          	addl   $0xffffffb2,(%edx,%eax,1)
    9330:	c3                   	ret
    9331:	41                   	inc    %ecx
    9332:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    9336:	04 04                	add    $0x4,%al
    9338:	10 00                	adc    %al,(%eax)
    933a:	00 00                	add    %al,(%eax)
    933c:	98                   	cwtl
    933d:	02 00                	add    (%eax),%al
    933f:	00 61 fc             	add    %ah,-0x4(%ecx)
    9342:	ff                   	(bad)
    9343:	ff 04 00             	incl   (%eax,%eax,1)
    9346:	00 00                	add    %al,(%eax)
    9348:	00 00                	add    %al,(%eax)
    934a:	00 00                	add    %al,(%eax)

Disassembly of section .got.plt:

0000934c <_GLOBAL_OFFSET_TABLE_>:
    934c:	00 00                	add    %al,(%eax)
    934e:	00 00                	add    %al,(%eax)
    9350:	00 00                	add    %al,(%eax)
    9352:	00 00                	add    %al,(%eax)
    9354:	00 00                	add    %al,(%eax)
    9356:	00 00                	add    %al,(%eax)

Disassembly of section .data:

00009360 <hex.0>:
    static char hex[] = "0123456789abcdef";
    9360:	30 31                	xor    %dh,(%ecx)
    9362:	32 33                	xor    (%ebx),%dh
    9364:	34 35                	xor    $0x35,%al
    9366:	36 37                	ss aaa
    9368:	38 39                	cmp    %bh,(%ecx)
    936a:	61                   	popa
    936b:	62 63 64             	bound  %esp,0x64(%ebx)
    936e:	65 66 00 00          	data16 add %al,%gs:(%eax)
    9372:	00 00                	add    %al,(%eax)

00009374 <dec.1>:
    static char dec[] = "0123456789";
    9374:	30 31                	xor    %dh,(%ecx)
    9376:	32 33                	xor    (%ebx),%dh
    9378:	34 35                	xor    $0x35,%al
    937a:	36 37                	ss aaa
    937c:	38 39                	cmp    %bh,(%ecx)
    937e:	00 00                	add    %al,(%eax)

00009380 <video>:
volatile char *video = (volatile char *) 0xB8000;
    9380:	00 80 0b 00      	add    %al,-0x704afff5(%eax)

00009384 <blank>:
char *blank =
    9384:	b5 8f                	mov    $0x8f,%ch
    9386:	00 00                	add    %al,(%eax)
    9388:	00 00                	add    %al,(%eax)
    938a:	00 00                	add    %al,(%eax)
    938c:	00 00                	add    %al,(%eax)
    938e:	00 00                	add    %al,(%eax)
    9390:	00 00                	add    %al,(%eax)
    9392:	00 00                	add    %al,(%eax)
    9394:	00 00                	add    %al,(%eax)
    9396:	00 00                	add    %al,(%eax)
    9398:	00 00                	add    %al,(%eax)
    939a:	00 00                	add    %al,(%eax)
    939c:	00 00                	add    %al,(%eax)
    939e:	00 00                	add    %al,(%eax)

000093a0 <mboot_info>:
mboot_info_t mboot_info = {.flags = (1 << 6), };
    93a0:	40                   	inc    %eax
    93a1:	00 00                	add    %al,(%eax)
    93a3:	00 00                	add    %al,(%eax)
    93a5:	00 00                	add    %al,(%eax)
    93a7:	00 00                	add    %al,(%eax)
    93a9:	00 00                	add    %al,(%eax)
    93ab:	00 00                	add    %al,(%eax)
    93ad:	00 00                	add    %al,(%eax)
    93af:	00 00                	add    %al,(%eax)
    93b1:	00 00                	add    %al,(%eax)
    93b3:	00 00                	add    %al,(%eax)
    93b5:	00 00                	add    %al,(%eax)
    93b7:	00 00                	add    %al,(%eax)
    93b9:	00 00                	add    %al,(%eax)
    93bb:	00 00                	add    %al,(%eax)
    93bd:	00 00                	add    %al,(%eax)
    93bf:	00 00                	add    %al,(%eax)
    93c1:	00 00                	add    %al,(%eax)
    93c3:	00 00                	add    %al,(%eax)
    93c5:	00 00                	add    %al,(%eax)
    93c7:	00 00                	add    %al,(%eax)
    93c9:	00 00                	add    %al,(%eax)
    93cb:	00 00                	add    %al,(%eax)
    93cd:	00 00                	add    %al,(%eax)
    93cf:	00 00                	add    %al,(%eax)
    93d1:	00 00                	add    %al,(%eax)
    93d3:	00 00                	add    %al,(%eax)
    93d5:	00 00                	add    %al,(%eax)
    93d7:	00 00                	add    %al,(%eax)
    93d9:	00 00                	add    %al,(%eax)
    93db:	00 00                	add    %al,(%eax)
    93dd:	00 00                	add    %al,(%eax)
    93df:	00 00                	add    %al,(%eax)
    93e1:	00 00                	add    %al,(%eax)
    93e3:	00 00                	add    %al,(%eax)
    93e5:	00 00                	add    %al,(%eax)
    93e7:	00 00                	add    %al,(%eax)
    93e9:	00 00                	add    %al,(%eax)
    93eb:	00 00                	add    %al,(%eax)
    93ed:	00 00                	add    %al,(%eax)
    93ef:	00 00                	add    %al,(%eax)
    93f1:	00 00                	add    %al,(%eax)
    93f3:	00 00                	add    %al,(%eax)
    93f5:	00 00                	add    %al,(%eax)
    93f7:	00 00                	add    %al,(%eax)
    93f9:	00 00                	add    %al,(%eax)
    93fb:	00 00                	add    %al,(%eax)
    93fd:	00 00                	add    %al,(%eax)
    93ff:	00                   	.byte 0

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 44 65 62          	sub    %al,0x62(%ebp,%eiz,2)
   9:	69 61 6e 20 31 34 2e 	imul   $0x2e343120,0x6e(%ecx),%esp
  10:	32 2e                	xor    (%esi),%ch
  12:	30 2d 33 29 20 31    	xor    %ch,0x31202933
  18:	34 2e                	xor    $0x2e,%al
  1a:	32 2e                	xor    (%esi),%ch
  1c:	30 00                	xor    %al,(%eax)

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 26                	add    %ah,(%esi)
  15:	0d 00 00 00 00       	or     $0x0,%eax
  1a:	00 00                	add    %al,(%eax)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 00                	add    %al,(%eax)
  20:	1c 00                	sbb    $0x0,%al
  22:	00 00                	add    %al,(%eax)
  24:	02 00                	add    (%eax),%al
  26:	25 00 00 00 04       	and    $0x4000000,%eax
  2b:	00 00                	add    %al,(%eax)
  2d:	00 00                	add    %al,(%eax)
  2f:	00 26                	add    %ah,(%esi)
  31:	8b 00                	mov    (%eax),%eax
  33:	00 b3 02 00 00 00    	add    %dh,0x2(%ebx)
  39:	00 00                	add    %al,(%eax)
  3b:	00 00                	add    %al,(%eax)
  3d:	00 00                	add    %al,(%eax)
  3f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  42:	00 00                	add    %al,(%eax)
  44:	02 00                	add    (%eax),%al
  46:	75 07                	jne    4f <PROT_MODE_DSEG+0x3f>
  48:	00 00                	add    %al,(%eax)
  4a:	04 00                	add    $0x0,%al
  4c:	00 00                	add    %al,(%eax)
  4e:	00 00                	add    %al,(%eax)
  50:	e1 8d                	loope  ffffffdf <SMAP_SIG+0xacb2be8f>
  52:	00 00                	add    %al,(%eax)
  54:	c0 01 00             	rolb   $0x0,(%ecx)
  57:	00 00                	add    %al,(%eax)
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  62:	00 00                	add    %al,(%eax)
  64:	02 00                	add    (%eax),%al
  66:	bd 0e 00 00 04       	mov    $0x400000e,%ebp
  6b:	00 00                	add    %al,(%eax)
  6d:	00 00                	add    %al,(%eax)
  6f:	00 a5 8f 00 00 10    	add    %ah,0x1000008f(%ebp)
  75:	00 00                	add    %al,(%eax)
  77:	00 00                	add    %al,(%eax)
  79:	00 00                	add    %al,(%eax)
  7b:	00 00                	add    %al,(%eax)
  7d:	00 00                	add    %al,(%eax)
  7f:	00                   	.byte 0

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	21 00                	and    %eax,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	05 00 01 04 00       	add    $0x40100,%eax
   9:	00 00                	add    %al,(%eax)
   b:	00 01                	add    %al,(%ecx)
   d:	00 00                	add    %al,(%eax)
   f:	00 00                	add    %al,(%eax)
  11:	00 7e 00             	add    %bh,0x0(%esi)
  14:	00 a6 1a 00 00 00    	add    %ah,0x1a(%esi)
  1a:	00 13                	add    %dl,(%ebx)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 3f                	add    %bh,(%edi)
  20:	00 00                	add    %al,(%eax)
  22:	00 01                	add    %al,(%ecx)
  24:	80 4c 07 00 00       	orb    $0x0,0x0(%edi,%eax,1)
  29:	05 00 01 04 14       	add    $0x14040100,%eax
  2e:	00 00                	add    %al,(%eax)
  30:	00 19                	add    %bl,(%ecx)
  32:	b7 00                	mov    $0x0,%bh
  34:	00 00                	add    %al,(%eax)
  36:	1d 3f 00 00 00       	sbb    $0x3f,%eax
  3b:	00 00                	add    %al,(%eax)
  3d:	00 00                	add    %al,(%eax)
  3f:	26 8b 00             	mov    %es:(%eax),%eax
  42:	00 b3 02 00 00 87    	add    %dh,-0x78fffffe(%ebx)
  48:	00 00                	add    %al,(%eax)
  4a:	00 05 01 06 43 01    	add    %al,0x1430601
  50:	00 00                	add    %al,(%eax)
  52:	0d 97 00 00 00       	or     $0x97,%eax
  57:	0d 37 00 00 00       	or     $0x37,%eax
  5c:	05 01 08 41 01       	add    $0x1410801,%eax
  61:	00 00                	add    %al,(%eax)
  63:	05 02 05 65 00       	add    $0x650502,%eax
  68:	00 00                	add    %al,(%eax)
  6a:	05 02 07 83 01       	add    $0x1830702,%eax
  6f:	00 00                	add    %al,(%eax)
  71:	0d 71 01 00 00       	or     $0x171,%eax
  76:	10 56 00             	adc    %dl,0x0(%esi)
  79:	00 00                	add    %al,(%eax)
  7b:	1a 04 05 69 6e 74 00 	sbb    0x746e69(,%eax,1),%al
  82:	0d 70 01 00 00       	or     $0x170,%eax
  87:	11 67 00             	adc    %esp,0x0(%edi)
  8a:	00 00                	add    %al,(%eax)
  8c:	05 04 07 63 01       	add    $0x1630704,%eax
  91:	00 00                	add    %al,(%eax)
  93:	05 08 05 a9 00       	add    $0xa90508,%eax
  98:	00 00                	add    %al,(%eax)
  9a:	05 08 07 59 01       	add    $0x1590708,%eax
  9f:	00 00                	add    %al,(%eax)
  a1:	12 c8                	adc    %al,%cl
  a3:	01 00                	add    %eax,(%eax)
  a5:	00 06                	add    %al,(%esi)
  a7:	10 8d 00 00 00 05    	adc    %cl,0x5000000(%ebp)
  ad:	03 80 93 00 00 0e    	add    0xe000093(%eax),%eax
  b3:	99                   	cltd
  b4:	00 00                	add    %al,(%eax)
  b6:	00 05 01 06 4a 01    	add    %al,0x14a0601
  bc:	00 00                	add    %al,(%eax)
  be:	1b 92 00 00 00 1c    	sbb    0x1c000000(%edx),%edx
  c4:	92                   	xchg   %eax,%edx
  c5:	00 00                	add    %al,(%eax)
  c7:	00 0f                	add    %cl,(%edi)
  c9:	72 6f                	jb     13a <PR_BOOTABLE+0xba>
  cb:	77 00                	ja     cd <PR_BOOTABLE+0x4d>
  cd:	18 0c 56             	sbb    %cl,(%esi,%edx,2)
  d0:	00 00                	add    %al,(%eax)
  d2:	00 05 03 28 94 00    	add    %al,0x942803
  d8:	00 12                	add    %dl,(%edx)
  da:	bd 01 00 00 1a       	mov    $0x1a000001,%ebp
  df:	07                   	pop    %es
  e0:	c5 00                	lds    (%eax),%eax
  e2:	00 00                	add    %al,(%eax)
  e4:	05 03 84 93 00       	add    $0x938403,%eax
  e9:	00 0e                	add    %cl,(%esi)
  eb:	92                   	xchg   %eax,%edx
  ec:	00 00                	add    %al,(%eax)
  ee:	00 10                	add    %dl,(%eax)
  f0:	92                   	xchg   %eax,%edx
  f1:	00 00                	add    %al,(%eax)
  f3:	00 da                	add    %bl,%dl
  f5:	00 00                	add    %al,(%eax)
  f7:	00 11                	add    %dl,(%ecx)
  f9:	67 00 00             	add    %al,(%bx,%si)
  fc:	00 27                	add    %ah,(%edi)
  fe:	00 1d b4 01 00 00    	add    %bl,0x1b4
 104:	01 30                	add    %esi,(%eax)
 106:	0d ca 00 00 00       	or     $0xca,%eax
 10b:	05 03 00 94 00       	add    $0x940003,%eax
 110:	00 02                	add    %al,(%edx)
 112:	30 01                	xor    %al,(%ecx)
 114:	00 00                	add    %al,(%eax)
 116:	8d 92 8d 00 00 47    	lea    0x4700008d(%edx),%edx
 11c:	00 00                	add    %al,(%eax)
 11e:	00 01                	add    %al,(%ecx)
 120:	9c                   	pushf
 121:	68 01 00 00 06       	push   $0x6000001
 126:	76 61                	jbe    189 <PR_BOOTABLE+0x109>
 128:	00 8d 1b 5d 00 00    	add    %cl,0x5d1b(%ebp)
 12e:	00 1e                	add    %bl,(%esi)
 130:	00 00                	add    %al,(%eax)
 132:	00 0c 00             	add    %cl,(%eax,%eax,1)
 135:	00 00                	add    %al,(%eax)
 137:	09 70 04             	or     %esi,0x4(%eax)
 13a:	00 00                	add    %al,(%eax)
 13c:	8d 28                	lea    (%eax),%ebp
 13e:	5d                   	pop    %ebp
 13f:	00 00                	add    %al,(%eax)
 141:	00 80 00 00 00 7c    	add    %al,0x7c000000(%eax)
 147:	00 00                	add    %al,(%eax)
 149:	00 09                	add    %cl,(%ecx)
 14b:	33 02                	xor    (%edx),%eax
 14d:	00 00                	add    %al,(%eax)
 14f:	8d 38                	lea    (%eax),%edi
 151:	5d                   	pop    %ebp
 152:	00 00                	add    %al,(%eax)
 154:	00 9b 00 00 00 91    	add    %bl,-0x6f000000(%ebx)
 15a:	00 00                	add    %al,(%eax)
 15c:	00 06                	add    %al,(%esi)
 15e:	6c                   	insb   (%dx),%es:(%edi)
 15f:	62 61 00             	bound  %esp,0x0(%ecx)
 162:	8d 49 5d             	lea    0x5d(%ecx),%ecx
 165:	00 00                	add    %al,(%eax)
 167:	00 c7                	add    %al,%bh
 169:	00 00                	add    %al,(%eax)
 16b:	00 c3                	add    %al,%bl
 16d:	00 00                	add    %al,(%eax)
 16f:	00 13                	add    %dl,(%ebx)
 171:	4d                   	dec    %ebp
 172:	00 00                	add    %al,(%eax)
 174:	00 8f 0e 5d 00 00    	add    %cl,0x5d0e(%edi)
 17a:	00 de                	add    %bl,%dh
 17c:	00 00                	add    %al,(%eax)
 17e:	00 d8                	add    %bl,%al
 180:	00 00                	add    %al,(%eax)
 182:	00 04 cc             	add    %al,(%esp,%ecx,8)
 185:	8d 00                	lea    (%eax),%eax
 187:	00 68 01             	add    %ch,0x1(%eax)
 18a:	00 00                	add    %al,(%eax)
 18c:	00 02                	add    %al,(%edx)
 18e:	8c 00                	mov    %es,(%eax)
 190:	00 00                	add    %al,(%eax)
 192:	78 23                	js     1b7 <PR_BOOTABLE+0x137>
 194:	8d 00                	lea    (%eax),%eax
 196:	00 6f 00             	add    %ch,0x0(%edi)
 199:	00 00                	add    %al,(%eax)
 19b:	01 9c 82 03 00 00 03 	add    %ebx,0x3000003(%edx,%eax,4)
 1a2:	64 73 74             	fs jae 219 <PR_BOOTABLE+0x199>
 1a5:	00 78 17             	add    %bh,0x17(%eax)
 1a8:	82 03 00             	addb   $0x0,(%ebx)
 1ab:	00 02                	add    %al,(%edx)
 1ad:	91                   	xchg   %eax,%ecx
 1ae:	00 0a                	add    %cl,(%edx)
 1b0:	33 02                	xor    (%edx),%eax
 1b2:	00 00                	add    %al,(%eax)
 1b4:	78 25                	js     1db <PR_BOOTABLE+0x15b>
 1b6:	5d                   	pop    %ebp
 1b7:	00 00                	add    %al,(%eax)
 1b9:	00 02                	add    %al,(%edx)
 1bb:	91                   	xchg   %eax,%ecx
 1bc:	04 0b                	add    $0xb,%al
 1be:	84 03                	test   %al,(%ebx)
 1c0:	00 00                	add    %al,(%eax)
 1c2:	23 8d 00 00 02 0c    	and    0xc020000(%ebp),%ecx
 1c8:	00 00                	add    %al,(%eax)
 1ca:	00 7b dc             	add    %bh,-0x24(%ebx)
 1cd:	01 00                	add    %eax,(%eax)
 1cf:	00 14 06             	add    %dl,(%esi,%eax,1)
 1d2:	07                   	pop    %es
 1d3:	00 00                	add    %al,(%eax)
 1d5:	2f                   	das
 1d6:	8d 00                	lea    (%eax),%eax
 1d8:	00 01                	add    %al,(%ecx)
 1da:	1c 00                	sbb    $0x0,%al
 1dc:	00 00                	add    %al,(%eax)
 1de:	74 01                	je     1e1 <PR_BOOTABLE+0x161>
 1e0:	17                   	pop    %ss
 1e1:	07                   	pop    %es
 1e2:	00 00                	add    %al,(%eax)
 1e4:	10 01                	adc    %al,(%ecx)
 1e6:	00 00                	add    %al,(%eax)
 1e8:	0e                   	push   %cs
 1e9:	01 00                	add    %eax,(%eax)
 1eb:	00 15 1c 00 00 00    	add    %dl,0x1c
 1f1:	16                   	push   %ss
 1f2:	22 07                	and    (%edi),%al
 1f4:	00 00                	add    %al,(%eax)
 1f6:	1d 01 00 00 1b       	sbb    $0x1b000001,%eax
 1fb:	01 00                	add    %eax,(%eax)
 1fd:	00 00                	add    %al,(%eax)
 1ff:	00 00                	add    %al,(%eax)
 201:	0c 2f                	or     $0x2f,%al
 203:	07                   	pop    %es
 204:	00 00                	add    %al,(%eax)
 206:	39 8d 00 00 01 39    	cmp    %ecx,0x39010000(%ebp)
 20c:	8d 00                	lea    (%eax),%eax
 20e:	00 08                	add    %cl,(%eax)
 210:	00 00                	add    %al,(%eax)
 212:	00 7d 0e             	add    %bh,0xe(%ebp)
 215:	02 00                	add    (%eax),%al
 217:	00 01                	add    %al,(%ecx)
 219:	38 07                	cmp    %al,(%edi)
 21b:	00 00                	add    %al,(%eax)
 21d:	27                   	daa
 21e:	01 00                	add    %eax,(%eax)
 220:	00 25 01 00 00 01    	add    %ah,0x1000001
 226:	43                   	inc    %ebx
 227:	07                   	pop    %es
 228:	00 00                	add    %al,(%eax)
 22a:	34 01                	xor    $0x1,%al
 22c:	00 00                	add    %al,(%eax)
 22e:	32 01                	xor    (%ecx),%al
 230:	00 00                	add    %al,(%eax)
 232:	00 0c 2f             	add    %cl,(%edi,%ebp,1)
 235:	07                   	pop    %es
 236:	00 00                	add    %al,(%eax)
 238:	41                   	inc    %ecx
 239:	8d 00                	lea    (%eax),%eax
 23b:	00 02                	add    %al,(%edx)
 23d:	41                   	inc    %ecx
 23e:	8d 00                	lea    (%eax),%eax
 240:	00 08                	add    %cl,(%eax)
 242:	00 00                	add    %al,(%eax)
 244:	00 7e 40             	add    %bh,0x40(%esi)
 247:	02 00                	add    (%eax),%al
 249:	00 01                	add    %al,(%ecx)
 24b:	38 07                	cmp    %al,(%edi)
 24d:	00 00                	add    %al,(%eax)
 24f:	3f                   	aas
 250:	01 00                	add    %eax,(%eax)
 252:	00 3d 01 00 00 01    	add    %bh,0x1000001
 258:	43                   	inc    %ebx
 259:	07                   	pop    %es
 25a:	00 00                	add    %al,(%eax)
 25c:	4c                   	dec    %esp
 25d:	01 00                	add    %eax,(%eax)
 25f:	00 4a 01             	add    %cl,0x1(%edx)
 262:	00 00                	add    %al,(%eax)
 264:	00 0b                	add    %cl,(%ebx)
 266:	2f                   	das
 267:	07                   	pop    %es
 268:	00 00                	add    %al,(%eax)
 26a:	49                   	dec    %ecx
 26b:	8d 00                	lea    (%eax),%eax
 26d:	00 02                	add    %al,(%edx)
 26f:	27                   	daa
 270:	00 00                	add    %al,(%eax)
 272:	00 7f 6e             	add    %bh,0x6e(%edi)
 275:	02 00                	add    (%eax),%al
 277:	00 01                	add    %al,(%ecx)
 279:	38 07                	cmp    %al,(%edi)
 27b:	00 00                	add    %al,(%eax)
 27d:	56                   	push   %esi
 27e:	01 00                	add    %eax,(%eax)
 280:	00 54 01 00          	add    %dl,0x0(%ecx,%eax,1)
 284:	00 01                	add    %al,(%ecx)
 286:	43                   	inc    %ebx
 287:	07                   	pop    %es
 288:	00 00                	add    %al,(%eax)
 28a:	63 01                	arpl   %eax,(%ecx)
 28c:	00 00                	add    %al,(%eax)
 28e:	61                   	popa
 28f:	01 00                	add    %eax,(%eax)
 291:	00 00                	add    %al,(%eax)
 293:	0b 2f                	or     (%edi),%ebp
 295:	07                   	pop    %es
 296:	00 00                	add    %al,(%eax)
 298:	54                   	push   %esp
 299:	8d 00                	lea    (%eax),%eax
 29b:	00 02                	add    %al,(%edx)
 29d:	37                   	aaa
 29e:	00 00                	add    %al,(%eax)
 2a0:	00 80 9c 02 00 00    	add    %al,0x29c(%eax)
 2a6:	01 38                	add    %edi,(%eax)
 2a8:	07                   	pop    %es
 2a9:	00 00                	add    %al,(%eax)
 2ab:	6e                   	outsb  %ds:(%esi),(%dx)
 2ac:	01 00                	add    %eax,(%eax)
 2ae:	00 6c 01 00          	add    %ch,0x0(%ecx,%eax,1)
 2b2:	00 01                	add    %al,(%ecx)
 2b4:	43                   	inc    %ebx
 2b5:	07                   	pop    %es
 2b6:	00 00                	add    %al,(%eax)
 2b8:	7b 01                	jnp    2bb <PR_BOOTABLE+0x23b>
 2ba:	00 00                	add    %al,(%eax)
 2bc:	79 01                	jns    2bf <PR_BOOTABLE+0x23f>
 2be:	00 00                	add    %al,(%eax)
 2c0:	00 0b                	add    %cl,(%ebx)
 2c2:	2f                   	das
 2c3:	07                   	pop    %es
 2c4:	00 00                	add    %al,(%eax)
 2c6:	5f                   	pop    %edi
 2c7:	8d 00                	lea    (%eax),%eax
 2c9:	00 02                	add    %al,(%edx)
 2cb:	47                   	inc    %edi
 2cc:	00 00                	add    %al,(%eax)
 2ce:	00 81 ca 02 00 00    	add    %al,0x2ca(%ecx)
 2d4:	01 38                	add    %edi,(%eax)
 2d6:	07                   	pop    %es
 2d7:	00 00                	add    %al,(%eax)
 2d9:	86 01                	xchg   %al,(%ecx)
 2db:	00 00                	add    %al,(%eax)
 2dd:	84 01                	test   %al,(%ecx)
 2df:	00 00                	add    %al,(%eax)
 2e1:	01 43 07             	add    %eax,0x7(%ebx)
 2e4:	00 00                	add    %al,(%eax)
 2e6:	93                   	xchg   %eax,%ebx
 2e7:	01 00                	add    %eax,(%eax)
 2e9:	00 91 01 00 00 00    	add    %dl,0x1(%ecx)
 2ef:	0c 2f                	or     $0x2f,%al
 2f1:	07                   	pop    %es
 2f2:	00 00                	add    %al,(%eax)
 2f4:	6d                   	insl   (%dx),%es:(%edi)
 2f5:	8d 00                	lea    (%eax),%eax
 2f7:	00 02                	add    %al,(%edx)
 2f9:	6d                   	insl   (%dx),%es:(%edi)
 2fa:	8d 00                	lea    (%eax),%eax
 2fc:	00 05 00 00 00 82    	add    %al,0x82000000
 302:	fc                   	cld
 303:	02 00                	add    (%eax),%al
 305:	00 01                	add    %al,(%ecx)
 307:	38 07                	cmp    %al,(%edi)
 309:	00 00                	add    %al,(%eax)
 30b:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 30c:	01 00                	add    %eax,(%eax)
 30e:	00 a2 01 00 00 01    	add    %ah,0x1000001(%edx)
 314:	43                   	inc    %ebx
 315:	07                   	pop    %es
 316:	00 00                	add    %al,(%eax)
 318:	b1 01                	mov    $0x1,%cl
 31a:	00 00                	add    %al,(%eax)
 31c:	af                   	scas   %es:(%edi),%eax
 31d:	01 00                	add    %eax,(%eax)
 31f:	00 00                	add    %al,(%eax)
 321:	0c 84                	or     $0x84,%al
 323:	03 00                	add    (%eax),%eax
 325:	00 72 8d             	add    %dh,-0x73(%edx)
 328:	00 00                	add    %al,(%eax)
 32a:	02 72 8d             	add    -0x73(%edx),%dh
 32d:	00 00                	add    %al,(%eax)
 32f:	0d 00 00 00 85       	or     $0x85000000,%eax
 334:	44                   	inc    %esp
 335:	03 00                	add    (%eax),%eax
 337:	00 14 06             	add    %dl,(%esi,%eax,1)
 33a:	07                   	pop    %es
 33b:	00 00                	add    %al,(%eax)
 33d:	77 8d                	ja     2cc <PR_BOOTABLE+0x24c>
 33f:	00 00                	add    %al,(%eax)
 341:	01 57 00             	add    %edx,0x0(%edi)
 344:	00 00                	add    %al,(%eax)
 346:	74 01                	je     349 <PR_BOOTABLE+0x2c9>
 348:	17                   	pop    %ss
 349:	07                   	pop    %es
 34a:	00 00                	add    %al,(%eax)
 34c:	bd 01 00 00 bb       	mov    $0xbb000001,%ebp
 351:	01 00                	add    %eax,(%eax)
 353:	00 15 57 00 00 00    	add    %dl,0x57
 359:	16                   	push   %ss
 35a:	22 07                	and    (%edi),%al
 35c:	00 00                	add    %al,(%eax)
 35e:	ca 01 00             	lret   $0x1
 361:	00 c8                	add    %cl,%al
 363:	01 00                	add    %eax,(%eax)
 365:	00 00                	add    %al,(%eax)
 367:	00 00                	add    %al,(%eax)
 369:	1e                   	push   %ds
 36a:	d6                   	(bad)
 36b:	06                   	push   %es
 36c:	00 00                	add    %al,(%eax)
 36e:	7f 8d                	jg     2fd <PR_BOOTABLE+0x27d>
 370:	00 00                	add    %al,(%eax)
 372:	01 7f 8d             	add    %edi,-0x73(%edi)
 375:	00 00                	add    %al,(%eax)
 377:	10 00                	adc    %al,(%eax)
 379:	00 00                	add    %al,(%eax)
 37b:	01 88 05 01 e3 06    	add    %ecx,0x6e30105(%eax)
 381:	00 00                	add    %al,(%eax)
 383:	d4 01                	aam    $0x1
 385:	00 00                	add    %al,(%eax)
 387:	d2 01                	rolb   %cl,(%ecx)
 389:	00 00                	add    %al,(%eax)
 38b:	01 ee                	add    %ebp,%esi
 38d:	06                   	push   %es
 38e:	00 00                	add    %al,(%eax)
 390:	e1 01                	loope  393 <PR_BOOTABLE+0x313>
 392:	00 00                	add    %al,(%eax)
 394:	df 01                	filds  (%ecx)
 396:	00 00                	add    %al,(%eax)
 398:	01 f9                	add    %edi,%ecx
 39a:	06                   	push   %es
 39b:	00 00                	add    %al,(%eax)
 39d:	ec                   	in     (%dx),%al
 39e:	01 00                	add    %eax,(%eax)
 3a0:	00 ea                	add    %ch,%dl
 3a2:	01 00                	add    %eax,(%eax)
 3a4:	00 00                	add    %al,(%eax)
 3a6:	00 1f                	add    %bl,(%edi)
 3a8:	04 20                	add    $0x20,%al
 3aa:	54                   	push   %esp
 3ab:	00 00                	add    %al,(%eax)
 3ad:	00 01                	add    %al,(%ecx)
 3af:	71 0d                	jno    3be <PR_BOOTABLE+0x33e>
 3b1:	01 02                	add    %eax,(%edx)
 3b3:	4f                   	dec    %edi
 3b4:	01 00                	add    %eax,(%eax)
 3b6:	00 68 cb             	add    %ch,-0x35(%eax)
 3b9:	8c 00                	mov    %es,(%eax)
 3bb:	00 29                	add    %ch,(%ecx)
 3bd:	00 00                	add    %al,(%eax)
 3bf:	00 01                	add    %al,(%ecx)
 3c1:	9c                   	pushf
 3c2:	d9 03                	flds   (%ebx)
 3c4:	00 00                	add    %al,(%eax)
 3c6:	03 6e 00             	add    0x0(%esi),%ebp
 3c9:	68 0f 56 00 00       	push   $0x560f
 3ce:	00 02                	add    %al,(%edx)
 3d0:	91                   	xchg   %eax,%ecx
 3d1:	00 06                	add    %al,(%esi)
 3d3:	73 00                	jae    3d5 <PR_BOOTABLE+0x355>
 3d5:	68 18 c5 00 00       	push   $0xc518
 3da:	00 fa                	add    %bh,%dl
 3dc:	01 00                	add    %eax,(%eax)
 3de:	00 f6                	add    %dh,%dh
 3e0:	01 00                	add    %eax,(%eax)
 3e2:	00 0f                	add    %cl,(%edi)
 3e4:	68 65 78 00 6a       	push   $0x6a007865
 3e9:	11 d9                	adc    %ebx,%ecx
 3eb:	03 00                	add    (%eax),%eax
 3ed:	00 05 03 60 93 00    	add    %al,0x936003
 3f3:	00 04 ef             	add    %al,(%edi,%ebp,8)
 3f6:	8c 00                	mov    %es,(%eax)
 3f8:	00 45 04             	add    %al,0x4(%ebp)
 3fb:	00 00                	add    %al,(%eax)
 3fd:	00 10                	add    %dl,(%eax)
 3ff:	92                   	xchg   %eax,%edx
 400:	00 00                	add    %al,(%eax)
 402:	00 e9                	add    %ch,%cl
 404:	03 00                	add    (%eax),%eax
 406:	00 11                	add    %dl,(%ecx)
 408:	67 00 00             	add    %al,(%bx,%si)
 40b:	00 10                	add    %dl,(%eax)
 40d:	00 02                	add    %al,(%edx)
 40f:	3c 01                	cmp    $0x1,%al
 411:	00 00                	add    %al,(%eax)
 413:	62 a2 8c 00 00 29    	bound  %esp,0x2900008c(%edx)
 419:	00 00                	add    %al,(%eax)
 41b:	00 01                	add    %al,(%ecx)
 41d:	9c                   	pushf
 41e:	35 04 00 00 03       	xor    $0x3000004,%eax
 423:	6e                   	outsb  %ds:(%esi),(%dx)
 424:	00 62 0f             	add    %ah,0xf(%edx)
 427:	56                   	push   %esi
 428:	00 00                	add    %al,(%eax)
 42a:	00 02                	add    %al,(%edx)
 42c:	91                   	xchg   %eax,%ecx
 42d:	00 06                	add    %al,(%esi)
 42f:	73 00                	jae    431 <PR_BOOTABLE+0x3b1>
 431:	62 17                	bound  %edx,(%edi)
 433:	c5 00                	lds    (%eax),%eax
 435:	00 00                	add    %al,(%eax)
 437:	0f 02 00             	lar    (%eax),%eax
 43a:	00 0b                	add    %cl,(%ebx)
 43c:	02 00                	add    (%eax),%al
 43e:	00 0f                	add    %cl,(%edi)
 440:	64 65 63 00          	fs arpl %eax,%gs:(%eax)
 444:	64 11 35 04 00 00 05 	adc    %esi,%fs:0x5000004
 44b:	03 74 93 00          	add    0x0(%ebx,%edx,4),%esi
 44f:	00 04 c6             	add    %al,(%esi,%eax,8)
 452:	8c 00                	mov    %es,(%eax)
 454:	00 45 04             	add    %al,0x4(%ebp)
 457:	00 00                	add    %al,(%eax)
 459:	00 10                	add    %dl,(%eax)
 45b:	92                   	xchg   %eax,%edx
 45c:	00 00                	add    %al,(%eax)
 45e:	00 45 04             	add    %al,0x4(%ebp)
 461:	00 00                	add    %al,(%eax)
 463:	11 67 00             	adc    %esp,0x0(%edi)
 466:	00 00                	add    %al,(%eax)
 468:	0a 00                	or     (%eax),%al
 46a:	02 79 01             	add    0x1(%ecx),%bh
 46d:	00 00                	add    %al,(%eax)
 46f:	52                   	push   %edx
 470:	4b                   	dec    %ebx
 471:	8c 00                	mov    %es,(%eax)
 473:	00 57 00             	add    %dl,0x0(%edi)
 476:	00 00                	add    %al,(%eax)
 478:	01 9c c0 04 00 00 06 	add    %ebx,0x6000004(%eax,%eax,8)
 47f:	6e                   	outsb  %ds:(%esi),(%dx)
 480:	00 52 0f             	add    %dl,0xf(%edx)
 483:	56                   	push   %esi
 484:	00 00                	add    %al,(%eax)
 486:	00 24 02             	add    %ah,(%edx,%eax,1)
 489:	00 00                	add    %al,(%eax)
 48b:	20 02                	and    %al,(%edx)
 48d:	00 00                	add    %al,(%eax)
 48f:	03 73 00             	add    0x0(%ebx),%esi
 492:	52                   	push   %edx
 493:	17                   	pop    %ss
 494:	c5 00                	lds    (%eax),%eax
 496:	00 00                	add    %al,(%eax)
 498:	02 91 04 0a c3 01    	add    0x1c30a04(%ecx),%dl
 49e:	00 00                	add    %al,(%eax)
 4a0:	52                   	push   %edx
 4a1:	20 56 00             	and    %dl,0x0(%esi)
 4a4:	00 00                	add    %al,(%eax)
 4a6:	02 91 08 0a cc 03    	add    0x3cc0a08(%ecx),%dl
 4ac:	00 00                	add    %al,(%eax)
 4ae:	52                   	push   %edx
 4af:	2c c5                	sub    $0xc5,%al
 4b1:	00 00                	add    %al,(%eax)
 4b3:	00 02                	add    %al,(%edx)
 4b5:	91                   	xchg   %eax,%ecx
 4b6:	0c 07                	or     $0x7,%al
 4b8:	69 00 54 09 56 00    	imul   $0x560954,(%eax),%eax
 4be:	00 00                	add    %al,(%eax)
 4c0:	3a 02                	cmp    (%edx),%al
 4c2:	00 00                	add    %al,(%eax)
 4c4:	34 02                	xor    $0x2,%al
 4c6:	00 00                	add    %al,(%eax)
 4c8:	13 a7 01 00 00 54    	adc    0x54000001(%edi),%esp
 4ce:	0c 56                	or     $0x56,%al
 4d0:	00 00                	add    %al,(%eax)
 4d2:	00 52 02             	add    %dl,0x2(%edx)
 4d5:	00 00                	add    %al,(%eax)
 4d7:	50                   	push   %eax
 4d8:	02 00                	add    (%eax),%al
 4da:	00 17                	add    %dl,(%edi)
 4dc:	a2 8c 00 00 c0       	mov    %al,0xc000008c
 4e1:	04 00                	add    $0x0,%al
 4e3:	00 00                	add    %al,(%eax)
 4e5:	02 ac 01 00 00 45 16 	add    0x16450000(%ecx,%eax,1),%ch
 4ec:	8c 00                	mov    %es,(%eax)
 4ee:	00 35 00 00 00 01    	add    %dh,0x1000000
 4f4:	9c                   	pushf
 4f5:	1d 05 00 00 03       	sbb    $0x3000005,%eax
 4fa:	73 00                	jae    4fc <PR_BOOTABLE+0x47c>
 4fc:	45                   	inc    %ebp
 4fd:	13 c5                	adc    %ebp,%eax
 4ff:	00 00                	add    %al,(%eax)
 501:	00 02                	add    %al,(%edx)
 503:	91                   	xchg   %eax,%ecx
 504:	00 07                	add    %al,(%edi)
 506:	69 00 47 09 56 00    	imul   $0x560947,(%eax),%eax
 50c:	00 00                	add    %al,(%eax)
 50e:	62 02                	bound  %eax,(%edx)
 510:	00 00                	add    %al,(%eax)
 512:	5a                   	pop    %edx
 513:	02 00                	add    (%eax),%al
 515:	00 07                	add    %al,(%edi)
 517:	6a 00                	push   $0x0
 519:	47                   	inc    %edi
 51a:	0c 56                	or     $0x56,%al
 51c:	00 00                	add    %al,(%eax)
 51e:	00 88 02 00 00 82    	add    %cl,-0x7dfffffe(%eax)
 524:	02 00                	add    (%eax),%al
 526:	00 07                	add    %al,(%edi)
 528:	63 00                	arpl   %eax,(%eax)
 52a:	48                   	dec    %eax
 52b:	0a 92 00 00 00 a2    	or     -0x5e000000(%edx),%dl
 531:	02 00                	add    (%eax),%al
 533:	00 a0 02 00 00 04    	add    %ah,0x4000002(%eax)
 539:	27                   	daa
 53a:	8c 00                	mov    %es,(%eax)
 53c:	00 1d 05 00 00 00    	add    %bl,0x5
 542:	18 96 01 00 00 3b    	sbb    %dl,0x3b000001(%esi)
 548:	56                   	push   %esi
 549:	00 00                	add    %al,(%eax)
 54b:	00 03                	add    %al,(%ebx)
 54d:	8c 00                	mov    %es,(%eax)
 54f:	00 13                	add    %dl,(%ebx)
 551:	00 00                	add    %al,(%eax)
 553:	00 01                	add    %al,(%ecx)
 555:	9c                   	pushf
 556:	58                   	pop    %eax
 557:	05 00 00 06 73       	add    $0x73060000,%eax
 55c:	00 3b                	add    %bh,(%ebx)
 55e:	18 58 05             	sbb    %bl,0x5(%eax)
 561:	00 00                	add    %al,(%eax)
 563:	b2 02                	mov    $0x2,%dl
 565:	00 00                	add    %al,(%eax)
 567:	aa                   	stos   %al,%es:(%edi)
 568:	02 00                	add    (%eax),%al
 56a:	00 07                	add    %al,(%edi)
 56c:	6e                   	outsb  %ds:(%esi),(%dx)
 56d:	00 3d 09 56 00 00    	add    %bh,0x5609
 573:	00 e8                	add    %ch,%al
 575:	02 00                	add    (%eax),%al
 577:	00 e4                	add    %ah,%ah
 579:	02 00                	add    (%eax),%al
 57b:	00 00                	add    %al,(%eax)
 57d:	0e                   	push   %cs
 57e:	9e                   	sahf
 57f:	00 00                	add    %al,(%eax)
 581:	00 02                	add    %al,(%edx)
 583:	87 00                	xchg   %eax,(%eax)
 585:	00 00                	add    %al,(%eax)
 587:	32 f4                	xor    %ah,%dh
 589:	8c 00                	mov    %es,(%eax)
 58b:	00 2f                	add    %ch,(%edi)
 58d:	00 00                	add    %al,(%eax)
 58f:	00 01                	add    %al,(%ecx)
 591:	9c                   	pushf
 592:	95                   	xchg   %eax,%ebp
 593:	05 00 00 06 69       	add    $0x69060000,%eax
 598:	00 32                	add    %dh,(%edx)
 59a:	13 4c 00 00          	adc    0x0(%eax,%eax,1),%ecx
 59e:	00 fa                	add    %bh,%dl
 5a0:	02 00                	add    (%eax),%al
 5a2:	00 f8                	add    %bh,%al
 5a4:	02 00                	add    (%eax),%al
 5a6:	00 04 14             	add    %al,(%esp,%edx,1)
 5a9:	8d 00                	lea    (%eax),%eax
 5ab:	00 8d 03 00 00 17    	add    %cl,0x17000003(%ebp)
 5b1:	23 8d 00 00 e0 05    	and    0x5e00000(%ebp),%ecx
 5b7:	00 00                	add    %al,(%eax)
 5b9:	00 02                	add    %al,(%edx)
 5bb:	81 00 00 00 28 e9    	addl   $0xe9280000,(%eax)
 5c1:	8b 00                	mov    (%eax),%eax
 5c3:	00 1a                	add    %bl,(%edx)
 5c5:	00 00                	add    %al,(%eax)
 5c7:	00 01                	add    %al,(%ecx)
 5c9:	9c                   	pushf
 5ca:	bf 05 00 00 03       	mov    $0x3000005,%edi
 5cf:	6d                   	insl   (%dx),%es:(%edi)
 5d0:	00 28                	add    %ch,(%eax)
 5d2:	12 c5                	adc    %ch,%al
 5d4:	00 00                	add    %al,(%eax)
 5d6:	00 02                	add    %al,(%edx)
 5d8:	91                   	xchg   %eax,%ecx
 5d9:	00 04 fd 8b 00 00 13 	add    %al,0x1300008b(,%edi,8)
 5e0:	06                   	push   %es
 5e1:	00 00                	add    %al,(%eax)
 5e3:	00 02                	add    %al,(%edx)
 5e5:	75 00                	jne    5e7 <PR_BOOTABLE+0x567>
 5e7:	00 00                	add    %al,(%eax)
 5e9:	23 d1                	and    %ecx,%edx
 5eb:	8b 00                	mov    (%eax),%eax
 5ed:	00 18                	add    %bl,(%eax)
 5ef:	00 00                	add    %al,(%eax)
 5f1:	00 01                	add    %al,(%ecx)
 5f3:	9c                   	pushf
 5f4:	e0 05                	loopne 5fb <PR_BOOTABLE+0x57b>
 5f6:	00 00                	add    %al,(%eax)
 5f8:	03 72 00             	add    0x0(%edx),%esi
 5fb:	23 0f                	and    (%edi),%ecx
 5fd:	56                   	push   %esi
 5fe:	00 00                	add    %al,(%eax)
 600:	00 02                	add    %al,(%edx)
 602:	91                   	xchg   %eax,%ecx
 603:	00 00                	add    %al,(%eax)
 605:	02 5d 00             	add    0x0(%ebp),%bl
 608:	00 00                	add    %al,(%eax)
 60a:	1d 86 8b 00 00       	sbb    $0x8b86,%eax
 60f:	4b                   	dec    %ebx
 610:	00 00                	add    %al,(%eax)
 612:	00 01                	add    %al,(%ecx)
 614:	9c                   	pushf
 615:	13 06                	adc    (%esi),%eax
 617:	00 00                	add    %al,(%eax)
 619:	03 73 00             	add    0x0(%ebx),%esi
 61c:	1d 14 c5 00 00       	sbb    $0xc514,%eax
 621:	00 02                	add    %al,(%edx)
 623:	91                   	xchg   %eax,%ecx
 624:	00 04 bc             	add    %al,(%esp,%edi,4)
 627:	8b 00                	mov    (%eax),%eax
 629:	00 13                	add    %dl,(%ebx)
 62b:	06                   	push   %es
 62c:	00 00                	add    %al,(%eax)
 62e:	04 c9                	add    $0xc9,%al
 630:	8b 00                	mov    (%eax),%eax
 632:	00 13                	add    %dl,(%ebx)
 634:	06                   	push   %es
 635:	00 00                	add    %al,(%eax)
 637:	00 18                	add    %bl,(%eax)
 639:	7e 01                	jle    63c <PR_BOOTABLE+0x5bc>
 63b:	00 00                	add    %al,(%eax)
 63d:	0f 56 00             	orps   (%eax),%xmm0
 640:	00 00                	add    %al,(%eax)
 642:	4c                   	dec    %esp
 643:	8b 00                	mov    (%eax),%eax
 645:	00 3a                	add    %bh,(%edx)
 647:	00 00                	add    %al,(%eax)
 649:	00 01                	add    %al,(%ecx)
 64b:	9c                   	pushf
 64c:	89 06                	mov    %eax,(%esi)
 64e:	00 00                	add    %al,(%eax)
 650:	03 72 00             	add    0x0(%edx),%esi
 653:	0f 0e                	femms
 655:	56                   	push   %esi
 656:	00 00                	add    %al,(%eax)
 658:	00 02                	add    %al,(%edx)
 65a:	91                   	xchg   %eax,%ecx
 65b:	00 06                	add    %al,(%esi)
 65d:	63 00                	arpl   %eax,(%eax)
 65f:	0f 15 56 00          	unpckhps 0x0(%esi),%xmm2
 663:	00 00                	add    %al,(%eax)
 665:	07                   	pop    %es
 666:	03 00                	add    (%eax),%eax
 668:	00 03                	add    %al,(%ebx)
 66a:	03 00                	add    (%eax),%eax
 66c:	00 09                	add    %cl,(%ecx)
 66e:	6f                   	outsl  %ds:(%esi),(%dx)
 66f:	00 00                	add    %al,(%eax)
 671:	00 0f                	add    %cl,(%edi)
 673:	1c 56                	sbb    $0x56,%al
 675:	00 00                	add    %al,(%eax)
 677:	00 18                	add    %bl,(%eax)
 679:	03 00                	add    (%eax),%eax
 67b:	00 14 03             	add    %dl,(%ebx,%eax,1)
 67e:	00 00                	add    %al,(%eax)
 680:	09 7a 00             	or     %edi,0x0(%edx)
 683:	00 00                	add    %al,(%eax)
 685:	0f 2f 58 05          	comiss 0x5(%eax),%xmm3
 689:	00 00                	add    %al,(%eax)
 68b:	33 03                	xor    (%ebx),%eax
 68d:	00 00                	add    %al,(%eax)
 68f:	25 03 00 00 07       	and    $0x7000003,%eax
 694:	6c                   	insb   (%dx),%es:(%edi)
 695:	00 11                	add    %dl,(%ecx)
 697:	09 56 00             	or     %edx,0x0(%esi)
 69a:	00 00                	add    %al,(%eax)
 69c:	a8 03                	test   $0x3,%al
 69e:	00 00                	add    %al,(%eax)
 6a0:	a0 03 00 00 04       	mov    0x4000003,%al
 6a5:	78 8b                	js     632 <PR_BOOTABLE+0x5b2>
 6a7:	00 00                	add    %al,(%eax)
 6a9:	89 06                	mov    %eax,(%esi)
 6ab:	00 00                	add    %al,(%eax)
 6ad:	00 02                	add    %al,(%edx)
 6af:	54                   	push   %esp
 6b0:	01 00                	add    %eax,(%eax)
 6b2:	00 08                	add    %cl,(%eax)
 6b4:	26 8b 00             	mov    %es:(%eax),%eax
 6b7:	00 26                	add    %ah,(%esi)
 6b9:	00 00                	add    %al,(%eax)
 6bb:	00 01                	add    %al,(%ecx)
 6bd:	9c                   	pushf
 6be:	d6                   	(bad)
 6bf:	06                   	push   %es
 6c0:	00 00                	add    %al,(%eax)
 6c2:	03 6c 00 08          	add    0x8(%eax,%eax,1),%ebp
 6c6:	0f 56 00             	orps   (%eax),%xmm0
 6c9:	00 00                	add    %al,(%eax)
 6cb:	02 91 00 0a 6f 00    	add    0x6f0a00(%ecx),%dl
 6d1:	00 00                	add    %al,(%eax)
 6d3:	08 16                	or     %dl,(%esi)
 6d5:	56                   	push   %esi
 6d6:	00 00                	add    %al,(%eax)
 6d8:	00 02                	add    %al,(%edx)
 6da:	91                   	xchg   %eax,%ecx
 6db:	04 03                	add    $0x3,%al
 6dd:	63 68 00             	arpl   %ebp,0x0(%eax)
 6e0:	08 22                	or     %ah,(%edx)
 6e2:	92                   	xchg   %eax,%edx
 6e3:	00 00                	add    %al,(%eax)
 6e5:	00 02                	add    %al,(%edx)
 6e7:	91                   	xchg   %eax,%ecx
 6e8:	08 07                	or     %al,(%edi)
 6ea:	70 00                	jo     6ec <PR_BOOTABLE+0x66c>
 6ec:	0a 14 8d 00 00 00 bf 	or     -0x41000000(,%ecx,4),%dl
 6f3:	03 00                	add    (%eax),%eax
 6f5:	00 bd 03 00 00 00    	add    %bh,0x3(%ebp)
 6fb:	21 a4 00 00 00 02 29 	and    %esp,0x29020000(%eax,%eax,1)
 702:	14 03                	adc    $0x3,%al
 704:	06                   	push   %es
 705:	07                   	pop    %es
 706:	00 00                	add    %al,(%eax)
 708:	08 a2 01 00 00 29    	or     %ah,0x29000001(%edx)
 70e:	1d 56 00 00 00       	sbb    $0x56,%eax
 713:	08 e8                	or     %ch,%al
 715:	03 00                	add    (%eax),%eax
 717:	00 29                	add    %ch,(%ecx)
 719:	29 82 03 00 00 22    	sub    %eax,0x22000003(%edx)
 71f:	63 6e 74             	arpl   %ebp,0x74(%esi)
 722:	00 02                	add    %al,(%edx)
 724:	29 33                	sub    %esi,(%ebx)
 726:	56                   	push   %esi
 727:	00 00                	add    %al,(%eax)
 729:	00 00                	add    %al,(%eax)
 72b:	23 69 6e             	and    0x6e(%ecx),%ebp
 72e:	62 00                	bound  %eax,(%eax)
 730:	02 22                	add    (%edx),%ah
 732:	17                   	pop    %ss
 733:	2d 00 00 00 03       	sub    $0x3000000,%eax
 738:	2f                   	das
 739:	07                   	pop    %es
 73a:	00 00                	add    %al,(%eax)
 73c:	08 a2 01 00 00 22    	or     %ah,0x22000001(%edx)
 742:	1f                   	pop    %ds
 743:	56                   	push   %esi
 744:	00 00                	add    %al,(%eax)
 746:	00 24 9d 01 00 00 02 	add    %ah,0x2000001(,%ebx,4)
 74d:	24 0d                	and    $0xd,%al
 74f:	2d 00 00 00 00       	sub    $0x0,%eax
 754:	25 9f 00 00 00       	and    $0x9f,%eax
 759:	02 18                	add    (%eax),%bl
 75b:	14 03                	adc    $0x3,%al
 75d:	08 a2 01 00 00 18    	or     %ah,0x18000001(%edx)
 763:	1d 56 00 00 00       	sbb    $0x56,%eax
 768:	08 9d 01 00 00 18    	or     %bl,0x18000001(%ebp)
 76e:	2b 2d 00 00 00 00    	sub    0x0,%ebp
 774:	00 44 07 00          	add    %al,0x0(%edi,%eax,1)
 778:	00 05 00 01 04 75    	add    %al,0x75040100
 77e:	02 00                	add    (%eax),%al
 780:	00 12                	add    %dl,(%edx)
 782:	b7 00                	mov    $0x0,%bh
 784:	00 00                	add    %al,(%eax)
 786:	1d 60 00 00 00       	sbb    $0x60,%eax
 78b:	00 00                	add    %al,(%eax)
 78d:	00 00                	add    %al,(%eax)
 78f:	e1 8d                	loope  71e <PR_BOOTABLE+0x69e>
 791:	00 00                	add    %al,(%eax)
 793:	c0 01 00             	rolb   $0x0,(%ecx)
 796:	00 7a 04             	add    %bh,0x4(%edx)
 799:	00 00                	add    %al,(%eax)
 79b:	05 01 06 43 01       	add    $0x1430601,%eax
 7a0:	00 00                	add    %al,(%eax)
 7a2:	03 97 00 00 00 0d    	add    0xd000000(%edi),%edx
 7a8:	1c 38                	sbb    $0x38,%al
 7aa:	00 00                	add    %al,(%eax)
 7ac:	00 05 01 08 41 01    	add    %al,0x1410801
 7b2:	00 00                	add    %al,(%eax)
 7b4:	05 02 05 65 00       	add    $0x650502,%eax
 7b9:	00 00                	add    %al,(%eax)
 7bb:	03 5a 03             	add    0x3(%edx),%ebx
 7be:	00 00                	add    %al,(%eax)
 7c0:	0f 1c 51 00          	nopl   0x0(%ecx)
 7c4:	00 00                	add    %al,(%eax)
 7c6:	05 02 07 83 01       	add    $0x1830702,%eax
 7cb:	00 00                	add    %al,(%eax)
 7cd:	03 71 01             	add    0x1(%ecx),%esi
 7d0:	00 00                	add    %al,(%eax)
 7d2:	10 1c 63             	adc    %bl,(%ebx,%eiz,2)
 7d5:	00 00                	add    %al,(%eax)
 7d7:	00 13                	add    %dl,(%ebx)
 7d9:	04 05                	add    $0x5,%al
 7db:	69 6e 74 00 03 70 01 	imul   $0x1700300,0x74(%esi),%ebp
 7e2:	00 00                	add    %al,(%eax)
 7e4:	11 1c 75 00 00 00 05 	adc    %ebx,0x5000000(,%esi,2)
 7eb:	04 07                	add    $0x7,%al
 7ed:	63 01                	arpl   %eax,(%ecx)
 7ef:	00 00                	add    %al,(%eax)
 7f1:	05 08 05 a9 00       	add    $0xa90508,%eax
 7f6:	00 00                	add    %al,(%eax)
 7f8:	03 14 02             	add    (%edx,%eax,1),%edx
 7fb:	00 00                	add    %al,(%eax)
 7fd:	13 1c 8e             	adc    (%esi,%ecx,4),%ebx
 800:	00 00                	add    %al,(%eax)
 802:	00 05 08 07 59 01    	add    %al,0x1590708
 808:	00 00                	add    %al,(%eax)
 80a:	0a 10                	or     (%eax),%dl
 80c:	5e                   	pop    %esi
 80d:	05 e5 00 00 00       	add    $0xe5,%eax
 812:	01 4c 03 00          	add    %ecx,0x0(%ebx,%eax,1)
 816:	00 5f 11             	add    %bl,0x11(%edi)
 819:	2d 00 00 00 00       	sub    $0x0,%eax
 81e:	01 2e                	add    %ebp,(%esi)
 820:	03 00                	add    (%eax),%eax
 822:	00 62 11             	add    %ah,0x11(%edx)
 825:	e5 00                	in     $0x0,%eax
 827:	00 00                	add    %al,(%eax)
 829:	01 0f                	add    %ecx,(%edi)
 82b:	69 64 00 63 11 2d 00 	imul   $0x2d11,0x63(%eax,%eax,1),%esp
 832:	00 
 833:	00 04 01             	add    %al,(%ecx,%eax,1)
 836:	da 03                	fiaddl (%ebx)
 838:	00 00                	add    %al,(%eax)
 83a:	67 11 e5             	addr16 adc %esp,%ebp
 83d:	00 00                	add    %al,(%eax)
 83f:	00 05 01 1e 04 00    	add    %al,0x41e01
 845:	00 68 12             	add    %ch,0x12(%eax)
 848:	6a 00                	push   $0x0
 84a:	00 00                	add    %al,(%eax)
 84c:	08 01                	or     %al,(%ecx)
 84e:	c3                   	ret
 84f:	04 00                	add    $0x0,%al
 851:	00 69 12             	add    %ch,0x12(%ecx)
 854:	6a 00                	push   $0x0
 856:	00 00                	add    %al,(%eax)
 858:	0c 00                	or     $0x0,%al
 85a:	06                   	push   %es
 85b:	2d 00 00 00 f5       	sub    $0xf5000000,%eax
 860:	00 00                	add    %al,(%eax)
 862:	00 08                	add    %cl,(%eax)
 864:	75 00                	jne    866 <PR_BOOTABLE+0x7e6>
 866:	00 00                	add    %al,(%eax)
 868:	02 00                	add    (%eax),%al
 86a:	14 6d                	adc    $0x6d,%al
 86c:	62 72 00             	bound  %esi,0x0(%edx)
 86f:	00 02                	add    %al,(%edx)
 871:	02 5b 10             	add    0x10(%ebx),%bl
 874:	37                   	aaa
 875:	01 00                	add    %eax,(%eax)
 877:	00 01                	add    %al,(%ecx)
 879:	3a 02                	cmp    (%edx),%al
 87b:	00 00                	add    %al,(%eax)
 87d:	5c                   	pop    %esp
 87e:	0d 37 01 00 00       	or     $0x137,%eax
 883:	00 0d ce 01 00 00    	add    %cl,0x1ce
 889:	5d                   	pop    %ebp
 88a:	0d 48 01 00 00       	or     $0x148,%eax
 88f:	b4 01                	mov    $0x1,%ah
 891:	0d d7 02 00 00       	or     $0x2d7,%eax
 896:	6a 12                	push   $0x12
 898:	58                   	pop    %eax
 899:	01 00                	add    %eax,(%eax)
 89b:	00 be 01 0d 47 04    	add    %bh,0x4470d01(%esi)
 8a1:	00 00                	add    %al,(%eax)
 8a3:	6b 0d 68 01 00 00 fe 	imul   $0xfffffffe,0x168,%ecx
 8aa:	01 00                	add    %eax,(%eax)
 8ac:	06                   	push   %es
 8ad:	2d 00 00 00 48       	sub    $0x48000000,%eax
 8b2:	01 00                	add    %eax,(%eax)
 8b4:	00 15 75 00 00 00    	add    %dl,0x75
 8ba:	b3 01                	mov    $0x1,%bl
 8bc:	00 06                	add    %al,(%esi)
 8be:	2d 00 00 00 58       	sub    $0x58000000,%eax
 8c3:	01 00                	add    %eax,(%eax)
 8c5:	00 08                	add    %cl,(%eax)
 8c7:	75 00                	jne    8c9 <PR_BOOTABLE+0x849>
 8c9:	00 00                	add    %al,(%eax)
 8cb:	09 00                	or     %eax,(%eax)
 8cd:	06                   	push   %es
 8ce:	95                   	xchg   %eax,%ebp
 8cf:	00 00                	add    %al,(%eax)
 8d1:	00 68 01             	add    %ch,0x1(%eax)
 8d4:	00 00                	add    %al,(%eax)
 8d6:	08 75 00             	or     %dh,0x0(%ebp)
 8d9:	00 00                	add    %al,(%eax)
 8db:	03 00                	add    (%eax),%eax
 8dd:	06                   	push   %es
 8de:	2d 00 00 00 78       	sub    $0x78000000,%eax
 8e3:	01 00                	add    %eax,(%eax)
 8e5:	00 08                	add    %cl,(%eax)
 8e7:	75 00                	jne    8e9 <PR_BOOTABLE+0x869>
 8e9:	00 00                	add    %al,(%eax)
 8eb:	01 00                	add    %eax,(%eax)
 8ed:	03 b5 02 00 00 6c    	add    0x6c000002(%ebp),%esi
 8f3:	0e                   	push   %cs
 8f4:	f5                   	cmc
 8f5:	00 00                	add    %al,(%eax)
 8f7:	00 0b                	add    %cl,(%ebx)
 8f9:	38 03                	cmp    %al,(%ebx)
 8fb:	00 00                	add    %al,(%eax)
 8fd:	18 76 bf             	sbb    %dh,-0x41(%esi)
 900:	01 00                	add    %eax,(%eax)
 902:	00 01                	add    %al,(%ecx)
 904:	19 04 00             	sbb    %eax,(%eax,%eax,1)
 907:	00 77 0e             	add    %dh,0xe(%edi)
 90a:	6a 00                	push   $0x0
 90c:	00 00                	add    %al,(%eax)
 90e:	00 01                	add    %al,(%ecx)
 910:	e3 03                	jecxz  915 <PR_BOOTABLE+0x895>
 912:	00 00                	add    %al,(%eax)
 914:	78 0e                	js     924 <PR_BOOTABLE+0x8a4>
 916:	83 00 00             	addl   $0x0,(%eax)
 919:	00 04 01             	add    %al,(%ecx,%eax,1)
 91c:	68 03 00 00 79       	push   $0x79000003
 921:	0e                   	push   %cs
 922:	83 00 00             	addl   $0x0,(%eax)
 925:	00 0c 01             	add    %cl,(%ecx,%eax,1)
 928:	bd 02 00 00 7a       	mov    $0x7a000002,%ebp
 92d:	0e                   	push   %cs
 92e:	6a 00                	push   $0x0
 930:	00 00                	add    %al,(%eax)
 932:	14 00                	adc    $0x0,%al
 934:	03 e1                	add    %ecx,%esp
 936:	02 00                	add    (%eax),%al
 938:	00 7b 0e             	add    %bh,0xe(%ebx)
 93b:	83 01 00             	addl   $0x0,(%ecx)
 93e:	00 0b                	add    %cl,(%ebx)
 940:	d7                   	xlat   %ds:(%ebx)
 941:	01 00                	add    %eax,(%eax)
 943:	00 34 83             	add    %dh,(%ebx,%eax,4)
 946:	8a 02                	mov    (%edx),%al
 948:	00 00                	add    %al,(%eax)
 94a:	01 d2                	add    %edx,%edx
 94c:	03 00                	add    (%eax),%eax
 94e:	00 84 0e 6a 00 00 00 	add    %al,0x6a(%esi,%ecx,1)
 955:	00 01                	add    %al,(%ecx)
 957:	a3 03 00 00 85       	mov    %eax,0x85000003
 95c:	0d 8a 02 00 00       	or     $0x28a,%eax
 961:	04 01                	add    $0x1,%al
 963:	bb 02 00 00 86       	mov    $0x86000002,%ebx
 968:	0e                   	push   %cs
 969:	46                   	inc    %esi
 96a:	00 00                	add    %al,(%eax)
 96c:	00 10                	add    %dl,(%eax)
 96e:	01 55 02             	add    %edx,0x2(%ebp)
 971:	00 00                	add    %al,(%eax)
 973:	87 0e                	xchg   %ecx,(%esi)
 975:	46                   	inc    %esi
 976:	00 00                	add    %al,(%eax)
 978:	00 12                	add    %dl,(%edx)
 97a:	01 11                	add    %edx,(%ecx)
 97c:	03 00                	add    (%eax),%eax
 97e:	00 88 0e 6a 00 00    	add    %cl,0x6a0e(%eax)
 984:	00 14 01             	add    %dl,(%ecx,%eax,1)
 987:	0c 02                	or     $0x2,%al
 989:	00 00                	add    %al,(%eax)
 98b:	89 0e                	mov    %ecx,(%esi)
 98d:	6a 00                	push   $0x0
 98f:	00 00                	add    %al,(%eax)
 991:	18 01                	sbb    %al,(%ecx)
 993:	bd 03 00 00 8a       	mov    $0x8a000003,%ebp
 998:	0e                   	push   %cs
 999:	6a 00                	push   $0x0
 99b:	00 00                	add    %al,(%eax)
 99d:	1c 01                	sbb    $0x1,%al
 99f:	f6 03 00             	testb  $0x0,(%ebx)
 9a2:	00 8b 0e 6a 00 00    	add    %cl,0x6a0e(%ebx)
 9a8:	00 20                	add    %ah,(%eax)
 9aa:	01 45 02             	add    %eax,0x2(%ebp)
 9ad:	00 00                	add    %al,(%eax)
 9af:	8c 0e                	mov    %cs,(%esi)
 9b1:	6a 00                	push   $0x0
 9b3:	00 00                	add    %al,(%eax)
 9b5:	24 01                	and    $0x1,%al
 9b7:	ce                   	into
 9b8:	02 00                	add    (%eax),%al
 9ba:	00 8d 0e 46 00 00    	add    %cl,0x460e(%ebp)
 9c0:	00 28                	add    %ch,(%eax)
 9c2:	01 5f 02             	add    %ebx,0x2(%edi)
 9c5:	00 00                	add    %al,(%eax)
 9c7:	8e 0e                	mov    (%esi),%cs
 9c9:	46                   	inc    %esi
 9ca:	00 00                	add    %al,(%eax)
 9cc:	00 2a                	add    %ch,(%edx)
 9ce:	01 3f                	add    %edi,(%edi)
 9d0:	04 00                	add    $0x0,%al
 9d2:	00 8f 0e 46 00 00    	add    %cl,0x460e(%edi)
 9d8:	00 2c 01             	add    %ch,(%ecx,%eax,1)
 9db:	a3 02 00 00 90       	mov    %eax,0x90000002
 9e0:	0e                   	push   %cs
 9e1:	46                   	inc    %esi
 9e2:	00 00                	add    %al,(%eax)
 9e4:	00 2e                	add    %ch,(%esi)
 9e6:	01 63 04             	add    %esp,0x4(%ebx)
 9e9:	00 00                	add    %al,(%eax)
 9eb:	91                   	xchg   %eax,%ecx
 9ec:	0e                   	push   %cs
 9ed:	46                   	inc    %esi
 9ee:	00 00                	add    %al,(%eax)
 9f0:	00 30                	add    %dh,(%eax)
 9f2:	01 de                	add    %ebx,%esi
 9f4:	01 00                	add    %eax,(%eax)
 9f6:	00 92 0e 46 00 00    	add    %dl,0x460e(%edx)
 9fc:	00 32                	add    %dh,(%edx)
 9fe:	00 06                	add    %al,(%esi)
 a00:	2d 00 00 00 9a       	sub    $0x9a000000,%eax
 a05:	02 00                	add    (%eax),%al
 a07:	00 08                	add    %cl,(%eax)
 a09:	75 00                	jne    a0b <PR_BOOTABLE+0x98b>
 a0b:	00 00                	add    %al,(%eax)
 a0d:	0b 00                	or     (%eax),%eax
 a0f:	03 f3                	add    %ebx,%esi
 a11:	01 00                	add    %eax,(%eax)
 a13:	00 93 03 ca 01 00    	add    %dl,0x1ca03(%ebx)
 a19:	00 0b                	add    %cl,(%ebx)
 a1b:	9b                   	fwait
 a1c:	02 00                	add    (%eax),%al
 a1e:	00 20                	add    %ah,(%eax)
 a20:	96                   	xchg   %eax,%esi
 a21:	11 03                	adc    %eax,(%ebx)
 a23:	00 00                	add    %al,(%eax)
 a25:	01 94 02 00 00 97 0e 	add    %edx,0xe970000(%edx,%eax,1)
 a2c:	6a 00                	push   $0x0
 a2e:	00 00                	add    %al,(%eax)
 a30:	00 01                	add    %al,(%ecx)
 a32:	31 02                	xor    %eax,(%edx)
 a34:	00 00                	add    %al,(%eax)
 a36:	98                   	cwtl
 a37:	0e                   	push   %cs
 a38:	6a 00                	push   $0x0
 a3a:	00 00                	add    %al,(%eax)
 a3c:	04 01                	add    $0x1,%al
 a3e:	7a 03                	jp     a43 <PR_BOOTABLE+0x9c3>
 a40:	00 00                	add    %al,(%eax)
 a42:	99                   	cltd
 a43:	0e                   	push   %cs
 a44:	6a 00                	push   $0x0
 a46:	00 00                	add    %al,(%eax)
 a48:	08 01                	or     %al,(%ecx)
 a4a:	be 04 00 00 9a       	mov    $0x9a000004,%esi
 a4f:	0e                   	push   %cs
 a50:	6a 00                	push   $0x0
 a52:	00 00                	add    %al,(%eax)
 a54:	0c 01                	or     $0x1,%al
 a56:	36 04 00             	ss add $0x0,%al
 a59:	00 9b 0e 6a 00 00    	add    %bl,0x6a0e(%ebx)
 a5f:	00 10                	add    %dl,(%eax)
 a61:	01 29                	add    %ebp,(%ecx)
 a63:	02 00                	add    (%eax),%al
 a65:	00 9c 0e 6a 00 00 00 	add    %bl,0x6a(%esi,%ecx,1)
 a6c:	14 01                	adc    $0x1,%al
 a6e:	90                   	nop
 a6f:	03 00                	add    (%eax),%eax
 a71:	00 9d 0e 6a 00 00    	add    %bl,0x6a0e(%ebp)
 a77:	00 18                	add    %bl,(%eax)
 a79:	01 ac 04 00 00 9e 0e 	add    %ebp,0xe9e0000(%esp,%eax,1)
 a80:	6a 00                	push   $0x0
 a82:	00 00                	add    %al,(%eax)
 a84:	1c 00                	sbb    $0x0,%al
 a86:	03 9b 02 00 00 9f    	add    -0x60fffffe(%ebx),%ebx
 a8c:	03 a5 02 00 00 0a    	add    0xa000002(%ebp),%esp
 a92:	04 ad                	add    $0xad,%al
 a94:	05 55 03 00 00       	add    $0x355,%eax
 a99:	01 27                	add    %esp,(%edi)
 a9b:	03 00                	add    (%eax),%eax
 a9d:	00 ae 11 2d 00 00    	add    %ch,0x2d11(%esi)
 aa3:	00 00                	add    %al,(%eax)
 aa5:	01 1b                	add    %ebx,(%ebx)
 aa7:	03 00                	add    (%eax),%eax
 aa9:	00 af 11 2d 00 00    	add    %ch,0x2d11(%edi)
 aaf:	00 01                	add    %al,(%ecx)
 ab1:	01 21                	add    %esp,(%ecx)
 ab3:	03 00                	add    (%eax),%eax
 ab5:	00 b0 11 2d 00 00    	add    %dh,0x2d11(%eax)
 abb:	00 02                	add    %al,(%edx)
 abd:	01 8e 02 00 00 b1    	add    %ecx,-0x4efffffe(%esi)
 ac3:	11 2d 00 00 00 03    	adc    %ebp,0x3000000
 ac9:	00 0a                	add    %cl,(%edx)
 acb:	10 be 09 8e 03 00    	adc    %bh,0x38e09(%esi)
 ad1:	00 01                	add    %al,(%ecx)
 ad3:	16                   	push   %ss
 ad4:	04 00                	add    $0x0,%al
 ad6:	00 bf 16 6a 00 00    	add    %bh,0x6a16(%edi)
 adc:	00 00                	add    %al,(%eax)
 ade:	01 86 02 00 00 c0    	add    %eax,-0x3ffffffe(%esi)
 ae4:	16                   	push   %ss
 ae5:	6a 00                	push   $0x0
 ae7:	00 00                	add    %al,(%eax)
 ae9:	04 01                	add    $0x1,%al
 aeb:	e8 03 00 00 c1       	call   c1000af3 <SMAP_SIG+0x6db2c9a3>
 af0:	16                   	push   %ss
 af1:	6a 00                	push   $0x0
 af3:	00 00                	add    %al,(%eax)
 af5:	08 01                	or     %al,(%ecx)
 af7:	76 04                	jbe    afd <PR_BOOTABLE+0xa7d>
 af9:	00 00                	add    %al,(%eax)
 afb:	c2 16 6a             	ret    $0x6a16
 afe:	00 00                	add    %al,(%eax)
 b00:	00 0c 00             	add    %cl,(%eax,%eax,1)
 b03:	0a 10                	or     (%eax),%dl
 b05:	c4 09                	les    (%ecx),%ecx
 b07:	c7 03 00 00 0f 6e    	movl   $0x6e0f0000,(%ebx)
 b0d:	75 6d                	jne    b7c <PR_BOOTABLE+0xafc>
 b0f:	00 c5                	add    %al,%ch
 b11:	16                   	push   %ss
 b12:	6a 00                	push   $0x0
 b14:	00 00                	add    %al,(%eax)
 b16:	00 01                	add    %al,(%ecx)
 b18:	19 04 00             	sbb    %eax,(%eax,%eax,1)
 b1b:	00 c6                	add    %al,%dh
 b1d:	16                   	push   %ss
 b1e:	6a 00                	push   $0x0
 b20:	00 00                	add    %al,(%eax)
 b22:	04 01                	add    $0x1,%al
 b24:	e8 03 00 00 c7       	call   c7000b2c <SMAP_SIG+0x73b2c9dc>
 b29:	16                   	push   %ss
 b2a:	6a 00                	push   $0x0
 b2c:	00 00                	add    %al,(%eax)
 b2e:	08 01                	or     %al,(%ecx)
 b30:	af                   	scas   %es:(%edi),%eax
 b31:	02 00                	add    (%eax),%al
 b33:	00 c8                	add    %cl,%al
 b35:	16                   	push   %ss
 b36:	6a 00                	push   $0x0
 b38:	00 00                	add    %al,(%eax)
 b3a:	0c 00                	or     $0x0,%al
 b3c:	16                   	push   %ss
 b3d:	10 02                	adc    %al,(%edx)
 b3f:	bd 05 e9 03 00       	mov    $0x3e905,%ebp
 b44:	00 17                	add    %dl,(%edi)
 b46:	81 02 00 00 02 c3    	addl   $0xc3020000,(%edx)
 b4c:	0b 55 03             	or     0x3(%ebp),%edx
 b4f:	00 00                	add    %al,(%eax)
 b51:	18 65 6c             	sbb    %ah,0x6c(%ebp)
 b54:	66 00 02             	data16 add %al,(%edx)
 b57:	c9                   	leave
 b58:	0b 8e 03 00 00 00    	or     0x3(%esi),%ecx
 b5e:	0b 6f 03             	or     0x3(%edi),%ebp
 b61:	00 00                	add    %al,(%eax)
 b63:	60                   	pusha
 b64:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 b65:	f1                   	int1
 b66:	04 00                	add    $0x0,%al
 b68:	00 01                	add    %al,(%ecx)
 b6a:	47                   	inc    %edi
 b6b:	02 00                	add    (%eax),%al
 b6d:	00 a6 0e 6a 00 00    	add    %ah,0x6a0e(%esi)
 b73:	00 00                	add    %al,(%eax)
 b75:	01 42 03             	add    %eax,0x3(%edx)
 b78:	00 00                	add    %al,(%eax)
 b7a:	a9 0e 6a 00 00       	test   $0x6a0e,%eax
 b7f:	00 04 01             	add    %al,(%ecx,%eax,1)
 b82:	fe 03                	incb   (%ebx)
 b84:	00 00                	add    %al,(%eax)
 b86:	aa                   	stos   %al,%es:(%edi)
 b87:	0e                   	push   %cs
 b88:	6a 00                	push   $0x0
 b8a:	00 00                	add    %al,(%eax)
 b8c:	08 01                	or     %al,(%ecx)
 b8e:	a9 03 00 00 b2       	test   $0xb2000003,%eax
 b93:	07                   	pop    %es
 b94:	1c 03                	sbb    $0x3,%al
 b96:	00 00                	add    %al,(%eax)
 b98:	0c 01                	or     $0x1,%al
 b9a:	4d                   	dec    %ebp
 b9b:	02 00                	add    (%eax),%al
 b9d:	00 b5 0e 6a 00 00    	add    %dh,0x6a0e(%ebp)
 ba3:	00 10                	add    %dl,(%eax)
 ba5:	01 6b 04             	add    %ebp,0x4(%ebx)
 ba8:	00 00                	add    %al,(%eax)
 baa:	b9 0e 6a 00 00       	mov    $0x6a0e,%ecx
 baf:	00 14 01             	add    %dl,(%ecx,%eax,1)
 bb2:	77 02                	ja     bb6 <PR_BOOTABLE+0xb36>
 bb4:	00 00                	add    %al,(%eax)
 bb6:	ba 0e 6a 00 00       	mov    $0x6a0e,%edx
 bbb:	00 18                	add    %bl,(%eax)
 bbd:	01 55 03             	add    %edx,0x3(%ebp)
 bc0:	00 00                	add    %al,(%eax)
 bc2:	ca 07 c7             	lret   $0xc707
 bc5:	03 00                	add    (%eax),%eax
 bc7:	00 1c 01             	add    %bl,(%ecx,%eax,1)
 bca:	63 03                	arpl   %eax,(%ebx)
 bcc:	00 00                	add    %al,(%eax)
 bce:	cd 0e                	int    $0xe
 bd0:	6a 00                	push   $0x0
 bd2:	00 00                	add    %al,(%eax)
 bd4:	2c 01                	sub    $0x1,%al
 bd6:	e9 01 00 00 cf       	jmp    cf000bdc <SMAP_SIG+0x7bb2ca8c>
 bdb:	0e                   	push   %cs
 bdc:	6a 00                	push   $0x0
 bde:	00 00                	add    %al,(%eax)
 be0:	30 01                	xor    %al,(%ecx)
 be2:	28 04 00             	sub    %al,(%eax,%eax,1)
 be5:	00 d3                	add    %dl,%bl
 be7:	0e                   	push   %cs
 be8:	6a 00                	push   $0x0
 bea:	00 00                	add    %al,(%eax)
 bec:	34 01                	xor    $0x1,%al
 bee:	c2 02 00             	ret    $0x2
 bf1:	00 d4                	add    %dl,%ah
 bf3:	0e                   	push   %cs
 bf4:	6a 00                	push   $0x0
 bf6:	00 00                	add    %al,(%eax)
 bf8:	38 01                	cmp    %al,(%ecx)
 bfa:	c5 03                	lds    (%ebx),%eax
 bfc:	00 00                	add    %al,(%eax)
 bfe:	d7                   	xlat   %ds:(%ebx)
 bff:	0e                   	push   %cs
 c00:	6a 00                	push   $0x0
 c02:	00 00                	add    %al,(%eax)
 c04:	3c 01                	cmp    $0x1,%al
 c06:	80 04 00 00          	addb   $0x0,(%eax,%eax,1)
 c0a:	da 0e                	fimull (%esi)
 c0c:	6a 00                	push   $0x0
 c0e:	00 00                	add    %al,(%eax)
 c10:	40                   	inc    %eax
 c11:	01 b4 04 00 00 dd 0e 	add    %esi,0xedd0000(%esp,%eax,1)
 c18:	6a 00                	push   $0x0
 c1a:	00 00                	add    %al,(%eax)
 c1c:	44                   	inc    %esp
 c1d:	01 7f 03             	add    %edi,0x3(%edi)
 c20:	00 00                	add    %al,(%eax)
 c22:	e0 0e                	loopne c32 <PR_BOOTABLE+0xbb2>
 c24:	6a 00                	push   $0x0
 c26:	00 00                	add    %al,(%eax)
 c28:	48                   	dec    %eax
 c29:	01 08                	add    %ecx,(%eax)
 c2b:	04 00                	add    $0x0,%al
 c2d:	00 e1                	add    %ah,%cl
 c2f:	0e                   	push   %cs
 c30:	6a 00                	push   $0x0
 c32:	00 00                	add    %al,(%eax)
 c34:	4c                   	dec    %esp
 c35:	01 ed                	add    %ebp,%ebp
 c37:	03 00                	add    (%eax),%eax
 c39:	00 e2                	add    %ah,%dl
 c3b:	0e                   	push   %cs
 c3c:	6a 00                	push   $0x0
 c3e:	00 00                	add    %al,(%eax)
 c40:	50                   	push   %eax
 c41:	01 91 04 00 00 e3    	add    %edx,-0x1cfffffc(%ecx)
 c47:	0e                   	push   %cs
 c48:	6a 00                	push   $0x0
 c4a:	00 00                	add    %al,(%eax)
 c4c:	54                   	push   %esp
 c4d:	01 fa                	add    %edi,%edx
 c4f:	01 00                	add    %eax,(%eax)
 c51:	00 e4                	add    %ah,%ah
 c53:	0e                   	push   %cs
 c54:	6a 00                	push   $0x0
 c56:	00 00                	add    %al,(%eax)
 c58:	58                   	pop    %eax
 c59:	01 51 04             	add    %edx,0x4(%ecx)
 c5c:	00 00                	add    %al,(%eax)
 c5e:	e5 0e                	in     $0xe,%eax
 c60:	6a 00                	push   $0x0
 c62:	00 00                	add    %al,(%eax)
 c64:	5c                   	pop    %esp
 c65:	00 03                	add    %al,(%ebx)
 c67:	ed                   	in     (%dx),%eax
 c68:	02 00                	add    (%eax),%al
 c6a:	00 e6                	add    %ah,%dh
 c6c:	03 e9                	add    %ecx,%ebp
 c6e:	03 00                	add    (%eax),%eax
 c70:	00 19                	add    %bl,(%ecx)
 c72:	6f                   	outsl  %ds:(%esi),(%dx)
 c73:	03 00                	add    (%eax),%eax
 c75:	00 01                	add    %al,(%ecx)
 c77:	08 0e                	or     %cl,(%esi)
 c79:	f1                   	int1
 c7a:	04 00                	add    $0x0,%al
 c7c:	00 05 03 a0 93 00    	add    %al,0x93a003
 c82:	00 07                	add    %al,(%edi)
 c84:	87 00                	xchg   %eax,(%eax)
 c86:	00 00                	add    %al,(%eax)
 c88:	02 4a 06             	add    0x6(%edx),%cl
 c8b:	20 05 00 00 04 58    	and    %al,0x58040000
 c91:	00 00                	add    %al,(%eax)
 c93:	00 00                	add    %al,(%eax)
 c95:	07                   	pop    %es
 c96:	30 01                	xor    %al,(%ecx)
 c98:	00 00                	add    %al,(%eax)
 c9a:	02 70 06             	add    0x6(%eax),%dh
 c9d:	41                   	inc    %ecx
 c9e:	05 00 00 04 6a       	add    $0x6a040000,%eax
 ca3:	00 00                	add    %al,(%eax)
 ca5:	00 04 6a             	add    %al,(%edx,%ebp,2)
 ca8:	00 00                	add    %al,(%eax)
 caa:	00 04 6a             	add    %al,(%edx,%ebp,2)
 cad:	00 00                	add    %al,(%eax)
 caf:	00 04 6a             	add    %al,(%edx,%ebp,2)
 cb2:	00 00                	add    %al,(%eax)
 cb4:	00 00                	add    %al,(%eax)
 cb6:	07                   	pop    %es
 cb7:	6b 02 00             	imul   $0x0,(%edx),%eax
 cba:	00 01                	add    %al,(%ecx)
 cbc:	06                   	push   %es
 cbd:	0d 58 05 00 00       	or     $0x558,%eax
 cc2:	04 6a                	add    $0x6a,%al
 cc4:	00 00                	add    %al,(%eax)
 cc6:	00 04 58             	add    %al,(%eax,%ebx,2)
 cc9:	05 00 00 00 09       	add    $0x9000000,%eax
 cce:	f1                   	int1
 ccf:	04 00                	add    $0x0,%al
 cd1:	00 07                	add    %al,(%edi)
 cd3:	81 00 00 00 02 4c    	addl   $0x4c020000,(%eax)
 cd9:	06                   	push   %es
 cda:	6f                   	outsl  %ds:(%esi),(%dx)
 cdb:	05 00 00 04 6f       	add    $0x6f040000,%eax
 ce0:	05 00 00 00 09       	add    $0x9000000,%eax
 ce5:	74 05                	je     cec <PR_BOOTABLE+0xc6c>
 ce7:	00 00                	add    %al,(%eax)
 ce9:	05 01 06 4a 01       	add    $0x14a0601,%eax
 cee:	00 00                	add    %al,(%eax)
 cf0:	07                   	pop    %es
 cf1:	5d                   	pop    %ebp
 cf2:	00 00                	add    %al,(%eax)
 cf4:	00 02                	add    %al,(%edx)
 cf6:	49                   	dec    %ecx
 cf7:	06                   	push   %es
 cf8:	8d 05 00 00 04 6f    	lea    0x6f040000,%eax
 cfe:	05 00 00 00 07       	add    $0x7000000,%eax
 d03:	75 00                	jne    d05 <PR_BOOTABLE+0xc85>
 d05:	00 00                	add    %al,(%eax)
 d07:	02 4b 06             	add    0x6(%ebx),%cl
 d0a:	9f                   	lahf
 d0b:	05 00 00 04 63       	add    $0x63040000,%eax
 d10:	00 00                	add    %al,(%eax)
 d12:	00 00                	add    %al,(%eax)
 d14:	10 98 03 00 00 41    	adc    %bl,0x41000003(%eax)
 d1a:	0f 58 05 00 00 70 8e 	addps  0x8e700000,%xmm0
 d21:	00 00                	add    %al,(%eax)
 d23:	77 00                	ja     d25 <PR_BOOTABLE+0xca5>
 d25:	00 00                	add    %al,(%eax)
 d27:	01 9c fc 05 00 00 11 	add    %ebx,0x11000005(%esp,%edi,8)
 d2e:	3d 03 00 00 41       	cmp    $0x41000003,%eax
 d33:	27                   	daa
 d34:	fc                   	cld
 d35:	05 00 00 02 91       	add    $0x91020000,%eax
 d3a:	00 0c 70             	add    %cl,(%eax,%esi,2)
 d3d:	00 43 12             	add    %al,0x12(%ebx)
 d40:	fc                   	cld
 d41:	05 00 00 dd 03       	add    $0x3dd0000,%eax
 d46:	00 00                	add    %al,(%eax)
 d48:	d1 03                	roll   $1,(%ebx)
 d4a:	00 00                	add    %al,(%eax)
 d4c:	0e                   	push   %cs
 d4d:	a3 04 00 00 44       	mov    %eax,0x44000004
 d52:	6a 00                	push   $0x0
 d54:	00 00                	add    %al,(%eax)
 d56:	36 04 00             	ss add $0x0,%al
 d59:	00 2c 04             	add    %ch,(%esp,%eax,1)
 d5c:	00 00                	add    %al,(%eax)
 d5e:	02 95 8e 00 00 7b    	add    0x7b00008e(%ebp),%dl
 d64:	05 00 00 02 af       	add    $0xaf020000,%eax
 d69:	8e 00                	mov    (%eax),%es
 d6b:	00 0e                	add    %cl,(%esi)
 d6d:	05 00 00 00 09       	add    $0x9000000,%eax
 d72:	bf 01 00 00 10       	mov    $0x10000001,%edi
 d77:	1d 02 00 00 2b       	sbb    $0x2b000002,%eax
 d7c:	0a 6a 00             	or     0x0(%edx),%ch
 d7f:	00 00                	add    %al,(%eax)
 d81:	e1 8d                	loope  d10 <PR_BOOTABLE+0xc90>
 d83:	00 00                	add    %al,(%eax)
 d85:	8f 00                	pop    (%eax)
 d87:	00 00                	add    %al,(%eax)
 d89:	01 9c 69 06 00 00 11 	add    %ebx,0x11000006(%ecx,%ebp,2)
 d90:	b5 03                	mov    $0x3,%ch
 d92:	00 00                	add    %al,(%eax)
 d94:	2b 1f                	sub    (%edi),%ebx
 d96:	6a 00                	push   $0x0
 d98:	00 00                	add    %al,(%eax)
 d9a:	02 91 00 0c 70 68    	add    0x68700c00(%ecx),%dl
 da0:	00 2e                	add    %ch,(%esi)
 da2:	0e                   	push   %cs
 da3:	69 06 00 00 67 04    	imul   $0x4670000,(%esi),%eax
 da9:	00 00                	add    %al,(%eax)
 dab:	61                   	popa
 dac:	04 00                	add    $0x0,%al
 dae:	00 0c 65 70 68 00 2e 	add    %cl,0x2e006870(,%eiz,2)
 db5:	13 69 06             	adc    0x6(%ecx),%ebp
 db8:	00 00                	add    %al,(%eax)
 dba:	7c 04                	jl     dc0 <PR_BOOTABLE+0xd40>
 dbc:	00 00                	add    %al,(%eax)
 dbe:	7a 04                	jp     dc4 <PR_BOOTABLE+0xd44>
 dc0:	00 00                	add    %al,(%eax)
 dc2:	02 09                	add    (%ecx),%cl
 dc4:	8e 00                	mov    (%eax),%es
 dc6:	00 20                	add    %ah,(%eax)
 dc8:	05 00 00 02 27       	add    $0x27020000,%eax
 dcd:	8e 00                	mov    (%eax),%es
 dcf:	00 5d 05             	add    %bl,0x5(%ebp)
 dd2:	00 00                	add    %al,(%eax)
 dd4:	02 59 8e             	add    -0x72(%ecx),%bl
 dd7:	00 00                	add    %al,(%eax)
 dd9:	20 05 00 00 00 09    	and    %al,0x9000000
 ddf:	11 03                	adc    %eax,(%ebx)
 de1:	00 00                	add    %al,(%eax)
 de3:	1a 07                	sbb    (%edi),%al
 de5:	03 00                	add    (%eax),%eax
 de7:	00 01                	add    %al,(%ecx)
 de9:	0a 06                	or     (%esi),%al
 deb:	e7 8e                	out    %eax,$0x8e
 ded:	00 00                	add    %al,(%eax)
 def:	ba 00 00 00 01       	mov    $0x1000000,%edx
 df4:	9c                   	pushf
 df5:	42                   	inc    %edx
 df6:	07                   	pop    %es
 df7:	00 00                	add    %al,(%eax)
 df9:	1b 64 65 76          	sbb    0x76(%ebp,%eiz,2),%esp
 dfd:	00 01                	add    %al,(%ecx)
 dff:	0a 19                	or     (%ecx),%bl
 e01:	6a 00                	push   $0x0
 e03:	00 00                	add    %al,(%eax)
 e05:	02 91 00 1c 6d 62    	add    0x626d1c00(%ecx),%dl
 e0b:	72 00                	jb     e0d <PR_BOOTABLE+0xd8d>
 e0d:	01 0a                	add    %ecx,(%edx)
 e0f:	25 42 07 00 00       	and    $0x742,%eax
 e14:	87 04 00             	xchg   %eax,(%eax,%eax,1)
 e17:	00 83 04 00 00 1d    	add    %al,0x1d000004(%ebx)
 e1d:	3d 03 00 00 01       	cmp    $0x1000003,%eax
 e22:	0a 37                	or     (%edi),%dh
 e24:	fc                   	cld
 e25:	05 00 00 9c 04       	add    $0x49c0000,%eax
 e2a:	00 00                	add    %al,(%eax)
 e2c:	98                   	cwtl
 e2d:	04 00                	add    $0x0,%al
 e2f:	00 0c 69             	add    %cl,(%ecx,%ebp,2)
 e32:	00 10                	add    %dl,(%eax)
 e34:	09 63 00             	or     %esp,0x0(%ebx)
 e37:	00 00                	add    %al,(%eax)
 e39:	b1 04                	mov    $0x4,%cl
 e3b:	00 00                	add    %al,(%eax)
 e3d:	ad                   	lods   %ds:(%esi),%eax
 e3e:	04 00                	add    $0x0,%al
 e40:	00 0e                	add    %cl,(%esi)
 e42:	fa                   	cli
 e43:	02 00                	add    (%eax),%al
 e45:	00 11                	add    %dl,(%ecx)
 e47:	6a 00                	push   $0x0
 e49:	00 00                	add    %al,(%eax)
 e4b:	c7 04 00 00 c1 04 00 	movl   $0x4c100,(%eax,%eax,1)
 e52:	00 0e                	add    %cl,(%esi)
 e54:	0e                   	push   %cs
 e55:	02 00                	add    (%eax),%al
 e57:	00 1f                	add    %bl,(%edi)
 e59:	6a 00                	push   $0x0
 e5b:	00 00                	add    %al,(%eax)
 e5d:	e3 04                	jecxz  e63 <PR_BOOTABLE+0xde3>
 e5f:	00 00                	add    %al,(%eax)
 e61:	df 04 00             	filds  (%eax,%eax,1)
 e64:	00 02                	add    %al,(%edx)
 e66:	04 8f                	add    $0x8f,%al
 e68:	00 00                	add    %al,(%eax)
 e6a:	8d 05 00 00 02 12    	lea    0x12020000,%eax
 e70:	8f 00                	pop    (%eax)
 e72:	00 7b 05             	add    %bh,0x5(%ebx)
 e75:	00 00                	add    %al,(%eax)
 e77:	02 46 8f             	add    -0x71(%esi),%al
 e7a:	00 00                	add    %al,(%eax)
 e7c:	5d                   	pop    %ebp
 e7d:	05 00 00 02 54       	add    $0x54020000,%eax
 e82:	8f 00                	pop    (%eax)
 e84:	00 9f 05 00 00 02    	add    %bl,0x2000005(%edi)
 e8a:	62 8f 00 00 7b 05    	bound  %ecx,0x57b0000(%edi)
 e90:	00 00                	add    %al,(%eax)
 e92:	02 6a 8f             	add    -0x71(%edx),%ch
 e95:	00 00                	add    %al,(%eax)
 e97:	01 06                	add    %eax,(%esi)
 e99:	00 00                	add    %al,(%eax)
 e9b:	02 7a 8f             	add    -0x71(%edx),%bh
 e9e:	00 00                	add    %al,(%eax)
 ea0:	7b 05                	jnp    ea7 <PR_BOOTABLE+0xe27>
 ea2:	00 00                	add    %al,(%eax)
 ea4:	02 89 8f 00 00 41    	add    0x4100008f(%ecx),%cl
 eaa:	05 00 00 02 97       	add    $0x97020000,%eax
 eaf:	8f 00                	pop    (%eax)
 eb1:	00 5d 05             	add    %bl,0x5(%ebp)
 eb4:	00 00                	add    %al,(%eax)
 eb6:	00 09                	add    %cl,(%ecx)
 eb8:	78 01                	js     ebb <PR_BOOTABLE+0xe3b>
 eba:	00 00                	add    %al,(%eax)
 ebc:	00 20                	add    %ah,(%eax)
 ebe:	00 00                	add    %al,(%eax)
 ec0:	00 05 00 01 04 52    	add    %al,0x52040100
 ec6:	04 00                	add    $0x0,%al
 ec8:	00 01                	add    %al,(%ecx)
 eca:	0c 06                	or     $0x6,%al
 ecc:	00 00                	add    %al,(%eax)
 ece:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 ecf:	8f 00                	pop    (%eax)
 ed1:	00 10                	add    %dl,(%eax)
 ed3:	d1 04 00             	roll   $1,(%eax,%eax,1)
 ed6:	00 13                	add    %dl,(%ebx)
 ed8:	00 00                	add    %al,(%eax)
 eda:	00 3f                	add    %bh,(%edi)
 edc:	00 00                	add    %al,(%eax)
 ede:	00 01                	add    %al,(%ecx)
 ee0:	80                   	.byte 0x80

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	00 10                	add    %dl,(%eax)
   4:	17                   	pop    %ss
   5:	11 01                	adc    %eax,(%ecx)
   7:	12 0f                	adc    (%edi),%cl
   9:	03 0e                	add    (%esi),%ecx
   b:	1b 0e                	sbb    (%esi),%ecx
   d:	25 0e 13 05 00       	and    $0x5130e,%eax
  12:	00 00                	add    %al,(%eax)
  14:	01 05 00 31 13 02    	add    %eax,0x2133100
  1a:	17                   	pop    %ss
  1b:	b7 42                	mov    $0x42,%bh
  1d:	17                   	pop    %ss
  1e:	00 00                	add    %al,(%eax)
  20:	02 2e                	add    (%esi),%ch
  22:	01 3f                	add    %edi,(%edi)
  24:	19 03                	sbb    %eax,(%ebx)
  26:	0e                   	push   %cs
  27:	3a 21                	cmp    (%ecx),%ah
  29:	01 3b                	add    %edi,(%ebx)
  2b:	0b 39                	or     (%ecx),%edi
  2d:	21 06                	and    %eax,(%esi)
  2f:	27                   	daa
  30:	19 11                	sbb    %edx,(%ecx)
  32:	01 12                	add    %edx,(%edx)
  34:	06                   	push   %es
  35:	40                   	inc    %eax
  36:	18 7a 19             	sbb    %bh,0x19(%edx)
  39:	01 13                	add    %edx,(%ebx)
  3b:	00 00                	add    %al,(%eax)
  3d:	03 05 00 03 08 3a    	add    0x3a080300,%eax
  43:	21 01                	and    %eax,(%ecx)
  45:	3b 0b                	cmp    (%ebx),%ecx
  47:	39 0b                	cmp    %ecx,(%ebx)
  49:	49                   	dec    %ecx
  4a:	13 02                	adc    (%edx),%eax
  4c:	18 00                	sbb    %al,(%eax)
  4e:	00 04 48             	add    %al,(%eax,%ecx,2)
  51:	00 7d 01             	add    %bh,0x1(%ebp)
  54:	7f 13                	jg     69 <PROT_MODE_DSEG+0x59>
  56:	00 00                	add    %al,(%eax)
  58:	05 24 00 0b 0b       	add    $0xb0b0024,%eax
  5d:	3e 0b 03             	or     %ds:(%ebx),%eax
  60:	0e                   	push   %cs
  61:	00 00                	add    %al,(%eax)
  63:	06                   	push   %es
  64:	05 00 03 08 3a       	add    $0x3a080300,%eax
  69:	21 01                	and    %eax,(%ecx)
  6b:	3b 0b                	cmp    (%ebx),%ecx
  6d:	39 0b                	cmp    %ecx,(%ebx)
  6f:	49                   	dec    %ecx
  70:	13 02                	adc    (%edx),%eax
  72:	17                   	pop    %ss
  73:	b7 42                	mov    $0x42,%bh
  75:	17                   	pop    %ss
  76:	00 00                	add    %al,(%eax)
  78:	07                   	pop    %es
  79:	34 00                	xor    $0x0,%al
  7b:	03 08                	add    (%eax),%ecx
  7d:	3a 21                	cmp    (%ecx),%ah
  7f:	01 3b                	add    %edi,(%ebx)
  81:	0b 39                	or     (%ecx),%edi
  83:	0b 49 13             	or     0x13(%ecx),%ecx
  86:	02 17                	add    (%edi),%dl
  88:	b7 42                	mov    $0x42,%bh
  8a:	17                   	pop    %ss
  8b:	00 00                	add    %al,(%eax)
  8d:	08 05 00 03 0e 3a    	or     %al,0x3a0e0300
  93:	21 02                	and    %eax,(%edx)
  95:	3b 0b                	cmp    (%ebx),%ecx
  97:	39 0b                	cmp    %ecx,(%ebx)
  99:	49                   	dec    %ecx
  9a:	13 00                	adc    (%eax),%eax
  9c:	00 09                	add    %cl,(%ecx)
  9e:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
  a3:	21 01                	and    %eax,(%ecx)
  a5:	3b 0b                	cmp    (%ebx),%ecx
  a7:	39 0b                	cmp    %ecx,(%ebx)
  a9:	49                   	dec    %ecx
  aa:	13 02                	adc    (%edx),%eax
  ac:	17                   	pop    %ss
  ad:	b7 42                	mov    $0x42,%bh
  af:	17                   	pop    %ss
  b0:	00 00                	add    %al,(%eax)
  b2:	0a 05 00 03 0e 3a    	or     0x3a0e0300,%al
  b8:	21 01                	and    %eax,(%ecx)
  ba:	3b 0b                	cmp    (%ebx),%ecx
  bc:	39 0b                	cmp    %ecx,(%ebx)
  be:	49                   	dec    %ecx
  bf:	13 02                	adc    (%edx),%eax
  c1:	18 00                	sbb    %al,(%eax)
  c3:	00 0b                	add    %cl,(%ebx)
  c5:	1d 01 31 13 52       	sbb    $0x52133101,%eax
  ca:	01 b8 42 0b 55 17    	add    %edi,0x17550b42(%eax)
  d0:	58                   	pop    %eax
  d1:	21 01                	and    %eax,(%ecx)
  d3:	59                   	pop    %ecx
  d4:	0b 57 21             	or     0x21(%edi),%edx
  d7:	05 01 13 00 00       	add    $0x1301,%eax
  dc:	0c 1d                	or     $0x1d,%al
  de:	01 31                	add    %esi,(%ecx)
  e0:	13 52 01             	adc    0x1(%edx),%edx
  e3:	b8 42 0b 11 01       	mov    $0x1110b42,%eax
  e8:	12 06                	adc    (%esi),%al
  ea:	58                   	pop    %eax
  eb:	21 01                	and    %eax,(%ecx)
  ed:	59                   	pop    %ecx
  ee:	0b 57 21             	or     0x21(%edi),%edx
  f1:	05 01 13 00 00       	add    $0x1301,%eax
  f6:	0d 16 00 03 0e       	or     $0xe030016,%eax
  fb:	3a 21                	cmp    (%ecx),%ah
  fd:	02 3b                	add    (%ebx),%bh
  ff:	0b 39                	or     (%ecx),%edi
 101:	21 1c 49             	and    %ebx,(%ecx,%ecx,2)
 104:	13 00                	adc    (%eax),%eax
 106:	00 0e                	add    %cl,(%esi)
 108:	0f 00 0b             	str    (%ebx)
 10b:	21 04 49             	and    %eax,(%ecx,%ecx,2)
 10e:	13 00                	adc    (%eax),%eax
 110:	00 0f                	add    %cl,(%edi)
 112:	34 00                	xor    $0x0,%al
 114:	03 08                	add    (%eax),%ecx
 116:	3a 21                	cmp    (%ecx),%ah
 118:	01 3b                	add    %edi,(%ebx)
 11a:	0b 39                	or     (%ecx),%edi
 11c:	0b 49 13             	or     0x13(%ecx),%ecx
 11f:	02 18                	add    (%eax),%bl
 121:	00 00                	add    %al,(%eax)
 123:	10 01                	adc    %al,(%ecx)
 125:	01 49 13             	add    %ecx,0x13(%ecx)
 128:	01 13                	add    %edx,(%ebx)
 12a:	00 00                	add    %al,(%eax)
 12c:	11 21                	adc    %esp,(%ecx)
 12e:	00 49 13             	add    %cl,0x13(%ecx)
 131:	2f                   	das
 132:	0b 00                	or     (%eax),%eax
 134:	00 12                	add    %dl,(%edx)
 136:	34 00                	xor    $0x0,%al
 138:	03 0e                	add    (%esi),%ecx
 13a:	3a 21                	cmp    (%ecx),%ah
 13c:	01 3b                	add    %edi,(%ebx)
 13e:	0b 39                	or     (%ecx),%edi
 140:	0b 49 13             	or     0x13(%ecx),%ecx
 143:	3f                   	aas
 144:	19 02                	sbb    %eax,(%edx)
 146:	18 00                	sbb    %al,(%eax)
 148:	00 13                	add    %dl,(%ebx)
 14a:	34 00                	xor    $0x0,%al
 14c:	03 0e                	add    (%esi),%ecx
 14e:	3a 21                	cmp    (%ecx),%ah
 150:	01 3b                	add    %edi,(%ebx)
 152:	0b 39                	or     (%ecx),%edi
 154:	0b 49 13             	or     0x13(%ecx),%ecx
 157:	02 17                	add    (%edi),%dl
 159:	b7 42                	mov    $0x42,%bh
 15b:	17                   	pop    %ss
 15c:	00 00                	add    %al,(%eax)
 15e:	14 1d                	adc    $0x1d,%al
 160:	01 31                	add    %esi,(%ecx)
 162:	13 52 01             	adc    0x1(%edx),%edx
 165:	b8 42 0b 55 17       	mov    $0x17550b42,%eax
 16a:	58                   	pop    %eax
 16b:	21 01                	and    %eax,(%ecx)
 16d:	59                   	pop    %ecx
 16e:	0b 57 21             	or     0x21(%edi),%edx
 171:	0d 00 00 15 0b       	or     $0xb150000,%eax
 176:	01 55 17             	add    %edx,0x17(%ebp)
 179:	00 00                	add    %al,(%eax)
 17b:	16                   	push   %ss
 17c:	34 00                	xor    $0x0,%al
 17e:	31 13                	xor    %edx,(%ebx)
 180:	02 17                	add    (%edi),%dl
 182:	b7 42                	mov    $0x42,%bh
 184:	17                   	pop    %ss
 185:	00 00                	add    %al,(%eax)
 187:	17                   	pop    %ss
 188:	48                   	dec    %eax
 189:	00 7d 01             	add    %bh,0x1(%ebp)
 18c:	82 01 19             	addb   $0x19,(%ecx)
 18f:	7f 13                	jg     1a4 <PR_BOOTABLE+0x124>
 191:	00 00                	add    %al,(%eax)
 193:	18 2e                	sbb    %ch,(%esi)
 195:	01 3f                	add    %edi,(%edi)
 197:	19 03                	sbb    %eax,(%ebx)
 199:	0e                   	push   %cs
 19a:	3a 21                	cmp    (%ecx),%ah
 19c:	01 3b                	add    %edi,(%ebx)
 19e:	0b 39                	or     (%ecx),%edi
 1a0:	21 05 27 19 49 13    	and    %eax,0x13491927
 1a6:	11 01                	adc    %eax,(%ecx)
 1a8:	12 06                	adc    (%esi),%al
 1aa:	40                   	inc    %eax
 1ab:	18 7a 19             	sbb    %bh,0x19(%edx)
 1ae:	01 13                	add    %edx,(%ebx)
 1b0:	00 00                	add    %al,(%eax)
 1b2:	19 11                	sbb    %edx,(%ecx)
 1b4:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 1ba:	1f                   	pop    %ds
 1bb:	1b 1f                	sbb    (%edi),%ebx
 1bd:	11 01                	adc    %eax,(%ecx)
 1bf:	12 06                	adc    (%esi),%al
 1c1:	10 17                	adc    %dl,(%edi)
 1c3:	00 00                	add    %al,(%eax)
 1c5:	1a 24 00             	sbb    (%eax,%eax,1),%ah
 1c8:	0b 0b                	or     (%ebx),%ecx
 1ca:	3e 0b 03             	or     %ds:(%ebx),%eax
 1cd:	08 00                	or     %al,(%eax)
 1cf:	00 1b                	add    %bl,(%ebx)
 1d1:	35 00 49 13 00       	xor    $0x134900,%eax
 1d6:	00 1c 26             	add    %bl,(%esi,%eiz,1)
 1d9:	00 49 13             	add    %cl,0x13(%ecx)
 1dc:	00 00                	add    %al,(%eax)
 1de:	1d 34 00 03 0e       	sbb    $0xe030034,%eax
 1e3:	3a 0b                	cmp    (%ebx),%cl
 1e5:	3b 0b                	cmp    (%ebx),%ecx
 1e7:	39 0b                	cmp    %ecx,(%ebx)
 1e9:	49                   	dec    %ecx
 1ea:	13 02                	adc    (%edx),%eax
 1ec:	18 00                	sbb    %al,(%eax)
 1ee:	00 1e                	add    %bl,(%esi)
 1f0:	1d 01 31 13 52       	sbb    $0x52133101,%eax
 1f5:	01 b8 42 0b 11 01    	add    %edi,0x1110b42(%eax)
 1fb:	12 06                	adc    (%esi),%al
 1fd:	58                   	pop    %eax
 1fe:	0b 59 0b             	or     0xb(%ecx),%ebx
 201:	57                   	push   %edi
 202:	0b 00                	or     (%eax),%eax
 204:	00 1f                	add    %bl,(%edi)
 206:	0f 00 0b             	str    (%ebx)
 209:	0b 00                	or     (%eax),%eax
 20b:	00 20                	add    %ah,(%eax)
 20d:	2e 00 03             	add    %al,%cs:(%ebx)
 210:	0e                   	push   %cs
 211:	3a 0b                	cmp    (%ebx),%cl
 213:	3b 0b                	cmp    (%ebx),%ecx
 215:	39 0b                	cmp    %ecx,(%ebx)
 217:	27                   	daa
 218:	19 20                	sbb    %esp,(%eax)
 21a:	0b 00                	or     (%eax),%eax
 21c:	00 21                	add    %ah,(%ecx)
 21e:	2e 01 03             	add    %eax,%cs:(%ebx)
 221:	0e                   	push   %cs
 222:	3a 0b                	cmp    (%ebx),%cl
 224:	3b 0b                	cmp    (%ebx),%ecx
 226:	39 0b                	cmp    %ecx,(%ebx)
 228:	27                   	daa
 229:	19 20                	sbb    %esp,(%eax)
 22b:	0b 01                	or     (%ecx),%eax
 22d:	13 00                	adc    (%eax),%eax
 22f:	00 22                	add    %ah,(%edx)
 231:	05 00 03 08 3a       	add    $0x3a080300,%eax
 236:	0b 3b                	or     (%ebx),%edi
 238:	0b 39                	or     (%ecx),%edi
 23a:	0b 49 13             	or     0x13(%ecx),%ecx
 23d:	00 00                	add    %al,(%eax)
 23f:	23 2e                	and    (%esi),%ebp
 241:	01 03                	add    %eax,(%ebx)
 243:	08 3a                	or     %bh,(%edx)
 245:	0b 3b                	or     (%ebx),%edi
 247:	0b 39                	or     (%ecx),%edi
 249:	0b 27                	or     (%edi),%esp
 24b:	19 49 13             	sbb    %ecx,0x13(%ecx)
 24e:	20 0b                	and    %cl,(%ebx)
 250:	01 13                	add    %edx,(%ebx)
 252:	00 00                	add    %al,(%eax)
 254:	24 34                	and    $0x34,%al
 256:	00 03                	add    %al,(%ebx)
 258:	0e                   	push   %cs
 259:	3a 0b                	cmp    (%ebx),%cl
 25b:	3b 0b                	cmp    (%ebx),%ecx
 25d:	39 0b                	cmp    %ecx,(%ebx)
 25f:	49                   	dec    %ecx
 260:	13 00                	adc    (%eax),%eax
 262:	00 25 2e 01 03 0e    	add    %ah,0xe03012e
 268:	3a 0b                	cmp    (%ebx),%cl
 26a:	3b 0b                	cmp    (%ebx),%ecx
 26c:	39 0b                	cmp    %ecx,(%ebx)
 26e:	27                   	daa
 26f:	19 20                	sbb    %esp,(%eax)
 271:	0b 00                	or     (%eax),%eax
 273:	00 00                	add    %al,(%eax)
 275:	01 0d 00 03 0e 3a    	add    %ecx,0x3a0e0300
 27b:	21 02                	and    %eax,(%edx)
 27d:	3b 0b                	cmp    (%ebx),%ecx
 27f:	39 0b                	cmp    %ecx,(%ebx)
 281:	49                   	dec    %ecx
 282:	13 38                	adc    (%eax),%edi
 284:	0b 00                	or     (%eax),%eax
 286:	00 02                	add    %al,(%edx)
 288:	48                   	dec    %eax
 289:	00 7d 01             	add    %bh,0x1(%ebp)
 28c:	7f 13                	jg     2a1 <PR_BOOTABLE+0x221>
 28e:	00 00                	add    %al,(%eax)
 290:	03 16                	add    (%esi),%edx
 292:	00 03                	add    %al,(%ebx)
 294:	0e                   	push   %cs
 295:	3a 21                	cmp    (%ecx),%ah
 297:	02 3b                	add    (%ebx),%bh
 299:	0b 39                	or     (%ecx),%edi
 29b:	0b 49 13             	or     0x13(%ecx),%ecx
 29e:	00 00                	add    %al,(%eax)
 2a0:	04 05                	add    $0x5,%al
 2a2:	00 49 13             	add    %cl,0x13(%ecx)
 2a5:	00 00                	add    %al,(%eax)
 2a7:	05 24 00 0b 0b       	add    $0xb0b0024,%eax
 2ac:	3e 0b 03             	or     %ds:(%ebx),%eax
 2af:	0e                   	push   %cs
 2b0:	00 00                	add    %al,(%eax)
 2b2:	06                   	push   %es
 2b3:	01 01                	add    %eax,(%ecx)
 2b5:	49                   	dec    %ecx
 2b6:	13 01                	adc    (%ecx),%eax
 2b8:	13 00                	adc    (%eax),%eax
 2ba:	00 07                	add    %al,(%edi)
 2bc:	2e 01 3f             	add    %edi,%cs:(%edi)
 2bf:	19 03                	sbb    %eax,(%ebx)
 2c1:	0e                   	push   %cs
 2c2:	3a 0b                	cmp    (%ebx),%cl
 2c4:	3b 0b                	cmp    (%ebx),%ecx
 2c6:	39 0b                	cmp    %ecx,(%ebx)
 2c8:	27                   	daa
 2c9:	19 3c 19             	sbb    %edi,(%ecx,%ebx,1)
 2cc:	01 13                	add    %edx,(%ebx)
 2ce:	00 00                	add    %al,(%eax)
 2d0:	08 21                	or     %ah,(%ecx)
 2d2:	00 49 13             	add    %cl,0x13(%ecx)
 2d5:	2f                   	das
 2d6:	0b 00                	or     (%eax),%eax
 2d8:	00 09                	add    %cl,(%ecx)
 2da:	0f 00 0b             	str    (%ebx)
 2dd:	21 04 49             	and    %eax,(%ecx,%ecx,2)
 2e0:	13 00                	adc    (%eax),%eax
 2e2:	00 0a                	add    %cl,(%edx)
 2e4:	13 01                	adc    (%ecx),%eax
 2e6:	0b 0b                	or     (%ebx),%ecx
 2e8:	3a 21                	cmp    (%ecx),%ah
 2ea:	02 3b                	add    (%ebx),%bh
 2ec:	0b 39                	or     (%ecx),%edi
 2ee:	0b 01                	or     (%ecx),%eax
 2f0:	13 00                	adc    (%eax),%eax
 2f2:	00 0b                	add    %cl,(%ebx)
 2f4:	13 01                	adc    (%ecx),%eax
 2f6:	03 0e                	add    (%esi),%ecx
 2f8:	0b 0b                	or     (%ebx),%ecx
 2fa:	3a 21                	cmp    (%ecx),%ah
 2fc:	02 3b                	add    (%ebx),%bh
 2fe:	0b 39                	or     (%ecx),%edi
 300:	21 10                	and    %edx,(%eax)
 302:	01 13                	add    %edx,(%ebx)
 304:	00 00                	add    %al,(%eax)
 306:	0c 34                	or     $0x34,%al
 308:	00 03                	add    %al,(%ebx)
 30a:	08 3a                	or     %bh,(%edx)
 30c:	21 01                	and    %eax,(%ecx)
 30e:	3b 0b                	cmp    (%ebx),%ecx
 310:	39 0b                	cmp    %ecx,(%ebx)
 312:	49                   	dec    %ecx
 313:	13 02                	adc    (%edx),%eax
 315:	17                   	pop    %ss
 316:	b7 42                	mov    $0x42,%bh
 318:	17                   	pop    %ss
 319:	00 00                	add    %al,(%eax)
 31b:	0d 0d 00 03 0e       	or     $0xe03000d,%eax
 320:	3a 21                	cmp    (%ecx),%ah
 322:	02 3b                	add    (%ebx),%bh
 324:	0b 39                	or     (%ecx),%edi
 326:	0b 49 13             	or     0x13(%ecx),%ecx
 329:	38 05 00 00 0e 34    	cmp    %al,0x340e0000
 32f:	00 03                	add    %al,(%ebx)
 331:	0e                   	push   %cs
 332:	3a 21                	cmp    (%ecx),%ah
 334:	01 3b                	add    %edi,(%ebx)
 336:	0b 39                	or     (%ecx),%edi
 338:	21 0e                	and    %ecx,(%esi)
 33a:	49                   	dec    %ecx
 33b:	13 02                	adc    (%edx),%eax
 33d:	17                   	pop    %ss
 33e:	b7 42                	mov    $0x42,%bh
 340:	17                   	pop    %ss
 341:	00 00                	add    %al,(%eax)
 343:	0f 0d 00             	prefetch (%eax)
 346:	03 08                	add    (%eax),%ecx
 348:	3a 21                	cmp    (%ecx),%ah
 34a:	02 3b                	add    (%ebx),%bh
 34c:	0b 39                	or     (%ecx),%edi
 34e:	0b 49 13             	or     0x13(%ecx),%ecx
 351:	38 0b                	cmp    %cl,(%ebx)
 353:	00 00                	add    %al,(%eax)
 355:	10 2e                	adc    %ch,(%esi)
 357:	01 3f                	add    %edi,(%edi)
 359:	19 03                	sbb    %eax,(%ebx)
 35b:	0e                   	push   %cs
 35c:	3a 21                	cmp    (%ecx),%ah
 35e:	01 3b                	add    %edi,(%ebx)
 360:	0b 39                	or     (%ecx),%edi
 362:	0b 27                	or     (%edi),%esp
 364:	19 49 13             	sbb    %ecx,0x13(%ecx)
 367:	11 01                	adc    %eax,(%ecx)
 369:	12 06                	adc    (%esi),%al
 36b:	40                   	inc    %eax
 36c:	18 7a 19             	sbb    %bh,0x19(%edx)
 36f:	01 13                	add    %edx,(%ebx)
 371:	00 00                	add    %al,(%eax)
 373:	11 05 00 03 0e 3a    	adc    %eax,0x3a0e0300
 379:	21 01                	and    %eax,(%ecx)
 37b:	3b 0b                	cmp    (%ebx),%ecx
 37d:	39 0b                	cmp    %ecx,(%ebx)
 37f:	49                   	dec    %ecx
 380:	13 02                	adc    (%edx),%eax
 382:	18 00                	sbb    %al,(%eax)
 384:	00 12                	add    %dl,(%edx)
 386:	11 01                	adc    %eax,(%ecx)
 388:	25 0e 13 0b 03       	and    $0x30b130e,%eax
 38d:	1f                   	pop    %ds
 38e:	1b 1f                	sbb    (%edi),%ebx
 390:	11 01                	adc    %eax,(%ecx)
 392:	12 06                	adc    (%esi),%al
 394:	10 17                	adc    %dl,(%edi)
 396:	00 00                	add    %al,(%eax)
 398:	13 24 00             	adc    (%eax,%eax,1),%esp
 39b:	0b 0b                	or     (%ebx),%ecx
 39d:	3e 0b 03             	or     %ds:(%ebx),%eax
 3a0:	08 00                	or     %al,(%eax)
 3a2:	00 14 13             	add    %dl,(%ebx,%edx,1)
 3a5:	01 03                	add    %eax,(%ebx)
 3a7:	08 0b                	or     %cl,(%ebx)
 3a9:	05 3a 0b 3b 0b       	add    $0xb3b0b3a,%eax
 3ae:	39 0b                	cmp    %ecx,(%ebx)
 3b0:	01 13                	add    %edx,(%ebx)
 3b2:	00 00                	add    %al,(%eax)
 3b4:	15 21 00 49 13       	adc    $0x13490021,%eax
 3b9:	2f                   	das
 3ba:	05 00 00 16 17       	add    $0x17160000,%eax
 3bf:	01 0b                	add    %ecx,(%ebx)
 3c1:	0b 3a                	or     (%edx),%edi
 3c3:	0b 3b                	or     (%ebx),%edi
 3c5:	0b 39                	or     (%ecx),%edi
 3c7:	0b 01                	or     (%ecx),%eax
 3c9:	13 00                	adc    (%eax),%eax
 3cb:	00 17                	add    %dl,(%edi)
 3cd:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 3d2:	0b 3b                	or     (%ebx),%edi
 3d4:	0b 39                	or     (%ecx),%edi
 3d6:	0b 49 13             	or     0x13(%ecx),%ecx
 3d9:	00 00                	add    %al,(%eax)
 3db:	18 0d 00 03 08 3a    	sbb    %cl,0x3a080300
 3e1:	0b 3b                	or     (%ebx),%edi
 3e3:	0b 39                	or     (%ecx),%edi
 3e5:	0b 49 13             	or     0x13(%ecx),%ecx
 3e8:	00 00                	add    %al,(%eax)
 3ea:	19 34 00             	sbb    %esi,(%eax,%eax,1)
 3ed:	03 0e                	add    (%esi),%ecx
 3ef:	3a 0b                	cmp    (%ebx),%cl
 3f1:	3b 0b                	cmp    (%ebx),%ecx
 3f3:	39 0b                	cmp    %ecx,(%ebx)
 3f5:	49                   	dec    %ecx
 3f6:	13 3f                	adc    (%edi),%edi
 3f8:	19 02                	sbb    %eax,(%edx)
 3fa:	18 00                	sbb    %al,(%eax)
 3fc:	00 1a                	add    %bl,(%edx)
 3fe:	2e 01 3f             	add    %edi,%cs:(%edi)
 401:	19 03                	sbb    %eax,(%ebx)
 403:	0e                   	push   %cs
 404:	3a 0b                	cmp    (%ebx),%cl
 406:	3b 0b                	cmp    (%ebx),%ecx
 408:	39 0b                	cmp    %ecx,(%ebx)
 40a:	27                   	daa
 40b:	19 11                	sbb    %edx,(%ecx)
 40d:	01 12                	add    %edx,(%edx)
 40f:	06                   	push   %es
 410:	40                   	inc    %eax
 411:	18 7a 19             	sbb    %bh,0x19(%edx)
 414:	01 13                	add    %edx,(%ebx)
 416:	00 00                	add    %al,(%eax)
 418:	1b 05 00 03 08 3a    	sbb    0x3a080300,%eax
 41e:	0b 3b                	or     (%ebx),%edi
 420:	0b 39                	or     (%ecx),%edi
 422:	0b 49 13             	or     0x13(%ecx),%ecx
 425:	02 18                	add    (%eax),%bl
 427:	00 00                	add    %al,(%eax)
 429:	1c 05                	sbb    $0x5,%al
 42b:	00 03                	add    %al,(%ebx)
 42d:	08 3a                	or     %bh,(%edx)
 42f:	0b 3b                	or     (%ebx),%edi
 431:	0b 39                	or     (%ecx),%edi
 433:	0b 49 13             	or     0x13(%ecx),%ecx
 436:	02 17                	add    (%edi),%dl
 438:	b7 42                	mov    $0x42,%bh
 43a:	17                   	pop    %ss
 43b:	00 00                	add    %al,(%eax)
 43d:	1d 05 00 03 0e       	sbb    $0xe030005,%eax
 442:	3a 0b                	cmp    (%ebx),%cl
 444:	3b 0b                	cmp    (%ebx),%ecx
 446:	39 0b                	cmp    %ecx,(%ebx)
 448:	49                   	dec    %ecx
 449:	13 02                	adc    (%edx),%eax
 44b:	17                   	pop    %ss
 44c:	b7 42                	mov    $0x42,%bh
 44e:	17                   	pop    %ss
 44f:	00 00                	add    %al,(%eax)
 451:	00 01                	add    %al,(%ecx)
 453:	11 00                	adc    %eax,(%eax)
 455:	10 17                	adc    %dl,(%edi)
 457:	11 01                	adc    %eax,(%ecx)
 459:	12 0f                	adc    (%edi),%cl
 45b:	03 0e                	add    (%esi),%ecx
 45d:	1b 0e                	sbb    (%esi),%ecx
 45f:	25 0e 13 05 00       	and    $0x5130e,%eax
 464:	00 00                	add    %al,(%eax)

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	83 00 00             	addl   $0x0,(%eax)
   3:	00 05 00 04 00 2e    	add    %al,0x2e000400
   9:	00 00                	add    %al,(%eax)
   b:	00 01                	add    %al,(%ecx)
   d:	01 01                	add    %eax,(%ecx)
   f:	fb                   	sti
  10:	0e                   	push   %cs
  11:	0d 00 01 01 01       	or     $0x1010100,%eax
  16:	01 00                	add    %eax,(%eax)
  18:	00 00                	add    %al,(%eax)
  1a:	01 00                	add    %eax,(%eax)
  1c:	00 01                	add    %al,(%ecx)
  1e:	01 01                	add    %eax,(%ecx)
  20:	1f                   	pop    %ds
  21:	02 00                	add    (%eax),%al
  23:	00 00                	add    %al,(%eax)
  25:	00 2c 00             	add    %ch,(%eax,%eax,1)
  28:	00 00                	add    %al,(%eax)
  2a:	02 01                	add    (%ecx),%al
  2c:	1f                   	pop    %ds
  2d:	02 0f                	add    (%edi),%cl
  2f:	02 37                	add    (%edi),%dh
  31:	00 00                	add    %al,(%eax)
  33:	00 01                	add    %al,(%ecx)
  35:	37                   	aaa
  36:	00 00                	add    %al,(%eax)
  38:	00 01                	add    %al,(%ecx)
  3a:	00 05 02 00 7e 00    	add    %al,0x7e0002
  40:	00 03                	add    %al,(%ebx)
  42:	29 01                	sub    %eax,(%ecx)
  44:	21 24 2f             	and    %esp,(%edi,%ebp,1)
  47:	2f                   	das
  48:	2f                   	das
  49:	2f                   	das
  4a:	30 2f                	xor    %ch,(%edi)
  4c:	2f                   	das
  4d:	2f                   	das
  4e:	2f                   	das
  4f:	34 3d                	xor    $0x3d,%al
  51:	42                   	inc    %edx
  52:	3d 67 3e 67 67       	cmp    $0x67673e67,%eax
  57:	30 2f                	xor    %ch,(%edi)
  59:	67 30 83 3d 4b       	xor    %al,0x4b3d(%bp,%di)
  5e:	2f                   	das
  5f:	30 2f                	xor    %ch,(%edi)
  61:	3d 2f 30 3d 3d       	cmp    $0x3d3d302f,%eax
  66:	31 26                	xor    %esp,(%esi)
  68:	59                   	pop    %ecx
  69:	3d 4b 40 5c 4b       	cmp    $0x4b5c404b,%eax
  6e:	2f                   	das
  6f:	2f                   	das
  70:	2f                   	das
  71:	2f                   	das
  72:	34 59                	xor    $0x59,%al
  74:	59                   	pop    %ecx
  75:	59                   	pop    %ecx
  76:	21 5b 27             	and    %ebx,0x27(%ebx)
  79:	21 30                	and    %esi,(%eax)
  7b:	21 2f                	and    %ebp,(%edi)
  7d:	2f                   	das
  7e:	2f                   	das
  7f:	30 21                	xor    %ah,(%ecx)
  81:	02 fc                	add    %ah,%bh
  83:	18 00                	sbb    %al,(%eax)
  85:	01 01                	add    %eax,(%ecx)
  87:	ef                   	out    %eax,(%dx)
  88:	03 00                	add    (%eax),%eax
  8a:	00 05 00 04 00 33    	add    %al,0x33000400
  90:	00 00                	add    %al,(%eax)
  92:	00 01                	add    %al,(%ecx)
  94:	01 01                	add    %eax,(%ecx)
  96:	fb                   	sti
  97:	0e                   	push   %cs
  98:	0d 00 01 01 01       	or     $0x1010100,%eax
  9d:	01 00                	add    %eax,(%eax)
  9f:	00 00                	add    %al,(%eax)
  a1:	01 00                	add    %eax,(%eax)
  a3:	00 01                	add    %al,(%ecx)
  a5:	01 01                	add    %eax,(%ecx)
  a7:	1f                   	pop    %ds
  a8:	02 00                	add    (%eax),%al
  aa:	00 00                	add    %al,(%eax)
  ac:	00 2c 00             	add    %ch,(%eax,%eax,1)
  af:	00 00                	add    %al,(%eax)
  b1:	02 01                	add    (%ecx),%al
  b3:	1f                   	pop    %ds
  b4:	02 0f                	add    (%edi),%cl
  b6:	03 4a 00             	add    0x0(%edx),%ecx
  b9:	00 00                	add    %al,(%eax)
  bb:	01 4a 00             	add    %ecx,0x0(%edx)
  be:	00 00                	add    %al,(%eax)
  c0:	01 55 00             	add    %edx,0x0(%ebp)
  c3:	00 00                	add    %al,(%eax)
  c5:	01 05 01 00 05 02    	add    %eax,0x2050001
  cb:	26 8b 00             	mov    %es:(%eax),%eax
  ce:	00 1a                	add    %bl,(%edx)
  d0:	05 05 13 05 01       	add    $0x1051305,%eax
  d5:	06                   	push   %es
  d6:	ab                   	stos   %eax,%es:(%edi)
  d7:	3c 05                	cmp    $0x5,%al
  d9:	22 3d 05 14 2e 05    	and    0x52e1405,%bh
  df:	05 06 67 05 08       	add    $0x8056706,%eax
  e4:	06                   	push   %es
  e5:	01 05 05 06 59 05    	add    %eax,0x5590605
  eb:	0e                   	push   %cs
  ec:	06                   	push   %es
  ed:	01 05 01 67 06 31    	add    %eax,0x31066701
  f3:	05 05 13 05 01       	add    $0x1051305,%eax
  f8:	06                   	push   %es
  f9:	11 05 0f 59 05 01    	adc    %eax,0x105590f
  ff:	49                   	dec    %ecx
 100:	05 09 3d 05 05       	add    $0x5053d09,%eax
 105:	06                   	push   %es
 106:	3d 05 09 06 11       	cmp    $0x11060905,%eax
 10b:	05 14 06 2f 05       	add    $0x52f0614,%eax
 110:	0c 06                	or     $0x6,%al
 112:	01 05 14 90 05 09    	add    %eax,0x9059014
 118:	06                   	push   %es
 119:	4b                   	dec    %ebx
 11a:	06                   	push   %es
 11b:	01 66 82             	add    %esp,-0x7e(%esi)
 11e:	05 05 06 76 05       	add    $0x5760605,%eax
 123:	01 06                	add    %eax,(%esi)
 125:	13 58 20             	adc    0x20(%eax),%ebx
 128:	06                   	push   %es
 129:	28 05 05 13 05 01    	sub    %al,0x1051305
 12f:	06                   	push   %es
 130:	11 05 15 e5 05 05    	adc    %eax,0x505e515
 136:	66 05 26 00          	add    $0x26,%ax
 13a:	02 04 01             	add    (%ecx,%eax,1),%al
 13d:	66 3c 05             	data16 cmp $0x5,%al
 140:	05 00 02 04 04       	add    $0x4040200,%eax
 145:	74 06                	je     14d <PR_BOOTABLE+0xcd>
 147:	08 13                	or     %dl,(%ebx)
 149:	05 01 06 c9 06       	add    $0x6c90601,%eax
 14e:	85 05 05 13 05 01    	test   %eax,0x1051305
 154:	06                   	push   %es
 155:	9d                   	popf
 156:	05 09 3d 05 01       	add    $0x1053d09,%eax
 15b:	3d 05 09 1f 05       	cmp    $0x51f0905,%eax
 160:	01 67 06             	add    %esp,0x6(%edi)
 163:	23 05 05 13 05 01    	and    0x1051305,%eax
 169:	06                   	push   %es
 16a:	11 05 05 67 06 08    	adc    %eax,0x8066705
 170:	13 05 09 00 02 04    	adc    0x4020009,%eax
 176:	01 13                	add    %edx,(%ebx)
 178:	05 0b 1f 05 01       	add    $0x1051f0b,%eax
 17d:	03 11                	add    (%ecx),%edx
 17f:	2e 05 05 13 14 05    	cs add $0x5141305,%eax
 185:	01 06                	add    %eax,(%esi)
 187:	0f 05                	syscall
 189:	0c 23                	or     $0x23,%al
 18b:	05 01 2b 2e 05       	add    $0x52e2b01,%eax
 190:	14 00                	adc    $0x0,%al
 192:	02 04 01             	add    (%ecx,%eax,1),%al
 195:	06                   	push   %es
 196:	3f                   	aas
 197:	05 09 67 05 0a       	add    $0xa056709,%eax
 19c:	06                   	push   %es
 19d:	01 05 1e 00 02 04    	add    %eax,0x402001e
 1a3:	03 06                	add    (%esi),%eax
 1a5:	1f                   	pop    %ds
 1a6:	05 05 30 05 01       	add    $0x1053005,%eax
 1ab:	06                   	push   %es
 1ac:	13 06                	adc    (%esi),%eax
 1ae:	32 05 05 13 13 14    	xor    0x14131305,%al
 1b4:	05 01 06 0e 58       	add    $0x580e0601,%eax
 1b9:	05 15 40 05 0c       	add    $0xc054015,%eax
 1be:	ba 05 13 00 02       	mov    $0x2001305,%edx
 1c3:	04 01                	add    $0x1,%al
 1c5:	2e 05 26 00 02 04    	cs add $0x4020026,%eax
 1cb:	01 06                	add    %eax,(%esi)
 1cd:	20 05 09 4b 05 0b    	and    %al,0xb054b09
 1d3:	06                   	push   %es
 1d4:	01 05 09 06 4b 05    	add    %eax,0x54b0609
 1da:	0e                   	push   %cs
 1db:	06                   	push   %es
 1dc:	01 05 09 06 67 05    	add    %eax,0x5670609
 1e2:	0e                   	push   %cs
 1e3:	06                   	push   %es
 1e4:	01 05 2c 00 02 04    	add    %eax,0x402002c
 1ea:	03 2b                	add    (%ebx),%ebp
 1ec:	05 0e 23 05 2e       	add    $0x2e05230e,%eax
 1f1:	00 02                	add    %al,(%edx)
 1f3:	04 03                	add    $0x3,%al
 1f5:	06                   	push   %es
 1f6:	39 05 31 00 02 04    	cmp    %eax,0x4020031
 1fc:	03 06                	add    (%esi),%eax
 1fe:	01 00                	add    %eax,(%eax)
 200:	02 04 03             	add    (%ebx,%eax,1),%al
 203:	20 05 01 33 06 78    	and    %al,0x78063301
 209:	05 05 13 14 05       	add    $0x5141305,%eax
 20e:	01 06                	add    %eax,(%esi)
 210:	0f 90 3c 05 08 bd 05 	seto   0x505bd08(,%eax,1)
 217:	05 
 218:	06                   	push   %es
 219:	93                   	xchg   %eax,%ebx
 21a:	05 09 13 05 0c       	add    $0xc051309,%eax
 21f:	06                   	push   %es
 220:	4a                   	dec    %edx
 221:	05 1a 00 02 04       	add    $0x402001a,%eax
 226:	01 06                	add    %eax,(%esi)
 228:	21 05 17 06 3b 05    	and    %eax,0x53b0617
 22e:	1a 00                	sbb    (%eax),%al
 230:	02 04 01             	add    (%ecx,%eax,1),%al
 233:	91                   	xchg   %eax,%ecx
 234:	05 05 06 4b 05       	add    $0x54b0605,%eax
 239:	08 06                	or     %al,(%esi)
 23b:	01 05 09 06 4b 05    	add    %eax,0x54b0609
 241:	0c 06                	or     $0x6,%al
 243:	01 05 10 3c 05 0c    	add    %eax,0xc053c10
 249:	4a                   	dec    %edx
 24a:	05 05 06 3d 05       	add    $0x53d0605,%eax
 24f:	0a 06                	or     (%esi),%al
 251:	01 05 05 06 4b 05    	add    %eax,0x54b0605
 257:	01 06                	add    %eax,(%esi)
 259:	3d 58 05 05 2d       	cmp    $0x2d050558,%eax
 25e:	58                   	pop    %eax
 25f:	05 01 06 00 05       	add    $0x5000601,%eax
 264:	02 a2 8c 00 00 16    	add    0x1600008c(%edx),%ah
 26a:	05 05 13 13 05       	add    $0x5131305,%eax
 26f:	01 06                	add    %eax,(%esi)
 271:	9c                   	pushf
 272:	05 05 68 05 01       	add    $0x1056805,%eax
 277:	08 3d 4a 06 23 05    	or     %bh,0x523064a
 27d:	05 13 13 05 01       	add    $0x1051313,%eax
 282:	06                   	push   %es
 283:	9c                   	pushf
 284:	05 05 68 05 01       	add    $0x1056805,%eax
 289:	08 3d 4a 06 03 47    	or     %bh,0x4703064a
 28f:	20 05 05 13 05 01    	and    %al,0x1051305
 295:	06                   	push   %es
 296:	9d                   	popf
 297:	05 05 4b 05 01       	add    $0x1054b05,%eax
 29c:	65 05 05 3d 06 91    	gs add $0x91063d05,%eax
 2a2:	05 01 06 67 05       	add    $0x5670601,%eax
 2a7:	05 49 05 01 06       	add    $0x6010549,%eax
 2ac:	03 c4                	add    %esp,%eax
 2ae:	00 58 05             	add    %bl,0x5(%eax)
 2b1:	05 14 05 0d 03       	add    $0x30d0514,%eax
 2b6:	76 01                	jbe    2b9 <PR_BOOTABLE+0x239>
 2b8:	05 05 15 05 01       	add    $0x1051505,%eax
 2bd:	06                   	push   %es
 2be:	17                   	pop    %ss
 2bf:	04 02                	add    $0x2,%al
 2c1:	05 05 03 ac 7f       	add    $0x7fac0305,%eax
 2c6:	4a                   	dec    %edx
 2c7:	04 01                	add    $0x1,%al
 2c9:	05 01 03 d4 00       	add    $0xd40301,%eax
 2ce:	58                   	pop    %eax
 2cf:	05 20 00 02 04       	add    $0x4020020,%eax
 2d4:	01 06                	add    %eax,(%esi)
 2d6:	37                   	aaa
 2d7:	04 02                	add    $0x2,%al
 2d9:	05 17 03 ae 7f       	add    $0x7fae0317,%eax
 2de:	01 05 05 14 13 3d    	add    %eax,0x3d131405
 2e4:	06                   	push   %es
 2e5:	01 04 01             	add    %eax,(%ecx,%eax,1)
 2e8:	05 20 00 02 04       	add    $0x4020020,%eax
 2ed:	01 03                	add    %eax,(%ebx)
 2ef:	ce                   	into
 2f0:	00 01                	add    %al,(%ecx)
 2f2:	05 05 06 03 09       	add    $0x9030605,%eax
 2f7:	74 04                	je     2fd <PR_BOOTABLE+0x27d>
 2f9:	02 05 14 03 9b 7f    	add    0x7f9b0314,%al
 2ff:	01 05 05 14 06 82    	add    %eax,0x82061405
 305:	04 01                	add    $0x1,%al
 307:	06                   	push   %es
 308:	03 e4                	add    %esp,%esp
 30a:	00 01                	add    %al,(%ecx)
 30c:	04 02                	add    $0x2,%al
 30e:	05 14 03 9a 7f       	add    $0x7f9a0314,%eax
 313:	01 05 05 14 06 82    	add    %eax,0x82061405
 319:	04 01                	add    $0x1,%al
 31b:	06                   	push   %es
 31c:	03 e5                	add    %ebp,%esp
 31e:	00 01                	add    %al,(%ecx)
 320:	04 02                	add    $0x2,%al
 322:	05 14 03 99 7f       	add    $0x7f990314,%eax
 327:	01 05 05 14 04 01    	add    %eax,0x1041405
 32d:	05 18 06 03 e5       	add    $0xe5030618,%eax
 332:	00 01                	add    %al,(%ecx)
 334:	04 02                	add    $0x2,%al
 336:	05 05 03 9b 7f       	add    $0x7f9b0305,%eax
 33b:	2e 04 01             	cs add $0x1,%al
 33e:	05 18 03 e5 00       	add    $0xe50318,%eax
 343:	58                   	pop    %eax
 344:	04 02                	add    $0x2,%al
 346:	05 05 03 9b 7f       	add    $0x7f9b0305,%eax
 34b:	3c 20                	cmp    $0x20,%al
 34d:	04 01                	add    $0x1,%al
 34f:	06                   	push   %es
 350:	03 e6                	add    %esi,%esp
 352:	00 01                	add    %al,(%ecx)
 354:	04 02                	add    $0x2,%al
 356:	05 14 03 98 7f       	add    $0x7f980314,%eax
 35b:	01 05 05 14 04 01    	add    %eax,0x1041405
 361:	05 18 06 03 e6       	add    $0xe6030618,%eax
 366:	00 01                	add    %al,(%ecx)
 368:	04 02                	add    $0x2,%al
 36a:	05 05 03 9a 7f       	add    $0x7f9a0305,%eax
 36f:	2e 04 01             	cs add $0x1,%al
 372:	05 18 03 e6 00       	add    $0xe60318,%eax
 377:	58                   	pop    %eax
 378:	04 02                	add    $0x2,%al
 37a:	05 05 03 9a 7f       	add    $0x7f9a0305,%eax
 37f:	3c 20                	cmp    $0x20,%al
 381:	04 01                	add    $0x1,%al
 383:	06                   	push   %es
 384:	03 e7                	add    %edi,%esp
 386:	00 01                	add    %al,(%ecx)
 388:	04 02                	add    $0x2,%al
 38a:	05 14 03 97 7f       	add    $0x7f970314,%eax
 38f:	01 05 05 14 04 01    	add    %eax,0x1041405
 395:	05 19 06 03 e7       	add    $0xe7030619,%eax
 39a:	00 01                	add    %al,(%ecx)
 39c:	04 02                	add    $0x2,%al
 39e:	05 05 03 99 7f       	add    $0x7f990305,%eax
 3a3:	2e 04 01             	cs add $0x1,%al
 3a6:	05 19 03 e7 00       	add    $0xe70319,%eax
 3ab:	58                   	pop    %eax
 3ac:	05 20 3c 04 02       	add    $0x2043c20,%eax
 3b1:	05 05 03 99 7f       	add    $0x7f990305,%eax
 3b6:	3c 20                	cmp    $0x20,%al
 3b8:	04 01                	add    $0x1,%al
 3ba:	06                   	push   %es
 3bb:	03 e8                	add    %eax,%ebp
 3bd:	00 01                	add    %al,(%ecx)
 3bf:	04 02                	add    $0x2,%al
 3c1:	05 14 03 96 7f       	add    $0x7f960314,%eax
 3c6:	01 05 05 14 06 58    	add    %eax,0x58061405
 3cc:	04 01                	add    $0x1,%al
 3ce:	06                   	push   %es
 3cf:	03 eb                	add    %ebx,%ebp
 3d1:	00 01                	add    %al,(%ecx)
 3d3:	05 0d 03 6c 01       	add    $0x16c030d,%eax
 3d8:	05 05 15 04 02       	add    $0x2041505,%eax
 3dd:	06                   	push   %es
 3de:	03 b1 7f 01 04 01    	add    0x104017f(%ecx),%esi
 3e4:	05 20 00 02 04       	add    $0x4020020,%eax
 3e9:	01 06                	add    %eax,(%esi)
 3eb:	03 cf                	add    %edi,%ecx
 3ed:	00 58 04             	add    %bl,0x4(%eax)
 3f0:	02 05 17 03 ae 7f    	add    0x7fae0317,%al
 3f6:	01 05 05 14 13 21    	add    %eax,0x21131405
 3fc:	06                   	push   %es
 3fd:	01 04 01             	add    %eax,(%ecx,%eax,1)
 400:	05 20 00 02 04       	add    $0x4020020,%eax
 405:	01 03                	add    %eax,(%ebx)
 407:	ce                   	into
 408:	00 01                	add    %al,(%ecx)
 40a:	05 05 06 03 14       	add    $0x14030605,%eax
 40f:	74 04                	je     415 <PR_BOOTABLE+0x395>
 411:	02 05 14 03 a1 7f    	add    0x7fa10314,%al
 417:	01 05 05 14 06 f2    	add    %eax,0xf2061405
 41d:	04 01                	add    $0x1,%al
 41f:	05 01 03 de 00       	add    $0xde0301,%eax
 424:	01 06                	add    %eax,(%esi)
 426:	41                   	inc    %ecx
 427:	05 05 13 14 05       	add    $0x5141305,%eax
 42c:	01 06                	add    %eax,(%esi)
 42e:	0f 90 05 05 06 40 05 	seto   0x5400605
 435:	16                   	push   %ss
 436:	06                   	push   %es
 437:	17                   	pop    %ss
 438:	05 08 03 7a 3c       	add    $0x3c7a0308,%eax
 43d:	05 16 34 05 08       	add    $0x8053416,%eax
 442:	39 05 0c 69 05 08    	cmp    %eax,0x805690c
 448:	03 7a 3c             	add    0x3c(%edx),%edi
 44b:	05 0c 67 05 05       	add    $0x505670c,%eax
 450:	06                   	push   %es
 451:	3e 15 17 05 0f 01    	ds adc $0x10f0517,%eax
 457:	05 09 4b 05 0f       	add    $0xf054b09,%eax
 45c:	06                   	push   %es
 45d:	3e 05 09 1e 05 0c    	ds add $0xc051e09,%eax
 463:	21 05 09 65 06 59    	and    %eax,0x59066509
 469:	13 05 0f 06 01 05    	adc    0x501060f,%eax
 46f:	01 5a 4a             	add    %ebx,0x4a(%edx)
 472:	20 20                	and    %ah,(%eax)
 474:	20 02                	and    %al,(%edx)
 476:	01 00                	add    %eax,(%eax)
 478:	01 01                	add    %eax,(%ecx)
 47a:	8e 01                	mov    (%ecx),%es
 47c:	00 00                	add    %al,(%eax)
 47e:	05 00 04 00 33       	add    $0x33000400,%eax
 483:	00 00                	add    %al,(%eax)
 485:	00 01                	add    %al,(%ecx)
 487:	01 01                	add    %eax,(%ecx)
 489:	fb                   	sti
 48a:	0e                   	push   %cs
 48b:	0d 00 01 01 01       	or     $0x1010100,%eax
 490:	01 00                	add    %eax,(%eax)
 492:	00 00                	add    %al,(%eax)
 494:	01 00                	add    %eax,(%eax)
 496:	00 01                	add    %al,(%ecx)
 498:	01 01                	add    %eax,(%ecx)
 49a:	1f                   	pop    %ds
 49b:	02 00                	add    (%eax),%al
 49d:	00 00                	add    %al,(%eax)
 49f:	00 2c 00             	add    %ch,(%eax,%eax,1)
 4a2:	00 00                	add    %al,(%eax)
 4a4:	02 01                	add    (%ecx),%al
 4a6:	1f                   	pop    %ds
 4a7:	02 0f                	add    (%edi),%cl
 4a9:	03 6b 00             	add    0x0(%ebx),%ebp
 4ac:	00 00                	add    %al,(%eax)
 4ae:	01 6b 00             	add    %ebp,0x0(%ebx)
 4b1:	00 00                	add    %al,(%eax)
 4b3:	01 55 00             	add    %edx,0x0(%ebp)
 4b6:	00 00                	add    %al,(%eax)
 4b8:	01 05 01 00 05 02    	add    %eax,0x2050001
 4be:	e1 8d                	loope  44d <PR_BOOTABLE+0x3cd>
 4c0:	00 00                	add    %al,(%eax)
 4c2:	03 2b                	add    (%ebx),%ebp
 4c4:	01 05 05 14 14 05    	add    %eax,0x5141405
 4ca:	01 06                	add    %eax,(%esi)
 4cc:	0e                   	push   %cs
 4cd:	05 05 08 40 06       	add    $0x6400805,%eax
 4d2:	08 3f                	or     %bh,(%edi)
 4d4:	05 08 06 01 05       	add    $0x5010608,%eax
 4d9:	09 06                	or     %eax,(%esi)
 4db:	e5 05                	in     $0x5,%eax
 4dd:	05 08 23 05 08       	add    $0x8052308,%eax
 4e2:	06                   	push   %es
 4e3:	01 05 16 59 05 08    	add    %eax,0x8055916
 4e9:	73 05                	jae    4f0 <PR_BOOTABLE+0x470>
 4eb:	05 06 67 05 0e       	add    $0xe056706,%eax
 4f0:	06                   	push   %es
 4f1:	01 05 09 3c 05 05    	add    %eax,0x5053c09
 4f7:	06                   	push   %es
 4f8:	30 05 0f 00 02 04    	xor    %al,0x402000f
 4fe:	01 01                	add    %eax,(%ecx)
 500:	05 09 4b 05 18       	add    $0x18054b09,%eax
 505:	00 02                	add    %al,(%edx)
 507:	04 02                	add    $0x2,%al
 509:	06                   	push   %es
 50a:	3b 05 09 3d 05 18    	cmp    0x18053d09,%eax
 510:	00 02                	add    %al,(%edx)
 512:	04 02                	add    $0x2,%al
 514:	06                   	push   %es
 515:	d5 00                	aad    $0x0
 517:	02 04 02             	add    (%edx,%eax,1),%al
 51a:	06                   	push   %es
 51b:	01 05 05 06 5c 05    	add    %eax,0x55c0605
 521:	1d 06 01 05 01       	sbb    $0x1050106,%eax
 526:	59                   	pop    %ecx
 527:	05 1d 57 05 01       	add    $0x105571d,%eax
 52c:	59                   	pop    %ecx
 52d:	20 06                	and    %al,(%esi)
 52f:	31 05 05 13 13 13    	xor    %eax,0x13131305
 535:	05 01 06 0f 05       	add    $0x50f0601,%eax
 53a:	0e                   	push   %cs
 53b:	5c                   	pop    %esp
 53c:	05 01 2a e4 05       	add    $0x5e42a01,%eax
 541:	05 06 40 13 bb       	add    $0xbb134006,%eax
 546:	05 0b 06 01 05       	add    $0x501060b,%eax
 54b:	30 06                	xor    %al,(%esi)
 54d:	3c 05                	cmp    $0x5,%al
 54f:	0d 06 58 05 30       	or     $0x30055806,%eax
 554:	4a                   	dec    %edx
 555:	05 09 06 2f 05       	add    $0x52f0609,%eax
 55a:	12 06                	adc    (%esi),%al
 55c:	3e 05 09 3a 06 67    	ds add $0x67063a09,%eax
 562:	13 05 12 06 01 05    	adc    0x5010612,%eax
 568:	30 55 05             	xor    %dl,0x5(%ebp)
 56b:	1e                   	push   %ds
 56c:	00 02                	add    %al,(%edx)
 56e:	04 01                	add    $0x1,%al
 570:	4a                   	dec    %edx
 571:	05 30 00 02 04       	add    $0x4020030,%eax
 576:	02 d6                	add    %dh,%dl
 578:	05 05 06 79 05       	add    $0x5790605,%eax
 57d:	1c 06                	sbb    $0x6,%al
 57f:	01 05 05 06 67 05    	add    %eax,0x5670605
 585:	0c 00                	or     $0x0,%al
 587:	02 04 01             	add    (%ecx,%eax,1),%al
 58a:	06                   	push   %es
 58b:	13 05 1a 65 05 05    	adc    0x505651a,%eax
 591:	06                   	push   %es
 592:	67 05 01 06 13 58    	addr16 add $0x58130601,%eax
 598:	20 06                	and    %al,(%esi)
 59a:	03 bb 7f 2e 05 05    	add    0x5052e7f(%ebx),%edi
 5a0:	13 05 01 06 11 58    	adc    0x58110601,%eax
 5a6:	05 05 d7 06 9f       	add    $0x9f06d705,%eax
 5ab:	d9 13                	fsts   (%ebx)
 5ad:	13 05 13 00 02 04    	adc    0x4020013,%eax
 5b3:	01 01                	add    %eax,(%ecx)
 5b5:	05 05 06 0d 05       	add    $0x50d0605,%eax
 5ba:	0c 41                	or     $0x41,%al
 5bc:	05 09 06 2f 05       	add    $0x52f0609,%eax
 5c1:	1e                   	push   %ds
 5c2:	06                   	push   %es
 5c3:	01 05 0c 58 05 0d    	add    %eax,0xd05580c
 5c9:	06                   	push   %es
 5ca:	9f                   	lahf
 5cb:	05 1a 06 01 05       	add    $0x501061a,%eax
 5d0:	0d 06 75 05 05       	or     $0x5057506,%eax
 5d5:	16                   	push   %ss
 5d6:	05 19 00 02 04       	add    $0x4020019,%eax
 5db:	02 03                	add    (%ebx),%al
 5dd:	79 2e                	jns    60d <PR_BOOTABLE+0x58d>
 5df:	05 13 00 02 04       	add    $0x4020013,%eax
 5e4:	01 20                	add    %esp,(%eax)
 5e6:	05 05 5f 05 09       	add    $0x9055f05,%eax
 5eb:	13 06                	adc    (%esi),%eax
 5ed:	90                   	nop
 5ee:	05 05 06 ae ae       	add    $0xaeae0605,%eax
 5f3:	d7                   	xlat   %ds:(%ebx)
 5f4:	05 16 06 01 05       	add    $0x5010616,%eax
 5f9:	05 06 a0 06 66       	add    $0x6606a006,%eax
 5fe:	06                   	push   %es
 5ff:	84 e6                	test   %ah,%dh
 601:	05 01 06 d8 82       	add    $0x82d80601,%eax
 606:	20 02                	and    %al,(%edx)
 608:	01 00                	add    %eax,(%eax)
 60a:	01 01                	add    %eax,(%ecx)
 60c:	47                   	inc    %edi
 60d:	00 00                	add    %al,(%eax)
 60f:	00 05 00 04 00 2e    	add    %al,0x2e000400
 615:	00 00                	add    %al,(%eax)
 617:	00 01                	add    %al,(%ecx)
 619:	01 01                	add    %eax,(%ecx)
 61b:	fb                   	sti
 61c:	0e                   	push   %cs
 61d:	0d 00 01 01 01       	or     $0x1010100,%eax
 622:	01 00                	add    %eax,(%eax)
 624:	00 00                	add    %al,(%eax)
 626:	01 00                	add    %eax,(%eax)
 628:	00 01                	add    %al,(%ecx)
 62a:	01 01                	add    %eax,(%ecx)
 62c:	1f                   	pop    %ds
 62d:	02 00                	add    (%eax),%al
 62f:	00 00                	add    %al,(%eax)
 631:	00 2c 00             	add    %ch,(%eax,%eax,1)
 634:	00 00                	add    %al,(%eax)
 636:	02 01                	add    (%ecx),%al
 638:	1f                   	pop    %ds
 639:	02 0f                	add    (%edi),%cl
 63b:	02 77 00             	add    0x0(%edi),%dh
 63e:	00 00                	add    %al,(%eax)
 640:	01 77 00             	add    %esi,0x0(%edi)
 643:	00 00                	add    %al,(%eax)
 645:	01 00                	add    %eax,(%eax)
 647:	05 02 a5 8f 00       	add    $0x8fa502,%eax
 64c:	00 17                	add    %dl,(%edi)
 64e:	21 59 4b             	and    %ebx,0x4b(%ecx)
 651:	4b                   	dec    %ebx
 652:	02 02                	add    (%edx),%al
 654:	00 01                	add    %al,(%ecx)
 656:	01                   	.byte 0x1

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   3:	74 2f                	je     34 <PROT_MODE_DSEG+0x24>
   5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   8:	74 31                	je     3b <PROT_MODE_DSEG+0x2b>
   a:	2f                   	das
   b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   e:	74 31                	je     41 <PROT_MODE_DSEG+0x31>
  10:	2e 53                	cs push %ebx
  12:	00 2f                	add    %ch,(%edi)
  14:	68 6f 6d 65 2f       	push   $0x2f656d6f
  19:	6c                   	insb   (%dx),%es:(%edi)
  1a:	61                   	popa
  1b:	62 69 62             	bound  %ebp,0x62(%ecx)
  1e:	61                   	popa
  1f:	68 2f 44 6f 77       	push   $0x776f442f
  24:	6e                   	outsb  %ds:(%esi),(%dx)
  25:	6c                   	insb   (%dx),%es:(%edi)
  26:	6f                   	outsl  %ds:(%esi),(%dx)
  27:	61                   	popa
  28:	64 73 2f             	fs jae 5a <PROT_MODE_DSEG+0x4a>
  2b:	4c                   	dec    %esp
  2c:	61                   	popa
  2d:	62 20                	bound  %esp,(%eax)
  2f:	33 20                	xor    (%eax),%esp
  31:	53                   	push   %ebx
  32:	57                   	push   %edi
  33:	45                   	inc    %ebp
  34:	2f                   	das
  35:	6d                   	insl   (%dx),%es:(%edi)
  36:	63 65 72             	arpl   %esp,0x72(%ebp)
  39:	74 69                	je     a4 <PR_BOOTABLE+0x24>
  3b:	6b 6f 73 00          	imul   $0x0,0x73(%edi),%ebp
  3f:	47                   	inc    %edi
  40:	4e                   	dec    %esi
  41:	55                   	push   %ebp
  42:	20 41 53             	and    %al,0x53(%ecx)
  45:	20 32                	and    %dh,(%edx)
  47:	2e 34 33             	cs xor $0x33,%al
  4a:	2e 31 00             	xor    %eax,%cs:(%eax)
  4d:	65 6e                	outsb  %gs:(%esi),(%dx)
  4f:	64 5f                	fs pop %edi
  51:	76 61                	jbe    b4 <PR_BOOTABLE+0x34>
  53:	00 77 61             	add    %dh,0x61(%edi)
  56:	69 74 64 69 73 6b 00 	imul   $0x70006b73,0x69(%esp,%eiz,2),%esi
  5d:	70 
  5e:	75 74                	jne    d4 <PR_BOOTABLE+0x54>
  60:	6c                   	insb   (%dx),%es:(%edi)
  61:	69 6e 65 00 73 68 6f 	imul   $0x6f687300,0x65(%esi),%ebp
  68:	72 74                	jb     de <PR_BOOTABLE+0x5e>
  6a:	20 69 6e             	and    %ch,0x6e(%ecx)
  6d:	74 00                	je     6f <PROT_MODE_DSEG+0x5f>
  6f:	63 6f 6c             	arpl   %ebp,0x6c(%edi)
  72:	6f                   	outsl  %ds:(%esi),(%dx)
  73:	72 00                	jb     75 <PROT_MODE_DSEG+0x65>
  75:	72 6f                	jb     e6 <PR_BOOTABLE+0x66>
  77:	6c                   	insb   (%dx),%es:(%edi)
  78:	6c                   	insb   (%dx),%es:(%edi)
  79:	00 73 74             	add    %dh,0x74(%ebx)
  7c:	72 69                	jb     e7 <PR_BOOTABLE+0x67>
  7e:	6e                   	outsb  %ds:(%esi),(%dx)
  7f:	67 00 70 61          	add    %dh,0x61(%bx,%si)
  83:	6e                   	outsb  %ds:(%esi),(%dx)
  84:	69 63 00 70 75 74 69 	imul   $0x69747570,0x0(%ebx),%esp
  8b:	00 72 65             	add    %dh,0x65(%edx)
  8e:	61                   	popa
  8f:	64 73 65             	fs jae f7 <PR_BOOTABLE+0x77>
  92:	63 74 6f 72          	arpl   %esi,0x72(%edi,%ebp,2)
  96:	00 75 69             	add    %dh,0x69(%ebp)
  99:	6e                   	outsb  %ds:(%esi),(%dx)
  9a:	74 38                	je     d4 <PR_BOOTABLE+0x54>
  9c:	5f                   	pop    %edi
  9d:	74 00                	je     9f <PR_BOOTABLE+0x1f>
  9f:	6f                   	outsl  %ds:(%esi),(%dx)
  a0:	75 74                	jne    116 <PR_BOOTABLE+0x96>
  a2:	62 00                	bound  %eax,(%eax)
  a4:	69 6e 73 6c 00 6c 6f 	imul   $0x6f6c006c,0x73(%esi),%ebp
  ab:	6e                   	outsb  %ds:(%esi),(%dx)
  ac:	67 20 6c 6f          	and    %ch,0x6f(%si)
  b0:	6e                   	outsb  %ds:(%esi),(%dx)
  b1:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
  b5:	74 00                	je     b7 <PR_BOOTABLE+0x37>
  b7:	47                   	inc    %edi
  b8:	4e                   	dec    %esi
  b9:	55                   	push   %ebp
  ba:	20 43 31             	and    %al,0x31(%ebx)
  bd:	37                   	aaa
  be:	20 31                	and    %dh,(%ecx)
  c0:	34 2e                	xor    $0x2e,%al
  c2:	32 2e                	xor    (%esi),%ch
  c4:	30 20                	xor    %ah,(%eax)
  c6:	2d 6d 33 32 20       	sub    $0x2032336d,%eax
  cb:	2d 6d 74 75 6e       	sub    $0x6e75746d,%eax
  d0:	65 3d 67 65 6e 65    	gs cmp $0x656e6567,%eax
  d6:	72 69                	jb     141 <PR_BOOTABLE+0xc1>
  d8:	63 20                	arpl   %esp,(%eax)
  da:	2d 6d 61 72 63       	sub    $0x6372616d,%eax
  df:	68 3d 69 36 38       	push   $0x3836693d
  e4:	36 20 2d 67 20 2d 4f 	and    %ch,%ss:0x4f2d2067
  eb:	73 20                	jae    10d <PR_BOOTABLE+0x8d>
  ed:	2d 4f 73 20 2d       	sub    $0x2d20734f,%eax
  f2:	66 6e                	data16 outsb %ds:(%esi),(%dx)
  f4:	6f                   	outsl  %ds:(%esi),(%dx)
  f5:	2d 62 75 69 6c       	sub    $0x6c697562,%eax
  fa:	74 69                	je     165 <PR_BOOTABLE+0xe5>
  fc:	6e                   	outsb  %ds:(%esi),(%dx)
  fd:	20 2d 66 6e 6f 2d    	and    %ch,0x2d6f6e66
 103:	73 74                	jae    179 <PR_BOOTABLE+0xf9>
 105:	61                   	popa
 106:	63 6b 2d             	arpl   %ebp,0x2d(%ebx)
 109:	70 72                	jo     17d <PR_BOOTABLE+0xfd>
 10b:	6f                   	outsl  %ds:(%esi),(%dx)
 10c:	74 65                	je     173 <PR_BOOTABLE+0xf3>
 10e:	63 74 6f 72          	arpl   %esi,0x72(%edi,%ebp,2)
 112:	20 2d 66 61 73 79    	and    %ch,0x79736166
 118:	6e                   	outsb  %ds:(%esi),(%dx)
 119:	63 68 72             	arpl   %ebp,0x72(%eax)
 11c:	6f                   	outsl  %ds:(%esi),(%dx)
 11d:	6e                   	outsb  %ds:(%esi),(%dx)
 11e:	6f                   	outsl  %ds:(%esi),(%dx)
 11f:	75 73                	jne    194 <PR_BOOTABLE+0x114>
 121:	2d 75 6e 77 69       	sub    $0x69776e75,%eax
 126:	6e                   	outsb  %ds:(%esi),(%dx)
 127:	64 2d 74 61 62 6c    	fs sub $0x6c626174,%eax
 12d:	65 73 00             	gs jae 130 <PR_BOOTABLE+0xb0>
 130:	72 65                	jb     197 <PR_BOOTABLE+0x117>
 132:	61                   	popa
 133:	64 73 65             	fs jae 19b <PR_BOOTABLE+0x11b>
 136:	63 74 69 6f          	arpl   %esi,0x6f(%ecx,%ebp,2)
 13a:	6e                   	outsb  %ds:(%esi),(%dx)
 13b:	00 69 74             	add    %ch,0x74(%ecx)
 13e:	6f                   	outsl  %ds:(%esi),(%dx)
 13f:	61                   	popa
 140:	00 75 6e             	add    %dh,0x6e(%ebp)
 143:	73 69                	jae    1ae <PR_BOOTABLE+0x12e>
 145:	67 6e                	outsb  %ds:(%si),(%dx)
 147:	65 64 20 63 68       	gs and %ah,%fs:0x68(%ebx)
 14c:	61                   	popa
 14d:	72 00                	jb     14f <PR_BOOTABLE+0xcf>
 14f:	69 74 6f 68 00 70 75 	imul   $0x74757000,0x68(%edi,%ebp,2),%esi
 156:	74 
 157:	63 00                	arpl   %eax,(%eax)
 159:	6c                   	insb   (%dx),%es:(%edi)
 15a:	6f                   	outsl  %ds:(%esi),(%dx)
 15b:	6e                   	outsb  %ds:(%esi),(%dx)
 15c:	67 20 6c 6f          	and    %ch,0x6f(%si)
 160:	6e                   	outsb  %ds:(%esi),(%dx)
 161:	67 20 75 6e          	and    %dh,0x6e(%di)
 165:	73 69                	jae    1d0 <PR_BOOTABLE+0x150>
 167:	67 6e                	outsb  %ds:(%si),(%dx)
 169:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 16e:	74 00                	je     170 <PR_BOOTABLE+0xf0>
 170:	75 69                	jne    1db <PR_BOOTABLE+0x15b>
 172:	6e                   	outsb  %ds:(%esi),(%dx)
 173:	74 33                	je     1a8 <PR_BOOTABLE+0x128>
 175:	32 5f 74             	xor    0x74(%edi),%bl
 178:	00 69 74             	add    %ch,0x74(%ecx)
 17b:	6f                   	outsl  %ds:(%esi),(%dx)
 17c:	78 00                	js     17e <PR_BOOTABLE+0xfe>
 17e:	70 75                	jo     1f5 <PR_BOOTABLE+0x175>
 180:	74 73                	je     1f5 <PR_BOOTABLE+0x175>
 182:	00 73 68             	add    %dh,0x68(%ebx)
 185:	6f                   	outsl  %ds:(%esi),(%dx)
 186:	72 74                	jb     1fc <PR_BOOTABLE+0x17c>
 188:	20 75 6e             	and    %dh,0x6e(%ebp)
 18b:	73 69                	jae    1f6 <PR_BOOTABLE+0x176>
 18d:	67 6e                	outsb  %ds:(%si),(%dx)
 18f:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 194:	74 00                	je     196 <PR_BOOTABLE+0x116>
 196:	73 74                	jae    20c <PR_BOOTABLE+0x18c>
 198:	72 6c                	jb     206 <PR_BOOTABLE+0x186>
 19a:	65 6e                	outsb  %gs:(%esi),(%dx)
 19c:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
 1a0:	61                   	popa
 1a1:	00 70 6f             	add    %dh,0x6f(%eax)
 1a4:	72 74                	jb     21a <PR_BOOTABLE+0x19a>
 1a6:	00 73 69             	add    %dh,0x69(%ebx)
 1a9:	67 6e                	outsb  %ds:(%si),(%dx)
 1ab:	00 72 65             	add    %dh,0x65(%edx)
 1ae:	76 65                	jbe    215 <PR_BOOTABLE+0x195>
 1b0:	72 73                	jb     225 <PR_BOOTABLE+0x1a5>
 1b2:	65 00 70 75          	add    %dh,%gs:0x75(%eax)
 1b6:	74 69                	je     221 <PR_BOOTABLE+0x1a1>
 1b8:	5f                   	pop    %edi
 1b9:	73 74                	jae    22f <PR_BOOTABLE+0x1af>
 1bb:	72 00                	jb     1bd <PR_BOOTABLE+0x13d>
 1bd:	62 6c 61 6e          	bound  %ebp,0x6e(%ecx,%eiz,2)
 1c1:	6b 00 72             	imul   $0x72,(%eax),%eax
 1c4:	6f                   	outsl  %ds:(%esi),(%dx)
 1c5:	6f                   	outsl  %ds:(%esi),(%dx)
 1c6:	74 00                	je     1c8 <PR_BOOTABLE+0x148>
 1c8:	76 69                	jbe    233 <PR_BOOTABLE+0x1b3>
 1ca:	64 65 6f             	fs outsl %gs:(%esi),(%dx)
 1cd:	00 64 69 73          	add    %ah,0x73(%ecx,%ebp,2)
 1d1:	6b 5f 73 69          	imul   $0x69,0x73(%edi),%ebx
 1d5:	67 00 65 6c          	add    %ah,0x6c(%di)
 1d9:	66 68 64 66          	pushw  $0x6664
 1dd:	00 65 5f             	add    %ah,0x5f(%ebp)
 1e0:	73 68                	jae    24a <PR_BOOTABLE+0x1ca>
 1e2:	73 74                	jae    258 <PR_BOOTABLE+0x1d8>
 1e4:	72 6e                	jb     254 <PR_BOOTABLE+0x1d4>
 1e6:	64 78 00             	fs js  1e9 <PR_BOOTABLE+0x169>
 1e9:	6d                   	insl   (%dx),%es:(%edi)
 1ea:	6d                   	insl   (%dx),%es:(%edi)
 1eb:	61                   	popa
 1ec:	70 5f                	jo     24d <PR_BOOTABLE+0x1cd>
 1ee:	61                   	popa
 1ef:	64 64 72 00          	fs fs jb 1f3 <PR_BOOTABLE+0x173>
 1f3:	65 6c                	gs insb (%dx),%es:(%edi)
 1f5:	66 68 64 72          	pushw  $0x7264
 1f9:	00 76 62             	add    %dh,0x62(%esi)
 1fc:	65 5f                	gs pop %edi
 1fe:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 205:	63 65 5f             	arpl   %esp,0x5f(%ebp)
 208:	6f                   	outsl  %ds:(%esi),(%dx)
 209:	66 66 00 65 5f       	data16 data16 add %ah,0x5f(%ebp)
 20e:	65 6e                	outsb  %gs:(%esi),(%dx)
 210:	74 72                	je     284 <PR_BOOTABLE+0x204>
 212:	79 00                	jns    214 <PR_BOOTABLE+0x194>
 214:	75 69                	jne    27f <PR_BOOTABLE+0x1ff>
 216:	6e                   	outsb  %ds:(%esi),(%dx)
 217:	74 36                	je     24f <PR_BOOTABLE+0x1cf>
 219:	34 5f                	xor    $0x5f,%al
 21b:	74 00                	je     21d <PR_BOOTABLE+0x19d>
 21d:	6c                   	insb   (%dx),%es:(%edi)
 21e:	6f                   	outsl  %ds:(%esi),(%dx)
 21f:	61                   	popa
 220:	64 5f                	fs pop %edi
 222:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
 226:	65 6c                	gs insb (%dx),%es:(%edi)
 228:	00 70 5f             	add    %dh,0x5f(%eax)
 22b:	6d                   	insl   (%dx),%es:(%edi)
 22c:	65 6d                	gs insl (%dx),%es:(%edi)
 22e:	73 7a                	jae    2aa <PR_BOOTABLE+0x22a>
 230:	00 70 5f             	add    %dh,0x5f(%eax)
 233:	6f                   	outsl  %ds:(%esi),(%dx)
 234:	66 66 73 65          	data16 data16 jae 29d <PR_BOOTABLE+0x21d>
 238:	74 00                	je     23a <PR_BOOTABLE+0x1ba>
 23a:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 23d:	74 6c                	je     2ab <PR_BOOTABLE+0x22b>
 23f:	6f                   	outsl  %ds:(%esi),(%dx)
 240:	61                   	popa
 241:	64 65 72 00          	fs gs jb 245 <PR_BOOTABLE+0x1c5>
 245:	65 5f                	gs pop %edi
 247:	66 6c                	data16 insb (%dx),%es:(%edi)
 249:	61                   	popa
 24a:	67 73 00             	addr16 jae 24d <PR_BOOTABLE+0x1cd>
 24d:	63 6d 64             	arpl   %ebp,0x64(%ebp)
 250:	6c                   	insb   (%dx),%es:(%edi)
 251:	69 6e 65 00 65 5f 6d 	imul   $0x6d5f6500,0x65(%esi),%ebp
 258:	61                   	popa
 259:	63 68 69             	arpl   %ebp,0x69(%eax)
 25c:	6e                   	outsb  %ds:(%esi),(%dx)
 25d:	65 00 65 5f          	add    %ah,%gs:0x5f(%ebp)
 261:	70 68                	jo     2cb <PR_BOOTABLE+0x24b>
 263:	65 6e                	outsb  %gs:(%esi),(%dx)
 265:	74 73                	je     2da <PR_BOOTABLE+0x25a>
 267:	69 7a 65 00 65 78 65 	imul   $0x65786500,0x65(%edx),%edi
 26e:	63 5f 6b             	arpl   %ebx,0x6b(%edi)
 271:	65 72 6e             	gs jb  2e2 <PR_BOOTABLE+0x262>
 274:	65 6c                	gs insb (%dx),%es:(%edi)
 276:	00 6d 6f             	add    %ch,0x6f(%ebp)
 279:	64 73 5f             	fs jae 2db <PR_BOOTABLE+0x25b>
 27c:	61                   	popa
 27d:	64 64 72 00          	fs fs jb 281 <PR_BOOTABLE+0x201>
 281:	61                   	popa
 282:	6f                   	outsl  %ds:(%esi),(%dx)
 283:	75 74                	jne    2f9 <PR_BOOTABLE+0x279>
 285:	00 73 74             	add    %dh,0x74(%ebx)
 288:	72 73                	jb     2fd <PR_BOOTABLE+0x27d>
 28a:	69 7a 65 00 70 61 72 	imul   $0x72617000,0x65(%edx),%edi
 291:	74 33                	je     2c6 <PR_BOOTABLE+0x246>
 293:	00 70 5f             	add    %dh,0x5f(%eax)
 296:	74 79                	je     311 <PR_BOOTABLE+0x291>
 298:	70 65                	jo     2ff <PR_BOOTABLE+0x27f>
 29a:	00 70 72             	add    %dh,0x72(%eax)
 29d:	6f                   	outsl  %ds:(%esi),(%dx)
 29e:	67 68 64 72 00 65    	addr16 push $0x65007264
 2a4:	5f                   	pop    %edi
 2a5:	73 68                	jae    30f <PR_BOOTABLE+0x28f>
 2a7:	65 6e                	outsb  %gs:(%esi),(%dx)
 2a9:	74 73                	je     31e <PR_BOOTABLE+0x29e>
 2ab:	69 7a 65 00 73 68 6e 	imul   $0x6e687300,0x65(%edx),%edi
 2b2:	64 78 00             	fs js  2b5 <PR_BOOTABLE+0x235>
 2b5:	6d                   	insl   (%dx),%es:(%edi)
 2b6:	62 72 5f             	bound  %esi,0x5f(%edx)
 2b9:	74 00                	je     2bb <PR_BOOTABLE+0x23b>
 2bb:	65 5f                	gs pop %edi
 2bd:	74 79                	je     338 <PR_BOOTABLE+0x2b8>
 2bf:	70 65                	jo     326 <PR_BOOTABLE+0x2a6>
 2c1:	00 64 72 69          	add    %ah,0x69(%edx,%esi,2)
 2c5:	76 65                	jbe    32c <PR_BOOTABLE+0x2ac>
 2c7:	73 5f                	jae    328 <PR_BOOTABLE+0x2a8>
 2c9:	61                   	popa
 2ca:	64 64 72 00          	fs fs jb 2ce <PR_BOOTABLE+0x24e>
 2ce:	65 5f                	gs pop %edi
 2d0:	65 68 73 69 7a 65    	gs push $0x657a6973
 2d6:	00 70 61             	add    %dh,0x61(%eax)
 2d9:	72 74                	jb     34f <PR_BOOTABLE+0x2cf>
 2db:	69 74 69 6f 6e 00 62 	imul   $0x6962006e,0x6f(%ecx,%ebp,2),%esi
 2e2:	69 
 2e3:	6f                   	outsl  %ds:(%esi),(%dx)
 2e4:	73 5f                	jae    345 <PR_BOOTABLE+0x2c5>
 2e6:	73 6d                	jae    355 <PR_BOOTABLE+0x2d5>
 2e8:	61                   	popa
 2e9:	70 5f                	jo     34a <PR_BOOTABLE+0x2ca>
 2eb:	74 00                	je     2ed <PR_BOOTABLE+0x26d>
 2ed:	6d                   	insl   (%dx),%es:(%edi)
 2ee:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2f1:	74 5f                	je     352 <PR_BOOTABLE+0x2d2>
 2f3:	69 6e 66 6f 5f 74 00 	imul   $0x745f6f,0x66(%esi),%ebp
 2fa:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2fd:	74 61                	je     360 <PR_BOOTABLE+0x2e0>
 2ff:	62 6c 65 5f          	bound  %ebp,0x5f(%ebp,%eiz,2)
 303:	6c                   	insb   (%dx),%es:(%edi)
 304:	62 61 00             	bound  %esp,0x0(%ecx)
 307:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 30a:	74 31                	je     33d <PR_BOOTABLE+0x2bd>
 30c:	6d                   	insl   (%dx),%es:(%edi)
 30d:	61                   	popa
 30e:	69 6e 00 65 5f 76 65 	imul   $0x65765f65,0x0(%esi),%ebp
 315:	72 73                	jb     38a <PR_BOOTABLE+0x30a>
 317:	69 6f 6e 00 70 61 72 	imul   $0x72617000,0x6e(%edi),%ebp
 31e:	74 31                	je     351 <PR_BOOTABLE+0x2d1>
 320:	00 70 61             	add    %dh,0x61(%eax)
 323:	72 74                	jb     399 <PR_BOOTABLE+0x319>
 325:	32 00                	xor    (%eax),%al
 327:	64 72 69             	fs jb  393 <PR_BOOTABLE+0x313>
 32a:	76 65                	jbe    391 <PR_BOOTABLE+0x311>
 32c:	72 00                	jb     32e <PR_BOOTABLE+0x2ae>
 32e:	66 69 72 73 74 5f    	imul   $0x5f74,0x73(%edx),%si
 334:	63 68 73             	arpl   %ebp,0x73(%eax)
 337:	00 62 69             	add    %ah,0x69(%edx)
 33a:	6f                   	outsl  %ds:(%esi),(%dx)
 33b:	73 5f                	jae    39c <PR_BOOTABLE+0x31c>
 33d:	73 6d                	jae    3ac <PR_BOOTABLE+0x32c>
 33f:	61                   	popa
 340:	70 00                	jo     342 <PR_BOOTABLE+0x2c2>
 342:	6d                   	insl   (%dx),%es:(%edi)
 343:	65 6d                	gs insl (%dx),%es:(%edi)
 345:	5f                   	pop    %edi
 346:	6c                   	insb   (%dx),%es:(%edi)
 347:	6f                   	outsl  %ds:(%esi),(%dx)
 348:	77 65                	ja     3af <PR_BOOTABLE+0x32f>
 34a:	72 00                	jb     34c <PR_BOOTABLE+0x2cc>
 34c:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 34f:	74 61                	je     3b2 <PR_BOOTABLE+0x332>
 351:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 355:	73 79                	jae    3d0 <PR_BOOTABLE+0x350>
 357:	6d                   	insl   (%dx),%es:(%edi)
 358:	73 00                	jae    35a <PR_BOOTABLE+0x2da>
 35a:	75 69                	jne    3c5 <PR_BOOTABLE+0x345>
 35c:	6e                   	outsb  %ds:(%esi),(%dx)
 35d:	74 31                	je     390 <PR_BOOTABLE+0x310>
 35f:	36 5f                	ss pop %edi
 361:	74 00                	je     363 <PR_BOOTABLE+0x2e3>
 363:	6d                   	insl   (%dx),%es:(%edi)
 364:	6d                   	insl   (%dx),%es:(%edi)
 365:	61                   	popa
 366:	70 5f                	jo     3c7 <PR_BOOTABLE+0x347>
 368:	6c                   	insb   (%dx),%es:(%edi)
 369:	65 6e                	outsb  %gs:(%esi),(%dx)
 36b:	67 74 68             	addr16 je 3d6 <PR_BOOTABLE+0x356>
 36e:	00 6d 62             	add    %ch,0x62(%ebp)
 371:	6f                   	outsl  %ds:(%esi),(%dx)
 372:	6f                   	outsl  %ds:(%esi),(%dx)
 373:	74 5f                	je     3d4 <PR_BOOTABLE+0x354>
 375:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 37c:	76 61                	jbe    3df <PR_BOOTABLE+0x35f>
 37e:	00 76 62             	add    %dh,0x62(%esi)
 381:	65 5f                	gs pop %edi
 383:	63 6f 6e             	arpl   %ebp,0x6e(%edi)
 386:	74 72                	je     3fa <PR_BOOTABLE+0x37a>
 388:	6f                   	outsl  %ds:(%esi),(%dx)
 389:	6c                   	insb   (%dx),%es:(%edi)
 38a:	5f                   	pop    %edi
 38b:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 392:	66 6c                	data16 insb (%dx),%es:(%edi)
 394:	61                   	popa
 395:	67 73 00             	addr16 jae 398 <PR_BOOTABLE+0x318>
 398:	70 61                	jo     3fb <PR_BOOTABLE+0x37b>
 39a:	72 73                	jb     40f <PR_BOOTABLE+0x38f>
 39c:	65 5f                	gs pop %edi
 39e:	65 38 32             	cmp    %dh,%gs:(%edx)
 3a1:	30 00                	xor    %al,(%eax)
 3a3:	65 5f                	gs pop %edi
 3a5:	65 6c                	gs insb (%dx),%es:(%edi)
 3a7:	66 00 62 6f          	data16 add %ah,0x6f(%edx)
 3ab:	6f                   	outsl  %ds:(%esi),(%dx)
 3ac:	74 5f                	je     40d <PR_BOOTABLE+0x38d>
 3ae:	64 65 76 69          	fs gs jbe 41b <PR_BOOTABLE+0x39b>
 3b2:	63 65 00             	arpl   %esp,0x0(%ebp)
 3b5:	64 6b 65 72 6e       	imul   $0x6e,%fs:0x72(%ebp),%esp
 3ba:	65 6c                	gs insb (%dx),%es:(%edi)
 3bc:	00 65 5f             	add    %ah,0x5f(%ebp)
 3bf:	70 68                	jo     429 <PR_BOOTABLE+0x3a9>
 3c1:	6f                   	outsl  %ds:(%esi),(%dx)
 3c2:	66 66 00 63 6f       	data16 data16 add %ah,0x6f(%ebx)
 3c7:	6e                   	outsb  %ds:(%esi),(%dx)
 3c8:	66 69 67 5f 74 61    	imul   $0x6174,0x5f(%edi),%sp
 3ce:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 3d2:	65 5f                	gs pop %edi
 3d4:	6d                   	insl   (%dx),%es:(%edi)
 3d5:	61                   	popa
 3d6:	67 69 63 00 6c 61 73 	imul   $0x7473616c,0x0(%bp,%di),%esp
 3dd:	74 
 3de:	5f                   	pop    %edi
 3df:	63 68 73             	arpl   %ebp,0x73(%eax)
 3e2:	00 62 61             	add    %ah,0x61(%edx)
 3e5:	73 65                	jae    44c <PR_BOOTABLE+0x3cc>
 3e7:	5f                   	pop    %edi
 3e8:	61                   	popa
 3e9:	64 64 72 00          	fs fs jb 3ed <PR_BOOTABLE+0x36d>
 3ed:	76 62                	jbe    451 <PR_BOOTABLE+0x3d1>
 3ef:	65 5f                	gs pop %edi
 3f1:	6d                   	insl   (%dx),%es:(%edi)
 3f2:	6f                   	outsl  %ds:(%esi),(%dx)
 3f3:	64 65 00 65 5f       	fs add %ah,%gs:0x5f(%ebp)
 3f8:	73 68                	jae    462 <PR_BOOTABLE+0x3e2>
 3fa:	6f                   	outsl  %ds:(%esi),(%dx)
 3fb:	66 66 00 6d 65       	data16 data16 add %ch,0x65(%ebp)
 400:	6d                   	insl   (%dx),%es:(%edi)
 401:	5f                   	pop    %edi
 402:	75 70                	jne    474 <PR_BOOTABLE+0x3f4>
 404:	70 65                	jo     46b <PR_BOOTABLE+0x3eb>
 406:	72 00                	jb     408 <PR_BOOTABLE+0x388>
 408:	76 62                	jbe    46c <PR_BOOTABLE+0x3ec>
 40a:	65 5f                	gs pop %edi
 40c:	6d                   	insl   (%dx),%es:(%edi)
 40d:	6f                   	outsl  %ds:(%esi),(%dx)
 40e:	64 65 5f             	fs gs pop %edi
 411:	69 6e 66 6f 00 74 61 	imul   $0x6174006f,0x66(%esi),%ebp
 418:	62 73 69             	bound  %esi,0x69(%ebx)
 41b:	7a 65                	jp     482 <PR_BOOTABLE+0x402>
 41d:	00 66 69             	add    %ah,0x69(%esi)
 420:	72 73                	jb     495 <PR_BOOTABLE+0x415>
 422:	74 5f                	je     483 <PR_BOOTABLE+0x403>
 424:	6c                   	insb   (%dx),%es:(%edi)
 425:	62 61 00             	bound  %esp,0x0(%ecx)
 428:	64 72 69             	fs jb  494 <PR_BOOTABLE+0x414>
 42b:	76 65                	jbe    492 <PR_BOOTABLE+0x412>
 42d:	73 5f                	jae    48e <PR_BOOTABLE+0x40e>
 42f:	6c                   	insb   (%dx),%es:(%edi)
 430:	65 6e                	outsb  %gs:(%esi),(%dx)
 432:	67 74 68             	addr16 je 49d <PR_BOOTABLE+0x41d>
 435:	00 70 5f             	add    %dh,0x5f(%eax)
 438:	66 69 6c 65 73 7a 00 	imul   $0x7a,0x73(%ebp,%eiz,2),%bp
 43f:	65 5f                	gs pop %edi
 441:	70 68                	jo     4ab <PR_BOOTABLE+0x42b>
 443:	6e                   	outsb  %ds:(%esi),(%dx)
 444:	75 6d                	jne    4b3 <PR_BOOTABLE+0x433>
 446:	00 73 69             	add    %dh,0x69(%ebx)
 449:	67 6e                	outsb  %ds:(%si),(%dx)
 44b:	61                   	popa
 44c:	74 75                	je     4c3 <PR_BOOTABLE+0x443>
 44e:	72 65                	jb     4b5 <PR_BOOTABLE+0x435>
 450:	00 76 62             	add    %dh,0x62(%esi)
 453:	65 5f                	gs pop %edi
 455:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 45c:	63 65 5f             	arpl   %esp,0x5f(%ebp)
 45f:	6c                   	insb   (%dx),%es:(%edi)
 460:	65 6e                	outsb  %gs:(%esi),(%dx)
 462:	00 65 5f             	add    %ah,0x5f(%ebp)
 465:	73 68                	jae    4cf <PR_BOOTABLE+0x44f>
 467:	6e                   	outsb  %ds:(%esi),(%dx)
 468:	75 6d                	jne    4d7 <PR_BOOTABLE+0x457>
 46a:	00 6d 6f             	add    %ch,0x6f(%ebp)
 46d:	64 73 5f             	fs jae 4cf <PR_BOOTABLE+0x44f>
 470:	63 6f 75             	arpl   %ebp,0x75(%edi)
 473:	6e                   	outsb  %ds:(%esi),(%dx)
 474:	74 00                	je     476 <PR_BOOTABLE+0x3f6>
 476:	5f                   	pop    %edi
 477:	72 65                	jb     4de <PR_BOOTABLE+0x45e>
 479:	73 65                	jae    4e0 <PR_BOOTABLE+0x460>
 47b:	72 76                	jb     4f3 <PR_BOOTABLE+0x473>
 47d:	65 64 00 62 6f       	gs add %ah,%fs:0x6f(%edx)
 482:	6f                   	outsl  %ds:(%esi),(%dx)
 483:	74 5f                	je     4e4 <PR_BOOTABLE+0x464>
 485:	6c                   	insb   (%dx),%es:(%edi)
 486:	6f                   	outsl  %ds:(%esi),(%dx)
 487:	61                   	popa
 488:	64 65 72 5f          	fs gs jb 4eb <PR_BOOTABLE+0x46b>
 48c:	6e                   	outsb  %ds:(%esi),(%dx)
 48d:	61                   	popa
 48e:	6d                   	insl   (%dx),%es:(%edi)
 48f:	65 00 76 62          	add    %dh,%gs:0x62(%esi)
 493:	65 5f                	gs pop %edi
 495:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 49c:	63 65 5f             	arpl   %esp,0x5f(%ebp)
 49f:	73 65                	jae    506 <PR_BOOTABLE+0x486>
 4a1:	67 00 6d 6d          	add    %ch,0x6d(%di)
 4a5:	61                   	popa
 4a6:	70 5f                	jo     507 <PR_BOOTABLE+0x487>
 4a8:	6c                   	insb   (%dx),%es:(%edi)
 4a9:	65 6e                	outsb  %gs:(%esi),(%dx)
 4ab:	00 70 5f             	add    %dh,0x5f(%eax)
 4ae:	61                   	popa
 4af:	6c                   	insb   (%dx),%es:(%edi)
 4b0:	69 67 6e 00 61 70 6d 	imul   $0x6d706100,0x6e(%edi),%esp
 4b7:	5f                   	pop    %edi
 4b8:	74 61                	je     51b <PR_BOOTABLE+0x49b>
 4ba:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 4be:	70 5f                	jo     51f <PR_BOOTABLE+0x49f>
 4c0:	70 61                	jo     523 <PR_BOOTABLE+0x4a3>
 4c2:	00 73 65             	add    %dh,0x65(%ebx)
 4c5:	63 74 6f 72          	arpl   %esi,0x72(%edi,%ebp,2)
 4c9:	73 5f                	jae    52a <PR_BOOTABLE+0x4aa>
 4cb:	63 6f 75             	arpl   %ebp,0x75(%edi)
 4ce:	6e                   	outsb  %ds:(%esi),(%dx)
 4cf:	74 00                	je     4d1 <PR_BOOTABLE+0x451>
 4d1:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4d4:	74 2f                	je     505 <PR_BOOTABLE+0x485>
 4d6:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4d9:	74 31                	je     50c <PR_BOOTABLE+0x48c>
 4db:	2f                   	das
 4dc:	65 78 65             	gs js  544 <PR_BOOTABLE+0x4c4>
 4df:	63 5f 6b             	arpl   %ebx,0x6b(%edi)
 4e2:	65 72 6e             	gs jb  553 <PR_BOOTABLE+0x4d3>
 4e5:	65 6c                	gs insb (%dx),%es:(%edi)
 4e7:	2e 53                	cs push %ebx
 4e9:	00                   	.byte 0

Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	2f                   	das
   1:	68 6f 6d 65 2f       	push   $0x2f656d6f
   6:	6c                   	insb   (%dx),%es:(%edi)
   7:	61                   	popa
   8:	62 69 62             	bound  %ebp,0x62(%ecx)
   b:	61                   	popa
   c:	68 2f 44 6f 77       	push   $0x776f442f
  11:	6e                   	outsb  %ds:(%esi),(%dx)
  12:	6c                   	insb   (%dx),%es:(%edi)
  13:	6f                   	outsl  %ds:(%esi),(%dx)
  14:	61                   	popa
  15:	64 73 2f             	fs jae 47 <PROT_MODE_DSEG+0x37>
  18:	4c                   	dec    %esp
  19:	61                   	popa
  1a:	62 20                	bound  %esp,(%eax)
  1c:	33 20                	xor    (%eax),%esp
  1e:	53                   	push   %ebx
  1f:	57                   	push   %edi
  20:	45                   	inc    %ebp
  21:	2f                   	das
  22:	6d                   	insl   (%dx),%es:(%edi)
  23:	63 65 72             	arpl   %esp,0x72(%ebp)
  26:	74 69                	je     91 <PR_BOOTABLE+0x11>
  28:	6b 6f 73 00          	imul   $0x0,0x73(%edi),%ebp
  2c:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  2f:	74 2f                	je     60 <PROT_MODE_DSEG+0x50>
  31:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  34:	74 31                	je     67 <PROT_MODE_DSEG+0x57>
  36:	00 62 6f             	add    %ah,0x6f(%edx)
  39:	6f                   	outsl  %ds:(%esi),(%dx)
  3a:	74 31                	je     6d <PROT_MODE_DSEG+0x5d>
  3c:	2e 53                	cs push %ebx
  3e:	00 62 6f             	add    %ah,0x6f(%edx)
  41:	6f                   	outsl  %ds:(%esi),(%dx)
  42:	74 2f                	je     73 <PROT_MODE_DSEG+0x63>
  44:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  47:	74 31                	je     7a <PROT_MODE_DSEG+0x6a>
  49:	2f                   	das
  4a:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  4d:	74 31                	je     80 <PR_BOOTABLE>
  4f:	6c                   	insb   (%dx),%es:(%edi)
  50:	69 62 2e 63 00 62 6f 	imul   $0x6f620063,0x2e(%edx),%esp
  57:	6f                   	outsl  %ds:(%esi),(%dx)
  58:	74 31                	je     8b <PR_BOOTABLE+0xb>
  5a:	6c                   	insb   (%dx),%es:(%edi)
  5b:	69 62 2e 68 00 62 6f 	imul   $0x6f620068,0x2e(%edx),%esp
  62:	6f                   	outsl  %ds:(%esi),(%dx)
  63:	74 2f                	je     94 <PR_BOOTABLE+0x14>
  65:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  68:	74 31                	je     9b <PR_BOOTABLE+0x1b>
  6a:	2f                   	das
  6b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  6e:	74 31                	je     a1 <PR_BOOTABLE+0x21>
  70:	6d                   	insl   (%dx),%es:(%edi)
  71:	61                   	popa
  72:	69 6e 2e 63 00 65 78 	imul   $0x78650063,0x2e(%esi),%ebp
  79:	65 63 5f 6b          	arpl   %ebx,%gs:0x6b(%edi)
  7d:	65 72 6e             	gs jb  ee <PR_BOOTABLE+0x6e>
  80:	65 6c                	gs insb (%dx),%es:(%edi)
  82:	2e 53                	cs push %ebx
  84:	00                   	.byte 0

Disassembly of section .debug_loclists:

00000000 <.debug_loclists>:
   0:	c1 03 00             	roll   $0x0,(%ebx)
   3:	00 05 00 04 00 00    	add    %al,0x400
   9:	00 00                	add    %al,(%eax)
   b:	00 00                	add    %al,(%eax)
   d:	00 00                	add    %al,(%eax)
   f:	00 00                	add    %al,(%eax)
  11:	00 00                	add    %al,(%eax)
  13:	00 00                	add    %al,(%eax)
  15:	01 01                	add    %eax,(%ecx)
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	01 01                	add    %eax,(%ecx)
  1d:	00 04 ec             	add    %al,(%esp,%ebp,8)
  20:	04 f8                	add    $0xf8,%al
  22:	04 02                	add    $0x2,%al
  24:	91                   	xchg   %eax,%ecx
  25:	00 04 f8             	add    %al,(%eax,%edi,8)
  28:	04 86                	add    $0x86,%al
  2a:	05 09 73 00 0c       	add    $0xc007309,%eax
  2f:	ff                   	(bad)
  30:	ff                   	(bad)
  31:	ff 00                	incl   (%eax)
  33:	1a 9f 04 86 05 8f    	sbb    -0x70fa79fc(%edi),%bl
  39:	05 09 77 00 0c       	add    $0xc007709,%eax
  3e:	ff                   	(bad)
  3f:	ff                   	(bad)
  40:	ff 00                	incl   (%eax)
  42:	1a 9f 04 8f 05 92    	sbb    -0x6dfa70fc(%edi),%bl
  48:	05 01 57 04 92       	add    $0x92045701,%eax
  4d:	05 92 05 0a 91       	add    $0x910a0592,%eax
  52:	00 06                	add    %al,(%esi)
  54:	0c ff                	or     $0xff,%al
  56:	ff                   	(bad)
  57:	ff 00                	incl   (%eax)
  59:	1a 9f 04 92 05 a1    	sbb    -0x5efa6dfc(%edi),%bl
  5f:	05 01 53 04 a1       	add    $0xa1045301,%eax
  64:	05 a5 05 02 74       	add    $0x740205a5,%eax
  69:	00 04 a5 05 a6 05 04 	add    %al,0x405a605(,%eiz,4)
  70:	73 80                	jae    fffffff2 <SMAP_SIG+0xacb2bea2>
  72:	7c 9f                	jl     13 <PROT_MODE_DSEG+0x3>
  74:	04 a6                	add    $0xa6,%al
  76:	05 af 05 01 53       	add    $0x530105af,%eax
  7b:	00 00                	add    %al,(%eax)
  7d:	00 00                	add    %al,(%eax)
  7f:	00 04 ec             	add    %al,(%esp,%ebp,8)
  82:	04 b2                	add    $0xb2,%al
  84:	05 02 91 04 04       	add    $0x4049102,%eax
  89:	b2 05                	mov    $0x5,%dl
  8b:	b3 05                	mov    $0x5,%bl
  8d:	02 74 08 00          	add    0x0(%eax,%ecx,1),%dh
  91:	00 02                	add    %al,(%edx)
  93:	02 00                	add    (%eax),%al
  95:	00 00                	add    %al,(%eax)
  97:	00 02                	add    %al,(%edx)
  99:	02 00                	add    (%eax),%al
  9b:	04 ec                	add    $0xec,%al
  9d:	04 92                	add    $0x92,%al
  9f:	05 02 91 08 04       	add    $0x4089102,%eax
  a4:	92                   	xchg   %eax,%edx
  a5:	05 9a 05 01 56       	add    $0x5601059a,%eax
  aa:	04 9a                	add    $0x9a,%al
  ac:	05 9b 05 02 74       	add    $0x7402059b,%eax
  b1:	00 04 9b             	add    %al,(%ebx,%ebx,4)
  b4:	05 a6 05 03 76       	add    $0x760305a6,%eax
  b9:	7f 9f                	jg     5a <PROT_MODE_DSEG+0x4a>
  bb:	04 a6                	add    $0xa6,%al
  bd:	05 b0 05 01 56       	add    $0x560105b0,%eax
  c2:	00 00                	add    %al,(%eax)
  c4:	00 00                	add    %al,(%eax)
  c6:	00 04 ec             	add    %al,(%esp,%ebp,8)
  c9:	04 b2                	add    $0xb2,%al
  cb:	05 02 91 0c 04       	add    $0x40c9102,%eax
  d0:	b2 05                	mov    $0x5,%dl
  d2:	b3 05                	mov    $0x5,%bl
  d4:	02 74 10 00          	add    0x0(%eax,%edx,1),%dh
  d8:	00 00                	add    %al,(%eax)
  da:	00 00                	add    %al,(%eax)
  dc:	00 00                	add    %al,(%eax)
  de:	04 92                	add    $0x92,%al
  e0:	05 b1 05 01 57       	add    $0x570105b1,%eax
  e5:	04 b1                	add    $0xb1,%al
  e7:	05 b2 05 0e 91       	add    $0x910e05b2,%eax
  ec:	00 06                	add    %al,(%esi)
  ee:	0c ff                	or     $0xff,%al
  f0:	ff                   	(bad)
  f1:	ff 00                	incl   (%eax)
  f3:	1a 91 04 06 22 9f    	sbb    -0x60ddf9fc(%ecx),%dl
  f9:	04 b2                	add    $0xb2,%al
  fb:	05 b3 05 0e 91       	add    $0x910e05b3,%eax
 100:	00 06                	add    %al,(%esi)
 102:	0c ff                	or     $0xff,%al
 104:	ff                   	(bad)
 105:	ff 00                	incl   (%eax)
 107:	1a 74 08 06          	sbb    0x6(%eax,%ecx,1),%dh
 10b:	22 9f 00 01 01 04    	and    0x4010100(%edi),%bl
 111:	89 04 8c             	mov    %eax,(%esp,%ecx,4)
 114:	04 04                	add    $0x4,%al
 116:	0a f7                	or     %bh,%dh
 118:	01 9f 00 00 01 04    	add    %ebx,0x4010000(%edi)
 11e:	8c 04 8c             	mov    %es,(%esp,%ecx,4)
 121:	04 01                	add    $0x1,%al
 123:	50                   	push   %eax
 124:	00 01                	add    %al,(%ecx)
 126:	00 04 93             	add    %al,(%ebx,%edx,4)
 129:	04 9b                	add    $0x9b,%al
 12b:	04 04                	add    $0x4,%al
 12d:	0a f2                	or     %dl,%dh
 12f:	01 9f 00 01 00 04    	add    %ebx,0x4000100(%edi)
 135:	93                   	xchg   %eax,%ebx
 136:	04 9b                	add    $0x9b,%al
 138:	04 02                	add    $0x2,%al
 13a:	31 9f 00 02 00 04    	xor    %ebx,0x4000200(%edi)
 140:	9b                   	fwait
 141:	04 a3                	add    $0xa3,%al
 143:	04 04                	add    $0x4,%al
 145:	0a f3                	or     %bl,%dh
 147:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 14d:	9b                   	fwait
 14e:	04 a3                	add    $0xa3,%al
 150:	04 01                	add    $0x1,%al
 152:	51                   	push   %ecx
 153:	00 02                	add    %al,(%edx)
 155:	00 04 a3             	add    %al,(%ebx,%eiz,4)
 158:	04 ae                	add    $0xae,%al
 15a:	04 04                	add    $0x4,%al
 15c:	0a f4                	or     %ah,%dh
 15e:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 164:	a3 04 ae 04 02       	mov    %eax,0x204ae04
 169:	91                   	xchg   %eax,%ecx
 16a:	05 00 02 00 04       	add    $0x4000200,%eax
 16f:	ae                   	scas   %es:(%edi),%al
 170:	04 b9                	add    $0xb9,%al
 172:	04 04                	add    $0x4,%al
 174:	0a f5                	or     %ch,%dh
 176:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 17c:	ae                   	scas   %es:(%edi),%al
 17d:	04 b9                	add    $0xb9,%al
 17f:	04 02                	add    $0x2,%al
 181:	91                   	xchg   %eax,%ecx
 182:	06                   	push   %es
 183:	00 02                	add    %al,(%edx)
 185:	00 04 b9             	add    %al,(%ecx,%edi,4)
 188:	04 c7                	add    $0xc7,%al
 18a:	04 04                	add    $0x4,%al
 18c:	0a f6                	or     %dh,%dh
 18e:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 194:	b9 04 c7 04 08       	mov    $0x804c704,%ecx
 199:	91                   	xchg   %eax,%ecx
 19a:	07                   	pop    %es
 19b:	94                   	xchg   %eax,%esp
 19c:	01 09                	add    %ecx,(%ecx)
 19e:	e0 21                	loopne 1c1 <PR_BOOTABLE+0x141>
 1a0:	9f                   	lahf
 1a1:	00 02                	add    %al,(%edx)
 1a3:	00 04 c7             	add    %al,(%edi,%eax,8)
 1a6:	04 cc                	add    $0xcc,%al
 1a8:	04 04                	add    $0x4,%al
 1aa:	0a f7                	or     %bh,%dh
 1ac:	01 9f 00 02 00 04    	add    %ebx,0x4000200(%edi)
 1b2:	c7 04 cc 04 03 08 20 	movl   $0x20080304,(%esp,%ecx,8)
 1b9:	9f                   	lahf
 1ba:	00 01                	add    %al,(%ecx)
 1bc:	01 04 d1             	add    %eax,(%ecx,%edx,8)
 1bf:	04 d2                	add    $0xd2,%al
 1c1:	04 04                	add    $0x4,%al
 1c3:	0a f7                	or     %bh,%dh
 1c5:	01 9f 00 00 01 04    	add    %ebx,0x4010000(%edi)
 1cb:	d2 04 d2             	rolb   %cl,(%edx,%edx,8)
 1ce:	04 01                	add    $0x1,%al
 1d0:	50                   	push   %eax
 1d1:	00 01                	add    %al,(%ecx)
 1d3:	00 04 d9             	add    %al,(%ecx,%ebx,8)
 1d6:	04 e9                	add    $0xe9,%al
 1d8:	04 04                	add    $0x4,%al
 1da:	0a f0                	or     %al,%dh
 1dc:	01 9f 00 01 00 04    	add    %ebx,0x4000100(%edi)
 1e2:	d9 04 e9             	flds   (%ecx,%ebp,8)
 1e5:	04 02                	add    $0x2,%al
 1e7:	91                   	xchg   %eax,%ecx
 1e8:	00 00                	add    %al,(%eax)
 1ea:	01 00                	add    %eax,(%eax)
 1ec:	04 d9                	add    $0xd9,%al
 1ee:	04 e9                	add    $0xe9,%al
 1f0:	04 03                	add    $0x3,%al
 1f2:	08 80 9f 00 00 00    	or     %al,0x9f(%eax)
 1f8:	00 00                	add    %al,(%eax)
 1fa:	04 a5                	add    $0xa5,%al
 1fc:	03 cd                	add    %ebp,%ecx
 1fe:	03 02                	add    (%edx),%eax
 200:	91                   	xchg   %eax,%ecx
 201:	04 04                	add    $0x4,%al
 203:	cd 03                	int    $0x3
 205:	ce                   	into
 206:	03 02                	add    (%edx),%eax
 208:	74 08                	je     212 <PR_BOOTABLE+0x192>
 20a:	00 00                	add    %al,(%eax)
 20c:	00 00                	add    %al,(%eax)
 20e:	00 04 fc             	add    %al,(%esp,%edi,8)
 211:	02 a4 03 02 91 04 04 	add    0x4049102(%ebx,%eax,1),%ah
 218:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 219:	03 a5 03 02 74 08    	add    0x8740203(%ebp),%esp
 21f:	00 00                	add    %al,(%eax)
 221:	00 00                	add    %al,(%eax)
 223:	00 04 a5 02 c6 02 02 	add    %al,0x202c602(,%eiz,4)
 22a:	91                   	xchg   %eax,%ecx
 22b:	00 04 c6             	add    %al,(%esi,%eax,8)
 22e:	02 fb                	add    %bl,%bh
 230:	02 01                	add    (%ecx),%al
 232:	50                   	push   %eax
 233:	00 00                	add    %al,(%eax)
 235:	00 00                	add    %al,(%eax)
 237:	00 00                	add    %al,(%eax)
 239:	00 04 c6             	add    %al,(%esi,%eax,8)
 23c:	02 e2                	add    %dl,%ah
 23e:	02 01                	add    (%ecx),%al
 240:	51                   	push   %ecx
 241:	04 e2                	add    $0xe2,%al
 243:	02 e9                	add    %cl,%ch
 245:	02 01                	add    (%ecx),%al
 247:	52                   	push   %edx
 248:	04 e9                	add    $0xe9,%al
 24a:	02 fb                	add    %bl,%bh
 24c:	02 01                	add    (%ecx),%al
 24e:	51                   	push   %ecx
 24f:	00 00                	add    %al,(%eax)
 251:	00 04 b1             	add    %al,(%ecx,%esi,4)
 254:	02 f5                	add    %ch,%dh
 256:	02 01                	add    (%ecx),%al
 258:	56                   	push   %esi
 259:	00 04 00             	add    %al,(%eax,%eax,1)
 25c:	00 00                	add    %al,(%eax)
 25e:	00 01                	add    %al,(%ecx)
 260:	01 00                	add    %eax,(%eax)
 262:	04 f0                	add    $0xf0,%al
 264:	01 87 02 02 30 9f    	add    %eax,-0x60cffdfe(%edi)
 26a:	04 87                	add    $0x87,%al
 26c:	02 98 02 01 52 04    	add    0x4520102(%eax),%bl
 272:	98                   	cwtl
 273:	02 9b 02 03 72 7f    	add    0x7f720302(%ebx),%bl
 279:	9f                   	lahf
 27a:	04 9b                	add    $0x9b,%al
 27c:	02 a5 02 01 52 00    	add    0x520102(%ebp),%ah
 282:	00 00                	add    %al,(%eax)
 284:	00 00                	add    %al,(%eax)
 286:	00 00                	add    %al,(%eax)
 288:	04 87                	add    $0x87,%al
 28a:	02 9c 02 01 50 04 9c 	add    -0x63fbafff(%edx,%eax,1),%bl
 291:	02 9e 02 03 70 01    	add    0x1700302(%esi),%bl
 297:	9f                   	lahf
 298:	04 9e                	add    $0x9e,%al
 29a:	02 a5 02 01 50 00    	add    0x500102(%ebp),%ah
 2a0:	00 00                	add    %al,(%eax)
 2a2:	04 8f                	add    $0x8f,%al
 2a4:	02 9e 02 01 56 00    	add    0x560102(%esi),%bl
 2aa:	00 00                	add    %al,(%eax)
 2ac:	00 00                	add    %al,(%eax)
 2ae:	00 00                	add    %al,(%eax)
 2b0:	00 00                	add    %al,(%eax)
 2b2:	04 dd                	add    $0xdd,%al
 2b4:	01 e5                	add    %esp,%ebp
 2b6:	01 02                	add    %eax,(%edx)
 2b8:	91                   	xchg   %eax,%ecx
 2b9:	00 04 e5 01 ec 01 07 	add    %al,0x701ec01(,%eiz,8)
 2c0:	91                   	xchg   %eax,%ecx
 2c1:	00 06                	add    %al,(%esi)
 2c3:	70 00                	jo     2c5 <PR_BOOTABLE+0x245>
 2c5:	22 9f 04 ec 01 ee    	and    -0x11fe13fc(%edi),%bl
 2cb:	01 09                	add    %ecx,(%ecx)
 2cd:	91                   	xchg   %eax,%ecx
 2ce:	00 06                	add    %al,(%esi)
 2d0:	70 00                	jo     2d2 <PR_BOOTABLE+0x252>
 2d2:	22 31                	and    (%ecx),%dh
 2d4:	1c 9f                	sbb    $0x9f,%al
 2d6:	04 ee                	add    $0xee,%al
 2d8:	01 f0                	add    %esi,%eax
 2da:	01 07                	add    %eax,(%edi)
 2dc:	91                   	xchg   %eax,%ecx
 2dd:	00 06                	add    %al,(%esi)
 2df:	70 00                	jo     2e1 <PR_BOOTABLE+0x261>
 2e1:	22 9f 00 03 00 00    	and    0x300(%edi),%bl
 2e7:	00 04 dd 01 e5 01 02 	add    %al,0x201e501(,%ebx,8)
 2ee:	30 9f 04 e5 01 f0    	xor    %bl,-0xffe1afc(%edi)
 2f4:	01 01                	add    %eax,(%ecx)
 2f6:	50                   	push   %eax
 2f7:	00 00                	add    %al,(%eax)
 2f9:	00 04 ce             	add    %al,(%esi,%ecx,8)
 2fc:	03 f4                	add    %esp,%esi
 2fe:	03 02                	add    (%edx),%eax
 300:	91                   	xchg   %eax,%ecx
 301:	00 00                	add    %al,(%eax)
 303:	00 00                	add    %al,(%eax)
 305:	00 00                	add    %al,(%eax)
 307:	04 26                	add    $0x26,%al
 309:	5f                   	pop    %edi
 30a:	02 91 04 04 5f 60    	add    0x605f0404(%ecx),%dl
 310:	02 74 08 00          	add    0x0(%eax,%ecx,1),%dh
 314:	00 00                	add    %al,(%eax)
 316:	00 00                	add    %al,(%eax)
 318:	04 26                	add    $0x26,%al
 31a:	5f                   	pop    %edi
 31b:	02 91 08 04 5f 60    	add    0x605f0408(%ecx),%dl
 321:	02 74 0c 00          	add    0x0(%esp,%ecx,1),%dh
 325:	00 00                	add    %al,(%eax)
 327:	00 01                	add    %al,(%ecx)
 329:	01 00                	add    %eax,(%eax)
 32b:	00 00                	add    %al,(%eax)
 32d:	00 00                	add    %al,(%eax)
 32f:	00 00                	add    %al,(%eax)
 331:	00 00                	add    %al,(%eax)
 333:	04 26                	add    $0x26,%al
 335:	37                   	aaa
 336:	02 91 0c 04 37 44    	add    0x4437040c(%ecx),%dl
 33c:	0a 91 0c 06 70 00    	or     0x70060c(%ecx),%dl
 342:	22 76 00             	and    0x0(%esi),%dh
 345:	1c 9f                	sbb    $0x9f,%al
 347:	04 44                	add    $0x44,%al
 349:	51                   	push   %ecx
 34a:	0c 91                	or     $0x91,%al
 34c:	0c 06                	or     $0x6,%al
 34e:	70 00                	jo     350 <PR_BOOTABLE+0x2d0>
 350:	22 76 00             	and    0x0(%esi),%dh
 353:	1c 23                	sbb    $0x23,%al
 355:	01 9f 04 51 59 0a    	add    %ebx,0xa595104(%edi)
 35b:	91                   	xchg   %eax,%ecx
 35c:	0c 06                	or     $0x6,%al
 35e:	73 00                	jae    360 <PR_BOOTABLE+0x2e0>
 360:	22 76 00             	and    0x0(%esi),%dh
 363:	1c 9f                	sbb    $0x9f,%al
 365:	04 59                	add    $0x59,%al
 367:	5e                   	pop    %esi
 368:	0a 91 0c 06 70 00    	or     0x70060c(%ecx),%dl
 36e:	22 76 00             	and    0x0(%esi),%dh
 371:	1c 9f                	sbb    $0x9f,%al
 373:	04 5e                	add    $0x5e,%al
 375:	5f                   	pop    %edi
 376:	12 91 0c 06 91 00    	adc    0x91060c(%ecx),%dl
 37c:	06                   	push   %es
 37d:	08 50 1e             	or     %dl,0x1e(%eax)
 380:	1c 70                	sbb    $0x70,%al
 382:	00 22                	add    %ah,(%edx)
 384:	91                   	xchg   %eax,%ecx
 385:	04 06                	add    $0x6,%al
 387:	1c 9f                	sbb    $0x9f,%al
 389:	04 5f                	add    $0x5f,%al
 38b:	60                   	pusha
 38c:	12 74 10 06          	adc    0x6(%eax,%edx,1),%dh
 390:	91                   	xchg   %eax,%ecx
 391:	00 06                	add    %al,(%esi)
 393:	08 50 1e             	or     %dl,0x1e(%eax)
 396:	1c 70                	sbb    $0x70,%al
 398:	00 22                	add    %ah,(%edx)
 39a:	74 08                	je     3a4 <PR_BOOTABLE+0x324>
 39c:	06                   	push   %es
 39d:	1c 9f                	sbb    $0x9f,%al
 39f:	00 00                	add    %al,(%eax)
 3a1:	00 00                	add    %al,(%eax)
 3a3:	00 00                	add    %al,(%eax)
 3a5:	00 00                	add    %al,(%eax)
 3a7:	00 04 35 37 01 56 04 	add    %al,0x4560137(,%esi,1)
 3ae:	37                   	aaa
 3af:	4a                   	dec    %edx
 3b0:	01 50 04             	add    %edx,0x4(%eax)
 3b3:	4a                   	dec    %edx
 3b4:	59                   	pop    %ecx
 3b5:	01 53 04             	add    %edx,0x4(%ebx)
 3b8:	59                   	pop    %ecx
 3b9:	60                   	pusha
 3ba:	01 50 00             	add    %edx,0x0(%eax)
 3bd:	00 00                	add    %al,(%eax)
 3bf:	04 19                	add    $0x19,%al
 3c1:	26 01 50 00          	add    %edx,%es:0x0(%eax)
 3c5:	29 01                	sub    %eax,(%ecx)
 3c7:	00 00                	add    %al,(%eax)
 3c9:	05 00 04 00 00       	add    $0x400,%eax
 3ce:	00 00                	add    %al,(%eax)
 3d0:	00 00                	add    %al,(%eax)
 3d2:	00 00                	add    %al,(%eax)
 3d4:	00 00                	add    %al,(%eax)
 3d6:	01 00                	add    %eax,(%eax)
 3d8:	00 00                	add    %al,(%eax)
 3da:	00 00                	add    %al,(%eax)
 3dc:	00 04 a8             	add    %al,(%eax,%ebp,4)
 3df:	01 b7 01 01 57 04    	add    %esi,0x4570101(%edi)
 3e5:	b7 01                	mov    $0x1,%bh
 3e7:	c8 01 06 77          	enter  $0x601,$0x77
 3eb:	00 76 00             	add    %dh,0x0(%esi)
 3ee:	22 9f 04 c8 01 ce    	and    -0x31fe37fc(%edi),%bl
 3f4:	01 08                	add    %ecx,(%eax)
 3f6:	77 00                	ja     3f8 <PR_BOOTABLE+0x378>
 3f8:	76 00                	jbe    3fa <PR_BOOTABLE+0x37a>
 3fa:	22 48 1c             	and    0x1c(%eax),%cl
 3fd:	9f                   	lahf
 3fe:	04 d3                	add    $0xd3,%al
 400:	01 83 02 06 77 00    	add    %eax,0x770602(%ebx)
 406:	76 00                	jbe    408 <PR_BOOTABLE+0x388>
 408:	22 9f 04 83 02 84    	and    -0x7bfd7cfc(%edi),%bl
 40e:	02 0a                	add    (%edx),%cl
 410:	77 00                	ja     412 <PR_BOOTABLE+0x392>
 412:	03 cc                	add    %esp,%ecx
 414:	93                   	xchg   %eax,%ebx
 415:	00 00                	add    %al,(%eax)
 417:	06                   	push   %es
 418:	22 9f 04 84 02 86    	and    -0x79fd7bfc(%edi),%bl
 41e:	02 0b                	add    (%ebx),%cl
 420:	91                   	xchg   %eax,%ecx
 421:	00 06                	add    %al,(%esi)
 423:	03 cc                	add    %esp,%ecx
 425:	93                   	xchg   %eax,%ebx
 426:	00 00                	add    %al,(%eax)
 428:	06                   	push   %es
 429:	22 9f 00 01 00 00    	and    0x100(%edi),%bl
 42f:	00 00                	add    %al,(%eax)
 431:	02 02                	add    (%edx),%al
 433:	00 00                	add    %al,(%eax)
 435:	00 04 a8             	add    %al,(%eax,%ebp,4)
 438:	01 b7 01 02 30 9f    	add    %esi,-0x60cffdff(%edi)
 43e:	04 b7                	add    $0xb7,%al
 440:	01 c8                	add    %ecx,%eax
 442:	01 01                	add    %eax,(%ecx)
 444:	56                   	push   %esi
 445:	04 c8                	add    $0xc8,%al
 447:	01 ce                	add    %ecx,%esi
 449:	01 03                	add    %eax,(%ebx)
 44b:	76 68                	jbe    4b5 <PR_BOOTABLE+0x435>
 44d:	9f                   	lahf
 44e:	04 ce                	add    $0xce,%al
 450:	01 83 02 01 56 04    	add    %eax,0x4560102(%ebx)
 456:	83 02 86             	addl   $0xffffff86,(%edx)
 459:	02 05 03 cc 93 00    	add    0x93cc03,%al
 45f:	00 00                	add    %al,(%eax)
 461:	00 00                	add    %al,(%eax)
 463:	00 01                	add    %al,(%ecx)
 465:	01 00                	add    %eax,(%eax)
 467:	04 5b                	add    $0x5b,%al
 469:	6a 01                	push   $0x1
 46b:	57                   	push   %edi
 46c:	04 6a                	add    $0x6a,%al
 46e:	78 03                	js     473 <PR_BOOTABLE+0x3f3>
 470:	77 60                	ja     4d2 <PR_BOOTABLE+0x452>
 472:	9f                   	lahf
 473:	04 78                	add    $0x78,%al
 475:	8d 01                	lea    (%ecx),%eax
 477:	01 57 00             	add    %edx,0x0(%edi)
 47a:	00 00                	add    %al,(%eax)
 47c:	04 60                	add    $0x60,%al
 47e:	87 01                	xchg   %eax,(%ecx)
 480:	01 56 00             	add    %edx,0x0(%esi)
 483:	00 00                	add    %al,(%eax)
 485:	00 00                	add    %al,(%eax)
 487:	04 86                	add    $0x86,%al
 489:	02 bf 03 02 91 04    	add    0x4910203(%edi),%bh
 48f:	04 bf                	add    $0xbf,%al
 491:	03 c0                	add    %eax,%eax
 493:	03 02                	add    (%edx),%eax
 495:	74 08                	je     49f <PR_BOOTABLE+0x41f>
 497:	00 00                	add    %al,(%eax)
 499:	00 00                	add    %al,(%eax)
 49b:	00 04 86             	add    %al,(%esi,%eax,4)
 49e:	02 bf 03 02 91 08    	add    0x8910203(%edi),%bh
 4a4:	04 bf                	add    $0xbf,%al
 4a6:	03 c0                	add    %eax,%eax
 4a8:	03 02                	add    (%edx),%eax
 4aa:	74 0c                	je     4b8 <PR_BOOTABLE+0x438>
 4ac:	00 03                	add    %al,(%ebx)
 4ae:	00 00                	add    %al,(%eax)
 4b0:	00 04 b1             	add    %al,(%ecx,%esi,4)
 4b3:	02 b6 02 02 30 9f    	add    -0x60cffdfe(%esi),%dh
 4b9:	04 b6                	add    $0xb6,%al
 4bb:	02 dd                	add    %ch,%bl
 4bd:	02 01                	add    (%ecx),%al
 4bf:	50                   	push   %eax
 4c0:	00 02                	add    %al,(%edx)
 4c2:	00 00                	add    %al,(%eax)
 4c4:	00 00                	add    %al,(%eax)
 4c6:	00 04 b1             	add    %al,(%ecx,%esi,4)
 4c9:	02 cc                	add    %ah,%cl
 4cb:	02 02                	add    (%edx),%al
 4cd:	30 9f 04 cc 02 ce    	xor    %bl,-0x31fd33fc(%edi)
 4d3:	02 01                	add    (%ecx),%al
 4d5:	56                   	push   %esi
 4d6:	04 ce                	add    $0xce,%al
 4d8:	02 e8                	add    %al,%ch
 4da:	02 02                	add    (%edx),%al
 4dc:	30 9f 00 00 00 00    	xor    %bl,0x0(%edi)
 4e2:	00 04 8b             	add    %al,(%ebx,%ecx,4)
 4e5:	03 91 03 01 50 04    	add    0x4500103(%ecx),%edx
 4eb:	91                   	xchg   %eax,%ecx
 4ec:	03 be 03 01 56 00    	add    0x560103(%esi),%edi

Disassembly of section .debug_rnglists:

00000000 <.debug_rnglists>:
   0:	5e                   	pop    %esi
   1:	00 00                	add    %al,(%eax)
   3:	00 05 00 04 00 00    	add    %al,0x400
   9:	00 00                	add    %al,(%eax)
   b:	00 04 fd 03 fd 03 04 	add    %al,0x403fd03(,%edi,8)
  12:	81 04 86 04 04 89 04 	addl   $0x4890404,(%esi,%eax,4)
  19:	93                   	xchg   %eax,%ebx
  1a:	04 00                	add    $0x0,%al
  1c:	04 81                	add    $0x81,%al
  1e:	04 86                	add    $0x86,%al
  20:	04 04                	add    $0x4,%al
  22:	89 04 8c             	mov    %eax,(%esp,%ecx,4)
  25:	04 00                	add    $0x0,%al
  27:	04 a3                	add    $0xa3,%al
  29:	04 a3                	add    $0xa3,%al
  2b:	04 04                	add    $0x4,%al
  2d:	a5                   	movsl  %ds:(%esi),%es:(%edi)
  2e:	04 aa                	add    $0xaa,%al
  30:	04 04                	add    $0x4,%al
  32:	ad                   	lods   %ds:(%esi),%eax
  33:	04 ae                	add    $0xae,%al
  35:	04 00                	add    $0x0,%al
  37:	04 ae                	add    $0xae,%al
  39:	04 ae                	add    $0xae,%al
  3b:	04 04                	add    $0x4,%al
  3d:	b0 04                	mov    $0x4,%al
  3f:	b5 04                	mov    $0x4,%ch
  41:	04 b8                	add    $0xb8,%al
  43:	04 b9                	add    $0xb9,%al
  45:	04 00                	add    $0x0,%al
  47:	04 b9                	add    $0xb9,%al
  49:	04 b9                	add    $0xb9,%al
  4b:	04 04                	add    $0x4,%al
  4d:	bb 04 c0 04 04       	mov    $0x404c004,%ebx
  52:	c6 04 c7 04          	movb   $0x4,(%edi,%eax,8)
  56:	00 04 cc             	add    %al,(%esp,%ecx,8)
  59:	04 d1                	add    $0xd1,%al
  5b:	04 04                	add    $0x4,%al
  5d:	d1 04 d2             	roll   $1,(%edx,%edx,8)
  60:	04 00                	add    $0x0,%al
