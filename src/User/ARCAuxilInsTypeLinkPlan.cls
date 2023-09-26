/// ARC AuxIns TypeLink(1672)
Class User.ARCAuxilInsTypeLinkPlan Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_AuxilInsTypeLinkPlan, StorageStrategy = SQLStorage ]
{

/// Des Ref AuxInsType
Property LINKAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 3, SqlFieldName = LINK_AuxInsType_DR ];

/// Childsub
Property LINKChildsub As %Float [ InitialExpression = {$i(^ARC("AUXIT",$p(%d(0),$c(1)),"LINK",0))}, SqlColumnNumber = 2, SqlFieldName = LINK_Childsub ];

/// Des Ref InsType
Property LINKInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = LINK_InsType_DR ];

/// ARC_AuxilInsurType Parent Reference
Relationship LINKParRef As ARCAuxilInsurType [ Cardinality = parent, Inverse = ChildARCAuxilInsTypeLinkPlan, Required, SqlFieldName = LINK_ParRef ];

Index RowIDBasedIDKeyIndex On LINKChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsTypeLinkPlan).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeLinkPlan","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsTypeLinkPlan).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeLinkPlan","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCAuxilInsTypeLinkPlan).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeLinkPlan","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCAuxilInsTypeLinkPlan).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeLinkPlan","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCAuxilInsTypeLinkPlan).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCAuxilInsTypeLinkPlan","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="LINKAuxInsTypeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LINKChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LINKInsTypeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="LINKParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="LINK_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LINK_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_AuxilInsurType.AUXIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AUXIT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_AuxilInsurType.AUXIT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LINK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLink">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_AuxilInsurType.AUXIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_AuxilInsurType.AUXIT_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LINK_AuxInsType_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LINK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LINK_RowId</SqlRowIdName>
<StreamLocation>^User.ARCAuxilInsTypeLinkPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
