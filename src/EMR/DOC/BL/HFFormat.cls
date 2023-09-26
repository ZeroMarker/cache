/// 名称:	EMR.DOC.BL.HFFormat
/// 描述:	通用文档管理模块  文档版式操作管理
/// 编写者:	duan
/// 编写日期: 	2021-03-22
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.HFFormat Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档版式目录树
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"action":"GET_HFF_DATATREE","params":{"userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetHFFormatTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "HFF"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s type = argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.HFFormat).GetHFFormatTreeJson(UserCode,DataTypes,type,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif (strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	elseif (strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未授权项目标识",2)
	}
	elseif (strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请输入用户Code",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       新建目录
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"action": "ADD_HFF_MANAGE","params": {"id":"","title":"","description":""},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s CategoryObj = ##class(EMR.DOC.DTO.HFFormatCategory).%New()
	s CategoryObj.ParentType=..GetTypeByKey(argInJson.params.id)
	s CategoryObj.Name = argInJson.params.title
	s CategoryObj.Description = argInJson.params.description
	s CategoryObj.ParentID = ..GetIDByKey(argInJson.params.id)
	
	s UserCode = argInJson.params.userCode
	//添加目录
	// Output:     成功：1   失败：-200  必填项校验 -201 名称不能为空 -202 父级ID不能为空
	// 									  -301 项目标识对象不存在 -302 父对象不存在
	// 									  -101 操作数据记录出错
    s strRes = ##Class(EMR.DOC.BL.HFFormat).AddCategoryJson(CategoryObj,UserCode)
    if (strRes = "1")
	{
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","参数错误：AHFFormatCategory不能为空",2) 
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","名称不能为空",2) 
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","id参数不能为空",2) 
	}
	elseif (strRes = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录出错",2) 
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","项目标识对象不存在",2) 
	}
	elseif (strRes = "-302")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","id参数不正确",2) 
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新目录
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"action": "UPDATE_HFF_MANAGE","params": {"id":"","title":"","description":"","parentId":""},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s CategoryObj = ##class(EMR.DOC.DTO.HFFormatCategory).%New()
	s CategoryObj.Name = argInJson.params.title
	s CategoryObj.Description = argInJson.params.description
	s CategoryObj.ID = ..GetIDByKey(argInJson.params.id)
	s CategoryObj.ParentID = ..GetIDByKey(argInJson.params.ParentId)
	
	//更新目录
	// Output:     成功：1   失败：-200  必填项校验 -201 名称不能为空 -202 ID不能为空
	// 									  -301 项目标识对象不存在 -302 父对象不存在 -303 "ID参数不对"
	//									  -101 操作数据记录出错
    s strRes = ##Class(EMR.DOC.BL.HFFormat).UpdateCategoryJson(CategoryObj)
    if (strRes = "1")
	{
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","参数错误：AHFFormatCategory不能为空",2) 
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","名称不能为空",2) 
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","id参数不能为空",2) 
	}
	elseif (strRes = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录出错",2) 
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","项目标识对象不存在",2) 
	}
	elseif (strRes = "-302")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","parentId参数不正确",2) 
	}
	elseif (strRes = "-303")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","id参数不正确",2) 
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除目录
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"action": "DELETE_HFF_MANAGE","params": {"id":""},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s ID = ..GetIDByKey(argInJson.params.id)
	
	//成功：1   失败：-200  ID不能为空
	// 				-301 ID数据不存在 
	// 			  -101 操作数据记录出错 -102 目录下不为空不允许删除
    s strRes = ##Class(EMR.DOC.BL.HFFormat).DeleteCategoryJson(ID)
    if (strRes = "1")
	{
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2) 
	}
	elseif (strRes = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录出错",2) 
	}
	elseif (strRes = "-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录下不为空不允许删除",2) 
	}
	elseif (strRes = -103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录下有版式数据不允许删除",2) 
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","ID数据不存在,检查id参数",2) 
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       新建版式
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"action": "ADD_HFF_MANAGE","params": {"title": "版式测试1","description": "患者基本信息新建版式","id": "24||DT","userCode":"YS01","IP":"127.0.0.1"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddHFFormat(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s HFFObj = ##class(EMR.DOC.DTO.HFFormat).%New()
	s HFFObj.Name = argInJson.params.title
	s HFFObj.Description = argInJson.params.description
	s HFFObj.HFFormatCategory = ..GetIDByKey(argInJson.params.id) 
	s HFFObj.BDMCategory = ..GetIDByKey(argInJson.params.BDMCategory)
	s HFFVersion = ##class(EMR.DOC.DTO.HFFormatVersion).%New()
	s HFFVersionLog = ##class(EMR.DOC.DTO.HFFormatStatusMLog).%New()
	s HFFVersionLog.CreateID = argInJson.params.userCode
	s HFFVersionLog.ModifyID = argInJson.params.userCode
	s HFFVersionLog.OperateMachineIP = argInJson.params.IP
	
	//添加版式
	
	// 成功： 1   失败：-200   AHFFormat -201 名称必传 -202 版式目录ID必传
	// 					-301 文档对象不存在 -302 版式目录对象不存在
	// 					-101 操作数据记录出错 -102 版式只能关联文档节点
    s HFFormatID = ##Class(EMR.DOC.BL.HFFormat).AddHFFormatJson(HFFObj)
    if (HFFormatID > 0 )
	{
		s argOutMessage.success = ..#OK
	}
	elseif (HFFormatID = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录出错 ",2) 
	}
	elseif (HFFormatID = "-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","版式只能关联业务数据模型文档节点",2) 
	}
	elseif (HFFormatID = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","参数传递错误：AHFFormat不能为空",2) 
	}
	elseif (HFFormatID = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","版式名称必传",2) 
	}
	elseif (HFFormatID = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","ID参数必传",2) 
	}
    s HFFVersion.HFFormat = HFFormatID
    //新增版本
    s strRes = ##Class(EMR.DOC.BL.HFFormatVersion).AddHFVersionJson(HFFVersion,HFFVersionLog,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","操作版式数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","操作版本数据记录失败",2)
	}
	elseif(strRes="-103")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","添加日志失败",2)
	}
	elseif(strRes="-104")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","有未发布的版本，不允许添加新版本",2)
	}
	elseif(strRes="-200")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","版式记录不存在,检查参数",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新版式
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"params":{"action":"UPDATE_HFFORMAT","args":{"ID":"2","Name":"入院记录","Description":"描述","GUID":"111111111"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateHFFormat(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s HFFObj = ##class(EMR.DOC.DTO.HFFormat).%New()
	s HFFObj.Name = argInJson.params.title
	s HFFObj.Description = argInJson.params.description
	s HFFObj.BDMCategory = ..GetIDByKey(argInJson.params.BDMCategory)
	s HFFObj.ID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.HFFormat).UpdateHFFormatJson(HFFObj)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作版式数据记录出错",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","版式记录不存在，检查参数id",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据模型文档记录不存在，检查参数parentId",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除版式
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数  
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteHFFormat(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s HFFormatID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.HFFormat).DeleteHFFormatJson(HFFormatID)
    /// Output:     成功： 1   失败：-200  必填项校验（版式ID）
	/// 							 -101 操作数据记录出错 -102 版式下有版本不允许删除 -103 修改版式目录数据失败
	///                              -301 版式数据不存在 -302 版式目录不存在
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数必填",2)
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","版式下有版本不允许删除",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","修改版式目录数据失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","版式数据不存在",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","版式目录不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取文档版式操作数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"params":{"action":"GET_HFFORMAT_OPERATION","args":{"UserCode":"2","ParentCode":"MENU_DOC_HFFORMAT"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetHFFormatOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ParentCode = "MENU_DOC_HFFORMAT"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.HFFormat).GetHFFormatOperationJson(ParentCode,UserCode,roleCode,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000",2)
}

/// Desc:       获取文档版式树结构
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argUserCode用户编码
/// Input:      DataTypes  授权数据类型
/// OutPut:     成功 1  失败 -201 用户Code未传
///                          -101 用户不存在  -102 用户没有关联角色 -103 用户没有项目标识授权
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.HFFormat).GetHFFormatTreeJson("YS01","HFF",.argOutData)
ClassMethod GetHFFormatTreeJson(argUserCode As %String, argDataTypes As %String, argType As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:roleCode=""
#;	s userObj = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-101"
#;	q:(userObj.RoleID="") "-102"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"

	s RoleID =RoleID
	s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(roleCode)
	q:(productArray.%Size()=0) "-103"
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	// %GetIterator返回一个%Iterator器对象，允许对一个动态实体的所有成员进行迭代
	set iter = productArray.%GetIterator()
	while iter.%GetNext(.key , .objProduct ) {
        s ProductID = objProduct.%Id()
        s jsonRoot  = ##class(%DynamicObject).%New()
        s rootID=""
        &sql(select ID into :rootID from CF_EMR_DOC.HFFormatCategory where ParentID = 0 and Product = :ProductID)
        continue:(rootID="")
        s objCate=##class(CF.EMR.DOC.HFFormatCategory).%OpenId(rootID)
        s jsonRoot.key =rootID_"||RT"
        s jsonRoot.title =objCate.Name
        s jsonRoot.sequence = 0
        s jsonRoot.description=objCate.Description
        s jsonRoot.type = "RT"
		s jsonCategory = ##class(%DynamicArray).%New()
		s DataTypes = $zcvt(argDataTypes,"U")
		d ##Class(EMR.DOC.BL.HFFormat).GetJsonCategroyByID(rootID,ProductID,argType,.jsonCategory)
		s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

/// Desc:       递归获取业务模型目录数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.HFFormat).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, aType As %String, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.HFFormatCategoryI("IdxProParentId",aProductID," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.HFFormatCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s objProduct = ##class(CT.EMR.DOC.Products).%OpenId(aProductID)
	    s type="CG"
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s jsonCat.description = objCat.Description
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if (objCat.ResChildCount>0)
		{
			//获取文档版式数据
			s result = ##Class(EMR.DOC.BL.HFFormat).GetHFFormatByPID(rowCID,aType,.jsonCateNew)
		}
		else
		{	
			//获取子目录数据
			s result = ##Class(EMR.DOC.BL.HFFormat).GetJsonCategroyByID(rowCID,aProductID,aType,.jsonCateNew)
		}
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       根据业务数据模型的文档节点获取文档版式信息
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      aBDMId 业务数据模型文档ID
///             aProduct 项目标识
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.HFFormat).GetHFFormatByPID(10,1,1,)
ClassMethod GetHFFormatByPID(aBDMId As %String, aType As %String, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.HFFormatI("IdxHFFormatCategory",aBDMId,rowID))
		q:(rowID = "")				
		s objHFF = ##Class(CF.EMR.DOC.HFFormat).%OpenId(rowID)
	    continue:(objHFF="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.key = rowID_"||LF"
	    s jsonCat.title = objHFF.Name
	    s jsonCat.type = "LF"
	    s jsonCat.description = objHFF.Description
	    s jsonCat.lastVersion = objHFF.LastVersion
	    s jsonCat.publishVersion = objHFF.PublishVersion
	    s jsonCat.BDMCategory = ""
	  
	    s:(objHFF.BDMCategory'="") jsonCat.BDMCategory = objHFF.BDMCategory.%Id()_"||DT" 
	    
	    if (aType'="LF"){
		    s jsonCateNew = ##class(%DynamicArray).%New()
	    	//获取版式版本数据
	    	s result = ##Class(EMR.DOC.BL.HFFormat).GetJsonHFVersionByID(rowID,.jsonCateNew)
	    	s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取版式版本数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      aHFFID 版式ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.HFFormat).GetJsonHFVersionByID(10)
ClassMethod GetJsonHFVersionByID(aHFFID As %String, ByRef jsonCategory As %DynamicArray)
{
	s objHFF=##class(CF.EMR.DOC.HFFormat).%OpenId(aHFFID)
	
	s res = "1"
	s versionNumber = ""
	for {
		s versionNumber = $o(^CF.EMR.DOC.HFFormatVersionI("IndexVersion",aHFFID,versionNumber))
		q:(versionNumber = "")
		s rowID = $O(^CF.EMR.DOC.HFFormatVersionI("IndexVersion",aHFFID,versionNumber,""))
		continue:(rowID="")		
		s objVersion = ##Class(CF.EMR.DOC.HFFormatVersion).%OpenId(rowID)
	    continue:(objVersion="")
	   
	    s objVersionMLog = ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetMaxLog(rowID)
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.id=rowID
	    s jsonCat.parentTitle=objHFF.Name
	    s jsonCat.key = rowID_"||IT"
	    s jsonCat.title = "V"_objVersion.VersionNumber_".0 "_$ZD(objVersion.EffectiveDate,3)
	    s jsonCat.type = "IT"
	    s jsonCat.version="V"_objVersion.VersionNumber_".0 "
	    s jsonCat.sequence = rowID
	    s jsonCat.status=objVersion.Status_""
	    s jsonCat.versionNumber = versionNumber
	    s jsonCat.createName=##class(EMR.DOC.HISInterface.PatientInfoAssist).GetUserNameByCode(objVersionMLog.CreateID)
	    s jsonCat.createDate=$ZD(objVersionMLog.CreateDate,3)
		s jsonCat.modifyDate=$ZD(objVersionMLog.ModifyDate,3)
		s jsonCat.remark=objVersionMLog.Remark
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       添加目录
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      
/// Output:     成功：1   失败：-200  必填项校验 -201 名称不能为空 -202 父级ID不能为空
/// 									  -301 项目标识对象不存在 -302 父对象不存在
/// 									  -101 操作数据记录出错
/// Debug:   q ##Class(EMR.DOC.BL.HFFormat).AddCategoryJson()
ClassMethod AddCategoryJson(AHFFormatCategory As EMR.DOC.DTO.HFFormatCategory, UserCode As %String) As %String
{
	
	q:(AHFFormatCategory="") "-200"
	q:(AHFFormatCategory.Name="") "-201"
	q:(AHFFormatCategory.ParentID="") "-202"
	TSTART
	s objHFFormatCategory = ##class(CF.EMR.DOC.HFFormatCategory).%New()

	//目录节点下添加目录
		s ObjParent = ##class(CF.EMR.DOC.HFFormatCategory).%OpenId(AHFFormatCategory.ParentID)
		q:(ObjParent="") "-302"
		s objHFFormatCategory.Product = ObjParent.Product
		s objHFFormatCategory.ParentID = AHFFormatCategory.ParentID
	
	s objHFFormatCategory.Name = AHFFormatCategory.Name
	s objHFFormatCategory.Description = AHFFormatCategory.Description
	if '(objHFFormatCategory.%Save())
 	{
		TROLLBACK
		q "-101"
	} 
	//版式暂时不走数据权限管理
	/*s ObjUser = ##class(%DynamicObject).%New()
	d ##class(EMR.DOC.BL.RBACUser).GetUserJson(UserCode,ObjUser)
	q:ObjUser=""
	s DataID = obj.%Id()
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(ObjUser.RoleID,DataID,"KB","CG",obj.Name,ProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = "-103"
		q strRes
	}*/
	TCOMMIT
	q "1"
}

/// Desc:       更新目录
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      
/// Output:     成功：1   失败：-200  必填项校验 -201 名称不能为空 -202 ID不能为空
/// 									  -301 项目标识对象不存在 -302 父对象不存在 -303 "ID参数不对"
/// 									  -101 操作数据记录出错
/// Debug:   q ##Class(EMR.DOC.BL.HFForma).AddCategoryJson()
ClassMethod UpdateCategoryJson(AHFFormatCategory As EMR.DOC.DTO.HFFormatCategory)
{
	q:(AHFFormatCategory="") "-200"
	q:(AHFFormatCategory.Name="") "-201"
	q:(AHFFormatCategory.ID="") "-202"
	TSTART
	s ObjCategory = ##class(CF.EMR.DOC.HFFormatCategory).%OpenId(AHFFormatCategory.ID)
	if (ObjCategory=""){
		TROLLBACK
		q "-303"
	}
	if (AHFFormatCategory.ParentID'=""){
		if (AHFFormatCategory.ParentID>0){
			//目录节点剪切
			s ObjParent = ##class(CF.EMR.DOC.HFFormatCategory).%OpenId(AHFFormatCategory.ParentID)
			if (ObjParent="") 
			{
				TROLLBACK
				q "-302"
			}
			s ObjCategory.Product = ObjParent.Product
			s ObjCategory.ParentID = AHFFormatCategory.ParentID
		}else{
			//根节点剪切
			s ProductID = $O(^CT.EMR.DOC.ProductsI("IdxCode"," "_AHFFormatCategory.ParentID,""))
			if (ProductID="") 
			{
				TROLLBACK
				q "-301"
			}
			s ObjProduct = ##class(CT.EMR.DOC.Products).%OpenId(ProductID)
			if (ObjProduct="") 
			{
				TROLLBACK
				q "-301"
			}
			s ObjCategory.Product = ObjProduct
			s ObjCategory.ParentID = 0
		}
	}
	s ObjCategory.Name = AHFFormatCategory.Name
	s ObjCategory.Description = AHFFormatCategory.Description
	if '(ObjCategory.%Save())
 	{
		TROLLBACK
		q "-101"
	} 
	TCOMMIT
	q "1"
}

/// Desc:       删除目录
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      
/// Output:     成功：1   失败：-200  ID不能为空
/// 							-301 项目标识对象不存在 
/// 							-101 操作数据记录出错 -102 目录下不为空不允许删除 -103 目录下有版式不允许删除
/// Debug:   q ##Class(EMR.DOC.BL.HFForma).AddCategoryJson()
ClassMethod DeleteCategoryJson(ID As %String)
{
	q:ID="" "-200"
	//目录下有子节点不允许删除
	s childCount = 0
	&SQL(select count(*) into :childCount from CF_EMR_DOC.HFFormatCategory where ParentID=:ID)
	if ((SQLCODE '="100")&&(SQLCODE'="0"))
	{
		q "-101"	
	}
	q:(childCount>0) "-102"
	TSTART
	s ObjCategory = ##class(CF.EMR.DOC.HFFormatCategory).%OpenId(ID)
	if (ObjCategory="")
	{
		TROLLBACK
		q "-301"
	}
	if (ObjCategory.ResChildCount>0)
	{
		TROLLBACK
		q "-103"	
	}
	&SQL(delete from CF_EMR_DOC.HFFormatCategory where ID=:ID)
	if ((SQLCODE '=100)&&(SQLCODE'=0)&&(SQLCODE'=-106))
	{
		q "-101"
		TROLLBACK	
	}
	TCOMMIT
	q "1"
}

/// Desc:       添加版式
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      ABDMCategoryID 业务数据模型文档id
///             AHFFormat 版式对象
/// Output:     成功： 1   失败：-200  AHFFormat -201 名称必传 -202 版式目录ID必传
/// 									  -301 文档对象不存在 -302 版式目录对象不存在
/// 									  -101 操作数据记录出错 -102 版式只能关联文档节点
/// Debug:   q ##Class(EMR.DOC.BL.HFFormat).AddHFFormatJson()
ClassMethod AddHFFormatJson(AHFFormat As EMR.DOC.DTO.HFFormat) As %String
{
	
	q:(AHFFormat="") "-200"
	q:(AHFFormat.Name="") "-201"
	q:(AHFFormat.HFFormatCategory="") "-202" 
	TSTART
	s objHFFormat = ##class(CF.EMR.DOC.HFFormat).%New()
	s ObjCategory = ##class(CF.EMR.DOC.HFFormatCategory).%OpenId(AHFFormat.HFFormatCategory)
	if (ObjCategory="")
	{
		TROLLBACK
		q "-302"	
	}
	s resChildCount = 0
	s:ObjCategory.ResChildCount>0 resChildCount=ObjCategory.ResChildCount
	s ObjCategory.ResChildCount = resChildCount+1
	if '(ObjCategory.%Save())
 	{
		TROLLBACK
		q "-101"
	} 
	s objHFFormat.HFFormatCategory = ObjCategory
	s objHFFormat.Product = ObjCategory.Product
	if (AHFFormat.BDMCategory'=""){
		s objBDM = ##class(CF.EMR.DOC.BDMCategory).%OpenId(AHFFormat.BDMCategory)
	 	if (objBDM="")
	 	{
		 	TROLLBACK
			q "-301"
	 	}
	 	
	 	if ($ZCVT(objBDM.StructType.Code,"U")'="DOCUMENT")
	 	{
			TROLLBACK
			q "-102" 	
		}
		 s objHFFormat.BDMCategory = objBDM
	}
 	
 	s GUID = ##class(%SYSTEM.Util).CreateGUID()
	s objHFFormat.Name = AHFFormat.Name
 	s objHFFormat.Description = AHFFormat.Description
 	s objHFFormat.GUID = GUID 
	if '(objHFFormat.%Save())
 	{
		TROLLBACK
		q "-101"
	} 
	
	TCOMMIT
	s HFFormatID = objHFFormat.%Id()
	q HFFormatID
}

/// Desc:       更新版式
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      AHFFormatID 业务数据模型文档id
///             AHFFormat 版式对象
/// Output:     成功： 1   失败：-200  必填项校验（文档ID，版式名称，GUID）
/// 							 -301 版式记录不存在 -302 文档记录不存在
/// 							 -101 操作数据记录出错
ClassMethod UpdateHFFormatJson(AHFFormat As EMR.DOC.DTO.HFFormat) As %String
{
	s strRes = "-101"
	q:((AHFFormat="")||(AHFFormat.ID="")||(AHFFormat.Name="")) "-200"
	TSTART
	s objHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(AHFFormat.ID)
	if (objHFFormat="")
	{
		TROLLBACK
		q "-301"
	}
	s strCategoryID = ""
	s:(objHFFormat.BDMCategory'="") strCategoryID = objHFFormat.BDMCategory.%Id()
	//更新数据模型文档绑定
 	if ((AHFFormat.BDMCategory'="")&&(strCategoryID'=AHFFormat.BDMCategory))
 	{
		s objCategoryNew = ##class(CF.EMR.DOC.BDMCategory).%OpenId(AHFFormat.BDMCategory)
		if (objCategoryNew="")
		{
	 		TROLLBACK
			q "-302"
		}
		s objHFFormat.BDMCategory = objCategoryNew
 	}
  	//更新，目录ID不变
 	
	s objHFFormat.Name = AHFFormat.Name
	s objHFFormat.Description = AHFFormat.Description
 	
	if '(objHFFormat.%Save())
 	{
	 	TROLLBACK
		q strRes
	} 
	TCOMMIT
	s strRes = "1"
	q strRes
}

/// Desc:       删除版式
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Output:     成功： 1   失败：-200  必填项校验（版式ID）
/// 							 -101 操作数据记录出错 -102 版式下有版本不允许删除 -103 修改版式目录数据失败
///                              -301 版式数据不存在 -302 版式目录不存在
/// Debug: w ##class(EMR.DOC.BL.HFFormat).DeleteHFFormatJson()
ClassMethod DeleteHFFormatJson(AHFFormatID As %String) As %String
{
	s strRes = "-101"
	q:""=AHFFormatID "-200"
	/*版式下有版本不允许删除*/
	s count =0
	&SQL(select Count(*) into :count from CF_EMR_DOC.HFFormatVersion where HFFormat = :AHFFormatID )
	q:(count>0) "-102"
	TSTART
	s ObjHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(AHFFormatID)
	if (ObjHFFormat="")
	{
		TROLLBACK 
		q "-301"	
	} 
	s CategoryID = ObjHFFormat.HFFormatCategory.%Id()
	s HFFormatCategory = ##class(CF.EMR.DOC.HFFormatCategory).%OpenId(CategoryID)
	if (HFFormatCategory="")
	{
		TROLLBACK
		q "-302"	
	}
	s HFFormatCategory.ResChildCount = HFFormatCategory.ResChildCount-1
	if '(HFFormatCategory.%Save())
 	{
	 	TROLLBACK
		q "-103"
	} 
	&SQL(delete from CF_EMR_DOC.HFFormat where ID=:AHFFormatID)
	if (SQLCODE=0){
		s strRes = "1"
	}else{
		TROLLBACK
		q strRes
	}
	
	TCOMMIT
	q strRes
}

/// Desc:      添加根节点目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||CG","childType":"CG","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddRootCategoryJson(product As %String, name As %String, desc As %String)
{
	s objCate=##class(CF.EMR.DOC.HFFormatCategory).%New()
	s objCate.Description=desc
	s objCate.Name=name
	s objProcudt=##class(CT.EMR.DOC.Products).%OpenId(product)
	s objCate.Product=objProcudt
	s objCate.ParentID=0
	s sc=objCate.%Save()
}

/// Desc:       获取文档版式操作数据
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败：     -101 用户不存在  -102 用户未维护角色 
///             				   -301 文档管理操作数据为空
ClassMethod GetHFFormatOperationJson(ParentCode As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "1"
#;	s objUser = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(UserCode)
#;	q:(objUser="") "-101"
#;	q:(objUser.RoleID="") "-102"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"

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
