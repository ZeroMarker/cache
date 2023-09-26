Class User.DHCBarCodeSplitInfo Extends (%Persistent, User.Abstract) [ SqlRowIdName = SPLIT_RowId, SqlTableName = DHC_BarCodeSplitInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property SPLITINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = SPLIT_INCI_DR ];

Property SPLITBarCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SPLIT_BarCode ];

Property SPLITExpStartPosition As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SPLIT_ExpStartPosition ];

Property SPLITExpLength As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SPLIT_ExpLength ];

Property SPLITBatStartPosition As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = SPLIT_BatStartPosition ];

Property SPLITBatLength As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SPLIT_BatLength ];

Property SPLITUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = SPLIT_UpdateDate ];

Property SPLITUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = SPLIT_UpdateTime ];

Property SPLITUpdateUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = SPLIT_UpdateUser_DR ];

/// 生产日期起始位置
Property SPLITProStartPosition As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SPLIT_ProStartPosition ];

/// 生产日期长度
Property SPLITProLength As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SPLIT_ProLength ];

/// 具体规格
Property SPLITSpecDesc As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SPLIT_SpecDesc ];

Property SPLITSciDr As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SPLIT_SciDr ];

/// UDI编码
Property SPLITUDICode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SPLIT_UDICode ];

///  Index SPLITBarCodeUniqueIndex On SPLITBarCode [ Unique ];
Storage SQLStorage
{
<Description>
<![CDATA[ Index SPLITBarCodeUniqueIndex On SPLITBarCode [ Unique ];]]></Description>
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSPLIT)</SqlIdExpression>
<SQLMap name="IndexBarCode">
<Global>^DHCSPLIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPLIT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SPLIT_BarCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SPLIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCSPLIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPLIT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SPLIT_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{SPLIT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="SPLIT_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPLIT_BatLength">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SPLIT_BatStartPosition">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SPLIT_ExpLength">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPLIT_ExpStartPosition">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SPLIT_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPLIT_ProLength">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SPLIT_ProStartPosition">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SPLIT_SciDr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SPLIT_SpecDesc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SPLIT_UDICode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SPLIT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SPLIT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SPLIT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCSPLIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SPLIT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{SPLIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPLIT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBarCodeSplitInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSPLIT)
	s oldI = +$g(^mdata("DHCBARCODESPLITINFO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSPLIT = maxI
	s ^mdata("DHCBARCODESPLITINFO") = maxI
}

}
