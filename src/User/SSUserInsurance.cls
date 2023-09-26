/// SS User Insurance(1651)
Class User.SSUserInsurance Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserInsurance, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property INSAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 5, SqlFieldName = INS_AuxInsType_DR ];

/// Des Ref CTLOC
Property INSCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = INS_CTLOC_DR ];

/// Childsub
Property INSChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p(%d(0),$c(1)),"INS",0))}, SqlColumnNumber = 2, SqlFieldName = INS_Childsub ];

/// EpisodeType
Property INSEpisodeType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,HealthPromotion", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",O,I,E,H") [ SqlColumnNumber = 6, SqlFieldName = INS_EpisodeType ];

/// Des Ref InsType
Property INSInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 3, SqlFieldName = INS_InsType_DR ];

/// SS_User Parent Reference
Relationship INSParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserInsurance, Required, SqlFieldName = INS_ParRef ];

Index RowIDBasedIDKeyIndex On INSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserInsurance).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserInsurance","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserInsurance).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserInsurance","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserInsurance).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserInsurance","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserInsurance).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserInsurance","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserInsurance).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserInsurance","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="INSAuxInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSEpisodeType">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INSInsTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INSParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="INS_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INS_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsBlankLoc">
<Condition>{INS_CTLOC_DR}=""</Condition>
<Global>^SSU</Global>
<PopulationPct>60</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"InsTypeDef"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INS_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INS_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserInsuranceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
