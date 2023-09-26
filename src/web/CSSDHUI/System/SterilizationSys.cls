Import sqluser

Class web.CSSDHUI.System.SterilizationSys Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 灭菌程序
/// 保存灭菌程序信息
/// w ##class(web.CSSDHUI.System.SterilizationSys).jsSave()
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

/// 灭菌程序
/// 保存灭菌程序信息
/// d ##class(web.CSSDHUI.System.SterilizationSys).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
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

		s SterProId=Obj.%Get("RowId")
		s SterProCode=Obj.%Get("SterProCode")
		s BegLabel=Obj.%Get("BegLabel")
		s SterProDesc=Obj.%Get("SterProDesc")
		s UseFlag=Obj.%Get("UseFlag")
		s SterType=Obj.%Get("SterType")
		s Interval=Obj.%Get("Interval")

		s ProType="2001"
		i SterType="" d RtnObj.Err(-2,"",SterProDesc_"没有维护灭菌方式！")
		continue:RtnObj.success'=0
		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",SterProCode,"CSSD_BaseCode",PHospId,SterProId,ProType)
		i CodeId'="" d RtnObj.Err(-3,"","代码已存在！")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",SterProDesc,"CSSD_BaseCode",PHospId,SterProId,ProType)
		i DescId'="" d RtnObj.Err(-4,"","描述已存在！")
		continue:RtnObj.success'=0

		i SterProId="" d
		.s SterProObj=##class(User.CSSDBaseCode).%New()
		e  d
		.s SterProObj=##class(User.CSSDBaseCode).%OpenId(SterProId)
		.d SterProObj.%Reload()
		s SterProObj.CSSDDCCode=SterProCode
		s SterProObj.CSSDDCName=SterProDesc
		s SterProObj.CSSDDCCodeType=ProType
		s SterProObj.CSSDDCNotUseFlag=UseFlag
		d SterProObj.CSSDDCSterWaySetObjectId(SterType)
		s SterProObj.CSSDDCInterval=Interval
		s Sc=SterProObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-5,"","保存失败!")
		continue:RtnObj.success'=0

		s SterProId=SterProObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_BaseCode",SterProId,PHospId)
		i ret'=0 d RtnObj.Err(-6,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除灭菌程序
/// w ##class(web.CSSDHUI.System.SterilizationSys).jsDelete()
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

/// Return:		RtnObj
/// Description:删除灭菌程序
/// Creator:	qiushengxin
/// Date:		2019-04-12
/// Input:		Params
/// Output:		RtnObj
ClassMethod Delete(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s MethodName=$CLASSNAME()_".Delete"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s SterProId=Obj.%Get("RowId")
		continue:SterProId=""
		
		&sql(delete from CSSD_BaseCode where %ID=:SterProId)
		i SQLCODE'=0 d RtnObj.Err(-2,SterProId,MethodName_":处理CSSD_BaseCode失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_BaseCode",SterProId)
		i ret'=0 d RtnObj.Err(-3,SterProId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// 灭菌程序
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.SterilizationSys","SelectAllSterilizationSys")
Query SelectAllSterilizationSys(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,SterProCode,SterProDesc,UseFlag,SterType,SterTypeDesc,Interval:%Float") [ SqlProc ]
{
}

ClassMethod SelectAllSterilizationSysExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
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
	s SqlStr="SELECT %ID As RowId, CSSDDC_CodeType,CSSDDC_Code,CSSDDC_Name,CSSDDC_NotUseFlag,CSSDDC_SterWay,"
		_" CSSDDC_SterWay->CSSDST_SterName as SterTypeDesc, CSSDDC_Interval"
		_" FROM CSSD_BaseCode "
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ProType=Result.Data("CSSDDC_CodeType")
		s RowId = Result.Data("RowId")
		s SterProCode = Result.Data("CSSDDC_Code")
		s SterProDesc = Result.Data("CSSDDC_Name")
		s UseFlag=Result.Data("CSSDDC_NotUseFlag")
		s SterType=Result.Data("CSSDDC_SterWay")
		s SterTypeDesc=Result.Data("SterTypeDesc")
		s Interval=Result.Data("CSSDDC_Interval")
		continue:ProType'="2001"	// 2001为灭菌程序
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_BaseCode",RowId,PHospId)
		continue:ret="N"
		d OutPutRowSterilizationSys
	}
	d Result.Close()
	Quit $$$OK
OutPutRowSterilizationSys
	s Data=$lb(RowId,SterProCode,SterProDesc,UseFlag,SterType,SterTypeDesc,Interval)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
