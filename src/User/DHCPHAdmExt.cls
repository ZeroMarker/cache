Class User.DHCPHAdmExt Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHA_RowID, SqlTableName = DHC_PHAdmExt, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHA_Adm_Dr  病人就诊指针
Property PHAAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHA_Adm_Dr ];

/// PHA_AdmType  就诊类型
Property PHAAdmType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHA_AdmType ];

/// PHA_AdmVisStatus  在院状态
Property PHAAdmVisStatus As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHA_AdmVisStatus ];

/// PHA_Date  结束日期
Property PHADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHA_Date ];

/// PHA_Time  结束时间
Property PHATime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHA_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHAE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHA_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHA_AdmVisStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHA_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHA_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHA_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHAE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCPHAE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVisStatusAdmType">
<Global>^DHCPHAE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VisStatusAdmType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_AdmVisStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdmExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHAE)
	s oldI = +$g(^mdata("DHCPHADMEXT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHAE = maxI
	s ^mdata("DHCPHADMEXT") = maxI
}

}
