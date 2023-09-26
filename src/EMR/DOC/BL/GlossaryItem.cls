/// 名称:	EMR.DOC.BL.GlossaryItem
/// 描述:	通用文档管理模块 Document(Doc) 术语关联业务类
/// 编写者：yejian
/// 编写日期: 2021-1-21
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlossaryItem Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取元素关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_GLOSSARYITEM_BYELEMENT","params":{"id":"1","temType":"EMRDOC","itemType":"ICOMPOSITESAMPLE","sCode":"S001","cCode":"V001","csCode":"I0002"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryItemByElement(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataID = ..GetIDByKey(argInJson.params.id)
	s TemType = argInJson.params.temType
	s ItemType = $zcvt(argInJson.params.itemType,"U")
	s strCodePath = $case(argInJson.params.sCode,"":"",:argInJson.params.sCode)
    s strCodePath = strCodePath_$case(argInJson.params.cCode,"":"",:"_"_argInJson.params.cCode)
    s strCodePath = strCodePath_$case(argInJson.params.maCode,"":"",:"_"_argInJson.params.maCode)
    s strCodePath = strCodePath_$case(argInJson.params.csCode,"":"",:"_"_argInJson.params.csCode)
    s strCodePath =$zcvt(strCodePath,"U")
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemByElementJson(DataID,TemType,ItemType,strCodePath,.argOutData)
	 //-100:获取数据失败 -200:传入参数不能为空
	if (strRes = "-100")
	{ 
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
	elseif (strRes = "-200")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","传入参数不能为空",2)
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联类型没查到",2)	
	}
	else
	{  
	     q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取模板下所有已经关联术语的数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_GLOSSARYITEMS_BYID","params":{"id":"1","temType":"EMRDOC"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryItemsByID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataID = ..GetIDByKey(argInJson.params.id)
	s TemType = argInJson.params.temType
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByIDJson(DataID,TemType,.argOutData)
    //-100:获取数据失败 -200:传入参数不能为空
	if (strRes = "-100")
	{ 
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
	elseif (strRes = "-200")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","传入参数不能为空",2)
	}
	else
	{  
	     q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取术语下所有已经关联术语的数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_GLOSSARYITEMS_BYGLOSSARYID","params":{"id":"1","":"BDM"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryItemsByGID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strGlossaryID = argInJson.params.id
	s strTemType = argInJson.params.temType
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByGIDJson(strGlossaryID,strTemType,.argOutData)
    //-100:获取数据失败 -200:传入参数不能为空
	if (strRes = "-100")
	{ 
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
	elseif (strRes = "-200")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","传入参数不能为空",2)
	}
	else
	{  
	     q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       添加模板元素关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"ADD_GLOSSARYITEM_DOCUMENT","params":{"id":"1","dataCode":"EMR090002","temType":"EMRDOC","glossaryID":"1",itemType":"ICOMPOSITESAMPLE","sCode":"S001","cCode":"V001","maCode":"","csCode":"I0002","itemName":"EMR09住院志.EMR090001入院记录.入院记录.S001患者基本信息.I0002性别.代码","valueType":"V"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddGlossaryItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoGItem = ##class(EMR.DOC.DTO.GlossaryItem).%New()
	s dtoGItem.DataID = ..GetIDByKey(argInJson.params.id)
	s dtoGItem.DataCode = argInJson.params.dataCode
	s dtoGItem.TemType = argInJson.params.TemType
	s dtoGItem.GlossaryID = ..GetIDByKey(argInJson.params.glossaryID)
	s dtoGItem.ItemType = $zcvt(argInJson.params.itemType,"U")
	s dtoGItem.SCode = argInJson.params.SCode
	s dtoGItem.CCode = argInJson.params.CCode
	s dtoGItem.MACode = argInJson.params.MACode
	s dtoGItem.CSCode = argInJson.params.CSCode
	s dtoGItem.ItemName = argInJson.params.itemName
	s dtoGItem.ValueType = argInJson.params.valueType
	if ((argInJson.params.className'="")||(argInJson.params.propertys'=""))
	{
		s strCodePath=argInJson.params.className_"#"_argInJson.params.propertys
	}
	else
	{
		s strCodePath = $case(argInJson.params.SCode,"":"",:argInJson.params.SCode)
	    s strCodePath = strCodePath_$case(argInJson.params.CCode,"":"",:"_"_argInJson.params.CCode)
	    s strCodePath = strCodePath_$case(argInJson.params.MACode,"":"",:"_"_argInJson.params.MACode)
	    s strCodePath = strCodePath_$case(argInJson.params.CSCode,"":"",:"_"_argInJson.params.CSCode)
    }
    s dtoGItem.CodePath =strCodePath
    ;s dtoGItem.CodePath =$zcvt(strCodePath,"U")
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItemJson(dtoGItem)
    //-100 添加失败, -200 元素类型不能为空，-201 章节编码不能为空,-202 段落编码不能为空，-203 元素编码不能为空， -204 复合元素编码不能为空，
    // -205 复合元素元素编码为空，-206 宏对象编码为空， -207 宏对象元素编码为空,  -300 术语未查到, -301 关联类型没查到，-400 已关联术语
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素类型不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","章节编码不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","段落编码不能为空",2)	
	}
	elseif (strRes = "-203")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素编码不能为空",2)	
	}
	elseif (strRes = "-204")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","复合元素编码不能为空",2)	
	}
	elseif (strRes = "-205")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","复合元素元素编码为空",2)	
	}
	elseif (strRes = "-206")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","宏对象编码为空",2)	
	}
	elseif (strRes = "-207")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","宏对象元素编码为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","术语未查到",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联类型没查到",2)	
	}
	elseif (strRes = "-311")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","章节关联内容重复",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","已关联术语",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       业务数据模型插入文档时关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"ADD_GLOSSARYITEM_BYBDM","params":{"id":"1","dataCode":"EMR090002","temType":"EMRDOC","sCode":"S001","cCode":"V001","bdmDataID":"1","itemType":"ISECTIONDESC","itemName":"EMR09住院志.EMR090001入院记录.入院记录.S001患者基本信息.I0002性别.代码"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddGlossaryItemByBDM(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoGItem = ##class(EMR.DOC.DTO.GlossaryItem).%New()
	s dtoGItem.DataID = ..GetIDByKey(argInJson.params.id)
	s dtoGItem.DataCode = argInJson.params.dataCode
	s dtoGItem.TemType = argInJson.params.temType
	s dtoGItem.SCode = argInJson.params.sCode
	s dtoGItem.CCode = argInJson.params.cCode
	s dtoGItem.ItemName = argInJson.params.itemName
	s dtoGItem.ItemType = $zcvt(argInJson.params.itemType,"U")
	s bdmDataID = argInJson.params.bdmDataID
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItemByBDMJson(dtoGItem,bdmDataID)
    d argOutData.Write(strRes)
    //-100 添加失败, -200 元素类型不能为空，-201 章节编码不能为空,-202 段落编码不能为空，-203 元素编码不能为空， -204 复合元素编码不能为空，
    // -205 复合元素元素编码为空，-206 宏对象编码为空， -207 宏对象元素编码为空,  -300 术语未查到, -301 关联类型没查到，-400 已关联术语
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素类型不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","章节编码不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","段落编码不能为空",2)	
	}
	elseif (strRes = "-203")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素编码不能为空",2)	
	}
	elseif (strRes = "-204")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","复合元素编码不能为空",2)	
	}
	elseif (strRes = "-205")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","复合元素元素编码为空",2)	
	}
	elseif (strRes = "-206")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","宏对象编码为空",2)	
	}
	elseif (strRes = "-207")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","宏对象元素编码为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","术语未查到",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联类型没查到",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","已关联术语",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除模板元素关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"DEL_GLOSSARYITEM","params":{"id":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DelGlossaryItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s GlossaryItemID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).DelGlossaryItemJson(GlossaryItemID)
    //失败:-100 删除失败, -200 ID不能为空 -300 未查到目录
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到目录","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除关联术语根据编码（文档和板式暂时版本问题，不能通过删除元素删除关联，通过术语统一管理，手动删除关系关系）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"DEL_GLOSSARYITEM_BYCODE","params":{"id":"57","dataCode":"EMR090002","temType":"BDM","itemType":"ICONCEPTSAMPLE","sCode":"S001","cCode":"","maCode":"MA0001","csCode":"L0001"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DelGlossaryItemByCode(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoGItem = ##class(EMR.DOC.DTO.GlossaryItem).%New()
	s dtoGItem.DataID = ..GetIDByKey(argInJson.params.id)
	s dtoGItem.DataCode = argInJson.params.dataCode
	s dtoGItem.TemType = argInJson.params.temType
	s dtoGItem.ItemType = $zcvt(argInJson.params.itemType,"U")
	s dtoGItem.SCode = argInJson.params.sCode
	s dtoGItem.CCode = argInJson.params.cCode
	s dtoGItem.MACode = argInJson.params.maCode
	s dtoGItem.CSCode = argInJson.params.csCode
	s strCodePath = $case(argInJson.params.sCode,"":"",:argInJson.params.sCode)
    s strCodePath = strCodePath_$case(argInJson.params.cCode,"":"",:"_"_argInJson.params.cCode)
    s strCodePath = strCodePath_$case(argInJson.params.maCode,"":"",:"_"_argInJson.params.maCode)
    s strCodePath = strCodePath_$case(argInJson.params.csCode,"":"",:"_"_argInJson.params.csCode)
    s dtoGItem.CodePath =$zcvt(strCodePath,"U")
    s strRes = ##Class(EMR.DOC.BL.GlossaryItem).DelGlossaryItemByCodeJson(dtoGItem)
   //-100 添加失败, -200 元素类型不能为空，-201 章节编码不能为空,-202 段落编码不能为空，-203 元素编码不能为空， -204 复合元素编码不能为空，
    // -205 复合元素元素编码为空，-206 宏对象编码为空， -207 宏对象元素编码为空, -208 文档类型不能为空，-209 关联类型不能为空
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素类型不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","章节编码不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","段落编码不能为空",2)	
	}
	elseif (strRes = "-203")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素编码不能为空",2)	
	}
	elseif (strRes = "-204")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","复合元素编码不能为空",2)	
	}
	elseif (strRes = "-205")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","复合元素元素编码为空",2)	
	}
	elseif (strRes = "-206")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","宏对象编码为空",2)	
	}
	elseif (strRes = "-207")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","宏对象元素编码为空",2)	
	}
	
	elseif (strRes = "-208")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档类型不能为空",2)	
	}
	elseif (strRes = "-209")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联类型不能为空",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取元素关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aTemplateID  模板ID
/// 				aTemType 文档类型
/// 				aItemCode	编码规则
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemByElementJson("1","EMRDOC","#TYPE:ICOMPOSITESAMPLE#SCODE:S001|CCODE:V003|CSCODE:I0002",argOutData)
ClassMethod GetGlossaryItemByElementJson(aDataID As %String, aTemType As %String, aItemType As %String, aCodePath As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-100"
	q:((aDataID="")||(aTemType="")||(aItemType="")) "-200"
	s jsonArr = ##class(%DynamicArray).%New()
	s strItemTypeID = $o(^CF.EMR.DOC.GlossaryItemTypeI("IdxCode"," "_$zcvt(aItemType,"U"),""))
	q:(strItemTypeID="") "-301"
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.GlossaryItemI("IdxTCodeType",aDataID,strItemTypeID," "_$zcvt(aCodePath,"U")," "_$zcvt(aTemType,"U"),rowID))
		q:(rowID = "")				
		s objItem = ##Class(CF.EMR.DOC.GlossaryItem).%OpenId(rowID)
        continue:(objItem="")
        s objGlossary = ##Class(CF.EMR.DOC.Glossary).%OpenId(objItem.GlossaryID)
        continue:(objGlossary="")
        s jsonItem  = ##class(%DynamicObject).%New()
        s jsonItem.id =objItem.GlossaryID
        s jsonItem.name =objGlossary.Name
        s jsonItem.internalId = objGlossary.InternalID
       	s jsonItem.valueType = objItem.ValueType
       	s jsonItem.itemName = objItem.ItemName		
		d jsonArr.%Push(jsonItem)
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取模板下所有已经关联术语的数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aTemplateID  模板ID
/// 				aTemType 文档类型
/// 				aItemCode	编码规则
/// OutPut:     argOutData 返回数据 -100:获取数据失败 -200:传入参数不能为空
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByIDJson("1","EMRDOC",argOutData)
ClassMethod GetGlossaryItemsByIDJson(aDataID As %String, aTemType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-100"
	q:((aDataID="")||(aTemType="")) "-200"
	s jsonArr = ##class(%DynamicArray).%New()
	
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.GlossaryItemI("IdxTypeDataID"," "_$zcvt(aTemType,"U"),aDataID,rowID))
		q:(rowID = "")				
		s objItem = ##Class(CF.EMR.DOC.GlossaryItem).%OpenId(rowID)
        continue:((objItem="")||(objItem.TemType'=aTemType))
        s jsonItem  = ##class(%DynamicObject).%New()
        s jsonItem.id =rowID
        s jsonItem.itemType =$case(objItem.ItemType,"":"",:objItem.ItemType.Code)
      	s jsonItem.sCode =objItem.SCode
        s jsonItem.cCode =objItem.CCode
        s jsonItem.maCode =objItem.MACode
        s jsonItem.csCode =objItem.CSCode
        s jsonItem.itemName = objItem.ItemName
       	s jsonItem.glossaryID = objItem.GlossaryID
       	s jsonItem.temType = objItem.TemType	
       	s jsonItem.valueType = objItem.ValueType	
		d jsonArr.%Push(jsonItem)
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取术语下所有已经关联术语的数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aGlossaryID  术语ID
/// OutPut:     argOutData 返回数据 -100:获取数据失败 -200:传入参数不能为空
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByGIDJson("1",argOutData)
ClassMethod GetGlossaryItemsByGIDJson(aGlossaryID As %String, aTemType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-100"
	s id=..GetIDByKey(aGlossaryID)
	q:((id="")||(aTemType="")) "-200"
	s jsonArr = ##class(%DynamicArray).%New()
	
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.GlossaryItemI("IdxGlossaryID",id,rowID))
		q:(rowID = "")				
		s objItem = ##Class(CF.EMR.DOC.GlossaryItem).%OpenId(rowID)
        continue:(objItem="")
        //ALL表示获取该术语所有关联关系
        if (aTemType'="ALL")
        {
	        //类型为文档或版式时，版式和文档关联关系都获取
	        if (aTemType="EMRDOC")||(aTemType="HFF")
	        {
		    	continue:((objItem.TemType'="EMRDOC")&&(objItem.TemType'="HFF"))    
	        }
	        else //获取对应类型关联关系
	        {
	        	continue:(objItem.TemType'=aTemType)
	        }
        }
        s jsonItem  = ##class(%DynamicObject).%New()
        s jsonItem.id =rowID
        s jsonItem.key =rowID
        s jsonItem.itemType =$case(objItem.ItemType,"":"",:objItem.ItemType.Code)
        if (objItem.ItemType'="")
        {
	        if ((objItem.ItemType.Code="EMRINSTANCE")||(objItem.ItemType.Code="TOOTH"))
	        {
		        s jsonItem.className=$p(objItem.CodePath,"#",1)
		        s jsonItem.propertys=$p(objItem.CodePath,"#",2)
	        }
        }
        s jsonItem.sCode =objItem.SCode
        s jsonItem.cCode =objItem.CCode
        s jsonItem.maCode =objItem.MACode
        s jsonItem.csCode =objItem.CSCode
        s jsonItem.itemName = objItem.ItemName
        s jsonItem.title = objItem.ItemName
       	s jsonItem.glossaryID = objItem.GlossaryID_"||"_..GetTypeByKey(aGlossaryID)
       	s jsonItem.temType = objItem.TemType	
       	s jsonItem.valueType = objItem.ValueType
       	if ((objItem.TemType="EMRDOC")||(objItem.TemType="EMRINSTANCE"))
       	{
       		s jsonItem.dataID = objItem.DataID_"||DT"	
       	}
       	elseif (objItem.TemType="KB")
       	{
       		s jsonItem.dataID = objItem.DataID_"||IT"	
	    }	
		d jsonArr.%Push(jsonItem)
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       添加模板元素关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  术语关联对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 元素类型不能为空，-201 章节编码不能为空,-202 段落编码不能为空，-203 元素编码不能为空， 
/// 						  -204 复合元素编码不能为空，-205 复合元素元素编码为空，-206 宏对象编码为空， -207 宏对象元素编码为空
/// 						  -300 术语未查到 ,-301 关联类型没查到，-400 已关联术语
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByDocIDJson("1","EMRDOC",argOutData)
ClassMethod AddGlossaryItemJson(aDTOItem As EMR.DOC.DTO.GlossaryItem) As %String
{
	s strRes = "-100"
	q:((aDTOItem = "")||(aDTOItem.GlossaryID="")) strRes
	//元素类型判断
	q:(aDTOItem.ItemType="") "-200"
	if ((aDTOItem.ItemType'="EMRINSTANCE")&&(aDTOItem.ItemType'="TOOTH"))
	{
		//章节编码判断		
		q:(aDTOItem.SCode="")&&(aDTOItem.TemType'="KB") "-201"
		//段落编码判断
		/*if ((aDTOItem.ItemType="ICOMPOSITEDESC")||((aDTOItem.ItemType="ICOMPOSITESAMPLE")&&(aDTOItem.TemType'="BDM"))
		||((aDTOItem.ItemType="ICONCEPTDESC")&&(aDTOItem.TemType'="BDM"))||((aDTOItem.ItemType="ICONCEPTSAMPLE")&&(aDTOItem.TemType'="BDM"))
		||(aDTOItem.ItemType="IMACRODESC")||(aDTOItem.ItemType="IMACROSAMPLE"))&&(aDTOItem.CCode="") 
		{
			q "-202"
		}*/
		//元素编码判断
		q:((aDTOItem.ItemType="ICOMPOSITESAMPLE")&&(aDTOItem.CSCode="")) "-203"
		//复合元素编码判断
		q:((aDTOItem.ItemType="ICONCEPTDESC")&&(aDTOItem.MACode="")) "-204"
		//复合元素元素编码判断
		q:((aDTOItem.ItemType="ICONCEPTSAMPLE")&&(aDTOItem.CSCode="")) "-205"
		//宏对象编码判断
		q:((aDTOItem.ItemType="IMACRODESC")&&(aDTOItem.MACode="")) "-206"
		//宏对象元素编码判断
		q:((aDTOItem.ItemType="IMACROSAMPLE")&&(aDTOItem.CSCode="")) "-207"
		
		;s tag=$o(^CF.EMR.DOC.GlossaryItemI("IdxTmpScode",aDTOItem.GlossaryID,aDTOItem.DataID," "_$zcvt(aDTOItem.SCode,"U"),""))
		;q:(tag'="") "-311"
	}
	s objGlossary = ##class(CF.EMR.DOC.Glossary).%OpenId(aDTOItem.GlossaryID)
	q:(objGlossary = "") "-300"
	
	s strItemTypeID = $o(^CF.EMR.DOC.GlossaryItemTypeI("IdxCode"," "_$zcvt(aDTOItem.ItemType,"U"),""))
	q:(strItemTypeID="") "-301"
	s objItemTypes = ##Class(CF.EMR.DOC.GlossaryItemType).%OpenId(strItemTypeID)
	q:(objItemTypes = "") "-301"
	
	
	s rowID = $o(^CF.EMR.DOC.GlossaryItemI("IdxLink",..GetIDByKey(aDTOItem.DataID),strItemTypeID," "_$zcvt(aDTOItem.CodePath,"U")," "_$zcvt(aDTOItem.ValueType,"U"),aDTOItem.GlossaryID,""))
	q:(rowID'="") "-400"
	
	s obj = ##class(CF.EMR.DOC.GlossaryItem).%New()
	s obj.GlossaryID = aDTOItem.GlossaryID
	s obj.InternalID = objGlossary.InternalID
	s obj.ItemType = objItemTypes
	s obj.SCode = aDTOItem.SCode
	s obj.CCode = aDTOItem.CCode
	s obj.MACode = aDTOItem.MACode
	s obj.CSCode = aDTOItem.CSCode
	s obj.CodePath = aDTOItem.CodePath
	s obj.ItemName = aDTOItem.ItemName
	s obj.DataCode = aDTOItem.DataCode
	s obj.DataID = aDTOItem.DataID
	s obj.TemType = aDTOItem.TemType
	s obj.ValueType = aDTOItem.ValueType
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s strRes =obj.%Id()
		
	}
	else
	{
		 s strRes = "-100"
	}
	q strRes
}

/// Desc:       添加模板元素关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  术语关联对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 业务数据模型元素ID不能为空，-201 章节编码不能为空,-202 段落编码不能为空，-203 业务数据模型元素类型不能为空， 
/// 						  -204 复合元素编码不能为空，-205 复合元素元素编码为空，-206 宏对象编码为空， -207 宏对象元素编码为空
/// 						  -300 业务数据模型元素未查到 ,-301 关联类型没查到，-400 已关联术语
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByDocIDJson("1","EMRDOC",argOutData)
ClassMethod AddGlossaryItemByBDMJson(aDTOItem As EMR.DOC.DTO.GlossaryItem, abdmDataID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if ((aDTOItem = "")||(aDTOItem.DataID=""))
	{ 
		TROLLBACK
		q strRes
	}
	//业务数据模型元素ID判断
	if (abdmDataID="") 
	{ 
		TROLLBACK
		q "-200"
	}
	//章节编码判断		
	if (aDTOItem.SCode="")&&(aDTOItem.TemType'="KB") 
	{ 
		TROLLBACK
		q "-201"
	}
	//段落编码判断
	if (aDTOItem.CCode="")&&(aDTOItem.ItemType'="ISECTIONDESC")
	{ 
		TROLLBACK
		q "-202"
	} 
	//业务数据模型元素类型
	if (aDTOItem.ItemType="")
	{ 
		TROLLBACK
		q "-203"
	} 
	s strItemTypeID = $o(^CF.EMR.DOC.GlossaryItemTypeI("IdxCode"," "_$zcvt(aDTOItem.ItemType,"U"),""))
	if (strItemTypeID="") 
	{ 
		TROLLBACK
		q "-301"
	}
	s objItemTypes = ##Class(CF.EMR.DOC.GlossaryItemType).%OpenId(strItemTypeID)
	if (objItemTypes = "") 
	{ 
		TROLLBACK
		q "-301"
	}
	s intMark = "0"
	//插入简单元素
	if (aDTOItem.ItemType ="ICOMPOSITESAMPLE")
	{
		s objSim=##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(abdmDataID)
		if (objSim="")
		{ 
			TROLLBACK
			q "-300"
		} 
		s strDataID = $case(objSim.BDMCategory,"":"",:objSim.BDMCategory.ParentID)
		s strSCode=$case(objSim.BDMCategory,"":"",:objSim.BDMCategory.Code)
		s strCSCode = objSim.Code
		s strCodePath = strSCode_"_"_strCSCode
		s strCodePath = $zcvt(strCodePath,"U")
		d addItem
	}
	elseif (aDTOItem.ItemType ="ICONCEPTDESC") //插入医学概念
	{
		s objCom=##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(abdmDataID)
		if (objCom="")
		{ 
			TROLLBACK
			q "-300"
		} 
		s strDataID = $case(objCom.BDMCategory,"":"",:objCom.BDMCategory.ParentID)
		s strSCode=$case(objCom.BDMCategory,"":"",:objCom.BDMCategory.Code)
		s strCSCode = objCom.Code
		s strCodePath = strSCode_"_"_strCSCode
		s strCodePath = $zcvt(strCodePath,"U")
		d addItem
	}
	elseif(aDTOItem.ItemType="ISECTIONDESC") //插入章节
	{
		s objSec=##class(CF.EMR.DOC.BDMCategory).%OpenId(abdmDataID)
		if (objSec="")
		{ 
			TROLLBACK
			q "-300"
		} 
		s strDataID = $case(objSec.ParentID,"":"",:objSec.ParentID)
		s strSCode=$case(objSec.Code,"":"",:objSec.Code)
		s strCodePath = strSCode
		s strCodePath = $zcvt(strCodePath,"U")
		d addItem
	}
	TCOMMIT
	q "1"
	
addItem
	s rowGID = ""
	for {
		s rowGID = $o(^CF.EMR.DOC.GlossaryItemI("IdxTCodeType",strDataID,strItemTypeID," "_strCodePath," BDM",rowGID))
		q:(rowGID = "")				
		s objItem = ##Class(CF.EMR.DOC.GlossaryItem).%OpenId(rowGID)
		s rowID = $o(^CF.EMR.DOC.GlossaryItemI("IdxLink",aDTOItem.DataID,strItemTypeID," "_$zcvt(objItem.CodePath,"U")," "_$zcvt(objItem.ValueType,"U"),objItem.GlossaryID,""))
		continue:(rowID '= "")
		s obj = ##class(CF.EMR.DOC.GlossaryItem).%New()
		s strCodePath = $case(aDTOItem.SCode,"":"",:aDTOItem.SCode)
	    s strCodePath = strCodePath_$case(aDTOItem.CCode,"":"",:"_"_aDTOItem.CCode)
	    s strCodePath = strCodePath_$case(objItem.MACode,"":"",:"_"_objItem.MACode)
	    s strCodePath = strCodePath_$case(objItem.CSCode,"":"",:"_"_objItem.CSCode)
		s obj.GlossaryID = objItem.GlossaryID
		s obj.InternalID = objItem.InternalID
		s obj.ItemType = objItemTypes
		s obj.CodePath =$zcvt(strCodePath,"U")
		s obj.ValueType = objItem.ValueType
		s obj.MACode = objItem.MACode
		s obj.CSCode = objItem.CSCode
		s obj.SCode = aDTOItem.SCode
		s obj.CCode = aDTOItem.CCode
		s obj.ItemName = aDTOItem.ItemName
		s obj.DataCode = aDTOItem.DataCode
		s obj.DataID = aDTOItem.DataID
		s obj.TemType = aDTOItem.TemType
		s sc = obj.%Save()
		if ('$$$ISOK(sc))
		{
			 s intMark = "-1"
			 q
		}	
	}
	if (intMark = "-1")
	{
		TROLLBACK
		q strRes
	}
}

/// Desc:       删除关联术语
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aGlossaryItemID  术语关联ID
/// OutPut:     返回数据 成功：1,失败:-100 删除失败, -200 ID不能为空 -300 未查到目录,-500 包含子节点不能删除
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).DelGlossaryItemByDocJson("40",argOutData)
ClassMethod DelGlossaryItemJson(aGlossaryItemID As %String) As %String
{
	s strRes = "-100"
	q:(aGlossaryItemID="") "-200"
	if (##class(CF.EMR.DOC.GlossaryItem).%ExistsId(aGlossaryItemID))	
	{
		if (##class(CF.EMR.DOC.GlossaryItem).%DeleteId(aGlossaryItemID))
		{
			q "1"
		}
		else
		{
			q strRes	
		}
	}
	else	  
	{
		q "-300"
	}
}

/// Desc:       根据类型和编码删除关联关系
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aGlossaryItemID  术语关联ID
/// OutPut:     返回数据 成功：1,失败:-100 删除失败, -200 ID不能为空, -201 章节编码不能为空,-202 段落编码不能为空，-203 元素编码不能为空， 
/// 						  -204 复合元素编码不能为空，-205 复合元素元素编码为空，-206 宏对象编码为空， -207 宏对象元素编码为空, -208 文档类型不能为空，-209 关联类型不能为空
/// 						  -300 关联类型为查到
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItem).DelGlossaryItemByDocJson("40",argOutData)
ClassMethod DelGlossaryItemByCodeJson(dtoItem As EMR.DOC.DTO.GlossaryItem) As %String
{
	s strRes = "-100"
	q:(dtoItem.DataID="") "-200"
	q:(dtoItem.TemType="") "-208"
	q:(dtoItem.ItemType="") "-209"
	//章节编码判断		
	q:(dtoItem.SCode="")&&(dtoItem.TemType'="KB") "-201"
	//段落编码判断
	if ((dtoItem.ItemType="ICOMPOSITEDESC")||((dtoItem.ItemType="ICOMPOSITESAMPLE")&&(dtoItem.TemType'="BDM"))
	||((dtoItem.ItemType="ICONCEPTDESC")&&(dtoItem.TemType'="BDM"))||((dtoItem.ItemType="ICONCEPTSAMPLE")&&(dtoItem.TemType'="BDM"))
	||(dtoItem.ItemType="IMACRODESC")||(dtoItem.ItemType="IMACROSAMPLE"))&&(dtoItem.CCode="") 
	{
		q "-202"
	}
	//元素编码判断
	q:((dtoItem.ItemType="ICOMPOSITESAMPLE")&&(dtoItem.CSCode="")) "-203"
	//复合元素编码判断
	q:((dtoItem.ItemType="ICONCEPTDESC")&&(dtoItem.MACode="")) "-204"
	//复合元素元素编码判断
	q:((dtoItem.ItemType="ICONCEPTSAMPLE")&&(dtoItem.CSCode="")) "-205"
	//宏对象编码判断
	q:((dtoItem.ItemType="IMACRODESC")&&(dtoItem.MACode="")) "-206"
	//宏对象元素编码判断
	q:((dtoItem.ItemType="IMACROSAMPLE")&&(dtoItem.CSCode="")) "-207"
	
	//删除章节
	if (dtoItem.ItemType="ISECTIONDESC")
	{
		&sql(DELETE FROM CF_EMR_DOC.GlossaryItem i WHERE i.DataID =:dtoItem.DataID AND i.TemType =:dtoItem.TemType AND i.SCode =:dtoItem.SCode)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			q strRes
		}
	}
	elseif (dtoItem.ItemType="ICOMPOSITEDESC") //删除段落
	{
		&sql(DELETE FROM CF_EMR_DOC.GlossaryItem i WHERE i.DataID =:dtoItem.DataID AND i.TemType =:dtoItem.TemType AND i.SCode =:dtoItem.SCode AND i.CCode =:dtoItem.CCode)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			q strRes
		}
	}
	elseif (dtoItem.ItemType="ICOMPOSITESAMPLE") //删除元素
	{
		&sql(DELETE FROM CF_EMR_DOC.GlossaryItem i WHERE i.DataID =:dtoItem.DataID AND i.TemType =:dtoItem.TemType AND i.SCode =:dtoItem.SCode AND i.CCode =:dtoItem.CCode AND i.CSCode =:dtoItem.CSCode)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			q strRes
		}
	}
	elseif (dtoItem.ItemType="ICONCEPTDESC")||(dtoItem.ItemType="IMACRODESC") //删除宏对象
	{
		&sql(DELETE FROM CF_EMR_DOC.GlossaryItem i WHERE i.DataID =:dtoItem.DataID AND i.TemType =:dtoItem.TemType AND i.SCode =:dtoItem.SCode AND i.MACode =:dtoItem.MACode)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			q strRes
		}
	}
	elseif (dtoItem.ItemType="ICONCEPTSAMPLE")||(dtoItem.ItemType="IMACROSAMPLE") //删除宏对象元素
	{
		&sql(DELETE FROM CF_EMR_DOC.GlossaryItem i WHERE i.DataID =:dtoItem.DataID AND i.TemType =:dtoItem.TemType AND i.SCode =:dtoItem.SCode AND i.MACode =:dtoItem.MACode AND i.CSCode =:dtoItem.CSCode)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			q strRes
		}
	}
	q "1"
}

}
