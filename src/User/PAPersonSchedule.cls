/// PersonSchedule(2782)
Class User.PAPersonSchedule Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonSchedule, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SCHChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPersonScheduleItem As PAPersonScheduleItem [ Cardinality = children, Inverse = ITMParRef ];

/// PA_Person Parent Reference
Relationship SCHParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonSchedule, Required, SqlFieldName = SCH_ParRef ];

/// Childsub
Property SCHChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SCH",0))}, SqlColumnNumber = 2, SqlFieldName = SCH_Childsub ];

/// Des Ref Schema
Property SCHSchemaDR As RBApptSchema [ SqlColumnNumber = 3, SqlFieldName = SCH_Schema_DR ];

/// Date
Property SCHDate As %Date [ SqlColumnNumber = 4, SqlFieldName = SCH_Date ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonSchedule).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSchedule","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonSchedule).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSchedule","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonSchedule).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSchedule","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonSchedule).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSchedule","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonSchedule).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSchedule","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSchedule","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="SCH_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCH_Schema_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SCH_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
