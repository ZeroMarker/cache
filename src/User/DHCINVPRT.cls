Class User.DHCINVPRT Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRT_Rowid, SqlTableName = DHC_INVPRT, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCINVOEItemAuthorize As User.DHCINVOEItemAuthorize [ Cardinality = children, Inverse = PRTIOAParRef ];

Relationship ChildDHCINVPayMode As User.DHCINVPayMode [ Cardinality = children, Inverse = IPMPRTParRef ];

/// PRT_Acount
Property PRTAcount As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PRT_Acount ];

/// PRT_ARRCP_DR
Property PRTARRCPDR As User.ARReceipts [ SqlColumnNumber = 3, SqlFieldName = PRT_ARRCP_DR ];

/// PRT_Date
Property PRTDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PRT_Date ];

/// PRT_DHCINVPRTR_DR
Property PRTDHCINVPRTRDR As User.DHCINVPRTReports [ SqlColumnNumber = 5, SqlFieldName = PRT_DHCINVPRTR_DR ];

/// PRT_Flag
Property PRTFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Normal,Abort,Strike,ToPaid", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S,TP") [ SqlColumnNumber = 6, SqlFieldName = PRT_Flag ];

/// PRT_Handin
Property PRTHandin As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 7, SqlFieldName = PRT_Handin ];

/// PRT_HandinDate
Property PRTHandinDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PRT_HandinDate ];

/// PRT_HandinTime
Property PRTHandinTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PRT_HandinTime ];

/// PRT_initInv_DR
Property PRTinitInvDR As User.DHCINVPRT [ SqlColumnNumber = 10, SqlFieldName = PRT_initInv_DR ];

/// PRT_inv
Property PRTinv As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PRT_inv ];

/// PRT_PAPMI_DR
Property PRTPAPMIDR As User.PAPatMas [ SqlColumnNumber = 12, SqlFieldName = PRT_PAPMI_DR ];

/// PRT_UseINVType
Property PRTUseINVType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PRT_UseINVType ];

/// PRT_Time
Property PRTTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = PRT_Time ];

/// PRT_Usr
Property PRTUsr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = PRT_Usr ];

/// PRT_SocialStatus
Property PRTSocialStatus As User.CTSocialStatus [ SqlColumnNumber = 16, SqlFieldName = PRT_SocialStatus ];

/// PRT_INVPrintFlag
Property PRTINVPrintFlag As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",NoPrint,Printed", MAXLEN = 7, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",N,P") [ SqlColumnNumber = 17, SqlFieldName = PRT_INVPrintFlag ];

/// PRT_ACCPINV_DR
Property PRTACCPINVDR As User.DHCAccPayINV [ SqlColumnNumber = 18, SqlFieldName = PRT_ACCPINV_DR ];

/// PRT_PayorShare
Property PRTPayorShare As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PRT_PayorShare ];

/// PRT_DiscAmount
Property PRTDiscAmount As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = PRT_DiscAmount ];

/// PRT_PatientShare
Property PRTPatientShare As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = PRT_PatientShare ];

/// PRT_InsType_DR
Property PRTInsTypeDR As User.PACAdmReason [ SqlColumnNumber = 22, SqlFieldName = PRT_InsType_DR ];

/// PRT_AllowRefund 1:退费申请，2:强制退费审核(2022-03-24 ZhYW)
Property PRTAllowRefund As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 23, SqlFieldName = PRT_AllowRefund ];

/// PRT_AllRefundUser
Property PRTAllRefundUser As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = PRT_AllRefundUser ];

/// PRT_AllRefundDate
Property PRTAllRefundDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = PRT_AllRefundDate ];

/// PRT_AllRefundTime
Property PRTAllRefundTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = PRT_AllRefundTime ];

/// PRT_PFinRep_DR
Property PRTPFinRepDR As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PRT_PFinRep_DR ];

/// PRT_SfootTime
Property PRTSfootTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = PRT_SfootTime ];

/// PRT_SfootUser
Property PRTSfootUserDR As User.SSUser [ SqlColumnNumber = 29, SqlFieldName = PRT_SfootUser_DR ];

/// PRT_OldINV_DR
Property PRTOldINVDR As User.DHCINVPRT [ SqlColumnNumber = 30, SqlFieldName = PRT_OldINV_DR ];

/// PRT_InsDiv_DR
Property PRTInsDivDR As User.INSUDivide [ SqlColumnNumber = 31, SqlFieldName = PRT_InsDiv_DR ];

/// PRT_YBPaySum
Property PRTYBPaySum As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = PRT_YBPaySum ];

/// PRT_RefundReason
Property PRTRefundReason As User.DHCINVOPRefReason [ SqlColumnNumber = 33, SqlFieldName = PRT_RefundReason ];

/// PRT_RefAuditLoc_DR
Property PRTRefAuditLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = PRT_RefAuditLoc_DR ];

/// PRT_FairType
Property PRTFairType As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Fair,Reg,Health Promotion", MAXLEN = 16, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",F,R,H") [ SqlColumnNumber = 35, SqlFieldName = PRT_FairType ];

/// PRT_OPPreSum
Property PRTOPPreSum As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = PRT_OPPreSum ];

/// PRT_OPBackChange
Property PRTOPBackChange As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = PRT_OPBackChange ];

/// PRT_OPCRoundErr
Property PRTOPCRoundErr As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = PRT_OPCRoundErr ];

/// PRT_SubAvailHosp_DR
Property PRTSubAvailHospDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = PRT_SubAvailHosp_DR ];

/// PRT_Hospital_DR
Property PRTHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 40, SqlFieldName = PRT_Hospital_DR ];

/// PRT_InsuranceType_DR
Property PRTInsuranceTypeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = PRT_InsuranceType_DR ];

/// PRT_Group_DR
Property PRTGroupDR As User.SSGroup [ SqlColumnNumber = 42, SqlFieldName = PRT_Group_DR ];

/// PRT_BusinessNo
Property PRTBusinessNo As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 43, SqlFieldName = PRT_BusinessNo ];

/// PRT_IPAddress
Property PRTIPAddress As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 44, SqlFieldName = PRT_IPAddress ];

/// PRT_StayFlag 急诊留观标志
Property PRTStayFlag As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = PRT_StayFlag ];

/// PRT_VATInvoiceNo 增值税发票号
Property PRTVATInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = PRT_VATInvoiceNo ];

/// PRT_PrePayUser_DR 预结操作员
Property PRTPrePayUserDR As User.SSUser [ SqlColumnNumber = 47, SqlFieldName = PRT_PrePayUser_DR ];

/// PRT_PrePayDate 预结日期
Property PRTPrePayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 48, SqlFieldName = PRT_PrePayDate ];

/// PRT_PrePayTime 预结时间
Property PRTPrePayTime As %Library.Time [ SqlColumnNumber = 49, SqlFieldName = PRT_PrePayTime ];

/// PRT_InvkInsuDivFlag 2022-11-17 是否调用医保接口标识
Property PRTInvkInsuDivFlag As %Library.String(COLLATION = "Exact", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 50, SqlFieldName = PRT_InvkInsuDivFlag ];

/// PRT_RealUser_DR 实际操作员
Property PRTRealUserDR As User.SSUser [ SqlColumnNumber = 51, SqlFieldName = PRT_RealUser_DR ];

/// Creator: ZhYW
/// CreatDate: 2022-03-24
/// Description: 审核和撤销审核时保存日志
Trigger TAfterUpdRefAudit [ Event = UPDATE, Time = AFTER ]
{
	if ({PRT_AllowRefund*C}) {
	    set json=##class(%DynamicObject).%New()
	    set json.TableName={%%TABLENAME}
	    set json.TableID={%%ID}
	    set json.PropValue={PRT_AllowRefund}
	    set json.UserDR={PRT_AllRefundUser}
	  	set json.OperDesc="门诊"_$s({PRT_AllowRefund*N}:"退费审核",1:"撤销审核")
	    set json.Remark={PRT_RefundReason}
	    do ##class(BILL.COM.PO.TriggerLog).Save(json.%ToJSON())
	}
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINVPRT)</SqlIdExpression>
<SQLMap name="IndexHandinDate">
<Global>^DHCINVPRT</Global>
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
<Expression>"HandDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_HandinDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInitInvDR">
<Global>^DHCINVPRT</Global>
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
<Expression>"InitInvDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_initInv_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsDivDR">
<Global>^DHCINVPRT</Global>
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
<Expression>"INSDIV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_InsDiv_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldInvDR">
<Global>^DHCINVPRT</Global>
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
<Expression>"OldINV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_OldINV_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPRTFlag">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRTFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCINVPRT</Global>
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
<Expression>{PRT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_Usr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="PRT_ACCPINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRT_ARRCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRT_Acount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRT_AllRefundDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PRT_AllRefundTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PRT_AllRefundUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PRT_AllowRefund">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PRT_BusinessNo">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="PRT_DHCINVPRTR_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRT_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRT_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRT_FairType">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PRT_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRT_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="PRT_Handin">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRT_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PRT_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PRT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="PRT_INVPrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRT_IPAddress">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="PRT_InsDiv_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PRT_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRT_InsuranceType_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="PRT_InvkInsuDivFlag">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="PRT_OPBackChange">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PRT_OPCRoundErr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PRT_OPPreSum">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PRT_OldINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PRT_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PRT_PFinRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PRT_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PRT_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PRT_PrePayDate">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="PRT_PrePayTime">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="PRT_PrePayUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="PRT_RealUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="PRT_RefAuditLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PRT_RefundReason">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PRT_SfootTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PRT_SfootUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PRT_SocialStatus">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PRT_StayFlag">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="PRT_SubAvailHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="PRT_Time">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PRT_UseINVType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PRT_Usr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PRT_VATInvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="PRT_YBPaySum">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PRT_initInv_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PRT_inv">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCINVPRT</Global>
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
<SQLMap name="indexDate">
<Global>^DHCINVPRT</Global>
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
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDateINST">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateINST"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDateInsType">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateInsType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRT_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexDatePapmi">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DatePAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexHandin">
<Global>^DHCINVPRT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRT_RowID</Field>
</RowIdSpec>
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
<Expression>{PRT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexInv">
<Global>^DHCINVPRT</Global>
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
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_inv}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexReport">
<Global>^DHCINVPRT</Global>
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
<Expression>"Report"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_DHCINVPRTR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexUser">
<Global>^DHCINVPRT</Global>
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
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_Usr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexVATInv">
<Global>^DHCINVPRT</Global>
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
<SQLMap name="indexrefundid">
<Global>^DHCINVPRT</Global>
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
<Expression>"INITID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRT_initInv_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
