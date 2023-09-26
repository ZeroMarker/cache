Class User.DHCEQContractAffix Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CA_RowID, SqlTableName = DHC_EQContractAffix, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CA_ContractListDR
Property CAContractListDR As User.DHCEQContractList [ SqlColumnNumber = 2, SqlFieldName = CA_ContractListDR ];

/// CA_AffixDR
Property CAAffixDR As User.DHCEQCAffix [ SqlColumnNumber = 3, SqlFieldName = CA_AffixDR ];

/// CA_AffixCatDR
Property CAAffixCatDR As User.DHCEQCAffixCat [ SqlColumnNumber = 4, SqlFieldName = CA_AffixCatDR ];

/// CA_PartSpec
Property CAPartSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CA_PartSpec ];

/// CA_PartModel
Property CAPartModel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CA_PartModel ];

/// CA_ManuFactoryDR
Property CAManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = CA_ManuFactoryDR ];

/// CA_QuantityNum
Property CAQuantityNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = CA_QuantityNum ];

/// CA_ReceiverDR
Property CAReceiverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CA_ReceiverDR ];

/// CA_LeaveFacNo
Property CALeaveFacNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CA_LeaveFacNo ];

/// CA_LeaveDate
Property CALeaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = CA_LeaveDate ];

/// CA_PriceFee
Property CAPriceFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = CA_PriceFee ];

/// CA_Remark
Property CARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CA_Remark ];

/// CA_CurrencyDR
Property CACurrencyDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CA_CurrencyDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQContractAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CA_AffixCatDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CA_AffixDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CA_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CA_CurrencyDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CA_LeaveDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CA_LeaveFacNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CA_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CA_PartModel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CA_PartSpec">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CA_PriceFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CA_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CA_ReceiverDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQContractAffix</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContractList">
<Global>^DHCEQContractAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ContractList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_ContractListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQContractAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
