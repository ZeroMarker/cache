/// SundryDebtor(2529)
Class User.ARCSundryDebtor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_SundryDebtor, StorageStrategy = SQLStorage ]
{

Relationship ChildARCSundryDebtorComments As ARCSundryDebtorComments [ Cardinality = children, Inverse = CMTParRef ];

/// Code
Property DEBCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DEB_Code ];

/// Description
Property DEBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DEB_Desc ];

/// Address
Property DEBAddress As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DEB_Address, SqlListType = SUBNODE ];

/// Alternate Address
Property DEBAltAddress As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DEB_AltAddress, SqlListType = SUBNODE ];

/// Des Ref City
Property DEBCityDR As CTCity [ SqlColumnNumber = 6, SqlFieldName = DEB_City_DR ];

/// Des Ref Zip
Property DEBZipDR As CTZip [ SqlColumnNumber = 7, SqlFieldName = DEB_Zip_DR ];

/// Phone
Property DEBPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DEB_Phone ];

/// Fax
Property DEBFax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DEB_Fax ];

/// Email
Property DEBEmail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = DEB_Email ];

/// Des Ref CareProv
Property DEBCareProvDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = DEB_CareProv_DR ];

/// Outstanding Balance
Property DEBOutsBalance As %Float [ SqlColumnNumber = 12, SqlFieldName = DEB_OutsBalance ];

/// PhoneExt
Property DEBPhoneExt As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DEB_PhoneExt ];

/// DebtorRef
Property DEBDebtorRef As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DEB_DebtorRef ];

/// Alternative Name
Property DEBAltName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DEB_AltName ];

/// Des Ref Hospital
Property DEBHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = DEB_Hospital_DR ];

/// Des REf Zip
Property DEBAltZipDR As CTZip [ SqlColumnNumber = 17, SqlFieldName = DEB_AltZip_DR ];

/// Des Ref AltCity
Property DEBAltCityDR As CTCity [ SqlColumnNumber = 18, SqlFieldName = DEB_AltCity_DR ];

/// Address2
Property DEBAddress2 As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = DEB_Address2, SqlListType = SUBNODE ];

/// AltAddress2
Property DEBAltAddress2 As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = DEB_AltAddress2, SqlListType = SUBNODE ];

/// Notes
Property DEBNotes As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = DEB_Notes, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCSundryDebtor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCSundryDebtor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCSundryDebtor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCSundryDebtor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtor","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCSundryDebtor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtor","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCSundryDebtor","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>23</ExtentSize>
<Property name="DEBAddress">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DEBAddress2">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="DEBAltAddress">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBAltAddress2">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DEBAltCityDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBAltName">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBAltZipDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBCareProvDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBCityDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DEBCode">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="DEBDebtorRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBDesc">
<Selectivity>4.3478%</Selectivity>
</Property>
<Property name="DEBEmail">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBFax">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBHospitalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBNotes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBOutsBalance">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DEBPhone">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="DEBPhoneExt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="DEBZipDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("SUNDEB",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DEB_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="DEB_Address2">
<Node>"ADDR2"</Node>
</Data>
<Data name="DEB_AltAddress">
<Node>"ALTADDR"</Node>
</Data>
<Data name="DEB_AltAddress2">
<Node>"ALTADDR2"</Node>
</Data>
<Data name="DEB_AltCity_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DEB_AltName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DEB_AltZip_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DEB_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DEB_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEB_DebtorRef">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DEB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEB_Email">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DEB_Fax">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DEB_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DEB_Notes">
<Node>"NOTES"</Node>
</Data>
<Data name="DEB_OutsBalance">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DEB_Phone">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEB_PhoneExt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DEB_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DEB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUNDEB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareProv">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DEB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUNDEB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CareProv"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEB_CareProv_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DEB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUNDEB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DEB_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DEB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUNDEB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DEB_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DEB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SUNDEB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEB_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DEB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEB_RowId</SqlRowIdName>
<StreamLocation>^User.ARCSundryDebtorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
