/// 手术转运申请
Class CIS.AN.OperTransfer Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperTransfer ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 申请接病人日期
Property receiveAppDate As %String [ Required, SqlColumnNumber = 3 ];

/// 申请接病人时间
Property receiveAppTime As %String [ Required, SqlColumnNumber = 4 ];

/// 申请接病人申请人
Property receiveAppUser As %String [ SqlColumnNumber = 5 ];

/// 申请送病人日期
Property sendAppDate As %String(MAXLEN = 500) [ SqlColumnNumber = 6 ];

/// 申请送病人时间
Property sendAppTime As %String [ SqlColumnNumber = 7 ];

/// 申请送病人申请人
Property sendAppUser As %String [ SqlColumnNumber = 8 ];

/// 接病人日期
Property receiveDate As %String [ SqlColumnNumber = 9 ];

/// 接病人时间
Property receiveTime As %String [ SqlColumnNumber = 10 ];

/// 接病人操作人
Property receiveUser As %String [ SqlColumnNumber = 11 ];

/// 送病人日期
Property sendDate As %String [ SqlColumnNumber = 12 ];

/// 送病人时间
Property sendTime As %String [ SqlColumnNumber = 13 ];

/// 送病人操作人
Property sendUser As %String [ SqlColumnNumber = 14 ];

/// 接病人护工报到日期
Property receiveAssDate As %String [ SqlColumnNumber = 15 ];

/// 接病人护工报到
Property receiveAssTime As %String [ SqlColumnNumber = 16 ];

/// 入手术室日期
Property receiveBackDate As %String [ SqlColumnNumber = 17 ];

/// 入手术室时间
Property receiveBackTime As %String [ SqlColumnNumber = 18 ];

/// 送病人护工报到日期
Property sendBackDate As %String [ SqlColumnNumber = 19 ];

/// 送病人护工报到时间
Property sendAssTime As %String [ SqlColumnNumber = 20 ];

/// 出手术间时间
Property sendBackTime As %String [ SqlColumnNumber = 21 ];

/// 更新时间
Property UpdateTime As %String [ SqlColumnNumber = 22 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="OperTransferDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>receiveAppDate</Value>
</Value>
<Value name="3">
<Value>receiveAppTime</Value>
</Value>
<Value name="4">
<Value>receiveAppUser</Value>
</Value>
<Value name="5">
<Value>sendAppDate</Value>
</Value>
<Value name="6">
<Value>sendAppTime</Value>
</Value>
<Value name="7">
<Value>sendAppUser</Value>
</Value>
<Value name="8">
<Value>receiveDate</Value>
</Value>
<Value name="9">
<Value>receiveTime</Value>
</Value>
<Value name="10">
<Value>receiveUser</Value>
</Value>
<Value name="11">
<Value>sendDate</Value>
</Value>
<Value name="12">
<Value>sendTime</Value>
</Value>
<Value name="13">
<Value>sendUser</Value>
</Value>
<Value name="14">
<Value>receiveAssDate</Value>
</Value>
<Value name="15">
<Value>receiveAssTime</Value>
</Value>
<Value name="16">
<Value>receiveBackDate</Value>
</Value>
<Value name="17">
<Value>receiveBackTime</Value>
</Value>
<Value name="18">
<Value>sendBackDate</Value>
</Value>
<Value name="19">
<Value>sendAssTime</Value>
</Value>
<Value name="20">
<Value>sendBackTime</Value>
</Value>
<Value name="21">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperTransferD</DataLocation>
<DefaultData>OperTransferDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperTransferD</IdLocation>
<IndexLocation>^CIS.AN.OperTransferI</IndexLocation>
<StreamLocation>^CIS.AN.OperTransferS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
