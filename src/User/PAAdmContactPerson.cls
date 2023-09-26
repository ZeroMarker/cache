/// PA Adm Contact Person(1881)
Class User.PAAdmContactPerson Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PA_AdmContactPerson, StorageStrategy = SQLStorage ]
{

/// Des Ref CTRLT
Property CONTCTRLTDR As CTRelation [ SqlColumnNumber = 11, SqlFieldName = CONT_CTRLT_DR ];

/// Carer Contribution
Property CONTCarerContribution As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CONT_CarerContribution ];

/// Childsub
Property CONTChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CONT",0))}, SqlColumnNumber = 2, SqlFieldName = CONT_Childsub ];

/// Consent To Share Info
Property CONTConsentToShareInfo As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CONT_ConsentToShareInfo ];

/// Des Ref ContType
Property CONTContTypeDR As PACContactType [ SqlColumnNumber = 3, SqlFieldName = CONT_ContType_DR ];

/// Date From
Property CONTDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CONT_DateFrom ];

/// Date To
Property CONTDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CONT_DateTo ];

/// Letter Comment
Property CONTLetterComment As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CONT_LetterComment ];

/// Non Consent Reason
Property CONTNonConsentReason As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CONT_NonConsentReason ];

/// Des Ref NonGovOrg
Property CONTNonGovOrgDR As PACNonGovOrg [ SqlColumnNumber = 8, SqlFieldName = CONT_NonGovOrg_DR ];

/// PA_Adm Parent Reference
Relationship CONTParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmContactPerson, Required, SqlFieldName = CONT_ParRef ];

/// Des Ref Person
Property CONTPersonDR As PAPerson [ SqlColumnNumber = 4, SqlFieldName = CONT_Person_DR ];

/// UpdateDate
Property CONTUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CONT_UpdateDate ];

/// UpdateTime
Property CONTUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = CONT_UpdateTime ];

/// Des Ref UpdateUser
Property CONTUpdateUserDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = CONT_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property CONTUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 15, SqlFieldName = CONT_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On CONTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="CONTCTRLTDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCarerContribution">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTConsentToShareInfo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CONTContTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTLetterComment">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTNonConsentReason">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTNonGovOrgDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTPersonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTUpdateUserHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CONT_CTRLT_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONT_CarerContribution">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONT_ConsentToShareInfo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONT_ContType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONT_LetterComment">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CONT_NonConsentReason">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONT_NonGovOrg_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONT_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CONT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CONT_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CONT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CONT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CONT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONT_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmContactPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
