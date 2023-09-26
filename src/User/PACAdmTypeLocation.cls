/// PAC Adm Type Location(1560)
Class User.PACAdmTypeLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AdmTypeLocation, StorageStrategy = SQLStorage ]
{

/// AdmType
Property ADMLOCAdmType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,HealthPromotion", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ SqlColumnNumber = 2, SqlFieldName = ADMLOC_AdmType ];

/// Des Ref CTLOC_DR
Property ADMLOCCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = ADMLOC_CTLOC_DR ];

/// Location Description
Property ADMLOCLocDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlComputeCode = { s {ADMLOC_LocDesc}=$$CO04^at1560({ADMLOC_CTLOC_DR})
}, SqlComputed, SqlFieldName = ADMLOC_LocDesc, Transient ];

Parameter EXTENTSIZE = 34;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAdmTypeLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACAdmTypeLocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAdmTypeLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACAdmTypeLocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAdmTypeLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACAdmTypeLocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAdmTypeLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACAdmTypeLocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAdmTypeLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACAdmTypeLocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>34</ExtentSize>
<Property name="ADMLOCAdmType">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ADMLOCCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADMLOCLocDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ADMLOC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADMLOC_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADMLOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADMLOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADMLOC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ADMLOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AdmType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADMLOC_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMLOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADMLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmTypeDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ADMLOC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADMLOC_AdmType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ADMLOC_LocDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADMLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADMLOC_RowId</SqlRowIdName>
<StreamLocation>^User.PACAdmTypeLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
