Class EMRservice.BL.BLTemplateDataSet Extends %RegisteredObject
{

/// w ##class(EMRservice.BL.BLTemplateDataSet).GetTemplateSummary()
ClassMethod GetTemplateSummary() As %String
{
	
	s json={}
	s jsondata=[]
	
	s jsonsub={}
	s basetemplateCount = ..GetBaseTemplate()
	s userTemplateCount = ..GetUserTemplate()
	s diseaseTypeCount = ..GetDiseaseType()
	s jsonsub.templatecount= (basetemplateCount + userTemplateCount)
	s jsonsub.basetemplate=basetemplateCount
	s jsonsub.usertemplate=userTemplateCount
	s jsonsub.diseasetypes=diseaseTypeCount
	
	d jsondata.%Push(jsonsub)
	
	s json.total=1
	s json.data=jsondata
	
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLTemplateDataSet).GetBaseTemplate()
ClassMethod GetBaseTemplate()
{
	s templateCount=0
	s emrtemplateCount=0
	s templateId=""
	for
	{
		s templateId = $o(^DHCEMRM.TemplateD(templateId))
		q:(templateId="")
		
		s objTemplate = ##class(EMRmeta.Template).%OpenId(templateId)
		continue:(objTemplate.PublishVersion="")
		
		s templateCount=templateCount+1
		
		s templateCateId = objTemplate.TemplateCategoryID
		
		//验证是否展现
		s emrCateId=""
		for
		{
			s emrCateId = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateCategoryID"," "_templateCateId, emrCateId))
			q:(emrCateId="")
			
			if ($d(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate",emrCateId, " "_templateId))=10)
			{
				s emrtemplateCount = emrtemplateCount+1
			}
		}

	}
	
	q emrtemplateCount_"/"_templateCount
}

/// w ##class(EMRservice.BL.BLTemplateDataSet).GetUserTemplate()
ClassMethod GetUserTemplate() As %String
{

	s usertemplateCount=0,workingCount=0
	
	s usertemplateId=""
	for
	{
		s usertemplateId = $o(^DHCEMRM.UserTemplateD(usertemplateId))
		q:(usertemplateId="")
		
		s objUserTemplate = ##class(EMRmeta.UserTemplate).%OpenId(usertemplateId)
		continue:((objUserTemplate.Status=0)||(objUserTemplate.Status=-1))
		
		s usertemplateCount=usertemplateCount+1
		
		if (objUserTemplate.Status=1)
		{
			s workingCount = workingCount +1
		}
		

	}
	
	q workingCount_"/"_usertemplateCount
}

ClassMethod GetDiseaseType() As %String
{
	s totalCount=0,workingCount=0
	s diagId=""
	for
	{
		s diagId=$o(^DHCEMRM.DiagnosD(diagId))
		q:(diagId="")
		
		s totalCount=totalCount+1
		s objDisease = ##class(EMRmeta.Diagnos).%OpenId(diagId)
		s diseaseCode = objDisease.DiagnosCode
		
		if ($d(^DHCEMRM.DiagnosDiseaseI("IdxDiagnosCode"," "_$zcvt(diseaseCode,"U")))=10)
		{
			s workingCount = workingCount+1
		}
	
	}
	
	q workingCount_"/"_totalCount
}

/// w ##class(EMRservice.BL.BLTemplateDataSet).GetCTLocData()
ClassMethod GetCTLocData()
{
	s json={}
	s jsondata=[]
	s count=0
	s ctlocId=""
	for
	{
		s ctlocId=$o(^PAC("ADMLOC",0,"AdmType","I",ctlocId))  
		q:ctlocId=""
		continue:($d(^CTLOC(ctlocId))=0)
		
		s ctlocdesc = $p($g(^CTLOC(ctlocId)),"^",2)
		s jsonsub={}
		s jsonsub.locid=ctlocId
		s jsonsub.locdesc = ctlocdesc
		
		d jsondata.%Push(jsonsub)
		s count=+$g(count)+1
	
	}
	s json.total=count
	s json.data=jsondata
	q json.%ToJSON()
}

/// w ##class(EMRservice.BL.BLTemplateDataSet).GetTemplateDataByLocID()
ClassMethod GetTemplateDataByLocID(ALocID As %String) As %String
{
	s json = {}
	s quitJson = json.%ToJSON()
	
	s jsonDocData=[]
	d ..GetEMRDocumentCateByParentId(0,.jsonDocData)

	s jsondata={}
	s jsondata.total = jsonDocData.%Size()
	s jsondata.rows = jsonDocData
	if (jsonDocData.%Size()>0)
	{
		s json.status = "suc"
		s json.data = jsondata
	}
	elseif (jsonDocData.%Size()=0)
	{
		s json.status = "suc"
		s json.data = ""
	}
	else
	{
		s json.status = "err"
	}
	
	q json.%ToJSON()
}

/// s json=[]
/// d ##class(EMRservice.BL.BLPrivRuleView).GetEMRDocumentCateByParentId(0,json)
/// w json.%ToJSON()
ClassMethod GetEMRDocumentCateByParentId(AParentID As %String, ByRef AJson As %DynamicObject)
{
	s seq=""
	for
	{
		s seq=$o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq))
		q:(seq="")
		
		s emrcateid=""
		for
		{
			s emrcateid=$o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentID,seq,emrcateid))
			q:(emrcateid="")
			s objemrcate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(emrcateid)
			s emrcateName = objemrcate.CategoryName
			s emrcateType = objemrcate.CategoryType
			
			s jsonsub = {}
			s jsonsub.id = emrcateid
			s jsonsub.templatename=emrcateName
			s jsonsub.categoryid = ""
			s jsonsub.templateid = ""
			s jsonsub.docid = ""
			s jsonsub.instanceid = ""
			s jsonsub.isdrg=""
			s jsonsub.type = ""
			//优化逻辑，精简输出
			/*
			if (AParentID'=0)
			{
				d jsonsub.%Set("_parentId",AParentID)
			}
			d AJson.%Push(jsonsub)
			*/
			if (AParentID=0)
			{
				d AJson.%Push(jsonsub)
			}
			
			if (emrcateType '= "TempCate")
			{
				d ..GetEMRDocumentCateByParentId(emrcateid,.AJson)	
			}
			else
			{
				d ..GetEMRDocumentByParentId(emrcateid,.AJson)	
			}
			
		}
	}
}

ClassMethod GetEMRDocumentByParentId(AParentID As %String, ByRef AJson As %DynamicObject)
{
	s seq=""
	for
	{
		s seq=$o(^DHCEMRM.EMRTemplateI("IdxTemplateSeq"," "_AParentID,seq))
		q:(seq="")
		
		s emrtemplateid=""
		for
		{
			s emrtemplateid=$o(^DHCEMRM.EMRTemplateI("IdxTemplateSeq"," "_AParentID,seq,emrtemplateid))
			q:(emrtemplateid="")
			s objemrtemplate = ##class(EMRmeta.EMRTemplate).%OpenId(emrtemplateid)
			s emrcateName = objemrtemplate.TemplateName
			
			s categoryid = objemrtemplate.BindTemplateCategoryID
			s templateid = objemrtemplate.BindTemplateID
			s docid = emrtemplateid
			s instanceid = ""
			
			s jsonsub = {}
			s jsonsub.id = "t"_emrtemplateid
			s jsonsub.templatename=emrcateName
			s jsonsub.categoryid = categoryid
			s jsonsub.templateid = templateid
			
			s jsonsub.docid = AParentID
		
			s jsonsub.instanceid = ""
			s jsonsub.isdrg=""
			s jsonsub.type = ""
			
			//优化逻辑，精简输出
			/*
			d jsonsub.%Set("_parentId",AParentID)
			*/
			
			d jsonsub.%Set("_parentId",..GetEMRTpltCateParentID(AParentID))
			d AJson.%Push(jsonsub)
			
		}
	}
}

ClassMethod GetEMRTpltCateParentID(AEMRTemplateCategoryID As %String) As %String
{
	//固定的层级结构降低理解难度，未用递归
	s objEMRTemplateCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(AEMRTemplateCategoryID)
	s pCateID = objEMRTemplateCate.ParentCategoryID
	
	s objParEMRTemplateCate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(pCateID)
	s ppCateID = objParEMRTemplateCate.ParentCategoryID
	
	q ppCateID
}

/// s stream = ##class(EMRservice.BL.BLTemplateDataSet).GetTemplateData(107)
/// w stream.Read(32000)
ClassMethod GetTemplateData(ALocID As %String) As %Stream
{
	s stream = ##class(%GlobalBinaryStream).%New()
	s json={}
	s jsondata=[]
	s count=0
	
	s CategoryIDs = ..GetCategoryIDs(ALocID)
	
	for i=1:1:$l(CategoryIDs,"^")
	{
		s cateId=$p(CategoryIDs,"^",i)
		
		s objCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(cateId)
		continue:(objCategory = "")
		s subJson={}
		s subJson.id = "EMRCate"_cateId
		s subJson.DocIDText=objCategory.CategoryName
		
		//stream缺少[],以下代码为补齐[]
		s fullJsonStream = ##class(%GlobalBinaryStream).%New()
		d fullJsonStream.Write("[")
		d fullJsonStream.CopyFrom(##Class(EMRservice.BL.BLClientCategory).GetTempCateJsonByCategoryIDNew(cateId,"3595","12175","List","","",ALocID,"",ALocID))
		d fullJsonStream.Write("]")
	
		s subJson.children = [].%FromJSON(fullJsonStream)
		d jsondata.%Push(subJson)
		s count = +$g(count)
	}
	s json.total = count
	s json.data=jsondata
	
	d json.%ToJSON(stream)
	
	q stream
}

/// w ##class(EMRservice.BL.BLTemplateDataSet).GetCategoryIDs(92)
ClassMethod GetCategoryIDs(ACTLocID) As %String
{
	s resultList="",result=""
	s tmpseq = ""
	
	for
	{ 
		s tmpseq=$o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq"," RUNNING",tmpseq))
		q:(tmpseq="")
		
		s tmpItemId=""
		for
		{
			s tmpItemId=$o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq"," RUNNING",tmpseq,tmpItemId))
			q:(tmpItemId="")
			
			s objNavSchItem = ##class(EMRmeta.EMRNavigationSchemeItem).%OpenId(tmpItemId)
			
			s NavSchItemCode = objNavSchItem.ItemCode
			
			
			continue:($d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," RUNNING", " "_NavSchItemCode," "_ACTLocID))'=10)
			
			s ctorgSchItem = objNavSchItem.ItemDr
			
			s objCTOrgSchItem = ##class(EMRmeta.CTOrganizationSchemeItem).%OpenId(ctorgSchItem)
			
			s cateId = objCTOrgSchItem.EMRTemplateCategoryID
			
			s resultList = resultList_$lb(cateId)
		}
	}
	
	if resultList'=""
	{
		s result= $lts(resultList,"^")
	}
	else
	{
		s result= resultList
	}
	
	q result
}

}
