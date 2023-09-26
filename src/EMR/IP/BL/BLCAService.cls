/// 名称:	EMR.IP.BL.BLCAService
/// 描述:	CA服务类
/// 编写者：lifengbo
/// 编写日期: 2023-04-07
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLCAService Extends EMR.IP.COM.ActionBase
{

/// Desc:       获取CA服务是否开启
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
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
    s strRes = ##Class(EMR.DOC.BL.CAService).GetCAServiceJson(userLocID,userID,ssgroupID,product,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
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
    s IsCACTLoc = ##Class(EMR.DOC.BL.CAService).IsCACTLoc(aUserLocID,aUserID,aSSGroupID,aProduct)
	if ((IsCAON = "Y")||(IsCAON="1"))&&(IsCACTLoc = "1") {
	    s CAServicvice="1"
	
	}
	d argOutData.Write(CAServicvice)
	q "1"
}

/// Desc:       判断科室是否开启CA签名
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
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
    s strRes = ##Class(EMR.IP.BL.BLCAService).GetCAServiceJSJson(pageType,productCode,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input: 		aPageType：页面类型“BS”，aProductCode：项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.IP.BL.BLCAService).GetCAServiceJSJson("BS","IP",.obj)
ClassMethod GetCAServiceJSJson(aPageType As %String, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr=[]
    //最新的程序需要增加产品模块的判断
	s HospitalName=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",aProductCode,"")
    s aPageType=$CASE(aPageType,"":"HISUI",:aPageType)
    s serviceJSData="",serviceJSList=""
    if ("BJXHYY"=HospitalName) {
        s scriptTagContent = ##Class(EMR.IP.BL.BLCAService).GetOnUsbChangedReadonly()
    } else {
        s scriptTagList = ##Class(EMR.IP.BL.BLCAService).GetOutPutSecXCommon()
    }
    s tagData = ""
    
    for i=1:1:$ll(scriptTagList)
    {
		
		s srcPath= $list(scriptTagList,i)
		s tagScript = "<script type='text/javascript' src='"_srcPath_"'></script>"
		s tagData = tagData_tagScript
	
	}
	
	if (scriptTagContent'="")
	{
		s tagData = tagData_scriptTagContent
	}
	
	//为空的时，不写入outData。
	if (tagData'="")
	{
		//argOutData按字符串输出数据，需要两端补充双引号
		s tagData = """"_tagData_""""
    	d argOutData.Write(tagData)
	}
	q 1
}

/// Desc:   重写ca接入系统代码（从write 修改为 拼接代码string动态加载）
/// 			详见 d ##Class(CA.DigitalSignatureService).OnUsbChangedReadonly()
/// Creator:    lifengbo
/// CreateDate: 2023-04-11
/// debugger: w ##Class(EMR.IP.BL.BLCAService).GetOnUsbChangedReadonly()
ClassMethod GetOnUsbChangedReadonly() As %String
{
	s returnScript = ""
	
	s returnScript =returnScript_ " <script type='text/javascript'>"_$c(10)
	s returnScript =returnScript_ "    if (!getList_pnp()) "_$c(10)
	s returnScript =returnScript_ "       { envVar.readonly = true; "_$c(10)
	s returnScript =returnScript_ "          alert('当前未插key，请插入key后进行操作！');} "_$c(10)
	s returnScript =returnScript_ " </script>"_$c(10)
  	s returnScript =returnScript_ " <script for='XTXAPP' event='OnUsbkeyChange' language='javascript'>"_$c(10)
   	s returnScript =returnScript_ "     function OnUsbkeyChange() "_$c(10)
   	s returnScript =returnScript_ "     {"_$c(10)
	s returnScript =returnScript_ "        if (!getList_pnp())  "_$c(10)
	s returnScript =returnScript_ "             { envVar.readonly = true; "_$c(10)
	s returnScript =returnScript_ "               alert('当前未插key，请插入key后进行操作！');} "_$c(10)  	
	s returnScript =returnScript_ "        else { envVar.readonly = false; } "_$c(10)
	s returnScript =returnScript_ "        if (typeof emrEditor.setEditorReadonly == 'function') emrEditor.setEditorReadonly();"_$c(10)
   	s returnScript =returnScript_ "     }"_$c(10)
   	s returnScript =returnScript_ "     OnUsbkeyChange();"_$c(10)
   	s returnScript =returnScript_ " </script>"_$c(10)
   	
   	q returnScript
}

/// Desc:   重写ca接入系统代码（返回js路径信息）
/// 			详见 d ##Class(CA.DigitalSignatureService).OutPutSecXCommon()
/// Creator:    lifengbo
/// CreateDate: 2023-04-11
/// Input: 	loginType 登录方式，值域：UKEY, FACE, PHONE
/// debugger: w ##Class(EMR.IP.BL.BLCAService).GetOutPutSecXCommon()
ClassMethod GetOutPutSecXCommon(CALogonType As %String = "", CAVenderCode As %String = "", CTLocID As %String = "", AHospID As %String = "") As %List
{
	//从session初始化登录信息
	d ##class(CA.Util.LogonInfo).GetLogon("", .CTLocID, "", .AHospID)
    
    //增加逻辑判断，未传入指定登录方式和厂商时，判断科室未开启CA则不输出CA接口js
    if (CALogonType = "")&&(CAVenderCode = "")
	{
		s isCAOn = ##Class(CA.DigitalSignatureService).GetCAServiceStatus(CTLocID)
		q:(isCAOn '= 1) ""
	}
	
	s signTypeAndVender = ##class(CA.DSService).GetSignTypeAndVender(CALogonType, CAVenderCode, CTLocID, AHospID)
	q:(signTypeAndVender = "") ""
	
	s signType = $p(signTypeAndVender, "^", 1)
	s venderCode = 	$p(signTypeAndVender, "^",2)
	
	s result=""
	// 只输出一个js接口文件，如果第三方自身也有自定义的其他js文件，将其内容复制到接口文件
	s jsPath = ##Class(CA.DSService).GetJSPath(signType,venderCode)
	
	s result = $lb(jsPath)
    	
    quit result
}

/// Desc:       获取患者签是否开启，并返回JS服务
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
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
	s strRes = ##Class(EMR.IP.BL.BLCAService).OutPutHandSignJSJson(userLocID,userID,ssgroupID,productCode,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input: 		aUserLocID 科室ID,aUserID 用户ID,aSSGroupID 安全组ID,aProductCode 项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			w ##Class(EMR.IP.BL.BLCAService).OutPutHandSignJSJson(191,18881,29,"IP",.obj)
ClassMethod OutPutHandSignJSJson(aUserLocID As %String, aUserID As %String, aSSGroupID As %String, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
    q:(aUserLocID = "") "-1^科室ID不能为空"
    s strRes = ""
    s $zt="ERROR"
    //模块编码为（OPEMR/IPEMR）
    s strModelCode = aProductCode_"EMR"
   
	s isCAON = ##Class(CA.DigitalSignatureService).GetPatCAServiceStatus(aUserLocID,aUserID,aSSGroupID,aProductCode)
	
	if (isCAON [ "0^") 
	{
		
		//未启用CA返回空
		q 1
	}
	
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
	//拼接ca输出
	s scriptData = """<script type='text/javascript' src='../scripts/emr/js/bs.handSign_"_CAHandSignCompany_".js'></script>"""
	d argOutData.Write(scriptData)
    
	q "1"
ERROR
	s $zt=""
	q "-1^"_$ze
}

/// Desc:      调用公共服务进行签名
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input: 		
/// Output:     成功：1^SignID  失败：0^ErrMsg	
/// debug:  	w ##Class(EMR.DOC.BL.CAService).Sign()
ClassMethod Sign(aUserCertCode As %String, aPmdType As %String, aDigest As %String, aSignValue As %String, CertNo As %String) As %String
{
	q:(aUserCertCode = "") "-1^用户唯一标示为空！"
	s caVer = ##Class(EMR.DOC.BL.CAService).CAVersion()
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
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
/// debug:  	w ##Class(EMR.DOC.BL.CAService).PDFSign()
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input: 		
/// Output:     Y/N
/// debug:  	w ##Class(EMR.DOC.BL.CAService).CAVersion()
ClassMethod CAVersion() As %String
{
	s id = $O(^DHCCERTAUTH.ConfigCommonI("IdxName"," CAVERSION",""))
	q:(id = "") "1"

	s ver = $lg($g(^DHCCERTAUTH.ConfigCommonD(id)),4)
	q ver
}

/// Desc:       获取签名值和时间戳
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"signID":"6"},"product":"OP","action":"GET_CASIGNDETAIL"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCASignDetail(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SignID = argInJson.params.signID
    s strRes = ##Class(EMR.DOC.BL.CAService).GetCASignDetailJson(SignID,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		CA.DigitalSignature表ID
/// Input: 		signID 签名ID
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CAService).GetCASignDetailJson("10209",.obj)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input:      argInJson  命令参数 {"params":{},"product":"OP","action":"GET_CASIGNDETAIL"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAnySignLocation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product = argInJson.params.product
    s strRes = ##Class(EMR.DOC.BL.CAService).GetAnySignLocationJson(product,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		CA.DigitalSignature表ID
/// Input: 		aProduct 项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CAService).GetCASignDetailJson("10209",.obj)
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
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		CA.DigitalSignature表ID
/// Input: 		aPatPushSignID 推送签名ID
/// 			aUserID 用户ID
/// 			aEntity 返回对象
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CAService).GetPushSignResult("10209","")
ClassMethod GetPushSignResult(aPatPushSignID As %String, aUserID As %String = "", ByRef aEntity As CA.Entity.EDigitalSignPatPush) As %String
{
    s strRes=""
	s entity = ""
	s strRes = ##Class(CA.BL.DigitalSignPatPush).GetPushSignResult(aPatPushSignID,aUserID,.aEntity)
	q strRes
}

/// Desc:       撤销推送签
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		CA.DigitalSignature表ID
/// Input: 		aPatPushSignID 推送签名ID
/// 			aUserID 用户ID
/// 			aEntity 返回对象
/// Output:     成功：1 失败： -1^失败信息 ,0^信息
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CAService).CancelPushSign("","","")
ClassMethod CancelPushSign(aPatPushSignID As %String, aUserID As %String = "", ACancelReason As %String = "") As %String
{
    s strRes=""
	s strRes = ##Class(CA.BL.DigitalSignPatPush).CancelPushSign(aPatPushSignID,aUserID,ACancelReason)
	q strRes
}

/// Desc:       获取验签结果
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input: 		aSignID 推送签名ID
/// 			aDigest 用户ID
/// Output:     正确返回"1^签名人、日期时间"，错误返回"0^错误信息" 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.CAService).CancelPushSign("","","")
ClassMethod GetVerifySignResult(aSignID As %String, aDigest As %String) As %String
{
    s strRes=""
	s strRes = ##class(CA.DigitalSignatureService).GetVerifySignResult(aSignID,aDigest)
	q strRes
}

/// Desc:       获取CA服务是否开启
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input:      argInJson  命令参数 {"params":{"userLocID":"6","userID":"6","ssgroupID":"29"},"product":"OP","action":"GET_CASERVICE"}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPatCAOffReason(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userLocID = argInJson.params.userLocID
	s userID = argInJson.params.userID
	s ssgroupID = argInJson.params.ssgroupID
	s product = argInJson.product
	s strRes = ##Class(EMR.IP.BL.BLCAService).GetPatCAOffReasonJson(userLocID,userID,ssgroupID,product,.argOutData)
    
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

/// Desc:       获取患者不能签名原因
/// Creator:    lifengbo
/// CreateDate: 2023-04-07
/// Table:		
/// Input: 		aUserLocID , aUserID , aSSGroupID ,aProduct 项目标识
/// 			argOutData 1 开启CA，0 未开启
/// Output:     成功：不能签名原因 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.IP.BL.BLCAService).GetPatCAOffReasonJson(191,18881,29,"IP",.obj)
ClassMethod GetPatCAOffReasonJson(aUserLocID As %String, aUserID As %String, aSSGroupID As %String, aProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^获取CA服务信息失败"
	q:(aUserLocID="") strRes

	s model= aProduct_"EMR"
    
    s isHandSignOn = ""
    if (##class(%Dictionary.CompiledMethod).%ExistsId("CA.DigitalSignatureService||GetPatCAServiceStatus") = 1)
	{
		s isHandSignOn = ##Class(CA.DigitalSignatureService).GetPatCAServiceStatus(aUserLocID,aUserID,aSSGroupID,model)
	
	}
	
	if (isHandSignOn = "") 
	{
		s hospID = ##Class(CA.BL.HospitalMgr).GetHospitIDByLocID(aUserLocID)
	    if (hospID = "")
	    {
	    	s hospID = $O(^CT("HOSP",0))   //默认第一个院区
	    }
	    
	    s isHandSignOn=0
	    
	    s version = ..CAVersion()
		if ("2"=version) {
			s HandSign=##Class(CA.DigitalSignatureService).IsHandSignCAON(hospitalID)
			s:("1" = HandSign) isHandSignOn=1
		}else{
			s HandSign=$g(^CF("CA","HandSign"))
			s:("Y" = HandSign) isHandSignOn=1
		}
	
	    s:(isHandSignOn = "0") isHandSignOn = isHandSignOn_"^系统"
	}

	s patCAOffReason =""
	s:($P(isHandSignOn,"^",1) ="0") patCAOffReason =$P(isHandSignOn,"^",2)

	d argOutData.Write(""""_patCAOffReason_"""")

	q "1"
}

/// CreateDate: 2021-09-06
/// Input:      无
/// Output:     1 开启     0 关闭
/// Debug:      w ##Class(EMR.IP.BL.BLCAService).CAHandSign()
ClassMethod CAHandSign(hospitalID = "") As %String
{
	s version = ..CAVersion()
	if ("2"=version) {
		s HandSign=##Class(CA.DigitalSignatureService).IsHandSignCAON(hospitalID)
		q ("1" = HandSign)
	}else{
		s HandSign=$g(^CF("CA","HandSign"))
		q ("Y" = HandSign)
	}
}

/// Desc:		患者签名厂商代码
/// CreateDate: 2021-09-06
/// Input:      无
/// Output:     厂商代码^是否支持PDF^是否需要显示待签二维码
/// 				例如: FAKE^1^0
/// 					  SZXX^1^1
/// Debug:      w ##Class(EMR.IP.BL.BLCAService).CAHandSignVender()
ClassMethod CAHandSignVender(hospitalID = "") As %String
{
	q:(..CAHandSign(hospitalID) = "0") ""
    
    s version = ..CAVersion()
	if ("2"=version) {
        s CAHandSignCompany = ##Class(CA.ConfigCommon).GetValueByName("DefaultHandSignVenderCode",hospitalID) //厂商代码
        s:(CAHandSignCompany = "") CAHandSignCompany = ##Class(CA.ConfigCommon).GetValueByName("DefaultPATPDFVenderCode",hospitalID) //厂商代码
        s IsSupportPDFSign = ##Class(CA.ConfigCommon).GetValueByName("IsSupportPDFSign",hospitalID)           //是否支持PDF
        s IsNeedQrCode = ##Class(CA.ConfigCommon).GetValueByName("IsNeedQrCode",hospitalID)                   //是否需要显示二维码
	}else{
        s CAHandSignCompany = $G(^CF("CA","CAHandSignCompany"))  //厂商代码
        s IsSupportPDFSign = $G(^CF("CA","IsSupportPDFSign"))    //是否支持PDF
        s IsNeedQrCode = $G(^CF("CA","IsNeedQrCode"))            //是否需要显示二维码
	}
    q CAHandSignCompany_"^"_IsSupportPDFSign_"^"_IsNeedQrCode
}

}
