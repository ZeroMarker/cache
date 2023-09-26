Class User.DHCEQCComponentParas Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCComponentParas, StorageStrategy = SQLStorage ]
{

/// CP_ComponentDR
Property CPComponentDR As User.DHCEQCComponent [ SqlColumnNumber = 2, SqlFieldName = CP_ComponentDR ];

/// CP_Code
Property CPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CP_Code ];

/// CP_Position
Property CPPosition As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CP_Position ];

/// CP_ValueType
Property CPValueType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CP_ValueType ];

/// CP_Value
Property CPValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CP_Value ];

/// CP_Hold1
Property CPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CP_Hold1 ];

/// CP_Hold2
Property CPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CP_Hold2 ];

/// CP_Hold3
Property CPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CP_Hold3 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCComponentParas",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CP_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CP_ComponentDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CP_Position">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CP_Value">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CP_ValueType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentParas"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComponent">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentParas"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ComponentDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CP_ComponentDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCComponentParasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
