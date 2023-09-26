Class web.DHCFFHQ Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod AddData(FileName As %String = "", ClassName As %String, ChangeType As %String) As %String
{
 k ^PAPER,^PAPERi,^DHCCARD("CF"),^DHCCARDi("CF"),^mdata("DHCCARDREF")
 s CircleNum=0
 s SUB="Data"
 k ^ErrText,^FHQ
 f  s CircleNum=CircleNum+1 q:(CircleNum>16)  d
 .if CircleNum=1 s FileName="d:\tmp\200610.txt"
 .if CircleNum=2 s FileName="d:\tmp\2006111.txt"
 .if CircleNum=3 s FileName="d:\tmp\2006112.txt"
 .if CircleNum=4 s FileName="d:\tmp\2006121.txt"
 .if CircleNum=5 s FileName="d:\tmp\2006122.txt"
 .if CircleNum=6 s FileName="d:\tmp\200701.txt"
 .if CircleNum=7 s FileName="d:\tmp\200702.txt"
 .if CircleNum=8 s FileName="d:\tmp\200703.txt"
 .if CircleNum=9 s FileName="d:\tmp\200704.txt"
 .if CircleNum=10 s FileName="d:\tmp\200705.txt"
 .if CircleNum=11 s FileName="d:\tmp\200706.txt"
 .if CircleNum=12 s FileName="d:\tmp\200707.txt"
 .if CircleNum=13 s FileName="d:\tmp\200708.txt"
 .if CircleNum=14 s FileName="d:\tmp\200709.txt"
 .if CircleNum=15 s FileName="d:\tmp\2007010.txt"
 .if CircleNum=16 s FileName="d:\tmp\file01.txt"
 .s IND=1
 .w CircleNum," "
	.D FILE^DHCFHQ(FileName,SUB)
	.FOR  S IND=$O(^zTSA("FHQ",SUB,IND)) Q:IND=""  SET TMPSTR=^(IND) DO
	..SET TMPSTR=$TR(TMPSTR," ","")
	..S ErrText=..PatInfo(ChangeType,TMPSTR)
	..if IND#100=0 w "."
	..Q:((ErrText="")!(ErrText="Ok")) 
	..S ^ErrText(CircleNum,IND)=ErrText
	Q ""
}

ClassMethod ArcimAlias(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" k ^ARC("ALIAS"),^ARC("KEYW")
	q:ChangeType="Clear" "数据已清:医嘱项"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
 s ArcCode=$p(RowStr,del,1),Alias=$p(RowStr,del,3)
 q:ArcCode="" ..RetErrorValue(RetStr,"取医嘱针出错:")
 Q:Alias="" ..RetErrorValue(RetStr,"取医嘱针出错:"_ArcCode)
 s ArcimId1=$o(^ARCIM(0,"Code",ArcCode,""))
 q:ArcimId1="" ..RetErrorValue(RetStr,"取医嘱针出错:"_ArcCode)
 s ArcimId2=$o(^ARCIM(0,"Code",ArcCode,ArcimId1,""))
 q:ArcimId2="" ..RetErrorValue(RetStr,"取医嘱针出错:"_ArcCode)
 s OnItsOwn=$p(^ARCIM(ArcimId1,ArcimId2,7),del,13)
 s ArcSubCatDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
 s ArcDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)

 //医嘱别名
 s ArcimId=ArcimId1_"||"_ArcimId2
 i Alias'="" d
 .set I=1
 .s num=$l(Alias,"/")
 .s ALI=""
 .FOR I=1:1:num d
 ..s ALI=$p(Alias,"/",I)
 ..q:$d(^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(ArcDesc)))
 ..if ChangeType'="Test" d
 ...q:$g(ALI)=""
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...k PLIST 
 ...s PLIST(2)=ArcimId,PLIST(5)=ArcDesc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 ...set PLIST(4)=$p(Alias,"/",I)
 ...&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcKeyId=0,CircleFlag=1
 ...f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 ....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 ....if ALI=ArcKey s CircleFlag=0
 ...q:(CircleFlag=0)
 ...k PLIST 
 ...s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_ArcDesc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
 ...set PLIST(4)=ALI_"Z"
 ...&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q RetStr
}

ClassMethod ArcimData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//	1	  2	       3	4	  5      	6	     7	     8	    9	          10	    
	//	
	//编码	收费项	别名   编码	医嘱描述	别名	单价	单位	医嘱大类	医嘱子类
	//11		12			13			14			15			16			17			18	
	//帐单大类	帐单子类	收费大类	收费子类	住院发票	住院核算	门诊发票	门诊核算
	//19		   20			   21		   	22	    	23			24			   25	  	26			  27		 28		29	
	//核算类	核算子类	会计类	会计子类	病案大类	病案子类	开展	独立医嘱	优先级	结果	数量
	//30            31       32
	//医嘱提示信息 设备名称  急诊标示
	if ChangeType="Clear"  d
	.K ^ARCIM,^ARC("ALIAS"),^ARC("KEYW")
	.k ^DHCTARI,^DHCTARIi,^mdata("DHCTARITEM"),^DHCTARAL,^mdata("DHCTARITEMALIAS")
	.k ^DHCOLT,^mdata("DHCORDERLINKTAR"),^DHCTARF,^mdata("DHCTARFACTOR")
	q:ChangeType="Clear" "数据已清:医嘱项"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET TarCode=$P(RowStr,del,1),TarDesc=$P(RowStr,del,2),OrdCode=$P(RowStr,del,4),OrdDesc=$P(RowStr,del,5)
	if ((OrdCode="") & (OrdDesc="")) d
	else  d
	.if OrdCode="" s RetStr=..RetErrorValue(RetStr,"医嘱代码为空:")
 .if OrdDesc="" s RetStr=..RetErrorValue(RetStr,"医嘱名称为空:")
 if ((TarCode="") & (TarDesc="")) d
	else  d
	.if TarCode="" s RetStr=..RetErrorValue(RetStr,"收费项代码为空:")
 .if TarDesc="" s RetStr=..RetErrorValue(RetStr,"收费项名称为空:")
 if (($g(OrdDesc)'="")&($g(OrdCode)'="")) d
 .s:($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_OrdDesc)
 .s:($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode)))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_OrdCode)
 if (($g(TarCode)'="")&($g(TarDesc)'="")) d
 .s:($D(^DHCTARI(0,"Code",TarCode))&('$D(^DHCTARI(0,"Desc",TarDesc)))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
 .s:($D(^DHCTARI(0,"Desc",TarDesc))&('$D(^DHCTARI(0,"Code",TarCode)))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)
 s UserDr=$o(^SSU("SSUSR",0))
 s BaseUom=$p(RowStr,del,8),BaseUomDr="" //基本单位
 if BaseUom="" s RetStr=..RetErrorValue(RetStr,"计价单位为空"_OrdCode) q RetStr
 i BaseUom'=""  d
 .s BaseUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(BaseUom),""))
 if BaseUomDr="" s RetStr=..RetErrorValue(RetStr,"计价单位指针出错"_OrdCode) q RetStr
 s OrdMsg=$P(RowStr,del,30),Equipment=$P(RowStr,del,31)
 s OnItsOwn=$$ALPHAUP^SSUTIL4($p(RowStr,del,26))
	..s:OnItsOwn="" OnItsOwn="Y"
	//医嘱项
	if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
	.if (('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
	..S abbr="1"
	..s ArcCat=$p(RowStr,del,9)
	..s ArcSubCat=$p(RowStr,del,10),ArcSubCatDr=""
	..if ArcSubCat="" s RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_OrdCode) q  
	..;s ArcSubCatTmp=ArcSubCat_ArcCat
	..s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
	..;s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCatTmp),"")) 
	..if ArcSubCatDr="" s RetStr=..RetErrorValue(RetStr,"医嘱子类指针出错:"_OrdCode_","_ArcSubCat) q
	..i ((OnItsOwn'="Y")&(OnItsOwn'="N")) s OnItsOwn="Y"
	..s BillGrp=$p(RowStr,del,11)
	..s:BillGrp="" RetStr=..RetErrorValue(RetStr,"帐单组为空:"_OrdCode)
	..q:BillGrp=""
	..s BillGrpDr=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(BillGrp),"")) 
	..s:BillGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单组指针出错:"_OrdCode_","_BillGrp)
 ..q:BillGrpDr=""
 ..s BillSubGrp=$p(RowStr,del,12)
 ..s:BillSubGrp="" RetStr=..RetErrorValue(RetStr,"帐单子组名称为空:"_OrdCode_","_BillSubGrp)
 ..q:BillSubGrp=""
 ..s BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrp),BillGrpDr,""))
 ..s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_OrdCode_","_BillSubGrp)
 ..q:BillSubGrpDr=""
 ..
	..s BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
	..s Priority=$p(RowStr,del,27)
	..s Priority=$tr(Priority," ","")
	..s:$g(Priority)'="" PrioDr=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),""))
	..if (($g(PrioDr)="")&($g(Priority)'="")) s RetStr=..RetErrorValue(RetStr,"取医嘱优先级指针出错:"_OrdCode)
	..s:$g(PrioDr)="" PrioDr=""
	..s resGrp=$p(RowStr,del,28)
	..s ServiceGroupDr=""
	..if $g(Equipment)'="" d
	...s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ArcCat),""))
	...if $g(ServiceGroupDr)="" s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4("检查"),""))
	..S Sentive=$p(RowStr,del,32)
 ..if ChangeType'="Test" d
 ...k PLIST 
 ...IF $G(Sentive)'="" S PLIST(133)="Y"
 ...if $g(ServiceGroupDr)'="" s PLIST(97)=ServiceGroupDr,PLIST(76)="S"
 ...if ArcCat["材料" s PLIST(76)="M"
 ...s PLIST(2)=OrdCode,PLIST(3)=OrdDesc,PLIST(4)=abbr,PLIST(105)=BaseUomDr
 ...s PLIST(9)=ArcSubCatDr,PLIST(47)=BillSubGrpDr,PLIST(83)=OnItsOwn
 ...s PLIST(113)=PrioDr,PLIST(117)=resGrp
 ...&SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcimId1=$o(^ARCIM(0,"Code",OrdCode,""))
 ...s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
 ...q:ArcimId1=""
 ...s ArcimId2=$o(^ARCIM(0,"Code",OrdCode,ArcimId1,""))
 ...q:ArcimId2=""
 ...s ArcimId=ArcimId1_"||"_ArcimId2
 ...//医嘱提示信息
 ...IF $g(OrdMsg)'="" d 
 ....IF $D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ....IF '$D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",0)=1,^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ...//价格
 ...s Price=$tr($p(RowStr,del,7)," ")
 ...i Price'="" s Price=+Price
 ...else  s RetStr=..RetErrorValue(RetStr,"价格为空")
 ...q:Price=""
 ...if ChangeType'="Test" d
 ....k PLIST
	....s PLIST(0)=ArcimId,PLIST(3)=+$h,PLIST(5)=1,PLIST(6)=Price  ;; PLIST(5)*: ARC_Tariff
 ....&SQL(INSERT INTO SQLUser.ARC_ItemPriceItaly VALUES :PLIST())
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemPriceItaly -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 //医嘱别名
 if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
 .if (($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
 .s Alias=$P(RowStr,del,6)
 .i Alias'="" d
 ..s ArcimId1=$o(^ARCIM(0,"Code",OrdCode,""))
 ..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"别名取医嘱针出错:"_OrdCode)
 ..q:ArcimId1=""
 ..s ArcimId2=$o(^ARCIM(0,"Code",OrdCode,ArcimId1,""))
 ..q:ArcimId2=""
 ..s ArcimId=ArcimId1_"||"_ArcimId2
 ..s ArcCatDr=""
 ..s ArcSubCatDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 ..if $g(ArcSubCatDr) s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
 ..set I=1
 ..s num=$l(Alias,"/")
 ..s ALI=""
 ..FOR I=1:1:num d
 ...s ALI=$p(Alias,"/",I)
 ...q:$g(ALI)=""
 ...;q:$d(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc)))
 ...S AliaId=$o(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc),0))
 ...if $g(AliaId)'="" s ArcimIdTmp=$p(^ARC("ALIAS",AliaId),del,1)
 ...q:(($g(ArcimId)=$g(ArcimIdTmp))&($g(AliaId)'=""))
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...if ChangeType'="Test" d
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 ....set PLIST(4)=ALI
 ....if $g(AliaId)'="" d
 .....&SQL(Update SQLUser.ARC_Alias Set ALIAS_ARCIM_DR=:ArcimId where ALIAS_RowId=:AliaId) 
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ....q:$g(SQLCODE)
 ....s ArcKeyId=0,CircleFlag=1
 ....f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 .....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 .....if ALI=ArcKey s CircleFlag=0,ArcKeyIdTmp=ArcKeyId
 ....;q:(CircleFlag=0)
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
 ....set PLIST(4)=ALI_"Z"
 ....if CircleFlag=0 d
 .....&SQL(Update SQLUser.ARC_ItemKeywords set KEYW_ARCIM_DR=:ArcimId where KEYW_RowId=:ArcKeyIdTmp)
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))


 //医嘱对应设备的服务
 if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(Equipment)'="")) d
 .if (($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($g(Equipment)'="")) d
	..s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc),""))
	..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_OrdDesc)
	..q:ArcimId1=""
	..s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc),ArcimId1,""))
	..s Service=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	..s:Service="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_OrdDesc)
	..q:Service=""
	..s ServiceId=0
	..s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
	..;s:EqId="" RetStr=..RetErrorValue(RetStr,"取设备指针指针出错:"_Equipment)
	..q:EqId=""
	..s CircleFlag=1
	..f  s ServiceId=$o(^RBC("SER",0,"EQ",EqId,ServiceId)) q:((ServiceId="")!(CircleFlag=0))  d
	...s ArcimId=$p(^RBC("SER",ServiceId),del,1)
	...s:(ArcimId=(ArcimId1_"||"_ArcimId2)) CircleFlag=0
	..q:CircleFlag=0
	..if ChangeType'="Test" d
	...k PLIST
	...S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(6)=EqId,PLIST(7)=$g(OrdDesc),PLIST(10)=Service,PLIST(11)="Y",PLIST(13)=$H-1
	...&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
 //收费项目
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .if (('$D(^DHCTARI(0,"Code",TarCode)))&('$D(^DHCTARI(0,"Desc",TarDesc)))) d
	..s TarSubCatDr="",OUTPDR="",INPDR="",EMCDR="",ACCTDR="",ACCTDR="",MRDR=""
	..s TarSubCat=$P(RowStr,del,14)
	..SET INP=$P(RowStr,del,16),OUTP=$P(RowStr,del,18),EMC=$P(RowStr,del,20),ACCT=$P(RowStr,del,22),MR=$P(RowStr,del,24)
	..q:BaseUomDr=""
	..s:TarSubCat="" RetStr=..RetErrorValue(RetStr,"收费子类为空:"_TarCode)
	..;q:TarSubCat=""
	..SET:TarSubCat'="" TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",$$UPPER^SSUTIL4(TarSubCat),""))
	..s:TarSubCatDr="" RetStr=..RetErrorValue(RetStr,"收费子指针出错:"_TarCode_","_TarSubCat)
	..;Q:TarSubCatDr=""
	..if OUTP="" s RetStr=..RetErrorValue(RetStr,"门诊子类为空:"_TarCode) 
	..SET:OUTP'="" OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
	..if OUTPDR="" s RetStr=..RetErrorValue(RetStr,"门诊子类指针出错:"_TarCode_","_OUTP) 
	..if INP="" s RetStr=..RetErrorValue(RetStr,"住院子类为空:"_TarCode) 
	..SET:INP'="" INPDR=$O(^DHCTarC("IC",0,"Desc",INP,"")) 
	..if INPDR="" s RetStr=..RetErrorValue(RetStr,"住院子类指针出错:"_TarCode_","_INP) 
	..if EMC="" s RetStr=..RetErrorValue(RetStr,"核算子类为空:"_TarCode) 
	..SET:EMC'="" EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
	..if EMCDR="" s RetStr=..RetErrorValue(RetStr,"核算子类指针出错:"_TarCode_","_EMC) 
	..if ACCT="" s RetStr=..RetErrorValue(RetStr,"会计科目子类为空:"_TarCode) 
	..SET:ACCT'="" ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
	..if ACCTDR="" s RetStr=..RetErrorValue(RetStr,"会计科目指针出错:"_TarCode_","_ACCT) 
	..
	..if MR="" s RetStr=..RetErrorValue(RetStr,"病案子类为空:"_TarCode) 
	..SET:MR'="" MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
	..if MRDR="" s RetStr=..RetErrorValue(RetStr,"病案指针出错:"_TarCode_","_MRDR) 
	..if ChangeType'="Test" d
	...K PLIST
	...SET PLIST(10)="N",PLIST(11)="Y",PLIST(12)=+$H
	...SET PLIST(2)=TarCode,PLIST(3)=TarDesc,PLIST(4)=BaseUomDr,PLIST(5)=TarSubCatDr,PLIST(6)=ACCTDR,PLIST(7)=OUTPDR
	...SET PLIST(8)=EMCDR,PLIST(9)=MRDR,PLIST(18)=INPDR
	...&SQL(INSERT INTO SQLUser.DHC_TARITEM VALUES :PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s TarId=$o(^DHCTARI(0,"Code",TarCode,""))
 ...if TarId="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项指针出错"_TarCode)
 ...q:TarId=""
 ...set I=1
 ...k PLIST 
 ...s PLIST(2)=TarId,PLIST(3)=TarDesc
 ...s Alias=$p(RowStr,del,3)
 ...if Alias="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项别名空"_TarCode)
 ...FOR  s ALI=$P(Alias,"/",I)  q:ALI=""  D
 ....s ALI=$$ALPHAUP^SSUTIL4(ALI)
 ....set PLIST(4)=ALI
 ....SET I=I+1
 ....s TiaId=0,CircleFlag=1
 ....f  s TiaId=$o(^DHCTARAL("A",TarId,TiaId)) q:((TiaId="")!(CircleFlag=0))  d
 .....s AliaTmp=$p(^DHCTARAL(TiaId),del,3)
 .....if $$ALPHAUP^SSUTIL4(AliaTmp)=$$ALPHAUP^SSUTIL4(ALI) s CircleFlag=0
 ....if ((CircleFlag=1)&(ChangeType'="Test")) d
 .....&SQL(INSERT INTO SQLUser.DHC_TARITEMAlias VALUES :PLIST()) 
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEMAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .....s ^DHCTARAL(0)=^mdata("DHCTARITEMALIAS")
 ...s Price=$tr($p(RowStr,del,7)," ")
 ...s:Price='"" Price=+Price
 ...s:Price="" RetStr=..RetErrorValue(RetStr,"收费项价格为空"_TarCode)
 ...k PLIST 
 ...s PLIST(0)=TarId,PLIST(3)=+$H,PLIST(5)=Price,PLIST(8)=UserDr,PLIST(13)="1"
 ...&SQL(INSERT INTO SQLUser.DHC_TARItemPrice VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARItemPrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱与收费项目对照
	q:(($g(OrdCode)="")&($g(OrdDesc)="")) RetStr
	q:(($g(TarCode)="")&($g(TarDesc)="")) RetStr
	q:(($g(OrdCode)="")!($g(OrdDesc)="")) ..RetErrorValue(RetStr,"医嘱项目名称或代码为空")
	q:(($g(TarCode)="")!($g(TarDesc)="")) ..RetErrorValue(RetStr,"收费项目名称或代码为空")
	if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(TarCode)'="")!($g(TarDesc)'="")) d
	.if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($d(^DHCTARI(0,"Code",TarCode)))) d
	..SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
	..if ArcimId1="" s RetStr=..RetErrorValue(RetStr,"对照时医嘱id出错"_OrdCode)
	..q:ArcimId1=""
	..SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
	..SET TarId=$O(^DHCTARI(0,"Code",TarCode,""))
	..if TarId="" s RetStr=..RetErrorValue(RetStr,"对照时收费项目id出错"_TarCode)
 ..q:TarId="" 
 ..q:$d(^DHCOLT(0,"ARTTA",ArcimId,TarId))
 ..if ChangeType'="Test" d
 ...K PLIST
 ...SET PLIST(2)=ArcimId,PLIST(3)=TarId,PLIST(4)=1,PLIST(5)=+$H-1
 ...&SQL(INSERT INTO SQLUser.DHC_ORDERLINKTAR VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod ArcimDataUp(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//	1	  2	       3	4	  5      	6	     7	     8	    9	          10	    
	//	
	//编码	收费项	别名   编码	医嘱描述	别名	单价	单位	医嘱大类	医嘱子类
	//11		12			13			14			15			16			17			18	
	//帐单大类	帐单子类	收费大类	收费子类	住院发票	住院核算	门诊发票	门诊核算
	//19		   20			   21		   	22	    	23			24			   25	  	26			  27		 28		29	
	//核算类	核算子类	会计类	会计子类	病案大类	病案子类	开展	独立医嘱	优先级	结果	数量
	//30            31       32
	//医嘱提示信息 设备名称  急诊标示

	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET ArcCode=$P(RowStr,del,1),ArcDesc=$P(RowStr,del,2),ArcSubCat=$P(RowStr,del,3)
	q:ArcCode="" ..RetErrorValue(RetStr,"医嘱代码为空:") 
 q:ArcDesc="" ..RetErrorValue(RetStr,"医嘱名称为空:") 
 q:('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode)))) ..RetErrorValue(RetStr,"医嘱项名称不存在:"_ArcDesc)
 q:('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcDesc)))) ..RetErrorValue(RetStr,"医嘱项代码不存在:"_ArcCode)
 s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),""))
 q:$g(ArcimId1)="" ..RetErrorValue(RetStr,"取医嘱项指针出错:"_ArcCode)
 s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcimId1,""))
 s ArcSubCatId=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),""))
 q:$g(ArcSubCatId)="" ..RetErrorValue(RetStr,"取医嘱子类指针出错:"_ArcSubCat)
 s ArcimId=ArcimId1_"||"_ArcimId2
 &SQL(update SQLUser.ARC_ItmMast set ARCIM_ItemCat_DR=:ArcSubCatId where arcim_rowid=:ArcimId)
 s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q RetStr
}

ClassMethod ArcimDataUpa() As %String
{
 s ArcimId1=0,ArcimId2=0,del="^"
	f  s ArcimId1=$o(^ARCIM(ArcimId1)) Q:ArcimId1=""  D
	.F  s ArcimId2=$o(^ARCIM(ArcimId1,ArcimId2)) Q:ArcimId2=""  D
	..s phddrg=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
	..q:$g(phddrg)=""
	..s ArcimId=ArcimId1_"||"_ArcimId2
	..q:$g(ArcimId)=""
	..if $p(phddrg,"||",2)=0 d
	...s $p(phddrg,"||",2)=1
	...&sql(update sqluser.arc_itmmast set ARCIM_PHCDF_DR=:phddrg where arcim_rowid=:ArcimId )
	...w "."
}

ClassMethod CareData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CTPCP,^RB("RES"),^RBC("SER")
	q:ChangeType="Clear" "数据已清:医护人员和资源"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,3),Desc=$P(RowStr,del,4),Abbr=$P(RowStr,del,11)
	q:Code="" ..RetErrorValue(RetStr,"代码为空")
	q:Desc="" ..RetErrorValue(RetStr,"名称为空")
	if $D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"医护人员代码已经存在")
	if $D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))) s RetStr=..RetErrorValue(RetStr,"医护人员名称已经存在")
	s CtLocCode=$p(RowStr,del,1)
	q:CtLocCode="" ..RetErrorValue(RetStr,"医护人员科室为空")
	s CpType=$P(RowStr,del,5),CpTypeDr=""
	if CpType'="" d
	.SET Label=Code,SMC=Code,Speciality=$P(RowStr,del,8)
	.s Title=$p(RowStr,del,6)
	.if Title'=""  d
	..s Title=$o(^CT("TTL",0,"Desc",$$ALPHAUP^SSUTIL4(Title),""))
	..if Title="" s RetStr=..RetErrorValue(RetStr,"职务类型指针出错")
	.IF CpType="" s RetStr=..RetErrorValue(RetStr,"医护人员类型为空") q
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q
	.s CtLoc=$p(CtLocCode,"/"),CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	.if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错CT_CareProv:"_CtLoc)
	.if ChangeType'="Test" d
	..if ('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code)))&('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))) d
	...K PLIST
	...SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=Label,PLIST(7)=CpTypeDr,PLIST(36)=Speciality,PLIST(38)=+$h,PLIST(49)=Title,PLIST(73)=$g(Abbr)
	...&SQL(INSERT INTO SQLUser.CT_CareProv VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	...if $g(%ROWID)'=""  d
	....k PLIST
	....s PLIST(0)=%ROWID,PLIST(3)=Desc
	....&SQL(INSERT INTO SQLUser.CT_CareProvKeywords VALUES :PLIST())
	....if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProvKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错:"_Code) q
	.S Services=$P(RowStr,del,9)
	.q:Services=""
	.s CircleNum=$l(Services,"/"),i=0
	.f  s i=i+1 q:(i>CircleNum)  d
	..s Service=$P(Services,"/",i)
	..q:$g(Service)=""
	..s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),""))
	..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_Code)
	..q:ArcimId1=""
	..s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),ArcimId1,""))
	..S ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	..s Service=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	..s:Service="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_Code)
	..q:Service=""
	..s ServiceId=0
	..s CircleFlag=1
	..f  s ServiceId=$o(^RBC("SER",0,"CTCP",CareProvId,ServiceId)) q:((ServiceId="")!(CircleFlag=0))  d
	...s ArcimId=$p(^RBC("SER",ServiceId),del,1)
	...s:(ArcimId=(ArcimId1_"||"_ArcimId2)) CircleFlag=0
	..if CircleFlag=0 q
	..;if CircleFlag=0 s RetStr=..RetErrorValue(RetStr,"医护人员服务已经存在:"_Code) q
	..if ChangeType'="Test" d
	...k PLIST
	...S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(5)=CareProvId,PLIST(7)=$g(ArcimDesc),PLIST(10)=Service,PLIST(11)="Y",PLIST(13)=$H-1
	...&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//医护人员所在科室
	IF (CpType'="") d
	.s SessTypeDr="",ClinicGroupDr="",SessType=$P(RowStr,del,12),ClinicGroup=$P(RowStr,del,13)
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q
	.if $p(^CT("CPT",CpTypeDr),del,4)="DOCTOR" d 
	..s i=1
	..for  s CtLoc=$p(CtLocCode,"/",i) q:CtLoc=""  d
	...s i=i+1
	...s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	...if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错RB_Resource:"_CtLoc) q
	...s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	...IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错:"_Code) q
	...q:$d(^RB("RES",0,"CTPCP",CareProvId,CtLocId))
	...;if $d(^RB("RES",0,"CTPCP",CareProvId,CtLocId)) s RetStr=..RetErrorValue(RetStr,"资源已经存在:"_Code) q
	...if ChangeType'="Test" d
	....k PLIST
	....s PLIST(3)=CtLocId,PLIST(4)=CareProvId,PLIST(7)=Code,PLIST(8)=Desc,PLIST(11)=-1,PLIST(16)=999
	....s PLIST(19)="Care Provider",PLIST(20)="Y",PLIST(21)="Y"
	....&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	....if $g(%ROWID)'="" S rid=%ROWID
	....ELSE  Q
	....q:$g(SessType)=""
	....q:'$d(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType)))  
	....s SessTypeDr=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType),""))
	....if $g(SessTypeDr)="" s RetStr=..RetErrorValue(RetStr,"取出诊级别出错:"_Code) q
	....s ClinicGroupDr=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(ClinicGroup),""))
	....if $g(ClinicGroupDr)="" s RetStr=..RetErrorValue(RetStr,"取亚专业出错:"_Code) q
	....S ^RB("RES",rid,"DHC")=SessTypeDr_"^"_ClinicGroupDr
	
	//用户表
 s Group=$p(RowStr,del,10) 
	q:$d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code))) ..RetErrorValue(RetStr,"用户代码已经存在"_Code)
	q:$d(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Desc))) ..RetErrorValue(RetStr,"用户代码已经存在"_Desc)
	if Group'="" d
	.IF (CpType'="") d
	..SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	..IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType)
	..s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.IF (($g(CareProvId)="")&( $g(CpTypeDr)'="")) s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错:"_Code) q 
	.s i=1,FirstLoc=1
	.for  s CtLoc=$p(CtLocCode,"/",i) q:CtLoc=""  d
	..s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	..if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错SS_USER:"_CtLoc),i=i+1 q
	..s UserGroup=$p(Group,"/",i)
	..s i=i+1
	..if $g(UserGroup)="" s RetStr=..RetErrorValue(RetStr,"取科室对应安全组出错:"_CtLoc) q
	..s UserGroupDr="",GroupId=0
	..f  s GroupId=$o(^SSU("SSGRP",GroupId)) q:GroupId=""  d
	...s GroupName=$p(^SSU("SSGRP",GroupId),"^",1)
	...if GroupName=UserGroup s UserGroupDr=GroupId q
	..if UserGroupDr="" s RetStr=..RetErrorValue(RetStr,"取安全组指针出错SS_User:"_UserGroup) q
	..s LanguageId=$o(^SS("LAN",""),-1)
	..if (ChangeType'="Test") d
	...k PLIST
	...if (FirstLoc=1) d
	....s PLIST(2)=Code,PLIST(3)=Desc,PLIST(7)=CtLocId,PLIST(13)=UserGroupDr,PLIST(18)=$g(CareProvId)
	....s PLIST(4)=Code,PLIST(9)="Y",PLIST(17)=LanguageId,PLIST(23)="Y",PLIST(103)=$h-1 
	....i $g(CareProvId)'="" s PLIST(19)=Code
	....&sql(INSERT INTO SQLUser.SS_User VALUES :PLIST())
	....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"SS_User -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	...else  d
	....S UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code),""))
	....if UserId="" s RetStr=..RetErrorValue(RetStr,"取用户信息出错:"_Code) q
	....s PLIST(0)=UserId,PLIST(3)=CtLocId,PLIST(4)=UserGroupDr
	....&sql(INSERT INTO SQLUser.SS_UserOtherLogonLoc VALUES :PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s FirstLoc=FirstLoc+1
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod CareData1(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,3),Desc=$P(RowStr,del,4),Abbr=$P(RowStr,del,11)
	q:Code="" ..RetErrorValue(RetStr,"代码为空")
	q:Desc="" ..RetErrorValue(RetStr,"名称为空")
		s CtLocCode=$p(RowStr,del,1)
	q:CtLocCode="" ..RetErrorValue(RetStr,"医护人员科室为空")
	s CpType=$P(RowStr,del,5),CpTypeDr=""
	s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错:"_Code) q ""
	
	//医护人员所在科室
	IF (CpType'="") d
	.s ^fhq=$i(^fhq)
	.s SessTypeDr="",ClinicGroupDr="",SessType=$P(RowStr,del,12),ClinicGroup=$P(RowStr,del,13)
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q 
	.if $p(^CT("CPT",CpTypeDr),del,4)="DOCTOR" d 
	..s i=1
	..for  s CtLoc=$p(CtLocCode,"/",i) q:CtLoc=""  d
	...s i=i+1
	...s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	...if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错RB_Resource:"_CtLoc) q
	...s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	...IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错:"_Code) q
	...q:'$d(^RB("RES",0,"CTPCP",CareProvId,CtLocId))
	...s rid=$o(^RB("RES",0,"CTPCP",CareProvId,CtLocId,""))
	...q:$g(rid)=""
	...q:($d(^RB("RES",rid,"DHC")))
	...q:$g(SessType)=""
	...q:'$d(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType)))  
	...s SessTypeDr=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType),""))
	...if $g(SessTypeDr)="" s RetStr=..RetErrorValue(RetStr,"取出诊级别出错:"_Code) q
	...s ClinicGroupDr=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(ClinicGroup),""))
	...if $g(ClinicGroupDr)="" s RetStr=..RetErrorValue(RetStr,"取亚专业出错:"_Code) q
	...S ^RB("RES",rid,"DHC")=SessTypeDr_"^"_ClinicGroupDr
	q ""
}

ClassMethod CareType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("CPT")
	q:ChangeType="Clear" "数据已清:科室和病区"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),DocType=$P(RowStr,del,2)
	q:Code="" ..RetErrorValue(RetStr,"名称为空")
	q:$D(^CT("CPT",$$ALPHAUP^SSUTIL4(Code))) ..RetErrorValue(RetStr,"人员类型已经存在"_Code)
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Code,PLIST(5)=DocType,PLIST(6)=$H-2
	.&SQL(INSERT INTO SQLUSER.CT_CARPRVTP VALUES :PLIST())
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_CARPRVTP -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod ClearGlobal(UpType As %String) As %String
{
	q:UpType=""
	k ^TMPFHQ(UpType)
	Q ""
}

ClassMethod CtGroup(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^RBC("DEP")
	q:ChangeType="Clear" "数据已清"_"^RBC("_"DEP"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	Q:Code="" RetStr="科室部门组为空"
	if '$d(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Code,PLIST(4)=$h-2
 ..&SQL(INSERT INTO SQLUSER.RBC_DEPARTMENTGROUP VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RBC_DEPARTMENTGROUP -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod CtLoc(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----*3------4--------5-----------6-----------7-----------8---------9---
	;    Code   Desc    Type    group    DEPTCAT  WARDVSDEPT    Ord Exec  Index Order    MR   
	; 1 PLIST(2)            Code
	; 2 PLIST(3)            Desc
	; 3 PLIST(27)           Type
	; 4 PLIST(43)           Group
	; 5 PLIST(47)           Order Exec Y/N
	; 6 PLIST(45)           Index By Order Date Y/N
	; 7 PLIST(54)           MR  Y/N
	Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	if ChangeType="Clear" K ^CTLOC,^PAWARD,^PAC("ADMLOC"),^PAC("PACWD")
	q:ChangeType="Clear" "数据已清:科室和病区"
	s del="^"
	SET RowStr=$tr(RowStr," ","")
	s RetStr=""
	SET Code=$P(RowStr,del,1),DESC=$P(RowStr,del,2),TYPE=$$ALPHAUP^SSUTIL4($P(RowStr,del,3)),GROUP=$P(RowStr,del,4)
	SET DEPTCAT=$$ALPHAUP^SSUTIL4($P(RowStr,del,5)),ORDEXEC=$P(RowStr,del,7),INDEX=$P(RowStr,del,8),MR=$P(RowStr,del,9)
	s adress=$P(RowStr,del,10),phone=$P(RowStr,del,11),ext=$P(RowStr,del,12),Abbre=$P(RowStr,del,13)
	s Floor=$P(RowStr,del,14)
	s:$g(Floor)'="" Floor=adress_","_Floor
	s Floor=$g(Floor)
	s:TYPE="" TYPE="OTHER"
	IF ORDEXEC="" SET ORDEXEC="Y"
	IF INDEX="" SET INDEX="Y"
	IF MR="" SET MR="Y"
	Q:Code="" RetStr="代码为空"
	s:$D(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code))) RetStr=..RetErrorValue(RetStr,"代码已经存在:"_Code)
	Q:DESC="" "名称为空"
	s:$D(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(DESC))) RetStr=..RetErrorValue(RetStr,"名称已经存在:"_DESC)
	s:TYPE="" RetStr=..RetErrorValue(RetStr,"科室类型为空")
	if (('$D(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(DESC))))) d
	.SET TYPE=$select(TYPE["WARD":"W",TYPE["EXECUTE":"E",TYPE["MEDICAL":"MR",TYPE["OPERATION":"OP",TYPE["CASHIER":"C",TYPE["OTHER":"O",TYPE["DISPENSING":"D",TYPE["CLINIC":"CL",TYPE["ROOM":"OR",1:"")
	.   IF TYPE="W" SET WARDFLAG="Y"
	.   ELSE  SET WARDFLAG=""
	.s GROUPDR=""
	.   SET:GROUP'="" GROUPDR=$O(^RBC("DEP",0,"Desc",$$ALPHAUP^SSUTIL4(GROUP),""))
	.   IF GROUPDR="" d
	.   .s:RetStr'="" RetStr=RetStr_"@"_Code_DESC_"科室部门组为空"
	.   .s:RetStr="" RetStr=Code_DESC_"科室部门组为空"  
 .if ChangeType'="Test" d
 ..S Para=Code_del_DESC_del_$g(WARDFLAG)_del_$g(TYPE)_del_$g(GROUPDR)_del_$g(ORDEXEC)_del_$g(INDEX)_del_$g(MR)_del_$g(adress)_del_$g(phone)_del_$g(ext)_del_$g(Abbre)_del_Floor
 ..s MRetStr=""
 ..ZN MEDDATA
 ..s MRetStr=$$CtLoc^DHCFHQIMP(Para)
 ..ZN CurrentNS
 ..s RetStr=..RetErrorValue(RetStr,MRetStr)
 ..
 SET DEPTCAT=$S(DEPTCAT["OUTP":"O",DEPTCAT["BOTH":"B",DEPTCAT["INP":"I",DEPTCAT["EMER":"E",DEPTCAT["PROM":"P",1:"")
	 if DEPTCAT'="" d
	 .SET CodeDR=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	 .if CodeDR="" s RetStr=..RetErrorValue(RetStr,"科室指针出错PAC_ADMTYPELOCATION:"_Code) q
	 .if ChangeType'="Test" d
	 ..if DEPTCAT="B" d   //为B时是门诊住院为一个科室
	 ...if '$d(^PAC("ADMLOC",0,"AdmType","O",CodeDR)) d
	 ....s Para=CodeDR_del_"O"
	 ....ZN MEDDATA
	 ....s MRetStr=$$AdmLoc^DHCFHQIMP(Para)
	 ....ZN CurrentNS
	 ....s RetStr=..RetErrorValue(RetStr,MRetStr)
	 ...if '$d(^PAC("ADMLOC",0,"AdmType","I",CodeDR)) d
	 ....s Para=CodeDR_del_"I"
	 ....ZN MEDDATA
	 ....s MRetStr=$$AdmLoc^DHCFHQIMP(Para)
	 ....ZN CurrentNS
	 ....s RetStr=..RetErrorValue(RetStr,MRetStr)
	 ....
	 ..e  d
	 ...if '$d(^PAC("ADMLOC",0,"AdmType","O",CodeDR)) d
	 ....s Para=CodeDR_del_DEPTCAT
	 ....ZN MEDDATA
	 ....s MRetStr=$$AdmLoc^DHCFHQIMP(Para)
	 ....ZN CurrentNS
	 ....s RetStr=..RetErrorValue(RetStr,MRetStr)
		
	// D CTWVSD     ;病区与科室对照
	 SET TYPE=$P(RowStr,del,3),DEPTLIST=$P(RowStr,del,6)
	 if TYPE'="" D
	 .SET WardId=$O(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(Code),""))  
	 .IF WardId="" Q
	 .s CtLocId=$p(^PAWARD(WardId),del,5)
	 .Q:$p(^CTLOC(CtLocId),del,13)'="W"
	 .IF DEPTLIST="" s RetStr=..RetErrorValue(RetStr,"病区对应的科室为空PAC_WardBedAllocation:"_Code) q
	 .SET I=1
	 .FOR  SET DEPT=$P(DEPTLIST,"/",I) Q:DEPT=""  D
	 ..SET I=I+1
	 ..SET DeptId=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	 ..IF DeptId="" s RetStr=..RetErrorValue(RetStr,"取科室指针出错PAC_WardBedAllocation:"_DEPT) Q
	 ..if ChangeType'="Test" d
	 ...K PLIST
	 ...SET PLIST(0)=WardId,PLIST(3)=+$H,PLIST(4)=DeptId,PLIST(5)=1
	 ...&SQL(INSERT INTO SQLUser.PAC_WardBedAllocation VALUES PLIST())
	 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PAC_WardBedAllocation"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))   
	 
	 q:RetStr="" "Ok"
	 q RetStr
}

/// 专长
ClassMethod CtSpec(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    DESC   
	IF ChangeType="Clear" K ^CT("SPC")
	q:ChangeType="Clear" "数据已清:专长"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	if $g(^CT("SPC",0))="" s Code=1
	if $g(^CT("SPC",0))'="" s Code=$g(^CT("SPC",0))+1
	Q:Code="" "编码为空"
	Q:$D(^CT("SPC",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) "名称已经存在"_Desc
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=$$ALPHAUP^SSUTIL4(Desc),PLIST(5)=+$H
	.&SQL(INSERT INTO SQLUSER.CT_Spec VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_Spec -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod CtSpecialty(ChangeType As %String = "", RowStr As %String = "") As %String
{
 //科室亚专业    ROWSTR  科室代码    亚专业
	if ChangeType="Clear" K ^RBC("CLGRP"),^DHCLocSubject
	q:ChangeType="Clear" "数据已清"_"^RBC("_"CLGRP"_")^DHCLocSubject"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET CtCode=$P(RowStr,del,1),Code=$P(RowStr,del,3),Desc=$P(RowStr,del,4)
	Q:Code="" RetStr="专业代码为空"
	Q:Desc="" RetStr="专业名称为空"
	if ('$d(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) d
	.;if $d(^RBC("CLGRP",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在"_Code) q
	.if $d(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在"_Desc) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$H-2
	..&sql(INSERT INTO SQLUSER.RBC_ClinicGroup VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_ClinicGroup -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	if $g(CtCode)'="" d
	.s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtCode),0))
	.s:$g(CtLocId)="" RetStr=..RetErrorValue(RetStr,"取科室指针出错"_CtCode)
	.q:$g(CtLocId)=""
	.s RbClinicGroupId=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
	.s:$g(RbClinicGroupId)="" RetStr=..RetErrorValue(RetStr,"取亚专业指针出错"_Code)
	.q:$g(RbClinicGroupId)=""
	.q:$d(^DHCLocSubject(0,"Loc",CtLocId,"Spec",RbClinicGroupId))
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=CtLocId,PLIST(3)=RbClinicGroupId
	..&sql(INSERT INTO SQLUSER.DHC_LocSpec VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_ClinicGroup -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
		
	//DHC_LocSpec
}

ClassMethod CtTitle(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("TTL")
	q:ChangeType="Clear" "数据已清"_"^CT("_"TTL"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	Q:Code="" RetStr="职务名称为空"
	if '$d(^CT("TTL",0,"Desc",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Code,PLIST(4)=$h-2
 ..&SQL(INSERT INTO SQLUSER.CT_Title VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Title -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod CtUom(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; Exel Format:
	;    ----1--------2---------3--------
	;    fromuom^   touom ^  fac      
	;      PLIST(2)^ PLIST(3)^ PLIST(5)
	if ChangeType="Clear" K ^CT("UOM"),^CT("CTCF")
	q:ChangeType="Clear" "数据已清"_"^CT("_"UOM"_")^CT("_"CTCF"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET FromUom=$p(RowStr,del,1),DESC=FromUom,FDESC=FromUom
	s ToUom=$p(RowStr,del,3),Fac=$p(RowStr,del,2)
	q:FromUom="" ..RetErrorValue(RetStr,"单位代码为空:")
	q:ToUom="" ..RetErrorValue(RetStr,"单位代码为空:")
	s:$g(Fac)="" Fac=1
	;q:((Fac=1)&(FromUom'=ToUom)) ..RetErrorValue(RetStr,"转换系数为1,但两个单位不一样:"_FromUom_"-"_ToUom)
	i '$d(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(FromUom))) d
	.if ChangeType'="Test" d 
	.. k PLIST       
	.. s PLIST(2)=FromUom,PLIST(3)=FromUom,PLIST(5)=FromUom
	.. &sql(INSERT INTO SQLUSER.CT_UOM VALUES :PLIST())
	.. i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_UOM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	i '$d(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(ToUom))) d
	.if ChangeType'="Test" d 
	.. k PLIST       
	.. s PLIST(2)=ToUom,PLIST(3)=ToUom,PLIST(5)=ToUom
	.. &sql(INSERT INTO SQLUSER.CT_UOM VALUES :PLIST())
	.. i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_UOM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	s FUOMDR=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(FromUom),""))
	q:FUOMDR="" ..RetErrorValue(RetStr,"转换单位出错:"_FromUom)

	s TUOMDR=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(ToUom),""))
	q:TUOMDR="" ..RetErrorValue(RetStr,"转换单位出错:"_ToUom)
	if '$D(^CT("CTCF",0,"UOM",FUOMDR,TUOMDR)) d
	.if ChangeType'="Test" d
	..k PLIST
	..SET PLIST(2)=FUOMDR,PLIST(3)=TUOMDR,PLIST(4)=Fac, PLIST(6)="Y"
	..&sql(INSERT INTO SQLUSER.CT_ConFac VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_ConFac -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod DrugData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	;  -*1*--------2--------3*-------4---------5------6--------7--------8-----------9---------
 ;  Code^Description^   ABBR  ^ abbr1^     UOM  ^PUR_PRICE^ PRICE ^Base UOM^ PAKG_UOM ^
 ;  -*10*------------11---------12-----13--------14-----15-------16-----17------18------19-----20-------21---
 ;  Base Quantity^EQUI_QTY ^ EQUI_UOM^ORDCAT^ORDSubCat^BILL ^ SUBBILL^ OUTPCAT OUTP   ECON   ECON    ACCT
 ;  -*22*-----23-----24-------25-----26--------27-----28-----------29-------30-------31-----32--------33--
 ;   ACCT   STKCAT^TKCAT^  DRGCAT^DRGSubCat^  MinCat^Instruction^duration^DRGFORM^ 医保类^Priority^OWN_ORD
 ;  --34------35----36------37---38---------39---------40--------41----------42---------43
 ;  ^BATCH^EXPIRE^供应商^厂商^precaution^indication^contraind^advreaction^incteraction^waring
 ; 1 PLIST(15)                           <= for Pharmarcy Item   Code
 ; 2 PLIST(2)                            <= for Pharmarcy Item   Description 
 ; 3 PLIST(5)                            <= for Pharmarcy Item   药理学分类子类
 ; 11 PLIST(13)                          <= for Pharmarcy Item   制药厂(厂商)
 ; 12                                    <= for Pharmarcy Item   Abbr
 ; 13                                    <= for Pharmarcy Item   规格
 ; 4 PLIST(2)                            <= for Drug Form        DRUG form 
 ; 5 PLIST(21)                           <= for Drug Form        Base Uom
	 ; 6 PLIST(11)                           <= for Drug Form        Instruction
 ; 7 PLIST(19)                           <= for Drug Form        Duration
 ; 8 PLIST(22)                           <= for Drug Form        Base Qty
 ; 9 PLIST(3)                            <= for PHC FormDose Equivalent  Equ Uom
 ; 10 PLIST(4)                           <= for PHC FormDose Equivalent  Equ Qty
 //s RowStr="6000005^注射用羧苄西林钠(1.0g)^注射用羧苄西林钠^SBXLN^支^39.00 ^46.80 ^支^支^1^1^g^^西成药^针剂丙类^西药费^西药丙类^^^^^西药费^西药费^西药费^西药费^医疗收入^药品收入^^^针剂^针剂^西药^抗微生物类^?-内酰胺类(青霉素类)^静脉输液^1天^粉针剂^医保丙类^长期医嘱^Y^Y^Y^^^^^^^^"
 Set CurrentNS=$ZNSPACE
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 
 if ChangeType="Clear" d
 .K ^PHCD,^INCI,^INCALIAS,^mdata("INCALIAS"),^INASP,^mdata("INADJSALEPRICE")
 .;k ^ARCIM,^ARC("ALIAS"),^DHCTARAL,^DHCOLT,^DHCTARI
 .;k ^ARCIM,^ARC("ALIAS"),^DHCTARAL,^DHCOLT,^DHCTARI
 q:ChangeType="Clear" "数据已清:药学项"
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
 s Code=$p(RowStr,del),Desc=$p(RowStr,del,2),abbr=$p(RowStr,del,4),Alias=$p(RowStr,del,4)
 s guige=$p(RowStr,del,39)
 set guige=$select(guige="甲类":1,guige="乙类":2,guige="丙类":3,guige="":3,1:4)
 q:Code="" ..RetErrorValue(RetStr,"代码为空:")
 q:Desc="" ..RetErrorValue(RetStr,"名称为空:")
 S:(($d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) RetStr=..RetErrorValue(RetStr,"药学项名称已经存在:")
 s:(($d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc))))) RetStr=..RetErrorValue(RetStr,"药学项代码已经存在:")
 s:(($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_Desc)
 s:(($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_Code)
 s:(($D(^DHCTARI(0,"Code",Code)))&('$D(^DHCTARI(0,"Desc",Desc)))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_Code)
 s:(($D(^DHCTARI(0,"Desc",Desc)))&('$D(^DHCTARI(0,"Code",Code)))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_Desc)
 s:(($d(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) RetStr=..RetErrorValue(RetStr,"库存项代码已经存在"_Code)
 s:(($d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) RetStr=..RetErrorValue(RetStr,"库存项名称已经存在"_Desc)

 s UserDr=$o(^SSU("SSUSR",0))
 s BaseUom=$p(RowStr,del,9),BaseUomDr="" //基本单位
 s OrdUom=$p(RowStr,del,5),OrdUomDr="" //基本单位
 i BaseUom'=""  d
 .s BaseUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(BaseUom),""))
 .s:BaseUomDr="" RetStr=..RetErrorValue(RetStr,"基本单位指针出错:"_BaseUom)
 i OrdUom'=""  d
 .s OrdUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(OrdUom),""))
 .s:OrdUomDr="" RetStr=..RetErrorValue(RetStr,"医嘱单位指针出错:"_BaseUom)
 s PakgUom=$p(RowStr,del,10),PakgUomDr=""
 s:PakgUom="" RetStr=..RetErrorValue(RetStr,"包装单位为空:") 
 if PakgUom'="" d
 .s PakgUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(PakgUom),"")) 
 .s:PakgUomDr="" RetStr=..RetErrorValue(RetStr,"包装单位指针出错:"_PakgUom)
 s Price=$tr($p(RowStr,del,8)," ")
 s Rprice=$tr($p(RowStr,del,7)," ") //进价 liangqiang
 s HospID=$tr($p(RowStr,del,60)," ")
 s ConFac=$tr($p(RowStr,del,11)," ")
 s UnitPrice=""
 //if (($g(Price)'="")&($g(ConFac)'="")) s UnitPrice=Price,Price=Price*ConFac
 if (($g(Price)'="")&($g(ConFac)'="")) s UnitPrice=Price/ConFac,Price=Price  //liangqiang update
  if (($g(Price)'="")&($g(ConFac)'="")) s TarPrice=UnitPrice  //liangqiang update
 

	//药学项
	
 if ('$d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc)))&('$d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
 .s precaution=$p(RowStr,del,47)  ;注意事项
 .s indication=$p(RowStr,del,48)  ;适应症
 .s contraind =$p(RowStr,del,49)  ;禁忌症
 .s advreaction=$p(RowStr,del,50) ;不良反应
 .s incteraction=$p(RowStr,del,51) ;
 .s waring=$p(RowStr,del,52)      ;提示
 .s cyjl=$p(RowStr,del,14)         ;常用计量
 .s Freq=$p(RowStr,del,40)        ;常用频次
 .;s ybmc=$p(RowStr,del,47)          ;医保名称
 .;s ybdm=$p(RowStr,del,48)          ;医保代码
 .;s isdmy=$p(RowStr,del,48)         ;是否是毒麻药
 .;s zyfs=$p(RowStr,del,50)          ;转移方式
 .;s jlxz=$p(RowStr,del,51)          ;剂量限制
 .;s pwjj=$p(RowStr,del,52)          ;配伍禁忌
 .;s bzxz=$p(RowStr,del,53)          ;病种限制
 .;i abbr'="" s Desc=abbr_"-"_Desc
 .;
 .;,labell=$p(RowStr,del,5),labelf=$p(RowStr,del,5) 
	.s PhcCat=$p(RowStr,del,34)
 .s SubCat=$p(RowStr,del,35)     ;
 .s MinCat=$p(RowStr,del,36)
 .s PhcCatDr="",SubCatDr="",MinCatDr=""
	.S GenericId=""
	.S Generic=$p(RowStr,del,3)
	.if Generic'="" d
	..;s GenericId=$o(^PHCGE("GE",0,"Code",$$ALPHAUP^SSUTIL4(Generic),0))
	..s GenericId=$o(^PHCGE("GE",0,"Name",$$ALPHAUP^SSUTIL4(Generic),0))
	..s ^fhq(Code)=Generic_"^"_GenericId
	..if GenericId="" s RetStr=..RetErrorValue(RetStr,"取药品通用名指针出错:"_Generic)
 .i SubCat'="" d
 ..s PhcCatDr=$o(^PHCC("SC_Desc",$$ALPHAUP^SSUTIL4(SubCat),PhcCatDr))
 ..s:PhcCatDr="" RetStr=..RetErrorValue(RetStr,"药理学子类不存在:"_SubCat)
 ..q:PhcCatDr=""  
 ..s SubCatDr=$o(^PHCC("SC_Desc",$$ALPHAUP^SSUTIL4(SubCat),PhcCatDr,SubCatDr))
 ..s:SubCatDr="" RetStr=..RetErrorValue(RetStr,"药理学子类指针出错:"_SubCat)	
 .IF MinCat'="" d
 ..s MinCatDr=$o(^PHCC("MIN_Desc",$$ALPHAUP^SSUTIL4(MinCat),PhcCatDr,SubCatDr,MinCatDr))
 ..s:MinCatDr="" RetStr=..RetErrorValue(RetStr,"药理学小类不存在:"_MinCat)
 .s:SubCatDr'="" SubCatDr=PhcCatDr_"||"_SubCatDr
 .s:MinCatDr'="" MinCatDr=SubCatDr_"||"_MinCatDr
 .
 .s manf=$p(RowStr,del,46),manfdr=""
 .i manf'="" d
 ..s manfdr=$o(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(manf),""))
 ..s:manfdr="" RetStr=..RetErrorValue(RetStr,"药品产地指针出错:"_manf)
 .. 
 .s PhcForm=$p(RowStr,del,39),PhcFormDr=""
 .if PhcForm="" s RetStr=..RetErrorValue(RetStr,"剂型为空"_Code) q
 .i PhcForm'="" d
 ..s PhcFormDr=$o(^PHCF(0,"Desc",$$ALPHAUP^SSUTIL4(PhcForm),"")) 
 ..s:PhcFormDr="" RetStr=..RetErrorValue(RetStr,"剂型指针出错:"_PhcForm) 
 ..q:PhcFormDr=""
 .q:$g(BaseUomDr)=""
 .s Instruct=$p(RowStr,del,37),InstructDr=""
 .i Instruct'="" d
 ..s InstructDr=$o(^PHCIN(0,"Desc1",$$ALPHAUP^SSUTIL4(Instruct),""))
 ..s:InstructDr="" RetStr=..RetErrorValue(RetStr,"用药说明指针出错:"_Instruct)
 ..q:InstructDr=""
 .
 .s duration=$p(RowStr,del,38)
 .s:duration="" duration="1天"
 .i duration'="" d 
 ..s durationDr=$o(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(duration),""))
 ..s:durationDr="" RetStr=..RetErrorValue(RetStr,"疗程指针出错:"_duration)
 ..q:durationDr=""
 .
 .s BaseQty=$p(RowStr,del,11)
 .s:BaseQty="" BaseQty=1
 .
 .s EquUom=$p(RowStr,del,13),EquUomDr=""
 .i EquUom'="" d
 ..s EquUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(EquUom),"")) 
 ..s:EquUomDr="" RetStr=..RetErrorValue(RetStr,"等效单位指针出错:"_EquUom)
 .
 .s EquQty=$p(RowStr,del,12)
 .s EquQty=$s(EquQty="":"",1:+EquQty)
 .
 .s FreqDr=""
 .i Freq'="" d
 ..s FreqDr=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Freq),""))
 .S ManType=$p(RowStr,del,15),ManTypeId=""
 .if $g(ManType)'="" d
 ..s ManTypeId=$o(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(ManType),0))
 ..if ManTypeId="" s RetStr=..RetErrorValue(RetStr,"取管制分类指针出错:"_ManType)
 .s ret="OK"
 .if ChangeType'="Test" d
 ..s guige=""
 ..s TradeName=""
 ..s Para=Code_del_Desc_del_TradeName_del_SubCatDr_del_MinCatDr_del_guige_del_manfdr_del_ManTypeId_del_GenericId
 ..zn MEDDATA
 ..S Ret=$$DrugMast^DHCFHQIMP(Para)
 ..ZN CurrentNS
 ..if Ret'="OK" S RetStr=..RetErrorValue(RetStr,Ret)
 ..
 ..;s PhcDrg=##class(User.PHCDrgMast).%New()
 ..;s PhcDrg.PHCDCode=Code
 ..;s PhcDrg.PHCDName=Desc
 ..;if $g(SubCatDr)'="" d
 ..;.d PhcDrg.PHCDPHCSCDRSetObjectId(SubCatDr)
 ..;s PhcDrg.PHCDOfficialCode="" ;guige
 ..;if $g(manfdr)'="" d
 ..;d PhcDrg.PHCDPHMNFDRSetObjectId(manfdr)
 ..;if $g(ManTypeId)'="" d
 ..;if $g(GenericId)'="" d
 ..;.d PhcDrg.PHCDGenericDRSetObjectId(GenericId)
 ..;if ManType'="" s ^fhq(Code,1)=PhcDrg.PHCDPHCPODR_"^"_ManTypeId_"^"_ManType
 ..;d PhcDrg.%Save()
 ..;d PhcDrg.%Close()
 ..;k PLIST 
 ..;s PLIST(15)=Code,PLIST(2)=Desc,PLIST(5)=SubCatDr,PLIST(13)=manfdr,PLIST(23)=guige
 ..;&SQL(INSERT INTO SQLUser.PHC_DrgMast VALUES PLIST())
 ..;s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..;q:$g(SQLCODE)
	..s DrgId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..s:DrgId="" RetStr=..RetErrorValue(RetStr,"取药品指针出错:"_Code)
	..q:DrgId=""
 ..k PLIST 
 ..s PLIST(0)=DrgId
 ..IF $g(InstructDr)="" S InstructDr=$O(^PHCIN(0))
 ..
 ..s PLIST(2)=PhcFormDr,PLIST(10)=FreqDr,PLIST(11)=$g(InstructDr),PLIST(19)=durationDr
 ..s PLIST(21)=BaseUomDr,PLIST(22)=1
 ..;if Code="090620Aaz3205" s ^fhq=PhcFormDr_"^"_FreqDr_del_durationDr_del_precaution_del_waring_del_indication_del_contraind
 ..&SQL(INSERT INTO SQLUser.PHC_DrgForm VALUES PLIST())
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgForm -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..s DrugFormId=$o(^PHCD("DF_Form",PhcFormDr,DrgId,""))
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"IND",0)))&(indication'="")) s ^PHCD(DrgId,"DF",DrugFormId,"IND",1)=indication
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"IND",0)))&(indication'="")) s ^PHCD(DrgId,"DF",DrugFormId,"IND",0)=1,^PHCD(DrgId,"DF",DrugFormId,"IND",1)=indication
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"PRE",0)))&(precaution'="")) s ^PHCD(DrgId,"DF",DrugFormId,"PRE",1)=precaution
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"PRE",0)))&(precaution'="")) s ^PHCD(DrgId,"DF",DrugFormId,"PRE",0)=1,^PHCD(DrgId,"DF",DrugFormId,"PRE",1)=precaution
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"ADV",0)))&(advreaction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"ADV",1)=advreaction
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"ADV",0)))&(advreaction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"ADV",0)=1,^PHCD(DrgId,"DF",DrugFormId,"ADV",1)=advreaction
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"INT",0)))&(incteraction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"INT",1)=incteraction
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"INT",0)))&(incteraction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"INT",0)=1,^PHCD(DrgId,"DF",DrugFormId,"INT",1)=incteraction
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"CON",0)))&(contraind'="")) s ^PHCD(DrgId,"DF",DrugFormId,"CON",1)=contraind
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"CON",0)))&(contraind'="")) s ^PHCD(DrgId,"DF",DrugFormId,"CON",0)=1,^PHCD(DrgId,"DF",DrugFormId,"CON",1)=contraind
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"WRN",0)))&(waring'="")) s ^PHCD(DrgId,"DF",DrugFormId,"WRN",1)=waring
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"WRN",0)))&(waring'="")) s ^PHCD(DrgId,"DF",DrugFormId,"WRN",0)=1,^PHCD(DrgId,"DF",DrugFormId,"WRN",1)=waring
	..i EquUomDr=""!(EquQty="") q
	..s:DrugFormId="" RetStr=..RetErrorValue(RetStr,"取药品剂型指针出错:"_Code)
	..q:DrugFormId=""
 ..k PLIST s PLIST(0)=DrgId_"||"_DrugFormId
 ..s PLIST(3)=EquUomDr,PLIST(4)=+EquQty,PLIST(5)=+cyjl
 ..&sql(INSERT INTO SQLUser.PHC_FormDoseEquiv VALUES PLIST())
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_FormDoseEquiv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	//医嘱项
	if (('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	.S abbr="1"
	.if PakgUomDr="" s RetStr=..RetErrorValue(RetStr,"取包装单位出错:"_Code)
	.q:PakgUomDr=""  //包装单位为空时退出
	.s ArcSubCat=$p(RowStr,del,17),ArcSubCatDr=""
	.s:ArcSubCat="" RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_Code)
	.q:ArcSubCat=""
	.s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
	.s:ArcSubCatDr="" RetStr=..RetErrorValue(RetStr,"医嘱子类指针出错:"_Code_","_ArcSubCat)
	.q:ArcSubCatDr=""
	.s OnItsOwn=$$ALPHAUP^SSUTIL4($p(RowStr,del,42))
	.s:OnItsOwn="" OnItsOwn="Y"
	.i ((OnItsOwn'="Y")&(OnItsOwn'="N")) s OnItsOwn="Y"
	.s BillGrp=$p(RowStr,del,18)
	.s:BillGrp="" RetStr=..RetErrorValue(RetStr,"帐单组为空:"_Code)
	.q:BillGrp=""
	.s BillGrpDr=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(BillGrp),"")) 
	.s:BillGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单组指针出错:"_Code_","_BillGrp)
 .q:BillGrpDr=""
 .s BillSubGrp=$p(RowStr,del,19)
 .s:BillSubGrp="" RetStr=..RetErrorValue(RetStr,"帐单子组名称为空:"_Code_","_BillSubGrp)
 .q:BillSubGrp=""
 .s BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrp),BillGrpDr,""))
 .s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_Code_","_BillSubGrp)
 .q:BillSubGrpDr=""
	.s BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
 .if $g(DrgId)="" d
 ..s DrgId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..s:DrgId="" RetStr=..RetErrorValue(RetStr,"取药品指针出错:"_Code)
	.q:$g(DrgId)=""
	.if $g(DrugFormId)="" d 
	..s DrugFormId=$o(^PHCD(DrgId,"DF",0))
	..s:DrugFormId="" RetStr=..RetErrorValue(RetStr,"取药品剂型指针出错:"_Code)
	.q:$g(DrugFormId)=""
	.s OrdDrugFormDr=DrgId_"||"_DrugFormId
	.s Priority=$p(RowStr,del,41)
	.i Priority'="" d 
	..S PrioDr=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),""))
	..if $g(PrioDr)="" s RetStr=..RetErrorValue(RetStr,"取医嘱优先级指针出错:"_Code)
	.s:$g(PrioDr)="" PrioDr=""
	.s resGrp=$p(RowStr,del,100)
	.
 .if ChangeType'="Test" d
 ..k PLIST s PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=abbr,PLIST(105)=OrdUomDr
 ..s PLIST(9)=ArcSubCatDr,PLIST(47)=BillSubGrpDr,PLIST(83)=OnItsOwn,PLIST(51)=OrdDrugFormDr
 ..s PLIST(113)=PrioDr,PLIST(117)=resGrp
 ..&SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:$g(SQLCODE)
 ..s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
 ..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_Code)
 ..q:ArcimId1=""
 ..s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId1,0))
 ..q:ArcimId2=""
 ..s ArcimId=ArcimId1_"||"_ArcimId2
 ..s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
 ..//别名
 ..i Alias'="" d
 ...set I=1
 ...s num=$l(Alias,"/")
 ...s ALI=""
 ...FOR I=1:1:num d
 ....s ALI=$p(Alias,"/",I)
 ....
 ....q:$d(^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(Desc)))
 ....q:$g(ALI)=""
 ....S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ....if ChangeType'="Test" d
 .....k PLIST 
 .....
 .....s PLIST(2)=ArcimId,PLIST(5)=Desc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 .....set PLIST(4)=ALI
 .....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 .....
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .....q:$g(SQLCODE)
 .....s ArcKeyId=0,CircleFlag=1
 .....f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 ......s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 ......if ALI=ArcKey s CircleFlag=0
 .....q:(CircleFlag=0)
 .....k PLIST 
 .....s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_Desc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
 .....set PLIST(4)=ALI_"Z"
 .....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..//价格
 ..if $g(Price)="" s RetStr=..RetErrorValue(RetStr,"价格为空")
 ..q:$g(Price)=""
 ..if $g(Rprice)="" s RetStr=..RetErrorValue(RetStr,"进价为空")
 ..q:$g(Rprice)=""
 ..if $g(HospID)="" s RetStr=..RetErrorValue(RetStr,"医院ID为空")
 ..q:$g(HospID)=""
 ..if ChangeType'="Test" d
 ...k PLIST
	...s PLIST(0)=ArcimId,PLIST(3)=+$h,PLIST(5)=1,PLIST(6)=Price  ;; PLIST(5)*: ARC_Tariff
 ...&SQL(INSERT INTO SQLUser.ARC_ItemPriceItaly VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemPriceItaly -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 //库存项
 i (('$d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d 
 . s guige=$p(RowStr,del,59)
 . s batch=$$ALPHAUP^SSUTIL4($piece(RowStr,del,43)) 
 . s:((batch="Y")!($g(batch)="")) batch="R"
 .if ((batch'="R")&(batch'="O")&(batch'="N")) s RetStr=..RetErrorValue(RetStr,"取批次出错"_Code_","_batch) q
 .s expire=$$ALPHAUP^SSUTIL4($p(RowStr,del,44)) 
 .s:((expire="Y")!($g(expire)="")) expire="R"
 .if ((expire'="R")&(expire'="O")&(expire'="N")) s RetStr=..RetErrorValue(RetStr,"取批次出错"_Code) q
 .q:BaseUomDr=""    
 .q:PakgUomDr="" 
 .
 .s ConFacFlag=$o(^CT("CTCF",0,"UOM",PakgUomDr,BaseUomDr,"")) 
 .if ConFacFlag="" s RetStr=..RetErrorValue(RetStr,"取单位转换出错"_Code) q
 .SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"库存项取医嘱id出错"_Code)
	.q:ArcimId1="" 
	.s ArcimId2=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId1,0))
	.q:$g(ArcimId2)=""
	.SET ArcimId=ArcimId1_"||"_ArcimId2
	.
	.s catg=$p(RowStr,del,32),catgDr="",catg=$tr(catg," ","")
 .if catg="" s RetStr=..RetErrorValue(RetStr,"库存分类为空:"_Code) 
 .q:catg=""
 .s catgDr=$o(^INC("SC",0,"Desc",catg,0))
 .if catgDr="" s RetStr=..RetErrorValue(RetStr,"库存分类为空:"_","_Code_","_catg) 
 .q:catgDr=""
	.s stkgrp=$p(RowStr,del,33),stkgrpDr=""
	.if stkgrp="" s RetStr=..RetErrorValue(RetStr,"盘点分类为空:"_Code) q
	.s stkgrpDr=$o(^INC("TG",0,"Desc",$$ALPHAUP^SSUTIL4(stkgrp),"")) 
	.if stkgrpDr="" s RetStr=..RetErrorValue(RetStr,"库存分类为空:"_","_Code_","_stkgrp) q
	.SET tran="B"
	.if ChangeType'="Test" d
 ..K PLIST S PLIST(44)=Code,PLIST(45)=Desc,PLIST(48)=batch,PLIST(49)=expire,PLIST(13)=BaseUomDr,PLIST(60)=PakgUomDr
 ..s PLIST(50)=ArcimId,PLIST(14)=catgDr,PLIST(5)=stkgrpDr,PLIST(41)=tran,PLIST(28)=Price
 ..s PLIST(64)="" ;guige    // liangqiang update
 ..&sql(INSERT INTO SQLUser.INC_Itm VALUES :PLIST())
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"INC_Itm -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:$g(SQLCODE)

 s IncItmId=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 IF ((Alias'="")&(IncItmId'="")) d
 .set I=1
 .if ChangeType'="Test" d
 ..FOR  s ALI=$P(Alias,"/",I) q:ALI=""  D
 ...SET I=I+1
 ...q:$g(ALI)=""
 ...s IncAliaId=0,CircleFlag=1
 ...f  s IncAliaId=$o(^INCALIAS(0,"INCI",IncItmId,IncAliaId)) q:((IncAliaId="")!(CircleFlag=0))  d
 ....s TmpLias=$p(^INCALIAS(IncAliaId),del,4)
 ....s:$$ALPHAUP^SSUTIL4(TmpLias)=$$ALPHAUP^SSUTIL4(ALI) CircleFlag=0
 ...q:(CircleFlag=0)
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...s IncItm=##class(User.INCALIAS).%New()
 ...s IncItm.INCAINCIDR=IncItmId
 ...s IncItm.INCACODE=Code
 ...s IncItm.INCADESC=Desc
 ...s IncItm.INCATEXT=ALI
 ...d IncItm.%Save()
 ...d IncItm.%Close()
 //库存项价格
 s IncItmId=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 if ((IncItmId'="")&(PakgUomDr'="")) d
 .
 .if $g(Price)="" s RetStr=..RetErrorValue(RetStr,"价格为空"_Code)
 .q:$g(Price)=""
 .s:Price='"" Price=+Price
 .if $g(ConFac)="" s ConFac=1
 .;if ((ConFac=1)&(BaseUomDr'=PakgUomDr)) s RetStr=..RetErrorValue(RetStr,"单位不相同但系数为为1:"_Code) q
 .;if ((ConFac'=1)&(BaseUomDr=PakgUomDr)) s RetStr=..RetErrorValue(RetStr,"单位相同但系数不为1:"_Code) q
 .//s Price=Price/ConFac
 .SET date=+$H,datee=+$h
 .q:BaseUomDr=""
	.if (Price<0) s RetStr=..RetErrorValue(RetStr,"库存项价格小于0"_Code_","_code) q
	.s Rprice=+$g(Rprice)
	.if (Rprice<0) s RetStr=..RetErrorValue(RetStr,"库存项进价小于0"_Code_","_code) q //liangqiang update
	.if ChangeType'="Test" d
	..k PLIST         
 ..;s PLIST(7)=Price/ConFac,PLIST(8)=+Price/ConFac,PLIST(10)="Y"
 ..s PLIST(7)=UnitPrice,PLIST(10)="Yes"
 ..s PLIST(8)=UnitPrice
 ..s PLIST(6)="ADJ00000B"      
 ..s PLIST(2)=date,PLIST(3)=date,PLIST(4)=UserDr,PLIST(5)=IncItmId,PLIST(11)=PakgUomDr,PLIST(12)=+Price
 ..s PLIST(15)=Rprice,PLIST(21)=HospID //liangqiang update
 ..&sql(INSERT INTO SQLUser.IN_AdjSalePrice VALUES :PLIST())
 ..s:$g(SQLCODE)'=0 RetStr=..RetErrorValue(RetStr,"IN_AdjSalePrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:$g(SQLCODE)'=0
 .//附加表 liangqiang update
 .K PLIST
 .s Spec=$p(RowStr,del,53)
 .s Remark=$p(RowStr,del,58) //批准文号 excle格式:国药准字-H20064230 注意中间有"-" liangqiang update
 .s PLIST(28)=Spec,PLIST(2)=IncItmId,PLIST(12)=Remark
 .&SQL(INSERT INTO SQLUser.DHC_itmaddionInfo VALUES :PLIST())
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_itmaddionInfo -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
  
 //收费项
	if (('$D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) d
	.s TarSubCat=$P(RowStr,del,21)
	.SET INP=$P(RowStr,del,23),OUTP=$P(RowStr,del,25),EMC=$P(RowStr,del,27),ACCT=$P(RowStr,del,29),MR=$P(RowStr,del,31)
	.q:BaseUomDr=""
	.
	.s:TarSubCat="" RetStr=..RetErrorValue(RetStr,"收费子类为空:"_Code)
	.q:TarSubCat=""
	.SET TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",$$UPPER^SSUTIL4(TarSubCat),""))
	.s:TarSubCatDr="" RetStr=..RetErrorValue(RetStr,"收费子指针出错:"_Code_","_TarSubCat)
	.Q:TarSubCatDr=""
	.
	.if OUTP="" s RetStr=..RetErrorValue(RetStr,"门诊子类为空:"_Code) q
	.SET OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
	.if OUTPDR="" s RetStr=..RetErrorValue(RetStr,"门诊子类指针出错:"_Code_","_OUTP) q
	.if INP="" s RetStr=..RetErrorValue(RetStr,"住院子类为空:"_Code) q
	.SET INPDR=$O(^DHCTarC("IC",0,"Desc",INP,"")) 
	.if INPDR="" s RetStr=..RetErrorValue(RetStr,"住院子类指针出错:"_Code_","_INP) q
	.if EMC="" s RetStr=..RetErrorValue(RetStr,"核算子类为空:"_Code) q
	.SET EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
	.if EMCDR="" s RetStr=..RetErrorValue(RetStr,"核算子类指针出错:"_Code_","_EMC) q
	.if ACCT="" s RetStr=..RetErrorValue(RetStr,"会计科目子类为空:"_Code) q
	.SET ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
	.if ACCTDR="" s RetStr=..RetErrorValue(RetStr,"会计科目指针出错:"_Code_","_ACCTDR) q
	.
	.if MR="" s RetStr=..RetErrorValue(RetStr,"病案子类为空:"_Code) q
	.SET MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
	.if MRDR="" s RetStr=..RetErrorValue(RetStr,"病案指针出错:"_Code_","_MRDR) q
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(10)="N",PLIST(11)="Y",PLIST(12)=+$H
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=BaseUomDr,PLIST(5)=TarSubCatDr,PLIST(6)=ACCTDR,PLIST(7)=OUTPDR
	..SET PLIST(8)=EMCDR,PLIST(9)=MRDR,PLIST(18)=INPDR
	..&SQL(INSERT INTO SQLUser.DHC_TARITEM VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:$g(SQLCODE)
 ..
 ..s TarId=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 ..if TarId="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项指针出错"_Code)
 ..q:TarId=""
 ..set I=1
 ..
 ..k PLIST 
 ..s PLIST(2)=TarId,PLIST(3)=Desc
 ..s:Price='"" Price=+Price
 ..s:Price="" RetStr=..RetErrorValue(RetStr,"收费项价格为空"_Code)
 ..if $g(ConFac)="" s ConFac=1
 ..;if ((ConFac=1)&(BaseUomDr'=PakgUomDr)) s RetStr=..RetErrorValue(RetStr,"单位不相同但系数为为1:"_Code) q
 ..;if ((ConFac'=1)&(BaseUomDr=PakgUomDr)) s RetStr=..RetErrorValue(RetStr,"单位相同但系数不为1:"_Code) q
 ..k PLIST 
 ..s PLIST(0)=TarId,PLIST(3)=+$H,PLIST(5)=+TarPrice,PLIST(8)=UserDr,PLIST(13)="1"
 ..&SQL(INSERT INTO SQLUser.DHC_TARItemPrice VALUES :PLIST())
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARItemPrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 //收费项别名
 s TarId=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 if (($g(TarId)'="")&(ChangeType'="Test")) d
 .set I=1
 .k PLIST 
 .s PLIST(2)=TarId,PLIST(3)=Desc
 .FOR  s ALI=$P(Alias,"/",I)  q:ALI=""  D
 ..q:$g(ALI)=""
 ..set PLIST(4)=ALI
 ..SET I=I+1
 ..&SQL(INSERT INTO SQLUser.DHC_TARITEMAlias VALUES :PLIST()) 
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEMAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	//医嘱与收费项目对照

	SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	q:ArcimId1="" ..RetErrorValue(RetStr,"对照时医嘱id出错"_Code) 
	SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId1,0))
	SET TarId=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 q:TarId="" ..RetErrorValue(RetStr,"对照时收费项目id出错"_Code)
 q:$d(^DHCOLT(0,"ARTTA",ArcimId,TarId)) RetStr
 if ChangeType'="Test" d
 .K PLIST
 .SET PLIST(2)=ArcimId,PLIST(3)=TarId,PLIST(4)=1,PLIST(5)=+$H-1
 .&SQL(INSERT INTO SQLUser.DHC_ORDERLINKTAR VALUES :PLIST())
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod DrugDataGen(ChangeType As %String = "", RowStr As %String = "") As %String
{
 ;导药学项通用名
 ;CODE    DESC  alias
 ; 1        2    3
 ;K ^PHCGE("GE")

 IF ChangeType="Clear" K ^PHCGE("GE")
	q:ChangeType="Clear" "数据已清:药品通用名"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S CODE=$P(RowStr,del,1),ALIAS=$P(RowStr,del,2)
	S DESC=ALIAS_"-"_CODE
	s startdate=+$h-1
	q:$G(CODE)="" ..RetErrorValue(RetStr,"代码为空")
	q:$D(^PHCGE("GE",0,"Code",$$ALPHAUP^SSUTIL4(CODE))) ..RetErrorValue(RetStr,"代码已经存在"_CODE) 
	K PLIST
	SET PLIST(2)=DESC,PLIST(3)=CODE,PLIST(6)=startdate
	 &SQL(INSERT INTO SQLUser.PHC_Generic VALUES PLIST())
 Q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_Generic -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
 s ARCIM=$g(%ROWID),I=1
 k PLIST s PLIST(16)=ARCIM,PLIST(14)=startdate
 F  s ALI=$P(ALIAS,"/",I)  q:ALI=""   D
 .set PLIST(4)=$EXTRACT(ALI,1,8)
 .SET I=I+1
 .&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST())
	Q RetStr
}

ClassMethod EqResource(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//1					2						3			4					5			6						7			8
	//科室代码	科室名称	设备组	设备名称	星期	开始时间 结束时间	数量
 IF ChangeType="Clear" k ^RBC("GRP"),^RBC("EQ")
	q:ChangeType="Clear" "数据已清:设备组及设备"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S CtLocCode=$P(RowStr,del,1),EqGroupCode=$P(RowStr,del,3),EqGroupDesc=$P(RowStr,del,4),Equipment=$P(RowStr,del,5)
	s Week=$P(RowStr,del,6),StartTime=$P(RowStr,del,7),EndTime=$P(RowStr,del,8),Num=$P(RowStr,del,9)
 s TotalNum=$P(RowStr,del,9)
	q:CtLocCode="" "科室代码为空"_CtLocCode
	s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	Q:$g(CtLocId)="" ..RetErrorValue(RetStr,"科室指针出错Ct_loc:"_CtLocCode)
	s:StartTime="" StartTime="08:00:00"
	s StartTime=$zth(StartTime)
	s:EndTime="" EndTime="17:00:00"
	s EndTime=$zth(EndTime)
	s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	q:CtLocId="" ..RetErrorValue(RetStr,"取科室指针出错"_CtLocCode_" "_Week)
	s EquipmentCode=""
	
	if $g(^RBC("EQ",0))="" s EquipmentCode=1
	if $g(^RBC("EQ",0))'="" s EquipmentCode=$g(^RBC("EQ",0))+1
	q:EqGroupCode="" "设备组为空"_CtLocCode_"星期"_Week
	S:('$d(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode)))&($d(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(EqGroupDesc))))) RetStr=..RetErrorValue(RetStr,"设备代码已经存在"_EqGroupCode)
	S:($d(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode)))&('$d(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(EqGroupDesc))))) RetStr=..RetErrorValue(RetStr,"设备名称已经存在"_EqGroupDesc)
	if ('$d(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode)))&('$d(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(EqGroupDesc))))) d
	.if ((ChangeType'="Test")) d
	..k PLIST
	..S PLIST(2)=EqGroupCode,PLIST(3)=EqGroupDesc,PLIST(4)=+$H
	..&SQL(INSERT INTO SQLUSER.RBC_EquipmentGroup VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_EquipmentGroup -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 q:Equipment="" "设备为空"_CtLocCode_"星期"_Week
 if ('$d(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment)))) d
 .s EqGroupDr=$o(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode),0))
 .if $g(EqGroupDr)="" s RetStr=..RetErrorValue(RetStr,"取设备组指针出错"_Equipment)
 .if ((ChangeType'="Test")) d
 ..k PLIST
 ..if $g(EqGroupDr)'="" s PLIST(4)=EqGroupDr
	..S PLIST(2)=EquipmentCode,PLIST(3)=Equipment,PLIST(5)=+$H
 ..&SQL(INSERT INTO SQLUSER.RBC_Equipment VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Equipment -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
 q:$g(EqId)="" ..RetErrorValue(RetStr,"取设备指针出错"_Equipment)
 if '$d(^RB("RES",0,"EQ",EqId,CtLocId)) d
 .s EquipmentId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),0))
 .if $g(EquipmentId) s RetStr=..RetErrorValue(RetStr,"取设备指针出错"_Equipment)
 .q:$g(EquipmentId)=""
 .s EquipmentCode=$p(^RBC("EQ",EquipmentId),del,1)
 .if $d(^RB("RES",0,"LocDesc",CtLocId,$$ALPHAUP^SSUTIL4(Equipment))) 
 .if ((ChangeType'="Test")) d
 ..k PLIST
	..s PLIST(3)=CtLocId,PLIST(5)=EqId,PLIST(7)=EquipmentCode,PLIST(8)=Equipment,PLIST(11)=-1,PLIST(16)=999
	..s PLIST(19)="Equipment",PLIST(20)="Y",PLIST(21)="Y"
	..if $d(^RB("RES",0,"LocDesc",CtLocId,$$ALPHAUP^SSUTIL4(Equipment))) d
	...&sql(update SQLUser.RB_Resource set RES_EQ_DR=:EqId,RES_Code=:EquipmentCode WHERE RES_CTLOC_DR=:CtLocId AND RES_DESC=:Equipment)
	..else  d
	...&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
	s RbId=$o(^RB("RES",0,"EQ",EqId,CtLocId,""))
	q:RbId="" ..RetErrorValue(RetStr,"资源计划中没有相应的记录"_Equipment)
	s RbDId="" 
	s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",+$h,RbDId))
	if (($g(RbDId)="")&(ChangeType'="Test")) d 
	.k PLIST
	.s PLIST(0)=RbId,PLIST(3)=+$h
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDate VALUES :PLIST())
	i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	;q DateStr_"^"_RowStr
	s:RbDId="" RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",+$h,0))
 q:Week="" "排班日期为空"_CtLocCode
	s CircleFlag=1,RbDSId=0
	for  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	.s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	.s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4)
	.if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.if CircleFlag=0 s RetStr=..RetErrorValue(RetStr,"记录已经存在"_Equipment_"星期"_Week)
	q:CircleFlag=0 RetStr
	if (ChangeType'="Test") d
	.k PLIST
	.s PLIST(0)=RbId_"||"_$g(RbDId),PLIST(4)=StartTime,PLIST(5)=EndTime,PLIST(8)=TotalNum
	.s PLIST(10)=Week
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDateSession VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSession -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q RetStr
}

ClassMethod ICD(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    IcdCode1    IcdCode2  IcdDesc  Alia
	;
	IF ChangeType="Clear" K ^MRC("ID")
	q:ChangeType="Clear" "Icd数据已经清除"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S Code=$P(RowStr,del,1),IcdCode1=$P(RowStr,del,2),IcdCode2=$P(RowStr,del,3),IcdDesc=$P(RowStr,del,4),Alias=$P(RowStr,del,5)
	
	if ((Code'="")&(IcdCode1'="")&(IcdDesc'="")) d
	.IF $D(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"代码已经存在Mrc_Icddx:"_Code) q
	.IF $D(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(IcdDesc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在Mrc_Icddx:"_IcdDesc)
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=IcdDesc,PLIST(6)=IcdCode1,PLIST(8)=+$h-1,PLIST(45)=IcdCode2
	..&SQL(INSERT INTO SQLUser.Mrc_Icddx VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"Mrc_Icddx -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	..q:$g(SQLCODE)
 ..s MrId=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 ..i Alias'="" d
 ...set I=1
 ...k PLIST 
 ...s PLIST(0)=MrId
 ...s num=$l(Alias,"/")
 ...s ALI=""
 ...FOR I=1:1:num d
 ....s ALI=$p(Alias,"/",I)
 ....s ALI=$$ALPHAUP^SSUTIL4(ALI)
 ....q:$d(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(ALI),MrId))
 ....if ChangeType'="Test" d
 .....set PLIST(3)=ALI
 .....&SQL(INSERT INTO SQLUser.MRC_ICDAlias VALUES PLIST()) 
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"MRC_ICDAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 Q RetStr
}

ClassMethod ICDTEMPLETE(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    IcdCode1    IcdCode2  IcdDesc  Alia
	;
	IF ChangeType="Clear" K ^DHCLocDiagnoseI,^DHCLocDiagnose
	q:ChangeType="Clear" "Icd模板数据已经清除"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S CtLocCode=$P(RowStr,del,1),IcdCode1=$P(RowStr,del,3),IcdDesc=$P(RowStr,del,4)
	s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	Q:$g(CtLocId)="" ..RetErrorValue(RetStr,"科室代码为空Ct_loc:"_CtLocCode)
	s IcdId=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(IcdDesc),""))
	q:$g(IcdId)="" ..RetErrorValue(RetStr,"ICD指针出错MRC_ICDDX:"_IcdDesc_" "_IcdCode1)
	s LocDiaId="",CircleFlag=1
	f  s LocDiaId=$o(^DHCLocDiagnoseI("Location",CtLocId,LocDiaId)) q:((LocDiaId="")!(CircleFlag=0))  d
	.s IcdIdTmp=$p(^DHCLocDiagnose(LocDiaId),del,2)
	.if IcdIdTmp=LocDiaId s CircleFlag=0
	if ((CircleFlag'=0)&(ChangeType'="Test")) d
	.k PLIST
	.S PLIST(2)=CtLocId,PLIST(3)=LocDiaId
	.&SQL(INSERT INTO SQLUser.DHC_LocDiagnose VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_LocDiagnose -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	Q RetStr
}

ClassMethod ManuFacturer(ChangeType As %String = "", RowStr As %String = "") As %String
{
 //产地与供应商
 Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	IF ChangeType="Clear" K ^PHMNF
	q:ChangeType="Clear" "数据已清:供应商和产地"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 s code=$p(RowStr,del,5),desc=$p(RowStr,del,5),pinyin=$p(RowStr,del,4)
 s pinyin=$e(pinyin,1,5)
 i pinyin'="" s desc=pinyin_"-"_desc
 if ((code'="") & (pinyin'="")) d
 .if code="" s RetStr=..RetErrorValue(RetStr,"名称不能为空APC_VENDOR:")
 .i $d(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在APC_VENDOR:"_code)
 .i $d(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在APC_VENDOR:"_code)
 .i (('$d(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(code))))&('$d(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(desc))))) d 
 ..if ChangeType'="Test" d
 ...s Para=code_del_desc
 ...ZN MEDDATA
 ...s MRetStr=$$ApcVendor^DHCFHQIMP(Para)
 ...ZN CurrentNS
 ...s RetStr=..RetErrorValue(RetStr,MRetStr)
 //增加产地
 s code=$p(RowStr,del,2),desc=$p(RowStr,del,2),pinyin=$p(RowStr,del,1)
 if ((code'="") & (pinyin'="")) d
 .i pinyin'="" s desc=pinyin_"-"_desc
 .if code="" s RetStr=..RetErrorValue(RetStr,"名称不能为空PH_Manufacturer:")
 .i $d(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在PH_Manufacturer:"_code)
 .i $d(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在PH_Manufacturer:"_desc)
 .i (('$d(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(code))))&('$d(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(desc))))) d 
 ..if ChangeType'="Test" d
 ...K PLIST
 ...s PLIST(7)=code,PLIST(2)=desc
 ...&sql(INSERT INTO SQLUSER.PH_Manufacturer VALUES :PLIST())
 ...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PH_Manufacturer -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod OrdCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	;Exel Field :
	;  *1*-------*2*-----3-----4*----------------5---------6------7------8---------9-------10---
	;  code^Category^SubCode^SubCategory(desc)^执行类型  type   result  calqty 接收科室  病人所在科室
	;PLIST:
	;  -(2)------(3)------------(9)-----(8)-   PLIST(10)       PLIST(12)
	; PLIST(8): Drug(R),Diet(D),IV(I),Consultation(C),Normal(N),Dental(T),LabTrak(L),
	;           RehabMedicine(X),Price(P)
	; PLIST(12): Required - Calculate Qty Flag
	; *** CAUTION: IND NUMber ***
	;

	IF ChangeType="Clear" K ^OEC("ORCAT"),^ARC("IC")
	q:ChangeType="Clear" "数据已清:医嘱大类和医嘱子类"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	
	S Desc=$P(RowStr,del,2)
	if $g(^OEC("ORCAT",0))="" s Code=1
	if $g(^OEC("ORCAT",0))'="" s Code=$g(^OEC("ORCAT",0))+1
	Q:Code="" ..RetErrorValue(RetStr,"医嘱大类代码为空OEC_ORDERCATEGORY")
	q:Desc="" ..RetErrorValue(RetStr,"医嘱大类名称为空OEC_ORDERCATEGORY")
	s OrdCatPatLoc=$P(RowStr,del,3),OrdCatRLoc=$P(RowStr,del,4)
	if ((Code'="")&(Desc'="")) d
	.;if $D(^OEC("ORCAT",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"医嘱大类代码已经存在OEC_ORDERCATEGORY") q
	.;IF $D(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) s RetStr=..RetErrorValue(RetStr,"医嘱大类名称已经存在OEC_ORDERCATEGORY") q
	.Q:$D(^OEC("ORCAT",0,"Code",$$ALPHAUP^SSUTIL4(Code)))
	.Q:$D(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) 
	.if ChangeType'="Test" d
	..K PLIST
	..S PLIST(2)=Code,PLIST(3)=Desc
	..&SQL(INSERT INTO SQLUser.OEC_ORDERCATEGORY VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"OEC_ORDERCATEGORY -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s OrdCatDr=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),""))
	//医嘱大类接收科室
	if ((Code'="")&(Desc'="")) d
	.q:(($g(OrdCatPatLoc)="")&($g(OrdCatRLoc)=""))
	.s OrdCatRlocId=0
	.if $g(OrdCatDr)'="" d
	..q:$d(^OEC("ORCAT",OrdCatDr,"RL"))
	..IF ((OrdCatRLoc="各个病房")&(ChangeType'="Test"))  D
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="各个科室")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((OrdCatRLoc'="各个病房")&((OrdCatRLoc'="各个科室"))&(ChangeType'="Test")) d
	...SET I=1,j=1
	...FOR  SET RLOC=$P(OrdCatRLoc,"/",j) Q:RLOC=""  D
	....s j=j+1
	....q:RLOC=""
	....q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	....SET RLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	....if RLOCDR="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错OEC_ORDERCATEGORY "_RLOC) q
	....IF ((OrdCatPatLoc="各个病房")&(ChangeType'="Test")) D
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......q:($P(^CTLOC(WardId),del,13)'="W")
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....
	....s PatLocDr=""
	....IF ((OrdCatPatLoc="各个科室")&(ChangeType'="Test")) D
	.....f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:RLocDr=""  d
	......k PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=PatLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="全部科室")&(ChangeType'="Test")) D
	.....k PLIST
	.....s PLIST(6)="Y"
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc'="各个病房")&(OrdCatPatLoc'="全部科室")&(OrdCatPatLoc'="各个科室")) D
	.....
	.....SET PLOC=$P(OrdCatPatLoc,"/",j-1) 
	.....s ^fhq(j)=PLOC_"^"_RLOC
	.....if ((PLOC="全部科室")!(PLOC="*")) d
	......
	.....else  d
	......SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	......if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错OEC_ORDERCATEGORY "_Desc_" "_PLOC) q
	.....if ChangeType'="Test" d
	.....K PLIST
	.....s:(I=1) PLIST(6)="Y"
	.....s:PLOC'="*" PLIST(4)=PLOCDR
	.....if PLOC="全部科室" k PLIST(4)
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_PLOC_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..SET I=I+1
	
	;医嘱子类
	S SubCode=$P(RowStr,del,5),SubDesc=$P(RowStr,del,6)
	if $g(^ARC("IC",0))="" s SubCode=1
	if $g(^ARC("IC",0))'="" s SubCode=$g(^ARC("IC",0))+1
	Q:SubCode="" ..RetErrorValue(RetStr,"医嘱子类代码为空ARC_ItemCat")
	q:SubDesc="" ..RetErrorValue(RetStr,"医嘱子类名称为空ARC_ItemCat")
	SET CodeDr=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),"")) 
	q:CodeDr="" ..RetErrorValue(RetStr,"取医嘱大类名称指针出错ARC_ItemCat")
	s ORDTYPE=$$ALPHAUP^SSUTIL4($p(RowStr,del,8))
	q:ORDTYPE="" ..RetErrorValue(RetStr,"医嘱类型为空ARC_ItemCat"_SubCode)
	s ORDERTYPEDR=$s(ORDTYPE["DRUG":"R",ORDTYPE["DIET":"D",ORDTYPE["IV":"I",ORDTYPE["CONS":"C",ORDTYPE["NORM":"N",ORDTYPE["DENT":"T",ORDTYPE["LABT":"L",ORDTYPE["REHA":"X",ORDTYPE["PRIC":"P",1:"Z") 
	q:ORDERTYPEDR="Z" ..RetErrorValue(RetStr,"取医嘱类型出错ARC_ItemCat"_SubDesc_","_ORDTYPE)

	s RESULT=$P(RowStr,del,7)
	q:RESULT ..RetErrorValue(RetStr,"医嘱执行类型为空ARC_ItemCat "_RESULT)
	if RESULT'="" s RESULTDR=$o(^OEC("EXEC",0,"Desc",$$ALPHAUP^SSUTIL4(RESULT),"")) 
	q:RESULTDR="" ..RetErrorValue(RetStr,"取执行类型出错ARC_ItemCat "_SubCode_","_$g(RESULT))
	s CALQTY=$P(RowStr,del,100)
	s:$g(CALQTY)="" CALQTY=""
	s:(($g(CALQTY)'="Y")&(CALQTY'="N")) CALQTY="N"
	IF ($D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode)))&('$D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc))))) s RetStr=..RetErrorValue(RetStr,"嘱子类编码已经存在ARC_ItemCat"_SubCode)
	IF ($D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc)))&('$D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))))) s RetStr=..RetErrorValue(RetStr,"嘱子类名称已经存在ARC_ItemCat"_SubDesc)
	
	if ((ChangeType'="Test")&('$D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc))))&('$D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))))) d
	.k PLIST
	.s PLIST(2)=SubCode,PLIST(3)=SubDesc,PLIST(9)=CodeDr,PLIST(8)=ORDERTYPEDR,PLIST(10)=RESULTDR,PLIST(12)=CALQTY
	.&SQL(INSERT INTO SQLUser.ARC_ItemCat VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_ItemCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱子类接收科室
	s RecLoc=$P(RowStr,del,11),PatLoc=$P(RowStr,del,10)
	q:(($g(RecLoc)="")&($g(PatLoc)="")) RetStr
	SET SubCatDr=$O(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc),""))
	q:SubCatDr="" ..RetErrorValue(RetStr,"医嘱子类指针出错ARC_ITEMCATRECLOC "_SubCode)
	;q:RecLoc="" ..RetErrorValue(RetStr,"接收科室为空ARC_ITEMCATRECLOC "_SubCode)
	;Q:PatLoc="" ..RetErrorValue(RetStr,"病人科室为空ARC_ITEMCATRECLOC "_SubCode)
	
	SET WardId=$O(^CTLOC(0)),I=1
	IF ((RecLoc="各个病房")&(ChangeType'="Test"))  D
	.FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	..q:($P(^CTLOC(WardId),del,13)'="W")
	..K PLIST
	..s PLIST(6)="Y"
	..SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	s RLocDr=""
	IF ((RecLoc="各个科室")&(ChangeType'="Test"))  D
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	..k PLIST
	..s PLIST(6)="Y"
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	IF ((RecLoc'="各个病房")&((RecLoc'="各个科室"))&(ChangeType'="Test")) d
	.SET I=1,j=1
	.FOR  SET RLOC=$P(RecLoc,"/",j) Q:RLOC=""  D
	..s j=j+1
	..q:RLOC=""
	..q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	..SET RLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	..if RLOCDR="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC) q
	..IF ((PatLoc="各个病房")&(ChangeType'="Test")) D
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..
	..s PatLocDr=""
	..IF ((PatLoc="各个科室")&(ChangeType'="Test")) D
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:RLocDr=""  d
	....k PLIST
	....s:(I=1) PLIST(6)="Y"
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="全部科室")&(ChangeType'="Test")) D
	...k PLIST
	...s:(I=1) PLIST(6)="Y"
	...SET PLIST(0)=SubCatDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc'="各个病房")&(PatLoc'="全部科室")&(PatLoc'="各个科室")) D
	...SET PLOC=$P(PatLoc,"/",j-1) 
	...if ((PLOC="全部科室")!(PLOC="*")) d
	...else  d
	....SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	....if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错ARC_ITEMCATRECLOC "_SubDesc_" "_PLOC) q
	...if ChangeType'="Test" d
	....K PLIST
	....s PLIST(6)="Y"
	....s:PLOC'="*" PLIST(3)=PLOCDR
	....if PLOC="全部科室" k PLIST(3)
	....SET PLIST(0)=SubCatDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_PLOC_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..SET I=I+1
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod OrdSet(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" k ^ARCOS
	q:ChangeType="Clear" "数据已清:医嘱项"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
 s OrdSetCode=$p(RowStr,del,1),OrdSetDesc=$p(RowStr,del,2),Alias=$p(RowStr,del,3)
 s OrdSetCat=$p(RowStr,del,4),OrdSetCatSub=$p(RowStr,del,5)
 s ArcCode=$p(RowStr,del,6),ArcDesc=$p(RowStr,del,7)
 q:OrdSetDesc="" ..RetErrorValue(RetStr,"医嘱套名称为空:")
 q:ArcCode="" ..RetErrorValue(RetStr,"医嘱代码为空:")
 if $g(^ARCOS(0))="" s OrdSetCode=1
 if $g(^ARCOS(0))'="" s OrdSetCode=$g(^ARCOS(0))+1
 if ((OrdSetCode'="")&(OrdSetDesc'="")) d
 .Q:($D(^ARCOS(0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetDesc))))
 .if (('$D(^ARCOS(0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetDesc))))&('$D(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(OrdSetCode))))) d
 ..if $g(OrdSetCatSub)="" s RetStr=..RetErrorValue(RetStr,"医嘱套子类为空:"_OrdSetDesc)
 ..q:OrdSetCatSub=""
 ..s OrdSetCatSubDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetCatSub),0))
 ..if $g(OrdSetCatSubDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套子类指针为空:"_OrdSetDesc_" "_SubDesc)
 ..q:OrdSetCatSubDr=""
 ..s OrdSetCatDr=$p(^ARC("IC",OrdSetCatSubDr),del,8)
 ..if $g(OrdSetCatDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套大类指针出错")
 ..q:OrdSetCatDr=""
 ..if ChangeType'="Test" d
	...K PLIST
	...S PLIST(2)=OrdSetCode,PLIST(4)="Y",PLIST(6)=OrdSetDesc,PLIST(16)=OrdSetCatDr,PLIST(17)=OrdSetCatSubDr,PLIST(25)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_OrdSets VALUES :PLIST())
	...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSets -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q
	...Q:$g(%ROWID)=""
	...s OrdSetId=$g(%ROWID)
	...Q:$D(^ARCOS(OrdSetId,"DATE",0))
	...K PLIST
	...S PLIST(0)=OrdSetId,PLIST(3)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_OrdSetDate VALUES :PLIST())
	...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSetDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q
	s OrdSetId=$o(^ARCOS(0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetDesc),""))
	q:$g(OrdSetId)="" ..RetErrorValue(RetStr,"取医嘱套指针出错"_OrdSetDesc)
	q:$G(ArcCode)="" ..RetErrorValue(RetStr,"医嘱项代码为空"_ArcCode)
	s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),0))
	q:$g(ArcimId1)="" ..RetErrorValue(RetStr,"医嘱项指针出错"_ArcCode)
	s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcimId1,0))
	q:$g(ArcimId2)="" ..RetErrorValue(RetStr,"医嘱项指针2出错"_ArcCode)
	s ArcimId=ArcimId1_"||"_ArcimId2
	S OrdSetDateId=$o(^ARCOS(OrdSetId,"DATE",""),-1)
	if $g(OrdSetDateId)="" d
	.K PLIST
	.S PLIST(0)=OrdSetId,PLIST(3)=+$H
	.&SQL(INSERT INTO SQLUser.ARC_OrdSetDate VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSetDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q
	.s OrdSetDateId=$g(%ROWID)
	Q:$g(OrdSetDateId)="" ..RetErrorValue(RetStr,"取医嘱套日期表出错"_OrdSetDesc)
 s CircleFlag=1,OrdSetDateItmId=""
 f  s OrdSetDateItmId=$o(^ARCOS(OrdSetId,"DATE",OrdSetDateId,"ITM",OrdSetDateItmId)) q:((OrdSetDateItmId="")!(CircleFlag=0))  d
 .s ArcimIdTmp=$p(^ARCOS(OrdSetId,"DATE",OrdSetDateId,"ITM",OrdSetDateItmId),del,1)
 .if ArcimId=ArcimIdTmp s CircleFlag=0
 if CircleFlag'=0 d
 .K PLIST
 .s PLIST(0)=OrdSetId_"||"_OrdSetDateId,PLIST(3)=ArcimId,PLIST(4)=1,PLIST(7)="Y"
 .&SQL(INSERT INTO SQLUser.ARC_OrdSetDateItem VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSetDateItem -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q

	//别名
 i Alias'="" d
 .set I=1
 .s num=$l(Alias,"/")
 .s ALI=""
 .FOR I=1:1:num d
 ..s ALI=$p(Alias,"/",I)
 ..;q:$d(^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdSetDesc)))
 ..s AliaId=$o(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdSetDesc),""))
 ..S ArcosId=""
 ..if $G(AliaId)'="" S ArcosId=$p(^ARC("ALIAS",AliaId),del,2)
 ..q:($g(OrdSetId)=$g(ArcosId))
 ..q:OrdSetCatSub=""
 ..s OrdSetCatSubDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetCatSub),0))
 ..if $g(OrdSetCatSubDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套子类指针为空:"_OrdSetDesc_" "_SubDesc)
 ..q:OrdSetCatSubDr=""
 ..s OrdSetCatDr=$p(^ARC("IC",OrdSetCatSubDr),del,8)
 ..if $g(OrdSetCatDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套大类指针出错")
 ..q:OrdSetCatDr=""
 ..if ChangeType'="Test" d
 ...q:$g(ALI)=""
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...k PLIST 
 ...s PLIST(3)=OrdSetId,PLIST(5)=OrdSetDesc,PLIST(6)=OrdSetCatSubDr,PLIST(14)=+$h
 ...set PLIST(4)=$p(Alias,"/",I)
 ...if $G(AliaId)'="" D
 ....&SQL(UPDATE SQLUser.ARC_Alias SET ALIAS_ARCOS_DR=:OrdSetId WHERE ALIAS_ROWID=:AliaId) 
 ...ELSE  D
 ....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcKeyId=0,CircleFlag=1
 ...f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCOS",OrdSetId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 ....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 ....if ALI=ArcKey s CircleFlag=0,ArcKeyIdTmp=ArcKeyId
 ...k PLIST 
 ...s PLIST(3)=OrdSetId,PLIST(5)=OrdSetDesc,PLIST(6)=OrdSetCatSubDr,PLIST(7)=OrdSetCatDr
 ...set PLIST(4)=$p(Alias,"/",I)
 ...if (CircleFlag=0) d
 ....&SQL(update SQLUser.ARC_ItemKeywords set KEYW_ARCOS_DR=:OrdSetId where KEYW_RowId=:ArcKeyIdTmp)
 ...else  d
 ....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	 q RetStr
}

ClassMethod PacBed(ChangeType As %String = "", RowStr As %String = "") As %String
{
 //^PAC("BEDTP"),^PAWARD({PAC_Ward.WARD_RowID},"BED",{BED_Childsub})  PAC_BEDTYPE,PAC_BED
	//1 护理站名称	2 床位名称	3 床位类型	4 房间	5房间类型	6不同性别同一房间 7是否预留房间
	//set RowStr="护理站名称^床位名称^床位类型^房间^房间类型^不同性别同一房间^是否预留房间"
	//s ChangeType="Test"
	if ChangeType="Clear" d
	.K ^PAC("BEDTP")
	.s PARID=0
	.FOR  SET PARID=$O(^PAWARD(PARID)) Q:PARID=""  D 
	..K ^PAWARD(PARID,"BED")
	q:ChangeType="Clear" "数据已清:床位类型和床位"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s BEDTYPE=$P(RowStr,del,3)
	Q:BEDTYPE="" "床位类型为空"
	if '$D(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(BEDTYPE))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=BEDTYPE,PLIST(3)=BEDTYPE,PLIST(4)="Y"
	..//&SQL(INSERT INTO SQLUSER.PAC_BEDTYPE VALUES PLIST())
	//Q:$g(SQLCODE)  s RetStr=..RetErrorValue(RetStr,"PAC_BEDTYPE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 SET LOC=$P(RowStr,del,1),BEDNO=$P(RowStr,del,2),ROOM=$P(RowStr,del,4)
	Q:LOC="" ..RetErrorValue(RetStr,"科室为空")
	q:BEDNO="" ..RetErrorValue(RetStr,"床号为空") 
	q:ROOM="" ..RetErrorValue(RetStr,"房间为空") 
	SET LOCDR=$O(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(LOC),""))
	Q:LOCDR="" ..RetErrorValue(RetStr,"科室出错:"_LOC) 

	SET BEDTYPEDR=$O(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(BEDTYPE),""))
	q:BEDTYPEDR="" ..RetErrorValue(RetStr,"床位类型出错:"_BEDTYPE)
	SET ROOMDR=$O(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(ROOM),""))
	q:ROOMDR="" ..RetErrorValue(RetStr,"房间出错:"_ROOM) 
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(0)=LOCDR,PLIST(3)=ROOMDR,PLIST(4)=BEDNO,PLIST(9)=BEDTYPEDR,PLIST(13)="Y"
	.&SQL(INSERT INTO SQLUSER.PAC_BED VALUES PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PAC_BED -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PacRoom(ChangeType As %String = "", RowStr As %String = "") As %String
{
 ; -1-----2--------3---------4---------5--------6
	  ; LOC   BED     BEDTYPE    ROOM    ROOMTYPE  SEX
	if ChangeType="Clear" K ^PAC("ROOMT"),^PAROOM
	q:ChangeType="Clear" "数据已清:房间类型和房间"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	Set ROOM=$P(RowStr,del,4),ROOMTYPE=$P(RowStr,del,5)
	Q:ROOMTYPE="" ..RetErrorValue(RetStr,"房间类型为空")
	IF '$D(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(ROOMTYPE))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=ROOMTYPE,PLIST(3)=ROOMTYPE
	..&SQL(INSERT INTO SQLUSER.PAC_ROOMTYPE VALUES PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PAC_ROOMTYPE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	Set ROOM=$P(RowStr,del,4),ROOMTYPE=$P(RowStr,del,5),DIFSEX=$E($P(RowStr,del,6),1,1)
	q:ROOM="" ..RetErrorValue(RetStr,"房间为空")
	SET ROOMTYPEDR=$O(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(ROOMTYPE),""))
	q:ROOMTYPEDR="" ..RetErrorValue(RetStr,"取房间类型指针出错:"_ROOMTYPEDR)
	if '$D(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(ROOM))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=ROOM,PLIST(3)=ROOM,PLIST(7)=ROOMTYPEDR,PLIST(8)=DIFSEX
	..&SQL(INSERT INTO SQLUSER.PAC_ROOM VALUES PLIST())
	..if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PAC_ROOM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PatInfo(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" 
	q:ChangeType="Clear" "病人信息请手工清除"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s CardNo=$P(RowStr,del,1),CardType=$P(RowStr,del,2),PatNo=$P(RowStr,del,3),Name=$P(RowStr,del,4),Sex=$P(RowStr,del,5)
	s Dob=$P(RowStr,del,6),PaperType=$P(RowStr,del,7),Id=$P(RowStr,del,8),MrOutp=$P(RowStr,del,9),MrInp=$P(RowStr,del,10)
	s TelH=$P(RowStr,del,11),PatType=$P(RowStr,del,12),Country=$P(RowStr,del,13)
	s Province=$P(RowStr,del,14),City=$P(RowStr,del,15),County=$P(RowStr,del,16),PostNo=$P(RowStr,del,17)
	S WorkUnit=$P(RowStr,del,18),Adress=$P(RowStr,del,19)
	s CardType="注册医疗卡-1"
	S Country="ZG-"_Country
	//q:$g(CardNo)="" "卡号为空"
	s CardNo=##class(web.DHCFBCM).ConvertStr(CardNo_"^0^15")
	;IF '$d(^DHCCARDi("CF",0,"CardNo",CardNo)) S ^FHQ1=$I(^FHQ1)
	q:$d(^DHCCARDi("CF",0,"CardNo",CardNo)) "卡号已经存在"_CardNo 
	;Q ""
	s PatNo=$i(^PAPER(0,"CNT","I"))
	if PatNo<30000 s PatNo=30000,^PAPER(0,"CNT","I")=30000
	s PatNo=##class(web.DHCFBPat).ConvertPatNo(PatNo)
	//s ^FHQ(PatNo)=RowStr
	//if $l(RowStr,"?")>1 S ^FHQ(PatNo)=RowStr
	//q "" 
	q:$g(PatNo)="" "病人登记号为空"_PatNo
	q:$g(Name)="" "病人姓名为空"_PatNo
	q:$g(Sex)="" "性别为空"_PatNo
	q:$g(PatType)="" "病人类别为空"_PatNo
	
	q:$d(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo))) "登记号已经存在"
	if (($l(RowStr,"^男^")<2)&($l(RowStr,"^女^")<2))  S ^FHQ(PatNo)=RowStr 
	//IF $L(Name,"?")>1 S ^FHQ(PatNo)=RowStr 
	Q:(($l(RowStr,"^男^")<2)&($l(RowStr,"^女^")<2)) "性别出错"_CardNo
	s Dob=$e(Dob,1,10)
	if (Dob<"1841-01-01") s Dob="1841-01-01"
	s Dob=$zdh(Dob,3)
	s Sex=$o(^CT("SEX",0,"Desc",$$ALPHAUP^SSUTIL4(Sex),""))
	q:Sex="" "取性别指针出错"_PatNo
	if $g(PatType)'="" d
	.s PatType=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(PatType),""))
	.s:$g(PatType)="" RetStr=..RetErrorValue(RetStr,"病人类型指针出错:"_PatNo)
	if $g(Country)'="" d 
	.s Country=$o(^CT("COU",0,"Desc",$$ALPHAUP^SSUTIL4(Country),""))
	.S:$g(Country)="" RetStr=..RetErrorValue(RetStr,"取国家指针出错:"_PatNo)
	if $g(Province)'="" d
	.s Province=$o(^CT("PROV",0,"Desc",$$ALPHAUP^SSUTIL4(Province),""))
	.s:$g(Province)="" RetStr=..RetErrorValue(RetStr,"取省份指针出错:"_PatNo)
	if $g(City)'="" d
	.s City=$o(^CT("CIT",0,"Desc",$$ALPHAUP^SSUTIL4(City),""))
	.s:$g(City)="" RetStr=..RetErrorValue(RetStr,"取省份指针出错:"_PatNo)
	//s:$g(County)'="" County=$o(^CT("CIT",0,"Desc",$$ALPHAUP({CTCIT_Desc}))
	if $g(PostNo)'="" d
	.s PostNo=$o(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(PostNo),""))
	.s:$g(PostNo)="" RetStr=..RetErrorValue(RetStr,"取邮编指针出错:"_PatNo)
	if ChangeType'="Test" d
	.K PLIST
	.S PLIST(8)=PatNo,PLIST(9)=PatNo
	.if $g(PaperType)'="" d
	..if PaperType="身份证" s PaperType="身份证-1"
	..if PaperType="军官证" s PaperType="军官证-1"
	..s:PaperType="身份证-1" PLIST(3)=Id
	..s PaCardTypeDr=$o(^PAC("CARD",0,"Desc",$$ALPHAUP^SSUTIL4(PaperType),""))
	.s:$g(PaCardTypeDr)="" RetStr=..RetErrorValue(RetStr,"取证件类型针出错:"_PaperType)
	.;q:$g(PaCardTypeDr)="" 
	.s PaCardTypeDr=$g(PaCardTypeDr)
	.s PLIST(114)=PaCardTypeDr,PLIST(113)=$g(Id)
	.s PLIST(4)=Name,PLIST(120)=Country,PLIST(124)=Province,PLIST(140)=City
	.s PLIST(11)=Dob
	.s PLIST(15)=Sex,PLIST(125)=MrOutp,PLIST(98)=MrInp,PLIST(129)=WorkUnit
	.&sql(insert into SQLUSER.Pa_PatMas VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_" Pa_PatMatmas -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.S PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	.if PatId="" s RetStr=..RetErrorValue(RetStr,"没有找到病人登记号"_PatNo) q
	.&sql(Update SQLUSER.Pa_Person set PAPER_TelH=:TelH,PAPER_Zip_Dr=:PostNo,PAPER_Country_dr=:Country,PAPER_SocialStatus_DR=:PatType where PAPER_ROWID=:PatId)
	.s:$g(Adress)'="" ^PAPER(PatId,"PER","ADD",0)=1,^PAPER(PatId,"PER","ADD",1)=Adress
	.s CardNo1=PatNo
	.if $d(^DHCCARDi("CF",0,"CardNo",CardNo1)) s RetStr=..RetErrorValue(RetStr,"卡号已经存在"_CardNo1) q
	.s CardTypeDrTmp=0,Flag=1,CardTypeDr=""
	.f  s CardTypeDrTmp=$o(^DHCCARDTYPEDef(CardTypeDrTmp)) q:((CardTypeDrTmp="")!(Flag'=1))  d
	..s CardDesc=$p(^DHCCARDTYPEDef(CardTypeDrTmp),"^",2)
	..if CardDesc="登记号" s Flag=0,CardTypeDr=CardTypeDrTmp
	.;if $g(CardTypeDr)="" s RetStr=..RetErrorValue(RetStr,"卡类型出错?登记号") q
	.k PLIST
	.S PLIST(3)=CardNo1,PLIST(5)=PatId,PLIST(7)=PatNo,PLIST(11)="N",PLIST(17)=CardTypeDr
	.s PLIST(8)=$h-1,PLIST(9)=22,PLIST(10)=1,PLIST(12)=$h-1
	.;&sql(insert into SQLUSER.DHC_CardRef VALUES :PLIST())   //把登记号做为卡号
	.;i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_"DHC_CardRef -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.q:$g(CardNo)=""
	.s CardNo1=CardNo,PLIST(3)=CardNo1
	.if $d(^DHCCARDi("CF",0,"CardNo",CardNo1)) s RetStr=..RetErrorValue(RetStr,"卡号已经存在"_CardNo1) q
	.s CardTypeDrTmp=0,Flag=1,CardTypeDr=""
	.f  s CardTypeDrTmp=$o(^DHCCARDTYPEDef(CardTypeDrTmp)) q:((CardTypeDrTmp="")!(Flag'=1))  d
	..s CardDesc=$p(^DHCCARDTYPEDef(CardTypeDrTmp),"^",2)
	..if CardDesc=CardType s Flag=0,CardTypeDr=CardTypeDrTmp
	.if $g(CardTypeDr)="" s RetStr=..RetErrorValue(RetStr,"卡类型出错"_CardType) q
	.s PLIST(17)=CardTypeDr
	.&sql(insert into SQLUSER.DHC_CardRef VALUES :PLIST())   //卡号
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_"DHC_CardRef -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PatInfoAdd() As %String
{
 s Ind = 0, del = "^"
 K ^FHQIQIQ0109("INSERT")
 f  s Ind=$o(^FHQIQIQ0109(Ind)) q:Ind=""  d
 .s TmpStr=^FHQIQIQ0109(Ind)
 .s RetStr=..PatInfo("Append",TmpStr)
 .S ^FHQIQIQ0109("INSERT")=$I(^FHQIQIQ0109("INSERT"))
 .q:((RetStr="") ! (RetStr="Ok"))
 .
 .s PatNo=$p(TmpStr,"^",1)
 .s ^ErrText(PatNo)=RetStr
 q ""
}

ClassMethod PatInfoUp(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" 
	q:ChangeType="Clear" "病人信息请手工清除"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s CardNo=$P(RowStr,del,1),CardType=$P(RowStr,del,2),PatNo=$P(RowStr,del,3),Name=$P(RowStr,del,4),Sex=$P(RowStr,del,5)
	s Dob=$P(RowStr,del,6),PaperType=$P(RowStr,del,7),Id=$P(RowStr,del,8),MrOutp=$P(RowStr,del,9),MrInp=$P(RowStr,del,10)
	s TelH=$P(RowStr,del,11),PatType=$P(RowStr,del,12),Country=$P(RowStr,del,13)
	s Province=$P(RowStr,del,14),City=$P(RowStr,del,15),County=$P(RowStr,del,16),PostNo=$P(RowStr,del,17)
	S WorkUnit=$P(RowStr,del,18),Adress=$P(RowStr,del,19)
	//q:$g(CardNo)="" "卡号为空"
	s CardNo=##class(web.DHCFBCM).ConvertStr(CardNo_"^0^12")
	s PatNo=##class(web.DHCFBPat).ConvertPatNo(PatNo)
	q:$g(PatNo)="" "病人登记号为空"_PatNo
	q:$g(Name)="" "病人姓名为空"_PatNo
	q:'$d(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo))) "登记号不存在"
	if ChangeType'="Test" d
	.S PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	.&sql(update SQLUSER.Pa_PatMas set PAPMI_Name=:Name where PAPMI_ROWID=:PatId)
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_" Pa_PatMatmas -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.s:$d(^PAPER(rid,"PER","ADD",0)) ^PAPER(rid,"PER","ADD",1)=Adress
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PhcCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----*3-----
	;    CAT    SubCat  MinCat 
 IF ChangeType="Clear" K ^PHCC
	q:ChangeType="Clear" "数据已清:药理学分类"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	;"insert table phc_cat begin"

	S CAT=$P(RowStr,del,1),SubCat=$P(RowStr,del,2),MINORSubCat=$P(RowStr,del,3)
	q:CAT="" "药理学大类为空PHC_Cat"
	IF '$D(^PHCC(0,"Code",$$ALPHAUP^SSUTIL4(CAT))) d 
	.IF ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=CAT,PLIST(3)=CAT
	..&SQL(INSERT INTO SQLUSER.PHC_Cat VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_Cat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	;"PHC_SubCat BEGIN"
	S CATDR=$O(^PHCC(0,"Code",$$ALPHAUP^SSUTIL4(CAT),""))
	q:CATDR="" RetStr=..RetErrorValue(RetStr,"取药理学大类指针出错:"_CAT)
	q:SubCat="" "药理学子类为空PHC_SubCat"
	IF '$D(^PHCC("SC_Code",$$ALPHAUP^SSUTIL4(SubCat))) d
	.IF ChangeType'="Test" d
	.K PLIST
	.S PLIST(0)=CATDR,PLIST(2)=SubCat,PLIST(3)=SubCat
	.&SQL(INSERT INTO SQLUSER.PHC_SubCat VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_SubCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	;"PHC_MINORSubCat BEGIN"
	q:MINORSubCat="" ..RetErrorValue(RetStr,"药理学小类为空PHC_MinorSubCat")
	S SubCatDR=$O(^PHCC("SC_Code",$$ALPHAUP^SSUTIL4(SubCat),CATDR,""))
	q:SubCatDR="" ..RetErrorValue(RetStr,"取药理学子类指针出错:"_SubCat)
	q:$D(^PHCC("MIN_Code",$$ALPHAUP^SSUTIL4(MINORSubCat),CATDR,SubCatDR)) ..RetErrorValue(RetStr,"取药理学小类已经存在:"_MINORSubCat) 
	IF ChangeType'="Test" d
	.K PLIST 
	.S PLIST(0)=CATDR_"||"_SubCatDR,PLIST(3)=MINORSubCat,PLIST(4)=MINORSubCat
	.&SQL(INSERT INTO SQLUSER.PHC_MinorSubCat VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_MinorSubCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PhcForm(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    DESC   
	IF ChangeType="Clear" K ^PHCF
	q:ChangeType="Clear" "数据已清:药品剂型"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET CODE=$P(RowStr,del,1),DESC=CODE
	Q:CODE="" "编码为空"
	Q:$D(^PHCF(0,$$ALPHAUP^SSUTIL4(CODE))) "编码已经存在"_CODE
	Q:$D(^PHCF(0,$$ALPHAUP^SSUTIL4(DESC))) "名称已经存在"_CODE
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=CODE,PLIST(3)=DESC
	.&SQL(INSERT INTO SQLUSER.PHC_FORM VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PH_Manufacturer -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PhcPoison(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*---
	;    Name
 IF ChangeType="Clear" K ^PHCPO
	q:ChangeType="Clear" "数据已清:药理学分类"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	S Desc=$P(RowStr,del,1)
	q:Desc="" "管理分类为空PHC_Cat"
	IF '$D(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(Desc))) d 
	.IF ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Desc,PLIST(3)=Desc
	..&SQL(INSERT INTO SQLUSER.PHC_Poison VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_Poison -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
}

/// 预约号的单位
ClassMethod PreUnit(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	IF ChangeType="Clear" K ^RBC("APTM")
	q:ChangeType="Clear" "数据已清:预约单位"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	Q:Code="" "编码为空"
	Q:Desc="" "名称为空"
	Q:$D(^RBC("APTM",0,"Code",$$ALPHAUP^SSUTIL4(Code))) "编码已经存在"_Code
	Q:$D(^RBC("APTM",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) "编码已经存在"_Desc
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)="N",PLIST(5)=$h-2
	.&SQL(INSERT INTO SQLUSER.RBC_AppointMethod VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_AppointMethod -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod RbSessionType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	IF ChangeType="Clear" K ^RBC("SESS")
	q:ChangeType="Clear" "数据已清:出诊类别"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	Q:Code="" "编码为空"
	Q:$D(^RBC("SESS",0,"Code",$$ALPHAUP^SSUTIL4(Code))) "编码已经存在"_Code
	Q:$D(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(Code))) "名称已经存在"_Code
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Code,PLIST(7)=$h-2
	.&SQL(INSERT INTO SQLUSER.RBC_SessionType VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_SessionType -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod RetErrorValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

ClassMethod SSGroup(ChangeType As %String = "", RowStr As %String = "") As %String
{
	q:ChangeType="Clear" "数据已清:库存分类和盘点分类"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,1)
	q:$g(Code)="" ""
	if ((Code'="") & (Desc'="")) d
	.s UserGroupDr="",GroupId=0,CircleFlag=1
	.f  s GroupId=$o(^SSU("SSGRP",GroupId)) q:((GroupId="")!(CircleFlag'=1))  d
	..s GroupName=$p(^SSU("SSGRP",GroupId),"^",1)
	..if GroupName=Code s CircleFlag=0  q
	.if CircleFlag=0 s RetStr=..RetErrorValue(RetStr,"安全组已经存在SS_User:"_GroupName) q
	.if ChangeType'="Test" d
 ..K PLIST
 ..s PLIST(3)=Code
 ..&SQL(INSERT INTO SQLUSER.SS_Group VALUES :PLIST())
 ..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"SS_Group -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q:RetStr="" "Ok"
 q RetStr
}

/// 医生出诊排班表
ClassMethod Schedule(ChangeType As %String = "", RowStr As %String = "", Para As %String) As %String
{
	
	IF ChangeType="Clear" d
	.s rid=0
	.for  s rid=$o(^RB("RES",rid)) q:rid=""  d
	..k ^RB("RES",rid,"DATE")
	..k ^RB("RES",rid,"Date")
	..;&SQL(delete from SQLUSER.DHC_RBResEffDateSessAppQty)
	q:ChangeType="Clear" "数据已清:医生排班表"
	s del="^",RetStr=""
	s DateStr=$p(Para,del,1)
	if $g(DateStr)'="" S DateStr=$ZDH(DateStr,4)
	if $g(DateStr)="" s DateStr=$h-1
	SET RowStr=$tr(RowStr," ","")
	//科室代码 科室名称	医生代码  医生名称	星期	开始日间	结束时间	每人看诊时间	出诊限额	可预约数	
	//预约起始号	加号限额  诊室	出诊级别	亚专业	限额单位	限额
	s CtLoc=$p(RowStr,del,2),CareCode=$p(RowStr,del,3),CareName=$p(RowStr,del,4),Week=$p(RowStr,del,5),StartTime=$p(RowStr,del,6)
	s EndTime=$p(RowStr,del,7),PerTime=$p(RowStr,del,8),TotalNum=$p(RowStr,del,9),PreNum=$p(RowStr,del,10)
	s PreStar=$p(RowStr,del,11),AddNum=$p(RowStr,del,12),Room=$p(RowStr,del,13),Grade=$p(RowStr,del,16)
	s Specialty=$p(RowStr,del,17),LimitUnit=$p(RowStr,del,18),LimitNum=$p(RowStr,del,19)
	q:CtLoc="" "科室代码为空"_CareCode
	q:CareCode="" "医生代码为空"_CareCode
	q:Week="" "排班日期为空"_CareCode
	;q:Room="" "诊室为空"_CareCode
	s:StartTime="" StartTime="07:00:00"
	s StartTime=$zth(StartTime)
	s:EndTime="" EndTime="17:00:00"
	s EndTime=$zth(EndTime)
	s RangeTimeDr="1"
	if StartTime'<$zth("12:30:00") s RangeTimeDr="2"
	s CtLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	q:CtLoc="" ..RetErrorValue(RetStr,"取科室指针出错"_CareCode_" "_CareName)
	if Room'="" s Room=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Room),""))
	;q:Room="" ..RetErrorValue(RetStr,"取诊间指针出错"_CareCode_" "_CareName)
	s CareDr=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CareCode),""))
	q:CareDr="" ..RetErrorValue(RetStr,"取人员指针出错"_CareCode_" "_CareName)
	S:$G(Grade)'="" GradeDr=$O(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(Grade),0))
	S:$G(GradeDr)="" RetStr=..RetErrorValue(RetStr,"出诊类别指针出错"_CareCode)
	S GradeDr=$G(GradeDr)
	IF $G(Specialty)'="" D
	.S Specialty=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Specialty),0)) 
	.S:Specialty="" RetStr=..RetErrorValue(RetStr,"取亚专业指针出错"_CareCode)
	s RbId=$o(^RB("RES",0,"CTPCP",CareDr,CtLoc,""))
	q:RbId="" ..RetErrorValue(RetStr,"资源计划中没有相应的记录"_CareCode)
	s RbDId="" 
	k PLIST
	s PLIST(0)=RbId,PLIST(3)=DateStr
	s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateStr,RbDId))
	
	if $g(RbDId)="" d 
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDate VALUES :PLIST())
	i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	;q DateStr_"^"_RowStr
	s:RbDId="" RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateStr,0))
	k PLIST
	s PLIST(0)=RbId_"||"_$g(RbDId),PLIST(3)=RangeTimeDr,PLIST(4)=StartTime,PLIST(5)=EndTime,PLIST(7)=PerTime,PLIST(8)=TotalNum
	s PLIST(9)=PreNum,PLIST(10)=Week,PLIST(11)=GradeDr,PLIST(16)=AddNum,PLIST(21)=Room,PLIST(23)=PreStar,PLIST(37)=Specialty
	s CircleFlag=1,RbDSId=0,CircleFlagRoom=1
	for  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	.s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	.s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4)
	.if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.q:Room=""
	.s id1=0   //同一诊室同一时间不能坐两个人
	.s CircleFlagRoom=1
	.
	.for  s id1=$o(^RB("RES",0,"SESSRoom",Room,id1)) q:((id1="")!(CircleFlagRoom'=1))  d
	..;s id2=$o(^RB("RES",0,"SESSRoom",Room,id1,""),-1) 
	..s id2=$o(^RB("RES",id1,"DATE",0,"Date",DateStr,""))
	..q:$g(id2)=""
	..s id3=""
	..f  s id3=$o(^RB("RES",0,"SESSRoom",Room,id1,id2,id3)) q:((id3="")!(CircleFlagRoom'=1))  d
	...s Str=$g(^RB("RES",id1,"DATE",id2,"SESS",id3))
	...s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4),RoomTmp=$p(Str,del,19)
	...if ((SWeek=Week)&(SStartTime=StartTime)&(RoomTmp=Room)) d
	....s CareId1=$p(^RB("RES",id1),del,2)
	....if ($g(CareId1)'="")  D
	.....IF ($D(^CTPCP(CareId1,1))) s CareCode1=$p(^CTPCP(CareId1,1),del,1),CareName1=$p(^CTPCP(CareId1,1),del,2)
	....s CircleFlagRoom=0
	q:(CircleFlagRoom'=1) ..RetErrorValue(RetStr,"同一诊室同一诊不能两个人 "_CareCode_" "_CareName_" "_CareCode1_" "_CareName1_" 星期"_Week)
	if $g(RbDSId1)'="" s RetStr=..RetErrorValue(RetStr,"记录已经存在 "_CareCode_" "_CareName_" 星期"_Week)
	if $g(RbDSId1)=""  d
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDateSession VALUES :PLIST())
	.i $g(SQLCODE)'=0 s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSession -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.if $g(%ROWID)'=""  d
	..s RbDSId1=%ROWID
	..S Services=$P(RowStr,del,19)
	..q:Services=""
	..s CircleNum=$l(Services,"/"),i=0
	..f  s i=i+1 q:(i>CircleNum)  d
	...s Service=$P(Services,"/",i)
	...q:$g(Service)=""
	...s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),""))
	...s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_Code)
	...q:ArcimId1=""
	...s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),ArcimId1,""))
	...s ArcimId=ArcimId1_"||"_ArcimId2
	...S ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	...s RbcServiceId=0,CircleFlag=1,RbcSerId=""
	...f  s RbcServiceId=$o(^RBC("SER",0,"CTCP",CareDr,RbcServiceId)) q:((RbcServiceId="")!(CircleFlag'=1))  d
	....s TmpStr=$g(^RBC("SER",RbcServiceId))
	....s:($p(TmpStr,del,1)=ArcimId) CircleFlag=0,RbcSerId=RbcServiceId
	...;if $g(RbcSerId)="" d  //如果没有相应的服务就增加一个
	....;s ServiceGroup=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	....;s:ServiceGroup="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_Code)
	....;q:ServiceGroup=""
	....;k PLIST
	....;S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(5)=CareDr,PLIST(7)=$g(Service),PLIST(10)=ServiceGroup,PLIST(11)="Y",PLIST(13)=$H-1
	....;&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	....;if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	....;s RbcSerId=$g(%ROWID)
	...;s:RbcSerId="" RetStr=..RetErrorValue(RetStr,"没有找到相应的服务"_CareCode_" 星期:"_Week_" "_Service)
	...;q:RbcSerId=""
	...;K PLIST
	...;;s PLIST(0)=RbId_"||"_$g(RbDId)_"||"_RbDSId1
	...;s PLIST(0)=RbDSId1
	...;s PLIST(3)=RbcSerId
	...;S PLIST(8)=ArcimDesc
	...;&SQL(INSERT INTO SQLUSER.RB_ResEffDateSessServices VALUES :PLIST())
	...;i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSessServices -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	//不同单位的预约限额
	s i=1
	for  s Unit=$p(LimitUnit,"/",i) q:Unit=""  d
	.s UnitId=$o(^RBC("APTM",0,"Desc",$$ALPHAUP^SSUTIL4(Unit),0))
	.s Num=$p(LimitNum,"/",i)
	.s i=i+1
	.if UnitId="" s RetStr=..RetErrorValue(RetStr,"取单位指针出错RB_cappointmethod:"_CareCode)  q
	.if Num="" s RetStr=..RetErrorValue(RetStr,"取数量出错SS_USER:"_CareCode) q
	.s CircleFlag=1,RbDSId=0
	.f  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	..s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	..s RbDSId1=""
	..s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4),SEndTime=$p(Str,del,5)
	..if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.q:$g(RbDSId1)=""
	.S PLIST(2)=RbId
	.s PLIST(3)=$g(RbDId)
	.s PLIST(4)=RbDSId1 
	.s PLIST(6)=UnitId 
	.s PLIST(7)=Num
	.&SQL(INSERT INTO SQLUSER.DHC_RBResEffDateSessAppQty VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_RBResEffDateSessAppQty -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod SetGloble(RowStr) As %String
{
	s TmpStr=RowStr
	q:TmpStr="" ""
	s num=$l(TmpStr,"^"),i=0
	;f  s i=i+1 q:(i>num)  d
	;.s Str=$p(TmpStr,"^",i)
	;.s Str=$p(Str,"@")
	;.s $p(TmpStr,"^",i)=Str 
	S PatNo=$p(TmpStr,"^")
	S ^FHQIQIQ("DATA")=$I(^FHQIQIQ("DATA"))
	s ^FHQIQIQ0109(PatNo)=TmpStr
	Q ""
}

ClassMethod SetStrToGloble(RowStr, UpType) As %String
{
	s RetStr="",del="^"
	s TmpStr=RowStr
	q:TmpStr="" ""
	S ^TMPFHQ(UpType,0)=$I(^TMPFHQ(UpType,0))
	S ^TMPFHQ(UpType,^TMPFHQ(UpType,0))=TmpStr
	Q ""
}

ClassMethod StockType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" K ^INC("SC"),^INC("TG")
	q:ChangeType="Clear" "数据已清:库存分类和盘点分类"
	s RetStr="",del="^"
	;INC_STKCAT ^INC("SC")  库存分类
	SET RowStr=$tr(RowStr," ","")
	SET CODE=$P(RowStr,del,1),DESC=$P(RowStr,del,2)
	if ((CODE'="") & (DESC'="")) d
	.i $d(^INC("SC",0,"Code",$$ALPHAUP^SSUTIL4(CODE))) s RetStr=..RetErrorValue(RetStr,"编码已经存在INC_STKCAT:"_CODE) 
 .i $d(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(DESC))) s RetStr=..RetErrorValue(RetStr,"名称已经存在INC_STKCAT:"_DESC)
 .i (('$d(^INC("SC",0,"Code",$$ALPHAUP^SSUTIL4(CODE))))&('$d(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(DESC))))) d 
 ..if ChangeType'="Test" d
 ...K PLIST
 ...s PLIST(2)=CODE,PLIST(3)=DESC
 ...&SQL(INSERT INTO SQLUSER.INC_STKCAT VALUES :PLIST())
 ...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"INC_STKCAT -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	; ^INC("TG"), INC_STKTKGP  盘点分类
	SET CODE=$P(RowStr,del,4),DESC=$P(RowStr,del,5)
	s ^fhqaa=CODE_"^"_DESC
	if ((CODE'="") & (DESC'="")) d
	.i $d(^INC("TG",0,"INCTG_Code",$$ALPHAUP^SSUTIL4(CODE))) s RetStr=..RetErrorValue(RetStr,"编码已经存在INC_STKTKGP:"_CODE) 
 .i $d(^INC("TG",0,"INCTG_Desc",$$ALPHAUP^SSUTIL4(DESC))) s RetStr=..RetErrorValue(RetStr,"名称已经存在INC_STKTKGP:"_DESC)
 .i (('$d(^INC("TG",0,"INCTG_Code",$$ALPHAUP^SSUTIL4(CODE))))&('$d(^INC("TG",0,"INCTG_Desc",$$ALPHAUP^SSUTIL4(DESC))))) d 
 ..if ChangeType'="Test" d
 ...K PLIST
 ...s PLIST(2)=CODE,PLIST(3)=DESC
 ...&SQL(INSERT INTO SQLUSER.INC_STKTKGP VALUES :PLIST())
 ...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"INC_STKTKGP -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q:RetStr="" "Ok"
	q RetStr
}

ClassMethod TarType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    SUBCODE  
	;
	IF ChangeType="Clear" d 
	.K ^ARCBG,^DHCTarC("AC"),^DHCTarC("CC"),^DHCTarC("EC"),^DHCTarC("IC"),^DHCTarC("MC"),^DHCTarC("OC"),^DHCTarC("SC")
	.k ^mdata("DHCTARAC"),^mdata("DHCTARCATE"),^mdata("DHCTAREC"),^mdata("DHCTARIC"),^mdata("DHCTARMC"),^mdata("DHCTAROC"),^mdata("DHCTARSUBCATE")
	.k ^DHCTarC("TAC"),^DHCTarC("TEC"),^DHCTarC("TIC"),^DHCTarC("TMC"),^DHCTarC("TOC")
	.k ^mdata("DHCTARACCTCATE"),^mdata("DHCTAREMCCATE"),^mdata("DHCTARINPATCATE"),^mdata("DHCTARMRCATE"),^mdata("DHCTAROUTPATCATE")
	q:ChangeType="Clear" "数据已清:帐单组,费用类别,住院发票,门诊发票,核算类,会计类,病案类"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S Code=$P(RowStr,del,1),SubCode=$P(RowStr,del,2)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在ARC_BillGrp:"_Code)
	.if ((ChangeType'="Test")&('$D(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code,PLIST(4)=Code
	..&SQL(INSERT INTO SQLUser.ARC_BillGrp VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_BillGrp -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
 .;"ARC_BILLSUB BEGIN" 
	.S CodeDr=$O(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取帐单指针出错ARC_BILLSUB:"_Code) q
	.IF $D(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在ARC_BILLSUB:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(0)=CodeDr,PLIST(3)=SubCode,PLIST(4)=SubCode,PLIST(5)=SubCode
	..&SQL(INSERT INTO SQLUser.ARC_BILLSUB VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_BILLSUB -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//收费大类
	S Code=$P(RowStr,del,4),SubCode=$P(RowStr,del,5)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("CC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARCATE:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("CC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARSubCatE BEGIN"
	.S CodeDr=$O(^DHCTarC("CC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取收费大类指针出错DHC_TARSubCatE:"_Code) q
	.IF $D(^DHCTarC("SC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARSubCatE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TARSubCatE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARSubCatE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	//住院发票
	S Code=$P(RowStr,del,7),SubCode=$P(RowStr,del,8)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TIC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARIC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TIC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARIC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARIC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARSubCatE BEGIN"
	.S CodeDr=$O(^DHCTarC("TIC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取住院大类指针出错DHC_TARINPATCATE:"_Code) q
	.IF $D(^DHCTarC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARINPATCATE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TARINPATCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARINPATCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//门诊发票
	S Code=$P(RowStr,del,10),SubCode=$P(RowStr,del,11)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TOC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TAROC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TOC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TAROC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TAROC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARSubCatE BEGIN"
	.S CodeDr=$O(^DHCTarC("TOC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取门诊大类指针出错DHC_TarOutpatCate:"_Code) q
	.IF $D(^DHCTarC("OC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TarOutpatCate:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TarOutpatCate VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TarOutpatCate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	//核算分类
	S Code=$P(RowStr,del,13),SubCode=$P(RowStr,del,14)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TEC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TAREC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TEC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TAREC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TAREC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TAREMCCATE BEGIN"
	.S CodeDr=$O(^DHCTarC("TEC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取核算大类指针出错DHC_TAREMCCATE:"_Code) q
	.IF $D(^DHCTarC("EC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TAREMCCATE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TAREMCCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TAREMCCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//会计科目
	S Code=$P(RowStr,del,16),SubCode=$P(RowStr,del,17)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TAC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARAC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TAC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARAC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARAC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARACCTCATE BEGIN"
	.S CodeDr=$O(^DHCTarC("TAC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取会计科目大类指针出错DHC_TARACCTCATE:"_Code) q
	.IF $D(^DHCTarC("AC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARACCTCATE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TARACCTCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARACCTCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//病案分类
	S Code=$P(RowStr,del,19),SubCode=$P(RowStr,del,20)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TMC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARMC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TMC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARMC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARMC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TarMrCate BEGIN"
	.S CodeDr=$O(^DHCTarC("TMC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取会计科目大类指针出错DHC_TarMrCate:"_Code) q
	.IF $D(^DHCTarC("MC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TarMrCate:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TarMrCate VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TarMrCate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	s ^DHCTarC("AC",0)=^mdata("DHCTARAC")
	s ^DHCTarC("CC",0)=^mdata("DHCTARCATE")
	s ^DHCTarC("EC",0)=^mdata("DHCTAREC"),^DHCTarC("IC",0)=^mdata("DHCTARIC"),^DHCTarC("MC",0)=^mdata("DHCTARMC")
	s ^DHCTarC("OC",0)=^mdata("DHCTAROC"),^DHCTarC("SC",0)=^mdata("DHCTARSUBCATE")
	s ^DHCTarC("TAC",0)=^mdata("DHCTARACCTCATE"),^DHCTarC("TEC",0)=^mdata("DHCTAREMCCATE"),^DHCTarC("TIC",0)=^mdata("DHCTARINPATCATE")
	s ^DHCTarC("TMC",0)=^mdata("DHCTARMRCATE"),^DHCTarC("TOC",0)=^mdata("DHCTAROUTPATCATE")
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UPPat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s CardNo=$P(RowStr,del,1),Name=$P(RowStr,del,2)
	s CardType="注册医疗卡-1"
	q:$g(CardNo)="" "卡号为空"
	s CardNo=##class(web.DHCFBCM).ConvertStr(CardNo_"^0^15")
	;IF '$d(^DHCCARDi("CF",0,"CardNo",CardNo)) S ^FHQ1=$I(^FHQ1)
	if $d(^DHCCARDi("CF",0,"CardNo",CardNo)) d
	.s CfId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
 .s PapmiId=$p(^DHCCARD("CF",CfId),del,4)
 .q:($g(PapmiId)="")
 .&sql(update sqluser.pa_patmas set papmi_name=:Name where papmi_rowid=:PapmiId)
 Q ""
}

ClassMethod UpCareSpec(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    spec   
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Spec=$P(RowStr,del,2)
	q:Code="" "编码为空"
	q:Spec="" "专长为空"
	s CtCareId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:$g(CtCareId)="" "医护人员不存在"_Code
	s CtSpecId=$o(^CT("SPC",0,"Desc",$$ALPHAUP^SSUTIL4(Spec),""))
	q:$g(CtSpecId)="" "取专长指针出错"_Spec
	&SQL(update SQLUSER.CT_CareProv set CTPCP_Spec_DR=:CtSpecId where CTPCP_RowId=:CtCareId)
	if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UpCtloc() As %String
{
	s RetStr="",del="^"
	s rid=0
	for  s rid=$o(^CTLOC(rid)) q:rid=""  d
	.if $d(^CTLOC(rid,"ADDR",0))  d
	..s Addr=^CTLOC(rid,"ADDR",1)
	..s $p(^CTLOC(rid),del,16)=Addr
	..w $p(^CTLOC(rid),del,16),!
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UpData(ChangeType As %String = "", RowStr As %String = "", UpType As %String = "", Para As %String = "") As %String
{
	
	q:UpType=""
	s RetStr=""
	if Para'=""  d
	.s DateStr=$p(Para,"^")
	else  d
	.s DateStr=""
	TS
	s:UpType="CTGROUP" RetStr=..CtGroup(ChangeType,RowStr)
	s:UpType="CTLOC" RetStr=..CtLoc(ChangeType,RowStr)
	s:UpType="CTSPEC" RetStr=..CtSpecialty(ChangeType,RowStr)
	s:UpType="CARETYPE" RetStr=..CareType(ChangeType,RowStr)
	s:UpType="CtSpec" RetStr=..CtSpec(ChangeType,RowStr)
	
	s:UpType="CTPROV" RetStr=..CareData(ChangeType,RowStr)
	s:UpType="UpCareSpec" RetStr=..UpCareSpec(ChangeType,RowStr)
	s:UpType="CTUOM" RetStr=..CtUom(ChangeType,RowStr)
	s:UpType="MANUFACTURER" RetStr=..ManuFacturer(ChangeType,RowStr)
	s:UpType="PHCFORM" RetStr=..PhcForm(ChangeType,RowStr)
	s:UpType="STOCKTYPE" RetStr=..StockType(ChangeType,RowStr)
	s:UpType="PHCCAT" RetStr=..PhcCat(ChangeType,RowStr)
	s:UpType="PhcPoison" RetStr=..PhcPoison(ChangeType,RowStr)
	//s:UpType="TARPAYSELF" RetStr=..TarPaySelf(ChangeType,RowStr)
	s:UpType="OECCAT" RetStr=..OrdCat(ChangeType,RowStr)
	
	//s:UpType="PHCINSTRUC" RetStr=..PhcInstruc(ChangeType,RowStr)
	s:UpType="PACROOM" RetStr=..PacRoom(ChangeType,RowStr)
	s:UpType="PACBED" RetStr=..PacBed(ChangeType,RowStr)
	s:UpType="DRUG" RetStr=..DrugData(ChangeType,RowStr)
	s:UpType="DrugDataGen" RetStr=..DrugDataGen(ChangeType,RowStr)
	
	s:UpType="TARTYPE" RetStr=..TarType(ChangeType,RowStr)
	s:UpType="ARCITM" RetStr=..ArcimData(ChangeType,RowStr)
	s:UpType="OrdSet" RetStr=..OrdSet(ChangeType,RowStr)
	s:UpType="UPARCITM" RetStr=..ArcimDataUp(ChangeType,RowStr)
	s:UpType="ArcimAlias" RetStr=..ArcimAlias(ChangeType,RowStr)
	
	;s:UpType="PatInof" RetStr=..PatInfo(ChangeType,RowStr)
	;s:UpType="PatInof" RetStr=..SetGloble(RowStr)
	s:UpType="PatInof" RetStr=..UPPat(ChangeType,RowStr)
	s:UpType="RBSessType" RetStr=..RbSessionType(ChangeType,RowStr)
	s:UpType="PreUnit" RetStr=..PreUnit(ChangeType,RowStr)
	s:UpType="Schedule" RetStr=..Schedule(ChangeType,RowStr,DateStr)
	s:UpType="SSGROUP" RetStr=..SSGroup(ChangeType,RowStr)
	s:UpType="CTTITLE" RetStr=..CtTitle(ChangeType,RowStr)
	s:UpType="UpRoom" RetStr=..UpRoom(ChangeType,RowStr)
	s:UpType="IcdDate" RetStr=..ICD(ChangeType,RowStr)
	s:UpType="EqResource" RetStr=..EqResource(ChangeType,RowStr)
	s:UpType="IcdTemplate" RetStr=..ICDTEMPLETE(ChangeType,RowStr)
	

	//if ChangeType="Test" TROLLBACK  Quit RetStr
	TC
	Q RetStr
}

ClassMethod UpDataBatch(ChangeType As %String = "", UpType As %String = "", DateStr As %String = "") As %String
{
	;d ##class(web.DHCFFHQ).UpDataBatch("Test","Schedule","11/29/2007")
	q:UpType=""
	s del="^",RowNum=0
	Q:($G(^TMPFHQ(UpType,0))<1) "没有数据"
	s RetStr=""
	s DateStr=$zdh(DateStr,4)
	TSTART
	IF ChangeType="Init" d
	.s ChangeType="Clear"
	.s RowStr=""
	.s:UpType="CTGROUP" RetStr=..CtGroup(ChangeType,RowStr)
	.s:UpType="CTLOC" RetStr=..CtLoc(ChangeType,RowStr)
	.s:UpType="CTSPEC" RetStr=..CtSpecialty(ChangeType,RowStr)
	.s:UpType="CARETYPE" RetStr=..CareType(ChangeType,RowStr)
	.s:UpType="CTPROV" RetStr=..CareData(ChangeType,RowStr)
	.s:UpType="CTUOM" RetStr=..CtUom(ChangeType,RowStr)
	.s:UpType="MANUFACTURER" RetStr=..ManuFacturer(ChangeType,RowStr)
	.s:UpType="PHCFORM" RetStr=..PhcForm(ChangeType,RowStr)
	.s:UpType="STOCKTYPE" RetStr=..StockType(ChangeType,RowStr)
	.s:UpType="PHCCAT" RetStr=..PhcCat(ChangeType,RowStr)
	.//s:UpType="TARPAYSELF" RetStr=..TarPaySelf(ChangeType,RowStr)
	.s:UpType="OECCAT" RetStr=..OrdCat(ChangeType,RowStr)
	.//s:UpType="PHCINSTRUC" RetStr=..PhcInstruc(ChangeType,RowStr)
	.s:UpType="PACROOM" RetStr=..PacRoom(ChangeType,RowStr)
	.s:UpType="PACBED" RetStr=..PacBed(ChangeType,RowStr)
	.s:UpType="DRUG" RetStr=..DrugData(ChangeType,RowStr)
	.s:UpType="ARCITM" RetStr=..ArcimData(ChangeType,RowStr)
	.s:UpType="PatInof" RetStr=..PatInfo(ChangeType,RowStr)
	.s:UpType="RBSessType" RetStr=..RbSessionType(ChangeType,RowStr)
	.s:UpType="PreUnit" RetStr=..PreUnit(ChangeType,RowStr)
	.s:UpType="Schedule" RetStr=..Schedule(ChangeType,RowStr)
	.s:UpType="SSGROUP" RetStr=..SSGroup(ChangeType,RowStr)
	.s:UpType="CTTITLE" RetStr=..CtTitle(ChangeType,RowStr)
	IF ChangeType="Clear" d
	.s ChangeType="Init"
	f  s RowNum=$o(^TMPFHQ(UpType,RowNum)) q:RowNum=""  d
	.s RowStr=^TMPFHQ(UpType,RowNum)
	.s:UpType="CTGROUP" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CtGroup(ChangeType,RowStr))
	.s:UpType="CTLOC" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CtLoc(ChangeType,RowStr))
	.s:UpType="CTSPEC" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CtSpecialty(ChangeType,RowStr))
	.s:UpType="CARETYPE" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CareType(ChangeType,RowStr))
	.s:UpType="CTPROV" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CareData(ChangeType,RowStr))
	.s:UpType="CTUOM" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CtUom(ChangeType,RowStr))
	.s:UpType="MANUFACTURER" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..ManuFacturer(ChangeType,RowStr))
	.s:UpType="PHCFORM" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PhcForm(ChangeType,RowStr))
	.s:UpType="STOCKTYPE" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..StockType(ChangeType,RowStr))
	.s:UpType="PHCCAT" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PhcCat(ChangeType,RowStr))
	.//s:UpType="TARPAYSELF" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..TarPaySelf(ChangeType,RowStr))
	.s:UpType="OECCAT" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..OrdCat(ChangeType,RowStr))
	.//s:UpType="PHCINSTRUC" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PhcInstruc(ChangeType,RowStr))
	.s:UpType="PACROOM" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PacRoom(ChangeType,RowStr))
	.s:UpType="PACBED" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PacBed(ChangeType,RowStr))
	.s:UpType="DRUG" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..DrugData(ChangeType,RowStr))
	.s:UpType="ARCITM" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..ArcimData(ChangeType,RowStr))
	.s:UpType="PatInof" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PatInfo(ChangeType,RowStr))
	.s:UpType="RBSessType" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..RbSessionType(ChangeType,RowStr))
	.s:UpType="PreUnit" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..PreUnit(ChangeType,RowStr))
	.s:UpType="Schedule" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..Schedule(ChangeType,RowStr,DateStr))
	.s:UpType="SSGROUP" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..SSGroup(ChangeType,RowStr))
	.s:UpType="CTTITLE" RetStr=..RetErrorValue(RetStr,"第"_RowNum_"行"_..CtTitle(ChangeType,RowStr))
	if ChangeType="Test" d
	.TROLLBACK
	TCOMMIT
	q RetStr
}

ClassMethod UpRoom(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),PinYin=$P(RowStr,del,3),Floor=$p(RowStr,del,10),Addr=$p(RowStr,del,14)
	s TmpS=$e(PinYin,$l(PinYin)-1,$l(PinYin))
	s Floor=$p(Floor,",",2)
	if (+Floor'=0) s Floor=Floor_"诊室"
	if (Code'="")  d
	.q:$g(Floor)=""
	.i $d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code)))  D
	..s rid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..;&SQL(Update SQLUSER.Ct_Loc set CTLOC_ContactName=:PinYin where CTLOC_ROWID=:rid)
 ..;i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"Ct_Loc -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:($p(^CTLOC(rid),del,16))=""
 ..s FloorTmp=$p(^CTLOC(rid),del,16)
 ..s $p(FloorTmp,",",3)=Floor
 ..s $p(^CTLOC(rid),del,16)=FloorTmp
 ..s ^CTLOC(rid,"ADDR",0)=1,^CTLOC(rid,"ADDR",1)=Addr
 ;q FloorTmp_"^"_Addr
 q:RetStr="" "Ok"
	q RetStr
}

/// 批量建卡 guobaoping
/// 数据格式  卡类型代码^卡类型名称^卡号^姓名^性别^出生日期^联系电话^住址^身份证号^病人类型(CT_SocialStatus表中的SS_Desc)(可以为空,默认自费)^是否绑定其他卡(1为需要绑定)^操作员工号(SS_User中的字段SSUSR_Initials)
/// 01^ 就诊卡^6217582600000011723^张三^男^1982-08-08^18761960795^广西北海市幸福小区幸福苑2幢102号^410203195612220063^自费^1^cashier
ClassMethod NewCard(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET CardTypeCode=$P(RowStr,del,1),CardTypeDesc=$P(RowStr,del,2),CardNo=$P(RowStr,del,3),Name=$P(RowStr,del,4),Sex=$P(RowStr,del,5)
	Set Birth=$P(RowStr,del,6),TelHome=$P(RowStr,del,7),Address=$P(RowStr,del,8),IDCardNo=$P(RowStr,del,9)
	Set PatType=$P(RowStr,del,10),BindFlag=$P(RowStr,del,11),UserCode=$P(RowStr,del,12)
	;1.卡类型合法性检查
	q:(CardTypeCode="")&&(CardTypeDesc="") ..RetErrorValue(RetStr,"卡类型代码和卡代码名称不能为空")
	s CardTypeID=""
	s TmpCardTypeID=0 f  s TmpCardTypeID=$o(^DHCCARDTYPEDef(TmpCardTypeID))  q:(CardTypeID'="")||(TmpCardTypeID="")  d
	.s TmpCardTypeCode=$p(^DHCCARDTYPEDef(TmpCardTypeID),"^")
	.s TmpCardTypeDesc=$p(^DHCCARDTYPEDef(TmpCardTypeID),"^",2)
	.i (CardTypeCode'="")&&(CardTypeCode=TmpCardTypeCode)  s CardTypeID=TmpCardTypeID
	.q:CardTypeID'=""
	.i (CardTypeDesc'="")&&(CardTypeDesc=TmpCardTypeDesc)  s CardTypeID=TmpCardTypeID
	.q:CardTypeID'=""
	q:CardTypeID="" ..RetErrorValue(RetStr,"卡类型无法识别,请核对数据")
	;2.病人信息合法性检查
	;2.1卡号
	q:CardNo="" ..RetErrorValue(RetStr,"卡号不能为空")
	;2.2姓名
	q:Name="" ..RetErrorValue(RetStr,"患者姓名不能为空")
	;2.3性别
	q:Sex="" ..RetErrorValue(RetStr,"性别不能为空")
	s SexId=""
	s SexId=$o(^CT("SEX",0,"Desc",$$ALPHAUP^SSUTIL4(Sex),SexId))
	q:SexId="" ..RetErrorValue(RetStr,"性别不合法")
	;2.4出生日期
	q:Birth="" ..RetErrorValue(RetStr,"出生日期不能为空")
	q:($l(Birth,"-")'=3)||($l(Birth)'=10) ..RetErrorValue(RetStr,"出生日期不合法")
	
	;2.5联系电话
	q:TelHome="" ..RetErrorValue(RetStr,"联系电话不能为空")
	;2.6住址
	;q:Address="" ..RetErrorValue(RetStr,"住址不能为空")
	;2.7身份证号
	q:IDCardNo="" ..RetErrorValue(RetStr,"身份证号不能为空")
	q:($l(IDCardNo)'=15)&&($l(IDCardNo)'=18) ..RetErrorValue(RetStr,"身份证号不合法")
	;2.8 病人类型
	i PatType'="" s PatTypeId=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(PatType),""))
	e  s PatTypeId=$o(^CT("SS",0,"Desc","自费",""))
	q:PatTypeId="" ..RetErrorValue(RetStr,"病人类型不能为空,默认值自费也存在")
	;2.9 操作员
	i UserCode'="" s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	e  s UserId=""
	q:(UserId="")||('$d(^SSU("SSUSR",UserId))) ..RetErrorValue(RetStr,"操作员不能为空")
	s newcardxml=""
	s myObj=##class(web.DHCEntity.PCA.NewCardInfo).%New()
	s myObj.CardTypeRowID=CardTypeID
	s myObj.CardNo=CardNo
	s myObj.Name=Name
	s myObj.Sex=Sex
	s myObj.Birth=Birth
	s myObj.TelHome=TelHome
	s myObj.Address=Address
	s myObj.IDCardNo=IDCardNo
	s myObj.PatType=PatTypeId
	s myObj.BindFlag=BindFlag
	s myObj.UserDR=UserId
	s rtn=myObj.XMLExportToString(.newcardxml,"NewCardInfo")
	i ($system.Status.IsError(rtn)) {
		q ..RetErrorValue(RetStr,"web.DHCEntity.PCA.NewCardInfo初始化异常")
	}
	d myObj.%Close()
	q:newcardxml="" ..RetErrorValue(RetStr,"建卡信息为空")
	if ChangeType'="Test" d
	.b ;newcardxml
	.s rtn=##class(web.DHCDocService).NewCardClass(newcardxml)
	.i rtn'="0" s RetStr=..RetErrorValue(RetStr,##class(web.DHCDocService).GetNewCardErrMsg(rtn))
 	q RetStr
}

}
