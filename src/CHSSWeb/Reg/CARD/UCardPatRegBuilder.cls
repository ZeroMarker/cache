Class CHSSWeb.Reg.CARD.UCardPatRegBuilder Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

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

	s myDate=+$h    //当前日期
	s myTime=$p($h,",",2)         //当前时间
	
	;把配置反序列化
	s myConfigObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	d myConfigObj.XMLDeserialize(.myConfigObj, ConfigInfo)
	
	s myInfoSource=myConfigObj.InfoSource			;$p(ConfigInfo, "^", 1)    //""
	s myGroupRegFlag=myConfigObj.GroupRegFlag			;$p(ConfigInfo, "^", 2)  //PR
	s myPatMasFlag=myConfigObj.PatMasFlag						;$p(myCardRegConfig, "^", 4)
	s myCardRefFlag=myConfigObj.CardRefFlag						;$p(myCardRegConfig, "^", 5)
	s myAccManageFLag = myConfigObj.AccManageFLag					; $p(myCardRegConfig, "^", 6)
	
	;获取系统配置
	;获取特殊的信息
	s myCardSecurityNo=$p(SepcialInfo, "^", 1)		; ""
	s myAccPWD=$p(SepcialInfo, "^", 2)				; "670B14728AD9902AECBA32E22FA4F6BD"
	
	s myCardRegConfig=##class(CHSSWeb.Reg.CARD.CardPATRegConfig).GetCardPatRegConfig()   //1^Y^^Y^Y^Y^^1^1^^^^^^^^
	s mySearchMasFlag=$p(myCardRegConfig, "^", 2)          //Y
	
	s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	i (myPatMasFlag="Y"){
		d myPatObj.XMLNodeDeserialize(.myPatObj, "PATMAS", PaPatInfo)  //个人基本信息
		s myPatObj.UpdateDate=myDate
		s myPatObj.UpdateTime=myTime
	}
	
	;b	;CardRef
	s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()  //用来传输卡注册信息的数据
	s myCardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()  //专门针对发补卡的收费记录
	//卡计费和打印发票操作
	s myFareType= ""
	
	i (myCardRefFlag="Y"){
		d myCardObj.XMLNodeDeserialize(.myCardObj,"CardRef", CardInfo)  //卡信息
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
				d myCardINVObj.XMLNodeDeserialize(.myCardINVObj, "CardINVPRT", CardINVInfo)  //支付方式
				s myCardINVObj.Date = myDate
				s myCardINVObj.Time = myTime
			}
			;d myobj.%Close()
		}
	}
	;b	;Acc
	i (myAccManageFLag="Y"){
		s myAccObj=##class(web.DHCEntity.PCA.AccManager).%New()
		d myAccObj.XMLNodeDeserialize(.myAccObj, "AccManager", AccInfo) //病患卡基本信息
		s myAccObj.OCDate = myDate
		s myAccObj.OCTime = myTime
		
		s myDepositObj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
		d myDepositObj.XMLNodeDeserialize(.myDepositObj,"AccPreDeposit",DepositInfo)  //支付方式
		s myDepositObj.PreDate=myDate
		s myDepositObj.PreTime=myTime
		;处理账户的特殊节点
		s myAccObj.PassWord = myAccPWD	
		b		;myDepositObj
	}

	;校验数据
	s myrtn=..CheckSaveData(myInfoSource, myPatObj, myCardObj)  //myInfoSource 信息来源标志  //myPatObj 个人基本信息  //myCardObj 卡信息
	
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
		s myrtn=##class(web.DHCBL.CARD.UCardAccManagerInfo).SaveAccMInfo(myAccObj, myDepositObj, myCardTypeDR, myConfigObj)
		s myAccRowID = $p(myrtn, "^", 2)
		s myAccPreRowID=$p(myrtn, "^", 3)
		s myrtn=+ myrtn
	}
	s ^guo("Tstart")="abcdef111"
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
	s myCardRefInfo=$g(myCardRowID)
	
	q myrtn_$c(1)_myOCardINVInfo_$c(1)_myOAccPreInfo_$c(1)_myCodeBarInfo_$c(1)_myPAPMIInfo_$c(1)_myCardRefInfo
}

ClassMethod CheckSaveData(InfoSource As %String, PatInfo As web.DHCEntity.PCA.PATMAS, CardInfo As web.DHCEntity.PCA.CardRef) As %String
{
	
	;验证数据是否 符合条件
	n (InfoSource, PatInfo, CardInfo)
	s myrtn=0
	
	;对于不同的卡类型， 约束
	;
	s myCardTypeDR=""
	
	i (CardInfo.CardTypeDefine=""){
		s myrtn=-366  //请选择卡类型
	}else{
		;此时要求证件号码<>""
		s myIDNo=PatInfo.IDCardNo1   //身份证号
		s myCredTypeDR=PatInfo.CredType  //证件类型
		s myCredNo=PatInfo.CredNo   //号码
		s myCardTypeDR= CardInfo.CardTypeDefine  //卡类型
		
		s myCheckInfo=##class(CHSSWeb.Reg.CARD.UCardRefInfo).CreateCardCheckData(myIDNo, myCredTypeDR, myCredNo,  myCardTypeDR, "")
		s myCIRtn=+$p(myCheckInfo,"^",1)
		s myPAPMIDR=$p(myCheckInfo,"^",2)
		
		;是否办理卡绑定  //?
		if (+myCIRtn=-368){
			;要求传入的 RowID与这个一样否则错误
			i (myPAPMIDR=PatInfo.PAPMIRowID){   //PA_PatMas 表的RowID
				s myrtn=0
			}else{
				s myrtn=-369
			}
		}else
		{
			s myrtn=myCIRtn
		}
	}
	
	q:(+myrtn) myrtn  //？
	
	if (InfoSource="Web")
	{
		
	}else
	{
		;本地信息验证， 需要在数据库中   
		;1. 一个患者只能有一张 同类卡    //?
		s myCardRowID=""
		i (PatInfo.PAPMIRowID'="")&(CardInfo.CardTypeDefine'="") d
		.s myNormalFlag=0
		.f  s myCardRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO", CardInfo.CardTypeDefine,PatInfo.PAPMIRowID, myCardRowID))  q:(myCardRowID="")!(+myrtn'=0)  d
		..s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)		;CF_ActiveFlag
		..q:(myAFlag'="N")		;如果此登记号有         //"R"  "N"  ?
		..s myNormalFlag=1
		..s myrtn=-364
	}
	;卡位数与输入的卡号码位数是否一致
	;CardInfo
	b		;卡号码位数是否一致
	i (+myrtn=0){
		;CardInfo.CardTypeDefine
		s myCardNo=CardInfo.CardNo
		i myCardNo '= "" d
		.s myCardNoLength=$l(myCardNo)
		.s myCardTypeLength=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^", 17)  //读取卡位数
		.if ((+myCardTypeLength'=+myCardNoLength)&&(+myCardTypeLength'=0)) d
		..s myrtn=-370
	}
	b	;;
	;卡前缀是否一致
	i (+myrtn=0){
		s myCardNo=CardInfo.CardNo
		s myCardTypePreNo=$p($g(^DHCCARDTYPEDef(myCardTypeDR)),"^", 29)		;
		s myCardTypePreL=$length(myCardTypePreNo)
		s myCardNoPre=$e(myCardNo,1,myCardTypePreL)
		if (myCardTypePreNo'="")&&(myCardTypePreNo'=myCardNoPre)
		{
			s myrtn=-371
		}
	}
	
	if (+myrtn=0){
		///
		s myrtnVal=##class(web.DHCBL.CARD.UCardRefInfo).ReadPatValidateInfoByCardNo(CardInfo.CardNo, "", CardInfo.CardTypeDefine)
		s myrtn=+$p(myrtnVal,"^",1)
	}
	
	b	;Check
	q myrtn
}

Storage Default
{
<Data name="UCardPatRegBuilderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Reg4E3.UCardPatRegB6D9D</DataLocation>
<DefaultData>UCardPatRegBuilderDefaultData</DefaultData>
<IdLocation>^CHSSWeb.Reg4E3.UCardPatRegB6D9D</IdLocation>
<IndexLocation>^CHSSWeb.Reg4E3.UCardPatRegB6D9I</IndexLocation>
<StreamLocation>^CHSSWeb.Reg4E3.UCardPatRegB6D9S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
