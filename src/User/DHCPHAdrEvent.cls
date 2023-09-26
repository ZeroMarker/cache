Class User.DHCPHAdrEvent Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRE_RowID, SqlTableName = DHC_PHAdrEvent, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ADRE_Code
Property ADRECode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ADRE_Code ];

/// ADRE_Desc
Property ADREDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRE_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHADRE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADRE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADRE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHADRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADRE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADRE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
