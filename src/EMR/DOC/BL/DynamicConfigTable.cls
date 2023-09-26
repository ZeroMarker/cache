/// 名称:	EMR.DOC.BL.DynamicConfigTable
/// 描述:	公用字典：术语集文档元素值域关联业务类
/// 编写者：yejian
/// 编写日期: 2021-5-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DynamicConfigTable Extends EMR.DOC.COM.ActionBase [ ProcedureBlock ]
{

/// Desc:       添加表结构到配置表中
/// Creator:    zhangzheyi
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "Add_DYNAMIC_CONFIG","params":{"tablename":"EMRmeta.DynamicConfigTable"，"configname":"资源配置表","product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDynamicConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s aTabName = argInJson.params.tablename
	s aConfigName = argInJson.params.configname
	if (aTabName = "")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","表名必传",2)
	}
	if (aConfigName = "")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置名必传",2)
	}
	s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).AddDynamicConfigtable(aTabName,aConfigName)
	// OutPut:     成功 1 失败  -200无此表  -201 表名 -202 配置名 -203 属性字段  -101 保存数据出错 
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存数据出错",2)
	}
	elseif (strRes = -200)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","查不到此表格",2)	
	}
	elseif (strRes = -201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","表名不能为空，检查参数id",2)	
	}
	elseif (strRes = -202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","配置名为空",2)	
	}
	elseif (strRes = -203)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","表格属性字段为空",2)	
	}
	elseif (strRes = -204)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","配置表名重复",2)	
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 添加配置表
ClassMethod AddDynamicConfigtable(aTabName As %String, aConfigName As %String)
{
	
	s result = ""
	s obj=##Class(%Dictionary.CompiledClass).%OpenId(aTabName)
	if obj=""
	{
		   q -200
	}
	&SQL(SELECT ID into :ValueID FROM CF_EMR_DOC.DynamicConfigTable WHERE ConfigName = :aTabName)
	q:(ValueID'= "") -204	
	s stres = ##class(CF.EMR.DOC.DynamicConfigTable).%OpenId()
	s DTOMap = ##class(EMR.DOC.DTO.DynamicConfigTable).%New()
	s DTOMap.ClassName = aTabName
	s DTOMap.TableName = aTabName
	s DTOMap.ConfigName = aConfigName
	s DTOMap.Fields = ""
	s cnt=obj.Properties.Count()
	f i=1:1:cnt 
	{
		s pdef=obj.Properties.GetAt(i) 
		s PropertyName=pdef.Name
		s item = ""
		   i (PropertyName'="%Concurrency") && (PropertyName'="%IsInSave") && (pdef.Private'=1)		
		   {
	            s item = ..FilterIlleaglChar(pdef.Name)
	            if (result '= "")
	            {
		           s result = result_","_item
	            }
	            else 
	            {
	               s result = item 
	            }
		    }
		}
	s DTOMap.Fields = result
	;s result = "{""TableName"":"""_obj.SqlSchemaName_"."_obj.SqlTableName_""",""Properties"":["_result_"]}"
    d obj.%Close()
	s stres = ..AddDynamicConfigJson(DTOMap)
	q:(stres'= 1) stres
	q 1
}

/// Desc:       添加配置表
/// Creator:    zhangzheyi
/// CreateDate: 2021-06-22
/// Input:      DTOMap 元素值域映射对象
/// OutPut:     成功 1 失败  -201 表名 -202 配置名 -203 属性字段  -101 保存数据出错                         
/// Debug:      
ClassMethod AddDynamicConfigJson(DTOMap As EMR.DOC.DTO.DynamicConfigTable)
{
	q:(DTOMap.ClassName="") -201
	q:(DTOMap.TableName="") -201
	q:(DTOMap.ConfigName="") -202
	q:(DTOMap.Fields="") -203
	TSTART
	s ObjMap = ##class(CF.EMR.DOC.DynamicConfigTable).%New()
	s ObjMap.ClassName = DTOMap.ClassName
	s ObjMap.TableName = DTOMap.TableName
	s ObjMap.ConfigName = DTOMap.ConfigName
	s ObjMap.Fields = DTOMap.Fields
	s sc = ObjMap.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}
	TCOMMIT
	q 1
}

/// Desc:       获取数据表表名
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_DYNAMIC_CONFIGTABLE","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDynamicConfigTable(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).GetDynamicConfigTableJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取数据表表名
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod GetDynamicConfigTableJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s TableArry = ##class(%ResultSet).%New("EMR.DOC.BL.DynamicConfigTable:GetTableName")
	d TableArry.Execute()
	q:(TableArry= "") -1
	while TableArry.Next()
	{
		s jsonItem  = ##class(%DynamicObject).%New()
        s jsonItem.value = TableArry.GetDataByName("ID")
        s jsonItem.label = TableArry.GetDataByName("ClassName")
		d jsonArr.%Push(jsonItem)
	}
	
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// desc 获取数据表表名（去重）
/// desc 获取全部用户
Query GetTableName() As %SQLQuery
{
		
	SELECT * FROM CF_EMR_DOC.DynamicConfigTable GROUP BY TableName
}

/// Desc:       获取配置表表名
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_DYNAMIC_CONFIGNAME","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDynamicConfigName(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s aTableName = argInJson.params.name
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).GetDynamicConfigNameJson(aTableName,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取配置表表名
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod GetDynamicConfigNameJson(aTableName As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s TableArry = ##class(%ResultSet).%New("EMR.DOC.BL.DynamicConfigTable:GetTableConfigName")
	d TableArry.Execute(aTableName)
	q:(TableArry= "") -1
	while TableArry.Next()
	{
		s jsonItem  = ##class(%DynamicObject).%New()
		s jsonItem.key = TableArry.GetDataByName("ID")
        s jsonItem.value = TableArry.GetDataByName("ID")
        s jsonItem.label = TableArry.GetDataByName("ConfigName")
		d jsonArr.%Push(jsonItem)
	}
	
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// desc 获取配置表表名（去重）
/// desc 获取全部用户
Query GetTableConfigName(TableName As %String) As %SQLQuery
{
	SELECT * FROM CF_EMR_DOC.DynamicConfigTable WHERE TableName = :TableName
}

/// Desc:       根据表名和配置名得到类的属性,类名对大小写敏感
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_CLASS_PROPERTIES","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetClassProperties(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s aTableName = argInJson.params.tablename
	s aConfigId= argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).GetClassPropertiesJson(aTableName,aConfigId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","表格名不能未空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表名不能未空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据表名和配置名得到类的属性,类名对大小写敏感
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod GetClassPropertiesJson(aTableName As %String, aConfigId As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
		
		q:(aTableName= "") -101
		q:(aConfigId= "") -102
		s strRes = "1"
		s obj=##Class(%Dictionary.CompiledClass).%OpenId(aTableName)
		if obj=""
		{
		    q ""
		}
		s jsonObj  = ##class(%DynamicObject).%New()
		s jsonObj.TableName = aTableName
		
		s objEntry = ..MapClassProperties(aConfigId)
		if ( objEntry = -1)
		{ 
	     s objEntry = ""
		}
		s jsonObj.ConfigName = objEntry.ConfigName
		s jsonObj.keys = objEntry.Fields
		
		s jsonArr = ##class(%DynamicArray).%New()		
		s cnt=obj.Properties.Count()
		f i=1:1:cnt 
		{
			s pdef=obj.Properties.GetAt(i) 
		    s PropertyName=pdef.Name
		    ;s item = ""
		    s jsonItem  = ##class(%DynamicObject).%New()
		    i (PropertyName'="%Concurrency") && (PropertyName'="%IsInSave") && (pdef.Private'=1)		
		    {
		        s isRequired = "否"
		        if (pdef.Required = 1) 
		        {
			        s isRequired = "是"
			    }
			    s jsonItem.key = i
			    s jsonItem.name = ..FilterIlleaglChar(pdef.Name)
			    s jsonItem.pType = pdef.Type
			    s jsonItem.SqlFieldName = pdef.SqlFieldName
			    s jsonItem.isRequired = isRequired
			    s jsonItem.defaultValue = ""
			    s jsonItem.desc = ..FilterIlleaglChar(pdef.Description)
		        d jsonArr.%Push(jsonItem)	 
		    }
		}
		s jsonObj.list = jsonArr
        d obj.%Close()
        d jsonObj.%ToJSON(argOutData)
		q strRes
}

/// Desc:       根据表格名和配置表名查询Fields
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod MapClassProperties(aConfigId As %String) As %String
{
	q:aConfigId="" -1
    s objEntry = ##Class(CF.EMR.DOC.DynamicConfigTable).%OpenId(aConfigId)
    q:objEntry="" -1
    q objEntry
}

/// Desc:       更新配置表Flelds字段
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_CLASS_PROPERTIES","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateClassProperties(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s aConfigId= argInJson.params.id
	s FieldName= argInJson.params.FieldName
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).UpdateClassPropertiesJson(FieldName,aConfigId,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","字段名不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","无此配置表",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新配置表Fileds字段
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateClassPropertiesJson(FieldName As %String, aConfigId As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
		
		q:(FieldName= "") -101
		q:(aConfigId= "") -102
		s strRes = "1"
		s Obj = ##Class(CF.EMR.DOC.DynamicConfigTable).%OpenId(aConfigId)
		if ( 'Obj )
		{ 
	     q -103
		}
		s Obj.Fields = FieldName
		s sc = Obj.%Save()
		if ('$$$ISOK(sc))
		{
			q -104
		}
		q 1
}

/// Desc:       获取所有配置表
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_ALLCLASS_PROPERTIES","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllClassProperties(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).GetAllClassPropertiesJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取所有配置表
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod GetAllClassPropertiesJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s TableArry = ##class(%ResultSet).%New("EMR.DOC.BL.DynamicConfigTable:GetAllClassPropertiesName")
	d TableArry.Execute()
	q:(TableArry= "") -1
	while TableArry.Next()
	{
		s jsonItem  = ##class(%DynamicObject).%New()
        s jsonItem.value = TableArry.GetDataByName("ID")
        s jsonItem.label = TableArry.GetDataByName("ConfigName")
        s jsonItem.className = TableArry.GetDataByName("ClassName")
		d jsonArr.%Push(jsonItem)
	}
	
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取配置表和字段数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"GET_CLASS_PROPERTIESDATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetClassPropertiesData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s aConfigId= argInJson.params.id
	s className= argInJson.params.className
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).GetClassPropertiesDataJson(aConfigId,className,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表名不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","数据表查询失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取配置表和字段数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod GetClassPropertiesDataJson(aConfigId As %String, className As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	q:(aConfigId= "") -101
	q:(className= "") -102
	s objEntry = ##Class(CF.EMR.DOC.DynamicConfigTable).%OpenId(aConfigId)
	if ( 'objEntry )
	{ 
	    q 103
	}
	s data = ..QueryDynTable(className)
	if ('data) 
	{
		q 104
	}
	
	s rowID = ""	
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s TableArry =  data		
	q:(TableArry= "") -1
	
	s element = objEntry.Fields
	s count = 1
	s elementAryy = ##class(%DynamicArray).%New()
	for
		{
			s fieldname = $P(element,",",count)
			q:(fieldname = "")
			s count = count + 1
			d elementAryy.%Push(fieldname)
			
		}
	
	s step = 1
	while TableArry.Next()
	{	
		s num = 1
		s json = "{"
		for
		{
			s name = $P(element,",",num)
			q:(name = "")
			s num = num + 1
			s nameValue = ""_TableArry.GetDataByName(name)
			s nameValue = $CASE(nameValue,"":" ",:nameValue)
			s cmdLetValue=  """"_name_""":"""_nameValue_""", "
			s json = json_cmdLetValue	
		}
		s id = ""_TableArry.GetDataByName("ID")
		s json = json_"""id"""_":"""_id_""","
		s json = json_"""key"""_":"""_id_""""
		s json = json_"}"
		s step = step + 1
		s jsonItem = ##class(%DynamicObject).%FromJSON(json)
		d jsonArr.%Push(jsonItem)
	}
	s jsonObj  = ##class(%DynamicObject).%New()
	s jsonObj.list = jsonArr
	s jsonObj.Fields = elementAryy
	d jsonObj.%ToJSON(argOutData)
	q strRes
}

/// desc 获取查询数据表数据
ClassMethod QueryDynTable(TableName As %String) As %XML.DataSet
{
 	s dataset = ##Class(%XML.DataSet).%New("%DynamicQuery:SQL")
 	s sql = "SELECT * FROM "_TableName
	s status=dataset.Prepare(sql)
	d dataset.Execute()
	if $$$ISERR(status) { q "" }
    q dataset
}

/// Desc:       更新配置表所属数据表的数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_CLASS_PROPERTIESDATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateClassPropertiesData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s aConfigId= argInJson.params.id
	s tableId= argInJson.params.tableId
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).UpdateClassPropertiesDataJson(aConfigId,tableId,argInJson,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表id不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新配置表所属数据表的数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:    
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateClassPropertiesDataJson(aConfigId As %String, tableId As %String, argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aConfigId= "") -101
	q:(tableId= "") -102
	s dataList= argInJson.params.list
	
	s objEntry = ##Class(CF.EMR.DOC.DynamicConfigTable).%OpenId(tableId)
	if ('objEntry)
		{
		q 103
		}
	s className = objEntry.ClassName
	s fileds = objEntry.Fields
	
	s split = "@@"
	s cmdCreateCls="objCompRegistered=##class("_className_").%OpenId("""_aConfigId_""")"
    s @cmdCreateCls
 
	s count = 1
	s iter = dataList.%GetIterator()
	while iter.%GetNext(.key , .item) {
		s value = item
		s:(value = " ") value = ""
		s property = $P(fileds,",",count)
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		b
		s @cmdLetValue
		s count = count + 1	     
	}
	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	
	s cmdClose="objCompRegistered.%Close()"
	d @cmdClose 
	q 1
}

/// Desc:        删除指定记录
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:     命令参数 {"Action":"DELETE_CLASS_PROPERTIESDATA","params":"","product":"GlobalEMR"}, 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteClassPropertiesData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s tableId= argInJson.params.tableId
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).DeleteClassPropertiesDataJson(tableId,argInJson,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Description:  删除指定记录
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:   	命令参数 {"Action":"DELETE_CLASS_PROPERTIESDATA","params":"","product":"GlobalEMR"},  
/// OutPut:     argOutData 返回数据
/// Debug:      d ##class(EMRservice.BL.BLDynamicConfigTable).DelRecord("EPRmeta.SysOption", "70")
ClassMethod DeleteClassPropertiesDataJson(tableId As %String, argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	;q:ClassName=""
	;q:ID=""
	q:tableId="" -101   
	s dataList= argInJson.params.list
	
	s objEntry = ##Class(CF.EMR.DOC.DynamicConfigTable).%OpenId(tableId)
	if ('objEntry)
		{
		q 102
		}
	s ClassName = objEntry.ClassName
	
	s iter = dataList.%GetIterator()
	while iter.%GetNext(.key , .item) {
		s kye = item.key
		s cmdDel="##class("_ClassName_").%DeleteId("_kye_")"
		d @cmdDel
	}
	q 1
	///w $ZOBJCLASSMETHOD(ClassName,"%DeleteId",ID)
}

/// Desc:       添加配置表所属数据表的数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_CLASS_PROPERTIESDATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddClassPropertiesData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s tableId= argInJson.params.tableId
    s strRes = ##Class(EMR.DOC.BL.DynamicConfigTable).AddClassPropertiesDataJson(tableId,argInJson,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","id不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表id不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","配置表不存在",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Description:   添加配置表所属数据表的数据
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddClassPropertiesDataJson(tableId As %String, argInJson As %DynamicAbstractObject, Properties As %String) As %String
{
	
	q:(tableId= "") -101
	s dataList= argInJson.params.list
	
	s objEntry = ##Class(CF.EMR.DOC.DynamicConfigTable).%OpenId(tableId)
	if ('objEntry)
		{
		q 103
		}
	s ClassName = objEntry.ClassName
	s fileds = objEntry.Fields
	
	
	
	
	s split = "@@"
	s cmdCreateCls="objCompRegistered=##class("_ClassName_").%New()"
    s @cmdCreateCls
    
    s count = 1
	s iter = dataList.%GetIterator()
	while iter.%GetNext(.key , .item) {
		s value = item
		s property = $P(fileds,",",count)
		s cmdLetValue="objCompRegistered."_property_"="""_value_""""
		s @cmdLetValue
		s count = count + 1	     
	}

	s cmdSave="objCompRegistered.%Save()"
	d @cmdSave	
	
	s cmdClose="objCompRegistered.%Close()"
	d @cmdClose 
	q 1
}

/// desc 获取所有配置表名
Query GetAllClassPropertiesName() As %SQLQuery
{
	SELECT * FROM CF_EMR_DOC.DynamicConfigTable
}

/// desc 获取全部用户
Query GetClassPropertiesFields(TableName As %String, ConfigName As %String) As %SQLQuery
{
	
	SELECT * FROM CF_EMR_DOC.DynamicConfigTable WHERE TableName = :TableName AND ConfigName =:ConfigName
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	s txt = $tr(txt,"""","\""")
	q txt
}

}
