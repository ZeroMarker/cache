/// 微生物备注关联
Class dbo.BTMICRemarkLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_MICRemarkLinks ]
{

Index IndexMaster On (MICRemarkDR, OrganismDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexOrganism On (OrganismDR, MICRemarkDR) [ SqlName = Index_Organism, Type = index ];

/// Foreign Key FKBTMICRemarkLinksMICRemarkDR created via DDL
ForeignKey FKBTMICRemarkLinksMICRemarkDR(MICRemarkDR) References dbo.BTMICRemark(PKBTMICREMARK) [ SqlName = FK_BTMICRemarkLinksMICRemarkDR ];

/// Foreign Key FKBTMICRemarkLinksOrganismDR created via DDL
ForeignKey FKBTMICRemarkLinksOrganismDR(OrganismDR) References dbo.BTOrganism(PKBTORGANISM) [ SqlName = FK_BTMICRemarkLinksOrganismDR ];

/// DDL Primary Key Specification
Index PKBTMICREMARKLINKS On RowID [ PrimaryKey, SqlName = PK_BT_MICREMARKLINKS, Type = index, Unique ];

Index IndexMICRemarkDR On (MICRemarkDR, OrganismDR) [ SqlName = Index_MICRemarkDR, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 微生物备注
Property MICRemarkDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 关联细菌
Property OrganismDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 是否默认
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMICRemarkLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MICRemarkDR</Value>
</Value>
<Value name="3">
<Value>OrganismDR</Value>
</Value>
<Value name="4">
<Value>IsDefault</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICRemarkLinksD</DataLocation>
<DefaultData>BTMICRemarkLinksDefaultData</DefaultData>
<IdLocation>^dbo.BTMICRemarkLinksD</IdLocation>
<IndexLocation>^dbo.BTMICRemarkLinksI</IndexLocation>
<StreamLocation>^dbo.BTMICRemarkLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
