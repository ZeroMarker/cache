Class User.DHCRBRelationShip Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRRS_RowID, SqlTableName = DHCRB_RelationShip, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBRelationShipItem As User.DHCRBRelationShipItem [ Cardinality = children, Inverse = DHCRBRelationShip ];

/// DRRS_Name
Property DRRSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRRS_Name ];

/// DRRS_Type
Property DRRSType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRRS_Type ];

/// DRRS_IsCompulsory
Property DRRSIsCompulsory As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRRS_IsCompulsory ];

/// DRRS_DetectionTime
Property DRRSDetectionTime As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DRRS_DetectionTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBRelationShip)</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DRRS_DetectionTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRRS_IsCompulsory">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRRS_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRRS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBRelationShip</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRRS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRelationShipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
