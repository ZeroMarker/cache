Class User.DHCEQCApproveAction Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AA_RowID, SqlTableName = DHC_EQCApproveAction, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AA_Desc
Property AADesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = AA_Desc ];

/// AA_ClassName
Property AAClassName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AA_ClassName ];

/// AA_Method
Property AAMethod As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AA_Method ];

/// AA_Hold1
Property AAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AA_Hold1 ];

/// AA_Hole2
Property AAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AA_Hold2 ];

/// AA_Hold3
Property AAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AA_Hold3 ];

/// AA_Hold4
Property AAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AA_Hold4 ];

/// AA_Hold5
Property AAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCApproveAction",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AA_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AA_Method">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCApproveAction"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClassName">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveAction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ClassName"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AA_ClassName}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveAction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AA_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMethod">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCApproveAction"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Method"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AA_Method}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCApproveActionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
