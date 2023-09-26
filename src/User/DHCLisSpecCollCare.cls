/// 基础数据平台-临床知识库-标本采集注意事项
Class User.DHCLisSpecCollCare Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = LSC_RowId, SqlTableName = DHC_LisSpecCollCare, StorageStrategy = SQLStorage ]
{

// ^DHCLSCCARE

Property LSCGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 2, SqlFieldName = LSC_Gen_Dr ];

Property LSCCatDr As User.DHCPHLibCat [ SqlColumnNumber = 3, SqlFieldName = LSC_Cat_Dr ];

Property LSCCollCare As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = LSC_CollCare ];

Property LSCSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LSC_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLSCCARE(0))</SqlIdExpression>
<SQLMap name="IndexCat">
<Global>^DHCLSCCARE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LSC_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LSC_Cat_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGen">
<Global>^DHCLSCCARE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LSC_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LSC_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LSC_CollCare">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LSC_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LSC_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLSCCARE</Global>
<Subscript name="1">
<Expression>{LSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LSC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLisSpecCollCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
