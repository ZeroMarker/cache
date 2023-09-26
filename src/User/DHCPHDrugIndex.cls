Class User.DHCPHDrugIndex Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PHDI_RowID, SqlTableName = DHC_PHDrugIndex, StorageStrategy = NewStorage1 ]
{

Property PHDIPHCDDR As User.PHCDrgMast [ SqlColumnNumber = 2, SqlFieldName = PHDI_PHCD_DR ];

Property PHDITestCodeDR As dbo.BTTestCode [ SqlColumnNumber = 3, SqlFieldName = PHDI_TestCode_DR ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCPHDIN(0))</SqlIdExpression>
<SQLMap name="Data">
<Data name="PHDI_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDI_TestCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHDIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHDI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCPHDINi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDI_PHCD_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDI_TestCode_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Index1">
<Global>^DHCPHDINi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHDI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"T"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDI_TestCode_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDI_PHCD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHDI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHDrugIndexS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
