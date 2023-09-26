Class User.DHCPracticeDocPreOrder Extends %Persistent [ SqlTableName = DHC_PracticeDocPreOrder, StorageStrategy = DHCPracticeDocPreOrder ]
{

/// adm
Property PracticeAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PracticeAdmDR ];

/// 医嘱json
Property PracticeJson As %Library.String(COLLATION = "Exact", MAXLEN = 1000000) [ SqlColumnNumber = 3, SqlFieldName = PracticeJson ];

/// 医嘱状态
Property PracticeJsonType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PracticeJsonType ];

/// 插入医嘱的实习生
Property PracticePreUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PracticePreUser ];

/// 插入医嘱的实习生日期
Property PracticePreDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = PracticePreDate ];

/// 插入医嘱的实习生时间
Property PracticePreTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PracticePreTime ];

/// 审核医嘱实习生医嘱的医生
Property PracticeConDoc As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PracticeConDoc ];

/// 插入医嘱的实习生日期
Property PracticeConDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = PracticeConDate ];

/// 插入医嘱的实习生时间
Property PracticeConTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PracticeConTime ];

/// 回插医嘱id
Property PracticeOrdItemDR As User.OEOrdItem [ SqlColumnNumber = 11, SqlFieldName = PracticeOrdItemDR ];

/// 录入界面类型
Property PracticeInsertType As %Library.String [ SqlColumnNumber = 12, SqlFieldName = PracticeInsertType ];

Storage DHCPracticeDocPreOrder
{
<SqlIdExpression>$i(^DHCPracticeDocPre(0))</SqlIdExpression>
<SQLMap name="IndexAdmDr">
<Global>^DHCPracticeDocPrei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AllAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PracticeAdmDR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeAdm">
<Global>^DHCPracticeDocPrei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TypeAdm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PracticeJsonType}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PracticeAdmDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="PracticeAdmDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PracticeConDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PracticeConDoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PracticeConTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PracticeInsertType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PracticeJson">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PracticeJsonType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PracticeOrdItemDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PracticePreDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PracticePreTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PracticePreUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPracticeDocPre</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCPracticeDocPreOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
