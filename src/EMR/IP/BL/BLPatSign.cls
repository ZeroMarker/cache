/// 名称:	EMR.IP.BL.BLPatSign
/// 描述:	住院病历 病历导航业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-08
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLPatSign Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存文档
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_HANDSIGNOPTION","params":{"userLocId":"1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetHandSignOption(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userLocId=""
	s userLocId=argInJson.params.userLocId
    s strRes = ##Class(EMR.IP.BL.BLPatSign).GetHandSignOptionJson(userLocId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入版本ID",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取患者签名配置信息
/// Input:	ACTLocID 登录科室ID
/// Return:	患者签名是否开启^签名厂商^是否支持PDF签名
/// Debug:	w ##Class(EMRservice.BL.BLPatSign).GetHandSignOption("100")
ClassMethod GetHandSignOptionJson(argUserLocId As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json={}
	s json.isHandSignOn = "0"
	s json.venderCode= ""
	s json.supportPDF= "0"
	s json.showQR = "0"
	
	
    s hospId = ""
    s:(argUserLocId '= "") hospId = $P($G(^CTLOC(argUserLocId)),"^",22)
	

	s isHandSignOn = ##Class(EMR.IP.BL.BLCAService).CAHandSign()
	
	if (isHandSignOn '= "1") 
	{
		d json.%ToJSON(argOutData)
		q 1
	}
	
	s json.isHandSignOn = isHandSignOn
	
	s vender = ##Class(EMR.IP.BL.BLCAService).CAHandSignVender(hospId)
	
	s json.venderCode = $p(vender, "^", 1)
	s json.supportPDF = $p(vender, "^", 2)
	s json.showQR = $p(vender, "^", 3)
	
	d json.%ToJSON(argOutData)
	
	q 1
}

}
