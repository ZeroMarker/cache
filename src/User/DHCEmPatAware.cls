Class User.DHCEmPatAware Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PA_RowID, SqlTableName = DHC_EmPatAware, StorageStrategy = SQLStorage ]
{

/// 代码 PA_Code
Property PACode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PA_Code ];

/// 描述 PA_Desc
Property PADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PA_Desc ];

/// 是否可用 PA_ActiveFlag
Property PAActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PA_ActiveFlag ];

/// 集团化医院 PA_Hosp_Dr
Property PAHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PA_Hosp_Dr ];

/// 描述 PA_Desc
Property PAScore As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = PA_Score ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPAW)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PA_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMPAW</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMPAW</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PA_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatAwareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
