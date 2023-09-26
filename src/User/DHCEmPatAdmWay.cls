Class User.DHCEmPatAdmWay Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PAW_RowID, SqlTableName = DHC_EmPatAdmWay, StorageStrategy = SQLStorage ]
{

/// 代码  PAW_Code
Property PAWCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PAW_Code ];

/// 描述  PAW_Desc
Property PAWDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PAW_Desc ];

/// 是否可用  PAW_ActiveFlag
Property PAWActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PAW_ActiveFlag ];

/// 集团化医院  PAW_Hosp_Dr
Property PAWHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PAW_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPADW)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMPADW</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAW_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAW_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PAW_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAW_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAW_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAW_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPADW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAW_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PAW_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatAdmWayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
