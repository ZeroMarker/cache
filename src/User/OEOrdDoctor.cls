/// OE_OrdDoctor(1920)
Class User.OEOrdDoctor Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdDoctor, StorageStrategy = SQLStorage ]
{

/// Des Ref CTPCP
Property DOCCTPCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = DOC_CTPCP_DR ];

/// Childsub
Property DOCChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DOC",0))}, SqlColumnNumber = 2, SqlFieldName = DOC_Childsub ];

/// OE_OrdItem Parent Reference
Relationship DOCParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdDoctor, Required, SqlFieldName = DOC_ParRef ];

Index RowIDBasedIDKeyIndex On DOCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 405;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdDoctor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdDoctor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdDoctor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdDoctor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdDoctor).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdDoctor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdDoctor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdDoctor","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdDoctor).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.OEOrdDoctor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>405</ExtentSize>
<Property name="DOCCTPCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DOCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DOCParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DOC_CTPCP_DR">
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
<Field>DOC_Childsub</Field>
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
<Expression>"DOC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DOC_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdDoctorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
