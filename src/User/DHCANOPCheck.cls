Class User.DHCANOPCheck Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPCheck ]
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

// 心电图

Property EKG As %String;

// 超声心动图

Property Echocardiogram As %String;

// X光

Property XRay As %String;

// 超声波

Property ACT As %String;

// 血管超声波

Property Ultrsonic As %String;

// 血管造影

Property VascularUltrasonic As %String;

// 肺功能测试

Property PulmonaryFuncTest As %String;

// 心肺听诊

Property HeartLungAuscultation As %String;

// 胸片

Property CR As %String;

Storage Default
{
<Data name="DHCANOPCheckDefaultData">
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
<Value>EKG</Value>
</Value>
<Value name="9">
<Value>Echocardiogram</Value>
</Value>
<Value name="10">
<Value>XRay</Value>
</Value>
<Value name="11">
<Value>ACT</Value>
</Value>
<Value name="12">
<Value>Ultrsonic</Value>
</Value>
<Value name="13">
<Value>VascularUltrasonic</Value>
</Value>
<Value name="14">
<Value>PulmonaryFuncTest</Value>
</Value>
<Value name="15">
<Value>HeartLungAuscultation</Value>
</Value>
<Value name="16">
<Value>CR</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPCheckD</DataLocation>
<DefaultData>DHCANOPCheckDefaultData</DefaultData>
<IdLocation>^User.DHCANOPCheckD</IdLocation>
<IndexLocation>^User.DHCANOPCheckI</IndexLocation>
<StreamLocation>^User.DHCANOPCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
