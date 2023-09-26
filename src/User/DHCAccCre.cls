Class User.DHCAccCre Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Cre_RowID, SqlTableName = DHC_AccCre, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCAccCreSub As User.DHCAccCreSub [ Cardinality = children, Inverse = CreSubParRef ];

/// CreDate
Property CreDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = Cre_Date ];

/// CreTime
Property CreTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = Cre_Time ];

/// CreActiveFlag
Property CreActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = Cre_ActiveFlag ];

/// CreStartDate
Property CreStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = Cre_StartDate ];

/// CreEndDate
Property CreEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = Cre_EndDate ];

/// CreCode
Property CreCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Cre_Code ];

/// CreDesc
Property CreDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Cre_Desc ];

/// CreDataSource
Property CreDataSource As %Library.String(DISPLAYLIST = ",FP,YJ ,ALL", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",FP,YJ,ALL") [ SqlColumnNumber = 4, SqlFieldName = Cre_DataSource ];

/// CrePatType
Property CrePatType As %Library.String(DISPLAYLIST = ",In Patient,Out Patient,ALL", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,A") [ SqlColumnNumber = 5, SqlFieldName = Cre_PatType ];

/// CrePrePrtFlag
Property CrePrePrtFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = Cre_PrePrtFlag ];

/// CreIncluAbort
Property CreIncluAbort As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = Cre_IncluAbort ];

/// CreModeCode    ----ACCTSysMode
Property CreModeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Cre_ModeCode ];

/// CreBusiType
Property CreBusiType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = Cre_BusiType ];

/// CreNote1
Property CreNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Cre_Note1 ];

/// CreNote2
Property CreNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Cre_Note2 ];

/// CreNote3
Property CreNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = Cre_Note3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACCCRE)</SqlIdExpression>
<SQLMap name="datamaster">
<Data name="Cre_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Cre_BusiType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Cre_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Cre_DataSource">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Cre_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Cre_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Cre_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Cre_IncluAbort">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Cre_ModeCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Cre_Note1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Cre_Note2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Cre_Note3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Cre_PatType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Cre_PrePrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Cre_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Cre_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCACCCRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Cre_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Cre_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexcode">
<Global>^DHCACCCRE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Cre_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cre_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cre_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccCreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
