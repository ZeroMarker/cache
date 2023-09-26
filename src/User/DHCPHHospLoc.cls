/// 科室字典表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-14
Class User.DHCPHHospLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = HOSPL_RowId, SqlTableName = DHC_PHHospLoc, StorageStrategy = SQLStorage ]
{

// ^DHCPHHLOC

Property HOSPLCode As %String [ SqlColumnNumber = 2, SqlFieldName = HOSPL_Code ];

Property HOSPLDesc As %String [ SqlColumnNumber = 3, SqlFieldName = HOSPL_Desc ];

Property HOSPLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = HOSPL_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHHLOC(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHHLOC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOSPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({HOSPL_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOSPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHHLOC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>HOSPL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({HOSPL_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOSPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="HOSPL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HOSPL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HOSPL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHHLOC</Global>
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
<StreamLocation>^User.DHCPHHospLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
