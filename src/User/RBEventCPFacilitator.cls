/// Event CP Facilitator(2294)
Class User.RBEventCPFacilitator Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_EventCPFacilitator, StorageStrategy = SQLStorage ]
{

/// Arrived
Property CPFArrived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = CPF_Arrived ];

/// Des Ref CareProv
Property CPFCareProvDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = CPF_CareProv_DR ];

/// Childsub
Property CPFChildsub As %Float [ InitialExpression = {$i(^RBEV($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CPF",0))}, SqlColumnNumber = 2, SqlFieldName = CPF_Childsub ];

/// RB_Event Parent Reference
Relationship CPFParRef As RBEvent [ Cardinality = parent, Inverse = ChildRBEventCPFacilitator, Required, SqlFieldName = CPF_ParRef ];

/// RSVP
Property CPFRSVP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CPF_RSVP ];

/// Restricted Booking
Property CPFRestrictedBooking As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CPF_RestrictedBooking ];

Index RowIDBasedIDKeyIndex On CPFChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 70;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBEventCPFacilitator).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPFacilitator","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBEventCPFacilitator).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPFacilitator","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBEventCPFacilitator).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPFacilitator","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBEventCPFacilitator).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPFacilitator","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBEventCPFacilitator).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPFacilitator","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>70</ExtentSize>
<Property name="CPFArrived">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPFCareProvDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPFChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPFParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPFRSVP">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPFRestrictedBooking">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CPF_Arrived">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPF_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPF_RSVP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPF_RestrictedBooking">
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
<Field>CPF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CPF_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventCPFacilitatorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
