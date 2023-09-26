/// 库存项关联计费项
Class User.DHCINCILExt Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = ILE_RowId, SqlTableName = DHC_INCIL_Ext, StorageStrategy = SQLStorage ]
{

Property ILEINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = ILE_INCI_DR ];

Property ILECTLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = ILE_CTLoc_DR ];

Property ILESpecListDR As User.DHCItmSpecList [ SqlColumnNumber = 4, SqlFieldName = ILE_SpecList_DR ];

Property ILESpecDesc As %String [ SqlColumnNumber = 5, SqlFieldName = ILE_SpecDesc ];

/// 上限(基本单位)
Property ILEMaxQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = ILE_MaxQty ];

/// 下限(基本单位)
Property ILEMinQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 7, SqlFieldName = ILE_MinQty ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCILE)</SqlIdExpression>
<SQLMap name="IndexInciLoc">
<Global>^DHCILE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ILE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"InciLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILE_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILE_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ILE_SpecList_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{ILE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocInci">
<Global>^DHCILE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ILE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocInci"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ILE_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ILE_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{ILE_SpecList_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{ILE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="ILE_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILE_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILE_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ILE_MinQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ILE_SpecDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ILE_SpecList_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCILE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ILE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ILE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINCILExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCILE)
	s oldI = +$g(^mdata("DHCINCILEXT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCILE = maxI
	s ^mdata("DHCINCILEXT") = maxI
}

}
