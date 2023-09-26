/// 煎药主表 2019-06-10 hulihua 
/// d ##Class(User.PHADECPreMain).%BuildIndices()
Class User.PHADECPreMain Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PDPM_RowId, SqlTableName = PHA_DECPreMain, StorageStrategy = SQLStorage ]
{

/// 关联子表	
Relationship ChildPHADECPreItem As User.PHADECPreItem [ Cardinality = children, Inverse = PDPIParrefDr ];

/// 处方号
Property PDPMPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PDPM_PrescNo ];

/// Patient Adm 指向就诊表
Property PDPMAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = PDPM_Adm_Dr ];

/// Pointer to other table
Property PDPMPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PDPM_Pointer ];

/// 当前流程
Property PDPMPstDr As User.PHADECProSto [ SqlColumnNumber = 5, SqlFieldName = PDPM_Pst_Dr ];

/// 状态类型
Property PDPMType As %Library.String(DISPLAYLIST = ",Inpatient,Outpatient", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 6, SqlFieldName = PDPM_Type ];

/// 煎药完成标志
Property PDPMCompFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = PDPM_CompFlag ];

/// 生成日期
Property PDPMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PDPM_Date ];

/// 生成时间
Property PDPMTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PDPM_Time ];

/// 煎药室ID
Property PDPMLocDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = PDPM_Loc_Dr ];

/// 全部发放标志
Property PDPMDispAllFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 11, SqlFieldName = PDPM_DispAllFlag ];

/// PDPM_MobileFlag
Property PDPMMobileFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 12, SqlFieldName = PDPM_MobileFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.PHA.DEC.PM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDPM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDPM_CompFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDPM_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDPM_DispAllFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDPM_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDPM_MobileFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDPM_PSt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDPM_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDPM_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDPM_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDPM_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^BS.PHA.DEC.PM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDPM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLocType">
<Global>^BS.PHA.DEC.PMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PDPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DATELOCTYPE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPM_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDPM_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocAdm">
<Global>^BS.PHA.DEC.PMi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LOCADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPM_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^BS.PHA.DEC.PMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDPM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPM_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECPreMainS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.DEC.PM)
	s oldI = +$g(^mdata("PHADECPreMain"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.DEC.PM = maxI
	s ^mdata("PHADECPreMain") = maxI
}

}
