Class User.DHCEmPatSource Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PS_RowID, SqlTableName = DHC_EmPatSource, StorageStrategy = SQLStorage ]
{

/// 代码  PH_Code
Property PSCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PS_Code ];

/// 描述  PH_Desc
Property PSDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PS_Desc ];

/// 是否可用  PH_ActiveFlag
Property PSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PS_ActiveFlag ];

/// 集团化医院  PH_Hosp_Dr
Property PSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PS_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPSO)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMPSO</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPSO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatSourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
