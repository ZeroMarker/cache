/// Drg Form Forms(2641)
Class User.PHCDrgFormForms Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_DrgFormForms, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FRMChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_DrgForm Parent Reference
Relationship FRMParRef As PHCDrgForm [ Cardinality = parent, Inverse = ChildPHCDrgFormForms, Required, SqlFieldName = FRM_ParRef ];

/// Childsub
Property FRMChildsub As %Float [ InitialExpression = {$i(^PHCD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DF",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"FRM",0))}, SqlColumnNumber = 2, SqlFieldName = FRM_Childsub ];

/// Des Ref DrgForm
Property FRMDrgFormDR As PHCDrgForm [ SqlColumnNumber = 3, SqlFieldName = FRM_DrgForm_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDrgFormForms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgFormForms","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDrgFormForms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgFormForms","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDrgFormForms).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgFormForms","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDrgFormForms).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgFormForms","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDrgFormForms).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgFormForms","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="FRM_DrgForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHC_DrgForm.PHCDF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>FRM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgForm.PHCDF_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"FRM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{FRM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexForm">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHC_DrgForm.PHCDF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>FRM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgForm.PHCDF_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"FRM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Form"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{FRM_DrgForm_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{FRM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>FRM_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrgFormFormsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
