Class User.PHCDrgIngredIndex Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DII_RowID, SqlTableName = PHC_DrgIngredIndex, StorageStrategy = SQLStorage ]
{

Relationship ChildPHCDrgIngrIndItm As PHCDrgIngrIndItm [ Cardinality = children, Inverse = DIIIParRef ];

/// Code
Property DIICode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DII_Code ];

/// Description
Property DIIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DII_Desc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PHCDrgIngredIndex(0))</SqlIdExpression>
<SQLMap name="CodeIndex">
<Global>^PHCDII</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DII_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DescIndex">
<Global>^PHCDII</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DII_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PHCDIIMasterIndex">
<Data name="DII_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DII_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCDII</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DII_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DII_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHCDrgIngredIndexS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
