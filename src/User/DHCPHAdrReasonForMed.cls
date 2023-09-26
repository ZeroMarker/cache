Class User.DHCPHAdrReasonForMed Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRM_RowID, SqlTableName = DHC_PHAdrReasonForMed, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ADRRM_Code
Property ADRRMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADRRM_Code ];

/// ADRRM_Desc
Property ADRRMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRRM_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRRM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRRM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRRM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADRRM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRRM_RowI</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRRM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrReasonForMedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
