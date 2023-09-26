/// 术后随访明细
Class CIS.AN.OperFollowupDetails Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperFollowupDetails ]
{

/// 手术麻醉表单
Property FollowupSheet As CIS.AN.OperFollowup [ Required, SqlColumnNumber = 2 ];

/// 数据项
Property DataItem As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 数据值
Property DataValue As %String(MAXLEN = 2000) [ SqlColumnNumber = 4 ];

/// 数据的执行日期
Property ExecDate As %Date [ SqlColumnNumber = 5 ];

/// 数据执行时间
Property ExecTime As %Time [ SqlColumnNumber = 6 ];

/// 数据更新用户ID
Property UpdateUserID As %String [ SqlColumnNumber = 7 ];

/// 数据更新日期
Property UpdateDate As %Date [ InitialExpression = {$piece($h,",",1)}, SqlColumnNumber = 8 ];

/// 数据更新时间
Property UpdateTime As %Time [ InitialExpression = {$piece($h,",",2)}, SqlColumnNumber = 9 ];

/// 分数值
Property DataScore As %String [ SqlColumnNumber = 10 ];

/// 数据说明
Property DataNote As %String [ SqlColumnNumber = 11 ];

Index ISheet On FollowupSheet;

Index ICode On (FollowupSheet, DataItem) [ Unique ];

ForeignKey FKRecordSheet(FollowupSheet) References CIS.AN.OperFollowup() [ OnDelete = cascade ];

Storage Default
{
<Data name="OperFollowupDetailsDefaultData">
<Value name="1">
<Value>FollowupSheet</Value>
</Value>
<Value name="2">
<Value>DataItem</Value>
</Value>
<Value name="3">
<Value>DataValue</Value>
</Value>
<Value name="4">
<Value>ExecDate</Value>
</Value>
<Value name="5">
<Value>ExecTime</Value>
</Value>
<Value name="6">
<Value>UpdateUserID</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>DataScore</Value>
</Value>
<Value name="10">
<Value>DataNote</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperFollowupDetailsD</DataLocation>
<DefaultData>OperFollowupDetailsDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperFollowupDetailsD</IdLocation>
<IndexLocation>^CIS.AN.OperFollowupDetailsI</IndexLocation>
<StreamLocation>^CIS.AN.OperFollowupDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
