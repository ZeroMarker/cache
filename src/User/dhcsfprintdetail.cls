Class User.dhcsfprintdetail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = prt_rowid, SqlTableName = dhc_sfprintdetail, StorageStrategy = SQLStorage ]
{

Relationship childsfprintdetailpaymode As User.dhcsfprintdetailpaymode [ Cardinality = children, Inverse = dpmprtparref ];

/// prt_rcptno
Property prtrcptno As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = prt_rcptno ];

/// prt_printdate
Property prtprintdate As %Date(FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 3, SqlFieldName = prt_printdate ];

/// prt_printtime
Property prtprinttime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 4, SqlFieldName = prt_printtime ];

/// prt_adm_dr
Property prtadmdr As User.PAAdm [ Required, SqlColumnNumber = 5, SqlFieldName = prt_adm_dr ];

/// prt_arrcp_dr
Property prtarrcpdr As User.ARReceipts [ SqlColumnNumber = 6, SqlFieldName = prt_arrcp_dr ];

/// prt_payamount
Property prtpayamount As %Float [ SqlColumnNumber = 7, SqlFieldName = prt_payamount ];

/// prt_papmi_dr
Property prtpapmidr As User.PAPatMas [ SqlColumnNumber = 8, SqlFieldName = prt_papmi_dr ];

/// prt_status
Property prtstatus As %String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = prt_status ];

/// prt_paymode
Property prtpaymode As User.CTPayMode [ SqlColumnNumber = 10, SqlFieldName = prt_paymode ];

/// prt_bank
Property prtbank As User.CMCBankMas [ SqlColumnNumber = 11, SqlFieldName = prt_bank ];

/// prt_chequeNo 支票号
Property prtchequeNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = prt_chequeNo ];

/// prt_unit_dr 单位
Property prtunitdr As User.CTHealthCareProvider [ SqlColumnNumber = 13, SqlFieldName = prt_unit_dr ];

/// prt_deptype_dr
Property prtdeptypedr As User.ARCDepType [ SqlColumnNumber = 14, SqlFieldName = prt_deptype_dr ];

/// prt_adduser_dr
Property prtadduserdr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = prt_adduser_dr ];

/// prt_deliverdate
Property prtdeliverdate As %Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = prt_deliverdate ];

/// prt_delivertime
Property prtdelivertime As %Time [ SqlColumnNumber = 17, SqlFieldName = prt_delivertime ];

/// prt_receivedate
Property prtreceivedate As %Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = prt_receivedate ];

/// prt_receivetime
Property prtreceivetime As %Time [ SqlColumnNumber = 19, SqlFieldName = prt_receivetime ];

/// prt_receiveuser
Property prtreceiveuser As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = prt_receiveuser ];

/// prt_jkuser_dr
Property prtjkuserdr As User.SSUser [ SqlColumnNumber = 21, SqlFieldName = prt_jkuser_dr ];

/// prt_jkflag
Property prtjkflag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = prt_jkflag ];

/// prt_jkdate
Property prtjkdate As %Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = prt_jkdate ];

/// prt_jktime
Property prtjktime As %Time [ SqlColumnNumber = 24, SqlFieldName = prt_jktime ];

/// prt_confirmuser
Property prtconfirmuser As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = prt_confirmuser ];

/// prt_confirmdate
Property prtconfirmdate As %Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = prt_confirmdate ];

/// prt_confirmtime
Property prtconfirmtime As %Time [ SqlColumnNumber = 27, SqlFieldName = prt_confirmtime ];

/// prt_confirmflag
Property prtconfirmflag As %String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = prt_confirmflag ];

/// prt_deliverflag
Property prtdeliverflag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = prt_deliverflag ];

/// prt_left 剩余可退余额
Property prtleft As %Float [ SqlColumnNumber = 30, SqlFieldName = prt_left ];

/// prt_jk_dr
Property prtjkdr As User.DHCJFUSERJK [ SqlColumnNumber = 31, SqlFieldName = prt_jk_dr ];

/// prt_yjrefreason_dr
Property prtyjrefreasondr As User.dhcjfyjrefreason [ SqlColumnNumber = 32, SqlFieldName = prt_yjrefreason_dr ];

/// prt_oldrcpt_dr 作废重收时指向原押金id(预留)
Property prtoldrcptdr As User.dhcsfprintdetail [ SqlColumnNumber = 33, SqlFieldName = prt_oldrcpt_dr ];

/// prt_remark 备注
Property prtremark As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = prt_remark ];

/// prt_lostregist_dr 挂失表RowId
Property prtlostregistdr As BILL.IP.DepLostRegist [ SqlColumnNumber = 35, SqlFieldName = prt_lostregist_dr ];

/// prt_branch
Property prtbranch As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = prt_branch ];

/// prt_currward_dr
Property prtcurrwarddr As User.PACWard [ SqlColumnNumber = 37, SqlFieldName = prt_currward_dr ];

/// prt_currdept_dr
Property prtcurrdeptdr As User.CTLoc [ SqlColumnNumber = 38, SqlFieldName = prt_currdept_dr ];

/// prt_paidflag
Property prtpaidflag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = prt_paidflag ];

/// prt_transfer
Property prttransfer As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = prt_transfer ];

/// prt_refinvprtzy_dr 住院取消结算对冲押金时对应的负记录指针
Property prtrefinvprtzydr As User.DHCINVPRTZY [ SqlColumnNumber = 41, SqlFieldName = prt_refinvprtzy_dr ];

/// prt_abortdate
Property prtabortdate As %Date(FORMAT = 1) [ SqlColumnNumber = 42, SqlFieldName = prt_abortdate ];

/// prt_aborttime
Property prtaborttime As %Time(FORMAT = 1) [ SqlColumnNumber = 43, SqlFieldName = prt_aborttime ];

/// prt_initdep_dr 退款时指向原票据RowId
Property prtinitdepdr As User.dhcsfprintdetail [ SqlColumnNumber = 44, SqlFieldName = prt_initdep_dr ];

/// prt_hospital_dr
Property prthospitaldr As User.CTHospital [ Required, SqlColumnNumber = 45, SqlFieldName = prt_hospital_dr ];

/// prt_ipaddress
Property prtipaddress As %String(COLLATION = "Exact") [ SqlColumnNumber = 46, SqlFieldName = prt_ipaddress ];

Storage SQLStorage
{
<ExtentSize>2500000</ExtentSize>
<Property name="%%ID">
<AverageFieldSize>3.26</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="prtabortdate">
<AverageFieldSize>2.29</AverageFieldSize>
<OutlierSelectivity>.942029:</OutlierSelectivity>
<Selectivity>0.6441%</Selectivity>
</Property>
<Property name="prtaborttime">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtadduserdr">
<AverageFieldSize>7</AverageFieldSize>
<OutlierSelectivity>.997101:17275</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<Property name="prtadmdr">
<AverageFieldSize>4.97</AverageFieldSize>
<Selectivity>0.3937%</Selectivity>
</Property>
<Property name="prtarrcpdr">
<AverageFieldSize>5.2</AverageFieldSize>
<Selectivity>0.3205%</Selectivity>
</Property>
<Property name="prtbank">
<AverageFieldSize>2.01</AverageFieldSize>
<OutlierSelectivity>.985507:</OutlierSelectivity>
<Selectivity>0.7246%</Selectivity>
</Property>
<Property name="prtbranch">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtchequeNo">
<AverageFieldSize>2.02</AverageFieldSize>
<OutlierSelectivity>.985507:</OutlierSelectivity>
<Selectivity>0.4831%</Selectivity>
</Property>
<Property name="prtconfirmdate">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtconfirmflag">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtconfirmtime">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtconfirmuser">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtcurrdeptdr">
<AverageFieldSize>5</AverageFieldSize>
<OutlierSelectivity>.286957:191</OutlierSelectivity>
<Selectivity>2.9710%</Selectivity>
</Property>
<Property name="prtcurrwarddr">
<AverageFieldSize>3.4</AverageFieldSize>
<OutlierSelectivity>.286957:3</OutlierSelectivity>
<Selectivity>2.8522%</Selectivity>
</Property>
<Property name="prtdeliverdate">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtdeliverflag">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtdelivertime">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtdeptypedr">
<AverageFieldSize>3.01</AverageFieldSize>
<OutlierSelectivity>.991304:1</OutlierSelectivity>
<Selectivity>0.8696%</Selectivity>
</Property>
<Property name="prthospitaldr">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.985507:2</OutlierSelectivity>
<Selectivity>0.7246%</Selectivity>
</Property>
<Property name="prtinitdepdr">
<AverageFieldSize>2.29</AverageFieldSize>
<OutlierSelectivity>.889855:</OutlierSelectivity>
<Selectivity>0.3060%</Selectivity>
</Property>
<Property name="prtipaddress">
<AverageFieldSize>2.04</AverageFieldSize>
<OutlierSelectivity>.997101:</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<Property name="prtjkdate">
<AverageFieldSize>6.99</AverageFieldSize>
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="prtjkdr">
<AverageFieldSize>3.54</AverageFieldSize>
<OutlierSelectivity>.136232:1</OutlierSelectivity>
<Selectivity>1.9195%</Selectivity>
</Property>
<Property name="prtjkflag">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.997101:"Y"</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<Property name="prtjktime">
<AverageFieldSize>6.99</AverageFieldSize>
<OutlierSelectivity>.878261:"23:59:59"</OutlierSelectivity>
<Selectivity>0.8116%</Selectivity>
</Property>
<Property name="prtjkuserdr">
<AverageFieldSize>6.99</AverageFieldSize>
<OutlierSelectivity>.994203:17275</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<Property name="prtleft">
<AverageFieldSize>6.08</AverageFieldSize>
<OutlierSelectivity>.211594:0</OutlierSelectivity>
<Selectivity>1.2319%</Selectivity>
</Property>
<Property name="prtlostregistdr">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.997101:</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<Property name="prtoldrcptdr">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtpaidflag">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.944928:"N"</OutlierSelectivity>
<Selectivity>5.5072%</Selectivity>
</Property>
<Property name="prtpapmidr">
<AverageFieldSize>4.68</AverageFieldSize>
<Selectivity>0.4149%</Selectivity>
</Property>
<Property name="prtpayamount">
<AverageFieldSize>6.79</AverageFieldSize>
<Selectivity>1.0638%</Selectivity>
</Property>
<Property name="prtpaymode">
<AverageFieldSize>3.02</AverageFieldSize>
<OutlierSelectivity>.953623:1</OutlierSelectivity>
<Selectivity>1.1594%</Selectivity>
</Property>
<Property name="prtprintdate">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="prtprinttime">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>0.2907%</Selectivity>
</Property>
<Property name="prtrcptno">
<AverageFieldSize>7.61</AverageFieldSize>
<Selectivity>0.3086%</Selectivity>
</Property>
<Property name="prtreceivedate">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtreceivetime">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtreceiveuser">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtrefarrcpdr">
<AverageFieldSize>2.01</AverageFieldSize>
<OutlierSelectivity>.997101:</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<Property name="prtremark">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtstatus">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.808696:1</OutlierSelectivity>
<Selectivity>6.3768%</Selectivity>
</Property>
<Property name="prttransfer">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtunitdr">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="prtyjrefreasondr">
<AverageFieldSize>2.01</AverageFieldSize>
<OutlierSelectivity>.994203:</OutlierSelectivity>
<Selectivity>0.2899%</Selectivity>
</Property>
<SqlIdExpression>$i(^DHCSFPRINTDETAIL)</SqlIdExpression>
<SQLMap name="IndexARRCPDR">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RcptDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_arrcp_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAddUser">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AddUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_adduser_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"adm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_adm_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCardNo">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CardNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_chequeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepType">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DepType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_deptype_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInitDepDR">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InitDepDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_initdep_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJkDate">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JkDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_jkdate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJkUser">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JkUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_jkuser_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJkflag">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JKFLAG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_jkflag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_adduser_dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaidFlag">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PaidFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_paidflag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_papmi_dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayMode">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PayMode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_paymode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrtDate">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PrtDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_printdate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRcptNo">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RcptNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_rcptno}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRefInvDR">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RefInvDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_refinvprtzy_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{prt_status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexJKDR">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JKDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_jk_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcurrdeptdr">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CurrDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_currdept_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexcurrwarddr">
<Global>^DHCSFPRINTDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CurrWard"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{prt_currward_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{prt_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="prtdetail">
<Data name="prt_abortdate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="prt_aborttime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="prt_adduser_dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="prt_adm_dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="prt_arrcp_dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="prt_bank">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="prt_branch">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="prt_chequeNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="prt_confirmdate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="prt_confirmflag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="prt_confirmtime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="prt_confirmuser">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="prt_currdept_dr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="prt_currward_dr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="prt_deliverdate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="prt_deliverflag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="prt_delivertime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="prt_deptype_dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="prt_hospital_dr">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="prt_initdep_dr">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="prt_ipaddress">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="prt_jk_dr">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="prt_jkdate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="prt_jkflag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="prt_jktime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="prt_jkuser_dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="prt_left">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="prt_lostregist_dr">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="prt_oldrcpt_dr">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="prt_paidflag">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="prt_papmi_dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="prt_payamount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="prt_paymode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="prt_printdate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="prt_printtime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="prt_rcptno">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="prt_receivedate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="prt_receivetime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="prt_receiveuser">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="prt_refinvprtzy_dr">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="prt_remark">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="prt_status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="prt_transfer">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="prt_unit_dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="prt_yjrefreason_dr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Global>^DHCSFPRINTDETAIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>prt_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{prt_rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.dhcsfprintdetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 2500000;

}
