/// 名称:EMR.DOC.BL.LocTemplate
/// 描述:通用文档管理模块 Document(Doc) 科室文档模板表
/// 编写者：ningyanghong
/// 编写日期: 2020-12-10
/// 产品组：电子病历产品组
Class EMR.DOC.BL.LocTemplate Extends EMR.DOC.COM.ActionBase
{

/// Desc:       更新模板属性
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      aParentId 目录ID
/// Output:     q ##Class(EMR.DOC.BL.LocTemplate).UpdateLocTemplate(0,1,1,)
ClassMethod UpdateLocTemplate(argDTO As EMR.DOC.DTO.LocTemplateCategory, ID As %String) As %String
{
	q:(ID="") "-100"
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(ID)
	q:(objTem="") "-200"
	s objDisease = "",strDid = ""
	s objTem.Description=argDTO.Description
	s objTem.Name=argDTO.Name
	s objTem.EMRName=argDTO.EMRName
	s strDid = ..GetIDByKey(argDTO.Disease)
	s:(strDid="") objTem.Disease=""
	s:(strDid'="") objDisease =##class(CF.EMR.DOC.Diagnos).%OpenId(strDid)
	s:(objDisease'="") objTem.Disease=objDisease
	s sc = objTem.%Save()
	if ('$$$ISOK(sc))
	{
		q "-300"
	}
	q "1"
}

/// Desc:       删除模板属性
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      目录ID
/// Output:     q ##Class(EMR.DOC.BL.LocTemplate)DeleteLocTemplate(0,1,1,)
ClassMethod DeleteLocTemplate(ID As %String) As %String
{
	q:(ID="") "-100"
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(ID)
	s versionNumber=objTem.TempLastVersion
	q:(objTem="") "-200"
	
	// childcount-1
	if (objTem.LocTemplateCategory'="")
	{
			s objCat=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(objTem.LocTemplateCategory.%Id())
			if (objCat'="")
			{
				s objCat.ResChildCount=objCat.ResChildCount-1
				s sc = objCat.%Save()
				if ('$$$ISOK(sc))
				{
					q "-300"
				}
			}
	}

		
	

	d ##class(CF.EMR.DOC.LocTemplate).%DeleteId(ID)
	// 将该模板最新version状态改为-1
	&sql(UPDATE CF_EMR_DOC.LocTemplateVersion SET Status = -1 WHERE TepmplateVersionNumber =:versionNumber and Template =:ID)
	
	q "1"
}

/// Creator:    yejian
/// Desc:       审核文档
/// CreateDate: 2020-12-17
/// Input:      ATemplate 文档对象
/// output:     成功： 模板ID 失败：-101 保存文档失败  -102 "更新目录失败"
/// 									-200 必填项校验失败
/// 									-301 目录对象为空 -302 文档类型为空 -303 文档版式不存在							 
/// Debug:      w ##Class(EMR.DOC.COM.Template).AddTemplate()
ClassMethod auditTemplate(ATemplate As %String) As %String
{
	q:(ATemplate="") "-100"
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(ATemplate)
	q:(objTem="" ) "-200"
	// 获取最新版本
	s lastVersion=objTem.TempLastVersion
	s rowID=""
	&sql(select ID into :rowID from CF_EMR_DOC.LocTemplateVersion where Template =:ATemplate and TepmplateVersionNumber =:lastVersion)
	s res= ##class(EMR.DOC.BL.LocTemplateAudit).AuditLocTemplateJsonp("3","申请审核",rowID)
	q "1"
}

/// Desc:       获取模板数组
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      aParentId 目录ID
/// Output:     q ##Class(EMR.DOC.BL.LocTemplate)GetJsonTemplateByID(0,1,1,)
ClassMethod GetJsonTemplateByID(aProductid As %String, aRoleID As %String, DataTypes As %String, TmpParentId As %String, CatParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	q:(TmpParentId="") 
	s:CatParentId="" CatParentId=-100000000000000
	s rowID="",seq=""
	for 
	{
		s seq=$o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",TmpParentId,CatParentId,seq))
		q:seq=""
		for
		{
			s rowID = $o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",TmpParentId,CatParentId,seq,rowID))
			q:(rowID="")
			s objtem=##class(CF.EMR.DOC.LocTemplate).%OpenId(rowID)
			
			s jsonItem = ##class(%DynamicObject).%New()
			s jsonItem.key =rowID_"||IT"
     		s jsonItem.type="IT"
     		s jsonItem.description=objtem.Description
     		s jsonItem.title=objtem.Name
     		s jsonItem.template=objtem.TemplateID.%Id()_"||DT"
     		s jsonItem.emrName=objtem.EMRName
     		s jsonItem.product=objtem.Product.ProductCode
     		s jsonItem.HFFormat=objtem.TemplateID.HFFormat.%Id()_"||LF"
     		if (objtem.Disease'="")
			{
				s jsonItem.disease=objtem.Disease.%Id()_"||D"
			}
			else
			{
				s jsonItem.disease=""
			}
	    	s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductid,aRoleID,DataTypes,"IT",rowID)
     		s jsonItem.permission=Permission
     		
     		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductid,aRoleID,DataTypes,"IT",rowID)
			s jsonItem.checked=checkStatus

     		s versionNumber=objtem.TempLastVersion
     		s status=""
			&sql(select Status into :status from CF_EMR_DOC.LocTemplateVersion where TepmplateVersionNumber = :versionNumber and Template =:rowID)
			s jsonItem.lastStatus=status
			
			d jsonCategory.%Push(jsonItem)
		}
	}
	
	q "1"
}

/// Desc:       科室模板排序
/// Creator:    huhao
/// CreateDate: 2022/11/22
/// Table:		CF.EMR.DOC.LocTemplate
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod LocTemplateSort(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s option=argInJson.params.operation
	s id=..GetIDByKey(argInJson.params.id)
	s strRes = ##class(EMR.DOC.BL.LocTemplate).sort(option,id)
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

/// Desc:       科室模板目录排序
/// Creator:    huhao
/// CreateDate: 2022/11/22
/// Table:		CF.EMR.DOC.LocTemplate
/// Input:      id:科室模板id
/// 			operation：操作编码  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod sort(option As %String, id As %String) As %String
{
	q:option="" "-1^无操作"
	q:id="" "-1^id不能为空"
	if (option="mi_up")
	{
		s seq="",rowId=""
		s objCat=##class(CF.EMR.DOC.LocTemplate).%OpenId(id)
		s oldSeq=objCat.Sequence
		s locCatID=$case(objCat.LocTemplateCategory,"":-100000000000000,:objCat.LocTemplateCategory.%Id())
		s seq=$o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",objCat.TemplateID.%Id(),locCatID,oldSeq),-1)
		q:seq="" "-1^无法上移"
		s rowId=$o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",objCat.TemplateID.%Id(),locCatID,seq,rowId))
		s obj=##class(CF.EMR.DOC.LocTemplate).%OpenId(rowId)
		s objCat.Sequence=obj.Sequence
		s obj.Sequence=oldSeq
		d obj.%Save()
		d objCat.%Save()
		q "1"		

				
	}
	elseif (option="mi_down")
	{
		s seq="",rowId=""
		s objCat=##class(CF.EMR.DOC.LocTemplate).%OpenId(id)
		s oldSeq=objCat.Sequence
		s locCatID=$case(objCat.LocTemplateCategory,"":-100000000000000,:objCat.LocTemplateCategory.%Id())
		s seq=$o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",objCat.TemplateID.%Id(),locCatID,oldSeq))
		q:seq="" "-1^无法下移"
		s rowId=$o(^CF.EMR.DOC.LocTemplateI("IdxCatSeq",objCat.TemplateID.%Id(),locCatID,seq,rowId))
		s obj=##class(CF.EMR.DOC.LocTemplate).%OpenId(rowId)
		s objCat.Sequence=obj.Sequence
		s obj.Sequence=oldSeq
		d obj.%Save()
		d objCat.%Save()
		q "1"
	}		

	else
	{
		 q "-1^操作不明确"
	}
}

Query GetTemplateByID(id As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,EMRName:%String,Description:%String,Disease:%String,LocTemplateCategory:%String,TempLastVersion:%String", SELECTMODE = "RUNTIME") [ SqlName = GetTemplateByID, SqlProc ]
{
	select ID,Name,EMRName,Description,Disease,LocTemplateCategory,TempLastVersion from CF_EMR_DOC.LocTemplate where LocTemplateCategory = :id
}

}
