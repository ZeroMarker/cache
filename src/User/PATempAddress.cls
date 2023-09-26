/// PA Temporary address(1814)
Class User.PATempAddress Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_TempAddress, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADDRChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship ADDRParRef As PAPerson [ Cardinality = parent, Inverse = ChildPATempAddress, Required, SqlFieldName = ADDR_ParRef ];

/// Childsub
Property ADDRChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TADDR",0))}, SqlColumnNumber = 2, SqlFieldName = ADDR_Childsub ];

/// Street
Property ADDRStreet As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADDR_Street, SqlListType = SUBNODE ];

/// Phone
Property ADDRPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ADDR_Phone ];

/// Des Ref CityArea
Property ADDRCityAreaDR As CTCityArea [ SqlColumnNumber = 5, SqlFieldName = ADDR_CityArea_DR ];

/// Des Ref City
Property ADDRCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = ADDR_City_DR ];

/// Des REf Province
Property ADDRProvinceDR As CTProvince [ SqlColumnNumber = 7, SqlFieldName = ADDR_Province_DR ];

/// Des Ref Region
Property ADDRRegionDR As CTRegion [ SqlColumnNumber = 8, SqlFieldName = ADDR_Region_DR ];

/// Des REf Zip
Property ADDRZipDR As CTZip [ SqlColumnNumber = 9, SqlFieldName = ADDR_Zip_DR ];

/// Des Ref HCA
Property ADDRHCADR As CTHealthCareArea [ SqlColumnNumber = 10, SqlFieldName = ADDR_HCA_DR ];

/// Date From
Property ADDRDateFrom As %Date [ SqlColumnNumber = 11, SqlFieldName = ADDR_DateFrom ];

/// Date To
Property ADDRDateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = ADDR_DateTo ];

/// Foreign City
Property ADDRForeignCity As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ADDR_ForeignCity ];

/// Foreign Zip
Property ADDRForeignZip As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = ADDR_ForeignZip ];

/// Des Ref AddressType
Property ADDRAddressTypeDR As CTAddrType [ SqlColumnNumber = 15, SqlFieldName = ADDR_AddressType_DR ];

/// Street2
Property ADDRStreet2 As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ADDR_Street2, SqlListType = SUBNODE ];

/// StreetLine1
Property ADDRStreetLine1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlComputeCode = { s {ADDR_StreetLine1}=$s({ADDR_Street}'="":$li({ADDR_Street},1),1:"")
}, SqlComputed, SqlFieldName = ADDR_StreetLine1, Transient ];

/// Comments
Property ADDRComments As list Of %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ADDR_Comments, SqlListType = SUBNODE ];

/// Country
Property ADDRCountryDR As CTCountry [ SqlColumnNumber = 19, SqlFieldName = ADDR_Country_DR ];

/// Des Ref AdmLeave
Property ADDRAdmLeaveDR As PAAdmLeave [ SqlColumnNumber = 20, SqlFieldName = ADDR_AdmLeave_DR ];

/// UpdateDate
Property ADDRUpdateDate As %Date [ SqlColumnNumber = 21, SqlFieldName = ADDR_UpdateDate ];

/// Update Time
Property ADDRUpdateTime As %Time [ SqlColumnNumber = 22, SqlFieldName = ADDR_UpdateTime ];

/// Des Ref UpdateUser
Property ADDRUpdateUserDR As SSUser [ SqlColumnNumber = 23, SqlFieldName = ADDR_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property ADDRUpdateHospitalDR As CTHospital [ SqlColumnNumber = 24, SqlFieldName = ADDR_UpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PATempAddress).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATempAddress","OnAfterDelete")
 d Table^HL7Outbound("PATempAddress ",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PATempAddress).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATempAddress","OnAfterInsert")
 d Table^HL7Outbound("PATempAddress ",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PATempAddress).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATempAddress","OnAfterUpdate")
 d Table^HL7Outbound("PATempAddress ",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PATempAddress).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATempAddress","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PATempAddress).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PATempAddress","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADDR_AddressType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADDR_AdmLeave_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADDR_CityArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADDR_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADDR_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="ADDR_Country_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADDR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADDR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADDR_ForeignCity">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADDR_ForeignZip">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADDR_HCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADDR_Phone">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADDR_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADDR_Region_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADDR_Street">
<Node>"ST"</Node>
</Data>
<Data name="ADDR_Street2">
<Node>"ST2"</Node>
</Data>
<Data name="ADDR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADDR_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADDR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADDR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADDR_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADDR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TADDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADDR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ADDR_RowId</SqlRowIdName>
<StreamLocation>^User.PATempAddressS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
