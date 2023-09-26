Class User.DHCPay Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAY_Rowid, SqlTableName = DHC_Pay, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPayItm As User.DHCPayItm [ Cardinality = children, Inverse = PAYIPAYParref ];

/// PAY_No
Property PAYNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PAY_No ];

/// PAY_APCVM_DR
Property PAYAPCVMDR As User.APCVendor [ SqlColumnNumber = 3, SqlFieldName = PAY_APCVM_DR ];

/// PAY_CTLOC_DR
Property PAYCTLOCDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PAY_CTLOC_DR ];

/// PAY_Date
Property PAYDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PAY_Date ];

/// PAY_Time
Property PAYTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PAY_Time ];

/// PAY_SSUSR_DR
Property PAYSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PAY_SSUSR_DR ];

/// PAY_PayMode
Property PAYMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PAY_Mode ];

/// PAY_Ack1
Property PAYAck1 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PAY_Ack1 ];

/// PAY_Ack2
Property PAYAck2 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PAY_Ack2 ];

/// PAY_CheckNo
Property PAYCheckNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PAY_CheckNo ];

/// PAY_CheckDate
Property PAYCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PAY_CheckDate ];

/// PAY_CheckAmt
Property PAYCheckAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PAY_CheckAmt ];

/// PAY_Date_Ack1
Property PAYDateAck1 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PAY_Date_Ack1 ];

/// PAY_Date_Ack2
Property PAYDateAck2 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = PAY_Date_Ack2 ];

/// PAY_SSUSR_Ack1
Property PAYSSUSRAck1 As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PAY_SSUSR_Ack1 ];

/// PAY_SSUSR_Ack2
Property PAYSSUSRAck2 As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = PAY_SSUSR_Ack2 ];

/// PAY_DateExpected
Property PAYDateExpected As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = PAY_DateExpected ];

/// PAY_PoisonFlag
Property PAYPoisonFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PAY_PoisonFlag ];

/// PAY_Completed
Property PAYCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = PAY_Completed ];

/// PAY_CertifiedNo(付款凭证号)
Property PAYCertifiedNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PAY_CertifiedNo ];

/// PAY_Remarks
Property PAYRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PAY_Remarks ];

/// PAY_Ack11
Property PAYAck11 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = PAY_Ack11 ];

/// PAY_Date_Ack11
Property PAYDateAck11 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = PAY_Date_Ack11 ];

/// PAY_SSUSR_Ack11
Property PAYSSUSRAck11 As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = PAY_SSUSR_Ack11 ];

/// PAY_Preferred(优先付款标志)
Property PAYPreferred As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = PAY_Preferred ];

/// PAY_Purpose(付款用途)
Property PAYPurpose As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PAY_Purpose ];

/// PAY_CompletedDate
Property PAYCompletedDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = PAY_CompletedDate ];

/// PAY_CompletedTime
Property PAYCompletedTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = PAY_CompletedTime ];

/// 银行
Property PAYBank As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PAY_Bank ];

/// 银行账号
Property PAYBankAccount As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PAY_BankAccount ];

/// PAY_Ack12
Property PAYAck12 As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = PAY_Ack12 ];

/// PAY_Date_Ack12
Property PAYDateAck12 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 33, SqlFieldName = PAY_Date_Ack12 ];

/// PAY_SSUSR_Ack12
Property PAYSSUSRAck12 As User.SSUser [ SqlColumnNumber = 34, SqlFieldName = PAY_SSUSR_Ack12 ];

/// 入账月份
Property PAYPaymentMonth As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PAY_PaymentMonth ];

/// PAY_Time1 采购确认时间
Property PAYTime1 As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = PAY_Time1 ];

/// PAY_Time2 会计确认时间
Property PAYTime2 As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = PAY_Time2 ];

/// PAY_Time11 财务确认时间
Property PAYTime11 As %Library.Time [ SqlColumnNumber = 38, SqlFieldName = PAY_Time11 ];

/// PAY_Time12
Property PAYTime12 As %Library.Time [ SqlColumnNumber = 39, SqlFieldName = PAY_Time12 ];

/// PAYCompletedUserDr
Property PAYCompletedUserDr As User.SSUser [ SqlColumnNumber = 40, SqlFieldName = PAY_CompletedUser_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPAY)</SqlIdExpression>
<SQLMap name="DataMasterPayrec">
<Data name="PAY_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAY_Ack1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAY_Ack11">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PAY_Ack12">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PAY_Ack2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAY_Bank">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PAY_BankAccount">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PAY_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAY_CertifiedNo">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PAY_CheckAmt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAY_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAY_CheckNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAY_Completed">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PAY_CompletedDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PAY_CompletedTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PAY_CompletedUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PAY_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAY_DateExpected">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PAY_Date_Ack1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAY_Date_Ack11">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PAY_Date_Ack12">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PAY_Date_Ack2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAY_Mode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAY_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAY_PaymentMonth">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PAY_PoisonFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PAY_Preferred">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PAY_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PAY_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PAY_SSUSR_Ack1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PAY_SSUSR_Ack11">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PAY_SSUSR_Ack12">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PAY_SSUSR_Ack2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PAY_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAY_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAY_Time1">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PAY_Time11">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PAY_Time12">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PAY_Time2">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Global>^DHCPAY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAck1Date">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ACK1DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>+{PAY_Date_Ack1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PAY_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAck2Date">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ACK2DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAY_Date_Ack2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAY_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAY_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLocVendor">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLocVen"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAY_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PAY_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PAY_APCVM_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAY_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PAY_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^DHCPAY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"VEN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PAY_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPAY)
	s oldI = +$g(^mdata("DHCPAY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPAY = maxI
	s ^mdata("DHCPAY") = maxI
}

}
