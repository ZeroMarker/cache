Class User.PMPDirectoryTree Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDT_Rowid, SqlTableName = PMP_DirectoryTree, StorageStrategy = SQLStorage ]
{

/// PDT_Type
Property PDTType As PMPDictionary3 [ SqlColumnNumber = 2, SqlFieldName = PDT_Type ];

/// PDT_Code
Property PDTCode As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PDT_Code ];

/// PDT_Descv
Property PDTDesc As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PDT_Desc ];

/// PDT_Leve
Property PDTLeve As PMPDictionary3 [ SqlColumnNumber = 5, SqlFieldName = PDT_Leve ];

/// PDT_FatherLeve
Property PDTFatherLeve As PMPDirectoryTree [ SqlColumnNumber = 6, SqlFieldName = PDT_FatherLeve ];

/// PDT_Standby1
Property PDTStandby1 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PDT_Standby1 ];

/// PDT_Standby2
Property PDTStandby2 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PDT_Standby2 ];

/// PDT_Standby3
Property PDTStandby3 As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PDT_Standby3 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPDirectoryTree("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PDT_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PDT_FatherLeve">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDT_Leve">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDT_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDT_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDT_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDT_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPDirectoryTree</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PDT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofCode">
<Global>^PMPDirectoryTreei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDT_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDT_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFatherLeve">
<Global>^PMPDirectoryTreei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FatherLeve"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDT_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDT_FatherLeve}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexofleve">
<Global>^PMPDirectoryTreei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LEVE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PDT_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDT_Leve}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPDirectoryTreeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
