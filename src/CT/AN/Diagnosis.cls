Class CT.AN.Diagnosis Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Diagnosis ]
{

/// 诊断代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 诊断描述
Property Description As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 诊断别名
Property ShortDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// ICD9编码
Property ICD9CMCode As %String [ SqlColumnNumber = 5 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

/// 激活标志
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 8 ];

/// 开始年龄
Property AgeFrom As %String [ SqlColumnNumber = 9 ];

/// 结束年龄
Property AgeTo As %String [ SqlColumnNumber = 10 ];

/// 性别
Property Gender As %String [ SqlColumnNumber = 11 ];

/// 拼音码
Property Alias As %String(MAXLEN = 200) [ SqlColumnNumber = 12 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 13 ];

/// 激活标志索引
Index IActive On Active;

/// ICD编码索引
Index ICDCode On ICD9CMCode;

/// 外部系统ID索引
Index IExt On ExternalID;

Storage Default
{
<Data name="DiagnosisDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ShortDesc</Value>
</Value>
<Value name="4">
<Value>ICD9CMCode</Value>
</Value>
<Value name="5">
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>AgeFrom</Value>
</Value>
<Value name="9">
<Value>AgeTo</Value>
</Value>
<Value name="10">
<Value>Gender</Value>
</Value>
<Value name="11">
<Value>Alias</Value>
</Value>
<Value name="12">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DiagnosisD</DataLocation>
<DefaultData>DiagnosisDefaultData</DefaultData>
<IdLocation>^CT.AN.DiagnosisD</IdLocation>
<IndexLocation>^CT.AN.DiagnosisI</IndexLocation>
<StreamLocation>^CT.AN.DiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
