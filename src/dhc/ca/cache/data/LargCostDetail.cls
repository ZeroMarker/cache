Class dhc.ca.cache.data.LargCostDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LargCostDetail_rowid, SqlTableName = LargCostDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LargCostDetailchildSub [ IdKey, PrimaryKey, Unique ];

/// LargCost Parent Reference
Relationship LargCostDetailparRef As dhc.ca.cache.data.LargCost [ Cardinality = parent, Inverse = ChildLargCostDetail, Required, SqlFieldName = LargCostDetail_parRef ];

/// LargCostDetail_childSub
Property LargCostDetailchildSub As %Library.Float [ InitialExpression = {$i(^DHCCALARGCOST($p(%d(0),$c(1),1),"Detail",0))}, SqlColumnNumber = 2, SqlFieldName = LargCostDetail_childSub ];

/// LargCostDetail_date
Property LargCostDetaildate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = LargCostDetail_date ];

/// LargCostDetail_fee
Property LargCostDetailfee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = LargCostDetail_fee ];

/// LargCostDetail_flag
Property LargCostDetailflag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LargCostDetail_flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="LargCostDetail_date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LargCostDetail_fee">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LargCostDetail_flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCALARGCOST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LargCost.LargCost_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LargCostDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{LargCost.LargCost_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCostDetail_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCCALARGCOST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>LargCost.LargCost_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LargCostDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DetailDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LargCost.LargCost_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LargCostDetail_date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LargCostDetail_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LargCostDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
