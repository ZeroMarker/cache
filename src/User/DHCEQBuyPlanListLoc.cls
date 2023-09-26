Class User.DHCEQBuyPlanListLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BPLL_RowID, SqlTableName = DHC_EQBuyPlanListLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BPLL_BuyPlanListDR
Property BPLLBuyPlanListDR As User.DHCEQBuyPlanList [ SqlColumnNumber = 2, SqlFieldName = BPLL_BuyPlanListDR ];

/// BPLL_BuyRequestListDR
Property BPLLBuyRequestListDR As User.DHCEQBuyRequestList [ SqlColumnNumber = 3, SqlFieldName = BPLL_BuyRequestListDR ];

/// BPLL_BuyLocDR
Property BPLLBuyLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BPLL_BuyLocDR ];

/// BPLL_Quantity
Property BPLLQuantity As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = BPLL_Quantity ];

/// BPLL_Remark
Property BPLLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BPLL_Remark ];

/// BPLL_Hold1
Property BPLLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BPLL_Hold1 ];

/// BPLL_Hold2
Property BPLLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BPLL_Hold2 ];

/// BPLL_Hold3
Property BPLLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BPLL_Hold3 ];

/// BPLL_Hold4
Property BPLLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BPLL_Hold4 ];

/// BPLL_Hold5
Property BPLLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BPLL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyPlanListLoc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BPLL_BuyLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BPLL_BuyPlanListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BPLL_BuyRequestListDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BPLL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BPLL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BPLL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BPLL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BPLL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BPLL_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BPLL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQBuyPlanListLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BPLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BPLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyPlanList">
<Global>^DHCEQBuyPlanListLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BPLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyPlanList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BPLL_BuyPlanListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BPLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyPlanListLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
