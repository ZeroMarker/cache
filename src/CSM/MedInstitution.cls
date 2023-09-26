Class CSM.MedInstitution Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 级别
Property InstLevel As %String(MAXLEN = 20, TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 类型
Property Type As %String(MAXLEN = 20, TRUNCATE = 1);

Storage Default
{
<Data name="MedInstitutionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>InstLevel</Value>
</Value>
</Data>
<DataLocation>^CSM.MedInstitutionD</DataLocation>
<DefaultData>MedInstitutionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.MedInstitutionD</IdLocation>
<IndexLocation>^CSM.MedInstitutionI</IndexLocation>
<StreamLocation>^CSM.MedInstitutionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
