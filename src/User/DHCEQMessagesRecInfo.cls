Class User.DHCEQMessagesRecInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRI_RowID, SqlTableName = DHC_EQMessagesRecInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MRI_MessagesDR
Property MRIMessagesDR As User.DHCEQMessages [ SqlColumnNumber = 2, SqlFieldName = MRI_MessagesDR ];

/// MRI_ReceiveUserDR
Property MRIReceiveUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MRI_ReceiveUserDR ];

/// MRI_ContractInfo
Property MRIContractInfo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MRI_ContractInfo ];

/// MRI_Roles
Property MRIRoles As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MRI_Roles ];

/// MRI_Status
Property MRIStatus As %Library.String(DISPLAYLIST = ",未接收,已接收,删除", MAXLEN = 6, SELECTIVITY = "33.3333%", VALUELIST = ",0,1,2") [ Required, SqlColumnNumber = 6, SqlFieldName = MRI_Status ];

/// MRI_ReceiveDate
Property MRIReceiveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MRI_ReceiveDate ];

/// MRI_ReceiveTime
Property MRIReceiveTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MRI_ReceiveTime ];

/// MRI_DelDate
Property MRIDelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MRI_DelDate ];

/// MRI_DelTime
Property MRIDelTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MRI_DelTime ];

/// MRI_Hold1
Property MRIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MRI_Hold1 ];

/// MRI_Hold2
Property MRIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MRI_Hold2 ];

/// MRI_Hold3
Property MRIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MRI_Hold3 ];

/// MRI_DelayLength
Property MRIDelayLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MRI_DelayLength ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessagesRecInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MRI_ContractInfo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRI_DelDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRI_DelTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRI_DelayLength">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MRI_MessagesDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRI_ReceiveDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRI_ReceiveTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRI_ReceiveUserDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRI_Roles">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRI_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMessagesRecInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MRI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMessage">
<Global>^DHCEQMessagesRecInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Message"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRI_MessagesDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMessages">
<Global>^DHCEQMessagesRecInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"UserStatusMessages"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MRI_ReceiveUserDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MRI_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRI_MessagesDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessagesRecInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
