/// LocCPType(2213)
Class User.CTLocCPType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocCPType, StorageStrategy = SQLStorage ]
{

/// Des Ref CareProvType
Property CPTCareProvTypeDR As PACCareType [ SqlColumnNumber = 3, SqlFieldName = CPT_CareProvType_DR ];

/// Childsub
Property CPTChildsub As %Float [ InitialExpression = {$i(^CTLOC($p(%d(0),$c(1)),"CPT",0))}, SqlColumnNumber = 2, SqlFieldName = CPT_Childsub ];

/// CT_Loc Parent Reference
Relationship CPTParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocCPType, Required, SqlFieldName = CPT_ParRef ];

Index RowIDBasedIDKeyIndex On CPTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocCPType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocCPType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocCPType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocCPType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocCPType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocCPType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocCPType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocCPType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocCPType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocCPType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="CPTCareProvTypeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CPTChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CPTParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="CPT_CareProvType_DR">
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
<Field>CPT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CPT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPT_CareProvType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CPT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CPT_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocCPTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
