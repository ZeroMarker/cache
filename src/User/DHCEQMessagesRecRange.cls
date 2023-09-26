Class User.DHCEQMessagesRecRange Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRR_RowID, SqlTableName = DHC_EQMessagesRecRange, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MRR_MessagesDR
Property MRRMessagesDR As User.DHCEQMessages [ SqlColumnNumber = 2, SqlFieldName = MRR_MessagesDR ];

/// MRR_FirstValue
Property MRRFirstValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MRR_FirstValue ];

/// MRR_SecondValue
Property MRRSecondValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MRR_SecondValue ];

/// MRR_Hold1
Property MRRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MRR_Hold1 ];

/// MRR_Hold2
Property MRRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MRR_Hold2 ];

/// MRR_Hold3
Property MRRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MRR_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessagesRecRange("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MRR_FirstValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRR_MessagesDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRR_SecondValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQMessagesRecRange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MRR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMessages">
<Global>^DHCEQMessagesRecRange</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Messages"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRR_MessagesDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessagesRecRangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
