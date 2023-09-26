Class dbo.BTIDPColonyCountItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_ColonyCountItem ]
{

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTIDPCOLONYCOUNTITEM On RowID [ PrimaryKey, SqlName = PPK_BTIDP_COLONYCOUNTITEM, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 4 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTIDPColonyCountItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPColonyCountItemD</DataLocation>
<DefaultData>BTIDPColonyCountItemDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPColonyCountItemD</IdLocation>
<IndexLocation>^dbo.BTIDPColonyCountItemI</IndexLocation>
<StreamLocation>^dbo.BTIDPColonyCountItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
