Class User.PAAdmBMP Extends (%Persistent, %Populate) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property AdmissionDate As %Date;

Property DischargeDate As %Date;

Index AdmissionDateIndex On AdmissionDate [ Type = bitmap ];

Index DischargeDateIndex On DischargeDate [ Type = bitmap ];

Storage Default
{
<Data name="PAAdmBMPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmissionDate</Value>
</Value>
<Value name="3">
<Value>DischargeDate</Value>
</Value>
</Data>
<DataLocation>^PAADMXD</DataLocation>
<DefaultData>PAAdmBMPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^PAADMXD</IdLocation>
<IndexLocation>^PAADMXI</IndexLocation>
<StreamLocation>^User.PAAdmBMPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
