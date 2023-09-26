Class User.DHCEmScoreItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SCORE_RowID, SqlTableName = DHC_EmScoreItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SCOREChildSub [ IdKey, PrimaryKey, Unique ];

/// User.DHCEmScore Parent Reference SCORE_Itm_ParRef
Relationship SCOREItmParRef As User.DHCEmScore [ Cardinality = parent, Inverse = ChildDHCEMSCOREITM, Required, SqlFieldName = SCORE_Itm_ParRef ];

/// SCORE_ChildSub
Property SCOREChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SCORE_ChildSub ];

/// 总分  SCORE_Score
Property SCOREScore As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SCORE_Score ];

/// 评分类型  SCORE_TypeCode
Property SCORETypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SCORE_TypeCode ];

/// 评分项目ID  SCORE_Item_Dr
Property SCOREItemDr As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SCORE_Item_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DateMaster">
<Data name="SCORE_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCORE_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCORE_Itm_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCORE_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCORE_TypeCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMSCORE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmScore.SCORE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCORE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmScore.SCORE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCORE_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmScoreItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
