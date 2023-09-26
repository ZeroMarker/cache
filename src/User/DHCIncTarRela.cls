/// 库存项收费项关联-第5级
Class User.DHCIncTarRela Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCTR_RowId, SqlTableName = DHC_IncTarRela, StorageStrategy = CacheSQLStorage ]
{

/// 库存项指针
Property INCTRINCIDr As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = INCTR_INCI_Dr ];

/// 收费项指针
Property INCTRTariDr As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = INCTR_Tari_Dr ];

/// 数量
Property INCTRQty As %Library.Numeric [ SqlColumnNumber = 4, SqlFieldName = INCTR_Qty ];

/// 开始日期
Property INCTRStartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = INCTR_StartDate ];

/// 截止日期
Property INCTREndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = INCTR_EndDate ];

Storage CacheSQLStorage
{
<ExtentSize>2500</ExtentSize>
<SqlIdExpression>$i(^DHCINCTAR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INCTR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCTR_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCTR_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCTR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCTR_Tari_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINCTAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INCTR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCINCTARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INCTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCTR_INCI_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTar">
<Global>^DHCINCTARi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INCTR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INCTR_Tari_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCIncTarRelaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
