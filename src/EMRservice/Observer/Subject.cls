/// Class Name:		EMRservice.Observer.Subject
/// Description:	对电子病历订阅信息表的操作
/// Creator:		Lina
/// Create Date:	2015-09-17
Class EMRservice.Observer.Subject Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description:	根据事件索引查询数据
/// Creator: 		Lina
/// Create Date:	2015-09-17
/// Debug:          d ##class(EMRservice.Observer.Subject).GetSubjectInfo("SAVE|17")
ClassMethod GetSubjectInfo(AEvent As %String, ArgType As %String = "") As %ArrayOfObjects
{
	q:(AEvent="") ""
	s count = 0
	s subjectID = ""
	s arr = ##Class(%ArrayOfObjects).%New()
	for {
		s subjectID = $o(^DHCEMRM.SubjectI("Idx"," "_AEvent,subjectID))
		q:subjectID=""
		
		s Subjectobj = ##class(EMRmeta.Subject).%OpenId(subjectID)
		q:Subjectobj=""
		
		continue:(ArgType '= "")&&(ArgType '= Subjectobj.Type)
		
		s entity = ##Class(EMRservice.entity.ESubject).%New()
		s entity.Code = Subjectobj.Code
		s entity.Glossary = Subjectobj.Glossary
		s entity.Description = Subjectobj.Description
		s entity.Expression = Subjectobj.Expression
		s entity.Type = Subjectobj.Type
		s entity.IsActive = Subjectobj.IsActive
		s entity.ResumeText = Subjectobj.ResumeText
		s entity.Event = Subjectobj.Event
		s entity.ID = subjectID
		s count = count + 1
		d arr.SetAt(entity,count)
	}
	q arr
}

/// Description:	插入数据
/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Return:         1:插入成功   -1：插入失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.Subject).Insert("NAME^HDSD00.11.110^患者姓名^^PaPatMas^Y^患者本人在公安户籍管理部门正式登记注册的姓氏和名称^SAVE|1")
ClassMethod Insert(ArgInput As %String) As %String
{
	q:ArgInput="" -2
	s ReturnValue = 0
	s code = $p(ArgInput,"^",1)
	s glossary = $p(ArgInput,"^",2)
	s description = $p(ArgInput,"^",3)
	s expression = $p(ArgInput,"^",4)
	s type = $p(ArgInput,"^",5)
	s isActive = $p(ArgInput,"^",6)
	s resumeText = $p(ArgInput,"^",7)
	s event = $p(ArgInput,"^",8)
	
	s Subjectobj = ##class(EMRmeta.Subject).%New()
	s Subjectobj.Code = code
	s Subjectobj.Glossary = glossary
	s Subjectobj.Description = description
	s Subjectobj.Expression = expression
	s Subjectobj.Type = type
	s Subjectobj.IsActive = isActive
	s Subjectobj.ResumeText = resumeText
	s Subjectobj.Event = event
	s sc = Subjectobj.%Save()
	
	if $system.Status.IsError(sc) //检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d Subjectobj.%Close()
	s Subjectobj = ""
	quit ReturnValue
}

/// Description:	插入数据
/// Creator:	    YHY
/// Create Date:	2012-10-28
/// Return:         1:插入成功   -1：插入失败   -2：缺少参数
/// Debug:          w ##class(EMRservice.Observer.Subject).Insert("NAME^HDSD00.11.110^患者姓名^^PaPatMas^Y^患者本人在公安户籍管理部门正式登记注册的姓氏和名称^SAVE|1")
ClassMethod Update(ASubjectID As %String, ArgInput As %String) As %String
{
	s Subjectobj = ##class(EMRmeta.Subject).%OpenId(ASubjectID)
	q:(Subjectobj = "") -3
	
	q:ArgInput="" -2
	
	s ReturnValue = 0
	s code = $p(ArgInput,"^",1)
	s glossary = $p(ArgInput,"^",2)
	s description = $p(ArgInput,"^",3)
	s expression = $p(ArgInput,"^",4)
	s type = $p(ArgInput,"^",5)
	s isActive = $p(ArgInput,"^",6)
	s resumeText = $p(ArgInput,"^",7)
	s event = $p(ArgInput,"^",8)
	
	s Subjectobj.Code = code
	s Subjectobj.Glossary = glossary
	s Subjectobj.Description = description
	s Subjectobj.Expression = expression
	s Subjectobj.Type = type
	s Subjectobj.IsActive = isActive
	s Subjectobj.ResumeText = resumeText
	//s Subjectobj.Event = event
	s sc = Subjectobj.%Save()
	
	if $system.Status.IsError(sc) //检查Save是否成功
	{                               
   		d $system.OBJ.DisplayError(sc) 
   		set ReturnValue = -1
	}
	else
	{
		set ReturnValue = 1
	}
	d Subjectobj.%Close()
	s Subjectobj = ""
	quit ReturnValue
}

/// Desc:	配置订阅信息基础数据
/// 	Debug:	w ##Class(EMRservice.Observer.Subject).RegSubjectConfig("SAVE|32","入院记录初步诊断^入院记录初步诊断^入院记录初步诊断^^WMRInfection^Y^传染病上报^SAVE|32")
ClassMethod RegSubjectConfig(AEvent, AType, AEventConfig) As %String
{
	s event = ..GetSubjectInfo(AEvent, AType)
	if (event.Count() > 0)
	{
		s ret = ..Update(event.GetAt("1").ID,AEventConfig)
	}
	else
	{
		s ret = ..Insert(AEventConfig)
	}
	
	q ret
}

/// Debug:	d ##Class(EMRservice.Observer.Subject).InitConfigWMRInfection("SAVE|32","入院记录初步诊断","入院记录初步诊断")
/// 			d ##Class(EMRservice.Observer.Subject).InitConfigWMRInfection("SAVE|33","诊断变更记录当前诊断","诊断变更记录当前诊断")
/// 			d ##Class(EMRservice.Observer.Subject).InitConfigWMRInfection("SAVE|15","首页诊断信息","首页诊断信息")
ClassMethod InitConfigWMRInfection(event, glossary, desc)
{
	s code = "WMRInfection", type = "WMRInfection", resume = "传染病上报", exp = "", isactive = "Y"
	
	s config = code_"^"_glossary_"^"_desc_"^"_exp_"^"_type_"^"_isactive_"^"_resume_"^"_event 
	
	w !,##Class(EMRservice.Observer.Subject).RegSubjectConfig(event,type,config)
}

/// 	Debug:	d ##Class(EMRservice.Observer.Subject).InitConfigNosocomialInfection("SAVE|155","首页诊断信息","首页诊断信息")
ClassMethod InitConfigNosocomialInfection(event, glossary, desc)
{
	s code = "NosocomialInfection", type = "NosocomialInfection", resume = "院内感染上报", exp = "", isactive = "Y"
	
	s config = code_"^"_glossary_"^"_desc_"^"_exp_"^"_type_"^"_isactive_"^"_resume_"^"_event 
	
	w !,##Class(EMRservice.Observer.Subject).RegSubjectConfig(event,type,config)
}

}
