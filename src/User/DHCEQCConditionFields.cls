Class User.DHCEQCConditionFields Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CF_RowID, SqlTableName = DHC_EQCConditionFields, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CF_Name
Property CFName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CF_Name ];

/// CF_TableName
Property CFTableName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CF_TableName ];

/// CF_Type
Property CFType As %Library.String(DISPLAYLIST = ",选择型,范围型", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 4, SqlFieldName = CF_Type ];

/// CF_Hold1
Property CFHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CF_Hold1 ];

/// CF_Hold2
Property CFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CF_Hold2 ];

/// CF_Hold3
Property CFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CF_Hold3 ];

/// CF_Hold4
Property CFHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CF_Hold4 ];

/// CF_Hold5
Property CFHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CF_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCConditionFields",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CF_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CF_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CF_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CF_TableName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CF_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCConditionFields"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="NameIndex">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCConditionFields"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CF_TableName})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({CF_Name})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCConditionFieldsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
