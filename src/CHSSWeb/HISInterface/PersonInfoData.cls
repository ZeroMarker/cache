Class CHSSWeb.HISInterface.PersonInfoData Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonInfo As list Of CHSSWeb.HISInterface.PersonInfo(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "EXPLICIT");

Storage Default
{
<Data name="PersonInfoDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonInfo</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HISI6F2.PersonInfoDataD</DataLocation>
<DefaultData>PersonInfoDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HISI6F2.PersonInfoDataD</IdLocation>
<IndexLocation>^CHSSWeb.HISI6F2.PersonInfoDataI</IndexLocation>
<StreamLocation>^CHSSWeb.HISI6F2.PersonInfoDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
