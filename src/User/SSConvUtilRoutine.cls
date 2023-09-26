/// SS Conv Util Routine(1405)
Class User.SSConvUtilRoutine Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_ConvUtilRoutine, StorageStrategy = SQLStorage ]
{

/// Childsub
Property RTNChildsub As %Float [ InitialExpression = {$i(^SSCU("CU",$p(%d(0),$c(1)),"RTN",0))}, SqlColumnNumber = 2, SqlFieldName = RTN_Childsub ];

/// Finish Date
Property RTNFinishDate As %Date [ SqlColumnNumber = 6, SqlFieldName = RTN_FinishDate ];

/// Finish Time
Property RTNFinishTime As %Time [ SqlColumnNumber = 7, SqlFieldName = RTN_FinishTime ];

/// SS_ConversionUtility Parent Reference
Relationship RTNParRef As SSConversionUtility [ Cardinality = parent, Inverse = ChildSSConvUtilRoutine, Required, SqlFieldName = RTN_ParRef ];

/// Routine To Run
Property RTNRoutineToRun As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RTN_RoutineToRun ];

/// Run Multiple Times
Property RTNRunMultipleTimes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 8, SqlFieldName = RTN_RunMultipleTimes ];

/// Start Date
Property RTNStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = RTN_StartDate ];

/// Start Time
Property RTNStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = RTN_StartTime ];

/// Tag
Property RTNTag As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = RTN_Tag ];

Index RowIDBasedIDKeyIndex On RTNChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSConvUtilRoutine).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConvUtilRoutine","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSConvUtilRoutine).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConvUtilRoutine","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSConvUtilRoutine).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConvUtilRoutine","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSConvUtilRoutine).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConvUtilRoutine","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSConvUtilRoutine).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConvUtilRoutine","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RTN_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RTN_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RTN_RoutineToRun">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RTN_RunMultipleTimes">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RTN_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RTN_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RTN_Tag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^SSCU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_ConversionUtility.SSCU_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RTN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CU"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_ConversionUtility.SSCU_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RTN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RTN_RowId</SqlRowIdName>
<StreamLocation>^User.SSConvUtilRoutineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
