Class User.DHCAdmTotalAmt Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ATA_RowId, SqlTableName = DHC_AdmTotalAmt, StorageStrategy = SQLStorage ]
{

/// Pa_adm Reference
Property ATAPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ATA_PAADM_DR ];

/// ATA_TotalAmt
Property ATATotalAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ATA_TotalAmt ];

/// ATA_TotDisc
Property ATATotDisc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ATA_TotDisc ];

/// ATA_TotIns
Property ATATotIns As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ATA_TotIns ];

/// ATA_TotPat
Property ATATotPat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ATA_TotPat ];

Index ATAPAADMDRUnqIdx1 On ATAPAADMDR [ Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCATA)</SqlIdExpression>
<SQLMap name="INDEXPAADM">
<Global>^DHCATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATA_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="ATA_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATA_TotDisc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATA_TotIns">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATA_TotPat">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATA_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ATA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdmTotalAmtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
