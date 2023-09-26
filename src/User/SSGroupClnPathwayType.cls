/// Group Cln Pathway Type(2168)
Class User.SSGroupClnPathwayType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupClnPathwayType, StorageStrategy = SQLStorage ]
{

/// Des Ref CPWType
Property CPWCPWTypeDR As MRCClinPathType [ SqlColumnNumber = 3, SqlFieldName = CPW_CPWType_DR ];

/// Childsub
Property CPWChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CPW",0))}, SqlColumnNumber = 2, SqlFieldName = CPW_Childsub ];

/// SS_Group Parent Reference
Relationship CPWParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupClnPathwayType, Required, SqlFieldName = CPW_ParRef ];

Index RowIDBasedIDKeyIndex On CPWChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupClnPathwayType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupClnPathwayType).OnTrigger($g(%d(1)))             

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupClnPathwayType).OnTrigger($g(%d(1))) 

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupClnPathwayType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupClnPathwayType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CPW_CPWType_DR">
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
<Field>CPW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CPW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CPW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CPW_CPWType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CPW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CPW_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupClnPathwayTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
