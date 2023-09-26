Class User.DHCMedPVMReport Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_MedPVMReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedPVMReportDtl As User.DHCMedPVMReportDtl [ Cardinality = children, Inverse = Parref ];

/// report no
Property ReportNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// report type
Property ReportType As User.DHCMedDictory [ SqlColumnNumber = 3 ];

/// report status
Property ReportStatus As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// INCItm ID
Property INCItmID As User.INCItm [ SqlColumnNumber = 5 ];

/// incitmbat id
Property INCItmBatID As User.INCItmBat [ SqlColumnNumber = 6 ];

/// report qty
Property ReportQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// instock qty
Property InStockQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

/// stock qty
Property StockQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// description
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10 ];

/// resume text
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// opinion
Property Opinion As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// report loc id
Property ReportLocID As User.CTLoc [ SqlColumnNumber = 13 ];

/// report place
Property ReportPlace As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// report user
Property ReportUser As User.SSUser [ SqlColumnNumber = 15 ];

/// report date
Property ReportDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16 ];

/// report time
Property ReportTime As %Library.Time [ SqlColumnNumber = 17 ];

/// check user
Property CheckUser As User.SSUser [ SqlColumnNumber = 18 ];

/// Check date
Property CheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19 ];

/// check time
Property CheckTime As %Library.Time [ SqlColumnNumber = 20 ];

/// text1
Property Text1 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

/// text2
Property Text2 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMedPVMRep)</SqlIdExpression>
<SQLMap name="IndexDateLoc">
<Global>^DHCMedPVMRep</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ReportDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ReportLocID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReportDateMap">
<Global>^DHCMedPVMRep</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RepDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ReportDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataMap">
<Data name="CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CheckUser">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="Description">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCItmBatID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCItmID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InStockQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Opinion">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ReportDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ReportLocID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ReportNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ReportPlace">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ReportQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ReportStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ReportTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ReportType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ReportUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="StockQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Text1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="Text2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCMedPVMRep</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedPVMReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
