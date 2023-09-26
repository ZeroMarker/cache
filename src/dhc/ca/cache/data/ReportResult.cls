Class dhc.ca.cache.data.ReportResult Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ReportResult_rowid, SqlTableName = ReportResult, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ReportResult_repType
Property ReportResultrepType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ReportResult_repType ];

/// ReportResult_intervalDr
Property ReportResultintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 3, SqlFieldName = ReportResult_intervalDr ];

/// ReportResult_distSetDr
Property ReportResultdistSetDr As dhc.ca.cache.data.CostDistSets [ SqlColumnNumber = 4, SqlFieldName = ReportResult_distSetDr ];

/// ReportResult_dataSetDr
Property ReportResultdataSetDr As dhc.ca.cache.data.DataLevelSets [ SqlColumnNumber = 5, SqlFieldName = ReportResult_dataSetDr ];

/// ReportResult_fee
Property ReportResultfee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ReportResult_fee ];

/// ReportResult_deptName
Property ReportResultdeptName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ReportResult_deptName ];

/// ReportResult_deptLayer
Property ReportResultdeptLayer As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ReportResult_deptLayer ];

/// ReportResult_deptOrder
Property ReportResultdeptOrder As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ReportResult_deptOrder ];

/// ReportResult_deptType
Property ReportResultdeptType As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ReportResult_deptType ];

/// ReportResult_itemName
Property ReportResultitemName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ReportResult_itemName ];

/// ReportResult_itemLayer
Property ReportResultitemLayer As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = ReportResult_itemLayer ];

/// ReportResult_itemOrder
Property ReportResultitemOrder As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = ReportResult_itemOrder ];

/// ReportResult_itemType
Property ReportResultitemType As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ReportResult_itemType ];

/// ReportResult_dataType
Property ReportResultdataType As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = ReportResult_dataType ];

/// ReportResult_deptDr
Property ReportResultdeptDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ReportResult_deptDr ];

/// ReportResult_itemDr
Property ReportResultitemDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = ReportResult_itemDr ];

/// ReportResult_FDName
Property ReportResultFDName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = ReportResult_FDName ];

/// ReportResult_FDDr
Property ReportResultFDDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 19, SqlFieldName = ReportResult_FDDr ];

/// ReportResult_FDTName
Property ReportResultFDTName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ReportResult_FDTName ];

/// ReportResult_FDTDr
Property ReportResultFDTDr As dhc.ca.cache.data.DeptLevelSets [ SqlColumnNumber = 21, SqlFieldName = ReportResult_FDTDr ];

/// ReportResult_FDTOrder
Property ReportResultFDTOrder As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = ReportResult_FDTOrder ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAREPORTRESULT("0"))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="ReportResult_FDDr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ReportResult_FDName">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ReportResult_FDTDr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ReportResult_FDTName">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ReportResult_FDTOrder">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ReportResult_dataSetDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ReportResult_dataType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ReportResult_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ReportResult_deptLayer">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ReportResult_deptName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ReportResult_deptOrder">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ReportResult_deptType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ReportResult_distSetDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ReportResult_fee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ReportResult_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ReportResult_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ReportResult_itemLayer">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ReportResult_itemName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ReportResult_itemOrder">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ReportResult_itemType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ReportResult_repType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAREPORTRESULT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ReportResult_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ReportResult_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRTIntDiDa">
<Global>^DHCCAREPORTRESULT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L9}</Expression>
<Field>ReportResult_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RTIntDiDa"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ReportResult_repType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ReportResult_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ReportResult_distSetDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ReportResult_dataSetDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ReportResult_deptDr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ReportResult_itemDr}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ReportResult_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.ReportResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
