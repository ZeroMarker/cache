Class User.DHCEQCComponentZone Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CZ_RowID, SqlTableName = DHC_EQCComponentZone, StorageStrategy = SQLStorage ]
{

/// CZ_BussType
Property CZBussType As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CZ_BussType ];

/// CZ_Code
Property CZCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CZ_Code ];

/// CZ_Desc
Property CZDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CZ_Desc ];

/// CZ_Title
Property CZTitle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CZ_Title ];

/// CZ_TitleID
Property CZTitleID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CZ_TitleID ];

/// CZ_Sort
Property CZSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CZ_Sort ];

/// CZ_Style
Property CZStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CZ_Style ];

/// CZ_ReadOnly
Property CZReadOnly As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CZ_ReadOnly ];

/// CZ_InvalidFlag
Property CZInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = CZ_InvalidFlag ];

/// CZ_Hold1
Property MDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CZ_Hold1 ];

/// CZ_Hold2
Property MDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CZ_Hold2 ];

/// CZ_Hold3
Property MDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CZ_Hold3 ];

/// CZ_Hold4
Property MDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CZ_Hold4 ];

/// CZ_Hold5
Property MDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CZ_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCComponentZone",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CZ_BussType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CZ_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CZ_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CZ_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CZ_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CZ_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CZ_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CZ_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CZ_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CZ_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CZ_Sort">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CZ_Style">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CZ_Title">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CZ_TitleID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CZ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentZone"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{CZ_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComponentSet">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CZ_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCComponentZone"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CZ_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CZ_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCComponentZoneS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
