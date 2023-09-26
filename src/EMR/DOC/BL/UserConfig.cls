/// 名称:	EMR.DOC.BL.UserConfig
/// 描述:	用户个性配置业务逻辑类
/// 编写者:	yejian
/// 编写日期: 	2022-8-25
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.UserConfig Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取用户配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"SET_USER_CONFIG","params":{"userID":"6","configType":"DISPLAYTYPE","userLocID":"6","configData":"CARD"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetUserConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.UserConfig).%New()
	s objItem.UserID = argInJson.params.userID
	s objItem.Type = argInJson.params.configType
	s objItem.LocID = argInJson.params.userLocID
	s objItem.Config = argInJson.params.configData
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.UserConfig).GetUserConfigJson(objItem,.argOutData)
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

/// Desc:       设置用户配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"SET_USER_CONFIG","params":{"userID":"6","configType":"DISPLAYTYPE","userLocID":"6","configData":"CARD"}}
/// 			userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SetUserConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.UserConfig).%New()
	s objItem.UserID = argInJson.params.userID
	s objItem.Type = argInJson.params.configType
	s objItem.LocID = argInJson.params.userLocID
	s objItem.Config = argInJson.params.configData
	s objItem.Product = argInJson.product
    s strRes = ##Class(EMR.DOC.BL.UserConfig).SetUserConfigJson(objItem,.argOutData)
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

/// Desc:       获取用户配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.UserConfig).GetUserDataJson("10209",.obj)
ClassMethod GetUserConfigJson(aUserConfig As EMR.DOC.DTO.UserConfig, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aUserConfig="")||(aUserConfig.UserID="")||(aUserConfig.LocID="")||(aUserConfig.Type="") "-1^用户ID、科室ID、配置类型不能为空"
   
	
	s flag = ##Class(EMR.DOC.BL.UserConfig).GetCloseConfig(aUserConfig.Type,aUserConfig.Product)
	q:(flag = "1") strRes
	
	s rowId = $o(^CF.EMR.DOC.UserConfigI("UserLocTypeIndex"," "_aUserConfig.UserID," "_aUserConfig.LocID," "_$zcvt(aUserConfig.Type,"U"),""))
	q:(rowId = "") strRes
	s objConfig = ##Class(CF.EMR.DOC.UserConfig).%OpenId(rowId)
	q:(objConfig = "") strRes
	s strConfig = """"_objConfig.Config_""""
	d argOutData.Write(strConfig)
	q strRes
}

/// Desc:       设置用户配置信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.UserConfig).GetUserDataJson("10209",.obj)
ClassMethod SetUserConfigJson(aUserConfig As EMR.DOC.DTO.UserConfig, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^更新失败"
	q:(aUserConfig="")||(aUserConfig.UserID="")||(aUserConfig.LocID="")||(aUserConfig.Type="") "-1^用户ID、科室ID、配置类型不能为空"
	s rowId = $o(^CF.EMR.DOC.UserConfigI("UserLocTypeIndex"," "_aUserConfig.UserID," "_aUserConfig.LocID," "_$zcvt(aUserConfig.Type,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(CF.EMR.DOC.UserConfig).%New()
		s obj.UserID = aUserConfig.UserID
		s obj.LocID = aUserConfig.LocID
		s obj.Type = aUserConfig.Type
	}
	else
	{
		s obj = ##Class(CF.EMR.DOC.UserConfig).%OpenId(rowId)
	}
	s id=$o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(aUserConfig.Product,"U"),""))
	s objProduct=##class(CT.EMR.DOC.Products).%OpenId(id)
	s obj.Product=objProduct
	s obj.Config = aUserConfig.Config
	s sc = obj.%Save()
	if ($$$ISOK(sc)) 
	{
		s strRes = 1 
		d argOutData.Write(obj.%Id())
	}
	q strRes
}

/// Desc:       判断用户是否屏蔽某项用户个性化配置
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input: 		AType 配置类型
/// 			AProduct 项目标识编码
/// Output:     0 未屏蔽，1屏蔽
/// debug:  	w ##Class(EMR.DOC.BL.UserConfig).GetCloseConfig("Revision","OP")	
ClassMethod GetCloseConfig(AType As %String, AProduct As %String) As %String
{
	s flag = "0"
	s closeUserConfigType = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("closeUserConfigType",AProduct,"")
	q:(closeUserConfigType = "") flag

	s count=$l(closeUserConfigType, "^")
	for i=1:1:count 
	{
		s closeType = $p(closeUserConfigType, "^", i)
		q:(closeType = "")
		if ($zcvt(closeType,"U") = $zcvt(AType,"U"))
		{
			s flag = "1"
			q
		}
	}
	q flag
}

/// Desc:       获取用户配置信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.UserConfig).GetUserConfigValue("10209",.obj)
ClassMethod GetUserConfigValue(argUserID As %String, argUserLocID As %String, argType As %String, argProduct As %String) As %String
{
	s strRes = ""
	
	s flag = ##Class(EMR.DOC.BL.UserConfig).GetCloseConfig(argType,argProduct)
	q:(flag = "1") strRes
	
	s rowId = $o(^CF.EMR.DOC.UserConfigI("UserLocTypeIndex"," "_argUserID," "_argUserLocID," "_$zcvt(argType,"U"),""))
	q:(rowId = "") strRes
	s objConfig = ##Class(CF.EMR.DOC.UserConfig).%OpenId(rowId)
	q:(objConfig = "") strRes
	
	s cfgValue = objConfig.Config
	q cfgValue
}

}
