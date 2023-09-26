Class CHSSWeb.HISInterface.PersonLifeStyleInfoData Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonLifeStyleInfo As list Of CHSSWeb.HISInterface.PersonLifeStyleInfo(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "EXPLICIT");

Storage Default
{
<Data name="PersonLifeStyleInfoDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonLifeStyleInfo</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonLifeSt90ED</DataLocation>
<DefaultData>PersonLifeStyleInfoDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonLifeSt90ED</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonLifeSt90EI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonLifeSt90ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
