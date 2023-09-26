/// Anaesthesia Additional Staff (2532)
Class User.ORAnaestAdditionalStaff Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_AnaestAdditionalStaff, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ANAASChildsub [ IdKey, PrimaryKey, Unique ];

/// OR_Anaesthesia Parent Reference
Relationship ANAASParRef As ORAnaesthesia [ Cardinality = parent, Inverse = ChildORAnaestAdditionalStaff, Required, SqlFieldName = ANAAS_ParRef ];

/// Childsub
Property ANAASChildsub As %Float [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ANA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ANAAS",0))}, SqlColumnNumber = 2, SqlFieldName = ANAAS_Childsub ];

/// Care Provider Type
Property ANAASCareProvType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ANAAS_CareProvType ];

/// Des Ref CT_CareProv
Property ANAASCareProvDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = ANAAS_CareProv_DR ];

/// Des Ref ORC_Operation
Property ANAASOperationDR As ORCOperation [ SqlColumnNumber = 5, SqlFieldName = ANAAS_Operation_DR ];

/// Des Ref PAC_StatePPP
Property ANAASStatePPPDR As PACStatePPP [ SqlColumnNumber = 6, SqlFieldName = ANAAS_StatePPP_DR ];

/// Start Date
Property ANAASStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ANAAS_StartDate ];

/// Start Time
Property ANAASStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ANAAS_StartTime ];

/// End Date
Property ANAASEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = ANAAS_EndDate ];

/// End Time
Property ANAASEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = ANAAS_EndTime ];

/// Des Resf CT_Loc
Property ANAASCPLocationDR As CTLoc [ SqlColumnNumber = 11, SqlFieldName = ANAAS_CPLocation_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnaestAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAdditionalStaff","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnaestAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAdditionalStaff","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnaestAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAdditionalStaff","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnaestAdditionalStaff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAdditionalStaff","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnaestAdditionalStaff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnaestAdditionalStaff","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANAAS_CPLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANAAS_CareProvType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANAAS_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANAAS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANAAS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANAAS_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANAAS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANAAS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANAAS_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ANAAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PA_Adm.PAADM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"ANAAS"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ANAAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareProvType">
<Global>^ORi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ANAAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CareProvider"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANAAS_CareProv_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ANAAS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ANAAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCareProvider">
<Global>^ORi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ANAAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CareProvType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANAAS_CareProvType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ANAAS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ANAAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOperation">
<Global>^ORi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ANAAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Operation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANAAS_Operation_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ANAAS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ANAAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProcedure">
<Global>^ORi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OR_Anaesthesia.ANA_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>ANAAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StatePPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANAAS_StatePPP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ANAAS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ANAAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ANAAS_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnaestAdditionalStaffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
