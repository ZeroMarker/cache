/// SLA Details Allocated(2145)
Class User.PASLADetailsAllocated Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SLADetailsAllocated, StorageStrategy = SQLStorage ]
{

Relationship ChildPASLADetailsAllocatedMulti As PASLADetailsAllocatedMulti [ Cardinality = children, Inverse = MULTParRef ];

/// Des Ref APPT
Property SLADAPPTDR As RBAppointment [ SqlColumnNumber = 4, SqlFieldName = SLAD_APPT_DR ];

/// Des Ref AdmCoding
Property SLADAdmCodingDR As PAAdmCoding [ SqlColumnNumber = 3, SqlFieldName = SLAD_AdmCoding_DR ];

/// Adm Date
Property SLADAdmDate As %Date [ SqlColumnNumber = 13, SqlFieldName = SLAD_AdmDate ];

/// Des Ref AdmWardAttend
Property SLADAdmWardAttendDR As PAAdmWardAttend [ SqlColumnNumber = 32, SqlFieldName = SLAD_AdmWardAttend_DR ];

/// Des Ref InsType
Property SLADAdminCatDR As ARCInsuranceType [ SqlColumnNumber = 17, SqlFieldName = SLAD_AdminCat_DR ];

/// Allocated
Property SLADAllocated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = SLAD_Allocated ];

/// Des Ref CTCP
Property SLADCTCPDR As CTCareProv [ SqlColumnNumber = 28, SqlFieldName = SLAD_CTCP_DR ];

/// Comment
Property SLADComment As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = SLAD_Comment ];

/// Des Ref HCA
Property SLADCommissionerDR As CTHealthCareArea [ SqlColumnNumber = 29, SqlFieldName = SLAD_Commissioner_DR ];

/// Date Allocated
Property SLADDateAlloc As %Date [ SqlColumnNumber = 8, SqlFieldName = SLAD_DateAlloc ];

/// EffectiveDate
Property SLADEffectiveDate As %Date [ SqlColumnNumber = 31, SqlFieldName = SLAD_EffectiveDate ];

/// Des Ref EpisSubtype
Property SLADEpisSubtypeDR As PACEpisodeSubType [ SqlColumnNumber = 33, SqlFieldName = SLAD_EpisSubtype_DR ];

/// Episode Address
Property SLADEpisodeAddress As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = SLAD_EpisodeAddress ];

/// Episode Age
Property SLADEpisodeAge As %Float [ SqlColumnNumber = 25, SqlFieldName = SLAD_EpisodeAge ];

/// Episode GP
Property SLADEpisodeGP As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = SLAD_EpisodeGP ];

/// EpisodeType
Property SLADEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = SLAD_EpisodeType ];

/// Des Ref RefDoc
Property SLADGPDR As PACRefDoctor [ SqlColumnNumber = 18, SqlFieldName = SLAD_GP_DR ];

/// Des Ref HCR
Property SLADHARDR As CTHealthCareRegion [ SqlColumnNumber = 20, SqlFieldName = SLAD_HAR_DR ];

/// Des Ref HRG
Property SLADHRGDR As PACHRGCodes [ SqlColumnNumber = 21, SqlFieldName = SLAD_HRG_DR ];

/// Manual Entry
Property SLADManualEntry As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SLAD_ManualEntry ];

/// Des Ref PAADM
Property SLADPAADMDR As PAAdm [ SqlColumnNumber = 6, SqlFieldName = SLAD_PAADM_DR ];

/// Des Ref Person
Property SLADPersonDR As PAPerson [ SqlColumnNumber = 2, SqlFieldName = SLAD_Person_DR ];

/// Des Ref Procedure
Property SLADProcedureDR As ORCOperation [ SqlColumnNumber = 19, SqlFieldName = SLAD_Procedure_DR ];

/// Reallocate Flag
Property SLADReallocateFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = SLAD_ReallocateFlag ];

/// Des Ref ServAgreem
Property SLADServAgreemDR As PACServiceAgreement [ SqlColumnNumber = 7, SqlFieldName = SLAD_ServAgreem_DR ];

/// Des Ref ServiceGroup
Property SLADServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 15, SqlFieldName = SLAD_ServiceGroup_DR ];

/// Des Ref CTLOC
Property SLADSpecialtyDR As CTLoc [ SqlColumnNumber = 16, SqlFieldName = SLAD_Specialty_DR ];

/// Time Alloc
Property SLADTimeAlloc As %Time [ SqlColumnNumber = 9, SqlFieldName = SLAD_TimeAlloc ];

/// Des Ref Trust
Property SLADTrustDR As PACTrust [ SqlColumnNumber = 30, SqlFieldName = SLAD_Trust_DR ];

/// Des Ref User
Property SLADUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = SLAD_User_DR ];

/// Valid Flag
Property SLADValidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = SLAD_ValidFlag ];

/// Des Ref WaitList
Property SLADWaitListDR As PAWaitingList [ SqlColumnNumber = 5, SqlFieldName = SLAD_WaitList_DR ];

Parameter EXTENTSIZE = 593;

Storage SQLStorage
{
<ExtentSize>593</ExtentSize>
<Property name="SLADAPPTDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADAdmCodingDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADAdmDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADAdmWardAttendDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADAdminCatDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADAllocated">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLADCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADComment">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADCommissionerDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADDateAlloc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADEffectiveDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADEpisSubtypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADEpisodeAddress">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADEpisodeAge">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADEpisodeGP">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADEpisodeType">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADGPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADHARDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADHRGDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADManualEntry">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLADPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADPersonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADProcedureDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADReallocateFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLADServAgreemDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADServiceGroupDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADSpecialtyDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADTimeAlloc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADTrustDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADValidFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLADWaitListDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PASLA("DETALL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SLAD_APPT_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SLAD_AdmCoding_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SLAD_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SLAD_AdmWardAttend_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SLAD_AdminCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SLAD_Allocated">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SLAD_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SLAD_Comment">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SLAD_Commissioner_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SLAD_DateAlloc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SLAD_EffectiveDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SLAD_EpisSubtype_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SLAD_EpisodeAddress">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SLAD_EpisodeAge">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SLAD_EpisodeGP">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SLAD_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SLAD_GP_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SLAD_HAR_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SLAD_HRG_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SLAD_ManualEntry">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SLAD_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SLAD_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLAD_Procedure_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SLAD_ReallocateFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SLAD_ServAgreem_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SLAD_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SLAD_Specialty_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SLAD_TimeAlloc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SLAD_Trust_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SLAD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SLAD_ValidFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SLAD_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PASLA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SLAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DETALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SLAD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^PASLAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SLAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DETALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SLAD_Person_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPersonAdmDate">
<Global>^PASLAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SLAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DETALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PersonDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SLAD_Person_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLAD_AdmDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SLAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServAgreem">
<Global>^PASLAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SLAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DETALL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ServAgr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SLAD_ServAgreem_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLAD_AdmDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SLAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SLAD_RowId</SqlRowIdName>
<StreamLocation>^User.PASLADetailsAllocatedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
