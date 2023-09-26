Class web.DHCBL.CARD.UCardAccManagerInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod SaveAccMInfo(AccObj As web.DHCEntity.PCA.AccManager, AccPreDepObj As web.DHCEntity.PCA.AccPreDeposit, CardTypeId As %String, RegConfig As web.DHCEntity.PCA.CardTypeConfig, ETPRowID As %String = "") As %String
{
	;保存
	;;	6. 保存患者帐户信息
	;;	6.1  保存预交金信息
	set $zt="ERROR^DHCSSERR"
	new (AccObj, AccPreDepObj, CardTypeId, RegConfig, ETPRowID)
	
	set rtn=0
	set AccMRowID=""
	set PreDepRowID=""
	
	//判断发卡时此类卡 此登记号的账户关系
	set AccObj.PAPMINo=##class(web.PAPatMas).GetRegistration(AccObj.PAPMIRowID)
	
	set myCARelation=RegConfig.CardAccountRelation		;$p(^DHCCARDTYPEDef(CardTypeId),"^",24)			;CTD_CardAccountRelation
	//1 不建立关联，直接退出
	quit:((myCARelation="N")||(myCARelation="")) rtn_"^"_AccMRowID_"^"_PreDepRowID
	
	//+2023-04-07 ZhYW 获取卡类型授权医院需要建账户的医院
	kill HospIdAry
	set HospId=0
	while($o(^User.BDPMappingHospI("HospRef","DHC_CardTypeDef",CardTypeId,HospId))) {
		set HospId=$o(^User.BDPMappingHospI("HospRef","DHC_CardTypeDef",CardTypeId,HospId))
		set DefHospId=##class(web.UDHCAccManageCLS).GetAccMDefHospId(HospId)
		continue:(+DefHospId=0)||($d(HospIdAry(DefHospId)))
		set HospIdAry(DefHospId)=""
		set rtnValue=..SaveSingleAccMInfo(AccObj, AccPreDepObj, CardTypeId, RegConfig, DefHospId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set myAccMRowID=$p(rtnValue,"^",2)
		//只有是在本院建卡时才充值
		if ((myAccMRowID>0)&&(HospId=AccObj.HospitalID)) {
			set AccMRowID=myAccMRowID      //本院建的账户
			//获取充值预交金需要的参数信息
			set myPreInfo=..GetPreDepInfo(AccObj, AccPreDepObj, CardTypeId)
			set myPrePayMInfo=..GetPreDepPayMInfo(AccPreDepObj)
			//充值，金额大于0时调用预交金充值接口
			if (+AccPreDepObj.amt>0) {
				set $p(myPrePayMInfo,"^",12)=ETPRowID
				set rtnValue=##class(web.UDHCAccAddDeposit).AddDeposit(myAccMRowID, myPreInfo, myPrePayMInfo)			
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) {
					set rtn=rtnValue
					quit
				}
				set PreDepRowID=$p(rtnValue,"^",2)
			}
		}
	}
	
	quit rtn_"^"_AccMRowID_"^"_PreDepRowID
}

/// 把对象 转化为信息
ClassMethod GetPreDepInfo(AccObj As web.DHCEntity.PCA.AccManager, AccPreDepObj As web.DHCEntity.PCA.AccPreDeposit, CardTypeId As %String) As %String
{
	new (AccObj, AccPreDepObj, CardTypeId)
	
	set Password=""    //AccObj.PassWord
	set PDType="P"
	set InitPDRowId=""
	set DepTypeId=""
	set AccPayInvId=""
	
	set myrtn=AccPreDepObj.amt
	set myrtn=myrtn_"^"_AccPreDepObj.UserDR
	set myrtn=myrtn_"^"_AccPreDepObj.BackReason
	set myrtn=myrtn_"^"_Password
	set myrtn=myrtn_"^"_PDType
	set myrtn=myrtn_"^"_AccPreDepObj.Remark
	set myrtn=myrtn_"^"_AccObj.HospitalID
	set myrtn=myrtn_"^"_InitPDRowId
	set myrtn=myrtn_"^"_DepTypeId
	set myrtn=myrtn_"^"_AccPayInvId
	set myrtn=myrtn_"^"_AccObj.CardNo
	set myrtn=myrtn_"^"_CardTypeId
	quit myrtn
}

/// 把对象 转化为信息
ClassMethod GetPreDepPayMInfo(AccPreDepObj As web.DHCEntity.PCA.AccPreDeposit) As %String
{
	new (AccPreDepObj)
	
	set myrtn=AccPreDepObj.PayMode		                ;+PayModeid
	set myrtn=myrtn_"^"_AccPreDepObj.Bank		        ;+Bankid
	set myrtn=myrtn_"^"_AccPreDepObj.CardChequeNo		;+CardChequeNo
	set myrtn=myrtn_"^"_AccPreDepObj.BankCardType		;+BankCardTypeid
	set myrtn=myrtn_"^"_AccPreDepObj.PayCompany		    ;+Company
	set myrtn=myrtn_"^"_AccPreDepObj.ChequeDate		    ;+ChequeDate
	set myrtn=myrtn_"^"_AccPreDepObj.PayAccNo		    ;+PayAccNo
	set myrtn=myrtn_"^"_AccPreDepObj.amt

	quit myrtn
}

/// Creator: ZhYW
/// CreatDate: 2023-04-07
/// Description: 建单个账户
/// Input: CardTypeId:DHC_CardTypeDef.RowId
/// Return: 
/// Debug: w ##class(web.DHCBL.CARD.UCardAccManagerInfo).SaveSingleAccMInfo(136, "", "") 
ClassMethod SaveSingleAccMInfo(AccObj As web.DHCEntity.PCA.AccManager, AccPreDepObj As web.DHCEntity.PCA.AccPreDeposit, CardTypeId As %String, RegConfig As web.DHCEntity.PCA.CardTypeConfig, HospId As %String) As %String
{
	set $zt="ERROR^DHCSSERR"
	new (AccObj, AccPreDepObj, CardTypeId, RegConfig, HospId)
	
	set rtn=0
	set AccMRowID=""
	
	set CARelation=RegConfig.CardAccountRelation    //CTD_CardAccountRelation
	quit:((CARelation="N")||(CARelation="")) rtn_"^"_AccMRowID   //不建立关联，直接退出
	
	set AccMCreatMode=$p($g(^DHCCARDTYPEDef(CardTypeId)),"^",45)    //DHC_CardTypeDef.CTD_AccMCreatMode 账户创建模式(P:按患者主索引建账户, C:按卡建账户)
	if (AccMCreatMode="C") {
		set AccMRowID=..GetAccMRowIDByCard(AccObj.PAPMIRowID, AccObj.CardNo, CardTypeId, HospId)  //根据卡取账户
	}else {
		set AccMRowID=..GetAccMRowIDByPAPMI(AccObj.PAPMIRowID, HospId)     //根据患者主索引取账户
	}
	quit:((CARelation="CL")&&(AccMRowID="")) rtn_"^"_AccMRowID
	quit:(+AccMRowID>0) rtn_"^"_AccMRowID
	
	set myAccM=##class(User.DHCAccManager).%New()
	quit:('$isObject(myAccM)) -1_"^"_"创建对象失败"
	
	set AccountNo=##class(web.UDHCAccManageCLS).getAccountNo(AccObj.PAPMINo)
	//此账户号码存在
	quit:($d(^DHCACDi("AccM",0,"AccountNo",AccountNo))) -211_"^"_AccMRowID		    //账户号码已存在
	set myAccM.AccMAccountNo=AccountNo		                                        //AccM_AccountNo
	do myAccM.AccMPAPMIDRSetObjectId(AccObj.PAPMIRowID)	                            //AccM_PAPMI_DR
	set myAccM.AccMPAPMINo=AccObj.PAPMINo			                                //AccM_PAPMINo
	set myAccM.AccMCardNo=AccObj.CardNo				                                //AccM_CardNo
	do myAccM.AccMCUserDRSetObjectId(AccObj.UserDR)                                 //AccM_CUser_DR
	set myAccM.AccMOCDate=AccObj.OCDate
	set myAccM.AccMOCTime=AccObj.OCTime
	set myAccM.AccMPassWord=AccObj.PassWord			                                 //AccM_PassWord
	set myAccM.AccMAccStatus="N"			                                         //AccM_AccStatus
	set myAccM.AccMDepPrice=AccObj.Depprice			                                 //AccM_DepPrice
	set myAccM.AccMType=$s((AccObj.AccountType'=""):AccObj.AccountType,1:"P")        //AccM_Type
	do myAccM.AccMCredTypeDRSetObjectId(AccObj.CredType)                             //AccM_CredType_DR
	set myAccM.AccMCredNo=AccObj.CredNo				                                 //AccM_CredNo
	do myAccM.AccMCardTypeDRSetObjectId(CardTypeId)                                  //AccM_CardTypeDR
	set myAccM.AccMCreatMode=AccMCreatMode                                           //AccM_CreatMode
	do myAccM.AccMHospDRSetObjectId(HospId)                                          //AccM_Hosp_DR
	set sc=myAccM.%Save()
	do myAccM.%Close()
	if ($system.Status.IsError(sc))	{
		do $system.Status.DisplayError(sc)
		set rtn=$system.Status.GetErrorCodes(sc)
		quit rtn_"^"_AccMRowID
	}
	
	set AccMRowID=myAccM.%Id()
	
	quit rtn_"^"_AccMRowID
}

/// Creator: ZhYW
/// CreatDate: 2023-04-07
/// Description: 根据患者获取账户信息ID  --  创建账户模式为"P"(按患者主索引建账户)时使用
/// Input: PatientId:PA_PatMas.RowId, HospId: 院区ID，如果是多院区，需要传院区组主院区ID
/// Return: DHC_AccManager.RowId
/// Debug: w ##class(web.DHCBL.CARD.UCardAccManagerInfo).GetAccMRowIDByPAPMI(136, 2)
ClassMethod GetAccMRowIDByPAPMI(PatientId As %String, HospId As %String) As %String
{
	new (PatientId, HospId)
	
	set AccMRowID=""
	quit:(PatientId="") AccMRowID
	
	set AccId=0
	while($o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))) {
		set AccId=$o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))
		set AccData=$g(^DHCACD("AccM",AccId))
	 	set ActiveFlag=$p(AccData,"^",13)
	 	continue:(" N S "'[(" "_ActiveFlag_" "))
	 	set HospDR=$p(AccData,"^",24)     //AccM_Hosp_DR
	 	continue:(HospDR'=HospId)
	 	set AccCreatMode=$p(AccData,"^",23)
	 	continue:(AccCreatMode'="P")      //过滤不是按患者主索引建的账户
	 	set AccMRowID=AccId
	 	quit
	}
	
	quit AccMRowID
}

/// Creator: ZhYW
/// CreatDate: 2022-12-05
/// Description: 根据卡获取账户ID -- 创建账户模式为"C"(按卡建账户)时使用
/// Input: PatientId:PA_PatMas.RowId, CardNo:卡号, CardTypeId:DHC_CardTypeDef.RowId,
///        HospId: CT_Hospital.RowId，如果是多院区，需要传院区组主院区ID 
/// Return: DHC_AccManager.RowId
/// Debug: w ##class(web.DHCBL.CARD.UCardAccManagerInfo).GetAccMRowIDByCard(136, "000000001", 2, 2)
ClassMethod GetAccMRowIDByCard(PatientId As %String, CardNo As %String, CardTypeId As %String, HospId As %String) As %String
{
	new (PatientId, CardNo, CardTypeId, HospId)
	
	set AccMRowID=""
	quit:(PatientId="") AccMRowID
	
	set AccId=0
	while($o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))) {
		set AccId=$o(^DHCACDi("AccM",0,"PAPMI",PatientId,AccId))
		set AccData=$g(^DHCACD("AccM",AccId))
	 	set ActiveFlag=$p(AccData,"^",13)
	 	continue:(" N S "'[(" "_ActiveFlag_" "))
	 	set HospDR=$p(AccData,"^",24)          //AccM_Hosp_DR
	 	continue:(HospDR'=HospId)
	 	set AccCreatMode=$p(AccData,"^",23)
	 	continue:(AccCreatMode'="C")           //过滤不是按卡建的账户
	 	set AccCardNo=$p(AccData,"^",4)        //AccM_CardNo
	 	continue:(AccCardNo'=CardNo)
	 	set AccCardTypeDR=$p(AccData,"^",22)   //AccM_CardTypeDR
	 	continue:(AccCardTypeDR'=CardTypeId)   //按卡类型过滤
	 	set AccMRowID=AccId
	 	quit
	}
	
	quit AccMRowID
}

}
