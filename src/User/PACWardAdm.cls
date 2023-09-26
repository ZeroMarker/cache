/// Ward Adm(2319)
Class User.PACWardAdm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WardAdm, StorageStrategy = SQLStorage ]
{

/// Booked Status
Property WADMBookedStatus As %String(DISPLAYLIST = ",Booked,Occupied,Requested", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",B,O,R") [ SqlColumnNumber = 4, SqlFieldName = WADM_BookedStatus ];

/// Childsub
Property WADMChildsub As %Float [ InitialExpression = {$i(^PAWARDA($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"WADM",0))}, SqlColumnNumber = 2, SqlFieldName = WADM_Childsub ];

/// Des Ref PAADM
Property WADMPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = WADM_PAADM_DR ];

/// PAC_Ward Parent Reference
Relationship WADMParRef As PACWard [ Cardinality = parent, Inverse = ChildPACWardAdm, Required, SqlFieldName = WADM_ParRef ];

/// Des Ref Room
Property WADMRoomDR As PACRoom [ SqlColumnNumber = 6, SqlFieldName = WADM_Room_DR ];

/// Des Ref Trans
Property WADMTransDR As PAAdmTransaction [ SqlColumnNumber = 5, SqlFieldName = WADM_Trans_DR ];

Index RowIDBasedIDKeyIndex On WADMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 494;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWardAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardAdm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWardAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardAdm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWardAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardAdm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWardAdm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardAdm","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWardAdm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWardAdm","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>494</ExtentSize>
<Property name="WADMBookedStatus">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="WADMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="WADMPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WADMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="WADMRoomDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="WADMTransDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="WADM_BookedStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WADM_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WADM_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WADM_Trans_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAWARDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"WADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WADM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Condition>'{WADM_Room_DR}</Condition>
<ConditionFields>WADM_Room_DR</ConditionFields>
<Global>^PAWARDA</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoom">
<Condition>{WADM_Room_DR}</Condition>
<ConditionFields>WADM_Room_DR</ConditionFields>
<Global>^PAWARDA</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>WADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WADM_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoom1">
<Global>^PAWARDA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>WADM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WADM_Room_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WADM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WADM_RowId</SqlRowIdName>
<StreamLocation>^User.PACWardAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
