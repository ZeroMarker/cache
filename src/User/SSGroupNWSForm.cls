/// DD GRoup Forms(1361)
Class User.SSGroupNWSForm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupNWSForm, StorageStrategy = SQLStorage ]
{

/// Childsub
Property NWSFORMChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"NWSFORM",0))}, SqlColumnNumber = 2, SqlFieldName = NWSFORM_Childsub ];

/// Height
Property NWSFORMHeight As %Float [ SqlColumnNumber = 5, SqlFieldName = NWSFORM_Height ];

/// LeftCoord
Property NWSFORMLeftCoord As %Float [ SqlColumnNumber = 4, SqlFieldName = NWSFORM_LeftCoord ];

/// SS_Group Parent Reference
Relationship NWSFORMParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupNWSForm, Required, SqlFieldName = NWSFORM_ParRef ];

/// TopCoord
Property NWSFORMTopCoord As %Float [ SqlColumnNumber = 3, SqlFieldName = NWSFORM_TopCoord ];

/// Width
Property NWSFORMWidth As %Float [ SqlColumnNumber = 6, SqlFieldName = NWSFORM_Width ];

Index RowIDBasedIDKeyIndex On NWSFORMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSForm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSForm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSForm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSForm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSForm).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSForm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupNWSForm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSForm","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupNWSForm).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSForm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="NWSFORMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="NWSFORMHeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="NWSFORMLeftCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="NWSFORMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="NWSFORMTopCoord">
<Selectivity>1</Selectivity>
</Property>
<Property name="NWSFORMWidth">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="NWSFORM_Height">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NWSFORM_LeftCoord">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NWSFORM_TopCoord">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NWSFORM_Width">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>NWSFORM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"NWSFORM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NWSFORM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NWSFORM_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupNWSFormS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
