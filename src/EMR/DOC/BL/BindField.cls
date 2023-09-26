/// 名称:	EMR.DOC.BL.BindField
/// 描述:	通用文档管理模块 Document(Doc) 数据元业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindField Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据数据集ID获取数据元（TABLE）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数{"action":"GET_BINDFIELD_DATA","params":{"bindQuery":"1","current":4,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataFieldTableByID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataType = argInJson.params.dataType
	s BindQueryID = argInJson.params.bindQuery
	s current = argInJson.params.current
    s pageSize = argInJson.params.pageSize 
    s name = argInJson.params.name
    s code = argInJson.params.code
    if ($ZCVT(DataType="TREE","U")){
		s strRes = ##Class(EMR.DOC.BL.BindField).GetDataTreeFieldByIDJson(BindQueryID,.argOutData,current,pageSize)
	}else{
		s strRes = ##Class(EMR.DOC.BL.BindField).GetDataFieldByIDJson(BindQueryID,.argOutData,current,pageSize,name,code)
	}
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集ID未传",2)
	}
	elseif(strRes="-301"){
		q ..SetOutMessage(argOutMessage,"ERROR","数据集记录不存在，检查参数",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       根据数据集ID获取数据元（TREE）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数{"action":"GET_BINDFIELD_DATA","params":{"bindQuery":"1","current":4,"pageSize":20},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataTreeFieldTableByID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s BindQueryID = argInJson.params.bindQuery
    s strRes = ##Class(EMR.DOC.BL.BindField).GetDataTreeFieldByIDJson(BindQueryID,.argOutData,current,pageSize)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集ID未传",2)
	}
	elseif(strRes="-301"){
		q ..SetOutMessage(argOutMessage,"ERROR","数据集记录不存在，检查参数",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       添加数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"ADD_DATA_FIELD","params":{ "bindQueryId":"18","code":"HDSD00.02.040","name":"EpisodeID[字符]", "description":"患者就诊号","bindFiled":"EpisodeID","valueType":"Text"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDataField(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoBindFiled = ##class(EMR.DOC.DTO.BindField).%New()
	s dtoBindFiled.BindQuery = argInJson.params.bindQueryId
	s dtoBindFiled.Code = argInJson.params.code
	s dtoBindFiled.Name = argInJson.params.name
	s dtoBindFiled.Description = argInJson.params.description
	s dtoBindFiled.BindFiled = argInJson.params.bindFiled
	s dtoBindFiled.ValueType = argInJson.params.valueType
    s strRes = ##Class(EMR.DOC.BL.BindField).AddDataFieldJson(dtoBindFiled,.argOutData)
	if (strRes > 0)
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-102")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
	elseif(strRes="-200")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","绑定数据集存在，检查参数",2)
	}
	elseif(strRes="-302")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","绑定值类型不存在，检查参数",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_DATA_FIELD","params":{"id":"480","code":"HDSD00.02.040","name":"EpisodeID[字符]更新","description":"患者就诊号","bindFiled":"EpisodeID","valueType":"Text"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpDataField(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoBindFiled = ##class(EMR.DOC.DTO.BindField).%New()
	s dtoBindFiled.ID = argInJson.params.id
	s dtoBindFiled.BindQuery = argInJson.params.bindQueryId
	s dtoBindFiled.Code = argInJson.params.code
	s dtoBindFiled.Name = argInJson.params.name
	s dtoBindFiled.Description = argInJson.params.description
	s dtoBindFiled.BindFiled = argInJson.params.bindFiled
	s dtoBindFiled.ValueType = argInJson.params.valueType
    s strRes = ##Class(EMR.DOC.BL.BindField).UpDataFieldJson(dtoBindFiled,.argOutData)
	if (strRes = 1)
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-102")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
	elseif(strRes="-200")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","绑定数据集存在，检查参数",2)
	}
	elseif(strRes="-302")	
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","绑定值类型不存在，检查参数",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"DEL_DATA_FIELD","params":{"id":"480"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DelDataField(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.BindField).DelDataFieldJson(ID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集不存在，检查入参",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据数据集ID获取数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aBindQueryID	数据集ID
/// OutPut:     argOutData 返回数据 成功 1 失败 -200 必填项
/// 											-301 数据集记录不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindField).GetDataFieldByIDJson("1",.argOutData)
ClassMethod GetDataFieldByIDJson(aBindQueryID As %String, ByRef argOutData As %GlobalBinaryStream, argCurrent As %String, argPageSize As %String, argName As %String, argCode As %String) As %String
{
	s strRes = "1"
	q:(aBindQueryID="") "-200"
	s objBindQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aBindQueryID)
	q:(objBindQuery="") "-301"
	s jsonRoot = ##class(%DynamicObject).%New()
    s jsonArr = ##class(%DynamicArray).%New()
    s:argCurrent="" argCurrent=..#DECURRENT
	s:argPageSize="" argPageSize=..#DEPAGESIZE
	if ((argCode'="")&(argName'="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.BindField:GetFieldByQueryByCodeAndName")
		d result.Execute(aBindQueryID,argCode,argName)
	}elseif((argCode="")&(argName="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.BindField:GetFieldByQuery")
		d result.Execute(aBindQueryID)
	}else{
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.BindField:GetFieldByQueryByCodeOrName")
		d result.Execute(aBindQueryID,argCode,argName)
	}
	q:(result = "") "-1" 
	s count = 0
	s startIndex = (argCurrent-1)*argPageSize+1
	s endIndex = startIndex+argPageSize-1
	While result.Next() 
	{
        s count=count+1
		continue:((count<startIndex)||(count>endIndex))
       	s jsonField  = ##class(%DynamicObject).%New()
	    s jsonField.id =result.GetDataByName("ID")
	    s jsonField.title=result.GetDataByName("Name")
	    s jsonField.key=result.GetDataByName("ID")
	    s jsonField.code =result.GetDataByName("Code")
	    s jsonField.name =result.GetDataByName("Name")
	    s jsonField.description = result.GetDataByName("Description")
	    s jsonField.bindFiled = result.GetDataByName("BindFiled")
	    s jsonField.valueType = result.GetDataByName("ValueType")
		d jsonArr.%Push(jsonField)
	}
	s jsonRoot.current = argCurrent
	s jsonRoot.pageSize = argPageSize
	s jsonRoot.total = count
	s jsonRoot.list = jsonArr

	d jsonRoot.%ToJSON(argOutData)

	q strRes
}

/// Desc:       添加数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  数据元对象
/// OutPut:     成功：数据元id  失败： -102 操作数据记录失败
/// 										-200 必填项校验（BindQuery，BindField，ValueType，name）
/// 										-301 数据集对象不存在  -302 绑定值类型不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindField).AddBindQueryDataJson("1","EMRDOC",argOutData)
ClassMethod AddDataFieldJson(aDTOItem As EMR.DOC.DTO.BindField, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")||(aDTOItem.Name="")||(aDTOItem.BindQuery="")||(aDTOItem.BindFiled="")||(aDTOItem.ValueType="")) "-200"
	s obj = ##class(CF.EMR.DOC.BindField).%New()
	s objBindQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aDTOItem.BindQuery)
	q:(objBindQuery="") "-301"
	s obj.BindQuery = objBindQuery
	
	s obj.Code = aDTOItem.Code
	s obj.Name = aDTOItem.Name
	s obj.Description = aDTOItem.Description
	s obj.BindFiled = aDTOItem.BindFiled
	s rowID = $o(^CF.EMR.DOC.BindValueTypesI("IdxProductCode",objBindQuery.Product.%Id()," "_$zcvt(aDTOItem.ValueType,"U"),""))
	q:(rowID= "") "-302"
	s objBindValueType = ##class(CF.EMR.DOC.BindValueTypes).%OpenId(rowID)
	s obj.ValueType = objBindValueType
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		q strRes
	}
	s strRes = obj.%Id()
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       更新数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  数据集对象
/// 			aParams 数据集入参
/// OutPut:     成功：1  失败： -102 操作数据记录失败
/// 							-200 必填项校验（id，BindQuery，BindField，ValueType，name）
/// 							-301 数据集对象不存在  -302 绑定值类型不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindField).UpBindQueryDataJson("1","EMRDOC",argOutData)
ClassMethod UpDataFieldJson(aDTOItem As EMR.DOC.DTO.BindField, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")||(aDTOItem.ID="")||(aDTOItem.Name="")||(aDTOItem.BindFiled="")||(aDTOItem.ValueType="")) "-200"

	s obj = ##class(CF.EMR.DOC.BindField).%OpenId(aDTOItem.ID)
	q:(obj = "") "-301"

	s obj.Code = aDTOItem.Code
	s obj.Name = aDTOItem.Name
	s obj.Description = aDTOItem.Description
	s obj.BindFiled = aDTOItem.BindFiled
	s strProductID = obj.BindQuery.Product.%Id()
	s rowID = $o(^CF.EMR.DOC.BindValueTypesI("IdxProductCode",strProductID," "_$zcvt(aDTOItem.ValueType,"U"),""))
	q:(rowID= "") "-302"
	s objBindValueType = ##class(CF.EMR.DOC.BindValueTypes).%OpenId(rowID)
	s obj.ValueType = objBindValueType
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		q strRes
	}
	s strRes = "1"
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       删除数据元
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aQueryID  数据集ID
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 						-200 必填项（id）未传
///                         -301 数据元对象不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindField).DelDataParameterValueJson("4",argOutData)
ClassMethod DelDataFieldJson(aID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes ="-102"
	if (aID ="")
	{
		q "-200"
	}
	s objBindField = ##class(CF.EMR.DOC.BindField).%OpenId(aID)
	if (objBindField ="")
	{
		q "-301"
	}
	if '(objBindField.%DeleteId(aID))
	{
		q strRes
	}
	s strRes = "1"
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       根据数据集ID获取数据元(TREE)
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aBindQueryID	数据集ID
/// OutPut:     argOutData 返回数据 成功 1 失败 -200 必填项
/// 											-301 数据集记录不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindField).GetDataFieldByIDJson("1",.argOutData)
ClassMethod GetDataTreeFieldByIDJson(aBindQueryID As %String, ByRef argOutData As %GlobalBinaryStream, argCurrent As %String, argPageSize As %String) As %String
{
	s strRes = "1"
	q:(aBindQueryID="") "-200"
	s objBindQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aBindQueryID)
	q:(objBindQuery="") "-301"
	s jsonRoot = ##class(%DynamicObject).%New()
	s jsonRoot.key = "root"
	s jsonRoot.title = objBindQuery.Name
	
    s jsonArr = ##class(%DynamicArray).%New()
 	s strFRowID = ""
	for {
		s strFRowID = $o(^CF.EMR.DOC.BindFieldI("IdxBindQuery",aBindQueryID,strFRowID))
		q:(strFRowID = "")			
		s objBindField = ##Class(CF.EMR.DOC.BindField).%OpenId(strFRowID)
        continue:(objBindField="")
       	s jsonField  = ##class(%DynamicObject).%New()
	    s jsonField.key =strFRowID
	    s jsonField.code =objBindField.Code
	    s jsonField.title =objBindField.Name
	    s jsonField.description = objBindField.Description
	    s jsonField.bindFiled = objBindField.BindFiled
	    s jsonField.valueType =$case(objBindField.ValueType,"":"",:objBindField.ValueType.Code)
	    s jsonField.type = "LF"
	   	s jsonField.sequence = strFRowID
		d jsonArr.%Push(jsonField)
	}
	s jsonRoot.children = jsonArr
	s result = ##class(%DynamicArray).%New()
	d result.%Push(jsonRoot)
	d result.%ToJSON(argOutData)
	q strRes
}

/// desc 根据数据集获取数据元  带Code 和 Name的双重过滤
/// 
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BindField","GetFieldByQueryByCodeAndName","","","")
Query GetFieldByQueryByCodeAndName(Query As %String, Code As %String, Name As %String) As %SQLQuery
{
	SELECT a.ID,a.BindFiled,a.BindQuery,a.Code,a.Description,a.Name,b.Code AS ValueType from CF_EMR_DOC.BindField a inner JOIN CF_EMR_DOC.BindValueTypes b ON a.ValueType = b.ID WHERE BindQuery =:Query  AND a.Code like "%"_:Code_"%" AND a.Name like"%"_:Name_"%"
}

/// desc 根据数据集获取数据元  带Code 和 Name的单条件过滤
/// 
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BindField","GetFieldByQueryByCodeOrName","31","")
Query GetFieldByQueryByCodeOrName(Query As %String, Code As %String, Name As %String) As %SQLQuery
{
	SELECT a.ID,a.BindFiled,a.BindQuery,a.Code,a.Description,a.Name,b.Code AS ValueType from CF_EMR_DOC.BindField a inner JOIN CF_EMR_DOC.BindValueTypes b ON a.ValueType = b.ID WHERE BindQuery =:Query  AND (a.Code like "%"_:Code_"%" OR a.Name like"%"_:Name_"%")
}

/// desc 根据数据集获取数据元  不带过滤条件
/// 
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BindField","GetFieldByQuery","","")
Query GetFieldByQuery(Query As %String) As %SQLQuery
{
	SELECT a.ID,a.BindFiled,a.BindQuery,a.Code,a.Description,a.Name,b.Code AS ValueType from CF_EMR_DOC.BindField a inner JOIN CF_EMR_DOC.BindValueTypes b ON a.ValueType = b.ID WHERE BindQuery =:Query
}

}
