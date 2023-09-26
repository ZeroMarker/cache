/// UDW Group(2338)
Class User.SSGroupUDWGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupUDWGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RESRRChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_Group Parent Reference
Relationship RESRRParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupUDWGroup, Required, SqlFieldName = RESRR_ParRef ];

/// Childsub
Property RESRRChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"UDWG",0))}, SqlColumnNumber = 2, SqlFieldName = RESRR_Childsub ];

/// Des Ref UDW Group
Property RESRRUDWGroupDR As SSUserDefWinGroup [ SqlColumnNumber = 3, SqlFieldName = RESRR_UDWGroup_DR ];

/// QuestReadOnly
Property RESRRQuestReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = RESRR_QuestReadOnly ];

/// QuestAdmRestrict
Property RESRRQuestAdmRestrict As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = RESRR_QuestAdmRestrict ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.SSGroupUDWGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupUDWGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.SSGroupUDWGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupUDWGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.SSGroupUDWGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupUDWGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.SSGroupUDWGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupUDWGroup","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.SSGroupUDWGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupUDWGroup","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroupUDWGroup","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RESRR_QuestAdmRestrict">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RESRR_QuestReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RESRR_UDWGroup_DR">
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
<Field>RESRR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UDWG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RESRR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdCat">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RESRR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"UDWG"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RESRR_UDWGroup_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RESRR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RESRR_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupUDWGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
