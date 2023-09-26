/// Deliv Time for Results(1702)
Class User.ARCItemCatDelivTimeRes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemCatDelivTimeRes, StorageStrategy = SQLStorage ]
{

Relationship ChildARCItemCatDelivTimeResDOW As ARCItemCatDelivTimeResDOW [ Cardinality = children, Inverse = DOWParRef ];

/// Childsub
Property DTRChildsub As %Float [ InitialExpression = {$i(^ARC("IC",$p(%d(0),$c(1)),"DTR",0))}, SqlColumnNumber = 2, SqlFieldName = DTR_Childsub ];

/// Date From
Property DTRDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DTR_DateFrom ];

/// Date To
Property DTRDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DTR_DateTo ];

/// ARC_ItemCat Parent Reference
Relationship DTRParRef As ARCItemCat [ Cardinality = parent, Inverse = ChildARCItemCatDelivTimeRes, Required, SqlFieldName = DTR_ParRef ];

/// Des Ref Priority
Property DTRPriorityDR As OECPriority [ SqlColumnNumber = 5, SqlFieldName = DTR_Priority_DR ];

/// Des Ref RecLoc
Property DTRRecLocDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = DTR_RecLoc_DR ];

/// Time
Property DTRTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DTR_Time ];

Index RowIDBasedIDKeyIndex On DTRChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemCatDelivTimeRes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeRes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemCatDelivTimeRes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeRes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemCatDelivTimeRes).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeRes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemCatDelivTimeRes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeRes","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemCatDelivTimeRes).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeRes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
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
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ItemCat.ARCIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItemCat.ARCIC_RowId}</Expression>
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
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ItemCat.ARCIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DTR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItemCat.ARCIC_RowId}</Expression>
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
<StreamLocation>^User.ARCItemCatDelivTimeResS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
