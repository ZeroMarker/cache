Class User.DHCEQCColumns Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = C_RowID, SqlTableName = DHC_EQCColumns, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// C_TableDR
Property CTableDR As User.DHCEQCTableData [ SqlColumnNumber = 2, SqlFieldName = C_TableDR ];

/// C_Name
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = C_Name ];

/// C_HiddenFlag
Property CHiddenFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = C_HiddenFlag ];

/// C_Caption
Property CCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = C_Caption ];

/// C_Location
Property CLocation As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = C_Location ];

/// C_Remark
Property CRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = C_Remark ];

/// C_Format
Property CFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = C_Format ];

/// C_Sort
Property CSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = C_Sort ];

/// C_Hold1
Property CHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = C_Hold1 ];

/// C_Hold2
Property CHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = C_Hold2 ];

/// C_Hold3
Property CHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = C_Hold3 ];

/// C_Hold4
Property CHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = C_Hold4 ];

/// C_Hold5
Property CHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = C_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCColumns",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="C_Caption">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="C_Format">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="C_HiddenFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="C_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="C_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="C_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="C_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="C_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="C_Location">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="C_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="C_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="C_Sort">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="C_TableDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCColumns"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSort">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCColumns"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Sort"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{C_TableDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{C_Sort}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTable">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCColumns"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Table"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{C_TableDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCColumnsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
