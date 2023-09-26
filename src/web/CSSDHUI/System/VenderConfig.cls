Import SQLUser

/// 厂商维护后台类
Class web.CSSDHUI.System.VenderConfig Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械厂商查询
/// Table:CSSD_Ven
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.VenderConfig","QueryVenderInfo","{""gUserId"":""11070"",""gLocId"":""316"",""gGroupId"":""103"",""gHospId"":""2""}","")
Query QueryVenderInfo(Params As %String, Others As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,VenCode,VenDesc,SaleManName,Telephone,Address,IsStop,IsStopDesc,VenType,VenTypeDesc,VenAlias") [ SqlProc ]
{
}

ClassMethod QueryVenderInfoExecute(ByRef qHandle As %Binary, Params As %String, Others As %String) As %Status
{
	n (qHandle,Params,Others)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OtherSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OtherSc'=0)) q $$$OK
	
	s PVenDesc = PJObj.%Get("VenDesc")
	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s HospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDVen_Rowid,CSSDVen_Code,CSSDVen_Name,CSSDVen_SaleManName,CSSDVen_Telephone,"
	 		 _"CSSDVen_Address,CSSDVen_IsStop,CSSDVen_Type,CSSDVen_Number from CSSD_Ven where 1=1"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("CSSDVen_Rowid")
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Ven",RowId,HospId)
		continue:ShowDataFlag="N"
		
		s VenCode = Result.Data("CSSDVen_Code")
		s VenDesc=Result.Data("CSSDVen_Name")
		s SaleManName = Result.Data("CSSDVen_SaleManName")
		s Telephone = Result.Data("CSSDVen_Telephone")
		s Address = Result.Data("CSSDVen_Address")
		s IsStop = Result.Data("CSSDVen_IsStop")
		i IsStop="Y"  s IsStopDesc = "是"
		s IsStopDesc="否"
		s VenType = Result.Data("CSSDVen_Type")
		s VenAlias=Result.Data("CSSDVen_Number")
		
		s PVenDesc=$zcvt(PVenDesc,"L"),VenDescLower=$zcvt(VenDesc,"L"),VenAliasLower=$zcvt(VenAlias,"L")
		i PVenDesc'="" continue:((VenDescLower'[PVenDesc)&&(VenAliasLower'[PVenDesc))
		
		s VenTypeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).getMachineType(VenType)
		d OutPutRow
	}
	d Result.Close()
 Quit $$$OK
OutPutRow
 s Data=$lb(RowId,VenCode,VenDesc,SaleManName,Telephone,Address,IsStop,IsStopDesc,VenType,VenTypeDesc,VenAlias)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Description:外来器械厂商更新、保存
/// Table:CSSD_Ven
/// w ##class(web.CSSDHUI.System.VenderConfig).jsSave("[{""VenDesc"":""宁波器械6"",""VenCode"":""106"",""SaleManName"":""宁波"",""Telephone"":""15029871123"",""Address"":""西安"",""IsStop"":""""}]","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod jsSave(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:外来器械厂商更新、保存
/// Table:CSSD_Ven
/// d ##class(web.CSSDHUI.System.VenderConfig).Save("[{""VenDesc"":""宁波器械6"",""VenCode"":""106"",""SaleManName"":""宁波"",""Telephone"":""15029871123"",""Address"":""西安"",""IsStop"":""""}]","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	q:((Sc'=0)||(OthersSc'=0)) RtnObj.Err(-1,"","入参解析失败!")
	
	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s HospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
 	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s VenCode=Obj.%Get("VenCode")
		s VenDesc=Obj.%Get("VenDesc")
		s VenAlias=Obj.%Get("VenAlias")
		s SaleManName=Obj.%Get("SaleManName")
		s Telephone=Obj.%Get("Telephone")
		s Address=Obj.%Get("Address")
		s IsStop=Obj.%Get("IsStop")
		s VenType=Obj.%Get("VenType")
		s:IsStop="" IsStop="Y"
		s:VenAlias="" VenAlias=##class(web.CSSDHUI.Common.UtilCommon).GetCNCODE(VenDesc,4,"")

		s VenId=""
		s VenId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",VenCode,"CSSD_Ven",HospId)
		i ((VenId'="")&&(VenId'=RowId)) d RtnObj.Err(-1,"","该厂商信息代码重复！")
		continue:RtnObj.success'=0
		s VenId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",VenDesc,"CSSD_Ven",HospId)
		i ((VenId'="")&&(VenId'=RowId)) d RtnObj.Err(-2,"","该厂商信息名称重复！")
		continue:RtnObj.success'=0
		s VenId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("CodeName",VenCode,"CSSD_Ven",HospId,"",VenDesc)
		i ((VenId'="")&&(VenId'=RowId)) d RtnObj.Err(-3,"","该厂商信息已维护！")
		continue:RtnObj.success'=0
		
		i RowId="" d
		.s VenObj=##class(User.CSSDVen).%New()
		e  d
		.s VenObj=##class(User.CSSDVen).%OpenId(RowId)
		.d VenObj.%Reload()
		s VenObj.CSSDVenCode=VenCode
		s VenObj.CSSDVenName=VenDesc
		s VenObj.CSSDVenSaleManName=SaleManName
		s VenObj.CSSDVenTelephone=Telephone
		s VenObj.CSSDVenAddress=Address
		s VenObj.CSSDVenIsStop=IsStop
		s VenObj.CSSDVenType=VenType
		s VenObj.CSSDVenNumber=VenAlias
		s Sc=VenObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",$ClassName()_":Save:保存厂商信息失败!")
		continue:RtnObj.success'=0
		
		i RowId="" d
		.s VenId=VenObj.%Id()
		.s Ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Ven",VenId,HospId)
		.i Ret'=0 d RtnObj.Err(-6,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Description:删除外来器械厂商信息
/// Table:CSSD_Ven
/// w ##class(web.CSSDHUI.System.VenderConfig).jsDelete()
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2020-03-23
/// Description:删除外来器械厂商信息
/// Table:CSSD_Ven
/// d ##class(web.CSSDHUI.System.VenderConfig).Delete()
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s sc=PJObj.%FromJSON(Params)
	q:sc'=0 RtnObj.Err(-1,"","入参解析失败!")
	
	s Obj=PJObj.%Pop()
	s RowId=Obj.%Get("RowId")
	s Flag=..IsExistData(RowId)
	q:Flag="Y" RtnObj.Err(-1,"","存在业务数据不能删除")
	
	&sql(Delete From CSSD_Ven where CSSDVen_Rowid=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-11,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	
	s Ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_Ven",RowId)
	q:Ret'=0 RtnObj.Err(-2,RowId,"删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
	q RtnObj
}

ClassMethod IsExistData(rowid) As %String
{
	n (rowid)
	s (ExtId,Flag,MachineConfigId)=""
	f  s ExtId=$o(^User.CSSDExtDevBindD(ExtId)) q:((ExtId="")||(Flag="Y"))  d
	.s VenId=$lg(^User.CSSDExtDevBindD(ExtId),25)
	.s:VenId=rowid Flag="Y"
	f  s MachineConfigId=$o(^User.CSSDMachineConfigD(MachineConfigId)) q:((MachineConfigId="")||(Flag="Y"))  d
	.s MachineVenId=$lg(^User.CSSDMachineConfigD(MachineConfigId),4)
	.i MachineVenId=rowid s Flag="Y" q
	q Flag
}

}
