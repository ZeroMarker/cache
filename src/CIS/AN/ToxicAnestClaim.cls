/// 毒麻药领用登记明细
Class CIS.AN.ToxicAnestClaim Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ToxicAnestClaim ]
{

/// 领用登记记录
Property RegRecord As CIS.AN.ToxicAnestReg [ Required, SqlColumnNumber = 2 ];

/// 毒麻药数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 3 ];

/// 批次
Property Batch As %String [ SqlColumnNumber = 4 ];

/// 电子监管码
Property ElectronicCode As %String [ SqlColumnNumber = 5 ];

/// 规格
Property Specification As %String [ SqlColumnNumber = 6 ];

/// 剂量
Property Dose As %Float [ SqlColumnNumber = 7 ];

/// 剂量单位
Property DoseUnit As CT.AN.Uom [ SqlColumnNumber = 8 ];

/// 小包装单位
Property QtyUnit As CT.AN.Uom [ SqlColumnNumber = 9 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",请领,已领取,已使用,已退还", MAXLEN = 2, VALUELIST = ",A,C,U,R") [ SqlColumnNumber = 10 ];

/// 使用日期
Property UseDate As %Date [ SqlColumnNumber = 11 ];

/// 使用时间
Property UseTime As %Time [ SqlColumnNumber = 12 ];

/// 关联手术安排记录
Property RelatedOper As CIS.AN.OperSchedule [ SqlColumnNumber = 13 ];

/// 关联麻醉记录数据
Property RelatedData As CIS.AN.AnaData [ SqlColumnNumber = 14 ];

/// 退还日期
Property ReturnDate As %Date [ SqlColumnNumber = 15 ];

/// 退还时间
Property ReturnTime As %Time [ SqlColumnNumber = 16 ];

/// 毒麻药领用登记索引
Index IReg On RegRecord;

/// 数据项索引
Index IItem On DataItem;

/// 手术申请索引
Index IOper On RelatedOper;

/// 麻醉数据索引
Index IData On RelatedData;

/// 毒麻药领用登记外键约束
ForeignKey FKToxicAnestReg(RegRecord) References CIS.AN.ToxicAnestReg() [ OnDelete = cascade ];

Storage Default
{
<Data name="ToxicAnestClaimDefaultData">
<Value name="1">
<Value>RegRecord</Value>
</Value>
<Value name="2">
<Value>DataItem</Value>
</Value>
<Value name="3">
<Value>Batch</Value>
</Value>
<Value name="4">
<Value>ElectronicCode</Value>
</Value>
<Value name="5">
<Value>Specification</Value>
</Value>
<Value name="6">
<Value>Dose</Value>
</Value>
<Value name="7">
<Value>DoseUnit</Value>
</Value>
<Value name="8">
<Value>QtyUnit</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>UseDate</Value>
</Value>
<Value name="11">
<Value>UseTime</Value>
</Value>
<Value name="12">
<Value>RelatedOper</Value>
</Value>
<Value name="13">
<Value>RelatedData</Value>
</Value>
<Value name="14">
<Value>ReturnDate</Value>
</Value>
<Value name="15">
<Value>ReturnTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ToxicAnestClaimD</DataLocation>
<DefaultData>ToxicAnestClaimDefaultData</DefaultData>
<IdLocation>^CIS.AN.ToxicAnestClaimD</IdLocation>
<IndexLocation>^CIS.AN.ToxicAnestClaimI</IndexLocation>
<StreamLocation>^CIS.AN.ToxicAnestClaimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
