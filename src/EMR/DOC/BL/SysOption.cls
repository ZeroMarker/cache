/// 名称:	EMR.DOC.BL.SysOption
/// 描述:	通用文档管理模块 Document(Doc) 系统参数业务类
/// 编写者：yejian
/// 编写日期: 2021-2-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.SysOption Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取系统参数
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_SYSOPTION","params":{"name":"HospitalName","defaultValue":"DHCC"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSysOption(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s strName = argInJson.params.name
	s strDValue = argInJson.params.defaultValue
    s strRes = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName(strName,strProduct,strDValue)
    d:(strRes'="") argOutData.Write(strRes)
	//1 获取成功
	if (strRes'="")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取多个系统参数
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_SYSOPTION","params":[{"name":"HospitalName","defaultValue":"DHCC"},{"name":"NameSpaceHIS","defaultValue":""},{"name":"NameSpaceLIS","defaultValue":""}]}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSysOptions(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strProduct = argInJson.product
	s arrSysDatas = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.SysOption).GetSysOptionsJson(arrSysDatas,strProduct,.argOutData)
    
	//1 获取成功
	if (strRes'="")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取系统参数值(项目标识为空，取第一个系统参数值)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      aName 参数名称
/// 			aProductCode 项目标识
/// 			aDefaultValue 默认值
/// OutPut:     系统参数值（为空返回默认值）
/// debug:	w ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName","OEP")
ClassMethod GetOptionValueByName(aName As %String, aProductCode As %String = "", aDefaultValue As %String = "") As %String
{
	q:(aName="") aDefaultValue
	if (aProductCode'="")
	{
		s objProduct = ##class(EMR.DOC.BL.Products).GetProductByCode(aProductCode)
		q:(objProduct="") aDefaultValue
		s pid = objProduct.%Id()
		s id=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",pid," "_$zcvt(aName,"U"),""))
		q:(""=id) aDefaultValue
	}
	else
	{
		s id=$o(^CF.EMR.DOC.SysOptionI("idxName"," "_$zcvt(aName,"U"),""))
		q:(""=id) aDefaultValue
	}
	s obj=##Class(CF.EMR.DOC.SysOption).%OpenId(id)
	q:(obj="") aDefaultValue
	q:(obj.OptionValue="") aDefaultValue
	q obj.OptionValue
}

/// Desc:       获取多个系统参数
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		aProductCode:项目标识
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.SysOption).GetSysOptionsJson(.obj)
ClassMethod GetSysOptionsJson(arrSysDatas As %DynamicAbstractObject, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	;n (strRes,arrSysDatas,jsonItem,argOutData,aProductCode)
	q:(aProductCode="") "-1^项目标识不能为空"
    s jsonItem  = ##class(%DynamicObject).%New()
   	s strkey = ""
	set iter = arrSysDatas.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s sysJson = item
        s strName = sysJson.name
        s strDValue = sysJson.defaultValue
		s strData = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName(strName,aProductCode,strDValue)
		try
		{
			if (strData'="")
			{
				s objJson = ##class(%DynamicAbstractObject).%FromJSON(strData)
				s:(objJson'="") strData = objJson
				d jsonItem.%Set(strName,strData)
			}
			else
			{
				d jsonItem.%Set(strName,strData)
			}
		
		}
		catch
		{
			d jsonItem.%Set(strName,strData)
		}
		
	}
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

/// Creator:	huhao
/// CreatDate:  2021-11-29
/// Desc:		获取系统参数列表
/// Input：		{"action":"GET_SYSOPTIONS","product":"GlobalEMR","params":{"Name":"name","Product":"op","Description":"ss","userCode":"YS01"}}
/// 					Name 参数名称
/// 				Description 参数描述
/// 				Product 产品标识
/// 				userCode 用户代码
/// Output：	-1 角色信息不存在，1 成功，	
/// Debug：		
ClassMethod GetSystemOptionList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ##class(EMR.DOC.BL.SysOption).GetSysList(argInJson.params,.argOutData)	
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","角色信息不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查询到内容",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// 带参数查询
ClassMethod GetSysList(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJson=##class(%DynamicArray).%New()
	s rowid="",strRes=""
	;s roleId=$o(^CF.EMR.DOC.RBACUserI("IdxUserRoles"," "_$zcvt(indata.userCode,"U"),""))
	s roleId =##Class(EMR.DOC.BL.RBACRole).GetRoleByCode(indata.safeGroupId)
	q:(roleId="") "-1"
	
	s productarray=##class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(indata.safeGroupId)
	q:(productarray.%Size()=0)
	set iter = productarray.%GetIterator()
	while iter.%GetNext(.key , .objProduct ) 
	{
		s productId=objProduct.%Id()
		s name=""
		for
		{
			s name=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",productId,name))
			q:name=""
			s typeID=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",productId,name,""))
			q:typeID=""
			s obj=##class(CF.EMR.DOC.SysOption).%OpenId(typeID)
			s resObj=##class(%DynamicObject).%New()
			continue:(obj.IsVisible="0")
			continue:(obj.Name[indata.Name)=0
			continue:(obj.Description[indata.Description)=0
			continue:(obj.Product.ProductCode[objProduct.ProductCode)=0
			continue:(obj.Product.ProductCode[indata.Product)=0
			s resObj.key=typeID
			s resObj.Name=obj.Name
			s resObj.Description=obj.Description
			s resObj.OptionValue=obj.OptionValue
			s resObj.IsEditer=obj.IsEditer
			s resObj.IsVisible=obj.IsVisible
			s resObj.Product=obj.Product.ProductCode
			d resJson.%Push(resObj)
			s strRes=1
		}
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Creator:	huhao
/// CreatDate:  2021-11-29
/// Desc:		新建系统参数
/// Input：		{"action":"ADD_SYSOPTIONS","product":"GlobalEMR","params":{"IsEditer":"N","Name":"N","Description":"N","IsVisible":"N","OptionValue":"N"}}
/// 					Name 参数名称
/// 				Description 参数描述
/// 				IsEditer 插件是否加载
/// 				Product 产品线标识
/// 				OptionValue 参数值
/// Return：	失败：0，成功：1
ClassMethod AddSysOptionValue(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##class(EMR.DOC.BL.SysOption).AddSysOption(argInJson.params,.argOutData)
	if (strRes = "1")
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
	    q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod AddSysOption(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:indata.Name="" "-1^请输入姓名"
	q:indata.Product="" "-1^请选择产品标识"
	s typeID=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_indata.Product,""))
	s rowId=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",typeID," "_$zcvt(indata.Name,"U"),""))
	s obj=##class(CF.EMR.DOC.SysOption).%OpenId(rowId)
	if (obj'="")
	{
		if (obj.IsVisible=0)
		{
			s obj.Description=indata.Description
			S obj.IsEditer=indata.IsEditer
			S obj.OptionValue=indata.OptionValue
			S obj.IsVisible="1"
			d ##class(EMR.DOC.BL.SysOption).AddLog(indata)
			s s=obj.%Save()
			q s	
		}
		else
		{
			q "-1^存在相同类型系统参数"
		}
	}
	else
	{
		s resobj=##class(CF.EMR.DOC.SysOption).%New()
		s resobj.Name=indata.Name
		s resobj.Description=indata.Description
		S resobj.IsEditer=indata.IsEditer
		S resobj.OptionValue=indata.OptionValue
		s id=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(indata.Product,"U"),""))
		s ProductObj=##class(CT.EMR.DOC.Products).%OpenId(id)
		s resobj.Product=ProductObj
		S resobj.IsVisible="1"
		d ##class(EMR.DOC.BL.SysOption).AddLog(indata)
		s s=resobj.%Save()
		q s	
	}
}

// 增加系统参数操作日志方法

ClassMethod AddLog(injson As %DynamicAbstractObject) As %String
{
	s obj=##class(CF.EMR.DOC.SysOptionLog).%New()
	S obj.Action="ADD"
	s obj.NewDescription=injson.Description
	s obj.NewIsEditer=injson.IsEditer
	s obj.NewName=injson.Name
	s obj.NewOptionValue=injson.OptionValue
	s obj.NewProduct=injson.Product
	s obj.OperateDate=$P($h,",",1)
	s obj.OperateTime=$P($h,",",2)
	S obj.OperateMachineIP=injson.IP
	s obj.OperateUserName=injson.userCode
	d obj.%Save()
}

/// Creator:	huhao
/// CreatDate:  2021-11-29
/// Desc:		更新系统参数
/// Input：		{"action":"UPDATE_SYSOPTIONS","product":"GlobalEMR","params":{"oldName":"fixedElementColor","newName":"fixedElementColor","oldProduct":"OP","newProduct":"OP","Description":"插件05|固定元素文字颜色","IsEditer":"Y","OptionValue":"","userCode":"YS01","IP":"localhost"}}
/// 					olName 更新之前的参数名称
/// 				newName 更新之后的参数名称
/// 				Description 参数描述
/// 				newProduct 更新之后的产品线标识
/// 				IsEditer 插件是否加载
/// 				oldProduct 更新之前产品线标识
/// 				OptionValue 参数值
/// Return：	失败：0，成功：1
ClassMethod UpdateSysOptionValue(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strParams = argInJson.params
    s strRes = ##class(EMR.DOC.BL.SysOption).UpdateSysOption(strParams,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","该系统参数已存在，请重新修改",2)
	}
	else
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod UpdateSysOption(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s strRes=""
	s oldId=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(indata.oldProduct,"U"),""))
	s oldSysId=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",oldId," "_$zcvt(indata.oldName,"U"),""))
	
	s newId=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(indata.newProduct,"U"),""))
	s newSysId=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",newId," "_$zcvt(indata.newName,"U"),""))
	s obj=##class(CF.EMR.DOC.SysOption).%OpenId(newSysId)
	if ((obj'="")&&(oldSysId'=newSysId))
	{
		s strRes="101"
		q strRes
	}
	else
	{
		d ##class(EMR.DOC.BL.SysOption).UpdateLog(oldSysId,indata)
		s resObj=##class(CF.EMR.DOC.SysOption).%OpenId(oldSysId)
		s resObj.Name=indata.newName
		s resObj.Description=indata.Description
		s resObj.IsEditer=indata.IsEditer
		s resObj.OptionValue=indata.OptionValue
		s proObj=##class(CT.EMR.DOC.Products).%OpenId(newId)
		s resObj.Product=proObj
		s strRes="1"
		d resObj.%Save()
		q strRes
	}
}

// 更新系统参数操作日志方法

ClassMethod UpdateLog(id As %String, injson As %DynamicAbstractObject) As %String
{
	s obj=##class(CF.EMR.DOC.SysOptionLog).%New()
	s oldObj=##class(CF.EMR.DOC.SysOption).%OpenId(id)
	s obj.Action="UPDATE"
	s obj.OldDescription=oldObj.Description
	s obj.OldIsEditer=oldObj.IsEditer
	s obj.OldName=oldObj.Name
	s obj.OldOptionValue=oldObj.OptionValue
	s obj.OldProduct=oldObj.Product.ProductCode
	s obj.NewDescription=injson.Description
	s obj.NewIsEditer=injson.IsEditer
	s obj.NewName=injson.newName
	s obj.NewOptionValue=injson.OptionValue
	s obj.NewProduct=injson.newProduct
	s obj.OperateDate=$P($h,",",1)
	s obj.OperateTime=$P($h,",",2)
	S obj.OperateMachineIP=injson.IP
	s obj.OperateUserName=injson.userCode
	d obj.%Save()
}

/// Creator:	huhao
/// CreatDate:  2021/11/30
/// Desc:		删除系统参数
/// Input：		{"action":"DELETE_SYSOPTIONS","product":"GlobalEMR","params":{"Name":"fixedElementColor","Product":"OP","userCode":"YS01","IP":"localhost"}}
/// 					Name 参数名称
/// 				Product 产品线标识
/// Return：	失败：0，成功：1
ClassMethod DeleteSysOptionValue(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##class(EMR.DOC.BL.SysOption).DeleteSysOption(argInJson.params,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod DeleteSysOption(indata As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream)
{
	s productI=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(indata.Product,"U"),""))
	s rowId=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",productI," "_$zcvt(indata.Name,"U"),""))
	s obj=##class(CF.EMR.DOC.SysOption).%OpenId(rowId)
	s obj.IsVisible="0"
	d ..DelLog(rowId,indata)
	s s=obj.%Save()
	q s
}

ClassMethod DelLog(id As %String, indata As %DynamicAbstractObject) As %String
{
	s obj=##class(CF.EMR.DOC.SysOption).%OpenId(id)
	s logObj=##class(CF.EMR.DOC.SysOptionLog).%New()
	s logObj.Action="DELETE"
	s logObj.OldDescription=obj.Description
	s logObj.OldIsEditer=obj.IsEditer
	s logObj.OldName=obj.Name
	s logObj.OldOptionValue=obj.OptionValue
	s logObj.OldProduct=obj.Product.ProductCode
	s logObj.OperateDate=$P($h,",",1)
	s logObj.OperateTime=$P($h,",",2)
	s logObj.OperateMachineIP=indata.IP
	s logObj.OperateUserName=indata.userCode
	d logObj.%Save()
}

/// 名称:		返回默认字体参数
/// 描述:		
/// 编写者:		huhao
/// 编写日期: 	
/// 产品组：	电子病历产品组
ClassMethod ReturnDefaultFontSet(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##class(EMR.DOC.BL.SysOption).outputFontSet(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod outputFontSet(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s obj=##class(%DynamicObject).%New()
	s rowId=""
	s rowId=$o(^CF.EMR.DOC.SysOptionI("idxName"," "_$zcvt("SetDefaultFontStyle","U"),rowId))
	s obj.content=##class(CF.EMR.DOC.SysOption).%OpenId(rowId).OptionValue
	d obj.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取编辑器全局系统参数
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"action":"LOAD_GLOBAL_PARAMETERS","product":"OP","params":{}}  [EDITOR 插件参数，ALL 所有系统参数]
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadGlobalParameters(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorPar"
	s strProduct = argInJson.product
	s strEpisodeID = argInJson.params.episodeID
	s strUserLocID = argInJson.params.userLocID
	s strUserID = argInJson.params.userID
	s strIP = argInJson.params.ipAddress
	s LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.SysOption).LoadGlobalParametersJson(strProduct,strUserID,strIP,strEpisodeID,strUserLocID,LangID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
ErrorPar
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror,2)
}

/// Desc:       获取编辑器全局系统参数
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		aProductCode:项目标识
/// 			aUserID:用户ID
/// 			aIP:IP地址
/// 			aEpisodeID:就诊号
/// 			aUserLocID:科室ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.SysOption).LoadGlobalParametersJson(.obj)
ClassMethod LoadGlobalParametersJson(aProductCode As %String, aUserID As %String, aIP As %String, aEpisodeID As %String, aUserLocID As %String, aLangID As %String = "20", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aProductCode="") "-1^项目标识不能为空"
	q:(aUserID="") "-1^用户ID不能为空"
	q:(aEpisodeID="") "-1^就诊号不能为空"
    s jsonItem  = ##class(%DynamicObject).%New()
    s objProduct = ##class(EMR.DOC.BL.Products).GetProductByCode(aProductCode)
	q:(objProduct="") "-1^传入项目标识有误"
	s objUser=##class(User.SSUser).%OpenId(aUserID,0)
	q:(objUser="") "-1^获取用户失败"
    s userName = objUser.SSUSRName
    s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(aUserID,aEpisodeID,aUserLocID,aProductCode,aLangID)
    s signLevel = $p(userLevel,"^",1)
    q:(signLevel="") "-1^请先维护用户级别!"
	s levelName = $p(userLevel,"^",2)
	s roleLevel = $p(userLevel,"^",3)
	
	s pid = objProduct.%Id()
   	s strkey = ""
	for
	{
		s strkey = $o(^CF.EMR.DOC.SysOptionI("idxTypeName",pid,strkey))
		q:(strkey = "")	
		s id = ""
		s id=$o(^CF.EMR.DOC.SysOptionI("idxTypeName",pid,strkey,id))
		continue:(""=id)
		s obj=##Class(CF.EMR.DOC.SysOption).%OpenId(id)
		continue:((obj.IsVisible="0")||(obj.IsEditer="N"))
		try
		{
			if (obj.OptionValue'="")
			{
				//水印系统参数处理
				if (obj.Name = "water")
				{
					s objJson = ##class(%DynamicAbstractObject).%FromJSON(obj.OptionValue)
					s textData = ""
					s iter = objJson.text.%GetIterator()
					while iter.%GetNext(.key , .value ) 
					{
						continue:(value="")
						if (value="hospitalName")
						{
							s strHosName = ##class(EMR.DOC.HISInterface.PatientInfoAssist).HospitalName(aEpisodeID)
							s textData=$case(textData,"":strHosName,:textData_" "_strHosName)
						}
						elseif (value = "userName")
						{
							s textData=$case(textData,"":userName,:textData_" "_userName)
						}
						elseif (value = "ip")
						{
							s textData=$case(textData,"":aIP,:textData_" "_aIP)
						}
						elseif (value = "dateTime")
						{
							s dateTime =$zd($p($h,",",1),3)_" "_$zt($p($h,",",2),1)
							s textData=$case(textData,"":dateTime,:textData_" "_dateTime)
						}
					}
					s objJson.text = textData
					d jsonItem.%Set(obj.Name,objJson)
				}
				else
				{
					s objJson = ##class(%DynamicAbstractObject).%FromJSON(obj.OptionValue)
					d jsonItem.%Set(obj.Name,objJson)
				}
			}
			else
			{
				d jsonItem.%Set(obj.Name,obj.OptionValue)
			}
		}
		catch
		{
			d jsonItem.%Set(obj.Name,obj.OptionValue)
		}		
	}
	
	
	
	s jsonUser = ##class(%DynamicObject).%New()
	s jsonUser.id = aUserID
	s jsonUser.ip = aIP
	s jsonUser.name = userName
	s jsonUser.userCode = objUser.SSUSRInitials
	s jsonUser.roleLevel = roleLevel
	s jsonUser.signLevel = signLevel
	s jsonUser.levelName = levelName
	s jsonItem.user=jsonUser
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

}
