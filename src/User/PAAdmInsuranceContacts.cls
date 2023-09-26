/// PA Adm Insurance Contacts(1908)
Class User.PAAdmInsuranceContacts Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmInsuranceContacts, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONTACTChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_AdmInsurance Parent Reference
Relationship CONTACTParRef As PAAdmInsurance [ Cardinality = parent, Inverse = ChildPAAdmInsuranceContacts, Required, SqlFieldName = CONTACT_ParRef ];

/// Childsub
Property CONTACTChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"INS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"CONTACT",0))}, SqlColumnNumber = 2, SqlFieldName = CONTACT_Childsub ];

/// Des Ref ContType
Property CONTACTContTypeDR As ARCPayorContactType [ SqlColumnNumber = 3, SqlFieldName = CONTACT_ContType_DR ];

/// Name
Property CONTACTName As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CONTACT_Name ];

/// Address1
Property CONTACTAddress1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CONTACT_Address1 ];

/// Address2
Property CONTACTAddress2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CONTACT_Address2 ];

/// Des Ref City
Property CONTACTCityDR As CTCity [ SqlColumnNumber = 7, SqlFieldName = CONTACT_City_DR ];

/// Des Ref Zip
Property CONTACTZipDR As CTZip [ SqlColumnNumber = 8, SqlFieldName = CONTACT_Zip_DR ];

/// Phone
Property CONTACTPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CONTACT_Phone ];

/// UpdateDate
Property CONTACTUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CONTACT_UpdateDate ];

/// UpdateTime
Property CONTACTUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CONTACT_UpdateTime ];

/// Des Ref UpdateUserHospital
Property CONTACTUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = CONTACT_UpdateUserHospital_DR ];

/// Des Ref UpdateUser
Property CONTACTUpdateUserDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = CONTACT_UpdateUser_DR ];

/// PayingShare
Property CONTACTPayingShare As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CONTACT_PayingShare ];

/// Des Ref Province
Property CONTACTProvinceDR As CTProvince [ SqlColumnNumber = 15, SqlFieldName = CONTACT_Province_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmInsuranceContacts).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceContacts","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmInsuranceContacts).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceContacts","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmInsuranceContacts).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceContacts","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmInsuranceContacts).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceContacts","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmInsuranceContacts).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAdmInsuranceContacts","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CONTACT_Address1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONTACT_Address2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONTACT_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONTACT_ContType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONTACT_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONTACT_PayingShare">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CONTACT_Phone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONTACT_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CONTACT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONTACT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONTACT_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CONTACT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CONTACT_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmInsurance.INS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>CONTACT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmInsurance.INS_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CONTACT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CONTACT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONTACT_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmInsuranceContactsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
