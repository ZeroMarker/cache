/// NR Nurse Rostering(1050)
Class User.NRNurseRostering Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = NR_Nurse_Rostering, StorageStrategy = SQLStorage ]
{

Relationship ChildNRNurseRosterRoom As NRNurseRosterRoom [ Cardinality = children, Inverse = NURRParRef ];

/// Date
Property NURDate As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = NUR_Date ];

/// Nurse Des Ref to CTCP
Property NURNurseDR As CTCareProv [ Required, SqlColumnNumber = 4, SqlFieldName = NUR_Nurse_DR ];

/// Schedule Type Des Ref to PACSched
Property NURSchedTypeDR As NRCScheduleCategory [ SqlColumnNumber = 5, SqlFieldName = NUR_SchedType_DR ];

/// Ward Des Ref to Ward
Property NURWardDR As PACWard [ SqlColumnNumber = 3, SqlFieldName = NUR_Ward_DR ];

Parameter EXTENTSIZE = 33;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.NRNurseRostering).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRostering","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.NRNurseRostering).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRostering","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.NRNurseRostering).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRostering","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.NRNurseRostering).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRostering","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.NRNurseRostering).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRostering","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>33</ExtentSize>
<Property name="NURDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="NURNurseDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NURSchedTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NURWardDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^NURSE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NUR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NUR_Nurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NUR_SchedType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NUR_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^NURSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{NUR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^NURSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NUR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NUR_Ward_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NUR_Nurse_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNurse">
<Global>^NURSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Nurse"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NUR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NUR_Nurse_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NUR_RowId</SqlRowIdName>
<StreamLocation>^User.NRNurseRosteringS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
