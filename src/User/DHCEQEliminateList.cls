Class User.DHCEQEliminateList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EL_RowID, SqlTableName = DHC_EQEliminateList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EL_SourceType
Property ELSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EL_SourceType ];

/// EL_SourceID
Property ELSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EL_SourceID ];

/// EL_EquipDR
Property ELEquipDR As User.DHCEQEquip [ SqlColumnNumber = 4, SqlFieldName = EL_EquipDR ];

/// EL_PreWorkLoad
Property ELPreWorkLoad As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EL_PreWorkLoad ];

/// EL_PositiveRate
Property ELPositiveRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EL_PositiveRate ];

/// EL_Hold1
Property ELHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EL_Hold1 ];

/// EL_Hold2
Property ELHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EL_Hold2 ];

/// EL_Hold3
Property ELHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EL_Hold3 ];

/// EL_Hold4
Property ELHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EL_Hold4 ];

/// EL_Hold5
Property ELHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEliminateList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EL_PositiveRate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EL_PreWorkLoad">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQEliminateList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{EL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQEliminateList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEliminateListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
