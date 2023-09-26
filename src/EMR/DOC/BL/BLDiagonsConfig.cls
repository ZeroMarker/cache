Class EMR.DOC.BL.BLDiagonsConfig Extends EMR.DOC.COM.ActionBase
{

/// Desc:       病种目录查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_SEARCH_DIAGNOSCATEGORY", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSearchDiagnosCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s searchText = argInJson.params.searchValue
	s jArryMeun = ##class(%DynamicArray).%New()
	
	if (searchText = "") {
		s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiagnosCategoryJson(0,.jArryMeun)
		
		s jArryArry = ##class(%DynamicArray).%New()
		s jsonItem = ##class(%DynamicObject).%New()
		s jsonItem.ID = 0	
		s jsonItem.key = 0	
        s jsonItem.title = "病种"
        s jsonItem.Type = "C"
        s jsonItem.children = jArryMeun
        d jArryArry.%Push(jsonItem)
        if (strRes = "1")
		{ 	
			d jArryArry.%ToJSON(argOutData)
		}
	}else {
		s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiagnosByCondition(searchText,.jArryMeun)
		 if (strRes = "1")
		{ 	
			d jArryMeun.%ToJSON(argOutData)
		}
	}
  
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
		q ..SetOutMessage(argOutMessage,"ERROR","图库目录查询失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       病种目录查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchDiagnosCategoryJson(ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxSeq"," "_ParentId,seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxSeq"," "_ParentId,seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.ID = obj.%Id()	
        	s jsonItem.key = obj.CategoryCode
        	s jsonItem.title = obj.CategoryCode_" "_obj.CategoryName
        	s jsonItem.Name = obj.CategoryName
        	s jsonItem.Type = "DC"
        	
        	s objResult = ##class(%DynamicArray).%New()
        	s arrItem = ##class(%DynamicArray).%New()
			s result = ##class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiagnosCategoryJson(jsonItem.ID,.arrItem)
			;if (arrItem.%Size() >0) {
			;	s jsonItem.children = arrItem
			;}
			
			s diagnosArry = ##class(%DynamicArray).%New()
			if (obj.DiagnosNum > 0){
	        	s imagItem = ##class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiagnosItemJson(obj.CategoryCode,.diagnosArry)     	
	        	;if (imagItem = "1"){
		        ;	s jsonItem.children = diagnosArry
		        ;}	
	        }
	        
	        s size = arrItem.%Size()
		    if (size> 0){
				for i=0:1:size-1 {
		    	s item = arrItem.%Get(i)
		    	d objResult.%Push(item)
		    	}	
			}
		   
		    
		    s step = diagnosArry.%Size()
		    if (step>0) {
				for i=0:1:step-1 {
		    	s item = diagnosArry.%Get(i)
		    	d objResult.%Push(item)
		    	}
			}
		    if (objResult.%Size() > 0) {
			    s jsonItem.children = objResult
			 }
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

/// Desc:       病种查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchDiagnosItemJson(Code As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s seq = ""
	for {
		s seq = $o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCodeSeq"," "_$zcvt(Code,"U"),seq))
		q:(seq = "")	
		s rowID = ""	
		for 
			{
			s rowID = $o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCodeSeq"," "_$zcvt(Code,"U"),seq,rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.ID= obj.%Id()	
        	s jsonItem.key = obj.DiagnosCode
        	s jsonItem.title = obj.DiagnosCode_" "_obj.DiagnosName
        	s jsonItem.Name = obj.DiagnosName
        	s jsonItem.Status = obj.Status
           	s jsonItem.Type = "D"
			d jsonArr.%Push(jsonItem)
		
		}
	}
	q strRes
}

/// Desc:       根据条件查询病种目录
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchDiagnosByCondition(SearchText As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s rowID = ""
	for {
			s rowID = $o(^CF.EMR.DOC.DiagnosD(rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") || ($find(obj.DiagnosName,SearchText) = 0) )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.ID= obj.%Id()	
        	s jsonItem.key = obj.DiagnosCode
        	s jsonItem.title = obj.DiagnosName
        	s jsonItem.Status = obj.Status
           	s jsonItem.Type = "D"
			d jsonArr.%Push(jsonItem)
	}
	q strRes
}

/// Desc:       添加病种目录
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_DIAGNOS_CATEGORY","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDiagnosCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnosCategoryJson(argInJson,.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","目录名不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","目录类型不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","父节点不存在",2)
	}
	elseif (strRes = -105)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能重复",2)
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

/// Description:   添加病种目录
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddDiagnosCategoryJson(argInJson As %DynamicAbstractObject, Properties As %String) As %String
{
	s name = argInJson.params.CategoryName
	q:(name= "") -101
	s Code = argInJson.params.CategoryCode
	q:(Code= "") -102
	s ParentID = argInJson.params.ParentID
	q:(ParentID= "") -103
	s params = argInJson.params
	
	if (ParentID '= 0) {
		s rowId = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(ParentID)
		q:(rowId = "") -104
	}
	
	 
	s seq = ""
	s seq = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(Code,"U"),seq))
	s obj = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(seq)
	q:((obj '= "")) -105
	
	s objDiagnos = ""
	s objDiagnos = $o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_$zcvt(Code,"U"),objDiagnos))
	s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(objDiagnos)
	q:((obj '= "")) -105
	
	TSTART
	s ObjDiagnos=##class(CF.EMR.DOC.DiagnosCategory).%New()
		
	s ObjDiagnos.CategoryCode = params.CategoryCode
	s ObjDiagnos.CategoryName = params.CategoryName	
	s ObjDiagnos.ParentID = params.ParentID
	
	s num = "" 
	&sql(SELECT COUNT(*) into num  FROM CF_EMR_DOC.DiagnosCategory)
	s ObjDiagnos.Sequence = num + 1
	
	s ObjDiagnos.IsExist = 1    

	s sc = ObjDiagnos.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -106
	}
	TCOMMIT
	q 1
}

/// Desc:     删除目录
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_DIAGNOS_CATEGORY","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteDiagnosCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.key
    s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnosCategoryJson(ID)
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

/// desc 删除目录
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteDiagnosCategoryJson(aID As %String)
{
	q:(aID="") -201
	s ObjMap = ##class(CF.EMR.DOC.DiagnosCategory).%OpenId(aID)
	q:(ObjMap="") -102
	s sc = ##class(CF.EMR.DOC.DiagnosCategory).%DeleteId(aID)
	q 1
}

/// Desc:       更新目录数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_DIAGNOS_CATEGORY","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateDiagnosCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).UpdateDiagnosCategoryJson(argInJson,.argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	elseif (strRes = -103)
	{  	
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能重复",2)
	}
	elseif (strRes = -105)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","目录不存在",2)
	}
	elseif (strRes = -106)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	elseif (strRes = -107)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","根节点目录不允许修改",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新目录数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:    
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateDiagnosCategoryJson(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s id= argInJson.params.ID
	q:(id= "") -101
	s Code= argInJson.params.CategoryCode
	q:(Code= "") -102
	s Name= argInJson.params.CategoryName
	q:(Name= "") -103
	
	q:(id = 0) -107
	
	s params = argInJson.params
	
	TSTART
	s ObjImage=##class(CF.EMR.DOC.DiagnosCategory).%OpenId(id)
	if ('ObjImage)
		{
		q 105
	}
	
	if (ObjImage.CategoryCode '= Code) {
		s seq = ""
		s seq = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(Code,"U"),seq))
		s obj = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(seq)
		q:(obj '= "" ) -105
	
		s diagnosId = ""
		s diagnosId = $o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_$zcvt(Code,"U"),diagnosId))
		s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(diagnosId)
		q:(obj '= "") -105
	}
    
    s ObjImage.CategoryCode = Code	
	s ObjImage.CategoryName = Name
 	s sc = ObjImage.%Save()
 	
 	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -106
	}
	TCOMMIT
	q 1
}

/// Desc:       添加病种
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_DIAGNOS","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDiagnos(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnosJson(argInJson,.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","目录名不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","目录类型不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","父节点不存在",2)
	}
	elseif (strRes = -105)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能重复",2)
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

/// Description:   添加病种
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddDiagnosJson(argInJson As %DynamicAbstractObject, Properties As %String) As %String
{
	s Name = argInJson.params.DiagnosName
	q:(Name= "") -101
	s Code = argInJson.params.DiagnosCode
	q:(Code= "") -102
	s ParentID = argInJson.params.ParentID
	q:(ParentID= "") -103
	s params = argInJson.params
	
	s rowId = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(ParentID)
	q:(rowId = "") -104
	 
	s seq = ""
	s seq = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(Code,"U"),seq))
	s obj = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(seq)
	q:((obj '= "")) -105
	
	s objDiagnos = ""
	s objDiagnos = $o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_$zcvt(Code,"U"),objDiagnos))
	s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(objDiagnos)
	q:((obj '= "")) -105
	
	TSTART
	s result = ##Class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnosCategoryCount(ParentID)
	q:(result '= "1") -107
	
	
	s ObjDiagnos=##class(CF.EMR.DOC.Diagnos).%New()
		
	s ObjDiagnos.CategoryCode = rowId.CategoryCode
	s ObjDiagnos.CategoryName = rowId.CategoryName
	s date =$p($h,",",1)
	s ObjDiagnos.CreateDate = date
	s ObjDiagnos.DiagnosCode = Code
	s ObjDiagnos.DiagnosName = Name
	s ObjDiagnos.IsExist = "1"
	
	s num = "" 
	&sql(SELECT COUNT(*)into num  FROM CF_EMR_DOC.Diagnos )
	s ObjDiagnos.Sequence = num + 1
	s ObjDiagnos.Status = params.Status
	s ObjDiagnos.UserID = "admin"
	
	s sc = ObjDiagnos.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -106
	}
	TCOMMIT
	q 1
}

/// Description:   增加目录节点数
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddDiagnosCategoryCount(id As %String) As %String
{
	s objItem = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(id)
	TSTART
	s objItem.DiagnosNum = objItem.DiagnosNum + 1
	s sc = objItem.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
	}
	TCOMMIT
	q 1
}

/// Desc:     删除病种
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_DIAGNOS","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteDiagnos(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID = argInJson.params.key
    s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnosJson(ID)
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
	elseif (strRes = -103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录总数保存失败",2)	
	}
	elseif (strRes = -103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","关联表保存失败",2)	
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

/// desc 删除病种
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteDiagnosJson(aID As %String)
{
	q:(aID="") -201
	TSTART
	s ObjMap = ##class(CF.EMR.DOC.Diagnos).%OpenId(aID)
	q:(ObjMap="") -102

	s result = ##Class(EMR.DOC.BL.BLDiagonsConfig).ReduceDiagnosCount(ObjMap.CategoryCode)
	if (result'="1")
	{
		TROLLBACK
		q -103
	}
	
	s stRtes = ##Class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnosDiseaseByCode(ObjMap.DiagnosCode)
	if (stRtes'="1")
	{
		TROLLBACK
		q -104
	}
	s sc = ##class(CF.EMR.DOC.Diagnos).%DeleteId(aID)
	TCOMMIT
	q 1
}

/// Description:   减少目录节点数
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod ReduceDiagnosCount(Code As %String) As %String
{
	s rowId = ""
	s rowId = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(Code,"U"),rowId))
	s objItem = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(rowId)
	
	TSTART
	s objItem.DiagnosNum = objItem.DiagnosNum - 1
	s sc = objItem.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
	}
	TCOMMIT
	q 1
}

/// Description:   删除病种并删除关联表已关联病种
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod DeleteDiagnosDiseaseByCode(Code As %String) As %String
{
	s strRes ="-1"
	TSTART
	s strMark = "1"
	s rowId = ""
	for {
		s rowId = $o(^CF.EMR.DOC.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(Code,"U"),rowId))
		s objItem = ##Class(CF.EMR.DOC.DiagnosDisease).%OpenId(rowId)
		q:(objItem = "")
		s objItem.IsExist = 0
		s sc = objItem.%Save()
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

/// Desc:       更新病种
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_DIAGNOS","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateDiagnos(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).UpdateDiagnosJson(argInJson,.argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)
	}
	elseif (strRes = -103)
	{  	
		q ..SetOutMessage(argOutMessage,"ERROR","病种不能为空",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","病种不存在",2)
	}
	elseif (strRes = -105)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能重复",2)
	}
	elseif (strRes = -106)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","保存失败",2)
	}
	elseif (strRes = -107)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","修改关联表失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新病种
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:    
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateDiagnosJson(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s id= argInJson.params.ID
	q:(id= "") -101
	s Code= argInJson.params.DiagnosCode
	q:(Code= "") -102
	s Name= argInJson.params.DiagnosName
	q:(Name= "") -103
	
	
	s params = argInJson.params
	
	TSTART
	s ObjDiagnos=##class(CF.EMR.DOC.Diagnos).%OpenId(id)
	if ('ObjDiagnos)
		{
		q 104
	}
	
	if (ObjDiagnos.DiagnosCode '= Code) {
		s seq = ""
		s seq = $o(^CF.EMR.DOC.DiagnosCategoryI("IdxCategoryCode"," "_$zcvt(Code,"U"),seq))
		s obj = ##Class(CF.EMR.DOC.DiagnosCategory).%OpenId(seq)
		q:(obj '= "" ) -105
	
		s diagnosId = ""
		s diagnosId = $o(^CF.EMR.DOC.DiagnosI("IdxDiagnosCode"," "_$zcvt(Code,"U"),diagnosId))
		s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(diagnosId)
		q:(obj '= "") -105
	}
	
	s result = ##Class(EMR.DOC.BL.BLDiagonsConfig).UpdateDiagnosDiseaseByCode(argInJson,ObjDiagnos.DiagnosCode)
	q:(result '= "1") -107
	
    s ObjDiagnos.DiagnosCode = Code	
	s ObjDiagnos.DiagnosName = Name
	s ObjDiagnos.Status = params.Status
 	s sc = ObjDiagnos.%Save()
 	
 	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -106
	}
	TCOMMIT
	q 1
}

/// Description:   修改病种后修改关联表已关联病种
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod UpdateDiagnosDiseaseByCode(argInJson As %DynamicAbstractObject, Code As %String) As %String
{
	s strRes ="-1"
	TSTART
	s strMark = "1"
	s rowId = ""
	for {
		s rowId = $o(^CF.EMR.DOC.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(Code,"U"),rowId))
		s objItem = ##Class(CF.EMR.DOC.DiagnosDisease).%OpenId(rowId)
		q:(objItem = "")
		s objItem.DiagnosCode = argInJson.params.DiagnosCode
		s objItem.DiagnosName = argInJson.params.DiagnosName
		s sc = objItem.%Save()
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

/// Desc:       获取所有诊断数据
/// Creator:    zhangzheyi
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_DISEASE_BYPAGESIZE","args":{}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDiseaseByPagesize(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argData = ##class(%DynamicObject).%New()
    s current = argInJson.params.current
	s pageSize = argInJson.params.pageSize
	s argData.searchValue = argInJson.params.searchValue
	s argData.current = $CASE(current,"":1,:current)
	s argData.pageSize = $CASE(pageSize,"":20,:pageSize)
	
	s argData.idxStart= argData.pageSize *(argData.current - 1) +1
	s argData.idxLast= argData.idxStart + argData.pageSize -1
    
    
    if (argData.searchValue = "") {
		s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).GetDiseaseByPagesizeJson(argData,.argOutData)
	}else {
		s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).GetDiseaseByValue(argData,.argOutData)
	}
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

/// Desc:       获取所有诊断数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACCTLocsJson(.argOutData)
ClassMethod GetDiseaseByPagesizeJson(argData As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s SearchText = argData.searchValue
	s jsonArrLoc = ##class(%DynamicArray).%New()
	
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.BLDiagonsConfig:GetDisease")
	d result.Execute()
	
	s num = ""
	&sql(SELECT count(*) into num FROM SQLUser.MRC_ICDDx )
	
	q:(result = "") "-1"
	s startPage = argData.idxStart
	s endPage = argData.idxLast
	s count = 1 
	While result.Next() 
	{
		s jsonLoc  = ##class(%DynamicObject).%New()
		s jsonLoc.ID = result.GetDataByName("MRCID_RowId")
		s jsonLoc.key = result.GetDataByName("MRCID_ICD9CM_Code")
	 	s jsonLoc.title = result.GetDataByName("MRCID_ShortDesc")	
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
	s jsonObj.total = num
	s jsonObj.list = jsonArrLoc
	
	d jsonObj.%ToJSON(argOutData)
	q strRes
}

/// Desc:       根据查询条件获取诊断数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACUser).GetRBACCTLocsJson(.argOutData)
ClassMethod GetDiseaseByValue(argData As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s SearchText = argData.searchValue
	s jsonArrLoc = ##class(%DynamicArray).%New()
	
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.BLDiagonsConfig:GetDisease")
	d result.Execute()
	q:(result = "") "-1"
	s count = 1 
	While result.Next() 
	{
		s jsonLoc  = ##class(%DynamicObject).%New()
		s jsonLoc.ID = result.GetDataByName("MRCID_RowId")
		s jsonLoc.key = result.GetDataByName("MRCID_ICD9CM_Code")
	 	s jsonLoc.title = result.GetDataByName("MRCID_ShortDesc")
	 	continue:($find(jsonLoc.title,SearchText) = 0) 	
		d jsonArrLoc.%Push(jsonLoc)	
		s count = count + 1
        
	}
	s jsonObj  = ##class(%DynamicObject).%New()		
	s jsonObj.current = argData.current
	s jsonObj.pageSize = count - 1
	s jsonObj.total = count - 1
	s jsonObj.list = jsonArrLoc
	
	d jsonObj.%ToJSON(argOutData)
	q strRes
}

Query GetDisease(ID As %String) As %SQLQuery
{
	SELECT MRCID_RowId,MRCID_ShortDesc,MRCID_ShortDesc,MRCID_ICD9CM_Code FROM SQLUser.MRC_ICDDx
}

/// Desc:       根据病种Code查询已关联诊断数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_SEARCH_DISEASEBYDIAGNOS", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSearchDiseaseByDiagnos(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s Code = argInJson.params.Code
	s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiseaseByDiagnosJson(Code,.argOutData)	
	if (strRes = "1")
	{ 	
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据病种Code查询已关联诊断数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchDiseaseByDiagnosJson(Code As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(Code = "" ) -101
	s jsonArry = ##class(%DynamicArray).%New()
	s rowID = ""
	for {
			s rowID = $o(^CF.EMR.DOC.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(Code,"U"),rowID))
			q:(rowID = "")		
			s obj = ##Class(CF.EMR.DOC.DiagnosDisease).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0") )
			
			s jsonItem  = ##class(%DynamicObject).%New()
			s jsonItem.key = obj.%Id()
			s jsonItem.ID = obj.%Id()	
        	s jsonItem.DiagnosCode = obj.DiagnosCode
        	s jsonItem.DiagnosName = obj.DiagnosName
        	s jsonItem.ICDCode = obj.ICDCode
        	s jsonItem.ICDID = obj.ICDID
        	s jsonItem.ICDName = obj.ICDName
			d jsonArry.%Push(jsonItem)
		
	}
	d jsonArry.%ToJSON(argOutData)
	q strRes
}

/// Desc:       添加病种和诊断关联数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_DIAGNOS_ANDDISEASE","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDiagnosAndDisease(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes=##class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnosAndDiseaseJson(argInJson)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Description:   添加病种和诊断关联数据
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddDiagnosAndDiseaseJson(argInJson As %DynamicAbstractObject) As %String
{
	s strRes = "1"
	s id = argInJson.params.ID
	q:id="" "-1^病种ID不能为空"
	s list = argInJson.params.list
	s Size = list.%Size()
	TSTART
	for i=0:1:(Size - 1) 
	{		
		s item = list.%Get(i)
		s diseaseID = item.diseaseID
		s:(diseaseID="") strRes="-1^诊断ID不能为空"
		q:(diseaseID = "" ) 
		
		s obj = ##Class(CF.EMR.DOC.Diagnos).%OpenId(id)
		s:(obj="") strRes="-1^病种不存在"
		q:(obj = "") 
		
		s objMRCID = ##Class(User.MRCICDDx).%OpenId(diseaseID)
		s:(obj="") strRes="-1^诊断不存在"
		q:(objMRCID = "") 
		
		s rowID =""
		s rowID = $o(^CF.EMR.DOC.DiagnosDiseaseI("IdxDiagnosCodeAndICDCode"," "_$zcvt(obj.DiagnosCode,"U")," "_objMRCID.MRCIDCode,rowID))
		s objDiagnosShip = ##Class(CF.EMR.DOC.DiagnosDisease).%OpenId(rowID)
		s:((objDiagnosShip '= "") && (objDiagnosShip.IsExist = 1)) strRes="-1^选择诊断中有已关联诊断"
		q:((objDiagnosShip '= "") && (objDiagnosShip.IsExist = 1)) 

		s ObjDiagnosDisease=##class(CF.EMR.DOC.DiagnosDisease).%New()
			
		s ObjDiagnosDisease.DiagnosCode = obj.DiagnosCode
		s ObjDiagnosDisease.DiagnosName = obj.DiagnosName	
		s ObjDiagnosDisease.ICDCode = objMRCID.MRCIDCode
		s ObjDiagnosDisease.ICDID = objMRCID.%Id()
		s ObjDiagnosDisease.ICDName = objMRCID.MRCIDDesc
		s ObjDiagnosDisease.IsExist = 1

		s sc = ObjDiagnosDisease.%Save()
		
		if ('$$$ISOK(sc))
		{
			s strRes="-1^保存失败"
		}
	}
	if (strRes'="1")
	{
		TROLLBACK
	}	
	else
	{
		TCOMMIT
	}

	q strRes
}

/// Desc:     	删除病种已关联诊断数据
/// Creator:    zhangzheyi
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_DIAGNOS_ANDDISEASE","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteDiagnosAndDisease(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

    s arrIDS = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnosAndDiseaseJson(arrIDS)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入用户ID数组",2)
	}else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 删除病种已关联诊断数据
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteDiagnosAndDiseaseJson(arrIDs As %String)
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
		s objDisease = ##class(CF.EMR.DOC.DiagnosDisease).%OpenId(strID)
		if (objDisease="") 
		{
			s strMark="-1"
			q
		}
		&sql(DELETE FROM CF_EMR_DOC.DiagnosDisease WHERE ID=:strID)

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
