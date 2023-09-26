/// DRG Codes(1437)
Class User.MRCDRGCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGCodes, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCDRGCodesVersion As MRCDRGCodesVersion [ Cardinality = children, Inverse = VERParRef ];

/// Code
Property DRGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DRG_Code ];

/// Description
Property DRGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DRG_Desc ];

/// Des Ref DRG Type
Property DRGDRGTypeDR As MRCDRGType [ SqlColumnNumber = 4, SqlFieldName = DRG_DRGType_DR ];

/// Des Ref DRGCateg
Property DRGDRGCategDR As MRCDRGCategory [ SqlColumnNumber = 5, SqlFieldName = DRG_DRGCateg_DR ];

/// Long Description
Property DRGLongDescription As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DRG_LongDescription ];

/// DateFrom
Property DRGDateFrom As %Date [ SqlColumnNumber = 7, SqlFieldName = DRG_DateFrom ];

/// DateTo
Property DRGDateTo As %Date [ SqlColumnNumber = 8, SqlFieldName = DRG_DateTo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("DRG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DRG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRG_DRGCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRG_DRGType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRG_LongDescription">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DRG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRG_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
