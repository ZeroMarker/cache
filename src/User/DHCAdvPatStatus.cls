Class User.DHCAdvPatStatus Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PATSTA_RowID, SqlTableName = DHC_AdvPatStatus, StorageStrategy = NewStorage1 ]
{

/// 状态类型	
Property PATSTAType As %String [ SqlColumnNumber = 2, SqlFieldName = PATSTA_Type ];

/// 状态代码
Property PATSTACode As %String [ SqlColumnNumber = 3, SqlFieldName = PATSTA_Code ];

/// 状态描述
Property PATSTADesc As %String [ SqlColumnNumber = 4, SqlFieldName = PATSTA_Desc ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCADVPATSTA)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVPATSTA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PATSTA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PATSTA_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PATSTA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PATSTA_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PATSTA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PATSTA_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVPATSTA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PATSTA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PATSTA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvPatStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
