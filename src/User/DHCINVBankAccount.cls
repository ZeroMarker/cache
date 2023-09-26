Class User.DHCINVBankAccount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IBA_RowID, SqlTableName = DHC_INVBankAccount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IBA_TR_Type
Property IBATRType As %Library.String(COLLATION = "Exact", MAXLEN = 9, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IBA_TR_Type ];

/// IBA_Card_NO
Property IBACardNO As %Library.String(COLLATION = "Exact", MAXLEN = 238, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IBA_Card_NO ];

/// IBA_TR_Amt
Property IBATRAmt As %Library.String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IBA_TR_Amt ];

/// IBA_Batch_Num
Property IBABatchNum As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IBA_Batch_Num ];

/// IBA_Term_ID
Property IBATermID As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IBA_Term_ID ];

/// IBA_Mer_ID
Property IBAMerID As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IBA_Mer_ID ];

/// IBA_Term_Trace
Property IBATermTrace As %Library.String(COLLATION = "Exact", MAXLEN = 9, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IBA_Term_Trace ];

/// IBA_Bank_DealData
Property IBABankDealData As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IBA_Bank_DealData ];

/// IBA_AuthNum
Property IBAAuthNum As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IBA_AuthNum ];

/// IBA_TR_Date
Property IBATRDate As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IBA_TR_Date ];

/// IBA_TR_Time
Property IBATRTime As %Library.String(COLLATION = "Exact", MAXLEN = 9, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IBA_TR_Time ];

/// IBA_Org_Term
Property IBAOrgTerm As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IBA_Org_Term ];

/// IBA_Org_Batch_Num
Property IBAOrgBatchNum As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IBA_Org_Batch_Num ];

///  IBA_Org_Term_Trace
Property IBAOrgTermTrace As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IBA_Org_Term_Trace ];

/// IBA_Org_TR_Date
Property IBAOrgTRDate As %Library.String(COLLATION = "Exact", MAXLEN = 8, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IBA_Org_TR_Date ];

/// IBA_Card_Org
Property IBACardOrg As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IBA_Card_Org ];

/// IBA_Card_Type
Property IBACardType As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IBA_Card_Type ];

/// IBA_ISMIS
Property IBAISMIS As %Library.String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IBA_ISMIS ];

/// IBA_TranFee
Property IBATranFee As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = IBA_TranFee ];

/// IBA_SectionNum
Property IBASectionNum As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = IBA_SectionNum ];

/// IBA_FeeRatio
Property IBAFeeRatio As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = IBA_FeeRatio ];

/// IBA_Refer_Num
Property IBAReferNum As %Library.String(COLLATION = "Exact", MAXLEN = 23, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = IBA_Refer_Num ];

/// IBA_HIS_ID
Property IBAHISID As %Library.String(COLLATION = "Exact", MAXLEN = 21, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = IBA_HIS_ID ];

/// IBA_IBP_DR
Property IBAIBPDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = IBA_IBP_DR ];

/// IBA_Match_Flag
Property IBAMatchFlag As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = IBA_Match_Flag ];

/// IBA_MatchDate
Property IBAMatchDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = IBA_MatchDate ];

/// IBA_MatchTime
Property IBAMatchTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = IBA_MatchTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVBANkACOUNT)</SqlIdExpression>
<SQLMap name="IndexMDM">
<Global>^DHCINVBANkACOUNT</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MDMF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBA_MatchDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBA_Match_Flag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IBA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMatchDate">
<Global>^DHCINVBANkACOUNT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IBA_MatchDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IBA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="IBA_AuthNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IBA_Bank_DealData">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IBA_Batch_Num">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IBA_Card_NO">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IBA_Card_Org">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IBA_Card_Type">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IBA_FeeRatio">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IBA_HIS_ID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IBA_IBP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IBA_ISMIS">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IBA_MatchDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IBA_MatchTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IBA_Match_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IBA_Mer_ID">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IBA_Org_Batch_Num">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IBA_Org_TR_Date">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IBA_Org_Term">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IBA_Org_Term_Trace">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IBA_Refer_Num">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IBA_SectionNum">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IBA_TR_Amt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IBA_TR_Date">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IBA_TR_Time">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IBA_TR_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IBA_Term_ID">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IBA_Term_Trace">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IBA_TranFee">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^DHCINVBANkACOUNT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IBA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{IBA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVBankAccountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
