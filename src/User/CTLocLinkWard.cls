/// LocLinkLocation(2087)
Class User.CTLocLinkWard Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_LocLinkWard, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property LINKPACWardDR As PACWard [ SqlColumnNumber = 3, SqlFieldName = LINK_PACWard_DR ];

/// Childsub
Property LINKChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LINK",0))}, SqlColumnNumber = 2, SqlFieldName = LINK_Childsub ];

/// CT_Loc Parent Reference
Relationship LINKWardParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocLinkWard, Required, SqlFieldName = LINK_WardParRef ];

Index RowIDBasedIDKeyIndex On LINKChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 15;

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="LINKCTLOCDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="LINKChildsub">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="LINKParRef">
<Selectivity>14.2857%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="LINK_PACWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LINKWARD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LINK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LINKWARD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LINK_PACWard_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LINK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LINK_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocLinkWardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
