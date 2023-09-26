Import sqluser

/// Descript:点评建议维护
/// Creater:    wxj
/// CreateDate: 2019-10-17
Class web.DHCSTMHUI.CommentAdvice Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新点评建议
/// Creater:    wxj
/// CreateDate: 2019-10-17
/// Table:DHC_MatCNT_Advice
/// Input:数据串:RowId^代码^描述,RowId^代码^描述
/// Output:     
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCSTMHUI.CommentAdvice).Save("[{""Code"":""002"",""Description"":""建议2""}]")
ClassMethod Save(Params As %String) As %Library.String
{
	n (Params,%session)
	;s ^tempxj("01")=Params
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
		&sql(select ID into:TmpId from DHC_MatCNT_Advice where MATCA_Code=:Code)
		i (TmpId'="")&&(TmpId'=RowId) d
		.s RtnObj.success=-5
		.s RtnObj.msg=Code_":代码重复"
		&sql(select ID into:TmpId from DHC_MatCNT_Advice where MATCA_Desc=:Description)
		i (TmpId'="")&&(TmpId'=RowId) d
		.s RtnObj.success=-6
		.s RtnObj.msg=Description_":描述重复"
		continue:RtnObj.success'=0
		s ObjStr=Obj.%ToJSON()
		i RowId'=""  d
		.s RtnObj=..Update(ObjStr)
		e  d
		.s RtnObj=..Insert(ObjStr)
		continue:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   判断点评建议代码是否重复
/// Creater:    wxj
/// CreateDate: 2019-10-17
/// Table:DHC_MatCNT_Advice
/// Input:代码
/// Output:     
/// Return：RowId
/// w ##class(web.DHCSTMHUI.CommentAdvice).CheckCode(998)
ClassMethod CheckCode(code As %String) As %Library.String
{
	n (code)
	s RowId=""
	&sql(select ID into :RowId from DHC_MatCNT_Advice where  MATCA_Code=:code)
	q RowId
}

/// Descript:   判断点评建议名称是否重复
/// Creater:    wxj
/// CreateDate: 2019-10-17
/// Table:DHC_MatCNT_Advice
/// Input:名称
/// Output:     
/// Return：RowId
/// w ##class(web.DHCSTMHUI.CommentAdvice).CheckCode(998)
ClassMethod CheckDesc(desc As %String) As %Library.String
{
	n (desc)
	s RowId=""
	&sql(select ID into :RowId from DHC_MatCNT_Advice where MATCA_Desc=:desc)
	q RowId
}

/// Descript:   增加点评建议
/// Creater:    wxj
/// CreateDate: 2019-10-17
/// Table:DHC_MatCNT_Advice
/// Input:代码,描述
/// Output:     
/// Return：RowId
ClassMethod Insert(Params As %String) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","Insert:参数解析错误!")
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	i (Code="")||(Description="") q RtnObj.Err(-1,"","必填项不可为空","",0)
	&sql(Insert into DHC_MatCNT_Advice (MATCA_Code,MATCA_Desc) values (:Code,:Description))
	i SQLCODE'=0 q RtnObj.Err(-2,"","Insert失败:"_SQLCODE_":"_$g(%msg))
	s RtnObj=##class(Log).SaveLog("DHC_MatCNT_Advice","User.DHCMatCNTAdvice","点评建议信息",$SYSTEM.SQL.GetROWID(),Description,"A")
	i RtnObj.success'=0 q RtnObj
	s RowId=$p(%ROWID,$c(1))
	s RtnObj.rowid=RowId
	q RtnObj
}

/// Descript:   更新点评建议
/// Creater:    wxj
/// CreateDate: 2019-10-17
/// Table:DHC_MatCNT_Advice
/// Input:代码,描述
/// Output:     
/// Return：RowId
ClassMethod Update(Params As %String) As RtnObj [ Private ]
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s RowId=PJObj.%Get("RowId")
	s Code=PJObj.%Get("Code")
	s Description=PJObj.%Get("Description")
	i (Code="")||(Description="")||(RowId="") d
	.s RtnObj.success=-1
	.s RtnObj.msg="必填项不可为空"
	q:RtnObj.success'=0 RtnObj
	s Tmpid=""
	&sql(select ID into:TmpId from DHC_MatCNT_Advice where MATCA_Code=:Code)
	i (TmpId'="")&&(TmpId'=RowId) d
	.s RtnObj.success=-5
	.s RtnObj.msg=Code_":代码重复"
	&sql(select ID into:TmpId from DHC_MatCNT_Advice where MATCA_Desc=:Description)
	i (TmpId'="")&&(TmpId'=RowId) d
	.s RtnObj.success=-6
	.s RtnObj.msg=Desc_":描述重复"
	Q:RtnObj.success'=0
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_Advice",RowId)
	&sql(Update DHC_MatCNT_Advice set MATCA_Code=:Code,MATCA_Desc=:Description where %ID=:RowId)
	i SQLCODE'=0 q RtnObj.Err(-1,RowId,"Update失败!",Params)
	s RtnObj=##class(Log).SaveLog("DHC_MatCNT_Advice","User.DHCMatCNTAdvice","点评建议信息",RowId,Description,"U","",OldJsonStr)
	q RtnObj
}

///  Descript:   删除点评建议
/// Creater:     wxj
/// CreateDate: 2019-10-17
/// Table:DHC_MatCNT_Advice
/// Input:RowId
/// Output:     
/// Return：0 – 成功，非0 ：失败
/// w ##class(web.DHCSTMHUI.CommentAdvice).Delete()
ClassMethod Delete(Params) As %Library.String
{
	n (Params,%session)
	s ^tempxj("Delete")=Params
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		i (RowId="") s Sc=RtnObj.Err(-2,"","没有需要删除信息!","",0)
		q:RtnObj.success'=0
		s JsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_MatCNT_Advice",RowId)
		&sql(Delete from DHC_MatCNT_Advice where %ID=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-3,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		e  d
		.s RtnObj=##class(Log).SaveLog("DHC_MatCNT_Advice","User.DHCMatCNTAdvice","点评建议信息",RowId,"","D",JsonStr)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	查询点评建议信息
/// Creater:	wxj
/// CreateDate:	2019-10-17
/// Table: DHC_MatCNT_Advice
/// Input:
/// Output:		
/// Return：点评建议信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CommentAdvice","SelectAll","","")
Query SelectAll() As Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "select ID as RowId, MATCA_Code as Code,MATCA_Desc as Description from DHC_MatCNT_Advice"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s RowId = Result.Data("RowId")
		CONTINUE:+RowId=0
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
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
