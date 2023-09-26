Class dhc.ca.cache.data.BaseData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BaseData_rowid, SqlTableName = BaseData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BaseData_intervalDr
Property BaseDataintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 2, SqlFieldName = BaseData_intervalDr ];

/// BaseData_sysDataType
Property BaseDatasysDataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BaseData_sysDataType ];

/// BaseData_dataTypeDr
Property BaseDatadataTypeDr As dhc.ca.cache.data.DataItemTypes [ SqlColumnNumber = 4, SqlFieldName = BaseData_dataTypeDr ];

/// BaseData_busDate
Property BaseDatabusDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = BaseData_busDate ];

/// BaseData_itemDr
Property BaseDataitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 6, SqlFieldName = BaseData_itemDr ];

/// BaseData_itemCode
Property BaseDataitemCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BaseData_itemCode ];

/// BaseData_itemName
Property BaseDataitemName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BaseData_itemName ];

/// BaseData_servDeptDr
Property BaseDataservDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 9, SqlFieldName = BaseData_servDeptDr ];

/// BaseData_servDeptCode
Property BaseDataservDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BaseData_servDeptCode ];

/// BaseData_servDeptName
Property BaseDataservDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BaseData_servDeptName ];

/// BaseData_serverDr
Property BaseDataserverDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 12, SqlFieldName = BaseData_serverDr ];

/// BaseData_serverCode
Property BaseDataserverCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BaseData_serverCode ];

/// BaseData_serverName
Property BaseDataserverName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BaseData_serverName ];

/// BaseData_servedDeptDr
Property BaseDataservedDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 15, SqlFieldName = BaseData_servedDeptDr ];

/// BaseData_servedDeptCode
Property BaseDataservedDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BaseData_servedDeptCode ];

/// BaseData_servedDeptName
Property BaseDataservedDeptName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BaseData_servedDeptName ];

/// BaseData_receiverDr
Property BaseDatareceiverDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 18, SqlFieldName = BaseData_receiverDr ];

/// BaseData_receiverCode
Property BaseDatareceiverCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BaseData_receiverCode ];

/// BaseData_receiverName
Property BaseDatareceiverName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BaseData_receiverName ];

/// BaseData_price
Property BaseDataprice As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = BaseData_price ];

/// BaseData_amount
Property BaseDataamount As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = BaseData_amount ];

/// BaseData_fee
Property BaseDatafee As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = BaseData_fee ];

/// BaseData_operType
Property BaseDataoperType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BaseData_operType ];

/// BaseData_operDate
Property BaseDataoperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = BaseData_operDate ];

/// BaseData_operDr
Property BaseDataoperDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 26, SqlFieldName = BaseData_operDr ];

/// BaseData_operDeptDr
Property BaseDataoperDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 27, SqlFieldName = BaseData_operDeptDr ];

/// BaseData_remark
Property BaseDataremark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BaseData_remark ];

/// BaseData_remark1
Property BaseDataremark1 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BaseData_remark1 ];

/// BaseData_remark2
Property BaseDataremark2 As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BaseData_remark2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCABASEDATA(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="BaseData_amount">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BaseData_busDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BaseData_dataTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BaseData_fee">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BaseData_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BaseData_itemCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BaseData_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BaseData_itemName">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BaseData_operDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BaseData_operDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BaseData_operDr">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BaseData_operType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BaseData_price">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BaseData_receiverCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BaseData_receiverDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BaseData_receiverName">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BaseData_remark">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BaseData_remark1">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BaseData_remark2">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BaseData_servDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BaseData_servDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BaseData_servDeptName">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BaseData_servedDeptCode">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BaseData_servedDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BaseData_servedDeptName">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BaseData_serverCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BaseData_serverDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BaseData_serverName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BaseData_sysDataType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCABASEDATA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BaseData_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInt">
<Global>^DHCCABASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Int"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BaseData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntSys">
<Global>^DHCCABASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntSys"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BaseData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BaseData_sysDataType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntSysDype">
<Global>^DHCCABASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntSysDype"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BaseData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BaseData_sysDataType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BaseData_dataTypeDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIntSysDypeUser">
<Global>^DHCCABASEDATA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>BaseData_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IntSysDypeUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BaseData_intervalDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BaseData_sysDataType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BaseData_dataTypeDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BaseData_operDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{BaseData_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.BaseDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
