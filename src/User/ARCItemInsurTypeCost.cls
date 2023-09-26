/// ARCIM InsurTypeCost(1118)
Class User.ARCItemInsurTypeCost Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemInsurTypeCost, StorageStrategy = SQLStorage ]
{

/// Cost
Property COSTAmt As %Float [ Required, SqlColumnNumber = 5, SqlFieldName = COST_Amt ];

/// Childsub
Property COSTChildsub As %Float [ InitialExpression = {$i(^ARCIM($p(%d(0),"||"),$p(%d(0),"||",2),"COST",0))}, SqlColumnNumber = 2, SqlFieldName = COST_Childsub ];

/// Eff Date From
Property COSTEffDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = COST_EffDateFrom ];

/// Eff Date To
Property COSTEffDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = COST_EffDateTo ];

/// Des Ref to InsCover
Property COSTInsCoverDR As ARCInsurCoverStatus [ SqlColumnNumber = 7, SqlFieldName = COST_InsCover_DR ];

/// Des Ref to InsType
Property COSTInsTypeDR As ARCInsuranceType [ Required, SqlColumnNumber = 6, SqlFieldName = COST_InsType_DR ];

/// ARC_ItmMast Parent Reference
Relationship COSTParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemInsurTypeCost, Required, SqlFieldName = COST_ParRef ];

Index RowIDBasedIDKeyIndex On COSTChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemInsurTypeCost).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemInsurTypeCost","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemInsurTypeCost).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemInsurTypeCost","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemInsurTypeCost).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemInsurTypeCost","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemInsurTypeCost).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemInsurTypeCost","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemInsurTypeCost).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemInsurTypeCost","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="COST_Amt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="COST_EffDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="COST_EffDateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="COST_InsCover_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="COST_InsType_DR">
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
<Field>COST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{COST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsTypeDate">
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
<Expression>{L8}</Expression>
<Field>COST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"COST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"InsTypeDate"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{COST_InsType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{COST_EffDateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{COST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>COST_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemInsurTypeCostS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
