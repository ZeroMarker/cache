Class User.DHCPhExeCute Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHE_Rowid, SqlTableName = DHC_PhExeCute, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHE_custom2
Property PHEAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHE_Amount ];

/// PHE_Custom3
Property PHECustom3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHE_Custom3 ];

/// PHE_Custom4
Property PHECustom4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHE_Custom4 ];

/// PHE_Date
Property PHEDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = PHE_Date ];

/// PHE_OEORE_Dr
Property PHEOEOREDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHE_OEORE_Dr ];

/// PHE_PaPmi_Dr
Property PHEPaPmiDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PHE_PaPmi_Dr ];

/// PHE_PhdDate
Property PHEPhdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PHE_PhdDate ];

/// PHE_Phdi_Dr
Property PHEPhdiDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PHE_Phdi_Dr ];

/// PHE_Phl_Dr
Property PHEPhlDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PHE_Phl_Dr ];

/// PHE_Php_Dr
Property PHEPhpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PHE_Php_Dr ];

/// PHE_QRFlag
Property PHEQRFlag As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHE_QRFlag ];

/// PHE_Custom1
Property PHEQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHE_Qty ];

/// PHE_Time
Property PHETime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PHE_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHEXEC)</SqlIdExpression>
<SQLMap name="Indexdate">
<Global>^DHCPHEXECi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHE_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexexec">
<Global>^DHCPHEXECi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"EXEC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHE_OEORE_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexpapmi">
<Global>^DHCPHEXECi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHE_PaPmi_Dr}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexphdi">
<Global>^DHCPHEXECi</Global>
<Subscript name="1">
<Expression>"PHDI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHE_Phl_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHE_Phdi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Phexemaster">
<Data name="PHE_Amount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHE_Custom3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHE_Custom4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHE_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHE_OEORE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHE_PaPmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHE_PhdDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHE_Phdi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHE_Phl_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHE_Php_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHE_QRFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHE_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHE_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPHEXEC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHE_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhExeCuteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
