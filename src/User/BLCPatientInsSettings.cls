/// BLC Patient Insurance Setting(1505)
Class User.BLCPatientInsSettings Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_PatientInsSettings, StorageStrategy = SQLStorage ]
{

/// Type of Insurance
Property INSInsuranceType As %String(DISPLAYLIST = ",Single,Multiple-Rank,Multiple-Main", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",S,R,M") [ Required, SqlColumnNumber = 3, SqlFieldName = INS_InsuranceType ];

/// Patient Type
Property INSPatientType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ Required, SqlColumnNumber = 2, SqlFieldName = INS_PatientType ];

Index INSPatientTypeUnqIdx1 On INSPatientType [ Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCPatientInsSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCPatientInsSettings","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCPatientInsSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCPatientInsSettings","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCPatientInsSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCPatientInsSettings","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCPatientInsSettings).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCPatientInsSettings","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCPatientInsSettings).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCPatientInsSettings","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="INSInsuranceType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INSPatientType">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("INSPAT",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="INS_InsuranceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_PatientType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatType">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PatType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INS_PatientType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.BLCPatientInsSettingsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
