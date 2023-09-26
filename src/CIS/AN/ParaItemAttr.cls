/// 麻醉参数属性
Class CIS.AN.ParaItemAttr Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = ParaItemAttr ]
{

/// 模板项
Property ParaItem As CIS.AN.ParaItem [ Required, SqlColumnNumber = 2 ];

/// 显示单位
Property Unit As CT.AN.Uom [ SqlColumnNumber = 3 ];

/// 数据中剂量单位是否可见
Property DoseUnitVisible As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// 数据中速度单位是否可见
Property SpeedUnitVisible As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 数据中浓度是否可见
Property ConcentrationVisible As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];

/// 血型（输血项目使用）
Property BloodType As %String [ SqlColumnNumber = 7 ];

/// 是否停止采集
Property SuspendCollect As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 8 ];

/// 是否自动生成
Property AutoGenerate As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 9 ];

/// 自动生成值
Property DefaultValue As %String [ SqlColumnNumber = 10 ];

/// 浓度
Property Concentration As %Float [ SqlColumnNumber = 11 ];

/// 浓度单位
Property ConcentrationUnit As CT.AN.Uom [ SqlColumnNumber = 12 ];

/// 默认持续
Property Continuous As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 13 ];

/// 输液通路
Property Pathway As %String [ SqlColumnNumber = 14 ];

/// 备注
Property Note As %String [ SqlColumnNumber = 15 ];

/// 默认显示用法
Property InstructionVisible As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 16 ];

/// 默认持续分钟数
Property Duration As %String [ SqlColumnNumber = 17 ];

/// 默认用法
Property Instruction As CT.AN.Instruction [ SqlColumnNumber = 18 ];

Index IParaItem On ParaItem;

ForeignKey FKParaItem(ParaItem) References CIS.AN.ParaItem() [ OnDelete = cascade ];

Storage Default
{
<Data name="ParaItemAttrDefaultData">
<Value name="1">
<Value>ParaItem</Value>
</Value>
<Value name="2">
<Value>Unit</Value>
</Value>
<Value name="3">
<Value>DoseUnitVisible</Value>
</Value>
<Value name="4">
<Value>SpeedUnitVisible</Value>
</Value>
<Value name="5">
<Value>ConcentrationVisible</Value>
</Value>
<Value name="6">
<Value>BloodType</Value>
</Value>
<Value name="7">
<Value>SuspendCollect</Value>
</Value>
<Value name="8">
<Value>AutoGenerate</Value>
</Value>
<Value name="9">
<Value>DefaultValue</Value>
</Value>
<Value name="10">
<Value>Concentration</Value>
</Value>
<Value name="11">
<Value>ConcentrationUnit</Value>
</Value>
<Value name="12">
<Value>Continuous</Value>
</Value>
<Value name="13">
<Value>Pathway</Value>
</Value>
<Value name="14">
<Value>Note</Value>
</Value>
<Value name="15">
<Value>InstructionVisible</Value>
</Value>
<Value name="16">
<Value>Duration</Value>
</Value>
<Value name="17">
<Value>Instruction</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ParaItemAttrD</DataLocation>
<DefaultData>ParaItemAttrDefaultData</DefaultData>
<IdLocation>^CIS.AN.ParaItemAttrD</IdLocation>
<IndexLocation>^CIS.AN.ParaItemAttrI</IndexLocation>
<StreamLocation>^CIS.AN.ParaItemAttrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
