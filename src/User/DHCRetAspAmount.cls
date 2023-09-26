/// DHC_RetAmount
Class User.DHCRetAspAmount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RETA_RowId, SqlTableName = DHC_RetAspAmount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RETA_INCI_DR
Property RETAINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = RETA_INCI_DR ];

/// RETA_CTLOC_DR
Property RETACTLOCDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = RETA_CTLOC_DR ];

/// RETA_AdjPrice
Property RETAAdjPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RETA_AdjPrice ];

/// RETA_Qty
Property RETAQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = RETA_Qty ];

/// RETA_Amount
Property RETAAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RETA_Amount ];

/// RETA_SSUSR_DR
Property RETASSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = RETA_SSUSR_DR ];

/// RETA_Date
Property RETADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = RETA_Date ];

/// RETA_Time
Property RETATime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = RETA_Time ];

/// RETA_Pointer
Property RETAPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RETA_Pointer ];

/// RETA_Type
Property RETAType As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "50.0000%", TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RETA_Type ];

/// RETA_RpDiff
Property RETARpDiff As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = RETA_RpDiff ];

/// RETA_RpAmt
Property RETARpAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = RETA_RpAmt ];

/// RETA_Uom_Dr
Property RETAUomDr As User.CTUOM [ SqlColumnNumber = 14, SqlFieldName = RETA_Uom_Dr ];

/// RETA_INCLB_DR
Property RETAINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 15, SqlFieldName = RETA_INCLB_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^RETA(0))</SqlIdExpression>
<SQLMap name="DataMasterRetAmount">
<Data name="RETA_AdjPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RETA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RETA_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RETA_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RETA_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RETA_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RETA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RETA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RETA_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RETA_RpDiff">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RETA_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RETA_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RETA_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RETA_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCRETA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RETA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RETA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInciLocTypeDate">
<Global>^DHCRETA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>RETA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCILOCTD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RETA_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RETA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RETA_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RETA_Date}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RETA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncilLocDate">
<Global>^DHCRETA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RETA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCILOCD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RETA_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RETA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RETA_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RETA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCRETA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RETA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RETA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RETA_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RETA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTypeDate">
<Global>^DHCRETA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RETA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCTYPEDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RETA_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RETA_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RETA_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RETA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCRETA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RETA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RETA_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RETA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RETA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRetAspAmountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
