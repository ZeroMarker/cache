/// 名称:	EMR.DOC.BL.BDMSimpleElements
/// 描述:	通用文档管理模块 Document(Doc) 业务数据模型简单元素业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BDMSimpleElements Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加简单元素
/// Creator:    yejian
/// CreateDate: 2021年4月7日
/// Input:      argArray  	命令参数 {"action":"ADD_BDM_SIMELEMENTS","params":{"parentId":"1210","glossaryItemIds":"","dataAttributes":{"Code":"","Type":"MIString","Name":"字符单元","PlaceHolder":"[字符单元]","Text":"","Value":"","ToolTip":"","DataBindings":"","Display":"true","ReadOnly":"false","AllowNull":"true","FixedStructs":"false","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"false","Italic":"false","TextAlign":"left","VerticalAlign":"middle","TextDecorationLine":"","ValidateMsg":"","Pattern":""}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddBDMSimElements(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMSimpleElements).%New()
	s argDTO.Code = argInJson.params.node.attrs.code
	s argDTO.Name = argInJson.params.node.attrs.name
	s argDTO.Type = argInJson.params.node.type
	s argDTO.BDMCategory =  ..GetIDByKey(argInJson.params.id)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
	s dataAttributes = argInJson.params.node
	s glossary = argInJson.params.node.attrs.glossary
	TSTART
    s strRes = ##Class(EMR.DOC.BL.BDMSimpleElements).AddBDMComElementsJson(argDTO,dataAttributes)
    //失败: -100 添加失败, -200 目录ID不能为空，-201 编码不能为空，-202 元素类型不能为空  -300 未查到目录 , -400 编码已存在
	if (strRes>0)
	{
		 s argOutMessage.success = ..#OK	
	}
	elseif (strRes = "-100")
	{ 
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","元素类型不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-400")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
	}
	
	//添加术语关联
	if (glossary'=""){
		s argInJson.params.id = strRes
		s argInJson.params.glossary = glossary
		s argInJson.params.type = "ET"
		s res= ##Class(EMR.DOC.BL.BDMSimpleElements).AddGlossary(argInJson,argInData,argOutMessage,argOutData)		
	}
	
	if (argOutMessage.errorCode=""){
		TCOMMIT
		q argOutMessage
	}else{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR",argOutMessage.errorMessage,2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// desc: 业务数据模型元素添加术语集关联
ClassMethod AddGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	if (argInJson.params.%GetTypeOf("glossary")'="array"){
		q ..SetOutMessage(argOutMessage,"ERROR","glossary必须为数组","2")
	}
	// 元素ID
	s ID = argInJson.params.id
	s glossary = argInJson.params.glossary
	s type = argInJson.params.type
	// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空 AGlossary 不能为空
	// 						-101 获取术语集关联名失败 -102 获取DocumentID失败 -103 添加术语集关联失败
   	s strRes = ##Class(EMR.DOC.BL.BDMCategory).AddGlossaryJson(ID,glossary,type,"BDM")
   	if (strRes=1){
		q argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空","2")
	}
	elseif(strRes=-200)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空","2")
	}
	elseif(strRes=-202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空","2")
	}
	elseif(strRes=-101)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取术语集关联名失败","2")
	}
	elseif(strRes=-102)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败","2")
	}
	elseif(strRes=-103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","添加术语集关联失败","2")
	}
	elseif(strRes=-301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素数据不存在","2")
	}
	else{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000","2")
	}
	q 1
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新简单元素
/// Creator:    yejian
/// CreateDate: 2021-4-7
/// Input:      argArray  	命令参数 {"action":"UP_BDM_SIMELEMENTS","params":{"id":"2","parentId":"1210","glossaryItemIds":"","node":{"Code":"L0001","Type":"MIString","Name":"字符单元","PlaceHolder":"[字符单元]","Text":"","Value":"","ToolTip":"","DataBindings":"","Display":"true","ReadOnly":"false","AllowNull":"true","FixedStructs":"false","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"false","Italic":"false","TextAlign":"left","VerticalAlign":"middle","TextDecorationLine":"","ValidateMsg":"","Pattern":""}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpBDMSimElements(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMSimpleElements).%New()
	s argDTO.ID =  ..GetIDByKey(argInJson.params.id)
	s argDTO.Code = argInJson.params.node.attrs.code
	s argDTO.Name = argInJson.params.node.attrs.name
	s argDTO.Type = argInJson.params.node.type
	s argDTO.BDMCategory =  ..GetIDByKey(argInJson.params.parentId)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
	s node = argInJson.params.node
	s glossary = argInJson.params.node.attrs.glossary
	TSTART
    s strRes = ##Class(EMR.DOC.BL.BDMSimpleElements).UpBDMSimElementsJson(argDTO,node)
    //失败:-100 添加失败, -200 ID不能为空，-201 编码不能为空，-202 元素类型不能为空  -300 未查到目录 , -400 编码已存在
    if (strRes>0)
    {
	 	s argOutMessage.success = ..#OK   
	}
    elseif (strRes = "-100")
	{
		TROLLBACK 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)
	}
	elseif (strRes = "-200")
	{
		TROLLBACK  
	    q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)
	}
	elseif (strRes = "-201")
	{
		TROLLBACK  
	    q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)
	}
	elseif (strRes = "-202")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","元素类型不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		TROLLBACK  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)
	}
	elseif (strRes = "-400")
	{
		TROLLBACK  
	    q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)
	}
	//更新术语集
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s argInJson.params.glossary = glossary
	s argInJson.params.type = "ET"
	s res = ..UpdateGlossary(argInJson,argInData,argOutMessage,argOutData)
	if (argOutMessage.errorCode=""){
		TCOMMIT
		q argOutMessage
	}else{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR",argOutMessage.errorMessage,2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// 更新元素的关联术语
ClassMethod UpdateGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	if (argInJson.params.%GetTypeOf("glossary")'="array"){
		q ..SetOutMessage(argOutMessage,"ERROR","glossary必须为数组","2")
	}
	
	s ID = argInJson.params.id
	s glossary = argInJson.params.glossary
	s type = argInJson.params.type
	// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空  -202AGlossary 不能为空
	// 						-301 元素对象不存在（ID）
	// 					-101 获取关联术语显示名称失败  -102 获取DocumentID失败 -103 添加术语关联失败 -104 删除术语关联失败
	s strRes = ##Class(EMR.DOC.BL.BDMCategory).UpdateGlossaryJson(ID,glossary,type,"BDM")
	if (strRes=1){
		q argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空","2")
	}
	elseif(strRes=-200)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空","2")
	}
	elseif(strRes=-202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空","2")
	}
	elseif(strRes=-101)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取术语集关联名失败","2")
	}
	elseif(strRes=-102)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败","2")
	}
	elseif(strRes=-103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","添加术语集关联失败","2")
	}
	elseif(strRes=-104)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","删除术语关联失败","2")
	}
	elseif(strRes=-301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素对象不存在（ID）","2")
	}
	q 1
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除简单元素
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"DEL_BDM_SIMELEMENTS","params":{"id":3},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelBDMSimElements(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	//删除术语关联
	s strID =  ..GetIDByKey(argInJson.params.id)
	TSTART
	s strRes = ##class(EMR.DOC.BL.BDMCategory).DeleteGlossaryJson(strID,"ET")
	if (strRes=1){
		s argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空",2)
	}
	elseif(strRes=-200)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空",2)
	}
	elseif(strRes=-202)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空",2)
	}
	elseif(strRes=-102)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败",2)
	}
	elseif(strRes=-104)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","删除术语关联失败",2)
	}
	elseif(strRes=-301)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","元素对象不存在（ID）",2)
	}
    s strRes = ##Class(EMR.DOC.BL.BDMSimpleElements).DelBDMSimElementsJson(strID)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到元素,-301 未查到目录章节
    if (strRes = "-100")
	{
		TROLLBACK 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败","2")
	}
	elseif(strRes = "-200")
	{ 
		TROLLBACK 
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空","2")
	}
	elseif(strRes = "-300")
	{
		TROLLBACK  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到元素","2")
	}
	elseif(strRes = "-301")
	{
		TROLLBACK  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到目录章节","2")
	}
	else
	{
		TCOMMIT
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000","2")
}

/// Desc:       获取简单元素
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMSimpleElements).GetSimpleJsonBySID(1,1,)
ClassMethod GetSimpleJsonByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowSID = ""
	for {
		s rowSID = $o(^CF.EMR.DOC.BDMSimpleElementsI("IdxCategory",aParentId,rowSID))
		q:(rowSID = "")				
		s objSim = ##Class(CF.EMR.DOC.BDMSimpleElements).%OpenId(rowSID)
	    continue:(objSim="")
	    s jsonSim  = ##class(%DynamicObject).%New()
	    s jsonSim.key = rowSID_"||ET"
	    s jsonSim.code = objSim.Code
	    s jsonSim.title = objSim.Name
	    s jsonSim.type = "ET"
	    s jsonSim.MIType = objSim.Type.Code
	    
		s jsonSimeAtrr = ##class(%DynamicAbstractObject).%FromJSON(objSim.DataAttributes)
		s jsonSim.node = jsonSimeAtrr
		d jsonCategory.%Push(jsonSim)	
	}
	q res
}

/// Desc:       添加模板
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argDTO  模板对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空，-202 元素类型不能为空 -101 术语关联失败
/// 						  -300 未查到目录 
/// 						  -400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMSimpleElements).AddBDMSimElementsJson()
ClassMethod AddBDMComElementsJson(argDTO As EMR.DOC.DTO.BDMSimpleElements, dataAttributes As %DynamicAbstractObject) As %String
{
	s strRes ="-100"
	TSTART
	if (argDTO.BDMCategory = "") 
	{
		TROLLBACK
		q "-200"
	}
	if (argDTO.Code = "") 
	{
		TROLLBACK
		q "-201"
	}
	if (argDTO.Type = "")
	{
		TROLLBACK
		q "-202"
	}
	s obj = ##class(CF.EMR.DOC.BDMSimpleElements).%New()
	s intParentID = +(argDTO.BDMCategory)
	//在父目录下添加子目录
	s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(intParentID)
	if (objParent="")
	{
		TROLLBACK
		q "-300"
	}
	s obj.Product = objParent.Product
	/*
	s strBDMETypeID = $o(^CT.EMR.DOC.TemElementTypesI("IdxCode"," "_$zcvt(argDTO.Type,"U"),""))
	if (strBDMETypeID="") 
	{
		TROLLBACK
		q "202"
	}
	s objBDMETypes = ##Class(CT.EMR.DOC.TemElementTypes).%OpenId(strBDMETypeID)*/
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMSimpleElementsI("IdxCateCode",intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	}
	;s obj.type = objBDMETypes
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.BDMCategory = objParent
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.DataAttributes = dataAttributes.%ToJSON()
	s obj.Sequence = +($g(^CF.EMR.DOC.BDMSimpleElementsD))+1
	s objParent.ResChildCount=objParent.ResChildCount+1
	s sc = objParent.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	TCOMMIT
	q obj.%Id()
}

/// Desc:       更新简单元素
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空，-202 元素类型不能为空,
/// 							  -300 未查到目录，-400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMSimpleElements).UpBDMSimElementsJson()
ClassMethod UpBDMSimElementsJson(argDTO As EMR.DOC.DTO.BDMSimpleElements, dataAttributes As %DynamicAbstractObject) As %String
{
	s strRes = "-100"
	TSTART
	if (argDTO.ID="") 
	{
		TROLLBACK
		q "-200"
	}
	if (argDTO.Code = "")
	{
		TROLLBACK
		q "-201"
	}
	if (argDTO.Type = "")
	{
		TROLLBACK
		q "-202"
	}
	s obj = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(argDTO.ID)
	if (obj="") 
	{
		TROLLBACK
		q "-200"
	}
	s intParentID = argDTO.BDMCategory
	if ((intParentID'="")&&(intParentID'=obj.BDMCategory.%Id()))
	{
		s intParentID = +(intParentID)
		s objNewParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(intParentID)
		if (objNewParent="")
		{
			TROLLBACK
			q "-300"
		}
		s objOldParent = obj.BDMCategory
		s objOldParent.ResChildCount = objOldParent.ResChildCount-1
		s scOld = objOldParent.%Save()
		if ('$$$ISOK(scOld))
		{
			 TROLLBACK
			 q -300
		}
		s obj.Product = objNewParent.Product
		s obj.BDMCategory = objNewParent
		s objNewParent.ResChildCount = +(objNewParent.ResChildCount)+1
		s scNew = objNewParent.%Save()
		if ('$$$ISOK(scNew))
		{
			 TROLLBACK
			 q -300
		}
	}else{
		s intParentID = obj.BDMCategory.%Id()	
	}
	
	
	s strBDMETypeID = $o(^CT.EMR.DOC.TemElementTypesI("IdxCode"," "_$zcvt(argDTO.Type,"U"),""))
	if (strBDMETypeID="") 
	{
		TROLLBACK
		q "202"
	}
	s objBDMETypes = ##Class(CT.EMR.DOC.TemElementTypes).%OpenId(strBDMETypeID)
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMSimpleElementsI("IdxCateCode",intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if ((isHas'="")&&(isHas'=argDTO.ID))
	{
		TROLLBACK
		q "-400"
	}

	s obj.Type = objBDMETypes
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.DataAttributes = dataAttributes.%ToJSON()
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       删除简单元素
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到元素,-301 未查到目录章节
/// Debug:      w ##Class(EMR.DOC.BL.BDMSimpleElements).DelBDMSimElementsJson("3")
ClassMethod DelBDMSimElementsJson(argSimID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (argSimID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(argSimID)
	if (obj="")  
	{
		TROLLBACK
		q "-300"
	}
	s intParentID = obj.BDMCategory.%Id()
	s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(intParentID)
	if (objParent="")  
	{
		TROLLBACK
		q "-301"
	}
	s objParent.ResChildCount = objParent.ResChildCount-1
	s sc = objParent.%Save()
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	s sc = ##class(CF.EMR.DOC.BDMSimpleElements).%DeleteId(argSimID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

}
