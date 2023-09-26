Class User.DHCRBApptScheduleAudiReason Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_RBApptScheduleAudiReason, StorageStrategy = SQLStorage ]
{

/// 超限描述
Property DHCRBASARDesc As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCRBASAR_Desc ];

/// 有效开始日期
Property DHCRBASARFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCRBASAR_FromDate ];

/// 有效结束日期
Property DHCRBASAREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCRBASAR_EndDate ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCRBASAR(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCRBASAR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCRBASAR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCRBASAR_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBASAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCRBASAR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RBASAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCRBASAR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCRBASAR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCRBApptSc6B3CS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
