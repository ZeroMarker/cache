/// ARC Surch Time Depend(1213)
Class User.ARCSurchTimeDepend Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SurchTimeDepend, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TIMEChildsub As %Float [ InitialExpression = {$i(^ARC("SURC",$p(%d(0),$c(1)),"TIME",0))}, SqlColumnNumber = 2, SqlFieldName = TIME_Childsub ];

/// Day Of Week From
Property TIMEDOWFrom As CTDayOfWeek [ SqlColumnNumber = 5, SqlFieldName = TIME_DOWFrom ];

/// Day Of Week To
Property TIMEDOWTo As CTDayOfWeek [ SqlColumnNumber = 6, SqlFieldName = TIME_DOWTo ];

/// Date From
Property TIMEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = TIME_DateFrom ];

/// Date To
Property TIMEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = TIME_DateTo ];

/// Fixed Amt
Property TIMEFixedAmt As %Float [ SqlColumnNumber = 10, SqlFieldName = TIME_FixedAmt ];

/// Description
Property TIMEName As %String(COLLATION = "Exact", MAXLEN = 78, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = TIME_Name ];

/// ARC_SurchargeCode Parent Reference
Relationship TIMEParRef As ARCSurchargeCode [ Cardinality = parent, Inverse = ChildARCSurchTimeDepend, Required, SqlFieldName = TIME_ParRef ];

/// % Charge
Property TIMEPerc As %Float [ SqlColumnNumber = 11, SqlFieldName = TIME_Perc ];

/// Time From
Property TIMETimeFrom As %Time [ SqlColumnNumber = 7, SqlFieldName = TIME_TimeFrom ];

/// Time To
Property TIMETimeTo As %Time [ SqlColumnNumber = 8, SqlFieldName = TIME_TimeTo ];

/// Visit Type
Property TIMEVisitType As %String(DISPLAYLIST = ",Normal,First Visit,Second and Other", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,F,S") [ SqlColumnNumber = 9, SqlFieldName = TIME_VisitType ];

Index RowIDBasedIDKeyIndex On TIMEChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSurchTimeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchTimeDepend","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSurchTimeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchTimeDepend","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSurchTimeDepend).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchTimeDepend","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSurchTimeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchTimeDepend","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSurchTimeDepend).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCSurchTimeDepend","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TIME_DOWFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TIME_DOWTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TIME_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TIME_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TIME_FixedAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TIME_Name">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TIME_Perc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TIME_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TIME_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TIME_VisitType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_SurchargeCode.SURC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>TIME_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TIME_Childsub}</Expression>
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
<Field>TIME_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_SurchargeCode.SURC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"VisTypeDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TIME_VisitType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{TIME_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{TIME_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TIME_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSurchTimeDependS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
