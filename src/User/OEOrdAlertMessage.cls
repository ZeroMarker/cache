/// OrdAlertMessage(2664)
Class User.OEOrdAlertMessage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdAlertMessage, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ALMChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdItem Parent Reference
Relationship ALMParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdAlertMessage, Required, SqlFieldName = ALM_ParRef ];

/// Childsub
Property ALMChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ALM",0))}, SqlColumnNumber = 2, SqlFieldName = ALM_Childsub ];

/// AlertType
Property ALMAlertType As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALM_AlertType ];

/// Message
Property ALMMessage As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = ALM_Message, SqlListType = SUBNODE ];

/// Des Ref OverrideReason
Property ALMOverrideReasonDR As OECAlertReason [ SqlColumnNumber = 5, SqlFieldName = ALM_OverrideReason_DR ];

/// Des Ref UserUpdate
Property ALMUserUpdateDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = ALM_UserUpdate_DR ];

/// DateUpdate
Property ALMDateUpdate As %Date [ SqlColumnNumber = 7, SqlFieldName = ALM_DateUpdate ];

/// TimeUpdate
Property ALMTimeUpdate As %Time [ SqlColumnNumber = 8, SqlFieldName = ALM_TimeUpdate ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdAlertMessage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAlertMessage","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdAlertMessage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAlertMessage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdAlertMessage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAlertMessage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdAlertMessage).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAlertMessage","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdAlertMessage).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAlertMessage","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ALM_AlertType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALM_DateUpdate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALM_Message">
<Node>"MSG"</Node>
</Data>
<Data name="ALM_OverrideReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALM_TimeUpdate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALM_UserUpdate_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ALM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ALM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ALM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ALM_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdAlertMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
