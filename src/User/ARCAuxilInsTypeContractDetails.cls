/// ARC Aux InsType ContractDetail(1493
Class User.ARCAuxilInsTypeContractDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_AuxilInsTypeContractDetails, StorageStrategy = SQLStorage ]
{

/// Des Ref CONTR Det
Property CONTRCONTRDR As BLCContractDetails [ SqlColumnNumber = 5, SqlFieldName = CONTR_CONTR_DR ];

/// Childsub
Property CONTRChildsub As %Float [ InitialExpression = {$i(^ARC("AUXIT",$p(%d(0),$c(1)),"CONTR",0))}, SqlColumnNumber = 2, SqlFieldName = CONTR_Childsub ];

/// Date From
Property CONTRDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = CONTR_DateFrom ];

/// Date To
Property CONTRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = CONTR_DateTo ];

/// ARC_AuxilInsurType Parent Reference
Relationship CONTRParRef As ARCAuxilInsurType [ Cardinality = parent, Inverse = ChildARCAuxilInsTypeContractDet, Required, SqlFieldName = CONTR_ParRef ];

Index RowIDBasedIDKeyIndex On CONTRChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsTypeContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeContractDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsTypeContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeContractDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsTypeContractDetails).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeContractDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCAuxilInsTypeContractDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeContractDetails","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCAuxilInsTypeContractDetails).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeContractDetails","OnBeforeUpdate")
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
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_AuxilInsurType.AUXIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CONTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUXIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_AuxilInsurType.AUXIT_RowId}</Expression>
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
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_AuxilInsurType.AUXIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CONTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUXIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_AuxilInsurType.AUXIT_RowId}</Expression>
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
<StreamLocation>^User.ARCAuxilInsTypeContractDeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
