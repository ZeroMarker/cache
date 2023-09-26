/// 名称:	EMR.DOC.BL.GlossaryItem
/// 描述:	术语集管理：术语集文档元素值域关联业务类
/// 编写者：yejian
/// 编写日期: 2021-5-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlossaryItemMap Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据元素术语关系ID获取文档元素选项值列表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action": "GET_VALUECHOICES_BYGITEMID","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetValueChoicesByGItemID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s glossaryItemID = ..GetIDByKey(argInJson.params.id)
	s current = argInJson.params.current
    s pageSize = argInJson.params.pageSize 
    s strRes = ##Class(EMR.DOC.BL.GlossaryItemMap).GetValueChoicesByGItemIDJson(glossaryItemID,current,pageSize,.argOutData)
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

/// Desc:       根据gossaryitemID取已经关联值域列表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATAELEMENTMAP_BYGLOSSARYITEM","params":{"id":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataElementMapByGIID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s glossaryItemID = ..GetIDByKey(argInJson.params.id)
	s current = argInJson.params.current
	s pageSize = argInJson.params.pageSize
    s strRes = ##Class(EMR.DOC.BL.GlossaryItemMap).GetDataElementMapByGIIDJson(glossaryItemID,current,pageSize,.argOutData)
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

/// Desc:       添加元素和数据元值域关联映射
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "ADD_DATAELEMENT_MAP","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDataElementMap(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s glossaryItemID = ..GetIDByKey(argInJson.params.id)
	s entifier = argInJson.params.entifier
	if (entifier = "")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据元标识符必传",2)
	}
	s DECVMID = ##Class(EMR.DOC.BL.DataElement).GetDevmIDByEntifier(entifier)
	if (argInJson.params.%GetTypeOf("list") '= "array")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","list必须为数组",2)
	}
	s list = argInJson.params.list
	s iter = list.%GetIterator()
	s strRes = 1
	while iter.%GetNext(.key , .item) {
		s DTOMap = ##class(EMR.DOC.DTO.GlossaryItemMap).%New()
		s DTOMap.GlossaryItemID = glossaryItemID
		s DTOMap.DEVID = item.devid
		s DTOMap.DEVDes = item.devValue
		s DTOMap.DECVMID = DECVMID
		s DTOMap.CodeSystem = item.codeSystem
		s DTOMap.TempID = item.code
		s DTOMap.TempDes = item.value
	    s strRes = ##Class(EMR.DOC.BL.GlossaryItemMap).AddMapJson(DTOMap)
	    q:(strRes'=1)
	}
	
	// OutPut:     成功 1 失败  -201 关联术语id -202 值域标识符 -203 值域值 -204 数据元允许值标示符关联ID -205 元素编码 -206 元素值
	//                          -101 保存数据出错  -301  关联术语记录不存在
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存数据出错",2)
	}
	elseif (strRes = -201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联术语id不能为空，检查参数id",2)	
	}
	elseif (strRes = -202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","值域标识符不能为空",2)	
	}
	elseif (strRes = -203)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","值域值不能为空",2)	
	}
	elseif (strRes = -204)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据元允许值不能为空",2)	
	}
	elseif (strRes = -205)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素编码不能为空",2)	
	}
	elseif (strRes = -206)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素值不能为空",2)	
	}
	elseif (strRes = -301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","术语集关联记录不存在，检查参数id",2)	
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:     删除元素和数据元值域关联映射
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_DATAELEMENT_MAP","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteDataElementMap(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.GlossaryItemMap).DeleteMapJson(ID)
	 ///output 成功 1 失败 -201 参数未传 -101 删除失败 -102 数据不存在
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
	elseif (strRes = -102)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据不存在",2)	
	}
	elseif (strRes = -201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","参数id未传",2)	
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 相同映射
/// input argArray  命令参数 {"action": "ADD_MAPBYVALUE","params":{ "id": "367",id"entifier":"DE02.01.040.00", "list":[{ "code":"1","value":"选项一",},{"code":"2","value":"选项一",} ]},"product": "GlobalEMR"}
/// output 成功 1 失败 -201 参数未传 -101 删除失败 -102 数据不存在
ClassMethod AddMapByValue(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s glossaryItemID = ..GetIDByKey(argInJson.params.id)
	s entifier = argInJson.params.entifier
	if (argInJson.params.%GetTypeOf("list") '= "array")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","list必须为数组",2)
	}
	s list = argInJson.params.list
	 ///output 成功 1 失败 -201 参数未传 -101 删除失败 -102 数据不存在
	s strRes = ##Class(EMR.DOC.BL.GlossaryItemMap).AddMapByValueJson(glossaryItemID,entifier,list)
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -100)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据存储出错",2)
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存数据出错",2)
	}
	elseif (strRes = -201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联术语id不能为空，检查参数id",2)	
	}
	elseif (strRes = -202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","值域标识符不能为空",2)	
	}
	elseif (strRes = -203)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","值域值不能为空",2)	
	}
	elseif (strRes = -204)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据元允许值不能为空",2)	
	}
	elseif (strRes = -205)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素编码不能为空",2)	
	}
	elseif (strRes = -206)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素值不能为空",2)	
	}
	elseif (strRes = -301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","术语集关联记录不存在，检查参数id",2)	
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据元素术语关系ID获取文档元素选项值列表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aGlossaryItemID  术语元素关联ID
/// OutPut:     成功 1 失败 -100 获取元素选项列表失败, -200 传入ID值有误或为空
/// 				-301 未获取到元素打散信息  -302 用户未关联角色  -303 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItemMap).GetValueChoicesByGItemIDJson("6",argOutData)
ClassMethod GetValueChoicesByGItemIDJson(aGlossaryItemID As %String, aCurrent As %String, aPageSize As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-100"
	q:(aGlossaryItemID="") "-200"
	s:aCurrent="" aCurrent=1
	s:aPageSize="" aPageSize=10
	s count = 0
	s jsonArr = ##class(%DynamicArray).%New()
	s objGItem = ##class(CF.EMR.DOC.GlossaryItem).%OpenId(aGlossaryItemID)
	q:(objGItem="") "-200"
	
	//业务数据模型中结构化元素
	if (objGItem.TemType="BDM")&&(objGItem.ItemType.Code="ICOMPOSITESAMPLE")
	{
		s documentID = objGItem.DataID
		s sectionCode = objGItem.SCode
		s csCode = objGItem.CSCode
		s rowSID =$o(^CF.EMR.DOC.BDMCategoryI("IdxParentIDCode"," "_$zcvt(documentID,"U")," "_$zcvt(sectionCode,"U"),""))
		q:(rowSID="") "-301"
		s rowID = $o(^CF.EMR.DOC.BDMSimpleElementsI("IdxCateCode",rowSID," "_$zcvt(csCode,"U"),""))
		q:(rowID = "") "-301"			
		s objSimEle = ##Class(CF.EMR.DOC.BDMSimpleElements).%OpenId(rowID)
        q:(objSimEle="") "-301"
        s simTypeCode = $zcvt(objSimEle.Type.Code,"U")
        //元素类型dictionary,radioGroup,checkboxGroup,select才有选项值 
        
        if ((simTypeCode="DICTIONARY")||(simTypeCode="RADIOGROUP")||(simTypeCode="CHECKBOXGROUP")||(simTypeCode="SELECT"))
        {
	        s jsonItem = ##class(%DynamicObject).%FromJSON(objSimEle.DataAttributes)
	        s jsonArr=jsonItem.attrs.choices
        }
		
	}
	elseif(objGItem.TemType="EMRDOC") //文档管理
	{
		s rowID = ""
		for {
			s rowID = $o(^CF.EMR.DOC.GlossaryItemMapI("IdxGlossaryItemID"," "_$zcvt(aGlossaryItemID,"U"),rowID))
			q:(rowID = "")				
			s objItemMap = ##Class(CF.EMR.DOC.GlossaryItemMap).%OpenId(rowID)
	        continue:(objItemMap="")
	        s jsonItem  = ##class(%DynamicObject).%New()
	        s jsonItem.glossaryItemID =objItemMap.GlossaryItemID
	       	s jsonItem.codeSystem = objItemMap.CodeSystem
	       	s jsonItem.decvMID = objItemMap.DECVMID
	       	s jsonItem.devID = objItemMap.DEVID
	       	s jsonItem.devDes = objItemMap.DEVDes
	       	s jsonItem.tempID =objItemMap.TempID
	        s jsonItem.tempDes = objItemMap.TempDes
			d jsonArr.%Push(jsonItem)
		}
	}
	
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       根据gossaryitemID取已经关联值域列表
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aGlossaryItemID  术语元素关联ID
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItemMap).GetDataElementMapByGIIDJson("1",argOutData)
ClassMethod GetDataElementMapByGIIDJson(aGlossaryItemID As %String, aCurrent As %String, aPageSize As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-100"
	q:((aGlossaryItemID="")) "-200"
	s:(aCurrent="") aCurrent=1
	s:(aPageSize="") aPageSize=10
	s start = (aCurrent-1)*aPageSize+1
	s end = start+aPageSize-1
	s count = 0
	s jsonRoot = ##class(%DynamicObject).%New()
	s jsonArr = ##class(%DynamicArray).%New()
	s rowID = ""
	for {
		;s rowID = $o(^CF.EMR.DOC.GlossaryItemMapI("IdxGlossaryItemID"," "_$zcvt(aGlossaryItemID,"U"),rowID))
		s rowID = $o(^CF.EMR.DOC.GlossaryItemMapI("IdxGlossaryItemID",aGlossaryItemID,rowID))
		q:(rowID = "")				
		s objItemMap = ##Class(CF.EMR.DOC.GlossaryItemMap).%OpenId(rowID)
        continue:(objItemMap="")
        s count= count+1
        ;continue:((count<start)||(count>end))
        s jsonItem  = ##class(%DynamicObject).%New()
        s jsonItem.glossaryItemID =objItemMap.GlossaryItemID.%Id()
       	s jsonItem.codeSystem = objItemMap.CodeSystem
       	s jsonItem.decvMID = objItemMap.DECVMID
       	s jsonItem.devID = objItemMap.DEVID
       	s jsonItem.devDes = objItemMap.DEVDes
       	s jsonItem.tempID =objItemMap.TempID
        s jsonItem.tempDes = objItemMap.TempDes
        s jsonItem.id = objItemMap.%Id()
		d jsonArr.%Push(jsonItem)
	}
	s jsonRoot.total = count
	s jsonRoot.current = aCurrent
	s jsonRoot.pageSize = aPageSize
	s jsonRoot.list = jsonArr
	d jsonRoot.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       添加元素和数据元值域映射
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      DTOMap 元素值域映射对象
/// OutPut:     成功 1 失败  -201 关联术语id -202 值域标识符 -203 值域值 -204 数据元允许值标示符关联ID -205 元素编码 -206 元素值
///                          -101 保存数据出错  -301  关联术语记录不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryItemMap).GetDataElementMapByGIIDJson("1",argOutData)
ClassMethod AddMapJson(DTOMap As EMR.DOC.DTO.GlossaryItemMap)
{
	q:(DTOMap.GlossaryItemID="") -201
	q:(DTOMap.DEVID="") -202
	q:(DTOMap.DEVDes="") -203
	q:(DTOMap.DECVMID="") -204
	q:(DTOMap.TempID="") -205
	q:(DTOMap.TempDes="") -206
	TSTART
	s ObjMap = ##class(CF.EMR.DOC.GlossaryItemMap).%New()
	s ObjGlossaryItem = ##class(CF.EMR.DOC.GlossaryItem).%OpenId(DTOMap.GlossaryItemID)
	if (ObjGlossaryItem=""){
		TROLLBACK
		q -301	
	}
	s ObjMap.CodeSystem = DTOMap.CodeSystem
	s ObjMap.GlossaryItemID = ObjGlossaryItem
	s ObjMap.TempID = DTOMap.TempID
	s ObjMap.TempDes = DTOMap.TempDes
	s ObjMap.DEVID = DTOMap.DEVID
	s ObjMap.DEVDes = DTOMap.DEVDes
	s ObjMap.DECVMID = DTOMap.DECVMID
	s sc = ObjMap.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}
	TCOMMIT
	q 1
}

/// desc 删除元素与数据元值域关联映射关系
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteMapJson(aID As %String)
{
	q:(aID="") -201
	TSTART
	s ObjMap = ##class(CF.EMR.DOC.GlossaryItemMap).%OpenId(aID)
	q:(ObjMap="") -102
	if '(ObjMap.%DeleteId(aID))
	{
		TROLLBACK
		q -101
	}	
	TCOMMIT
	q 1
}

/// desc 相同映射（值一致的元素与数据元值域映射）
ClassMethod AddMapByValueJson(aGlossaryID As %String, aEntifier As %String, aList As %DynamicArray)
{
	q:(aGlossaryID="") -201
	q:(aEntifier="") -202
	q:(aList="") -203
	s $zt = "Error"
	s DECVMID = ##Class(EMR.DOC.BL.DataElement).GetDevmIDByEntifier(aEntifier)
	q:(DECVMID="") -302
	s iter = aList.%GetIterator()
	s strRes = 1
	s flag = 1
	s break = ""
	TSTART
	while iter.%GetNext(.key , .item) {
		s ValueID = ..GetDataElementValue(item.value,aEntifier)
		s:(ValueID="-301") break = ValueID
		continue:ValueID="-301"
		s ObjValue = ##class(CF.EMR.DOC.DataElementValues).%OpenId(ValueID)
		continue:ObjValue=""
		s devid = ObjValue.DEVID
		s devValue = ObjValue.Meaning
		s DTOMap = ##class(EMR.DOC.DTO.GlossaryItemMap).%New()
		s DTOMap.GlossaryItemID = aGlossaryID
		s DTOMap.DEVID = devid
		s DTOMap.DEVDes = devValue
		s DTOMap.DECVMID = DECVMID
		s DTOMap.CodeSystem = item.codeSystem
		s DTOMap.TempID = item.code
		s DTOMap.TempDes = item.value
	    s strRes = ##Class(EMR.DOC.BL.GlossaryItemMap).AddMapJson(DTOMap)
	    if (strRes'=1)
		{
			s flag = 0
			TROLLBACK
			q
		}	
		    
		}
	q:(break'= "") break
	q:(flag'= 1) -101
	TCOMMIT
	q strRes
Error
	TROLLBACK
	q -100
}

/// desc 获取数据元值域值与元素值相同的项
ClassMethod GetDataElementValue(aValue As %String, aEntifier As %String)
{
	q:(aValue="") ""
	q:(aEntifier="") ""
	s DataElementID  = $O(^CF.EMR.DOC.DataElementI("IdxEntifier"," "_aEntifier,""))
	q:DataElementID="" -301
	s ObjDataElement = ##class(CF.EMR.DOC.DataElement).%OpenId(DataElementID)
	q:ObjDataElement="" -301
	s DECVMID = ObjDataElement.DEVID
	s ValueID = ""
	&SQL(SELECT ID into :ValueID FROM CF_EMR_DOC.DataElementValues WHERE DECVMID = :DECVMID AND Meaning = :aValue)
	q:(ValueID = "") -301
	q ValueID
}

/// desc 获取数据元值域值中与指定值相等的项
/// desc 获取全部用户
Query GetValue(DECVMID As %String, Meaning As %String) As %SQLQuery
{
	SELECT ID FROM CF_EMR_DOC.DataElementValues WHERE DECVMID = :DECVMID AND Meaning = :Meaning
}

}
