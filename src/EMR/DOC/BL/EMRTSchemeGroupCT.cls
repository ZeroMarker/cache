/// 名称:	CF.EMR.DOC.EMRTSchemeGroupCT
/// 描述:	导航方案分组表科室关联表 业务类
/// 编写者：ningyanghong
/// 编写日期: 2021-10-27
/// 产品组：电子病历产品组
Class EMR.DOC.BL.EMRTSchemeGroupCT Extends EMR.DOC.COM.ActionBase
{

/// Desc:       保存科室配置信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-20
/// Input:      argArray  命令参数 {"action":"SAVE_SCHEMEGROUPCT_LOC","params":{"id":"68^67","locStr":"259^262","title":"11111"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveSchemeGroupLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s itemIDstr = argInJson.params.code
	s ssGroupIDStr = argInJson.params.LocStr
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupCT).SaveSchemeGroupLocJson(itemIDstr,ssGroupIDStr)
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","分组Code值不存在",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","科室不存在",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","请传入分组编码",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000")
}

/// Desc:       新增导航方案排序（科室）科室关联
/// Creator:    ningyanghong
/// CreateDate: 2021-10-29
/// Input:      argArray  命令参数{"action":"ADD_SECHEMEGROUP_LOC",params:{code:"",ctID:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddSchemeGroupCT(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strGroup=argInJson.params.code
	s strCTLoc=argInJson.params.ctID
	s strRes=##class(EMR.DOC.BL.EMRTSchemeGroupCT).AddSchemeGroupCTJson(strGroup,strCTLoc)
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
	elseif (strRes = "202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","科室不存在",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"未知错误")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取导航方案排序（科室）科室关联
/// Creator:    ningyanghong
/// CreateDate: 2021-10-29
/// Input:      argArray  命令参数{"action":"GET_SECHEMEGROUP_LOC",params:{code:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSchemeGroupCT(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strGroup=argInJson.params.code
	s strRes=##class(EMR.DOC.BL.EMRTSchemeGroupCT).GetSchemeGroupCTJson(strGroup,argOutData)
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
	    q ..SetOutMessage(argOutMessage,"未知错误")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新绑定科室列表
/// Creator:    ningyanghong
/// CreateDate: 2021-11-01
/// Input:      argArray  	命令参数 {"action":"UPDATE_SCHEMEGROUP_LOC","params":{"code":"68||CG","locData":["id"]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1           
ClassMethod SaveBindLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s groupCode = argInJson.params.code
	s locIDs = argInJson.params.locData
	s locArr=##class(%DynamicArray).%FromJSON(locIDs)
    s strRes = ##Class(EMR.DOC.BL.EMRTSchemeGroupCT).SaveBindLocJson(groupCode,locArr)
	if (strRes = "101")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
		elseif (strRes = "200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","分组编码不存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Description:更新绑定节点的科室列表
/// Creator:    ningyanghong
/// CreateDate: 2021-11-01
/// Input:      分组code,LocArr-挂接科室数组
/// OutPut:     返回数据 成功：ID,
/// 					 失败:101 分组编码不存在, 200 科室编码不存在，300 分组编码为空
/// Debug:w ##Class(EMR.DOC.BL.TextKBLoc).SaveBindLocJson(CateID,LocIDStr)
ClassMethod SaveBindLocJson(code As %String, locArr As %DynamicArray) As %String
{
	s strRes="101"
	q:(code="") strRes
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :Group)
	q:(count=0) "200"
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeItemsByCode")
	d result.Execute(code)
	While result.Next() 
	{
		s rowID =result.GetDataByName("ID")
		for i=1:1:locArr.%Size()
			{
				s res=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupCT:GetSchemeGroupCTByCode")
				d res.Execute(rowID)
				While res.Next()
				{
					s CTLoc =result.GetDataByName("CTLoc")
					s countLoc=0
					&sql(select count(*) into :countLoc from SQLUser.CT_Loc where CTLOC_RowID = :CTLoc)
					continue:(countLoc=0)
					 /// 存在，设置数
					if (locArr.%Get(i)=CTLoc)
					{
						
					}
					
					
				}
			}
		
	}
}

/// Desc:       保存科室配置信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-16
/// Input:      code 分组Code,LocIDStr-挂接科室拼成的字符串,格式为:locID1^locID2
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod SaveSchemeGroupLocJson(code As %String, LocIDStr As %String)
{
	q:(code="") "-301"
	s strRes="-100"
	s count=""
	// code不存在
	&sql(select count(*) into :count from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode =:code)
	q:(count=0) strRes
	&sql(DELETE FROM CF_EMR_DOC.EMRTSchemeGroupCT WHERE Code=:code)
	
			for j=1:1:$l(LocIDStr,"^")
			{
				s locID=$p(LocIDStr,"^",j)
				q:(locID="")
				
				
				s count=""
				&sql(select count(*) into :count from CF_EMR_DOC.EMRTSchemeGroupCT where Code= :ItemID and CTLoc=:locID)
				if (count=0)
				{
					s objNewGroup=##class(CF.EMR.DOC.EMRTSchemeGroupCT).%New()
					s objNewGroup.Code=code
					s objNewGroup.CTLoc=locID
					s sc = objNewGroup.%Save()
					continue:($$$ISOK(sc)) 
					
				}	
			}
			
		
				q "1"
}

/// Desc:       新增导航方案排序（科室）关联
/// Creator:    ningyanghong
/// CreateDate: 2021-10-29
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeGroupCT).AddSchemeGroupCTJson(Group,CTLoc)
ClassMethod AddSchemeGroupCTJson(Group As %String, CTLoc As %String) As %String
{
	s strRes = "101"
	/// 检查必填项
	q:(Group="")||(CTLoc="") strRes
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :Group)
	q:(count=0) "201" 
	s countLoc=0
	&sql(select count(*) into :countLoc from SQLUser.CT_Loc where CTLOC_RowID = :CTLoc)
	q:(countLoc=0) "202"
	
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupSeq:GetSchemeItemsByCode")
	d result.Execute(Group)
	While result.Next() 
	{
     	s rowID =result.GetDataByName("ID")
     	s objGroup=##class(CF.EMR.DOC.EMRTSchemeGroupSeq).%OpenId(rowID)
     	s objGroupCT=##class(CF.EMR.DOC.EMRTSchemeGroupCT).%New()
     	s objGroupCT.CTLoc=CTLoc
     	s objGroupCT.EMRTSchemeGroup=objGroup
     	s sc = objGroupCT.%Save()
		s:($$$ISOK(sc)) strRes = "1"
	}					
	q strRes
}

/// Desc:       获取分组科室列表
/// Creator:    ningyanghong
/// CreateDate: 2021-10-29
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.EMRTSchemeGroupCT).GetSchemeGroupCTJson(strGroup,.argOutData)
ClassMethod GetSchemeGroupCTJson(strGroup As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes= "101"
	q:(strGroup="") strRes
	s strRes = "201"
	s jsonArr = ##class(%DynamicArray).%New()
	s count=""
	&sql(select count(ID) into :count from CF_EMR_DOC.EMRTSchemeGroupSeq where GroupCode = :strGroup)
	q:(count="") strRes
	s result=##class(%ResultSet).%New("EMR.DOC.BL.EMRTSchemeGroupCT:GetSchemeGroupCTByCode")
	d result.Execute(strGroup)
	s objRes  = ##class(%DynamicObject).%New()
	s LocIDStr = ""
	While result.Next() 
	{
     	s CTLoc =result.GetDataByName("CTLoc")
     	if (LocIDStr="")
     	{
	     	s LocIDStr=CTLoc
	    }
	    else
	    {
		    s LocIDStr = LocIDStr_"^"_CTLoc	
	    }
     	
	}	
	s objRes.code=strGroup
	s objRes.LocIDStr=LocIDStr		
	d objRes.%ToJSON(argOutData)
	q "1"
}

Query GetSchemeGroupCTByCode(itemCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLoc:%String", SELECTMODE = "RUNTIME") [ SqlName = GetSchemeGroupCTByCode, SqlProc ]
{
	select CTLoc from CF_EMR_DOC.EMRTSchemeGroupCT where Code = :itemCode group by CTLoc
}

Query SelectLocByID(rowID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "RowId:%String,Code:%String,Des:%String", SELECTMODE = "RUNTIME") [ SqlName = SelectLocByID, SqlProc ]
{
	SELECT CTLOC_RowId,CTLOC_CODE,upper(CTLOC_Desc) From SQLUser.CT_Loc Where CTLoc_RowId = :rowID Order By CTLOC_RowId
}

}
