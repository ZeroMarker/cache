Class User.DHCInpoiApproForSCI Extends (%Persistent, User.Abstract) [ SqlRowIdName = IPOISCI_Rowid, SqlTableName = DHC_InpoiApproForSCI, StorageStrategy = SqlStorage ]
{

Property IPOISCIINPOIDR As User.INPOItm [ SqlColumnNumber = 2, SqlFieldName = IPOISCI_INPOI_DR ];

/// 随行单明细表ID
Property IPOISCIOrderDetailSubId As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IPOISCI_OrderDetailSubId ];

Property IPOISCIApproveQty As %Float [ SqlColumnNumber = 4, SqlFieldName = IPOISCI_Approve_Qty ];

Property IPOISCICTUOMDr As CTUOM [ Required, SqlColumnNumber = 5, SqlFieldName = IPOISCI_CTUOM_Dr ];

Property IPOISCIDate As %Date [ SqlColumnNumber = 6, SqlFieldName = IPOISCI_Date ];

Property IPOISCITime As %Time [ SqlColumnNumber = 7, SqlFieldName = IPOISCI_Time ];

Property IPOISCISSusrDr As SSUser [ SqlColumnNumber = 8, SqlFieldName = IPOISCI_SSusr_Dr ];

Property IPOISCIApproveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = IPOISCI_ApproveFlag ];

Property IPOISCISCANQty As %Float [ SqlColumnNumber = 10, SqlFieldName = IPOISCI_SCAN_Qty ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCIPOISCI(0))</SqlIdExpression>
<SQLMap name="DataMasterPOISCI">
<Data name="IPOISCI_ApproveFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPOISCI_Approve_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPOISCI_CTUOM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPOISCI_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPOISCI_INPOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPOISCI_OrderDetailSubId">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPOISCI_SCAN_Qty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPOISCI_SSusr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPOISCI_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCIPOISCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPOISCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateInpoi">
<Global>^DHCIPOISCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IPOISCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DateInpoi"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_INPOI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInpoi">
<Global>^DHCIPOISCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPOISCI_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Inpoi"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_INPOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexordsubid">
<Global>^DHCIPOISCI</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ORDSUBID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_OrderDetailSubId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{IPOISCI_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IPOISCI_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCInpoiApproForSCIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
