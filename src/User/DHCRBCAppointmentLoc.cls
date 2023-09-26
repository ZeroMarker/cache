Class User.DHCRBCAppointmentLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRCAL_RowId, SqlTableName = DHCRBC_AppointmentLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRCAL_LOCID
Property DRCALLocID As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DRCAL_LocID ];

/// DRCAL_DESC
Property DRCALDesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRCAL_Desc ];

/// DRCAL_LOCATION
Property DRCALLocation As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRCAL_Location ];

/// DRCAL_TEL
Property DRCALTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DRCAL_Tel ];

/// DRCAL_InValidate
Property DRCALInValidate As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DRCAL_InValidate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCAppointmentLoc)</SqlIdExpression>
<SQLMap name="IndexLocId">
<Global>^DHCRBCAppointmentLocI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRCAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRCAL_LocID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRCAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DRCAL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRCAL_InValidate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRCAL_LocID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRCAL_Location">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRCAL_Tel">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCAppointmentLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DRCAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DRCAL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCAppointmentLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
