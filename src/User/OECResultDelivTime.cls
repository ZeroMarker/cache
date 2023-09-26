/// Result Deliv Time Between Loc(1704)
Class User.OECResultDelivTime Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ResultDelivTime, StorageStrategy = SQLStorage ]
{

/// Arrive Time
Property DLTArriveTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DLT_ArriveTime ];

/// Date From
Property DLTDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = DLT_DateFrom ];

/// Date To
Property DLTDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = DLT_DateTo ];

/// Des Ref LocFrom
Property DLTLocFromDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = DLT_LocFrom_DR ];

/// Des Ref LocTo
Property DLTLocToDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = DLT_LocTo_DR ];

/// Start Time
Property DLTStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = DLT_StartTime ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECResultDelivTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECResultDelivTime","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECResultDelivTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECResultDelivTime","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECResultDelivTime).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECResultDelivTime","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECResultDelivTime).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECResultDelivTime","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECResultDelivTime).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OECResultDelivTime","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^OEC("DLT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DLT_ArriveTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DLT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DLT_LocFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLT_LocTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DLT_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DLT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DLT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DLT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DLT_LocFrom_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DLT_LocTo_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DLT_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DLT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DLT_Rowid</SqlRowIdName>
<StreamLocation>^User.OECResultDelivTimeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
