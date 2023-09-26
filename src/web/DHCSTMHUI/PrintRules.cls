Import sqluser

/// Descript:	物资打印规则
/// CreateDate:	2021-08-27
/// Table:		MAT_PrintRules
Class web.DHCSTMHUI.PrintRules Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存打印规则
/// CreateDate:	2021-08-27
/// Table:		MAT_PrintRules
/// Input: rowid^代码^描述   
/// Return："" : 成功，'""：失败
/// w ##class(web.DHCSTMHUI.PrintRules).Save("[{""RowId"":""1"",""Code"":""23"",""Description"":""描述从""}]")
ClassMethod Save(Params As %String) As %Library.String
{
	n (Params,%session)
	;s ^tmpmy("Save")=Params
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Type=..sssCode()
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Code=Obj.%Get("Code")
		s Description=Obj.%Get("Description")
		s ObjStr=Obj.%ToJSON()
		i RowId'=""  d
		.s RtnObj=..Update(ObjStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	更新打印规则
/// CreateDate:	2021-08-27
/// Table:		MAT_PrintRules
/// Input:		RowId,代码,描述
/// Return:		RtnObj
ClassMethod Update(Params As %String) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	i Code="" d
	.d RtnObj.Err(-1,"","代码不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("MAT_PrintRules",RowId)
	&sql(Update MAT_PrintRules set MATPR_Desc=:Description where MATPR_RowId=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-1,RowId,"Update失败!",Params)
	s RtnObj=##class(Log).SaveLog("MAT_PrintRules","User.MATPrintRules","打印信息",RowId,Description,"U","",OldJsonStr)
	q RtnObj
}

/// Descript:	查询打印规则
/// CreateDate:	2021-08-27
/// Table:		MAT_PrintRules
/// Input:		RowId,代码,描述
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.PrintRules","SelectAll","{""Code"":""D"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""Description"":"""",""BDPHospital"":""2""}")
Query SelectAll(Params As %String) As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	;s ^tmpzx("SelectAllExecute")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pCode=PJobj.%Get("Code")
	s pDescription=PJobj.%Get("Description")
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "select MATPR_RowId as RowId,MATPR_Code as Code, MATPR_Desc as Description from MAT_PrintRules"  
	s Result=##class(%Library.ResultSet).%New()
	s Result.RuntimeMode=0
	d Result.Prepare(SqlStr)
	s Sc=Result.Execute()
	i $$$ISERR(Sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		CONTINUE:+RowId=0	
		s Code = Result.Data("Code")
		CONTINUE:(pDescription'="")&&(Code'[pCode)
		s Description = Result.Data("Description")
		CONTINUE:(pDescription'="")&&((Description'[pDescription)&&(Code'[pDescription))
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,Code,Description)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
