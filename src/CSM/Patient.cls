/// 病人表
Class CSM.Patient Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 年龄
Property Age As %Integer;

/// 病人在外部系统的ID
Property PatientID As %String(TRUNCATE = 1);

/// 出生日期
Property Birthday As %String(MAXLEN = 10, TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别
Property Gender As %String(MAXLEN = 2, TRUNCATE = 1);

/// 家庭住址
Property HomeAddr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 家庭电话
Property HomeTel As %String(MAXLEN = 30, TRUNCATE = 1);

/// 手机号码
Property MobileNo As %String(TRUNCATE = 1);

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Age</Value>
</Value>
<Value name="3">
<Value>Birthday</Value>
</Value>
<Value name="4">
<Value>Gender</Value>
</Value>
<Value name="5">
<Value>HomeAddr</Value>
</Value>
<Value name="6">
<Value>HomeTel</Value>
</Value>
<Value name="7">
<Value>MobileNo</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>PatientID</Value>
</Value>
</Data>
<DataLocation>^CSM.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.PatientD</IdLocation>
<IndexLocation>^CSM.PatientI</IndexLocation>
<StreamLocation>^CSM.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
