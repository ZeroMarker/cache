/// LocLinkLocation(2087)
Class User.CTLocLinkLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocLinkLocation, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property LINKCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = LINK_CTLOC_DR ];

/// Childsub
Property LINKChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LINK",0))}, SqlColumnNumber = 2, SqlFieldName = LINK_Childsub ];

/// CT_Loc Parent Reference
Relationship LINKParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocLinkLocation, Required, SqlFieldName = LINK_ParRef ];

Index RowIDBasedIDKeyIndex On LINKChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 15;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocLinkLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocLinkLocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocLinkLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocLinkLocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocLinkLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocLinkLocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocLinkLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocLinkLocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocLinkLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocLinkLocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="LINKCTLOCDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="LINKChildsub">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="LINKParRef">
<Selectivity>14.2857%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="LINK_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LINK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LINK_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LINK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LINK_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocLinkLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
