/// NonGovOrg(2165)
Class User.PACNonGovOrg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_NonGovOrg, StorageStrategy = SQLStorage ]
{

Relationship ChildPACNonGovOrgKeywords As PACNonGovOrgKeywords [ Cardinality = children, Inverse = KEYWParRef ];

/// Code
Property NGOCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = NGO_Code ];

/// Description
Property NGODesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = NGO_Desc ];

/// Address
Property NGOAddress As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = NGO_Address, SqlListType = SUBNODE ];

/// Des Ref City
Property NGOCityDR As CTCity [ SqlColumnNumber = 5, SqlFieldName = NGO_City_DR ];

/// Des Ref Zip
Property NGOZipDR As CTZip [ SqlColumnNumber = 6, SqlFieldName = NGO_Zip_DR ];

/// Des Ref Province
Property NGOProvinceDR As CTProvince [ SqlColumnNumber = 7, SqlFieldName = NGO_Province_DR ];

/// Phone
Property NGOPhone As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = NGO_Phone ];

/// Fax
Property NGOFax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = NGO_Fax ];

/// Email
Property NGOEmail As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = NGO_Email ];

/// Contact Method
Property NGOContactMethod As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = NGO_ContactMethod ];

/// DateFrom
Property NGODateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = NGO_DateFrom ];

/// DateTo
Property NGODateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = NGO_DateTo ];

/// School
Property NGOSchool As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = NGO_School ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACNonGovOrg).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrg","OnAfterInsert")
 d POFILINS^at2165
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACNonGovOrg).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrg","OnAfterUpdate")
 d POFILUPD^at2165
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACNonGovOrg).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrg","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACNonGovOrg).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrg","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrg","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACNonGovOrg).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNonGovOrg","OnAfterDelete")
 &sql(DELETE FROM PAC_NonGovOrgKeywords WHERE KEYW_ParRef=:%d(1))
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("NGO",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="NGO_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="NGO_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NGO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NGO_ContactMethod">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NGO_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NGO_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NGO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NGO_Email">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NGO_Fax">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NGO_Phone">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NGO_Province_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NGO_School">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NGO_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NGO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NGO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NGO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NGO_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NGO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NGO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NGO_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NGO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchoolCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NGO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SchoolCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NGO_School}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({NGO_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NGO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchoolDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NGO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NGO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SchoolDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NGO_School}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({NGO_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NGO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NGO_RowId</SqlRowIdName>
<StreamLocation>^User.PACNonGovOrgS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
