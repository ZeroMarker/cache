Class DHCINM.HR.MgQualRegisted Extends %Persistent
{

/// 状态
Property RegistedStatus As %String [ SqlColumnNumber = 2, SqlFieldName = Registed_Status ];

/// 注册日期
Property RegistedDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Registed_Date ];

/// 证书附件 
Property CertPic As list Of %String(MAXLEN = 2000) [ SqlColumnNumber = 4, SqlFieldName = Registed_CertPic ];

/// 人员
Property RegistedPerson As %String [ SqlColumnNumber = 5, SqlFieldName = Registed_Person ];

/// 注册证书有效期
Property RegistedValidDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Registed_ValidDate ];

Index ssid On RegistedPerson;

Index Assid On (RegistedPerson, RegistedStatus);

Storage Default
{
<Data name="MgQualRegistedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegistedStatus</Value>
</Value>
<Value name="3">
<Value>RegistedDate</Value>
</Value>
<Value name="4">
<Value>CertPic</Value>
</Value>
<Value name="5">
<Value>RegistedPerson</Value>
</Value>
<Value name="6">
<Value>RegistedValidDate</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgQualRegistedD</DataLocation>
<DefaultData>MgQualRegistedDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgQualRegistedD</IdLocation>
<IndexLocation>^DHCINM.HR.MgQualRegistedI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgQualRegistedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
