Class User.DHCEQEvaluateList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EL_RowID, SqlTableName = DHC_EQEvaluateList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EL_EvaluateDR
Property ELEvaluateDR As User.DHCEQEvaluate [ SqlColumnNumber = 2, SqlFieldName = EL_EvaluateDR ];

/// EL_EvaluateTypeDR
Property ELEvaluateTypeDR As User.DHCEQCEvaluateType [ SqlColumnNumber = 3, SqlFieldName = EL_EvaluateTypeDR ];

/// EL_Score
Property ELScore As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EL_Score ];

/// EL_Content
Property ELContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EL_Content ];

/// EL_EvaluateGroupDR
Property ELEvaluateGroupDR As User.DHCEQCEvaluateGroup [ SqlColumnNumber = 6, SqlFieldName = EL_EvaluateGroupDR ];

/// EL_Hold1
Property ELHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EL_Hold1 ];

/// EL_Hold2
Property ELHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EL_Hold2 ];

/// EL_Hold3
Property ELHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EL_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEvaluateList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EL_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EL_EvaluateDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EL_EvaluateGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EL_EvaluateTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Data name="EL_Score">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQEvaluateList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEvaluate">
<Global>^DHCEQEvaluateList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Evaluate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EL_EvaluateDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEvaluateGroup">
<Global>^DHCEQEvaluateList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EvaluateGroup"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{EL_EvaluateGroupDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEvaluateListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
