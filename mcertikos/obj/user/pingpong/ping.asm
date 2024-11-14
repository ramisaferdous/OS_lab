
obj/user/pingpong/ping:     file format elf32-i386


Disassembly of section .text:

40000000 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary.
	 */
	testl	$0x0fffffff, %esp
40000000:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000006:	75 04                	jne    4000000c <args_exist>

40000008 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000008:	6a 00                	push   $0x0
	pushl	$0
4000000a:	6a 00                	push   $0x0

4000000c <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000000c:	e8 94 0c 00 00       	call   40000ca5 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000011:	50                   	push   %eax

40000012 <spin>:
spin:
	/*
	 * TODO: replace yield with exit
	 */
	call	yield
40000012:	e8 04 08 00 00       	call   4000081b <yield>
	jmp	spin
40000017:	eb f9                	jmp    40000012 <spin>

40000019 <debug>:
#include <proc.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char *file, int line, const char *fmt, ...)
{
40000019:	53                   	push   %ebx
4000001a:	83 ec 0c             	sub    $0xc,%esp
4000001d:	e8 a7 00 00 00       	call   400000c9 <__x86.get_pc_thunk.bx>
40000022:	81 c3 d2 2f 00 00    	add    $0x2fd2,%ebx
    va_list ap;
    va_start(ap, fmt);
    printf("[D] %s:%d: ", file, line);
40000028:	ff 74 24 18          	push   0x18(%esp)
4000002c:	ff 74 24 18          	push   0x18(%esp)
40000030:	8d 83 0c e0 ff ff    	lea    -0x1ff4(%ebx),%eax
40000036:	50                   	push   %eax
40000037:	e8 e5 01 00 00       	call   40000221 <printf>
    vcprintf(fmt, ap);
4000003c:	83 c4 08             	add    $0x8,%esp
4000003f:	8d 44 24 24          	lea    0x24(%esp),%eax
40000043:	50                   	push   %eax
40000044:	ff 74 24 24          	push   0x24(%esp)
40000048:	e8 73 01 00 00       	call   400001c0 <vcprintf>
    va_end(ap);
}
4000004d:	83 c4 18             	add    $0x18,%esp
40000050:	5b                   	pop    %ebx
40000051:	c3                   	ret

40000052 <warn>:

void warn(const char *file, int line, const char *fmt, ...)
{
40000052:	53                   	push   %ebx
40000053:	83 ec 0c             	sub    $0xc,%esp
40000056:	e8 6e 00 00 00       	call   400000c9 <__x86.get_pc_thunk.bx>
4000005b:	81 c3 99 2f 00 00    	add    $0x2f99,%ebx
    va_list ap;
    va_start(ap, fmt);
    printf("[W] %s:%d: ", file, line);
40000061:	ff 74 24 18          	push   0x18(%esp)
40000065:	ff 74 24 18          	push   0x18(%esp)
40000069:	8d 83 18 e0 ff ff    	lea    -0x1fe8(%ebx),%eax
4000006f:	50                   	push   %eax
40000070:	e8 ac 01 00 00       	call   40000221 <printf>
    vcprintf(fmt, ap);
40000075:	83 c4 08             	add    $0x8,%esp
40000078:	8d 44 24 24          	lea    0x24(%esp),%eax
4000007c:	50                   	push   %eax
4000007d:	ff 74 24 24          	push   0x24(%esp)
40000081:	e8 3a 01 00 00       	call   400001c0 <vcprintf>
    va_end(ap);
}
40000086:	83 c4 18             	add    $0x18,%esp
40000089:	5b                   	pop    %ebx
4000008a:	c3                   	ret

4000008b <panic>:

void panic(const char *file, int line, const char *fmt, ...)
{
4000008b:	53                   	push   %ebx
4000008c:	83 ec 0c             	sub    $0xc,%esp
4000008f:	e8 35 00 00 00       	call   400000c9 <__x86.get_pc_thunk.bx>
40000094:	81 c3 60 2f 00 00    	add    $0x2f60,%ebx
    va_list ap;
    va_start(ap, fmt);
    printf("[P] %s:%d: ", file, line);
4000009a:	ff 74 24 18          	push   0x18(%esp)
4000009e:	ff 74 24 18          	push   0x18(%esp)
400000a2:	8d 83 24 e0 ff ff    	lea    -0x1fdc(%ebx),%eax
400000a8:	50                   	push   %eax
400000a9:	e8 73 01 00 00       	call   40000221 <printf>
    vcprintf(fmt, ap);
400000ae:	83 c4 08             	add    $0x8,%esp
400000b1:	8d 44 24 24          	lea    0x24(%esp),%eax
400000b5:	50                   	push   %eax
400000b6:	ff 74 24 24          	push   0x24(%esp)
400000ba:	e8 01 01 00 00       	call   400001c0 <vcprintf>
400000bf:	83 c4 10             	add    $0x10,%esp
    va_end(ap);

    while (1)
        yield();
400000c2:	e8 54 07 00 00       	call   4000081b <yield>
    while (1)
400000c7:	eb f9                	jmp    400000c2 <panic+0x37>

400000c9 <__x86.get_pc_thunk.bx>:
400000c9:	8b 1c 24             	mov    (%esp),%ebx
400000cc:	c3                   	ret
400000cd:	66 90                	xchg   %ax,%ax
400000cf:	66 90                	xchg   %ax,%ax
400000d1:	66 90                	xchg   %ax,%ax
400000d3:	66 90                	xchg   %ax,%ax
400000d5:	66 90                	xchg   %ax,%ax
400000d7:	66 90                	xchg   %ax,%ax
400000d9:	66 90                	xchg   %ax,%ax
400000db:	66 90                	xchg   %ax,%ax
400000dd:	66 90                	xchg   %ax,%ax
400000df:	66 90                	xchg   %ax,%ax
400000e1:	66 90                	xchg   %ax,%ax
400000e3:	66 90                	xchg   %ax,%ax
400000e5:	66 90                	xchg   %ax,%ax
400000e7:	66 90                	xchg   %ax,%ax
400000e9:	66 90                	xchg   %ax,%ax
400000eb:	66 90                	xchg   %ax,%ax
400000ed:	66 90                	xchg   %ax,%ax
400000ef:	66 90                	xchg   %ax,%ax
400000f1:	66 90                	xchg   %ax,%ax
400000f3:	66 90                	xchg   %ax,%ax
400000f5:	66 90                	xchg   %ax,%ax
400000f7:	66 90                	xchg   %ax,%ax
400000f9:	66 90                	xchg   %ax,%ax
400000fb:	66 90                	xchg   %ax,%ax
400000fd:	66 90                	xchg   %ax,%ax
400000ff:	90                   	nop

40000100 <atoi>:
#include <stdlib.h>

int atoi(const char *buf, int *i)
{
40000100:	55                   	push   %ebp
40000101:	57                   	push   %edi
40000102:	56                   	push   %esi
40000103:	53                   	push   %ebx
    int loc = 0;
    int numstart = 0;
    int acc = 0;
    int negative = 0;
    if (buf[loc] == '+')
40000104:	8b 44 24 14          	mov    0x14(%esp),%eax
40000108:	0f b6 00             	movzbl (%eax),%eax
4000010b:	3c 2b                	cmp    $0x2b,%al
4000010d:	74 17                	je     40000126 <atoi+0x26>
        loc++;
    else if (buf[loc] == '-') {
4000010f:	3c 2d                	cmp    $0x2d,%al
40000111:	74 1f                	je     40000132 <atoi+0x32>
    int negative = 0;
40000113:	bf 00 00 00 00       	mov    $0x0,%edi
    int loc = 0;
40000118:	be 00 00 00 00       	mov    $0x0,%esi
        negative = 1;
        loc++;
    }
    numstart = loc;
    // no grab the numbers
    while ('0' <= buf[loc] && buf[loc] <= '9') {
4000011d:	89 f2                	mov    %esi,%edx
    int acc = 0;
4000011f:	b9 00 00 00 00       	mov    $0x0,%ecx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000124:	eb 2b                	jmp    40000151 <atoi+0x51>
    int negative = 0;
40000126:	bf 00 00 00 00       	mov    $0x0,%edi
        loc++;
4000012b:	be 01 00 00 00       	mov    $0x1,%esi
40000130:	eb eb                	jmp    4000011d <atoi+0x1d>
        negative = 1;
40000132:	bf 01 00 00 00       	mov    $0x1,%edi
        loc++;
40000137:	be 01 00 00 00       	mov    $0x1,%esi
4000013c:	eb df                	jmp    4000011d <atoi+0x1d>
4000013e:	66 90                	xchg   %ax,%ax
        acc = acc * 10 + (buf[loc] - '0');
40000140:	8d 2c 89             	lea    (%ecx,%ecx,4),%ebp
40000143:	8d 4c 2d 00          	lea    0x0(%ebp,%ebp,1),%ecx
40000147:	0f be c0             	movsbl %al,%eax
4000014a:	8d 4c 08 d0          	lea    -0x30(%eax,%ecx,1),%ecx
        loc++;
4000014e:	83 c2 01             	add    $0x1,%edx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000151:	8b 44 24 14          	mov    0x14(%esp),%eax
40000155:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
40000159:	8d 68 d0             	lea    -0x30(%eax),%ebp
4000015c:	89 eb                	mov    %ebp,%ebx
4000015e:	80 fb 09             	cmp    $0x9,%bl
40000161:	76 dd                	jbe    40000140 <atoi+0x40>
    }
    if (numstart == loc) {
40000163:	39 d6                	cmp    %edx,%esi
40000165:	74 13                	je     4000017a <atoi+0x7a>
        // no numbers have actually been scanned
        return 0;
    }
    if (negative)
40000167:	85 ff                	test   %edi,%edi
40000169:	74 02                	je     4000016d <atoi+0x6d>
        acc = -acc;
4000016b:	f7 d9                	neg    %ecx
    *i = acc;
4000016d:	8b 44 24 18          	mov    0x18(%esp),%eax
40000171:	89 08                	mov    %ecx,(%eax)
    return loc;
}
40000173:	89 d0                	mov    %edx,%eax
40000175:	5b                   	pop    %ebx
40000176:	5e                   	pop    %esi
40000177:	5f                   	pop    %edi
40000178:	5d                   	pop    %ebp
40000179:	c3                   	ret
        return 0;
4000017a:	ba 00 00 00 00       	mov    $0x0,%edx
4000017f:	eb f2                	jmp    40000173 <atoi+0x73>

40000181 <putch>:
    int cnt;            // total bytes printed so far
    char buf[MAX_BUF];
};

static void putch(int ch, struct printbuf *b)
{
40000181:	53                   	push   %ebx
40000182:	8b 54 24 0c          	mov    0xc(%esp),%edx
    b->buf[b->idx++] = ch;
40000186:	8b 02                	mov    (%edx),%eax
40000188:	8d 48 01             	lea    0x1(%eax),%ecx
4000018b:	89 0a                	mov    %ecx,(%edx)
4000018d:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
40000192:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
    if (b->idx == MAX_BUF - 1) {
40000196:	81 f9 ff 01 00 00    	cmp    $0x1ff,%ecx
4000019c:	74 0b                	je     400001a9 <putch+0x28>
        b->buf[b->idx] = 0;
        puts(b->buf, b->idx);
        b->idx = 0;
    }
    b->cnt++;
4000019e:	8b 42 04             	mov    0x4(%edx),%eax
400001a1:	83 c0 01             	add    $0x1,%eax
400001a4:	89 42 04             	mov    %eax,0x4(%edx)
}
400001a7:	5b                   	pop    %ebx
400001a8:	c3                   	ret
        b->buf[b->idx] = 0;
400001a9:	c6 44 02 09 00       	movb   $0x0,0x9(%edx,%eax,1)
        puts(b->buf, b->idx);
400001ae:	8d 5a 08             	lea    0x8(%edx),%ebx
#include <types.h>
#include <x86.h>

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
400001b1:	b8 00 00 00 00       	mov    $0x0,%eax
400001b6:	cd 30                	int    $0x30
        b->idx = 0;
400001b8:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
400001be:	eb de                	jmp    4000019e <putch+0x1d>

400001c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
400001c0:	53                   	push   %ebx
400001c1:	81 ec 18 02 00 00    	sub    $0x218,%esp
400001c7:	e8 fd fe ff ff       	call   400000c9 <__x86.get_pc_thunk.bx>
400001cc:	81 c3 28 2e 00 00    	add    $0x2e28,%ebx
    struct printbuf b;

    b.idx = 0;
400001d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
400001d9:	00 
    b.cnt = 0;
400001da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400001e1:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
400001e2:	ff b4 24 24 02 00 00 	push   0x224(%esp)
400001e9:	ff b4 24 24 02 00 00 	push   0x224(%esp)
400001f0:	8d 44 24 10          	lea    0x10(%esp),%eax
400001f4:	50                   	push   %eax
400001f5:	8d 83 8d d1 ff ff    	lea    -0x2e73(%ebx),%eax
400001fb:	50                   	push   %eax
400001fc:	e8 86 01 00 00       	call   40000387 <vprintfmt>

    b.buf[b.idx] = 0;
40000201:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000205:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
4000020a:	8d 5c 24 20          	lea    0x20(%esp),%ebx
4000020e:	b8 00 00 00 00       	mov    $0x0,%eax
40000213:	cd 30                	int    $0x30
    puts(b.buf, b.idx);

    return b.cnt;
}
40000215:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000219:	81 c4 28 02 00 00    	add    $0x228,%esp
4000021f:	5b                   	pop    %ebx
40000220:	c3                   	ret

40000221 <printf>:

int printf(const char *fmt, ...)
{
40000221:	83 ec 14             	sub    $0x14,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
    cnt = vcprintf(fmt, ap);
40000224:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000228:	50                   	push   %eax
40000229:	ff 74 24 1c          	push   0x1c(%esp)
4000022d:	e8 8e ff ff ff       	call   400001c0 <vcprintf>
    va_end(ap);

    return cnt;
}
40000232:	83 c4 1c             	add    $0x1c,%esp
40000235:	c3                   	ret
40000236:	66 90                	xchg   %ax,%ax
40000238:	66 90                	xchg   %ax,%ax
4000023a:	66 90                	xchg   %ax,%ax
4000023c:	66 90                	xchg   %ax,%ax
4000023e:	66 90                	xchg   %ax,%ax

40000240 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
40000240:	55                   	push   %ebp
40000241:	57                   	push   %edi
40000242:	56                   	push   %esi
40000243:	53                   	push   %ebx
40000244:	83 ec 2c             	sub    $0x2c,%esp
40000247:	e8 ac 05 00 00       	call   400007f8 <__x86.get_pc_thunk.cx>
4000024c:	81 c1 a8 2d 00 00    	add    $0x2da8,%ecx
40000252:	89 4c 24 14          	mov    %ecx,0x14(%esp)
40000256:	89 c6                	mov    %eax,%esi
40000258:	89 d7                	mov    %edx,%edi
4000025a:	8b 44 24 40          	mov    0x40(%esp),%eax
4000025e:	8b 54 24 44          	mov    0x44(%esp),%edx
40000262:	89 d1                	mov    %edx,%ecx
40000264:	89 c2                	mov    %eax,%edx
40000266:	89 44 24 18          	mov    %eax,0x18(%esp)
4000026a:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
4000026e:	8b 44 24 48          	mov    0x48(%esp),%eax
40000272:	8b 5c 24 4c          	mov    0x4c(%esp),%ebx
40000276:	8b 6c 24 50          	mov    0x50(%esp),%ebp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
4000027a:	89 44 24 08          	mov    %eax,0x8(%esp)
4000027e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000285:	00 
40000286:	39 c2                	cmp    %eax,%edx
40000288:	1b 4c 24 0c          	sbb    0xc(%esp),%ecx
4000028c:	72 42                	jb     400002d0 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
4000028e:	83 ec 0c             	sub    $0xc,%esp
40000291:	55                   	push   %ebp
40000292:	83 eb 01             	sub    $0x1,%ebx
40000295:	53                   	push   %ebx
40000296:	50                   	push   %eax
40000297:	83 ec 08             	sub    $0x8,%esp
4000029a:	ff 74 24 2c          	push   0x2c(%esp)
4000029e:	ff 74 24 2c          	push   0x2c(%esp)
400002a2:	ff 74 24 44          	push   0x44(%esp)
400002a6:	ff 74 24 44          	push   0x44(%esp)
400002aa:	8b 5c 24 44          	mov    0x44(%esp),%ebx
400002ae:	e8 8d 0a 00 00       	call   40000d40 <__udivdi3>
400002b3:	83 c4 18             	add    $0x18,%esp
400002b6:	52                   	push   %edx
400002b7:	50                   	push   %eax
400002b8:	89 fa                	mov    %edi,%edx
400002ba:	89 f0                	mov    %esi,%eax
400002bc:	e8 7f ff ff ff       	call   40000240 <printnum>
400002c1:	83 c4 20             	add    $0x20,%esp
400002c4:	eb 11                	jmp    400002d7 <printnum+0x97>
    } else {
        // print any needed pad characters before first digit
        while (--width > 0)
            putch(padc, putdat);
400002c6:	83 ec 08             	sub    $0x8,%esp
400002c9:	57                   	push   %edi
400002ca:	55                   	push   %ebp
400002cb:	ff d6                	call   *%esi
400002cd:	83 c4 10             	add    $0x10,%esp
        while (--width > 0)
400002d0:	83 eb 01             	sub    $0x1,%ebx
400002d3:	85 db                	test   %ebx,%ebx
400002d5:	7f ef                	jg     400002c6 <printnum+0x86>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
400002d7:	ff 74 24 0c          	push   0xc(%esp)
400002db:	ff 74 24 0c          	push   0xc(%esp)
400002df:	ff 74 24 24          	push   0x24(%esp)
400002e3:	ff 74 24 24          	push   0x24(%esp)
400002e7:	8b 5c 24 24          	mov    0x24(%esp),%ebx
400002eb:	e8 70 0b 00 00       	call   40000e60 <__umoddi3>
400002f0:	83 c4 08             	add    $0x8,%esp
400002f3:	57                   	push   %edi
400002f4:	0f be 84 03 30 e0 ff 	movsbl -0x1fd0(%ebx,%eax,1),%eax
400002fb:	ff 
400002fc:	50                   	push   %eax
400002fd:	ff d6                	call   *%esi
}
400002ff:	83 c4 3c             	add    $0x3c,%esp
40000302:	5b                   	pop    %ebx
40000303:	5e                   	pop    %esi
40000304:	5f                   	pop    %edi
40000305:	5d                   	pop    %ebp
40000306:	c3                   	ret

40000307 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long getuint(va_list * ap, int lflag)
{
    if (lflag >= 2)
40000307:	83 fa 01             	cmp    $0x1,%edx
4000030a:	7f 13                	jg     4000031f <getuint+0x18>
        return va_arg(*ap, unsigned long long);
    else if (lflag)
4000030c:	85 d2                	test   %edx,%edx
4000030e:	74 1c                	je     4000032c <getuint+0x25>
        return va_arg(*ap, unsigned long);
40000310:	8b 08                	mov    (%eax),%ecx
40000312:	8d 51 04             	lea    0x4(%ecx),%edx
40000315:	89 10                	mov    %edx,(%eax)
40000317:	8b 01                	mov    (%ecx),%eax
40000319:	ba 00 00 00 00       	mov    $0x0,%edx
4000031e:	c3                   	ret
        return va_arg(*ap, unsigned long long);
4000031f:	8b 08                	mov    (%eax),%ecx
40000321:	8d 51 08             	lea    0x8(%ecx),%edx
40000324:	89 10                	mov    %edx,(%eax)
40000326:	8b 01                	mov    (%ecx),%eax
40000328:	8b 51 04             	mov    0x4(%ecx),%edx
4000032b:	c3                   	ret
    else
        return va_arg(*ap, unsigned int);
4000032c:	8b 08                	mov    (%eax),%ecx
4000032e:	8d 51 04             	lea    0x4(%ecx),%edx
40000331:	89 10                	mov    %edx,(%eax)
40000333:	8b 01                	mov    (%ecx),%eax
40000335:	ba 00 00 00 00       	mov    $0x0,%edx
}
4000033a:	c3                   	ret

4000033b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long getint(va_list * ap, int lflag)
{
    if (lflag >= 2)
4000033b:	83 fa 01             	cmp    $0x1,%edx
4000033e:	7f 0f                	jg     4000034f <getint+0x14>
        return va_arg(*ap, long long);
    else if (lflag)
40000340:	85 d2                	test   %edx,%edx
40000342:	74 18                	je     4000035c <getint+0x21>
        return va_arg(*ap, long);
40000344:	8b 08                	mov    (%eax),%ecx
40000346:	8d 51 04             	lea    0x4(%ecx),%edx
40000349:	89 10                	mov    %edx,(%eax)
4000034b:	8b 01                	mov    (%ecx),%eax
4000034d:	99                   	cltd
4000034e:	c3                   	ret
        return va_arg(*ap, long long);
4000034f:	8b 08                	mov    (%eax),%ecx
40000351:	8d 51 08             	lea    0x8(%ecx),%edx
40000354:	89 10                	mov    %edx,(%eax)
40000356:	8b 01                	mov    (%ecx),%eax
40000358:	8b 51 04             	mov    0x4(%ecx),%edx
4000035b:	c3                   	ret
    else
        return va_arg(*ap, int);
4000035c:	8b 08                	mov    (%eax),%ecx
4000035e:	8d 51 04             	lea    0x4(%ecx),%edx
40000361:	89 10                	mov    %edx,(%eax)
40000363:	8b 01                	mov    (%ecx),%eax
40000365:	99                   	cltd
}
40000366:	c3                   	ret

40000367 <sprintputch>:
    char *ebuf;
    int cnt;
};

static void sprintputch(int ch, struct sprintbuf *b)
{
40000367:	8b 44 24 08          	mov    0x8(%esp),%eax
    b->cnt++;
4000036b:	8b 48 08             	mov    0x8(%eax),%ecx
4000036e:	8d 51 01             	lea    0x1(%ecx),%edx
40000371:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf)
40000374:	8b 10                	mov    (%eax),%edx
40000376:	3b 50 04             	cmp    0x4(%eax),%edx
40000379:	73 0b                	jae    40000386 <sprintputch+0x1f>
        *b->buf++ = ch;
4000037b:	8d 4a 01             	lea    0x1(%edx),%ecx
4000037e:	89 08                	mov    %ecx,(%eax)
40000380:	8b 44 24 04          	mov    0x4(%esp),%eax
40000384:	88 02                	mov    %al,(%edx)
}
40000386:	c3                   	ret

40000387 <vprintfmt>:
{
40000387:	55                   	push   %ebp
40000388:	57                   	push   %edi
40000389:	56                   	push   %esi
4000038a:	53                   	push   %ebx
4000038b:	83 ec 2c             	sub    $0x2c,%esp
4000038e:	e8 5d 04 00 00       	call   400007f0 <__x86.get_pc_thunk.ax>
40000393:	05 61 2c 00 00       	add    $0x2c61,%eax
40000398:	89 44 24 08          	mov    %eax,0x8(%esp)
4000039c:	8b 74 24 40          	mov    0x40(%esp),%esi
400003a0:	8b 7c 24 44          	mov    0x44(%esp),%edi
400003a4:	8b 6c 24 48          	mov    0x48(%esp),%ebp
400003a8:	eb 0c                	jmp    400003b6 <vprintfmt+0x2f>
            putch(ch, putdat);
400003aa:	83 ec 08             	sub    $0x8,%esp
400003ad:	57                   	push   %edi
400003ae:	50                   	push   %eax
400003af:	ff d6                	call   *%esi
400003b1:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
400003b4:	89 dd                	mov    %ebx,%ebp
400003b6:	8d 5d 01             	lea    0x1(%ebp),%ebx
400003b9:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
400003bd:	83 f8 25             	cmp    $0x25,%eax
400003c0:	74 0c                	je     400003ce <vprintfmt+0x47>
            if (ch == '\0')
400003c2:	85 c0                	test   %eax,%eax
400003c4:	75 e4                	jne    400003aa <vprintfmt+0x23>
}
400003c6:	83 c4 2c             	add    $0x2c,%esp
400003c9:	5b                   	pop    %ebx
400003ca:	5e                   	pop    %esi
400003cb:	5f                   	pop    %edi
400003cc:	5d                   	pop    %ebp
400003cd:	c3                   	ret
        padc = ' ';
400003ce:	c6 44 24 1b 20       	movb   $0x20,0x1b(%esp)
        altflag = 0;
400003d3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
400003da:	00 
        precision = -1;
400003db:	c7 44 24 10 ff ff ff 	movl   $0xffffffff,0x10(%esp)
400003e2:	ff 
        width = -1;
400003e3:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
400003ea:	ff 
        lflag = 0;
400003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
400003f0:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        switch (ch = *(unsigned char *) fmt++) {
400003f4:	8d 6b 01             	lea    0x1(%ebx),%ebp
400003f7:	0f b6 03             	movzbl (%ebx),%eax
400003fa:	0f b6 d0             	movzbl %al,%edx
400003fd:	89 14 24             	mov    %edx,(%esp)
40000400:	83 e8 23             	sub    $0x23,%eax
40000403:	3c 55                	cmp    $0x55,%al
40000405:	0f 87 d6 02 00 00    	ja     400006e1 <.L27>
4000040b:	0f b6 c0             	movzbl %al,%eax
4000040e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000412:	89 ca                	mov    %ecx,%edx
40000414:	03 94 81 58 e0 ff ff 	add    -0x1fa8(%ecx,%eax,4),%edx
4000041b:	ff e2                	jmp    *%edx

4000041d <.L25>:
4000041d:	89 eb                	mov    %ebp,%ebx
4000041f:	c6 44 24 1b 2d       	movb   $0x2d,0x1b(%esp)
40000424:	eb ce                	jmp    400003f4 <vprintfmt+0x6d>

40000426 <.L61>:
40000426:	89 eb                	mov    %ebp,%ebx
            padc = '0';
40000428:	c6 44 24 1b 30       	movb   $0x30,0x1b(%esp)
4000042d:	eb c5                	jmp    400003f4 <vprintfmt+0x6d>

4000042f <.L62>:
        switch (ch = *(unsigned char *) fmt++) {
4000042f:	b9 00 00 00 00       	mov    $0x0,%ecx
40000434:	8b 14 24             	mov    (%esp),%edx
40000437:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000043e:	00 
4000043f:	90                   	nop
                precision = precision * 10 + ch - '0';
40000440:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
40000443:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
                ch = *fmt;
40000447:	0f be 55 00          	movsbl 0x0(%ebp),%edx
                if (ch < '0' || ch > '9')
4000044b:	8d 42 d0             	lea    -0x30(%edx),%eax
4000044e:	83 f8 09             	cmp    $0x9,%eax
40000451:	77 40                	ja     40000493 <.L41+0xf>
            for (precision = 0;; ++fmt) {
40000453:	83 c5 01             	add    $0x1,%ebp
                precision = precision * 10 + ch - '0';
40000456:	eb e8                	jmp    40000440 <.L62+0x11>

40000458 <.L39>:
            precision = va_arg(ap, int);
40000458:	8b 44 24 4c          	mov    0x4c(%esp),%eax
4000045c:	83 c0 04             	add    $0x4,%eax
4000045f:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000463:	8b 40 fc             	mov    -0x4(%eax),%eax
40000466:	89 44 24 10          	mov    %eax,0x10(%esp)
            goto process_precision;
4000046a:	eb 2b                	jmp    40000497 <.L41+0x13>

4000046c <.L38>:
            if (width < 0)
4000046c:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
40000471:	78 07                	js     4000047a <.L38+0xe>
        switch (ch = *(unsigned char *) fmt++) {
40000473:	89 eb                	mov    %ebp,%ebx
            goto reswitch;
40000475:	e9 7a ff ff ff       	jmp    400003f4 <vprintfmt+0x6d>
                width = 0;
4000047a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000481:	00 
40000482:	eb ef                	jmp    40000473 <.L38+0x7>

40000484 <.L41>:
        switch (ch = *(unsigned char *) fmt++) {
40000484:	89 eb                	mov    %ebp,%ebx
            altflag = 1;
40000486:	c7 44 24 14 01 00 00 	movl   $0x1,0x14(%esp)
4000048d:	00 
            goto reswitch;
4000048e:	e9 61 ff ff ff       	jmp    400003f4 <vprintfmt+0x6d>
40000493:	89 4c 24 10          	mov    %ecx,0x10(%esp)
            if (width < 0)
40000497:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
4000049c:	78 07                	js     400004a5 <.L41+0x21>
            goto reswitch;
4000049e:	89 eb                	mov    %ebp,%ebx
400004a0:	e9 4f ff ff ff       	jmp    400003f4 <vprintfmt+0x6d>
                width = precision, precision = -1;
400004a5:	8b 44 24 10          	mov    0x10(%esp),%eax
400004a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
400004ad:	c7 44 24 10 ff ff ff 	movl   $0xffffffff,0x10(%esp)
400004b4:	ff 
400004b5:	eb e7                	jmp    4000049e <.L41+0x1a>

400004b7 <.L34>:
            lflag++;
400004b7:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
        switch (ch = *(unsigned char *) fmt++) {
400004bc:	89 eb                	mov    %ebp,%ebx
            goto reswitch;
400004be:	e9 31 ff ff ff       	jmp    400003f4 <vprintfmt+0x6d>

400004c3 <.L36>:
            putch(va_arg(ap, int), putdat);
400004c3:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400004c7:	83 c0 04             	add    $0x4,%eax
400004ca:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004ce:	83 ec 08             	sub    $0x8,%esp
400004d1:	57                   	push   %edi
400004d2:	ff 70 fc             	push   -0x4(%eax)
400004d5:	ff d6                	call   *%esi
            break;
400004d7:	83 c4 10             	add    $0x10,%esp
400004da:	e9 d7 fe ff ff       	jmp    400003b6 <vprintfmt+0x2f>

400004df <.L31>:
            if ((p = va_arg(ap, char *)) == NULL)
400004df:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400004e3:	83 c0 04             	add    $0x4,%eax
400004e6:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004ea:	8b 40 fc             	mov    -0x4(%eax),%eax
400004ed:	89 04 24             	mov    %eax,(%esp)
400004f0:	85 c0                	test   %eax,%eax
400004f2:	74 29                	je     4000051d <.L31+0x3e>
            if (width > 0 && padc != '-')
400004f4:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
400004f9:	0f 9f c2             	setg   %dl
400004fc:	80 7c 24 1b 2d       	cmpb   $0x2d,0x1b(%esp)
40000501:	0f 95 c0             	setne  %al
40000504:	84 c2                	test   %al,%dl
40000506:	75 24                	jne    4000052c <.L31+0x4d>
40000508:	8b 04 24             	mov    (%esp),%eax
4000050b:	8b 5c 24 10          	mov    0x10(%esp),%ebx
4000050f:	89 74 24 40          	mov    %esi,0x40(%esp)
40000513:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000517:	89 6c 24 48          	mov    %ebp,0x48(%esp)
4000051b:	eb 6e                	jmp    4000058b <.L31+0xac>
                p = "(null)";
4000051d:	8b 44 24 08          	mov    0x8(%esp),%eax
40000521:	8d 80 41 e0 ff ff    	lea    -0x1fbf(%eax),%eax
40000527:	89 04 24             	mov    %eax,(%esp)
4000052a:	eb c8                	jmp    400004f4 <.L31+0x15>
                for (width -= strnlen(p, precision); width > 0; width--)
4000052c:	83 ec 08             	sub    $0x8,%esp
4000052f:	ff 74 24 18          	push   0x18(%esp)
40000533:	ff 74 24 0c          	push   0xc(%esp)
40000537:	8b 5c 24 18          	mov    0x18(%esp),%ebx
4000053b:	e8 5e 03 00 00       	call   4000089e <strnlen>
40000540:	29 44 24 1c          	sub    %eax,0x1c(%esp)
40000544:	8b 54 24 1c          	mov    0x1c(%esp),%edx
40000548:	83 c4 10             	add    $0x10,%esp
4000054b:	89 d3                	mov    %edx,%ebx
4000054d:	eb 12                	jmp    40000561 <.L31+0x82>
                    putch(padc, putdat);
4000054f:	83 ec 08             	sub    $0x8,%esp
40000552:	57                   	push   %edi
40000553:	0f be 44 24 27       	movsbl 0x27(%esp),%eax
40000558:	50                   	push   %eax
40000559:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
4000055b:	83 eb 01             	sub    $0x1,%ebx
4000055e:	83 c4 10             	add    $0x10,%esp
40000561:	85 db                	test   %ebx,%ebx
40000563:	7f ea                	jg     4000054f <.L31+0x70>
40000565:	89 da                	mov    %ebx,%edx
40000567:	8b 04 24             	mov    (%esp),%eax
4000056a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
4000056e:	89 74 24 40          	mov    %esi,0x40(%esp)
40000572:	89 d6                	mov    %edx,%esi
40000574:	89 6c 24 48          	mov    %ebp,0x48(%esp)
40000578:	eb 11                	jmp    4000058b <.L31+0xac>
                    putch(ch, putdat);
4000057a:	83 ec 08             	sub    $0x8,%esp
4000057d:	57                   	push   %edi
4000057e:	52                   	push   %edx
4000057f:	ff 54 24 50          	call   *0x50(%esp)
40000583:	83 c4 10             	add    $0x10,%esp
                                         || --precision >= 0); width--)
40000586:	83 ee 01             	sub    $0x1,%esi
                 (ch = *p++) != '\0' && (precision < 0
40000589:	89 e8                	mov    %ebp,%eax
4000058b:	8d 68 01             	lea    0x1(%eax),%ebp
4000058e:	0f b6 00             	movzbl (%eax),%eax
40000591:	0f be d0             	movsbl %al,%edx
40000594:	85 d2                	test   %edx,%edx
40000596:	74 4d                	je     400005e5 <.L31+0x106>
40000598:	85 db                	test   %ebx,%ebx
4000059a:	78 05                	js     400005a1 <.L31+0xc2>
                                         || --precision >= 0); width--)
4000059c:	83 eb 01             	sub    $0x1,%ebx
4000059f:	78 21                	js     400005c2 <.L31+0xe3>
                if (altflag && (ch < ' ' || ch > '~'))
400005a1:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
400005a6:	74 d2                	je     4000057a <.L31+0x9b>
400005a8:	0f be c0             	movsbl %al,%eax
400005ab:	83 e8 20             	sub    $0x20,%eax
400005ae:	83 f8 5e             	cmp    $0x5e,%eax
400005b1:	76 c7                	jbe    4000057a <.L31+0x9b>
                    putch('?', putdat);
400005b3:	83 ec 08             	sub    $0x8,%esp
400005b6:	57                   	push   %edi
400005b7:	6a 3f                	push   $0x3f
400005b9:	ff 54 24 50          	call   *0x50(%esp)
400005bd:	83 c4 10             	add    $0x10,%esp
400005c0:	eb c4                	jmp    40000586 <.L31+0xa7>
400005c2:	89 f3                	mov    %esi,%ebx
400005c4:	8b 74 24 40          	mov    0x40(%esp),%esi
400005c8:	8b 6c 24 48          	mov    0x48(%esp),%ebp
400005cc:	eb 0e                	jmp    400005dc <.L31+0xfd>
                putch(' ', putdat);
400005ce:	83 ec 08             	sub    $0x8,%esp
400005d1:	57                   	push   %edi
400005d2:	6a 20                	push   $0x20
400005d4:	ff d6                	call   *%esi
            for (; width > 0; width--)
400005d6:	83 eb 01             	sub    $0x1,%ebx
400005d9:	83 c4 10             	add    $0x10,%esp
400005dc:	85 db                	test   %ebx,%ebx
400005de:	7f ee                	jg     400005ce <.L31+0xef>
400005e0:	e9 d1 fd ff ff       	jmp    400003b6 <vprintfmt+0x2f>
400005e5:	89 f3                	mov    %esi,%ebx
400005e7:	8b 74 24 40          	mov    0x40(%esp),%esi
400005eb:	8b 6c 24 48          	mov    0x48(%esp),%ebp
400005ef:	eb eb                	jmp    400005dc <.L31+0xfd>

400005f1 <.L35>:
            num = getint(&ap, lflag);
400005f1:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
400005f5:	8d 44 24 4c          	lea    0x4c(%esp),%eax
400005f9:	89 ca                	mov    %ecx,%edx
400005fb:	e8 3b fd ff ff       	call   4000033b <getint>
            if ((long long) num < 0) {
40000600:	89 04 24             	mov    %eax,(%esp)
40000603:	89 54 24 04          	mov    %edx,0x4(%esp)
40000607:	83 7c 24 04 00       	cmpl   $0x0,0x4(%esp)
4000060c:	78 26                	js     40000634 <.L35+0x43>
            base = 10;
4000060e:	bb 0a 00 00 00       	mov    $0xa,%ebx
            printnum(putch, putdat, num, base, width, padc);
40000613:	83 ec 0c             	sub    $0xc,%esp
40000616:	0f be 4c 24 27       	movsbl 0x27(%esp),%ecx
4000061b:	51                   	push   %ecx
4000061c:	ff 74 24 1c          	push   0x1c(%esp)
40000620:	53                   	push   %ebx
40000621:	52                   	push   %edx
40000622:	50                   	push   %eax
40000623:	89 fa                	mov    %edi,%edx
40000625:	89 f0                	mov    %esi,%eax
40000627:	e8 14 fc ff ff       	call   40000240 <printnum>
            break;
4000062c:	83 c4 20             	add    $0x20,%esp
4000062f:	e9 82 fd ff ff       	jmp    400003b6 <vprintfmt+0x2f>
                putch('-', putdat);
40000634:	83 ec 08             	sub    $0x8,%esp
40000637:	57                   	push   %edi
40000638:	6a 2d                	push   $0x2d
4000063a:	ff d6                	call   *%esi
                num = -(long long) num;
4000063c:	8b 44 24 10          	mov    0x10(%esp),%eax
40000640:	8b 54 24 14          	mov    0x14(%esp),%edx
40000644:	f7 d8                	neg    %eax
40000646:	83 d2 00             	adc    $0x0,%edx
40000649:	f7 da                	neg    %edx
4000064b:	83 c4 10             	add    $0x10,%esp
4000064e:	eb be                	jmp    4000060e <.L35+0x1d>

40000650 <.L30>:
            num = getuint(&ap, lflag);
40000650:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
40000654:	8d 44 24 4c          	lea    0x4c(%esp),%eax
40000658:	89 ca                	mov    %ecx,%edx
4000065a:	e8 a8 fc ff ff       	call   40000307 <getuint>
            base = 10;
4000065f:	bb 0a 00 00 00       	mov    $0xa,%ebx
            goto number;
40000664:	eb ad                	jmp    40000613 <.L35+0x22>

40000666 <.L33>:
            putch('X', putdat);
40000666:	83 ec 08             	sub    $0x8,%esp
40000669:	57                   	push   %edi
4000066a:	6a 58                	push   $0x58
4000066c:	ff d6                	call   *%esi
            putch('X', putdat);
4000066e:	83 c4 08             	add    $0x8,%esp
40000671:	57                   	push   %edi
40000672:	6a 58                	push   $0x58
40000674:	ff d6                	call   *%esi
            putch('X', putdat);
40000676:	83 c4 08             	add    $0x8,%esp
40000679:	57                   	push   %edi
4000067a:	6a 58                	push   $0x58
4000067c:	ff d6                	call   *%esi
            break;
4000067e:	83 c4 10             	add    $0x10,%esp
40000681:	e9 30 fd ff ff       	jmp    400003b6 <vprintfmt+0x2f>

40000686 <.L32>:
            putch('0', putdat);
40000686:	83 ec 08             	sub    $0x8,%esp
40000689:	57                   	push   %edi
4000068a:	6a 30                	push   $0x30
4000068c:	ff d6                	call   *%esi
            putch('x', putdat);
4000068e:	83 c4 08             	add    $0x8,%esp
40000691:	57                   	push   %edi
40000692:	6a 78                	push   $0x78
40000694:	ff d6                	call   *%esi
                (uintptr_t) va_arg(ap, void *);
40000696:	8b 44 24 5c          	mov    0x5c(%esp),%eax
4000069a:	83 c0 04             	add    $0x4,%eax
4000069d:	89 44 24 5c          	mov    %eax,0x5c(%esp)
            num = (unsigned long long)
400006a1:	8b 40 fc             	mov    -0x4(%eax),%eax
400006a4:	ba 00 00 00 00       	mov    $0x0,%edx
            goto number;
400006a9:	83 c4 10             	add    $0x10,%esp
            base = 16;
400006ac:	bb 10 00 00 00       	mov    $0x10,%ebx
            goto number;
400006b1:	e9 5d ff ff ff       	jmp    40000613 <.L35+0x22>

400006b6 <.L28>:
            num = getuint(&ap, lflag);
400006b6:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
400006ba:	8d 44 24 4c          	lea    0x4c(%esp),%eax
400006be:	89 ca                	mov    %ecx,%edx
400006c0:	e8 42 fc ff ff       	call   40000307 <getuint>
            base = 16;
400006c5:	bb 10 00 00 00       	mov    $0x10,%ebx
400006ca:	e9 44 ff ff ff       	jmp    40000613 <.L35+0x22>

400006cf <.L40>:
            putch(ch, putdat);
400006cf:	8b 14 24             	mov    (%esp),%edx
400006d2:	83 ec 08             	sub    $0x8,%esp
400006d5:	57                   	push   %edi
400006d6:	52                   	push   %edx
400006d7:	ff d6                	call   *%esi
            break;
400006d9:	83 c4 10             	add    $0x10,%esp
400006dc:	e9 d5 fc ff ff       	jmp    400003b6 <vprintfmt+0x2f>

400006e1 <.L27>:
            putch('%', putdat);
400006e1:	83 ec 08             	sub    $0x8,%esp
400006e4:	57                   	push   %edi
400006e5:	6a 25                	push   $0x25
400006e7:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
400006e9:	83 c4 10             	add    $0x10,%esp
400006ec:	89 dd                	mov    %ebx,%ebp
400006ee:	eb 03                	jmp    400006f3 <.L27+0x12>
400006f0:	83 ed 01             	sub    $0x1,%ebp
400006f3:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
400006f7:	75 f7                	jne    400006f0 <.L27+0xf>
400006f9:	e9 b8 fc ff ff       	jmp    400003b6 <vprintfmt+0x2f>

400006fe <printfmt>:
{
400006fe:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt(putch, putdat, fmt, ap);
40000701:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000705:	50                   	push   %eax
40000706:	ff 74 24 1c          	push   0x1c(%esp)
4000070a:	ff 74 24 1c          	push   0x1c(%esp)
4000070e:	ff 74 24 1c          	push   0x1c(%esp)
40000712:	e8 70 fc ff ff       	call   40000387 <vprintfmt>
}
40000717:	83 c4 1c             	add    $0x1c,%esp
4000071a:	c3                   	ret

4000071b <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list ap)
{
4000071b:	83 ec 1c             	sub    $0x1c,%esp
4000071e:	e8 cd 00 00 00       	call   400007f0 <__x86.get_pc_thunk.ax>
40000723:	05 d1 28 00 00       	add    $0x28d1,%eax
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000728:	8b 54 24 20          	mov    0x20(%esp),%edx
4000072c:	89 54 24 04          	mov    %edx,0x4(%esp)
40000730:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
40000737:	ff 
40000738:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
4000073f:	00 

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
40000740:	ff 74 24 28          	push   0x28(%esp)
40000744:	ff 74 24 28          	push   0x28(%esp)
40000748:	8d 54 24 0c          	lea    0xc(%esp),%edx
4000074c:	52                   	push   %edx
4000074d:	8d 80 73 d3 ff ff    	lea    -0x2c8d(%eax),%eax
40000753:	50                   	push   %eax
40000754:	e8 2e fc ff ff       	call   40000387 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000759:	8b 44 24 14          	mov    0x14(%esp),%eax
4000075d:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
40000760:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000764:	83 c4 2c             	add    $0x2c,%esp
40000767:	c3                   	ret

40000768 <sprintf>:

int sprintf(char *buf, const char *fmt, ...)
{
40000768:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    int rc;

    va_start(ap, fmt);
    rc = vsprintf(buf, fmt, ap);
4000076b:	8d 44 24 1c          	lea    0x1c(%esp),%eax
4000076f:	50                   	push   %eax
40000770:	ff 74 24 1c          	push   0x1c(%esp)
40000774:	ff 74 24 1c          	push   0x1c(%esp)
40000778:	e8 9e ff ff ff       	call   4000071b <vsprintf>
    va_end(ap);

    return rc;
}
4000077d:	83 c4 1c             	add    $0x1c,%esp
40000780:	c3                   	ret

40000781 <vsnprintf>:

int vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000781:	83 ec 1c             	sub    $0x1c,%esp
40000784:	e8 6b 00 00 00       	call   400007f4 <__x86.get_pc_thunk.dx>
40000789:	81 c2 6b 28 00 00    	add    $0x286b,%edx
4000078f:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000793:	89 44 24 04          	mov    %eax,0x4(%esp)
40000797:	8b 4c 24 24          	mov    0x24(%esp),%ecx
4000079b:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
4000079f:	89 44 24 08          	mov    %eax,0x8(%esp)
400007a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400007aa:	00 

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400007ab:	ff 74 24 2c          	push   0x2c(%esp)
400007af:	ff 74 24 2c          	push   0x2c(%esp)
400007b3:	8d 44 24 0c          	lea    0xc(%esp),%eax
400007b7:	50                   	push   %eax
400007b8:	8d 82 73 d3 ff ff    	lea    -0x2c8d(%edx),%eax
400007be:	50                   	push   %eax
400007bf:	e8 c3 fb ff ff       	call   40000387 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
400007c4:	8b 44 24 14          	mov    0x14(%esp),%eax
400007c8:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
400007cb:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400007cf:	83 c4 2c             	add    $0x2c,%esp
400007d2:	c3                   	ret

400007d3 <snprintf>:

int snprintf(char *buf, int n, const char *fmt, ...)
{
400007d3:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;
    int rc;

    va_start(ap, fmt);
    rc = vsnprintf(buf, n, fmt, ap);
400007d6:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400007da:	50                   	push   %eax
400007db:	ff 74 24 1c          	push   0x1c(%esp)
400007df:	ff 74 24 1c          	push   0x1c(%esp)
400007e3:	ff 74 24 1c          	push   0x1c(%esp)
400007e7:	e8 95 ff ff ff       	call   40000781 <vsnprintf>
    va_end(ap);

    return rc;
}
400007ec:	83 c4 1c             	add    $0x1c,%esp
400007ef:	c3                   	ret

400007f0 <__x86.get_pc_thunk.ax>:
400007f0:	8b 04 24             	mov    (%esp),%eax
400007f3:	c3                   	ret

400007f4 <__x86.get_pc_thunk.dx>:
400007f4:	8b 14 24             	mov    (%esp),%edx
400007f7:	c3                   	ret

400007f8 <__x86.get_pc_thunk.cx>:
400007f8:	8b 0c 24             	mov    (%esp),%ecx
400007fb:	c3                   	ret

400007fc <spawn>:
#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t spawn(uintptr_t exec, unsigned int quota)
{
400007fc:	53                   	push   %ebx
static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
400007fd:	8b 5c 24 08          	mov    0x8(%esp),%ebx
40000801:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000805:	b8 01 00 00 00       	mov    $0x1,%eax
4000080a:	cd 30                	int    $0x30
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
4000080c:	85 c0                	test   %eax,%eax
4000080e:	75 04                	jne    40000814 <spawn+0x18>
    return sys_spawn(exec, quota);
}
40000810:	89 d8                	mov    %ebx,%eax
40000812:	5b                   	pop    %ebx
40000813:	c3                   	ret
40000814:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return sys_spawn(exec, quota);
40000819:	eb f5                	jmp    40000810 <spawn+0x14>

4000081b <yield>:
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
4000081b:	b8 02 00 00 00       	mov    $0x2,%eax
40000820:	cd 30                	int    $0x30

void yield(void)
{
    sys_yield();
}
40000822:	c3                   	ret

40000823 <spinlock_init>:
    return result;
}

void spinlock_init(spinlock_t *lk)
{
    *lk = 0;
40000823:	8b 44 24 04          	mov    0x4(%esp),%eax
40000827:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
4000082d:	c3                   	ret

4000082e <spinlock_acquire>:

void spinlock_acquire(spinlock_t *lk)
{
4000082e:	8b 54 24 04          	mov    0x4(%esp),%edx
    while (xchg(lk, 1) != 0)
40000832:	eb 02                	jmp    40000836 <spinlock_acquire+0x8>
        asm volatile ("pause");
40000834:	f3 90                	pause
    asm volatile ("lock; xchgl %0, %1"
40000836:	b8 01 00 00 00       	mov    $0x1,%eax
4000083b:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
4000083e:	85 c0                	test   %eax,%eax
40000840:	75 f2                	jne    40000834 <spinlock_acquire+0x6>
}
40000842:	c3                   	ret

40000843 <spinlock_holding>:
}

// Check whether this cpu is holding the lock.
bool spinlock_holding(spinlock_t *lk)
{
    return *lk;
40000843:	8b 44 24 04          	mov    0x4(%esp),%eax
40000847:	8b 00                	mov    (%eax),%eax
}
40000849:	c3                   	ret

4000084a <spinlock_release>:
{
4000084a:	53                   	push   %ebx
4000084b:	8b 5c 24 08          	mov    0x8(%esp),%ebx
    if (spinlock_holding(lk) == FALSE)
4000084f:	53                   	push   %ebx
40000850:	e8 ee ff ff ff       	call   40000843 <spinlock_holding>
40000855:	83 c4 04             	add    $0x4,%esp
40000858:	84 c0                	test   %al,%al
4000085a:	74 08                	je     40000864 <spinlock_release+0x1a>
    asm volatile ("lock; xchgl %0, %1"
4000085c:	b8 00 00 00 00       	mov    $0x0,%eax
40000861:	f0 87 03             	lock xchg %eax,(%ebx)
}
40000864:	5b                   	pop    %ebx
40000865:	c3                   	ret
40000866:	66 90                	xchg   %ax,%ax
40000868:	66 90                	xchg   %ax,%ax
4000086a:	66 90                	xchg   %ax,%ax
4000086c:	66 90                	xchg   %ax,%ax
4000086e:	66 90                	xchg   %ax,%ax
40000870:	66 90                	xchg   %ax,%ax
40000872:	66 90                	xchg   %ax,%ax
40000874:	66 90                	xchg   %ax,%ax
40000876:	66 90                	xchg   %ax,%ax
40000878:	66 90                	xchg   %ax,%ax
4000087a:	66 90                	xchg   %ax,%ax
4000087c:	66 90                	xchg   %ax,%ax
4000087e:	66 90                	xchg   %ax,%ax

40000880 <strlen>:
#include <string.h>
#include <types.h>

int strlen(const char *s)
{
40000880:	8b 44 24 04          	mov    0x4(%esp),%eax
    int n;

    for (n = 0; *s != '\0'; s++)
40000884:	ba 00 00 00 00       	mov    $0x0,%edx
40000889:	eb 0b                	jmp    40000896 <strlen+0x16>
4000088b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        n++;
40000890:	83 c2 01             	add    $0x1,%edx
    for (n = 0; *s != '\0'; s++)
40000893:	83 c0 01             	add    $0x1,%eax
40000896:	80 38 00             	cmpb   $0x0,(%eax)
40000899:	75 f5                	jne    40000890 <strlen+0x10>
    return n;
}
4000089b:	89 d0                	mov    %edx,%eax
4000089d:	c3                   	ret

4000089e <strnlen>:

int strnlen(const char *s, size_t size)
{
4000089e:	8b 54 24 04          	mov    0x4(%esp),%edx
400008a2:	8b 44 24 08          	mov    0x8(%esp),%eax
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
400008a6:	b9 00 00 00 00       	mov    $0x0,%ecx
400008ab:	eb 1c                	jmp    400008c9 <strnlen+0x2b>
400008ad:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008b4:	00 
400008b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008bc:	00 
400008bd:	8d 76 00             	lea    0x0(%esi),%esi
        n++;
400008c0:	83 c1 01             	add    $0x1,%ecx
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
400008c3:	83 c2 01             	add    $0x1,%edx
400008c6:	83 e8 01             	sub    $0x1,%eax
400008c9:	85 c0                	test   %eax,%eax
400008cb:	74 05                	je     400008d2 <strnlen+0x34>
400008cd:	80 3a 00             	cmpb   $0x0,(%edx)
400008d0:	75 ee                	jne    400008c0 <strnlen+0x22>
    return n;
}
400008d2:	89 c8                	mov    %ecx,%eax
400008d4:	c3                   	ret

400008d5 <strcpy>:

char *strcpy(char *dst, const char *src)
{
400008d5:	56                   	push   %esi
400008d6:	53                   	push   %ebx
400008d7:	8b 74 24 0c          	mov    0xc(%esp),%esi
400008db:	8b 54 24 10          	mov    0x10(%esp),%edx
    char *ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
400008df:	89 f0                	mov    %esi,%eax
400008e1:	eb 1d                	jmp    40000900 <strcpy+0x2b>
400008e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008ea:	00 
400008eb:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008f2:	00 
400008f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400008fa:	00 
400008fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000900:	89 d1                	mov    %edx,%ecx
40000902:	83 c2 01             	add    $0x1,%edx
40000905:	89 c3                	mov    %eax,%ebx
40000907:	83 c0 01             	add    $0x1,%eax
4000090a:	0f b6 09             	movzbl (%ecx),%ecx
4000090d:	88 0b                	mov    %cl,(%ebx)
4000090f:	84 c9                	test   %cl,%cl
40000911:	75 ed                	jne    40000900 <strcpy+0x2b>
        /* do nothing */ ;
    return ret;
}
40000913:	89 f0                	mov    %esi,%eax
40000915:	5b                   	pop    %ebx
40000916:	5e                   	pop    %esi
40000917:	c3                   	ret

40000918 <strncpy>:

char *strncpy(char *dst, const char *src, size_t size)
{
40000918:	55                   	push   %ebp
40000919:	57                   	push   %edi
4000091a:	56                   	push   %esi
4000091b:	53                   	push   %ebx
4000091c:	8b 6c 24 14          	mov    0x14(%esp),%ebp
40000920:	8b 5c 24 18          	mov    0x18(%esp),%ebx
40000924:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
    size_t i;
    char *ret;

    ret = dst;
    for (i = 0; i < size; i++) {
40000928:	89 ea                	mov    %ebp,%edx
4000092a:	b8 00 00 00 00       	mov    $0x0,%eax
4000092f:	eb 14                	jmp    40000945 <strncpy+0x2d>
40000931:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000938:	00 
40000939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000940:	83 c0 01             	add    $0x1,%eax
        *dst++ = *src;
40000943:	89 f2                	mov    %esi,%edx
    for (i = 0; i < size; i++) {
40000945:	39 f8                	cmp    %edi,%eax
40000947:	73 11                	jae    4000095a <strncpy+0x42>
        *dst++ = *src;
40000949:	8d 72 01             	lea    0x1(%edx),%esi
4000094c:	0f b6 0b             	movzbl (%ebx),%ecx
4000094f:	88 0a                	mov    %cl,(%edx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
40000951:	84 c9                	test   %cl,%cl
40000953:	74 eb                	je     40000940 <strncpy+0x28>
            src++;
40000955:	83 c3 01             	add    $0x1,%ebx
40000958:	eb e6                	jmp    40000940 <strncpy+0x28>
    }
    return ret;
}
4000095a:	89 e8                	mov    %ebp,%eax
4000095c:	5b                   	pop    %ebx
4000095d:	5e                   	pop    %esi
4000095e:	5f                   	pop    %edi
4000095f:	5d                   	pop    %ebp
40000960:	c3                   	ret

40000961 <strlcpy>:

size_t strlcpy(char *dst, const char *src, size_t size)
{
40000961:	56                   	push   %esi
40000962:	53                   	push   %ebx
40000963:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000967:	8b 4c 24 10          	mov    0x10(%esp),%ecx
4000096b:	8b 54 24 14          	mov    0x14(%esp),%edx
    char *dst_in;

    dst_in = dst;
    if (size > 0) {
4000096f:	85 d2                	test   %edx,%edx
40000971:	75 29                	jne    4000099c <strlcpy+0x3b>
40000973:	89 f0                	mov    %esi,%eax
40000975:	eb 20                	jmp    40000997 <strlcpy+0x36>
40000977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
4000097e:	00 
4000097f:	90                   	nop
        while (--size > 0 && *src != '\0')
            *dst++ = *src++;
40000980:	83 c1 01             	add    $0x1,%ecx
40000983:	88 18                	mov    %bl,(%eax)
40000985:	8d 40 01             	lea    0x1(%eax),%eax
        while (--size > 0 && *src != '\0')
40000988:	83 ea 01             	sub    $0x1,%edx
4000098b:	74 07                	je     40000994 <strlcpy+0x33>
4000098d:	0f b6 19             	movzbl (%ecx),%ebx
40000990:	84 db                	test   %bl,%bl
40000992:	75 ec                	jne    40000980 <strlcpy+0x1f>
        *dst = '\0';
40000994:	c6 00 00             	movb   $0x0,(%eax)
    }
    return dst - dst_in;
40000997:	29 f0                	sub    %esi,%eax
}
40000999:	5b                   	pop    %ebx
4000099a:	5e                   	pop    %esi
4000099b:	c3                   	ret
4000099c:	89 f0                	mov    %esi,%eax
4000099e:	eb e8                	jmp    40000988 <strlcpy+0x27>

400009a0 <strcmp>:

int strcmp(const char *p, const char *q)
{
400009a0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
400009a4:	8b 54 24 08          	mov    0x8(%esp),%edx
    while (*p && *p == *q)
400009a8:	eb 1c                	jmp    400009c6 <strcmp+0x26>
400009aa:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009b1:	00 
400009b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
400009b9:	00 
400009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p++, q++;
400009c0:	83 c1 01             	add    $0x1,%ecx
400009c3:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
400009c6:	0f b6 01             	movzbl (%ecx),%eax
400009c9:	84 c0                	test   %al,%al
400009cb:	74 04                	je     400009d1 <strcmp+0x31>
400009cd:	3a 02                	cmp    (%edx),%al
400009cf:	74 ef                	je     400009c0 <strcmp+0x20>
    return (int) ((unsigned char) *p - (unsigned char) *q);
400009d1:	0f b6 c0             	movzbl %al,%eax
400009d4:	0f b6 12             	movzbl (%edx),%edx
400009d7:	29 d0                	sub    %edx,%eax
}
400009d9:	c3                   	ret

400009da <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
400009da:	53                   	push   %ebx
400009db:	8b 54 24 08          	mov    0x8(%esp),%edx
400009df:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
400009e3:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
400009e7:	eb 09                	jmp    400009f2 <strncmp+0x18>
        n--, p++, q++;
400009e9:	83 e8 01             	sub    $0x1,%eax
400009ec:	83 c2 01             	add    $0x1,%edx
400009ef:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
400009f2:	85 c0                	test   %eax,%eax
400009f4:	74 0b                	je     40000a01 <strncmp+0x27>
400009f6:	0f b6 1a             	movzbl (%edx),%ebx
400009f9:	84 db                	test   %bl,%bl
400009fb:	74 04                	je     40000a01 <strncmp+0x27>
400009fd:	3a 19                	cmp    (%ecx),%bl
400009ff:	74 e8                	je     400009e9 <strncmp+0xf>
    if (n == 0)
40000a01:	85 c0                	test   %eax,%eax
40000a03:	74 0a                	je     40000a0f <strncmp+0x35>
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
40000a05:	0f b6 02             	movzbl (%edx),%eax
40000a08:	0f b6 11             	movzbl (%ecx),%edx
40000a0b:	29 d0                	sub    %edx,%eax
}
40000a0d:	5b                   	pop    %ebx
40000a0e:	c3                   	ret
        return 0;
40000a0f:	b8 00 00 00 00       	mov    $0x0,%eax
40000a14:	eb f7                	jmp    40000a0d <strncmp+0x33>

40000a16 <strchr>:

char *strchr(const char *s, char c)
{
40000a16:	8b 44 24 04          	mov    0x4(%esp),%eax
40000a1a:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000a1f:	eb 12                	jmp    40000a33 <strchr+0x1d>
40000a21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a28:	00 
40000a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a30:	83 c0 01             	add    $0x1,%eax
40000a33:	0f b6 10             	movzbl (%eax),%edx
40000a36:	84 d2                	test   %dl,%dl
40000a38:	74 05                	je     40000a3f <strchr+0x29>
        if (*s == c)
40000a3a:	38 ca                	cmp    %cl,%dl
40000a3c:	75 f2                	jne    40000a30 <strchr+0x1a>
40000a3e:	c3                   	ret
            return (char *) s;
    return 0;
40000a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
40000a44:	c3                   	ret

40000a45 <strfind>:

char *strfind(const char *s, char c)
{
40000a45:	8b 44 24 04          	mov    0x4(%esp),%eax
40000a49:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000a4e:	eb 03                	jmp    40000a53 <strfind+0xe>
40000a50:	83 c0 01             	add    $0x1,%eax
40000a53:	0f b6 10             	movzbl (%eax),%edx
40000a56:	84 d2                	test   %dl,%dl
40000a58:	74 04                	je     40000a5e <strfind+0x19>
        if (*s == c)
40000a5a:	38 ca                	cmp    %cl,%dl
40000a5c:	75 f2                	jne    40000a50 <strfind+0xb>
            break;
    return (char *) s;
}
40000a5e:	c3                   	ret

40000a5f <strtol>:

long strtol(const char *s, char **endptr, int base)
{
40000a5f:	55                   	push   %ebp
40000a60:	57                   	push   %edi
40000a61:	56                   	push   %esi
40000a62:	53                   	push   %ebx
40000a63:	83 ec 04             	sub    $0x4,%esp
40000a66:	8b 54 24 18          	mov    0x18(%esp),%edx
40000a6a:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000a6e:	8b 5c 24 20          	mov    0x20(%esp),%ebx
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
40000a72:	eb 0f                	jmp    40000a83 <strtol+0x24>
40000a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000a7b:	00 
40000a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s++;
40000a80:	83 c2 01             	add    $0x1,%edx
    while (*s == ' ' || *s == '\t')
40000a83:	0f b6 02             	movzbl (%edx),%eax
40000a86:	3c 20                	cmp    $0x20,%al
40000a88:	74 f6                	je     40000a80 <strtol+0x21>
40000a8a:	3c 09                	cmp    $0x9,%al
40000a8c:	74 f2                	je     40000a80 <strtol+0x21>

    // plus/minus sign
    if (*s == '+')
40000a8e:	3c 2b                	cmp    $0x2b,%al
40000a90:	74 39                	je     40000acb <strtol+0x6c>
        s++;
    else if (*s == '-')
40000a92:	3c 2d                	cmp    $0x2d,%al
40000a94:	74 3f                	je     40000ad5 <strtol+0x76>
    int neg = 0;
40000a96:	bf 00 00 00 00       	mov    $0x0,%edi
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000a9b:	85 db                	test   %ebx,%ebx
40000a9d:	0f 94 c0             	sete   %al
40000aa0:	83 fb 10             	cmp    $0x10,%ebx
40000aa3:	0f 94 c1             	sete   %cl
40000aa6:	08 c8                	or     %cl,%al
40000aa8:	74 0f                	je     40000ab9 <strtol+0x5a>
40000aaa:	0f b6 02             	movzbl (%edx),%eax
40000aad:	3c 30                	cmp    $0x30,%al
40000aaf:	74 2e                	je     40000adf <strtol+0x80>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
40000ab1:	85 db                	test   %ebx,%ebx
40000ab3:	75 0d                	jne    40000ac2 <strtol+0x63>
40000ab5:	3c 30                	cmp    $0x30,%al
40000ab7:	74 36                	je     40000aef <strtol+0x90>
        s++, base = 8;
    else if (base == 0)
40000ab9:	85 db                	test   %ebx,%ebx
40000abb:	75 05                	jne    40000ac2 <strtol+0x63>
        base = 10;
40000abd:	bb 0a 00 00 00       	mov    $0xa,%ebx
40000ac2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
40000ac9:	eb 50                	jmp    40000b1b <strtol+0xbc>
        s++;
40000acb:	83 c2 01             	add    $0x1,%edx
    int neg = 0;
40000ace:	bf 00 00 00 00       	mov    $0x0,%edi
40000ad3:	eb c6                	jmp    40000a9b <strtol+0x3c>
        s++, neg = 1;
40000ad5:	83 c2 01             	add    $0x1,%edx
40000ad8:	bf 01 00 00 00       	mov    $0x1,%edi
40000add:	eb bc                	jmp    40000a9b <strtol+0x3c>
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000adf:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
40000ae3:	75 cc                	jne    40000ab1 <strtol+0x52>
        s += 2, base = 16;
40000ae5:	83 c2 02             	add    $0x2,%edx
40000ae8:	bb 10 00 00 00       	mov    $0x10,%ebx
40000aed:	eb d3                	jmp    40000ac2 <strtol+0x63>
        s++, base = 8;
40000aef:	83 c2 01             	add    $0x1,%edx
40000af2:	bb 08 00 00 00       	mov    $0x8,%ebx
40000af7:	eb c9                	jmp    40000ac2 <strtol+0x63>
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
        else if (*s >= 'a' && *s <= 'z')
40000af9:	8d 68 9f             	lea    -0x61(%eax),%ebp
40000afc:	89 e9                	mov    %ebp,%ecx
40000afe:	80 f9 19             	cmp    $0x19,%cl
40000b01:	77 2d                	ja     40000b30 <strtol+0xd1>
            dig = *s - 'a' + 10;
40000b03:	0f be c0             	movsbl %al,%eax
40000b06:	83 e8 57             	sub    $0x57,%eax
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
40000b09:	39 d8                	cmp    %ebx,%eax
40000b0b:	7d 35                	jge    40000b42 <strtol+0xe3>
            break;
        s++, val = (val * base) + dig;
40000b0d:	83 c2 01             	add    $0x1,%edx
40000b10:	8b 0c 24             	mov    (%esp),%ecx
40000b13:	0f af cb             	imul   %ebx,%ecx
40000b16:	01 c8                	add    %ecx,%eax
40000b18:	89 04 24             	mov    %eax,(%esp)
        if (*s >= '0' && *s <= '9')
40000b1b:	0f b6 02             	movzbl (%edx),%eax
40000b1e:	8d 68 d0             	lea    -0x30(%eax),%ebp
40000b21:	89 e9                	mov    %ebp,%ecx
40000b23:	80 f9 09             	cmp    $0x9,%cl
40000b26:	77 d1                	ja     40000af9 <strtol+0x9a>
            dig = *s - '0';
40000b28:	0f be c0             	movsbl %al,%eax
40000b2b:	83 e8 30             	sub    $0x30,%eax
40000b2e:	eb d9                	jmp    40000b09 <strtol+0xaa>
        else if (*s >= 'A' && *s <= 'Z')
40000b30:	8d 68 bf             	lea    -0x41(%eax),%ebp
40000b33:	89 e9                	mov    %ebp,%ecx
40000b35:	80 f9 19             	cmp    $0x19,%cl
40000b38:	77 08                	ja     40000b42 <strtol+0xe3>
            dig = *s - 'A' + 10;
40000b3a:	0f be c0             	movsbl %al,%eax
40000b3d:	83 e8 37             	sub    $0x37,%eax
40000b40:	eb c7                	jmp    40000b09 <strtol+0xaa>
        // we don't properly detect overflow!
    }

    if (endptr)
40000b42:	85 f6                	test   %esi,%esi
40000b44:	74 02                	je     40000b48 <strtol+0xe9>
        *endptr = (char *) s;
40000b46:	89 16                	mov    %edx,(%esi)
    return (neg ? -val : val);
40000b48:	85 ff                	test   %edi,%edi
40000b4a:	74 03                	je     40000b4f <strtol+0xf0>
40000b4c:	f7 1c 24             	negl   (%esp)
}
40000b4f:	8b 04 24             	mov    (%esp),%eax
40000b52:	83 c4 04             	add    $0x4,%esp
40000b55:	5b                   	pop    %ebx
40000b56:	5e                   	pop    %esi
40000b57:	5f                   	pop    %edi
40000b58:	5d                   	pop    %ebp
40000b59:	c3                   	ret

40000b5a <memset>:

void *memset(void *v, int c, size_t n)
{
40000b5a:	57                   	push   %edi
40000b5b:	53                   	push   %ebx
40000b5c:	8b 7c 24 0c          	mov    0xc(%esp),%edi
40000b60:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    if (n == 0)
40000b64:	85 c9                	test   %ecx,%ecx
40000b66:	74 38                	je     40000ba0 <memset+0x46>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
40000b68:	f7 c7 03 00 00 00    	test   $0x3,%edi
40000b6e:	75 29                	jne    40000b99 <memset+0x3f>
40000b70:	f6 c1 03             	test   $0x3,%cl
40000b73:	75 24                	jne    40000b99 <memset+0x3f>
        c &= 0xFF;
40000b75:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
40000b7a:	8b 44 24 10          	mov    0x10(%esp),%eax
40000b7e:	c1 e0 18             	shl    $0x18,%eax
40000b81:	89 d3                	mov    %edx,%ebx
40000b83:	c1 e3 10             	shl    $0x10,%ebx
40000b86:	09 d8                	or     %ebx,%eax
40000b88:	89 d3                	mov    %edx,%ebx
40000b8a:	c1 e3 08             	shl    $0x8,%ebx
40000b8d:	09 d8                	or     %ebx,%eax
40000b8f:	09 d0                	or     %edx,%eax
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
40000b91:	c1 e9 02             	shr    $0x2,%ecx
        asm volatile ("cld; rep stosl\n"
40000b94:	fc                   	cld
40000b95:	f3 ab                	rep stos %eax,%es:(%edi)
40000b97:	eb 07                	jmp    40000ba0 <memset+0x46>
                      : "cc", "memory");
    } else
        asm volatile ("cld; rep stosb\n"
40000b99:	8b 44 24 10          	mov    0x10(%esp),%eax
40000b9d:	fc                   	cld
40000b9e:	f3 aa                	rep stos %al,%es:(%edi)
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
40000ba0:	89 f8                	mov    %edi,%eax
40000ba2:	5b                   	pop    %ebx
40000ba3:	5f                   	pop    %edi
40000ba4:	c3                   	ret

40000ba5 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
40000ba5:	57                   	push   %edi
40000ba6:	56                   	push   %esi
40000ba7:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000bab:	8b 74 24 10          	mov    0x10(%esp),%esi
40000baf:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
40000bb3:	39 c6                	cmp    %eax,%esi
40000bb5:	73 36                	jae    40000bed <memmove+0x48>
40000bb7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000bba:	39 d0                	cmp    %edx,%eax
40000bbc:	73 2f                	jae    40000bed <memmove+0x48>
        s += n;
        d += n;
40000bbe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000bc1:	f6 c2 03             	test   $0x3,%dl
40000bc4:	75 1b                	jne    40000be1 <memmove+0x3c>
40000bc6:	f7 c7 03 00 00 00    	test   $0x3,%edi
40000bcc:	75 13                	jne    40000be1 <memmove+0x3c>
40000bce:	f6 c1 03             	test   $0x3,%cl
40000bd1:	75 0e                	jne    40000be1 <memmove+0x3c>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
40000bd3:	83 ef 04             	sub    $0x4,%edi
40000bd6:	8d 72 fc             	lea    -0x4(%edx),%esi
40000bd9:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
40000bdc:	fd                   	std
40000bdd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000bdf:	eb 09                	jmp    40000bea <memmove+0x45>
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
40000be1:	83 ef 01             	sub    $0x1,%edi
40000be4:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
40000be7:	fd                   	std
40000be8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
40000bea:	fc                   	cld
40000beb:	eb 20                	jmp    40000c0d <memmove+0x68>
    } else {
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000bed:	f7 c6 03 00 00 00    	test   $0x3,%esi
40000bf3:	75 13                	jne    40000c08 <memmove+0x63>
40000bf5:	a8 03                	test   $0x3,%al
40000bf7:	75 0f                	jne    40000c08 <memmove+0x63>
40000bf9:	f6 c1 03             	test   $0x3,%cl
40000bfc:	75 0a                	jne    40000c08 <memmove+0x63>
            asm volatile ("cld; rep movsl\n"
                          :: "D" (d), "S" (s), "c" (n / 4)
40000bfe:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
40000c01:	89 c7                	mov    %eax,%edi
40000c03:	fc                   	cld
40000c04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000c06:	eb 05                	jmp    40000c0d <memmove+0x68>
                          : "cc", "memory");
        else
            asm volatile ("cld; rep movsb\n"
40000c08:	89 c7                	mov    %eax,%edi
40000c0a:	fc                   	cld
40000c0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
40000c0d:	5e                   	pop    %esi
40000c0e:	5f                   	pop    %edi
40000c0f:	c3                   	ret

40000c10 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
40000c10:	ff 74 24 0c          	push   0xc(%esp)
40000c14:	ff 74 24 0c          	push   0xc(%esp)
40000c18:	ff 74 24 0c          	push   0xc(%esp)
40000c1c:	e8 84 ff ff ff       	call   40000ba5 <memmove>
40000c21:	83 c4 0c             	add    $0xc,%esp
}
40000c24:	c3                   	ret

40000c25 <memcmp>:

int memcmp(const void *v1, const void *v2, size_t n)
{
40000c25:	56                   	push   %esi
40000c26:	53                   	push   %ebx
40000c27:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000c2b:	8b 54 24 10          	mov    0x10(%esp),%edx
40000c2f:	8b 44 24 14          	mov    0x14(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
40000c33:	eb 13                	jmp    40000c48 <memcmp+0x23>
40000c35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c3c:	00 
40000c3d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
40000c40:	83 c1 01             	add    $0x1,%ecx
40000c43:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
40000c46:	89 f0                	mov    %esi,%eax
40000c48:	8d 70 ff             	lea    -0x1(%eax),%esi
40000c4b:	85 c0                	test   %eax,%eax
40000c4d:	74 12                	je     40000c61 <memcmp+0x3c>
        if (*s1 != *s2)
40000c4f:	0f b6 01             	movzbl (%ecx),%eax
40000c52:	0f b6 1a             	movzbl (%edx),%ebx
40000c55:	38 d8                	cmp    %bl,%al
40000c57:	74 e7                	je     40000c40 <memcmp+0x1b>
            return (int) *s1 - (int) *s2;
40000c59:	0f b6 c0             	movzbl %al,%eax
40000c5c:	0f b6 db             	movzbl %bl,%ebx
40000c5f:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
40000c61:	5b                   	pop    %ebx
40000c62:	5e                   	pop    %esi
40000c63:	c3                   	ret

40000c64 <memchr>:

void *memchr(const void *s, int c, size_t n)
{
40000c64:	8b 44 24 04          	mov    0x4(%esp),%eax
40000c68:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    const void *ends = (const char *) s + n;
40000c6c:	89 c2                	mov    %eax,%edx
40000c6e:	03 54 24 0c          	add    0xc(%esp),%edx
    for (; s < ends; s++)
40000c72:	eb 0f                	jmp    40000c83 <memchr+0x1f>
40000c74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000c7b:	00 
40000c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c80:	83 c0 01             	add    $0x1,%eax
40000c83:	39 d0                	cmp    %edx,%eax
40000c85:	73 05                	jae    40000c8c <memchr+0x28>
        if (*(const unsigned char *) s == (unsigned char) c)
40000c87:	38 08                	cmp    %cl,(%eax)
40000c89:	75 f5                	jne    40000c80 <memchr+0x1c>
40000c8b:	c3                   	ret
            return (void *) s;
    return NULL;
40000c8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
40000c91:	c3                   	ret

40000c92 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
40000c92:	ff 74 24 08          	push   0x8(%esp)
40000c96:	6a 00                	push   $0x0
40000c98:	ff 74 24 0c          	push   0xc(%esp)
40000c9c:	e8 b9 fe ff ff       	call   40000b5a <memset>
40000ca1:	83 c4 0c             	add    $0xc,%esp
}
40000ca4:	c3                   	ret

40000ca5 <main>:
#include <proc.h>
#include <stdio.h>
#include <syscall.h>

int main(int argc, char **argv)
{
40000ca5:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000ca9:	83 e4 f0             	and    $0xfffffff0,%esp
40000cac:	ff 71 fc             	push   -0x4(%ecx)
40000caf:	55                   	push   %ebp
40000cb0:	89 e5                	mov    %esp,%ebp
40000cb2:	53                   	push   %ebx
40000cb3:	51                   	push   %ecx
40000cb4:	e8 10 f4 ff ff       	call   400000c9 <__x86.get_pc_thunk.bx>
40000cb9:	81 c3 3b 23 00 00    	add    $0x233b,%ebx
    unsigned int val = 100;
    unsigned int *addr = (unsigned int *) 0xe0000000;

    printf("ping started.\n");
40000cbf:	83 ec 0c             	sub    $0xc,%esp
40000cc2:	8d 83 48 e0 ff ff    	lea    -0x1fb8(%ebx),%eax
40000cc8:	50                   	push   %eax
40000cc9:	e8 53 f5 ff ff       	call   40000221 <printf>
    printf("ping: the value at address %x: %d\n", addr, *addr);
40000cce:	83 c4 0c             	add    $0xc,%esp
40000cd1:	ff 35 00 00 00 e0    	push   0xe0000000
40000cd7:	68 00 00 00 e0       	push   $0xe0000000
40000cdc:	8d 83 b0 e1 ff ff    	lea    -0x1e50(%ebx),%eax
40000ce2:	50                   	push   %eax
40000ce3:	e8 39 f5 ff ff       	call   40000221 <printf>
    printf("ping: writing the value %d to the address %x\n", val, addr);
40000ce8:	83 c4 0c             	add    $0xc,%esp
40000ceb:	68 00 00 00 e0       	push   $0xe0000000
40000cf0:	6a 64                	push   $0x64
40000cf2:	8d 83 d4 e1 ff ff    	lea    -0x1e2c(%ebx),%eax
40000cf8:	50                   	push   %eax
40000cf9:	e8 23 f5 ff ff       	call   40000221 <printf>
    *addr = val;
40000cfe:	c7 05 00 00 00 e0 64 	movl   $0x64,0xe0000000
40000d05:	00 00 00 
    yield();
40000d08:	e8 0e fb ff ff       	call   4000081b <yield>
    printf("ping: the new value at address %x: %d\n", addr, *addr);
40000d0d:	83 c4 0c             	add    $0xc,%esp
40000d10:	ff 35 00 00 00 e0    	push   0xe0000000
40000d16:	68 00 00 00 e0       	push   $0xe0000000
40000d1b:	8d 83 04 e2 ff ff    	lea    -0x1dfc(%ebx),%eax
40000d21:	50                   	push   %eax
40000d22:	e8 fa f4 ff ff       	call   40000221 <printf>

    return 0;
}
40000d27:	83 c4 10             	add    $0x10,%esp
40000d2a:	b8 00 00 00 00       	mov    $0x0,%eax
40000d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
40000d32:	59                   	pop    %ecx
40000d33:	5b                   	pop    %ebx
40000d34:	5d                   	pop    %ebp
40000d35:	8d 61 fc             	lea    -0x4(%ecx),%esp
40000d38:	c3                   	ret
40000d39:	66 90                	xchg   %ax,%ax
40000d3b:	66 90                	xchg   %ax,%ax
40000d3d:	66 90                	xchg   %ax,%ax
40000d3f:	90                   	nop

40000d40 <__udivdi3>:
40000d40:	f3 0f 1e fb          	endbr32
40000d44:	55                   	push   %ebp
40000d45:	57                   	push   %edi
40000d46:	56                   	push   %esi
40000d47:	53                   	push   %ebx
40000d48:	83 ec 1c             	sub    $0x1c,%esp
40000d4b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
40000d4f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40000d53:	8b 74 24 34          	mov    0x34(%esp),%esi
40000d57:	8b 5c 24 38          	mov    0x38(%esp),%ebx
40000d5b:	85 c0                	test   %eax,%eax
40000d5d:	75 19                	jne    40000d78 <__udivdi3+0x38>
40000d5f:	39 de                	cmp    %ebx,%esi
40000d61:	73 4d                	jae    40000db0 <__udivdi3+0x70>
40000d63:	31 ff                	xor    %edi,%edi
40000d65:	89 e8                	mov    %ebp,%eax
40000d67:	89 f2                	mov    %esi,%edx
40000d69:	f7 f3                	div    %ebx
40000d6b:	89 fa                	mov    %edi,%edx
40000d6d:	83 c4 1c             	add    $0x1c,%esp
40000d70:	5b                   	pop    %ebx
40000d71:	5e                   	pop    %esi
40000d72:	5f                   	pop    %edi
40000d73:	5d                   	pop    %ebp
40000d74:	c3                   	ret
40000d75:	8d 76 00             	lea    0x0(%esi),%esi
40000d78:	39 c6                	cmp    %eax,%esi
40000d7a:	73 14                	jae    40000d90 <__udivdi3+0x50>
40000d7c:	31 ff                	xor    %edi,%edi
40000d7e:	31 c0                	xor    %eax,%eax
40000d80:	89 fa                	mov    %edi,%edx
40000d82:	83 c4 1c             	add    $0x1c,%esp
40000d85:	5b                   	pop    %ebx
40000d86:	5e                   	pop    %esi
40000d87:	5f                   	pop    %edi
40000d88:	5d                   	pop    %ebp
40000d89:	c3                   	ret
40000d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000d90:	0f bd f8             	bsr    %eax,%edi
40000d93:	83 f7 1f             	xor    $0x1f,%edi
40000d96:	75 48                	jne    40000de0 <__udivdi3+0xa0>
40000d98:	39 f0                	cmp    %esi,%eax
40000d9a:	72 06                	jb     40000da2 <__udivdi3+0x62>
40000d9c:	31 c0                	xor    %eax,%eax
40000d9e:	39 dd                	cmp    %ebx,%ebp
40000da0:	72 de                	jb     40000d80 <__udivdi3+0x40>
40000da2:	b8 01 00 00 00       	mov    $0x1,%eax
40000da7:	eb d7                	jmp    40000d80 <__udivdi3+0x40>
40000da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000db0:	89 d9                	mov    %ebx,%ecx
40000db2:	85 db                	test   %ebx,%ebx
40000db4:	75 0b                	jne    40000dc1 <__udivdi3+0x81>
40000db6:	b8 01 00 00 00       	mov    $0x1,%eax
40000dbb:	31 d2                	xor    %edx,%edx
40000dbd:	f7 f3                	div    %ebx
40000dbf:	89 c1                	mov    %eax,%ecx
40000dc1:	31 d2                	xor    %edx,%edx
40000dc3:	89 f0                	mov    %esi,%eax
40000dc5:	f7 f1                	div    %ecx
40000dc7:	89 c6                	mov    %eax,%esi
40000dc9:	89 e8                	mov    %ebp,%eax
40000dcb:	89 f7                	mov    %esi,%edi
40000dcd:	f7 f1                	div    %ecx
40000dcf:	89 fa                	mov    %edi,%edx
40000dd1:	83 c4 1c             	add    $0x1c,%esp
40000dd4:	5b                   	pop    %ebx
40000dd5:	5e                   	pop    %esi
40000dd6:	5f                   	pop    %edi
40000dd7:	5d                   	pop    %ebp
40000dd8:	c3                   	ret
40000dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000de0:	89 f9                	mov    %edi,%ecx
40000de2:	ba 20 00 00 00       	mov    $0x20,%edx
40000de7:	29 fa                	sub    %edi,%edx
40000de9:	d3 e0                	shl    %cl,%eax
40000deb:	89 44 24 08          	mov    %eax,0x8(%esp)
40000def:	89 d1                	mov    %edx,%ecx
40000df1:	89 d8                	mov    %ebx,%eax
40000df3:	d3 e8                	shr    %cl,%eax
40000df5:	89 c1                	mov    %eax,%ecx
40000df7:	8b 44 24 08          	mov    0x8(%esp),%eax
40000dfb:	09 c1                	or     %eax,%ecx
40000dfd:	89 f0                	mov    %esi,%eax
40000dff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000e03:	89 f9                	mov    %edi,%ecx
40000e05:	d3 e3                	shl    %cl,%ebx
40000e07:	89 d1                	mov    %edx,%ecx
40000e09:	d3 e8                	shr    %cl,%eax
40000e0b:	89 f9                	mov    %edi,%ecx
40000e0d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
40000e11:	89 eb                	mov    %ebp,%ebx
40000e13:	d3 e6                	shl    %cl,%esi
40000e15:	89 d1                	mov    %edx,%ecx
40000e17:	d3 eb                	shr    %cl,%ebx
40000e19:	09 f3                	or     %esi,%ebx
40000e1b:	89 c6                	mov    %eax,%esi
40000e1d:	89 f2                	mov    %esi,%edx
40000e1f:	89 d8                	mov    %ebx,%eax
40000e21:	f7 74 24 08          	divl   0x8(%esp)
40000e25:	89 d6                	mov    %edx,%esi
40000e27:	89 c3                	mov    %eax,%ebx
40000e29:	f7 64 24 0c          	mull   0xc(%esp)
40000e2d:	39 d6                	cmp    %edx,%esi
40000e2f:	72 1f                	jb     40000e50 <__udivdi3+0x110>
40000e31:	89 f9                	mov    %edi,%ecx
40000e33:	d3 e5                	shl    %cl,%ebp
40000e35:	39 c5                	cmp    %eax,%ebp
40000e37:	73 04                	jae    40000e3d <__udivdi3+0xfd>
40000e39:	39 d6                	cmp    %edx,%esi
40000e3b:	74 13                	je     40000e50 <__udivdi3+0x110>
40000e3d:	89 d8                	mov    %ebx,%eax
40000e3f:	31 ff                	xor    %edi,%edi
40000e41:	e9 3a ff ff ff       	jmp    40000d80 <__udivdi3+0x40>
40000e46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000e4d:	00 
40000e4e:	66 90                	xchg   %ax,%ax
40000e50:	8d 43 ff             	lea    -0x1(%ebx),%eax
40000e53:	31 ff                	xor    %edi,%edi
40000e55:	e9 26 ff ff ff       	jmp    40000d80 <__udivdi3+0x40>
40000e5a:	66 90                	xchg   %ax,%ax
40000e5c:	66 90                	xchg   %ax,%ax
40000e5e:	66 90                	xchg   %ax,%ax

40000e60 <__umoddi3>:
40000e60:	f3 0f 1e fb          	endbr32
40000e64:	55                   	push   %ebp
40000e65:	57                   	push   %edi
40000e66:	56                   	push   %esi
40000e67:	53                   	push   %ebx
40000e68:	83 ec 1c             	sub    $0x1c,%esp
40000e6b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40000e6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
40000e73:	8b 74 24 30          	mov    0x30(%esp),%esi
40000e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000e7b:	89 da                	mov    %ebx,%edx
40000e7d:	85 c0                	test   %eax,%eax
40000e7f:	75 17                	jne    40000e98 <__umoddi3+0x38>
40000e81:	39 fb                	cmp    %edi,%ebx
40000e83:	73 53                	jae    40000ed8 <__umoddi3+0x78>
40000e85:	89 f0                	mov    %esi,%eax
40000e87:	f7 f7                	div    %edi
40000e89:	89 d0                	mov    %edx,%eax
40000e8b:	31 d2                	xor    %edx,%edx
40000e8d:	83 c4 1c             	add    $0x1c,%esp
40000e90:	5b                   	pop    %ebx
40000e91:	5e                   	pop    %esi
40000e92:	5f                   	pop    %edi
40000e93:	5d                   	pop    %ebp
40000e94:	c3                   	ret
40000e95:	8d 76 00             	lea    0x0(%esi),%esi
40000e98:	89 f1                	mov    %esi,%ecx
40000e9a:	39 c3                	cmp    %eax,%ebx
40000e9c:	73 12                	jae    40000eb0 <__umoddi3+0x50>
40000e9e:	89 f0                	mov    %esi,%eax
40000ea0:	83 c4 1c             	add    $0x1c,%esp
40000ea3:	5b                   	pop    %ebx
40000ea4:	5e                   	pop    %esi
40000ea5:	5f                   	pop    %edi
40000ea6:	5d                   	pop    %ebp
40000ea7:	c3                   	ret
40000ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
40000eaf:	00 
40000eb0:	0f bd e8             	bsr    %eax,%ebp
40000eb3:	83 f5 1f             	xor    $0x1f,%ebp
40000eb6:	75 48                	jne    40000f00 <__umoddi3+0xa0>
40000eb8:	39 d8                	cmp    %ebx,%eax
40000eba:	0f 82 d8 00 00 00    	jb     40000f98 <__umoddi3+0x138>
40000ec0:	39 fe                	cmp    %edi,%esi
40000ec2:	0f 83 d0 00 00 00    	jae    40000f98 <__umoddi3+0x138>
40000ec8:	89 c8                	mov    %ecx,%eax
40000eca:	83 c4 1c             	add    $0x1c,%esp
40000ecd:	5b                   	pop    %ebx
40000ece:	5e                   	pop    %esi
40000ecf:	5f                   	pop    %edi
40000ed0:	5d                   	pop    %ebp
40000ed1:	c3                   	ret
40000ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ed8:	89 f9                	mov    %edi,%ecx
40000eda:	85 ff                	test   %edi,%edi
40000edc:	75 0b                	jne    40000ee9 <__umoddi3+0x89>
40000ede:	b8 01 00 00 00       	mov    $0x1,%eax
40000ee3:	31 d2                	xor    %edx,%edx
40000ee5:	f7 f7                	div    %edi
40000ee7:	89 c1                	mov    %eax,%ecx
40000ee9:	89 d8                	mov    %ebx,%eax
40000eeb:	31 d2                	xor    %edx,%edx
40000eed:	f7 f1                	div    %ecx
40000eef:	89 f0                	mov    %esi,%eax
40000ef1:	f7 f1                	div    %ecx
40000ef3:	89 d0                	mov    %edx,%eax
40000ef5:	31 d2                	xor    %edx,%edx
40000ef7:	eb 94                	jmp    40000e8d <__umoddi3+0x2d>
40000ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f00:	ba 20 00 00 00       	mov    $0x20,%edx
40000f05:	89 e9                	mov    %ebp,%ecx
40000f07:	29 ea                	sub    %ebp,%edx
40000f09:	d3 e0                	shl    %cl,%eax
40000f0b:	89 54 24 04          	mov    %edx,0x4(%esp)
40000f0f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
40000f14:	89 44 24 08          	mov    %eax,0x8(%esp)
40000f18:	89 f8                	mov    %edi,%eax
40000f1a:	8b 54 24 04          	mov    0x4(%esp),%edx
40000f1e:	d3 e8                	shr    %cl,%eax
40000f20:	89 c1                	mov    %eax,%ecx
40000f22:	8b 44 24 08          	mov    0x8(%esp),%eax
40000f26:	09 c1                	or     %eax,%ecx
40000f28:	89 d8                	mov    %ebx,%eax
40000f2a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000f2e:	89 e9                	mov    %ebp,%ecx
40000f30:	d3 e7                	shl    %cl,%edi
40000f32:	89 d1                	mov    %edx,%ecx
40000f34:	d3 e8                	shr    %cl,%eax
40000f36:	89 e9                	mov    %ebp,%ecx
40000f38:	89 7c 24 0c          	mov    %edi,0xc(%esp)
40000f3c:	d3 e3                	shl    %cl,%ebx
40000f3e:	89 c7                	mov    %eax,%edi
40000f40:	89 d1                	mov    %edx,%ecx
40000f42:	89 f0                	mov    %esi,%eax
40000f44:	d3 e8                	shr    %cl,%eax
40000f46:	89 fa                	mov    %edi,%edx
40000f48:	89 e9                	mov    %ebp,%ecx
40000f4a:	09 d8                	or     %ebx,%eax
40000f4c:	d3 e6                	shl    %cl,%esi
40000f4e:	f7 74 24 08          	divl   0x8(%esp)
40000f52:	89 d3                	mov    %edx,%ebx
40000f54:	f7 64 24 0c          	mull   0xc(%esp)
40000f58:	89 c7                	mov    %eax,%edi
40000f5a:	89 d1                	mov    %edx,%ecx
40000f5c:	39 d3                	cmp    %edx,%ebx
40000f5e:	72 06                	jb     40000f66 <__umoddi3+0x106>
40000f60:	75 10                	jne    40000f72 <__umoddi3+0x112>
40000f62:	39 c6                	cmp    %eax,%esi
40000f64:	73 0c                	jae    40000f72 <__umoddi3+0x112>
40000f66:	2b 44 24 0c          	sub    0xc(%esp),%eax
40000f6a:	1b 54 24 08          	sbb    0x8(%esp),%edx
40000f6e:	89 d1                	mov    %edx,%ecx
40000f70:	89 c7                	mov    %eax,%edi
40000f72:	89 f2                	mov    %esi,%edx
40000f74:	29 fa                	sub    %edi,%edx
40000f76:	19 cb                	sbb    %ecx,%ebx
40000f78:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
40000f7d:	89 d8                	mov    %ebx,%eax
40000f7f:	d3 e0                	shl    %cl,%eax
40000f81:	89 e9                	mov    %ebp,%ecx
40000f83:	d3 ea                	shr    %cl,%edx
40000f85:	d3 eb                	shr    %cl,%ebx
40000f87:	09 d0                	or     %edx,%eax
40000f89:	89 da                	mov    %ebx,%edx
40000f8b:	83 c4 1c             	add    $0x1c,%esp
40000f8e:	5b                   	pop    %ebx
40000f8f:	5e                   	pop    %esi
40000f90:	5f                   	pop    %edi
40000f91:	5d                   	pop    %ebp
40000f92:	c3                   	ret
40000f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
40000f98:	89 da                	mov    %ebx,%edx
40000f9a:	89 f1                	mov    %esi,%ecx
40000f9c:	29 f9                	sub    %edi,%ecx
40000f9e:	19 c2                	sbb    %eax,%edx
40000fa0:	89 c8                	mov    %ecx,%eax
40000fa2:	e9 23 ff ff ff       	jmp    40000eca <__umoddi3+0x6a>
