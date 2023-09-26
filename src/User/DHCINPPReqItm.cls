Class User.DHCINPPReqItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPREQI_RowId, SqlTableName = DHC_INPPReqItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPREQIChildSub [ IdKey, PrimaryKey, Unique ];

/// IN_PurPlanItm Parent Reference
Relationship PPREQIINPPIParref As User.INPurPlanItm [ Cardinality = parent, Inverse = ChildDHCINPPReqItm, Required, SqlFieldName = PPREQI_INPPI_Parref ];

/// PPREQI_ChildSub
Property PPREQIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PPREQI_ChildSub ];

/// PPREQI_REQITM_DR
Property PPREQIREQITMDR As User.INReqItm [ SqlColumnNumber = 3, SqlFieldName = PPREQI_REQITM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PPREQI_REQITM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^INPP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_PurPlan.INPP_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IN_PurPlanItm.INPPI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PPREQI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_PurPlan.INPP_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PPI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IN_PurPlanItm.INPPI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PPREQI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRQI">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_PurPlan.INPP_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>IN_PurPlanItm.INPPI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PPREQI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PPREQI_REQITM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IN_PurPlan.INPP_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{IN_PurPlanItm.INPPI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PPREQI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINPPReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
