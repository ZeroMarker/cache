/// PA Traffic Accident Contact(1924)
Class User.PATrafficAccidentContact Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TrafficAccidentContact, StorageStrategy = SQLStorage ]
{

/// Address1
Property CONTAddress1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CONT_Address1 ];

/// Address2
Property CONTAddress2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CONT_Address2 ];

/// Childsub
Property CONTChildsub As %Float [ InitialExpression = {$i(^PATRF($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CONT",0))}, SqlColumnNumber = 2, SqlFieldName = CONT_Childsub ];

/// Des Ref City
Property CONTCityDR As CTCity [ SqlColumnNumber = 7, SqlFieldName = CONT_City_DR ];

/// Des Ref ContType
Property CONTContTypeDR As ARCPayorContactType [ SqlColumnNumber = 3, SqlFieldName = CONT_ContType_DR ];

/// Date From
Property CONTDateFrom As %Date [ SqlColumnNumber = 10, SqlFieldName = CONT_DateFrom ];

/// Date To
Property CONTDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = CONT_DateTo ];

/// LastUpdateDate
Property CONTLastUpdateDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CONT_LastUpdateDate ];

/// Des Ref LastUpdateHospital
Property CONTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 15, SqlFieldName = CONT_LastUpdateHospital_DR ];

/// LastUpdateTime
Property CONTLastUpdateTime As %Time [ SqlColumnNumber = 14, SqlFieldName = CONT_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property CONTLastUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = CONT_LastUpdateUser_DR ];

/// Name
Property CONTName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CONT_Name ];

/// PA_TrafficAccident Parent Reference
Relationship CONTParRef As PATrafficAccident [ Cardinality = parent, Inverse = ChildPATrafficAccidentContact, Required, SqlFieldName = CONT_ParRef ];

/// Phone
Property CONTPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CONT_Phone ];

/// Des Ref Zip
Property CONTZipDR As CTZip [ SqlColumnNumber = 8, SqlFieldName = CONT_Zip_DR ];

Index RowIDBasedIDKeyIndex On CONTChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 279;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PATrafficAccidentContact).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccidentContact","OnAfterDelete")

 d Table^HL7Outbound("PATrafficAccidentContact",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PATrafficAccidentContact).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccidentContact","OnAfterInsert")

 d Table^HL7Outbound("PATrafficAccidentContact",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PATrafficAccidentContact).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccidentContact","OnAfterUpdate")

 d Table^HL7Outbound("PATrafficAccidentContact",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PATrafficAccidentContact).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccidentContact","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PATrafficAccidentContact).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATrafficAccidentContact","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>279</ExtentSize>
<Property name="CONTAddress1">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTAddress2">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTCityDR">
<Selectivity>1</Selectivity>
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
<Property name="CONTLastUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTLastUpdateHospitalDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTLastUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTLastUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTName">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTPhone">
<Selectivity>1</Selectivity>
</Property>
<Property name="CONTZipDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CONT_Address1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONT_Address2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONT_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONT_ContType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CONT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CONT_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CONT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CONT_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CONT_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONT_Phone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONT_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PATRF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_TrafficAccident.TRF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CONT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_TrafficAccident.TRF_RowId}</Expression>
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
<StreamLocation>^User.PATrafficAccidentContactS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
