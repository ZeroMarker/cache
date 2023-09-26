Class User.DHCMGNurEducation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 继续教育
Property EduPer As User.DHCMGPersons;

Property EduDep As %String(TRUNCATE = 1);

Property EduDate As %Library.Date(FORMAT = 1);

//主办单位

Property EduUnit As %String(TRUNCATE = 1);

/// /项目名称
Property EduPrjName As %String(TRUNCATE = 1);

//项目等级

Property EduLevel As %String(TRUNCATE = 1);

//编号

Property EduPrjNo As %String(TRUNCATE = 1);

//学分

Property EduPoint As %String(TRUNCATE = 1);

Index nur On EduPer;

Storage Default
{
<Data name="DHCMGNurEducationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EduDate</Value>
</Value>
<Value name="3">
<Value>EduDep</Value>
</Value>
<Value name="4">
<Value>EduLevel</Value>
</Value>
<Value name="5">
<Value>EduPer</Value>
</Value>
<Value name="6">
<Value>EduPoint</Value>
</Value>
<Value name="7">
<Value>EduPrjName</Value>
</Value>
<Value name="8">
<Value>EduPrjNo</Value>
</Value>
<Value name="9">
<Value>EduUnit</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurEducationD</DataLocation>
<DefaultData>DHCMGNurEducationDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurEducationD</IdLocation>
<IndexLocation>^User.DHCMGNurEducationI</IndexLocation>
<StreamLocation>^User.DHCMGNurEducationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
