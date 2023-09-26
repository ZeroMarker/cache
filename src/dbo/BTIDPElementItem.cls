/// 鉴定元素选项
Class dbo.BTIDPElementItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_ElementItem ]
{

Index IndexMaster On (IDPElementDR, Sequence) [ SqlName = Index_Master, Type = index ];

Index IndexCode On (IDPElementDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

/// Foreign Key FKBTIDPElementItemIDPElementDR created via DDL
ForeignKey FKBTIDPElementItemIDPElementDR(IDPElementDR) References dbo.BTIDPElement(PKBTIDPELEMENT) [ SqlName = FK_BTIDPElementItemIDPElementDR ];

/// DDL Primary Key Specification
Index PKBTIDPELEMENTITEM On RowID [ PrimaryKey, SqlName = PK_BTIDP_ELEMENTITEM, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定元素
Property IDPElementDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ Required, SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTIDPElementItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPElementDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPElementItemD</DataLocation>
<DefaultData>BTIDPElementItemDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPElementItemD</IdLocation>
<IndexLocation>^dbo.BTIDPElementItemI</IndexLocation>
<StreamLocation>^dbo.BTIDPElementItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
