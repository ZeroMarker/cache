/// OrdExecStatus(2726)
Class User.OEOrdExecStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdExecStatus, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STCHChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdExec Parent Reference
Relationship STCHParRef As OEOrdExec [ Cardinality = parent, Inverse = ChildOEOrdExecStatus, Required, SqlFieldName = STCH_ParRef ];

/// Childsub
Property STCHChildsub As %Float [ InitialExpression = {$i(^OEORD($p(initvalue,"||"),"I",$p(initvalue,"||",2),"X",$p(initvalue,"||",3),"STCH",0))}, SqlColumnNumber = 2, SqlFieldName = STCH_Childsub ];

/// Des Ref AdminStatus
Property STCHAdminStatusDR As OECOrderAdminStatus [ SqlColumnNumber = 3, SqlFieldName = STCH_AdminStatus_DR ];

/// Des Ref Status Change Reason
Property STCHReasonDR As OECAdminStatusChReason [ SqlColumnNumber = 4, SqlFieldName = STCH_Reason_DR ];

/// Date
Property STCHDate As %Date [ SqlColumnNumber = 5, SqlFieldName = STCH_Date ];

/// Time
Property STCHTime As %Time [ SqlColumnNumber = 6, SqlFieldName = STCH_Time ];

/// Des Ref User
Property STCHUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = STCH_User_DR ];

Property STCHReasonComtent As %String [ SqlColumnNumber = 8, SqlFieldName = STCH_ReasonDesc ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdExecStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExecStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdExecStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExecStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdExecStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExecStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdExecStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExecStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdExecStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdExecStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="STCH_AdminStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STCH_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STCH_ReasonDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STCH_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STCH_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STCH_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
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
<Field>OE_OrdExec.OEORE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>STCH_Childsub</Field>
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
<Expression>"X"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdExec.OEORE_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"STCH"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{STCH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateTimeIndex">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OE_OrdExec.OEORE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>STCH_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STCHDateT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STCH_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STCH_Time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OE_OrdExec.OEORE_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{STCH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STCH_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdExecStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
