Class User.DHCPHWardRound Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHWR_RowID, SqlTableName = DHC_PHWardRound, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHWRGUIDANCE As User.DHCPHWRGuidance [ Cardinality = children, Inverse = PHWRGPHWRParref ];

Relationship ChildDHCPHWRHISPRECOM As User.DHCPHWRHisPreCom [ Cardinality = children, Inverse = PHHPCPHWRParref ];

Relationship ChildDHCPHWRPASDISHIS As User.DHCPHWRPasDisHis [ Cardinality = children, Inverse = PHPDHPHWRParref ];

Relationship ChildDHCPHWRPASMEDHIS As User.DHCPHWRPasMedHis [ Cardinality = children, Inverse = PHPMHPHWRParref ];

Relationship ChildDHCPHWRPERANDFAMHIS As User.DHCPHWRPerAndFamHis [ Cardinality = children, Inverse = PHPFHPHWRParref ];

Relationship ChildDHCPHWRCONDISANDTRE As User.DHCPHWRConDisAndTre [ Cardinality = children, Inverse = PHCDTPHWRParref ];

Relationship ChildDHCPHWRALLERGICHIS As User.DHCPHWRAllergicHis [ Cardinality = children, Inverse = PHAHPHWRParref ];

Relationship ChildDHCPHWRDRGITM As User.DHCPHWRDrgItm [ Cardinality = children, Inverse = PHDIPHWRParref ];

Relationship ChildPHWRVitalSigns As User.DHCPHWRVitalSigns [ Cardinality = children, Inverse = VSParref ];

Relationship ChildDHCPHWRPRECOM As User.DHCPHWRPreCom [ Cardinality = children, Inverse = PHWRCPHWRParref ];

/// PHWR_Adm_Dr 病人就诊指针
Property PHWRAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHWR_Adm_Dr ];

/// PHWR_Ward_Dr 病区
Property PHWRWardDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHWR_Ward_Dr ];

/// PHWR_Dept_Dr 科室ID
Property PHWRDeptDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHWR_Dept_Dr ];

/// PHWR_BloodType 血型
Property PHWRBloodType As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHWR_BloodType ];

/// PHWR_ICDesc 诊断
Property PHWRICDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHWR_ICDesc ];

/// PHWR_CurStatus 当前状态
Property PHWRCurStatus As %Library.String(DISPLAYLIST = ",New,In,Out", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,I,O") [ SqlColumnNumber = 7, SqlFieldName = PHWR_CurStatus ];

/// PHWR_Guidance 指导意见
Property PHWRGuidance As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHWR_Guidance ];

/// PHWR_User_Dr 记录人
Property PHWRUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PHWR_User_Dr ];

/// PHWR_Date 记录日期
Property PHWRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PHWR_Date ];

/// PHWR_Time 记录时间
Property PHWRTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PHWR_Time ];

/// PHWR_Weight 体重
Property PHWRWeight As %String [ SqlColumnNumber = 12, SqlFieldName = PHWR_Weight ];

/// PHCP_PharSignPath 药师签名路径
Property PHWRPharSignPath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHWR_PharSignPath ];

/// PHCP_PatSignPath 患者签名路径
Property PHWRPatSignPath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHWR_PatSignPath ];

/// PHWR_Instruction 注意事项
Property PHWRInstruction As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHWR_Instruction ];

/// PHWR_Analysis  用药分析
Property PHWRAnalysis As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PHWR_Analysis ];

/// PHWR_Monitoring 用药监护
Property PHWRMonitoring As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHWR_Monitoring ];

/// PHWR_OutSummary 出院总结
Property PHWROutSummary As %String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHWR_OutSummary ];

/// PHWR_PharCareplan 药学监护计划与实施
Property PHWRPharCareplan As %String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHWR_PharCareplan ];

/// PHWR_Followup 随访跟踪记录
Property PHWRFollowup As %String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PHWR_Followup ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHWR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHWR_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHWR_Analysis">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHWR_BloodType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHWR_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHWR_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHWR_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHWR_Followup">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHWR_Guidance">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHWR_ICDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHWR_Instruction">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHWR_Monitoring">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHWR_OutSummary">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHWR_PatSignPath">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHWR_PharCareplan">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHWR_PharSignPath">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHWR_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHWR_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHWR_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHWR_Weight">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHWR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHWR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHWR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHWR_Adm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCurStatusAdmDr">
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHWR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CurStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWR_CurStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHWR_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHWR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHWR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHWR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHWR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAdmDr">
<Global>^DHCPHWR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHWR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DataAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHWR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHWR_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHWR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHWardRoundS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHWR)
	s oldI = +$g(^mdata("DHCPHWARDROUND"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHWR = maxI
	s ^mdata("DHCPHWARDROUND") = maxI
}

}
