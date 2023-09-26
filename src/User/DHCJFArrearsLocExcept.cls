Class User.DHCJFArrearsLocExcept Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFALE_RowID, SqlTableName = DHC_JFArrearsLocExcept, StorageStrategy = SQLStorage ]
{

/// JFALE_Loc_DR
Property JFALELocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = JFALE_Loc_DR ];

/// JFALE_DateFrom
Property JFALEDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = JFALE_DateFrom ];

/// JFALE_DateTo
Property JFALEDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = JFALE_DateTo ];

/// JFALE_User_DR
Property JFALEUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = JFALE_User_DR ];

/// JFALE_Date
Property JFALEDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = JFALE_Date ];

/// JFALE_Time
Property JFALETime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = JFALE_Time ];

/// JFALE_Hosp_DR
Property JFALEHospDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = JFALL_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFARREARSLOCEXCEPT)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="JFALE_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JFALE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFALE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFALE_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFALE_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JFALE_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFALL_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCJFARREARSLOCEXCEPT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JFALE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{JFALE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexLoc">
<Global>^DHCJFARREARSLOCEXCEPT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFALE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFALE_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFALE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFArrearsLocExceptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
