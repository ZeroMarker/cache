/// Creator:丁亚男
/// CreatDate:2021-10-14
/// Description：评估表关联评估结果条件设置表
/// Table：CT.WDT.MKB.AssConResCondi
Class CT.WDT.CDSS.AssConResCondi Extends (%Persistent, User.Abstract)
{

/// 评估表指针
Property AssDR As CT.WDT.CDSS.AssBase [ Required ];

/// 类型（总分、结论、描述）
Property DataType As %String;

/// 计算方式（累加、平均值、最大值、最小值、公式、特殊）
Property CalculateMethod As %String(MAXLEN = "");

/// 公式/特殊条件
Property CondiContent As %String(MAXLEN = "");

/// 显示内容
Property ShowContent As %String(MAXLEN = "");

/// 备注
Property Remark As %String(MAXLEN = "");

Index AssIndex On AssDR;

Index AssTypeIndex On (AssDR, DataType As Exact);

Index AssCalMetIndex On (AssDR, DataType As Exact, CalculateMethod As Exact);

Storage Default
{
<Data name="AssConResCondiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssDR</Value>
</Value>
<Value name="3">
<Value>DataType</Value>
</Value>
<Value name="4">
<Value>CalculateMethod</Value>
</Value>
<Value name="5">
<Value>CondiContent</Value>
</Value>
<Value name="6">
<Value>ShowContent</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssConResCondiD</DataLocation>
<DefaultData>AssConResCondiDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssConResCondiD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssConResCondiI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssConResCondiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
