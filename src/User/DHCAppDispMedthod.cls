Class User.DHCAppDispMedthod Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlRowIdName = AD_RowID, SqlTableName = DHC_AppDispMedthod, StorageStrategy = SQLStorage ]
{

/// 代码
Property ADCode As %String [ SqlColumnNumber = 2, SqlFieldName = AD_Code ];

/// 描述
Property ADDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AD_Desc ];

/// 是否可用
Property ADActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AD_ActiveFlag ];

/// 上一级rowid
Property ADHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AD_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPDIM(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPDIM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AD_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AD_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPDIM</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AD_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AD_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="AD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AD_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCAPDIM</Global>
<RowIdSpec name="1">
<Field>AD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AD_RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppDispMedthodS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
