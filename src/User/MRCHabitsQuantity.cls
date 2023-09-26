/// Habits Quantity        (MRHQT,1073)
Class User.MRCHabitsQuantity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_HabitsQuantity, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On QTYChildsub [ IdKey, PrimaryKey, Unique ];

/// MRC_Habits Parent Reference
Relationship QTYParRef As MRCHabits [ Cardinality = parent, Inverse = ChildMRCHabitsQuantity, Required, SqlFieldName = QTY_ParRef ];

/// Childsub
Property QTYChildsub As %Float [ InitialExpression = {$i(^MRC("HAB",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QTY",0))}, SqlColumnNumber = 2, SqlFieldName = QTY_Childsub ];

/// Code
Property QTYCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = QTY_Code ];

/// Description
Property QTYDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = QTY_Desc ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCHabitsQuantity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCHabitsQuantity","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCHabitsQuantity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCHabitsQuantity","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCHabitsQuantity).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCHabitsQuantity","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCHabitsQuantity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCHabitsQuantity","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCHabitsQuantity).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCHabitsQuantity","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QTY_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QTY_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_Habits.HAB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>QTY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HAB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_Habits.HAB_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"QTY"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QTY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>QTY_RowId</SqlRowIdName>
<StreamLocation>^User.MRCHabitsQuantityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
