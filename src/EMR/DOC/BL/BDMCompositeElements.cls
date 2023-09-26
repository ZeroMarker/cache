/// 名称:	EMR.DOC.BL.BDMCompositeElements
/// 描述:	通用文档管理模块 Document(Doc) 业务数据模型复合元素业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BDMCompositeElements Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加复合元素
/// Creator:    yejian
/// CreateDate: 2021年4月7日
/// Input:      argArray  	命令参数 {"action":"ADD_BDM_COMELEMENTS","params":{"parentId":"1210","code":"MCC0001","type":"MIConcept","name":"体温","description":"体温","allowInput":"True","fixedStructs":"False","fontName":"","fontSize":"","bold":"False","italic":"False","textColor":"","glossaryItemIds":"","subItems":[{"Code":"N0001","Type":"MINumber","Name":"数字单元","PlaceHolder":"[体温]","Text":"","Value":"","ToolTip":"","DataBindings":"","DecimalPlaces":"","Increment":"","Maximum":"","Minmum":"","Display":"true","ReadOnly":"false","AllowNull":"true","FixedStructs":"false","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"false","Italic":"false","TextAlign":"left","VerticalAlign":"middle","TextDecorationLine":"","ValidateMsg":"","Pattern":""},{"Code":"L0001","Type":"MIString","Name":"字符单元","PlaceHolder":"[℃]","Text":"","Value":"","ToolTip":"","DataBindings":"","Display":"true","ReadOnly":"false","AllowNull":"true","FixedStructs":"false","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"false","Italic":"false","TextAlign":"left","VerticalAlign":"middle","TextDecorationLine":"","ValidateMsg":"","Pattern":""},{"Type":"Text","ReadOnly":"False","DisplayName":"天","TextPosition":"normal"//常规normal,上标superscript,下标subscript}]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddBDMComElements(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCompositeElements).%New()
	s argDTO.Code = argInJson.params.node.attrs.code
	s argDTO.Name = argInJson.params.node.attrs.name
	s argDTO.Type = argInJson.params.node.type
	s argDTO.BDMCategory =  ..GetIDByKey(argInJson.params.id)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
	s dataAttributes = argInJson.params.node
	s glossary = argInJson.params.node.attrs.glossary
	TSTART
    s strRes = ##Class(EMR.DOC.BL.BDMCompositeElements).AddBDMComElementsJson(argDTO,dataAttributes)
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
		s argInJson.params.type = "CT"
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
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新复合元素
/// Creator:    yejian
/// CreateDate: 2021-4-7
/// Input:      argArray  	命令参数 {"action":"UP_BDM_COMELEMENTS","params":{"id":"2","parentId":"1210","code":"MCC0001","type":"MIConcept","name":"体温","description":"体温","allowInput":"True","fixedStructs":"False","fontName":"","fontSize":"","bold":"False","italic":"False","textColor":"","glossaryItemIds":"","subItems":[{"Code":"N0001","Type":"MINumber","Name":"数字单元","PlaceHolder":"[体温]","Text":"","Value":"","ToolTip":"","DataBindings":"","DecimalPlaces":"","Increment":"","Maximum":"","Minmum":"","Display":"true","ReadOnly":"false","AllowNull":"true","FixedStructs":"false","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"false","Italic":"false","TextAlign":"left","VerticalAlign":"middle","TextDecorationLine":"","ValidateMsg":"","Pattern":""},{"Code":"L0001","Type":"MIString","Name":"字符单元","PlaceHolder":"[℃]","Text":"","Value":"","ToolTip":"","DataBindings":"","Display":"true","ReadOnly":"false","AllowNull":"true","FixedStructs":"false","MaxLength":"","TableIndex":"","PasswordChar":"","BackgroundColor":"","Cursors":"","FontFamily":"","Color":"","FontSize":"","Bold":"false","Italic":"false","TextAlign":"left","VerticalAlign":"middle","TextDecorationLine":"","ValidateMsg":"","Pattern":""},{"Type":"Text","ReadOnly":"False","DisplayName":"天","TextPosition":"normal"//常规normal,上标superscript,下标subscript}]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpBDMComElements(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s argDTO = ##class(EMR.DOC.DTO.BDMCompositeElements).%New()
	s argDTO.ID =  ..GetIDByKey(argInJson.params.id)
	s argDTO.Code = argInJson.params.node.attrs.code
	s argDTO.Name = argInJson.params.node.attrs.name
	s argDTO.Type = argInJson.params.node.type
	s argDTO.BDMCategory =  ..GetIDByKey(argInJson.params.parentId)
	s node = argInJson.params.node
	s glossary = argInJson.params.node.attrs.glossary
	TSTART
    s strRes = ##Class(EMR.DOC.BL.BDMCompositeElements).UpBDMComElementsJson(argDTO,node)
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
	s argInJson.params.type = "CT"
	s res = ##Class(EMR.DOC.BL.BDMSimpleElements).UpdateGlossary(argInJson,argInData,argOutMessage,argOutData)
	if (argOutMessage.errorCode=""){
		TCOMMIT
		s argOutMessage.success = ..#OK
	}else{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR",argOutMessage.errorMessage,2)
	}
	q 1
Error
	TROLLBACK
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除复合元素
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"DEL_BDM_COMELEMENTS","params":{"id":3},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelBDMComElements(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID =  ..GetIDByKey(argInJson.params.id)
	TSTART
	//删除术语关联
	s strRes = ##class(EMR.DOC.BL.BDMCategory).DeleteGlossaryJson(strID,"CT")
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
    s strRes = ##Class(EMR.DOC.BL.BDMCompositeElements).DelBDMComElementsJson(strID)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到元素,-301 未查到目录章节
    if (strRes=1)
	{
		TCOMMIT
		s argOutMessage.success = ..#OK
	} 
	elseif(strRes = "-100")
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
	q 1
Error
	TROLLBACK 
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000","2")
}

/// Desc:       获取复合元素
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMCompositeElements).GetCompositeJsonByPID(1,"")
ClassMethod GetCompositeJsonByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.BDMCompositE865I("IdxCategory",aParentId,rowCID))
		q:(rowCID = "")				
		s objSim = ##Class(CF.EMR.DOC.BDMCompositeElements).%OpenId(rowCID)
	    continue:(objSim="")
	    s jsonCom  = ##class(%DynamicObject).%New()
	    s jsonCom.key = rowCID_"||CT"
	    s jsonCom.code = objSim.Code
	    s jsonCom.title = objSim.Name
	    s jsonCom.type = "CT"
	    s jsonCom.MIType = "compolex"
	    s jsonCom.glossaryItemIDS = objSim.GlossaryItemIDS
	    s jsonCom.sequence = objSim.Sequence
	    
		s jsonComeAtrr = ##class(%DynamicAbstractObject).%FromJSON(objSim.DataAttributes)
		s jsonCom.node = jsonComeAtrr
		d jsonCategory.%Push(jsonCom)	
	}
	q res
}

/// Desc:       添加模板
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argDTO  模板对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空，-202 元素类型不能为空
/// 						  -300 未查到目录 
/// 						  -400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCompositeElements).AddBDMSimElementsJson()
ClassMethod AddBDMComElementsJson(argDTO As EMR.DOC.DTO.BDMCompositeElements, dataAttributes As %DynamicAbstractObject) As %String
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
	s obj = ##class(CF.EMR.DOC.BDMCompositeElements).%New()
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
	s strBDMETypeID = $o(^CT.EMR.DOC.BDMComElementsI("IdxCode"," "_$zcvt(argDTO.Type,"U"),""))
	if (strBDMETypeID="") 
	{
		TROLLBACK
		q "202"
	}
	s objBDMETypes = ##Class(CT.EMR.DOC.TemElementTypes).%OpenId(strBDMETypeID)
	*/
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCompositE865I("IdxCateCode",intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	}
	//s obj.Type = objBDMETypes
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

/// Desc:       更新复合元素
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空，-202 元素类型不能为空,
/// 							  -300 未查到目录，-400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCompositeElements).UpBDMSimElementsJson()
ClassMethod UpBDMComElementsJson(argDTO As EMR.DOC.DTO.BDMCompositeElements, dataAttributes As %DynamicAbstractObject) As %String
{
	s strRes = "-100"
	if (argDTO.ID="") 
	{
		q "-200"
	}
	if (argDTO.Code = "")
	{
		q "-201"
	}
	if (argDTO.Type = "")
	{
		q "-202"
	}
	s obj = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(argDTO.ID)
	q:(obj="") "-200" 
	s intParentID = +(argDTO.BDMCategory)
	if ((intParentID>0)&&(intParentID'=obj.BDMCategory.%Id()))
	{
		//在父目录下添加子目录
		s objNewParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(intParentID)
		q:(objNewParent="") "-300"
		s obj.Product = objNewParent.Product
		s objNewParent.ResChildCount = +(objNewParent.ResChildCount)+1
		s objOldParent = obj.BDMCategory
		q:(objOldParent="") "-300"
	
		s objOldParent.ResChildCount = objOldParent.ResChildCount-1
		s scNew = objNewParent.%Save()
		if ('$$$ISOK(scNew)){
			q -101	
		}
		s scOld = objOldParent.%Save()
		if ('$$$ISOK(scOld)){
			q -101	
		}
	}else{
		s intParentID = obj.BDMCategory.%Id()
	}
	/*
	s strBDMETypeID = $o(^CT.EMR.DOC.TemElementTypesI("IdxCode"," "_$zcvt(argDTO.Type,"U"),""))
	q:(strBDMETypeID="") "202"
	
	s objBDMETypes = ##Class(CT.EMR.DOC.TemElementTypes).%OpenId(strBDMETypeID)*/
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCompositE865I("IdxCateCode",intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if ((isHas'="")&&(isHas'=argDTO.ID))
	{
		q "-400"
	}

	;s obj.Type = objBDMETypes
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.DataAttributes = dataAttributes.%ToJSON()
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 q strRes
	}
	q "1"
}

/// Desc:       删除复合元素
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到元素,-301 未查到目录章节
/// Debug:      w ##Class(EMR.DOC.BL.BDMCompositeElements).DelBDMSimElementsJson("3")
ClassMethod DelBDMComElementsJson(argSimID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (argSimID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(argSimID)
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
	s sc = ##class(CF.EMR.DOC.BDMCompositeElements).%DeleteId(argSimID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

}
