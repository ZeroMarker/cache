/// CT Ref Clinic Contract Det(1494)
Class User.CTRefClnContractDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_RefClnContractDetails, StorageStrategy = SQLStorage ]
{

/// Des REf CONTRact Det
Property CONTRCONTRDR As BLCContractDetails [ SqlColumnNumber = 5, SqlFieldName = CONTR_CONTR_DR ];

/// Childsub
Property CONTRChildsub As %Float [ InitialExpression = {$i(^CT("RFC",$p(%d(0),$c(1)),"CONTR",0))}, SqlColumnNumber = 2, SqlFieldName = CONTR_Childsub ];

/// Date From
Property CONTRDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = CONTR_DateFrom ];

/// Date To
Property CONTRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = CONTR_DateTo ];

/// CT_RefClin Parent Reference
Relationship CONTRParRef As CTRefClin [ Cardinality = parent, Inverse = ChildCTRefClnContractDetails, Required, SqlFieldName = CONTR_ParRef ];

Index RowIDBasedIDKeyIndex On CONTRChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTRefClnContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRefClnContractDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTRefClnContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRefClnContractDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTRefClnContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRefClnContractDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTRefClnContractDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRefClnContractDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTRefClnContractDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTRefClnContractDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CONTR_CONTR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONTR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONTR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_RefClin.CTRFC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CONTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_RefClin.CTRFC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CONTR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_RefClin.CTRFC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CONTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_RefClin.CTRFC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CONTR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CONTR_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CONTR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CONTR_RowId</SqlRowIdName>
<StreamLocation>^User.CTRefClnContractDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
