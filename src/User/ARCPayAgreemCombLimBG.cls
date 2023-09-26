/// ARC Pay Agreem Comb Lim BG(1862)
Class User.ARCPayAgreemCombLimBG Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemCombLimBG, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On BGChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PayAgreemBGCombLimits Parent Reference
Relationship BGParRef As ARCPayAgreemBGCombLimits [ Cardinality = parent, Inverse = ChildARCPayAgreemCombLimBG, Required, SqlFieldName = BG_ParRef ];

/// Childsub
Property BGChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"COM",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"BG",0))}, SqlColumnNumber = 2, SqlFieldName = BG_Childsub ];

/// Des Ref BillGrp
Property BGBillGrpDR As ARCBillGrp [ SqlColumnNumber = 3, SqlFieldName = BG_BillGrp_DR ];

/// Des Ref BillSub
Property BGBillSubDR As ARCBillSub [ SqlColumnNumber = 4, SqlFieldName = BG_BillSub_DR ];

/// Des Ref ARCIM
Property BGARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = BG_ARCIM_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemCombLimBG).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemCombLimBG","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemCombLimBG).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemCombLimBG","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemCombLimBG).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemCombLimBG","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemCombLimBG).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemCombLimBG","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemCombLimBG","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemCombLimBG).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemCombLimBG","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BG_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BG_BillGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BG_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_PayAgreemBGCombLimits.COM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>BG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_PayAgreemBGCombLimits.COM_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BG"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BG_Childsub}</Expression>
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
<Field>ARC_PayAgreemBGCombLimits.COM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>BG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BG_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_PayAgreemBGCombLimits.COM_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BG_Childsub}</Expression>
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
<Field>ARC_PayAgreemBGCombLimits.COM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>BG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillGrp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BG_BillGrp_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_PayAgreemBGCombLimits.COM_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BG_Childsub}</Expression>
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
<Field>ARC_PayAgreemBGCombLimits.COM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>BG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"BillSub"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BG_BillSub_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_PayAgreemBGCombLimits.COM_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{BG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemCombLimBGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
