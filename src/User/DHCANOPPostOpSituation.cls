/// 术后情况
Class User.DHCANOPPostOpSituation Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPPostOpSituation ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

// 医院

Property Hospital As %String;

// 送往场所

Property SendPlace As %String;

// 其他

Property Others As %String;

// 意识

Property Consciousness As %String;

// 气管导管

Property Trachea As %String;

Index arrangeIdIndex On ArrangeId;

Index typeIndex On (Type, ArrangeId);

Index DateTimeIndex On (DataDate, DataTime, ArrangeId);

Index TypeDateTimeIndex On (Type, DataDate, DataTime, ArrangeId);

Storage Default
{
<Data name="DHCANOPPostOpSituationDefaultData">
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
<Value>Hospital</Value>
</Value>
<Value name="9">
<Value>SendPlace</Value>
</Value>
<Value name="10">
<Value>Others</Value>
</Value>
<Value name="11">
<Value>Consciousness</Value>
</Value>
<Value name="12">
<Value>Trachea</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPPostOpSituationD</DataLocation>
<DefaultData>DHCANOPPostOpSituationDefaultData</DefaultData>
<IdLocation>^User.DHCANOPPostOpSituationD</IdLocation>
<IndexLocation>^User.DHCANOPPostOpSituationI</IndexLocation>
<StreamLocation>^User.DHCANOPPostOpSituationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
