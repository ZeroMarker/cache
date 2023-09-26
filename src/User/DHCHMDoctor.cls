Class User.DHCHMDoctor Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right ]
{

Parameter ClassName = "User.DHCHMDoctor";

Property DCode As User.SSUser [ Required ];

//Property DCode As %String [ Required ];

Index DCodeIndex On (Dtype, DCode) [ Unique ];

Property DDesc As %String(MAXLEN = 30);

Property DActive As %String;

Property Dtype As %String;

Property DRemark As %String(MAXLEN = 200);

Storage Default
{
<Data name="DHCHMDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DActive</Value>
</Value>
<Value name="3">
<Value>DCode</Value>
</Value>
<Value name="4">
<Value>DDesc</Value>
</Value>
<Value name="5">
<Value>DRemark</Value>
</Value>
<Value name="6">
<Value>Dtype</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMDoctorD</DataLocation>
<DefaultData>DHCHMDoctorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMDoctorD</IdLocation>
<IndexLocation>^User.DHCHMDoctorI</IndexLocation>
<StreamLocation>^User.DHCHMDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
