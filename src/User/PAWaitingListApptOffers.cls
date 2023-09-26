/// WaitingListApptOffers(2749)
Class User.PAWaitingListApptOffers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListApptOffers, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APTOFChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship APTOFParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListApptOffers, Required, SqlFieldName = APTOF_ParRef ];

/// Childsub
Property APTOFChildsub As %Float [ InitialExpression = {$i(^PAWL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"APTOF",0))}, SqlColumnNumber = 2, SqlFieldName = APTOF_Childsub ];

/// Date
Property APTOFDate As %Date [ SqlColumnNumber = 3, SqlFieldName = APTOF_Date ];

/// Des Ref WLOfferType
Property APTOFWLOfferTypeDR As PACWLTypeOfOffers [ SqlColumnNumber = 4, SqlFieldName = APTOF_WLOfferType_DR ];

/// ResponseDate
Property APTOFResponseDate As %Date [ SqlColumnNumber = 5, SqlFieldName = APTOF_ResponseDate ];

/// ResponseComments
Property APTOFResponseComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = APTOF_ResponseComments, SqlListType = subnode ];

/// Des Ref Outcome
Property APTOFOutcomeDR As PACWLOutcomeOfOffers [ SqlColumnNumber = 7, SqlFieldName = APTOF_Outcome_DR ];

/// Des Ref Appointment
Property APTOFAppointmentDR As RBAppointment [ SqlColumnNumber = 8, SqlFieldName = APTOF_Appointment_DR ];

/// Des Ref RBAS
Property APTOFRBASDR As RBApptSchedule [ SqlColumnNumber = 9, SqlFieldName = APTOF_RBAS_DR ];

/// ApptCancelDate
Property APTOFApptCancelDate As %Date [ SqlColumnNumber = 10, SqlFieldName = APTOF_ApptCancelDate ];

/// ApptDate
Property APTOFApptDate As %Date [ SqlColumnNumber = 11, SqlFieldName = APTOF_ApptDate ];

/// ApptTransferDate
Property APTOFApptTransferDate As %Date [ SqlColumnNumber = 12, SqlFieldName = APTOF_ApptTransferDate ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingListApptOffers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListApptOffers","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingListApptOffers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListApptOffers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingListApptOffers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListApptOffers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingListApptOffers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListApptOffers","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingListApptOffers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListApptOffers","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListApptOffers","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="APTOFAppointmentDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="APTOFApptCancelDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APTOFApptDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="APTOFApptTransferDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APTOFChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="APTOFDate">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="APTOFOutcomeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APTOFParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="APTOFRBASDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="APTOFResponseComments">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="APTOFResponseDate">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="APTOFWLOfferTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="APTOF_Appointment_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APTOF_ApptCancelDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APTOF_ApptDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APTOF_ApptTransferDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APTOF_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APTOF_Outcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APTOF_RBAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APTOF_ResponseComments">
<Node>"CMT"</Node>
</Data>
<Data name="APTOF_ResponseDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APTOF_WLOfferType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>APTOF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APTOF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APTOF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppt">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>APTOF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OfferAppt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APTOF_Appointment_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APTOF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRBAS">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>APTOF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OfferRBAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{APTOF_RBAS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APTOF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>APTOF_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListApptOffersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
