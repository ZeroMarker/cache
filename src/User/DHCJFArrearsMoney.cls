Class User.DHCJFArrearsMoney Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFAM_RowID, SqlTableName = DHC_JFArrearsMoney, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On JFAMChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_JFArrears Parent Reference
Relationship JFAMJFAParref As User.DHCJFArrears [ Cardinality = parent, Inverse = ChildDHCJFArrearsMoney, Required, SqlFieldName = JFAM_JFA_Parref ];

/// JFAM_ChildSub
Property JFAMChildSub As %Library.Float [ InitialExpression = {$i(^DHCJFARREARS(+%d(0),"M",0))}, Required, SqlColumnNumber = 2, SqlFieldName = JFAM_ChildSub ];

/// JFAM_AL_Dr
Property JFAMALDr As User.DHCJFArrearsLevel [ SqlColumnNumber = 3, SqlFieldName = JFAM_AL_Dr ];

/// JFAM_Type
Property JFAMType As %Library.String(DISPLAYLIST = ",Deposit,Arrears", MAXLEN = 7, SELECTIVITY = "33.3333%", VALUELIST = ",D,A") [ SqlColumnNumber = 4, SqlFieldName = JFAM_Type ];

/// JFAM_Operator1
Property JFAMOperator1 As %Library.String(MAXLEN = 2, SELECTIVITY = "16.6667%", VALUELIST = ",>=,<=,>,<,=") [ SqlColumnNumber = 5, SqlFieldName = JFAM_Operator1 ];

/// JFAM_MoneyFrom
Property JFAMMoneyFrom As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = JFAM_MoneyFrom ];

/// JFAM_Operator2
Property JFAMOperator2 As %Library.String(MAXLEN = 2, SELECTIVITY = "16.6667%", VALUELIST = ",<=,>=,<,>,=") [ SqlColumnNumber = 7, SqlFieldName = JFAM_Operator2 ];

/// JFAM_MoneyTo
Property JFAMMoneyTo As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = JFAM_MoneyTo ];

/// JFAM_Desc
Property JFAMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = JFAM_Desc ];

/// JFAM_Flag
Property JFAMFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = JFAM_Flag ];

/// JFAM_User_Dr
Property JFAMUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = JFAM_User_Dr ];

/// JFAM_Date
Property JFAMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = JFAM_Date ];

/// JFAM_Time
Property JFAMTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = JFAM_Time ];

/// JFAM_UpdateUser_Dr
Property JFAMUpdateUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = JFAM_UpdateUser_Dr ];

/// JFAM_UpdateDate
Property JFAMUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = JFAM_UpdateDate ];

/// JFAM_UpdateTime
Property JFAMUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = JFAM_UpdateTime ];

/// JFAM_DateFrom
Property JFAMDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = JFAM_DateFrom ];

/// JFAM_DateTo
Property JFAMDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = JFAM_DateTo ];

/// JFAM_FeeRate
Property JFAMFeeRate As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = JFAM_FeeRate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataDHCJFARREARS">
<Data name="JFAM_AL_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFAM_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JFAM_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JFAM_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="JFAM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JFAM_FeeRate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="JFAM_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JFAM_MoneyFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFAM_MoneyTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JFAM_Operator1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFAM_Operator2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JFAM_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JFAM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFAM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JFAM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JFAM_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JFAM_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCJFARREARS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_JFArrears.JFA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>JFAM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_JFArrears.JFA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"M"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{JFAM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexAM">
<Global>^DHCJFARREARS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_JFArrears.JFA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>JFAM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_JFArrears.JFA_RowID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFAM_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{JFAM_AL_Dr}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{JFAM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFArrearsMoneyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
