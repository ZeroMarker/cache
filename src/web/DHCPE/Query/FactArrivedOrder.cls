/// 权责报表数据---给袁旭传
/// ADM^医嘱项号^接收科室^总金额^医嘱数量^单价^医嘱类号^病人科室名称^病人医生号^下医嘱医生^帐单子类^帐单大类^帐单号^医嘱rowid^时间^结算时间^执行医生^下医嘱科室
/// 如果以上字段不能全部给我的话，前6项是要有的，其中医嘱项是必须的，通过医嘱项找帐单大类，账单子类,医嘱子类,在统计时即使医嘱为空也不影响我这，我通过帐单大类统计
/// Create by MLH 20080425
Class web.DHCPE.Query.FactArrivedOrder Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(web.DHCPE.Query.FactArrivedOrder).FactArrivedOrder("61121","61126")
ClassMethod FactArrivedOrder(StartDate, EndDate)
{
	If StartDate="" Set StartDate=+$h
	If EndDate="" Set EndDate=+$h
	
	//到达前加的医嘱，到达时自动加到his的医嘱
	K ^DHCPETempFactOrd
	Set i=0
	Set PIADMDate=StartDate-1
	For  Set PIADMDate=$O(^DHCPEDataEx("DHCPEPreIADM",0,"AdmDateTime",PIADMDate)) Quit:(PIADMDate="")||(PIADMDate>EndDate)  Do
	.w !,"PIADMDate"_PIADMDate
	.Set PIADMTime=0
	.For  Set PIADMTime=$O(^DHCPEDataEx("DHCPEPreIADM",0,"AdmDateTime",PIADMDate,PIADMTime)) Quit:PIADMTime=""  Do
	..;w !,"PIADMDate"_PIADMDate_","_PIADMTime
	..Set PIADMRowId=0
	..For  Set PIADMRowId=$O(^DHCPEDataEx("DHCPEPreIADM",0,"AdmDateTime",PIADMDate,PIADMTime,PIADMRowId))  Quit:PIADMRowId=""  Do
	...Set PIADMStatus=$P(^DHCPEPreIADM(PIADMRowId),"^",8)
	...Quit:(PIADMStatus'="ARRIVED")&&(PIADMStatus'="CANCELARRIVED")
	...Set PIOIChd=0
	...For  Set PIOIChd=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChd)) Quit:(PIOIChd="")  Do
	....Set PIOIStatus=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChd)),"^",16)
	....Quit:PIOIStatus'="1"
	....Set PIOIDate=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChd),"^",12)
	....If PIOIDate<=PIADMDate Do SetGlobal(PIADMRowId,PIOIChd,"Insert")

	//到达后加的医嘱
	Set PIOIDate=StartDate-1
	For  Set PIOIDate=$o(^DHCPEPreIADM(0,"UpdateDateTime",PIOIDate)) Quit:(PIOIDate="")||(PIOIDate>EndDate)  Do
	.Set PIOITime=0
	.For  Set PIOITime=$o(^DHCPEPreIADM(0,"UpdateDateTime",PIOIDate,PIOITime)) Quit:PIOITime=""  Do
	..Set PIADMRowId=0
	..For  Set PIADMRowId=$o(^DHCPEPreIADM(0,"UpdateDateTime",PIOIDate,PIOITime,PIADMRowId)) Quit:PIADMRowId=""  Do
	...Set PIOIChd=0
	...For  Set PIOIChd=$o(^DHCPEPreIADM(0,"UpdateDateTime",PIOIDate,PIOITime,PIADMRowId,PIOIChd)) Quit:PIOIChd=""  Do
	....Set PIOIStatus=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChd)),"^",16)
	....Quit:PIOIStatus'="1"
	....Set IsAdd=0
	....Do OrderIsAdd(PIADMRowId,PIOIDate)
	....If IsAdd=1 Do SetGlobal(PIADMRowId,PIOIChd,"Insert")

	//到达后删除的医嘱
	Set XDate=StartDate-1
	For  Set XDate=$o(^DHCPEDataEx("DHCPEPreIOrdItem",0,"XDateTime",XDate)) Quit:(XDate="")||(XDate>EndDate)  Do
	.q:XDate=""
	.Set XTime=0
	.For  Set XTime=$o(^DHCPEDataEx("DHCPEPreIOrdItem",0,"XDateTime",XDate,XTime)) Quit:$g(XTime)=""  Do
	..q:(XTime="")||(XDate="")
	..Set PIOIRowId=0
	..//b  ///1111
	..//w !,XDate_","_XTime1
	..For  Set PIOIRowId=$o(^DHCPEDataEx("DHCPEPreIOrdItem",0,"XDateTime",XDate,XTime,PIOIRowId)) Quit:$g(PIOIRowId)=""  Do
	...Set IsDel=0
	...Do OrderIsDel(PIOIRowId,XDate)
	...If IsDel=1 Do SetGlobal($p(PIOIRowId,"||",1),$p(PIOIRowId,"||",2),"Delete")
	
OrderIsAdd(piadm,pioidate)
	Quit:($g(piadm)="")||($g(ordchd)="")
	Set piadmdate=$p($g(^DHCPEDataEx("DHCPEPreIADM","AdmDate","AdmTime",piadm)),"^",1)
	If pioidate>piadmdate Set IsAdd=1

OrderIsDel(pioi,xdate)
	Quit:$g(pioi)=""
	Set piadm=$p(pioi,"||",1)
	Quit:($g(piadm)="")||(piadm=0)
	Quit:'$d(^DHCPEPreIADM(piadm))     //yx
	Set piadmstatus=$P(^DHCPEPreIADM(piadm),"^",8)
	If (piadmstatus="ARRIVED")||(piadmstatus="CANCELARRIVED") Do
	.Set piadmdate=$p($g(^DHCPEDataEx("DHCPEPreIADM","AdmDate","AdmTime",piadm)),"^",1)
	.Set oeori=$o(^DHCPECRMO(0,"CRMORI",pioi,0))
	.If (xdate>piadmdate)&(oeori'="") Set IsDel=1

SetGlobal(piadm,ordchd,type)
	Set iadmr=$O(^DHCPEIADM(0,"CRMADM",piadm,0))
	Quit:$g(iadmr)=""
	Set PAADM=$p($g(^DHCPEIADM(iadmr)),"^",1)
	Set CRMOrder=$o(^DHCPECRMO(0,"CRMORI",piadm_"||"_ordchd,0))
	Quit:$g(CRMOrder)=""
	Set OEORI=$p($g(^DHCPECRMO(CRMOrder)),"^",1)
	Set RecLoc=$p(^DHCPEPreIADM(piadm,"ORDITEM",ordchd),"^",17)
	Set FactAmount=##class(web.DHCPE.OrdSetsPrice).PEOrdPrice("",piadm_"||"_ordchd)
	Set AccountAmount=$p(^DHCPEPreIADM(piadm,"ORDITEM",ordchd),"^",14)
	Set ^DHCPETempFactOrd(piadm_"||"_ordchd,type)=PAADM_"^"_OEORI_"^"_RecLoc_"^"_FactAmount_"^1^"_AccountAmount
	//Set i=1+i
	//For  Set=^OEORDi(0,"StDt",{OEORI_SttDat},{OE_Order.OEORD_RowId},{OEORI_Childsub})
}

/// d ##class(web.DHCPE.Query.FactArrivedOrder).SetAdmGlobal()
ClassMethod SetAdmGlobal()
{
	k ^DHCPEDataEx("DHCPEPreIADM","AdmDate","AdmTime")
	k ^DHCPEDataEx("DHCPEPreIADM",0,"AdmDateTime")
	Set IADMRowId=0
	For  Set IADMRowId=$o(^DHCPEIADM(IADMRowId))  Quit:(IADMRowId="")  Do
	.//Set IADMStatus=$p(^DHCPEIADM(IADMRowId),"^",8)
	.Set PIADMRowID=$p(^DHCPEIADM(IADMRowId),"^",4)
	.Set PIADMStatus=$p($g(^DHCPEPreIADM(PIADMRowID)),"^",8)
	.Quit:(PIADMStatus'="ARRIVED")&(PIADMStatus'="CANCELARRIVED")
	.Set IADMDate=$p(^DHCPEPreIADM(PIADMRowID),"^",22)
	.Set IADMTime=$p(^DHCPEPreIADM(PIADMRowID),"^",23)
	.Set ^DHCPEDataEx("DHCPEPreIADM","AdmDate","AdmTime",PIADMRowID)=IADMDate_"^"_IADMTime
	.Set ^DHCPEDataEx("DHCPEPreIADM",0,"AdmDateTime",IADMDate,IADMTime,PIADMRowID)=""
}

}
