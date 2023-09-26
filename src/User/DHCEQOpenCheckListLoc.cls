Class User.DHCEQOpenCheckListLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OCLL_RowID, SqlTableName = DHC_EQOpenCheckListLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OCLL_OpenCheckListDR
Property OCLLOpenCheckListDR As User.DHCEQOpenCheckList [ SqlColumnNumber = 2, SqlFieldName = OCLL_OpenCheckListDR ];

/// OCLL_ContractListLocDR
Property OCLLContractListLocDR As User.DHCEQContractListLoc [ SqlColumnNumber = 3, SqlFieldName = OCLL_ContractListLocDR ];

/// OCLL_BuyLocDR
Property OCLLBuyLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 4, SqlFieldName = OCLL_BuyLocDR ];

/// OCLL_Quantity
Property OCLLQuantity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OCLL_Quantity ];

/// OCLL_LeaveFactoryNo
Property OCLLLeaveFactoryNo As %Library.String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = OCLL_LeaveFactoryNo ];

/// OCLL_FileNo
Property OCLLFileNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OCLL_FileNo ];

/// OCLL_Remark
Property OCLLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OCLL_Remark ];

/// OCLL_Hold1
Property OCLLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OCLL_Hold1 ];

/// OCLL_Hold2
Property OCLLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OCLL_Hold2 ];

/// OCLL_Hold3
Property OCLLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OCLL_Hold3 ];

/// OCLL_Hold4
Property OCLLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = OCLL_Hold4 ];

/// OCLL_Hold5
Property OCLLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = OCLL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOpenCheckListLoc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OCLL_BuyLocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OCLL_ContractListLocDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OCLL_FileNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OCLL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OCLL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OCLL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OCLL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OCLL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OCLL_LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OCLL_OpenCheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OCLL_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OCLL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQOpenCheckListLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OCLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{OCLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOpenCheckList">
<Global>^DHCEQOpenCheckListLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OCLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OpenCheckList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OCLL_OpenCheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OCLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOpenCheckListLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
