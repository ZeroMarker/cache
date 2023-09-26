Import sqluser

Class web.CSSDHUI.PackageInfo.PackageMatCompare Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// CreatDate:2021-03-05
/// Description:根据消毒包id获取绑定的包装材料信息
/// Table:CSSD_Expire
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.PackageMatCompare","SelectPackageMat","1")
Query SelectPackageMat(Parref As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,MaterialId,MaterialCode,MaterialDesc,Price,ExpLength,DefaultFlag") [ SqlProc ]
{
}

ClassMethod SelectPackageMatExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	i Parref="" q $$$OK
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT CSSDEX_Rowid as RowId,CSSDEX_Price,CSSDEx_IsDefault,CSSDEX_Length,"
			_" CSSDEX_Material_DR as MaterialId,CSSDEX_Material_DR->CSSDM_Code,CSSDEX_Material_DR->CSSDM_Desc"
			_" FROM CSSD_Expire WHERE CSSDEX_Package_DR= "_Parref
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Price = Result.Data("CSSDEX_Price")
		s ExpLength = Result.Data("CSSDEX_Length")
		s DefaultFlag = Result.Data("CSSDEx_IsDefault")
		s MaterialId = Result.Data("MaterialId")
		s MaterialCode = Result.Data("CSSDM_Code")
		s MaterialDesc = Result.Data("CSSDM_Desc")
		continue:MaterialId=""
		d OutPutRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,MaterialId,MaterialCode,MaterialDesc,Price,ExpLength,DefaultFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 保存包装材料
/// w ##class(web.CSSDHUI.PackageInfo.PackageMatCompare).jsSave()
ClassMethod jsSave(Parref As %String, Params As %String, Others As %String) As %Library.String
{
	n (Parref,Params,Others,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Parref,Params,Others)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021-03-05
/// Description:保存消毒包id获取绑定的包装材料信息
/// Table:CSSD_Expire
/// w ##class(web.CSSDHUI.PackageInfo.PackageMatCompare).Save("4","[{""DefaultFlag"":""Y"",""MaterialId"":""1"",""MaterialDesc"":""7天包装"",""ExpLength"":""7"",""Price"":""22""}]","{""BDPHospital"":""2"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod Save(Parref As %String, Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Parref,Params,Others,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s gLocId=OthersObj.%Get("gLocId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s ExpireId=Obj.%Get("RowId")
		s MaterialId=Obj.%Get("MaterialId")
		s ExpLength=Obj.%Get("ExpLength")
		s Price=Obj.%Get("Price")
		s DefaultFlag=Obj.%Get("DefaultFlag")

		s TmpId=$o(^User.CSSDExpireI("IndexCSSDEXPackageMat",Parref,MaterialId,""))
		i ((TmpId'="")&&(ExpireId'=TmpId)) d RtnObj.Err(-2,"","该消毒包维护的包装材料重复,请核对！")
		continue:RtnObj.success'=0

		i ExpireId="" d
		.s ExpireObj=##class(User.CSSDExpire).%New()
		e  d
		.s ExpireObj=##class(User.CSSDExpire).%OpenId(ExpireId)
		.d ExpireObj.%Reload()
		d ExpireObj.CSSDEXPackageSetObjectId(Parref)
		d ExpireObj.CSSDEXMaterialDrSetObjectId(MaterialId)
		s ExpireObj.CSSDEXLength=ExpLength
		s ExpireObj.CSSDEXPrice=Price
		s ExpireObj.CSSDExIsDefault=DefaultFlag
		s Sc=ExpireObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-3,"","保存失败!")
		continue:RtnObj.success'=0
		
		i DefaultFlag="Y" d
		.s RtnObj=##class(web.CSSDHUI.PackageInfo.Package).UpdateLength(Parref,MaterialId,ExpLength,Price)
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除灭菌程序
/// w ##class(web.CSSDHUI.System.SterilizationSys).jsDelete()
ClassMethod jsDelete(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Delete(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:ban
/// CreatDate:2021-03-05
/// Description:删除消毒包id获取绑定的包装材料信息
/// Table:CSSD_Expire
/// d ##class(web.CSSDHUI.PackageInfo.PackageMatCompare).DeleteDetail("{""Rowid"":""9"",""LocCode"":""ZYMZ006"",""LocId"":""6"",""LocDesc"":""肝病门诊""}")
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params,%session)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		
		s RowId=Obj.%Get("RowId")
		s PkgId=$lg(^User.CSSDExpireD(RowId),10)
		s MatCount=0
		&sql(SELECT count(*) into :MatCount FROM CSSD_Expire WHERE CSSDEX_Package_DR=:PkgId)
		i MatCount=1 d RtnObj.Err(-1,"","包装材料不能全部删除!","",0)
		continue:RtnObj.success<0
		
		&sql(Delete from CSSD_Expire where CSSDEX_Rowid=:RowId)
		i SQLCODE'=0 d RtnObj.Err(-1,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// Return:RtnObj.Json()
/// Description:获取包装材料类型
/// Creator:why
/// Date:2021-03-10
/// Table:CSSD_Material
/// Input:ID
/// Output:RtnObj
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.PackageMatCompare","SelectMaterialInfo","RowId","Desc")
Query SelectMaterialInfo(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,MaterialCode,MaterialDesc,ExpLength,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectMaterialInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID,CSSDM_Code,CSSDM_Desc,CSSDM_ExpLength,CSSDM_IsUsed FROM CSSD_Material"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s MaterialCode = Result.Data("CSSDM_Code")
		s MaterialDesc = Result.Data("CSSDM_Desc")
		s ExpLength = Result.Data("CSSDM_ExpLength")
		s UseFlag = Result.Data("CSSDM_IsUsed")
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Material",RowId,PHospId)
		continue:ret="N"
		d OutPutMaterial
	}
	d Result.Close()
	Quit $$$OK
OutPutMaterial
	s Data=$lb(RowId,MaterialCode,MaterialDesc,ExpLength,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod jsSaveMaterialInfo(Params As %String, Others As %String) As %Library.String
{
	n (Params,Others,%session)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..SaveMaterialInfo(Params,Others)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Return:RtnObj.Json()
/// Description:保存包装材料
/// Creator:why
/// Date:2021-03-10
/// Table:CSSD_Material
/// Input:Params
/// Output:RtnObj
/// w ##class(web.CSSDHUI.PackageInfo.PackageMatCompare).SaveMaterialInfo()
ClassMethod SaveMaterialInfo(Params, Others) As %Library.String
{
	n (Params,Others,%session)

	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s MaterialId=Obj.%Get("RowId")
		s MaterialCode=Obj.%Get("MaterialCode")
		s MaterialDesc=Obj.%Get("MaterialDesc")
		s ExpLength=Obj.%Get("ExpLength")
		s UseFlag=Obj.%Get("UseFlag")

		i ((MaterialCode="")||(MaterialDesc="")||(ExpLength="")) d RtnObj.Err(-2,"","包装材料代码、名称、效期长度不能为空!")
		continue:RtnObj.success'=0
		s RecallId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",MaterialCode,"CSSD_Material",PHospId,MaterialId)
		i RecallId'="" d RtnObj.Err(-3,"","包装材料代码重复!")
		continue:RtnObj.success'=0
		s RecallId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",MaterialDesc,"CSSD_Material",PHospId,MaterialId)
		i RecallId'="" d RtnObj.Err(-4,"","包装材料名称重复!")
		continue:RtnObj.success'=0

		i MaterialId="" d
		.s MaterialObj=##class(User.CSSDMaterial).%New()
		e  d
		.s MaterialObj=##class(User.CSSDMaterial).%OpenId(MaterialId)
		.d MaterialObj.%Reload()
		s MaterialObj.CSSDMCode=MaterialCode
		s MaterialObj.CSSDMDesc=MaterialDesc
		s MaterialObj.CSSDMExpLength=ExpLength
		s MaterialObj.CSSDMIsUsed=UseFlag
		s Sc=MaterialObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存失败!")
		continue:RtnObj.success'=0
		s MaterialId=MaterialObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_Material",MaterialId,PHospId)
		i ret'=0 d RtnObj.Err(-6,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

}
