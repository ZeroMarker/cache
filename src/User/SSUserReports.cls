/// SS User Reports(1271)
Class User.SSUserReports Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserReports, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property USREPCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = USREP_CTLOC_DR ];

/// Childsub
Property USREPChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p(%d(0),$c(1)),"USREP",0))}, SqlColumnNumber = 2, SqlFieldName = USREP_Childsub ];

/// Des Ref Device
Property USREPDeviceDR As SSDevice [ SqlColumnNumber = 4, SqlFieldName = USREP_Device_DR ];

/// SS_User Parent Reference
Relationship USREPParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserReports, Required, SqlFieldName = USREP_ParRef ];

/// Des Ref Report(Module Report)
Property USREPReportDR As CTModules [ SqlColumnNumber = 3, SqlFieldName = USREP_Report_DR ];

Index RowIDBasedIDKeyIndex On USREPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserReports).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserReports","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserReports).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserReports","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserReports).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserReports","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserReports).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserReports","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserReports).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserReports","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="USREPCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="USREPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="USREPDeviceDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="USREPParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="USREPReportDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="USREP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="USREP_Device_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="USREP_Report_DR">
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
<Field>USREP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USREP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{USREP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReportGroup">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>USREP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"USREP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Rep"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{USREP_Report_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{USREP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>USREP_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserReportsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
