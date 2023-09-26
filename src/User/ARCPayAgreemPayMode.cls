/// PayAgreemPayMode(2568)
Class User.ARCPayAgreemPayMode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemPayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PMChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_PaymentAgreement Parent Reference
Relationship PMParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemPayMode, Required, SqlFieldName = PM_ParRef ];

/// Childsub
Property PMChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PMODE",0))}, SqlColumnNumber = 2, SqlFieldName = PM_Childsub ];

/// Date From
Property PMDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = PM_DateFrom ];

/// Date To
Property PMDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = PM_DateTo ];

/// Des Ref PayMode
Property PMPayModeDR As CTPayMode [ SqlColumnNumber = 5, SqlFieldName = PM_PayMode_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPayMode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPayMode","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPayMode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPayMode","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPayMode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPayMode","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemPayMode).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPayMode","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemPayMode).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCPayAgreemPayMode","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PM_PayMode_DR">
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
<Field>PM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PMODE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
