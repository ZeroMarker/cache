/// 名称:	EMR.DOC.BL.PaitSign
/// 描述:	患者待签功能业务类
/// 编写者：huhao
/// 编写日期: 2022-09-19
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PaitSign Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取签名排序列表
/// Creator:    huhao
/// CreateDate: 2022/09/29
/// Table:		CF.EMR.DOC.PatSignOrder
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetPaitSignOrder(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.id
	s strRes = ##class(EMR.DOC.BL.PaitSign).PaitSequenceList(id,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","查询失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       获取签名排序列表
/// Creator:    huhao
/// CreateDate: 2022/09/29
/// Table:		CF.EMR.DOC.PatSignOrder
/// Input:      id 模板id  	 
/// OutPut:     签名列表JSON数据
/// Debug:		
ClassMethod PaitSequenceList(id As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="-1^未查询到数据",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.PatSignOrderD(rowid))
		s obj=##class(CF.EMR.DOC.PatSignOrder).%OpenId(rowid)
		q:obj=""
		continue:obj.TemplateVersion=""
		if (id'="")
		{
			continue:(obj.TemplateVersion.%Id()'=id)
		}
		s resObj.key=rowid
		s resObj.SignData=obj.SignData
		s resObj.TemplateID=obj.Template.%Id()
		s resObj.TemplateVersion=obj.TemplateVersion.%Id()
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       修改签名排序顺序
/// Creator:    huhao
/// CreateDate: 20220929
/// Table:		CF.EMR.DOC.PatSignOrder
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod UpdatePaitData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id=argInJson.params.id
	s signData=argInJson.params.signData
	s strRes = ##class(EMR.DOC.BL.PaitSign).UpdatePaitSequence(id,signData,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	s strErr = $zerror
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod UpdatePaitSequence(id As %String, signData As %DynamicArray, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	q:id="" "-1^id不能为空"
	s objId=""
	&sql(select id into :objId from CF_EMR_DOC.PatSignOrder where TemplateVersion=:id)
	s obj=##class(CF.EMR.DOC.PatSignOrder).%OpenId(objId)
	q:obj="" "-1^患者待签对象不存在"
	s obj.SignData=signData.%ToJSON()
	d obj.%Save()
	q "1"
}

/// Desc:       获取患者签名类型
/// Creator:    huhao
/// CreateDate: 20220929
/// Table:		CF.EMR.DOC.PatSignKeyWordType
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetPaitSignContent(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##class(EMR.DOC.BL.PaitSign).GetPaitSignType(.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetPaitSignType(ByRef argOutData As %GlobalBinaryStream)
{
	s strRes="",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.PatSignKeyWordTypeD(rowid))
		s obj=##class(CF.EMR.DOC.PatSignKeyWordType).%OpenId(rowid)
		q:obj=""
		s resObj.key=rowid
		s resObj.Code=obj.Code
		s resObj.Name=obj.Name
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取患者签名者类型
/// Creator:    huhao
/// CreateDate: 20220929
/// Table:		CF.EMR.DOC.PatSignSignerType
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetPaitSignerType(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s strRes = ##class(EMR.DOC.BL.PaitSign).GetPaitSignPepType(.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetPaitSignPepType(ByRef argOutData As %GlobalBinaryStream)
{
	s strRes="",rowid=""
	s resJson=##class(%DynamicArray).%New()
	for
	{
		s resObj=##class(%DynamicObject).%New()
		s rowid=$o(^CF.EMR.DOC.PatSignSignerTypeD(rowid))
		s obj=##class(CF.EMR.DOC.PatSignSignerType).%OpenId(rowid)
		q:obj=""
		s resObj.key=rowid
		s resObj.Code=obj.Code
		s resObj.Name=obj.Name
		d resJson.%Push(resObj)
		s strRes="1"
	}
	d resJson.%ToJSON(argOutData)
	q strRes
}

/// Desc:       保存患者待签数据
/// Creator:    huhao
/// CreateDate: 2923-2-13
/// Table:		CF_EMR_DOC.PatSignOrder
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod AddSignData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s tmpversionId=..GetIDByKey(argInJson.params.id)
	s sginData=argInJson.params.signData
	
	s strRes = ##class(EMR.DOC.BL.PaitSign).save(tmpversionId,sginData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod save(versionId As %String, signData As %String) As %String
{
	s strRes="",delFlag="",addFlag=""
	q:versionId="" "-1^模板版本id不能为空"
	if (signData.%Size()=0)
	{
		&sql(delete from CF_EMR_DOC.Patsignorder where Templateversion=:versionId)
		q "1"
	}
	
	s orderId=""
	&sql(select ID into :orderId from CF_EMR_DOC.PatSignOrder where templateversion=:versionId)
	if (orderId="")
	{
		//正常保存流程
		s obj=##class(CF.EMR.DOC.PatSignOrder).%New()
		s obj.SignData=signData.%ToJSON()
		s tmpVersionObj=##class(CF.EMR.DOC.TemplateVersion).%OpenId(versionId)
		q:tmpVersionObj="" "-1^版本不存在"
		s obj.TemplateVersion=tmpVersionObj
		s obj.Template=tmpVersionObj.Template
		s sc=obj.%Save()
		if ($$$ISOK(sc))
		{
			s strRes="1"
		}
	}
	else
	{
		//外部传参的signdata
		s InArr=##class(%DynamicArray).%New()
		s str=signData.%ToJSON()
		s InArr={}.%FromJSON(str)
		//库中版本对应的signdata
		s orderObj=##class(CF.EMR.DOC.PatSignOrder).%OpenId(orderId)
		s resArr=##class(%DynamicArray).%New()
		s resArr={}.%FromJSON(orderObj.SignData)
		
		//循环resArr删除多余的前面角色
		for i=0:1:(resArr.%Size()-1)
		{
			s resObj=resArr.%Get(i)
			q:resObj=""
			for j=0:1:(InArr.%Size()-1)
			{
				s InObj=InArr.%Get(j)
				if ((resObj.displayName=InObj.displayName)&&(resObj.path=InObj.path))
				{
					s delFlag=""
					q
				}
				else
				{
					s delFlag="1"
				}
			}
			if (delFlag="1")
			{
				d resArr.%Remove(i)
				s i=i-1
			}
		}
		//循环InArr插入新增的角色
		s centerArr=##class(%DynamicArray).%New()
		s centerArr=resArr
		for i=0:1:(InArr.%Size()-1)
		{
			s InObj=InArr.%Get(i)
			q:InObj=""
			s count=centerArr.%Size()
			s:count=0 addFlag="1"
			for j=0:1:(count-1)
			{
				s resObj=centerArr.%Get(j)
				if ((resObj.displayName=InObj.displayName)&&(resObj.path=InObj.path))
				{
					s addFlag=""
					q
				}
				else
				{
					s addFlag="1"
				}
			}
			if (addFlag="1")
			{
				d resArr.%Push(InObj)
			}
		}
		s orderObj.SignData=resArr.%ToJSON()
		s sc= orderObj.%Save()
		if ($$$ISOK(sc))
		{
			s strRes="1"
		}
	}
	q strRes
}

}
