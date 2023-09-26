Import SQLUser

///  未检补检未总检查询
Class web.DHCPE.Report.AdmOEStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 120;

/// w ##class(%ResultSet).RunQuery("web.DHCPE.Report.AdmOEStatus","AdmOEStatusQuery","100110","","","","")
Query AdmOEStatusQuery(RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", AdmDate As %Library.String = "", Status As %Library.String = "", GAdmList As %String = "") As %Query(ROWSPEC = "AOQ_ADMID:%String, AOQ_IADMID:%String, AOQ_AdmNo:%String, AOQ_Name:%String, AOQ_GName:%String, AOQ_AdmDate:%String, AOQ_OrdItemsStatus:%String,TSort:%String")
{
}

ClassMethod AdmOEStatusQueryExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", AdmDate As %Library.String = "", Status As %Library.String = "", GAdmList As %String = "") As %Status
{
   
	
 	s ind=10
 	s id=0
 	s m=0
	Set repid=$I(^CacheTemp)
	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
	s GAdmList=##class(web.DHCPE.DHCPECommon).UnEscape(GAdmList)
	i ((RegNo="")&(Name="")&(GAdmListDR="")&(AdmDate="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
    
    i AdmDate'="" s AdmDate=##class(websys.Conversions).DateHtmlToLogical(AdmDate)
    
	k ^DHCPETMP
	k ^DHCPESort("sort")
 	// 格式化登记号
 	s:(""'=RegNo) RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	
	s IAdmId="0"
	f  s IAdmId=$O(^DHCPEIADM(IAdmId)) q:IAdmId=""  d 
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmId)          //add 2009-07-07 
  	.q:LocFlag=1
	.s Curdata=$G(^DHCPEIADM(IAdmId))
	.s IADMStatus=$p(Curdata,"^",8)
	.s OrdItemsStatus=""
	.Q:'((IADMStatus="COMPLETED")||(IADMStatus="ARRIVED"))
	.s IADMAdmDate=$p(Curdata,"^",5)
	.//过滤2007-07-12以前的数据    2007-07-25
	.//q:(IADMAdmDate<60823)
	.s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	.q:IADMAdmDate<PESystemStartDate
	.q:((AdmDate'="")&(IADMAdmDate'="")&(AdmDate'=IADMAdmDate))
	.s:(""'=IADMAdmDate) IADMAdmDate=##class(websys.Conversions).DateLogicalToHtml(IADMAdmDate)
	. 
	.s GAdmId=$p(Curdata,"^",2)
	.s GID=""
	.s:(""'=GAdmId) GID=$p($g(^DHCPEGADM(GAdmId)),"^",1)
	.;Q:(""'=GAdmListDR)&((""=GID)||(GID'=GAdmListDR))
	.Q:(""'=GAdmListDR)&((""=GAdmId)||(GAdmId'=GAdmListDR))
	.s GDesc=""
	.s:(""'=GID) GDesc=$P($G(^DHCPEGBI(GID)),"^",2)
	.s paadmId=$p(Curdata,"^",1)
	.q:(paadmId="")
	.s patMatId=$p($G(^PAADM(paadmId)),"^",1)
	.q:patMatId=""
	.s PAADMNo=$p(^PAADM(paadmId),"^",81)
	.q:(RegNo'="")&(RegNo'=$p($g(^PAPER(patMatId,"PAT",1)),"^",1))
	.
	.q:(Name'="")&($p($g(^PAPER(patMatId,"ALL")),"^",1)'[Name)
	.
	.s retAdmId=paadmId, retPatName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	.s retAdmNo=$p($g(^PAPER(patMatId,"PAT",1)),"^",2)
	.// PAPMI_Name
	.s retName=$p($g(^PAPER(patMatId,"ALL")),"^",1)
	.s retRegStatus=$p(Curdata,"^",8)
	.s retAdmDate=##class(websys.Conversions).DateLogicalToHtml($p(Curdata,"^",5))
	.s ReportStatus=""
	.s RPId=$o(^DHCPERPT(0,"IADM",IAdmId,0))
	.i RPId'="" d
	..s ReportStatus=$p(^DHCPERPT(RPId),"^",2)
	.s:(ReportStatus'="NA") OrdItemsStatus="已总检"
	.;---- 取体检状态----
	.s:(OrdItemsStatus'="已总检") OrdItemsStatus=..IsOrdItemsStatus(retAdmId)
	.//s:(OrdItemsStatus'="已总检") OrdItemsStatus="未总检"
	.q:OrdItemsStatus=""
	.Q:(""'=Status)&(Status'[OrdItemsStatus)
	.s User=%session.Get("LOGON.USERID")
	.s ^DHCPESort("sort",User)=ind
	.s m=m+1
	.s Data=$lb(retAdmId, IAdmId, retAdmNo, retName, GDesc, IADMAdmDate, OrdItemsStatus,m) 
 	.d AdmOEStatusQueryOut
 	.s ^DHCPETMP("ItemsStatus", OrdItemsStatus)=1+$G(^DHCPETMP("ItemsStatus", OrdItemsStatus))
 
 	s title="总计:"
 	s TotalStr=""
 	s ind=1
 	s OrdItemsStatus=0
 	f  s OrdItemsStatus=$O(^DHCPETMP("ItemsStatus", OrdItemsStatus)) Q:(""=OrdItemsStatus)  d
 	.s Total=^DHCPETMP("ItemsStatus", OrdItemsStatus)
 	.s Data=$lb( "", "", "", title, Total, "", OrdItemsStatus)
 	.i TotalStr="" s TotalStr=OrdItemsStatus_" "_Total_"人"
 	.e  s TotalStr=TotalStr_","_OrdItemsStatus_" "_Total_"人"
 	.;d AdmOEStatusQueryOut
 	 w "<font color = blue size=2 >总计:"_TotalStr_"</font>"
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdmOEStatusQueryOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	quit
}

// w ##Class(web.DHCPE.Query.IAdmItemStatus).GetPatOrdItemInfo("","","3759277")

// w ##class(web.DHCPE.Report.AdmOEStatus).IsOrdItemsStatus("465685")

ClassMethod IsOrdItemsStatus(AdmId As %String) As %Integer
{
     

	s ordId=$o(^OEORD(0,"Adm",AdmId,""))
	Q:(ordId="") ""
	s isCompleted=1
	s OrdItemsStatus="未检"
	s ordIChd=0
	f  s ordIChd=$o(^OEORD(ordId,"I",ordIChd)) q:(ordIChd="")  d
	.
	.s hisOEItemDr=ordId_"||"_ordIChd
	.// OE_OrdItem.{ OEORI_ItmMast_DR } ARC_ItmMast
	.s ARCIMDR=$P($G(^OEORD(ordId,"I",ordIChd,1)),"^",2)
	.// DHC_PE_Station.{ ST_RowId }
	.q:ARCIMDR=""
	.s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	.Q:(""=STRowId) //过滤非体检项目
	.
	.s ordIStatus=$p(^OEORD(ordId,"I",ordIChd,1),"^",13)
	.
	.// 过滤非医嘱站点
	.s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(ordId_"||"_ordIChd),0))
	.Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))
	.
	.s ARCIMDesc=$p(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1),"^",2)
	.//w !,"hisOEItemDr:"_hisOEItemDr_"  ordIStatus:"_ordIStatus
	.Q:(ordIStatus=4)
	.
	.i (ordIStatus=6) d
	..s:(OrdItemsStatus="未检") OrdItemsStatus="需补检"
	..
	..//s ^DHCPEAOQTMP("TMP",AdmId,ordIStatus,ordId,ordIChd)=ARCIMDR_"^"_$G(ARCIMDesc)
	.//w "  OrdItemsStatus:"_OrdItemsStatus
	.
	.i (ordIStatus=1) d
	..s isCompleted=0
	..//s ^DHCPEAOQTMP("TMP",AdmId,ordIStatus,ordId,ordIChd)=ARCIMDR_"^"_$G(ARCIMDesc)
	.
	s:(isCompleted=1)&(OrdItemsStatus="需补检") OrdItemsStatus="未总检"
	q OrdItemsStatus
}

/*
ClassMethod AdmOEStatusQueryExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", GAdmListDR As %Library.String = "", GTAdmListDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "") As %Status
{

 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
 	if ((""=RegNo) && (""=Name) && (""=GAdmListDR) && (""=GTAdmListDR)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	k ^DHCPEOSQTMP

 	// 按登记号
 	i (""'=RegNo)&(""=GAdmListDR)&(""=GAdmListDR) d
 	.
 	.// 格式化登记号
 	.s:(""'=RegNo) RegNo=$Extract("00000000",1,8-$LENGTH(RegNo))_RegNo
 	.
 	.// DHC_PE_PreIBaseInfo.{ PIBI_RowId }
 	.s PIBIRowId=0
 	.f  s PIBIRowId=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,PIBIRowId)) q:PIBIRowId=""  d
 	..
	..// DHC_PE_PreIADM.{ PIADM_RowId }
	..s PIADMRowId=0
	..f  s PIADMRowId=$O(^DHCPEPreIADM(0,"PIBI",PIBIRowId,PIADMRowId)) q:PIADMRowId=""  d
	...
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...
	...//  PIADM_Status
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("ARRIVED"'=PIADMStatus)
	...
	...// PIADM_PEDateBegin	预约体检日期 4
	...s PIADMPEDateBegin=$p(CurData,"^",4)
	...Q:(""'=DateBegin)&(+DateBegin<+PIADMPEDateBegin)
	...i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	...
	...// PIADM_PEDateEnd	预约体检日期 5
	...s PIADMPEDateEnd=$p(CurData,"^",5)
	...Q:(""'=DateEnd)&(+DateEnd>+PIADMPEDateEnd)
	...i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	...
	...//PIBI_Name	姓名 1.2
	...s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIRowId)),"^",2)
	...
	...s ^DHCPEOSQTMP("IADM", PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
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
	...
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...
	...//  PIADM_Status
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("ARRIVED"'=PIADMStatus)
	...
	...// PIADM_PEDateBegin	预约体检日期 4
	...s PIADMPEDateBegin=$p(CurData,"^",4)
	...Q:(""'=DateBegin)&(+DateBegin<+PIADMPEDateBegin)
	...i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	...
	...// PIADM_PEDateEnd	预约体检日期 5
	...s PIADMPEDateEnd=$p(CurData,"^",5)
	...Q:(""'=DateEnd)&(+DateEnd>+PIADMPEDateEnd)
	...i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	...
	...s ^DHCPEOSQTMP("IADM",PIADMRowId)=PIBIName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	...

	
	// 按团体
	i (""'=GAdmListDR) d
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGADM", GAdmListDR, PIADMRowId)) q:PIADMRowId=""  d
	..
	..s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	..
	..//  PIADM_Status
	..s PIADMStatus=$p(CurData,"^",8)
	..Q:("ARRIVED"'=PIADMStatus)
	..
	..// PIADM_PIBI_DR
	..s PIBIDR=$p(CurData, "^", 1)
	..//DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名
	..s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)), "^", 2)
	..q:(""'=Name)&(PIBIDRName'[Name)
	..
	..
	..// PIADM_PEDateBegin	预约体检日期 4
	..s PIADMPEDateBegin=$p(CurData, "^", 4)
	..Q:(""'=DateBegin)&(+DateBegin<+PIADMPEDateBegin)
	..i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	..
	..// PIADM_PEDateEnd	预约体检日期 5
	..s PIADMPEDateEnd=$p(CurData,"^",5)
	..Q:(""'=DateEnd)&(+DateEnd>+PIADMPEDateEnd)
	..i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	..
	..
	..s ^DHCPEOSQTMP("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	..
	..	
	
	// 按团体组
	i (""'=GTAdmListDR) d
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
	..Q:(""'=DateBegin)&(+DateBegin<+PIADMPEDateBegin)
	..i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	..
	..// PIADM_PEDateEnd	预约体检日期 5
	..s PIADMPEDateEnd=$p(CurData,"^",5)
	..Q:(""'=DateEnd)&(+DateEnd>+PIADMPEDateEnd)
	..i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	..
	..
	..s ^DHCPEOSQTMP("IADM",PIADMRowId)=PIBIDRName_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	..
	..	
 	

	s PIADMRowId="0"
	f  s PIADMRowId=$O(^DHCPEOSQTMP("IADM",PIADMRowId)) q:PIADMRowId=""  d
	.// DHC_PE_PreAudit.{ PA_RowId }
	.s PARowId=0
	.f  s PARowId=$O(^DHCPEPreA(0,"CRMADM","I",PIADMRowId,PARowId)) q:PARowId=""  d
	..
	..s CurData=$G(^DHCPEPreA(PARowId))
	..// DHC_PE_PreAudit.{ PA_Type }
	..s PAType=$P(CurData,"^",20)
	..// DHC_PE_PreAudit.{ PA_Status }
	..s PAStatus=$P(CurData,"^",21)
	..s Status=""
	..i ("PRE"=PAType)&("U"=PAStatus) s Status="预约"
	..i ("ADD"=PAType)&("U"=PAStatus) s Status="加项"
	..i ("NU"=PAStatus) s Status="删除"
	..s PatName=$P($G(^DHCPEOSQTMP("IADM",PIADMRowId)),"^",1)
	..s ADMPEDateBegin=$P($G(^DHCPEOSQTMP("IADM",PIADMRowId)),"^",2)
	..s ADMPEDateEnd=$P($G(^DHCPEOSQTMP("IADM",PIADMRowId)),"^",3)
	..s ARCIMDR=""
	..s ARCIMDesc=""
	..s Data=$LB(PIADMRowId, PatName, ADMPEDateBegin,ADMPEDateEnd,ARCIMDR,ARCIMDesc,Status)
    ..d AdmOEStatusQueryOut

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdmOEStatusQueryOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}
*/
ClassMethod AdmOEStatusQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmOEStatusQueryExecute ]
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

ClassMethod AdmOEStatusQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmOEStatusQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 显示客户未检项目 DHCPEAdmOEStatus.OEItemList
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.AdmOEStatus","AdmOEItem","433247")
Query AdmOEItem(ADMDR As %Library.String = "") As %Query(ROWSPEC = "AOI_ARCIM_DR:%String, AOI_ARCIM_Desc:%String, AOI_ARCIM_Status:%String")
{
}

ClassMethod AdmOEItemExecute(ByRef qHandle As %Binary, ADMDR As %Library.String = "") As %Status
{

 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	
	i (ADMDR="") {		
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	

	s ordId=$o(^OEORD(0,"Adm",ADMDR,""))
	Q:(ordId="") ""

	s ordIChd=0
	f  s ordIChd=$o(^OEORD(ordId,"I",ordIChd)) q:(ordIChd="")  d
	.s hisOEItemDr=ordId_"||"_ordIChd
	.s ARCIMDR=$P($G(^OEORD(ordId,"I",ordIChd,1)),"^",2)
	.q:ARCIMDR=""
	.s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	.Q:(""=STRowId) //过滤非体检项目 例如抽血费等
	.s ordIStatus=$p(^OEORD(ordId,"I",ordIChd,1),"^",13)
	.s OtherSTRowId=$O(^DHCPEST(0,"STORD_ARCIM",(ordId_"||"_ordIChd),0))
	.Q:(OtherSTRowId=$D(^DHCPESetting("DHCPE","StationId_Other")))      //过滤非医嘱站点
	.s ARCIMDesc=$p(^ARCIM($p(ARCIMDR,"||",1),$p(ARCIMDR,"||",2),1),"^",2)
	.Q:(ordIStatus=4) // 停止
	.Q:(ordIStatus'=1) //"核实"
	.
	.s:(ordIStatus=1) ordIStatus="核实"
	.s:(ordIStatus=2) ordIStatus="未核实"
	.s:(ordIStatus=6) ordIStatus="执行"
	.s Data=$lb( ARCIMDR, ARCIMDesc, ordIStatus) 
	.
 	.do AdmOEItemOut
 	.
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdmOEItemOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AdmOEItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmOEItemExecute ]
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

ClassMethod AdmOEItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmOEItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInd()
{
  s num=$g(^DHCPESort("sort",%session.Get("LOGON.USERID"))) 
  q num
}

ClassMethod GetRow()
{
	s num=0
	s OrdItemsStatus=0
	f  s OrdItemsStatus=$O(^DHCPETMP("ItemsStatus", OrdItemsStatus)) Q:(""=OrdItemsStatus)  d
	.s num=num+1
	q num
}

}
