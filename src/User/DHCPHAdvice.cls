Class User.DHCPHAdvice Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHA_RowID, SqlTableName = DHC_PHAdvice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHAdvDetail As User.DHCPHAdvDetail [ Cardinality = children, Inverse = PHADPHAParref ];

Relationship ChildDHCPHAdvItm As User.DHCPHAdvItm [ Cardinality = children, Inverse = PHAIPHAParref ];

/// PHA_User_Dr 药师UserID
Property PHAUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PHA_User_Dr ];

/// PHA_Adm_Dr  病人AdmDr
Property PHAAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PHA_Adm_Dr ];

/// PHA_DocUser_Dr  医生UserID
Property PHADocUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHA_DocUser_Dr ];

/// PHA_Date  日期
Property PHADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHA_Date ];

/// PHA_Time  时间
Property PHATime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHA_Time ];

/// PHA_CurStatus  当前状态 10-药师建议  20-医生申诉  30-医生接受 40-药师接受
Property PHACurStatus As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHA_CurStatus ];

/// PHA_Adopt  是否采纳  1-采纳  0未采纳
Property PHAAdopt As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = PHA_Adopt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHAD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHA_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHA_Adopt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHA_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHA_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHA_DocUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHA_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHA_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCPHAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateDocUser">
<Global>^DHCPHAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateDocUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_DocUser_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateUser">
<Global>^DHCPHAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHA_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHA_User_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHAD)
	s oldI = +$g(^mdata("DHCPHADVICE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHAD = maxI
	s ^mdata("DHCPHADVICE") = maxI
}

}
