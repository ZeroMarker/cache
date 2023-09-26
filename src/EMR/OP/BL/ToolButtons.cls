/// 名称:	EMR.OP.BL.ToolButtons
/// 描述:	门诊病历-工具栏按钮业务逻辑类
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.OP.BL.ToolButtons Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取门诊工具栏按钮
/// Creator:    yejian
/// CreateDate: 2021-7-22
/// Table:		CF_EMR_OP.SysOption
/// Input:      argInJson  命令参数 {"action":"GET_OPEMRTOOLBUTTONS","params":{},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOPEmrToolButtons(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.OP.BL.ToolButtons).GetOPEmrToolButtonsJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取门诊工具栏按钮JSON
/// Creator:    yejian
/// CreateDate: 2021-3-25
/// Input:      
/// OutPut:     成功 1 失败 -1
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ToolButtons).GetOPEmrToolButtonsJson(.argOutData)
ClassMethod GetOPEmrToolButtonsJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s jsonArr = ##class(%DynamicArray).%New()
	s strRes = ""
	s ret=[{"btnSave":"保存"},{"btnPrint":"打印"},{"btnDelete":"删除"},{"btnTemplateclassify":"模板"},{"btnSpechars":"符号"},{"btnExportDocument":"导出"},{"btnPreview":"预览"},{"btnRevisionVisible":"显示痕迹"},{"btnLogFlagInfo":"操作日志"},{"btnAuthRequest":"权限申请"},{"btnTooth":"牙位图"},{"btnManagePersonal":"管理个人模板"}]
	s ret=##Class(EMR.OP.BL.SysOption).GetOptionValueByName("OPEmrButtons",ret)
	
	s jsonArr = ##class(%DynamicAbstractObject).%FromJSON(ret)
	
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
Error
	q "-1"
}

}
