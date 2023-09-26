Class User.DHCMGNurAntCat Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//消毒分类

Property AntCatName As %String(TRUNCATE = 1);

Property AntCatDesc As %String(TRUNCATE = 1);

Property AntCatIfPre As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Property AntCatMem As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCMGNurAntCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AntCatDesc</Value>
</Value>
<Value name="3">
<Value>AntCatIfPre</Value>
</Value>
<Value name="4">
<Value>AntCatMem</Value>
</Value>
<Value name="5">
<Value>AntCatName</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurAntCatD</DataLocation>
<DefaultData>DHCMGNurAntCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurAntCatD</IdLocation>
<IndexLocation>^User.DHCMGNurAntCatI</IndexLocation>
<StreamLocation>^User.DHCMGNurAntCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
