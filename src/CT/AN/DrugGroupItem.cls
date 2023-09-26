/// 药物组项目
Class CT.AN.DrugGroupItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugGroupItem ]
{

/// 数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 医嘱项ID
Property ArcimID As %String [ SqlColumnNumber = 3 ];

/// 剂量(每单位组药物)
Property Dose As %Float [ SqlColumnNumber = 4 ];

/// 剂量单位
Property DoseUnit As CT.AN.Uom [ SqlColumnNumber = 5 ];

/// 速度
Property Speed As %Float [ SqlColumnNumber = 6 ];

/// 速度单位
Property SpeedUnit As CT.AN.Uom [ SqlColumnNumber = 7 ];

/// 接收科室
Property RecvLocID As %String [ SqlColumnNumber = 8 ];

/// 是否溶剂
Property IsSolvent As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// 是否毒麻药
Property ToxicAnesthetic As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 10 ];

/// 数据项索引
Index IDataItem On DataItem;

/// 数据项外键约束
ForeignKey FKDataItem(DataItem) References CT.AN.DataItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="DrugGroupItemDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>ArcimID</Value>
</Value>
<Value name="3">
<Value>Dose</Value>
</Value>
<Value name="4">
<Value>DoseUnit</Value>
</Value>
<Value name="5">
<Value>Speed</Value>
</Value>
<Value name="6">
<Value>SpeedUnit</Value>
</Value>
<Value name="7">
<Value>RecvLocID</Value>
</Value>
<Value name="8">
<Value>IsSolvent</Value>
</Value>
<Value name="9">
<Value>ToxicAnesthetic</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DrugGroupItemD</DataLocation>
<DefaultData>DrugGroupItemDefaultData</DefaultData>
<IdLocation>^CT.AN.DrugGroupItemD</IdLocation>
<IndexLocation>^CT.AN.DrugGroupItemI</IndexLocation>
<StreamLocation>^CT.AN.DrugGroupItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
