Class CIS.AN.PACUTransaction Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PACUTransaction ]
{

/// 手术
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 描述
Property Description As %String [ SqlColumnNumber = 3 ];

/// 开始日期时间
Property StartDT As %TimeStamp [ SqlColumnNumber = 4 ];

/// 结束日期时间
Property EndDT As %TimeStamp [ SqlColumnNumber = 5 ];

/// 前一个位置
Property FormerLoc As CF.AN.Location [ SqlColumnNumber = 6 ];

/// 目标位置
Property TargetLoc As CF.AN.Location [ SqlColumnNumber = 7 ];

/// 原因
Property Reason As %String [ SqlColumnNumber = 8 ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 9 ];

/// 更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 10 ];

/// 更新人
Property UpdateUser As %String [ SqlColumnNumber = 11 ];

Index Oper On OperSchedule;

ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="PACUTransactionDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>StartDT</Value>
</Value>
<Value name="4">
<Value>EndDT</Value>
</Value>
<Value name="5">
<Value>FormerLoc</Value>
</Value>
<Value name="6">
<Value>TargetLoc</Value>
</Value>
<Value name="7">
<Value>Reason</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PACUTransactionD</DataLocation>
<DefaultData>PACUTransactionDefaultData</DefaultData>
<IdLocation>^CIS.AN.PACUTransactionD</IdLocation>
<IndexLocation>^CIS.AN.PACUTransactionI</IndexLocation>
<StreamLocation>^CIS.AN.PACUTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
