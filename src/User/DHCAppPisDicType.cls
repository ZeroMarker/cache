Class User.DHCAppPisDicType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AP_RowID, SqlTableName = DHC_AppPisDicType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AP_Code  代码
Property APCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AP_Code ];

/// AP_Desc  描述
Property APDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AP_Desc ];

/// 是否可用  AP_ActiveFlag
Property APActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AP_ActiveFlag ];

/// 集团化医院  AP_Hosp_Dr
Property APHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AP_Hosp_Dr ];

/// 是否启用申请单授权  AP_ActiveFlag
Property APMapCodeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = AP_MapCodeFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCAPPPDT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Piece>4</Piece>
</Data>
<Data name="AP_MapCodeFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCAPPPDT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPPDT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPPDT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AP_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPisDicTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
