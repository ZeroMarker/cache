Class User.DHCJFArrearsOrdCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFAOC_RowID, SqlTableName = DHC_JFArrearsOrdCat, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On JFAOCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_JFArrearsLevel Parent Reference
Relationship JFAOCALParref As User.DHCJFArrearsLevel [ Cardinality = parent, Inverse = ChildDHCJFArrearsOrdCat, Required, SqlFieldName = JFAOC_AL_Parref ];

/// JFAOC_ChildSub
Property JFAOCChildSub As %Library.Float [ InitialExpression = {$i(^DHCJFARREARSLEVEL(+%d(0),"O",0))}, Required, SqlColumnNumber = 2, SqlFieldName = JFAOC_ChildSub ];

/// JFAOC_OrdCat_Dr
Property JFAOCOrdCatDr As User.OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = JFAOC_OrdCat_Dr ];

/// JFAOC_OrdSubCat_Dr
Property JFAOCOrdSubCatDr As User.ARCItemCat [ SqlColumnNumber = 4, SqlFieldName = JFAOC_OrdSubCat_Dr ];

/// JFAOC_DateFrom
Property JFAOCDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = JFAOC_DateFrom ];

/// JFAOC_DateTo
Property JFAOCDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = JFAOC_DateTo ];

/// JFAOC_User_Dr
Property JFAOCUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = JFAOC_User_Dr ];

/// JFAOC_Date
Property JFAOCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = JFAOC_Date ];

/// JFAOC_Time
Property JFAOCTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = JFAOC_Time ];

/// JFAOC_UpdateDate
Property JFAOCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = JFAOC_UpdateDate ];

/// JFAOC_UpdateTime
Property JFAOCUpdateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = JFAOC_UpdateTime ];

/// JFAOC_UpdateUser_Dr
Property JFAOCUpdateUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = JFAOC_UpdateUser_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="dataMaster">
<Data name="JFAOC_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JFAOC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFAOC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFAOC_OrdCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFAOC_OrdSubCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFAOC_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JFAOC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JFAOC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JFAOC_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JFAOC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCJFARREARSLEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_JFArrearsLevel.JFAL_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>JFAOC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_JFArrearsLevel.JFAL_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{JFAOC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOrdCat">
<Global>^DHCJFARREARSLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_JFArrearsLevel.JFAL_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>JFAOC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFAOC_OrdCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_JFArrearsLevel.JFAL_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFAOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOrdSubCat">
<Global>^DHCJFARREARSLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_JFArrearsLevel.JFAL_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>JFAOC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrdSubCat"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFAOC_OrdSubCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_JFArrearsLevel.JFAL_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFAOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFArrearsOrdCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
