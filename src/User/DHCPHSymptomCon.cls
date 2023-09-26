/// 症状字典对照表
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-18
Class User.DHCPHSymptomCon Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = SYM_RowId, SqlTableName = DHC_PHSymptomCon, StorageStrategy = SQLStorage ]
{

// ^DHCPHSYMCON

Property SYMCode As %String [ SqlColumnNumber = 2, SqlFieldName = SYM_Code ];

Property SYMDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SYM_Desc ];

Property SYMHisCode As %String [ SqlColumnNumber = 4, SqlFieldName = SYM_HisCode ];

Property SYMHisDesc As %String [ SqlColumnNumber = 5, SqlFieldName = SYM_HisDesc ];

Property SYMHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = SYM_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHSYMCON(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHSYMCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SYM_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYM_HisCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HisCodeIndex">
<Global>^DHCPHSYMCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SYM_HisCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="SYM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SYM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SYM_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SYM_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SYM_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHSYMCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SYM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SYM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SYM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSymptomConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
