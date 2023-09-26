Class User.INSUDivideSubCate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDIVS_Rowid, SqlTableName = INSU_DivideSubCate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDIVS_DivideDr
Property INDIVSDivideDr As User.INSUDivide [ SqlColumnNumber = 2, SqlFieldName = INDIVS_DivideDr ];

/// INDIVS_PB_Dr
Property INDIVSPBDr As User.DHCPatientBill [ SqlColumnNumber = 3, SqlFieldName = INDIVS_PB_Dr ];

/// INDIVS_HisCate
Property INDIVSHisCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDIVS_HisCate ];

/// INDIVS_InsuCate
Property INDIVSInsuCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDIVS_InsuCate ];

/// INDIVS_Date
Property INDIVSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INDIVS_Date ];

/// INDIVS_Time
Property INDIVSTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INDIVS_Time ];

/// INDIVS_Amount
Property INDIVSAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INDIVS_Amount ];

/// INDIVS_TCJJ
Property INDIVSTCJJ As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INDIVS_TCJJ ];

/// INDIVS_YLXZF
Property INDIVSYLXZF As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INDIVS_YLXZF ];

/// INDIVS_JLFY
Property INDIVSJLFY As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INDIVS_JLFY ];

/// INDIVS_YLFY
Property INDIVSYLFY As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INDIVS_YLFY ];

/// INDIVS_BLFY
Property INDIVSBLFY As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INDIVS_BLFY ];

/// INDIVS_DLFY
Property INDIVSDLFY As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INDIVS_DLFY ];

/// INDIVS_GRZFFY
Property INDIVSGRZFFY As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INDIVS_GRZFFY ];

/// INDIVS_CXJZFFY
Property INDIVSCXJZFFY As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INDIVS_CXJZFFY ];

/// INDIVS_Demo1
Property INDIVSDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INDIVS_Demo1 ];

/// INDIS_Demo2
Property INDIVSDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INDIVS_Demo2 ];

/// INDIS_Demo3
Property INDIVSDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INDIVS_Demo3 ];

/// INDIS_Demo4
Property INDIVSDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INDIVS_Demo4 ];

/// INDIS_Demo5
Property INDIVSDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INDIVS_Demo5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDIVS)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INDIVS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDIVS_BLFY">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDIVS_CXJZFFY">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INDIVS_DLFY">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDIVS_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDIVS_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INDIVS_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INDIVS_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INDIVS_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INDIVS_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INDIVS_DivideDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDIVS_GRZFFY">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDIVS_HisCate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDIVS_InsuCate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDIVS_JLFY">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDIVS_PB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDIVS_TCJJ">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDIVS_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDIVS_YLFY">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDIVS_YLXZF">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCINDIVS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDIVS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INDIVS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofDate">
<Global>^DHCINDIVS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIVS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIVS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIVS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPBDr">
<Global>^DHCINDIVS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIVS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIVS_PB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIVS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPBDrInsuCateDr">
<Global>^DHCINDIVS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIVS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsuCateDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIVS_PB_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDIVS_InsuCate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDIVS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPBDrTarCateDr">
<Global>^DHCINDIVS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIVS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TarCate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIVS_PB_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDIVS_HisCate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDIVS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDivideSubCateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
