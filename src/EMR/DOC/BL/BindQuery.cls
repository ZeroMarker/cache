/// 名称:	EMR.DOC.BL.BindQuery
/// 描述:	通用文档管理模块 Document(Doc) 数据集业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindQuery Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据用户Code获取数据集目录树
/// Creator:    duan
/// CreateDate: 2021-04-14
/// Input:      argArray  命令参数 {"action":"GET_BINDQUERY_DATA","params":{"userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindQueryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId    
	s strRes = ##Class(EMR.DOC.BL.BindQuery).GetBindQueryJson(UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="-101")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif (strRes="-102")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	elseif (strRes="-103")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未授权项目标识",2)
	}
	elseif (strRes="-201")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","请输入用户Code",2)
	}
	else
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取数据绑定tree
/// Creator:    duan
/// CreateDate: 2021-04-14
/// Input:      argArray  命令参数 {"action":"GET_BINDTREE_DATA","params":{"userCode":"YS01","role":"PersonalTemplate"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindTreeData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s role = argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.BindQuery).GetBindTreeJson(UserCode,role,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="-101")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif (strRes="-102")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	elseif (strRes="-103")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未授权项目标识",2)
	}
	elseif (strRes="-201")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","请输入用户Code",2)
	}
	else
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据用户Code获取数据集操作数据
/// Creator:    duan
/// CreateDate: 2021-04-14
/// Input:      argArray  命令参数 {"action":"GET_BINDQUERY_OPERATION","params":{"userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindQueryOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s ParentCode = "MENU_DOC_BIND"
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.BindQuery).GetBindQueryOperationJson(ParentCode,UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif(strRes="-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","用户没有关联角色，请先授权",2)	
	}
	elseif(strRes="-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档管理操作数据为空,检查数据源",2)	
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据用户Code获取数据集Table
/// Creator:    duan
/// CreateDate: 2021-04-14
/// Input:      argArray  命令参数 {"action":"GET_BINDQUERY_TABLE","params":{"userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindQueryDataByProduct(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product = argInJson.params.product
	s current = argInJson.params.current
	s pageSize = argInJson.params.pageSize
	s name = argInJson.params.name
	s code = argInJson.params.code
    s strRes = ##Class(EMR.DOC.BL.BindQuery).GetBindQueryJsonByProduct(product,argOutData,current,pageSize,name,code)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="-200")
	{  
	 	d argOutData.Clear()
	    q ..SetOutMessage(argOutMessage,"ERROR","product参数未传",2)
	}
	elseif (strRes="-102")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	elseif (strRes="-103")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未授权项目标识",2)
	}
	elseif (strRes="-201")
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","请输入用户Code",2)
	}
	else
	{  
	 	d argOutData.Write("-1")
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据项目标识获取数据集目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_DATA_TREE","args":{"ProductCode":"DOC"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBindDataTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode = argInJson.params.productCode
	s DataJsonObj = ##class(%DynamicObject).%New()
    s strRes = ##Class(EMR.DOC.BL.BindQuery).GetDataParameterValuesJson(ProductCode,.DataJsonObj)
	if (strRes = "1")
	{ 
		d DataJsonObj.%ToJSON(argOutData)
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

/// Desc:       添加数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action": "ADD_BINDQUERY_DATA","params": {"productCode": "OEP","code": "","name": "添加数据集测试","description": "添加数据集测试","queryName": "EMR.DOC.HISInterface.SystemData:GetFirstPageInfoNew","bindType": "Query","param": [{"code": "EpisodeID"}]},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddBindQueryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoBindQuery = ##class(EMR.DOC.DTO.BindQuery).%New()
	s dtoBindQuery.Product = argInJson.params.productCode
	s dtoBindQuery.Code = argInJson.params.code
	s dtoBindQuery.Name = argInJson.params.name
	s dtoBindQuery.Description = argInJson.params.description
	s dtoBindQuery.QueryName = argInJson.params.queryName
	s dtoBindQuery.BindType = argInJson.params.bindType
	s strParam = argInJson.params.param
    s strRes = ##Class(EMR.DOC.BL.BindQuery).AddBindQueryDataJson(dtoBindQuery,strParam,.argOutData)
	if (strRes >0)
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","查询类已存在，不需要创建",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据操作失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目标识不存在，检查参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","查询方法不存在，检查参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_BINDQUERY_DATA","params":{ "id":"16","code": "","name": "添加数据集测试[更新]","description": "添加数据集测试","queryName": "EMR.DOC.BL.RBACUser:SelectRBACUserss","bindType": "Query","param": [{"code": "EpisodeID"}]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpBindQueryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoBindQuery = ##class(EMR.DOC.DTO.BindQuery).%New()
	s dtoBindQuery.ID = argInJson.params.id
	s dtoBindQuery.Code = argInJson.params.code
	s dtoBindQuery.Name = argInJson.params.name
	s dtoBindQuery.Description = argInJson.params.description
	s dtoBindQuery.ReturnMuch=argInJson.params.returnmuch
	s dtoBindQuery.QueryName = argInJson.params.queryName
	s dtoBindQuery.BindType = argInJson.params.bindType
	s strParam = argInJson.params.param
    s strRes = ##Class(EMR.DOC.BL.BindQuery).UpBindQueryDataJson(dtoBindQuery,strParam,.argOutData)
	if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","查询类已存在，不能重复创建",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据操作失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集不存在，检查Id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","查询方法不存在，检查参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"DEL_BINDQUERY_DATA","params":{"id":"17"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DelBindQueryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.BindQuery).DelBindQueryDataJson(ID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集ID未传",2)
	}
	elseif(strRes = "-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集记录不存在，检查参数",2)
	}
	elseif(strRes = "-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集下存在数据元，不允许删除",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取数据集、数据元编码是否存在（Type：BindQuery 数据集，BindField 数据元）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_BINDCODE_ISEXIST","args":{"ProductCode":"DOC","QueryCode":"HDSD00.02","FieldCode":"HDSD00.02.01","Type":"BindQuery"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    -1 失败，1 编码已存在，0 编码不存在
ClassMethod GetBindCodeIsExist(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode = argInJson.params.args.ProductCode
	s QueryCode = argInJson.params.args.QueryCode
	s FieldCode = argInJson.params.args.FieldCode
	s Type = argInJson.params.args.Type
    s strRes = ##Class(EMR.DOC.BL.BindQuery).GetBindCodeIsExistJson(ProductCode,QueryCode,FieldCode,Type,.argOutData)
	if (strRes '= "-1")
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

/// Desc:       获取数据集属性关联字段
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATA_BINDVALUES","params":{"bindQueryId":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    -1 失败，1 成功
ClassMethod GetDataBindValues(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s BindQueryID = argInJson.params.bindQueryId
    s strRes = ##Class(EMR.DOC.BL.BindQuery).GetDataBindValuesJson(BindQueryID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入数据集ID",2)
	}
	elseif(strRes = "-301")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集记录不存在,检查参数",2)
	}
	elseif(strRes = "-302")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","数据集查询类不存在",2)
	}
	else
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:    获取用户相关所有项目标识下的数据集目录树JSON
/// Creator:    duanlijun
/// CreateDate: 2021-04-14
/// Input:      AUserCode 用户Code
/// OutPut:    成功：1   失败： -201 用户Code必填
///             				-101 用户对象为空 -102 角色为空  -103 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).GetBindQueryJson("YS01",.argOutData)
ClassMethod GetBindQueryJson(AUserCode As %String, roleCode As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:roleCode="" 
#;	s userObj = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(AUserCode)
#;	q:(userObj="") "-101"
#;	q:(userObj.RoleID="") "-102"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"

	
	s RoleID = RoleID
	s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(roleCode)
	q:(productArray.%Size()=0) "-103"
	s strRes = "1"
	set iter = productArray.%GetIterator()
	s ArrayResult = ##class(%DynamicArray).%New()
	while iter.%GetNext(.key , .objProduct ) {
		 s DataJsonObj = ##class(%DynamicObject).%New()
		 s strRes = ##Class(EMR.DOC.BL.BindQuery).GetDataParameterValuesJson(objProduct.ProductCode,.DataJsonObj)
		 if (strRes="1"){
			 d ArrayResult.%Push(DataJsonObj)
		}
	}
	d ArrayResult.%ToJSON(AOutData)

	q strRes
}

/// Desc:    获取用户相关所有项目标识下的数据集目录树JSON
/// Creator:    duanlijun
/// CreateDate: 2021-04-14
/// Input:      AUserCode 用户Code
/// OutPut:    成功：1   失败： -201 用户Code必填
///             				-101 用户对象为空 -102 角色为空  -103 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).GetBindQueryJson("YS01",.argOutData)
ClassMethod GetBindTreeJson(AUserCode As %String, ARole As %String, ByRef AOutData As %GlobalBinaryStream)
{
	q:ARole="" "-201"
	//如果传入角色code,用户为传入的角色
#;	if (ARole="")
#;	{
#;		s userObj = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(AUserCode)
#;		q:(userObj="") "-101"
#;		q:(userObj.RoleID="") "-102"
#;		s RoleID = userObj.RoleID.%Id()
#;	}
#;	else
#;	{
		//根据角色编码获取角色ID，成功返回角色ID，失败返回-1^失败信息
#;		s RoleID =##Class(EMR.DOC.BL.RBACRole).GetRoleByCode(ARole)
#;		q:(RoleID["-1^") "-102" 
#;	}
	s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(ARole)
	q:(productArray.%Size()=0) "-103"
	s strRes = "1"
	set iter = productArray.%GetIterator()
	s ArrayResult = ##class(%DynamicArray).%New()
	while iter.%GetNext(.key , .objProduct ) {
		 s DataJsonObj = ##class(%DynamicObject).%New()
		 s strRes = ##Class(EMR.DOC.BL.BindQuery).GetDataParameterJson(objProduct.ProductCode,.DataJsonObj)
		 if (strRes="1"){
			 d ArrayResult.%Push(DataJsonObj)
		}
	}
	d ArrayResult.%ToJSON(AOutData)

	q strRes
}

/// Desc:       获取数据集目录树JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProductCode	项目标识
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).GetDataParameterValuesJson("DOC",.argOutData)
ClassMethod GetDataParameterJson(AProductCode As %String, ByRef ADataJsonObj As %DynamicObject) As %String
{
	s strRes = "-200"
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(AProductCode,"U"),""))
	q:(ProductID="") strRes
	s ProductObj = ##class(CT.EMR.DOC.Products).%OpenId(ProductID)
	q:(ProductObj="") strRes
	s strRes = "1"
    s ADataJsonObj.key =AProductCode
    s ADataJsonObj.title ="数据集("_ProductObj.ProductName_")"
    s ADataJsonObj.type = "RT"
    s jsonArr = ##class(%DynamicArray).%New()
 	s strBRowID = ""
	for {
		s strBRowID = $o(^CF.EMR.DOC.BindQueryI("IdxProduct",ProductID,strBRowID))
		q:(strBRowID = "")			
		s objBindQuery = ##Class(CF.EMR.DOC.BindQuery).%OpenId(strBRowID)
        continue:(objBindQuery="")
       	s jsonQuery  = ##class(%DynamicObject).%New()
	    s jsonQuery.key =strBRowID
	    s jsonQuery.code =objBindQuery.Code
	    s jsonQuery.title =objBindQuery.Name
	    s jsonQuery.description = objBindQuery.Description
	    s jsonQuery.queryName = objBindQuery.QueryName
	    s jsonQuery.bindType = $case(objBindQuery.BindType,"":"",:objBindQuery.BindType.Code)
	    s jsonQuery.returnMuch=objBindQuery.ReturnMuch
	    s jsonQuery.type = "CG"
	   	s arrParamter = ##class(%DynamicArray).%New()
	   	s strPRowID = ""
		for {
			s strPRowID = $o(^CF.EMR.DOC.BindParameterI("IdxBindQuery",strBRowID,strPRowID))
			q:(strPRowID = "")			
			s objBindPara = ##Class(CF.EMR.DOC.BindParameter).%OpenId(strPRowID)
	        continue:(objBindPara="")
	       	s jsonPara  = ##class(%DynamicObject).%New()
		    s jsonPara.code = $case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Code)
		    s jsonPara.title =$case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Name)
		    s jsonPara.description =$case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Description)
		    d arrParamter.%Push(jsonPara)
		}
	   	s jsonQuery.params=arrParamter
	   	s jsonParameterArr=##class(%DynamicArray).%New()
	   	s result = ##class(%ResultSet).%New("EMR.DOC.BL.BindField:GetFieldByQuery")
		d result.Execute(strBRowID)
		While result.Next() 
			{
       		s jsonField  = ##class(%DynamicObject).%New()
	    	s jsonField.type="LF"
	    	s jsonField.title=result.GetDataByName("Name")
	    	s jsonField.key=result.GetDataByName("ID")_"LF"
	    	s jsonField.code =result.GetDataByName("Code")
	    	s jsonField.name =result.GetDataByName("Name")
	    	s jsonField.description = result.GetDataByName("Description")
	    	s jsonField.bindFiled = result.GetDataByName("BindFiled")
	    	s jsonField.valueType = result.GetDataByName("ValueType")
			d jsonParameterArr.%Push(jsonField)
			}
	   	s:jsonParameterArr.%Size()>0 jsonQuery.children=jsonParameterArr
		d jsonArr.%Push(jsonQuery)
	}
	s:jsonArr.%Size()>0 ADataJsonObj.children=jsonArr
	q strRes
}

/// Desc:    获取项目标识下的所有数据集数据（TABLE）
/// Creator:    duanlijun
/// CreateDate: 2021-05-08
/// Input:      AProduct 项目标识codeCode
/// OutPut:    成功：1   失败： -201 项目标识Code必填
///             				-301 项目标识不存在 -102 角色为空  -103 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).GetBindQueryJson("YS01",.argOutData)
ClassMethod GetBindQueryJsonByProduct(AProduct As %String, ByRef AOutData As %GlobalBinaryStream, ACurrent As %String = 1, APageSize As %String = 10, AName As %String = "", ACode As %String = "")
{
	s strRes = "1"
	q:AProduct="" "-201"
	s:ACurrent="" ACurrent=1
	s:APageSize="" APageSize=10
	s result = ##class(%DynamicObject).%New()
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(AProduct,"U"),""))
	q:(ProductID="") "-301"
	s ProductObj = ##class(CT.EMR.DOC.Products).%OpenId(ProductID)
	q:(ProductObj="") "-301"
    s jsonArr = ##class(%DynamicArray).%New()
    s start = (ACurrent-1)*APageSize+1
    s end = ACurrent*APageSize
    s count=0
 	s strBRowID = ""
	for {
		s strBRowID = $o(^CF.EMR.DOC.BindQueryI("IdxProduct",ProductID,strBRowID))
		q:(strBRowID = "")			
		s objBindQuery = ##Class(CF.EMR.DOC.BindQuery).%OpenId(strBRowID)
        continue:((objBindQuery="")||((AName'="")&&'(objBindQuery.Name[AName))||((ACode'="")&&'(objBindQuery.Code[ACode)))
        s count = count+1
        continue:((count<start)||(count>end))
       	s jsonQuery  = ##class(%DynamicObject).%New()
	    s jsonQuery.key =strBRowID
	    s jsonQuery.code =objBindQuery.Code
	    s jsonQuery.title =objBindQuery.Name
	    s jsonQuery.description = objBindQuery.Description
	    s jsonQuery.queryName = objBindQuery.QueryName
	    s jsonQuery.bindType = $case(objBindQuery.BindType,"":"",:objBindQuery.BindType.Code)
	    s jsonQuery.type = "LF"
	   	s arrParamter = ##class(%DynamicArray).%New()
	   	s strPRowID = ""
		for {
			s strPRowID = $o(^CF.EMR.DOC.BindParameterI("IdxBindQuery",strBRowID,strPRowID))
			q:(strPRowID = "")			
			s objBindPara = ##Class(CF.EMR.DOC.BindParameter).%OpenId(strPRowID)
	        continue:(objBindPara="")
	       	s jsonPara  = ##class(%DynamicObject).%New()
		    s jsonPara.code = $case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Code)
		    s jsonPara.title =$case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Name)
		    s jsonPara.description =$case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Description)
		    d arrParamter.%Push(jsonPara)
		}
	   	s jsonQuery.params=arrParamter
		d jsonArr.%Push(jsonQuery)
	}
	s result.current = ACurrent
	s result.pageSize = APageSize
	s result.total = count
	s result.list = jsonArr
	d result.%ToJSON(AOutData)

	q strRes
}

/// Desc:       获取数据集目录树JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProductCode	项目标识
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).GetDataParameterValuesJson("DOC",.argOutData)
ClassMethod GetDataParameterValuesJson(AProductCode As %String, ByRef ADataJsonObj As %DynamicObject) As %String
{
	s strRes = "-200"
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(AProductCode,"U"),""))
	q:(ProductID="") strRes
	s ProductObj = ##class(CT.EMR.DOC.Products).%OpenId(ProductID)
	q:(ProductObj="") strRes
	s strRes = "1"
    s ADataJsonObj.key =AProductCode
    s ADataJsonObj.title ="数据集("_ProductObj.ProductName_")"
    s ADataJsonObj.type = "RT"
    s jsonArr = ##class(%DynamicArray).%New()
 	s strBRowID = ""
	for {
		s strBRowID = $o(^CF.EMR.DOC.BindQueryI("IdxProduct",ProductID,strBRowID))
		q:(strBRowID = "")			
		s objBindQuery = ##Class(CF.EMR.DOC.BindQuery).%OpenId(strBRowID)
        continue:(objBindQuery="")
       	s jsonQuery  = ##class(%DynamicObject).%New()
	    s jsonQuery.key =strBRowID
	    s jsonQuery.code =objBindQuery.Code
	    s jsonQuery.title =objBindQuery.Name
	    s jsonQuery.description = objBindQuery.Description
	    s jsonQuery.queryName = objBindQuery.QueryName
	    s jsonQuery.bindType = $case(objBindQuery.BindType,"":"",:objBindQuery.BindType.Code)
	    s jsonQuery.returnMuch=objBindQuery.ReturnMuch
	    s jsonQuery.type = "LF"
	   	s arrParamter = ##class(%DynamicArray).%New()
	   	s strPRowID = ""
		for {
			s strPRowID = $o(^CF.EMR.DOC.BindParameterI("IdxBindQuery",strBRowID,strPRowID))
			q:(strPRowID = "")			
			s objBindPara = ##Class(CF.EMR.DOC.BindParameter).%OpenId(strPRowID)
	        continue:(objBindPara="")
	       	s jsonPara  = ##class(%DynamicObject).%New()
		    s jsonPara.code = $case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Code)
		    s jsonPara.title =$case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Name)
		    s jsonPara.description =$case(objBindPara.Parameter,"":"",:objBindPara.Parameter.Description)
		    d arrParamter.%Push(jsonPara)
		}
	   	s jsonQuery.params=arrParamter
		d jsonArr.%Push(jsonQuery)
	}
	s:jsonArr.%Size()>0 ADataJsonObj.children=jsonArr
	q strRes
}

/// Desc:       添加数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  数据集对象
/// 			aParams 数据集入参
/// OutPut:     成功 数据集ID>0  失败： -101 queryName 查询类已存在，不需要新建  -102 操作数据失败
/// 							   		-200 必填项校验不成功
/// 						   			-301 项目标识不存在 -302 查询方法不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).AddBindQueryDataJson("1","EMRDOC",argOutData)
ClassMethod AddBindQueryDataJson(aDTOItem As EMR.DOC.DTO.BindQuery, aParams As %DynamicArray, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")||(aDTOItem.Product="")||(aDTOItem.QueryName="")||(aDTOItem.BindType="")||(aDTOItem.Name="")) "-200"
	TSTART
	s strMark = "1"
	s objProduct = ##Class(EMR.DOC.BL.Products).GetProductByCode(aDTOItem.Product)
	if (objProduct="")
	{
		TROLLBACK
		q "-301"
	}
	s strProductID = objProduct.%Id()
	s rowID = $o(^CF.EMR.DOC.BindQueryI("IdxPQueryName",strProductID," "_$zcvt(aDTOItem.QueryName,"U"),""))
	if (rowID '= "") 
	{
		TROLLBACK
		s strRes = "-101"
		d argOutData.Write(strRes)
		q strRes
	}
	/*判断类是否存在*/
	s obj = ##class(CF.EMR.DOC.BindQuery).%New()
	s obj.Product = objProduct
	s rowTypeID = $o(^CF.EMR.DOC.BindTypesI("IdxProductCode",strProductID," "_$zcvt(aDTOItem.BindType,"U"),""))
	if (rowTypeID = "") 
	{
		TROLLBACK
		q "-302"
	}
	s objBindType = ##class(CF.EMR.DOC.BindTypes).%OpenId(rowTypeID)
	s obj.BindType = objBindType
	s obj.Code = aDTOItem.Code
	s obj.Description = aDTOItem.Description
	s obj.Name = aDTOItem.Name
	s obj.QueryName = aDTOItem.QueryName
	s obj.ReturnMuch=$CASE(aDTOItem.ReturnMuch,"":1,:0)
	
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-102"
	}
	s intParamSize = aParams.%Size()
	for i=0:1:(intParamSize-1)
	{
		s jItem = aParams.%Get(i)
		s strParamCode = jItem.code
		s countc=strParamCode.%Size()
		for i=0:1:(countc-1)
		{
			s code= strParamCode.%Get(i)
			s strPValueRowID = $o(^CF.EMR.DOC.BindPValuesI("IdxProductCode",strProductID," "_$zcvt(code,"U"),""))
			if (strPValueRowID = "") 
			{
				s strMark ="-1"
				q
			}
			s objParametarValue = ##class(CF.EMR.DOC.BindParameterValues).%OpenId(strPValueRowID)
			s objParametar = ##class(CF.EMR.DOC.BindParameter).%New()
			s objParametar.BindQuery = obj
			s objParametar.Parameter = objParametarValue
			s sc = objParametar.%Save()
			if ('$$$ISOK(sc))
			{
				s strMark ="-1"
				q
			}		
		}
		
	}	if (strMark ="-1")
	{
		s strRes = "-102"
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = obj.%Id()
	}

	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       更新数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDTOItem  数据集对象
/// 			aParams 数据集入参
/// OutPut:     成功 1  失败： -101 queryName 查询类已存在，不需要新建  -102 操作数据失败
/// 						   -200 必填项校验不成功
/// 						   -301 数据集不存在 -302 查询方法不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).UpBindQueryDataJson("1","EMRDOC",argOutData)
ClassMethod UpBindQueryDataJson(aDTOItem As EMR.DOC.DTO.BindQuery, aParams As %DynamicArray, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")||(aDTOItem.QueryName="")||(aDTOItem.BindType="")||(aDTOItem.Name="")) "-200"
	TSTART
	s strMark = "1"
	s obj = ##class(CF.EMR.DOC.BindQuery).%OpenId(aDTOItem.ID)
	if (obj = "") 
	{
		TROLLBACK
		q "-301"
	}
	s strProductID = obj.Product.%Id()
	s rowID = $o(^CF.EMR.DOC.BindQueryI("IdxPQueryName",strProductID," "_$zcvt(aDTOItem.QueryName,"U"),""))
	if ((rowID'="")&&(rowID'=aDTOItem.ID)) 
	{
		TROLLBACK
		q "-101"
	}
	s rowTypeID = $o(^CF.EMR.DOC.BindTypesI("IdxProductCode",strProductID," "_$zcvt(aDTOItem.BindType,"U"),""))
	if (rowTypeID = "") 
	{
		TROLLBACK
		q "-302"
	}
	s objBindType = ##class(CF.EMR.DOC.BindTypes).%OpenId(rowTypeID)
	s obj.BindType = objBindType
	s obj.Code = aDTOItem.Code
	s obj.Description = aDTOItem.Description
	s obj.Name = aDTOItem.Name
	s obj.QueryName = aDTOItem.QueryName
	s obj.ReturnMuch=aDTOItem.ReturnMuch
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q strRes
	}
	s strPVRowID = ""
	for {
		s strPVRowID = $o(^CF.EMR.DOC.BindParameterI("IdxBindQuery",aDTOItem.ID,strPVRowID))
		q:(strPVRowID="")
		if ('##class(CF.EMR.DOC.BindParameter).%DeleteId(strPVRowID))
		{
			s strMark ="-1"
			q
		}
	}
	s intParamSize = aParams.%Size()
	for i=0:1:(intParamSize-1)
	{
		s jItem = aParams.%Get(i)
		s strParamCode = jItem.code
		s countc=strParamCode.%Size()
		for i=0:1:(countc-1)
		{
			s code= strParamCode.%Get(i)
			s strPValueRowID = $o(^CF.EMR.DOC.BindPValuesI("IdxProductCode",strProductID," "_$zcvt(code,"U"),""))
			if (strPValueRowID = "") 
			{
				s strMark ="-1"
				q
			}
			s objParametarValue = ##class(CF.EMR.DOC.BindParameterValues).%OpenId(strPValueRowID)
			s objParametar = ##class(CF.EMR.DOC.BindParameter).%New()
			s objParametar.BindQuery = obj
			s objParametar.Parameter = objParametarValue
			s sc = objParametar.%Save()
			if ('$$$ISOK(sc))
			{
				s strMark ="-1"
				q
			}		
		}
		
	}
	
	if (strMark ="-1")
	{
		TROLLBACK
		s strRes = "-102"
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       删除数据集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aQueryID  数据集ID
/// OutPut:     返回数据 成功：1,失败：-102 操作数据失败
/// 									   -200 未传数据集ID
/// 									   -301 数据集对象不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindQuery).DelGlossaryItemByDocJson("40",argOutData)
ClassMethod DelBindQueryDataJson(aQueryID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes ="-102"
	q:(aQueryID="") "-200"
	TSTART
	s strMark = "1"
	s objQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aQueryID)
	if (objQuery ="")
	{
		TROLLBACK
		q "-301"
	}
	s fieldId=  $o(^CF.EMR.DOC.BindFieldI("IdxBindQuery",aQueryID,""))
	if (fieldId '= "") q "-302"
	s strPVRowID = ""
	for {
		s strPVRowID = $o(^CF.EMR.DOC.BindParameterI("IdxBindQuery",aQueryID,strPVRowID))
		q:(strPVRowID="")
		if ('##class(CF.EMR.DOC.BindParameter).%DeleteId(strPVRowID))
		{
			s strMark ="-1"
			q
		}
	}
	s strBFRowID = ""
	for {
		s strBFRowID = $o(^CF.EMR.DOC.BindFieldI("IdxBindQuery",aQueryID,strBFRowID))
		q:(strBFRowID="")
		if ('##class(CF.EMR.DOC.BindField).%DeleteId(strBFRowID))
		{
			s strMark ="-1"
			q
		}
	}
	if '(objQuery.%DeleteId(aQueryID))
	{
		TROLLBACK
		q strRes
	}
	if (strMark ="-1")
	{
		TROLLBACK
		s strRes = "-102"
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       获取数据集、数据元编码是否存在
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aProductCode 项目标识
///             aCode 编码
///             aType 数据类型 (BindQuery 数据集，BindField 数据元)
/// Output:     -1 失败，1 编码已存在，0 编码不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			q ##Class(EMR.DOC.BL.BindQuery).GetBindCodeIsExistJson("DOC","HDSD00.02","HDSD00.02.01","BindQuery",argOutData)
ClassMethod GetBindCodeIsExistJson(aProductCode As %String, QueryCode As %String, FieldCode As %String, aType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1"
	q:((aType="")||(aProductCode="")||(QueryCode="")) strRes
	
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(aProductCode,"U"),""))
	q:(ProductID="") strRes
	s rowID = ""
	if (aType ="BindQuery")
	{
		s rowID = $o(^CF.EMR.DOC.BindQueryI("IdxPCode",ProductID," "_$zcvt(QueryCode,"U"),""))
	}
	elseif(aType ="BindField")
	{
		s rowQID = $o(^CF.EMR.DOC.BindQueryI("IdxPCode",ProductID," "_$zcvt(QueryCode,"U"),""))
		q:(rowQID="") strRes
		s rowID = $o(^CF.EMR.DOC.BindFieldI("IdxQueryCode",rowQID," "_$zcvt(FieldCode,"U"),""))
	}			
	if (rowID>0)
	{
		s strRes ="1"
	}
	else
	{
		s strRes = "0"	
	}
	d argOutData.Write(strRes)
	q strRes
}

/// Desc:       获取数据集属性关联字段
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aBindQueryID 数据集ID
/// Output:     成功 1 失败 -200 数据集ID未传
/// 							-301 数据集记录不存在 -302 数据集查询类方法不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			w ##Class(EMR.DOC.BL.BindQuery).GetDataBindValuesJson("1",argOutData)
ClassMethod GetDataBindValuesJson(aBindQueryID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:((aBindQueryID="")) "-200"
	s objBindQuery = ##class(CF.EMR.DOC.BindQuery).%OpenId(aBindQueryID)
	q:(objBindQuery="") "-301"
	s jsonArr = ##class(%DynamicArray).%New()
	s stramMessage = ##Class(%GlobalBinaryStream).%New()
	s strClassName = $p(objBindQuery.QueryName,":",1)
	s strQueryName = $p(objBindQuery.QueryName,":",2)
	//实现方法为Query查询
	if (objBindQuery.BindType.Code ="Query")
	{
		s strMethodQuery = strClassName_"||"_strQueryName
		;s classExist = ##class(%Dictionary.CompiledClass).%ExistsId(strClassName)
		s methodQuery = ##class(%Dictionary.CompiledQuery).%ExistsId(strMethodQuery)
		q:(methodQuery="0") "-302"
		s obj = ##class(%Dictionary.CompiledQuery).%OpenId(strMethodQuery)
		q:(obj="") "-302"
		s cnt=$ll(obj.ColNames)
		for i=1:1:cnt 
		{
			s colName=$listget(obj.ColNames,i) 
		    d jsonArr.%Push(colName)
		}
	}
	elseif(objBindQuery.BindType.Code ="ClassProperty")
	{
	}			
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       根据类名和方法名获取ID
/// Creator:    yejian
/// CreateDate: 2021-5-6
/// Input:      AClassName 类名
/// 			AQueryName 方法名
/// Output:     成功 rowID
/// 			失败 ""
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			w ##Class(EMR.DOC.BL.BindQuery).GetDataBindValuesJson("1",argOutData)
ClassMethod SelectIDByClassName(AClassName As %String, AQueryName As %String) As %String
{
	s Result="" 
	q:(AClassName="")||(AQueryName="") Result
	s strQueryName =AClassName_":"_AQueryName
	&sql(SELECT Count(ID) Into :CountID FROM CF_EMR_DOC.BindQuery where QueryName= :strQueryName)
	if (CountID=0)
	{
		s Result="" 
	}
	elseif (CountID >=0)
	{
		&sql(SELECT ID Into :Result FROM CF_EMR_DOC.BindQuery where QueryName= :strQueryName)
	}
	q Result
}

/// Desc:       获取数据集操作数据
/// Creator:    duan
/// CreateDate: 2021-05-17
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败：     -101 用户不存在  -102 用户未维护角色 
///             				   -301 文档管理操作数据为空
ClassMethod GetBindQueryOperationJson(ParentCode As %String, argUserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "1"
#;	s objUser = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(objUser="") "-101"
#;	q:(objUser.RoleID="") "-102"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"

	s strRoleID = RoleID
	s jsonObj  = ##class(%DynamicObject).%New()
 	s strRPRowID = ""
 	s strRes = "-301"

	//添加右键授权数据
	s jsonFuncMenuNode = ##class(%DynamicObject).%New()
	//添加按钮授权数据
	s arrayFuncBtn = ##class(%DynamicArray).%New()
	s rowFuncItemID = ""
	for {
		s rowFuncItemID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(ParentCode,"U"),rowFuncItemID))
		q:(rowFuncItemID = "")				
		s objFunItem = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFuncItemID)
		continue:(objFunItem="")
		s strRes="1"
        if (objFunItem.Type.Code="funcMenuNode")
        {
			s Permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFuncItemID)
			//添加功能菜单授权数据
			s jsonFuncMenu = ##class(%DynamicArray).%New()
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFunItem.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s menuPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				continue:menuPermission'=2
				d jsonFuncMenu.%Push(jsonMenu)
			}
	        s:(objFunItem.FuncCode="menu_hfformat_root") jsonFuncMenuNode.root = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_hfformat_category") jsonFuncMenuNode.category = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_hfformat_document") jsonFuncMenuNode.document = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_hfformat_format") jsonFuncMenuNode.format = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_hfformat_version") jsonFuncMenuNode.version = jsonFuncMenu
        }
        elseif(objFunItem.Type.Code="funcBtnType")
        {
	        
			s permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFuncItemID)
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFunItem.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s btnPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				s jsonMenu.permission = btnPermission
				d arrayFuncBtn.%Push(jsonMenu)
			}
        }
	
	}
    
    s jsonObj.tree =jsonFuncMenuNode
    s jsonObj.btn =arrayFuncBtn
	d jsonObj.%ToJSON(argOutData)

	q strRes
}

}
