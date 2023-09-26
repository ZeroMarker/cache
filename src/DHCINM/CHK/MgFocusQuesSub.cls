Class DHCINM.CHK.MgFocusQuesSub Extends %Persistent
{

Relationship Parref As DHCINM.CHK.MgFocusQues [ Cardinality = parent, Inverse = ChildSub ];

/// 描述
Property QuesDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = QuesDesc ];

/// 质控外键
Property QualSubID As %String [ SqlColumnNumber = 3, SqlFieldName = QuesType ];

/// 复查结果
Property Result As %String [ SqlColumnNumber = 4, SqlFieldName = Result ];

/// 复查备注
Property Remark As %String [ SqlColumnNumber = 5, SqlFieldName = Remark ];

/// 检查总数
Property CheckNum As %String [ SqlColumnNumber = 6, SqlFieldName = CheckNum ];

/// 错误数
Property ErrNum As %String [ SqlColumnNumber = 7, SqlFieldName = ErrNum ];

/// 错误率
Property ErrRate As %String [ SqlColumnNumber = 8, SqlFieldName = ErrRate ];

Storage Default
{
<Data name="MgFocusQuesSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QuesDesc</Value>
</Value>
<Value name="3">
<Value>QualSubID</Value>
</Value>
<Value name="4">
<Value>Result</Value>
</Value>
<Value name="5">
<Value>Remark</Value>
</Value>
<Value name="6">
<Value>CheckNum</Value>
</Value>
<Value name="7">
<Value>ErrNum</Value>
</Value>
<Value name="8">
<Value>ErrRate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgFocusQuesSubD</DataLocation>
<DefaultData>MgFocusQuesSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.CHK.MgFocusQuesSubI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgFocusQuesSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
