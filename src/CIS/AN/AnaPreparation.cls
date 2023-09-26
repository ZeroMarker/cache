/// 麻醉物品预约准备
Class CIS.AN.AnaPreparation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaPreparation ]
{

Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 2 ];

/// 麻醉医生用户ID
Property AnaDoctor As %String [ SqlColumnNumber = 3 ];

/// 目标日期
Property TargetDate As %Date [ SqlColumnNumber = 4 ];

/// 医嘱项ID
Property ArcimID As %String [ SqlColumnNumber = 5 ];

/// 数量
Property PackQty As %Float [ SqlColumnNumber = 6 ];

/// 单位
Property PackUom As CT.AN.Uom [ SqlColumnNumber = 7 ];

/// 用药途径
Property Instruction As %String [ SqlColumnNumber = 8 ];

/// 接收科室
Property RecvLoc As %String [ SqlColumnNumber = 9 ];

Property CreateUser As %String [ SqlColumnNumber = 10 ];

Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11 ];

Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12 ];

Property UpdateUser As %String [ SqlColumnNumber = 13 ];

Property UpdateDate As %Date [ SqlColumnNumber = 14 ];

Property UpdateTime As %Time [ SqlColumnNumber = 15 ];

/// 审核用户
Property AuditUser As %String [ SqlColumnNumber = 16 ];

Property AuditDate As %Date [ SqlColumnNumber = 17 ];

Property AuditTime As %Time [ SqlColumnNumber = 18 ];

/// 医护人员所在科室的ID
Property Dept As %String [ SqlColumnNumber = 19 ];

Property OrderSetItem As %String [ SqlColumnNumber = 20 ];

Property DoseQty As %Float [ SqlColumnNumber = 21 ];

Property DoseUom As CT.AN.Uom [ SqlColumnNumber = 22 ];

Property Freq As %String [ SqlColumnNumber = 23 ];

Property Duration As %String [ SqlColumnNumber = 24 ];

Property Status As %String(DISPLAYLIST = ",新建,提交,审核,作废", VALUELIST = ",N,S,A,C") [ SqlColumnNumber = 25 ];

Property OperRoom As CF.AN.Location [ SqlColumnNumber = 26 ];

Index OPS On OperSchedule;

Index DeptDate On (Dept, TargetDate);

/// 手术申请外键索引
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="AnaPreparationDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>AnaDoctor</Value>
</Value>
<Value name="3">
<Value>TargetDate</Value>
</Value>
<Value name="4">
<Value>ArcimID</Value>
</Value>
<Value name="5">
<Value>PackQty</Value>
</Value>
<Value name="6">
<Value>PackUom</Value>
</Value>
<Value name="7">
<Value>Instruction</Value>
</Value>
<Value name="8">
<Value>RecvLoc</Value>
</Value>
<Value name="9">
<Value>CreateUser</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
<Value name="12">
<Value>UpdateUser</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateTime</Value>
</Value>
<Value name="15">
<Value>AuditUser</Value>
</Value>
<Value name="16">
<Value>AuditDate</Value>
</Value>
<Value name="17">
<Value>AuditTime</Value>
</Value>
<Value name="18">
<Value>Dept</Value>
</Value>
<Value name="19">
<Value>OrderSetItem</Value>
</Value>
<Value name="20">
<Value>DoseQty</Value>
</Value>
<Value name="21">
<Value>DoseUom</Value>
</Value>
<Value name="22">
<Value>Freq</Value>
</Value>
<Value name="23">
<Value>Duration</Value>
</Value>
<Value name="24">
<Value>Status</Value>
</Value>
<Value name="25">
<Value>OperRoom</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AnaPreparationD</DataLocation>
<DefaultData>AnaPreparationDefaultData</DefaultData>
<IdLocation>^CIS.AN.AnaPreparationD</IdLocation>
<IndexLocation>^CIS.AN.AnaPreparationI</IndexLocation>
<StreamLocation>^CIS.AN.AnaPreparationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
