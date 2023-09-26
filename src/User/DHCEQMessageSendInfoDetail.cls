Class User.DHCEQMessageSendInfoDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MSID_RowID, SqlTableName = DHC_EQMessageSendInfoDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MSID_MessageSendInfoDR
Property MSIDMessageSendInfoDR As User.DHCEQMessageSendInfo [ SqlColumnNumber = 2, SqlFieldName = MSID_MessageSendInfoDR ];

/// MSID_SendDate
Property MSIDSendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = MSID_SendDate ];

/// MSID_SendTime
Property MSIDSendTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = MSID_SendTime ];

/// MSID_Times
Property MSIDTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MSID_Times ];

/// MSID_Status
Property MSIDStatus As %Library.String(DISPLAYLIST = ",发送未返回,发送成功,发送失败", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 6, SqlFieldName = MSID_Status ];

/// MSID_Results
Property MSIDResults As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MSID_Results ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessageSendInfoDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MSID_MessageSendInfoDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MSID_Results">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MSID_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MSID_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MSID_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MSID_Times">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQMessageSendInfoDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MSID_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MSID_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMessageSendInfo">
<Global>^DHCEQMessageSendInfoDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MSID_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MessageSendInfo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MSID_MessageSendInfoDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MSID_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessageSendInfoDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
