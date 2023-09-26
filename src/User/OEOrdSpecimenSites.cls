/// OrdSpecimenSites(2209)
Class User.OEOrdSpecimenSites Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdSpecimenSites, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SITEChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SPEC",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"SITE",0))}, SqlColumnNumber = 2, SqlFieldName = SITE_Childsub ];

/// Code
Property SITECode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SITE_Code ];

/// OE_OrdSpecimen Parent Reference
Relationship SITEParRef As OEOrdSpecimen [ Cardinality = parent, Inverse = ChildOEOrdSpecimenSites, Required, SqlFieldName = SITE_ParRef ];

Index RowIDBasedIDKeyIndex On SITEChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 137;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdSpecimenSites).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdSpecimenSites).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdSpecimenSites).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdSpecimenSites).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdSpecimenSites).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>137</ExtentSize>
<Property name="SITEChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SITECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SITEParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="SITE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OE_OrdSpecimen.SPEC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>SITE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SPEC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdSpecimen.SPEC_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"SITE"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SITE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SITE_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdSpecimenSitesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
