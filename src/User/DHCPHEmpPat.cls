Class User.DHCPHEmpPat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHEP_RowID, SqlTableName = DHC_PHEmpPat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHEP_StartDate  开始日期
Property PHEPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHEP_StartDate ];

/// PHEP_StartTime  开始时间
Property PHEPStartTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHEP_StartTime ];

/// PHEP_Adm_Dr  病人就诊指针
Property PHEPAdmDr As User.PAAdm [ SqlColumnNumber = 4, SqlFieldName = PHEP_Adm_Dr ];

/// PHEP_Ward_Dr 病区ID
Property PHEPWardDr As User.PACWard [ SqlColumnNumber = 5, SqlFieldName = PHEP_Ward_Dr ];

/// PHEP_Dept_Dr 科室ID
Property PHEPDeptDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PHEP_Dept_Dr ];

/// PHEP_ML_DR  监护级别
Property PHEPMLDR As User.DHCPHMonLevel [ SqlColumnNumber = 7, SqlFieldName = PHEP_ML_DR ];

/// PHEP_EndDate  结束日期
Property PHEPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PHEP_EndDate ];

/// PHEP_EndTime  结束时间
Property PHEPEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PHEP_EndTime ];

/// PHEP_User_Dr  标注用户
Property PHEPUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = PHEP_User_Dr ];

/// PHEP_Remark  备注
Property PHEPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHEP_Remark ];

/// PHEP_Reason  原因
Property PHEPReason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHEP_Reason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHEP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHEP_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEP_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHEP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHEP_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHEP_ML_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHEP_Reason">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHEP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHEP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEP_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHEP_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCPHEP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEP_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHEP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEP_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHEmpPatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHEP)
	s oldI = +$g(^mdata("DHCPHEMPPAT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHEP = maxI
	s ^mdata("DHCPHEMPPAT") = maxI
}

}
