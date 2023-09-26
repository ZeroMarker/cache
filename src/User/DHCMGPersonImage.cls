Class User.DHCMGPersonImage Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PersonDR As User.DHCMGPersons;

Property SignName As User.DHCMGCCode;

Property Mem As %String(TRUNCATE = 1);

//证书

Property Image As %Stream;

Property SignImage As %GlobalCharacterStream(LOCATION = "^User.DHCMGPersonImageS");

Index Person On PersonDR;

Method SaveStream(ByRef Itm As User.DHCMGPersonImage, str As %String) As %String
{
 //##class(
    
	d Itm.SignImage.Write(str)
	q 0
}

Storage Default
{
<Data name="DHCMGPersonImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonDR</Value>
</Value>
<Value name="3">
<Value>SignName</Value>
</Value>
<Value name="4">
<Value>Mem</Value>
</Value>
<Value name="5">
<Value>SignImage</Value>
</Value>
<Value name="6">
<Value>Image</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPersonImageD</DataLocation>
<DefaultData>DHCMGPersonImageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPersonImageD</IdLocation>
<IndexLocation>^User.DHCMGPersonImageI</IndexLocation>
<StreamLocation>^User.DHCMGPersonImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
