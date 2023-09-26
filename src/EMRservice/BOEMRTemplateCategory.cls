Class EMRservice.BOEMRTemplateCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRTemplateCategory";

ClassMethod Add(argEMRTemplateCategory As EMRservice.entity.EEMRTemplateCategory) As %String [ WebMethod ]
{
 
	q:($d(argEMRTemplateCategory)=0)||(argEMRTemplateCategory="") 0
	s aEMRTemplateCategory=""
	s aEMRTemplateCategory=##class(EMRmeta.EMRTemplateCategory).%New()
	q:(aEMRTemplateCategory="") 0

  
	s aEMRTemplateCategory.CategoryName=argEMRTemplateCategory.CategoryName
	s aEMRTemplateCategory.CategoryType=argEMRTemplateCategory.CategoryType
	s aEMRTemplateCategory.ParentCategoryID=argEMRTemplateCategory.ParentCategoryID
	s aEMRTemplateCategory.CategorySeq=argEMRTemplateCategory.CategorySeq
 	s aEMRTemplateCategory.IsMutex=argEMRTemplateCategory.IsMutex
 	s aEMRTemplateCategory.IsLeadframe=argEMRTemplateCategory.IsLeadframe
 	s aEMRTemplateCategory.IsWaitsign=argEMRTemplateCategory.IsWaitsign
 	s aEMRTemplateCategory.ImageUrl=argEMRTemplateCategory.ImageUrl
 	s aEMRTemplateCategory.InternalID=argEMRTemplateCategory.InternalID
 	s aEMRTemplateCategory.FullFight=##class(EMRservice.Tools.Tool).GetCNCODE(argEMRTemplateCategory.CategoryName,3,"")
 	s aEMRTemplateCategory.JaneSpell=##class(EMRservice.Tools.Tool).GetCNCODE(argEMRTemplateCategory.CategoryName,4,"")
	s result=""
	s result=aEMRTemplateCategory.%Save()

	s aEMRTemplateCategory.CategorySeq = aEMRTemplateCategory.%Id()
	s result=aEMRTemplateCategory.%Save()
	q aEMRTemplateCategory.%Id()
}

/// Desc:       根据模板批量添加病历展现
/// Creator:    yejian
/// CreateDate: 2021-6-15
/// Input:      argArr 模板集合，aParentID 目录ID，aInternalID 业务活动记录编码
/// OutPut:     返回值：成功 1，失败 -1
ClassMethod AddTemps(argArr As %ListOfDataTypes(ELEMENTTYPE="%String",MAXLEN="200"), aParentID As %String, aInternalID As %String) As %String [ WebMethod ]
{
 	q ##class(EMRservice.BL.BLEMRTemplateCategory).AddTemps(argArr,aParentID,aInternalID)
}

ClassMethod Delete(argEMRTemplateCategoryID As %String) As %String [ WebMethod ]
{
	q:($d(argEMRTemplateCategoryID)=0)||(argEMRTemplateCategoryID="") 0
	s aEMRTemplateCategory="",result=""
	s aEMRTemplateCategory=##class(EMRmeta.EMRTemplateCategory).%OpenId(argEMRTemplateCategoryID)
	q:(aEMRTemplateCategory="") 0
	s aEMRTemplateCategory=""
	s result=##class(EMRmeta.EMRTemplateCategory).%DeleteId(argEMRTemplateCategoryID)
	q result
}

ClassMethod Update(argEMRTemplateCategoryID As %String, argEMRTemplateCategory As EMRservice.entity.EEMRTemplateCategory) As %String [ WebMethod ]
{
	q:($d(argEMRTemplateCategoryID)=0)||($d(argEMRTemplateCategory)=0)||(argEMRTemplateCategoryID="")||(argEMRTemplateCategory="") 0
	s aEMRTemplateCategory="",result=""
	s aEMRTemplateCategory=##class(EMRmeta.EMRTemplateCategory).%OpenId(argEMRTemplateCategoryID)
	q:(aEMRTemplateCategory="") 0
	
	s aEMRTemplateCategory.CategoryName=argEMRTemplateCategory.CategoryName
	s aEMRTemplateCategory.CategoryType=argEMRTemplateCategory.CategoryType
	s aEMRTemplateCategory.ParentCategoryID=argEMRTemplateCategory.ParentCategoryID
	s aEMRTemplateCategory.CategorySeq=argEMRTemplateCategory.CategorySeq
	s aEMRTemplateCategory.IsMutex=argEMRTemplateCategory.IsMutex
	s aEMRTemplateCategory.IsLeadframe=argEMRTemplateCategory.IsLeadframe
	s aEMRTemplateCategory.IsWaitsign=argEMRTemplateCategory.IsWaitsign
	s aEMRTemplateCategory.ImageUrl=argEMRTemplateCategory.ImageUrl
	s aEMRTemplateCategory.InternalID=argEMRTemplateCategory.InternalID
	s aEMRTemplateCategory.FullFight=##class(EMRservice.Tools.Tool).GetCNCODE(argEMRTemplateCategory.CategoryName,3,"")
	s aEMRTemplateCategory.JaneSpell=##class(EMRservice.Tools.Tool).GetCNCODE(argEMRTemplateCategory.CategoryName,4,"")
	s result=""
	s result=aEMRTemplateCategory.%Save()
	q result
}

ClassMethod GetById(argEMRTemplateCategoryID As %String) As EMRservice.entity.EEMRTemplateCategory [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EMRservice.entity.EEMRTemplateCategory).%New()
	
	s tmpResult=##class(EMRmeta.EMRTemplateCategory).%OpenId(argEMRTemplateCategoryID)
	q:(tmpResult="") result
	s result.ID=argEMRTemplateCategoryID
	s result.CategoryName=tmpResult.CategoryName
	s result.CategoryType=tmpResult.CategoryType
	s result.ParentCategoryID=tmpResult.ParentCategoryID
	s result.CategorySeq=tmpResult.CategorySeq
	s result.IsMutex=tmpResult.IsMutex
	s result.IsLeadframe=tmpResult.IsLeadframe
	s result.IsWaitsign=tmpResult.IsWaitsign
	s result.ImageUrl=tmpResult.ImageUrl
	s result.InternalID=tmpResult.InternalID
	s result.FullFight=##class(EMRservice.Tools.Tool).GetCNCODE(tmpResult.CategoryName,3,"")
	s result.JaneSpell=##class(EMRservice.Tools.Tool).GetCNCODE(tmpResult.CategoryName,4,"")
	
	q result
}

ClassMethod GetAll() As EMRservice.dataset.EEMRTemplateCategoryDatasetAll [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EEMRTemplateCategoryDatasetAll).%New()
	Quit result
}

ClassMethod GetCategoryProperty(argEMRCategoryID As %String) As EMRservice.entity.EEMRCategoryProperty [ WebMethod ]
{
	
	s result="",id="",tmpResult="",EMRTemplateID="",TemplateId="",TemplateType=""
	if (argEMRCategoryID'="")
	{
	  s EMRTemplateID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_argEMRCategoryID,"0"))
	  if (EMRTemplateID'="")
	  {
		  s objEMRTemplate=##Class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
		  s TemplateId=objEMRTemplate.BindTemplateID
		  //s TemplateId = $listget(^DHCEMRM.EMRTemplateD(EMRTemplateID),5)	
		  if (TemplateId'="")
		  {
		    //s TemplateType = $listget(^DHCEMRM.TemplateD(TemplateId),4)
		    s objTemplate=##Class(EMRmeta.Template).%OpenId(TemplateId)
		    s TemplateType=objTemplate.ChartItemType
		  }
	  }
	}
	
	
	s result=##class(EMRservice.entity.EEMRCategoryProperty).%New()
	
	s tmpResult=##class(EMRmeta.EMRTemplateCategory).%OpenId(argEMRCategoryID)
	q:(tmpResult="") ""
	s result.Name=tmpResult.CategoryName
 	s result.IsMutex = tmpResult.IsMutex
 	s result.IsLeadframe = tmpResult.IsLeadframe
 	s result.ImageUrl=tmpResult.ImageUrl
 	s result.InternalID=tmpResult.InternalID
 	s result.IsLeadframe=tmpResult.IsLeadframe
 	s result.IsWaitsign = tmpResult.IsWaitsign
 	s result.FullFight = ##class(EMRservice.Tools.Tool).GetCNCODE(tmpResult.CategoryName,3,"")
 	s result.JaneSpell = ##class(EMRservice.Tools.Tool).GetCNCODE(tmpResult.CategoryName,4,"")
 	s result.TemplateType = TemplateType
 	//s:(TemplateType="Multiple") result.IsLeadframe=1
 	//s:(TemplateType="Single") result.IsLeadframe=0
	d tmpResult.%Close()
	k tmpResult
		

	
	q result
}

ClassMethod SetCategoryProperty(argEMRCategoryID As %String, argCategoryProperty As EMRservice.entity.EEMRCategoryProperty) As %String [ WebMethod ]
{
	q:((argEMRCategoryID="") || (argCategoryProperty="")) 0
	s tmpResult=""
	s tmpResult=##class(EMRmeta.EMRTemplateCategory).%OpenId(argEMRCategoryID)
	q:(tmpResult="") 0
	
	s tmpResult.CategoryName = argCategoryProperty.Name
	s tmpResult.IsMutex = argCategoryProperty.IsMutex
	s tmpResult.IsLeadframe = argCategoryProperty.IsLeadframe
	s tmpResult.IsWaitsign = argCategoryProperty.IsWaitsign
	s tmpResult.ImageUrl=argCategoryProperty.ImageUrl
	s tmpResult.InternalID=argCategoryProperty.InternalID
	
	s tmpResult.FullFight=##class(EMRservice.Tools.Tool).GetCNCODE(argCategoryProperty.Name,3,"")
	s tmpResult.JaneSpell=##class(EMRservice.Tools.Tool).GetCNCODE(argCategoryProperty.Name,4,"")
	s strRelut = tmpResult.%Save()
	//如果是CategoryChapter则同步更新子节点Document
	if ((tmpResult.CategoryType="CategoryChapter")&&(tmpResult.InternalID'=""))
	{
		s pRowID = ""
		for{
			s pRowID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID"," "_argEMRCategoryID,pRowID))
			q:(pRowID="") 
			s objDocument=##class(EMRmeta.EMRTemplateCategory).%OpenId(pRowID)
			q:(objDocument="")
			s objDocument.InternalID = tmpResult.InternalID
			s strRelut= objDocument.%Save()
		}
	}
	q strRelut
}

/// 将目录类型转化为节点ID前缀
ClassMethod TransCategoryType(argCategoryType) As %String
{
	q:((argCategoryType="") || ($d(argCategoryType)=0)) ""
	
	set resultType = ""
	if (argCategoryType="Category")
	{
		s resultType = "CG"
	}
	elseif (argCategoryType="CategoryChapter")
	{
		s resultType = "CC"
	}
	elseif (argCategoryType="TempCate")
	{
		s resultType = "TC"
	}
	elseif (argCategoryType="PrtTemplate") 
	{
		s resultType = "LF"
	}
	elseif (argCategoryType="PhotoScan")
	{
		s resultType = "PS"
	}else
	{
		s resultType = "CG"
	}
	
	q resultType
}

/// Desc:	获取目录名称信息
ClassMethod GetCategoryInfoByIDs(AEMRTemplateCategoryIDs As %String) As EMRservice.dataset.EEMRTplCateInfoDataset [ WebMethod ]
{
	s ds = ##Class(EMRservice.dataset.EEMRTplCateInfoDataset).%New()
	d ds.SetArgs(AEMRTemplateCategoryIDs)
	q ds
}

/// 批量更新排序字段 by yejian
ClassMethod UpdateCategorySeq(argStr As %String) As %String [ WebMethod ]
{
	
 	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
		S argstrItem= $P(argStr,",",I)
		S argEMRTemplateCategoryID = $P(argstrItem,"^",1)
		S argCategorySeq = $P(argstrItem,"^",2)
		if ($d(argEMRTemplateCategoryID)=0)||($d(argCategorySeq)=0)||(argEMRTemplateCategoryID="")||(argCategorySeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s aEMRTemplateCategory="",result=""
		s aEMRTemplateCategory=##class(EMRmeta.EMRTemplateCategory).%OpenId(argEMRTemplateCategoryID)
		if (aEMRTemplateCategory ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s aEMRTemplateCategory.CategorySeq=argCategorySeq
		s result=""
		if '(aEMRTemplateCategory.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

}
