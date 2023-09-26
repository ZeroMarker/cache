/// Restrict day of the week(1708)
Class User.ARCItemDelivTimeResDOW Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemDelivTimeResDOW, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DOWChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"DTR",$p(%d(0),"||",3),"DOW",0))}, SqlColumnNumber = 2, SqlFieldName = DOW_Childsub ];

/// Date From
Property DOWDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DOW_DateFrom ];

/// Date To
Property DOWDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DOW_DateTo ];

/// Des Ref DayOfWeek
Property DOWDayOfWeekDR As CTDayOfWeek [ SqlColumnNumber = 5, SqlFieldName = DOW_DayOfWeek_DR ];

/// ARC_ItemDelivTimeRes Parent Reference
Relationship DOWParRef As ARCItemDelivTimeRes [ Cardinality = parent, Inverse = ChildARCItemDelivTimeResDOW, Required, SqlFieldName = DOW_ParRef ];

Index RowIDBasedIDKeyIndex On DOWChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemDelivTimeResDOW).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeResDOW","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemDelivTimeResDOW).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeResDOW","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemDelivTimeResDOW).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeResDOW","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemDelivTimeResDOW).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeResDOW","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemDelivTimeResDOW).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemDelivTimeResDOW","OnBeforeUpdate")
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
<Field>ARC_ItemDelivTimeRes.DTR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>DOW_Childsub</Field>
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
<Expression>{ARC_ItemDelivTimeRes.DTR_Childsub}</Expression>
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
<Expression>{L4}</Expression>
<Field>ARC_ItemDelivTimeRes.DTR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L10}</Expression>
<Field>DOW_Childsub</Field>
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
<Expression>{ARC_ItemDelivTimeRes.DTR_Childsub}</Expression>
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
<Expression>{DOW_DayOfWeek_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{DOW_DateFrom}</Expression>
</Subscript>
<Subscript name="10">
<Expression>{DOW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DOW_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemDelivTimeResDOWS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
