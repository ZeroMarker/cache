Class User.DHCRBExamGroupItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCRB_ExamGroupItem, SqlTableName = DHCRB_ExamGroupItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On childsub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_ExamGroup Parent Reference
Relationship DHCRBExamGroup As User.DHCRBExamGroup [ Cardinality = parent, Inverse = ChildDHCRBExamGroupItem, Required, SqlFieldName = DHCRB_ExamGroup ];

/// Child subscript
Property childsub As %Library.Float [ InitialExpression = {$i(^mdata("DHCRBEXAMGROUPITEM"))}, Required, SqlColumnNumber = 2 ];

/// DREGI_ItmMast_DR
Property DREGIItmMastDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DREGI_ItmMast_DR ];

/// DREGI_ItemCode
Property DREGIItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DREGI_ItemCode ];

/// DREGI_ItemDesc
Property DREGIItemDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DREGI_ItemDesc ];

/// DREGI_BodyCode
Property DREGIBodyCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DREGI_BodyCode ];

/// DREGI_BodyDR
Property DREGIBodyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DREGI_BodyDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DREGI_BodyCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DREGI_BodyDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DREGI_ItemCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DREGI_ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DREGI_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCRBExamGroup</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_ExamGroup.DREG_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExamItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_ExamGroup.DREG_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItmMast">
<Global>^DHCRBExamGroup</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCRB_ExamGroup.DREG_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemMastIndex"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DREGI_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCRB_ExamGroup.DREG_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBExamGroupItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
