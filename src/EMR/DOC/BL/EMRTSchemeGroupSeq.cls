/// 名称:	EMR.DOC.BL.EMRTSchemeGroupSeq
/// 描述:	导航方案排序科室分组表 业务类
/// 编写者：ningyanghong
/// 编写日期: 2021-10-27
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeGroupSeq Extends EMR.DOC.COM.ActionBase
{

/// Desc:       新增导航方案排序（科室）分组
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  命令参数{"action":"ADD_SECHEME_GROUPSEQ",params:{code:"",title:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddSchemeGroupSeq(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO=##class(EMR.DOC.DTO.EMRTSchemeGroupSeq).%New()
	s argDTO.GroupCode=argInJson.params.code
	s argDTO.GroupName=argInJson.params.title
	s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).AddSchemeGroupSeqJson(argDTO)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif (strRes = "201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","该分组编码已存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       修改导航方案排序（科室）分组
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  命令参数{"action":"UPDATE_SCHEME_GROUP",params:{code:"",title:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateSchemeGroupData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO=##class(EMR.DOC.DTO.EMRTSchemeGroupSeq).%New()
	s argDTO.GroupCode=argInJson.params.code
	s argDTO.GroupName=argInJson.params.title
	s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).UpdateSchemeGroupDataJson(argDTO)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif (strRes = "201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","该分组编码不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       新增项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  命令参数{"action":"ADD_SECHEME_GROUPSEQ",params:{code:"",title:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddItem(objItem As CF.EMR.DOC.EMRTSchemeItem)
{
	q:(objItem="") "-200"
	// 获取所有分类code 新增
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeGroup")
	d result.Execute()
	While result.Next() 
	{
     	s rowID =result.GetDataByName("ID")
     	s objGroup=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(rowID)
     	s code=objGroup.GroupCode
     	s name=objGroup.GroupName
     	s jsonItem = ##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%New()
     	s jsonItem.GroupName=name
     	s jsonItem.GroupCode=code
     	s jsonItem.EMRTSchemeItem=objItem
     	s sequence=""
     	&sql(select max(Sequence) into :sequence from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code)
     	s jsonItem.Sequence=sequence+1
     	d jsonItem.%Save()
	}
	q "1"
}

/// Desc:       删除项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  命令参数{"action":"ADD_SECHEME_GROUPSEQ",params:{code:"",title:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteItem(ID As %String)
{
	// itemID
	q:(ID="") "-200"
	
	
	// 获取所有分类code 
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeGroup")
	d result.Execute()
	While result.Next() 
	{
     	s rowID =result.GetDataByName("ID")
     	s objGroup=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(rowID)
     	s code=objGroup.GroupCode
     	s rowID1=""
     	&sql(select ID into :rowID1 from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code and EMRTSchemeItem = :ID)
     	continue:(rowID="")
     	s objItem=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(rowID1)
     	s Sequence=objItem.Sequence
     	s sc = ##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%DeleteId(rowID1)
     	if ($$$ISOK(sc))
		{
			// 排序修改
		    s countID=""
		    &sql(select count(*) into :countID from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code)
		    for i=Sequence+1:1:countID
		    {
			  s newSeq=i-1
			  &SQL(update CF_EMR_DOC.EMRTSchemeGroupSeq set Sequence =:newSeq where Sequence= :i and GroupCode = :code )
		    }
		
		}
     	
	}
	q "1"
}

/// Desc:       获取分组列表
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  命令参数{"action":"GET_SCHEMEGROUP_DATA","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeGroupData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).GetSchemeGroupDataJson(argOutData)
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

/// Desc:       获取分组项目列表
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  命令参数{"action":"GET_SCHEMEGROUP_ITEMS","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeGroupItemsData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ACode = argInJson.params.code
	s ASchemeID=argInJson.params.schemeID
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).GetSchemeGroupItemsDataJson(ACode,ASchemeID,argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分组编码不存在",2)
	}
	elseif (strRes="102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif (strRes="103")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","导航方案不存在",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除分组
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      argArray  	命令参数 {"action":"DELETE_SECHEME_GROUPSEQ","params":{code："" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功："1",失败：-1
ClassMethod DelSchemeGroupSeq(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ACode = argInJson.params.code
	s res=##class(EMR.DOC.BL.EMRTSchemeGroupSeq).DeleteSchemeGroupSeqJson(ACode)
	if (res = "1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (res="101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组编码不存在",2)
		
	}
	elseif (res="102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       项目排序
/// Creator:    ningyanghong
/// CreateDate: 2021-10-28
/// Input:      argArray  	命令参数 {"action":"UPDATE_SCHEMEGROUPITEM_SEQUENCE","params":{id:"",sequence:"",code:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回获取的数据,失败：-1
ClassMethod UpDateSchemeGroupItemSeq(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objScheme =##class(EMR.DOC.DTO.EMRTSchemeGroupSeq).%New()
	s objScheme.ID = argInJson.params.id
	s objScheme.Sequence = argInJson.params.sequence
	s objScheme.GroupCode=argInJson.params.code
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).UpSchemeGroupItemSeqJson(objScheme)
	if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目不存在",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分组编码不存在",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取分组列表
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).GetSchemeGroupDataJson(.argOutData)
ClassMethod GetSchemeGroupDataJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeGroup")
	d result.Execute()
	While result.Next() 
	{
     	s rowID =result.GetDataByName("ID")
     	s objGroup=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(rowID)
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.code=objGroup.GroupCode
     	s jsonItem.title=objGroup.GroupName
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取分组项目列表
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).GetSchemeGroupDataJson(.argOutData)
ClassMethod GetSchemeGroupItemsDataJson(code As %String, SchemeID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "102"
	q:(code="")||(SchemeID="") strRes
	
	//统计GroupCode=code的测试内容条数
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code)
	if (count=0)
	{
		s strRes="101"
		q strRes
	}
	//展现方案表（病历归档方案 or 住院在院方案）
	s objScheme=##class(CF.EMR.DOC.EMRTScheme).%OpenId(SchemeID)
	q:(objScheme="") "103"
	
	s jsonArr = ##class(%DynamicArray).%New()
	//按顺序查询GroupCode=Code的所有ID（CF.EMR.DOC.EMRTSchemeGroupSeq）
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeItemsByCode")
	d result.Execute(code)
	While result.Next() 
	{
     	s rowID =result.GetDataByName("ID")
     	s objGroup=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(rowID)
     	continue:objGroup.EMRTSchemeItem=""
     	s objItem=objGroup.EMRTSchemeItem
     	continue:(objItem="")||(objItem.EMRTScheme'=objScheme)
     	s objCat=objItem.DataID
     	continue:(objCat="")
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.name=objCat.Name
     	s jsonItem.sequence=objGroup.Sequence
     	s jsonItem.EMRName=objCat.EMRName
     	s jsonItem.code=objGroup.GroupCode
     	s jsonItem.title=objGroup.GroupName
     	s jsonItem.id=rowID
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       删除分组
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).DeleteSchemeGroupSeqJson()
ClassMethod DeleteSchemeGroupSeqJson(code As %String)
{
	q:(code ="") "102"
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code)
	if (count=0)
	{
		s strRes="101"
		q strRes
	}
    s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeItemsByCode")
	d result.Execute(code)
	While result.Next() 
		{
			s strRes="-1"
     		s rowID =result.GetDataByName("ID")
     		s sc=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%DeleteId(rowID)
			s:($$$ISOK(sc)) strRes = "1"
		}
	q strRes
}

/// Desc:       新增导航方案排序（科室）分组
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).AddSchemeGroupSeqJson(.argOutData)
ClassMethod AddSchemeGroupSeqJson(ByRef argDTO As EMR.DOC.DTO.EMRTSchemeGroupSeq) As %String
{
	s strRes = "101"
	/// 检查必填项
	q:(argDTO.GroupName="")||(argDTO.GroupCode="") strRes
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :argDTO.GroupCode)
	if (count>0)
	{
		s strRes="201"
		q strRes
	}
	else
	{
			
		s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeItems")
		d result.Execute()
		While result.Next() 
		{
			s strRes="-1"
			s objGroup=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%New()
     		s objGroup.GroupCode=argDTO.GroupCode
     		s objGroup.GroupName=argDTO.GroupName
     		s rowID =result.GetDataByName("ID")
     		s objItem=##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(rowID)
     		s objGroup.EMRTSchemeItem=objItem
     		s objGroup.Sequence=objItem.Sequence
     		s sc = objGroup.%Save()
			s:($$$ISOK(sc)) strRes = "1"
		}
		q strRes
	
	}
}

/// Desc:       修改导航方案排序（科室）分组
/// Creator:    ningyanghong
/// CreateDate: 2021-10-27
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).AddSchemeGroupSeqJson(.argOutData)
ClassMethod UpdateSchemeGroupDataJson(ByRef argDTO As EMR.DOC.DTO.EMRTSchemeGroupSeq) As %String
{
	s strRes = "101"
	/// 检查必填项
	q:(argDTO.GroupName="")||(argDTO.GroupCode="") strRes
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :argDTO.GroupCode)
	if (count=0)
	{
		s strRes="201"
		q strRes
	}
	else
	{
			
		&sql(UPDATE CF_EMR_DOC.EMRTSchemeGroupSeq set GroupName = :argDTO.GroupName where GroupCode = :argDTO.GroupCode)
		q "1"
	
	}
}

/// Desc:       项目排序
/// Creator:    ningyanghong
/// CreateDate: 2021-10-28
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      w ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).UpSchemeGroupItemSeqJson()
ClassMethod UpSchemeGroupItemSeqJson(schemeGroup As EMR.DOC.DTO.EMRTSchemeGroupSeq) As %String
{
	s strRes = "-200"
	q:(schemeGroup.Sequence="")||(schemeGroup.ID="")||(schemeGroup.GroupCode="") strRes
	s strRes = "-101"
	s objSchemeGroupItem = ##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(schemeGroup.ID)
	q:(objSchemeGroupItem="") strRes
	s groupCode=objSchemeGroupItem.GroupCode
	s itemId=objSchemeGroupItem.EMRTSchemeItem.EMRTScheme.%Id()
	s strRes="-102"
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :schemeGroup.GroupCode)
	q:(count=0) strRes
	
	s oldSeq=objSchemeGroupItem.Sequence
	/// 前移
	if (oldSeq>schemeGroup.Sequence)
	{
		for i=(oldSeq-1):-1:schemeGroup.Sequence
		{
			s newSeq=i+1
			&sql(UPDATE CF_EMR_DOC.EMRTSchemeGroupSeq SET SEQUENCE=:newSeq where Sequence= :i and GroupCode = :groupCode and EMRTSchemeItem->EMRTScheme->ID=:itemId)
		}
	}else
	{
		for i=(oldSeq+1):1:schemeGroup.Sequence
		{
			s newSeq=i-1
			&sql(UPDATE CF_EMR_DOC.EMRTSchemeGroupSeq SET SEQUENCE=:newSeq where Sequence= :i and GroupCode = :groupCode and EMRTSchemeItem->EMRTScheme->ID=:itemId)
		}
	}
	s objSchemeGroupItem.Sequence=schemeGroup.Sequence
	s sc = objSchemeGroupItem.%Save()
	q:($$$ISOK(sc)) "1"
}

Query GetSchemeItems() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeItems, SqlProc ]
{
	select ID from CF_EMR_DOC.EMRTSchemeItem order by ID
}

Query GetSchemeItemsByCode(code As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeItemsByCode, SqlProc ]
{
	select ID from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code order by Sequence
}

Query GetSchemeGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeGroup, SqlProc ]
{
	select ID from CF_EMR_DOC.EMRTSchemeGroupSeq group by GroupCode
}

Query GetSchemeItemsByCodeAndSequence(code As %String, sequence As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Item:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeItemsByCodeAndSequence, SqlProc ]
{
	select ID,EMRTSchemeItem from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :code and Sequence = :sequence order by ID
}

}
