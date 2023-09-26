/// Event CP Attender(2295)
Class User.RBEventCPAttender Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_EventCPAttender, StorageStrategy = SQLStorage ]
{

/// Arrived
Property CPATArrived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CPAT_Arrived ];

/// Des Ref CareProv
Property CPATCareProvDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = CPAT_CareProv_DR ];

/// Childsub
Property CPATChildsub As %Float [ InitialExpression = {$i(^RBEV($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CPAT",0))}, SqlColumnNumber = 2, SqlFieldName = CPAT_Childsub ];

/// RB_Event Parent Reference
Relationship CPATParRef As RBEvent [ Cardinality = parent, Inverse = ChildRBEventCPAttender, Required, SqlFieldName = CPAT_ParRef ];

/// RSVP
Property CPATRSVP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CPAT_RSVP ];

/// Restricted Booking
Property CPATRestrictedBooking As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CPAT_RestrictedBooking ];

Index RowIDBasedIDKeyIndex On CPATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 65;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBEventCPAttender).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPAttender","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBEventCPAttender).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPAttender","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBEventCPAttender).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPAttender","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBEventCPAttender).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPAttender","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBEventCPAttender).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventCPAttender","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>65</ExtentSize>
<Property name="CPATArrived">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPATCareProvDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPATParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CPATRSVP">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPATRestrictedBooking">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CPAT_Arrived">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPAT_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPAT_RSVP">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPAT_RestrictedBooking">
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
<Field>CPAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CPAT_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventCPAttenderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
