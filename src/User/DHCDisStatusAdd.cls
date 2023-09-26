Class User.DHCDisStatusAdd Extends %Library.Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SA_RowId, SqlTableName = DHC_DisStatusAdd, StorageStrategy = SQLStorage ]
{

/// 代码  SA_Code
Property SACode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = SA_Code ];

/// 描述  SA_Desc
Property SADesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = SA_Desc ];

/// 激活标志  SA_ActiveFlag
Property SAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SA_ActiveFlag ];

/// 必须流程  SA_MustFlag
Property SAMustFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SA_MustFlag ];

/// 科室  SA_Loc_Dr
Property SALocDr As User.DHCDisNodeLoc [ SqlColumnNumber = 6, SqlFieldName = SA_Loc_Dr ];

/// 类型  SA_Type
Property SAType As User.DHCDisTypeAdd [ SqlColumnNumber = 7, SqlFieldName = SA_Type ];

/// 集团化医院  SA_Hosp_Dr
Property SAHospDr As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = SA_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISSA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SA_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SA_MustFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SA_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDISSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCDISSA</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDISSA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodeTypeHosp">
<Global>^DHCDISSA</Global>
<RowIdSpec name="1">
<Expression>L4</Expression>
<Field>SA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CodeTypeHosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SA_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTpeCode">
<Global>^DHCDISSA</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SA_Code}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeMulCode">
<Global>^DHCDISSA</Global>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeMulCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SA_ActiveFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SA_MustFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SA_Code}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisStatusAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
