/// ItemDepartOverride(2421)
Class User.ARCItemDepartOverride Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemDepartOverride, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DOVChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship DOVParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemDepartOverride, Required, SqlFieldName = DOV_ParRef ];

/// Childsub
Property DOVChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DOV",0))}, SqlColumnNumber = 2, SqlFieldName = DOV_Childsub ];

/// Des Ref CTLOC
Property DOVCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = DOV_CTLOC_DR ];

/// Days
Property DOVDays As %Float [ SqlColumnNumber = 4, SqlFieldName = DOV_Days ];

/// Hours
Property DOVHours As %Float [ SqlColumnNumber = 5, SqlFieldName = DOV_Hours ];

/// Date From
Property DOVDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = DOV_DateFrom ];

/// Date To
Property DOVDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = DOV_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemDepartOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDepartOverride","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemDepartOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDepartOverride","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemDepartOverride).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDepartOverride","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemDepartOverride).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDepartOverride","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemDepartOverride).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDepartOverride","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="DOV_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DOV_Days">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOV_Hours">
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
<Field>DOV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DOV"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
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
<Field>DOV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DOV"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DOV_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DOV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DOV_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemDepartOverrideS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
