Class User.PATestJML Extends %Persistent [ SqlRowIdName = PA_RowID, SqlTableName = PA_TestJML ]
{

Property PAName As %String [ SqlColumnNumber = 2, SqlFieldName = PA_Name ];

Property PACardNo As %Integer [ SqlColumnNumber = 3, SqlFieldName = PA_CardNo ];

Property PASexDr As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = PA_Sex_Dr ];

Storage Default
{
<Data name="PATestJMLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAName</Value>
</Value>
<Value name="3">
<Value>PACardNo</Value>
</Value>
<Value name="4">
<Value>PASexDr</Value>
</Value>
</Data>
<DataLocation>^User.PATestJMLD</DataLocation>
<DefaultData>PATestJMLDefaultData</DefaultData>
<IdLocation>^User.PATestJMLD</IdLocation>
<IndexLocation>^User.PATestJMLI</IndexLocation>
<StreamLocation>^User.PATestJMLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
