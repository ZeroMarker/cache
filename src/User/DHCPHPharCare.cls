Class User.DHCPHPharCare Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPC_RowID, SqlTableName = DHC_PHPharCare, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHPCMONSCOPE As User.DHCPHPCMonScope [ Cardinality = children, Inverse = PHMSPHPCParref ];

Relationship ChildDHCPHPCMONITEM As User.DHCPHPCMonItem [ Cardinality = children, Inverse = PHMIPHPCParref ];

Relationship ChildDHCPHPCDRGITM As User.DHCPHPCDrgItm [ Cardinality = children, Inverse = PHDIPHPCParref ];

/// PHPC_ML_DR 监护级别
Property PHPCMLDR As User.DHCPHMonLevel [ SqlColumnNumber = 2, SqlFieldName = PHPC_ML_DR ];

/// PHPC_Adm_Dr 病人就诊指针
Property PHPCAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PHPC_Adm_Dr ];

/// PHPC_Ward_Dr 病区ID
Property PHPCWardDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHPC_Ward_Dr ];

/// PHPC_Dept_Dr 科室ID
Property PHPCDeptDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHPC_Dept_Dr ];

/// PHPC_User_Dr 记录人
Property PHPCUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PHPC_User_Dr ];

/// PHPC_Date 记录日期
Property PHPCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PHPC_Date ];

/// PHPC_Time 记录时间
Property PHPCTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PHPC_Time ];

/// PHPC_Content 监护内容
Property PHPCContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHPC_Content ];

/// PHPC_ImpMonItems 重要检验检测项目
Property PHPCImpMonItems As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHPC_ImpMonItems ];

/// PHPC_MonitorSituation  监护执行情况
Property PHPCMonitorSituation As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHPC_MonitorSituation ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHPC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHPC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHPC_Content">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHPC_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHPC_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHPC_ImpMonItems">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHPC_ML_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPC_MonitorSituation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHPC_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHPC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHPC_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHPC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCPHPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHPC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPC_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPharCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHPC)
	s oldI = +$g(^mdata("DHCPHPHARCARE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHPC = maxI
	s ^mdata("DHCPHPHARCARE") = maxI
}

}
