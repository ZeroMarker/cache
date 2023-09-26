Class User.DHCWMRHistory Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_History, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PatientName
Property PatientName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// NameSpell
Property NameSpell As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Sex
Property Sex As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Birthday
Property Birthday As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5 ];

/// Age
Property Age As %Library.Float [ SqlColumnNumber = 6 ];

/// Wedlock
Property Wedlock As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// Occupation
Property Occupation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// City
Property City As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// County
Property County As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// Nation
Property Nation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// Nationality
Property Nationality As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// IdentityCode
Property IdentityCode As %Library.String(COLLATION = "Exact", MAXLEN = 18, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// Company
Property Company As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// CompanyTel
Property CompanyTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

/// CompanyZip
Property CompanyZip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// HomeAddress
Property HomeAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// HomeTel
Property HomeTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// HomeZip
Property HomeZip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// RelationDesc
Property RelationDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

/// RelativeName
Property RelativeName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

/// RelativeTel
Property RelativeTel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22 ];

/// RelativeAddress
Property RelativeAddress As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRHISTORY)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="Age">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Birthday">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="City">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Company">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CompanyTel">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CompanyZip">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="County">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HomeAddress">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="HomeTel">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="HomeZip">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IdentityCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="NameSpell">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Nation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Nationality">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Occupation">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PatientName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RelationDesc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RelativeAddress">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RelativeName">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RelativeTel">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="Sex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Wedlock">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCWMRHISTORY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNameSpell">
<Global>^DHCWMRHISTORY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NameSpell"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({NameSpell})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatientName">
<Global>^DHCWMRHISTORY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatientName"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PatientName})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
