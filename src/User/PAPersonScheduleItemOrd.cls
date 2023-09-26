/// PersonScheduleItemOrd(2784)
Class User.PAPersonScheduleItemOrd Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonScheduleItemOrd, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ORDChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_PersonScheduleItem Parent Reference
Relationship ORDParRef As PAPersonScheduleItem [ Cardinality = parent, Inverse = ChildPAPersonScheduleItemOrd, Required, SqlFieldName = ORD_ParRef ];

/// Childsub
Property ORDChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"SCH",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITM",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"ORD",0))}, SqlColumnNumber = 2, SqlFieldName = ORD_Childsub ];

/// Des Ref ARCIM
Property ORDARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ORD_ARCIM_DR ];

/// Des Ref ARCOS
Property ORDARCOSDR As ARCOrdSets [ SqlColumnNumber = 4, SqlFieldName = ORD_ARCOS_DR ];

/// Des Ref OrdItem
Property ORDOrdItemDR As OEOrdItem [ SqlColumnNumber = 5, SqlFieldName = ORD_OrdItem_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAPersonScheduleItemOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItemOrd","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAPersonScheduleItemOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItemOrd","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAPersonScheduleItemOrd).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItemOrd","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAPersonScheduleItemOrd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItemOrd","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAPersonScheduleItemOrd).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItemOrd","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonScheduleItemOrd","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ORD_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ORD_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ORD_OrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_PersonSchedule.SCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PA_PersonScheduleItem.ITM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>ORD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_PersonSchedule.SCH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_PersonScheduleItem.ITM_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ORD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ORD_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonScheduleItemOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
