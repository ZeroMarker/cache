Class User.DHCAccPayINV Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = API_RowID, SqlTableName = DHC_AccPayINV, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAccPayINVMode As User.DHCAccPayINVMode [ Cardinality = children, Inverse = APMAPIParRef ];

/// API_Amount
Property APIAmount As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = API_Amount ];

/// API_Flag
Property APIFlag As %Library.String(DISPLAYLIST = ",Normal,Abort,Strike", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S") [ SqlColumnNumber = 3, SqlFieldName = API_Flag ];

/// API_Date
Property APIDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = API_Date ];

/// API_Time
Property APITime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = API_Time ];

/// API_PUser_DR
Property APIPUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = API_PUser_DR ];

/// API_INVNo
Property APIINVNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = API_INVNo ];

/// API_CheckDate
Property APICheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = API_CheckDate ];

/// API_CheckTime
Property APICheckTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = API_CheckTime ];

/// API_CheckUser_DR
Property APICheckUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = API_CheckUser_DR ];

/// API_PayINV_DR
Property APIPayINVDR As User.DHCAccPayINV [ SqlColumnNumber = 11, SqlFieldName = API_PayINV_DR ];

/// API_PAPMI_DR
Property APIPAPMIDR As User.PAPatMas [ SqlColumnNumber = 12, SqlFieldName = API_PAPMI_DR ];

/// API_AccMan_DR
Property APIAccManDR As User.DHCAccManager [ SqlColumnNumber = 13, SqlFieldName = API_AccMan_DR ];

/// API_PatientShare
Property APIPatientShare As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = API_PatientShare ];

/// API_DiscAmount
Property APIDiscAmount As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = API_DiscAmount ];

/// API_PayorShare
Property APIPayorShare As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = API_PayorShare ];

/// API_SelfPatPay CardPay
Property APISelfPatPay As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = API_SelfPatPay ];

/// API_SelfYBPay
Property APISelfYBPay As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = API_SelfYBPay ];

/// API_RefundSum
Property APIRefundSum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = API_RefundSum ];

/// API_InsDiv_DR
Property APIInsDivDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = API_InsDiv_DR ];

/// API_INVRep_DR
Property APIINVRepDR As User.DHCINVPRTReports [ SqlColumnNumber = 21, SqlFieldName = API_INVRep_DR ];

/// API_CashPay
Property APICashPay As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = API_CashPay ];

/// API_OldAPINV_DR
Property APIOldAPINVDR As User.DHCAccPayINV [ SqlColumnNumber = 23, SqlFieldName = API_OldAPINV_DR ];

/// API_Sum
Property APIOPCRoundSum As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = API_OPCRoundSum ];

/// API_AccFI_DR
Property APIAccFIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = API_AccFI_DR ];

/// API_AutoYBFlag
Property APIAutoYBFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = API_AutoYBFlag ];

/// API_IPAddress
Property APIIPAddress As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 27, SqlFieldName = API_IPAddress ];

/// API_Note8
Property APINote8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = API_Note8 ];

/// API_Note9
Property APINote9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = API_Note9 ];

/// API_Hospital_DR 
Property APIHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 30, SqlFieldName = API_Hospital_DR ];

/// API_StayFlag 急诊留观标识
Property APIStayFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = API_StayFlag ];

/// API_OldAPINV_DR
Property APIInsTypeDR As User.PACAdmReason [ SqlColumnNumber = 32, SqlFieldName = API_InsType_DR ];

/// API_Group_DR
Property APIGroupDR As User.SSGroup [ SqlColumnNumber = 33, SqlFieldName = API_Group_DR ];

/// API_Handin
Property APIHandin As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = API_Handin ];

/// API_VATInvoiceNo 增值税发票号
Property APIVATInvoiceNo As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = API_VATInvoiceNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVPRTAP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="API_AccFI_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="API_AccMan_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="API_Amount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="API_AutoYBFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="API_CashPay">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="API_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="API_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="API_CheckUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="API_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="API_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="API_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="API_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="API_Handin">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="API_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="API_INVNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="API_INVRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="API_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="API_InsDiv_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="API_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="API_Note8">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="API_Note9">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="API_OPCRoundSum">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="API_OldAPINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="API_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="API_PUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="API_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="API_PayINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="API_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="API_RefundSum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="API_SelfPatPay">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="API_SelfYBPay">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="API_StayFlag">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="API_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="API_VATInvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Global>^DHCINVPRTAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAPIAccMan">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"APIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_AccMan_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAPIInsDivDR">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InsDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_InsDiv_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAPIOldAPINVDR">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OldADR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_OldAPINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAPIPUserDR">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UseDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_PUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAPIPayINVDR">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"APIDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_PayINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCheckDate">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CheckDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_CheckDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVNo">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INVNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_INVNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINVRep">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INVRep"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{API_INVRep_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{API_InsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{API_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{API_PUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{API_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexHandin">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{API_Handin}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{API_PUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexVATInv">
<Global>^DHCINVPRTAPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VATInvNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{API_VATInvoiceNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{API_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPayINVS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
