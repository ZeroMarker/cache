/// 鉴定包额外元素
Class dbo.BTIDPLinkAddElement Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_LinkAddElement ]
{

Index IndexMaster On (IDPLinkDR, Sequence) [ SqlName = Index_Master, Type = index ];

Index IndexElement On (IDPLinkDR, IDPElementDR) [ SqlName = Index_Element, Type = index, Unique ];

/// Foreign Key FKBTIDPLinkAddElementIDPLinkDR created via DDL
ForeignKey FKBTIDPLinkAddElementIDPLinkDR(IDPLinkDR) References dbo.BTIDPLink(PKBTIDPLINK) [ SqlName = FK_BTIDPLinkAddElementIDPLinkDR ];

/// Foreign Key FKBTIDPLinkAddElementIDPElementDR created via DDL
ForeignKey FKBTIDPLinkAddElementIDPElementDR(IDPElementDR) References dbo.BTIDPElement(PKBTIDPELEMENT) [ SqlName = FK_BTIDPLinkAddElementIDPElementDR ];

/// DDL Primary Key Specification
Index PKBTIDPLINKADDELEMENT On RowID [ PrimaryKey, SqlName = PK_BTIDP_LINKADDELEMENT, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 关联
Property IDPLinkDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 鉴定元素
Property IDPElementDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTIDPLinkAddElementDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPLinkDR</Value>
</Value>
<Value name="3">
<Value>IDPElementDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPLinkAddElementD</DataLocation>
<DefaultData>BTIDPLinkAddElementDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPLinkAddElementD</IdLocation>
<IndexLocation>^dbo.BTIDPLinkAddElementI</IndexLocation>
<StreamLocation>^dbo.BTIDPLinkAddElementS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
