Class User.DHCTransferDoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCTRD_Rowid, SqlTableName = DHC_TransferDoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCTRD_CTPCP_Dr
Property DHCTRDCTPCPDr As User.CTCareProv [ SqlColumnNumber = 2, SqlFieldName = DHCTRD_CTPCP_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTRDOC)</SqlIdExpression>
<SQLMap name="DHCTransferDocMaster">
<Data name="DHCTRD_CTPCP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCTRDOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCTRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCTRD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCODE">
<Global>^DHCTRDOCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCTRD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CTPCP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCTRD_CTPCP_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCTRD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCTransferDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
