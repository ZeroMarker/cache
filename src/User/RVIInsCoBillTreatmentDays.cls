/// RVI InsCoBill Treatment Days(1281)
Class User.RVIInsCoBillTreatmentDays Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCoBillTreatmentDays, StorageStrategy = SQLStorage ]
{

/// Childsub
Property TDAYChildsub As %Float [ InitialExpression = {$i(^RVI($p(%d(0),$c(1)),"TDAY",0))}, SqlColumnNumber = 2, SqlFieldName = TDAY_Childsub ];

/// RVI_InsCompanyBill Parent Reference
Relationship TDAYParRef As RVIInsCompanyBill [ Cardinality = parent, Inverse = ChildRVIInsCoBillTreatmentDays, Required, SqlFieldName = TDAY_ParRef ];

/// Treatment Date
Property TDAYTreatmentDate As %Float [ SqlColumnNumber = 3, SqlFieldName = TDAY_TreatmentDate ];

Index RowIDBasedIDKeyIndex On TDAYChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillTreatmentDays).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillTreatmentDays","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillTreatmentDays).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillTreatmentDays","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillTreatmentDays).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillTreatmentDays","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCoBillTreatmentDays).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillTreatmentDays","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCoBillTreatmentDays).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillTreatmentDays","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TDAY_TreatmentDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TDAY_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TDAY"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TDAY_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TDAY_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCoBillTreatmentDaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
