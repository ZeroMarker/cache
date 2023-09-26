/// PayAgreemBedDiscount(2072)
Class User.ARCPayAgreemBedDiscount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemBedDiscount, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On BDChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PaymentAgreement Parent Reference
Relationship BDParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemBedDiscount, Required, SqlFieldName = BD_ParRef ];

/// Childsub
Property BDChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p(%d(0),$c(1)),"BD",0))}, SqlColumnNumber = 2, SqlFieldName = BD_Childsub ];

/// Date From
Property BDDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = BD_DateFrom ];

/// Date To
Property BDDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = BD_DateTo ];

/// Day From
Property BDDayFrom As %Float [ SqlColumnNumber = 5, SqlFieldName = BD_DayFrom ];

/// Day To
Property BDDayTo As %Float [ SqlColumnNumber = 6, SqlFieldName = BD_DayTo ];

/// % Discount
Property BDDiscount As %Float [ SqlColumnNumber = 7, SqlFieldName = BD_Discount ];

/// Des Ref RoomType
Property BDRoomTypeDR As PACRoomType [ SqlColumnNumber = 8, SqlFieldName = BD_RoomType_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBedDiscount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedDiscount","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBedDiscount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedDiscount","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBedDiscount).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedDiscount","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemBedDiscount).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedDiscount","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemBedDiscount).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBedDiscount","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BD_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BD_DayFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BD_DayTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BD_Discount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BD_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>BD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>BD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DateFrom"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BD_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BD_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemBedDiscountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
