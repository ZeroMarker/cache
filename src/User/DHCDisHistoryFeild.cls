/// 基础数据平台-临床知识库-既往史字典表
Class User.DHCDisHistoryFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = DHI_RowId, SqlTableName = DHC_DisHistoryFeild, StorageStrategy = SQLStorage ]
{

// ^DHCDISHISF

Property DHICode As %String [ SqlColumnNumber = 2, SqlFieldName = DHI_Code ];

Property DHIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DHI_Desc ];

Property DHIActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DHI_ActiveFlag ];

Property DHISysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DHI_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDISHISF(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCDISHISFi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DHI_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDISHISFi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({DHI_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DHI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHI_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISHISF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDisHistoryFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
