/// Event Patient(2293)
Class User.RBEventPatient Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_EventPatient, StorageStrategy = SQLStorage ]
{

/// Arrived
Property PATArrived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PAT_Arrived ];

/// Childsub
Property PATChildsub As %Float [ InitialExpression = {$i(^RBEV($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAT",0))}, SqlColumnNumber = 2, SqlFieldName = PAT_Childsub ];

/// Des Ref PAADM
Property PATPAADMDR As PAAdm [ SqlColumnNumber = 7, SqlFieldName = PAT_PAADM_DR ];

/// RB_Event Parent Reference
Relationship PATParRef As RBEvent [ Cardinality = parent, Inverse = ChildRBEventPatient, Required, SqlFieldName = PAT_ParRef ];

/// Des Ref PatMas
Property PATPatMasDR As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PAT_PatMas_DR ];

/// RSVP
Property PATRSVP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PAT_RSVP ];

/// Waiver Fee
Property PATWaiverFee As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PAT_WaiverFee ];

Index RowIDBasedIDKeyIndex On PATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 114;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBEventPatient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventPatient","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBEventPatient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventPatient","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBEventPatient).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventPatient","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBEventPatient).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventPatient","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBEventPatient).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventPatient","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>114</ExtentSize>
<Property name="PATArrived">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="PATPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PATParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="PATPatMasDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PATRSVP">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PATWaiverFee">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="PAT_Arrived">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAT_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAT_PatMas_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAT_RSVP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAT_WaiverFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RBEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Event.EV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPat">
<Global>^RBEVi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RB_Event.EV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAT_PatMas_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAT_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventPatientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
