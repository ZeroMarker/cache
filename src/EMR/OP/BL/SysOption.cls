/// 名称:	EMR.OP.BL.SysOption
/// 描述:	门诊病历-系统参数业务逻辑类
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.OP.BL.SysOption Extends EMR.OP.COM.ActionBase [ Not ProcedureBlock ]
{

/// Desc:       根据名称获取系统参数值
/// Creator:    yejian
/// CreateDate: 2021-3-25
/// Input:      AName 名称
/// 			ADefaultValue 默认值
/// OutPut:     返回系统参数值
/// Debug:     	s ret =[{"btnSave":"保存"},{"btnPrint":"打印"}]
/// 			w ##class(EMR.OP.BL.SysOption).GetOptionValueByName("OPEmrButtons","")
ClassMethod GetOptionValueByName(AName As %String, ADefaultValue As %String) As %String
{
	s id=$o(^CF.EMR.DOC.SysOptionI("idxName"," "_$zcvt(AName,"U"),""))
	q:(""=id) ADefaultValue
	s obj=##Class(CF.EMR.DOC.SysOption).%OpenId(id)    
	q $case(obj.OptionValue,$c(0):"",:obj.OptionValue)
}

/// Desc:       获取门诊资源按钮
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"action":"GET_TOOLBUTTONS","product":"OP","params":{"userLocID":"6"}} 
/// 			userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetEmrButtons(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorBtn"
	s strProduct = argInJson.product
	s strUserLocID = argInJson.params.userLocID
    s strRes = ##Class(EMR.OP.BL.SysOption).GetEmrButtonsJson(strProduct,strUserLocID,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
ErrorBtn
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror,2)
}

/// Desc:       获取门诊资源按钮
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		aProductCode:项目标识
/// 			aUserLocID:科室ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.SysOption).LoadGlobalParametersJson(.obj)
ClassMethod GetEmrButtonsJson(aProductCode As %String, aUserLocID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s defValue = [{"id":"btnSave","desc":"保存","icon":"icon-save"},{"id":"btnPrint","desc":"打印","icon":"icon-print"},{"id":"btnPrintOpt","desc":"打印","icon":"icon-print"},{"id":"btnDelete","desc":"删除","icon":"icon-cancel"},{"id":"btnTemplateclassify","desc":"模板","icon":"icon-resort"},{"id":"btnManagePersonal","desc":"管理个人模板","icon":"icon-paper-save"},{"id":"btnSpechars","desc":"符号","icon":"icon-omega"},{"id":"btnExportDocument","desc":"导出","icon":"icon-export"},{"id":"btnPreview","desc":"预览","icon":"icon-eye"},{"id":"btnRevisionVisible","desc":"显示痕迹","icon":"icon-eye"},{"id":"btnLogFlagInfo","desc":"操作日志","icon":"icon-paper-cfg"},{"id":"btnAuthRequest","desc":"权限申请","icon":"icon-stamp"},{"id":"btnAutoApply","desc":"自动授权","icon":"icon-paper-pen"},{"id":"btnImage","desc":"图库","icon":"icon-img"},{"id":"btnEye","desc":"前房深度公式","icon":"icon-eye-deepgrade"},{"id":"btnTooth","desc":"牙位图","icon":"icon-tooth","ctloc":"^115^"}]
	s btnData = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("emrButtons",aProductCode,defValue.%ToJSON())
	q:(btnData="") "-1^获取配置数据失败"
	try
	{
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(btnData)
	}
	catch
	{
		s strRes= "-1^系统参数emrButtons配置的格式有误"
	}
	q:(strRes["-1^") strRes
	s:(aUserLocID'="") aUserLocID ="^"_aUserLocID_"^"
	set iter = objJson.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonItem = item
		s ctLocs = jsonItem.ctloc
		//配置科室、传入科室都不为空,不满足移除
		if (ctLocs '="")&&(aUserLocID'="")
		{
			if (ctLocs '[ aUserLocID)
			{
				d objJson.%Remove(key)
			}
		}
		//移除所有的ctloc标签
		d:(ctLocs '="") jsonItem.%Remove("ctloc")
	}
	
	d objJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取历史就诊引用创建模板服务
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input:      argInJson  命令参数 {"action":"GET_REFCREATETEMPLATEID","product":"OP","params":{"userLocID":"6"}} 
/// 			userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRefCreateTemplateID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorCTem"
	s strProduct = argInJson.product
	s strUserLocID = argInJson.params.userLocID
    s strRes = ##Class(EMR.OP.BL.SysOption).GetRefCreateTemplateIDJson(strProduct,strUserLocID,.argOutData)
	//1 获取成功
	if (strRes="1")
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
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
ErrorCTem
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror,2)
}

/// Desc:       获取历史就诊引用创建模板服务
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF.EMR.OP.SysOption 门急诊系统参数表
/// Input: 		aProductCode:项目标识
/// 			aUserLocID:科室ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.OP.BL.SysOption).LoadGlobalParametersJson(.obj)
ClassMethod GetRefCreateTemplateIDJson(aProductCode As %String, aUserLocID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s defValue = {}
	s refData = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("refCreateTemplateID",aProductCode,"")
	if (refData="") 
	{
		d defValue.%ToJSON(argOutData)
		q strRes
	}
	try
	{
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(refData)
	}
	catch
	{
		s strRes= "-1^系统参数refCreateTemplateID配置的格式有误"
	}
	q:(strRes["-1^") strRes
	s locId = "",locType="",defId="",defType="",retData = ""
	set iter = objJson.%GetIterator()
	while iter.%GetNext(.key , .item ) {
		//1:2:LOCTEMPLATE
        s strItem = item
		s ctLocs = $p(strItem,":",1)
		//配置科室、传入科室都不为空,不满足移除
		if (ctLocs '="")&&(aUserLocID'="")
		{
			if (ctLocs = aUserLocID)
			{
				s locId = $p(strItem,":",2)
				s locType = $p(strItem,":",3)
			}
		}
		elseif(ctLocs="")
		{
			s defId = $p(strItem,":",2)
			s defType = $p(strItem,":",3)
		}
	}
	s retJson = ##class(%DynamicObject).%New()
	s retJson.sourceID=$case(locId,"":defId,:locId)
	s retJson.sourceType=$case(locId,"":defType,:locType)
	s retJson.isLeadframe = "1"
	s retJson.serial = "1"
	d retJson.%ToJSON(argOutData)
	q strRes
}

}
