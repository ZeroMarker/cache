Class EPRservice.BOEPRTemplateCategory Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRTemplateCategory";

ClassMethod Add(argEPRTemplateCategory As EPRservice.entity.EEPRTemplateCategory) As %String [ WebMethod ]
{
	q:($d(argEPRTemplateCategory)=0)||(argEPRTemplateCategory="") 0
	s aEPRTemplateCategory=""
	s aEPRTemplateCategory=##class(EPRmeta.EPRTemplateCategory).%New()
	q:(aEPRTemplateCategory="") 0
	
	//取出上级Category的ID
	if (argEPRTemplateCategory.CategoryType ="PrtTemplate")
	{
		q:(argEPRTemplateCategory.BindPrnTemplateID = "") 0
		s objBindPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(argEPRTemplateCategory.BindPrnTemplateID)
		q:(objBindPrintTemplate = "" ) 0
		s argEPRTemplateCategory.BindPrnTemplateCategoryID = objBindPrintTemplate.PrintTemplateCategoryID
		d objBindPrintTemplate.%Close()
		k objBindPrintTemplate
	}
	
	s aEPRTemplateCategory.CategoryName=argEPRTemplateCategory.CategoryName
	s aEPRTemplateCategory.CategoryType=argEPRTemplateCategory.CategoryType
	s aEPRTemplateCategory.ParentCategoryID=argEPRTemplateCategory.ParentCategoryID
	s aEPRTemplateCategory.CategorySeq=argEPRTemplateCategory.CategorySeq
	s aEPRTemplateCategory.BindPrnTemplateID=argEPRTemplateCategory.BindPrnTemplateID
	s aEPRTemplateCategory.BindPrnTemplateCategoryID=argEPRTemplateCategory.BindPrnTemplateCategoryID
	s result=""
	s result=aEPRTemplateCategory.%Save()
	s aEPRTemplateCategory.CategorySeq = aEPRTemplateCategory.%Id()
	s result=aEPRTemplateCategory.%Save()
	q aEPRTemplateCategory.%Id()
}

ClassMethod Delete(argEPRTemplateCategoryID As %String) As %String [ WebMethod ]
{
	q:($d(argEPRTemplateCategoryID)=0)||(argEPRTemplateCategoryID="") 0
	s aEPRTemplateCategory="",result=""
	s aEPRTemplateCategory=##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRTemplateCategoryID)
	q:(aEPRTemplateCategory="") 0
	s aEPRTemplateCategory=""
	s result=##class(EPRmeta.EPRTemplateCategory).%DeleteId(argEPRTemplateCategoryID)
	q result
}

ClassMethod Update(argEPRTemplateCategoryID As %String, argEPRTemplateCategory As EPRservice.entity.EEPRTemplateCategory) As %String [ WebMethod ]
{
	q:($d(argEPRTemplateCategoryID)=0)||($d(argEPRTemplateCategory)=0)||(argEPRTemplateCategoryID="")||(argEPRTemplateCategory="") 0
	s aEPRTemplateCategory="",result=""
	s aEPRTemplateCategory=##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRTemplateCategoryID)
	q:(aEPRTemplateCategory="") 0
	
	s aEPRTemplateCategory.CategoryName=argEPRTemplateCategory.CategoryName
	s aEPRTemplateCategory.CategoryType=argEPRTemplateCategory.CategoryType
	s aEPRTemplateCategory.ParentCategoryID=argEPRTemplateCategory.ParentCategoryID
	s aEPRTemplateCategory.CategorySeq=argEPRTemplateCategory.CategorySeq
	s aEPRTemplateCategory.BindPrnTemplateID=argEPRTemplateCategory.BindPrnTemplateID
	s aEPRTemplateCategory.BindPrnTemplateCategoryID=aEPRTemplateCategory.BindPrnTemplateCategoryID
	
	s result=""
	s result=aEPRTemplateCategory.%Save()
	q result
}

ClassMethod GetById(argEPRTemplateCategoryID As %String) As EPRservice.entity.EEPRTemplateCategory [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.EEPRTemplateCategory).%New()
	
	s tmpResult=##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRTemplateCategoryID)
	q:(tmpResult="") result
	s result.ID=argEPRTemplateCategoryID
	s result.CategoryName=tmpResult.CategoryName
	s result.CategoryType=tmpResult.CategoryType
	s result.ParentCategoryID=tmpResult.ParentCategoryID
	s result.CategorySeq=tmpResult.CategorySeq
	s result.BindPrnTemplateID=tmpResult.BindPrnTemplateID
	s result.BindPrnTemplateCategoryID=tmpResult.BindPrnTemplateCategoryID
	
	q result
}

ClassMethod GetAll() As EPRservice.dataset.EEPRTemplateCategoryDatasetAll [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EEPRTemplateCategoryDatasetAll).%New()
	Quit result
}

ClassMethod GetCategoryProperty(argEPRCategoryID As %String) As EPRservice.entity.EEPRCategoryProperty [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.EEPRCategoryProperty).%New()
	
	s tmpResult=##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRCategoryID)
	q:(tmpResult="") ""
	s result.Name=tmpResult.CategoryName
	s bindPrintTemplateId = tmpResult.BindPrnTemplateID
	s curPrintCategoryId = tmpResult.BindPrnTemplateCategoryID
	s eprPrintTemplateType = tmpResult.CategoryType
	d tmpResult.%Close()
	k tmpResult
		
	if (eprPrintTemplateType = "PrtTemplate" && bindPrintTemplateId '= "")
	{
		//取出界面模板上级的Category
		s resultDirName = ""
		
		s objBindPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(bindPrintTemplateId)
		if (objBindPrintTemplate '= "" )
		{
			s resultDirName = objBindPrintTemplate.Name
			d objBindPrintTemplate.%Close()
			k objBindPrintTemplate
		}
			
		for {
			q:(curPrintCategoryId = "")
			
			s objBindPrintCategory = "",bindPrintCategoryName=""
			s objBindPrintCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(curPrintCategoryId)
			q:(objBindPrintCategory = "")
			s bindPrintCategoryName = objBindPrintCategory.Name
			s curPrintCategoryId = objBindPrintCategory.ParentID
			d objBindPrintCategory.%Close()
			k objBindPrintCategory
			
			s resultDirName = bindPrintCategoryName_"\"_resultDirName
		}
		
		s result.ResourceDir=resultDirName
	}

	
	q result
}

ClassMethod SetCategoryProperty(argEPRCategoryID As %String, argCategoryProperty As EPRservice.entity.EEPRCategoryProperty) As %String [ WebMethod ]
{
	q:((argEPRCategoryID="") || (argCategoryProperty="")) 0
	s tmpResult=""
	s tmpResult=##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRCategoryID)
	q:(tmpResult="") 0
	
	s tmpResult.CategoryName = argCategoryProperty.Name
	
	q tmpResult.%Save()
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

/// CreateUser: houj
/// CreateDate: 2009-11-14
/// Desc: 获取绑定打印模板的类型
/// Input：argEPRTemplateCategoryId: PrtTemplate或TempCate类型的EPRmeta.EPRTemplateCategory记录rowid
/// Output: 绑定打印模板的类型，共三种情况
/// 			Single 		唯一打印模板
/// 			Multiple 	可重复打印模板
/// 			""			未绑定任何类型打印模板
/// Debug: w ##class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateType("43")
ClassMethod GetBindPrtTemplateType(argEPRTemplateCategoryId) As %String
{
	q:(argEPRTemplateCategoryId="") ""
	
	s objEPRTemplateCategory = ##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRTemplateCategoryId)
	q:(objEPRTemplateCategory="") ""
	
	s bindPrtTemplateId = objEPRTemplateCategory.BindPrnTemplateID
	q:(bindPrtTemplateId="") ""
	
	s objPrtTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(bindPrtTemplateId)
	q:(objPrtTemplate="") ""
	
	q objPrtTemplate.ChartItemType
}

/// Desc:	获取目录名称信息
ClassMethod GetCategoryInfoByIDs(AEPRTemplateCategoryIDs As %String) As EPRservice.dataset.EEPRTplCateInfoDataset [ WebMethod ]
{
	s ds = ##Class(EPRservice.dataset.EEPRTplCateInfoDataset).%New()
	d ds.SetArgs(AEPRTemplateCategoryIDs)
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
		S argEPRTemplateCategoryID = $P(argstrItem,"^",1)
		S argCategorySeq = $P(argstrItem,"^",2)
		if ($d(argEPRTemplateCategoryID)=0)||($d(argCategorySeq)=0)||(argEPRTemplateCategoryID="")||(argCategorySeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s aEPRTemplateCategory="",result=""
		s aEPRTemplateCategory=##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRTemplateCategoryID)
		if (aEPRTemplateCategory ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s aEPRTemplateCategory.CategorySeq=argCategorySeq
		s result=""
		if '(aEPRTemplateCategory.%Save())
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

/// CreateUser: houj
/// CreateDate: 2012-12-27
/// Desc: 获取绑定打印模板的ID
/// Input：argEPRTemplateCategoryId: EPRmeta.EPRTemplateCategory记录rowid
/// Output: 绑定打印模板的ID，共三种情况
/// Debug: w ##class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateID("43")
ClassMethod GetBindPrtTemplateID(argEPRTemplateCategoryId) As %String
{
	q:(argEPRTemplateCategoryId="") ""
	
	s objEPRTemplateCategory = ##class(EPRmeta.EPRTemplateCategory).%OpenId(argEPRTemplateCategoryId)
	q:(objEPRTemplateCategory="") ""
	
	q objEPRTemplateCategory.BindPrnTemplateID
}

}
