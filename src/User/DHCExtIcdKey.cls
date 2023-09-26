/// 基础数据平台-临床知识库-诊断关键字表
Class User.DHCExtIcdKey Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = ICDK_RowId, SqlTableName = DHC_ExtIcdKey, StorageStrategy = SQLStorage ]
{

// ^DHCEXTICDK

Property ICDKICDDr As User.DHCExtIcdFeild [ SqlColumnNumber = 2, SqlFieldName = ICDK_ICD_Dr ];

Property ICDKText As %String [ SqlColumnNumber = 3, SqlFieldName = ICDK_Text ];

Property ICDKSysFlag As %String [ SqlColumnNumber = 4, SqlFieldName = ICDK_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEXTICDK(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICDK_ICD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICDK_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICDK_Text">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEXTICDK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICDK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICDK_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICDText">
<Global>^DHCEXTICDKi</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ICDK_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICDText"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICDK_ICD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$UPPER({ICDK_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICDK_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ICDK_RowId</SqlRowIdName>
<StreamLocation>^User.DHCExtIcdKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
