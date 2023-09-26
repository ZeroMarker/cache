/// 名称:	EMR.DOC.BL.TextKB
/// 描述:	专科知识库
/// 编写者：zhangxl
/// 编写日期: 2021-7-29
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TextKB Extends EMR.DOC.COM.ActionBase
{

/// Desc:       新增目录
/// Creator:    zhangxl
/// CreateDate: 2021-7-29
/// Input:      argArray  	命令参数 {"action":"ADD_TEXTKB_CATALOG","params":{"id":"0","Name":"新增目录"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddTextKBCatalog(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TextKBCategory).%New()
	s argDTO.ParentID = argInJson.params.id
    s argDTO.Name = argInJson.params.Name
    s strRes = ##Class(EMR.DOC.BL.TextKB).AddTextKBCatalogJson(argDTO)
    //失败:-100 添加失败, -200 目录ID不能为空
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内容不能为空",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加目录
/// Creator:    zhangxl
/// CreateDate: 2021-7-29
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      ##Class(EMR.DOC.BL.TextKBCategory).AddTextKBCatalogJson()
ClassMethod AddTextKBCatalogJson(argDTO As EMR.DOC.DTO.TextKBCategory) As %String
{
	s strRes ="-100"
	q:(argDTO.ParentID="") "-200"
	q:(argDTO.Name="") "-300"
    s obj = ##Class(CF.EMR.DOC.TextKBCategory).%New()
    s obj.Sequence = $case($d(^CF.EMR.DOC.TextKBCategoryD)>0,0:1,:^CF.EMR.DOC.TextKBCategoryD+1)
	s obj.ParentID = argDTO.ParentID
	s obj.Name = argDTO.Name
	s obj.Type = "folder"
	s obj.IsValid = "Y"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       更新目录
/// Creator:    zhangxl
/// CreateDate: 2021-8-22
/// Input:      argArray  命令参数 {"params":{"action":"UPDATE_TEXTKB_CATALOG","args":{"id":"2","Name":"入院记录"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateTextKB(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TextKBCategory).%New()
	s argDTO.ID = argInJson.params.id
    s argDTO.Name = argInJson.params.Name
    s strRes = ##Class(EMR.DOC.BL.TextKB).UpdateTextKBJson(argDTO)
    //失败:-100 添加失败, -200 目录ID不能为空
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新目录/节点
/// Creator:    zhangxl
/// CreateDate: 2021-8-6
/// Input:      argDTO  目录对象
/// Output:     成功： 1   失败：-200  必填项校验
/// 							 -301 版式记录不存在 -302 文档记录不存在
/// 							 -101 操作数据记录出错
ClassMethod UpdateTextKBJson(argDTO As EMR.DOC.DTO.TextKBCategory) As %String
{
	s strRes = "-101"
	q:((argDTO.ID="")||(argDTO.Name="")) "-200"
	TSTART
	s objTextKB = ##class(CF.EMR.DOC.TextKBCategory).%OpenId(argDTO.ID)
	if (objTextKB="")
	{
		TROLLBACK
		q "-301"
	}
 	
	s objTextKB.Name = argDTO.Name
 	
	if '(objTextKB.%Save())
 	{
	 	TROLLBACK
		q strRes
	} 
	TCOMMIT
	s strRes = "1"
	q strRes
}

/// Desc:       新增节点
/// Creator:    zhangxl
/// CreateDate: 2021-7-29
/// Input:      argArray  	命令参数 {"action":"ADD_TEXTKB_ITEM","params":{"id":"0","Name":"新增目录"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddTextKBItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.TextKBCategory).%New()
	s argDTO.ParentID = argInJson.params.id
	s argDTO.Name = argInJson.params.Name
    s strRes = ##Class(EMR.DOC.BL.TextKB).AddTextKBItemJson(argDTO)
    //失败:-100 添加失败, -200 目录ID不能为空
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内容不能为空",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加节点
/// Creator:    zhangxl
/// CreateDate: 2021-7-29
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      ##Class(EMR.DOC.BL.TextKBCategory)AddTextKBItemJson()
ClassMethod AddTextKBItemJson(argDTO As EMR.DOC.DTO.TextKBCategory) As %String
{
	s strRes ="-100"
	q:(argDTO.ParentID="") "-200"
	q:(argDTO.Name="") "-300"
    s obj = ##Class(CF.EMR.DOC.TextKBCategory).%New()
    s obj.Sequence = $case($d(^CF.EMR.DOC.TextKBCategoryD)>0,0:1,:^CF.EMR.DOC.TextKBCategoryD+1)
	s obj.ParentID = argDTO.ParentID
	s obj.Name = argDTO.Name
	s obj.Type = "leaf"
	s obj.IsValid = "Y"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       删除目录、节点
/// Creator:    zhangxl
/// CreateDate: 2021-7-29
/// Input:      argArray  	命令参数 {"action":"DEL_TEXTKB","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelTextKB(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.TextKB).DelTextKBJson(strID)
    d argOutData.Write(strRes)
    //失败:-100 删除失败, -200 ID不能为空
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败","2")
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到术语目录","2")
	}
	elseif(strRes = "-500")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","包含子节点不能删除","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除目录、节点
/// Creator:    zhangxl
/// CreateDate: 2021-7-30
/// Input:      argID  ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空， -300 未查到术语目录,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.TextKB).DelTextKBJson("1")
ClassMethod DelTextKBJson(strID As %String) As %String
{
	s strRes = "-100"
	if (strID="")
	{
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.TextKBCategory).%OpenId(strID)
	if (obj="")  
	{
		q "-300"
	}
	
	s strNodesCount = 0
	&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.TextKBCategory c WHERE c.ParentID = :strID and c.IsValid ="Y")
	if (strNodesCount>0)
	{
		q "-500"
	}
	;s sc = ##class(CF.EMR.DOC.TextKBCategory).%DeleteId(strID)

	s obj.IsValid = "N"	
	s sc = obj.%Save()
    s:($$$ISOK(sc)) strRes = "1"
    q strRes
}

}
