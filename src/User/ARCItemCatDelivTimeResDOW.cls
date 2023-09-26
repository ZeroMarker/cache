/// Restrict Day of the week (1703)
Class User.ARCItemCatDelivTimeResDOW Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemCatDelivTimeResDOW, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DOWChildsub As %Float [ InitialExpression = {$i(^ARC("IC",$p(%d(0),"||"),"DTR",$p(%d(0),"||",2),"DOW",0))}, SqlColumnNumber = 2, SqlFieldName = DOW_Childsub ];

/// Date From
Property DOWDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DOW_DateFrom ];

/// Date To
Property DOWDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DOW_DateTo ];

/// Des Ref DayOfWeek
Property DOWDayOfWeekDR As CTDayOfWeek [ SqlColumnNumber = 5, SqlFieldName = DOW_DayOfWeek_DR ];

/// ARC_ItemCatDelivTimeRes Parent Reference
Relationship DOWParRef As ARCItemCatDelivTimeRes [ Cardinality = parent, Inverse = ChildARCItemCatDelivTimeResDOW, Required, SqlFieldName = DOW_ParRef ];

Index RowIDBasedIDKeyIndex On DOWChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemCatDelivTimeResDOW).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeResDOW","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemCatDelivTimeResDOW).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeResDOW","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemCatDelivTimeResDOW).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeResDOW","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemCatDelivTimeResDOW).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeResDOW","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemCatDelivTimeResDOW).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemCatDelivTimeResDOW","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DOW_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOW_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOW_DayOfWeek_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ItemCat.ARCIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARC_ItemCatDelivTimeRes.DTR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>DOW_Childsub</Field>
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
<Expression>{ARC_ItemCatDelivTimeRes.DTR_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DOW"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DOW_Childsub}</Expression>
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
<Expression>{L4}</Expression>
<Field>ARC_ItemCatDelivTimeRes.DTR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>DOW_Childsub</Field>
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
<Expression>{ARC_ItemCatDelivTimeRes.DTR_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"DOW"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DOW_DateFrom}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{DOW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DOW_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemCatDelivTimeResDOWS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
