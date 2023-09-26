/// SS User Order Category(1259)
Class User.SSUserOrderCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserOrderCategory, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ORCATChildsub As %Float [ InitialExpression = {$i(^SST("SSUSR",$p(%d(0),$c(1)),"ORCAT",0))}, SqlColumnNumber = 2, SqlFieldName = ORCAT_Childsub ];

/// Des Ref to OrderCateg
Property ORCATOrderCategDR As OECOrderCategory [ Required, SqlColumnNumber = 3, SqlFieldName = ORCAT_OrderCateg_DR ];

/// SS_User Parent Reference
Relationship ORCATParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserOrderCategory, Required, SqlFieldName = ORCAT_ParRef ];

Index RowIDBasedIDKeyIndex On ORCATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 35;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserOrderCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserOrderCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserOrderCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserOrderCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderCategory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserOrderCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>35</ExtentSize>
<Property name="ORCATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ORCATOrderCategDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ORCATParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ORCAT_OrderCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ORCAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ORCAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ORCAT_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserOrderCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
