Class web.CSSDHUI.Interface.ServiceForHRP Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 消毒成本核算接口
/// call web_CSSDHUI_Interface.PackageDisp("2021-11-01","2022-12-26")
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Interface.ServiceForHRP","QueryPackageDisp","2021-11-01","2022-12-26")
Query QueryPackageDisp(StartDate As %String = "", EndDate As %String = "") As web.CSSDHUI.Query(ROWSPEC = "ACC_YEAR,ACC_MONTH,DEPT_CODE,MAT_CODE,MAT_NAME,MONEY") [ SqlName = PackageDisp, SqlProc ]
{
}

ClassMethod QueryPackageDispExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s FStartDate=..DH2L(StartDate)
	s FEndDate=..DH2L(EndDate)
	q:(FStartDate="")||(FEndDate)="" $$$OK
	
	s Pid=..NewPid()
	k ^TMPCSSD(Pid)
	
	s sql="SELECT main.CSSDPDM_DispDate as DispDate,main.CSSDPDM_ToLoc_DR as locDr,main.CSSDPDM_ToLoc_DR->CTLOC_Desc as locName,main.CSSDPDM_FromLoc_Dr as FromLocdr,"
		_" main.CSSDPDM_FromLoc_Dr->CTLOC_Desc as FromLocName,"
		_" detail.CSSDPD_Package_DR as pkgDr,detail.CSSDPD_Package_DR->CSSDP_Desc as pkgName,detail.CSSDPD_DispPrice as unitPrice,detail.CSSDPD_Qty as qty"
		_" FROM CSSD_PackageDispMain main,cssd_packagedisp detail "
		_" where main.ID=detail.CSSDPD_Parref_DR "
		_" and CSSDPDM_ComplateFlag ='Y' and main.CSSDPDM_DispDate between "_FStartDate_" and "_FEndDate
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sql)
	d result.Execute()
	While(result.Next())
	{
		s tolocdr=result.Data("locDr")
		s toLocName=result.Data("locName")
		s Packagedr=result.Data("pkgDr")
		s PackageName=result.Data("pkgName")
		s UnitPrice=result.Data("unitPrice")
		s Qty=result.Data("qty")
		s DispDate=result.Data("DispDate")
		
		s sumPrice=UnitPrice*Qty
		s DispDate=$zd(DispDate,3)
		s Year=$P(DispDate,"-",1)
		s Month=$P(DispDate,"-",2)
		s data=Year_","_Month_","_Packagedr_","_PackageName_","_tolocdr_","_toLocName
		i '$d(^TMPCSSD(Pid,data)) d
		.s ^TMPCSSD(Pid,data)=sumPrice
		e  d
		.s ^TMPCSSD(Pid,data)=^TMPCSSD(Pid,data)+sumPrice
	}
	d result.Close()
	
	s str=""
	f  s str=$o(^TMPCSSD(Pid,str)) q:str=""  d
	.s sumPrice=^TMPCSSD(Pid,str)
	.s Year=$P(str,",",1)
	.s Month=$P(str,",",2)
	.s packagedr=$P(str,",",3)
	.s Desc=$P(str,",",4)
	.s LocId=$p(str,",",5)
	.s toLocDesc=$p(str,",",6)
	.s Data=$lb(Year,Month,LocId,packagedr,Desc,sumPrice)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	k ^TMPCSSD(Pid)
	q $$$OK
}

}
