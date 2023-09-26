/// 煎药附加信息表 2019-06-11 hulihua 
/// d ##Class(User.PHADECPreAddInfo).%BuildIndices()
Class User.PHADECPreAddInfo Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PDPAI_RowId, SqlTableName = PHA_DECPreAddInfo, StorageStrategy = SQLStorage ]
{

/// 煎药主表外键
Property PDPAIPreMainDr As User.PHADECPreMain [ SqlColumnNumber = 2, SqlFieldName = PDPAI_PreMain_Dr ];

/// 浸泡时长
Property PDPAISoakInterval As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PDPAI_SoakInterval ];

/// 一煎加水量
Property PDPAIFWaterQua As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PDPAI_FWaterQua ];

/// 一煎时长
Property PDPAIFInterval As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PDPAI_FInterval ];

/// 一煎对应设备
Property PDPAIFEquiDr As User.PHADECEquiMai [ SqlColumnNumber = 6, SqlFieldName = PDPAI_FEqui_Dr ];

/// 二煎加水量
Property PDPAISWaterQua As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PDPAI_SWaterQua ];

/// 二煎时长
Property PDPAISInterval As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PDPAI_SInterval ];

/// 二煎对应设备
Property PDPAISEquiDr As User.PHADECEquiMai [ SqlColumnNumber = 9, SqlFieldName = PDPAI_SEqui_Dr ];

/// 标签数量
Property PDPAILabelNum As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = PDPAI_LabelNum ];

/// 备注
Property PDPAIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PDPAI_Remarks ];

/// 制膏时长
Property PDPAIPasteInterval As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PDPAI_PasteInterval ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.PHA.DEC.PAI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDPAI_FEqui_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDPAI_FInterval">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDPAI_FWaterQua">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDPAI_LabelNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDPAI_PasteInterval">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDPAI_PreMain_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDPAI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDPAI_SEqui_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDPAI_SInterval">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDPAI_SWaterQua">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDPAI_SoakInterval">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^BS.PHA.DEC.PAI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDPAI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDPAI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPMDr">
<Global>^BS.PHA.DEC.PAIi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDPAI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PMDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPAI_PreMain_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPAI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECPreAddInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^BS.PHA.DEC.PAI)
	s oldI = +$g(^mdata("PHADECPreAddInfo"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^BS.PHA.DEC.PAI = maxI
	s ^mdata("PHADECPreAddInfo") = maxI
}

}
