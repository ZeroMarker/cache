Class User.PMPStatusButto Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SB_Rowid, SqlTableName = PMP_StatusButtont, StorageStrategy = SQLStorage ]
{

/// SB_Date
Property SBDate As %Date [ SqlColumnNumber = 2, SqlFieldName = SB_Date ];

/// SB _Time
Property SBTime As %Time [ SqlColumnNumber = 3, SqlFieldName = SB_Time ];

/// SB _User
Property SBUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SB_User ];

/// SB_Status
Property SBStatus As PMPDictionary3 [ SqlColumnNumber = 5, SqlFieldName = SB_Status ];

/// SB_Button
Property SBButton As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SB_Button ];

/// SB_Type
Property SBType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SB_Type ];

/// SB_By1
Property SBBy1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SB_By1 ];

/// SB_By2
Property SBBy2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SB_By2 ];

/// SB_By3
Property SBBy3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SB_By3 ];

/// SB_By4
Property SBBy4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SB_By4 ];

/// SB_By5
Property SBBy5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SB_By5 ];

/// SB_By6
Property SBBy6 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SB_By6 ];

/// SB_By7
Property SBBy7 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SB_By7 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPStatusButton(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="SB_Button">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SB_By1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SB_By2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SB_By3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SB_By4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SB_By5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SB_By6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SB_By7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SB_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SB_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SB_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SB_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SB_User">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PMPStatusButton</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SB _Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SB_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofSBButton">
<Global>^PMPStatusButtoni</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"SB_Button"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SB_Button}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSBStatus">
<Global>^PMPStatusButtoni</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"SB_Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SB_Status}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPStatusButtoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
