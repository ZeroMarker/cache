/// 名称: DHC_SymptomFeild
/// 描述: 症状字典表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-13
Class User.DHCSymptomFeild Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = SYF_RowId, SqlTableName = DHC_SymptomFeild, StorageStrategy = SQLStorage ]
{

// ^DHCSYMFEI

Property SYFCode As %String(MAXLEN = 200) [ SqlColumnNumber = 2, SqlFieldName = SYF_Code ];

Property SYFDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = SYF_Desc ];

Property SYFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SYF_ActiveFlag ];

Property SYFAge As %String [ SqlColumnNumber = 5, SqlFieldName = SYF_Age ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSYMFEI(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCSYMFEI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({SYF_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCSYMFEI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$UPPER({SYF_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="SYF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SYF_Age">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SYF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SYF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSYMFEI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SYF_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SYF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SYF_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSymptomFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
