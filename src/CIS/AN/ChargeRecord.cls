/// 手术麻醉收费记录
Class CIS.AN.ChargeRecord Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ChargeRecord ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 2 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",初始化,修正,归档", MAXLEN = 2, VALUELIST = ",I,M,A") [ SqlColumnNumber = 3 ];

/// 创建用户
Property CreateUser As %String [ SqlColumnNumber = 4 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="ChargeRecordDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>CreateUser</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ChargeRecordD</DataLocation>
<DefaultData>ChargeRecordDefaultData</DefaultData>
<IdLocation>^CIS.AN.ChargeRecordD</IdLocation>
<IndexLocation>^CIS.AN.ChargeRecordI</IndexLocation>
<StreamLocation>^CIS.AN.ChargeRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
