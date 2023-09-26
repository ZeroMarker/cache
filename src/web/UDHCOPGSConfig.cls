Import SQLUser

Class web.UDHCOPGSConfig Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCOPGSConfig).ReadCFByGRowID("122", 2)
ClassMethod ReadCFByGRowID(GPRowID As %String, HospID As %String) As %String
{
	set rtn=0
	quit:(GPRowID="") 100
	
	set GSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(GPRowID, HospID)
	
	if (+GSRowID=0) {
		&SQL(
			INSERT INTO DHC_OPGroupSettings (
				GS_SSGroup_DR, GS_Hosp_DR
			)
			VALUES (
				:GPRowID, :HospID
			)
		)
		set rtn=SQLCODE
		if (+rtn) quit rtn_"^"_$g(%msg)
		set GSRowID=$g(%ROWID)
	}
	
	&SQL(SELECT * INTO PLIST() FROM DHC_OPGroupSettings WHERE %ID = :GSRowID)

	set myGSRowID=PLIST(1)
	set myFootFlag=(PLIST(2)="Y")
	set myRecLocFlag=(PLIST(3)="Y")
	set myPrtINVFlag=(PLIST(4)="Y")
	set myDateFrom=PLIST(5)
	set myDateTo=PLIST(6)
	set myAbortFlag=(PLIST(7)="Y")
	set myRefundFlag=(PLIST(8)="Y")
	set myPrtXMLName=PLIST(10)
	set myColPrtXMLName=PLIST(11)
	set myUseINVType=PLIST(19)
	set myInputOrdFlag=PLIST(20)
	set myPrtListFlag=PLIST(21)
	set myColPrtListFlag=PLIST(22)
	set myPrtEINVFlag=PLIST(23)        //GS_PrtEINVFlag 是否打印电子发票
	set myOneToManyFlag=PLIST(28)
	set myRegInvFlag=PLIST(29)
	set myInvDateFlag=PLIST(30)
	set myCardPayModeFlag=PLIST(31)
	set myReceiveFlag=PLIST(32)       //GS_ReceiveFlag +2018-05-18 ZhYW 日结汇总需要接收标识
	set myRegBillFlag=PLIST(33)       //GS_RegBillFlag +2018-05-31 ZhYW 挂号医嘱跟收费医嘱一起结算?
	
	set myGPDesc=$p($g(^SSU("SSGRP",GPRowID)),"^",1)
	set myStr=myGSRowID_"^"_myFootFlag_"^"_myRecLocFlag_"^"_myPrtINVFlag_"^"_myDateFrom
	set myStr=myStr_"^"_myDateTo_"^"_myAbortFlag_"^"_myRefundFlag_"^"_myGPDesc
	set myStr=myStr_"^"_myPrtXMLName_"^"_myColPrtXMLName_"^"_myUseINVType_"^"_myInputOrdFlag
	set myStr=myStr_"^"_myPrtListFlag_"^"_myColPrtListFlag_"^"_myOneToManyFlag
	set myStr=myStr_"^"_myRegInvFlag_"^"_myInvDateFlag_"^"_myCardPayModeFlag
	set myStr=myStr_"^"_myReceiveFlag_"^"_myRegBillFlag_"^"_myPrtEINVFlag
	
	quit rtn_"^"_myStr
}

/// Description: 获取费别的支付方式
/// Debug: w ##class(web.UDHCOPGSConfig).ReadPMByINSRowID(1, 2)
ClassMethod ReadPMByINSRowID(insTypeId As %String, hospId As %String) As %String
{
	set myPMStr=""
	quit:(insTypeId="") myPMStr
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_OP_AdmReaPayMode", hospId)
	
	set myPPRowID=0
	while($o(^DHCOPPARCONPMODEi(0,"ADMRDR",insTypeId,myPPRowID))) {
		set myPPRowID=$o(^DHCOPPARCONPMODEi(0,"ADMRDR",insTypeId,myPPRowID))
		set myPPData=$g(^DHCOPPARCONPMODE(myPPRowID))
		continue:(myPPData="")
		set myHospDR=$p(myPPData,"^",8)
		continue:(myHospDR'=defHospId)
		set myPMRowID=$p(myPPData,"^",2)
		set myPMStr=myPMStr_myPMRowID_"^"
	}
	
	quit myPMStr
}

/// Debug: w ##class(web.UDHCOPGSConfig).ReadPMByGPRowID(46, 2)
ClassMethod ReadPMByGPRowID(GPRowID As %String, HospID As %String) As %String
{
	quit:(GPRowID="") 101_$c(2)_""
	
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(GPRowID, HospID)
	set rtn=##class(web.UDHCOPGroupSettings).SELECT(myGSRowID)
	quit:(rtn) rtn_$c(2)_"^"
	
	set myPMStr=""
	set mySub=0
	while($o(^DHCOPGS("GS",myGSRowID,"PM",mySub))) {
		set mySub=$o(^DHCOPGS("GS",myGSRowID,"PM",mySub))
		set myGSPMData=$g(^DHCOPGS("GS",myGSRowID,"PM",mySub))
		continue:(myGSPMData="")
		set myPM=$p(myGSPMData,"^",1)
		set myPMStr=myPM_"^"_myPMStr
	}
	
	set myPMStr="^"_myPMStr
	
	quit rtn_$c(2)_myPMStr
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOPGSConfig","ReadPMConfig","122","2")
Query ReadPMConfig(GPRowID As %String, HospID As %String, LangId As %String = "") As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMCode:%String,CTPMDesc:%String,PMRowID:%String,DefFlag:%String,RPFlag:%String,INVPrtFlag:%String,PMPDFlag:%String,PMOPCFlag:%String,PMOPRegFlag:%String,PMOPRefundFlag:%String,PMHotKey:%String,PMDEPRefundFlag:%String")
{
}

ClassMethod ReadPMConfigExecute(ByRef qHandle As %Binary, GPRowID As %String, HospID As %String, LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(GPRowID, HospID)
	if (myGSRowID="")  quit $$$OK
	
	kill PMList
	set maxIndex=99999
	set myPMSub=0
	while($o(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))) {
		set myPMSub=$o(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
		set myGSPMData=$g(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
		continue:(myGSPMData="")
		set myPMRowID=myGSRowID_"||"_myPMSub
		set myCTPMRowID=$p(myGSPMData,"^",1)
		continue:(myCTPMRowID="")
		set myCTPMCode=$p($g(^CT("CTPM",myCTPMRowID)),"^",1)
		set myCTPMDesc=$p($g(^CT("CTPM",myCTPMRowID)),"^",2)
		set myCTPMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myCTPMDesc, LangId)
		set myDefFlag=$p(myGSPMData,"^",4)
		set myINVPrtFlag=$p(myGSPMData,"^",5)
		set myRPFlag=$p(myGSPMData,"^",6)
		set myPMPDFlag=$p(myGSPMData,"^",7)          //预交金
		set myPMOPCFlag=$p(myGSPMData,"^",8)         //收费
		set myPMOPRegFlag=$p(myGSPMData,"^",9)       //挂号
		set myPMOPRefundFlag=$p(myGSPMData,"^",10)   //退费
		set myPMSequence=$p(myGSPMData,"^",11)       //顺序号
		set myPMHotKey=$p(myGSPMData,"^",12)         //快捷键
		set myPMDEPRefundFlag=$p(myGSPMData,"^",15)   //退预交金
		if (myPMSequence="") set myPMSequence=$i(maxIndex)
		set PMList(myPMSequence)=$lb(myCTPMRowID,myCTPMCode,myCTPMDesc,myPMRowID,myDefFlag,myRPFlag,myINVPrtFlag,myPMPDFlag,myPMOPCFlag,myPMOPRegFlag,myPMOPRefundFlag,myPMHotKey,myPMDEPRefundFlag)
	}
	
	set seqIdx=0
	while($o(PMList(seqIdx))) {
		set seqIdx=$o(PMList(seqIdx))
		set Data=$g(PMList(seqIdx))
		do OutputPMConfig
	}
	
	kill PMList
	quit $$$OK
	
OutputPMConfig
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Table: DHC_OPGSRecLoc
/// Debug: w ##class(web.UDHCOPGSConfig).ReadRLByGPLoc("15","511")
ClassMethod ReadRLByGPLoc(GSRowID As %String, CTLocId As %String) As %String
{
	set myRecStr=""
	set mySub=0
	while($o(^DHCOPGS("GS",GSRowID,"RL",mySub))) {
		set mySub=$o(^DHCOPGS("GS",GSRowID,"RL",mySub))
		set mySubData=$g(^DHCOPGS("GS",GSRowID,"RL",mySub))
		continue:(mySubData="")
		set myLoadLocDR=$p(mySubData,"^",5)     //RL_LoadLoc_DR
		continue:(myLoadLocDR'=CTLocId)
		set myActFlag=$p(mySubData,"^",4)
		continue:(myActFlag="N")
		set myRecLocDR=$p(mySubData,"^",1)      //RL_RecLoc_DR
		continue:(myRecLocDR="")
		set myRecStr=$s((myRecStr=""):myRecLocDR,1:(myRecStr_"^"_myRecLocDR))
	}
	quit myRecStr
}

/// Description: 返回值判断原则
///  ="":不过滤接收科室，<>"":过滤接收科室
/// Debug: w ##class(web.UDHCOPGSConfig).ReadRLByGPRowID(238, 2, 1)
ClassMethod ReadRLByGPRowID(GPRowID As %String, HospID As %String, CTLocId As %String) As %String
{
	set myRecStr=""
	quit:(GPRowID="") myRecStr
	
	set myGSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(GPRowID, HospID)
	quit:(myGSRowID="") myRecStr
	
	set myRecFlag=$p($g(^DHCOPGS("GS",myGSRowID)),"^",2)    //GS_RecLocFlag 按照接收科室接收医嘱标识
	quit:(myRecFlag'="Y") myRecStr
	
	set myRecStr=..ReadRLByGPLoc(myGSRowID, CTLocId)	
	//要求按照接收科室来接收医嘱?同时没有配置接收科室时
	if ((myRecStr="")||(myRecStr="^")) {
		set myRecStr="NoRecLoc"
	}
	
	quit myRecStr
}

/// Description: 判断该安全组是否有卡消费权限(科室卡消费调用判断)
/// Return: Y:有, N:无
/// Debug: w ##class(web.UDHCOPGSConfig).GetGroupCPPFlag(196, 2)
ClassMethod GetGroupCPPFlag(GPRowID As %String, HospID As %String) As %String
{
	set rtn="N"
	quit:(GPRowID="") rtn
	set GSRowID=##class(web.UDHCOPGSConfig).GetGSRowID(GPRowID, HospID)
	quit:(GSRowID="") rtn
	set PayModeDR=$o(^CT("CTPM",0,"Code","CPP",0))
	quit:(PayModeDR="") rtn
	set myPMSub=$o(^DHCOPGSi("GS",0,"CTPMDR",PayModeDR,GSRowID,"PM",0))
	quit:(myPMSub="") rtn
	set rtn=$p(^DHCOPGS("GS",GSRowID,"PM",myPMSub),"^",8)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-01-08
/// Description: 取安全组配置的支付方式
/// Input:  GPRowID: SS_Group.RowId
/// 		TypeFlag="DEP" 预交金
/// 		TypeFlag="FEE" 收费	--默认
/// 		TypeFlag="REG" 挂号
/// 		TypeFlag="REF" 退费
///         DefFlag: 是否需要设置默认标识
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOPGSConfig","ReadGSINSPMList",238, 2, "1", "REF")
Query ReadGSINSPMList(GPRowID As %String, HospID As %String, TypeFlag As %String = "", InsType As %String = "", DefFlag As %String = "Y") As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMDesc:%String,CTPMCode:%String,RPFlag:%String,INVPrtFlag:%String,selected:%Boolean")
{
}

ClassMethod ReadGSINSPMListExecute(ByRef qHandle As %Binary, GPRowID As %String, HospID As %String, TypeFlag As %String = "", InsType As %String = "", DefFlag As %String = "Y") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set myPMStr=..ReadPMByINSRowID(InsType, HospID)
	set num=0
	set mySelFlag=0
	set rset=##class(%ResultSet).%New("web.UDHCOPGSConfig:ReadPMConfig")
	do rset.Execute(GPRowID, HospID)
	while (rset.Next()) {
		set num=$i(num)
		set myTypeFlag=$case(TypeFlag, "DEP":rset.Data("PMPDFlag"), "REG":rset.Data("PMOPRegFlag"), "REF":rset.Data("PMOPRefundFlag"), "RDEP":rset.Data("PMDEPRefundFlag"), :rset.Data("PMOPCFlag"))
	 	set myGSPMRowID=rset.Data("PMRowID")
	 	continue:((myGSPMRowID="")||(myTypeFlag'="Y"))
	 	set myCTPMRowID=rset.Data("CTPMRowID")
	 	continue:((myPMStr'="")&&(("^"_myPMStr_"^")'[("^"_myCTPMRowID_"^")))
	 	set myCTPMCode=rset.Data("CTPMCode")
	 	set myCTPMDesc=rset.Data("CTPMDesc")
	 	set myRPFlag=rset.Data("RPFlag")
	 	set myINVPrtFlag=rset.Data("INVPrtFlag")
	 	set mySelect="false"
	 	if (DefFlag="Y") {
		 	set myDefFlag=rset.Data("DefFlag")
		 	set mySelect=$case(myDefFlag, "Y":"true", :"false")
		 	set mySelFlag=$case(myDefFlag, "Y": 1, :mySelFlag)
		 	if ((("^"_myPMStr_"^")[("^"_myCTPMRowID_"^"))) {
			 	if ((num=1)&&(mySelFlag=0)) {
				 	set mySelect="true"
				}
			}
		}
		do OutputGSINSPMList
	}
	
	quit $$$OK
	
OutputGSINSPMList
	set Data=$lb(myCTPMRowID,myCTPMDesc,myCTPMCode,myRPFlag,myINVPrtFlag,mySelect)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2020-05-20
/// Description: 获取安全组功能配置RowId
/// Table: DHC_OPGroupSettings
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: DHCOPGroupSettings.RowId
/// Debug: w ##class(web.UDHCOPGSConfig).GetGSRowID(122, 2)
ClassMethod GetGSRowID(groupId As %String, hospId As %String) As %String
{
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_GroupAuth", hospId)
	set gsCfgId=""
	set rowId=0
	while ($o(^DHCOPGSi("GS",0,"GSDR",groupId,rowId))&&(gsCfgId="")) {
		set rowId=$o(^DHCOPGSi("GS",0,"GSDR",groupId,rowId))
		set hospDR=$p($g(^DHCOPGS("GS",rowId)),"^",33)
		continue:(hospDR'=defHospId)
		set gsCfgId=rowId
	}
	
	quit gsCfgId
}

/// Creator: ZhYW
/// CreateDate: 2020-05-20
/// Description: 取某个安全组收费默认的支付方式
/// Table: DHC_OPGroupSettings
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
/// Return: DHCOPGroupSettings.RowId
/// Debug: w ##class(web.UDHCOPGSConfig).GetGSDefPayMode(122, 2)
ClassMethod GetGSDefPayMode(groupId As %String, hospId As %String) As %String
{
    quit:(+groupId=0) "^"
    
    set myGSRowID=..GetGSRowID(groupId, hospId)
    quit:(+myGSRowID=0) "^"
    
	set paymId=""
    set myPMSub=0
    while($o(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))&&(paymId="")) {
	    set myPMSub=$o(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
	    set myGSPMData=$g(^DHCOPGS("GS",myGSRowID,"PM",myPMSub))
  		continue:(myGSPMData="")
		set myDefFlag=$p(myGSPMData,"^",4)
		continue:(myDefFlag'="Y")
    	set myPayMDR=$p(myGSPMData,"^",1)
    	set paymId=myPayMDR
    }
	
	set paymDesc=$s((+paymId'=0):$p($g(^CT("CTPM",paymId)),"^",2),1:"")
	
    quit paymId_"^"_paymDesc
}

/// Creator: Lid
/// CreateDate: 2020-06-09
/// Description: 取附属信息--以后做配置
/// Input: groupId--安全组,hospId-院区
/// Table: 
/// Debug: w ##class(web.UDHCOPGSConfig).GetAdditionalDataCfg("", "")
ClassMethod GetAdditionalDataCfg(groupId As %String, hospId As %String) As %String
{
	/// 以后做配置，先定义几种常用的
	/// 代码：
	///		CheckNO --支票号
	///		CheckDate -- 支票日期
	///		Bank --银行
	///		PayAccNO --支付账户号/银行卡号
	///		PayCard --支付卡卡号，预交金支付时传账号rowid
	///		HCP --合同单位
	/// 组件类型：
	///		textbox --文本框--默认
	///		numberbox --数字框
	///		datebox --日期
	///		combobox --下拉框
	
	//rtn="附属项代码^附属项描述^组件类型!附属项代码^附属项描述^组件类型!..."
	set rtn="CheckNO^支票号^numberbox"
	set rtn=rtn_"!"_"CheckDate^支票日期^datebox"
	set rtn=rtn_"!"_"Bank^银行^combobox"
	set rtn=rtn_"!"_"PayAccNO^账户号^numberbox"
	set rtn=rtn_"!"_"PayCard^支付卡号^textbox"
	set rtn=rtn_"!"_"HCP^公费单位^combobox"
   	
    quit rtn
}

/// Creator: Lid
/// CreateDate: 2020-06-09
/// Description: 取支付方式附属信息--以后做配置，先写死
/// Input: 
/// Table: 
/// Debug: w ##class(web.UDHCOPGSConfig).GetAdditionalData(8)
ClassMethod GetAdditionalData(payMode As %String, groupId As %String, hospId As %String) As %String
{
	/// 根据支付方式取其对应的附属信息：
	/// 比如：	支票--支票号、银行、支票日期、对方账户号
	///			合同单位记账--公费单位
	///			银行卡--银行、银行卡号
	
	/// 代码：
	///		CheckNO --支票号
	///		CheckDate -- 支票日期
	///		Bank --银行
	///		PayAccNO --支付账户号/银行卡号
	///		PayCard --支付卡卡号，预交金支付时传账号rowid
	///		HCP --公费单位
	/// 是否必填项目：
	///		Y -- 是
	///		N -- 否
	
	set rtn=""
    quit:(+payMode=0) rtn
    set payMCode=$p(^CT("CTPM",payMode),"^",1)
    set payMCode=$zcvt(payMCode,"U")
    
    if (payMCode="ZP") set rtn="CheckNO!支票号!Y^CheckDate!支票日期!Y^PayAccNO!账户号!N^Bank!银行!N"
    if (payMCode="CCP") set rtn="HCP!公费单位!Y"
    if (payMCode="YHK") set rtn="Bank!银行!Y^PayAccNO!账户号!N"
   	if (payMCode="TJDJK") set rtn="PayCard!卡号!Y"  //+2022-08-19 ZhYW 体检代金卡
   	
    quit rtn
}

/// Creator: ZhYW
/// CreateDate: 2020-08-17
/// Description: 取安全组的支付方式RowId串
/// Table: DHC_OPGroupSettings
/// Input: groupId:SS_Group.RowId, hospId:CT_Hospital.RowId
///        typeFlag: "DEP"(预交金)
/// 	  			 "FEE"(收费	-- 默认)
/// 				 "REG"(挂号)
/// 				 "REF"(退费)
/// Return: 
/// Debug: w ##class(web.UDHCOPGSConfig).GetGSPayModeStr(239, 2, "REF")
ClassMethod GetGSPayModeStr(groupId As %String, hospId As %String, typeFlag As %String) As %String
{
	set paymIdStr=""
    quit:(+groupId=0) paymIdStr
    
	set rset=##class(%ResultSet).%New("web.UDHCOPGSConfig:ReadPMConfig")
	do rset.Execute(groupId, hospId)
	while (rset.Next()) {
		set myTypeFlag=$case(typeFlag, "DEP":rset.Data("PMPDFlag"), "REG":rset.Data("PMOPRegFlag"), "REF":rset.Data("PMOPRefundFlag"), :rset.Data("PMOPCFlag"))
	 	set myGSPMRowID=rset.Data("PMRowID")
	 	continue:((myGSPMRowID="")||(myTypeFlag'="Y"))
	 	set myCTPMRowID=rset.Data("CTPMRowID")
	 	set paymIdStr=$s((paymIdStr=""):myCTPMRowID,1:(paymIdStr_"^"_myCTPMRowID))
	}
	
    quit paymIdStr
}

/// Creator: ZhYW
/// CreatDate: 2022-09-14
/// Description: 获取对照的门诊退费支付方式
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.UDHCOPGSConfig).GetContraRefPMStr("OPCHRG.OPRefd.TFZFFSYSFZFFSDZ", 2, 2)
ClassMethod GetContraRefPMStr(cfgCode As %String, hospId As %String, paymId As %String) As %String
{
	set myPMStr=""
	quit:((cfgCode="")||(paymId="")) myPMStr
	
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute(cfgCode, paymId, "", hospId)
	while (rset.Next()) {
		set id=rset.Get("ID")
		set myPMStr=$s((myPMStr=""):id,1:(myPMStr_"^"_id))
	}
	
	quit myPMStr
}

/// Creator: ZhYW
/// CreatDate: 2022-09-14
/// Description: 取安全组配置的支付方式
/// Input:  GPRowID: SS_Group.RowId
/// 		TypeFlag="DEP" 预交金
/// 		TypeFlag="REG" 挂号
/// 		TypeFlag="REF" 退费
///         TypeFlag="RDEP" 退预交金
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOPGSConfig","QryGSContraRefPMList","239","2","REF","OPCHRG.OPRefd.TFZFFSYSFZFFSDZ","")
Query QryGSContraRefPMList(GPRowID As %String, HospID As %String, TypeFlag As %String = "", CfgCode As %String = "", PayMID As %String = "", LangId As %String = "") As websys.Query(ROWSPEC = "CTPMRowID:%String:支付方式ID,CTPMDesc:%String:支付方式,CTPMCode:%String:支付方式代码,selected:%Boolean")
{
}

ClassMethod QryGSContraRefPMListExecute(ByRef qHandle As %Binary, GPRowID As %String, HospID As %String, TypeFlag As %String = "", CfgCode As %String = "", PayMID As %String = "", LangId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if (LangId="")&&($d(%session)) {
		set LangId=%session.Get("LOGON.LANGID")
	}
	
	if (+PayMID'=0) {
		&SQL(
			SELECT %ID, CTPM_Code, CTPM_Desc, CTPM_DateFrom, CTPM_DateTo
			INTO :myCTPMRowID, :myCTPMCode, :myCTPMDesc, :myCTPMDateFrom, :myCTPMDateTo
			FROM CT_PayMode
			WHERE %ID = :PayMID
		)
		if ((myCTPMDateFrom'>+$h)&&((myCTPMDateTo="")||(myCTPMDateTo'<+$h))) {
			set myCTPMDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", myCTPMDesc, LangId)
			set mySelect="true"
			do OutputContraRefPMList
		}
	}
	
	set myPMStr=..GetContraRefPMStr(CfgCode, HospID, PayMID)
	set rset=##class(%ResultSet).%New("web.UDHCOPGSConfig:ReadPMConfig")
	do rset.Execute(GPRowID, HospID)
	while (rset.Next()) {
		set myTypeFlag=$case(TypeFlag, "DEP":rset.Data("PMPDFlag"), "REG":rset.Data("PMOPRegFlag"), "REF":rset.Data("PMOPRefundFlag"), "RDEP":rset.Data("PMDEPRefundFlag"), :"")
	 	set myGSPMRowID=rset.Data("PMRowID")
	 	continue:((myGSPMRowID="")||(myTypeFlag'="Y"))
	 	set myCTPMRowID=rset.Data("CTPMRowID")
	 	//过滤传入的支付方式,因为在上面已经输出; 没有配置对照的支付方式时,只输出传入的支付方式
	 	continue:((PayMID'="") && ((PayMID=myCTPMRowID) || (("^"_myPMStr_"^")'[("^"_myCTPMRowID_"^"))))  
	 	set myCTPMCode=rset.Data("CTPMCode")
	 	set myCTPMDesc=rset.Data("CTPMDesc")
	 	set mySelect="false"
		do OutputContraRefPMList
	}
	
	quit $$$OK
	
OutputContraRefPMList
	set Data=$lb(myCTPMRowID,myCTPMDesc,myCTPMCode,mySelect)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

}
