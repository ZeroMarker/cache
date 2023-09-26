Class EMR.DOC.BL.HFFormatPermission Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取版式管理功能权限数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  	命令参数 {"params":{"action":"GET_HFFORMAT_PERMISSION","args":{"ID":"1"}},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod DelTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = argInJson.params.args.ID
	
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).DelTemplateVersionJson(strID)
    d argOutData.Write(strRes)
	if (strRes = "-1")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR")
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write("-1")
	q ..SetOutMessage(argOutMessage,"ERROR")
}

}
