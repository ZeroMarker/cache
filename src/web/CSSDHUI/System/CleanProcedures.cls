Import sqluser

Class web.CSSDHUI.System.CleanProcedures Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// 清洗程序
/// 保存清洗程序信息
/// w ##class(web.CSSDHUI.System.CleanProcedures).jsSave()
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

/// 清洗程序
/// 保存清洗程序信息
/// w ##class(web.CSSDHUI.System.CleanProcedures).Save()
ClassMethod Save(Params As %String, Others As %String) As web.CSSDHUI.RtnObj
{
	n (Params,Others)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s OthersObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s OthersSc=OthersObj.%FromJSON(Others)
	i ((Sc'=0)||(OthersSc'=0)) q Sc=RtnObj.Err(-1,"","入参解析失败!")

	s PHospId=OthersObj.%Get("BDPHospital")
	s gHospId=OthersObj.%Get("gHospId")
	s PHospId=##class(web.CSSDHUI.HospMap).GetBDPHospId(PHospId,gHospId)

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s CleanProId=Obj.%Get("RowId")
		s CleanProCode=Obj.%Get("CleanProCode")
		s CleanProDesc=Obj.%Get("CleanProDesc")
		s Interval=Obj.%Get("Interval")
		s UseFlag=Obj.%Get("UseFlag")

		s ProType="1001"
		s CodeId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Code",CleanProCode,"CSSD_BaseCode",PHospId,CleanProId,ProType)
		i CodeId'="" d RtnObj.Err(-2,"","代码已存在！")
		continue:RtnObj.success'=0
		s DescId=##class(web.CSSDHUI.HospMap).CodeDescIfRepeat("Desc",CleanProDesc,"CSSD_BaseCode",PHospId,CleanProId,ProType)
		i DescId'="" d RtnObj.Err(-3,"","描述已存在！")
		continue:RtnObj.success'=0
		i CleanProId="" d
		.s CleanProObj=##class(User.CSSDBaseCode).%New()
		e  d
		.s CleanProObj=##class(User.CSSDBaseCode).%OpenId(CleanProId)
		.d CleanProObj.%Reload()
		s CleanProObj.CSSDDCCode=CleanProCode
		s CleanProObj.CSSDDCName=CleanProDesc
		s CleanProObj.CSSDDCCodeType=ProType
		s CleanProObj.CSSDDCInterval=Interval
		s CleanProObj.CSSDDCNotUseFlag=UseFlag
		s Sc=CleanProObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"","保存失败!")
		continue:RtnObj.success'=0

		s CleanProId=CleanProObj.%Id()
		s ret = ##class(web.CSSDHUI.HospMap).SaveHOSP("CSSD_BaseCode",CleanProId,PHospId)
		i ret'=0 d RtnObj.Err(-5,"","关联院区失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除清洗程序
/// w ##class(web.CSSDHUI.System.CleanProcedures).jsDelete()
ClassMethod jsDelete(Params As %String) As %String
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
/// Description:删除清洗程序
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

		s CleanProId=Obj.%Get("RowId")
		continue:CleanProId=""
		&sql(delete from CSSD_BaseCode where %ID=:CleanProId)
		i SQLCODE'=0 d RtnObj.Err(-2,CleanProId,MethodName_":处理CSSD_BaseCode失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
		s ret=##class(web.CSSDHUI.HospMap).DeleteHospitals("CSSD_BaseCode",CleanProId)
		i ret'=0 d RtnObj.Err(-3,CleanProId,MethodName_":删除医院关联数据失败！,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.CleanProcedures","SelectAllCleanProcedures","RowId","Desc")
Query SelectAllCleanProcedures(Params As %String) As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,CleanProCode,CleanProDesc,Interval:%Float,UseFlag") [ SqlProc ]
{
}

ClassMethod SelectAllCleanProceduresExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s SqlStr="SELECT %ID As RowId, CSSDDC_CodeType,CSSDDC_Code,CSSDDC_Name,CSSDDC_Interval,CSSDDC_NotUseFlag "
			_" FROM CSSD_BaseCode order by CSSDDC_Code"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s ProType=Result.Data("CSSDDC_CodeType")
		s RowId = Result.Data("RowId")
		s CleanProCode = Result.Data("CSSDDC_Code")
		s CleanProDesc = Result.Data("CSSDDC_Name")
		s Interval=Result.Data("CSSDDC_Interval")
		s UseFlag=Result.Data("CSSDDC_NotUseFlag")
		continue:ProType'="1001"	// 1001为清洗程序
		s ret =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_BaseCode",RowId,PHospId)
		continue:ret="N"
		d OutPutRowCleanProcedures
	}
	d Result.Close()
	Quit $$$OK
OutPutRowCleanProcedures
	s Data=$lb(RowId,CleanProCode,CleanProDesc,Interval,UseFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
