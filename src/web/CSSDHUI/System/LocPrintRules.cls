Import sqluser

Class web.CSSDHUI.System.LocPrintRules Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	查询科室打印规则
/// CreateDate:	2022-03-07
/// Table:		CSSD_LocHospPrintRules
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.LocPrintRules","SelectAllLocPrintRules")
Query SelectAllLocPrintRules() As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,HospId,HospDesc,LocId,LocDesc,PrintMode,PrintRulesDesc") [ SqlProc ]
{
}

ClassMethod SelectAllLocPrintRulesExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT LHP_RowId As RowId, LHP_Loc_DR as LocId,LHP_Loc_DR->CTLOC_Desc as LocDesc,"
			_"LHP_Hosp_DR as HospId, LHP_Hosp_DR->HOSP_Desc as HospDesc,LHP_PrintType as PrintMode "
			_"from cf_ster_cssd.LocHospPrintRules"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s LocId = Result.Data("LocId")
		s LocDesc = Result.Data("LocDesc")
		s HospId = Result.Data("HospId")
		s HospDesc = Result.Data("HospDesc")
		s PrintMode = Result.Data("PrintMode")
		continue:+RowId=0
		continue:PrintMode=""
		s PrintRulesDesc=""
		s PrintRulesId = $o(^CT.STER.CSSD.PrintRulesI("CSSDPRCode",PrintMode,""))
		s:PrintRulesId'="" PrintRulesDesc = $lg(^CT.STER.CSSD.PrintRulesD(PrintRulesId),3)
		d OutPutAllLocPrintRules
	}
	d Result.Close()
	Quit $$$OK
OutPutAllLocPrintRules
	s Data=$lb(RowId,HospId,HospDesc,LocId,LocDesc,PrintMode,PrintRulesDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	保存科室打印规则
/// CreateDate:	2022-03-07
/// Table:		CSSD_LocHospPrintRules
/// Input:		LocId,HospId,PrintMode
/// d ##class(web.CSSDHUI.System.LocPrintRules).jsSave(^tmpmy("dsf"))
ClassMethod jsSave(Params) As %Library.String
{
	n (Params)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod Save(Params) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MethodName=$CLASSNAME()_".Save"
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","入参解析失败!")

	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s RowId=Obj.%Get("RowId")
		s LocId=Obj.%Get("LocId")
		s PHospId=Obj.%Get("HospId")
		s PrintMode=Obj.%Get("PrintMode")
		s TmpId=""
		s:LocId'="" TmpId=$o(^CF.STER.CSSD.HospPrintRulesI("IndexCSSDLHPLoc",LocId,"")) 
		i ((TmpId'="")&&(TmpId'=RowId)) d RtnObj.Err(-2,"","科室重复!","",0)
		continue:RtnObj.success'=0
		s TmpId=""
		i PHospId'="" d
		.f  s TmpId=$o(^CF.STER.CSSD.HospPrintRulesI("IndexCSSDLHP",PHospId,TmpId)) q:(TmpId="")  d
		..s TmpLocId=$lg(^CF.STER.CSSD.HospPrintRulesD(TmpId),2)
		..d:((TmpId'=RowId)&&(TmpLocId=""))&&(LocId="") RtnObj.Err(-3,"","院区重复!","",0)
		..continue:RtnObj.success'=0

		i RowId="" d
		.s HospPrintRulesObj=##class(CF.STER.CSSD.HospPrintRules).%New()
		e  d
		.s HospPrintRulesObj=##class(CF.STER.CSSD.HospPrintRules).%OpenId(RowId)
		.d HospPrintRulesObj.%Reload()
		d HospPrintRulesObj.LHPLocDrSetObjectId(LocId)
		d HospPrintRulesObj.LHPHospDrSetObjectId(PHospId)
		s HospPrintRulesObj.LHPPrintType=PrintMode
		s Sc=HospPrintRulesObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-4,"",MethodName_":保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

/// 删除科室打印规则
/// w ##class(web.CSSDHUI.System.LocPrintRules).jsDelete()
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

/// 删除科室打印规则
/// CreateDate:	2022-03-07
/// Table:		CSSD_LocHospPrintRules
/// d ##class(web.CSSDHUI.System.LocPrintRules).Delete("")
ClassMethod Delete(Params) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s MethodName=$CLASSNAME()_".Delete"
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"",MethodName_":参数解析失败")
	While(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s LocHospPrintRulesId=Obj.%Get("RowId")
		continue:LocHospPrintRulesId=""
		&sql(delete from cf_ster_cssd.LocHospPrintRules where LHP_RowId=:LocHospPrintRulesId)
		i SQLCODE'=0 d RtnObj.Err(-2,LocHospPrintRulesId,MethodName_":处理LocHospPrintRules失败,SQLOCDE:"_SQLCODE)
		continue:RtnObj.success<0
	}
	q RtnObj
}

}
