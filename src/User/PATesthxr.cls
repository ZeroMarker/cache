/// 病人信息表
Class User.PATesthxr Extends %Persistent [ SqlTableName = PA_Test ]
{

Property PARowId As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = PA_RowId ];

/// 病人姓名
Property PAName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PA_Name ];

/// 病人身份证号
Property PACardNo As %Integer [ SqlFieldName = PA_CardNo ];

/// 病人性别
Property PASexDr As User.CTSex [ SqlFieldName = PA_Sex_Dr ];

Storage Default
{
<Data name="PATesthxrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PARowId</Value>
</Value>
<Value name="3">
<Value>PAName</Value>
</Value>
<Value name="4">
<Value>PACardNo</Value>
</Value>
<Value name="5">
<Value>PASexDr</Value>
</Value>
</Data>
<DataLocation>^User.PATesthxrD</DataLocation>
<DefaultData>PATesthxrDefaultData</DefaultData>
<IdLocation>^User.PATesthxrD</IdLocation>
<IndexLocation>^User.PATesthxrI</IndexLocation>
<StreamLocation>^User.PATesthxrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
