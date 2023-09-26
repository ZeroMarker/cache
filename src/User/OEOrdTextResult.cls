/// OE Order Text Result(1395)
Class User.OEOrdTextResult Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdTextResult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000000;

/// Childsub
Property TRESChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"TR",0))}, SqlColumnNumber = 2, SqlFieldName = TRES_Childsub ];

/// Des Ref OE TextResult
Property TRESOETRDR As OETextResult [ SqlColumnNumber = 3, SqlFieldName = TRES_OETR_DR ];

/// OE_OrdItem Parent Reference
Relationship TRESParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdTextResult, Required, SqlFieldName = TRES_ParRef ];

Index RowIDBasedIDKeyIndex On TRESChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdTextResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdTextResult","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdTextResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdTextResult","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdTextResult).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdTextResult","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdTextResult).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdTextResult","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdTextResult).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdTextResult","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="TRESChildsub">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="TRESOETRDR">
<Selectivity>0.8621%</Selectivity>
</Property>
<Property name="TRESParRef">
<Selectivity>0.8929%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="TRES_OETR_DR">
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
<Field>TRES_Childsub</Field>
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
<Expression>"TR"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTextResult">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TextRes"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TRES_OETR_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRES_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdTextResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
