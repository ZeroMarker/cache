Class User.DHCEQGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GR_RowID, SqlTableName = DHC_EQGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GR_Code
Property GRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GR_Code ];

/// GR_Name
Property GRName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GR_Name ];

/// GR_Desc
Property GRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GR_Desc ];

/// GR_Remark
Property GRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GR_Remark ];

/// GR_UpdateUserDR
Property GRUpdateUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = GR_UpdateUserDR ];

/// GR_UpdateDate
Property GRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = GR_UpdateDate ];

/// GR_UpdateTime
Property GRUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = GR_UpdateTime ];

/// GR_FromDate
Property GRFromDate As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = GR_FromDate ];

/// GR_ToDate
Property GRToDate As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = GR_ToDate ];

/// GR_InvalidFlag
Property GRInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = GR_InvalidFlag ];

/// GR_Hold1
Property GRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = GR_Hold1 ];

/// GR_Hold2
Property GRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = GR_Hold2 ];

/// GR_Hold3
Property GRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = GR_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQGroup("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GR_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GR_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GR_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQGroup</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
