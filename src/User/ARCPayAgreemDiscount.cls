/// Pay Agreem Discount(2214)
Class User.ARCPayAgreemDiscount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemDiscount, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DISCChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PaymentAgreement Parent Reference
Relationship DISCParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemDiscount, Required, SqlFieldName = DISC_ParRef ];

/// Childsub
Property DISCChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DISC",0))}, SqlColumnNumber = 2, SqlFieldName = DISC_Childsub ];

/// Date From
Property DISCDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DISC_DateFrom ];

/// Date To
Property DISCDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DISC_DateTo ];

/// Day From
Property DISCDayFrom As %Float [ SqlColumnNumber = 5, SqlFieldName = DISC_DayFrom ];

/// Day To
Property DISCDayTo As %Float [ SqlColumnNumber = 6, SqlFieldName = DISC_DayTo ];

/// Des Ref BillGroup
Property DISCBillGroupDR As ARCBillGrp [ SqlColumnNumber = 7, SqlFieldName = DISC_BillGroup_DR ];

/// Des Ref BillSub
Property DISCBillSubDR As ARCBillSub [ SqlColumnNumber = 8, SqlFieldName = DISC_BillSub_DR ];

/// Des Ref ARCIM
Property DISCARCIMDR As ARCItmMast [ SqlColumnNumber = 9, SqlFieldName = DISC_ARCIM_DR ];

/// % Discount
Property DISCDiscount As %Float [ SqlColumnNumber = 10, SqlFieldName = DISC_Discount ];

/// DiscountAmount
Property DISCDiscountAmount As %Float [ SqlColumnNumber = 11, SqlFieldName = DISC_DiscountAmount ];

/// Des Ref DocSpec
Property DISCDocSpecDR As CTSpec [ SqlColumnNumber = 12, SqlFieldName = DISC_DocSpec_DR ];

/// Payor Only
Property DISCPayorOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DISC_PayorOnly ];

/// Des Ref EpisBill
Property DISCEpisBillDR As ARCEpisodicBilling [ SqlColumnNumber = 14, SqlFieldName = DISC_EpisBill_DR ];

/// Des Ref EpisSubType
Property DISCEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 15, SqlFieldName = DISC_EpisSubType_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDiscount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDiscount","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDiscount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDiscount","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemDiscount).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDiscount","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemDiscount).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDiscount","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDiscount","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemDiscount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemDiscount","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DISC_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DISC_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DISC_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DISC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DISC_DayFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DISC_DayTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DISC_Discount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DISC_DiscountAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DISC_DocSpec_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DISC_EpisBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DISC_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DISC_PayorOnly">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DISC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DISC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DISC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DISC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DISC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DISC_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DISC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DISC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DISC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DISC_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DISC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillSub">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DISC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DISC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillSub"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DISC_BillSub_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DISC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DISC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemDiscountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
