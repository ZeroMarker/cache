/// 名称:	EMR.DOC.BL.EMRTSchemeItemSSGroup
/// 描述:	导航方案项目授权表 业务类
/// 编写者：Ningyanghong
/// 编写日期: 2021-10-18
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeItemSSGroup Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取关联科室
/// Creator:    ningyanghong
/// CreateDate: 2021-12-17
/// Input:      argArray  命令参数 {"action":"GET_SCHEMEITEM_SSGROUP","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeItemSSGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s itemID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).GetSchemeItemSSGroupJson(itemID,.argOutData)
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
ClassMethod GetSchemeItemSSGroupStrJson(ItemID As %String) As %String
{
	s strRes="201"
	q:(ItemID="") strRes
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",ItemID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemSSGroup).%OpenId(RowID)
		
			d obj.%Close()
			s str=""
			&sql(select SSGRP_Desc into :str from SQLUser.SS_Group Where SSGRP_RowId=:curLocID )
			s LocIDStr=str
			
		}
		else
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemSSGroup).%OpenId(RowID)

			d obj.%Close()
			s IDStr = ""
			&sql(select SSGRP_Desc  into :IDStr from SQLUser.SS_Group Where SSGRP_RowId=:curLocID )
			s LocIDStr = LocIDStr_" "_IDStr
		}
	}
	s strRes = "1"
	q LocIDStr
}

/// Desc:       获取共同关联安全组
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      argArray  命令参数 {"action":"GET_SCHEMEITEM_SSGROUP","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeItemSameSSGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s itemID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).GetSchemeItemSameSSGroupJson(itemID,.argOutData)
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
ClassMethod GetSchemeItemSSGroupJson(ItemID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="201"
	q:(ItemID="") strRes
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",ItemID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemSSGroup).%OpenId(RowID)
		
			d obj.%Close()
			s LocIDStr = curLocID
		}
		else
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",ItemID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTSchemeItemSSGroup).%OpenId(RowID)

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

/// Desc:       获取指定分组下的关联科室
/// Creator:    zhangxl
/// CreateDate: 2021-10-21
/// OutPut:     返回数据 成功：ID, 返回格式:locID1^locID2^locID3^..
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetTemplateGroupLocJson(strID,.argOutData)
ClassMethod GetSchemeItemSameSSGroupJson(ItemID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="201"
	q:(ItemID="") strRes
	s LocIDStr = ""
	s objArr=##class(%DynamicArray).%New()
	
	s idLength=$l(ItemID,"^")
	s firstID=$p(ItemID,"^")
	;获取第一个id下的安全组数据
	s arrayLoc=##class(%DynamicArray).%New()
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",firstID,curLocID))
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
			s LocID = $o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",navID,LocID))
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
		s key="",title=""
		s g=r-1
		s itemId=$p(arrayLoc.%Get(g),"^")
		s locID=$p(arrayLoc.%Get(g),"^",2)
		if (locID=idLength)
		{
			&sql(SELECT SSGRP_RowId into :key From SQLUser.SS_Group Where SSGRP_RowId=:itemId)
			&sql(SELECT SSGRP_Desc into :title From SQLUser.SS_Group Where SSGRP_RowId=:itemId)
			s objRes.key=key
			s objRes.title=title
			d objArr.%Push(objRes)
		}
	}

	d objArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       保存安全组配置信息
/// Creator:    huhao
/// CreateDate: 2023/4/4
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEITEM_SSGROUP","params":[{"id":"67","locStr":"259^262"},{"id":"68","locStr":"259^261"}],"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveSchemeItemSSGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).SaveSchemeItemSSGroupJson(argInJson.params)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","获取失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       保存安全组配置信息
/// Creator:    huhao
/// CreateDate: 2023/4/4
/// Input:      
/// OutPut:     返回数据 成功：ID,
/// 					
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod SaveSchemeItemSSGroupJson(arr As %DynamicArray)
{
	s strRes="1"
	s count=arr.%Size()
	q:count=0
	TSTART
	for i=0:1:count-1
	{
		s obj=arr.%Get(i)
		s id=obj.id
		s ssGroupIdStr=obj.ssGroupIdStr
		&sql(delete CF_EMR_DOC.EMRTSchemeItemSSGroup WHERE EMRTSchemeItem=:id)
		for j=1:1:$l(ssGroupIdStr,"^")
		{
			s itemId=$p(ssGroupIdStr,"^",j)
			continue:itemId=""
			s objNewGroup=##class(CF.EMR.DOC.EMRTSchemeItemSSGroup).%New()
			s objItem=##class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(id)
			s objNewGroup.EMRTSchemeItem=objItem
			s objNewGroup.SSGroupID=itemId
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

/// Desc:       批量删除共同安全组配置
/// Creator:    huhao
/// CreateDate: 2023-4-3
/// Input:      argArray  命令参数 {"action":"DELETE_SCHEMEITEM_LOC","params":[{"id":"67","locStr":"259^262"},{"id":"68","locStr":"259^261"}],"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据 成功返回1，失败返回错误信息
ClassMethod DeleteSchemeItemSSGroup(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.id
	s ssGroupIdStr=argInJson.params.ssGroupIdStr
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).DeleteSchemeItemSSGroupJson(id,ssGroupIdStr)
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
ClassMethod DeleteSchemeItemSSGroupJson(id As %String, ssGroupIdStr As %String)
{
	s strRes=1
	TSTART
	for i=1:1:$l(id,"^")
	{
		s itemId=$p(id,"^",i)
		q:itemId=""
		for j=1:1:$l(ssGroupIdStr,"^")
		{
			s ssGroupId=$p(ssGroupIdStr,"^",j)
			q:ssGroupId=""
			
			s rowId=$o(^CF.EMR.DOC.EMRTSchemeISSGI("IdxSchemeItemGroupID",itemId,ssGroupId,""))
			s sc=##class(CF.EMR.DOC.EMRTSchemeItemSSGroup).%DeleteId(rowId)
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
