/// 表单药品项目
Class CT.AN.DrugItem Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugItem ]
{

/// 数据项
Property DataItem As CT.AN.DataItem [ Required, SqlColumnNumber = 2 ];

/// 默认剂量单位
Property DoseUnit As CT.AN.Uom [ SqlColumnNumber = 3 ];

/// 默认剂量
Property DoseQty As %Float [ SqlColumnNumber = 4 ];

/// 浓度
Property Concentration As %Float [ SqlColumnNumber = 5 ];

/// 默认用药原因
Property Reason As %String [ SqlColumnNumber = 6 ];

/// 默认用药速度
Property Speed As %Float [ SqlColumnNumber = 7 ];

/// 默认用药速度
Property SpeedUnit As CT.AN.Uom [ SqlColumnNumber = 8 ];

/// 默认接收科室ID
Property RecvLocID As %String [ SqlColumnNumber = 9 ];

/// 用药时长
Property Duration As %Float [ SqlColumnNumber = 10 ];

/// HIS医嘱项ID
Property ArcimID As %String [ SqlColumnNumber = 11 ];

/// 麻醉药类型(毒麻药，精麻药，正常)
Property AnaDrugType As %String(DISPLAYLIST = ",毒麻药，精麻药，正常", VALUELIST = ",D,J,N") [ SqlColumnNumber = 12 ];

/// 默认浓度单位
Property ConcentrationUnit As CT.AN.Uom [ SqlColumnNumber = 13 ];

/// 默认用药途径
Property Instruction As CT.AN.Instruction [ SqlColumnNumber = 14 ];

/// 数据项索引
Index DataItem On DataItem;

/// 麻醉药类型索引
Index AnaDrugType On AnaDrugType;

/// 数据项外键约束
ForeignKey FKDataItem(DataItem) References CT.AN.DataItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="DrugItemDefaultData">
<Value name="1">
<Value>DataItem</Value>
</Value>
<Value name="2">
<Value>DoseUnit</Value>
</Value>
<Value name="3">
<Value>DoseQty</Value>
</Value>
<Value name="4">
<Value>Concentration</Value>
</Value>
<Value name="5">
<Value>Reason</Value>
</Value>
<Value name="6">
<Value>Speed</Value>
</Value>
<Value name="7">
<Value>SpeedUnit</Value>
</Value>
<Value name="8">
<Value>RecvLocID</Value>
</Value>
<Value name="9">
<Value>Duration</Value>
</Value>
<Value name="10">
<Value>ArcimID</Value>
</Value>
<Value name="11">
<Value>AnaDrugType</Value>
</Value>
<Value name="12">
<Value>ConcentrationUnit</Value>
</Value>
<Value name="13">
<Value>Instruction</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DrugItemD</DataLocation>
<DefaultData>DrugItemDefaultData</DefaultData>
<IdLocation>^CT.AN.DrugItemD</IdLocation>
<IndexLocation>^CT.AN.DrugItemI</IndexLocation>
<StreamLocation>^CT.AN.DrugItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
