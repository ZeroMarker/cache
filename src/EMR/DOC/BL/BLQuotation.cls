Class EMR.DOC.BL.BLQuotation Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取所有科室数据
/// Creator:    zhangzheyi
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_QUOTATION","args":{}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACQuotation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.BLQuotation).GetRBACCQuotationJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取所有科室数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACCTLocsJson(.argOutData)
ClassMethod GetRBACCQuotationJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArrLoc = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.BLQuotation:GetAllCTLoc")
	d result.Execute()
	q:(result = "") "-1" 
	s num = ""
	&sql(select count(*)into num from SQLUser.CT_Loc )
	s count = 1
	s Obj = "{"
	While result.Next() 
	{
		s jsonLoc  = ##class(%DynamicObject).%New()
	 	s jsonLoc.CTLocRowid = result.GetDataByName("CTLOC_RowID")
	 	s jsonLoc.CTLocDesc = result.GetDataByName("CTLOC_Desc")
	 	s text = result.GetDataByName("CTLOC_Desc")
	 	s id = result.GetDataByName("CTLOC_RowID")
	 	
	 	if (count < num ){
		 	s Obj = Obj_""""_id_""""_":{""text"""_":"""_text_""",""id"""_":"_id_"},"
	 	}else {
			s Obj = Obj_""""_id_""""_":{""text"""_":"""_text_""",""id"""_":"_id_"}" 	
		}
	 	s count = count + 1
		
	}
	s Obj = Obj_"}"
	s jsonItem = ##class(%DynamicObject).%FromJSON(Obj)
	d jsonItem.%ToJSON(argOutData)
	q strRes
}

Query GetAllCTLoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowID,CTLOC_Desc", SELECTMODE = "RUNTIME")
{
	Select CTLOC_RowID,CTLOC_Desc from SQLUser.CT_Loc order by CTLOC_RowID
}

/// Desc:       根据DocID获取科室关联模板
/// Creator:    zhangzheyi
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_QUOTATIONBYDOCID","args":{}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACQuotationByDocID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
D
	s $zt = "Error"
	s argData = ##class(%DynamicObject).%New()
    s current = argInJson.params.current
	s pageSize = argInJson.params.pageSize
	s argData.current = $CASE(current,"":1,:current)
	s argData.pageSize = $CASE(pageSize,"":20,:pageSize)
	
	s argData.idxStart= argData.pageSize *(argData.current - 1) +1
	s argData.idxLast= argData.idxStart + argData.pageSize -1
    S argData.ID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.BLQuotation).GetRBACQuotationByDocIDJson(argData,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-101"){
		q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到科室列表数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据DocID获取科室关联模板
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACCTLocsJson(.argOutData)
ClassMethod GetRBACQuotationByDocIDJson(argData As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s aID = argData.ID
	q:(aID = "") -101
	s jsonArrLoc = ##class(%DynamicArray).%New()
	
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.BLQuotation:GetQuotationByDocId")
	d result.Execute(aID)
	
	;s num = ##class(%ResultSet).%New("EMR.DOC.BL.BLQuotation:GetCountByDocId")
	;d num.Execute(aID)
	
	s num = ""
	&sql(SELECT count(*) into num FROM CF_EMR_DOC.QuotationScheme WHERE CTLocID =:aID )
	
	q:(result = "") "-1"
	s startPage = argData.idxStart
	s endPage = argData.idxLast
	s count = 1 
	While result.Next() 
	{
		s jsonLoc  = ##class(%DynamicObject).%New()
		s jsonLoc.ID = result.GetDataByName("ID")
	 	s jsonLoc.CTLocDesc = result.GetDataByName("CTLocDesc")
	 	s jsonLoc.CTLocID = result.GetDataByName("CTLocID")
	 	s jsonLoc.DocID = result.GetDataByName("DocID")
	 	s jsonLoc.DocName = result.GetDataByName("DocName")
	 	s jsonLoc.IsActive = result.GetDataByName("IsActive")
	 	
	 	s IsExist = result.GetDataByName("IsExist")
	 	continue:( IsExist = 0 )
	 	
	 	if (count >= startPage) {
		 	d jsonArrLoc.%Push(jsonLoc)	
		}
		if (count = endPage){
			q
		}	
		s count = count + 1
        
	}
	s jsonObj  = ##class(%DynamicObject).%New()		
	s jsonObj.current = argData.current
	s jsonObj.pageSize = argData.pageSize
	s jsonObj.total = count - 1
	s jsonObj.list = jsonArrLoc
	
	d jsonObj.%ToJSON(argOutData)
	q strRes
}

Query GetQuotationByDocId(ID As %String) As %SQLQuery
{
	SELECT * FROM CF_EMR_DOC.QuotationScheme WHERE CTLocID =:ID
}

Query GetCountByDocId(ID As %String) As %SQLQuery
{
	SELECT count(*) FROM CF_EMR_DOC.QuotationScheme WHERE CTLocID =:ID
}

/// Desc:     	更改科室已关联模板数据“有效”状态
/// Creator:    zhangzheyi
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "CHANGE_STDDIC_DATA","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod ChangeQuotationData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

    s arrIDS = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.BLQuotation).ChangeQuotationDataJson(arrIDS)
    d argOutData.Write(strRes)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入用户ID数组",2)
	}else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除用户失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 更改科室已关联模板数据“有效”状态
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod ChangeQuotationDataJson(arrIDs As %String)
{
	
	s strRes ="-1"
	q:(arrIDs.%Size()=0) strRes
	TSTART
	s strRes = "-2"
	s strMark = "1"
	s intIDSize = arrIDs.%Size()
	for i=0:1:(intIDSize-1)
	{
		s jItem = arrIDs.%Get(i)
		s strID = jItem.ID
		s objUsers = ##class(CF.EMR.DOC.QuotationScheme).%OpenId(strID)
		if (objUsers="") 
		{
			s strMark="-1"
			q
		}
		s objUsers.IsActive = jItem.IsActive
		s sc = objUsers.%Save()
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			q
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       获取病历引用科室文档管理目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_RBAC_QUOTATIONTEMPLATE","params":{"roleId":"1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACQuotationTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "TEMPLATE"
    s strRes = ##Class(EMR.DOC.BL.BLQuotation).GetRBACTemplateDataJson(DataTypes,.argOutData)
	// 成功 1 失败 -201 角色ID必传  -202 DataTypes必传
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色ID必传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","DataTypes必传",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取模板树结构
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserCode用户编码
/// Input:      DataTypes  授权数据类型
/// OutPut:     成功 1 失败 -201 角色ID必传  -202 DataTypes必传
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateDataJson("1","TEMPLATE",.argOutData)
ClassMethod GetRBACTemplateDataJson(DataTypes As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr = ##class(%DynamicArray).%New()
	q:(DataTypes="") "-202"
 	s ProductID = ""
	for {
		s ProductID = $o(^CT.EMR.DOC.ProductsD(ProductID))
		q:(ProductID = "")			
		s objProduct = ##Class(CT.EMR.DOC.Products).%OpenId(ProductID)
        continue:(objProduct="")
        s jsonRoot  = ##class(%DynamicObject).%New()
        s jsonRoot.key =objProduct.ProductCode_"||RT"
        s jsonRoot.productId =ProductID
        s jsonRoot.title ="文档管理("_objProduct.ProductName_")"
        s jsonRoot.type = "RT"
   		
		s jsonCategory = ##class(%DynamicArray).%New()
		s DataTypes = $zcvt(DataTypes,"U")
		d ##Class(EMR.DOC.BL.BLQuotation).GetJsonCategroyByID(0,ProductID,DataTypes,.jsonCategory)
		s jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)

	q "1"
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, DataTypes As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemCID = ""
	for {
		s rowTemCID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxProParentId",aProductID," "_aParentId,rowTemCID))
		q:(rowTemCID = "")				
		s objTemCat = ##Class(CF.EMR.DOC.TemplateCategory).%OpenId(rowTemCID)
	    continue:(objTemCat="")
	    s jsonTemCat  = ##class(%DynamicObject).%New()
	    s jsonTemCat.key = rowTemCID_"||CG"
	    s jsonTemCat.title = objTemCat.Name
	    s jsonTemCat.type = "CG"
	    s jsonTemCat.productId = aProductID
	   
		s jsonCateNew = ##class(%DynamicArray).%New()
		//如果子节点为模板则ResChildCount不为0
		if (objTemCat.ResChildCount=0)
		{
			s result = ##Class(EMR.DOC.BL.BLQuotation).GetJsonCategroyByID(rowTemCID,aProductID,DataTypes,.jsonCateNew)
		}
		else
		{	
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.BLQuotation).GetJsonTempalteByCID(rowTemCID,aProductID,DataTypes,.jsonCateNew)
		}
		if (jsonCateNew.%Size()>0)
		{
			s jsonTemCat.children = jsonCateNew
		}
		d jsonCategory.%Push(jsonTemCat)	
	}
	q res
}

/// Desc:       获取模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.RBACDataPermission).GetJsonTempalteByCID(0,1,1,)
ClassMethod GetJsonTempalteByCID(aParentId As %String, aProductid As %String, DataTypes As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemID = ""
	for {
		s rowTemID = $o(^CF.EMR.DOC.TemplateI("IdxProCategory",aProductid,aParentId,rowTemID))
		q:(rowTemID = "")				
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(rowTemID)
	    continue:(objTem="")
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s jsonTem.key = rowTemID_"||LF"
	    s jsonTem.title = objTem.Name
	    s jsonTem.type = "LF"
	    s jsonTem.productId = aProductid
	    
		d jsonCategory.%Push(jsonTem)	
	}
	q res
}

/// Desc:       添加科室关联模板数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_QUOTATION_DATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddQuotationData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	TSTART
	s arry = argInJson.params 
	s intIDSize = arry.%Size()
	for i=0:1:(intIDSize-1)
	{
		s jItem = arry.%Get(i)
		s jsonObj  = ##class(%DynamicObject).%New()
		s jsonObj.CTLocID = jItem.CTLocID
		s jsonObj.DocID  = ##Class(EMR.DOC.COM.ActionBase).GetIDByKey(jItem.DocID) 
		s result = ##Class(EMR.DOC.BL.BLQuotation).AddQuotationDataJson(jsonObj,.argOutData)
		s strRes =result 
		continue:(result = "-103") 
		if ((result '= "1")){
			TROLLBACK
			q
		}
		
	}  
	TCOMMIT
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","科室ID不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","模板ID不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","重复添加",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","科室ID不存在",2)
	}
	elseif (strRes = -105)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","模板ID不存在",2)
	}
	elseif (strRes = -106)
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

/// Description:   添加科室关联模板数据
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddQuotationDataJson(Obj As %DynamicObject, Properties As %String) As %String
{
	
	s fag=0
	s CTLocID = Obj.CTLocID
	q:(CTLocID= "") -101
	s DocID = Obj.DocID
	q:(DocID= "") -102
	
	s rowID = ""
	s rowID = $o(^CF.EMR.DOC.QuotationSchemeI("IdxCTLocIDDocID",CTLocID,DocID,rowID))
	s objUsers = ##class(CF.EMR.DOC.QuotationScheme).%OpenId(rowID)
	s:((rowID '= "") && (objUsers.IsExist = 0)) fag=1
	q:((rowID '= "") && (objUsers.IsExist = 1)) -103
	
	s objCTLoc = ##class(User.CTLoc).%OpenId(CTLocID)
	q:(objCTLoc = "") -104
	
	s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(DocID)
	q:(objTem = "") -105
	
	
	TSTART
	if (fag=0)
	{
		s ObjStdDic=##class(CF.EMR.DOC.QuotationScheme).%New()
		
		s ObjStdDic.CTLocDesc = objCTLoc.CTLOCDesc
		s ObjStdDic.CTLocID = objCTLoc.%Id()
		s ObjStdDic.DocName = objTem.Name
		s ObjStdDic.DocID = objTem.%Id()
		s ObjStdDic.IsActive = "Y"
		s ObjStdDic.IsExist="1"
		s sc = ObjStdDic.%Save()

	}
	else
	{
		s objUsers.CTLocDesc = objCTLoc.CTLOCDesc
		s objUsers.CTLocID = objCTLoc.%Id()
		s objUsers.DocName = objTem.Name
		s objUsers.DocID = objTem.%Id()
		s objUsers.IsActive = "Y"
		s objUsers.IsExist="1"
		s sc = objUsers.%Save()

	}
	
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -106
	}
	TCOMMIT
	q 1
}

/// Desc:     删除字典数据
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_QUOTATION_DATA","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteQuotationData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

    s arrIDS = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.BLQuotation).DeleteQuotationDataJson(arrIDS)
    d argOutData.Write(strRes)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入用户ID数组",2)
	}else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除关联模板失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 删除字典数据
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteQuotationDataJson(arrIDs As %String)
{
	
	s strRes ="-1"
	q:(arrIDs.%Size()=0) strRes
	TSTART
	s strRes = "-2"
	s strMark = "1"
	s intIDSize = arrIDs.%Size()
	for i=0:1:(intIDSize-1)
	{
		s jItem = arrIDs.%Get(i)
		s strID = jItem
		s objUsers = ##class(CF.EMR.DOC.QuotationScheme).%OpenId(strID)
		if (objUsers="") 
		{
			s strMark="-1"
			q
		}
		s objUsers.IsExist = 0
		s sc = objUsers.%Save()
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			q
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

}
