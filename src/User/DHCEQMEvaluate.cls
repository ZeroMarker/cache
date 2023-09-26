Class User.DHCEQMEvaluate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = E_RowID, SqlTableName = DHC_EQMEvaluate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// E_Content
Property EContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = E_Content ];

/// E_Date
Property EDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = E_Date ];

/// E_EvaluateTypeDR
Property EEvaluateTypeDR As User.DHCEQMCEvaluateType [ SqlColumnNumber = 4, SqlFieldName = E_EvaluateTypeDR ];

/// E_Remark
Property ERemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = E_Remark ];

/// E_Score
Property EScore As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = E_Score ];

/// E_SourceID
Property ESourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = E_SourceID ];

/// E_SourceType
Property ESourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = E_SourceType ];

/// E_Time
Property ETime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = E_Time ];

/// E_UserDR
Property EUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = E_UserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMEvaluate("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="E_Content">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="E_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="E_EvaluateTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="E_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="E_Score">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="E_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="E_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="E_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="E_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQMEvaluate</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{E_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQMEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{E_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQMEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>E_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{E_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{E_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{E_EvaluateTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{E_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMEvaluateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
