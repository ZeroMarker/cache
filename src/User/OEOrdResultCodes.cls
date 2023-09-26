/// OE Ord Result Code(1464)
Class User.OEOrdResultCodes Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdResultCodes, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CODChildsub As %Float [ InitialExpression = {$i(^OEORD($p(%d(0),"||"),"I",$p(%d(0),"||",2),"RES",$p(%d(0),"||",3),"COD",0))}, SqlColumnNumber = 2, SqlFieldName = COD_Childsub ];

/// OE_OrdResult Parent Reference
Relationship CODParRef As OEOrdResult [ Cardinality = parent, Inverse = ChildOEOrdResultCodes, Required, SqlFieldName = COD_ParRef ];

/// Des Ref Word Resut Code
Property CODWordResutCodeDR As MRCWordResultCode [ SqlColumnNumber = 3, SqlFieldName = COD_WordResutCode_DR ];

Index RowIDBasedIDKeyIndex On CODChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdResultCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdResultCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdResultCodes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdResultCodes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultCodes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdResultCodes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdResultCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="COD_WordResutCode_DR">
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
<Field>OE_OrdResult.RES_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>COD_Childsub</Field>
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
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdResult.RES_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"COD"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{COD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>COD_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdResultCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
