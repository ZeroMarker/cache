/// PAC Bed Department Allocation(1484
Class User.PACBedDepartmentAllocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BedDepartmentAllocation, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property DEPCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = DEP_CTLOC_DR ];

/// Childsub
Property DEPChildsub As %Float [ InitialExpression = {$i(^PAWARD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"BED",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DEP",0))}, SqlColumnNumber = 2, SqlFieldName = DEP_Childsub ];

/// Date From
Property DEPDateFrom As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = DEP_DateFrom ];

/// Date To
Property DEPDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DEP_DateTo ];

/// PAC_Bed Parent Reference
Relationship DEPParRef As PACBed [ Cardinality = parent, Inverse = ChildPACBedDepartmentAllocation, Required, SqlFieldName = DEP_ParRef ];

Index RowIDBasedIDKeyIndex On DEPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 70;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACBedDepartmentAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedDepartmentAllocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACBedDepartmentAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedDepartmentAllocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACBedDepartmentAllocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedDepartmentAllocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACBedDepartmentAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedDepartmentAllocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACBedDepartmentAllocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACBedDepartmentAllocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>70</ExtentSize>
<Property name="DEPCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEPDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEPDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEPParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DEP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAWARD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAC_Bed.BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Bed.BED_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^PAWARD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAC_Bed.BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Bed.BED_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DEP_DateFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DEP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEP_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedDepartmentAllocatioS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
