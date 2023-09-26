Class User.DHCRBPositionMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPM_RowID, SqlTableName = DHCRB_PositionMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBPositionMapDesc As User.DHCRBPositionMapDesc [ Cardinality = children, Inverse = DPMDParRef ];

/// DPM_Name
Property DPMFileName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DPM_FileName ];

/// DPM_Height
Property DPMHeight As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DPM_Height ];

/// DPM_Width
Property DPMWidth As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DPM_Width ];

/// DPM_Medium_DR
Property DPMMediumDR As User.DHCRBCMedium [ SqlColumnNumber = 5, SqlFieldName = DPM_Medium_DR ];

/// DPM_Loc_DR
Property DPMLocDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DPM_Loc_DR ];

/// DPM_Desc
Property DPMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DPM_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBMap("Image"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBMapi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Locdr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPM_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DPM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPM_FileName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPM_Height">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DPM_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPM_Medium_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DPM_Width">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBMap</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Image"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBPositionMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
