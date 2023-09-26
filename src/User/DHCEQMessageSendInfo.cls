Class User.DHCEQMessageSendInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MSI_RowID, SqlTableName = DHC_EQMessageSendInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MSI_ErrInfo
Property MSIErrInfo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MSI_ErrInfo ];

/// MSI_Hold1
Property MSIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MSI_Hold1 ];

/// MSI_Hold2
Property MSIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MSI_Hold2 ];

/// MSI_Hold3
Property MSIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MSI_Hold3 ];

/// MSI_MessagesDR
Property MSIMessagesDR As User.DHCEQMessages [ SqlColumnNumber = 3, SqlFieldName = MSI_MessagesDR ];

/// MSI_MessagesRecInfoDR
Property MSIMessagesRecInfoDR As User.DHCEQMessagesRecInfo [ SqlColumnNumber = 4, SqlFieldName = MSI_MessagesRecInfoDR ];

/// MSI_MessagesType
Property MSIMessagesType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MSI_MessagesType ];

/// MSI_MsgInfo
Property MSIMsgInfo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MSI_MsgInfo ];

/// MSI_ReceiveUser
Property MSIReceiveUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MSI_ReceiveUser ];

/// MSI_Remark
Property MSIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MSI_Remark ];

/// MSI_SendDate
Property MSISendDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = MSI_SendDate ];

/// MSI_SendTime
Property MSISendTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = MSI_SendTime ];

/// MSI_Status
Property MSIStatus As %Library.String(DISPLAYLIST = ",未发送,已发送,发送未成功,发送未返回,不需发送", MAXLEN = 5, SELECTIVITY = "16.6667%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4") [ SqlColumnNumber = 9, SqlFieldName = MSI_Status ];

/// MSI_Times
Property MSITimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MSI_Times ];

/// MSI_ToAddress
Property MSIToAddress As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MSI_ToAddress ];

/// MSI_RepeatFlag
Property MSIRepeatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = MSI_RepeatFlag ];

/// MSI_RepeatLength
Property MSIRepeatLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MSI_RepeatLength ];

/// MSI_MaxLength
Property MSIMaxLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MSI_MaxLength ];

/// MSI_CreateDate
Property MSICreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = MSI_CreateDate ];

/// MSI_CreateTime
Property MSICreateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = MSI_CreateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessageSendInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MSI_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MSI_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MSI_ErrInfo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MSI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MSI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MSI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MSI_MaxLength">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MSI_MessagesDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MSI_MessagesRecInfoDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MSI_MessagesType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MSI_MsgInfo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MSI_ReceiveUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MSI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MSI_RepeatFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MSI_RepeatLength">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MSI_SendDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MSI_SendTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MSI_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MSI_Times">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MSI_ToAddress">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQMessageSendInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MSI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQMessageSendInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MSI_MessagesType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MSI_MessagesDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MSI_ToAddress}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeStatus">
<Global>^DHCEQMessageSendInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MSI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MSI_MessagesType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MSI_Status}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MSI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessageSendInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
