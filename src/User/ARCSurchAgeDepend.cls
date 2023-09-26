/// ARC SurchCode Age Depend(1214)
Class User.ARCSurchAgeDepend Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchAgeDepend, StorageStrategy = SQLStorage ]
{

/// Childsub
Property AGEChildsub As %Float [ InitialExpression = {$i(^ARC("SURC",$p(%d(0),$c(1)),"AGE",0))}, SqlColumnNumber = 2, SqlFieldName = AGE_Childsub ];

/// Date From
Property AGEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = AGE_DateFrom ];

/// Date To
Property AGEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = AGE_DateTo ];

/// Day From
Property AGEDayFrom As %Float [ SqlColumnNumber = 8, SqlFieldName = AGE_DayFrom ];

/// Day To
Property AGEDayTo As %Float [ SqlColumnNumber = 7, SqlFieldName = AGE_DayTo ];

/// Fixed Amt
Property AGEFixedAmt As %Float [ SqlColumnNumber = 9, SqlFieldName = AGE_FixedAmt ];

/// Description
Property AGEName As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = AGE_Name ];

/// ARC_SurchargeCode Parent Reference
Relationship AGEParRef As ARCSurchargeCode [ Cardinality = parent, Inverse = ChildARCSurchAgeDepend, Required, SqlFieldName = AGE_ParRef ];

/// % Charge
Property AGEPerc As %Float [ SqlColumnNumber = 10, SqlFieldName = AGE_Perc ];

/// Visit Type
Property AGEVisitType As %String(DISPLAYLIST = ",Normal,First Visit,Second and Other", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 11, SqlFieldName = AGE_VisitType ];

/// Year From
Property AGEYearFrom As %Float [ SqlColumnNumber = 5, SqlFieldName = AGE_YearFrom ];

/// Year To
Property AGEYearTo As %Float [ SqlColumnNumber = 6, SqlFieldName = AGE_YearTo ];

Index RowIDBasedIDKeyIndex On AGEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchAgeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchAgeDepend","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchAgeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchAgeDepend","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchAgeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchAgeDepend","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchAgeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchAgeDepend","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchAgeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchAgeDepend","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AGE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AGE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AGE_DayFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AGE_DayTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AGE_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AGE_Name">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AGE_Perc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AGE_VisitType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AGE_YearFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AGE_YearTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AGE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AGE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AGE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVisTypeDate">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AGE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AGE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"VisTypeDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AGE_VisitType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AGE_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{AGE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>AGE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchAgeDependS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
