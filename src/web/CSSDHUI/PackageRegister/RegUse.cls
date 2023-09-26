Import SQLUser

Class web.CSSDHUI.PackageRegister.RegUse Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 待消耗消毒包
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageRegister.RegUse","GetLocPackages",^tmplkkl)
Query GetLocPackages(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "TransId:%Integer,Label,PkgDesc,AttributeId,ExpDate,MinusDate,CurLoction,Status,SteDate,PkgId") [ SqlProc ]
{
}

ClassMethod GetLocPackagesExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (%session,qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s curDate=$p($h,",",1)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s pSupLocId=PJObj.%Get("SupLoc")
	s pLabel=PJObj.%Get("Label")
	s gHospId=PJObj.%Get("gHospId")
	s pStartDate=PJObj.%Get("StartDate")
	s pEndDate=PJObj.%Get("EndDate")
	q:((pStartDate="")||(pEndDate="")) $$$OK
	
	s pStartDate=..DH2L(pStartDate)
	s pEndDate=..DH2L(pEndDate)
	s SqlStr="SELECT CSSDT_Rowid,CSSDT_Date as SteDate, CSSDT_ExpDate as ExpDate, CSSDT_Label as Label,CSSDT_Trf_DR->CSSDPD_Parref_DR as TrfId,"
		_" CSSDT_Package_DR as PkgId,CSSDT_Package_DR->CSSDP_Desc as PkgDesc,CSSDT_Package_DR->CSSDP_Hospital as HospitalDr,"
		_" CSSDT_Package_DR->CSSDP_PackTypeDetail as AttributeId,CSSDT_Status as Status,CSSDT_Disp_DR->CSSDPD_Parref_DR as DispId,"
		_" CSSDT_ExpDealDate,CSSDT_ExpDealTime,CSSDT_ExpDealUser_DR->ssusr_name as ExpDealUserName,CSSDT_Pack_DR->CSSDPP_PackLocDR as PackLocId,"
		_" CSSDT_ExpDealCleanDetailDr,CSSDT_ExpDealCleanDetailDr->CSSDCDP_CleanMainDR->CSSDC_No as ExpDealCleanNo"
		_" FROM cssd_trans WHERE CSSDT_Status in ('R','D','U') and CSSDT_Date between "_pStartDate_" and "_pEndDate
	i pLabel'="" d
	.s SqlStr=SqlStr_" And CSSDT_Label='"_pLabel_"'"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(SqlStr)
	d result.Execute()
	While(result.Next())
	{
		s TransId=result.Data("CSSDT_Rowid")
		s SteDate=result.Data("SteDate")
		s ExpDate=result.Data("ExpDate")
		s Label=result.Data("Label")
		s PkgId=result.Data("PkgId")
		s Status=result.Data("Status")
		s ExpDealDate=result.Data("CSSDT_ExpDealDate")
		s ExpDealTime=result.Data("CSSDT_ExpDealTime")
		s ExpDealUserName=result.Data("ExpDealUserName")
		s AttributeId=result.Data("AttributeId")
		s PkgDesc=result.Data("PkgDesc")
		s ExpDealCleanDetailId=result.Data("CSSDT_ExpDealCleanDetailDr")
		s ExpDealCleanNo=result.Data("ExpDealCleanNo")
		s TrfId=result.Data("TrfId")
		s DispId=result.Data("DispId")
		s PackLocId=result.Data("PackLocId")
		
		i TrfId'="" s DispId=TrfId ;没有调拨记录的取发放
		s ToLocId=$list(^User.CSSDPackageDispMainD(DispId),7) ;接收科室
		s SupLocId=$list(^User.CSSDPackageDispMainD(DispId),2)
		continue:(pSupLocId'="")&&(SupLocId'=pSupLocId)			;只取本科室
		s CurLoction=""
		i ToLocId'="" d
		.s CurLoction=$p(^CTLOC(ToLocId),"^",2)
		e  d
		.s CurLoction=$p(^CTLOC(PackLocId),"^",2) ;没有发放/调拨记录取打包科室
		
		;患者登记的标签当前位置取患者绑定的科室
		s PationtDR="",TransOPId="",PatLoc=""
		s TransOPId=$o(^User.CSSDTransOPI("CSSDTOPLabelIndex",Label,""))
		i TransOPId'="" d
		.s PationtDR=##class(User.CSSDTransOP).%OpenId(TransOPId).CSSDTOPPationtDRGetObjectId()
		.s pationtInfo=##class(web.CSSDHUI.PackageRegister.PkgRegister).ByAdmGetPatInfo(PationtDR)
		.s PatLoc=$p(pationtInfo,"^",3)
		i PatLoc'="" s CurLoction=PatLoc
		
		s ExpDealDate=..DL2H(ExpDealDate)
		s ExpDealTime=..TL2H(ExpDealTime)
		s SteDate=..DL2H(SteDate)
		s MinusDate=ExpDate-curDate
		s ExpDate=..DL2H(ExpDate)
		i AttributeId=1 d
		.s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
		d OutputRow
	}
	d result.Close()
	q $$$OK
OutputRow
	s Data=$lb(TransId,Label,PkgDesc,AttributeId,ExpDate,MinusDate,CurLoction,Status,SteDate,PkgId)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:	wangjiabin
/// CreatDate:	2022-02-25
/// Description:批量处理已使用的消毒包
/// Table:		CSSD_Trans
/// Input:		Params
/// Output:		
/// Return:		RtnObj.Json
/// w ##class(web.CSSDHUI.PackageRegister.RegUse).jsRegUse(^tmpllokk)
ClassMethod jsRegUse(Params As %String) As %String
{
	n (%session,Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s RtnObj=..RegUse(Params)
	q RtnObj.Json()
}

ClassMethod RegUse(Params As %String) As web.CSSDHUI.RtnObj
{
	n (%session,Params)
	s MethodName=$ClassName()_"RegUse"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	i Params="" q RtnObj.Err(-1,"","入参不能为空!")
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i (Sc'=0) q RtnObj.Err(-1,"","入参解析失败:"_MethodName)
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s Label=Obj.%Get("Label")
		s TransId=Obj.%Get("TransId")
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		s TransStatus=TransObj.CSSDTStatus
		i TransStatus="U" d RtnObj.Err(-1,"",Label_"已经使用,不能重复处理!","",0) q
		i TransStatus="TC" d RtnObj.Err(-1,"",Label_"已经过期处理,不能使用!","",0) q
		
		&sql(update CSSD_Trans set CSSDT_Status='U' where CSSDT_Rowid=:TransId)
		i SQLCODE'=0 d RtnObj.Err(-3,"","更新过期信息失败！") q
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

}
