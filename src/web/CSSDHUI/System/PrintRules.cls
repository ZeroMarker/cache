Import sqluser

Class web.CSSDHUI.System.PrintRules Extends (%RegisteredObject, %XML.Adaptor, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:	查询打印规则
/// CreateDate:	2021-08-27
/// Table:		CSSD_PrintRules
/// Input:		RowId,代码,描述
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.System.PrintRules","SelectAllPrintRules","{""Code"":""D"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""Description"":"""",""BDPHospital"":""2""}")
Query SelectAllPrintRules() As web.CSSDHUI.Query(ROWSPEC = "RowId:%Integer,PrintRulesCode,PrintRulesDesc") [ SqlProc ]
{
}

ClassMethod SelectAllPrintRulesExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s Result=##class(%Library.ResultSet).%New()
	s SqlStr="SELECT ID, PR_Code,PR_Desc from CT_STER_CSSD.PrintRules"
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s PrintRulesCode = Result.Data("PR_Code")
		s PrintRulesDesc = Result.Data("PR_Desc")
		continue:+RowId=0
		d OutPutRowPrintRules
	}
	d Result.Close()
	Quit $$$OK
OutPutRowPrintRules
	s Data=$lb(RowId,PrintRulesCode,PrintRulesDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 保存打印规则
/// w ##class(web.CSSDHUI.System.PrintRules).jsSave()
ClassMethod jsSave(Params As %String) As %Library.String
{
	n (Params,Others)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..Save(Params)
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	保存打印规则
/// CreateDate:	2021-08-27
/// Table:		CSSD_PrintRules
/// Input: rowid^代码^描述
/// Return："" : 成功，'""：失败
/// w ##class(web.CSSDHUI.System.PrintRules).Save()
ClassMethod Save(Params As %String) As web.CSSDHUI.RtnObj
{
	n (Params)
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""

		s PrintRulesId=Obj.%Get("RowId")
		s PrintRulesDesc=Obj.%Get("PrintRulesDesc")

		continue:+PrintRulesId=0
		s PrintRulesObj=##class(CT.STER.CSSD.PrintRules).%OpenId(PrintRulesId)
		s PrintRulesObj.PRDesc=PrintRulesDesc
		s Sc=PrintRulesObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-2,"","保存失败!")
		continue:RtnObj.success'=0
	}
	q RtnObj
}

}
