Class User.DHCEQGather Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = G_RowID, SqlTableName = DHC_EQGather, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// G_StartDate
Property GStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = G_StartDate ];

/// G_EndDate
Property GEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = G_EndDate ];

/// G_Status
Property GStatus As %Library.String(DISPLAYLIST = ",新增,执行,异常,完成", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 4, SqlFieldName = G_Status ];

/// G_Type
Property GType As %Library.String(DISPLAYLIST = ",补采记录,正常任务记录", MAXLEN = 2, SELECTIVITY = "50.0000%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 5, SqlFieldName = G_Type ];

/// G_AddUserDR
Property GAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = G_AddUserDR ];

/// G_AddDate
Property GAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = G_AddDate ];

/// G_AddTime
Property FAddTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = G_AddTime ];

/// G_InvalidFlag
Property GInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = G_InvalidFlag ];

/// G_Hold1
Property GHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = G_Hold1 ];

/// G_Hold2
Property GHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = G_Hold2 ];

/// G_Hold3
Property GHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = G_Hold3 ];

/// G_Hold4
Property GHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = G_Hold4 ];

/// G_Hold5
Property GHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = G_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQGather("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="G_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="G_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="G_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="G_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="G_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="G_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="G_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="G_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="G_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="G_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="G_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="G_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="G_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQGather</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>G_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{G_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQGatherS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
