/// BLC FirstVisit Elapsed Days(1495)
Class User.BLCFirstVisitElapseDays Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_FirstVisitElapseDays, StorageStrategy = SQLStorage ]
{

/// Date From
Property FVEDDateFrom As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = FVED_DateFrom ];

/// Date To
Property FVEDDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = FVED_DateTo ];

/// Elapsed Days
Property FVEDElapsedDays As %Numeric(MINVAL = 0, SCALE = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = FVED_ElapsedDays ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCFirstVisitElapseDays).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCFirstVisitElapseDays","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCFirstVisitElapseDays).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCFirstVisitElapseDays","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCFirstVisitElapseDays).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCFirstVisitElapseDays","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCFirstVisitElapseDays).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCFirstVisitElapseDays","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCFirstVisitElapseDays).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCFirstVisitElapseDays","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="FVEDDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="FVEDDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="FVEDElapsedDays">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("FVED",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FVED_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FVED_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FVED_ElapsedDays">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FVED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FVED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{FVED_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FVED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FVED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FVED_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FVED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FVED_RowId</SqlRowIdName>
<StreamLocation>^User.BLCFirstVisitElapseDaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
