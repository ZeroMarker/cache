Class User.INSUICDContrast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INICT_Rowid, SqlTableName = INSU_ICDContrast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INICT_His_Dr
Property INICTHisDr As User.MRCICDDx [ SqlColumnNumber = 2, SqlFieldName = INICT_His_Dr ];

/// INICT_HisCode
Property INICTHisCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INICT_HisCode ];

/// INICT_HisDesc
Property INICTHisDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INICT_HisDesc ];

/// INICT_Insu_Dr
Property INICTInsuDr As User.INSUDiagnosis [ SqlColumnNumber = 5, SqlFieldName = INICT_Insu_Dr ];

/// INICT_InsuCode
Property INICTInsuCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INICT_InsuCode ];

/// INICT_InsuDesc
Property INICTInsuDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INICT_InsuDesc ];

/// INICT_DicType
Property INICTDicType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INICT_DicType ];

/// INICT_ActiveDate
Property INICTActiveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = INICT_ActiveDate ];

/// INICT_User_Dr
Property INICTUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = INICT_User_Dr ];

/// INICT_Date
Property INICTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = INICT_Date ];

/// INICT_Time
Property INICTTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = INICT_Time ];

/// INICT_ADDIP
Property INICTADDIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INICT_ADDIP ];

/// INICT_Unique
Property INICTUnique As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INICT_Unique ];

/// INICT_XString01
Property INICTXString01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INICT_XString01 ];

/// INICT_XString02
Property INICTXString02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INICT_XString02 ];

/// INICT_XString03
Property INICTXString03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INICT_XString03 ];

/// INICT_XString04
Property INICTXString04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INICT_XString04 ];

/// INICT_XString05
Property INICTXString05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INICT_XString05 ];

/// INICT_HospDr
Property INICTHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INICT_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINICT)</SqlIdExpression>
<SQLMap name="DATAMasterMap">
<Data name="INICT_ADDIP">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INICT_ActiveDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INICT_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INICT_DicType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INICT_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INICT_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INICT_His_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INICT_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INICT_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INICT_InsuDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INICT_Insu_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INICT_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INICT_Unique">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INICT_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INICT_XString01">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INICT_XString02">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INICT_XString03">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INICT_XString04">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INICT_XString05">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCINICT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsuId">
<Global>^DHCINICT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INDISID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INICT_Insu_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsuIdHosp">
<Global>^DHCINICT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INICT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"INDISID"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INICT_Insu_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRCICDID">
<Global>^DHCINICT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MRCICDID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INICT_His_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRCICDIDHosp">
<Global>^DHCINICT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INICT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"MRCICDID"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INICT_His_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofActDate">
<Global>^DHCINICT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ActDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INICT_His_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INICT_DicType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INICT_ActiveDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofActDateHosp">
<Global>^DHCINICT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>INICT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INICT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ActDate"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INICT_His_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INICT_DicType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INICT_ActiveDate}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INICT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUICDContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
