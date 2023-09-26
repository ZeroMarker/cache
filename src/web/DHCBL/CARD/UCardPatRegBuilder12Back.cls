Class web.DHCBL.CARD.UCardPatRegBuilder12Back Extends (%RegisteredObject, %XML.Adaptor, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 126;

/// 保存Pat
/// Card
/// AccManager
/// 信息到数据库中
/// 
ClassMethod SavePCAInfoToServer(ConfigInfo As %String, PaPatInfo As %String, CardInfo As %String, AccInfo As %String, DepositInfo As %String, CardINVInfo As %String, SepcialInfo As %String, ExpStr As %String) As %String
{
	;w ##class(web.DHCBL.CARD.UCardPatRegBuilder).SavePCAInfoToServer(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, ExpStr)
	
	s $ZT="ERROR^DHCSSERR"
	
	n (ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	s ^TMPPatRegInfo=$lb(ConfigInfo, PaPatInfo, CardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
	
	s myrtn=""

	s myDate=+$h
	s myTime=$p($h,",",2)
	
	;1 . 数据信息来源
	;  HIS
	;  来之银行
	;2. Group Reg = GR
	;	Person Reg ="" or PR
	;	...
	;3. 
	
	;把配置反序列化
	s myConObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	d myConObj.XMLDeserialize(.myConObj, ConfigInfo)
	
	s myInfoSource=myConObj.InfoSource			;$p(ConfigInfo, "^", 1)
	s myGroupRegFlag=myConObj.GroupRegFlag			;$p(ConfigInfo, "^", 2)
	
	;获取系统配置
	;获取特殊的信息
	s myCardSecurityNo=$p(SepcialInfo, "^", 1)		;
	s myAccPWD=$p(SepcialInfo, "^", 2)				;
	
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	
	s mySearchMasFlag=$p(myCardRegConfig, "^", 2)
	s myPatMasFlag=$p(myCardRegConfig, "^", 4)
	s myCardRefFlag=$p(myCardRegConfig, "^", 5)
	s myAccManageFLag= $p(myCardRegConfig, "^", 6)
	
	s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	i (myPatMasFlag="Y"){
		d myPatObj.XMLNodeDeserialize(.myPatObj, "PATMAS", PaPatInfo)
		s myPatObj.UpdateDate=myDate
		s myPatObj.UpdateTime=myTime
	}
	
	;b	;CardRef
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
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
			s myobj=##class(User.DHCCardTypeDef).%OpenId(myCardTypeDR)
			//判断是否计费
			s myFareType = myobj.CTDFareType
			i (myobj.CTDFareType="C"){
				d myCardINVObj.XMLNodeDeserialize(.myCardINVObj, "CardINVPRT", CardINVInfo)
				s myCardINVObj.Date = myDate
				s myCardINVObj.Time = myTime
			}
			d myobj.%Close()
		}
	}
	;b	;Acc
	i (myAccManageFLag="Y"){
		s myAccObj=##class(web.DHCEntity.PCA.AccManager).%New()
		d myAccObj.XMLNodeDeserialize(.myAccObj, "AccManager", AccInfo)
		s myAccObj.OCDate = myDate
		s myAccObj.OCTime = myTime
		
		
		s myDepositObj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
		d myDepositObj.XMLNodeDeserialize(.myDepositObj,"AccPreDeposit",DepositInfo)
		s myDepositObj.PreDate=myDate
		s myDepositObj.PreTime=myTime
		;处理账户的特殊节点
		s myAccObj.PassWord = myAccPWD	
		b		;myDepositObj
	}
	
	;校验数据
	s myrtn=..CheckSaveData(myInfoSource, myPatObj, myCardObj)
	
	q:(+myrtn) myrtn
	
	;下面需要实现的功能
	;.....................
	;q "0^^^"
	
	;初始化数据
	s myAccPreRowID=""
	s myAccRowID=""
	s myPAPMIRowID=""
	s myCardINVRowID=""
	
	Tstart
	
	;4. 保存患者基本信息到数据库
	i (myPatMasFlag="Y"){
		s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(myPatObj)
		s myPAPMIRowID=$p(myrtn,"^",2)
		s myrtn=+myrtn
	}
	b	;保存患者基本信息到数据库
	;	5.1	根据卡类型配置 保存票据信息和费用信息
	;5. 保存患者帐户信息
	i ((myAccManageFLag="Y")&&(+myrtn=0)){
		s myAccObj.PAPMIRowID = myPAPMIRowID
		s myCardTypeDR = myCardObj.CardTypeDefine
		s myrtn=##class(web.DHCBL.CARD.UCardAccManagerInfo).SaveAccMInfo(myAccObj, myDepositObj, myCardTypeDR)
		s myAccRowID = $p(myrtn, "^", 2)
		s myAccPreRowID=$p(myrtn, "^", 3)
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
			s myCardObj.ActiveFlag="N"		;正常状态
			s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
			s myCardRowID=$p(myrtn, "^", 2)
			s myrtn=+myrtn
		}
		b		;保存卡完毕
	}
	
	b		;RollBack
	if (+myrtn=0)
	{
		tcommit
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
	
	q myrtn_$c(1)_myOCardINVInfo_$c(1)_myOAccPreInfo_$c(1)_myCodeBarInfo_$c(1)_myPAPMIInfo
}

ClassMethod CheckSaveData(InfoSource As %String, PatInfo As web.DHCEntity.PCA.PATMAS, CardInfo As web.DHCEntity.PCA.CardRef) As %String
{
	;验证数据是否 符合条件
	n (InfoSource, PatInfo, CardInfo)
	s myrtn=0
	
	;对于不同的卡类型， 约束
	;
	i (CardInfo.CardTypeDefine=""){
		s myrtn=-366
	}else{
		;此时要求证件号码<>""
		s mySameFind=0
		s myPAPMIDR=0
		s myCardTypeValidateFlag=$p(^DHCCARDTYPEDef(CardInfo.CardTypeDefine),"^", 30)		;CTD_ValidateMode
		///身份证类型验证  ID Unqiue
		if (myCardTypeValidateFlag="IDU"){
			i PatInfo.IDCardNo1="" d
			.s myrtn=-367
			
			q:(myrtn) myrtn
			
			s myPAID=$ZConvert(PatInfo.IDCardNo1,"U")
			i $l(myPAID)=15{
				
				s myPAID15=$ZConvert(PatInfo.IDCardNo1_"Z","U")
				s myPAID18=$e(myPAID,1,6)_"19"_$e(myPAID,7,15)_" "
				s myPAID18=$ZConvert(myPAID18_"Z","U")
				
			}elseif($l(myPAID)=18){
				s myPAID18=$ZConvert(PatInfo.IDCardNo1_"Z","U")
				s myPAID15=$e(myPAID,1,6)_$e(myPAID,9,17)
				s myPAID15=$ZConvert(myPAID15_"Z","U")
				
			}
			
			;^DHCCARDi("CF",0,"PAPMICTDR",{CF_PAPMI_DR},{CF_CardType_DR},      x
			;分成  15 位和 18位区别
			f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID18,myPAPMIDR))  q:((myPAPMIDR="")!(+mySameFind))  d
			.s myCardTypeDR=0
			.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			..i CardInfo.CardTypeDefine=myCardTypeDR d
			...s mySameFind=1
			s myPAPMIDR=0
			f  s myPAPMIDR=$o(^PAPERi("PAPMI_ICPPBC",myPAID15,myPAPMIDR))  q:((myPAPMIDR="")!(+mySameFind))  d
			.s myCardTypeDR=0
			.f  s myCardTypeDR=$o(^DHCCARDi("CF",0,"PAPMICTDR",myPAPMIDR ,myCardTypeDR)) q:(myCardTypeDR="")!(+mySameFind)  d
			..i CardInfo.CardTypeDefine=myCardTypeDR d
			...s mySameFind=1
			
			i +mySameFind d
			.s myrtn=-365
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
