/// 名称:	EMR.DOC.BL.SSGroup
/// 描述:	安全组信息
/// 编写者：zhangxl
/// 编写日期: 
/// 产品组：电子病历产品组
Class EMR.DOC.BL.SSGroup Extends EMR.DOC.COM.ActionBase
{

/// Desc:       加载安全组
/// Creator:    zhangxl
/// CreateDate: 
/// Input:      argArray  命令参数 {"action":"LOAD_SSGROUPINFO","params":{SSGroupID: "", SSGroupDesc: ""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSSGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error" 
	s SSGroupID = argInJson.params.SSGroupID
	s SSGroupDesc = argInJson.params.SSGroupDesc
    s strRes = ##Class(EMR.DOC.BL.SSGroup).GetSSGroupJson(SSGroupID,SSGroupDesc,.argOutData)
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}elseif(strRes["-1^")
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

/// Desc:       加载安全组信息
/// Creator:    
/// CreateDate:   
/// OutPut:     总数据量
/// Debug:		w ##class(EMR.DOC.BL.SSGroup).GetSSGroupJson("","",.OutData)
ClassMethod GetSSGroupJson(argSSGroupID As %String, argSSGroupDesc As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New() 
	s jsonArr = ##class(%DynamicArray).%New() ;多个json对象

	
	//从数据库中遍历获取信息
	s SSGroupRowId = ""
	;s count = 0
	for {
		s SSGroupRowId = $o(^SSU("SSGRP",SSGroupRowId))
		q:(SSGroupRowId="")	
		
		continue:(argSSGroupID'="")&&(argSSGroupID'=SSGroupRowId)		
		s objSSGroup =$g(^SSU("SSGRP",SSGroupRowId))
		continue:(objSSGroup="")
		s SSGroupDesc=$p(objSSGroup,"^",1)
		continue:(argSSGroupDesc'="")&&(argSSGroupDesc'=SSGroupDesc)
		continue:(SSGroupDesc["停")
		s jsonMenu  = ##class(%DynamicObject).%New() ;单个json对象
		
		s jsonMenu.ID = SSGroupRowId
		s jsonMenu.Name = SSGroupDesc
	
	    ;s count = count + 1
	    
	    
		d jsonArr.%Push(jsonMenu) 
	}
	
	d jsonArr.%ToJSON(argOutData) ;将json对象转化为json格式

	q strRes
	
Error
	q "-1^获取安全组信息失败"
}

}
