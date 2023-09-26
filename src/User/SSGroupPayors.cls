/// SS Group Payor(1742)
Class User.SSGroupPayors Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupPayors, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property PAYAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 7, SqlFieldName = PAY_AuxInsType_DR ];

/// Des Ref CTLOC
Property PAYCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = PAY_CTLOC_DR ];

/// Childsub
Property PAYChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"PAY",0))}, SqlColumnNumber = 2, SqlFieldName = PAY_Childsub ];

/// Date From
Property PAYDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PAY_DateFrom ];

/// Date To
Property PAYDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PAY_DateTo ];

/// Des Ref InsType
Property PAYInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 6, SqlFieldName = PAY_InsType_DR ];

/// SS_Group Parent Reference
Relationship PAYParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupPayors, Required, SqlFieldName = PAY_ParRef ];

Index RowIDBasedIDKeyIndex On PAYChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupPayors).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupPayors","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupPayors).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupPayors","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupPayors).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupPayors","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupPayors).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupPayors","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupPayors).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupPayors","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="PAYAuxInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PAYCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PAYChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PAYDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="PAYDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="PAYInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PAYParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="PAY_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAY_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAY_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAY_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAY_InsType_DR">
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
<Field>PAY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPayorDate">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L9}</Expression>
<Field>PAY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Payor"</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{PAY_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PAY_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PAY_DateFrom}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PAY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlan">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L10}</Expression>
<Field>PAY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PAY"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Plan"</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{PAY_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PAY_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>+{PAY_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{PAY_DateFrom}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{PAY_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAY_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupPayorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
