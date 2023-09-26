Class User.DHCWorkAuditLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = DWAL_RowId, SqlTableName = DHC_WorkAuditLog, StorageStrategy = SQLStorage ]
{

/// 日期
Property DWALDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 2, SqlFieldName = DWAL_Date ];

/// 时间
Property DWALTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = DWAL_Time ];

/// 业务类型
Property DWALType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DWAL_Type ];

/// 库存项ID||日志主表ID
Property DWALPoint As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DWAL_Point ];

/// 审核人
Property DWALUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = DWAL_User_Dr ];

/// 审核级别
Property DWALLevel As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DWAL_Level ];

/// 审核标志
Property DWALFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 8, SqlFieldName = DWAL_Flag ];

/// 拒绝理由
Property DWALRefuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DWAL_RefuseReason ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDWAL)</SqlIdExpression>
<SQLMap name="IndexTypeDate">
<Global>^DHCDWAL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DWAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DWAL_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DWAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePoint">
<Global>^DHCDWAL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DWAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePoint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DWAL_Point}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DWAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indextypelevel">
<Global>^DHCDWAL</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DWAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPEPOINTLEVEL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DWAL_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DWAL_Point}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DWAL_Level}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DWAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DWAL_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DWAL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DWAL_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DWAL_Point">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DWAL_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DWAL_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DWAL_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DWAL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDWAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DWAL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DWAL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DWAL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCWorkAuditLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCDWAL)
	s oldI = +$g(^mdata("DHCWorkAuditLog"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCDWAL = maxI
	s ^mdata("DHCWorkAuditLog") = maxI
}

}
