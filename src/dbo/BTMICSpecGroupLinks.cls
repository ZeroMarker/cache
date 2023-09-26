/// 微生物标本组关联
Class dbo.BTMICSpecGroupLinks Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMIC_SpecGroupLinks ]
{

/// Foreign Key FKBTMICSpecGroupLinksMICSpecGroupDR created via DDL
ForeignKey FKBTMICSpecGroupLinksMICSpecGroupDR(MICSpecGroupDR) References dbo.BTMICSpecGroup(PKBTMICSPECGROUP) [ SqlName = FK_BTMICSpecGroupLinksMICSpecGroupDR ];

/// Foreign Key FKBTMICSpecGroupLinksSpecimenDR created via DDL
ForeignKey FKBTMICSpecGroupLinksSpecimenDR(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_BTMICSpecGroupLinksSpecimenDR ];

/// DDL Primary Key Specification
Index PKBTMICSPECGROUPLINKS On RowID [ PrimaryKey, SqlName = PK_BTMIC_SPECGROUPLINKS, Type = index, Unique ];

Index IndexMaster On (MICSpecGroupDR, SpecimenDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSpecimen On (SpecimenDR, MICSpecGroupDR) [ SqlName = Index_Specimen, Type = index ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本组
Property MICSpecGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 标本类型
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTMICSpecGroupLinksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MICSpecGroupDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMICSpecGroupLinksD</DataLocation>
<DefaultData>BTMICSpecGroupLinksDefaultData</DefaultData>
<IdLocation>^dbo.BTMICSpecGroupLinksD</IdLocation>
<IndexLocation>^dbo.BTMICSpecGroupLinksI</IndexLocation>
<StreamLocation>^dbo.BTMICSpecGroupLinksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
