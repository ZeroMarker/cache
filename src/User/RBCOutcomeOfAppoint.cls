/// RBC Outcome of appointment(1731)
Class User.RBCOutcomeOfAppoint Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_OutcomeOfAppoint, StorageStrategy = SQLStorage ]
{

/// Code
Property OUTCCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OUTC_Code ];

/// Description
Property OUTCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OUTC_Desc ];

/// Attendance Class
Property OUTCAttendanceClass As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OUTC_AttendanceClass ];

/// National Code
Property OUTCNationalCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = OUTC_NationalCode ];

/// Discharge Flag
Property OUTCDischargeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = OUTC_DischargeFlag ];

/// Associated Action
Property OUTCAssociatedAction As %String(DISPLAYLIST = ",Failed To Attend,Rebook", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",F,R") [ SqlColumnNumber = 7, SqlFieldName = OUTC_AssociatedAction ];

/// Date From
Property OUTCDateFrom As %Date [ SqlColumnNumber = 8, SqlFieldName = OUTC_DateFrom ];

/// Date To
Property OUTCDateTo As %Date [ SqlColumnNumber = 9, SqlFieldName = OUTC_DateTo ];

/// Des Ref WLStatus
Property OUTCWLStatusDR As PACWaitingListStatus [ SqlColumnNumber = 10, SqlFieldName = OUTC_WLStatus_DR ];

/// RemoveWL
Property OUTCRemoveWL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = OUTC_RemoveWL ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBCOutcomeOfAppoint).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCOutcomeOfAppoint","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBCOutcomeOfAppoint).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCOutcomeOfAppoint","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBCOutcomeOfAppoint).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCOutcomeOfAppoint","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBCOutcomeOfAppoint).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCOutcomeOfAppoint","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBCOutcomeOfAppoint).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCOutcomeOfAppoint","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCOutcomeOfAppoint","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>25</ExtentSize>
<Property name="OUTCAssociatedAction">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OUTCAttendanceClass">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="OUTCCode">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="OUTCDateFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="OUTCDateTo">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="OUTCDesc">
<Selectivity>4.0000%</Selectivity>
</Property>
<Property name="OUTCDischargeFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OUTCNationalCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="OUTCRemoveWL">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="OUTCWLStatusDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^RBC("OUTC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OUTC_AssociatedAction">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OUTC_AttendanceClass">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OUTC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OUTC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OUTC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OUTC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OUTC_DischargeFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OUTC_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OUTC_RemoveWL">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OUTC_WLStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OUTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OUTC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OUTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OUTC_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OUTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OUTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OUTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OUTC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OUTC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OUTC_RowId</SqlRowIdName>
<StreamLocation>^User.RBCOutcomeOfAppointS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
