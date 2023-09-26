Class DHCEPRFS.ThirdParty.INST.Err3rdCreateLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 病人号	
Property PatientID As %String [ SqlColumnNumber = 2 ];

/// 就诊号	
Property EpisodeID As %String [ SqlColumnNumber = 3 ];

/// 记录日期
Property RegDate As %Date [ SqlColumnNumber = 4 ];

/// 记录时间
Property RegTime As %Time [ SqlColumnNumber = 5 ];

/// 服务器IP
Property IP As %String [ SqlColumnNumber = 6 ];

/// 第三方FTP路径	
Property FTPPathSXML As %String(MAXLEN = 200000, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 项目编码
Property TypeCode As %String [ SqlColumnNumber = 8 ];

/// 有问题PDF路径
Property OneFTPPath As %String(MAXLEN = 200000, TRUNCATE = 1) [ SqlColumnNumber = 9 ];

/// 病案号	
Property MedRecordNo As %String [ SqlColumnNumber = 10 ];

/// 错误类型
/// NOTEXIST--不存在    ERROR--存在但报错
Property ErrorType As %String [ SqlColumnNumber = 11 ];

Index IdxMain On (RegDate, RegTime);

Storage Default
{
<Data name="Err3rdCreateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>RegDate</Value>
</Value>
<Value name="5">
<Value>RegTime</Value>
</Value>
<Value name="6">
<Value>IP</Value>
</Value>
<Value name="7">
<Value>FTPPathSXML</Value>
</Value>
<Value name="8">
<Value>TypeCode</Value>
</Value>
<Value name="9">
<Value>OneFTPPath</Value>
</Value>
<Value name="10">
<Value>MedRecordNo</Value>
</Value>
<Value name="11">
<Value>ErrorType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.Err3rdCreateLogD</DataLocation>
<DefaultData>Err3rdCreateLogDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.Err3rdCreateLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.Err3rdCreateLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.Err3rdCreateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
