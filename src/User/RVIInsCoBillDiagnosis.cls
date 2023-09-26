/// RVI InsCoBill Diagnosis(1282)
Class User.RVIInsCoBillDiagnosis Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCoBillDiagnosis, StorageStrategy = SQLStorage ]
{

/// Childsub
Property DIAChildsub As %Float [ InitialExpression = {$i(^RVI($p(%d(0),$c(1)),"DIA",0))}, SqlColumnNumber = 2, SqlFieldName = DIA_Childsub ];

/// Des Ref to NFMI Dep
Property DIADepartDR As CTNFMICategDepart [ SqlColumnNumber = 3, SqlFieldName = DIA_Depart_DR ];

/// Discharge Code
Property DIADischargeCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DIA_DischargeCode ];

/// Insurance Description
Property DIAInsurDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DIA_InsurDesc ];

/// Des Ref MRCICDx
Property DIAMRCICDxDR As MRCICDDx [ SqlColumnNumber = 4, SqlFieldName = DIA_MRCICDx_DR ];

/// No of Days IP and PostDischarged Med
Property DIANoDaysIPPostDischMed As %Float [ SqlColumnNumber = 5, SqlFieldName = DIA_NoDaysIPPostDischMed ];

/// Operation Performed
Property DIAOperPerformed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DIA_OperPerformed ];

/// RVI_InsCompanyBill Parent Reference
Relationship DIAParRef As RVIInsCompanyBill [ Cardinality = parent, Inverse = ChildRVIInsCoBillDiagnosis, Required, SqlFieldName = DIA_ParRef ];

/// Print
Property DIAPrint As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DIA_Print ];

/// Reason for Injury
Property DIAReasonInjury As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DIA_ReasonInjury ];

/// Special Code
Property DIASpecialCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DIA_SpecialCode ];

Index RowIDBasedIDKeyIndex On DIAChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillDiagnosis).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillDiagnosis","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillDiagnosis).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillDiagnosis","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillDiagnosis).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillDiagnosis","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCoBillDiagnosis).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillDiagnosis","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCoBillDiagnosis).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillDiagnosis","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DIA_Depart_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIA_DischargeCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIA_InsurDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIA_MRCICDx_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIA_NoDaysIPPostDischMed">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIA_OperPerformed">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIA_Print">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DIA_ReasonInjury">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIA_SpecialCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DIA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DIA_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCoBillDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
