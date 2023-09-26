Class User.DHCANOPShift Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPShift ]
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

// X、CT片

Property XCT As %String;

// 衣物

Property Clothes As %String;

// 贵重物品

Property Valuables As %String;

// 特殊用药

Property SpecialMedica As %String;

// 输血

Property BloodTrans As %String;

// 检查单

Property CheckList As %String;

// 穿刺

Property Puncture As %String;

// 导管情况

Property CatheterCondi As %String;

// 物品

Property Things As %String;

// 检查单X

Property CheckX As %String;

// 检查单CT\MRI

Property CheckCTMRI As %String;

// 检查单-其他

Property OtherCheckList As %String;

// 其他导管

Property OtherCatheter As %String;

// 引流

Property Drainage As %String;

// 其他

Property Others As %String;

Storage Default
{
<Data name="DHCANOPShiftDefaultData">
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
<Value>XCT</Value>
</Value>
<Value name="9">
<Value>Clothes</Value>
</Value>
<Value name="10">
<Value>Valuables</Value>
</Value>
<Value name="11">
<Value>SpecialMedica</Value>
</Value>
<Value name="12">
<Value>BloodTrans</Value>
</Value>
<Value name="13">
<Value>CheckList</Value>
</Value>
<Value name="14">
<Value>Puncture</Value>
</Value>
<Value name="15">
<Value>CatheterCondi</Value>
</Value>
<Value name="16">
<Value>Others</Value>
</Value>
<Value name="17">
<Value>Things</Value>
</Value>
<Value name="18">
<Value>X</Value>
</Value>
<Value name="19">
<Value>CheckCRMRI</Value>
</Value>
<Value name="20">
<Value>OtherCheckList</Value>
</Value>
<Value name="21">
<Value>OtherCatheter</Value>
</Value>
<Value name="22">
<Value>CheckX</Value>
</Value>
<Value name="23">
<Value>CheckCTMRI</Value>
</Value>
<Value name="24">
<Value>Drainage</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPShiftD</DataLocation>
<DefaultData>DHCANOPShiftDefaultData</DefaultData>
<IdLocation>^User.DHCANOPShiftD</IdLocation>
<IndexLocation>^User.DHCANOPShiftI</IndexLocation>
<StreamLocation>^User.DHCANOPShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
