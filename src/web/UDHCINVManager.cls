/// 发票业务管理类
Class web.UDHCINVManager Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CheckINVBuyInfo(PreNoABC As %String, INVType As %String, BegINVNo As %String, EndINVNo As %String) As %String
{
	;w ##class(web.UDHCINVManager).CheckINVBuyInfo(PreNoABC, INVType, BegINVNo, EndINVNo)
	;w ##class(web.UDHCINVManager).CheckINVBuyInfo("", "O", "00000001", "00001000")
	s myFindFlag=0
	s myrtn=0
	;1 关联发票类型验证
	
	i INVType="O" d
	.
	
	s myCheckVal=..CheckINVBuy(PreNoABC, INVType, BegINVNo, EndINVNo)
	s myrtn=+myCheckVal
	s myFindFlag=$p(myCheckVal,"^",2)
	
	q:(+myrtn) myrtn_"^"_myFindFlag
	
	q myrtn_"^"_myFindFlag
}

/// 购入验证
ClassMethod CheckReceiptBuyInfo(PreNoABC As %String, INVType As %String, BegINVNo As %String, EndINVNo As %String) As %String
{
	;w ##class(web.UDHCINVManager).CheckINVBuy(PreNoABC, INVType, BegINVNo, EndINVNo)
	;
	;2 本发票类型验证
	;INVType
	;BegINVNo
	;EndINVNo
	;PreNoABC
	;
	s myrtn=0
	
	s myFindFlag=0	;=1 qq
	
	q:(INVType="") -500
	
	q:(BegINVNo="")!(EndINVNo="") -501
	q:(+BegINVNo>+EndINVNo) -503
	
	s myBegLen = +$l(BegINVNo)
	s myEndLen = +$l(EndINVNo)
	
	q:(+myBegLen'=myEndLen) -502
	s mySecRtn=""
	
	;^DHCAMTMAGi(0,"BINVABC",{finac_loc},{finac_title},$l({finac_stnum}),{finac_stnum}{finac_rowid})
	;^DHCAMTMAGi(0,"BINV",{finac_loc},$l({finac_stnum}),{finac_stnum},{finac_rowid})
	i (PreNoABC=""){
		;^DHCAMTMAGi(0,"BINV",{finac_loc},$l({finac_stnum}),{finac_stnum},{finac_rowid})
		s myStINVNo=""
		f  s myStINVNo=$o(^DHCSFBUY(0,"BeginNo",INVType, myBegLen, myStINVNo)) q:(myStINVNo="")!(+myStINVNo>+EndINVNo)!(+myFindFlag'=0)  d
		.s myINVRowID=0
		.f  s myINVRowID=$o(^DHCSFBUY(0,"BeginNo",INVType, myBegLen, myStINVNo, myINVRowID))  q:((myINVRowID="")!(+myFindFlag'=0))  d
		..s myEndINVNo=$p(^DHCSFBUY(myINVRowID), "^",4)
		..s myPreNoABC=$p(^DHCSFBUY(myINVRowID), "^",11)
		..q:(PreNoABC'=myPreNoABC)
		..q:(myEndINVNo="")
		..s mySecRtn=..SectionAggregateCal(myStINVNo, myEndINVNo,BegINVNo, EndINVNo)
		..i mySecRtn'="" d
		...s myFindFlag=1
		..s FirstNo=myStINVNo
		..s EndNo=myEndINVNo
		..i ((BegINVNo<FirstNo)&(EndINVNo>EndNo)) d
		...s myFindFlag=1
		
	}else{
		;^DHCAMTMAGi(0,"BINVABC",{finac_loc},{finac_title},$l({finac_stnum}),{finac_stnum}{finac_rowid})
		s myStINVNo=""
		f  s myStINVNo=$o(^DHCSFBUY(0,"BeginABC",INVType, PreNoABC, myBegLen, myStINVNo)) q:(myStINVNo="")!(+myStINVNo>+EndINVNo)!(+myFindFlag'=0)  d
		.s myINVRowID=0
		.f  s myINVRowID=$o(^DHCSFBUY(0,"BeginABC",INVType, PreNoABC, myBegLen, myStINVNo, myINVRowID))  q:((myINVRowID="")!(+myFindFlag'=0))  d
		..s myEndINVNo=$p(^DHCSFBUY(myINVRowID), "^",4)
		..q:(myEndINVNo="")
		..s mySecRtn=..SectionAggregateCal(myStINVNo, myEndINVNo,BegINVNo, EndINVNo)	
		..i mySecRtn'="" d
		...s myFindFlag=1
		..s FirstNo=myStINVNo
		..s EndNo=myEndINVNo
		..i ((BegINVNo<FirstNo)&(EndINVNo>EndNo)) d
		...s myFindFlag=1
	}
	
	q myrtn_"^"_myFindFlag
}

/// 验证发票的购入验证
ClassMethod CheckINVBuy(PreNoABC As %String, INVType As %String, BegINVNo As %String, EndINVNo As %String) As %String
{
	;w ##class(web.UDHCINVManager).CheckINVBuy(PreNoABC, INVType, BegINVNo, EndINVNo)
	;
	;2 本发票类型验证
	;INVType
	;BegINVNo
	;EndINVNo
	;PreNoABC
	;
	s myrtn=0
	
	s myFindFlag=0	;=1 qq
	
	q:(INVType="") -500
	
	q:(BegINVNo="")!(EndINVNo="") -501
	q:(+BegINVNo>+EndINVNo) -503
	
	s myBegLen = +$l(BegINVNo)
	s myEndLen = +$l(EndINVNo)
	
	q:(+myBegLen'=myEndLen) -502
	s mySecRtn=""
	
	;^DHCAMTMAGi(0,"BINVABC",{finac_loc},{finac_title},$l({finac_stnum}),{finac_stnum}{finac_rowid})
	;^DHCAMTMAGi(0,"BINV",{finac_loc},$l({finac_stnum}),{finac_stnum},{finac_rowid})
	i (PreNoABC=""){
		;^DHCAMTMAGi(0,"BINV",{finac_loc},$l({finac_stnum}),{finac_stnum},{finac_rowid})
		s myStINVNo=""
		f  s myStINVNo=$o(^DHCAMTMAGi(0,"BINV",INVType, myBegLen, myStINVNo)) q:(myStINVNo="")!(+myStINVNo>+EndINVNo)!(+myFindFlag'=0)  d
		.s myINVRowID=0
		.f  s myINVRowID=$o(^DHCAMTMAGi(0,"BINV",INVType, myBegLen, myStINVNo, myINVRowID))  q:((myINVRowID="")!(+myFindFlag'=0))  d
		..s myEndINVNo=$p(^DHCAMTMAG(myINVRowID), "^",6)
		..s myPreNoABC=$p(^DHCAMTMAG(myINVRowID), "^",13)
		..S ^FHQAB=PreNoABC_"^"_myPreNoABC
		..q:(PreNoABC'=myPreNoABC)
		..q:(myEndINVNo="")
		..s mySecRtn=..SectionAggregateCal(myStINVNo, myEndINVNo,BegINVNo, EndINVNo)
		..S ^FHQAA=mySecRtn
		..i mySecRtn'="" d
		...s myFindFlag=1
		..
	}else{
		;^DHCAMTMAGi(0,"BINVABC",{finac_loc},{finac_title},$l({finac_stnum}),{finac_stnum}{finac_rowid})
		s myStINVNo=""
		f  s myStINVNo=$o(^DHCAMTMAGi(0,"BINVABC",INVType, PreNoABC, myBegLen, myStINVNo)) q:(myStINVNo="")!(+myStINVNo>+EndINVNo)!(+myFindFlag'=0)  d
		.s myINVRowID=0
		.f  s myINVRowID=$o(^DHCAMTMAGi(0,"BINVABC",INVType, PreNoABC, myBegLen, myStINVNo, myINVRowID))  q:((myINVRowID="")!(+myFindFlag'=0))  d
		..s myEndINVNo=$p(^DHCAMTMAG(myINVRowID), "^",6)
		..q:(myEndINVNo="")
		..s mySecRtn=..SectionAggregateCal(myStINVNo, myEndINVNo,BegINVNo, EndINVNo)
		
		..i mySecRtn'="" d
		...s myFindFlag=1
		
	}
	
	q myrtn_"^"_myFindFlag
}

ClassMethod CheckINVDispenseInfo(PreNoABC As %String, INVType As %String, BegINVNo As %String, EndINVNo As %String) As %String
{
	;w ##class(web.UDHCINVManager).CheckINVDispenseInfo(PreNoABC, INVType, BegINVNo, EndINVNo)
	;w ##class(web.UDHCINVManager).CheckINVDispenseInfo("12", "O", 2001, 9999)

	s myFindFlag=0
	s myrtn=0
	
	;1 关联发票类型验证
	
	i INVType="O" d
	.
	
	s myCheckVal=..CheckINVDispense(PreNoABC, INVType, BegINVNo, EndINVNo)
	
	s myrtn=+myCheckVal
	s myFindFlag=$p(myCheckVal,"^",2)
	
	q:(+myrtn) myrtn_"^"_myFindFlag
	
	q myrtn_"^"_myFindFlag
}

/// 发票的发放检测
ClassMethod CheckINVDispense(PreNoABC As %String, INVType As %String, BegINVNo As %String, EndINVNo As %String) As %String
{
	;w ##class(web.UDHCINVManager).CheckINVDispense(PreNoABC, INVType, BegINVNo, EndINVNo)
	;w ##class(web.UDHCINVManager).CheckINVDispense("12", "O", 2001, 9999)
	s myrtn=0
	
	s myFindFlag=0	;=1 qq
	
	q:(INVType="") -500
	
	q:(BegINVNo="")!(EndINVNo="") -501
	q:(+BegINVNo>+EndINVNo) -503
	
	s myBegLen = +$l(BegINVNo)
	s myEndLen = +$l(EndINVNo)
	
	q:(+myBegLen'=myEndLen) -502
	s mySecRtn=""
	
	;
	;
	i (PreNoABC=""){
		;^DHCAMTMAGi(0,"BINV",{finac_loc},$l({finac_stnum}),{finac_stnum},{finac_rowid})
		s myStINVNo=""
		f  s myStINVNo=$o(^DHCINVOICEi(0,"BINV",INVType, myBegLen, myStINVNo)) q:(myStINVNo="")!(+myStINVNo>+EndINVNo)!(+myFindFlag'=0)  d
		.s myINVRowID=0
		.f  s myINVRowID=$o(^DHCINVOICEi(0,"BINV",INVType, myBegLen, myStINVNo, myINVRowID))  q:((myINVRowID="")!(+myFindFlag'=0))  d
		..s myEndINVNo=$p(^DHCINVOICE(myINVRowID), "^",2)
		..s myPreNoABC=$p(^DHCINVOICE(myINVRowID), "^",16)
		..S ^FHQAB=PreNoABC_"^"_myPreNoABC
		..q:(PreNoABC'=myPreNoABC)
		..q:(myEndINVNo="") 
		..S RetFlag=$p(^DHCINVOICE(myINVRowID), "^",22)
		..if RetFlag="Y" s myEndINVNo1=$p(^DHCINVOICE(myINVRowID), "^",6)
		..if $g(myEndINVNo1)'="" s myEndINVNo=myEndINVNo1-1
		..s mySecRtn=..SectionAggregateCal(myStINVNo, myEndINVNo,BegINVNo, EndINVNo)
		..S ^FHQAA=mySecRtn
		..i mySecRtn'="" d
		...s myFindFlag=1
		..
	}else{
		;^DHCAMTMAGi(0,"BINVABC",{finac_loc},{finac_title},$l({finac_stnum}),{finac_stnum}{finac_rowid})
		s myStINVNo=""
		f  s myStINVNo=$o(^DHCINVOICEi(0,"BINVABC",INVType, PreNoABC, myBegLen, myStINVNo)) q:(myStINVNo="")!(+myStINVNo>+EndINVNo)!(+myFindFlag'=0)  d
		.s myINVRowID=0
		.f  s myINVRowID=$o(^DHCINVOICEi(0,"BINVABC",INVType, PreNoABC, myBegLen, myStINVNo, myINVRowID))  q:((myINVRowID="")!(+myFindFlag'=0))  d
		..s myEndINVNo=$p(^DHCINVOICE(myINVRowID), "^",2)
		..q:(myEndINVNo="")
		..S RetFlag=$p(^DHCINVOICE(myINVRowID), "^",22)
		..if RetFlag="Y" s myEndINVNo1=$p(^DHCINVOICE(myINVRowID), "^",6)
		..if $g(myEndINVNo1)'="" s myEndINVNo=myEndINVNo1-1
		..s mySecRtn=..SectionAggregateCal(myStINVNo, myEndINVNo,BegINVNo, EndINVNo)
		..S ^FHQAA1=mySecRtn
		..i mySecRtn'="" d
		...s myFindFlag=1
		
	}
	
	q myrtn_"^"_myFindFlag
}

ClassMethod SectionAggregateCal(ReferenceBegNo As %String, ReferenceEndNo As %String, TargetBegNo As %String, TargetEndNo As %String) As %String
{
   
	;w ##class(web.UDHCINVManager).SectionAggregateCal("0001","0100","0010","0012")
	;直线区域 关系
	;ReferenceBegNo		参照点
	;ReferenceEndNo		参照点
	;TargetBegNo		目标
	;TargetEndNo
	;某个 目标 集合 与参照集合的关系
	s myrtn=""
	;InterSection
	;R
	;L
	s myInBegNode=0
	s myInEndNode=0
	;641745001^641750000^641746963^641747062 
	;目标开始号码是否在参考段内
	i (+ReferenceBegNo <= +TargetBegNo)&(+ReferenceEndNo>=+TargetBegNo){
		s myInBegNode=1
	}
	;目标结束号码是否在参考段内
	if (+ReferenceBegNo <= +TargetEndNo)&(+ReferenceEndNo>=+TargetEndNo){
		s myInEndNode=1
	}
	
	if (+myInBegNode=1)&(+myInEndNode=1){
		s myrtn="I"
	}elseif(+myInBegNode=1){
		s myrtn="L"
	}elseif(+myInEndNode=1){
		s myrtn="R"
	}else{
	}
	;add by wangjian 2015-01-07 反查目标发票段是否包含参考段
	s myInBegBackNode=0
	s myInEndBackNode=0
	;参考开始号码是否在目标发票段内
	i (+TargetBegNo <= +ReferenceBegNo)&(+TargetEndNo>=+ReferenceBegNo){
		s myInBegBackNode=1
	}
	;参考结束号码是否在目标发票段内
	if (+TargetBegNo <= +ReferenceEndNo)&(+TargetEndNo>=+ReferenceEndNo){
		s myInEndBackNode=1
	}
	if (+myInBegBackNode=1)&(+myInEndBackNode=1){
		s myrtn="BI"
	}elseif(+myInBegBackNode=1){
		s myrtn="BL"
	}elseif(+myInEndBackNode=1){
		s myrtn="BR"
	}else{
	}
	;end
	
	
	
	q myrtn
}

ClassMethod INVTEST()
{
	;d ##class(web.UDHCINVManager).INVTEST()
	;s myobj=##class(User.DHCINVOICE).%OpenId(2)
	;d myobj.%Save()
	;000001	000010
	;000005	00009
	w ##class(web.UDHCINVManager).CheckINVDispense("", "I", "000001", "000012")
}

}
