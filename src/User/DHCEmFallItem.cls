Class User.DHCEmFallItem Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = FALL_RowId, SqlTableName = DHC_EmFallItem, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On FALLChlidSub [ IdKey, PrimaryKey, Unique ];

/// 主表ID FALL_ParRef_Dr
Relationship FALLParRefDr As User.DHCEmFall [ Cardinality = parent, Inverse = ChildDHCEMFALLITEM, Required, SqlFieldName = FALL_ParRef_Dr ];

/// 子表Sub FALL_ChlidSub
Property FALLChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = FALL_ChlidSub ];

/// 项目代码 FALL_ItmCode
Property FALLItmCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = FALL_ItmCode ];

/// 项目描述 FALL_ItmDesc
Property FALLItmDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = FALL_ItmDesc ];

/// 分数 FALL_Score
Property FALLScore As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = FALL_Score ];

/// 是否可用 FALL_ActiveFlag
Property FALLActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = FALL_ActiveFlag ];

/// 集团化医院 FALL_Hosp_Dr
Property FALLHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = FALL_Hosp_Dr ];

Storage NewStorage1
{
<SQLMap name="Master">
<Data name="FALL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FALL_ChlidSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FALL_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FALL_ItmCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FALL_ItmDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FALL_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FALL_Score">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEMFALL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmFall.FALL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>FALL_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmFall.FALL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{FALL_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCEMFALL</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_EmFall.FALL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>FALL_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_EmFall.FALL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FALL_ItmCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FALL_ChlidSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmFallItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
