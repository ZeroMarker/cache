Import SQLUser

/// 主要功能		: 每日体检人员列表
/// 主要功能		：(安贞医院需求)
/// 
Class web.DHCPE.Report.PEDayList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 41;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.QueryPEDayList","QueryPEDayList","","","",$H)
Query QueryPEDayList(PEDate As %Library.String = "") As %Query(ROWSPEC = "PDL_PEDate:%String, PDL_Name:%String, PDL_Telephone:%String, PDL_FactAmount:%String, PDL_PrintReportDate:%String, PDL_Signature:%String")
{
}

ClassMethod QueryPEDayListExecute(ByRef qHandle As %Binary, PEDate As %Library.String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	k ^DHCPETMP("PDL")
 	s:(""=PEDate) PEDate=+$H
 	d ..QueryPEDayList(PEDate)
 	s ind=1
 	s id=0
 	
 	s IADMRowId=0
 	f  s IADMRowId=$O(^DHCPETMP("PDL", "List", IADMRowId)) Q:(""=IADMRowId)  d
	.s CurData=^DHCPETMP("PDL", "List", IADMRowId)
	.s AdmDate=$P(CurData, "^", 1)
	.s PIBIName=$P(CurData, "^", 2)
	.s PIBITel=$P(CurData, "^", 3)
	.s FinalAmount=$P(CurData, "^", 4)
	.s ReportDate=$P(CurData, "^", 5)
	.s Signature=$P(CurData, "^", 6)
	.s Data=$LB(AdmDate, PIBIName, PIBITel, FinalAmount, ReportDate, Signature)
	.d QueryPEDayListOut
	.
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
QueryPEDayListOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryPEDayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPEDayListExecute ]
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

ClassMethod QueryPEDayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPEDayListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(web.DHCPE.Report.PEDayList).QueryPEDayList(+$H)
ClassMethod QueryPEDayList(PEDate As %Library.String = "")
{
	s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",PEDate),-1)
	//f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(""=AdmDate)  d
	f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(""=AdmDate)||(PEDate'=AdmDate)  d
	.s Time=0
	.f  s Time=$O(^DHCPEIADM(0, "AdmDateTime", AdmDate, Time)) q:(""=Time)  d
	..s IADMRowId=0
	..f  s IADMRowId=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADMRowId)) q:(""=IADMRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...s Curdata=$G(^DHCPEIADM(IADMRowId))
	...
	...// DHC_PE_IADM.{ IADM_Status }
	...s IADMStatus=$p(Curdata,"^",8)
	...Q:'((IADMStatus="COMPLETED")||(IADMStatus="ARRIVED"))
	...// DHC_PE_IADM.{ IADM_CRMADM } = DHC_PE_PreIADM.{ PIADM_RowId }
	...s PIAdmRowId=$P($g(^DHCPEIADM(IADMRowId)),"^",4)
	...Q:(""=PIAdmRowId)
	...// DHC_PE_PreIADM.{ PIADM_PIBI_DR }
	...s PIBIDR=$P($G(^DHCPEPreIADM(PIAdmRowId)),"^",1)
	...Q:(""=PIBIDR)
	...// DHC_PE_PreIBaseInfo.{ PIBI_Name }
	...s PIBIName=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	...
	...// DHC_PE_PreIBaseInfo.{ PIBI_Tel1 }
	...s PIBITel=$p(^DHCPEPreIBI(PIBIDR),"^",6)
	...
	...// DHC_PE_PreIBaseInfo.{ PIBI_MobilePhone }
	...s PIBIMobilePhone=$p(^DHCPEPreIBI(PIBIDR),"^",8)
	...s:(""'=PIBIMobilePhone) PIBITel=PIBIMobilePhone
	...
	...// DHC_PE_PreIBaseInfo.{ PIBI_Sex_DR } 性别
	...s PIBISex=$p(^DHCPEPreIBI(PIBIDR),"^",3)
	...//  CT_Sex
	...i PIBISex'="" s PIBISex=$p(^CT("SEX",PIBISex),"^",2)
	...
	...// DHC_PE_PreIBaseInfo.{ PIBI_DOB }	出生日期
	...s PIBIDOB=$p(^DHCPEPreIBI(PIBIDR),"^",4)
 	...//年龄
 	...s:(PIBIDOB'="") PIBIDOB=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
	...// DHC_PE_PreIBaseInfo.{ PIBI_Married_DR }
	...s PIBIMarried=$p(^DHCPEPreIBI(PIBIDR),"^",17)
	...
	...// 应付金额^最终金额^公费金额^公费已付^公费未付^自费金额^自费已付^自费未付
	...s retvalue=##Class(web.DHCPE.InvPrt).GetAdmFee(PIAdmRowId)
	...Q:(""=retvalue)
	...// 实际金额
	...s FinalAmount=+$P(retvalue,"^",2)
	...s ^DHCPETMP("PDL", "FinalAmount")=FinalAmount+$G(^DHCPETMP("PDL","FinalAmount"))
	...
	...s ReportDate=$P($G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",PIAdmRowId)),"^",1)
	...s:(""'=ReportDate) ReportDate=$ZD(ReportDate,3)
	...// 										体检日期		姓名			电话		费用						取报告日期		签名
	...s ^DHCPETMP("PDL", "List", IADMRowId)=$ZD(AdmDate,3)_"^"_PIBIName_"^"_PIBITel_"^"_$FN(FinalAmount, "", 2)_"^"_	ReportDate_"^"_			""
	...s ^DHCPETMP("PDL", "Count")=1+$G(^DHCPETMP("PDL","Count"))
	...
	
	Q
}

/// d ##Class(web.DHCPE.Report.PEDayList).PEDayListImport("Out","","04/01/2008")
ClassMethod PEDayListImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	k ^DHCPETMP("PDL")
	s PEDate=$ZDH(Instring, 4)
 	s:(""=PEDate) PEDate=+$H
 	d ..QueryPEDayList(PEDate)
 	
 	s IADMRowId=0
 	f  s IADMRowId=$O(^DHCPETMP("PDL", "List",IADMRowId)) Q:(""=IADMRowId)  d
	.s Data=^DHCPETMP("PDL", "List",IADMRowId)
	.// 	体检日期			姓名				取报告日期			报告已出	电话				费用				签名
	.s Data=$P(Data,"^",1)_"^"_$P(Data,"^",2)_"^"_$P(Data,"^",5)_"^"_	""_"^"_		$P(Data,"^",3)_"^"_$P(Data,"^",4)_"^"_$P(Data,"^",6)
	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	// 		体检日期			姓名										取报告日期	报告已出	电话		费用												签名
	s Data="总计:"_"^"_			""_$G(^DHCPETMP("PDL", "Count"))_"人"_"^"_	""_"^"_		""_"^"_		""_"^"_		$FN($G(^DHCPETMP("PDL", "FinalAmount")),"",2)_"^"_	""
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	Q
}

}
