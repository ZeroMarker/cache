Class DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter appId = "688d73da01214ded8caa920eb8c98ede";

Parameter orgCode = "c584ae0729774835ac9cb65c636446d2";

Parameter key = "b3cba00281fc4bc3801c8cdfd05b82e8";

// 222.222.40.2  外网测试地址 8098

// terminalCode="XT00005"

/// Parameter Server = "168.168.10.6";
Parameter Server = "172.16.4.23";

Parameter Port = 8888;

Parameter Link = "/api/";

Parameter version = "V1.1.4";

/// Parameter version = "/api/encrypt";
/// 5.1 电子健康卡注册
/// w ##Class(DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods).createVmcardQRcode(^temp("createVmcardQRcode"))
/// 路振涛^13220198902136412^01^^^^1^01^19890213^^18703213885^路振涛^18703213885^09^^^^^^^1^0^^^^3^
/// 姓名^证件号^证件类型^证件开始日期^证件结束日期^发证机关^性别^民族^出生日期^出生地（10）^本人手机号^联系人名字^联系人电话^婚姻状态^户籍地址^居住地址^证件照片^头像照片^国际^语言（20）^人员类型^多胎标志^多胎产次^母亲姓名^母亲身份证号^母亲主索引ID^操作方式^绑定ID
/// w ##Class(DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods).createVmcardQRcode("路振涛^13220198902136412^01^^^^1^01^19890213^^18703213885^路振涛^18703213885^09^^^^^^^1^0^^^^^3^")
/// {"datas":{"qrCode":"7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3:1","empi":"B4BCD312D482FD75C75F6A135948C57E5B07ED325D169DE8A2614CF1E5DD5340","erhcCardNo":"7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3"},"returnCode":0,"returnDesc":"请求成功","signString":"7868e42c11d2ee10af89cca64880b747","timestamp":"1569466272"}
ClassMethod createVmcardQRcode(Para As %String) As %String
{
	s ^temp("createVmcardQRcode")=Para
	s JsonInfo=..GetJsonInfo("createVmcardQRcode",Para)
	b ;-00
	s ReInfo=..HttpService(JsonInfo)
	b ;xz--1
	s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	if (obj.%Get("returnCode")=0)
	{
		s DataObj=obj.%Get("datas")
		s qCode=DataObj.%Get("erhcCardNo")
	}else{
			s qCode=""
	}
	q qCode
}

/// 5.2电子健康卡个人信息修改
ClassMethod modifyVmcardInfo(Para As %String) As %String
{
	s JsonInfo=..GetJsonInfo("modifyVmcardInfo",Para)
	s ReInfo=..HttpService(JsonInfo)
	s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	if (obj.%Get("returnCode")=0)
	{
		s ReInfo=0
		}else{
			s ReInfo=-1
			}
	q ReInfo
}

/// 5.3获取个人基本信息
/// 证件类型^证件号码^电子健康卡ID^操作方式
/// 7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3
/// 3E3CD944076BBF60BD028DC26954B22B130FB3E42993016C2D205A5F31FB0B33
/// w ##Class(DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods).getPersonInfo("^^7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3^3")
///  
ClassMethod getPersonInfo(Para As %String) As %String
{
	s ^temp("getPersonInfo")=$lb(Para)
	s JsonInfo=..GetJsonInfo("getPersonInfo",Para)
	
	s ReInfo=..HttpService(JsonInfo)
	b ;ReInfo
	s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	s myXMLData=""
	if (obj.%Get("returnCode")=0)
	{
		s ReInfo=0
		s DataObj=obj.%Get("datas")
		s name=DataObj.%Get("name")
		b ;xz---
		i name'="" s name=..GetDeEncrypt(name)
		s idCode=DataObj.%Get("idCode")
		i idCode'="" s idCode=..GetDeEncrypt(idCode)
		s sex=DataObj.%Get("sex")
		s birthday=DataObj.%Get("birthday")
		s phone=DataObj.%Get("phone")
		i phone'="" s phone=..GetDeEncrypt(phone) 
		s currentAddress=DataObj.%Get("currentAddress")
		s CardNo=DataObj.%Get("erhcCardNo")
		s myXMLData="<CardNo>"_$p($p(Para,"^",3),":",1)_"</CardNo>"
		s myXMLData=myXMLData_"<CredNo>"_idCode_"</CredNo>"
		s myXMLData=myXMLData_"<Name>"_name_"</Name>"
		s myXMLData=myXMLData_"<Sex>"_sex_"</Sex>"
		s myXMLData=myXMLData_"<Birth>"_birthday_"</Birth>"
		s myXMLData=myXMLData_"<TelHome>"_phone_"</TelHome>"
		s myXMLData=myXMLData_"<Address>"_currentAddress_"</Address>"
		s myXMLData = "<gRoot>" _ myXMLData _ "</gRoot>"
		s myXMLData=CardNo_"^"_myXMLData

		}else{
			s ReInfo=-1
			}
	s ReInfo=ReInfo_"^"_myXMLData
	q ReInfo
}

/// 5.4 电子健康卡二维码获取
ClassMethod getActiveQrCode(Para As %String) As %String
{
	s JsonInfo=..GetJsonInfo("getActiveQrCode",Para)
	s ReInfo=..HttpService(JsonInfo)
	s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	if (obj.%Get("returnCode")=0)
	{
		s ReInfo=0
		s DataObj=obj.%Get("datas")
		s qrCode=DataObj.%Get("qrCode")
		s name=DataObj.%Get("name")
		i name'="" s name=..GetDeEncrypt(name)
		s idCode=DataObj.%Get("idCode")
		i idCode'="" s idCode=..GetDeEncrypt(idCode)
		s sex=DataObj.%Get("sex")
		s nation=DataObj.%Get("nation")
		}else{
			s ReInfo=-1
			}
	q ReInfo
}

/// 5.5 电子卡二维码验证
ClassMethod getPersonInfoByQrCode(Para As %String) As %String
{
	 s JsonInfo=..GetJsonInfo("getPersonInfoByQrCode",Para)
	 s ReInfo=..HttpService(JsonInfo)
	 s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	 if (obj.%Get("returnCode")=0)
	{
		s DataObj=obj.%Get("datas")
		s name=DataObj.%Get("name")
		i name'="" s name=..GetDeEncrypt(name)
		s idCode=DataObj.%Get("idCode")
		i idCode'="" s idCode=..GetDeEncrypt(idCode)
		s idCardTypeCode=DataObj.%Get("idCardTypeCode")
		s sex=DataObj.%Get("sex")
		s nation=DataObj.%Get("nation")
		s birthday=DataObj.%Get("birthday")
		s phone=DataObj.%Get("phone")
		i phone'="" s phone=..GetDeEncrypt(phone)
		s qrCode=DataObj.%Get("qrCode")
		s currentAddress=DataObj.%Get("currentAddress")
		s birthplace=DataObj.%Get("birthplace")
		s maritalstatuscode=DataObj.%Get("maritalstatuscode")
		s address=DataObj.%Get("address")
		s nationality=DataObj.%Get("nationality")
		s language=DataObj.%Get("language")
		s residentFlag=DataObj.%Get("residentFlag")
		s scenePhoto=DataObj.%Get("scenePhoto")
		s linkman=DataObj.%Get("linkman")
		i linkman'="" s linkman=..GetDeEncrypt(linkman)
		s telephone=DataObj.%Get("telephone")
		i telephone'="" s telephone=..GetDeEncrypt(telephone)
		s ReInfo=0
		
		}else{
			s ReInfo="-1"
			}
	   q ReInfo
}

/// 5.7 主索引查询人员信息
ClassMethod getPersonInfoByEmpi(Para As %String) As %String
{
	 s JsonInfo=..GetJsonInfo("getPersonInfoByEmpi",Para)
	 s ReInfo=..HttpService(JsonInfo)
	 s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	 if (obj.%Get("returnCode")=0)
	 {
		s DataObj=obj.%Get("datas")
		s name=DataObj.%Get("name")
		i name'="" s name=..GetDeEncrypt(name)
		s idCode=DataObj.%Get("idCode")
		i idCode'="" s idCode=..GetDeEncrypt(idCode)
		s idCardTypeCode=DataObj.%Get("idCardTypeCode")
		s sex=DataObj.%Get("sex")
		s nation=DataObj.%Get("nation")
		s birthday=DataObj.%Get("birthday")
		s phone=DataObj.%Get("phone")
		i phone'="" s phone=..GetDeEncrypt(phone)
		s currentAddress=DataObj.%Get("currentAddress")
		s address=DataObj.%Get("address")
		s residentFlag=DataObj.%Get("residentFlag")
		s scenePhoto=DataObj.%Get("scenePhoto")
		s linkman=DataObj.%Get("linkman")
		s telephone=DataObj.%Get("telephone")
		s domainID=DataObj.%Get("domainID")
		s cardNo=DataObj.%Get("cardNo")
		s cardType=DataObj.%Get("cardType")
		s cardOrgCode=DataObj.%Get("cardOrgCode")
		s cardOrgName=DataObj.%Get("cardOrgName")
        s ReInfo=0
	}else
	{
		s ReInfo="-1"
		}
	q ReInfo
}

/// 5.15 用卡数据上传
ClassMethod batchUploaderhcCardUseInfo(Para As %String) As %String
{
	 s JsonInfo=..GetJsonInfo("getPersonInfoByEmpi",Para)
	 s ReInfo=..HttpService(JsonInfo)
	 s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	 if (obj.%Get("returnCode")=0)
	 { 
	    s ReInfo=0
	}else{
		s ReInfo="-1"
		}
	q ReInfo
}

/// 5.19 电子健康卡注销
ClassMethod cancelVmcardInfo(Para As %String) As %String
{
	s JsonInfo=..GetJsonInfo("cancelVmcardInfo",Para)
	 s ReInfo=..HttpService(JsonInfo)
	 s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	 if (obj.%Get("returnCode")=0)
	 { 
	    s ReInfo=0
	}else{
		s ReInfo="-1"
		}
	q ReInfo
}

/// 5.21 始读终端注册
ClassMethod registerNo(Para As %String) As %String
{
	 s JsonInfo=..GetJsonInfo("registerNo",Para)
	 s ReInfo=..HttpService(JsonInfo)
	 s obj=##class(%Library.DynamicObject).%FromJSON(ReInfo)
	 if (obj.%Get("returnCode")=0)
	 { 
	    s ReInfo=0
	}else{
		s ReInfo="-1"
		}
	q ReInfo
}

ClassMethod GetJsonInfo(Method As %String, Para As %String) As %String
{
	k ^DHCDocEleHealthCard($j)
	s GetInfoObj=##class(%Library.DynamicObject).%New()
	d GetInfoObj.%Set("appId",..#appId)
	d GetInfoObj.%Set("orgCode",..#orgCode)
	;s Time=$zt($p($h,",",2))
	s Time=$zd($h,8)_$replace($zt($p($h,",",2)),":","")
	s timestamp=..GetEncrypt(Time)
	d GetInfoObj.%Set("timestamp",timestamp)
	s nonceStr=..GetRandomNum(15)
	d GetInfoObj.%Set("nonceStr",nonceStr)
	d GetInfoObj.%Set("version",..#version)
	d GetInfoObj.%Set("method",Method)
	;b ;headSign -strat
	s headSign=..GetSign(nonceStr,timestamp)
	;b ;headSign -end
	d GetInfoObj.%Set("headSign",headSign)
	d GetInfoObj.%Set("bodySign","")  //放入if条件里面赋值
	d GetInfoObj.%Set("signMode","MD5")
	d GetInfoObj.%Set("encryptMode","DESede/ECB/ZeroBytePadding")
	d GetInfoObj.%Set("signature","")
	
	if Method="createVmcardQRcode"
	{

		s name=$p(Para,"^",1)
		i name'="" s name=..GetEncrypt(name)
		s idCode=$p(Para,"^",2)
		i idCode'="" s idCode=..GetEncrypt(idCode)
		s idCardTypeCode=$p(Para,"^",3)
		s validStartdate=$p(Para,"^",4)
		s validEnddate=$p(Para,"^",5)
		s idInst=$p(Para,"^",6)
		s sex=$p(Para,"^",7)
		s nation=$p(Para,"^",8)
		s birthday=$p(Para,"^",9)
		s birthplace=$p(Para,"^",10)
		s phone=$p(Para,"^",11)
		i phone'="" s phone=..GetEncrypt(phone)
		s linkman=$p(Para,"^",12)
		i linkman'="" s linkman=..GetEncrypt(linkman)
		s telephone=$p(Para,"^",13)
		i telephone'="" s telephone=..GetEncrypt(telephone)
		s maritalstatuscode=$p(Para,"^",14)
		s address=$p(Para,"^",15)
		s currentAddress=$p(Para,"^",16)
		s idPhoto=$p(Para,"^",17)
		s scenePhoto=$p(Para,"^",18)
		s nationality=$p(Para,"^",19)
		s language=$p(Para,"^",20)
		s personnelType=$p(Para,"^",21)
		s multifetalMark=$p(Para,"^",22)
		s multpripleBirths=$p(Para,"^",23)
		s motherName=$p(Para,"^",24)
		i motherName'="" s motherName=..GetEncrypt(motherName)
		s motherIdCode=$p(Para,"^",25)
		i motherIdCode'="" s motherIdCode=..GetEncrypt(motherIdCode)
		s motherEmpi=$p(Para,"^",26)
		s appMode=$p(Para,"^",27)
		s payAccType=$p(Para,"^",28)
        
        s ^DHCDocEleHealthCard($j,"name")=name
        s ^DHCDocEleHealthCard($j,"idCode")=idCode
        s ^DHCDocEleHealthCard($j,"idCardTypeCode")=idCardTypeCode
        s ^DHCDocEleHealthCard($j,"validStartdate")=validStartdate
        s ^DHCDocEleHealthCard($j,"validEnddate")=validEnddate
        s ^DHCDocEleHealthCard($j,"idInst")=idInst
        s ^DHCDocEleHealthCard($j,"sex")=sex
        s ^DHCDocEleHealthCard($j,"nation")=nation
        s ^DHCDocEleHealthCard($j,"birthday")=birthday
        s ^DHCDocEleHealthCard($j,"birthplace")=birthplace
        s ^DHCDocEleHealthCard($j,"phone")=phone
        s ^DHCDocEleHealthCard($j,"linkman")=linkman
        s ^DHCDocEleHealthCard($j,"telephone")=telephone
        s ^DHCDocEleHealthCard($j,"maritalstatuscode")=maritalstatuscode
        s ^DHCDocEleHealthCard($j,"address")=address
        s ^DHCDocEleHealthCard($j,"currentAddress")=currentAddress
        s ^DHCDocEleHealthCard($j,"idPhoto")=idPhoto
        s ^DHCDocEleHealthCard($j,"scenePhoto")=scenePhoto
        s ^DHCDocEleHealthCard($j,"nationality")=nationality
        s ^DHCDocEleHealthCard($j,"language")=language
        s ^DHCDocEleHealthCard($j,"personnelType")=personnelType
        s ^DHCDocEleHealthCard($j,"multifetalMark")=multifetalMark
        s ^DHCDocEleHealthCard($j,"multpripleBirths")=multpripleBirths
        s ^DHCDocEleHealthCard($j,"motherName")=motherName
        s ^DHCDocEleHealthCard($j,"motherIdCode")=motherIdCode
        s ^DHCDocEleHealthCard($j,"motherEmpi")=motherEmpi
        s ^DHCDocEleHealthCard($j,"appMode")=appMode
        s ^DHCDocEleHealthCard($j,"payAccType")=payAccType
       }elseif (Method="getPersonInfo")
		{
		   //证件类型^证件号码^电子健康卡ID^操作方式
		   s idCardTypeCode=$p(Para,"^",1)
		   s idCode=$p(Para,"^",2)
		   i idCode'="" s idCode=..GetEncrypt(idCode)
		   s erhcCardNo=$p(Para,"^",3)
		   s appMode=$p(Para,"^",4)
		   s ^DHCDocEleHealthCard($j,"idCardTypeCode")=idCardTypeCode
		   s ^DHCDocEleHealthCard($j,"idCode")=idCode
		   s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
		   s ^DHCDocEleHealthCard($j,"appMode")=appMode

        }elseif (Method="modifyVmcardInfo")
        {
	       s erhcCardNo=$p(Para,"^",1)
           s sex=$p(Para,"^",2)
		   s nation=$p(Para,"^",3)
		   s validStartdate=$p(Para,"^",4)
		   s validEnddate=$p(Para,"^",5)
		   s idInst=$p(Para,"^",6)
		   s birthday=$p(Para,"^",7)
		   s birthplace=$p(Para,"^",8)
		   s phone=$p(Para,"^",9)
		   i phone'="" s phone=..GetEncrypt(phone)
		   s linkman=$p(Para,"^",10)
		   i linkman'="" s linkman=..GetEncrypt(linkman)
		   s telephone=$p(Para,"^",11)
		   i telephone'="" s telephone=..GetEncrypt(telephone)
		   s maritalstatuscode=$p(Para,"^",12)
		   s address=$p(Para,"^",13)
		   s currentAddress=$p(Para,"^",14)
		   s scenePhoto=$p(Para,"^",15)
		   s nationality=$p(Para,"^",16)
		   s language=$p(Para,"^",17)
		   s appMode=$p(Para,"^",18)
           
           s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
           s ^DHCDocEleHealthCard($j,"sex")=sex
           s ^DHCDocEleHealthCard($j,"nation")=nation
           s ^DHCDocEleHealthCard($j,"validStartdate")=validStartdate
           s ^DHCDocEleHealthCard($j,"validEnddate")=validEnddate
           s ^DHCDocEleHealthCard($j,"idInst")=idInst
           s ^DHCDocEleHealthCard($j,"birthday")=birthday
           s ^DHCDocEleHealthCard($j,"birthplace")=birthplace
           s ^DHCDocEleHealthCard($j,"phone")=phone
           s ^DHCDocEleHealthCard($j,"linkman")=linkman
           s ^DHCDocEleHealthCard($j,"telephone")=telephone
           s ^DHCDocEleHealthCard($j,"maritalstatuscode")=maritalstatuscode
           s ^DHCDocEleHealthCard($j,"address")=address
           s ^DHCDocEleHealthCard($j,"currentAddress")=currentAddress
           s ^DHCDocEleHealthCard($j,"scenePhoto")=scenePhoto
           s ^DHCDocEleHealthCard($j,"nationality")=nationality
           s ^DHCDocEleHealthCard($j,"language")=language
           s ^DHCDocEleHealthCard($j,"appMode")=appMode
          }elseif (Method="getActiveQrCode")
          {
	          s erhcCardNo=$p(Para,"^",1)
	          s appMode=$p(Para,"^",2)
	          s ^DHCDocEleHealthCard($j,"erhcCardNo")=erhcCardNo
	          s ^DHCDocEleHealthCard($j,"appMode")=appMode
	      }elseif (Method="getPersonInfoByQrCode")
	      {
		      s qrCode=$p(Para,"^",1)
			  s terminalCode=$p(Para,"^",2)
			  s medStepCode=$p(Para,"^",3)
			  s appMode=$p(Para,"^",4)
				
			  s ^DHCDocEleHealthCard($j,"qrCode")=qrCode
			  s ^DHCDocEleHealthCard($j,"terminalCode")=terminalCode
			  s ^DHCDocEleHealthCard($j,"medStepCode")=medStepCode
			  s ^DHCDocEleHealthCard($j,"appMode")=appMode
           }elseif (Method="getPersonInfoByEmpi")
           {
	          s empi=Para
	          s ^DHCDocEleHealthCard($j,"empi")=empi
	       }elseif (Method="batchUploaderhcCardUseInfo")
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

        s BodyObj=##class(%Library.DynamicObject).%New()
	    s SortDesc=""
	    for {
		   s SortDesc=$o(^DHCDocEleHealthCard($j,SortDesc))
		   q:SortDesc=""
		   d BodyObj.%Set(SortDesc,^DHCDocEleHealthCard($j,SortDesc))
		 }
		s bodySign=..GetBodySign(BodyObj)
		d GetInfoObj.%Set("bodySign",bodySign) 
		d GetInfoObj.%Set("body",BodyObj)
		s GetInfoJson=GetInfoObj.%ToJSON()
		q GetInfoJson
}

ClassMethod GetEncrypt(params As %String) As %String
{
	s result=""
	s EncryptObj=##class(%Library.DynamicObject).%New()
	d EncryptObj.%Set("key",..#key)
	d EncryptObj.%Set("params",params)
	s EncryptJson=EncryptObj.%ToJSON()
	s OutJson=..HttpService(EncryptJson,"encrypt")
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

/// w ##Class(DHCDoc.Interface.Outside.ElecHealthCardService.ElecHealthCardMethods).GetDeEncrypt("673B3F94095302C7EB6CB619E87B9C96")
ClassMethod GetDeEncrypt(params As %String) As %String
{
	s result=""
	s EncryptObj=##class(%Library.DynamicObject).%New()
	d EncryptObj.%Set("key",..#key)
	d EncryptObj.%Set("params",params)
	s EncryptJson=EncryptObj.%ToJSON()
	b ;
	s OutJson=..HttpService(EncryptJson,"deciphering")
	b ;...
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

ClassMethod GetSign(nonceStr As %String, timestamp As %String) As %String
{
	s result=""
	s SignObj=##class(%Library.DynamicObject).%New()
	d SignObj.%Set("key",..#key)
	s bodyObj=##class(%Library.DynamicObject).%New()
	d bodyObj.%Set("appId",..#appId)
	d bodyObj.%Set("nonceStr",nonceStr)
	d bodyObj.%Set("orgCode",..#orgCode)
	d bodyObj.%Set("timestamp",timestamp)
	d bodyObj.%Set("version",..#version)
	d SignObj.%Set("body",bodyObj)
	s SignJson=SignObj.%ToJSON()
	b ;EncryptJson
	s OutJson=..HttpService(SignJson,"sign")
	b ;OutJson -GetSign
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

ClassMethod GetBodySign(Body As %String) As %String
{
	s result=""
	s BodySignObj=##class(%Library.DynamicObject).%New()
	d BodySignObj.%Set("key",..#key)
	d BodySignObj.%Set("body",Body)
	s BodySignJson=BodySignObj.%ToJSON()
	s OutJson=..HttpService(BodySignJson,"sign")
	s obj=##class(%Library.DynamicObject).%FromJSON(OutJson)
	 if obj.%Get("code")=0
    {
	    s result=obj.%Get("result")
    }
	q result
}

ClassMethod HttpService(Json As %String, tLink As %String = "do") As %String
{
	s ScanOutput=""
    s httpRequest=##class(%Net.HttpRequest).%New()
	s httpRequest.Timeout=5
	s httpRequest.Server=(..#Server)
	s httpRequest.Port=(..#Port)
	s httpRequest.ContentCharset="utf-8"
	//d httpRequest.ContentTypeSet("application/json")
	d httpRequest.ContentTypeSet("text/plain")  ;不然汉字转码会有问题
	d httpRequest.EntityBody.Write(Json)
	s retStr=httpRequest.Post(..#Link_tLink)
	b ;;;2
	s contentInfo=httpRequest.HttpResponse.ContentInfo
	s statusCode=httpRequest.HttpResponse.StatusCode
	s dataStream=httpRequest.HttpResponse.Data
	i dataStream'="" s ScanOutput=dataStream.ReadLine()
	
	q ScanOutput
}

/// 生成随机数 (入参位随机数的长度)
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

ClassMethod ReadCardTypeByDesc1(Desc)
{
	s DZJJKCardTypeID=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","DZJJKCardTypeID")
	s myTypeID=0 s myval="" 
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:((myTypeID="")||(myval'=""))  d
	.q:myTypeID'=DZJJKCardTypeID
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	q myval
}

/// / w ##class(web.DHCOPAdmReg).GetCodeCardInfoByPatNo("0001511339")
ClassMethod GetCodeCardInfoByPatNo(PatNo As %String)
{
	s DZJJKCardTypeID=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","DZJJKCardTypeID")
	s rtn=""
	s PatNo=$$ALPHAUP^SSUTIL4(PatNo)
	s PAPMIRowId="" f  s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PatNo,PAPMIRowId)) q:PAPMIRowId=""  d
	.s CFRowID="" f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIRowId,CFRowID)) q:CFRowID=""  d
	..s ActiveFlag=$P(^DHCCARD("CF",CFRowID),"^",10) 
	..q:ActiveFlag'="N"
	..s CFCardTypeDR=$P(^DHCCARD("CF",CFRowID),"^",16)
	..q:DZJJKCardTypeID'=CFCardTypeDR
	..s CardNo=$P(^DHCCARD("CF",CFRowID),"^",2)
	..s rtn=..GetCodeCardInfo(CardNo)
	
	q rtn
}

ClassMethod GetCodeCardInfo(CardNo As %String) As %String
{
	s ReInfo=""
	s CFRowId=""
	for 
	{
		s CFRowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowId))
		q:CFRowId=""
		s ActiveFlag=$P(^DHCCARD("CF",CFRowId),"^",10) 
	    continue:ActiveFlag'="N"
	    s PatientID=$P(^DHCCARD("CF",CFRowId),"^",4)
	    s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	    s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    s PatSex="",Age=""
	    s PatSexDR=$p($g(^PAPER(PatientID,"ALL")),"^",7)
		i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
		s PatDOB=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	    s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	    s Age=$p(Age,"|",12)
		s ReInfo=Name_"^"_PatSex_"^"_PatientNo_"^"_Age _"^"_CardNo
	}
	q ReInfo
}

Storage Default
{
<Data name="ElecHealthCardMethodsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCDoc.Int7768.ElecHealthC8D6ED</DataLocation>
<DefaultData>ElecHealthCardMethodsDefaultData</DefaultData>
<IdLocation>^DHCDoc.Int7768.ElecHealthC8D6ED</IdLocation>
<IndexLocation>^DHCDoc.Int7768.ElecHealthC8D6EI</IndexLocation>
<StreamLocation>^DHCDoc.Int7768.ElecHealthC8D6ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
