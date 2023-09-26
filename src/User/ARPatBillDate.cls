/// Korean AR Patient Bill Date(1438)
Class User.ARPatBillDate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillDate, StorageStrategy = SQLStorage ]
{

Relationship ChildARPatBillDateBillGrp As ARPatBillDateBillGrp [ Cardinality = children, Inverse = BGRPParRef ];

/// Date
Property DATEDate As %Date [ SqlColumnNumber = 2, SqlFieldName = DATE_Date ];

/// Insurance Uplift
Property DATEInsuranceUplift As %Float [ SqlColumnNumber = 17, SqlFieldName = DATE_InsuranceUplift ];

/// AR_PatientBill Parent Reference
Relationship DATEParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillDate, Required, SqlFieldName = DATE_ParRef ];

/// Patient Uplift
Property DATEPatientUplift As %Float [ SqlColumnNumber = 18, SqlFieldName = DATE_PatientUplift ];

/// Total Allowed
Property DATETotalAllowed As %Float [ SqlColumnNumber = 3, SqlFieldName = DATE_TotalAllowed ];

/// Total Disallowed
Property DATETotalDisallowed As %Float [ SqlColumnNumber = 4, SqlFieldName = DATE_TotalDisallowed ];

/// Total Ins Co
Property DATETotalInsCo As %Float [ SqlColumnNumber = 5, SqlFieldName = DATE_TotalInsCo ];

/// Total Material AD
Property DATETotalMaterialAD As %Float [ SqlColumnNumber = 13, SqlFieldName = DATE_TotalMaterialAD ];

/// Total Material Allowed
Property DATETotalMaterialAllowed As %Float [ SqlColumnNumber = 6, SqlFieldName = DATE_TotalMaterialAllowed ];

/// Total Material Disallowed
Property DATETotalMaterialDisallow As %Float [ SqlColumnNumber = 7, SqlFieldName = DATE_TotalMaterialDisallow ];

/// Total Material Unauthorised
Property DATETotalMaterialUnauthor As %Float [ SqlColumnNumber = 14, SqlFieldName = DATE_TotalMaterialUnauthor ];

/// Total Pat Service Allowed
Property DATETotalPatServiceAllowed As %Float [ SqlColumnNumber = 12, SqlFieldName = DATE_TotalPatServiceAllowed ];

/// Total Patient
Property DATETotalPatient As %Float [ SqlColumnNumber = 8, SqlFieldName = DATE_TotalPatient ];

/// Total Patient Of Allowed
Property DATETotalPatientOfAllowed As %Float [ SqlColumnNumber = 9, SqlFieldName = DATE_TotalPatientOfAllowed ];

/// Total Service AD
Property DATETotalServiceAD As %Float [ SqlColumnNumber = 15, SqlFieldName = DATE_TotalServiceAD ];

/// Total Service Allowed
Property DATETotalServiceAllowed As %Float [ SqlColumnNumber = 11, SqlFieldName = DATE_TotalServiceAllowed ];

/// Total Service Unauthorised
Property DATETotalServiceUnauthor As %Float [ SqlColumnNumber = 16, SqlFieldName = DATE_TotalServiceUnauthor ];

/// Total Specialist
Property DATETotalSpecialist As %Float [ SqlColumnNumber = 10, SqlFieldName = DATE_TotalSpecialist ];

Index RowIDBasedIDKeyIndex On DATEDate [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillDate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDate","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillDate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillDate).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillDate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDate","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillDate).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARPatBillDate","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DATE_InsuranceUplift">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DATE_PatientUplift">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DATE_TotalAllowed">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DATE_TotalDisallowed">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DATE_TotalInsCo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DATE_TotalMaterialAD">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DATE_TotalMaterialAllowed">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DATE_TotalMaterialDisallow">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DATE_TotalMaterialUnauthor">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DATE_TotalPatServiceAllowed">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DATE_TotalPatient">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DATE_TotalPatientOfAllowed">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DATE_TotalServiceAD">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DATE_TotalServiceAllowed">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DATE_TotalServiceUnauthor">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DATE_TotalSpecialist">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DATE_Date</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DATE_Date}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DATE_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillDateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
