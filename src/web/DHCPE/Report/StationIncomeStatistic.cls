Import SQLUser

/// 创建时间		：2008.01.07
/// 创建人			：xuwm
/// 存在系统		：体检系统
/// 关联数据		: 
/// 索引			：
/// 主要功能		: 科室收入统计
/// 主要功能		：(复兴医院需求)
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.Report.StationIncomeStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.StationIncomeStatistic","StationIncomeStatistic","","",60871,63938,31)
Query StationIncomeStatistic(LocDR As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "") As %Query(ROWSPEC = "SIS_SendLoc:%String, SIS_RectLoc:%String, SIS_OEItem:%String, SIS_Price:%String, SIS_Count:%String, SIS_AccountAmountTotal:%String, SIS_FactAmountTotal:%String")
{
}

ClassMethod StationIncomeStatisticExecute(ByRef qHandle As %Binary, LocDR As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "") As %Status
{
 	s ind=1
 	s id=0	
 	s CurUserID=%session.Get("LOGON.USERID") 
	Set repid=$I(^CacheTemp)
	k ^DHCPETMP("SIS")
	k ^DHCPETMP("StationIncomeStatistic","InfoExport","List",CurUserID)
	s ^DHCPETMP("SIS", "StationIncomeStatistic")=""""_LocDR_""","""_OEItemDR_""","""_DateBegin_""","""_DateEnd_""","""_GroupDR_""""
 	
 	if ((""=LocDR) && (""=OEItemDR) && (""=DateBegin) && (""=DateEnd) && (""=GroupDR)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
 	i DateEnd'=""   s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
 	
	s PhyExamLocId=%session.Get("LOGON.CTLOCID")
	s PhyExamLoc=$P($G(^CTLOC(PhyExamLocId)),"^",2)
	s StationIdOther=$G(^DHCPESetting("DHCPE","StationId_Other"))
	
	// 按团体查询
	
 	//i (""=DateBegin)&&(""=DateEnd)&&((""'=GroupDR)) d
 	i (""'=GroupDR) d
 
 	.// DHC_PE_GADM.{ GADM_RowId } = DHC_PE_IADM.{ IADM_GADM_DR }
 	.s GADMRowId=0
 	.f  s GADMRowId=$O(^DHCPEGADM(0,"GBI", GroupDR, GADMRowId)) q:(""=GADMRowId)  d
 	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",$P(^DHCPEGADM(GADMRowId),"^",2))          //add 2009-07-07 
  	..q:LocFlag=1
	..s GTeamDR=0
	..f  s GTeamDR=$O(^DHCPEIADM(0,"GADM", GADMRowId, GTeamDR)) q:(""=GTeamDR)  d
	...// DHC_PE_IADM.{ IADM_RowId}
	...s IAdmRowId=0
	...f  s IAdmRowId=$O(^DHCPEIADM(0,"GADM", GADMRowId, GTeamDR, IAdmRowId)) q:(""=IAdmRowId)  d
	....
	....// DHC_PE_IADM.{ IADM_Status }
	....s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	....Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	....
	....// DHC_PE_IADM.{ IADM_PAADM_DR }
	....s PAADMDR=$P($g(^DHCPEIADM(IAdmRowId)), "^", 1)
	....
	....// DHC_PE_IADM.{ IADM_CRMADM }
	....//s PIADMRowId=$P(Curdata,"^",4)
	....
	....//s ^DHCPETMPDWA("IADM", IAdmRowId)=IAdmRowId
	....s ^DHCPETMP("SIS", "ADM", PAADMDR)=IAdmRowId
	....//w PAADMDR,!
	.
	
	// 按到达(登记)日期查询
	i (""=GroupDR)&&((""'=DateBegin)||(""'=DateEnd)) d
	.s AdmDate=0
	.s:(""'=DateBegin) AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",DateBegin), -1)
	.f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(""=AdmDate)||((""'=DateEnd)&&(AdmDate>DateEnd))  d
	..s Time=0
	..f  s Time=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, Time)) q:(""=Time)  d
	...s IADMRowId=0
	...f  s IADMRowId=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADMRowId)) q:(""=IADMRowId)  d
	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMRowId)          //add 2009-07-07 
 	....q:LocFlag=1
	....s Curdata=$G(^DHCPEIADM(IADMRowId))
	....
	....// DHC_PE_IADM.{ IADM_Status }
	....s IADMStatus=$p(Curdata,"^",8)
	....Q:'((IADMStatus="COMPLETED")||(IADMStatus="ARRIVED"))
	....
	....// DHC_PE_IADM.{ IADM_CRMADM }
	....//s PIADMRowId=$P(Curdata,"^",4)
	....
	....// DHC_PE_IADM.{ IADM_PAADM_DR }
	....s PAADMDR=$p(Curdata,"^",1)
	....Q:(""=PAADMDR) // 过滤非法数据
	....s ^DHCPETMP("SIS", "ADM", PAADMDR)=IADMRowId
	
	s PAADM="",FactAmount=0
	f  s PAADM=$O(^DHCPETMP("SIS", "ADM", PAADM)) Q:(PAADM="")  d
	.//w !,"PAADM:"_PAADM
	.// OE_Order.{ OEORD_RowId }
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId)) q:OEORDRowId=""  d
	..//w !,"   OEORDRowId:"_OEORDRowId
	..// OE_OrdItem.{ OEORI_Childsub }
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:OEORIChildsub=""  d
	...//w !,"    OEORIChildsub:"_OEORIChildsub
	...// 过滤非医嘱站点
	...//s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	...//Q:(""'=StationIdOther)&&(STRowId=StationIdOther)
	...
	...//  OEC_OrderStatus.{ }
	...s OEORIItemStatDR=+$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...Q:(6'=OEORIItemStatDR) //6	E	执行	N
	...
	...// OEORI_ItmMast_DR
	...s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	...Q:(""'=OEItemDR)&(OEItemDR'=ItmMastDR)
	...
	...// OEORI_RecDep_DR
	...s RecDepDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	...Q:(""'=LocDR)&(LocDR'=RecDepDR)
	...//w "   StatDR:"_OEORIItemStatDR_" ItmMastDR:"_ItmMastDR_"  RecDepDR:"_RecDepDR
	...
	...// DHC_PE_CRMOrder.{ CRMO_RowId }
	...s CRMORowId=$O(^DHCPECRMO(0,"OEORI", OEORDRowId_"||"_OEORIChildsub, 0))
	...Q:(""=CRMORowId) //
	...// DHC_PE_CRMOrder.{ CRMO_CRMORI } => DHC_PE_PreIOrdItem
	...s CRMOCRMORI=$P(^DHCPECRMO(CRMORowId), "^", 2)
	...// DHC_PE_PreIADM.{ PIADM_RowId }
	...s PIADMRowId=$P(CRMOCRMORI, "||", 1)
	...// DHC_PE_PreIOrdItem.{ PIOI_ChildSub }
	...s PIOIChildSub=$P(CRMOCRMORI, "||", 2)
	...//  DHC_PE_PreIOrdItem.{ PIOI_OrdEnt_DR }
	...s OrdEntDR=$P($G(^DHCPEPreIADM(PIADMRowId, "ORDITEM", PIOIChildSub)), "^", 2)
	...
	...i ""'=OrdEntDR d
	....// DHC_PE_PreIOrdEnt.{ PIOE_ChildSub }
	....//^DHCPEPreIADM({DHC_PE_PreIADM.PIADM_RowId},"ORDENT", )
	....s ^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "OrdEnt")=FactAmount+$G(^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "FactAmount"))
	...
	...i ""=OrdEntDR d
	....//w !,"ItmMastDR:"_ItmMastDR_"   CRMOCRMORI: "_CRMOCRMORI
	....// OE_OrdEnt
	....s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMOCRMORI, "", "")
	....s ^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "FactAmount")=FactAmount+$G(^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "FactAmount"))
	...
	...s ^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "List", PAADM)=FactAmount
	...s ^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "Count")=1+$G(^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "Count"))
	...
	
	s CountTotal=0,AccountTotal=0,FactTotal=0
	s RecDepDR=0
	f  s RecDepDR=$O(^DHCPETMP("SIS", "RecDep", RecDepDR)) q:RecDepDR=""  d
	.//  CT_Loc.{ CTLOC_Desc }
	.s CTLOCDesc=$P($G(^CTLOC(RecDepDR)),"^",2)
	.//s ^DHCPETMP("SIS", "RecDep", RecDepDR)=CTLOCDesc
	.//w !, "RecDepDR:"_RecDepDR
	.s ItmMastDR=0
	.f  s ItmMastDR=$O(^DHCPETMP("SIS","RecDep", RecDepDR, "ItmMast", ItmMastDR)) q:ItmMastDR=""  d
	..//w !,"  ItmMastDR:"_ItmMastDR
	..// ARC_ItmMast.{ ARCIM_Desc }
	..s ARCIMSubscript=$P(ItmMastDR,"||",1)
	..s ARCIMVersion=$P(ItmMastDR,"||",2)
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	..
	..s Price=##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR,PIADMRowId)
	..s Count=^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "Count")
	..s AccountAmountTotal=Price*Count
	..s FactAmountTotal=$G(^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "FactAmount"))
	..S CountTotal=CountTotal+Count
	..s AccountTotal=AccountTotal+AccountAmountTotal
	..s FactTotal=FactTotal+FactAmountTotal
	..s Data=$LB(PhyExamLoc, CTLOCDesc, ARCIMDesc, Price, Count, AccountAmountTotal, FactAmountTotal)
    ..d StationWorkStatisticOut
	..
	..s ^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR)=ARCIMDesc
	..s ^DHCPETMP("SIS", "RecDep", RecDepDR, "ItmMast", ItmMastDR, "Price")=Price

	s PhyExamLoc="合计"
    s CTLOCDesc="", ARCIMDesc="", Price=""
    s Count=CountTotal
    s AccountAmountTotal=AccountTotal
    s FactAmountTotal=FactTotal
    s Data=$LB(PhyExamLoc, CTLOCDesc, ARCIMDesc, Price, Count, AccountAmountTotal, FactAmountTotal) 
    d StationWorkStatisticOut   
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
StationWorkStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
 	s ^DHCPETMP("StationIncomeStatistic","InfoExport","List",CurUserID,ind)=PhyExamLoc_"^"_CTLOCDesc_"^"_ARCIMDesc_"^"_Price_"^"_$G(Count)_"^"_AccountAmountTotal_"^"_FactAmountTotal
 	Set ind=ind+1
 	q
}

ClassMethod StationIncomeStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StationIncomeStatisticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StationIncomeStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StationIncomeStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query LocFactIncome(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "TLocName:%String,TAmount:%String")
{
}

ClassMethod LocFactIncomeExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	s ind=1
 	s id=0	
 	Set repid=$I(^CacheTemp)
 	s Job=$J
 	k ^TEMPDHCPELocFactIncome
 	if (BeginDate="")&&(EndDate="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i BeginDate="" s BeginDate=1
 	i EndDate="" s EndDate=+$H
 	//计算收款
 	s Date=BeginDate-1
 	f  s Date=$o(^DHCPEUSERREPORT(0,"DATE",Date)) q:(Date="")||(Date>EndDate)  d
 	.s rid=0
 	.f  s rid=$o(^DHCPEUSERREPORT(0,"DATE",Date,rid)) q:(rid="")  d
 	..s invid=0
 	..f  s invid=$o(^DHCPEINVPRT(0,"REPORT",rid,invid)) q:invid=""  d
 	...s PRTINVNO=$p(^DHCPEINVPRT(invid),"^",1)
 	...i PRTINVNO="" d
 	....s Flag=-1
 	....s CurInvID=$p(^DHCPEINVPRT(invid),"^",9)
 	...e  d
 	....s CurInvID=invid
 	....s Flag=1
 	...s pbid=$p(^DHCPEINVPRT(CurInvID),"^",3)
 	...s papbid=$o(^DHCPEPAPBR(0,"PBDR",pbid,0))
 	...q:papbid=""
 	...s auditid=$p(^DHCPEPAPBR(papbid),"^",1)
 	...s PreIADM=0
 	...f  s PreIADM=$O(^DHCPEPreIADM(0,"PAORDITEM",auditid,PreIADM)) q:PreIADM=""  d
 	....s ItemSub=0
 	....f  s ItemSub=$O(^DHCPEPreIADM(0,"PAORDITEM",auditid,PreIADM,ItemSub)) q:ItemSub=""  d
 	.....s RecLoc=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",17)
 	.....i RecLoc="" s RecLoc=0
 	.....s FeeSub=0
 	.....f  s FeeSub=$O(^DHCPEPreIADM(0,"PAORDITEM",auditid,PreIADM,ItemSub,FeeSub)) q:FeeSub=""  d
 	......s FactAmount=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub),"^",2)
 	......s ^TEMPDHCPELocFactIncome(Job,RecLoc)=+$G(^TEMPDHCPELocFactIncome(Job,RecLoc))+(+FactAmount)*Flag
 	s TotalAmout=0
 	s RecLoc=""
 	f  s RecLoc=$O(^TEMPDHCPELocFactIncome(Job,RecLoc)) q:RecLoc=""  d
 	.i RecLoc=0 d
 	..s RecLocDesc="无接受科室"
 	.e  d
 	..s RecLocDesc=$P(^CTLOC(RecLoc),"^",2)
 	..s Amount=$G(^TEMPDHCPELocFactIncome(Job,RecLoc))
 	..s TotalAmout=TotalAmout+Amount
 	..d LocFactIncomeOut
 	s RecLocDesc="合计"
 	s Amount=TotalAmout
 	d LocFactIncomeOut
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
LocFactIncomeOut
    s Data=$LB(RecLocDesc,Amount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LocFactIncomeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocFactIncomeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LocFactIncomeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocFactIncomeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetStationIncomeStatisticRows(User)
{
	q $o(^DHCPETMP("StationIncomeStatistic","InfoExport","List",User,""),-1)
}

ClassMethod GetStationIncomeStatisticRowsInfo(User, num)
{
	q:'$d(^DHCPETMP("StationIncomeStatistic","InfoExport","List",User,num)) ""
	q $g(^DHCPETMP("StationIncomeStatistic","InfoExport","List",User,num))
}

}
