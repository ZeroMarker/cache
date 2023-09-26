Import SQLUser

/// 业务员统计
/// 
Class web.DHCPE.Report.SalerStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

/// w ##class(web.DHCPE.Report.SalerStatistic).SalerStatisticImport("","","2007-12")
ClassMethod SalerStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	
	
	s ImportDate=$P(Instring,"^",1)
	s Year=$p(ImportDate,"-",1)
	s Month=$p(ImportDate,"-",2)
	q:((Year/2000)>2)||((Year/2000)<1)||(Month>12)||(Month<1) "请输入正确的日期"
	s StartDate=$P(Instring,"^",2)
	s EndDate=$P(Instring,"^",3)
 	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)

 	
	s DateBegin=$ZDH(ImportDate_"-01",3)
	
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P(ImportDate,"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay
	
	s:StartDate'="" DateBegin=StartDate
  	s:EndDate'="" DateEnd=EndDate
	
	k ^DHCPETMPPA
	s ^DHCPETMPPA("Instring")=Instring
 	s:(0'=+DateBegin) DateBegin=DateBegin-1
 	// DHC_PE_IADM.{ IADM_AdmDate } 
	s IADMAdmDate=+DateBegin
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
	.//DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime", IADMAdmDate, IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...// IADM_Status
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...
	...// DHC_PE_IADM.{ IADM_GADM_DR }
	...s GADMDR=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
	...i ""'=GADMDR  d
	....// DHC_PE_GADM.{ GADM_GBI_DR }
	....s GBIDR=$P($g(^DHCPEGADM(GADMDR)),"^",2)
	....// DHC_PE_GBaseInfo.{ GBI_Desc }
	....i GBIDR'="" s GDesc=$P($g(^DHCPEGBI(GBIDR)),"^",2)
	...e  d
	....s GDesc=""
	...
	...// DHC_PE_IADM.{ IADM_CRMADM }
	...s CRMADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	...
	...s CurData=$g(^DHCPEPreIADM(CRMADM))
	...
	...//  PIADM_Status
	...//s PIADMStatus=$p(CurData,"^",8)
	...//Q:("ARRIVED"'=PIADMStatus)
	...
	...// PIADM_PIBI_DR
	...s PIBIDR=$p(CurData, "^", 1)
	...//DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名
	...s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)), "^", 2)
	...
	...//  PIADM_Sales_DR
	...s PIADMSalesDR=+$p(CurData,"^",24)
	...// SS_User.{ SSUSR_Name }
	...s:(""'=PIADMSalesDR) SalesName=$P($G(^SSU("SSUSR",PIADMSalesDR)),"^",2)
	...s:("0"=PIADMSalesDR) SalesName="客户中心"
	...//w "PIADMSalesDR:"_PIADMSalesDR_"  SalesName:"_SalesName,!
	...
	...//  PIADM_Type
	...s PIADMType=$p(CurData,"^",25)
	...s:(""=PIADMType) PIADMType="散客"
	...s:("1"=PIADMType) PIADMType="招工"
	...//s:(""=PIADMType) PIADMType="团体"
	...
	...s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(CRMADM)
	...s AAmount=$P(retVal,"^",1)
	...s FAmount=$P(retVal,"^",2)
	...
	...
	...
	...// 加项金额
	...// DHC_PE_PreAudit.{ PA_RowId }
	...s ADDAmount=0
	...s PARowId=0
	...f  s PARowId=$O(^DHCPEPreA(0,"CRMADM","I",CRMADM,PARowId)) q:PARowId=""  d
	....//w !,"CRMADM:"_CRMADM_"  IAdmRowId:"_IAdmRowId_"   ARowId:"_PARowId
	....s CurData=$G(^DHCPEPreA(PARowId))
	....// DHC_PE_PreAudit.{ PA_Type }
	....s PAType=$P(CurData,"^",20)
	....Q:("ADD"'=PAType)
	....// DHC_PE_PreAudit.{ PA_Status }
	....s PAStatus=$P(CurData,"^",21)
	....Q:((PAStatus="NoUse")||(PAStatus="NU"))
	....
	....// PA_FactAmount
	....s ADDAmount=+$G(ADDAmount)+$P(CurData,"^",9)
	....
	...s:(0=ADDAmount) ADDAmount=""
	...
	...
	...
	...s ^DHCPETMPPA("Sales",PIADMSalesDR)=SalesName
	...//																							单价		体检费用
	...s ^DHCPETMPPA("Sales",PIADMSalesDR, PIADMType, "List", IAdmRowId)=GDesc_"^"_PIBIDRName_"^"_AAmount_"^"_FAmount
	...
	...
	...
	s Datas=""
	s SalesDR=""
	f  s SalesDR=$O(^DHCPETMPPA("Sales", SalesDR)) q:(""=SalesDR)  d
	.s SalesName=$G(^DHCPETMPPA("Sales", SalesDR))
	.s PEType="业务员介绍"
	.s:("客户中心"=SalesName) PEType="客户中心"
	.s:("客户中心"=SalesName) SalesName=""
	.s PType=0
	.f  s PType=$O(^DHCPETMPPA("Sales",SalesDR, PType)) q:(""=PType)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPETMPPA("Sales",SalesDR, PType, "List", IAdmRowId)) q:(""=IAdmRowId)  d
	...s CurData=$G(^DHCPETMPPA("Sales",SalesDR, PType, "List", IAdmRowId))
	...
	...// 	体检类别	业务员姓名		单位				体检种类		姓名					单价		体检人次	体检费用			折扣	折后费用	付款方式
	...s Data=PEType_"^"_SalesName_"^"_$P(CurData,"^",1)_"^"_PType_"^"_$P(CurData,"^",2)_"^"_$P(CurData,"^",3)_"^"_1_"^"_$P(CurData,"^",4)_"^"_""	_"^"_		"^"_""
	...s Datas=Datas_Data_";"
	...//w Data,!
	...i ""'=itmjs d
	....s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	....&javascript<#(retval)#>
	
	Q Datas
}

Storage Default
{
<Data name="SalerStatisticDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.SalerStatisticD</DataLocation>
<DefaultData>SalerStatisticDefaultData</DefaultData>
<IdLocation>^web.DHCP.SalerStatisticD</IdLocation>
<IndexLocation>^web.DHCP.SalerStatisticI</IndexLocation>
<StreamLocation>^web.DHCP.SalerStatisticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
