/// 基础数据平台-临床知识库-剂型字典表
Class User.DHCPHExtForm Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHEF_RowId, SqlTableName = DHC_PHExtForm, StorageStrategy = SQLStorage ]
{

// ^DHCPHEF

Property PHEFCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHEF_Code ];

Property PHEFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHEF_Desc ];

Property PHEFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHEF_ActiveFlag ];

Property PHEFSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PHEF_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHEF(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHEFi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHEF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEF_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHEFi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({PHEF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHEF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHEF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHEF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHEF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHEF_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHEF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHEF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHEF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHEF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHExtFormS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
