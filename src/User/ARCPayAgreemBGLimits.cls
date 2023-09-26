/// ARC Pay Agreem BG Limits(1768)
Class User.ARCPayAgreemBGLimits Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemBGLimits, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LIMChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PaymentAgreement Parent Reference
Relationship LIMParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemBGLimits, Required, SqlFieldName = LIM_ParRef ];

/// Childsub
Property LIMChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LIM",0))}, SqlColumnNumber = 2, SqlFieldName = LIM_Childsub ];

/// Des Ref BillGroup
Property LIMBillGroupDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = LIM_BillGroup_DR ];

/// Des Ref BillSub
Property LIMBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = LIM_BillSub_DR ];

/// Des Ref RoomType
Property LIMRoomTypeDR As PACRoomType [ SqlColumnNumber = 5, SqlFieldName = LIM_RoomType_DR ];

/// Max Coverage
Property LIMMaxCoverage As %Float [ SqlColumnNumber = 6, SqlFieldName = LIM_MaxCoverage ];

/// Des Ref ARCIM
Property LIMARCIMDR As ARCItmMast [ SqlColumnNumber = 7, SqlFieldName = LIM_ARCIM_DR ];

/// Payor Percent
Property LIMPayorPercent As %Float [ SqlColumnNumber = 8, SqlFieldName = LIM_PayorPercent ];

/// Des Ref OrderStatus
Property LIMOrderStatusDR As OECOrderStatus [ SqlColumnNumber = 9, SqlFieldName = LIM_OrderStatus_DR ];

/// EpisodeType
Property LIMEpisodeType As %String(DISPLAYLIST = ",Inpatient,Outpatient,Emergency,HealthPromotion", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",I,O,E,H") [ SqlColumnNumber = 10, SqlFieldName = LIM_EpisodeType ];

/// Des Ref EpisSubType
Property LIMEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 11, SqlFieldName = LIM_EpisSubType_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBGLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGLimits","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBGLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGLimits","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemBGLimits).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGLimits","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemBGLimits).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGLimits","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGLimits","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemBGLimits).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemBGLimits","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LIM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LIM_BillGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LIM_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LIM_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LIM_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LIM_MaxCoverage">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LIM_OrderStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LIM_PayorPercent">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LIM_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LIM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LIM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
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
<Field>LIM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LIM_BillGroup_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LIM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LIM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemBGLimitsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
