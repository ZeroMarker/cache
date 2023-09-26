Class User.DHCAdvInterfaceCol Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AFC_RowID, SqlTableName = DHC_AdvInterfaceCol, StorageStrategy = SQLStorage ]
{

/// 代码 AFC_Code
Property AFCCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = AFC_Code ];

/// 描述 AFC_Desc
Property AFCDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = AFC_Desc ];

/// 可用标识 AFC_ActiveFlag
Property AFCActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AFC_ActiveFlag ];

/// 医院 AFC_HospDr 2021-04-14 多院区改造 cy
Property AFCHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AFC_HospDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVAFC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCADVAFC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AFC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AFC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AFC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCADVAFC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AFC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AFC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AFC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="AFC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AFC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AFC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AFC_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVAFC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AFC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AFC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvInterfaceColS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
