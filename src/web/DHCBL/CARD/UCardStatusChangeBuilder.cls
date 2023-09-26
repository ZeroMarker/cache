Class web.DHCBL.CARD.UCardStatusChangeBuilder Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CardExechange(CardStatusChangeInfo As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardExechange(^ozrtest(100))
	set ^ozrtest(100)=CardStatusChangeInfo
	s StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	d StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	
	TStart
	set rtn=0
	;1.验证卡状态
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if status="D" {
		set rtn= -359 ;作废的卡不能再进行换卡
	}
	elseif status="S" {
		set rtn= -360 ;正常状态的卡不能进行换卡
	}
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)

	s myCurDate=..%SysDate()
	s myCurTime=..%SysTime()
	s UserDR=StatusInfo.UserDR
	s CardINVRowID=""
	
	;2.作废卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set rtn=+rtn
		s myrtn=rtn
		
		s CardINVRowID=$p(^DHCCARD("CF",StatusInfo.CardID),"^",17)
		;如果有票据金额时，作废金额
		i ((+myrtn=0)&&(CardINVRowID'="")) d
		.;作废原发票zhaocz
		.s sFlag="S"
		.;s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVPark(CardINVRowID, UserDR, sFlag)
		
		b	;作废原发票
		;INVRowID, UserDR, sFlag, CurDate, CurTime
		;产生负票
		i (+myrtn=0)&&(CardINVRowID'="") d
		.;s myval=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancel(CardINVRowID, UserDR,sFlag,myCurDate, myCurTime)
		.;s myrtn=+$p(myval,"^",1)
		.;s myParkRowID=$p(myval,"^",2)
		
		b	;产生负票
		
		;写负支付模式
		i (+myrtn=0)&&(CardINVRowID'="") d
		.s myExpStr=""
		.;s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CardINVCancelPayMode(CardINVRowID, myParkRowID, myCurDate, myCurTime, myExpStr)
		
	}
	
	;2.写作废卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"
		s myParkCardObj=##class(web.DHCEntity.PCA.CardStatusChange).%New()
		d myParkCardObj.XMLNodeDeserialize(.myParkCardObj,"DHCCardStatusChange",CardStatusChangeInfo)
		;换卡状态 Exchange
		s myParkCardObj.ActiveFlag="ETD"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(myParkCardObj)
		set rtn=+rtn
		d myParkCardObj.%Close()
	}
	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			if (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
		}
	}
	
	;4 . Addtional 新增卡计费
	;在原卡上Copy 计费记录
	if ((myCardRefFlag="Y")&&(+rtn=0)&&(CardINVRowID'="")) {
		//加入计费
		s sFlag="N"
		;s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).CopyOriginalINVInfo(CardINVRowID, UserDR,sFlag,myCurDate, myCurTime)
		s rtn=+myrtn
	}
	
	;4.新增卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="N"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).InsertCard(StatusInfo)
		set StatusInfo.CardID=$piece(rtn,"^",2)
		set rtn=+rtn
		
		
		
	}
	;5.写新增卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="E"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	;6.根据帐户配置,新增帐户状态
	if myAccManageFLag="Y" {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			if (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
		}
	}
	b	;Tro
	if (+rtn=0)
	{
		TCommit
		d ##Class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(StatusInfo.CardID)
	}
	else
	{
		TRollback
	}
	quit rtn
}

ClassMethod CardReissue(CardStatusChangeInfo As %String, CardINVInfo As %String) As %String
{
	set ^TMPZCZDFDFDD=$lb(CardStatusChangeInfo,CardINVInfo)
	//set ^ozrtest(101)=CardINVInfo
	s StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	d StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	s newCardID=""
	TStart
	set rtn=0
	;1.验证卡状态
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	if status="D" {
		set rtn=  -361 ;作废的卡不能再进行补卡
	}
	elseif status="N" {
		set rtn=  -362 ;正常状态的卡不能进行补卡
	}
	s SDateDiff=+$g(^DHCACDP("ParaSet","SDateDiff")) ;挂失与补卡的日期差
	s ReportLossDate=+##class(web.DHCBL.CARD.CardManager).GetCardStatusChangeDate(StatusInfo.CardID)
	s DateDiff=..%SysDate()-ReportLossDate
	if (DateDiff<SDateDiff)
	{
		set rtn=  -363 ;挂失与补卡的日期差
	}
	;卡前缀是否一致
	i ((+rtn=0)){
		s myCardNo=StatusInfo.ExchangeCardNo
		s myCardTypeDR=StatusInfo.CardTypeDefine
		s myCardTypePreNo=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^", 29)		;
		s myCardTypePreL=$length(myCardTypePreNo)
		s myCardNoPre=$e(myCardNo,1,myCardTypePreL)
		if (myCardTypePreNo'="")&&(myCardTypePreNo'=myCardNoPre)
		{
			s rtn=-371 ;卡前缀是否一致
		}
	}
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	;2.作废卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="D"		;补卡
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set rtn=+rtn
	}
	b	;2.写作废卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="STD"   ;补卡
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	b	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	if ((myAccManageFLag="Y")&&(+rtn=0)) {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				set rtn=+myStatusInfo
			}
		}
	}
	
	b	;4.新增卡
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="N"
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).InsertCard(StatusInfo)
		set StatusInfo.CardID=$piece(rtn,"^",2)
		set newCardID=StatusInfo.CardID
		set rtn=+rtn
	}
	;5.写新增卡状态记录
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
		set StatusInfo.ActiveFlag="RN"			;	补有效的卡
		set rtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set rtn=+rtn
	}
	b	;6.根据帐户配置,新增帐户状态
	if myAccManageFLag="Y" {
		set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			i (+myStatusInfo<0){
				set rtn=+myStatusInfo
			}
		}
	}
	//卡计费和打印发票操作
	s InvPrtRowID=""
	
	s myFareType= ""
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
	;7.卡计费
	if ((myCardRefFlag="Y")&&(+rtn=0)) {
	    //此卡是否计费等操作
		s myCardTypeDR = StatusInfo.CardTypeDefine
		if (myCardTypeDR'=""){
			s myobj=##class(User.DHCCardTypeDef).%OpenId(myCardTypeDR)
			//判断是否计费
			s myFareType = myobj.CTDFareType
			i (myobj.CTDFareType="C"){
				d myCardINVObj.XMLNodeDeserialize(.myCardINVObj, "CardINVPRT", CardINVInfo)
				;s myCardINVObj.CardDR=StatusInfo.CardID
				s myCardINVObj.PAPMIRowID=StatusInfo.PatientID
				s myCardINVObj.UserDR=StatusInfo.UserDR
				s myCardINVObj.Flag="N"
				s myCardINVObj.Date=..%SysDate()
				s myCardINVObj.Time=..%SysTime()
			}
			d myobj.%Close()
			//加入计费
			i (myFareType="C")
			{
				s rtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).SaveCardINVInfo(myCardINVObj,myCardTypeDR)
				s InvPrtRowID=$p(rtn,"^",2)
				set rtn=+rtn
				
				if (rtn=0)
				{
					//获取发票打印信息
					;set JSFunName="DHCP_PrintFun"
					set JSFunName="InvPrintNew"
					/*
					s ^Tomming("InvPrtRowID")=InvPrtRowID
					s ^Tomming("StatusInfo.CardID")=StatusInfo.CardID
					s ^Tomming("newCardID")=newCardID
					s updateInvPrtRowID=##class(User.DHCCardRef).%OpenId(newCardID)
					//                  ##class(User.DHCCardRef).%OpenId(
					if $IsObject(updateInvPrtRowID)
					{
						s updateInvPrtRowID.CFCardINVPRTDR=InvPrtRowID
						s sc=updateInvPrtRowID.%Save()
						If $$$ISERR(sc) {
							s ^Tomming("ISERR")=1
							d updateInvPrtRowID.%Close()
							Do $System.Status.DisplayError()
						}else{
							s ^Tomming("ISERR")=0
							d updateInvPrtRowID.%Close()
						}
					}
					else
					{
						s ^Tomming("NoObject")=1
					}
					*/
					&sql(update sqluser.dhc_cardref set cf_cardinvprt_dr=:InvPrtRowID where cf_rowid=:newCardID)
					//s rtn=##class(web.UDHCOPPrtInfo7).GetRegINVPRTData(JSFunName,InvPrtRowID)
				}
			}
		}
	}
	if (+rtn=0)
	{
		TCommit
		;调用平台接口
		s rtnStr=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDREADDCARDINFO",StatusInfo.CardID)
		d ##Class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(StatusInfo.CardID)
	}
	else
	{
		TRollback
	}
	
	quit rtn_"^"_InvPrtRowID
}

ClassMethod CheckCardNoByType(CardID As %String, CardTypeId As %String) As %String
{
	s rtn=0
	s PatientID=$p($g(^DHCCARD("CF",CardID)),"^",4)
	s myCardRowID=0
	f  s myCardRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO", CardTypeId,PatientID, myCardRowID))  q:(myCardRowID="")!(+rtn'=0)  d
	.s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
	.q:(myAFlag'="N")		;如果此登记号有
	.s rtn=-364
	q rtn
}

// w ##class(web.DHCBL.CARD.UCardStatusChangeBuilder).CardReportOrCancelLoss("<DHCCardStatusChange><PatientID>52</PatientID><CardID>47621</CardID><RegNo>0000000052</RegNo><IDCardNo>512501196512305186</IDCardNo><CredType></CredType><CardNo>0000000110</CardNo><CardTypeDefine>条形码</CardTypeDefine><ActiveFlag>S</ActiveFlag><Flag>挂失</Flag><ExchangeCardNo></ExchangeCardNo><DateFrom></DateFrom><DateTo></DateTo><RLName>MIC110</RLName><RLCredNo>512501196512305186</RLCredNo><RLCredType></RLCredType><RLCredTypeID>20</RLCredTypeID><RLAddress></RLAddress><RLPhoneNo>13412341234</RLPhoneNo><RLProof></RLProof><RLRemark></RLRemark><UserDR>7</UserDR><ComputerIP>LL-PC</ComputerIP><LogonHospDR>2</LogonHospDR></DHCCardStatusChange>","S")

ClassMethod CardReportOrCancelLoss(CardStatusChangeInfo As %String, oldstatus As %String) As %String
{
	s ^TMPZCZDFDFDD=$lb(CardStatusChangeInfo, oldstatus)
	set StatusInfo=##class(web.DHCEntity.PCA.CardStatusChange).%New()
	do StatusInfo.XMLNodeDeserialize(.StatusInfo,"DHCCardStatusChange",CardStatusChangeInfo)
	set myrtn=0
	;1.验证卡状态	
	set status=##class(web.DHCBL.CARD.CardManager).GetCardStatus(StatusInfo.CardID)
	
	if status'=oldstatus
	{
		if oldstatus="N" 		
		{
			set myrtn=-355 ;非正常卡不能挂失			
		}
		elseif(oldstatus="S")
		{
			set myrtn=-356 ;非挂失卡不能取消挂失
		}
		quit myrtn
	}
	;一个患者只能有一张 同类卡
	
	s myCardRowID=""
	i (StatusInfo.PatientID'="")&(StatusInfo.CardTypeDefine'="")&(oldstatus="S") d
	.s CardTypeId=$p($g(^DHCCARD("CF",StatusInfo.CardID)),"^",16)
	.s myrtn=..CheckCardNoByType(StatusInfo.CardID,CardTypeId)
	q:myrtn'=0 myrtn
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	
	TSTART
	;2.1 挂失卡
	if ((myCardRefFlag="Y")&&(+myrtn=0)) {
		if oldstatus="N"
		{
			set StatusInfo.ActiveFlag="S"
		}
		if (oldstatus="S")
		{
			set StatusInfo.ActiveFlag="N"
		}
		set myrtn=##class(web.DHCBL.CARD.CardStatusChange).UpdateCardStatus(StatusInfo)
		set myrtn=+myrtn
	}	
	
	b	;;2.2 写挂失卡状态记录
	if ((myCardRefFlag="Y")&&(+myrtn=0)) {
		if oldstatus="N"
		{
			set StatusInfo.ActiveFlag="S"
		}
		if (oldstatus="S")
		{
			set StatusInfo.ActiveFlag="N"
		}
		set myrtn=##class(web.DHCBL.CARD.CardStatusChange).Insert(StatusInfo)
		set myrtn=+myrtn
		
	}
	b	;3.根据帐户配置,如果有帐户信息,更新帐户状态
	
	if ((myAccManageFLag="Y")&&(+myrtn=0)) 
	{
		if oldstatus="N"
		{
			set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"S")
		}
		else
		{
			set CardAccStatus=##class(web.DHCBL.CARD.CardManager).GenerateoCardAccStatus(StatusInfo,"N")
		}
		if CardAccStatus.AccountID'=""
		{
			set myStatusInfo=##class(web.DHCBL.CARD.UCardAccStatusChange).Insert(CardAccStatus)
			if (+myStatusInfo<0){
				s rtn=+myStatusInfo
			}
		}
	}
	
	if (+myrtn=0)
	{
		TCommit
		;调用平台接口
		if oldstatus="N" {
			s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDLOSTCARDINFO",StatusInfo.CardID)  ;挂失
		}
		if oldstatus="S" {
			s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDACTIVECARDINFO",StatusInfo.CardID) ;激活
		}
	}
	else
	{
		TRollback
	}
	
	quit myrtn
}

}
