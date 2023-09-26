Class User.DHCDisServiceGroup Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SERG_RowID, SqlTableName = DHC_DisServiceGroup, StorageStrategy = SQLStorage ]
{

/// 代码  SERG_Code
Property SERGCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SERG_Code ];

/// 描述  SERG_Desc
Property SERGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SERG_Desc ];

/// 是否可用  SERG_ActiveFlag	
Property SERGActiveFlag As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SERG_ActiveFlag ];

/// 集团化医院  SERG_Hosp_Dr
Property SERGHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = SERG_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISSERG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SERG_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SERG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SERG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SERG_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISSERG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SERG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SERG_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDISSERG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SERG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SERG_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SERG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDISSERG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SERG_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SERG_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SERG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisServiceGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
