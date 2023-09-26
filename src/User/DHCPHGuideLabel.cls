/// 名称：指南目录
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2017-4-12
Class User.DHCPHGuideLabel Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PGL_RowId, SqlTableName = DHC_PHGuideLabel, StorageStrategy = SQLStorage ]
{

// ^DHCPHGULA,^DHCPHGULAi

Property PGLCode As %String [ SqlColumnNumber = 2, SqlFieldName = PGL_Code ];

Property PGLDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PGL_Desc ];

Property PGLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PGL_ActiveFlag ];

Property PGLSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PGL_SysFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHGULA(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHGULAi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PGL_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^DHCPHGULAi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PGL_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PGL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGL_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHGULA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PGL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PGL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PGL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHGuideLabelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
