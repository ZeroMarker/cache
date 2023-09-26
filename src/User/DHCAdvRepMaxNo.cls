Class User.DHCAdvRepMaxNo Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADVRMN_RowID, SqlTableName = DHC_AdvRepMaxNo, StorageStrategy = SQLStorage ]
{

/// 		编号		
Property ADVRMNCode As %String [ SqlColumnNumber = 2, SqlFieldName = ADVRMN_Code ];

/// 		报告类型dr		
Property ADVRMNRepTypeDr As %String [ SqlColumnNumber = 3, SqlFieldName = ADVRMN_RepType_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVRMN)</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCADVRMN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVRMN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVRMN_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVRMN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADVRMN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVRMN_RepType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVRMN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVRMN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVRMN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TypeIndex">
<Global>^DHCADVRMN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVRMN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVRMN_RepType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVRMN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepMaxNoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
