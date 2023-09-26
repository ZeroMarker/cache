/// Hospital Plan(2460)
Class User.CTHospitalPlan Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_HospitalPlan, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PLANChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Hospital Parent Reference
Relationship PLANParRef As CTHospital [ Cardinality = parent, Inverse = ChildCTHospitalPlan, Required, SqlFieldName = PLAN_ParRef ];

/// Childsub
Property PLANChildsub As %Float [ InitialExpression = {$i(^CT("HOSP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PLAN",0))}, SqlColumnNumber = 2, SqlFieldName = PLAN_Childsub ];

/// Des Ref AuxIns
Property PLANAuxInsDR As ARCAuxilInsurType [ SqlColumnNumber = 3, SqlFieldName = PLAN_AuxIns_DR ];

/// Date From
Property PLANDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = PLAN_DateFrom ];

/// Date To
Property PLANDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = PLAN_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTHospitalPlan).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalPlan","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTHospitalPlan).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalPlan","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTHospitalPlan).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalPlan","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTHospitalPlan).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalPlan","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTHospitalPlan).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalPlan","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTHospitalPlan","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PLANAuxInsDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PLANChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PLANDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PLANDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PLANParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PLAN_AuxIns_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLAN_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLAN_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PLAN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PLAN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLAN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuxInst">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Hospital.HOSP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PLAN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Hospital.HOSP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PLAN"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"AuxIns"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PLAN_AuxIns_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PLAN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PLAN_RowId</SqlRowIdName>
<StreamLocation>^User.CTHospitalPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
