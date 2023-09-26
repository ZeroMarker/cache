/// Ord Day Book SpecimType(2312)
Class User.OEOrdDBSpecimType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdDBSpecimType, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DBSPECChildsub As %Float [ InitialExpression = {$i(^OEORD($p(%d(0),"||"),"I",$p(%d(0),"||",2),"DBSPEC",0))}, SqlColumnNumber = 2, SqlFieldName = DBSPEC_Childsub ];

/// OE_OrdItem Parent Reference
Relationship DBSPECParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdDBSpecimType, Required, SqlFieldName = DBSPEC_ParRef ];

/// Spec Type
Property DBSPECSpecType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DBSPEC_SpecType ];

Index RowIDBasedIDKeyIndex On DBSPECChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdDBSpecimType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdDBSpecimType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdDBSpecimType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdDBSpecimType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdDBSpecimType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdDBSpecimType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdDBSpecimType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdDBSpecimType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdDBSpecimType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdDBSpecimType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DBSPEC_SpecType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Field>DBSPEC_Childsub</Field>
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
<Expression>"DBSPEC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DBSPEC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DBSPEC_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdDBSpecimTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
