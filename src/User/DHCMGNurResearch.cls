Class User.DHCMGNurResearch Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//护理科研成果

Property ResearchPer As User.DHCMGPersons;

Property ResearchDep As %String(TRUNCATE = 1);

//成果日期

Property ResearchDate As %Library.Date(FORMAT = 1);

//成果内容

Property ResearchContent As %String(TRUNCATE = 1);

//获奖等级

Property ResearchLevel As %String(TRUNCATE = 1);

//本人作用

Property ResearchSelFun As %String(TRUNCATE = 1);

//学分

Property ResearchPoint As %String(TRUNCATE = 1);

//学分分类

Property ResearchSign As %String(TRUNCATE = 1);

Index Per On ResearchPer;

Index DateDep On (ResearchDate, ResearchDep);

Storage Default
{
<Data name="DHCMGNurResearchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResearchContent</Value>
</Value>
<Value name="3">
<Value>ResearchDate</Value>
</Value>
<Value name="4">
<Value>ResearchDep</Value>
</Value>
<Value name="5">
<Value>ResearchLevel</Value>
</Value>
<Value name="6">
<Value>ResearchPer</Value>
</Value>
<Value name="7">
<Value>ResearchPoint</Value>
</Value>
<Value name="8">
<Value>ResearchSelFun</Value>
</Value>
<Value name="9">
<Value>ResearchSign</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurResearchD</DataLocation>
<DefaultData>DHCMGNurResearchDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurResearchD</IdLocation>
<IndexLocation>^User.DHCMGNurResearchI</IndexLocation>
<StreamLocation>^User.DHCMGNurResearchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
