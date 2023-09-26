/// 查询日志类
Class DHCDoc.Log.Search Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = Search ]
{

/// 调用日志类
Property CallClass As %Library.String(MAXLEN = "", TRUNCATE = 1) [ Required ];

/// 调用日志方法
Property CallMethod As %Library.String(MAXLEN = "", TRUNCATE = 1) [ Required ];

/// 查询参数流
Property ArgsStream As %Library.GlobalCharacterStream;

/// 查询结果流
Property ResultStream As %Library.GlobalCharacterStream;

/// 备注
Property Remark As %Library.String(MAXLEN = 999, TRUNCATE = 1);

/// 系统日期
Property InsertDate As %Date [ InitialExpression = {+$h} ];

/// 系统时间
Property InsertTime As %Time [ InitialExpression = {$p($h,",",2)} ];

Index ClsMth On (CallClass As Exact, CallMethod As Exact);

Index InsertDate On (InsertDate As Exact, CallClass As Exact, CallMethod As Exact);

/// creator:郭荣勇
/// date:20170310
/// desc:一般性的通用日志
/// table:DHCDoc_Log.Search
/// input:Id 记录RowId(Id存在需更新,Id不存在则需插入),调用日志类,调用日志类方法,入参流,出参流,备注
/// output:
/// eg: d ##class(DHCDoc.Log.Search).General(Id,"web.DHCExamPatList","RegFindExecute",ArgsStream,ResultStream,"备注")
ClassMethod General(Id As %String, CallClass As %String, CallMethod As %String, ArgsStream As %GlobalCharacterStream, ResultStream As %GlobalCharacterStream, Remark As %String = "") As %String
{
	n (Id,CallClass,CallMethod,ArgsStream,ResultStream,Remark)
	s SQLCODE=0
	if Id="" {
		&sql(insert DHCDoc_Log.Search set 
	        CallClass=:CallClass,
	        CallMethod=:CallMethod,
	        ArgsStream=:ArgsStream,
	        ResultStream=:ResultStream,
	        Remark=:Remark)
	}else{
		&sql(update DHCDoc_Log.Search set 
	        CallClass=:CallClass,
	        CallMethod=:CallMethod,
	        ArgsStream=:ArgsStream,
	        ResultStream=:ResultStream,
	        Remark=:Remark where %ID=:Id)
	}
	; 日志记录失败记录
	if SQLCODE d code(SQLCODE)
	
	quit SQLCODE
code(SQLCODE) n cnt
	S cnt=$i(^DHCDoc.Log.SearchERR(0))
	S ^DHCDoc.Log.SearchERR(cnt)=SQLCODE_" "_$g(%mdiag(1))_" "_$g(%msg)_" "_$h
	S ^DHCDoc.Log.SearchERR("DATET",+$H,$P($H,",",2),cnt)=""
	Q
}

Storage Default
{
<Data name="SearchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CallClass</Value>
</Value>
<Value name="3">
<Value>CallMethod</Value>
</Value>
<Value name="4">
<Value>ArgsStream</Value>
</Value>
<Value name="5">
<Value>ResultStream</Value>
</Value>
<Value name="6">
<Value>InsertDate</Value>
</Value>
<Value name="7">
<Value>InsertTime</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.Log.SearchD</DataLocation>
<DefaultData>SearchDefaultData</DefaultData>
<IdLocation>^DHCDoc.Log.SearchD</IdLocation>
<IndexLocation>^DHCDoc.Log.SearchI</IndexLocation>
<StreamLocation>^DHCDoc.Log.SearchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
