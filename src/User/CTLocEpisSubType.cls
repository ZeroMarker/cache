/// CT Loc EpisSubType(1760)
Class User.CTLocEpisSubType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocEpisSubType, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SUBTChildsub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1)),"SUBT",0))}, SqlColumnNumber = 2, SqlFieldName = SUBT_Childsub ];

/// Des Ref EpisSubType
Property SUBTEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 3, SqlFieldName = SUBT_EpisSubType_DR ];

/// CT_Loc Parent Reference
Relationship SUBTParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocEpisSubType, Required, SqlFieldName = SUBT_ParRef ];

Index RowIDBasedIDKeyIndex On SUBTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocEpisSubType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocEpisSubType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocEpisSubType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocEpisSubType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocEpisSubType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocEpisSubType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocEpisSubType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocEpisSubType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocEpisSubType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocEpisSubType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="SUBTChildsub">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="SUBTEpisSubTypeDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="SUBTParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SUBT_EpisSubType_DR">
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
<Field>SUBT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUBT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUBT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSubType">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SUBT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUBT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SubType"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUBT_EpisSubType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUBT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUBT_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocEpisSubTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
