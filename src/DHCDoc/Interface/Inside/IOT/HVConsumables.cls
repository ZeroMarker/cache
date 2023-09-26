Class DHCDoc.Interface.Inside.IOT.HVConsumables Extends %RegisteredObject
{

/// 过滤不是高值耗材的医嘱,项目上自己完成
/// date:2019-09-09
/// desc:互联互通共享文档【2.22.1高值耗材使用记录表（DHCENSCDA.User.CDA.C0022Info）】
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.HVConsumables","GetC0022Info","2019-09-10","2019-09-10","")
ClassMethod GetC0022InfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Hospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	set qHandle = $lb(0,repid,0)
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	s (AdmID,DocumentID,HDSD0008052,HDSD0008036,HDSD0008033,HDSD00080331,HDSD0008093,HDSD0008073,HDSD0008008,HDSD0008009,HDSD0008010,HDSD0008011,HDSD0008023,HDSD0008057)=""
	for Date=StartDate:1:EndDate {
		s orderParref=""
		for {
			s orderParref=$O(^OEORDi(0,"StDt",Date,orderParref))
			q:orderParref=""
			s orderId = 0 
			for{
				s orderId = $O(^OEORDi(0,"StDt",Date,orderParref,orderId))
				q:orderId=""
				s OrdObj=##class(User.OEOrdItem).%OpenId(orderParref_"||"_orderId,0)
				s ARCIMRowId=OrdObj.OEORIItmMastDR.%Id()
				continue:ARCIMRowId="" 
				s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
				continue:ItemCatRowid=""
				s OrderType=""
				s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
				s OrdCat=$p(^ARC("IC",ItemCatRowid),"^",8)
				/*
				====过滤不是高值耗材的医嘱,项目上自己完成
				====可按大类(OrdCat)或子类(ItemCatRowid)过滤数据
				*/
				s AdmID=$P(^OEORD(orderParref),"^",1) ///就诊ID号	AdmID
				s DocumentID=orderParref_"||"_orderId  ///文档唯一编号	DocumentID
				s HDSD0005016=orderParref_"||"_orderId  ///医嘱号(电子申请单号)
				///签名日期时间	HDSD0006068
				s HDSD0008052=$Zd($P(OrdObj.OEORIDateTime,",",1))_" "  _$Zt($P(OrdObj.OEORIDateTime,",",2)) ///签名日期时间
				///记录日期时间	HDSD0008036
				s OEORIDateExecuted=OrdObj.OEORIDateExecuted
				s OEORITimeExecuted=OrdObj.OEORITimeExecuted
				if (OEORIDateExecuted'="")&&(OEORITimeExecuted'=""){
					s HDSD0008036 =$Zd(OEORIDateExecuted,3)_" "_$Zt(OEORITimeExecuted)   ///医嘱执行日期时间
				}
				s OEORIUserExecuted=OrdObj.OEORIUserExecuted
				if $ISOBJECT(OEORIUserExecuted){
					s OEORIUserExecuted=OrdObj.OEORIUserExecuted.%Id()
					s UserObj=##class(User.SSUser).%OpenId(OEORIUserExecuted,0)
					if $ISOBJECT(UserObj) {
						s HDSD0008033=UserObj.SSUSRInitials ///护士签名代码
						s HDSD00080331=UserObj.SSUSRName ///护士签名
					   do UserObj.%Close()
					}
				}
				
				s ExecDr=0
				for {
					s ExecDr=$O(^OEORD(orderParref,"I",orderId,"X",ExecDr))
					q:(ExecDr="")
					s ExStDate= $p(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",1)
					s ExStTime= $p(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",2)
					s ExecStateDR= $p(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",16)
					s execStatus=""
					i +ExecStateDR>0 s execStatus = $p(^OEC("STAT",ExecStateDR),"^",1)
					s CTPCPDR=$P(^OEORD(orderParref,"I",orderId,"X",ExecDr),"^",15)
					if (execStatus="F")&&(HDSD0008033="")&&(CTPCPDR'=""){
						s UserID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPDR,0))
						s HDSD0008033=$P(^SSU("SSUSR",UserID),"^",1) ///医嘱执行者代码
						s HDSD00080331=$P(^SSU("SSUSR",UserID),"^",2) ///医嘱执行者签名
					}
					if (execStatus="F")&&(HDSD0008036=""){
						s HDSD0008036=$Zd(ExStDate,3)_" "_$Zt(ExStTime)   ///医嘱执行日期时间
					}
				}
				
				
				s inci=$O(^INCI(0,"ARCIM_DR",$P(ARCIMRowId,"||",1),""))
				if (inci'=""){
					s add=$O(^DHCITMINFO(0,"INCI",inci,""))
					if (add'=""){
						s HDSD0008093=$P(^DHCITMINFO(add),"^",12)  ////植入性耗材标志
					}
					s HDSD0008008=$P(^INCI(inci,1),"^",1) //材料名称	
					s HDSD0008009=$P(^INCI(inci,1),"^",2)  //产品编码
					s Add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
					if (Add'=""){
						s VendorId=$p($G(^DHCITMINFO(Add)),"^",24)
						s:VendorId'="" HDSD0008010=$p(^APC("APCVM",VendorId),"^",3) ///产品供应商
						s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
						s:ManfId'="" HDSD0008011=$P(^PHMNF(ManfId),"^",2)  ///产品生产厂家
					}
					S buomdr=$P(^INCI(inci,1),"^",10)
					s:buomdr'="" HDSD0008023=$P(^CT("UOM",buomdr),"^",2)  ///材料单位
				}
				s HDSD0008073 =OrdObj.OEORIPhQtyOrd /// 数量	HDSD0008073
				////使用途径	HDSD0008057
				s OEORIInstrDR=OrdObj.OEORIInstrDR
				if $ISOBJECT(OEORIInstrDR){
					s OEORIInstrDR=OrdObj.OEORIInstrDR.%Id()
					s InstrObj=##class(User.PHCInstruc).%OpenId(OEORIInstrDR,0)
					if $ISOBJECT(InstrObj) {
					   s HDSD0008057=InstrObj.PHCINCode  //药物使用途径代码
					   do InstrObj.%Close()
					}
				}
				d OutputRow1
				}
			}
		}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(AdmID,DocumentID,HDSD0008052,HDSD0008036,HDSD0008033,HDSD00080331,HDSD0008093,HDSD0008073,HDSD0008008,HDSD0008009,HDSD0008010,HDSD0008011,HDSD0008023,HDSD0008057)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetC0022InfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetC0022InfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
       Set AtEnd=1
	   Set Row=""
    }Else{Set Row=^CacheTemp(repid,ind)}
    s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetC0022InfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetC0022InfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetC0022Info(StartDate As %String, EndDate As %String, Hospital As %String) As %Query(ROWSPEC = "AdmID,DocumentID,HDSD0008052,HDSD0008036,HDSD0008033,HDSD00080331,HDSD0008093,HDSD0008073,HDSD0008008,HDSD0008009,HDSD0008010,HDSD0008011,HDSD0008023,HDSD0008057")
{
}

}
