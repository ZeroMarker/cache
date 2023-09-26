Class User.DHCPAQuePrintLog Extends %Persistent [ SqlTableName = DHC_PAQuePrintLog, StorageStrategy = SQLStorage ]
{

/// PQPL_PrescNo
Property PQPLPrescNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PQPL_PrescNo ];

/// PQPL_AgencyCredNo
Property PQPLAgencyCredNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PQPL_AgencyCredNo ];

/// PQPL_AgencyCredNo
Property PQPLAgencyName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PQPL_AgencyName ];

/// PQPL_AgencyCredNo
Property PQPLAgencyTel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PQPL_AgencyTel ];

/// PQPL_PrintDate
Property PQPLPrintDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PQPL_PrintDate ];

/// PQPL_PrintTime
Property PQPLPrintTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PQPL_PrintTime ];

/// PQPL_PrintUser_DR
Property PQPLPrintUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = PQPL_PrintUser_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPAQPL("PL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PQPL_AgencyCredNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PQPL_AgencyName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PQPL_AgencyTel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PQPL_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PQPL_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PQPL_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PQPL_PrintUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPAQPL</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PQPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PQPL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^DHCPAQPL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PQPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PQPL_PrescNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PQPL_PrintDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PQPL_PrintTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PQPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintDate">
<Global>^DHCPAQPL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PQPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PrinDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PQPL_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PQPL_PrintTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PQPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintUser">
<Global>^DHCPAQPL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PQPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PrintUser"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PQPL_PrintUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PQPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PQPL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPAQuePrintLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
