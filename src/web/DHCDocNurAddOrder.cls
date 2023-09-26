Class web.DHCDocNurAddOrder Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindAdmVOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmVOrderItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDate() As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetDate()
	;s curDate=""
	s curDate=$zd(+$h,3)
 	q curDate
}

ClassMethod FindAdmVOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, StDate As %String, EndDate As %String, PriorCode As %String, AllOrd As %String, SelDate As %String, DocOrd As %String, NurOrd As %String, NewOrd As %String) As %Status
{
	//D ##class(%ResultSet).RunQuery("web.DHCDocNurAddOrder","FindAdmVOrderItems",76977,62380,62380,"Long",0,0,1,1,1)
	s ^TMP("FindAdmVOrderItems")=EpisodeID_","_StDate_","_EndDate_","_PriorCode_","_AllOrd_","_SelDate_","_DocOrd_","_NurOrd_","_NewOrd
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s LogonDepDR=%session.Get("LOGON.CTLOCID")
	s LogonHospDr=$P(^CTLOC(LogonDepDR),"^",22)
	s LinkLocStr=..GetLinkLocation(LogonDepDR)
 	s PriorDescStr=""
 	i PriorCode="Temp" s PriorDescStr=$g(^DHCOEOrdPrintSet("OrdTyp"))
 	e  i PriorCode="Long" s PriorDescStr=$g(^DHCOEOrdPrintSet("L","OrdTyp"))
 	//i PriorCode=""  s PriorID=$O(^OECPR(0,"Code","S",0)) ;长期医嘱 
 	i StDate>EndDate s StDate=EndDate
	i SelDate=1  d 
	.i StDate=""  s StDate=..%SysDate()
	.i EndDate=""  s EndDate=..%SysDate()+1
	e  d 
	.s SttDate=..%SysDate() s EndDate=..%SysDate()+1
	i StDate'="" s StDate=..%ZDH(StDate)
    i EndDate'="" s EndDate=..%ZDH(EndDate)
	k ^CacheTemp("GetUnSelOrderData",$j)
	if NewOrd="1"  d
	d GetNewOrder   //查找当日新医嘱
	else  d
	.d GetUnSelOrder  //查找当日及之前的所有未补录项目
	
	s count=0 for  s count=$o(^CacheTemp("GetUnSelOrderData",$j,count))  q:count=""  d
	.Set ^CacheTemp(repid,ind)=^CacheTemp("GetUnSelOrderData",$j,count)
 	.Set ind=ind+1
	k ^CacheTemp("GetUnSelOrderData",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetNewOrder
    k ^CacheTemp("GetNewOrder",$j)
	s CareOrderAvialFlag=0
	q:EpisodeID="" 
	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:OrderRowid=""
	s OrderDates=..%SysDate()
    s ChildSub=0 f  s ChildSub=$O(^OEORDi(0,"StDt",OrderDates,OrderRowid,ChildSub)) Q:(ChildSub="")  d
	.s OrdStatus=$p($g(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ChildSub,1),"^",13))),"^",1) 
	.q:(OrdStatus'="V")
	.s ArcimRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)		;OEORI_ItmMast_DR
	.q:ArcimRowid=""
	.s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	.q:ItemCatRowid=""
	.s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
 	.if OrderType="L" d
 	..s printflag=..GetPrintFlag(OrderRowid,ChildSub)
 	.q:$G(printflag)="Y"
 	.s catdesc=##class(web.DHCSETIMAGE).GetOrdCat(OrderRowid,ChildSub)
    .q:(catdesc="消耗材料")!(catdesc="普通项目")
    .s fillerNo=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",12)
    .q:fillerNo'=""
    .s ExecFlag=0
    .s ExeChildSub="" f  s ExeChildSub=$o(^OEORD(OrderRowid,"I",ChildSub,"X",ExeChildSub)) q:(ExeChildSub="")!(ExecFlag=1)  d
    ..q:'$d(^OEORD(OrderRowid,"I",ChildSub,"X",ExeChildSub))
    ..s ExecDate=$p(^OEORD(OrderRowid,"I",ChildSub,"X",ExeChildSub),"^",19)   ;执行日期
 	..s ExecCTP=$p(^OEORD(OrderRowid,"I",ChildSub,"X",ExeChildSub),"^",15)     ;执行人
 	..s ExecStateDR=$p(^OEORD(OrderRowid,"I",ChildSub,"X",ExeChildSub),"^",16)  ;执行状态
	..s:ExecStateDR'="" ExecState=$p($g(^OEC("STAT",ExecStateDR)),"^")  //撤销执行的医嘱排除掉
 	..i (ExecDate'="")&(ExecCTP'="")&&$g(ExecState)'="C" s ExecFlag=1  Q
 	.q:ExecFlag=1
	.s LinkOrderItem=$p($G(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
	.q:LinkOrderItem'=""
	.s ^CacheTemp("GetNewOrder",$j,"master",OrderRowid_"||"_ChildSub)=""
	.s LinkSub="" f  s LinkSub=$o(^OEORDi(0,"OEORI",OrderRowid,OrderRowid_"||"_ChildSub,LinkSub)) q:(LinkSub="")  d
	..s OrderSubItem=OrderRowid_"||"_LinkSub
	..s ^CacheTemp("GetNewOrder",$j,"master",OrderRowid_"||"_ChildSub,"child",OrderRowid_"||"_LinkSub)=""
	s n=0
	s mast=""  for  s mast=$O(^CacheTemp("GetNewOrder",$j,"master",mast)) q:mast=""  d
	.d OutputRowVerify(+mast,$p(mast,"||",2))
	.s sub=""  for  s sub=$O(^CacheTemp("GetNewOrder",$j,"master",mast,"child",sub)) q:sub=""  d
	..d OutputRowVerify(+sub,$p(sub,"||",2))
 	q 		
GetUnSelOrder
    k ^CacheTemp("GetUnSelOrder",$j)
	s CareOrderAvialFlag=0
	q:EpisodeID="" 
	s OrderRowid=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:OrderRowid=""
	f OrderDates=StDate:1:EndDate  D
	.Q:'$D(^OEORDi(0,"StDt",OrderDates))
    .s ChildSub=0 f  s ChildSub=$O(^OEORDi(0,"StDt",OrderDates,OrderRowid,ChildSub)) Q:(ChildSub="")  d
	..s OrdStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ChildSub,1),"^",13)),"^",1)
	..q:(OrdStatus'="V")&(OrdStatus'="E")
	..s LinkOrderItem=$p($G(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
	..q:LinkOrderItem'=""
	..s ^CacheTemp("GetUnSelOrder",$j,"master",OrderRowid_"||"_ChildSub)=""
	..s LinkSub="" f  s LinkSub=$o(^OEORDi(0,"OEORI",OrderRowid,OrderRowid_"||"_ChildSub,LinkSub)) q:(LinkSub="")  d
	...s OrderSubItem=OrderRowid_"||"_LinkSub
	...s LinkOrdStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",LinkSub,1),"^",13)),"^",1)
	...q:(LinkOrdStatus'="V")&(LinkOrdStatus'="E")
	...s ^CacheTemp("GetUnSelOrder",$j,"master",OrderRowid_"||"_ChildSub,"child",OrderRowid_"||"_LinkSub)=""
	s n=0
	s mast=""  for  s mast=$O(^CacheTemp("GetUnSelOrder",$j,"master",mast)) q:mast=""  d
	.d OutputRowVerify(+mast,$p(mast,"||",2))
	.s sub=""  for  s sub=$O(^CacheTemp("GetUnSelOrder",$j,"master",mast,"child",sub)) q:sub=""  d
	..d OutputRowVerify(+sub,$p(sub,"||",2))
 	q 
	
OutputRowVerify(ord,child)
    s (SfrDesc,OEORIFlowRateUnit,OEORISpeedFlowRat,OrderName,OrderItemRowId,OrderSeqNo,OrderPriorRowid,OrderPrior,OrderDate,OrderTime,OrderDocDesc,OrderStartDate,OrderStartTime,SelectOrderItem,OrderLinkOrderDR,OrderFreq,OrderInstr,OrderInstrRowid,OrderDoseQty,OrderDepProcNote,OrderFreqRowid,OrderRecDep,LabelDesc,LabEpisodeNo,ARCIMRowid,PackQty)=""
    s OrderSeqNo=$p($g(^OEORD(ord,"I",child,3)),"^",4)		;OEORI_SeqNo
	s ARCIMRowid=$p($g(^OEORD(ord,"I",child,1)),"^",2)		;OEORI_ItmMast_DR
	s ARCIMSubScript=$p(ARCIMRowid,"||",1)
	s ARCIMSubVersion=$p(ARCIMRowid,"||",2)
	s ARCICRowId=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",10)  ;ARCIM_ItemCat_DR  
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ARCICRowId,LogonHospDr,ARCIMRowid)
	;使用草药录入程序
	s UseCNMedEntry=..%GetConfig("UseCNMedEntry")
	;q:(PHPrescType="3")&(UseCNMedEntry="1")
	s OrderPriorRowid=$p($g(^OEORD(ord,"I",child,1)),"^",8) ;OEORI_Priority_DR
	q:OrderPriorRowid=""  //床位费和诊疗费没有医嘱优先级,也不需要显示
	s OrderPrior=$p($g(^OECPR(OrderPriorRowid)),"^",2)
	q:(PriorDescStr'="")&&(PriorDescStr'[OrderPrior)
	s OrderOrdLocDR=$p($g(^OEORD(ord,"I",child,7)),"^",2)
	q:(("^"_LinkLocStr_"^")'[("^"_OrderOrdLocDR_"^"))&(LogonDepDR'=OrderOrdLocDR)
	s ItemCatDR=$p(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1),"^",10) //医嘱类型dr
	s ItemOrderType=$P(^ARC("IC",ItemCatDR),"^",7)           //医嘱类型 代码
	;q:ItemOrderType'="R"
 	s catdr=$p(^ARC("IC",ItemCatDR),"^",8)
 	q:catdr=""
 	q:'$d(^OEC("ORCAT",catdr))
 	s ordCatDesc=$p(^OEC("ORCAT",catdr),"^",2)
	s OrderName=""
	s ItemOrderType=$P(^ARC("IC",ItemCatDR),"^",7)           //医嘱类型 代码
	s OrderName=$p(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1),"^",2)
	q:OrderName["自定义"
	i OrderSeqNo["." s OrderName="____"_OrderName  //如果为子医嘱 名称前增加缩进
	s OrderItemRowId=ord_"||"_child
	s OrderStartDate=$p($g(^OEORD(ord,"I",child,1)),"^",9)
	i (OrderPriorRowid=3)&(OrderStartDate<+$h)  s OldFlag=1
	e  s OldFlag=""
	s OrderStartDate=..%ZD(OrderStartDate) //$zd(OrderStartDate,3)
	s OrderStartTime=$p($g(^OEORD(ord,"I",child,1)),"^",10)
	s OrderStartTime=..%ZT(OrderStartTime,1)
	s OrderDate=$p($g(^OEORD(ord,"I",child,3)),"^",7)
	s OrderDate=..%ZD(OrderDate) //$zd(OrderDate,3)
	s OrderTime=$p($g(^OEORD(ord,"I",child,1)),"^",17)
	s OrderTime=..%ZT(OrderTime,1)
	s OrderLinkOrderDR=$p($g(^OEORD(ord,"I",child,11)),"^",39)
	s OrderDocDR=$p($g(^OEORD(ord,"I",child,1)),"^",11)
	q:OrderDocDR=""
	s OrderDocDesc=$p($g(^CTPCP(OrderDocDR,1)),"^",2)
	s CpTypDR=$P(^CTPCP(OrderDocDR,1),"^",4)  ;CTPCP_CarPrvTp_DR 医护人员类型
	q:CpTypDR=""
	q:'$d(^CT("CPT",CpTypDR))
	s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	q:(NurOrd'=0)&(DocOrd=0)&($G(CpTyp)="DOCTOR")
	q:(DocOrd'=0)&(NurOrd=0)&($G(CpTyp)="NURSE")
	s OrderFillerNoStr=$p($g(^OEORD(ord,"I",child,9)),"^",12)
	;q:OrderFillerNoStr'=""
	s SelectOrderItem=$p($g(^OEORD(ord,"I",child,"DHC")),"^",35)
	i OrderLinkOrderDR'=""  d
	.s SelectOrderItem=$p($g(^OEORD(+OrderLinkOrderDR,"I",$p(OrderLinkOrderDR,"||",2),"DHC")),"^",35)
	;q:(SelectOrderItem="Y")&(OrdersDate'=OrderSttDate)
  i SelectOrderItem="Y" s SelectOrderItem=1
  e  s SelectOrderItem=0
	s OrderFreq=""
	s OrderFreqRowid=$p($g(^OEORD(ord,"I",child,2)),"^",4)		;OEORI_PHFreq_DR
	i OrderFreqRowid'="" s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",3)
	s OrderInstr=""
	s OrderInstrRowid=$p($g(^OEORD(ord,"I",child,2)),"^",7)		;OEORI_Instr_DR
	i OrderInstrRowid'="" s OrderInstr=$p($g(^PHCIN(OrderInstrRowid)),"^",2)  
	s OrderDoseQty=$p($g(^OEORD(ord,"I",child,2)),"^",1)	;OEORI_DoseQty
	s OrderDoseUOMRowid=$p($g(^OEORD(ord,"I",child,2)),"^",3)	;OEORI_Unit_DR
	i OrderDoseUOMRowid'="" s OrderDoseUOM=$p($g(^CT("UOM",OrderDoseUOMRowid)),"^",2)				;剂量单位
	e  s OrderDoseUOM=""
	s LabelDesc=##class(web.DHCNurCom).GetLabelDesc(ord_"||"_child)
	s LabEpisodeNo=$p($g(^OEORD(ord,"I",child,3)),"^",20)  ;OEORI_LabEpisodeNo
	s OrderDoseQty=OrderDoseQty_" "_OrderDoseUOM
	s OrderDepProcNote=$g(^OEORD(ord,"I",child,"DEP",1))			;OEORI_DepProcNotes
	s OEORISpeedFlowRat=$p($g(^OEORD(ord,"I",child,3)),"^",17)
	s OEORIFlowRateUnit=$p($g(^OEORD(ord,"I",child,6)),"^",8)
	i OEORIFlowRateUnit'=""  d
	.s SfrDesc=$p($g(^OEC("SFR",OEORIFlowRateUnit)),"^",2)
    .s SpeedFlowRat="("_"流速:"_OEORISpeedFlowRat_SfrDesc_""_")"
	.s OrderName=OrderName_SpeedFlowRat
	s RecDepDR=$p($g(^OEORD(ord,"I",child,3)),"^",6)
	i RecDepDR="" s OrderRecDep=""
	e  s OrderRecDep=$p($g(^CTLOC(RecDepDR)),"^",2)
	s ARCIMRowid=ord_"||"_child
	i (ItemOrderType="R") d
	.s PackQty=$P($G(^OEORD(ord,"I",child,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	e  d
	.s PackQty=$P($G(^OEORD(ord,"I",child,1)),"^",12)  ;oeori_Phqtyord  shu liang
 	i (PackQty="")&&$p(PackQty,".",1)="" s PackQty=0_PackQty
 	 
 	s Data=$lb(OrderName,OrderItemRowId,OrderSeqNo,OrderPriorRowid,OrderPrior,OrderDate,OrderTime,OrderDocDesc,OrderStartDate,OrderStartTime,SelectOrderItem,OrderLinkOrderDR,OrderFreq,OrderInstr,OrderInstrRowid,OrderDoseQty,OrderDepProcNote,OrderFreqRowid,OrderRecDep,LabelDesc,LabEpisodeNo,ARCIMRowid,PackQty,OldFlag)
 	s n=n+1
 	s ^CacheTemp("GetUnSelOrderData",$j,n)=Data
 quit
}

ClassMethod FindAdmVOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmVOrderItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*Query FindAdmVOrderItemsBak(EpisodeID As %String, SttDate As %String, EndDate As %String, PriorID As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "医嘱名称:%String,OrderItemRowId:%String,OrderSeqNo:%String,Hidden:%String,医嘱日期:%String,医嘱时间:%String,下医嘱医生:%String,开始日期:%String")
{
}*/
Query FindAdmVOrderItems(EpisodeID As %String, StDate As %String, EndDate As %String, PriorCode As %String, AllOrd As %String, SelDate As %String, DocOrd As %String, NurOrd As %String, NewOrd As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "OrderName:%String,OrderItemRowId:%String,OrderSeqNo:%String,OrderPriorRowid:%String,OrderPrior:%String,OrderDate:%String,OrderTime:%String,OrderDocDesc:%String,OrderStartDate:%String,OrderStartTime:%String,SelectOrderItem:%String,OrderLinkOrderDR:%String,OrderFreq:%String,OrderInstr:%String,OrderInstrRowid:%String,OrderDoseQty:%String,OrderDepProcNote:%String,OrderFreqRowid:%String,OrderRecDep:%String,LabelDesc:%String,LabEpisodeNo:%String,ARCIMRowid:%String,PackQty:%String,OldFlag:%String")
{
}

// Creator:		徐鹏

// CreatDate:    2009.07.17

// Description:	根据已经录入的医嘱的用法,查找该用法对应的医嘱

// Table:        ARC_ItmMast,OE_OrdItem

// Input:        EpisodeID:就诊ID,已录入的医嘱

// Output:       已录入医嘱的用法对应的医嘱

ClassMethod FindInstrLinkItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrLinkItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindInstrLinkItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, MasterOrderItemRowId As %String) As %Status
{
	// w ##class(web.DHCDocNurAddOrder).FindInstrLinkItemsExecute("","180241","180157||543")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    s LogonDepDR=%session.Get("LOGON.CTLOCID")
 	s OrderRowid=$p(MasterOrderItemRowId,"||",1)
 	s ChildSub=$p(MasterOrderItemRowId,"||",2)
	s OrderInstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)		;OEORI_Instr_DR
	i OrderInstrRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ARCIMStr=..GetInstrArcimStr(EpisodeID,OrderInstrRowid)
	i ARCIMStr=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s Len=$l(ARCIMStr,"^")
	f i=1:1:Len  d
	.s ARCIMRowid=$p($p(ARCIMStr,"^",i),"!",1)
	.s UseLocRowId=$p($p(ARCIMStr,"^",i),"!",2)
	.//q:(LogonDepDR'=UseLocRowId)&&(UseLocRowId'="")
	.s ARCIMSubScript=$p(ARCIMRowid,"||",1)
	.s ARCIMSubVersion=$p(ARCIMRowid,"||",2)
	.s OrderName=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",2)  
	.s ARCICRowId=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",10)  ;ARCIM_ItemCat_DR
	.s Item=OrderName
	.s ItemRowid=ARCIMRowid
	.s ItemOrderType=$p($g(^ARC("IC",ARCICRowId)),"^",7)
	.s Data=$lb(Item,ItemRowid,ItemOrderType)
	.Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindInstrLinkItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrLinkItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindInstrLinkItems(EpisodeID As %String = "", MasterOrderItemRowId As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "Item:%String,ItemRowid:%String,ItemOrderType:%String")
{
}

ClassMethod SaveDone(OrderItemStr As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).SaveDone("","180241","180157||543")
	q:OrderItemStr="" 1
	s Len=$l(OrderItemStr,"^")
	f i=1:1:Len  d
	.s OrderItemRowId=$p(OrderItemStr,"^",i)
	.s $p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"DHC"),"^",35)="Y"
	.s ChildSub=0
	.f  s ChildSub=$o(^OEORDi(0,"OEORI",+OrderItemRowId,OrderItemRowId,ChildSub)) q:ChildSub=""  d
	..s $p(^OEORD(+OrderItemRowId,"I",ChildSub,"DHC"),"^",35)="Y"
	q 1
}

ClassMethod UnSave(OrderItemStr As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).SaveDone("","180241","180157||543")
	q:OrderItemStr="" 1
	s Len=$l(OrderItemStr,"^")
	f i=1:1:Len  d
	.s OrderItemRowId=$p(OrderItemStr,"^",i)
	.s $p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"DHC"),"^",35)="N"
	q 1
}

// 取得用法关联的医嘱数量

ClassMethod GetInstrLinkItemsNum(EpisodeID As %String, MasterOrderItemRowId As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetInstrLinkItemsNum("180241","180226||604")
 	s Num=0
 	s OrderRowid=$p(MasterOrderItemRowId,"||",1)
 	s ChildSub=$p(MasterOrderItemRowId,"||",2)
	s OrderInstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)		;OEORI_Instr_DR
	q:OrderInstrRowid="" 0
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ARCIMStr=..GetInstrArcimStr(EpisodeID,OrderInstrRowid)
	q:ARCIMStr="" 0
	s Len=$l(ARCIMStr,"^")
	q Len
}

ClassMethod GetFreqDesc(OrderFreqRowid As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetInstrLinkItemsNum("180241","180226||604")
	q:OrderFreqRowid="" ""
 	s OrderFreq=$p($g(^PHCFR(OrderFreqRowid)),"^",3)
 	q OrderFreq
}

ClassMethod GetLinkLocation(QueLocRowid As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetLinkLocation(15)
	s LinkLocStr=""
	s LinkSub=0
	f  s LinkSub=$o(^CTLOC(QueLocRowid,"LINK",LinkSub)) q:LinkSub=""  d
	.s LinkLocDR=$p($g(^CTLOC(QueLocRowid,"LINK",LinkSub)),"^",1)
	.i LinkLocStr=""  s LinkLocStr=LinkLocDR
	.e  s LinkLocStr=LinkLocStr_"^"_LinkLocDR
 	q LinkLocStr
}

ClassMethod GetLinkOrdersBroker(itmjs As %Library.String = "", EpisodeID As %String, MasterOrderItemRowId As %String, ARCIMRowid1 As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetInstrLinkItemsNum("180241","180226||604")
 	Set rset=##class(%ResultSet).%New("web.DHCDocNurAddOrder:FindInstrLinkItems")
 	do rset.Execute(EpisodeID,MasterOrderItemRowId)
 	While (rset.Next()) {
 		s OrderName=rset.GetData(1)
 		s ARCIMRowid=rset.GetData(2)
 		s ItemOrderType=rset.GetData(3)
 		s LinkOrdersStr=OrderName_"^"_ARCIMRowid_"^"_ItemOrderType_"^"_"1"_"^"_ARCIMRowid1
 		//s retval=itmjs_"('"_$ZCVT($g(OrderName),"O","JS")_"','"_$ZCVT($g(ARCIMRowid),"O","JS")_"','"_$ZCVT($g(ItemOrderType),"O","JS")_"');"
 		s retval=itmjs_"('"_$ZCVT($g(LinkOrdersStr),"O","JS")_"');"
		&javascript<#(retval)#>
 	}
 	d rset.Close()
 	q 0
}

ClassMethod GetLinkLabOrdersBroker(itmjs As %Library.String = "", EpisodeID As %String, LabelDesc As %String, ARCIMRowid2 As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetInstrLinkItemsNum("180241","180226||604")
 	//Set rset=##class(%ResultSet).%New("web.DHCDocNurAddOrder:FindInstrLinkItems")
 	//do rset.Execute(EpisodeID,MasterOrderItemRowId)
 	//While (rset.Next()) {
 	s OrderName=""
 	s ARCIMRowid=""
 	s ItemOrderType=""
	i LabelDesc="红"  d
 	.s OrderName=""
 	.s ARCIMRowid="7735||1"
 	.s ItemOrderType="N"
 	e  i LabelDesc="黑"  d
 	.s OrderName=""
 	.s ARCIMRowid="7737||1"
 	.s ItemOrderType="N"
 	e  i LabelDesc="绿"  d
 	.s OrderName=""
 	.s ARCIMRowid="7736||1"
 	.s ItemOrderType="N"
 	e  i LabelDesc="蓝"  d
 	.s OrderName=""
 	.s ARCIMRowid="7739||1"
 	.s ItemOrderType="N"
 	e  i LabelDesc="紫"  d
 	.s OrderName=""
 	.s ARCIMRowid="7738||1"
 	.s ItemOrderType="N"
	i ARCIMRowid'=""  d
	.s LinkOrdersStr=OrderName_"^"_ARCIMRowid_"^"_ItemOrderType_"^"_"1"_"^"_ARCIMRowid2
	.//s retval=itmjs_"('"_$ZCVT($g(OrderName),"O","JS")_"','"_$ZCVT($g(ARCIMRowid),"O","JS")_"','"_$ZCVT($g(ItemOrderType),"O","JS")_"');"
	.s retval=itmjs_"('"_$ZCVT($g(LinkOrdersStr),"O","JS")_"');"
	.&javascript<#(retval)#>
 	q 0
}

// Creator:		qixin

// CreatDate:    2009.11.29

// Description:	根据已经录入的医嘱,查找该医嘱对应的医嘱项目,在DoctorSetup中设置的-----"附加医嘱项设置"

// Table:        ARC_ItmMast,OE_OrdItem

// Global:       ^DHCItmMastAdd

// Input:        EpisodeID:就诊ID,已录入的医嘱

// Output:       已录入医嘱的用法对应的医嘱

ClassMethod FindOrderLinkItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmVOrderItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOrderLinkItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, MasterOrderItemRowId As %String) As %Status
{
	// w ##class(web.DHCDocNurAddOrder).FindInstrLinkItemsExecute("","180241","180157||543")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
 
 	s OrderRowid=$p(MasterOrderItemRowId,"||",1)
 	s ChildSub=$p(MasterOrderItemRowId,"||",2)
	s OrderItmRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)		;OEORI_ARCIC_DR
 	
	s rowid=0  f  s rowid=$O(^DHCItmMastAdd(0,"ARCIM",OrderItmRowid,rowid)) q:rowid=""  d
	.s AppendItemRowid=$P($g(^DHCItmMastAdd(rowid)),"^",2)
	.s qty=$P($g(^DHCItmMastAdd(rowid)),"^",3)
	.i qty="" s qty=0 	
	.s AppendItemSubScript=$p(AppendItemRowid,"||",1)
	.s AppendItemSubVersion=$p(AppendItemRowid,"||",2)
	.s OrderName=$p($g(^ARCIM(AppendItemSubScript,AppendItemSubVersion,1)),"^",2)  
	.s Item=OrderName
	.s ItemRowid=AppendItemRowid
	.s ItemOrderType=$p($g(^ARC("IC",AppendItemRowid)),"^",7)
	.s ^qixin("ARCIM",MasterOrderItemRowId,rowid)=Item_"^"_ItemRowid_"^"_ItemOrderType_"^"_qty
	.s Data=$lb(Item,ItemRowid,ItemOrderType,qty)
	.Set ^CacheTemp(repid,ind)=Data
 	.Set ind=ind+1
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindOrderLinkItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrLinkItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindOrderLinkItems(EpisodeID As %String = "", MasterOrderItemRowId As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "Item:%String,ItemRowid:%String,ItemOrderType:%String,qty:%String")
{
}

ClassMethod GetOrderLinkOrdersBroker(itmjs As %Library.String = "", EpisodeID As %String, MasterOrderItemRowId As %String, ARCIMRowid3 As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetInstrLinkItemsNum("180241","180226||604")
 	s OrderName=""
 	Set rset=##class(%ResultSet).%New("web.DHCDocNurAddOrder:FindOrderLinkItems")
 	do rset.Execute(EpisodeID,MasterOrderItemRowId)
 	While (rset.Next()) {
 		s OrderName=rset.GetData(1)
 		s ARCIMRowid=rset.GetData(2)
 		s ItemOrderType=rset.GetData(3)
 		s qty=rset.GetData(4)
 		s LinkOrdersStr=OrderName_"^"_ARCIMRowid_"^"_ItemOrderType_"^"_qty_"^"_ARCIMRowid3
 		//s retval=itmjs_"('"_$ZCVT($g(OrderName),"O","JS")_"','"_$ZCVT($g(ARCIMRowid),"O","JS")_"','"_$ZCVT($g(ItemOrderType),"O","JS")_"');"
 		s retval=itmjs_"('"_$ZCVT($g(LinkOrdersStr),"O","JS")_"');"
		&javascript<#(retval)#>
 	}
 	d rset.Close()
 	q OrderName
}

ClassMethod GetCurrentDate(DateFormat As %String) As %String
{
	s Curr=$H
	s CurrDateNum=$P(Curr,",",1)
	;dd/mm/yyyy hh:mm
	s CurrDate=$ZD(CurrDateNum,DateFormat)
	Quit CurrDate_"^"_CurrDateNum
}

ClassMethod GetFreqDetail(OrderFreqRowid As %String) As %String
{
	// w ##class(web.DHCDocNurAddOrder).GetInstrLinkItemsNum("180241","180226||604")
	q:OrderFreqRowid="" ""
 	s factor=$p($g(^PHCFR(OrderFreqRowid)),"^",2)
 	s days=$p($g(^PHCFR(OrderFreqRowid)),"^",5)
 	s weekflag=$P($g(^PHCFR(+$g(OrderFreqRowid),"DHC")),"^",1)
	s disptimestr=""
	i weekflag=1 s disptimestr=..GetFreqDispTimeStr(+$g(rowid))
 	q factor_"^"_days_"^"_disptimestr_"^"
}

ClassMethod GetFreqDispTimeStr(PHCFRrow As %String) As %String
{
	s ret=""
	s childsub=0  f  s childsub=$O(^PHCFR(PHCFRrow,"OPDT",childsub)) Q:childsub=""  d
	.s time=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",1)
	.s timestr=..%ZT(time,3)
	.s week=$p(^PHCFR(PHCFRrow,"OPDT",childsub),"^",2)
	.s DispTime=time_$C(2)_week
	.i ret="" s ret=DispTime
	.e  s ret=ret_$C(1)_DispTime
	Q ret
}

/// 取用法绑定医嘱
/// w ##class(web.DHCDocNurAddOrder).GetInstrArcimStr(64,13)
ClassMethod GetInstrArcimStr(EpisodeID As %String, OrderInstrRowid As %String) As %String
{
	s InstrArcimStr=""
	s LogonDepDR=%session.Get("LOGON.CTLOCID")
	//s LogonDepDR=17
	s HospitalID=$P(^CTLOC(LogonDepDR),"^",22)
	Set CFUseHospSepInstrArcim=1 //$$getconfignode^DHCDocConfig("UseHospSepInstrArcim")
	if (CFUseHospSepInstrArcim=1) s OrderInstrStr=OrderInstrRowid_"||"_HospitalID
	e  s OrderInstrStr=OrderInstrRowid
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	
	/*i HospitalID=""  d
	.i (PAAdmType'="I")  d 
	..s OrderInstrStr=$o(^DHCDocConfig("InstrArcimSel",OrderInstrRowid_"||"))
	.e  d
	..s OrderInstrStr=$o(^DHCDocConfig("InstrIPArcimSel",OrderInstrRowid_"||"))
	e  d
	.s OrderInstrStr=OrderInstrRowid_"||"_HospitalID
	q:OrderInstrStr="" ""
	s AppOrderInstrRowid=$p(OrderInstrStr,"||")
	q:AppOrderInstrRowid'=OrderInstrRowid ""*/
	i (PAAdmType'="I")  d 
	.s InstrArcimStr=$g(^DHCDocConfig("InstrArcimSel",OrderInstrStr))
	e  d
	.s InstrArcimStr=$g(^DHCDocConfig("InstrIPArcimSel",OrderInstrStr))
	s InstrArcimStr=##Class(DHCDoc.DHCDocConfig.InstrArcim).CheckInstrAppendItemStr(InstrArcimStr,LogonDepDR,"NURADD")
	q InstrArcimStr
}

ClassMethod GetPrintFlag(OrderRowid, ChildSub) As %String
{
	s PrintFlag="N"
	s ExecSub=0
	f  s ExecSub=$o(^OEORD(OrderRowid,"I",ChildSub,"X",ExecSub)) q:(ExecSub="")||(PrintFlag="Y")  D
	.s PrintFlag=$p($g(^OEORD(OrderRowid,"I",ChildSub,"X",ExecSub,"NUR")),"^",1)
	q PrintFlag
}

}
