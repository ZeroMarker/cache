/// PA Adm Copayment Codes(1788)
Class User.PAAdmCopaymentCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmCopaymentCodes, StorageStrategy = SQLStorage ]
{

/// Childsub
Property COPCChildsub As %Float [ InitialExpression = {$i(^PAADM($p(%d(0),$c(1)),"COPC",0))}, SqlColumnNumber = 2, SqlFieldName = COPC_Childsub ];

/// Des Ref Copayment
Property COPCCopaymentDR As ARCCopaymentCodes [ SqlColumnNumber = 3, SqlFieldName = COPC_Copayment_DR ];

/// Date From
Property COPCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = COPC_DateFrom ];

/// PA_Adm Parent Reference
Relationship COPCParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmCopaymentCodes, Required, SqlFieldName = COPC_ParRef ];

/// Des Ref User
Property COPCUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = COPC_User_DR ];

Index RowIDBasedIDKeyIndex On COPCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 166;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmCopaymentCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCopaymentCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmCopaymentCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCopaymentCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmCopaymentCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCopaymentCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmCopaymentCodes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCopaymentCodes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmCopaymentCodes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmCopaymentCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>166</ExtentSize>
<Property name="COPCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="COPCCopaymentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="COPCDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="COPCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="COPCUserDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="COPC_Copayment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COPC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COPC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>COPC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"COPC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{COPC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>COPC_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmCopaymentCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
