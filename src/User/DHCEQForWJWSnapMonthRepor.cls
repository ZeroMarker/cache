Class User.DHCEQForWJWSnapMonthRepor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SMR_RowID, SqlTableName = DHC_EQForWJWSnapMonthReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SMR_EquipTypeDR
Property SMREquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 2, SqlFieldName = SMR_EquipTypeDR ];

/// SMR_CompCode
Property SMRCompCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SMR_CompCode ];

/// SMR_CopyCode
Property SMRCopyCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SMR_CopyCode ];

/// SMR_AcctYear
Property SMRAcctYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SMR_AcctYear ];

/// SMR_AcctMonth
Property SMRAcctMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SMR_AcctMonth ];

/// SMR_StoreCode
Property SMRStoreCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SMR_StoreCode ];

/// SMR_DeptCode
Property SMRDeptCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SMR_DeptCode ];

/// SMR_KindCode
Property SMRKindCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SMR_KindCode ];

/// SMR_KindType
Property SMRKindType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SMR_KindType ];

/// SMR_EquipCode
Property SMREquipCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SMR_EquipCode ];

/// SMR_AttCode
Property SMRAttCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SMR_AttCode ];

/// SMR_AttName
Property SMRAttName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SMR_AttName ];

/// SMR_BeginAmount
Property SMRBeginAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SMR_BeginAmount ];

/// SMR_BeginMoney
Property SMRBeginMoney As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SMR_BeginMoney ];

/// SMR_InAmount
Property SMRInAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SMR_InAmount ];

/// SMR_InMoney
Property SMRInMoney As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SMR_InMoney ];

/// SMR_OutAmount
Property SMROutAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = SMR_OutAmount ];

/// SMR_OutMoney
Property SMROutMoney As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = SMR_OutMoney ];

/// SMR_EndAmount
Property SMREndAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = SMR_EndAmount ];

/// SMR_EndMoney
Property SMREndMoney As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = SMR_EndMoney ];

/// SMR_DepreMoney
Property SMRDepreMoney As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = SMR_DepreMoney ];

/// SMR_AlreadyDepre
Property SMRAlreadyDepre As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = SMR_AlreadyDepre ];

/// SMR_Amount
Property SMRAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = SMR_Amount ];

/// SMR_Date
Property SMRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = SMR_Date ];

/// SMR_Time
Property SMRTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = SMR_Time ];

/// SMR_Hold1
Property SMRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = SMR_Hold1 ];

/// SMR_Hold2
Property SMRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = SMR_Hold2 ];

/// SMR_Hold3
Property SMRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = SMR_Hold3 ];

/// SMR_Hold4
Property SMRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = SMR_Hold4 ];

/// SMR_Hold5
Property SMRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = SMR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQForWJWSnapMonthReport("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SMR_AcctMonth">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SMR_AcctYear">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SMR_AlreadyDepre">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SMR_Amount">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SMR_AttCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SMR_AttName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SMR_BeginAmount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SMR_BeginMoney">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SMR_CompCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SMR_CopyCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SMR_Date">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SMR_DepreMoney">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SMR_DeptCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SMR_EndAmount">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SMR_EndMoney">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SMR_EquipCode">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SMR_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SMR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SMR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SMR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SMR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SMR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SMR_InAmount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SMR_InMoney">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SMR_KindCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SMR_KindType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SMR_OutAmount">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SMR_OutMoney">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SMR_StoreCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SMR_Time">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Global>^DHCEQForWJWSnapMonthReport</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SMR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexYearMonth">
<Global>^DHCEQForWJWSnapMonthReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"YearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SMR_AcctYear}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SMR_AcctMonth}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQForWJWS924S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
