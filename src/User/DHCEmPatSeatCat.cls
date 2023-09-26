Class User.DHCEmPatSeatCat Extends %Persistent [ SqlRowIdName = PSC_RowID, SqlTableName = DHC_EmPatSeatCat, StorageStrategy = SQLStorage ]
{

/// 代码  PSC_Code
Property PSCCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PSC_Code ];

/// 描述  PSC_Desc
Property PSCDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PSC_Desc ];

/// 是否可用  PSC_ActiveFlag
Property PSCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PSC_ActiveFlag ];

/// 集团化医院  PSC_Hosp_Dr
Property PSCHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PSC_Hosp_Dr ];

/// 床位颜色  PSC_Color
Property PSCColor As %Text(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = PSC_Color ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPSC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMPSC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PSC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMPSC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PSC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSC_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PSC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PSC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSC_Color">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PSC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PSC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PSC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatSeatCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
