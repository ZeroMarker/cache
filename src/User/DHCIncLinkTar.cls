/// 库存项收费项关联-第5级
Class User.DHCIncLinkTar Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INCLT_RowId, SqlTableName = DHC_IncLinkTar, StorageStrategy = CacheSQLStorage ]
{

/// 库存项指针
Property INCLTINCIDr As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = INCLT_INCI_Dr ];

/// 收费项指针
Property INCLTTariDr As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = INCLT_Tari_Dr ];

/// 数量
Property INCLTQty As %Library.Numeric [ SqlColumnNumber = 4, SqlFieldName = INCLT_Qty ];

/// 开始日期
Property INCLTStartDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = INCLT_StartDate ];

/// 截止日期
Property INCLTEndDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = INCLT_EndDate ];

Storage CacheSQLStorage
{
<ExtentSize>2500</ExtentSize>
<SqlIdExpression>$i(^DHCINCLT)</SqlIdExpression>
<SQLMap name="IndexInci">
<Global>^DHCINCLT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INCLT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCLT_INCI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCLT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="INCLT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCLT_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCLT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCLT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCLT_Tari_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINCLT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INCLT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INCLT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCIncLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
