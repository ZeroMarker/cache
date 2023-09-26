/// Service Set Items(1433)
Class User.RBCServiceSetItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_ServiceSet_Items, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = ITM_ARCIM_DR ];

/// Des Ref ARCOS
Property ITMARCOSDR As ARCOrdSets [ SqlColumnNumber = 7, SqlFieldName = ITM_ARCOS_DR ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^RBC("SET",$p(%d(0),$c(1)),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// Days
Property ITMDays As %Float [ SqlColumnNumber = 5, SqlFieldName = ITM_Days ];

/// Main Service
Property ITMMain As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ITM_Main ];

/// RBC_ServiceSet Parent Reference
Relationship ITMParRef As RBCServiceSet [ Cardinality = parent, Inverse = ChildRBCServiceSetItems, Required, SqlFieldName = ITM_ParRef ];

/// Sequence
Property ITMSequence As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ITM_Sequence ];

/// Des Ref RBC_Service
Property ITMServiceDR As RBCServices [ SqlColumnNumber = 3, SqlFieldName = ITM_Service_DR ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 8;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCServiceSetItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceSetItems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCServiceSetItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceSetItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCServiceSetItems).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceSetItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCServiceSetItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceSetItems","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCServiceSetItems).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBCServiceSetItems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>8</ExtentSize>
<Property name="ITMARCIMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMARCOSDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMDays">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMMain">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ITMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMSequence">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMServiceDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITM_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITM_Days">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_Main">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITM_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITM_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_ServiceSet.SET_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_ServiceSet.SET_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexService">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RBC_ServiceSet.SET_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITM_Service_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RBC_ServiceSet.SET_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.RBCServiceSetItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
