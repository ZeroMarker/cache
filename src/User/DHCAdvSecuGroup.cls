Class User.DHCAdvSecuGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SECUG_RowId, SqlTableName = DHC_AdvSecuGroup, StorageStrategy = SQLStorage ]
{

/// 代码  SECU_Code
Property SECUCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = SECU_Code ];

/// 描述  SECU_Desc
Property SECUDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = SECU_Desc ];

/// 所在医院  SECU_Hosp_Dr
Property SECUHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = SECU_Hosp_Dr ];

/// 启用标志  SECU_ActiveFlag
Property SECUActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SECU_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVSECUG)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVSECUG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SECUG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SECU_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SECUG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<BlockCount>1</BlockCount>
<Data name="SECU_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SECU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SECU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SECU_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVSECUG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SECUG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SECUG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvSecuGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
