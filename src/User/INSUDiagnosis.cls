Class User.INSUDiagnosis Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDIS_Rowid, SqlTableName = INSU_Diagnosis, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDIS_bzxmbm
Property INDISbzxmbm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INDIS_bzxmbm ];

/// INDIS_bzbm
Property INDISbzbm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INDIS_bzbm ];

/// INDIS_bzmc
Property INDISbzmc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDIS_bzmc ];

/// INDIS_srrj
Property INDISsrrj As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDIS_srrj ];

/// INDIS_srrj2
Property INDISsrrj2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INDIS_srrj2 ];

/// INDIS_jcbzbz
Property INDISjcbzbz As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDIS_jcbzbz ];

/// INDIS_Cate
Property INDISCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDIS_Cate ];

/// INDIS_SubCate
Property INDISSubCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDIS_SubCate ];

/// INDIS_Date
Property INDISDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INDIS_Date ];

/// INDIS_Time
Property INDISTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = INDIS_Time ];

/// INDIS_User_Dr
Property INDISUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = INDIS_User_Dr ];

/// INDIS_ADDIP
Property INDISADDIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INDIS_ADDIP ];

/// INDIS_ActiveDate
Property INDISActiveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = INDIS_ActiveDate ];

/// INDIS_Unique
Property INDISUnique As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INDIS_Unique ];

/// INDIS_XString01
Property INDISXString01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INDIS_XString01 ];

/// INDIS_XString02
Property INDISXString02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INDIS_XString02 ];

/// INDIS_XString03
Property INDISXString03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INDIS_XString03 ];

/// INDIS_XString04
Property INDISXString04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INDIS_XString04 ];

/// INDIS_XString05
Property INDISXString05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INDIS_XString05 ];

/// INDIS_XString06
Property INDISXString06 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INDIS_XString06 ];

/// INDIS_XString07
Property INDISXString07 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INDIS_XString07 ];

/// INDIS_XString08
Property INDISXString08 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INDIS_XString08 ];

/// INDIS_HisVer(院内版本号)  INDIS_XString09->INDIS_HisVer	upt 20230208
Property INDISHisVer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INDIS_HisVer ];

// Property INDISXString10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INDIS_XString10 ];

/// INDIS_XString10->INDIS_ExpiryDate	upt 20221012
Property INDISExpiryDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = INDIS_ExpiryDate ];

/// INDIS_HospDr
Property INDISHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INDIS_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDiagnos)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INDIS_ADDIP">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDIS_ActiveDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDIS_Cate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDIS_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INDIS_HisVer">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INDIS_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INDIS_SubCate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDIS_Unique">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDIS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDIS_XString01">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INDIS_XString02">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INDIS_XString03">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INDIS_XString04">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INDIS_XString05">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INDIS_XString06">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INDIS_XString07">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INDIS_XString08">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INDIS_bzbm">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDIS_bzmc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDIS_bzxmbm">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDIS_jcbzbz">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDIS_srrj">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDIS_srrj2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINDiagnos</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INDIS_srrj})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasHosp">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIS_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Alias"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INDIS_srrj})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INDIS_bzbm})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodeHosp">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIS_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CODE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INDIS_bzbm})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_bzmc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescHosp">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIS_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DESC"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDIS_bzmc}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisVer">
<Global>^DHCINDiagnos</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HisVer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIS_HisVer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
