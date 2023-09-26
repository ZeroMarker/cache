Class User.DHCAppPisTreMet Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisTreMet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 病理申请主表  AP_PisMas_Dr
Property APPisMasDr As User.DHCAppPisMaster [ SqlColumnNumber = 2, SqlFieldName = AP_PisMas_Dr ];

/// 治疗方式   AP_TreMet_Dr
Property APTreMetDr As %Library.String [ SqlColumnNumber = 3, SqlFieldName = AP_TreMet_Dr ];

/// 治疗方式   AP_TreMetDesc
Property APTreMetDesc As %Library.String [ SqlColumnNumber = 4, SqlFieldName = AP_TreMetDesc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCAPPPTM)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_PisMas_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_TreMetDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_TreMet_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPPTM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPisMas">
<Global>^DHCAPPPTM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PisMas"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AP_PisMas_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisTreMetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
