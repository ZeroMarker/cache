/// SS Conversion Status(1482)
Class User.SSConversionStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_ConversionStatus, StorageStrategy = SQLStorage ]
{

/// Date Finished
Property SSCVDateFinished As %Date [ SqlColumnNumber = 5, SqlFieldName = SSCV_DateFinished ];

/// Date Start
Property SSCVDateStart As %Date [ SqlColumnNumber = 3, SqlFieldName = SSCV_DateStart ];

/// Error
Property SSCVError As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SSCV_Error ];

/// Routine
Property SSCVRoutine As %String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SSCV_Routine ];

/// Time Finished
Property SSCVTimeFinished As %Time [ SqlColumnNumber = 6, SqlFieldName = SSCV_TimeFinished ];

/// Time Start
Property SSCVTimeStart As %Time [ SqlColumnNumber = 4, SqlFieldName = SSCV_TimeStart ];

Index RowIDBasedIDKeyIndex On SSCVRoutine [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 83;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSConversionStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConversionStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSConversionStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConversionStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSConversionStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConversionStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSConversionStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConversionStatus","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSConversionStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSConversionStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>83</ExtentSize>
<Property name="SSCVDateFinished">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSCVDateStart">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSCVError">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSCVRoutine">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSCVTimeFinished">
<Selectivity>1</Selectivity>
</Property>
<Property name="SSCVTimeStart">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SSCV_DateFinished">
<Delimiter>"^"</Delimiter>
<Node>"STOP"</Node>
<Piece>1</Piece>
</Data>
<Data name="SSCV_DateStart">
<Delimiter>"^"</Delimiter>
<Node>"START"</Node>
<Piece>1</Piece>
</Data>
<Data name="SSCV_Error">
<Delimiter>"^"</Delimiter>
<Node>"ERR"</Node>
<Piece>1</Piece>
</Data>
<Data name="SSCV_TimeFinished">
<Delimiter>"^"</Delimiter>
<Node>"STOP"</Node>
<Piece>2</Piece>
</Data>
<Data name="SSCV_TimeStart">
<Delimiter>"^"</Delimiter>
<Node>"START"</Node>
<Piece>2</Piece>
</Data>
<Global>^CONV</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSCV_Routine</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONV-ROUTINE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SSCV_Routine}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSCV_RowId</SqlRowIdName>
<StreamLocation>^User.SSConversionStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
