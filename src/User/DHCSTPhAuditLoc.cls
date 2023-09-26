/// DHC_STPhAuditLoc
Class User.DHCSTPhAuditLoc Extends (%Library.Persistent, User.Abstract) [ Not Abstract, ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAL_RowID, SqlTableName = DHC_STPhAuditLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PALPhLocDr Des Ref to CT_Loc 
Property PALPhLocDr As CTLoc [ SqlColumnNumber = 2, SqlFieldName = PAL_PhLoc_Dr ];

/// PALOrdLocDr Des Ref to CT_Loc
Property PALOrdLocDr As CTLoc [ SqlColumnNumber = 3, SqlFieldName = PAL_OrdLoc_Dr ];

/// PAL_Poison_Dr PHC_Poison 可多选逗号隔开
Property PALPoisonDr As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PAL_Poison_Dr ];

Property PALFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PAL_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTPAL(0))</SqlIdExpression>
<SQLMap name="LocIndex">
<Global>^DHCSTPAL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdPhLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAL_OrdLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{PAL_PhLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PAL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAL_OrdLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAL_PhLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAL_Poison_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTPAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PAL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PhaLocIndex">
<Global>^DHCSTPAL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PhOrdLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAL_PhLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAL_OrdLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCSTPhAuditLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
