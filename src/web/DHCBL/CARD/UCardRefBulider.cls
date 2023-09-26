/// 对于卡操作的 类调度
Class web.DHCBL.CARD.UCardRefBulider Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// w ##class(web.DHCBL.CARD.UCardRefBulider).CancelCardInfo(639,A,$p(^tmpgry("CancelCardInfo"),",",3),"")
ClassMethod CancelCardInfo(UserDR As %String, sFlag As %String, CardStatusChangeInfo As %String, ExpStr As %String) As %String
{
	;CardINVRowID, UserDR, sFlag
	s myrtn=0
	s ^tmpgry("CancelCardInfo")=UserDR_","_sFlag_","_CardStatusChangeInfo_","_ExpStr
	
	set StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	do StatusInfo.XMLDeserialize(.StatusInfo,CardStatusChangeInfo)
	s HospitalID=$p(ExpStr,"^",1)
	b ;验证卡是否挂上账户
	;校验数据
	s IsSameAccFlag="",IsSameAccCardNo=""
	s myrtn=..CheckCardStatus(StatusInfo,.IsSameAccFlag,.IsSameAccCardNo)
	q:(+myrtn) myrtn
	
	ts
	
	s myCurDate=..%SysDate()
	s myCurTime=..%SysTime()
	
	;把原卡标注为回收
	;同时考虑 卡对应帐户的关系
	b
	;1.验证卡状态	
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if (status'="N")&&(..IsSpecNeedCancel(StatusInfo)=0)
	{
		set myrtn=-355 ;非正常卡不能挂失
	}


	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	
	;3.根据帐户配置,如果有帐户信息,更新帐户状态,退账户预交金
	Set InvInfo=""
	if ((myAccManageFLag="Y")&&(+myrtn=0)&&(..IsSpecNeedCancel(StatusInfo)=0)&&(IsSameAccFlag'="Y"))
	{
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"S")
		
		if (CardAccStatus.AccountID'="") {
			//set rtn=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			//set rtn=+rtn
			Set balance=##class(web.UDHCAccManageCLS).getAccBalance(CardAccStatus.AccountID)
			if (balance>0){
				Set myBackReason=""
				Set myPassword=""
				Set myPDType="R"
				Set myRemark=""
				Set myPayModeId=1   //"现金"
				Set myBankId=""
				Set myCardChequeNo=""
				Set myBankCardType=""
				Set myPayCompany=""
				Set myChequeDate=""
				Set myPayAccNo=""
				Set myPreInfo=balance_"^"_UserDR_"^"_myBackReason_"^"_myPassword_"^"_myPDType_"^"_myRemark_"^"_HospitalID
				Set myPrePayMStr=myPayModeId_"^"_myBankId_"^"_myCardChequeNo_"^"_myBankCardType_"^"_myPayCompany_"^"_myChequeDate_"^"_myPayAccNo_"^"_balance
				Set Ret=##class(web.UDHCAccAddDeposit).AddDeposit(CardAccStatus.AccountID, myPreInfo, myPrePayMStr)
				Set myrtn=$p(Ret,"^",1)
				Set InvInfo=$p(Ret,"^",7)
				b ;666
				if myrtn'=0{
					quit -1	
				}
			}
		}
	}
	;2.1  设置卡被回收
	if ((myCardRefFlag="Y")&&(+myrtn=0)) {
		set StatusInfo.ActiveFlag="R"
		
		set myrtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set myrtn=+myrtn
	}	
	b	;设置卡被回收
	;2.2 写挂失卡状态记录
	if ((myCardRefFlag="Y")&&(+myrtn=0)) {
			set StatusInfo.ActiveFlag="R"
		set myrtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set myrtn=+myrtn
		
	}
	b	;写挂失卡状态记录
	
	s myCardObj=##class(User.DHCCardRef).%OpenId(StatusInfo.CardID)
	
	s CardINVRowID=""
	i ($IsObject(myCardObj.CFCardINVPRTDR)){
		s CardINVRowID=myCardObj.CFCardINVPRTDR.%Id()
	}
	d myCardObj.%Close()
	
	i ((+myrtn=0)&&(CardINVRowID'="")) d
	.;作废原发票zhaocz
	.s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVPark(CardINVRowID, UserDR, sFlag)
	
	b	;作废原发票
	;INVRowID, UserDR, sFlag, CurDate, CurTime
	;产生负票
	i (+myrtn=0)&&(CardINVRowID'="") d
	.s myval=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancel(CardINVRowID, UserDR,sFlag,myCurDate, myCurTime,HospitalID)
	.s myrtn=+$p(myval,"^",1)
	.s myParkRowID=$p(myval,"^",2)
	
	b	;产生负票
	
	;写负支付模式
	i (+myrtn=0)&&(CardINVRowID'="") d
	.s myExpStr=$p(ExpStr,"^",2)
	.s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancelPayMode(CardINVRowID, myParkRowID, myCurDate, myCurTime, myExpStr)

	b	;Tro
	
	i +myrtn=0 d
	.tc
	.;掉用平台组方法
	.s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDRETREATCARDINFO",StatusInfo.CardID)
	.d ##Class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(StatusInfo.CardID)
	e  d
	.tro
	

	q myrtn_"$"_InvInfo_"$"_$g(myParkRowID)_"$"_IsSameAccCardNo_"$"_CardINVRowID
}

/// 验证卡的状态;包含:办理的业务
ClassMethod CheckCardStatus(StatusInfo As web.DHCEntity.PCA.CardStatusChange, ByRef IsSameAccFlag As %String = "", ByRef IsSameAccCardNo As %String = "") As %String
{
	s myrtn=0
	;1. 需要验证卡是否挂上账户
	s myCardRwoID=StatusInfo.CardID
	;^DHCCARD("CF",{CF_RowID})
	s myAccRowID=$p(^DHCCARD("CF",myCardRwoID),"^",1)
	
	i (myAccRowID'=""){
		//+2023-04-10 ZhYW 按患者主索引建的账户，不能结算账户，可以直接退卡; 按卡建的账户，先结算账户再退卡
		s myAccCreatMode=$p($g(^DHCACD("AccM",myAccRowID)),"^",23)
		s myAccFlag=$p($g(^DHCACD("AccM",myAccRowID)),"^",13)		 ;AccM_AccStatus
		i ((myAccCreatMode="C")&&(myAccFlag="N")){
			s myrtn=-373		;卡对应着有效账户,不能办理退卡,建议使用门诊账户结算
		}
	}
	;2. 其他
	if ..IsSpecNeedCancel(StatusInfo) {
		s myrtn=0
	}
	;3. 判断是否存在其他有效卡关联此账户
	if (myAccRowID'=""){
		//+2023-04-10 ZhYW 按患者主索引建的账户，不能结算账户，可以直接退卡; 按卡建的账户，先结算账户再退卡
		s IsSameAccFlag="N"
		s myAccCreatMode=$p($g(^DHCACD("AccM",myAccRowID)),"^",23)
		if (myAccCreatMode="P") {
			s IsSameAccFlag="Y"
		}else {
			s CardRowid=0 
			f  s CardRowid=$o(^DHCCARDi("CF",0,"AccNoDR",myAccRowID,CardRowid)) q:(CardRowid="")!(IsSameAccFlag="Y")  d
			.q:CardRowid=myCardRwoID
			.s ActiveFlag=$p(^DHCCARD("CF",CardRowid),"^",10)
			.q:ActiveFlag'="N"
			.s IsSameAccFlag="Y"
			.s IsSameAccCardNo=$p(^DHCCARD("CF",CardRowid),"^",2)
			.s myrtn=0
		}
	}
	q myrtn
}

/// 判断是否特殊可退情况:1. 挂失后作废的卡(即挂失后补卡),可以退卡退卡押金
ClassMethod IsSpecNeedCancel(StatusInfo As web.DHCEntity.PCA.CardStatusChange) As %String
{
	s myrtn=0
	s CardID=StatusInfo.CardID
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(CardID)
	;得到卡状态改变表,上一个状态是否是挂失后作废(SuspendToDepose STD)
	i status="D" {
		s CSCSub=""
		s CSCSub=$O(^DHCCARD("CF",CardID,"CSC",CSCSub),-1)
		i CSCSub'="" {
			s CurStatus=$p($g(^DHCCARD("CF",CardID,"CSC",CSCSub)),"^",3)
			i CurStatus="STD" s myrtn=1
		}
	}
	b 
	
	q myrtn
}

}
