Class User.DHCAppRepPos Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepPos, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 检查报告医嘱项对应部位记录表ID  AR_RepPart_Dr 
Property ARRepPartDr As User.DHCAppRepPart [ SqlColumnNumber = 2, SqlFieldName = AR_RepPart_Dr ];

/// 体位  AR_Pos_Dr 
Property ARPosDr As User.DHCAppPosition [ SqlColumnNumber = 3, SqlFieldName = AR_Pos_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCAPREPO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_Pos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AR_RepPart_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPREPO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRepPart">
<Global>^DHCAPREPO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepPart"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_RepPart_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepPosS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
