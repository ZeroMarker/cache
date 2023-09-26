Class User.DHCINVAliTradeSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IAD_RowID, SqlTableName = DHC_INVAliTradeSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IADSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVBankTradePay Parent Reference
Relationship IADIAPParRef As User.DHCINVAliTradePay [ Cardinality = parent, Inverse = ChildDHCINVAliTradeSub, Required, SqlFieldName = IAD_IAP_ParRef ];

/// IAD_Sub
Property IADSub As %Library.Float [ InitialExpression = {$i(^DHCINVALITP($p(%d(0),$c(1)),"D",0))}, SqlColumnNumber = 2, SqlFieldName = IAD_Sub ];

/// IAD_OEORDER
Property IADOEORDER As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IAD_OEORDER ];

/// IAD_ArmDesc
Property IADArmDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IAD_ArmDesc ];

/// IAD_ArmStatus
Property IADArmStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IAD_ArmStatus ];

/// IAD_Price
Property IADPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IAD_Price ];

/// IAD_Qty
Property IADQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IAD_Qty ];

/// IAD_TotalAmt
Property IADTotalAmt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IAD_TotalAmt ];

/// IAD_DiscAmount
Property IADDiscAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IAD_DiscAmount ];

/// IAD_PayorShare
Property IADPayorShare As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IAD_PayorShare ];

/// IAD_PatientShare
Property IADPatientShare As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IAD_PatientShare ];

Property IADNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IAD_Note1 ];

Property IADNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IAD_Note2 ];

Property IADNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IAD_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IAD_ArmDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IAD_ArmStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IAD_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IAD_Note1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IAD_Note2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IAD_Note3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IAD_OEORDER">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IAD_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IAD_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IAD_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IAD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IAD_TotalAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINVALITP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVAliTradePay.IAP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IAD_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_INVAliTradePay.IAP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IAD_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVAliTradeSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
