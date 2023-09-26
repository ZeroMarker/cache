Class EPRservice.BOEPRTemplate Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRTemplate";

/// Modify by Candyxu 2012-08 增加参数 argType用来分辨存储的是模板还是扫描图片目录，当其值为"PhotoScan"时增加的是知情同意书目录
ClassMethod Add(argEPRTemplate As EPRservice.entity.EEPRTemplate, argType As %String) As %String [ WebMethod ]
{
	q:($d(argEPRTemplate)=0)||(argEPRTemplate="") 0
	q:(argEPRTemplate.BindTemplateID = "") ""
	if (argType '= "PhotoScan")
	{
	    //取出界面模板上级的Category
	    s objBindTemplate = ##class(EPRmeta.Template).%OpenId(argEPRTemplate.BindTemplateID)
	    q:(objBindTemplate = "" ) ""
	    s bindCategoryId = objBindTemplate.TemplateCategoryID
	    d objBindTemplate.%Close()
	    k objBindTemplate
	
	    q:(bindCategoryId = "") ""
	}else
	{
		s bindCategoryId = argEPRTemplate.BindTemplateID
	}

	s objBindTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(bindCategoryId)
	q:(objBindTemplateCategory = "") ""
	s bindTemplateCategoryName = objBindTemplateCategory.Name
	d objBindTemplateCategory.%Close()
	k objBindTemplateCategory
	
    s argEPRTemplate.BindTemplateCategoryID = bindCategoryId
	s argEPRTemplate.EPRTemplateName = bindTemplateCategoryName

	//
	s aEPRTemplate=""
	s aEPRTemplate=##class(EPRmeta.EPRTemplate).%New()
	q:(aEPRTemplate="") ""
	
	s aEPRTemplate.EPRTemplateName=argEPRTemplate.EPRTemplateName
	s aEPRTemplate.EPRCategoryID=argEPRTemplate.EPRCategoryID
	s aEPRTemplate.EPRTemplateSeq=argEPRTemplate.EPRTemplateSeq
	s aEPRTemplate.BindTemplateID=argEPRTemplate.BindTemplateID
	s aEPRTemplate.BindTemplateCategoryID=argEPRTemplate.BindTemplateCategoryID
	s aEPRTemplate.NecessaryTemplate=argEPRTemplate.NecessaryTemplate
	
	s result=""
	s result=aEPRTemplate.%Save()
	q aEPRTemplate.%Id()_"^"_bindTemplateCategoryName
}

ClassMethod Delete(argEPRTemplateID As %String) As %String [ WebMethod ]
{
	q:($d(argEPRTemplateID)=0)||(argEPRTemplateID="") 0
	s aEPRTemplate="",result=""
	s aEPRTemplate=##class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
	q:(aEPRTemplate="") "0"
	q:(aEPRTemplate.NecessaryTemplate = "1") "2"   //必填项不允许删除
	s aEPRTemplate=""
	s result=##class(EPRmeta.EPRTemplate).%DeleteId(argEPRTemplateID)
	q result
}

ClassMethod Update(argEPRTemplateID As %String, argEPRTemplate As EPRservice.entity.EEPRTemplate) As %String [ WebMethod ]
{
	q:($d(argEPRTemplateID)=0)||($d(argEPRTemplate)=0)||(argEPRTemplateID="")||(argEPRTemplate="") 0
	s aEPRTemplate="",result=""
	s aEPRTemplate=##class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
	q:(aEPRTemplate="") 0
	
	s aEPRTemplate.EPRTemplateName=argEPRTemplate.EPRTemplateName
	s aEPRTemplate.EPRCategoryID=argEPRTemplate.EPRCategoryID
	s aEPRTemplate.EPRTemplateSeq=argEPRTemplate.EPRTemplateSeq
	s aEPRTemplate.BindTemplateID=argEPRTemplate.BindTemplateID
	s aEPRTemplate.BindTemplateCategoryID=argEPRTemplate.BindTemplateCategoryID
	s aEPRTemplate.NecessaryTemplate=argEPRTemplate.NecessaryTemplate
	
	s result=""
	s result=aEPRTemplate.%Save()
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
		S argEPRTemplateID = $P(argstrItem,"^",1)
		S argEPRTemplateSeq = $P(argstrItem,"^",2)
		if ($d(argEPRTemplateID)=0)||($d(argEPRTemplateSeq)=0)||(argEPRTemplateID="")||(argEPRTemplateSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s aEPRTemplate="",result=""
		s aEPRTemplate=##class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
		if (aEPRTemplate ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s aEPRTemplate.EPRTemplateSeq=argEPRTemplateSeq
		s result=""
		if '(aEPRTemplate.%Save())
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

ClassMethod GetById(argEPRTemplateID As %String) As EPRservice.entity.EEPRTemplate [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.EEPRTemplate).%New()
	
	s tmpResult=##class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
	q:(tmpResult="") result
	s result.ID=argEPRTemplateID
	s result.EPRTemplateName=tmpResult.EPRTemplateName
	s result.EPRCategoryID=tmpResult.EPRCategoryID
	s result.EPRTemplateSeq=tmpResult.EPRTemplateSeq
	s result.BindTemplateID=tmpResult.BindTemplateID
	s result.BindTemplateCategoryID=tmpResult.BindTemplateCategoryID
	s result.NecessaryTemplate=tmpResult.NecessaryTemplate
	
	q result
}

ClassMethod GetAll() As EPRservice.dataset.EEPRTemplateDatasetAll [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EEPRTemplateDatasetAll).%New()
	Quit result
}

ClassMethod GetTemplateProperty(argEPRTemplateID As %String) As EPRservice.entity.EEPRCategoryProperty [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.EEPRCategoryProperty).%New()
	
	s tmpResult=##class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
	q:(tmpResult="") ""
	s result.Name=tmpResult.EPRTemplateName
	s result.NecessaryTemplate=tmpResult.NecessaryTemplate
	s result.NodeRule=tmpResult.PrivRuleDR
	
	//取出界面模板上级的Category
	s resultDirName = ""
	s bindTemplateId = tmpResult.BindTemplateID
	s curCategoryId = tmpResult.BindTemplateCategoryID
	d tmpResult.%Close()
	k tmpResult
	
	if (bindTemplateId '= "")
	{
		s objBindTemplate = ##class(EPRmeta.Template).%OpenId(bindTemplateId)
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
		s objBindTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(curCategoryId)
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

ClassMethod SetTemplateProperty(argEPRTemplateID As %String, argCategoryProperty As EPRservice.entity.EEPRCategoryProperty) As %String [ WebMethod ]
{
	q:((argEPRTemplateID="") || (argCategoryProperty="")) 0
	s tmpResult=""
	s tmpResult=##class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
	q:(tmpResult="") 0
	s tmpResult.EPRTemplateName = argCategoryProperty.Name
	s tmpResult.NecessaryTemplate = argCategoryProperty.NecessaryTemplate
	s tmpResult.PrivRuleDR = argCategoryProperty.NodeRule
	q tmpResult.%Save()
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   依据EPRmeta.EPRTemplate.RowID获取其配置目录的全路径字符串
/// Table：        EPRmeta.EPRTemplate,EPRmeta.EPRTemplateCategory
/// Input：        
/// Output：       对输出参数的说明
/// Return：       \TemplateCategoryName(Category)\TemplateCategoryName(CategoryChapter)\TemplateCategoryName(PrtTemplate)\TemplateName
/// Others
/// Debug: w ##class(EPRservice.BOEPRTemplate).GetTemplateAllPathString("14")
ClassMethod GetTemplateAllPathString(argEPRTemplateID As %String) As %String
{
	s objEprTemplate=##Class(EPRmeta.EPRTemplate).%OpenId(argEPRTemplateID)
	s TemplateName=objEprTemplate.EPRTemplateName
    s TCategoryID=objEprTemplate.EPRCategoryID
    s TemplateCategroy=##Class(EPRmeta.EPRTemplateCategory).%OpenId(TCategoryID)
    if (TemplateCategroy.CategoryType ="PrtTemplate")
    {
	  s PCategoryName=TemplateCategroy.CategoryName
	  s CCCategoryID=TemplateCategroy.ParentCategoryID  
	}
	d TemplateCategroy.%Close()
	
	s CCTemplateCategroy=##Class(EPRmeta.EPRTemplateCategory).%OpenId(CCCategoryID)
	if (CCTemplateCategroy.CategoryType ="CategoryChapter")
	{
	  s CCCategoryName=CCTemplateCategroy.CategoryName
	  s CategoryID=CCTemplateCategroy.ParentCategoryID
	}
	d CCTemplateCategroy.%Close()
	
	s Categroy=##Class(EPRmeta.EPRTemplateCategory).%OpenId(CategoryID)
	if (Categroy.CategoryType ="Category")
	{
	  s CategoryName=Categroy.CategoryName
	}
	d Categroy.%Close()
	
	q CategoryName_"\"_CCCategoryName_"\"_PCategoryName_"\"_TemplateName
}

/// Creator： LIfengbo
/// CreatDate： 2012-07-10
/// Description:： 通过BindTemplateID获取EPRTemplate中满足条件ID最小的数据对象
/// Table： EPRmeta.EPRTemplate
/// Input： argBindTemplateID  BindTemplateID的值
/// Output： EPRTemplate中满足BindTemplateID条件，ID最小的数据对象
/// Return： EPRTemplate中满足BindTemplateID条件，ID最小的数据对象
/// Others： 其它说明
ClassMethod GetByBindTemplateId(argBindTemplateID As %String) As EPRservice.entity.EEPRTemplate [ WebMethod ]
{
	q:(argBindTemplateID="")||(argBindTemplateID=$c(0))
		
	s result="",id="",tmpResult="",EPRTemplateID=""
	s result=##class(EPRservice.entity.EEPRTemplate).%New()
	s argBindTemplateID=" "_argBindTemplateID
	s EPRTemplateID=$o(^DHCEPRM.EPRTemplateI("IdxBindTemplateID",argBindTemplateID,EPRTemplateID)) 
	q:EPRTemplateID=""
		
	s tmpResult=##class(EPRmeta.EPRTemplate).%OpenId(EPRTemplateID)
	q:(tmpResult="") result
	s result.ID=EPRTemplateID
	s result.EPRTemplateName=tmpResult.EPRTemplateName
	s result.EPRCategoryID=tmpResult.EPRCategoryID
	s result.EPRTemplateSeq=tmpResult.EPRTemplateSeq
	s result.BindTemplateID=tmpResult.BindTemplateID
	s result.BindTemplateCategoryID=tmpResult.BindTemplateCategoryID
	s result.NecessaryTemplate=tmpResult.NecessaryTemplate
	q result
}

/// Creator： LIfengbo
/// CreatDate： 2012-07-10
/// Description:： 同步满足BindTemplateID条件的EPRTemplate数据项
/// Table： EPRmeta.EPRTemplate
/// Input： argBindTemplateID  BindTemplateID的值
/// Output： EPRTemplate中满足BindTemplateID条件数据数目
/// Return： EPRTemplate中满足BindTemplateID条件数据数目
/// Others： 其它说明
ClassMethod SynchronEPRTemplateByBTID(argBindTemplateID As %String) As EPRservice.entity.EEPRTemplate [ WebMethod ]
{
	s EPRTemplateID="",num=0
	s argBindTemplateID=" "_argBindTemplateID
	f  s EPRTemplateID=$o(^DHCEPRM.EPRTemplateI("IdxBindTemplateID",argBindTemplateID,EPRTemplateID))  q:EPRTemplateID=""  d
	.s num=num+1
	.i num=1 d GetBindTemplateCategoryID 
	.e  d SynchronBindTemplateCategoryID
	q num
GetBindTemplateCategoryID
	s EPRTemplateobj=##class(EPRmeta.EPRTemplate).%OpenId(EPRTemplateID)
	s SynchronEPRTemplateCategoryID=EPRTemplateobj.BindTemplateCategoryID
	d EPRTemplateobj.%Close()
	s EPRTemplateobj=""
		
SynchronBindTemplateCategoryID
	s EPRTemplateobjm=##class(EPRmeta.EPRTemplate).%OpenId(EPRTemplateID)
	s EPRTemplateobjm.BindTemplateCategoryID=SynchronEPRTemplateCategoryID
	d EPRTemplateobjm.%Save()
	d EPRTemplateobjm.%Close()
	s EPRTemplateobjm=""
}

}
