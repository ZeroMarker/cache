/// ARC Item Generic(1846)
Class User.ARCItemGeneric Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemGeneric, StorageStrategy = SQLStorage ]
{

/// ARCIM Description
Property GENARCIMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GEN_ARCIM_Desc ];

/// ARCIM_Row
Property GENARCIMRow As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlComputeCode = { s {GEN_ARCIM_Row}={GEN_ParRef}
}, SqlComputed, SqlFieldName = GEN_ARCIM_Row, Transient ];

/// ARCIM_Type
Property GENARCIMType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s {GEN_ARCIM_Type}="ARCIM"
}, SqlComputed, SqlFieldName = GEN_ARCIM_Type, Transient ];

/// Childsub
Property GENChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"GEN",0))}, SqlColumnNumber = 2, SqlFieldName = GEN_Childsub ];

/// Des Ref Generic
Property GENGenericDR As PHCGeneric [ SqlColumnNumber = 3, SqlFieldName = GEN_Generic_DR ];

/// Generic Description
Property GENGenericDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GEN_GenericDesc ];

/// ARC_ItmMast Parent Reference
Relationship GENParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemGeneric, Required, SqlFieldName = GEN_ParRef ];

/// Visible
Property GENVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = GEN_Visible ];

Index RowIDBasedIDKeyIndex On GENChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemGeneric).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemGeneric","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemGeneric).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemGeneric","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemGeneric).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemGeneric","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemGeneric).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemGeneric","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemGeneric).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemGeneric","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="GEN_ARCIM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GEN_ARCIM_Row">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GEN_ARCIM_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GEN_GenericDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GEN_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GEN_Visible">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
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
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GEN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GEN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias1">
<Data name="GEN_ARCIM_Row">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GEN_ARCIM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GEN_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{GEN_Childsub}</Expression>
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GEN_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({GEN_ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAlias2">
<Data name="GEN_ARCIM_Row">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GEN_ARCIM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GEN_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{GEN_Childsub}</Expression>
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GEN_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({GEN_ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAlias3">
<Condition>$$visible^at115({GEN_Visible})="Y"</Condition>
<Data name="GEN_ARCIM_Row">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GEN_ARCIM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GEN_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{GEN_Childsub}</Expression>
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GEN_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({GEN_ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAlias4">
<Condition>$$visible^at115({GEN_Visible})="Y"</Condition>
<Data name="GEN_ARCIM_Row">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GEN_ARCIM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GEN_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{GEN_Childsub}</Expression>
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({GEN_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({GEN_ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGener1">
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
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GEN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Gener"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GEN_Generic_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{GEN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGeneric2">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>GEN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gen2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GEN_Generic_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GEN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GEN_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemGenericS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
