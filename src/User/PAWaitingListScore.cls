/// WaitingListScore(2786)
Class User.PAWaitingListScore Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListScore, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SCChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship SCParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListScore, Required, SqlFieldName = SC_ParRef ];

/// Childsub
Property SCChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SC",0))}, SqlColumnNumber = 2, SqlFieldName = SC_Childsub ];

/// Score
Property SCScore As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SC_Score ];

/// AssignmentDate
Property SCAssignmentDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SC_AssignmentDate ];

/// AssignmentTime
Property SCAssignmentTime As %Time [ SqlColumnNumber = 5, SqlFieldName = SC_AssignmentTime ];

/// UpdateDate
Property SCUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = SC_UpdateDate ];

/// UpdateTime
Property SCUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = SC_UpdateTime ];

/// DeleteDate
Property SCDeleteDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SC_DeleteDate ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingListScore).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListScore","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingListScore).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListScore","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingListScore).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListScore","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingListScore).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListScore","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListScore","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingListScore).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListScore","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="SC_AssignmentDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SC_AssignmentTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SC_DeleteDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SC_Score">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SC_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
