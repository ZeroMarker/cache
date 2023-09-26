Class User.DHCEQRefuseRecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RR_RowID, SqlTableName = DHC_EQRefuseRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RR_FlowStep
Property RRFlowStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RR_FlowStep ];

/// RR_Hold1
Property RRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RR_Hold1 ];

/// RR_Hold2
Property RRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RR_Hold2 ];

/// RR_Hold3
Property RRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RR_Hold3 ];

/// RR_RefuseDate
Property RRRefuseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = RR_RefuseDate ];

/// RR_RefuseReason
Property RRRefuseReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RR_RefuseReason ];

/// RR_RefuseTime
Property RRRefuseTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = RR_RefuseTime ];

/// RR_RefuseUserDR
Property RRRefuseUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RR_RefuseUserDR ];

/// RR_Remark
Property RRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RR_Remark ];

/// RR_RoleDR
Property RRRoleDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RR_RoleDR ];

/// RR_SourceID
Property RRSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RR_SourceID ];

/// RR_SourceType
Property RRSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RR_SourceType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQRefuseRecord("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RR_FlowStep">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RR_RefuseDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RR_RefuseReason">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RR_RefuseTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RR_RefuseUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RR_RoleDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RR_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RR_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQRefuseRecord</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQRefuseRecord</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RR_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RR_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQRefuseRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
