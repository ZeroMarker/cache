/// 科室字典对照表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-14
Class User.DHCPHHospLocCon Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = HOSPL_RowId, SqlTableName = DHC_PHHospLocCon, StorageStrategy = SQLStorage ]
{

// ^DHCPHHLOCCON

Property HOSPLCode As %String [ SqlColumnNumber = 2, SqlFieldName = HOSPL_Code ];

Property HOSPLDesc As %String [ SqlColumnNumber = 3, SqlFieldName = HOSPL_Desc ];

Property HOSPLHisCode As %String [ SqlColumnNumber = 4, SqlFieldName = HOSPL_HisCode ];

Property HOSPLHisDesc As %String [ SqlColumnNumber = 5, SqlFieldName = HOSPL_HisDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHHLOCCON(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHHLOCCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HOSPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HOSPL_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOSPL_HisCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HisCodeIndex">
<Global>^DHCPHHLOCCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOSPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HOSPL_HisCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOSPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="HOSPL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HOSPL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HOSPL_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HOSPL_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHHLOCCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>HOSPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{HOSPL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HOSPL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHHospLocConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
