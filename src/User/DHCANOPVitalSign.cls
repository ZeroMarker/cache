Class User.DHCANOPVitalSign Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPVitalSign ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

// 心率

Property HR As %String;

// 血氧饱和度

Property SpO2 As %String;

// 脉搏

Property Pulse As %String;

// 呼吸频率

Property RR As %String;

// 体温 37.3～38℃为低热，38.1～39℃为中等度热，39.1～41℃为高热

Property Temp As %String;

// 口温

Property OralTemp As %String;

// 腋温

Property AxillaryTemp As %String;

// 腋温

Property AnalTemp As %String;

// 无创收缩压

Property NBPs As %String;

// 无创舒张压

Property NBPd As %String;

// 无创平均压

Property NBPm As %String;

// 有创收缩压

Property IBPs As %String;

// 有创舒张压

Property IBPd As %String;

// 有创平均压

Property IBPm As %String;

// 瞳孔 缩小;散大;大小不等;双侧散大对光反应消失

Property Pupil As %String;

// 角膜反射 直接与间接反射皆消失;直接反射消失;完全消失

Property CornealReflex As %String;

// 神志

Property Consciousness As %String;

// 身高

Property Hight As %String;

// 体重

Property Weight As %String;

// 血型

Property BloodType As %String;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

Storage Default
{
<Data name="DHCANOPVitalSignDefaultData">
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
<Value>HR</Value>
</Value>
<Value name="9">
<Value>SpO2</Value>
</Value>
<Value name="10">
<Value>Pulse</Value>
</Value>
<Value name="11">
<Value>RR</Value>
</Value>
<Value name="12">
<Value>Temp</Value>
</Value>
<Value name="13">
<Value>OralTemp</Value>
</Value>
<Value name="14">
<Value>AxillaryTemp</Value>
</Value>
<Value name="15">
<Value>AnalTemp</Value>
</Value>
<Value name="16">
<Value>NBPs</Value>
</Value>
<Value name="17">
<Value>NBPd</Value>
</Value>
<Value name="18">
<Value>NBPm</Value>
</Value>
<Value name="19">
<Value>IBPs</Value>
</Value>
<Value name="20">
<Value>IBPd</Value>
</Value>
<Value name="21">
<Value>IBPm</Value>
</Value>
<Value name="22">
<Value>Pupil</Value>
</Value>
<Value name="23">
<Value>CornealReflex</Value>
</Value>
<Value name="24">
<Value>Consciousness</Value>
</Value>
<Value name="25">
<Value>Hight</Value>
</Value>
<Value name="26">
<Value>Weight</Value>
</Value>
<Value name="27">
<Value>BloodType</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPVitalSignD</DataLocation>
<DefaultData>DHCANOPVitalSignDefaultData</DefaultData>
<IdLocation>^User.DHCANOPVitalSignD</IdLocation>
<IndexLocation>^User.DHCANOPVitalSignI</IndexLocation>
<StreamLocation>^User.DHCANOPVitalSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
