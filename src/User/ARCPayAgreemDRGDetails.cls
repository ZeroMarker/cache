/// ARC Pay Agreem DRG Details(1850)
Class User.ARCPayAgreemDRGDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemDRGDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCPayAgreemDRGDetAdd As ARCPayAgreemDRGDetAdd [ Cardinality = children, Inverse = ADDParRef ];

Relationship ChildARCPayAgreemDRGDetPDRates As ARCPayAgreemDRGDetPDRates [ Cardinality = children, Inverse = PDRParRef ];

/// ARC_PayAgreemDRG Parent Reference
Relationship DETParRef As ARCPayAgreemDRG [ Cardinality = parent, Inverse = ChildARCPayAgreemDRGDetails, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DRG",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Date From
Property DETDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DET_DateFrom ];

/// Date To
Property DETDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DET_DateTo ];

/// Aver Length Of Stay
Property DETAverLengthOfStay As %Float [ SqlColumnNumber = 5, SqlFieldName = DET_AverLengthOfStay ];

/// LS OutlierDays
Property DETLSOutlierDays As %Float [ SqlColumnNumber = 6, SqlFieldName = DET_LSOutlierDays ];

/// LS Outlier Benefit
Property DETLSOutlierBenefit As %Float [ SqlColumnNumber = 7, SqlFieldName = DET_LSOutlierBenefit ];

/// Price
Property DETPrice As %Float [ SqlColumnNumber = 8, SqlFieldName = DET_Price ];

/// Des Ref EpisBill
Property DETEpisBillDR As ARCEpisodicBilling [ SqlColumnNumber = 9, SqlFieldName = DET_EpisBill_DR ];

/// Des Ref Contract
Property DETContractDR As BLCContractDetails [ SqlColumnNumber = 10, SqlFieldName = DET_Contract_DR ];

/// Include Priv Suppl
Property DETIncludePrivSuppl As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DET_IncludePrivSuppl ];

/// Same Day Case Less the 6 Hours MV
Property DETSameDayCaseLess6HMV As %Float [ SqlColumnNumber = 12, SqlFieldName = DET_SameDayCaseLess6HMV ];

/// SameDayCase 6 and more HMV
Property DETSameDayCase6HMV As %Float [ SqlColumnNumber = 13, SqlFieldName = DET_SameDayCase6HMV ];

/// Overnight Flagfall
Property DETOvernightFlagfall As %Float [ SqlColumnNumber = 14, SqlFieldName = DET_OvernightFlagfall ];

/// Overnight Flagfall MV
Property DETOvernightFlagfallMV As %Float [ SqlColumnNumber = 15, SqlFieldName = DET_OvernightFlagfallMV ];

/// Mech Vent Rate
Property DETMVRate As %Float [ SqlColumnNumber = 16, SqlFieldName = DET_MVRate ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_AverLengthOfStay">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DET_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_EpisBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DET_IncludePrivSuppl">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DET_LSOutlierBenefit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DET_LSOutlierDays">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_MVRate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DET_OvernightFlagfall">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DET_OvernightFlagfallMV">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DET_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_SameDayCase6HMV">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DET_SameDayCaseLess6HMV">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemDRG.DRG_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemDRG.DRG_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemDRG.DRG_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemDRG.DRG_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DET_DateFrom}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemDRGDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
