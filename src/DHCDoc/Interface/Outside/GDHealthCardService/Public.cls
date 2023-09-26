Class DHCDoc.Interface.Outside.GDHealthCardService.Public Extends (%RegisteredObject, Parameter)
{

/// 6.1电子健康码注册（createVmcardQRcode）
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).createVmcardQRcode(^temp("createVmcardQRcode"))
/// 路振^13220198902136413^01^^^^1^01^19890213^^18703213885^路振^18703213885^09^^^^^^^1^0^^^^3^
/// 姓名^证件号^证件类型^证件开始日期^证件结束日期^发证机关^性别^民族^出生日期^出生地（10）^本人手机号^联系人名字^联系人电话^婚姻状态^户籍地址^居住地址^证件照片^头像照片^国际^语言（20）^人员类型^多胎标志^多胎产次^母亲姓名^母亲身份证号^母亲主索引ID^操作方式^绑定ID
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).createVmcardQRcode("卢宇航^441602197604012114^1^^^^1^1^1976-04-01^^13600260802^^^^^^^^^^1^^^^^^3^0")
/// {"datas":{"qrCode":"7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3:1","empi":"B4BCD312D482FD75C75F6A135948C57E5B07ED325D169DE8A2614CF1E5DD5340","erhcCardNo":"7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3"},"returnCode":0,"returnDesc":"请求成功","signString":"7868e42c11d2ee10af89cca64880b747","timestamp":"1569466272"}
ClassMethod createVmcardQRcode(Para As %String, PAPMIRowID As %String = "", UserID As %String = "") As %String
{
	s ^temp("createVmcardQRcode")=Para
	//q 0
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("createVmcardQRcode",Para)
	b ; 测试
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","createVmcardQRcode")=$lb(JsonInfo,JsonOutput)
	b ;a2
	;s JsonOutput="{""datas"":{""qrCode"":""7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3:1"",""empi"":""B4BCD312D482FD75C75F6A135948C57E5B07ED325D169DE8A2614CF1E5DD5340"",""erhcCardNo"":""7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3""},""returnCode"":0,""returnDesc"":""请求成功"",""signString"":""7868e42c11d2ee10af89cca64880b747"",""timestamp"":""1569466272""}"
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s erhcCardNo=DataArray.GetAt("erhcCardNo")
		s qCode=DataArray.GetAt("qrCode")
		s qCode=success_"^"_erhcCardNo_"^"_qCode
		
		s Rtn=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).CreateHealthCard(erhcCardNo,PAPMIRowID,UserID,qCode)
	}else{
		s qCode=success_"^"_returnDesc
	}
	q qCode
}

/// 6.2电子健康码个人信息修改（modifyVmcardInfo）
/// w ##class(DHCDoc.Interface.Outside.GDHealthCardService.Public).modifyVmcardInfo(3)
ClassMethod modifyVmcardInfo(PersonID As %String, UserID As %String = "") As %String
{
	s ^temp("modifyVmcardInfo")=$lb(PersonID,UserID)
	s erhcCardNo=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEHCHealthCardByPat(PersonID)
	if erhcCardNo=""{
		Q "0^未查询到电子健康卡"	
	}
	
	s Para=PersonID_"^"_erhcCardNo
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("modifyVmcardInfo",Para)
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","modifyVmcardInfo")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	s ReInfo=success_"^"_returnDesc
	s ^temp("ReInfo1")=$lb(ReInfo)
	i success=0 { // 调用电子健康卡卡号重置（resetVmcardInfo）
		s ReInfo=..resetVmcardInfo(PersonID,UserID)
	}
	s ^temp("ReInfo")=$lb(ReInfo)
	q ReInfo
}

/// 6.3电子健康码个人信息查询（getPersonInfo）
/// 证件类型^证件号码^电子健康卡ID^操作方式
/// 7A1DB49A2B1615E02CA015D9FE9F34F21DD61CB9830C9B95A87F4F994B4DB4B3
/// 8F9D278DAC5F4E95545EB716F1EF3033E52C2959C658C2FA:1::1301A0002QTHX0001
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).getPersonInfo("^^8F9D278DAC5F4E95545EB716F1EF3033E52C2959C658C2FA^3")
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).getPersonInfo("^^FFFA52A9895301960D011CE893A1EF41CEE16F81B03F4BCE^3")
ClassMethod getPersonInfo(Para As %String) As %String
{
	s ^tempztw("getPersonInfo")=Para
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("getPersonInfo",Para)
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","getPersonInfo")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	
	s ret=""
	if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s name=DataArray.GetAt("name")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s idCode=DataArray.GetAt("idCode")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s idCardTypeCode=DataArray.GetAt("idCardTypeCode")
		s sex=DataArray.GetAt("sex")
		s nation=DataArray.GetAt("nation")
		s birthday=DataArray.GetAt("birthday")
		s phone=DataArray.GetAt("phone")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s linkman=DataArray.GetAt("linkman") ;联系人姓名
		s telephone=DataArray.GetAt("telephone") ;联系人电话
		s currentAddress=DataArray.GetAt("currentAddress") ;居住地址
		s erhcCardNo=DataArray.GetAt("erhcCardNo") ;电子健康码 ID
		
		s provinceCode=DataArray.GetAt("provinceCode") ;居住省份代码
		s provinceCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("provinceCode",provinceCode)		
		s addressCityCode=DataArray.GetAt("addressCityCode") ;居住城市代码
		s addressCityCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("addressCityCode",addressCityCode)
		s countyCode=DataArray.GetAt("countyCode") ;居住县区代码
		s countyCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("countyCode",countyCode)
		s professionType=DataArray.GetAt("professionType") ;职业类型
		s professionType=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("professionType",professionType)
		
		;s qCode=success_"^"_erhcCardNo_"^"_qCode

		s myXMLData="<CredNo>"_idCode_"</CredNo>"
		s myXMLData=myXMLData_"<CardNo>"_$p($p(Para,"^",3),":",1)_"</CardNo>"
		s myXMLData=myXMLData_"<Name>"_name_"</Name>"
		s myXMLData=myXMLData_"<Sex>"_sex_"</Sex>"
		s myXMLData=myXMLData_"<Birth>"_birthday_"</Birth>"
		s myXMLData=myXMLData_"<TelHome>"_phone_"</TelHome>"
		s myXMLData=myXMLData_"<Address>"_currentAddress_"</Address>"
		
		s myXMLData=myXMLData_"<ProvinceInfoLookUpRowID>"_provinceCode_"</ProvinceInfoLookUpRowID>"
		s myXMLData=myXMLData_"<CityDescLookUpRowID>"_addressCityCode_"</CityDescLookUpRowID>"
		s myXMLData=myXMLData_"<CityAreaLookUpRowID>"_countyCode_"</CityAreaLookUpRowID>"
		s myXMLData=myXMLData_"<Vocation>"_professionType_"</Vocation>"
		
		s myXMLData = "<gRoot>" _ myXMLData _ "</gRoot>"
		s ret=success_"^"_erhcCardNo_"^"_myXMLData
	}else{
		s ret=success_"^"_returnDesc
	}
	Q ret
}

/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).getActiveQrCode("A37A12E88B85C8E479AD27EEEAD68565DC2D3CC3461A7C00^3")
/// 6.4电子健康码二维码获取（getActiveQrCode）
ClassMethod getActiveQrCode(Para As %String) As %String
{
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("getActiveQrCode",Para)
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","getActiveQrCode")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	s ret=""
	if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s qrCode=DataArray.GetAt("qrCode")
		s name=DataArray.GetAt("name")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s idCode=DataArray.GetAt("idCode")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s idCardTypeCode=DataArray.GetAt("idCardTypeCode")
		s sex=DataArray.GetAt("sex")
		s nation=DataArray.GetAt("nation")
		s ret=success_"^"_qrCode
	}else{
		s ret=success_"^"_returnDesc
	}
	
	q ret
}

/// 6.5 电子卡二维码验证
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).getPersonInfoByQrCode("FFFA52A9895301960D011CE893A1EF41CEE16F81B03F4BCE:1::1301A0002QTHX0001^^010106^3")
ClassMethod getPersonInfoByQrCode(Para As %String) As %String
{
	s ^tempztw("getPersonInfoByQrCode")=Para
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("getPersonInfoByQrCode",Para)
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","getPersonInfoByQrCode")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	set ReInfo=""
	if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s qrCode=DataArray.GetAt("qrCode")
		s name=DataArray.GetAt("name")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s idCode=DataArray.GetAt("idCode")
		i name'="" s name=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(name)
		s idCardTypeCode=DataArray.GetAt("idCardTypeCode")
		s sex=DataArray.GetAt("sex")
		s nation=DataArray.GetAt("nation")
		s birthday=DataArray.GetAt("birthday")
		s phone=DataArray.GetAt("phone")
		i phone'="" s phone=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(phone)
		s currentAddress=DataArray.GetAt("currentAddress")
		s birthplace=DataArray.GetAt("birthplace")
		s maritalstatuscode=DataArray.GetAt("maritalstatuscode")
		s address=DataArray.GetAt("address")
		s nationality=DataArray.GetAt("nationality")
		s language=DataArray.GetAt("language")
		s residentFlag=DataArray.GetAt("residentFlag")
		s scenePhoto=DataArray.GetAt("scenePhoto")
		s linkman=DataArray.GetAt("linkman")
		i linkman'="" s linkman=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(linkman)
		s telephone=DataArray.GetAt("telephone")
		i telephone'="" s telephone=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetDeEncrypt(telephone)
		
		s provinceCode=DataArray.GetAt("provinceCode") ;居住省份代码
		s provinceCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("provinceCode",provinceCode)		
		s addressCityCode=DataArray.GetAt("addressCityCode") ;居住城市代码
		s addressCityCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("addressCityCode",addressCityCode)
		s countyCode=DataArray.GetAt("countyCode") ;居住县区代码
		s countyCode=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("countyCode",countyCode)
		s professionType=DataArray.GetAt("professionType") ;职业类型
		s professionType=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ConvertDataValueFrom("professionType",professionType)
		b ;a1
		s ReInfo=success_"^"_returnDesc
	}else{
		s ReInfo=success_"^"_returnDesc
	}
	q ReInfo
}

/// "01^440221198303035915^3"
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).queryIfHasRegistered("20^441602198003071977^3")
/// 6.6查询账户是否注册
ClassMethod queryIfHasRegistered(Para As %String) As %String
{
	s ^temp("queryIfHasRegistered")=Para
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("queryIfHasRegistered",Para)
	b ;JsonInfo
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","queryIfHasRegistered")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	set ReInfo=""
	if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s parameters=DataArray.GetAt("parameters") ;0:未查到此用户 1:已注册
		s remarks=DataArray.GetAt("remarks") ;若已经注册，提示上次注册信息
		s ReInfo=success_"^"_parameters_"^"_remarks
	}else{
		s ReInfo=success_"^"_returnDesc
	}
	
	q ReInfo
}

/// 6.7电子卡二维码领码/激活（activateVmcardQRcode）
/// w ##Class(DHCDoc.Interface.Outside.GDHealthCardService.Public).activateVmcardQRcode("20^441602198003071977^3")
/// 电子卡二维码领码/激活
ClassMethod activateVmcardQRcode(Para As %String) As %String
{
	s ^tempztw("activateVmcardQRcode")=Para
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("activateVmcardQRcode",Para)
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","activateVmcardQRcode")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")
	set ReInfo=""
	if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s qrCode=DataArray.GetAt("qrCode")
		s ReInfo=success_"^"_qrCode
	}else{
		s ReInfo=success_"^"_returnDesc
	}
	
	q ReInfo
}

/// Creator: 
/// Date: 2021-06-10 15:11:08
/// Description: 6.8电子健康卡卡号重置（resetVmcardInfo）（V1.1新增）（修改患者证件号码时调用）
///     		用于根据姓名，证件类型，证件号码重新生成电子健康卡ID和主索引ID，并根据原电子健康卡ID更新姓名，证件类型，证件号码等信息
/// Input: 
/// Output: 
/// Others: w ##class(DHCDoc.Interface.Outside.GDHealthCardService.Public).resetVmcardInfo(2,1)
ClassMethod resetVmcardInfo(PatientID As %String, UserID As %String = "") As %String
{
    s ^temp("resetVmcardInfo")=$lb(PatientID,UserID)
	s erhcCardNo=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).GetEHCHealthCardByPat(PatientID)
	if erhcCardNo=""{
		Q "0^未查询到电子健康卡"  // 只有有电子健康的卡才有重置的必要	
	}
	// Para：body中入参拼接
    s Para=PatientID_"^"_erhcCardNo
	s JsonInfo=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).GetJsonInfo("resetVmcardInfo",Para)
	s JsonOutput=##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).HttpService(JsonInfo)
	s ^temp("HealthCard","resetVmcardInfo")=$lb(JsonInfo,JsonOutput)
	set OutArrayOBJ=##class(web.INSUCacheJSON).Decode(JsonOutput)
	set success=OutArrayOBJ.GetAt("returnCode")  // 0 ：成功  非 0：不成功
	set returnDesc=OutArrayOBJ.GetAt("returnDesc")  // 对错误或异常的描述信息
    if (success=0)
	{
		s DataArray=OutArrayOBJ.GetAt("datas")
		s erhcCardNo=DataArray.GetAt("erhcCardNo")  // 电子健康卡 ID
		s qCode=DataArray.GetAt("qrCode")  // 静态码（只用于打印）
        s empi=DataArray.GetAt("empi")  // 主索引 ID(未使用)        
		s qCode=success_"^"_erhcCardNo_"^"_qCode		
		s Rtn=##class(DHCDoc.Interface.Outside.GDHealthCardService.SelfMethod).CreateHealthCard(erhcCardNo,PatientID,UserID,qCode)
	}else{
		s qCode=success_"^"_returnDesc
	}
	q qCode
}

/// / w ##class(web.DHCOPAdmReg).GetCodeCardInfoByPatNo("0001511339")
ClassMethod GetCodeCardInfoByPatNo(PatNo As %String)
{
	s DZJJKCardTypeID=+##class(DHCDoc.Interface.Outside.GDHealthCardService.Util).ReadCardTypeByDesc()
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

}
