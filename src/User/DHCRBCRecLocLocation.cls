Class User.DHCRBCRecLocLocation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRL_RowID, SqlTableName = DHCRBC_RecLoc_Location, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRL_RecLocDesc
Property DRLRecLocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DRL_RecLocDesc ];

/// DRL_BookedDesc
Property DRLBookedDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRL_BookedDesc ];

/// DRL_InputFeeDesc
Property DRLInputFeeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRL_InputFeeDesc ];

/// DRL_RecLocDR
Property DRLRecLocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = DRL_RecLocDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCLocation("LOCATION"))</SqlIdExpression>
<SQLMap name="IndexRecLocDR">
<Global>^DHCRBCLocationi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Rec-LocDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRL_RecLocDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DRL_BookedDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRL_InputFeeDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRL_RecLocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRL_RecLocDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCLocation</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOCATION"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCRecLocLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
