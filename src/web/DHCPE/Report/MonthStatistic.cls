Import SQLUser

/// 月工作量统计
/// 为宁波医院做;复兴不要
/// 
Class web.DHCPE.Report.MonthStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.MonthStatistic","MonthStatistic",60915)
Query MonthStatistic(ImportDate As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "PA_Day:%String, PA_Amount:%String,GAmount:%String,IAmount:%String")
{
}

ClassMethod MonthStatisticExecute(ByRef qHandle As %Binary, ImportDate As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
 	//w LocDR_":"_OEItemDR_":"_DateBegin_":"_DateEnd
	s NetAmount=""
 	s ind=1
 	s id=0
 	s:(""=ImportDate) ImportDate=$ZDH($P($ZD($H,3), "-", 1)_"-"_$P($ZD($H,3), "-", 2)_"-01",3)
	Set repid=$I(^CacheTemp)
 	if (""=ImportDate) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	s DateBegin=ImportDate
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P($ZD(ImportDate,3),"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay-1
	s:StartDate'="" DateBegin=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s:EndDate'="" DateEnd=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	k ^DHCPETMPPA
	;s ^DHCPETMPPA("DayNetAmount", IADMAdmDate)=0
 	s:(0'=+DateBegin) DateBegin=DateBegin-1
 	// DHC_PE_IADM.{ IADM_AdmDate } 
	s IADMAdmDate=+DateBegin
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
	.//w "IADMAdmDate:"_IADMAdmDate,!
	.//DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..//w "        IADMAdmTime:"_IADMAdmTime,!
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...// IADM_Status
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...s PIADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",4)
	...s VIPLevel=$P(^DHCPEPreIADM(PIADM),"^",18)
	...s GroupID=$P($g(^DHCPEIADM(IAdmRowId)),"^",2)
	...i GroupID="" d
	....s ^DHCPETMPPA("DayPersonG", IADMAdmDate)=+$G(^DHCPETMPPA("DayPersonG", IADMAdmDate))+1
	....s:VIPLevel=2 ^DHCPETMPPA("DayPersonGV", IADMAdmDate)=+$G(^DHCPETMPPA("DayPersonGV", IADMAdmDate))+1
	....s ^DHCPETMPPA("DayPersonG")=+$G(^DHCPETMPPA("DayPersonG"))+1
	....s:VIPLevel=2 ^DHCPETMPPA("DayPersonGV")=+$G(^DHCPETMPPA("DayPersonGV"))+1
	...e  d
	....s ^DHCPETMPPA("DayPersonI", IADMAdmDate)=+$G(^DHCPETMPPA("DayPersonI", IADMAdmDate))+1
	....s:VIPLevel=2 ^DHCPETMPPA("DayPersonIV",IADMAdmDate)=+$G(^DHCPETMPPA("DayPersonIV",IADMAdmDate))+1
	....s ^DHCPETMPPA("DayPersonI")=+$G(^DHCPETMPPA("DayPersonI"))+1
	....s:VIPLevel=2 ^DHCPETMPPA("DayPersonIV")=+$G(^DHCPETMPPA("DayPersonIV"))+1
	...s ^DHCPETMPPA("DayPerson", IADMAdmDate)=+$G(^DHCPETMPPA("DayPerson", IADMAdmDate))+1
	...s:VIPLevel=2 ^DHCPETMPPA("DayPersonV", IADMAdmDate)=+$G(^DHCPETMPPA("DayPersonV", IADMAdmDate))+1
	
	...s ^DHCPETMPPA("Persontatol")=+$G(^DHCPETMPPA("Persontatol"))+1
	...s:VIPLevel=2 ^DHCPETMPPA("PersontatolV")=+$G(^DHCPETMPPA("PersontatolV"))+1
	
	s AdmDate=0
	f  s AdmDate=$O(^DHCPETMPPA("DayPerson", AdmDate)) q:AdmDate=""  d
	.s Amount=+$G(^DHCPETMPPA("DayPerson", AdmDate))
	.s VAmount=+$G(^DHCPETMPPA("DayPersonV", AdmDate))
	.;i VAmount'=0 s Amount=Amount_"("_VAmount_")"
	.i VAmount'=0 s Amount=Amount
	
	.s GAmount=+$G(^DHCPETMPPA("DayPersonG", AdmDate))
	.s VGAmount=+$G(^DHCPETMPPA("DayPersonGV", AdmDate))
	.;i VGAmount'=0 s GAmount=GAmount_"("_VGAmount_")"
	.i VGAmount'=0 s GAmount=GAmount
	.;s NetAmount=+$G(^DHCPETMPPA("DayNetAmount", IADMAdmDate))  add yd 20160530
	
	.s IAmount=+$G(^DHCPETMPPA("DayPersonI", AdmDate))
	.s VIAmount=+$G(^DHCPETMPPA("DayPersonIV", AdmDate))
	.;i VIAmount'=0 s IAmount=IAmount_"("_VIAmount_")"
	.i VIAmount'=0 s IAmount=IAmount
	.s Data=$LB(##class(websys.Conversions).DateLogicalToHtml(AdmDate),Amount,GAmount,IAmount)
    .d MonthStatisticOut
	
	s Amount=+$G(^DHCPETMPPA("Persontatol"))
	s VAmount=+$G(^DHCPETMPPA("PersontatolV"))
	;i VAmount'=0 s Amount=Amount_"("_VAmount_")"
	i VAmount'=0 s Amount=Amount
	s GAmount=+$G(^DHCPETMPPA("DayPersonG"))
	s VGAmount=+$G(^DHCPETMPPA("DayPersonGV"))
	;i VGAmount'=0 s GAmount=GAmount_"("_VGAmount_")"
	i VGAmount'=0 s GAmount=GAmount
	   
	s IAmount=+$G(^DHCPETMPPA("DayPersonI"))
	s VIAmount=+$G(^DHCPETMPPA("DayPersonIV"))
	;i VIAmount'=0 s IAmount=IAmount_"("_VIAmount_")"
	i VIAmount'=0 s IAmount=IAmount
	s Data=$LB("总计:",Amount,GAmount,IAmount)
	
	//s Data=$LB("总计:",+$G(^DHCPETMPPA("Persontatol")),+$G(^DHCPETMPPA("DayPersonG")),+$G(^DHCPETMPPA("DayPersonI")))
	d MonthStatisticOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
MonthStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/*
ClassMethod MonthStatisticExecute(ByRef qHandle As %Binary, ImportDate As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	
 	s ind=1
 	s id=0
 
 	s:(""=ImportDate) ImportDate=$ZDH($P($ZD($H,3), "-", 1)_"-"_$P($ZD($H,3), "-", 2)_"-01",3)
	Set repid=$I(^CacheTemp)
 	if (""=ImportDate) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
	s DateBegin=ImportDate
	s MaxDay=27
	while(+$P($ZD(DateBegin+MaxDay, 3),"-",2)=+$P($ZD(ImportDate,3),"-",2)) {
		s MaxDay=1+MaxDay
	}
	s DateEnd=DateBegin+MaxDay-1
	
	s:StartDate'="" DateBegin=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s:EndDate'="" DateEnd=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	k ^DHCPETMPPA
 	s:(0'=+DateBegin) DateBegin=DateBegin-1
 	// DHC_PE_IADM.{ IADM_AdmDate } 
	s IADMAdmDate=+DateBegin
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
	.//w "IADMAdmDate:"_IADMAdmDate,!
	.//DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..//w "        IADMAdmTime:"_IADMAdmTime,!
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...// IADM_Status
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...
	...s ^DHCPETMPPA("DayPerson", IADMAdmDate)=+$G(^DHCPETMPPA("DayPerson", IADMAdmDate))+1
	...s ^DHCPETMPPA("Persontatol")=+$G(^DHCPETMPPA("Persontatol"))+1
	
	s AdmDate=0
	f  s AdmDate=$O(^DHCPETMPPA("DayPerson", AdmDate)) q:AdmDate=""  d
	.s Amount=+$G(^DHCPETMPPA("DayPerson", AdmDate))
	.s Data=$LB(##class(websys.Conversions).DateLogicalToHtml(AdmDate),Amount)
    .d MonthStatisticOut
	
	s Data=$LB("总计:",+$G(^DHCPETMPPA("Persontatol")))
	d MonthStatisticOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
MonthStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}
*/
ClassMethod MonthStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthStatisticExecute ]
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

ClassMethod MonthStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCPE.Report.MonthStatistic).MonthDataImport("","","2007-08")
ClassMethod MonthDataImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", ImportDate As %Library.String = "") As %Status
{
 	
 	k ^DHCPETMPPA
 	k ^TEMPDHCPEExport("MonthPEIADMDataImport")
 	k ^TEMPDHCPEExportMonth("MonthPEIADMDataImport")

 	s Instring=ImportDate
 	s ImportDate=$P(Instring,"^",1)
	s StartDate=$P(Instring,"^",2)
	s EndDate=$P(Instring,"^",3)
 	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
 	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 

 	
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
	//w "   IADMAdmDate:"_$ZD(IADMAdmDate,3),!
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>=+DateEnd)||(""=IADMAdmDate))  d
	.
	.//w "IADMAdmDate:"_$ZD(IADMAdmDate,3),!
	.
	.//DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
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
	...// DHC_PE_PreIADM.{ PIADM_Sales_DR }
	...s SalesDR=$P($g(^DHCPEPreIADM(CRMADM)),"^",24)
	...// SS_User.{ SSUSR_Name }
	...s:(""'=SalesDR) SalesName=$P($G(^SSU("SSUSR",SalesDR)),"^",2)
	...s:(""=SalesDR) SalesName="体检中心"
	...// DHC_PE_PreIADM.{ PIADM_PIBI_DR }
	...s PIBIDR=$P($g(^DHCPEPreIADM(CRMADM)),"^",1)
	...// DHC_PE_PreIBaseInfo.{ PIBI_Name }
	...s PName=$P($g(^DHCPEPreIBI(PIBIDR)),"^",2)
	...// DHC_PE_PreIBaseInfo.{ PIBI_MobilePhone }
	...s MobilePhone=$P($g(^DHCPEPreIBI(PIBIDR)),"^",8)
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
	...s ^DHCPETMPPA("DayPerson", IADMAdmDate)=+$G(^DHCPETMPPA("DayPerson", IADMAdmDate))+1
	...
	...s ^DHCPETMPPA("Persontatol")=+$G(^DHCPETMPPA("Persontatol"))+1
	...s ^DHCPETMPPA("DayPerson", IADMAdmDate,"PEADM",SalesName,^DHCPETMPPA("DayPerson", IADMAdmDate))=PName_"^"_GDesc_"^"_MobilePhone_"^"_AAmount_"^"_FAmount_"^"_ADDAmount
	...

	s AdmDate=DateBegin+1
	s strValue=""
	
	while (AdmDate<+DateEnd) {
		
		s Amount=+$G(^DHCPETMPPA("DayPerson", AdmDate))
		// 每天体检客户情况 
		i (Amount>0)&&(""'=itmjs) d
		.
		.d ..MonthPEIADMDataImport(itmjs,itmjsex,AdmDate)

		s Date=$ZD(AdmDate,3)
		s strLine=(AdmDate-DateBegin)_"^"_Date_"^"_Amount
		s strValue=strValue_strLine_";"
		s AdmDate=+AdmDate+1
	}
	Q strValue
}

/// w ##class(web.DHCPE.Report.MonthStatistic).MonthPEIADMDataImport("","","60823")
ClassMethod MonthPEIADMDataImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	s AdmDate=Instring
	s SalesName=""
	s Datas=""
	f  s SalesName=$O(^DHCPETMPPA("DayPerson", AdmDate,"PEADM",SalesName)) q:(""=SalesName)  d
	.s Date=$ZD(AdmDate,3)_"("_+$G(^DHCPETMPPA("DayPerson", AdmDate))_"人)"
	.s PAID=0
	.f  s PAID=$O(^DHCPETMPPA("DayPerson", AdmDate,"PEADM",SalesName, PAID)) q:(""=PAID)  d
	..s CurData=$G(^DHCPETMPPA("DayPerson", AdmDate,"PEADM",SalesName, PAID))
	..// 	日期	业务员 		套餐			价格			姓名					单位					电话				收费情况(金额)		收费情况(款到日期)		加项项目			加项收费	折扣	备注								
	..s Data=Date_"^"_SalesName_"^"		_"^"_$P(CurData,"^",4)_"^"_$P(CurData,"^",1)_"^"_$P(CurData,"^",2)_"^"_$P(CurData,"^",3)_"^"_$P(CurData,"^",5)_"^"					_"^"_$P(CurData,"^",6)_"^"			_"^"	_"^"
	..S ^TEMPDHCPEExport("MonthPEIADMDataImport",Data)=Data
	..s Datas=Datas_Data_";"
	..s Date=""
	
	s Data="",i=0
    f  s Data=$o(^TEMPDHCPEExport("MonthPEIADMDataImport",Data)) q:Data=""  d
    .s i=i+1
    .s ^TEMPDHCPEExportMonth("MonthPEIADMDataImport",i)=$g(^TEMPDHCPEExport("MonthPEIADMDataImport",Data))
    



	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Datas,"O","JS")_"');"
	.&javascript<#(retval)#>
	Q Datas
}

ClassMethod GetMonthStatisticRows()
{
	q $o(^TEMPDHCPEExportMonth("MonthPEIADMDataImport",""),-1)
}

ClassMethod GetMonthStatisticInfo(num)
{
	q:'$d(^TEMPDHCPEExportMonth("MonthPEIADMDataImport",num)) ""
	q $g(^TEMPDHCPEExportMonth("MonthPEIADMDataImport",num))
}

/// w ##class(web.DHCPE.Report.MonthStatistic).getpath()
ClassMethod getpath()
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

Query SearchLoc(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "CTLOC_Code:%String,CTLOC_Desc:%String, CTLOC_RowId:%String")
{
	select CTLOC_Code, CTLOC_Desc, CTLOC_RowId
	from CT_loc
	where CTLOC_Desc %STARTSWITH :Desc
}

}
