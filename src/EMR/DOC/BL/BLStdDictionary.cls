Class EMR.DOC.BL.BLStdDictionary Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取基础字典数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_ALL_STDDIC", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetALLStdDic(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argData  = ##class(%DynamicObject).%New()
	s argData.Code = argInJson.params.Code
	s argData.Name = argInJson.params.Name
	s argData.DicCodeCol = argInJson.params.DicCodeCol
	
	s current = argInJson.params.current
	s pageSize = argInJson.params.pagesize
	s argData.current = $CASE(current,"":1,:current)
	s argData.pageSize = $CASE(pageSize,"":20,:pageSize)
	
	s argData.idxStart= argData.pageSize *(argData.current - 1) +1
	s argData.idxLast= argData.idxStart + argData.pageSize -1
	if ((argData.Code = "") && (argData.Name = "") &&(argData.DicCodeCol = "") )
	{
		s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).GetALLStdDicJson(argData,.argOutData)
	} else {
		s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).GetSearchStdDicJson(argData,.argOutData)
	}
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","查询失败",2)
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

/// Desc:       获取基础字典数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetALLStdDicJson(argData As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s startPage = argData.idxStart
	s endPage = argData.idxLast
	s count = 1
	s jsonArr = ##class(%DynamicArray).%New()
	s result =  ##class(%ResultSet).%New("EMR.DOC.BL.BLStdDictionary:GetStdDicAll")
	d result.Execute()
	s strRes = "101"
	q:(result="") strRes
	s index = 1
	While result.Next() 
		{
			s jsonItem  = ##class(%DynamicObject).%New()
			s IsExist = result.GetDataByName("IsExist")
			
	   		s jsonItem.Id =  result.GetDataByName("ID")
	   		s jsonItem.Code = result.GetDataByName("Code")
        	s jsonItem.Description = result.GetDataByName("Description")
        	s jsonItem.DicAliasCol = result.GetDataByName("DicAliasCol")  
        	s jsonItem.DicCodeCol = result.GetDataByName("DicCodeCol")
        	s jsonItem.DicDescCol = result.GetDataByName("DicDescCol")
        	s jsonItem.IsRuleType = result.GetDataByName("IsRuleType")
        	s jsonItem.Name = result.GetDataByName("Name")
        	s jsonItem.RuleTypeTag = result.GetDataByName("RuleTypeTag")
        	s jsonItem.TableName = result.GetDataByName("TableName")
        	s jsonItem.ConditionCode = result.GetDataByName("ConditionCode")
        	s jsonItem.Condition =result.GetDataByName("Condition")
        	s jsonItem.IsDiagnosRuleType = result.GetDataByName("IsDiagnosRuleType")
        	s jsonItem.index = index
        	
        	;s:('result.GetDataByName("DicAliasCol")) jsonItem.DicAliasCol = ""
        	;s:('result.GetDataByName("RuleTypeTag")) jsonItem.RuleTypeTag = ""
        	;s:('result.GetDataByName("ConditionCode")) jsonItem.ConditionCode = ""
        	;s:('result.GetDataByName("Condition")) jsonItem.Condition = ""
       
	   	if (IsExist '= "0")
	   	{
		   	d jsonArr.%Push(jsonItem)
		   	s index = index + 1
		} 	
		
	}
	
	s num = ""
	&sql(select count(*)into num from CF_EMR_DOC.StdDictionary WHERE IsExist = "1")
	
	s jsonObj  = ##class(%DynamicObject).%New()	
	s jsonObj.current = argData.current
	s jsonObj.PageSize = argData.pageSize
	s jsonObj.total = num
	s jsonObj.list = jsonArr
	
	s strRes = "1"
	d jsonObj.%ToJSON(argOutData)
	q strRes
}

/// Desc:       基础字典查询
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetSearchStdDicJson(argData As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s Code = argData.Code
	s Name = argData.Name
	s DicCodeCol = argData.DicCodeCol
	

	s step =""
	s index = 1
	s jsonArr = ##class(%DynamicArray).%New()
	for {	
					
	 		s step = $o(^CF.EMR.DOC.StdDictionaryI("SequenceIndex",step))
	 		q:(step = "")
	 		s rowID= $o(^CF.EMR.DOC.StdDictionaryI("SequenceIndex",step,""))
	 		q:(rowID = "")
			s obj = ##Class(CF.EMR.DOC.StdDictionary).%OpenId(rowID)
			continue:((obj="") || (obj.IsExist = "0"))
			continue:($find(obj.Code,Code) = 0)
			continue:($find(obj.Name,Name) = 0) 
			continue:($find(obj.DicCodeCol,DicCodeCol) = 0)
			s jsonItem  = ##class(%DynamicObject).%New()
			
        	s jsonItem.Id =  obj.%Id()
	   		s jsonItem.Code = obj.Code
        	s jsonItem.Description = obj.Description
        	s jsonItem.DicAliasCol = obj.DicAliasCol
        	s jsonItem.DicCodeCol = obj.DicCodeCol
        	s jsonItem.DicDescCol = obj.DicDescCol
        	s jsonItem.IsRuleType = obj.IsRuleType
        	s jsonItem.Name = obj.Name
        	
        	if (obj.RuleTypeTag)
        	{
	       		s jsonItem.RuleTypeTag = obj.RuleTypeTag.%Id()
	        }
        	s jsonItem.TableName = obj.TableName
        	s jsonItem.ConditionCode = obj.ConditionCode
        	s jsonItem.Condition =obj.Condition
        	s jsonItem.IsDiagnosRuleType = obj.IsDiagnosRuleType
        	s jsonItem.index = index
        	
        	s:('jsonItem.DicAliasCol) jsonItem.DicAliasCol = ""
        	s:('jsonItem.RuleTypeTag) jsonItem.RuleTypeTag = ""
        	s:('jsonItem.ConditionCode) jsonItem.ConditionCode = ""
        	s:('jsonItem.Condition) jsonItem.Condition = ""
			
			s index = index + 1
		   	d jsonArr.%Push(jsonItem)
		   	
	}
	s jsonObj  = ##class(%DynamicObject).%New()		
	s jsonObj.current = argData.current
	s jsonObj.PageSize = index - 1
	s jsonObj.total = index - 1
	s jsonObj.list = jsonArr
	
	s strRes = "1"
	d jsonObj.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取所有字典数据
/// Creator:    duan
/// CreateDate: 2021-04-07
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BLStdDictionary","GetStdDicAll")
Query GetStdDicAll() As %SQLQuery
{
	SELECT * FROM CF_EMR_DOC.StdDictionary ORDER BY Sequence
}

/// Desc:       获取字典数据总数
/// Creator:    duan
/// CreateDate: 2021-04-07
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BLStdDictionary","GetStdDicAll")
Query GetStdDicCount() As %SQLQuery
{
	SELECT count(*) FROM  CF_EMR_DOC.StdDictionary WHERE IsExist = "1"
}

/// Desc:       添加字典
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"ADD_STDDIC_DATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddStdDicData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).AddStdDicDataJson(argInJson,.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","代码不能为空",2)
	}
	elseif (strRes = -102)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","名称不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","字典代码列不能为空",2)
	}
	elseif (strRes = -104)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","病种规则类别不能为空",2)
	}
	elseif (strRes = -105)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","权限规则类别不能为空",2)
	}
	elseif (strRes = -106)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","对应表名不能为空",2)
	}
	elseif (strRes = -107)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","代码名不能重复",2)
	}
	elseif (strRes = -108)
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

/// Description:   添加字典
/// Table：        
/// Input：        ClassName：类名 Properties: 属性=Value, 逗号分隔 &&
/// Output：       
/// Return：        
/// test: d ##class(EMRservice.BL.BLDynamicConfigTable).AddRecord("EMRmeta_FrequentText.Chapter", "CTLocID=251@@Name=主诉@@Sequence=1")    
ClassMethod AddStdDicDataJson(argInJson As %DynamicAbstractObject, Properties As %String) As %String
{
	

	s Code = argInJson.params.Code
	q:(Code= "") -101
	s Name = argInJson.params.Name
	q:(Name= "") -102
	s DicCodecol = argInJson.params.DicCodeCol
	q:(DicCodecol= "") -103
	s IsDiagnosRuleType = argInJson.params.IsDiagnosRuleType
	q:(IsDiagnosRuleType= "") -104
	s IsRuleType = argInJson.params.IsRuleType
	q:(IsRuleType= "") -105
	s TableName = argInJson.params.TableName
	q:(TableName= "") -106
	
	s rowID = ""
	s rowID = $o(^CF.EMR.DOC.StdDictionaryI("CodeIndex"," "_Code,rowID))
	q:(rowID '= "") -107
	
	s params = argInJson.params
	
	TSTART
	s ObjStdDic=##class(CF.EMR.DOC.StdDictionary).%New()
	
	s ObjStdDic.Name = params.Name
	s ObjStdDic.Code = params.Code
	
    s ObjStdDic.Description = params.Description
    s ObjStdDic.DicAliasCol = params.DicAliasCol
    s ObjStdDic.DicCodeCol = params.DicCodeCol
    s ObjStdDic.DicDescCol = params.DicDescCol
    
    s ruleTypeID = params.RuleTypeTag
    if (ruleTypeID '= "") {
		s ObjRule = ##class(CF.EMR.DOC.EMRTSRuleType).%OpenId(ruleTypeID)
    	s ObjStdDic.RuleTypeTag = ObjRule
	}else {
		s ObjStdDic.RuleTypeTag = ruleTypeID	
	}
    
    
    s ObjStdDic.TableName = params.TableName
    s ObjStdDic.ConditionCode = params.ConditionCode
    s ObjStdDic.Condition =params.Condition
    
    s ObjStdDic.IsRuleType = params.IsRuleType
    s ObjStdDic.IsDiagnosRuleType = params.IsDiagnosRuleType
    
    s ObjStdDic.Sequence = +(^CF.EMR.DOC.StdDictionaryD)+1 
	s ObjStdDic.IsExist = "1"   

	s sc = ObjStdDic.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -108
	}
	TCOMMIT
	q 1
}

/// Desc:     删除字典数据
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "DELETE_STDDIC_DATA","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteStdDicData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

    s arrIDS = argInJson.params
    s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).DeleteStdDicDataJson(arrIDS)
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

/// desc 删除字典数据
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod DeleteStdDicDataJson(arrIDs As %String)
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
		s sc = ##class(CF.EMR.DOC.StdDictionary).%DeleteId(strID)
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

/// Desc:       更新基础字典数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"Action":"UPDATE_STDDIC_DATA","params":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateStdDicData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id= argInJson.params.Id
	s code= argInJson.params.Code
    s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).UpdateStdDicDataJson(id,code,argInJson,.argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","代码名不能为空",2)
	}
	elseif (strRes = -103)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","字典不存在",2)
	}
	elseif (strRes = -104)
	{  	
		q ..SetOutMessage(argOutMessage,"ERROR","代码名不能重复",2)
	}
	elseif (strRes = -105)
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

/// Desc:       更新基础字典数据
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:    
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DynamicConfigTable)GetDynamicConfigTableJson(argOutData)
ClassMethod UpdateStdDicDataJson(id As %String, code As %String, argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(id= "") -101
	q:(code= "" ) - 102
	s params = argInJson.params
	TSTART
	s ObjStdDic = ##class(CF.EMR.DOC.StdDictionary).%OpenId(id)
	q:(ObjStdDic = "") -103
	
	if (ObjStdDic.Code '= code) {
		s rowID = ""
		s rowID = $o(^CF.EMR.DOC.StdDictionaryI("CodeIndex"," "_code,rowID))
		q:(rowID '= "") -104
	}
	
	
	s ObjStdDic.Name = params.Name
	s ObjStdDic.Code = params.Code
	
    s ObjStdDic.Description = params.Description
    s ObjStdDic.DicAliasCol = params.DicAliasCol
    s ObjStdDic.DicCodeCol = params.DicCodeCol
    s ObjStdDic.DicDescCol = params.DicDescCol
    
    s ruleTypeID = params.RuleTypeTag
    if (ruleTypeID '= "") {
		s ObjRule = ##class(CF.EMR.DOC.EMRTSRuleType).%OpenId(ruleTypeID)
    	s ObjStdDic.RuleTypeTag = ObjRule
	}else {
		s ObjStdDic.RuleTypeTag = ruleTypeID	
	}
   
    
    s ObjStdDic.TableName = params.TableName
    s ObjStdDic.Condition =params.Condition
    s ObjStdDic.ConditionCode = params.ConditionCode
   
    
    s ObjStdDic.IsRuleType = params.IsRuleType
    s ObjStdDic.IsDiagnosRuleType = params.IsDiagnosRuleType
    s sc = ObjStdDic.%Save()
 	
 	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -105
	}
	TCOMMIT
	q 1
}

/// Desc:     更换基础字典顺序
/// Creator:    duan
/// CreateDate: 2021-06-22
/// Input:      argArray  命令参数 {"action": "EXCHANGE_STDDIC_ORDER","params":{"id":"6"},"product": "GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod ExchangeStdDicOrder(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s oldStdId = argInJson.params.oldStdictionaryId
	s newStdId = argInJson.params.newStdictionaryId 
    s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).ExchangeStdDicOrderJson(oldStdId,newStdId)
	 ///output 成功 1 失败 -201 参数未传 -101 删除失败 -102 数据不存在
	if (strRes = 1)
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	     q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 更换基础字典顺序
/// input aID 关联ID
/// output 成功 1 失败 -201 关联术语id未传 -202 数据元标识符未传 -203 映射list不能为空 -302 数据元值域关联ID不存在
ClassMethod ExchangeStdDicOrderJson(oldStdId As %String, newStdId As %String)
{
	s strRes=""
	q:((oldStdId="")||(newStdId="")) "-1^字典id不能为空"
	s newStdObj=##class(CF.EMR.DOC.StdDictionary).%OpenId(newStdId)
	q:newStdObj="" "-1^字典不存在"
	s oldStdObj=##class(CF.EMR.DOC.StdDictionary).%OpenId(oldStdId)
	q:oldStdObj="" "-1^字典不存在"
	s seq=newStdObj.Sequence
	//下移
	if (newStdObj.Sequence>oldStdObj.Sequence)
	{
		for i=oldStdObj.Sequence+1:1:newStdObj.Sequence
		{
			s rowId=$o(^CF.EMR.DOC.StdDictionaryI("SequenceIndex",i,""))
			continue:rowId=""
			s obj=##class(CF.EMR.DOC.StdDictionary).%OpenId(rowId)
			s obj.Sequence=obj.Sequence-1
			d obj.%Save()
		}
	}
	else
	{
		for i=oldStdObj.Sequence-1:-1:newStdObj.Sequence
		{
			s rowId=$o(^CF.EMR.DOC.StdDictionaryI("SequenceIndex",i,""),-1)
			continue:rowId=""
			s obj=##class(CF.EMR.DOC.StdDictionary).%OpenId(rowId)
			s obj.Sequence=obj.Sequence+1
			d obj.%Save()
		}	
	}
	s oldStdObj.Sequence=seq
	s sc= oldStdObj.%Save()
	if ($$$ISOK(sc))
	{
		s strRes=1
	}
	q strRes
}

/// Desc:       查询所有规则类别
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_TS_RULETYPE", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTSRuleType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##Class(EMR.DOC.BL.BLStdDictionary).GetTSRuleTypeJson(.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = -101)
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       查询所有规则类别
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetTSRuleTypeJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s result =  ##class(%ResultSet).%New("EMR.DOC.BL.BLStdDictionary:GetAllRuleType")
	d result.Execute()
	s strRes = "101"
	q:(result="") strRes
	While result.Next() {
			s jsonItem  = ##class(%DynamicObject).%New()
	   		s jsonItem.value =  result.GetDataByName("ID")
	   		s jsonItem.label = result.GetDataByName("Name")
		   	d jsonArr.%Push(jsonItem)
	}
	s strRes = "1"
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       查询所有规则类别
/// Creator:    duan
/// CreateDate: 2021-04-07
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.BLStdDictionary","GetStdDicAll")
Query GetAllRuleType() As %SQLQuery
{
	SELECT * FROM CF_EMR_DOC.EMRTSRuleType
}

}
