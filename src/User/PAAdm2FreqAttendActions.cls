/// Adm2FreqAttendActions(2770)
Class User.PAAdm2FreqAttendActions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Adm2FreqAttendActions, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FRAChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Adm2 Parent Reference
Relationship FRAParRef As PAAdm2 [ Cardinality = parent, Inverse = ChildPAAdm2FreqAttendActions, Required, SqlFieldName = FRA_ParRef ];

/// Childsub
Property FRAChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"FRA",0))}, SqlColumnNumber = 2, SqlFieldName = FRA_Childsub ];

/// Des Ref FreqAttendAction
Property FRAFreqAttendActionDR As PACFreqAttendActions [ SqlColumnNumber = 3, SqlFieldName = FRA_FreqAttendAction_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAAdm2FreqAttendActions).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2FreqAttendActions","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAAdm2FreqAttendActions).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2FreqAttendActions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAAdm2FreqAttendActions).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2FreqAttendActions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAAdm2FreqAttendActions).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2FreqAttendActions","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAAdm2FreqAttendActions).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2FreqAttendActions","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdm2FreqAttendActions","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="FRA_FreqAttendAction_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm2.PAADM2_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FRA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm2.PAADM2_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FRA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FRA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FRA_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdm2FreqAttendActionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
