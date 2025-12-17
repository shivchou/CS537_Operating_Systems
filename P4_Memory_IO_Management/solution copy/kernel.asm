
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 64 21 80       	mov    $0x802164f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 78 10 80       	push   $0x801078e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 85 43 00 00       	call   801043e0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 78 10 80       	push   $0x801078e7
80100097:	50                   	push   %eax
80100098:	e8 13 42 00 00       	call   801042b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 c7 44 00 00       	call   801045b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 e9 43 00 00       	call   80104550 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 41 00 00       	call   801042f0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 78 10 80       	push   $0x801078ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 cd 41 00 00       	call   80104390 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 78 10 80       	push   $0x801078ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 41 00 00       	call   80104390 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 3c 41 00 00       	call   80104350 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 90 43 00 00       	call   801045b0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 df 42 00 00       	jmp    80104550 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 79 10 80       	push   $0x80107906
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 0b 43 00 00       	call   801045b0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 7e 3d 00 00       	call   80104050 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 55 42 00 00       	call   80104550 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 ff 41 00 00       	call   80104550 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 79 10 80       	push   $0x8010790d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 33 84 10 80 	movl   $0x80108433,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 33 40 00 00       	call   80104400 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 79 10 80       	push   $0x80107921
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 5b 00 00       	call   80105f30 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 26 5a 00 00       	call   80105f30 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 5a 00 00       	call   80105f30 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 5a 00 00       	call   80105f30 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ba 41 00 00       	call   80104710 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 05 41 00 00       	call   80104670 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 79 10 80       	push   $0x80107925
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 00 40 00 00       	call   801045b0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 67 3f 00 00       	call   80104550 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 50 79 10 80 	movzbl -0x7fef86b0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 c3 3d 00 00       	call   801045b0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 79 10 80       	mov    $0x80107938,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 f0 3c 00 00       	call   80104550 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 79 10 80       	push   $0x8010793f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 18 3d 00 00       	call   801045b0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 7b 3b 00 00       	call   80104550 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 dd 37 00 00       	jmp    801041f0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 c7 36 00 00       	call   80104110 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 79 10 80       	push   $0x80107948
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 6b 39 00 00       	call   801043e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 bf 2e 00 00       	call   80103980 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 47 66 00 00       	call   80107180 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 f8 63 00 00       	call   80106fa0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 d2 62 00 00       	call   80106eb0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 e0 64 00 00       	call   80107100 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 39 63 00 00       	call   80106fa0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 98 65 00 00       	call   80107220 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 98 3b 00 00       	call   80104870 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 84 3b 00 00       	call   80104870 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 f3 66 00 00       	call   801073f0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ea 63 00 00       	call   80107100 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 88 66 00 00       	call   801073f0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 8a 3a 00 00       	call   80104830 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 4e 5f 00 00       	call   80106d20 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 26 63 00 00       	call   80107100 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 79 10 80       	push   $0x80107961
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 6d 79 10 80       	push   $0x8010796d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 bb 35 00 00       	call   801043e0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 6a 37 00 00       	call   801045b0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 da 36 00 00       	call   80104550 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 c1 36 00 00       	call   80104550 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 fc 36 00 00       	call   801045b0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 7f 36 00 00       	call   80104550 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 79 10 80       	push   $0x80107974
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 aa 36 00 00       	call   801045b0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 0f 36 00 00       	call   80104550 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 dd 35 00 00       	jmp    80104550 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 92 25 00 00       	call   80103540 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 7c 79 10 80       	push   $0x8010797c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 4e 26 00 00       	jmp    801036e0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 86 79 10 80       	push   $0x80107986
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 8f 79 10 80       	push   $0x8010798f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 32 24 00 00       	jmp    801035e0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 95 79 10 80       	push   $0x80107995
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 9f 79 10 80       	push   $0x8010799f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 b2 79 10 80       	push   $0x801079b2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 46 33 00 00       	call   80104670 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 41 32 00 00       	call   801045b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 74 31 00 00       	call   80104550 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 46 31 00 00       	call   80104550 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 c8 79 10 80       	push   $0x801079c8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 d8 79 10 80       	push   $0x801079d8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ca 31 00 00       	call   80104710 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 eb 79 10 80       	push   $0x801079eb
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 65 2e 00 00       	call   801043e0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 f2 79 10 80       	push   $0x801079f2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 1c 2d 00 00       	call   801042b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 4f 31 00 00       	call   80104710 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 58 7a 10 80       	push   $0x80107a58
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 dd 2f 00 00       	call   80104670 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 f8 79 10 80       	push   $0x801079f8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 da 2f 00 00       	call   80104710 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 4c 2e 00 00       	call   801045b0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 dc 2d 00 00       	call   80104550 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 49 2b 00 00       	call   801042f0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 f3 2e 00 00       	call   80104710 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 10 7a 10 80       	push   $0x80107a10
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 0a 7a 10 80       	push   $0x80107a0a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 18 2b 00 00       	call   80104390 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 bc 2a 00 00       	jmp    80104350 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 1f 7a 10 80       	push   $0x80107a1f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 2b 2a 00 00       	call   801042f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 71 2a 00 00       	call   80104350 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 c5 2c 00 00       	call   801045b0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 4b 2c 00 00       	jmp    80104550 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 9b 2c 00 00       	call   801045b0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 2c 2c 00 00       	call   80104550 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 68 29 00 00       	call   80104390 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 11 29 00 00       	call   80104350 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 1f 7a 10 80       	push   $0x80107a1f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 d4 2b 00 00       	call   80104710 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 d8 2a 00 00       	call   80104710 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 ad 2a 00 00       	call   80104780 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 4e 2a 00 00       	call   80104780 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 39 7a 10 80       	push   $0x80107a39
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 27 7a 10 80       	push   $0x80107a27
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 d1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 f1 27 00 00       	call   801045b0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 81 27 00 00       	call   80104550 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 e4 28 00 00       	call   80104710 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 ff 24 00 00       	call   80104390 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 9d 24 00 00       	call   80104350 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 30 28 00 00       	call   80104710 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 60 24 00 00       	call   80104390 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 01 24 00 00       	call   80104350 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 1e 24 00 00       	call   80104390 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 fb 23 00 00       	call   80104390 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 a4 23 00 00       	call   80104350 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 1f 7a 10 80       	push   $0x80107a1f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 8e 27 00 00       	call   801047d0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 48 7a 10 80       	push   $0x80107a48
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 2e 80 10 80       	push   $0x8010802e
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 b4 7a 10 80       	push   $0x80107ab4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 ab 7a 10 80       	push   $0x80107aab
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 c6 7a 10 80       	push   $0x80107ac6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 0b 22 00 00       	call   801043e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 5d 23 00 00       	call   801045b0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 5e 1e 00 00       	call   80104110 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 80 22 00 00       	call   80104550 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 9d 20 00 00       	call   80104390 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 83 22 00 00       	call   801045b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 e2 1c 00 00       	call   80104050 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 c5 21 00 00       	jmp    80104550 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 f5 7a 10 80       	push   $0x80107af5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 e0 7a 10 80       	push   $0x80107ae0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ca 7a 10 80       	push   $0x80107aca
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 14 7b 10 80       	push   $0x80107b14
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb f0 64 21 80    	cmp    $0x802164f0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 79 21 00 00       	call   80104670 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 83 20 00 00       	call   801045b0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 08 20 00 00       	jmp    80104550 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 46 7b 10 80       	push   $0x80107b46
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 4c 7b 10 80       	push   $0x80107b4c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 b6 1d 00 00       	call   801043e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 f8 1e 00 00       	call   801045b0 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 6a 1e 00 00       	call   80104550 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 80 7b 10 80 	movzbl -0x7fef8480(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 26 11 80       	mov    0x80112680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 c4 1b 00 00       	call   801046c0 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 26 11 80    	push   0x801126e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 e7 1a 00 00       	call   80104710 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 26 11 80    	push   0x801126d4
80102c6d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 80 7d 10 80       	push   $0x80107d80
80102ccf:	68 a0 26 11 80       	push   $0x801126a0
80102cd4:	e8 07 17 00 00       	call   801043e0 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 26 11 80       	push   $0x801126a0
80102d6b:	e8 40 18 00 00       	call   801045b0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 26 11 80       	push   $0x801126a0
80102d80:	68 a0 26 11 80       	push   $0x801126a0
80102d85:	e8 c6 12 00 00       	call   80104050 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d9b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102db7:	68 a0 26 11 80       	push   $0x801126a0
80102dbc:	e8 8f 17 00 00       	call   80104550 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 26 11 80       	push   $0x801126a0
80102dde:	e8 cd 17 00 00       	call   801045b0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 2f 17 00 00       	call   80104550 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 26 11 80       	push   $0x801126a0
80102e36:	e8 75 17 00 00       	call   801045b0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 bf 12 00 00       	call   80104110 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e58:	e8 f3 16 00 00       	call   80104550 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e94:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 57 18 00 00       	call   80104710 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 26 11 80       	push   $0x801126a0
80102f08:	e8 03 12 00 00       	call   80104110 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f14:	e8 37 16 00 00       	call   80104550 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 84 7d 10 80       	push   $0x80107d84
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 26 11 80       	push   $0x801126a0
80102f76:	e8 35 16 00 00       	call   801045b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 96 15 00 00       	jmp    80104550 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 93 7d 10 80       	push   $0x80107d93
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 a9 7d 10 80       	push   $0x80107da9
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 54 09 00 00       	call   80103960 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 4d 09 00 00       	call   80103960 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 c4 7d 10 80       	push   $0x80107dc4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 39 2b 00 00       	call   80105b60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 d4 08 00 00       	call   80103900 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 01 0c 00 00       	call   80103c40 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 c5 3c 00 00       	call   80106d10 <switchkvm>
  seginit();
8010304b:	e8 b0 3a 00 00       	call   80106b00 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 f0 64 21 80       	push   $0x802164f0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 7a 41 00 00       	call   80107200 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 95 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 6b 3a 00 00       	call   80106b00 <seginit>
  picinit();       // disable pic
80103095:	e8 86 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 a7 2d 00 00       	call   80105e50 <uartinit>
  pinit();         // process table
801030a9:	e8 32 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 2d 2a 00 00       	call   80105ae0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 37 16 00 00       	call   80104710 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 e2 07 00 00       	call   80103900 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 a0       	push   $0xa0000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  DPUInit();       // setup WISC DPU
80103182:	e8 49 43 00 00       	call   801074d0 <DPUInit>
  SSDInit();       // setup WISC SSD
80103187:	e8 04 45 00 00       	call   80107690 <SSDInit>
  userinit();      // first user process
8010318c:	e8 1f 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103191:	e8 6a fe ff ff       	call   80103000 <mpmain>
80103196:	66 90                	xchg   %ax,%ax
80103198:	66 90                	xchg   %ax,%ax
8010319a:	66 90                	xchg   %ax,%ax
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 d8 7d 10 80       	push   $0x80107dd8
801031d3:	56                   	push   %esi
801031d4:	e8 e7 14 00 00       	call   801046c0 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031eb:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
80103225:	53                   	push   %ebx
80103226:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103229:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103230:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103237:	c1 e0 08             	shl    $0x8,%eax
8010323a:	09 d0                	or     %edx,%eax
8010323c:	c1 e0 04             	shl    $0x4,%eax
8010323f:	75 1b                	jne    8010325c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103241:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103248:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010324f:	c1 e0 08             	shl    $0x8,%eax
80103252:	09 d0                	or     %edx,%eax
80103254:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103257:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010325c:	ba 00 04 00 00       	mov    $0x400,%edx
80103261:	e8 3a ff ff ff       	call   801031a0 <mpsearch1>
80103266:	89 c3                	mov    %eax,%ebx
80103268:	85 c0                	test   %eax,%eax
8010326a:	0f 84 40 01 00 00    	je     801033b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103270:	8b 73 04             	mov    0x4(%ebx),%esi
80103273:	85 f6                	test   %esi,%esi
80103275:	0f 84 25 01 00 00    	je     801033a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103284:	6a 04                	push   $0x4
80103286:	68 dd 7d 10 80       	push   $0x80107ddd
8010328b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010328c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010328f:	e8 2c 14 00 00       	call   801046c0 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 01 01 00 00    	jne    801033a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010329f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032a6:	3c 01                	cmp    $0x1,%al
801032a8:	74 08                	je     801032b2 <mpinit+0x92>
801032aa:	3c 04                	cmp    $0x4,%al
801032ac:	0f 85 ee 00 00 00    	jne    801033a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032b9:	66 85 d2             	test   %dx,%dx
801032bc:	74 22                	je     801032e0 <mpinit+0xc0>
801032be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032c3:	31 d2                	xor    %edx,%edx
801032c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032d4:	39 c7                	cmp    %eax,%edi
801032d6:	75 f0                	jne    801032c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032d8:	84 d2                	test   %dl,%dl
801032da:	0f 85 c0 00 00 00    	jne    801033a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032e6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103300:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103307:	90                   	nop
80103308:	39 d0                	cmp    %edx,%eax
8010330a:	73 15                	jae    80103321 <mpinit+0x101>
    switch(*p){
8010330c:	0f b6 08             	movzbl (%eax),%ecx
8010330f:	80 f9 02             	cmp    $0x2,%cl
80103312:	74 4c                	je     80103360 <mpinit+0x140>
80103314:	77 3a                	ja     80103350 <mpinit+0x130>
80103316:	84 c9                	test   %cl,%cl
80103318:	74 56                	je     80103370 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010331a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331d:	39 d0                	cmp    %edx,%eax
8010331f:	72 eb                	jb     8010330c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103321:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103324:	85 f6                	test   %esi,%esi
80103326:	0f 84 d9 00 00 00    	je     80103405 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010332c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103330:	74 15                	je     80103347 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103332:	b8 70 00 00 00       	mov    $0x70,%eax
80103337:	ba 22 00 00 00       	mov    $0x22,%edx
8010333c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333d:	ba 23 00 00 00       	mov    $0x23,%edx
80103342:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103343:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ee                   	out    %al,(%dx)
  }
}
80103347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334a:	5b                   	pop    %ebx
8010334b:	5e                   	pop    %esi
8010334c:	5f                   	pop    %edi
8010334d:	5d                   	pop    %ebp
8010334e:	c3                   	ret    
8010334f:	90                   	nop
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 c2                	jbe    8010331a <mpinit+0xfa>
80103358:	31 f6                	xor    %esi,%esi
8010335a:	eb ac                	jmp    80103308 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010336d:	eb 99                	jmp    80103308 <mpinit+0xe8>
8010336f:	90                   	nop
      if(ncpu < NCPU) {
80103370:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 6c ff ff ff       	jmp    80103308 <mpinit+0xe8>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 e2 7d 10 80       	push   $0x80107de2
801033a8:	e8 d3 cf ff ff       	call   80100380 <panic>
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033b5:	eb 13                	jmp    801033ca <mpinit+0x1aa>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 d6                	je     801033a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 d8 7d 10 80       	push   $0x80107dd8
801033d7:	53                   	push   %ebx
801033d8:	e8 e3 12 00 00       	call   801046c0 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1a0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1a0>
80103400:	e9 6b fe ff ff       	jmp    80103270 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 fc 7d 10 80       	push   $0x80107dfc
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret    
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 d0 d9 ff ff       	call   80100e30 <filealloc>
80103460:	89 03                	mov    %eax,(%ebx)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a8 00 00 00    	je     80103512 <pipealloc+0xd2>
8010346a:	e8 c1 d9 ff ff       	call   80100e30 <filealloc>
8010346f:	89 06                	mov    %eax,(%esi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 87 00 00 00    	je     80103500 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 02 f2 ff ff       	call   80102680 <kalloc>
8010347e:	89 c7                	mov    %eax,%edi
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 b0 00 00 00    	je     80103538 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 1b 7e 10 80       	push   $0x80107e1b
801034b8:	50                   	push   %eax
801034b9:	e8 22 0f 00 00       	call   801043e0 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 03                	mov    (%ebx),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 03                	mov    (%ebx),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 03                	mov    (%ebx),%eax
801034d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 06                	mov    (%esi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 06                	mov    (%esi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034f6:	31 c0                	xor    %eax,%eax
}
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret    
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	74 1e                	je     80103524 <pipealloc+0xe4>
    fileclose(*f0);
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	50                   	push   %eax
8010350a:	e8 e1 d9 ff ff       	call   80100ef0 <fileclose>
8010350f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103512:	8b 06                	mov    (%esi),%eax
80103514:	85 c0                	test   %eax,%eax
80103516:	74 0c                	je     80103524 <pipealloc+0xe4>
    fileclose(*f1);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	50                   	push   %eax
8010351c:	e8 cf d9 ff ff       	call   80100ef0 <fileclose>
80103521:	83 c4 10             	add    $0x10,%esp
}
80103524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 c8                	jne    80103506 <pipealloc+0xc6>
8010353e:	eb d2                	jmp    80103512 <pipealloc+0xd2>

80103540 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103548:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	53                   	push   %ebx
8010354f:	e8 5c 10 00 00       	call   801045b0 <acquire>
  if(writable){
80103554:	83 c4 10             	add    $0x10,%esp
80103557:	85 f6                	test   %esi,%esi
80103559:	74 65                	je     801035c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103564:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010356b:	00 00 00 
    wakeup(&p->nread);
8010356e:	50                   	push   %eax
8010356f:	e8 9c 0b 00 00       	call   80104110 <wakeup>
80103574:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103577:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010357d:	85 d2                	test   %edx,%edx
8010357f:	75 0a                	jne    8010358b <pipeclose+0x4b>
80103581:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103587:	85 c0                	test   %eax,%eax
80103589:	74 15                	je     801035a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010358b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010358e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103591:	5b                   	pop    %ebx
80103592:	5e                   	pop    %esi
80103593:	5d                   	pop    %ebp
    release(&p->lock);
80103594:	e9 b7 0f 00 00       	jmp    80104550 <release>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 a7 0f 00 00       	call   80104550 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 06 ef ff ff       	jmp    801024c0 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 37 0b 00 00       	call   80104110 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb 99                	jmp    80103577 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 28             	sub    $0x28,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ec:	53                   	push   %ebx
801035ed:	e8 be 0f 00 00       	call   801045b0 <acquire>
  for(i = 0; i < n; i++){
801035f2:	8b 45 10             	mov    0x10(%ebp),%eax
801035f5:	83 c4 10             	add    $0x10,%esp
801035f8:	85 c0                	test   %eax,%eax
801035fa:	0f 8e c0 00 00 00    	jle    801036c0 <pipewrite+0xe0>
80103600:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103603:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103609:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103612:	03 45 10             	add    0x10(%ebp),%eax
80103615:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103624:	89 ca                	mov    %ecx,%edx
80103626:	05 00 02 00 00       	add    $0x200,%eax
8010362b:	39 c1                	cmp    %eax,%ecx
8010362d:	74 3f                	je     8010366e <pipewrite+0x8e>
8010362f:	eb 67                	jmp    80103698 <pipewrite+0xb8>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103638:	e8 43 03 00 00       	call   80103980 <myproc>
8010363d:	8b 48 24             	mov    0x24(%eax),%ecx
80103640:	85 c9                	test   %ecx,%ecx
80103642:	75 34                	jne    80103678 <pipewrite+0x98>
      wakeup(&p->nread);
80103644:	83 ec 0c             	sub    $0xc,%esp
80103647:	57                   	push   %edi
80103648:	e8 c3 0a 00 00       	call   80104110 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	53                   	push   %ebx
80103650:	56                   	push   %esi
80103651:	e8 fa 09 00 00       	call   80104050 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103656:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010365c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103662:	83 c4 10             	add    $0x10,%esp
80103665:	05 00 02 00 00       	add    $0x200,%eax
8010366a:	39 c2                	cmp    %eax,%edx
8010366c:	75 2a                	jne    80103698 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010366e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103674:	85 c0                	test   %eax,%eax
80103676:	75 c0                	jne    80103638 <pipewrite+0x58>
        release(&p->lock);
80103678:	83 ec 0c             	sub    $0xc,%esp
8010367b:	53                   	push   %ebx
8010367c:	e8 cf 0e 00 00       	call   80104550 <release>
        return -1;
80103681:	83 c4 10             	add    $0x10,%esp
80103684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368c:	5b                   	pop    %ebx
8010368d:	5e                   	pop    %esi
8010368e:	5f                   	pop    %edi
8010368f:	5d                   	pop    %ebp
80103690:	c3                   	ret    
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103698:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010369b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010369e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036ad:	83 c6 01             	add    $0x1,%esi
801036b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ba:	0f 85 58 ff ff ff    	jne    80103618 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c9:	50                   	push   %eax
801036ca:	e8 41 0a 00 00       	call   80104110 <wakeup>
  release(&p->lock);
801036cf:	89 1c 24             	mov    %ebx,(%esp)
801036d2:	e8 79 0e 00 00       	call   80104550 <release>
  return n;
801036d7:	8b 45 10             	mov    0x10(%ebp),%eax
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	eb aa                	jmp    80103689 <pipewrite+0xa9>
801036df:	90                   	nop

801036e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
801036e9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ef:	56                   	push   %esi
801036f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036f6:	e8 b5 0e 00 00       	call   801045b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010370a:	74 2f                	je     8010373b <piperead+0x5b>
8010370c:	eb 37                	jmp    80103745 <piperead+0x65>
8010370e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103710:	e8 6b 02 00 00       	call   80103980 <myproc>
80103715:	8b 48 24             	mov    0x24(%eax),%ecx
80103718:	85 c9                	test   %ecx,%ecx
8010371a:	0f 85 80 00 00 00    	jne    801037a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103720:	83 ec 08             	sub    $0x8,%esp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	e8 26 09 00 00       	call   80104050 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010372a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103739:	75 0a                	jne    80103745 <piperead+0x65>
8010373b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 cb                	jne    80103710 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103745:	8b 55 10             	mov    0x10(%ebp),%edx
80103748:	31 db                	xor    %ebx,%ebx
8010374a:	85 d2                	test   %edx,%edx
8010374c:	7f 20                	jg     8010376e <piperead+0x8e>
8010374e:	eb 2c                	jmp    8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 85 09 00 00       	call   80104110 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 bd 0d 00 00       	call   80104550 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 a2 0d 00 00       	call   80104550 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037cc:	68 20 2d 11 80       	push   $0x80112d20
801037d1:	e8 da 0d 00 00       	call   801045b0 <acquire>
801037d6:	83 c4 10             	add    $0x10,%esp
801037d9:	eb 10                	jmp    801037eb <allocproc+0x2b>
801037db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	83 c3 7c             	add    $0x7c,%ebx
801037e3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801037e9:	74 75                	je     80103860 <allocproc+0xa0>
    if(p->state == UNUSED)
801037eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801037ee:	85 c0                	test   %eax,%eax
801037f0:	75 ee                	jne    801037e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103801:	89 43 10             	mov    %eax,0x10(%ebx)
80103804:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103807:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010380c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103812:	e8 39 0d 00 00       	call   80104550 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103817:	e8 64 ee ff ff       	call   80102680 <kalloc>
8010381c:	83 c4 10             	add    $0x10,%esp
8010381f:	89 43 08             	mov    %eax,0x8(%ebx)
80103822:	85 c0                	test   %eax,%eax
80103824:	74 53                	je     80103879 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103826:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010382c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010382f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103834:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103837:	c7 40 14 d2 5a 10 80 	movl   $0x80105ad2,0x14(%eax)
  p->context = (struct context*)sp;
8010383e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103841:	6a 14                	push   $0x14
80103843:	6a 00                	push   $0x0
80103845:	50                   	push   %eax
80103846:	e8 25 0e 00 00       	call   80104670 <memset>
  p->context->eip = (uint)forkret;
8010384b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010384e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103851:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
80103858:	89 d8                	mov    %ebx,%eax
8010385a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385d:	c9                   	leave  
8010385e:	c3                   	ret    
8010385f:	90                   	nop
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 20 2d 11 80       	push   $0x80112d20
8010386a:	e8 e1 0c 00 00       	call   80104550 <release>
}
8010386f:	89 d8                	mov    %ebx,%eax
  return 0;
80103871:	83 c4 10             	add    $0x10,%esp
}
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103880:	31 db                	xor    %ebx,%ebx
}
80103882:	89 d8                	mov    %ebx,%eax
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 20 2d 11 80       	push   $0x80112d20
8010389b:	e8 b0 0c 00 00       	call   80104550 <release>

  if (first) {
801038a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave  
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 9c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 f0 f3 ff ff       	call   80102cc0 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
801038d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 20 7e 10 80       	push   $0x80107e20
801038eb:	68 20 2d 11 80       	push   $0x80112d20
801038f0:	e8 eb 0a 00 00       	call   801043e0 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf  
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 df ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret    
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 27 7e 10 80       	push   $0x80107e27
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 04 7f 10 80       	push   $0x80107f04
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave  
  return mycpu()-cpus;
8010396c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret    
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 d4 0a 00 00       	call   80104460 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 14 0b 00 00       	call   801044b0 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave  
801039a2:	c3                   	ret    
801039a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 04 fe ff ff       	call   801037c0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 b8 37 00 00       	call   80107180 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 b4 10 80       	push   $0x8010b460
801039e0:	50                   	push   %eax
801039e1:	e8 4a 34 00 00       	call   80106e30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 75 0c 00 00       	call   80104670 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 50 7e 10 80       	push   $0x80107e50
80103a54:	50                   	push   %eax
80103a55:	e8 d6 0d 00 00       	call   80104830 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 59 7e 10 80 	movl   $0x80107e59,(%esp)
80103a61:	e8 3a e6 ff ff       	call   801020a0 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a70:	e8 3b 0b 00 00       	call   801045b0 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a83:	e8 c8 0a 00 00       	call   80104550 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 37 7e 10 80       	push   $0x80107e37
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 b3 09 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 f3 09 00 00       	call   801044b0 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 50 32 00 00       	call   80106d20 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret    
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 b1 34 00 00       	call   80106fa0 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 c1 35 00 00       	call   801070d0 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 32 09 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 72 09 00 00       	call   801044b0 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 7d fc ff ff       	call   801037c0 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 b7 00 00 00    	je     80103c05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 13 37 00 00       	call   80107270 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 a1 00 00 00    	je     80103c0c <fork+0xec>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b75:	89 c8                	mov    %ecx,%eax
80103b77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 ff d2 ff ff       	call   80100ea0 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bb3:	83 ec 0c             	sub    $0xc,%esp
80103bb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bbc:	e8 8f db ff ff       	call   80101750 <idup>
80103bc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bcd:	6a 10                	push   $0x10
80103bcf:	53                   	push   %ebx
80103bd0:	50                   	push   %eax
80103bd1:	e8 5a 0c 00 00       	call   80104830 <safestrcpy>
  pid = np->pid;
80103bd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bd9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be0:	e8 cb 09 00 00       	call   801045b0 <acquire>
  np->state = RUNNABLE;
80103be5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf3:	e8 58 09 00 00       	call   80104550 <release>
  return pid;
80103bf8:	83 c4 10             	add    $0x10,%esp
}
80103bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bfe:	89 d8                	mov    %ebx,%eax
80103c00:	5b                   	pop    %ebx
80103c01:	5e                   	pop    %esi
80103c02:	5f                   	pop    %edi
80103c03:	5d                   	pop    %ebp
80103c04:	c3                   	ret    
    return -1;
80103c05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c0a:	eb ef                	jmp    80103bfb <fork+0xdb>
    kfree(np->kstack);
80103c0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c0f:	83 ec 0c             	sub    $0xc,%esp
80103c12:	ff 73 08             	push   0x8(%ebx)
80103c15:	e8 a6 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c21:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c30:	eb c9                	jmp    80103bfb <fork+0xdb>
80103c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c40 <scheduler>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c49:	e8 b2 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103c4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c55:	00 00 00 
  struct cpu *c = mycpu();
80103c58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c5a:	8d 78 04             	lea    0x4(%eax),%edi
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c60:	fb                   	sti    
    acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c64:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c69:	68 20 2d 11 80       	push   $0x80112d20
80103c6e:	e8 3d 09 00 00       	call   801045b0 <acquire>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c84:	75 33                	jne    80103cb9 <scheduler+0x79>
      switchuvm(p);
80103c86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c8f:	53                   	push   %ebx
80103c90:	e8 8b 30 00 00       	call   80106d20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c95:	58                   	pop    %eax
80103c96:	5a                   	pop    %edx
80103c97:	ff 73 1c             	push   0x1c(%ebx)
80103c9a:	57                   	push   %edi
      p->state = RUNNING;
80103c9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ca2:	e8 e4 0b 00 00       	call   8010488b <swtch>
      switchkvm();
80103ca7:	e8 64 30 00 00       	call   80106d10 <switchkvm>
      c->proc = 0;
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb9:	83 c3 7c             	add    $0x7c,%ebx
80103cbc:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103cc2:	75 bc                	jne    80103c80 <scheduler+0x40>
    release(&ptable.lock);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 20 2d 11 80       	push   $0x80112d20
80103ccc:	e8 7f 08 00 00       	call   80104550 <release>
    sti();
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	eb 8a                	jmp    80103c60 <scheduler+0x20>
80103cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi

80103ce0 <sched>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 76 07 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103cea:	e8 11 fc ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf5:	e8 b6 07 00 00       	call   801044b0 <popcli>
  if(!holding(&ptable.lock))
80103cfa:	83 ec 0c             	sub    $0xc,%esp
80103cfd:	68 20 2d 11 80       	push   $0x80112d20
80103d02:	e8 09 08 00 00       	call   80104510 <holding>
80103d07:	83 c4 10             	add    $0x10,%esp
80103d0a:	85 c0                	test   %eax,%eax
80103d0c:	74 4f                	je     80103d5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d0e:	e8 ed fb ff ff       	call   80103900 <mycpu>
80103d13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d1a:	75 68                	jne    80103d84 <sched+0xa4>
  if(p->state == RUNNING)
80103d1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d20:	74 55                	je     80103d77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d22:	9c                   	pushf  
80103d23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d24:	f6 c4 02             	test   $0x2,%ah
80103d27:	75 41                	jne    80103d6a <sched+0x8a>
  intena = mycpu()->intena;
80103d29:	e8 d2 fb ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d37:	e8 c4 fb ff ff       	call   80103900 <mycpu>
80103d3c:	83 ec 08             	sub    $0x8,%esp
80103d3f:	ff 70 04             	push   0x4(%eax)
80103d42:	53                   	push   %ebx
80103d43:	e8 43 0b 00 00       	call   8010488b <swtch>
  mycpu()->intena = intena;
80103d48:	e8 b3 fb ff ff       	call   80103900 <mycpu>
}
80103d4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret    
    panic("sched ptable.lock");
80103d5d:	83 ec 0c             	sub    $0xc,%esp
80103d60:	68 5b 7e 10 80       	push   $0x80107e5b
80103d65:	e8 16 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	68 87 7e 10 80       	push   $0x80107e87
80103d72:	e8 09 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	68 79 7e 10 80       	push   $0x80107e79
80103d7f:	e8 fc c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 6d 7e 10 80       	push   $0x80107e6d
80103d8c:	e8 ef c5 ff ff       	call   80100380 <panic>
80103d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9f:	90                   	nop

80103da0 <exit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103da9:	e8 d2 fb ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103dae:	39 05 54 4c 11 80    	cmp    %eax,0x80114c54
80103db4:	0f 84 fd 00 00 00    	je     80103eb7 <exit+0x117>
80103dba:	89 c3                	mov    %eax,%ebx
80103dbc:	8d 70 28             	lea    0x28(%eax),%esi
80103dbf:	8d 78 68             	lea    0x68(%eax),%edi
80103dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dc8:	8b 06                	mov    (%esi),%eax
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 12                	je     80103de0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	50                   	push   %eax
80103dd2:	e8 19 d1 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103dd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ddd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103de0:	83 c6 04             	add    $0x4,%esi
80103de3:	39 f7                	cmp    %esi,%edi
80103de5:	75 e1                	jne    80103dc8 <exit+0x28>
  begin_op();
80103de7:	e8 74 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103dec:	83 ec 0c             	sub    $0xc,%esp
80103def:	ff 73 68             	push   0x68(%ebx)
80103df2:	e8 b9 da ff ff       	call   801018b0 <iput>
  end_op();
80103df7:	e8 d4 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103dfc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e03:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e0a:	e8 a1 07 00 00       	call   801045b0 <acquire>
  wakeup1(curproc->parent);
80103e0f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e12:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e15:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e1a:	eb 0e                	jmp    80103e2a <exit+0x8a>
80103e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e20:	83 c0 7c             	add    $0x7c,%eax
80103e23:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e28:	74 1c                	je     80103e46 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e2e:	75 f0                	jne    80103e20 <exit+0x80>
80103e30:	3b 50 20             	cmp    0x20(%eax),%edx
80103e33:	75 eb                	jne    80103e20 <exit+0x80>
      p->state = RUNNABLE;
80103e35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3c:	83 c0 7c             	add    $0x7c,%eax
80103e3f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e44:	75 e4                	jne    80103e2a <exit+0x8a>
      p->parent = initproc;
80103e46:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e51:	eb 10                	jmp    80103e63 <exit+0xc3>
80103e53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e57:	90                   	nop
80103e58:	83 c2 7c             	add    $0x7c,%edx
80103e5b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103e61:	74 3b                	je     80103e9e <exit+0xfe>
    if(p->parent == curproc){
80103e63:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e66:	75 f0                	jne    80103e58 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e68:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e6c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e6f:	75 e7                	jne    80103e58 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e71:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e76:	eb 12                	jmp    80103e8a <exit+0xea>
80103e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop
80103e80:	83 c0 7c             	add    $0x7c,%eax
80103e83:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e88:	74 ce                	je     80103e58 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0xe0>
80103e90:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e93:	75 eb                	jne    80103e80 <exit+0xe0>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e9c:	eb e2                	jmp    80103e80 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e9e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ea5:	e8 36 fe ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 a8 7e 10 80       	push   $0x80107ea8
80103eb2:	e8 c9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 9b 7e 10 80       	push   $0x80107e9b
80103ebf:	e8 bc c4 ff ff       	call   80100380 <panic>
80103ec4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ecf:	90                   	nop

80103ed0 <wait>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	56                   	push   %esi
80103ed4:	53                   	push   %ebx
  pushcli();
80103ed5:	e8 86 05 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103eda:	e8 21 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103edf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ee5:	e8 c6 05 00 00       	call   801044b0 <popcli>
  acquire(&ptable.lock);
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 20 2d 11 80       	push   $0x80112d20
80103ef2:	e8 b9 06 00 00       	call   801045b0 <acquire>
80103ef7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103efa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f01:	eb 10                	jmp    80103f13 <wait+0x43>
80103f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f07:	90                   	nop
80103f08:	83 c3 7c             	add    $0x7c,%ebx
80103f0b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f11:	74 1b                	je     80103f2e <wait+0x5e>
      if(p->parent != curproc)
80103f13:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f16:	75 f0                	jne    80103f08 <wait+0x38>
      if(p->state == ZOMBIE){
80103f18:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f1c:	74 62                	je     80103f80 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f21:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f26:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f2c:	75 e5                	jne    80103f13 <wait+0x43>
    if(!havekids || curproc->killed){
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	0f 84 a0 00 00 00    	je     80103fd6 <wait+0x106>
80103f36:	8b 46 24             	mov    0x24(%esi),%eax
80103f39:	85 c0                	test   %eax,%eax
80103f3b:	0f 85 95 00 00 00    	jne    80103fd6 <wait+0x106>
  pushcli();
80103f41:	e8 1a 05 00 00       	call   80104460 <pushcli>
  c = mycpu();
80103f46:	e8 b5 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f51:	e8 5a 05 00 00       	call   801044b0 <popcli>
  if(p == 0)
80103f56:	85 db                	test   %ebx,%ebx
80103f58:	0f 84 8f 00 00 00    	je     80103fed <wait+0x11d>
  p->chan = chan;
80103f5e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f61:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f68:	e8 73 fd ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103f6d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f74:	eb 84                	jmp    80103efa <wait+0x2a>
80103f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f80:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f83:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f86:	ff 73 08             	push   0x8(%ebx)
80103f89:	e8 32 e5 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80103f8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f95:	5a                   	pop    %edx
80103f96:	ff 73 04             	push   0x4(%ebx)
80103f99:	e8 62 31 00 00       	call   80107100 <freevm>
        p->pid = 0;
80103f9e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fa5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fb0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fbe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fc5:	e8 86 05 00 00       	call   80104550 <release>
        return pid;
80103fca:	83 c4 10             	add    $0x10,%esp
}
80103fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd0:	89 f0                	mov    %esi,%eax
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5d                   	pop    %ebp
80103fd5:	c3                   	ret    
      release(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fd9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fde:	68 20 2d 11 80       	push   $0x80112d20
80103fe3:	e8 68 05 00 00       	call   80104550 <release>
      return -1;
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	eb e0                	jmp    80103fcd <wait+0xfd>
    panic("sleep");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 b4 7e 10 80       	push   $0x80107eb4
80103ff5:	e8 86 c3 ff ff       	call   80100380 <panic>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104000 <yield>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104007:	68 20 2d 11 80       	push   $0x80112d20
8010400c:	e8 9f 05 00 00       	call   801045b0 <acquire>
  pushcli();
80104011:	e8 4a 04 00 00       	call   80104460 <pushcli>
  c = mycpu();
80104016:	e8 e5 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010401b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104021:	e8 8a 04 00 00       	call   801044b0 <popcli>
  myproc()->state = RUNNABLE;
80104026:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010402d:	e8 ae fc ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
80104032:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104039:	e8 12 05 00 00       	call   80104550 <release>
}
8010403e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104041:	83 c4 10             	add    $0x10,%esp
80104044:	c9                   	leave  
80104045:	c3                   	ret    
80104046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404d:	8d 76 00             	lea    0x0(%esi),%esi

80104050 <sleep>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	8b 7d 08             	mov    0x8(%ebp),%edi
8010405c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010405f:	e8 fc 03 00 00       	call   80104460 <pushcli>
  c = mycpu();
80104064:	e8 97 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104069:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010406f:	e8 3c 04 00 00       	call   801044b0 <popcli>
  if(p == 0)
80104074:	85 db                	test   %ebx,%ebx
80104076:	0f 84 87 00 00 00    	je     80104103 <sleep+0xb3>
  if(lk == 0)
8010407c:	85 f6                	test   %esi,%esi
8010407e:	74 76                	je     801040f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104080:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104086:	74 50                	je     801040d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 20 2d 11 80       	push   $0x80112d20
80104090:	e8 1b 05 00 00       	call   801045b0 <acquire>
    release(lk);
80104095:	89 34 24             	mov    %esi,(%esp)
80104098:	e8 b3 04 00 00       	call   80104550 <release>
  p->chan = chan;
8010409d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040a7:	e8 34 fc ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040b3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040ba:	e8 91 04 00 00       	call   80104550 <release>
    acquire(lk);
801040bf:	89 75 08             	mov    %esi,0x8(%ebp)
801040c2:	83 c4 10             	add    $0x10,%esp
}
801040c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c8:	5b                   	pop    %ebx
801040c9:	5e                   	pop    %esi
801040ca:	5f                   	pop    %edi
801040cb:	5d                   	pop    %ebp
    acquire(lk);
801040cc:	e9 df 04 00 00       	jmp    801045b0 <acquire>
801040d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040e2:	e8 f9 fb ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f1:	5b                   	pop    %ebx
801040f2:	5e                   	pop    %esi
801040f3:	5f                   	pop    %edi
801040f4:	5d                   	pop    %ebp
801040f5:	c3                   	ret    
    panic("sleep without lk");
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	68 ba 7e 10 80       	push   $0x80107eba
801040fe:	e8 7d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104103:	83 ec 0c             	sub    $0xc,%esp
80104106:	68 b4 7e 10 80       	push   $0x80107eb4
8010410b:	e8 70 c2 ff ff       	call   80100380 <panic>

80104110 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010411a:	68 20 2d 11 80       	push   $0x80112d20
8010411f:	e8 8c 04 00 00       	call   801045b0 <acquire>
80104124:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104127:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010412c:	eb 0c                	jmp    8010413a <wakeup+0x2a>
8010412e:	66 90                	xchg   %ax,%ax
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104138:	74 1c                	je     80104156 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010413a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010413e:	75 f0                	jne    80104130 <wakeup+0x20>
80104140:	3b 58 20             	cmp    0x20(%eax),%ebx
80104143:	75 eb                	jne    80104130 <wakeup+0x20>
      p->state = RUNNABLE;
80104145:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414c:	83 c0 7c             	add    $0x7c,%eax
8010414f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104154:	75 e4                	jne    8010413a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104156:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010415d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104160:	c9                   	leave  
  release(&ptable.lock);
80104161:	e9 ea 03 00 00       	jmp    80104550 <release>
80104166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416d:	8d 76 00             	lea    0x0(%esi),%esi

80104170 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 10             	sub    $0x10,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010417a:	68 20 2d 11 80       	push   $0x80112d20
8010417f:	e8 2c 04 00 00       	call   801045b0 <acquire>
80104184:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104187:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010418c:	eb 0c                	jmp    8010419a <kill+0x2a>
8010418e:	66 90                	xchg   %ax,%ax
80104190:	83 c0 7c             	add    $0x7c,%eax
80104193:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104198:	74 36                	je     801041d0 <kill+0x60>
    if(p->pid == pid){
8010419a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010419d:	75 f1                	jne    80104190 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010419f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041aa:	75 07                	jne    801041b3 <kill+0x43>
        p->state = RUNNABLE;
801041ac:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 20 2d 11 80       	push   $0x80112d20
801041bb:	e8 90 03 00 00       	call   80104550 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041c3:	83 c4 10             	add    $0x10,%esp
801041c6:	31 c0                	xor    %eax,%eax
}
801041c8:	c9                   	leave  
801041c9:	c3                   	ret    
801041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041d0:	83 ec 0c             	sub    $0xc,%esp
801041d3:	68 20 2d 11 80       	push   $0x80112d20
801041d8:	e8 73 03 00 00       	call   80104550 <release>
}
801041dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041e0:	83 c4 10             	add    $0x10,%esp
801041e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e8:	c9                   	leave  
801041e9:	c3                   	ret    
801041ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041f8:	53                   	push   %ebx
801041f9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801041fe:	83 ec 3c             	sub    $0x3c,%esp
80104201:	eb 24                	jmp    80104227 <procdump+0x37>
80104203:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104207:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 33 84 10 80       	push   $0x80108433
80104210:	e8 8b c4 ff ff       	call   801006a0 <cprintf>
80104215:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104218:	83 c3 7c             	add    $0x7c,%ebx
8010421b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104221:	0f 84 81 00 00 00    	je     801042a8 <procdump+0xb8>
    if(p->state == UNUSED)
80104227:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010422a:	85 c0                	test   %eax,%eax
8010422c:	74 ea                	je     80104218 <procdump+0x28>
      state = "???";
8010422e:	ba cb 7e 10 80       	mov    $0x80107ecb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104233:	83 f8 05             	cmp    $0x5,%eax
80104236:	77 11                	ja     80104249 <procdump+0x59>
80104238:	8b 14 85 2c 7f 10 80 	mov    -0x7fef80d4(,%eax,4),%edx
      state = "???";
8010423f:	b8 cb 7e 10 80       	mov    $0x80107ecb,%eax
80104244:	85 d2                	test   %edx,%edx
80104246:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104249:	53                   	push   %ebx
8010424a:	52                   	push   %edx
8010424b:	ff 73 a4             	push   -0x5c(%ebx)
8010424e:	68 cf 7e 10 80       	push   $0x80107ecf
80104253:	e8 48 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104258:	83 c4 10             	add    $0x10,%esp
8010425b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010425f:	75 a7                	jne    80104208 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104261:	83 ec 08             	sub    $0x8,%esp
80104264:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104267:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010426a:	50                   	push   %eax
8010426b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010426e:	8b 40 0c             	mov    0xc(%eax),%eax
80104271:	83 c0 08             	add    $0x8,%eax
80104274:	50                   	push   %eax
80104275:	e8 86 01 00 00       	call   80104400 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010427a:	83 c4 10             	add    $0x10,%esp
8010427d:	8d 76 00             	lea    0x0(%esi),%esi
80104280:	8b 17                	mov    (%edi),%edx
80104282:	85 d2                	test   %edx,%edx
80104284:	74 82                	je     80104208 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104286:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104289:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010428c:	52                   	push   %edx
8010428d:	68 21 79 10 80       	push   $0x80107921
80104292:	e8 09 c4 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	39 fe                	cmp    %edi,%esi
8010429c:	75 e2                	jne    80104280 <procdump+0x90>
8010429e:	e9 65 ff ff ff       	jmp    80104208 <procdump+0x18>
801042a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a7:	90                   	nop
  }
}
801042a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ab:	5b                   	pop    %ebx
801042ac:	5e                   	pop    %esi
801042ad:	5f                   	pop    %edi
801042ae:	5d                   	pop    %ebp
801042af:	c3                   	ret    

801042b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ba:	68 44 7f 10 80       	push   $0x80107f44
801042bf:	8d 43 04             	lea    0x4(%ebx),%eax
801042c2:	50                   	push   %eax
801042c3:	e8 18 01 00 00       	call   801043e0 <initlock>
  lk->name = name;
801042c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e1:	c9                   	leave  
801042e2:	c3                   	ret    
801042e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042f8:	8d 73 04             	lea    0x4(%ebx),%esi
801042fb:	83 ec 0c             	sub    $0xc,%esp
801042fe:	56                   	push   %esi
801042ff:	e8 ac 02 00 00       	call   801045b0 <acquire>
  while (lk->locked) {
80104304:	8b 13                	mov    (%ebx),%edx
80104306:	83 c4 10             	add    $0x10,%esp
80104309:	85 d2                	test   %edx,%edx
8010430b:	74 16                	je     80104323 <acquiresleep+0x33>
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104310:	83 ec 08             	sub    $0x8,%esp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	e8 36 fd ff ff       	call   80104050 <sleep>
  while (lk->locked) {
8010431a:	8b 03                	mov    (%ebx),%eax
8010431c:	83 c4 10             	add    $0x10,%esp
8010431f:	85 c0                	test   %eax,%eax
80104321:	75 ed                	jne    80104310 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104323:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104329:	e8 52 f6 ff ff       	call   80103980 <myproc>
8010432e:	8b 40 10             	mov    0x10(%eax),%eax
80104331:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104334:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104337:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010433a:	5b                   	pop    %ebx
8010433b:	5e                   	pop    %esi
8010433c:	5d                   	pop    %ebp
  release(&lk->lk);
8010433d:	e9 0e 02 00 00       	jmp    80104550 <release>
80104342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104350 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104358:	8d 73 04             	lea    0x4(%ebx),%esi
8010435b:	83 ec 0c             	sub    $0xc,%esp
8010435e:	56                   	push   %esi
8010435f:	e8 4c 02 00 00       	call   801045b0 <acquire>
  lk->locked = 0;
80104364:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010436a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104371:	89 1c 24             	mov    %ebx,(%esp)
80104374:	e8 97 fd ff ff       	call   80104110 <wakeup>
  release(&lk->lk);
80104379:	89 75 08             	mov    %esi,0x8(%ebp)
8010437c:	83 c4 10             	add    $0x10,%esp
}
8010437f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104382:	5b                   	pop    %ebx
80104383:	5e                   	pop    %esi
80104384:	5d                   	pop    %ebp
  release(&lk->lk);
80104385:	e9 c6 01 00 00       	jmp    80104550 <release>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	31 ff                	xor    %edi,%edi
80104396:	56                   	push   %esi
80104397:	53                   	push   %ebx
80104398:	83 ec 18             	sub    $0x18,%esp
8010439b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010439e:	8d 73 04             	lea    0x4(%ebx),%esi
801043a1:	56                   	push   %esi
801043a2:	e8 09 02 00 00       	call   801045b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043a7:	8b 03                	mov    (%ebx),%eax
801043a9:	83 c4 10             	add    $0x10,%esp
801043ac:	85 c0                	test   %eax,%eax
801043ae:	75 18                	jne    801043c8 <holdingsleep+0x38>
  release(&lk->lk);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	56                   	push   %esi
801043b4:	e8 97 01 00 00       	call   80104550 <release>
  return r;
}
801043b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043bc:	89 f8                	mov    %edi,%eax
801043be:	5b                   	pop    %ebx
801043bf:	5e                   	pop    %esi
801043c0:	5f                   	pop    %edi
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret    
801043c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801043c8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043cb:	e8 b0 f5 ff ff       	call   80103980 <myproc>
801043d0:	39 58 10             	cmp    %ebx,0x10(%eax)
801043d3:	0f 94 c0             	sete   %al
801043d6:	0f b6 c0             	movzbl %al,%eax
801043d9:	89 c7                	mov    %eax,%edi
801043db:	eb d3                	jmp    801043b0 <holdingsleep+0x20>
801043dd:	66 90                	xchg   %ax,%ax
801043df:	90                   	nop

801043e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043f9:	5d                   	pop    %ebp
801043fa:	c3                   	ret    
801043fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ff:	90                   	nop

80104400 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104400:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104401:	31 d2                	xor    %edx,%edx
{
80104403:	89 e5                	mov    %esp,%ebp
80104405:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104406:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010440c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010440f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104410:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104416:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010441c:	77 1a                	ja     80104438 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010441e:	8b 58 04             	mov    0x4(%eax),%ebx
80104421:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104424:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104427:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104429:	83 fa 0a             	cmp    $0xa,%edx
8010442c:	75 e2                	jne    80104410 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010442e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104431:	c9                   	leave  
80104432:	c3                   	ret    
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
  for(; i < 10; i++)
80104438:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010443b:	8d 51 28             	lea    0x28(%ecx),%edx
8010443e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104446:	83 c0 04             	add    $0x4,%eax
80104449:	39 d0                	cmp    %edx,%eax
8010444b:	75 f3                	jne    80104440 <getcallerpcs+0x40>
}
8010444d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104450:	c9                   	leave  
80104451:	c3                   	ret    
80104452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104460 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 04             	sub    $0x4,%esp
80104467:	9c                   	pushf  
80104468:	5b                   	pop    %ebx
  asm volatile("cli");
80104469:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010446a:	e8 91 f4 ff ff       	call   80103900 <mycpu>
8010446f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104475:	85 c0                	test   %eax,%eax
80104477:	74 17                	je     80104490 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104479:	e8 82 f4 ff ff       	call   80103900 <mycpu>
8010447e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104488:	c9                   	leave  
80104489:	c3                   	ret    
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104490:	e8 6b f4 ff ff       	call   80103900 <mycpu>
80104495:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010449b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044a1:	eb d6                	jmp    80104479 <pushcli+0x19>
801044a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <popcli>:

void
popcli(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044b6:	9c                   	pushf  
801044b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044b8:	f6 c4 02             	test   $0x2,%ah
801044bb:	75 35                	jne    801044f2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044bd:	e8 3e f4 ff ff       	call   80103900 <mycpu>
801044c2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044c9:	78 34                	js     801044ff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044cb:	e8 30 f4 ff ff       	call   80103900 <mycpu>
801044d0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044d6:	85 d2                	test   %edx,%edx
801044d8:	74 06                	je     801044e0 <popcli+0x30>
    sti();
}
801044da:	c9                   	leave  
801044db:	c3                   	ret    
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044e0:	e8 1b f4 ff ff       	call   80103900 <mycpu>
801044e5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044eb:	85 c0                	test   %eax,%eax
801044ed:	74 eb                	je     801044da <popcli+0x2a>
  asm volatile("sti");
801044ef:	fb                   	sti    
}
801044f0:	c9                   	leave  
801044f1:	c3                   	ret    
    panic("popcli - interruptible");
801044f2:	83 ec 0c             	sub    $0xc,%esp
801044f5:	68 4f 7f 10 80       	push   $0x80107f4f
801044fa:	e8 81 be ff ff       	call   80100380 <panic>
    panic("popcli");
801044ff:	83 ec 0c             	sub    $0xc,%esp
80104502:	68 66 7f 10 80       	push   $0x80107f66
80104507:	e8 74 be ff ff       	call   80100380 <panic>
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <holding>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 75 08             	mov    0x8(%ebp),%esi
80104518:	31 db                	xor    %ebx,%ebx
  pushcli();
8010451a:	e8 41 ff ff ff       	call   80104460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010451f:	8b 06                	mov    (%esi),%eax
80104521:	85 c0                	test   %eax,%eax
80104523:	75 0b                	jne    80104530 <holding+0x20>
  popcli();
80104525:	e8 86 ff ff ff       	call   801044b0 <popcli>
}
8010452a:	89 d8                	mov    %ebx,%eax
8010452c:	5b                   	pop    %ebx
8010452d:	5e                   	pop    %esi
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104530:	8b 5e 08             	mov    0x8(%esi),%ebx
80104533:	e8 c8 f3 ff ff       	call   80103900 <mycpu>
80104538:	39 c3                	cmp    %eax,%ebx
8010453a:	0f 94 c3             	sete   %bl
  popcli();
8010453d:	e8 6e ff ff ff       	call   801044b0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104542:	0f b6 db             	movzbl %bl,%ebx
}
80104545:	89 d8                	mov    %ebx,%eax
80104547:	5b                   	pop    %ebx
80104548:	5e                   	pop    %esi
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret    
8010454b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010454f:	90                   	nop

80104550 <release>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104558:	e8 03 ff ff ff       	call   80104460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010455d:	8b 03                	mov    (%ebx),%eax
8010455f:	85 c0                	test   %eax,%eax
80104561:	75 15                	jne    80104578 <release+0x28>
  popcli();
80104563:	e8 48 ff ff ff       	call   801044b0 <popcli>
    panic("release");
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	68 6d 7f 10 80       	push   $0x80107f6d
80104570:	e8 0b be ff ff       	call   80100380 <panic>
80104575:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104578:	8b 73 08             	mov    0x8(%ebx),%esi
8010457b:	e8 80 f3 ff ff       	call   80103900 <mycpu>
80104580:	39 c6                	cmp    %eax,%esi
80104582:	75 df                	jne    80104563 <release+0x13>
  popcli();
80104584:	e8 27 ff ff ff       	call   801044b0 <popcli>
  lk->pcs[0] = 0;
80104589:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104590:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104597:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010459c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a5:	5b                   	pop    %ebx
801045a6:	5e                   	pop    %esi
801045a7:	5d                   	pop    %ebp
  popcli();
801045a8:	e9 03 ff ff ff       	jmp    801044b0 <popcli>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi

801045b0 <acquire>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045b7:	e8 a4 fe ff ff       	call   80104460 <pushcli>
  if(holding(lk))
801045bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045bf:	e8 9c fe ff ff       	call   80104460 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045c4:	8b 03                	mov    (%ebx),%eax
801045c6:	85 c0                	test   %eax,%eax
801045c8:	75 7e                	jne    80104648 <acquire+0x98>
  popcli();
801045ca:	e8 e1 fe ff ff       	call   801044b0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801045cf:	b9 01 00 00 00       	mov    $0x1,%ecx
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801045d8:	8b 55 08             	mov    0x8(%ebp),%edx
801045db:	89 c8                	mov    %ecx,%eax
801045dd:	f0 87 02             	lock xchg %eax,(%edx)
801045e0:	85 c0                	test   %eax,%eax
801045e2:	75 f4                	jne    801045d8 <acquire+0x28>
  __sync_synchronize();
801045e4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045ec:	e8 0f f3 ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801045f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801045f4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801045f6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801045f9:	31 c0                	xor    %eax,%eax
801045fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104600:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104606:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010460c:	77 1a                	ja     80104628 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010460e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104611:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104615:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104618:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010461a:	83 f8 0a             	cmp    $0xa,%eax
8010461d:	75 e1                	jne    80104600 <acquire+0x50>
}
8010461f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104622:	c9                   	leave  
80104623:	c3                   	ret    
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104628:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010462c:	8d 51 34             	lea    0x34(%ecx),%edx
8010462f:	90                   	nop
    pcs[i] = 0;
80104630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104636:	83 c0 04             	add    $0x4,%eax
80104639:	39 c2                	cmp    %eax,%edx
8010463b:	75 f3                	jne    80104630 <acquire+0x80>
}
8010463d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104640:	c9                   	leave  
80104641:	c3                   	ret    
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104648:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010464b:	e8 b0 f2 ff ff       	call   80103900 <mycpu>
80104650:	39 c3                	cmp    %eax,%ebx
80104652:	0f 85 72 ff ff ff    	jne    801045ca <acquire+0x1a>
  popcli();
80104658:	e8 53 fe ff ff       	call   801044b0 <popcli>
    panic("acquire");
8010465d:	83 ec 0c             	sub    $0xc,%esp
80104660:	68 75 7f 10 80       	push   $0x80107f75
80104665:	e8 16 bd ff ff       	call   80100380 <panic>
8010466a:	66 90                	xchg   %ax,%ax
8010466c:	66 90                	xchg   %ax,%ax
8010466e:	66 90                	xchg   %ax,%ax

80104670 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	8b 55 08             	mov    0x8(%ebp),%edx
80104677:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010467a:	53                   	push   %ebx
8010467b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010467e:	89 d7                	mov    %edx,%edi
80104680:	09 cf                	or     %ecx,%edi
80104682:	83 e7 03             	and    $0x3,%edi
80104685:	75 29                	jne    801046b0 <memset+0x40>
    c &= 0xFF;
80104687:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010468a:	c1 e0 18             	shl    $0x18,%eax
8010468d:	89 fb                	mov    %edi,%ebx
8010468f:	c1 e9 02             	shr    $0x2,%ecx
80104692:	c1 e3 10             	shl    $0x10,%ebx
80104695:	09 d8                	or     %ebx,%eax
80104697:	09 f8                	or     %edi,%eax
80104699:	c1 e7 08             	shl    $0x8,%edi
8010469c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010469e:	89 d7                	mov    %edx,%edi
801046a0:	fc                   	cld    
801046a1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046a3:	5b                   	pop    %ebx
801046a4:	89 d0                	mov    %edx,%eax
801046a6:	5f                   	pop    %edi
801046a7:	5d                   	pop    %ebp
801046a8:	c3                   	ret    
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801046b0:	89 d7                	mov    %edx,%edi
801046b2:	fc                   	cld    
801046b3:	f3 aa                	rep stos %al,%es:(%edi)
801046b5:	5b                   	pop    %ebx
801046b6:	89 d0                	mov    %edx,%eax
801046b8:	5f                   	pop    %edi
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret    
801046bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046bf:	90                   	nop

801046c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	8b 75 10             	mov    0x10(%ebp),%esi
801046c7:	8b 55 08             	mov    0x8(%ebp),%edx
801046ca:	53                   	push   %ebx
801046cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ce:	85 f6                	test   %esi,%esi
801046d0:	74 2e                	je     80104700 <memcmp+0x40>
801046d2:	01 c6                	add    %eax,%esi
801046d4:	eb 14                	jmp    801046ea <memcmp+0x2a>
801046d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801046e0:	83 c0 01             	add    $0x1,%eax
801046e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801046e6:	39 f0                	cmp    %esi,%eax
801046e8:	74 16                	je     80104700 <memcmp+0x40>
    if(*s1 != *s2)
801046ea:	0f b6 0a             	movzbl (%edx),%ecx
801046ed:	0f b6 18             	movzbl (%eax),%ebx
801046f0:	38 d9                	cmp    %bl,%cl
801046f2:	74 ec                	je     801046e0 <memcmp+0x20>
      return *s1 - *s2;
801046f4:	0f b6 c1             	movzbl %cl,%eax
801046f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801046f9:	5b                   	pop    %ebx
801046fa:	5e                   	pop    %esi
801046fb:	5d                   	pop    %ebp
801046fc:	c3                   	ret    
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
80104700:	5b                   	pop    %ebx
  return 0;
80104701:	31 c0                	xor    %eax,%eax
}
80104703:	5e                   	pop    %esi
80104704:	5d                   	pop    %ebp
80104705:	c3                   	ret    
80104706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470d:	8d 76 00             	lea    0x0(%esi),%esi

80104710 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	8b 55 08             	mov    0x8(%ebp),%edx
80104717:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010471a:	56                   	push   %esi
8010471b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010471e:	39 d6                	cmp    %edx,%esi
80104720:	73 26                	jae    80104748 <memmove+0x38>
80104722:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104725:	39 fa                	cmp    %edi,%edx
80104727:	73 1f                	jae    80104748 <memmove+0x38>
80104729:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010472c:	85 c9                	test   %ecx,%ecx
8010472e:	74 0c                	je     8010473c <memmove+0x2c>
      *--d = *--s;
80104730:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104734:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104737:	83 e8 01             	sub    $0x1,%eax
8010473a:	73 f4                	jae    80104730 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010473c:	5e                   	pop    %esi
8010473d:	89 d0                	mov    %edx,%eax
8010473f:	5f                   	pop    %edi
80104740:	5d                   	pop    %ebp
80104741:	c3                   	ret    
80104742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104748:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010474b:	89 d7                	mov    %edx,%edi
8010474d:	85 c9                	test   %ecx,%ecx
8010474f:	74 eb                	je     8010473c <memmove+0x2c>
80104751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104758:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104759:	39 c6                	cmp    %eax,%esi
8010475b:	75 fb                	jne    80104758 <memmove+0x48>
}
8010475d:	5e                   	pop    %esi
8010475e:	89 d0                	mov    %edx,%eax
80104760:	5f                   	pop    %edi
80104761:	5d                   	pop    %ebp
80104762:	c3                   	ret    
80104763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104770 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104770:	eb 9e                	jmp    80104710 <memmove>
80104772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	8b 75 10             	mov    0x10(%ebp),%esi
80104787:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010478a:	53                   	push   %ebx
8010478b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010478e:	85 f6                	test   %esi,%esi
80104790:	74 2e                	je     801047c0 <strncmp+0x40>
80104792:	01 d6                	add    %edx,%esi
80104794:	eb 18                	jmp    801047ae <strncmp+0x2e>
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
801047a0:	38 d8                	cmp    %bl,%al
801047a2:	75 14                	jne    801047b8 <strncmp+0x38>
    n--, p++, q++;
801047a4:	83 c2 01             	add    $0x1,%edx
801047a7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047aa:	39 f2                	cmp    %esi,%edx
801047ac:	74 12                	je     801047c0 <strncmp+0x40>
801047ae:	0f b6 01             	movzbl (%ecx),%eax
801047b1:	0f b6 1a             	movzbl (%edx),%ebx
801047b4:	84 c0                	test   %al,%al
801047b6:	75 e8                	jne    801047a0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047b8:	29 d8                	sub    %ebx,%eax
}
801047ba:	5b                   	pop    %ebx
801047bb:	5e                   	pop    %esi
801047bc:	5d                   	pop    %ebp
801047bd:	c3                   	ret    
801047be:	66 90                	xchg   %ax,%ax
801047c0:	5b                   	pop    %ebx
    return 0;
801047c1:	31 c0                	xor    %eax,%eax
}
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
801047c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cd:	8d 76 00             	lea    0x0(%esi),%esi

801047d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	8b 75 08             	mov    0x8(%ebp),%esi
801047d8:	53                   	push   %ebx
801047d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047dc:	89 f0                	mov    %esi,%eax
801047de:	eb 15                	jmp    801047f5 <strncpy+0x25>
801047e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801047e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801047e7:	83 c0 01             	add    $0x1,%eax
801047ea:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801047ee:	88 50 ff             	mov    %dl,-0x1(%eax)
801047f1:	84 d2                	test   %dl,%dl
801047f3:	74 09                	je     801047fe <strncpy+0x2e>
801047f5:	89 cb                	mov    %ecx,%ebx
801047f7:	83 e9 01             	sub    $0x1,%ecx
801047fa:	85 db                	test   %ebx,%ebx
801047fc:	7f e2                	jg     801047e0 <strncpy+0x10>
    ;
  while(n-- > 0)
801047fe:	89 c2                	mov    %eax,%edx
80104800:	85 c9                	test   %ecx,%ecx
80104802:	7e 17                	jle    8010481b <strncpy+0x4b>
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104808:	83 c2 01             	add    $0x1,%edx
8010480b:	89 c1                	mov    %eax,%ecx
8010480d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104811:	29 d1                	sub    %edx,%ecx
80104813:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104817:	85 c9                	test   %ecx,%ecx
80104819:	7f ed                	jg     80104808 <strncpy+0x38>
  return os;
}
8010481b:	5b                   	pop    %ebx
8010481c:	89 f0                	mov    %esi,%eax
8010481e:	5e                   	pop    %esi
8010481f:	5f                   	pop    %edi
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    
80104822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	8b 55 10             	mov    0x10(%ebp),%edx
80104837:	8b 75 08             	mov    0x8(%ebp),%esi
8010483a:	53                   	push   %ebx
8010483b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010483e:	85 d2                	test   %edx,%edx
80104840:	7e 25                	jle    80104867 <safestrcpy+0x37>
80104842:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104846:	89 f2                	mov    %esi,%edx
80104848:	eb 16                	jmp    80104860 <safestrcpy+0x30>
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104850:	0f b6 08             	movzbl (%eax),%ecx
80104853:	83 c0 01             	add    $0x1,%eax
80104856:	83 c2 01             	add    $0x1,%edx
80104859:	88 4a ff             	mov    %cl,-0x1(%edx)
8010485c:	84 c9                	test   %cl,%cl
8010485e:	74 04                	je     80104864 <safestrcpy+0x34>
80104860:	39 d8                	cmp    %ebx,%eax
80104862:	75 ec                	jne    80104850 <safestrcpy+0x20>
    ;
  *s = 0;
80104864:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104867:	89 f0                	mov    %esi,%eax
80104869:	5b                   	pop    %ebx
8010486a:	5e                   	pop    %esi
8010486b:	5d                   	pop    %ebp
8010486c:	c3                   	ret    
8010486d:	8d 76 00             	lea    0x0(%esi),%esi

80104870 <strlen>:

int
strlen(const char *s)
{
80104870:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104871:	31 c0                	xor    %eax,%eax
{
80104873:	89 e5                	mov    %esp,%ebp
80104875:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104878:	80 3a 00             	cmpb   $0x0,(%edx)
8010487b:	74 0c                	je     80104889 <strlen+0x19>
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
80104880:	83 c0 01             	add    $0x1,%eax
80104883:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104887:	75 f7                	jne    80104880 <strlen+0x10>
    ;
  return n;
}
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    

8010488b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010488b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010488f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104893:	55                   	push   %ebp
  pushl %ebx
80104894:	53                   	push   %ebx
  pushl %esi
80104895:	56                   	push   %esi
  pushl %edi
80104896:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104897:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104899:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010489b:	5f                   	pop    %edi
  popl %esi
8010489c:	5e                   	pop    %esi
  popl %ebx
8010489d:	5b                   	pop    %ebx
  popl %ebp
8010489e:	5d                   	pop    %ebp
  ret
8010489f:	c3                   	ret    

801048a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048aa:	e8 d1 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048af:	8b 00                	mov    (%eax),%eax
801048b1:	39 d8                	cmp    %ebx,%eax
801048b3:	76 1b                	jbe    801048d0 <fetchint+0x30>
801048b5:	8d 53 04             	lea    0x4(%ebx),%edx
801048b8:	39 d0                	cmp    %edx,%eax
801048ba:	72 14                	jb     801048d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048bf:	8b 13                	mov    (%ebx),%edx
801048c1:	89 10                	mov    %edx,(%eax)
  return 0;
801048c3:	31 c0                	xor    %eax,%eax
}
801048c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c8:	c9                   	leave  
801048c9:	c3                   	ret    
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801048d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d5:	eb ee                	jmp    801048c5 <fetchint+0x25>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax

801048e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048ea:	e8 91 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
801048ef:	39 18                	cmp    %ebx,(%eax)
801048f1:	76 2d                	jbe    80104920 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801048f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801048f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801048f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801048fa:	39 d3                	cmp    %edx,%ebx
801048fc:	73 22                	jae    80104920 <fetchstr+0x40>
801048fe:	89 d8                	mov    %ebx,%eax
80104900:	eb 0d                	jmp    8010490f <fetchstr+0x2f>
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104908:	83 c0 01             	add    $0x1,%eax
8010490b:	39 c2                	cmp    %eax,%edx
8010490d:	76 11                	jbe    80104920 <fetchstr+0x40>
    if(*s == 0)
8010490f:	80 38 00             	cmpb   $0x0,(%eax)
80104912:	75 f4                	jne    80104908 <fetchstr+0x28>
      return s - *pp;
80104914:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104919:	c9                   	leave  
8010491a:	c3                   	ret    
8010491b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop
80104920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104928:	c9                   	leave  
80104929:	c3                   	ret    
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104930 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104935:	e8 46 f0 ff ff       	call   80103980 <myproc>
8010493a:	8b 55 08             	mov    0x8(%ebp),%edx
8010493d:	8b 40 18             	mov    0x18(%eax),%eax
80104940:	8b 40 44             	mov    0x44(%eax),%eax
80104943:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104946:	e8 35 f0 ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010494b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010494e:	8b 00                	mov    (%eax),%eax
80104950:	39 c6                	cmp    %eax,%esi
80104952:	73 1c                	jae    80104970 <argint+0x40>
80104954:	8d 53 08             	lea    0x8(%ebx),%edx
80104957:	39 d0                	cmp    %edx,%eax
80104959:	72 15                	jb     80104970 <argint+0x40>
  *ip = *(int*)(addr);
8010495b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010495e:	8b 53 04             	mov    0x4(%ebx),%edx
80104961:	89 10                	mov    %edx,(%eax)
  return 0;
80104963:	31 c0                	xor    %eax,%eax
}
80104965:	5b                   	pop    %ebx
80104966:	5e                   	pop    %esi
80104967:	5d                   	pop    %ebp
80104968:	c3                   	ret    
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104975:	eb ee                	jmp    80104965 <argint+0x35>
80104977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497e:	66 90                	xchg   %ax,%ax

80104980 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	53                   	push   %ebx
80104986:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104989:	e8 f2 ef ff ff       	call   80103980 <myproc>
8010498e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104990:	e8 eb ef ff ff       	call   80103980 <myproc>
80104995:	8b 55 08             	mov    0x8(%ebp),%edx
80104998:	8b 40 18             	mov    0x18(%eax),%eax
8010499b:	8b 40 44             	mov    0x44(%eax),%eax
8010499e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049a1:	e8 da ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049a9:	8b 00                	mov    (%eax),%eax
801049ab:	39 c7                	cmp    %eax,%edi
801049ad:	73 31                	jae    801049e0 <argptr+0x60>
801049af:	8d 4b 08             	lea    0x8(%ebx),%ecx
801049b2:	39 c8                	cmp    %ecx,%eax
801049b4:	72 2a                	jb     801049e0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049b6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801049b9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049bc:	85 d2                	test   %edx,%edx
801049be:	78 20                	js     801049e0 <argptr+0x60>
801049c0:	8b 16                	mov    (%esi),%edx
801049c2:	39 c2                	cmp    %eax,%edx
801049c4:	76 1a                	jbe    801049e0 <argptr+0x60>
801049c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049c9:	01 c3                	add    %eax,%ebx
801049cb:	39 da                	cmp    %ebx,%edx
801049cd:	72 11                	jb     801049e0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801049cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801049d2:	89 02                	mov    %eax,(%edx)
  return 0;
801049d4:	31 c0                	xor    %eax,%eax
}
801049d6:	83 c4 0c             	add    $0xc,%esp
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5f                   	pop    %edi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e5:	eb ef                	jmp    801049d6 <argptr+0x56>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f5:	e8 86 ef ff ff       	call   80103980 <myproc>
801049fa:	8b 55 08             	mov    0x8(%ebp),%edx
801049fd:	8b 40 18             	mov    0x18(%eax),%eax
80104a00:	8b 40 44             	mov    0x44(%eax),%eax
80104a03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a06:	e8 75 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a0e:	8b 00                	mov    (%eax),%eax
80104a10:	39 c6                	cmp    %eax,%esi
80104a12:	73 44                	jae    80104a58 <argstr+0x68>
80104a14:	8d 53 08             	lea    0x8(%ebx),%edx
80104a17:	39 d0                	cmp    %edx,%eax
80104a19:	72 3d                	jb     80104a58 <argstr+0x68>
  *ip = *(int*)(addr);
80104a1b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a1e:	e8 5d ef ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz)
80104a23:	3b 18                	cmp    (%eax),%ebx
80104a25:	73 31                	jae    80104a58 <argstr+0x68>
  *pp = (char*)addr;
80104a27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a2e:	39 d3                	cmp    %edx,%ebx
80104a30:	73 26                	jae    80104a58 <argstr+0x68>
80104a32:	89 d8                	mov    %ebx,%eax
80104a34:	eb 11                	jmp    80104a47 <argstr+0x57>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	39 c2                	cmp    %eax,%edx
80104a45:	76 11                	jbe    80104a58 <argstr+0x68>
    if(*s == 0)
80104a47:	80 38 00             	cmpb   $0x0,(%eax)
80104a4a:	75 f4                	jne    80104a40 <argstr+0x50>
      return s - *pp;
80104a4c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a4e:	5b                   	pop    %ebx
80104a4f:	5e                   	pop    %esi
80104a50:	5d                   	pop    %ebp
80104a51:	c3                   	ret    
80104a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a58:	5b                   	pop    %ebx
    return -1;
80104a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a5e:	5e                   	pop    %esi
80104a5f:	5d                   	pop    %ebp
80104a60:	c3                   	ret    
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6f:	90                   	nop

80104a70 <syscall>:
[SYS_hpmap]   sys_hpmap,
};

void
syscall(void)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a77:	e8 04 ef ff ff       	call   80103980 <myproc>
80104a7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a7e:	8b 40 18             	mov    0x18(%eax),%eax
80104a81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a87:	83 fa 18             	cmp    $0x18,%edx
80104a8a:	77 24                	ja     80104ab0 <syscall+0x40>
80104a8c:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
80104a93:	85 d2                	test   %edx,%edx
80104a95:	74 19                	je     80104ab0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a97:	ff d2                	call   *%edx
80104a99:	89 c2                	mov    %eax,%edx
80104a9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104a9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa4:	c9                   	leave  
80104aa5:	c3                   	ret    
80104aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ab0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ab1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ab4:	50                   	push   %eax
80104ab5:	ff 73 10             	push   0x10(%ebx)
80104ab8:	68 7d 7f 10 80       	push   $0x80107f7d
80104abd:	e8 de bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104ac2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ac5:	83 c4 10             	add    $0x10,%esp
80104ac8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad2:	c9                   	leave  
80104ad3:	c3                   	ret    
80104ad4:	66 90                	xchg   %ax,%ax
80104ad6:	66 90                	xchg   %ax,%ax
80104ad8:	66 90                	xchg   %ax,%ax
80104ada:	66 90                	xchg   %ax,%ax
80104adc:	66 90                	xchg   %ax,%ax
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ae5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ae8:	53                   	push   %ebx
80104ae9:	83 ec 34             	sub    $0x34,%esp
80104aec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104af2:	57                   	push   %edi
80104af3:	50                   	push   %eax
{
80104af4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104af7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104afa:	e8 c1 d5 ff ff       	call   801020c0 <nameiparent>
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	85 c0                	test   %eax,%eax
80104b04:	0f 84 46 01 00 00    	je     80104c50 <create+0x170>
    return 0;
  ilock(dp);
80104b0a:	83 ec 0c             	sub    $0xc,%esp
80104b0d:	89 c3                	mov    %eax,%ebx
80104b0f:	50                   	push   %eax
80104b10:	e8 6b cc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b15:	83 c4 0c             	add    $0xc,%esp
80104b18:	6a 00                	push   $0x0
80104b1a:	57                   	push   %edi
80104b1b:	53                   	push   %ebx
80104b1c:	e8 bf d1 ff ff       	call   80101ce0 <dirlookup>
80104b21:	83 c4 10             	add    $0x10,%esp
80104b24:	89 c6                	mov    %eax,%esi
80104b26:	85 c0                	test   %eax,%eax
80104b28:	74 56                	je     80104b80 <create+0xa0>
    iunlockput(dp);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	53                   	push   %ebx
80104b2e:	e8 dd ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b33:	89 34 24             	mov    %esi,(%esp)
80104b36:	e8 45 cc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b3b:	83 c4 10             	add    $0x10,%esp
80104b3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b43:	75 1b                	jne    80104b60 <create+0x80>
80104b45:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b4a:	75 14                	jne    80104b60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b4f:	89 f0                	mov    %esi,%eax
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b60:	83 ec 0c             	sub    $0xc,%esp
80104b63:	56                   	push   %esi
    return 0;
80104b64:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b66:	e8 a5 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104b6b:	83 c4 10             	add    $0x10,%esp
}
80104b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b71:	89 f0                	mov    %esi,%eax
80104b73:	5b                   	pop    %ebx
80104b74:	5e                   	pop    %esi
80104b75:	5f                   	pop    %edi
80104b76:	5d                   	pop    %ebp
80104b77:	c3                   	ret    
80104b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b84:	83 ec 08             	sub    $0x8,%esp
80104b87:	50                   	push   %eax
80104b88:	ff 33                	push   (%ebx)
80104b8a:	e8 81 ca ff ff       	call   80101610 <ialloc>
80104b8f:	83 c4 10             	add    $0x10,%esp
80104b92:	89 c6                	mov    %eax,%esi
80104b94:	85 c0                	test   %eax,%eax
80104b96:	0f 84 cd 00 00 00    	je     80104c69 <create+0x189>
  ilock(ip);
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	50                   	push   %eax
80104ba0:	e8 db cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104ba5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ba9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104bb1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104bb5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bbe:	89 34 24             	mov    %esi,(%esp)
80104bc1:	e8 0a cb ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bc6:	83 c4 10             	add    $0x10,%esp
80104bc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bce:	74 30                	je     80104c00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bd0:	83 ec 04             	sub    $0x4,%esp
80104bd3:	ff 76 04             	push   0x4(%esi)
80104bd6:	57                   	push   %edi
80104bd7:	53                   	push   %ebx
80104bd8:	e8 03 d4 ff ff       	call   80101fe0 <dirlink>
80104bdd:	83 c4 10             	add    $0x10,%esp
80104be0:	85 c0                	test   %eax,%eax
80104be2:	78 78                	js     80104c5c <create+0x17c>
  iunlockput(dp);
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	53                   	push   %ebx
80104be8:	e8 23 ce ff ff       	call   80101a10 <iunlockput>
  return ip;
80104bed:	83 c4 10             	add    $0x10,%esp
}
80104bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bf3:	89 f0                	mov    %esi,%eax
80104bf5:	5b                   	pop    %ebx
80104bf6:	5e                   	pop    %esi
80104bf7:	5f                   	pop    %edi
80104bf8:	5d                   	pop    %ebp
80104bf9:	c3                   	ret    
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c08:	53                   	push   %ebx
80104c09:	e8 c2 ca ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c0e:	83 c4 0c             	add    $0xc,%esp
80104c11:	ff 76 04             	push   0x4(%esi)
80104c14:	68 24 80 10 80       	push   $0x80108024
80104c19:	56                   	push   %esi
80104c1a:	e8 c1 d3 ff ff       	call   80101fe0 <dirlink>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 18                	js     80104c3e <create+0x15e>
80104c26:	83 ec 04             	sub    $0x4,%esp
80104c29:	ff 73 04             	push   0x4(%ebx)
80104c2c:	68 23 80 10 80       	push   $0x80108023
80104c31:	56                   	push   %esi
80104c32:	e8 a9 d3 ff ff       	call   80101fe0 <dirlink>
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	79 92                	jns    80104bd0 <create+0xf0>
      panic("create dots");
80104c3e:	83 ec 0c             	sub    $0xc,%esp
80104c41:	68 17 80 10 80       	push   $0x80108017
80104c46:	e8 35 b7 ff ff       	call   80100380 <panic>
80104c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop
}
80104c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c53:	31 f6                	xor    %esi,%esi
}
80104c55:	5b                   	pop    %ebx
80104c56:	89 f0                	mov    %esi,%eax
80104c58:	5e                   	pop    %esi
80104c59:	5f                   	pop    %edi
80104c5a:	5d                   	pop    %ebp
80104c5b:	c3                   	ret    
    panic("create: dirlink");
80104c5c:	83 ec 0c             	sub    $0xc,%esp
80104c5f:	68 26 80 10 80       	push   $0x80108026
80104c64:	e8 17 b7 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c69:	83 ec 0c             	sub    $0xc,%esp
80104c6c:	68 08 80 10 80       	push   $0x80108008
80104c71:	e8 0a b7 ff ff       	call   80100380 <panic>
80104c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi

80104c80 <sys_dup>:
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104c85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104c88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c8b:	50                   	push   %eax
80104c8c:	6a 00                	push   $0x0
80104c8e:	e8 9d fc ff ff       	call   80104930 <argint>
80104c93:	83 c4 10             	add    $0x10,%esp
80104c96:	85 c0                	test   %eax,%eax
80104c98:	78 36                	js     80104cd0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c9e:	77 30                	ja     80104cd0 <sys_dup+0x50>
80104ca0:	e8 db ec ff ff       	call   80103980 <myproc>
80104ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ca8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cac:	85 f6                	test   %esi,%esi
80104cae:	74 20                	je     80104cd0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104cb0:	e8 cb ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104cb5:	31 db                	xor    %ebx,%ebx
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104cc0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cc4:	85 d2                	test   %edx,%edx
80104cc6:	74 18                	je     80104ce0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104cc8:	83 c3 01             	add    $0x1,%ebx
80104ccb:	83 fb 10             	cmp    $0x10,%ebx
80104cce:	75 f0                	jne    80104cc0 <sys_dup+0x40>
}
80104cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104cd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104cd8:	89 d8                	mov    %ebx,%eax
80104cda:	5b                   	pop    %ebx
80104cdb:	5e                   	pop    %esi
80104cdc:	5d                   	pop    %ebp
80104cdd:	c3                   	ret    
80104cde:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ce0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ce3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ce7:	56                   	push   %esi
80104ce8:	e8 b3 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104ced:	83 c4 10             	add    $0x10,%esp
}
80104cf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf3:	89 d8                	mov    %ebx,%eax
80104cf5:	5b                   	pop    %ebx
80104cf6:	5e                   	pop    %esi
80104cf7:	5d                   	pop    %ebp
80104cf8:	c3                   	ret    
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d00 <sys_read>:
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d0b:	53                   	push   %ebx
80104d0c:	6a 00                	push   $0x0
80104d0e:	e8 1d fc ff ff       	call   80104930 <argint>
80104d13:	83 c4 10             	add    $0x10,%esp
80104d16:	85 c0                	test   %eax,%eax
80104d18:	78 5e                	js     80104d78 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d1e:	77 58                	ja     80104d78 <sys_read+0x78>
80104d20:	e8 5b ec ff ff       	call   80103980 <myproc>
80104d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d2c:	85 f6                	test   %esi,%esi
80104d2e:	74 48                	je     80104d78 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d30:	83 ec 08             	sub    $0x8,%esp
80104d33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d36:	50                   	push   %eax
80104d37:	6a 02                	push   $0x2
80104d39:	e8 f2 fb ff ff       	call   80104930 <argint>
80104d3e:	83 c4 10             	add    $0x10,%esp
80104d41:	85 c0                	test   %eax,%eax
80104d43:	78 33                	js     80104d78 <sys_read+0x78>
80104d45:	83 ec 04             	sub    $0x4,%esp
80104d48:	ff 75 f0             	push   -0x10(%ebp)
80104d4b:	53                   	push   %ebx
80104d4c:	6a 01                	push   $0x1
80104d4e:	e8 2d fc ff ff       	call   80104980 <argptr>
80104d53:	83 c4 10             	add    $0x10,%esp
80104d56:	85 c0                	test   %eax,%eax
80104d58:	78 1e                	js     80104d78 <sys_read+0x78>
  return fileread(f, p, n);
80104d5a:	83 ec 04             	sub    $0x4,%esp
80104d5d:	ff 75 f0             	push   -0x10(%ebp)
80104d60:	ff 75 f4             	push   -0xc(%ebp)
80104d63:	56                   	push   %esi
80104d64:	e8 b7 c2 ff ff       	call   80101020 <fileread>
80104d69:	83 c4 10             	add    $0x10,%esp
}
80104d6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d6f:	5b                   	pop    %ebx
80104d70:	5e                   	pop    %esi
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    
80104d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d77:	90                   	nop
    return -1;
80104d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d7d:	eb ed                	jmp    80104d6c <sys_read+0x6c>
80104d7f:	90                   	nop

80104d80 <sys_write>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d8b:	53                   	push   %ebx
80104d8c:	6a 00                	push   $0x0
80104d8e:	e8 9d fb ff ff       	call   80104930 <argint>
80104d93:	83 c4 10             	add    $0x10,%esp
80104d96:	85 c0                	test   %eax,%eax
80104d98:	78 5e                	js     80104df8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d9e:	77 58                	ja     80104df8 <sys_write+0x78>
80104da0:	e8 db eb ff ff       	call   80103980 <myproc>
80104da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104da8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dac:	85 f6                	test   %esi,%esi
80104dae:	74 48                	je     80104df8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db0:	83 ec 08             	sub    $0x8,%esp
80104db3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db6:	50                   	push   %eax
80104db7:	6a 02                	push   $0x2
80104db9:	e8 72 fb ff ff       	call   80104930 <argint>
80104dbe:	83 c4 10             	add    $0x10,%esp
80104dc1:	85 c0                	test   %eax,%eax
80104dc3:	78 33                	js     80104df8 <sys_write+0x78>
80104dc5:	83 ec 04             	sub    $0x4,%esp
80104dc8:	ff 75 f0             	push   -0x10(%ebp)
80104dcb:	53                   	push   %ebx
80104dcc:	6a 01                	push   $0x1
80104dce:	e8 ad fb ff ff       	call   80104980 <argptr>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	78 1e                	js     80104df8 <sys_write+0x78>
  return filewrite(f, p, n);
80104dda:	83 ec 04             	sub    $0x4,%esp
80104ddd:	ff 75 f0             	push   -0x10(%ebp)
80104de0:	ff 75 f4             	push   -0xc(%ebp)
80104de3:	56                   	push   %esi
80104de4:	e8 c7 c2 ff ff       	call   801010b0 <filewrite>
80104de9:	83 c4 10             	add    $0x10,%esp
}
80104dec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104def:	5b                   	pop    %ebx
80104df0:	5e                   	pop    %esi
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    
80104df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104df7:	90                   	nop
    return -1;
80104df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfd:	eb ed                	jmp    80104dec <sys_write+0x6c>
80104dff:	90                   	nop

80104e00 <sys_close>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e0b:	50                   	push   %eax
80104e0c:	6a 00                	push   $0x0
80104e0e:	e8 1d fb ff ff       	call   80104930 <argint>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	78 3e                	js     80104e58 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e1e:	77 38                	ja     80104e58 <sys_close+0x58>
80104e20:	e8 5b eb ff ff       	call   80103980 <myproc>
80104e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e28:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e2b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e2f:	85 f6                	test   %esi,%esi
80104e31:	74 25                	je     80104e58 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e33:	e8 48 eb ff ff       	call   80103980 <myproc>
  fileclose(f);
80104e38:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e3b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e42:	00 
  fileclose(f);
80104e43:	56                   	push   %esi
80104e44:	e8 a7 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104e49:	83 c4 10             	add    $0x10,%esp
80104e4c:	31 c0                	xor    %eax,%eax
}
80104e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e51:	5b                   	pop    %ebx
80104e52:	5e                   	pop    %esi
80104e53:	5d                   	pop    %ebp
80104e54:	c3                   	ret    
80104e55:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e5d:	eb ef                	jmp    80104e4e <sys_close+0x4e>
80104e5f:	90                   	nop

80104e60 <sys_fstat>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	53                   	push   %ebx
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 bd fa ff ff       	call   80104930 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 46                	js     80104ec0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 40                	ja     80104ec0 <sys_fstat+0x60>
80104e80:	e8 fb ea ff ff       	call   80103980 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e8c:	85 f6                	test   %esi,%esi
80104e8e:	74 30                	je     80104ec0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e90:	83 ec 04             	sub    $0x4,%esp
80104e93:	6a 14                	push   $0x14
80104e95:	53                   	push   %ebx
80104e96:	6a 01                	push   $0x1
80104e98:	e8 e3 fa ff ff       	call   80104980 <argptr>
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	85 c0                	test   %eax,%eax
80104ea2:	78 1c                	js     80104ec0 <sys_fstat+0x60>
  return filestat(f, st);
80104ea4:	83 ec 08             	sub    $0x8,%esp
80104ea7:	ff 75 f4             	push   -0xc(%ebp)
80104eaa:	56                   	push   %esi
80104eab:	e8 20 c1 ff ff       	call   80100fd0 <filestat>
80104eb0:	83 c4 10             	add    $0x10,%esp
}
80104eb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb6:	5b                   	pop    %ebx
80104eb7:	5e                   	pop    %esi
80104eb8:	5d                   	pop    %ebp
80104eb9:	c3                   	ret    
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec5:	eb ec                	jmp    80104eb3 <sys_fstat+0x53>
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <sys_link>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ed5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ed8:	53                   	push   %ebx
80104ed9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104edc:	50                   	push   %eax
80104edd:	6a 00                	push   $0x0
80104edf:	e8 0c fb ff ff       	call   801049f0 <argstr>
80104ee4:	83 c4 10             	add    $0x10,%esp
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	0f 88 fb 00 00 00    	js     80104fea <sys_link+0x11a>
80104eef:	83 ec 08             	sub    $0x8,%esp
80104ef2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ef5:	50                   	push   %eax
80104ef6:	6a 01                	push   $0x1
80104ef8:	e8 f3 fa ff ff       	call   801049f0 <argstr>
80104efd:	83 c4 10             	add    $0x10,%esp
80104f00:	85 c0                	test   %eax,%eax
80104f02:	0f 88 e2 00 00 00    	js     80104fea <sys_link+0x11a>
  begin_op();
80104f08:	e8 53 de ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80104f0d:	83 ec 0c             	sub    $0xc,%esp
80104f10:	ff 75 d4             	push   -0x2c(%ebp)
80104f13:	e8 88 d1 ff ff       	call   801020a0 <namei>
80104f18:	83 c4 10             	add    $0x10,%esp
80104f1b:	89 c3                	mov    %eax,%ebx
80104f1d:	85 c0                	test   %eax,%eax
80104f1f:	0f 84 e4 00 00 00    	je     80105009 <sys_link+0x139>
  ilock(ip);
80104f25:	83 ec 0c             	sub    $0xc,%esp
80104f28:	50                   	push   %eax
80104f29:	e8 52 c8 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f36:	0f 84 b5 00 00 00    	je     80104ff1 <sys_link+0x121>
  iupdate(ip);
80104f3c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f3f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f47:	53                   	push   %ebx
80104f48:	e8 83 c7 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80104f4d:	89 1c 24             	mov    %ebx,(%esp)
80104f50:	e8 0b c9 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f55:	58                   	pop    %eax
80104f56:	5a                   	pop    %edx
80104f57:	57                   	push   %edi
80104f58:	ff 75 d0             	push   -0x30(%ebp)
80104f5b:	e8 60 d1 ff ff       	call   801020c0 <nameiparent>
80104f60:	83 c4 10             	add    $0x10,%esp
80104f63:	89 c6                	mov    %eax,%esi
80104f65:	85 c0                	test   %eax,%eax
80104f67:	74 5b                	je     80104fc4 <sys_link+0xf4>
  ilock(dp);
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	50                   	push   %eax
80104f6d:	e8 0e c8 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f72:	8b 03                	mov    (%ebx),%eax
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	39 06                	cmp    %eax,(%esi)
80104f79:	75 3d                	jne    80104fb8 <sys_link+0xe8>
80104f7b:	83 ec 04             	sub    $0x4,%esp
80104f7e:	ff 73 04             	push   0x4(%ebx)
80104f81:	57                   	push   %edi
80104f82:	56                   	push   %esi
80104f83:	e8 58 d0 ff ff       	call   80101fe0 <dirlink>
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	85 c0                	test   %eax,%eax
80104f8d:	78 29                	js     80104fb8 <sys_link+0xe8>
  iunlockput(dp);
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	56                   	push   %esi
80104f93:	e8 78 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104f98:	89 1c 24             	mov    %ebx,(%esp)
80104f9b:	e8 10 c9 ff ff       	call   801018b0 <iput>
  end_op();
80104fa0:	e8 2b de ff ff       	call   80102dd0 <end_op>
  return 0;
80104fa5:	83 c4 10             	add    $0x10,%esp
80104fa8:	31 c0                	xor    %eax,%eax
}
80104faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fad:	5b                   	pop    %ebx
80104fae:	5e                   	pop    %esi
80104faf:	5f                   	pop    %edi
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    
80104fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fb8:	83 ec 0c             	sub    $0xc,%esp
80104fbb:	56                   	push   %esi
80104fbc:	e8 4f ca ff ff       	call   80101a10 <iunlockput>
    goto bad;
80104fc1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	53                   	push   %ebx
80104fc8:	e8 b3 c7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
80104fcd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fd2:	89 1c 24             	mov    %ebx,(%esp)
80104fd5:	e8 f6 c6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80104fda:	89 1c 24             	mov    %ebx,(%esp)
80104fdd:	e8 2e ca ff ff       	call   80101a10 <iunlockput>
  end_op();
80104fe2:	e8 e9 dd ff ff       	call   80102dd0 <end_op>
  return -1;
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fef:	eb b9                	jmp    80104faa <sys_link+0xda>
    iunlockput(ip);
80104ff1:	83 ec 0c             	sub    $0xc,%esp
80104ff4:	53                   	push   %ebx
80104ff5:	e8 16 ca ff ff       	call   80101a10 <iunlockput>
    end_op();
80104ffa:	e8 d1 dd ff ff       	call   80102dd0 <end_op>
    return -1;
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105007:	eb a1                	jmp    80104faa <sys_link+0xda>
    end_op();
80105009:	e8 c2 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010500e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105013:	eb 95                	jmp    80104faa <sys_link+0xda>
80105015:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105020 <sys_unlink>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105025:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105028:	53                   	push   %ebx
80105029:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 bc f9 ff ff       	call   801049f0 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 7a 01 00 00    	js     801051b9 <sys_unlink+0x199>
  begin_op();
8010503f:	e8 1c dd ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105044:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105047:	83 ec 08             	sub    $0x8,%esp
8010504a:	53                   	push   %ebx
8010504b:	ff 75 c0             	push   -0x40(%ebp)
8010504e:	e8 6d d0 ff ff       	call   801020c0 <nameiparent>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105059:	85 c0                	test   %eax,%eax
8010505b:	0f 84 62 01 00 00    	je     801051c3 <sys_unlink+0x1a3>
  ilock(dp);
80105061:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105064:	83 ec 0c             	sub    $0xc,%esp
80105067:	57                   	push   %edi
80105068:	e8 13 c7 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010506d:	58                   	pop    %eax
8010506e:	5a                   	pop    %edx
8010506f:	68 24 80 10 80       	push   $0x80108024
80105074:	53                   	push   %ebx
80105075:	e8 46 cc ff ff       	call   80101cc0 <namecmp>
8010507a:	83 c4 10             	add    $0x10,%esp
8010507d:	85 c0                	test   %eax,%eax
8010507f:	0f 84 fb 00 00 00    	je     80105180 <sys_unlink+0x160>
80105085:	83 ec 08             	sub    $0x8,%esp
80105088:	68 23 80 10 80       	push   $0x80108023
8010508d:	53                   	push   %ebx
8010508e:	e8 2d cc ff ff       	call   80101cc0 <namecmp>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	0f 84 e2 00 00 00    	je     80105180 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010509e:	83 ec 04             	sub    $0x4,%esp
801050a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050a4:	50                   	push   %eax
801050a5:	53                   	push   %ebx
801050a6:	57                   	push   %edi
801050a7:	e8 34 cc ff ff       	call   80101ce0 <dirlookup>
801050ac:	83 c4 10             	add    $0x10,%esp
801050af:	89 c3                	mov    %eax,%ebx
801050b1:	85 c0                	test   %eax,%eax
801050b3:	0f 84 c7 00 00 00    	je     80105180 <sys_unlink+0x160>
  ilock(ip);
801050b9:	83 ec 0c             	sub    $0xc,%esp
801050bc:	50                   	push   %eax
801050bd:	e8 be c6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ca:	0f 8e 1c 01 00 00    	jle    801051ec <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050d8:	74 66                	je     80105140 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050da:	83 ec 04             	sub    $0x4,%esp
801050dd:	6a 10                	push   $0x10
801050df:	6a 00                	push   $0x0
801050e1:	57                   	push   %edi
801050e2:	e8 89 f5 ff ff       	call   80104670 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050e7:	6a 10                	push   $0x10
801050e9:	ff 75 c4             	push   -0x3c(%ebp)
801050ec:	57                   	push   %edi
801050ed:	ff 75 b4             	push   -0x4c(%ebp)
801050f0:	e8 9b ca ff ff       	call   80101b90 <writei>
801050f5:	83 c4 20             	add    $0x20,%esp
801050f8:	83 f8 10             	cmp    $0x10,%eax
801050fb:	0f 85 de 00 00 00    	jne    801051df <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105106:	0f 84 94 00 00 00    	je     801051a0 <sys_unlink+0x180>
  iunlockput(dp);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	ff 75 b4             	push   -0x4c(%ebp)
80105112:	e8 f9 c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105117:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010511c:	89 1c 24             	mov    %ebx,(%esp)
8010511f:	e8 ac c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105124:	89 1c 24             	mov    %ebx,(%esp)
80105127:	e8 e4 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010512c:	e8 9f dc ff ff       	call   80102dd0 <end_op>
  return 0;
80105131:	83 c4 10             	add    $0x10,%esp
80105134:	31 c0                	xor    %eax,%eax
}
80105136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5f                   	pop    %edi
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret    
8010513e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105140:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105144:	76 94                	jbe    801050da <sys_unlink+0xba>
80105146:	be 20 00 00 00       	mov    $0x20,%esi
8010514b:	eb 0b                	jmp    80105158 <sys_unlink+0x138>
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
80105150:	83 c6 10             	add    $0x10,%esi
80105153:	3b 73 58             	cmp    0x58(%ebx),%esi
80105156:	73 82                	jae    801050da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105158:	6a 10                	push   $0x10
8010515a:	56                   	push   %esi
8010515b:	57                   	push   %edi
8010515c:	53                   	push   %ebx
8010515d:	e8 2e c9 ff ff       	call   80101a90 <readi>
80105162:	83 c4 10             	add    $0x10,%esp
80105165:	83 f8 10             	cmp    $0x10,%eax
80105168:	75 68                	jne    801051d2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010516a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010516f:	74 df                	je     80105150 <sys_unlink+0x130>
    iunlockput(ip);
80105171:	83 ec 0c             	sub    $0xc,%esp
80105174:	53                   	push   %ebx
80105175:	e8 96 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	ff 75 b4             	push   -0x4c(%ebp)
80105186:	e8 85 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010518b:	e8 40 dc ff ff       	call   80102dd0 <end_op>
  return -1;
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105198:	eb 9c                	jmp    80105136 <sys_unlink+0x116>
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051a0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051a3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051a6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051ab:	50                   	push   %eax
801051ac:	e8 1f c5 ff ff       	call   801016d0 <iupdate>
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	e9 53 ff ff ff       	jmp    8010510c <sys_unlink+0xec>
    return -1;
801051b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051be:	e9 73 ff ff ff       	jmp    80105136 <sys_unlink+0x116>
    end_op();
801051c3:	e8 08 dc ff ff       	call   80102dd0 <end_op>
    return -1;
801051c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cd:	e9 64 ff ff ff       	jmp    80105136 <sys_unlink+0x116>
      panic("isdirempty: readi");
801051d2:	83 ec 0c             	sub    $0xc,%esp
801051d5:	68 48 80 10 80       	push   $0x80108048
801051da:	e8 a1 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801051df:	83 ec 0c             	sub    $0xc,%esp
801051e2:	68 5a 80 10 80       	push   $0x8010805a
801051e7:	e8 94 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	68 36 80 10 80       	push   $0x80108036
801051f4:	e8 87 b1 ff ff       	call   80100380 <panic>
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105200 <sys_open>:

int
sys_open(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105205:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105208:	53                   	push   %ebx
80105209:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 dc f7 ff ff       	call   801049f0 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 8e 00 00 00    	js     801052ad <sys_open+0xad>
8010521f:	83 ec 08             	sub    $0x8,%esp
80105222:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105225:	50                   	push   %eax
80105226:	6a 01                	push   $0x1
80105228:	e8 03 f7 ff ff       	call   80104930 <argint>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	78 79                	js     801052ad <sys_open+0xad>
    return -1;

  begin_op();
80105234:	e8 27 db ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105239:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010523d:	75 79                	jne    801052b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	ff 75 e0             	push   -0x20(%ebp)
80105245:	e8 56 ce ff ff       	call   801020a0 <namei>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	89 c6                	mov    %eax,%esi
8010524f:	85 c0                	test   %eax,%eax
80105251:	0f 84 7e 00 00 00    	je     801052d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105257:	83 ec 0c             	sub    $0xc,%esp
8010525a:	50                   	push   %eax
8010525b:	e8 20 c5 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105268:	0f 84 c2 00 00 00    	je     80105330 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010526e:	e8 bd bb ff ff       	call   80100e30 <filealloc>
80105273:	89 c7                	mov    %eax,%edi
80105275:	85 c0                	test   %eax,%eax
80105277:	74 23                	je     8010529c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105279:	e8 02 e7 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010527e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105280:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105284:	85 d2                	test   %edx,%edx
80105286:	74 60                	je     801052e8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c3 01             	add    $0x1,%ebx
8010528b:	83 fb 10             	cmp    $0x10,%ebx
8010528e:	75 f0                	jne    80105280 <sys_open+0x80>
    if(f)
      fileclose(f);
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	57                   	push   %edi
80105294:	e8 57 bc ff ff       	call   80100ef0 <fileclose>
80105299:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	56                   	push   %esi
801052a0:	e8 6b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052a5:	e8 26 db ff ff       	call   80102dd0 <end_op>
    return -1;
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052b2:	eb 6d                	jmp    80105321 <sys_open+0x121>
801052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052b8:	83 ec 0c             	sub    $0xc,%esp
801052bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052be:	31 c9                	xor    %ecx,%ecx
801052c0:	ba 02 00 00 00       	mov    $0x2,%edx
801052c5:	6a 00                	push   $0x0
801052c7:	e8 14 f8 ff ff       	call   80104ae0 <create>
    if(ip == 0){
801052cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052d1:	85 c0                	test   %eax,%eax
801052d3:	75 99                	jne    8010526e <sys_open+0x6e>
      end_op();
801052d5:	e8 f6 da ff ff       	call   80102dd0 <end_op>
      return -1;
801052da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052df:	eb 40                	jmp    80105321 <sys_open+0x121>
801052e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052e8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052ef:	56                   	push   %esi
801052f0:	e8 6b c5 ff ff       	call   80101860 <iunlock>
  end_op();
801052f5:	e8 d6 da ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
801052fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105300:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105303:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105306:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105309:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010530b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105312:	f7 d0                	not    %eax
80105314:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105317:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010531a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010531d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105324:	89 d8                	mov    %ebx,%eax
80105326:	5b                   	pop    %ebx
80105327:	5e                   	pop    %esi
80105328:	5f                   	pop    %edi
80105329:	5d                   	pop    %ebp
8010532a:	c3                   	ret    
8010532b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010532f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105330:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105333:	85 c9                	test   %ecx,%ecx
80105335:	0f 84 33 ff ff ff    	je     8010526e <sys_open+0x6e>
8010533b:	e9 5c ff ff ff       	jmp    8010529c <sys_open+0x9c>

80105340 <sys_mkdir>:

int
sys_mkdir(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105346:	e8 15 da ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010534b:	83 ec 08             	sub    $0x8,%esp
8010534e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105351:	50                   	push   %eax
80105352:	6a 00                	push   $0x0
80105354:	e8 97 f6 ff ff       	call   801049f0 <argstr>
80105359:	83 c4 10             	add    $0x10,%esp
8010535c:	85 c0                	test   %eax,%eax
8010535e:	78 30                	js     80105390 <sys_mkdir+0x50>
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105366:	31 c9                	xor    %ecx,%ecx
80105368:	ba 01 00 00 00       	mov    $0x1,%edx
8010536d:	6a 00                	push   $0x0
8010536f:	e8 6c f7 ff ff       	call   80104ae0 <create>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	74 15                	je     80105390 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010537b:	83 ec 0c             	sub    $0xc,%esp
8010537e:	50                   	push   %eax
8010537f:	e8 8c c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105384:	e8 47 da ff ff       	call   80102dd0 <end_op>
  return 0;
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	31 c0                	xor    %eax,%eax
}
8010538e:	c9                   	leave  
8010538f:	c3                   	ret    
    end_op();
80105390:	e8 3b da ff ff       	call   80102dd0 <end_op>
    return -1;
80105395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010539a:	c9                   	leave  
8010539b:	c3                   	ret    
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_mknod>:

int
sys_mknod(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053a6:	e8 b5 d9 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053ab:	83 ec 08             	sub    $0x8,%esp
801053ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053b1:	50                   	push   %eax
801053b2:	6a 00                	push   $0x0
801053b4:	e8 37 f6 ff ff       	call   801049f0 <argstr>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	85 c0                	test   %eax,%eax
801053be:	78 60                	js     80105420 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053c0:	83 ec 08             	sub    $0x8,%esp
801053c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c6:	50                   	push   %eax
801053c7:	6a 01                	push   $0x1
801053c9:	e8 62 f5 ff ff       	call   80104930 <argint>
  if((argstr(0, &path)) < 0 ||
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 4b                	js     80105420 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053d5:	83 ec 08             	sub    $0x8,%esp
801053d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053db:	50                   	push   %eax
801053dc:	6a 02                	push   $0x2
801053de:	e8 4d f5 ff ff       	call   80104930 <argint>
     argint(1, &major) < 0 ||
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	78 36                	js     80105420 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053ee:	83 ec 0c             	sub    $0xc,%esp
801053f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053f5:	ba 03 00 00 00       	mov    $0x3,%edx
801053fa:	50                   	push   %eax
801053fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053fe:	e8 dd f6 ff ff       	call   80104ae0 <create>
     argint(2, &minor) < 0 ||
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	74 16                	je     80105420 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010540a:	83 ec 0c             	sub    $0xc,%esp
8010540d:	50                   	push   %eax
8010540e:	e8 fd c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105413:	e8 b8 d9 ff ff       	call   80102dd0 <end_op>
  return 0;
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	31 c0                	xor    %eax,%eax
}
8010541d:	c9                   	leave  
8010541e:	c3                   	ret    
8010541f:	90                   	nop
    end_op();
80105420:	e8 ab d9 ff ff       	call   80102dd0 <end_op>
    return -1;
80105425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010542a:	c9                   	leave  
8010542b:	c3                   	ret    
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_chdir>:

int
sys_chdir(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	53                   	push   %ebx
80105435:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105438:	e8 43 e5 ff ff       	call   80103980 <myproc>
8010543d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010543f:	e8 1c d9 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544a:	50                   	push   %eax
8010544b:	6a 00                	push   $0x0
8010544d:	e8 9e f5 ff ff       	call   801049f0 <argstr>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	85 c0                	test   %eax,%eax
80105457:	78 77                	js     801054d0 <sys_chdir+0xa0>
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	ff 75 f4             	push   -0xc(%ebp)
8010545f:	e8 3c cc ff ff       	call   801020a0 <namei>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	89 c3                	mov    %eax,%ebx
80105469:	85 c0                	test   %eax,%eax
8010546b:	74 63                	je     801054d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	50                   	push   %eax
80105471:	e8 0a c3 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105476:	83 c4 10             	add    $0x10,%esp
80105479:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010547e:	75 30                	jne    801054b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	53                   	push   %ebx
80105484:	e8 d7 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105489:	58                   	pop    %eax
8010548a:	ff 76 68             	push   0x68(%esi)
8010548d:	e8 1e c4 ff ff       	call   801018b0 <iput>
  end_op();
80105492:	e8 39 d9 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105497:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	31 c0                	xor    %eax,%eax
}
8010549f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a2:	5b                   	pop    %ebx
801054a3:	5e                   	pop    %esi
801054a4:	5d                   	pop    %ebp
801054a5:	c3                   	ret    
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 57 c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054b9:	e8 12 d9 ff ff       	call   80102dd0 <end_op>
    return -1;
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c6:	eb d7                	jmp    8010549f <sys_chdir+0x6f>
801054c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop
    end_op();
801054d0:	e8 fb d8 ff ff       	call   80102dd0 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054da:	eb c3                	jmp    8010549f <sys_chdir+0x6f>
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_exec>:

int
sys_exec(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054e5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054eb:	53                   	push   %ebx
801054ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054f2:	50                   	push   %eax
801054f3:	6a 00                	push   $0x0
801054f5:	e8 f6 f4 ff ff       	call   801049f0 <argstr>
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	85 c0                	test   %eax,%eax
801054ff:	0f 88 87 00 00 00    	js     8010558c <sys_exec+0xac>
80105505:	83 ec 08             	sub    $0x8,%esp
80105508:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010550e:	50                   	push   %eax
8010550f:	6a 01                	push   $0x1
80105511:	e8 1a f4 ff ff       	call   80104930 <argint>
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	85 c0                	test   %eax,%eax
8010551b:	78 6f                	js     8010558c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010551d:	83 ec 04             	sub    $0x4,%esp
80105520:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105526:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105528:	68 80 00 00 00       	push   $0x80
8010552d:	6a 00                	push   $0x0
8010552f:	56                   	push   %esi
80105530:	e8 3b f1 ff ff       	call   80104670 <memset>
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105540:	83 ec 08             	sub    $0x8,%esp
80105543:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105549:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105550:	50                   	push   %eax
80105551:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105557:	01 f8                	add    %edi,%eax
80105559:	50                   	push   %eax
8010555a:	e8 41 f3 ff ff       	call   801048a0 <fetchint>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	85 c0                	test   %eax,%eax
80105564:	78 26                	js     8010558c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105566:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010556c:	85 c0                	test   %eax,%eax
8010556e:	74 30                	je     801055a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105576:	52                   	push   %edx
80105577:	50                   	push   %eax
80105578:	e8 63 f3 ff ff       	call   801048e0 <fetchstr>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	78 08                	js     8010558c <sys_exec+0xac>
  for(i=0;; i++){
80105584:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105587:	83 fb 20             	cmp    $0x20,%ebx
8010558a:	75 b4                	jne    80105540 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010558c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010558f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105594:	5b                   	pop    %ebx
80105595:	5e                   	pop    %esi
80105596:	5f                   	pop    %edi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret    
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055a7:	00 00 00 00 
  return exec(path, argv);
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	56                   	push   %esi
801055af:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801055b5:	e8 f6 b4 ff ff       	call   80100ab0 <exec>
801055ba:	83 c4 10             	add    $0x10,%esp
}
801055bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c0:	5b                   	pop    %ebx
801055c1:	5e                   	pop    %esi
801055c2:	5f                   	pop    %edi
801055c3:	5d                   	pop    %ebp
801055c4:	c3                   	ret    
801055c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_pipe>:

int
sys_pipe(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055d8:	53                   	push   %ebx
801055d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055dc:	6a 08                	push   $0x8
801055de:	50                   	push   %eax
801055df:	6a 00                	push   $0x0
801055e1:	e8 9a f3 ff ff       	call   80104980 <argptr>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 4a                	js     80105637 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801055ed:	83 ec 08             	sub    $0x8,%esp
801055f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055f3:	50                   	push   %eax
801055f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055f7:	50                   	push   %eax
801055f8:	e8 43 de ff ff       	call   80103440 <pipealloc>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	78 33                	js     80105637 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105604:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105607:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105609:	e8 72 e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010560e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105610:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105614:	85 f6                	test   %esi,%esi
80105616:	74 28                	je     80105640 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105618:	83 c3 01             	add    $0x1,%ebx
8010561b:	83 fb 10             	cmp    $0x10,%ebx
8010561e:	75 f0                	jne    80105610 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	ff 75 e0             	push   -0x20(%ebp)
80105626:	e8 c5 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010562b:	58                   	pop    %eax
8010562c:	ff 75 e4             	push   -0x1c(%ebp)
8010562f:	e8 bc b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563c:	eb 53                	jmp    80105691 <sys_pipe+0xc1>
8010563e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105640:	8d 73 08             	lea    0x8(%ebx),%esi
80105643:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010564a:	e8 31 e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010564f:	31 d2                	xor    %edx,%edx
80105651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105658:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010565c:	85 c9                	test   %ecx,%ecx
8010565e:	74 20                	je     80105680 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105660:	83 c2 01             	add    $0x1,%edx
80105663:	83 fa 10             	cmp    $0x10,%edx
80105666:	75 f0                	jne    80105658 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105668:	e8 13 e3 ff ff       	call   80103980 <myproc>
8010566d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105674:	00 
80105675:	eb a9                	jmp    80105620 <sys_pipe+0x50>
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105680:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105684:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105687:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105689:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010568c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010568f:	31 c0                	xor    %eax,%eax
}
80105691:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105694:	5b                   	pop    %ebx
80105695:	5e                   	pop    %esi
80105696:	5f                   	pop    %edi
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	66 90                	xchg   %ax,%ax
8010569b:	66 90                	xchg   %ax,%ax
8010569d:	66 90                	xchg   %ax,%ax
8010569f:	90                   	nop

801056a0 <sys_iomap>:
#define HP_addrspace_Error	"XV6_TEST: HP Mapping Physical Address is not within huge page space!\n"
#define HP_userspace_Error	"XV6_TEST: HP Mapping Virtual Address exceeds user space!\n"

int
sys_iomap(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	53                   	push   %ebx
801056a5:	83 ec 10             	sub    $0x10,%esp
  // Task 1
  uint paddr; // physical address
  uint size; // size
  uint vaddr; // virtual address 

  struct proc *currproc = myproc(); // current process
801056a8:	e8 d3 e2 ff ff       	call   80103980 <myproc>

  // error checking: paddr and size cannot be negative  
  if(argint(0, (int*)&paddr) < 0) {
801056ad:	83 ec 08             	sub    $0x8,%esp
  struct proc *currproc = myproc(); // current process
801056b0:	89 c6                	mov    %eax,%esi
  if(argint(0, (int*)&paddr) < 0) {
801056b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b5:	50                   	push   %eax
801056b6:	6a 00                	push   $0x0
801056b8:	e8 73 f2 ff ff       	call   80104930 <argint>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	0f 88 a0 00 00 00    	js     80105768 <sys_iomap+0xc8>
    return -1;
  }
  if(argint(1, (int*)&size) < 0) {
801056c8:	83 ec 08             	sub    $0x8,%esp
801056cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ce:	50                   	push   %eax
801056cf:	6a 01                	push   $0x1
801056d1:	e8 5a f2 ff ff       	call   80104930 <argint>
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	85 c0                	test   %eax,%eax
801056db:	0f 88 87 00 00 00    	js     80105768 <sys_iomap+0xc8>
    return -1; 
  }

  // error checking: paddr has to be aligned to 4KB
  if(paddr % PGSIZE != 0) {
801056e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056e4:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
801056ea:	0f 85 ae 00 00 00    	jne    8010579e <sys_iomap+0xfe>
    cprintf(IO_addralign_Error);
    return -1; 
  }

  // error checking: size must be aligned to 4KB
  if(size % PGSIZE != 0) {
801056f0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801056f3:	f7 c1 ff 0f 00 00    	test   $0xfff,%ecx
801056f9:	0f 85 88 00 00 00    	jne    80105787 <sys_iomap+0xe7>
    cprintf(IO_sizealign_Error);
    return -1; 
  }

  // error checking: paddr not in device space
  if(!(paddr >= DEVSPACE)) {
801056ff:	81 fa ff ff ff fd    	cmp    $0xfdffffff,%edx
80105705:	76 4b                	jbe    80105752 <sys_iomap+0xb2>
    cprintf(IO_addrspace_Error);
    return -1; 
  }

  // allocate VA in user space starting from current  process size
  vaddr = PGROUNDUP(currproc->sz);
80105707:	8b 06                	mov    (%esi),%eax
80105709:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010570f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

  // error checking: vaddr total space (vaddr + size) cannot exceed user space
  // in other words, cannot be in the kernel space
  if ((vaddr + size) > KERNBASE) {
80105715:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
80105718:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010571d:	77 51                	ja     80105770 <sys_iomap+0xd0>
  // PTE_W: io needs to write 
  // PTE_U: need to map to user space
  // PTE_PWT
  // PTE_PCD
  // PTE_DEV: need to map devices 
  if(mappages(currproc->pgdir, (char*)vaddr, size, paddr, PTE_W | PTE_U | PTE_PWT | PTE_PCD | PTE_DEV) == -1) {  
8010571f:	83 ec 0c             	sub    $0xc,%esp
80105722:	6a 3e                	push   $0x3e
80105724:	52                   	push   %edx
80105725:	51                   	push   %ecx
80105726:	53                   	push   %ebx
80105727:	ff 76 04             	push   0x4(%esi)
8010572a:	e8 61 14 00 00       	call   80106b90 <mappages>
8010572f:	83 c4 20             	add    $0x20,%esp
80105732:	83 f8 ff             	cmp    $0xffffffff,%eax
80105735:	74 31                	je     80105768 <sys_iomap+0xc8>
    return -1;
  }

  // map pages returned a valid result
  // update the process size
  currproc->sz = vaddr + size; 
80105737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573a:	01 d8                	add    %ebx,%eax
8010573c:	89 06                	mov    %eax,(%esi)

  // flush TLB
  lcr3(V2P(currproc->pgdir));
8010573e:	8b 46 04             	mov    0x4(%esi),%eax
80105741:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105746:	0f 22 d8             	mov    %eax,%cr3
  
  return vaddr;
80105749:	89 d8                	mov    %ebx,%eax
}
8010574b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010574e:	5b                   	pop    %ebx
8010574f:	5e                   	pop    %esi
80105750:	5d                   	pop    %ebp
80105751:	c3                   	ret    
    cprintf(IO_addrspace_Error);
80105752:	83 ec 0c             	sub    $0xc,%esp
80105755:	68 e0 80 10 80       	push   $0x801080e0
8010575a:	e8 41 af ff ff       	call   801006a0 <cprintf>
    return -1; 
8010575f:	83 c4 10             	add    $0x10,%esp
80105762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576d:	eb dc                	jmp    8010574b <sys_iomap+0xab>
8010576f:	90                   	nop
    cprintf(IO_userspace_Error);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	68 24 81 10 80       	push   $0x80108124
80105778:	e8 23 af ff ff       	call   801006a0 <cprintf>
    return -1;
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105785:	eb c4                	jmp    8010574b <sys_iomap+0xab>
    cprintf(IO_sizealign_Error);
80105787:	83 ec 0c             	sub    $0xc,%esp
8010578a:	68 ac 80 10 80       	push   $0x801080ac
8010578f:	e8 0c af ff ff       	call   801006a0 <cprintf>
    return -1; 
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579c:	eb ad                	jmp    8010574b <sys_iomap+0xab>
    cprintf(IO_addralign_Error);
8010579e:	83 ec 0c             	sub    $0xc,%esp
801057a1:	68 6c 80 10 80       	push   $0x8010806c
801057a6:	e8 f5 ae ff ff       	call   801006a0 <cprintf>
    return -1; 
801057ab:	83 c4 10             	add    $0x10,%esp
801057ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b3:	eb 96                	jmp    8010574b <sys_iomap+0xab>
801057b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_hpmap>:

int
sys_hpmap(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
801057c5:	83 ec 10             	sub    $0x10,%esp
  uint paddr;
  uint size;
  uint vaddr;

  struct proc *currproc = myproc();
801057c8:	e8 b3 e1 ff ff       	call   80103980 <myproc>

  // get arguments, check that they exist 
  if (argint(0, (int*)&paddr) < 0) {
801057cd:	83 ec 08             	sub    $0x8,%esp
  struct proc *currproc = myproc();
801057d0:	89 c6                	mov    %eax,%esi
  if (argint(0, (int*)&paddr) < 0) {
801057d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057d5:	50                   	push   %eax
801057d6:	6a 00                	push   $0x0
801057d8:	e8 53 f1 ff ff       	call   80104930 <argint>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	0f 88 a8 00 00 00    	js     80105890 <sys_hpmap+0xd0>
    return -1;
  } 
  if (argint(1, (int*)&size) < 0) {
801057e8:	83 ec 08             	sub    $0x8,%esp
801057eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ee:	50                   	push   %eax
801057ef:	6a 01                	push   $0x1
801057f1:	e8 3a f1 ff ff       	call   80104930 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	0f 88 8f 00 00 00    	js     80105890 <sys_hpmap+0xd0>
    return -1;
  }
    

  // error checking: p addr not aligned 
  if (paddr % (1 << PDXSHIFT) != 0) {
80105801:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105804:	f7 c2 ff ff 3f 00    	test   $0x3fffff,%edx
8010580a:	0f 85 be 00 00 00    	jne    801058ce <sys_hpmap+0x10e>
    cprintf(HP_addralign_Error);
    return -1;
  }

  // error checking: size not aligned 
  if (size % (1 << PDXSHIFT) != 0) {
80105810:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105813:	f7 c1 ff ff 3f 00    	test   $0x3fffff,%ecx
80105819:	0f 85 98 00 00 00    	jne    801058b7 <sys_hpmap+0xf7>
    cprintf(HP_sizealign_Error);
    return -1;
  }

  // physical address not within huge page space
  if (paddr < HUGE_PAGE_START || paddr >= HUGE_PAGE_END) {
8010581f:	8d 82 00 00 00 e2    	lea    -0x1e000000(%edx),%eax
80105825:	3d ff ff ff 01       	cmp    $0x1ffffff,%eax
8010582a:	77 4a                	ja     80105876 <sys_hpmap+0xb6>
    cprintf(HP_addrspace_Error);
    return -1;
  }

  // pick next aligned virtual address (aligned to huge page)
  vaddr = HPROUNDUP(currproc->sz);
8010582c:	8b 06                	mov    (%esi),%eax
8010582e:	8d 98 ff ff 3f 00    	lea    0x3fffff(%eax),%ebx
80105834:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx

  // error checking: not in user space 
  if (vaddr + size > KERNBASE) {
8010583a:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
8010583d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80105842:	77 5c                	ja     801058a0 <sys_hpmap+0xe0>
    return -1;
  }

  // check that mapping returns valid 
  // write and user flags 
  if (hpmappages(currproc->pgdir, (char*)vaddr, size, paddr, PTE_W | PTE_U) < 0)
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	6a 06                	push   $0x6
80105849:	52                   	push   %edx
8010584a:	51                   	push   %ecx
8010584b:	53                   	push   %ebx
8010584c:	ff 76 04             	push   0x4(%esi)
8010584f:	e8 2c 14 00 00       	call   80106c80 <hpmappages>
80105854:	83 c4 20             	add    $0x20,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	78 35                	js     80105890 <sys_hpmap+0xd0>
    return -1;

  currproc->sz = vaddr + size;
8010585b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585e:	01 d8                	add    %ebx,%eax
80105860:	89 06                	mov    %eax,(%esi)

  // flush TLB
  lcr3(V2P(currproc->pgdir));
80105862:	8b 46 04             	mov    0x4(%esi),%eax
80105865:	05 00 00 00 80       	add    $0x80000000,%eax
8010586a:	0f 22 d8             	mov    %eax,%cr3

  return vaddr;
8010586d:	89 d8                	mov    %ebx,%eax
}
8010586f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105872:	5b                   	pop    %ebx
80105873:	5e                   	pop    %esi
80105874:	5d                   	pop    %ebp
80105875:	c3                   	ret    
    cprintf(HP_addrspace_Error);
80105876:	83 ec 0c             	sub    $0xc,%esp
80105879:	68 d4 81 10 80       	push   $0x801081d4
8010587e:	e8 1d ae ff ff       	call   801006a0 <cprintf>
    return -1;
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	eb d8                	jmp    8010586f <sys_hpmap+0xaf>
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax
    cprintf(HP_userspace_Error);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	68 1c 82 10 80       	push   $0x8010821c
801058a8:	e8 f3 ad ff ff       	call   801006a0 <cprintf>
    return -1;
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	eb b8                	jmp    8010586f <sys_hpmap+0xaf>
    cprintf(HP_sizealign_Error);
801058b7:	83 ec 0c             	sub    $0xc,%esp
801058ba:	68 a0 81 10 80       	push   $0x801081a0
801058bf:	e8 dc ad ff ff       	call   801006a0 <cprintf>
    return -1;
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cc:	eb a1                	jmp    8010586f <sys_hpmap+0xaf>
    cprintf(HP_addralign_Error);
801058ce:	83 ec 0c             	sub    $0xc,%esp
801058d1:	68 60 81 10 80       	push   $0x80108160
801058d6:	e8 c5 ad ff ff       	call   801006a0 <cprintf>
    return -1;
801058db:	83 c4 10             	add    $0x10,%esp
801058de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e3:	eb 8a                	jmp    8010586f <sys_hpmap+0xaf>
801058e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_fork>:

int
sys_fork(void)
{
  return fork();
801058f0:	e9 2b e2 ff ff       	jmp    80103b20 <fork>
801058f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_exit>:
}

int
sys_exit(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 08             	sub    $0x8,%esp
  exit();
80105906:	e8 95 e4 ff ff       	call   80103da0 <exit>
  return 0;  // not reached
}
8010590b:	31 c0                	xor    %eax,%eax
8010590d:	c9                   	leave  
8010590e:	c3                   	ret    
8010590f:	90                   	nop

80105910 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105910:	e9 bb e5 ff ff       	jmp    80103ed0 <wait>
80105915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_kill>:
}

int
sys_kill(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105926:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105929:	50                   	push   %eax
8010592a:	6a 00                	push   $0x0
8010592c:	e8 ff ef ff ff       	call   80104930 <argint>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	85 c0                	test   %eax,%eax
80105936:	78 18                	js     80105950 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	ff 75 f4             	push   -0xc(%ebp)
8010593e:	e8 2d e8 ff ff       	call   80104170 <kill>
80105943:	83 c4 10             	add    $0x10,%esp
}
80105946:	c9                   	leave  
80105947:	c3                   	ret    
80105948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594f:	90                   	nop
80105950:	c9                   	leave  
    return -1;
80105951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105956:	c3                   	ret    
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax

80105960 <sys_getpid>:

int
sys_getpid(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105966:	e8 15 e0 ff ff       	call   80103980 <myproc>
8010596b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010596e:	c9                   	leave  
8010596f:	c3                   	ret    

80105970 <sys_sbrk>:

int
sys_sbrk(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105974:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105977:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010597a:	50                   	push   %eax
8010597b:	6a 00                	push   $0x0
8010597d:	e8 ae ef ff ff       	call   80104930 <argint>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	78 27                	js     801059b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105989:	e8 f2 df ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
8010598e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105991:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105993:	ff 75 f4             	push   -0xc(%ebp)
80105996:	e8 05 e1 ff ff       	call   80103aa0 <growproc>
8010599b:	83 c4 10             	add    $0x10,%esp
8010599e:	85 c0                	test   %eax,%eax
801059a0:	78 0e                	js     801059b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059a2:	89 d8                	mov    %ebx,%eax
801059a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a7:	c9                   	leave  
801059a8:	c3                   	ret    
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059b5:	eb eb                	jmp    801059a2 <sys_sbrk+0x32>
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax

801059c0 <sys_sleep>:

int
sys_sleep(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ca:	50                   	push   %eax
801059cb:	6a 00                	push   $0x0
801059cd:	e8 5e ef ff ff       	call   80104930 <argint>
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	85 c0                	test   %eax,%eax
801059d7:	0f 88 8a 00 00 00    	js     80105a67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	68 80 4c 11 80       	push   $0x80114c80
801059e5:	e8 c6 eb ff ff       	call   801045b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059ed:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  while(ticks - ticks0 < n){
801059f3:	83 c4 10             	add    $0x10,%esp
801059f6:	85 d2                	test   %edx,%edx
801059f8:	75 27                	jne    80105a21 <sys_sleep+0x61>
801059fa:	eb 54                	jmp    80105a50 <sys_sleep+0x90>
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a00:	83 ec 08             	sub    $0x8,%esp
80105a03:	68 80 4c 11 80       	push   $0x80114c80
80105a08:	68 60 4c 11 80       	push   $0x80114c60
80105a0d:	e8 3e e6 ff ff       	call   80104050 <sleep>
  while(ticks - ticks0 < n){
80105a12:	a1 60 4c 11 80       	mov    0x80114c60,%eax
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	29 d8                	sub    %ebx,%eax
80105a1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a1f:	73 2f                	jae    80105a50 <sys_sleep+0x90>
    if(myproc()->killed){
80105a21:	e8 5a df ff ff       	call   80103980 <myproc>
80105a26:	8b 40 24             	mov    0x24(%eax),%eax
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	74 d3                	je     80105a00 <sys_sleep+0x40>
      release(&tickslock);
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	68 80 4c 11 80       	push   $0x80114c80
80105a35:	e8 16 eb ff ff       	call   80104550 <release>
  }
  release(&tickslock);
  return 0;
}
80105a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	68 80 4c 11 80       	push   $0x80114c80
80105a58:	e8 f3 ea ff ff       	call   80104550 <release>
  return 0;
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	31 c0                	xor    %eax,%eax
}
80105a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a65:	c9                   	leave  
80105a66:	c3                   	ret    
    return -1;
80105a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6c:	eb f4                	jmp    80105a62 <sys_sleep+0xa2>
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_dpu>:

extern void DPU_loop(void);

int
sys_dpu(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 08             	sub    $0x8,%esp
  DPU_loop();
80105a76:	e8 35 1b 00 00       	call   801075b0 <DPU_loop>
  return 0;
}
80105a7b:	31 c0                	xor    %eax,%eax
80105a7d:	c9                   	leave  
80105a7e:	c3                   	ret    
80105a7f:	90                   	nop

80105a80 <sys_ssd>:

extern void SSD_loop(void);

int
sys_ssd(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 08             	sub    $0x8,%esp
  SSD_loop();
80105a86:	e8 75 1d 00 00       	call   80107800 <SSD_loop>
  return 0;
}
80105a8b:	31 c0                	xor    %eax,%eax
80105a8d:	c9                   	leave  
80105a8e:	c3                   	ret    
80105a8f:	90                   	nop

80105a90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
80105a94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a97:	68 80 4c 11 80       	push   $0x80114c80
80105a9c:	e8 0f eb ff ff       	call   801045b0 <acquire>
  xticks = ticks;
80105aa1:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  release(&tickslock);
80105aa7:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105aae:	e8 9d ea ff ff       	call   80104550 <release>
  return xticks;
}
80105ab3:	89 d8                	mov    %ebx,%eax
80105ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab8:	c9                   	leave  
80105ab9:	c3                   	ret    

80105aba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105aba:	1e                   	push   %ds
  pushl %es
80105abb:	06                   	push   %es
  pushl %fs
80105abc:	0f a0                	push   %fs
  pushl %gs
80105abe:	0f a8                	push   %gs
  pushal
80105ac0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ac1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ac5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ac7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ac9:	54                   	push   %esp
  call trap
80105aca:	e8 c1 00 00 00       	call   80105b90 <trap>
  addl $4, %esp
80105acf:	83 c4 04             	add    $0x4,%esp

80105ad2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ad2:	61                   	popa   
  popl %gs
80105ad3:	0f a9                	pop    %gs
  popl %fs
80105ad5:	0f a1                	pop    %fs
  popl %es
80105ad7:	07                   	pop    %es
  popl %ds
80105ad8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ad9:	83 c4 08             	add    $0x8,%esp
  iret
80105adc:	cf                   	iret   
80105add:	66 90                	xchg   %ax,%ax
80105adf:	90                   	nop

80105ae0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ae0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ae1:	31 c0                	xor    %eax,%eax
{
80105ae3:	89 e5                	mov    %esp,%ebp
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aef:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105af0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105af7:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
80105afe:	08 00 00 8e 
80105b02:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105b09:	80 
80105b0a:	c1 ea 10             	shr    $0x10,%edx
80105b0d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105b14:	80 
  for(i = 0; i < 256; i++)
80105b15:	83 c0 01             	add    $0x1,%eax
80105b18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b1d:	75 d1                	jne    80105af0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b22:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105b27:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
80105b2e:	00 00 ef 
  initlock(&tickslock, "time");
80105b31:	68 56 82 10 80       	push   $0x80108256
80105b36:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b3b:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105b41:	c1 e8 10             	shr    $0x10,%eax
80105b44:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
80105b4a:	e8 91 e8 ff ff       	call   801043e0 <initlock>
}
80105b4f:	83 c4 10             	add    $0x10,%esp
80105b52:	c9                   	leave  
80105b53:	c3                   	ret    
80105b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop

80105b60 <idtinit>:

void
idtinit(void)
{
80105b60:	55                   	push   %ebp
  pd[0] = size-1;
80105b61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b66:	89 e5                	mov    %esp,%ebp
80105b68:	83 ec 10             	sub    $0x10,%esp
80105b6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b6f:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105b74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b78:	c1 e8 10             	shr    $0x10,%eax
80105b7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
80105b96:	83 ec 1c             	sub    $0x1c,%esp
80105b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b9f:	83 f8 40             	cmp    $0x40,%eax
80105ba2:	0f 84 68 01 00 00    	je     80105d10 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ba8:	83 e8 20             	sub    $0x20,%eax
80105bab:	83 f8 1f             	cmp    $0x1f,%eax
80105bae:	0f 87 8c 00 00 00    	ja     80105c40 <trap+0xb0>
80105bb4:	ff 24 85 fc 82 10 80 	jmp    *-0x7fef7d04(,%eax,4)
80105bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bbf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105bc0:	e8 7b c6 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105bc5:	e8 46 cd ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bca:	e8 b1 dd ff ff       	call   80103980 <myproc>
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	74 1d                	je     80105bf0 <trap+0x60>
80105bd3:	e8 a8 dd ff ff       	call   80103980 <myproc>
80105bd8:	8b 50 24             	mov    0x24(%eax),%edx
80105bdb:	85 d2                	test   %edx,%edx
80105bdd:	74 11                	je     80105bf0 <trap+0x60>
80105bdf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105be3:	83 e0 03             	and    $0x3,%eax
80105be6:	66 83 f8 03          	cmp    $0x3,%ax
80105bea:	0f 84 e8 01 00 00    	je     80105dd8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105bf0:	e8 8b dd ff ff       	call   80103980 <myproc>
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	74 0f                	je     80105c08 <trap+0x78>
80105bf9:	e8 82 dd ff ff       	call   80103980 <myproc>
80105bfe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c02:	0f 84 b8 00 00 00    	je     80105cc0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c08:	e8 73 dd ff ff       	call   80103980 <myproc>
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	74 1d                	je     80105c2e <trap+0x9e>
80105c11:	e8 6a dd ff ff       	call   80103980 <myproc>
80105c16:	8b 40 24             	mov    0x24(%eax),%eax
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	74 11                	je     80105c2e <trap+0x9e>
80105c1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c21:	83 e0 03             	and    $0x3,%eax
80105c24:	66 83 f8 03          	cmp    $0x3,%ax
80105c28:	0f 84 0f 01 00 00    	je     80105d3d <trap+0x1ad>
    exit();
}
80105c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c31:	5b                   	pop    %ebx
80105c32:	5e                   	pop    %esi
80105c33:	5f                   	pop    %edi
80105c34:	5d                   	pop    %ebp
80105c35:	c3                   	ret    
80105c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c40:	e8 3b dd ff ff       	call   80103980 <myproc>
80105c45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	0f 84 a2 01 00 00    	je     80105df2 <trap+0x262>
80105c50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c54:	0f 84 98 01 00 00    	je     80105df2 <trap+0x262>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c5a:	0f 20 d1             	mov    %cr2,%ecx
80105c5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c60:	e8 fb dc ff ff       	call   80103960 <cpuid>
80105c65:	8b 73 30             	mov    0x30(%ebx),%esi
80105c68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c71:	e8 0a dd ff ff       	call   80103980 <myproc>
80105c76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c79:	e8 02 dd ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c84:	51                   	push   %ecx
80105c85:	57                   	push   %edi
80105c86:	52                   	push   %edx
80105c87:	ff 75 e4             	push   -0x1c(%ebp)
80105c8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c91:	56                   	push   %esi
80105c92:	ff 70 10             	push   0x10(%eax)
80105c95:	68 b8 82 10 80       	push   $0x801082b8
80105c9a:	e8 01 aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105c9f:	83 c4 20             	add    $0x20,%esp
80105ca2:	e8 d9 dc ff ff       	call   80103980 <myproc>
80105ca7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cae:	e8 cd dc ff ff       	call   80103980 <myproc>
80105cb3:	85 c0                	test   %eax,%eax
80105cb5:	0f 85 18 ff ff ff    	jne    80105bd3 <trap+0x43>
80105cbb:	e9 30 ff ff ff       	jmp    80105bf0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105cc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105cc4:	0f 85 3e ff ff ff    	jne    80105c08 <trap+0x78>
    yield();
80105cca:	e8 31 e3 ff ff       	call   80104000 <yield>
80105ccf:	e9 34 ff ff ff       	jmp    80105c08 <trap+0x78>
80105cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cd8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cdb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cdf:	e8 7c dc ff ff       	call   80103960 <cpuid>
80105ce4:	57                   	push   %edi
80105ce5:	56                   	push   %esi
80105ce6:	50                   	push   %eax
80105ce7:	68 60 82 10 80       	push   $0x80108260
80105cec:	e8 af a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105cf1:	e8 1a cc ff ff       	call   80102910 <lapiceoi>
    break;
80105cf6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cf9:	e8 82 dc ff ff       	call   80103980 <myproc>
80105cfe:	85 c0                	test   %eax,%eax
80105d00:	0f 85 cd fe ff ff    	jne    80105bd3 <trap+0x43>
80105d06:	e9 e5 fe ff ff       	jmp    80105bf0 <trap+0x60>
80105d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
    if(myproc()->killed)
80105d10:	e8 6b dc ff ff       	call   80103980 <myproc>
80105d15:	8b 70 24             	mov    0x24(%eax),%esi
80105d18:	85 f6                	test   %esi,%esi
80105d1a:	0f 85 c8 00 00 00    	jne    80105de8 <trap+0x258>
    myproc()->tf = tf;
80105d20:	e8 5b dc ff ff       	call   80103980 <myproc>
80105d25:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d28:	e8 43 ed ff ff       	call   80104a70 <syscall>
    if(myproc()->killed)
80105d2d:	e8 4e dc ff ff       	call   80103980 <myproc>
80105d32:	8b 48 24             	mov    0x24(%eax),%ecx
80105d35:	85 c9                	test   %ecx,%ecx
80105d37:	0f 84 f1 fe ff ff    	je     80105c2e <trap+0x9e>
}
80105d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d40:	5b                   	pop    %ebx
80105d41:	5e                   	pop    %esi
80105d42:	5f                   	pop    %edi
80105d43:	5d                   	pop    %ebp
      exit();
80105d44:	e9 57 e0 ff ff       	jmp    80103da0 <exit>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d50:	e8 3b 02 00 00       	call   80105f90 <uartintr>
    lapiceoi();
80105d55:	e8 b6 cb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d5a:	e8 21 dc ff ff       	call   80103980 <myproc>
80105d5f:	85 c0                	test   %eax,%eax
80105d61:	0f 85 6c fe ff ff    	jne    80105bd3 <trap+0x43>
80105d67:	e9 84 fe ff ff       	jmp    80105bf0 <trap+0x60>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d70:	e8 5b ca ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105d75:	e8 96 cb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d7a:	e8 01 dc ff ff       	call   80103980 <myproc>
80105d7f:	85 c0                	test   %eax,%eax
80105d81:	0f 85 4c fe ff ff    	jne    80105bd3 <trap+0x43>
80105d87:	e9 64 fe ff ff       	jmp    80105bf0 <trap+0x60>
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d90:	e8 cb db ff ff       	call   80103960 <cpuid>
80105d95:	85 c0                	test   %eax,%eax
80105d97:	0f 85 28 fe ff ff    	jne    80105bc5 <trap+0x35>
      acquire(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 80 4c 11 80       	push   $0x80114c80
80105da5:	e8 06 e8 ff ff       	call   801045b0 <acquire>
      wakeup(&ticks);
80105daa:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
      ticks++;
80105db1:	83 05 60 4c 11 80 01 	addl   $0x1,0x80114c60
      wakeup(&ticks);
80105db8:	e8 53 e3 ff ff       	call   80104110 <wakeup>
      release(&tickslock);
80105dbd:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105dc4:	e8 87 e7 ff ff       	call   80104550 <release>
80105dc9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105dcc:	e9 f4 fd ff ff       	jmp    80105bc5 <trap+0x35>
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105dd8:	e8 c3 df ff ff       	call   80103da0 <exit>
80105ddd:	e9 0e fe ff ff       	jmp    80105bf0 <trap+0x60>
80105de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105de8:	e8 b3 df ff ff       	call   80103da0 <exit>
80105ded:	e9 2e ff ff ff       	jmp    80105d20 <trap+0x190>
80105df2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105df5:	e8 66 db ff ff       	call   80103960 <cpuid>
80105dfa:	83 ec 0c             	sub    $0xc,%esp
80105dfd:	56                   	push   %esi
80105dfe:	57                   	push   %edi
80105dff:	50                   	push   %eax
80105e00:	ff 73 30             	push   0x30(%ebx)
80105e03:	68 84 82 10 80       	push   $0x80108284
80105e08:	e8 93 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105e0d:	83 c4 14             	add    $0x14,%esp
80105e10:	68 5b 82 10 80       	push   $0x8010825b
80105e15:	e8 66 a5 ff ff       	call   80100380 <panic>
80105e1a:	66 90                	xchg   %ax,%ax
80105e1c:	66 90                	xchg   %ax,%ax
80105e1e:	66 90                	xchg   %ax,%ax

80105e20 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e20:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80105e25:	85 c0                	test   %eax,%eax
80105e27:	74 17                	je     80105e40 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e29:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e2e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e2f:	a8 01                	test   $0x1,%al
80105e31:	74 0d                	je     80105e40 <uartgetc+0x20>
80105e33:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e38:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e39:	0f b6 c0             	movzbl %al,%eax
80105e3c:	c3                   	ret    
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e45:	c3                   	ret    
80105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi

80105e50 <uartinit>:
{
80105e50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e51:	31 c9                	xor    %ecx,%ecx
80105e53:	89 c8                	mov    %ecx,%eax
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	57                   	push   %edi
80105e58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e5d:	56                   	push   %esi
80105e5e:	89 fa                	mov    %edi,%edx
80105e60:	53                   	push   %ebx
80105e61:	83 ec 1c             	sub    $0x1c,%esp
80105e64:	ee                   	out    %al,(%dx)
80105e65:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e6f:	89 f2                	mov    %esi,%edx
80105e71:	ee                   	out    %al,(%dx)
80105e72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e7c:	ee                   	out    %al,(%dx)
80105e7d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e82:	89 c8                	mov    %ecx,%eax
80105e84:	89 da                	mov    %ebx,%edx
80105e86:	ee                   	out    %al,(%dx)
80105e87:	b8 03 00 00 00       	mov    $0x3,%eax
80105e8c:	89 f2                	mov    %esi,%edx
80105e8e:	ee                   	out    %al,(%dx)
80105e8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e94:	89 c8                	mov    %ecx,%eax
80105e96:	ee                   	out    %al,(%dx)
80105e97:	b8 01 00 00 00       	mov    $0x1,%eax
80105e9c:	89 da                	mov    %ebx,%edx
80105e9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ea4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105ea5:	3c ff                	cmp    $0xff,%al
80105ea7:	74 78                	je     80105f21 <uartinit+0xd1>
  uart = 1;
80105ea9:	c7 05 c0 54 11 80 01 	movl   $0x1,0x801154c0
80105eb0:	00 00 00 
80105eb3:	89 fa                	mov    %edi,%edx
80105eb5:	ec                   	in     (%dx),%al
80105eb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ebc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105ebf:	bf 7c 83 10 80       	mov    $0x8010837c,%edi
80105ec4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ec9:	6a 00                	push   $0x0
80105ecb:	6a 04                	push   $0x4
80105ecd:	e8 ae c5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ed2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ee0:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80105ee5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105eea:	85 c0                	test   %eax,%eax
80105eec:	75 14                	jne    80105f02 <uartinit+0xb2>
80105eee:	eb 23                	jmp    80105f13 <uartinit+0xc3>
    microdelay(10);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	6a 0a                	push   $0xa
80105ef5:	e8 36 ca ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	83 eb 01             	sub    $0x1,%ebx
80105f00:	74 07                	je     80105f09 <uartinit+0xb9>
80105f02:	89 f2                	mov    %esi,%edx
80105f04:	ec                   	in     (%dx),%al
80105f05:	a8 20                	test   $0x20,%al
80105f07:	74 e7                	je     80105ef0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f09:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f0d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f12:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f13:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f17:	83 c7 01             	add    $0x1,%edi
80105f1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f1d:	84 c0                	test   %al,%al
80105f1f:	75 bf                	jne    80105ee0 <uartinit+0x90>
}
80105f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f24:	5b                   	pop    %ebx
80105f25:	5e                   	pop    %esi
80105f26:	5f                   	pop    %edi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <uartputc>:
  if(!uart)
80105f30:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80105f35:	85 c0                	test   %eax,%eax
80105f37:	74 47                	je     80105f80 <uartputc+0x50>
{
80105f39:	55                   	push   %ebp
80105f3a:	89 e5                	mov    %esp,%ebp
80105f3c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f42:	53                   	push   %ebx
80105f43:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f48:	eb 18                	jmp    80105f62 <uartputc+0x32>
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	6a 0a                	push   $0xa
80105f55:	e8 d6 c9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	83 eb 01             	sub    $0x1,%ebx
80105f60:	74 07                	je     80105f69 <uartputc+0x39>
80105f62:	89 f2                	mov    %esi,%edx
80105f64:	ec                   	in     (%dx),%al
80105f65:	a8 20                	test   $0x20,%al
80105f67:	74 e7                	je     80105f50 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f69:	8b 45 08             	mov    0x8(%ebp),%eax
80105f6c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f71:	ee                   	out    %al,(%dx)
}
80105f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f75:	5b                   	pop    %ebx
80105f76:	5e                   	pop    %esi
80105f77:	5d                   	pop    %ebp
80105f78:	c3                   	ret    
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f80:	c3                   	ret    
80105f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8f:	90                   	nop

80105f90 <uartintr>:

void
uartintr(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f96:	68 20 5e 10 80       	push   $0x80105e20
80105f9b:	e8 e0 a8 ff ff       	call   80100880 <consoleintr>
}
80105fa0:	83 c4 10             	add    $0x10,%esp
80105fa3:	c9                   	leave  
80105fa4:	c3                   	ret    

80105fa5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $0
80105fa7:	6a 00                	push   $0x0
  jmp alltraps
80105fa9:	e9 0c fb ff ff       	jmp    80105aba <alltraps>

80105fae <vector1>:
.globl vector1
vector1:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $1
80105fb0:	6a 01                	push   $0x1
  jmp alltraps
80105fb2:	e9 03 fb ff ff       	jmp    80105aba <alltraps>

80105fb7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $2
80105fb9:	6a 02                	push   $0x2
  jmp alltraps
80105fbb:	e9 fa fa ff ff       	jmp    80105aba <alltraps>

80105fc0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $3
80105fc2:	6a 03                	push   $0x3
  jmp alltraps
80105fc4:	e9 f1 fa ff ff       	jmp    80105aba <alltraps>

80105fc9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $4
80105fcb:	6a 04                	push   $0x4
  jmp alltraps
80105fcd:	e9 e8 fa ff ff       	jmp    80105aba <alltraps>

80105fd2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $5
80105fd4:	6a 05                	push   $0x5
  jmp alltraps
80105fd6:	e9 df fa ff ff       	jmp    80105aba <alltraps>

80105fdb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $6
80105fdd:	6a 06                	push   $0x6
  jmp alltraps
80105fdf:	e9 d6 fa ff ff       	jmp    80105aba <alltraps>

80105fe4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $7
80105fe6:	6a 07                	push   $0x7
  jmp alltraps
80105fe8:	e9 cd fa ff ff       	jmp    80105aba <alltraps>

80105fed <vector8>:
.globl vector8
vector8:
  pushl $8
80105fed:	6a 08                	push   $0x8
  jmp alltraps
80105fef:	e9 c6 fa ff ff       	jmp    80105aba <alltraps>

80105ff4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $9
80105ff6:	6a 09                	push   $0x9
  jmp alltraps
80105ff8:	e9 bd fa ff ff       	jmp    80105aba <alltraps>

80105ffd <vector10>:
.globl vector10
vector10:
  pushl $10
80105ffd:	6a 0a                	push   $0xa
  jmp alltraps
80105fff:	e9 b6 fa ff ff       	jmp    80105aba <alltraps>

80106004 <vector11>:
.globl vector11
vector11:
  pushl $11
80106004:	6a 0b                	push   $0xb
  jmp alltraps
80106006:	e9 af fa ff ff       	jmp    80105aba <alltraps>

8010600b <vector12>:
.globl vector12
vector12:
  pushl $12
8010600b:	6a 0c                	push   $0xc
  jmp alltraps
8010600d:	e9 a8 fa ff ff       	jmp    80105aba <alltraps>

80106012 <vector13>:
.globl vector13
vector13:
  pushl $13
80106012:	6a 0d                	push   $0xd
  jmp alltraps
80106014:	e9 a1 fa ff ff       	jmp    80105aba <alltraps>

80106019 <vector14>:
.globl vector14
vector14:
  pushl $14
80106019:	6a 0e                	push   $0xe
  jmp alltraps
8010601b:	e9 9a fa ff ff       	jmp    80105aba <alltraps>

80106020 <vector15>:
.globl vector15
vector15:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $15
80106022:	6a 0f                	push   $0xf
  jmp alltraps
80106024:	e9 91 fa ff ff       	jmp    80105aba <alltraps>

80106029 <vector16>:
.globl vector16
vector16:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $16
8010602b:	6a 10                	push   $0x10
  jmp alltraps
8010602d:	e9 88 fa ff ff       	jmp    80105aba <alltraps>

80106032 <vector17>:
.globl vector17
vector17:
  pushl $17
80106032:	6a 11                	push   $0x11
  jmp alltraps
80106034:	e9 81 fa ff ff       	jmp    80105aba <alltraps>

80106039 <vector18>:
.globl vector18
vector18:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $18
8010603b:	6a 12                	push   $0x12
  jmp alltraps
8010603d:	e9 78 fa ff ff       	jmp    80105aba <alltraps>

80106042 <vector19>:
.globl vector19
vector19:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $19
80106044:	6a 13                	push   $0x13
  jmp alltraps
80106046:	e9 6f fa ff ff       	jmp    80105aba <alltraps>

8010604b <vector20>:
.globl vector20
vector20:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $20
8010604d:	6a 14                	push   $0x14
  jmp alltraps
8010604f:	e9 66 fa ff ff       	jmp    80105aba <alltraps>

80106054 <vector21>:
.globl vector21
vector21:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $21
80106056:	6a 15                	push   $0x15
  jmp alltraps
80106058:	e9 5d fa ff ff       	jmp    80105aba <alltraps>

8010605d <vector22>:
.globl vector22
vector22:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $22
8010605f:	6a 16                	push   $0x16
  jmp alltraps
80106061:	e9 54 fa ff ff       	jmp    80105aba <alltraps>

80106066 <vector23>:
.globl vector23
vector23:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $23
80106068:	6a 17                	push   $0x17
  jmp alltraps
8010606a:	e9 4b fa ff ff       	jmp    80105aba <alltraps>

8010606f <vector24>:
.globl vector24
vector24:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $24
80106071:	6a 18                	push   $0x18
  jmp alltraps
80106073:	e9 42 fa ff ff       	jmp    80105aba <alltraps>

80106078 <vector25>:
.globl vector25
vector25:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $25
8010607a:	6a 19                	push   $0x19
  jmp alltraps
8010607c:	e9 39 fa ff ff       	jmp    80105aba <alltraps>

80106081 <vector26>:
.globl vector26
vector26:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $26
80106083:	6a 1a                	push   $0x1a
  jmp alltraps
80106085:	e9 30 fa ff ff       	jmp    80105aba <alltraps>

8010608a <vector27>:
.globl vector27
vector27:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $27
8010608c:	6a 1b                	push   $0x1b
  jmp alltraps
8010608e:	e9 27 fa ff ff       	jmp    80105aba <alltraps>

80106093 <vector28>:
.globl vector28
vector28:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $28
80106095:	6a 1c                	push   $0x1c
  jmp alltraps
80106097:	e9 1e fa ff ff       	jmp    80105aba <alltraps>

8010609c <vector29>:
.globl vector29
vector29:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $29
8010609e:	6a 1d                	push   $0x1d
  jmp alltraps
801060a0:	e9 15 fa ff ff       	jmp    80105aba <alltraps>

801060a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $30
801060a7:	6a 1e                	push   $0x1e
  jmp alltraps
801060a9:	e9 0c fa ff ff       	jmp    80105aba <alltraps>

801060ae <vector31>:
.globl vector31
vector31:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $31
801060b0:	6a 1f                	push   $0x1f
  jmp alltraps
801060b2:	e9 03 fa ff ff       	jmp    80105aba <alltraps>

801060b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $32
801060b9:	6a 20                	push   $0x20
  jmp alltraps
801060bb:	e9 fa f9 ff ff       	jmp    80105aba <alltraps>

801060c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $33
801060c2:	6a 21                	push   $0x21
  jmp alltraps
801060c4:	e9 f1 f9 ff ff       	jmp    80105aba <alltraps>

801060c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $34
801060cb:	6a 22                	push   $0x22
  jmp alltraps
801060cd:	e9 e8 f9 ff ff       	jmp    80105aba <alltraps>

801060d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $35
801060d4:	6a 23                	push   $0x23
  jmp alltraps
801060d6:	e9 df f9 ff ff       	jmp    80105aba <alltraps>

801060db <vector36>:
.globl vector36
vector36:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $36
801060dd:	6a 24                	push   $0x24
  jmp alltraps
801060df:	e9 d6 f9 ff ff       	jmp    80105aba <alltraps>

801060e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $37
801060e6:	6a 25                	push   $0x25
  jmp alltraps
801060e8:	e9 cd f9 ff ff       	jmp    80105aba <alltraps>

801060ed <vector38>:
.globl vector38
vector38:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $38
801060ef:	6a 26                	push   $0x26
  jmp alltraps
801060f1:	e9 c4 f9 ff ff       	jmp    80105aba <alltraps>

801060f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $39
801060f8:	6a 27                	push   $0x27
  jmp alltraps
801060fa:	e9 bb f9 ff ff       	jmp    80105aba <alltraps>

801060ff <vector40>:
.globl vector40
vector40:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $40
80106101:	6a 28                	push   $0x28
  jmp alltraps
80106103:	e9 b2 f9 ff ff       	jmp    80105aba <alltraps>

80106108 <vector41>:
.globl vector41
vector41:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $41
8010610a:	6a 29                	push   $0x29
  jmp alltraps
8010610c:	e9 a9 f9 ff ff       	jmp    80105aba <alltraps>

80106111 <vector42>:
.globl vector42
vector42:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $42
80106113:	6a 2a                	push   $0x2a
  jmp alltraps
80106115:	e9 a0 f9 ff ff       	jmp    80105aba <alltraps>

8010611a <vector43>:
.globl vector43
vector43:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $43
8010611c:	6a 2b                	push   $0x2b
  jmp alltraps
8010611e:	e9 97 f9 ff ff       	jmp    80105aba <alltraps>

80106123 <vector44>:
.globl vector44
vector44:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $44
80106125:	6a 2c                	push   $0x2c
  jmp alltraps
80106127:	e9 8e f9 ff ff       	jmp    80105aba <alltraps>

8010612c <vector45>:
.globl vector45
vector45:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $45
8010612e:	6a 2d                	push   $0x2d
  jmp alltraps
80106130:	e9 85 f9 ff ff       	jmp    80105aba <alltraps>

80106135 <vector46>:
.globl vector46
vector46:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $46
80106137:	6a 2e                	push   $0x2e
  jmp alltraps
80106139:	e9 7c f9 ff ff       	jmp    80105aba <alltraps>

8010613e <vector47>:
.globl vector47
vector47:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $47
80106140:	6a 2f                	push   $0x2f
  jmp alltraps
80106142:	e9 73 f9 ff ff       	jmp    80105aba <alltraps>

80106147 <vector48>:
.globl vector48
vector48:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $48
80106149:	6a 30                	push   $0x30
  jmp alltraps
8010614b:	e9 6a f9 ff ff       	jmp    80105aba <alltraps>

80106150 <vector49>:
.globl vector49
vector49:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $49
80106152:	6a 31                	push   $0x31
  jmp alltraps
80106154:	e9 61 f9 ff ff       	jmp    80105aba <alltraps>

80106159 <vector50>:
.globl vector50
vector50:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $50
8010615b:	6a 32                	push   $0x32
  jmp alltraps
8010615d:	e9 58 f9 ff ff       	jmp    80105aba <alltraps>

80106162 <vector51>:
.globl vector51
vector51:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $51
80106164:	6a 33                	push   $0x33
  jmp alltraps
80106166:	e9 4f f9 ff ff       	jmp    80105aba <alltraps>

8010616b <vector52>:
.globl vector52
vector52:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $52
8010616d:	6a 34                	push   $0x34
  jmp alltraps
8010616f:	e9 46 f9 ff ff       	jmp    80105aba <alltraps>

80106174 <vector53>:
.globl vector53
vector53:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $53
80106176:	6a 35                	push   $0x35
  jmp alltraps
80106178:	e9 3d f9 ff ff       	jmp    80105aba <alltraps>

8010617d <vector54>:
.globl vector54
vector54:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $54
8010617f:	6a 36                	push   $0x36
  jmp alltraps
80106181:	e9 34 f9 ff ff       	jmp    80105aba <alltraps>

80106186 <vector55>:
.globl vector55
vector55:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $55
80106188:	6a 37                	push   $0x37
  jmp alltraps
8010618a:	e9 2b f9 ff ff       	jmp    80105aba <alltraps>

8010618f <vector56>:
.globl vector56
vector56:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $56
80106191:	6a 38                	push   $0x38
  jmp alltraps
80106193:	e9 22 f9 ff ff       	jmp    80105aba <alltraps>

80106198 <vector57>:
.globl vector57
vector57:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $57
8010619a:	6a 39                	push   $0x39
  jmp alltraps
8010619c:	e9 19 f9 ff ff       	jmp    80105aba <alltraps>

801061a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $58
801061a3:	6a 3a                	push   $0x3a
  jmp alltraps
801061a5:	e9 10 f9 ff ff       	jmp    80105aba <alltraps>

801061aa <vector59>:
.globl vector59
vector59:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $59
801061ac:	6a 3b                	push   $0x3b
  jmp alltraps
801061ae:	e9 07 f9 ff ff       	jmp    80105aba <alltraps>

801061b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $60
801061b5:	6a 3c                	push   $0x3c
  jmp alltraps
801061b7:	e9 fe f8 ff ff       	jmp    80105aba <alltraps>

801061bc <vector61>:
.globl vector61
vector61:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $61
801061be:	6a 3d                	push   $0x3d
  jmp alltraps
801061c0:	e9 f5 f8 ff ff       	jmp    80105aba <alltraps>

801061c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $62
801061c7:	6a 3e                	push   $0x3e
  jmp alltraps
801061c9:	e9 ec f8 ff ff       	jmp    80105aba <alltraps>

801061ce <vector63>:
.globl vector63
vector63:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $63
801061d0:	6a 3f                	push   $0x3f
  jmp alltraps
801061d2:	e9 e3 f8 ff ff       	jmp    80105aba <alltraps>

801061d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $64
801061d9:	6a 40                	push   $0x40
  jmp alltraps
801061db:	e9 da f8 ff ff       	jmp    80105aba <alltraps>

801061e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $65
801061e2:	6a 41                	push   $0x41
  jmp alltraps
801061e4:	e9 d1 f8 ff ff       	jmp    80105aba <alltraps>

801061e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $66
801061eb:	6a 42                	push   $0x42
  jmp alltraps
801061ed:	e9 c8 f8 ff ff       	jmp    80105aba <alltraps>

801061f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $67
801061f4:	6a 43                	push   $0x43
  jmp alltraps
801061f6:	e9 bf f8 ff ff       	jmp    80105aba <alltraps>

801061fb <vector68>:
.globl vector68
vector68:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $68
801061fd:	6a 44                	push   $0x44
  jmp alltraps
801061ff:	e9 b6 f8 ff ff       	jmp    80105aba <alltraps>

80106204 <vector69>:
.globl vector69
vector69:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $69
80106206:	6a 45                	push   $0x45
  jmp alltraps
80106208:	e9 ad f8 ff ff       	jmp    80105aba <alltraps>

8010620d <vector70>:
.globl vector70
vector70:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $70
8010620f:	6a 46                	push   $0x46
  jmp alltraps
80106211:	e9 a4 f8 ff ff       	jmp    80105aba <alltraps>

80106216 <vector71>:
.globl vector71
vector71:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $71
80106218:	6a 47                	push   $0x47
  jmp alltraps
8010621a:	e9 9b f8 ff ff       	jmp    80105aba <alltraps>

8010621f <vector72>:
.globl vector72
vector72:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $72
80106221:	6a 48                	push   $0x48
  jmp alltraps
80106223:	e9 92 f8 ff ff       	jmp    80105aba <alltraps>

80106228 <vector73>:
.globl vector73
vector73:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $73
8010622a:	6a 49                	push   $0x49
  jmp alltraps
8010622c:	e9 89 f8 ff ff       	jmp    80105aba <alltraps>

80106231 <vector74>:
.globl vector74
vector74:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $74
80106233:	6a 4a                	push   $0x4a
  jmp alltraps
80106235:	e9 80 f8 ff ff       	jmp    80105aba <alltraps>

8010623a <vector75>:
.globl vector75
vector75:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $75
8010623c:	6a 4b                	push   $0x4b
  jmp alltraps
8010623e:	e9 77 f8 ff ff       	jmp    80105aba <alltraps>

80106243 <vector76>:
.globl vector76
vector76:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $76
80106245:	6a 4c                	push   $0x4c
  jmp alltraps
80106247:	e9 6e f8 ff ff       	jmp    80105aba <alltraps>

8010624c <vector77>:
.globl vector77
vector77:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $77
8010624e:	6a 4d                	push   $0x4d
  jmp alltraps
80106250:	e9 65 f8 ff ff       	jmp    80105aba <alltraps>

80106255 <vector78>:
.globl vector78
vector78:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $78
80106257:	6a 4e                	push   $0x4e
  jmp alltraps
80106259:	e9 5c f8 ff ff       	jmp    80105aba <alltraps>

8010625e <vector79>:
.globl vector79
vector79:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $79
80106260:	6a 4f                	push   $0x4f
  jmp alltraps
80106262:	e9 53 f8 ff ff       	jmp    80105aba <alltraps>

80106267 <vector80>:
.globl vector80
vector80:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $80
80106269:	6a 50                	push   $0x50
  jmp alltraps
8010626b:	e9 4a f8 ff ff       	jmp    80105aba <alltraps>

80106270 <vector81>:
.globl vector81
vector81:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $81
80106272:	6a 51                	push   $0x51
  jmp alltraps
80106274:	e9 41 f8 ff ff       	jmp    80105aba <alltraps>

80106279 <vector82>:
.globl vector82
vector82:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $82
8010627b:	6a 52                	push   $0x52
  jmp alltraps
8010627d:	e9 38 f8 ff ff       	jmp    80105aba <alltraps>

80106282 <vector83>:
.globl vector83
vector83:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $83
80106284:	6a 53                	push   $0x53
  jmp alltraps
80106286:	e9 2f f8 ff ff       	jmp    80105aba <alltraps>

8010628b <vector84>:
.globl vector84
vector84:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $84
8010628d:	6a 54                	push   $0x54
  jmp alltraps
8010628f:	e9 26 f8 ff ff       	jmp    80105aba <alltraps>

80106294 <vector85>:
.globl vector85
vector85:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $85
80106296:	6a 55                	push   $0x55
  jmp alltraps
80106298:	e9 1d f8 ff ff       	jmp    80105aba <alltraps>

8010629d <vector86>:
.globl vector86
vector86:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $86
8010629f:	6a 56                	push   $0x56
  jmp alltraps
801062a1:	e9 14 f8 ff ff       	jmp    80105aba <alltraps>

801062a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $87
801062a8:	6a 57                	push   $0x57
  jmp alltraps
801062aa:	e9 0b f8 ff ff       	jmp    80105aba <alltraps>

801062af <vector88>:
.globl vector88
vector88:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $88
801062b1:	6a 58                	push   $0x58
  jmp alltraps
801062b3:	e9 02 f8 ff ff       	jmp    80105aba <alltraps>

801062b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $89
801062ba:	6a 59                	push   $0x59
  jmp alltraps
801062bc:	e9 f9 f7 ff ff       	jmp    80105aba <alltraps>

801062c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $90
801062c3:	6a 5a                	push   $0x5a
  jmp alltraps
801062c5:	e9 f0 f7 ff ff       	jmp    80105aba <alltraps>

801062ca <vector91>:
.globl vector91
vector91:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $91
801062cc:	6a 5b                	push   $0x5b
  jmp alltraps
801062ce:	e9 e7 f7 ff ff       	jmp    80105aba <alltraps>

801062d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $92
801062d5:	6a 5c                	push   $0x5c
  jmp alltraps
801062d7:	e9 de f7 ff ff       	jmp    80105aba <alltraps>

801062dc <vector93>:
.globl vector93
vector93:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $93
801062de:	6a 5d                	push   $0x5d
  jmp alltraps
801062e0:	e9 d5 f7 ff ff       	jmp    80105aba <alltraps>

801062e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $94
801062e7:	6a 5e                	push   $0x5e
  jmp alltraps
801062e9:	e9 cc f7 ff ff       	jmp    80105aba <alltraps>

801062ee <vector95>:
.globl vector95
vector95:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $95
801062f0:	6a 5f                	push   $0x5f
  jmp alltraps
801062f2:	e9 c3 f7 ff ff       	jmp    80105aba <alltraps>

801062f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $96
801062f9:	6a 60                	push   $0x60
  jmp alltraps
801062fb:	e9 ba f7 ff ff       	jmp    80105aba <alltraps>

80106300 <vector97>:
.globl vector97
vector97:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $97
80106302:	6a 61                	push   $0x61
  jmp alltraps
80106304:	e9 b1 f7 ff ff       	jmp    80105aba <alltraps>

80106309 <vector98>:
.globl vector98
vector98:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $98
8010630b:	6a 62                	push   $0x62
  jmp alltraps
8010630d:	e9 a8 f7 ff ff       	jmp    80105aba <alltraps>

80106312 <vector99>:
.globl vector99
vector99:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $99
80106314:	6a 63                	push   $0x63
  jmp alltraps
80106316:	e9 9f f7 ff ff       	jmp    80105aba <alltraps>

8010631b <vector100>:
.globl vector100
vector100:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $100
8010631d:	6a 64                	push   $0x64
  jmp alltraps
8010631f:	e9 96 f7 ff ff       	jmp    80105aba <alltraps>

80106324 <vector101>:
.globl vector101
vector101:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $101
80106326:	6a 65                	push   $0x65
  jmp alltraps
80106328:	e9 8d f7 ff ff       	jmp    80105aba <alltraps>

8010632d <vector102>:
.globl vector102
vector102:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $102
8010632f:	6a 66                	push   $0x66
  jmp alltraps
80106331:	e9 84 f7 ff ff       	jmp    80105aba <alltraps>

80106336 <vector103>:
.globl vector103
vector103:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $103
80106338:	6a 67                	push   $0x67
  jmp alltraps
8010633a:	e9 7b f7 ff ff       	jmp    80105aba <alltraps>

8010633f <vector104>:
.globl vector104
vector104:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $104
80106341:	6a 68                	push   $0x68
  jmp alltraps
80106343:	e9 72 f7 ff ff       	jmp    80105aba <alltraps>

80106348 <vector105>:
.globl vector105
vector105:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $105
8010634a:	6a 69                	push   $0x69
  jmp alltraps
8010634c:	e9 69 f7 ff ff       	jmp    80105aba <alltraps>

80106351 <vector106>:
.globl vector106
vector106:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $106
80106353:	6a 6a                	push   $0x6a
  jmp alltraps
80106355:	e9 60 f7 ff ff       	jmp    80105aba <alltraps>

8010635a <vector107>:
.globl vector107
vector107:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $107
8010635c:	6a 6b                	push   $0x6b
  jmp alltraps
8010635e:	e9 57 f7 ff ff       	jmp    80105aba <alltraps>

80106363 <vector108>:
.globl vector108
vector108:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $108
80106365:	6a 6c                	push   $0x6c
  jmp alltraps
80106367:	e9 4e f7 ff ff       	jmp    80105aba <alltraps>

8010636c <vector109>:
.globl vector109
vector109:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $109
8010636e:	6a 6d                	push   $0x6d
  jmp alltraps
80106370:	e9 45 f7 ff ff       	jmp    80105aba <alltraps>

80106375 <vector110>:
.globl vector110
vector110:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $110
80106377:	6a 6e                	push   $0x6e
  jmp alltraps
80106379:	e9 3c f7 ff ff       	jmp    80105aba <alltraps>

8010637e <vector111>:
.globl vector111
vector111:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $111
80106380:	6a 6f                	push   $0x6f
  jmp alltraps
80106382:	e9 33 f7 ff ff       	jmp    80105aba <alltraps>

80106387 <vector112>:
.globl vector112
vector112:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $112
80106389:	6a 70                	push   $0x70
  jmp alltraps
8010638b:	e9 2a f7 ff ff       	jmp    80105aba <alltraps>

80106390 <vector113>:
.globl vector113
vector113:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $113
80106392:	6a 71                	push   $0x71
  jmp alltraps
80106394:	e9 21 f7 ff ff       	jmp    80105aba <alltraps>

80106399 <vector114>:
.globl vector114
vector114:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $114
8010639b:	6a 72                	push   $0x72
  jmp alltraps
8010639d:	e9 18 f7 ff ff       	jmp    80105aba <alltraps>

801063a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $115
801063a4:	6a 73                	push   $0x73
  jmp alltraps
801063a6:	e9 0f f7 ff ff       	jmp    80105aba <alltraps>

801063ab <vector116>:
.globl vector116
vector116:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $116
801063ad:	6a 74                	push   $0x74
  jmp alltraps
801063af:	e9 06 f7 ff ff       	jmp    80105aba <alltraps>

801063b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $117
801063b6:	6a 75                	push   $0x75
  jmp alltraps
801063b8:	e9 fd f6 ff ff       	jmp    80105aba <alltraps>

801063bd <vector118>:
.globl vector118
vector118:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $118
801063bf:	6a 76                	push   $0x76
  jmp alltraps
801063c1:	e9 f4 f6 ff ff       	jmp    80105aba <alltraps>

801063c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $119
801063c8:	6a 77                	push   $0x77
  jmp alltraps
801063ca:	e9 eb f6 ff ff       	jmp    80105aba <alltraps>

801063cf <vector120>:
.globl vector120
vector120:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $120
801063d1:	6a 78                	push   $0x78
  jmp alltraps
801063d3:	e9 e2 f6 ff ff       	jmp    80105aba <alltraps>

801063d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $121
801063da:	6a 79                	push   $0x79
  jmp alltraps
801063dc:	e9 d9 f6 ff ff       	jmp    80105aba <alltraps>

801063e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $122
801063e3:	6a 7a                	push   $0x7a
  jmp alltraps
801063e5:	e9 d0 f6 ff ff       	jmp    80105aba <alltraps>

801063ea <vector123>:
.globl vector123
vector123:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $123
801063ec:	6a 7b                	push   $0x7b
  jmp alltraps
801063ee:	e9 c7 f6 ff ff       	jmp    80105aba <alltraps>

801063f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $124
801063f5:	6a 7c                	push   $0x7c
  jmp alltraps
801063f7:	e9 be f6 ff ff       	jmp    80105aba <alltraps>

801063fc <vector125>:
.globl vector125
vector125:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $125
801063fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106400:	e9 b5 f6 ff ff       	jmp    80105aba <alltraps>

80106405 <vector126>:
.globl vector126
vector126:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $126
80106407:	6a 7e                	push   $0x7e
  jmp alltraps
80106409:	e9 ac f6 ff ff       	jmp    80105aba <alltraps>

8010640e <vector127>:
.globl vector127
vector127:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $127
80106410:	6a 7f                	push   $0x7f
  jmp alltraps
80106412:	e9 a3 f6 ff ff       	jmp    80105aba <alltraps>

80106417 <vector128>:
.globl vector128
vector128:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $128
80106419:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010641e:	e9 97 f6 ff ff       	jmp    80105aba <alltraps>

80106423 <vector129>:
.globl vector129
vector129:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $129
80106425:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010642a:	e9 8b f6 ff ff       	jmp    80105aba <alltraps>

8010642f <vector130>:
.globl vector130
vector130:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $130
80106431:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106436:	e9 7f f6 ff ff       	jmp    80105aba <alltraps>

8010643b <vector131>:
.globl vector131
vector131:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $131
8010643d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106442:	e9 73 f6 ff ff       	jmp    80105aba <alltraps>

80106447 <vector132>:
.globl vector132
vector132:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $132
80106449:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010644e:	e9 67 f6 ff ff       	jmp    80105aba <alltraps>

80106453 <vector133>:
.globl vector133
vector133:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $133
80106455:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010645a:	e9 5b f6 ff ff       	jmp    80105aba <alltraps>

8010645f <vector134>:
.globl vector134
vector134:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $134
80106461:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106466:	e9 4f f6 ff ff       	jmp    80105aba <alltraps>

8010646b <vector135>:
.globl vector135
vector135:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $135
8010646d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106472:	e9 43 f6 ff ff       	jmp    80105aba <alltraps>

80106477 <vector136>:
.globl vector136
vector136:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $136
80106479:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010647e:	e9 37 f6 ff ff       	jmp    80105aba <alltraps>

80106483 <vector137>:
.globl vector137
vector137:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $137
80106485:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010648a:	e9 2b f6 ff ff       	jmp    80105aba <alltraps>

8010648f <vector138>:
.globl vector138
vector138:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $138
80106491:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106496:	e9 1f f6 ff ff       	jmp    80105aba <alltraps>

8010649b <vector139>:
.globl vector139
vector139:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $139
8010649d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064a2:	e9 13 f6 ff ff       	jmp    80105aba <alltraps>

801064a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $140
801064a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064ae:	e9 07 f6 ff ff       	jmp    80105aba <alltraps>

801064b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $141
801064b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ba:	e9 fb f5 ff ff       	jmp    80105aba <alltraps>

801064bf <vector142>:
.globl vector142
vector142:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $142
801064c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064c6:	e9 ef f5 ff ff       	jmp    80105aba <alltraps>

801064cb <vector143>:
.globl vector143
vector143:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $143
801064cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064d2:	e9 e3 f5 ff ff       	jmp    80105aba <alltraps>

801064d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $144
801064d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064de:	e9 d7 f5 ff ff       	jmp    80105aba <alltraps>

801064e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $145
801064e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064ea:	e9 cb f5 ff ff       	jmp    80105aba <alltraps>

801064ef <vector146>:
.globl vector146
vector146:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $146
801064f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064f6:	e9 bf f5 ff ff       	jmp    80105aba <alltraps>

801064fb <vector147>:
.globl vector147
vector147:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $147
801064fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106502:	e9 b3 f5 ff ff       	jmp    80105aba <alltraps>

80106507 <vector148>:
.globl vector148
vector148:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $148
80106509:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010650e:	e9 a7 f5 ff ff       	jmp    80105aba <alltraps>

80106513 <vector149>:
.globl vector149
vector149:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $149
80106515:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010651a:	e9 9b f5 ff ff       	jmp    80105aba <alltraps>

8010651f <vector150>:
.globl vector150
vector150:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $150
80106521:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106526:	e9 8f f5 ff ff       	jmp    80105aba <alltraps>

8010652b <vector151>:
.globl vector151
vector151:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $151
8010652d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106532:	e9 83 f5 ff ff       	jmp    80105aba <alltraps>

80106537 <vector152>:
.globl vector152
vector152:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $152
80106539:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010653e:	e9 77 f5 ff ff       	jmp    80105aba <alltraps>

80106543 <vector153>:
.globl vector153
vector153:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $153
80106545:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010654a:	e9 6b f5 ff ff       	jmp    80105aba <alltraps>

8010654f <vector154>:
.globl vector154
vector154:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $154
80106551:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106556:	e9 5f f5 ff ff       	jmp    80105aba <alltraps>

8010655b <vector155>:
.globl vector155
vector155:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $155
8010655d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106562:	e9 53 f5 ff ff       	jmp    80105aba <alltraps>

80106567 <vector156>:
.globl vector156
vector156:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $156
80106569:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010656e:	e9 47 f5 ff ff       	jmp    80105aba <alltraps>

80106573 <vector157>:
.globl vector157
vector157:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $157
80106575:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010657a:	e9 3b f5 ff ff       	jmp    80105aba <alltraps>

8010657f <vector158>:
.globl vector158
vector158:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $158
80106581:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106586:	e9 2f f5 ff ff       	jmp    80105aba <alltraps>

8010658b <vector159>:
.globl vector159
vector159:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $159
8010658d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106592:	e9 23 f5 ff ff       	jmp    80105aba <alltraps>

80106597 <vector160>:
.globl vector160
vector160:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $160
80106599:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010659e:	e9 17 f5 ff ff       	jmp    80105aba <alltraps>

801065a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $161
801065a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065aa:	e9 0b f5 ff ff       	jmp    80105aba <alltraps>

801065af <vector162>:
.globl vector162
vector162:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $162
801065b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065b6:	e9 ff f4 ff ff       	jmp    80105aba <alltraps>

801065bb <vector163>:
.globl vector163
vector163:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $163
801065bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065c2:	e9 f3 f4 ff ff       	jmp    80105aba <alltraps>

801065c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $164
801065c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065ce:	e9 e7 f4 ff ff       	jmp    80105aba <alltraps>

801065d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $165
801065d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065da:	e9 db f4 ff ff       	jmp    80105aba <alltraps>

801065df <vector166>:
.globl vector166
vector166:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $166
801065e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065e6:	e9 cf f4 ff ff       	jmp    80105aba <alltraps>

801065eb <vector167>:
.globl vector167
vector167:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $167
801065ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065f2:	e9 c3 f4 ff ff       	jmp    80105aba <alltraps>

801065f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $168
801065f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065fe:	e9 b7 f4 ff ff       	jmp    80105aba <alltraps>

80106603 <vector169>:
.globl vector169
vector169:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $169
80106605:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010660a:	e9 ab f4 ff ff       	jmp    80105aba <alltraps>

8010660f <vector170>:
.globl vector170
vector170:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $170
80106611:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106616:	e9 9f f4 ff ff       	jmp    80105aba <alltraps>

8010661b <vector171>:
.globl vector171
vector171:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $171
8010661d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106622:	e9 93 f4 ff ff       	jmp    80105aba <alltraps>

80106627 <vector172>:
.globl vector172
vector172:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $172
80106629:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010662e:	e9 87 f4 ff ff       	jmp    80105aba <alltraps>

80106633 <vector173>:
.globl vector173
vector173:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $173
80106635:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010663a:	e9 7b f4 ff ff       	jmp    80105aba <alltraps>

8010663f <vector174>:
.globl vector174
vector174:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $174
80106641:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106646:	e9 6f f4 ff ff       	jmp    80105aba <alltraps>

8010664b <vector175>:
.globl vector175
vector175:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $175
8010664d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106652:	e9 63 f4 ff ff       	jmp    80105aba <alltraps>

80106657 <vector176>:
.globl vector176
vector176:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $176
80106659:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010665e:	e9 57 f4 ff ff       	jmp    80105aba <alltraps>

80106663 <vector177>:
.globl vector177
vector177:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $177
80106665:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010666a:	e9 4b f4 ff ff       	jmp    80105aba <alltraps>

8010666f <vector178>:
.globl vector178
vector178:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $178
80106671:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106676:	e9 3f f4 ff ff       	jmp    80105aba <alltraps>

8010667b <vector179>:
.globl vector179
vector179:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $179
8010667d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106682:	e9 33 f4 ff ff       	jmp    80105aba <alltraps>

80106687 <vector180>:
.globl vector180
vector180:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $180
80106689:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010668e:	e9 27 f4 ff ff       	jmp    80105aba <alltraps>

80106693 <vector181>:
.globl vector181
vector181:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $181
80106695:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010669a:	e9 1b f4 ff ff       	jmp    80105aba <alltraps>

8010669f <vector182>:
.globl vector182
vector182:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $182
801066a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066a6:	e9 0f f4 ff ff       	jmp    80105aba <alltraps>

801066ab <vector183>:
.globl vector183
vector183:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $183
801066ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066b2:	e9 03 f4 ff ff       	jmp    80105aba <alltraps>

801066b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $184
801066b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066be:	e9 f7 f3 ff ff       	jmp    80105aba <alltraps>

801066c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $185
801066c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066ca:	e9 eb f3 ff ff       	jmp    80105aba <alltraps>

801066cf <vector186>:
.globl vector186
vector186:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $186
801066d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066d6:	e9 df f3 ff ff       	jmp    80105aba <alltraps>

801066db <vector187>:
.globl vector187
vector187:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $187
801066dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066e2:	e9 d3 f3 ff ff       	jmp    80105aba <alltraps>

801066e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $188
801066e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066ee:	e9 c7 f3 ff ff       	jmp    80105aba <alltraps>

801066f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $189
801066f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066fa:	e9 bb f3 ff ff       	jmp    80105aba <alltraps>

801066ff <vector190>:
.globl vector190
vector190:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $190
80106701:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106706:	e9 af f3 ff ff       	jmp    80105aba <alltraps>

8010670b <vector191>:
.globl vector191
vector191:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $191
8010670d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106712:	e9 a3 f3 ff ff       	jmp    80105aba <alltraps>

80106717 <vector192>:
.globl vector192
vector192:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $192
80106719:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010671e:	e9 97 f3 ff ff       	jmp    80105aba <alltraps>

80106723 <vector193>:
.globl vector193
vector193:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $193
80106725:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010672a:	e9 8b f3 ff ff       	jmp    80105aba <alltraps>

8010672f <vector194>:
.globl vector194
vector194:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $194
80106731:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106736:	e9 7f f3 ff ff       	jmp    80105aba <alltraps>

8010673b <vector195>:
.globl vector195
vector195:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $195
8010673d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106742:	e9 73 f3 ff ff       	jmp    80105aba <alltraps>

80106747 <vector196>:
.globl vector196
vector196:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $196
80106749:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010674e:	e9 67 f3 ff ff       	jmp    80105aba <alltraps>

80106753 <vector197>:
.globl vector197
vector197:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $197
80106755:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010675a:	e9 5b f3 ff ff       	jmp    80105aba <alltraps>

8010675f <vector198>:
.globl vector198
vector198:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $198
80106761:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106766:	e9 4f f3 ff ff       	jmp    80105aba <alltraps>

8010676b <vector199>:
.globl vector199
vector199:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $199
8010676d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106772:	e9 43 f3 ff ff       	jmp    80105aba <alltraps>

80106777 <vector200>:
.globl vector200
vector200:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $200
80106779:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010677e:	e9 37 f3 ff ff       	jmp    80105aba <alltraps>

80106783 <vector201>:
.globl vector201
vector201:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $201
80106785:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010678a:	e9 2b f3 ff ff       	jmp    80105aba <alltraps>

8010678f <vector202>:
.globl vector202
vector202:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $202
80106791:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106796:	e9 1f f3 ff ff       	jmp    80105aba <alltraps>

8010679b <vector203>:
.globl vector203
vector203:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $203
8010679d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067a2:	e9 13 f3 ff ff       	jmp    80105aba <alltraps>

801067a7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $204
801067a9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067ae:	e9 07 f3 ff ff       	jmp    80105aba <alltraps>

801067b3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $205
801067b5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ba:	e9 fb f2 ff ff       	jmp    80105aba <alltraps>

801067bf <vector206>:
.globl vector206
vector206:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $206
801067c1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067c6:	e9 ef f2 ff ff       	jmp    80105aba <alltraps>

801067cb <vector207>:
.globl vector207
vector207:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $207
801067cd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067d2:	e9 e3 f2 ff ff       	jmp    80105aba <alltraps>

801067d7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $208
801067d9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067de:	e9 d7 f2 ff ff       	jmp    80105aba <alltraps>

801067e3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $209
801067e5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067ea:	e9 cb f2 ff ff       	jmp    80105aba <alltraps>

801067ef <vector210>:
.globl vector210
vector210:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $210
801067f1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067f6:	e9 bf f2 ff ff       	jmp    80105aba <alltraps>

801067fb <vector211>:
.globl vector211
vector211:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $211
801067fd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106802:	e9 b3 f2 ff ff       	jmp    80105aba <alltraps>

80106807 <vector212>:
.globl vector212
vector212:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $212
80106809:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010680e:	e9 a7 f2 ff ff       	jmp    80105aba <alltraps>

80106813 <vector213>:
.globl vector213
vector213:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $213
80106815:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010681a:	e9 9b f2 ff ff       	jmp    80105aba <alltraps>

8010681f <vector214>:
.globl vector214
vector214:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $214
80106821:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106826:	e9 8f f2 ff ff       	jmp    80105aba <alltraps>

8010682b <vector215>:
.globl vector215
vector215:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $215
8010682d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106832:	e9 83 f2 ff ff       	jmp    80105aba <alltraps>

80106837 <vector216>:
.globl vector216
vector216:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $216
80106839:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010683e:	e9 77 f2 ff ff       	jmp    80105aba <alltraps>

80106843 <vector217>:
.globl vector217
vector217:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $217
80106845:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010684a:	e9 6b f2 ff ff       	jmp    80105aba <alltraps>

8010684f <vector218>:
.globl vector218
vector218:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $218
80106851:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106856:	e9 5f f2 ff ff       	jmp    80105aba <alltraps>

8010685b <vector219>:
.globl vector219
vector219:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $219
8010685d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106862:	e9 53 f2 ff ff       	jmp    80105aba <alltraps>

80106867 <vector220>:
.globl vector220
vector220:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $220
80106869:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010686e:	e9 47 f2 ff ff       	jmp    80105aba <alltraps>

80106873 <vector221>:
.globl vector221
vector221:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $221
80106875:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010687a:	e9 3b f2 ff ff       	jmp    80105aba <alltraps>

8010687f <vector222>:
.globl vector222
vector222:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $222
80106881:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106886:	e9 2f f2 ff ff       	jmp    80105aba <alltraps>

8010688b <vector223>:
.globl vector223
vector223:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $223
8010688d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106892:	e9 23 f2 ff ff       	jmp    80105aba <alltraps>

80106897 <vector224>:
.globl vector224
vector224:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $224
80106899:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010689e:	e9 17 f2 ff ff       	jmp    80105aba <alltraps>

801068a3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $225
801068a5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068aa:	e9 0b f2 ff ff       	jmp    80105aba <alltraps>

801068af <vector226>:
.globl vector226
vector226:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $226
801068b1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068b6:	e9 ff f1 ff ff       	jmp    80105aba <alltraps>

801068bb <vector227>:
.globl vector227
vector227:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $227
801068bd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068c2:	e9 f3 f1 ff ff       	jmp    80105aba <alltraps>

801068c7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $228
801068c9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068ce:	e9 e7 f1 ff ff       	jmp    80105aba <alltraps>

801068d3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $229
801068d5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068da:	e9 db f1 ff ff       	jmp    80105aba <alltraps>

801068df <vector230>:
.globl vector230
vector230:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $230
801068e1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068e6:	e9 cf f1 ff ff       	jmp    80105aba <alltraps>

801068eb <vector231>:
.globl vector231
vector231:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $231
801068ed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068f2:	e9 c3 f1 ff ff       	jmp    80105aba <alltraps>

801068f7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $232
801068f9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068fe:	e9 b7 f1 ff ff       	jmp    80105aba <alltraps>

80106903 <vector233>:
.globl vector233
vector233:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $233
80106905:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010690a:	e9 ab f1 ff ff       	jmp    80105aba <alltraps>

8010690f <vector234>:
.globl vector234
vector234:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $234
80106911:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106916:	e9 9f f1 ff ff       	jmp    80105aba <alltraps>

8010691b <vector235>:
.globl vector235
vector235:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $235
8010691d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106922:	e9 93 f1 ff ff       	jmp    80105aba <alltraps>

80106927 <vector236>:
.globl vector236
vector236:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $236
80106929:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010692e:	e9 87 f1 ff ff       	jmp    80105aba <alltraps>

80106933 <vector237>:
.globl vector237
vector237:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $237
80106935:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010693a:	e9 7b f1 ff ff       	jmp    80105aba <alltraps>

8010693f <vector238>:
.globl vector238
vector238:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $238
80106941:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106946:	e9 6f f1 ff ff       	jmp    80105aba <alltraps>

8010694b <vector239>:
.globl vector239
vector239:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $239
8010694d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106952:	e9 63 f1 ff ff       	jmp    80105aba <alltraps>

80106957 <vector240>:
.globl vector240
vector240:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $240
80106959:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010695e:	e9 57 f1 ff ff       	jmp    80105aba <alltraps>

80106963 <vector241>:
.globl vector241
vector241:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $241
80106965:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010696a:	e9 4b f1 ff ff       	jmp    80105aba <alltraps>

8010696f <vector242>:
.globl vector242
vector242:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $242
80106971:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106976:	e9 3f f1 ff ff       	jmp    80105aba <alltraps>

8010697b <vector243>:
.globl vector243
vector243:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $243
8010697d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106982:	e9 33 f1 ff ff       	jmp    80105aba <alltraps>

80106987 <vector244>:
.globl vector244
vector244:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $244
80106989:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010698e:	e9 27 f1 ff ff       	jmp    80105aba <alltraps>

80106993 <vector245>:
.globl vector245
vector245:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $245
80106995:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010699a:	e9 1b f1 ff ff       	jmp    80105aba <alltraps>

8010699f <vector246>:
.globl vector246
vector246:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $246
801069a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069a6:	e9 0f f1 ff ff       	jmp    80105aba <alltraps>

801069ab <vector247>:
.globl vector247
vector247:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $247
801069ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069b2:	e9 03 f1 ff ff       	jmp    80105aba <alltraps>

801069b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $248
801069b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069be:	e9 f7 f0 ff ff       	jmp    80105aba <alltraps>

801069c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $249
801069c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069ca:	e9 eb f0 ff ff       	jmp    80105aba <alltraps>

801069cf <vector250>:
.globl vector250
vector250:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $250
801069d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069d6:	e9 df f0 ff ff       	jmp    80105aba <alltraps>

801069db <vector251>:
.globl vector251
vector251:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $251
801069dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069e2:	e9 d3 f0 ff ff       	jmp    80105aba <alltraps>

801069e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $252
801069e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069ee:	e9 c7 f0 ff ff       	jmp    80105aba <alltraps>

801069f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $253
801069f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069fa:	e9 bb f0 ff ff       	jmp    80105aba <alltraps>

801069ff <vector254>:
.globl vector254
vector254:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $254
80106a01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a06:	e9 af f0 ff ff       	jmp    80105aba <alltraps>

80106a0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $255
80106a0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a12:	e9 a3 f0 ff ff       	jmp    80105aba <alltraps>
80106a17:	66 90                	xchg   %ax,%ax
80106a19:	66 90                	xchg   %ax,%ax
80106a1b:	66 90                	xchg   %ax,%ax
80106a1d:	66 90                	xchg   %ax,%ax
80106a1f:	90                   	nop

80106a20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	89 c6                	mov    %eax,%esi
80106a27:	53                   	push   %ebx
  pde_t *pde; 

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a28:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a2e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a34:	83 ec 1c             	sub    $0x1c,%esp
80106a37:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106a3a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a3d:	39 d3                	cmp    %edx,%ebx
80106a3f:	72 18                	jb     80106a59 <deallocuvm.part.0+0x39>
80106a41:	eb 41                	jmp    80106a84 <deallocuvm.part.0+0x64>
80106a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a47:	90                   	nop
  if(*pde & PTE_P){
80106a48:	a8 01                	test   $0x1,%al
80106a4a:	75 44                	jne    80106a90 <deallocuvm.part.0+0x70>
      continue; 
    }

    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a4c:	83 c2 01             	add    $0x1,%edx
80106a4f:	89 d3                	mov    %edx,%ebx
80106a51:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a54:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106a57:	76 2b                	jbe    80106a84 <deallocuvm.part.0+0x64>
    pde = &pgdir[PDX(a)];
80106a59:	89 da                	mov    %ebx,%edx
80106a5b:	c1 ea 16             	shr    $0x16,%edx
80106a5e:	8d 0c 96             	lea    (%esi,%edx,4),%ecx
    if ((*pde & PTE_P) && (*pde & PTE_PS)) {
80106a61:	8b 01                	mov    (%ecx),%eax
80106a63:	89 c7                	mov    %eax,%edi
80106a65:	81 e7 81 00 00 00    	and    $0x81,%edi
80106a6b:	81 ff 81 00 00 00    	cmp    $0x81,%edi
80106a71:	75 d5                	jne    80106a48 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a73:	8d 5a 01             	lea    0x1(%edx),%ebx
      *pde = 0; 
80106a76:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a7c:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a7f:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80106a82:	77 d5                	ja     80106a59 <deallocuvm.part.0+0x39>
      }
      *pte = 0;
    }
  }
  return newsz;
}
80106a84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a8a:	5b                   	pop    %ebx
80106a8b:	5e                   	pop    %esi
80106a8c:	5f                   	pop    %edi
80106a8d:	5d                   	pop    %ebp
80106a8e:	c3                   	ret    
80106a8f:	90                   	nop
  return &pgtab[PTX(va)];
80106a90:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a97:	c1 e9 0a             	shr    $0xa,%ecx
80106a9a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106aa0:	8d bc 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%edi
    if(!pte)
80106aa7:	85 ff                	test   %edi,%edi
80106aa9:	74 a1                	je     80106a4c <deallocuvm.part.0+0x2c>
    else if((*pte & PTE_P) != 0){
80106aab:	8b 07                	mov    (%edi),%eax
80106aad:	a8 01                	test   $0x1,%al
80106aaf:	74 14                	je     80106ac5 <deallocuvm.part.0+0xa5>
      if(pa == 0)
80106ab1:	89 c2                	mov    %eax,%edx
80106ab3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ab9:	74 29                	je     80106ae4 <deallocuvm.part.0+0xc4>
      if ((*pte & PTE_DEV) == 0) {
80106abb:	a8 20                	test   $0x20,%al
80106abd:	74 11                	je     80106ad0 <deallocuvm.part.0+0xb0>
      *pte = 0;
80106abf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  for(; a  < oldsz; a += PGSIZE){
80106ac5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106acb:	eb 87                	jmp    80106a54 <deallocuvm.part.0+0x34>
80106acd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(v);
80106ad0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106ad3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
        kfree(v);
80106ad9:	52                   	push   %edx
80106ada:	e8 e1 b9 ff ff       	call   801024c0 <kfree>
80106adf:	83 c4 10             	add    $0x10,%esp
80106ae2:	eb db                	jmp    80106abf <deallocuvm.part.0+0x9f>
        panic("kfree");
80106ae4:	83 ec 0c             	sub    $0xc,%esp
80106ae7:	68 46 7b 10 80       	push   $0x80107b46
80106aec:	e8 8f 98 ff ff       	call   80100380 <panic>
80106af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aff:	90                   	nop

80106b00 <seginit>:
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b06:	e8 55 ce ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106b0b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b10:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b1a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106b21:	ff 00 00 
80106b24:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106b2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b2e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106b35:	ff 00 00 
80106b38:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106b3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b42:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106b49:	ff 00 00 
80106b4c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106b53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b56:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106b5d:	ff 00 00 
80106b60:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106b67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b6a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106b6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b73:	c1 e8 10             	shr    $0x10,%eax
80106b76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b7d:	0f 01 10             	lgdtl  (%eax)
}
80106b80:	c9                   	leave  
80106b81:	c3                   	ret    
80106b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b90 <mappages>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 1c             	sub    $0x1c,%esp
80106b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b9c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
80106b9f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ba1:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106ba5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106baa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bb3:	8b 45 14             	mov    0x14(%ebp),%eax
80106bb6:	29 d8                	sub    %ebx,%eax
80106bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bbb:	eb 3a                	jmp    80106bf7 <mappages+0x67>
80106bbd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106bc0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bc7:	c1 ea 0a             	shr    $0xa,%edx
80106bca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bd0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bd7:	85 c0                	test   %eax,%eax
80106bd9:	74 75                	je     80106c50 <mappages+0xc0>
    if(*pte & PTE_P)
80106bdb:	f6 00 01             	testb  $0x1,(%eax)
80106bde:	0f 85 86 00 00 00    	jne    80106c6a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106be4:	0b 75 18             	or     0x18(%ebp),%esi
80106be7:	83 ce 01             	or     $0x1,%esi
80106bea:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bec:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106bef:	74 6f                	je     80106c60 <mappages+0xd0>
    a += PGSIZE;
80106bf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106bfd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c00:	89 d8                	mov    %ebx,%eax
80106c02:	c1 e8 16             	shr    $0x16,%eax
80106c05:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c08:	8b 07                	mov    (%edi),%eax
80106c0a:	a8 01                	test   $0x1,%al
80106c0c:	75 b2                	jne    80106bc0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c0e:	e8 6d ba ff ff       	call   80102680 <kalloc>
80106c13:	85 c0                	test   %eax,%eax
80106c15:	74 39                	je     80106c50 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c17:	83 ec 04             	sub    $0x4,%esp
80106c1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c1d:	68 00 10 00 00       	push   $0x1000
80106c22:	6a 00                	push   $0x0
80106c24:	50                   	push   %eax
80106c25:	e8 46 da ff ff       	call   80104670 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106c2d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c30:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106c36:	83 c8 07             	or     $0x7,%eax
80106c39:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106c3b:	89 d8                	mov    %ebx,%eax
80106c3d:	c1 e8 0a             	shr    $0xa,%eax
80106c40:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c45:	01 d0                	add    %edx,%eax
80106c47:	eb 92                	jmp    80106bdb <mappages+0x4b>
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c58:	5b                   	pop    %ebx
80106c59:	5e                   	pop    %esi
80106c5a:	5f                   	pop    %edi
80106c5b:	5d                   	pop    %ebp
80106c5c:	c3                   	ret    
80106c5d:	8d 76 00             	lea    0x0(%esi),%esi
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c63:	31 c0                	xor    %eax,%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
      panic("remap");
80106c6a:	83 ec 0c             	sub    $0xc,%esp
80106c6d:	68 84 83 10 80       	push   $0x80108384
80106c72:	e8 09 97 ff ff       	call   80100380 <panic>
80106c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7e:	66 90                	xchg   %ax,%ax

80106c80 <hpmappages>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 1c             	sub    $0x1c,%esp
80106c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)HPROUNDDOWN(((uint)va) + size - 1);
80106c8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
{
80106c8f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c92:	8b 75 14             	mov    0x14(%ebp),%esi
  a = (char*)HPROUNDDOWN((uint)va);
80106c95:	89 c3                	mov    %eax,%ebx
  last = (char*)HPROUNDDOWN(((uint)va) + size - 1);
80106c97:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
  a = (char*)HPROUNDDOWN((uint)va);
80106c9b:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
  last = (char*)HPROUNDDOWN(((uint)va) + size - 1);
80106ca1:	25 00 00 c0 ff       	and    $0xffc00000,%eax
    pde = &pgdir[PDX(a)];
80106ca6:	89 d9                	mov    %ebx,%ecx
  last = (char*)HPROUNDDOWN(((uint)va) + size - 1);
80106ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pde = &pgdir[PDX(a)];
80106cab:	c1 e9 14             	shr    $0x14,%ecx
80106cae:	01 f9                	add    %edi,%ecx
    if (*pde & PTE_P) {
80106cb0:	f6 01 01             	testb  $0x1,(%ecx)
80106cb3:	75 41                	jne    80106cf6 <hpmappages+0x76>
    *pde = pa | perm | PTE_P | PTE_PS;
80106cb5:	8b 45 18             	mov    0x18(%ebp),%eax
80106cb8:	89 da                	mov    %ebx,%edx
80106cba:	09 f0                	or     %esi,%eax
80106cbc:	0c 81                	or     $0x81,%al
80106cbe:	89 01                	mov    %eax,(%ecx)
    if (a >= last)
80106cc0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80106cc3:	73 27                	jae    80106cec <hpmappages+0x6c>
80106cc5:	8d 76 00             	lea    0x0(%esi),%esi
    a += HPSIZE;
80106cc8:	81 c2 00 00 40 00    	add    $0x400000,%edx
    pde = &pgdir[PDX(a)];
80106cce:	89 d1                	mov    %edx,%ecx
80106cd0:	8d 04 16             	lea    (%esi,%edx,1),%eax
80106cd3:	c1 e9 16             	shr    $0x16,%ecx
80106cd6:	29 d8                	sub    %ebx,%eax
80106cd8:	8d 0c 8f             	lea    (%edi,%ecx,4),%ecx
    if (*pde & PTE_P) {
80106cdb:	f6 01 01             	testb  $0x1,(%ecx)
80106cde:	75 16                	jne    80106cf6 <hpmappages+0x76>
    *pde = pa | perm | PTE_P | PTE_PS;
80106ce0:	0b 45 18             	or     0x18(%ebp),%eax
80106ce3:	0c 81                	or     $0x81,%al
80106ce5:	89 01                	mov    %eax,(%ecx)
    if (a >= last)
80106ce7:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80106cea:	77 dc                	ja     80106cc8 <hpmappages+0x48>
}
80106cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cef:	31 c0                	xor    %eax,%eax
80106cf1:	5b                   	pop    %ebx
80106cf2:	5e                   	pop    %esi
80106cf3:	5f                   	pop    %edi
80106cf4:	5d                   	pop    %ebp
80106cf5:	c3                   	ret    
      panic("remap");
80106cf6:	83 ec 0c             	sub    $0xc,%esp
80106cf9:	68 84 83 10 80       	push   $0x80108384
80106cfe:	e8 7d 96 ff ff       	call   80100380 <panic>
80106d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d10:	a1 c4 54 11 80       	mov    0x801154c4,%eax
80106d15:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d1a:	0f 22 d8             	mov    %eax,%cr3
}
80106d1d:	c3                   	ret    
80106d1e:	66 90                	xchg   %ax,%ax

80106d20 <switchuvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d2c:	85 f6                	test   %esi,%esi
80106d2e:	0f 84 cb 00 00 00    	je     80106dff <switchuvm+0xdf>
  if(p->kstack == 0)
80106d34:	8b 46 08             	mov    0x8(%esi),%eax
80106d37:	85 c0                	test   %eax,%eax
80106d39:	0f 84 da 00 00 00    	je     80106e19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d3f:	8b 46 04             	mov    0x4(%esi),%eax
80106d42:	85 c0                	test   %eax,%eax
80106d44:	0f 84 c2 00 00 00    	je     80106e0c <switchuvm+0xec>
  pushcli();
80106d4a:	e8 11 d7 ff ff       	call   80104460 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d4f:	e8 ac cb ff ff       	call   80103900 <mycpu>
80106d54:	89 c3                	mov    %eax,%ebx
80106d56:	e8 a5 cb ff ff       	call   80103900 <mycpu>
80106d5b:	89 c7                	mov    %eax,%edi
80106d5d:	e8 9e cb ff ff       	call   80103900 <mycpu>
80106d62:	83 c7 08             	add    $0x8,%edi
80106d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d68:	e8 93 cb ff ff       	call   80103900 <mycpu>
80106d6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d70:	ba 67 00 00 00       	mov    $0x67,%edx
80106d75:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d7c:	83 c0 08             	add    $0x8,%eax
80106d7f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d86:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d8b:	83 c1 08             	add    $0x8,%ecx
80106d8e:	c1 e8 18             	shr    $0x18,%eax
80106d91:	c1 e9 10             	shr    $0x10,%ecx
80106d94:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d9a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106da0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106da5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106db1:	e8 4a cb ff ff       	call   80103900 <mycpu>
80106db6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbd:	e8 3e cb ff ff       	call   80103900 <mycpu>
80106dc2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dc6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106dc9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dcf:	e8 2c cb ff ff       	call   80103900 <mycpu>
80106dd4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dd7:	e8 24 cb ff ff       	call   80103900 <mycpu>
80106ddc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106de0:	b8 28 00 00 00       	mov    $0x28,%eax
80106de5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106de8:	8b 46 04             	mov    0x4(%esi),%eax
80106deb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106df0:	0f 22 d8             	mov    %eax,%cr3
}
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	5b                   	pop    %ebx
80106df7:	5e                   	pop    %esi
80106df8:	5f                   	pop    %edi
80106df9:	5d                   	pop    %ebp
  popcli();
80106dfa:	e9 b1 d6 ff ff       	jmp    801044b0 <popcli>
    panic("switchuvm: no process");
80106dff:	83 ec 0c             	sub    $0xc,%esp
80106e02:	68 8a 83 10 80       	push   $0x8010838a
80106e07:	e8 74 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e0c:	83 ec 0c             	sub    $0xc,%esp
80106e0f:	68 b5 83 10 80       	push   $0x801083b5
80106e14:	e8 67 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e19:	83 ec 0c             	sub    $0xc,%esp
80106e1c:	68 a0 83 10 80       	push   $0x801083a0
80106e21:	e8 5a 95 ff ff       	call   80100380 <panic>
80106e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi

80106e30 <inituvm>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 1c             	sub    $0x1c,%esp
80106e39:	8b 75 10             	mov    0x10(%ebp),%esi
80106e3c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e42:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e48:	77 50                	ja     80106e9a <inituvm+0x6a>
80106e4a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106e4d:	e8 2e b8 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106e52:	83 ec 04             	sub    $0x4,%esp
80106e55:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e5a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e5c:	6a 00                	push   $0x0
80106e5e:	50                   	push   %eax
80106e5f:	e8 0c d8 ff ff       	call   80104670 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e67:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e6d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106e74:	50                   	push   %eax
80106e75:	68 00 10 00 00       	push   $0x1000
80106e7a:	6a 00                	push   $0x0
80106e7c:	52                   	push   %edx
80106e7d:	e8 0e fd ff ff       	call   80106b90 <mappages>
  memmove(mem, init, sz);
80106e82:	89 75 10             	mov    %esi,0x10(%ebp)
80106e85:	83 c4 20             	add    $0x20,%esp
80106e88:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e91:	5b                   	pop    %ebx
80106e92:	5e                   	pop    %esi
80106e93:	5f                   	pop    %edi
80106e94:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e95:	e9 76 d8 ff ff       	jmp    80104710 <memmove>
    panic("inituvm: more than a page");
80106e9a:	83 ec 0c             	sub    $0xc,%esp
80106e9d:	68 c9 83 10 80       	push   $0x801083c9
80106ea2:	e8 d9 94 ff ff       	call   80100380 <panic>
80106ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eae:	66 90                	xchg   %ax,%ax

80106eb0 <loaduvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
80106eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ebc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ebf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ec4:	0f 85 bb 00 00 00    	jne    80106f85 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eca:	01 f0                	add    %esi,%eax
80106ecc:	89 f3                	mov    %esi,%ebx
80106ece:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ed1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ed4:	01 f0                	add    %esi,%eax
80106ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ed9:	85 f6                	test   %esi,%esi
80106edb:	0f 84 87 00 00 00    	je     80106f68 <loaduvm+0xb8>
80106ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106eee:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106ef0:	89 c2                	mov    %eax,%edx
80106ef2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ef5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106ef8:	f6 c2 01             	test   $0x1,%dl
80106efb:	75 13                	jne    80106f10 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106efd:	83 ec 0c             	sub    $0xc,%esp
80106f00:	68 e3 83 10 80       	push   $0x801083e3
80106f05:	e8 76 94 ff ff       	call   80100380 <panic>
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f10:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f13:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f19:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f1e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f25:	85 c0                	test   %eax,%eax
80106f27:	74 d4                	je     80106efd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f29:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f2b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f2e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f38:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f3e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f41:	29 d9                	sub    %ebx,%ecx
80106f43:	05 00 00 00 80       	add    $0x80000000,%eax
80106f48:	57                   	push   %edi
80106f49:	51                   	push   %ecx
80106f4a:	50                   	push   %eax
80106f4b:	ff 75 10             	push   0x10(%ebp)
80106f4e:	e8 3d ab ff ff       	call   80101a90 <readi>
80106f53:	83 c4 10             	add    $0x10,%esp
80106f56:	39 f8                	cmp    %edi,%eax
80106f58:	75 1e                	jne    80106f78 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f5a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f60:	89 f0                	mov    %esi,%eax
80106f62:	29 d8                	sub    %ebx,%eax
80106f64:	39 c6                	cmp    %eax,%esi
80106f66:	77 80                	ja     80106ee8 <loaduvm+0x38>
}
80106f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f6b:	31 c0                	xor    %eax,%eax
}
80106f6d:	5b                   	pop    %ebx
80106f6e:	5e                   	pop    %esi
80106f6f:	5f                   	pop    %edi
80106f70:	5d                   	pop    %ebp
80106f71:	c3                   	ret    
80106f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f80:	5b                   	pop    %ebx
80106f81:	5e                   	pop    %esi
80106f82:	5f                   	pop    %edi
80106f83:	5d                   	pop    %ebp
80106f84:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f85:	83 ec 0c             	sub    $0xc,%esp
80106f88:	68 84 84 10 80       	push   $0x80108484
80106f8d:	e8 ee 93 ff ff       	call   80100380 <panic>
80106f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <allocuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106fa9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106fac:	85 ff                	test   %edi,%edi
80106fae:	0f 88 bc 00 00 00    	js     80107070 <allocuvm+0xd0>
  if(newsz < oldsz)
80106fb4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106fb7:	0f 82 a3 00 00 00    	jb     80107060 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc0:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fc6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fcc:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fcf:	0f 86 8e 00 00 00    	jbe    80107063 <allocuvm+0xc3>
80106fd5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fdb:	eb 43                	jmp    80107020 <allocuvm+0x80>
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fe0:	83 ec 04             	sub    $0x4,%esp
80106fe3:	68 00 10 00 00       	push   $0x1000
80106fe8:	6a 00                	push   $0x0
80106fea:	50                   	push   %eax
80106feb:	e8 80 d6 ff ff       	call   80104670 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ff0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ff6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106ffd:	50                   	push   %eax
80106ffe:	68 00 10 00 00       	push   $0x1000
80107003:	56                   	push   %esi
80107004:	57                   	push   %edi
80107005:	e8 86 fb ff ff       	call   80106b90 <mappages>
8010700a:	83 c4 20             	add    $0x20,%esp
8010700d:	85 c0                	test   %eax,%eax
8010700f:	78 6f                	js     80107080 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80107011:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107017:	39 75 10             	cmp    %esi,0x10(%ebp)
8010701a:	0f 86 a0 00 00 00    	jbe    801070c0 <allocuvm+0x120>
    mem = kalloc();
80107020:	e8 5b b6 ff ff       	call   80102680 <kalloc>
80107025:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107027:	85 c0                	test   %eax,%eax
80107029:	75 b5                	jne    80106fe0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010702b:	83 ec 0c             	sub    $0xc,%esp
8010702e:	68 01 84 10 80       	push   $0x80108401
80107033:	e8 68 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107038:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703b:	83 c4 10             	add    $0x10,%esp
8010703e:	39 45 10             	cmp    %eax,0x10(%ebp)
80107041:	74 2d                	je     80107070 <allocuvm+0xd0>
80107043:	8b 55 10             	mov    0x10(%ebp),%edx
80107046:	89 c1                	mov    %eax,%ecx
80107048:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
8010704b:	31 ff                	xor    %edi,%edi
8010704d:	e8 ce f9 ff ff       	call   80106a20 <deallocuvm.part.0>
}
80107052:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107055:	89 f8                	mov    %edi,%eax
80107057:	5b                   	pop    %ebx
80107058:	5e                   	pop    %esi
80107059:	5f                   	pop    %edi
8010705a:	5d                   	pop    %ebp
8010705b:	c3                   	ret    
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107060:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107066:	89 f8                	mov    %edi,%eax
80107068:	5b                   	pop    %ebx
80107069:	5e                   	pop    %esi
8010706a:	5f                   	pop    %edi
8010706b:	5d                   	pop    %ebp
8010706c:	c3                   	ret    
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107073:	31 ff                	xor    %edi,%edi
}
80107075:	5b                   	pop    %ebx
80107076:	89 f8                	mov    %edi,%eax
80107078:	5e                   	pop    %esi
80107079:	5f                   	pop    %edi
8010707a:	5d                   	pop    %ebp
8010707b:	c3                   	ret    
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107080:	83 ec 0c             	sub    $0xc,%esp
80107083:	68 19 84 10 80       	push   $0x80108419
80107088:	e8 13 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010708d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107090:	83 c4 10             	add    $0x10,%esp
80107093:	39 45 10             	cmp    %eax,0x10(%ebp)
80107096:	74 0d                	je     801070a5 <allocuvm+0x105>
80107098:	89 c1                	mov    %eax,%ecx
8010709a:	8b 55 10             	mov    0x10(%ebp),%edx
8010709d:	8b 45 08             	mov    0x8(%ebp),%eax
801070a0:	e8 7b f9 ff ff       	call   80106a20 <deallocuvm.part.0>
      kfree(mem);
801070a5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801070a8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801070aa:	53                   	push   %ebx
801070ab:	e8 10 b4 ff ff       	call   801024c0 <kfree>
      return 0;
801070b0:	83 c4 10             	add    $0x10,%esp
}
801070b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b6:	89 f8                	mov    %edi,%eax
801070b8:	5b                   	pop    %ebx
801070b9:	5e                   	pop    %esi
801070ba:	5f                   	pop    %edi
801070bb:	5d                   	pop    %ebp
801070bc:	c3                   	ret    
801070bd:	8d 76 00             	lea    0x0(%esi),%esi
801070c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801070c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c6:	5b                   	pop    %ebx
801070c7:	5e                   	pop    %esi
801070c8:	89 f8                	mov    %edi,%eax
801070ca:	5f                   	pop    %edi
801070cb:	5d                   	pop    %ebp
801070cc:	c3                   	ret    
801070cd:	8d 76 00             	lea    0x0(%esi),%esi

801070d0 <deallocuvm>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070dc:	39 d1                	cmp    %edx,%ecx
801070de:	73 10                	jae    801070f0 <deallocuvm+0x20>
}
801070e0:	5d                   	pop    %ebp
801070e1:	e9 3a f9 ff ff       	jmp    80106a20 <deallocuvm.part.0>
801070e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ed:	8d 76 00             	lea    0x0(%esi),%esi
801070f0:	89 d0                	mov    %edx,%eax
801070f2:	5d                   	pop    %ebp
801070f3:	c3                   	ret    
801070f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070ff:	90                   	nop

80107100 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 0c             	sub    $0xc,%esp
80107109:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010710c:	85 f6                	test   %esi,%esi
8010710e:	74 5d                	je     8010716d <freevm+0x6d>
  if(newsz >= oldsz)
80107110:	31 c9                	xor    %ecx,%ecx
80107112:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107117:	89 f0                	mov    %esi,%eax
80107119:	89 f3                	mov    %esi,%ebx
8010711b:	e8 00 f9 ff ff       	call   80106a20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107120:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107126:	eb 0f                	jmp    80107137 <freevm+0x37>
80107128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712f:	90                   	nop
80107130:	83 c3 04             	add    $0x4,%ebx
80107133:	39 fb                	cmp    %edi,%ebx
80107135:	74 27                	je     8010715e <freevm+0x5e>
    if(pgdir[i] & PTE_P){
80107137:	8b 03                	mov    (%ebx),%eax
80107139:	a8 01                	test   $0x1,%al
8010713b:	74 f3                	je     80107130 <freevm+0x30>
      // check if page is a normal size (PTE_PS)
      if((pgdir[i] & PTE_PS) == 0) {
8010713d:	a8 80                	test   $0x80,%al
8010713f:	75 ef                	jne    80107130 <freevm+0x30>
        char * v = P2V(PTE_ADDR(pgdir[i]));
80107141:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        kfree(v);
80107146:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107149:	83 c3 04             	add    $0x4,%ebx
        char * v = P2V(PTE_ADDR(pgdir[i]));
8010714c:	05 00 00 00 80       	add    $0x80000000,%eax
        kfree(v);
80107151:	50                   	push   %eax
80107152:	e8 69 b3 ff ff       	call   801024c0 <kfree>
80107157:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010715a:	39 fb                	cmp    %edi,%ebx
8010715c:	75 d9                	jne    80107137 <freevm+0x37>
      }
      // for huge pages don't clear page, just clear pde
    }
  }
  kfree((char*)pgdir);
8010715e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107164:	5b                   	pop    %ebx
80107165:	5e                   	pop    %esi
80107166:	5f                   	pop    %edi
80107167:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107168:	e9 53 b3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
8010716d:	83 ec 0c             	sub    $0xc,%esp
80107170:	68 35 84 10 80       	push   $0x80108435
80107175:	e8 06 92 ff ff       	call   80100380 <panic>
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <setupkvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	56                   	push   %esi
80107184:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107185:	e8 f6 b4 ff ff       	call   80102680 <kalloc>
8010718a:	89 c6                	mov    %eax,%esi
8010718c:	85 c0                	test   %eax,%eax
8010718e:	74 42                	je     801071d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107193:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107198:	68 00 10 00 00       	push   $0x1000
8010719d:	6a 00                	push   $0x0
8010719f:	50                   	push   %eax
801071a0:	e8 cb d4 ff ff       	call   80104670 <memset>
801071a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801071a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071ab:	8b 53 08             	mov    0x8(%ebx),%edx
801071ae:	83 ec 0c             	sub    $0xc,%esp
801071b1:	ff 73 0c             	push   0xc(%ebx)
801071b4:	29 c2                	sub    %eax,%edx
801071b6:	50                   	push   %eax
801071b7:	52                   	push   %edx
801071b8:	ff 33                	push   (%ebx)
801071ba:	56                   	push   %esi
801071bb:	e8 d0 f9 ff ff       	call   80106b90 <mappages>
801071c0:	83 c4 20             	add    $0x20,%esp
801071c3:	85 c0                	test   %eax,%eax
801071c5:	78 19                	js     801071e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071c7:	83 c3 10             	add    $0x10,%ebx
801071ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071d0:	75 d6                	jne    801071a8 <setupkvm+0x28>
}
801071d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071d5:	89 f0                	mov    %esi,%eax
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5d                   	pop    %ebp
801071da:	c3                   	ret    
801071db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071df:	90                   	nop
      freevm(pgdir);
801071e0:	83 ec 0c             	sub    $0xc,%esp
801071e3:	56                   	push   %esi
      return 0;
801071e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071e6:	e8 15 ff ff ff       	call   80107100 <freevm>
      return 0;
801071eb:	83 c4 10             	add    $0x10,%esp
}
801071ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f1:	89 f0                	mov    %esi,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5d                   	pop    %ebp
801071f6:	c3                   	ret    
801071f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071fe:	66 90                	xchg   %ax,%ax

80107200 <kvmalloc>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107206:	e8 75 ff ff ff       	call   80107180 <setupkvm>
8010720b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107210:	05 00 00 00 80       	add    $0x80000000,%eax
80107215:	0f 22 d8             	mov    %eax,%cr3
}
80107218:	c9                   	leave  
80107219:	c3                   	ret    
8010721a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107220 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	83 ec 08             	sub    $0x8,%esp
80107226:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107229:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010722c:	89 c1                	mov    %eax,%ecx
8010722e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107231:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107234:	f6 c2 01             	test   $0x1,%dl
80107237:	75 17                	jne    80107250 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107239:	83 ec 0c             	sub    $0xc,%esp
8010723c:	68 46 84 10 80       	push   $0x80108446
80107241:	e8 3a 91 ff ff       	call   80100380 <panic>
80107246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107250:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107253:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107259:	25 fc 0f 00 00       	and    $0xffc,%eax
8010725e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107265:	85 c0                	test   %eax,%eax
80107267:	74 d0                	je     80107239 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107269:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010726c:	c9                   	leave  
8010726d:	c3                   	ret    
8010726e:	66 90                	xchg   %ax,%ax

80107270 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107279:	e8 02 ff ff ff       	call   80107180 <setupkvm>
8010727e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107281:	85 c0                	test   %eax,%eax
80107283:	0f 84 c0 00 00 00    	je     80107349 <copyuvm+0xd9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107289:	8b 55 0c             	mov    0xc(%ebp),%edx
8010728c:	85 d2                	test   %edx,%edx
8010728e:	0f 84 b5 00 00 00    	je     80107349 <copyuvm+0xd9>
80107294:	31 f6                	xor    %esi,%esi
80107296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801072a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801072a3:	89 f0                	mov    %esi,%eax
801072a5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801072ab:	a8 01                	test   $0x1,%al
801072ad:	75 11                	jne    801072c0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072af:	83 ec 0c             	sub    $0xc,%esp
801072b2:	68 50 84 10 80       	push   $0x80108450
801072b7:	e8 c4 90 ff ff       	call   80100380 <panic>
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072c0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072c7:	c1 ea 0a             	shr    $0xa,%edx
801072ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072d7:	85 c0                	test   %eax,%eax
801072d9:	74 d4                	je     801072af <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072db:	8b 38                	mov    (%eax),%edi
801072dd:	f7 c7 01 00 00 00    	test   $0x1,%edi
801072e3:	0f 84 9b 00 00 00    	je     80107384 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801072e9:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
801072eb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801072f1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072f4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
801072fa:	e8 81 b3 ff ff       	call   80102680 <kalloc>
801072ff:	89 c7                	mov    %eax,%edi
80107301:	85 c0                	test   %eax,%eax
80107303:	74 5f                	je     80107364 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107305:	83 ec 04             	sub    $0x4,%esp
80107308:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010730e:	68 00 10 00 00       	push   $0x1000
80107313:	53                   	push   %ebx
80107314:	50                   	push   %eax
80107315:	e8 f6 d3 ff ff       	call   80104710 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010731a:	58                   	pop    %eax
8010731b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107321:	ff 75 e4             	push   -0x1c(%ebp)
80107324:	50                   	push   %eax
80107325:	68 00 10 00 00       	push   $0x1000
8010732a:	56                   	push   %esi
8010732b:	ff 75 e0             	push   -0x20(%ebp)
8010732e:	e8 5d f8 ff ff       	call   80106b90 <mappages>
80107333:	83 c4 20             	add    $0x20,%esp
80107336:	85 c0                	test   %eax,%eax
80107338:	78 1e                	js     80107358 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010733a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107340:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107343:	0f 87 57 ff ff ff    	ja     801072a0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107349:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010734c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734f:	5b                   	pop    %ebx
80107350:	5e                   	pop    %esi
80107351:	5f                   	pop    %edi
80107352:	5d                   	pop    %ebp
80107353:	c3                   	ret    
80107354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107358:	83 ec 0c             	sub    $0xc,%esp
8010735b:	57                   	push   %edi
8010735c:	e8 5f b1 ff ff       	call   801024c0 <kfree>
      goto bad;
80107361:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107364:	83 ec 0c             	sub    $0xc,%esp
80107367:	ff 75 e0             	push   -0x20(%ebp)
8010736a:	e8 91 fd ff ff       	call   80107100 <freevm>
  return 0;
8010736f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107376:	83 c4 10             	add    $0x10,%esp
}
80107379:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010737c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010737f:	5b                   	pop    %ebx
80107380:	5e                   	pop    %esi
80107381:	5f                   	pop    %edi
80107382:	5d                   	pop    %ebp
80107383:	c3                   	ret    
      panic("copyuvm: page not present");
80107384:	83 ec 0c             	sub    $0xc,%esp
80107387:	68 6a 84 10 80       	push   $0x8010846a
8010738c:	e8 ef 8f ff ff       	call   80100380 <panic>
80107391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739f:	90                   	nop

801073a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073a9:	89 c1                	mov    %eax,%ecx
801073ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073b1:	f6 c2 01             	test   $0x1,%dl
801073b4:	0f 84 00 01 00 00    	je     801074ba <uva2ka.cold>
  return &pgtab[PTX(va)];
801073ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801073c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801073c9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801073d0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073d7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073da:	05 00 00 00 80       	add    $0x80000000,%eax
801073df:	83 fa 05             	cmp    $0x5,%edx
801073e2:	ba 00 00 00 00       	mov    $0x0,%edx
801073e7:	0f 45 c2             	cmovne %edx,%eax
}
801073ea:	c3                   	ret    
801073eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073ef:	90                   	nop

801073f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 0c             	sub    $0xc,%esp
801073f9:	8b 75 14             	mov    0x14(%ebp),%esi
801073fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801073ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107402:	85 f6                	test   %esi,%esi
80107404:	75 51                	jne    80107457 <copyout+0x67>
80107406:	e9 a5 00 00 00       	jmp    801074b0 <copyout+0xc0>
8010740b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010740f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107410:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107416:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010741c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107422:	74 75                	je     80107499 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107424:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107426:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107429:	29 c3                	sub    %eax,%ebx
8010742b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107431:	39 f3                	cmp    %esi,%ebx
80107433:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107436:	29 f8                	sub    %edi,%eax
80107438:	83 ec 04             	sub    $0x4,%esp
8010743b:	01 c1                	add    %eax,%ecx
8010743d:	53                   	push   %ebx
8010743e:	52                   	push   %edx
8010743f:	51                   	push   %ecx
80107440:	e8 cb d2 ff ff       	call   80104710 <memmove>
    len -= n;
    buf += n;
80107445:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107448:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010744e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107451:	01 da                	add    %ebx,%edx
  while(len > 0){
80107453:	29 de                	sub    %ebx,%esi
80107455:	74 59                	je     801074b0 <copyout+0xc0>
  if(*pde & PTE_P){
80107457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010745a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010745c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010745e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107461:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107467:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010746a:	f6 c1 01             	test   $0x1,%cl
8010746d:	0f 84 4e 00 00 00    	je     801074c1 <copyout.cold>
  return &pgtab[PTX(va)];
80107473:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107475:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010747b:	c1 eb 0c             	shr    $0xc,%ebx
8010747e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107484:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010748b:	89 d9                	mov    %ebx,%ecx
8010748d:	83 e1 05             	and    $0x5,%ecx
80107490:	83 f9 05             	cmp    $0x5,%ecx
80107493:	0f 84 77 ff ff ff    	je     80107410 <copyout+0x20>
  }
  return 0;
}
80107499:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010749c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074a1:	5b                   	pop    %ebx
801074a2:	5e                   	pop    %esi
801074a3:	5f                   	pop    %edi
801074a4:	5d                   	pop    %ebp
801074a5:	c3                   	ret    
801074a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ad:	8d 76 00             	lea    0x0(%esi),%esi
801074b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074b3:	31 c0                	xor    %eax,%eax
}
801074b5:	5b                   	pop    %ebx
801074b6:	5e                   	pop    %esi
801074b7:	5f                   	pop    %edi
801074b8:	5d                   	pop    %ebp
801074b9:	c3                   	ret    

801074ba <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801074ba:	a1 00 00 00 00       	mov    0x0,%eax
801074bf:	0f 0b                	ud2    

801074c1 <copyout.cold>:
801074c1:	a1 00 00 00 00       	mov    0x0,%eax
801074c6:	0f 0b                	ud2    
801074c8:	66 90                	xchg   %ax,%ax
801074ca:	66 90                	xchg   %ax,%ax
801074cc:	66 90                	xchg   %ax,%ax
801074ce:	66 90                	xchg   %ax,%ax

801074d0 <DPUInit>:
801074d0:	c7 05 cc 54 11 80 00 	movl   $0xfe000000,0x801154cc
801074d7:	00 00 fe 
801074da:	31 c0                	xor    %eax,%eax
801074dc:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
801074e1:	c7 05 c8 54 11 80 00 	movl   $0xfe080000,0x801154c8
801074e8:	00 08 fe 
801074eb:	eb 09                	jmp    801074f6 <DPUInit+0x26>
801074ed:	8d 76 00             	lea    0x0(%esi),%esi
801074f0:	8b 15 cc 54 11 80    	mov    0x801154cc,%edx
801074f6:	01 c2                	add    %eax,%edx
801074f8:	83 c0 04             	add    $0x4,%eax
801074fb:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80107501:	3d 00 04 00 00       	cmp    $0x400,%eax
80107506:	75 e8                	jne    801074f0 <DPUInit+0x20>
80107508:	31 c0                	xor    %eax,%eax
8010750a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107510:	8b 15 c8 54 11 80    	mov    0x801154c8,%edx
80107516:	01 c2                	add    %eax,%edx
80107518:	83 c0 04             	add    $0x4,%eax
8010751b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80107521:	3d 00 00 08 00       	cmp    $0x80000,%eax
80107526:	75 e8                	jne    80107510 <DPUInit+0x40>
80107528:	c3                   	ret    
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107530 <simple_hash>:
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	69 55 0c b1 79 37 9e 	imul   $0x9e3779b1,0xc(%ebp),%edx
8010753a:	c1 c2 10             	rol    $0x10,%edx
8010753d:	33 55 08             	xor    0x8(%ebp),%edx
80107540:	5d                   	pop    %ebp
80107541:	89 d0                	mov    %edx,%eax
80107543:	c1 e8 10             	shr    $0x10,%eax
80107546:	31 d0                	xor    %edx,%eax
80107548:	69 c0 6b ca eb 85    	imul   $0x85ebca6b,%eax,%eax
8010754e:	89 c2                	mov    %eax,%edx
80107550:	c1 ea 0d             	shr    $0xd,%edx
80107553:	31 c2                	xor    %eax,%edx
80107555:	69 d2 35 ae b2 c2    	imul   $0xc2b2ae35,%edx,%edx
8010755b:	89 d0                	mov    %edx,%eax
8010755d:	c1 e8 10             	shr    $0x10,%eax
80107560:	31 d0                	xor    %edx,%eax
80107562:	c3                   	ret    
80107563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <inner_product>:
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107577:	56                   	push   %esi
80107578:	8b 75 10             	mov    0x10(%ebp),%esi
8010757b:	53                   	push   %ebx
8010757c:	c1 e9 02             	shr    $0x2,%ecx
8010757f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107582:	74 1c                	je     801075a0 <inner_product+0x30>
80107584:	89 cf                	mov    %ecx,%edi
80107586:	31 c0                	xor    %eax,%eax
80107588:	31 c9                	xor    %ecx,%ecx
8010758a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107590:	8b 14 83             	mov    (%ebx,%eax,4),%edx
80107593:	0f af 14 86          	imul   (%esi,%eax,4),%edx
80107597:	83 c0 01             	add    $0x1,%eax
8010759a:	01 d1                	add    %edx,%ecx
8010759c:	39 f8                	cmp    %edi,%eax
8010759e:	75 f0                	jne    80107590 <inner_product+0x20>
801075a0:	5b                   	pop    %ebx
801075a1:	89 c8                	mov    %ecx,%eax
801075a3:	5e                   	pop    %esi
801075a4:	5f                   	pop    %edi
801075a5:	5d                   	pop    %ebp
801075a6:	c3                   	ret    
801075a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ae:	66 90                	xchg   %ax,%ax

801075b0 <DPU_loop>:
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 1c             	sub    $0x1c,%esp
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075c0:	8b 1d cc 54 11 80    	mov    0x801154cc,%ebx
801075c6:	8b 43 2c             	mov    0x2c(%ebx),%eax
801075c9:	83 f8 01             	cmp    $0x1,%eax
801075cc:	75 4f                	jne    8010761d <DPU_loop+0x6d>
801075ce:	8b 4b 30             	mov    0x30(%ebx),%ecx
801075d1:	8b 43 34             	mov    0x34(%ebx),%eax
801075d4:	8b 53 38             	mov    0x38(%ebx),%edx
801075d7:	69 c0 b1 79 37 9e    	imul   $0x9e3779b1,%eax,%eax
801075dd:	c1 c0 10             	rol    $0x10,%eax
801075e0:	31 c8                	xor    %ecx,%eax
801075e2:	89 c1                	mov    %eax,%ecx
801075e4:	c1 e9 10             	shr    $0x10,%ecx
801075e7:	31 c8                	xor    %ecx,%eax
801075e9:	69 c0 6b ca eb 85    	imul   $0x85ebca6b,%eax,%eax
801075ef:	89 c1                	mov    %eax,%ecx
801075f1:	c1 e9 0d             	shr    $0xd,%ecx
801075f4:	31 c8                	xor    %ecx,%eax
801075f6:	69 c0 35 ae b2 c2    	imul   $0xc2b2ae35,%eax,%eax
801075fc:	89 c1                	mov    %eax,%ecx
801075fe:	c1 e9 10             	shr    $0x10,%ecx
80107601:	31 c8                	xor    %ecx,%eax
80107603:	89 43 3c             	mov    %eax,0x3c(%ebx)
80107606:	c7 82 00 00 00 80 01 	movl   $0x1,-0x80000000(%edx)
8010760d:	00 00 00 
80107610:	8b 1d cc 54 11 80    	mov    0x801154cc,%ebx
80107616:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
8010761d:	8b 43 54             	mov    0x54(%ebx),%eax
80107620:	83 f8 01             	cmp    $0x1,%eax
80107623:	75 56                	jne    8010767b <DPU_loop+0xcb>
80107625:	8b 4b 58             	mov    0x58(%ebx),%ecx
80107628:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010762b:	8b 73 60             	mov    0x60(%ebx),%esi
8010762e:	8b 7b 64             	mov    0x64(%ebx),%edi
80107631:	c1 e9 02             	shr    $0x2,%ecx
80107634:	8d 82 00 00 08 fe    	lea    -0x1f80000(%edx),%eax
8010763a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010763d:	74 20                	je     8010765f <DPU_loop+0xaf>
8010763f:	8d 3c 88             	lea    (%eax,%ecx,4),%edi
80107642:	29 d6                	sub    %edx,%esi
80107644:	31 c9                	xor    %ecx,%ecx
80107646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764d:	8d 76 00             	lea    0x0(%esi),%esi
80107650:	8b 14 06             	mov    (%esi,%eax,1),%edx
80107653:	0f af 10             	imul   (%eax),%edx
80107656:	83 c0 04             	add    $0x4,%eax
80107659:	01 d1                	add    %edx,%ecx
8010765b:	39 c7                	cmp    %eax,%edi
8010765d:	75 f1                	jne    80107650 <DPU_loop+0xa0>
8010765f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107662:	89 4b 68             	mov    %ecx,0x68(%ebx)
80107665:	c7 80 00 00 00 80 01 	movl   $0x1,-0x80000000(%eax)
8010766c:	00 00 00 
8010766f:	a1 cc 54 11 80       	mov    0x801154cc,%eax
80107674:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
8010767b:	e8 80 c9 ff ff       	call   80104000 <yield>
80107680:	e9 3b ff ff ff       	jmp    801075c0 <DPU_loop+0x10>
80107685:	66 90                	xchg   %ax,%ax
80107687:	66 90                	xchg   %ax,%ax
80107689:	66 90                	xchg   %ax,%ax
8010768b:	66 90                	xchg   %ax,%ax
8010768d:	66 90                	xchg   %ax,%ax
8010768f:	90                   	nop

80107690 <SSDInit>:
80107690:	55                   	push   %ebp
80107691:	31 c0                	xor    %eax,%eax
80107693:	ba 00 00 10 fe       	mov    $0xfe100000,%edx
80107698:	89 e5                	mov    %esp,%ebp
8010769a:	83 ec 08             	sub    $0x8,%esp
8010769d:	c7 05 e0 54 21 80 00 	movl   $0xfe100000,0x802154e0
801076a4:	00 10 fe 
801076a7:	eb 0d                	jmp    801076b6 <SSDInit+0x26>
801076a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076b0:	8b 15 e0 54 21 80    	mov    0x802154e0,%edx
801076b6:	01 c2                	add    %eax,%edx
801076b8:	83 c0 04             	add    $0x4,%eax
801076bb:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
801076c1:	3d 00 04 00 00       	cmp    $0x400,%eax
801076c6:	75 e8                	jne    801076b0 <SSDInit+0x20>
801076c8:	31 c0                	xor    %eax,%eax
801076ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076d0:	c7 04 85 e0 54 11 80 	movl   $0x0,-0x7feeab20(,%eax,4)
801076d7:	00 00 00 00 
801076db:	83 c0 01             	add    $0x1,%eax
801076de:	3d 00 00 04 00       	cmp    $0x40000,%eax
801076e3:	75 eb                	jne    801076d0 <SSDInit+0x40>
801076e5:	83 ec 04             	sub    $0x4,%esp
801076e8:	6a 28                	push   $0x28
801076ea:	68 a8 84 10 80       	push   $0x801084a8
801076ef:	ff 35 e0 54 21 80    	push   0x802154e0
801076f5:	e8 16 d0 ff ff       	call   80104710 <memmove>
801076fa:	83 c4 10             	add    $0x10,%esp
801076fd:	b9 02 00 00 00       	mov    $0x2,%ecx
80107702:	31 c0                	xor    %eax,%eax
80107704:	c7 05 70 56 11 80 34 	movl   $0x1234,0x80115670
8010770b:	12 00 00 
8010770e:	ba 01 00 00 00       	mov    $0x1,%edx
80107713:	c7 05 e0 5c 11 80 e7 	movl   $0x3e7,0x80115ce0
8010771a:	03 00 00 
8010771d:	c7 05 e4 5c 11 80 78 	movl   $0x378,0x80115ce4
80107724:	03 00 00 
80107727:	c7 05 e8 5c 11 80 09 	movl   $0x309,0x80115ce8
8010772e:	03 00 00 
80107731:	c7 05 ec 5c 11 80 9a 	movl   $0x29a,0x80115cec
80107738:	02 00 00 
8010773b:	c7 05 e0 54 1d 80 e9 	movl   $0x7e9,0x801d54e0
80107742:	07 00 00 
80107745:	c7 05 e4 d4 1d 80 67 	movl   $0x2b67,0x801dd4e4
8010774c:	2b 00 00 
8010774f:	c7 05 e8 d4 1d 80 ce 	movl   $0x56ce,0x801dd4e8
80107756:	56 00 00 
80107759:	c7 05 ec d4 1d 80 35 	movl   $0x8235,0x801dd4ec
80107760:	82 00 00 
80107763:	c7 05 f0 d4 1d 80 9c 	movl   $0xad9c,0x801dd4f0
8010776a:	ad 00 00 
8010776d:	c7 05 f4 d4 1d 80 03 	movl   $0xd903,0x801dd4f4
80107774:	d9 00 00 
80107777:	c7 05 f8 d4 1d 80 6a 	movl   $0x1046a,0x801dd4f8
8010777e:	04 01 00 
80107781:	c7 05 fc d4 1d 80 d1 	movl   $0x12fd1,0x801dd4fc
80107788:	2f 01 00 
8010778b:	c7 05 00 d5 1d 80 38 	movl   $0x15b38,0x801dd500
80107792:	5b 01 00 
80107795:	c7 05 d4 56 11 80 87 	movl   $0x12d687,0x801156d4
8010779c:	d6 12 00 
8010779f:	c7 05 e0 56 11 80 ce 	movl   $0x23cace,0x801156e0
801077a6:	ca 23 00 
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b0:	89 14 85 e0 64 11 80 	mov    %edx,-0x7fee9b20(,%eax,4)
801077b7:	83 c2 0a             	add    $0xa,%edx
801077ba:	89 0c 85 20 65 11 80 	mov    %ecx,-0x7fee9ae0(,%eax,4)
801077c1:	83 c0 01             	add    $0x1,%eax
801077c4:	83 c1 05             	add    $0x5,%ecx
801077c7:	83 f8 10             	cmp    $0x10,%eax
801077ca:	75 e4                	jne    801077b0 <SSDInit+0x120>
801077cc:	ba 02 00 00 00       	mov    $0x2,%edx
801077d1:	b8 03 00 00 00       	mov    $0x3,%eax
801077d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077dd:	8d 76 00             	lea    0x0(%esi),%esi
801077e0:	89 94 00 5a 75 11 80 	mov    %edx,-0x7fee8aa6(%eax,%eax,1)
801077e7:	83 c2 03             	add    $0x3,%edx
801077ea:	89 84 00 da 74 11 80 	mov    %eax,-0x7fee8b26(%eax,%eax,1)
801077f1:	83 c0 02             	add    $0x2,%eax
801077f4:	83 f8 43             	cmp    $0x43,%eax
801077f7:	75 e7                	jne    801077e0 <SSDInit+0x150>
801077f9:	c9                   	leave  
801077fa:	c3                   	ret    
801077fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ff:	90                   	nop

80107800 <SSD_loop>:
80107800:	55                   	push   %ebp
80107801:	a1 e0 54 21 80       	mov    0x802154e0,%eax
80107806:	89 e5                	mov    %esp,%ebp
80107808:	56                   	push   %esi
80107809:	53                   	push   %ebx
8010780a:	8b 50 2c             	mov    0x2c(%eax),%edx
8010780d:	83 fa 01             	cmp    $0x1,%edx
80107810:	74 66                	je     80107878 <SSD_loop+0x78>
80107812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107818:	8b 50 54             	mov    0x54(%eax),%edx
8010781b:	83 fa 01             	cmp    $0x1,%edx
8010781e:	75 46                	jne    80107866 <SSD_loop+0x66>
80107820:	8b 48 58             	mov    0x58(%eax),%ecx
80107823:	8b 50 5c             	mov    0x5c(%eax),%edx
80107826:	8b 58 60             	mov    0x60(%eax),%ebx
80107829:	8b 70 64             	mov    0x64(%eax),%esi
8010782c:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107832:	c1 eb 02             	shr    $0x2,%ebx
80107835:	74 19                	je     80107850 <SSD_loop+0x50>
80107837:	83 e1 fc             	and    $0xfffffffc,%ecx
8010783a:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
8010783d:	29 d1                	sub    %edx,%ecx
8010783f:	90                   	nop
80107840:	8b 10                	mov    (%eax),%edx
80107842:	89 94 01 e0 54 11 00 	mov    %edx,0x1154e0(%ecx,%eax,1)
80107849:	83 c0 04             	add    $0x4,%eax
8010784c:	39 c3                	cmp    %eax,%ebx
8010784e:	75 f0                	jne    80107840 <SSD_loop+0x40>
80107850:	c7 86 00 00 00 80 01 	movl   $0x1,-0x80000000(%esi)
80107857:	00 00 00 
8010785a:	a1 e0 54 21 80       	mov    0x802154e0,%eax
8010785f:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
80107866:	e8 95 c7 ff ff       	call   80104000 <yield>
8010786b:	a1 e0 54 21 80       	mov    0x802154e0,%eax
80107870:	8b 50 2c             	mov    0x2c(%eax),%edx
80107873:	83 fa 01             	cmp    $0x1,%edx
80107876:	75 a0                	jne    80107818 <SSD_loop+0x18>
80107878:	8b 48 30             	mov    0x30(%eax),%ecx
8010787b:	8b 50 34             	mov    0x34(%eax),%edx
8010787e:	8b 58 38             	mov    0x38(%eax),%ebx
80107881:	8b 70 3c             	mov    0x3c(%eax),%esi
80107884:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
8010788a:	c1 eb 02             	shr    $0x2,%ebx
8010788d:	74 22                	je     801078b1 <SSD_loop+0xb1>
8010788f:	83 e1 fc             	and    $0xfffffffc,%ecx
80107892:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
80107895:	29 d1                	sub    %edx,%ecx
80107897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789e:	66 90                	xchg   %ax,%ax
801078a0:	8b 94 01 e0 54 11 00 	mov    0x1154e0(%ecx,%eax,1),%edx
801078a7:	83 c0 04             	add    $0x4,%eax
801078aa:	89 50 fc             	mov    %edx,-0x4(%eax)
801078ad:	39 d8                	cmp    %ebx,%eax
801078af:	75 ef                	jne    801078a0 <SSD_loop+0xa0>
801078b1:	c7 86 00 00 00 80 01 	movl   $0x1,-0x80000000(%esi)
801078b8:	00 00 00 
801078bb:	a1 e0 54 21 80       	mov    0x802154e0,%eax
801078c0:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
801078c7:	e9 4c ff ff ff       	jmp    80107818 <SSD_loop+0x18>
