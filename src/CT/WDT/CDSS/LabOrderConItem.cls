/// Creator:谷雪萍
/// CreatDate:2020-06-15
/// Description：his检验医嘱和his检验项目（检验小项）关联表
/// Table：CT.WDT.CDSS.LabOrderConItem
Class CT.WDT.CDSS.LabOrderConItem Extends %Persistent
{

/// 检验小项代码
Property LabItemCode As %String [ Required ];

/// 检验小项描述
Property LabItemDesc As %String(MAXLEN = "") [ Required ];

/// 检验医嘱代码
Property LabOrderCode As %String(MAXLEN = "") [ Required ];

/// 检验医嘱描述
Property LabOrderDesc As %String(MAXLEN = "") [ Required ];

/// 医嘱开始日期
Property LabOrderStartDate As %Date;

/// 医嘱结束日期
Property LabOrderEndDate As %Date;

/// 对照开始日期
Property ConStartDate As %Date;

/// 对照结束日期
Property ConEndDate As %Date;

/// 所属医院
Property DictHosp As CT.WDT.CDSS.CustomerHosp [ Required ];

Index UniqueHospIndex On (LabItemCode As Exact, LabOrderCode As Exact, DictHosp As Exact);

Index ItemHospIndex On (LabItemCode As Exact, LabItemDesc As Exact, DictHosp As Exact);

Index OrderHospIndex On (LabOrderCode As Exact, LabOrderDesc As Exact, DictHosp As Exact);

Index ItemDescIndex On LabItemDesc As Exact;

Index OrderDescIndex On LabOrderDesc As Exact;

Storage Default
{
<Data name="LabOrderConItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabItemCode</Value>
</Value>
<Value name="3">
<Value>LabItemDesc</Value>
</Value>
<Value name="4">
<Value>LabOrderCode</Value>
</Value>
<Value name="5">
<Value>LabOrderDesc</Value>
</Value>
<Value name="6">
<Value>LabOrderStartDate</Value>
</Value>
<Value name="7">
<Value>LabOrderEndDate</Value>
</Value>
<Value name="8">
<Value>ConStartDate</Value>
</Value>
<Value name="9">
<Value>ConEndDate</Value>
</Value>
<Value name="10">
<Value>DictHosp</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.LabOrderConItemD</DataLocation>
<DefaultData>LabOrderConItemDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.LabOrderConItemD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.LabOrderConItemI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.LabOrderConItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
