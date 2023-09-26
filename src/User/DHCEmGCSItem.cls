Class User.DHCEmGCSItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = GCS_RowId, SqlTableName = DHC_EmGCSItem, StorageStrategy = SQLStorage ]
{

/// 主表ID GCS_ParRef_Dr
Relationship GCSParRefDr As User.DHCEmGCS [ Cardinality = parent, Inverse = ChildDHCEMGCSITEM, Required, SqlFieldName = GCS_ParRef_Dr ];

/// 子表GCS_ChlidSub
Property GCSChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = GCS_ChlidSub ];

/// 项目代码 GCS_ItmCode	
Property GCSItmCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = GCS_ItmCode ];

/// 项目描述 GCS_ItmDesc	
Property GCSItmDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = GCS_ItmDesc ];

/// 分数 GCS_Score
Property GCSScore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = GCS_Score ];

/// 是否可用 GCS_ActiveFlag
Property GCSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = GCS_ActiveFlag ];

/// 集团化医院 GCS_Hosp_Dr
Property GCSHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = GCS_Hosp_Dr ];

Index RowIDBasedIDKeyIndex On GCSChildSub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="GCS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GCS_ChlidSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GCS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GCS_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GCS_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GCS_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GCS_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMGCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EMGCS.GCS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GCS_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmGCS.GCS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GCS_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMGCS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_EmGCS.GCS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GCS_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GCSCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_EmGCS.GCS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GCS_ItmDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GCS_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmGCSItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
