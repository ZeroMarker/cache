/// 名称:	EMR.DOC.BL.EMRTemplateGroupLoc
/// 描述:	病历分组科室关联
/// 编写者：zhangxl
/// 编写日期: 2021-9-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTemplateGroupLoc Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取所有科室数据列表
/// Creator:    zhangxl
/// CreateDate: 2021-10-29
/// Input:      argArray  	命令参数 {"action":"GET_ALL_LOCS","params":"","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 
ClassMethod GetAllLocs(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetAllLocsJson(.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取所有科室数据列表
/// Creator:    zhangxl
/// CreateDate: 2021-8-3
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##Class(EMR.DOC.BL.TextKBLoc).GetAllLocJson(.argOutData)
ClassMethod GetAllLocsJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s strRes = ""
	s jsonArr = ##class(%DynamicArray).%New()
	
	s strRes = ""
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRTemplateGroupLoc:SelectAllLocs")
	d result.Execute()
	While result.Next() 
	{
     	s jsonItem = ##class(%DynamicObject).%New()
     	s jsonItem.key =result.GetDataByName("RowId")
     	s jsonItem.Code =result.GetDataByName("Code")
     	s jsonItem.title =result.GetDataByName("Des")
     	d jsonArr.%Push(jsonItem)
	}					
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取所有科室数据
/// Creator:    zhangxl
/// CreateDate: 2021-8-6
/// Input:      
/// OutPut:     dataset
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTextKBConfig","SelectAllLoc")
Query SelectAllLocs() As %SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%String,Code:%String,Des:%String")
{
	SELECT CTLOC_RowId,CTLOC_CODE,upper(CTLOC_Desc) From SQLUser.CT_Loc Where CTLOC_Type='E' or CTLOC_Type='OP' or CTLOC_Type='OR' or CTLOC_Type='EM'  Order By CTLOC_Desc,CTLOC_RowId
}

/// Desc:       获取病历分组下的关联科室
/// Creator:    zhangxl
/// CreateDate: 2021-10-21
/// Input:      argArray  命令参数 {"action":"GET_GROUP_LOC","params":{"id":"0"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemplateGroupLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetTemplateGroupLocJson(groupID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取角色类型数据出错",2)
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
ClassMethod GetTemplateGroupLocJson(groupID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s LocIDStr = ""
	s curLocID = ""
	for {
		s curLocID = $o(^CF.EMR.DOC.EMRTemGroupLocI("IdxCodeCTLocID",groupID,curLocID))
		q:(curLocID="")
		
		If (LocIDStr = "")
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTemGroupLocI("IdxCodeCTLocID",groupID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTemplateGroupLoc).%OpenId(RowID)
		
			d obj.%Close()
			s LocIDStr = curLocID
		}
		else
		{
			s RowID = ""
			s RowID = $o(^CF.EMR.DOC.EMRTemGroupLocI("IdxCodeCTLocID",groupID,curLocID,RowID))
			s obj = ##class(CF.EMR.DOC.EMRTemplateGroupLoc).%OpenId(RowID)

			d obj.%Close()
			s LocIDStr = LocIDStr_"^"_curLocID
		}
	}
	s argInJson  = ##class(%DynamicObject).%New()
	s argInJson.Group = groupID
	s argInJson.LocIDStr = LocIDStr
	d argInJson.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       保存分组下的科室配置信息
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      argArray  命令参数 {"action":"SAVE_GROUP_LOC","params":{"id":"68","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveGroupLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupID = argInJson.params.id
	s LocIDStr = argInJson.params.locStr
	s LocTitle = argInJson.params.title
    s strRes = ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).SaveGroupLocJson(groupID,LocIDStr,LocTitle)
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

/// Desc:       保存分组下的科室配置信息
/// Creator:    zhangxl
/// CreateDate: 2021-9-24
/// Input:      目录GroupID,LocIDStr-挂接科室拼成的字符串,格式为:locID1^locID2
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod SaveGroupLocJson(groupID As %String, LocIDStr As %String, LocTitle As %String)
{
	s ret = 0, status = 1
	q:(groupID="") ret
	
	TStart
	
	//检查该目录是否已关联
	s CateIDExist =  ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).CheckCateIDExist(groupID)
	if (CateIDExist = 0)
	{
		if (LocIDStr '= "")&&(LocIDStr'=$c(0))
		{
			// 不存在，直接将LocIDStr中的数据插入
			for i = 1:1:$l(LocIDStr,"^")
			{
				s CtLocID = $p(LocIDStr,"^",i)
				continue:(CtLocID="")
				
				s Flag = ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).Add(groupID,CtLocID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}	
		}
	}
	else
	{	
		s curLocID = ""
		s DeleteIDs = ""
		for {
			s curLocID = $o(^CF.EMR.DOC.EMRTemGroupLocI("IdxCodeCTLocID",groupID,curLocID))
			q:(curLocID="")

			s RowID = $o(^CF.EMR.DOC.EMRTemGroupLocI("IdxCodeCTLocID",groupID,curLocID,""))
			continue:(RowID="")
			
			//对curLocID去空格
			s tmpLocID = $e(curLocID,2,$l(curLocID))
			
			//配置的科室串为空,即将原先库中已有的记录状态设置为失效
			if (LocIDStr="")||(LocIDStr=$C(0))
			{
				s DeleteIDs = DeleteIDs_$lb(RowID)
				continue	
			}
			else
			{
				//配置的科室串不为空,依次判断原先库中存在的该节点挂接的科室串中是否存在新增的科室ID
				If $f("^"_LocIDStr_"^", "^"_tmpLocID_"^")<1
				{
					// 原先配置LocID不在新配置LocIDStr串中，将此关联的RowID记录到DeleteIDs列表中
					s DeleteIDs = DeleteIDs_$lb(RowID)	
				}
				else
				{
					//将LocIDStr进行处理，去掉已经找到的LocID			
					s tmpLocIDStr = ""
					s strLength = $l(LocIDStr,"^")
					for i=1:1:strLength
					{
						s tmp = $p(LocIDStr,"^",i)
						continue:(tmp="")
						
						continue:(tmp = tmpLocID) 
						
						If tmpLocIDStr=""
						{
							s tmpLocIDStr = tmp
						}
						Else
						{
							s tmpLocIDStr = tmpLocIDStr_"^"_tmp
						}
					}
					
					s LocIDStr = tmpLocIDStr
					
				}
			}
		}
				
		if (DeleteIDs'="")
		{
			for Ind=1:1:$listlength(DeleteIDs)
			{
				s DeleteID = $listget(DeleteIDs,Ind)
				continue:(DeleteID="")
				
				s Flag = ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).Delete(DeleteID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}	
		}
		
		
		//插入新数据
		if (LocIDStr '= "")&&(LocIDStr'=$c(0))
		{
			s strLength = $l(LocIDStr,"^")
			for i=1:1:strLength
			{
				//insert,create new data
				s curLocID = $p(LocIDStr,"^",i)
				continue:(curLocID="")
				
				s Flag = ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).Add(groupID,curLocID)
				if (Flag = 0)
				{
					s status = 0
					q	
				}
			}
		}
	}
	
	s obj=##class(CF.EMR.DOC.EMRTemplateGroup).%OpenId(groupID)	
	s obj.LocTitle=LocTitle
	s sc = obj.%Save()
	
	if (status = 1)
	{
		TCommit
		s ret = 1
	}
	else
	{
		TRollBack	
	}
	
	q ret
}

/// Desc:       目录与科室关联
/// Creator:    zhangxl
/// CreateDate: 2021-8-10
/// Input:      CateID-目录ID,LocID-科室ID
/// OutPut:     1-关联成功 0-关联失败
/// Debug:	
ClassMethod Add(GroupID As %String, LocID As %String) As %Integer
{
	s ret = 1
	s obj = ##class(CF.EMR.DOC.EMRTemplateGroupLoc).%New()
	s objCat = ##class(CF.EMR.DOC.EMRTemplateGroup).%OpenId(GroupID)
	s obj.TemplateGroupCode = objCat
	s obj.CTLocID = LocID
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
	s obj = ##class(CF.EMR.DOC.EMRTemplateGroupLoc).%OpenId(RowID)
	
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
ClassMethod CheckCateIDExist(groupID As %String) As %Integer
{
	s ret = 0
	q:(groupID="") ret
	
	s RowID = $o(^CF.EMR.DOC.EMRTemGroupLocI("IdxCodeCTLocID",groupID,""))
	if (+RowID>0)
	{
		s ret = 1
	}
	q ret
}

}
