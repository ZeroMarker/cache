Class EMRservice.BOEMRTemplate Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRTemplate";

/// Modify by Candyxu 2012-08 增加参数 argType用来分辨存储的是模板还是扫描图片目录，当其值为"PhotoScan"时增加的是知情同意书目录
ClassMethod Add(argEMRTemplate As EMRservice.entity.EEMRTemplate, argType As %String) As %String [ WebMethod ]
{
	q:($d(argEMRTemplate)=0)||(argEMRTemplate="") ""
	q:(argEMRTemplate.BindTemplateID = "") ""
	s bindTemplateName = "" 
	if (argType '= "PhotoScan")
	{
	    //取出界面模板上级的Category
	    s objBindTemplate = ##class(EMRmeta.Template).%OpenId(argEMRTemplate.BindTemplateID)
	    q:(objBindTemplate = "" ) ""
	    s bindCategoryId = objBindTemplate.TemplateCategoryID
	   	s bindTemplateName = objBindTemplate.Name
	    d objBindTemplate.%Close()
	    k objBindTemplate
	
	    q:(bindCategoryId = "") ""
	}else
	{
		s bindCategoryId = argEMRTemplate.BindTemplateID
	}
	s objBindTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(bindCategoryId)
	q:(objBindTemplateCategory = "") ""
	;s bindTemplateCategoryName = objBindTemplateCategory.Name
	d objBindTemplateCategory.%Close()
	k objBindTemplateCategory

    s argEMRTemplate.BindTemplateCategoryID = bindCategoryId
	s argEMRTemplate.TemplateName = bindTemplateName

	//
	s aEMRTemplate=""
	s aEMRTemplate=##class(EMRmeta.EMRTemplate).%New()
	q:(aEMRTemplate="") ""

	s aEMRTemplate.TemplateName=argEMRTemplate.TemplateName
	s aEMRTemplate.CategoryID=argEMRTemplate.CategoryID
	s aEMRTemplate.TemplateSeq=argEMRTemplate.TemplateSeq
	s aEMRTemplate.BindTemplateID=argEMRTemplate.BindTemplateID
	s aEMRTemplate.BindTemplateCategoryID=argEMRTemplate.BindTemplateCategoryID
	s aEMRTemplate.NecessaryTemplate=argEMRTemplate.NecessaryTemplate
	s aEMRTemplate.InternalID=argEMRTemplate.InternalID

	s result=""
	s result=aEMRTemplate.%Save()
	s aEMRTemplate.TemplateSeq = aEMRTemplate.%Id()
	s result=aEMRTemplate.%Save()
	q aEMRTemplate.%Id()_"^"_bindTemplateName
}

ClassMethod Delete(argEMRTemplateID As %String) As %String [ WebMethod ]
{
	q:($d(argEMRTemplateID)=0)||(argEMRTemplateID="") 0
	s aEMRTemplate="",result=""
	s aEMRTemplate=##class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
	q:(aEMRTemplate="") "0"
	q:(aEMRTemplate.NecessaryTemplate = "1") "2"   //必填项不允许删除
	s aEMRTemplate=""
	s result=##class(EMRmeta.EMRTemplate).%DeleteId(argEMRTemplateID)
	q result
}

ClassMethod Update(argEMRTemplateID As %String, argEMRTemplate As EMRservice.entity.EEMRTemplate) As %String [ WebMethod ]
{
	q:($d(argEMRTemplateID)=0)||($d(argEMRTemplate)=0)||(argEMRTemplateID="")||(argEMRTemplate="") 0
	s aEMRTemplate="",result=""
	s aEMRTemplate=##class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
	q:(aEMRTemplate="") 0
	
	s aEMRTemplate.TemplateName=argEMRTemplate.TemplateName
	s aEMRTemplate.CategoryID=argEMRTemplate.CategoryID
	s aEMRTemplate.TemplateSeq=argEMRTemplate.TemplateSeq
	s aEMRTemplate.BindTemplateID=argEMRTemplate.BindTemplateID
	s aEMRTemplate.BindTemplateCategoryID=argEMRTemplate.BindTemplateCategoryID
	s aEMRTemplate.NecessaryTemplate=argEMRTemplate.NecessaryTemplate
	s aEMRTemplate.InternalID=argEMRTemplate.InternalID
	
	s result=""
	s result=aEMRTemplate.%Save()
	q result
}

/// 批量更新排序字段 by yejian
ClassMethod UpdateTemplateSeq(argStr As %String) As %String [ WebMethod ]
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
		S argstrItem= $P(argStr,",",I)
		S argEMRTemplateID = $P(argstrItem,"^",1)
		S argEMRTemplateSeq = $P(argstrItem,"^",2)
		if ($d(argEMRTemplateID)=0)||($d(argEMRTemplateSeq)=0)||(argEMRTemplateID="")||(argEMRTemplateSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s aEMRTemplate="",result=""
		s aEMRTemplate=##class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
		if (aEMRTemplate ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s aEMRTemplate.TemplateSeq=argEMRTemplateSeq
		s result=""
		if '(aEMRTemplate.%Save())
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

ClassMethod GetById(argEMRTemplateID As %String) As EMRservice.entity.EEMRTemplate [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EMRservice.entity.EEMRTemplate).%New()
	
	s tmpResult=##class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
	q:(tmpResult="") result
	s result.ID=argEMRTemplateID
	s result.TemplateName=tmpResult.TemplateName
	s result.CategoryID=tmpResult.CategoryID
	s result.TemplateSeq=tmpResult.TemplateSeq
	s result.BindTemplateID=tmpResult.BindTemplateID
	s result.BindTemplateCategoryID=tmpResult.BindTemplateCategoryID
	s result.NecessaryTemplate=tmpResult.NecessaryTemplate
	s result.InternalID=tmpResult.InternalID
	
	q result
}

ClassMethod GetAll() As EMRservice.dataset.EEMRTemplateDatasetAll [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EEMRTemplateDatasetAll).%New()
	Quit result
}

ClassMethod GetTemplateProperty(argEMRTemplateID As %String) As EMRservice.entity.EEMRCategoryProperty [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EMRservice.entity.EEMRCategoryProperty).%New()
	
	s tmpResult=##class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
	q:(tmpResult="") ""
	s result.Name=tmpResult.TemplateName
	s result.NecessaryTemplate=tmpResult.NecessaryTemplate
	s result.NodeRule=tmpResult.PrivRuleDR
	s result.InternalID=tmpResult.InternalID
	
	//取出界面模板上级的Category
	s resultDirName = ""
	s bindTemplateId = tmpResult.BindTemplateID
	s curCategoryId = tmpResult.BindTemplateCategoryID
	d tmpResult.%Close()
	k tmpResult
	
	if (bindTemplateId '= "")
	{
		s objBindTemplate = ##class(EMRmeta.Template).%OpenId(bindTemplateId)
		if (objBindTemplate '= "" )
		{
			s resultDirName = objBindTemplate.Name
			d objBindTemplate.%Close()
			k objBindTemplate
		}
	}
	
	for {
		q:(curCategoryId = "")
		
		s objBindTemplateCategory = "",bindTemplateCategoryName=""
		s objBindTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(curCategoryId)
		q:(objBindTemplateCategory = "")
		s bindTemplateCategoryName = objBindTemplateCategory.Name
		s curCategoryId = objBindTemplateCategory.ParentID
		d objBindTemplateCategory.%Close()
		k objBindTemplateCategory
		
		s resultDirName = bindTemplateCategoryName_"\"_resultDirName
	}

	s result.ResourceDir=resultDirName
	q result
}

ClassMethod SetTemplateProperty(argEMRTemplateID As %String, argCategoryProperty As EMRservice.entity.EEMRCategoryProperty) As %String [ WebMethod ]
{
	q:((argEMRTemplateID="") || (argCategoryProperty="")) 0
	s tmpResult=""
	s tmpResult=##class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
	q:(tmpResult="") 0
	s tmpResult.TemplateName = argCategoryProperty.Name
	s tmpResult.NecessaryTemplate = argCategoryProperty.NecessaryTemplate
	s tmpResult.PrivRuleDR = argCategoryProperty.NodeRule
	s tmpResult.InternalID = argCategoryProperty.InternalID
	q tmpResult.%Save()
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   依据EMRmeta.EMRTemplate.RowID获取其配置目录的全路径字符串
/// Table：        EMRmeta.EMRTemplate,EMRmeta.EMRTemplateCategory
/// Input：        
/// Output：       对输出参数的说明
/// Return：       \TemplateCategoryName(Category)\TemplateCategoryName(CategoryChapter)\TemplateCategoryName(PrtTemplate)\TemplateName
/// Others
/// Debug: w ##class(EMRservice.BOEMRTemplate).GetTemplateAllPathString("14")
ClassMethod GetTemplateAllPathString(argEMRTemplateID As %String) As %String
{
	s objEprTemplate=##Class(EMRmeta.EMRTemplate).%OpenId(argEMRTemplateID)
	s TemplateName=objEprTemplate.TemplateName
    s TCategoryID=objEprTemplate.CategoryID
    s TemplateCategroy=##Class(EMRmeta.EMRTemplateCategory).%OpenId(TCategoryID)
    if (TemplateCategroy.CategoryType ="PrtTemplate")
    {
	  s PCategoryName=TemplateCategroy.CategoryName
	  s CCCategoryID=TemplateCategroy.ParentCategoryID  
	}
	d TemplateCategroy.%Close()
	
	s CCTemplateCategroy=##Class(EMRmeta.EMRTemplateCategory).%OpenId(CCCategoryID)
	if (CCTemplateCategroy.CategoryType ="CategoryChapter")
	{
	  s CCCategoryName=CCTemplateCategroy.CategoryName
	  s CategoryID=CCTemplateCategroy.ParentCategoryID
	}
	d CCTemplateCategroy.%Close()
	
	s Categroy=##Class(EMRmeta.EMRTemplateCategory).%OpenId(CategoryID)
	if (Categroy.CategoryType ="Category")
	{
	  s CategoryName=Categroy.CategoryName
	}
	d Categroy.%Close()
	
	q CategoryName_"\"_CCCategoryName_"\"_PCategoryName_"\"_TemplateName
}

/// Creator： LIfengbo
/// CreatDate： 2012-07-10
/// Description:： 通过BindTemplateID获取EMRTemplate中满足条件ID最小的数据对象
/// Table： EMRmeta.EMRTemplate
/// Input： argBindTemplateID  BindTemplateID的值
/// Output： EMRTemplate中满足BindTemplateID条件，ID最小的数据对象
/// Return： EMRTemplate中满足BindTemplateID条件，ID最小的数据对象
/// Others： 其它说明
ClassMethod GetByBindTemplateId(argBindTemplateID As %String) As EMRservice.entity.EEMRTemplate [ WebMethod ]
{
	q:(argBindTemplateID="")||(argBindTemplateID=$c(0))
		
	s result="",id="",tmpResult="",EMRTemplateID=""
	s result=##class(EMRservice.entity.EEMRTemplate).%New()
	s argBindTemplateID=" "_argBindTemplateID
	s EMRTemplateID=$o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID",argBindTemplateID,EMRTemplateID)) 
	q:EMRTemplateID=""
		
	s tmpResult=##class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
	q:(tmpResult="") result
	s result.ID=EMRTemplateID
	s result.TemplateName=tmpResult.TemplateName
	s result.CategoryID=tmpResult.CategoryID
	s result.TemplateSeq=tmpResult.TemplateSeq
	s result.BindTemplateID=tmpResult.BindTemplateID
	s result.BindTemplateCategoryID=tmpResult.BindTemplateCategoryID
	s result.NecessaryTemplate=tmpResult.NecessaryTemplate
	s result.InternalID=tmpResult.InternalID
	q result
}

/// Creator： LIfengbo
/// CreatDate： 2012-07-10
/// Description:： 同步满足BindTemplateID条件的EMRTemplate数据项
/// Table： EMRmeta.EMRTemplate
/// Input： argBindTemplateID  BindTemplateID的值
/// Output： EMRTemplate中满足BindTemplateID条件数据数目
/// Return： EMRTemplate中满足BindTemplateID条件数据数目
/// Others： 其它说明
ClassMethod SynchronEMRTemplateByBTID(argBindTemplateID As %String) As EMRservice.entity.EEMRTemplate [ WebMethod ]
{
	s EMRTemplateID="",num=0
	s argBindTemplateID=" "_argBindTemplateID
	f  s EMRTemplateID=$o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID",argBindTemplateID,EMRTemplateID))  q:EMRTemplateID=""  d
	.s num=num+1
	.i num=1 d GetBindTemplateCategoryID 
	.e  d SynchronBindTemplateCategoryID
	q num
GetBindTemplateCategoryID
	s EMRTemplateobj=##class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
	s SynchronEMRTemplateCategoryID=EMRTemplateobj.BindTemplateCategoryID
	d EMRTemplateobj.%Close()
	s EMRTemplateobj=""
		
SynchronBindTemplateCategoryID
	s EMRTemplateobjm=##class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
	s EMRTemplateobjm.BindTemplateCategoryID=SynchronEMRTemplateCategoryID
	d EMRTemplateobjm.%Save()
	d EMRTemplateobjm.%Close()
	s EMRTemplateobjm=""
}

}
