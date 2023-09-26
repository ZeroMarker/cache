/// 基础数据平台-临床知识库-过敏史关键字表
Class User.DHCAllergyKey Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = ALK_RowId, SqlTableName = DHC_AllergyKey, StorageStrategy = SQLStorage ]
{

// ^DHCALLGYKEY

Property ALKALDr As User.DHCAllergyFeild [ SqlColumnNumber = 2, SqlFieldName = ALK_AL_Dr ];

Property ALKKey As %String [ SqlColumnNumber = 3, SqlFieldName = ALK_Key ];

Property ALKSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ALK_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCALLGYKEY(0))</SqlIdExpression>
<SQLMap name="IndexKey">
<Global>^DHCALLGYKEYi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ALK_AL_Dr</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Key"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALK_AL_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({ALK_Key})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ALK_AL_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALK_Key">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALK_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCALLGYKEY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ALK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ALK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ALK_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAllergyKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
