Class User.DHCEQSRentFee Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RF_RowID, SqlTableName = DHC_EQSRentFee, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RF_RentDR
Property RFRentDR As User.DHCEQSRent [ SqlColumnNumber = 2, SqlFieldName = RF_RentDR ];

/// RF_ResourceHistoryPriceDR
Property RFResourceHistoryPriceDR As User.DHCEQSCPriceType [ SqlColumnNumber = 3, SqlFieldName = RF_ResourceHistoryPriceDR ];

/// RF_MakeDate
Property RFMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = RF_MakeDate ];

/// RF_PriceTypeDR
Property RFPriceTypeDR As User.DHCEQSCPriceType [ SqlColumnNumber = 5, SqlFieldName = RF_PriceTypeDR ];

/// RF_Amount
Property RFAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RF_Amount ];

/// RF_UomQuantity
Property RFUomQuantity As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RF_UomQuantity ];

/// RF_UOMDR
Property RFUOMDR As User.DHCEQCUOM [ SqlColumnNumber = 8, SqlFieldName = RF_UOMDR ];

/// RF_Quantity
Property RFQuantity As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = RF_Quantity ];

/// RF_Price
Property RFPrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = RF_Price ];

/// RF_DiscountFee
Property RFDiscountFee As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = RF_DiscountFee ];

/// RF_CostFee
Property RFCostFee As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = RF_CostFee ];

/// RF_Remark
Property RFRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RF_Remark ];

/// RF_BillStatus
Property RFBillStatus As %Library.String(DISPLAYLIST = ",未结账,已结账,结账付费", MAXLEN = 3, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 14, SqlFieldName = RF_BillStatus ];

/// RF_BillListDR
Property RFBillListDR As User.DHCEQSBillList [ SqlColumnNumber = 15, SqlFieldName = RF_BillListDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSRentFee("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RF_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RF_BillListDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RF_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RF_CostFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RF_DiscountFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RF_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RF_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RF_PriceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RF_Quantity">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RF_RentDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RF_ResourceHistoryPriceDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RF_UOMDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RF_UomQuantity">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQSRentFee</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRent">
<Global>^DHCEQSRentFee</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Rent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RF_RentDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSRentFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
