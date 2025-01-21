.section __TEXT,__text,regular,pure_instructions
.build_version ios, 14, 5
.globl _main
.p2align 2

; Copyright 2025 @LNSSPsd on GitHub
; Idea from https://apps.apple.com/app/abcd-cards/id1212769036


; NOTE: Calling to system methods (BL) must prepare x29, x30

_init_sel:
	sub sp,sp,#32
	stp x29,x30,[sp,#16]
	str x1,[sp]
	bl _sel_registerName
	ldr x1,[sp]
	str x0,[x1]
	ldp x29,x30,[sp,#16]
	add sp,sp,#32
	ret
_init_class:
	sub sp,sp,#32
	stp x29,x30,[sp,#16]
	str x1,[sp]
	bl _objc_getRequiredClass
	ldr x1,[sp]
	str x0,[x1]
	ldp x29,x30,[sp,#16]
	add sp,sp,#32
	ret

/*init_sels_OLD:
	sub sp,sp,#0x10
	stp x29,x30,[sp]
	adrp x0,str_sel_retain@PAGE
	add x0,x0,str_sel_retain@PAGEOFF
	adrp x1,sel_retain@PAGE
	add x1,x1,sel_retain@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_release@PAGE
	add x0,x0,str_sel_release@PAGEOFF
	adrp x1,sel_release@PAGE
	add x1,x1,sel_release@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_alloc@PAGE
	add x0,x0,str_sel_alloc@PAGEOFF
	adrp x1,sel_alloc@PAGE
	add x1,x1,sel_alloc@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_init@PAGE
	add x0,x0,str_sel_init@PAGEOFF
	adrp x1,sel_init@PAGE
	add x1,x1,sel_init@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_new@PAGE
	add x0,x0,str_sel_new@PAGEOFF
	adrp x1,sel_new@PAGE
	add x1,x1,sel_new@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_initWithFrame@PAGE
	add x0,x0,str_sel_initWithFrame@PAGEOFF
	adrp x1,sel_initWithFrame@PAGE
	add x1,x1,sel_initWithFrame@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_colorWithRGBA@PAGE
	add x0,x0,str_sel_colorWithRGBA@PAGEOFF
	adrp x1,sel_colorWithRGBA@PAGE
	add x1,x1,sel_colorWithRGBA@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_setBackgroundColor@PAGE
	add x0,x0,str_sel_setBackgroundColor@PAGEOFF
	adrp x1,sel_setBackgroundColor@PAGE
	add x1,x1,sel_setBackgroundColor@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_setText@PAGE
	add x0,x0,str_sel_setText@PAGEOFF
	adrp x1,sel_setText@PAGE
	add x1,x1,sel_setText@PAGEOFF
	bl _init_sel
	adrp x0,str_sel_setTextAlignment@PAGE
	add x0,x0,str_sel_setTextAlignment@PAGEOFF
	adrp x1,sel_setTextAlignment@PAGE
	add x1,x1,sel_setTextAlignment@PAGEOFF
	bl _init_sel
	adrp x0,str_UIColor@PAGE
	add x0,x0,str_UIColor@PAGEOFF
	adrp x1,class_UIColor@PAGE
	add x1,x1,class_UIColor@PAGEOFF
	bl _init_class
	adrp x0,str_UIControl@PAGE
	add x0,x0,str_UIControl@PAGEOFF
	adrp x1,class_UIControl@PAGE
	add x1,x1,class_UIControl@PAGEOFF
	bl _init_class
	adrp x0,str_UILabel@PAGE
	add x0,x0,str_UILabel@PAGEOFF
	adrp x1,class_UILabel@PAGE
	add x1,x1,class_UILabel@PAGEOFF
	bl _init_class
	ldp x29,x30,[sp]
	add sp,sp,#0x10
	ret*/

.advance_str_ptr:
	ldrb w4,[x0]
	cmp w4,#0
	add x0,x0,#1
	b.ne .advance_str_ptr
	ret
init_sels:
	sub sp,sp,#80
	stp x29,x30,[sp,#64]
	adrp x1,.sel_begin@PAGE
	add x1,x1,.sel_begin@PAGEOFF
	adrp x2,.clsd_begin@PAGE
	add x2,x2,.clsd_begin@PAGEOFF
	adrp x3,.clsd_end@PAGE
	add x3,x3,.clsd_end@PAGEOFF
	stp x2,x3,[sp,#16]
	adrp x0,str_init_ptr@PAGE
	add x0,x0,str_init_ptr@PAGEOFF
.load_next_sel:
	cmp x1,x2
	b.eq .load_next_cls.start
	stp x0,x1,[sp]
	bl _init_sel
	ldp x0,x1,[sp]
	ldr x2,[sp,#16]
	bl .advance_str_ptr
	add x1,x1,#8
	b .load_next_sel
.load_next_cls.start:
	ldr x2,[sp,#24]
.load_next_cls:
	cmp x1,x2
	b.eq .load_next_cls.end
	stp x0,x1,[sp]
	bl _init_class
	ldp x0,x1,[sp]
	ldr x2,[sp,#24]
	bl .advance_str_ptr
	add x1,x1,#8
	b .load_next_cls
.load_next_cls.end:
	ldp x29,x30,[sp,#64]
	add sp,sp,#80
	ret

; x0: self
retainObj:
	adrp x1,sel_retain@PAGE
	ldr x1,[x1,sel_retain@PAGEOFF]
	b _objc_msgSend
releaseObj:
	adrp x1,sel_release@PAGE
	ldr x1,[x1,sel_release@PAGEOFF]
	b _objc_msgSend
allocObj:
	;sub sp,sp,#16
	;str x0,[sp]
	;adrp x1,str_sel_alloc@PAGE
	;add x0,x1,str_sel_alloc@PAGEOFF
	;bl _sel_registerName
	;mov x1,x0
	;ldr x0,[sp]
	;bl _objc_msgSend
	;add sp,sp,#16
	;ret
	adrp x1,sel_alloc@PAGE
	ldr x1,[x1,sel_alloc@PAGEOFF]
	b _objc_msgSend
initObj:
	adrp x1,sel_init@PAGE
	ldr x1,[x1,sel_init@PAGEOFF]
	b _objc_msgSend
newObj:
	adrp x1,sel_new@PAGE
	ldr x1,[x1,sel_new@PAGEOFF]
	b _objc_msgSend

loadScreenSize:
	sub sp,sp,#32
	stp x29,x30,[sp,#16]
	adrp x0,str_UIScreen@PAGE
	add x0,x0,str_UIScreen@PAGEOFF
	bl _objc_getRequiredClass
	str x0,[sp]
	adrp x0,str_sel_mainScreen@PAGE
	add x0,x0,str_sel_mainScreen@PAGEOFF
	bl _sel_registerName
	mov x1,x0
	ldr x0,[sp]
	bl _objc_msgSend
	str x0,[sp]
	adrp x0,str_sel_bounds@PAGE
	add x0,x0,str_sel_bounds@PAGEOFF
	bl _sel_registerName
	mov x1, x0
	ldr x0, [sp]
	bl _objc_msgSend
	adrp x0,_d.screenSize@PAGE
	add x0,x0,_d.screenSize@PAGEOFF
	stp d2,d3,[x0]
	ldp x29,x30,[sp,#16]
	add sp,sp,#32
	ret

; WARNING: RET: d2, d3; d0, d1 untouched
halfScreen.size:
	mov x0,#0x4000000000000000
	fmov d4,x0
	adrp x0,_d.screenSize@PAGE
	add x0,x0,_d.screenSize@PAGEOFF
	ldp d2,d3,[x0]
	fdiv d2,d2,d4
	fdiv d3,d3,d4
	ret

; args: d0, d1, d2, d3
UIColorWithRGBA:
	adrp x0,class_UIColor@PAGE
	ldr x0,[x0,class_UIColor@PAGEOFF]
	adrp x1,sel_colorWithRGBA@PAGE
	ldr x1,[x1,sel_colorWithRGBA@PAGEOFF]
	b _objc_msgSend

UIColorWhite:
	; https://stackoverflow.com/questions/64608307/how-do-i-move-a-floating-point-constant-into-an-fp-register
	mov x0,#0x3ff0000000000000
	fmov d0, x0
	fmov d1,d0
	fmov d2,d0
	fmov d3,d0
	b UIColorWithRGBA

UIColorRed:
	mov x0,#0x3ff0000000000000
	fmov d0, x0
	fmov d1,#0
	fmov d2,#0
	fmov d3,d0
	b UIColorWithRGBA

UIColorGreen:
	mov x0,#0x3ff0000000000000
	fmov d0,#0
	fmov d1,x0
	fmov d2,#0
	fmov d3,x0
	b UIColorWithRGBA

UIColorBlue:
	mov x0,#0x3ff0000000000000
	fmov d0,#0
	fmov d1,#0
	fmov d2,x0
	fmov d3,x0
	b UIColorWithRGBA
UIColorYellow:
	mov x0,#0x3ff0000000000000
	fmov d0,x0
	fmov d1,x0
	fmov d2,#0
	fmov d3,x0
	b UIColorWithRGBA
UIColorGrey:
	adrp x0,class_UIColor@PAGE
	ldr x0,[x0,class_UIColor@PAGEOFF]
	adrp x1,sel_grayColor@PAGE
	ldr x1,[x1,sel_grayColor@PAGEOFF]
	b _objc_msgSend

; x0: UIView / UIView subclass
; d0-d3: CGRect
initViewWithFrame:
	sub sp,sp,#48
	stp x29,x30,[sp,#32]
	stp d0,d1,[sp]
	stp d2,d3,[sp,#16]
	bl allocObj
	adrp x1,sel_initWithFrame@PAGE
	ldr x1,[x1,sel_initWithFrame@PAGEOFF]
	ldp d0,d1,[sp]
	ldp d2,d3,[sp,#16]
	bl _objc_msgSend
	ldp x29,x30,[sp,#32]
	add sp,sp,#48
	ret

; x0: Selection String
; x1: UIColor
; x2: Action argument (2 reserved, 3 - UIControl)
; x3: ColorIsWhite
; d0-d3: CGRect
makeSelection:
	sub sp,sp,#64
	stp x29,x30,[sp,#48]
	stp x0,x1,[sp]
	stp d2,d3,[sp,#16]
	stp x2,x3,[sp,#32]
	adrp x0,class_UIControl@PAGE
	ldr x0,[x0,class_UIControl@PAGEOFF]
	bl initViewWithFrame
	adrp x1,sel_setBackgroundColor@PAGE
	ldr x1,[x1,sel_setBackgroundColor@PAGEOFF]
	ldr x2,[sp,#8]
	str x0,[sp,#8]
	bl _objc_msgSend
	ldp d2,d3,[sp,#16]
	fmov d0,#0
	fmov d1,#0
	adrp x0,class_UILabel@PAGE
	ldr x0,[x0,class_UILabel@PAGEOFF]
	bl initViewWithFrame
	str x0,[sp,#16]
	ldr x0,[sp,#40]
	ucvtf d0,x0
	fmov d1,d0
	fmov d2,d0
	mov x0,#1
	ucvtf d3,x0
	bl UIColorWithRGBA
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_setTextColor@PAGE
	ldr x1,[x1,sel_setTextColor@PAGEOFF]
	bl _objc_msgSend
	adrp x0,optionSelected@PAGE
	add x0,x0,optionSelected@PAGEOFF
	ldp x1,x2,[sp,#32]
	ldr x3,[sp,#8]
	bl makeUIAction
	mov x2,x0
	adrp x1,sel_addActionForControlEvents@PAGE
	ldr x1,[x1,sel_addActionForControlEvents@PAGEOFF]
	ldr x0,[sp,#8]
	mov x3,#64 ; UIControlEventTouchUpInside
	bl _objc_msgSend
	ldr x0,[sp]
	bl ___CFStringMakeConstantString
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_setText@PAGE
	ldr x1,[x1,sel_setText@PAGEOFF]
	bl _objc_msgSend
	ldr x0,[sp,#16]
	adrp x1,sel_setTextAlignment@PAGE
	ldr x1,[x1,sel_setTextAlignment@PAGEOFF]
	mov x2,#1 ; NSTextAlignmentCenter
	bl _objc_msgSend
	adrp x0,class_UIFont@PAGE
	ldr x0,[x0,class_UIFont@PAGEOFF]
	adrp x1,sel_systemFontOfSizeAndWeight@PAGE
	ldr x1,[x1,sel_systemFontOfSizeAndWeight@PAGEOFF]
	mov x2,#0x4050000000000000
	fmov d0,x2
	adrp x2,_UIFontWeightHeavy@GOTPAGE
	ldr x2,[x2,_UIFontWeightHeavy@GOTPAGEOFF]
	ldr d1,[x2]
	bl _objc_msgSend
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_setFont@PAGE
	ldr x1,[x1,sel_setFont@PAGEOFF]
	bl _objc_msgSend
	ldr x2,[sp,#16]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	ldr x0,[sp,#8]
	bl _objc_msgSend
	ldr x0,[sp,#8]
	ldp x29,x30,[sp,#48]
	add sp,sp,#64
	ret

; Arguments:
; x0 (w0): Letter
; x1: colorIsWhite
; x2: UIControl clicked
optionSelected:
	cmp x0,#0
	b.ne .opts.create
	mov x0,x2
	adrp x1,sel_removeFromSuperview@PAGE
	ldr x1,[x1,sel_removeFromSuperview@PAGEOFF]
	b _objc_msgSend
.opts.create:
	sub sp,sp,#32
	stp x29,x30,[sp,#16]
	strh w1,[sp,#12]
	strh w0,[sp,#8]
	mov x0,x2
	adrp x1,sel_backgroundColor@PAGE
	ldr x1,[x1,sel_backgroundColor@PAGEOFF]
	str x0,[sp]
	bl _objc_msgSend
	fmov d0,#0
	fmov d1,d0
	adrp x1,_d.screenSize@PAGE
	add x1,x1,_d.screenSize@PAGEOFF
	ldp d2,d3,[x1]
	mov x1,x0
	add x0,sp,#8
	ldrh w3,[sp,#12]
	mov x2,#0
	;mov x3,#1
	bl makeSelection
	str x0,[sp,#8]
	ldr x0,[sp]
	adrp x1,sel_superview@PAGE
	ldr x1,[x1,sel_superview@PAGEOFF]
	bl _objc_msgSend
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	ldr x2,[sp,#8]
	bl _objc_msgSend
	ldp x29,x30,[sp,#16]
	add sp,sp,#32
	ret

; Arguments:
; x0: Function address
; x1-x3: Additional pointers
makeUIAction:
	sub sp,sp,#80
	stp x29,x30,[sp,#64]
	; Block: https://clang.llvm.org/docs/Block-ABI-Apple.html
	stp x0,x1,[sp,#32]
	stp x2,x3,[sp,#48]
	adrp x0,__NSConcreteStackBlock@GOTPAGE
	ldr x0,[x0,__NSConcreteStackBlock@GOTPAGEOFF]
	mov x1,#536870912 ; (1<<29) and 0 for reserved
	adrp x2,.makeUIAction.called@PAGE
	add x2,x2,.makeUIAction.called@PAGEOFF
	adrp x3,makeUIAction.blockDescriptor@PAGE
	add x3,x3,makeUIAction.blockDescriptor@PAGEOFF
	stp x0,x1,[sp]
	stp x2,x3,[sp,#16]
	adrp x0,class_UIAction@PAGE
	ldr x0,[x0,class_UIAction@PAGEOFF]
	adrp x1,sel_actionWithHandler@PAGE
	ldr x1,[x1,sel_actionWithHandler@PAGEOFF]
	mov x2, sp
	bl _objc_msgSend
	ldp x29,x30,[sp,#64]
	add sp,sp,#80
	ret
.makeUIAction.called:
	ldp x1,x2, [x0,#48]
	ldp x5,x0, [x0,#32]
	br x5

; Arguments:
; x0: Function address
; x1: Title
; x2: Style
; x3: Additional pointer
; Block: https://clang.llvm.org/docs/Block-ABI-Apple.html
makeUIAlertAction:
	sub sp,sp,#80
	stp x29,x30,[sp,#64]
	stp x0,x3,[sp,#32]
	str x2,[sp,#48]
	mov x0,x1
	bl ___CFStringMakeConstantString
	str x0,[sp,#56]
	ldr x0,[sp,#32]
	cmp x0,#0
	b.ne .makeUIAlertAction.withBlock
	mov x4,#0
	b .makeUIAlertAction.creation
.makeUIAlertAction.withBlock:
	adrp x0,__NSConcreteStackBlock@GOTPAGE
	ldr x0,[x0,__NSConcreteStackBlock@GOTPAGEOFF]
	mov x1,#536870912 ; (1<<29), 0
	adrp x2,.makeUIAlertAction.called@PAGE
	add x2,x2,.makeUIAlertAction.called@PAGEOFF
	adrp x3,makeUIAlertAction.blockDescriptor@PAGE
	add x3,x3,makeUIAlertAction.blockDescriptor@PAGEOFF
	stp x0,x1,[sp]
	stp x2,x3,[sp,#16]
	mov x4, sp
.makeUIAlertAction.creation:
	adrp x0,class_UIAlertAction@PAGE
	ldr x0,[x0,class_UIAlertAction@PAGEOFF]
	adrp x1,sel_actionWithTitleEtc@PAGE
	ldr x1,[x1,sel_actionWithTitleEtc@PAGEOFF]
	ldr x2,[sp,#56]
	ldr x3,[sp,#48]
	bl _objc_msgSend
	ldp x29,x30,[sp,#64]
	add sp,sp,#80
	ret
.makeUIAlertAction.called:
	ldp x5,x4, [x0,#32]
	mov x0,x1
	mov x1,x4
	br x5

showCredit:
	sub sp,sp,#32
	stp x29,x30,[sp,#16]
	adrp x0,credit_title_str@PAGE
	add x0,x0,credit_title_str@PAGEOFF
	bl ___CFStringMakeConstantString
	str x0,[sp]
	adrp x0,credit_desc_str@PAGE
	add x0,x0,credit_desc_str@PAGEOFF
	bl ___CFStringMakeConstantString
	mov x3,x0
	adrp x0,class_UIAlertController@PAGE
	ldr x0,[x0,class_UIAlertController@PAGEOFF]
	adrp x1,sel_alertControllerCreate@PAGE
	ldr x1,[x1,sel_alertControllerCreate@PAGEOFF]
	ldr x2,[sp]
	mov x4,#1
	bl _objc_msgSend
	str x0,[sp]
	adrp x0,.showCredit.show_src@PAGE
	add x0,x0,.showCredit.show_src@PAGEOFF
	adrp x1,credit_src_str@PAGE
	add x1,x1,credit_src_str@PAGEOFF
	mov x2,#0 ; UIAlertActionStyleDefault
	mov x3,#0
	bl makeUIAlertAction
	mov x2,x0
	ldr x0,[sp]
	adrp x1,sel_addAction@PAGE
	ldr x1,[x1,sel_addAction@PAGEOFF]
	bl _objc_msgSend
	mov w1,#0x4b4f
	str w1,[sp,#8]
	mov x0,#0
	add x1,sp,#8
	mov x2,#0 ; UIAlertStyleDefault
	; mov x3, #0 ; not required
	bl makeUIAlertAction
	mov x2,x0
	ldr x0,[sp]
	adrp x1,sel_addAction@PAGE
	ldr x1,[x1,sel_addAction@PAGEOFF]
	bl _objc_msgSend
	adrp x0,var_mainViewController@PAGE
	ldr x0,[x0,var_mainViewController@PAGEOFF]
	adrp x1,sel_presentViewControllerEtc@PAGE
	ldr x1,[x1,sel_presentViewControllerEtc@PAGEOFF]
	ldr x2,[sp]
	mov x3,#1 ; YES
	mov x4,#0
	bl _objc_msgSend
	ldp x29,x30,[sp,#16]
	add sp,sp,#32
	ret
.showCredit.show_src:
	sub sp,sp,#32
	stp x29,x30,[sp,#16]
	adrp x0,credit_src_link_str@PAGE
	add x0,x0,credit_src_link_str@PAGEOFF
	bl ___CFStringMakeConstantString
	mov x2,x0
	adrp x0,class_NSURL@PAGE
	ldr x0,[x0,class_NSURL@PAGEOFF]
	adrp x1,sel_URLWithString@PAGE
	ldr x1,[x1,sel_URLWithString@PAGEOFF]
	bl _objc_msgSend
	str x0,[sp]
	adrp x0,class_UIApplication@PAGE
	ldr x0,[x0,class_UIApplication@PAGEOFF]
	adrp x1,sel_sharedApplication@PAGE
	ldr x1,[x1,sel_sharedApplication@PAGEOFF]
	bl _objc_msgSend
	adrp x1,sel_openURLndEtc@PAGE
	ldr x1,[x1,sel_openURLndEtc@PAGEOFF]
	ldr x2,[sp]
	mov x3, #0
	mov x4, #0
	bl _objc_msgSend
	ldp x29,x30,[sp,#16]
	add sp,sp,#32
	ret

func_loadView:
	sub sp,sp,#48
	stp x29,x30,[sp,#32]
	str x1,[sp]
	; make objc_super structure on sp,#8
	str x0,[sp,#8]
	bl _object_getClass
	bl _class_getSuperclass
	str x0,[sp,#16]
	add x0,sp,#8
	ldr x1,[sp]
	bl _objc_msgSendSuper ; [super loadView]
	adrp x0,str_sel_view@PAGE
	add x0,x0,str_sel_view@PAGEOFF
	bl _sel_registerName
	mov x1,x0
	ldr x0,[sp,#8]
	bl _objc_msgSend
	str x0,[sp,#16]
	bl UIColorWhite
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_setBackgroundColor@PAGE
	ldr x1,[x1,sel_setBackgroundColor@PAGEOFF]
	bl _objc_msgSend
	
	mov w0,#0x0041 ; 'A'
	strh w0,[sp,#24]
	bl UIColorRed
	mov x1,x0 ; halfScreenSize only modifies x0
	bl halfScreen.size
	fmov d0,#0
	fmov d1,#0
	add x0,sp,#24
	ldrh w2,[x0]
	mov x3,#1
	bl makeSelection
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	bl _objc_msgSend
	
	mov w0,#0x0042 ; 'B'
	strh w0,[sp,#24]
	bl UIColorGreen
	mov x1,x0
	bl halfScreen.size
	fmov d0,d2
	fmov d1,#0
	add x0,sp,#24
	ldrh w2,[x0]
	mov x3,#0
	bl makeSelection
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	bl _objc_msgSend
	
	mov w0,#0x0043 ; 'C'
	strh w0,[sp,#24]
	bl UIColorYellow
	mov x1,x0
	bl halfScreen.size
	fmov d0,#0
	fmov d1,d3
	add x0,sp,#24
	ldrh w2,[x0]
	mov x3,#0
	bl makeSelection
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	bl _objc_msgSend
	
	mov w0,#0x0044 ; 'D'
	strh w0,[sp,#24]
	bl UIColorBlue
	mov x1,x0
	bl halfScreen.size
	fmov d0,d2
	fmov d1,d3
	add x0,sp,#24
	ldrh w2,[x0]
	mov x3,#1
	bl makeSelection
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	bl _objc_msgSend
	
	mov w0,#63 ; '?'
	strh w0,[sp,#24]
	bl UIColorGrey
	mov x1,x0
	bl halfScreen.size
	fmov d0,d2
	fmov d1,d3
	mov x0,#64
	ucvtf d4,x0
	fsub d0,d2,d4
	fsub d1,d3,d4
	fadd d2,d4,d4
	fadd d3,d4,d4
	add x0,sp,#24
	ldrh w2,[x0]
	mov x3,#1
	bl makeSelection
	mov x2,x0
	ldr x0,[sp,#16]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	bl _objc_msgSend
	
	adrp x0,class_UIButton@PAGE
	ldr x0,[x0,class_UIButton@PAGEOFF]
	adrp x1,sel_buttonWithType@PAGE
	ldr x1,[x1,sel_buttonWithType@PAGEOFF]
	mov x2,#4 ; UIButtonTypeInfoDark
	bl _objc_msgSend
	str x0,[sp]
	adrp x0,class_UIColor@PAGE
	ldr x0,[x0,class_UIColor@PAGEOFF]
	adrp x1,sel_blackColor@PAGE
	ldr x1,[x1,sel_blackColor@PAGEOFF]
	bl _objc_msgSend
	mov x2,x0
	;ldr x0,[sp]
	;adrp x1,sel_setTitleColorForState@PAGE
	;ldr x1,[x1,sel_setTitleColorForState@PAGEOFF]
	;mov x3,#0 ; UIControlStateNormal
	;bl _objc_msgSend
	ldr x0,[sp]
	adrp x1,_d.screenSize@PAGE
	ldr d0,[x1, _d.screenSize@PAGEOFF]
	mov x1,#32
	ucvtf d1,x1
	fsub d0,d0,d1
	fsub d0,d0,d1 ; -2*32
	fmov d2,d1
	fmov d3,d1
	adrp x1,sel_setFrame@PAGE
	ldr x1,[x1,sel_setFrame@PAGEOFF]
	bl _objc_msgSend
	adrp x0,showCredit@PAGE
	add x0,x0,showCredit@PAGEOFF
	mov x1,#0
	mov x2,#0
	mov x3,#0
	bl makeUIAction
	mov x2,x0
	adrp x1,sel_addActionForControlEvents@PAGE
	ldr x1,[x1,sel_addActionForControlEvents@PAGEOFF]
	ldr x0,[sp]
	mov x3,#64 ; UIControlEventTouchUpInside
	bl _objc_msgSend
	ldr x2,[sp]
	adrp x1,sel_addSubview@PAGE
	ldr x1,[x1,sel_addSubview@PAGEOFF]
	ldr x0,[sp,#16]
	bl _objc_msgSend
	
	ldp x29,x30,[sp,#32]
	add sp,sp,#48
	ret

abort.jump:
	b _abort

func.retYES:
	mov x0,#1
	ret

abcdFinishLaunching.func:
	sub sp, sp, #32
	stp x29,x30,[sp,#16]
	bl loadScreenSize
	adrp x0, class_UIWindow@PAGE
	ldr x0,[x0,class_UIWindow@PAGEOFF]
	bl initViewWithFrame
	str x0,[sp]
	adrp x0,str_UIViewController@PAGE
	add x0,x0,str_UIViewController@PAGEOFF
	bl _objc_getRequiredClass
	adrp x1,str_ABCDViewController@PAGE
	add x1,x1,str_ABCDViewController@PAGEOFF
	mov x2,#0
	bl _objc_allocateClassPair
	str x0,[sp,#8]
	adrp x0,str_sel_loadView@PAGE
	add x0,x0,str_sel_loadView@PAGEOFF
	bl _sel_registerName
	mov x1,x0
	ldr x0,[sp,#8]
	adrp x2,str_voidType@PAGE
	add x3,x2,str_voidType@PAGEOFF
	adrp x2,func_loadView@PAGE
	add x2,x2,func_loadView@PAGEOFF
	bl _class_addMethod
	cmp x0,#0
	b.eq abort.jump
	ldr x0,[sp,#8]
	adrp x3,str_boolType@PAGE
	add x3,x3,str_boolType@PAGEOFF
	adrp x2,func.retYES@PAGE
	add x2,x2,func.retYES@PAGEOFF
	adrp x1,sel_prefersStatusBarHidden@PAGE
	ldr x1,[x1,sel_prefersStatusBarHidden@PAGEOFF]
	bl _class_addMethod
	ldr x0,[sp,#8]
	bl _objc_registerClassPair
	ldr x0,[sp,#8]
	bl newObj
	adrp x1,var_mainViewController@PAGE
	str x0,[x1,var_mainViewController@PAGEOFF]
	str x0,[sp,#8]
	adrp x0,str_sel_setRootViewController@PAGE
	add x0,x0,str_sel_setRootViewController@PAGEOFF
	bl _sel_registerName
	mov x1,x0
	ldr x0,[sp]
	ldr x2,[sp,#8]
	bl _objc_msgSend
	adrp x0,str_sel_makeKeyAndVisible@PAGE
	add x0,x0,str_sel_makeKeyAndVisible@PAGEOFF
	bl _sel_registerName
	mov x1,x0
	ldr x0,[sp]
	bl _objc_msgSend
	ldp x29,x30,[sp,#16]
	add sp, sp, #32
	mov x0,#1 ;YES
	ret

_main:
	sub sp, sp, #64
	stp x29, x30, [sp,#48]
	add x29, sp, #16
	stp x0, x1, [sp, #8]
	adrp x0, str_UIResponder@PAGE
	add x0, x0, str_UIResponder@PAGEOFF
	bl _objc_getRequiredClass
	adrp x1, abcdDelegateClassName@PAGE
	add x1, x1, abcdDelegateClassName@PAGEOFF
	mov x2, 0
	bl _objc_allocateClassPair
	str x0, [sp]
	adrp x0, abcdFinishLaunching@PAGE
	add x0, x0, abcdFinishLaunching@PAGEOFF
	bl _sel_registerName
	adrp x3, abcdFinishLaunching.types@PAGE
	add x3, x3, abcdFinishLaunching.types@PAGEOFF
	mov x1, x0
	ldr x0, [sp]
	adrp x2, abcdFinishLaunching.func@PAGE
	add x2, x2, abcdFinishLaunching.func@PAGEOFF
	bl _class_addMethod
	cmp x0, #0
	b.eq abort.jump
	bl init_sels
	ldr x0, [sp]
	bl _objc_registerClassPair
	ldr x0, [sp]
	bl _NSStringFromClass
	mov x3, x0
	ldp x0, x1, [sp, #8]
	mov x2, #0
	b _UIApplicationMain
	;ldp x29, x30, [sp,#48]
	;add sp,sp,#64
	;ret
	

.section __TEXT,__cstring,cstring_literals
str_UIResponder:
	.asciz "UIResponder"
str_UIWindow:
	.asciz "UIWindow"
str_UIScreen:
	.asciz "UIScreen"
str_UIViewController:
	.asciz "UIViewController"
str_ABCDViewController:
	.asciz "ABCDMainUIViewController"
str_UIControl:
	.asciz "UIControl"

abcdDelegateClassName:
	.asciz "ABCDAppDelegate"
abcdFinishLaunching.types:
	.asciz "v@:@@"
str_sel_loadView:
	.asciz "loadView"
str_sel_view:
	.asciz "view"
str_voidType:
	.asciz "v@:"
str_boolType:
	.asciz "c@:"

;.section __TEXT,__objc_methname,cstring_literals
str_sel_initWithFrame:
	.asciz "initWithFrame:"
str_sel_mainScreen:
	.asciz "mainScreen"
str_sel_bounds:
	.asciz "bounds"
str_sel_setRootViewController:
	.asciz "setRootViewController:"
str_sel_makeKeyAndVisible:
	.asciz "makeKeyAndVisible"
abcdFinishLaunching:
	.asciz "application:didFinishLaunchingWithOptions:"
credit_title_str:
	.asciz "Credit"
credit_desc_str:
	.ascii "ABCD Card App Replicate\n"
	.ascii "Written in pure arm64 assembly\n"
	.ascii "Author: GitHub @LNSSPsd\n"
	.ascii "Original idea from ABCD Cards App\n"
	.asciz "available on App Store."
credit_src_str:
	.asciz "Source Code"
credit_src_link_str:
	.asciz "https://github.com/LNSSPsd/ABCD-Cards-arm64-asm"
.p2align 3
makeUIAction.blockDescriptor:
	.quad 0
	.quad 64
makeUIAlertAction.blockDescriptor:
	.quad 0
	.quad 48

.section __DATA,__common
_d.screenSize:
	.quad 0
	.quad 0
var_mainViewController:
	.quad 0
.sel_begin:
sel_release:
	.quad 0
sel_retain:
	.quad 0
sel_alloc:
	.quad 0
sel_init:
	.quad 0
sel_new:
	.quad 0
sel_initWithFrame:
	.quad 0
sel_colorWithRGBA:
	.quad 0
sel_setBackgroundColor:
	.quad 0
sel_setText:
	.quad 0
sel_setTextAlignment:
	.quad 0
sel_systemFontOfSizeAndWeight:
	.quad 0
sel_setFont:
	.quad 0
sel_addSubview:
	.quad 0
sel_actionWithHandler:
	.quad 0
sel_addActionForControlEvents:
	.quad 0
sel_superview:
	.quad 0
sel_removeFromSuperview:
	.quad 0
sel_backgroundColor:
	.quad 0
sel_buttonWithType:
	.quad 0
sel_setTitleColorForState:
	.quad 0
sel_setFrame:
	.quad 0
sel_alertControllerCreate:
	.quad 0
sel_actionWithTitleEtc:
	.quad 0
sel_addAction:
	.quad 0
sel_presentViewControllerEtc:
	.quad 0
sel_URLWithString:
	.quad 0
sel_openURLndEtc:
	.quad 0
sel_sharedApplication:
	.quad 0
sel_grayColor:
	.quad 0
sel_blackColor:
	.quad 0
sel_prefersStatusBarHidden:
	.quad 0
sel_setTextColor:
	.quad 0
.clsd_begin:
class_UIColor:
	.quad 0
class_UIControl:
	.quad 0
class_UILabel:
	.quad 0
class_UIFont:
	.quad 0
class_UIWindow:
	.quad 0
class_UIAction:
	.quad 0
class_UIButton:
	.quad 0
class_UIAlertController:
	.quad 0
class_UIAlertAction:
	.quad 0
class_NSURL:
	.quad 0
class_UIApplication:
	.quad 0
.clsd_end:
	.quad 0

.section __TEXT,__cstring,cstring_literals
str_init_ptr:
	.asciz "release"
	.asciz "retain"
	.asciz "alloc"
	.asciz "init"
	.asciz "new"
	.asciz "initWithFrame:"
	;.asciz "mainScreen"
	;.asciz "bounds"
	;.asciz "setRootViewController:"
	;.asciz "makeKeyAndVisible"
	;.asciz "application:didFinishLaunchingWithOptions:"
	.asciz "colorWithRed:green:blue:alpha:"
	.asciz "setBackgroundColor:"
	.asciz "setText:"
	.asciz "setTextAlignment:"
	.asciz "systemFontOfSize:weight:"
	.asciz "setFont:"
	.asciz "addSubview:"
	.asciz "actionWithHandler:"
	.asciz "addAction:forControlEvents:"
	.asciz "superview"
	.asciz "removeFromSuperview"
	.asciz "backgroundColor"
	.asciz "buttonWithType:"
	.asciz "setTitleColor:forState:"
	.asciz "setFrame:"
	.asciz "alertControllerWithTitle:message:preferredStyle:"
	.asciz "actionWithTitle:style:handler:"
	.asciz "addAction:"
	.asciz "presentViewController:animated:completion:"
	.asciz "URLWithString:"
	.asciz "openURL:options:completionHandler:"
	.asciz "sharedApplication"
	.asciz "grayColor"
	.asciz "blackColor"
	.asciz "prefersStatusBarHidden"
	.asciz "setTextColor:"
	.asciz "UIColor"
	.asciz "UIControl"
	.asciz "UILabel"
	.asciz "UIFont"
	.asciz "UIWindow"
	.asciz "UIAction"
	.asciz "UIButton"
	.asciz "UIAlertController"
	.asciz "UIAlertAction"
	.asciz "NSURL"
	.asciz "UIApplication"

