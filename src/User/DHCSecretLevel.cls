Class User.DHCSecretLevel Extends %Persistent [ SqlRowIdName = Level_RowId, SqlTableName = DHC_SecretLevel ]
{

Property LevelCode As %String [ Required, SqlFieldName = Level_Code ];

Property LevelDesc As %String [ Required, SqlFieldName = Level_Desc ];

/// 相应密级的特殊字符
Property LevelAlias As %String [ Required, SqlFieldName = Level_Alias ];

Index Code On LevelCode [ Unique ];

Index Alias On LevelAlias [ Unique ];

Storage Default
{
<Data name="DHCSecretLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LevelCode</Value>
</Value>
<Value name="3">
<Value>LevelDesc</Value>
</Value>
<Value name="4">
<Value>LevelAlias</Value>
</Value>
</Data>
<DataLocation>^User.DHCSecretLevelD</DataLocation>
<DefaultData>DHCSecretLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCSecretLevelD</IdLocation>
<IndexLocation>^User.DHCSecretLevelI</IndexLocation>
<StreamLocation>^User.DHCSecretLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
