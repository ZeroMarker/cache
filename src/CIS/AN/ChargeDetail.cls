/// 收费记录明细项
Class CIS.AN.ChargeDetail Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ChargeDetail ]
{

/// 记费登记单
Property ChargeRecord As CIS.AN.ChargeRecord [ Required, SqlColumnNumber = 2 ];

/// 记费项目
Property ChargeItem As CF.AN.ChargeItem [ SqlColumnNumber = 3 ];

/// 记费数量
Property Qty As %Float [ SqlColumnNumber = 4 ];

/// 记费单位
Property Unit As %String [ SqlColumnNumber = 5 ];

/// 单价
Property Price As %Float [ SqlColumnNumber = 6 ];

/// 记费剂量
Property PrescribedDose As %Float [ SqlColumnNumber = 7 ];

/// 实际剂量
Property ActualDose As %Float [ SqlColumnNumber = 8 ];

/// 剂量单位
Property DoseUnit As %String [ SqlColumnNumber = 9 ];

/// 审核用户
Property AuditUser As %String [ SqlColumnNumber = 13 ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 14 ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 15 ];

/// 更新用户
Property UpdateUser As %String [ SqlColumnNumber = 16 ];

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 17 ];

/// 更新时间
Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18 ];

/// 开单科室ID
Property BillDept As %String [ SqlColumnNumber = 19 ];

/// 执行科室ID
Property ExecDept As %String [ SqlColumnNumber = 20 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",未核实,核实,撤销,已收费,已退费,已删除", VALUELIST = ",N,A,C,F,R,D") [ SqlColumnNumber = 21 ];

/// 用户科室ID
Property UserDept As %String [ SqlColumnNumber = 22 ];

/// 收费日期
Property ChargeDate As %Date [ SqlColumnNumber = 25 ];

/// 收费时间
Property ChargeTime As %Time [ SqlColumnNumber = 26 ];

/// 收费人
Property ChargeUser As %String [ SqlColumnNumber = 27 ];

/// 条码号
Property BarCode As %String [ SqlColumnNumber = 28 ];

/// 用药途径
Property Instruction As CT.AN.Instruction [ SqlColumnNumber = 29 ];

/// 医嘱项ID
Property ArcimID As %String [ SqlColumnNumber = 30 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 31 ];

/// 医嘱项名称
Property ArcimDesc As %String [ SqlColumnNumber = 34 ];

/// 作废人
Property CancelUser As %String [ SqlColumnNumber = 35 ];

/// 作废日期
Property CancelDate As %Date [ SqlColumnNumber = 36 ];

/// 作废时间
Property CancelTime As %Time [ SqlColumnNumber = 37 ];

/// 医嘱优先级
Property Priority As %String [ SqlColumnNumber = 38 ];

/// 提醒数量
Property AlertQty As %String [ SqlColumnNumber = 39 ];

/// 关联的麻醉方法
Property AnaMethod As %String [ SqlColumnNumber = 40 ];

/// 关联的麻醉导管
Property Catheter As %String [ SqlColumnNumber = 41 ];

/// 收费记录索引
Index IChargeRecord On ChargeRecord;

/// 开单科室索引
Index IBillDept On BillDept;

/// 执行科室索引
Index IExecDept On ExecDept;

/// 用户科室索引
Index IUserDept On UserDept;

/// 收费项目索引
Index IChargeItem On ChargeItem;

/// 收费日期索引
Index IChargeDate On ChargeDate;

/// 审核日期索引
Index IAuditDate On AuditDate;

/// 条码号索引
Index IBarCode On BarCode;

/// 外部系统ID索引
Index IExt On ExternalID;

/// 收费日期、开发科室、医嘱项ID索引
Index IArcimDate On (ChargeDate, BillDept, ArcimID);

/// 收费记录、收费科室、医嘱项ID索引
Index IArcim On (ChargeRecord, BillDept, ArcimID);

/// 收费记录外键约束
ForeignKey FKChargeRecord(ChargeRecord) References CIS.AN.ChargeRecord() [ OnDelete = cascade ];

Storage Default
{
<Data name="ChargeDetailDefaultData">
<Value name="1">
<Value>ChargeRecord</Value>
</Value>
<Value name="2">
<Value>ChargeItem</Value>
</Value>
<Value name="3">
<Value>Qty</Value>
</Value>
<Value name="4">
<Value>Unit</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>PrescribedDose</Value>
</Value>
<Value name="7">
<Value>ActualDose</Value>
</Value>
<Value name="8">
<Value>DoseUnit</Value>
</Value>
<Value name="9">
<Value>AuditUser</Value>
</Value>
<Value name="10">
<Value>AuditDate</Value>
</Value>
<Value name="11">
<Value>AuditTime</Value>
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
<Value>BillDept</Value>
</Value>
<Value name="16">
<Value>ExecDept</Value>
</Value>
<Value name="17">
<Value>Status</Value>
</Value>
<Value name="18">
<Value>UserDept</Value>
</Value>
<Value name="19">
<Value>ChargeDate</Value>
</Value>
<Value name="20">
<Value>ChargeTime</Value>
</Value>
<Value name="21">
<Value>ChargeUser</Value>
</Value>
<Value name="22">
<Value>BarCode</Value>
</Value>
<Value name="23">
<Value>Instruction</Value>
</Value>
<Value name="24">
<Value>ArcimID</Value>
</Value>
<Value name="25">
<Value>ExternalID</Value>
</Value>
<Value name="26">
<Value>ArcimDesc</Value>
</Value>
<Value name="27">
<Value>CancelUser</Value>
</Value>
<Value name="28">
<Value>CancelDate</Value>
</Value>
<Value name="29">
<Value>CancelTime</Value>
</Value>
<Value name="30">
<Value>Priority</Value>
</Value>
<Value name="31">
<Value>AlertQty</Value>
</Value>
<Value name="32">
<Value>AnaMethod</Value>
</Value>
<Value name="33">
<Value>Catheter</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ChargeDetailD</DataLocation>
<DefaultData>ChargeDetailDefaultData</DefaultData>
<IdLocation>^CIS.AN.ChargeDetailD</IdLocation>
<IndexLocation>^CIS.AN.ChargeDetailI</IndexLocation>
<StreamLocation>^CIS.AN.ChargeDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
