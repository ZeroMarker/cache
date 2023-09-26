Class DHCDoc.Interface.Outside.JXSElecHealthCard.Methods Extends (%RegisteredObject, %XML.Adaptor, DHCExternalService.RegInterface.SelfRegPlulic) [ Not ProcedureBlock ]
{

/// 接口地址
Parameter Server = "192.168.1.32";

/// 接口端口
Parameter Port = 8090;

/// 接入机构编号
Parameter InstitutionID = "49142056-X36040011A1001";

/// 注册终端编号
Parameter TerminalID = "JJDYRMYYCK01";

/// 授权编码
Parameter Appid = "kjO773wJ";

/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).EleHealthCardRegister("01^360981200203076175^郭俊名^1^汉族^20020307^1^18720968867","","")
/// Para=01^360104199203041915^徐高远^1^汉族^19920304^南昌^18329163019
/// 2.1电子健康卡注册
ClassMethod EleHealthCardRegister(Para As %String, TerminalID As %String = "", Secret As %String = "") As %String
{
	////CertType CertID Name Gender Nation BirthDate Address Phone
	s ^tmp("EleHealthCardRegister")=$lb(Para,TerminalID,Secret)
	i Secret="" s Secret="W1KS92L108X"
	s CertType=$p(Para,"^",1)
	s CertID=$p(Para,"^",2)
	s Name=$p(Para,"^",3)
	s Gender=$p(Para,"^",4)
	s Nation=$p(Para,"^",5)
	s BirthDate=$p(Para,"^",6)
	s Address=$p(Para,"^",7)
	s Phone=$p(Para,"^",8)
	s DateTime=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTime() //..GetCurrentDate() ;
	i TerminalID="" s TerminalID=..#TerminalID
	s InstitutionID=..#InstitutionID
	s Appid=..#Appid
	s TerminalSecret= ##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTerminalSecret(Secret,DateTime)  ;..GetTerminalSecret(Secret,DateTime)  ; //
	i TerminalSecret'="" s TerminalSecret=$tr(TerminalSecret,"""","")
	s NonceStr=..GetRandomNum(8)  
	s root=##class(%Library.DynamicObject).%New()
	d root.%Set("InstitutionID",InstitutionID)
	d root.%Set("TerminalID",TerminalID)
	d root.%Set("Time",DateTime)
	d root.%Set("CertType",CertType)
	d root.%Set("CertID",CertID)
	d root.%Set("Name",Name)
	d root.%Set("TerminalSecret",TerminalSecret)
	s ResidentInfo=##class(%Library.DynamicObject).%New()
	d ResidentInfo.%Set("Gender",Gender)
	d ResidentInfo.%Set("Nation",Nation)
	d ResidentInfo.%Set("BirthDate",BirthDate)
	d ResidentInfo.%Set("Address",Address)
	d ResidentInfo.%Set("Phone",Phone)
	d root.%Set("residentInfo",ResidentInfo)
	s APIVerify=##class(%Library.DynamicObject).%New()
	d APIVerify.%Set("Appid",Appid)
	d APIVerify.%Set("Nonce_Str",NonceStr)
	d APIVerify.%Set("Time",DateTime)
	s Sign=..GetSign(Appid,NonceStr,DateTime)
	d APIVerify.%Set("Sign",Sign)
	d root.%Set("aPIVerify",APIVerify)
	d root.%Set("MAC",NonceStr)
	s ReJson=root.%ToJSON()
	;s URL="ECard/Register-By-Terminal"
	set ReJsonstream=##class(%Stream.GlobalCharacter).%New()
	d ReJsonstream.Write(ReJson)
    s ReInfo=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).SendElectronicHealthCard("MES0294",ReJsonstream) //..HttpService(ReJson,URL)
    q:ReInfo="" ""
    b ;ReInfo
    set ^tempss($h)=ReJson
    ///{"result":"0","data":"注册成功！","message":"注册成功！","mac":""}
    s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	s ReInfo=obj.%Get("result")_"^"_obj.%Get("data")
	s ^TempDHCEleHealthCard(+$h,"Register",$i(^TempDHCEleHealthCard(+$h,"Register")))=ReInfo
	q ReInfo
}

/// 2.3静态二维码申请
/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeApply("01^360981200203076175^郭俊名","","")
ClassMethod StaticCodeApply(Para As %String, TerminalID As %String = "", Secret As %String = "") As %String
{
	i Secret="" s Secret="W1KS92L108X"
    s CertType=$p(Para,"^",1)
    s CertID=$p(Para,"^",2)
    s FamilyName=$p(Para,"^",3)
    s DateTime=  ##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTime()  ;..GetCurrentDate() ; //
	i TerminalID="" s TerminalID=..#TerminalID 
	s InstitutionID=..#InstitutionID
	s Appid=..#Appid
	s TerminalSecret=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTerminalSecret(Secret,DateTime)  ;..GetTerminalSecret(Secret,DateTime)  ; //
	i TerminalSecret'="" s TerminalSecret=$tr(TerminalSecret,"""","")
	s NonceStr=..GetRandomNum(8) 
	s root=##class(%Library.DynamicObject).%New()
	d root.%Set("InstitutionID",InstitutionID)
	d root.%Set("TerminalID",TerminalID)
	d root.%Set("Time",DateTime)
	d root.%Set("CertType",CertType)
	d root.%Set("CertID",CertID) 
	;d root.%Set("FamilyName",FamilyName)
	d root.%Set("TerminalSecret",TerminalSecret)
	s APIVerify=##class(%Library.DynamicObject).%New()
	d APIVerify.%Set("Appid",Appid)
	d APIVerify.%Set("Nonce_Str",NonceStr)
	d APIVerify.%Set("Time",DateTime)
	s Sign=..GetSign(Appid,NonceStr,DateTime)
	d APIVerify.%Set("Sign",Sign)
	d root.%Set("APIVerify",APIVerify)
	d root.%Set("MAC",NonceStr)
	s ReJson=root.%ToJSON()
	;s URL="/QRcode/Apply-Static-By-Terminal"
    set ReJsonstream=##class(%Stream.GlobalCharacter).%New()
	d ReJsonstream.Write(ReJson)
    s ReInfo=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).SendElectronicHealthCard("MES0295",ReJsonstream) //..HttpService(ReJson,URL)
    
    ;b ;ReInfo
    s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
    if obj.%Get("result")=0
    {
	    s Data=obj.%Get("data")
	    s ReInfo=..GetResponseDate(Data,"Apply")
	}else{
		s ReInfo=""
	 }
	s ^TempDHCEleHealthCard(+$h,"CodeApply",$i(^TempDHCEleHealthCard(+$h,"CodeApply")))=ReInfo
    q ReInfo
}

/// 2.4静态二维码验证
/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeVerification("74C4F1AE1B7A143E1302F7A9ECD7A5E47C650EA3B4FE1978BCD23C088F9BB4EF:1::3602A0015","HisReg")
ClassMethod StaticCodeVerification(Code As %String, ChannelCode As %String = "", MedStepCode As %String = "") As %String
{
	s CredNo=""
	s DateTime=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTime() //..GetCurrentDate()  
	s NonceStr=..GetRandomNum(8)  //$p($h,",",2)
	i MedStepCode= "" s MedStepCode="000"
	s TerminalID=..#TerminalID
	s InstitutionID=..#InstitutionID
	s Appid=..#Appid
    s root=##class(%Library.DynamicObject).%New()
	d root.%Set("InstitutionID",InstitutionID)
	d root.%Set("TerminalID","FR2000-28 FE6L0260")
	d root.%Set("Time",DateTime)
	d root.%Set("Data",Code)
	d root.%Set("ChannelCode",ChannelCode)
	d root.%Set("MedStepCode",MedStepCode)
	s APIVerify=##class(%Library.DynamicObject).%New()
	d APIVerify.%Set("Appid",Appid)
	d APIVerify.%Set("Nonce_Str",NonceStr)
	d APIVerify.%Set("Time",DateTime)
	s Sign=..GetSign(Appid,NonceStr,DateTime)
	d APIVerify.%Set("Sign",Sign)
	d root.%Set("aPIVerify",APIVerify)
	d root.%Set("MAC",NonceStr)
	d root.%Set("OfficeCode","00")
	s Secret="W1KS92L108X"
	s TerminalSecret=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTerminalSecret(Secret,DateTime)  
	i TerminalSecret'="" s TerminalSecret=$tr(TerminalSecret,"""","")
	d root.%Set("TerminalSecret",TerminalSecret)
	s ReJson=root.%ToJSON()
    set ReJsonstream=##class(%Stream.GlobalCharacter).%New()
	d ReJsonstream.Write(ReJson)
    s ReInfo=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).SendElectronicHealthCard("MES0338",ReJsonstream) 
    q:ReInfo="" ""
    /*s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
    if obj.%Get("result")=0
    {
	    s Data=obj.%Get("data")
	    s ReInfo=..GetResponseDate(Data,"HisReg")
	}else{
		s ReInfo=""
	 }*/
	q ReInfo
}

/// 2.6电子健康卡变更
/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).ELEHealthCardChange("01^360104199203041915^18329163018","","123")
ClassMethod ELEHealthCardChange(Para As %String, TerminalID As %String = "", Secret As %String = "") As %String
{
	i Secret="" s Secret="W1KS92L108X"
	s CertType=$p(Para,"^",1)
	s CertID=$p(Para,"^",2)
	s Phone=$p(Para,"^",3)
	s DateTime=..GetCurrentDate()
	i TerminalID="" s TerminalID="234"  ///
	s TerminalSecret=..GetTerminalSecret(Secret,DateTime)
	i TerminalSecret'="" s TerminalSecret=$tr(TerminalSecret,"""","")
	s NonceStr=..GetRandomNum(8)  
	s root=##class(%Library.DynamicObject).%New()
	d root.%Set("InstitutionID","230018360102250131")
	d root.%Set("TerminalID",TerminalID)
	d root.%Set("Time",DateTime)
	d root.%Set("CertType",CertType)
	d root.%Set("CertID",CertID)
	d root.%Set("Phone",Phone)
	d root.%Set("TerminalSecret",TerminalSecret)
	s APIVerify=##class(%Library.DynamicObject).%New()
	d APIVerify.%Set("Appid","x8QjN5Iy")
	d APIVerify.%Set("Nonce_Str",NonceStr)
	d APIVerify.%Set("Time",DateTime)
	s Sign=..GetSign("x8QjN5Iy",NonceStr,DateTime)
	d APIVerify.%Set("Sign",Sign)
	d root.%Set("APIVerify",APIVerify)
	d root.%Set("MAC","")
	s ReJson=root.%ToJSON()
	s URL="/ECard/Change-By-Terminal"
	s ReInfo=..HttpService(ReJson,URL)
    q:ReInfo="" ""
    s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
    s ReInfo=obj.%Get("result")_"^"_obj.%Get("message")
    q ReInfo
}

/// 2.7电子健康卡是否存在
/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).ELEHealthCardExist("01^362523195812240025","0050569451b0","")
ClassMethod ELEHealthCardExist(Para As %String, TerminalID As %String = "", Secret As %String = "") As %String
{
	i Secret="" s Secret="W1KS92L108X"
	s CertType=$p(Para,"^",1)
	s CertID=$p(Para,"^",2)
	s DateTime=..GetCurrentDate()
	i TerminalID="" s TerminalID=..#TerminalID  ///
	s InstitutionID=..#InstitutionID
	s Appid=..#Appid
	s TerminalSecret=..GetTerminalSecret(Secret,DateTime)
	i TerminalSecret'="" s TerminalSecret=$tr(TerminalSecret,"""","")
	s NonceStr=..GetRandomNum(8)  
	s root=##class(%Library.DynamicObject).%New()
	d root.%Set("InstitutionID",InstitutionID)
	d root.%Set("TerminalID",TerminalID)
	d root.%Set("Time",DateTime)
	d root.%Set("CertType",CertType)
	d root.%Set("CertID",CertID)
	d root.%Set("TerminalSecret",TerminalSecret)
	s APIVerify=##class(%Library.DynamicObject).%New()
	d APIVerify.%Set("Appid",Appid)
	d APIVerify.%Set("Nonce_Str",NonceStr)
	d APIVerify.%Set("Time",DateTime)
	s Sign=..GetSign(Appid,NonceStr,DateTime)
	d APIVerify.%Set("Sign",Sign)
	d root.%Set("APIVerify",APIVerify)
	d root.%Set("MAC","")
	s ReJson=root.%ToJSON()
	s URL="/ECard/Exist-By-Terminal"
	s ReInfo=..HttpService(ReJson,URL)
    q:ReInfo="" ""
    s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
    s ReInfo=obj.%Get("result")_"^"_obj.%Get("message")
    s ^TempDHCEleHealthCard(+$h,"CardExist",$i(^TempDHCEleHealthCard(+$h,"CardExist")))=ReInfo
    q ReInfo
}

/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).ChildEleHealthCardRegister("01^360981200203076175^郭俊名^1^汉族^20020307^1^18720968867","","")
/// Para=01^360104199203041915^徐高远^1^汉族^19920304^南昌^18329163019
/// 2.6儿童电子健康卡注册
ClassMethod ChildEleHealthCardRegister(Para As %String, TerminalID As %String = "", Secret As %String = "") As %String
{
	////CertType CertID Name Gender Nation BirthDate Address Phone
	s ^tmp("ChildEleHealthCardRegister")=$lb(Para,TerminalID,Secret)
	i Secret="" s Secret="W1KS92L108X"
	s CertType=$p(Para,"^",1)
	s CertID=$p(Para,"^",2)
	s Name=$p(Para,"^",3)
	s Gender=$p(Para,"^",4)
	s Nation=$p(Para,"^",5)
	s BirthDate=$p(Para,"^",6)
	s Address=$p(Para,"^",7)
	s Phone=$p(Para,"^",8)
	s DateTime=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTime() //..GetCurrentDate()
	i TerminalID="" s TerminalID=..#TerminalID
	s InstitutionID=..#InstitutionID
	s Appid=..#Appid
	s TerminalSecret=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).GetTerminalSecret(Secret,DateTime) //..GetTerminalSecret(Secret,DateTime)
	i TerminalSecret'="" s TerminalSecret=$tr(TerminalSecret,"""","")
	s NonceStr=..GetRandomNum(8)  
	s root=##class(%Library.DynamicObject).%New()
	d root.%Set("InstitutionID",InstitutionID)
	d root.%Set("TerminalID",TerminalID)
	d root.%Set("Time",DateTime)
	d root.%Set("CertType",CertType)
	d root.%Set("CertID",CertID)
	d root.%Set("Name",Name)
	d root.%Set("TerminalSecret",TerminalSecret)
	s ResidentInfo=##class(%Library.DynamicObject).%New()
	d ResidentInfo.%Set("Gender",Gender)
	d ResidentInfo.%Set("Nation",Nation)
	d ResidentInfo.%Set("BirthDate",BirthDate)
	d ResidentInfo.%Set("Address",Address)
	d ResidentInfo.%Set("Phone",Phone)
	d root.%Set("residentInfo",ResidentInfo)
	s APIVerify=##class(%Library.DynamicObject).%New()
	d APIVerify.%Set("Appid",Appid)
	d APIVerify.%Set("Nonce_Str",NonceStr)
	d APIVerify.%Set("Time",DateTime)
	s Sign=..GetSign(Appid,NonceStr,DateTime)
	d APIVerify.%Set("Sign",Sign)
	d root.%Set("aPIVerify",APIVerify)
	d root.%Set("MAC","")
	s registerChildModel=##class(%Library.DynamicObject).%New()
	d registerChildModel.%Set("Name",Name)
	d registerChildModel.%Set("Gender",Gender)
	d registerChildModel.%Set("Birthdate",BirthDate)
	d root.%Set("registerChildModel",registerChildModel)
	s ReJson=root.%ToJSON()
	s URL="ECard/Register-By-Terminal"
	 set ReJsonstream=##class(%Stream.GlobalCharacter).%New()
	d ReJsonstream.Write(ReJson)
    s ReInfo=##class(web.DHCENS.BLL.ElectronicHealthCard.Method.SendElectronicHealthCardInfo).SendElectronicHealthCard("MES0307",ReJsonstream)
    q:ReInfo="" ""
    b ;01
    ///{"result":"0","data":"注册成功！","message":"注册成功！","mac":""}
    s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	s ReInfo=obj.%Get("result")_"^"_obj.%Get("data")
	s ^TempDHCEleHealthCard(+$h,"Register",$i(^TempDHCEleHealthCard(+$h,"Register")))=ReInfo
	q ReInfo
}

ClassMethod GetResponseDate(Info As %String, HisMedStepCode As %String = "") As %String
{
	q:Info="" ""
	s reInfo=""
	if (HisMedStepCode="HisReg")
	{
		s healthCardNo=Info.healthCardNo
		s cardNumber=Info.entityCardModel.cardNumber
		s birthDate=Info.residentInfoModel.birthDate
		i birthDate'="" s birthDate=$tr($p(birthDate," ",1),"/","-")
		s SexDesc=Info.residentInfoModel.gender
		s name=Info.residentInfoModel.name
		s Phone=Info.residentInfoModel.phone
		s nation=Info.residentInfoModel.nation
		s address=Info.residentInfoModel.address
		s SexDr=""
		i SexDesc'="" s SexDr=$O(^CT("SEX",0,"Desc",SexDesc,0))
		
		s myXMLData="<CredNo>"_cardNumber_"</CredNo>"
		s myXMLData=myXMLData_"<Name>"_name_"</Name>"
		s myXMLData=myXMLData_"<Sex>"_SexDr_"</Sex>"
		s myXMLData=myXMLData_"<Birth>"_birthDate_"</Birth>"
		s myXMLData=myXMLData_"<TelHome>"_Phone_"</TelHome>"
		s myXMLData=myXMLData_"<Address>"_address_"</Address>"
		s myXMLData = "<gRoot>" _ myXMLData _ "</gRoot>"
		s myXMLData="0^"_cardNumber_"^"_myXMLData
		s reInfo=myXMLData
	
	}elseif (HisMedStepCode="Register"){
		s reInfo=Info.result
	}elseif (HisMedStepCode="Apply"){
		s reInfo="0^"_Info.staticQrCode
		
	}elseif (HisMedStepCode="Verify"){
		s reInfo=Info.healthCardNo
	}else{
		s cardNumber=Info.entityCardModel.cardNumber	
		s reInfo=cardNumber
	}
	q reInfo
}

ClassMethod HttpService(Json As %String, URL As %String) As %String
{
	s ScanOutput=""
    s httpRequest=##class(%Net.HttpRequest).%New()
	s httpRequest.Timeout=5
	s httpRequest.Server=..#Server
	s httpRequest.Port=..#Port
	s httpRequest.ContentCharset="UTF-8"
	d httpRequest.ContentTypeSet("text/json")
	d httpRequest.EntityBody.Write(ReJson)
	s retStr=httpRequest.Post(URL)
	s contentInfo=httpRequest.HttpResponse.ContentInfo
	s statusCode=httpRequest.HttpResponse.StatusCode
	s dataStream=httpRequest.HttpResponse.Data
	i dataStream'="" s ScanOutput=dataStream.ReadLine()
	q ScanOutput
}

/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetSign(11,"20181102175703","ceshi")
ClassMethod GetSign(Appid, NonceStr, Time) As %String
{
   
    s Str=Appid_"&"_Time_"&"_NonceStr
	s Key="Qv2pUBP6"
	s sign=$system.Encryption.HMACSHA1(Str,Key)
	s sign=##class(web.Util.Encryption).Byte2Hex(sign)
	s sign=$zcvt(sign,"l")
	s signBase64=$system.Encryption.Base64Encode(sign,1)
	q signBase64
}

/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetCurrentDate()
ClassMethod GetCurrentDate() As %String
{
	s Date=""
	s httpRequest=##class(%Net.HttpRequest).%New()
	s httpRequest.Timeout=5
	s httpRequest.Server=..#Server
	s httpRequest.Port=..#Port
	s httpRequest.ContentCharset="UTF-8"
	d httpRequest.ContentTypeSet("text/json")
	s retStr=httpRequest.Get("/Time/GetCurrentTime")
	s contentInfo=httpRequest.HttpResponse.ContentInfo
	s statusCode=httpRequest.HttpResponse.StatusCode
	s dataStream=httpRequest.HttpResponse.Data
	i dataStream'="" s ScanOutput=dataStream.ReadLine()
	 s obj=##class(%Library.DynamicObject).%FromJSON(ScanOutput)
    if obj.%Get("result")=0
    {  ///data
	    s Date=obj.%Get("data")
    }
    
    
    
	q Date
}

/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetTerminalSecret()
ClassMethod GetTerminalSecret(Secret As %String, DateTime As %String) As %String
{
	s ScanOutput=""
	//s Seed1 = "123"_"&"_"123"_"&"_"20190115164200"
	s randomNum=..GetRandomNum(8)
	s Seed=Secret_"&"_randomNum_"&"_DateTime
	s signBase64=$system.Encryption.Base64Encode(Seed,1)
    s httpRequest=##class(%Net.HttpRequest).%New()
	s httpRequest.Timeout=5
	s httpRequest.Server=..#Server
	s httpRequest.Port=..#Port
	s httpRequest.ContentCharset="UTF-8"
	d httpRequest.ContentTypeSet("text/json")
	//d httpRequest.EntityBody.Write(signBase64)
	do httpRequest.InsertFormData("data",signBase64)
	s retStr=httpRequest.Get("/HospitalRegSecret/GetRsa")
	s contentInfo=httpRequest.HttpResponse.ContentInfo
	s statusCode=httpRequest.HttpResponse.StatusCode
	s dataStream=httpRequest.HttpResponse.Data
	i dataStream'="" s ScanOutput=dataStream.ReadLine()
	q ScanOutput
}

ClassMethod GetRandomNum(Len As %String) As %String
{
	s randomNum=""
	f i=1:1:Len
	{
		i randomNum="" {
			s randomNum=$Random(10)
			}else{
				s randomNum=randomNum_$Random(10)
				}
	}
	q randomNum
}

/// 根据病人ID注册电子健康卡并绑定 Add by tyq 2021-12-23
/// w ##Class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).CreatPatElecCardBind(1)
ClassMethod CreatPatElecCardBind(PatId As %String)
{
	q:PatId="" ""
	
	s myPAPMIRowID=PatId
	// 江西丰城人民要求将电子健康卡绑定到患者和卡信息上并建立索引，在扫码时根据健康卡索引获取患者信息 Add by tyq 2021-12-20
	// 将电子健康卡唯一识别ID和静态二维码信息保存到患者基本信息上，后续使用从这里拿
	s PatElecIndex=$p($g(^PAPER(myPAPMIRowID,"PER",4)),"^",25),PatElecStatic=$p($g(^PAPER(myPAPMIRowID,"PER",4)),"^",26)
	
	i (PatElecIndex="")||(PatElecStatic=""){
		s CredNo=$p($g(^PAPER(myPAPMIRowID,"ALL")),"^",9),CredType=$p($g(^PAPER(myPAPMIRowID,"PAT",3)),"^",7)
		s:CredType'="" CredType=$p($g(^PAC("CARD",CredType)),"^",1)
		if (CredNo'="")&&(CredType="01") {
			s Name=$p($g(^PAPER(myPAPMIRowID,"ALL")),"^",1)
			s Birth=$p($g(^PAPER(myPAPMIRowID,"ALL")),"^",6)
			i Birth'="" s Birth=$zd(Birth,8)
			s NationDesc=""
			s NationDescLookUpRowID=$p($g(^PAPER(myPAPMIRowID,"PER",2)),"^",1)
			i NationDescLookUpRowID'="" s NationDesc=$p(^CT("NAT",NationDescLookUpRowID),"^",2)
			s Sex=$p($g(^PAPER(myPAPMIRowID,"ALL")),"^",7)
			s Address=$g(^PAPER(myPAPMIRowID,"PER","ADD",1))
			s TelHome=$p($g(^PAPER(myPAPMIRowID,"PER",1)),"^",11)
			i TelHome="" s TelHome=$p($g(^PAPER(myPAPMIRowID,"PER",4)),"^",21)
			
			s ApplyInfo="01^"_CredNo_"^"_CredType
			i PatElecStatic="" {
				///静态二维码申请
				s ReInfo=##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeApply(ApplyInfo,"","")
				i $p(ReInfo,"^",1)=0 {
					s PatElecStatic=$p(ReInfo,"^",2)
				}
			}
			
			i PatElecIndex=""{
			    //电子健康卡注册	
			    s RegisterInfo="01^"_CredNo_"^"_Name_"^"_Sex_"^"_NationDesc_"^"_Birth_"^"_Address_"^"_TelHome
			    s ReInfo=##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).EleHealthCardRegister(RegisterInfo,"","")
				i $p(ReInfo,"^",1)=0 s PatElecIndex=$p(PatElecStatic,":",1)
				;s ApplyInfo="01^"_CredNo_"^"_Name
				;s ReInfo=##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeApply(ApplyInfo,"","")
				
				;s TCode=$p(ReInfo,"^",2)
				 //s TCode=$p(ReInfo,"^",2)
			}
			
			// 患者信息与电子健康卡信息绑定
			&SQL(Update SQLUser.PA_PatMas Set PAPMI_ElecMasterIndex=:PatElecIndex,PAPMI_ElecStaticQrcodePhoto=:PatElecStatic where PAPMI_RowId=:myPAPMIRowID)
		}	 
		
	}
	
	q 0
}

/// 根据静态二维码信息返回HIS患者卡号 Add by tyq 2021-12-23
/// Input:ElecStatic静态二维码文本信息，ChannelCode刷卡终端类型，MedStepCode诊疗环节代码
/// w ##Class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetPatCardNoByElecStatic("9D2A58D30DEE8CAECFE8A36FCF7DBBE836159A32B57C949C9F1F7EA3F4B42E71:1::3602A0015")
ClassMethod GetPatCardNoByElecStatic(ElecStatic As %String, ChannelCode As %String = "", MedStepCode As %String = "")
{
	q:ElecStatic="" "-1^请先扫码或输入卡号"
	
	q:$l(ElecStatic)<30 0_"^"_ElecStatic

 
	s ret=##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeVerification(ElecStatic, ChannelCode, MedStepCode)
	q:ret="" "-1^二维码验证失败，请重试。"

	s ElecIndex=ret
	s FindCFRowId=""
	s PatId=0
	f  s PatId=$o(^PAPERi("ElecMI",$zcvt(ElecIndex,"U"),PatId))  q:(PatId="")||(FindCFRowId'="")  d
	.q:'$d(^PAPER(PatId,"ALL"))
	.s PatActive=$p($g(^PAPER(PatId,"PAT",1)),"^",6)
	.q:PatActive="N"
	.s CardId=0
	.f  s CardId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatId,CardId)) q:(CardId="")||(FindCFRowId'="")  d
	..q:'$d(^DHCCARD("CF",CardId))
	..s CFActive=$p($g(^DHCCARD("CF",CardId)),"^",10)
	..q:CFActive'="N"
	..s FindCFRowId=CardId
	
	q:FindCFRowId="" "-1^HIS未找到对应的患者记录，请先建档。"
	
	s CarNo=$p($g(^DHCCARD("CF",FindCFRowId)),"^",2)
	
	q 0_"^"_CarNo
}

/// 根据静态二维码信息返回HIS患者卡号 Add by ls 2022-09-27
/// Input:ElecStatic静态二维码文本信息，ChannelCode刷卡终端类型，MedStepCode诊疗环节代码
/// w ##Class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetPatCardNoByElecStaticNew("9D2A58D30DEE8CAECFE8A36FCF7DBBE836159A32B57C949C9F1F7EA3F4B42E71:1::3602A0015")
ClassMethod GetPatCardNoByElecStaticNew(ElecStatic As %String, ChannelCode As %String = "", MedStepCode As %String = "")
{
	q:ElecStatic="" "-1^请先扫码或输入卡号"
	
	q:$l(ElecStatic)<30 0_"^"_ElecStatic

	/// 这里不需再调用二维码验证接口；通过扫码得到的二维码iD截取串后 根据PAPatmas表索引查找是否已建档即可
	/*s ret=##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeVerification(ElecStatic, ChannelCode, MedStepCode)
	q:ret="" "-1^二维码验证失败，请重试。"
	*/

	s ElecIndex=$p(ElecStatic,":",1)
	s FindCFRowId=""
	s PatId=0
	f  s PatId=$o(^PAPERi("ElecMI",$zcvt(ElecIndex,"U"),PatId))  q:(PatId="")||(FindCFRowId'="")  d
	.q:'$d(^PAPER(PatId,"ALL"))
	.s PatActive=$p($g(^PAPER(PatId,"PAT",1)),"^",6)
	.q:PatActive="N"
	.s CardId=0
	.f  s CardId=$o(^DHCCARDi("CF",0,"PAPMIDR",PatId,CardId)) q:(CardId="")||(FindCFRowId'="")  d
	..q:'$d(^DHCCARD("CF",CardId))
	..s CFActive=$p($g(^DHCCARD("CF",CardId)),"^",10)
	..q:CFActive'="N"
	..s FindCFRowId=CardId
	
	q:FindCFRowId="" "-1^HIS未找到对应的患者记录，请先建档。"
	
	s CarNo=$p($g(^DHCCARD("CF",FindCFRowId)),"^",2)
	
	q 0_"^"_CarNo
}

/// 如果patpas表内无健康卡索引，则通过二维码判断该患者是否有建档,若有建档则绑定电子健康卡信息
/// / ElecStati含有动态信息的二维码
/// w ##Class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetPatientIDByEle("9D2A58D30DEE8CAECFE8A36FCF7DBBE836159A32B57C949C9F1F7EA3F4B42E71:1::3602A0015")
ClassMethod GetPatientIDByEle(ElecStatic As %String)
{
	q:ElecStatic="" "-1^请先扫码或输入卡号"
	s ret=##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).StaticCodeVerification(ElecStatic, "HisReg")
	s retObj=##class(DHCDoc.Util.FromXML).Json2Arr(ret)

	;^PAPERi("DVA",$$ALPHAUP({PAPMI_DVAnumber}),{PAPMI_RowId})
	s IDCard=retObj.data.entityCardModel.cardNumber
	s IDCard=$ZCVT(IDCard,"U")
	s PatientID="",ReturnPatID="",FindCFRowId=""
	For{
		s PatientID=$O(^PAPERi("DVA",IDCard,PatientID))
		q:(PatientID="")||(ReturnPatID'="")
		s ActiveFlag=$P(^PAPER(PatientID,"PAT",1),"^",6)
		continue:ActiveFlag="N"
		s CredType=$P(^PAPER(PatientID,"PAT",3),"^",7)
		///证件类型是身份证
		continue:CredType'="20"
		s ReturnPatID=PatientID	
	}
	if (ReturnPatID'=""){
		do ..CreatPatElecCardBind(ReturnPatID)
		s CardId=0
		f  s CardId=$o(^DHCCARDi("CF",0,"PAPMIDR",ReturnPatID,CardId)) q:(CardId="")||(FindCFRowId'="")  d
		.q:'$d(^DHCCARD("CF",CardId))
		.s CFActive=$p($g(^DHCCARD("CF",CardId)),"^",10)
		.q:CFActive'="N"
		.s FindCFRowId=CardId
		q:FindCFRowId="" "-1^HIS未找到对应的患者记录，请先建档。"
		s CarNo=$p($g(^DHCCARD("CF",FindCFRowId)),"^",2)
			
	}else{
		q "-1^HIS未找到对应的患者记录，请先建档。"
	}
	q 0_"^"_CarNo
}

/// Description:提供HIS窗口获取二维码打印信息，未注册电子健康卡时先补发电子健康卡 Add by tyq 2021-12-23
/// W ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).NewJKCardInfo(3)
ClassMethod NewJKCardInfo(PatientId As %String)
{
	s ^Temp("JKCManager","NewJKCardInfo")=PatientId
	q:PatientId="" "-1^参数为空"
	
	s IDNo=$p($g(^PAPER(PatientId,"ALL")),"^",9)
	q:IDNo="" "-1^非实名患者不允许打印，请先至患者信息修改界面完善个人信息"
	
	;s HospId=%session.Get("LOGON.HOSPID")
	s RhcvId="",FindRhcvId="",NoRegistNomalCard=""
	s QrcodePhotoBase="",FindQrcodePhotoBase=""
	
	s FindRhcvId=$p($g(^PAPER(PatientId,"PER",4)),"^",25)
	s FindQrcodePhotoBase=$p($g(^PAPER(PatientId,"PER",4)),"^",26)
	i (FindRhcvId="")||(FindQrcodePhotoBase=""){
		d ##Class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).CreatPatElecCardBind(PatientId)
	}
	s FindRhcvId=$p($g(^PAPER(PatientId,"PER",4)),"^",25)
	s FindQrcodePhotoBase=$p($g(^PAPER(PatientId,"PER",4)),"^",26)
	q:FindRhcvId="" "-1^未获取到患者电子健康卡信息"
	
	s CardNo="",PatName=""
	s PatName=$p($g(^PAPER(PatientId,"ALL")),"^",1)
	s PatNo=$p($g(^PAPER(PatientId,"PAT",1)),"^",1)
	s FindQrcodePhotoBase=$TR(FindQrcodePhotoBase,$C(13),"")
	s FindQrcodePhotoBase=$TR(FindQrcodePhotoBase,$C(10),"")
	
	q "0^"_FindRhcvId_"^"_FindQrcodePhotoBase_"^"_PatName_"^"_CardNo_"^"_PatNo
}

/// w ##class(DHCDoc.Interface.Outside.JXSElecHealthCard.Methods).GetEleHeadlthInfo("9D2A58D30DEE8CAECFE8A36FCF7DBBE836159A32B57C949C9F1F7EA3F4B42E71:1::3602A0015")
ClassMethod GetEleHeadlthInfo(Code As %String) As %String
{
	s ReInfo=""
	s ReInfo=..StaticCodeVerification(Code,"HisReg")
	s retObj=##class(DHCDoc.Util.FromXML).Json2Arr(ReInfo)
	b ;l--1
	s result=retObj.result
	q:result'=0 ReInfo
	s CredNo=retObj.data.entityCardModel.cardNumber
	s Name=retObj.data.residentInfoModel.name
	s Phone=retObj.data.residentInfoModel.phone
	s Nation=retObj.data.residentInfoModel.nation
	s Address=retObj.data.residentInfoModel.address
	s XML="<IDRoot><Name>"_Name_"</Name><TelHome>"_Phone_"</TelHome><Address>"_Address_"</Address></IDRoot>"
	s ReInfo=CredNo_"^"_XML
	Quit ReInfo
}

}
