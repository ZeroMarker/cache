/// 基础数据平台-临床知识库-通用名别名字典
Class User.DHCPHExtGenAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEGAl_RowId, SqlTableName = DHC_PHExtGenAlias, StorageStrategy = SQLStorage ]
{

// ^DHCPHEGAL

Property PHEGAlGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 2, SqlFieldName = PHEGAl_Gen_Dr ];

Property PHEGAlText As %String [ SqlColumnNumber = 3, SqlFieldName = PHEGAl_Text ];

Property PHEGAlLibDr As User.DHCPHLibaryLabel [ SqlColumnNumber = 4, SqlFieldName = PHEGAl_Lib_Dr ];

Property PHEGAlSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEGAl_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEGAL(0))</SqlIdExpression>
<SQLMap name="IndexGen">
<Global>^DHCPHEGALi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEGAl_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEGAl_Gen_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEGAl_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenText">
<Global>^DHCPHEGALi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHEGAl_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GenText"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHEGAl_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({PHEGAl_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHEGAl_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^DHCPHEGALi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHEGAl_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEGAl_Text})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEGAl_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEGAl_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEGAl_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEGAl_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHEGAl_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHEGAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEGAl_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEGAl_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEGAl_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtGenAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
