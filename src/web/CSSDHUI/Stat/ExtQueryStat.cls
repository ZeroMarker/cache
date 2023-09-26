Class web.CSSDHUI.Stat.ExtQueryStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:外来器械查询
/// Creator:ban
/// CreateDate:2023-03-10
/// Table:CSSD_Trans
/// Input:查询条件
/// Return：外来器械数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.ExtQueryStat","SelectAll","{""StartDate"":""2023-03-07"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2"",""EndDate"":""2023-03-10"",""DateType"":"""",""ExtUseLocId"":"""",""ExtPkgId"":"""",""ExtFirmId"":""""}")
Query SelectAll(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,BarCode,PkgId,PkgDesc,RecNum:%Integer,Num:%Integer,RecDate,ExtLocDesc") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s PExtPkgId=PJObj.%Get("ExtPkgId")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PExtFirmId=PJObj.%Get("ExtFirmId")
	s PExtUseLocId=PJObj.%Get("ExtUseLocId")
	s gHospId=PJObj.%Get("gHospId")
	s gGroupId = PJObj.%Get("gGroupId")
	s gUserId = PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	q:PStartDate="" $$$OK
	q:PEndDate="" $$$OK
	
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDExt_Rowid,CSSDExt_Code,CSSDExt_InstruName,CSSDExt_RecNum,CSSDExt_InstruNum,CSSDExt_Implants,CSSDExt_ReciveDate,CSSDExt_Loc,CSSDExt_Firm"
		_" FROM CSSD_ExtDevBind where CSSDExt_ReciveDate between '"_PStartDate_"' and '"_PEndDate_"'"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDExt_Rowid")
		s BarCode = Result.Data("CSSDExt_Code")
		s PkgId = Result.Data("CSSDExt_InstruName")
		s RecNum = Result.Data("CSSDExt_RecNum")
		s InstruNum = +Result.Data("CSSDExt_InstruNum")
		s ImplantsNum=+Result.Data("CSSDExt_Implants")
		s RecDate = Result.Data("CSSDExt_ReciveDate")
		s ExtLocId = Result.Data("CSSDExt_Loc")
		s ExtFirmId = Result.Data("CSSDExt_Firm")
		
		continue:(PExtUseLocId'="")&&(PExtUseLocId'=ExtLocId)
		continue:(PExtPkgId'="")&&(PExtPkgId'=PkgId)
		continue:(PExtFirmId'="")&&(PExtFirmId'=ExtFirmId)
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
		continue:ShowDataFlag="N"
		
		s PkgObj = ##class(User.CSSDPackage).%OpenId(PkgId)
		s PkgDesc=PkgObj.CSSDPDesc
		s RecDate=..DL2H(RecDate)
		s ExtLocDesc=..sssLocDesc(ExtLocId)
		
		s Num=0
		s ExtItmId=""
		f  s ExtItmId=$o(^User.CSSDExtDevBindDetailI("ParrefDrPkgDrIndex",RowId,PkgId,ExtItmId)) q:ExtItmId=""  d
		.s ExtItmObj=##class(User.CSSDExtDevBindDetail).%OpenId(ExtItmId)
		.d ExtItmObj.%Reload()
		.s Qty=ExtItmObj.CSSDEBDQty
		.s Num=Num+Qty
		.
		i Num=0 d
		.s Num=InstruNum+ImplantsNum
		.
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,BarCode,PkgId,PkgDesc,RecNum,Num,RecDate,ExtLocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
