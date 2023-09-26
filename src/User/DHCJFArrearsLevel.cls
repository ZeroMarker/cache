Class User.DHCJFArrearsLevel Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JFAL_RowID, SqlTableName = DHC_JFArrearsLevel, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCJFArrearsOrdCat As User.DHCJFArrearsOrdCat [ Cardinality = children, Inverse = JFAOCALParref ];

/// JFAL_Code
Property JFALCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JFAL_Code ];

/// JFAL_Desc
Property JFALDesc As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JFAL_Desc ];

/// JFAL_Type
Property JFALType As %Library.String(DISPLAYLIST = ",Warning,Control,Ignore,Full", MAXLEN = 7, SELECTIVITY = "20.0000%", VALUELIST = ",W,C,I,F") [ SqlColumnNumber = 4, SqlFieldName = JFAL_Type ];

/// JFAL_OrderEntry
Property JFALOrderEntry As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = JFAL_OrderEntry ];

/// JFAL_OrderExecute
Property JFALOrderExecute As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = JFAL_OrderExecute ];

/// JFAL_Flag
Property JFALFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = JFAL_Flag ];

/// JFAL_LimitPrice
Property JFALLimitPrice As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = JFAL_LimitPrice ];

/// JFAL_LimitPrice2
Property JFALLimitPrice2 As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = JFAL_LimitPrice2 ];

/// JFAL_OrdCatReverse
Property JFALOrdCatReverse As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = JFAL_OrdCatReverse ];

/// JFAL_User_Dr
Property JFALUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = JFAL_User_Dr ];

/// JFAL_Date
Property JFALDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = JFAL_Date ];

/// JFAL_Time
Property JFALTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = JFAL_Time ];

/// JFAL_UpdateUser_Dr
Property JFALUpdateUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = JFAL_UpdateUser_Dr ];

/// JFAL_UpdateDate
Property JFALUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = JFAL_UpdateDate ];

/// JFAL_UpdateTime
Property JFALUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = JFAL_UpdateTime ];

/// JFAL_DateFrom
Property JFALDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = JFAL_DateFrom ];

/// JFAL_DateTo
Property JFALDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = JFAL_DateTo ];

/// JFAL_Hosp_DR
Property JFALHospDR As User.CTHospital [ SqlColumnNumber = 19, SqlFieldName = JFAL_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFARREARSLEVEL)</SqlIdExpression>
<SQLMap name="dataMaster">
<Data name="JFAL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JFAL_Date">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JFAL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="JFAL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="JFAL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JFAL_Flag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JFAL_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="JFAL_LimitPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JFAL_LimitPrice2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JFAL_OrdCatReverse">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JFAL_OrderEntry">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JFAL_OrderExecute">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JFAL_Time">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JFAL_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JFAL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JFAL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JFAL_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JFAL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCJFARREARSLEVEL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JFAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{JFAL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCJFARREARSLEVEL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JFAL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{JFAL_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{JFAL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFArrearsLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
