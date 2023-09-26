/// KPIIndex1
Class dhc.pa.data.KPIIndex1 Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = KPIIndex1_rowid, SqlTableName = KPIIndex1, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// KPIIndex1_code
Property KPIIndex1code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = KPIIndex1_code ];

/// KPIIndex1_name
Property KPIIndex1name As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = KPIIndex1_name ];

/// KPIIndex1_shortcut
Property KPIIndex1shortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = KPIIndex1_shortcut ];

/// KPIIndex1_py
Property KPIIndex1py As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = KPIIndex1_py ];

/// KPIIndex1_dimTypeDr
Property KPIIndex1dimTypeDr As dhc.pa.data.DimensType [ SqlColumnNumber = 6, SqlFieldName = KPIIndex1_dimTypeDr ];

/// KPIIndex1_target
Property KPIIndex1target As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = KPIIndex1_target ];

/// KPIIndex1_desc
Property KPIIndex1desc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = KPIIndex1_desc ];

/// KPIIndex1_calUnitDr
Property KPIIndex1calUnitDr As dhc.pa.data.CalUnit [ SqlColumnNumber = 9, SqlFieldName = KPIIndex1_calUnitDr ];

/// KPIIndex1_extreMum
Property KPIIndex1extreMum As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = KPIIndex1_extreMum ];

/// KPIIndex1_expression
Property KPIIndex1expression As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = KPIIndex1_expression ];

/// KPIIndex1_expDesc
Property KPIIndex1expDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = KPIIndex1_expDesc ];

/// KPIIndex1_colTypeDr
Property KPIIndex1colTypeDr As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = KPIIndex1_colTypeDr ];

/// KPIIndex1_scoreMethodCode
Property KPIIndex1scoreMethodCode As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = KPIIndex1_scoreMethodCode ];

/// KPIIndex1_colDeptDr
Property KPIIndex1colDeptDr As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = KPIIndex1_colDeptDr ];

/// KPIIndex1_dataSource
Property KPIIndex1dataSource As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = KPIIndex1_dataSource ];

/// KPIIndex1_isHospKPI
Property KPIIndex1isHospKPI As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = KPIIndex1_isHospKPI ];

/// KPIIndex1_isDeptKPI
Property KPIIndex1isDeptKPI As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = KPIIndex1_isDeptKPI ];

/// KPIIndex1_isMedKPI
Property KPIIndex1isMedKPI As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = KPIIndex1_isMedKPI ];

/// KPIIndex1_isNurKPI
Property KPIIndex1isNurKPI As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = KPIIndex1_isNurKPI ];

/// KPIIndex1_isPostKPI
Property KPIIndex1isPostKPI As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = KPIIndex1_isPostKPI ];

/// KPIIndex1_parent
Property KPIIndex1parent As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = KPIIndex1_parent ];

/// KPIIndex1_level
Property KPIIndex1level As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = KPIIndex1_level ];

/// KPIIndex1_isStop
Property KPIIndex1isStop As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = KPIIndex1_isStop ];

/// KPIIndex1_isEnd
Property KPIIndex1isEnd As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = KPIIndex1_isEnd ];

/// KPIIndex1_order
Property KPIIndex1order As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = KPIIndex1_order ];

/// KPIIndex1_isKPI
Property KPIIndex1isKPI As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = KPIIndex1_isKPI ];

/// KPIIndex1_isTotal
Property KPIIndex1isTotal As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = KPIIndex1_isTotal ];

/// KPIIndex1_compType 1-增长率计算 2-差额计算 区间法1-增长率计算 2是原本计算
Property KPIIndex1compType As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = KPIIndex1_compType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAKPIINDEX1(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="KPIIndex1_calUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="KPIIndex1_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KPIIndex1_colDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="KPIIndex1_colTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="KPIIndex1_compType">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="KPIIndex1_dataSource">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="KPIIndex1_desc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="KPIIndex1_dimTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="KPIIndex1_expDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="KPIIndex1_expression">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="KPIIndex1_extreMum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="KPIIndex1_isDeptKPI">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="KPIIndex1_isEnd">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="KPIIndex1_isHospKPI">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="KPIIndex1_isKPI">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="KPIIndex1_isMedKPI">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="KPIIndex1_isNurKPI">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="KPIIndex1_isPostKPI">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="KPIIndex1_isStop">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="KPIIndex1_isTotal">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="KPIIndex1_level">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="KPIIndex1_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KPIIndex1_order">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="KPIIndex1_parent">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="KPIIndex1_py">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KPIIndex1_scoreMethodCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="KPIIndex1_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KPIIndex1_target">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCJXPAKPIINDEX1</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDimType">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DimType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_dimTypeDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPY">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PY"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_py}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentKPI">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentOrder">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParentOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPAKPIINDEX1</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>KPIIndex1_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ShortCut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KPIIndex1_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KPIIndex1_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.KPIIndex1S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
