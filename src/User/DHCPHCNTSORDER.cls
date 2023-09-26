/// 处方点评基础数据表
Class User.DHCPHCNTSORDER Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCO_RowId, SqlTableName = DHC_PHCNTSORDER, StorageStrategy = CacheSQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHCNTSORDERITM As User.DHCPHCNTSORDERITM [ Cardinality = children, Inverse = PHCOIPHCOPARREF ];

/// 医嘱开单日期
Property PHCOOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHCO_OrdDate ];

/// 医嘱开单医生
Property PHCODoctorDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PHCO_Doctor_Dr ];

/// 医嘱开单科室
Property PHCODocLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHCO_DocLoc_Dr ];

/// 就诊类型
Property PHCOAdmType As %Library.String(DISPLAYLIST = ",I,O,H,E", MAXLEN = 4, VALUELIST = ",I,O,H,E") [ SqlColumnNumber = 5, SqlFieldName = PHCO_AdmType ];

/// 接收科室
Property PHCORecDepDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PHCO_RecDep_Dr ];

/// 院区
Property PHCOHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = PHCO_Hosp_Dr ];

/// 费别
Property PHCOAdmReasonDr As User.PACAdmReason [ SqlColumnNumber = 8, SqlFieldName = PHCO_AdmReason_Dr ];

/// 年龄
Property PHCOAge As %Library.Double [ SqlColumnNumber = 9, SqlFieldName = PHCO_Age ];

/// 售价金额
Property PHCOSpAmt As %Library.Double [ SqlColumnNumber = 10, SqlFieldName = PHCO_SpAmt ];

/// 疗程
Property PHCODuraDr As User.PHCDuration [ SqlColumnNumber = 11, SqlFieldName = PHCO_Dura_Dr ];

/// 医嘱大类-西药\成药\草药(记录首个医嘱对应)
Property PHCOOrdCatDr As User.OECOrderCategory [ SqlColumnNumber = 12, SqlFieldName = PHCO_OrdCat_Dr ];

/// 就诊Id
Property PHCOAdmDr As User.PAAdm [ SqlColumnNumber = 13, SqlFieldName = PHCO_Adm_Dr ];

/// 医嘱开单时间
Property PHCOOrdTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = PHCO_OrdTime ];

Storage CacheSQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCNTSORDER)</SqlIdExpression>
<SQLMap name="IndexAdm">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCO_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmReason">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmReason"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCO_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCO_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCO_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCO_AdmReason_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAge">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Age"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCO_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCO_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCO_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCO_Age}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocLoc">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DocLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCO_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCO_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCO_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCO_DocLoc_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoctor">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Doctor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCO_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCO_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCO_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCO_Doctor_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDep">
<Global>^DHCPHCNTSORDER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCO_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCO_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCO_OrdDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHCO_RecDep_Dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PHCO_AdmReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCO_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCO_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHCO_Age">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCO_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCO_Doctor_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCO_Dura_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHCO_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCO_OrdCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHCO_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCO_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHCO_RecDep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCO_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHCNTSORDER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHCO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSORDERS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCNTSORDER)
	s oldI = +$g(^mdata("DHCPHCNTSORDER"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCNTSORDER = maxI
	s ^mdata("DHCPHCNTSORDER") = maxI
}

}
