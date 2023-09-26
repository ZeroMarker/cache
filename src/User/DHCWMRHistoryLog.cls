Class User.DHCWMRHistoryLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, SqlTableName = DHC_WMR_HistoryLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MedicalRecordMainID
Property MRMainID As User.DHCWMRMain [ SqlColumnNumber = 2 ];

/// ModifyUser
Property ModifyUser As User.SSUser [ SqlColumnNumber = 3 ];

/// ModifyDate
Property ModifyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4 ];

/// ModifyTime
Property ModifyTime As %Library.Time [ SqlColumnNumber = 5 ];

/// ModifyContent
Property ModifyContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWMRHistoryLog)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MRMainID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ModifyContent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ModifyDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ModifyTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ModifyUser">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWMRHistoryLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMrMainID">
<Global>^DHCWMRHistoryLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MrMainID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRMainID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRHistoryLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
