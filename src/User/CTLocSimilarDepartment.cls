/// CT Location Similar Dept(1481)
Class User.CTLocSimilarDepartment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_Loc_SimilarDepartment, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property DEPCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = DEP_CTLOC_DR ];

/// Childsub
Property DEPChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DEP",0))}, SqlColumnNumber = 2, SqlFieldName = DEP_Childsub ];

/// CT_Loc Parent Reference
Relationship DEPParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocSimilarDepartment, Required, SqlFieldName = DEP_ParRef ];

Index RowIDBasedIDKeyIndex On DEPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocSimilarDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocSimilarDepartment","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocSimilarDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocSimilarDepartment","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocSimilarDepartment).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocSimilarDepartment","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocSimilarDepartment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocSimilarDepartment","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocSimilarDepartment).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTLocSimilarDepartment","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="DEPCTLOCDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="DEPChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEPParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DEP_CTLOC_DR">
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
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDep">
<Global>^CTLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DEP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEP_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocSimilarDepartmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
