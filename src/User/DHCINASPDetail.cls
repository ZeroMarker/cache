Class User.DHCINASPDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASPD_Rowid, SqlTableName = DHC_INASP_Detail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ASPD_Date
Property ASPDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = ASPD_Date ];

/// ASPD_Time
Property ASPDTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = ASPD_Time ];

/// ASPD_SSUSR_DR
Property ASPDSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = ASPD_SSUSR_DR ];

/// ASPD_PriorSP_UOM
Property ASPDPriorSPUom As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ASPD_PriorSP_Uom ];

/// ASPD_ResultSP_Uom
Property ASPDResultSPUom As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ASPD_ResultSP_Uom ];

/// ASPD_AdjUom
Property ASPDAdjUomDR As User.CTUOM [ SqlColumnNumber = 7, SqlFieldName = ASPD_AdjUom_DR ];

/// ASPD_PriorSP
Property ASPDPriorSP As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ASPD_PriorSP ];

/// ASPD_ResultSP
Property ASPDResultSP As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ASPD_ResultSP ];

/// ASPD_INASP_DR
Property ASPDINASPDR As User.INAdjSalePrice [ SqlColumnNumber = 10, SqlFieldName = ASPD_INASP_DR ];

/// ASPD_PriorRP
Property ASPDPriorRP As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ASPD_PriorRP ];

/// ASPD_ResultRP
Property ASPDResultRP As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ASPD_ResultRP ];

/// ASPD_PriorRP_Uom
Property ASPDPriorRPUom As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ASPD_PriorRP_Uom ];

/// ASPD_ResultRP_Uom
Property ASPDResultRPUom As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = ASPD_ResultRP_Uom ];

/// ASPD_INAPB_DR
Property ASPDINAPBDR As User.INAdjPriceBatch [ SqlColumnNumber = 15, SqlFieldName = ASPD_INAPB_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINASPD)</SqlIdExpression>
<SQLMap name="DataMasterDHCINASPDet">
<Data name="ASPD_AdjUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASPD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASPD_INAPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ASPD_INASP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASPD_PriorRP">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ASPD_PriorRP_Uom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ASPD_PriorSP">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASPD_PriorSP_Uom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASPD_ResultRP">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ASPD_ResultRP_Uom">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ASPD_ResultSP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASPD_ResultSP_Uom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASPD_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASPD_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINASPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ASPD_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINAPB">
<Global>^DHCINASPD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASPD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INAPB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ASPD_INAPB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ASPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINASP">
<Global>^DHCINASPD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INASP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ASPD_INASP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ASPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINASPDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINASPD)
	s oldI = +$g(^mdata("DHCINASPDETAIL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINASPD = maxI
	s ^mdata("DHCINASPDETAIL") = maxI
}

}
