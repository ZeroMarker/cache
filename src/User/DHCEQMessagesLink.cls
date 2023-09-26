Class User.DHCEQMessagesLink Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ML_RowID, SqlTableName = DHC_EQMessagesLink, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ML_MessageDR
Property MLMessageDR As User.DHCEQMessages [ SqlColumnNumber = 2, SqlFieldName = ML_MessageDR ];

/// ML_LinkID
Property MLLinkID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ML_LinkID ];

/// ML_BussInfoDR
Property MLBussInfoDR As User.DHCEQCMessagesResult [ SqlColumnNumber = 4, SqlFieldName = ML_BussInfoDR ];

/// ML_Remark
Property MLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ML_Remark ];

/// ML_Hold1
Property MLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ML_Hold1 ];

/// ML_Hold2
Property MLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ML_Hold2 ];

/// ML_Hold3
Property MLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ML_Hold3 ];

/// ML_Hold4
Property MLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ML_Hold4 ];

/// ML_Hold5
Property MLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ML_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessagesLink("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ML_BussInfoDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ML_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ML_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ML_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ML_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ML_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ML_LinkID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ML_MessageDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ML_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQMessagesLink</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ML_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMessage">
<Global>^DHCEQMessagesLink</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Message"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ML_MessageDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessagesLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
