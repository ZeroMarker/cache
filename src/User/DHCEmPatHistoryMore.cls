Class User.DHCEmPatHistoryMore Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = PHIM_RowId, SqlTableName = DHC_EmPatHistoryMore, StorageStrategy = NewStorage1 ]
{

/// 代码  PHIM_Code
Property PHIMCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PHIM_Code ];

/// 描述  PHIM_Desc
Property PHIMDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PHIM_Desc ];

/// 是否可用  PHIM_ActiveFlag
Property PHIMActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PHIM_ActiveFlag ];

/// 集团化医院  PHIM_Hosp_Dr
Property PHIMHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PHIM_Hosp_Dr ];

/// 类型  PHIM_Type
Property PHIMType As %Text(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = PHIM_Type ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPHIM)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMPHIM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHIM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHIM_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHIM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMPHIM</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHIM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHIM_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHIM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PHIM_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHIM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHIM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHIM_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHIM_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMPHIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHIM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHIM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHIM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCEmPatHistoryMoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
