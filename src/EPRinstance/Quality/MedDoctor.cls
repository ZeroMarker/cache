/// 质控医师维护表
Class EPRinstance.Quality.MedDoctor Extends %Persistent
{

Index IdxUserID On UserID;

Index IdxRange On Range;

/// 科室ID
Property LocID As %String;

/// 医师ID
Property UserID As %String;

/// 质控范围（门诊、在院、出院病历）
Property Range As %String;

/// 质控员等级（住院总-1、二级质控医师-2、三级质控医师-3、病历质量监管员-4、专项病历质控员-5）
Property Grade As %String;

/// 有效期开始时间
Property EffectiveStartDate As %String;

/// 有效期结束时间
Property EffectiveEndDate As %String;

Storage Default
{
<Data name="MedDoctorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserName</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>Grade</Value>
</Value>
<Value name="5">
<Value>EffectiveStartDate</Value>
</Value>
<Value name="6">
<Value>EffectiveEndDate</Value>
</Value>
<Value name="7">
<Value>Range</Value>
</Value>
<Value name="8">
<Value>LocID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.MedDoctorD</DataLocation>
<DefaultData>MedDoctorDefaultData</DefaultData>
<IdLocation>^DHCEPRQ.MedDoctorD</IdLocation>
<IndexLocation>^DHCEPRQ.MedDoctorI</IndexLocation>
<StreamLocation>^DHCEPRQ.MedDoctorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
