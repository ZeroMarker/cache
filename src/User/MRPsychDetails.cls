/// Psych Details(2208)
Class User.MRPsychDetails Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PsychDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PSYCHChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRPsychTreatmentForm As MRPsychTreatmentForm [ Cardinality = children, Inverse = TFParRef ];

Relationship ChildMRPsychMentalCategory As MRPsychMentalCategory [ Cardinality = children, Inverse = MCParRef ];

Relationship ChildMRPsychTribunal As MRPsychTribunal [ Cardinality = children, Inverse = TRIBParRef ];

/// MR_Adm Parent Reference
Relationship PSYCHParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRPsychDetails, Required, SqlFieldName = PSYCH_ParRef ];

/// Childsub
Property PSYCHChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PSYCH",0))}, SqlColumnNumber = 2, SqlFieldName = PSYCH_Childsub ];

/// Des Ref LegalStat
Property PSYCHLegalStatDR As PACLegalStatusClassif [ SqlColumnNumber = 3, SqlFieldName = PSYCH_LegalStat_DR ];

/// Des Ref MentalCateg
Property PSYCHMentalCategDR As PACMentalCategory [ SqlColumnNumber = 4, SqlFieldName = PSYCH_MentalCateg_DR ];

/// Date From
Property PSYCHDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = PSYCH_DateFrom ];

/// Date To
Property PSYCHDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = PSYCH_DateTo ];

/// Status
Property PSYCHStatus As %String(DISPLAYLIST = ",No known previous episodes,previous episodes, this provider,previous episodes, other providers", MAXLEN = 34, TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 7, SqlFieldName = PSYCH_Status ];

/// Des Ref UsualAccom
Property PSYCHUsualAccomDR As PACUsualAccomodation [ SqlColumnNumber = 8, SqlFieldName = PSYCH_UsualAccom_DR ];

/// Des Ref PensionStatus
Property PSYCHPensionStatusDR As PACPensionStatus [ SqlColumnNumber = 9, SqlFieldName = PSYCH_PensionStatus_DR ];

/// Des Ref RefFurtherCare
Property PSYCHRefFurtherCareDR As PACReferralFurtherCare [ SqlColumnNumber = 10, SqlFieldName = PSYCH_RefFurtherCare_DR ];

/// First Admit
Property PSYCHFirstAdmit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PSYCH_FirstAdmit ];

/// Prev Non Admit
Property PSYCHPrevNonAdmit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PSYCH_PrevNonAdmit ];

/// Des Ref EmploymentStatus
Property PSYCHEmploymentStatusDR As PACEmploymentStatus [ SqlColumnNumber = 13, SqlFieldName = PSYCH_EmploymentStatus_DR ];

/// UpdateDate
Property PSYCHUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PSYCH_UpdateDate ];

/// UpdateTime
Property PSYCHUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PSYCH_UpdateTime ];

/// Des Ref UpdateUserHospital
Property PSYCHUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = PSYCH_UpdateUserHospital_DR ];

/// Des Ref UpdateUser
Property PSYCHUpdateUserDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = PSYCH_UpdateUser_DR ];

/// SectionTimeFrom
Property PSYCHSectionTimeFrom As %Time [ SqlColumnNumber = 18, SqlFieldName = PSYCH_SectionTimeFrom ];

/// SectionTimeTo
Property PSYCHSectionTimeTo As %Time [ SqlColumnNumber = 19, SqlFieldName = PSYCH_SectionTimeTo ];

/// SectionDateFrom
Property PSYCHSectionDateFrom As %Date [ SqlColumnNumber = 20, SqlFieldName = PSYCH_SectionDateFrom ];

/// SectionDateTo
Property PSYCHSectionDateTo As %Date [ SqlColumnNumber = 21, SqlFieldName = PSYCH_SectionDateTo ];

/// ConsentDate
Property PSYCHConsentDate As %Date [ SqlColumnNumber = 22, SqlFieldName = PSYCH_ConsentDate ];

/// ConsentTime
Property PSYCHConsentTime As %Time [ SqlColumnNumber = 23, SqlFieldName = PSYCH_ConsentTime ];

/// ConsentDateTo
Property PSYCHConsentDateTo As %Date [ SqlColumnNumber = 24, SqlFieldName = PSYCH_ConsentDateTo ];

/// OnLeave
Property PSYCHOnLeave As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = PSYCH_OnLeave ];

/// Des Ref TreatmentForm
Property PSYCHTreatmentFormDR As PACTreatmentForm [ SqlColumnNumber = 26, SqlFieldName = PSYCH_TreatmentForm_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPsychDetails).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychDetails","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPsychDetails).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychDetails","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPsychDetails).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychDetails","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPsychDetails).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychDetails","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPsychDetails).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychDetails","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PSYCH_ConsentDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PSYCH_ConsentDateTo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PSYCH_ConsentTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PSYCH_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PSYCH_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PSYCH_EmploymentStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PSYCH_FirstAdmit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PSYCH_LegalStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PSYCH_MentalCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PSYCH_OnLeave">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PSYCH_PensionStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PSYCH_PrevNonAdmit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PSYCH_RefFurtherCare_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PSYCH_SectionDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PSYCH_SectionDateTo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PSYCH_SectionTimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PSYCH_SectionTimeTo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PSYCH_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PSYCH_TreatmentForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PSYCH_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PSYCH_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PSYCH_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PSYCH_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PSYCH_UsualAccom_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PSYCH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PSYCH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PSYCH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PSYCH_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PSYCH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLegalSta">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PSYCH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateLST"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PSYCH_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PSYCH_LegalStat_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PSYCH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateMentCateg">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PSYCH_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateMC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PSYCH_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PSYCH_MentalCateg_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PSYCH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PSYCH_RowId</SqlRowIdName>
<StreamLocation>^User.MRPsychDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
