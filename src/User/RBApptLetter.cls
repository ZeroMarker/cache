/// Appt Letter(2150)
Class User.RBApptLetter Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptLetter, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LETChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_Appointment Parent Reference
Relationship LETParRef As RBAppointment [ Cardinality = parent, Inverse = ChildRBApptLetter, Required, SqlFieldName = LET_ParRef ];

/// Childsub
Property LETChildsub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"APPT",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"LET",0))}, SqlColumnNumber = 2, SqlFieldName = LET_Childsub ];

/// Date
Property LETDate As %Date [ SqlColumnNumber = 3, SqlFieldName = LET_Date ];

/// Time
Property LETTime As %Time [ SqlColumnNumber = 4, SqlFieldName = LET_Time ];

/// Description
Property LETDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LET_Desc ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBApptLetter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptLetter","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBApptLetter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptLetter","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBApptLetter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptLetter","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBApptLetter).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptLetter","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBApptLetter).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptLetter","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LET_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LET_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LET_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>RB_Appointment.APPT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>LET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Appointment.APPT_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"LET"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LET_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptLetterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
