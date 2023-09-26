/// 基础数据平台-临床知识库-通用名和剂型/部位/标本关联表
Class User.DHCGenLinkPointer Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = GlP_RowId, SqlTableName = DHC_GenLinkPointer, StorageStrategy = SQLStorage ]
{

// ^DHCGENLINP

Property GlPGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 2, SqlFieldName = GlP_Gen_Dr ];

Property GlPPointer As %String [ SqlColumnNumber = 3, SqlFieldName = GlP_Pointer ];

Property GlPActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GlP_ActiveFlag ];

Property GlPSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = GlP_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCGENLINP(0))</SqlIdExpression>
<SQLMap name="IndexGen">
<Global>^DHCGENLINPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GlP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({GlP_Gen_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GlP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenPointer">
<Global>^DHCGENLINPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GlP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{GlP_Gen_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({GlP_Pointer})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GlP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPointer">
<Global>^DHCGENLINPi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GlP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({GlP_Pointer})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GlP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="GlP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GlP_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GlP_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GlP_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCGENLINP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GlP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GlP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>GlP_RowId</SqlRowIdName>
<StreamLocation>^User.DHCGenLinkPointerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
