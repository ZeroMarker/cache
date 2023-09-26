Class User.DHCPHMonSubClass Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMSC_RowID, SqlTableName = DHC_PHMonSubClass, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHMONSUBCLASSITM As User.DHCPHMonSubClassItm [ Cardinality = children, Inverse = PHMSCIPHMSCParref ];

/// PHMSC_Code
Property PHMSCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHMSC_Code ];

/// PHMSC_Desc
Property PHMSCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHMSC_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHMSC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHMSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHMSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHMSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHMSC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHMSC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonSubClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
