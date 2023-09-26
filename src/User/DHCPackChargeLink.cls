/// 打包收费关联表
Class User.DHCPackChargeLink Extends (%Persistent, User.Abstract) [ SqlRowIdName = PCL_RowId, SqlTableName = DHC_PackChargeLink, StorageStrategy = SQLStorage ]
{

Property PCLPackDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = PCL_Pack_DR ];

Property PCLINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PCL_INCI_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPCL)</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="PCL_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCL_Pack_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PCL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PackIndex">
<Global>^DHCPCL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PACK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCL_Pack_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PCL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPackChargeLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPCL)
	s oldI = +$g(^mdata("DHCPACKCHARGELINK"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPCL = maxI
	s ^mdata("DHCPACKCHARGELINK") = maxI
}

}
