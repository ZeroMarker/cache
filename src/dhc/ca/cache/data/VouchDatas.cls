Class dhc.ca.cache.data.VouchDatas Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VouchDatas_rowid, SqlTableName = VouchDatas, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// VouchData_intervalDr
Property VouchDatasintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = VouchDatas_intervalDr ];

/// VouchData_deptDr
Property VouchDatasdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = VouchDatas_deptDr ];

/// VouchData_itemDr
Property VouchDatasitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = VouchDatas_itemDr ];

/// VouchData_inType
Property VouchDatasinType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VouchDatas_inType ];

/// VouchDatas_personDr
Property VouchDataspersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 6, SqlFieldName = VouchDatas_personDr ];

/// VouchDatas_remark
Property VouchDatasremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VouchDatas_remark ];

/// VouchDatas_dealFlag
Property VouchDatasdealFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = VouchDatas_dealFlag ];

//Property VouchDatasmonth As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = VouchDatas_month ];

/// VouchDatas_month
Property VouchDatasmonth As %Library.String [ SqlColumnNumber = 9, SqlFieldName = VouchDatas_month ];

/// VouchDatas_num
Property VouchDatasnum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = VouchDatas_num ];

/// VouchDatas_date
Property VouchDatasdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = VouchDatas_date ];

/// VouchDatas_abstract
Property VouchDatasabstract As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = VouchDatas_abstract ];

/// VouchDatas_deptCode
Property VouchDatasdeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = VouchDatas_deptCode ];

/// VouchDatas_deptName
Property VouchDatasdeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = VouchDatas_deptName ];

/// VouchDatas_subjCode
Property VouchDatassubjCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = VouchDatas_subjCode ];

/// VouchDatas_subjName
Property VouchDatassubjName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = VouchDatas_subjName ];

/// VouchDatas_debit
Property VouchDatasdebit As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = VouchDatas_debit ];

/// VouchDatas_loans
Property VouchDatasloans As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = VouchDatas_loans ];

/// VouchDatas_entryFlag
Property VouchDatasentryFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = VouchDatas_entryFlag ];

/// VouchDatas_PatWardCode
Property VouchDatasPatWardCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = VouchDatas_PatWardCode ];

/// VouchDatas_PatWardName
Property VouchDatasPatWardName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = VouchDatas_PatWardName ];

/// VouchDatas_PatWardDr
Property VouchDatasPatWardDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 22, SqlFieldName = VouchDatas_PatWardDr ];

/// VouchDatas_PatDocCode
Property VouchDatasPatDocCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = VouchDatas_PatDocCode ];

/// VouchDatas_PatDocName
Property VouchDatasPatDocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = VouchDatas_PatDocName ];

/// VouchDatas_PatDocDr
Property VouchDatasPatDocDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 25, SqlFieldName = VouchDatas_PatDocDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAVOUCHDATAS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="VouchDatas_PatDocCode">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="VouchDatas_PatDocDr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="VouchDatas_PatDocName">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="VouchDatas_PatWardCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="VouchDatas_PatWardDr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="VouchDatas_PatWardName">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="VouchDatas_abstract">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VouchDatas_date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VouchDatas_dealFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VouchDatas_debit">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="VouchDatas_deptCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VouchDatas_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VouchDatas_deptName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="VouchDatas_entryFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="VouchDatas_inType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VouchDatas_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VouchDatas_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VouchDatas_loans">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="VouchDatas_month">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="VouchDatas_num">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VouchDatas_personDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VouchDatas_remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VouchDatas_subjCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="VouchDatas_subjName">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCCAVOUCHDATAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VouchDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VouchDatas_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Global>^DHCCAVOUCHDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VouchDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VouchDatas_deptDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VouchDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInterval">
<Global>^DHCCAVOUCHDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VouchDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Interval"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VouchDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VouchDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalDept">
<Global>^DHCCAVOUCHDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VouchDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VouchDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VouchDatas_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VouchDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalItem">
<Global>^DHCCAVOUCHDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VouchDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VouchDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VouchDatas_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VouchDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntervalentryflag">
<Global>^DHCCAVOUCHDATAS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VouchDatas_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntervalEntryflag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VouchDatas_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VouchDatas_entryFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VouchDatas_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.VouchDatasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
