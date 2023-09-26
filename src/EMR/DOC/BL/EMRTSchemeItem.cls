/// 名称:	CF.EMR.DOC.EMRTSchemeItem
/// 描述:	导航方案项目表 业务类
/// 编写者：ningyanghong
/// 编写日期: 2021-10-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeItem Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取所有业务活动记录分类
/// Creator:    ningyanghong
/// CreateDate: 2021-10-20
/// Input:      argArray  命令参数{"action":"GET_SCHEMEITEM_DATA","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeItemsData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItem).GetSchemeItemsDataJson(argOutData)
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

/// Desc:       新增项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// Input:      argArray  命令参数
/// 							{	
/// 								"action":"ADD_SECHEME_ITEM",
/// 								"params":
/// 									{
/// 										scheme:"",// 病历导航方案
/// 										item:"", // 业务活动记录分类
/// 									},
/// 								"product":"GlobalEMR"
/// 							}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据 成功返回1 失败返回错误信息
ClassMethod AddSchemeItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO=##class(EMR.DOC.DTO.EMRTSchemeItem).%New()
	s argDTO.EMRTScheme=argInJson.params.scheme
	s argDTO.DataID=argInJson.params.item
	s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItem).AddSchemeItemJson(argDTO)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif (strRes = "102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","导航方案不存在",2)
	}
	elseif (strRes = "103")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","项目不存在",2)
	}
	elseif (strRes = "104")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","节点类型不存在",2)
	}
	elseif (strRes = "201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","项目已存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       修改项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// Input:      argArray  命令参数
/// 							{
/// 								"action":"UPDATE_SECHEME_ITEM",
/// 								"params":
/// 									{
/// 										"id":"",// 需要修改的项目id
/// 										"hisURL":"",// 修改的url数据
/// 										"hisParameter":"",// 参数
/// 									},
/// 								"product":"GlobalEMR"
/// 							}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据 成功返回1，失败返回错误信息
ClassMethod UpdateSchemeItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO=##class(EMR.DOC.DTO.EMRTSchemeItem).%New()
	s argDTO.ID=argInJson.params.id
	s argDTO.HISURL=argInJson.params.hisURL
	s argDTO.HISParameter=argInJson.params.hisParameter
	s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItem).UpdateSchemeItemJson(argDTO)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif (strRes = "102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","导航项目不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除项目
/// Creator:    Ning
/// CreateDate: 2021-10-21
/// Input:      argArray  	命令参数 
/// 						{
/// 								"action":"DELETE_SECHEME_ITEM",
/// 								"params":
/// 										{
/// 											"id"："" 
/// 										},
/// 								"product":"GlobalEMR"
/// 							}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功："1",失败：-1
ClassMethod DelSchemeItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s result = ""
	s AID = argInJson.params.id
	s res=##class(EMR.DOC.BL.EMRTSchemeItem).DeleteSchemeItemJson(AID)
	if (res = "1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (res="101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","项目不存在",2)
		
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

/// Desc:       获取导航分类项目
/// Creator:    Ning
/// CreateDate: 2021-10-21
/// Input:      argArray  	命令参数 {"action":"GET_SECHEME_ITEM","params":{id："" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
/// 						{
/// 								"id":"",// 导航分类项目id		
/// 								"name":"",// 导航分类项目名称
/// 								"emrName":"",// 导航分类项目业务名称
/// 								"documentID":"",// 导航分类项目关联业务活动记录分类id
/// 							"loc":"",// 导航分类项目关联的科室配置
/// 							"group":"",// 导航分类项目关联安全组配置
/// 							"hisURL":"",// hisURL配置
/// 								"hisParameter":"",// his参数配置
/// 							}
ClassMethod GetSchemeItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	TSTART	
	s result = ""
	s AID = argInJson.params.id
	s res=##class(EMR.DOC.BL.EMRTSchemeItem).GetSchemeItemJson(AID,argOutData)
	if (res = "1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (res="101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","导航分类不存在",2)
		
	}
	elseif (res="102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
Error
	TROLLBACK	
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       展现方案排序
/// Creator:    ningyanghong
/// CreateDate: 2021-10-11
/// Input:      argArray  	命令参数 {"action":"UPDATE_SCHEMEITEM_SEQUENCE","params":{id:"",sequence:"",scheme:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：返回1,失败：-1
ClassMethod UpDateSchemeItemSeq(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objScheme =##class(EMR.DOC.DTO.EMRTSchemeItem).%New()
	s objScheme.ID = argInJson.params.id
	s objScheme.Sequence = argInJson.params.sequence
	s objScheme.EMRTScheme=argInJson.params.scheme
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItem).UpSchemeItemSeqJson(objScheme)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","导航方案不存在",2)
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

/// Desc:       项目排序
/// Creator:    ningyanghong
/// CreateDate: 2021-10-25
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      w ##class(EMR.DOC.BL.EMRTSchemeItem).UpSchemeItemSeqJson()
ClassMethod UpSchemeItemSeqJson(AScheme As EMR.DOC.DTO.EMRTSchemeItem) As %String
{
	s strRes = "-200"
	q:(AScheme.Sequence="")||(AScheme.ID="")||(AScheme.EMRTScheme="") strRes
	s strRes = "-101"
	s objSchemeItem = ##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(AScheme.ID)
	q:(objSchemeItem="") strRes
	s strRes="-102"
	s objScheme=##class(CF.EMR.DOC.EMRTScheme).%OpenId(AScheme.EMRTScheme)
	q:(objScheme="") strRes
	s id=objScheme.%Id()
	s oldSeq=objSchemeItem.Sequence
	/// 前移
	if (oldSeq>AScheme.Sequence)
	{
		for i=(oldSeq-1):-1:AScheme.Sequence
		{
			s newSeq=i+1
			&SQL(update CF_EMR_DOC.EMRTSchemeItem set Sequence =:newSeq where Sequence= :i and EMRTScheme = :id )
		}
		
	}else
	{
		for i=(oldSeq+1):1:AScheme.Sequence
		{
			s newSeq=i-1
			&SQL(update CF_EMR_DOC.EMRTSchemeItem set Sequence =:newSeq where Sequence= :i and EMRTScheme = :id)
		}
	}
	s objSchemeItem.Sequence=AScheme.Sequence
	s sc = objSchemeItem.%Save()
	q:($$$ISOK(sc)) "1"
}

/// Desc:       获取所有业务活动记录分类
/// Creator:    ningyanghong
/// CreateDate: 2021-10-20
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeItem).GetSchemeItemsDataJson(.argOutData)
ClassMethod GetSchemeItemsDataJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	/// 获取文档目录type为业务活动记录分类的节点数据
	s jsonArr = ##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeItem:GetSchemeItemsData")
	d result.Execute()
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.id =result.GetDataByName("ID")
     	s jsonItem.name =result.GetDataByName("Name")
     	s jsonItem.EMRName=result.GetDataByName("EMRName")
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       新增项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeItem).AddSchemeItemJson(.argOutData)
ClassMethod AddSchemeItemJson(ByRef argDTO As EMR.DOC.DTO.EMRTSchemeItem) As %String
{
	s strRes = "101"
	/// 检查必填项
	q:(argDTO.EMRTScheme="")||(argDTO.DataID="") strRes
	s strRes="102"
	/// 导航方案分类是否存在
	s objScheme=##class(CF.EMR.DOC.EMRTScheme).%OpenId(argDTO.EMRTScheme)
	q:objScheme="" strRes
	s strRes="104"
	
	/// 节点类型
	s rowId = $o(^CF.EMR.DOC.TemplateCTypesI("IdxCode"," "_$zcvt("Classification","u"),""))
	q:rowId="" strRes
	s objType=##class(CF.EMR.DOC.TemplateCTypes).%OpenId(rowId)
	
	// 遍历截取ItemID
		for i=1:1:$l(argDTO.DataID,"^")
		{
			s ItemID=$p(argDTO.DataID,"^",i)
			q:(ItemID="")
			
			s ID=$p(ItemID,"||",1)
			q:(ID="")
			s count=0
			&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeItem where EMRTScheme = :argDTO.EMRTScheme and DataID = :ID)
			if (count=0)
			{
				
				s objSchemeItem=##class(CF.EMR.DOC.EMRTSchemeItem).%New()
				s objSchemeItem.DataID=##class(CF.EMR.DOC.TemplateCategory).%OpenId(ID)
				s objSchemeItem.EMRTScheme=objScheme
				s EMRTScheme=argDTO.EMRTScheme
				;s objSchemeItem.DataType=objType
				s sequence=0
				&sql(SELECT Max(Sequence) into :sequence FROM CF_EMR_DOC.EMRTSchemeItem where EMRTScheme = :argDTO.EMRTScheme)
				if (sequence)
				{
					s objSchemeItem.Sequence=sequence+1	
				}
				else
				{
					s objSchemeItem.Sequence=1
				}

				s sc = objSchemeItem.%Save()
				s:($$$ISOK(sc)) result = "1"
				// 新增科室排序分组项目
				d ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).AddItem(objSchemeItem)
				}
			}

	q "1"
}

/// Desc:       修改项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeItem).AddSchemeItemJson(.argOutData)
ClassMethod UpdateSchemeItemJson(ByRef argDTO As EMR.DOC.DTO.EMRTSchemeItem) As %String
{
	s strRes="101"
	q:(argDTO.ID="") strRes
	
	s strRes="102"
	s objSchemeItem=##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(argDTO.ID)
	q:(objSchemeItem="") strRes
	
	s objSchemeItem.HISURL=argDTO.HISURL
	s objSchemeItem.HISParameter=argDTO.HISParameter
	s sc = objSchemeItem.%Save()
	s:($$$ISOK(sc)) strRes = "1"
	q strRes
}

/// Desc:       删除项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.EMRTSchemeItem).DeleteSchemeItemJson()
ClassMethod DeleteSchemeItemJson(rowID As %String)
{
	q:(rowID ="") "102"
	for i=1:1:$l(rowID,"^")
		{
			
			s ID=$p(rowID,"^",i)
			q:(ID="")
			s objSchemeItem = ##Class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(ID)
			continue:(objSchemeItem="")
			s Sequence=objSchemeItem.Sequence
			s Scheme=objSchemeItem.EMRTScheme.%Id()
			
			
				// 排序修改
			
				s countID=0
				&sql(select count(*) into :countID from CF_EMR_DOC.EMRTSchemeItem where EMRTScheme = :Scheme)
				continue:(countID=0)
		 		for j=(Sequence+1):1:countID
		 		{
					 s newSeq=j-1
					&SQL(update CF_EMR_DOC.EMRTSchemeItem set Sequence =:newSeq where Sequence= :j and EMRTScheme = :Scheme )
				}
				d ##class(CF.EMR.DOC.EMRTSchemeItem).%DeleteId(ID)
		
				// 删除科室排序项目
				d ##class(EMR.DOC.BL.EMRTSchemeGroupSeq).DeleteItem(ID)
				
				// 删除科室、安全组绑定
	   			d ##Class(EMR.DOC.BL.EMRTSchemeItemRes).SaveSchemeItemLocJson(ID,"")
	   			d ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).SaveSchemeItemSSGroupJson(ID,"")
    		
		}
	
  q "1"
}

/// Desc:       获取导航分类项目
/// Creator:    ningyanghong
/// CreateDate: 2021-10-21
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///     w ##Class(EMR.DOC.BL.EMRTSchemeItem).GetSchemeItemJson()
ClassMethod GetSchemeItemJson(rowID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	q:(rowID ="") "102"
    s objSchemeItem = ##Class(CF.EMR.DOC.EMRTScheme).%OpenId(rowID)
	q:(objSchemeItem="") "101"
	s jsonArr = ##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeItem:GetSchemeItemsDataByScheme")
	d result.Execute(rowID)
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.id =result.GetDataByName("ID")
     	s dataID =result.GetDataByName("DataID") 
     	s jsonItem.sequence=result.GetDataByName("Sequence")
     	s objCat=##class(CF.EMR.DOC.TemplateCategory).%OpenId(dataID)
     	continue:(objCat="")
     	s jsonItem.name=objCat.Name
     	s jsonItem.emrName=objCat.EMRName
     	s jsonItem.documentID=dataID_"||CT"
     	s locStr=##Class(EMR.DOC.BL.EMRTSchemeItemRes).GetSchemeItemLocStrJson(jsonItem.id)
     	s ssgroupStr=##class(EMR.DOC.BL.EMRTSchemeItemSSGroup).GetSchemeItemSSGroupStrJson(jsonItem.id)
     	s jsonItem.loc=locStr
     	s jsonItem.group=ssgroupStr
     	s jsonItem.hisURL=result.GetDataByName("HISURL")
     	s jsonItem.hisParameter=result.GetDataByName("HISParameter")
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	q "1"
}

Query GetSchemeItemsData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,EMRName:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeItemsData, SqlProc ]
{
	select ID,Name,EMRName from CF_EMR_DOC.TemplateCategory where StructType = 1 order by ID
}

Query GetSchemeItemsDataByScheme(argScheme As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,DataID:%String,Sequence:%String,HISURL:%String,HISParameter:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeItemsDataByScheme, SqlProc ]
{
	select ID,DataID,Sequence,HISURL,HISParameter from CF_EMR_DOC.EMRTSchemeItem where EMRTScheme = :argScheme order by Sequence
}

}
