/// Operation Additional Staff (2533)
Class User.ORAnOperAdditionalStaff Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OR_An_Oper_Additional_Staff, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OPASChildsub [ IdKey, PrimaryKey, Unique ];

/// OR_Anaest_Operation Parent Reference
Relationship OPASParRef As ORAnaestOperation [ Cardinality = parent, Inverse = ChildORAnOperAdditionalStaff, Required, SqlFieldName = OPAS_ParRef ];

/// Childsub
Property OPASChildsub As %Float [ InitialExpression = {$i(^OR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ANA",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"OP",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"OPAS",0))}, SqlColumnNumber = 2, SqlFieldName = OPAS_Childsub ];

/// Care Provider Type
Property OPASCareProvType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OPAS_CareProvType ];

/// Des Ref CTCareProv
Property OPASCareProvDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = OPAS_CareProv_DR ];

/// Des Ref ORC_OPeration
Property OPASOperationDR As ORCOperation [ SqlColumnNumber = 5, SqlFieldName = OPAS_Operation_DR ];

/// des ref PAC_StatePPP
Property OPASStatePPPDR As PACStatePPP [ SqlColumnNumber = 6, SqlFieldName = OPAS_StatePPP_DR ];

/// Start Date
Property OPASStartDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OPAS_StartDate ];

/// Start Time
Property OPASStartTime As %Time [ SqlColumnNumber = 8, SqlFieldName = OPAS_StartTime ];

/// End Date
Property OPASEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = OPAS_EndDate ];

/// End Time
Property OPASEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = OPAS_EndTime ];

/// Des Ref CT_Loc
Property OPASCPLocationDR As CTLoc [ SqlColumnNumber = 11, SqlFieldName = OPAS_CPLocation_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORAnOperAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperAdditionalStaff","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORAnOperAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperAdditionalStaff","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORAnOperAdditionalStaff).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperAdditionalStaff","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORAnOperAdditionalStaff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperAdditionalStaff","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORAnOperAdditionalStaff).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORAnOperAdditionalStaff","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OPAS_CPLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPAS_CareProvType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPAS_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPAS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPAS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPAS_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPAS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPAS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPAS_StatePPP_DR">
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
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>OPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"ANA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OR_Anaesthesia.ANA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="6">
<Expression>"OPAS"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OPAS_Childsub}</Expression>
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
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>OPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CareProvider"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPAS_CareProv_DR}</Expression>
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
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"OPAS"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{OPAS_Childsub}</Expression>
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
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>OPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CareProvType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPAS_CareProvType}</Expression>
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
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"OPAS"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{OPAS_Childsub}</Expression>
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
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>OPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Operation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPAS_Operation_DR}</Expression>
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
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"OPAS"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{OPAS_Childsub}</Expression>
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
<Field>OR_Anaest_Operation.ANAOP_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L9}</Expression>
<Field>OPAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"StatePPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPAS_StatePPP_DR}</Expression>
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
<Expression>"OP"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OR_Anaest_Operation.ANAOP_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>"OPAS"</Expression>
</Subscript>
<Subscript name="9">
<Expression>{OPAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OPAS_RowId</SqlRowIdName>
<StreamLocation>^User.ORAnOperAdditionalStaffS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
