/// 基础数据平台-临床知识库-过敏史字典表
Class User.DHCAllergyFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = ALF_RowId, SqlTableName = DHC_AllergyFeild, StorageStrategy = SQLStorage ]
{

// ^DHCALLERGY

Property ALFCode As %String [ SqlColumnNumber = 2, SqlFieldName = ALF_Code ];

Property ALFDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ALF_Desc ];

Property ALFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ALF_ActiveFlag ];

Property ALFSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ALF_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCALLERGY(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCALLERGYi</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ALF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({ALF_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCALLERGYi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({ALF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ALF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALF_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCALLERGY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ALF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ALF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ALF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAllergyFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
