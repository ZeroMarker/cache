Class User.CSSDCleanItmLocation Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_CleanItmLocation ]
{

/// 不合格部位编码
Property CSSDLocationCode As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CSSD_LocationCode ];

/// 不合格部位描述
Property CSSDLocationDesc As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSD_LocationDesc ];

Index CSSDLocationUniqueCode On CSSDLocationCode As Exact;

Storage Default
{
<Data name="CSSDCleanItmLocationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDLocationCode</Value>
</Value>
<Value name="3">
<Value>CSSDLocationDesc</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanItmLocationD</DataLocation>
<DefaultData>CSSDCleanItmLocationDefaultData</DefaultData>
<IdLocation>^User.CSSDCleanItmLocationD</IdLocation>
<IndexLocation>^User.CSSDCleanItmLocationI</IndexLocation>
<StreamLocation>^User.CSSDCleanItmLocationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
