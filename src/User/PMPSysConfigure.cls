Class User.PMPSysConfigure Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SC_Rowid, SqlTableName = PMP_SysConfigure, StorageStrategy = SQLStorage ]
{

/// SCType
Property SCType As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SC_Type ];

/// SCMenu
Property SCMenu As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SC_Menu ];

/// SCText
Property SCText As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SC_Text ];

/// SCStdate
Property SCStdate As %Date [ SqlColumnNumber = 5, SqlFieldName = SC_Stdate ];

/// SCEndate
Property SCEndate As %Date [ SqlColumnNumber = 6, SqlFieldName = SC_Endate ];

/// SCby1
Property SCby1 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SC_by1 ];

/// SCby2
Property SCby2 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SC_by2 ];

/// SCby3
Property SCby3 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SC_by3 ];

/// SCby4
Property SCby4 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SC_by4 ];

/// SCby5
Property SCby5 As %String(COLLATION = "Exact", MAXLEN = 1024, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SC_by5 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PMPSysConfigure(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="SC_Endate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SC_Menu">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SC_Stdate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SC_Text">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SC_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SC_by1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SC_by2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SC_by3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SC_by4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SC_by5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PMPSysConfigure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SC_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPSysConfigure</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SC_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SC_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPSysConfigureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
