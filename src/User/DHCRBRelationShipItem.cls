Class User.DHCRBRelationShipItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCRB_RelationShipItem, SqlTableName = DHCRB_RelationShipItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On childsub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_RelationShip Parent Reference
Relationship DHCRBRelationShip As User.DHCRBRelationShip [ Cardinality = parent, Inverse = ChildDHCRBRelationShipItem, Required, SqlFieldName = DHCRB_RelationShip ];

/// Child subscript
Property childsub As %Library.Float [ InitialExpression = {$i(^mdata("DHCRBRELATIONSHIPITEM"))}, Required, SqlColumnNumber = 2 ];

/// DRRSI_ExamGroup_DR
Property DRRSIExamGroupDR As User.DHCRBExamGroup [ SqlColumnNumber = 3, SqlFieldName = DRRSI_ExamGroup_DR ];

/// DRRSI_SequenceNumber
Property DRRSISequenceNumber As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DRRSI_SequenceNumber ];

/// DRRSI_MinimumTimeInterval
Property DRRSIMinimumTimeInterval As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DRRSI_MinimumTimeInterval ];

/// DRRSI_MaxmumTimeInterval
Property DRRSIMaxmumTimeInterval As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DRRSI_MaxmumTimeInterval ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DRRSI_ExamGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRRSI_MaxmumTimeInterval">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRRSI_MinimumTimeInterval">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRRSI_SequenceNumber">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBRelationShip</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_RelationShip.DRRS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RelationShipItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_RelationShip.DRRS_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExamGroup">
<Global>^DHCRBRelationShipi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_RelationShip.DRRS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExamGroupIndex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRRSI_ExamGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_RelationShip.DRRS_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShipSequence">
<Data name="childsub"/>
<Global>^DHCRBRelationShipi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCRB_RelationShip.DRRS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ShipSequenceIndex"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCRB_RelationShip.DRRS_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRRSI_SequenceNumber}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRelationShipItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
