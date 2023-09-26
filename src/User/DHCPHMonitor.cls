Class User.DHCPHMonitor Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHM_RowID, SqlTableName = DHC_PHMonitor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHMonitorItm As User.DHCPHMonitorItm [ Cardinality = children, Inverse = PHMIPHMParref ];

/// PHM_Adm_Dr  病人AdmDr
Property PHMAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHM_Adm_Dr ];

/// PHM_FunTheItem_Dr  主题项目ID
Property PHMFunTheItemDr As User.DHCPHFunTheItem [ SqlColumnNumber = 3, SqlFieldName = PHM_FunTheItem_Dr ];

/// PHM_Date  日期
Property PHMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHM_Date ];

/// PHM_Time  时间
Property PHMTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHM_Time ];

/// PHM_UpdDate  日期
Property PHMUpdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PHM_UpdDate ];

/// PHM_UpdTime  时间
Property PHMUpdTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PHM_UpdTime ];

/// PHM_Status
Property PHMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHM_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHM_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHM_FunTheItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHM_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHM_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHM_UpdDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHM_UpdTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPHM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCPHM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHM_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHM_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdDate">
<Global>^DHCPHM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexUpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHM_UpdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonitorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHM)
	s oldI = +$g(^mdata("DHCPHMONITOR"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHM = maxI
	s ^mdata("DHCPHMONITOR") = maxI
}

}
