Class User.DHCEQContractListLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CLL_RowID, SqlTableName = DHC_EQContractListLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CLL_ContractListDR
Property CLLContractListDR As User.DHCEQContractList [ SqlColumnNumber = 2, SqlFieldName = CLL_ContractListDR ];

/// CLL_BuyPlanListLocDR
Property CLLBuyPlanListLocDR As User.DHCEQBuyPlanListLoc [ SqlColumnNumber = 3, SqlFieldName = CLL_BuyPlanListLocDR ];

/// CLL_BuyRequestListDR
Property CLLBuyRequestListDR As User.DHCEQBuyRequestList [ SqlColumnNumber = 4, SqlFieldName = CLL_BuyRequestListDR ];

/// CLL_BuyLocDR
Property CLLBuyLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CLL_BuyLocDR ];

/// CLL_Quantity
Property CLLQuantity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CLL_Quantity ];

/// CLL_ArrivedQuantity
Property CLLArrivedQuantity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CLL_ArrivedQuantity ];

/// CLL_Remark
Property CLLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CLL_Remark ];

/// CLL_Hold1
Property CLLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CLL_Hold1 ];

/// CLL_Hold2
Property CLLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CLL_Hold2 ];

/// CLL_Hold3
Property CLLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CLL_Hold3 ];

/// CLL_Hold4
Property CLLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CLL_Hold4 ];

/// CLL_Hold5
Property CLLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CLL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQContractListLoc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CLL_ArrivedQuantity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CLL_BuyLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CLL_BuyPlanListLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CLL_BuyRequestListDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CLL_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CLL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CLL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CLL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CLL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CLL_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CLL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQContractListLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{CLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContractList">
<Global>^DHCEQContractListLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ContractList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CLL_ContractListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContractListLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
