Class User.DHCANOPAnScheme Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPAnScheme ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

// 麻醉方法

Property AnaestType As %String;

// 麻醉辅助措施

Property SpecificApply As %String;

// 监测项目

Property MonitorItem As %String;

// 术后镇痛

Property PostoperativeAnalgesia As %String;

// 计划

Property Plan As %String;

// 术前用药

Property PreMedicine As %String;

// 用药效果

Property MedicineEffect As %String;

Storage Default
{
<Data name="DHCANOPAnSchemeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeId</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>DataDate</Value>
</Value>
<Value name="5">
<Value>DataTime</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>UpdateTime</Value>
</Value>
<Value name="8">
<Value>AnaestType</Value>
</Value>
<Value name="9">
<Value>SpecificApply</Value>
</Value>
<Value name="10">
<Value>MonitorItem</Value>
</Value>
<Value name="11">
<Value>PostoperativeAnalgesia</Value>
</Value>
<Value name="12">
<Value>Plan</Value>
</Value>
<Value name="13">
<Value>PreMedicine</Value>
</Value>
<Value name="14">
<Value>MedicineEffect</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPAnSchemeD</DataLocation>
<DefaultData>DHCANOPAnSchemeDefaultData</DefaultData>
<IdLocation>^User.DHCANOPAnSchemeD</IdLocation>
<IndexLocation>^User.DHCANOPAnSchemeI</IndexLocation>
<StreamLocation>^User.DHCANOPAnSchemeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
