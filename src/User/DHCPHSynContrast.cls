///  证型对照
/// 编写者:基础数据平台组-谷雪萍
/// 编写日期: 2016-7-18
Class User.DHCPHSynContrast Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlRowIdName = PHSYC_RowId, SqlTableName = DHC_PHSynContrast, StorageStrategy = SQLStorage ]
{

// ^DHCPHSYNCON

Property PHSYCCode As %String [ SqlColumnNumber = 2, SqlFieldName = PHSYC_Code ];

Property PHSYCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PHSYC_Desc ];

Property PHSYCHisCode As %String [ SqlColumnNumber = 4, SqlFieldName = PHSYC_HisCode ];

Property PHSYCHisDesc As %String [ SqlColumnNumber = 5, SqlFieldName = PHSYC_HisDesc ];

Property PHSYCHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = PHSYC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHSYNCON(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^DHCPHSYNCON</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHSYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSYC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSYC_HisCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHSYC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="HisCodeIndex">
<Global>^DHCPHSYNCON</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSYC_HisCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSYC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHSYC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSYC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSYC_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHSYC_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHSYC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHSYNCON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSYC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHSYC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHSYC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPHSynContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
