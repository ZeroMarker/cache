Class User.PDAMenuConfig Extends (%Persistent, User.Abstract) [ SqlRowIdName = PDAMC_RowId, SqlTableName = PDA_MenuConfig ]
{

/// 安全组
Property PDAMCGroupDr As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = PDAMC_Group_Dr ];

/// 菜单代码
Property PDAMCCode As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = PDAMC_Code ];

/// 菜单名称
Property PDAMCDesc As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = PDAMC_Desc ];

/// 启用标志
Property PDAMCActiveFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PDAMC_ActiveFlag ];

Index IndexPDAMCGroupDr On PDAMCGroupDr As Exact;

Storage Default
{
<Data name="PDAMenuConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PDAMCGroupDr</Value>
</Value>
<Value name="3">
<Value>PDAMCCode</Value>
</Value>
<Value name="4">
<Value>PDAMCDesc</Value>
</Value>
<Value name="5">
<Value>PDAMCActiveFlag</Value>
</Value>
</Data>
<DataLocation>^User.PDAMenuConfigD</DataLocation>
<DefaultData>PDAMenuConfigDefaultData</DefaultData>
<IdLocation>^User.PDAMenuConfigD</IdLocation>
<IndexLocation>^User.PDAMenuConfigI</IndexLocation>
<SqlRowIdName>PDAMC_RowId</SqlRowIdName>
<StreamLocation>^User.PDAMenuConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
