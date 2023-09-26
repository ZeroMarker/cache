Class web.DHCBL.CARD.UCardPatRegBuilder Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 208;

/// 保存Pat
/// Card
/// AccManager
/// 信息到数据库中
/// 
ClassMethod SavePCAInfoToServer(ConfigInfo As %String, PaPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String, CardINVInfo As %String, SepcialInfo As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, ExpStr)
	
	s $ZT="ERROR^DHCSSERR"
	s Index=$I(^tan("SavePCAInfoToServer"))
	s ^tan("SavePCAInfoToServer",Index)=ConfigInfo_"_"_PaPatInfo_"_"_CardInfo_"_"_AccInfo_"_"_DepositInfo_"_"_CardINVInfo_"_"_SepcialInfo_"_"_ExpStr
	i Index>5000 k ^tan("SavePCAInfoToServer")
	;s ^zmc(1122)=ConfigInfo_"_"_PaPatInfo_"_"_CardInfo_"_"_AccInfo_"_"_DepositInfo_"_"_CardINVInfo_"_"_SepcialInfo_"_"_ExpStr
	n (ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr,%session)
	s ^TMPPatRegInfo=$lb(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	
	s myrtn=""
	s UsePANoToCardNO=$P(ExpStr,"^",2)
    s HospitalID=$P(ExpStr,"^",3)  //院区
    s TransferCardFlag=$P(ExpStr,"^",4)  //转正式卡
    s PhotoStream=$P(ExpStr,"^",5) //图片base64编码
    s ETPRowID=$P(ExpStr,"^",6)
    s PayModeidNew=##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)
	s myDate=..%SysDate()
	s myTime=..%SysTime()
	
	;1 . 数据信息来源
	;  HIS
	;  来之银行
	;2. Group Reg = GR
	;	Person Reg ="" or PR
	;	...
	;3. 
	
	;把配置反序列化
	s myConfigObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	d myConfigObj.XMLDeserialize(.myConfigObj, ConfigInfo)
	
	s myInfoSource=myConfigObj.InfoSource			;$p(ConfigInfo, "^", 1)
	s myGroupRegFlag=myConfigObj.GroupRegFlag			;$p(ConfigInfo, "^", 2)
	
	;获取系统配置
	;获取特殊的信息
	s myCardSecurityNo=$p(SepcialInfo, "^", 1)		;
	s myAccPWD=$p(SepcialInfo, "^", 2)				;
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	
	s mySearchMasFlag=$p(myCardRegConfig, "^", 2)
	s myPatMasFlag=myConfigObj.PatMasFlag						;$p(myCardRegConfig, "^", 4)
	s myCardRefFlag=myConfigObj.CardRefFlag						;$p(myCardRegConfig, "^", 5)
	s myAccManageFLag = myConfigObj.AccManageFLag					; $p(myCardRegConfig, "^", 6)
	s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	d myPatObj.XMLNodeDeserialize(.myPatObj, "PATMAS", PaPatInfo)
	i (myPatMasFlag="Y"){
		s myPatObj.UpdateDate=myDate
		s myPatObj.UpdateTime=myTime
		if (PhotoStream'="") s myPatObj.PhotoInfo=PhotoStream
	}
	///判断证件号码是否已经被使用
	s CheckSameCredID=##class(web.DHCBL.CARD.UCardPaPatMasInfo).CheckCredNoIDU(myPatObj.PAPMIRowID,myPatObj.CredNo,myPatObj.CredType)
	if (CheckSameCredID=1){
		q "-2此证件号码已经被使用"_$c(1)_""_$c(1)_""_$c(1)_"^"_$c(1)_""_$c(1)_""
	}
	//建大病历
	if $P(ExpStr,"^",1)=1{
		Tstart
		//i (myPatMasFlag="Y"){
		s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(myPatObj)
		if (+myrtn=0){
			s myPAPMIRowID=$p(myrtn,"^",2)
			if (TransferCardFlag="1"){
				s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).UpdateCardInfo(CardInfo)
				if (myrtn=0){
					//推送第三方病历接口
					//d ##class(DHCENS.REG.BS.WebREGService).PatInfoSend(myPAPMIRowID)
				}
			}
		}
		if (+myrtn=0){
			tcommit
			if (..%IsValidMethod("web.DHCPE.PreIBIUpdate","UpdatePEInfoByHis"))  d
			.s PAPMINO=$P($G(^PAPER(myPAPMIRowID,"PAT",1)),"^",1)
			.s UserDr=$P($G(^PAPER(myPAPMIRowID,"PER",4)),"^",7)
			.s:UserDr="" UserDr=$P($G(^PAPER(myPAPMIRowID,"PER",5)),"^",18)
			.d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(PAPMINO,UserDr,HospitalID)
		}else{
			trollback
			q myrtn
		}
		s PatNo=$p(^PAPER(myPAPMIRowID,"PAT",1),"^",2)
		s myrtn=+myrtn
		
		q myrtn_$c(1)_""_$c(1)_""_$c(1)_PatNo_"^"_$c(1)_""_$c(1)_""
	}
	
	;b	;CardRef
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
	s myAccObj=##class(web.DHCEntity.PCA.AccManager).%New()
	
	//卡计费和打印发票操作
	s myFareType= ""
	i (myCardRefFlag="Y"){
		d myCardObj.XMLNodeDeserialize(.myCardObj,"CardRef", CardInfo)
		s myCardObj.SecurityNo=myCardSecurityNo
		s myCardObj.CFDate=myDate
		s myCardObj.CFTime=myTime
		
		//此卡是否计费等操作
		s myCardTypeDR = myCardObj.CardTypeDefine
		if ((myCardTypeDR'="")&&(myGroupRegFlag'="GR")){
			;s myobj=##class(User.DHCCardTypeDef).%OpenId(myCardTypeDR)
			//判断是否计费
			;s myFareType = myobj.CTDFareType
			s myFareType = myConfigObj.FareType
			
			i (myFareType ="C"){
				d myCardINVObj.XMLNodeDeserialize(.myCardINVObj, "CardINVPRT", CardINVInfo)
				s myCardINVObj.Date = myDate
				s myCardINVObj.Time = myTime
				s myCardINVObj.HospitalID=HospitalID
				s myCardINVObj.ETPRowID=ETPRowID
			}
			s:PayModeidNew'="" myCardINVObj.PayMode=PayModeidNew
			;d myobj.%Close()
		}
	}
	;b	;Acc
	i (myAccManageFLag="Y"){
		d myAccObj.XMLNodeDeserialize(.myAccObj, "AccManager", AccInfo)
		s myAccObj.OCDate = myDate
		s myAccObj.OCTime = myTime
		s myAccObj.HospitalID=HospitalID
		
		s myDepositObj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
		d myDepositObj.XMLNodeDeserialize(.myDepositObj,"AccPreDeposit",DepositInfo)
		s myDepositObj.PreDate=myDate
		s myDepositObj.PreTime=myTime
		;处理账户的特殊节点
		s myAccObj.PassWord = myAccPWD	
		s:PayModeidNew'="" myDepositObj.PayMode=PayModeidNew
		b		;myDepositObj
	}
		
    // 获取二维码卡号
	s myrtn=##class(DHCDoc.Interface.CardManage).Interface("GetQRCode",myPatObj,myCardObj)
	i (+myrtn'=0){
		q myrtn
	}
	i ($p(myrtn,"^",2)'="")&&(myAccObj.CardNo="") {
		s myAccObj.CardNo=$p(myrtn,"^",2)
		s myCardObj.CardNo=$p(myrtn,"^",2)
	}

	;校验数据
	s myrtn=..CheckSaveData(myInfoSource, myPatObj, myCardObj,UsePANoToCardNO,HospitalID)
	
	q:(+myrtn) myrtn
	
	;下面需要实现的功能
	;.....................
	;q "0^^^"
	
	;初始化数据
	s myAccPreRowID=""
	s myAccRowID=""
	s myPAPMIRowID=""
	s myCardINVRowID=""
	s myCardRowID=""
	Tstart
	;4. 保存患者基本信息到数据库
	i (myPatMasFlag="Y"){
		s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(myPatObj)
		s myPAPMIRowID=$p(myrtn,"^",2)
	}else{
		;纯粹的卡关联
		s myPAPMIRowID=myCardObj.PAPMIRowID
	}
	
	//如果使用登记号作为卡号在这个位置补卡号信息
	if (+myrtn=0)&&(myPAPMIRowID'="")&&(UsePANoToCardNO="Y"){
		s PAPMINO=$P($G(^PAPER(myPAPMIRowID,"PAT",1)),"^",1)
		s:myAccManageFLag="Y" myAccObj.CardNo=PAPMINO
		s myCardObj.CardNo=PAPMINO
	}
	
	b	;保存患者基本信息到数据库
	;	5.1	根据卡类型配置 保存票据信息和费用信息
	;5. 保存患者帐户信息
	i ((myAccManageFLag="Y")&&(+myrtn=0)){
		s myAccObj.PAPMIRowID = myPAPMIRowID
		s myCardTypeDR = myCardObj.CardTypeDefine
		s myrtn=##class(web.DHCBL.CARD.UCardAccManagerInfo).SaveAccMInfo(myAccObj, myDepositObj, myCardTypeDR, myConfigObj,ETPRowID)
		s myAccRowID = $p(myrtn, "^", 2)
		s myAccPreRowID=$p(myrtn, "^", 3)
		if ($p(myrtn, "^", 1)'=0){s myAccPreRowID=$p(myrtn, "^", 2)}
		s myrtn=+ myrtn
	}
	b	;保存患者帐户信息
	;6. 保存患者的卡信息到数据库
	i ((myCardRefFlag="Y")&&(+myrtn=0)){
		b		;加入计费ing
		//加入计费
		i ((myFareType="C")&&(+myrtn=0)&&(myGroupRegFlag'="GR"))
		{
			s myCardINVObj.PAPMIRowID = myPAPMIRowID
			s myCardINVObj.Flag="N"
			s myrtn=##class(web.DHCBL.CARD.UCardINVPRTInfo).SaveCardINVInfo(myCardINVObj,myCardObj.CardTypeDefine)
			s myCardINVRowID=$p(myrtn,"^",2)
			s myrtn=+myrtn
		}
		b		;保存卡信息ing
		//保存卡信息
		if ((+myrtn=0))
		{
			s myCardObj.PAPMIRowID = myPAPMIRowID
			s myCardObj.CardINVPRTDR=myCardINVRowID
			s myCardObj.CFAccNoDR =myAccRowID
			;NP,PC,CC
			i myCardINVRowID="" d
			.s myCardObj.FareType="NP"
			e  d
			.s myCardObj.FareType="PC"
			;集团注册
			i (myGroupRegFlag="GR") d
			.s myCardObj.FareType="CC"
			
			s myCardObj.ActiveFlag="N"		;正常状态
			s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
			s myCardRowID=$p(myrtn, "^", 2)
			s myrtn=+myrtn
		}
		b		;保存卡完毕
	}
	
    // 创建病人后处理
	if (+myrtn=0){  
		s myrtn=##class(DHCDoc.Interface.CardManage).Interface("AfterPatCreat",myPatObj,myCardObj)
		s myrtn=+myrtn
	}

	b		;RollBack
	if (+myrtn=0)
	{
		tcommit
		;调用平台组接口
		s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDPATINFO",myPAPMIRowID)
		s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADDCARDINFO",myCardRowID)
		d ##Class(web.DHCCardPurchaseManage).UpdateCardPurchaseAllot(myCardRowID)
		if (..%IsValidMethod("web.DHCPE.PreIBIUpdate","UpdatePEInfoByHis"))  d
		.s PAPMINO=$P($G(^PAPER(myPAPMIRowID,"PAT",1)),"^",1)
		.//PAPER_UserUpdate
		.s UserDr=$P($G(^PAPER(myPAPMIRowID,"PER",4)),"^",7)
		.s:UserDr="" UserDr=$P($G(^PAPER(myPAPMIRowID,"PER",5)),"^",18)
		.d ##class(web.DHCPE.PreIBIUpdate).UpdatePEInfoByHis(PAPMINO,UserDr,HospitalID)
	}
	else
	{
		trollback
	}
	
	;返回数据
	;1. CardINVInfo RowID
	;2. AccPreDeposit RowID
	;3. PAPMINo
	;4. PAPMIDR
	s myOCardINVInfo=myCardINVRowID
	s myOAccPreInfo=myAccPreRowID
	;如果此类型卡需要 打印条形码， 就输出条形码数据直接给 Dll  
	;形式是XML格式
	s myCodeBarInfo=""
	s myPAPMIInfo = myPAPMIRowID
	s myCardRefInfo=$g(myCardRowID)
	s CardNO="" s PAPMINO=""
	s:myCardRowID'="" CardNO=$P($G(^DHCCARD("CF",myCardRowID)),"^",2)
	s:myPAPMIRowID'="" PAPMINO=$P($G(^PAPER(myPAPMIRowID,"PAT",1)),"^",1)
	
	
	q myrtn_$c(1)_myOCardINVInfo_$c(1)_myOAccPreInfo_$c(1)_myCodeBarInfo_$c(1)_myPAPMIInfo_$c(1)_myCardRefInfo_$c(1)_PAPMINO_$c(1)_CardNO
}

ClassMethod CheckSaveData(InfoSource As %String, PatInfo As web.DHCEntity.PCA.PATMAS, CardInfo As web.DHCEntity.PCA.CardRef, UsePANoToCardNO As %String = "", HospitalID As %String = "") As %String
{
	;验证数据是否 符合条件
	n (InfoSource, PatInfo, CardInfo,UsePANoToCardNO,HospitalID,%session)
	s myrtn=0
	
	;对于不同的卡类型， 约束
	;
	s myCardTypeDR=""
	
	i (CardInfo.CardTypeDefine=""){
		s myrtn=-366
	}else{
		;此时要求证件号码<>""
		s myIDNo=PatInfo.IDCardNo1
		s myCredTypeDR=PatInfo.CredType
		s myCredNo=PatInfo.CredNo
		s myCardTypeDR= CardInfo.CardTypeDefine
		s TemporaryCard=CardInfo.TemporaryCard
		s myAge=PatInfo.Age
		s ExtStr=myAge_"^"_HospitalID_"^"_TemporaryCard
		s myCheckInfo=##class(web.DHCBL.CARD.UCardRefInfo).CreateCardCheckData(myIDNo, myCredTypeDR, myCredNo,  myCardTypeDR, ExtStr)
		s myCIRtn=+$p(myCheckInfo,"^",1)
		s myPAPMIDR=$p(myCheckInfo,"^",2)
		
		;是否办理卡绑定
		if (+myCIRtn=-368){
			;要求传入的 RowID与这个一样否则错误
			i (myPAPMIDR=PatInfo.PAPMIRowID){
				s myrtn=0
			}else{
				s myrtn=-369
			}
		}else
		{
			s myrtn=myCIRtn
		}
	}
	
	q:(+myrtn) myrtn
	
	if (InfoSource="Web")
	{
		
	}else
	{
		;本地信息验证， 需要在数据库中
		;1. 一个患者只能有一张 同类卡
		s myCardRowID=""
		i (PatInfo.PAPMIRowID'="")&(CardInfo.CardTypeDefine'="") d
		.s myNormalFlag=0
		.f  s myCardRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO", CardInfo.CardTypeDefine,PatInfo.PAPMIRowID, myCardRowID))  q:(myCardRowID="")!(+myrtn'=0)  d
		..s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
		..q:(myAFlag'="N")		;如果此登记号有
		..s myNormalFlag=1
		..s myrtn=-364
		
	}
	;卡位数与输入的卡号码位数是否一致
	;CardInfo
	b		;卡号码位数是否一致  使用登记号作为卡号不校验
	i ((+myrtn=0)&(UsePANoToCardNO'="Y")){
		;CardInfo.CardTypeDefine
		s myCardNo=CardInfo.CardNo
		s myCardNoLength=$l(myCardNo)
		
		s myCardTypeLength=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^", 17)		;
		if ((+myCardTypeLength'=+myCardNoLength)&&(+myCardTypeLength'=0)){
			s myrtn=-370
		}
	}
	b	;;
	;卡前缀是否一致
	i ((+myrtn=0)&(UsePANoToCardNO'="Y")){
		s myCardNo=CardInfo.CardNo
		s myCardTypePreNo=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^", 29)		;
		s myCardTypePreL=$length(myCardTypePreNo)
		s myCardNoPre=$e(myCardNo,1,myCardTypePreL)
		if (myCardTypePreNo'="")&&(myCardTypePreNo'=myCardNoPre)
		{
			s myrtn=-371
		}
	}
	
	///如果使用登记号作为卡号不再这个位置验证
	if ((+myrtn=0)&&(UsePANoToCardNO'="Y")){

		if (UsePANoToCardNO'="Y"){
			s myrtnVal=##class(web.DHCBL.CARD.UCardRefInfo).ReadPatValidateInfoByCardNo(CardInfo.CardNo, "", CardInfo.CardTypeDefine)
			s myrtn=+$p(myrtnVal,"^",1)
		}elseif (CardInfo.CardNo'=""){
			s myrtnVal=##class(web.DHCBL.CARD.UCardRefInfo).ReadPatValidateInfoByCardNo(CardInfo.CardNo, "", CardInfo.CardTypeDefine)
			s myrtn=+$p(myrtnVal,"^",1)
		}
		
	}
	
	b	;Check
	q myrtn
}

ClassMethod GroupPersonInfoReg(UserDR As %String, ExpStr As %String) As %String
{
	;
	;(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	;把临时存储的数据转换为对象
	s myrtn=0
	
	q myrtn
}

ClassMethod SaveTest()
{
	;d ##class(web.DHCBL.CARD.UCardPatRegBuilder).SaveTest()
	;^TMPPatRegInfo=$lb(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, ExpStr)
	s ConfigInfo=$LIST($g(^TMPPatRegInfo),1)
	s PaPatInfo=$LIST($g(^TMPPatRegInfo),2)
	s CardInfo =$LIST($g(^TMPPatRegInfo),3)
	s AccInfo =$LIST($g(^TMPPatRegInfo),4)
	s DepositInfo=$LIST($g(^TMPPatRegInfo),5)
	s CardINVInfo=$LIST($g(^TMPPatRegInfo),6)
	s SepcialInfo=$LIST($g(^TMPPatRegInfo),7)
	s ExpStr =$LIST($g(^TMPPatRegInfo),8)
	
	s myrtn= ..SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	b		;myrtn
}

}
