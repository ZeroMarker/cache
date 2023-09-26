Class User.DHCAppCutBas Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AC_RowID, SqlTableName = DHC_AppCutBas, StorageStrategy = SQLStorage ]
{

/// 代码 AC_Code
Property ACCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = AC_Code ];

/// 描述 AC_Desc
Property ACDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = AC_Desc ];

/// 医院标识 AC_Hosp_Dr
Property ACHospDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = AC_Hosp_Dr ];

/// 是否可用 AC_ActiveFlag
Property ACActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AC_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPCB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPCB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AC_RwoID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPCB</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPCB</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppCutBasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
