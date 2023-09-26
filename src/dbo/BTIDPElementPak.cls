/// 鉴定元素包项
Class dbo.BTIDPElementPak Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_PakElement ]
{

Index IndexMaster On (IDPPakDR, IDPElementDR) [ SqlName = Index_Master, Type = index ];

Index IndexSequence On (IDPPakDR, ParentDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTIDPElementPakIDPPakDR created via DDL
ForeignKey FKBTIDPElementPakIDPPakDR(IDPPakDR) References dbo.BTIDPPak(PKBTIDPPAK) [ SqlName = FK_BTIDPElementPakIDPPakDR ];

/// Foreign Key FKBTIDPElementPakIDPElementDR created via DDL
ForeignKey FKBTIDPElementPakIDPElementDR(IDPElementDR) References dbo.BTIDPElement(PKBTIDPELEMENT) [ SqlName = FK_BTIDPElementPakIDPElementDR ];

/// Foreign Key FKBTIDPElementPakParentDR created via DDL
ForeignKey FKBTIDPElementPakParentDR(ParentDR) References dbo.BTIDPElementPak(PKBTIDPELEMENTPAK) [ SqlName = FK_BTIDPElementPakParentDR ];

/// DDL Primary Key Specification
Index PKBTIDPELEMENTPAK On RowID [ PrimaryKey, SqlName = PK_BTIDP_PAKELEMENT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定元素包
Property IDPPakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 鉴定元素
Property IDPElementDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 默认结果
Property DefaultResult As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 父节点
Property ParentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTIDPElementPakDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPPakDR</Value>
</Value>
<Value name="3">
<Value>IDPElementDR</Value>
</Value>
<Value name="4">
<Value>DefaultResult</Value>
</Value>
<Value name="5">
<Value>ParentDR</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPElementPakD</DataLocation>
<DefaultData>BTIDPElementPakDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPElementPakD</IdLocation>
<IndexLocation>^dbo.BTIDPElementPakI</IndexLocation>
<StreamLocation>^dbo.BTIDPElementPakS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
