Class User.DHCEQDisuseList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DL_RowID, SqlTableName = DHC_EQDisuseList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DL_DisuseRequestDR
Property DLDisuseRequestDR As User.DHCEQDisuseRequest [ SqlColumnNumber = 2, SqlFieldName = DL_DisuseRequestDR ];

/// DL_SourceType
Property DLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DL_SourceType ];

/// DL_SourceID
Property DLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DL_SourceID ];

/// DL_Qty
Property DLQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DL_Qty ];

/// DL_UseState
Property DLUseState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DL_UseState ];

/// DL_DisuseReason
Property DLDisuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DL_DisuseReason ];

/// DL_DisuseDate
Property DLDisuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DL_DisuseDate ];

/// DL_Remark
Property DLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DL_Remark ];

/// DL_Hold1 原值
Property DLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DL_Hold1 ];

/// DL_Hold2 报废存放地点
Property DLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DL_Hold2 ];

/// DL_Hold3 处置方式
Property DLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DL_Hold3 ];

/// DL_Hold4 处置费用
Property DLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DL_Hold4 ];

/// DL_Hold5
Property DLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDisuseList("0"))</SqlIdExpression>
<SQLMap name="DataMastet">
<Data name="DL_DisuseDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DL_DisuseReason">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DL_DisuseRequestDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DL_Qty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DL_UseState">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQDisuseList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRequest">
<Global>^DHCEQDisuseList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Request"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DL_DisuseRequestDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQDisuseList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDisuseListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
