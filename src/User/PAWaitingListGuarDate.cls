/// WaitingListGuarDate(2773)
Class User.PAWaitingListGuarDate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListGuarDate, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On GDChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship GDParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListGuarDate, Required, SqlFieldName = GD_ParRef ];

/// Childsub
Property GDChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"GD",0))}, SqlColumnNumber = 2, SqlFieldName = GD_Childsub ];

/// WaitTime
Property GDWaitTime As %Float [ SqlColumnNumber = 3, SqlFieldName = GD_WaitTime ];

/// Guaranteed Date
Property GDGuaranteedDate As %Date [ SqlColumnNumber = 4, SqlFieldName = GD_GuaranteedDate ];

/// ChangeDate
Property GDChangeDate As %Date [ SqlColumnNumber = 5, SqlFieldName = GD_ChangeDate ];

/// ChangeTime
Property GDChangeTime As %Time [ SqlColumnNumber = 6, SqlFieldName = GD_ChangeTime ];

/// EffDate
Property GDEffDate As %Date [ SqlColumnNumber = 7, SqlFieldName = GD_EffDate ];

/// Des Ref User
Property GDUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = GD_User_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingListGuarDate).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListGuarDate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingListGuarDate).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListGuarDate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingListGuarDate).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListGuarDate","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingListGuarDate).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListGuarDate","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListGuarDate","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingListGuarDate).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListGuarDate","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="GD_ChangeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GD_ChangeTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GD_EffDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GD_GuaranteedDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GD_WaitTime">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>GD_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListGuarDateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
