Class User.DHCEQPaymentNotice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PN_RowID, SqlTableName = DHC_EQPaymentNotice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PN_NoticeNo
Property PNNoticeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PN_NoticeNo ];

/// PN_MakeDate
Property PNMakeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PN_MakeDate ];

/// PN_LocDR
Property PNLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PN_LocDR ];

/// PN_ProviderDR
Property PNProviderDR As User.DHCEQCVendor [ SqlColumnNumber = 5, SqlFieldName = PN_ProviderDR ];

/// PN_Bank
Property PNBank As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PN_Bank ];

/// PN_BankAccount
Property PNBankAccount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PN_BankAccount ];

/// PN_AccountDate
Property PNAccountDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PN_AccountDate ];

/// PN_TotalFee
Property PNTotalFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PN_TotalFee ];

/// PN_PurposeType
Property PNPurposeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PN_PurposeType ];

/// PN_Type
Property PNType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PN_Type ];

/// PN_Agent
Property PNAgent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PN_Agent ];

/// PN_Status
Property PNStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 13, SqlFieldName = PN_Status ];

/// PN_Remark
Property PNRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PN_Remark ];

/// PN_UpdateUserDR
Property PNUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PN_UpdateUserDR ];

/// PN_UpdateDate
Property PNUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PN_UpdateDate ];

/// PN_UpdateTime
Property PNUpdateTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = PN_UpdateTime ];

/// PN_SubmitUserDR
Property PNSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PN_SubmitUserDR ];

/// PN_SubmitDate
Property PNSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = PN_SubmitDate ];

/// PN_SubmitTime
Property PNSubmitTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = PN_SubmitTime ];

/// PN_AuditUserDR
Property PNAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PN_AuditUserDR ];

/// PN_AuditDate
Property PNAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = PN_AuditDate ];

/// PN_AuditTime
Property PNAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = PN_AuditTime ];

/// PN_DisUseUserDR
Property PNDisUseUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PN_DisUseUserDR ];

/// PN_DisUseDate
Property PNDisUseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = PN_DisUseDate ];

/// PN_DisUseTime
Property PNDisUseTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = PN_DisUseTime ];

/// PN_InvalidFlag
Property PNInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PN_InvalidFlag ];

/// PN_Hold1
Property PNHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PN_Hold1 ];

/// PN_Hold2
Property PNHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PN_Hold2 ];

/// PN_Hold3
Property PNHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PN_Hold3 ];

/// PN_Hold4
Property PNHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PN_Hold4 ];

/// PN_Hold5
Property PNHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PN_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPaymentNotice("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PN_AccountDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PN_Agent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PN_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PN_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PN_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PN_Bank">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PN_BankAccount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PN_DisUseDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PN_DisUseTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PN_DisUseUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PN_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PN_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PN_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PN_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PN_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PN_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PN_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PN_MakeDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PN_NoticeNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PN_ProviderDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PN_PurposeType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PN_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PN_Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PN_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PN_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PN_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PN_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PN_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PN_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PN_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PN_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQPaymentNotice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PN_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQPaymentNotice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PN_LocDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNoticeNo">
<Global>^DHCEQPaymentNotice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NoticeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PN_NoticeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProvider">
<Global>^DHCEQPaymentNotice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Provider"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PN_ProviderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQPaymentNotice</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PN_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPaymentNoticeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
