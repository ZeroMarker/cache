/// 名称:	EMR.DOC.BL.EMRTSchemeItemRes
/// 描述:	导航方案项目授权表 业务类
/// 编写者：Ningyanghong
/// 编写日期: 2021-10-18
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeItemRes Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取安全组列表
/// Creator:    ningyanghong
/// CreateDate: 2021-10-18
/// Input:      argArray  命令参数{"action":"GET_SSGROUP_LIST","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSSGroupData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemRes).GetSSGroupDataJson(argOutData)
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

/// Desc:       获取安全组列表
/// Creator:    ningyanghong
/// CreateDate: 2021-09-29
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeItemRes).GetSSGroupDataJson(.argOutData)
ClassMethod GetSSGroupDataJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeItemRes:GetAllSSGroup")
	d result.Execute()
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.key =result.GetDataByName("ID")
     	s jsonItem.title =result.GetDataByName("Description")
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = GetAllSSGroup, SqlProc ]
{
	select SSGRP_RowId,SSGRP_Desc from SQLUser.SS_Group order by SSGRP_Desc
}

/// Desc:       获取关联科室
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"GET_SCHEMEITEM_LOC","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeItemLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s itemID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemRes).GetSchemeItemLocJson(itemID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入项目ID",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取共同关联科室
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"GET_SCHEMEITEM_LOC","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeItemSameLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s itemID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemRes).GetSchemeItemSameLocJson(itemID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes="201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入项目ID",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       获取指定分组下的关联科室
/// Creator:    zhangxl
/// CreateDate: 2021-10-21
/// OutPut:     返回数据 成功：ID, 返回格式:locID1^locID2^locID3^..
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetTemplateGroupLocJson(strID,.argOutData)
ClassMethod GetSchemeItemSameLocJson(ItemID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="201"
	q:(ItemID="") strRes
	s LocIDStr = ""
	s objArr=##class(%DynamicArray).%New()
	
	s idLength=$l(ItemID,"^")
	s firstID=$p(ItemID,"^")
	;获取第一个id下的科室数据
	s arrayLoc=##class(%DynamicArray).%New()
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",firstID,curLocID))
		q:(curLocID="")
		s jsonLoc=curLocID_"^1"
		d arrayLoc.%Push(jsonLoc)
	}
	
	s size=arrayLoc.%Size()
	
	for i=2:1:idLength
	{
		s LocID = ""
		s navID=$p(ItemID,"^",i)
		for 
		{
			s LocID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",navID,LocID))
			q:(LocID="")
			
			for j=1:1:size
			{
				s l=j-1
				s id=$p(arrayLoc.%Get(l),"^")
				s num=$p(arrayLoc.%Get(l),"^",2)
				if (LocID=id)
				{
					s num=num+1
					d arrayLoc.%Set(l,id_"^"_num)
				}
			}
			
		
		}
	}
	for r=1:1:size
	{
		s objRes=##class(%DynamicObject).%New()
		s key="",title="",code=""
		s g=r-1
		s itemId=$p(arrayLoc.%Get(g),"^")
		s locID=$p(arrayLoc.%Get(g),"^",2)
		if (locID=idLength)
		{
			&sql(SELECT CTLOC_RowId into :key From SQLUser.CT_Loc Where CTLOC_RowID=:itemId)
			&sql(SELECT CTLOC_CODE into :code From SQLUser.CT_Loc Where CTLOC_RowID=:itemId)
			&sql(SELECT upper(CTLOC_Desc) into :title From SQLUser.CT_Loc Where CTLOC_RowID=:itemId)
			s objRes.key=key
			s objRes.title=title
			s objRes.Code=code
			d objArr.%Push(objRes)
		}
	}

	d objArr.%ToJSON(argOutData)

	q "1"
}

/// Desc:       获取指定分组下的关联科室
/// Creator:    zhangxl
/// CreateDate: 2021-10-21
/// OutPut:     返回数据 成功：ID, 返回格式:locID1^locID2^locID3^..
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetTemplateGroupLocJson(strID,.argOutData)
ClassMethod GetSchemeItemLocStrJson(ItemID As %String) As %String
{
	s strRes="201"
	q:(ItemID="") strRes
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",ItemID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemRes).%OpenId(RowID)
		
			d obj.%Close()
			s str=""
			&sql(select CTLOC_Desc  into :str from SQLUser.CT_Loc Where CTLOC_RowId=:curLocID )
			s LocIDStr=str
			
		}
		else
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemRes).%OpenId(RowID)

			d obj.%Close()
			s IDStr = ""
			&sql(select CTLOC_Desc  into :IDStr from SQLUser.CT_Loc Where CTLOC_RowId=:curLocID )
			s LocIDStr = LocIDStr_" "_IDStr
		}
	}
	s strRes = "1"
	q LocIDStr
}

/// Desc:       获取指定分组下的关联科室
/// Creator:    zhangxl
/// CreateDate: 2021-10-21
/// OutPut:     返回数据 成功：ID, 返回格式:locID1^locID2^locID3^..
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetTemplateGroupLocJson(strID,.argOutData)
ClassMethod GetSchemeItemLocJson(ItemID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="201"
	q:(ItemID="") strRes
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",ItemID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemRes).%OpenId(RowID)
		
			d obj.%Close()
			s LocIDStr = curLocID
		}
		else
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemRes).%OpenId(RowID)

			d obj.%Close()
			s LocIDStr = LocIDStr_"^"_curLocID
		}
	}
	s argInJson  = ##class(%DynamicObject).%New()
	s argInJson.Group = ItemID
	s argInJson.LocIDStr = LocIDStr
	d argInJson.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       保存科室配置信息
/// Creator:    huhao
/// CreateDate: 2023-4-3
/// Input:      argArray  命令参数 
/// 							{
/// 									"action":"SAVE_SCHEMEITEM_LOC",
/// 									"params":[
/// 											{
/// 												"id":"67",
/// 												"locStr":"259^262",
/// 											},{
/// 												"id":"68",
/// 												"locStr":"259^261",
/// 												}]
/// 									"product":"GlobalEMR"
/// 								}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据 成功返回1，失败返回错误信息
ClassMethod SaveSchemeItemLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemRes).SaveSchemeItemLocJson(argInJson.params)
    if (strRes = "1")
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       保存科室配置信息
/// Creator:    huhao
/// CreateDate: 2023-4-3
/// Input:      
/// OutPut:     返回数据 成功：ID,
/// 					 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod SaveSchemeItemLocJson(arr As %DynamicArray)
{
	s strRes="1"
	s count=arr.%Size()
	q:count=0
	TSTART
	for i=0:1:count-1
	{
		s obj=arr.%Get(i)
		s id=obj.id
		s locIdStr=obj.locIdStr
		&sql(delete CF_EMR_DOC.EMRTSchemeItemRes WHERE EMRTSchemeItem=:id)
		for j=1:1:$l(locIdStr,"^")
		{
			s itemId=$p(locIdStr,"^",j)
			s objNewGroup=##class(CF.EMR.DOC.EMRTSchemeItemRes).%New()
			s objItem=##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(id)
			s objNewGroup.EMRTSchemeItem=objItem
			s objNewGroup.CTLocID=itemId
			s sc = objNewGroup.%Save()
			if ('$$$ISOK(sc))
			{
				s strRes="-1^保存失败"
				TROLLBACK
			}
			
		}
	}
	TCOMMIT
	q strRes
}

/// Desc:       目录与科室关联
/// Creator:    zhangxl
/// CreateDate: 2021-8-10
/// Input:      CateID-目录ID,LocID-科室ID
/// OutPut:     1-关联成功 0-关联失败
/// Debug:	
ClassMethod Add(ItemID As %String, LocID As %String) As %Integer
{
	s ret = 1
	s obj = ##class(CF.EMR.DOC.EMRTSchemeItemRes).%New()
	s objCat = ##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(ItemID)
	s obj.EMRTSchemeItem = objCat
	s obj.CTLocID= LocID
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	q ret
}

/// Desc:       解除目录与科室关联
/// Creator:    zhangxl
/// CreateDate: 2021-8-10
/// Input:      RowID
/// OutPut:     1-关联成功 0-关联失败
/// Debug:	
ClassMethod Delete(RowID As %String) As %Integer
{
	s ret = 1
	q:(RowID="") ret
	
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(CF.EMR.DOC.EMRTSchemeItemRes).%OpenId(RowID)
	
	if '(obj.%DeleteId(RowID))
	{
		s ret = 0	
	}
	
	d obj.%Close()
	
	q ret
}

/// Desc:       检查目录是否已经和科室关联
/// Creator:    zhangxl
/// CreateDate: 2021-8-10
/// Input:      ACateID-目录ID
/// OutPut:     1-已关联 0-无关联
ClassMethod CheckCateIDExist(itemID As %String) As %Integer
{
	s ret = 0
	q:(itemID="") ret
	
	s RowID = $o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",itemID,""))
	if (+RowID>0)
	{
		s ret = 1
	}
	q ret
}

/// Desc:       批量删除共同科室配置
/// Creator:    huhao
/// CreateDate: 2023-4-3
/// Input:      argArray  命令参数 {"action":"DELETE_SCHEMEITEM_LOC","params":[{"id":"67","locStr":"259^262"},{"id":"68","locStr":"259^261"}],"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据 成功返回1，失败返回错误信息
ClassMethod DeleteSchemeItemLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.id
	s locIdStr=argInJson.params.locIdStr
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemRes).DeleteSchemeItemLocJson(id,locIdStr)
    if (strRes = "1")
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
	   q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:      批量删除共同科室配置
/// Creator:    huhao
/// CreateDate: 2023-4-3
/// Input:      
/// OutPut:     返回数据 成功：ID,
/// 					 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod DeleteSchemeItemLocJson(id As %String, locIdStr As %String)
{
	s strRes=1
	TSTART
	for i=1:1:$l(id,"^")
	{
		s itemId=$p(id,"^",i)
		q:itemId=""
		for j=1:1:$l(locIdStr,"^")
		{
			s locId=$p(locIdStr,"^",j)
			q:locId=""
			
			s rowId=$o(^CF.EMR.DOC.EMRTSchemeItemResI("IdxSchemeItemLocID",itemId,locId,""))
			s sc=##class(CF.EMR.DOC.EMRTSchemeItemRes).%DeleteId(rowId)
			if ('$$$ISOK(sc))
			{
				s strRes="-1^"_itemId_"保存失败"
				TROLLBACK
			}
			
			
		}
	}
	TCOMMIT
	q strRes
}

}
