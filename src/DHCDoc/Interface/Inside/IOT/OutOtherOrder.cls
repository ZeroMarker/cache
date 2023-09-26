Class DHCDoc.Interface.Inside.IOT.OutOtherOrder Extends %RegisteredObject
{

/// date:2019-09-09
/// desc:互联互通共享文档【1.9.1门诊医嘱主信息表(DHCENSCDA.User.Order.OutOtherOrder)】
/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.OutOtherOrder","GetOutOtherOrder","2019-01-10","2019-09-10","")
ClassMethod GetOutOtherOrderExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, Hospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	set qHandle = $lb(0,repid,0)
	s StartDate=$ZDH(StartDate,3)
	s EndDate=$ZDH(EndDate,3)
	s (HDSD0003049,HDSD00030491,HDSD0003050,HDSD0003501,HDSD0003502,HDSD0003052,HDSD0003053,HDSD0003051,HDSD0003044,HDSD0003045,HDSD0003043,HDSD0003047,HDSD0003048,HDSD0003046,HDSD0003030,HDSD0003042,HDSD0003055,AdmID,OrderSn,HDSD0015004,HDSD0015022,HDSD00150221,HDSD00030531,HDSD00030451,HDSD00030431,HDSD00030511,HDSD00030481,HDSD00030301,HDSD00030551)=""
	for Date=StartDate:1:EndDate {
		s orderParref=""
		for {
			s orderParref=$O(^OEORDi(0,"StDt",Date,orderParref))
			q:orderParref=""
			s AdmID=$P(^OEORD(orderParref),"^",1)
			s PAADMType=$p($g(^PAADM(AdmID)),"^",2)
			continue:(PAADMType'="O")&&(PAADMType'="E")
			s orderId = 0 
			for{
				s orderId = $O(^OEORDi(0,"StDt",Date,orderParref,orderId))
				q:orderId=""
				s OEORIRowID=orderParref_"||"_orderId
				s OrdObj=##class(User.OEOrdItem).%OpenId(OEORIRowID,0)
				s ARCIMRowId=OrdObj.OEORIItmMastDR.%Id()
				continue:ARCIMRowId="" 
				s OEORIPriorityDR=OrdObj.OEORIPriorityDR.%Id()
				s OECPriorityObj=##class(User.OECPriority).%OpenId(OEORIPriorityDR,0)
				if $ISOBJECT(OECPriorityObj) {
				   s HDSD0003049=OECPriorityObj.OECPRDesc  ///医嘱项目类型
				   s HDSD00030491=OECPriorityObj.OECPRCode  ///医嘱项目类型代码
				   do OECPriorityObj.%Close()
				}
				s ArcItmObj=##class(User.ARCItmMast).%OpenId(ARCIMRowId,0)
				s HDSD0003050=ArcItmObj.ARCIMDesc  ///医嘱项目内容
				do ArcItmObj.%Close()
				s OEORISttDat=OrdObj.OEORISttDat
				s OEORISttTim=OrdObj.OEORISttTim
				s HDSD0003501=$Zd(OEORISttDat,3)_" "_$Zt(OEORISttTim) //医嘱计划开始日期时间
				///医嘱计划结束日期时间	HDSD0003502
				s OEORIDateExecuted=OrdObj.OEORIDateExecuted
				s OEORITimeExecuted=OrdObj.OEORITimeExecuted
				if (OEORIDateExecuted'="")&&(OEORITimeExecuted'=""){
					s HDSD0003052 =$Zd(OEORIDateExecuted,3)_" "_$Zt(OEORITimeExecuted)   ///医嘱执行日期时间
				}
				s OEORIUserExecuted=OrdObj.OEORIUserExecuted
				if $ISOBJECT(OEORIUserExecuted){
					s OEORIUserExecuted=OrdObj.OEORIUserExecuted.%Id()
					s UserObj=##class(User.SSUser).%OpenId(OEORIUserExecuted,0)
					if $ISOBJECT(UserObj) {
						s HDSD00030531=UserObj.SSUSRInitials ///医嘱执行者代码
						s HDSD0003053=UserObj.SSUSRName ///医嘱执行者签名
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
					if (execStatus="F")&&(HDSD00030531="")&&(CTPCPDR'=""){
						s UserID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPDR,0))
						s HDSD00030531=$P(^SSU("SSUSR",UserID),"^",1) ///医嘱执行者代码
						s HDSD0003053=$P(^SSU("SSUSR",UserID),"^",2) ///医嘱执行者签名
					}
					if (execStatus="F")&&(HDSD0003052=""){
						s HDSD0003052=$Zd(ExStDate,3)_" "_$Zt(ExStTime)   ///医嘱执行日期时间
					}
				}
				
				
				
				s OEORIRecDepDR=OrdObj.OEORIRecDepDR
				if $ISOBJECT(OEORIRecDepDR){
					s OEORIRecDepDR=OrdObj.OEORIRecDepDR.%Id()
					s LocObj=##class(User.CTLoc).%OpenId(OEORIRecDepDR,0)
					if $ISOBJECT(LocObj) {
					   s HDSD0003051=LocObj.CTLOCDesc ///医嘱执行科室
					   s HDSD00030511=LocObj.CTLOCCode ///医嘱执行科室代码
					   do LocObj.%Close()
					}
				}
				s HDSD0003044=$Zd($P(OrdObj.OEORIDateTime,",",1))_" "  _$Zt($P(OrdObj.OEORIDateTime,",",2)) ///医嘱开立日期时间
				s OEORIUserAdd=OrdObj.OEORIUserAdd  ///实习生 OEORIDoctorDR
				if $ISOBJECT(OEORIUserAdd){
					s OEORIUserAdd=OrdObj.OEORIUserAdd.%Id()
					s UserObj=##class(User.SSUser).%OpenId(OEORIUserAdd,0)
					if $ISOBJECT(UserObj) {
					   s HDSD00030451=UserObj.SSUSRInitials ///医嘱开立者代码
					   s HDSD0003045=UserObj.SSUSRName  ///医嘱开立者签名
					   do UserObj.%Close()
					}
				}
				s OEORIOrdDeptDR=OrdObj.OEORIOrdDeptDR
				if $ISOBJECT(OEORIOrdDeptDR) {
					s OEORIOrdDeptDR=OrdObj.OEORIOrdDeptDR.%Id()
					s LocObj=##class(User.CTLoc).%OpenId(OEORIOrdDeptDR,0)
					if $ISOBJECT(LocObj) {
						s HDSD00030431=LocObj.CTLOCCode ///医嘱开立科室代码
						s HDSD0003043=LocObj.CTLOCDesc ///医嘱开立科室
						do LocObj.%Close()
					}
				}
				s HDSD0003047=$Zd($P(OrdObj.OEORIDateTime,",",1))_" "  _$Zt($P(OrdObj.OEORIDateTime,",",2)) ///医嘱审核日期时间
				s OEORIDoctorDR=OrdObj.OEORIDoctorDR  ///
				if $ISOBJECT(OEORIDoctorDR){
					s OEORIDoctorDR=OrdObj.OEORIDoctorDR.%Id()
					s DocObj=##class(User.CTCareProv).%OpenId(OEORIDoctorDR,0)
					if $ISOBJECT(DocObj) {
					   s HDSD00030481=DocObj.CTPCPCode ///医嘱审核者代码
					   s HDSD0003048=DocObj.CTPCPDesc  ///医嘱审核者签名
					   do DocObj.%Close()
					}
				}
				s HDSD0003046="" ///
				if (OrdObj.OEORIXDate'=""){
					s HDSD0003046=$ZD(OrdObj.OEORIXDate,3) ///医嘱取消日期时间
				}
				s OEORIXCTCPDR=OrdObj.OEORIXCTCPDR
				if $ISOBJECT(OEORIXCTCPDR){
					s OEORIXCTCPDR=OrdObj.OEORIXCTCPDR.%Id()
					s DocObj=##class(User.CTCareProv).%OpenId(OEORIXCTCPDR,0)
					if $ISOBJECT(DocObj) {
					   s HDSD0003030=DocObj.CTPCPDesc ///医嘱取消者签名
					   s HDSD00030301=DocObj.CTPCPCode ///医嘱取消者代码
					   do DocObj.%Close()
					}
				}
				s OEORIDepProcNotes=OrdObj.OEORIDepProcNotes ///医嘱备注信息
				if $ISOBJECT(OEORIDepProcNotes){
					s HDSD0003042=OEORIDepProcNotes.GetAt(0)
				}
				s OEORIItemStatDR=OrdObj.OEORIItemStatDR.%Id()
				s OECStatusObj=##class(User.OECOrderStatus).%OpenId(OEORIItemStatDR,0)
				if $ISOBJECT(OECStatusObj) {
				   s HDSD0003055=OECStatusObj.OSTATDesc ///医嘱执行状态
				   s HDSD00030551 = OECStatusObj.OSTATCode  ///医嘱执行状态代码
				   do OECStatusObj.%Close()
				}
				s AdmID=$P(^OEORD(orderParref),"^",1) ///就诊ID号	AdmID
				s OrderSn=OEORIRowID ///医嘱号
				s HDSD0015004=OrdObj.OEORIPrescNo ///处方药品组号（医嘱序号）
				s OEORICategDR=OrdObj.OEORICategDR
				if $ISOBJECT(OEORICategDR){
					s OEORICategDR=OrdObj.OEORICategDR.%Id()
					s OECCateObj=##class(User.OECOrderCategory).%OpenId(OEORICategDR,0)
					if $ISOBJECT(OECCateObj) {
					   s HDSD0015022=OECCateObj.ORCATCode ///医嘱类别代码
					   s HDSD00150221=OECCateObj.ORCATDesc  ///医嘱类别描述
					   do OECCateObj.%Close()
					}
				}
				d OutputRow1
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(HDSD0003049,HDSD00030491,HDSD0003050,HDSD0003501,HDSD0003502,HDSD0003052,HDSD0003053,HDSD0003051,HDSD0003044,HDSD0003045,HDSD0003043,HDSD0003047,HDSD0003048,HDSD0003046,HDSD0003030,HDSD0003042,HDSD0003055,AdmID,OrderSn,HDSD0015004,HDSD0015022,HDSD00150221,HDSD00030531,HDSD00030451,HDSD00030431,HDSD00030511,HDSD00030481,HDSD00030301,HDSD00030551)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOutOtherOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutOtherOrderExecute ]
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

ClassMethod GetOutOtherOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutOtherOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetOutOtherOrder(StartDate As %String, EndDate As %String, Hospital As %String) As %Query(ROWSPEC = "HDSD0003049,HDSD00030491,HDSD0003050,HDSD0003501,HDSD0003502,HDSD0003052,HDSD0003053,HDSD0003051,HDSD0003044,HDSD0003045,HDSD0003043,HDSD0003047,HDSD0003048,HDSD0003046,HDSD0003030,HDSD0003042,HDSD0003055,AdmID,OrderSn,HDSD0015004,HDSD0015022,HDSD00150221,HDSD00030531,HDSD00030451,HDSD00030431,HDSD00030511,HDSD00030481,HDSD00030301,HDSD00030551")
{
}

}
