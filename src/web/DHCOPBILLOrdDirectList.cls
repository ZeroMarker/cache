Import SQLUser

/// Lid 
/// 2010-05-31
/// 医嘱导引单类
Class web.DHCOPBILLOrdDirectList Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Lid
/// CreatDate:2012-12-06
/// Description:获取导诊单数据(广西北海)
/// Table:DHC_InvPrt,DHC_PatientBill,DHC_BillConInv,OE_OrdItem,ARC_ItmMast,ARC_ItemCat
/// Input:PrtRowid:发票表RowID
/// Output:
/// Return:
/// Other:w ##class(web.DHCOPBILLOrdDirectList).GetDirectListByPrtRowidGXBH("356790")
ClassMethod GetDirectListByPrtRowidGXBH(PrtRowid As %String, ExpStr = "")
{
	New (PrtRowid,ExpStr)
	;医嘱项目^数量^标本^接受科室
	Kill ^TMP($ZN,$j,"D")
	Kill ^TMP($ZN,$j,"PBID")
	;
	Quit:(+PrtRowid=0) ""
    ;病人基本信息
    Set paperDr=$p(^DHCINVPRT(PrtRowid),"^",15)
	Set patNo=$p($g(^PAPER(paperDr,"PAT",1)),"^",1)   ;登记号
	
	Set CardNO=""
	;Set CardInfo=##class(web.UDHCJFBaseCommon).GetCardNOByPAPMI("", paperDr, "")
	;Set CardNO=$p(CardInfo,"^",1)
	Set patName=$p($g(^PAPER(paperDr,"ALL")),"^",1)   ;姓名
	Set patmiId=$p($g(^PAPER(paperDr,"ALL")),"^",9)   ;身份证
	Set sex=$p($g(^PAPER(paperDr,"ALL")),"^",7)       ;性别
	If (sex'="") s sex=$p(^CT("SEX",sex),"^",2)
	Set age=##class(web.DHCBillInterface).GetPapmiAge(paperDr, "")
	;
	;获取中草药配制
	Set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	Set rtn=$p(HerbConfig,$c(2))
	Quit:(rtn) 104   ;配置错误
	Set FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	Set FCHerbDesc=$p(HerbConfig,$c(2),3)
	Set FCHerbNum=$p(HerbConfig,$c(2),4)
	Set FCHerbRange=$p(HerbConfig,$c(2),5)
	;
	Set PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	Set PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	Set PrtDateDesc=$zd(PrtDate,3)
	Set PrtTimeDesc=$zt(PrtTime,1)
	Set PrtUser=$p(^DHCINVPRT(PrtRowid),"^",21)
	Set PrtUserDesc=$p(^SSU("SSUSR",PrtUser),"^",2)
	Set BaseInfo="CardNO"_$c(2)_CardNO_"^"_"PatientNO"_$c(2)_patNo_"^"_"PatientName"_$c(2)_patName_"^"_"Sex"_$c(2)_sex
	Set BaseInfo=BaseInfo_"^"_"Age"_$c(2)_age_"岁"_"^"_"PrtUser"_$c(2)_PrtUserDesc_"^"_"PrtDate"_$c(2)_PrtDateDesc_" "_PrtTimeDesc
	;
	Set FCHerIndex=0, ZJFlagIndex=0
	;
	Set BCIDR="0"
    For  Set BCIDR=$o(^DHCBCI(0,"INV",PrtRowid,BCIDR)) Quit:(BCIDR="")  Do
	.Set Bill=$p(^DHCBCI(BCIDR),"^",2)
	.Set Adm=$p(^DHCBCI(BCIDR),"^",3)   ;就诊Rowid
	.Quit:'$D(^DHCPB(Bill))
	.Set PBO=0 
	.For  Set PBO=$o(^DHCPB(Bill,"O",PBO)) Quit:PBO=""  Do
	..Quit:($d(^DHCPB(Bill,"O",PBO))=10)
	..Set OEORIDR=$p(^DHCPB(Bill,"O",PBO),"^",4)							;医嘱表Rowid
	..Set ARCIMDR=$p(^DHCPB(Bill,"O",PBO),"^",3)							;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
    ..Set PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	..Set RecdepDR=$p($g(^OEORD(+OEORIDR,"I",+$p(OEORIDR,"||",2),3)),"^",6) ;接收科室Rowid
    ..Set LocType=$p(^CTLOC(RecdepDR),"^",13) 
	..if (LocType="") Set LocType="Z"	;放在最后?
	..Set ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	..Set OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	..If OrderType="R" Do
	...;药品
	...Set OrdTypeFlag=1
	..Else  If OrderType="L" Do
	...;检验
	...Set OrdTypeFlag=2
	..Else  Do
	...Set Flag=##class(web.DHCDocHardCoded).IsExamSubCat(ARCIMDR)
	...If +Flag=1 Do
	....;检查
	....Set OrdTypeFlag=3
	...Else  Do
	....;治疗
	....Set OrdTypeFlag=4
	..Set ^TMP($ZN,$j,"PBID",OrdTypeFlag,RecdepDR,Bill_"||"_PBO)=""	;按医嘱分类(顺序:药品->检验->检查->治疗)及接收科室重新建立索引
    ;
	Set myOrdTypeFlag=""
	For  Set myOrdTypeFlag=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag)) Quit:myOrdTypeFlag=""  Do
	.Set:myOrdTypeFlag=1 Str="药品"
	.Set:myOrdTypeFlag=2 Str="化验"
	.Set:myOrdTypeFlag=3 Str="检查"
	.Set:myOrdTypeFlag=4 Str="治疗"
	.Set myRecDR="",RecLocStr=""
	.For  Set myRecDR=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR)) Quit:myRecDR=""  Do
	..Set myPBORID="",OrdStr=""
	..For  Set myPBORID=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR,myPBORID)) Quit:myPBORID=""  Do
	...Set Bill=+myPBORID
	...Set PBO=$p(myPBORID,"||",2)
	...Set OrdTotSum=$fn($p(^DHCPB(Bill,"O",PBO),"^",8),"",2)
	...Set OEORIDR=$p(^DHCPB(Bill,"O",PBO),"^",4)							;医嘱表Rowid
	...Set ARCIMDR=$p(^DHCPB(Bill,"O",PBO),"^",3)							;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
	...Set ArcimDesc=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",2) ;名称
    ...Set PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	...Set RecdepDR=$p($g(^OEORD(+OEORIDR,"I",+$p(OEORIDR,"||",2),3)),"^",6) ;接收科室Rowid
    ...Set RecDepLoc=$p(^CTLOC(RecdepDR),"^",2)
	...If RecDepLoc["-" Set RecDepLoc=$p(RecDepLoc,"-",2)					;接收科室
	...Set RecDepLocPosition=$p($g(^CTLOC(RecdepDR,"ADDR","1")),"^",1)  	;接收科室的物理地址
	...Set LabEpisodeDesc=..GetlabEpisodeDesc(OEORIDR)			;标本类型
    ...Set LocType=$p(^CTLOC(RecdepDR),"^",13) 
	...If LocType="" Set LocType="Z"	;放在最后?
	...Set ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	...Set OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	...Set PackUOMRowid=$p($g(^ARCIM(+ARCIMDR,1,8)),"^",14) ;整包装单位
	...Set OEPrice=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	...Set PackUOM=""
	...If (PackUOMRowid'="")  Do
	....Set PackUOM=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
	...Set Price=$p(^DHCPB(Bill,"O",PBO),"^",7)
	...Set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ARCIMDR, OEORIDR)
	...Set PackQty=$p(^DHCPB(Bill,"O",PBO),"^",5)
	...Set Refundqty=$p(^DHCPB(Bill,"O",PBO),"^",6)			;;OE_OrdItem->OEORI_RefundQty
	...If Refundqty="" Do
	....Set Refundqty=0
	...Set PackQty=+PackQty+Refundqty
	...Set Price=$fn(Price*ConFac,"",3)
	...If (OrderType="R")&(PackQty="") s PackQty=1
	...If ((OrderType="R")&(PackQty'="")) d
	....Set PackQty=PackQty/ConFac
    ...;
    ...If OrderType="R" Do
    ....If (ArcItmCatDR="132")!(ArcItmCatDR="137")!(ArcItmCatDR="142") Do
    .....;针剂
    .....If +FCHerIndex=0 Do
    ......Set ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
    ......Set ind=$g(^TMP($ZN,$j,"D"))
    ......Set ^TMP($ZN,$j,"D",ind)="针剂"_"^"_""_"^"_""_"^"_"急诊药房"
    ......Set FCHerIndex=FCHerIndex+1
    ....Else  If (ArcItmCatDR="135") Do
    .....;草药
    .....If +ZJFlagIndex=0 Do
    ......Set ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
    ......Set ind=$g(^TMP($ZN,$j,"D"))
    ......Set ^TMP($ZN,$j,"D",ind)="中草药"_"^"_""_"^"_""_"^"_"门诊中药房"
    ......Set ZJFlagIndex=ZJFlagIndex+1
    ....Else  Do
    .....;西药 
    .....Set ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
    .....Set ind=$g(^TMP($ZN,$j,"D"))
    .....Set ^TMP($ZN,$j,"D",ind)=ArcimDesc_"^"_PackQty_PackUOM_"^"_""_"^"_"门诊西药房"
    ...Else  Do
    ....;非药品
    ....Set ^TMP($ZN,$j,"D")=$g(^TMP($ZN,$j,"D"))+1
    ....Set ind=$g(^TMP($ZN,$j,"D"))
    ....Set ^TMP($ZN,$j,"D",ind)=ArcimDesc_"^"_PackQty_PackUOM_"^"_LabEpisodeDesc_"^"_"门诊西药房"
    Set List="医嘱项目^数量^标本^接受科室"
    Set Index=""
    For  Set Index=$o(^TMP($ZN,$j,"D",Index)) Quit:Index=""  Do
    .Set ArcimDesc=$p(^TMP($ZN,$j,"D",Index),"^",1)
    .Set ArcimDesc=$e(ArcimDesc,1,12)
    .Set Qty=$p(^TMP($ZN,$j,"D",Index),"^",2)
    .Set LabEpisodeDesc=$p(^TMP($ZN,$j,"D",Index),"^",3)
    .Set ReLoc=$p(^TMP($ZN,$j,"D",Index),"^",4)
    .If List="" Do
    ..Set List=ArcimDesc_"^"_Qty_"^"_LabEpisodeDesc_"^"_ReLoc
    .Else  Do
    ..Set List=List_$c(2)_ArcimDesc_"^"_Qty_"^"_LabEpisodeDesc_"^"_ReLoc
    ;
    Kill ^TMP($ZN,$j,"PBID")
    Kill ^TMP($ZN,$j,"D")
    ;
    Set rtn=BaseInfo_$c(3)_List
    ;
    Quit rtn
}

/// Creator:Lid
/// CreatDate:2011-08-26
/// Description:获取导诊单数据(兰大二院)
/// Table:DHC_InvPrt,DHC_PatientBill,DHC_BillConInv,OE_OrdItem,ARC_ItmMast,ARC_ItemCat
/// Input:PrtRowid:发票表RowID
/// Output:
/// Return:
/// Other:w ##class(web.DHCOPBILLOrdDirectList).GetDirectListByPrtRowidLDEY("178217")
ClassMethod GetDirectListByPrtRowidLDEY(PrtRowid As %String)
{
	n (PrtRowid)
	k ^TMP($ZN,$j,"PBID")
	;
	q:+PrtRowid=0 ""
    ;病人基本信息
    s paperDr=$p(^DHCINVPRT(PrtRowid),"^",15)
	i $d(^PAPER(paperDr,"PAT",1)) d
	.s patNo=$p(^PAPER(paperDr,"PAT",1),"^",1)   ;登记号
	s CardInfo=##class(web.UDHCJFBaseCommon).GetCardNOByPAPMI("",paperDr,"")
	s CardNO=$p(CardInfo,"^",1)
	i $d(^PAPER(paperDr,"ALL")) d
	.s patName=$p(^PAPER(paperDr,"ALL"),"^",1)   ;姓名
	.s patmiId=$p(^PAPER(paperDr,"ALL"),"^",9)   ;身份证
	.s sex=$p(^PAPER(paperDr,"ALL"),"^",7)       ;性别
	.i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	.s (patdob,patageyr,patagemth,patageday,age)=""
	.&sql(select paper_dob,paper_ageyr,paper_agemth,paper_ageday into :patdob,:patageyr,:patagemth,:patageday 
	      from pa_person where paper_rowid=:paperDr)
	.;+2015-3-19 hujunbin 使用年龄统一接口
	.Set age=##Class(web.DHCBillInterface).GetPapmiAge(paperDr,"")
	;
	;获取中草药配制
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	;
	s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	s PrtDateDesc=$zd(PrtDate,3)
	s PrtTimeDesc=$zt(PrtTime,1)
	s PrtUser=$p(^DHCINVPRT(PrtRowid),"^",21)
	s PrtUserDesc=$p(^SSU("SSUSR",PrtUser),"^",2)
	s BaseInfo=CardNO_"^"_patName_"^"_sex_"^"_age_"^"_PrtUserDesc_"^"_PrtDateDesc_" "_PrtTimeDesc
	
	s BCIDR=""
    f  s BCIDR=$o(^DHCBCI(0,"INV",PrtRowid,BCIDR)) Quit:BCIDR=""  d
	.s Bill=$p(^DHCBCI(BCIDR),"^",2)
	.s Adm=$p(^DHCBCI(BCIDR),"^",3)   ;就诊Rowid
	.Quit:'$D(^DHCPB(Bill))
	.Set PBO=0 
	.f  Set PBO=$o(^DHCPB(Bill,"O",PBO)) Quit:PBO=""  Do
	..q:($d(^DHCPB(Bill,"O",PBO))=10)
	..s OEORIDR=$p(^DHCPB(Bill,"O",PBO),"^",4)							;医嘱表Rowid
	..s ARCIMDR=$p(^DHCPB(Bill,"O",PBO),"^",3)							;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
    ..s PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	..s RecdepDR=$p($g(^OEORD(+OEORIDR,"I",+$p(OEORIDR,"||",2),3)),"^",6) ;接收科室Rowid
    ..s LocType=$p(^CTLOC(RecdepDR),"^",13) 
	..i LocType="" s LocType="Z"	;放在最后?
	..s ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	..s OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	..i OrderType="R" d
	...;药品
	...s OrdTypeFlag=1
	..e  i OrderType="L" d
	...;检验
	...s OrdTypeFlag=2
	..e  d
	...s Flag=##class(web.DHCDocHardCoded).IsExamSubCat(ARCIMDR)
	...i +Flag=1 d
	....;检查
	....s OrdTypeFlag=3
	...e  d
	....;治疗
	....s OrdTypeFlag=4
	..s ^TMP($ZN,$j,"PBID",OrdTypeFlag,RecdepDR,Bill_"||"_PBO)=""	;按医嘱分类(顺序:药品->检验->检查->治疗)及接收科室重新建立索引
    ;
    s myOrdTypeFlag="",rtn=""
	f  s myOrdTypeFlag=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag)) q:myOrdTypeFlag=""  d
	.s:myOrdTypeFlag=1 Str="药品"
	.s:myOrdTypeFlag=2 Str="化验"
	.s:myOrdTypeFlag=3 Str="检查"
	.s:myOrdTypeFlag=4 Str="治疗"
	.s myRecDR="",RecLocStr=""
	.f  s myRecDR=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR)) q:myRecDR=""  d
	..s RecDepLoc=$p(^CTLOC(myRecDR),"^",2)
	..i RecDepLoc["-" s RecDepLoc=$p(RecDepLoc,"-",2)					;接收科室
	..s RecDepLocPosition=$p($g(^CTLOC(myRecDR,"ADDR","1")),"^",1)  	;接收科室的物理地址
	..s RecLocPrompt="血常规、尿常规 抽取标本后15分钟现场取结果，其他项目在一楼门诊导诊台取结果。" ;科室注意事项提示
	..s myPBORID="",OrdStr=""
	..f  s myPBORID=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR,myPBORID)) q:myPBORID=""  d
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEORIDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s ARCIMDR=$p(^DHCPB(Bill,"O",Ord),"^",3)
    ...s ProcessingNotes=$p($g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),9)),"^",14) 	;ARCIM_ProcessingNotes草药备注
    ...s RBNotes="",RBIndex="0"
    ...f  s RBIndex=$o(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),"RB",RBIndex)) q:RBIndex=""  d
    ....s RBNote=$g(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),"RB",RBIndex))
    ....s RBNotes=RBNotes_RBNote
	...s OrdTotSum=$fn($p(^DHCPB(Bill,"O",Ord),"^",8),"",2)
	...s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",2) ;名称
	...s ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	...s OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
    ...s PackUOMRowid=$p($g(^ARCIM(+ARCIMDR,1,8)),"^",14) ;整包装单位
	...s OEPrice=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	...s PackUOM=""
	...i PackUOMRowid'=""  d
	....s PackUOM=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
	...s Price=$p(^DHCPB(Bill,"O",Ord),"^",7)
	...s ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ARCIMDR, OEORIDR)
	...s PackQty=$p(^DHCPB(Bill,"O",Ord),"^",5)
	...s Refundqty=$p(^DHCPB(Bill,"O",Ord),"^",6)			;;OE_OrdItem->OEORI_RefundQty
	...i Refundqty="" d
	....s Refundqty=0
	...s PackQty=+PackQty+Refundqty
	...s Price=$fn(Price*ConFac,"",3)
	...i (OrderType="R")&(PackQty="") s PackQty=1
	...i ((OrderType="R")&(PackQty'="")) d
	....s PackQty=PackQty/ConFac
	...i myOrdTypeFlag=1 d
	....;药品
    ....i ((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ArcItmCatDR_"^"))) d
    .....;草药
    .....i +$g(FCHerIndex)=0 d
    ......i OrdStr="" s OrdStr=FCHerbDesc_"^^^^"
    ......e  s OrdStr=OrdStr_"!"_FCHerbDesc_"^^^^"
    .....s FCHerIndex=+$g(FCHerIndex)+1
    ....e  d
    .....;西药、中成药
    .....i OrdStr="" s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum
    .....e  s OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum
    ...i myOrdTypeFlag=2 d
    ....;检验
    ....s PrintBarPosition="" ;打印条码位置
    ....s ReportDate=""			;取报告时间
    ....s ReportPosition=""		;取报告地点
    ....s Prompt=""				;温馨提示
    ....i OrdStr="" s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_"采血地点:"_PrintBarPosition_"^"_"取报告时间:"_ReportDate_"^"_"取报告地点:"_ReportPosition_"^"_"科室:"_RecDepLoc_"  位置:"_RecDepLocPosition
    ....e  s OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_"采血地点:"_PrintBarPosition_"^"_"取报告时间:"_ReportDate_"^"_"取报告地点:"_ReportPosition_"^"_"位置:"_RecDepLoc
    ...i myOrdTypeFlag=3 d
    ....;检查
    ....i OrdStr="" s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_RBNotes_"^"_"科室:"_RecDepLoc_"  位置:"_RecDepLocPosition
    ....e  s OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_RBNotes_"^"_"科室:"_RecDepLoc_"  位置:"_RecDepLocPosition
    ...i myOrdTypeFlag=4 d
    ....;治疗
    ....i OrdStr="" s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_"科室:"_RecDepLoc_"  位置:"_RecDepLocPosition
    ....e  s OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_"科室:"_RecDepLoc_"  位置:"_RecDepLocPosition
    ..i RecLocStr="" s RecLocStr=RecDepLoc_"^"_RecDepLocPosition_"^"_RecLocPrompt_$c(5)_OrdStr
    ..e  s RecLocStr=RecLocStr_$c(4)_RecDepLoc_"^"_RecDepLocPosition_"^"_RecLocPrompt_$c(5)_OrdStr
    .i rtn="" s rtn=Str_$c(3)_RecLocStr
    .e  s rtn=rtn_$c(2)_Str_$c(3)_RecLocStr

    s rtn=BaseInfo_$c(1)_rtn
    k ^TMP($ZN,$j,"PBID")
    ;w rtn
    q rtn
}

/// Creator:Lid
/// CreatDate:2011-08-26
/// Description:获取导诊单数据(北京协和)
/// Table:DHC_InvPrt,DHC_PatientBill,DHC_BillConInv,OE_OrdItem,ARC_ItmMast,ARC_ItemCat
/// Input:PrtRowid:发票表RowID
/// Output:
/// Return:
/// Other:w ##class(web.DHCOPBILLOrdDirectList).GetDirectListByPrtRowidXHOLD("349369")
ClassMethod GetDirectListByPrtRowidXHOLD(PrtRowid As %String, ExpStr As %String = "")
{
	
	n (PrtRowid,ExpStr)
	k ^TMP($ZN,$j,"PBID")
	k ^TMP("DirectList","LabSortIndex",$j)
	k ^TMP("myWinInfo",$j)
	;
	s Group=$p($g(ExpStr),"^",1)
	;s:Group="" Group=$G(%session.Data("LOGON.GROUPID"))
	;
	q:+PrtRowid=0 ""
    ;病人基本信息
    s paperDr=$p($get(^DHCINVPRT(PrtRowid)),"^",15)
    q:paperDr="" ""
	i $d(^PAPER(paperDr,"PAT",1)) d
	.s patNo=$p(^PAPER(paperDr,"PAT",1),"^",1)   ;登记号
	s SocialStatus=$p($g(^PAPER(paperDr,"PER",1)),"^",10)  ;PAPER_SocialStatus_dr
	s SocialStatusDesc=""
	s:SocialStatus'="" SocialStatusDesc=$p(^CT("SS",SocialStatus),"^",2)
	i $d(^PAPER(paperDr,"ALL")) d
	.s patName=$p(^PAPER(paperDr,"ALL"),"^",1)   ;姓名
	.s patmiId=$p(^PAPER(paperDr,"ALL"),"^",9)   ;身份证
	.s sex=$p(^PAPER(paperDr,"ALL"),"^",7)       ;性别
	.i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	.s (patdob,patageyr,patagemth,patageday,age)=""
	.&sql(select paper_dob,paper_ageyr,paper_agemth,paper_ageday into :patdob,:patageyr,:patagemth,:patageday 
	      from pa_person where paper_rowid=:paperDr)
	.;+2015-3-19 hujunbin 使用年龄统一接口
	.Set age=##Class(web.DHCBillInterface).GetPapmiAge(paperDr,"")
	s age=age_" "_SocialStatusDesc
	;
	;获取中草药配制
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s rtn=$p(HerbConfig,$c(2))
	q:rtn 104   ;配置错误
	s FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	s FCHerbDesc=$p(HerbConfig,$c(2),3)
	s FCHerbNum=$p(HerbConfig,$c(2),4)
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	;
	s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	s PrtDateDesc=$zd(PrtDate,3)
	s PrtTimeDesc=$zt(PrtTime,1)
	s PrtUser=$p(^DHCINVPRT(PrtRowid),"^",21)
	s PrtUserDesc=$p(^SSU("SSUSR",PrtUser),"^",1)
	s BaseInfo=patNo_"^"_patName_"^"_sex_"^"_age_"^"_PrtUserDesc_"^"_PrtDateDesc_" "_PrtTimeDesc_"^"_SocialStatusDesc
	;b ;
	s BCIDR=""
    f  s BCIDR=$o(^DHCBCI(0,"INV",PrtRowid,BCIDR)) Quit:BCIDR=""  d
	.s Bill=$p(^DHCBCI(BCIDR),"^",2)
	.s Adm=$p(^DHCBCI(BCIDR),"^",3)   ;就诊Rowid
	.Quit:'$D(^DHCPB(Bill))
	.Set PBO=0 
	.f  Set PBO=$o(^DHCPB(Bill,"O",PBO)) Quit:PBO=""  Do
	..q:($d(^DHCPB(Bill,"O",PBO))=10)
	..s OEORIDR=$p(^DHCPB(Bill,"O",PBO),"^",4)							;医嘱表Rowid
	..s ARCIMDR=$p(^DHCPB(Bill,"O",PBO),"^",3)							;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
    ..s PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	..s RecdepDR=$p($g(^OEORD(+OEORIDR,"I",+$p(OEORIDR,"||",2),3)),"^",6) ;接收科室Rowid
    ..s LocType=$p(^CTLOC(RecdepDR),"^",13) 
	..i LocType="" s LocType="Z"	;放在最后?
	..s ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	..s OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	..;Start Lid 2011-09-03 判断该医嘱的主医嘱是否为药品，如果是药品则不在导诊单上大印
	..s OrdItmType=""
	..s OEORIOEORIDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),11)),"^",39) ;OEORI_OEORI_DR(主医嘱指针)
	..i ((OrderType'="R")&(OEORIOEORIDR'="")) d
	...s OEORIOEORIDRArcimDR=$p($g(^OEORD(+OEORIOEORIDR,"I",$p(OEORIOEORIDR,"||",2),1)),"^",2)
	...s ItmCatDR=$p(^ARCIM(+OEORIOEORIDRArcimDR,$p(OEORIOEORIDRArcimDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	...s OrdItmType=$p(^ARC("IC",ItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	..q:OrdItmType="R"
	..;End
	..q:(Group="183")&(OrderType'="R")	;体检安全组导诊单上只打印药品
	..s LisFlag=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),"DHC")),"^",22)	
	..q:LisFlag'="" 	;过滤检验绑定的医嘱.
	..i OrderType="R" d
	...;药品
	...;判断是否为基数药，如果是则取基数药使用位置(科室)
	...s JSYDepDR=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),"DHC")),"^",36)
	...s JSYFlag="" ;##class(web.DHCSTINTERFACE).ChkOrdBaseMedFlag(PresNo)	;1是基数药，非1不是
	...i JSYFlag=1 s RecdepDR=JSYDepDR
	...;取发药窗口
	...s WinInfo=##class(web.DHCMZYFXTYW02).GetPrtPrescWin(PrtRowid,PresNo)
	...i WinInfo'="" s ^TMP("myWinInfo",$j,RecdepDR)=WinInfo
	...s OrdTypeFlag=1
	..e  i OrderType="L" d
	...;检验
	...s OrdTypeFlag=2
	..e  d
	...s Flag=##class(web.DHCBillHardCoded).IsExamSubCat(ARCIMDR)
	...i +Flag=1 d
	....;检查
	....s OrdTypeFlag=4
	...e  d
	....;治疗
	....s OrdTypeFlag=3
	..s ^TMP($ZN,$j,"PBID",OrdTypeFlag,RecdepDR,Bill_"||"_PBO)=""	;按医嘱分类(顺序:药品->检验->治疗->检查)及接收科室重新建立索引
    .;协和医院 根据Adm取需划价的检查医嘱
    .Set PrescPriceStr=##class(web.DHCOPBILLOrdDirectList).GetPrescPriceOrditem(Adm)
    .For i=1:1:$l(PrescPriceStr,"^") Do
    ..Set PrescPriceOrdItm=$p(PrescPriceStr,"^",i)
    ..Quit:PrescPriceOrdItm="" 
    ..Set ItemStatDR=$p($g(^OEORD(+PrescPriceOrdItm,"I",+$p(PrescPriceOrdItm,"||",2),1)),"^",13)	;OEORI_ItemStat_DR
    ..Set OSTATCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    ..Quit:OSTATCode="D"	;过滤停止医嘱
    ..Set RecdepDR=$p($g(^OEORD(+PrescPriceOrdItm,"I",+$p(PrescPriceOrdItm,"||",2),3)),"^",6) ;接收科室Rowid
    ..;只有检查有划价医嘱
    ..Set ^TMP($ZN,$j,"PBID",4,RecdepDR,"PrescPrice",PrescPriceOrdItm)=""
    ;
    s myOrdTypeFlag="",rtn=""
	f  s myOrdTypeFlag=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag)) q:myOrdTypeFlag=""  d
	.s:myOrdTypeFlag=1 Str="药品"
	.s:myOrdTypeFlag=2 Str="化验"
	.s:myOrdTypeFlag=3 Str="治疗"
	.s:myOrdTypeFlag=4 Str="检查"
	.s myRecDR="",RecLocStr=""
	.f  s myRecDR=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR)) q:myRecDR=""  d
	..s RecDepLoc=$p(^CTLOC(myRecDR),"^",2)
	..s RecDepLocDesc=RecDepLoc
	..i RecDepLoc["-" s RecDepLoc=$p(RecDepLoc,"-",2)					;接收科室
	..s RecDepLocPosition=$p($g(^CTLOC(myRecDR,"ADDR","1")),"^",1)  	;接收科室的物理地址
	..s RecLocPrompt=""													;科室注意事项提示
	..s ReportPosition=""
	..s JSYFlag=0												;取报告地点
	..s myPBORID="",OrdStr=""
	..f  s myPBORID=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR,myPBORID)) q:myPBORID=""  d
	...Set PPOrdItm=""
	...For  Set PPOrdItm=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR,myPBORID,PPOrdItm)) Quit:PPOrdItm=""  Do
	....;划价医嘱
	....Set ARCIMDR=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),1)),"^",2)
	....s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",2) ;名称
	....s ArcimAbbrev=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",3) ;简写 ARCIM_Abbrev
	....s UserDepartment=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),7)),"^",2) ;开单科室DR
	....s UserDepDesc=""
	....i UserDepartment'="" s UserDepDesc=$p(^CTLOC(UserDepartment),"^",2)
	....i UserDepDesc["-" s UserDepDesc=$p(UserDepDesc,"-",2)
	....s OEORIDate=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),3)),"^",7) ;OEORI_Date
	....s OEORITime=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),3)),"^",15) ;OEORI_Time
	....s OEORIDateDisplay="",OEORITimeDisplay=""
	....s:OEORIDate'="" OEORIDateDisplay=$zd(OEORIDate,3)
	....s:OEORITime'="" OEORITimeDisplay=$zt(OEORITime,1)
	....s Adm=$p(^OEORD(+PPOrdItm),"^",1)
	....s AdmDepDR=$p(^PAADM(Adm),"^",4)
	....s AdmDepDesc=$p(^CTLOC(AdmDepDR),"^",2)
	....i AdmDepDesc["-" s AdmDepDesc=$p(AdmDepDesc,"-",2)
	....i myOrdTypeFlag=4 d
    .....;检查
    .....;(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备地点) flag-0:自动预约失败，1 自动预约成功   
	...../// BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
    .....s ret=##class(web.DHCRisBookParam).AutoBooked(PPOrdItm,PrtDate,PrtTime,"HIS01")
    .....Set PrescPriceFlag="" ;##class(web.UDHCJFBILL).GetPrescPriceOrdItemFlag(PPOrdItm,"")
    .....Set OEPflag=$p(PrescPriceFlag,"^",1)
    .....Set OEPInputFlag=$p(PrescPriceFlag,"^",2)
    .....If (OEPflag="Y")&(OEPInputFlag="Y") Do
    ......s PrescPricePosition=$p($p(ret,"^",7),"$",2)	;预约位置
    ......Set ^PrescPriceOrdItemSend(Adm,PPOrdItm)=PrescPriceFlag	;记录已发放的的医嘱ID
    .....Else  Do
    ......Set PrescPricePosition=$p(ret,"^",9)	;划价位置
    .....s Prompt=$p($p(ret,"^",7),"$",1)
    .....s BookedNote=""	;$p(ret,"^",8)	;检查须知
    .....;
    .....i AdmDepDesc["国际医疗" d
    ......s BookedNote=""
    ......s Prompt=""
    ......s PrescPricePosition="请咨询就诊楼层护士站"
    .....s NewArcimDesc=##class(web.DHCRisApplicationBill).GetAppItemName(PPOrdItm) 
    .....s tmp1=NewArcimDesc_"^"_""_"^"_""_"^"_""_"^"_""_"^"_AdmDepDesc_"^"_PrescPricePosition_"^"_Prompt_"^"_BookedNote_"^"_OEORIDateDisplay_" "_OEORITimeDisplay
    .....i OrdStr="" s OrdStr=tmp1
    .....e  s OrdStr=OrdStr_"!"_tmp1
	...;
	...Quit:myPBORID="PrescPrice"
	...s Bill=+myPBORID
	...s Ord=$p(myPBORID,"||",2)
	...s OEORIDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...s ARCIMDR=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...s UserDepartment=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),7)),"^",2) ;开单科室DR
	...s OEORIDate=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",7) ;OEORI_Date
	...s OEORITime=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",15) ;OEORI_Time
	...s OEORIDateDisplay="",OEORITimeDisplay=""
	...s:OEORIDate'="" OEORIDateDisplay=$zd(OEORIDate,3)
	...s:OEORITime'="" OEORITimeDisplay=$zt(OEORITime,1)
	...s UserDepDesc=""
	...i UserDepartment'="" s UserDepDesc=$p(^CTLOC(UserDepartment),"^",2)
	...i UserDepDesc["-" s UserDepDesc=$p(UserDepDesc,"-",2)
	...s Adm=$p(^OEORD(+OEORIDR),"^",1)
	...s AdmDepDR=$p(^PAADM(Adm),"^",4)
	...s AdmDepDesc=$p(^CTLOC(AdmDepDR),"^",2)
	...i AdmDepDesc["-" s AdmDepDesc=$p(AdmDepDesc,"-",2)
	...;Start Lid 2011-09-03 判断该医嘱的主医嘱是否为药品，如果是药品则不在导诊单上大印
	...s OrdItmType=""
	...s OEORIOEORIDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),11)),"^",39) ;OEORI_OEORI_DR(主医嘱指针)
	...i ((myOrdTypeFlag'=1)&(OEORIOEORIDR'="")) d
	....s OEORIOEORIDRArcimDR=$p($g(^OEORD(+OEORIOEORIDR,"I",$p(OEORIOEORIDR,"||",2),1)),"^",2)
	....s ItmCatDR=$p(^ARCIM(+OEORIOEORIDRArcimDR,$p(OEORIOEORIDRArcimDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	....s OrdItmType=$p(^ARC("IC",ItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	...q:OrdItmType="R"
	...;End
	...s LisFlag=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),"DHC")),"^",22)	
	...q:LisFlag'="" 	;过滤检验绑定的医嘱.
	...s PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	...;s JSYFlag=0
	...i OrdItmType="R" d
	....s JSYFlag="" ;##class(web.DHCSTINTERFACE).ChkOrdBaseMedFlag(PresNo)	;1是基数药，非1不是
	...s OrdTotSum=$fn($p(^DHCPB(Bill,"O",Ord),"^",8),"",2)
	...s ArcimDesc=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",2) ;名称
	...s ArcimAbbrev=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",3) ;简写 ARCIM_Abbrev
	...s ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	...s OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
    ...s PackUOMRowid=$p($g(^ARCIM(+ARCIMDR,1,8)),"^",14) ;整包装单位
	...s OEPrice=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	...s PackUOM=""
	...i PackUOMRowid'=""  d
	....s PackUOM=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
	...s Price=$p(^DHCPB(Bill,"O",Ord),"^",7)
	...s ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ARCIMDR, OEORIDR)
	...s PackQty=$p(^DHCPB(Bill,"O",Ord),"^",5)
	...s Refundqty=$p(^DHCPB(Bill,"O",Ord),"^",6)			;;OE_OrdItem->OEORI_RefundQty
	...i (Refundqty="") d
	....s Refundqty=0
	...s PackQty=+PackQty+Refundqty
	...s Price=$fn(Price*ConFac,"",3)
	...i (OrderType="R")&(PackQty="") s PackQty=1
	...i ((OrderType="R")&(PackQty'="")) d
	....s PackQty=PackQty/ConFac
	...i myOrdTypeFlag=1 d
	....;药品
    ....i ((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ArcItmCatDR_"^"))) d
    .....;草药
    .....i +$g(FCHerIndex)=0  d
    ......i OrdStr="" s OrdStr=FCHerbDesc_"^^^^"
    ......e  s OrdStr=OrdStr_"!"_FCHerbDesc_"^^^^"
    .....s FCHerIndex=+$g(FCHerIndex)+1
    ....e  d
    .....;西药、中成药
    .....i OrdStr="" s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum
    .....e  s OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum
    ...i myOrdTypeFlag=2 d
    ....;检验
    ....i UserDepartment'="" s PrintBarPosition=##class(web.DHCOPBillHDDC).findLOCBloodDis(OEORIDR) 	;打印条码位置
    ....s LabEpisodeDesc=..GetlabEpisodeDesc(OEORIDR)			;标本类型
    ....s SortIndex=LabEpisodeDesc
    ....i LabEpisodeDesc["血" s SortIndex="a"_LabEpisodeDesc 	;标本类型带血的排在最前边
    ....i LabEpisodeDesc="" s SortIndex="左左左左"				;标本类型为空排到最后
    ....s ReportDate=..GetlabReportDate(OEORIDR)		;取报告时间
    ....s ReportPosition=""			;取报告地点
    ....s Prompt=$p($g(^ARCIM(+ARCIMDR,1,9)),"^",32)				;温馨提示
    ....i Prompt'="" s Prompt="温馨提示:"_Prompt
    ....i ArcimAbbrev'="" s ArcimDesc=ArcimAbbrev	;简写不为空时，打印简写
    ....s LabOrdStr=ArcimDesc_"^"_LabEpisodeDesc_"^"_Price_"^"_""_"^"_OrdTotSum_"^"_"采集说明:"_PrintBarPosition_"^"_"报告时间:"_ReportDate_"^"_"报告地点:"_ReportPosition_"^"_Prompt
    ....;i OrdStr="" s OrdStr=LabOrdStr
    ....;e  s OrdStr=OrdStr_"!"_LabOrdStr
    ....;建立一个索引，用于排序
    ....s ^TMP("DirectList","LabSortIndex",$j,SortIndex,myRecDR,ArcimDesc)=LabOrdStr
    ...i myOrdTypeFlag=4 d
    ....;检查
    ....;(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备位置) flag-0:自动预约失败，1 自动预约成功   
	..../// BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
    ....s ret=##class(web.DHCRisBookParam).AutoBooked(OEORIDR,PrtDate,PrtTime,"HIS01")
    ....s BookType=$p(ret,"^",1)
    ....s Prompt=$p($p(ret,"^",7),"$",1)
    ....s BookedNote=$p(ret,"^",8)	;检查须知
    ....s PrescPricePosition=""
    ....i (BookType=1)!(BookType=3) d
    .....s PrescPricePosition=$p($p(ret,"^",7),"$",3)
    .....s EquipmentPosition=$p(ret,"^",10)
    .....i EquipmentPosition'="" d
    ......s PrescPricePosition=EquipmentPosition	;设备地点不为空时，显示设备地点
    .....;s Prompt="请您去 "_PrescPricePosition_" 做检查."
    ....i BookType=2 d
    .....s PrescPricePosition=$p($p(ret,"^",7),"$",2)
    .....s BookedNote=""
    .....;s Prompt="请您去 "_PrescPricePosition_" 预约."
    ....i (BookType=2) s BookedNote=""	;检查须知
    ....i AdmDepDesc["国际医疗" d
    .....s Prompt=""
    .....s BookedNote=""
    .....s PrescPricePosition="请咨询就诊楼层护士站"
    ....s NewArcimDesc=##class(web.DHCRisApplicationBill).GetAppItemName(OEORIDR) 
    ....s tmp3=NewArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_AdmDepDesc_"^"_PrescPricePosition_"^"_Prompt_"^"_BookedNote_"^"_OEORIDateDisplay_" "_OEORITimeDisplay
    ....i OrdStr="" s OrdStr=tmp3
    ....e  s OrdStr=OrdStr_"!"_tmp3
    ...i myOrdTypeFlag=3 d
    ....;治疗
    ....s Position=""
    ....i AdmDepDesc["国际医疗" s Position="地点:"_"请咨询就诊楼层护士站"
    ....;(after the consultation,if there is any examination or therapy,please go to the nurser station)
    ....i OrdStr="" s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_Position
    ....e  s OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_Position
    ..i myOrdTypeFlag=2 d
    ...s Ind=""
    ...f  s Ind=$o(^TMP("DirectList","LabSortIndex",$j,Ind)) q:Ind=""  d
    ....s LabArcimDesc=""
    ....f  s LabArcimDesc=$o(^TMP("DirectList","LabSortIndex",$j,Ind,myRecDR,LabArcimDesc)) q:LabArcimDesc=""  d
    .....s tmp5=$g(^TMP("DirectList","LabSortIndex",$j,Ind,myRecDR,LabArcimDesc))
    .....i OrdStr="" s OrdStr=tmp5
    .....e  s OrdStr=OrdStr_"!"_tmp5
    ..i OrdStr'="" d
    ...s PresWin=$g(^TMP("myWinInfo",$j,myRecDR))	;发药窗口
    ...;i $g(JSYFlag)=1 s JSYFlag="基数药"
    ...i PresWin["基数" s JSYFlag="基数药"
    ...i PresWin'["基数" s PresWin=PresWin_"号窗口"  
    ...;i RecDepLocDesc["6.2100" s PresWin="先打处方后"
    ...s PrtWinFlag=0
    ...i (RecDepLocDesc["1.2100")!(RecDepLocDesc["1.2400") s PrtWinFlag=1
    ...i RecLocStr="" s RecLocStr=RecDepLoc_"^"_RecDepLocPosition_"^"_RecLocPrompt_"^"_ReportPosition_"^"_PresWin_"^"_$g(JSYFlag)_"^"_$g(PrtWinFlag)_$c(5)_OrdStr
    ...e  s RecLocStr=RecLocStr_$c(4)_RecDepLoc_"^"_RecDepLocPosition_"^"_RecLocPrompt_"^"_ReportPosition_"^"_PresWin_"^"_$g(JSYFlag)_"^"_$g(PrtWinFlag)_$c(5)_OrdStr
    .i rtn="" s rtn=Str_$c(3)_RecLocStr
    .e  s rtn=rtn_$c(2)_Str_$c(3)_RecLocStr
    k ^TMP("DirectList","LabSortIndex",$j)
    s rtn=BaseInfo_$c(1)_rtn
    ;b ;111
    k ^TMP($ZN,$j,"PBID")
    ;w rtn
    q rtn
}

/// Creator:Lid
/// CreatDate:2012-12-12
/// Description:获取导诊单数据(北京协和)
/// Table:DHC_InvPrt,DHC_PatientBill,DHC_BillConInv,OE_OrdItem,ARC_ItmMast,ARC_ItemCat
/// Input:PrtRowid:发票表RowID,ExpStr:(安全组^科室^收费员^^)
/// Output:
/// Return:
/// Other: w ##class(web.DHCOPBILLOrdDirectList).GetDirectListByPrtRowidXH("234436","122^^^")
ClassMethod GetDirectListByPrtRowidXH(PrtRowid As %String, ExpStr As %String = "")
{
	New (PrtRowid,ExpStr)
	Kill ^TMP($ZN,$j,"PBID")
	Kill ^MaxLabReportDate($j)
	Kill ^TMP("myWinInfo",$j)
	Kill ^LabOrdItem($j)
	Kill ^TMPLabSortIndex("LabSort",$j)
	Set Group=$p($g(ExpStr),"^",1)
	Set CTLocDR=$p($g(ExpStr),"^",2)
	Set UserDR=$p($g(ExpStr),"^",3)
	;s:Group="" Group=$G(%session.Data("LOGON.GROUPID"))
	;
	Quit:+PrtRowid=0 ""
    ;病人基本信息
    Set paperDr=$p($get(^DHCINVPRT(PrtRowid)),"^",15)
    Quit:(paperDr="") ""
	Set patNo=$p($g(^PAPER(paperDr,"PAT",1)),"^",1)   ;登记号
	Set SocialStatus=$p($g(^PAPER(paperDr,"PER",1)),"^",10)  ;PAPER_SocialStatus_dr
	Set SocialStatusDesc=""
	Set:(SocialStatus'="") SocialStatusDesc=$p(^CT("SS",SocialStatus),"^",2)
	Set patName=$p($g(^PAPER(paperDr,"ALL")),"^",1)   ;姓名
	Set patmiId=$p($g(^PAPER(paperDr,"ALL")),"^",9)   ;身份证
	Set sex=$p($g(^PAPER(paperDr,"ALL")),"^",7)       ;性别
	If (sex'="") Set sex=$p(^CT("SEX",sex),"^",2)
	Set age=##class(web.DHCBillInterface).GetPapmiAge(paperDr, "")
	Set age=age_" "_SocialStatusDesc
	;
	;获取中草药配制
	Set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	Set rtn=$p(HerbConfig,$c(2))
	Quit:rtn 104   ;配置错误
	Set FCHerbFlag=$p(HerbConfig,$c(2),2)		;OPFC_HerbalFlag
	Set FCHerbDesc=$p(HerbConfig,$c(2),3)
	Set FCHerbNum=$p(HerbConfig,$c(2),4)
	Set FCHerbRange=$p(HerbConfig,$c(2),5)
	;
	Set PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	Set PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	Set PrtDateDesc=$zd(PrtDate,3)
	Set PrtTimeDesc=$zt(PrtTime,1)
	Set PrtUser=$p(^DHCINVPRT(PrtRowid),"^",21)
	Set PrtUserDesc=$p(^SSU("SSUSR",PrtUser),"^",2)
	Set BaseInfo=patNo_"^"_patName_"^"_sex_"^"_age_"^"_PrtUserDesc_"^"_PrtDateDesc_" "_PrtTimeDesc_"^"_SocialStatusDesc
	Set BCIDR=""
    For  Set BCIDR=$o(^DHCBCI(0,"INV",PrtRowid,BCIDR)) Quit:BCIDR=""  Do
	.Set Bill=$p(^DHCBCI(BCIDR),"^",2)
	.Set Adm=$p(^DHCBCI(BCIDR),"^",3)   ;就诊Rowid
	.Quit:'$d(^DHCPB(Bill))
	.Set PBO=0 
	.For  Set PBO=$o(^DHCPB(Bill,"O",PBO)) Quit:PBO=""  Do
	..Quit:($d(^DHCPB(Bill,"O",PBO))=10)
	..Set OEORIDR=$p(^DHCPB(Bill,"O",PBO),"^",4)							;医嘱表Rowid
	..Set ARCIMDR=$p(^DHCPB(Bill,"O",PBO),"^",3)							;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
    ..Set PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	..Set RecdepDR=$p($g(^OEORD(+OEORIDR,"I",+$p(OEORIDR,"||",2),3)),"^",6) ;接收科室Rowid
    ..Set LocType=$p(^CTLOC(RecdepDR),"^",13) 
	..If (LocType="") Set LocType="Z"	;放在最后?
	..Set ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	..Set OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	..;Start Lid 2011-09-03 判断该医嘱的主医嘱是否为药品，如果是药品则不在导诊单上大印
	..Set OrdItmType=""
	..Set OEORIOEORIDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),11)),"^",39) ;OEORI_OEORI_DR(主医嘱指针)
	..If ((OrderType'="R")&&(OEORIOEORIDR'="")) d
	...Set OEORIOEORIDRArcimDR=$p($g(^OEORD(+OEORIOEORIDR,"I",$p(OEORIOEORIDR,"||",2),1)),"^",2)
	...Set ItmCatDR=$p(^ARCIM(+OEORIOEORIDRArcimDR,$p(OEORIOEORIDRArcimDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	...Set OrdItmType=$p(^ARC("IC",ItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
	..Quit:(OrdItmType="R")
	..;End
	..Set LisFlag=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),"DHC")),"^",22)	
	..Quit:LisFlag'="" 	;过滤检验绑定的医嘱.
	..Quit:((Group="183")&&(OrderType'="R"))	;体检安全组导诊单上只打印药品
	..Set LisFlag=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),"DHC")),"^",22)	
	..Quit:(LisFlag'="") 	;过滤检验绑定的医嘱.
	..If (OrderType="R") Do
	...;药品
	...;判断是否为基数药，如果是则取基数药使用位置(科室)
	...Set JSYDepDR=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),"DHC")),"^",36)
	...Set JSYFlag=""	;##class(web.DHCSTINTERFACE).ChkOrdBaseMedFlag(PresNo)	;1是基数药，非1不是
	...If JSYFlag=1 d
	....If JSYDepDR'="" Set RecdepDR=JSYDepDR
	...;取发药窗口
	...Set WinInfo=##class(web.DHCMZYFXTYW02).GetPrtPrescWin(PrtRowid,PresNo)
	...If WinInfo'="" Set ^TMP("myWinInfo",$j,RecdepDR)=WinInfo
	...Set OrdTypeFlag=1
	..Else  If OrderType="L" Do
	...;检验
	...Set OrdTypeFlag=2
	..Else  Do
	...Set Flag=##class(web.DHCBillHardCoded).IsExamSubCat(ARCIMDR)
	...If +Flag=1 d
	....;检查
	....Set OrdTypeFlag=4
	...Else  Do
	....;治疗
	....Set OrdTypeFlag=3
	..Set ^TMP($ZN,$j,"PBID",OrdTypeFlag,RecdepDR,Bill_"||"_PBO)=""	;按医嘱分类(顺序:药品->检验->治疗->检查)及接收科室重新建立索引
    .;协和医院 根据Adm取需划价的检查医嘱
    .Set PrescPriceStr=##class(web.DHCOPBILLOrdDirectList).GetPrescPriceOrditem(Adm)
    .For i=1:1:$l(PrescPriceStr,"^") Do
    ..Set PrescPriceOrdItm=$p(PrescPriceStr,"^",i)
    ..Quit:PrescPriceOrdItm="" 
    ..Set ItemStatDR=$p($g(^OEORD(+PrescPriceOrdItm,"I",+$p(PrescPriceOrdItm,"||",2),1)),"^",13)	;OEORI_ItemStat_DR
    ..Set OSTATCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    ..Quit:OSTATCode="D"	;过滤停止医嘱
    ..Set RecdepDR=$p($g(^OEORD(+PrescPriceOrdItm,"I",+$p(PrescPriceOrdItm,"||",2),3)),"^",6) ;接收科室Rowid
    ..;只有检查有划价医嘱
    ..Set ^TMP($ZN,$j,"PBID",4,RecdepDR,"PrescPrice",PrescPriceOrdItm)=""

    Set myOrdTypeFlag="",rtn=""
	For  Set myOrdTypeFlag=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag)) Quit:myOrdTypeFlag=""  Do
	.Set:myOrdTypeFlag=1 Str="药品"
	.Set:myOrdTypeFlag=2 Str="化验"
	.Set:myOrdTypeFlag=3 Str="治疗"
	.Set:myOrdTypeFlag=4 Str="检查"
	.Set myRecDR="",RecLocStr=""
	.For  Set myRecDR=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR)) Quit:myRecDR=""  Do
	..Set RecDepLoc=$p(^CTLOC(myRecDR),"^",2)
	..Set RecDepLocDesc=RecDepLoc
	..If (RecDepLoc["-") Set RecDepLoc=$p(RecDepLoc,"-",2)					;接收科室
	..Set RecDepLocPosition=$p($g(^CTLOC(myRecDR,"ADDR","1")),"^",1)  	;接收科室的物理地址
	..Set RecLocPrompt=""												;科室注意事项提示
	..Set ReportPosition=""												;取报告地点
	..Set JSYFlag=0
	..Set myPBORID="",OrdStr=""
	..For  Set myPBORID=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR,myPBORID)) Quit:myPBORID=""  Do
	...Set PPOrdItm=""
	...For  Set PPOrdItm=$o(^TMP($ZN,$j,"PBID",myOrdTypeFlag,myRecDR,myPBORID,PPOrdItm)) Quit:PPOrdItm=""  Do
	....;划价医嘱
	....Set ARCIMDR=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),1)),"^",2)
	....Set ArcimDesc=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",2) ;名称
	....Set ArcimAbbrev=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",3) ;简写 ARCIM_Abbrev
	....Set UserDepartment=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),7)),"^",2) ;开单科室DR
	....Set UserDepDesc=""
	....If UserDepartment'=""  Do
	.....Set UserDepDesc=$p(^CTLOC(UserDepartment),"^",2)
	....If UserDepDesc["-" s UserDepDesc=$p(UserDepDesc,"-",2)
	....Set OEORIDate=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),3)),"^",7) ;OEORI_Date
	....Set OEORITime=$p($g(^OEORD(+PPOrdItm,"I",$p(PPOrdItm,"||",2),3)),"^",15) ;OEORI_Time
	....Set OEORIDateDisplay="",OEORITimeDisplay=""
	....Set:OEORIDate'="" OEORIDateDisplay=$zd(OEORIDate,3)
	....Set:OEORITime'="" OEORITimeDisplay=$zt(OEORITime,1)
	....Set Adm=$p(^OEORD(+PPOrdItm),"^",1)
	....Set AdmDepDR=$p(^PAADM(Adm),"^",4)
	....Set AdmDepDesc=$p(^CTLOC(AdmDepDR),"^",2)
	....If AdmDepDesc["-" Set AdmDepDesc=$p(AdmDepDesc,"-",2)
	....If (myOrdTypeFlag=4) Do
    .....;检查
    .....;(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备地点) flag-0:自动预约失败，1 自动预约成功   
	.....//BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
    .....Set ret=##class(web.DHCRisBookParam).AutoBooked(PPOrdItm,PrtDate,PrtTime,"HIS01")
    .....Set PrescPriceFlag="" ;##class(web.UDHCJFBILL).GetPrescPriceOrdItemFlag(PPOrdItm,"")
    .....Set OEPflag=$p(PrescPriceFlag,"^",1)
    .....Set OEPInputFlag=$p(PrescPriceFlag,"^",2)
    .....If (OEPflag="Y")&(OEPInputFlag="Y") Do
    ......Set PrescPricePosition=$p($p(ret,"^",7),"$",2)	;预约位置
    ......Set ^PrescPriceOrdItemSend(Adm,PPOrdItm)=PrescPriceFlag	;记录已发放的的医嘱ID
    .....Else  Do
    ......Set PrescPricePosition=$p(ret,"^",9)	;划价位置
    .....Set Prompt=$p($p(ret,"^",7),"$",1)
    .....Set BookedNote=""	;$p(ret,"^",8)	;检查须知
    .....;
    .....If (AdmDepDesc["国际医疗") Do
    ......Set BookedNote=""
    ......Set Prompt=""
    ......Set PrescPricePosition="请咨询就诊楼层护士站"
    .....Set NewArcimDesc=##class(web.DHCRisApplicationBill).GetAppItemName(PPOrdItm) 
    .....Set tmp1=NewArcimDesc_"^"_""_"^"_""_"^"_""_"^"_""_"^"_AdmDepDesc_"^"_PrescPricePosition_"^"_Prompt_"^"_BookedNote_"^"_OEORIDateDisplay_" "_OEORITimeDisplay
    .....if OrdStr="" Set OrdStr=tmp1
    .....Else  Set OrdStr=OrdStr_"!"_tmp1
	...Quit:(myPBORID="PrescPrice")
	...;
	...Set Bill=+myPBORID
	...Set Ord=$p(myPBORID,"||",2)
	...Set OEORIDR=$p(^DHCPB(Bill,"O",Ord),"^",4)
	...Set ARCIMDR=$p(^DHCPB(Bill,"O",Ord),"^",3)
	...Set UserDepartment=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),7)),"^",2) ;开单科室DR
	...Set OEORIDate=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",7) ;OEORI_Date
	...set OEORITime=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",15) ;OEORI_Time
	...Set OEORIDateDisplay="",OEORITimeDisplay=""
	...Set:OEORIDate'="" OEORIDateDisplay=$zd(OEORIDate,3)
	...Set:OEORITime'="" OEORITimeDisplay=$zt(OEORITime,1)
	...Set UserDepDesc=""
	...If (UserDepartment'="") Set UserDepDesc=$p(^CTLOC(UserDepartment),"^",2)
	...If (UserDepDesc["-") s UserDepDesc=$p(UserDepDesc,"-",2)
	...Set Adm=$p(^OEORD(+OEORIDR),"^",1)
	...Set AdmDepDR=$p(^PAADM(Adm),"^",4)
	...Set AdmDepDesc=$p(^CTLOC(AdmDepDR),"^",2)
	...If AdmDepDesc["-" Set AdmDepDesc=$p(AdmDepDesc,"-",2)
	...Set PresNo=$p(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1),"^",14)
	...Set OrdTotSum=$fn($p(^DHCPB(Bill,"O",Ord),"^",8),"",2)
	...Set ArcimDesc=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",2) ;名称
	...b ;1
	...Set ArcimAbbrev=$p($g(^ARCIM(+ARCIMDR,1,1)),"^",3) ;简写 ARCIM_Abbrev
	...Set ArcItmCatDR=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",10) 	;医嘱子类(ARC_ItmMast->ARCIM_ItemCat_DR->ARC_ItemCat)
	...Set OrderType=$p(^ARC("IC",ArcItmCatDR),"^",7)                   	;医嘱类型ARC_ItemCat->ARCIC_OrderType(R:药品N:诊疗 L:检验P:自定价医嘱)
    ...If OrderType="R" d
	....Set JSYFlag="" ;##class(web.DHCSTINTERFACE).ChkOrdBaseMedFlag(PresNo)	;1是基数药，非1不是
    ...Set PackUOMRowid=$p($g(^ARCIM(+ARCIMDR,1,8)),"^",14) ;整包装单位
	...Set OEPrice=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",25)		;;取出P   价格 OE_OrdItem->OEORI_Price
	...Set PackUOM=""
	...If (PackUOMRowid'="")  Do
	....Set PackUOM=$p($g(^CT("UOM",PackUOMRowid)),"^",2)
	...Set Price=$p(^DHCPB(Bill,"O",Ord),"^",7)	
	...Set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(ARCIMDR, OEORIDR)
	...Set PackQty=$p(^DHCPB(Bill,"O",Ord),"^",5)
	...Set Refundqty=$p(^DHCPB(Bill,"O",Ord),"^",6)			//OE_OrdItem->OEORI_RefundQty
	...If Refundqty="" Do
	....Set Refundqty=0
	...Set PackQty=+PackQty+Refundqty
	...Set Price=$fn(Price*ConFac,"",3)
	...If (OrderType="R")&(PackQty="") Set PackQty=1
	...If ((OrderType="R")&(PackQty'="")) Do
	....s PackQty=PackQty/ConFac
	...If myOrdTypeFlag=1 Do
	....;b ;药品
    ....If ((+$g(FCHerbFlag)=1)&&(FCHerbRange[("^"_ArcItmCatDR_"^"))) Do
    .....;b ;草药
    .....If +$g(FCHerIndex)=0 Do
    ......If OrdStr="" Set OrdStr=FCHerbDesc_"^^^^"
    ......Else  Set OrdStr=OrdStr_"!"_FCHerbDesc_"^^^^"
    .....Set FCHerIndex=+$g(FCHerIndex)+1
    ....Else  Do
    .....;西药、中成药
    .....If (OrdStr="") s OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum
    .....Else  Set OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum
    ...If myOrdTypeFlag=2 Do
    ....;检验
    ....Set specSub=$o(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),"SPEC",""),-1)
    ....Set specCode=""
    ....Set:specSub'="" specCode=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),"SPEC",specSub)),"^",1) ;标本代码表的Code
    ....If UserDepartment'="" Set PrintBarPosition=##class(web.DHCOPBillHDDC).findLOCBloodDisNew(OEORIDR,specCode) 	;打印条码位置
    ....Set LabEpisodeDesc=..GetlabEpisodeDesc(OEORIDR)			;标本类型
    ....Set SortIndex=LabEpisodeDesc
    ....Set ReportDate=..GetlabReportDate(OEORIDR)		;取报告时间
    ....Set ReportPosition=""			;取报告地点
    ....Set Prompt=$p($g(^ARCIM(+ARCIMDR,1,9)),"^",32)				;温馨提示
    ....If (ArcimAbbrev'="") Set ArcimDesc=ArcimAbbrev	;简写不为空时，打印简写
    ....Set LabOrdStr=ArcimDesc_"^"_LabEpisodeDesc_"^"_Price_"^"_""_"^"_OrdTotSum_"^"_PrintBarPosition_"^"_ReportDate_"^"_ReportPosition_"^"_Prompt
    ....Set LabEpisodeNo=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),3)),"^",20)	;检验条码号 OEORI_LabEpisodeNo
    ....Set:LabEpisodeNo="" LabEpisodeNo="Z"
    ....Set ^LabOrdItem($j,LabEpisodeNo,OEORIDR)=Bill_"||"_Ord_"^"_LabOrdStr	
    ...If (myOrdTypeFlag=4) Do
    ....;检查
    ....;(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备位置) flag-0:自动预约失败，1 自动预约成功   
	....;BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
    ....Set ret=##class(web.DHCRisBookParam).AutoBooked(OEORIDR,PrtDate,PrtTime,"HIS01")
    ....Set BookType=$p(ret,"^",1)
    ....Set Prompt=$p($p(ret,"^",7),"$",1)
    ....Set BookedNote=$p(ret,"^",8)	;检查须知
    ....Set PrescPricePosition=""
    ....If (BookType=1)||(BookType=3) Do
    .....Set PrescPricePosition=$p($p(ret,"^",7),"$",3)
    .....Set EquipmentPosition=$p(ret,"^",10)
    .....If (EquipmentPosition'="") Do
    ......Set PrescPricePosition=EquipmentPosition	;设备地点不为空时，显示设备地点
    .....;s Prompt="请您去 "_PrescPricePosition_" 做检查."
    ....If (BookType=2) Do
    .....Set PrescPricePosition=$p($p(ret,"^",7),"$",2)
    .....Set BookedNote=""
    .....;s Prompt="请您去 "_PrescPricePosition_" 预约."
    ....If (BookType=2) s BookedNote=""	;检查须知
    ....If AdmDepDesc["国际医疗" Do
    .....Set Prompt=""
    .....Set BookedNote=""
    .....Set PrescPricePosition="请咨询就诊楼层护士站"
    ....Set NewArcimDesc=##class(web.DHCRisApplicationBill).GetAppItemName(OEORIDR) 
    ....Set IsAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORIDR)
    ....If (IsAppRepFlag="Y") Do
    .....Set PartDesc=##class(web.DHCEMInterface).GetExaReqPartDesc(OEORIDR)
    .....If (PartDesc'="") Set NewArcimDesc=NewArcimDesc_PartDesc    //名称 + 部位
    ....Set tmp3=NewArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_AdmDepDesc_"^"_PrescPricePosition_"^"_Prompt_"^"_BookedNote_"^"_OEORIDateDisplay_" "_OEORITimeDisplay
    ....If (OrdStr="") Set OrdStr=tmp3
    ....Else  Set OrdStr=OrdStr_"!"_tmp3
    ...If (myOrdTypeFlag=3) Do
    ....Set Position=""
    ....If UserDepartment'="" Set Position=##class(web.DHCOPBillHDDC).findLOCBloodDis(OEORIDR,"N") 	;打印条码位置
    ....If (AdmDepDesc["国际医疗") s Position="地点:"_"请咨询就诊楼层护士站"
    ....Else  Set Position="地点:"_Position
    ....If (OrdStr="") Set OrdStr=ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_Position
    ....Else  Set OrdStr=OrdStr_"!"_ArcimDesc_"^"_PackQty_"^"_Price_"^"_PackUOM_"^"_OrdTotSum_"^"_Position
   	....b ;;11111
    ..If (OrdStr'="")&(myOrdTypeFlag=1) Do
    ...Set AutoRFlag=$p(^CTLOC(myRecDR),"^",35)	;摆药机发药标志
    ...Set PresWin=$g(^TMP("myWinInfo",$j,myRecDR))	;发药窗口
    ...s PresWin=$tr(PresWin,"号窗口","")
    ...If PresWin["基数" Do
    ....Set JSYFlag="基数药"
    ....Set JSYFlagDesc="以下药品请到 "_RecDepLocPosition_" "_RecDepLoc_" ,诊间使用,不需要到药房取."
    ...Set PrtWinFlag=0
    ...If AutoRFlag="Y" Do
    ....Set PrtWinFlag=1	;1：摆药机发药，0：人工发药
    ....;Set Dispensary="请到 "_RecDepLocPosition_" "_PresWin_" 号窗口"
    ....Set Dispensary="请到 "_RecDepLocPosition
   	....Set HosptialNote="待屏幕上方出现您的姓名后,刷卡取药."
    ...Else  Do
    ....Set Dispensary="请到 "_RecDepLocPosition
    ....Set HosptialNote="请先到收方窗口交卡打印处方,再取药."
    ...If RecDepLocDesc["同仁堂" Do
    ....Set HerbFlag=1	;根据接收科室判断是否为草药
    ....;Set Dispensary=" 请到 "_RecDepLocPosition_" 中草药房取药."
    ....Set Dispensary="东院就诊:请到东院北区七层中医科取药|西院就诊:请到西院门诊楼三层中医科取药"
    ....If AdmDepDesc["国际医疗" Do
    .....Set Dispensary="国际医疗就诊:请到国际医疗部二层取药.|"
   	...Else  Do
   	....Set HerbFlag=0
   	..;
   	..If (OrdStr'="") Do
    ...If RecLocStr="" Set RecLocStr=RecDepLoc_"^"_RecDepLocPosition_"^"_RecLocPrompt_"^"_ReportPosition_"^"_$g(PresWin)_"^"_$g(JSYFlag)_"^"_$g(PrtWinFlag)_"^"_$g(JSYFlagDesc)_"^"_$g(HerbFlag)_"^"_$g(Dispensary)_"^"_$g(HosptialNote)_$c(5)_OrdStr
    ...Else  Set RecLocStr=RecLocStr_$c(4)_RecDepLoc_"^"_RecDepLocPosition_"^"_RecLocPrompt_"^"_ReportPosition_"^"_$g(PresWin)_"^"_$g(JSYFlag)_"^"_$g(PrtWinFlag)_"^"_$g(JSYFlagDesc)_"^"_$g(HerbFlag)_"^"_$g(Dispensary)_"^"_$g(HosptialNote)_$c(5)_OrdStr
    .If myOrdTypeFlag=2 Do
   	..;化验 ^LabOrdItem($j,LabEpisodeNo,OEORIDR)
   	..Set LabNO="",LabOrdStr=""
   	..For  Set LabNO=$o(^LabOrdItem($j,LabNO)) Quit:LabNO=""  Do
   	...Set LabNODesc="",LabEpisodeDesc="",LabPrtBarPosition="",LabReportPosition=""
   	...Set LabReportDate="",LabPrompt=""
   	...Set LabOEORI=""
   	...For  Set LabOEORI=$o(^LabOrdItem($j,LabNO,LabOEORI)) Quit:LabOEORI=""  Do
   	....Set LabInfo=^LabOrdItem($j,LabNO,LabOEORI)
   	....Set myLabName=$p(LabInfo,"^",2)	;化验项目名称
   	....Set myLabEpisodeDesc=$p(LabInfo,"^",3)	;标本
   	....Set myPrintBarPosition=$p(LabInfo,"^",7)	;打印条码位置
   	....Set myReportDate=$p(LabInfo,"^",8)		;取报告时间
   	....Do ##class(web.DHCOPBILLOrdDirectList).GetNumberForString(LabNO,myReportDate,$j)
   	....Set myReportPosition=$p(LabInfo,"^",9)	;取报告地点
   	....Set myLabPrompt=$p(LabInfo,"^",10)		;温馨提示
   	....If LabNODesc=""  Set LabNODesc=myLabName
   	....Else  Set LabNODesc=LabNODesc_"+"_myLabName
   	....If (LabEpisodeDesc="")&(myLabEpisodeDesc'="") Do
   	.....Set LabEpisodeDesc=myLabEpisodeDesc		;默认条码号一样时，标本类型也一样，所以默认取任意一个
   	....If (LabPrtBarPosition="")&(myPrintBarPosition'="") Do
   	.....Set LabPrtBarPosition=myPrintBarPosition	;默认条码号一样时，条码打印位置也一样，所以默认取任意一个
   	....If (LabReportPosition="")&(myReportPosition'="") Do
   	.....Set LabReportPosition=myReportPosition	;默认条码号一样时，取报告地点也一样，所以默认取任意一个
   	....If (LabPrompt="")&(myLabPrompt'="") Do
   	.....Set LabPrompt=myLabPrompt					;默认条码号一样时，温馨提示默认取一个就行
   	...Set MaxTime=$o(^MaxLabReportDate($j,LabNO,""),-1)
    ...If MaxTime'="" Set LabReportDate=$g(^MaxLabReportDate($j,LabNO,MaxTime))
    ...;b ;ArcimDesc_"^"_LabEpisodeDesc_"^"_Price_"^"_""_"^"_OrdTotSum_"^"_PrintBarPosition_"^"_ReportDate_"^"_ReportPosition_"^"_Prompt
    ...Set:LabPrompt'="" LabPrompt="温馨提示:"_LabPrompt
    ...Set tmp5=LabNODesc_"^"_LabEpisodeDesc_"^"_""_"^"_""_"^"_""_"^"_"采集说明:"_LabPrtBarPosition_"^"_"报告时间:"_LabReportDate_"^"_"取报告地点"_LabReportPosition_"^"_LabPrompt
    ...Set:LabPrtBarPosition="" LabPrtBarPosition="左左左左左左左左左"
    ...Set ^TMPLabSortIndex("LabSort",$j,LabNO,LabPrtBarPosition)=tmp5
    ..Set LabNO=""
    ..For  Set LabNO=$o(^TMPLabSortIndex("LabSort",$j,LabNO)) Quit:LabNO=""  Do
    ...Set PrtBarP=""
    ...For  Set PrtBarP=$o(^TMPLabSortIndex("LabSort",$j,LabNO,PrtBarP)) Quit:PrtBarP=""  Do
    ....Set tmp6=$g(^TMPLabSortIndex("LabSort",$j,LabNO,PrtBarP))
    ....If LabOrdStr="" Set LabOrdStr=tmp6
    ....Else  Set LabOrdStr=LabOrdStr_"!"_tmp6
    ..Set RecLocStr="^^^^^^"_$c(5)_LabOrdStr
  	.;
    .If rtn="" Set rtn=Str_$c(3)_RecLocStr
    .Else  Set rtn=rtn_$c(2)_Str_$c(3)_RecLocStr
    ;
    If rtn'="" Do
    .Set rtn=BaseInfo_$c(1)_rtn
    Kill ^LabOrdItem($j)
    Kill ^MaxLabReportDate($j)
    Kill ^TMP($ZN,$j,"PBID")
    Quit rtn
    ;
}

/// Debug:w ##class(web.DHCOPBILLOrdDirectList).GetNumberForString(111111,"",22222)
ClassMethod GetNumberForString(LabNO, String, Job)
{
	New (LabNO,String,Job)
	;
	;Set String="今天是14号"
	;Set String=String_",请与4-11天后取报告"
	For n=1:1:$l(String) Do
	.Set TMPStr=$e(String,n,$l(String))
	.Set Number=+TMPStr
	.If +Number>0 Do
	..Set ^MaxLabReportDate(Job,LabNO,Number)=String
	..If $l(Number)>1 Set n=n+$l(Number)
	;
	Quit 0
}

/// Lid
/// 2010-05-31
/// 根据发票号生成医嘱明细
/// w ##class(web.DHCOPBILLOrdDirectList).GetOrdDetailsByPrtRowid(19)
ClassMethod SetOrdDetailsByPrtRowid(prtRowid As %String, ordList As %String = "", sFlag, job) As %String
{
	;申请医嘱的判断方式
	;在RIS下面有一个 web.DHCRisOutInterface，这样一个方法 QueryPaidPatientInfo
    ;s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
    ;q:(billed'="P")!(ServerMaterial'="S")
    
    if sFlag="PRT" d
    .d SetDate(prtRowid,ordList,job)  
    /*;卡消费
    i sFlag="API" d
    .s myACPRowID=0
	.f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",prtRowid,myACPRowID)) q:(myACPRowID="")  d
	..s myINVRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..q:(myINVRowID="")
	..d SetDate(myINVRowID,ordList,job)
    */
SetDate(prtRowid,ordList,job) 
    s invLinkDr=""
    f  s invLinkDr=$o(^DHCBCI(0,"INV",prtRowid,invLinkDr)) Quit:invLinkDr=""  Do
	.s bill=$p(^DHCBCI(invLinkDr),"^",2)
	.s adm=$p(^DHCBCI(invLinkDr),"^",3)   ;就诊Rowid
	.Quit:'$D(^DHCPB(bill))
	.Set ord=0 
	.f  Set ord=$o(^DHCPB(bill,"O",ord)) Quit:ord=""  Do
	..q:($d(^DHCPB(bill,"O",ord))=10)
	..s oeitDr=$p(^DHCPB(bill,"O",ord),"^",4)  ;医嘱表Rowid
	..q:(+ordList'=0)&&(("^"_ordList_"^")'[("^"_oeitDr_"^"))  ;过滤医嘱
	..s arcimDr=$p(^DHCPB(bill,"O",ord),"^",3) ;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
    ..s arcItmCatDr=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",10) ;医嘱子类()
	..s orderType=$p(^ARC("IC",arcItmCatDr),"^",7)                   ;医嘱类型
	..s serverMaterial=$p($g(^ARCIM($p(arcimDr,"||",1),$p(arcimDr,"||",2),7)),"^",6) ;申请医嘱判断标志
	..s billed=$p(^OEORD(+oeitDr,"I",$p(oeitDr,"||",2),3),"^",5)   ;医嘱账单标志
	..q:(billed'="P")  ;过滤未结算医嘱
	..s myPresNo=$p(^OEORD(+oeitDr,"I",$p(oeitDr,"||",2),1),"^",14)
	..s recdepDR=$p($g(^OEORD(+oeitDr,"I",+$p(oeitDr,"||",2),3)),"^",6) ;接收科室
	..s loctype=$p(^CTLOC(recdepDR),"^",13)   ;Ward||W Execute||E Drug Injection||DI Dispensing||D_
	..i loctype="" s loctype="Z"	;放在最后?
	..s ordRowid=bill_"||"_ord  ;生成DHC_PatbillOrder表Rowid
	..i $d(^DHCOPBillReqLinkOrd(oeitDr)) s flag=^DHCOPBillReqLinkOrd(oeitDr)  ;F2切换标志
	..e  s flag="-1"
	..i serverMaterial="S" d
	...s ^TMP("DHCOPBILL","OrdDirectList","Server",job,adm,recdepDR,flag,ordRowid)=ordRowid
	..e  d
	...s ^TMP("DHCOPBILL","OrdDirectList","NoServer",job,adm,recdepDR,flag,ordRowid)=ordRowid
}

/// Lid
/// 2010-06-01
/// 获取医嘱导引单打印信息
/// w ##class(web.DHCOPBILLOrdDirectList).GetPrintInfoByPrtRowid(236171,"35781||6")
ClassMethod GetPrintInfoByPrtRowid(prtRowid, ordList As %String = "", sFlag) As %String
{
	s job=$j
	 ;清楚临时数据
    k ^TMP("DHCOPBILL","OrdDirectList","NoServer",job)
    k ^TMP("DHCOPBILL","OrdDirectList","Server",job)
    k ^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job)
    
    s ^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job)=sFlag_"^"_prtRowid
	d ..SetOrdDetailsByPrtRowid(prtRowid,ordList,sFlag,job)  ;生成导引单数据

	s printInfo=..SetPrintInfo(job)
    
    ;清楚临时数据
    ;k ^TMP("DHCOPBILL","OrdDirectList","NoServer",job)
    ;k ^TMP("DHCOPBILL","OrdDirectList","Server",job)
    k ^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job)
    
	q printInfo
}

/// Lid
/// 2010-06-01
/// 生成打印信息
/// ^TMP("DHCOPBILL","OrdDirectList","NoServer",job,adm,recdepDR)=ordRowid
/// ^TMP("DHCOPBILL","OrdDirectList","Server",job,adm,recdepDR)=ordRowid
ClassMethod SetPrintInfo(job)
{
	s rtn=""
	;1.普通医嘱信息
	s noServerPrtInfo=..GetNoServerPrtInfo(job)
	
	b ;1
	;2.申请医嘱信息
	s serverPrtInfo=..GetServerPrtInfo(job)
	b ;2
	;3.特殊医嘱信息
	b ;3
	s rtn=$g(noServerPrtInfo)_$c(6)_$g(serverPrtInfo)_$c(6)_""
	b ;4
	q rtn
}

/// 获取申请类医嘱导引单打印数据
ClassMethod GetServerPrtInfo(job)
{
	s adm="",ServerStr=""
	f  s adm=$o(^TMP("DHCOPBILL","OrdDirectList","Server",job,adm)) q:adm=""  d
    .s patInfo=..GetPatInfoByAdm(adm)
    .s baseInfo=$p(patInfo,$c(2),1)
    .s admInfo=$p(patInfo,$c(2),2)
    .s prtStr=$g(^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job))
	.s prtInfo=..GetInvInfoByPrtRowid("",$p(prtStr,"^",2),$p(prtStr,"^",1))
	.s invNO=$p(prtInfo,"^",2) ;发票号
	.s prtUsrCode=$p(prtInfo,"^",11) ;收款员
	.s recDepLocInfo="",recdepDr="" 
	.f  s recdepDr=$o(^TMP("DHCOPBILL","OrdDirectList","Server",job,adm,recdepDr)) q:recdepDr=""  d
    ..s flag=""
    ..f  s flag=$o(^TMP("DHCOPBILL","OrdDirectList","Server",job,adm,recdepDr,flag)) q:flag=""  d
    ...s recDepLoc=$p(^CTLOC(recdepDr),"^",2)
	...i recDepLoc["-" s recDepLoc=$p(recDepLoc,"-",2)
	...;$p($g(^CTLOC(RoomDr,"ADDR","1")),"^",1)    
    ...;s RoomFloor=$p($g(^CTLOC(RoomDr)),"^",16)
	...s recDepLocPosition=$p($g(^CTLOC(recdepDr,"ADDR","1")),"^",1)  ;科室的物理地址
	...;申请医嘱特有信息
	...s diagDesc="" ;诊断信息
	...s lisInfo=""  ;临床诊断及实验室检查
	...s totalAmtSum=0
	...s ordDetial=..GetOrdDetails("Server",job, adm, recdepDr,flag,.totalAmtSum)
	...i recDepLocInfo="" d
	....s recDepLocInfo=recDepLoc_"^"_recDepLocPosition_"^"_baseInfo_"^"_admInfo_"^"_totalAmtSum_"^"_invNO_"^"_prtUsrCode_"^"_lisInfo_"^"_diagDesc_$c(3)_ordDetial
	...e  s recDepLocInfo=recDepLocInfo_$c(4)_recDepLoc_"^"_recDepLocPosition_"^"_baseInfo_"^"_admInfo_"^"_totalAmtSum_"^"_invNO_"^"_prtUsrCode_"^"_lisInfo_"^"_diagDesc_$c(3)_ordDetial
	.i ServerStr="" s ServerStr=recDepLocInfo
	.e  s ServerStr=ServerStr_$c(5)_recDepLocInfo
	
	q ServerStr
}

/// 获取非申请类医嘱导引单打印数据
ClassMethod GetNoServerPrtInfo(job)
{
	s adm="",noServerStr=""
	f  s adm=$o(^TMP("DHCOPBILL","OrdDirectList","NoServer",job,adm)) q:adm=""  d
    .s patInfo=..GetPatInfoByAdm(adm)
    .s baseInfo=$p(patInfo,$c(2),1)
    .s admInfo=$p(patInfo,$c(2),2)
    .s prtStr=$g(^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job))
	.s prtInfo=..GetInvInfoByPrtRowid("",$p(prtStr,"^",2),$p(prtStr,"^",1))
	.s invNO=$p(prtInfo,"^",2) ;发票号
	.s prtUsrCode=$p(prtInfo,"^",11) ;收款员
	.s recDepLocInfo="",recdepDr="" 
	.f  s recdepDr=$o(^TMP("DHCOPBILL","OrdDirectList","NoServer",job,adm,recdepDr)) q:recdepDr=""  d
    ..s flag=""
    ..f  s flag=$o(^TMP("DHCOPBILL","OrdDirectList","NoServer",job,adm,recdepDr,flag)) q:flag=""  d
    ...s recDepLoc=$p(^CTLOC(recdepDr),"^",2)
	...i recDepLoc["-" s recDepLoc=$p(recDepLoc,"-",2)
	...;$p($g(^CTLOC(RoomDr,"ADDR","1")),"^",1)    
    ...;s RoomFloor=$p($g(^CTLOC(RoomDr)),"^",16)
	...s recDepLocPosition=$p($g(^CTLOC(recdepDr,"ADDR","1")),"^",1)  ;科室的物理地址
	...s totalAmtSum=0
	...s ordDetial=..GetOrdDetails("NoServer",job, adm, recdepDr,flag,.totalAmtSum)
	...i recDepLocInfo="" d
	....s recDepLocInfo=recDepLoc_"^"_recDepLocPosition_"^"_baseInfo_"^"_admInfo_"^"_totalAmtSum_"^"_invNO_"^"_prtUsrCode_$c(3)_ordDetial
	...e  s recDepLocInfo=recDepLocInfo_$c(4)_recDepLoc_"^"_recDepLocPosition_"^"_baseInfo_"^"_admInfo_"^"_totalAmtSum_"^"_invNO_"^"_prtUsrCode_$c(3)_ordDetial
	.i noServerStr="" s noServerStr=recDepLocInfo
	.e  s noServerStr=noServerStr_$c(5)_recDepLocInfo
	
	q noServerStr
}

ClassMethod GetOrdDetails(flag, job, adm, recdepDr, flag2, totalAmtSum)
{
	s ordInfo="",totalAmtSum=0 ,ordDr=""
	f  s ordDr=$o(^TMP("DHCOPBILL","OrdDirectList",flag,job,adm,recdepDr,flag2,ordDr)) q:ordDr=""  d
	.s ordStr=$g(^DHCPB(+ordDr,"O",$p(ordDr,"||",2)))
	.q:ordStr=""
	.s arcmiDr=$p(ordStr,"^",3) ;医嘱项指针
	.s arcmiDesc=$p(^ARCIM(+arcmiDr,$p(arcmiDr,"||",2),1),"^",2) 
	.s oeoriDr=$p(ordStr,"^",4) ;医嘱指针
	.s prescNo=$p( ^OEORD(+oeoriDr,"I",$p(oeoriDr,"||",2),1),"^",15)      ;处方号
	.s labEpisodeNo=$p( ^OEORD(+oeoriDr,"I",$p(oeoriDr,"||",2),3),"^",20) ;检验条码号
	.s qty=+$p(ordStr,"^",5),refundQty=+$p(ordStr,"^",6)
	.s factQty=qty+refundQty
	.s unitPrice=$j($p(ordStr,"^",7),3,2)
	.s totalAmt=+$p(ordStr,"^",8)
	.s totalAmtSum=$j((totalAmtSum+totalAmt),3,2)
	.i ordInfo="" d
	..s ordInfo=arcmiDesc_"^"_factQty_"^"_unitPrice_"^"_$g(labEpisodeNo)
	.e  d
	..s ordInfo=ordInfo_"!"_arcmiDesc_"^"_factQty_"^"_unitPrice_"^"_$g(labEpisodeNo)
	
	q ordInfo
}

/// Lid
/// 2010-06-01
/// 根据就诊号取病人信息
/// w ##class(web.DHCOPBILLOrdDirectList).GetPatInfoByAdm(36046)
ClassMethod GetPatInfoByAdm(adm) As %String
{
	;取病人基本信息，就诊信息
	s adm=$g(adm)
	q:adm="" ""
	s patType=$p(^PAADM(adm),"^",2) 

	q:(patType'="O")&&(patType'="E") ;过滤非门诊病人

	s paperDr=$p(^PAADM(adm),"^",1)
	;病人基本信息
	s baseInfo=""
	s patNo=$p($g(^PAPER(paperDr,"PAT",1)),"^",1)   ;登记号
	s medicare=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "O", "")   ;病案号
	s patName=$p($g(^PAPER(paperDr,"ALL")),"^",1)   ;姓名
	s patmiId=$p($g(^PAPER(paperDr,"ALL")),"^",9)   ;身份证
	s sex=$p($g(^PAPER(paperDr,"ALL")),"^",7)       ;性别
	i (sex'="") s sex=$p(^CT("SEX",sex),"^",2)
	s age=##class(web.DHCBillInterface).GetPapmiAge(paperDr, "")
	s baseInfo=patNo_"^"_medicare_"^"_patName_"^"_sex_"^"_age
	 
	;病人就诊信息
	s admInfo=""
	s admDate=$p(^PAADM(adm),"^",6) ;就诊时间
	s admLoc=$p(^PAADM(adm),"^",4)  ;就诊科室
	i (admLoc'="") s admLoc=$p(^CTLOC(admLoc),"^",2) 
	i admLoc["-" s admLoc=$p(admLoc,"-",2)
	s admInfo=$zd(admDate,3)_"^"_admLoc

	q baseInfo_$c(2)_admInfo
}

ClassMethod GetPatientByPapmi(PapmiRowid As %String) As %String
{
	;获得病人个人信息
	q:PapmiRowid=""
	s PapmiOPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2)
	s PapmiIPNo=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",1)
	s PapmiNo=##Class(web.PAPatMas).GetRegistration(PapmiRowid)
	s PatientName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",1)
	s PatientDOB=$P($G(^PAPER(PapmiRowid,"ALL")),"^",6)
	s PatientBirthday=$ZD($G(PatientDOB),3)
	;
	s PatientSexDr=$P($G(^PAPER(PapmiRowid,"ALL")),"^",7)
	if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
	else  s PatientSex=""
	;
	s Pattype=""
	s PatientSocialStausDR=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10)
	i PatientSocialStausDR'=""  d
	.s Pattype=$p(^CT("SS",PatientSocialStausDR),"^",2)
	;
	s PatientCompany=$g(^PAPER(PapmiRowid,"PER","ADD",1))
	s PatientComAdd=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18)
	s EmployeeNO=$P($G(^PAPER(PapmiRowid,"EMP")),"^",5)
	s PatientMaritalDr=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",3)
	if PatientMaritalDr'="" s PatientMarital= $P($G(^CT("MAR",PatientMaritalDr)),"^",2)
	e  s PatientMarital="未知"
	s PatCategoryRowid=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",8)
	s Medcare=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",22)
	s Tel=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11)
	s PapmiName3=$P($G(^PAPER(PapmiRowid,"ALL")),"^",19)  //医保(卡/手册)号
	;
	s Age=$$CalAge^at182(PatientDOB,+$H,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=##class(web.DHCDocOrderEntry).FormatAge(AgeYear,AgeMonth,AgeDay)

	s ALLERGY=""
	s ALLERGY=$G(^PAPER(PapmiRowid,"ALLERGY",1))
	S NationDR=""
	s NationDR=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",1)
	s Nation=""
	if NationDR'="" s Nation=$p($g(^CT("NAT",NationDR)),"^",2)
	s Nation=$p(Nation,"-",2)
	s OccupationDR="",Occupation=""
	s OccupationDR=$p($g(^PAPER(PapmiRowid,"PER",2)),"^",6)
	if OccupationDR'="" s Occupation=$p($g(^CT("OCC",OccupationDR)),"^",2)
	s Occupation=$p(Occupation,"-",2)

	;RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard
	s RealName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",21)
	s RealCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",22)
	s SupplyName=$P($G(^PAPER(PapmiRowid,"ALL")),"^",23)
	s SupplyCard=$P($G(^PAPER(PapmiRowid,"ALL")),"^",24)
	s GovernCardNo=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",4)
	s PersonID=""
	s PersonID=$P($G(^PAPER(PapmiRowid,"ALL")),"^",9)   ;身份证
	s CFRowId="",CardNo="",find=0
	for {
		s CFRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,CFRowId),-1)
		q:((CFRowId="")!(find=1))
		s CardNo=$p($g(^DHCCARD("CF",CFRowId)),"^",2)
		s CardActived=$p($g(^DHCCARD("CF",CFRowId)),"^",10)
		i CardActived="N" s find=1
	}



	s ret= PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_PatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo
	s ret=ret_"^"_$g(Tel)_"^"_$G(ALLERGY)_"^"_$g(Nation)_"^"_$g(Occupation)_"^"_PapmiName3_"^"_$g(CardNo)_"^"_$g(PersonID)
	Q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBILLOrdDirectList","QueryAdmOrder",178222,"PRT")
Query QueryAdmOrder(ReceipID As %String, sFlag As %String) As websys.Query(ROWSPEC = "Tselect:%String,TOrder:%String,TOrderSum:%String,TOrderQty:%String,TRecloc:%String,TReturnQty:%String,TOrderRowid:%String,TExcuteflag:%String,RefSum:%String")
{
}

ClassMethod QueryAdmOrderExecute(ByRef qHandle As %Binary, ReceipID As %String, sFlag As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

	if (ReceipID="") quit $$$OK
		
	if (sFlag="PRT") do
	.set myINVRowID=ReceipID
	.do BuildData
	else  if (sFlag="API") do
	.set myACPRowID=0
	.for  set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",ReceipID,myACPRowID)) quit:(myACPRowID="")  do
	..set myINVRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..quit:(myINVRowID="")
	..do BuildData
	
	quit $$$OK
	
BuildData
	q:(myINVRowID="")
	
	s billConInv=0
	f  s billConInv=$o(^DHCBCI(0,"INV",myINVRowID,billConInv)) q:(billConInv="")  d
	.s pb=$p($g(^DHCBCI(billConInv)),"^",2)
	.s pbo=0
	.f  s pbo=$o(^DHCPB(pb,"O",pbo)) q:(pbo="")  d
	..s PBOData=$g(^DHCPB(pb,"O",pbo))
	..q:(PBOData="")
	..s Arcim=$p(PBOData,"^",3)
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) ;名称
	..s OEORI=$p(PBOData,"^",4)
	..s Executflag=0
	..s OrderUnitPrice=$p(PBOData,"^",7)	;PBO_UnitPrice
	..s Billreturnqty=+$p(PBOData,"^",6)		;PBO_RefundQty
	..s OrderBillQty=$p(PBOData,"^",5)		;PBO_BillQty
	..s returnqty=0
	..s confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	..s OrderBillQty=(OrderBillQty+Billreturnqty)/confac
	..s OrderBillQty=$fn(OrderBillQty,"N")
	..s PatSum=$p(PBOData,"^",11)
	..s PatSum=$fn(PatSum,"",2)
	..s myRefSum=PatSum
	..s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	..s recdepdesc=$p($g(^CTLOC(recdepcode)),"^",2)
	..s ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(Arcim, 0)
	..i (ordCateType="R")  d
	...s Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
	...;此处的部分退药?有个小Bug
	...s returnqty=##class(PHA.FACE.OUT.Com).GetRetOrdQty(OEORI, myINVRowID)   //退药数量
	...s confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	...s returnqty=returnqty/confac
	...i (Executflag=0) d
	....;药物医嘱?没有发药的
	...e  d
	....;药物医嘱?已经发药的?Executflag=1
	....;已经退药的
	....i (+returnqty'=0) d  
	.....i OrderBillQty=returnqty d
	.....e  d
	.....s myRefSum=$fn($fn((myRefSum/OrderBillQty),"",6)*returnqty,"",2)
	..e  d
	...s OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	...s OrdStatCode=$p(^OEC("OSTAT",OrdStat),"^",1)
	...s Executflag=$case(OrdStatCode,"E":1,:0)
	..s select=1  ;选中标志，默认全部选中
	..do OutputRow
	
	quit
OutputRow
	set Data=$lb(select,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// w ##class(web.DHCOPBILLOrdDirectList).GetRepROWID("0013")
ClassMethod GetRepROWID(ReceipNO As %String)
{
	s ret=0,sFlag=""
	s ReceipNO=ReceipNO
	s ReceipNO=$ZConvert(ReceipNO, "U")
	i ($d(^DHCINVPRT(0,"INV",ReceipNO))=0)&($d(^DHCINVPRTAPi(0,"INVNo",ReceipNO))=0)  s ret=-1    
	i $d(^DHCINVPRT(0,"INV",ReceipNO)) d
	.s INVPRTRowid="" 
	.s sFlag="PRT" 
	.f  s INVPRTRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,INVPRTRowid)) q:INVPRTRowid=""  d
	..s ret=INVPRTRowid
	
	q:ret'=0 ret_"^"_sFlag
	
	i $d(^DHCINVPRTAPi(0,"INVNo",ReceipNO)) d
	.s sFlag="API"
	.s INVPRTRowid=""  
	.f  s INVPRTRowid=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,INVPRTRowid)) q:INVPRTRowid=""  d
	..s ret=INVPRTRowid
	
	q ret_"^"_sFlag
}

/// 根据发票号或发票rowid获取发票信息
/// w ##class(web.DHCOPBILLOrdDirectList).GetInvInfoByPrtRowid("","13")
ClassMethod GetInvInfoByPrtRowid(invNO As %String = "", prtRowid As %String = "", sFlag As %String = "") As %String
{
	q:(invNO="")&&(prtRowid="") ""
	i prtRowid="" d
	.s invInfo=..GetRepROWID(invNO)
	.s prtRowid=$p(invInfo,"^",1)
	.s sFlag=$p(invInfo,"^",2)

	q:(prtRowid=-1)!(prtRowid=-2)!(sFlag="") ""
	s rtn=""
	i sFlag="PRT" d
	.s flag=$p($g(^DHCINVPRT(prtRowid)),"^",8)         ;状态
	.s PRTAcount=$p($g(^DHCINVPRT(prtRowid)),"^",1)    ;总金额
	.s prtInvNO=$p($g(^DHCINVPRT(prtRowid)),"^",14)    ;发票号
	.s PRTPatPay=$p($g(^DHCINVPRT(prtRowid)),"^",16)   ;病人支付金额
	.s PRTUsr=$p($g(^DHCINVPRT(prtRowid)),"^",21)      ;收款人
	.s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)       ;收款人Code
	.s PrtPapmiDR=$p($g(^DHCINVPRT(prtRowid)),"^",15)  ;
	.s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2) ;登记号
	.s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1) ;病人姓名
	.s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)  ;病人性别
	.s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	;
	;卡消费
	i sFlag="API" d
	.s flag=$p($g(^DHCINVPRTAP(prtRowid)),"^",2)         ;状态
	.s PRTAcount=$p($g(^DHCINVPRTAP(prtRowid)),"^",1)    ;总金额
	.s prtInvNO=$p($g(^DHCINVPRTAP(prtRowid)),"^",6)    ;发票号
	.s PRTPatPay=$p($g(^DHCINVPRTAP(prtRowid)),"^",13)   ;病人支付金额
	.s PRTUsr=$p($g(^DHCINVPRTAP(prtRowid)),"^",5)      ;收款人
	.s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)       ;收款人Code
	.s PrtPapmiDR=$p($g(^DHCINVPRTAP(prtRowid)),"^",11)  ;
	.s PapmiNo=$P($G(^PAPER(PrtPapmiDR,"PAT",1)),"^",2) ;登记号
	.s PapmiName=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",1) ;病人姓名
	.s PapmiSex=$P($G(^PAPER(PrtPapmiDR,"ALL")),"^",7)  ;病人性别
	.s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
	
	s rtn=sFlag_"^"_prtInvNO_"^"_prtRowid_"^"_PapmiNo_"^"_PapmiName_"^"_PapmiSex_"^"_PRTUsr_"^"_PRTAcount_"^"_PRTPatPay_"^"_flag_"^"_UserNo
	q rtn
}

/// Lid
/// 2010-06-10
/// 通过医嘱Rowid判断医嘱录入人是否为医护人员
/// 是:0,否:1
ClassMethod CheckISCareProvByOeoriDr(oeoridr)
{
	;^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
	s rtn=1
	s ordAddUser=$p(^OEORD(+oeoridr,"I",$p(oeoridr,"||",2),7),"^",1) ;医嘱录入人
	;判断录入人身份
	s careProvDr=$p(^SSU("SSUSR",ordAddUser),"^",14) ;医护人员表CT_CareProv
	q:$g(careProvDr)="" rtn
	
	s carPrvTpDr=$p(^CTPCP(careProvDr,1),"^",4)	     ;医护人员类型表CT_CarPrvTp
	s internalType=$p(^CT("CPT",carPrvTpDr),"^",4)   ;医护人员类型
	i (internalType="DOCTOR")!(internalType="NURSE") s rtn=0
	q rtn
}

/// Lid
/// 2010-11-11
/// 导诊单打印
/// w ##class(web.DHCOPBILLOrdDirectList).GetOrdDirectInfo(176525,"","PRT")
ClassMethod GetOrdDirectInfo(prtRowid, ordList As %String = "", sFlag)
{
	s job=$j
	 ;清楚临时数据
	k ^TMP("DHCOPBILL","OrdDirectList",job)
    k ^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job)
    
    s ^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job)=sFlag_"^"_prtRowid ;用于区分集中打印发票和直接打印发票
	d ..SetDataByPrtRowid(prtRowid,ordList,sFlag,job)  ;生成导引单数据

	s printInfo=..GetDataInfo(job)
    
    ;清楚临时数据
    k ^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job)

	q printInfo
}

/// Lid
/// 2010-11-11
/// 生成导诊单数据
ClassMethod SetDataByPrtRowid(prtRowid, ordList, sFlag, job)
{
	if sFlag="PRT" d
	.d SetPBOData(prtRowid,ordList,job)

	;卡消费
	i sFlag="API" d
	.s myACPRowID=0
	.f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",prtRowid,myACPRowID)) q:(myACPRowID="")  d
	..s myINVRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	..q:(myINVRowID="")
	..d SetPBOData(myINVRowID,ordList,job)
    
SetPBOData(prtRowid,ordList,job) 
	s invLinkDr=""
    f  s invLinkDr=$o(^DHCBCI(0,"INV",prtRowid,invLinkDr)) Quit:invLinkDr=""  Do
	.s bill=$p(^DHCBCI(invLinkDr),"^",2)
	.s adm=$p(^DHCBCI(invLinkDr),"^",3)   ;就诊Rowid
	.q:'$D(^DHCPB(bill))
	.Set ord=0 
	.f  Set ord=$o(^DHCPB(bill,"O",ord)) Quit:ord=""  Do
	..q:($d(^DHCPB(bill,"O",ord))=10)
	..s oeitDr=$p(^DHCPB(bill,"O",ord),"^",4)  ;医嘱表Rowid
	..q:(+ordList'=0)&&(("^"_ordList_"^")'[("^"_oeitDr_"^"))  ;过滤医嘱
	..s arcimDr=$p(^DHCPB(bill,"O",ord),"^",3) ;医嘱项Rowid DHC_PatBillOrder->PBO_ARCIM_DR
	..s arcItmCatDr=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",10) ;医嘱子类()
	..s orderType=$p(^ARC("IC",arcItmCatDr),"^",7)                   ;医嘱类型
	..s serverMaterial=$p($g(^ARCIM($p(arcimDr,"||",1),$p(arcimDr,"||",2),7)),"^",6) ;申请医嘱判断标志
	..s billed=$p(^OEORD(+oeitDr,"I",$p(oeitDr,"||",2),3),"^",5)   ;医嘱账单标志
	..q:(billed'="P")  ;过滤未结算医嘱
	..s myPresNo=$p(^OEORD(+oeitDr,"I",$p(oeitDr,"||",2),1),"^",14)
	..s recdepDR=$p($g(^OEORD(+oeitDr,"I",+$p(oeitDr,"||",2),3)),"^",6) ;接收科室
	..s loctype=$p(^CTLOC(recdepDR),"^",13)   ;Ward||W Execute||E Drug Injection||DI Dispensing||D_
	..i loctype="" s loctype="Z"	;放在最后?
	..s ordRowid=bill_"||"_ord  ;生成DHC_PatbillOrder表Rowid
	..s ^TMP("DHCOPBILL","OrdDirectList",job,adm,recdepDR,ordRowid)=ordRowid
	
	q
}

/// Lid
/// 2010-11-11
/// 获取导诊单打印数据信息
ClassMethod GetDataInfo(job)
{
	s adm="",Str="",del="^",recDepLocInfo=""
	f  s adm=$o(^TMP("DHCOPBILL","OrdDirectList",job,adm)) q:adm=""  d
	.s PAPMI=$p($g(^PAADM(adm)),"^",1)
	.s retPatInfo=..GetPatientByPapmi(PAPMI)
    .;登记号^卡号^姓名^年龄^性别
    .s patInfo=$p(retPatInfo,"^",2)_del_$p(retPatInfo,"^",30)_del_$p(retPatInfo,"^",3)_del_$p(retPatInfo,"^",5)_del_$p(retPatInfo,"^",4)
    .;s patInfo=..GetPatInfoByAdm(adm)
    .;s baseInfo=$p(patInfo,$c(2),1)
    .;s admInfo=$p(patInfo,$c(2),2)
    .;s prtStr=$g(^TMP("DHCOPBILL","OrdDirectList","PRTRowid",job))
	.;s prtInfo=..GetInvInfoByPrtRowid("",$p(prtStr,"^",2),$p(prtStr,"^",1))
	.;s invNO=$p(prtInfo,"^",2) ;发票号
	.;s prtUsrCode=$p(prtInfo,"^",11) ;收款员
	.s recDepLocInfo="",recdepDr="" 
	.f  s recdepDr=$o(^TMP("DHCOPBILL","OrdDirectList",job,adm,recdepDr)) q:recdepDr=""  d
    ..s recDepLoc=$p(^CTLOC(recdepDr),"^",2)
	..i recDepLoc["-" s recDepLoc=$p(recDepLoc,"-",2)
	..;$p($g(^CTLOC(RoomDr,"ADDR","1")),"^",1)    
    ..;s RoomFloor=$p($g(^CTLOC(RoomDr)),"^",16)
	..s recDepLocPosition=$p($g(^CTLOC(recdepDr,"ADDR","1")),"^",1)  ;科室的物理地址
	..s totalAmtSum=0,ordList=""
	..s ordDr=""
	..f  s ordDr=$o(^TMP("DHCOPBILL","OrdDirectList",job,adm,recdepDr,ordDr)) q:ordDr=""  d
	...s ordStr=$g(^DHCPB(+ordDr,"O",$p(ordDr,"||",2)))
	...q:ordStr=""
	...s arcmiDr=$p(ordStr,"^",3) ;医嘱项指针
	...s arcmiDesc=$p(^ARCIM(+arcmiDr,$p(arcmiDr,"||",2),1),"^",2) 
	...s oeoriDr=$p(ordStr,"^",4) ;医嘱指针
	...s prescNo=$p( ^OEORD(+oeoriDr,"I",$p(oeoriDr,"||",2),1),"^",15)      ;处方号
	...s labEpisodeNo=$p( ^OEORD(+oeoriDr,"I",$p(oeoriDr,"||",2),3),"^",20) ;检验条码号
	...s qty=+$p(ordStr,"^",5),refundQty=+$p(ordStr,"^",6)
	...s factQty=qty+refundQty
	...s unitPrice=$j($p(ordStr,"^",7),3,2)
	...s totalAmt=+$p(ordStr,"^",8)
	...s totalAmtSum=$j((totalAmtSum+totalAmt),3,2)
	...s tmpList=##class(web.DHCDocService).GetOrdByOrdId(oeoriDr) ;调用医生站接口获取医嘱列表信息
	...i ordList="" s ordList=tmpList
	...e  s ordList=ordList_$c(3)_tmpList
	..s tmpStr=patInfo_del_recDepLoc_del_recDepLocPosition_del_$zd($h,3)_"  "_$zt($h,1)_del_"合计:"_$fn(totalAmtSum,"",2)_"  已收:"_$fn(totalAmtSum,"",2)_"  未收:"_$fn(0,"",2)_$c(2)_ordList
	..i recDepLocInfo="" d
	...s recDepLocInfo=tmpStr
	..e  d
	...s recDepLocInfo=recDepLocInfo_$c(1)_tmpStr
	
	q recDepLocInfo
}

/// Lid
/// 2010-07-29
/// 根据医嘱Rowid，获取检验标本
/// oe_orditem,oe_ordspecimen(oe_orditem的子表)
/// ct_specimen(标本代码表)
/// w ##class(web.DHCOPBILLOrdDirectList).GetlabEpisodeDesc("35787||3")
ClassMethod GetlabEpisodeDesc(oeoridr)
{
	;^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub},"SPEC",{SPEC_Childsub})
	s specSub=$o(^OEORD(+oeoridr,"I",$p(oeoridr,"||",2),"SPEC",""),-1)
	q:+specSub=0 ""
	q:'$d(^OEORD(+oeoridr,"I",$p(oeoridr,"||",2),"SPEC",specSub)) ""
	s specCode=$p(^OEORD(+oeoridr,"I",$p(oeoridr,"||",2),"SPEC",specSub),"^",1) ;标本代码表的Code 
	;s info=$g(^TTAB("SPEC",specCode))  
	;s specDesc=$p(info,"\",1)
	s specDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2)
	q specDesc
}

/// Lid
/// 2010-08-11
/// 获取取报告时间
/// oe_orditem,ARC_ItmMast,ARC_ItemExternalCodes
/// w ##class(web.DHCOPBILLOrdDirectList).GetlabReportDate("8352||16")
ClassMethod GetlabReportDate(oeoridr)
{
	;医嘱项Rowid
	s arcimdr=$p(^OEORD(+oeoridr,"I",$p(oeoridr,"||",2),1),"^",2) ;OEORI_ItmMast_DR->ARC_ItmMast
   	s extsub=$o(^ARCIM(+arcimdr,$p(arcimdr,"||",2),"EXT","0")) ;取第一条记录
   	q:extsub="" ""
   	s extCode=$p(^ARCIM(+arcimdr,$p(arcimdr,"||",2),"EXT",extsub),"^",4)
   	q:extCode="" ""
   	q:'$d(^TTAB("TS",$g(extCode))) ""
   	s reportDate=$p(^TTAB("TS",extCode),"\",33)
   	q reportDate
}

/// Creator:Lid
/// CreatDate:2012-08-29
/// Desc:根据Adm获取检查的划价医嘱
/// Input:
/// Return:
/// Debug:w ##class(web.DHCOPBILLOrdDirectList).GetPrescPriceOrditem(8514)
ClassMethod GetPrescPriceOrditem(Adm)
{
	New (Adm)
	;^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	;^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
	Set OEORDDR="",rtn=""
	For  Set OEORDDR=$o(^OEORD(0,"Adm",Adm,OEORDDR)) Quit:OEORDDR=""  Do
	.Quit:'$d(^OEORD(OEORDDR))
	.Set Sub=""
	.For  Set Sub=$o(^OEORD(OEORDDR,"I",Sub)) Quit:Sub=""  Do
	..Set OEORIDR=OEORDDR_"||"_Sub
	..Set PrescPriceFlag="" ;##class(web.UDHCJFBILL).GetPrescPriceOrdItemFlag(OEORIDR,"")
    ..Set OEPflag=$p(PrescPriceFlag,"^",1)
    ..Set OEPInputFlag=$p(PrescPriceFlag,"^",2)
    ..Quit:OEPflag'="Y"	;过滤非划价医嘱
    ..Quit:(OEPflag="Y")&(OEPInputFlag="Y")&($d(^PrescPriceOrdItemSend(Adm,OEORIDR)))	;过滤已经划价且已给平台发送的医嘱
    ..If rtn=""  Set rtn=OEORIDR
    ..Else  Set rtn=rtn_"^"_OEORIDR
    ;
    Quit rtn
}

ClassMethod GetHospDesc(LocRowid As %String) As %String
{
	n (LocRowid)
	s HospID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocRowid)
	s HospDesc=""
	i (HospID'="") s HospDesc=$p(^CT("HOSP",HospID),"^",2)
	q HospDesc
}

/// 根据集中打印发票表获取
/// w ##class(web.DHCOPBILLOrdDirectList).GetPrtRowId(20689)
ClassMethod GetPrtRowId(apiRowId As %String) As %String
{
	new (apiRowId)
	set prtRowIdStr=""
	set acpDr="0"
	for  set acpDr=$o(^DHCINVPRTCAPi(0,"APINVDR",apiRowId,acpDr)) quit:(acpDr="")  do
	.set prtRowId=$p(^DHCINVPRTCAP(acpDr),"^",1)
	.if (prtRowIdStr="") set prtRowIdStr=prtRowId
	.else  set prtRowIdStr=prtRowIdStr_"^"_prtRowId
	quit prtRowIdStr
}

}
