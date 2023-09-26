Class User.DHCEQBussWarnDays Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BWD_RowID, SqlTableName = DHC_EQBussWarnDays, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BWD_BussID
Property BWDBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BWD_BussID ];

/// BWD_EndDay
Property BWDEndDay As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = BWD_EndDay ];

/// BWD_Hold1
Property BWDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BWD_Hold1 ];

/// BWD_Hold2
Property BWDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BWD_Hold2 ];

/// BWD_Hold3
Property BWDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BWD_Hold3 ];

/// BWD_Hold4
Property BWDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BWD_Hold4 ];

/// BWD_Hold5
Property BWDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BWD_Hold5 ];

/// BWD_InvalidFlag
Property BWDInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = BWD_InvalidFlag ];

/// BWD_OverDueDaysNum
Property BWDOverDueDaysNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BWD_OverDueDaysNum ];

/// BWD_Remark
Property BWDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BWD_Remark ];

/// BWD_SourceType
Property BWDSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BWD_SourceType ];

/// BWD_SubType
Property BWDSubType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BWD_SubType ];

/// BWD_WarnDay
Property BWDWarnDay As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = BWD_WarnDay ];

/// BWD_WarnDaysNum
Property BWDWarnDaysNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BWD_WarnDaysNum ];

/// BWD_UpdateDate
Property BWDUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = BWD_UpdateDate ];

/// BWD_UpdateTime
Property BWDUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = BWD_UpdateTime ];

/// BWD_UpdateUserDR
Property BWDUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BWD_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBussWarnDays("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BWD_BussID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BWD_EndDay">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BWD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BWD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BWD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BWD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BWD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BWD_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BWD_OverDueDaysNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BWD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BWD_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BWD_SubType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BWD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BWD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BWD_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BWD_WarnDay">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BWD_WarnDaysNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQBussWarnDays</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BWD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BWD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQBussWarnDays</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>BWD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BWD_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BWD_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BWD_SubType}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{BWD_BussID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{BWD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubType">
<Global>^DHCEQBussWarnDays</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BWD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SubType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BWD_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BWD_SubType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BWD_BussID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{BWD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBussWarnDaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
