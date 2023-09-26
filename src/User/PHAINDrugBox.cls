Class User.PHAINDrugBox Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = PHAIN_DrugBox, StorageStrategy = CacheSQLStorage ]
{

/// 代码
Property PINDBCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PINDB_Code ];

/// 代码
Property PINDBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PINDB_Desc ];

/// 药房
Property PINDBLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PINDB_Loc_Dr ];

/// 备注
Property PINDBRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PINDB_Remark ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.DRUGBOX(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PINDB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINDB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINDB_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PINDB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CF.PHA.IN.DRUGBOX</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PINDB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PINDB_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CF.PHA.IN.DRUGBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PINDB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PINDB_Code})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PINDB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CF.PHA.IN.DRUGBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PINDB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PINDB_Desc})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PINDB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CF.PHA.IN.DRUGBOXi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PINDB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PINDB_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PINDB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PINDB_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINDrugBoxS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
