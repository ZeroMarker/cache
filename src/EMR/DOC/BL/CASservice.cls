/// 名称:	EMR.DOC.BL.CASservice
/// 描述:	CA服务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.CASservice Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取CA服务是否开启
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"userLocID":"6","userID":"6","ssgroupID":"29"},"product":"OP","action":"GET_CASERVICE"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCAService(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userLocID = argInJson.params.userLocID
	s userID = argInJson.params.userID
	s ssgroupID = argInJson.params.ssgroupID
	s product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.CASservice).GetCAServiceJson(userLocID,userID,ssgroupID,product,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取CA服务是否开启
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserLocID：科室ID，aUserID:用户ID，aSSGroupID：安全组ID
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.UserData).GetUserDataJson("10209",.obj)
ClassMethod GetCAServiceJson(aUserLocID As %String, aUserID As %String, aSSGroupID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^获取CA服务信息失败"
	q:(aUserLocID="") strRes
    s jsonItem  = ##class(%DynamicObject).%New()
   	s CAServicvice="0"
    s IsCAON=##Class(CA.DigitalSignatureService).IsCAON()
    //最新的程序需要增加产品模块的判断
    s IsCACTLoc = ##Class(EMR.DOC.BL.CASservice).IsCACTLoc(aUserLocID,aUserID,aSSGroupID,aProduct)
	if ((IsCAON = "Y")||(IsCAON="1"))&&(IsCACTLoc = "1") {
	    s CAServicvice="1"
	
	}
	d argOutData.Write(CAServicvice)
	q "1"
}

/// Desc:       判断科室是否开启CA签名
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserLocID：科室ID，aUserID:用户ID，aSSGroupID：安全组ID,aProduct 项目标识
/// 			
/// Output:     1 开启CA，0 未开启
/// debug:  	q ##Class(EMR.OP.BL.UserData).IsCACTLoc("10209")
ClassMethod IsCACTLoc(aUserLocID As %String, aUserID As %String, aSSGroupID As %String, aProduct As %String) As %String
{
	q:(aUserLocID="") "-1^科室ID不能为空"
   	s ModelCode =$case(aProduct,"OP":"OPEMR","IP":"IPEMR")
    //最新的程序需要增加产品模块的判断
    if ($ll((##class(%Dictionary.CompiledMethod).%OpenId("CA.DigitalSignatureService||IsCACTLoc")).DefaultArgs) = "4") {
        s IsCACTLoc=##Class(CA.DigitalSignatureService).IsCACTLoc(aUserLocID,aUserID,aSSGroupID,ModelCode)
    } else {
        s IsCACTLoc=##Class(CA.DigitalSignatureService).IsCACTLoc(aUserLocID)
    }
	q IsCACTLoc
}

/// Desc:       获取CA服务JS
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"pageType":"BS","userID":"","ssgroupID":""},"product":"OP","action":"GET_CASERVICE_JS"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCAServiceJS(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s pageType = argInJson.params.pageType
	s productCode = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.CASservice).GetCAServiceJSJson(pageType,productCode,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取CA服务JS
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aPageType：页面类型“BS”，aProductCode：项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).GetUserDataJson("10209",.obj)
ClassMethod GetCAServiceJSJson(aPageType As %String, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
    //最新的程序需要增加产品模块的判断
	s HospitalName=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",aProductCode,"")
    s aPageType=$CASE(aPageType,"":"HISUI",:aPageType)
    if ("BJXHYY"=HospitalName) {
        d ##Class(EMR.OP.BL.OutputHtml).OnUsbChangedReadonly()
    } else {
        d ##Class(CA.DigitalSignatureService).OutPutSecXCommon()
    }
    ;d ##Class(EMR.OP.BL.OutputHtml).OutPutopkeysign(HospitalName, aPageType)
	q "1"
}

/// Desc:       获取患者签是否开启，并返回JS服务
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"userLocID":"6","userID":"","ssgroupID":""},"product":"OP","action":"OUTPUT_HANDSIGNJS"}
/// 			userLocID 科室ID,userID 用户ID，ssgroupID 安全组ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod OutPutHandSignJS(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userLocID = argInJson.params.userLocID
	s userID = argInJson.params.userID
	s ssgroupID = argInJson.params.ssgroupID
	s productCode = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.CASservice).OutPutHandSignJSJson(userLocID,userID,ssgroupID,productCode,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取患者签是否开启，并返回JS服务
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserLocID 科室ID,aUserID 用户ID,aSSGroupID 安全组ID,aProductCode 项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).GetUserDataJson("10209",.obj)
ClassMethod OutPutHandSignJSJson(aUserLocID As %String, aUserID As %String, aSSGroupID As %String, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
    q:(aUserLocID = "") "-1^科室ID不能为空"
    s strRes = ""
    //模块编码为（OPEMR/IPEMR）
    s strModelCode = aProductCode_"EMR"
	s isCAON = ##Class(CA.DigitalSignatureService).GetPatCAServiceStatus(aUserLocID,aUserID,aSSGroupID,strModelCode)
	q:(isCAON["0^") "-1^未开启CA服务:"_$p(isCAON,"^",2)
	
	s CAHandSignCompany="",IsSupportPDFSign="",IsNeedQrCode="",hospitalID=""
	s version = ..CAVersion()
	if ("2"=version) {
        s CAHandSignCompany = ##Class(CA.ConfigCommon).GetValueByName("DefaultHandSignVenderCode",hospitalID) //厂商代码
        s IsSupportPDFSign = ##Class(CA.ConfigCommon).GetValueByName("IsSupportPDFSign",hospitalID)           //是否支持PDF
        s IsNeedQrCode = ##Class(CA.ConfigCommon).GetValueByName("IsNeedQrCode",hospitalID)                   //是否需要显示二维码
	}else{
        s CAHandSignCompany = $G(^CF("CA","CAHandSignCompany"))  //厂商代码
        s IsSupportPDFSign = $G(^CF("CA","IsSupportPDFSign"))    //是否支持PDF
        s IsNeedQrCode = $G(^CF("CA","IsNeedQrCode"))            //是否需要显示二维码
	}
    w !,"<script type='text/javascript' src='../scripts/emr/js/bs.handSign_"_CAHandSignCompany_".js'></script>",!
	q "1"
}

/// Desc:      调用公共服务进行签名
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		
/// Output:     成功：1^SignID  失败：0^ErrMsg	
/// debug:  	w ##Class(EMR.DOC.BL.CASservice).Sign()
ClassMethod Sign(aUserCertCode As %String, aPmdType As %String, aDigest As %String, aSignValue As %String, CertNo As %String) As %String
{
	q:(aUserCertCode = "") "-1^用户唯一标示为空！"
	s caVer = ##Class(EMR.DOC.BL.CASservice).CAVersion()
	if (caVer = "2")
	{
		s caRes=##Class(CA.DigitalSignatureService).Sign(aUserCertCode,aPmdType,aDigest,aSignValue,CertNo)
	}
	else
	{
		s caRes=##Class(CA.DigitalSignatureService).Sign(aUserCertCode,aPmdType,aDigest,aSignValue)
	}
	q caRes
}

/// Desc:      调用公共服务进行PDF签名
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		argInData PDF流数据
/// 			aProductCode 项目标识
/// 			aDocumentID 文档ID
/// 			aDocName 文档标题
/// 			aKeyWord 签名关键字
/// 			aEpisodeID 就诊号
/// 			aUserID 用户ID
/// 			ASignType 签名类型
/// Output:     成功：1^SignID  失败：0^ErrMsg	
/// debug:  	w ##Class(EMR.DOC.BL.CASservice).PDFSign()
ClassMethod PDFSign(argInData As %GlobalCharacterStream, aProductCode As %String, aDocumentID As %String, aDocName As %String, aKeyWord As %String, aEpisodeID As %String, aUserID As %String, ASignType As %String = "")
{
	q:(argInData="")||((argInData.Size<100)) "-1^推送PDF错误,PDF不能为空"
	s ret = ##class(CA.PatSignService).PushToSignPDF("",argInData,aProductCode, aDocumentID, aDocName, aKeyWord, aEpisodeID, aUserID,ASignType)
	;s json = ##class(CA.Util.Json).FromJson(ret)
	s json = ##class(%DynamicObject).%FromJSON(ret)
	if (json.retCode '= "0")
	{
		q "-1^"_json.retMsg
	}
	q ret
}

/// Desc:      判定CA版本，1是老版 2是新版
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		
/// Output:     Y/N
/// debug:  	w ##Class(EMR.DOC.BL.CASservice).CAVersion()
ClassMethod CAVersion() As %String
{
	s id = $O(^DHCCERTAUTH.ConfigCommonI("IdxName"," CAVERSION",""))
	q:(id = "") "1"

	s ver = $lg($g(^DHCCERTAUTH.ConfigCommonD(id)),4)
	q ver
}

/// Desc:       获取签名值和时间戳
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"signID":"6"},"product":"OP","action":"GET_CASIGNDETAIL"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCASignDetail(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SignID = argInJson.params.signID
    s strRes = ##Class(EMR.DOC.BL.CASservice).GetCASignDetailJson(SignID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取签名值和时间戳
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CA.DigitalSignature表ID
/// Input: 		signID 签名ID
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).GetCASignDetailJson("10209",.obj)
ClassMethod GetCASignDetailJson(aSignID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
    s strRes=""
	q:(aSignID="") "-1^签名ID不能为空"
	s CAObj = ##class(CA.DigitalSignature).%OpenId(aSignID)
	q:CAObj="" "-1^根据签名ID获取签名信息失败"
	s jsonItem = ##class(%DynamicObject).%New()
	//签名值
	s jsonItem.SignValue=CAObj.SignValue
	//时间戳
	s jsonItem.SignTimeStamp=CAObj.SignTimeStamp
	d jsonItem.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取患者签配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"params":{},"product":"OP","action":"GET_CASIGNDETAIL"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAnySignLocation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product = argInJson.params.product
    s strRes = ##Class(EMR.DOC.BL.CASservice).GetAnySignLocationJson(product,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取患者签配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CA.DigitalSignature表ID
/// Input: 		aProduct 项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).GetCASignDetailJson("10209",.obj)
ClassMethod GetAnySignLocationJson(aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
    s strRes=""
	s jsonItem = ##class(%DynamicObject).%New()
	//AnySignLocation
	s jsonItem.Value=$G(^CF("CA","AnySignLocation"))
	d jsonItem.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取推送签名结果
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CA.DigitalSignature表ID
/// Input: 		aPatPushSignID 推送签名ID
/// 			aUserID 用户ID
/// 			aEntity 返回对象
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).GetPushSignResult("10209","")
ClassMethod GetPushSignResult(aPatPushSignID As %String, aUserID As %String = "", ByRef aEntity As CA.Entity.EDigitalSignPatPush) As %String
{
    s strRes=""
	s entity = ""
	s strRes = ##Class(CA.BL.DigitalSignPatPush).GetPushSignResult(aPatPushSignID,aUserID,.aEntity)
	q strRes
}

/// Desc:       撤销推送签
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CA.DigitalSignature表ID
/// Input: 		aPatPushSignID 推送签名ID
/// 			aUserID 用户ID
/// 			aEntity 返回对象
/// Output:     成功：1 失败： -1^失败信息 ,0^信息
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).CancelPushSign("","","")
ClassMethod CancelPushSign(aPatPushSignID As %String, aUserID As %String = "", ACancelReason As %String = "") As %String
{
    s strRes=""
	s strRes = ##Class(CA.BL.DigitalSignPatPush).CancelPushSign(aPatPushSignID,aUserID,ACancelReason)
	q strRes
}

/// Desc:       获取验签结果
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aSignID 推送签名ID
/// 			aDigest 用户ID
/// Output:     正确返回"1^签名人、日期时间"，错误返回"0^错误信息" 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CASservice).CancelPushSign("","","")
ClassMethod GetVerifySignResult(aSignID As %String, aDigest As %String) As %String
{
    s strRes=""
	s strRes = ##class(CA.DigitalSignatureService).GetVerifySignResult(aSignID,aDigest)
	q strRes
}

}
