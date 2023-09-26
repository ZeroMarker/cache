/// 麻醉自费耗材
Class CIS.AN.SelfPaidMaterialData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = SelfPaidMaterialData ]
{

/// 表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 自费药品
Property SelfPaidMaterial As CF.AN.SelfPaidMaterial [ Required, SqlColumnNumber = 3 ];

/// 规格
Property Specification As %String [ SqlColumnNumber = 4 ];

/// 单价
Property Price As %Float [ SqlColumnNumber = 5 ];

/// 数量
Property Qty As %Integer [ SqlColumnNumber = 6 ];

/// 备注
Property Note As %String [ SqlColumnNumber = 7 ];

/// 用户ID
Property UpdateUserID As %String [ SqlColumnNumber = 8 ];

/// 数据更新日期
Property UpdateDate As %Date [ InitialExpression = {$piece($h,",",1)}, SqlColumnNumber = 9 ];

/// 数据更新时间
Property UpdateTime As %Time [ InitialExpression = {$piece($h,",",2)}, SqlColumnNumber = 10 ];

/// 手术麻醉记录表单索引
Index ISheet On RecordSheet;

/// 麻醉记录表单外键约束
ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="SelfPaidMaterialDataDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>SelfPaidMaterial</Value>
</Value>
<Value name="3">
<Value>Specification</Value>
</Value>
<Value name="4">
<Value>Price</Value>
</Value>
<Value name="5">
<Value>Qty</Value>
</Value>
<Value name="6">
<Value>Note</Value>
</Value>
<Value name="7">
<Value>UpdateUserID</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.SelfPaidMaterialDataD</DataLocation>
<DefaultData>SelfPaidMaterialDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.SelfPaidMaterialDataD</IdLocation>
<IndexLocation>^CIS.AN.SelfPaidMaterialDataI</IndexLocation>
<StreamLocation>^CIS.AN.SelfPaidMaterialDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
