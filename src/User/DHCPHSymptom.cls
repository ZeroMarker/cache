/// 知识库症状字典表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-18
Class User.DHCPHSymptom Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = SYM_RowId, SqlTableName = DHC_PHSymptom, StorageStrategy = SQLStorage ]
{

// ^DHCPHSYMP

Property SYMCode As %String [ SqlColumnNumber = 2, SqlFieldName = SYM_Code ];

Property SYMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SYM_Desc ];

Property SYMActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SYM_ActiveFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHSYMP(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHSYMP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({SYM_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHSYMP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({SYM_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="SYM_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SYM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SYM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHSYMP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SYM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SYM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSymptomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
