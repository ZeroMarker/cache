Class User.DHCINVPRTZY Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRT_Rowid, SqlTableName = DHC_INVPRTZY, StorageStrategy = SQLStorage ]
{

Relationship ChildINVPRTZYPayMode As User.DHCINVPRTZYPayMode [ Cardinality = children, Inverse = IPMPRTParRef ];

/// PRT_inv
Property PRTinv As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PRT_inv ];

/// PRT_Date
Property PRTDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 3, SqlFieldName = PRT_Date ];

/// PRT_Time
Property PRTTime As %Library.Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 4, SqlFieldName = PRT_Time ];

/// PRT_Adm
Property PRTAdm As User.PAAdm [ SqlColumnNumber = 5, SqlFieldName = PRT_Adm ];

/// PRT_ARPBL
Property PRTARPBL As User.DHCPatientBill [ SqlColumnNumber = 7, SqlFieldName = PRT_ARPBL ];

/// PRT_Acount
Property PRTAcount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PRT_Acount ];

/// PRT_Usr
Property PRTUsr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PRT_Usr ];

/// PRT_Flag
Property PRTFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Normal,Abort,Strike,Interm", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,I") [ SqlColumnNumber = 10, SqlFieldName = PRT_Flag ];

/// PRT_PatType
Property PRTPatType As User.PACAdmReason [ SqlColumnNumber = 11, SqlFieldName = PRT_PatType ];

/// PRT_Approval
Property PRTApproval As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PRT_Approval ];

/// PRT_AproUser
Property PRTAproUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PRT_AproUser ];

/// PRT_Aprodate
Property PRTAprodate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PRT_Aprodate ];

/// PRT_initInv
Property PRTinitInv As User.DHCINVPRTZY [ SqlColumnNumber = 15, SqlFieldName = PRT_initInv ];

/// PRT_Handin
Property PRTHandin As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 16, SqlFieldName = PRT_Handin ];

/// PRT_HandDate
Property PRTHandDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = PRT_HandDate ];

/// PRT_HandTime
Property PRTHandTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = PRT_HandTime ];

/// PRT_PAPMI_DR
Property PRTPAPMIDR As User.PAPatMas [ SqlColumnNumber = 19, SqlFieldName = PRT_PAPMI_DR ];

/// PRT_BizFlag(Pass NO: 过号重打, Arrears Back: 欠费补回)
Property PRTBizFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Pass NO,Arrears Back", TRUNCATE = 1, VALUELIST = ",PN,AB") [ SqlColumnNumber = 20, SqlFieldName = PRT_BizFlag ];

/// PRT_ARRCP_DR
Property PRTARRCPDR As User.ARReceipts [ SqlColumnNumber = 21, SqlFieldName = PRT_ARRCP_DR ];

/// PRT_SPInv_DR 集中打印发票表指针
Property PRTSPInvDR As BILL.IP.SummaryPrtInv [ SqlColumnNumber = 23, SqlFieldName = PRT_SPInv_DR ];

/// PRT_OldINV_DR
Property PRTOldINVDR As User.DHCINVPRTZY [ SqlColumnNumber = 24, SqlFieldName = PRT_OldINV_DR ];

/// PRT_Deposit
Property PRTDeposit As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = PRT_Deposit ];

/// PRT_JK_DR
Property PRTJKDR As User.DHCJFUSERJK [ SqlColumnNumber = 26, SqlFieldName = PRT_JK_DR ];

/// PRT_MultiInvFlag
Property PRTMultiInvFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PRT_MultiInvFlag ];

/// PRT_TransferFlag
Property PRTTransferFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PRT_TransferFlag ];

/// PRT_INVPrintFlag 打印标识
Property PRTINVPrintFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",NoPrint,Printed", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,P") [ SqlColumnNumber = 29, SqlFieldName = PRT_INVPrintFlag ];

/// PRT_CancelChgReason_DR ZhYW 2022-06-23 取消结算原因
Property PRTCancelChgReasonDR As CF.BILL.IP.CancelChgReason [ SqlColumnNumber = 30, SqlFieldName = PRT_CancelChgReason_DR ];

/// PRT_DiscretOutstAmt
Property PRTDiscretOutstAmt As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = PRT_DiscretOutstAmt ];

/// PRT_DateFrom
Property PRTDateFrom As %Library.Date [ SqlColumnNumber = 32, SqlFieldName = PRT_DateFrom ];

/// PRT_DateTo
Property PRTDateTo As %Library.Date [ SqlColumnNumber = 33, SqlFieldName = PRT_DateTo ];

/// PRT_AbortDate
Property PRTAbortDate As %Library.Date [ SqlColumnNumber = 34, SqlFieldName = PRT_AbortDate ];

/// PRT_AbortTime
Property PRTAbortTime As %Library.Time [ SqlColumnNumber = 35, SqlFieldName = PRT_AbortTime ];

/// PRT_BusinessNo
Property PRTBusinessNo As %Library.String [ SqlColumnNumber = 36, SqlFieldName = PRT_BusinessNo ];

/// PRT_InsDiv_DR
Property PRTInsDivDR As User.INSUDivide [ SqlColumnNumber = 37, SqlFieldName = PRT_InsDiv_DR ];

/// PRT_Hospital_DR
Property PRTHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 38, SqlFieldName = PRT_Hospital_DR ];

/// PRT_VATInvoiceNo 增值税发票号
Property PRTVATInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = PRT_VATInvoiceNo ];

/// PRT_IPAddress
Property PRTIPAddress As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 40, SqlFieldName = PRT_IPAddress ];

/// PRT_RealUser_DR 实际操作员
Property PRTRealUserDR As User.SSUser [ SqlColumnNumber = 41, SqlFieldName = PRT_RealUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVPRTZY)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRT_ARPBL">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRT_ARRCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PRT_AbortDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PRT_AbortTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PRT_Acount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRT_Adm">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRT_Approval">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRT_AproUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PRT_Aprodate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PRT_BizFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PRT_BusinessNo">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PRT_CancelChgReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PRT_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PRT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PRT_Deposit">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PRT_DiscretOutstAmt">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PRT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRT_HandDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PRT_HandTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PRT_Handin">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PRT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PRT_INVPrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PRT_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PRT_InsDiv_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PRT_JK_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PRT_MultiInvFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PRT_OldINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PRT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PRT_PatType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRT_RealUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PRT_SPInv_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PRT_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRT_TransferFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PRT_Usr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRT_VATInvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PRT_initInv">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PRT_inv">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINVPRTZY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexADM">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Adm}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARPBL">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_ARPBL}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDATE">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDATEUSER">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATEUSER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Usr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandDate">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HANDDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_HandDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHandin">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HandIn"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Handin}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Usr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINV">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_inv}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInitInv">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InitInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_initInv}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatType">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PATTYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_PatType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Usr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDisretOutstType">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DISTYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_CancelChgReason_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexJK">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"JK"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_JK_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexVATINV">
<Global>^DHCINVPRTZY</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VATInv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_VATInvoiceNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTZYS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
