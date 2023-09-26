Class User.DHCASPAmount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASPA_Rowid, SqlTableName = DHC_ASPAmount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCASPAmountLB As User.DHCASPAmountLB [ Cardinality = children, Inverse = ASPALBASPAParref ];

/// ASPA_No
Property ASPANo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ASPA_No ];

/// ASPA_CTLOC_DR
Property ASPACTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = ASPA_CTLOC_DR ];

/// ASPA_AdjPrice
Property ASPAAdjPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ASPA_AdjPrice ];

/// ASPA_INASP_DR
Property ASPAINASPDR As User.INAdjSalePrice [ SqlColumnNumber = 5, SqlFieldName = ASPA_INASP_DR ];

/// ASPA_INCI_DR
Property ASPAINCIDR As User.INCItm [ SqlColumnNumber = 6, SqlFieldName = ASPA_INCI_DR ];

/// ASPA_StkQty
Property ASPAStkQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ASPA_StkQty ];

/// ASPA_Amount
Property ASPAAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ASPA_Amount ];

/// ASPA_Date
Property ASPADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = ASPA_Date ];

/// ASPA_Time
Property ASPATime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = ASPA_Time ];

/// ASPA_SSUSR_DR
Property ASPASSUSRDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = ASPA_SSUSR_DR ];

/// ASPA_AdjRP
Property ASPAAdjRP As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ASPA_AdjRP ];

/// ASPA_RPAmt
Property ASPARPAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ASPA_RPAmt ];

/// ASPA_INAPB_Dr
Property ASPAINAPBDr As User.INAdjPriceBatch [ SqlColumnNumber = 14, SqlFieldName = ASPA_INAPB_Dr ];

/// ASPA_INCLB_Dr
Property ASPAINCLBDr As User.INCItmLcBt [ SqlColumnNumber = 15, SqlFieldName = ASPA_INCLB_Dr ];

/// 付款ID
Property ASPAPAYDr As User.DHCPay [ SqlColumnNumber = 16, SqlFieldName = ASPA_PAY_Dr ];

/// ASPA_ASPDetailDr
Property ASPAASPDetailDr As User.DHCINASPDetail [ SqlColumnNumber = 17, SqlFieldName = ASPA_ASPDetail_Dr ];

/// ASPA_TranType
Property ASPATranType As %Library.String [ SqlColumnNumber = 18, SqlFieldName = ASPA_TranType ];

/// ASPA_ASPTran_Dr
Property ASPATranDr As %Library.String [ SqlColumnNumber = 19, SqlFieldName = ASPA_ASPTran_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^ASPA)</SqlIdExpression>
<SQLMap name="DataMasterASPA">
<Data name="ASPA_ASPDetail_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ASPA_ASPTran_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ASPA_AdjPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASPA_AdjRP">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ASPA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASPA_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASPA_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ASPA_INAPB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ASPA_INASP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ASPA_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASPA_INCLB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ASPA_No">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ASPA_PAY_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ASPA_RPAmt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ASPA_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASPA_StkQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASPA_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ASPA_TranType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^ASPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ASPA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ASPA_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ASPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ASPA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPA_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASPA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateINCIL">
<Global>^ASPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ASPA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATEINCIL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ASPA_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ASPA_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ASPA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{ASPA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINAPBLoc">
<Global>^ASPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ASPA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INAPB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ASPA_INAPB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ASPA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ASPA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINASP">
<Global>^ASPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ASPA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ASPLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ASPA_INASP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ASPA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ASPA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeTrans">
<Global>^ASPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ASPA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TranType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ASPA_TranType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"Trans"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ASPA_ASPTran_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{ASPA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCASPAmountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^ASPA)
	s oldI = +$g(^mdata("DHCASPAMOUNT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^ASPA = maxI
	s ^mdata("DHCASPAMOUNT") = maxI
}

}
