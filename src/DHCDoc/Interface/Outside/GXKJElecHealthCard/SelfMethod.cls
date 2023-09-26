Class DHCDoc.Interface.Outside.GXKJElecHealthCard.SelfMethod Extends (%RegisteredObject, Parameter)
{

/// w ##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.SelfMethod).GetJsonInfo("getPersonInfo","1^2^3^4")
ClassMethod GetJsonInfo(Method As %String, Para As %String) As %String
{
	k ^DHCDocEleHealthCard($j)

	s GetInfoObj=""
	if Method="createVmcardQRcode"  // 6.1电子健康码注册
	{
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.createVmcardQRcode).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalCreateCard).%New()
	}elseif (Method="getPersonInfo"){  // 6.3电子健康码个人信息查询（getPersonInfo）
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.getPersonInfo).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalGetPerson).%New()
	}elseif (Method="modifyVmcardInfo")  // 6.2电子健康码个人信息修改（modifyVmcardInfo）
	{
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.modifyVmcardInfo).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalModify).%New()
	}elseif (Method="getActiveQrCode")  // 6.4电子健康码二维码获取
	{
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.getActiveQrCode).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalActiveQrCode).%New()

	}elseif (Method="getPersonInfoByQrCode")  // 6.5电子卡二维码验证
	{
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.getPersonInfoByQrCode).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalPersonInfoByQrCode).%New()

	}elseif (Method="queryIfHasRegistered")  // 6.6查询账户是否注册
	{
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.queryIfHasRegistered).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalRegistered).%New()
	}elseif (Method="activateVmcardQRcode")  // 6.7电子卡二维码领码/激活
	{
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.queryIfHasRegistered).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalRegistered).%New()
	}elseif (Method="resetVmcardInfo"){  // 6.8电子健康卡卡号重置
		s GetInfoObj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Entity.resetVmcardInfo).%New()
		s myobj=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.GetGlobalResetCard).%New()
	}else{
	
	}
	
	if $IsObject(GetInfoObj){
		s GetInfoObj.appId=..#appId
		;s GetInfoObj.orgCode=..#orgCode
		s GetInfoObj.method=Method
		s GetInfoObj.version=..#version
		s Time=$zd($h,8)_$replace($zt($p($h,",",2)),":","")
		s timestamp=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetEncrypt(Time)
		s GetInfoObj.timestamp=timestamp
		s nonceStr=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetRandomNum(15)
		s GetInfoObj.nonceStr=nonceStr
		
		s headSign="none" ;##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetSign(nonceStr,timestamp)
		s GetInfoObj.headSign=headSign
		s GetInfoObj.bodySign="none"  ;放入if条件里面赋值
		s GetInfoObj.signMode="none"  ;SM3
		s GetInfoObj.encryptMode="none" ;//"SM4/ECB/ZeroBytePadding"
		s GetInfoObj.signature="none"
		
		;策略模式
		#dim contex As DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.Contex
		s contex=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.Contex).%New(myobj)
		s bodyobj=contex.GetGlobal(Para)
		s bodyobj.orgCode=..#orgCode
		s bodyobj.appRecordNo=..#appCordNo
		
		if $IsObject(bodyobj){
			;set ArrayOBJ=##class(%ArrayOfDataTypes).%New()
			;set ArrayOBJ=##class(web.INSUCacheJSON).GetAsArrayOfDataTypesFromOBJ(bodyobj)
			;set BodyJson=##class(web.INSUCacheJSON).Encode(ArrayOBJ)
			;set bodySign=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).GetBodySign(BodyObj)
			d GetInfoObj.body.Insert(bodyobj)
		}else{
			Q ""
		}
	}else{
		Q ""	
	}
	
	
	set ArrayOBJ=##class(%ArrayOfDataTypes).%New()
	set ArrayOBJ=##class(web.INSUCacheJSON).GetAsArrayOfDataTypesFromOBJ(GetInfoObj)
	set JsonInput=##class(web.INSUCacheJSON).Encode(ArrayOBJ)
	set JsonInput=$tr(JsonInput,"[","")
	set JsonInput=$tr(JsonInput,"]","")
	Q JsonInput
}

/// w ##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.SelfMethod).GetBodyGlobal("getPersonInfo","01^21092219840527736X^0000000040^3")
ClassMethod GetBodyObj(Method, Para)
{
	if (Method="batchUploaderhcCardUseInfo")
     {
		s serialNumberId=$p(Para,"^",1)
		s erhcCardNo=$p(Para,"^",2)
		s orgCode=$p(Para,"^",3)
		s orgName=$p(Para,"^",4)
		s terminalCode=$p(Para,"^",5)
		s useCityCode=$p(Para,"^",6)
		s useCityName=$p(Para,"^",7)
		s name=$p(Para,"^",8)
		s sex=$p(Para,"^",9)
		s nation=$p(Para,"^",10)
		s birthday=$p(Para,"^",11)
		s phone=$p(Para,"^",12)
		s idcode=$p(Para,"^",13)
		s address=$p(Para,"^",14)
		s useOrgCode=$p(Para,"^",15)
		s useOrgName=$p(Para,"^",16)
		s terminalType=$p(Para,"^",17)
		s useTime=$p(Para,"^",18)

		s ^DHCDocEleHealthCard($j,"serialNumberId")=serialNumberId
		s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
		s ^DHCDocEleHealthCard($j,"orgCode")=orgCode
		s ^DHCDocEleHealthCard($j,"orgName")=orgName
		s ^DHCDocEleHealthCard($j,"terminalCode")=terminalCode
		s ^DHCDocEleHealthCard($j,"useCityCode")=useCityCode
		s ^DHCDocEleHealthCard($j,"useCityName")=useCityName
		s ^DHCDocEleHealthCard($j,"name")=name
		s ^DHCDocEleHealthCard($j,"sex")=sex
		s ^DHCDocEleHealthCard($j,"nation")=nation
		s ^DHCDocEleHealthCard($j,"birthday")=birthday
		s ^DHCDocEleHealthCard($j,"phone")=phone
		s ^DHCDocEleHealthCard($j,"idcode")=idcode
		s ^DHCDocEleHealthCard($j,"address")=address
		s ^DHCDocEleHealthCard($j,"useOrgCode")=useOrgCode
		s ^DHCDocEleHealthCard($j,"useOrgName")=useOrgName
		s ^DHCDocEleHealthCard($j,"terminalType")=terminalType
		s ^DHCDocEleHealthCard($j,"useTime")=useTime
	}elseif (Method="cancelVmcardInfo")
	{
		s idCardTypeCode=$p(Para,"^",1)
		s idCode=$p(Para,"^",2)
		s erhcCardNo=$p(Para,"^",3)
		s appMode=$p(Para,"^",4)

		s ^DHCDocEleHealthCard($j,"idCardTypeCode")=idCardTypeCode
		s ^DHCDocEleHealthCard($j,"idCode")=idCode
		s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
		s ^DHCDocEleHealthCard($j,"appMode")=appMode
	}elseif (Method="registerNo")
	{
		s terminalCode=$p(Para,"^",1)
		s departmentName=$p(Para,"^",2)
		s departmentCode=$p(Para,"^",3)
		s terminalType=$p(Para,"^",4)
		s installationPositior=$p(Para,"^",5)
		s remark=$p(Para,"^",6)

		s ^DHCDocEleHealthCard($j,"terminalCode")=terminalCode
		s ^DHCDocEleHealthCard($j,"departmentName")=departmentName
		s ^DHCDocEleHealthCard($j,"departmentCode")=departmentCode
		s ^DHCDocEleHealthCard($j,"terminalType")=terminalType
		s ^DHCDocEleHealthCard($j,"installationPositior")=installationPositior
		s ^DHCDocEleHealthCard($j,"remark")=remark
	}
	#dim contex As DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.Contex
	s contex=##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Stratergy.Contex).%New(myobj)
	s bodyobj=contex.GetGlobal(Para)
}

/// / 有患者ID自动插卡号
ClassMethod CreateHealthCard(NewCardNo As %String = "", PatientID As %String = "", UserID As %String = "", QRCode As %String = "") As %String
{
	Q:NewCardNo="" ""
	Q:PatientID="" ""
	s:UserID="" UserID=%session.Get("LOGON.USERID")
	s CardType=+(##class(DHCDoc.Interface.Outside.GXKJElecHealthCard.Util).ReadCardTypeByDesc())
	
	s myCardRowID=""
	s myNormalFlag=0
	s CardRowID=""
	s myrtn=""
	for {
		s myCardRowID=$o(^DHCCARDi("CF",0,"TypePAPMINO", CardType,PatientID, myCardRowID))  
		q:(myCardRowID="")
		s myAFlag=$p(^DHCCARD("CF",myCardRowID),"^", 10)			;CF_ActiveFlag
		continue:(myAFlag'="N")		;如果此登记号有
		s myNormalFlag=1
		s CardRowID=myCardRowID
	}
	if (myNormalFlag="0"){
		s myCardObj=##class(web.DHCEntity.PCA.CardRef).%New()
		s myCardObj.CardNo=NewCardNo
		s myCardObj.CardTypeDefine=CardType
		s myCardObj.PAPMIRowID=PatientID
		s myCardObj.CredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6) 
		s myCardObj.UserDR=UserID
		s myCardObj.CFDate=+$h
		s myCardObj.CFTime=$P($H,",",2)
		s myCardObj.PAPMINo=$P($G(^PAPER(PatientID,"PAT",1)),"^",1)
		s myCardObj.ActiveFlag="N"
		s myrtn=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(myCardObj)
		b ;0932323
		s myCardRowID=$p(myrtn, "^", 2)
		s myrtn=+myrtn
	}else{
		s CardNo=$P(^DHCCARD("CF",CardRowID),"^",2)
		if (CardNo'=NewCardNo){
			Set cf = ##class(User.DHCCardRef).%OpenId(CardRowID)
			Set cf.CFCardNo = NewCardNo
			Set sc = cf.%Save()
			If ($System.Status.IsError(sc))
			{
				Do $System.Status.DisplayError(sc)
				Set myrtn = "-200"	;卡信息保存失败
			}
		}
	}
		
	Q myrtn
}

ClassMethod UpdateQRCode()
{
	;CFQRCode
}

}
