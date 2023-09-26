/// OE Annotation(2212)
Class User.OEAnnotation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_Annotation, StorageStrategy = SQLStorage ]
{

/// Des Ref MRPic
Property ANNOTMRPicDR As MRPictures [ SqlColumnNumber = 4, SqlFieldName = ANNOT_MRPic_DR ];

/// Des Ref OEOrdItem
Property ANNOTOEOrdItemDR As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = ANNOT_OEOrdItem_DR ];

/// Des Ref OEOrdRes
Property ANNOTOEOrdResDR As OEOrdResult [ SqlColumnNumber = 2, SqlFieldName = ANNOT_OEOrdRes_DR ];

/// Text
Property ANNOTText As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = ANNOT_Text, SqlListType = SUBNODE ];

Parameter EXTENTSIZE = 67;

Storage SQLStorage
{
<ExtentSize>67</ExtentSize>
<Property name="ANNOTMRPicDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANNOTOEOrdItemDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANNOTOEOrdResDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANNOTText">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^OEAN(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANNOT_MRPic_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANNOT_OEOrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANNOT_OEOrdRes_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANNOT_Text">
<Node>"TXT"</Node>
</Data>
<Global>^OEAN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ANNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ANNOT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMRPic">
<Global>^OEANi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MRPic"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANNOT_MRPic_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANNOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEOrdRes">
<Global>^OEANi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdRes"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANNOT_OEOrdRes_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANNOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeOrdItem">
<Global>^OEANi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ANNOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANNOT_OEOrdItem_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANNOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANNOT_RowId</SqlRowIdName>
<StreamLocation>^User.OEAnnotationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
