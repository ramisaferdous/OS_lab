
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <video_init>:

static unsigned addr_6845;
static struct video terminal;

void video_init(void)
{
  100000:	57                   	push   %edi
  100001:	56                   	push   %esi
  100002:	53                   	push   %ebx
  100003:	e8 35 03 00 00       	call   10033d <__x86.get_pc_thunk.bx>
  100008:	81 c3 ec ef 00 00    	add    $0xefec,%ebx
    uint16_t was;
    unsigned pos;

    /* Get a pointer to the memory-mapped text display buffer. */
    cp = (uint16_t *) CGA_BUF;
    was = *cp;
  10000e:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
    *cp = (uint16_t) 0xA55A;
  100015:	66 c7 05 00 80 0b 00 	movw   $0xa55a,0xb8000
  10001c:	5a a5 
    if (*cp != 0xA55A) {
  10001e:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  100025:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100029:	0f 84 91 00 00 00    	je     1000c0 <video_init+0xc0>
        cp = (uint16_t *) MONO_BUF;
        addr_6845 = MONO_BASE;
  10002f:	c7 83 18 90 02 00 b4 	movl   $0x3b4,0x29018(%ebx)
  100036:	03 00 00 
        dprintf("addr_6845:%x\n", addr_6845);
  100039:	83 ec 08             	sub    $0x8,%esp
  10003c:	68 b4 03 00 00       	push   $0x3b4
  100041:	8d 83 0c 90 ff ff    	lea    -0x6ff4(%ebx),%eax
  100047:	50                   	push   %eax
  100048:	e8 55 2b 00 00       	call   102ba2 <dprintf>
  10004d:	83 c4 10             	add    $0x10,%esp
        cp = (uint16_t *) MONO_BUF;
  100050:	be 00 00 0b 00       	mov    $0xb0000,%esi
        addr_6845 = CGA_BASE;
        dprintf("addr_6845:%x\n", addr_6845);
    }

    /* Extract cursor location */
    outb(addr_6845, 14);
  100055:	83 ec 08             	sub    $0x8,%esp
  100058:	6a 0e                	push   $0xe
  10005a:	ff b3 18 90 02 00    	push   0x29018(%ebx)
  100060:	e8 be 35 00 00       	call   103623 <outb>
    pos = inb(addr_6845 + 1) << 8;
  100065:	8b 83 18 90 02 00    	mov    0x29018(%ebx),%eax
  10006b:	83 c0 01             	add    $0x1,%eax
  10006e:	89 04 24             	mov    %eax,(%esp)
  100071:	e8 95 35 00 00       	call   10360b <inb>
  100076:	0f b6 f8             	movzbl %al,%edi
  100079:	c1 e7 08             	shl    $0x8,%edi
    outb(addr_6845, 15);
  10007c:	83 c4 08             	add    $0x8,%esp
  10007f:	6a 0f                	push   $0xf
  100081:	ff b3 18 90 02 00    	push   0x29018(%ebx)
  100087:	e8 97 35 00 00       	call   103623 <outb>
    pos |= inb(addr_6845 + 1);
  10008c:	8b 83 18 90 02 00    	mov    0x29018(%ebx),%eax
  100092:	83 c0 01             	add    $0x1,%eax
  100095:	89 04 24             	mov    %eax,(%esp)
  100098:	e8 6e 35 00 00       	call   10360b <inb>
  10009d:	0f b6 c0             	movzbl %al,%eax
  1000a0:	09 f8                	or     %edi,%eax

    terminal.crt_buf = (uint16_t *) cp;
  1000a2:	89 b3 0c 90 02 00    	mov    %esi,0x2900c(%ebx)
    terminal.crt_pos = pos;
  1000a8:	66 89 83 10 90 02 00 	mov    %ax,0x29010(%ebx)
    terminal.active_console = 0;
  1000af:	c7 83 14 90 02 00 00 	movl   $0x0,0x29014(%ebx)
  1000b6:	00 00 00 
}
  1000b9:	83 c4 10             	add    $0x10,%esp
  1000bc:	5b                   	pop    %ebx
  1000bd:	5e                   	pop    %esi
  1000be:	5f                   	pop    %edi
  1000bf:	c3                   	ret
        *cp = was;
  1000c0:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
        addr_6845 = CGA_BASE;
  1000c7:	c7 83 18 90 02 00 d4 	movl   $0x3d4,0x29018(%ebx)
  1000ce:	03 00 00 
        dprintf("addr_6845:%x\n", addr_6845);
  1000d1:	83 ec 08             	sub    $0x8,%esp
  1000d4:	68 d4 03 00 00       	push   $0x3d4
  1000d9:	8d 83 0c 90 ff ff    	lea    -0x6ff4(%ebx),%eax
  1000df:	50                   	push   %eax
  1000e0:	e8 bd 2a 00 00       	call   102ba2 <dprintf>
  1000e5:	83 c4 10             	add    $0x10,%esp
    cp = (uint16_t *) CGA_BUF;
  1000e8:	be 00 80 0b 00       	mov    $0xb8000,%esi
  1000ed:	e9 63 ff ff ff       	jmp    100055 <video_init+0x55>

001000f2 <video_putc>:

void video_putc(int c)
{
  1000f2:	53                   	push   %ebx
  1000f3:	83 ec 08             	sub    $0x8,%esp
  1000f6:	e8 42 02 00 00       	call   10033d <__x86.get_pc_thunk.bx>
  1000fb:	81 c3 f9 ee 00 00    	add    $0xeef9,%ebx
  100101:	8b 44 24 10          	mov    0x10(%esp),%eax
    // if no attribute given, then use black on white
    if (!(c & ~0xFF))
  100105:	3d ff 00 00 00       	cmp    $0xff,%eax
  10010a:	77 03                	ja     10010f <video_putc+0x1d>
        c |= 0x0700;
  10010c:	80 cc 07             	or     $0x7,%ah

    switch (c & 0xff) {
  10010f:	0f b6 d0             	movzbl %al,%edx
  100112:	3c 0a                	cmp    $0xa,%al
  100114:	0f 84 12 01 00 00    	je     10022c <video_putc+0x13a>
  10011a:	83 fa 0a             	cmp    $0xa,%edx
  10011d:	7f 51                	jg     100170 <video_putc+0x7e>
  10011f:	83 fa 08             	cmp    $0x8,%edx
  100122:	0f 84 d6 00 00 00    	je     1001fe <video_putc+0x10c>
  100128:	83 fa 09             	cmp    $0x9,%edx
  10012b:	0f 85 11 01 00 00    	jne    100242 <video_putc+0x150>
        /* fallthru */
    case '\r':
        terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
        break;
    case '\t':
        video_putc(' ');
  100131:	83 ec 0c             	sub    $0xc,%esp
  100134:	6a 20                	push   $0x20
  100136:	e8 b7 ff ff ff       	call   1000f2 <video_putc>
        video_putc(' ');
  10013b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100142:	e8 ab ff ff ff       	call   1000f2 <video_putc>
        video_putc(' ');
  100147:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10014e:	e8 9f ff ff ff       	call   1000f2 <video_putc>
        video_putc(' ');
  100153:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10015a:	e8 93 ff ff ff       	call   1000f2 <video_putc>
        video_putc(' ');
  10015f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100166:	e8 87 ff ff ff       	call   1000f2 <video_putc>
        break;
  10016b:	83 c4 10             	add    $0x10,%esp
  10016e:	eb 26                	jmp    100196 <video_putc+0xa4>
    switch (c & 0xff) {
  100170:	83 fa 0d             	cmp    $0xd,%edx
  100173:	0f 85 c9 00 00 00    	jne    100242 <video_putc+0x150>
        terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
  100179:	0f b7 83 10 90 02 00 	movzwl 0x29010(%ebx),%eax
  100180:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100186:	c1 e8 16             	shr    $0x16,%eax
  100189:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10018c:	c1 e0 04             	shl    $0x4,%eax
  10018f:	66 89 83 10 90 02 00 	mov    %ax,0x29010(%ebx)
    default:
        terminal.crt_buf[terminal.crt_pos++] = c;  /* write the character */
        break;
    }

    if (terminal.crt_pos >= CRT_SIZE) {
  100196:	66 81 bb 10 90 02 00 	cmpw   $0x7cf,0x29010(%ebx)
  10019d:	cf 07 
  10019f:	0f 87 c1 00 00 00    	ja     100266 <video_putc+0x174>
            terminal.crt_buf[i] = 0x0700 | ' ';
        terminal.crt_pos -= CRT_COLS;
    }

    /* move that little blinky thing */
    outb(addr_6845, 14);
  1001a5:	83 ec 08             	sub    $0x8,%esp
  1001a8:	6a 0e                	push   $0xe
  1001aa:	ff b3 18 90 02 00    	push   0x29018(%ebx)
  1001b0:	e8 6e 34 00 00       	call   103623 <outb>
    outb(addr_6845 + 1, terminal.crt_pos >> 8);
  1001b5:	8b 83 18 90 02 00    	mov    0x29018(%ebx),%eax
  1001bb:	83 c0 01             	add    $0x1,%eax
  1001be:	83 c4 08             	add    $0x8,%esp
  1001c1:	0f b6 93 11 90 02 00 	movzbl 0x29011(%ebx),%edx
  1001c8:	52                   	push   %edx
  1001c9:	50                   	push   %eax
  1001ca:	e8 54 34 00 00       	call   103623 <outb>
    outb(addr_6845, 15);
  1001cf:	83 c4 08             	add    $0x8,%esp
  1001d2:	6a 0f                	push   $0xf
  1001d4:	ff b3 18 90 02 00    	push   0x29018(%ebx)
  1001da:	e8 44 34 00 00       	call   103623 <outb>
    outb(addr_6845 + 1, terminal.crt_pos);
  1001df:	8b 83 18 90 02 00    	mov    0x29018(%ebx),%eax
  1001e5:	83 c0 01             	add    $0x1,%eax
  1001e8:	83 c4 08             	add    $0x8,%esp
  1001eb:	0f b6 93 10 90 02 00 	movzbl 0x29010(%ebx),%edx
  1001f2:	52                   	push   %edx
  1001f3:	50                   	push   %eax
  1001f4:	e8 2a 34 00 00       	call   103623 <outb>
}
  1001f9:	83 c4 18             	add    $0x18,%esp
  1001fc:	5b                   	pop    %ebx
  1001fd:	c3                   	ret
        if (terminal.crt_pos > 0) {
  1001fe:	0f b7 93 10 90 02 00 	movzwl 0x29010(%ebx),%edx
  100205:	66 85 d2             	test   %dx,%dx
  100208:	74 8c                	je     100196 <video_putc+0xa4>
            terminal.crt_pos--;
  10020a:	83 ea 01             	sub    $0x1,%edx
  10020d:	66 89 93 10 90 02 00 	mov    %dx,0x29010(%ebx)
            terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  100214:	b0 00                	mov    $0x0,%al
  100216:	0f b7 d2             	movzwl %dx,%edx
  100219:	01 d2                	add    %edx,%edx
  10021b:	03 93 0c 90 02 00    	add    0x2900c(%ebx),%edx
  100221:	83 c8 20             	or     $0x20,%eax
  100224:	66 89 02             	mov    %ax,(%edx)
  100227:	e9 6a ff ff ff       	jmp    100196 <video_putc+0xa4>
        terminal.crt_pos += CRT_COLS;
  10022c:	0f b7 83 10 90 02 00 	movzwl 0x29010(%ebx),%eax
  100233:	83 c0 50             	add    $0x50,%eax
  100236:	66 89 83 10 90 02 00 	mov    %ax,0x29010(%ebx)
  10023d:	e9 37 ff ff ff       	jmp    100179 <video_putc+0x87>
        terminal.crt_buf[terminal.crt_pos++] = c;  /* write the character */
  100242:	0f b7 93 10 90 02 00 	movzwl 0x29010(%ebx),%edx
  100249:	8d 4a 01             	lea    0x1(%edx),%ecx
  10024c:	66 89 8b 10 90 02 00 	mov    %cx,0x29010(%ebx)
  100253:	0f b7 d2             	movzwl %dx,%edx
  100256:	01 d2                	add    %edx,%edx
  100258:	03 93 0c 90 02 00    	add    0x2900c(%ebx),%edx
  10025e:	66 89 02             	mov    %ax,(%edx)
        break;
  100261:	e9 30 ff ff ff       	jmp    100196 <video_putc+0xa4>
        memmove(terminal.crt_buf, terminal.crt_buf + CRT_COLS,
  100266:	8b 83 0c 90 02 00    	mov    0x2900c(%ebx),%eax
  10026c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  100272:	83 ec 04             	sub    $0x4,%esp
  100275:	68 00 0f 00 00       	push   $0xf00
  10027a:	52                   	push   %edx
  10027b:	50                   	push   %eax
  10027c:	e8 8a 25 00 00       	call   10280b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  100281:	83 c4 10             	add    $0x10,%esp
  100284:	b8 80 07 00 00       	mov    $0x780,%eax
  100289:	eb 26                	jmp    1002b1 <video_putc+0x1bf>
  10028b:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  100292:	00 
  100293:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10029a:	00 
  10029b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            terminal.crt_buf[i] = 0x0700 | ' ';
  1002a0:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1002a3:	03 93 0c 90 02 00    	add    0x2900c(%ebx),%edx
  1002a9:	66 c7 02 20 07       	movw   $0x720,(%edx)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  1002ae:	83 c0 01             	add    $0x1,%eax
  1002b1:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1002b6:	7e e8                	jle    1002a0 <video_putc+0x1ae>
        terminal.crt_pos -= CRT_COLS;
  1002b8:	0f b7 83 10 90 02 00 	movzwl 0x29010(%ebx),%eax
  1002bf:	83 e8 50             	sub    $0x50,%eax
  1002c2:	66 89 83 10 90 02 00 	mov    %ax,0x29010(%ebx)
  1002c9:	e9 d7 fe ff ff       	jmp    1001a5 <video_putc+0xb3>

001002ce <video_set_cursor>:

void video_set_cursor(int x, int y)
{
  1002ce:	e8 66 00 00 00       	call   100339 <__x86.get_pc_thunk.cx>
  1002d3:	81 c1 21 ed 00 00    	add    $0xed21,%ecx
  1002d9:	8b 44 24 04          	mov    0x4(%esp),%eax
    terminal.crt_pos = x * CRT_COLS + y;
  1002dd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1002e0:	c1 e0 04             	shl    $0x4,%eax
  1002e3:	89 c2                	mov    %eax,%edx
  1002e5:	66 03 54 24 08       	add    0x8(%esp),%dx
  1002ea:	66 89 91 10 90 02 00 	mov    %dx,0x29010(%ecx)
}
  1002f1:	c3                   	ret

001002f2 <video_clear_screen>:

void video_clear_screen()
{
  1002f2:	e8 42 00 00 00       	call   100339 <__x86.get_pc_thunk.cx>
  1002f7:	81 c1 fd ec 00 00    	add    $0xecfd,%ecx
    int i;
    for (i = 0; i < CRT_SIZE; i++) {
  1002fd:	b8 00 00 00 00       	mov    $0x0,%eax
  100302:	eb 2d                	jmp    100331 <video_clear_screen+0x3f>
  100304:	eb 1a                	jmp    100320 <video_clear_screen+0x2e>
  100306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10030d:	00 
  10030e:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  100315:	00 
  100316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10031d:	00 
  10031e:	66 90                	xchg   %ax,%ax
        terminal.crt_buf[i] = ' ';
  100320:	8d 14 00             	lea    (%eax,%eax,1),%edx
  100323:	03 91 0c 90 02 00    	add    0x2900c(%ecx),%edx
  100329:	66 c7 02 20 00       	movw   $0x20,(%edx)
    for (i = 0; i < CRT_SIZE; i++) {
  10032e:	83 c0 01             	add    $0x1,%eax
  100331:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  100336:	7e e8                	jle    100320 <video_clear_screen+0x2e>
    }
}
  100338:	c3                   	ret

00100339 <__x86.get_pc_thunk.cx>:
  100339:	8b 0c 24             	mov    (%esp),%ecx
  10033c:	c3                   	ret

0010033d <__x86.get_pc_thunk.bx>:
  10033d:	8b 1c 24             	mov    (%esp),%ebx
  100340:	c3                   	ret

00100341 <cons_init>:
    char buf[CONSOLE_BUFFER_SIZE];
    uint32_t rpos, wpos;
} cons;

void cons_init()
{
  100341:	53                   	push   %ebx
  100342:	83 ec 0c             	sub    $0xc,%esp
  100345:	e8 f3 ff ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10034a:	81 c3 aa ec 00 00    	add    $0xecaa,%ebx
    memset(&cons, 0x0, sizeof(cons));
  100350:	68 08 02 00 00       	push   $0x208
  100355:	6a 00                	push   $0x0
  100357:	8d 83 2c 90 02 00    	lea    0x2902c(%ebx),%eax
  10035d:	50                   	push   %eax
  10035e:	e8 5d 24 00 00       	call   1027c0 <memset>
    serial_init();
  100363:	e8 48 03 00 00       	call   1006b0 <serial_init>
    video_init();
  100368:	e8 93 fc ff ff       	call   100000 <video_init>
}
  10036d:	83 c4 18             	add    $0x18,%esp
  100370:	5b                   	pop    %ebx
  100371:	c3                   	ret

00100372 <cons_intr>:

void cons_intr(int (*proc)(void))
{
  100372:	56                   	push   %esi
  100373:	53                   	push   %ebx
  100374:	83 ec 04             	sub    $0x4,%esp
  100377:	e8 c1 ff ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10037c:	81 c3 78 ec 00 00    	add    $0xec78,%ebx
  100382:	8b 74 24 10          	mov    0x10(%esp),%esi
    int c;

    while ((c = (*proc)()) != -1) {
  100386:	ff d6                	call   *%esi
  100388:	83 f8 ff             	cmp    $0xffffffff,%eax
  10038b:	74 2e                	je     1003bb <cons_intr+0x49>
        if (c == 0)
  10038d:	85 c0                	test   %eax,%eax
  10038f:	74 f5                	je     100386 <cons_intr+0x14>
            continue;
        cons.buf[cons.wpos++] = c;
  100391:	8b 8b 30 92 02 00    	mov    0x29230(%ebx),%ecx
  100397:	8d 51 01             	lea    0x1(%ecx),%edx
  10039a:	89 93 30 92 02 00    	mov    %edx,0x29230(%ebx)
  1003a0:	88 84 0b 2c 90 02 00 	mov    %al,0x2902c(%ebx,%ecx,1)
        if (cons.wpos == CONSOLE_BUFFER_SIZE)
  1003a7:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  1003ad:	75 d7                	jne    100386 <cons_intr+0x14>
            cons.wpos = 0;
  1003af:	c7 83 30 92 02 00 00 	movl   $0x0,0x29230(%ebx)
  1003b6:	00 00 00 
  1003b9:	eb cb                	jmp    100386 <cons_intr+0x14>
    }
}
  1003bb:	83 c4 04             	add    $0x4,%esp
  1003be:	5b                   	pop    %ebx
  1003bf:	5e                   	pop    %esi
  1003c0:	c3                   	ret

001003c1 <cons_getc>:

char cons_getc(void)
{
  1003c1:	53                   	push   %ebx
  1003c2:	83 ec 08             	sub    $0x8,%esp
  1003c5:	e8 73 ff ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1003ca:	81 c3 2a ec 00 00    	add    $0xec2a,%ebx
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1003d0:	e8 35 02 00 00       	call   10060a <serial_intr>
    keyboard_intr();
  1003d5:	e8 e7 04 00 00       	call   1008c1 <keyboard_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1003da:	8b 83 2c 92 02 00    	mov    0x2922c(%ebx),%eax
  1003e0:	3b 83 30 92 02 00    	cmp    0x29230(%ebx),%eax
  1003e6:	74 25                	je     10040d <cons_getc+0x4c>
        c = cons.buf[cons.rpos++];
  1003e8:	8d 50 01             	lea    0x1(%eax),%edx
  1003eb:	89 93 2c 92 02 00    	mov    %edx,0x2922c(%ebx)
  1003f1:	0f b6 84 03 2c 90 02 	movzbl 0x2902c(%ebx,%eax,1),%eax
  1003f8:	00 
        if (cons.rpos == CONSOLE_BUFFER_SIZE)
  1003f9:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  1003ff:	75 11                	jne    100412 <cons_getc+0x51>
            cons.rpos = 0;
  100401:	c7 83 2c 92 02 00 00 	movl   $0x0,0x2922c(%ebx)
  100408:	00 00 00 
        return c;
  10040b:	eb 05                	jmp    100412 <cons_getc+0x51>
    }
    return 0;
  10040d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100412:	83 c4 08             	add    $0x8,%esp
  100415:	5b                   	pop    %ebx
  100416:	c3                   	ret

00100417 <cons_putc>:

void cons_putc(char c)
{
  100417:	56                   	push   %esi
  100418:	53                   	push   %ebx
  100419:	83 ec 10             	sub    $0x10,%esp
  10041c:	e8 1c ff ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100421:	81 c3 d3 eb 00 00    	add    $0xebd3,%ebx
    serial_putc(c);
  100427:	0f be 74 24 1c       	movsbl 0x1c(%esp),%esi
  10042c:	56                   	push   %esi
  10042d:	e8 09 02 00 00       	call   10063b <serial_putc>
    video_putc(c);
  100432:	89 34 24             	mov    %esi,(%esp)
  100435:	e8 b8 fc ff ff       	call   1000f2 <video_putc>
}
  10043a:	83 c4 14             	add    $0x14,%esp
  10043d:	5b                   	pop    %ebx
  10043e:	5e                   	pop    %esi
  10043f:	c3                   	ret

00100440 <getchar>:

char getchar(void)
{
  100440:	83 ec 0c             	sub    $0xc,%esp
    char c;

    while ((c = cons_getc()) == 0)
  100443:	e8 79 ff ff ff       	call   1003c1 <cons_getc>
  100448:	84 c0                	test   %al,%al
  10044a:	74 f7                	je     100443 <getchar+0x3>
        /* do nothing */ ;
    return c;
}
  10044c:	83 c4 0c             	add    $0xc,%esp
  10044f:	c3                   	ret

00100450 <putchar>:

void putchar(char c)
{
  100450:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100453:	0f be 44 24 1c       	movsbl 0x1c(%esp),%eax
  100458:	50                   	push   %eax
  100459:	e8 b9 ff ff ff       	call   100417 <cons_putc>
}
  10045e:	83 c4 1c             	add    $0x1c,%esp
  100461:	c3                   	ret

00100462 <readline>:

char *readline(const char *prompt)
{
  100462:	57                   	push   %edi
  100463:	56                   	push   %esi
  100464:	53                   	push   %ebx
  100465:	e8 d9 00 00 00       	call   100543 <__x86.get_pc_thunk.si>
  10046a:	81 c6 8a eb 00 00    	add    $0xeb8a,%esi
  100470:	8b 44 24 10          	mov    0x10(%esp),%eax
    int i;
    char c;

    if (prompt != NULL)
  100474:	85 c0                	test   %eax,%eax
  100476:	74 15                	je     10048d <readline+0x2b>
        dprintf("%s", prompt);
  100478:	83 ec 08             	sub    $0x8,%esp
  10047b:	50                   	push   %eax
  10047c:	8d 86 1a 90 ff ff    	lea    -0x6fe6(%esi),%eax
  100482:	50                   	push   %eax
  100483:	89 f3                	mov    %esi,%ebx
  100485:	e8 18 27 00 00       	call   102ba2 <dprintf>
  10048a:	83 c4 10             	add    $0x10,%esp
        } else if ((c == '\b' || c == '\x7f') && i > 0) {
            putchar('\b');
            i--;
        } else if (c >= ' ' && i < BUFLEN - 1) {
            putchar(c);
            linebuf[i++] = c;
  10048d:	bf 00 00 00 00       	mov    $0x0,%edi
  100492:	eb 44                	jmp    1004d8 <readline+0x76>
            dprintf("read error: %e\n", c);
  100494:	83 ec 08             	sub    $0x8,%esp
  100497:	0f be d8             	movsbl %al,%ebx
  10049a:	53                   	push   %ebx
  10049b:	8d 86 1d 90 ff ff    	lea    -0x6fe3(%esi),%eax
  1004a1:	50                   	push   %eax
  1004a2:	89 f3                	mov    %esi,%ebx
  1004a4:	e8 f9 26 00 00       	call   102ba2 <dprintf>
            return NULL;
  1004a9:	83 c4 10             	add    $0x10,%esp
  1004ac:	b8 00 00 00 00       	mov    $0x0,%eax
            putchar('\n');
            linebuf[i] = 0;
            return linebuf;
        }
    }
}
  1004b1:	5b                   	pop    %ebx
  1004b2:	5e                   	pop    %esi
  1004b3:	5f                   	pop    %edi
  1004b4:	c3                   	ret
        } else if (c >= ' ' && i < BUFLEN - 1) {
  1004b5:	80 fb 1f             	cmp    $0x1f,%bl
  1004b8:	0f 9f c2             	setg   %dl
  1004bb:	81 ff fe 03 00 00    	cmp    $0x3fe,%edi
  1004c1:	0f 9e c0             	setle  %al
  1004c4:	84 c2                	test   %al,%dl
  1004c6:	75 40                	jne    100508 <readline+0xa6>
        } else if (c == '\n' || c == '\r') {
  1004c8:	80 fb 0a             	cmp    $0xa,%bl
  1004cb:	0f 94 c0             	sete   %al
  1004ce:	80 fb 0d             	cmp    $0xd,%bl
  1004d1:	0f 94 c2             	sete   %dl
  1004d4:	08 d0                	or     %dl,%al
  1004d6:	75 4b                	jne    100523 <readline+0xc1>
        c = getchar();
  1004d8:	e8 63 ff ff ff       	call   100440 <getchar>
  1004dd:	89 c3                	mov    %eax,%ebx
        if (c < 0) {
  1004df:	84 c0                	test   %al,%al
  1004e1:	78 b1                	js     100494 <readline+0x32>
        } else if ((c == '\b' || c == '\x7f') && i > 0) {
  1004e3:	3c 08                	cmp    $0x8,%al
  1004e5:	0f 94 c0             	sete   %al
  1004e8:	80 fb 7f             	cmp    $0x7f,%bl
  1004eb:	0f 94 c2             	sete   %dl
  1004ee:	08 d0                	or     %dl,%al
  1004f0:	74 c3                	je     1004b5 <readline+0x53>
  1004f2:	85 ff                	test   %edi,%edi
  1004f4:	7e bf                	jle    1004b5 <readline+0x53>
            putchar('\b');
  1004f6:	83 ec 0c             	sub    $0xc,%esp
  1004f9:	6a 08                	push   $0x8
  1004fb:	e8 50 ff ff ff       	call   100450 <putchar>
            i--;
  100500:	83 ef 01             	sub    $0x1,%edi
  100503:	83 c4 10             	add    $0x10,%esp
  100506:	eb d0                	jmp    1004d8 <readline+0x76>
            putchar(c);
  100508:	83 ec 0c             	sub    $0xc,%esp
  10050b:	0f be c3             	movsbl %bl,%eax
  10050e:	50                   	push   %eax
  10050f:	e8 3c ff ff ff       	call   100450 <putchar>
            linebuf[i++] = c;
  100514:	88 9c 3e 4c 92 02 00 	mov    %bl,0x2924c(%esi,%edi,1)
  10051b:	83 c4 10             	add    $0x10,%esp
  10051e:	8d 7f 01             	lea    0x1(%edi),%edi
  100521:	eb b5                	jmp    1004d8 <readline+0x76>
            putchar('\n');
  100523:	83 ec 0c             	sub    $0xc,%esp
  100526:	6a 0a                	push   $0xa
  100528:	e8 23 ff ff ff       	call   100450 <putchar>
            linebuf[i] = 0;
  10052d:	c6 84 3e 4c 92 02 00 	movb   $0x0,0x2924c(%esi,%edi,1)
  100534:	00 
            return linebuf;
  100535:	83 c4 10             	add    $0x10,%esp
  100538:	8d 86 4c 92 02 00    	lea    0x2924c(%esi),%eax
  10053e:	e9 6e ff ff ff       	jmp    1004b1 <readline+0x4f>

00100543 <__x86.get_pc_thunk.si>:
  100543:	8b 34 24             	mov    (%esp),%esi
  100546:	c3                   	ret

00100547 <serial_proc_data>:
    inb(0x84);
    inb(0x84);
}

static int serial_proc_data(void)
{
  100547:	53                   	push   %ebx
  100548:	83 ec 14             	sub    $0x14,%esp
  10054b:	e8 ed fd ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100550:	81 c3 a4 ea 00 00    	add    $0xeaa4,%ebx
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
  100556:	68 fd 03 00 00       	push   $0x3fd
  10055b:	e8 ab 30 00 00       	call   10360b <inb>
  100560:	83 c4 10             	add    $0x10,%esp
  100563:	a8 01                	test   $0x1,%al
  100565:	74 18                	je     10057f <serial_proc_data+0x38>
        return -1;
    return inb(COM1 + COM_RX);
  100567:	83 ec 0c             	sub    $0xc,%esp
  10056a:	68 f8 03 00 00       	push   $0x3f8
  10056f:	e8 97 30 00 00       	call   10360b <inb>
  100574:	0f b6 c0             	movzbl %al,%eax
  100577:	83 c4 10             	add    $0x10,%esp
}
  10057a:	83 c4 08             	add    $0x8,%esp
  10057d:	5b                   	pop    %ebx
  10057e:	c3                   	ret
        return -1;
  10057f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100584:	eb f4                	jmp    10057a <serial_proc_data+0x33>

00100586 <delay>:
{
  100586:	53                   	push   %ebx
  100587:	83 ec 14             	sub    $0x14,%esp
  10058a:	e8 ae fd ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10058f:	81 c3 65 ea 00 00    	add    $0xea65,%ebx
    inb(0x84);
  100595:	68 84 00 00 00       	push   $0x84
  10059a:	e8 6c 30 00 00       	call   10360b <inb>
    inb(0x84);
  10059f:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  1005a6:	e8 60 30 00 00       	call   10360b <inb>
    inb(0x84);
  1005ab:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  1005b2:	e8 54 30 00 00       	call   10360b <inb>
    inb(0x84);
  1005b7:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  1005be:	e8 48 30 00 00       	call   10360b <inb>
}
  1005c3:	83 c4 18             	add    $0x18,%esp
  1005c6:	5b                   	pop    %ebx
  1005c7:	c3                   	ret

001005c8 <serial_reformatnewline>:
    if (serial_exists)
        cons_intr(serial_proc_data);
}

static int serial_reformatnewline(int c, int p)
{
  1005c8:	56                   	push   %esi
  1005c9:	53                   	push   %ebx
  1005ca:	83 ec 04             	sub    $0x4,%esp
  1005cd:	e8 6b fd ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1005d2:	81 c3 22 ea 00 00    	add    $0xea22,%ebx
    int nl = '\n';
    /* POSIX requires newline on the serial line to
     * be a CR-LF pair. Without this, you get a malformed output
     * with clients like minicom or screen
     */
    if (c == nl) {
  1005d8:	83 f8 0a             	cmp    $0xa,%eax
  1005db:	74 0b                	je     1005e8 <serial_reformatnewline+0x20>
        outb(p, cr);
        outb(p, nl);
        return 1;
    } else
        return 0;
  1005dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1005e2:	83 c4 04             	add    $0x4,%esp
  1005e5:	5b                   	pop    %ebx
  1005e6:	5e                   	pop    %esi
  1005e7:	c3                   	ret
  1005e8:	89 d6                	mov    %edx,%esi
        outb(p, cr);
  1005ea:	83 ec 08             	sub    $0x8,%esp
  1005ed:	6a 0d                	push   $0xd
  1005ef:	52                   	push   %edx
  1005f0:	e8 2e 30 00 00       	call   103623 <outb>
        outb(p, nl);
  1005f5:	83 c4 08             	add    $0x8,%esp
  1005f8:	6a 0a                	push   $0xa
  1005fa:	56                   	push   %esi
  1005fb:	e8 23 30 00 00       	call   103623 <outb>
        return 1;
  100600:	83 c4 10             	add    $0x10,%esp
  100603:	b8 01 00 00 00       	mov    $0x1,%eax
  100608:	eb d8                	jmp    1005e2 <serial_reformatnewline+0x1a>

0010060a <serial_intr>:
{
  10060a:	53                   	push   %ebx
  10060b:	83 ec 08             	sub    $0x8,%esp
  10060e:	e8 2a fd ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100613:	81 c3 e1 e9 00 00    	add    $0xe9e1,%ebx
    if (serial_exists)
  100619:	80 bb 4c 96 02 00 00 	cmpb   $0x0,0x2964c(%ebx)
  100620:	75 05                	jne    100627 <serial_intr+0x1d>
}
  100622:	83 c4 08             	add    $0x8,%esp
  100625:	5b                   	pop    %ebx
  100626:	c3                   	ret
        cons_intr(serial_proc_data);
  100627:	83 ec 0c             	sub    $0xc,%esp
  10062a:	8d 83 53 15 ff ff    	lea    -0xeaad(%ebx),%eax
  100630:	50                   	push   %eax
  100631:	e8 3c fd ff ff       	call   100372 <cons_intr>
  100636:	83 c4 10             	add    $0x10,%esp
}
  100639:	eb e7                	jmp    100622 <serial_intr+0x18>

0010063b <serial_putc>:

void serial_putc(char c)
{
  10063b:	57                   	push   %edi
  10063c:	56                   	push   %esi
  10063d:	53                   	push   %ebx
  10063e:	e8 fa fc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100643:	81 c3 b1 e9 00 00    	add    $0xe9b1,%ebx
  100649:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (!serial_exists)
  10064d:	80 bb 4c 96 02 00 00 	cmpb   $0x0,0x2964c(%ebx)
  100654:	74 3e                	je     100694 <serial_putc+0x59>
        return;

    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  100656:	be 00 00 00 00       	mov    $0x0,%esi
  10065b:	eb 08                	jmp    100665 <serial_putc+0x2a>
        delay();
  10065d:	e8 24 ff ff ff       	call   100586 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  100662:	83 c6 01             	add    $0x1,%esi
  100665:	83 ec 0c             	sub    $0xc,%esp
  100668:	68 fd 03 00 00       	push   $0x3fd
  10066d:	e8 99 2f 00 00       	call   10360b <inb>
  100672:	83 c4 10             	add    $0x10,%esp
  100675:	a8 20                	test   $0x20,%al
  100677:	75 08                	jne    100681 <serial_putc+0x46>
  100679:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  10067f:	7e dc                	jle    10065d <serial_putc+0x22>

    if (!serial_reformatnewline(c, COM1 + COM_TX))
  100681:	89 f8                	mov    %edi,%eax
  100683:	0f be c0             	movsbl %al,%eax
  100686:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10068b:	e8 38 ff ff ff       	call   1005c8 <serial_reformatnewline>
  100690:	85 c0                	test   %eax,%eax
  100692:	74 04                	je     100698 <serial_putc+0x5d>
        outb(COM1 + COM_TX, c);
}
  100694:	5b                   	pop    %ebx
  100695:	5e                   	pop    %esi
  100696:	5f                   	pop    %edi
  100697:	c3                   	ret
        outb(COM1 + COM_TX, c);
  100698:	83 ec 08             	sub    $0x8,%esp
  10069b:	89 f8                	mov    %edi,%eax
  10069d:	0f b6 f8             	movzbl %al,%edi
  1006a0:	57                   	push   %edi
  1006a1:	68 f8 03 00 00       	push   $0x3f8
  1006a6:	e8 78 2f 00 00       	call   103623 <outb>
  1006ab:	83 c4 10             	add    $0x10,%esp
  1006ae:	eb e4                	jmp    100694 <serial_putc+0x59>

001006b0 <serial_init>:

void serial_init(void)
{
  1006b0:	53                   	push   %ebx
  1006b1:	83 ec 10             	sub    $0x10,%esp
  1006b4:	e8 84 fc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1006b9:	81 c3 3b e9 00 00    	add    $0xe93b,%ebx
    /* turn off interrupt */
    outb(COM1 + COM_IER, 0);
  1006bf:	6a 00                	push   $0x0
  1006c1:	68 f9 03 00 00       	push   $0x3f9
  1006c6:	e8 58 2f 00 00       	call   103623 <outb>

    /* set DLAB */
    outb(COM1 + COM_LCR, COM_LCR_DLAB);
  1006cb:	83 c4 08             	add    $0x8,%esp
  1006ce:	68 80 00 00 00       	push   $0x80
  1006d3:	68 fb 03 00 00       	push   $0x3fb
  1006d8:	e8 46 2f 00 00       	call   103623 <outb>

    /* set baud rate */
    outb(COM1 + COM_DLL, 0x0001 & 0xff);
  1006dd:	83 c4 08             	add    $0x8,%esp
  1006e0:	6a 01                	push   $0x1
  1006e2:	68 f8 03 00 00       	push   $0x3f8
  1006e7:	e8 37 2f 00 00       	call   103623 <outb>
    outb(COM1 + COM_DLM, 0x0001 >> 8);
  1006ec:	83 c4 08             	add    $0x8,%esp
  1006ef:	6a 00                	push   $0x0
  1006f1:	68 f9 03 00 00       	push   $0x3f9
  1006f6:	e8 28 2f 00 00       	call   103623 <outb>

    /* Set the line status. */
    outb(COM1 + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
  1006fb:	83 c4 08             	add    $0x8,%esp
  1006fe:	6a 03                	push   $0x3
  100700:	68 fb 03 00 00       	push   $0x3fb
  100705:	e8 19 2f 00 00       	call   103623 <outb>

    /* Enable the FIFO. */
    outb(COM1 + COM_FCR, 0xc7);
  10070a:	83 c4 08             	add    $0x8,%esp
  10070d:	68 c7 00 00 00       	push   $0xc7
  100712:	68 fa 03 00 00       	push   $0x3fa
  100717:	e8 07 2f 00 00       	call   103623 <outb>

    /* Turn on DTR, RTS, and OUT2. */
    outb(COM1 + COM_MCR, 0x0b);
  10071c:	83 c4 08             	add    $0x8,%esp
  10071f:	6a 0b                	push   $0xb
  100721:	68 fc 03 00 00       	push   $0x3fc
  100726:	e8 f8 2e 00 00       	call   103623 <outb>

    // Clear any preexisting overrun indications and interrupts
    // Serial COM1 doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10072b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
  100732:	e8 d4 2e 00 00       	call   10360b <inb>
  100737:	3c ff                	cmp    $0xff,%al
  100739:	0f 95 83 4c 96 02 00 	setne  0x2964c(%ebx)
    (void) inb(COM1 + COM_IIR);
  100740:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
  100747:	e8 bf 2e 00 00       	call   10360b <inb>
    (void) inb(COM1 + COM_RX);
  10074c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
  100753:	e8 b3 2e 00 00       	call   10360b <inb>
}
  100758:	83 c4 18             	add    $0x18,%esp
  10075b:	5b                   	pop    %ebx
  10075c:	c3                   	ret

0010075d <serial_intenable>:

void serial_intenable(void)
{
  10075d:	53                   	push   %ebx
  10075e:	83 ec 08             	sub    $0x8,%esp
  100761:	e8 d7 fb ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100766:	81 c3 8e e8 00 00    	add    $0xe88e,%ebx
    if (serial_exists) {
  10076c:	80 bb 4c 96 02 00 00 	cmpb   $0x0,0x2964c(%ebx)
  100773:	75 05                	jne    10077a <serial_intenable+0x1d>
        outb(COM1 + COM_IER, 1);
        serial_intr();
    }
}
  100775:	83 c4 08             	add    $0x8,%esp
  100778:	5b                   	pop    %ebx
  100779:	c3                   	ret
        outb(COM1 + COM_IER, 1);
  10077a:	83 ec 08             	sub    $0x8,%esp
  10077d:	6a 01                	push   $0x1
  10077f:	68 f9 03 00 00       	push   $0x3f9
  100784:	e8 9a 2e 00 00       	call   103623 <outb>
        serial_intr();
  100789:	e8 7c fe ff ff       	call   10060a <serial_intr>
  10078e:	83 c4 10             	add    $0x10,%esp
}
  100791:	eb e2                	jmp    100775 <serial_intenable+0x18>

00100793 <kbd_proc_data>:
/*
 * Get data from the keyboard. If we finish a character, return it. Else 0.
 * Return -1 if no data.
 */
static int kbd_proc_data(void)
{
  100793:	56                   	push   %esi
  100794:	53                   	push   %ebx
  100795:	83 ec 10             	sub    $0x10,%esp
  100798:	e8 a0 fb ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10079d:	81 c3 57 e8 00 00    	add    $0xe857,%ebx
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0)
  1007a3:	6a 64                	push   $0x64
  1007a5:	e8 61 2e 00 00       	call   10360b <inb>
  1007aa:	83 c4 10             	add    $0x10,%esp
  1007ad:	a8 01                	test   $0x1,%al
  1007af:	0f 84 05 01 00 00    	je     1008ba <kbd_proc_data+0x127>
        return -1;

    data = inb(KBDATAP);
  1007b5:	83 ec 0c             	sub    $0xc,%esp
  1007b8:	6a 60                	push   $0x60
  1007ba:	e8 4c 2e 00 00       	call   10360b <inb>

    if (data == 0xE0) {
  1007bf:	83 c4 10             	add    $0x10,%esp
  1007c2:	3c e0                	cmp    $0xe0,%al
  1007c4:	0f 84 82 00 00 00    	je     10084c <kbd_proc_data+0xb9>
        // E0 escape character
        shift |= E0ESC;
        return 0;
    } else if (data & 0x80) {
  1007ca:	84 c0                	test   %al,%al
  1007cc:	0f 88 88 00 00 00    	js     10085a <kbd_proc_data+0xc7>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    } else if (shift & E0ESC) {
  1007d2:	8b 93 50 96 02 00    	mov    0x29650(%ebx),%edx
  1007d8:	f6 c2 40             	test   $0x40,%dl
  1007db:	74 0c                	je     1007e9 <kbd_proc_data+0x56>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1007dd:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
  1007e0:	83 e2 bf             	and    $0xffffffbf,%edx
  1007e3:	89 93 50 96 02 00    	mov    %edx,0x29650(%ebx)
    }

    shift |= shiftcode[data];
  1007e9:	0f b6 c0             	movzbl %al,%eax
  1007ec:	0f b6 94 03 8c 98 ff 	movzbl -0x6774(%ebx,%eax,1),%edx
  1007f3:	ff 
  1007f4:	0b 93 50 96 02 00    	or     0x29650(%ebx),%edx
  1007fa:	89 93 50 96 02 00    	mov    %edx,0x29650(%ebx)
    shift ^= togglecode[data];
  100800:	0f b6 8c 03 8c 97 ff 	movzbl -0x6874(%ebx,%eax,1),%ecx
  100807:	ff 
  100808:	31 ca                	xor    %ecx,%edx
  10080a:	89 93 50 96 02 00    	mov    %edx,0x29650(%ebx)

    c = charcode[shift & (CTL | SHIFT)][data];
  100810:	89 d1                	mov    %edx,%ecx
  100812:	83 e1 03             	and    $0x3,%ecx
  100815:	8b 8c 8b ac ff ff ff 	mov    -0x54(%ebx,%ecx,4),%ecx
  10081c:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  100820:	0f b6 f0             	movzbl %al,%esi
    if (shift & CAPSLOCK) {
  100823:	f6 c2 08             	test   $0x8,%dl
  100826:	74 0d                	je     100835 <kbd_proc_data+0xa2>
        if ('a' <= c && c <= 'z')
  100828:	89 f0                	mov    %esi,%eax
  10082a:	8d 4e 9f             	lea    -0x61(%esi),%ecx
  10082d:	83 f9 19             	cmp    $0x19,%ecx
  100830:	77 58                	ja     10088a <kbd_proc_data+0xf7>
            c += 'A' - 'a';
  100832:	83 ee 20             	sub    $0x20,%esi
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }
    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  100835:	f7 d2                	not    %edx
  100837:	f6 c2 06             	test   $0x6,%dl
  10083a:	75 08                	jne    100844 <kbd_proc_data+0xb1>
  10083c:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
  100842:	74 53                	je     100897 <kbd_proc_data+0x104>
        dprintf("Rebooting!\n");
        outb(0x92, 0x3);  // courtesy of Chris Frost
    }

    return c;
}
  100844:	89 f0                	mov    %esi,%eax
  100846:	83 c4 04             	add    $0x4,%esp
  100849:	5b                   	pop    %ebx
  10084a:	5e                   	pop    %esi
  10084b:	c3                   	ret
        shift |= E0ESC;
  10084c:	83 8b 50 96 02 00 40 	orl    $0x40,0x29650(%ebx)
        return 0;
  100853:	be 00 00 00 00       	mov    $0x0,%esi
  100858:	eb ea                	jmp    100844 <kbd_proc_data+0xb1>
        data = (shift & E0ESC ? data : data & 0x7F);
  10085a:	8b 93 50 96 02 00    	mov    0x29650(%ebx),%edx
  100860:	f6 c2 40             	test   $0x40,%dl
  100863:	75 03                	jne    100868 <kbd_proc_data+0xd5>
  100865:	83 e0 7f             	and    $0x7f,%eax
        shift &= ~(shiftcode[data] | E0ESC);
  100868:	0f b6 c0             	movzbl %al,%eax
  10086b:	0f b6 84 03 8c 98 ff 	movzbl -0x6774(%ebx,%eax,1),%eax
  100872:	ff 
  100873:	83 c8 40             	or     $0x40,%eax
  100876:	0f b6 c0             	movzbl %al,%eax
  100879:	f7 d0                	not    %eax
  10087b:	21 c2                	and    %eax,%edx
  10087d:	89 93 50 96 02 00    	mov    %edx,0x29650(%ebx)
        return 0;
  100883:	be 00 00 00 00       	mov    $0x0,%esi
  100888:	eb ba                	jmp    100844 <kbd_proc_data+0xb1>
        else if ('A' <= c && c <= 'Z')
  10088a:	83 e8 41             	sub    $0x41,%eax
  10088d:	83 f8 19             	cmp    $0x19,%eax
  100890:	77 a3                	ja     100835 <kbd_proc_data+0xa2>
            c += 'a' - 'A';
  100892:	83 c6 20             	add    $0x20,%esi
  100895:	eb 9e                	jmp    100835 <kbd_proc_data+0xa2>
        dprintf("Rebooting!\n");
  100897:	83 ec 0c             	sub    $0xc,%esp
  10089a:	8d 83 2d 90 ff ff    	lea    -0x6fd3(%ebx),%eax
  1008a0:	50                   	push   %eax
  1008a1:	e8 fc 22 00 00       	call   102ba2 <dprintf>
        outb(0x92, 0x3);  // courtesy of Chris Frost
  1008a6:	83 c4 08             	add    $0x8,%esp
  1008a9:	6a 03                	push   $0x3
  1008ab:	68 92 00 00 00       	push   $0x92
  1008b0:	e8 6e 2d 00 00       	call   103623 <outb>
  1008b5:	83 c4 10             	add    $0x10,%esp
  1008b8:	eb 8a                	jmp    100844 <kbd_proc_data+0xb1>
        return -1;
  1008ba:	be ff ff ff ff       	mov    $0xffffffff,%esi
  1008bf:	eb 83                	jmp    100844 <kbd_proc_data+0xb1>

001008c1 <keyboard_intr>:

void keyboard_intr(void)
{
  1008c1:	53                   	push   %ebx
  1008c2:	83 ec 14             	sub    $0x14,%esp
  1008c5:	e8 73 fa ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1008ca:	81 c3 2a e7 00 00    	add    $0xe72a,%ebx
    cons_intr(kbd_proc_data);
  1008d0:	8d 83 9f 17 ff ff    	lea    -0xe861(%ebx),%eax
  1008d6:	50                   	push   %eax
  1008d7:	e8 96 fa ff ff       	call   100372 <cons_intr>
}
  1008dc:	83 c4 18             	add    $0x18,%esp
  1008df:	5b                   	pop    %ebx
  1008e0:	c3                   	ret

001008e1 <devinit>:
#include "tsc.h"

void intr_init(void);

void devinit(uintptr_t mbi_addr)
{
  1008e1:	57                   	push   %edi
  1008e2:	56                   	push   %esi
  1008e3:	53                   	push   %ebx
  1008e4:	e8 54 fa ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1008e9:	81 c3 0b e7 00 00    	add    $0xe70b,%ebx
  1008ef:	8b 74 24 10          	mov    0x10(%esp),%esi
    seg_init();
  1008f3:	e8 1b 28 00 00       	call   103113 <seg_init>

    enable_sse();
  1008f8:	e8 7e 2c 00 00       	call   10357b <enable_sse>

    cons_init();
  1008fd:	e8 3f fa ff ff       	call   100341 <cons_init>
    KERN_DEBUG("cons initialized.\n");
  100902:	83 ec 04             	sub    $0x4,%esp
  100905:	8d 83 39 90 ff ff    	lea    -0x6fc7(%ebx),%eax
  10090b:	50                   	push   %eax
  10090c:	6a 14                	push   $0x14
  10090e:	8d bb 4c 90 ff ff    	lea    -0x6fb4(%ebx),%edi
  100914:	57                   	push   %edi
  100915:	e8 bc 20 00 00       	call   1029d6 <debug_normal>
    KERN_DEBUG("devinit mbi_addr: %d\n", mbi_addr);
  10091a:	56                   	push   %esi
  10091b:	8d 83 5f 90 ff ff    	lea    -0x6fa1(%ebx),%eax
  100921:	50                   	push   %eax
  100922:	6a 15                	push   $0x15
  100924:	57                   	push   %edi
  100925:	e8 ac 20 00 00       	call   1029d6 <debug_normal>

    tsc_init();
  10092a:	83 c4 20             	add    $0x20,%esp
  10092d:	e8 b8 18 00 00       	call   1021ea <tsc_init>
    intr_init();
  100932:	e8 b7 13 00 00       	call   101cee <intr_init>

    /* enable interrupts */
    intr_enable(IRQ_TIMER);
  100937:	83 ec 0c             	sub    $0xc,%esp
  10093a:	6a 00                	push   $0x0
  10093c:	e8 dd 13 00 00       	call   101d1e <intr_enable>
    intr_enable(IRQ_KBD);
  100941:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100948:	e8 d1 13 00 00       	call   101d1e <intr_enable>
    intr_enable(IRQ_SERIAL13);
  10094d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100954:	e8 c5 13 00 00       	call   101d1e <intr_enable>

    pmmap_init(mbi_addr);
  100959:	89 34 24             	mov    %esi,(%esp)
  10095c:	e8 8c 02 00 00       	call   100bed <pmmap_init>
}
  100961:	83 c4 10             	add    $0x10,%esp
  100964:	5b                   	pop    %ebx
  100965:	5e                   	pop    %esi
  100966:	5f                   	pop    %edi
  100967:	c3                   	ret
  100968:	66 90                	xchg   %ax,%ax
  10096a:	66 90                	xchg   %ax,%ax
  10096c:	66 90                	xchg   %ax,%ax
  10096e:	66 90                	xchg   %ax,%ax

00100970 <pmmap_dump>:
    if (last_slot[PMMAP_USABLE] != NULL)
        max_usable_memory = last_slot[PMMAP_USABLE]->end;
}

static void pmmap_dump(void)
{
  100970:	56                   	push   %esi
  100971:	53                   	push   %ebx
  100972:	83 ec 04             	sub    $0x4,%esp
  100975:	e8 c3 f9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10097a:	81 c3 7a e6 00 00    	add    $0xe67a,%ebx
    struct pmmap *slot;
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100980:	8b b3 88 96 02 00    	mov    0x29688(%ebx),%esi
  100986:	eb 39                	jmp    1009c1 <pmmap_dump+0x51>
  100988:	83 f8 04             	cmp    $0x4,%eax
  10098b:	75 64                	jne    1009f1 <pmmap_dump+0x81>
        KERN_INFO("BIOS-e820: 0x%08x - 0x%08x (%s)\n",
  10098d:	8d 8b 97 90 ff ff    	lea    -0x6f69(%ebx),%ecx
  100993:	eb 06                	jmp    10099b <pmmap_dump+0x2b>
  100995:	8d 8b 85 90 ff ff    	lea    -0x6f7b(%ebx),%ecx
  10099b:	8b 16                	mov    (%esi),%edx
  10099d:	8b 46 04             	mov    0x4(%esi),%eax
  1009a0:	39 c2                	cmp    %eax,%edx
  1009a2:	74 08                	je     1009ac <pmmap_dump+0x3c>
  1009a4:	83 f8 ff             	cmp    $0xffffffff,%eax
  1009a7:	74 03                	je     1009ac <pmmap_dump+0x3c>
  1009a9:	83 e8 01             	sub    $0x1,%eax
  1009ac:	51                   	push   %ecx
  1009ad:	50                   	push   %eax
  1009ae:	52                   	push   %edx
  1009af:	8d 83 8c 99 ff ff    	lea    -0x6674(%ebx),%eax
  1009b5:	50                   	push   %eax
  1009b6:	e8 f6 1f 00 00       	call   1029b1 <debug_info>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  1009bb:	8b 76 0c             	mov    0xc(%esi),%esi
  1009be:	83 c4 10             	add    $0x10,%esp
  1009c1:	85 f6                	test   %esi,%esi
  1009c3:	74 34                	je     1009f9 <pmmap_dump+0x89>
        KERN_INFO("BIOS-e820: 0x%08x - 0x%08x (%s)\n",
  1009c5:	8b 46 08             	mov    0x8(%esi),%eax
  1009c8:	83 f8 03             	cmp    $0x3,%eax
  1009cb:	74 c8                	je     100995 <pmmap_dump+0x25>
  1009cd:	77 b9                	ja     100988 <pmmap_dump+0x18>
  1009cf:	83 f8 01             	cmp    $0x1,%eax
  1009d2:	74 0d                	je     1009e1 <pmmap_dump+0x71>
  1009d4:	83 f8 02             	cmp    $0x2,%eax
  1009d7:	75 10                	jne    1009e9 <pmmap_dump+0x79>
  1009d9:	8d 8b 75 90 ff ff    	lea    -0x6f8b(%ebx),%ecx
  1009df:	eb ba                	jmp    10099b <pmmap_dump+0x2b>
  1009e1:	8d 8b 7e 90 ff ff    	lea    -0x6f82(%ebx),%ecx
  1009e7:	eb b2                	jmp    10099b <pmmap_dump+0x2b>
  1009e9:	8d 8b 8f 90 ff ff    	lea    -0x6f71(%ebx),%ecx
  1009ef:	eb aa                	jmp    10099b <pmmap_dump+0x2b>
  1009f1:	8d 8b 8f 90 ff ff    	lea    -0x6f71(%ebx),%ecx
  1009f7:	eb a2                	jmp    10099b <pmmap_dump+0x2b>
                  (slot->type == MEM_RAM) ? "usable" :
                  (slot->type == MEM_RESERVED) ? "reserved" :
                  (slot->type == MEM_ACPI) ? "ACPI data" :
                  (slot->type == MEM_NVS) ? "ACPI NVS" : "unknown");
    }
}
  1009f9:	83 c4 04             	add    $0x4,%esp
  1009fc:	5b                   	pop    %ebx
  1009fd:	5e                   	pop    %esi
  1009fe:	c3                   	ret

001009ff <pmmap_merge>:
{
  1009ff:	56                   	push   %esi
  100a00:	53                   	push   %ebx
  100a01:	83 ec 14             	sub    $0x14,%esp
  100a04:	e8 34 f9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100a09:	81 c3 eb e5 00 00    	add    $0xe5eb,%ebx
    struct pmmap *last_slot[4] = { NULL, NULL, NULL, NULL };
  100a0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100a16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100a1d:	00 
  100a1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100a25:	00 
  100a26:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100a2d:	00 
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100a2e:	8b b3 88 96 02 00    	mov    0x29688(%ebx),%esi
  100a34:	eb 03                	jmp    100a39 <pmmap_merge+0x3a>
  100a36:	8b 76 0c             	mov    0xc(%esi),%esi
  100a39:	85 f6                	test   %esi,%esi
  100a3b:	74 39                	je     100a76 <pmmap_merge+0x77>
        if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  100a3d:	8b 46 0c             	mov    0xc(%esi),%eax
  100a40:	85 c0                	test   %eax,%eax
  100a42:	74 32                	je     100a76 <pmmap_merge+0x77>
        if (slot->start <= next_slot->start &&
  100a44:	8b 10                	mov    (%eax),%edx
  100a46:	3b 16                	cmp    (%esi),%edx
  100a48:	72 ec                	jb     100a36 <pmmap_merge+0x37>
            slot->end >= next_slot->start &&
  100a4a:	8b 4e 04             	mov    0x4(%esi),%ecx
        if (slot->start <= next_slot->start &&
  100a4d:	39 d1                	cmp    %edx,%ecx
  100a4f:	72 e5                	jb     100a36 <pmmap_merge+0x37>
            slot->end >= next_slot->start &&
  100a51:	8b 50 08             	mov    0x8(%eax),%edx
  100a54:	39 56 08             	cmp    %edx,0x8(%esi)
  100a57:	75 dd                	jne    100a36 <pmmap_merge+0x37>
            slot->end = max(slot->end, next_slot->end);
  100a59:	83 ec 08             	sub    $0x8,%esp
  100a5c:	ff 70 04             	push   0x4(%eax)
  100a5f:	51                   	push   %ecx
  100a60:	e8 a5 2a 00 00       	call   10350a <max>
  100a65:	89 46 04             	mov    %eax,0x4(%esi)
            SLIST_REMOVE_AFTER(slot, next);
  100a68:	8b 46 0c             	mov    0xc(%esi),%eax
  100a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  100a6e:	89 46 0c             	mov    %eax,0xc(%esi)
  100a71:	83 c4 10             	add    $0x10,%esp
  100a74:	eb c0                	jmp    100a36 <pmmap_merge+0x37>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100a76:	8b b3 88 96 02 00    	mov    0x29688(%ebx),%esi
  100a7c:	eb 46                	jmp    100ac4 <pmmap_merge+0xc5>
  100a7e:	83 f8 04             	cmp    $0x4,%eax
  100a81:	75 07                	jne    100a8a <pmmap_merge+0x8b>
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  100a83:	b8 03 00 00 00       	mov    $0x3,%eax
  100a88:	eb 24                	jmp    100aae <pmmap_merge+0xaf>
        KERN_ASSERT(sublist_nr != -1);
  100a8a:	8d 83 a0 90 ff ff    	lea    -0x6f60(%ebx),%eax
  100a90:	50                   	push   %eax
  100a91:	8d 83 b1 90 ff ff    	lea    -0x6f4f(%ebx),%eax
  100a97:	50                   	push   %eax
  100a98:	6a 6b                	push   $0x6b
  100a9a:	8d 83 ce 90 ff ff    	lea    -0x6f32(%ebx),%eax
  100aa0:	50                   	push   %eax
  100aa1:	e8 69 1f 00 00       	call   102a0f <debug_panic>
  100aa6:	83 c4 10             	add    $0x10,%esp
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  100aa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        if (last_slot[sublist_nr] != NULL)
  100aae:	8b 14 84             	mov    (%esp,%eax,4),%edx
  100ab1:	85 d2                	test   %edx,%edx
  100ab3:	74 3f                	je     100af4 <pmmap_merge+0xf5>
            SLIST_INSERT_AFTER(last_slot[sublist_nr], slot, type_next);
  100ab5:	8b 4a 10             	mov    0x10(%edx),%ecx
  100ab8:	89 4e 10             	mov    %ecx,0x10(%esi)
  100abb:	89 72 10             	mov    %esi,0x10(%edx)
        last_slot[sublist_nr] = slot;
  100abe:	89 34 84             	mov    %esi,(%esp,%eax,4)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ac1:	8b 76 0c             	mov    0xc(%esi),%esi
  100ac4:	85 f6                	test   %esi,%esi
  100ac6:	74 3d                	je     100b05 <pmmap_merge+0x106>
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  100ac8:	8b 46 08             	mov    0x8(%esi),%eax
  100acb:	83 f8 03             	cmp    $0x3,%eax
  100ace:	74 16                	je     100ae6 <pmmap_merge+0xe7>
  100ad0:	83 f8 03             	cmp    $0x3,%eax
  100ad3:	77 a9                	ja     100a7e <pmmap_merge+0x7f>
  100ad5:	83 f8 01             	cmp    $0x1,%eax
  100ad8:	74 13                	je     100aed <pmmap_merge+0xee>
  100ada:	83 f8 02             	cmp    $0x2,%eax
  100add:	75 ab                	jne    100a8a <pmmap_merge+0x8b>
  100adf:	b8 01 00 00 00       	mov    $0x1,%eax
  100ae4:	eb c8                	jmp    100aae <pmmap_merge+0xaf>
  100ae6:	b8 02 00 00 00       	mov    $0x2,%eax
  100aeb:	eb c1                	jmp    100aae <pmmap_merge+0xaf>
  100aed:	b8 00 00 00 00       	mov    $0x0,%eax
  100af2:	eb ba                	jmp    100aae <pmmap_merge+0xaf>
            SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot, type_next);
  100af4:	8d 93 78 96 02 00    	lea    0x29678(%ebx),%edx
  100afa:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
  100afd:	89 4e 10             	mov    %ecx,0x10(%esi)
  100b00:	89 34 82             	mov    %esi,(%edx,%eax,4)
  100b03:	eb b9                	jmp    100abe <pmmap_merge+0xbf>
    if (last_slot[PMMAP_USABLE] != NULL)
  100b05:	8b 04 24             	mov    (%esp),%eax
  100b08:	85 c0                	test   %eax,%eax
  100b0a:	74 09                	je     100b15 <pmmap_merge+0x116>
        max_usable_memory = last_slot[PMMAP_USABLE]->end;
  100b0c:	8b 40 04             	mov    0x4(%eax),%eax
  100b0f:	89 83 74 96 02 00    	mov    %eax,0x29674(%ebx)
}
  100b15:	83 c4 14             	add    $0x14,%esp
  100b18:	5b                   	pop    %ebx
  100b19:	5e                   	pop    %esi
  100b1a:	c3                   	ret

00100b1b <pmmap_alloc_slot>:
{
  100b1b:	e8 0e 03 00 00       	call   100e2e <__x86.get_pc_thunk.dx>
  100b20:	81 c2 d4 e4 00 00    	add    $0xe4d4,%edx
    if (unlikely(pmmap_slots_next_free == 128))
  100b26:	8b 82 8c 96 02 00    	mov    0x2968c(%edx),%eax
  100b2c:	3d 80 00 00 00       	cmp    $0x80,%eax
  100b31:	74 1b                	je     100b4e <pmmap_alloc_slot+0x33>
    return &pmmap_slots[pmmap_slots_next_free++];
  100b33:	8d 48 01             	lea    0x1(%eax),%ecx
  100b36:	89 8a 8c 96 02 00    	mov    %ecx,0x2968c(%edx)
  100b3c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  100b3f:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
  100b46:	8d 84 02 ac 96 02 00 	lea    0x296ac(%edx,%eax,1),%eax
  100b4d:	c3                   	ret
        return NULL;
  100b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b53:	c3                   	ret

00100b54 <pmmap_insert>:
{
  100b54:	55                   	push   %ebp
  100b55:	57                   	push   %edi
  100b56:	56                   	push   %esi
  100b57:	53                   	push   %ebx
  100b58:	83 ec 1c             	sub    $0x1c,%esp
  100b5b:	e8 dd f7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100b60:	81 c3 94 e4 00 00    	add    $0xe494,%ebx
  100b66:	89 c6                	mov    %eax,%esi
  100b68:	89 d5                	mov    %edx,%ebp
  100b6a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
    if ((free_slot = pmmap_alloc_slot()) == NULL)
  100b6e:	e8 a8 ff ff ff       	call   100b1b <pmmap_alloc_slot>
  100b73:	89 c7                	mov    %eax,%edi
  100b75:	85 c0                	test   %eax,%eax
  100b77:	74 1b                	je     100b94 <pmmap_insert+0x40>
    free_slot->start = start;
  100b79:	89 37                	mov    %esi,(%edi)
    free_slot->end = end;
  100b7b:	89 6f 04             	mov    %ebp,0x4(%edi)
    free_slot->type = type;
  100b7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  100b82:	89 47 08             	mov    %eax,0x8(%edi)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100b85:	8b 8b 88 96 02 00    	mov    0x29688(%ebx),%ecx
  100b8b:	89 c8                	mov    %ecx,%eax
    last_slot = NULL;
  100b8d:	ba 00 00 00 00       	mov    $0x0,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100b92:	eb 31                	jmp    100bc5 <pmmap_insert+0x71>
        KERN_PANIC("More than 128 E820 entries.\n");
  100b94:	83 ec 04             	sub    $0x4,%esp
  100b97:	8d 83 df 90 ff ff    	lea    -0x6f21(%ebx),%eax
  100b9d:	50                   	push   %eax
  100b9e:	6a 3c                	push   $0x3c
  100ba0:	8d 83 ce 90 ff ff    	lea    -0x6f32(%ebx),%eax
  100ba6:	50                   	push   %eax
  100ba7:	e8 63 1e 00 00       	call   102a0f <debug_panic>
  100bac:	83 c4 10             	add    $0x10,%esp
  100baf:	eb c8                	jmp    100b79 <pmmap_insert+0x25>
  100bb1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  100bb8:	00 
  100bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        last_slot = slot;
  100bc0:	89 c2                	mov    %eax,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  100bc5:	85 c0                	test   %eax,%eax
  100bc7:	74 04                	je     100bcd <pmmap_insert+0x79>
        if (start < slot->start)
  100bc9:	3b 30                	cmp    (%eax),%esi
  100bcb:	73 f3                	jae    100bc0 <pmmap_insert+0x6c>
    if (last_slot == NULL) {
  100bcd:	85 d2                	test   %edx,%edx
  100bcf:	74 11                	je     100be2 <pmmap_insert+0x8e>
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100bd1:	8b 42 0c             	mov    0xc(%edx),%eax
  100bd4:	89 47 0c             	mov    %eax,0xc(%edi)
  100bd7:	89 7a 0c             	mov    %edi,0xc(%edx)
}
  100bda:	83 c4 1c             	add    $0x1c,%esp
  100bdd:	5b                   	pop    %ebx
  100bde:	5e                   	pop    %esi
  100bdf:	5f                   	pop    %edi
  100be0:	5d                   	pop    %ebp
  100be1:	c3                   	ret
        SLIST_INSERT_HEAD(&pmmap_list, free_slot, next);
  100be2:	89 4f 0c             	mov    %ecx,0xc(%edi)
  100be5:	89 bb 88 96 02 00    	mov    %edi,0x29688(%ebx)
  100beb:	eb ed                	jmp    100bda <pmmap_insert+0x86>

00100bed <pmmap_init>:

void pmmap_init(uintptr_t mbi_addr)
{
  100bed:	55                   	push   %ebp
  100bee:	57                   	push   %edi
  100bef:	56                   	push   %esi
  100bf0:	53                   	push   %ebx
  100bf1:	83 ec 18             	sub    $0x18,%esp
  100bf4:	e8 44 f7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100bf9:	81 c3 fb e3 00 00    	add    $0xe3fb,%ebx
  100bff:	8b 74 24 2c          	mov    0x2c(%esp),%esi
    KERN_INFO("\n");
  100c03:	8d 83 6c 93 ff ff    	lea    -0x6c94(%ebx),%eax
  100c09:	50                   	push   %eax
  100c0a:	e8 a2 1d 00 00       	call   1029b1 <debug_info>

    mboot_info_t *mbi = (mboot_info_t *) mbi_addr;
    mboot_mmap_t *p = (mboot_mmap_t *) mbi->mmap_addr;
  100c0f:	8b 46 30             	mov    0x30(%esi),%eax

    SLIST_INIT(&pmmap_list);
  100c12:	c7 83 88 96 02 00 00 	movl   $0x0,0x29688(%ebx)
  100c19:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_USABLE]);
  100c1c:	c7 83 78 96 02 00 00 	movl   $0x0,0x29678(%ebx)
  100c23:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_RESV]);
  100c26:	c7 83 7c 96 02 00 00 	movl   $0x0,0x2967c(%ebx)
  100c2d:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_ACPI]);
  100c30:	c7 83 80 96 02 00 00 	movl   $0x0,0x29680(%ebx)
  100c37:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);
  100c3a:	c7 83 84 96 02 00 00 	movl   $0x0,0x29684(%ebx)
  100c41:	00 00 00 

    /*
     * Copy memory map information from multiboot information mbi to pmmap.
     */
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100c44:	83 c4 10             	add    $0x10,%esp
  100c47:	eb 12                	jmp    100c5b <pmmap_init+0x6e>
            goto next;
        else
            start = p->base_addr_low;

        if (p->length_high != 0 || p->length_low >= 0xffffffff - start)
            end = 0xffffffff;
  100c49:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        else
            end = start + p->length_low;

        type = p->type;
  100c4e:	8b 48 14             	mov    0x14(%eax),%ecx

        pmmap_insert(start, end, type);
  100c51:	89 e8                	mov    %ebp,%eax
  100c53:	e8 fc fe ff ff       	call   100b54 <pmmap_insert>

      next:
        p = (mboot_mmap_t *) (((uint32_t) p) + sizeof(mboot_mmap_t) /* p->size */);
  100c58:	8d 47 18             	lea    0x18(%edi),%eax
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100c5b:	89 c7                	mov    %eax,%edi
  100c5d:	89 c2                	mov    %eax,%edx
  100c5f:	2b 56 30             	sub    0x30(%esi),%edx
  100c62:	3b 56 2c             	cmp    0x2c(%esi),%edx
  100c65:	73 25                	jae    100c8c <pmmap_init+0x9f>
        if (p->base_addr_high != 0)  /* ignore address above 4G */
  100c67:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
  100c6b:	75 eb                	jne    100c58 <pmmap_init+0x6b>
            start = p->base_addr_low;
  100c6d:	8b 68 04             	mov    0x4(%eax),%ebp
        if (p->length_high != 0 || p->length_low >= 0xffffffff - start)
  100c70:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  100c74:	75 d3                	jne    100c49 <pmmap_init+0x5c>
  100c76:	8b 50 0c             	mov    0xc(%eax),%edx
  100c79:	89 e9                	mov    %ebp,%ecx
  100c7b:	f7 d1                	not    %ecx
  100c7d:	39 ca                	cmp    %ecx,%edx
  100c7f:	73 04                	jae    100c85 <pmmap_init+0x98>
            end = start + p->length_low;
  100c81:	01 ea                	add    %ebp,%edx
  100c83:	eb c9                	jmp    100c4e <pmmap_init+0x61>
            end = 0xffffffff;
  100c85:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  100c8a:	eb c2                	jmp    100c4e <pmmap_init+0x61>
    }

    /* merge overlapped memory regions */
    pmmap_merge();
  100c8c:	e8 6e fd ff ff       	call   1009ff <pmmap_merge>
    pmmap_dump();
  100c91:	e8 da fc ff ff       	call   100970 <pmmap_dump>

    /* count the number of pmmap entries */
    struct pmmap *slot;
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100c96:	8b 83 88 96 02 00    	mov    0x29688(%ebx),%eax
  100c9c:	eb 0c                	jmp    100caa <pmmap_init+0xbd>
  100c9e:	66 90                	xchg   %ax,%ax
        pmmap_nentries++;
  100ca0:	83 83 6c 96 02 00 01 	addl   $0x1,0x2966c(%ebx)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  100caa:	85 c0                	test   %eax,%eax
  100cac:	75 f2                	jne    100ca0 <pmmap_init+0xb3>
    }

    /* Calculate the maximum page number */
    mem_npages = rounddown(max_usable_memory, PAGESIZE) / PAGESIZE;
  100cae:	83 ec 08             	sub    $0x8,%esp
  100cb1:	68 00 10 00 00       	push   $0x1000
  100cb6:	ff b3 74 96 02 00    	push   0x29674(%ebx)
  100cbc:	e8 65 28 00 00       	call   103526 <rounddown>
  100cc1:	c1 e8 0c             	shr    $0xc,%eax
  100cc4:	89 83 70 96 02 00    	mov    %eax,0x29670(%ebx)
}
  100cca:	83 c4 1c             	add    $0x1c,%esp
  100ccd:	5b                   	pop    %ebx
  100cce:	5e                   	pop    %esi
  100ccf:	5f                   	pop    %edi
  100cd0:	5d                   	pop    %ebp
  100cd1:	c3                   	ret

00100cd2 <get_size>:

int get_size(void)
{
  100cd2:	e8 53 01 00 00       	call   100e2a <__x86.get_pc_thunk.ax>
  100cd7:	05 1d e3 00 00       	add    $0xe31d,%eax
    return pmmap_nentries;
  100cdc:	8b 80 6c 96 02 00    	mov    0x2966c(%eax),%eax
}
  100ce2:	c3                   	ret

00100ce3 <get_mms>:

uint32_t get_mms(int idx)
{
  100ce3:	53                   	push   %ebx
  100ce4:	e8 54 f6 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100ce9:	81 c3 0b e3 00 00    	add    $0xe30b,%ebx
  100cef:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  100cf3:	8b 83 88 96 02 00    	mov    0x29688(%ebx),%eax
    int i = 0;
  100cf9:	ba 00 00 00 00       	mov    $0x0,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100cfe:	eb 06                	jmp    100d06 <get_mms+0x23>
        if (i == idx)
            break;
        i++;
  100d00:	83 c2 01             	add    $0x1,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d03:	8b 40 0c             	mov    0xc(%eax),%eax
  100d06:	85 c0                	test   %eax,%eax
  100d08:	74 04                	je     100d0e <get_mms+0x2b>
        if (i == idx)
  100d0a:	39 ca                	cmp    %ecx,%edx
  100d0c:	75 f2                	jne    100d00 <get_mms+0x1d>
    }

    if (slot == NULL || i == pmmap_nentries)
  100d0e:	85 c0                	test   %eax,%eax
  100d10:	74 0c                	je     100d1e <get_mms+0x3b>
  100d12:	39 93 6c 96 02 00    	cmp    %edx,0x2966c(%ebx)
  100d18:	74 0b                	je     100d25 <get_mms+0x42>
        return 0;

    return slot->start;
  100d1a:	8b 00                	mov    (%eax),%eax
}
  100d1c:	5b                   	pop    %ebx
  100d1d:	c3                   	ret
        return 0;
  100d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  100d23:	eb f7                	jmp    100d1c <get_mms+0x39>
  100d25:	b8 00 00 00 00       	mov    $0x0,%eax
  100d2a:	eb f0                	jmp    100d1c <get_mms+0x39>

00100d2c <get_mml>:

uint32_t get_mml(int idx)
{
  100d2c:	53                   	push   %ebx
  100d2d:	e8 0b f6 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100d32:	81 c3 c2 e2 00 00    	add    $0xe2c2,%ebx
  100d38:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d3c:	8b 93 88 96 02 00    	mov    0x29688(%ebx),%edx
    int i = 0;
  100d42:	b8 00 00 00 00       	mov    $0x0,%eax
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d47:	eb 0d                	jmp    100d56 <get_mml+0x2a>
  100d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (i == idx)
            break;
        i++;
  100d50:	83 c0 01             	add    $0x1,%eax
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d53:	8b 52 0c             	mov    0xc(%edx),%edx
  100d56:	85 d2                	test   %edx,%edx
  100d58:	74 04                	je     100d5e <get_mml+0x32>
        if (i == idx)
  100d5a:	39 c8                	cmp    %ecx,%eax
  100d5c:	75 f2                	jne    100d50 <get_mml+0x24>
    }

    if (slot == NULL || i == pmmap_nentries)
  100d5e:	85 d2                	test   %edx,%edx
  100d60:	74 0f                	je     100d71 <get_mml+0x45>
  100d62:	39 83 6c 96 02 00    	cmp    %eax,0x2966c(%ebx)
  100d68:	74 0e                	je     100d78 <get_mml+0x4c>
        return 0;

    return slot->end - slot->start;
  100d6a:	8b 42 04             	mov    0x4(%edx),%eax
  100d6d:	2b 02                	sub    (%edx),%eax
}
  100d6f:	5b                   	pop    %ebx
  100d70:	c3                   	ret
        return 0;
  100d71:	b8 00 00 00 00       	mov    $0x0,%eax
  100d76:	eb f7                	jmp    100d6f <get_mml+0x43>
  100d78:	b8 00 00 00 00       	mov    $0x0,%eax
  100d7d:	eb f0                	jmp    100d6f <get_mml+0x43>

00100d7f <is_usable>:

int is_usable(int idx)
{
  100d7f:	53                   	push   %ebx
  100d80:	e8 b8 f5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100d85:	81 c3 6f e2 00 00    	add    $0xe26f,%ebx
  100d8b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d8f:	8b 83 88 96 02 00    	mov    0x29688(%ebx),%eax
    int i = 0;
  100d95:	ba 00 00 00 00       	mov    $0x0,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d9a:	eb 0a                	jmp    100da6 <is_usable+0x27>
  100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (i == idx)
            break;
        i++;
  100da0:	83 c2 01             	add    $0x1,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100da3:	8b 40 0c             	mov    0xc(%eax),%eax
  100da6:	85 c0                	test   %eax,%eax
  100da8:	74 04                	je     100dae <is_usable+0x2f>
        if (i == idx)
  100daa:	39 ca                	cmp    %ecx,%edx
  100dac:	75 f2                	jne    100da0 <is_usable+0x21>
    }

    if (slot == NULL || i == pmmap_nentries)
  100dae:	85 c0                	test   %eax,%eax
  100db0:	74 14                	je     100dc6 <is_usable+0x47>
  100db2:	39 93 6c 96 02 00    	cmp    %edx,0x2966c(%ebx)
  100db8:	74 13                	je     100dcd <is_usable+0x4e>
        return 0;

    return slot->type == MEM_RAM;
  100dba:	83 78 08 01          	cmpl   $0x1,0x8(%eax)
  100dbe:	0f 94 c0             	sete   %al
  100dc1:	0f b6 c0             	movzbl %al,%eax
}
  100dc4:	5b                   	pop    %ebx
  100dc5:	c3                   	ret
        return 0;
  100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  100dcb:	eb f7                	jmp    100dc4 <is_usable+0x45>
  100dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  100dd2:	eb f0                	jmp    100dc4 <is_usable+0x45>

00100dd4 <set_cr3>:

void set_cr3(unsigned int **pdir)
{
  100dd4:	53                   	push   %ebx
  100dd5:	83 ec 14             	sub    $0x14,%esp
  100dd8:	e8 60 f5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100ddd:	81 c3 17 e2 00 00    	add    $0xe217,%ebx
    lcr3((uint32_t) pdir);
  100de3:	ff 74 24 1c          	push   0x1c(%esp)
  100de7:	e8 0b 28 00 00       	call   1035f7 <lcr3>
}
  100dec:	83 c4 18             	add    $0x18,%esp
  100def:	5b                   	pop    %ebx
  100df0:	c3                   	ret

00100df1 <enable_paging>:

void enable_paging(void)
{
  100df1:	53                   	push   %ebx
  100df2:	83 ec 08             	sub    $0x8,%esp
  100df5:	e8 43 f5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  100dfa:	81 c3 fa e1 00 00    	add    $0xe1fa,%ebx
    /* enable global pages (Sec 4.10.2.4, Intel ASDM Vol3) */
    uint32_t cr4 = rcr4();
  100e00:	e8 02 28 00 00       	call   103607 <rcr4>
    cr4 |= CR4_PGE;
  100e05:	0c 80                	or     $0x80,%al
    lcr4(cr4);
  100e07:	83 ec 0c             	sub    $0xc,%esp
  100e0a:	50                   	push   %eax
  100e0b:	e8 ef 27 00 00       	call   1035ff <lcr4>

    /* turn on paging */
    uint32_t cr0 = rcr0();
  100e10:	e8 da 27 00 00       	call   1035ef <rcr0>
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_MP;
    cr0 &= ~(CR0_EM | CR0_TS);
  100e15:	83 e0 f3             	and    $0xfffffff3,%eax
  100e18:	0d 23 00 05 80       	or     $0x80050023,%eax
    lcr0(cr0);
  100e1d:	89 04 24             	mov    %eax,(%esp)
  100e20:	e8 c2 27 00 00       	call   1035e7 <lcr0>
}
  100e25:	83 c4 18             	add    $0x18,%esp
  100e28:	5b                   	pop    %ebx
  100e29:	c3                   	ret

00100e2a <__x86.get_pc_thunk.ax>:
  100e2a:	8b 04 24             	mov    (%esp),%eax
  100e2d:	c3                   	ret

00100e2e <__x86.get_pc_thunk.dx>:
  100e2e:	8b 14 24             	mov    (%esp),%edx
  100e31:	c3                   	ret

00100e32 <intr_init_idt>:
gatedesc_t idt[256];
pseudodesc_t idt_pd =
    {.pd_lim = sizeof(idt) - 1, .pd_base = (uint32_t) idt};

static void intr_init_idt(void)
{
  100e32:	55                   	push   %ebp
  100e33:	57                   	push   %edi
  100e34:	56                   	push   %esi
  100e35:	53                   	push   %ebx
  100e36:	e8 ef ff ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  100e3b:	05 b9 e1 00 00       	add    $0xe1b9,%eax

    /* check that T_IRQ0 is a multiple of 8 */
    KERN_ASSERT((T_IRQ0 & 7) == 0);

    /* install a default handler */
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  100e40:	ba 00 00 00 00       	mov    $0x0,%edx
  100e45:	eb 78                	jmp    100ebf <intr_init_idt+0x8d>
        SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  100e47:	c7 c5 ce 25 10 00    	mov    $0x1025ce,%ebp
  100e4d:	66 89 ac d0 ac a0 02 	mov    %bp,0x2a0ac(%eax,%edx,8)
  100e54:	00 
  100e55:	8d b4 d0 ac a0 02 00 	lea    0x2a0ac(%eax,%edx,8),%esi
  100e5c:	66 c7 46 02 08 00    	movw   $0x8,0x2(%esi)
  100e62:	0f b6 8c d0 b0 a0 02 	movzbl 0x2a0b0(%eax,%edx,8),%ecx
  100e69:	00 
  100e6a:	83 e1 e0             	and    $0xffffffe0,%ecx
  100e6d:	88 8c d0 b0 a0 02 00 	mov    %cl,0x2a0b0(%eax,%edx,8)
  100e74:	c6 84 d0 b0 a0 02 00 	movb   $0x0,0x2a0b0(%eax,%edx,8)
  100e7b:	00 
  100e7c:	0f b6 8c d0 b1 a0 02 	movzbl 0x2a0b1(%eax,%edx,8),%ecx
  100e83:	00 
  100e84:	83 e1 f0             	and    $0xfffffff0,%ecx
  100e87:	83 c9 0e             	or     $0xe,%ecx
  100e8a:	88 8c d0 b1 a0 02 00 	mov    %cl,0x2a0b1(%eax,%edx,8)
  100e91:	89 cf                	mov    %ecx,%edi
  100e93:	83 e7 ef             	and    $0xffffffef,%edi
  100e96:	89 fb                	mov    %edi,%ebx
  100e98:	88 9c d0 b1 a0 02 00 	mov    %bl,0x2a0b1(%eax,%edx,8)
  100e9f:	83 e1 8f             	and    $0xffffff8f,%ecx
  100ea2:	88 8c d0 b1 a0 02 00 	mov    %cl,0x2a0b1(%eax,%edx,8)
  100ea9:	83 c9 80             	or     $0xffffff80,%ecx
  100eac:	88 8c d0 b1 a0 02 00 	mov    %cl,0x2a0b1(%eax,%edx,8)
  100eb3:	89 eb                	mov    %ebp,%ebx
  100eb5:	c1 eb 10             	shr    $0x10,%ebx
  100eb8:	66 89 5e 06          	mov    %bx,0x6(%esi)
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  100ebc:	83 c2 01             	add    $0x1,%edx
  100ebf:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  100ec5:	76 80                	jbe    100e47 <intr_init_idt+0x15>

    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  100ec7:	c7 c1 c0 24 10 00    	mov    $0x1024c0,%ecx
  100ecd:	66 89 88 ac a0 02 00 	mov    %cx,0x2a0ac(%eax)
  100ed4:	66 c7 80 ae a0 02 00 	movw   $0x8,0x2a0ae(%eax)
  100edb:	08 00 
  100edd:	0f b6 90 b0 a0 02 00 	movzbl 0x2a0b0(%eax),%edx
  100ee4:	83 e2 e0             	and    $0xffffffe0,%edx
  100ee7:	88 90 b0 a0 02 00    	mov    %dl,0x2a0b0(%eax)
  100eed:	c6 80 b0 a0 02 00 00 	movb   $0x0,0x2a0b0(%eax)
  100ef4:	0f b6 90 b1 a0 02 00 	movzbl 0x2a0b1(%eax),%edx
  100efb:	83 e2 f0             	and    $0xfffffff0,%edx
  100efe:	83 ca 0e             	or     $0xe,%edx
  100f01:	88 90 b1 a0 02 00    	mov    %dl,0x2a0b1(%eax)
  100f07:	89 d3                	mov    %edx,%ebx
  100f09:	83 e3 ef             	and    $0xffffffef,%ebx
  100f0c:	88 98 b1 a0 02 00    	mov    %bl,0x2a0b1(%eax)
  100f12:	83 e2 8f             	and    $0xffffff8f,%edx
  100f15:	88 90 b1 a0 02 00    	mov    %dl,0x2a0b1(%eax)
  100f1b:	83 ca 80             	or     $0xffffff80,%edx
  100f1e:	88 90 b1 a0 02 00    	mov    %dl,0x2a0b1(%eax)
  100f24:	c1 e9 10             	shr    $0x10,%ecx
  100f27:	66 89 88 b2 a0 02 00 	mov    %cx,0x2a0b2(%eax)
    SETGATE(idt[T_DEBUG],                   0, CPU_GDT_KCODE, &Xdebug,          0);
  100f2e:	c7 c1 ca 24 10 00    	mov    $0x1024ca,%ecx
  100f34:	66 89 88 b4 a0 02 00 	mov    %cx,0x2a0b4(%eax)
  100f3b:	66 c7 80 b6 a0 02 00 	movw   $0x8,0x2a0b6(%eax)
  100f42:	08 00 
  100f44:	0f b6 90 b8 a0 02 00 	movzbl 0x2a0b8(%eax),%edx
  100f4b:	83 e2 e0             	and    $0xffffffe0,%edx
  100f4e:	88 90 b8 a0 02 00    	mov    %dl,0x2a0b8(%eax)
  100f54:	c6 80 b8 a0 02 00 00 	movb   $0x0,0x2a0b8(%eax)
  100f5b:	0f b6 90 b9 a0 02 00 	movzbl 0x2a0b9(%eax),%edx
  100f62:	83 e2 f0             	and    $0xfffffff0,%edx
  100f65:	83 ca 0e             	or     $0xe,%edx
  100f68:	88 90 b9 a0 02 00    	mov    %dl,0x2a0b9(%eax)
  100f6e:	89 d3                	mov    %edx,%ebx
  100f70:	83 e3 ef             	and    $0xffffffef,%ebx
  100f73:	88 98 b9 a0 02 00    	mov    %bl,0x2a0b9(%eax)
  100f79:	83 e2 8f             	and    $0xffffff8f,%edx
  100f7c:	88 90 b9 a0 02 00    	mov    %dl,0x2a0b9(%eax)
  100f82:	83 ca 80             	or     $0xffffff80,%edx
  100f85:	88 90 b9 a0 02 00    	mov    %dl,0x2a0b9(%eax)
  100f8b:	c1 e9 10             	shr    $0x10,%ecx
  100f8e:	66 89 88 ba a0 02 00 	mov    %cx,0x2a0ba(%eax)
    SETGATE(idt[T_NMI],                     0, CPU_GDT_KCODE, &Xnmi,            0);
  100f95:	c7 c1 d4 24 10 00    	mov    $0x1024d4,%ecx
  100f9b:	66 89 88 bc a0 02 00 	mov    %cx,0x2a0bc(%eax)
  100fa2:	66 c7 80 be a0 02 00 	movw   $0x8,0x2a0be(%eax)
  100fa9:	08 00 
  100fab:	0f b6 90 c0 a0 02 00 	movzbl 0x2a0c0(%eax),%edx
  100fb2:	83 e2 e0             	and    $0xffffffe0,%edx
  100fb5:	88 90 c0 a0 02 00    	mov    %dl,0x2a0c0(%eax)
  100fbb:	c6 80 c0 a0 02 00 00 	movb   $0x0,0x2a0c0(%eax)
  100fc2:	0f b6 90 c1 a0 02 00 	movzbl 0x2a0c1(%eax),%edx
  100fc9:	83 e2 f0             	and    $0xfffffff0,%edx
  100fcc:	83 ca 0e             	or     $0xe,%edx
  100fcf:	88 90 c1 a0 02 00    	mov    %dl,0x2a0c1(%eax)
  100fd5:	89 d3                	mov    %edx,%ebx
  100fd7:	83 e3 ef             	and    $0xffffffef,%ebx
  100fda:	88 98 c1 a0 02 00    	mov    %bl,0x2a0c1(%eax)
  100fe0:	83 e2 8f             	and    $0xffffff8f,%edx
  100fe3:	88 90 c1 a0 02 00    	mov    %dl,0x2a0c1(%eax)
  100fe9:	83 ca 80             	or     $0xffffff80,%edx
  100fec:	88 90 c1 a0 02 00    	mov    %dl,0x2a0c1(%eax)
  100ff2:	c1 e9 10             	shr    $0x10,%ecx
  100ff5:	66 89 88 c2 a0 02 00 	mov    %cx,0x2a0c2(%eax)
    SETGATE(idt[T_BRKPT],                   0, CPU_GDT_KCODE, &Xbrkpt,          3);
  100ffc:	c7 c1 de 24 10 00    	mov    $0x1024de,%ecx
  101002:	66 89 88 c4 a0 02 00 	mov    %cx,0x2a0c4(%eax)
  101009:	66 c7 80 c6 a0 02 00 	movw   $0x8,0x2a0c6(%eax)
  101010:	08 00 
  101012:	0f b6 90 c8 a0 02 00 	movzbl 0x2a0c8(%eax),%edx
  101019:	83 e2 e0             	and    $0xffffffe0,%edx
  10101c:	88 90 c8 a0 02 00    	mov    %dl,0x2a0c8(%eax)
  101022:	c6 80 c8 a0 02 00 00 	movb   $0x0,0x2a0c8(%eax)
  101029:	0f b6 90 c9 a0 02 00 	movzbl 0x2a0c9(%eax),%edx
  101030:	83 e2 f0             	and    $0xfffffff0,%edx
  101033:	83 ca 0e             	or     $0xe,%edx
  101036:	88 90 c9 a0 02 00    	mov    %dl,0x2a0c9(%eax)
  10103c:	83 e2 ef             	and    $0xffffffef,%edx
  10103f:	88 90 c9 a0 02 00    	mov    %dl,0x2a0c9(%eax)
  101045:	89 d3                	mov    %edx,%ebx
  101047:	83 cb 60             	or     $0x60,%ebx
  10104a:	88 98 c9 a0 02 00    	mov    %bl,0x2a0c9(%eax)
  101050:	83 ca e0             	or     $0xffffffe0,%edx
  101053:	88 90 c9 a0 02 00    	mov    %dl,0x2a0c9(%eax)
  101059:	c1 e9 10             	shr    $0x10,%ecx
  10105c:	66 89 88 ca a0 02 00 	mov    %cx,0x2a0ca(%eax)
    SETGATE(idt[T_OFLOW],                   0, CPU_GDT_KCODE, &Xoflow,          3);
  101063:	c7 c1 e8 24 10 00    	mov    $0x1024e8,%ecx
  101069:	66 89 88 cc a0 02 00 	mov    %cx,0x2a0cc(%eax)
  101070:	66 c7 80 ce a0 02 00 	movw   $0x8,0x2a0ce(%eax)
  101077:	08 00 
  101079:	0f b6 90 d0 a0 02 00 	movzbl 0x2a0d0(%eax),%edx
  101080:	83 e2 e0             	and    $0xffffffe0,%edx
  101083:	88 90 d0 a0 02 00    	mov    %dl,0x2a0d0(%eax)
  101089:	c6 80 d0 a0 02 00 00 	movb   $0x0,0x2a0d0(%eax)
  101090:	0f b6 90 d1 a0 02 00 	movzbl 0x2a0d1(%eax),%edx
  101097:	83 e2 f0             	and    $0xfffffff0,%edx
  10109a:	83 ca 0e             	or     $0xe,%edx
  10109d:	88 90 d1 a0 02 00    	mov    %dl,0x2a0d1(%eax)
  1010a3:	83 e2 ef             	and    $0xffffffef,%edx
  1010a6:	88 90 d1 a0 02 00    	mov    %dl,0x2a0d1(%eax)
  1010ac:	89 d3                	mov    %edx,%ebx
  1010ae:	83 cb 60             	or     $0x60,%ebx
  1010b1:	88 98 d1 a0 02 00    	mov    %bl,0x2a0d1(%eax)
  1010b7:	83 ca e0             	or     $0xffffffe0,%edx
  1010ba:	88 90 d1 a0 02 00    	mov    %dl,0x2a0d1(%eax)
  1010c0:	c1 e9 10             	shr    $0x10,%ecx
  1010c3:	66 89 88 d2 a0 02 00 	mov    %cx,0x2a0d2(%eax)
    SETGATE(idt[T_BOUND],                   0, CPU_GDT_KCODE, &Xbound,          0);
  1010ca:	c7 c1 f2 24 10 00    	mov    $0x1024f2,%ecx
  1010d0:	66 89 88 d4 a0 02 00 	mov    %cx,0x2a0d4(%eax)
  1010d7:	66 c7 80 d6 a0 02 00 	movw   $0x8,0x2a0d6(%eax)
  1010de:	08 00 
  1010e0:	0f b6 90 d8 a0 02 00 	movzbl 0x2a0d8(%eax),%edx
  1010e7:	83 e2 e0             	and    $0xffffffe0,%edx
  1010ea:	88 90 d8 a0 02 00    	mov    %dl,0x2a0d8(%eax)
  1010f0:	c6 80 d8 a0 02 00 00 	movb   $0x0,0x2a0d8(%eax)
  1010f7:	0f b6 90 d9 a0 02 00 	movzbl 0x2a0d9(%eax),%edx
  1010fe:	83 e2 f0             	and    $0xfffffff0,%edx
  101101:	83 ca 0e             	or     $0xe,%edx
  101104:	88 90 d9 a0 02 00    	mov    %dl,0x2a0d9(%eax)
  10110a:	89 d3                	mov    %edx,%ebx
  10110c:	83 e3 ef             	and    $0xffffffef,%ebx
  10110f:	88 98 d9 a0 02 00    	mov    %bl,0x2a0d9(%eax)
  101115:	83 e2 8f             	and    $0xffffff8f,%edx
  101118:	88 90 d9 a0 02 00    	mov    %dl,0x2a0d9(%eax)
  10111e:	83 ca 80             	or     $0xffffff80,%edx
  101121:	88 90 d9 a0 02 00    	mov    %dl,0x2a0d9(%eax)
  101127:	c1 e9 10             	shr    $0x10,%ecx
  10112a:	66 89 88 da a0 02 00 	mov    %cx,0x2a0da(%eax)
    SETGATE(idt[T_ILLOP],                   0, CPU_GDT_KCODE, &Xillop,          0);
  101131:	c7 c1 fc 24 10 00    	mov    $0x1024fc,%ecx
  101137:	66 89 88 dc a0 02 00 	mov    %cx,0x2a0dc(%eax)
  10113e:	66 c7 80 de a0 02 00 	movw   $0x8,0x2a0de(%eax)
  101145:	08 00 
  101147:	0f b6 90 e0 a0 02 00 	movzbl 0x2a0e0(%eax),%edx
  10114e:	83 e2 e0             	and    $0xffffffe0,%edx
  101151:	88 90 e0 a0 02 00    	mov    %dl,0x2a0e0(%eax)
  101157:	c6 80 e0 a0 02 00 00 	movb   $0x0,0x2a0e0(%eax)
  10115e:	0f b6 90 e1 a0 02 00 	movzbl 0x2a0e1(%eax),%edx
  101165:	83 e2 f0             	and    $0xfffffff0,%edx
  101168:	83 ca 0e             	or     $0xe,%edx
  10116b:	88 90 e1 a0 02 00    	mov    %dl,0x2a0e1(%eax)
  101171:	89 d3                	mov    %edx,%ebx
  101173:	83 e3 ef             	and    $0xffffffef,%ebx
  101176:	88 98 e1 a0 02 00    	mov    %bl,0x2a0e1(%eax)
  10117c:	83 e2 8f             	and    $0xffffff8f,%edx
  10117f:	88 90 e1 a0 02 00    	mov    %dl,0x2a0e1(%eax)
  101185:	83 ca 80             	or     $0xffffff80,%edx
  101188:	88 90 e1 a0 02 00    	mov    %dl,0x2a0e1(%eax)
  10118e:	c1 e9 10             	shr    $0x10,%ecx
  101191:	66 89 88 e2 a0 02 00 	mov    %cx,0x2a0e2(%eax)
    SETGATE(idt[T_DEVICE],                  0, CPU_GDT_KCODE, &Xdevice,         0);
  101198:	c7 c1 06 25 10 00    	mov    $0x102506,%ecx
  10119e:	66 89 88 e4 a0 02 00 	mov    %cx,0x2a0e4(%eax)
  1011a5:	66 c7 80 e6 a0 02 00 	movw   $0x8,0x2a0e6(%eax)
  1011ac:	08 00 
  1011ae:	0f b6 90 e8 a0 02 00 	movzbl 0x2a0e8(%eax),%edx
  1011b5:	83 e2 e0             	and    $0xffffffe0,%edx
  1011b8:	88 90 e8 a0 02 00    	mov    %dl,0x2a0e8(%eax)
  1011be:	c6 80 e8 a0 02 00 00 	movb   $0x0,0x2a0e8(%eax)
  1011c5:	0f b6 90 e9 a0 02 00 	movzbl 0x2a0e9(%eax),%edx
  1011cc:	83 e2 f0             	and    $0xfffffff0,%edx
  1011cf:	83 ca 0e             	or     $0xe,%edx
  1011d2:	88 90 e9 a0 02 00    	mov    %dl,0x2a0e9(%eax)
  1011d8:	89 d3                	mov    %edx,%ebx
  1011da:	83 e3 ef             	and    $0xffffffef,%ebx
  1011dd:	88 98 e9 a0 02 00    	mov    %bl,0x2a0e9(%eax)
  1011e3:	83 e2 8f             	and    $0xffffff8f,%edx
  1011e6:	88 90 e9 a0 02 00    	mov    %dl,0x2a0e9(%eax)
  1011ec:	83 ca 80             	or     $0xffffff80,%edx
  1011ef:	88 90 e9 a0 02 00    	mov    %dl,0x2a0e9(%eax)
  1011f5:	c1 e9 10             	shr    $0x10,%ecx
  1011f8:	66 89 88 ea a0 02 00 	mov    %cx,0x2a0ea(%eax)
    SETGATE(idt[T_DBLFLT],                  0, CPU_GDT_KCODE, &Xdblflt,         0);
  1011ff:	c7 c1 10 25 10 00    	mov    $0x102510,%ecx
  101205:	66 89 88 ec a0 02 00 	mov    %cx,0x2a0ec(%eax)
  10120c:	66 c7 80 ee a0 02 00 	movw   $0x8,0x2a0ee(%eax)
  101213:	08 00 
  101215:	0f b6 90 f0 a0 02 00 	movzbl 0x2a0f0(%eax),%edx
  10121c:	83 e2 e0             	and    $0xffffffe0,%edx
  10121f:	88 90 f0 a0 02 00    	mov    %dl,0x2a0f0(%eax)
  101225:	c6 80 f0 a0 02 00 00 	movb   $0x0,0x2a0f0(%eax)
  10122c:	0f b6 90 f1 a0 02 00 	movzbl 0x2a0f1(%eax),%edx
  101233:	83 e2 f0             	and    $0xfffffff0,%edx
  101236:	83 ca 0e             	or     $0xe,%edx
  101239:	88 90 f1 a0 02 00    	mov    %dl,0x2a0f1(%eax)
  10123f:	89 d3                	mov    %edx,%ebx
  101241:	83 e3 ef             	and    $0xffffffef,%ebx
  101244:	88 98 f1 a0 02 00    	mov    %bl,0x2a0f1(%eax)
  10124a:	83 e2 8f             	and    $0xffffff8f,%edx
  10124d:	88 90 f1 a0 02 00    	mov    %dl,0x2a0f1(%eax)
  101253:	83 ca 80             	or     $0xffffff80,%edx
  101256:	88 90 f1 a0 02 00    	mov    %dl,0x2a0f1(%eax)
  10125c:	c1 e9 10             	shr    $0x10,%ecx
  10125f:	66 89 88 f2 a0 02 00 	mov    %cx,0x2a0f2(%eax)
    SETGATE(idt[T_TSS],                     0, CPU_GDT_KCODE, &Xtss,            0);
  101266:	c7 c1 22 25 10 00    	mov    $0x102522,%ecx
  10126c:	66 89 88 fc a0 02 00 	mov    %cx,0x2a0fc(%eax)
  101273:	66 c7 80 fe a0 02 00 	movw   $0x8,0x2a0fe(%eax)
  10127a:	08 00 
  10127c:	0f b6 90 00 a1 02 00 	movzbl 0x2a100(%eax),%edx
  101283:	83 e2 e0             	and    $0xffffffe0,%edx
  101286:	88 90 00 a1 02 00    	mov    %dl,0x2a100(%eax)
  10128c:	c6 80 00 a1 02 00 00 	movb   $0x0,0x2a100(%eax)
  101293:	0f b6 90 01 a1 02 00 	movzbl 0x2a101(%eax),%edx
  10129a:	83 e2 f0             	and    $0xfffffff0,%edx
  10129d:	83 ca 0e             	or     $0xe,%edx
  1012a0:	88 90 01 a1 02 00    	mov    %dl,0x2a101(%eax)
  1012a6:	89 d3                	mov    %edx,%ebx
  1012a8:	83 e3 ef             	and    $0xffffffef,%ebx
  1012ab:	88 98 01 a1 02 00    	mov    %bl,0x2a101(%eax)
  1012b1:	83 e2 8f             	and    $0xffffff8f,%edx
  1012b4:	88 90 01 a1 02 00    	mov    %dl,0x2a101(%eax)
  1012ba:	83 ca 80             	or     $0xffffff80,%edx
  1012bd:	88 90 01 a1 02 00    	mov    %dl,0x2a101(%eax)
  1012c3:	c1 e9 10             	shr    $0x10,%ecx
  1012c6:	66 89 88 02 a1 02 00 	mov    %cx,0x2a102(%eax)
    SETGATE(idt[T_SEGNP],                   0, CPU_GDT_KCODE, &Xsegnp,          0);
  1012cd:	c7 c1 2a 25 10 00    	mov    $0x10252a,%ecx
  1012d3:	66 89 88 04 a1 02 00 	mov    %cx,0x2a104(%eax)
  1012da:	66 c7 80 06 a1 02 00 	movw   $0x8,0x2a106(%eax)
  1012e1:	08 00 
  1012e3:	0f b6 90 08 a1 02 00 	movzbl 0x2a108(%eax),%edx
  1012ea:	83 e2 e0             	and    $0xffffffe0,%edx
  1012ed:	88 90 08 a1 02 00    	mov    %dl,0x2a108(%eax)
  1012f3:	c6 80 08 a1 02 00 00 	movb   $0x0,0x2a108(%eax)
  1012fa:	0f b6 90 09 a1 02 00 	movzbl 0x2a109(%eax),%edx
  101301:	83 e2 f0             	and    $0xfffffff0,%edx
  101304:	83 ca 0e             	or     $0xe,%edx
  101307:	88 90 09 a1 02 00    	mov    %dl,0x2a109(%eax)
  10130d:	89 d3                	mov    %edx,%ebx
  10130f:	83 e3 ef             	and    $0xffffffef,%ebx
  101312:	88 98 09 a1 02 00    	mov    %bl,0x2a109(%eax)
  101318:	83 e2 8f             	and    $0xffffff8f,%edx
  10131b:	88 90 09 a1 02 00    	mov    %dl,0x2a109(%eax)
  101321:	83 ca 80             	or     $0xffffff80,%edx
  101324:	88 90 09 a1 02 00    	mov    %dl,0x2a109(%eax)
  10132a:	c1 e9 10             	shr    $0x10,%ecx
  10132d:	66 89 88 0a a1 02 00 	mov    %cx,0x2a10a(%eax)
    SETGATE(idt[T_STACK],                   0, CPU_GDT_KCODE, &Xstack,          0);
  101334:	c7 c1 32 25 10 00    	mov    $0x102532,%ecx
  10133a:	66 89 88 0c a1 02 00 	mov    %cx,0x2a10c(%eax)
  101341:	66 c7 80 0e a1 02 00 	movw   $0x8,0x2a10e(%eax)
  101348:	08 00 
  10134a:	0f b6 90 10 a1 02 00 	movzbl 0x2a110(%eax),%edx
  101351:	83 e2 e0             	and    $0xffffffe0,%edx
  101354:	88 90 10 a1 02 00    	mov    %dl,0x2a110(%eax)
  10135a:	c6 80 10 a1 02 00 00 	movb   $0x0,0x2a110(%eax)
  101361:	0f b6 90 11 a1 02 00 	movzbl 0x2a111(%eax),%edx
  101368:	83 e2 f0             	and    $0xfffffff0,%edx
  10136b:	83 ca 0e             	or     $0xe,%edx
  10136e:	88 90 11 a1 02 00    	mov    %dl,0x2a111(%eax)
  101374:	89 d3                	mov    %edx,%ebx
  101376:	83 e3 ef             	and    $0xffffffef,%ebx
  101379:	88 98 11 a1 02 00    	mov    %bl,0x2a111(%eax)
  10137f:	83 e2 8f             	and    $0xffffff8f,%edx
  101382:	88 90 11 a1 02 00    	mov    %dl,0x2a111(%eax)
  101388:	83 ca 80             	or     $0xffffff80,%edx
  10138b:	88 90 11 a1 02 00    	mov    %dl,0x2a111(%eax)
  101391:	c1 e9 10             	shr    $0x10,%ecx
  101394:	66 89 88 12 a1 02 00 	mov    %cx,0x2a112(%eax)
    SETGATE(idt[T_GPFLT],                   0, CPU_GDT_KCODE, &Xgpflt,          0);
  10139b:	c7 c1 3a 25 10 00    	mov    $0x10253a,%ecx
  1013a1:	66 89 88 14 a1 02 00 	mov    %cx,0x2a114(%eax)
  1013a8:	66 c7 80 16 a1 02 00 	movw   $0x8,0x2a116(%eax)
  1013af:	08 00 
  1013b1:	0f b6 90 18 a1 02 00 	movzbl 0x2a118(%eax),%edx
  1013b8:	83 e2 e0             	and    $0xffffffe0,%edx
  1013bb:	88 90 18 a1 02 00    	mov    %dl,0x2a118(%eax)
  1013c1:	c6 80 18 a1 02 00 00 	movb   $0x0,0x2a118(%eax)
  1013c8:	0f b6 90 19 a1 02 00 	movzbl 0x2a119(%eax),%edx
  1013cf:	83 e2 f0             	and    $0xfffffff0,%edx
  1013d2:	83 ca 0e             	or     $0xe,%edx
  1013d5:	88 90 19 a1 02 00    	mov    %dl,0x2a119(%eax)
  1013db:	89 d3                	mov    %edx,%ebx
  1013dd:	83 e3 ef             	and    $0xffffffef,%ebx
  1013e0:	88 98 19 a1 02 00    	mov    %bl,0x2a119(%eax)
  1013e6:	83 e2 8f             	and    $0xffffff8f,%edx
  1013e9:	88 90 19 a1 02 00    	mov    %dl,0x2a119(%eax)
  1013ef:	83 ca 80             	or     $0xffffff80,%edx
  1013f2:	88 90 19 a1 02 00    	mov    %dl,0x2a119(%eax)
  1013f8:	c1 e9 10             	shr    $0x10,%ecx
  1013fb:	66 89 88 1a a1 02 00 	mov    %cx,0x2a11a(%eax)
    SETGATE(idt[T_PGFLT],                   0, CPU_GDT_KCODE, &Xpgflt,          0);
  101402:	c7 c1 42 25 10 00    	mov    $0x102542,%ecx
  101408:	66 89 88 1c a1 02 00 	mov    %cx,0x2a11c(%eax)
  10140f:	66 c7 80 1e a1 02 00 	movw   $0x8,0x2a11e(%eax)
  101416:	08 00 
  101418:	0f b6 90 20 a1 02 00 	movzbl 0x2a120(%eax),%edx
  10141f:	83 e2 e0             	and    $0xffffffe0,%edx
  101422:	88 90 20 a1 02 00    	mov    %dl,0x2a120(%eax)
  101428:	c6 80 20 a1 02 00 00 	movb   $0x0,0x2a120(%eax)
  10142f:	0f b6 90 21 a1 02 00 	movzbl 0x2a121(%eax),%edx
  101436:	83 e2 f0             	and    $0xfffffff0,%edx
  101439:	83 ca 0e             	or     $0xe,%edx
  10143c:	88 90 21 a1 02 00    	mov    %dl,0x2a121(%eax)
  101442:	89 d3                	mov    %edx,%ebx
  101444:	83 e3 ef             	and    $0xffffffef,%ebx
  101447:	88 98 21 a1 02 00    	mov    %bl,0x2a121(%eax)
  10144d:	83 e2 8f             	and    $0xffffff8f,%edx
  101450:	88 90 21 a1 02 00    	mov    %dl,0x2a121(%eax)
  101456:	83 ca 80             	or     $0xffffff80,%edx
  101459:	88 90 21 a1 02 00    	mov    %dl,0x2a121(%eax)
  10145f:	c1 e9 10             	shr    $0x10,%ecx
  101462:	66 89 88 22 a1 02 00 	mov    %cx,0x2a122(%eax)
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  101469:	c7 c1 54 25 10 00    	mov    $0x102554,%ecx
  10146f:	66 89 88 2c a1 02 00 	mov    %cx,0x2a12c(%eax)
  101476:	66 c7 80 2e a1 02 00 	movw   $0x8,0x2a12e(%eax)
  10147d:	08 00 
  10147f:	0f b6 90 30 a1 02 00 	movzbl 0x2a130(%eax),%edx
  101486:	83 e2 e0             	and    $0xffffffe0,%edx
  101489:	88 90 30 a1 02 00    	mov    %dl,0x2a130(%eax)
  10148f:	c6 80 30 a1 02 00 00 	movb   $0x0,0x2a130(%eax)
  101496:	0f b6 90 31 a1 02 00 	movzbl 0x2a131(%eax),%edx
  10149d:	83 e2 f0             	and    $0xfffffff0,%edx
  1014a0:	83 ca 0e             	or     $0xe,%edx
  1014a3:	88 90 31 a1 02 00    	mov    %dl,0x2a131(%eax)
  1014a9:	89 d3                	mov    %edx,%ebx
  1014ab:	83 e3 ef             	and    $0xffffffef,%ebx
  1014ae:	88 98 31 a1 02 00    	mov    %bl,0x2a131(%eax)
  1014b4:	83 e2 8f             	and    $0xffffff8f,%edx
  1014b7:	88 90 31 a1 02 00    	mov    %dl,0x2a131(%eax)
  1014bd:	83 ca 80             	or     $0xffffff80,%edx
  1014c0:	88 90 31 a1 02 00    	mov    %dl,0x2a131(%eax)
  1014c6:	c1 e9 10             	shr    $0x10,%ecx
  1014c9:	66 89 88 32 a1 02 00 	mov    %cx,0x2a132(%eax)
    SETGATE(idt[T_ALIGN],                   0, CPU_GDT_KCODE, &Xalign,          0);
  1014d0:	c7 c1 5e 25 10 00    	mov    $0x10255e,%ecx
  1014d6:	66 89 88 34 a1 02 00 	mov    %cx,0x2a134(%eax)
  1014dd:	66 c7 80 36 a1 02 00 	movw   $0x8,0x2a136(%eax)
  1014e4:	08 00 
  1014e6:	0f b6 90 38 a1 02 00 	movzbl 0x2a138(%eax),%edx
  1014ed:	83 e2 e0             	and    $0xffffffe0,%edx
  1014f0:	88 90 38 a1 02 00    	mov    %dl,0x2a138(%eax)
  1014f6:	c6 80 38 a1 02 00 00 	movb   $0x0,0x2a138(%eax)
  1014fd:	0f b6 90 39 a1 02 00 	movzbl 0x2a139(%eax),%edx
  101504:	83 e2 f0             	and    $0xfffffff0,%edx
  101507:	83 ca 0e             	or     $0xe,%edx
  10150a:	88 90 39 a1 02 00    	mov    %dl,0x2a139(%eax)
  101510:	89 d3                	mov    %edx,%ebx
  101512:	83 e3 ef             	and    $0xffffffef,%ebx
  101515:	88 98 39 a1 02 00    	mov    %bl,0x2a139(%eax)
  10151b:	83 e2 8f             	and    $0xffffff8f,%edx
  10151e:	88 90 39 a1 02 00    	mov    %dl,0x2a139(%eax)
  101524:	83 ca 80             	or     $0xffffff80,%edx
  101527:	88 90 39 a1 02 00    	mov    %dl,0x2a139(%eax)
  10152d:	c1 e9 10             	shr    $0x10,%ecx
  101530:	66 89 88 3a a1 02 00 	mov    %cx,0x2a13a(%eax)
    SETGATE(idt[T_MCHK],                    0, CPU_GDT_KCODE, &Xmchk,           0);
  101537:	c7 c1 62 25 10 00    	mov    $0x102562,%ecx
  10153d:	66 89 88 3c a1 02 00 	mov    %cx,0x2a13c(%eax)
  101544:	66 c7 80 3e a1 02 00 	movw   $0x8,0x2a13e(%eax)
  10154b:	08 00 
  10154d:	0f b6 90 40 a1 02 00 	movzbl 0x2a140(%eax),%edx
  101554:	83 e2 e0             	and    $0xffffffe0,%edx
  101557:	88 90 40 a1 02 00    	mov    %dl,0x2a140(%eax)
  10155d:	c6 80 40 a1 02 00 00 	movb   $0x0,0x2a140(%eax)
  101564:	0f b6 90 41 a1 02 00 	movzbl 0x2a141(%eax),%edx
  10156b:	83 e2 f0             	and    $0xfffffff0,%edx
  10156e:	83 ca 0e             	or     $0xe,%edx
  101571:	88 90 41 a1 02 00    	mov    %dl,0x2a141(%eax)
  101577:	89 d3                	mov    %edx,%ebx
  101579:	83 e3 ef             	and    $0xffffffef,%ebx
  10157c:	88 98 41 a1 02 00    	mov    %bl,0x2a141(%eax)
  101582:	83 e2 8f             	and    $0xffffff8f,%edx
  101585:	88 90 41 a1 02 00    	mov    %dl,0x2a141(%eax)
  10158b:	83 ca 80             	or     $0xffffff80,%edx
  10158e:	88 90 41 a1 02 00    	mov    %dl,0x2a141(%eax)
  101594:	c1 e9 10             	shr    $0x10,%ecx
  101597:	66 89 88 42 a1 02 00 	mov    %cx,0x2a142(%eax)

    SETGATE(idt[T_IRQ0 + IRQ_TIMER],        0, CPU_GDT_KCODE, &Xirq_timer,      0);
  10159e:	c7 c1 68 25 10 00    	mov    $0x102568,%ecx
  1015a4:	66 89 88 ac a1 02 00 	mov    %cx,0x2a1ac(%eax)
  1015ab:	66 c7 80 ae a1 02 00 	movw   $0x8,0x2a1ae(%eax)
  1015b2:	08 00 
  1015b4:	0f b6 90 b0 a1 02 00 	movzbl 0x2a1b0(%eax),%edx
  1015bb:	83 e2 e0             	and    $0xffffffe0,%edx
  1015be:	88 90 b0 a1 02 00    	mov    %dl,0x2a1b0(%eax)
  1015c4:	c6 80 b0 a1 02 00 00 	movb   $0x0,0x2a1b0(%eax)
  1015cb:	0f b6 90 b1 a1 02 00 	movzbl 0x2a1b1(%eax),%edx
  1015d2:	83 e2 f0             	and    $0xfffffff0,%edx
  1015d5:	83 ca 0e             	or     $0xe,%edx
  1015d8:	88 90 b1 a1 02 00    	mov    %dl,0x2a1b1(%eax)
  1015de:	89 d3                	mov    %edx,%ebx
  1015e0:	83 e3 ef             	and    $0xffffffef,%ebx
  1015e3:	88 98 b1 a1 02 00    	mov    %bl,0x2a1b1(%eax)
  1015e9:	83 e2 8f             	and    $0xffffff8f,%edx
  1015ec:	88 90 b1 a1 02 00    	mov    %dl,0x2a1b1(%eax)
  1015f2:	83 ca 80             	or     $0xffffff80,%edx
  1015f5:	88 90 b1 a1 02 00    	mov    %dl,0x2a1b1(%eax)
  1015fb:	c1 e9 10             	shr    $0x10,%ecx
  1015fe:	66 89 88 b2 a1 02 00 	mov    %cx,0x2a1b2(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_KBD],          0, CPU_GDT_KCODE, &Xirq_kbd,        0);
  101605:	c7 c1 6e 25 10 00    	mov    $0x10256e,%ecx
  10160b:	66 89 88 b4 a1 02 00 	mov    %cx,0x2a1b4(%eax)
  101612:	66 c7 80 b6 a1 02 00 	movw   $0x8,0x2a1b6(%eax)
  101619:	08 00 
  10161b:	0f b6 90 b8 a1 02 00 	movzbl 0x2a1b8(%eax),%edx
  101622:	83 e2 e0             	and    $0xffffffe0,%edx
  101625:	88 90 b8 a1 02 00    	mov    %dl,0x2a1b8(%eax)
  10162b:	c6 80 b8 a1 02 00 00 	movb   $0x0,0x2a1b8(%eax)
  101632:	0f b6 90 b9 a1 02 00 	movzbl 0x2a1b9(%eax),%edx
  101639:	83 e2 f0             	and    $0xfffffff0,%edx
  10163c:	83 ca 0e             	or     $0xe,%edx
  10163f:	88 90 b9 a1 02 00    	mov    %dl,0x2a1b9(%eax)
  101645:	89 d3                	mov    %edx,%ebx
  101647:	83 e3 ef             	and    $0xffffffef,%ebx
  10164a:	88 98 b9 a1 02 00    	mov    %bl,0x2a1b9(%eax)
  101650:	83 e2 8f             	and    $0xffffff8f,%edx
  101653:	88 90 b9 a1 02 00    	mov    %dl,0x2a1b9(%eax)
  101659:	83 ca 80             	or     $0xffffff80,%edx
  10165c:	88 90 b9 a1 02 00    	mov    %dl,0x2a1b9(%eax)
  101662:	c1 e9 10             	shr    $0x10,%ecx
  101665:	66 89 88 ba a1 02 00 	mov    %cx,0x2a1ba(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_SLAVE],        0, CPU_GDT_KCODE, &Xirq_slave,      0);
  10166c:	c7 c1 74 25 10 00    	mov    $0x102574,%ecx
  101672:	66 89 88 bc a1 02 00 	mov    %cx,0x2a1bc(%eax)
  101679:	66 c7 80 be a1 02 00 	movw   $0x8,0x2a1be(%eax)
  101680:	08 00 
  101682:	0f b6 90 c0 a1 02 00 	movzbl 0x2a1c0(%eax),%edx
  101689:	83 e2 e0             	and    $0xffffffe0,%edx
  10168c:	88 90 c0 a1 02 00    	mov    %dl,0x2a1c0(%eax)
  101692:	c6 80 c0 a1 02 00 00 	movb   $0x0,0x2a1c0(%eax)
  101699:	0f b6 90 c1 a1 02 00 	movzbl 0x2a1c1(%eax),%edx
  1016a0:	83 e2 f0             	and    $0xfffffff0,%edx
  1016a3:	83 ca 0e             	or     $0xe,%edx
  1016a6:	88 90 c1 a1 02 00    	mov    %dl,0x2a1c1(%eax)
  1016ac:	89 d3                	mov    %edx,%ebx
  1016ae:	83 e3 ef             	and    $0xffffffef,%ebx
  1016b1:	88 98 c1 a1 02 00    	mov    %bl,0x2a1c1(%eax)
  1016b7:	83 e2 8f             	and    $0xffffff8f,%edx
  1016ba:	88 90 c1 a1 02 00    	mov    %dl,0x2a1c1(%eax)
  1016c0:	83 ca 80             	or     $0xffffff80,%edx
  1016c3:	88 90 c1 a1 02 00    	mov    %dl,0x2a1c1(%eax)
  1016c9:	c1 e9 10             	shr    $0x10,%ecx
  1016cc:	66 89 88 c2 a1 02 00 	mov    %cx,0x2a1c2(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  1016d3:	c7 c1 7a 25 10 00    	mov    $0x10257a,%ecx
  1016d9:	66 89 88 c4 a1 02 00 	mov    %cx,0x2a1c4(%eax)
  1016e0:	66 c7 80 c6 a1 02 00 	movw   $0x8,0x2a1c6(%eax)
  1016e7:	08 00 
  1016e9:	0f b6 90 c8 a1 02 00 	movzbl 0x2a1c8(%eax),%edx
  1016f0:	83 e2 e0             	and    $0xffffffe0,%edx
  1016f3:	88 90 c8 a1 02 00    	mov    %dl,0x2a1c8(%eax)
  1016f9:	c6 80 c8 a1 02 00 00 	movb   $0x0,0x2a1c8(%eax)
  101700:	0f b6 90 c9 a1 02 00 	movzbl 0x2a1c9(%eax),%edx
  101707:	83 e2 f0             	and    $0xfffffff0,%edx
  10170a:	83 ca 0e             	or     $0xe,%edx
  10170d:	88 90 c9 a1 02 00    	mov    %dl,0x2a1c9(%eax)
  101713:	89 d3                	mov    %edx,%ebx
  101715:	83 e3 ef             	and    $0xffffffef,%ebx
  101718:	88 98 c9 a1 02 00    	mov    %bl,0x2a1c9(%eax)
  10171e:	83 e2 8f             	and    $0xffffff8f,%edx
  101721:	88 90 c9 a1 02 00    	mov    %dl,0x2a1c9(%eax)
  101727:	83 ca 80             	or     $0xffffff80,%edx
  10172a:	88 90 c9 a1 02 00    	mov    %dl,0x2a1c9(%eax)
  101730:	c1 e9 10             	shr    $0x10,%ecx
  101733:	66 89 88 ca a1 02 00 	mov    %cx,0x2a1ca(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  10173a:	c7 c1 80 25 10 00    	mov    $0x102580,%ecx
  101740:	66 89 88 cc a1 02 00 	mov    %cx,0x2a1cc(%eax)
  101747:	66 c7 80 ce a1 02 00 	movw   $0x8,0x2a1ce(%eax)
  10174e:	08 00 
  101750:	0f b6 90 d0 a1 02 00 	movzbl 0x2a1d0(%eax),%edx
  101757:	83 e2 e0             	and    $0xffffffe0,%edx
  10175a:	88 90 d0 a1 02 00    	mov    %dl,0x2a1d0(%eax)
  101760:	c6 80 d0 a1 02 00 00 	movb   $0x0,0x2a1d0(%eax)
  101767:	0f b6 90 d1 a1 02 00 	movzbl 0x2a1d1(%eax),%edx
  10176e:	83 e2 f0             	and    $0xfffffff0,%edx
  101771:	83 ca 0e             	or     $0xe,%edx
  101774:	88 90 d1 a1 02 00    	mov    %dl,0x2a1d1(%eax)
  10177a:	89 d3                	mov    %edx,%ebx
  10177c:	83 e3 ef             	and    $0xffffffef,%ebx
  10177f:	88 98 d1 a1 02 00    	mov    %bl,0x2a1d1(%eax)
  101785:	83 e2 8f             	and    $0xffffff8f,%edx
  101788:	88 90 d1 a1 02 00    	mov    %dl,0x2a1d1(%eax)
  10178e:	83 ca 80             	or     $0xffffff80,%edx
  101791:	88 90 d1 a1 02 00    	mov    %dl,0x2a1d1(%eax)
  101797:	c1 e9 10             	shr    $0x10,%ecx
  10179a:	66 89 88 d2 a1 02 00 	mov    %cx,0x2a1d2(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_LPT2],         0, CPU_GDT_KCODE, &Xirq_lpt,        0);
  1017a1:	c7 c1 86 25 10 00    	mov    $0x102586,%ecx
  1017a7:	66 89 88 d4 a1 02 00 	mov    %cx,0x2a1d4(%eax)
  1017ae:	66 c7 80 d6 a1 02 00 	movw   $0x8,0x2a1d6(%eax)
  1017b5:	08 00 
  1017b7:	0f b6 90 d8 a1 02 00 	movzbl 0x2a1d8(%eax),%edx
  1017be:	83 e2 e0             	and    $0xffffffe0,%edx
  1017c1:	88 90 d8 a1 02 00    	mov    %dl,0x2a1d8(%eax)
  1017c7:	c6 80 d8 a1 02 00 00 	movb   $0x0,0x2a1d8(%eax)
  1017ce:	0f b6 90 d9 a1 02 00 	movzbl 0x2a1d9(%eax),%edx
  1017d5:	83 e2 f0             	and    $0xfffffff0,%edx
  1017d8:	83 ca 0e             	or     $0xe,%edx
  1017db:	88 90 d9 a1 02 00    	mov    %dl,0x2a1d9(%eax)
  1017e1:	89 d3                	mov    %edx,%ebx
  1017e3:	83 e3 ef             	and    $0xffffffef,%ebx
  1017e6:	88 98 d9 a1 02 00    	mov    %bl,0x2a1d9(%eax)
  1017ec:	83 e2 8f             	and    $0xffffff8f,%edx
  1017ef:	88 90 d9 a1 02 00    	mov    %dl,0x2a1d9(%eax)
  1017f5:	83 ca 80             	or     $0xffffff80,%edx
  1017f8:	88 90 d9 a1 02 00    	mov    %dl,0x2a1d9(%eax)
  1017fe:	c1 e9 10             	shr    $0x10,%ecx
  101801:	66 89 88 da a1 02 00 	mov    %cx,0x2a1da(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_FLOPPY],       0, CPU_GDT_KCODE, &Xirq_floppy,     0);
  101808:	c7 c1 8c 25 10 00    	mov    $0x10258c,%ecx
  10180e:	66 89 88 dc a1 02 00 	mov    %cx,0x2a1dc(%eax)
  101815:	66 c7 80 de a1 02 00 	movw   $0x8,0x2a1de(%eax)
  10181c:	08 00 
  10181e:	0f b6 90 e0 a1 02 00 	movzbl 0x2a1e0(%eax),%edx
  101825:	83 e2 e0             	and    $0xffffffe0,%edx
  101828:	88 90 e0 a1 02 00    	mov    %dl,0x2a1e0(%eax)
  10182e:	c6 80 e0 a1 02 00 00 	movb   $0x0,0x2a1e0(%eax)
  101835:	0f b6 90 e1 a1 02 00 	movzbl 0x2a1e1(%eax),%edx
  10183c:	83 e2 f0             	and    $0xfffffff0,%edx
  10183f:	83 ca 0e             	or     $0xe,%edx
  101842:	88 90 e1 a1 02 00    	mov    %dl,0x2a1e1(%eax)
  101848:	89 d3                	mov    %edx,%ebx
  10184a:	83 e3 ef             	and    $0xffffffef,%ebx
  10184d:	88 98 e1 a1 02 00    	mov    %bl,0x2a1e1(%eax)
  101853:	83 e2 8f             	and    $0xffffff8f,%edx
  101856:	88 90 e1 a1 02 00    	mov    %dl,0x2a1e1(%eax)
  10185c:	83 ca 80             	or     $0xffffff80,%edx
  10185f:	88 90 e1 a1 02 00    	mov    %dl,0x2a1e1(%eax)
  101865:	c1 e9 10             	shr    $0x10,%ecx
  101868:	66 89 88 e2 a1 02 00 	mov    %cx,0x2a1e2(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_SPURIOUS],     0, CPU_GDT_KCODE, &Xirq_spurious,   0);
  10186f:	c7 c1 92 25 10 00    	mov    $0x102592,%ecx
  101875:	66 89 88 e4 a1 02 00 	mov    %cx,0x2a1e4(%eax)
  10187c:	66 c7 80 e6 a1 02 00 	movw   $0x8,0x2a1e6(%eax)
  101883:	08 00 
  101885:	0f b6 90 e8 a1 02 00 	movzbl 0x2a1e8(%eax),%edx
  10188c:	83 e2 e0             	and    $0xffffffe0,%edx
  10188f:	88 90 e8 a1 02 00    	mov    %dl,0x2a1e8(%eax)
  101895:	c6 80 e8 a1 02 00 00 	movb   $0x0,0x2a1e8(%eax)
  10189c:	0f b6 90 e9 a1 02 00 	movzbl 0x2a1e9(%eax),%edx
  1018a3:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a6:	83 ca 0e             	or     $0xe,%edx
  1018a9:	88 90 e9 a1 02 00    	mov    %dl,0x2a1e9(%eax)
  1018af:	89 d3                	mov    %edx,%ebx
  1018b1:	83 e3 ef             	and    $0xffffffef,%ebx
  1018b4:	88 98 e9 a1 02 00    	mov    %bl,0x2a1e9(%eax)
  1018ba:	83 e2 8f             	and    $0xffffff8f,%edx
  1018bd:	88 90 e9 a1 02 00    	mov    %dl,0x2a1e9(%eax)
  1018c3:	83 ca 80             	or     $0xffffff80,%edx
  1018c6:	88 90 e9 a1 02 00    	mov    %dl,0x2a1e9(%eax)
  1018cc:	c1 e9 10             	shr    $0x10,%ecx
  1018cf:	66 89 88 ea a1 02 00 	mov    %cx,0x2a1ea(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_RTC],          0, CPU_GDT_KCODE, &Xirq_rtc,        0);
  1018d6:	c7 c1 98 25 10 00    	mov    $0x102598,%ecx
  1018dc:	66 89 88 ec a1 02 00 	mov    %cx,0x2a1ec(%eax)
  1018e3:	66 c7 80 ee a1 02 00 	movw   $0x8,0x2a1ee(%eax)
  1018ea:	08 00 
  1018ec:	0f b6 90 f0 a1 02 00 	movzbl 0x2a1f0(%eax),%edx
  1018f3:	83 e2 e0             	and    $0xffffffe0,%edx
  1018f6:	88 90 f0 a1 02 00    	mov    %dl,0x2a1f0(%eax)
  1018fc:	c6 80 f0 a1 02 00 00 	movb   $0x0,0x2a1f0(%eax)
  101903:	0f b6 90 f1 a1 02 00 	movzbl 0x2a1f1(%eax),%edx
  10190a:	83 e2 f0             	and    $0xfffffff0,%edx
  10190d:	83 ca 0e             	or     $0xe,%edx
  101910:	88 90 f1 a1 02 00    	mov    %dl,0x2a1f1(%eax)
  101916:	89 d3                	mov    %edx,%ebx
  101918:	83 e3 ef             	and    $0xffffffef,%ebx
  10191b:	88 98 f1 a1 02 00    	mov    %bl,0x2a1f1(%eax)
  101921:	83 e2 8f             	and    $0xffffff8f,%edx
  101924:	88 90 f1 a1 02 00    	mov    %dl,0x2a1f1(%eax)
  10192a:	83 ca 80             	or     $0xffffff80,%edx
  10192d:	88 90 f1 a1 02 00    	mov    %dl,0x2a1f1(%eax)
  101933:	c1 e9 10             	shr    $0x10,%ecx
  101936:	66 89 88 f2 a1 02 00 	mov    %cx,0x2a1f2(%eax)
    SETGATE(idt[T_IRQ0 + 9],                0, CPU_GDT_KCODE, &Xirq9,           0);
  10193d:	c7 c1 9e 25 10 00    	mov    $0x10259e,%ecx
  101943:	66 89 88 f4 a1 02 00 	mov    %cx,0x2a1f4(%eax)
  10194a:	66 c7 80 f6 a1 02 00 	movw   $0x8,0x2a1f6(%eax)
  101951:	08 00 
  101953:	0f b6 90 f8 a1 02 00 	movzbl 0x2a1f8(%eax),%edx
  10195a:	83 e2 e0             	and    $0xffffffe0,%edx
  10195d:	88 90 f8 a1 02 00    	mov    %dl,0x2a1f8(%eax)
  101963:	c6 80 f8 a1 02 00 00 	movb   $0x0,0x2a1f8(%eax)
  10196a:	0f b6 90 f9 a1 02 00 	movzbl 0x2a1f9(%eax),%edx
  101971:	83 e2 f0             	and    $0xfffffff0,%edx
  101974:	83 ca 0e             	or     $0xe,%edx
  101977:	88 90 f9 a1 02 00    	mov    %dl,0x2a1f9(%eax)
  10197d:	89 d3                	mov    %edx,%ebx
  10197f:	83 e3 ef             	and    $0xffffffef,%ebx
  101982:	88 98 f9 a1 02 00    	mov    %bl,0x2a1f9(%eax)
  101988:	83 e2 8f             	and    $0xffffff8f,%edx
  10198b:	88 90 f9 a1 02 00    	mov    %dl,0x2a1f9(%eax)
  101991:	83 ca 80             	or     $0xffffff80,%edx
  101994:	88 90 f9 a1 02 00    	mov    %dl,0x2a1f9(%eax)
  10199a:	c1 e9 10             	shr    $0x10,%ecx
  10199d:	66 89 88 fa a1 02 00 	mov    %cx,0x2a1fa(%eax)
    SETGATE(idt[T_IRQ0 + 10],               0, CPU_GDT_KCODE, &Xirq10,          0);
  1019a4:	c7 c2 a4 25 10 00    	mov    $0x1025a4,%edx
  1019aa:	66 89 90 fc a1 02 00 	mov    %dx,0x2a1fc(%eax)
  1019b1:	66 c7 80 fe a1 02 00 	movw   $0x8,0x2a1fe(%eax)
  1019b8:	08 00 
  1019ba:	0f b6 90 00 a2 02 00 	movzbl 0x2a200(%eax),%edx
  1019c1:	83 e2 e0             	and    $0xffffffe0,%edx
  1019c4:	88 90 00 a2 02 00    	mov    %dl,0x2a200(%eax)
  1019ca:	c6 80 00 a2 02 00 00 	movb   $0x0,0x2a200(%eax)
  1019d1:	0f b6 90 01 a2 02 00 	movzbl 0x2a201(%eax),%edx
  1019d8:	83 e2 f0             	and    $0xfffffff0,%edx
  1019db:	83 ca 0e             	or     $0xe,%edx
  1019de:	88 90 01 a2 02 00    	mov    %dl,0x2a201(%eax)
  1019e4:	89 d1                	mov    %edx,%ecx
  1019e6:	83 e1 ef             	and    $0xffffffef,%ecx
  1019e9:	88 88 01 a2 02 00    	mov    %cl,0x2a201(%eax)
  1019ef:	83 e2 8f             	and    $0xffffff8f,%edx
  1019f2:	88 90 01 a2 02 00    	mov    %dl,0x2a201(%eax)
  1019f8:	83 ca 80             	or     $0xffffff80,%edx
  1019fb:	88 90 01 a2 02 00    	mov    %dl,0x2a201(%eax)
  101a01:	c7 c2 a4 25 10 00    	mov    $0x1025a4,%edx
  101a07:	c1 ea 10             	shr    $0x10,%edx
  101a0a:	66 89 90 02 a2 02 00 	mov    %dx,0x2a202(%eax)
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  101a11:	c7 c1 aa 25 10 00    	mov    $0x1025aa,%ecx
  101a17:	66 89 88 04 a2 02 00 	mov    %cx,0x2a204(%eax)
  101a1e:	66 c7 80 06 a2 02 00 	movw   $0x8,0x2a206(%eax)
  101a25:	08 00 
  101a27:	0f b6 90 08 a2 02 00 	movzbl 0x2a208(%eax),%edx
  101a2e:	83 e2 e0             	and    $0xffffffe0,%edx
  101a31:	88 90 08 a2 02 00    	mov    %dl,0x2a208(%eax)
  101a37:	c6 80 08 a2 02 00 00 	movb   $0x0,0x2a208(%eax)
  101a3e:	0f b6 90 09 a2 02 00 	movzbl 0x2a209(%eax),%edx
  101a45:	83 e2 f0             	and    $0xfffffff0,%edx
  101a48:	83 ca 0e             	or     $0xe,%edx
  101a4b:	88 90 09 a2 02 00    	mov    %dl,0x2a209(%eax)
  101a51:	89 d3                	mov    %edx,%ebx
  101a53:	83 e3 ef             	and    $0xffffffef,%ebx
  101a56:	88 98 09 a2 02 00    	mov    %bl,0x2a209(%eax)
  101a5c:	83 e2 8f             	and    $0xffffff8f,%edx
  101a5f:	88 90 09 a2 02 00    	mov    %dl,0x2a209(%eax)
  101a65:	83 ca 80             	or     $0xffffff80,%edx
  101a68:	88 90 09 a2 02 00    	mov    %dl,0x2a209(%eax)
  101a6e:	c1 e9 10             	shr    $0x10,%ecx
  101a71:	66 89 88 0a a2 02 00 	mov    %cx,0x2a20a(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_MOUSE],        0, CPU_GDT_KCODE, &Xirq_mouse,      0);
  101a78:	c7 c1 b0 25 10 00    	mov    $0x1025b0,%ecx
  101a7e:	66 89 88 0c a2 02 00 	mov    %cx,0x2a20c(%eax)
  101a85:	66 c7 80 0e a2 02 00 	movw   $0x8,0x2a20e(%eax)
  101a8c:	08 00 
  101a8e:	0f b6 90 10 a2 02 00 	movzbl 0x2a210(%eax),%edx
  101a95:	83 e2 e0             	and    $0xffffffe0,%edx
  101a98:	88 90 10 a2 02 00    	mov    %dl,0x2a210(%eax)
  101a9e:	c6 80 10 a2 02 00 00 	movb   $0x0,0x2a210(%eax)
  101aa5:	0f b6 90 11 a2 02 00 	movzbl 0x2a211(%eax),%edx
  101aac:	83 e2 f0             	and    $0xfffffff0,%edx
  101aaf:	83 ca 0e             	or     $0xe,%edx
  101ab2:	88 90 11 a2 02 00    	mov    %dl,0x2a211(%eax)
  101ab8:	89 d3                	mov    %edx,%ebx
  101aba:	83 e3 ef             	and    $0xffffffef,%ebx
  101abd:	88 98 11 a2 02 00    	mov    %bl,0x2a211(%eax)
  101ac3:	83 e2 8f             	and    $0xffffff8f,%edx
  101ac6:	88 90 11 a2 02 00    	mov    %dl,0x2a211(%eax)
  101acc:	83 ca 80             	or     $0xffffff80,%edx
  101acf:	88 90 11 a2 02 00    	mov    %dl,0x2a211(%eax)
  101ad5:	c1 e9 10             	shr    $0x10,%ecx
  101ad8:	66 89 88 12 a2 02 00 	mov    %cx,0x2a212(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_COPROCESSOR],  0, CPU_GDT_KCODE, &Xirq_coproc,     0);
  101adf:	c7 c1 b6 25 10 00    	mov    $0x1025b6,%ecx
  101ae5:	66 89 88 14 a2 02 00 	mov    %cx,0x2a214(%eax)
  101aec:	66 c7 80 16 a2 02 00 	movw   $0x8,0x2a216(%eax)
  101af3:	08 00 
  101af5:	0f b6 90 18 a2 02 00 	movzbl 0x2a218(%eax),%edx
  101afc:	83 e2 e0             	and    $0xffffffe0,%edx
  101aff:	88 90 18 a2 02 00    	mov    %dl,0x2a218(%eax)
  101b05:	c6 80 18 a2 02 00 00 	movb   $0x0,0x2a218(%eax)
  101b0c:	0f b6 90 19 a2 02 00 	movzbl 0x2a219(%eax),%edx
  101b13:	83 e2 f0             	and    $0xfffffff0,%edx
  101b16:	83 ca 0e             	or     $0xe,%edx
  101b19:	88 90 19 a2 02 00    	mov    %dl,0x2a219(%eax)
  101b1f:	89 d3                	mov    %edx,%ebx
  101b21:	83 e3 ef             	and    $0xffffffef,%ebx
  101b24:	88 98 19 a2 02 00    	mov    %bl,0x2a219(%eax)
  101b2a:	83 e2 8f             	and    $0xffffff8f,%edx
  101b2d:	88 90 19 a2 02 00    	mov    %dl,0x2a219(%eax)
  101b33:	83 ca 80             	or     $0xffffff80,%edx
  101b36:	88 90 19 a2 02 00    	mov    %dl,0x2a219(%eax)
  101b3c:	c1 e9 10             	shr    $0x10,%ecx
  101b3f:	66 89 88 1a a2 02 00 	mov    %cx,0x2a21a(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_IDE1],         0, CPU_GDT_KCODE, &Xirq_ide1,       0);
  101b46:	c7 c1 bc 25 10 00    	mov    $0x1025bc,%ecx
  101b4c:	66 89 88 1c a2 02 00 	mov    %cx,0x2a21c(%eax)
  101b53:	66 c7 80 1e a2 02 00 	movw   $0x8,0x2a21e(%eax)
  101b5a:	08 00 
  101b5c:	0f b6 90 20 a2 02 00 	movzbl 0x2a220(%eax),%edx
  101b63:	83 e2 e0             	and    $0xffffffe0,%edx
  101b66:	88 90 20 a2 02 00    	mov    %dl,0x2a220(%eax)
  101b6c:	c6 80 20 a2 02 00 00 	movb   $0x0,0x2a220(%eax)
  101b73:	0f b6 90 21 a2 02 00 	movzbl 0x2a221(%eax),%edx
  101b7a:	83 e2 f0             	and    $0xfffffff0,%edx
  101b7d:	83 ca 0e             	or     $0xe,%edx
  101b80:	88 90 21 a2 02 00    	mov    %dl,0x2a221(%eax)
  101b86:	89 d3                	mov    %edx,%ebx
  101b88:	83 e3 ef             	and    $0xffffffef,%ebx
  101b8b:	88 98 21 a2 02 00    	mov    %bl,0x2a221(%eax)
  101b91:	83 e2 8f             	and    $0xffffff8f,%edx
  101b94:	88 90 21 a2 02 00    	mov    %dl,0x2a221(%eax)
  101b9a:	83 ca 80             	or     $0xffffff80,%edx
  101b9d:	88 90 21 a2 02 00    	mov    %dl,0x2a221(%eax)
  101ba3:	c1 e9 10             	shr    $0x10,%ecx
  101ba6:	66 89 88 22 a2 02 00 	mov    %cx,0x2a222(%eax)
    SETGATE(idt[T_IRQ0 + IRQ_IDE2],         0, CPU_GDT_KCODE, &Xirq_ide2,       0);
  101bad:	c7 c1 c2 25 10 00    	mov    $0x1025c2,%ecx
  101bb3:	66 89 88 24 a2 02 00 	mov    %cx,0x2a224(%eax)
  101bba:	66 c7 80 26 a2 02 00 	movw   $0x8,0x2a226(%eax)
  101bc1:	08 00 
  101bc3:	0f b6 90 28 a2 02 00 	movzbl 0x2a228(%eax),%edx
  101bca:	83 e2 e0             	and    $0xffffffe0,%edx
  101bcd:	88 90 28 a2 02 00    	mov    %dl,0x2a228(%eax)
  101bd3:	c6 80 28 a2 02 00 00 	movb   $0x0,0x2a228(%eax)
  101bda:	0f b6 90 29 a2 02 00 	movzbl 0x2a229(%eax),%edx
  101be1:	83 e2 f0             	and    $0xfffffff0,%edx
  101be4:	83 ca 0e             	or     $0xe,%edx
  101be7:	88 90 29 a2 02 00    	mov    %dl,0x2a229(%eax)
  101bed:	89 d3                	mov    %edx,%ebx
  101bef:	83 e3 ef             	and    $0xffffffef,%ebx
  101bf2:	88 98 29 a2 02 00    	mov    %bl,0x2a229(%eax)
  101bf8:	83 e2 8f             	and    $0xffffff8f,%edx
  101bfb:	88 90 29 a2 02 00    	mov    %dl,0x2a229(%eax)
  101c01:	83 ca 80             	or     $0xffffff80,%edx
  101c04:	88 90 29 a2 02 00    	mov    %dl,0x2a229(%eax)
  101c0a:	c1 e9 10             	shr    $0x10,%ecx
  101c0d:	66 89 88 2a a2 02 00 	mov    %cx,0x2a22a(%eax)

    // Use DPL=3 here because system calls are explicitly invoked
    // by the user process (with "int $T_SYSCALL").
    SETGATE(idt[T_SYSCALL], 0, CPU_GDT_KCODE, &Xsyscall, 3);
  101c14:	c7 c1 c8 25 10 00    	mov    $0x1025c8,%ecx
  101c1a:	66 89 88 2c a2 02 00 	mov    %cx,0x2a22c(%eax)
  101c21:	66 c7 80 2e a2 02 00 	movw   $0x8,0x2a22e(%eax)
  101c28:	08 00 
  101c2a:	0f b6 90 30 a2 02 00 	movzbl 0x2a230(%eax),%edx
  101c31:	83 e2 e0             	and    $0xffffffe0,%edx
  101c34:	88 90 30 a2 02 00    	mov    %dl,0x2a230(%eax)
  101c3a:	c6 80 30 a2 02 00 00 	movb   $0x0,0x2a230(%eax)
  101c41:	0f b6 90 31 a2 02 00 	movzbl 0x2a231(%eax),%edx
  101c48:	83 e2 f0             	and    $0xfffffff0,%edx
  101c4b:	83 ca 0e             	or     $0xe,%edx
  101c4e:	88 90 31 a2 02 00    	mov    %dl,0x2a231(%eax)
  101c54:	83 e2 ef             	and    $0xffffffef,%edx
  101c57:	88 90 31 a2 02 00    	mov    %dl,0x2a231(%eax)
  101c5d:	89 d3                	mov    %edx,%ebx
  101c5f:	83 cb 60             	or     $0x60,%ebx
  101c62:	88 98 31 a2 02 00    	mov    %bl,0x2a231(%eax)
  101c68:	83 ca e0             	or     $0xffffffe0,%edx
  101c6b:	88 90 31 a2 02 00    	mov    %dl,0x2a231(%eax)
  101c71:	c1 e9 10             	shr    $0x10,%ecx
  101c74:	66 89 88 32 a2 02 00 	mov    %cx,0x2a232(%eax)

    /* default */
    SETGATE(idt[T_DEFAULT], 0, CPU_GDT_KCODE, &Xdefault, 0);
  101c7b:	c7 c1 ce 25 10 00    	mov    $0x1025ce,%ecx
  101c81:	66 89 88 9c a8 02 00 	mov    %cx,0x2a89c(%eax)
  101c88:	66 c7 80 9e a8 02 00 	movw   $0x8,0x2a89e(%eax)
  101c8f:	08 00 
  101c91:	0f b6 90 a0 a8 02 00 	movzbl 0x2a8a0(%eax),%edx
  101c98:	83 e2 e0             	and    $0xffffffe0,%edx
  101c9b:	88 90 a0 a8 02 00    	mov    %dl,0x2a8a0(%eax)
  101ca1:	c6 80 a0 a8 02 00 00 	movb   $0x0,0x2a8a0(%eax)
  101ca8:	0f b6 90 a1 a8 02 00 	movzbl 0x2a8a1(%eax),%edx
  101caf:	83 e2 f0             	and    $0xfffffff0,%edx
  101cb2:	83 ca 0e             	or     $0xe,%edx
  101cb5:	88 90 a1 a8 02 00    	mov    %dl,0x2a8a1(%eax)
  101cbb:	89 d3                	mov    %edx,%ebx
  101cbd:	83 e3 ef             	and    $0xffffffef,%ebx
  101cc0:	88 98 a1 a8 02 00    	mov    %bl,0x2a8a1(%eax)
  101cc6:	83 e2 8f             	and    $0xffffff8f,%edx
  101cc9:	88 90 a1 a8 02 00    	mov    %dl,0x2a8a1(%eax)
  101ccf:	83 ca 80             	or     $0xffffff80,%edx
  101cd2:	88 90 a1 a8 02 00    	mov    %dl,0x2a8a1(%eax)
  101cd8:	c1 e9 10             	shr    $0x10,%ecx
  101cdb:	66 89 88 a2 a8 02 00 	mov    %cx,0x2a8a2(%eax)

    asm volatile ("lidt %0" :: "m" (idt_pd));
  101ce2:	0f 01 98 0c 03 00 00 	lidtl  0x30c(%eax)
}
  101ce9:	5b                   	pop    %ebx
  101cea:	5e                   	pop    %esi
  101ceb:	5f                   	pop    %edi
  101cec:	5d                   	pop    %ebp
  101ced:	c3                   	ret

00101cee <intr_init>:

void intr_init(void)
{
  101cee:	53                   	push   %ebx
  101cef:	83 ec 08             	sub    $0x8,%esp
  101cf2:	e8 46 e6 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101cf7:	81 c3 fd d2 00 00    	add    $0xd2fd,%ebx
    if (intr_inited == TRUE)
  101cfd:	0f b6 83 ac a8 02 00 	movzbl 0x2a8ac(%ebx),%eax
  101d04:	3c 01                	cmp    $0x1,%al
  101d06:	74 11                	je     101d19 <intr_init+0x2b>
        return;

    pic_init();
  101d08:	e8 89 00 00 00       	call   101d96 <pic_init>
    intr_init_idt();
  101d0d:	e8 20 f1 ff ff       	call   100e32 <intr_init_idt>
    intr_inited = TRUE;
  101d12:	c6 83 ac a8 02 00 01 	movb   $0x1,0x2a8ac(%ebx)
}
  101d19:	83 c4 08             	add    $0x8,%esp
  101d1c:	5b                   	pop    %ebx
  101d1d:	c3                   	ret

00101d1e <intr_enable>:

void intr_enable(uint8_t irq)
{
  101d1e:	53                   	push   %ebx
  101d1f:	83 ec 08             	sub    $0x8,%esp
  101d22:	e8 16 e6 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101d27:	81 c3 cd d2 00 00    	add    $0xd2cd,%ebx
  101d2d:	8b 44 24 10          	mov    0x10(%esp),%eax
    if (irq >= 16)
  101d31:	3c 0f                	cmp    $0xf,%al
  101d33:	76 05                	jbe    101d3a <intr_enable+0x1c>
        return;
    pic_enable(irq);
}
  101d35:	83 c4 08             	add    $0x8,%esp
  101d38:	5b                   	pop    %ebx
  101d39:	c3                   	ret
    pic_enable(irq);
  101d3a:	83 ec 0c             	sub    $0xc,%esp
  101d3d:	0f b6 c0             	movzbl %al,%eax
  101d40:	50                   	push   %eax
  101d41:	e8 a0 01 00 00       	call   101ee6 <pic_enable>
  101d46:	83 c4 10             	add    $0x10,%esp
  101d49:	eb ea                	jmp    101d35 <intr_enable+0x17>

00101d4b <intr_eoi>:

void intr_eoi(void)
{
  101d4b:	53                   	push   %ebx
  101d4c:	83 ec 08             	sub    $0x8,%esp
  101d4f:	e8 e9 e5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101d54:	81 c3 a0 d2 00 00    	add    $0xd2a0,%ebx
    pic_eoi();
  101d5a:	e8 b6 01 00 00       	call   101f15 <pic_eoi>
}
  101d5f:	83 c4 08             	add    $0x8,%esp
  101d62:	5b                   	pop    %ebx
  101d63:	c3                   	ret

00101d64 <intr_local_enable>:

void intr_local_enable(void)
{
  101d64:	53                   	push   %ebx
  101d65:	83 ec 08             	sub    $0x8,%esp
  101d68:	e8 d0 e5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101d6d:	81 c3 87 d2 00 00    	add    $0xd287,%ebx
    sti();
  101d73:	e8 e5 17 00 00       	call   10355d <sti>
}
  101d78:	83 c4 08             	add    $0x8,%esp
  101d7b:	5b                   	pop    %ebx
  101d7c:	c3                   	ret

00101d7d <intr_local_disable>:

void intr_local_disable(void)
{
  101d7d:	53                   	push   %ebx
  101d7e:	83 ec 08             	sub    $0x8,%esp
  101d81:	e8 b7 e5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101d86:	81 c3 6e d2 00 00    	add    $0xd26e,%ebx
    cli();
  101d8c:	e8 ca 17 00 00       	call   10355b <cli>
}
  101d91:	83 c4 08             	add    $0x8,%esp
  101d94:	5b                   	pop    %ebx
  101d95:	c3                   	ret

00101d96 <pic_init>:
static uint16_t irqmask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool pic_inited = FALSE;

/* Initialize the 8259A interrupt controllers. */
void pic_init(void)
{
  101d96:	53                   	push   %ebx
  101d97:	83 ec 08             	sub    $0x8,%esp
  101d9a:	e8 9e e5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101d9f:	81 c3 55 d2 00 00    	add    $0xd255,%ebx
    if (pic_inited == TRUE)  // only do once on bootstrap CPU
  101da5:	80 bb ad a8 02 00 01 	cmpb   $0x1,0x2a8ad(%ebx)
  101dac:	0f 84 ee 00 00 00    	je     101ea0 <pic_init+0x10a>
        return;
    pic_inited = TRUE;
  101db2:	c6 83 ad a8 02 00 01 	movb   $0x1,0x2a8ad(%ebx)

    /* mask all interrupts */
    outb(IO_PIC1 + 1, 0xff);
  101db9:	83 ec 08             	sub    $0x8,%esp
  101dbc:	68 ff 00 00 00       	push   $0xff
  101dc1:	6a 21                	push   $0x21
  101dc3:	e8 5b 18 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, 0xff);
  101dc8:	83 c4 08             	add    $0x8,%esp
  101dcb:	68 ff 00 00 00       	push   $0xff
  101dd0:	68 a1 00 00 00       	push   $0xa1
  101dd5:	e8 49 18 00 00       	call   103623 <outb>

    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);
  101dda:	83 c4 08             	add    $0x8,%esp
  101ddd:	6a 11                	push   $0x11
  101ddf:	6a 20                	push   $0x20
  101de1:	e8 3d 18 00 00       	call   103623 <outb>

    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, T_IRQ0);
  101de6:	83 c4 08             	add    $0x8,%esp
  101de9:	6a 20                	push   $0x20
  101deb:	6a 21                	push   $0x21
  101ded:	e8 31 18 00 00       	call   103623 <outb>

    // ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
    //        3-bit No of IR line at which slave connects to master (slave PIC).
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
  101df2:	83 c4 08             	add    $0x8,%esp
  101df5:	6a 04                	push   $0x4
  101df7:	6a 21                	push   $0x21
  101df9:	e8 25 18 00 00       	call   103623 <outb>
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //        can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x1);
  101dfe:	83 c4 08             	add    $0x8,%esp
  101e01:	6a 01                	push   $0x1
  101e03:	6a 21                	push   $0x21
  101e05:	e8 19 18 00 00       	call   103623 <outb>

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);            // ICW1
  101e0a:	83 c4 08             	add    $0x8,%esp
  101e0d:	6a 11                	push   $0x11
  101e0f:	68 a0 00 00 00       	push   $0xa0
  101e14:	e8 0a 18 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, T_IRQ0 + 8);  // ICW2
  101e19:	83 c4 08             	add    $0x8,%esp
  101e1c:	6a 28                	push   $0x28
  101e1e:	68 a1 00 00 00       	push   $0xa1
  101e23:	e8 fb 17 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
  101e28:	83 c4 08             	add    $0x8,%esp
  101e2b:	6a 02                	push   $0x2
  101e2d:	68 a1 00 00 00       	push   $0xa1
  101e32:	e8 ec 17 00 00       	call   103623 <outb>
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x01);        // ICW4
  101e37:	83 c4 08             	add    $0x8,%esp
  101e3a:	6a 01                	push   $0x1
  101e3c:	68 a1 00 00 00       	push   $0xa1
  101e41:	e8 dd 17 00 00       	call   103623 <outb>

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);  /* clear specific mask */
  101e46:	83 c4 08             	add    $0x8,%esp
  101e49:	6a 68                	push   $0x68
  101e4b:	6a 20                	push   $0x20
  101e4d:	e8 d1 17 00 00       	call   103623 <outb>
    outb(IO_PIC1, 0x0a);  /* read IRR by default */
  101e52:	83 c4 08             	add    $0x8,%esp
  101e55:	6a 0a                	push   $0xa
  101e57:	6a 20                	push   $0x20
  101e59:	e8 c5 17 00 00       	call   103623 <outb>

    outb(IO_PIC2, 0x68);  /* OCW3 */
  101e5e:	83 c4 08             	add    $0x8,%esp
  101e61:	6a 68                	push   $0x68
  101e63:	68 a0 00 00 00       	push   $0xa0
  101e68:	e8 b6 17 00 00       	call   103623 <outb>
    outb(IO_PIC2, 0x0a);  /* OCW3 */
  101e6d:	83 c4 08             	add    $0x8,%esp
  101e70:	6a 0a                	push   $0xa
  101e72:	68 a0 00 00 00       	push   $0xa0
  101e77:	e8 a7 17 00 00       	call   103623 <outb>

    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
  101e7c:	83 c4 08             	add    $0x8,%esp
  101e7f:	68 ff 00 00 00       	push   $0xff
  101e84:	6a 21                	push   $0x21
  101e86:	e8 98 17 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, 0xFF);
  101e8b:	83 c4 08             	add    $0x8,%esp
  101e8e:	68 ff 00 00 00       	push   $0xff
  101e93:	68 a1 00 00 00       	push   $0xa1
  101e98:	e8 86 17 00 00       	call   103623 <outb>
  101e9d:	83 c4 10             	add    $0x10,%esp
}
  101ea0:	83 c4 08             	add    $0x8,%esp
  101ea3:	5b                   	pop    %ebx
  101ea4:	c3                   	ret

00101ea5 <pic_setmask>:

void pic_setmask(uint16_t mask)
{
  101ea5:	56                   	push   %esi
  101ea6:	53                   	push   %ebx
  101ea7:	83 ec 0c             	sub    $0xc,%esp
  101eaa:	e8 8e e4 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101eaf:	81 c3 45 d1 00 00    	add    $0xd145,%ebx
  101eb5:	8b 74 24 18          	mov    0x18(%esp),%esi
    irqmask = mask;
  101eb9:	66 89 b3 12 03 00 00 	mov    %si,0x312(%ebx)
    outb(IO_PIC1 + 1, (char) mask);
  101ec0:	89 f0                	mov    %esi,%eax
  101ec2:	0f b6 c0             	movzbl %al,%eax
  101ec5:	50                   	push   %eax
  101ec6:	6a 21                	push   $0x21
  101ec8:	e8 56 17 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  101ecd:	83 c4 08             	add    $0x8,%esp
  101ed0:	89 f0                	mov    %esi,%eax
  101ed2:	0f b6 f4             	movzbl %ah,%esi
  101ed5:	56                   	push   %esi
  101ed6:	68 a1 00 00 00       	push   $0xa1
  101edb:	e8 43 17 00 00       	call   103623 <outb>
}
  101ee0:	83 c4 14             	add    $0x14,%esp
  101ee3:	5b                   	pop    %ebx
  101ee4:	5e                   	pop    %esi
  101ee5:	c3                   	ret

00101ee6 <pic_enable>:

void pic_enable(int irq)
{
  101ee6:	83 ec 18             	sub    $0x18,%esp
  101ee9:	e8 40 ef ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  101eee:	81 c2 06 d1 00 00    	add    $0xd106,%edx
    pic_setmask(irqmask & ~(1 << irq));
  101ef4:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  101ef8:	b8 01 00 00 00       	mov    $0x1,%eax
  101efd:	d3 e0                	shl    %cl,%eax
  101eff:	f7 d0                	not    %eax
  101f01:	66 23 82 12 03 00 00 	and    0x312(%edx),%ax
  101f08:	0f b7 c0             	movzwl %ax,%eax
  101f0b:	50                   	push   %eax
  101f0c:	e8 94 ff ff ff       	call   101ea5 <pic_setmask>
}
  101f11:	83 c4 1c             	add    $0x1c,%esp
  101f14:	c3                   	ret

00101f15 <pic_eoi>:

void pic_eoi(void)
{
  101f15:	53                   	push   %ebx
  101f16:	83 ec 10             	sub    $0x10,%esp
  101f19:	e8 1f e4 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101f1e:	81 c3 d6 d0 00 00    	add    $0xd0d6,%ebx
    // OCW2: rse00xxx
    //   r: rotate
    //   s: specific
    //   e: end-of-interrupt
    // xxx: specific interrupt line
    outb(IO_PIC1, 0x20);
  101f24:	6a 20                	push   $0x20
  101f26:	6a 20                	push   $0x20
  101f28:	e8 f6 16 00 00       	call   103623 <outb>
    outb(IO_PIC2, 0x20);
  101f2d:	83 c4 08             	add    $0x8,%esp
  101f30:	6a 20                	push   $0x20
  101f32:	68 a0 00 00 00       	push   $0xa0
  101f37:	e8 e7 16 00 00       	call   103623 <outb>
}
  101f3c:	83 c4 18             	add    $0x18,%esp
  101f3f:	5b                   	pop    %ebx
  101f40:	c3                   	ret

00101f41 <pic_reset>:

void pic_reset(void)
{
  101f41:	53                   	push   %ebx
  101f42:	83 ec 10             	sub    $0x10,%esp
  101f45:	e8 f3 e3 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  101f4a:	81 c3 aa d0 00 00    	add    $0xd0aa,%ebx
    // mask all interrupts
    outb(IO_PIC1 + 1, 0x00);
  101f50:	6a 00                	push   $0x0
  101f52:	6a 21                	push   $0x21
  101f54:	e8 ca 16 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, 0x00);
  101f59:	83 c4 08             	add    $0x8,%esp
  101f5c:	6a 00                	push   $0x0
  101f5e:	68 a1 00 00 00       	push   $0xa1
  101f63:	e8 bb 16 00 00       	call   103623 <outb>

    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);
  101f68:	83 c4 08             	add    $0x8,%esp
  101f6b:	6a 11                	push   $0x11
  101f6d:	6a 20                	push   $0x20
  101f6f:	e8 af 16 00 00       	call   103623 <outb>

    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, T_IRQ0);
  101f74:	83 c4 08             	add    $0x8,%esp
  101f77:	6a 20                	push   $0x20
  101f79:	6a 21                	push   $0x21
  101f7b:	e8 a3 16 00 00       	call   103623 <outb>

    // ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
    //        3-bit No of IR line at which slave connects to master(slave PIC).
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
  101f80:	83 c4 08             	add    $0x8,%esp
  101f83:	6a 04                	push   $0x4
  101f85:	6a 21                	push   $0x21
  101f87:	e8 97 16 00 00       	call   103623 <outb>
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //        can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x3);
  101f8c:	83 c4 08             	add    $0x8,%esp
  101f8f:	6a 03                	push   $0x3
  101f91:	6a 21                	push   $0x21
  101f93:	e8 8b 16 00 00       	call   103623 <outb>

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);            // ICW1
  101f98:	83 c4 08             	add    $0x8,%esp
  101f9b:	6a 11                	push   $0x11
  101f9d:	68 a0 00 00 00       	push   $0xa0
  101fa2:	e8 7c 16 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, T_IRQ0 + 8);  // ICW2
  101fa7:	83 c4 08             	add    $0x8,%esp
  101faa:	6a 28                	push   $0x28
  101fac:	68 a1 00 00 00       	push   $0xa1
  101fb1:	e8 6d 16 00 00       	call   103623 <outb>
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
  101fb6:	83 c4 08             	add    $0x8,%esp
  101fb9:	6a 02                	push   $0x2
  101fbb:	68 a1 00 00 00       	push   $0xa1
  101fc0:	e8 5e 16 00 00       	call   103623 <outb>
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x01);        // ICW4
  101fc5:	83 c4 08             	add    $0x8,%esp
  101fc8:	6a 01                	push   $0x1
  101fca:	68 a1 00 00 00       	push   $0xa1
  101fcf:	e8 4f 16 00 00       	call   103623 <outb>

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);  /* clear specific mask */
  101fd4:	83 c4 08             	add    $0x8,%esp
  101fd7:	6a 68                	push   $0x68
  101fd9:	6a 20                	push   $0x20
  101fdb:	e8 43 16 00 00       	call   103623 <outb>
    outb(IO_PIC1, 0x0a);  /* read IRR by default */
  101fe0:	83 c4 08             	add    $0x8,%esp
  101fe3:	6a 0a                	push   $0xa
  101fe5:	6a 20                	push   $0x20
  101fe7:	e8 37 16 00 00       	call   103623 <outb>

    outb(IO_PIC2, 0x68);  /* OCW3 */
  101fec:	83 c4 08             	add    $0x8,%esp
  101fef:	6a 68                	push   $0x68
  101ff1:	68 a0 00 00 00       	push   $0xa0
  101ff6:	e8 28 16 00 00       	call   103623 <outb>
    outb(IO_PIC2, 0x0a);  /* OCW3 */
  101ffb:	83 c4 08             	add    $0x8,%esp
  101ffe:	6a 0a                	push   $0xa
  102000:	68 a0 00 00 00       	push   $0xa0
  102005:	e8 19 16 00 00       	call   103623 <outb>
}
  10200a:	83 c4 18             	add    $0x18,%esp
  10200d:	5b                   	pop    %ebx
  10200e:	c3                   	ret

0010200f <timer_hw_init>:
#define TIMER_16BIT   0x30  /* r/w counter 16 bits, LSB first */

// Initialize the programmable interval timer.

void timer_hw_init(void)
{
  10200f:	53                   	push   %ebx
  102010:	83 ec 10             	sub    $0x10,%esp
  102013:	e8 25 e3 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  102018:	81 c3 dc cf 00 00    	add    $0xcfdc,%ebx
    outb(PIT_CONTROL, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  10201e:	6a 34                	push   $0x34
  102020:	6a 43                	push   $0x43
  102022:	e8 fc 15 00 00       	call   103623 <outb>
    outb(PIT_CHANNEL0, LOW8(LATCH));
  102027:	83 c4 08             	add    $0x8,%esp
  10202a:	68 9c 00 00 00       	push   $0x9c
  10202f:	6a 40                	push   $0x40
  102031:	e8 ed 15 00 00       	call   103623 <outb>
    outb(PIT_CHANNEL0, HIGH8(LATCH));
  102036:	83 c4 08             	add    $0x8,%esp
  102039:	6a 2e                	push   $0x2e
  10203b:	6a 40                	push   $0x40
  10203d:	e8 e1 15 00 00       	call   103623 <outb>
}
  102042:	83 c4 18             	add    $0x18,%esp
  102045:	5b                   	pop    %ebx
  102046:	c3                   	ret

00102047 <tsc_calibrate>:

/*
 * XXX: From Linux 3.2.6: arch/x86/kernel/tsc.c: pit_calibrate_tsc()
 */
static uint64_t tsc_calibrate(uint32_t latch, uint32_t ms, int loopmin)
{
  102047:	55                   	push   %ebp
  102048:	57                   	push   %edi
  102049:	56                   	push   %esi
  10204a:	53                   	push   %ebx
  10204b:	83 ec 48             	sub    $0x48,%esp
  10204e:	e8 f0 e4 ff ff       	call   100543 <__x86.get_pc_thunk.si>
  102053:	81 c6 a1 cf 00 00    	add    $0xcfa1,%esi
  102059:	89 c7                	mov    %eax,%edi
  10205b:	89 54 24 38          	mov    %edx,0x38(%esp)
  10205f:	89 4c 24 34          	mov    %ecx,0x34(%esp)
    uint64_t tsc, t1, t2, delta, tscmin, tscmax;;
    int pitcnt;

    /* Set the Gate high, disable speaker */
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  102063:	6a 61                	push   $0x61
  102065:	89 f3                	mov    %esi,%ebx
  102067:	e8 9f 15 00 00       	call   10360b <inb>
  10206c:	83 c4 08             	add    $0x8,%esp
  10206f:	83 e0 fc             	and    $0xfffffffc,%eax
  102072:	83 c8 01             	or     $0x1,%eax
  102075:	0f b6 c0             	movzbl %al,%eax
  102078:	50                   	push   %eax
  102079:	6a 61                	push   $0x61
  10207b:	e8 a3 15 00 00       	call   103623 <outb>
    /*
     * Setup CTC channel 2 for mode 0, (interrupt on terminal
     * count mode), binary count. Set the latch register to 50ms
     * (LSB then MSB) to begin countdown.
     */
    outb(0x43, 0xb0);
  102080:	83 c4 08             	add    $0x8,%esp
  102083:	68 b0 00 00 00       	push   $0xb0
  102088:	6a 43                	push   $0x43
  10208a:	e8 94 15 00 00       	call   103623 <outb>
    outb(0x42, latch & 0xff);
  10208f:	83 c4 08             	add    $0x8,%esp
  102092:	89 f8                	mov    %edi,%eax
  102094:	0f b6 c0             	movzbl %al,%eax
  102097:	50                   	push   %eax
  102098:	6a 42                	push   $0x42
  10209a:	e8 84 15 00 00       	call   103623 <outb>
    outb(0x42, latch >> 8);
  10209f:	83 c4 08             	add    $0x8,%esp
  1020a2:	89 f8                	mov    %edi,%eax
  1020a4:	0f b6 fc             	movzbl %ah,%edi
  1020a7:	57                   	push   %edi
  1020a8:	6a 42                	push   $0x42
  1020aa:	e8 74 15 00 00       	call   103623 <outb>

    tsc = t1 = t2 = rdtsc();
  1020af:	e8 c4 14 00 00       	call   103578 <rdtsc>
  1020b4:	89 44 24 30          	mov    %eax,0x30(%esp)
  1020b8:	89 54 24 34          	mov    %edx,0x34(%esp)

    pitcnt = 0;
    tscmax = 0;
    tscmin = ~(uint64_t) 0x0;
    while ((inb(0x61) & 0x20) == 0) {
  1020bc:	83 c4 10             	add    $0x10,%esp
    tsc = t1 = t2 = rdtsc();
  1020bf:	89 44 24 18          	mov    %eax,0x18(%esp)
  1020c3:	89 54 24 1c          	mov    %edx,0x1c(%esp)
    pitcnt = 0;
  1020c7:	bf 00 00 00 00       	mov    $0x0,%edi
    tscmax = 0;
  1020cc:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  1020d3:	00 
  1020d4:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  1020db:	00 
    tscmin = ~(uint64_t) 0x0;
  1020dc:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
  1020e3:	ff 
  1020e4:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  1020eb:	ff 
    while ((inb(0x61) & 0x20) == 0) {
  1020ec:	eb 0b                	jmp    1020f9 <tsc_calibrate+0xb2>
        tsc = t2;
        if (delta < tscmin)
            tscmin = delta;
        if (delta > tscmax)
            tscmax = delta;
        pitcnt++;
  1020ee:	83 c7 01             	add    $0x1,%edi
        tsc = t2;
  1020f1:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  1020f5:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
    while ((inb(0x61) & 0x20) == 0) {
  1020f9:	83 ec 0c             	sub    $0xc,%esp
  1020fc:	6a 61                	push   $0x61
  1020fe:	89 f3                	mov    %esi,%ebx
  102100:	e8 06 15 00 00       	call   10360b <inb>
  102105:	83 c4 10             	add    $0x10,%esp
  102108:	a8 20                	test   $0x20,%al
  10210a:	75 3f                	jne    10214b <tsc_calibrate+0x104>
        t2 = rdtsc();
  10210c:	89 f3                	mov    %esi,%ebx
  10210e:	e8 65 14 00 00       	call   103578 <rdtsc>
  102113:	89 c1                	mov    %eax,%ecx
  102115:	89 d3                	mov    %edx,%ebx
        delta = t2 - tsc;
  102117:	2b 44 24 18          	sub    0x18(%esp),%eax
  10211b:	1b 54 24 1c          	sbb    0x1c(%esp),%edx
        if (delta < tscmin)
  10211f:	8b 6c 24 08          	mov    0x8(%esp),%ebp
  102123:	39 e8                	cmp    %ebp,%eax
  102125:	89 d5                	mov    %edx,%ebp
  102127:	1b 6c 24 0c          	sbb    0xc(%esp),%ebp
  10212b:	73 08                	jae    102135 <tsc_calibrate+0xee>
            tscmin = delta;
  10212d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102131:	89 54 24 0c          	mov    %edx,0xc(%esp)
        if (delta > tscmax)
  102135:	39 44 24 10          	cmp    %eax,0x10(%esp)
  102139:	8b 6c 24 14          	mov    0x14(%esp),%ebp
  10213d:	19 d5                	sbb    %edx,%ebp
  10213f:	73 ad                	jae    1020ee <tsc_calibrate+0xa7>
            tscmax = delta;
  102141:	89 44 24 10          	mov    %eax,0x10(%esp)
  102145:	89 54 24 14          	mov    %edx,0x14(%esp)
  102149:	eb a3                	jmp    1020ee <tsc_calibrate+0xa7>
     * times, then we have been hit by a massive SMI
     *
     * If the maximum is 10 times larger than the minimum,
     * then we got hit by an SMI as well.
     */
    KERN_DEBUG("pitcnt=%u, tscmin=%llu, tscmax=%llu\n",
  10214b:	ff 74 24 14          	push   0x14(%esp)
  10214f:	ff 74 24 14          	push   0x14(%esp)
  102153:	ff 74 24 14          	push   0x14(%esp)
  102157:	ff 74 24 14          	push   0x14(%esp)
  10215b:	57                   	push   %edi
  10215c:	8d 86 b0 99 ff ff    	lea    -0x6650(%esi),%eax
  102162:	50                   	push   %eax
  102163:	6a 39                	push   $0x39
  102165:	8d 86 fc 90 ff ff    	lea    -0x6f04(%esi),%eax
  10216b:	50                   	push   %eax
  10216c:	e8 65 08 00 00       	call   1029d6 <debug_normal>
               pitcnt, tscmin, tscmax);
    if (pitcnt < loopmin || tscmax > 10 * tscmin)
  102171:	83 c4 20             	add    $0x20,%esp
  102174:	8b 44 24 28          	mov    0x28(%esp),%eax
  102178:	39 c7                	cmp    %eax,%edi
  10217a:	7c 5c                	jl     1021d8 <tsc_calibrate+0x191>
  10217c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102180:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  102184:	89 f8                	mov    %edi,%eax
  102186:	89 ea                	mov    %ebp,%edx
  102188:	0f a4 c2 02          	shld   $0x2,%eax,%edx
  10218c:	c1 e0 02             	shl    $0x2,%eax
  10218f:	01 f8                	add    %edi,%eax
  102191:	11 ea                	adc    %ebp,%edx
  102193:	01 c0                	add    %eax,%eax
  102195:	11 d2                	adc    %edx,%edx
  102197:	89 c1                	mov    %eax,%ecx
  102199:	89 d0                	mov    %edx,%eax
  10219b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  10219f:	8b 6c 24 14          	mov    0x14(%esp),%ebp
  1021a3:	39 f9                	cmp    %edi,%ecx
  1021a5:	19 e8                	sbb    %ebp,%eax
  1021a7:	72 38                	jb     1021e1 <tsc_calibrate+0x19a>
        return ~(uint64_t) 0x0;

    /* Calculate the PIT value */
    delta = t2 - t1;
  1021a9:	8b 44 24 18          	mov    0x18(%esp),%eax
  1021ad:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  1021b1:	2b 44 24 20          	sub    0x20(%esp),%eax
  1021b5:	1b 54 24 24          	sbb    0x24(%esp),%edx
    return delta / ms;
  1021b9:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  1021bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  1021c2:	53                   	push   %ebx
  1021c3:	51                   	push   %ecx
  1021c4:	52                   	push   %edx
  1021c5:	50                   	push   %eax
  1021c6:	89 f3                	mov    %esi,%ebx
  1021c8:	e8 93 54 00 00       	call   107660 <__udivdi3>
  1021cd:	83 c4 10             	add    $0x10,%esp
}
  1021d0:	83 c4 3c             	add    $0x3c,%esp
  1021d3:	5b                   	pop    %ebx
  1021d4:	5e                   	pop    %esi
  1021d5:	5f                   	pop    %edi
  1021d6:	5d                   	pop    %ebp
  1021d7:	c3                   	ret
        return ~(uint64_t) 0x0;
  1021d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1021dd:	89 c2                	mov    %eax,%edx
  1021df:	eb ef                	jmp    1021d0 <tsc_calibrate+0x189>
  1021e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1021e6:	89 c2                	mov    %eax,%edx
  1021e8:	eb e6                	jmp    1021d0 <tsc_calibrate+0x189>

001021ea <tsc_init>:

int tsc_init(void)
{
  1021ea:	55                   	push   %ebp
  1021eb:	57                   	push   %edi
  1021ec:	56                   	push   %esi
  1021ed:	53                   	push   %ebx
  1021ee:	83 ec 1c             	sub    $0x1c,%esp
  1021f1:	e8 47 e1 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1021f6:	81 c3 fe cd 00 00    	add    $0xcdfe,%ebx
    uint64_t ret;
    int i;

    timer_hw_init();
  1021fc:	e8 0e fe ff ff       	call   10200f <timer_hw_init>

    tsc_per_ms = 0;
  102201:	c7 83 b4 a8 02 00 00 	movl   $0x0,0x2a8b4(%ebx)
  102208:	00 00 00 
  10220b:	c7 83 b8 a8 02 00 00 	movl   $0x0,0x2a8b8(%ebx)
  102212:	00 00 00 

    if (detect_kvm())
  102215:	e8 f1 03 00 00       	call   10260b <detect_kvm>
  10221a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10221e:	85 c0                	test   %eax,%eax
  102220:	75 4e                	jne    102270 <tsc_init+0x86>

    /*
     * XXX: If TSC calibration fails frequently, try to increase the
     *      upper bound of loop condition, e.g. alternating 3 to 10.
     */
    for (i = 0; i < 10; i++) {
  102222:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  102226:	83 fd 09             	cmp    $0x9,%ebp
  102229:	0f 8f ba 00 00 00    	jg     1022e9 <tsc_init+0xff>
        ret = tsc_calibrate(CAL_LATCH, CAL_MS, CAL_PIT_LOOPS);
  10222f:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  102234:	ba 0a 00 00 00       	mov    $0xa,%edx
  102239:	b8 9b 2e 00 00       	mov    $0x2e9b,%eax
  10223e:	e8 04 fe ff ff       	call   102047 <tsc_calibrate>
  102243:	89 c6                	mov    %eax,%esi
  102245:	89 d7                	mov    %edx,%edi
        if (ret != ~(uint64_t) 0x0)
  102247:	21 d0                	and    %edx,%eax
  102249:	83 f8 ff             	cmp    $0xffffffff,%eax
  10224c:	0f 85 97 00 00 00    	jne    1022e9 <tsc_init+0xff>
            break;
        KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i + 1);
  102252:	83 c5 01             	add    $0x1,%ebp
  102255:	55                   	push   %ebp
  102256:	8d 83 0b 91 ff ff    	lea    -0x6ef5(%ebx),%eax
  10225c:	50                   	push   %eax
  10225d:	6a 5c                	push   $0x5c
  10225f:	8d 83 fc 90 ff ff    	lea    -0x6f04(%ebx),%eax
  102265:	50                   	push   %eax
  102266:	e8 6b 07 00 00       	call   1029d6 <debug_normal>
  10226b:	83 c4 10             	add    $0x10,%esp
  10226e:	eb b6                	jmp    102226 <tsc_init+0x3c>
		tsc_per_ms = kvm_get_tsc_hz() / 1000llu;
  102270:	e8 b3 04 00 00       	call   102728 <kvm_get_tsc_hz>
  102275:	6a 00                	push   $0x0
  102277:	68 e8 03 00 00       	push   $0x3e8
  10227c:	52                   	push   %edx
  10227d:	50                   	push   %eax
  10227e:	e8 dd 53 00 00       	call   107660 <__udivdi3>
  102283:	89 83 b4 a8 02 00    	mov    %eax,0x2a8b4(%ebx)
  102289:	89 93 b8 a8 02 00    	mov    %edx,0x2a8b8(%ebx)
		KERN_INFO ("TSC read from KVM: %u.%03u MHz.\n",
  10228f:	8b 83 b4 a8 02 00    	mov    0x2a8b4(%ebx),%eax
  102295:	8b 93 b8 a8 02 00    	mov    0x2a8b8(%ebx),%edx
  10229b:	8b b3 b4 a8 02 00    	mov    0x2a8b4(%ebx),%esi
  1022a1:	8b bb b8 a8 02 00    	mov    0x2a8b8(%ebx),%edi
  1022a7:	6a 00                	push   $0x0
  1022a9:	68 e8 03 00 00       	push   $0x3e8
  1022ae:	52                   	push   %edx
  1022af:	50                   	push   %eax
  1022b0:	e8 cb 54 00 00       	call   107780 <__umoddi3>
  1022b5:	83 c4 14             	add    $0x14,%esp
  1022b8:	52                   	push   %edx
  1022b9:	50                   	push   %eax
  1022ba:	83 ec 0c             	sub    $0xc,%esp
  1022bd:	6a 00                	push   $0x0
  1022bf:	68 e8 03 00 00       	push   $0x3e8
  1022c4:	57                   	push   %edi
  1022c5:	56                   	push   %esi
  1022c6:	e8 95 53 00 00       	call   107660 <__udivdi3>
  1022cb:	83 c4 1c             	add    $0x1c,%esp
  1022ce:	52                   	push   %edx
  1022cf:	50                   	push   %eax
  1022d0:	8d 83 d8 99 ff ff    	lea    -0x6628(%ebx),%eax
  1022d6:	50                   	push   %eax
  1022d7:	e8 d5 06 00 00       	call   1029b1 <debug_info>
		return (0);
  1022dc:	83 c4 20             	add    $0x20,%esp
  1022df:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1022e6:	00 
  1022e7:	eb 76                	jmp    10235f <tsc_init+0x175>
    }

    if (ret == ~(uint64_t) 0x0) {
  1022e9:	89 f0                	mov    %esi,%eax
  1022eb:	21 f8                	and    %edi,%eax
  1022ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  1022f0:	74 79                	je     10236b <tsc_init+0x181>
        tsc_per_ms = 1000000;

        timer_hw_init();
        return 1;
    } else {
        tsc_per_ms = ret;
  1022f2:	89 b3 b4 a8 02 00    	mov    %esi,0x2a8b4(%ebx)
  1022f8:	89 bb b8 a8 02 00    	mov    %edi,0x2a8b8(%ebx)
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  1022fe:	8b 83 b4 a8 02 00    	mov    0x2a8b4(%ebx),%eax
  102304:	8b 93 b8 a8 02 00    	mov    0x2a8b8(%ebx),%edx
  10230a:	8b b3 b4 a8 02 00    	mov    0x2a8b4(%ebx),%esi
  102310:	8b bb b8 a8 02 00    	mov    0x2a8b8(%ebx),%edi
  102316:	83 ec 10             	sub    $0x10,%esp
  102319:	6a 00                	push   $0x0
  10231b:	68 e8 03 00 00       	push   $0x3e8
  102320:	52                   	push   %edx
  102321:	50                   	push   %eax
  102322:	e8 59 54 00 00       	call   107780 <__umoddi3>
  102327:	83 c4 1c             	add    $0x1c,%esp
  10232a:	52                   	push   %edx
  10232b:	50                   	push   %eax
  10232c:	83 ec 04             	sub    $0x4,%esp
  10232f:	6a 00                	push   $0x0
  102331:	68 e8 03 00 00       	push   $0x3e8
  102336:	57                   	push   %edi
  102337:	56                   	push   %esi
  102338:	e8 23 53 00 00       	call   107660 <__udivdi3>
  10233d:	83 c4 14             	add    $0x14,%esp
  102340:	52                   	push   %edx
  102341:	50                   	push   %eax
  102342:	8d 83 5c 91 ff ff    	lea    -0x6ea4(%ebx),%eax
  102348:	50                   	push   %eax
  102349:	6a 68                	push   $0x68
  10234b:	8d 83 fc 90 ff ff    	lea    -0x6f04(%ebx),%eax
  102351:	50                   	push   %eax
  102352:	e8 7f 06 00 00       	call   1029d6 <debug_normal>

        timer_hw_init();
  102357:	83 c4 20             	add    $0x20,%esp
  10235a:	e8 b0 fc ff ff       	call   10200f <timer_hw_init>
        return 0;
    }
}
  10235f:	8b 44 24 0c          	mov    0xc(%esp),%eax
  102363:	83 c4 1c             	add    $0x1c,%esp
  102366:	5b                   	pop    %ebx
  102367:	5e                   	pop    %esi
  102368:	5f                   	pop    %edi
  102369:	5d                   	pop    %ebp
  10236a:	c3                   	ret
        KERN_DEBUG("TSC calibration failed.\n");
  10236b:	83 ec 04             	sub    $0x4,%esp
  10236e:	8d 83 29 91 ff ff    	lea    -0x6ed7(%ebx),%eax
  102374:	50                   	push   %eax
  102375:	6a 60                	push   $0x60
  102377:	8d b3 fc 90 ff ff    	lea    -0x6f04(%ebx),%esi
  10237d:	56                   	push   %esi
  10237e:	e8 53 06 00 00       	call   1029d6 <debug_normal>
        KERN_DEBUG("Assume TSC freq = 1 GHz.\n");
  102383:	83 c4 0c             	add    $0xc,%esp
  102386:	8d 83 42 91 ff ff    	lea    -0x6ebe(%ebx),%eax
  10238c:	50                   	push   %eax
  10238d:	6a 61                	push   $0x61
  10238f:	56                   	push   %esi
  102390:	e8 41 06 00 00       	call   1029d6 <debug_normal>
        tsc_per_ms = 1000000;
  102395:	c7 83 b4 a8 02 00 40 	movl   $0xf4240,0x2a8b4(%ebx)
  10239c:	42 0f 00 
  10239f:	c7 83 b8 a8 02 00 00 	movl   $0x0,0x2a8b8(%ebx)
  1023a6:	00 00 00 
        timer_hw_init();
  1023a9:	e8 61 fc ff ff       	call   10200f <timer_hw_init>
        return 1;
  1023ae:	83 c4 10             	add    $0x10,%esp
  1023b1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  1023b8:	00 
  1023b9:	eb a4                	jmp    10235f <tsc_init+0x175>

001023bb <delay>:

/*
 * Wait for ms millisecond.
 */
void delay(uint32_t ms)
{
  1023bb:	55                   	push   %ebp
  1023bc:	57                   	push   %edi
  1023bd:	56                   	push   %esi
  1023be:	53                   	push   %ebx
  1023bf:	83 ec 1c             	sub    $0x1c,%esp
  1023c2:	e8 e7 00 00 00       	call   1024ae <__x86.get_pc_thunk.bp>
  1023c7:	81 c5 2d cc 00 00    	add    $0xcc2d,%ebp
  1023cd:	8b 44 24 30          	mov    0x30(%esp),%eax
    volatile uint64_t ticks = tsc_per_ms * ms;
  1023d1:	8b b5 b4 a8 02 00    	mov    0x2a8b4(%ebp),%esi
  1023d7:	8b bd b8 a8 02 00    	mov    0x2a8b8(%ebp),%edi
  1023dd:	89 fb                	mov    %edi,%ebx
  1023df:	0f af d8             	imul   %eax,%ebx
  1023e2:	f7 e6                	mul    %esi
  1023e4:	01 da                	add    %ebx,%edx
  1023e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1023ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
    volatile uint64_t start = rdtsc();
  1023ee:	89 eb                	mov    %ebp,%ebx
  1023f0:	e8 83 11 00 00       	call   103578 <rdtsc>
  1023f5:	89 04 24             	mov    %eax,(%esp)
  1023f8:	89 54 24 04          	mov    %edx,0x4(%esp)
    while (rdtsc() < start + ticks);
  1023fc:	89 eb                	mov    %ebp,%ebx
  1023fe:	e8 75 11 00 00       	call   103578 <rdtsc>
  102403:	89 c3                	mov    %eax,%ebx
  102405:	89 d1                	mov    %edx,%ecx
  102407:	8b 04 24             	mov    (%esp),%eax
  10240a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10240e:	8b 74 24 08          	mov    0x8(%esp),%esi
  102412:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  102416:	01 f0                	add    %esi,%eax
  102418:	11 fa                	adc    %edi,%edx
  10241a:	39 c3                	cmp    %eax,%ebx
  10241c:	19 d1                	sbb    %edx,%ecx
  10241e:	72 dc                	jb     1023fc <delay+0x41>
}
  102420:	83 c4 1c             	add    $0x1c,%esp
  102423:	5b                   	pop    %ebx
  102424:	5e                   	pop    %esi
  102425:	5f                   	pop    %edi
  102426:	5d                   	pop    %ebp
  102427:	c3                   	ret

00102428 <udelay>:

/*
 * Wait for us microsecond.
 */
void udelay(uint32_t us)
{
  102428:	55                   	push   %ebp
  102429:	57                   	push   %edi
  10242a:	56                   	push   %esi
  10242b:	53                   	push   %ebx
  10242c:	83 ec 1c             	sub    $0x1c,%esp
  10242f:	e8 7a 00 00 00       	call   1024ae <__x86.get_pc_thunk.bp>
  102434:	81 c5 c0 cb 00 00    	add    $0xcbc0,%ebp
  10243a:	8b 74 24 30          	mov    0x30(%esp),%esi
    volatile uint64_t ticks = tsc_per_ms / 1000 * us;
  10243e:	8b 85 b4 a8 02 00    	mov    0x2a8b4(%ebp),%eax
  102444:	8b 95 b8 a8 02 00    	mov    0x2a8b8(%ebp),%edx
  10244a:	6a 00                	push   $0x0
  10244c:	68 e8 03 00 00       	push   $0x3e8
  102451:	52                   	push   %edx
  102452:	50                   	push   %eax
  102453:	89 eb                	mov    %ebp,%ebx
  102455:	e8 06 52 00 00       	call   107660 <__udivdi3>
  10245a:	83 c4 10             	add    $0x10,%esp
  10245d:	89 d3                	mov    %edx,%ebx
  10245f:	89 c2                	mov    %eax,%edx
  102461:	89 d9                	mov    %ebx,%ecx
  102463:	0f af ce             	imul   %esi,%ecx
  102466:	89 f0                	mov    %esi,%eax
  102468:	f7 e2                	mul    %edx
  10246a:	01 ca                	add    %ecx,%edx
  10246c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102470:	89 54 24 0c          	mov    %edx,0xc(%esp)
    volatile uint64_t start = rdtsc();
  102474:	89 eb                	mov    %ebp,%ebx
  102476:	e8 fd 10 00 00       	call   103578 <rdtsc>
  10247b:	89 04 24             	mov    %eax,(%esp)
  10247e:	89 54 24 04          	mov    %edx,0x4(%esp)
    while (rdtsc() < start + ticks);
  102482:	89 eb                	mov    %ebp,%ebx
  102484:	e8 ef 10 00 00       	call   103578 <rdtsc>
  102489:	89 c3                	mov    %eax,%ebx
  10248b:	89 d1                	mov    %edx,%ecx
  10248d:	8b 04 24             	mov    (%esp),%eax
  102490:	8b 54 24 04          	mov    0x4(%esp),%edx
  102494:	8b 74 24 08          	mov    0x8(%esp),%esi
  102498:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  10249c:	01 f0                	add    %esi,%eax
  10249e:	11 fa                	adc    %edi,%edx
  1024a0:	39 c3                	cmp    %eax,%ebx
  1024a2:	19 d1                	sbb    %edx,%ecx
  1024a4:	72 dc                	jb     102482 <udelay+0x5a>
}
  1024a6:	83 c4 1c             	add    $0x1c,%esp
  1024a9:	5b                   	pop    %ebx
  1024aa:	5e                   	pop    %esi
  1024ab:	5f                   	pop    %edi
  1024ac:	5d                   	pop    %ebp
  1024ad:	c3                   	ret

001024ae <__x86.get_pc_thunk.bp>:
  1024ae:	8b 2c 24             	mov    (%esp),%ebp
  1024b1:	c3                   	ret
  1024b2:	66 90                	xchg   %ax,%ax
  1024b4:	66 90                	xchg   %ax,%ax
  1024b6:	66 90                	xchg   %ax,%ax
  1024b8:	66 90                	xchg   %ax,%ax
  1024ba:	66 90                	xchg   %ax,%ax
  1024bc:	66 90                	xchg   %ax,%ax
  1024be:	66 90                	xchg   %ax,%ax

001024c0 <Xdivide>:
	jmp	_alltraps

.text

/* exceptions  */
TRAPHANDLER_NOEC(Xdivide,	T_DIVIDE)
  1024c0:	6a 00                	push   $0x0
  1024c2:	6a 00                	push   $0x0
  1024c4:	e9 17 01 00 00       	jmp    1025e0 <_alltraps>
  1024c9:	90                   	nop

001024ca <Xdebug>:
TRAPHANDLER_NOEC(Xdebug,	T_DEBUG)
  1024ca:	6a 00                	push   $0x0
  1024cc:	6a 01                	push   $0x1
  1024ce:	e9 0d 01 00 00       	jmp    1025e0 <_alltraps>
  1024d3:	90                   	nop

001024d4 <Xnmi>:
TRAPHANDLER_NOEC(Xnmi,		T_NMI)
  1024d4:	6a 00                	push   $0x0
  1024d6:	6a 02                	push   $0x2
  1024d8:	e9 03 01 00 00       	jmp    1025e0 <_alltraps>
  1024dd:	90                   	nop

001024de <Xbrkpt>:
TRAPHANDLER_NOEC(Xbrkpt,	T_BRKPT)
  1024de:	6a 00                	push   $0x0
  1024e0:	6a 03                	push   $0x3
  1024e2:	e9 f9 00 00 00       	jmp    1025e0 <_alltraps>
  1024e7:	90                   	nop

001024e8 <Xoflow>:
TRAPHANDLER_NOEC(Xoflow,	T_OFLOW)
  1024e8:	6a 00                	push   $0x0
  1024ea:	6a 04                	push   $0x4
  1024ec:	e9 ef 00 00 00       	jmp    1025e0 <_alltraps>
  1024f1:	90                   	nop

001024f2 <Xbound>:
TRAPHANDLER_NOEC(Xbound,	T_BOUND)
  1024f2:	6a 00                	push   $0x0
  1024f4:	6a 05                	push   $0x5
  1024f6:	e9 e5 00 00 00       	jmp    1025e0 <_alltraps>
  1024fb:	90                   	nop

001024fc <Xillop>:
TRAPHANDLER_NOEC(Xillop,	T_ILLOP)
  1024fc:	6a 00                	push   $0x0
  1024fe:	6a 06                	push   $0x6
  102500:	e9 db 00 00 00       	jmp    1025e0 <_alltraps>
  102505:	90                   	nop

00102506 <Xdevice>:
TRAPHANDLER_NOEC(Xdevice,	T_DEVICE)
  102506:	6a 00                	push   $0x0
  102508:	6a 07                	push   $0x7
  10250a:	e9 d1 00 00 00       	jmp    1025e0 <_alltraps>
  10250f:	90                   	nop

00102510 <Xdblflt>:
TRAPHANDLER     (Xdblflt,	T_DBLFLT)
  102510:	6a 08                	push   $0x8
  102512:	e9 c9 00 00 00       	jmp    1025e0 <_alltraps>
  102517:	90                   	nop

00102518 <Xcoproc>:
TRAPHANDLER_NOEC(Xcoproc,	T_COPROC)
  102518:	6a 00                	push   $0x0
  10251a:	6a 09                	push   $0x9
  10251c:	e9 bf 00 00 00       	jmp    1025e0 <_alltraps>
  102521:	90                   	nop

00102522 <Xtss>:
TRAPHANDLER     (Xtss,		T_TSS)
  102522:	6a 0a                	push   $0xa
  102524:	e9 b7 00 00 00       	jmp    1025e0 <_alltraps>
  102529:	90                   	nop

0010252a <Xsegnp>:
TRAPHANDLER     (Xsegnp,	T_SEGNP)
  10252a:	6a 0b                	push   $0xb
  10252c:	e9 af 00 00 00       	jmp    1025e0 <_alltraps>
  102531:	90                   	nop

00102532 <Xstack>:
TRAPHANDLER     (Xstack,	T_STACK)
  102532:	6a 0c                	push   $0xc
  102534:	e9 a7 00 00 00       	jmp    1025e0 <_alltraps>
  102539:	90                   	nop

0010253a <Xgpflt>:
TRAPHANDLER     (Xgpflt,	T_GPFLT)
  10253a:	6a 0d                	push   $0xd
  10253c:	e9 9f 00 00 00       	jmp    1025e0 <_alltraps>
  102541:	90                   	nop

00102542 <Xpgflt>:
TRAPHANDLER     (Xpgflt,	T_PGFLT)
  102542:	6a 0e                	push   $0xe
  102544:	e9 97 00 00 00       	jmp    1025e0 <_alltraps>
  102549:	90                   	nop

0010254a <Xres>:
TRAPHANDLER_NOEC(Xres,		T_RES)
  10254a:	6a 00                	push   $0x0
  10254c:	6a 0f                	push   $0xf
  10254e:	e9 8d 00 00 00       	jmp    1025e0 <_alltraps>
  102553:	90                   	nop

00102554 <Xfperr>:
TRAPHANDLER_NOEC(Xfperr,	T_FPERR)
  102554:	6a 00                	push   $0x0
  102556:	6a 10                	push   $0x10
  102558:	e9 83 00 00 00       	jmp    1025e0 <_alltraps>
  10255d:	90                   	nop

0010255e <Xalign>:
TRAPHANDLER     (Xalign,	T_ALIGN)
  10255e:	6a 11                	push   $0x11
  102560:	eb 7e                	jmp    1025e0 <_alltraps>

00102562 <Xmchk>:
TRAPHANDLER_NOEC(Xmchk,		T_MCHK)
  102562:	6a 00                	push   $0x0
  102564:	6a 12                	push   $0x12
  102566:	eb 78                	jmp    1025e0 <_alltraps>

00102568 <Xirq_timer>:

/* ISA interrupts  */
TRAPHANDLER_NOEC(Xirq_timer,	T_IRQ0 + IRQ_TIMER)
  102568:	6a 00                	push   $0x0
  10256a:	6a 20                	push   $0x20
  10256c:	eb 72                	jmp    1025e0 <_alltraps>

0010256e <Xirq_kbd>:
TRAPHANDLER_NOEC(Xirq_kbd,	T_IRQ0 + IRQ_KBD)
  10256e:	6a 00                	push   $0x0
  102570:	6a 21                	push   $0x21
  102572:	eb 6c                	jmp    1025e0 <_alltraps>

00102574 <Xirq_slave>:
TRAPHANDLER_NOEC(Xirq_slave,	T_IRQ0 + IRQ_SLAVE)
  102574:	6a 00                	push   $0x0
  102576:	6a 22                	push   $0x22
  102578:	eb 66                	jmp    1025e0 <_alltraps>

0010257a <Xirq_serial2>:
TRAPHANDLER_NOEC(Xirq_serial2,	T_IRQ0 + IRQ_SERIAL24)
  10257a:	6a 00                	push   $0x0
  10257c:	6a 23                	push   $0x23
  10257e:	eb 60                	jmp    1025e0 <_alltraps>

00102580 <Xirq_serial1>:
TRAPHANDLER_NOEC(Xirq_serial1,	T_IRQ0 + IRQ_SERIAL13)
  102580:	6a 00                	push   $0x0
  102582:	6a 24                	push   $0x24
  102584:	eb 5a                	jmp    1025e0 <_alltraps>

00102586 <Xirq_lpt>:
TRAPHANDLER_NOEC(Xirq_lpt,	T_IRQ0 + IRQ_LPT2)
  102586:	6a 00                	push   $0x0
  102588:	6a 25                	push   $0x25
  10258a:	eb 54                	jmp    1025e0 <_alltraps>

0010258c <Xirq_floppy>:
TRAPHANDLER_NOEC(Xirq_floppy,	T_IRQ0 + IRQ_FLOPPY)
  10258c:	6a 00                	push   $0x0
  10258e:	6a 26                	push   $0x26
  102590:	eb 4e                	jmp    1025e0 <_alltraps>

00102592 <Xirq_spurious>:
TRAPHANDLER_NOEC(Xirq_spurious,	T_IRQ0 + IRQ_SPURIOUS)
  102592:	6a 00                	push   $0x0
  102594:	6a 27                	push   $0x27
  102596:	eb 48                	jmp    1025e0 <_alltraps>

00102598 <Xirq_rtc>:
TRAPHANDLER_NOEC(Xirq_rtc,	T_IRQ0 + IRQ_RTC)
  102598:	6a 00                	push   $0x0
  10259a:	6a 28                	push   $0x28
  10259c:	eb 42                	jmp    1025e0 <_alltraps>

0010259e <Xirq9>:
TRAPHANDLER_NOEC(Xirq9,		T_IRQ0 + 9)
  10259e:	6a 00                	push   $0x0
  1025a0:	6a 29                	push   $0x29
  1025a2:	eb 3c                	jmp    1025e0 <_alltraps>

001025a4 <Xirq10>:
TRAPHANDLER_NOEC(Xirq10,	T_IRQ0 + 10)
  1025a4:	6a 00                	push   $0x0
  1025a6:	6a 2a                	push   $0x2a
  1025a8:	eb 36                	jmp    1025e0 <_alltraps>

001025aa <Xirq11>:
TRAPHANDLER_NOEC(Xirq11,	T_IRQ0 + 11)
  1025aa:	6a 00                	push   $0x0
  1025ac:	6a 2b                	push   $0x2b
  1025ae:	eb 30                	jmp    1025e0 <_alltraps>

001025b0 <Xirq_mouse>:
TRAPHANDLER_NOEC(Xirq_mouse,	T_IRQ0 + IRQ_MOUSE)
  1025b0:	6a 00                	push   $0x0
  1025b2:	6a 2c                	push   $0x2c
  1025b4:	eb 2a                	jmp    1025e0 <_alltraps>

001025b6 <Xirq_coproc>:
TRAPHANDLER_NOEC(Xirq_coproc,	T_IRQ0 + IRQ_COPROCESSOR)
  1025b6:	6a 00                	push   $0x0
  1025b8:	6a 2d                	push   $0x2d
  1025ba:	eb 24                	jmp    1025e0 <_alltraps>

001025bc <Xirq_ide1>:
TRAPHANDLER_NOEC(Xirq_ide1,	T_IRQ0 + IRQ_IDE1)
  1025bc:	6a 00                	push   $0x0
  1025be:	6a 2e                	push   $0x2e
  1025c0:	eb 1e                	jmp    1025e0 <_alltraps>

001025c2 <Xirq_ide2>:
TRAPHANDLER_NOEC(Xirq_ide2,	T_IRQ0 + IRQ_IDE2)
  1025c2:	6a 00                	push   $0x0
  1025c4:	6a 2f                	push   $0x2f
  1025c6:	eb 18                	jmp    1025e0 <_alltraps>

001025c8 <Xsyscall>:

/* syscall */
TRAPHANDLER_NOEC(Xsyscall,	T_SYSCALL)
  1025c8:	6a 00                	push   $0x0
  1025ca:	6a 30                	push   $0x30
  1025cc:	eb 12                	jmp    1025e0 <_alltraps>

001025ce <Xdefault>:

/* default ? */
TRAPHANDLER     (Xdefault,	T_DEFAULT)
  1025ce:	68 fe 00 00 00       	push   $0xfe
  1025d3:	eb 0b                	jmp    1025e0 <_alltraps>
  1025d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1025dc:	00 
  1025dd:	8d 76 00             	lea    0x0(%esi),%esi

001025e0 <_alltraps>:

	.globl _alltraps
	.type _alltraps, @function
	.p2align 4, 0x90	/* 16-byte alignment, nop filled */
_alltraps:
	cli			# make sure there is no nested trap
  1025e0:	fa                   	cli
	cld
  1025e1:	fc                   	cld

	pushl	%ds		# build context
  1025e2:	1e                   	push   %ds
	pushl	%es
  1025e3:	06                   	push   %es
	pushal
  1025e4:	60                   	pusha

	movl	$CPU_GDT_KDATA, %eax	# load kernel's data segment
  1025e5:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax, %ds
  1025ea:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
  1025ec:	8e c0                	mov    %eax,%es

	pushl	%esp		# pass pointer to this trapframe
  1025ee:	54                   	push   %esp

	call	trap		# and call trap (does not return)
  1025ef:	e8 5c 4f 00 00       	call   107550 <trap>

1:	hlt			# should never get here; just spin...
  1025f4:	f4                   	hlt
  1025f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1025fc:	00 
  1025fd:	8d 76 00             	lea    0x0(%esi),%esi

00102600 <trap_return>:
//
	.globl trap_return
	.type trap_return, @function
	.p2align 4, 0x90	/* 16-byte alignment, nop filled */
trap_return:
	movl	4(%esp), %esp	// reset stack pointer to point to trap frame
  102600:	8b 64 24 04          	mov    0x4(%esp),%esp
	popal			// restore general-purpose registers except esp
  102604:	61                   	popa
	popl	%es		// restore data segment registers
  102605:	07                   	pop    %es
	popl	%ds
  102606:	1f                   	pop    %ds
	addl	$8, %esp	// skip tf_trapno and tf_errcode
  102607:	83 c4 08             	add    $0x8,%esp
	iret			// return from trap handler
  10260a:	cf                   	iret

0010260b <detect_kvm>:
}

#define CPUID_FEATURE_HYPERVISOR	(1<<31) /* Running on a hypervisor */

int detect_kvm(void)
{
  10260b:	57                   	push   %edi
  10260c:	56                   	push   %esi
  10260d:	53                   	push   %ebx
  10260e:	83 ec 10             	sub    $0x10,%esp
  102611:	e8 2d df ff ff       	call   100543 <__x86.get_pc_thunk.si>
  102616:	81 c6 de c9 00 00    	add    $0xc9de,%esi
	__asm __volatile("cpuid"
  10261c:	b8 01 00 00 00       	mov    $0x1,%eax
  102621:	b9 00 00 00 00       	mov    $0x0,%ecx
  102626:	0f a2                	cpuid
	uint32_t eax;

	if (cpu_has (CPUID_FEATURE_HYPERVISOR))
  102628:	f6 c2 01             	test   $0x1,%dl
  10262b:	75 0c                	jne    102639 <detect_kvm+0x2e>
		if (!strncmp ("KVMKVMKVM", (const char *) hyper_vendor_id, 9))
		{
			return 1;
		}
	}
	return 0;
  10262d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102632:	83 c4 10             	add    $0x10,%esp
  102635:	5b                   	pop    %ebx
  102636:	5e                   	pop    %esi
  102637:	5f                   	pop    %edi
  102638:	c3                   	ret
		cpuid (CPUID_KVM_SIGNATURE, &eax, &hyper_vendor_id[0],
  102639:	83 ec 0c             	sub    $0xc,%esp
  10263c:	8d 7c 24 0c          	lea    0xc(%esp),%edi
  102640:	8d 44 24 14          	lea    0x14(%esp),%eax
  102644:	50                   	push   %eax
  102645:	8d 44 24 14          	lea    0x14(%esp),%eax
  102649:	50                   	push   %eax
  10264a:	57                   	push   %edi
  10264b:	8d 44 24 24          	lea    0x24(%esp),%eax
  10264f:	50                   	push   %eax
  102650:	68 00 00 00 40       	push   $0x40000000
  102655:	89 f3                	mov    %esi,%ebx
  102657:	e8 32 0f 00 00       	call   10358e <cpuid>
		if (!strncmp ("KVMKVMKVM", (const char *) hyper_vendor_id, 9))
  10265c:	83 c4 1c             	add    $0x1c,%esp
  10265f:	6a 09                	push   $0x9
  102661:	57                   	push   %edi
  102662:	8d 86 75 91 ff ff    	lea    -0x6e8b(%esi),%eax
  102668:	50                   	push   %eax
  102669:	e8 1d 02 00 00       	call   10288b <strncmp>
  10266e:	89 fc                	mov    %edi,%esp
  102670:	85 c0                	test   %eax,%eax
  102672:	74 07                	je     10267b <detect_kvm+0x70>
	return 0;
  102674:	b8 00 00 00 00       	mov    $0x0,%eax
  102679:	eb b7                	jmp    102632 <detect_kvm+0x27>
			return 1;
  10267b:	b8 01 00 00 00       	mov    $0x1,%eax
  102680:	eb b0                	jmp    102632 <detect_kvm+0x27>

00102682 <kvm_has_feature>:

int
kvm_has_feature(uint32_t feature)
{
  102682:	53                   	push   %ebx
  102683:	83 ec 24             	sub    $0x24,%esp
  102686:	e8 b2 dc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10268b:	81 c3 69 c9 00 00    	add    $0xc969,%ebx
	uint32_t eax, ebx, ecx, edx;
	eax = 0; edx = 0;
  102691:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  102698:	00 
  102699:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1026a0:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  1026a1:	8d 44 24 0c          	lea    0xc(%esp),%eax
  1026a5:	50                   	push   %eax
  1026a6:	8d 44 24 14          	lea    0x14(%esp),%eax
  1026aa:	50                   	push   %eax
  1026ab:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  1026af:	50                   	push   %eax
  1026b0:	8d 44 24 24          	lea    0x24(%esp),%eax
  1026b4:	50                   	push   %eax
  1026b5:	68 01 00 00 40       	push   $0x40000001
  1026ba:	e8 cf 0e 00 00       	call   10358e <cpuid>

	return ((eax & feature) != 0 ? 1 : 0);
  1026bf:	8b 44 24 40          	mov    0x40(%esp),%eax
  1026c3:	23 44 24 2c          	and    0x2c(%esp),%eax
  1026c7:	85 c0                	test   %eax,%eax
  1026c9:	0f 95 c0             	setne  %al
  1026cc:	0f b6 c0             	movzbl %al,%eax
}
  1026cf:	83 c4 38             	add    $0x38,%esp
  1026d2:	5b                   	pop    %ebx
  1026d3:	c3                   	ret

001026d4 <kvm_enable_feature>:

int
kvm_enable_feature(uint32_t feature)
{
  1026d4:	53                   	push   %ebx
  1026d5:	83 ec 24             	sub    $0x24,%esp
  1026d8:	e8 60 dc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1026dd:	81 c3 17 c9 00 00    	add    $0xc917,%ebx
	uint32_t eax, ebx, ecx, edx;
	eax = 1 << feature; edx = 0;
  1026e3:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  1026e7:	b8 01 00 00 00       	mov    $0x1,%eax
  1026ec:	d3 e0                	shl    %cl,%eax
  1026ee:	89 44 24 18          	mov    %eax,0x18(%esp)
  1026f2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1026f9:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  1026fa:	8d 44 24 0c          	lea    0xc(%esp),%eax
  1026fe:	50                   	push   %eax
  1026ff:	8d 44 24 14          	lea    0x14(%esp),%eax
  102703:	50                   	push   %eax
  102704:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  102708:	50                   	push   %eax
  102709:	8d 44 24 24          	lea    0x24(%esp),%eax
  10270d:	50                   	push   %eax
  10270e:	68 01 00 00 40       	push   $0x40000001
  102713:	e8 76 0e 00 00       	call   10358e <cpuid>

	return (ebx == 0 ? 1 : 0);
  102718:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
  10271d:	0f 94 c0             	sete   %al
  102720:	0f b6 c0             	movzbl %al,%eax
}
  102723:	83 c4 38             	add    $0x38,%esp
  102726:	5b                   	pop    %ebx
  102727:	c3                   	ret

00102728 <kvm_get_tsc_hz>:

uint64_t
kvm_get_tsc_hz(void)
{
  102728:	55                   	push   %ebp
  102729:	57                   	push   %edi
  10272a:	56                   	push   %esi
  10272b:	53                   	push   %ebx
  10272c:	83 ec 28             	sub    $0x28,%esp
  10272f:	e8 09 dc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  102734:	81 c3 c0 c8 00 00    	add    $0xc8c0,%ebx
	uint64_t tsc_hz = 0llu;
	uint32_t msr_sys_time;

	if (kvm_has_feature(KVM_FEATURE_CLOCKSOURCE2))
  10273a:	6a 03                	push   $0x3
  10273c:	e8 41 ff ff ff       	call   102682 <kvm_has_feature>
  102741:	83 c4 10             	add    $0x10,%esp
  102744:	85 c0                	test   %eax,%eax
  102746:	75 18                	jne    102760 <kvm_get_tsc_hz+0x38>
	{
		msr_sys_time = MSR_KVM_SYSTEM_TIME_NEW;
	}
	else if (kvm_has_feature(KVM_FEATURE_CLOCKSOURCE))
  102748:	83 ec 0c             	sub    $0xc,%esp
  10274b:	6a 00                	push   $0x0
  10274d:	e8 30 ff ff ff       	call   102682 <kvm_has_feature>
  102752:	83 c4 10             	add    $0x10,%esp
  102755:	85 c0                	test   %eax,%eax
  102757:	74 57                	je     1027b0 <kvm_get_tsc_hz+0x88>
	{
		msr_sys_time = MSR_KVM_SYSTEM_TIME;
  102759:	bd 12 00 00 00       	mov    $0x12,%ebp
  10275e:	eb 05                	jmp    102765 <kvm_get_tsc_hz+0x3d>
		msr_sys_time = MSR_KVM_SYSTEM_TIME_NEW;
  102760:	bd 01 4d 56 4b       	mov    $0x4b564d01,%ebp
	{
		return (0llu);
	}

	/* bit0 == 1 means enable, kvm will update this memory periodically */
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock) | 0x1llu);
  102765:	8d 83 cc a8 02 00    	lea    0x2a8cc(%ebx),%eax
  10276b:	83 ec 04             	sub    $0x4,%esp
  10276e:	89 44 24 10          	mov    %eax,0x10(%esp)
  102772:	83 c8 01             	or     $0x1,%eax
  102775:	ba 00 00 00 00       	mov    $0x0,%edx
  10277a:	52                   	push   %edx
  10277b:	50                   	push   %eax
  10277c:	55                   	push   %ebp
  10277d:	e8 e5 0d 00 00       	call   103567 <wrmsr>

	tsc_hz = (uint64_t) pvclock.tsc_to_system_mul;
  102782:	8b b3 e4 a8 02 00    	mov    0x2a8e4(%ebx),%esi
  102788:	bf 00 00 00 00       	mov    $0x0,%edi

	/* disable update */
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock));
  10278d:	83 c4 0c             	add    $0xc,%esp
  102790:	8b 44 24 10          	mov    0x10(%esp),%eax
  102794:	ba 00 00 00 00       	mov    $0x0,%edx
  102799:	52                   	push   %edx
  10279a:	50                   	push   %eax
  10279b:	55                   	push   %ebp
  10279c:	e8 c6 0d 00 00       	call   103567 <wrmsr>

	return tsc_hz;
  1027a1:	83 c4 10             	add    $0x10,%esp
}
  1027a4:	89 f0                	mov    %esi,%eax
  1027a6:	89 fa                	mov    %edi,%edx
  1027a8:	83 c4 1c             	add    $0x1c,%esp
  1027ab:	5b                   	pop    %ebx
  1027ac:	5e                   	pop    %esi
  1027ad:	5f                   	pop    %edi
  1027ae:	5d                   	pop    %ebp
  1027af:	c3                   	ret
		return (0llu);
  1027b0:	be 00 00 00 00       	mov    $0x0,%esi
  1027b5:	bf 00 00 00 00       	mov    $0x0,%edi
  1027ba:	eb e8                	jmp    1027a4 <kvm_get_tsc_hz+0x7c>
  1027bc:	66 90                	xchg   %ax,%ax
  1027be:	66 90                	xchg   %ax,%ax

001027c0 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *v, int c, size_t n)
{
  1027c0:	57                   	push   %edi
  1027c1:	53                   	push   %ebx
  1027c2:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  1027c6:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    if (n == 0)
  1027ca:	85 c9                	test   %ecx,%ecx
  1027cc:	74 38                	je     102806 <memset+0x46>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
  1027ce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  1027d4:	75 29                	jne    1027ff <memset+0x3f>
  1027d6:	f6 c1 03             	test   $0x3,%cl
  1027d9:	75 24                	jne    1027ff <memset+0x3f>
        c &= 0xFF;
  1027db:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
  1027e0:	8b 44 24 10          	mov    0x10(%esp),%eax
  1027e4:	c1 e0 18             	shl    $0x18,%eax
  1027e7:	89 d3                	mov    %edx,%ebx
  1027e9:	c1 e3 10             	shl    $0x10,%ebx
  1027ec:	09 d8                	or     %ebx,%eax
  1027ee:	89 d3                	mov    %edx,%ebx
  1027f0:	c1 e3 08             	shl    $0x8,%ebx
  1027f3:	09 d8                	or     %ebx,%eax
  1027f5:	09 d0                	or     %edx,%eax
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
  1027f7:	c1 e9 02             	shr    $0x2,%ecx
        asm volatile ("cld; rep stosl\n"
  1027fa:	fc                   	cld
  1027fb:	f3 ab                	rep stos %eax,%es:(%edi)
  1027fd:	eb 07                	jmp    102806 <memset+0x46>
                      : "cc", "memory");
    } else
        asm volatile ("cld; rep stosb\n"
  1027ff:	8b 44 24 10          	mov    0x10(%esp),%eax
  102803:	fc                   	cld
  102804:	f3 aa                	rep stos %al,%es:(%edi)
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
  102806:	89 f8                	mov    %edi,%eax
  102808:	5b                   	pop    %ebx
  102809:	5f                   	pop    %edi
  10280a:	c3                   	ret

0010280b <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
  10280b:	57                   	push   %edi
  10280c:	56                   	push   %esi
  10280d:	8b 44 24 0c          	mov    0xc(%esp),%eax
  102811:	8b 74 24 10          	mov    0x10(%esp),%esi
  102815:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  102819:	39 c6                	cmp    %eax,%esi
  10281b:	73 36                	jae    102853 <memmove+0x48>
  10281d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  102820:	39 d0                	cmp    %edx,%eax
  102822:	73 2f                	jae    102853 <memmove+0x48>
        s += n;
        d += n;
  102824:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
  102827:	f6 c2 03             	test   $0x3,%dl
  10282a:	75 1b                	jne    102847 <memmove+0x3c>
  10282c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  102832:	75 13                	jne    102847 <memmove+0x3c>
  102834:	f6 c1 03             	test   $0x3,%cl
  102837:	75 0e                	jne    102847 <memmove+0x3c>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
  102839:	83 ef 04             	sub    $0x4,%edi
  10283c:	8d 72 fc             	lea    -0x4(%edx),%esi
  10283f:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
  102842:	fd                   	std
  102843:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102845:	eb 09                	jmp    102850 <memmove+0x45>
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
  102847:	83 ef 01             	sub    $0x1,%edi
  10284a:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
  10284d:	fd                   	std
  10284e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
  102850:	fc                   	cld
  102851:	eb 20                	jmp    102873 <memmove+0x68>
    } else {
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
  102853:	f7 c6 03 00 00 00    	test   $0x3,%esi
  102859:	75 13                	jne    10286e <memmove+0x63>
  10285b:	a8 03                	test   $0x3,%al
  10285d:	75 0f                	jne    10286e <memmove+0x63>
  10285f:	f6 c1 03             	test   $0x3,%cl
  102862:	75 0a                	jne    10286e <memmove+0x63>
            asm volatile ("cld; rep movsl\n"
                          :: "D" (d), "S" (s), "c" (n / 4)
  102864:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
  102867:	89 c7                	mov    %eax,%edi
  102869:	fc                   	cld
  10286a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10286c:	eb 05                	jmp    102873 <memmove+0x68>
                          : "cc", "memory");
        else
            asm volatile ("cld; rep movsb\n"
  10286e:	89 c7                	mov    %eax,%edi
  102870:	fc                   	cld
  102871:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
  102873:	5e                   	pop    %esi
  102874:	5f                   	pop    %edi
  102875:	c3                   	ret

00102876 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
  102876:	ff 74 24 0c          	push   0xc(%esp)
  10287a:	ff 74 24 0c          	push   0xc(%esp)
  10287e:	ff 74 24 0c          	push   0xc(%esp)
  102882:	e8 84 ff ff ff       	call   10280b <memmove>
  102887:	83 c4 0c             	add    $0xc,%esp
}
  10288a:	c3                   	ret

0010288b <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
  10288b:	53                   	push   %ebx
  10288c:	8b 54 24 08          	mov    0x8(%esp),%edx
  102890:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  102894:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
  102898:	eb 09                	jmp    1028a3 <strncmp+0x18>
        n--, p++, q++;
  10289a:	83 e8 01             	sub    $0x1,%eax
  10289d:	83 c2 01             	add    $0x1,%edx
  1028a0:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
  1028a3:	85 c0                	test   %eax,%eax
  1028a5:	74 0b                	je     1028b2 <strncmp+0x27>
  1028a7:	0f b6 1a             	movzbl (%edx),%ebx
  1028aa:	84 db                	test   %bl,%bl
  1028ac:	74 04                	je     1028b2 <strncmp+0x27>
  1028ae:	3a 19                	cmp    (%ecx),%bl
  1028b0:	74 e8                	je     10289a <strncmp+0xf>
    if (n == 0)
  1028b2:	85 c0                	test   %eax,%eax
  1028b4:	74 0a                	je     1028c0 <strncmp+0x35>
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
  1028b6:	0f b6 02             	movzbl (%edx),%eax
  1028b9:	0f b6 11             	movzbl (%ecx),%edx
  1028bc:	29 d0                	sub    %edx,%eax
}
  1028be:	5b                   	pop    %ebx
  1028bf:	c3                   	ret
        return 0;
  1028c0:	b8 00 00 00 00       	mov    $0x0,%eax
  1028c5:	eb f7                	jmp    1028be <strncmp+0x33>

001028c7 <strnlen>:

int strnlen(const char *s, size_t size)
{
  1028c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  1028cb:	8b 44 24 08          	mov    0x8(%esp),%eax
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  1028cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  1028d4:	eb 13                	jmp    1028e9 <strnlen+0x22>
  1028d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1028dd:	00 
  1028de:	66 90                	xchg   %ax,%ax
        n++;
  1028e0:	83 c1 01             	add    $0x1,%ecx
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  1028e3:	83 c2 01             	add    $0x1,%edx
  1028e6:	83 e8 01             	sub    $0x1,%eax
  1028e9:	85 c0                	test   %eax,%eax
  1028eb:	74 05                	je     1028f2 <strnlen+0x2b>
  1028ed:	80 3a 00             	cmpb   $0x0,(%edx)
  1028f0:	75 ee                	jne    1028e0 <strnlen+0x19>
    return n;
}
  1028f2:	89 c8                	mov    %ecx,%eax
  1028f4:	c3                   	ret

001028f5 <strcmp>:

int strcmp(const char *p, const char *q)
{
  1028f5:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1028f9:	8b 54 24 08          	mov    0x8(%esp),%edx
    while (*p && *p == *q)
  1028fd:	eb 07                	jmp    102906 <strcmp+0x11>
  1028ff:	90                   	nop
        p++, q++;
  102900:	83 c1 01             	add    $0x1,%ecx
  102903:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
  102906:	0f b6 01             	movzbl (%ecx),%eax
  102909:	84 c0                	test   %al,%al
  10290b:	74 04                	je     102911 <strcmp+0x1c>
  10290d:	3a 02                	cmp    (%edx),%al
  10290f:	74 ef                	je     102900 <strcmp+0xb>
    return (int) ((unsigned char) *p - (unsigned char) *q);
  102911:	0f b6 c0             	movzbl %al,%eax
  102914:	0f b6 12             	movzbl (%edx),%edx
  102917:	29 d0                	sub    %edx,%eax
}
  102919:	c3                   	ret

0010291a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *strchr(const char *s, char c)
{
  10291a:	8b 44 24 04          	mov    0x4(%esp),%eax
  10291e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
  102923:	eb 0e                	jmp    102933 <strchr+0x19>
  102925:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10292c:	00 
  10292d:	8d 76 00             	lea    0x0(%esi),%esi
  102930:	83 c0 01             	add    $0x1,%eax
  102933:	0f b6 10             	movzbl (%eax),%edx
  102936:	84 d2                	test   %dl,%dl
  102938:	74 05                	je     10293f <strchr+0x25>
        if (*s == c)
  10293a:	38 ca                	cmp    %cl,%dl
  10293c:	75 f2                	jne    102930 <strchr+0x16>
  10293e:	c3                   	ret
            return (char *) s;
    return 0;
  10293f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102944:	c3                   	ret

00102945 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
  102945:	ff 74 24 08          	push   0x8(%esp)
  102949:	6a 00                	push   $0x0
  10294b:	ff 74 24 0c          	push   0xc(%esp)
  10294f:	e8 6c fe ff ff       	call   1027c0 <memset>
  102954:	83 c4 0c             	add    $0xc,%esp
}
  102957:	c3                   	ret
  102958:	66 90                	xchg   %ax,%ax
  10295a:	66 90                	xchg   %ax,%ax
  10295c:	66 90                	xchg   %ax,%ax
  10295e:	66 90                	xchg   %ax,%ax

00102960 <debug_trace>:
}

#define DEBUG_TRACEFRAMES 10

static void debug_trace(uintptr_t ebp, uintptr_t *eips)
{
  102960:	53                   	push   %ebx
    int i;
    uintptr_t *frame = (uintptr_t *) ebp;

    for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  102961:	b9 00 00 00 00       	mov    $0x0,%ecx
  102966:	eb 23                	jmp    10298b <debug_trace+0x2b>
  102968:	eb 16                	jmp    102980 <debug_trace+0x20>
  10296a:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  102971:	00 
  102972:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  102979:	00 
  10297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        eips[i] = frame[1];              /* saved %eip */
  102980:	8b 58 04             	mov    0x4(%eax),%ebx
  102983:	89 1c 8a             	mov    %ebx,(%edx,%ecx,4)
        frame = (uintptr_t *) frame[0];  /* saved %ebp */
  102986:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  102988:	83 c1 01             	add    $0x1,%ecx
  10298b:	83 f9 09             	cmp    $0x9,%ecx
  10298e:	0f 9e c3             	setle  %bl
  102991:	85 c0                	test   %eax,%eax
  102993:	74 15                	je     1029aa <debug_trace+0x4a>
  102995:	84 db                	test   %bl,%bl
  102997:	75 e7                	jne    102980 <debug_trace+0x20>
  102999:	eb 0f                	jmp    1029aa <debug_trace+0x4a>
  10299b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    }
    for (; i < DEBUG_TRACEFRAMES; i++)
        eips[i] = 0;
  1029a0:	c7 04 8a 00 00 00 00 	movl   $0x0,(%edx,%ecx,4)
    for (; i < DEBUG_TRACEFRAMES; i++)
  1029a7:	83 c1 01             	add    $0x1,%ecx
  1029aa:	83 f9 09             	cmp    $0x9,%ecx
  1029ad:	7e f1                	jle    1029a0 <debug_trace+0x40>
}
  1029af:	5b                   	pop    %ebx
  1029b0:	c3                   	ret

001029b1 <debug_info>:
{
  1029b1:	53                   	push   %ebx
  1029b2:	83 ec 08             	sub    $0x8,%esp
  1029b5:	e8 83 d9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1029ba:	81 c3 3a c6 00 00    	add    $0xc63a,%ebx
    va_start(ap, fmt);
  1029c0:	8d 44 24 14          	lea    0x14(%esp),%eax
    vdprintf(fmt, ap);
  1029c4:	83 ec 08             	sub    $0x8,%esp
  1029c7:	50                   	push   %eax
  1029c8:	ff 74 24 1c          	push   0x1c(%esp)
  1029cc:	e8 72 01 00 00       	call   102b43 <vdprintf>
}
  1029d1:	83 c4 18             	add    $0x18,%esp
  1029d4:	5b                   	pop    %ebx
  1029d5:	c3                   	ret

001029d6 <debug_normal>:
{
  1029d6:	53                   	push   %ebx
  1029d7:	83 ec 0c             	sub    $0xc,%esp
  1029da:	e8 5e d9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1029df:	81 c3 15 c6 00 00    	add    $0xc615,%ebx
    dprintf("[D] %s:%d: ", file, line);
  1029e5:	ff 74 24 18          	push   0x18(%esp)
  1029e9:	ff 74 24 18          	push   0x18(%esp)
  1029ed:	8d 83 7f 91 ff ff    	lea    -0x6e81(%ebx),%eax
  1029f3:	50                   	push   %eax
  1029f4:	e8 a9 01 00 00       	call   102ba2 <dprintf>
    va_start(ap, fmt);
  1029f9:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    vdprintf(fmt, ap);
  1029fd:	83 c4 08             	add    $0x8,%esp
  102a00:	50                   	push   %eax
  102a01:	ff 74 24 24          	push   0x24(%esp)
  102a05:	e8 39 01 00 00       	call   102b43 <vdprintf>
}
  102a0a:	83 c4 18             	add    $0x18,%esp
  102a0d:	5b                   	pop    %ebx
  102a0e:	c3                   	ret

00102a0f <debug_panic>:

gcc_noinline void debug_panic(const char *file, int line, const char *fmt, ...)
{
  102a0f:	56                   	push   %esi
  102a10:	53                   	push   %ebx
  102a11:	83 ec 38             	sub    $0x38,%esp
  102a14:	e8 24 d9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  102a19:	81 c3 db c5 00 00    	add    $0xc5db,%ebx
    int i;
    uintptr_t eips[DEBUG_TRACEFRAMES];
    va_list ap;

    dprintf("[P] %s:%d: ", file, line);
  102a1f:	ff 74 24 48          	push   0x48(%esp)
  102a23:	ff 74 24 48          	push   0x48(%esp)
  102a27:	8d 83 8b 91 ff ff    	lea    -0x6e75(%ebx),%eax
  102a2d:	50                   	push   %eax
  102a2e:	e8 6f 01 00 00       	call   102ba2 <dprintf>

    va_start(ap, fmt);
  102a33:	8d 44 24 5c          	lea    0x5c(%esp),%eax
    vdprintf(fmt, ap);
  102a37:	83 c4 08             	add    $0x8,%esp
  102a3a:	50                   	push   %eax
  102a3b:	ff 74 24 54          	push   0x54(%esp)
  102a3f:	e8 ff 00 00 00       	call   102b43 <vdprintf>
#define MAX_CHILDREN 3

static inline uint32_t __attribute__ ((always_inline)) read_ebp(void)
{
    uint32_t ebp;
    __asm __volatile ("movl %%ebp,%0" : "=rm" (ebp));
  102a44:	89 e8                	mov    %ebp,%eax
    va_end(ap);

    debug_trace(read_ebp(), eips);
  102a46:	8d 54 24 18          	lea    0x18(%esp),%edx
  102a4a:	e8 11 ff ff ff       	call   102960 <debug_trace>
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  102a4f:	83 c4 10             	add    $0x10,%esp
  102a52:	be 00 00 00 00       	mov    $0x0,%esi
  102a57:	83 fe 09             	cmp    $0x9,%esi
  102a5a:	7f 20                	jg     102a7c <debug_panic+0x6d>
  102a5c:	8b 44 b4 08          	mov    0x8(%esp,%esi,4),%eax
  102a60:	85 c0                	test   %eax,%eax
  102a62:	74 18                	je     102a7c <debug_panic+0x6d>
        dprintf("\tfrom 0x%08x\n", eips[i]);
  102a64:	83 ec 08             	sub    $0x8,%esp
  102a67:	50                   	push   %eax
  102a68:	8d 83 97 91 ff ff    	lea    -0x6e69(%ebx),%eax
  102a6e:	50                   	push   %eax
  102a6f:	e8 2e 01 00 00       	call   102ba2 <dprintf>
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  102a74:	83 c6 01             	add    $0x1,%esi
  102a77:	83 c4 10             	add    $0x10,%esp
  102a7a:	eb db                	jmp    102a57 <debug_panic+0x48>

    dprintf("Kernel Panic !!!\n");
  102a7c:	83 ec 0c             	sub    $0xc,%esp
  102a7f:	8d 83 a5 91 ff ff    	lea    -0x6e5b(%ebx),%eax
  102a85:	50                   	push   %eax
  102a86:	e8 17 01 00 00       	call   102ba2 <dprintf>

    halt();
  102a8b:	e8 e6 0a 00 00       	call   103576 <halt>
}
  102a90:	83 c4 44             	add    $0x44,%esp
  102a93:	5b                   	pop    %ebx
  102a94:	5e                   	pop    %esi
  102a95:	c3                   	ret

00102a96 <debug_warn>:

void debug_warn(const char *file, int line, const char *fmt, ...)
{
  102a96:	53                   	push   %ebx
  102a97:	83 ec 0c             	sub    $0xc,%esp
  102a9a:	e8 9e d8 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  102a9f:	81 c3 55 c5 00 00    	add    $0xc555,%ebx
    dprintf("[W] %s:%d: ", file, line);
  102aa5:	ff 74 24 18          	push   0x18(%esp)
  102aa9:	ff 74 24 18          	push   0x18(%esp)
  102aad:	8d 83 b7 91 ff ff    	lea    -0x6e49(%ebx),%eax
  102ab3:	50                   	push   %eax
  102ab4:	e8 e9 00 00 00       	call   102ba2 <dprintf>

    va_list ap;
    va_start(ap, fmt);
  102ab9:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    vdprintf(fmt, ap);
  102abd:	83 c4 08             	add    $0x8,%esp
  102ac0:	50                   	push   %eax
  102ac1:	ff 74 24 24          	push   0x24(%esp)
  102ac5:	e8 79 00 00 00       	call   102b43 <vdprintf>
    va_end(ap);
}
  102aca:	83 c4 18             	add    $0x18,%esp
  102acd:	5b                   	pop    %ebx
  102ace:	c3                   	ret

00102acf <cputs>:
    int cnt;  /* total bytes printed so far */
    char buf[CONSOLE_BUFFER_SIZE];
};

static void cputs(const char *str)
{
  102acf:	56                   	push   %esi
  102ad0:	53                   	push   %ebx
  102ad1:	83 ec 04             	sub    $0x4,%esp
  102ad4:	e8 64 d8 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  102ad9:	81 c3 1b c5 00 00    	add    $0xc51b,%ebx
  102adf:	89 c6                	mov    %eax,%esi
    while (*str) {
  102ae1:	eb 12                	jmp    102af5 <cputs+0x26>
        cons_putc(*str);
  102ae3:	83 ec 0c             	sub    $0xc,%esp
  102ae6:	0f be c0             	movsbl %al,%eax
  102ae9:	50                   	push   %eax
  102aea:	e8 28 d9 ff ff       	call   100417 <cons_putc>
        str += 1;
  102aef:	83 c6 01             	add    $0x1,%esi
  102af2:	83 c4 10             	add    $0x10,%esp
    while (*str) {
  102af5:	0f b6 06             	movzbl (%esi),%eax
  102af8:	84 c0                	test   %al,%al
  102afa:	75 e7                	jne    102ae3 <cputs+0x14>
    }
}
  102afc:	83 c4 04             	add    $0x4,%esp
  102aff:	5b                   	pop    %ebx
  102b00:	5e                   	pop    %esi
  102b01:	c3                   	ret

00102b02 <putch>:

static void putch(int ch, struct dprintbuf *b)
{
  102b02:	53                   	push   %ebx
  102b03:	83 ec 08             	sub    $0x8,%esp
  102b06:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    b->buf[b->idx++] = ch;
  102b0a:	8b 13                	mov    (%ebx),%edx
  102b0c:	8d 42 01             	lea    0x1(%edx),%eax
  102b0f:	89 03                	mov    %eax,(%ebx)
  102b11:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  102b15:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
    if (b->idx == CONSOLE_BUFFER_SIZE - 1) {
  102b19:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  102b1e:	74 0e                	je     102b2e <putch+0x2c>
        b->buf[b->idx] = 0;
        cputs(b->buf);
        b->idx = 0;
    }
    b->cnt++;
  102b20:	8b 43 04             	mov    0x4(%ebx),%eax
  102b23:	83 c0 01             	add    $0x1,%eax
  102b26:	89 43 04             	mov    %eax,0x4(%ebx)
}
  102b29:	83 c4 08             	add    $0x8,%esp
  102b2c:	5b                   	pop    %ebx
  102b2d:	c3                   	ret
        b->buf[b->idx] = 0;
  102b2e:	c6 44 13 09 00       	movb   $0x0,0x9(%ebx,%edx,1)
        cputs(b->buf);
  102b33:	8d 43 08             	lea    0x8(%ebx),%eax
  102b36:	e8 94 ff ff ff       	call   102acf <cputs>
        b->idx = 0;
  102b3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  102b41:	eb dd                	jmp    102b20 <putch+0x1e>

00102b43 <vdprintf>:

int vdprintf(const char *fmt, va_list ap)
{
  102b43:	53                   	push   %ebx
  102b44:	81 ec 18 02 00 00    	sub    $0x218,%esp
  102b4a:	e8 ee d7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  102b4f:	81 c3 a5 c4 00 00    	add    $0xc4a5,%ebx
    struct dprintbuf b;

    b.idx = 0;
  102b55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102b5c:	00 
    b.cnt = 0;
  102b5d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102b64:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
  102b65:	ff b4 24 24 02 00 00 	push   0x224(%esp)
  102b6c:	ff b4 24 24 02 00 00 	push   0x224(%esp)
  102b73:	8d 44 24 10          	lea    0x10(%esp),%eax
  102b77:	50                   	push   %eax
  102b78:	8d 83 0e 3b ff ff    	lea    -0xc4f2(%ebx),%eax
  102b7e:	50                   	push   %eax
  102b7f:	e8 63 01 00 00       	call   102ce7 <vprintfmt>

    b.buf[b.idx] = 0;
  102b84:	8b 44 24 18          	mov    0x18(%esp),%eax
  102b88:	c6 44 04 20 00       	movb   $0x0,0x20(%esp,%eax,1)
    cputs(b.buf);
  102b8d:	8d 44 24 20          	lea    0x20(%esp),%eax
  102b91:	e8 39 ff ff ff       	call   102acf <cputs>

    return b.cnt;
}
  102b96:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  102b9a:	81 c4 28 02 00 00    	add    $0x228,%esp
  102ba0:	5b                   	pop    %ebx
  102ba1:	c3                   	ret

00102ba2 <dprintf>:

int dprintf(const char *fmt, ...)
{
  102ba2:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
  102ba5:	8d 44 24 14          	lea    0x14(%esp),%eax
    cnt = vdprintf(fmt, ap);
  102ba9:	83 ec 08             	sub    $0x8,%esp
  102bac:	50                   	push   %eax
  102bad:	ff 74 24 1c          	push   0x1c(%esp)
  102bb1:	e8 8d ff ff ff       	call   102b43 <vdprintf>
    va_end(ap);

    return cnt;
}
  102bb6:	83 c4 1c             	add    $0x1c,%esp
  102bb9:	c3                   	ret
  102bba:	66 90                	xchg   %ax,%ax
  102bbc:	66 90                	xchg   %ax,%ax
  102bbe:	66 90                	xchg   %ax,%ax

00102bc0 <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void printnum(putch_t putch, void *putdat, unsigned long long num,
                     unsigned base, int width, int padc)
{
  102bc0:	55                   	push   %ebp
  102bc1:	57                   	push   %edi
  102bc2:	56                   	push   %esi
  102bc3:	53                   	push   %ebx
  102bc4:	83 ec 2c             	sub    $0x2c,%esp
  102bc7:	e8 6d d7 ff ff       	call   100339 <__x86.get_pc_thunk.cx>
  102bcc:	81 c1 28 c4 00 00    	add    $0xc428,%ecx
  102bd2:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  102bd6:	89 c6                	mov    %eax,%esi
  102bd8:	89 d7                	mov    %edx,%edi
  102bda:	8b 44 24 40          	mov    0x40(%esp),%eax
  102bde:	8b 54 24 44          	mov    0x44(%esp),%edx
  102be2:	89 d1                	mov    %edx,%ecx
  102be4:	89 c2                	mov    %eax,%edx
  102be6:	89 44 24 18          	mov    %eax,0x18(%esp)
  102bea:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
  102bee:	8b 44 24 48          	mov    0x48(%esp),%eax
  102bf2:	8b 5c 24 4c          	mov    0x4c(%esp),%ebx
  102bf6:	8b 6c 24 50          	mov    0x50(%esp),%ebp
    /* first recursively print all preceding (more significant) digits */
    if (num >= base) {
  102bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bfe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102c05:	00 
  102c06:	39 c2                	cmp    %eax,%edx
  102c08:	1b 4c 24 0c          	sbb    0xc(%esp),%ecx
  102c0c:	72 42                	jb     102c50 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
  102c0e:	83 ec 0c             	sub    $0xc,%esp
  102c11:	55                   	push   %ebp
  102c12:	83 eb 01             	sub    $0x1,%ebx
  102c15:	53                   	push   %ebx
  102c16:	50                   	push   %eax
  102c17:	83 ec 08             	sub    $0x8,%esp
  102c1a:	ff 74 24 2c          	push   0x2c(%esp)
  102c1e:	ff 74 24 2c          	push   0x2c(%esp)
  102c22:	ff 74 24 44          	push   0x44(%esp)
  102c26:	ff 74 24 44          	push   0x44(%esp)
  102c2a:	8b 5c 24 44          	mov    0x44(%esp),%ebx
  102c2e:	e8 2d 4a 00 00       	call   107660 <__udivdi3>
  102c33:	83 c4 18             	add    $0x18,%esp
  102c36:	52                   	push   %edx
  102c37:	50                   	push   %eax
  102c38:	89 fa                	mov    %edi,%edx
  102c3a:	89 f0                	mov    %esi,%eax
  102c3c:	e8 7f ff ff ff       	call   102bc0 <printnum>
  102c41:	83 c4 20             	add    $0x20,%esp
  102c44:	eb 11                	jmp    102c57 <printnum+0x97>
    } else {
        /* print any needed pad characters before first digit */
        while (--width > 0)
            putch(padc, putdat);
  102c46:	83 ec 08             	sub    $0x8,%esp
  102c49:	57                   	push   %edi
  102c4a:	55                   	push   %ebp
  102c4b:	ff d6                	call   *%esi
  102c4d:	83 c4 10             	add    $0x10,%esp
        while (--width > 0)
  102c50:	83 eb 01             	sub    $0x1,%ebx
  102c53:	85 db                	test   %ebx,%ebx
  102c55:	7f ef                	jg     102c46 <printnum+0x86>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
  102c57:	ff 74 24 0c          	push   0xc(%esp)
  102c5b:	ff 74 24 0c          	push   0xc(%esp)
  102c5f:	ff 74 24 24          	push   0x24(%esp)
  102c63:	ff 74 24 24          	push   0x24(%esp)
  102c67:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  102c6b:	e8 10 4b 00 00       	call   107780 <__umoddi3>
  102c70:	83 c4 08             	add    $0x8,%esp
  102c73:	57                   	push   %edi
  102c74:	0f be 84 03 c3 91 ff 	movsbl -0x6e3d(%ebx,%eax,1),%eax
  102c7b:	ff 
  102c7c:	50                   	push   %eax
  102c7d:	ff d6                	call   *%esi
}
  102c7f:	83 c4 3c             	add    $0x3c,%esp
  102c82:	5b                   	pop    %ebx
  102c83:	5e                   	pop    %esi
  102c84:	5f                   	pop    %edi
  102c85:	5d                   	pop    %ebp
  102c86:	c3                   	ret

00102c87 <getuint>:
 * Get an unsigned int of various possible sizes from a varargs list,
 * depending on the lflag parameter.
 */
static unsigned long long getuint(va_list *ap, int lflag)
{
    if (lflag >= 2)
  102c87:	83 fa 01             	cmp    $0x1,%edx
  102c8a:	7f 13                	jg     102c9f <getuint+0x18>
        return va_arg(*ap, unsigned long long);
    else if (lflag)
  102c8c:	85 d2                	test   %edx,%edx
  102c8e:	74 1c                	je     102cac <getuint+0x25>
        return va_arg(*ap, unsigned long);
  102c90:	8b 10                	mov    (%eax),%edx
  102c92:	8d 4a 04             	lea    0x4(%edx),%ecx
  102c95:	89 08                	mov    %ecx,(%eax)
  102c97:	8b 02                	mov    (%edx),%eax
  102c99:	ba 00 00 00 00       	mov    $0x0,%edx
  102c9e:	c3                   	ret
        return va_arg(*ap, unsigned long long);
  102c9f:	8b 10                	mov    (%eax),%edx
  102ca1:	8d 4a 08             	lea    0x8(%edx),%ecx
  102ca4:	89 08                	mov    %ecx,(%eax)
  102ca6:	8b 02                	mov    (%edx),%eax
  102ca8:	8b 52 04             	mov    0x4(%edx),%edx
  102cab:	c3                   	ret
    else
        return va_arg(*ap, unsigned int);
  102cac:	8b 10                	mov    (%eax),%edx
  102cae:	8d 4a 04             	lea    0x4(%edx),%ecx
  102cb1:	89 08                	mov    %ecx,(%eax)
  102cb3:	8b 02                	mov    (%edx),%eax
  102cb5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  102cba:	c3                   	ret

00102cbb <getint>:
 * Same as getuint but signed - can't use getuint
 * because of sign extension
 */
static long long getint(va_list *ap, int lflag)
{
    if (lflag >= 2)
  102cbb:	83 fa 01             	cmp    $0x1,%edx
  102cbe:	7f 0f                	jg     102ccf <getint+0x14>
        return va_arg(*ap, long long);
    else if (lflag)
  102cc0:	85 d2                	test   %edx,%edx
  102cc2:	74 18                	je     102cdc <getint+0x21>
        return va_arg(*ap, long);
  102cc4:	8b 10                	mov    (%eax),%edx
  102cc6:	8d 4a 04             	lea    0x4(%edx),%ecx
  102cc9:	89 08                	mov    %ecx,(%eax)
  102ccb:	8b 02                	mov    (%edx),%eax
  102ccd:	99                   	cltd
  102cce:	c3                   	ret
        return va_arg(*ap, long long);
  102ccf:	8b 10                	mov    (%eax),%edx
  102cd1:	8d 4a 08             	lea    0x8(%edx),%ecx
  102cd4:	89 08                	mov    %ecx,(%eax)
  102cd6:	8b 02                	mov    (%edx),%eax
  102cd8:	8b 52 04             	mov    0x4(%edx),%edx
  102cdb:	c3                   	ret
    else
        return va_arg(*ap, int);
  102cdc:	8b 10                	mov    (%eax),%edx
  102cde:	8d 4a 04             	lea    0x4(%edx),%ecx
  102ce1:	89 08                	mov    %ecx,(%eax)
  102ce3:	8b 02                	mov    (%edx),%eax
  102ce5:	99                   	cltd
}
  102ce6:	c3                   	ret

00102ce7 <vprintfmt>:

void vprintfmt(putch_t putch, void *putdat, const char *fmt, va_list ap)
{
  102ce7:	55                   	push   %ebp
  102ce8:	57                   	push   %edi
  102ce9:	56                   	push   %esi
  102cea:	53                   	push   %ebx
  102ceb:	83 ec 2c             	sub    $0x2c,%esp
  102cee:	e8 37 e1 ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  102cf3:	05 01 c3 00 00       	add    $0xc301,%eax
  102cf8:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cfc:	8b 74 24 40          	mov    0x40(%esp),%esi
  102d00:	8b 7c 24 44          	mov    0x44(%esp),%edi
  102d04:	8b 6c 24 48          	mov    0x48(%esp),%ebp
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char *) fmt++) != '%') {
  102d08:	8d 5d 01             	lea    0x1(%ebp),%ebx
  102d0b:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
  102d0f:	83 f8 25             	cmp    $0x25,%eax
  102d12:	74 16                	je     102d2a <vprintfmt+0x43>
            if (ch == '\0')
  102d14:	85 c0                	test   %eax,%eax
  102d16:	0f 84 22 03 00 00    	je     10303e <.L25+0x27>
                return;
            putch(ch, putdat);
  102d1c:	83 ec 08             	sub    $0x8,%esp
  102d1f:	57                   	push   %edi
  102d20:	50                   	push   %eax
  102d21:	ff d6                	call   *%esi
  102d23:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
  102d26:	89 dd                	mov    %ebx,%ebp
  102d28:	eb de                	jmp    102d08 <vprintfmt+0x21>
        }

        // Process a %-escape sequence
        padc = ' ';
  102d2a:	c6 44 24 1b 20       	movb   $0x20,0x1b(%esp)
        width = -1;
        precision = -1;
        lflag = 0;
        altflag = 0;
  102d2f:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  102d36:	00 
        precision = -1;
  102d37:	c7 44 24 10 ff ff ff 	movl   $0xffffffff,0x10(%esp)
  102d3e:	ff 
        width = -1;
  102d3f:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  102d46:	ff 
        lflag = 0;
  102d47:	b9 00 00 00 00       	mov    $0x0,%ecx
  102d4c:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
      reswitch:
        switch (ch = *(unsigned char *) fmt++) {
  102d50:	8d 6b 01             	lea    0x1(%ebx),%ebp
  102d53:	0f b6 03             	movzbl (%ebx),%eax
  102d56:	0f b6 d0             	movzbl %al,%edx
  102d59:	89 14 24             	mov    %edx,(%esp)
  102d5c:	83 e8 23             	sub    $0x23,%eax
  102d5f:	3c 55                	cmp    $0x55,%al
  102d61:	0f 87 b0 02 00 00    	ja     103017 <.L25>
  102d67:	0f b6 c0             	movzbl %al,%eax
  102d6a:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  102d6e:	89 ca                	mov    %ecx,%edx
  102d70:	03 94 81 18 a1 ff ff 	add    -0x5ee8(%ecx,%eax,4),%edx
  102d77:	ff e2                	jmp    *%edx

00102d79 <.L23>:
  102d79:	89 eb                	mov    %ebp,%ebx
  102d7b:	c6 44 24 1b 2d       	movb   $0x2d,0x1b(%esp)
  102d80:	eb ce                	jmp    102d50 <vprintfmt+0x69>

00102d82 <.L58>:
  102d82:	89 eb                	mov    %ebp,%ebx
            padc = '-';
            goto reswitch;

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d84:	c6 44 24 1b 30       	movb   $0x30,0x1b(%esp)
  102d89:	eb c5                	jmp    102d50 <vprintfmt+0x69>

00102d8b <.L59>:
        switch (ch = *(unsigned char *) fmt++) {
  102d8b:	b9 00 00 00 00       	mov    $0x0,%ecx
  102d90:	8b 14 24             	mov    (%esp),%edx
  102d93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  102d9a:	00 
  102d9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        case '6':
        case '7':
        case '8':
        case '9':
            for (precision = 0;; ++fmt) {
                precision = precision * 10 + ch - '0';
  102da0:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  102da3:	8d 4c 42 d0          	lea    -0x30(%edx,%eax,2),%ecx
                ch = *fmt;
  102da7:	0f be 55 00          	movsbl 0x0(%ebp),%edx
                if (ch < '0' || ch > '9')
  102dab:	8d 42 d0             	lea    -0x30(%edx),%eax
  102dae:	83 f8 09             	cmp    $0x9,%eax
  102db1:	77 3f                	ja     102df2 <.L38+0xf>
            for (precision = 0;; ++fmt) {
  102db3:	83 c5 01             	add    $0x1,%ebp
                precision = precision * 10 + ch - '0';
  102db6:	eb e8                	jmp    102da0 <.L59+0x15>

00102db8 <.L36>:
                    break;
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102db8:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102dbc:	8d 50 04             	lea    0x4(%eax),%edx
  102dbf:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  102dc3:	8b 00                	mov    (%eax),%eax
  102dc5:	89 44 24 10          	mov    %eax,0x10(%esp)
            goto process_precision;
  102dc9:	eb 2b                	jmp    102df6 <.L38+0x13>

00102dcb <.L35>:

        case '.':
            if (width < 0)
  102dcb:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  102dd0:	78 07                	js     102dd9 <.L35+0xe>
        switch (ch = *(unsigned char *) fmt++) {
  102dd2:	89 eb                	mov    %ebp,%ebx
                width = 0;
            goto reswitch;
  102dd4:	e9 77 ff ff ff       	jmp    102d50 <vprintfmt+0x69>
                width = 0;
  102dd9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102de0:	00 
  102de1:	eb ef                	jmp    102dd2 <.L35+0x7>

00102de3 <.L38>:
        switch (ch = *(unsigned char *) fmt++) {
  102de3:	89 eb                	mov    %ebp,%ebx

        case '#':
            altflag = 1;
  102de5:	c7 44 24 14 01 00 00 	movl   $0x1,0x14(%esp)
  102dec:	00 
            goto reswitch;
  102ded:	e9 5e ff ff ff       	jmp    102d50 <vprintfmt+0x69>
  102df2:	89 4c 24 10          	mov    %ecx,0x10(%esp)

          process_precision:
            if (width < 0)
  102df6:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  102dfb:	78 07                	js     102e04 <.L38+0x21>
                width = precision, precision = -1;
            goto reswitch;
  102dfd:	89 eb                	mov    %ebp,%ebx
  102dff:	e9 4c ff ff ff       	jmp    102d50 <vprintfmt+0x69>
                width = precision, precision = -1;
  102e04:	8b 44 24 10          	mov    0x10(%esp),%eax
  102e08:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e0c:	c7 44 24 10 ff ff ff 	movl   $0xffffffff,0x10(%esp)
  102e13:	ff 
  102e14:	eb e7                	jmp    102dfd <.L38+0x1a>

00102e16 <.L31>:

        // long flag (doubled for long long)
        case 'l':
            lflag++;
  102e16:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
        switch (ch = *(unsigned char *) fmt++) {
  102e1b:	89 eb                	mov    %ebp,%ebx
            goto reswitch;
  102e1d:	e9 2e ff ff ff       	jmp    102d50 <vprintfmt+0x69>

00102e22 <.L33>:

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102e22:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102e26:	8d 50 04             	lea    0x4(%eax),%edx
  102e29:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  102e2d:	83 ec 08             	sub    $0x8,%esp
  102e30:	57                   	push   %edi
  102e31:	ff 30                	push   (%eax)
  102e33:	ff d6                	call   *%esi
            break;
  102e35:	83 c4 10             	add    $0x10,%esp
  102e38:	e9 cb fe ff ff       	jmp    102d08 <vprintfmt+0x21>

00102e3d <.L29>:

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL)
  102e3d:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102e41:	8d 50 04             	lea    0x4(%eax),%edx
  102e44:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  102e48:	8b 00                	mov    (%eax),%eax
  102e4a:	89 04 24             	mov    %eax,(%esp)
  102e4d:	85 c0                	test   %eax,%eax
  102e4f:	74 29                	je     102e7a <.L29+0x3d>
                p = "(null)";
            if (width > 0 && padc != '-')
  102e51:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  102e56:	0f 9f c2             	setg   %dl
  102e59:	80 7c 24 1b 2d       	cmpb   $0x2d,0x1b(%esp)
  102e5e:	0f 95 c0             	setne  %al
  102e61:	84 c2                	test   %al,%dl
  102e63:	75 24                	jne    102e89 <.L29+0x4c>
  102e65:	8b 04 24             	mov    (%esp),%eax
  102e68:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  102e6c:	89 74 24 40          	mov    %esi,0x40(%esp)
  102e70:	8b 74 24 0c          	mov    0xc(%esp),%esi
  102e74:	89 6c 24 48          	mov    %ebp,0x48(%esp)
  102e78:	eb 6e                	jmp    102ee8 <.L29+0xab>
                p = "(null)";
  102e7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  102e7e:	8d 80 d4 91 ff ff    	lea    -0x6e2c(%eax),%eax
  102e84:	89 04 24             	mov    %eax,(%esp)
  102e87:	eb c8                	jmp    102e51 <.L29+0x14>
                for (width -= strnlen(p, precision); width > 0; width--)
  102e89:	83 ec 08             	sub    $0x8,%esp
  102e8c:	ff 74 24 18          	push   0x18(%esp)
  102e90:	ff 74 24 0c          	push   0xc(%esp)
  102e94:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  102e98:	e8 2a fa ff ff       	call   1028c7 <strnlen>
  102e9d:	29 44 24 1c          	sub    %eax,0x1c(%esp)
  102ea1:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  102ea5:	83 c4 10             	add    $0x10,%esp
  102ea8:	89 d3                	mov    %edx,%ebx
  102eaa:	eb 12                	jmp    102ebe <.L29+0x81>
                    putch(padc, putdat);
  102eac:	83 ec 08             	sub    $0x8,%esp
  102eaf:	57                   	push   %edi
  102eb0:	0f be 44 24 27       	movsbl 0x27(%esp),%eax
  102eb5:	50                   	push   %eax
  102eb6:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
  102eb8:	83 eb 01             	sub    $0x1,%ebx
  102ebb:	83 c4 10             	add    $0x10,%esp
  102ebe:	85 db                	test   %ebx,%ebx
  102ec0:	7f ea                	jg     102eac <.L29+0x6f>
  102ec2:	89 da                	mov    %ebx,%edx
  102ec4:	8b 04 24             	mov    (%esp),%eax
  102ec7:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  102ecb:	89 74 24 40          	mov    %esi,0x40(%esp)
  102ecf:	89 d6                	mov    %edx,%esi
  102ed1:	89 6c 24 48          	mov    %ebp,0x48(%esp)
  102ed5:	eb 11                	jmp    102ee8 <.L29+0xab>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
                 width--)
                if (altflag && (ch < ' ' || ch > '~'))
                    putch('?', putdat);
                else
                    putch(ch, putdat);
  102ed7:	83 ec 08             	sub    $0x8,%esp
  102eda:	57                   	push   %edi
  102edb:	52                   	push   %edx
  102edc:	ff 54 24 50          	call   *0x50(%esp)
  102ee0:	83 c4 10             	add    $0x10,%esp
                 width--)
  102ee3:	83 ee 01             	sub    $0x1,%esi
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  102ee6:	89 e8                	mov    %ebp,%eax
  102ee8:	8d 68 01             	lea    0x1(%eax),%ebp
  102eeb:	0f b6 00             	movzbl (%eax),%eax
  102eee:	0f be d0             	movsbl %al,%edx
  102ef1:	85 d2                	test   %edx,%edx
  102ef3:	74 4d                	je     102f42 <.L29+0x105>
  102ef5:	85 db                	test   %ebx,%ebx
  102ef7:	78 05                	js     102efe <.L29+0xc1>
  102ef9:	83 eb 01             	sub    $0x1,%ebx
  102efc:	78 21                	js     102f1f <.L29+0xe2>
                if (altflag && (ch < ' ' || ch > '~'))
  102efe:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  102f03:	74 d2                	je     102ed7 <.L29+0x9a>
  102f05:	0f be c0             	movsbl %al,%eax
  102f08:	83 e8 20             	sub    $0x20,%eax
  102f0b:	83 f8 5e             	cmp    $0x5e,%eax
  102f0e:	76 c7                	jbe    102ed7 <.L29+0x9a>
                    putch('?', putdat);
  102f10:	83 ec 08             	sub    $0x8,%esp
  102f13:	57                   	push   %edi
  102f14:	6a 3f                	push   $0x3f
  102f16:	ff 54 24 50          	call   *0x50(%esp)
  102f1a:	83 c4 10             	add    $0x10,%esp
  102f1d:	eb c4                	jmp    102ee3 <.L29+0xa6>
  102f1f:	89 f3                	mov    %esi,%ebx
  102f21:	8b 74 24 40          	mov    0x40(%esp),%esi
  102f25:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  102f29:	eb 0e                	jmp    102f39 <.L29+0xfc>
            for (; width > 0; width--)
                putch(' ', putdat);
  102f2b:	83 ec 08             	sub    $0x8,%esp
  102f2e:	57                   	push   %edi
  102f2f:	6a 20                	push   $0x20
  102f31:	ff d6                	call   *%esi
            for (; width > 0; width--)
  102f33:	83 eb 01             	sub    $0x1,%ebx
  102f36:	83 c4 10             	add    $0x10,%esp
  102f39:	85 db                	test   %ebx,%ebx
  102f3b:	7f ee                	jg     102f2b <.L29+0xee>
  102f3d:	e9 c6 fd ff ff       	jmp    102d08 <vprintfmt+0x21>
  102f42:	89 f3                	mov    %esi,%ebx
  102f44:	8b 74 24 40          	mov    0x40(%esp),%esi
  102f48:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  102f4c:	eb eb                	jmp    102f39 <.L29+0xfc>

00102f4e <.L32>:
            break;

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f4e:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  102f52:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  102f56:	89 ca                	mov    %ecx,%edx
  102f58:	e8 5e fd ff ff       	call   102cbb <getint>
            if ((long long) num < 0) {
  102f5d:	89 04 24             	mov    %eax,(%esp)
  102f60:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f64:	83 7c 24 04 00       	cmpl   $0x0,0x4(%esp)
  102f69:	78 07                	js     102f72 <.L32+0x24>
                putch('-', putdat);
                num = -(long long) num;
            }
            base = 10;
  102f6b:	bb 0a 00 00 00       	mov    $0xa,%ebx
            goto number;
  102f70:	eb 5c                	jmp    102fce <.L30+0x2a>
                putch('-', putdat);
  102f72:	83 ec 08             	sub    $0x8,%esp
  102f75:	57                   	push   %edi
  102f76:	6a 2d                	push   $0x2d
  102f78:	ff d6                	call   *%esi
                num = -(long long) num;
  102f7a:	8b 44 24 10          	mov    0x10(%esp),%eax
  102f7e:	8b 54 24 14          	mov    0x14(%esp),%edx
  102f82:	f7 d8                	neg    %eax
  102f84:	83 d2 00             	adc    $0x0,%edx
  102f87:	f7 da                	neg    %edx
  102f89:	83 c4 10             	add    $0x10,%esp
  102f8c:	eb dd                	jmp    102f6b <.L32+0x1d>

00102f8e <.L28>:

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f8e:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  102f92:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  102f96:	89 ca                	mov    %ecx,%edx
  102f98:	e8 ea fc ff ff       	call   102c87 <getuint>
            base = 10;
  102f9d:	bb 0a 00 00 00       	mov    $0xa,%ebx
            goto number;
  102fa2:	eb 2a                	jmp    102fce <.L30+0x2a>

00102fa4 <.L30>:
        case 'o':
            // TODO

        // pointer
        case 'p':
            putch('0', putdat);
  102fa4:	83 ec 08             	sub    $0x8,%esp
  102fa7:	57                   	push   %edi
  102fa8:	6a 30                	push   $0x30
  102faa:	ff d6                	call   *%esi
            putch('x', putdat);
  102fac:	83 c4 08             	add    $0x8,%esp
  102faf:	57                   	push   %edi
  102fb0:	6a 78                	push   $0x78
  102fb2:	ff d6                	call   *%esi
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  102fb4:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  102fb8:	8d 50 04             	lea    0x4(%eax),%edx
  102fbb:	89 54 24 5c          	mov    %edx,0x5c(%esp)
  102fbf:	8b 00                	mov    (%eax),%eax
  102fc1:	ba 00 00 00 00       	mov    $0x0,%edx
            base = 16;
            goto number;
  102fc6:	83 c4 10             	add    $0x10,%esp
            base = 16;
  102fc9:	bb 10 00 00 00       	mov    $0x10,%ebx
        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
            base = 16;
          number:
            printnum(putch, putdat, num, base, width, padc);
  102fce:	83 ec 0c             	sub    $0xc,%esp
  102fd1:	0f be 4c 24 27       	movsbl 0x27(%esp),%ecx
  102fd6:	51                   	push   %ecx
  102fd7:	ff 74 24 1c          	push   0x1c(%esp)
  102fdb:	53                   	push   %ebx
  102fdc:	52                   	push   %edx
  102fdd:	50                   	push   %eax
  102fde:	89 fa                	mov    %edi,%edx
  102fe0:	89 f0                	mov    %esi,%eax
  102fe2:	e8 d9 fb ff ff       	call   102bc0 <printnum>
            break;
  102fe7:	83 c4 20             	add    $0x20,%esp
  102fea:	e9 19 fd ff ff       	jmp    102d08 <vprintfmt+0x21>

00102fef <.L26>:
            num = getuint(&ap, lflag);
  102fef:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  102ff3:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  102ff7:	89 ca                	mov    %ecx,%edx
  102ff9:	e8 89 fc ff ff       	call   102c87 <getuint>
            base = 16;
  102ffe:	bb 10 00 00 00       	mov    $0x10,%ebx
  103003:	eb c9                	jmp    102fce <.L30+0x2a>

00103005 <.L37>:

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103005:	8b 14 24             	mov    (%esp),%edx
  103008:	83 ec 08             	sub    $0x8,%esp
  10300b:	57                   	push   %edi
  10300c:	52                   	push   %edx
  10300d:	ff d6                	call   *%esi
            break;
  10300f:	83 c4 10             	add    $0x10,%esp
  103012:	e9 f1 fc ff ff       	jmp    102d08 <vprintfmt+0x21>

00103017 <.L25>:

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103017:	83 ec 08             	sub    $0x8,%esp
  10301a:	57                   	push   %edi
  10301b:	6a 25                	push   $0x25
  10301d:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
  10301f:	83 c4 10             	add    $0x10,%esp
  103022:	89 dd                	mov    %ebx,%ebp
  103024:	eb 0d                	jmp    103033 <.L25+0x1c>
  103026:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10302d:	00 
  10302e:	66 90                	xchg   %ax,%ax
  103030:	83 ed 01             	sub    $0x1,%ebp
  103033:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
  103037:	75 f7                	jne    103030 <.L25+0x19>
  103039:	e9 ca fc ff ff       	jmp    102d08 <vprintfmt+0x21>
                /* do nothing */ ;
            break;
        }
    }
}
  10303e:	83 c4 2c             	add    $0x2c,%esp
  103041:	5b                   	pop    %ebx
  103042:	5e                   	pop    %esi
  103043:	5f                   	pop    %edi
  103044:	5d                   	pop    %ebp
  103045:	c3                   	ret

00103046 <tss_switch>:

segdesc_t gdt_LOC[CPU_GDT_NDESC];
tss_t tss_LOC[64];

void tss_switch(uint32_t pid)
{
  103046:	57                   	push   %edi
  103047:	56                   	push   %esi
  103048:	53                   	push   %ebx
  103049:	e8 ef d2 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10304e:	81 c3 a6 bf 00 00    	add    $0xbfa6,%ebx
    gdt_LOC[CPU_GDT_TSS >> 3] =
        SEGDESC16(STS_T32A, (uint32_t) (&tss_LOC[pid]), sizeof(tss_t) - 1, 0);
  103054:	69 44 24 10 ec 00 00 	imul   $0xec,0x10(%esp),%eax
  10305b:	00 
  10305c:	8d 84 03 0c b0 02 00 	lea    0x2b00c(%ebx,%eax,1),%eax
  103063:	89 c2                	mov    %eax,%edx
  103065:	c1 ea 10             	shr    $0x10,%edx
  103068:	89 c1                	mov    %eax,%ecx
  10306a:	c1 e9 18             	shr    $0x18,%ecx
  10306d:	89 cf                	mov    %ecx,%edi
    gdt_LOC[CPU_GDT_TSS >> 3] =
  10306f:	66 c7 83 34 eb 02 00 	movw   $0xeb,0x2eb34(%ebx)
  103076:	eb 00 
  103078:	66 89 83 36 eb 02 00 	mov    %ax,0x2eb36(%ebx)
  10307f:	88 93 38 eb 02 00    	mov    %dl,0x2eb38(%ebx)
  103085:	0f b6 83 39 eb 02 00 	movzbl 0x2eb39(%ebx),%eax
  10308c:	83 e0 f0             	and    $0xfffffff0,%eax
  10308f:	89 c2                	mov    %eax,%edx
  103091:	83 ca 09             	or     $0x9,%edx
  103094:	88 93 39 eb 02 00    	mov    %dl,0x2eb39(%ebx)
  10309a:	83 c8 19             	or     $0x19,%eax
  10309d:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
  1030a3:	83 e0 9f             	and    $0xffffff9f,%eax
  1030a6:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
  1030ac:	83 c8 80             	or     $0xffffff80,%eax
  1030af:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
  1030b5:	0f b6 93 3a eb 02 00 	movzbl 0x2eb3a(%ebx),%edx
  1030bc:	89 d6                	mov    %edx,%esi
  1030be:	83 e6 f0             	and    $0xfffffff0,%esi
  1030c1:	89 f1                	mov    %esi,%ecx
  1030c3:	88 8b 3a eb 02 00    	mov    %cl,0x2eb3a(%ebx)
  1030c9:	89 d6                	mov    %edx,%esi
  1030cb:	83 e6 e0             	and    $0xffffffe0,%esi
  1030ce:	89 f1                	mov    %esi,%ecx
  1030d0:	88 8b 3a eb 02 00    	mov    %cl,0x2eb3a(%ebx)
  1030d6:	83 e2 c0             	and    $0xffffffc0,%edx
  1030d9:	88 93 3a eb 02 00    	mov    %dl,0x2eb3a(%ebx)
  1030df:	83 ca 40             	or     $0x40,%edx
  1030e2:	88 93 3a eb 02 00    	mov    %dl,0x2eb3a(%ebx)
  1030e8:	83 e2 7f             	and    $0x7f,%edx
  1030eb:	88 93 3a eb 02 00    	mov    %dl,0x2eb3a(%ebx)
  1030f1:	89 f9                	mov    %edi,%ecx
  1030f3:	88 8b 3b eb 02 00    	mov    %cl,0x2eb3b(%ebx)
    gdt_LOC[CPU_GDT_TSS >> 3].sd_s = 0;
  1030f9:	83 e0 ef             	and    $0xffffffef,%eax
  1030fc:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
    ltr(CPU_GDT_TSS);
  103102:	83 ec 0c             	sub    $0xc,%esp
  103105:	6a 28                	push   $0x28
  103107:	e8 d2 04 00 00       	call   1035de <ltr>
}
  10310c:	83 c4 10             	add    $0x10,%esp
  10310f:	5b                   	pop    %ebx
  103110:	5e                   	pop    %esi
  103111:	5f                   	pop    %edi
  103112:	c3                   	ret

00103113 <seg_init>:

void seg_init(void)
{
  103113:	57                   	push   %edi
  103114:	56                   	push   %esi
  103115:	53                   	push   %ebx
  103116:	83 ec 18             	sub    $0x18,%esp
  103119:	e8 1f d2 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10311e:	81 c3 d6 be 00 00    	add    $0xbed6,%ebx
    /* clear BSS */
    extern uint8_t end[], edata[];
    memzero(edata, bsp_kstack - edata);
  103124:	8d b3 0c f0 06 00    	lea    0x6f00c(%ebx),%esi
  10312a:	c7 c0 14 78 13 00    	mov    $0x137814,%eax
  103130:	89 f2                	mov    %esi,%edx
  103132:	29 c2                	sub    %eax,%edx
  103134:	52                   	push   %edx
  103135:	50                   	push   %eax
  103136:	e8 0a f8 ff ff       	call   102945 <memzero>
    memzero(bsp_kstack + 4096, end - bsp_kstack - 4096);
  10313b:	c7 c0 20 1c e0 00    	mov    $0xe01c20,%eax
  103141:	29 f0                	sub    %esi,%eax
  103143:	2d 00 10 00 00       	sub    $0x1000,%eax
  103148:	83 c4 08             	add    $0x8,%esp
  10314b:	50                   	push   %eax
  10314c:	8d b6 00 10 00 00    	lea    0x1000(%esi),%esi
  103152:	56                   	push   %esi
  103153:	e8 ed f7 ff ff       	call   102945 <memzero>

    /* setup GDT */
    gdt_LOC[0] = SEGDESC_NULL;
  103158:	c7 83 0c eb 02 00 00 	movl   $0x0,0x2eb0c(%ebx)
  10315f:	00 00 00 
  103162:	c7 83 10 eb 02 00 00 	movl   $0x0,0x2eb10(%ebx)
  103169:	00 00 00 
    /* 0x08: kernel code */
    gdt_LOC[CPU_GDT_KCODE >> 3] =
  10316c:	66 c7 83 14 eb 02 00 	movw   $0xffff,0x2eb14(%ebx)
  103173:	ff ff 
  103175:	66 c7 83 16 eb 02 00 	movw   $0x0,0x2eb16(%ebx)
  10317c:	00 00 
  10317e:	c6 83 18 eb 02 00 00 	movb   $0x0,0x2eb18(%ebx)
  103185:	0f b6 83 19 eb 02 00 	movzbl 0x2eb19(%ebx),%eax
  10318c:	83 e0 f0             	and    $0xfffffff0,%eax
  10318f:	89 c2                	mov    %eax,%edx
  103191:	83 ca 0a             	or     $0xa,%edx
  103194:	88 93 19 eb 02 00    	mov    %dl,0x2eb19(%ebx)
  10319a:	83 c8 1a             	or     $0x1a,%eax
  10319d:	88 83 19 eb 02 00    	mov    %al,0x2eb19(%ebx)
  1031a3:	83 e0 9f             	and    $0xffffff9f,%eax
  1031a6:	88 83 19 eb 02 00    	mov    %al,0x2eb19(%ebx)
  1031ac:	83 c8 80             	or     $0xffffff80,%eax
  1031af:	88 83 19 eb 02 00    	mov    %al,0x2eb19(%ebx)
  1031b5:	0f b6 83 1a eb 02 00 	movzbl 0x2eb1a(%ebx),%eax
  1031bc:	83 c8 0f             	or     $0xf,%eax
  1031bf:	88 83 1a eb 02 00    	mov    %al,0x2eb1a(%ebx)
  1031c5:	89 c2                	mov    %eax,%edx
  1031c7:	83 e2 ef             	and    $0xffffffef,%edx
  1031ca:	88 93 1a eb 02 00    	mov    %dl,0x2eb1a(%ebx)
  1031d0:	83 e0 cf             	and    $0xffffffcf,%eax
  1031d3:	88 83 1a eb 02 00    	mov    %al,0x2eb1a(%ebx)
  1031d9:	89 c2                	mov    %eax,%edx
  1031db:	83 ca 40             	or     $0x40,%edx
  1031de:	88 93 1a eb 02 00    	mov    %dl,0x2eb1a(%ebx)
  1031e4:	83 c8 c0             	or     $0xffffffc0,%eax
  1031e7:	88 83 1a eb 02 00    	mov    %al,0x2eb1a(%ebx)
  1031ed:	c6 83 1b eb 02 00 00 	movb   $0x0,0x2eb1b(%ebx)
        SEGDESC32(STA_X | STA_R, 0x0, 0xffffffff, 0);
    /* 0x10: kernel data */
    gdt_LOC[CPU_GDT_KDATA >> 3] = SEGDESC32(STA_W, 0x0, 0xffffffff, 0);
  1031f4:	66 c7 83 1c eb 02 00 	movw   $0xffff,0x2eb1c(%ebx)
  1031fb:	ff ff 
  1031fd:	66 c7 83 1e eb 02 00 	movw   $0x0,0x2eb1e(%ebx)
  103204:	00 00 
  103206:	c6 83 20 eb 02 00 00 	movb   $0x0,0x2eb20(%ebx)
  10320d:	0f b6 83 21 eb 02 00 	movzbl 0x2eb21(%ebx),%eax
  103214:	83 e0 f0             	and    $0xfffffff0,%eax
  103217:	89 c2                	mov    %eax,%edx
  103219:	83 ca 02             	or     $0x2,%edx
  10321c:	88 93 21 eb 02 00    	mov    %dl,0x2eb21(%ebx)
  103222:	83 c8 12             	or     $0x12,%eax
  103225:	88 83 21 eb 02 00    	mov    %al,0x2eb21(%ebx)
  10322b:	83 e0 9f             	and    $0xffffff9f,%eax
  10322e:	88 83 21 eb 02 00    	mov    %al,0x2eb21(%ebx)
  103234:	83 c8 80             	or     $0xffffff80,%eax
  103237:	88 83 21 eb 02 00    	mov    %al,0x2eb21(%ebx)
  10323d:	0f b6 83 22 eb 02 00 	movzbl 0x2eb22(%ebx),%eax
  103244:	83 c8 0f             	or     $0xf,%eax
  103247:	88 83 22 eb 02 00    	mov    %al,0x2eb22(%ebx)
  10324d:	89 c2                	mov    %eax,%edx
  10324f:	83 e2 ef             	and    $0xffffffef,%edx
  103252:	88 93 22 eb 02 00    	mov    %dl,0x2eb22(%ebx)
  103258:	83 e0 cf             	and    $0xffffffcf,%eax
  10325b:	88 83 22 eb 02 00    	mov    %al,0x2eb22(%ebx)
  103261:	89 c2                	mov    %eax,%edx
  103263:	83 ca 40             	or     $0x40,%edx
  103266:	88 93 22 eb 02 00    	mov    %dl,0x2eb22(%ebx)
  10326c:	83 c8 c0             	or     $0xffffffc0,%eax
  10326f:	88 83 22 eb 02 00    	mov    %al,0x2eb22(%ebx)
  103275:	c6 83 23 eb 02 00 00 	movb   $0x0,0x2eb23(%ebx)
    /* 0x18: user code */
    gdt_LOC[CPU_GDT_UCODE >> 3] =
  10327c:	66 c7 83 24 eb 02 00 	movw   $0xffff,0x2eb24(%ebx)
  103283:	ff ff 
  103285:	66 c7 83 26 eb 02 00 	movw   $0x0,0x2eb26(%ebx)
  10328c:	00 00 
  10328e:	c6 83 28 eb 02 00 00 	movb   $0x0,0x2eb28(%ebx)
  103295:	0f b6 83 29 eb 02 00 	movzbl 0x2eb29(%ebx),%eax
  10329c:	83 e0 f0             	and    $0xfffffff0,%eax
  10329f:	89 c2                	mov    %eax,%edx
  1032a1:	83 ca 0a             	or     $0xa,%edx
  1032a4:	88 93 29 eb 02 00    	mov    %dl,0x2eb29(%ebx)
  1032aa:	89 c2                	mov    %eax,%edx
  1032ac:	83 ca 1a             	or     $0x1a,%edx
  1032af:	88 93 29 eb 02 00    	mov    %dl,0x2eb29(%ebx)
  1032b5:	83 c8 7a             	or     $0x7a,%eax
  1032b8:	88 83 29 eb 02 00    	mov    %al,0x2eb29(%ebx)
  1032be:	c6 83 29 eb 02 00 fa 	movb   $0xfa,0x2eb29(%ebx)
  1032c5:	0f b6 83 2a eb 02 00 	movzbl 0x2eb2a(%ebx),%eax
  1032cc:	83 c8 0f             	or     $0xf,%eax
  1032cf:	88 83 2a eb 02 00    	mov    %al,0x2eb2a(%ebx)
  1032d5:	89 c2                	mov    %eax,%edx
  1032d7:	83 e2 ef             	and    $0xffffffef,%edx
  1032da:	88 93 2a eb 02 00    	mov    %dl,0x2eb2a(%ebx)
  1032e0:	83 e0 cf             	and    $0xffffffcf,%eax
  1032e3:	88 83 2a eb 02 00    	mov    %al,0x2eb2a(%ebx)
  1032e9:	89 c2                	mov    %eax,%edx
  1032eb:	83 ca 40             	or     $0x40,%edx
  1032ee:	88 93 2a eb 02 00    	mov    %dl,0x2eb2a(%ebx)
  1032f4:	83 c8 c0             	or     $0xffffffc0,%eax
  1032f7:	88 83 2a eb 02 00    	mov    %al,0x2eb2a(%ebx)
  1032fd:	c6 83 2b eb 02 00 00 	movb   $0x0,0x2eb2b(%ebx)
        SEGDESC32(STA_X | STA_R, 0x00000000, 0xffffffff, 3);
    /* 0x20: user data */
    gdt_LOC[CPU_GDT_UDATA >> 3] =
  103304:	66 c7 83 2c eb 02 00 	movw   $0xffff,0x2eb2c(%ebx)
  10330b:	ff ff 
  10330d:	66 c7 83 2e eb 02 00 	movw   $0x0,0x2eb2e(%ebx)
  103314:	00 00 
  103316:	c6 83 30 eb 02 00 00 	movb   $0x0,0x2eb30(%ebx)
  10331d:	0f b6 83 31 eb 02 00 	movzbl 0x2eb31(%ebx),%eax
  103324:	83 e0 f0             	and    $0xfffffff0,%eax
  103327:	89 c2                	mov    %eax,%edx
  103329:	83 ca 02             	or     $0x2,%edx
  10332c:	88 93 31 eb 02 00    	mov    %dl,0x2eb31(%ebx)
  103332:	89 c2                	mov    %eax,%edx
  103334:	83 ca 12             	or     $0x12,%edx
  103337:	88 93 31 eb 02 00    	mov    %dl,0x2eb31(%ebx)
  10333d:	83 c8 72             	or     $0x72,%eax
  103340:	88 83 31 eb 02 00    	mov    %al,0x2eb31(%ebx)
  103346:	c6 83 31 eb 02 00 f2 	movb   $0xf2,0x2eb31(%ebx)
  10334d:	0f b6 83 32 eb 02 00 	movzbl 0x2eb32(%ebx),%eax
  103354:	83 c8 0f             	or     $0xf,%eax
  103357:	88 83 32 eb 02 00    	mov    %al,0x2eb32(%ebx)
  10335d:	89 c2                	mov    %eax,%edx
  10335f:	83 e2 ef             	and    $0xffffffef,%edx
  103362:	88 93 32 eb 02 00    	mov    %dl,0x2eb32(%ebx)
  103368:	83 e0 cf             	and    $0xffffffcf,%eax
  10336b:	88 83 32 eb 02 00    	mov    %al,0x2eb32(%ebx)
  103371:	89 c2                	mov    %eax,%edx
  103373:	83 ca 40             	or     $0x40,%edx
  103376:	88 93 32 eb 02 00    	mov    %dl,0x2eb32(%ebx)
  10337c:	83 c8 c0             	or     $0xffffffc0,%eax
  10337f:	88 83 32 eb 02 00    	mov    %al,0x2eb32(%ebx)
  103385:	c6 83 33 eb 02 00 00 	movb   $0x0,0x2eb33(%ebx)
        SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);

    /* setup TSS */
    tss0.ts_esp0 = (uint32_t) bsp_kstack + 4096;
  10338c:	89 b3 10 00 07 00    	mov    %esi,0x70010(%ebx)
    tss0.ts_ss0 = CPU_GDT_KDATA;
  103392:	66 c7 83 14 00 07 00 	movw   $0x10,0x70014(%ebx)
  103399:	10 00 
    gdt_LOC[CPU_GDT_TSS >> 3] =
  10339b:	66 c7 83 34 eb 02 00 	movw   $0xeb,0x2eb34(%ebx)
  1033a2:	eb 00 
  1033a4:	8d 8b 0c 00 07 00    	lea    0x7000c(%ebx),%ecx
  1033aa:	66 89 8b 36 eb 02 00 	mov    %cx,0x2eb36(%ebx)
        SEGDESC16(STS_T32A, (uint32_t) (&tss0), sizeof(tss_t) - 1, 0);
  1033b1:	89 c8                	mov    %ecx,%eax
  1033b3:	c1 e8 10             	shr    $0x10,%eax
    gdt_LOC[CPU_GDT_TSS >> 3] =
  1033b6:	88 83 38 eb 02 00    	mov    %al,0x2eb38(%ebx)
  1033bc:	0f b6 83 39 eb 02 00 	movzbl 0x2eb39(%ebx),%eax
  1033c3:	83 e0 f0             	and    $0xfffffff0,%eax
  1033c6:	89 c2                	mov    %eax,%edx
  1033c8:	83 ca 09             	or     $0x9,%edx
  1033cb:	88 93 39 eb 02 00    	mov    %dl,0x2eb39(%ebx)
  1033d1:	83 c8 19             	or     $0x19,%eax
  1033d4:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
  1033da:	83 e0 9f             	and    $0xffffff9f,%eax
  1033dd:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
  1033e3:	83 c8 80             	or     $0xffffff80,%eax
  1033e6:	89 c7                	mov    %eax,%edi
  1033e8:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)
  1033ee:	0f b6 93 3a eb 02 00 	movzbl 0x2eb3a(%ebx),%edx
  1033f5:	89 d6                	mov    %edx,%esi
  1033f7:	83 e6 f0             	and    $0xfffffff0,%esi
  1033fa:	89 f0                	mov    %esi,%eax
  1033fc:	88 83 3a eb 02 00    	mov    %al,0x2eb3a(%ebx)
  103402:	89 d6                	mov    %edx,%esi
  103404:	83 e6 e0             	and    $0xffffffe0,%esi
  103407:	89 f0                	mov    %esi,%eax
  103409:	88 83 3a eb 02 00    	mov    %al,0x2eb3a(%ebx)
  10340f:	83 e2 c0             	and    $0xffffffc0,%edx
  103412:	88 93 3a eb 02 00    	mov    %dl,0x2eb3a(%ebx)
  103418:	83 ca 40             	or     $0x40,%edx
  10341b:	88 93 3a eb 02 00    	mov    %dl,0x2eb3a(%ebx)
  103421:	83 e2 7f             	and    $0x7f,%edx
  103424:	88 93 3a eb 02 00    	mov    %dl,0x2eb3a(%ebx)
        SEGDESC16(STS_T32A, (uint32_t) (&tss0), sizeof(tss_t) - 1, 0);
  10342a:	c1 e9 18             	shr    $0x18,%ecx
    gdt_LOC[CPU_GDT_TSS >> 3] =
  10342d:	88 8b 3b eb 02 00    	mov    %cl,0x2eb3b(%ebx)
    gdt_LOC[CPU_GDT_TSS >> 3].sd_s = 0;
  103433:	89 f8                	mov    %edi,%eax
  103435:	83 e0 ef             	and    $0xffffffef,%eax
  103438:	88 83 39 eb 02 00    	mov    %al,0x2eb39(%ebx)

    pseudodesc_t gdt_desc = {
  10343e:	66 c7 44 24 1a 2f 00 	movw   $0x2f,0x1a(%esp)
        .pd_lim = sizeof(gdt_LOC) - 1,
        .pd_base = (uint32_t) gdt_LOC
  103445:	8d 83 0c eb 02 00    	lea    0x2eb0c(%ebx),%eax
    pseudodesc_t gdt_desc = {
  10344b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    };
    asm volatile ("lgdt %0" :: "m" (gdt_desc));
  10344f:	0f 01 54 24 1a       	lgdtl  0x1a(%esp)
    asm volatile ("movw %%ax,%%gs" :: "a" (CPU_GDT_KDATA));
  103454:	b8 10 00 00 00       	mov    $0x10,%eax
  103459:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax,%%fs" :: "a" (CPU_GDT_KDATA));
  10345b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax,%%es" :: "a" (CPU_GDT_KDATA));
  10345d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax,%%ds" :: "a" (CPU_GDT_KDATA));
  10345f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax,%%ss" :: "a" (CPU_GDT_KDATA));
  103461:	8e d0                	mov    %eax,%ss
    /* reload %cs */
    asm volatile ("ljmp %0,$1f\n 1:\n" :: "i" (CPU_GDT_KCODE));
  103463:	ea 6a 34 10 00 08 00 	ljmp   $0x8,$0x10346a

    /*
     * Load a null LDT.
     */
    lldt(0);
  10346a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103471:	e8 dc 00 00 00       	call   103552 <lldt>

    /*
     * Load the bootstrap TSS.
     */
    ltr(CPU_GDT_TSS);
  103476:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
  10347d:	e8 5c 01 00 00       	call   1035de <ltr>

    /*
     * Initialize all TSS structures for processes.
     */
    unsigned int pid;
    memzero(tss_LOC, sizeof(tss_t) * 64);
  103482:	83 c4 08             	add    $0x8,%esp
  103485:	68 00 3b 00 00       	push   $0x3b00
  10348a:	8d 83 0c b0 02 00    	lea    0x2b00c(%ebx),%eax
  103490:	50                   	push   %eax
  103491:	e8 af f4 ff ff       	call   102945 <memzero>
    memzero(STACK_LOC, sizeof(char) * 64 * 4096);
  103496:	83 c4 08             	add    $0x8,%esp
  103499:	68 00 00 04 00       	push   $0x40000
  10349e:	8d 83 0c f0 02 00    	lea    0x2f00c(%ebx),%eax
  1034a4:	50                   	push   %eax
  1034a5:	e8 9b f4 ff ff       	call   102945 <memzero>
    for (pid = 0; pid < 64; pid++) {
  1034aa:	83 c4 10             	add    $0x10,%esp
  1034ad:	be 00 00 00 00       	mov    $0x0,%esi
  1034b2:	eb 4a                	jmp    1034fe <seg_init+0x3eb>
        tss_LOC[pid].ts_esp0 = (uint32_t) STACK_LOC[pid] + 4096;
  1034b4:	89 f0                	mov    %esi,%eax
  1034b6:	c1 e0 0c             	shl    $0xc,%eax
  1034b9:	8d 94 03 0c 00 03 00 	lea    0x3000c(%ebx,%eax,1),%edx
  1034c0:	69 c6 ec 00 00 00    	imul   $0xec,%esi,%eax
  1034c6:	8d bc 03 0c b0 02 00 	lea    0x2b00c(%ebx,%eax,1),%edi
  1034cd:	89 57 04             	mov    %edx,0x4(%edi)
        tss_LOC[pid].ts_ss0 = CPU_GDT_KDATA;
  1034d0:	66 c7 47 08 10 00    	movw   $0x10,0x8(%edi)
        tss_LOC[pid].ts_iomb = offsetof(tss_t, ts_iopm);
  1034d6:	66 c7 47 66 68 00    	movw   $0x68,0x66(%edi)
        memzero(tss_LOC[pid].ts_iopm, sizeof(uint8_t) * 128);
  1034dc:	8d 84 03 74 b0 02 00 	lea    0x2b074(%ebx,%eax,1),%eax
  1034e3:	83 ec 08             	sub    $0x8,%esp
  1034e6:	68 80 00 00 00       	push   $0x80
  1034eb:	50                   	push   %eax
  1034ec:	e8 54 f4 ff ff       	call   102945 <memzero>
        tss_LOC[pid].ts_iopm[128] = 0xff;
  1034f1:	c6 87 e8 00 00 00 ff 	movb   $0xff,0xe8(%edi)
    for (pid = 0; pid < 64; pid++) {
  1034f8:	83 c6 01             	add    $0x1,%esi
  1034fb:	83 c4 10             	add    $0x10,%esp
  1034fe:	83 fe 3f             	cmp    $0x3f,%esi
  103501:	76 b1                	jbe    1034b4 <seg_init+0x3a1>
    }
}
  103503:	83 c4 10             	add    $0x10,%esp
  103506:	5b                   	pop    %ebx
  103507:	5e                   	pop    %esi
  103508:	5f                   	pop    %edi
  103509:	c3                   	ret

0010350a <max>:
#include "types.h"

uint32_t max(uint32_t a, uint32_t b)
{
  10350a:	8b 44 24 08          	mov    0x8(%esp),%eax
    return (a > b) ? a : b;
  10350e:	8b 54 24 04          	mov    0x4(%esp),%edx
  103512:	39 d0                	cmp    %edx,%eax
  103514:	0f 42 c2             	cmovb  %edx,%eax
}
  103517:	c3                   	ret

00103518 <min>:

uint32_t min(uint32_t a, uint32_t b)
{
  103518:	8b 44 24 08          	mov    0x8(%esp),%eax
    return (a < b) ? a : b;
  10351c:	8b 54 24 04          	mov    0x4(%esp),%edx
  103520:	39 d0                	cmp    %edx,%eax
  103522:	0f 47 c2             	cmova  %edx,%eax
}
  103525:	c3                   	ret

00103526 <rounddown>:

uint32_t rounddown(uint32_t a, uint32_t n)
{
  103526:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    return a - a % n;
  10352a:	89 c8                	mov    %ecx,%eax
  10352c:	ba 00 00 00 00       	mov    $0x0,%edx
  103531:	f7 74 24 08          	divl   0x8(%esp)
  103535:	89 c8                	mov    %ecx,%eax
  103537:	29 d0                	sub    %edx,%eax
}
  103539:	c3                   	ret

0010353a <roundup>:

uint32_t roundup(uint32_t a, uint32_t n)
{
  10353a:	8b 54 24 08          	mov    0x8(%esp),%edx
    return rounddown(a + n - 1, n);
  10353e:	89 d0                	mov    %edx,%eax
  103540:	03 44 24 04          	add    0x4(%esp),%eax
  103544:	52                   	push   %edx
  103545:	83 e8 01             	sub    $0x1,%eax
  103548:	50                   	push   %eax
  103549:	e8 d8 ff ff ff       	call   103526 <rounddown>
  10354e:	83 c4 08             	add    $0x8,%esp
}
  103551:	c3                   	ret

00103552 <lldt>:
#include <lib/string.h>
#include "x86.h"

gcc_inline void lldt(uint16_t sel)
{
    __asm __volatile ("lldt %0" :: "r" (sel));
  103552:	0f b7 44 24 04       	movzwl 0x4(%esp),%eax
  103557:	0f 00 d0             	lldt   %eax
}
  10355a:	c3                   	ret

0010355b <cli>:

gcc_inline void cli(void)
{
    __asm __volatile ("cli" ::: "memory");
  10355b:	fa                   	cli
}
  10355c:	c3                   	ret

0010355d <sti>:

gcc_inline void sti(void)
{
    __asm __volatile ("sti; nop");
  10355d:	fb                   	sti
  10355e:	90                   	nop
}
  10355f:	c3                   	ret

00103560 <rdmsr>:

gcc_inline uint64_t rdmsr(uint32_t msr)
{
    uint64_t rv;
    __asm __volatile ("rdmsr"
  103560:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  103564:	0f 32                	rdmsr
                      : "=A" (rv)
                      : "c" (msr));
    return rv;
}
  103566:	c3                   	ret

00103567 <wrmsr>:

gcc_inline void wrmsr(uint32_t msr, uint64_t newval)
{
    __asm __volatile ("wrmsr" :: "A" (newval), "c" (msr));
  103567:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10356b:	8b 44 24 08          	mov    0x8(%esp),%eax
  10356f:	8b 54 24 0c          	mov    0xc(%esp),%edx
  103573:	0f 30                	wrmsr
}
  103575:	c3                   	ret

00103576 <halt>:

gcc_inline void halt(void)
{
    __asm __volatile ("hlt");
  103576:	f4                   	hlt
}
  103577:	c3                   	ret

00103578 <rdtsc>:

gcc_inline uint64_t rdtsc(void)
{
    uint64_t rv;

    __asm __volatile ("rdtsc" : "=A" (rv));
  103578:	0f 31                	rdtsc
    return (rv);
}
  10357a:	c3                   	ret

0010357b <enable_sse>:
}

gcc_inline uint32_t rcr4(void)
{
    uint32_t cr4;
    __asm __volatile ("movl %%cr4,%0" : "=r" (cr4));
  10357b:	0f 20 e0             	mov    %cr4,%eax
    cr4 = rcr4() | CR4_OSFXSR | CR4_OSXMMEXCPT;
  10357e:	80 cc 06             	or     $0x6,%ah
    FENCE();
  103581:	0f ae f0             	mfence
    __asm __volatile ("movl %0,%%cr4" :: "r" (val));
  103584:	0f 22 e0             	mov    %eax,%cr4
    __asm __volatile ("movl %%cr0,%0" : "=r" (val));
  103587:	0f 20 c0             	mov    %cr0,%eax
    FENCE();
  10358a:	0f ae f0             	mfence
}
  10358d:	c3                   	ret

0010358e <cpuid>:
{
  10358e:	55                   	push   %ebp
  10358f:	57                   	push   %edi
  103590:	56                   	push   %esi
  103591:	53                   	push   %ebx
  103592:	8b 44 24 14          	mov    0x14(%esp),%eax
  103596:	8b 74 24 18          	mov    0x18(%esp),%esi
  10359a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  10359e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
    __asm __volatile ("cpuid"
  1035a2:	0f a2                	cpuid
    if (eaxp)
  1035a4:	85 f6                	test   %esi,%esi
  1035a6:	74 02                	je     1035aa <cpuid+0x1c>
        *eaxp = eax;
  1035a8:	89 06                	mov    %eax,(%esi)
    if (ebxp)
  1035aa:	85 ff                	test   %edi,%edi
  1035ac:	74 02                	je     1035b0 <cpuid+0x22>
        *ebxp = ebx;
  1035ae:	89 1f                	mov    %ebx,(%edi)
    if (ecxp)
  1035b0:	85 ed                	test   %ebp,%ebp
  1035b2:	74 03                	je     1035b7 <cpuid+0x29>
        *ecxp = ecx;
  1035b4:	89 4d 00             	mov    %ecx,0x0(%ebp)
    if (edxp)
  1035b7:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
  1035bc:	74 06                	je     1035c4 <cpuid+0x36>
        *edxp = edx;
  1035be:	8b 44 24 24          	mov    0x24(%esp),%eax
  1035c2:	89 10                	mov    %edx,(%eax)
}
  1035c4:	5b                   	pop    %ebx
  1035c5:	5e                   	pop    %esi
  1035c6:	5f                   	pop    %edi
  1035c7:	5d                   	pop    %ebp
  1035c8:	c3                   	ret

001035c9 <rcr3>:
    __asm __volatile ("movl %%cr3,%0" : "=r" (val));
  1035c9:	0f 20 d8             	mov    %cr3,%eax
}
  1035cc:	c3                   	ret

001035cd <outl>:
    __asm __volatile ("outl %0,%w1" :: "a" (data), "d" (port));
  1035cd:	8b 54 24 04          	mov    0x4(%esp),%edx
  1035d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  1035d5:	ef                   	out    %eax,(%dx)
}
  1035d6:	c3                   	ret

001035d7 <inl>:
    __asm __volatile ("inl %w1,%0" : "=a" (data) : "d" (port));
  1035d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  1035db:	ed                   	in     (%dx),%eax
}
  1035dc:	c3                   	ret

001035dd <smp_wmb>:
}
  1035dd:	c3                   	ret

001035de <ltr>:
    __asm __volatile ("ltr %0" :: "r" (sel));
  1035de:	0f b7 44 24 04       	movzwl 0x4(%esp),%eax
  1035e3:	0f 00 d8             	ltr    %eax
}
  1035e6:	c3                   	ret

001035e7 <lcr0>:
    __asm __volatile ("movl %0,%%cr0" :: "r" (val));
  1035e7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1035eb:	0f 22 c0             	mov    %eax,%cr0
}
  1035ee:	c3                   	ret

001035ef <rcr0>:
    __asm __volatile ("movl %%cr0,%0" : "=r" (val));
  1035ef:	0f 20 c0             	mov    %cr0,%eax
}
  1035f2:	c3                   	ret

001035f3 <rcr2>:
    __asm __volatile ("movl %%cr2,%0" : "=r" (val));
  1035f3:	0f 20 d0             	mov    %cr2,%eax
}
  1035f6:	c3                   	ret

001035f7 <lcr3>:
    __asm __volatile ("movl %0,%%cr3" :: "r" (val));
  1035f7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1035fb:	0f 22 d8             	mov    %eax,%cr3
}
  1035fe:	c3                   	ret

001035ff <lcr4>:
    __asm __volatile ("movl %0,%%cr4" :: "r" (val));
  1035ff:	8b 44 24 04          	mov    0x4(%esp),%eax
  103603:	0f 22 e0             	mov    %eax,%cr4
}
  103606:	c3                   	ret

00103607 <rcr4>:
    __asm __volatile ("movl %%cr4,%0" : "=r" (cr4));
  103607:	0f 20 e0             	mov    %cr4,%eax
    return cr4;
}
  10360a:	c3                   	ret

0010360b <inb>:

gcc_inline uint8_t inb(int port)
{
    uint8_t data;
    __asm __volatile ("inb %w1,%0"
  10360b:	8b 54 24 04          	mov    0x4(%esp),%edx
  10360f:	ec                   	in     (%dx),%al
                      : "=a" (data)
                      : "d" (port));
    return data;
}
  103610:	c3                   	ret

00103611 <insl>:

gcc_inline void insl(int port, void *addr, int cnt)
{
  103611:	57                   	push   %edi
    __asm __volatile ("cld\n\trepne\n\tinsl"
  103612:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  103616:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10361a:	8b 54 24 08          	mov    0x8(%esp),%edx
  10361e:	fc                   	cld
  10361f:	f2 6d                	repnz insl (%dx),%es:(%edi)
                      : "=D" (addr), "=c" (cnt)
                      : "d" (port), "0" (addr), "1" (cnt)
                      : "memory", "cc");
}
  103621:	5f                   	pop    %edi
  103622:	c3                   	ret

00103623 <outb>:

gcc_inline void outb(int port, uint8_t data)
{
    __asm __volatile ("outb %0,%w1" :: "a" (data), "d" (port));
  103623:	8b 54 24 04          	mov    0x4(%esp),%edx
  103627:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
  10362c:	ee                   	out    %al,(%dx)
}
  10362d:	c3                   	ret

0010362e <outsw>:

gcc_inline void outsw(int port, const void *addr, int cnt)
{
  10362e:	56                   	push   %esi
    __asm __volatile ("cld\n\trepne\n\toutsw"
  10362f:	8b 74 24 0c          	mov    0xc(%esp),%esi
  103633:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  103637:	8b 54 24 08          	mov    0x8(%esp),%edx
  10363b:	fc                   	cld
  10363c:	f2 66 6f             	repnz outsw %ds:(%esi),(%dx)
                      : "=S" (addr), "=c" (cnt)
                      : "d" (port), "0" (addr), "1" (cnt)
                      : "cc");
}
  10363f:	5e                   	pop    %esi
  103640:	c3                   	ret

00103641 <mon_help>:
extern void set_curid(unsigned int curid);
extern void kctx_switch(unsigned int from_pid, unsigned int to_pid);

/***** Implementations of basic kernel monitor commands *****/
int mon_help(int argc, char **argv, struct Trapframe *tf)
{
  103641:	56                   	push   %esi
  103642:	53                   	push   %ebx
  103643:	83 ec 04             	sub    $0x4,%esp
  103646:	e8 f2 cc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10364b:	81 c3 a9 b9 00 00    	add    $0xb9a9,%ebx
    int i;

    for (i = 0; i < NCOMMANDS; i++)
  103651:	be 00 00 00 00       	mov    $0x0,%esi
  103656:	eb 30                	jmp    103688 <mon_help+0x47>
        dprintf("%s - %s\n", commands[i].name, commands[i].desc);
  103658:	83 ec 04             	sub    $0x4,%esp
  10365b:	8d 04 36             	lea    (%esi,%esi,1),%eax
  10365e:	8d 0c 30             	lea    (%eax,%esi,1),%ecx
  103661:	8d 14 8d 00 00 00 00 	lea    0x0(,%ecx,4),%edx
  103668:	ff b4 13 d0 ff ff ff 	push   -0x30(%ebx,%edx,1)
  10366f:	ff b4 13 cc ff ff ff 	push   -0x34(%ebx,%edx,1)
  103676:	8d 83 db 91 ff ff    	lea    -0x6e25(%ebx),%eax
  10367c:	50                   	push   %eax
  10367d:	e8 20 f5 ff ff       	call   102ba2 <dprintf>
    for (i = 0; i < NCOMMANDS; i++)
  103682:	83 c6 01             	add    $0x1,%esi
  103685:	83 c4 10             	add    $0x10,%esp
  103688:	83 fe 02             	cmp    $0x2,%esi
  10368b:	76 cb                	jbe    103658 <mon_help+0x17>
    return 0;
}
  10368d:	b8 00 00 00 00       	mov    $0x0,%eax
  103692:	83 c4 04             	add    $0x4,%esp
  103695:	5b                   	pop    %ebx
  103696:	5e                   	pop    %esi
  103697:	c3                   	ret

00103698 <mon_kerninfo>:

int mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
  103698:	57                   	push   %edi
  103699:	56                   	push   %esi
  10369a:	53                   	push   %ebx
  10369b:	e8 9d cc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1036a0:	81 c3 54 b9 00 00    	add    $0xb954,%ebx
    extern uint8_t start[], etext[], edata[], end[];

    dprintf("Special kernel symbols:\n");
  1036a6:	83 ec 0c             	sub    $0xc,%esp
  1036a9:	8d 83 e4 91 ff ff    	lea    -0x6e1c(%ebx),%eax
  1036af:	50                   	push   %eax
  1036b0:	e8 ed f4 ff ff       	call   102ba2 <dprintf>
    dprintf("  start  %08x\n", start);
  1036b5:	83 c4 08             	add    $0x8,%esp
  1036b8:	c7 c7 24 40 10 00    	mov    $0x104024,%edi
  1036be:	57                   	push   %edi
  1036bf:	8d 83 fd 91 ff ff    	lea    -0x6e03(%ebx),%eax
  1036c5:	50                   	push   %eax
  1036c6:	e8 d7 f4 ff ff       	call   102ba2 <dprintf>
    dprintf("  etext  %08x\n", etext);
  1036cb:	83 c4 08             	add    $0x8,%esp
  1036ce:	ff b3 f8 ff ff ff    	push   -0x8(%ebx)
  1036d4:	8d 83 0c 92 ff ff    	lea    -0x6df4(%ebx),%eax
  1036da:	50                   	push   %eax
  1036db:	e8 c2 f4 ff ff       	call   102ba2 <dprintf>
    dprintf("  edata  %08x\n", edata);
  1036e0:	83 c4 08             	add    $0x8,%esp
  1036e3:	ff b3 f4 ff ff ff    	push   -0xc(%ebx)
  1036e9:	8d 83 1b 92 ff ff    	lea    -0x6de5(%ebx),%eax
  1036ef:	50                   	push   %eax
  1036f0:	e8 ad f4 ff ff       	call   102ba2 <dprintf>
    dprintf("  end    %08x\n", end);
  1036f5:	83 c4 08             	add    $0x8,%esp
  1036f8:	c7 c6 20 1c e0 00    	mov    $0xe01c20,%esi
  1036fe:	56                   	push   %esi
  1036ff:	8d 83 2a 92 ff ff    	lea    -0x6dd6(%ebx),%eax
  103705:	50                   	push   %eax
  103706:	e8 97 f4 ff ff       	call   102ba2 <dprintf>
    dprintf("Kernel executable memory footprint: %dKB\n",
            ROUNDUP(end - start, 1024) / 1024);
  10370b:	29 fe                	sub    %edi,%esi
  10370d:	8d 86 ff 03 00 00    	lea    0x3ff(%esi),%eax
  103713:	89 c1                	mov    %eax,%ecx
  103715:	c1 f9 1f             	sar    $0x1f,%ecx
  103718:	c1 e9 16             	shr    $0x16,%ecx
  10371b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  10371e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  103724:	29 ca                	sub    %ecx,%edx
  103726:	29 d0                	sub    %edx,%eax
    dprintf("Kernel executable memory footprint: %dKB\n",
  103728:	83 c4 08             	add    $0x8,%esp
  10372b:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  103731:	85 c0                	test   %eax,%eax
  103733:	0f 49 d0             	cmovns %eax,%edx
  103736:	c1 fa 0a             	sar    $0xa,%edx
  103739:	52                   	push   %edx
  10373a:	8d 83 fc 99 ff ff    	lea    -0x6604(%ebx),%eax
  103740:	50                   	push   %eax
  103741:	e8 5c f4 ff ff       	call   102ba2 <dprintf>
    return 0;
  103746:	83 c4 10             	add    $0x10,%esp
}
  103749:	b8 00 00 00 00       	mov    $0x0,%eax
  10374e:	5b                   	pop    %ebx
  10374f:	5e                   	pop    %esi
  103750:	5f                   	pop    %edi
  103751:	c3                   	ret

00103752 <mon_start_user>:
    // TODO
    return 0;
}

int mon_start_user(int argc, char **argv, struct Trapframe *tf)
{
  103752:	57                   	push   %edi
  103753:	56                   	push   %esi
  103754:	53                   	push   %ebx
  103755:	e8 e3 cb ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10375a:	81 c3 9a b8 00 00    	add    $0xb89a,%ebx
    unsigned int idle_pid;
    idle_pid = proc_create(_binary___obj_user_idle_idle_start, 10000);
  103760:	83 ec 08             	sub    $0x8,%esp
  103763:	68 10 27 00 00       	push   $0x2710
  103768:	ff b3 f0 ff ff ff    	push   -0x10(%ebx)
  10376e:	e8 ad 34 00 00       	call   106c20 <proc_create>
  103773:	89 c6                	mov    %eax,%esi
    KERN_DEBUG("process idle %d is created.\n", idle_pid);
  103775:	50                   	push   %eax
  103776:	8d 83 39 92 ff ff    	lea    -0x6dc7(%ebx),%eax
  10377c:	50                   	push   %eax
  10377d:	6a 4a                	push   $0x4a
  10377f:	8d bb 56 92 ff ff    	lea    -0x6daa(%ebx),%edi
  103785:	57                   	push   %edi
  103786:	e8 4b f2 ff ff       	call   1029d6 <debug_normal>

    KERN_INFO("Start user-space ... \n");
  10378b:	83 c4 14             	add    $0x14,%esp
  10378e:	8d 83 69 92 ff ff    	lea    -0x6d97(%ebx),%eax
  103794:	50                   	push   %eax
  103795:	e8 17 f2 ff ff       	call   1029b1 <debug_info>

    tqueue_remove(NUM_IDS, idle_pid);
  10379a:	83 c4 08             	add    $0x8,%esp
  10379d:	56                   	push   %esi
  10379e:	6a 40                	push   $0x40
  1037a0:	e8 7b 2d 00 00       	call   106520 <tqueue_remove>
    tcb_set_state(idle_pid, TSTATE_RUN);
  1037a5:	83 c4 08             	add    $0x8,%esp
  1037a8:	6a 01                	push   $0x1
  1037aa:	56                   	push   %esi
  1037ab:	e8 90 29 00 00       	call   106140 <tcb_set_state>
    set_curid(idle_pid);
  1037b0:	89 34 24             	mov    %esi,(%esp)
  1037b3:	e8 58 32 00 00       	call   106a10 <set_curid>
    kctx_switch(0, idle_pid);
  1037b8:	83 c4 08             	add    $0x8,%esp
  1037bb:	56                   	push   %esi
  1037bc:	6a 00                	push   $0x0
  1037be:	e8 cd 27 00 00       	call   105f90 <kctx_switch>

    KERN_PANIC("mon_start_user() should never reach here.\n");
  1037c3:	83 c4 0c             	add    $0xc,%esp
  1037c6:	8d 83 28 9a ff ff    	lea    -0x65d8(%ebx),%eax
  1037cc:	50                   	push   %eax
  1037cd:	6a 53                	push   $0x53
  1037cf:	57                   	push   %edi
  1037d0:	e8 3a f2 ff ff       	call   102a0f <debug_panic>
    return 0;
  1037d5:	83 c4 10             	add    $0x10,%esp
}
  1037d8:	b8 00 00 00 00       	mov    $0x0,%eax
  1037dd:	5b                   	pop    %ebx
  1037de:	5e                   	pop    %esi
  1037df:	5f                   	pop    %edi
  1037e0:	c3                   	ret

001037e1 <runcmd>:
/***** Kernel monitor command interpreter *****/
#define WHITESPACE "\t\r\n "
#define MAXARGS    16

static int runcmd(char *buf, struct Trapframe *tf)
{
  1037e1:	55                   	push   %ebp
  1037e2:	57                   	push   %edi
  1037e3:	56                   	push   %esi
  1037e4:	53                   	push   %ebx
  1037e5:	83 ec 5c             	sub    $0x5c,%esp
  1037e8:	e8 50 cb ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1037ed:	81 c3 07 b8 00 00    	add    $0xb807,%ebx
  1037f3:	89 c6                	mov    %eax,%esi
  1037f5:	89 54 24 0c          	mov    %edx,0xc(%esp)
    char *argv[MAXARGS];
    int i;

    // Parse the command buffer into whitespace-separated arguments
    argc = 0;
    argv[argc] = 0;
  1037f9:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  103800:	00 
    argc = 0;
  103801:	bf 00 00 00 00       	mov    $0x0,%edi
  103806:	eb 6d                	jmp    103875 <runcmd+0x94>
    while (1) {
        // gobble whitespace
        while (*buf && strchr(WHITESPACE, *buf))
  103808:	83 ec 08             	sub    $0x8,%esp
  10380b:	0f be c0             	movsbl %al,%eax
  10380e:	50                   	push   %eax
  10380f:	8d 83 80 92 ff ff    	lea    -0x6d80(%ebx),%eax
  103815:	50                   	push   %eax
  103816:	e8 ff f0 ff ff       	call   10291a <strchr>
  10381b:	83 c4 10             	add    $0x10,%esp
  10381e:	85 c0                	test   %eax,%eax
  103820:	74 5a                	je     10387c <runcmd+0x9b>
            *buf++ = 0;
  103822:	c6 06 00             	movb   $0x0,(%esi)
  103825:	89 fd                	mov    %edi,%ebp
  103827:	8d 76 01             	lea    0x1(%esi),%esi
  10382a:	eb 47                	jmp    103873 <runcmd+0x92>
        if (*buf == 0)
            break;

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            dprintf("Too many arguments (max %d)\n", MAXARGS);
  10382c:	83 ec 08             	sub    $0x8,%esp
  10382f:	6a 10                	push   $0x10
  103831:	8d 83 85 92 ff ff    	lea    -0x6d7b(%ebx),%eax
  103837:	50                   	push   %eax
  103838:	e8 65 f3 ff ff       	call   102ba2 <dprintf>
            return 0;
  10383d:	83 c4 10             	add    $0x10,%esp
  103840:	bf 00 00 00 00       	mov    $0x0,%edi
        if (strcmp(argv[0], commands[i].name) == 0)
            return commands[i].func(argc, argv, tf);
    }
    dprintf("Unknown command '%s'\n", argv[0]);
    return 0;
}
  103845:	89 f8                	mov    %edi,%eax
  103847:	83 c4 5c             	add    $0x5c,%esp
  10384a:	5b                   	pop    %ebx
  10384b:	5e                   	pop    %esi
  10384c:	5f                   	pop    %edi
  10384d:	5d                   	pop    %ebp
  10384e:	c3                   	ret
            buf++;
  10384f:	83 c6 01             	add    $0x1,%esi
        while (*buf && !strchr(WHITESPACE, *buf))
  103852:	0f b6 06             	movzbl (%esi),%eax
  103855:	84 c0                	test   %al,%al
  103857:	74 1a                	je     103873 <runcmd+0x92>
  103859:	83 ec 08             	sub    $0x8,%esp
  10385c:	0f be c0             	movsbl %al,%eax
  10385f:	50                   	push   %eax
  103860:	8d 83 80 92 ff ff    	lea    -0x6d80(%ebx),%eax
  103866:	50                   	push   %eax
  103867:	e8 ae f0 ff ff       	call   10291a <strchr>
  10386c:	83 c4 10             	add    $0x10,%esp
  10386f:	85 c0                	test   %eax,%eax
  103871:	74 dc                	je     10384f <runcmd+0x6e>
            *buf++ = 0;
  103873:	89 ef                	mov    %ebp,%edi
        while (*buf && strchr(WHITESPACE, *buf))
  103875:	0f b6 06             	movzbl (%esi),%eax
  103878:	84 c0                	test   %al,%al
  10387a:	75 8c                	jne    103808 <runcmd+0x27>
        if (*buf == 0)
  10387c:	80 3e 00             	cmpb   $0x0,(%esi)
  10387f:	74 0e                	je     10388f <runcmd+0xae>
        if (argc == MAXARGS - 1) {
  103881:	83 ff 0f             	cmp    $0xf,%edi
  103884:	74 a6                	je     10382c <runcmd+0x4b>
        argv[argc++] = buf;
  103886:	8d 6f 01             	lea    0x1(%edi),%ebp
  103889:	89 74 bc 10          	mov    %esi,0x10(%esp,%edi,4)
        while (*buf && !strchr(WHITESPACE, *buf))
  10388d:	eb c3                	jmp    103852 <runcmd+0x71>
    argv[argc] = 0;
  10388f:	c7 44 bc 10 00 00 00 	movl   $0x0,0x10(%esp,%edi,4)
  103896:	00 
    if (argc == 0)
  103897:	85 ff                	test   %edi,%edi
  103899:	74 aa                	je     103845 <runcmd+0x64>
    for (i = 0; i < NCOMMANDS; i++) {
  10389b:	be 00 00 00 00       	mov    $0x0,%esi
  1038a0:	83 fe 02             	cmp    $0x2,%esi
  1038a3:	77 43                	ja     1038e8 <runcmd+0x107>
        if (strcmp(argv[0], commands[i].name) == 0)
  1038a5:	83 ec 08             	sub    $0x8,%esp
  1038a8:	8d 04 76             	lea    (%esi,%esi,2),%eax
  1038ab:	ff b4 83 cc ff ff ff 	push   -0x34(%ebx,%eax,4)
  1038b2:	ff 74 24 1c          	push   0x1c(%esp)
  1038b6:	e8 3a f0 ff ff       	call   1028f5 <strcmp>
  1038bb:	83 c4 10             	add    $0x10,%esp
  1038be:	85 c0                	test   %eax,%eax
  1038c0:	74 05                	je     1038c7 <runcmd+0xe6>
    for (i = 0; i < NCOMMANDS; i++) {
  1038c2:	83 c6 01             	add    $0x1,%esi
  1038c5:	eb d9                	jmp    1038a0 <runcmd+0xbf>
            return commands[i].func(argc, argv, tf);
  1038c7:	8d 04 76             	lea    (%esi,%esi,2),%eax
  1038ca:	83 ec 04             	sub    $0x4,%esp
  1038cd:	ff 74 24 10          	push   0x10(%esp)
  1038d1:	8d 54 24 18          	lea    0x18(%esp),%edx
  1038d5:	52                   	push   %edx
  1038d6:	57                   	push   %edi
  1038d7:	ff 94 83 d4 ff ff ff 	call   *-0x2c(%ebx,%eax,4)
  1038de:	89 c7                	mov    %eax,%edi
  1038e0:	83 c4 10             	add    $0x10,%esp
  1038e3:	e9 5d ff ff ff       	jmp    103845 <runcmd+0x64>
    dprintf("Unknown command '%s'\n", argv[0]);
  1038e8:	83 ec 08             	sub    $0x8,%esp
  1038eb:	ff 74 24 18          	push   0x18(%esp)
  1038ef:	8d 83 a2 92 ff ff    	lea    -0x6d5e(%ebx),%eax
  1038f5:	50                   	push   %eax
  1038f6:	e8 a7 f2 ff ff       	call   102ba2 <dprintf>
    return 0;
  1038fb:	83 c4 10             	add    $0x10,%esp
  1038fe:	bf 00 00 00 00       	mov    $0x0,%edi
  103903:	e9 3d ff ff ff       	jmp    103845 <runcmd+0x64>

00103908 <mon_backtrace>:
}
  103908:	b8 00 00 00 00       	mov    $0x0,%eax
  10390d:	c3                   	ret

0010390e <monitor>:

void monitor(struct Trapframe *tf)
{
  10390e:	57                   	push   %edi
  10390f:	56                   	push   %esi
  103910:	53                   	push   %ebx
  103911:	e8 27 ca ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  103916:	81 c3 de b6 00 00    	add    $0xb6de,%ebx
  10391c:	8b 74 24 10          	mov    0x10(%esp),%esi
    char *buf;

    dprintf("\n****************************************\n\n");
  103920:	83 ec 0c             	sub    $0xc,%esp
  103923:	8d bb 54 9a ff ff    	lea    -0x65ac(%ebx),%edi
  103929:	57                   	push   %edi
  10392a:	e8 73 f2 ff ff       	call   102ba2 <dprintf>
    dprintf("Welcome to the mCertiKOS kernel monitor!\n");
  10392f:	8d 83 80 9a ff ff    	lea    -0x6580(%ebx),%eax
  103935:	89 04 24             	mov    %eax,(%esp)
  103938:	e8 65 f2 ff ff       	call   102ba2 <dprintf>
    dprintf("\n****************************************\n\n");
  10393d:	89 3c 24             	mov    %edi,(%esp)
  103940:	e8 5d f2 ff ff       	call   102ba2 <dprintf>
    dprintf("Type 'help' for a list of commands.\n");
  103945:	8d 83 ac 9a ff ff    	lea    -0x6554(%ebx),%eax
  10394b:	89 04 24             	mov    %eax,(%esp)
  10394e:	e8 4f f2 ff ff       	call   102ba2 <dprintf>
  103953:	83 c4 10             	add    $0x10,%esp

    while (1) {
        buf = (char *) readline("$> ");
  103956:	83 ec 0c             	sub    $0xc,%esp
  103959:	8d 83 b8 92 ff ff    	lea    -0x6d48(%ebx),%eax
  10395f:	50                   	push   %eax
  103960:	e8 fd ca ff ff       	call   100462 <readline>
        if (buf != NULL)
  103965:	83 c4 10             	add    $0x10,%esp
  103968:	85 c0                	test   %eax,%eax
  10396a:	74 ea                	je     103956 <monitor+0x48>
            if (runcmd(buf, tf) < 0)
  10396c:	89 f2                	mov    %esi,%edx
  10396e:	e8 6e fe ff ff       	call   1037e1 <runcmd>
  103973:	85 c0                	test   %eax,%eax
  103975:	79 df                	jns    103956 <monitor+0x48>
                break;
    }
}
  103977:	5b                   	pop    %ebx
  103978:	5e                   	pop    %esi
  103979:	5f                   	pop    %edi
  10397a:	c3                   	ret

0010397b <pt_copyin>:
                       unsigned int perm);
extern unsigned int get_ptbl_entry_by_va(unsigned int pid,
                                         unsigned int vaddr);

size_t pt_copyin(uint32_t pmap_id, uintptr_t uva, void *kva, size_t len)
{
  10397b:	55                   	push   %ebp
  10397c:	57                   	push   %edi
  10397d:	56                   	push   %esi
  10397e:	53                   	push   %ebx
  10397f:	83 ec 1c             	sub    $0x1c,%esp
  103982:	e8 a3 d4 ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  103987:	05 6d b6 00 00       	add    $0xb66d,%eax
  10398c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103990:	8b 6c 24 34          	mov    0x34(%esp),%ebp
  103994:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  103998:	81 fd ff ff ff 3f    	cmp    $0x3fffffff,%ebp
  10399e:	0f 86 ae 00 00 00    	jbe    103a52 <pt_copyin+0xd7>
  1039a4:	8d 44 3d 00          	lea    0x0(%ebp,%edi,1),%eax
  1039a8:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  1039ad:	0f 87 ae 00 00 00    	ja     103a61 <pt_copyin+0xe6>
        return 0;

    if ((uintptr_t) kva + len > VM_USERHI)
  1039b3:	89 f8                	mov    %edi,%eax
  1039b5:	03 44 24 38          	add    0x38(%esp),%eax
  1039b9:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  1039be:	0f 87 a4 00 00 00    	ja     103a68 <pt_copyin+0xed>
        return 0;

    size_t copied = 0;
  1039c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  1039c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1039cd:	eb 3c                	jmp    103a0b <pt_copyin+0x90>
        if ((uva_pa & PTE_P) == 0) {
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
        }

        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1039cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039d4:	89 ea                	mov    %ebp,%edx
  1039d6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  1039dc:	09 d0                	or     %edx,%eax

        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1039de:	be 00 10 00 00       	mov    $0x1000,%esi
  1039e3:	29 d6                	sub    %edx,%esi
  1039e5:	39 fe                	cmp    %edi,%esi
  1039e7:	0f 47 f7             	cmova  %edi,%esi
            len : PAGESIZE - uva_pa % PAGESIZE;

        memcpy(kva, (void *) uva_pa, size);
  1039ea:	83 ec 04             	sub    $0x4,%esp
  1039ed:	56                   	push   %esi
  1039ee:	50                   	push   %eax
  1039ef:	ff 74 24 44          	push   0x44(%esp)
  1039f3:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  1039f7:	e8 7a ee ff ff       	call   102876 <memcpy>

        len -= size;
  1039fc:	29 f7                	sub    %esi,%edi
        uva += size;
  1039fe:	01 f5                	add    %esi,%ebp
        kva += size;
  103a00:	01 74 24 48          	add    %esi,0x48(%esp)
        copied += size;
  103a04:	01 74 24 1c          	add    %esi,0x1c(%esp)
  103a08:	83 c4 10             	add    $0x10,%esp
    while (len) {
  103a0b:	85 ff                	test   %edi,%edi
  103a0d:	74 3d                	je     103a4c <pt_copyin+0xd1>
        uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  103a0f:	83 ec 08             	sub    $0x8,%esp
  103a12:	55                   	push   %ebp
  103a13:	ff 74 24 3c          	push   0x3c(%esp)
  103a17:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  103a1b:	e8 10 19 00 00       	call   105330 <get_ptbl_entry_by_va>
        if ((uva_pa & PTE_P) == 0) {
  103a20:	83 c4 10             	add    $0x10,%esp
  103a23:	a8 01                	test   $0x1,%al
  103a25:	75 a8                	jne    1039cf <pt_copyin+0x54>
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  103a27:	83 ec 04             	sub    $0x4,%esp
  103a2a:	6a 07                	push   $0x7
  103a2c:	55                   	push   %ebp
  103a2d:	ff 74 24 3c          	push   0x3c(%esp)
  103a31:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  103a35:	e8 66 23 00 00       	call   105da0 <alloc_page>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  103a3a:	83 c4 08             	add    $0x8,%esp
  103a3d:	55                   	push   %ebp
  103a3e:	ff 74 24 3c          	push   0x3c(%esp)
  103a42:	e8 e9 18 00 00       	call   105330 <get_ptbl_entry_by_va>
  103a47:	83 c4 10             	add    $0x10,%esp
  103a4a:	eb 83                	jmp    1039cf <pt_copyin+0x54>
  103a4c:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  103a50:	eb 05                	jmp    103a57 <pt_copyin+0xdc>
        return 0;
  103a52:	b9 00 00 00 00       	mov    $0x0,%ecx
    }

    return copied;
}
  103a57:	89 c8                	mov    %ecx,%eax
  103a59:	83 c4 1c             	add    $0x1c,%esp
  103a5c:	5b                   	pop    %ebx
  103a5d:	5e                   	pop    %esi
  103a5e:	5f                   	pop    %edi
  103a5f:	5d                   	pop    %ebp
  103a60:	c3                   	ret
        return 0;
  103a61:	b9 00 00 00 00       	mov    $0x0,%ecx
  103a66:	eb ef                	jmp    103a57 <pt_copyin+0xdc>
        return 0;
  103a68:	b9 00 00 00 00       	mov    $0x0,%ecx
  103a6d:	eb e8                	jmp    103a57 <pt_copyin+0xdc>

00103a6f <pt_copyout>:

size_t pt_copyout(void *kva, uint32_t pmap_id, uintptr_t uva, size_t len)
{
  103a6f:	55                   	push   %ebp
  103a70:	57                   	push   %edi
  103a71:	56                   	push   %esi
  103a72:	53                   	push   %ebx
  103a73:	83 ec 1c             	sub    $0x1c,%esp
  103a76:	e8 af d3 ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  103a7b:	05 79 b5 00 00       	add    $0xb579,%eax
  103a80:	89 44 24 08          	mov    %eax,0x8(%esp)
  103a84:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  103a88:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  103a8c:	81 fd ff ff ff 3f    	cmp    $0x3fffffff,%ebp
  103a92:	0f 86 ae 00 00 00    	jbe    103b46 <pt_copyout+0xd7>
  103a98:	8d 44 3d 00          	lea    0x0(%ebp,%edi,1),%eax
  103a9c:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  103aa1:	0f 87 ae 00 00 00    	ja     103b55 <pt_copyout+0xe6>
        return 0;

    if ((uintptr_t) kva + len > VM_USERHI)
  103aa7:	89 f8                	mov    %edi,%eax
  103aa9:	03 44 24 30          	add    0x30(%esp),%eax
  103aad:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  103ab2:	0f 87 a4 00 00 00    	ja     103b5c <pt_copyout+0xed>
        return 0;

    size_t copied = 0;
  103ab8:	b9 00 00 00 00       	mov    $0x0,%ecx
  103abd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  103ac1:	eb 3c                	jmp    103aff <pt_copyout+0x90>
        if ((uva_pa & PTE_P) == 0) {
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
        }

        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  103ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ac8:	89 ea                	mov    %ebp,%edx
  103aca:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  103ad0:	09 d0                	or     %edx,%eax

        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  103ad2:	be 00 10 00 00       	mov    $0x1000,%esi
  103ad7:	29 d6                	sub    %edx,%esi
  103ad9:	39 fe                	cmp    %edi,%esi
  103adb:	0f 47 f7             	cmova  %edi,%esi
            len : PAGESIZE - uva_pa % PAGESIZE;

        memcpy((void *) uva_pa, kva, size);
  103ade:	83 ec 04             	sub    $0x4,%esp
  103ae1:	56                   	push   %esi
  103ae2:	ff 74 24 38          	push   0x38(%esp)
  103ae6:	50                   	push   %eax
  103ae7:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  103aeb:	e8 86 ed ff ff       	call   102876 <memcpy>

        len -= size;
  103af0:	29 f7                	sub    %esi,%edi
        uva += size;
  103af2:	01 f5                	add    %esi,%ebp
        kva += size;
  103af4:	01 74 24 40          	add    %esi,0x40(%esp)
        copied += size;
  103af8:	01 74 24 1c          	add    %esi,0x1c(%esp)
  103afc:	83 c4 10             	add    $0x10,%esp
    while (len) {
  103aff:	85 ff                	test   %edi,%edi
  103b01:	74 3d                	je     103b40 <pt_copyout+0xd1>
        uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  103b03:	83 ec 08             	sub    $0x8,%esp
  103b06:	55                   	push   %ebp
  103b07:	ff 74 24 40          	push   0x40(%esp)
  103b0b:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  103b0f:	e8 1c 18 00 00       	call   105330 <get_ptbl_entry_by_va>
        if ((uva_pa & PTE_P) == 0) {
  103b14:	83 c4 10             	add    $0x10,%esp
  103b17:	a8 01                	test   $0x1,%al
  103b19:	75 a8                	jne    103ac3 <pt_copyout+0x54>
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  103b1b:	83 ec 04             	sub    $0x4,%esp
  103b1e:	6a 07                	push   $0x7
  103b20:	55                   	push   %ebp
  103b21:	ff 74 24 40          	push   0x40(%esp)
  103b25:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  103b29:	e8 72 22 00 00       	call   105da0 <alloc_page>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  103b2e:	83 c4 08             	add    $0x8,%esp
  103b31:	55                   	push   %ebp
  103b32:	ff 74 24 40          	push   0x40(%esp)
  103b36:	e8 f5 17 00 00       	call   105330 <get_ptbl_entry_by_va>
  103b3b:	83 c4 10             	add    $0x10,%esp
  103b3e:	eb 83                	jmp    103ac3 <pt_copyout+0x54>
  103b40:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  103b44:	eb 05                	jmp    103b4b <pt_copyout+0xdc>
        return 0;
  103b46:	b9 00 00 00 00       	mov    $0x0,%ecx
    }

    return copied;
}
  103b4b:	89 c8                	mov    %ecx,%eax
  103b4d:	83 c4 1c             	add    $0x1c,%esp
  103b50:	5b                   	pop    %ebx
  103b51:	5e                   	pop    %esi
  103b52:	5f                   	pop    %edi
  103b53:	5d                   	pop    %ebp
  103b54:	c3                   	ret
        return 0;
  103b55:	b9 00 00 00 00       	mov    $0x0,%ecx
  103b5a:	eb ef                	jmp    103b4b <pt_copyout+0xdc>
        return 0;
  103b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  103b61:	eb e8                	jmp    103b4b <pt_copyout+0xdc>

00103b63 <pt_memset>:

size_t pt_memset(uint32_t pmap_id, uintptr_t va, char c, size_t len)
{
  103b63:	55                   	push   %ebp
  103b64:	57                   	push   %edi
  103b65:	56                   	push   %esi
  103b66:	53                   	push   %ebx
  103b67:	83 ec 1c             	sub    $0x1c,%esp
  103b6a:	e8 ce c7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  103b6f:	81 c3 85 b4 00 00    	add    $0xb485,%ebx
  103b75:	8b 6c 24 34          	mov    0x34(%esp),%ebp
  103b79:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  103b7d:	0f b6 44 24 38       	movzbl 0x38(%esp),%eax
  103b82:	88 44 24 0f          	mov    %al,0xf(%esp)
    size_t set = 0;
  103b86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b8d:	00 

    while (len) {
  103b8e:	eb 36                	jmp    103bc6 <pt_memset+0x63>
        if ((pa & PTE_P) == 0) {
            alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
            pa = get_ptbl_entry_by_va(pmap_id, va);
        }

        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  103b90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b95:	89 ea                	mov    %ebp,%edx
  103b97:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  103b9d:	09 d0                	or     %edx,%eax

        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  103b9f:	be 00 10 00 00       	mov    $0x1000,%esi
  103ba4:	29 d6                	sub    %edx,%esi
  103ba6:	39 fe                	cmp    %edi,%esi
  103ba8:	0f 47 f7             	cmova  %edi,%esi
            len : PAGESIZE - pa % PAGESIZE;

        memset((void *) pa, c, size);
  103bab:	83 ec 04             	sub    $0x4,%esp
  103bae:	56                   	push   %esi
  103baf:	0f be 54 24 17       	movsbl 0x17(%esp),%edx
  103bb4:	52                   	push   %edx
  103bb5:	50                   	push   %eax
  103bb6:	e8 05 ec ff ff       	call   1027c0 <memset>

        len -= size;
  103bbb:	29 f7                	sub    %esi,%edi
        va += size;
  103bbd:	01 f5                	add    %esi,%ebp
        set += size;
  103bbf:	01 74 24 18          	add    %esi,0x18(%esp)
  103bc3:	83 c4 10             	add    $0x10,%esp
    while (len) {
  103bc6:	85 ff                	test   %edi,%edi
  103bc8:	74 35                	je     103bff <pt_memset+0x9c>
        uintptr_t pa = get_ptbl_entry_by_va(pmap_id, va);
  103bca:	83 ec 08             	sub    $0x8,%esp
  103bcd:	55                   	push   %ebp
  103bce:	ff 74 24 3c          	push   0x3c(%esp)
  103bd2:	e8 59 17 00 00       	call   105330 <get_ptbl_entry_by_va>
        if ((pa & PTE_P) == 0) {
  103bd7:	83 c4 10             	add    $0x10,%esp
  103bda:	a8 01                	test   $0x1,%al
  103bdc:	75 b2                	jne    103b90 <pt_memset+0x2d>
            alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
  103bde:	83 ec 04             	sub    $0x4,%esp
  103be1:	6a 07                	push   $0x7
  103be3:	55                   	push   %ebp
  103be4:	ff 74 24 3c          	push   0x3c(%esp)
  103be8:	e8 b3 21 00 00       	call   105da0 <alloc_page>
            pa = get_ptbl_entry_by_va(pmap_id, va);
  103bed:	83 c4 08             	add    $0x8,%esp
  103bf0:	55                   	push   %ebp
  103bf1:	ff 74 24 3c          	push   0x3c(%esp)
  103bf5:	e8 36 17 00 00       	call   105330 <get_ptbl_entry_by_va>
  103bfa:	83 c4 10             	add    $0x10,%esp
  103bfd:	eb 91                	jmp    103b90 <pt_memset+0x2d>
    }

    return set;
}
  103bff:	8b 44 24 08          	mov    0x8(%esp),%eax
  103c03:	83 c4 1c             	add    $0x1c,%esp
  103c06:	5b                   	pop    %ebx
  103c07:	5e                   	pop    %esi
  103c08:	5f                   	pop    %edi
  103c09:	5d                   	pop    %ebp
  103c0a:	c3                   	ret
  103c0b:	66 90                	xchg   %ax,%ax
  103c0d:	66 90                	xchg   %ax,%ax
  103c0f:	66 90                	xchg   %ax,%ax
  103c11:	66 90                	xchg   %ax,%ax
  103c13:	66 90                	xchg   %ax,%ax
  103c15:	66 90                	xchg   %ax,%ax
  103c17:	66 90                	xchg   %ax,%ax
  103c19:	66 90                	xchg   %ax,%ax
  103c1b:	66 90                	xchg   %ax,%ax
  103c1d:	66 90                	xchg   %ax,%ax
  103c1f:	90                   	nop

00103c20 <elf_load>:

/*
 * Load elf execution file exe to the virtual address space pmap.
 */
void elf_load(void *exe_ptr, int pid)
{
  103c20:	55                   	push   %ebp
  103c21:	57                   	push   %edi
  103c22:	56                   	push   %esi
  103c23:	53                   	push   %ebx
  103c24:	83 ec 2c             	sub    $0x2c,%esp
  103c27:	e8 11 c7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  103c2c:	81 c3 c8 b3 00 00    	add    $0xb3c8,%ebx
    char *strtab __attribute__((unused));
    uintptr_t exe = (uintptr_t) exe_ptr;

    eh = (elfhdr *) exe;

    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  103c32:	8b 44 24 40          	mov    0x40(%esp),%eax
  103c36:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
  103c3c:	75 3f                	jne    103c7d <elf_load+0x5d>
    KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  103c3e:	8b 44 24 40          	mov    0x40(%esp),%eax
  103c42:	66 83 78 32 00       	cmpw   $0x0,0x32(%eax)
  103c47:	74 55                	je     103c9e <elf_load+0x7e>

    sh = (sechdr *) ((uintptr_t) eh + eh->e_shoff);
  103c49:	8b 44 24 40          	mov    0x40(%esp),%eax
  103c4d:	89 c2                	mov    %eax,%edx
  103c4f:	03 50 20             	add    0x20(%eax),%edx
    esh = sh + eh->e_shnum;

    strtab = (char *) (exe + sh[eh->e_shstrndx].sh_offset);
  103c52:	0f b7 40 32          	movzwl 0x32(%eax),%eax
  103c56:	8d 04 80             	lea    (%eax,%eax,4),%eax
    KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  103c59:	83 7c c2 04 03       	cmpl   $0x3,0x4(%edx,%eax,8)
  103c5e:	75 5f                	jne    103cbf <elf_load+0x9f>

    ph = (proghdr *) ((uintptr_t) eh + eh->e_phoff);
  103c60:	8b 44 24 40          	mov    0x40(%esp),%eax
  103c64:	89 c2                	mov    %eax,%edx
  103c66:	03 50 1c             	add    0x1c(%eax),%edx
  103c69:	89 d5                	mov    %edx,%ebp
    eph = ph + eh->e_phnum;
  103c6b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  103c6f:	c1 e0 05             	shl    $0x5,%eax
  103c72:	01 d0                	add    %edx,%eax
  103c74:	89 44 24 18          	mov    %eax,0x18(%esp)

    for (; ph < eph; ph++) {
  103c78:	e9 26 01 00 00       	jmp    103da3 <elf_load+0x183>
    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  103c7d:	8d 83 0e 93 ff ff    	lea    -0x6cf2(%ebx),%eax
  103c83:	50                   	push   %eax
  103c84:	8d 83 b1 90 ff ff    	lea    -0x6f4f(%ebx),%eax
  103c8a:	50                   	push   %eax
  103c8b:	6a 1e                	push   $0x1e
  103c8d:	8d 83 27 93 ff ff    	lea    -0x6cd9(%ebx),%eax
  103c93:	50                   	push   %eax
  103c94:	e8 76 ed ff ff       	call   102a0f <debug_panic>
  103c99:	83 c4 10             	add    $0x10,%esp
  103c9c:	eb a0                	jmp    103c3e <elf_load+0x1e>
    KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  103c9e:	8d 83 fc 9a ff ff    	lea    -0x6504(%ebx),%eax
  103ca4:	50                   	push   %eax
  103ca5:	8d 83 b1 90 ff ff    	lea    -0x6f4f(%ebx),%eax
  103cab:	50                   	push   %eax
  103cac:	6a 1f                	push   $0x1f
  103cae:	8d 83 27 93 ff ff    	lea    -0x6cd9(%ebx),%eax
  103cb4:	50                   	push   %eax
  103cb5:	e8 55 ed ff ff       	call   102a0f <debug_panic>
  103cba:	83 c4 10             	add    $0x10,%esp
  103cbd:	eb 8a                	jmp    103c49 <elf_load+0x29>
    KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  103cbf:	8d 83 1c 9b ff ff    	lea    -0x64e4(%ebx),%eax
  103cc5:	50                   	push   %eax
  103cc6:	8d 83 b1 90 ff ff    	lea    -0x6f4f(%ebx),%eax
  103ccc:	50                   	push   %eax
  103ccd:	6a 25                	push   $0x25
  103ccf:	8d 83 27 93 ff ff    	lea    -0x6cd9(%ebx),%eax
  103cd5:	50                   	push   %eax
  103cd6:	e8 34 ed ff ff       	call   102a0f <debug_panic>
  103cdb:	83 c4 10             	add    $0x10,%esp
  103cde:	eb 80                	jmp    103c60 <elf_load+0x40>
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
            alloc_page(pid, va, perm);

            if (va < rounddown(zva, PAGESIZE)) {
                /* copy a complete page */
                pt_copyout((void *) fa, pid, va, PAGESIZE);
  103ce0:	68 00 10 00 00       	push   $0x1000
  103ce5:	56                   	push   %esi
  103ce6:	55                   	push   %ebp
  103ce7:	57                   	push   %edi
  103ce8:	e8 82 fd ff ff       	call   103a6f <pt_copyout>
  103ced:	83 c4 10             	add    $0x10,%esp
  103cf0:	eb 11                	jmp    103d03 <elf_load+0xe3>
                /* copy a partial page */
                pt_memset(pid, va, 0, PAGESIZE);
                pt_copyout((void *) fa, pid, va, zva - va);
            } else {
                /* zero a page */
                pt_memset(pid, va, 0, PAGESIZE);
  103cf2:	68 00 10 00 00       	push   $0x1000
  103cf7:	6a 00                	push   $0x0
  103cf9:	56                   	push   %esi
  103cfa:	55                   	push   %ebp
  103cfb:	e8 63 fe ff ff       	call   103b63 <pt_memset>
  103d00:	83 c4 10             	add    $0x10,%esp
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  103d03:	81 c6 00 10 00 00    	add    $0x1000,%esi
  103d09:	81 c7 00 10 00 00    	add    $0x1000,%edi
  103d0f:	8b 44 24 10          	mov    0x10(%esp),%eax
  103d13:	39 c6                	cmp    %eax,%esi
  103d15:	73 6c                	jae    103d83 <elf_load+0x163>
            alloc_page(pid, va, perm);
  103d17:	83 ec 04             	sub    $0x4,%esp
  103d1a:	ff 74 24 18          	push   0x18(%esp)
  103d1e:	56                   	push   %esi
  103d1f:	55                   	push   %ebp
  103d20:	e8 7b 20 00 00       	call   105da0 <alloc_page>
            if (va < rounddown(zva, PAGESIZE)) {
  103d25:	83 c4 08             	add    $0x8,%esp
  103d28:	68 00 10 00 00       	push   $0x1000
  103d2d:	ff 74 24 18          	push   0x18(%esp)
  103d31:	e8 f0 f7 ff ff       	call   103526 <rounddown>
  103d36:	83 c4 10             	add    $0x10,%esp
  103d39:	39 c6                	cmp    %eax,%esi
  103d3b:	72 a3                	jb     103ce0 <elf_load+0xc0>
            } else if (va < zva && ph->p_filesz) {
  103d3d:	8b 44 24 0c          	mov    0xc(%esp),%eax
  103d41:	39 c6                	cmp    %eax,%esi
  103d43:	73 ad                	jae    103cf2 <elf_load+0xd2>
  103d45:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  103d49:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  103d4d:	74 a3                	je     103cf2 <elf_load+0xd2>
                pt_memset(pid, va, 0, PAGESIZE);
  103d4f:	68 00 10 00 00       	push   $0x1000
  103d54:	6a 00                	push   $0x0
  103d56:	56                   	push   %esi
  103d57:	55                   	push   %ebp
  103d58:	e8 06 fe ff ff       	call   103b63 <pt_memset>
                pt_copyout((void *) fa, pid, va, zva - va);
  103d5d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  103d61:	29 f0                	sub    %esi,%eax
  103d63:	50                   	push   %eax
  103d64:	56                   	push   %esi
  103d65:	55                   	push   %ebp
  103d66:	57                   	push   %edi
  103d67:	e8 03 fd ff ff       	call   103a6f <pt_copyout>
  103d6c:	83 c4 20             	add    $0x20,%esp
  103d6f:	eb 92                	jmp    103d03 <elf_load+0xe3>
            perm |= PTE_W;
  103d71:	c7 44 24 14 07 00 00 	movl   $0x7,0x14(%esp)
  103d78:	00 
  103d79:	89 6c 24 1c          	mov    %ebp,0x1c(%esp)
  103d7d:	8b 6c 24 44          	mov    0x44(%esp),%ebp
  103d81:	eb 8c                	jmp    103d0f <elf_load+0xef>
  103d83:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
  103d87:	eb 17                	jmp    103da0 <elf_load+0x180>
  103d89:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  103d90:	00 
  103d91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  103d98:	00 
  103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (; ph < eph; ph++) {
  103da0:	83 c5 20             	add    $0x20,%ebp
  103da3:	8b 44 24 18          	mov    0x18(%esp),%eax
  103da7:	39 c5                	cmp    %eax,%ebp
  103da9:	73 73                	jae    103e1e <elf_load+0x1fe>
        if (ph->p_type != ELF_PROG_LOAD)
  103dab:	83 7d 00 01          	cmpl   $0x1,0x0(%ebp)
  103daf:	75 ef                	jne    103da0 <elf_load+0x180>
        fa = (uintptr_t) eh + rounddown(ph->p_offset, PAGESIZE);
  103db1:	83 ec 08             	sub    $0x8,%esp
  103db4:	68 00 10 00 00       	push   $0x1000
  103db9:	ff 75 04             	push   0x4(%ebp)
  103dbc:	e8 65 f7 ff ff       	call   103526 <rounddown>
  103dc1:	03 44 24 50          	add    0x50(%esp),%eax
  103dc5:	89 c7                	mov    %eax,%edi
        va = rounddown(ph->p_va, PAGESIZE);
  103dc7:	83 c4 08             	add    $0x8,%esp
  103dca:	68 00 10 00 00       	push   $0x1000
  103dcf:	ff 75 08             	push   0x8(%ebp)
  103dd2:	e8 4f f7 ff ff       	call   103526 <rounddown>
  103dd7:	89 c6                	mov    %eax,%esi
        zva = ph->p_va + ph->p_filesz;
  103dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  103ddc:	89 c1                	mov    %eax,%ecx
  103dde:	03 4d 10             	add    0x10(%ebp),%ecx
  103de1:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        eva = roundup(ph->p_va + ph->p_memsz, PAGESIZE);
  103de5:	8b 55 14             	mov    0x14(%ebp),%edx
  103de8:	83 c4 08             	add    $0x8,%esp
  103deb:	68 00 10 00 00       	push   $0x1000
  103df0:	01 d0                	add    %edx,%eax
  103df2:	50                   	push   %eax
  103df3:	e8 42 f7 ff ff       	call   10353a <roundup>
  103df8:	89 44 24 20          	mov    %eax,0x20(%esp)
        if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  103dfc:	83 c4 10             	add    $0x10,%esp
  103dff:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
  103e03:	0f 85 68 ff ff ff    	jne    103d71 <elf_load+0x151>
        perm = PTE_U | PTE_P;
  103e09:	c7 44 24 14 05 00 00 	movl   $0x5,0x14(%esp)
  103e10:	00 
  103e11:	89 6c 24 1c          	mov    %ebp,0x1c(%esp)
  103e15:	8b 6c 24 44          	mov    0x44(%esp),%ebp
  103e19:	e9 f1 fe ff ff       	jmp    103d0f <elf_load+0xef>
            }
        }
    }
}
  103e1e:	83 c4 2c             	add    $0x2c,%esp
  103e21:	5b                   	pop    %ebx
  103e22:	5e                   	pop    %esi
  103e23:	5f                   	pop    %edi
  103e24:	5d                   	pop    %ebp
  103e25:	c3                   	ret

00103e26 <elf_entry>:

uintptr_t elf_entry(void *exe_ptr)
{
  103e26:	56                   	push   %esi
  103e27:	53                   	push   %ebx
  103e28:	83 ec 04             	sub    $0x4,%esp
  103e2b:	e8 0d c5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  103e30:	81 c3 c4 b1 00 00    	add    $0xb1c4,%ebx
  103e36:	8b 74 24 10          	mov    0x10(%esp),%esi
    uintptr_t exe = (uintptr_t) exe_ptr;
    elfhdr *eh = (elfhdr *) exe;
    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  103e3a:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  103e40:	75 09                	jne    103e4b <elf_entry+0x25>
    return (uintptr_t) eh->e_entry;
  103e42:	8b 46 18             	mov    0x18(%esi),%eax
}
  103e45:	83 c4 04             	add    $0x4,%esp
  103e48:	5b                   	pop    %ebx
  103e49:	5e                   	pop    %esi
  103e4a:	c3                   	ret
    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  103e4b:	8d 83 0e 93 ff ff    	lea    -0x6cf2(%ebx),%eax
  103e51:	50                   	push   %eax
  103e52:	8d 83 b1 90 ff ff    	lea    -0x6f4f(%ebx),%eax
  103e58:	50                   	push   %eax
  103e59:	6a 50                	push   $0x50
  103e5b:	8d 83 27 93 ff ff    	lea    -0x6cd9(%ebx),%eax
  103e61:	50                   	push   %eax
  103e62:	e8 a8 eb ff ff       	call   102a0f <debug_panic>
  103e67:	83 c4 10             	add    $0x10,%esp
  103e6a:	eb d6                	jmp    103e42 <elf_entry+0x1c>
  103e6c:	66 90                	xchg   %ax,%ax
  103e6e:	66 90                	xchg   %ax,%ax

00103e70 <kern_init>:
    monitor(NULL);
#endif
}

void kern_init(uintptr_t mbi_addr)
{
  103e70:	56                   	push   %esi
  103e71:	53                   	push   %ebx
  103e72:	e8 c6 c4 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  103e77:	81 c3 7d b1 00 00    	add    $0xb17d,%ebx
  103e7d:	83 ec 10             	sub    $0x10,%esp
    thread_init(mbi_addr);
  103e80:	ff 74 24 1c          	push   0x1c(%esp)
  103e84:	e8 a7 2b 00 00       	call   106a30 <thread_init>

    KERN_DEBUG("Kernel initialized.\n");
  103e89:	8d b3 4b 93 ff ff    	lea    -0x6cb5(%ebx),%esi
  103e8f:	83 c4 0c             	add    $0xc,%esp
  103e92:	8d 83 36 93 ff ff    	lea    -0x6cca(%ebx),%eax
  103e98:	50                   	push   %eax
  103e99:	6a 3b                	push   $0x3b
  103e9b:	56                   	push   %esi
  103e9c:	e8 35 eb ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("In kernel main.\n\n");
  103ea1:	83 c4 0c             	add    $0xc,%esp
  103ea4:	8d 83 5c 93 ff ff    	lea    -0x6ca4(%ebx),%eax
  103eaa:	50                   	push   %eax
  103eab:	6a 0f                	push   $0xf
  103ead:	56                   	push   %esi
  103eae:	e8 23 eb ff ff       	call   1029d6 <debug_normal>
    dprintf("Testing the PKCtxNew layer...\n");
  103eb3:	8d 83 4c 9b ff ff    	lea    -0x64b4(%ebx),%eax
  103eb9:	89 04 24             	mov    %eax,(%esp)
  103ebc:	e8 e1 ec ff ff       	call   102ba2 <dprintf>
    if (test_PKCtxNew() == 0) {
  103ec1:	e8 4a 22 00 00       	call   106110 <test_PKCtxNew>
  103ec6:	83 c4 10             	add    $0x10,%esp
  103ec9:	84 c0                	test   %al,%al
  103ecb:	0f 85 df 00 00 00    	jne    103fb0 <kern_init+0x140>
      dprintf("All tests passed.\n");
  103ed1:	83 ec 0c             	sub    $0xc,%esp
  103ed4:	8d 83 6e 93 ff ff    	lea    -0x6c92(%ebx),%eax
  103eda:	50                   	push   %eax
  103edb:	e8 c2 ec ff ff       	call   102ba2 <dprintf>
  103ee0:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103ee3:	83 ec 0c             	sub    $0xc,%esp
  103ee6:	8d b3 6c 93 ff ff    	lea    -0x6c94(%ebx),%esi
  103eec:	56                   	push   %esi
  103eed:	e8 b0 ec ff ff       	call   102ba2 <dprintf>
    dprintf("Testing the PTCBInit layer...\n");
  103ef2:	8d 83 6c 9b ff ff    	lea    -0x6494(%ebx),%eax
  103ef8:	89 04 24             	mov    %eax,(%esp)
  103efb:	e8 a2 ec ff ff       	call   102ba2 <dprintf>
    if (test_PTCBInit() == 0) {
  103f00:	e8 2b 24 00 00       	call   106330 <test_PTCBInit>
  103f05:	83 c4 10             	add    $0x10,%esp
  103f08:	84 c0                	test   %al,%al
  103f0a:	0f 85 f0 00 00 00    	jne    104000 <kern_init+0x190>
      dprintf("All tests passed.\n");
  103f10:	83 ec 0c             	sub    $0xc,%esp
  103f13:	8d 83 6e 93 ff ff    	lea    -0x6c92(%ebx),%eax
  103f19:	50                   	push   %eax
  103f1a:	e8 83 ec ff ff       	call   102ba2 <dprintf>
  103f1f:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103f22:	83 ec 0c             	sub    $0xc,%esp
  103f25:	56                   	push   %esi
  103f26:	e8 77 ec ff ff       	call   102ba2 <dprintf>
    dprintf("Testing the PTQueueInit layer...\n");
  103f2b:	8d 83 8c 9b ff ff    	lea    -0x6474(%ebx),%eax
  103f31:	89 04 24             	mov    %eax,(%esp)
  103f34:	e8 69 ec ff ff       	call   102ba2 <dprintf>
    if (test_PTQueueInit() == 0) {
  103f39:	e8 92 2a 00 00       	call   1069d0 <test_PTQueueInit>
  103f3e:	83 c4 10             	add    $0x10,%esp
  103f41:	84 c0                	test   %al,%al
  103f43:	0f 85 9f 00 00 00    	jne    103fe8 <kern_init+0x178>
      dprintf("All tests passed.\n");
  103f49:	83 ec 0c             	sub    $0xc,%esp
  103f4c:	8d 83 6e 93 ff ff    	lea    -0x6c92(%ebx),%eax
  103f52:	50                   	push   %eax
  103f53:	e8 4a ec ff ff       	call   102ba2 <dprintf>
  103f58:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103f5b:	83 ec 0c             	sub    $0xc,%esp
  103f5e:	56                   	push   %esi
  103f5f:	e8 3e ec ff ff       	call   102ba2 <dprintf>
    dprintf("Testing the PThread layer...\n");
  103f64:	8d 83 8f 93 ff ff    	lea    -0x6c71(%ebx),%eax
  103f6a:	89 04 24             	mov    %eax,(%esp)
  103f6d:	e8 30 ec ff ff       	call   102ba2 <dprintf>
    if (test_PThread() == 0) {
  103f72:	e8 59 2c 00 00       	call   106bd0 <test_PThread>
  103f77:	83 c4 10             	add    $0x10,%esp
  103f7a:	84 c0                	test   %al,%al
  103f7c:	75 52                	jne    103fd0 <kern_init+0x160>
      dprintf("All tests passed.\n");
  103f7e:	83 ec 0c             	sub    $0xc,%esp
  103f81:	8d 83 6e 93 ff ff    	lea    -0x6c92(%ebx),%eax
  103f87:	50                   	push   %eax
  103f88:	e8 15 ec ff ff       	call   102ba2 <dprintf>
  103f8d:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103f90:	83 ec 0c             	sub    $0xc,%esp
  103f93:	56                   	push   %esi
  103f94:	e8 09 ec ff ff       	call   102ba2 <dprintf>
    dprintf("\nTest complete. Please Use Ctrl-a x to exit qemu.");
  103f99:	8d 83 b0 9b ff ff    	lea    -0x6450(%ebx),%eax
  103f9f:	89 04 24             	mov    %eax,(%esp)
  103fa2:	e8 fb eb ff ff       	call   102ba2 <dprintf>

    kern_main();
}
  103fa7:	83 c4 14             	add    $0x14,%esp
  103faa:	5b                   	pop    %ebx
  103fab:	5e                   	pop    %esi
  103fac:	c3                   	ret
  103fad:	8d 76 00             	lea    0x0(%esi),%esi
        dprintf("Test failed.\n");
  103fb0:	83 ec 0c             	sub    $0xc,%esp
  103fb3:	8d 83 81 93 ff ff    	lea    -0x6c7f(%ebx),%eax
  103fb9:	50                   	push   %eax
  103fba:	e8 e3 eb ff ff       	call   102ba2 <dprintf>
  103fbf:	83 c4 10             	add    $0x10,%esp
  103fc2:	e9 1c ff ff ff       	jmp    103ee3 <kern_init+0x73>
  103fc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  103fce:	00 
  103fcf:	90                   	nop
        dprintf("Test failed.\n");
  103fd0:	83 ec 0c             	sub    $0xc,%esp
  103fd3:	8d 83 81 93 ff ff    	lea    -0x6c7f(%ebx),%eax
  103fd9:	50                   	push   %eax
  103fda:	e8 c3 eb ff ff       	call   102ba2 <dprintf>
  103fdf:	83 c4 10             	add    $0x10,%esp
  103fe2:	eb ac                	jmp    103f90 <kern_init+0x120>
  103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        dprintf("Test failed.\n");
  103fe8:	83 ec 0c             	sub    $0xc,%esp
  103feb:	8d 83 81 93 ff ff    	lea    -0x6c7f(%ebx),%eax
  103ff1:	50                   	push   %eax
  103ff2:	e8 ab eb ff ff       	call   102ba2 <dprintf>
  103ff7:	83 c4 10             	add    $0x10,%esp
  103ffa:	e9 5c ff ff ff       	jmp    103f5b <kern_init+0xeb>
  103fff:	90                   	nop
        dprintf("Test failed.\n");
  104000:	83 ec 0c             	sub    $0xc,%esp
  104003:	8d 83 81 93 ff ff    	lea    -0x6c7f(%ebx),%eax
  104009:	50                   	push   %eax
  10400a:	e8 93 eb ff ff       	call   102ba2 <dprintf>
  10400f:	83 c4 10             	add    $0x10,%esp
  104012:	e9 0b ff ff ff       	jmp    103f22 <kern_init+0xb2>
  104017:	90                   	nop
  104018:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
  10401e:	00 00                	add    %al,(%eax)
  104020:	fb                   	sti
  104021:	4f                   	dec    %edi
  104022:	52                   	push   %edx
  104023:	e4                   	.byte 0xe4

00104024 <start>:
	.long CHECKSUM

	/* this is the entry of the kernel */
	.globl start
start:
	cli
  104024:	fa                   	cli

	/* check whether the bootloader provide multiboot information */
	cmpl	$MULTIBOOT_BOOTLOADER_MAGIC, %eax
  104025:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
	jne	spin
  10402a:	75 27                	jne    104053 <spin>
	movl	%ebx, multiboot_ptr
  10402c:	89 1d 54 40 10 00    	mov    %ebx,0x104054

	/* tell BIOS to warmboot next time */
	movw	$0x1234, 0x472
  104032:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  104039:	34 12 

	/* clear EFLAGS */
	pushl	$0x2
  10403b:	6a 02                	push   $0x2
	popfl
  10403d:	9d                   	popf

	/* prepare the kernel stack */
	movl	$0x0, %ebp
  10403e:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl	$(bsp_kstack + 4096), %esp
  104043:	bc 00 f0 17 00       	mov    $0x17f000,%esp

	/* jump to the C code */
	push	multiboot_ptr
  104048:	ff 35 54 40 10 00    	push   0x104054
	call	kern_init
  10404e:	e8 1d fe ff ff       	call   103e70 <kern_init>

00104053 <spin>:

	/* should not be here */
spin:
	hlt
  104053:	f4                   	hlt

00104054 <multiboot_ptr>:
  104054:	00 00                	add    %al,(%eax)
  104056:	00 00                	add    %al,(%eax)
  104058:	66 90                	xchg   %ax,%ax
  10405a:	66 90                	xchg   %ax,%ax
  10405c:	66 90                	xchg   %ax,%ax
  10405e:	66 90                	xchg   %ax,%ax

00104060 <get_nps>:
static struct ATStruct AT[1 << 20];

// The getter function for NUM_PAGES.
unsigned int get_nps(void)
{
    return NUM_PAGES;
  104060:	e8 c5 cd ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  104065:	05 8f af 00 00       	add    $0xaf8f,%eax
  10406a:	8b 80 0c 01 87 00    	mov    0x87010c(%eax),%eax
}
  104070:	c3                   	ret
  104071:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104078:	00 
  104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104080 <set_nps>:

// The setter function for NUM_PAGES.
void set_nps(unsigned int nps)
{
    NUM_PAGES = nps;
  104080:	e8 a5 cd ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  104085:	05 6f af 00 00       	add    $0xaf6f,%eax
  10408a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10408e:	89 90 0c 01 87 00    	mov    %edx,0x87010c(%eax)
}
  104094:	c3                   	ret
  104095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10409c:	00 
  10409d:	8d 76 00             	lea    0x0(%esi),%esi

001040a0 <at_is_norm>:
 * If the page with the given index has the normal permission,
 * then returns 1, otherwise returns 0.
 */
unsigned int at_is_norm(unsigned int page_index)
{
    return AT[page_index].perm > 1? 1: 0;
  1040a0:	e8 85 cd ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  1040a5:	05 4f af 00 00       	add    $0xaf4f,%eax
  1040aa:	8b 54 24 04          	mov    0x4(%esp),%edx
  1040ae:	83 bc d0 0c 01 07 00 	cmpl   $0x1,0x7010c(%eax,%edx,8)
  1040b5:	01 
  1040b6:	0f 97 c0             	seta   %al
  1040b9:	0f b6 c0             	movzbl %al,%eax
}
  1040bc:	c3                   	ret
  1040bd:	8d 76 00             	lea    0x0(%esi),%esi

001040c0 <at_set_perm>:
 * Sets the permission of the page with given index.
 * It also marks the page as unallocated.
 */
void at_set_perm(unsigned int page_index, unsigned int perm)
{
    AT[page_index].perm=perm;
  1040c0:	e8 65 cd ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  1040c5:	05 2f af 00 00       	add    $0xaf2f,%eax
{
  1040ca:	8b 54 24 04          	mov    0x4(%esp),%edx
    AT[page_index].perm=perm;
  1040ce:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    AT[page_index].allocated=0;
  1040d2:	c7 84 d0 10 01 07 00 	movl   $0x0,0x70110(%eax,%edx,8)
  1040d9:	00 00 00 00 
    AT[page_index].perm=perm;
  1040dd:	89 8c d0 0c 01 07 00 	mov    %ecx,0x7010c(%eax,%edx,8)
}
  1040e4:	c3                   	ret
  1040e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1040ec:	00 
  1040ed:	8d 76 00             	lea    0x0(%esi),%esi

001040f0 <at_is_allocated>:
 * The getter function for the physical page allocation flag.
 * Returns 0 if the page is not allocated, otherwise returns 1.
 */
unsigned int at_is_allocated(unsigned int page_index)
{
   return AT[page_index].allocated > 0? 1: 0;
  1040f0:	e8 35 cd ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  1040f5:	05 ff ae 00 00       	add    $0xaeff,%eax
  1040fa:	8b 54 24 04          	mov    0x4(%esp),%edx
  1040fe:	8b 84 d0 10 01 07 00 	mov    0x70110(%eax,%edx,8),%eax
  104105:	85 c0                	test   %eax,%eax
  104107:	0f 95 c0             	setne  %al
  10410a:	0f b6 c0             	movzbl %al,%eax
}
  10410d:	c3                   	ret
  10410e:	66 90                	xchg   %ax,%ax

00104110 <at_set_allocated>:
 * The setter function for the physical page allocation flag.
 * Set the flag of the page with given index to the given value.
 */
void at_set_allocated(unsigned int page_index, unsigned int allocated)
{
   AT[page_index].allocated=allocated;
  104110:	e8 15 cd ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  104115:	05 df ae 00 00       	add    $0xaedf,%eax
  10411a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10411e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  104122:	89 8c d0 10 01 07 00 	mov    %ecx,0x70110(%eax,%edx,8)
  104129:	c3                   	ret
  10412a:	66 90                	xchg   %ax,%ax
  10412c:	66 90                	xchg   %ax,%ax
  10412e:	66 90                	xchg   %ax,%ax

00104130 <MATIntro_test1>:
#include <lib/debug.h>
#include "export.h"

int MATIntro_test1()
{
  104130:	55                   	push   %ebp
  104131:	57                   	push   %edi
  104132:	56                   	push   %esi
    int rn10[] = { 1, 3, 5, 6, 78, 3576, 32, 8, 0, 100 };
    int i;
    int nps = get_nps();
    for (i = 0; i < 10; i++) {
  104133:	31 f6                	xor    %esi,%esi
{
  104135:	53                   	push   %ebx
  104136:	e8 02 c2 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10413b:	81 c3 b9 ae 00 00    	add    $0xaeb9,%ebx
  104141:	83 ec 4c             	sub    $0x4c,%esp
    int rn10[] = { 1, 3, 5, 6, 78, 3576, 32, 8, 0, 100 };
  104144:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%esp)
  10414b:	00 
  10414c:	8d 7c 24 18          	lea    0x18(%esp),%edi
  104150:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
  104157:	00 
  104158:	c7 44 24 20 05 00 00 	movl   $0x5,0x20(%esp)
  10415f:	00 
  104160:	c7 44 24 24 06 00 00 	movl   $0x6,0x24(%esp)
  104167:	00 
  104168:	c7 44 24 28 4e 00 00 	movl   $0x4e,0x28(%esp)
  10416f:	00 
  104170:	c7 44 24 2c f8 0d 00 	movl   $0xdf8,0x2c(%esp)
  104177:	00 
  104178:	c7 44 24 30 20 00 00 	movl   $0x20,0x30(%esp)
  10417f:	00 
  104180:	c7 44 24 34 08 00 00 	movl   $0x8,0x34(%esp)
  104187:	00 
  104188:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%esp)
  10418f:	00 
  104190:	c7 44 24 3c 64 00 00 	movl   $0x64,0x3c(%esp)
  104197:	00 
    int nps = get_nps();
  104198:	e8 c3 fe ff ff       	call   104060 <get_nps>
  10419d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    for (i = 0; i < 10; i++) {
  1041a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1041a8:	00 
  1041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        set_nps(rn10[i]);
  1041b0:	8b 2c b7             	mov    (%edi,%esi,4),%ebp
  1041b3:	83 ec 0c             	sub    $0xc,%esp
  1041b6:	55                   	push   %ebp
  1041b7:	e8 c4 fe ff ff       	call   104080 <set_nps>
        if (get_nps() != rn10[i]) {
  1041bc:	e8 9f fe ff ff       	call   104060 <get_nps>
  1041c1:	83 c4 10             	add    $0x10,%esp
  1041c4:	39 c5                	cmp    %eax,%ebp
  1041c6:	75 38                	jne    104200 <MATIntro_test1+0xd0>
    for (i = 0; i < 10; i++) {
  1041c8:	83 c6 01             	add    $0x1,%esi
  1041cb:	83 fe 0a             	cmp    $0xa,%esi
  1041ce:	75 e0                	jne    1041b0 <MATIntro_test1+0x80>
            dprintf("test 1.1 failed (i = %d): (%d != %d)\n", i, get_nps(), rn10[i]);
            set_nps(nps);
            return 1;
        }
    }
    set_nps(nps);
  1041d0:	83 ec 0c             	sub    $0xc,%esp
  1041d3:	ff 74 24 18          	push   0x18(%esp)
  1041d7:	e8 a4 fe ff ff       	call   104080 <set_nps>
    dprintf("test 1 passed.\n");
  1041dc:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  1041e2:	89 04 24             	mov    %eax,(%esp)
  1041e5:	e8 b8 e9 ff ff       	call   102ba2 <dprintf>
    return 0;
  1041ea:	83 c4 10             	add    $0x10,%esp
  1041ed:	31 c0                	xor    %eax,%eax
}
  1041ef:	83 c4 4c             	add    $0x4c,%esp
  1041f2:	5b                   	pop    %ebx
  1041f3:	5e                   	pop    %esi
  1041f4:	5f                   	pop    %edi
  1041f5:	5d                   	pop    %ebp
  1041f6:	c3                   	ret
  1041f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1041fe:	00 
  1041ff:	90                   	nop
            dprintf("test 1.1 failed (i = %d): (%d != %d)\n", i, get_nps(), rn10[i]);
  104200:	e8 5b fe ff ff       	call   104060 <get_nps>
  104205:	55                   	push   %ebp
  104206:	50                   	push   %eax
  104207:	8d 83 e4 9b ff ff    	lea    -0x641c(%ebx),%eax
  10420d:	56                   	push   %esi
  10420e:	50                   	push   %eax
  10420f:	e8 8e e9 ff ff       	call   102ba2 <dprintf>
            set_nps(nps);
  104214:	58                   	pop    %eax
  104215:	ff 74 24 18          	push   0x18(%esp)
  104219:	e8 62 fe ff ff       	call   104080 <set_nps>
            return 1;
  10421e:	83 c4 10             	add    $0x10,%esp
  104221:	b8 01 00 00 00       	mov    $0x1,%eax
}
  104226:	83 c4 4c             	add    $0x4c,%esp
  104229:	5b                   	pop    %ebx
  10422a:	5e                   	pop    %esi
  10422b:	5f                   	pop    %edi
  10422c:	5d                   	pop    %ebp
  10422d:	c3                   	ret
  10422e:	66 90                	xchg   %ax,%ax

00104230 <MATIntro_test2>:

int MATIntro_test2()
{
  104230:	56                   	push   %esi
  104231:	53                   	push   %ebx
  104232:	e8 06 c1 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104237:	81 c3 bd ad 00 00    	add    $0xadbd,%ebx
  10423d:	83 ec 0c             	sub    $0xc,%esp
    at_set_perm(0, 0);
  104240:	6a 00                	push   $0x0
  104242:	6a 00                	push   $0x0
  104244:	e8 77 fe ff ff       	call   1040c0 <at_set_perm>
    if (at_is_norm(0) != 0 || at_is_allocated(0) != 0) {
  104249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104250:	e8 4b fe ff ff       	call   1040a0 <at_is_norm>
  104255:	83 c4 10             	add    $0x10,%esp
  104258:	85 c0                	test   %eax,%eax
  10425a:	75 11                	jne    10426d <MATIntro_test2+0x3d>
  10425c:	83 ec 0c             	sub    $0xc,%esp
  10425f:	6a 00                	push   $0x0
  104261:	e8 8a fe ff ff       	call   1040f0 <at_is_allocated>
  104266:	83 c4 10             	add    $0x10,%esp
  104269:	85 c0                	test   %eax,%eax
  10426b:	74 43                	je     1042b0 <MATIntro_test2+0x80>
        dprintf("test 2.1 failed: (%d != 0 || %d != 0)\n", at_is_norm(0), at_is_allocated(0));
  10426d:	83 ec 0c             	sub    $0xc,%esp
  104270:	6a 00                	push   $0x0
  104272:	e8 79 fe ff ff       	call   1040f0 <at_is_allocated>
  104277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10427e:	89 c6                	mov    %eax,%esi
  104280:	e8 1b fe ff ff       	call   1040a0 <at_is_norm>
  104285:	83 c4 0c             	add    $0xc,%esp
  104288:	56                   	push   %esi
  104289:	50                   	push   %eax
  10428a:	8d 83 0c 9c ff ff    	lea    -0x63f4(%ebx),%eax
        at_set_perm(0, 0);
        return 1;
    }
    at_set_perm(0, 1);
    if (at_is_norm(0) != 0 || at_is_allocated(0) != 0) {
        dprintf("test 2.2 failed: (%d != 0 || %d != 0)\n", at_is_norm(0), at_is_allocated(0));
  104290:	50                   	push   %eax
  104291:	e8 0c e9 ff ff       	call   102ba2 <dprintf>
        at_set_perm(0, 0);
  104296:	58                   	pop    %eax
  104297:	5a                   	pop    %edx
  104298:	6a 00                	push   $0x0
  10429a:	6a 00                	push   $0x0
  10429c:	e8 1f fe ff ff       	call   1040c0 <at_set_perm>
        return 1;
  1042a1:	83 c4 10             	add    $0x10,%esp
        return 1;
  1042a4:	b8 01 00 00 00       	mov    $0x1,%eax
        return 1;
    }
    at_set_perm(0, 0);
    dprintf("test 2 passed.\n");
    return 0;
}
  1042a9:	83 c4 04             	add    $0x4,%esp
  1042ac:	5b                   	pop    %ebx
  1042ad:	5e                   	pop    %esi
  1042ae:	c3                   	ret
  1042af:	90                   	nop
    at_set_perm(0, 1);
  1042b0:	83 ec 08             	sub    $0x8,%esp
  1042b3:	6a 01                	push   $0x1
  1042b5:	6a 00                	push   $0x0
  1042b7:	e8 04 fe ff ff       	call   1040c0 <at_set_perm>
    if (at_is_norm(0) != 0 || at_is_allocated(0) != 0) {
  1042bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1042c3:	e8 d8 fd ff ff       	call   1040a0 <at_is_norm>
  1042c8:	83 c4 10             	add    $0x10,%esp
  1042cb:	85 c0                	test   %eax,%eax
  1042cd:	75 11                	jne    1042e0 <MATIntro_test2+0xb0>
  1042cf:	83 ec 0c             	sub    $0xc,%esp
  1042d2:	6a 00                	push   $0x0
  1042d4:	e8 17 fe ff ff       	call   1040f0 <at_is_allocated>
  1042d9:	83 c4 10             	add    $0x10,%esp
  1042dc:	85 c0                	test   %eax,%eax
  1042de:	74 28                	je     104308 <MATIntro_test2+0xd8>
        dprintf("test 2.2 failed: (%d != 0 || %d != 0)\n", at_is_norm(0), at_is_allocated(0));
  1042e0:	83 ec 0c             	sub    $0xc,%esp
  1042e3:	6a 00                	push   $0x0
  1042e5:	e8 06 fe ff ff       	call   1040f0 <at_is_allocated>
  1042ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1042f1:	89 c6                	mov    %eax,%esi
  1042f3:	e8 a8 fd ff ff       	call   1040a0 <at_is_norm>
  1042f8:	83 c4 0c             	add    $0xc,%esp
  1042fb:	56                   	push   %esi
  1042fc:	50                   	push   %eax
  1042fd:	8d 83 34 9c ff ff    	lea    -0x63cc(%ebx),%eax
  104303:	eb 8b                	jmp    104290 <MATIntro_test2+0x60>
  104305:	8d 76 00             	lea    0x0(%esi),%esi
    at_set_perm(0, 2);
  104308:	83 ec 08             	sub    $0x8,%esp
  10430b:	6a 02                	push   $0x2
  10430d:	6a 00                	push   $0x0
  10430f:	e8 ac fd ff ff       	call   1040c0 <at_set_perm>
    if (at_is_norm(0) != 1 || at_is_allocated(0) != 0) {
  104314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10431b:	e8 80 fd ff ff       	call   1040a0 <at_is_norm>
  104320:	83 c4 10             	add    $0x10,%esp
  104323:	83 f8 01             	cmp    $0x1,%eax
  104326:	75 11                	jne    104339 <MATIntro_test2+0x109>
  104328:	83 ec 0c             	sub    $0xc,%esp
  10432b:	6a 00                	push   $0x0
  10432d:	e8 be fd ff ff       	call   1040f0 <at_is_allocated>
  104332:	83 c4 10             	add    $0x10,%esp
  104335:	85 c0                	test   %eax,%eax
  104337:	74 2f                	je     104368 <MATIntro_test2+0x138>
        dprintf("test 2.3 failed: (%d != 1 || %d != 0)\n", at_is_norm(0), at_is_allocated(0));
  104339:	83 ec 0c             	sub    $0xc,%esp
  10433c:	6a 00                	push   $0x0
  10433e:	e8 ad fd ff ff       	call   1040f0 <at_is_allocated>
  104343:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10434a:	89 c6                	mov    %eax,%esi
  10434c:	e8 4f fd ff ff       	call   1040a0 <at_is_norm>
  104351:	83 c4 0c             	add    $0xc,%esp
  104354:	56                   	push   %esi
  104355:	50                   	push   %eax
  104356:	8d 83 5c 9c ff ff    	lea    -0x63a4(%ebx),%eax
  10435c:	e9 2f ff ff ff       	jmp    104290 <MATIntro_test2+0x60>
  104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    at_set_perm(0, 100);
  104368:	83 ec 08             	sub    $0x8,%esp
  10436b:	6a 64                	push   $0x64
  10436d:	6a 00                	push   $0x0
  10436f:	e8 4c fd ff ff       	call   1040c0 <at_set_perm>
    if (at_is_norm(0) != 1 || at_is_allocated(0) != 0) {
  104374:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10437b:	e8 20 fd ff ff       	call   1040a0 <at_is_norm>
  104380:	83 c4 10             	add    $0x10,%esp
  104383:	83 f8 01             	cmp    $0x1,%eax
  104386:	75 38                	jne    1043c0 <MATIntro_test2+0x190>
  104388:	83 ec 0c             	sub    $0xc,%esp
  10438b:	6a 00                	push   $0x0
  10438d:	e8 5e fd ff ff       	call   1040f0 <at_is_allocated>
  104392:	83 c4 10             	add    $0x10,%esp
  104395:	85 c0                	test   %eax,%eax
  104397:	75 27                	jne    1043c0 <MATIntro_test2+0x190>
    at_set_perm(0, 0);
  104399:	83 ec 08             	sub    $0x8,%esp
  10439c:	6a 00                	push   $0x0
  10439e:	6a 00                	push   $0x0
  1043a0:	e8 1b fd ff ff       	call   1040c0 <at_set_perm>
    dprintf("test 2 passed.\n");
  1043a5:	8d 83 bd 93 ff ff    	lea    -0x6c43(%ebx),%eax
  1043ab:	89 04 24             	mov    %eax,(%esp)
  1043ae:	e8 ef e7 ff ff       	call   102ba2 <dprintf>
    return 0;
  1043b3:	83 c4 10             	add    $0x10,%esp
  1043b6:	31 c0                	xor    %eax,%eax
  1043b8:	e9 ec fe ff ff       	jmp    1042a9 <MATIntro_test2+0x79>
  1043bd:	8d 76 00             	lea    0x0(%esi),%esi
        dprintf("test 2.4 failed: (%d != 1 || %d != 0)\n", at_is_norm(0), at_is_allocated(0));
  1043c0:	83 ec 0c             	sub    $0xc,%esp
  1043c3:	6a 00                	push   $0x0
  1043c5:	e8 26 fd ff ff       	call   1040f0 <at_is_allocated>
  1043ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1043d1:	89 c6                	mov    %eax,%esi
  1043d3:	e8 c8 fc ff ff       	call   1040a0 <at_is_norm>
  1043d8:	83 c4 0c             	add    $0xc,%esp
  1043db:	56                   	push   %esi
  1043dc:	50                   	push   %eax
  1043dd:	8d 83 84 9c ff ff    	lea    -0x637c(%ebx),%eax
  1043e3:	e9 a8 fe ff ff       	jmp    104290 <MATIntro_test2+0x60>
  1043e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1043ef:	00 

001043f0 <MATIntro_test3>:

int MATIntro_test3()
{
  1043f0:	53                   	push   %ebx
  1043f1:	e8 47 bf ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1043f6:	81 c3 fe ab 00 00    	add    $0xabfe,%ebx
  1043fc:	83 ec 10             	sub    $0x10,%esp
    at_set_allocated(1, 0);
  1043ff:	6a 00                	push   $0x0
  104401:	6a 01                	push   $0x1
  104403:	e8 08 fd ff ff       	call   104110 <at_set_allocated>
    if (at_is_allocated(1) != 0) {
  104408:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10440f:	e8 dc fc ff ff       	call   1040f0 <at_is_allocated>
  104414:	83 c4 10             	add    $0x10,%esp
  104417:	85 c0                	test   %eax,%eax
  104419:	0f 85 89 00 00 00    	jne    1044a8 <MATIntro_test3+0xb8>
        dprintf("test 3.1 failed: (%d != 0)\n", at_is_allocated(1));
        at_set_allocated(1, 0);
        return 1;
    }
    at_set_allocated(1, 1);
  10441f:	83 ec 08             	sub    $0x8,%esp
  104422:	6a 01                	push   $0x1
  104424:	6a 01                	push   $0x1
  104426:	e8 e5 fc ff ff       	call   104110 <at_set_allocated>
    if (at_is_allocated(1) != 1) {
  10442b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104432:	e8 b9 fc ff ff       	call   1040f0 <at_is_allocated>
  104437:	83 c4 10             	add    $0x10,%esp
  10443a:	83 f8 01             	cmp    $0x1,%eax
  10443d:	74 31                	je     104470 <MATIntro_test3+0x80>
        dprintf("test 3.2 failed: (%d != 1)\n", at_is_allocated(1));
  10443f:	83 ec 0c             	sub    $0xc,%esp
  104442:	6a 01                	push   $0x1
  104444:	e8 a7 fc ff ff       	call   1040f0 <at_is_allocated>
  104449:	59                   	pop    %ecx
  10444a:	5a                   	pop    %edx
  10444b:	50                   	push   %eax
  10444c:	8d 83 e9 93 ff ff    	lea    -0x6c17(%ebx),%eax
  104452:	50                   	push   %eax
  104453:	e8 4a e7 ff ff       	call   102ba2 <dprintf>
        at_set_allocated(1, 0);
  104458:	58                   	pop    %eax
  104459:	5a                   	pop    %edx
  10445a:	6a 00                	push   $0x0
  10445c:	6a 01                	push   $0x1
  10445e:	e8 ad fc ff ff       	call   104110 <at_set_allocated>
        return 1;
  104463:	83 c4 10             	add    $0x10,%esp
        return 1;
  104466:	b8 01 00 00 00       	mov    $0x1,%eax
        return 1;
    }
    at_set_allocated(1, 0);
    dprintf("test 3 passed.\n");
    return 0;
}
  10446b:	83 c4 08             	add    $0x8,%esp
  10446e:	5b                   	pop    %ebx
  10446f:	c3                   	ret
    at_set_allocated(1, 100);
  104470:	83 ec 08             	sub    $0x8,%esp
  104473:	6a 64                	push   $0x64
  104475:	6a 01                	push   $0x1
  104477:	e8 94 fc ff ff       	call   104110 <at_set_allocated>
    if (at_is_allocated(1) != 1) {
  10447c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104483:	e8 68 fc ff ff       	call   1040f0 <at_is_allocated>
  104488:	83 c4 10             	add    $0x10,%esp
  10448b:	83 f8 01             	cmp    $0x1,%eax
  10448e:	74 30                	je     1044c0 <MATIntro_test3+0xd0>
        dprintf("test 3.3 failed: (%d != 1)\n", at_is_allocated(1));
  104490:	83 ec 0c             	sub    $0xc,%esp
  104493:	6a 01                	push   $0x1
  104495:	e8 56 fc ff ff       	call   1040f0 <at_is_allocated>
  10449a:	5a                   	pop    %edx
  10449b:	59                   	pop    %ecx
  10449c:	50                   	push   %eax
  10449d:	8d 83 05 94 ff ff    	lea    -0x6bfb(%ebx),%eax
  1044a3:	eb ad                	jmp    104452 <MATIntro_test3+0x62>
  1044a5:	8d 76 00             	lea    0x0(%esi),%esi
        dprintf("test 3.1 failed: (%d != 0)\n", at_is_allocated(1));
  1044a8:	83 ec 0c             	sub    $0xc,%esp
  1044ab:	6a 01                	push   $0x1
  1044ad:	e8 3e fc ff ff       	call   1040f0 <at_is_allocated>
  1044b2:	59                   	pop    %ecx
  1044b3:	5a                   	pop    %edx
  1044b4:	50                   	push   %eax
  1044b5:	8d 83 cd 93 ff ff    	lea    -0x6c33(%ebx),%eax
  1044bb:	eb 95                	jmp    104452 <MATIntro_test3+0x62>
  1044bd:	8d 76 00             	lea    0x0(%esi),%esi
    at_set_allocated(1, 0);
  1044c0:	83 ec 08             	sub    $0x8,%esp
  1044c3:	6a 00                	push   $0x0
  1044c5:	6a 01                	push   $0x1
  1044c7:	e8 44 fc ff ff       	call   104110 <at_set_allocated>
    dprintf("test 3 passed.\n");
  1044cc:	8d 83 21 94 ff ff    	lea    -0x6bdf(%ebx),%eax
  1044d2:	89 04 24             	mov    %eax,(%esp)
  1044d5:	e8 c8 e6 ff ff       	call   102ba2 <dprintf>
    return 0;
  1044da:	83 c4 10             	add    $0x10,%esp
  1044dd:	31 c0                	xor    %eax,%eax
}
  1044df:	83 c4 08             	add    $0x8,%esp
  1044e2:	5b                   	pop    %ebx
  1044e3:	c3                   	ret
  1044e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1044eb:	00 
  1044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001044f0 <MATIntro_test_own>:
int MATIntro_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  1044f0:	31 c0                	xor    %eax,%eax
  1044f2:	c3                   	ret
  1044f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1044fa:	00 
  1044fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00104500 <test_MATIntro>:

int test_MATIntro()
{
  104500:	53                   	push   %ebx
  104501:	83 ec 08             	sub    $0x8,%esp
    return MATIntro_test1() + MATIntro_test2() + MATIntro_test3() + MATIntro_test_own();
  104504:	e8 27 fc ff ff       	call   104130 <MATIntro_test1>
  104509:	89 c3                	mov    %eax,%ebx
  10450b:	e8 20 fd ff ff       	call   104230 <MATIntro_test2>
  104510:	01 c3                	add    %eax,%ebx
  104512:	e8 d9 fe ff ff       	call   1043f0 <MATIntro_test3>
}
  104517:	83 c4 08             	add    $0x8,%esp
    return MATIntro_test1() + MATIntro_test2() + MATIntro_test3() + MATIntro_test_own();
  10451a:	01 d8                	add    %ebx,%eax
}
  10451c:	5b                   	pop    %ebx
  10451d:	c3                   	ret
  10451e:	66 90                	xchg   %ax,%ax

00104520 <pmem_init>:
 *    Review import.h in the current directory for the list of avaiable getter and setter functions.
 */

void
pmem_init(unsigned int mbi_addr)
{
  104520:	55                   	push   %ebp
  104521:	57                   	push   %edi
  104522:	56                   	push   %esi
  104523:	31 f6                	xor    %esi,%esi
  104525:	53                   	push   %ebx
  104526:	e8 12 be ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10452b:	81 c3 c9 aa 00 00    	add    $0xaac9,%ebx
  104531:	83 ec 28             	sub    $0x28,%esp
  unsigned int i;

  //Calls the lower layer initializatin primitives.
  //The parameter mbi_addr shell not be used in the further code.
  
  devinit(mbi_addr);
  104534:	ff 74 24 3c          	push   0x3c(%esp)
  104538:	e8 a4 c3 ff ff       	call   1008e1 <devinit>
   * Calculate the number of actual number of avaiable physical pages and store it into the local varaible nps.
   * Hint: Think of it as the highest address possible in the ranges of the memory map table,
   *       divided by the page size.
   */

  table_nrow = get_size();
  10453d:	e8 90 c7 ff ff       	call   100cd2 <get_size>
  104542:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  if(table_nrow == 0){
  104546:	83 c4 10             	add    $0x10,%esp
  104549:	85 c0                	test   %eax,%eax
  10454b:	0f 85 36 01 00 00    	jne    104687 <pmem_init+0x167>
    start_addr = get_mms(table_nrow - 1);
    length = get_mml(table_nrow - 1);
    highest_addr = start_addr + length - 1;
    nps = start_addr / PAGESIZE + length / PAGESIZE + (start_addr % PAGESIZE + length % PAGESIZE) / PAGESIZE;
  }
  set_nps(nps); // Setting the value computed above to NUM_PAGES.
  104551:	83 ec 0c             	sub    $0xc,%esp
   *    That means there may be some gaps between the ranges.
   *    You should still set the permission of those pages in allocation table to 0.
   */
   
  // Reserved by the kernel
  for(i = 0; i < VM_USERLO_PI; i++){
  104554:	31 ff                	xor    %edi,%edi
  set_nps(nps); // Setting the value computed above to NUM_PAGES.
  104556:	56                   	push   %esi
  104557:	e8 24 fb ff ff       	call   104080 <set_nps>
  10455c:	83 c4 10             	add    $0x10,%esp
  10455f:	90                   	nop
    at_set_perm(i, 1);
  104560:	83 ec 08             	sub    $0x8,%esp
  104563:	6a 01                	push   $0x1
  104565:	57                   	push   %edi
  for(i = 0; i < VM_USERLO_PI; i++){
  104566:	83 c7 01             	add    $0x1,%edi
    at_set_perm(i, 1);
  104569:	e8 52 fb ff ff       	call   1040c0 <at_set_perm>
  for(i = 0; i < VM_USERLO_PI; i++){
  10456e:	83 c4 10             	add    $0x10,%esp
  104571:	81 ff 00 00 04 00    	cmp    $0x40000,%edi
  104577:	75 e7                	jne    104560 <pmem_init+0x40>
  }
  for(i = VM_USERHI_PI; i < nps; i++){
  104579:	bd 00 00 0f 00       	mov    $0xf0000,%ebp
  10457e:	81 fe 00 00 0f 00    	cmp    $0xf0000,%esi
  104584:	76 2a                	jbe    1045b0 <pmem_init+0x90>
  104586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10458d:	00 
  10458e:	66 90                	xchg   %ax,%ax
    at_set_perm(i, 1);
  104590:	83 ec 08             	sub    $0x8,%esp
  104593:	6a 01                	push   $0x1
  104595:	55                   	push   %ebp
  for(i = VM_USERHI_PI; i < nps; i++){
  104596:	83 c5 01             	add    $0x1,%ebp
    at_set_perm(i, 1);
  104599:	e8 22 fb ff ff       	call   1040c0 <at_set_perm>
  for(i = VM_USERHI_PI; i < nps; i++){
  10459e:	83 c4 10             	add    $0x10,%esp
  1045a1:	39 ee                	cmp    %ebp,%esi
  1045a3:	75 eb                	jne    104590 <pmem_init+0x70>
  1045a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1045ac:	00 
  1045ad:	8d 76 00             	lea    0x0(%esi),%esi
  }
  //set all default permission to 0
  for(i = VM_USERLO_PI; i < VM_USERHI_PI; i++){
    at_set_perm(i, 0);
  1045b0:	83 ec 08             	sub    $0x8,%esp
  1045b3:	6a 00                	push   $0x0
  1045b5:	57                   	push   %edi
  for(i = VM_USERLO_PI; i < VM_USERHI_PI; i++){
  1045b6:	83 c7 01             	add    $0x1,%edi
    at_set_perm(i, 0);
  1045b9:	e8 02 fb ff ff       	call   1040c0 <at_set_perm>
  for(i = VM_USERLO_PI; i < VM_USERHI_PI; i++){
  1045be:	83 c4 10             	add    $0x10,%esp
  1045c1:	81 ff 00 00 0f 00    	cmp    $0xf0000,%edi
  1045c7:	75 e7                	jne    1045b0 <pmem_init+0x90>
  }
  for(i = 0; i < table_nrow; i++){
  1045c9:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1045cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045d4:	00 
  1045d5:	85 c0                	test   %eax,%eax
  1045d7:	0f 84 a2 00 00 00    	je     10467f <pmem_init+0x15f>
  1045dd:	8d 76 00             	lea    0x0(%esi),%esi
    start_addr = get_mms(i);
  1045e0:	83 ec 0c             	sub    $0xc,%esp
  1045e3:	8b 74 24 10          	mov    0x10(%esp),%esi
  1045e7:	56                   	push   %esi
  1045e8:	e8 f6 c6 ff ff       	call   100ce3 <get_mms>
    length = get_mml(i);
  1045ed:	89 34 24             	mov    %esi,(%esp)
    start_addr = get_mms(i);
  1045f0:	89 c5                	mov    %eax,%ebp
    length = get_mml(i);
  1045f2:	e8 35 c7 ff ff       	call   100d2c <get_mml>
    perm = is_usable(i);
  1045f7:	89 34 24             	mov    %esi,(%esp)
    perm = perm == 1? 2: 0;
    page_idx = start_addr / PAGESIZE;
  1045fa:	89 ef                	mov    %ebp,%edi
    length = get_mml(i);
  1045fc:	89 44 24 18          	mov    %eax,0x18(%esp)
    perm = is_usable(i);
  104600:	e8 7a c7 ff ff       	call   100d7f <is_usable>
    perm = perm == 1? 2: 0;
  104605:	83 c4 10             	add    $0x10,%esp
    //align to the beginning of a page
    if(page_idx * PAGESIZE < start_addr){
  104608:	89 e9                	mov    %ebp,%ecx
    perm = perm == 1? 2: 0;
  10460a:	83 f8 01             	cmp    $0x1,%eax
  10460d:	0f 94 c0             	sete   %al
    if(page_idx * PAGESIZE < start_addr){
  104610:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    page_idx = start_addr / PAGESIZE;
  104616:	c1 ef 0c             	shr    $0xc,%edi
    perm = perm == 1? 2: 0;
  104619:	0f b6 c0             	movzbl %al,%eax
      page_idx++;
  10461c:	39 e9                	cmp    %ebp,%ecx
  10461e:	83 d7 00             	adc    $0x0,%edi
    perm = perm == 1? 2: 0;
  104621:	8d 34 00             	lea    (%eax,%eax,1),%esi
    }
    //the whole page resides in this row
    while((page_idx + 1) * PAGESIZE <= start_addr + length){
  104624:	8b 44 24 08          	mov    0x8(%esp),%eax
  104628:	8d 57 01             	lea    0x1(%edi),%edx
  10462b:	01 c5                	add    %eax,%ebp
  10462d:	c1 e2 0c             	shl    $0xc,%edx
  104630:	39 d5                	cmp    %edx,%ebp
  104632:	73 0e                	jae    104642 <pmem_init+0x122>
  104634:	eb 36                	jmp    10466c <pmem_init+0x14c>
  104636:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10463d:	00 
  10463e:	66 90                	xchg   %ax,%ax
  104640:	89 c7                	mov    %eax,%edi
      //the kernel reserved area
      if(page_idx < VM_USERLO_PI){
  104642:	81 ff ff ff 03 00    	cmp    $0x3ffff,%edi
  104648:	76 15                	jbe    10465f <pmem_init+0x13f>
        page_idx++;
        continue;
      }
      if(page_idx >= VM_USERHI_PI){
  10464a:	81 ff ff ff 0e 00    	cmp    $0xeffff,%edi
  104650:	77 1a                	ja     10466c <pmem_init+0x14c>
        break;
      }
      at_set_perm(page_idx, perm);
  104652:	83 ec 08             	sub    $0x8,%esp
  104655:	56                   	push   %esi
  104656:	57                   	push   %edi
  104657:	e8 64 fa ff ff       	call   1040c0 <at_set_perm>
  10465c:	83 c4 10             	add    $0x10,%esp
    while((page_idx + 1) * PAGESIZE <= start_addr + length){
  10465f:	8d 47 01             	lea    0x1(%edi),%eax
  104662:	83 c7 02             	add    $0x2,%edi
  104665:	c1 e7 0c             	shl    $0xc,%edi
  104668:	39 fd                	cmp    %edi,%ebp
  10466a:	73 d4                	jae    104640 <pmem_init+0x120>
  for(i = 0; i < table_nrow; i++){
  10466c:	83 44 24 04 01       	addl   $0x1,0x4(%esp)
  104671:	8b 44 24 04          	mov    0x4(%esp),%eax
  104675:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  104679:	0f 85 61 ff ff ff    	jne    1045e0 <pmem_init+0xc0>
      page_idx++;
    }
  }
  10467f:	83 c4 1c             	add    $0x1c,%esp
  104682:	5b                   	pop    %ebx
  104683:	5e                   	pop    %esi
  104684:	5f                   	pop    %edi
  104685:	5d                   	pop    %ebp
  104686:	c3                   	ret
    start_addr = get_mms(table_nrow - 1);
  104687:	83 ec 0c             	sub    $0xc,%esp
  10468a:	8d 70 ff             	lea    -0x1(%eax),%esi
  10468d:	56                   	push   %esi
  10468e:	e8 50 c6 ff ff       	call   100ce3 <get_mms>
    length = get_mml(table_nrow - 1);
  104693:	89 34 24             	mov    %esi,(%esp)
    start_addr = get_mms(table_nrow - 1);
  104696:	89 c7                	mov    %eax,%edi
    length = get_mml(table_nrow - 1);
  104698:	e8 8f c6 ff ff       	call   100d2c <get_mml>
    nps = start_addr / PAGESIZE + length / PAGESIZE + (start_addr % PAGESIZE + length % PAGESIZE) / PAGESIZE;
  10469d:	89 fe                	mov    %edi,%esi
  10469f:	c1 ef 0c             	shr    $0xc,%edi
  1046a2:	83 c4 10             	add    $0x10,%esp
  1046a5:	89 c2                	mov    %eax,%edx
  1046a7:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
  1046ad:	c1 e8 0c             	shr    $0xc,%eax
  1046b0:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  1046b6:	01 f8                	add    %edi,%eax
  1046b8:	01 d6                	add    %edx,%esi
  1046ba:	c1 ee 0c             	shr    $0xc,%esi
  1046bd:	01 c6                	add    %eax,%esi
  1046bf:	e9 8d fe ff ff       	jmp    104551 <pmem_init+0x31>
  1046c4:	66 90                	xchg   %ax,%ax
  1046c6:	66 90                	xchg   %ax,%ax
  1046c8:	66 90                	xchg   %ax,%ax
  1046ca:	66 90                	xchg   %ax,%ax
  1046cc:	66 90                	xchg   %ax,%ax
  1046ce:	66 90                	xchg   %ax,%ax

001046d0 <MATInit_test1>:
#define VM_USERHI    0xF0000000
#define VM_USERLO_PI (VM_USERLO / PAGESIZE)
#define VM_USERHI_PI (VM_USERHI / PAGESIZE)

int MATInit_test1()
{
  1046d0:	57                   	push   %edi
  1046d1:	56                   	push   %esi
  1046d2:	31 f6                	xor    %esi,%esi
  1046d4:	53                   	push   %ebx
  1046d5:	e8 63 bc ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1046da:	81 c3 1a a9 00 00    	add    $0xa91a,%ebx
    int i;
    int nps = get_nps();
  1046e0:	e8 7b f9 ff ff       	call   104060 <get_nps>
  1046e5:	89 c7                	mov    %eax,%edi
    if (nps <= 1000) {
  1046e7:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  1046ec:	7f 11                	jg     1046ff <MATInit_test1+0x2f>
  1046ee:	e9 ad 00 00 00       	jmp    1047a0 <MATInit_test1+0xd0>
  1046f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.1 failed: (%d <= 1000)\n", nps);
        return 1;
    }
    for (i = 0; i < nps; i++) {
  1046f8:	83 c6 01             	add    $0x1,%esi
  1046fb:	39 f7                	cmp    %esi,%edi
  1046fd:	74 51                	je     104750 <MATInit_test1+0x80>
        if (at_is_allocated(i) != 0) {
  1046ff:	83 ec 0c             	sub    $0xc,%esp
  104702:	56                   	push   %esi
  104703:	e8 e8 f9 ff ff       	call   1040f0 <at_is_allocated>
  104708:	83 c4 10             	add    $0x10,%esp
  10470b:	85 c0                	test   %eax,%eax
  10470d:	75 61                	jne    104770 <MATInit_test1+0xa0>
            dprintf("test 1.2 failed (i = %d): (%d != 0)\n", i, at_is_allocated(i));
            return 1;
        }
        if ((i < VM_USERLO_PI || VM_USERHI_PI <= i)
  10470f:	8d 86 00 00 fc ff    	lea    -0x40000(%esi),%eax
  104715:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  10471a:	76 dc                	jbe    1046f8 <MATInit_test1+0x28>
            && at_is_norm(i) != 0) {
  10471c:	83 ec 0c             	sub    $0xc,%esp
  10471f:	56                   	push   %esi
  104720:	e8 7b f9 ff ff       	call   1040a0 <at_is_norm>
  104725:	83 c4 10             	add    $0x10,%esp
  104728:	85 c0                	test   %eax,%eax
  10472a:	74 cc                	je     1046f8 <MATInit_test1+0x28>
            dprintf("test 1.3 failed (i = %d): (%d != 0)\n", i, at_is_norm(i));
  10472c:	83 ec 0c             	sub    $0xc,%esp
  10472f:	56                   	push   %esi
  104730:	e8 6b f9 ff ff       	call   1040a0 <at_is_norm>
  104735:	83 c4 0c             	add    $0xc,%esp
  104738:	50                   	push   %eax
  104739:	8d 83 f4 9c ff ff    	lea    -0x630c(%ebx),%eax
  10473f:	56                   	push   %esi
  104740:	50                   	push   %eax
  104741:	e8 5c e4 ff ff       	call   102ba2 <dprintf>
            return 1;
  104746:	83 c4 10             	add    $0x10,%esp
  104749:	eb 42                	jmp    10478d <MATInit_test1+0xbd>
  10474b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        }
    }
    dprintf("test 1 passed.\n");
  104750:	83 ec 0c             	sub    $0xc,%esp
  104753:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  104759:	50                   	push   %eax
  10475a:	e8 43 e4 ff ff       	call   102ba2 <dprintf>
    return 0;
  10475f:	83 c4 10             	add    $0x10,%esp
  104762:	31 c0                	xor    %eax,%eax
}
  104764:	5b                   	pop    %ebx
  104765:	5e                   	pop    %esi
  104766:	5f                   	pop    %edi
  104767:	c3                   	ret
  104768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10476f:	00 
            dprintf("test 1.2 failed (i = %d): (%d != 0)\n", i, at_is_allocated(i));
  104770:	83 ec 0c             	sub    $0xc,%esp
  104773:	56                   	push   %esi
  104774:	e8 77 f9 ff ff       	call   1040f0 <at_is_allocated>
  104779:	83 c4 0c             	add    $0xc,%esp
  10477c:	50                   	push   %eax
  10477d:	8d 83 cc 9c ff ff    	lea    -0x6334(%ebx),%eax
  104783:	56                   	push   %esi
  104784:	50                   	push   %eax
  104785:	e8 18 e4 ff ff       	call   102ba2 <dprintf>
            return 1;
  10478a:	83 c4 10             	add    $0x10,%esp
}
  10478d:	5b                   	pop    %ebx
        return 1;
  10478e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  104793:	5e                   	pop    %esi
  104794:	5f                   	pop    %edi
  104795:	c3                   	ret
  104796:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10479d:	00 
  10479e:	66 90                	xchg   %ax,%ax
        dprintf("test 1.1 failed: (%d <= 1000)\n", nps);
  1047a0:	83 ec 08             	sub    $0x8,%esp
  1047a3:	50                   	push   %eax
  1047a4:	8d 83 ac 9c ff ff    	lea    -0x6354(%ebx),%eax
  1047aa:	50                   	push   %eax
  1047ab:	e8 f2 e3 ff ff       	call   102ba2 <dprintf>
        return 1;
  1047b0:	83 c4 10             	add    $0x10,%esp
  1047b3:	eb d8                	jmp    10478d <MATInit_test1+0xbd>
  1047b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1047bc:	00 
  1047bd:	8d 76 00             	lea    0x0(%esi),%esi

001047c0 <MATInit_test_own>:
int MATInit_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  1047c0:	31 c0                	xor    %eax,%eax
  1047c2:	c3                   	ret
  1047c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1047ca:	00 
  1047cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001047d0 <test_MATInit>:

int test_MATInit()
{
    return MATInit_test1() + MATInit_test_own();
  1047d0:	e9 fb fe ff ff       	jmp    1046d0 <MATInit_test1>
  1047d5:	66 90                	xchg   %ax,%ax
  1047d7:	66 90                	xchg   %ax,%ax
  1047d9:	66 90                	xchg   %ax,%ax
  1047db:	66 90                	xchg   %ax,%ax
  1047dd:	66 90                	xchg   %ax,%ax
  1047df:	90                   	nop

001047e0 <palloc>:
 *    scan the allocation table from scratch every time.
 */

unsigned int
palloc()
{
  1047e0:	56                   	push   %esi
  1047e1:	53                   	push   %ebx
  1047e2:	e8 56 bb ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1047e7:	81 c3 0d a8 00 00    	add    $0xa80d,%ebx
  1047ed:	83 ec 04             	sub    $0x4,%esp
  //no available physical pages
  if (get_nps() == 0) {
  1047f0:	e8 6b f8 ff ff       	call   104060 <get_nps>
  1047f5:	85 c0                	test   %eax,%eax
  1047f7:	74 4d                	je     104846 <palloc+0x66>
    return 0;
  }

  //first record the current value of next
  unsigned int begin = next;
  1047f9:	8b b3 14 03 00 00    	mov    0x314(%ebx),%esi
  1047ff:	89 f0                	mov    %esi,%eax
  104801:	eb 0f                	jmp    104812 <palloc+0x32>
  104803:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    //then allocate the page, and return the page index
    if (at_is_norm(next) && at_is_allocated(next) == 0) {
      at_set_allocated(next, 1);
      return next;
    }
    next++;
  104808:	89 83 14 03 00 00    	mov    %eax,0x314(%ebx)
    //if next moves to the end, we set next to the beginning
    if (next == VM_USERHI_PI) {
      next = VM_USERLO_PI;
    }
  } while (next != begin);
  10480e:	39 c6                	cmp    %eax,%esi
  104810:	74 34                	je     104846 <palloc+0x66>
    if (at_is_norm(next) && at_is_allocated(next) == 0) {
  104812:	83 ec 0c             	sub    $0xc,%esp
  104815:	50                   	push   %eax
  104816:	e8 85 f8 ff ff       	call   1040a0 <at_is_norm>
  10481b:	83 c4 10             	add    $0x10,%esp
  10481e:	85 c0                	test   %eax,%eax
  104820:	75 2e                	jne    104850 <palloc+0x70>
    next++;
  104822:	8b 93 14 03 00 00    	mov    0x314(%ebx),%edx
  104828:	8d 42 01             	lea    0x1(%edx),%eax
    if (next == VM_USERHI_PI) {
  10482b:	81 fa ff ff 0e 00    	cmp    $0xeffff,%edx
  104831:	75 d5                	jne    104808 <palloc+0x28>
      next = VM_USERLO_PI;
  104833:	c7 83 14 03 00 00 00 	movl   $0x40000,0x314(%ebx)
  10483a:	00 04 00 
  10483d:	b8 00 00 04 00       	mov    $0x40000,%eax
  } while (next != begin);
  104842:	39 c6                	cmp    %eax,%esi
  104844:	75 cc                	jne    104812 <palloc+0x32>

  //all pages are allocated
  return 0;
} 
  104846:	83 c4 04             	add    $0x4,%esp
    return 0;
  104849:	31 c0                	xor    %eax,%eax
} 
  10484b:	5b                   	pop    %ebx
  10484c:	5e                   	pop    %esi
  10484d:	c3                   	ret
  10484e:	66 90                	xchg   %ax,%ax
    if (at_is_norm(next) && at_is_allocated(next) == 0) {
  104850:	83 ec 0c             	sub    $0xc,%esp
  104853:	ff b3 14 03 00 00    	push   0x314(%ebx)
  104859:	e8 92 f8 ff ff       	call   1040f0 <at_is_allocated>
  10485e:	83 c4 10             	add    $0x10,%esp
  104861:	85 c0                	test   %eax,%eax
  104863:	75 bd                	jne    104822 <palloc+0x42>
      at_set_allocated(next, 1);
  104865:	83 ec 08             	sub    $0x8,%esp
  104868:	6a 01                	push   $0x1
  10486a:	ff b3 14 03 00 00    	push   0x314(%ebx)
  104870:	e8 9b f8 ff ff       	call   104110 <at_set_allocated>
      return next;
  104875:	83 c4 10             	add    $0x10,%esp
  104878:	8b 83 14 03 00 00    	mov    0x314(%ebx),%eax
} 
  10487e:	83 c4 04             	add    $0x4,%esp
  104881:	5b                   	pop    %ebx
  104882:	5e                   	pop    %esi
  104883:	c3                   	ret
  104884:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10488b:	00 
  10488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104890 <pfree>:
 *
 * Hint: Simple.
 */
void
pfree(unsigned int pfree_index)
{
  104890:	53                   	push   %ebx
  104891:	e8 a7 ba ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104896:	81 c3 5e a7 00 00    	add    $0xa75e,%ebx
  10489c:	83 ec 10             	sub    $0x10,%esp
  at_set_allocated(pfree_index, 0);
  10489f:	6a 00                	push   $0x0
  1048a1:	ff 74 24 1c          	push   0x1c(%esp)
  1048a5:	e8 66 f8 ff ff       	call   104110 <at_set_allocated>
  1048aa:	83 c4 18             	add    $0x18,%esp
  1048ad:	5b                   	pop    %ebx
  1048ae:	c3                   	ret
  1048af:	90                   	nop

001048b0 <MATOp_test1>:
#define VM_USERHI    0xF0000000
#define VM_USERLO_PI (VM_USERLO / PAGESIZE)
#define VM_USERHI_PI (VM_USERHI / PAGESIZE)

int MATOp_test1()
{
  1048b0:	56                   	push   %esi
  1048b1:	53                   	push   %ebx
  1048b2:	e8 86 ba ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1048b7:	81 c3 3d a7 00 00    	add    $0xa73d,%ebx
  1048bd:	83 ec 04             	sub    $0x4,%esp
    int page_index = palloc();
  1048c0:	e8 1b ff ff ff       	call   1047e0 <palloc>
  1048c5:	89 c6                	mov    %eax,%esi
    if (page_index < VM_USERLO_PI || VM_USERHI_PI <= page_index) {
  1048c7:	2d 00 00 04 00       	sub    $0x40000,%eax
  1048cc:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  1048d1:	0f 87 91 00 00 00    	ja     104968 <MATOp_test1+0xb8>
        dprintf("test 1.1 failed: (%d < VM_USERLO_PI || VM_USERHI_PI <= %d)\n", page_index, page_index);
        pfree(page_index);
        return 1;
    }
    if (at_is_norm(page_index) != 1) {
  1048d7:	83 ec 0c             	sub    $0xc,%esp
  1048da:	56                   	push   %esi
  1048db:	e8 c0 f7 ff ff       	call   1040a0 <at_is_norm>
  1048e0:	83 c4 10             	add    $0x10,%esp
  1048e3:	83 f8 01             	cmp    $0x1,%eax
  1048e6:	74 38                	je     104920 <MATOp_test1+0x70>
        dprintf("test 1.2 failed: (%d != 1)\n", at_is_norm(page_index));
  1048e8:	83 ec 0c             	sub    $0xc,%esp
  1048eb:	56                   	push   %esi
  1048ec:	e8 af f7 ff ff       	call   1040a0 <at_is_norm>
  1048f1:	5a                   	pop    %edx
  1048f2:	59                   	pop    %ecx
  1048f3:	50                   	push   %eax
  1048f4:	8d 83 31 94 ff ff    	lea    -0x6bcf(%ebx),%eax
  1048fa:	50                   	push   %eax
  1048fb:	e8 a2 e2 ff ff       	call   102ba2 <dprintf>
        pfree(page_index);
  104900:	89 34 24             	mov    %esi,(%esp)
  104903:	e8 88 ff ff ff       	call   104890 <pfree>
        return 1;
  104908:	83 c4 10             	add    $0x10,%esp
        dprintf("test 1.4 failed: (%d != 0)\n", at_is_allocated(page_index));
        return 1;
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  10490b:	83 c4 04             	add    $0x4,%esp
        return 1;
  10490e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  104913:	5b                   	pop    %ebx
  104914:	5e                   	pop    %esi
  104915:	c3                   	ret
  104916:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10491d:	00 
  10491e:	66 90                	xchg   %ax,%ax
    if (at_is_allocated(page_index) != 1) {
  104920:	83 ec 0c             	sub    $0xc,%esp
  104923:	56                   	push   %esi
  104924:	e8 c7 f7 ff ff       	call   1040f0 <at_is_allocated>
  104929:	83 c4 10             	add    $0x10,%esp
  10492c:	83 f8 01             	cmp    $0x1,%eax
  10492f:	75 47                	jne    104978 <MATOp_test1+0xc8>
    pfree(page_index);
  104931:	83 ec 0c             	sub    $0xc,%esp
  104934:	56                   	push   %esi
  104935:	e8 56 ff ff ff       	call   104890 <pfree>
    if (at_is_allocated(page_index) != 0) {
  10493a:	89 34 24             	mov    %esi,(%esp)
  10493d:	e8 ae f7 ff ff       	call   1040f0 <at_is_allocated>
  104942:	83 c4 10             	add    $0x10,%esp
  104945:	85 c0                	test   %eax,%eax
  104947:	75 47                	jne    104990 <MATOp_test1+0xe0>
    dprintf("test 1 passed.\n");
  104949:	83 ec 0c             	sub    $0xc,%esp
  10494c:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  104952:	50                   	push   %eax
  104953:	e8 4a e2 ff ff       	call   102ba2 <dprintf>
    return 0;
  104958:	83 c4 10             	add    $0x10,%esp
  10495b:	31 c0                	xor    %eax,%eax
}
  10495d:	83 c4 04             	add    $0x4,%esp
  104960:	5b                   	pop    %ebx
  104961:	5e                   	pop    %esi
  104962:	c3                   	ret
  104963:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.1 failed: (%d < VM_USERLO_PI || VM_USERHI_PI <= %d)\n", page_index, page_index);
  104968:	83 ec 04             	sub    $0x4,%esp
  10496b:	8d 83 1c 9d ff ff    	lea    -0x62e4(%ebx),%eax
  104971:	56                   	push   %esi
  104972:	56                   	push   %esi
  104973:	eb 85                	jmp    1048fa <MATOp_test1+0x4a>
  104975:	8d 76 00             	lea    0x0(%esi),%esi
        dprintf("test 1.3 failed: (%d != 1)\n", at_is_allocated(page_index));
  104978:	83 ec 0c             	sub    $0xc,%esp
  10497b:	56                   	push   %esi
  10497c:	e8 6f f7 ff ff       	call   1040f0 <at_is_allocated>
  104981:	5a                   	pop    %edx
  104982:	59                   	pop    %ecx
  104983:	50                   	push   %eax
  104984:	8d 83 4d 94 ff ff    	lea    -0x6bb3(%ebx),%eax
  10498a:	e9 6b ff ff ff       	jmp    1048fa <MATOp_test1+0x4a>
  10498f:	90                   	nop
        dprintf("test 1.4 failed: (%d != 0)\n", at_is_allocated(page_index));
  104990:	83 ec 0c             	sub    $0xc,%esp
  104993:	56                   	push   %esi
  104994:	e8 57 f7 ff ff       	call   1040f0 <at_is_allocated>
  104999:	5a                   	pop    %edx
  10499a:	59                   	pop    %ecx
  10499b:	50                   	push   %eax
  10499c:	8d 83 69 94 ff ff    	lea    -0x6b97(%ebx),%eax
  1049a2:	50                   	push   %eax
  1049a3:	e8 fa e1 ff ff       	call   102ba2 <dprintf>
        return 1;
  1049a8:	83 c4 10             	add    $0x10,%esp
  1049ab:	e9 5b ff ff ff       	jmp    10490b <MATOp_test1+0x5b>

001049b0 <MATOp_test_own>:
int MATOp_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  1049b0:	31 c0                	xor    %eax,%eax
  1049b2:	c3                   	ret
  1049b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1049ba:	00 
  1049bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001049c0 <test_MATOp>:

int test_MATOp()
{
    return MATOp_test1() + MATOp_test_own();
  1049c0:	e9 eb fe ff ff       	jmp    1048b0 <MATOp_test1>
  1049c5:	66 90                	xchg   %ax,%ax
  1049c7:	66 90                	xchg   %ax,%ax
  1049c9:	66 90                	xchg   %ax,%ax
  1049cb:	66 90                	xchg   %ax,%ax
  1049cd:	66 90                	xchg   %ax,%ax
  1049cf:	90                   	nop

001049d0 <container_init>:
/**
 * Initializes the container data for the root process (the one with index 0).
 * The root process is the one that gets spawned first by the kernel.
 */
void container_init(unsigned int mbi_addr)
{
  1049d0:	55                   	push   %ebp
  1049d1:	57                   	push   %edi
  1049d2:	56                   	push   %esi
  1049d3:	53                   	push   %ebx
  1049d4:	e8 64 b9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1049d9:	81 c3 1b a6 00 00    	add    $0xa61b,%ebx
  1049df:	83 ec 18             	sub    $0x18,%esp
  unsigned int real_quota;
  unsigned int nps;
  unsigned int i;
  // TODO: define your local variables here.
 
  pmem_init(mbi_addr);
  1049e2:	ff 74 24 2c          	push   0x2c(%esp)
  1049e6:	e8 35 fb ff ff       	call   104520 <pmem_init>
  /**
   * TODO: compute the available quota and store it into the variable real_quota.
   * It should be the number of the unallocated pages with the normal permission
   * in the physical memory allocation table.
   */
  nps = get_nps();
  1049eb:	e8 70 f6 ff ff       	call   104060 <get_nps>
  for(i = 0;i < nps; i++){
  1049f0:	83 c4 10             	add    $0x10,%esp
  1049f3:	85 c0                	test   %eax,%eax
  1049f5:	0f 84 95 00 00 00    	je     104a90 <container_init+0xc0>
  1049fb:	89 c7                	mov    %eax,%edi
  1049fd:	31 f6                	xor    %esi,%esi
  real_quota = 0;
  1049ff:	31 ed                	xor    %ebp,%ebp
  104a01:	eb 0c                	jmp    104a0f <container_init+0x3f>
  104a03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(i = 0;i < nps; i++){
  104a08:	83 c6 01             	add    $0x1,%esi
  104a0b:	39 f7                	cmp    %esi,%edi
  104a0d:	74 29                	je     104a38 <container_init+0x68>
    if(at_is_norm(i) && !at_is_allocated(i)){
  104a0f:	83 ec 0c             	sub    $0xc,%esp
  104a12:	56                   	push   %esi
  104a13:	e8 88 f6 ff ff       	call   1040a0 <at_is_norm>
  104a18:	83 c4 10             	add    $0x10,%esp
  104a1b:	85 c0                	test   %eax,%eax
  104a1d:	74 e9                	je     104a08 <container_init+0x38>
  104a1f:	83 ec 0c             	sub    $0xc,%esp
  104a22:	56                   	push   %esi
  104a23:	e8 c8 f6 ff ff       	call   1040f0 <at_is_allocated>
  104a28:	83 c4 10             	add    $0x10,%esp
      real_quota++; 
  104a2b:	83 f8 01             	cmp    $0x1,%eax
  104a2e:	83 d5 00             	adc    $0x0,%ebp
  for(i = 0;i < nps; i++){
  104a31:	83 c6 01             	add    $0x1,%esi
  104a34:	39 f7                	cmp    %esi,%edi
  104a36:	75 d7                	jne    104a0f <container_init+0x3f>
    }
  }
  KERN_DEBUG("\nreal quota: %d\n\n", real_quota);

  CONTAINER[0].quota = real_quota;
  104a38:	89 ee                	mov    %ebp,%esi
  KERN_DEBUG("\nreal quota: %d\n\n", real_quota);
  104a3a:	8d 83 85 94 ff ff    	lea    -0x6b7b(%ebx),%eax
  104a40:	55                   	push   %ebp
  104a41:	50                   	push   %eax
  104a42:	8d 83 58 9d ff ff    	lea    -0x62a8(%ebx),%eax
  104a48:	6a 29                	push   $0x29
  104a4a:	50                   	push   %eax
  104a4b:	e8 86 df ff ff       	call   1029d6 <debug_normal>
  CONTAINER[0].quota = real_quota;
  104a50:	89 b3 2c 01 87 00    	mov    %esi,0x87012c(%ebx)
  CONTAINER[0].usage = 0;
  104a56:	c7 83 30 01 87 00 00 	movl   $0x0,0x870130(%ebx)
  104a5d:	00 00 00 
  CONTAINER[0].parent = 0;
  104a60:	c7 83 34 01 87 00 00 	movl   $0x0,0x870134(%ebx)
  104a67:	00 00 00 
  CONTAINER[0].nchildren = 0;
  104a6a:	c7 83 38 01 87 00 00 	movl   $0x0,0x870138(%ebx)
  104a71:	00 00 00 
  CONTAINER[0].used = 1;
  104a74:	c7 83 3c 01 87 00 01 	movl   $0x1,0x87013c(%ebx)
  104a7b:	00 00 00 
}
  104a7e:	83 c4 1c             	add    $0x1c,%esp
  104a81:	5b                   	pop    %ebx
  104a82:	5e                   	pop    %esi
  104a83:	5f                   	pop    %edi
  104a84:	5d                   	pop    %ebp
  104a85:	c3                   	ret
  104a86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104a8d:	00 
  104a8e:	66 90                	xchg   %ax,%ax
  real_quota = 0;
  104a90:	31 ed                	xor    %ebp,%ebp
  for(i = 0;i < nps; i++){
  104a92:	31 f6                	xor    %esi,%esi
  104a94:	eb a4                	jmp    104a3a <container_init+0x6a>
  104a96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104a9d:	00 
  104a9e:	66 90                	xchg   %ax,%ax

00104aa0 <container_get_parent>:
// get the id of parent process of process # [id]
unsigned int container_get_parent(unsigned int id)
{
  // TODO

  return CONTAINER[id].parent;
  104aa0:	e8 89 c3 ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104aa5:	81 c2 4f a5 00 00    	add    $0xa54f,%edx
{
  104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  return CONTAINER[id].parent;
  104aaf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  104ab2:	8b 84 82 34 01 87 00 	mov    0x870134(%edx,%eax,4),%eax
}
  104ab9:	c3                   	ret
  104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104ac0 <container_get_nchildren>:

// get the number of children of process # [id]
unsigned int container_get_nchildren(unsigned int id)
{
  // TODO
  return CONTAINER[id].nchildren;
  104ac0:	e8 69 c3 ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104ac5:	81 c2 2f a5 00 00    	add    $0xa52f,%edx
{
  104acb:	8b 44 24 04          	mov    0x4(%esp),%eax
  return CONTAINER[id].nchildren;
  104acf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  104ad2:	8b 84 82 38 01 87 00 	mov    0x870138(%edx,%eax,4),%eax
}
  104ad9:	c3                   	ret
  104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104ae0 <container_get_quota>:

// get the maximum memory quota of process # [id]
unsigned int container_get_quota(unsigned int id)
{
  // TODO
  return CONTAINER[id].quota;
  104ae0:	e8 49 c3 ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104ae5:	81 c2 0f a5 00 00    	add    $0xa50f,%edx
{
  104aeb:	8b 44 24 04          	mov    0x4(%esp),%eax
  return CONTAINER[id].quota;
  104aef:	8d 04 80             	lea    (%eax,%eax,4),%eax
  104af2:	8b 84 82 2c 01 87 00 	mov    0x87012c(%edx,%eax,4),%eax
}
  104af9:	c3                   	ret
  104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104b00 <container_get_usage>:

// get the current memory usage of process # [id]
unsigned int container_get_usage(unsigned int id)
{
  // TODO
  return CONTAINER[id].usage;
  104b00:	e8 29 c3 ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104b05:	81 c2 ef a4 00 00    	add    $0xa4ef,%edx
{
  104b0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  return CONTAINER[id].usage;
  104b0f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  104b12:	8b 84 82 30 01 87 00 	mov    0x870130(%edx,%eax,4),%eax
}
  104b19:	c3                   	ret
  104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104b20 <container_can_consume>:
// determines whether the process # [id] can consume extra
// [n] pages of memory. If so, returns 1, o.w., returns 0.
unsigned int container_can_consume(unsigned int id, unsigned int n)
{
  // TODO
  return CONTAINER[id].quota - CONTAINER[id].usage >= n;
  104b20:	e8 09 c3 ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104b25:	81 c2 cf a4 00 00    	add    $0xa4cf,%edx
{
  104b2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  return CONTAINER[id].quota - CONTAINER[id].usage >= n;
  104b2f:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  104b32:	8b 84 8a 2c 01 87 00 	mov    0x87012c(%edx,%ecx,4),%eax
  104b39:	2b 84 8a 30 01 87 00 	sub    0x870130(%edx,%ecx,4),%eax
  104b40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  104b44:	0f 93 c0             	setae  %al
  104b47:	0f b6 c0             	movzbl %al,%eax
}
  104b4a:	c3                   	ret
  104b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00104b50 <container_split>:
 * dedicates [quota] pages of memory for a new child process.
 * you can assume it is safe to allocate [quota] pages (i.e., the check is already done outside before calling this function)
 * returns the container index for the new child process.
 */
unsigned int container_split(unsigned int id, unsigned int quota)
{
  104b50:	57                   	push   %edi
  104b51:	56                   	push   %esi
  104b52:	53                   	push   %ebx
  104b53:	8b 54 24 10          	mov    0x10(%esp),%edx
  104b57:	e8 e1 b7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104b5c:	81 c3 98 a4 00 00    	add    $0xa498,%ebx
  104b62:	8b 74 24 14          	mov    0x14(%esp),%esi
  unsigned int child, nc;

  nc = CONTAINER[id].nchildren;
  104b66:	8d 04 92             	lea    (%edx,%edx,4),%eax
  104b69:	8d 8c 83 2c 01 87 00 	lea    0x87012c(%ebx,%eax,4),%ecx
  child = id * MAX_CHILDREN + 1 + nc; //container index for the child process
  104b70:	8d 44 52 01          	lea    0x1(%edx,%edx,2),%eax
  nc = CONTAINER[id].nchildren;
  104b74:	8b 79 0c             	mov    0xc(%ecx),%edi
  /**
   * TODO: update the container structure of both parent and child process appropriately.
   */
  //update parent
  CONTAINER[id].nchildren++;
  CONTAINER[id].usage += quota;
  104b77:	01 71 04             	add    %esi,0x4(%ecx)
  child = id * MAX_CHILDREN + 1 + nc; //container index for the child process
  104b7a:	01 f8                	add    %edi,%eax
  CONTAINER[id].nchildren++;
  104b7c:	83 c7 01             	add    $0x1,%edi
  104b7f:	89 79 0c             	mov    %edi,0xc(%ecx)

  //update child
  CONTAINER[child].quota = quota;
  104b82:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  104b85:	c1 e1 02             	shl    $0x2,%ecx
  104b88:	8d bc 0b 2c 01 87 00 	lea    0x87012c(%ebx,%ecx,1),%edi
  104b8f:	89 37                	mov    %esi,(%edi)
  CONTAINER[child].usage = 0;
  104b91:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
  CONTAINER[child].parent = id;
  104b98:	89 57 08             	mov    %edx,0x8(%edi)
  CONTAINER[child].nchildren = 0;
  104b9b:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
  CONTAINER[child].used = 1;
  104ba2:	c7 47 10 01 00 00 00 	movl   $0x1,0x10(%edi)
  return child;
}
  104ba9:	5b                   	pop    %ebx
  104baa:	5e                   	pop    %esi
  104bab:	5f                   	pop    %edi
  104bac:	c3                   	ret
  104bad:	8d 76 00             	lea    0x0(%esi),%esi

00104bb0 <container_alloc>:
 * allocates one more page for process # [id], given that its usage would not exceed the quota.
 * the container structure should be updated accordingly after the allocation.
 * returns the page index of the allocated page, or 0 in the case of failure.
 */
unsigned int container_alloc(unsigned int id)
{
  104bb0:	56                   	push   %esi
  104bb1:	53                   	push   %ebx
  104bb2:	e8 86 b7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104bb7:	81 c3 3d a4 00 00    	add    $0xa43d,%ebx
  104bbd:	83 ec 04             	sub    $0x4,%esp
  104bc0:	8b 74 24 10          	mov    0x10(%esp),%esi
  /*
   * TODO: implement the function here.
   */
  unsigned int pid; //page id

  pid = palloc();
  104bc4:	e8 17 fc ff ff       	call   1047e0 <palloc>
  if(pid == 0) return 0; //failure
  104bc9:	85 c0                	test   %eax,%eax
  104bcb:	74 0b                	je     104bd8 <container_alloc+0x28>

  CONTAINER[id].usage++;
  104bcd:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  104bd0:	83 84 93 30 01 87 00 	addl   $0x1,0x870130(%ebx,%edx,4)
  104bd7:	01 
  return pid;
}
  104bd8:	83 c4 04             	add    $0x4,%esp
  104bdb:	5b                   	pop    %ebx
  104bdc:	5e                   	pop    %esi
  104bdd:	c3                   	ret
  104bde:	66 90                	xchg   %ax,%ax

00104be0 <container_free>:

// frees the physical page and reduces the usage by 1.
void container_free(unsigned int id, unsigned int page_index)
{
  104be0:	56                   	push   %esi
  104be1:	53                   	push   %ebx
  104be2:	e8 56 b7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104be7:	81 c3 0d a4 00 00    	add    $0xa40d,%ebx
  104bed:	83 ec 10             	sub    $0x10,%esp
  104bf0:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  // TODO
  pfree(page_index);
  104bf4:	ff 74 24 20          	push   0x20(%esp)
  104bf8:	e8 93 fc ff ff       	call   104890 <pfree>
  CONTAINER[id].usage--;
  104bfd:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  104c00:	83 ac 83 30 01 87 00 	subl   $0x1,0x870130(%ebx,%eax,4)
  104c07:	01 
  104c08:	83 c4 14             	add    $0x14,%esp
  104c0b:	5b                   	pop    %ebx
  104c0c:	5e                   	pop    %esi
  104c0d:	c3                   	ret
  104c0e:	66 90                	xchg   %ax,%ax

00104c10 <MContainer_test1>:
#include <lib/debug.h>
#include "export.h"

int MContainer_test1()
{
  104c10:	53                   	push   %ebx
  104c11:	e8 27 b7 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104c16:	81 c3 de a3 00 00    	add    $0xa3de,%ebx
  104c1c:	83 ec 14             	sub    $0x14,%esp
    if (container_get_quota(0) <= 10000) {
  104c1f:	6a 00                	push   $0x0
  104c21:	e8 ba fe ff ff       	call   104ae0 <container_get_quota>
  104c26:	83 c4 10             	add    $0x10,%esp
  104c29:	3d 10 27 00 00       	cmp    $0x2710,%eax
  104c2e:	0f 86 7c 00 00 00    	jbe    104cb0 <MContainer_test1+0xa0>
        dprintf("test 1.1 failed: (%d <= 10000)\n", container_get_quota(0));
        return 1;
    }
    if (container_can_consume(0, 10000) != 1) {
  104c34:	83 ec 08             	sub    $0x8,%esp
  104c37:	68 10 27 00 00       	push   $0x2710
  104c3c:	6a 00                	push   $0x0
  104c3e:	e8 dd fe ff ff       	call   104b20 <container_can_consume>
  104c43:	83 c4 10             	add    $0x10,%esp
  104c46:	83 f8 01             	cmp    $0x1,%eax
  104c49:	75 35                	jne    104c80 <MContainer_test1+0x70>
        dprintf("test 1.2 failed: (%d != 1)\n", container_can_consume(0, 10000));
        return 1;
    }
    if (container_can_consume(0, 10000000) != 0) {
  104c4b:	83 ec 08             	sub    $0x8,%esp
  104c4e:	68 80 96 98 00       	push   $0x989680
  104c53:	6a 00                	push   $0x0
  104c55:	e8 c6 fe ff ff       	call   104b20 <container_can_consume>
  104c5a:	83 c4 10             	add    $0x10,%esp
  104c5d:	85 c0                	test   %eax,%eax
  104c5f:	75 6f                	jne    104cd0 <MContainer_test1+0xc0>
        dprintf("test 1.3 failed: (%d != 0)\n", container_can_consume(0, 10000000));
        return 1;
    }
    dprintf("test 1 passed.\n");
  104c61:	83 ec 0c             	sub    $0xc,%esp
  104c64:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  104c6a:	50                   	push   %eax
  104c6b:	e8 32 df ff ff       	call   102ba2 <dprintf>
    return 0;
  104c70:	83 c4 10             	add    $0x10,%esp
  104c73:	31 c0                	xor    %eax,%eax
}
  104c75:	83 c4 08             	add    $0x8,%esp
  104c78:	5b                   	pop    %ebx
  104c79:	c3                   	ret
  104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dprintf("test 1.2 failed: (%d != 1)\n", container_can_consume(0, 10000));
  104c80:	83 ec 08             	sub    $0x8,%esp
  104c83:	68 10 27 00 00       	push   $0x2710
  104c88:	6a 00                	push   $0x0
  104c8a:	e8 91 fe ff ff       	call   104b20 <container_can_consume>
  104c8f:	5a                   	pop    %edx
  104c90:	59                   	pop    %ecx
  104c91:	50                   	push   %eax
  104c92:	8d 83 31 94 ff ff    	lea    -0x6bcf(%ebx),%eax
  104c98:	50                   	push   %eax
  104c99:	e8 04 df ff ff       	call   102ba2 <dprintf>
        return 1;
  104c9e:	83 c4 10             	add    $0x10,%esp
}
  104ca1:	83 c4 08             	add    $0x8,%esp
        return 1;
  104ca4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  104ca9:	5b                   	pop    %ebx
  104caa:	c3                   	ret
  104cab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.1 failed: (%d <= 10000)\n", container_get_quota(0));
  104cb0:	83 ec 0c             	sub    $0xc,%esp
  104cb3:	6a 00                	push   $0x0
  104cb5:	e8 26 fe ff ff       	call   104ae0 <container_get_quota>
  104cba:	5a                   	pop    %edx
  104cbb:	59                   	pop    %ecx
  104cbc:	50                   	push   %eax
  104cbd:	8d 83 7c 9d ff ff    	lea    -0x6284(%ebx),%eax
  104cc3:	50                   	push   %eax
  104cc4:	e8 d9 de ff ff       	call   102ba2 <dprintf>
        return 1;
  104cc9:	83 c4 10             	add    $0x10,%esp
  104ccc:	eb d3                	jmp    104ca1 <MContainer_test1+0x91>
  104cce:	66 90                	xchg   %ax,%ax
        dprintf("test 1.3 failed: (%d != 0)\n", container_can_consume(0, 10000000));
  104cd0:	83 ec 08             	sub    $0x8,%esp
  104cd3:	68 80 96 98 00       	push   $0x989680
  104cd8:	6a 00                	push   $0x0
  104cda:	e8 41 fe ff ff       	call   104b20 <container_can_consume>
  104cdf:	5a                   	pop    %edx
  104ce0:	59                   	pop    %ecx
  104ce1:	50                   	push   %eax
  104ce2:	8d 83 97 94 ff ff    	lea    -0x6b69(%ebx),%eax
  104ce8:	50                   	push   %eax
  104ce9:	e8 b4 de ff ff       	call   102ba2 <dprintf>
        return 1;
  104cee:	83 c4 10             	add    $0x10,%esp
  104cf1:	eb ae                	jmp    104ca1 <MContainer_test1+0x91>
  104cf3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104cfa:	00 
  104cfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00104d00 <MContainer_test2>:

int MContainer_test2()
{
  104d00:	55                   	push   %ebp
  104d01:	57                   	push   %edi
  104d02:	56                   	push   %esi
  104d03:	53                   	push   %ebx
  104d04:	e8 34 b6 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104d09:	81 c3 eb a2 00 00    	add    $0xa2eb,%ebx
  104d0f:	83 ec 38             	sub    $0x38,%esp
    unsigned int old_usage = container_get_usage(0);
  104d12:	6a 00                	push   $0x0
  104d14:	e8 e7 fd ff ff       	call   104b00 <container_get_usage>
    unsigned int old_nchildren = container_get_nchildren(0);
  104d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    unsigned int old_usage = container_get_usage(0);
  104d20:	89 c5                	mov    %eax,%ebp
    unsigned int old_nchildren = container_get_nchildren(0);
  104d22:	e8 99 fd ff ff       	call   104ac0 <container_get_nchildren>
  104d27:	89 c7                	mov    %eax,%edi
    unsigned int chid = container_split(0, 100);
  104d29:	58                   	pop    %eax
  104d2a:	5a                   	pop    %edx
  104d2b:	6a 64                	push   $0x64
  104d2d:	6a 00                	push   $0x0
  104d2f:	e8 1c fe ff ff       	call   104b50 <container_split>
    if (container_get_quota(chid) != 100
  104d34:	89 04 24             	mov    %eax,(%esp)
    unsigned int chid = container_split(0, 100);
  104d37:	89 c6                	mov    %eax,%esi
    if (container_get_quota(chid) != 100
  104d39:	e8 a2 fd ff ff       	call   104ae0 <container_get_quota>
        || container_get_parent(chid) != 0
        || container_get_usage(chid) != 0
        || container_get_nchildren(chid) != 0
        || container_get_usage(0) != old_usage + 100
  104d3e:	8d 55 64             	lea    0x64(%ebp),%edx
        || container_get_nchildren(0) != old_nchildren + 1) {
  104d41:	8d 4f 01             	lea    0x1(%edi),%ecx
        || container_get_usage(0) != old_usage + 100
  104d44:	89 54 24 1c          	mov    %edx,0x1c(%esp)
        || container_get_nchildren(0) != old_nchildren + 1) {
  104d48:	89 4c 24 20          	mov    %ecx,0x20(%esp)
    if (container_get_quota(chid) != 100
  104d4c:	83 c4 10             	add    $0x10,%esp
  104d4f:	83 f8 64             	cmp    $0x64,%eax
  104d52:	75 10                	jne    104d64 <MContainer_test2+0x64>
        || container_get_parent(chid) != 0
  104d54:	83 ec 0c             	sub    $0xc,%esp
  104d57:	56                   	push   %esi
  104d58:	e8 43 fd ff ff       	call   104aa0 <container_get_parent>
  104d5d:	83 c4 10             	add    $0x10,%esp
  104d60:	85 c0                	test   %eax,%eax
  104d62:	74 7c                	je     104de0 <MContainer_test2+0xe0>
        dprintf("test 2.1 failed:\n"
  104d64:	83 ec 0c             	sub    $0xc,%esp
  104d67:	6a 00                	push   $0x0
  104d69:	e8 52 fd ff ff       	call   104ac0 <container_get_nchildren>
  104d6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d75:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  104d79:	e8 82 fd ff ff       	call   104b00 <container_get_usage>
  104d7e:	89 34 24             	mov    %esi,(%esp)
  104d81:	89 44 24 28          	mov    %eax,0x28(%esp)
  104d85:	e8 36 fd ff ff       	call   104ac0 <container_get_nchildren>
  104d8a:	89 34 24             	mov    %esi,(%esp)
  104d8d:	89 44 24 24          	mov    %eax,0x24(%esp)
  104d91:	e8 6a fd ff ff       	call   104b00 <container_get_usage>
  104d96:	89 34 24             	mov    %esi,(%esp)
  104d99:	89 c5                	mov    %eax,%ebp
  104d9b:	e8 00 fd ff ff       	call   104aa0 <container_get_parent>
  104da0:	89 34 24             	mov    %esi,(%esp)
  104da3:	89 c7                	mov    %eax,%edi
  104da5:	e8 36 fd ff ff       	call   104ae0 <container_get_quota>
  104daa:	5e                   	pop    %esi
  104dab:	ff 74 24 1c          	push   0x1c(%esp)
  104daf:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  104db3:	52                   	push   %edx
  104db4:	ff 74 24 20          	push   0x20(%esp)
  104db8:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  104dbc:	51                   	push   %ecx
  104dbd:	ff 74 24 30          	push   0x30(%esp)
  104dc1:	55                   	push   %ebp
  104dc2:	57                   	push   %edi
  104dc3:	50                   	push   %eax
  104dc4:	8d 83 9c 9d ff ff    	lea    -0x6264(%ebx),%eax
  104dca:	50                   	push   %eax
  104dcb:	e8 d2 dd ff ff       	call   102ba2 <dprintf>
                container_get_parent(chid),
                container_get_usage(chid),
                container_get_nchildren(chid),
                container_get_usage(0), old_usage + 100,
                container_get_nchildren(0), old_nchildren + 1);
        return 1;
  104dd0:	83 c4 30             	add    $0x30,%esp
  104dd3:	b8 01 00 00 00       	mov    $0x1,%eax
        dprintf("test 2.2 failed: (%d != 1)\n", container_get_usage(chid));
        return 1;
    }
    dprintf("test 2 passed.\n");
    return 0;
}
  104dd8:	83 c4 2c             	add    $0x2c,%esp
  104ddb:	5b                   	pop    %ebx
  104ddc:	5e                   	pop    %esi
  104ddd:	5f                   	pop    %edi
  104dde:	5d                   	pop    %ebp
  104ddf:	c3                   	ret
        || container_get_usage(chid) != 0
  104de0:	83 ec 0c             	sub    $0xc,%esp
  104de3:	56                   	push   %esi
  104de4:	e8 17 fd ff ff       	call   104b00 <container_get_usage>
  104de9:	83 c4 10             	add    $0x10,%esp
  104dec:	85 c0                	test   %eax,%eax
  104dee:	0f 85 70 ff ff ff    	jne    104d64 <MContainer_test2+0x64>
        || container_get_nchildren(chid) != 0
  104df4:	83 ec 0c             	sub    $0xc,%esp
  104df7:	56                   	push   %esi
  104df8:	e8 c3 fc ff ff       	call   104ac0 <container_get_nchildren>
  104dfd:	83 c4 10             	add    $0x10,%esp
  104e00:	85 c0                	test   %eax,%eax
  104e02:	0f 85 5c ff ff ff    	jne    104d64 <MContainer_test2+0x64>
        || container_get_usage(0) != old_usage + 100
  104e08:	83 ec 0c             	sub    $0xc,%esp
  104e0b:	6a 00                	push   $0x0
  104e0d:	e8 ee fc ff ff       	call   104b00 <container_get_usage>
  104e12:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  104e16:	83 c4 10             	add    $0x10,%esp
  104e19:	39 f8                	cmp    %edi,%eax
  104e1b:	0f 85 43 ff ff ff    	jne    104d64 <MContainer_test2+0x64>
        || container_get_nchildren(0) != old_nchildren + 1) {
  104e21:	83 ec 0c             	sub    $0xc,%esp
  104e24:	6a 00                	push   $0x0
  104e26:	e8 95 fc ff ff       	call   104ac0 <container_get_nchildren>
  104e2b:	8b 7c 24 20          	mov    0x20(%esp),%edi
  104e2f:	83 c4 10             	add    $0x10,%esp
  104e32:	39 f8                	cmp    %edi,%eax
  104e34:	0f 85 2a ff ff ff    	jne    104d64 <MContainer_test2+0x64>
    container_alloc(chid);
  104e3a:	83 ec 0c             	sub    $0xc,%esp
  104e3d:	56                   	push   %esi
  104e3e:	e8 6d fd ff ff       	call   104bb0 <container_alloc>
    if (container_get_usage(chid) != 1) {
  104e43:	89 34 24             	mov    %esi,(%esp)
  104e46:	e8 b5 fc ff ff       	call   104b00 <container_get_usage>
  104e4b:	83 c4 10             	add    $0x10,%esp
  104e4e:	83 f8 01             	cmp    $0x1,%eax
  104e51:	74 20                	je     104e73 <MContainer_test2+0x173>
        dprintf("test 2.2 failed: (%d != 1)\n", container_get_usage(chid));
  104e53:	83 ec 0c             	sub    $0xc,%esp
  104e56:	56                   	push   %esi
  104e57:	e8 a4 fc ff ff       	call   104b00 <container_get_usage>
  104e5c:	5a                   	pop    %edx
  104e5d:	59                   	pop    %ecx
  104e5e:	50                   	push   %eax
  104e5f:	8d 83 b3 94 ff ff    	lea    -0x6b4d(%ebx),%eax
  104e65:	50                   	push   %eax
  104e66:	e8 37 dd ff ff       	call   102ba2 <dprintf>
        return 1;
  104e6b:	83 c4 10             	add    $0x10,%esp
  104e6e:	e9 60 ff ff ff       	jmp    104dd3 <MContainer_test2+0xd3>
    dprintf("test 2 passed.\n");
  104e73:	83 ec 0c             	sub    $0xc,%esp
  104e76:	8d 83 bd 93 ff ff    	lea    -0x6c43(%ebx),%eax
  104e7c:	50                   	push   %eax
  104e7d:	e8 20 dd ff ff       	call   102ba2 <dprintf>
    return 0;
  104e82:	83 c4 10             	add    $0x10,%esp
  104e85:	31 c0                	xor    %eax,%eax
  104e87:	e9 4c ff ff ff       	jmp    104dd8 <MContainer_test2+0xd8>
  104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104e90 <MContainer_test_own>:
int MContainer_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  104e90:	31 c0                	xor    %eax,%eax
  104e92:	c3                   	ret
  104e93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104e9a:	00 
  104e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00104ea0 <test_MContainer>:

int test_MContainer()
{
  104ea0:	53                   	push   %ebx
  104ea1:	83 ec 08             	sub    $0x8,%esp
    return MContainer_test1() + MContainer_test2() + MContainer_test_own();
  104ea4:	e8 67 fd ff ff       	call   104c10 <MContainer_test1>
  104ea9:	89 c3                	mov    %eax,%ebx
  104eab:	e8 50 fe ff ff       	call   104d00 <MContainer_test2>
}
  104eb0:	83 c4 08             	add    $0x8,%esp
    return MContainer_test1() + MContainer_test2() + MContainer_test_own();
  104eb3:	01 d8                	add    %ebx,%eax
}
  104eb5:	5b                   	pop    %ebx
  104eb6:	c3                   	ret
  104eb7:	66 90                	xchg   %ax,%ax
  104eb9:	66 90                	xchg   %ax,%ax
  104ebb:	66 90                	xchg   %ax,%ax
  104ebd:	66 90                	xchg   %ax,%ax
  104ebf:	90                   	nop

00104ec0 <set_pdir_base>:
 */
unsigned int IDPTbl[1024][1024] gcc_aligned(PAGESIZE);

// Sets the CR3 register with the start address of the page structure for process # [index].
void set_pdir_base(unsigned int index)
{
  104ec0:	53                   	push   %ebx
  104ec1:	e8 77 b4 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  104ec6:	81 c3 2e a1 00 00    	add    $0xa12e,%ebx
  104ecc:	83 ec 14             	sub    $0x14,%esp
    // TODO
    set_cr3((unsigned int **)PDirPool[index]);
  104ecf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  104ed3:	c1 e0 0c             	shl    $0xc,%eax
  104ed6:	8d 84 03 0c 10 c7 00 	lea    0xc7100c(%ebx,%eax,1),%eax
  104edd:	50                   	push   %eax
  104ede:	e8 f1 be ff ff       	call   100dd4 <set_cr3>
}
  104ee3:	83 c4 18             	add    $0x18,%esp
  104ee6:	5b                   	pop    %ebx
  104ee7:	c3                   	ret
  104ee8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104eef:	00 

00104ef0 <get_pdir_entry>:
// Returns the page directory entry # [pde_index] of the process # [proc_index].
// This can be used to test whether the page directory entry is mapped.
unsigned int get_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    // TODO
    return (unsigned int)PDirPool[proc_index][pde_index];
  104ef0:	e8 39 bf ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104ef5:	81 c2 ff a0 00 00    	add    $0xa0ff,%edx
  104efb:	8b 44 24 04          	mov    0x4(%esp),%eax
  104eff:	c1 e0 0a             	shl    $0xa,%eax
  104f02:	03 44 24 08          	add    0x8(%esp),%eax
  104f06:	8b 84 82 0c 10 c7 00 	mov    0xc7100c(%edx,%eax,4),%eax
}
  104f0d:	c3                   	ret
  104f0e:	66 90                	xchg   %ax,%ax

00104f10 <set_pdir_entry>:
void set_pdir_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int page_index)
{
    // TODO
    unsigned int value = (page_index << 12) | PT_PERM_PTU; 
    PDirPool[proc_index][pde_index] = (char *)value;
  104f10:	e8 24 b4 ff ff       	call   100339 <__x86.get_pc_thunk.cx>
  104f15:	81 c1 df a0 00 00    	add    $0xa0df,%ecx
    unsigned int value = (page_index << 12) | PT_PERM_PTU; 
  104f1b:	8b 54 24 0c          	mov    0xc(%esp),%edx
    PDirPool[proc_index][pde_index] = (char *)value;
  104f1f:	8b 44 24 04          	mov    0x4(%esp),%eax
    unsigned int value = (page_index << 12) | PT_PERM_PTU; 
  104f23:	c1 e2 0c             	shl    $0xc,%edx
    PDirPool[proc_index][pde_index] = (char *)value;
  104f26:	c1 e0 0a             	shl    $0xa,%eax
  104f29:	03 44 24 08          	add    0x8(%esp),%eax
    unsigned int value = (page_index << 12) | PT_PERM_PTU; 
  104f2d:	83 ca 07             	or     $0x7,%edx
  104f30:	89 94 81 0c 10 c7 00 	mov    %edx,0xc7100c(%ecx,%eax,4)
}
  104f37:	c3                   	ret
  104f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104f3f:	00 

00104f40 <set_pdir_entry_identity>:
// You should also set the permissions PTE_P, PTE_W, and PTE_U.
// This will be used to map a page directory entry to an identity page table.
void set_pdir_entry_identity(unsigned int proc_index, unsigned int pde_index)
{
    // TODO
    unsigned int value = (unsigned int)IDPTbl[pde_index];
  104f40:	e8 f4 b3 ff ff       	call   100339 <__x86.get_pc_thunk.cx>
  104f45:	81 c1 af a0 00 00    	add    $0xa0af,%ecx
{
  104f4b:	53                   	push   %ebx
  104f4c:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
    unsigned int value = (unsigned int)IDPTbl[pde_index];
  104f50:	89 d8                	mov    %ebx,%eax
  104f52:	c1 e0 0c             	shl    $0xc,%eax
  104f55:	8d 94 01 0c 10 87 00 	lea    0x87100c(%ecx,%eax,1),%edx
    value |= PT_PERM_PTU;
    PDirPool[proc_index][pde_index] = (char *)value;
  104f5c:	8b 44 24 08          	mov    0x8(%esp),%eax
    value |= PT_PERM_PTU;
  104f60:	83 ca 07             	or     $0x7,%edx
    PDirPool[proc_index][pde_index] = (char *)value;
  104f63:	c1 e0 0a             	shl    $0xa,%eax
  104f66:	01 d8                	add    %ebx,%eax
    value |= PT_PERM_PTU;
  104f68:	89 94 81 0c 10 c7 00 	mov    %edx,0xc7100c(%ecx,%eax,4)
}
  104f6f:	5b                   	pop    %ebx
  104f70:	c3                   	ret
  104f71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104f78:	00 
  104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104f80 <rmv_pdir_entry>:
// Removes the specified page directory entry (sets the page directory entry to 0).
// Don't forget to cast the value to (unsigned int *).
void rmv_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    // TODO
    PDirPool[proc_index][pde_index] = (char *)0x00000000;
  104f80:	e8 a9 be ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104f85:	81 c2 6f a0 00 00    	add    $0xa06f,%edx
  104f8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  104f8f:	c1 e0 0a             	shl    $0xa,%eax
  104f92:	03 44 24 08          	add    0x8(%esp),%eax
  104f96:	c7 84 82 0c 10 c7 00 	movl   $0x0,0xc7100c(%edx,%eax,4)
  104f9d:	00 00 00 00 
}
  104fa1:	c3                   	ret
  104fa2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  104fa9:	00 
  104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104fb0 <get_ptbl_entry>:
// Do not forget that the permission info is also stored in the page directory entries.
unsigned int get_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                            unsigned int pte_index)
{
    // TODO
    unsigned int pte_addr = (unsigned int )PDirPool[proc_index][pde_index];
  104fb0:	e8 79 be ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104fb5:	81 c2 3f a0 00 00    	add    $0xa03f,%edx
  104fbb:	8b 44 24 04          	mov    0x4(%esp),%eax
  104fbf:	c1 e0 0a             	shl    $0xa,%eax
  104fc2:	03 44 24 08          	add    0x8(%esp),%eax
  104fc6:	8b 84 82 0c 10 c7 00 	mov    0xc7100c(%edx,%eax,4),%eax
    pte_addr &= 0xfffff000; //remove perm bits
    pte_addr += pte_index << 2;//
    return *(unsigned int *)pte_addr; 
  104fcd:	8b 54 24 0c          	mov    0xc(%esp),%edx
    pte_addr &= 0xfffff000; //remove perm bits
  104fd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return *(unsigned int *)pte_addr; 
  104fd6:	8b 04 90             	mov    (%eax,%edx,4),%eax
    
}
  104fd9:	c3                   	ret
  104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104fe0 <set_ptbl_entry>:
                    unsigned int pte_index, unsigned int page_index,
                    unsigned int perm)
{
    // TODO
    unsigned int* pte;
    unsigned int pte_addr =  (unsigned int )PDirPool[proc_index][pde_index];
  104fe0:	e8 49 be ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  104fe5:	81 c2 0f a0 00 00    	add    $0xa00f,%edx
  104feb:	8b 44 24 04          	mov    0x4(%esp),%eax
    pte_addr += pte_index << 2;

    pte = (unsigned int *)pte_addr;
    *pte &= 0x00000000;
    *pte = page_index << 12;
    *pte |= (perm & 0x00000fff);
  104fef:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    unsigned int pte_addr =  (unsigned int )PDirPool[proc_index][pde_index];
  104ff3:	c1 e0 0a             	shl    $0xa,%eax
  104ff6:	03 44 24 08          	add    0x8(%esp),%eax
    *pte |= (perm & 0x00000fff);
  104ffa:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    unsigned int pte_addr =  (unsigned int )PDirPool[proc_index][pde_index];
  105000:	8b 94 82 0c 10 c7 00 	mov    0xc7100c(%edx,%eax,4),%edx
    *pte = page_index << 12;
  105007:	8b 44 24 10          	mov    0x10(%esp),%eax
  10500b:	c1 e0 0c             	shl    $0xc,%eax
    pte_addr &= 0xfffff000;//rmove perm bits
  10500e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    *pte |= (perm & 0x00000fff);
  105014:	09 c8                	or     %ecx,%eax
  105016:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  10501a:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
}
  10501d:	c3                   	ret
  10501e:	66 90                	xchg   %ax,%ax

00105020 <set_ptbl_entry_identity>:
void set_ptbl_entry_identity(unsigned int pde_index, unsigned int pte_index,
                             unsigned int perm)
{
    // TODO
    IDPTbl[pde_index][pte_index] = ((pde_index << 10) + pte_index) << 12;
    IDPTbl[pde_index][pte_index] |= perm;
  105020:	e8 14 b3 ff ff       	call   100339 <__x86.get_pc_thunk.cx>
  105025:	81 c1 cf 9f 00 00    	add    $0x9fcf,%ecx
  10502b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10502f:	c1 e0 0a             	shl    $0xa,%eax
  105032:	03 44 24 08          	add    0x8(%esp),%eax
    IDPTbl[pde_index][pte_index] = ((pde_index << 10) + pte_index) << 12;
  105036:	89 c2                	mov    %eax,%edx
  105038:	c1 e2 0c             	shl    $0xc,%edx
    IDPTbl[pde_index][pte_index] |= perm;
  10503b:	0b 54 24 0c          	or     0xc(%esp),%edx
  10503f:	89 94 81 0c 10 87 00 	mov    %edx,0x87100c(%ecx,%eax,4)
}
  105046:	c3                   	ret
  105047:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10504e:	00 
  10504f:	90                   	nop

00105050 <rmv_ptbl_entry>:
void rmv_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int pte_index)
{
    // TODO
    unsigned int * pte;
    unsigned int pte_addr = (unsigned int)PDirPool[proc_index][pde_index];
  105050:	e8 d9 bd ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  105055:	81 c2 9f 9f 00 00    	add    $0x9f9f,%edx
  10505b:	8b 44 24 04          	mov    0x4(%esp),%eax
  10505f:	c1 e0 0a             	shl    $0xa,%eax
  105062:	03 44 24 08          	add    0x8(%esp),%eax
  105066:	8b 84 82 0c 10 c7 00 	mov    0xc7100c(%edx,%eax,4),%eax
    pte_addr &= 0xfffff000;//remove perm bits
    pte_addr += pte_index << 2;
    pte = (unsigned int *)pte_addr;
    *pte &= 0x00000000;
  10506d:	8b 54 24 0c          	mov    0xc(%esp),%edx
    pte_addr &= 0xfffff000;//remove perm bits
  105071:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    *pte &= 0x00000000;
  105076:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
  10507d:	c3                   	ret
  10507e:	66 90                	xchg   %ax,%ax

00105080 <MPTIntro_test1>:

extern char *PDirPool[NUM_IDS][1024];
extern unsigned int IDPTbl[1024][1024];

int MPTIntro_test1()
{
  105080:	56                   	push   %esi
  105081:	53                   	push   %ebx
  105082:	e8 b6 b2 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105087:	81 c3 6d 9f 00 00    	add    $0x9f6d,%ebx
  10508d:	83 ec 10             	sub    $0x10,%esp
    set_pdir_base(0);
  105090:	6a 00                	push   $0x0
  105092:	e8 29 fe ff ff       	call   104ec0 <set_pdir_base>
    if ((unsigned int) PDirPool[0] != rcr3()) {
  105097:	e8 2d e5 ff ff       	call   1035c9 <rcr3>
  10509c:	c7 c6 00 00 d8 00    	mov    $0xd80000,%esi
  1050a2:	83 c4 10             	add    $0x10,%esp
  1050a5:	39 f0                	cmp    %esi,%eax
  1050a7:	74 27                	je     1050d0 <MPTIntro_test1+0x50>
        dprintf("test 1.1 failed: (%d != %d)\n",
  1050a9:	e8 1b e5 ff ff       	call   1035c9 <rcr3>
  1050ae:	83 ec 04             	sub    $0x4,%esp
  1050b1:	50                   	push   %eax
  1050b2:	8d 83 cf 94 ff ff    	lea    -0x6b31(%ebx),%eax
  1050b8:	56                   	push   %esi
  1050b9:	50                   	push   %eax
  1050ba:	e8 e3 da ff ff       	call   102ba2 <dprintf>
                (unsigned int) PDirPool[0], rcr3());
        return 1;
  1050bf:	83 c4 10             	add    $0x10,%esp
  1050c2:	b8 01 00 00 00       	mov    $0x1,%eax
                get_pdir_entry(1, 1), get_pdir_entry(1, 2));
        return 1;
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  1050c7:	83 c4 04             	add    $0x4,%esp
  1050ca:	5b                   	pop    %ebx
  1050cb:	5e                   	pop    %esi
  1050cc:	c3                   	ret
  1050cd:	8d 76 00             	lea    0x0(%esi),%esi
    set_pdir_entry_identity(1, 1);
  1050d0:	83 ec 08             	sub    $0x8,%esp
  1050d3:	6a 01                	push   $0x1
  1050d5:	6a 01                	push   $0x1
  1050d7:	e8 64 fe ff ff       	call   104f40 <set_pdir_entry_identity>
    set_pdir_entry(1, 2, 100);
  1050dc:	83 c4 0c             	add    $0xc,%esp
  1050df:	6a 64                	push   $0x64
  1050e1:	6a 02                	push   $0x2
  1050e3:	6a 01                	push   $0x1
  1050e5:	e8 26 fe ff ff       	call   104f10 <set_pdir_entry>
    if (get_pdir_entry(1, 1) != (unsigned int) IDPTbl[1] + 7) {
  1050ea:	58                   	pop    %eax
  1050eb:	5a                   	pop    %edx
  1050ec:	6a 01                	push   $0x1
  1050ee:	6a 01                	push   $0x1
  1050f0:	e8 fb fd ff ff       	call   104ef0 <get_pdir_entry>
  1050f5:	c7 c6 00 00 98 00    	mov    $0x980000,%esi
  1050fb:	83 c4 10             	add    $0x10,%esp
  1050fe:	81 c6 07 10 00 00    	add    $0x1007,%esi
  105104:	39 c6                	cmp    %eax,%esi
  105106:	74 28                	je     105130 <MPTIntro_test1+0xb0>
        dprintf("test 1.2 failed: (%d != %d)\n",
  105108:	83 ec 08             	sub    $0x8,%esp
  10510b:	6a 01                	push   $0x1
  10510d:	6a 01                	push   $0x1
  10510f:	e8 dc fd ff ff       	call   104ef0 <get_pdir_entry>
  105114:	83 c4 0c             	add    $0xc,%esp
  105117:	56                   	push   %esi
  105118:	50                   	push   %eax
  105119:	8d 83 ec 94 ff ff    	lea    -0x6b14(%ebx),%eax
  10511f:	50                   	push   %eax
  105120:	e8 7d da ff ff       	call   102ba2 <dprintf>
        return 1;
  105125:	83 c4 10             	add    $0x10,%esp
  105128:	eb 98                	jmp    1050c2 <MPTIntro_test1+0x42>
  10512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (get_pdir_entry(1, 2) != 409607) {
  105130:	83 ec 08             	sub    $0x8,%esp
  105133:	6a 02                	push   $0x2
  105135:	6a 01                	push   $0x1
  105137:	e8 b4 fd ff ff       	call   104ef0 <get_pdir_entry>
  10513c:	83 c4 10             	add    $0x10,%esp
  10513f:	3d 07 40 06 00       	cmp    $0x64007,%eax
  105144:	75 72                	jne    1051b8 <MPTIntro_test1+0x138>
    rmv_pdir_entry(1, 1);
  105146:	83 ec 08             	sub    $0x8,%esp
  105149:	6a 01                	push   $0x1
  10514b:	6a 01                	push   $0x1
  10514d:	e8 2e fe ff ff       	call   104f80 <rmv_pdir_entry>
    rmv_pdir_entry(1, 2);
  105152:	59                   	pop    %ecx
  105153:	5e                   	pop    %esi
  105154:	6a 02                	push   $0x2
  105156:	6a 01                	push   $0x1
  105158:	e8 23 fe ff ff       	call   104f80 <rmv_pdir_entry>
    if (get_pdir_entry(1, 1) != 0 || get_pdir_entry(1, 2) != 0) {
  10515d:	58                   	pop    %eax
  10515e:	5a                   	pop    %edx
  10515f:	6a 01                	push   $0x1
  105161:	6a 01                	push   $0x1
  105163:	e8 88 fd ff ff       	call   104ef0 <get_pdir_entry>
  105168:	83 c4 10             	add    $0x10,%esp
  10516b:	85 c0                	test   %eax,%eax
  10516d:	75 13                	jne    105182 <MPTIntro_test1+0x102>
  10516f:	83 ec 08             	sub    $0x8,%esp
  105172:	6a 02                	push   $0x2
  105174:	6a 01                	push   $0x1
  105176:	e8 75 fd ff ff       	call   104ef0 <get_pdir_entry>
  10517b:	83 c4 10             	add    $0x10,%esp
  10517e:	85 c0                	test   %eax,%eax
  105180:	74 5e                	je     1051e0 <MPTIntro_test1+0x160>
        dprintf("test 1.4 failed: (%d != 0 || %d != 0)\n",
  105182:	83 ec 08             	sub    $0x8,%esp
  105185:	6a 02                	push   $0x2
  105187:	6a 01                	push   $0x1
  105189:	e8 62 fd ff ff       	call   104ef0 <get_pdir_entry>
  10518e:	89 c6                	mov    %eax,%esi
  105190:	58                   	pop    %eax
  105191:	5a                   	pop    %edx
  105192:	6a 01                	push   $0x1
  105194:	6a 01                	push   $0x1
  105196:	e8 55 fd ff ff       	call   104ef0 <get_pdir_entry>
  10519b:	83 c4 0c             	add    $0xc,%esp
  10519e:	56                   	push   %esi
  10519f:	50                   	push   %eax
  1051a0:	8d 83 18 9e ff ff    	lea    -0x61e8(%ebx),%eax
  1051a6:	50                   	push   %eax
  1051a7:	e8 f6 d9 ff ff       	call   102ba2 <dprintf>
        return 1;
  1051ac:	83 c4 10             	add    $0x10,%esp
  1051af:	e9 0e ff ff ff       	jmp    1050c2 <MPTIntro_test1+0x42>
  1051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        dprintf("test 1.3 failed: (%d != 409607)\n", get_pdir_entry(1, 2));
  1051b8:	83 ec 08             	sub    $0x8,%esp
  1051bb:	6a 02                	push   $0x2
  1051bd:	6a 01                	push   $0x1
  1051bf:	e8 2c fd ff ff       	call   104ef0 <get_pdir_entry>
  1051c4:	59                   	pop    %ecx
  1051c5:	5e                   	pop    %esi
  1051c6:	50                   	push   %eax
  1051c7:	8d 83 f4 9d ff ff    	lea    -0x620c(%ebx),%eax
  1051cd:	50                   	push   %eax
  1051ce:	e8 cf d9 ff ff       	call   102ba2 <dprintf>
        return 1;
  1051d3:	83 c4 10             	add    $0x10,%esp
  1051d6:	e9 e7 fe ff ff       	jmp    1050c2 <MPTIntro_test1+0x42>
  1051db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    dprintf("test 1 passed.\n");
  1051e0:	83 ec 0c             	sub    $0xc,%esp
  1051e3:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  1051e9:	50                   	push   %eax
  1051ea:	e8 b3 d9 ff ff       	call   102ba2 <dprintf>
    return 0;
  1051ef:	83 c4 10             	add    $0x10,%esp
  1051f2:	31 c0                	xor    %eax,%eax
  1051f4:	e9 ce fe ff ff       	jmp    1050c7 <MPTIntro_test1+0x47>
  1051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105200 <MPTIntro_test2>:

int MPTIntro_test2()
{
  105200:	53                   	push   %ebx
  105201:	e8 37 b1 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105206:	81 c3 ee 9d 00 00    	add    $0x9dee,%ebx
  10520c:	83 ec 0c             	sub    $0xc,%esp
    set_pdir_entry(1, 1, 10000);
  10520f:	68 10 27 00 00       	push   $0x2710
  105214:	6a 01                	push   $0x1
  105216:	6a 01                	push   $0x1
  105218:	e8 f3 fc ff ff       	call   104f10 <set_pdir_entry>
    set_ptbl_entry(1, 1, 1, 10000, 259);
  10521d:	c7 04 24 03 01 00 00 	movl   $0x103,(%esp)
  105224:	68 10 27 00 00       	push   $0x2710
  105229:	6a 01                	push   $0x1
  10522b:	6a 01                	push   $0x1
  10522d:	6a 01                	push   $0x1
  10522f:	e8 ac fd ff ff       	call   104fe0 <set_ptbl_entry>
    if (get_ptbl_entry(1, 1, 1) != 40960259) {
  105234:	83 c4 1c             	add    $0x1c,%esp
  105237:	6a 01                	push   $0x1
  105239:	6a 01                	push   $0x1
  10523b:	6a 01                	push   $0x1
  10523d:	e8 6e fd ff ff       	call   104fb0 <get_ptbl_entry>
  105242:	83 c4 10             	add    $0x10,%esp
  105245:	3d 03 01 71 02       	cmp    $0x2710103,%eax
  10524a:	74 34                	je     105280 <MPTIntro_test2+0x80>
        dprintf("test 2.1 failed: (%d != 40960259)\n", get_ptbl_entry(1, 1, 1));
  10524c:	83 ec 04             	sub    $0x4,%esp
  10524f:	6a 01                	push   $0x1
  105251:	6a 01                	push   $0x1
  105253:	6a 01                	push   $0x1
  105255:	e8 56 fd ff ff       	call   104fb0 <get_ptbl_entry>
  10525a:	5a                   	pop    %edx
  10525b:	59                   	pop    %ecx
  10525c:	50                   	push   %eax
  10525d:	8d 83 40 9e ff ff    	lea    -0x61c0(%ebx),%eax
  105263:	50                   	push   %eax
  105264:	e8 39 d9 ff ff       	call   102ba2 <dprintf>
        return 1;
  105269:	83 c4 10             	add    $0x10,%esp
        return 1;
    }
    rmv_pdir_entry(1, 1);
    dprintf("test 2 passed.\n");
    return 0;
}
  10526c:	83 c4 08             	add    $0x8,%esp
        return 1;
  10526f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  105274:	5b                   	pop    %ebx
  105275:	c3                   	ret
  105276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10527d:	00 
  10527e:	66 90                	xchg   %ax,%ax
    rmv_ptbl_entry(1, 1, 1);
  105280:	83 ec 04             	sub    $0x4,%esp
  105283:	6a 01                	push   $0x1
  105285:	6a 01                	push   $0x1
  105287:	6a 01                	push   $0x1
  105289:	e8 c2 fd ff ff       	call   105050 <rmv_ptbl_entry>
    if (get_ptbl_entry(1, 1, 1) != 0) {
  10528e:	83 c4 0c             	add    $0xc,%esp
  105291:	6a 01                	push   $0x1
  105293:	6a 01                	push   $0x1
  105295:	6a 01                	push   $0x1
  105297:	e8 14 fd ff ff       	call   104fb0 <get_ptbl_entry>
  10529c:	83 c4 10             	add    $0x10,%esp
  10529f:	85 c0                	test   %eax,%eax
  1052a1:	75 2d                	jne    1052d0 <MPTIntro_test2+0xd0>
    rmv_pdir_entry(1, 1);
  1052a3:	83 ec 08             	sub    $0x8,%esp
  1052a6:	6a 01                	push   $0x1
  1052a8:	6a 01                	push   $0x1
  1052aa:	e8 d1 fc ff ff       	call   104f80 <rmv_pdir_entry>
    dprintf("test 2 passed.\n");
  1052af:	8d 83 bd 93 ff ff    	lea    -0x6c43(%ebx),%eax
  1052b5:	89 04 24             	mov    %eax,(%esp)
  1052b8:	e8 e5 d8 ff ff       	call   102ba2 <dprintf>
    return 0;
  1052bd:	83 c4 10             	add    $0x10,%esp
  1052c0:	31 c0                	xor    %eax,%eax
}
  1052c2:	83 c4 08             	add    $0x8,%esp
  1052c5:	5b                   	pop    %ebx
  1052c6:	c3                   	ret
  1052c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1052ce:	00 
  1052cf:	90                   	nop
        dprintf("test 2.2 failed: (%d != 0)\n", get_ptbl_entry(1, 1, 1));
  1052d0:	83 ec 04             	sub    $0x4,%esp
  1052d3:	6a 01                	push   $0x1
  1052d5:	6a 01                	push   $0x1
  1052d7:	6a 01                	push   $0x1
  1052d9:	e8 d2 fc ff ff       	call   104fb0 <get_ptbl_entry>
  1052de:	5a                   	pop    %edx
  1052df:	59                   	pop    %ecx
  1052e0:	50                   	push   %eax
  1052e1:	8d 83 09 95 ff ff    	lea    -0x6af7(%ebx),%eax
  1052e7:	50                   	push   %eax
  1052e8:	e8 b5 d8 ff ff       	call   102ba2 <dprintf>
        return 1;
  1052ed:	83 c4 10             	add    $0x10,%esp
  1052f0:	e9 77 ff ff ff       	jmp    10526c <MPTIntro_test2+0x6c>
  1052f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1052fc:	00 
  1052fd:	8d 76 00             	lea    0x0(%esi),%esi

00105300 <MPTIntro_test_own>:
int MPTIntro_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  105300:	31 c0                	xor    %eax,%eax
  105302:	c3                   	ret
  105303:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10530a:	00 
  10530b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105310 <test_MPTIntro>:

int test_MPTIntro()
{
  105310:	53                   	push   %ebx
  105311:	83 ec 08             	sub    $0x8,%esp
    return MPTIntro_test1() + MPTIntro_test2() + MPTIntro_test_own();
  105314:	e8 67 fd ff ff       	call   105080 <MPTIntro_test1>
  105319:	89 c3                	mov    %eax,%ebx
  10531b:	e8 e0 fe ff ff       	call   105200 <MPTIntro_test2>
}
  105320:	83 c4 08             	add    $0x8,%esp
    return MPTIntro_test1() + MPTIntro_test2() + MPTIntro_test_own();
  105323:	01 d8                	add    %ebx,%eax
}
  105325:	5b                   	pop    %ebx
  105326:	c3                   	ret
  105327:	66 90                	xchg   %ax,%ax
  105329:	66 90                	xchg   %ax,%ax
  10532b:	66 90                	xchg   %ax,%ax
  10532d:	66 90                	xchg   %ax,%ax
  10532f:	90                   	nop

00105330 <get_ptbl_entry_by_va>:
 * Returns the page table entry corresponding to the virtual address,
 * according to the page structure of process # [proc_index].
 * Returns 0 if the mapping does not exist.
 */
unsigned int get_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  105330:	55                   	push   %ebp
  105331:	57                   	push   %edi
  105332:	56                   	push   %esi
  105333:	53                   	push   %ebx
  105334:	e8 04 b0 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105339:	81 c3 bb 9c 00 00    	add    $0x9cbb,%ebx
  10533f:	83 ec 14             	sub    $0x14,%esp
  105342:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  105346:	8b 7c 24 28          	mov    0x28(%esp),%edi
    // TODO
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
  10534a:	89 f5                	mov    %esi,%ebp
  10534c:	c1 ed 16             	shr    $0x16,%ebp
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;

    unsigned int pde = get_pdir_entry(proc_index, pde_index);
  10534f:	55                   	push   %ebp
  105350:	57                   	push   %edi
  105351:	e8 9a fb ff ff       	call   104ef0 <get_pdir_entry>
    // check the present bit of page directory entry
    if ((pde & PTE_P) == 0) {
  105356:	83 c4 10             	add    $0x10,%esp
  105359:	a8 01                	test   $0x1,%al
  10535b:	75 13                	jne    105370 <get_ptbl_entry_by_va+0x40>
    //check the present bit of page table entry
    if ((pte & PTE_P) == 0) {
        return 0;
    }
    return pte;
}         
  10535d:	83 c4 0c             	add    $0xc,%esp
        return 0;
  105360:	31 c0                	xor    %eax,%eax
}         
  105362:	5b                   	pop    %ebx
  105363:	5e                   	pop    %esi
  105364:	5f                   	pop    %edi
  105365:	5d                   	pop    %ebp
  105366:	c3                   	ret
  105367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10536e:	00 
  10536f:	90                   	nop
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
  105370:	c1 ee 0c             	shr    $0xc,%esi
    unsigned int pte = get_ptbl_entry(proc_index, pde_index, pte_index);
  105373:	83 ec 04             	sub    $0x4,%esp
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
  105376:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
    unsigned int pte = get_ptbl_entry(proc_index, pde_index, pte_index);
  10537c:	56                   	push   %esi
  10537d:	55                   	push   %ebp
  10537e:	57                   	push   %edi
  10537f:	e8 2c fc ff ff       	call   104fb0 <get_ptbl_entry>
    if ((pte & PTE_P) == 0) {
  105384:	83 c4 10             	add    $0x10,%esp
  105387:	a8 01                	test   $0x1,%al
  105389:	74 d2                	je     10535d <get_ptbl_entry_by_va+0x2d>
}         
  10538b:	83 c4 0c             	add    $0xc,%esp
  10538e:	5b                   	pop    %ebx
  10538f:	5e                   	pop    %esi
  105390:	5f                   	pop    %edi
  105391:	5d                   	pop    %ebp
  105392:	c3                   	ret
  105393:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10539a:	00 
  10539b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001053a0 <get_pdir_entry_by_va>:

// returns the page directory entry corresponding to the given virtual address
unsigned int get_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  1053a0:	53                   	push   %ebx
  1053a1:	e8 97 af ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1053a6:	81 c3 4e 9c 00 00    	add    $0x9c4e,%ebx
  1053ac:	83 ec 10             	sub    $0x10,%esp
    // TODO
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
  1053af:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1053b3:	c1 e8 16             	shr    $0x16,%eax
    unsigned int pde = get_pdir_entry(proc_index, pde_index);
  1053b6:	50                   	push   %eax
  1053b7:	ff 74 24 1c          	push   0x1c(%esp)
  1053bb:	e8 30 fb ff ff       	call   104ef0 <get_pdir_entry>
    return pde;
}
  1053c0:	83 c4 18             	add    $0x18,%esp
  1053c3:	5b                   	pop    %ebx
  1053c4:	c3                   	ret
  1053c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1053cc:	00 
  1053cd:	8d 76 00             	lea    0x0(%esi),%esi

001053d0 <rmv_ptbl_entry_by_va>:

// removes the page table entry for the given virtual address
void rmv_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  1053d0:	55                   	push   %ebp
  1053d1:	57                   	push   %edi
  1053d2:	56                   	push   %esi
  1053d3:	53                   	push   %ebx
  1053d4:	e8 64 af ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1053d9:	81 c3 1b 9c 00 00    	add    $0x9c1b,%ebx
  1053df:	83 ec 14             	sub    $0x14,%esp
  1053e2:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  1053e6:	8b 7c 24 28          	mov    0x28(%esp),%edi
    // TODO
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
  1053ea:	89 f5                	mov    %esi,%ebp
  1053ec:	c1 ed 16             	shr    $0x16,%ebp
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;

    unsigned int pde = get_pdir_entry(proc_index, pde_index);
  1053ef:	55                   	push   %ebp
  1053f0:	57                   	push   %edi
  1053f1:	e8 fa fa ff ff       	call   104ef0 <get_pdir_entry>
    // check the present bit of page directory entry
    if ((pde & PTE_P) == 0) {
  1053f6:	83 c4 10             	add    $0x10,%esp
  1053f9:	a8 01                	test   $0x1,%al
  1053fb:	74 17                	je     105414 <rmv_ptbl_entry_by_va+0x44>
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
  1053fd:	c1 ee 0c             	shr    $0xc,%esi
    // the page directory entry is not valid for address translation
        return;
    }
    rmv_ptbl_entry(proc_index, pde_index, pte_index);
  105400:	83 ec 04             	sub    $0x4,%esp
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
  105403:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
    rmv_ptbl_entry(proc_index, pde_index, pte_index);
  105409:	56                   	push   %esi
  10540a:	55                   	push   %ebp
  10540b:	57                   	push   %edi
  10540c:	e8 3f fc ff ff       	call   105050 <rmv_ptbl_entry>
  105411:	83 c4 10             	add    $0x10,%esp
}
  105414:	83 c4 0c             	add    $0xc,%esp
  105417:	5b                   	pop    %ebx
  105418:	5e                   	pop    %esi
  105419:	5f                   	pop    %edi
  10541a:	5d                   	pop    %ebp
  10541b:	c3                   	ret
  10541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105420 <rmv_pdir_entry_by_va>:

// removes the page directory entry for the given virtual address
void rmv_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  105420:	53                   	push   %ebx
  105421:	e8 17 af ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105426:	81 c3 ce 9b 00 00    	add    $0x9bce,%ebx
  10542c:	83 ec 10             	sub    $0x10,%esp
    // TODO
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
  10542f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  105433:	c1 e8 16             	shr    $0x16,%eax
    rmv_pdir_entry(proc_index, pde_index);
  105436:	50                   	push   %eax
  105437:	ff 74 24 1c          	push   0x1c(%esp)
  10543b:	e8 40 fb ff ff       	call   104f80 <rmv_pdir_entry>
}
  105440:	83 c4 18             	add    $0x18,%esp
  105443:	5b                   	pop    %ebx
  105444:	c3                   	ret
  105445:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10544c:	00 
  10544d:	8d 76 00             	lea    0x0(%esi),%esi

00105450 <set_ptbl_entry_by_va>:

// maps the virtual address [vaddr] to the physical page # [page_index] with permission [perm]
// you do not need to worry about the page directory entry. just map the page table entry.
void set_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr, unsigned int page_index, unsigned int perm)
{
  105450:	53                   	push   %ebx
  105451:	e8 e7 ae ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105456:	81 c3 9e 9b 00 00    	add    $0x9b9e,%ebx
  10545c:	83 ec 14             	sub    $0x14,%esp
  10545f:	8b 44 24 20          	mov    0x20(%esp),%eax
    // TODO
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
    set_ptbl_entry(proc_index, pde_index, pte_index, page_index, perm);
  105463:	ff 74 24 28          	push   0x28(%esp)
  105467:	ff 74 24 28          	push   0x28(%esp)
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
  10546b:	89 c2                	mov    %eax,%edx
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
  10546d:	c1 e8 16             	shr    $0x16,%eax
    unsigned int pte_index = (vaddr & VA_PTBL_MASK) >> 12;
  105470:	c1 ea 0c             	shr    $0xc,%edx
  105473:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
    set_ptbl_entry(proc_index, pde_index, pte_index, page_index, perm);
  105479:	52                   	push   %edx
  10547a:	50                   	push   %eax
  10547b:	ff 74 24 2c          	push   0x2c(%esp)
  10547f:	e8 5c fb ff ff       	call   104fe0 <set_ptbl_entry>
}
  105484:	83 c4 28             	add    $0x28,%esp
  105487:	5b                   	pop    %ebx
  105488:	c3                   	ret
  105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105490 <set_pdir_entry_by_va>:

// registers the mapping from [vaddr] to physical page # [page_index] in the page directory
void set_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr, unsigned int page_index)
{
  105490:	53                   	push   %ebx
  105491:	e8 a7 ae ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105496:	81 c3 5e 9b 00 00    	add    $0x9b5e,%ebx
  10549c:	83 ec 0c             	sub    $0xc,%esp
    // TODO
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
    set_pdir_entry(proc_index, pde_index, page_index);
  10549f:	ff 74 24 1c          	push   0x1c(%esp)
    unsigned int pde_index = (vaddr & VA_PDIR_MASK) >> 22;
  1054a3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1054a7:	c1 e8 16             	shr    $0x16,%eax
    set_pdir_entry(proc_index, pde_index, page_index);
  1054aa:	50                   	push   %eax
  1054ab:	ff 74 24 1c          	push   0x1c(%esp)
  1054af:	e8 5c fa ff ff       	call   104f10 <set_pdir_entry>
}   
  1054b4:	83 c4 18             	add    $0x18,%esp
  1054b7:	5b                   	pop    %ebx
  1054b8:	c3                   	ret
  1054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001054c0 <idptbl_init>:

// initializes the identity page table
// the permission for the kernel memory should be PTE_P, PTE_W, and PTE_G,
// while the permission for the rest should be PTE_P and PTE_W.
void idptbl_init(unsigned int mbi_adr)
{
  1054c0:	56                   	push   %esi
    //
    container_init(mbi_adr);

    // TODO
    unsigned int addr;
    for (addr = 0; addr < 0xFFFFF000; addr += PAGESIZE) {
  1054c1:	31 f6                	xor    %esi,%esi
{
  1054c3:	53                   	push   %ebx
  1054c4:	e8 74 ae ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1054c9:	81 c3 2b 9b 00 00    	add    $0x9b2b,%ebx
  1054cf:	83 ec 10             	sub    $0x10,%esp
    container_init(mbi_adr);
  1054d2:	ff 74 24 1c          	push   0x1c(%esp)
  1054d6:	e8 f5 f4 ff ff       	call   1049d0 <container_init>
  1054db:	83 c4 10             	add    $0x10,%esp
  1054de:	66 90                	xchg   %ax,%ax
        unsigned int pde_index = (addr & VA_PDIR_MASK) >> 22;
        unsigned int pte_index = (addr & VA_PTBL_MASK) >> 12;
  1054e0:	89 f0                	mov    %esi,%eax
        unsigned int pde_index = (addr & VA_PDIR_MASK) >> 22;
  1054e2:	89 f2                	mov    %esi,%edx
        if (addr < VM_USERLO || addr >= VM_USERHI) {
  1054e4:	8d 8e 00 00 00 c0    	lea    -0x40000000(%esi),%ecx
        unsigned int pte_index = (addr & VA_PTBL_MASK) >> 12;
  1054ea:	c1 e8 0c             	shr    $0xc,%eax
        unsigned int pde_index = (addr & VA_PDIR_MASK) >> 22;
  1054ed:	c1 ea 16             	shr    $0x16,%edx
        unsigned int pte_index = (addr & VA_PTBL_MASK) >> 12;
  1054f0:	25 ff 03 00 00       	and    $0x3ff,%eax
        if (addr < VM_USERLO || addr >= VM_USERHI) {
  1054f5:	81 f9 ff ff ff af    	cmp    $0xafffffff,%ecx
  1054fb:	76 26                	jbe    105523 <idptbl_init+0x63>
            //kernel pages
            set_ptbl_entry_identity(pde_index, pte_index, PT_PERM_PWG);
  1054fd:	83 ec 04             	sub    $0x4,%esp
    for (addr = 0; addr < 0xFFFFF000; addr += PAGESIZE) {
  105500:	81 c6 00 10 00 00    	add    $0x1000,%esi
            set_ptbl_entry_identity(pde_index, pte_index, PT_PERM_PWG);
  105506:	68 03 01 00 00       	push   $0x103
  10550b:	50                   	push   %eax
  10550c:	52                   	push   %edx
  10550d:	e8 0e fb ff ff       	call   105020 <set_ptbl_entry_identity>
    for (addr = 0; addr < 0xFFFFF000; addr += PAGESIZE) {
  105512:	83 c4 10             	add    $0x10,%esp
  105515:	81 fe 00 f0 ff ff    	cmp    $0xfffff000,%esi
  10551b:	75 c3                	jne    1054e0 <idptbl_init+0x20>
        }else {
            //not kernel pages
            set_ptbl_entry_identity(pde_index, pte_index, PT_PERM_PW);
        }
    }
  10551d:	83 c4 04             	add    $0x4,%esp
  105520:	5b                   	pop    %ebx
  105521:	5e                   	pop    %esi
  105522:	c3                   	ret
            set_ptbl_entry_identity(pde_index, pte_index, PT_PERM_PW);
  105523:	51                   	push   %ecx
    for (addr = 0; addr < 0xFFFFF000; addr += PAGESIZE) {
  105524:	81 c6 00 10 00 00    	add    $0x1000,%esi
            set_ptbl_entry_identity(pde_index, pte_index, PT_PERM_PW);
  10552a:	6a 03                	push   $0x3
  10552c:	50                   	push   %eax
  10552d:	52                   	push   %edx
  10552e:	e8 ed fa ff ff       	call   105020 <set_ptbl_entry_identity>
    for (addr = 0; addr < 0xFFFFF000; addr += PAGESIZE) {
  105533:	83 c4 10             	add    $0x10,%esp
  105536:	eb a8                	jmp    1054e0 <idptbl_init+0x20>
  105538:	66 90                	xchg   %ax,%ax
  10553a:	66 90                	xchg   %ax,%ax
  10553c:	66 90                	xchg   %ax,%ax
  10553e:	66 90                	xchg   %ax,%ax

00105540 <MPTOp_test1>:
#include <lib/debug.h>
#include "export.h"

int MPTOp_test1()
{
  105540:	53                   	push   %ebx
  105541:	e8 f7 ad ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105546:	81 c3 ae 9a 00 00    	add    $0x9aae,%ebx
  10554c:	83 ec 10             	sub    $0x10,%esp
    unsigned int vaddr = 4096 * 1024 * 300;
    if (get_ptbl_entry_by_va(10, vaddr) != 0) {
  10554f:	68 00 00 00 4b       	push   $0x4b000000
  105554:	6a 0a                	push   $0xa
  105556:	e8 d5 fd ff ff       	call   105330 <get_ptbl_entry_by_va>
  10555b:	83 c4 10             	add    $0x10,%esp
  10555e:	85 c0                	test   %eax,%eax
  105560:	0f 85 0a 01 00 00    	jne    105670 <MPTOp_test1+0x130>
        dprintf("test 1.1 failed: (%d != 0)\n", get_ptbl_entry_by_va(10, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(10, vaddr) != 0) {
  105566:	83 ec 08             	sub    $0x8,%esp
  105569:	68 00 00 00 4b       	push   $0x4b000000
  10556e:	6a 0a                	push   $0xa
  105570:	e8 2b fe ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105575:	83 c4 10             	add    $0x10,%esp
  105578:	85 c0                	test   %eax,%eax
  10557a:	0f 85 c0 00 00 00    	jne    105640 <MPTOp_test1+0x100>
        dprintf("test 1.2 failed: (%d != 0)\n", get_pdir_entry_by_va(10, vaddr));
        return 1;
    }
    set_pdir_entry_by_va(10, vaddr, 100);
  105580:	83 ec 04             	sub    $0x4,%esp
  105583:	6a 64                	push   $0x64
  105585:	68 00 00 00 4b       	push   $0x4b000000
  10558a:	6a 0a                	push   $0xa
  10558c:	e8 ff fe ff ff       	call   105490 <set_pdir_entry_by_va>
    set_ptbl_entry_by_va(10, vaddr, 100, 259);
  105591:	68 03 01 00 00       	push   $0x103
  105596:	6a 64                	push   $0x64
  105598:	68 00 00 00 4b       	push   $0x4b000000
  10559d:	6a 0a                	push   $0xa
  10559f:	e8 ac fe ff ff       	call   105450 <set_ptbl_entry_by_va>
    if (get_ptbl_entry_by_va(10, vaddr) == 0) {
  1055a4:	83 c4 18             	add    $0x18,%esp
  1055a7:	68 00 00 00 4b       	push   $0x4b000000
  1055ac:	6a 0a                	push   $0xa
  1055ae:	e8 7d fd ff ff       	call   105330 <get_ptbl_entry_by_va>
  1055b3:	83 c4 10             	add    $0x10,%esp
  1055b6:	85 c0                	test   %eax,%eax
  1055b8:	0f 84 02 01 00 00    	je     1056c0 <MPTOp_test1+0x180>
        dprintf("test 1.3 failed: (%d == 0)\n", get_ptbl_entry_by_va(10, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(10, vaddr) == 0) {
  1055be:	83 ec 08             	sub    $0x8,%esp
  1055c1:	68 00 00 00 4b       	push   $0x4b000000
  1055c6:	6a 0a                	push   $0xa
  1055c8:	e8 d3 fd ff ff       	call   1053a0 <get_pdir_entry_by_va>
  1055cd:	83 c4 10             	add    $0x10,%esp
  1055d0:	85 c0                	test   %eax,%eax
  1055d2:	0f 84 c0 00 00 00    	je     105698 <MPTOp_test1+0x158>
        dprintf("test 1.4 failed: (%d == 0)\n", get_pdir_entry_by_va(10, vaddr));
        return 1;
    }
    rmv_ptbl_entry_by_va(10, vaddr);
  1055d8:	83 ec 08             	sub    $0x8,%esp
  1055db:	68 00 00 00 4b       	push   $0x4b000000
  1055e0:	6a 0a                	push   $0xa
  1055e2:	e8 e9 fd ff ff       	call   1053d0 <rmv_ptbl_entry_by_va>
    rmv_pdir_entry_by_va(10, vaddr);
  1055e7:	58                   	pop    %eax
  1055e8:	5a                   	pop    %edx
  1055e9:	68 00 00 00 4b       	push   $0x4b000000
  1055ee:	6a 0a                	push   $0xa
  1055f0:	e8 2b fe ff ff       	call   105420 <rmv_pdir_entry_by_va>
    if (get_ptbl_entry_by_va(10, vaddr) != 0) {
  1055f5:	59                   	pop    %ecx
  1055f6:	58                   	pop    %eax
  1055f7:	68 00 00 00 4b       	push   $0x4b000000
  1055fc:	6a 0a                	push   $0xa
  1055fe:	e8 2d fd ff ff       	call   105330 <get_ptbl_entry_by_va>
  105603:	83 c4 10             	add    $0x10,%esp
  105606:	85 c0                	test   %eax,%eax
  105608:	0f 85 e2 00 00 00    	jne    1056f0 <MPTOp_test1+0x1b0>
        dprintf("test 1.5 failed: (%d != 0)\n", get_ptbl_entry_by_va(10, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(10, vaddr) != 0) {
  10560e:	83 ec 08             	sub    $0x8,%esp
  105611:	68 00 00 00 4b       	push   $0x4b000000
  105616:	6a 0a                	push   $0xa
  105618:	e8 83 fd ff ff       	call   1053a0 <get_pdir_entry_by_va>
  10561d:	83 c4 10             	add    $0x10,%esp
  105620:	85 c0                	test   %eax,%eax
  105622:	0f 85 f8 00 00 00    	jne    105720 <MPTOp_test1+0x1e0>
        dprintf("test 1.6 failed: (%d != 0)\n", get_pdir_entry_by_va(10, vaddr));
        return 1;
    }
    dprintf("test 1 passed.\n");
  105628:	83 ec 0c             	sub    $0xc,%esp
  10562b:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  105631:	50                   	push   %eax
  105632:	e8 6b d5 ff ff       	call   102ba2 <dprintf>
    return 0;
  105637:	83 c4 10             	add    $0x10,%esp
  10563a:	31 c0                	xor    %eax,%eax
  10563c:	eb 28                	jmp    105666 <MPTOp_test1+0x126>
  10563e:	66 90                	xchg   %ax,%ax
        dprintf("test 1.2 failed: (%d != 0)\n", get_pdir_entry_by_va(10, vaddr));
  105640:	83 ec 08             	sub    $0x8,%esp
  105643:	68 00 00 00 4b       	push   $0x4b000000
  105648:	6a 0a                	push   $0xa
  10564a:	e8 51 fd ff ff       	call   1053a0 <get_pdir_entry_by_va>
  10564f:	5a                   	pop    %edx
  105650:	59                   	pop    %ecx
  105651:	50                   	push   %eax
  105652:	8d 83 41 95 ff ff    	lea    -0x6abf(%ebx),%eax
  105658:	50                   	push   %eax
  105659:	e8 44 d5 ff ff       	call   102ba2 <dprintf>
        return 1;
  10565e:	83 c4 10             	add    $0x10,%esp
        return 1;
  105661:	b8 01 00 00 00       	mov    $0x1,%eax
}
  105666:	83 c4 08             	add    $0x8,%esp
  105669:	5b                   	pop    %ebx
  10566a:	c3                   	ret
  10566b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.1 failed: (%d != 0)\n", get_ptbl_entry_by_va(10, vaddr));
  105670:	83 ec 08             	sub    $0x8,%esp
  105673:	68 00 00 00 4b       	push   $0x4b000000
  105678:	6a 0a                	push   $0xa
  10567a:	e8 b1 fc ff ff       	call   105330 <get_ptbl_entry_by_va>
  10567f:	5a                   	pop    %edx
  105680:	59                   	pop    %ecx
  105681:	50                   	push   %eax
  105682:	8d 83 25 95 ff ff    	lea    -0x6adb(%ebx),%eax
  105688:	50                   	push   %eax
  105689:	e8 14 d5 ff ff       	call   102ba2 <dprintf>
        return 1;
  10568e:	83 c4 10             	add    $0x10,%esp
  105691:	eb ce                	jmp    105661 <MPTOp_test1+0x121>
  105693:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.4 failed: (%d == 0)\n", get_pdir_entry_by_va(10, vaddr));
  105698:	83 ec 08             	sub    $0x8,%esp
  10569b:	68 00 00 00 4b       	push   $0x4b000000
  1056a0:	6a 0a                	push   $0xa
  1056a2:	e8 f9 fc ff ff       	call   1053a0 <get_pdir_entry_by_va>
  1056a7:	5a                   	pop    %edx
  1056a8:	59                   	pop    %ecx
  1056a9:	50                   	push   %eax
  1056aa:	8d 83 79 95 ff ff    	lea    -0x6a87(%ebx),%eax
  1056b0:	50                   	push   %eax
  1056b1:	e8 ec d4 ff ff       	call   102ba2 <dprintf>
        return 1;
  1056b6:	83 c4 10             	add    $0x10,%esp
  1056b9:	eb a6                	jmp    105661 <MPTOp_test1+0x121>
  1056bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.3 failed: (%d == 0)\n", get_ptbl_entry_by_va(10, vaddr));
  1056c0:	83 ec 08             	sub    $0x8,%esp
  1056c3:	68 00 00 00 4b       	push   $0x4b000000
  1056c8:	6a 0a                	push   $0xa
  1056ca:	e8 61 fc ff ff       	call   105330 <get_ptbl_entry_by_va>
  1056cf:	5a                   	pop    %edx
  1056d0:	59                   	pop    %ecx
  1056d1:	50                   	push   %eax
  1056d2:	8d 83 5d 95 ff ff    	lea    -0x6aa3(%ebx),%eax
  1056d8:	50                   	push   %eax
  1056d9:	e8 c4 d4 ff ff       	call   102ba2 <dprintf>
        return 1;
  1056de:	83 c4 10             	add    $0x10,%esp
  1056e1:	e9 7b ff ff ff       	jmp    105661 <MPTOp_test1+0x121>
  1056e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1056ed:	00 
  1056ee:	66 90                	xchg   %ax,%ax
        dprintf("test 1.5 failed: (%d != 0)\n", get_ptbl_entry_by_va(10, vaddr));
  1056f0:	83 ec 08             	sub    $0x8,%esp
  1056f3:	68 00 00 00 4b       	push   $0x4b000000
  1056f8:	6a 0a                	push   $0xa
  1056fa:	e8 31 fc ff ff       	call   105330 <get_ptbl_entry_by_va>
  1056ff:	5a                   	pop    %edx
  105700:	59                   	pop    %ecx
  105701:	50                   	push   %eax
  105702:	8d 83 95 95 ff ff    	lea    -0x6a6b(%ebx),%eax
  105708:	50                   	push   %eax
  105709:	e8 94 d4 ff ff       	call   102ba2 <dprintf>
        return 1;
  10570e:	83 c4 10             	add    $0x10,%esp
  105711:	e9 4b ff ff ff       	jmp    105661 <MPTOp_test1+0x121>
  105716:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10571d:	00 
  10571e:	66 90                	xchg   %ax,%ax
        dprintf("test 1.6 failed: (%d != 0)\n", get_pdir_entry_by_va(10, vaddr));
  105720:	83 ec 08             	sub    $0x8,%esp
  105723:	68 00 00 00 4b       	push   $0x4b000000
  105728:	6a 0a                	push   $0xa
  10572a:	e8 71 fc ff ff       	call   1053a0 <get_pdir_entry_by_va>
  10572f:	5a                   	pop    %edx
  105730:	59                   	pop    %ecx
  105731:	50                   	push   %eax
  105732:	8d 83 b1 95 ff ff    	lea    -0x6a4f(%ebx),%eax
  105738:	50                   	push   %eax
  105739:	e8 64 d4 ff ff       	call   102ba2 <dprintf>
        return 1;
  10573e:	83 c4 10             	add    $0x10,%esp
  105741:	e9 1b ff ff ff       	jmp    105661 <MPTOp_test1+0x121>
  105746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10574d:	00 
  10574e:	66 90                	xchg   %ax,%ax

00105750 <MPTOp_test_own>:
int MPTOp_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  105750:	31 c0                	xor    %eax,%eax
  105752:	c3                   	ret
  105753:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10575a:	00 
  10575b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105760 <test_MPTOp>:

int test_MPTOp()
{
    return MPTOp_test1() + MPTOp_test_own();
  105760:	e9 db fd ff ff       	jmp    105540 <MPTOp_test1>
  105765:	66 90                	xchg   %ax,%ax
  105767:	66 90                	xchg   %ax,%ax
  105769:	66 90                	xchg   %ax,%ax
  10576b:	66 90                	xchg   %ax,%ax
  10576d:	66 90                	xchg   %ax,%ax
  10576f:	66 90                	xchg   %ax,%ax
  105771:	66 90                	xchg   %ax,%ax
  105773:	66 90                	xchg   %ax,%ax
  105775:	66 90                	xchg   %ax,%ax
  105777:	66 90                	xchg   %ax,%ax
  105779:	66 90                	xchg   %ax,%ax
  10577b:	66 90                	xchg   %ax,%ax
  10577d:	66 90                	xchg   %ax,%ax
  10577f:	90                   	nop

00105780 <pdir_init>:
 * For each process from id 0 to NUM_IDS -1,
 * set the page directory entries sothat the kernel portion of the map as identity map,
 * and the rest of page directories are unmmaped.
 */
void pdir_init(unsigned int mbi_adr)
{
  105780:	57                   	push   %edi
    int i, j;
    
    idptbl_init(mbi_adr);

    //set other processes
    for(i = 0; i < NUM_IDS; i++){
  105781:	31 ff                	xor    %edi,%edi
{
  105783:	56                   	push   %esi
  105784:	53                   	push   %ebx
  105785:	e8 b3 ab ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10578a:	81 c3 6a 98 00 00    	add    $0x986a,%ebx
    idptbl_init(mbi_adr);
  105790:	83 ec 0c             	sub    $0xc,%esp
  105793:	ff 74 24 1c          	push   0x1c(%esp)
  105797:	e8 24 fd ff ff       	call   1054c0 <idptbl_init>
  10579c:	83 c4 10             	add    $0x10,%esp
      //kernel address, set to identity
      for(j = 0; j < (VM_USERLO_PI >> 10); j++){
  10579f:	31 f6                	xor    %esi,%esi
  1057a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1057a8:	00 
  1057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        set_pdir_entry_identity(i, j);
  1057b0:	83 ec 08             	sub    $0x8,%esp
  1057b3:	56                   	push   %esi
      for(j = 0; j < (VM_USERLO_PI >> 10); j++){
  1057b4:	83 c6 01             	add    $0x1,%esi
        set_pdir_entry_identity(i, j);
  1057b7:	57                   	push   %edi
  1057b8:	e8 83 f7 ff ff       	call   104f40 <set_pdir_entry_identity>
      for(j = 0; j < (VM_USERLO_PI >> 10); j++){
  1057bd:	83 c4 10             	add    $0x10,%esp
  1057c0:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  1057c6:	75 e8                	jne    1057b0 <pdir_init+0x30>
  1057c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1057cf:	00 
      }
      //normal address, set to unmap
      for(j = VM_USERLO_PI >> 10; j < VM_USERHI_PI >> 10; j++){
        rmv_pdir_entry(i, j);
  1057d0:	83 ec 08             	sub    $0x8,%esp
  1057d3:	56                   	push   %esi
      for(j = VM_USERLO_PI >> 10; j < VM_USERHI_PI >> 10; j++){
  1057d4:	83 c6 01             	add    $0x1,%esi
        rmv_pdir_entry(i, j);
  1057d7:	57                   	push   %edi
  1057d8:	e8 a3 f7 ff ff       	call   104f80 <rmv_pdir_entry>
      for(j = VM_USERLO_PI >> 10; j < VM_USERHI_PI >> 10; j++){
  1057dd:	83 c4 10             	add    $0x10,%esp
  1057e0:	81 fe c0 03 00 00    	cmp    $0x3c0,%esi
  1057e6:	75 e8                	jne    1057d0 <pdir_init+0x50>
  1057e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1057ef:	00 
      }
      //kernel address, set to identity
      for(j = VM_USERHI_PI >> 10; j < 1024; j++){
        set_pdir_entry_identity(i, j);
  1057f0:	83 ec 08             	sub    $0x8,%esp
  1057f3:	56                   	push   %esi
      for(j = VM_USERHI_PI >> 10; j < 1024; j++){
  1057f4:	83 c6 01             	add    $0x1,%esi
        set_pdir_entry_identity(i, j);
  1057f7:	57                   	push   %edi
  1057f8:	e8 43 f7 ff ff       	call   104f40 <set_pdir_entry_identity>
      for(j = VM_USERHI_PI >> 10; j < 1024; j++){
  1057fd:	83 c4 10             	add    $0x10,%esp
  105800:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  105806:	75 e8                	jne    1057f0 <pdir_init+0x70>
    for(i = 0; i < NUM_IDS; i++){
  105808:	83 c7 01             	add    $0x1,%edi
  10580b:	83 ff 40             	cmp    $0x40,%edi
  10580e:	75 8f                	jne    10579f <pdir_init+0x1f>
      }
    }
    
}
  105810:	5b                   	pop    %ebx
  105811:	5e                   	pop    %esi
  105812:	5f                   	pop    %edi
  105813:	c3                   	ret
  105814:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10581b:	00 
  10581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105820 <alloc_ptbl>:
 * and clears (set to 0) the whole page table entries for this newly mapped page table.
 * It returns the page index of the newly allocated physical page.
 * In the case when there's no physical page available, it returns 0.
 */
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vadr)
{
  105820:	57                   	push   %edi
  105821:	56                   	push   %esi
  105822:	53                   	push   %ebx
  105823:	8b 7c 24 10          	mov    0x10(%esp),%edi
  105827:	e8 11 ab ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10582c:	81 c3 c8 97 00 00    	add    $0x97c8,%ebx
  // TODO
  unsigned int addr;
  unsigned int page_index;
  page_index = container_alloc(proc_index);
  105832:	83 ec 0c             	sub    $0xc,%esp
  105835:	57                   	push   %edi
  105836:	e8 75 f3 ff ff       	call   104bb0 <container_alloc>
  if(page_index == 0) return 0;//no physical page vailable
  10583b:	83 c4 10             	add    $0x10,%esp
  page_index = container_alloc(proc_index);
  10583e:	89 c6                	mov    %eax,%esi
  if(page_index == 0) return 0;//no physical page vailable
  105840:	85 c0                	test   %eax,%eax
  105842:	75 0c                	jne    105850 <alloc_ptbl+0x30>
  // addr increases 4 per step, since entry is 4 bytes
  for(addr = page_index << 12; addr < (page_index + 1) << 12; addr += 4){
    *(unsigned int *)addr &= 0x00000000; 
  }
  return page_index;
}
  105844:	89 f0                	mov    %esi,%eax
  105846:	5b                   	pop    %ebx
  105847:	5e                   	pop    %esi
  105848:	5f                   	pop    %edi
  105849:	c3                   	ret
  10584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  set_pdir_entry_by_va(proc_index, vadr, page_index);
  105850:	83 ec 04             	sub    $0x4,%esp
  105853:	50                   	push   %eax
  105854:	ff 74 24 1c          	push   0x1c(%esp)
  105858:	57                   	push   %edi
  105859:	e8 32 fc ff ff       	call   105490 <set_pdir_entry_by_va>
  for(addr = page_index << 12; addr < (page_index + 1) << 12; addr += 4){
  10585e:	89 f0                	mov    %esi,%eax
  105860:	8d 56 01             	lea    0x1(%esi),%edx
  105863:	83 c4 10             	add    $0x10,%esp
  105866:	c1 e0 0c             	shl    $0xc,%eax
  105869:	c1 e2 0c             	shl    $0xc,%edx
  10586c:	39 d0                	cmp    %edx,%eax
  10586e:	73 d4                	jae    105844 <alloc_ptbl+0x24>
    *(unsigned int *)addr &= 0x00000000; 
  105870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(addr = page_index << 12; addr < (page_index + 1) << 12; addr += 4){
  105876:	83 c0 04             	add    $0x4,%eax
  105879:	39 d0                	cmp    %edx,%eax
  10587b:	73 c7                	jae    105844 <alloc_ptbl+0x24>
  10587d:	b9 01 00 00 00       	mov    $0x1,%ecx
  105882:	85 c9                	test   %ecx,%ecx
  105884:	74 1a                	je     1058a0 <alloc_ptbl+0x80>
    *(unsigned int *)addr &= 0x00000000; 
  105886:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(addr = page_index << 12; addr < (page_index + 1) << 12; addr += 4){
  10588c:	83 c0 04             	add    $0x4,%eax
  10588f:	39 d0                	cmp    %edx,%eax
  105891:	73 b1                	jae    105844 <alloc_ptbl+0x24>
  105893:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10589a:	00 
  10589b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    *(unsigned int *)addr &= 0x00000000; 
  1058a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(addr = page_index << 12; addr < (page_index + 1) << 12; addr += 4){
  1058a6:	83 c0 08             	add    $0x8,%eax
    *(unsigned int *)addr &= 0x00000000; 
  1058a9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(addr = page_index << 12; addr < (page_index + 1) << 12; addr += 4){
  1058b0:	39 d0                	cmp    %edx,%eax
  1058b2:	72 ec                	jb     1058a0 <alloc_ptbl+0x80>
  1058b4:	eb 8e                	jmp    105844 <alloc_ptbl+0x24>
  1058b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1058bd:	00 
  1058be:	66 90                	xchg   %ax,%ax

001058c0 <free_ptbl>:

// Reverse operation of alloc_ptbl.
// Removes corresponding page directory entry,
// and frees the page for the page table entries (with container_free).
void free_ptbl(unsigned int proc_index, unsigned int vadr)
{
  1058c0:	55                   	push   %ebp
  1058c1:	57                   	push   %edi
  1058c2:	56                   	push   %esi
  1058c3:	53                   	push   %ebx
  1058c4:	e8 74 aa ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1058c9:	81 c3 2b 97 00 00    	add    $0x972b,%ebx
  1058cf:	83 ec 14             	sub    $0x14,%esp
  1058d2:	8b 7c 24 28          	mov    0x28(%esp),%edi
  1058d6:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  // TODO
  unsigned int pdir_entry;
  unsigned int page_index;
  pdir_entry = get_pdir_entry_by_va(proc_index, vadr);
  1058da:	55                   	push   %ebp
  1058db:	57                   	push   %edi
  1058dc:	e8 bf fa ff ff       	call   1053a0 <get_pdir_entry_by_va>
  1058e1:	89 c6                	mov    %eax,%esi
  page_index = pdir_entry >> 12;
  // remove page directory entry
  rmv_pdir_entry_by_va(proc_index, vadr);
  1058e3:	58                   	pop    %eax
  1058e4:	5a                   	pop    %edx
  1058e5:	55                   	push   %ebp
  1058e6:	57                   	push   %edi
  page_index = pdir_entry >> 12;
  1058e7:	c1 ee 0c             	shr    $0xc,%esi
  rmv_pdir_entry_by_va(proc_index, vadr);
  1058ea:	e8 31 fb ff ff       	call   105420 <rmv_pdir_entry_by_va>

  //free the page for the page table entities
  container_free(proc_index, page_index);
  1058ef:	59                   	pop    %ecx
  1058f0:	5d                   	pop    %ebp
  1058f1:	56                   	push   %esi
  1058f2:	57                   	push   %edi
  1058f3:	e8 e8 f2 ff ff       	call   104be0 <container_free>
  1058f8:	83 c4 1c             	add    $0x1c,%esp
  1058fb:	5b                   	pop    %ebx
  1058fc:	5e                   	pop    %esi
  1058fd:	5f                   	pop    %edi
  1058fe:	5d                   	pop    %ebp
  1058ff:	c3                   	ret

00105900 <MPTComm_test1>:
#include <pmm/MContainer/export.h>
#include <vmm/MPTOp/export.h>
#include "export.h"

int MPTComm_test1()
{
  105900:	55                   	push   %ebp
  105901:	57                   	push   %edi
    int i;
    for (i = 0; i < 1024; i++) {
  105902:	bf 03 01 00 00       	mov    $0x103,%edi
{
  105907:	56                   	push   %esi
    for (i = 0; i < 1024; i++) {
  105908:	31 f6                	xor    %esi,%esi
{
  10590a:	53                   	push   %ebx
  10590b:	e8 2d aa ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105910:	81 c3 e4 96 00 00    	add    $0x96e4,%ebx
  105916:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; i < 1024; i++) {
  105919:	eb 0e                	jmp    105929 <MPTComm_test1+0x29>
  10591b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  105920:	83 c6 01             	add    $0x1,%esi
  105923:	81 c7 00 00 40 00    	add    $0x400000,%edi
        if (i < 256 || i >= 960) {
  105929:	8d 86 00 ff ff ff    	lea    -0x100(%esi),%eax
  10592f:	3d bf 02 00 00       	cmp    $0x2bf,%eax
  105934:	76 ea                	jbe    105920 <MPTComm_test1+0x20>
            if (get_ptbl_entry_by_va(10, i * 4096 * 1024) !=
  105936:	89 f5                	mov    %esi,%ebp
  105938:	52                   	push   %edx
  105939:	c1 e5 16             	shl    $0x16,%ebp
  10593c:	52                   	push   %edx
  10593d:	55                   	push   %ebp
  10593e:	6a 0a                	push   $0xa
  105940:	e8 eb f9 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105945:	83 c4 10             	add    $0x10,%esp
  105948:	39 f8                	cmp    %edi,%eax
  10594a:	74 d4                	je     105920 <MPTComm_test1+0x20>
                i * 4096 * 1024 + 259) {
                dprintf("test 1.1 failed (i = %d): (%d != %d)\n",
  10594c:	50                   	push   %eax
  10594d:	50                   	push   %eax
  10594e:	55                   	push   %ebp
  10594f:	6a 0a                	push   $0xa
  105951:	e8 da f9 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105956:	57                   	push   %edi
  105957:	50                   	push   %eax
  105958:	8d 83 e4 9b ff ff    	lea    -0x641c(%ebx),%eax
  10595e:	56                   	push   %esi
  10595f:	50                   	push   %eax
  105960:	e8 3d d2 ff ff       	call   102ba2 <dprintf>
            }
        }
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  105965:	83 c4 2c             	add    $0x2c,%esp
  105968:	b8 01 00 00 00       	mov    $0x1,%eax
  10596d:	5b                   	pop    %ebx
  10596e:	5e                   	pop    %esi
  10596f:	5f                   	pop    %edi
  105970:	5d                   	pop    %ebp
  105971:	c3                   	ret
  105972:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105979:	00 
  10597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105980 <MPTComm_test2>:

int MPTComm_test2()
{
  105980:	53                   	push   %ebx
  105981:	e8 b7 a9 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105986:	81 c3 6e 96 00 00    	add    $0x966e,%ebx
  10598c:	83 ec 10             	sub    $0x10,%esp
    unsigned int vaddr = 300 * 4096 * 1024;
    container_split(0, 100);
  10598f:	6a 64                	push   $0x64
  105991:	6a 00                	push   $0x0
  105993:	e8 b8 f1 ff ff       	call   104b50 <container_split>
    alloc_ptbl(1, vaddr);
  105998:	59                   	pop    %ecx
  105999:	58                   	pop    %eax
  10599a:	68 00 00 00 4b       	push   $0x4b000000
  10599f:	6a 01                	push   $0x1
  1059a1:	e8 7a fe ff ff       	call   105820 <alloc_ptbl>
    if (get_pdir_entry_by_va(1, vaddr) == 0) {
  1059a6:	58                   	pop    %eax
  1059a7:	5a                   	pop    %edx
  1059a8:	68 00 00 00 4b       	push   $0x4b000000
  1059ad:	6a 01                	push   $0x1
  1059af:	e8 ec f9 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  1059b4:	83 c4 10             	add    $0x10,%esp
  1059b7:	85 c0                	test   %eax,%eax
  1059b9:	0f 84 89 00 00 00    	je     105a48 <MPTComm_test2+0xc8>
        dprintf("test 2.1 failed: (%d == 0)\n", get_pdir_entry_by_va(1, vaddr));
        return 1;
    }
    if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  1059bf:	83 ec 08             	sub    $0x8,%esp
  1059c2:	68 00 00 00 4b       	push   $0x4b000000
  1059c7:	6a 01                	push   $0x1
  1059c9:	e8 62 f9 ff ff       	call   105330 <get_ptbl_entry_by_va>
  1059ce:	83 c4 10             	add    $0x10,%esp
  1059d1:	85 c0                	test   %eax,%eax
  1059d3:	75 43                	jne    105a18 <MPTComm_test2+0x98>
        dprintf("test 2.2 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
        return 1;
    }
    free_ptbl(1, vaddr);
  1059d5:	83 ec 08             	sub    $0x8,%esp
  1059d8:	68 00 00 00 4b       	push   $0x4b000000
  1059dd:	6a 01                	push   $0x1
  1059df:	e8 dc fe ff ff       	call   1058c0 <free_ptbl>
    if (get_pdir_entry_by_va(1, vaddr) != 0) {
  1059e4:	58                   	pop    %eax
  1059e5:	5a                   	pop    %edx
  1059e6:	68 00 00 00 4b       	push   $0x4b000000
  1059eb:	6a 01                	push   $0x1
  1059ed:	e8 ae f9 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  1059f2:	83 c4 10             	add    $0x10,%esp
  1059f5:	85 c0                	test   %eax,%eax
  1059f7:	75 77                	jne    105a70 <MPTComm_test2+0xf0>
        dprintf("test 2.3 failed: (%d != 0)\n", get_pdir_entry_by_va(1, vaddr));
        return 1;
    }
    dprintf("test 2 passed.\n");
  1059f9:	83 ec 0c             	sub    $0xc,%esp
  1059fc:	8d 83 bd 93 ff ff    	lea    -0x6c43(%ebx),%eax
  105a02:	50                   	push   %eax
  105a03:	e8 9a d1 ff ff       	call   102ba2 <dprintf>
    return 0;
  105a08:	83 c4 10             	add    $0x10,%esp
  105a0b:	31 c0                	xor    %eax,%eax
}
  105a0d:	83 c4 08             	add    $0x8,%esp
  105a10:	5b                   	pop    %ebx
  105a11:	c3                   	ret
  105a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dprintf("test 2.2 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
  105a18:	83 ec 08             	sub    $0x8,%esp
  105a1b:	68 00 00 00 4b       	push   $0x4b000000
  105a20:	6a 01                	push   $0x1
  105a22:	e8 09 f9 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105a27:	59                   	pop    %ecx
  105a28:	5a                   	pop    %edx
  105a29:	50                   	push   %eax
  105a2a:	8d 83 09 95 ff ff    	lea    -0x6af7(%ebx),%eax
  105a30:	50                   	push   %eax
  105a31:	e8 6c d1 ff ff       	call   102ba2 <dprintf>
        return 1;
  105a36:	83 c4 10             	add    $0x10,%esp
}
  105a39:	83 c4 08             	add    $0x8,%esp
        return 1;
  105a3c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  105a41:	5b                   	pop    %ebx
  105a42:	c3                   	ret
  105a43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 2.1 failed: (%d == 0)\n", get_pdir_entry_by_va(1, vaddr));
  105a48:	83 ec 08             	sub    $0x8,%esp
  105a4b:	68 00 00 00 4b       	push   $0x4b000000
  105a50:	6a 01                	push   $0x1
  105a52:	e8 49 f9 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105a57:	59                   	pop    %ecx
  105a58:	5a                   	pop    %edx
  105a59:	50                   	push   %eax
  105a5a:	8d 83 cd 95 ff ff    	lea    -0x6a33(%ebx),%eax
  105a60:	50                   	push   %eax
  105a61:	e8 3c d1 ff ff       	call   102ba2 <dprintf>
        return 1;
  105a66:	83 c4 10             	add    $0x10,%esp
  105a69:	eb ce                	jmp    105a39 <MPTComm_test2+0xb9>
  105a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 2.3 failed: (%d != 0)\n", get_pdir_entry_by_va(1, vaddr));
  105a70:	83 ec 08             	sub    $0x8,%esp
  105a73:	68 00 00 00 4b       	push   $0x4b000000
  105a78:	6a 01                	push   $0x1
  105a7a:	e8 21 f9 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105a7f:	5a                   	pop    %edx
  105a80:	59                   	pop    %ecx
  105a81:	50                   	push   %eax
  105a82:	8d 83 e9 95 ff ff    	lea    -0x6a17(%ebx),%eax
  105a88:	50                   	push   %eax
  105a89:	e8 14 d1 ff ff       	call   102ba2 <dprintf>
        return 1;
  105a8e:	83 c4 10             	add    $0x10,%esp
  105a91:	eb a6                	jmp    105a39 <MPTComm_test2+0xb9>
  105a93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105a9a:	00 
  105a9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105aa0 <MPTComm_test_own>:
int MPTComm_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  105aa0:	31 c0                	xor    %eax,%eax
  105aa2:	c3                   	ret
  105aa3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105aaa:	00 
  105aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105ab0 <test_MPTComm>:

int test_MPTComm()
{
  105ab0:	83 ec 0c             	sub    $0xc,%esp
    return MPTComm_test1() + MPTComm_test2() + MPTComm_test_own();
  105ab3:	e8 48 fe ff ff       	call   105900 <MPTComm_test1>
  105ab8:	e8 c3 fe ff ff       	call   105980 <MPTComm_test2>
}
  105abd:	83 c4 0c             	add    $0xc,%esp
    return MPTComm_test1() + MPTComm_test2() + MPTComm_test_own();
  105ac0:	83 c0 01             	add    $0x1,%eax
}
  105ac3:	c3                   	ret
  105ac4:	66 90                	xchg   %ax,%ax
  105ac6:	66 90                	xchg   %ax,%ax
  105ac8:	66 90                	xchg   %ax,%ax
  105aca:	66 90                	xchg   %ax,%ax
  105acc:	66 90                	xchg   %ax,%ax
  105ace:	66 90                	xchg   %ax,%ax

00105ad0 <pdir_init_kern>:
/**
 * Sets the entire page map for process 0 as the identity map.
 * Note that part of the task is already completed by pdir_init.
 */
void pdir_init_kern(unsigned int mbi_addr)
{
  105ad0:	53                   	push   %ebx
  105ad1:	e8 67 a8 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105ad6:	81 c3 1e 95 00 00    	add    $0x951e,%ebx
  105adc:	83 ec 14             	sub    $0x14,%esp
    // TODO: Define your local variables here.

    pdir_init(mbi_addr);
  105adf:	ff 74 24 1c          	push   0x1c(%esp)
  105ae3:	e8 98 fc ff ff       	call   105780 <pdir_init>

    //TODO
}
  105ae8:	83 c4 18             	add    $0x18,%esp
  105aeb:	5b                   	pop    %ebx
  105aec:	c3                   	ret
  105aed:	8d 76 00             	lea    0x0(%esi),%esi

00105af0 <map_page>:
unsigned int map_page(unsigned int proc_index, unsigned int vaddr,
                      unsigned int page_index, unsigned int perm)
{
    // TODO
    return 0;
}
  105af0:	31 c0                	xor    %eax,%eax
  105af2:	c3                   	ret
  105af3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105afa:	00 
  105afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105b00 <unmap_page>:
 */
unsigned int unmap_page(unsigned int proc_index, unsigned int vaddr)
{
    // TODO
    return 0;
  105b00:	31 c0                	xor    %eax,%eax
  105b02:	c3                   	ret
  105b03:	66 90                	xchg   %ax,%ax
  105b05:	66 90                	xchg   %ax,%ax
  105b07:	66 90                	xchg   %ax,%ax
  105b09:	66 90                	xchg   %ax,%ax
  105b0b:	66 90                	xchg   %ax,%ax
  105b0d:	66 90                	xchg   %ax,%ax
  105b0f:	90                   	nop

00105b10 <MPTKern_test1>:
#include <pmm/MContainer/export.h>
#include <vmm/MPTOp/export.h>
#include "export.h"

int MPTKern_test1()
{
  105b10:	53                   	push   %ebx
  105b11:	e8 27 a8 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105b16:	81 c3 de 94 00 00    	add    $0x94de,%ebx
  105b1c:	83 ec 10             	sub    $0x10,%esp
    unsigned int vaddr = 4096 * 1024 * 300;
    container_split(0, 100);
  105b1f:	6a 64                	push   $0x64
  105b21:	6a 00                	push   $0x0
  105b23:	e8 28 f0 ff ff       	call   104b50 <container_split>
    if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  105b28:	58                   	pop    %eax
  105b29:	5a                   	pop    %edx
  105b2a:	68 00 00 00 4b       	push   $0x4b000000
  105b2f:	6a 01                	push   $0x1
  105b31:	e8 fa f7 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105b36:	83 c4 10             	add    $0x10,%esp
  105b39:	85 c0                	test   %eax,%eax
  105b3b:	0f 85 cf 00 00 00    	jne    105c10 <MPTKern_test1+0x100>
        dprintf("test 1.1 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(1, vaddr) != 0) {
  105b41:	83 ec 08             	sub    $0x8,%esp
  105b44:	68 00 00 00 4b       	push   $0x4b000000
  105b49:	6a 01                	push   $0x1
  105b4b:	e8 50 f8 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105b50:	83 c4 10             	add    $0x10,%esp
  105b53:	85 c0                	test   %eax,%eax
  105b55:	0f 85 85 00 00 00    	jne    105be0 <MPTKern_test1+0xd0>
        dprintf("test 1.2 failed: (%d != 0)\n", get_pdir_entry_by_va(1, vaddr));
        return 1;
    }
    map_page(1, vaddr, 100, 7);
  105b5b:	6a 07                	push   $0x7
  105b5d:	6a 64                	push   $0x64
  105b5f:	68 00 00 00 4b       	push   $0x4b000000
  105b64:	6a 01                	push   $0x1
  105b66:	e8 85 ff ff ff       	call   105af0 <map_page>
    if (get_ptbl_entry_by_va(1, vaddr) == 0) {
  105b6b:	59                   	pop    %ecx
  105b6c:	58                   	pop    %eax
  105b6d:	68 00 00 00 4b       	push   $0x4b000000
  105b72:	6a 01                	push   $0x1
  105b74:	e8 b7 f7 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105b79:	83 c4 10             	add    $0x10,%esp
  105b7c:	85 c0                	test   %eax,%eax
  105b7e:	0f 84 dc 00 00 00    	je     105c60 <MPTKern_test1+0x150>
        dprintf("test 1.3 failed: (%d == 0)\n", get_ptbl_entry_by_va(1, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(1, vaddr) == 0) {
  105b84:	83 ec 08             	sub    $0x8,%esp
  105b87:	68 00 00 00 4b       	push   $0x4b000000
  105b8c:	6a 01                	push   $0x1
  105b8e:	e8 0d f8 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105b93:	83 c4 10             	add    $0x10,%esp
  105b96:	85 c0                	test   %eax,%eax
  105b98:	0f 84 9a 00 00 00    	je     105c38 <MPTKern_test1+0x128>
        dprintf("test 1.4 failed: (%d == 0)\n", get_pdir_entry_by_va(1, vaddr));
        return 1;
    }
    unmap_page(1, vaddr);
  105b9e:	83 ec 08             	sub    $0x8,%esp
  105ba1:	68 00 00 00 4b       	push   $0x4b000000
  105ba6:	6a 01                	push   $0x1
  105ba8:	e8 53 ff ff ff       	call   105b00 <unmap_page>
    if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  105bad:	58                   	pop    %eax
  105bae:	5a                   	pop    %edx
  105baf:	68 00 00 00 4b       	push   $0x4b000000
  105bb4:	6a 01                	push   $0x1
  105bb6:	e8 75 f7 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105bbb:	83 c4 10             	add    $0x10,%esp
  105bbe:	85 c0                	test   %eax,%eax
  105bc0:	0f 85 ca 00 00 00    	jne    105c90 <MPTKern_test1+0x180>
        dprintf("test 1.5 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
        return 1;
    }
    dprintf("test 1 passed.\n");
  105bc6:	83 ec 0c             	sub    $0xc,%esp
  105bc9:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  105bcf:	50                   	push   %eax
  105bd0:	e8 cd cf ff ff       	call   102ba2 <dprintf>
    return 0;
  105bd5:	83 c4 10             	add    $0x10,%esp
  105bd8:	31 c0                	xor    %eax,%eax
}
  105bda:	83 c4 08             	add    $0x8,%esp
  105bdd:	5b                   	pop    %ebx
  105bde:	c3                   	ret
  105bdf:	90                   	nop
        dprintf("test 1.2 failed: (%d != 0)\n", get_pdir_entry_by_va(1, vaddr));
  105be0:	83 ec 08             	sub    $0x8,%esp
  105be3:	68 00 00 00 4b       	push   $0x4b000000
  105be8:	6a 01                	push   $0x1
  105bea:	e8 b1 f7 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105bef:	5a                   	pop    %edx
  105bf0:	59                   	pop    %ecx
  105bf1:	50                   	push   %eax
  105bf2:	8d 83 41 95 ff ff    	lea    -0x6abf(%ebx),%eax
  105bf8:	50                   	push   %eax
  105bf9:	e8 a4 cf ff ff       	call   102ba2 <dprintf>
        return 1;
  105bfe:	83 c4 10             	add    $0x10,%esp
}
  105c01:	83 c4 08             	add    $0x8,%esp
        return 1;
  105c04:	b8 01 00 00 00       	mov    $0x1,%eax
}
  105c09:	5b                   	pop    %ebx
  105c0a:	c3                   	ret
  105c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.1 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
  105c10:	83 ec 08             	sub    $0x8,%esp
  105c13:	68 00 00 00 4b       	push   $0x4b000000
  105c18:	6a 01                	push   $0x1
  105c1a:	e8 11 f7 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105c1f:	5a                   	pop    %edx
  105c20:	59                   	pop    %ecx
  105c21:	50                   	push   %eax
  105c22:	8d 83 25 95 ff ff    	lea    -0x6adb(%ebx),%eax
  105c28:	50                   	push   %eax
  105c29:	e8 74 cf ff ff       	call   102ba2 <dprintf>
        return 1;
  105c2e:	83 c4 10             	add    $0x10,%esp
  105c31:	eb ce                	jmp    105c01 <MPTKern_test1+0xf1>
  105c33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.4 failed: (%d == 0)\n", get_pdir_entry_by_va(1, vaddr));
  105c38:	83 ec 08             	sub    $0x8,%esp
  105c3b:	68 00 00 00 4b       	push   $0x4b000000
  105c40:	6a 01                	push   $0x1
  105c42:	e8 59 f7 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105c47:	59                   	pop    %ecx
  105c48:	5a                   	pop    %edx
  105c49:	50                   	push   %eax
  105c4a:	8d 83 79 95 ff ff    	lea    -0x6a87(%ebx),%eax
  105c50:	50                   	push   %eax
  105c51:	e8 4c cf ff ff       	call   102ba2 <dprintf>
        return 1;
  105c56:	83 c4 10             	add    $0x10,%esp
  105c59:	eb a6                	jmp    105c01 <MPTKern_test1+0xf1>
  105c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.3 failed: (%d == 0)\n", get_ptbl_entry_by_va(1, vaddr));
  105c60:	83 ec 08             	sub    $0x8,%esp
  105c63:	68 00 00 00 4b       	push   $0x4b000000
  105c68:	6a 01                	push   $0x1
  105c6a:	e8 c1 f6 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105c6f:	59                   	pop    %ecx
  105c70:	5a                   	pop    %edx
  105c71:	50                   	push   %eax
  105c72:	8d 83 5d 95 ff ff    	lea    -0x6aa3(%ebx),%eax
  105c78:	50                   	push   %eax
  105c79:	e8 24 cf ff ff       	call   102ba2 <dprintf>
        return 1;
  105c7e:	83 c4 10             	add    $0x10,%esp
  105c81:	e9 7b ff ff ff       	jmp    105c01 <MPTKern_test1+0xf1>
  105c86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105c8d:	00 
  105c8e:	66 90                	xchg   %ax,%ax
        dprintf("test 1.5 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
  105c90:	83 ec 08             	sub    $0x8,%esp
  105c93:	68 00 00 00 4b       	push   $0x4b000000
  105c98:	6a 01                	push   $0x1
  105c9a:	e8 91 f6 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105c9f:	5a                   	pop    %edx
  105ca0:	59                   	pop    %ecx
  105ca1:	50                   	push   %eax
  105ca2:	8d 83 95 95 ff ff    	lea    -0x6a6b(%ebx),%eax
  105ca8:	50                   	push   %eax
  105ca9:	e8 f4 ce ff ff       	call   102ba2 <dprintf>
        return 1;
  105cae:	83 c4 10             	add    $0x10,%esp
  105cb1:	e9 4b ff ff ff       	jmp    105c01 <MPTKern_test1+0xf1>
  105cb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105cbd:	00 
  105cbe:	66 90                	xchg   %ax,%ax

00105cc0 <MPTKern_test2>:

int MPTKern_test2()
{
  105cc0:	57                   	push   %edi
  105cc1:	56                   	push   %esi
  105cc2:	be 03 00 00 40       	mov    $0x40000003,%esi
  105cc7:	53                   	push   %ebx
  105cc8:	e8 70 a6 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105ccd:	81 c3 27 93 00 00    	add    $0x9327,%ebx
  105cd3:	eb 11                	jmp    105ce6 <MPTKern_test2+0x26>
  105cd5:	8d 76 00             	lea    0x0(%esi),%esi
    unsigned int i;
    for (i = 256; i < 960; i++) {
  105cd8:	81 c6 00 00 40 00    	add    $0x400000,%esi
  105cde:	81 fe 03 00 00 f0    	cmp    $0xf0000003,%esi
  105ce4:	74 42                	je     105d28 <MPTKern_test2+0x68>
        if (get_ptbl_entry_by_va(0, i * 4096 * 1024L) !=
  105ce6:	83 ec 08             	sub    $0x8,%esp
  105ce9:	8d 7e fd             	lea    -0x3(%esi),%edi
  105cec:	57                   	push   %edi
  105ced:	6a 00                	push   $0x0
  105cef:	e8 3c f6 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105cf4:	83 c4 10             	add    $0x10,%esp
  105cf7:	39 f0                	cmp    %esi,%eax
  105cf9:	74 dd                	je     105cd8 <MPTKern_test2+0x18>
            i * 4096 * 1024L + 3) {
            dprintf("test 2.1 failed (i = %d): (%d != %d)\n",
  105cfb:	83 ec 08             	sub    $0x8,%esp
  105cfe:	57                   	push   %edi
  105cff:	6a 00                	push   $0x0
  105d01:	e8 2a f6 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105d06:	83 c4 0c             	add    $0xc,%esp
  105d09:	56                   	push   %esi
  105d0a:	50                   	push   %eax
  105d0b:	8d 83 64 9e ff ff    	lea    -0x619c(%ebx),%eax
  105d11:	50                   	push   %eax
  105d12:	e8 8b ce ff ff       	call   102ba2 <dprintf>
                    get_ptbl_entry_by_va(0, i * 4096 * 1024L),
                    i * 4096 * 1024L + 3);
            return 1;
  105d17:	83 c4 10             	add    $0x10,%esp
  105d1a:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    dprintf("test 2 passed.\n");
    return 0;
}
  105d1f:	5b                   	pop    %ebx
  105d20:	5e                   	pop    %esi
  105d21:	5f                   	pop    %edi
  105d22:	c3                   	ret
  105d23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    dprintf("test 2 passed.\n");
  105d28:	83 ec 0c             	sub    $0xc,%esp
  105d2b:	8d 83 bd 93 ff ff    	lea    -0x6c43(%ebx),%eax
  105d31:	50                   	push   %eax
  105d32:	e8 6b ce ff ff       	call   102ba2 <dprintf>
    return 0;
  105d37:	83 c4 10             	add    $0x10,%esp
  105d3a:	31 c0                	xor    %eax,%eax
}
  105d3c:	5b                   	pop    %ebx
  105d3d:	5e                   	pop    %esi
  105d3e:	5f                   	pop    %edi
  105d3f:	c3                   	ret

00105d40 <MPTKern_test_own>:
int MPTKern_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  105d40:	31 c0                	xor    %eax,%eax
  105d42:	c3                   	ret
  105d43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105d4a:	00 
  105d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105d50 <test_MPTKern>:

int test_MPTKern()
{
  105d50:	53                   	push   %ebx
  105d51:	83 ec 08             	sub    $0x8,%esp
    return MPTKern_test1() + MPTKern_test2() + MPTKern_test_own();
  105d54:	e8 b7 fd ff ff       	call   105b10 <MPTKern_test1>
  105d59:	89 c3                	mov    %eax,%ebx
  105d5b:	e8 60 ff ff ff       	call   105cc0 <MPTKern_test2>
}
  105d60:	83 c4 08             	add    $0x8,%esp
    return MPTKern_test1() + MPTKern_test2() + MPTKern_test_own();
  105d63:	01 d8                	add    %ebx,%eax
}
  105d65:	5b                   	pop    %ebx
  105d66:	c3                   	ret
  105d67:	66 90                	xchg   %ax,%ax
  105d69:	66 90                	xchg   %ax,%ax
  105d6b:	66 90                	xchg   %ax,%ax
  105d6d:	66 90                	xchg   %ax,%ax
  105d6f:	90                   	nop

00105d70 <paging_init>:
 * Initializes the page structures,
 * move to the page structure # 0 (kernel).
 * and turn on the paging.
 */
void paging_init(unsigned int mbi_addr)
{
  105d70:	53                   	push   %ebx
  105d71:	e8 c7 a5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105d76:	81 c3 7e 92 00 00    	add    $0x927e,%ebx
  105d7c:	83 ec 14             	sub    $0x14,%esp
	pdir_init_kern(mbi_addr);
  105d7f:	ff 74 24 1c          	push   0x1c(%esp)
  105d83:	e8 48 fd ff ff       	call   105ad0 <pdir_init_kern>
	set_pdir_base(0);
  105d88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105d8f:	e8 2c f1 ff ff       	call   104ec0 <set_pdir_base>
	enable_paging();
  105d94:	e8 58 b0 ff ff       	call   100df1 <enable_paging>
  105d99:	83 c4 18             	add    $0x18,%esp
  105d9c:	5b                   	pop    %ebx
  105d9d:	c3                   	ret
  105d9e:	66 90                	xchg   %ax,%ax

00105da0 <alloc_page>:
unsigned int alloc_page(unsigned int proc_index, unsigned int vaddr,
                        unsigned int perm)
{
    // TODO
    return 0;
}
  105da0:	31 c0                	xor    %eax,%eax
  105da2:	c3                   	ret
  105da3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105daa:	00 
  105dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105db0 <alloc_mem_quota>:

/**
 * Designate some memory quota for the next child process.
 */
unsigned int alloc_mem_quota(unsigned int id, unsigned int quota)
{
  105db0:	53                   	push   %ebx
  105db1:	e8 87 a5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105db6:	81 c3 3e 92 00 00    	add    $0x923e,%ebx
  105dbc:	83 ec 10             	sub    $0x10,%esp
    unsigned int child;
    child = container_split(id, quota);
  105dbf:	ff 74 24 1c          	push   0x1c(%esp)
  105dc3:	ff 74 24 1c          	push   0x1c(%esp)
  105dc7:	e8 84 ed ff ff       	call   104b50 <container_split>
    return child;
  105dcc:	83 c4 18             	add    $0x18,%esp
  105dcf:	5b                   	pop    %ebx
  105dd0:	c3                   	ret
  105dd1:	66 90                	xchg   %ax,%ax
  105dd3:	66 90                	xchg   %ax,%ax
  105dd5:	66 90                	xchg   %ax,%ax
  105dd7:	66 90                	xchg   %ax,%ax
  105dd9:	66 90                	xchg   %ax,%ax
  105ddb:	66 90                	xchg   %ax,%ax
  105ddd:	66 90                	xchg   %ax,%ax
  105ddf:	90                   	nop

00105de0 <MPTNew_test1>:
#include <vmm/MPTOp/export.h>
#include <vmm/MPTNew/export.h>
#include "export.h"

int MPTNew_test1()
{
  105de0:	53                   	push   %ebx
  105de1:	e8 57 a5 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105de6:	81 c3 0e 92 00 00    	add    $0x920e,%ebx
  105dec:	83 ec 10             	sub    $0x10,%esp
    unsigned int vaddr = 4096 * 1024 * 400;
    container_split(0, 100);
  105def:	6a 64                	push   $0x64
  105df1:	6a 00                	push   $0x0
  105df3:	e8 58 ed ff ff       	call   104b50 <container_split>
    if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  105df8:	59                   	pop    %ecx
  105df9:	58                   	pop    %eax
  105dfa:	68 00 00 00 64       	push   $0x64000000
  105dff:	6a 01                	push   $0x1
  105e01:	e8 2a f5 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105e06:	83 c4 10             	add    $0x10,%esp
  105e09:	85 c0                	test   %eax,%eax
  105e0b:	0f 85 9f 00 00 00    	jne    105eb0 <MPTNew_test1+0xd0>
        dprintf("test 1.1 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(1, vaddr) != 0) {
  105e11:	83 ec 08             	sub    $0x8,%esp
  105e14:	68 00 00 00 64       	push   $0x64000000
  105e19:	6a 01                	push   $0x1
  105e1b:	e8 80 f5 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105e20:	83 c4 10             	add    $0x10,%esp
  105e23:	85 c0                	test   %eax,%eax
  105e25:	75 59                	jne    105e80 <MPTNew_test1+0xa0>
        dprintf("test 1.2 failed: (%d != 0)\n", get_pdir_entry_by_va(1, vaddr));
        return 1;
    }
    alloc_page(1, vaddr, 7);
  105e27:	83 ec 04             	sub    $0x4,%esp
  105e2a:	6a 07                	push   $0x7
  105e2c:	68 00 00 00 64       	push   $0x64000000
  105e31:	6a 01                	push   $0x1
  105e33:	e8 68 ff ff ff       	call   105da0 <alloc_page>
    if (get_ptbl_entry_by_va(1, vaddr) == 0) {
  105e38:	58                   	pop    %eax
  105e39:	5a                   	pop    %edx
  105e3a:	68 00 00 00 64       	push   $0x64000000
  105e3f:	6a 01                	push   $0x1
  105e41:	e8 ea f4 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105e46:	83 c4 10             	add    $0x10,%esp
  105e49:	85 c0                	test   %eax,%eax
  105e4b:	0f 84 af 00 00 00    	je     105f00 <MPTNew_test1+0x120>
        dprintf("test 1.3 failed: (%d == 0)\n", get_ptbl_entry_by_va(1, vaddr));
        return 1;
    }
    if (get_pdir_entry_by_va(1, vaddr) == 0) {
  105e51:	83 ec 08             	sub    $0x8,%esp
  105e54:	68 00 00 00 64       	push   $0x64000000
  105e59:	6a 01                	push   $0x1
  105e5b:	e8 40 f5 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105e60:	83 c4 10             	add    $0x10,%esp
  105e63:	85 c0                	test   %eax,%eax
  105e65:	74 71                	je     105ed8 <MPTNew_test1+0xf8>
        dprintf("test 1.4 failed: (%d == 0)\n", get_pdir_entry_by_va(1, vaddr));
        return 1;
    }
    dprintf("test 1 passed.\n");
  105e67:	83 ec 0c             	sub    $0xc,%esp
  105e6a:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  105e70:	50                   	push   %eax
  105e71:	e8 2c cd ff ff       	call   102ba2 <dprintf>
    return 0;
  105e76:	83 c4 10             	add    $0x10,%esp
  105e79:	31 c0                	xor    %eax,%eax
}
  105e7b:	83 c4 08             	add    $0x8,%esp
  105e7e:	5b                   	pop    %ebx
  105e7f:	c3                   	ret
        dprintf("test 1.2 failed: (%d != 0)\n", get_pdir_entry_by_va(1, vaddr));
  105e80:	83 ec 08             	sub    $0x8,%esp
  105e83:	68 00 00 00 64       	push   $0x64000000
  105e88:	6a 01                	push   $0x1
  105e8a:	e8 11 f5 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105e8f:	59                   	pop    %ecx
  105e90:	5a                   	pop    %edx
  105e91:	50                   	push   %eax
  105e92:	8d 83 41 95 ff ff    	lea    -0x6abf(%ebx),%eax
  105e98:	50                   	push   %eax
  105e99:	e8 04 cd ff ff       	call   102ba2 <dprintf>
        return 1;
  105e9e:	83 c4 10             	add    $0x10,%esp
}
  105ea1:	83 c4 08             	add    $0x8,%esp
        return 1;
  105ea4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  105ea9:	5b                   	pop    %ebx
  105eaa:	c3                   	ret
  105eab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.1 failed: (%d != 0)\n", get_ptbl_entry_by_va(1, vaddr));
  105eb0:	83 ec 08             	sub    $0x8,%esp
  105eb3:	68 00 00 00 64       	push   $0x64000000
  105eb8:	6a 01                	push   $0x1
  105eba:	e8 71 f4 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105ebf:	59                   	pop    %ecx
  105ec0:	5a                   	pop    %edx
  105ec1:	50                   	push   %eax
  105ec2:	8d 83 25 95 ff ff    	lea    -0x6adb(%ebx),%eax
  105ec8:	50                   	push   %eax
  105ec9:	e8 d4 cc ff ff       	call   102ba2 <dprintf>
        return 1;
  105ece:	83 c4 10             	add    $0x10,%esp
  105ed1:	eb ce                	jmp    105ea1 <MPTNew_test1+0xc1>
  105ed3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.4 failed: (%d == 0)\n", get_pdir_entry_by_va(1, vaddr));
  105ed8:	83 ec 08             	sub    $0x8,%esp
  105edb:	68 00 00 00 64       	push   $0x64000000
  105ee0:	6a 01                	push   $0x1
  105ee2:	e8 b9 f4 ff ff       	call   1053a0 <get_pdir_entry_by_va>
  105ee7:	5a                   	pop    %edx
  105ee8:	59                   	pop    %ecx
  105ee9:	50                   	push   %eax
  105eea:	8d 83 79 95 ff ff    	lea    -0x6a87(%ebx),%eax
  105ef0:	50                   	push   %eax
  105ef1:	e8 ac cc ff ff       	call   102ba2 <dprintf>
        return 1;
  105ef6:	83 c4 10             	add    $0x10,%esp
  105ef9:	eb a6                	jmp    105ea1 <MPTNew_test1+0xc1>
  105efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        dprintf("test 1.3 failed: (%d == 0)\n", get_ptbl_entry_by_va(1, vaddr));
  105f00:	83 ec 08             	sub    $0x8,%esp
  105f03:	68 00 00 00 64       	push   $0x64000000
  105f08:	6a 01                	push   $0x1
  105f0a:	e8 21 f4 ff ff       	call   105330 <get_ptbl_entry_by_va>
  105f0f:	5a                   	pop    %edx
  105f10:	59                   	pop    %ecx
  105f11:	50                   	push   %eax
  105f12:	8d 83 5d 95 ff ff    	lea    -0x6aa3(%ebx),%eax
  105f18:	50                   	push   %eax
  105f19:	e8 84 cc ff ff       	call   102ba2 <dprintf>
        return 1;
  105f1e:	83 c4 10             	add    $0x10,%esp
  105f21:	e9 7b ff ff ff       	jmp    105ea1 <MPTNew_test1+0xc1>
  105f26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105f2d:	00 
  105f2e:	66 90                	xchg   %ax,%ax

00105f30 <MPTNew_test_own>:
int MPTNew_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  105f30:	31 c0                	xor    %eax,%eax
  105f32:	c3                   	ret
  105f33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  105f3a:	00 
  105f3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00105f40 <test_MPTNew>:

int test_MPTNew()
{
    return MPTNew_test1() + MPTNew_test_own();
  105f40:	e9 9b fe ff ff       	jmp    105de0 <MPTNew_test1>
  105f45:	66 90                	xchg   %ax,%ax
  105f47:	66 90                	xchg   %ax,%ax
  105f49:	66 90                	xchg   %ax,%ax
  105f4b:	66 90                	xchg   %ax,%ax
  105f4d:	66 90                	xchg   %ax,%ax
  105f4f:	90                   	nop

00105f50 <kctx_set_esp>:
// Memory to save the NUM_IDS kernel thread states.
struct kctx kctx_pool[NUM_IDS];

void kctx_set_esp(unsigned int pid, void *esp)
{
    kctx_pool[pid].esp = esp;
  105f50:	e8 d9 ae ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  105f55:	81 c2 9f 90 00 00    	add    $0x909f,%edx
{
  105f5b:	8b 44 24 04          	mov    0x4(%esp),%eax
    kctx_pool[pid].esp = esp;
  105f5f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  105f63:	8d 04 40             	lea    (%eax,%eax,2),%eax
  105f66:	89 8c c2 0c 10 cb 00 	mov    %ecx,0xcb100c(%edx,%eax,8)
}
  105f6d:	c3                   	ret
  105f6e:	66 90                	xchg   %ax,%ax

00105f70 <kctx_set_eip>:

void kctx_set_eip(unsigned int pid, void *eip)
{
    kctx_pool[pid].eip = eip;
  105f70:	e8 b9 ae ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  105f75:	81 c2 7f 90 00 00    	add    $0x907f,%edx
{
  105f7b:	8b 44 24 04          	mov    0x4(%esp),%eax
    kctx_pool[pid].eip = eip;
  105f7f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  105f83:	8d 04 40             	lea    (%eax,%eax,2),%eax
  105f86:	89 8c c2 20 10 cb 00 	mov    %ecx,0xcb1020(%edx,%eax,8)
}
  105f8d:	c3                   	ret
  105f8e:	66 90                	xchg   %ax,%ax

00105f90 <kctx_switch>:
/**
 * Saves the states for thread # [from_pid] and restores the states
 * for thread # [to_pid].
 */
void kctx_switch(unsigned int from_pid, unsigned int to_pid)
{
  105f90:	53                   	push   %ebx
  105f91:	e8 a7 a3 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  105f96:	81 c3 5e 90 00 00    	add    $0x905e,%ebx
  105f9c:	83 ec 10             	sub    $0x10,%esp
  105f9f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  105fa3:	8b 54 24 18          	mov    0x18(%esp),%edx
    cswitch(&kctx_pool[from_pid], &kctx_pool[to_pid]);
  105fa7:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
  105faa:	8d 14 52             	lea    (%edx,%edx,2),%edx
  105fad:	8d 83 0c 10 cb 00    	lea    0xcb100c(%ebx),%eax
  105fb3:	8d 0c c8             	lea    (%eax,%ecx,8),%ecx
  105fb6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
  105fb9:	51                   	push   %ecx
  105fba:	50                   	push   %eax
  105fbb:	e8 05 00 00 00       	call   105fc5 <cswitch>
}
  105fc0:	83 c4 18             	add    $0x18,%esp
  105fc3:	5b                   	pop    %ebx
  105fc4:	c3                   	ret

00105fc5 <cswitch>:
/*
 * void cswitch(struct kctx *from, struct kctx *to);
 */
	.globl cswitch
cswitch:
	movl	4(%esp), %eax	/* %eax <- from */
  105fc5:	8b 44 24 04          	mov    0x4(%esp),%eax
	movl	8(%esp), %edx	/* %edx <- to */
  105fc9:	8b 54 24 08          	mov    0x8(%esp),%edx

	/* TODO: save the old kernel context */
	movl	0(%esp), %ecx
  105fcd:	8b 0c 24             	mov    (%esp),%ecx
	movl	%ecx, 20(%eax)
  105fd0:	89 48 14             	mov    %ecx,0x14(%eax)
	movl	%ebp, 16(%eax)
  105fd3:	89 68 10             	mov    %ebp,0x10(%eax)
	movl	%ebx, 12(%eax)
  105fd6:	89 58 0c             	mov    %ebx,0xc(%eax)
	movl	%esi, 8(%eax)
  105fd9:	89 70 08             	mov    %esi,0x8(%eax)
	movl	%edi, 4(%eax)
  105fdc:	89 78 04             	mov    %edi,0x4(%eax)
	movl	%esp, 0(%eax)
  105fdf:	89 20                	mov    %esp,(%eax)

	/* TODO: load the new kernel context */
	movl	0(%edx), %esp
  105fe1:	8b 22                	mov    (%edx),%esp
	movl	4(%edx), %edi
  105fe3:	8b 7a 04             	mov    0x4(%edx),%edi
	movl	8(%edx), %esi
  105fe6:	8b 72 08             	mov    0x8(%edx),%esi
	movl	12(%edx), %ebx
  105fe9:	8b 5a 0c             	mov    0xc(%edx),%ebx
	movl	16(%edx), %ebp
  105fec:	8b 6a 10             	mov    0x10(%edx),%ebp
	movl	20(%edx), %ecx
  105fef:	8b 4a 14             	mov    0x14(%edx),%ecx
	movl	%ecx, 0(%esp)
  105ff2:	89 0c 24             	mov    %ecx,(%esp)

	xor	%eax, %eax
  105ff5:	31 c0                	xor    %eax,%eax
	ret
  105ff7:	c3                   	ret
  105ff8:	66 90                	xchg   %ax,%ax
  105ffa:	66 90                	xchg   %ax,%ax
  105ffc:	66 90                	xchg   %ax,%ax
  105ffe:	66 90                	xchg   %ax,%ax

00106000 <kctx_new>:
 * We do not care about the rest of states when a new thread starts.
 * The function returns the child thread (process) id.
 * In case of an error, return NUM_IDS.
 */
unsigned int kctx_new(void *entry, unsigned int id, unsigned int quota)
{
  106000:	56                   	push   %esi
  106001:	53                   	push   %ebx
  106002:	e8 36 a3 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106007:	81 c3 ed 8f 00 00    	add    $0x8fed,%ebx
  10600d:	83 ec 0c             	sub    $0xc,%esp
    // TODO
    unsigned int child = alloc_mem_quota(id, quota);
  106010:	ff 74 24 20          	push   0x20(%esp)
  106014:	ff 74 24 20          	push   0x20(%esp)
  106018:	e8 93 fd ff ff       	call   105db0 <alloc_mem_quota>
  10601d:	89 c6                	mov    %eax,%esi
    kctx_set_eip(child, entry);
  10601f:	58                   	pop    %eax
  106020:	5a                   	pop    %edx
  106021:	ff 74 24 18          	push   0x18(%esp)
  106025:	56                   	push   %esi
  106026:	e8 45 ff ff ff       	call   105f70 <kctx_set_eip>
    kctx_set_esp(child, (void *)&STACK_LOC[child][PAGESIZE - 1]);
  10602b:	59                   	pop    %ecx
  10602c:	89 f2                	mov    %esi,%edx
  10602e:	58                   	pop    %eax
  10602f:	c7 c0 00 e0 13 00    	mov    $0x13e000,%eax
  106035:	c1 e2 0c             	shl    $0xc,%edx
  106038:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  10603f:	50                   	push   %eax
  106040:	56                   	push   %esi
  106041:	e8 0a ff ff ff       	call   105f50 <kctx_set_esp>

    return child;
}
  106046:	83 c4 14             	add    $0x14,%esp
  106049:	89 f0                	mov    %esi,%eax
  10604b:	5b                   	pop    %ebx
  10604c:	5e                   	pop    %esi
  10604d:	c3                   	ret
  10604e:	66 90                	xchg   %ax,%ax

00106050 <PKCtxNew_test1>:
    void *eip;
} kctx;
extern kctx kctx_pool[NUM_IDS];

int PKCtxNew_test1()
{
  106050:	56                   	push   %esi
  106051:	53                   	push   %ebx
  106052:	e8 e6 a2 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106057:	81 c3 9d 8f 00 00    	add    $0x8f9d,%ebx
  10605d:	83 ec 08             	sub    $0x8,%esp
    void *dummy_addr = (void *) 0;
    unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  106060:	68 e8 03 00 00       	push   $0x3e8
  106065:	6a 00                	push   $0x0
  106067:	6a 00                	push   $0x0
  106069:	e8 92 ff ff ff       	call   106000 <kctx_new>
    if (container_get_quota(chid) != 1000) {
  10606e:	89 04 24             	mov    %eax,(%esp)
    unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  106071:	89 c6                	mov    %eax,%esi
    if (container_get_quota(chid) != 1000) {
  106073:	e8 68 ea ff ff       	call   104ae0 <container_get_quota>
  106078:	83 c4 10             	add    $0x10,%esp
  10607b:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  106080:	75 56                	jne    1060d8 <PKCtxNew_test1+0x88>
        dprintf("test 1.1 failed: (%d != 1000)\n", container_get_quota(chid));
        return 1;
    }
    if (kctx_pool[chid].eip != dummy_addr) {
  106082:	c7 c2 00 00 dc 00    	mov    $0xdc0000,%edx
  106088:	8d 04 76             	lea    (%esi,%esi,2),%eax
  10608b:	8d 04 c2             	lea    (%edx,%eax,8),%eax
  10608e:	8b 40 14             	mov    0x14(%eax),%eax
  106091:	85 c0                	test   %eax,%eax
  106093:	74 23                	je     1060b8 <PKCtxNew_test1+0x68>
        dprintf("test 1.2 failed: (%d != %d)\n", kctx_pool[chid].eip, dummy_addr);
  106095:	83 ec 04             	sub    $0x4,%esp
  106098:	6a 00                	push   $0x0
  10609a:	50                   	push   %eax
  10609b:	8d 83 ec 94 ff ff    	lea    -0x6b14(%ebx),%eax
  1060a1:	50                   	push   %eax
  1060a2:	e8 fb ca ff ff       	call   102ba2 <dprintf>
        return 1;
  1060a7:	83 c4 10             	add    $0x10,%esp
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  1060aa:	83 c4 04             	add    $0x4,%esp
        return 1;
  1060ad:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1060b2:	5b                   	pop    %ebx
  1060b3:	5e                   	pop    %esi
  1060b4:	c3                   	ret
  1060b5:	8d 76 00             	lea    0x0(%esi),%esi
    dprintf("test 1 passed.\n");
  1060b8:	83 ec 0c             	sub    $0xc,%esp
  1060bb:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  1060c1:	50                   	push   %eax
  1060c2:	e8 db ca ff ff       	call   102ba2 <dprintf>
    return 0;
  1060c7:	83 c4 10             	add    $0x10,%esp
  1060ca:	31 c0                	xor    %eax,%eax
}
  1060cc:	83 c4 04             	add    $0x4,%esp
  1060cf:	5b                   	pop    %ebx
  1060d0:	5e                   	pop    %esi
  1060d1:	c3                   	ret
  1060d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dprintf("test 1.1 failed: (%d != 1000)\n", container_get_quota(chid));
  1060d8:	83 ec 0c             	sub    $0xc,%esp
  1060db:	56                   	push   %esi
  1060dc:	e8 ff e9 ff ff       	call   104ae0 <container_get_quota>
  1060e1:	59                   	pop    %ecx
  1060e2:	5e                   	pop    %esi
  1060e3:	50                   	push   %eax
  1060e4:	8d 83 8c 9e ff ff    	lea    -0x6174(%ebx),%eax
  1060ea:	50                   	push   %eax
  1060eb:	e8 b2 ca ff ff       	call   102ba2 <dprintf>
        return 1;
  1060f0:	83 c4 10             	add    $0x10,%esp
  1060f3:	eb b5                	jmp    1060aa <PKCtxNew_test1+0x5a>
  1060f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1060fc:	00 
  1060fd:	8d 76 00             	lea    0x0(%esi),%esi

00106100 <PKCtxNew_test_own>:
int PKCtxNew_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  106100:	31 c0                	xor    %eax,%eax
  106102:	c3                   	ret
  106103:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10610a:	00 
  10610b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00106110 <test_PKCtxNew>:

int test_PKCtxNew()
{
    return PKCtxNew_test1() + PKCtxNew_test_own();
  106110:	e9 3b ff ff ff       	jmp    106050 <PKCtxNew_test1>
  106115:	66 90                	xchg   %ax,%ax
  106117:	66 90                	xchg   %ax,%ax
  106119:	66 90                	xchg   %ax,%ax
  10611b:	66 90                	xchg   %ax,%ax
  10611d:	66 90                	xchg   %ax,%ax
  10611f:	90                   	nop

00106120 <tcb_get_state>:

struct TCB TCBPool[NUM_IDS];

unsigned int tcb_get_state(unsigned int pid)
{
    return TCBPool[pid].state;
  106120:	e8 09 ad ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  106125:	81 c2 cf 8e 00 00    	add    $0x8ecf,%edx
{
  10612b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return TCBPool[pid].state;
  10612f:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106132:	8b 84 82 0c 16 cb 00 	mov    0xcb160c(%edx,%eax,4),%eax
}
  106139:	c3                   	ret
  10613a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106140 <tcb_set_state>:

void tcb_set_state(unsigned int pid, unsigned int state)
{
    TCBPool[pid].state = state;
  106140:	e8 e9 ac ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  106145:	81 c2 af 8e 00 00    	add    $0x8eaf,%edx
{
  10614b:	8b 44 24 04          	mov    0x4(%esp),%eax
    TCBPool[pid].state = state;
  10614f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  106153:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106156:	89 8c 82 0c 16 cb 00 	mov    %ecx,0xcb160c(%edx,%eax,4)
}
  10615d:	c3                   	ret
  10615e:	66 90                	xchg   %ax,%ax

00106160 <tcb_get_prev>:

unsigned int tcb_get_prev(unsigned int pid)
{
    return TCBPool[pid].prev;
  106160:	e8 c9 ac ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  106165:	81 c2 8f 8e 00 00    	add    $0x8e8f,%edx
{
  10616b:	8b 44 24 04          	mov    0x4(%esp),%eax
    return TCBPool[pid].prev;
  10616f:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106172:	8b 84 82 10 16 cb 00 	mov    0xcb1610(%edx,%eax,4),%eax
}
  106179:	c3                   	ret
  10617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106180 <tcb_set_prev>:

void tcb_set_prev(unsigned int pid, unsigned int prev_pid)
{
    TCBPool[pid].prev = prev_pid;
  106180:	e8 a9 ac ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  106185:	81 c2 6f 8e 00 00    	add    $0x8e6f,%edx
{
  10618b:	8b 44 24 04          	mov    0x4(%esp),%eax
    TCBPool[pid].prev = prev_pid;
  10618f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  106193:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106196:	89 8c 82 10 16 cb 00 	mov    %ecx,0xcb1610(%edx,%eax,4)
}
  10619d:	c3                   	ret
  10619e:	66 90                	xchg   %ax,%ax

001061a0 <tcb_get_next>:

unsigned int tcb_get_next(unsigned int pid)
{
    return TCBPool[pid].next;
  1061a0:	e8 89 ac ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  1061a5:	81 c2 4f 8e 00 00    	add    $0x8e4f,%edx
{
  1061ab:	8b 44 24 04          	mov    0x4(%esp),%eax
    return TCBPool[pid].next;
  1061af:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1061b2:	8b 84 82 14 16 cb 00 	mov    0xcb1614(%edx,%eax,4),%eax
}
  1061b9:	c3                   	ret
  1061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001061c0 <tcb_set_next>:

void tcb_set_next(unsigned int pid, unsigned int next_pid)
{
    TCBPool[pid].next = next_pid;
  1061c0:	e8 69 ac ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  1061c5:	81 c2 2f 8e 00 00    	add    $0x8e2f,%edx
{
  1061cb:	8b 44 24 04          	mov    0x4(%esp),%eax
    TCBPool[pid].next = next_pid;
  1061cf:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1061d3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1061d6:	89 8c 82 14 16 cb 00 	mov    %ecx,0xcb1614(%edx,%eax,4)
}
  1061dd:	c3                   	ret
  1061de:	66 90                	xchg   %ax,%ax

001061e0 <tcb_init_at_id>:

void tcb_init_at_id(unsigned int pid)
{
    TCBPool[pid].state = TSTATE_DEAD;
  1061e0:	e8 49 ac ff ff       	call   100e2e <__x86.get_pc_thunk.dx>
  1061e5:	81 c2 0f 8e 00 00    	add    $0x8e0f,%edx
{
  1061eb:	8b 44 24 04          	mov    0x4(%esp),%eax
    TCBPool[pid].state = TSTATE_DEAD;
  1061ef:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1061f2:	c1 e0 02             	shl    $0x2,%eax
  1061f5:	c7 84 02 0c 16 cb 00 	movl   $0x3,0xcb160c(%edx,%eax,1)
  1061fc:	03 00 00 00 
    TCBPool[pid].prev = NUM_IDS;
  106200:	8d 84 02 0c 16 cb 00 	lea    0xcb160c(%edx,%eax,1),%eax
  106207:	c7 40 04 40 00 00 00 	movl   $0x40,0x4(%eax)
    TCBPool[pid].next = NUM_IDS;
  10620e:	c7 40 08 40 00 00 00 	movl   $0x40,0x8(%eax)
}
  106215:	c3                   	ret
  106216:	66 90                	xchg   %ax,%ax
  106218:	66 90                	xchg   %ax,%ax
  10621a:	66 90                	xchg   %ax,%ax
  10621c:	66 90                	xchg   %ax,%ax
  10621e:	66 90                	xchg   %ax,%ax

00106220 <tcb_init>:
/**
 * Initializes the TCB for all NUM_IDS threads with the state TSTATE_DEAD,
 * and with two indices being NUM_IDS (which represents NULL).
 */
void tcb_init(unsigned int mbi_addr)
{
  106220:	56                   	push   %esi

    paging_init(mbi_addr);

    // TODO
    int id;
        for(id = 0; id < NUM_IDS; id++){
  106221:	31 f6                	xor    %esi,%esi
{
  106223:	53                   	push   %ebx
  106224:	e8 14 a1 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106229:	81 c3 cb 8d 00 00    	add    $0x8dcb,%ebx
  10622f:	83 ec 10             	sub    $0x10,%esp
    paging_init(mbi_addr);
  106232:	ff 74 24 1c          	push   0x1c(%esp)
  106236:	e8 35 fb ff ff       	call   105d70 <paging_init>
  10623b:	83 c4 10             	add    $0x10,%esp
  10623e:	66 90                	xchg   %ax,%ax
		tcb_init_at_id(id);
  106240:	83 ec 0c             	sub    $0xc,%esp
  106243:	56                   	push   %esi
        for(id = 0; id < NUM_IDS; id++){
  106244:	83 c6 01             	add    $0x1,%esi
		tcb_init_at_id(id);
  106247:	e8 94 ff ff ff       	call   1061e0 <tcb_init_at_id>
        for(id = 0; id < NUM_IDS; id++){
  10624c:	83 c4 10             	add    $0x10,%esp
  10624f:	83 fe 40             	cmp    $0x40,%esi
  106252:	75 ec                	jne    106240 <tcb_init+0x20>
	}
}
  106254:	83 c4 04             	add    $0x4,%esp
  106257:	5b                   	pop    %ebx
  106258:	5e                   	pop    %esi
  106259:	c3                   	ret
  10625a:	66 90                	xchg   %ax,%ax
  10625c:	66 90                	xchg   %ax,%ax
  10625e:	66 90                	xchg   %ax,%ax

00106260 <PTCBInit_test1>:
#include <lib/thread.h>
#include <thread/PTCBIntro/export.h>
#include "export.h"

int PTCBInit_test1()
{
  106260:	55                   	push   %ebp
  106261:	57                   	push   %edi
  106262:	56                   	push   %esi
    unsigned int i;
    for (i = 1; i < NUM_IDS; i++) {
  106263:	be 01 00 00 00       	mov    $0x1,%esi
{
  106268:	53                   	push   %ebx
  106269:	e8 cf a0 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10626e:	81 c3 86 8d 00 00    	add    $0x8d86,%ebx
  106274:	83 ec 0c             	sub    $0xc,%esp
  106277:	eb 31                	jmp    1062aa <PTCBInit_test1+0x4a>
  106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS
  106280:	83 ec 0c             	sub    $0xc,%esp
  106283:	56                   	push   %esi
  106284:	e8 d7 fe ff ff       	call   106160 <tcb_get_prev>
  106289:	83 c4 10             	add    $0x10,%esp
  10628c:	83 f8 40             	cmp    $0x40,%eax
  10628f:	75 2a                	jne    1062bb <PTCBInit_test1+0x5b>
            || tcb_get_next(i) != NUM_IDS) {
  106291:	83 ec 0c             	sub    $0xc,%esp
  106294:	56                   	push   %esi
  106295:	e8 06 ff ff ff       	call   1061a0 <tcb_get_next>
  10629a:	83 c4 10             	add    $0x10,%esp
  10629d:	83 f8 40             	cmp    $0x40,%eax
  1062a0:	75 19                	jne    1062bb <PTCBInit_test1+0x5b>
    for (i = 1; i < NUM_IDS; i++) {
  1062a2:	83 c6 01             	add    $0x1,%esi
  1062a5:	83 fe 40             	cmp    $0x40,%esi
  1062a8:	74 56                	je     106300 <PTCBInit_test1+0xa0>
        if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS
  1062aa:	83 ec 0c             	sub    $0xc,%esp
  1062ad:	56                   	push   %esi
  1062ae:	e8 6d fe ff ff       	call   106120 <tcb_get_state>
  1062b3:	83 c4 10             	add    $0x10,%esp
  1062b6:	83 f8 03             	cmp    $0x3,%eax
  1062b9:	74 c5                	je     106280 <PTCBInit_test1+0x20>
            dprintf("test 1.1 failed (i = %d): "
  1062bb:	83 ec 0c             	sub    $0xc,%esp
  1062be:	56                   	push   %esi
  1062bf:	e8 dc fe ff ff       	call   1061a0 <tcb_get_next>
  1062c4:	89 34 24             	mov    %esi,(%esp)
  1062c7:	89 c5                	mov    %eax,%ebp
  1062c9:	e8 92 fe ff ff       	call   106160 <tcb_get_prev>
  1062ce:	89 34 24             	mov    %esi,(%esp)
  1062d1:	89 c7                	mov    %eax,%edi
  1062d3:	e8 48 fe ff ff       	call   106120 <tcb_get_state>
  1062d8:	6a 40                	push   $0x40
  1062da:	55                   	push   %ebp
  1062db:	6a 40                	push   $0x40
  1062dd:	57                   	push   %edi
  1062de:	6a 03                	push   $0x3
  1062e0:	50                   	push   %eax
  1062e1:	8d 83 ac 9e ff ff    	lea    -0x6154(%ebx),%eax
  1062e7:	56                   	push   %esi
  1062e8:	50                   	push   %eax
  1062e9:	e8 b4 c8 ff ff       	call   102ba2 <dprintf>
                    "(%d != %d || %d != %d || %d != %d)\n",
                    i, tcb_get_state(i), TSTATE_DEAD,
                    tcb_get_prev(i), NUM_IDS,
                    tcb_get_next(i), NUM_IDS);
            return 1;
  1062ee:	83 c4 30             	add    $0x30,%esp
  1062f1:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  1062f6:	83 c4 0c             	add    $0xc,%esp
  1062f9:	5b                   	pop    %ebx
  1062fa:	5e                   	pop    %esi
  1062fb:	5f                   	pop    %edi
  1062fc:	5d                   	pop    %ebp
  1062fd:	c3                   	ret
  1062fe:	66 90                	xchg   %ax,%ax
    dprintf("test 1 passed.\n");
  106300:	83 ec 0c             	sub    $0xc,%esp
  106303:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  106309:	50                   	push   %eax
  10630a:	e8 93 c8 ff ff       	call   102ba2 <dprintf>
    return 0;
  10630f:	83 c4 10             	add    $0x10,%esp
  106312:	31 c0                	xor    %eax,%eax
}
  106314:	83 c4 0c             	add    $0xc,%esp
  106317:	5b                   	pop    %ebx
  106318:	5e                   	pop    %esi
  106319:	5f                   	pop    %edi
  10631a:	5d                   	pop    %ebp
  10631b:	c3                   	ret
  10631c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106320 <PTCBInit_test_own>:
int PTCBInit_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  106320:	31 c0                	xor    %eax,%eax
  106322:	c3                   	ret
  106323:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10632a:	00 
  10632b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00106330 <test_PTCBInit>:

int test_PTCBInit()
{
    return PTCBInit_test1() + PTCBInit_test_own();
  106330:	e9 2b ff ff ff       	jmp    106260 <PTCBInit_test1>
  106335:	66 90                	xchg   %ax,%ax
  106337:	66 90                	xchg   %ax,%ax
  106339:	66 90                	xchg   %ax,%ax
  10633b:	66 90                	xchg   %ax,%ax
  10633d:	66 90                	xchg   %ax,%ax
  10633f:	90                   	nop

00106340 <tqueue_get_head>:
 */
struct TQueue TQueuePool[NUM_IDS + 1];

unsigned int tqueue_get_head(unsigned int chid)
{
    return TQueuePool[chid].head;
  106340:	e8 e5 aa ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  106345:	05 af 8c 00 00       	add    $0x8caf,%eax
  10634a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10634e:	8b 84 d0 0c 19 cb 00 	mov    0xcb190c(%eax,%edx,8),%eax
}
  106355:	c3                   	ret
  106356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10635d:	00 
  10635e:	66 90                	xchg   %ax,%ax

00106360 <tqueue_set_head>:

void tqueue_set_head(unsigned int chid, unsigned int head)
{
    TQueuePool[chid].head = head;
  106360:	e8 c5 aa ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  106365:	05 8f 8c 00 00       	add    $0x8c8f,%eax
  10636a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10636e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  106372:	89 8c d0 0c 19 cb 00 	mov    %ecx,0xcb190c(%eax,%edx,8)
}
  106379:	c3                   	ret
  10637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106380 <tqueue_get_tail>:

unsigned int tqueue_get_tail(unsigned int chid)
{
    return TQueuePool[chid].tail;
  106380:	e8 a5 aa ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  106385:	05 6f 8c 00 00       	add    $0x8c6f,%eax
  10638a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10638e:	8b 84 d0 10 19 cb 00 	mov    0xcb1910(%eax,%edx,8),%eax
}
  106395:	c3                   	ret
  106396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10639d:	00 
  10639e:	66 90                	xchg   %ax,%ax

001063a0 <tqueue_set_tail>:

void tqueue_set_tail(unsigned int chid, unsigned int tail)
{
    TQueuePool[chid].tail = tail;
  1063a0:	e8 85 aa ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  1063a5:	05 4f 8c 00 00       	add    $0x8c4f,%eax
  1063aa:	8b 54 24 04          	mov    0x4(%esp),%edx
  1063ae:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1063b2:	89 8c d0 10 19 cb 00 	mov    %ecx,0xcb1910(%eax,%edx,8)
}
  1063b9:	c3                   	ret
  1063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001063c0 <tqueue_init_at_id>:

void tqueue_init_at_id(unsigned int chid)
{
    TQueuePool[chid].head = NUM_IDS;
  1063c0:	e8 65 aa ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  1063c5:	05 2f 8c 00 00       	add    $0x8c2f,%eax
{
  1063ca:	8b 54 24 04          	mov    0x4(%esp),%edx
    TQueuePool[chid].head = NUM_IDS;
  1063ce:	c7 84 d0 0c 19 cb 00 	movl   $0x40,0xcb190c(%eax,%edx,8)
  1063d5:	40 00 00 00 
    TQueuePool[chid].tail = NUM_IDS;
  1063d9:	c7 84 d0 10 19 cb 00 	movl   $0x40,0xcb1910(%eax,%edx,8)
  1063e0:	40 00 00 00 
}
  1063e4:	c3                   	ret
  1063e5:	66 90                	xchg   %ax,%ax
  1063e7:	66 90                	xchg   %ax,%ax
  1063e9:	66 90                	xchg   %ax,%ax
  1063eb:	66 90                	xchg   %ax,%ax
  1063ed:	66 90                	xchg   %ax,%ax
  1063ef:	90                   	nop

001063f0 <tqueue_init>:

/**
 * Initializes all the thread queues with tqueue_init_at_id.
 */
void tqueue_init(unsigned int mbi_addr)
{
  1063f0:	56                   	push   %esi

    tcb_init(mbi_addr);

    unsigned int id;
    // TODO
    for (id = 0; id <= NUM_IDS; id++)
  1063f1:	31 f6                	xor    %esi,%esi
{
  1063f3:	53                   	push   %ebx
  1063f4:	e8 44 9f ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1063f9:	81 c3 fb 8b 00 00    	add    $0x8bfb,%ebx
  1063ff:	83 ec 10             	sub    $0x10,%esp
    tcb_init(mbi_addr);
  106402:	ff 74 24 1c          	push   0x1c(%esp)
  106406:	e8 15 fe ff ff       	call   106220 <tcb_init>
  10640b:	83 c4 10             	add    $0x10,%esp
  10640e:	66 90                	xchg   %ax,%ax
    {
        tqueue_init_at_id(id);
  106410:	83 ec 0c             	sub    $0xc,%esp
  106413:	56                   	push   %esi
    for (id = 0; id <= NUM_IDS; id++)
  106414:	83 c6 01             	add    $0x1,%esi
        tqueue_init_at_id(id);
  106417:	e8 a4 ff ff ff       	call   1063c0 <tqueue_init_at_id>
    for (id = 0; id <= NUM_IDS; id++)
  10641c:	83 c4 10             	add    $0x10,%esp
  10641f:	83 fe 41             	cmp    $0x41,%esi
  106422:	75 ec                	jne    106410 <tqueue_init+0x20>
    }
}
  106424:	83 c4 04             	add    $0x4,%esp
  106427:	5b                   	pop    %ebx
  106428:	5e                   	pop    %esi
  106429:	c3                   	ret
  10642a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106430 <tqueue_enqueue>:
 * Recall that the doubly linked list is index based.
 * So you only need to insert the index.
 * Hint: there are multiple cases in this function.
 */
void tqueue_enqueue(unsigned int chid, unsigned int pid)
{
  106430:	55                   	push   %ebp
  106431:	57                   	push   %edi
  106432:	56                   	push   %esi
  106433:	53                   	push   %ebx
  106434:	e8 04 9f ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106439:	81 c3 bb 8b 00 00    	add    $0x8bbb,%ebx
  10643f:	83 ec 18             	sub    $0x18,%esp
  106442:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  106446:	8b 7c 24 30          	mov    0x30(%esp),%edi
    // TODO

    unsigned int tail_pid;

    tail_pid = tqueue_get_tail(chid);
  10644a:	55                   	push   %ebp
  10644b:	e8 30 ff ff ff       	call   106380 <tqueue_get_tail>
    if (tail_pid != NUM_IDS)
  106450:	83 c4 10             	add    $0x10,%esp
    tail_pid = tqueue_get_tail(chid);
  106453:	89 c6                	mov    %eax,%esi
    if (tail_pid != NUM_IDS)
  106455:	83 f8 40             	cmp    $0x40,%eax
  106458:	74 2e                	je     106488 <tqueue_enqueue+0x58>
    {
        tcb_set_next(tail_pid, pid);
  10645a:	83 ec 08             	sub    $0x8,%esp
  10645d:	57                   	push   %edi
  10645e:	50                   	push   %eax
  10645f:	e8 5c fd ff ff       	call   1061c0 <tcb_set_next>
  106464:	83 c4 10             	add    $0x10,%esp
    else
    {
        tqueue_set_head(chid, pid);
    }

    tcb_set_prev(pid, tail_pid);
  106467:	83 ec 08             	sub    $0x8,%esp
  10646a:	56                   	push   %esi
  10646b:	57                   	push   %edi
  10646c:	e8 0f fd ff ff       	call   106180 <tcb_set_prev>
    tqueue_set_tail(chid, pid);
  106471:	58                   	pop    %eax
  106472:	5a                   	pop    %edx
  106473:	57                   	push   %edi
  106474:	55                   	push   %ebp
  106475:	e8 26 ff ff ff       	call   1063a0 <tqueue_set_tail>
}
  10647a:	83 c4 1c             	add    $0x1c,%esp
  10647d:	5b                   	pop    %ebx
  10647e:	5e                   	pop    %esi
  10647f:	5f                   	pop    %edi
  106480:	5d                   	pop    %ebp
  106481:	c3                   	ret
  106482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        tqueue_set_head(chid, pid);
  106488:	83 ec 08             	sub    $0x8,%esp
  10648b:	57                   	push   %edi
  10648c:	55                   	push   %ebp
  10648d:	e8 ce fe ff ff       	call   106360 <tqueue_set_head>
  106492:	83 c4 10             	add    $0x10,%esp
  106495:	eb d0                	jmp    106467 <tqueue_enqueue+0x37>
  106497:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10649e:	00 
  10649f:	90                   	nop

001064a0 <tqueue_dequeue>:
 * Reverse action of tqueue_enqueue, i.e. pops a TCB from the head of the specified queue.
 * It returns the popped thread's id, or NUM_IDS if the queue is empty.
 * Hint: there are multiple cases in this function.
 */
unsigned int tqueue_dequeue(unsigned int chid)
{
  1064a0:	55                   	push   %ebp
  1064a1:	57                   	push   %edi
  1064a2:	56                   	push   %esi
  1064a3:	53                   	push   %ebx
  1064a4:	e8 94 9e ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1064a9:	81 c3 4b 8b 00 00    	add    $0x8b4b,%ebx
  1064af:	83 ec 18             	sub    $0x18,%esp
  1064b2:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
    // TODO
    unsigned int head_id, head_next_id;
    head_id = tqueue_get_head(chid);
  1064b6:	55                   	push   %ebp
  1064b7:	e8 84 fe ff ff       	call   106340 <tqueue_get_head>
    if (head_id == NUM_IDS)
  1064bc:	83 c4 10             	add    $0x10,%esp
    head_id = tqueue_get_head(chid);
  1064bf:	89 c6                	mov    %eax,%esi
    if (head_id == NUM_IDS)
  1064c1:	83 f8 40             	cmp    $0x40,%eax
  1064c4:	74 38                	je     1064fe <tqueue_dequeue+0x5e>
        return NUM_IDS;

    
    head_next_id = tcb_get_next(head_id);
  1064c6:	83 ec 0c             	sub    $0xc,%esp
  1064c9:	50                   	push   %eax
  1064ca:	e8 d1 fc ff ff       	call   1061a0 <tcb_get_next>
    if (head_next_id != NUM_IDS)
  1064cf:	83 c4 10             	add    $0x10,%esp
    head_next_id = tcb_get_next(head_id);
  1064d2:	89 c7                	mov    %eax,%edi
    if (head_next_id != NUM_IDS)
  1064d4:	83 f8 40             	cmp    $0x40,%eax
  1064d7:	74 37                	je     106510 <tqueue_dequeue+0x70>
    {
        tcb_set_prev(head_next_id, NUM_IDS);
  1064d9:	83 ec 08             	sub    $0x8,%esp
  1064dc:	6a 40                	push   $0x40
  1064de:	50                   	push   %eax
  1064df:	e8 9c fc ff ff       	call   106180 <tcb_set_prev>
  1064e4:	83 c4 10             	add    $0x10,%esp
    }
    else
    {
        tqueue_set_tail(chid, NUM_IDS);
    }
    tcb_set_next(head_id, NUM_IDS);
  1064e7:	83 ec 08             	sub    $0x8,%esp
  1064ea:	6a 40                	push   $0x40
  1064ec:	56                   	push   %esi
  1064ed:	e8 ce fc ff ff       	call   1061c0 <tcb_set_next>
    tqueue_set_head(chid, head_next_id);
  1064f2:	58                   	pop    %eax
  1064f3:	5a                   	pop    %edx
  1064f4:	57                   	push   %edi
  1064f5:	55                   	push   %ebp
  1064f6:	e8 65 fe ff ff       	call   106360 <tqueue_set_head>
    return head_id;
  1064fb:	83 c4 10             	add    $0x10,%esp
}
  1064fe:	83 c4 0c             	add    $0xc,%esp
  106501:	89 f0                	mov    %esi,%eax
  106503:	5b                   	pop    %ebx
  106504:	5e                   	pop    %esi
  106505:	5f                   	pop    %edi
  106506:	5d                   	pop    %ebp
  106507:	c3                   	ret
  106508:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10650f:	00 
        tqueue_set_tail(chid, NUM_IDS);
  106510:	83 ec 08             	sub    $0x8,%esp
  106513:	6a 40                	push   $0x40
  106515:	55                   	push   %ebp
  106516:	e8 85 fe ff ff       	call   1063a0 <tqueue_set_tail>
  10651b:	83 c4 10             	add    $0x10,%esp
  10651e:	eb c7                	jmp    1064e7 <tqueue_dequeue+0x47>

00106520 <tqueue_remove>:
/**
 * Removes the TCB #pid from the queue #chid.
 * Hint: there are many cases in this function.
 */
void tqueue_remove(unsigned int chid, unsigned int pid)
{
  106520:	55                   	push   %ebp
  106521:	57                   	push   %edi
  106522:	56                   	push   %esi
  106523:	53                   	push   %ebx
  106524:	e8 14 9e ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106529:	81 c3 cb 8a 00 00    	add    $0x8acb,%ebx
  10652f:	83 ec 28             	sub    $0x28,%esp
  106532:	8b 74 24 40          	mov    0x40(%esp),%esi
    // TODO
    unsigned int head_pid, tail_pid;
    unsigned int prev_pid, next_pid;
    head_pid = tqueue_get_head(chid);
  106536:	ff 74 24 3c          	push   0x3c(%esp)
  10653a:	e8 01 fe ff ff       	call   106340 <tqueue_get_head>
    tail_pid = tqueue_get_tail(chid);
  10653f:	59                   	pop    %ecx
  106540:	ff 74 24 3c          	push   0x3c(%esp)
    head_pid = tqueue_get_head(chid);
  106544:	89 c5                	mov    %eax,%ebp
    tail_pid = tqueue_get_tail(chid);
  106546:	e8 35 fe ff ff       	call   106380 <tqueue_get_tail>
    prev_pid = tcb_get_prev(pid);
  10654b:	89 34 24             	mov    %esi,(%esp)
    tail_pid = tqueue_get_tail(chid);
  10654e:	89 44 24 18          	mov    %eax,0x18(%esp)
    prev_pid = tcb_get_prev(pid);
  106552:	e8 09 fc ff ff       	call   106160 <tcb_get_prev>
    next_pid = tcb_get_next(pid);
  106557:	89 34 24             	mov    %esi,(%esp)
    prev_pid = tcb_get_prev(pid);
  10655a:	89 c7                	mov    %eax,%edi
    next_pid = tcb_get_next(pid);
  10655c:	e8 3f fc ff ff       	call   1061a0 <tcb_get_next>
    if (head_pid == pid)
  106561:	83 c4 10             	add    $0x10,%esp
  106564:	39 f5                	cmp    %esi,%ebp
  106566:	74 78                	je     1065e0 <tqueue_remove+0xc0>
    {
        tqueue_set_head(chid, next_pid);
    }
    if (tail_pid == pid)
  106568:	39 74 24 08          	cmp    %esi,0x8(%esp)
  10656c:	74 52                	je     1065c0 <tqueue_remove+0xa0>
    {
        tqueue_set_tail(chid, prev_pid);
    }
    if (next_pid != NUM_IDS)
  10656e:	83 f8 40             	cmp    $0x40,%eax
  106571:	74 15                	je     106588 <tqueue_remove+0x68>
    {
        tcb_set_prev(next_pid, prev_pid);
  106573:	83 ec 08             	sub    $0x8,%esp
  106576:	57                   	push   %edi
  106577:	50                   	push   %eax
  106578:	89 44 24 18          	mov    %eax,0x18(%esp)
  10657c:	e8 ff fb ff ff       	call   106180 <tcb_set_prev>
  106581:	8b 44 24 18          	mov    0x18(%esp),%eax
  106585:	83 c4 10             	add    $0x10,%esp
    }
    if (prev_pid != NUM_IDS)
  106588:	83 ff 40             	cmp    $0x40,%edi
  10658b:	74 0d                	je     10659a <tqueue_remove+0x7a>
    {
        tcb_set_next(prev_pid, next_pid);
  10658d:	83 ec 08             	sub    $0x8,%esp
  106590:	50                   	push   %eax
  106591:	57                   	push   %edi
  106592:	e8 29 fc ff ff       	call   1061c0 <tcb_set_next>
  106597:	83 c4 10             	add    $0x10,%esp
    }

    tcb_set_next(pid, NUM_IDS);
  10659a:	83 ec 08             	sub    $0x8,%esp
  10659d:	6a 40                	push   $0x40
  10659f:	56                   	push   %esi
  1065a0:	e8 1b fc ff ff       	call   1061c0 <tcb_set_next>
    tcb_set_prev(pid, NUM_IDS);
  1065a5:	58                   	pop    %eax
  1065a6:	5a                   	pop    %edx
  1065a7:	6a 40                	push   $0x40
  1065a9:	56                   	push   %esi
  1065aa:	e8 d1 fb ff ff       	call   106180 <tcb_set_prev>
}
  1065af:	83 c4 2c             	add    $0x2c,%esp
  1065b2:	5b                   	pop    %ebx
  1065b3:	5e                   	pop    %esi
  1065b4:	5f                   	pop    %edi
  1065b5:	5d                   	pop    %ebp
  1065b6:	c3                   	ret
  1065b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1065be:	00 
  1065bf:	90                   	nop
  1065c0:	89 44 24 08          	mov    %eax,0x8(%esp)
        tqueue_set_tail(chid, prev_pid);
  1065c4:	83 ec 08             	sub    $0x8,%esp
  1065c7:	57                   	push   %edi
  1065c8:	ff 74 24 3c          	push   0x3c(%esp)
  1065cc:	e8 cf fd ff ff       	call   1063a0 <tqueue_set_tail>
  1065d1:	83 c4 10             	add    $0x10,%esp
  1065d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  1065d8:	eb 94                	jmp    10656e <tqueue_remove+0x4e>
  1065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        tqueue_set_head(chid, next_pid);
  1065e0:	83 ec 08             	sub    $0x8,%esp
  1065e3:	50                   	push   %eax
  1065e4:	89 44 24 18          	mov    %eax,0x18(%esp)
  1065e8:	ff 74 24 3c          	push   0x3c(%esp)
  1065ec:	e8 6f fd ff ff       	call   106360 <tqueue_set_head>
  1065f1:	83 c4 10             	add    $0x10,%esp
  1065f4:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1065f8:	e9 6b ff ff ff       	jmp    106568 <tqueue_remove+0x48>
  1065fd:	66 90                	xchg   %ax,%ax
  1065ff:	90                   	nop

00106600 <PTQueueInit_test1>:
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PTQueueInit_test1()
{
  106600:	57                   	push   %edi
  106601:	56                   	push   %esi
    unsigned int i;
    for (i = 0; i < NUM_IDS; i++) {
  106602:	31 f6                	xor    %esi,%esi
{
  106604:	53                   	push   %ebx
  106605:	e8 33 9d ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  10660a:	81 c3 ea 89 00 00    	add    $0x89ea,%ebx
  106610:	eb 1f                	jmp    106631 <PTQueueInit_test1+0x31>
  106612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
  106618:	83 ec 0c             	sub    $0xc,%esp
  10661b:	56                   	push   %esi
  10661c:	e8 5f fd ff ff       	call   106380 <tqueue_get_tail>
  106621:	83 c4 10             	add    $0x10,%esp
  106624:	83 f8 40             	cmp    $0x40,%eax
  106627:	75 19                	jne    106642 <PTQueueInit_test1+0x42>
    for (i = 0; i < NUM_IDS; i++) {
  106629:	83 c6 01             	add    $0x1,%esi
  10662c:	83 fe 40             	cmp    $0x40,%esi
  10662f:	74 4f                	je     106680 <PTQueueInit_test1+0x80>
        if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
  106631:	83 ec 0c             	sub    $0xc,%esp
  106634:	56                   	push   %esi
  106635:	e8 06 fd ff ff       	call   106340 <tqueue_get_head>
  10663a:	83 c4 10             	add    $0x10,%esp
  10663d:	83 f8 40             	cmp    $0x40,%eax
  106640:	74 d6                	je     106618 <PTQueueInit_test1+0x18>
            dprintf("test 1.1 failed (i = %d): "
  106642:	83 ec 0c             	sub    $0xc,%esp
  106645:	56                   	push   %esi
  106646:	e8 35 fd ff ff       	call   106380 <tqueue_get_tail>
  10664b:	89 34 24             	mov    %esi,(%esp)
  10664e:	89 c7                	mov    %eax,%edi
  106650:	e8 eb fc ff ff       	call   106340 <tqueue_get_head>
  106655:	5a                   	pop    %edx
  106656:	59                   	pop    %ecx
  106657:	6a 40                	push   $0x40
  106659:	57                   	push   %edi
  10665a:	6a 40                	push   $0x40
  10665c:	50                   	push   %eax
  10665d:	8d 83 ec 9e ff ff    	lea    -0x6114(%ebx),%eax
  106663:	56                   	push   %esi
  106664:	50                   	push   %eax
  106665:	e8 38 c5 ff ff       	call   102ba2 <dprintf>
                    "(%d != %d || %d != %d)\n",
                    i, tqueue_get_head(i), NUM_IDS,
                    tqueue_get_tail(i), NUM_IDS);
            return 1;
  10666a:	83 c4 20             	add    $0x20,%esp
  10666d:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  106672:	5b                   	pop    %ebx
  106673:	5e                   	pop    %esi
  106674:	5f                   	pop    %edi
  106675:	c3                   	ret
  106676:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10667d:	00 
  10667e:	66 90                	xchg   %ax,%ax
    dprintf("test 1 passed.\n");
  106680:	83 ec 0c             	sub    $0xc,%esp
  106683:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  106689:	50                   	push   %eax
  10668a:	e8 13 c5 ff ff       	call   102ba2 <dprintf>
    return 0;
  10668f:	83 c4 10             	add    $0x10,%esp
  106692:	31 c0                	xor    %eax,%eax
}
  106694:	5b                   	pop    %ebx
  106695:	5e                   	pop    %esi
  106696:	5f                   	pop    %edi
  106697:	c3                   	ret
  106698:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10669f:	00 

001066a0 <PTQueueInit_test2>:

int PTQueueInit_test2()
{
  1066a0:	55                   	push   %ebp
  1066a1:	57                   	push   %edi
  1066a2:	56                   	push   %esi
  1066a3:	53                   	push   %ebx
  1066a4:	e8 94 9c ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1066a9:	81 c3 4b 89 00 00    	add    $0x894b,%ebx
  1066af:	83 ec 24             	sub    $0x24,%esp
    unsigned int pid;
    tqueue_enqueue(0, 2);
  1066b2:	6a 02                	push   $0x2
  1066b4:	6a 00                	push   $0x0
  1066b6:	e8 75 fd ff ff       	call   106430 <tqueue_enqueue>
    tqueue_enqueue(0, 3);
  1066bb:	5a                   	pop    %edx
  1066bc:	59                   	pop    %ecx
  1066bd:	6a 03                	push   $0x3
  1066bf:	6a 00                	push   $0x0
  1066c1:	e8 6a fd ff ff       	call   106430 <tqueue_enqueue>
    tqueue_enqueue(0, 4);
  1066c6:	5e                   	pop    %esi
  1066c7:	5f                   	pop    %edi
  1066c8:	6a 04                	push   $0x4
  1066ca:	6a 00                	push   $0x0
  1066cc:	e8 5f fd ff ff       	call   106430 <tqueue_enqueue>
    if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 3) {
  1066d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1066d8:	e8 83 fa ff ff       	call   106160 <tcb_get_prev>
  1066dd:	83 c4 10             	add    $0x10,%esp
  1066e0:	83 f8 40             	cmp    $0x40,%eax
  1066e3:	75 12                	jne    1066f7 <PTQueueInit_test2+0x57>
  1066e5:	83 ec 0c             	sub    $0xc,%esp
  1066e8:	6a 02                	push   $0x2
  1066ea:	e8 b1 fa ff ff       	call   1061a0 <tcb_get_next>
  1066ef:	83 c4 10             	add    $0x10,%esp
  1066f2:	83 f8 03             	cmp    $0x3,%eax
  1066f5:	74 39                	je     106730 <PTQueueInit_test2+0x90>
        dprintf("test 2.1 failed: (%d != %d || %d != 3)\n",
  1066f7:	83 ec 0c             	sub    $0xc,%esp
  1066fa:	6a 02                	push   $0x2
  1066fc:	e8 9f fa ff ff       	call   1061a0 <tcb_get_next>
  106701:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  106708:	89 c6                	mov    %eax,%esi
  10670a:	e8 51 fa ff ff       	call   106160 <tcb_get_prev>
  10670f:	56                   	push   %esi
  106710:	6a 40                	push   $0x40
  106712:	50                   	push   %eax
  106713:	8d 83 20 9f ff ff    	lea    -0x60e0(%ebx),%eax
  106719:	50                   	push   %eax
  10671a:	e8 83 c4 ff ff       	call   102ba2 <dprintf>
                tcb_get_prev(2), NUM_IDS, tcb_get_next(2));
        return 1;
  10671f:	83 c4 20             	add    $0x20,%esp
  106722:	b8 01 00 00 00       	mov    $0x1,%eax
                tqueue_get_head(0), tqueue_get_tail(0));
        return 1;
    }
    dprintf("test 2 passed.\n");
    return 0;
}
  106727:	83 c4 1c             	add    $0x1c,%esp
  10672a:	5b                   	pop    %ebx
  10672b:	5e                   	pop    %esi
  10672c:	5f                   	pop    %edi
  10672d:	5d                   	pop    %ebp
  10672e:	c3                   	ret
  10672f:	90                   	nop
    if (tcb_get_prev(3) != 2 || tcb_get_next(3) != 4) {
  106730:	83 ec 0c             	sub    $0xc,%esp
  106733:	6a 03                	push   $0x3
  106735:	e8 26 fa ff ff       	call   106160 <tcb_get_prev>
  10673a:	83 c4 10             	add    $0x10,%esp
  10673d:	83 f8 02             	cmp    $0x2,%eax
  106740:	75 12                	jne    106754 <PTQueueInit_test2+0xb4>
  106742:	83 ec 0c             	sub    $0xc,%esp
  106745:	6a 03                	push   $0x3
  106747:	e8 54 fa ff ff       	call   1061a0 <tcb_get_next>
  10674c:	83 c4 10             	add    $0x10,%esp
  10674f:	83 f8 04             	cmp    $0x4,%eax
  106752:	74 34                	je     106788 <PTQueueInit_test2+0xe8>
        dprintf("test 2.2 failed: (%d != 2 || %d != 4)\n",
  106754:	83 ec 0c             	sub    $0xc,%esp
  106757:	6a 03                	push   $0x3
  106759:	e8 42 fa ff ff       	call   1061a0 <tcb_get_next>
  10675e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  106765:	89 c6                	mov    %eax,%esi
  106767:	e8 f4 f9 ff ff       	call   106160 <tcb_get_prev>
  10676c:	83 c4 0c             	add    $0xc,%esp
  10676f:	56                   	push   %esi
  106770:	50                   	push   %eax
  106771:	8d 83 48 9f ff ff    	lea    -0x60b8(%ebx),%eax
  106777:	50                   	push   %eax
  106778:	e8 25 c4 ff ff       	call   102ba2 <dprintf>
        return 1;
  10677d:	83 c4 10             	add    $0x10,%esp
  106780:	eb a0                	jmp    106722 <PTQueueInit_test2+0x82>
  106782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (tcb_get_prev(4) != 3 || tcb_get_next(4) != NUM_IDS) {
  106788:	83 ec 0c             	sub    $0xc,%esp
  10678b:	6a 04                	push   $0x4
  10678d:	e8 ce f9 ff ff       	call   106160 <tcb_get_prev>
  106792:	83 c4 10             	add    $0x10,%esp
  106795:	83 f8 03             	cmp    $0x3,%eax
  106798:	75 12                	jne    1067ac <PTQueueInit_test2+0x10c>
  10679a:	83 ec 0c             	sub    $0xc,%esp
  10679d:	6a 04                	push   $0x4
  10679f:	e8 fc f9 ff ff       	call   1061a0 <tcb_get_next>
  1067a4:	83 c4 10             	add    $0x10,%esp
  1067a7:	83 f8 40             	cmp    $0x40,%eax
  1067aa:	74 30                	je     1067dc <PTQueueInit_test2+0x13c>
        dprintf("test 2.3 failed: (%d != 3 || %d != %d)\n",
  1067ac:	83 ec 0c             	sub    $0xc,%esp
  1067af:	6a 04                	push   $0x4
  1067b1:	e8 ea f9 ff ff       	call   1061a0 <tcb_get_next>
  1067b6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1067bd:	89 c6                	mov    %eax,%esi
  1067bf:	e8 9c f9 ff ff       	call   106160 <tcb_get_prev>
  1067c4:	6a 40                	push   $0x40
  1067c6:	56                   	push   %esi
  1067c7:	50                   	push   %eax
  1067c8:	8d 83 70 9f ff ff    	lea    -0x6090(%ebx),%eax
  1067ce:	50                   	push   %eax
  1067cf:	e8 ce c3 ff ff       	call   102ba2 <dprintf>
        return 1;
  1067d4:	83 c4 20             	add    $0x20,%esp
  1067d7:	e9 46 ff ff ff       	jmp    106722 <PTQueueInit_test2+0x82>
    tqueue_remove(0, 3);
  1067dc:	83 ec 08             	sub    $0x8,%esp
  1067df:	6a 03                	push   $0x3
  1067e1:	6a 00                	push   $0x0
  1067e3:	e8 38 fd ff ff       	call   106520 <tqueue_remove>
    if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 4) {
  1067e8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1067ef:	e8 6c f9 ff ff       	call   106160 <tcb_get_prev>
  1067f4:	83 c4 10             	add    $0x10,%esp
  1067f7:	83 f8 40             	cmp    $0x40,%eax
  1067fa:	75 12                	jne    10680e <PTQueueInit_test2+0x16e>
  1067fc:	83 ec 0c             	sub    $0xc,%esp
  1067ff:	6a 02                	push   $0x2
  106801:	e8 9a f9 ff ff       	call   1061a0 <tcb_get_next>
  106806:	83 c4 10             	add    $0x10,%esp
  106809:	83 f8 04             	cmp    $0x4,%eax
  10680c:	74 30                	je     10683e <PTQueueInit_test2+0x19e>
        dprintf("test 2.4 failed: (%d != %d || %d != 4)\n",
  10680e:	83 ec 0c             	sub    $0xc,%esp
  106811:	6a 02                	push   $0x2
  106813:	e8 88 f9 ff ff       	call   1061a0 <tcb_get_next>
  106818:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10681f:	89 c6                	mov    %eax,%esi
  106821:	e8 3a f9 ff ff       	call   106160 <tcb_get_prev>
  106826:	56                   	push   %esi
  106827:	6a 40                	push   $0x40
  106829:	50                   	push   %eax
  10682a:	8d 83 98 9f ff ff    	lea    -0x6068(%ebx),%eax
  106830:	50                   	push   %eax
  106831:	e8 6c c3 ff ff       	call   102ba2 <dprintf>
        return 1;
  106836:	83 c4 20             	add    $0x20,%esp
  106839:	e9 e4 fe ff ff       	jmp    106722 <PTQueueInit_test2+0x82>
    if (tcb_get_prev(3) != NUM_IDS || tcb_get_next(3) != NUM_IDS) {
  10683e:	83 ec 0c             	sub    $0xc,%esp
  106841:	6a 03                	push   $0x3
  106843:	e8 18 f9 ff ff       	call   106160 <tcb_get_prev>
  106848:	83 c4 10             	add    $0x10,%esp
  10684b:	83 f8 40             	cmp    $0x40,%eax
  10684e:	75 12                	jne    106862 <PTQueueInit_test2+0x1c2>
  106850:	83 ec 0c             	sub    $0xc,%esp
  106853:	6a 03                	push   $0x3
  106855:	e8 46 f9 ff ff       	call   1061a0 <tcb_get_next>
  10685a:	83 c4 10             	add    $0x10,%esp
  10685d:	83 f8 40             	cmp    $0x40,%eax
  106860:	74 37                	je     106899 <PTQueueInit_test2+0x1f9>
        dprintf("test 2.5 failed: (%d != %d || %d != %d)\n",
  106862:	83 ec 0c             	sub    $0xc,%esp
  106865:	6a 03                	push   $0x3
  106867:	e8 34 f9 ff ff       	call   1061a0 <tcb_get_next>
  10686c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  106873:	89 c6                	mov    %eax,%esi
  106875:	e8 e6 f8 ff ff       	call   106160 <tcb_get_prev>
  10687a:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  106881:	56                   	push   %esi
  106882:	6a 40                	push   $0x40
  106884:	50                   	push   %eax
  106885:	8d 83 c0 9f ff ff    	lea    -0x6040(%ebx),%eax
  10688b:	50                   	push   %eax
  10688c:	e8 11 c3 ff ff       	call   102ba2 <dprintf>
        return 1;
  106891:	83 c4 20             	add    $0x20,%esp
  106894:	e9 89 fe ff ff       	jmp    106722 <PTQueueInit_test2+0x82>
    if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
  106899:	83 ec 0c             	sub    $0xc,%esp
  10689c:	6a 04                	push   $0x4
  10689e:	e8 bd f8 ff ff       	call   106160 <tcb_get_prev>
  1068a3:	83 c4 10             	add    $0x10,%esp
  1068a6:	83 f8 02             	cmp    $0x2,%eax
  1068a9:	75 12                	jne    1068bd <PTQueueInit_test2+0x21d>
  1068ab:	83 ec 0c             	sub    $0xc,%esp
  1068ae:	6a 04                	push   $0x4
  1068b0:	e8 eb f8 ff ff       	call   1061a0 <tcb_get_next>
  1068b5:	83 c4 10             	add    $0x10,%esp
  1068b8:	83 f8 40             	cmp    $0x40,%eax
  1068bb:	74 30                	je     1068ed <PTQueueInit_test2+0x24d>
        dprintf("test 2.6 failed: (%d != 2 || %d != %d)\n",
  1068bd:	83 ec 0c             	sub    $0xc,%esp
  1068c0:	6a 04                	push   $0x4
  1068c2:	e8 d9 f8 ff ff       	call   1061a0 <tcb_get_next>
  1068c7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1068ce:	89 c6                	mov    %eax,%esi
  1068d0:	e8 8b f8 ff ff       	call   106160 <tcb_get_prev>
  1068d5:	6a 40                	push   $0x40
  1068d7:	56                   	push   %esi
  1068d8:	50                   	push   %eax
  1068d9:	8d 83 ec 9f ff ff    	lea    -0x6014(%ebx),%eax
  1068df:	50                   	push   %eax
  1068e0:	e8 bd c2 ff ff       	call   102ba2 <dprintf>
        return 1;
  1068e5:	83 c4 20             	add    $0x20,%esp
  1068e8:	e9 35 fe ff ff       	jmp    106722 <PTQueueInit_test2+0x82>
    pid = tqueue_dequeue(0);
  1068ed:	83 ec 0c             	sub    $0xc,%esp
  1068f0:	6a 00                	push   $0x0
  1068f2:	e8 a9 fb ff ff       	call   1064a0 <tqueue_dequeue>
    if (pid != 2 || tcb_get_prev(pid) != NUM_IDS
  1068f7:	83 c4 10             	add    $0x10,%esp
    pid = tqueue_dequeue(0);
  1068fa:	89 c6                	mov    %eax,%esi
    if (pid != 2 || tcb_get_prev(pid) != NUM_IDS
  1068fc:	83 f8 02             	cmp    $0x2,%eax
  1068ff:	75 12                	jne    106913 <PTQueueInit_test2+0x273>
  106901:	83 ec 0c             	sub    $0xc,%esp
  106904:	6a 02                	push   $0x2
  106906:	e8 55 f8 ff ff       	call   106160 <tcb_get_prev>
  10690b:	83 c4 10             	add    $0x10,%esp
  10690e:	83 f8 40             	cmp    $0x40,%eax
  106911:	74 4d                	je     106960 <PTQueueInit_test2+0x2c0>
        dprintf("test 2.7 failed:\n"
  106913:	83 ec 0c             	sub    $0xc,%esp
  106916:	6a 00                	push   $0x0
  106918:	e8 63 fa ff ff       	call   106380 <tqueue_get_tail>
  10691d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  106921:	31 c0                	xor    %eax,%eax
  106923:	89 04 24             	mov    %eax,(%esp)
  106926:	e8 15 fa ff ff       	call   106340 <tqueue_get_head>
  10692b:	89 34 24             	mov    %esi,(%esp)
  10692e:	89 c5                	mov    %eax,%ebp
  106930:	e8 6b f8 ff ff       	call   1061a0 <tcb_get_next>
  106935:	89 34 24             	mov    %esi,(%esp)
  106938:	89 c7                	mov    %eax,%edi
  10693a:	e8 21 f8 ff ff       	call   106160 <tcb_get_prev>
  10693f:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  106943:	52                   	push   %edx
  106944:	55                   	push   %ebp
  106945:	6a 40                	push   $0x40
  106947:	57                   	push   %edi
  106948:	6a 40                	push   $0x40
  10694a:	50                   	push   %eax
  10694b:	8d 83 14 a0 ff ff    	lea    -0x5fec(%ebx),%eax
  106951:	56                   	push   %esi
  106952:	50                   	push   %eax
  106953:	e8 4a c2 ff ff       	call   102ba2 <dprintf>
        return 1;
  106958:	83 c4 30             	add    $0x30,%esp
  10695b:	e9 c2 fd ff ff       	jmp    106722 <PTQueueInit_test2+0x82>
        || tcb_get_next(pid) != NUM_IDS || tqueue_get_head(0) != 4
  106960:	83 ec 0c             	sub    $0xc,%esp
  106963:	6a 02                	push   $0x2
  106965:	e8 36 f8 ff ff       	call   1061a0 <tcb_get_next>
  10696a:	83 c4 10             	add    $0x10,%esp
  10696d:	83 f8 40             	cmp    $0x40,%eax
  106970:	75 a1                	jne    106913 <PTQueueInit_test2+0x273>
  106972:	83 ec 0c             	sub    $0xc,%esp
  106975:	6a 00                	push   $0x0
  106977:	e8 c4 f9 ff ff       	call   106340 <tqueue_get_head>
  10697c:	83 c4 10             	add    $0x10,%esp
  10697f:	83 f8 04             	cmp    $0x4,%eax
  106982:	75 8f                	jne    106913 <PTQueueInit_test2+0x273>
        || tqueue_get_tail(0) != 4) {
  106984:	83 ec 0c             	sub    $0xc,%esp
  106987:	6a 00                	push   $0x0
  106989:	e8 f2 f9 ff ff       	call   106380 <tqueue_get_tail>
  10698e:	83 c4 10             	add    $0x10,%esp
  106991:	83 f8 04             	cmp    $0x4,%eax
  106994:	0f 85 79 ff ff ff    	jne    106913 <PTQueueInit_test2+0x273>
    dprintf("test 2 passed.\n");
  10699a:	83 ec 0c             	sub    $0xc,%esp
  10699d:	8d 83 bd 93 ff ff    	lea    -0x6c43(%ebx),%eax
  1069a3:	50                   	push   %eax
  1069a4:	e8 f9 c1 ff ff       	call   102ba2 <dprintf>
    return 0;
  1069a9:	83 c4 10             	add    $0x10,%esp
  1069ac:	31 c0                	xor    %eax,%eax
  1069ae:	e9 74 fd ff ff       	jmp    106727 <PTQueueInit_test2+0x87>
  1069b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1069ba:	00 
  1069bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001069c0 <PTQueueInit_test_own>:
int PTQueueInit_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  1069c0:	31 c0                	xor    %eax,%eax
  1069c2:	c3                   	ret
  1069c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1069ca:	00 
  1069cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001069d0 <test_PTQueueInit>:

int test_PTQueueInit()
{
  1069d0:	53                   	push   %ebx
  1069d1:	83 ec 08             	sub    $0x8,%esp
    return PTQueueInit_test1() + PTQueueInit_test2() + PTQueueInit_test_own();
  1069d4:	e8 27 fc ff ff       	call   106600 <PTQueueInit_test1>
  1069d9:	89 c3                	mov    %eax,%ebx
  1069db:	e8 c0 fc ff ff       	call   1066a0 <PTQueueInit_test2>
}
  1069e0:	83 c4 08             	add    $0x8,%esp
    return PTQueueInit_test1() + PTQueueInit_test2() + PTQueueInit_test_own();
  1069e3:	01 d8                	add    %ebx,%eax
}
  1069e5:	5b                   	pop    %ebx
  1069e6:	c3                   	ret
  1069e7:	66 90                	xchg   %ax,%ax
  1069e9:	66 90                	xchg   %ax,%ax
  1069eb:	66 90                	xchg   %ax,%ax
  1069ed:	66 90                	xchg   %ax,%ax
  1069ef:	90                   	nop

001069f0 <get_curid>:
unsigned int CURID;

unsigned int get_curid(void)
{
    return CURID;
  1069f0:	e8 35 a4 ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  1069f5:	05 ff 85 00 00       	add    $0x85ff,%eax
  1069fa:	8b 80 14 1b cb 00    	mov    0xcb1b14(%eax),%eax
}
  106a00:	c3                   	ret
  106a01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106a08:	00 
  106a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106a10 <set_curid>:

void set_curid(unsigned int curid)
{
    CURID = curid;
  106a10:	e8 15 a4 ff ff       	call   100e2a <__x86.get_pc_thunk.ax>
  106a15:	05 df 85 00 00       	add    $0x85df,%eax
  106a1a:	8b 54 24 04          	mov    0x4(%esp),%edx
  106a1e:	89 90 14 1b cb 00    	mov    %edx,0xcb1b14(%eax)
}
  106a24:	c3                   	ret
  106a25:	66 90                	xchg   %ax,%ax
  106a27:	66 90                	xchg   %ax,%ax
  106a29:	66 90                	xchg   %ax,%ax
  106a2b:	66 90                	xchg   %ax,%ax
  106a2d:	66 90                	xchg   %ax,%ax
  106a2f:	90                   	nop

00106a30 <thread_init>:
#include <lib/thread.h>

#include "import.h"

void thread_init(unsigned int mbi_addr)
{
  106a30:	53                   	push   %ebx
  106a31:	e8 07 99 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106a36:	81 c3 be 85 00 00    	add    $0x85be,%ebx
  106a3c:	83 ec 14             	sub    $0x14,%esp
	tqueue_init(mbi_addr);
  106a3f:	ff 74 24 1c          	push   0x1c(%esp)
  106a43:	e8 a8 f9 ff ff       	call   1063f0 <tqueue_init>
	set_curid(0);
  106a48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106a4f:	e8 bc ff ff ff       	call   106a10 <set_curid>
	tcb_set_state(0, TSTATE_RUN);
  106a54:	58                   	pop    %eax
  106a55:	5a                   	pop    %edx
  106a56:	6a 01                	push   $0x1
  106a58:	6a 00                	push   $0x0
  106a5a:	e8 e1 f6 ff ff       	call   106140 <tcb_set_state>
}
  106a5f:	83 c4 18             	add    $0x18,%esp
  106a62:	5b                   	pop    %ebx
  106a63:	c3                   	ret
  106a64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106a6b:	00 
  106a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106a70 <thread_spawn>:
 * Allocates new child thread context, set the state of the new child thread
 * as ready, and pushes it to the ready queue.
 * It returns the child thread id.
 */
unsigned int thread_spawn(void *entry, unsigned int id, unsigned int quota)
{
  106a70:	56                   	push   %esi
  106a71:	53                   	push   %ebx
  106a72:	e8 c6 98 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106a77:	81 c3 7d 85 00 00    	add    $0x857d,%ebx
  106a7d:	83 ec 08             	sub    $0x8,%esp
  // TODO
  int child = kctx_new(entry, id, quota);
  106a80:	ff 74 24 1c          	push   0x1c(%esp)
  106a84:	ff 74 24 1c          	push   0x1c(%esp)
  106a88:	ff 74 24 1c          	push   0x1c(%esp)
  106a8c:	e8 6f f5 ff ff       	call   106000 <kctx_new>
  106a91:	89 c6                	mov    %eax,%esi
  tcb_set_state(child, TSTATE_READY);
  106a93:	58                   	pop    %eax
  106a94:	5a                   	pop    %edx
  106a95:	6a 00                	push   $0x0
  106a97:	56                   	push   %esi
  106a98:	e8 a3 f6 ff ff       	call   106140 <tcb_set_state>
  tqueue_enqueue(NUM_IDS, child);
  106a9d:	59                   	pop    %ecx
  106a9e:	58                   	pop    %eax
  106a9f:	56                   	push   %esi
  106aa0:	6a 40                	push   $0x40
  106aa2:	e8 89 f9 ff ff       	call   106430 <tqueue_enqueue>
  return child;
}
  106aa7:	83 c4 14             	add    $0x14,%esp
  106aaa:	89 f0                	mov    %esi,%eax
  106aac:	5b                   	pop    %ebx
  106aad:	5e                   	pop    %esi
  106aae:	c3                   	ret
  106aaf:	90                   	nop

00106ab0 <thread_yield>:
 * current thread id, then switches to the new kernel context.
 * Hint: if you are the only thread that is ready to run,
 * do you need to switch to yourself?
 */
void thread_yield(void)
{
  106ab0:	57                   	push   %edi
  106ab1:	56                   	push   %esi
  106ab2:	53                   	push   %ebx
  106ab3:	e8 85 98 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106ab8:	81 c3 3c 85 00 00    	add    $0x853c,%ebx
  // TODO
  int curid = get_curid();
  106abe:	e8 2d ff ff ff       	call   1069f0 <get_curid>
  int next_ready = tqueue_dequeue(NUM_IDS);
  106ac3:	83 ec 0c             	sub    $0xc,%esp
  106ac6:	6a 40                	push   $0x40
  int curid = get_curid();
  106ac8:	89 c7                	mov    %eax,%edi
  int next_ready = tqueue_dequeue(NUM_IDS);
  106aca:	e8 d1 f9 ff ff       	call   1064a0 <tqueue_dequeue>
  if (next_ready == NUM_IDS) {
  106acf:	83 c4 10             	add    $0x10,%esp
  106ad2:	83 f8 40             	cmp    $0x40,%eax
  106ad5:	74 35                	je     106b0c <thread_yield+0x5c>
    //no ready threads then return
    return;
  }
  //set current running thread's state to ready
  tcb_set_state(curid, TSTATE_READY);
  106ad7:	83 ec 08             	sub    $0x8,%esp
  106ada:	89 c6                	mov    %eax,%esi
  106adc:	6a 00                	push   $0x0
  106ade:	57                   	push   %edi
  106adf:	e8 5c f6 ff ff       	call   106140 <tcb_set_state>
  //push the current thread to ready queue
  tqueue_enqueue(NUM_IDS, curid);
  106ae4:	58                   	pop    %eax
  106ae5:	5a                   	pop    %edx
  106ae6:	57                   	push   %edi
  106ae7:	6a 40                	push   $0x40
  106ae9:	e8 42 f9 ff ff       	call   106430 <tqueue_enqueue>
  
  //set the state of next ready thread
  tcb_set_state(next_ready, TSTATE_RUN);
  106aee:	59                   	pop    %ecx
  106aef:	58                   	pop    %eax
  106af0:	6a 01                	push   $0x1
  106af2:	56                   	push   %esi
  106af3:	e8 48 f6 ff ff       	call   106140 <tcb_set_state>
  
  //set current thread id, switch context
  set_curid(next_ready);
  106af8:	89 34 24             	mov    %esi,(%esp)
  106afb:	e8 10 ff ff ff       	call   106a10 <set_curid>
  kctx_switch(curid, next_ready); 
  106b00:	58                   	pop    %eax
  106b01:	5a                   	pop    %edx
  106b02:	56                   	push   %esi
  106b03:	57                   	push   %edi
  106b04:	e8 87 f4 ff ff       	call   105f90 <kctx_switch>
  106b09:	83 c4 10             	add    $0x10,%esp
  106b0c:	5b                   	pop    %ebx
  106b0d:	5e                   	pop    %esi
  106b0e:	5f                   	pop    %edi
  106b0f:	c3                   	ret

00106b10 <PThread_test1>:
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PThread_test1()
{
  106b10:	56                   	push   %esi
  106b11:	53                   	push   %ebx
  106b12:	e8 26 98 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106b17:	81 c3 dd 84 00 00    	add    $0x84dd,%ebx
  106b1d:	83 ec 08             	sub    $0x8,%esp
    void *dummy_addr = (void *) 0;
    unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  106b20:	68 e8 03 00 00       	push   $0x3e8
  106b25:	6a 00                	push   $0x0
  106b27:	6a 00                	push   $0x0
  106b29:	e8 42 ff ff ff       	call   106a70 <thread_spawn>
    if (tcb_get_state(chid) != TSTATE_READY) {
  106b2e:	89 04 24             	mov    %eax,(%esp)
    unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  106b31:	89 c6                	mov    %eax,%esi
    if (tcb_get_state(chid) != TSTATE_READY) {
  106b33:	e8 e8 f5 ff ff       	call   106120 <tcb_get_state>
  106b38:	83 c4 10             	add    $0x10,%esp
  106b3b:	85 c0                	test   %eax,%eax
  106b3d:	75 61                	jne    106ba0 <PThread_test1+0x90>
        dprintf("test 1.1 failed: (%d != %d)\n",
                tcb_get_state(chid), TSTATE_READY);
        return 1;
    }
    if (tqueue_get_tail(NUM_IDS) != chid) {
  106b3f:	83 ec 0c             	sub    $0xc,%esp
  106b42:	6a 40                	push   $0x40
  106b44:	e8 37 f8 ff ff       	call   106380 <tqueue_get_tail>
  106b49:	83 c4 10             	add    $0x10,%esp
  106b4c:	39 f0                	cmp    %esi,%eax
  106b4e:	74 30                	je     106b80 <PThread_test1+0x70>
        dprintf("test 1.2 failed: (%d != %d)\n",
  106b50:	83 ec 0c             	sub    $0xc,%esp
  106b53:	6a 40                	push   $0x40
  106b55:	e8 26 f8 ff ff       	call   106380 <tqueue_get_tail>
  106b5a:	83 c4 0c             	add    $0xc,%esp
  106b5d:	56                   	push   %esi
  106b5e:	50                   	push   %eax
  106b5f:	8d 83 ec 94 ff ff    	lea    -0x6b14(%ebx),%eax
  106b65:	50                   	push   %eax
  106b66:	e8 37 c0 ff ff       	call   102ba2 <dprintf>
                tqueue_get_tail(NUM_IDS), chid);
        return 1;
  106b6b:	83 c4 10             	add    $0x10,%esp
    }
    dprintf("test 1 passed.\n");
    return 0;
}
  106b6e:	83 c4 04             	add    $0x4,%esp
        return 1;
  106b71:	b8 01 00 00 00       	mov    $0x1,%eax
}
  106b76:	5b                   	pop    %ebx
  106b77:	5e                   	pop    %esi
  106b78:	c3                   	ret
  106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dprintf("test 1 passed.\n");
  106b80:	83 ec 0c             	sub    $0xc,%esp
  106b83:	8d 83 ad 93 ff ff    	lea    -0x6c53(%ebx),%eax
  106b89:	50                   	push   %eax
  106b8a:	e8 13 c0 ff ff       	call   102ba2 <dprintf>
    return 0;
  106b8f:	83 c4 10             	add    $0x10,%esp
  106b92:	31 c0                	xor    %eax,%eax
}
  106b94:	83 c4 04             	add    $0x4,%esp
  106b97:	5b                   	pop    %ebx
  106b98:	5e                   	pop    %esi
  106b99:	c3                   	ret
  106b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        dprintf("test 1.1 failed: (%d != %d)\n",
  106ba0:	83 ec 0c             	sub    $0xc,%esp
  106ba3:	56                   	push   %esi
  106ba4:	e8 77 f5 ff ff       	call   106120 <tcb_get_state>
  106ba9:	83 c4 0c             	add    $0xc,%esp
  106bac:	6a 00                	push   $0x0
  106bae:	50                   	push   %eax
  106baf:	8d 83 cf 94 ff ff    	lea    -0x6b31(%ebx),%eax
  106bb5:	50                   	push   %eax
  106bb6:	e8 e7 bf ff ff       	call   102ba2 <dprintf>
        return 1;
  106bbb:	83 c4 10             	add    $0x10,%esp
  106bbe:	eb ae                	jmp    106b6e <PThread_test1+0x5e>

00106bc0 <PThread_test_own>:
int PThread_test_own()
{
    // TODO (optional)
    // dprintf("own test passed.\n");
    return 0;
}
  106bc0:	31 c0                	xor    %eax,%eax
  106bc2:	c3                   	ret
  106bc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106bca:	00 
  106bcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00106bd0 <test_PThread>:

int test_PThread()
{
    return PThread_test1() + PThread_test_own();
  106bd0:	e9 3b ff ff ff       	jmp    106b10 <PThread_test1>
  106bd5:	66 90                	xchg   %ax,%ax
  106bd7:	66 90                	xchg   %ax,%ax
  106bd9:	66 90                	xchg   %ax,%ax
  106bdb:	66 90                	xchg   %ax,%ax
  106bdd:	66 90                	xchg   %ax,%ax
  106bdf:	90                   	nop

00106be0 <proc_start_user>:

extern tf_t uctx_pool[NUM_IDS];
extern char STACK_LOC[NUM_IDS][PAGESIZE];

void proc_start_user(void)
{
  106be0:	56                   	push   %esi
  106be1:	53                   	push   %ebx
  106be2:	e8 56 97 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106be7:	81 c3 0d 84 00 00    	add    $0x840d,%ebx
  106bed:	83 ec 04             	sub    $0x4,%esp
    unsigned int cur_pid = get_curid();
  106bf0:	e8 fb fd ff ff       	call   1069f0 <get_curid>
    tss_switch(cur_pid);
  106bf5:	83 ec 0c             	sub    $0xc,%esp
  106bf8:	50                   	push   %eax
    unsigned int cur_pid = get_curid();
  106bf9:	89 c6                	mov    %eax,%esi
    tss_switch(cur_pid);
  106bfb:	e8 46 c4 ff ff       	call   103046 <tss_switch>
    set_pdir_base(cur_pid);
  106c00:	89 34 24             	mov    %esi,(%esp)

    trap_return((void *) &uctx_pool[cur_pid]);
  106c03:	6b f6 44             	imul   $0x44,%esi,%esi
    set_pdir_base(cur_pid);
  106c06:	e8 b5 e2 ff ff       	call   104ec0 <set_pdir_base>
    trap_return((void *) &uctx_pool[cur_pid]);
  106c0b:	81 c6 20 0b dc 00    	add    $0xdc0b20,%esi
  106c11:	89 34 24             	mov    %esi,(%esp)
  106c14:	e8 e7 b9 ff ff       	call   102600 <trap_return>
}
  106c19:	83 c4 14             	add    $0x14,%esp
  106c1c:	5b                   	pop    %ebx
  106c1d:	5e                   	pop    %esi
  106c1e:	c3                   	ret
  106c1f:	90                   	nop

00106c20 <proc_create>:

unsigned int proc_create(void *elf_addr, unsigned int quota)
{
  106c20:	57                   	push   %edi
  106c21:	56                   	push   %esi
  106c22:	53                   	push   %ebx
  106c23:	e8 15 97 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106c28:	81 c3 cc 83 00 00    	add    $0x83cc,%ebx
    unsigned int pid, id;

    id = get_curid();
  106c2e:	e8 bd fd ff ff       	call   1069f0 <get_curid>
    pid = thread_spawn((void *) proc_start_user, id, quota);
  106c33:	83 ec 04             	sub    $0x4,%esp
  106c36:	ff 74 24 18          	push   0x18(%esp)
  106c3a:	50                   	push   %eax
  106c3b:	8d 83 ec 7b ff ff    	lea    -0x8414(%ebx),%eax
  106c41:	50                   	push   %eax
  106c42:	e8 29 fe ff ff       	call   106a70 <thread_spawn>

    if (pid != NUM_IDS) {
  106c47:	83 c4 10             	add    $0x10,%esp
    pid = thread_spawn((void *) proc_start_user, id, quota);
  106c4a:	89 c6                	mov    %eax,%esi
    if (pid != NUM_IDS) {
  106c4c:	83 f8 40             	cmp    $0x40,%eax
  106c4f:	74 58                	je     106ca9 <proc_create+0x89>
        elf_load(elf_addr, pid);
  106c51:	83 ec 08             	sub    $0x8,%esp

        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  106c54:	6b fe 44             	imul   $0x44,%esi,%edi
        elf_load(elf_addr, pid);
  106c57:	50                   	push   %eax
  106c58:	ff 74 24 1c          	push   0x1c(%esp)
  106c5c:	e8 bf cf ff ff       	call   103c20 <elf_load>
        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  106c61:	81 c7 20 0b dc 00    	add    $0xdc0b20,%edi
  106c67:	b8 23 00 00 00       	mov    $0x23,%eax
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  106c6c:	ba 23 00 00 00       	mov    $0x23,%edx
        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  106c71:	66 89 47 20          	mov    %ax,0x20(%edi)
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  106c75:	b9 1b 00 00 00       	mov    $0x1b,%ecx
        uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  106c7a:	b8 23 00 00 00       	mov    $0x23,%eax
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  106c7f:	66 89 57 24          	mov    %dx,0x24(%edi)
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  106c83:	66 89 4f 34          	mov    %cx,0x34(%edi)
        uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  106c87:	66 89 47 40          	mov    %ax,0x40(%edi)
        uctx_pool[pid].esp = VM_USERHI;
  106c8b:	c7 47 3c 00 00 00 f0 	movl   $0xf0000000,0x3c(%edi)
        uctx_pool[pid].eflags = FL_IF;
  106c92:	c7 47 38 00 02 00 00 	movl   $0x200,0x38(%edi)
        uctx_pool[pid].eip = elf_entry(elf_addr);
  106c99:	58                   	pop    %eax
  106c9a:	ff 74 24 1c          	push   0x1c(%esp)
  106c9e:	e8 83 d1 ff ff       	call   103e26 <elf_entry>
  106ca3:	83 c4 10             	add    $0x10,%esp
  106ca6:	89 47 30             	mov    %eax,0x30(%edi)
    }

    return pid;
}
  106ca9:	89 f0                	mov    %esi,%eax
  106cab:	5b                   	pop    %ebx
  106cac:	5e                   	pop    %esi
  106cad:	5f                   	pop    %edi
  106cae:	c3                   	ret
  106caf:	90                   	nop

00106cb0 <syscall_get_arg1>:
/**
 * Retrieves the system call arguments from uctx_pool that get
 * passed in from the current running process' system call.
 */
unsigned int syscall_get_arg1(void)
{
  106cb0:	53                   	push   %ebx
  106cb1:	e8 87 96 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106cb6:	81 c3 3e 83 00 00    	add    $0x833e,%ebx
  106cbc:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106cbf:	e8 2c fd ff ff       	call   1069f0 <get_curid>
    return uctx_pool[pid].regs.eax;
  106cc4:	6b c0 44             	imul   $0x44,%eax,%eax
  106cc7:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106ccd:	8b 40 1c             	mov    0x1c(%eax),%eax
}
  106cd0:	83 c4 08             	add    $0x8,%esp
  106cd3:	5b                   	pop    %ebx
  106cd4:	c3                   	ret
  106cd5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106cdc:	00 
  106cdd:	8d 76 00             	lea    0x0(%esi),%esi

00106ce0 <syscall_get_arg2>:

unsigned int syscall_get_arg2(void)
{
  106ce0:	53                   	push   %ebx
  106ce1:	e8 57 96 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106ce6:	81 c3 0e 83 00 00    	add    $0x830e,%ebx
  106cec:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106cef:	e8 fc fc ff ff       	call   1069f0 <get_curid>
    return uctx_pool[pid].regs.ebx;
  106cf4:	6b c0 44             	imul   $0x44,%eax,%eax
  106cf7:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106cfd:	8b 40 10             	mov    0x10(%eax),%eax
}
  106d00:	83 c4 08             	add    $0x8,%esp
  106d03:	5b                   	pop    %ebx
  106d04:	c3                   	ret
  106d05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106d0c:	00 
  106d0d:	8d 76 00             	lea    0x0(%esi),%esi

00106d10 <syscall_get_arg3>:

unsigned int syscall_get_arg3(void)
{
  106d10:	53                   	push   %ebx
  106d11:	e8 27 96 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106d16:	81 c3 de 82 00 00    	add    $0x82de,%ebx
  106d1c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106d1f:	e8 cc fc ff ff       	call   1069f0 <get_curid>
    return uctx_pool[pid].regs.ecx;
  106d24:	6b c0 44             	imul   $0x44,%eax,%eax
  106d27:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
    return 0;
}
  106d2d:	8b 40 18             	mov    0x18(%eax),%eax
  106d30:	83 c4 08             	add    $0x8,%esp
  106d33:	5b                   	pop    %ebx
  106d34:	c3                   	ret
  106d35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106d3c:	00 
  106d3d:	8d 76 00             	lea    0x0(%esi),%esi

00106d40 <syscall_get_arg4>:

unsigned int syscall_get_arg4(void)
{
  106d40:	53                   	push   %ebx
  106d41:	e8 f7 95 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106d46:	81 c3 ae 82 00 00    	add    $0x82ae,%ebx
  106d4c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106d4f:	e8 9c fc ff ff       	call   1069f0 <get_curid>
    return uctx_pool[pid].regs.edx;
  106d54:	6b c0 44             	imul   $0x44,%eax,%eax
  106d57:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106d5d:	8b 40 14             	mov    0x14(%eax),%eax
}
  106d60:	83 c4 08             	add    $0x8,%esp
  106d63:	5b                   	pop    %ebx
  106d64:	c3                   	ret
  106d65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106d6c:	00 
  106d6d:	8d 76 00             	lea    0x0(%esi),%esi

00106d70 <syscall_get_arg5>:

unsigned int syscall_get_arg5(void)
{
  106d70:	53                   	push   %ebx
  106d71:	e8 c7 95 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106d76:	81 c3 7e 82 00 00    	add    $0x827e,%ebx
  106d7c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106d7f:	e8 6c fc ff ff       	call   1069f0 <get_curid>
    return uctx_pool[pid].regs.esi;
  106d84:	6b c0 44             	imul   $0x44,%eax,%eax
  106d87:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106d8d:	8b 40 04             	mov    0x4(%eax),%eax
}
  106d90:	83 c4 08             	add    $0x8,%esp
  106d93:	5b                   	pop    %ebx
  106d94:	c3                   	ret
  106d95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106d9c:	00 
  106d9d:	8d 76 00             	lea    0x0(%esi),%esi

00106da0 <syscall_get_arg6>:

unsigned int syscall_get_arg6(void)
{
  106da0:	53                   	push   %ebx
  106da1:	e8 97 95 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106da6:	81 c3 4e 82 00 00    	add    $0x824e,%ebx
  106dac:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106daf:	e8 3c fc ff ff       	call   1069f0 <get_curid>
    return uctx_pool[pid].regs.edi;
  106db4:	6b c0 44             	imul   $0x44,%eax,%eax
  106db7:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106dbd:	8b 00                	mov    (%eax),%eax
}
  106dbf:	83 c4 08             	add    $0x8,%esp
  106dc2:	5b                   	pop    %ebx
  106dc3:	c3                   	ret
  106dc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  106dcb:	00 
  106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106dd0 <syscall_set_errno>:
/**
 * Sets the error number in uctx_pool that gets passed
 * to the current running process when we return to it.
 */
void syscall_set_errno(unsigned int errno)
{
  106dd0:	53                   	push   %ebx
  106dd1:	e8 67 95 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106dd6:	81 c3 1e 82 00 00    	add    $0x821e,%ebx
  106ddc:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106ddf:	e8 0c fc ff ff       	call   1069f0 <get_curid>
    uctx_pool[pid].regs.eax = errno;
  106de4:	8b 54 24 10          	mov    0x10(%esp),%edx
  106de8:	6b c0 44             	imul   $0x44,%eax,%eax
  106deb:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106df1:	89 50 1c             	mov    %edx,0x1c(%eax)
}
  106df4:	83 c4 08             	add    $0x8,%esp
  106df7:	5b                   	pop    %ebx
  106df8:	c3                   	ret
  106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106e00 <syscall_set_retval1>:
/**
 * Sets the return values in uctx_pool that get passed
 * to the current running process when we return to it.
 */
void syscall_set_retval1(unsigned int retval)
{
  106e00:	53                   	push   %ebx
  106e01:	e8 37 95 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106e06:	81 c3 ee 81 00 00    	add    $0x81ee,%ebx
  106e0c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106e0f:	e8 dc fb ff ff       	call   1069f0 <get_curid>
    uctx_pool[pid].regs.ebx = retval;
  106e14:	8b 54 24 10          	mov    0x10(%esp),%edx
  106e18:	6b c0 44             	imul   $0x44,%eax,%eax
  106e1b:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106e21:	89 50 10             	mov    %edx,0x10(%eax)
}
  106e24:	83 c4 08             	add    $0x8,%esp
  106e27:	5b                   	pop    %ebx
  106e28:	c3                   	ret
  106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106e30 <syscall_set_retval2>:

void syscall_set_retval2(unsigned int retval)
{
  106e30:	53                   	push   %ebx
  106e31:	e8 07 95 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106e36:	81 c3 be 81 00 00    	add    $0x81be,%ebx
  106e3c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106e3f:	e8 ac fb ff ff       	call   1069f0 <get_curid>
    uctx_pool[pid].regs.ecx = retval;
  106e44:	8b 54 24 10          	mov    0x10(%esp),%edx
  106e48:	6b c0 44             	imul   $0x44,%eax,%eax
  106e4b:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106e51:	89 50 18             	mov    %edx,0x18(%eax)
}
  106e54:	83 c4 08             	add    $0x8,%esp
  106e57:	5b                   	pop    %ebx
  106e58:	c3                   	ret
  106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106e60 <syscall_set_retval3>:

void syscall_set_retval3(unsigned int retval)
{
  106e60:	53                   	push   %ebx
  106e61:	e8 d7 94 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106e66:	81 c3 8e 81 00 00    	add    $0x818e,%ebx
  106e6c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106e6f:	e8 7c fb ff ff       	call   1069f0 <get_curid>
    uctx_pool[pid].regs.edx = retval;
  106e74:	8b 54 24 10          	mov    0x10(%esp),%edx
  106e78:	6b c0 44             	imul   $0x44,%eax,%eax
  106e7b:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106e81:	89 50 14             	mov    %edx,0x14(%eax)
}
  106e84:	83 c4 08             	add    $0x8,%esp
  106e87:	5b                   	pop    %ebx
  106e88:	c3                   	ret
  106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106e90 <syscall_set_retval4>:

void syscall_set_retval4(unsigned int retval)
{
  106e90:	53                   	push   %ebx
  106e91:	e8 a7 94 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106e96:	81 c3 5e 81 00 00    	add    $0x815e,%ebx
  106e9c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106e9f:	e8 4c fb ff ff       	call   1069f0 <get_curid>
    uctx_pool[pid].regs.esi = retval;
  106ea4:	8b 54 24 10          	mov    0x10(%esp),%edx
  106ea8:	6b c0 44             	imul   $0x44,%eax,%eax
  106eab:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106eb1:	89 50 04             	mov    %edx,0x4(%eax)
}
  106eb4:	83 c4 08             	add    $0x8,%esp
  106eb7:	5b                   	pop    %ebx
  106eb8:	c3                   	ret
  106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106ec0 <syscall_set_retval5>:

void syscall_set_retval5(unsigned int retval)
{
  106ec0:	53                   	push   %ebx
  106ec1:	e8 77 94 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106ec6:	81 c3 2e 81 00 00    	add    $0x812e,%ebx
  106ecc:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int pid;
    pid = get_curid();
  106ecf:	e8 1c fb ff ff       	call   1069f0 <get_curid>
    uctx_pool[pid].regs.edi = retval;
  106ed4:	8b 54 24 10          	mov    0x10(%esp),%edx
  106ed8:	6b c0 44             	imul   $0x44,%eax,%eax
  106edb:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  106ee1:	89 10                	mov    %edx,(%eax)
}
  106ee3:	83 c4 08             	add    $0x8,%esp
  106ee6:	5b                   	pop    %ebx
  106ee7:	c3                   	ret
  106ee8:	66 90                	xchg   %ax,%ax
  106eea:	66 90                	xchg   %ax,%ax
  106eec:	66 90                	xchg   %ax,%ax
  106eee:	66 90                	xchg   %ax,%ax

00106ef0 <sys_puts>:
/**
 * Copies a string from user into buffer and prints it to the screen.
 * This is called by the user level "printf" library as a system call.
 */
void sys_puts(void)
{
  106ef0:	55                   	push   %ebp
  106ef1:	57                   	push   %edi
  106ef2:	56                   	push   %esi
  106ef3:	53                   	push   %ebx
  106ef4:	e8 44 94 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  106ef9:	81 c3 fb 80 00 00    	add    $0x80fb,%ebx
  106eff:	83 ec 2c             	sub    $0x2c,%esp
    unsigned int cur_pid;
    unsigned int str_uva, str_len;
    unsigned int remain, cur_pos, nbytes;

    cur_pid = get_curid();
  106f02:	e8 e9 fa ff ff       	call   1069f0 <get_curid>
  106f07:	89 44 24 10          	mov    %eax,0x10(%esp)
    str_uva = syscall_get_arg2();
  106f0b:	e8 d0 fd ff ff       	call   106ce0 <syscall_get_arg2>
  106f10:	89 c7                	mov    %eax,%edi
    str_len = syscall_get_arg3();
  106f12:	e8 f9 fd ff ff       	call   106d10 <syscall_get_arg3>

    if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI))
  106f17:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  106f1d:	0f 86 c5 00 00 00    	jbe    106fe8 <sys_puts+0xf8>
  106f23:	8d 14 07             	lea    (%edi,%eax,1),%edx
  106f26:	89 c5                	mov    %eax,%ebp
  106f28:	81 fa 00 00 00 f0    	cmp    $0xf0000000,%edx
  106f2e:	0f 87 b4 00 00 00    	ja     106fe8 <sys_puts+0xf8>
    }

    remain = str_len;
    cur_pos = str_uva;

    while (remain)
  106f34:	85 c0                	test   %eax,%eax
  106f36:	0f 84 94 00 00 00    	je     106fd0 <sys_puts+0xe0>
        if (remain < PAGESIZE - 1)
            nbytes = remain;
        else
            nbytes = PAGESIZE - 1;

        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes)
  106f3c:	8b 44 24 10          	mov    0x10(%esp),%eax
  106f40:	8d 8b 2c 2c cb 00    	lea    0xcb2c2c(%ebx),%ecx
            syscall_set_errno(E_MEM);
            return;
        }

        sys_buf[cur_pid][nbytes] = '\0';
        KERN_INFO("%s", sys_buf[cur_pid]);
  106f46:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes)
  106f4a:	c1 e0 0c             	shl    $0xc,%eax
  106f4d:	89 44 24 14          	mov    %eax,0x14(%esp)
  106f51:	01 c8                	add    %ecx,%eax
  106f53:	89 44 24 08          	mov    %eax,0x8(%esp)
        KERN_INFO("%s", sys_buf[cur_pid]);
  106f57:	8d 83 1a 90 ff ff    	lea    -0x6fe6(%ebx),%eax
  106f5d:	89 44 24 18          	mov    %eax,0x18(%esp)
  106f61:	eb 35                	jmp    106f98 <sys_puts+0xa8>
  106f63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        sys_buf[cur_pid][nbytes] = '\0';
  106f68:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  106f6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
        KERN_INFO("%s", sys_buf[cur_pid]);
  106f70:	83 ec 08             	sub    $0x8,%esp
        sys_buf[cur_pid][nbytes] = '\0';
  106f73:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  106f76:	8b 44 24 24          	mov    0x24(%esp),%eax
  106f7a:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
        KERN_INFO("%s", sys_buf[cur_pid]);
  106f7e:	ff 74 24 10          	push   0x10(%esp)
  106f82:	ff 74 24 24          	push   0x24(%esp)
  106f86:	e8 26 ba ff ff       	call   1029b1 <debug_info>

        remain -= nbytes;
        cur_pos += nbytes;
  106f8b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    while (remain)
  106f8f:	83 c4 10             	add    $0x10,%esp
        cur_pos += nbytes;
  106f92:	01 c7                	add    %eax,%edi
    while (remain)
  106f94:	29 c5                	sub    %eax,%ebp
  106f96:	74 38                	je     106fd0 <sys_puts+0xe0>
        if (remain < PAGESIZE - 1)
  106f98:	ba ff 0f 00 00       	mov    $0xfff,%edx
  106f9d:	39 d5                	cmp    %edx,%ebp
  106f9f:	89 d6                	mov    %edx,%esi
  106fa1:	0f 46 f5             	cmovbe %ebp,%esi
        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes)
  106fa4:	56                   	push   %esi
  106fa5:	ff 74 24 0c          	push   0xc(%esp)
  106fa9:	57                   	push   %edi
  106faa:	ff 74 24 1c          	push   0x1c(%esp)
  106fae:	e8 c8 c9 ff ff       	call   10397b <pt_copyin>
  106fb3:	83 c4 10             	add    $0x10,%esp
  106fb6:	39 f0                	cmp    %esi,%eax
  106fb8:	74 ae                	je     106f68 <sys_puts+0x78>
            syscall_set_errno(E_MEM);
  106fba:	83 ec 0c             	sub    $0xc,%esp
  106fbd:	6a 01                	push   $0x1
  106fbf:	e8 0c fe ff ff       	call   106dd0 <syscall_set_errno>
            return;
  106fc4:	83 c4 10             	add    $0x10,%esp
    }

    syscall_set_errno(E_SUCC);
}
  106fc7:	83 c4 2c             	add    $0x2c,%esp
  106fca:	5b                   	pop    %ebx
  106fcb:	5e                   	pop    %esi
  106fcc:	5f                   	pop    %edi
  106fcd:	5d                   	pop    %ebp
  106fce:	c3                   	ret
  106fcf:	90                   	nop
    syscall_set_errno(E_SUCC);
  106fd0:	83 ec 0c             	sub    $0xc,%esp
  106fd3:	6a 00                	push   $0x0
  106fd5:	e8 f6 fd ff ff       	call   106dd0 <syscall_set_errno>
  106fda:	83 c4 10             	add    $0x10,%esp
}
  106fdd:	83 c4 2c             	add    $0x2c,%esp
  106fe0:	5b                   	pop    %ebx
  106fe1:	5e                   	pop    %esi
  106fe2:	5f                   	pop    %edi
  106fe3:	5d                   	pop    %ebp
  106fe4:	c3                   	ret
  106fe5:	8d 76 00             	lea    0x0(%esi),%esi
        syscall_set_errno(E_INVAL_ADDR);
  106fe8:	83 ec 0c             	sub    $0xc,%esp
  106feb:	6a 04                	push   $0x4
  106fed:	e8 de fd ff ff       	call   106dd0 <syscall_set_errno>
        return;
  106ff2:	83 c4 10             	add    $0x10,%esp
}
  106ff5:	83 c4 2c             	add    $0x2c,%esp
  106ff8:	5b                   	pop    %ebx
  106ff9:	5e                   	pop    %esi
  106ffa:	5f                   	pop    %edi
  106ffb:	5d                   	pop    %ebp
  106ffc:	c3                   	ret
  106ffd:	8d 76 00             	lea    0x0(%esi),%esi

00107000 <sys_spawn>:
 * NUM_IDS with the error number E_INVAL_PID. The same error case apply
 * when the proc_create fails.
 * Otherwise, you should mark it as successful, and return the new child process id.
 */
void sys_spawn(void)
{
  107000:	56                   	push   %esi
  107001:	53                   	push   %ebx
  107002:	e8 36 93 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  107007:	81 c3 ed 7f 00 00    	add    $0x7fed,%ebx
  10700d:	83 ec 04             	sub    $0x4,%esp
    // TODO
    unsigned int curid;
    unsigned int elf_id, quota;
    unsigned int pid;
    void *elf_addr;
    curid = get_curid();
  107010:	e8 db f9 ff ff       	call   1069f0 <get_curid>
    elf_id = syscall_get_arg2(); // arg1 is reserved for system call number
  107015:	e8 c6 fc ff ff       	call   106ce0 <syscall_get_arg2>
    if (elf_id > 3 || elf_id < 1)
  10701a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10701d:	83 fa 02             	cmp    $0x2,%edx
  107020:	77 6e                	ja     107090 <sys_spawn+0x90>
        // not legal
        syscall_set_errno(E_INVAL_PID);
        syscall_set_retval1(NUM_IDS);
        return;
    }
    else if (elf_id == 1)
  107022:	83 f8 01             	cmp    $0x1,%eax
  107025:	74 59                	je     107080 <sys_spawn+0x80>
    {
        elf_addr = (void *)_binary___obj_user_pingpong_ping_start;
    }
    else if (elf_id == 2)
  107027:	83 f8 02             	cmp    $0x2,%eax
  10702a:	0f 84 80 00 00 00    	je     1070b0 <sys_spawn+0xb0>
    {
        elf_addr = (void *)_binary___obj_user_pingpong_pong_start;
    }
    else if (elf_id == 3)
    {
        elf_addr = (void *)_binary___obj_user_pingpong_ding_start;
  107030:	c7 c6 54 7b 12 00    	mov    $0x127b54,%esi
        // should not go here
    }

    // TODO elf_addr

    quota = syscall_get_arg3();
  107036:	e8 d5 fc ff ff       	call   106d10 <syscall_get_arg3>
    pid = proc_create(elf_addr, quota);
  10703b:	83 ec 08             	sub    $0x8,%esp
  10703e:	50                   	push   %eax
  10703f:	56                   	push   %esi
  107040:	e8 db fb ff ff       	call   106c20 <proc_create>
    if (pid == NUM_IDS)
  107045:	83 c4 10             	add    $0x10,%esp
    pid = proc_create(elf_addr, quota);
  107048:	89 c6                	mov    %eax,%esi
    if (pid == NUM_IDS)
  10704a:	83 f8 40             	cmp    $0x40,%eax
  10704d:	74 21                	je     107070 <sys_spawn+0x70>
    {
        syscall_set_errno(E_MEM);
    }
    else
    {
        syscall_set_errno(E_SUCC);
  10704f:	83 ec 0c             	sub    $0xc,%esp
  107052:	6a 00                	push   $0x0
  107054:	e8 77 fd ff ff       	call   106dd0 <syscall_set_errno>
  107059:	83 c4 10             	add    $0x10,%esp
    }
    syscall_set_retval1(pid);
  10705c:	83 ec 0c             	sub    $0xc,%esp
  10705f:	56                   	push   %esi
  107060:	e8 9b fd ff ff       	call   106e00 <syscall_set_retval1>
  107065:	83 c4 10             	add    $0x10,%esp
}
  107068:	83 c4 04             	add    $0x4,%esp
  10706b:	5b                   	pop    %ebx
  10706c:	5e                   	pop    %esi
  10706d:	c3                   	ret
  10706e:	66 90                	xchg   %ax,%ax
        syscall_set_errno(E_MEM);
  107070:	83 ec 0c             	sub    $0xc,%esp
  107073:	6a 01                	push   $0x1
  107075:	e8 56 fd ff ff       	call   106dd0 <syscall_set_errno>
  10707a:	83 c4 10             	add    $0x10,%esp
  10707d:	eb dd                	jmp    10705c <sys_spawn+0x5c>
  10707f:	90                   	nop
        elf_addr = (void *)_binary___obj_user_pingpong_ping_start;
  107080:	c7 c6 44 81 11 00    	mov    $0x118144,%esi
  107086:	eb ae                	jmp    107036 <sys_spawn+0x36>
  107088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10708f:	00 
        syscall_set_errno(E_INVAL_PID);
  107090:	83 ec 0c             	sub    $0xc,%esp
  107093:	6a 05                	push   $0x5
  107095:	e8 36 fd ff ff       	call   106dd0 <syscall_set_errno>
        syscall_set_retval1(NUM_IDS);
  10709a:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  1070a1:	e8 5a fd ff ff       	call   106e00 <syscall_set_retval1>
        return;
  1070a6:	83 c4 10             	add    $0x10,%esp
}
  1070a9:	83 c4 04             	add    $0x4,%esp
  1070ac:	5b                   	pop    %ebx
  1070ad:	5e                   	pop    %esi
  1070ae:	c3                   	ret
  1070af:	90                   	nop
        elf_addr = (void *)_binary___obj_user_pingpong_pong_start;
  1070b0:	c7 c6 4c fe 11 00    	mov    $0x11fe4c,%esi
  1070b6:	e9 7b ff ff ff       	jmp    107036 <sys_spawn+0x36>
  1070bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001070c0 <sys_yield>:
 * The user level library function sys_yield (defined in user/include/syscall.h)
 * does not take any argument and does not have any return values.
 * Do not forget to set the error number as E_SUCC.
 */
void sys_yield(void)
{
  1070c0:	53                   	push   %ebx
  1070c1:	e8 77 92 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1070c6:	81 c3 2e 7f 00 00    	add    $0x7f2e,%ebx
  1070cc:	83 ec 08             	sub    $0x8,%esp
    // TODO
    thread_yield();
  1070cf:	e8 dc f9 ff ff       	call   106ab0 <thread_yield>
    syscall_set_errno(E_SUCC);
  1070d4:	83 ec 0c             	sub    $0xc,%esp
  1070d7:	6a 00                	push   $0x0
  1070d9:	e8 f2 fc ff ff       	call   106dd0 <syscall_set_errno>
}
  1070de:	83 c4 18             	add    $0x18,%esp
  1070e1:	5b                   	pop    %ebx
  1070e2:	c3                   	ret
  1070e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1070ea:	00 
  1070eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

001070f0 <sys_fork>:

// Your implementation of fork
void sys_fork()
{
    // TODO
}
  1070f0:	c3                   	ret
  1070f1:	66 90                	xchg   %ax,%ax
  1070f3:	66 90                	xchg   %ax,%ax
  1070f5:	66 90                	xchg   %ax,%ax
  1070f7:	66 90                	xchg   %ax,%ax
  1070f9:	66 90                	xchg   %ax,%ax
  1070fb:	66 90                	xchg   %ax,%ax
  1070fd:	66 90                	xchg   %ax,%ax
  1070ff:	90                   	nop

00107100 <syscall_dispatch>:
#include <lib/syscall.h>

#include "import.h"

void syscall_dispatch(void)
{
  107100:	53                   	push   %ebx
  107101:	e8 37 92 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  107106:	81 c3 ee 7e 00 00    	add    $0x7eee,%ebx
  10710c:	83 ec 08             	sub    $0x8,%esp
    unsigned int nr;

    nr = syscall_get_arg1();
  10710f:	e8 9c fb ff ff       	call   106cb0 <syscall_get_arg1>

    switch (nr) {
  107114:	83 f8 02             	cmp    $0x2,%eax
  107117:	74 3f                	je     107158 <syscall_dispatch+0x58>
  107119:	77 15                	ja     107130 <syscall_dispatch+0x30>
  10711b:	85 c0                	test   %eax,%eax
  10711d:	74 49                	je     107168 <syscall_dispatch+0x68>
         *   the process ID of the process
         *
         * Error:
         *   E_INVAL_PID
         */
        sys_spawn();
  10711f:	e8 dc fe ff ff       	call   107000 <sys_spawn>
        sys_fork();
        break;
    default:
        syscall_set_errno(E_INVAL_CALLNR);
    }
}
  107124:	83 c4 08             	add    $0x8,%esp
  107127:	5b                   	pop    %ebx
  107128:	c3                   	ret
  107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (nr) {
  107130:	83 f8 03             	cmp    $0x3,%eax
  107133:	75 0b                	jne    107140 <syscall_dispatch+0x40>
        sys_fork();
  107135:	e8 b6 ff ff ff       	call   1070f0 <sys_fork>
}
  10713a:	83 c4 08             	add    $0x8,%esp
  10713d:	5b                   	pop    %ebx
  10713e:	c3                   	ret
  10713f:	90                   	nop
        syscall_set_errno(E_INVAL_CALLNR);
  107140:	83 ec 0c             	sub    $0xc,%esp
  107143:	6a 03                	push   $0x3
  107145:	e8 86 fc ff ff       	call   106dd0 <syscall_set_errno>
  10714a:	83 c4 10             	add    $0x10,%esp
}
  10714d:	83 c4 08             	add    $0x8,%esp
  107150:	5b                   	pop    %ebx
  107151:	c3                   	ret
  107152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sys_yield();
  107158:	e8 63 ff ff ff       	call   1070c0 <sys_yield>
}
  10715d:	83 c4 08             	add    $0x8,%esp
  107160:	5b                   	pop    %ebx
  107161:	c3                   	ret
  107162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sys_puts();
  107168:	e8 83 fd ff ff       	call   106ef0 <sys_puts>
}
  10716d:	83 c4 08             	add    $0x8,%esp
  107170:	5b                   	pop    %ebx
  107171:	c3                   	ret
  107172:	66 90                	xchg   %ax,%ax
  107174:	66 90                	xchg   %ax,%ax
  107176:	66 90                	xchg   %ax,%ax
  107178:	66 90                	xchg   %ax,%ax
  10717a:	66 90                	xchg   %ax,%ax
  10717c:	66 90                	xchg   %ax,%ax
  10717e:	66 90                	xchg   %ax,%ax

00107180 <trap_dump>:
#include "import.h"

extern tf_t uctx_pool[NUM_IDS];

static void trap_dump(tf_t *tf)
{
  107180:	55                   	push   %ebp
  107181:	57                   	push   %edi
  107182:	56                   	push   %esi
  107183:	53                   	push   %ebx
  107184:	e8 b4 91 ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  107189:	81 c3 6b 7e 00 00    	add    $0x7e6b,%ebx
  10718f:	83 ec 0c             	sub    $0xc,%esp
    if (tf == NULL)
  107192:	85 c0                	test   %eax,%eax
  107194:	0f 84 c0 01 00 00    	je     10735a <trap_dump+0x1da>
  10719a:	89 c6                	mov    %eax,%esi
        return;

    uintptr_t base = (uintptr_t)tf;

    KERN_DEBUG("trapframe at %x\n", base);
  10719c:	8d bb 60 a0 ff ff    	lea    -0x5fa0(%ebx),%edi
  1071a2:	50                   	push   %eax
  1071a3:	8d 83 05 96 ff ff    	lea    -0x69fb(%ebx),%eax
  1071a9:	50                   	push   %eax
    KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
    KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
    KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  1071aa:	8d ab 58 96 ff ff    	lea    -0x69a8(%ebx),%ebp
    KERN_DEBUG("trapframe at %x\n", base);
  1071b0:	6a 15                	push   $0x15
  1071b2:	57                   	push   %edi
  1071b3:	e8 1e b8 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
  1071b8:	58                   	pop    %eax
  1071b9:	8d 83 16 96 ff ff    	lea    -0x69ea(%ebx),%eax
  1071bf:	ff 36                	push   (%esi)
  1071c1:	56                   	push   %esi
  1071c2:	50                   	push   %eax
  1071c3:	6a 16                	push   $0x16
  1071c5:	57                   	push   %edi
  1071c6:	e8 0b b8 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
  1071cb:	83 c4 14             	add    $0x14,%esp
  1071ce:	8d 46 04             	lea    0x4(%esi),%eax
  1071d1:	ff 76 04             	push   0x4(%esi)
  1071d4:	50                   	push   %eax
  1071d5:	8d 83 2c 96 ff ff    	lea    -0x69d4(%ebx),%eax
  1071db:	50                   	push   %eax
  1071dc:	6a 17                	push   $0x17
  1071de:	57                   	push   %edi
  1071df:	e8 f2 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
  1071e4:	83 c4 14             	add    $0x14,%esp
  1071e7:	8d 46 08             	lea    0x8(%esi),%eax
  1071ea:	ff 76 08             	push   0x8(%esi)
  1071ed:	50                   	push   %eax
  1071ee:	8d 83 42 96 ff ff    	lea    -0x69be(%ebx),%eax
  1071f4:	50                   	push   %eax
  1071f5:	6a 18                	push   $0x18
  1071f7:	57                   	push   %edi
  1071f8:	e8 d9 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  1071fd:	83 c4 14             	add    $0x14,%esp
  107200:	8d 46 0c             	lea    0xc(%esi),%eax
  107203:	ff 76 0c             	push   0xc(%esi)
  107206:	50                   	push   %eax
  107207:	55                   	push   %ebp
  107208:	6a 19                	push   $0x19
  10720a:	57                   	push   %edi
  10720b:	e8 c6 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  107210:	83 c4 14             	add    $0x14,%esp
  107213:	8d 46 10             	lea    0x10(%esi),%eax
  107216:	ff 76 10             	push   0x10(%esi)
  107219:	50                   	push   %eax
  10721a:	8d 83 6e 96 ff ff    	lea    -0x6992(%ebx),%eax
  107220:	50                   	push   %eax
  107221:	6a 1a                	push   $0x1a
  107223:	57                   	push   %edi
  107224:	e8 ad b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
  107229:	83 c4 14             	add    $0x14,%esp
  10722c:	8d 46 14             	lea    0x14(%esi),%eax
  10722f:	ff 76 14             	push   0x14(%esi)
  107232:	50                   	push   %eax
  107233:	8d 83 84 96 ff ff    	lea    -0x697c(%ebx),%eax
  107239:	50                   	push   %eax
  10723a:	6a 1b                	push   $0x1b
  10723c:	57                   	push   %edi
  10723d:	e8 94 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
  107242:	83 c4 14             	add    $0x14,%esp
  107245:	8d 46 18             	lea    0x18(%esi),%eax
  107248:	ff 76 18             	push   0x18(%esi)
  10724b:	50                   	push   %eax
  10724c:	8d 83 9a 96 ff ff    	lea    -0x6966(%ebx),%eax
  107252:	50                   	push   %eax
  107253:	6a 1c                	push   $0x1c
  107255:	57                   	push   %edi
  107256:	e8 7b b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  10725b:	83 c4 14             	add    $0x14,%esp
  10725e:	8d 46 1c             	lea    0x1c(%esi),%eax
  107261:	ff 76 1c             	push   0x1c(%esi)
  107264:	50                   	push   %eax
  107265:	8d 83 b0 96 ff ff    	lea    -0x6950(%ebx),%eax
  10726b:	50                   	push   %eax
  10726c:	6a 1d                	push   $0x1d
  10726e:	57                   	push   %edi
  10726f:	e8 62 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  107274:	0f b7 46 20          	movzwl 0x20(%esi),%eax
  107278:	83 c4 14             	add    $0x14,%esp
  10727b:	50                   	push   %eax
  10727c:	8d 46 20             	lea    0x20(%esi),%eax
  10727f:	50                   	push   %eax
  107280:	8d 83 c6 96 ff ff    	lea    -0x693a(%ebx),%eax
  107286:	50                   	push   %eax
  107287:	6a 1e                	push   $0x1e
  107289:	57                   	push   %edi
  10728a:	e8 47 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
  10728f:	0f b7 46 24          	movzwl 0x24(%esi),%eax
  107293:	83 c4 14             	add    $0x14,%esp
  107296:	50                   	push   %eax
  107297:	8d 46 24             	lea    0x24(%esi),%eax
  10729a:	50                   	push   %eax
  10729b:	8d 83 dc 96 ff ff    	lea    -0x6924(%ebx),%eax
  1072a1:	50                   	push   %eax
  1072a2:	6a 1f                	push   $0x1f
  1072a4:	57                   	push   %edi
  1072a5:	e8 2c b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
  1072aa:	83 c4 14             	add    $0x14,%esp
  1072ad:	8d 46 28             	lea    0x28(%esi),%eax
  1072b0:	ff 76 28             	push   0x28(%esi)
  1072b3:	50                   	push   %eax
  1072b4:	8d 83 f2 96 ff ff    	lea    -0x690e(%ebx),%eax
  1072ba:	50                   	push   %eax
  1072bb:	6a 20                	push   $0x20
  1072bd:	57                   	push   %edi
  1072be:	e8 13 b7 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  1072c3:	83 c4 14             	add    $0x14,%esp
  1072c6:	8d 46 2c             	lea    0x2c(%esi),%eax
  1072c9:	ff 76 2c             	push   0x2c(%esi)
  1072cc:	50                   	push   %eax
  1072cd:	8d 83 08 97 ff ff    	lea    -0x68f8(%ebx),%eax
  1072d3:	50                   	push   %eax
  1072d4:	6a 21                	push   $0x21
  1072d6:	57                   	push   %edi
  1072d7:	e8 fa b6 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  1072dc:	83 c4 14             	add    $0x14,%esp
  1072df:	8d 46 30             	lea    0x30(%esi),%eax
  1072e2:	ff 76 30             	push   0x30(%esi)
  1072e5:	50                   	push   %eax
  1072e6:	8d 83 1e 97 ff ff    	lea    -0x68e2(%ebx),%eax
  1072ec:	50                   	push   %eax
  1072ed:	6a 22                	push   $0x22
  1072ef:	57                   	push   %edi
  1072f0:	e8 e1 b6 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
  1072f5:	0f b7 46 34          	movzwl 0x34(%esi),%eax
  1072f9:	83 c4 14             	add    $0x14,%esp
  1072fc:	50                   	push   %eax
  1072fd:	8d 46 34             	lea    0x34(%esi),%eax
  107300:	50                   	push   %eax
  107301:	8d 83 34 97 ff ff    	lea    -0x68cc(%ebx),%eax
  107307:	50                   	push   %eax
  107308:	6a 23                	push   $0x23
  10730a:	57                   	push   %edi
  10730b:	e8 c6 b6 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
  107310:	83 c4 14             	add    $0x14,%esp
  107313:	8d 46 38             	lea    0x38(%esi),%eax
  107316:	ff 76 38             	push   0x38(%esi)
  107319:	50                   	push   %eax
  10731a:	8d 83 4a 97 ff ff    	lea    -0x68b6(%ebx),%eax
  107320:	50                   	push   %eax
  107321:	6a 24                	push   $0x24
  107323:	57                   	push   %edi
  107324:	e8 ad b6 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  107329:	83 c4 14             	add    $0x14,%esp
  10732c:	8d 46 3c             	lea    0x3c(%esi),%eax
  10732f:	ff 76 3c             	push   0x3c(%esi)
  107332:	50                   	push   %eax
  107333:	55                   	push   %ebp
  107334:	6a 25                	push   $0x25
  107336:	57                   	push   %edi
  107337:	e8 9a b6 ff ff       	call   1029d6 <debug_normal>
    KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
  10733c:	0f b7 46 40          	movzwl 0x40(%esi),%eax
  107340:	83 c4 14             	add    $0x14,%esp
  107343:	83 c6 40             	add    $0x40,%esi
  107346:	50                   	push   %eax
  107347:	8d 83 60 97 ff ff    	lea    -0x68a0(%ebx),%eax
  10734d:	56                   	push   %esi
  10734e:	50                   	push   %eax
  10734f:	6a 26                	push   $0x26
  107351:	57                   	push   %edi
  107352:	e8 7f b6 ff ff       	call   1029d6 <debug_normal>
  107357:	83 c4 20             	add    $0x20,%esp
}
  10735a:	83 c4 0c             	add    $0xc,%esp
  10735d:	5b                   	pop    %ebx
  10735e:	5e                   	pop    %esi
  10735f:	5f                   	pop    %edi
  107360:	5d                   	pop    %ebp
  107361:	c3                   	ret
  107362:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  107369:	00 
  10736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107370 <default_exception_handler>:

void default_exception_handler(void)
{
  107370:	56                   	push   %esi
  107371:	e8 cd 91 ff ff       	call   100543 <__x86.get_pc_thunk.si>
  107376:	81 c6 7e 7c 00 00    	add    $0x7c7e,%esi
  10737c:	53                   	push   %ebx
  10737d:	83 ec 04             	sub    $0x4,%esp
    unsigned int cur_pid;

    cur_pid = get_curid();
  107380:	89 f3                	mov    %esi,%ebx
  107382:	e8 69 f6 ff ff       	call   1069f0 <get_curid>
    trap_dump(&uctx_pool[cur_pid]);
  107387:	6b d8 44             	imul   $0x44,%eax,%ebx
  10738a:	81 c3 20 0b dc 00    	add    $0xdc0b20,%ebx
  107390:	89 d8                	mov    %ebx,%eax
  107392:	e8 e9 fd ff ff       	call   107180 <trap_dump>

    KERN_PANIC("Trap %d @ 0x%08x.\n", uctx_pool[cur_pid].trapno,
  107397:	83 ec 0c             	sub    $0xc,%esp
  10739a:	8d 86 76 97 ff ff    	lea    -0x688a(%esi),%eax
  1073a0:	ff 73 30             	push   0x30(%ebx)
  1073a3:	ff 73 28             	push   0x28(%ebx)
  1073a6:	89 f3                	mov    %esi,%ebx
  1073a8:	50                   	push   %eax
  1073a9:	8d 86 60 a0 ff ff    	lea    -0x5fa0(%esi),%eax
  1073af:	6a 30                	push   $0x30
  1073b1:	50                   	push   %eax
  1073b2:	e8 58 b6 ff ff       	call   102a0f <debug_panic>
               uctx_pool[cur_pid].eip);
}
  1073b7:	83 c4 24             	add    $0x24,%esp
  1073ba:	5b                   	pop    %ebx
  1073bb:	5e                   	pop    %esi
  1073bc:	c3                   	ret
  1073bd:	8d 76 00             	lea    0x0(%esi),%esi

001073c0 <pgflt_handler>:

void pgflt_handler(void)
{
  1073c0:	55                   	push   %ebp
  1073c1:	57                   	push   %edi
  1073c2:	56                   	push   %esi
  1073c3:	53                   	push   %ebx
  1073c4:	e8 74 8f ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1073c9:	81 c3 2b 7c 00 00    	add    $0x7c2b,%ebx
  1073cf:	83 ec 0c             	sub    $0xc,%esp
    unsigned int cur_pid;
    unsigned int errno;
    unsigned int fault_va;
    unsigned int pte_entry;

    cur_pid = get_curid();
  1073d2:	e8 19 f6 ff ff       	call   1069f0 <get_curid>
  1073d7:	89 c6                	mov    %eax,%esi
    errno = uctx_pool[cur_pid].err;
  1073d9:	6b c0 44             	imul   $0x44,%eax,%eax
  1073dc:	81 c0 20 0b dc 00    	add    $0xdc0b20,%eax
  1073e2:	8b 78 2c             	mov    0x2c(%eax),%edi
    fault_va = rcr2();
  1073e5:	e8 09 c2 ff ff       	call   1035f3 <rcr2>
  1073ea:	89 c5                	mov    %eax,%ebp

    if ((errno & 0x3) == 0x3)
  1073ec:	89 f8                	mov    %edi,%eax
  1073ee:	f7 d0                	not    %eax
  1073f0:	a8 03                	test   $0x3,%al
  1073f2:	74 2c                	je     107420 <pgflt_handler+0x60>

    // Uncomment this line to see information about the page fault
    // KERN_DEBUG("Page fault: VA 0x%08x, errno 0x%08x, process %d, EIP 0x%08x.\n",
    //            fault_va, errno, cur_pid, uctx_pool[cur_pid].eip);

    if (errno & PFE_PR)
  1073f4:	f7 c7 01 00 00 00    	test   $0x1,%edi
  1073fa:	75 36                	jne    107432 <pgflt_handler+0x72>
        KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n",
                   fault_va, errno);
        return;
    }

    if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber)
  1073fc:	83 ec 04             	sub    $0x4,%esp
  1073ff:	6a 07                	push   $0x7
  107401:	55                   	push   %ebp
  107402:	56                   	push   %esi
  107403:	e8 98 e9 ff ff       	call   105da0 <alloc_page>
  107408:	83 c4 10             	add    $0x10,%esp
  10740b:	3d 01 00 10 00       	cmp    $0x100001,%eax
  107410:	74 6e                	je     107480 <pgflt_handler+0xc0>
    {
        KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n",
                   fault_va, errno);
    }
}
  107412:	83 c4 0c             	add    $0xc,%esp
  107415:	5b                   	pop    %ebx
  107416:	5e                   	pop    %esi
  107417:	5f                   	pop    %edi
  107418:	5d                   	pop    %ebp
  107419:	c3                   	ret
  10741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte_entry = get_ptbl_entry_by_va(cur_pid, fault_va);
  107420:	83 ec 08             	sub    $0x8,%esp
  107423:	55                   	push   %ebp
  107424:	56                   	push   %esi
  107425:	e8 06 df ff ff       	call   105330 <get_ptbl_entry_by_va>
        if (pte_entry & PTE_COW)
  10742a:	83 c4 10             	add    $0x10,%esp
  10742d:	f6 c4 08             	test   $0x8,%ah
  107430:	74 2e                	je     107460 <pgflt_handler+0xa0>
  107432:	8d b3 60 a0 ff ff    	lea    -0x5fa0(%ebx),%esi
        KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n",
  107438:	83 ec 0c             	sub    $0xc,%esp
  10743b:	8d 83 ac a0 ff ff    	lea    -0x5f54(%ebx),%eax
  107441:	57                   	push   %edi
  107442:	55                   	push   %ebp
  107443:	50                   	push   %eax
  107444:	6a 54                	push   $0x54
  107446:	56                   	push   %esi
  107447:	e8 c3 b5 ff ff       	call   102a0f <debug_panic>
        return;
  10744c:	83 c4 20             	add    $0x20,%esp
}
  10744f:	83 c4 0c             	add    $0xc,%esp
  107452:	5b                   	pop    %ebx
  107453:	5e                   	pop    %esi
  107454:	5f                   	pop    %edi
  107455:	5d                   	pop    %ebp
  107456:	c3                   	ret
  107457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10745e:	00 
  10745f:	90                   	nop
            KERN_PANIC("Writing to read-only page: va = %p\n", fault_va);
  107460:	8d 83 88 a0 ff ff    	lea    -0x5f78(%ebx),%eax
  107466:	8d b3 60 a0 ff ff    	lea    -0x5fa0(%ebx),%esi
  10746c:	55                   	push   %ebp
  10746d:	50                   	push   %eax
  10746e:	6a 4a                	push   $0x4a
  107470:	56                   	push   %esi
  107471:	e8 99 b5 ff ff       	call   102a0f <debug_panic>
  107476:	83 c4 10             	add    $0x10,%esp
  107479:	eb bd                	jmp    107438 <pgflt_handler+0x78>
  10747b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n",
  107480:	83 ec 0c             	sub    $0xc,%esp
  107483:	8d 83 e0 a0 ff ff    	lea    -0x5f20(%ebx),%eax
  107489:	57                   	push   %edi
  10748a:	55                   	push   %ebp
  10748b:	50                   	push   %eax
  10748c:	8d 83 60 a0 ff ff    	lea    -0x5fa0(%ebx),%eax
  107492:	6a 5b                	push   $0x5b
  107494:	50                   	push   %eax
  107495:	e8 75 b5 ff ff       	call   102a0f <debug_panic>
  10749a:	83 c4 20             	add    $0x20,%esp
}
  10749d:	83 c4 0c             	add    $0xc,%esp
  1074a0:	5b                   	pop    %ebx
  1074a1:	5e                   	pop    %esi
  1074a2:	5f                   	pop    %edi
  1074a3:	5d                   	pop    %ebp
  1074a4:	c3                   	ret
  1074a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1074ac:	00 
  1074ad:	8d 76 00             	lea    0x0(%esi),%esi

001074b0 <exception_handler>:
/**
 * We currently only handle the page fault exception.
 * All other exceptions should be routed to the default exception handler.
 */
void exception_handler(void)
{
  1074b0:	57                   	push   %edi
  1074b1:	56                   	push   %esi
  1074b2:	53                   	push   %ebx
  1074b3:	e8 85 8e ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  1074b8:	81 c3 3c 7b 00 00    	add    $0x7b3c,%ebx
    // TODO
    unsigned int trapno;
    unsigned int cur_pid;
    cur_pid = get_curid();
  1074be:	e8 2d f5 ff ff       	call   1069f0 <get_curid>
    tf_t tf;
    tf = uctx_pool[cur_pid];
  1074c3:	c7 c7 20 0b dc 00    	mov    $0xdc0b20,%edi
  1074c9:	6b c0 44             	imul   $0x44,%eax,%eax
    if (tf.trapno == T_PGFLT)
  1074cc:	83 7c 07 28 0e       	cmpl   $0xe,0x28(%edi,%eax,1)
  1074d1:	74 3d                	je     107510 <exception_handler+0x60>
    cur_pid = get_curid();
  1074d3:	e8 18 f5 ff ff       	call   1069f0 <get_curid>
    trap_dump(&uctx_pool[cur_pid]);
  1074d8:	6b f0 44             	imul   $0x44,%eax,%esi
  1074db:	01 fe                	add    %edi,%esi
  1074dd:	89 f0                	mov    %esi,%eax
  1074df:	e8 9c fc ff ff       	call   107180 <trap_dump>
    KERN_PANIC("Trap %d @ 0x%08x.\n", uctx_pool[cur_pid].trapno,
  1074e4:	83 ec 0c             	sub    $0xc,%esp
  1074e7:	8d 83 76 97 ff ff    	lea    -0x688a(%ebx),%eax
  1074ed:	ff 76 30             	push   0x30(%esi)
  1074f0:	ff 76 28             	push   0x28(%esi)
  1074f3:	50                   	push   %eax
  1074f4:	8d 83 60 a0 ff ff    	lea    -0x5fa0(%ebx),%eax
  1074fa:	6a 30                	push   $0x30
  1074fc:	50                   	push   %eax
  1074fd:	e8 0d b5 ff ff       	call   102a0f <debug_panic>
}
  107502:	83 c4 20             	add    $0x20,%esp
    }
    else
    {
        default_exception_handler();
    }
}
  107505:	5b                   	pop    %ebx
  107506:	5e                   	pop    %esi
  107507:	5f                   	pop    %edi
  107508:	c3                   	ret
  107509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107510:	5b                   	pop    %ebx
  107511:	5e                   	pop    %esi
  107512:	5f                   	pop    %edi
        pgflt_handler();
  107513:	e9 a8 fe ff ff       	jmp    1073c0 <pgflt_handler>
  107518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10751f:	00 

00107520 <interrupt_handler>:
/**
 * Any interrupt request other than the spurious or timer should be
 * routed to the default interrupt handler.
 */
void interrupt_handler(void)
{
  107520:	53                   	push   %ebx
  107521:	e8 17 8e ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  107526:	81 c3 ce 7a 00 00    	add    $0x7ace,%ebx
  10752c:	83 ec 08             	sub    $0x8,%esp
    // TODO
    unsigned int arg1;
    arg1 = syscall_get_arg1();
  10752f:	e8 7c f7 ff ff       	call   106cb0 <syscall_get_arg1>
    if (arg1 == T_IRQ0 + IRQ_TIMER)
  107534:	83 f8 27             	cmp    $0x27,%eax
  107537:	74 05                	je     10753e <interrupt_handler+0x1e>
    intr_eoi();
  107539:	e8 0d a8 ff ff       	call   101d4b <intr_eoi>
    }
    else
    {
        default_intr_handler();
    }
}
  10753e:	83 c4 08             	add    $0x8,%esp
  107541:	5b                   	pop    %ebx
  107542:	c3                   	ret
  107543:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10754a:	00 
  10754b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00107550 <trap>:

void trap(tf_t *tf)
{
  107550:	55                   	push   %ebp
  107551:	57                   	push   %edi
  107552:	56                   	push   %esi
  107553:	53                   	push   %ebx
  107554:	e8 e4 8d ff ff       	call   10033d <__x86.get_pc_thunk.bx>
  107559:	81 c3 9b 7a 00 00    	add    $0x7a9b,%ebx
  10755f:	83 ec 0c             	sub    $0xc,%esp
    unsigned int cur_pid;

    cur_pid = get_curid();
  107562:	e8 89 f4 ff ff       	call   1069f0 <get_curid>
    uctx_pool[cur_pid] = *tf; // save the current user context (trap frame)
  107567:	c7 c5 20 0b dc 00    	mov    $0xdc0b20,%ebp
  10756d:	8b 74 24 20          	mov    0x20(%esp),%esi
    set_pdir_base(0);         // switch to the kernel's page table
  107571:	83 ec 0c             	sub    $0xc,%esp
    uctx_pool[cur_pid] = *tf; // save the current user context (trap frame)
  107574:	6b c0 44             	imul   $0x44,%eax,%eax
  107577:	b9 11 00 00 00       	mov    $0x11,%ecx
  10757c:	01 e8                	add    %ebp,%eax
  10757e:	89 c7                	mov    %eax,%edi
  107580:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    set_pdir_base(0);         // switch to the kernel's page table
  107582:	6a 00                	push   $0x0
  107584:	e8 37 d9 ff ff       	call   104ec0 <set_pdir_base>

    if (T_DIVIDE <= tf->trapno && tf->trapno <= T_SECEV)
  107589:	8b 44 24 30          	mov    0x30(%esp),%eax
  10758d:	83 c4 10             	add    $0x10,%esp
  107590:	8b 40 28             	mov    0x28(%eax),%eax
  107593:	83 f8 1e             	cmp    $0x1e,%eax
  107596:	76 48                	jbe    1075e0 <trap+0x90>
        exception_handler();
    else if (T_IRQ0 + IRQ_TIMER <= tf->trapno && tf->trapno <= T_IRQ0 + IRQ_IDE2)
  107598:	8d 50 e0             	lea    -0x20(%eax),%edx
  10759b:	83 fa 0f             	cmp    $0xf,%edx
  10759e:	76 20                	jbe    1075c0 <trap+0x70>
        interrupt_handler();
    else if (tf->trapno == T_SYSCALL)
  1075a0:	83 f8 30             	cmp    $0x30,%eax
  1075a3:	0f 84 9f 00 00 00    	je     107648 <trap+0xf8>
        syscall_dispatch();

    // Trap handled. Jump back to the user.
    // This is where you switch the TSS and page structure back.
    proc_start_user();
  1075a9:	e8 32 f6 ff ff       	call   106be0 <proc_start_user>
}
  1075ae:	83 c4 0c             	add    $0xc,%esp
  1075b1:	5b                   	pop    %ebx
  1075b2:	5e                   	pop    %esi
  1075b3:	5f                   	pop    %edi
  1075b4:	5d                   	pop    %ebp
  1075b5:	c3                   	ret
  1075b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1075bd:	00 
  1075be:	66 90                	xchg   %ax,%ax
    arg1 = syscall_get_arg1();
  1075c0:	e8 eb f6 ff ff       	call   106cb0 <syscall_get_arg1>
    if (arg1 == T_IRQ0 + IRQ_TIMER)
  1075c5:	83 f8 27             	cmp    $0x27,%eax
  1075c8:	74 df                	je     1075a9 <trap+0x59>
    intr_eoi();
  1075ca:	e8 7c a7 ff ff       	call   101d4b <intr_eoi>
    proc_start_user();
  1075cf:	e8 0c f6 ff ff       	call   106be0 <proc_start_user>
}
  1075d4:	83 c4 0c             	add    $0xc,%esp
  1075d7:	5b                   	pop    %ebx
  1075d8:	5e                   	pop    %esi
  1075d9:	5f                   	pop    %edi
  1075da:	5d                   	pop    %ebp
  1075db:	c3                   	ret
  1075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cur_pid = get_curid();
  1075e0:	e8 0b f4 ff ff       	call   1069f0 <get_curid>
    tf = uctx_pool[cur_pid];
  1075e5:	6b c0 44             	imul   $0x44,%eax,%eax
    if (tf.trapno == T_PGFLT)
  1075e8:	83 7c 05 28 0e       	cmpl   $0xe,0x28(%ebp,%eax,1)
  1075ed:	74 41                	je     107630 <trap+0xe0>
    cur_pid = get_curid();
  1075ef:	e8 fc f3 ff ff       	call   1069f0 <get_curid>
    trap_dump(&uctx_pool[cur_pid]);
  1075f4:	6b f0 44             	imul   $0x44,%eax,%esi
  1075f7:	01 ee                	add    %ebp,%esi
  1075f9:	89 f0                	mov    %esi,%eax
  1075fb:	e8 80 fb ff ff       	call   107180 <trap_dump>
    KERN_PANIC("Trap %d @ 0x%08x.\n", uctx_pool[cur_pid].trapno,
  107600:	83 ec 0c             	sub    $0xc,%esp
  107603:	8d 83 76 97 ff ff    	lea    -0x688a(%ebx),%eax
  107609:	ff 76 30             	push   0x30(%esi)
  10760c:	ff 76 28             	push   0x28(%esi)
  10760f:	50                   	push   %eax
  107610:	8d 83 60 a0 ff ff    	lea    -0x5fa0(%ebx),%eax
  107616:	6a 30                	push   $0x30
  107618:	50                   	push   %eax
  107619:	e8 f1 b3 ff ff       	call   102a0f <debug_panic>
}
  10761e:	83 c4 20             	add    $0x20,%esp
    proc_start_user();
  107621:	e8 ba f5 ff ff       	call   106be0 <proc_start_user>
}
  107626:	83 c4 0c             	add    $0xc,%esp
  107629:	5b                   	pop    %ebx
  10762a:	5e                   	pop    %esi
  10762b:	5f                   	pop    %edi
  10762c:	5d                   	pop    %ebp
  10762d:	c3                   	ret
  10762e:	66 90                	xchg   %ax,%ax
        pgflt_handler();
  107630:	e8 8b fd ff ff       	call   1073c0 <pgflt_handler>
    proc_start_user();
  107635:	e8 a6 f5 ff ff       	call   106be0 <proc_start_user>
}
  10763a:	83 c4 0c             	add    $0xc,%esp
  10763d:	5b                   	pop    %ebx
  10763e:	5e                   	pop    %esi
  10763f:	5f                   	pop    %edi
  107640:	5d                   	pop    %ebp
  107641:	c3                   	ret
  107642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        syscall_dispatch();
  107648:	e8 b3 fa ff ff       	call   107100 <syscall_dispatch>
  10764d:	e9 57 ff ff ff       	jmp    1075a9 <trap+0x59>
  107652:	66 90                	xchg   %ax,%ax
  107654:	66 90                	xchg   %ax,%ax
  107656:	66 90                	xchg   %ax,%ax
  107658:	66 90                	xchg   %ax,%ax
  10765a:	66 90                	xchg   %ax,%ax
  10765c:	66 90                	xchg   %ax,%ax
  10765e:	66 90                	xchg   %ax,%ax

00107660 <__udivdi3>:
  107660:	f3 0f 1e fb          	endbr32
  107664:	55                   	push   %ebp
  107665:	57                   	push   %edi
  107666:	56                   	push   %esi
  107667:	53                   	push   %ebx
  107668:	83 ec 1c             	sub    $0x1c,%esp
  10766b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  10766f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  107673:	8b 74 24 34          	mov    0x34(%esp),%esi
  107677:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  10767b:	85 c0                	test   %eax,%eax
  10767d:	75 19                	jne    107698 <__udivdi3+0x38>
  10767f:	39 de                	cmp    %ebx,%esi
  107681:	73 4d                	jae    1076d0 <__udivdi3+0x70>
  107683:	31 ff                	xor    %edi,%edi
  107685:	89 e8                	mov    %ebp,%eax
  107687:	89 f2                	mov    %esi,%edx
  107689:	f7 f3                	div    %ebx
  10768b:	89 fa                	mov    %edi,%edx
  10768d:	83 c4 1c             	add    $0x1c,%esp
  107690:	5b                   	pop    %ebx
  107691:	5e                   	pop    %esi
  107692:	5f                   	pop    %edi
  107693:	5d                   	pop    %ebp
  107694:	c3                   	ret
  107695:	8d 76 00             	lea    0x0(%esi),%esi
  107698:	39 c6                	cmp    %eax,%esi
  10769a:	73 14                	jae    1076b0 <__udivdi3+0x50>
  10769c:	31 ff                	xor    %edi,%edi
  10769e:	31 c0                	xor    %eax,%eax
  1076a0:	89 fa                	mov    %edi,%edx
  1076a2:	83 c4 1c             	add    $0x1c,%esp
  1076a5:	5b                   	pop    %ebx
  1076a6:	5e                   	pop    %esi
  1076a7:	5f                   	pop    %edi
  1076a8:	5d                   	pop    %ebp
  1076a9:	c3                   	ret
  1076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1076b0:	0f bd f8             	bsr    %eax,%edi
  1076b3:	83 f7 1f             	xor    $0x1f,%edi
  1076b6:	75 48                	jne    107700 <__udivdi3+0xa0>
  1076b8:	39 f0                	cmp    %esi,%eax
  1076ba:	72 06                	jb     1076c2 <__udivdi3+0x62>
  1076bc:	31 c0                	xor    %eax,%eax
  1076be:	39 dd                	cmp    %ebx,%ebp
  1076c0:	72 de                	jb     1076a0 <__udivdi3+0x40>
  1076c2:	b8 01 00 00 00       	mov    $0x1,%eax
  1076c7:	eb d7                	jmp    1076a0 <__udivdi3+0x40>
  1076c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1076d0:	89 d9                	mov    %ebx,%ecx
  1076d2:	85 db                	test   %ebx,%ebx
  1076d4:	75 0b                	jne    1076e1 <__udivdi3+0x81>
  1076d6:	b8 01 00 00 00       	mov    $0x1,%eax
  1076db:	31 d2                	xor    %edx,%edx
  1076dd:	f7 f3                	div    %ebx
  1076df:	89 c1                	mov    %eax,%ecx
  1076e1:	31 d2                	xor    %edx,%edx
  1076e3:	89 f0                	mov    %esi,%eax
  1076e5:	f7 f1                	div    %ecx
  1076e7:	89 c6                	mov    %eax,%esi
  1076e9:	89 e8                	mov    %ebp,%eax
  1076eb:	89 f7                	mov    %esi,%edi
  1076ed:	f7 f1                	div    %ecx
  1076ef:	89 fa                	mov    %edi,%edx
  1076f1:	83 c4 1c             	add    $0x1c,%esp
  1076f4:	5b                   	pop    %ebx
  1076f5:	5e                   	pop    %esi
  1076f6:	5f                   	pop    %edi
  1076f7:	5d                   	pop    %ebp
  1076f8:	c3                   	ret
  1076f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107700:	89 f9                	mov    %edi,%ecx
  107702:	ba 20 00 00 00       	mov    $0x20,%edx
  107707:	29 fa                	sub    %edi,%edx
  107709:	d3 e0                	shl    %cl,%eax
  10770b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10770f:	89 d1                	mov    %edx,%ecx
  107711:	89 d8                	mov    %ebx,%eax
  107713:	d3 e8                	shr    %cl,%eax
  107715:	89 c1                	mov    %eax,%ecx
  107717:	8b 44 24 08          	mov    0x8(%esp),%eax
  10771b:	09 c1                	or     %eax,%ecx
  10771d:	89 f0                	mov    %esi,%eax
  10771f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  107723:	89 f9                	mov    %edi,%ecx
  107725:	d3 e3                	shl    %cl,%ebx
  107727:	89 d1                	mov    %edx,%ecx
  107729:	d3 e8                	shr    %cl,%eax
  10772b:	89 f9                	mov    %edi,%ecx
  10772d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  107731:	89 eb                	mov    %ebp,%ebx
  107733:	d3 e6                	shl    %cl,%esi
  107735:	89 d1                	mov    %edx,%ecx
  107737:	d3 eb                	shr    %cl,%ebx
  107739:	09 f3                	or     %esi,%ebx
  10773b:	89 c6                	mov    %eax,%esi
  10773d:	89 f2                	mov    %esi,%edx
  10773f:	89 d8                	mov    %ebx,%eax
  107741:	f7 74 24 08          	divl   0x8(%esp)
  107745:	89 d6                	mov    %edx,%esi
  107747:	89 c3                	mov    %eax,%ebx
  107749:	f7 64 24 0c          	mull   0xc(%esp)
  10774d:	39 d6                	cmp    %edx,%esi
  10774f:	72 1f                	jb     107770 <__udivdi3+0x110>
  107751:	89 f9                	mov    %edi,%ecx
  107753:	d3 e5                	shl    %cl,%ebp
  107755:	39 c5                	cmp    %eax,%ebp
  107757:	73 04                	jae    10775d <__udivdi3+0xfd>
  107759:	39 d6                	cmp    %edx,%esi
  10775b:	74 13                	je     107770 <__udivdi3+0x110>
  10775d:	89 d8                	mov    %ebx,%eax
  10775f:	31 ff                	xor    %edi,%edi
  107761:	e9 3a ff ff ff       	jmp    1076a0 <__udivdi3+0x40>
  107766:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  10776d:	00 
  10776e:	66 90                	xchg   %ax,%ax
  107770:	8d 43 ff             	lea    -0x1(%ebx),%eax
  107773:	31 ff                	xor    %edi,%edi
  107775:	e9 26 ff ff ff       	jmp    1076a0 <__udivdi3+0x40>
  10777a:	66 90                	xchg   %ax,%ax
  10777c:	66 90                	xchg   %ax,%ax
  10777e:	66 90                	xchg   %ax,%ax

00107780 <__umoddi3>:
  107780:	f3 0f 1e fb          	endbr32
  107784:	55                   	push   %ebp
  107785:	57                   	push   %edi
  107786:	56                   	push   %esi
  107787:	53                   	push   %ebx
  107788:	83 ec 1c             	sub    $0x1c,%esp
  10778b:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  10778f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  107793:	8b 74 24 30          	mov    0x30(%esp),%esi
  107797:	8b 7c 24 38          	mov    0x38(%esp),%edi
  10779b:	89 da                	mov    %ebx,%edx
  10779d:	85 c0                	test   %eax,%eax
  10779f:	75 17                	jne    1077b8 <__umoddi3+0x38>
  1077a1:	39 fb                	cmp    %edi,%ebx
  1077a3:	73 53                	jae    1077f8 <__umoddi3+0x78>
  1077a5:	89 f0                	mov    %esi,%eax
  1077a7:	f7 f7                	div    %edi
  1077a9:	89 d0                	mov    %edx,%eax
  1077ab:	31 d2                	xor    %edx,%edx
  1077ad:	83 c4 1c             	add    $0x1c,%esp
  1077b0:	5b                   	pop    %ebx
  1077b1:	5e                   	pop    %esi
  1077b2:	5f                   	pop    %edi
  1077b3:	5d                   	pop    %ebp
  1077b4:	c3                   	ret
  1077b5:	8d 76 00             	lea    0x0(%esi),%esi
  1077b8:	89 f1                	mov    %esi,%ecx
  1077ba:	39 c3                	cmp    %eax,%ebx
  1077bc:	73 12                	jae    1077d0 <__umoddi3+0x50>
  1077be:	89 f0                	mov    %esi,%eax
  1077c0:	83 c4 1c             	add    $0x1c,%esp
  1077c3:	5b                   	pop    %ebx
  1077c4:	5e                   	pop    %esi
  1077c5:	5f                   	pop    %edi
  1077c6:	5d                   	pop    %ebp
  1077c7:	c3                   	ret
  1077c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  1077cf:	00 
  1077d0:	0f bd e8             	bsr    %eax,%ebp
  1077d3:	83 f5 1f             	xor    $0x1f,%ebp
  1077d6:	75 48                	jne    107820 <__umoddi3+0xa0>
  1077d8:	39 d8                	cmp    %ebx,%eax
  1077da:	0f 82 d8 00 00 00    	jb     1078b8 <__umoddi3+0x138>
  1077e0:	39 fe                	cmp    %edi,%esi
  1077e2:	0f 83 d0 00 00 00    	jae    1078b8 <__umoddi3+0x138>
  1077e8:	89 c8                	mov    %ecx,%eax
  1077ea:	83 c4 1c             	add    $0x1c,%esp
  1077ed:	5b                   	pop    %ebx
  1077ee:	5e                   	pop    %esi
  1077ef:	5f                   	pop    %edi
  1077f0:	5d                   	pop    %ebp
  1077f1:	c3                   	ret
  1077f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1077f8:	89 f9                	mov    %edi,%ecx
  1077fa:	85 ff                	test   %edi,%edi
  1077fc:	75 0b                	jne    107809 <__umoddi3+0x89>
  1077fe:	b8 01 00 00 00       	mov    $0x1,%eax
  107803:	31 d2                	xor    %edx,%edx
  107805:	f7 f7                	div    %edi
  107807:	89 c1                	mov    %eax,%ecx
  107809:	89 d8                	mov    %ebx,%eax
  10780b:	31 d2                	xor    %edx,%edx
  10780d:	f7 f1                	div    %ecx
  10780f:	89 f0                	mov    %esi,%eax
  107811:	f7 f1                	div    %ecx
  107813:	89 d0                	mov    %edx,%eax
  107815:	31 d2                	xor    %edx,%edx
  107817:	eb 94                	jmp    1077ad <__umoddi3+0x2d>
  107819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107820:	ba 20 00 00 00       	mov    $0x20,%edx
  107825:	89 e9                	mov    %ebp,%ecx
  107827:	29 ea                	sub    %ebp,%edx
  107829:	d3 e0                	shl    %cl,%eax
  10782b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10782f:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  107834:	89 44 24 08          	mov    %eax,0x8(%esp)
  107838:	89 f8                	mov    %edi,%eax
  10783a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10783e:	d3 e8                	shr    %cl,%eax
  107840:	89 c1                	mov    %eax,%ecx
  107842:	8b 44 24 08          	mov    0x8(%esp),%eax
  107846:	09 c1                	or     %eax,%ecx
  107848:	89 d8                	mov    %ebx,%eax
  10784a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10784e:	89 e9                	mov    %ebp,%ecx
  107850:	d3 e7                	shl    %cl,%edi
  107852:	89 d1                	mov    %edx,%ecx
  107854:	d3 e8                	shr    %cl,%eax
  107856:	89 e9                	mov    %ebp,%ecx
  107858:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  10785c:	d3 e3                	shl    %cl,%ebx
  10785e:	89 c7                	mov    %eax,%edi
  107860:	89 d1                	mov    %edx,%ecx
  107862:	89 f0                	mov    %esi,%eax
  107864:	d3 e8                	shr    %cl,%eax
  107866:	89 fa                	mov    %edi,%edx
  107868:	89 e9                	mov    %ebp,%ecx
  10786a:	09 d8                	or     %ebx,%eax
  10786c:	d3 e6                	shl    %cl,%esi
  10786e:	f7 74 24 08          	divl   0x8(%esp)
  107872:	89 d3                	mov    %edx,%ebx
  107874:	f7 64 24 0c          	mull   0xc(%esp)
  107878:	89 c7                	mov    %eax,%edi
  10787a:	89 d1                	mov    %edx,%ecx
  10787c:	39 d3                	cmp    %edx,%ebx
  10787e:	72 06                	jb     107886 <__umoddi3+0x106>
  107880:	75 10                	jne    107892 <__umoddi3+0x112>
  107882:	39 c6                	cmp    %eax,%esi
  107884:	73 0c                	jae    107892 <__umoddi3+0x112>
  107886:	2b 44 24 0c          	sub    0xc(%esp),%eax
  10788a:	1b 54 24 08          	sbb    0x8(%esp),%edx
  10788e:	89 d1                	mov    %edx,%ecx
  107890:	89 c7                	mov    %eax,%edi
  107892:	89 f2                	mov    %esi,%edx
  107894:	29 fa                	sub    %edi,%edx
  107896:	19 cb                	sbb    %ecx,%ebx
  107898:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  10789d:	89 d8                	mov    %ebx,%eax
  10789f:	d3 e0                	shl    %cl,%eax
  1078a1:	89 e9                	mov    %ebp,%ecx
  1078a3:	d3 ea                	shr    %cl,%edx
  1078a5:	d3 eb                	shr    %cl,%ebx
  1078a7:	09 d0                	or     %edx,%eax
  1078a9:	89 da                	mov    %ebx,%edx
  1078ab:	83 c4 1c             	add    $0x1c,%esp
  1078ae:	5b                   	pop    %ebx
  1078af:	5e                   	pop    %esi
  1078b0:	5f                   	pop    %edi
  1078b1:	5d                   	pop    %ebp
  1078b2:	c3                   	ret
  1078b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  1078b8:	89 da                	mov    %ebx,%edx
  1078ba:	89 f1                	mov    %esi,%ecx
  1078bc:	29 f9                	sub    %edi,%ecx
  1078be:	19 c2                	sbb    %eax,%edx
  1078c0:	89 c8                	mov    %ecx,%eax
  1078c2:	e9 23 ff ff ff       	jmp    1077ea <__umoddi3+0x6a>
