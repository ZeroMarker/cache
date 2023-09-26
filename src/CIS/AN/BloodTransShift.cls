/// 血制品交接
Class CIS.AN.BloodTransShift Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodTransShift ]
{

/// 手术申请ID
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 2 ];

/// 输血记录
Property BloodBag As CIS.AN.BloodBag [ Required, SqlColumnNumber = 3 ];

/// 取血护士
Property FetchNurse As %String [ SqlColumnNumber = 4 ];

/// 巡回护士
Property CircualNurse As %String [ SqlColumnNumber = 5 ];

/// 取血护士与巡回护士交接日期
Property CirShiftDate As %Date [ SqlColumnNumber = 6 ];

/// 取血护士与巡回护士交接时间
Property CirShiftTime As %Time [ SqlColumnNumber = 7 ];

/// 弃血袋人
Property DiscardProv As %String [ SqlColumnNumber = 8 ];

/// 弃血袋日期
Property DiscardDate As %Date [ SqlColumnNumber = 9 ];

/// 弃血袋时间
Property DiscardTime As %Time [ SqlColumnNumber = 10 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 11 ];

/// 最后更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 12 ];

/// 最后更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 13 ];

/// 血液种类
Property BloodType As %String [ SqlColumnNumber = 14 ];

/// 输血科人员
Property TransProv As %String [ SqlColumnNumber = 15 ];

/// 输血科人员与取血护士交接日期
Property TransShiftDate As %Date [ SqlColumnNumber = 16 ];

/// 输血科人员与取血护士交接时间
Property TransShiftTime As %Time [ SqlColumnNumber = 17 ];

/// 核对者
Property CheckProv As %String [ SqlColumnNumber = 18 ];

/// 取血日期
Property FetchDate As %Date [ SqlColumnNumber = 19 ];

/// 取血时间
Property FetchTime As %Time [ SqlColumnNumber = 20 ];

/// 血袋索引
Index IBloodBag On BloodBag;

/// 取血日期索引
Index IFetchDate On FetchDate;

/// 血袋外键约束
ForeignKey FKBloodBag(BloodBag) References CIS.AN.BloodBag() [ OnDelete = cascade ];

Storage Default
{
<Data name="BloodTransShiftDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>BloodBag</Value>
</Value>
<Value name="3">
<Value>FetchNurse</Value>
</Value>
<Value name="4">
<Value>CircualNurse</Value>
</Value>
<Value name="5">
<Value>CirShiftDate</Value>
</Value>
<Value name="6">
<Value>CirShiftTime</Value>
</Value>
<Value name="7">
<Value>DiscardProv</Value>
</Value>
<Value name="8">
<Value>DiscardDate</Value>
</Value>
<Value name="9">
<Value>DiscardTime</Value>
</Value>
<Value name="10">
<Value>UpdateUser</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>UpdateTime</Value>
</Value>
<Value name="13">
<Value>BloodType</Value>
</Value>
<Value name="14">
<Value>TransProv</Value>
</Value>
<Value name="15">
<Value>TransShiftDate</Value>
</Value>
<Value name="16">
<Value>TransShiftTime</Value>
</Value>
<Value name="17">
<Value>CheckProv</Value>
</Value>
<Value name="18">
<Value>FetchDate</Value>
</Value>
<Value name="19">
<Value>FetchTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BloodTransShiftD</DataLocation>
<DefaultData>BloodTransShiftDefaultData</DefaultData>
<IdLocation>^CIS.AN.BloodTransShiftD</IdLocation>
<IndexLocation>^CIS.AN.BloodTransShiftI</IndexLocation>
<StreamLocation>^CIS.AN.BloodTransShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
