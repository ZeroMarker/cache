Class User.DHCEmPatHistory Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PH_RowID, SqlTableName = DHC_EmPatHistory, StorageStrategy = SQLStorage ]
{

/// 代码  PH_Code
Property PHCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PH_Code ];

/// 描述  PH_Desc
Property PHDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PH_Desc ];

/// 是否可用  PH_ActiveFlag
Property PHActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PH_ActiveFlag ];

/// 集团化医院  PH_Hosp_Dr
Property PHHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PH_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPHI)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMPHI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PH_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PH_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PH_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PH_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPHI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
