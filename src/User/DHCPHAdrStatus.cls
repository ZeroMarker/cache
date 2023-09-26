Class User.DHCPHAdrStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRS_RowID, SqlTableName = DHC_PHAdrStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHADRSTATUSGRANT As User.DHCPHAdrStatusGrant [ Cardinality = children, Inverse = ADRSGADRSParref ];

/// ADRS_Code
Property ADRSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADRS_Code ];

/// ADRS_Desc
Property ADRSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRS_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADRS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{ADRS_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHADRS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{ADRS_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
