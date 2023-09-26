/// AdmContractedCare(2449)
Class User.PAAdmContractedCare Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmContractedCare, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CONTCAREChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CONTCARE",0))}, SqlColumnNumber = 2, SqlFieldName = CONTCARE_Childsub ];

/// Des Ref ContRole
Property CONTCAREContRoleDR As PACContractRole [ SqlColumnNumber = 3, SqlFieldName = CONTCARE_ContRole_DR ];

/// Des Ref ContType
Property CONTCAREContTypeDR As PACContractType [ SqlColumnNumber = 4, SqlFieldName = CONTCARE_ContType_DR ];

/// Date From
Property CONTCAREDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CONTCARE_DateFrom ];

/// Date To
Property CONTCAREDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CONTCARE_DateTo ];

/// PA_Adm Parent Reference
Relationship CONTCAREParRef As PAAdm [ Cardinality = parent, Inverse = ChildPAAdmContractedCare, Required, SqlFieldName = CONTCARE_ParRef ];

/// Time From
Property CONTCARETimeFrom As %Time [ SqlColumnNumber = 6, SqlFieldName = CONTCARE_TimeFrom ];

/// Time To
Property CONTCARETimeTo As %Time [ SqlColumnNumber = 8, SqlFieldName = CONTCARE_TimeTo ];

/// Update Date
Property CONTCAREUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CONTCARE_UpdateDate ];

/// Update Time
Property CONTCAREUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CONTCARE_UpdateTime ];

/// Des Ref UpdateUser
Property CONTCAREUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = CONTCARE_UpdateUser_DR ];

/// Des Ref UpdateUserHospital
Property CONTCAREUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = CONTCARE_UpdateUserHospital_DR ];

Index RowIDBasedIDKeyIndex On CONTCAREChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="CONTCAREChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREContRoleDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREContTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCARETimeFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCARETimeTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCAREUpdateUserHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="CONTCARE_ContRole_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONTCARE_ContType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONTCARE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONTCARE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONTCARE_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONTCARE_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CONTCARE_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONTCARE_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONTCARE_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONTCARE_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CONTCARE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONTCARE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CONTCARE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONTCARE_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmContractedCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
