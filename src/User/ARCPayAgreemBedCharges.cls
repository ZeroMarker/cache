/// ARC Pay Agreem bed Charges(1673)
Class User.ARCPayAgreemBedCharges Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemBedCharges, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On BEDChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PaymentAgreement Parent Reference
Relationship BEDParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemBedCharges, Required, SqlFieldName = BED_ParRef ];

/// Childsub
Property BEDChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"BED",0))}, SqlColumnNumber = 2, SqlFieldName = BED_Childsub ];

/// Days From
Property BEDDaysFrom As %Float [ SqlColumnNumber = 3, SqlFieldName = BED_DaysFrom ];

/// Days To
Property BEDDaysTo As %Float [ SqlColumnNumber = 4, SqlFieldName = BED_DaysTo ];

/// Amount
Property BEDAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = BED_Amt ];

/// Des Ref BillGrp
Property BEDBillGrpDR As ARCBillGrp [ SqlColumnNumber = 6, SqlFieldName = BED_BillGrp_DR ];

/// Des Ref Bill Sub
Property BEDBillSubDR As ARCBillSub [ SqlColumnNumber = 7, SqlFieldName = BED_BillSub_DR ];

/// Des Ref RoomType
Property BEDRoomTypeDR As PACRoomType [ SqlColumnNumber = 8, SqlFieldName = BED_RoomType_DR ];

/// Patient Share
Property BEDPatientShare As %Float [ SqlColumnNumber = 9, SqlFieldName = BED_PatientShare ];

/// Date From
Property BEDDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = BED_DateFrom ];

/// Date To
Property BEDDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = BED_DateTo ];

/// TimeFrom
Property BEDTimeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = BED_TimeFrom ];

/// TimeTo
Property BEDTimeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = BED_TimeTo ];

/// FixedPrice
Property BEDFixedPrice As %Float [ SqlColumnNumber = 14, SqlFieldName = BED_FixedPrice ];

/// Des Ref EpisodeSubType
Property BEDEpisodeSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 15, SqlFieldName = BED_EpisodeSubType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBedCharges).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedCharges","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBedCharges).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedCharges","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBedCharges).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedCharges","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemBedCharges).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedCharges","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemBedCharges).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedCharges","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BED_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BED_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BED_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BED_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BED_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BED_DaysFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BED_DaysTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BED_EpisodeSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BED_FixedPrice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BED_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BED_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BED_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BED_TimeTo">
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
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillGrp">
<Condition>1</Condition>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BED_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BED_BillSub_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BED_RoomType_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysFrom">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>BED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Days"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BED_DaysFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BED_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemBedChargesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
