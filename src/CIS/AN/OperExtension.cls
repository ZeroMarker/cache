/// 手麻信息扩展表
Class CIS.AN.OperExtension Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperExtension ]
{

Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 项目代码(请保存有意义的项目代码：英文单词或英文单词的组合)
Property ItemCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 项目描述
Property ItemDesc As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 4 ];

/// 项目值
Property ItemValue As %String(MAXLEN = 30000) [ SqlColumnNumber = 5 ];

/// 说明
Property ItemNote As %String(MAXLEN = 30000) [ SqlColumnNumber = 6 ];

Property UpdateDate As %Date [ SqlColumnNumber = 7 ];

Property UpdateTime As %Time [ SqlColumnNumber = 8 ];

Property UpdateUser As %String [ SqlColumnNumber = 9 ];

Index IOPS On OperSchedule;

Index ICode On (OperSchedule, ItemCode) [ Unique ];

Storage Default
{
<Data name="OperExtensionDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>ItemCode</Value>
</Value>
<Value name="3">
<Value>ItemDesc</Value>
</Value>
<Value name="4">
<Value>ItemValue</Value>
</Value>
<Value name="5">
<Value>ItemNote</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>UpdateTime</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperExtensionD</DataLocation>
<DefaultData>OperExtensionDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperExtensionD</IdLocation>
<IndexLocation>^CIS.AN.OperExtensionI</IndexLocation>
<StreamLocation>^CIS.AN.OperExtensionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
