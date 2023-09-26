Class CHSSWeb.WhFirstCheckEvalService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-09-08
/// Description:检索总体评估情况
/// Table：WhFirstCheckEval
/// Input: WhFirstCheckEval
/// Output：
/// Return：
/// Others：
ClassMethod ListPage(start As %Integer, limit As %Integer, FirstCheckRowIdParref As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,EvalRowIdParref,EvalContent FROM CHSS.WhFirstCheckEval where  FirstCheckRowIdParref ="_FirstCheckRowIdParref
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()
	
	While(result.Next())
	{
	s RowId = result.Data("RowId")
	s EvalRowIdParref= result.Data("EvalRowIdParref")
	s EvalContent= result.Data("EvalContent")
	Set tmp=RowId_"^"_EvalRowIdParref_"^"_EvalContent
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("RowId^EvalRowIdParref^EvalContent",count)
	
	k json
	d result.Close()
	q resultString
}

ClassMethod ShowInfo(start As %Integer, limit As %Integer, FirstCheckRowIdParref As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,EvalRowIdParref,EvalContent FROM CHSS.WhFirstCheckEval where  FirstCheckRowIdParref ="_FirstCheckRowIdParref
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	set tmp = ""
	set startStr = "'"
	
	While(result.Next())
	{
	s RowId = result.Data("RowId")
	s EvalRowIdParref= result.Data("EvalRowIdParref")
	s EvalContent= result.Data("EvalContent")
	Set tmp = tmp_startStr_EvalContent
	s startStr = "\r\n"	
	}
	
	i tmp '= "" d
	.s tmp = tmp_"'"
	e  d
	.s tmp = """"""
	q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod insert(FirstCheckRowIdParref As %Integer, EvalRowIdParref As %Integer, EvalContent As %String) As %String
{
	q:(FirstCheckRowIdParref="") "初次孕产期检查编号为空，保存出错！"
		
	s RowId=""
	q:RowId'="" "code-rep"
	&sql(insert into CHSS.WhFirstCheckEval (FirstCheckRowIdParref, EvalRowIdParref,EvalContent) values(:FirstCheckRowIdParref,:EvalRowIdParref,:EvalContent))
	q SQLCODE
}

ClassMethod update(RowId, EvalRowIdParref As %Integer, EvalContent As %String) As %String
{
	q:(RowId="") "code-rep"
	&sql(update CHSS.WhFirstCheckEval set EvalRowIdParref=:EvalRowIdParref,EvalContent=:EvalContent where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.WhFirstCheckEval where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="WhFirstCheckEvalServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhFirstCheck8FED</DataLocation>
<DefaultData>WhFirstCheckEvalServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhFirstCheck8FED</IdLocation>
<IndexLocation>^CHSSWeb.WhFirstCheck8FEI</IndexLocation>
<StreamLocation>^CHSSWeb.WhFirstCheck8FES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
