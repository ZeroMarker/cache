Import SQLUser

Class web.DHCOPConfig Extends BILL.COM.Abstract
{

/// Description: 获取中草药配置
/// Debug: w ##class(web.DHCOPConfig).GetHerbalConfig(2)
ClassMethod GetHerbalConfig(hospId As %String) As %String
{
	set cfgId=..GetSOPFCfgId(hospId)
	quit:(cfgId="") 101
	
	&SQL(
		SELECT OPFC_HerbalFlag, OPFC_HerbalDesc, OPFC_HerbalNum
		INTO :HerbbalFlag, :HerbalDesc, :HerbalNum
		FROM DHC_SOPFConfig
		WHERE %ID = :cfgId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn
	
	set myInfo=HerbbalFlag
	set myInfo=myInfo_$c(2)_HerbalDesc
	set myInfo=myInfo_$c(2)_HerbalNum
	set HerbRange=""
	if (HerbbalFlag=1) {
		set FCHerbRange=##class(BILL.Interface.Inside.Invoke).GetCNMedItemCatStr(hospId)
		set HerbRange="^"_FCHerbRange_"^"
	}
	set myInfo=myInfo_$c(2)_HerbRange
	
	quit 0_$c(2)_myInfo
}

/// Description: 获取门诊收费的基本配置
/// Debug: w ##class(web.DHCOPConfig).GetOPBaseConfig(2)
ClassMethod GetOPBaseConfig(hospId As %String) As %String
{
	set cfgId=..GetSOPFCfgId(hospId)
	quit:(cfgId="") 101
	
	&SQL(
		SELECT * INTO PLIST()
		FROM DHC_SOPFConfig
		WHERE %ID = :cfgId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^^^^^^^^^^"
	
	set myInfo=PLIST(1)						;1
	set myInfo=myInfo_"^"_PLIST(2)			;2      OPFC_WebConDR
	set myInfo=myInfo_"^"_PLIST(3)			;3      OPFC_Hosp_DR
	set myInfo=myInfo_"^"_PLIST(4)			;4      OPFC_ItemFlag
	set myInfo=myInfo_"^"_PLIST(5)			;5      OPFC_ReclocFlag
	set myInfo=myInfo_"^"_PLIST(6)			;6      OPFC_PresNoFlag
	set myInfo=myInfo_"^"_PLIST(7)			;7      OPFC_RecInvCount
	set myInfo=myInfo_"^"_PLIST(8)			;8      OPFC_PrintCount
	set myInfo=myInfo_"^"_PLIST(13)			;9      OPFC_YBConFlag
	set myInfo=myInfo_"^"_PLIST(14)			;10     OPFC_AdmFlag
	set myInfo=myInfo_"^"_PLIST(15)			;11     OPFC_AppFlag
	set myInfo=myInfo_"^"_PLIST(16)			;12     OPFC_PRTYBConFlag
	set myInfo=myInfo_"^"_PLIST(17)			;13     OPFC_RoundDownNum
	set myInfo=myInfo_"^"_(+PLIST(18))		;14     OPFC_OrdSIFlag
	set myInfo=myInfo_"^"_PLIST(19)			;15     OPFC_AItmCatStr
	set myInfo=myInfo_"^"_PLIST(20)			;16		OPFCUseFareType
	set myInfo=myInfo_"^"_PLIST(21)			;17		OPFCBILLVersion
	set myInfo=myInfo_"^"_PLIST(22)			;18		OPFC_IntervalMin
	set myInfo=myInfo_"^"_PLIST(23)			;19     OPFCAppOEFlag
	set myInfo=myInfo_"^"_PLIST(24)			;20		OPFCOutSearchFlag
	set myInfo=myInfo_"^"_PLIST(25)			;21		OPFCOutTimeRange
	set myInfo=myInfo_"^"_PLIST(26)			;22		OPFCEmergencySearchFlag
	set myInfo=myInfo_"^"_PLIST(27)			;23		OPFCEmergencyTimeRange
	set myInfo=myInfo_"^"_PLIST(28)		    ;24		OPFC_AuditSpaceTime
	set myInfo=myInfo_"^"_PLIST(29)			;25		OPFC_OESkinRtnFlag
	set myInfo=myInfo_"^"_PLIST(30)			;26		OPFC_OEORDLimitFootFlag
	set myInfo=myInfo_"^"_PLIST(31)			;27		OPFC_SubAvailFlag		
	set myInfo=myInfo_"^"_PLIST(32)			;28		OPFC_AccPreDepReceiptType(预交金收据类型)
	set myInfo=myInfo_"^"_PLIST(33)			;29		OPFC_RegReceiptType(挂号收据类型)
	set myInfo=myInfo_"^"_PLIST(34)			;30	    OPFC_StrikeRequireINV(红冲退发票走收据号"Y")
	set myInfo=myInfo_"^"_PLIST(38)			;31		OPFC_OneToManyFlag(集中打印发票与支付小条是否为"一对多")
	set myInfo=myInfo_"^"_PLIST(39)			;32	    OPFC_RegInvFlag(集中打印发票时,挂号发票是否单独拆分)
	set myInfo=myInfo_"^"_PLIST(40)			;33	    OPFC_InvDateFlag(集中打印发票时,是否发票打印日期单独拆分)
	set myInfo=myInfo_"^"_PLIST(35)			;34	    OPFC_SKCFootFlag(是否选择病种结算)
	set myInfo=myInfo_"^"_PLIST(36)			;35	    OPFC_NewAdmReaFootFlag(是否选择新费别结算)
	set myInfo=myInfo_"^"_PLIST(51)			;36     OPFC_ZeroAmtUseYBFlag 零费用结算是否调用医保 ShangXuehao 2020-11-25
	set myInfo=myInfo_"^"_PLIST(48)			;37     OPFC_ICDXFlag 按病种拆分标识 ZhYW 2021-11-17
	set myInfo=myInfo_"^"_PLIST(49)			;38     OPFC_RegOrdFlag 挂号医嘱单独拆票标识 ZhYW 2021-11-17
	
	quit 0_"^"_myInfo
}

/// Description: 获取门诊收费的基本配置
/// Input: groupId:安全组, hospId: CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPConfig).GetOPBaseConfigForGroup(113)
ClassMethod GetOPBaseConfigForGroup(groupId As %String, hospId As %String) As %String
{
	set myOPInfo=..GetOPBaseConfig(hospId)
	set myInfo=""
	set mylen=$l(myOPInfo,"^")
	for i=2:1:mylen {
		set myInfo=myInfo_$p(myOPInfo,"^",i)_"^"
	}
	
	if (groupId'="") {
		set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(groupId, hospId)
		if (myGSRowID'="") {
			set myGSData=$g(^DHCOPGS("GS",myGSRowID))
			set myPrtINVFlag=$p(myGSData,"^",3)			        //GS_PrtINVFlag
			set myPRTParaFlag=$p(myGSData,"^",11)		        //GS_PRPParaFlag
			if (myPRTParaFlag="G") {
				set myItemFlag=$p(myGSData,"^",12)			    //GS_ItemFlag
				set myRecDepFlag=$p(myGSData,"^",13)		    //GS_RecDepFlag
				set myPresNoFlag=$p(myGSData,"^",14)		    //GS_PresNoFlag
				set myRecInvCount=+$p(myGSData,"^",15)		    //GS_RecInvCount
				set myPrintCount=+$p(myGSData,"^",16)		    //GS_PrintCount
				set myOrdIFlag=+$p(myGSData,"^",17)			    //GS_OrdSIFlag
				set myICDXFlag=+$p(myGSData,"^",23)		        //GS_ICDXFlag(按病种拆分标识)
				set myRegOrdFlag=+$p(myGSData,"^",24)		    //GS_ICDXFlag(挂号医嘱单独拆票标识)
				set myNote5=$p(myGSData,"^",26)				    //GS_Note5 (是否使用押金管理)
				set myOneToManyFlag=+$p(myGSData,"^",27)	    //OPFC_OneToManyFlag(集中打印发票与支付小条是否为
				set myRegInvFlag=+$p(myGSData,"^",28)		    //OPFC_RegInvFlag(集中打印发票时,挂号发票是否单独拆分)
				set myInvDateFlag=+$p(myGSData,"^",29)		    //GS_InvDateFlag(集中打印发票时,是否发票打印日期单独拆分)
				set myCardPayModeFlag=+$p(myGSData,"^",30)		//GS_CardPayModeFlag(科室卡支付是否弹出收费界面)
				set $p(myInfo,"^",4)=myItemFlag
				set $p(myInfo,"^",5)=myRecDepFlag
				set $p(myInfo,"^",6)=myPresNoFlag
				set $p(myInfo,"^",7)=myRecInvCount
				set $p(myInfo,"^",8)=myPrintCount
				set $p(myInfo,"^",14)=myOrdIFlag			                    //OPFC_OrdSIFlag
				set $p(myInfo,"^",28)=myNote5
				set $p(myInfo,"^",31)=myOneToManyFlag
				set $p(myInfo,"^",32)=myRegInvFlag
				set $p(myInfo,"^",33)=myInvDateFlag
				set $p(myInfo,"^",34)=myCardPayModeFlag
				set $p(myInfo,"^",37)=myICDXFlag
				set $p(myInfo,"^",38)=myRegOrdFlag
			}
		}
	}
	
	quit 0_"^"_myInfo
}

/// Description: 获取门诊收费的基本配置?
/// Debug: w ##class(web.DHCOPConfig).GetOPYBConfig(2)
ClassMethod GetOPYBConfig(hospId As %String) As %String
{
	set cfgId=..GetSOPFCfgId(hospId)
	quit:(cfgId="") 101
	
	&SQL(
		SELECT OPFC_YBConFlag, OPFC_AdmFlag, OPFC_ICDXFlag, OPFC_RegOrdFlag
		INTO :YBConFlag, :AdmFlag, :ICDXFlag, :RegOrdFlag
		FROM DHC_SOPFConfig
		WHERE %ID = :cfgId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn
	
	set myInfo=YBConFlag_"^"_AdmFlag_"^"_ICDXFlag_"^"_RegOrdFlag
	
	quit 0_"^"_myInfo
}

/// Description: 获取门诊收费的基本配置
/// Input: hospId: CT_Hospital.RowId
/// Return: DHC_SOPFConfig.OPFC_SubAvailFlag
/// Debug: w ##class(web.DHCOPConfig).GetOPSubAvailConfig(2)
ClassMethod GetOPSubAvailConfig(hospId As %String) As %String
{
	set cfgId=..GetSOPFCfgId(hospId)
	quit:(cfgId="") 101
	set SubAvailFlag=$p($g(^DHCSOPFCON(cfgId)),"^",30)		
	quit 0_"^"_SubAvailFlag
}

/// Description: 获取门诊使用的费别类型
/// Input: hospId: CT_Hospital.RowId
/// Return: DHC_SOPFConfig.OPFC_UseFareType
/// Debug: w ##class(web.DHCOPConfig).GetOPUseFareTypeConfig(2)
ClassMethod GetOPUseFareTypeConfig(hospId As %String) As %String
{
	set cfgId=..GetSOPFCfgId(hospId)
	quit:(cfgId="") 101
	set UseFareType=+$p($g(^DHCSOPFCON(cfgId)),"^",19)
	quit 0_"^"_UseFareType
}

/// Description: 获取按照费别的票据配置
/// Return: 0: 打印发票，1: 不打印票
/// Debug: w ##class(web.DHCOPConfig).GetReasonConfig("1")
ClassMethod GetReasonConfig(InsTypeId As %String = "") As %String
{
	quit:(InsTypeId="") 0
	set myStatus=+$p($g(^PAC("ADMREA",InsTypeId)),"^",10)
	quit myStatus
}

/// Debug: w ##class(web.DHCOPConfig).GetReasonType("12")
ClassMethod GetReasonType(InsTypeId As %String = "") As %String
{
	quit:(InsTypeId="") 0
	set myRType=+$p($g(^PAC("ADMREA",InsTypeId)),"^",11)
	quit myRType
}

/// Debug: w ##class(web.DHCOPConfig).GetVersion()
ClassMethod GetVersion() As %String
{
	set cfgId=$o(^DHCSOPFCON(0))
	quit:(cfgId="") 101
	set version=$p($g(^DHCSOPFCON(cfgId)),"^",11)
	quit version
}

/// Debug: w ##class(web.DHCOPConfig).ReadOESpPrtFlag()
ClassMethod ReadOESpPrtFlag(ArcRowID As %String) As %String
{
	set myArBSDR=$p(^ARCIM(+ArcRowID,$p(ArcRowID,"||",2),1),"^",9)
	
	quit:(myArBSDR="") ""
	
	set mySpFlag=$p($g(^ARCBG(+myArBSDR,"SG",$p(myArBSDR,"||",2))),"^",3)
	
	if ("OF"'[mySpFlag) {
		set mySpFlag=""
	}
	
	quit mySpFlag
}

/// Description: 获取基本配置参数；用来维护系统配置
/// Debug: w ##class(web.DHCOPConfig).ReadOPSPConfig(2)
ClassMethod ReadOPSPConfig(hospId As %String) As %String
{
	set cfgId=..GetSOPFCfgId(hospId)
	quit:(cfgId="") 101
	
	set myStr=$g(^DHCSOPFCON(cfgId))
	set myStr=cfgId_"^"_myStr
	
	quit myStr
}

/// Description: 根据费别的RowID，得到医保的标志
/// Return: 0:非医保; >0:是医保
/// Debug: w ##class(web.DHCOPConfig).ReadYBFlagByINS()
ClassMethod ReadYBFlagByINS(INSRowID As %String) As %String
{
	quit:(INSRowID="") 0
	set myYBFlag=+$p($g(^PAC("ADMREA",INSRowID)),"^",9)
	quit myYBFlag
}

/// Description: 获取费别配置信息通过费别RowID
/// mystr 说明：
/// 1 配置成为门诊收费是否连接医保状态标志
/// 2 配置成为此费别的患者是否打印发票
/// 3 配置成为此类患者需要特殊凭据才能结算， 例如： PCS卡， 老年卡等
/// 4 配置成费别类型  0 表示此患者类型按照 系统配置结算 1  表示此费别强制按照此类型结算
/// 5 
/// Debug: w ##class(web.DHCOPConfig).ReadINSInfoByINS()
ClassMethod ReadINSInfoByINS(INSRowID As %String) As %String
{
	set mystr=""

	quit:(INSRowID="") "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	
	quit:('$d(^PAC("ADMREA",INSRowID))) "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

	set mystr=$p(^PAC("ADMREA",INSRowID),"^",9)			;REA_AdmSource  配置成为门诊收费是否连接医保状态标志
	set mystr=mystr_"^"_$p(^PAC("ADMREA",INSRowID),"^",10) ;REA_QualifStatus 配置成为此费别的患者是否打印发票
	set mystr=mystr_"^"_$p(^PAC("ADMREA",INSRowID),"^",11) ;REA_CareType   配置成为此类患者需要特殊凭据才能结算， 例如： PCS卡， 老年卡等
	set mystr=mystr_"^"							;把第4位留给费别
	//下面是新建一张表来扩展费别  这个可以用来表示门诊或者住院的 DHC_SOPADMReasonExp
	set mySARERowID=$o(^DHCSOPADMRExpi(0,"ADMR",INSRowID,0))
	
	if (mySARERowID'="") {
		set $p(mystr,"^",4)=$p(^DHCSOPADMRExp(mySARERowID),"^",2)		//SARE_UseFareType
	}else {
		set mystr=mystr_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	}
	quit mystr
}

/// Description: 根据患者类型获取是否连接医保，优先连接
/// Debug: w ##class(web.DHCOPConfig).ReadYBFlagByPayType()
ClassMethod ReadYBFlagByPayType(PatTypeRowID As %String, HospId As %String) As %String
{
	set myConFlag=0		//表示不连接
	quit:(PatTypeRowID="") myConFlag
	
	set myBConStr=##class(web.DHCOPConfig).GetOPBaseConfig(HospId)
	set myYBConFlag=$p(myBConStr,"^",10)
	quit:(myYBConFlag'=1) myConFlag
	
	set myPACRowID=0
	while($o(^DHCPACADM(0,"Social",PatTypeRowID,myPACRowID))) {
		set myPACRowID=$o(^DHCPACADM(0,"Social",PatTypeRowID,myPACRowID))
		set myReaRowID=$p(^DHCPACADM(myPACRowID),"^",2)
		set myInsFlag=$s((+myReaRowID'=0):$p($g(^PAC("ADMREA",myReaRowID)),"^",9),1:"")
		continue:(+myInsFlag=0)
		set myConFlag=myInsFlag
		quit:(+myConFlag'=0)
	}
	
	quit myConFlag
}

/// Debug: w ##class(web.DHCOPConfig).TransLBToStr($lb("1",2,3))
ClassMethod TransLBToStr(LBStr As %String) As %String
{
	quit $lts(LBStr,"^")
	/*
	set myStr=""
	
	set mylen=$ll(LBStr)
	
	for i=1:1:mylen  do
	.set myCurStr=$li(LBStr,i)
	.if (i=1) do
	..set myStr=myCurStr
	.else  do
	..set myStr=myStr_"^"_myCurStr
	
	quit myStr
	*/
}

/// Creator: ZhYW
/// CreatDate: 2019-10-22
/// Description: 保存配置表数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPConfig).SaveSOPFCfg("")
ClassMethod SaveSOPFCfg(jsonStr As %String) As %String
{
	set ^TMP("SaveSOPFCfg")=$lb(jsonStr)
	set $zt="ERROR"
	
	set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
	
	if (jsonObj.ID>0) {
		set dataObj=##class(User.DHCSOPFConfig).%OpenId(jsonObj.ID, 0)
	}else {
		set dataObj=##class(User.DHCSOPFConfig).%New()
	}
	if ('$isObject(dataObj)) {
		do dataObj.%Close()
		quit -1_"^"_"创建对象失败"
	}
	
	set rtn=0
	ts
	
	set dataObj.OPFCWebConDR=$s((jsonObj.OPFCWebConDR'=""):jsonObj.OPFCWebConDR, 1:1)   //这个值什么意思?
	do dataObj.OPFCHospDRSetObjectId(jsonObj.OPFCHospDR)
	set dataObj.OPFCItemFlag=(jsonObj.OPFCItemFlag'="")
	set dataObj.OPFCReclocFlag=+jsonObj.OPFCReclocFlag
	set dataObj.OPFCPresNoFlag=+jsonObj.OPFCPresNoFlag
	
	set dataObj.OPFCRecInvCount=+jsonObj.OPFCRecInvCount
	set dataObj.OPFCPrintCount=+jsonObj.OPFCPrintCount
	set dataObj.OPFCHerbalFlag=+jsonObj.OPFCHerbalFlag
	set dataObj.OPFCHerbalDesc=$s((jsonObj.OPFCHerbalDesc'=""):jsonObj.OPFCHerbalDesc, 1:"中草药收费")
	set dataObj.OPFCHerbalNum=$s((jsonObj.OPFCHerbalNum'=""):jsonObj.OPFCHerbalNum, 1:1)
	
	set dataObj.OPFCVersion=$s((jsonObj.OPFCVersion'=""):jsonObj.OPFCVersion, 1:12)
	set dataObj.OPFCYBConFlag=jsonObj.OPFCYBConFlag
	set dataObj.OPFCAdmFlag=jsonObj.OPFCAdmFlag
	set dataObj.OPFCPRTYBConFlag=jsonObj.OPFCPRTYBConFlag
	
	set dataObj.OPFCRoundDownNum=+jsonObj.OPFCRoundDownNum
	set dataObj.OPFCOrdSIFlag=jsonObj.OPFCOrdSIFlag
	set dataObj.OPFCAItmCatStr=jsonObj.OPFCAItmCatStr
	set dataObj.OPFCUseFareType=jsonObj.OPFCUseFareType
	set dataObj.OPFCBILLVersion=$s((jsonObj.OPFCBILLVersion'=""):jsonObj.OPFCBILLVersion, 1:1)
	
	set dataObj.OPFCIntervalMin=jsonObj.OPFCIntervalMin
	set dataObj.OPFCZeroPriceChargeFlag=jsonObj.OPFCZeroPriceChargeFlag    //价格为零的医嘱结算是否进账单
	set dataObj.OPFCOutSearchFlag=jsonObj.OPFCOutSearchFlag
	set dataObj.OPFCOutTimeRange=jsonObj.OPFCOutTimeRange
	set dataObj.OPFCEmergencySearchFlag=jsonObj.OPFCEmergencySearchFlag
	
	set dataObj.OPFCEmergencyTimeRange=jsonObj.OPFCEmergencyTimeRange
	set dataObj.OPFCAuditSpaceTime=jsonObj.OPFCAuditSpaceTime
	set dataObj.OPFCOESkinRtnFlag=jsonObj.OPFCOESkinRtnFlag
	set dataObj.OPFCOEORDLimitFootFlag=jsonObj.OPFCOEORDLimitFootFlag
	set dataObj.OPFCSubAvailFlag=jsonObj.OPFCSubAvailFlag
	
	set dataObj.OPFCAccPreDepReceiptType=jsonObj.OPFCAccPreDepReceiptType
	set dataObj.OPFCRegReceiptType=jsonObj.OPFCRegReceiptType
	set dataObj.OPFCStrikeRequireINV=jsonObj.OPFCStrikeRequireINV
	set dataObj.OPFCSKCFootFlag=jsonObj.OPFCSKCFootFlag
	set dataObj.OPFCNewAdmReaFootFlag=jsonObj.OPFCNewAdmReaFootFlag
	
	set dataObj.OPFCOneToManyFlag=jsonObj.OPFCOneToManyFlag
	set dataObj.OPFCRegInvFlag=jsonObj.OPFCRegInvFlag
	set dataObj.OPFCInvDateFlag=jsonObj.OPFCInvDateFlag
	set dataObj.OPFCRcptUserFlag=jsonObj.OPFCRcptUserFlag
	
	set dataObj.OPFCSuperAuthGrp=jsonObj.OPFCSuperAuthGrp
	set dataObj.OPFCPrtGuideFlag=jsonObj.OPFCPrtGuideFlag
	set dataObj.OPFCStayChargeMode=jsonObj.OPFCStayChargeMode
	set dataObj.OPFCOPTransferFlag=jsonObj.OPFCOPTransferFlag
	
	set dataObj.OPFCIPTransferFlag=jsonObj.OPFCIPTransferFlag
	set dataObj.OPFCICDXFlag=jsonObj.OPFCICDXFlag
	set dataObj.OPFCRegOrdFlag=jsonObj.OPFCRegOrdFlag
	set dataObj.OPFCZeroAmtUseYBFlag=jsonObj.OPFCZeroAmtUseYBFlag	//零费用结算是否调用调用医保
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if ($$$ISERR(sc)) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-03-17
/// Description: 获取DHC_SOPFConfig表RowId(用于业务应用程序中)
/// Input: hospId: CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPConfig).GetSOPFCfgId(2)
ClassMethod GetSOPFCfgId(hospId As %String) As %String
{
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_Param", hospId)
	set cfgId=""
	set myID=0
	while($o(^DHCSOPFCON(myID))&&(cfgId="")) {
		set myID=$o(^DHCSOPFCON(myID))
		set myHospDR=$p($g(^DHCSOPFCON(myID)),"^",2)
		continue:(myHospDR'=defHospId)
		set cfgId=myID
	}
	
	quit cfgId
}

/// Creator: ZhYW
/// CreatDate: 2020-04-28
/// Description: 获取DHC_SOPFConfig表数据(json 用于配置界面)
/// Input: hospId: CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPConfig).GetSOPFCfgJsonData(2)
ClassMethod GetSOPFCfgJsonData(hospId As %String) As %String
{
	set cfgId=""
	set myID=0
	while($o(^DHCSOPFCON(myID))&&(cfgId="")) {
		set myID=$o(^DHCSOPFCON(myID))
		set myHospDR=$p($g(^DHCSOPFCON(myID)),"^",2)
		continue:(myHospDR'=hospId)
		set cfgId=myID
	}
	
	quit ##class(web.DHCBillCommon).GetClsPropValById("User.DHCSOPFConfig", cfgId)
}

/// Creator: ZhYW
/// CreatDate: 2022-09-21
/// Description: 取预交金的收据类型设置
/// Input: hospId: CT_Hospital.RowId
/// Return: DHC_SOPFConfig.OPFC_AccPreDepReceiptType
/// Debug: w ##class(web.DHCOPConfig).GetPreReceiptType(2)
ClassMethod GetPreReceiptType(HospId As %String) As %String
{
	set receiptType=""
	set cfgId=..GetSOPFCfgId(HospId)
	quit:(+cfgId=0) receiptType
	set receiptType=$p($g(^DHCSOPFCON(cfgId)),"^",31)
	quit receiptType
}

/// Creator: ZhYW
/// CreatDate: 2023-03-07
/// Description: 保存配置表门诊退费审核配置数据
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPConfig).SaveOPRefAuthCfg("")
ClassMethod SaveOPRefAuthCfg(jsonStr As %String) As %String
{
	set ^TMP("SaveRefAuthCfg")=$lb(jsonStr)
	set $zt="ERROR"
	
	set EnablePMASystem=##class(BILL.Interface.Inside.AuthItemApply).GetEnablePMASystem()
	
	set jsonObj=##class(%DynamicObject).%FromJSON(jsonStr)
	
	if (jsonObj.ID>0) {
		set dataObj=##class(User.DHCSOPFConfig).%OpenId(jsonObj.ID, 0)
	}else {
		set dataObj=##class(User.DHCSOPFConfig).%New()
	}
	if ('$isObject(dataObj)) {
		do dataObj.%Close()
		quit -1_"^"_"创建对象失败"
	}
	
	set rtn=0
	ts
	
	set dataObj.OPFCWebConDR=$s((jsonObj.OPFCWebConDR'=""):jsonObj.OPFCWebConDR, 1:1)   //这个值什么意思?
	do dataObj.OPFCHospDRSetObjectId(jsonObj.OPFCHospDR)

	set dataObj.OPFCHerbalDesc=$s((jsonObj.OPFCHerbalDesc'=""):jsonObj.OPFCHerbalDesc, 1:"中草药收费")
	set dataObj.OPFCHerbalNum=$s((jsonObj.OPFCHerbalNum'=""):jsonObj.OPFCHerbalNum, 1:1)
	
	set dataObj.OPFCVersion=$s((jsonObj.OPFCVersion'=""):jsonObj.OPFCVersion, 1:12)
	set dataObj.OPFCBILLVersion=$s((jsonObj.OPFCBILLVersion'=""):jsonObj.OPFCBILLVersion, 1:1)
	
	if ('EnablePMASystem) {
		do ##class(BILL.Interface.Inside.AuthItemApply).SetOPRefAuthDTO(.dataObj, jsonObj)
	}
	set sc=dataObj.%Save()
	do dataObj.%Close()
	set dataId=dataObj.%Id()
	if ($$$ISERR(sc)) {
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	if (EnablePMASystem) {
		//+2023-03-28 ZhYW 向权力系统发送审批申请
		set appJson=##class(%DynamicObject).%New()
		set appJson.ID=dataId
		do ##class(BILL.Interface.Inside.AuthItemApply).SetOPRefAuthDTO(.appJson, jsonObj)
		set rtn=##class(BILL.Interface.Inside.AuthItemApply).SaveOPRefAuthCfgApply(appJson.%ToJSON())   //向权力系统发送申请
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

}
