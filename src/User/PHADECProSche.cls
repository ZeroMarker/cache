/// 煎药方案维护表 2019-08-08 hulihua 
/// d ##Class(User.PHADECProSche).%BuildIndices()
Class User.PHADECProSche Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PDPSE_RowId, SqlTableName = PHA_DECProSche, StorageStrategy = SQLStorage ]
{

/// 方案代码
Property PDPSECode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PDPSE_Code ];

/// 方案名称
Property PDPSEDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PDPSE_Desc ];

/// 是否使用
Property PDPSEActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PDPSE_ActiveFlag ];

/// 处方剂型
Property PDPSEPreFormDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PDPSE_PreForm_Dr ];

/// 处方功效
Property PDPSEPresEffect As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PDPSE_PresEffect ];

/// 压力
Property PDPSEPressure As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PDPSE_Pressure ];

/// 温度
Property PDPSETemper As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PDPSE_Temper ];

/// 浸泡时长
Property PDPSESoakInt As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PDPSE_SoakInt ];

/// 首煎时长
Property PDPSEFirDecInt As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PDPSE_FirDecInt ];

/// 首煎加水量
Property PDPSEFirWaterQua As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PDPSE_FirWaterQua ];

/// 二煎标志
Property PDPSESecDecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 12, SqlFieldName = PDPSE_SecDecFlag ];

/// 二煎时长
Property PDPSESecDecInt As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PDPSE_SecDecInt ];

/// 二煎加水量
Property PDPSESecWaterQua As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PDPSE_SecWaterQua ];

/// 制膏标志
Property PDPSEPasteFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 15, SqlFieldName = PDPSE_PasteFlag ];

/// 制膏时长
Property PDPSEPasteInt As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PDPSE_PasteInt ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.DEC.PSE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDPSE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDPSE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDPSE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDPSE_FirDecInt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDPSE_FirWaterQua">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDPSE_PasteFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PDPSE_PasteInt">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PDPSE_PreForm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDPSE_PresEffect">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDPSE_Pressure">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDPSE_SecDecFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDPSE_SecDecInt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PDPSE_SecWaterQua">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PDPSE_SoakInt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDPSE_Temper">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.PHA.DEC.PSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDPSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDPSE_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFormActive">
<Global>^CF.PHA.DEC.PSEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDPSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"FormActive"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPSE_PreForm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPSE_ActiveFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDPSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPreForm">
<Global>^CF.PHA.DEC.PSEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PDPSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PRESCFORM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDPSE_PreForm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDPSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHADECProScheS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.DEC.PSE)
	s oldI = +$g(^mdata("PHADECProSche"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.DEC.PSE = maxI
	s ^mdata("PHADECProSche") = maxI
}

}
