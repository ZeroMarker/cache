/// Creater:lulin
/// Descriptions:重点问题追踪
/// Date:2022-06-23
Class DHCINM.CHK.MgFocusQues Extends %Persistent
{

Relationship ChildSub As DHCINM.CHK.MgFocusQuesSub [ Cardinality = children, Inverse = Parref ];

/// 名称
Property KeyQuesDesc As %String [ SqlColumnNumber = 2, SqlFieldName = KeyQuesDesc ];

/// 表单
Property Qual As %String [ SqlColumnNumber = 3, SqlFieldName = Qual ];

/// 病区
Property KeyQuesWard As %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = KeyQuesWard ];

/// 开始日期
Property KeyQuesStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = KeyQuesStDate ];

/// 结束日期
Property KeyQuesEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = KeyQuesEndDate ];

/// 状态【N：保存，Y:提交，B:驳回，S:审核】
Property KeyQuesStatus As %String [ SqlColumnNumber = 7, SqlFieldName = KeyQuesStatus ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 8, SqlFieldName = Creator ];

/// 审核、驳回信息
Property RejectInfo As list Of %String [ SqlColumnNumber = 9, SqlFieldName = RejectInfo ];

/// 审核、驳回最后一人
Property RejectUser As %String [ SqlColumnNumber = 10, SqlFieldName = RejectUser ];

/// 错误率
Property KeyQuesRate As %String [ SqlColumnNumber = 11, SqlFieldName = KeyQuesRate ];

Index date On KeyQuesStDate;

Storage Default
{
<Data name="MgFocusQuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyQuesDesc</Value>
</Value>
<Value name="3">
<Value>Qual</Value>
</Value>
<Value name="4">
<Value>KeyQuesWard</Value>
</Value>
<Value name="5">
<Value>KeyQuesStDate</Value>
</Value>
<Value name="6">
<Value>KeyQuesEndDate</Value>
</Value>
<Value name="7">
<Value>KeyQuesStatus</Value>
</Value>
<Value name="8">
<Value>Creator</Value>
</Value>
<Value name="9">
<Value>RejectInfo</Value>
</Value>
<Value name="10">
<Value>RejectUser</Value>
</Value>
<Value name="11">
<Value>KeyQuesRate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgFocusQuesD</DataLocation>
<DefaultData>MgFocusQuesDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgFocusQuesD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgFocusQuesI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgFocusQuesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
