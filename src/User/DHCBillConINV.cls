Class User.DHCBillConINV Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCBCI_Rowid, SqlTableName = DHC_BillConINV, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCBCI_ADMDR
Property DHCBCIADMDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = DHCBCI_ADMDR ];

/// DHCBCI_INVDR
Property DHCBCIINVDR As User.DHCINVPRT [ SqlColumnNumber = 3, SqlFieldName = DHCBCI_INVDR ];

/// DHCBCI_PatBillDR
Property DHCBCIPatBillDR As User.DHCPatientBill [ SqlColumnNumber = 4, SqlFieldName = DHCBCI_PatBillDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBCI)</SqlIdExpression>
<SQLMap name="datamaster">
<Data name="DHCBCI_ADMDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCBCI_INVDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCBCI_PatBillDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCBCI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexadm">
<Global>^DHCBCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_ADMDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexbill">
<Global>^DHCBCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Bill"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_PatBillDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexinv">
<Global>^DHCBCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCBCI_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_INVDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCBCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillConINVS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
