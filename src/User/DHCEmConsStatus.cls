Class User.DHCEmConsStatus Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ECS_RowID, SqlTableName = DHC_EmConsStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ECS_Code
Property ECSCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ECS_Code ];

/// ECS_Desc
Property ECSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ECS_Desc ];

/// 是否可用  ECS_ActiveFlag
Property ECSActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ECS_ActiveFlag ];

/// 集团化医院  ECS_Hosp_Dr
Property ECSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = ECS_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEMCONS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ECS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ECS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ECS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ECS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMCONS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ECS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ECS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMCONS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ECS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ECS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMCONS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ECS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ECS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ECS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
