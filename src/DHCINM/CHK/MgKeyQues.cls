/// Creater:wangpf
/// Descriptions:重点问题父表
/// Date:2021-12-26
Class DHCINM.CHK.MgKeyQues Extends %Persistent
{

Relationship ChildSub As DHCINM.CHK.MgKeyQuesSub [ Cardinality = children, Inverse = Parref ];

/// 类型
Property KeyQuesType As %String [ SqlColumnNumber = 2, SqlFieldName = KeyQuesType ];

/// 统计科室
Property KeyQuesLoc As %String [ SqlColumnNumber = 3, SqlFieldName = KeyQuesLoc ];

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

/// 片区
Property KeyQuesArea As %String [ SqlColumnNumber = 11, SqlFieldName = KeyQuesArea ];

Index date On KeyQuesStDate;

Storage Default
{
<Data name="MgKeyQuesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyQuesType</Value>
</Value>
<Value name="3">
<Value>KeyQuesLoc</Value>
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
<Value>KeyQuesArea</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgKeyQuesD</DataLocation>
<DefaultData>MgKeyQuesDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgKeyQuesD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgKeyQuesI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgKeyQuesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
