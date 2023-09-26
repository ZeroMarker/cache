Class User.DHCEQCCodeTable Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CT_RowID, SqlTableName = DHC_EQCCodeTable, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index CTTableNameUnqIdx1 On CTTableName [ Unique ];

/// CT_Hidden
Property CTHidden As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CT_Hidden ];

/// CT_PreFix
Property CTPreFix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CT_PreFix ];

/// CT_ReadOnly
Property CTReadOnly As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CT_ReadOnly ];

/// CT_Remark
Property CTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CT_Remark ];

/// CT_TableDesc
Property CTTableDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CT_TableDesc ];

/// CT_TableName
Property CTTableName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CT_TableName ];

/// CT_Type
Property CTType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CT_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCodeTable("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CT_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CT_PreFix">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CT_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CT_TableDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CT_TableName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCodeTable</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTableName">
<Global>^DHCEQCCodeTable</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TableName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_TableName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQCCodeTable</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CT_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCCodeTableS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
