/// Nurse Blood Queue
Class User.DHCBloodQueue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCBQ_RowId, SqlTableName = DHC_BloodQueue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Queue Number
Property DHCBQQueueNo As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DHCBQ_QueueNo ];

/// Patient Adm No 
Property DHCBQPatAdmId As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DHCBQ_PatAdmId ];

/// Patient Register No
Property DHCBQPatRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCBQ_PatRegNo ];

/// Patient Name
Property DHCBQPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCBQ_PatName ];

/// Patient Card No
Property DHCBQPatCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCBQ_PatCardNo ];

/// Patient Ctloc RowId
Property DHCBQPatCtlocDr As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DHCBQ_PatCtlocDr ];

/// Patient Ctloc Desc
Property DHCBQPatCtlocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCBQ_PatCtlocDesc ];

/// Patient Get Number
Property DHCBQPatGetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCBQ_PatGetDate ];

/// Patient Get Number Time
Property DHCBQPatGetTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCBQ_PatGetTime ];

/// Patient State
Property DHCBQPatState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCBQ_PatState ];

/// Computer Ip
Property DHCBQCTPCPComputerIp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCBQ_CTPCPComputerIp ];

/// Computer Name
Property DHCBQCTPCPComputerName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCBQ_CTPCPComputerName ];

/// Nurse Code
Property DHCBQCTPCPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCBQ_CTPCPCode ];

/// Nurse RowId
Property DHCBQCTPCPDr As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DHCBQ_CTPCPDr ];

/// Nurse Name
Property DHCBQCTPCPName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCBQ_CTPCPName ];

/// Nurse CtLoc RowID
Property DHCBQCTPCPCtLocDr As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = DHCBQ_CTPCPCtLocDr ];

/// Nurse CtLoc Desc
Property DHCBQCTPCPCtLocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCBQ_CTPCPCtLocDesc ];

/// Nurse Call Date
Property DHCBQCallDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DHCBQ_CallDate ];

/// Nurse Call Time
Property DHCBQCallTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DHCBQ_CallTime ];

/// VIP Patient
Property DHCBQVIPPat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DHCBQ_VIPPat ];

/// Get Number Location ID
Property DHCBQLocation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DHCBQ_Location ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBQ)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCBQ_CTPCPCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCBQ_CTPCPComputerIp">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCBQ_CTPCPComputerName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCBQ_CTPCPCtLocDesc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCBQ_CTPCPCtLocDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCBQ_CTPCPDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCBQ_CTPCPName">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCBQ_CallDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCBQ_CallTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCBQ_Location">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCBQ_PatAdmId">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCBQ_PatCardNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCBQ_PatCtlocDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCBQ_PatCtlocDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCBQ_PatGetDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCBQ_PatGetTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCBQ_PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCBQ_PatRegNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCBQ_PatState">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCBQ_QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCBQ_VIPPat">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCBQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCBQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLocRegNoState">
<Global>^DHCBQ</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateLocRegNoState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBQ_PatGetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBQ_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCBQ_PatRegNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCBQ_PatState}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateNurStateVIP">
<Global>^DHCBQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DHCBQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateNurStVIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBQ_PatGetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBQ_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCBQ_CTPCPDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCBQ_PatState}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCBQ_VIPPat}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGetDate">
<Global>^DHCBQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCBQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GetDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBQ_PatGetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBQ_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGetDateNurseState">
<Global>^DHCBQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHCBQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateNurseState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBQ_PatGetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBQ_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCBQ_CTPCPDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCBQ_PatState}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGetDatePatState">
<Global>^DHCBQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCBQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GetDateState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBQ_PatGetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBQ_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCBQ_PatState}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGetDateVIPState">
<Global>^DHCBQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>DHCBQ_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GetDateVIPState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCBQ_PatGetDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCBQ_Location}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCBQ_VIPPat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCBQ_PatState}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCBQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBloodQueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
