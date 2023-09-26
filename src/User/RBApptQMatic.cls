/// ApptQMatic(2732)
Class User.RBApptQMatic Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptQMatic, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On QMChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_Appointment Parent Reference
Relationship QMParRef As RBAppointment [ Cardinality = parent, Inverse = ChildRBApptQMatic, Required, SqlFieldName = QM_ParRef ];

/// Childsub
Property QMChildsub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"APPT",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"QM",0))}, SqlColumnNumber = 2, SqlFieldName = QM_Childsub ];

/// Number
Property QMNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = QM_Number ];

/// Status
Property QMStatus As %String(DISPLAYLIST = ",Active,Done", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",A,D") [ SqlColumnNumber = 4, SqlFieldName = QM_Status ];

/// CreateDate
Property QMCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = QM_CreateDate ];

/// CreateTime
Property QMCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = QM_CreateTime ];

/// LastUpdateDate
Property QMLastUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = QM_LastUpdateDate ];

/// LastUpdateTime
Property QMLastUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = QM_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property QMLastUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = QM_LastUpdateUser_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBApptQMatic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptQMatic","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBApptQMatic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptQMatic","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBApptQMatic).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptQMatic","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBApptQMatic).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptQMatic","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBApptQMatic).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptQMatic","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QM_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QM_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QM_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QM_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QM_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QM_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QM_Status">
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
<Field>QM_Childsub</Field>
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
<Expression>"QM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>QM_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptQMaticS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
