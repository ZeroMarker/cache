/// PAC Counter Setup(1533)
Class User.PACCounterSetup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CounterSetup, StorageStrategy = SQLStorage ]
{

/// Des Ref Counter Type
Property SETCounterTypeDR As PACCounterType [ SqlColumnNumber = 5, SqlFieldName = SET_CounterType_DR ];

/// Des Ref EpisSubType
Property SETEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 3, SqlFieldName = SET_EpisSubType_DR ];

/// Episode Type
Property SETEpisodeType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,Health Promotion", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ Required, SqlColumnNumber = 2, SqlFieldName = SET_EpisodeType ];

/// Des Ref Hospital
Property SETHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = SET_Hospital_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACCounterSetup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterSetup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACCounterSetup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterSetup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACCounterSetup).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterSetup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACCounterSetup).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterSetup","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACCounterSetup).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACCounterSetup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SETCounterTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETEpisSubTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETEpisodeType">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SETHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("CNTSET",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SET_CounterType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SET_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SET_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SET_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CNTSET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SET_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEpisType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CNTSET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AdmType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SET_EpisodeType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SET_RowId</SqlRowIdName>
<StreamLocation>^User.PACCounterSetupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
