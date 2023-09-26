/// 基础数据平台-临床知识库-用法字典表
Class User.DHCPHExtInstruc Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEIN_RowId, SqlTableName = DHC_PHExtInstruc, StorageStrategy = SQLStorage ]
{

// ^DHCPHEINSTR

Property PHEINCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHEIN_Code ];

Property PHEINDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHEIN_Desc ];

Property PHEINActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHEIN_ActiveFlag ];

Property PHEINSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEIN_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEINSTR(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHEINSTRi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHEIN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEIN_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHEINSTRi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEIN_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEIN_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEIN_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEIN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEIN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEIN_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEINSTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEIN_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHEIN_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEIN_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtInstrucS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
