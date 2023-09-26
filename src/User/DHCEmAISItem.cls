Class User.DHCEmAISItem Extends %Persistent [ SqlRowIdName = AIS_RowId, SqlTableName = DHC_EmAISItem, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On AISChlidSub [ IdKey, PrimaryKey, Unique ];

/// 主表ID AIS_ParRef_Dr
Relationship AISParRefDr As User.DHCEmAIS [ Cardinality = parent, Inverse = ChildDHCEMAISITEM, Required, SqlFieldName = AIS_ParRef_Dr ];

/// 子表Sub AIS_ChlidSub
Property AISChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AIS_ChlidSub ];

/// 项目代码 AIS_ItmCode
Property AISItmCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = AIS_ItmCode ];

/// 项目描述 AIS_ItmDesc
Property AISItmDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = AIS_ItmDesc ];

/// 分数 AIS_Score
Property AISScore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AIS_Score ];

/// 是否可用 AIS_ActiveFlag
Property AISActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = AIS_ActiveFlag ];

/// 集团化医院 AIS_Hosp_Dr
Property AISHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = AIS_Hosp_Dr ];

Storage NewStorage1
{
<SQLMap name="DataMaster">
<Data name="AIS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AIS_ChlidSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AIS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AIS_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AIS_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AIS_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AIS_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMAIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmAIS.AIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>AIS_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmAIS.AIS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AIS_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCEMAIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_EmAIS.AIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>AIS_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_EmAIS.AIS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AIS_ItmCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AIS_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmAISItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
