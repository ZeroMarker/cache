Import SQLUser

/// 项目明细
/// 
Class web.DHCPE.Report.OEItemStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 148;

/*Query OEItemStatusQuery(RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", GTAdmListDR As %Library.String = "", OEItemDR As %Library.String = "", OEOrderStatus As %Library.String = "", OEItemStatus As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Query(ROWSPEC = "OSQ_IADM:%String, OSQ_Name:%String, OSQ_BookDateBegin:%String, OSQ_BookDateEnd:%String, OSQ_OEItemDR:%String, OSQ_OEItemDesc:%String, OSQ_OEItemStatus:%String, OSQ_OrderStatus:%String")
{
}

ClassMethod OEItemStatusQueryExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", GTAdmListDR As %Library.String = "", OEItemDR As %Library.String = "", OEOrderStatus As %Library.String = "", OEItemStatus As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Status
{

 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
 	if ((""=RegNo) && (""=Name) && (""=GAdmListDR) && (""=GTAdmListDR)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	k ^DHCPETMPOSQ
 	s ^DHCPETMPOSQ("OEItemStatusQuery")=""""_RegNo_""", """_Name_""", """_GAdmListDR_""", """_GTAdmListDR_""", """_OEItemDR_""", """_OEOrderStatus_""", """_OEItemStatus_""", """_DateBegin_""", """_DateEnd_""""
	
 	// 按登记号
 	i (""'=RegNo)&(""=GAdmListDR)&(""=GAdmListDR) d
 	.
 	.// 格式化登记号
 	.s:(""'=RegNo) RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
 	.
 	.// DHC_PE_PreIBaseInfo.{ PIBI_RowId }
 	.s PIBIRowId=0
 	.f  s PIBIRowId=$O(^DHCPEPreIBI(0, "PAPMINo", RegNo,PIBIRowId)) q:PIBIRowId=""  d
 	..
	..// DHC_PE_PreIADM.{ PIADM_RowId }
	..s PIADMRowId=0
	..f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PIBI", PIBIRowId,PIADMRowId)) q:PIADMRowId=""  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADMRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...
	...//  PIADM_Status
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("ARRIVED"'=PIADMStatus)
	...
	...// PIADM_PEDateBegin	预约体检日期 4
	...s PIADMPEDateBegin=$p(CurData,"^",4)
	...Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	...i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	...
	...// PIADM_PEDateEnd	预约体检日期 5
	...s PIADMPEDateEnd=$p(CurData,"^",5)
	...Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	...i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	...
	...//PIBI_Name	姓名 1.2
	...s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",2)
	...
	...s ^DHCPETMPOSQ("IADM", PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	..
	.
	
	// 按姓名
	i (""'=Name)&(""=GAdmListDR)&(""=GAdmListDR) d
	.s PIBIRowId=0
	.f  s PIBIRowId=$O(^DHCPEPreIBI(PIBIRowId)) q:PIBIRowId=""  d
	..
	..s CurData=$g(^DHCPEPreIBI(PIBIRowId))  
	..
	..
	..// DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名 
	..S PIBIName=$p(CurData,"^",2)
	..q:(""'=Name)&(PIBIName'[Name)
	..
	..// DHC_PE_PreIADM.{ PIADM_RowId }
	..s PIADMRowId=0
	..f  s PIADMRowId=$O(^DHCPEPreIADM(0,"PIBI",PIBIRowId,PIADMRowId)) q:PIADMRowId=""  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADMRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...
	...//  PIADM_Status
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("ARRIVED"'=PIADMStatus)
	...
	...// PIADM_PEDateBegin	预约体检日期 4
	...s PIADMPEDateBegin=$p(CurData,"^",4)
	...Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	...i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	...
	...// PIADM_PEDateEnd	预约体检日期 5
	...s PIADMPEDateEnd=$p(CurData,"^",5)
	...Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	...i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	...
	...s ^DHCPETMPOSQ("IADM",PIADMRowId)=PIBIName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	...
	...
	...
	...
	
	// 按团体 
	i (""'=GAdmListDR)&(""=GTAdmListDR) d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",GAdmListDR)          //add 2009-07-07 
  	.q:LocFlag=1
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGADM", GAdmListDR, PIADMRowId)) q:PIADMRowId=""  d
	..
	..s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	..
	..// PIADM_Status
	..s PIADMStatus=$p(CurData,"^",8)
	..Q:("ARRIVED"'=PIADMStatus)
	..
	..// PIADM_PIBI_DR
	..s PIBIDR=$p(CurData, "^", 1)
	..// DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名
	..s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)), "^", 2)
	..q:(""'=Name)&(PIBIDRName'[Name)
	..
	..
	..// PIADM_PEDateBegin	预约体检日期 4
	..s PIADMPEDateBegin=$p(CurData, "^", 4)
	..Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	..i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	..
	..// PIADM_PEDateEnd	预约体检日期 5
	..s PIADMPEDateEnd=$p(CurData,"^",5)
	..Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	..i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	..
	..
	..s ^DHCPETMPOSQ("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	..
	..
	
	// 按团体组
	i (""'=GTAdmListDR)&(""'=GAdmListDR) d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",+GAdmListDR)          //add 2009-07-07 
  	.q:LocFlag=1
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGTeam", GTAdmListDR, PIADMRowId)) q:PIADMRowId=""  d
	..s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	..
	..//  PIADM_Status
	..s PIADMStatus=$p(CurData,"^",8)
	..Q:("ARRIVED"'=PIADMStatus)
	..
	..// PIADM_PIBI_DR
	..s PIBIDR=$p(CurData,"^",1)
	..//DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名
	..s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
	..q:(""'=Name)&(PIBIDRName'[Name)
	..
	..// PIADM_PEDateBegin	预约体检日期 4
	..s PIADMPEDateBegin=$p(CurData,"^",4)
	..Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	..i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	..
	..// PIADM_PEDateEnd	预约体检日期 5
	..s PIADMPEDateEnd=$p(CurData,"^",5)
	..Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	..i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	..
	..
	..s ^DHCPETMPOSQ("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	..
	..
 	//	///////////////////////		统计		/////////////////////////////////// 	
	s PIADMRowId="0"
	f  s PIADMRowId=$O(^DHCPETMPOSQ("IADM",PIADMRowId)) q:PIADMRowId=""  d
	.//  DHC_PE_PreIOrdItem.{ PIOI_RowId }
	.s PIOIRowId=0
	.f  s PIOIRowId=$O(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIRowId)) q:PIOIRowId=""  d
	..s OSTATDesc=""
	..// DHC_PE_CRMOrder.{ CRMO_RowId }
	..s CRMORowId=$O(^DHCPECRMO(0,"CRMORI",PIADMRowId_"||"_PIOIRowId, 0))
	..
	..s Flag=1
	..// 查询项目遗嘱的执行状态
	..i ""'=CRMORowId d
	...// DHC_PE_CRMOrder.{ CRMO_OEORI_DR } =  OE_OrdItem
	...s OEORIDR=$P($G(^DHCPECRMO(CRMORowId)), "^", 1)
	...//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	...s OEORIItemStatDR=$p($G(^OEORD($P(OEORIDR,"||",1),"I",$P(OEORIDR,"||",2),1)),"^",13)
	...// OEC_OrderStatus.{OSTAT_Code}
	...s OSTATCode=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	...s:(""'=OEOrderStatus)&(OEOrderStatus'[("^"_OSTATCode_"^")) Flag=0
	...// OEC_OrderStatus.{OSTAT_Desc}
	...s OSTATDesc=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
	..Q:(0=Flag)
	..
	..//w PIOIRowId,!
	..s CurData=$G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIRowId))
	..
	..// DHC_PE_PreIOrdItem.{ PIOI_ItemStat }
	..s PIOIStatus=$P(CurData,"^",16)
	..//w !,"ID:"_PIOIRowId_"   Status:"_PIOIStatus_" OEItemStatus:"_OEItemStatus
	..Q:(""'=OEItemStatus)&(OEItemStatus[("^DEL^"))&(6'=+PIOIStatus)
	..
	..// DHC_PE_PreIOrdItem.{ PIOI_Type }
	..s PIOIType=$P(CurData,"^",15)
	..Q:(""'=OEItemStatus)&(OEItemStatus'[("^"_PIOIType_"^"))
	..
	..s Status=""
	..i ("PRE"=PIOIType) s Status="预约"
	..i ("ADD"=PIOIType) s Status="加项"
	..i (6=+PIOIStatus) s Status="删除"
	..
	..
	..s PatName=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",1)
	..s ADMPEDateBegin=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",2)
	..s ADMPEDateEnd=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",3)
	..// DHC_PE_PreIOrdItem.{ PIOI_ItmMast_DR }
	..s ARCIMDR=$P(CurData,"^",1)
	..Q:(""'=OEItemDR)&(OEItemDR'=ARCIMDR)  //按项目查询
	..
	..// 过滤非医嘱站点
	..s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	..Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))
	..
	..
	..
	..
	..s ARCIMDesc=$p(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1),"^",2)
	..s Data=$LB(PIADMRowId, PatName, ADMPEDateBegin,ADMPEDateEnd,ARCIMDR,ARCIMDesc,Status,OSTATDesc)
    ..d OEItemStatusQueryOut

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OEItemStatusQueryOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}*/
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.OEItemStatus","OEItemStatusQuery", "", "", "10", "", "", "^PRE^^DEL^", "", "")
Query OEItemStatusQuery(RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", GTAdmListDR As %Library.String = "", OEItemDR As %Library.String = "", OEOrderStatus As %Library.String = "", OEItemStatus As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Query(ROWSPEC = "OSQ_IADM:%String, OSQ_Name:%String, OSQ_BookDateBegin:%String, OSQ_BookDateEnd:%String, OSQ_OEItemDR:%String, OSQ_OEItemDesc:%String, OSQ_OEItemStatus:%String, OSQ_OrderStatus:%String,OSQ_GName:%String,OSQ_RegNo:%String,TARCIMPrice:%String,TFactPrice:%String,TDiscountRelate:%String")
{
}

ClassMethod OEItemStatusQueryExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", GTAdmListDR As %Library.String = "", OEItemDR As %Library.String = "", OEOrderStatus As %Library.String = "", OEItemStatus As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Status
{

 	s ind=1
 	s id=0 
	Set repid=$I(^CacheTemp)
	
 	if ((""=RegNo) && (""=Name) && (""=GAdmListDR) && (""=GTAdmListDR)&&(""=DateEnd)&&(""=DateBegin)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s User=%session.Get("LOGON.USERID")
 	k ^DHCPETMPItemStatus(User,"ItemStatus")

 	k ^DHCPETMPOSQ
 	s ^DHCPETMPOSQ("OEItemStatusQuery")=""""_RegNo_""", """_Name_""", """_GAdmListDR_""", """_GTAdmListDR_""", """_OEItemDR_""", """_OEOrderStatus_""", """_OEItemStatus_""", """_DateBegin_""", """_DateEnd_""""
	
	i (""'=RegNo) s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	
	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin) 
	i DateEnd'="" s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd) 
	
	
	i DateEnd="" s DateEnd=+$H
	i DateBegin="" s DateBegin=0
 	
 	// 按登记号
 	i (""'=RegNo)&(""=GAdmListDR)&(""=GAdmListDR) d
 	.s:(""'=RegNo) RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
 	.s PIBIRowId=0
 	.f  s PIBIRowId=$O(^DHCPEPreIBI(0, "PAPMINo", RegNo,PIBIRowId)) q:PIBIRowId=""  d
	..s PIADMRowId=0
	..f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PIBI", PIBIRowId,PIADMRowId)) q:PIADMRowId=""  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADMRowId) //add 2009-07-07 
  	...q:LocFlag=1
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("ARRIVED"'=PIADMStatus)
	...S PGADMDR=$p(CurData,"^",2)
	...S GDesc="",PGADMDR="",PGBIDR=""
	...i PGADMDR'="" s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1) 
	...I PGBIDR'="" S GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2)
	...s PIADMPEDateBegin=$p(CurData,"^",4)
	...Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	...i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	...s PIADMPEDateEnd=$p(CurData,"^",5)
	...Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	...i ""'=PIADMPEDateEnd s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	...s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",2)
	...s ^DHCPETMPOSQ("IADM", PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd_"^"_GDesc_"^"_RegNo

	
	
	// 按团体 
	i (""'=GAdmListDR)&(""=GTAdmListDR) d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",GAdmListDR) //add 2009-07-07 
  	.q:LocFlag=1
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGADM", GAdmListDR, PIADMRowId)) q:PIADMRowId=""  d
	..s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	..s PIADMStatus=$p(CurData,"^",8)
	..Q:("ARRIVED"'=PIADMStatus)
	..s PIBIDR=$p(CurData, "^", 1)
	..s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)), "^", 2)
	..q:(""'=Name)&(PIBIDRName'[Name)
	..s TRegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
	..q:(""'=RegNo)&(TRegNo'=RegNo)
	...S GDesc="",PGADMDR="",PGBIDR=""
	..S PGADMDR=$p(CurData,"^",2)
	..i PGADMDR'="" s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1) 
	..I PGBIDR'="" S GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2)
	..s PIADMPEDateBegin=$p(CurData, "^", 4)
	..Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	..i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	..s PIADMPEDateEnd=$p(CurData,"^",5)
	..Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	..i ""'=PIADMPEDateEnd s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	..s ^DHCPETMPOSQ("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd_"^"_GDesc_"^"_TRegNo
	

	
	// 按团体分组
	i (""'=GTAdmListDR)&(""'=GAdmListDR) d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",+GAdmListDR) //add 2009-07-07 
  	.q:LocFlag=1
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGTeam", GTAdmListDR, PIADMRowId)) q:PIADMRowId=""  d
	..s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	..s PIADMStatus=$p(CurData,"^",8)
	..Q:("ARRIVED"'=PIADMStatus)
	..s PIBIDR=$p(CurData,"^",1)
	..s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
	..q:(""'=Name)&(PIBIDRName'[Name)
	..s TRegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
	..q:(""'=RegNo)&(TRegNo'=RegNo)
	..S GDesc="",PGADMDR="",PGBIDR=""
	..S PGADMDR=$p(CurData,"^",2)
	..i PGADMDR'="" s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1) 
	..I PGBIDR'="" S GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2) 
	..s PIADMPEDateBegin=$p(CurData,"^",4)
	..Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	..i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	..s PIADMPEDateEnd=$p(CurData,"^",5)
	..Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	..i ""'=PIADMPEDateEnd s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	..s ^DHCPETMPOSQ("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd_"^"_GDesc_"^"_TRegNo
	..
	//按时间查找
	If (DateEnd'="")&&(DateBegin'="") Do
	.s Date=""
	.f  s Date=$o(^DHCPEPreIADM(0,"BookDateTime",Date),-1) q:((Date="")||(Date=0)||(Date<DateBegin))  d
	..s EDate=0
	..f  s EDate=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate)) q:((EDate="")||(EDate=0)||(EDate>DateEnd))  d
	...s Time=""
	...f  s Time=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time),-1) q:((Time="")||(Time=0))  d
	....s PIADMRowId=0
	....f  s PIADMRowId=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time,PIADMRowId)) q:PIADMRowId=""  d
    .....s CurData=$g(^DHCPEPreIADM(PIADMRowId))
    .....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADMRowId) //add 2009-07-07 
  	.....q:LocFlag=1
	.....s PIADMStatus=$p(CurData,"^",8)
	.....Q:("ARRIVED"'=PIADMStatus)
	.....S GDesc="",PGADMDR="",PGBIDR=""
	.....S PGADMDR=$p(CurData,"^",2)
	.....q:(""'=GAdmListDR)&(GAdmListDR'=PGADMDR)
	.....i PGADMDR'="" s PGBIDR=$P($G(^DHCPEPreGADM(PGADMDR)),"^",1) 
	.....I PGBIDR'="" S GDesc=$P($G(^DHCPEPreGBI(PGBIDR)),"^",2) 
	.....S PGTeamDR=$p(CurData,"^",3)
	.....q:(""'=GTAdmListDR)&(GTAdmListDR'=PGTeamDR)
	.....s PIBIDR=$p(CurData,"^",1)
	.....s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
	.....q:(""'=Name)&(PIBIDRName'[Name)
	.....s TRegNo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
	.....q:(""'=RegNo)&(TRegNo'=RegNo)
	.....s PIADMPEDateBegin=$p(CurData,"^",4)
	.....Q:(""'=DateBegin)&(+DateBegin>+PIADMPEDateBegin)
	.....i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	.....s PIADMPEDateEnd=$p(CurData,"^",5)
	.....Q:(""'=DateEnd)&(+DateEnd<+PIADMPEDateEnd)
	.....i ""'=PIADMPEDateEnd s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	.....s ^DHCPETMPOSQ("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd_"^"_GDesc_"^"_TRegNo
 	// /////////////////////// 统计 /////////////////////////////////// 
	s PIADMRowId="0"
	f  s PIADMRowId=$O(^DHCPETMPOSQ("IADM",PIADMRowId)) q:PIADMRowId=""  d
	.s PIOIRowId=0
	.f  s PIOIRowId=$O(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIRowId)) q:PIOIRowId=""  d
	..s OSTATDesc=""
	..s CRMORowId=$O(^DHCPECRMO(0,"CRMORI",PIADMRowId_"||"_PIOIRowId, 0))
	..q:CRMORowId=""
	..s Flag=1
	..// 查询项目遗嘱的执行状态
	..i ""'=CRMORowId d
	...s OEORIDR=$P($G(^DHCPECRMO(CRMORowId)), "^", 1)
	...s OEORIItemStatDR=$p($G(^OEORD($P(OEORIDR,"||",1),"I",$P(OEORIDR,"||",2),1)),"^",13)
	...// OEC_OrderStatus.{OSTAT_Code}
	...s OSTATCode=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",1)
	...s:(""'=OEOrderStatus)&(OEOrderStatus'[("^"_OSTATCode_"^")) Flag=0
	...// OEC_OrderStatus.{OSTAT_Desc}
	...s OSTATDesc=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
	..Q:(0=Flag)
	..s CurData=$G(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIRowId))
	..//应收金额
	..s ARCIMPrice=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIRowId)),"^",14)
	..i $p(ARCIMPrice,".",1)="" s ARCIMPrice=0_ARCIMPrice
	..s ARCIMPrice=$fn(ARCIMPrice,"",2)
	..//实际金额
	..s FactPrice=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIADMRowId_"||"_PIOIRowId,"","")
	..i $p(FactPrice,".",1)="" s FactPrice=0_FactPrice
	..s FactPrice=$fn(FactPrice,"",2)
    ..//折扣系数
    .. s DiscountRelate=0
    ..i ARCIMPrice'="0.00" s DiscountRelate=FactPrice/ARCIMPrice
    ..i $p(DiscountRelate,".",1)="" s DiscountRelate=0_DiscountRelate
	..s DiscountRelate=$fn(DiscountRelate,"",2)
	
	..s PIOIStatus=$P(CurData,"^",16)
	..Q:(""'=OEItemStatus)&(OEItemStatus[("^DEL^"))&(6'=+PIOIStatus)
	..s PIOIType=$P(CurData,"^",15)
	..Q:(""'=OEItemStatus)&(OEItemStatus'[("^"_PIOIType_"^"))
	..s Status=""
	..i ("PRE"=PIOIType) s Status="预约"
	..i ("ADD"=PIOIType) s Status="加项"
	..i ("6"=+PIOIStatus) s Status="删除"
	..
	..s PatName=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",1)
	..s ADMPEDateBegin=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",2)
	..s ADMPEDateEnd=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",3)
	..S GDesc=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",4)
	..s TRegNo=$P($G(^DHCPETMPOSQ("IADM",PIADMRowId)),"^",5)
	..// DHC_PE_PreIOrdItem.{ PIOI_ItmMast_DR }
	..s ARCIMDR=$P(CurData,"^",1)
	..Q:(""'=OEItemDR)&(OEItemDR'=ARCIMDR) //按项目查询
	..
	..// 过滤非医嘱站点
	..s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	..Q:(OtherSTRowId=$g(^DHCPESetting("DHCPE","StationId_Other")))
	..

	..s ARCIMDesc=$p(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1),"^",2)
	..s Data=$LB(PIADMRowId, PatName, ADMPEDateBegin,ADMPEDateEnd,ARCIMDR,ARCIMDesc,Status,OSTATDesc,GDesc,TRegNo,ARCIMPrice,FactPrice,DiscountRelate)
    ..d OEItemStatusQueryOut

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OEItemStatusQueryOut
	 s ^DHCPETMPItemStatus(User,"ItemStatus","List",ind)=PatName_"^"_TRegNo_"^"_GDesc_"^"_ARCIMDesc_"^"_Status_"^"_OSTATDesc_"^"_ADMPEDateBegin_"^"_ADMPEDateEnd_"^"_ARCIMPrice_"^"_FactPrice_"^"_DiscountRelate
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OEItemStatusQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OEItemStatusQueryExecute ]
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

ClassMethod OEItemStatusQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OEItemStatusQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemStatusRows(User)
{
 
 s iLLoop=0 ,Rows=0
 f  s iLLoop=$O(^DHCPETMPItemStatus(User,"ItemStatus","List",iLLoop)) Q:(""=iLLoop)  d
 .s Rows=Rows+1
 q Rows
}

ClassMethod GetItemStatusData(User, i)
{
	
	q:'$d(^DHCPETMPItemStatus(User,"ItemStatus","List",i)) ""
	q $g(^DHCPETMPItemStatus(User,"ItemStatus","List",i))
}

/// 每日体检项目工作量统计
/// 
/// w ##Class(web.DHCPE.Report.OEItemStatus).OEItemDayStatisticImport("","","2007-7")
ClassMethod OEItemDayStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	
	k ^DHCPESWATMP
	
	s ImportDate=$P(Instring,"^",1)
	s StartDate=$P(Instring,"^",2)
	s EndDate=$P(Instring,"^",3)
 	s:StartDate'="" StartDate=$ZDH(StartDate,4)
 	s:EndDate'="" EndDate=$ZDH(EndDate,4)
 	
 	Q:(""=ImportDate) ""
 	
	s DateBegin=$ZDH(ImportDate_"-01",3)
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P(ImportDate,"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay
 	
 	
 	s:StartDate'="" DateBegin=StartDate
  	s:EndDate'="" DateEnd=EndDate
  	
  	
	s:(0'=+DateBegin) DateBegin=DateBegin-1
 	// DHC_PE_IADM.{ IADM_AdmDate } 
	s IADMAdmDate=+DateBegin
	
	s IADMAdmDate=IADMAdmDate
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>=+DateEnd)||(""=IADMAdmDate))  d
	.//DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate,IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s PAADMDR=$p($g(^DHCPEIADM(IAdmRowId)),"^",1)
	...Q:(PAADMDR="")
	...s OEORDRowId=0
	...// OE_Order.OEORD_RowId
	...f  s OEORDRowId=$O(^OEORD(0,"Adm", PAADMDR, OEORDRowId)) q:(""=OEORDRowId)  d
 	....// OE_OrdItem.{ OEORI_Childsub }
 	....s OEORIChildsub=0
 	....f  s OEORIChildsub=$O(^OEORD(OEORDRowId, "I", OEORIChildsub)) q:(""=OEORIChildsub)  d
 	.....
	.....// 过滤非医嘱站点
	.....s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(OEORDRowId_"||"_OEORIChildsub),0))
	.....Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))
	.....//  OEC_OrderStatus
	.....s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.....Q:(6'=OEORIItemStatDR) //6	E	执行	N
	.....
	.....// OEORI_ItmMast_DR
	.....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.....// 按站点给项目排序 先检验,检查,后体检科室 
	.....s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
	.....Q:(""=STRowId)
	.....
	.....i "Lab"=##class(web.DHCPE.Public.Setting).GetStationType(STRowId) d
	......s STRowId=1000+STRowId
	.....e  d
	......s STRowId=2000+STRowId
	.....
	.....
	.....s ^DHCPESWATMP("ItmMast", STRowId, ItmMastDR)=+$G(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR))+1
	.....s ^DHCPESWATMP("ItmMast", STRowId, ItmMastDR, "Day", IADMAdmDate)=+$G(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR, "Day", IADMAdmDate))+1

	
	s ItmMastList=""
	// 项目列表
	s STRowId=0
	f  s STRowId=$O(^DHCPESWATMP("ItmMast", STRowId)) q:STRowId=""  d
	.s ItmMastDR=0
	.f  s ItmMastDR=$O(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR)) q:ItmMastDR=""  d
	..s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
	..s ItmMastList=ItmMastList_"^"_ItmMastDesc
	..
	s ItmMastList=ItmMastList_"^"_"备注"
	s retValue=ItmMastList_";"
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(ItmMastList,"O","JS")_"');"
	.&javascript<#(retval)#>
	.	
	
	//w !,"项目列表:"_retValue,!
	s DayAmount=""
	s STRowId=0
	f  s STRowId=$O(^DHCPESWATMP("ItmMast", STRowId)) q:STRowId=""  d
	.s ItmMastDR=0
	.f  s ItmMastDR=$O(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR)) q:ItmMastDR=""  d
	..s Amount=+$G(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR))
	..s DayAmount=DayAmount_"^"_Amount
	..
	s DayAmount="总计"_DayAmount
	s retValue=retValue_DayAmount_";"
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(DayAmount,"O","JS")_"');"
	.&javascript<#(retval)#>
	.
	// w !,"总计:"_retValue,!
	
	s AdmDate=DateBegin+1
	while (AdmDate<+DateEnd) {
		
		s DayAmount=""
		s STRowId=0
		f  s STRowId=$O(^DHCPESWATMP("ItmMast", STRowId)) q:STRowId=""  d
		.s ItmMastDR=0		
		.f  s ItmMastDR=$O(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR)) q:ItmMastDR=""  d
		..s Amount=+$G(^DHCPESWATMP("ItmMast", STRowId, ItmMastDR, "Day", AdmDate))
		..s DayAmount=DayAmount_"^"_Amount
		..
		
		s Date=$ZD(AdmDate,3)
		s DayAmount=Date_DayAmount
		// w "每日情况:"_DayAmount,!
		
		s retValue=retValue_DayAmount_";"
		s AdmDate=+AdmDate+1
		
		i ""'=itmjs d
		.s retval=itmjs_"('"_$ZCVT(DayAmount,"O","JS")_"');"
		.&javascript<#(retval)#>
		.
	}
	
	//Q "1" //retValue
	Q retValue
}

}
