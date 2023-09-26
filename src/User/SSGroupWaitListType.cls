/// SS Group Wait List Type(1926)
Class User.SSGroupWaitListType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupWaitListType, StorageStrategy = SQLStorage ]
{

/// Childsub
Property WLTChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"WLT",0))}, SqlColumnNumber = 2, SqlFieldName = WLT_Childsub ];

/// SS_Group Parent Reference
Relationship WLTParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupWaitListType, Required, SqlFieldName = WLT_ParRef ];

/// Des Ref WaitListType
Property WLTWaitListTypeDR As PACWaitingListType [ SqlColumnNumber = 3, SqlFieldName = WLT_WaitListType_DR ];

Index RowIDBasedIDKeyIndex On WLTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupWaitListType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWaitListType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupWaitListType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWaitListType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupWaitListType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWaitListType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupWaitListType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWaitListType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupWaitListType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupWaitListType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="WLTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="WLTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="WLTWaitListTypeDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="WLT_WaitListType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>WLT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexWLType">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>WLT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WLT_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{WLT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLT_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupWaitListTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
