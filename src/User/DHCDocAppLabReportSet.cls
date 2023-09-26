Class User.DHCDocAppLabReportSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHCDocAppLabReportSet, StorageStrategy = DHCDocAppLabReportSet ]
{

/// 类型
Property Type As %Library.String [ SqlColumnNumber = 2, SqlFieldName = Type ];

/// 路径
Property ReportFullFile As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ReportFullFile ];

/// 医嘱项ID
Property ARCIMDR As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ARCIMDR ];

/// 子类
Property ARCIMCatDR As User.ARCItemCat [ SqlColumnNumber = 5, SqlFieldName = ARCIMCatDR ];

/// 是否开启报告号
Property ToReportNo As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ToReportNo ];

/// 报告号前参数
Property BeforeReportNo As %Library.String [ SqlColumnNumber = 7, SqlFieldName = BeforeReportNo ];

/// 多个报告号分割服
Property BeforeReportNoSplit As %Library.String [ SqlColumnNumber = 8, SqlFieldName = BeforeReportNoSplit ];

/// 登记号
Property ToRegistNo As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ToRegistNo ];

/// 登记号前参数
Property BeforeRegistNo As %Library.String [ SqlColumnNumber = 10, SqlFieldName = BeforeRegistNo ];

/// 用户代码
Property ToUserCode As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ToUserCode ];

/// 用户代码前参数
Property BeforeUserCode As %Library.String [ SqlColumnNumber = 12, SqlFieldName = BeforeUserCode ];

/// 其他参数
Property BeforeOther As %Library.String [ SqlColumnNumber = 13, SqlFieldName = BeforeOther ];

/// 医院
Property HospID As CTHospital [ SqlColumnNumber = 14, SqlFieldName = HospID ];

Storage DHCDocAppLabReportSet
{
<SqlIdExpression>$i(^DHCDocAppLabReportSet(0))</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="ARCIMCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARCIMDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BeforeOther">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BeforeRegistNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BeforeReportNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BeforeReportNoSplit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BeforeUserCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HospID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ReportFullFile">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ToRegistNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ToReportNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ToUserCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDocAppLabReportSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>RowID</Expression>
<Field>{L1}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocAppLabReportSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
