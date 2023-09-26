/// Discharge Condition(1062)
Class User.PACDischCondit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DischCondit, StorageStrategy = SQLStorage ]
{

/// Code
Property DISCONCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DISCON_Code ];

/// Date From
Property DISCONDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = DISCON_DateFrom ];

/// Date To
Property DISCONDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = DISCON_DateTo ];

/// Dead Flag
Property DISCONDeadFlag As %String(DISPLAYLIST = ",InPatientAdmission,Death,Waiting List,Appointment,Transfer", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",IP,D,WL,A,T") [ SqlColumnNumber = 4, SqlFieldName = DISCON_DeadFlag ];

/// Description
Property DISCONDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DISCON_Desc ];

/// Episode Type
Property DISCONEpisodeType As %String(DISPLAYLIST = ",Emergency,Inpatient", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",E,I") [ SqlColumnNumber = 8, SqlFieldName = DISCON_EpisodeType ];

/// National Code
Property DISCONNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DISCON_NationalCode ];

Index DISCONCodeUnqIdx1 On DISCONCode [ Unique ];

Parameter EXTENTSIZE = 12;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACDischCondit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDischCondit","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACDischCondit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDischCondit","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACDischCondit).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDischCondit","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACDischCondit).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDischCondit","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACDischCondit).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACDischCondit","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>12</ExtentSize>
<Property name="DISCONCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="DISCONDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="DISCONDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="DISCONDeadFlag">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DISCONDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="DISCONEpisodeType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DISCONNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("DISCON",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DISCON_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISCON_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DISCON_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DISCON_DeadFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DISCON_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DISCON_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DISCON_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DISCON_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCON"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DISCON_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DISCON_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCON"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DISCON_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISCON_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DISCON_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISCON"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DISCON_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DISCON_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DISCON_RowId</SqlRowIdName>
<StreamLocation>^User.PACDischConditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
