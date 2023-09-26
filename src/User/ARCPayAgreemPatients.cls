/// ARC Payment Agreem Patients(1839)
Class User.ARCPayAgreemPatients Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_PayAgreemPatients, StorageStrategy = SQLStorage ]
{

/// Des Ref PAPMI
Property PAPPAPMIDR As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PAP_PAPMI_DR ];

/// Childsub
Property PATChildsub As %Float [ InitialExpression = {$i(^ARC("PAY",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAT",0))}, SqlColumnNumber = 2, SqlFieldName = PAT_Childsub ];

/// Date From
Property PATDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PAT_DateFrom ];

/// Date To
Property PATDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PAT_DateTo ];

/// Membership Card Number
Property PATMembershipCardNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PAT_MembershipCardNumber ];

/// ARC_PaymentAgreement Parent Reference
Relationship PATParRef As ARCPaymentAgreement [ Cardinality = parent, Inverse = ChildARCPayAgreemPatients, Required, SqlFieldName = PAT_ParRef ];

Index RowIDBasedIDKeyIndex On PATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPatients).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemPatients","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPatients).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemPatients","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCPayAgreemPatients).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemPatients","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCPayAgreemPatients).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemPatients","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCPayAgreemPatients).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCPayAgreemPatients","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="PAPPAPMIDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PATChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PATDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PATMembershipCardNumber">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PATParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PAP_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAT_MembershipCardNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPat1">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Pat"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAP_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPat2">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARC_PaymentAgreement.PAY_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Pat"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAP_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_PaymentAgreement.PAY_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCPayAgreemPatientsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
