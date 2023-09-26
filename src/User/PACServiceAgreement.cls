/// PAC ServiceAgreement(2133)
Class User.PACServiceAgreement Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreement, StorageStrategy = SQLStorage ]
{

Relationship ChildPACServiceAgreementAdminCa As PACServiceAgreementAdminCateg [ Cardinality = children, Inverse = INSParRef ];

Relationship ChildPACServiceAgreementEpisode As PACServiceAgreementEpisodeType [ Cardinality = children, Inverse = EPParRef ];

Relationship ChildPACServiceAgreementGP As PACServiceAgreementGP [ Cardinality = children, Inverse = GPParRef ];

Relationship ChildPACServiceAgreementGPPract As PACServiceAgreementGPPractices [ Cardinality = children, Inverse = GPPParRef ];

Relationship ChildPACServiceAgreementHAR As PACServiceAgreementHAR [ Cardinality = children, Inverse = HARParRef ];

Relationship ChildPACServiceAgreementHRG As PACServiceAgreementHRG [ Cardinality = children, Inverse = HRGParRef ];

Relationship ChildPACServiceAgreementProcedu As PACServiceAgreementProcedure [ Cardinality = children, Inverse = PROCParRef ];

Relationship ChildPACServiceAgreementSpecial As PACServiceAgreementSpecialty [ Cardinality = children, Inverse = SPECParRef ];

Relationship ChildPACServiceAgreementTarget As PACServiceAgreementTarget [ Cardinality = children, Inverse = TARParRef ];

/// All Admin Categories
Property SLAAllAdminCategories As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SLA_AllAdminCategories ];

/// All Episode Types
Property SLAAllEpisodeTypes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SLA_AllEpisodeTypes ];

/// All GP Practices
Property SLAAllGPPractices As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = SLA_AllGPPractices ];

/// All GPs
Property SLAAllGPs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SLA_AllGPs ];

/// All HARs
Property SLAAllHARs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = SLA_AllHARs ];

/// All HRGs
Property SLAAllHRGs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = SLA_AllHRGs ];

/// All Procedures
Property SLAAllProcedures As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = SLA_AllProcedures ];

/// All Specialities
Property SLAAllSpecialities As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = SLA_AllSpecialities ];

/// Auto Allocation
Property SLAAutoAllocation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SLA_AutoAllocation ];

/// Des Ref HCA
Property SLACommissionerDR As CTHealthCareArea [ SqlColumnNumber = 2, SqlFieldName = SLA_Commissioner_DR ];

/// Des Ref ContractGroup
Property SLAContractGroupDR As PACContractGroup [ SqlColumnNumber = 18, SqlFieldName = SLA_ContractGroup_DR ];

/// Date From
Property SLADateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = SLA_DateFrom ];

/// Date To
Property SLADateTo As %Date [ SqlColumnNumber = 10, SqlFieldName = SLA_DateTo ];

/// Description
Property SLADesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SLA_Desc ];

/// Interim Payment
Property SLAInterimPayment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SLA_InterimPayment ];

/// Reallocation
Property SLAReallocation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SLA_Reallocation ];

/// Serial Number
Property SLASerialNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SLA_SerialNumber ];

/// Des Ref Trust
Property SLATrustDR As PACTrust [ SqlColumnNumber = 3, SqlFieldName = SLA_Trust_DR ];

Parameter EXTENTSIZE = 18;

Storage SQLStorage
{
<ExtentSize>18</ExtentSize>
<Property name="SLAAllAdminCategories">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllEpisodeTypes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllGPPractices">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllGPs">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllHARs">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllHRGs">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllProcedures">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAllSpecialities">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAAutoAllocation">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLACommissionerDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLAContractGroupDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLADesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLAInterimPayment">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLAReallocation">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SLASerialNumber">
<Selectivity>1</Selectivity>
</Property>
<Property name="SLATrustDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("SLA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SLA_AllAdminCategories">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SLA_AllEpisodeTypes">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SLA_AllGPPractices">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SLA_AllGPs">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SLA_AllHARs">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SLA_AllHRGs">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SLA_AllProcedures">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SLA_AllSpecialities">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SLA_AutoAllocation">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SLA_Commissioner_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SLA_ContractGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SLA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SLA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SLA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SLA_InterimPayment">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SLA_Reallocation">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SLA_SerialNumber">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SLA_Trust_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SLA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SLA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SLA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SLA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSerial">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SLA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Ser"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SLA_SerialNumber})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTrust">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SLA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Trust"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SLA_Trust_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SLA_Commissioner_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SLA_SerialNumber}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SLA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SLA_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
