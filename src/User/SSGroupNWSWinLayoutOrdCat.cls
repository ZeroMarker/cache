/// SS Group NWS WinLayoutOrdCat(1360)
Class User.SSGroupNWSWinLayoutOrdCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupNWSWinLayoutOrdCat, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CATChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),"||"),"NWSWIN",$p(%d(0),"||",2),"CAT",0))}, SqlColumnNumber = 2, SqlFieldName = CAT_Childsub ];

/// Des Ref OrdCat
Property CATOrdCatDR As OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = CAT_OrdCat_DR ];

/// SS_GroupNWS_WindowLayout Parent Reference
Relationship CATParRef As SSGroupNWSWindowLayout [ Cardinality = parent, Inverse = ChildSSGroupNWSWinLayoutOrdCat, Required, SqlFieldName = CAT_ParRef ];

Index RowIDBasedIDKeyIndex On CATChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSWinLayoutOrdCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWinLayoutOrdCat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSWinLayoutOrdCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWinLayoutOrdCat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroupNWSWinLayoutOrdCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWinLayoutOrdCat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroupNWSWinLayoutOrdCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWinLayoutOrdCat","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroupNWSWinLayoutOrdCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSGroupNWSWinLayoutOrdCat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CAT_OrdCat_DR">
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
<Field>SS_GroupNWS_WindowLayout.NWSWIN_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>CAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"NWSWIN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_GroupNWS_WindowLayout.NWSWIN_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"CAT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CAT_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupNWSWinLayoutOrdCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
