Class DHCEPRFS.SelfPrint.INST.TextCode Extends %Persistent
{

/// 短信验证码
Property Code As %String(TRUNCATE = 1);

/// 发送短信手机号
Property PhoneNo As %String(TRUNCATE = 1);

/// 身份证
Property IDCardNo As %String(TRUNCATE = 1);

/// 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// MRPatientID
Property MRPatientID As %String(TRUNCATE = 1);

/// IP
Property ClientIP As %String(TRUNCATE = 1);

/// 终端名
Property TerminalName As %String(TRUNCATE = 1);

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 服务器日期
Property ServerDate As %Date;

/// 服务器时间
Property ServerTime As %Time;

Storage Default
{
<Data name="TextCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>IDCardNo</Value>
</Value>
<Value name="4">
<Value>MedRecordNo</Value>
</Value>
<Value name="5">
<Value>MRPatientID</Value>
</Value>
<Value name="6">
<Value>ClientIP</Value>
</Value>
<Value name="7">
<Value>ServerDate</Value>
</Value>
<Value name="8">
<Value>ServerTime</Value>
</Value>
<Value name="9">
<Value>PhoneNo</Value>
</Value>
<Value name="10">
<Value>TerminalName</Value>
</Value>
<Value name="11">
<Value>RegNo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.SelfPrin4024.TextCodeD</DataLocation>
<DefaultData>TextCodeDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.SelfPrin4024.TextCodeD</IdLocation>
<IndexLocation>^DHCEPRFS.SelfPrin4024.TextCodeI</IndexLocation>
<StreamLocation>^DHCEPRFS.SelfPrin4024.TextCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
