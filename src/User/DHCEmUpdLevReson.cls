Class User.DHCEmUpdLevReson Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ULR_RowID, SqlTableName = DHC_EmUpdLevReson, StorageStrategy = SQLStorage ]
{

/// 代码 ULR_Code
Property ULRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ULR_Code ];

/// 描述 ULR_Desc
Property ULRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ULR_Desc ];

/// 是否可用 ULR_ActiveFlag
Property ULRActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ULR_ActiveFlag ];

/// 集团化医院 ULR_Hosp_Dr
Property ULRHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = ULR_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMULR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ULR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ULR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ULR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ULR_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMULR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ULR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ULR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMULR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ULR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ULR_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ULR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmUpdLevResonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
