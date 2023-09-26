/// ConsultCategObserv(2697)
Class User.OECConsultCategObserv Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ConsultCategObserv, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1;

Index RowIDBasedIDKeyIndex On OBSChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_ConsultCateg Parent Reference
Relationship OBSParRef As OECConsultCateg [ Cardinality = parent, Inverse = ChildOECConsultCategObserv, Required, SqlFieldName = OBS_ParRef ];

/// Childsub
Property OBSChildsub As %Float [ InitialExpression = {$i(^OEC("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"OBS",0))}, SqlColumnNumber = 2, SqlFieldName = OBS_Childsub ];

/// Des Ref ObservGroup
Property OBSObservGroupDR As MRCObservationGroup [ SqlColumnNumber = 3, SqlFieldName = OBS_ObservGroup_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECConsultCategObserv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategObserv","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECConsultCategObserv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategObserv","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECConsultCategObserv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategObserv","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECConsultCategObserv).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategObserv","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECConsultCategObserv).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategObserv","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="OBSChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OBSObservGroupDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="OBSParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="OBS_ObservGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexObsGroup">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OBS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OBS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ObsGrp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OBS_ObservGroup_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OBS_RowId</SqlRowIdName>
<StreamLocation>^User.OECConsultCategObservS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
