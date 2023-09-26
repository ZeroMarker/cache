Class User.DHCEmGCS Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = GCS_RowId, SqlTableName = DHC_EmGCS, StorageStrategy = SQLStorage ]
{

/// 项目描述 GCS_ItmDesc
Property GCSItmDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = GCS_ItmDesc ];

/// 项目代码 GCS_ItmCode
Property GCSItmCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = GCS_ItmCode ];

/// 是否可用 GCS_ActiveFlag
Property GCSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = GCS_ActiveFlag ];

/// 集团化医院 GCS_Hosp_Dr
Property GCSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = GCS_Hosp_Dr ];

Relationship ChildDHCEMGCSITEM As User.DHCEmGCSItem [ Cardinality = children, Inverse = GCSParRefDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMGCS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GCS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GCS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GCS_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GCS_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMGCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GCS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{GCS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMGCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GCS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCS_ItmCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GCS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMGCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GCS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCS_ItmDesc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GCS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexCodeHos">
<Global>^DHCEMGCS</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CodeHos"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCS_ItmCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GCS_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GCS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmGCSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
