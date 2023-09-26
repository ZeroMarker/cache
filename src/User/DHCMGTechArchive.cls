Class User.DHCMGTechArchive Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property dep As %String(TRUNCATE = 1);

Property pers As User.DHCMGPersons;

Property arctyp As User.DHCMGCCode;

Property arcdate As %Library.Date(FORMAT = 1);

Property arcsign As %String(TRUNCATE = 1);

Property arcpoint As %String(TRUNCATE = 1);

Property arccontent As %String(TRUNCATE = 1);

Property arcpro As User.DHCMGTechArcProVal;

Index datedep On (arcdate, dep);

Index depper On (dep, pers);

Storage Default
{
<Data name="DHCMGTechArchiveDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>arcdate</Value>
</Value>
<Value name="3">
<Value>arcpro</Value>
</Value>
<Value name="4">
<Value>dep</Value>
</Value>
<Value name="5">
<Value>pers</Value>
</Value>
<Value name="6">
<Value>arcpoint</Value>
</Value>
<Value name="7">
<Value>arcsign</Value>
</Value>
<Value name="8">
<Value>arctyp</Value>
</Value>
<Value name="9">
<Value>arccontent</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGTechArchiveD</DataLocation>
<DefaultData>DHCMGTechArchiveDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGTechArchiveD</IdLocation>
<IndexLocation>^User.DHCMGTechArchiveI</IndexLocation>
<StreamLocation>^User.DHCMGTechArchiveS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
