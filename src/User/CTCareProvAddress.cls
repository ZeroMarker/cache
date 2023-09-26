/// CareProvAddress(2201)
Class User.CTCareProvAddress Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CareProvAddress, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADDRChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_CareProv Parent Reference
Relationship ADDRParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvAddress, Required, SqlFieldName = ADDR_ParRef ];

/// Childsub
Property ADDRChildsub As %Float [ InitialExpression = {$i(^CTPCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ADDR",0))}, SqlColumnNumber = 2, SqlFieldName = ADDR_Childsub ];

/// Type
Property ADDRType As %String(DISPLAYLIST = ",Home,Internal,Room,Private", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",H,I,R,P") [ SqlColumnNumber = 3, SqlFieldName = ADDR_Type ];

/// Address1
Property ADDRAddress1 As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ADDR_Address1 ];

/// Address2
Property ADDRAddress2 As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ADDR_Address2 ];

/// Des Ref Suburb
Property ADDRSuburbDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = ADDR_Suburb_DR ];

/// Des Ref State
Property ADDRStateDR As CTProvince [ SqlColumnNumber = 7, SqlFieldName = ADDR_State_DR ];

/// Des Ref Postcode
Property ADDRPostcodeDR As CTZip [ SqlColumnNumber = 8, SqlFieldName = ADDR_Postcode_DR ];

/// Phone
Property ADDRPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ADDR_Phone ];

/// Fax
Property ADDRFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ADDR_Fax ];

/// Mobile
Property ADDRMobile As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = ADDR_Mobile ];

/// Email
Property ADDREmail As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ADDR_Email ];

/// Pager
Property ADDRPager As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ADDR_Pager ];

/// PrefMethod
Property ADDRPrefMethod As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ADDR_PrefMethod ];

/// Des Ref Hospital
Property ADDRHospitalDR As CTHospital [ SqlColumnNumber = 15, SqlFieldName = ADDR_Hospital_DR ];

/// DateFrom
Property ADDRDateFrom As %Date [ SqlColumnNumber = 16, SqlFieldName = ADDR_DateFrom ];

/// DateTo
Property ADDRDateTo As %Date [ SqlColumnNumber = 17, SqlFieldName = ADDR_DateTo ];

/// ProvNumber
Property ADDRProvNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ADDR_ProvNumber ];

/// PrefConMethod
Property ADDRPrefConMethod As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ADDR_PrefConMethod ];

/// ContactFirstOn
Property ADDRContactFirstOn As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = ADDR_ContactFirstOn ];

/// BestContactTime
Property ADDRBestContactTime As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = ADDR_BestContactTime ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProvAddress).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvAddress","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProvAddress).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvAddress","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProvAddress).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvAddress","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProvAddress).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvAddress","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProvAddress).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCareProvAddress","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADDR_Address1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADDR_Address2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADDR_BestContactTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADDR_ContactFirstOn">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADDR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADDR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADDR_Email">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADDR_Fax">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADDR_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADDR_Mobile">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADDR_Pager">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADDR_Phone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADDR_Postcode_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADDR_PrefConMethod">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADDR_PrefMethod">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADDR_ProvNumber">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADDR_State_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADDR_Suburb_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADDR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADDR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADDR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ADDR_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvAddressS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
