Class User.DHCStkDrugGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDG_RowId, SqlTableName = DHCStkDrugGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkDrugGrpItm As User.DHCStkDrugGrpItm [ Cardinality = children, Inverse = SDGISDGParRef ];

/// SDG_Code
Property SDGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SDG_Code ];

/// SDG_Desc
Property SDGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SDG_Desc ];

/// SDG_Type
Property SDGType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SDG_Type ];

/// SDG_IsPack
Property SDGIsPack As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SDG_IsPack ];

/// SDG_Reserve
Property SDGReserve As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SDG_Reserve ];

/// SDG_ReqFlag
Property SDGReqFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SDG_ReqFlag ];

/// SDG_MobileFlag
Property SDGMobileFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SDG_MobileFlag ];

/// SDG_MobileFlag
Property SDGCategGroup As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SDG_CategGroup ];

/// 打印明细
Property SDGPrtDetail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SDG_PrtDetail ];

/// 打印汇总
Property SDGPrtTotal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SDG_PrtTotal ];

/// 打印其他
Property SDGPrtCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SDG_PrtCode ];

/// 打印冲减退药单
Property SDGPrtReserve As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SDG_PrtReserve ];

/// 打印预览
Property SDGPrtPreview As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SDG_PrtPreview ];

/// 打印库存不足单
Property SDGPrtNoStock As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SDG_PrtNoStock ];

/// 病区结余药冲减标志
Property SDGBalReserve As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SDG_BalReserve ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTDRUGGRP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SDG_BalReserve">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SDG_CategGroup">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SDG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDG_IsPack">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SDG_MobileFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SDG_PrtCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SDG_PrtDetail">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SDG_PrtNoStock">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SDG_PrtPreview">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SDG_PrtReserve">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SDG_PrtTotal">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SDG_ReqFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SDG_Reserve">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SDG_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTDRUGGRP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SDG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SDG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCSTDRUGGRP</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SDG_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SDG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDrugGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTDRUGGRP)
	s oldI = +$g(^mdata("DHCSTKDRUGGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTDRUGGRP = maxI
	s ^mdata("DHCSTKDRUGGROUP") = maxI
}

}
