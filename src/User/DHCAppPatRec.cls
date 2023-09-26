Class User.DHCAppPatRec Extends %Persistent [ SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPatRec, StorageStrategy = SQLStorage ]
{

/// 代码 AP_Code
Property APCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = AP_Code ];

/// 描述 AP_Desc
Property APDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = AP_Desc ];

/// 医院标识 AP_Hosp_Dr
Property APHospDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = AP_Hosp_Dr ];

/// 是否可用 AP_ActiveFlag
Property APActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AP_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPPR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPPR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPatRecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
