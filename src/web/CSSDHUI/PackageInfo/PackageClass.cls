Import sqluser

/// wfg
Class web.CSSDHUI.PackageInfo.PackageClass Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:cy
/// CreateDate:2019-8-29
/// Description：保存消毒包分类数据
/// Table:CSSD_PackageClass
/// d ##class(web.CSSDHUI.PackageInfo.PackageClass).jsSave()
ClassMethod jsSave(Params, Others) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	ts
	s RtnObj=..Save(Params,Others)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Creator:cy
/// CreateDate:2019-8-29
/// Description：保存消毒包分类数据
/// Table:CSSD_PackageClass
/// d ##class(web.CSSDHUI.PackageInfo.PackageClass).Save("{""BDPHospital"":""10"",""SynType"":""washer"",""gUserId"":""11889"",""gLocId"":""166"",""gGroupId"":""102"",""gHospId"":""2""}")
ClassMethod Save(Params, Others) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	s Sc=PJObj.%FromJSON(Params)
	i ((Sc'=0)||(OthersSc'=0)) q RtnObj.Err(-1,"","入参解析失败!")
	
	s pHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s PkgClassCode=Obj.%Get("PkgClassCode")
		s PkgClassDesc=Obj.%Get("PkgClassDesc")
		s NotUseFlag=Obj.%Get("NotUseFlag")
		
		s (CodeId,DescId)=""
		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",PkgClassCode,"CSSD_PackageClass",pHospId)
		i ((CodeId'="")&&(CodeId'=RowId)) d RtnObj.Err(-2,"",PkgClassCode_"-分类代码重复!")
		continue:RtnObj.success'=0
		
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",PkgClassDesc,"CSSD_PackageClass",pHospId)
		i ((DescId'="")&&(DescId'=RowId)) d RtnObj.Err(-3,"",PkgClassDesc_"-分类描述重复!")
		continue:RtnObj.success'=0
		
		i (NotUseFlag="N")&&(RowId'="") d
		.s PkgId=$o(^User.CSSDPackageI("CSSDPackageClassIndex",RowId,""))	//判断消毒包分类能否停用
		.i PkgId'="" d RtnObj.Err(-4,"","分类:"_PkgClassDesc_"和消毒包存在绑定，不能停用!")
		continue:RtnObj.success'=0
		
		i RowId="" d
		.s PkgClassObj=##class(User.CSSDPackageClass).%New()
		e  d
		.s PkgClassObj=##class(User.CSSDPackageClass).%OpenId(RowId)
		.d PkgClassObj.%Reload()
		s PkgClassObj.CSSDPCPackClassCode=PkgClassCode
		s PkgClassObj.CSSDPCPackCalssName=PkgClassDesc
		s PkgClassObj.CSSDPCNotUseFlag=NotUseFlag
		s Sc=PkgClassObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存失败!")
		continue:RtnObj.success'=0
		
		s:RowId="" RowId=PkgClassObj.%Id()
		s Ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_PackageClass",RowId,pHospId)
		i Ret'=0 d RtnObj.Err(-6,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// Creator:cy
/// CreateDate:2019-8-29
/// Description：查询消毒包分类数据
/// Table:CSSD_PackageClass
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.PackageInfo.PackageClass","SelectAll")
Query SelectAll(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PkgClassCode,PkgClassDesc,BusinessProcess,NotUseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj = ##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	
	s pHospId=PJObj.%Get("BDPHospital")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID As RowId,CSSDPC_PackClassName,CSSDPC_PackClassCode,"
			_"CSSDPC_NotUseFlag FROM CSSD_PackageClass "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		s PkgClassCode = Result.Data("CSSDPC_PackClassCode")
		s PkgClassDesc = Result.Data("CSSDPC_PackClassName")
		s NotUseFlag = Result.Data("CSSDPC_NotUseFlag")
		s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_PackageClass",RowId,pHospId)
		continue:ShowDataFlag="N"
		d OutPutRow
 	}
 	d Result.Close()
 Quit $$$OK
OutPutRow
 s Data=$lb(RowId,PkgClassCode,PkgClassDesc,BusinessProcess,NotUseFlag)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Creator:cy
/// CreateDate:2019-8-29
/// Description：删除消毒包分类信息
/// Table:CSSD_PackageClass
/// d ##class(web.CSSDHUI.PackageInfo.PackageClass).jsDelete()
ClassMethod jsDelete(Params) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!").Json()
	
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s PkgClassId=Obj.%Get("RowId")
		continue:PkgClassId=""
		
		s PkgId=$o(^User.CSSDPackageI("CSSDPackageClassIndex",PkgClassId,""))
		i PkgId'="" d RtnObj.Err(-2,"","该分类存在消毒包数据绑定，不能删除")
		continue:RtnObj.success'=0
		
		&sql(Delete From CSSD_PackageClass WHERE ID =:PkgClassId)
		i SQLCODE'=0  d RtnObj.Err(-3,"","消毒包分类删除失败！")
		continue:RtnObj.success'=0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

}
