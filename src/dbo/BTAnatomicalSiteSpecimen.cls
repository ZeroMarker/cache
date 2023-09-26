/// 标本类型采集部位
Class dbo.BTAnatomicalSiteSpecimen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AnatomicalSiteSpecimen, StorageStrategy = Default ]
{

/// Foreign Key FKAnatomicalSite created via DDL
ForeignKey FKAnatomicalSite(AnatomicalSiteDR) References dbo.BTAnatomicalSite(PKBTANATOMICALSITE) [ SqlName = FK_AnatomicalSite ];

/// Foreign Key FKAnatomicalSiteSpecimen created via DDL
ForeignKey FKAnatomicalSiteSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_AnatomicalSiteSpecimen ];

Index IndexMaster On (AnatomicalSiteDR, SpecimenDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (AnatomicalSiteDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexSpecimen On (SpecimenDR, AnatomicalSiteDR) [ SqlName = Index_Specimen, Type = index ];

/// DDL Primary Key Specification
Index PKBTANATOMICALSITESPECIMEN On RowID [ PrimaryKey, SqlName = PK_BT_ANATOMICALSITESPECIMEN, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 采集部位  
Property AnatomicalSiteDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTAnatomicalSiteSpecimenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AnatomicalSiteDR</Value>
</Value>
<Value name="3">
<Value>SpecimenDR</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAnatomicalSiteSpecimenD</DataLocation>
<DefaultData>BTAnatomicalSiteSpecimenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAnatomicalSiteSpecimenD</IdLocation>
<IndexLocation>^dbo.BTAnatomicalSiteSpecimenI</IndexLocation>
<StreamLocation>^dbo.BTAnatomicalSiteSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
