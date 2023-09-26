/// ARC Item Delivery Time for Res(1707
Class User.ARCItemDelivTimeRes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemDelivTimeRes, StorageStrategy = SQLStorage ]
{

Relationship ChildARCItemDelivTimeResDOW As ARCItemDelivTimeResDOW [ Cardinality = children, Inverse = DOWParRef ];

/// Childsub
Property DTRChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"DTR",0))}, SqlColumnNumber = 2, SqlFieldName = DTR_Childsub ];

/// Date From
Property DTRDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DTR_DateFrom ];

/// Date To
Property DTRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DTR_DateTo ];

/// ARC_ItmMast Parent Reference
Relationship DTRParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemDelivTimeRes, Required, SqlFieldName = DTR_ParRef ];

/// Des Ref Priority
Property DTRPriorityDR As OECPriority [ SqlColumnNumber = 5, SqlFieldName = DTR_Priority_DR ];

/// Des Ref RecLoc
Property DTRRecLocDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = DTR_RecLoc_DR ];

/// Time
Property DTRTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DTR_Time ];

Index RowIDBasedIDKeyIndex On DTRChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemDelivTimeRes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeRes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemDelivTimeRes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeRes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemDelivTimeRes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeRes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemDelivTimeRes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeRes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemDelivTimeRes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeRes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="DTRChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DTRDateFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DTRDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DTRParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DTRPriorityDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DTRRecLocDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DTRTime">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DTR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DTR_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DTR_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DTR_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>DTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DTR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>DTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DTR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DTR_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DTR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DTR_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemDelivTimeResS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
