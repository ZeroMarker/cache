Class User.DHCEQInStockListLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ISLL_RowID, SqlTableName = DHC_EQInStockListLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ISLL_InStockListDR
Property ISLLInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 2, SqlFieldName = ISLL_InStockListDR ];

/// ISLL_ContractListLocDR
Property ISLLContractListLocDR As User.DHCEQContractListLoc [ SqlColumnNumber = 3, SqlFieldName = ISLL_ContractListLocDR ];

/// ISLL_BuyLocDR
Property ISLLBuyLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 4, SqlFieldName = ISLL_BuyLocDR ];

/// ISLL_Quantity
Property ISLLQuantity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ISLL_Quantity ];

/// ISLL_LeaveFactoryNo
Property ISLLLeaveFactoryNo As %Library.String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = ISLL_LeaveFactoryNo ];

/// ISLL_FileNo
Property ISLLFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ISLL_FileNo ];

/// ISLL_Remark
Property ISLLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ISLL_Remark ];

/// ISLL_Hold1
Property ISLLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ISLL_Hold1 ];

/// ISLL_Hold2
Property ISLLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ISLL_Hold2 ];

/// ISLL_Hold3
Property ISLLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ISLL_Hold3 ];

/// ISLL_Hold4
Property ISLLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ISLL_Hold4 ];

/// ISLL_Hold5
Property ISLLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ISLL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInStockListLoc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ISLL_BuyLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISLL_ContractListLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISLL_FileNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISLL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ISLL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ISLL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ISLL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ISLL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ISLL_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISLL_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ISLL_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISLL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQInStockListLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ISLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQInStockListLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ISLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISLL_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ISLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInStockListLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
