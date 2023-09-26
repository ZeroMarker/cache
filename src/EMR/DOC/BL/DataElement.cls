/// 名称:	EMR.DOC.BL.DataElement
/// 描述:	通用文档管理模块 Document(Doc) 数据元集数据元业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DataElement Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_DATAELEMENT_ITEM","params":{"internalID":"DE01.00.016.00","name":"会诊单编号1","description":"会诊单编号1","parentID":"1","dataType":"S1","format":"AN..18","devid":"CV02.01.104"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddDataElement(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.DataElement).%New()
	s argDTO.Entifier = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Definition = argInJson.params.description
	s argDTO.Category =argInJson.params.parentID
	s argDTO.DataType = argInJson.params.dataType
	s argDTO.Format = argInJson.params.format
	s argDTO.DEVID = argInJson.params.devid
    s strRes = ##Class(EMR.DOC.BL.DataElement).AddDataElementJson(argDTO)
    //失败:-100 添加失败,-101 更新目录子节点数失败， -200 目录ID不能为空，-201 内部标识符不能为空，-202 数据类型不能为空，-203 数据元允许值标识符有误,-204 数据格式不能为空, -300 未查到目录， -400 内部标识符已存在
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","更新目录子节点数失败",2)	
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内部标识符不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据类型不能为空",2)	
	}
	elseif (strRes = "-203")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据元允许值标识符有误",2)	
	}
	elseif (strRes = "-204")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据格式不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内部标识符已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_DATAELEMENT_ITEM","params":{"id":"1424","internalID":"DE01.00.016.00","name":"会诊单编号2","description":"会诊单编号2","parentID":"1","dataType":"S1","format":"AN..18","devid":"CV02.01.104"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpDataElement(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.DataElement).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.Entifier = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Definition = argInJson.params.description
	s argDTO.Category =..GetIDByKey(argInJson.params.parentId)
	s argDTO.DataType = argInJson.params.dataType
	s argDTO.Format = argInJson.params.format
	s argDTO.DEVID = argInJson.params.devID
    s strRes = ##Class(EMR.DOC.BL.DataElement).UpDataElementJson(argDTO)
    //失败:-100 更新失败, -200 ID不能为空，-201 内部标识符不能为空，-202 目录ID不能为空，-203 数据元允许值标识符有误,-204 数据格式不能为空,-205 数据类型不能为空, -300 未查到目录, -400 内部标识符已存在
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)	
	}
	elseif (strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","内部标识符不能为空",2)	
	}
	elseif (strRes = "-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-203")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据元允许值标识符有误",2)	
	}
	elseif (strRes = "-204")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据格式不能为空",2)	
	}
	elseif (strRes = "-205")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据类型不能为空",2)	
	}
	elseif (strRes = "-300")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)	
	}
	elseif (strRes = "-400")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","内部标识符已存在",2)	
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_DATAELEMENT_ITEM","params":{"id":1424},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelDataElement(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.DataElement).DelDataElementJson(strID)
    d argOutData.Write(strRes)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到数据元
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到数据元","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据目录获取数据元
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Debug:      s argOutData = ##Class(%DynamicArray).%New() 
/// 	     q ##Class(EMR.DOC.BL.DataElement).GetDataElementByPID(1,argOutData)
ClassMethod GetDataElementByPID(aParentId As %String, aPInternalID As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowSID = ""
	for {
		s rowSID = $o(^CF.EMR.DOC.DataElementI("IdxCategory",aParentId,rowSID))
		q:(rowSID = "")				
		s objDataElement = ##Class(CF.EMR.DOC.DataElement).%OpenId(rowSID)
	    continue:(objDataElement="")
	    s jsonDataElement  = ##class(%DynamicObject).%New()
	    s jsonDataElement.key = rowSID_"||IT"
	    s jsonDataElement.title = objDataElement.Name
	    s jsonDataElement.entifier = objDataElement.Entifier
	    s jsonDataElement.type = "IT"
	    s jsonDataElement.definition =objDataElement.Definition
	    s jsonDataElement.dataType = objDataElement.DataType
	    s jsonDataElement.format = objDataElement.Format
	    s jsonDataElement.devID = objDataElement.DEVID
	    S jsonDataElement.PInternalID = aPInternalID
		d jsonCategory.%Push(jsonDataElement)	
	}
	q res
}

/// Desc:       添加数据元目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 内部标识符不能为空，-202 数据类型不能为空，-203 数据元允许值标识符有误,-204 数据格式不能为空
/// 						  -300 未查到目录， -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.DataElement).AddDataElementJson()
ClassMethod AddDataElementJson(argDTO As EMR.DOC.DTO.DataElement) As %String
{
	s strRes ="-100"
	TSTART
	
	if (argDTO.Category = "")
	{
		TROLLBACK
		q "-200"
	} 
	if (argDTO.Entifier = "")
	{
		TROLLBACK
		q "-201"
	}
	if (argDTO.DataType = "")
	{
		TROLLBACK
		q "-202"
	}
	if (argDTO.Format = "")
	{
		TROLLBACK
		q "-204"
	}
	s argDTO.Versions ="1"
	s argDTO.RegOrgan = "卫生部卫生信息标准专业委员会"
	s argDTO.Environment = "卫生信息"
	s argDTO.ClassModle = "分类法"
	s argDTO.ResOrgan = "卫生部统计信息中心"
	s argDTO.State = "标准状态"
	s argDTO.PutInOrgan = "卫生部统计信息中心"
	s argDTO.CreateDate = $ZDATEH($ZDATE($h))
 	s argDTO.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s argDTO.LastModifyDate = $ZDATEH($ZDATE($h))
	s argDTO.LastModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	s obj = ##class(CF.EMR.DOC.DataElement).%New()
	s intCategoryID = +(argDTO.Category)
	s strEntifier = $zcvt(argDTO.Entifier,"U")
	s objCategory = ##class(CF.EMR.DOC.DataElementCategory).%OpenId(intCategoryID)
	if (intCategoryID'=0)&&(objCategory="")
	{
		TROLLBACK
		q "-300"
	}
	s obj.Category = objCategory
	if (argDTO.DEVID'="")
	{
		s devcRowID = $o(^CF.EMR.DOC.DEVCategoryI("IdxDECVMID"," "_$zcvt(argDTO.DEVID,"U"),""))
		if (devcRowID="")
		{
			TROLLBACK
			q "-203"
		}
		s obj.DEVID = argDTO.DEVID
	}
	s isHas = $o(^CF.EMR.DOC.DataElementI("IdxEntifier"," "_$zcvt(argDTO.Entifier,"U"),""))
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	} 
	
	s obj.Entifier = argDTO.Entifier
	s obj.Name = argDTO.Name
	s obj.Definition = argDTO.Definition
	s obj.DataType = argDTO.DataType
	s obj.DEVID = argDTO.DEVID
	s obj.Format = argDTO.Format
	s obj.Versions = argDTO.Versions
	s obj.RegOrgan = argDTO.RegOrgan
	s obj.Environment = argDTO.Environment
	s obj.ClassModle = argDTO.ClassModle
	s obj.ResOrgan = argDTO.ResOrgan
	s obj.State = argDTO.State
	s obj.PutInOrgan = argDTO.PutInOrgan
	s obj.CreateDate = argDTO.CreateDate
	s obj.CreateTime = argDTO.CreateTime
	s obj.LastModifyDate = argDTO.LastModifyDate
	s obj.LastModifyTime = argDTO.LastModifyTime
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		q obj.%Id()
	}
	else
	{
		TROLLBACK
		 q strRes
	}
}

/// Desc:       更新目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 内部标识符不能为空，-202 目录ID不能为空，-203 数据元允许值标识符有误,-204 数据格式不能为空,-205 数据类型不能为空
/// 						  -300 未查到目录, -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.DataElement).UpBDMCategoryJson()
ClassMethod UpDataElementJson(argDTO As EMR.DOC.DTO.DataElement) As %String
{
	s strRes = "-100"
	TSTART
	if (argDTO.ID="")
	{
		TROLLBACK
		q "-200"
	} 
	if (argDTO.Entifier = "")
	{
		TROLLBACK
		q "-201"
	}
	if (argDTO.DataType = "")
	{
		TROLLBACK
		q "-205"
	}
	if (argDTO.Format = "")
	{
		TROLLBACK
		q "-204"
	}
	s argDTO.LastModifyDate = $ZDATEH($ZDATE($h))
	s argDTO.LastModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	s obj = ##class(CF.EMR.DOC.DataElement).%OpenId(argDTO.ID)
	if (obj="")
	{
		TROLLBACK
		q "-200"
	} 
	s intCategoryID = +(argDTO.Category)
	s strEntifier = $zcvt(argDTO.Entifier,"U")
	if ((intCategoryID>0)&&(intCategoryID'=obj.Category.%Id())){
		s objCategory = ##class(CF.EMR.DOC.DataElementCategory).%OpenId(intCategoryID)
		s obj.Category = objCategory
	}else{
		s intCategoryID = obj.Category.%Id()
	}
	if (argDTO.DEVID'="")
	{
		s devcRowID = $o(^CF.EMR.DOC.DEVCategoryI("IdxDECVMID"," "_$zcvt(argDTO.DEVID,"U"),""))
		if (devcRowID="")
		{
			TROLLBACK
			q "-203"
		}
		s obj.DEVID = argDTO.DEVID
	}
	s isHas = $o(^CF.EMR.DOC.DataElementI("IdxEntifier"," "_$zcvt(argDTO.Entifier,"U"),""))
	if (isHas'="")&&(isHas'=argDTO.ID)
	{
		TROLLBACK
		q "-400"
	} 
	s obj.Entifier = argDTO.Entifier
	s obj.Name = argDTO.Name
	s obj.Definition = argDTO.Definition
	s obj.DataType = argDTO.DataType
	s obj.DEVID = argDTO.DEVID
	s obj.Format = argDTO.Format
	s obj.LastModifyDate = argDTO.LastModifyDate
	s obj.LastModifyTime = argDTO.LastModifyTime
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		q obj.%Id()
	}
	else
	{
		TROLLBACK
		 q strRes
	}
}

/// Desc:       删除数据元目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到数据元,-301 更新目录子节点数失败	,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.DataElement).DelBDMCategoryJson("1")
ClassMethod DelDataElementJson(aID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (aID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.DataElement).%OpenId(aID)
	if (obj="")  
	{
		TROLLBACK
		q "-300"
	}
	s sc = ##class(CF.EMR.DOC.DataElement).%DeleteId(aID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

/// desc 根据数据元标识符获取数据元的允许值
/// debug  w ##Class(EMR.DOC.BL.DataElement).GetDevmIDByEntifier()
ClassMethod GetDevmIDByEntifier(aEntifier As %String)
{
	q:aEntifier="" ""
	s DataElementID  = $O(^CF.EMR.DOC.DataElementI("IdxEntifier"," "_aEntifier,""))
	q:DataElementID="" -301
	s ObjDataElement = ##class(CF.EMR.DOC.DataElement).%OpenId(DataElementID)
	q:ObjDataElement="" -301
	s aDevID = ObjDataElement.DEVID
	q aDevID
}

}
