Class User.DHCEmPatStatusAcc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PSA_RowId, SqlTableName = DHC_EmPatStatusAcc, StorageStrategy = SQLStorage ]
{

/// 主表ID PSA_Status_Dr
Property PSAStatusDr As User.DHCPACVisitStatus [ SqlColumnNumber = 2, SqlFieldName = PSA_Status_Dr ];

/// 类型
Property PSAType As %Library.String(DISPLAYLIST = ",SS_Group,SS_User,DHC", MAXLEN = 8, SELECTIVITY = "20.0000%", VALUELIST = ",G,U,D") [ SqlColumnNumber = 3, SqlFieldName = PSA_Type ];

/// 指针
Property PSAPointer As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PSA_Pointer ];

/// 集团化医院  PSA_Hosp_Dr
Property PSAHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PSA_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMPSA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PSA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PSA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PSA_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSA_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMPSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PSA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PSA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCEMPSA</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSA_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSA_Status_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PSA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEMPSA</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSA_Status_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEMPSA</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PSA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PSA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatStatusAccS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
