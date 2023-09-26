/// PersonConsultSetCons(2707)
Class User.PAPersonConsultSetCons Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonConsultSetCons, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONSChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPAPersonConsultSetConsR As PAPersonConsultSetConsR [ Cardinality = children, Inverse = CONSRParRef ];

/// PA_PersonConsultSet Parent Reference
Relationship CONSParRef As PAPersonConsultSet [ Cardinality = parent, Inverse = ChildPAPersonConsultSetCons, Required, SqlFieldName = CONS_ParRef ];

/// Childsub
Property CONSChildsub As %Float [ InitialExpression = {$i(^PA("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"CONSET",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"CONS",0))}, SqlColumnNumber = 2, SqlFieldName = CONS_Childsub ];

/// Des Ref PAADM
Property CONSPAADMDR As PAAdm [ SqlColumnNumber = 3, SqlFieldName = CONS_PAADM_DR ];

/// VisitDate
Property CONSVisitDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CONS_VisitDate ];

/// VisitTime
Property CONSVisitTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CONS_VisitTime ];

/// Des Ref CTPCP
Property CONSCTPCPDR As CTCareProv [ SqlColumnNumber = 6, SqlFieldName = CONS_CTPCP_DR ];

/// Des Ref PreviousConsult
Property CONSPreviousConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 7, SqlFieldName = CONS_PreviousConsult_DR ];

/// Significant
Property CONSSignificant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = CONS_Significant ];

/// EndDate
Property CONSEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CONS_EndDate ];

/// EndTime
Property CONSEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CONS_EndTime ];

/// Status
Property CONSStatus As %String(DISPLAYLIST = ",In Progress,End,Suspended", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",I,E,S") [ SqlColumnNumber = 11, SqlFieldName = CONS_Status ];

/// Notes
Property CONSNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CONS_Notes, SqlListType = subnode ];

/// Des Ref FollowupOrder
Property CONSFollowupOrderDR As OEOrdItem [ SqlColumnNumber = 13, SqlFieldName = CONS_FollowupOrder_DR ];

/// Des Ref APPT
Property CONSAPPTDR As RBAppointment [ SqlColumnNumber = 14, SqlFieldName = CONS_APPT_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonConsultSetCons).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetCons","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonConsultSetCons).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetCons","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonConsultSetCons).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetCons","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonConsultSetCons).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetCons","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetCons","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonConsultSetCons).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonConsultSetCons","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CONS_APPT_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CONS_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONS_FollowupOrder_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CONS_Notes">
<Node>"REM"</Node>
</Data>
<Data name="CONS_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONS_PreviousConsult_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONS_Significant">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONS_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONS_VisitDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONS_VisitTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_Consult.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PA_PersonConsultSet.CONSET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>CONS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_Consult.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CONSET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_PersonConsultSet.CONSET_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"CONS"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="6">
<Expression>{CONS_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^PAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Consult.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PA_PersonConsultSet.CONSET_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>CONS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONSAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CONS_PAADM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Consult.CONS_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_PersonConsultSet.CONSET_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CONS_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonConsultSetConsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
