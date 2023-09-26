/// 名称：		EMRservice.BL.BLUserTemplateSectionRelation
/// 描述：		用户模板章节继承关系BL层
/// 编写者：	yejian
/// 编写时间：	2016-8-2
Class EMRservice.BL.BLUserTemplateSectionRelation Extends (%RegisteredObject, %XML.Adaptor)
{

/// 根据科室ID获取用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateSectionRelation","GetSectionSByTemplateID","1")
Query GetSectionSByTemplateID(aTemplateID As %String) As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,Code:%String,Name:%String,SectionCode:%String,SectionName:%String,Status:%String")
{
}

ClassMethod GetSectionSByTemplateIDExecute(ByRef qHandle As %Binary, aTemplateID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(aTemplateID) = "")||(aTemplateID=$c(0))) $$$OK
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateID"," "_$zcvt(aTemplateID,"U"),rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowID)
		continue:(objUserTemSec = "")
	
		s TemplateID = objUserTemSec.TemplateID
		s Code = objUserTemSec.Code
		s Name = objUserTemSec.Name
		s SectionCode = objUserTemSec.SectionCode
		s SectionName = objUserTemSec.SectionName
		s Status = objUserTemSec.Status
	
		s Data = $lb(rowID,TemplateID,Code,Name,SectionCode,SectionName,Status)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod GetSectionSByTemplateIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSectionSByTemplateIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetSectionSByTemplateIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSectionSByTemplateIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据模板ID获取个人模板
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateSectionRelation","GetPersonSectionSByTemplateID","1")
Query GetPersonSectionSByTemplateID(aTemplateID As %String) As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,ExampleID:%String,Name:%String,SectionCode:%String,SectionName:%String,Status:%String")
{
}

ClassMethod GetPersonSectionSByTemplateIDExecute(ByRef qHandle As %Binary, aTemplateID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(aTemplateID) = "")||(aTemplateID=$c(0))) $$$OK
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.ExampleInsSecRelationI("IdxTemplateID"," "_$zcvt(aTemplateID,"U"),rowID))
		q:(rowID = "")
		s objPersonTemSec = ##Class(EMRmeta.ExampleInsSecRelation).%OpenId(rowID)
		continue:(objPersonTemSec = "")
	
		s TemplateID = objPersonTemSec.TemplateID
		s ExampleID = objPersonTemSec.ExampleID
		s Name = objPersonTemSec.Name
		s SectionCode = objPersonTemSec.SectionCode
		s SectionName = objPersonTemSec.SectionName
		s Status = objPersonTemSec.Status
	
		s Data = $lb(rowID,TemplateID,ExampleID,Name,SectionCode,SectionName,Status)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod GetPersonSectionSByTemplateIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPersonSectionSByTemplateIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPersonSectionSByTemplateIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPersonSectionSByTemplateIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据科室ID获取用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateSectionRelation","GetSectionSByUserTempCode","1")
Query GetSectionSByUserTempCode(aCode As %String) As %Query(ROWSPEC = "ID:%Integer,TemplateID:%String,Code:%String,Name:%String,SectionCode:%String,SectionName:%String,Status:%String")
{
}

ClassMethod GetSectionSByUserTempCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(($g(aCode) = "")||(aCode=$c(0))) $$$OK
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCode"," "_$zcvt(aCode,"U"),rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowID)
		continue:(objUserTemSec = "")
	
		s TemplateID = objUserTemSec.TemplateID
		s Code = objUserTemSec.Code
		s Name = objUserTemSec.Name
		s SectionCode = objUserTemSec.SectionCode
		s SectionName = objUserTemSec.SectionName
		s Status = objUserTemSec.Status
	
		s Data = $lb(rowID,TemplateID,Code,Name,SectionCode,SectionName,Status)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1	
		
	}
	
	q $$$OK
}

ClassMethod GetSectionSByUserTempCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSectionSByUserTempCodeExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetSectionSByUserTempCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSectionSByUserTempCodeExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 添加用户模板章节
ClassMethod AddUserTemplateSection(AUserTemplateSecRel As EMRservice.entity.EUserTemplateSectionRelation) As %String
{
	s ret = 1

	s objUserTemSecRelation = ##Class(EMRmeta.UserTemplateSectionRelation).%New()
	s objUserTemSecRelation.TemplateID =AUserTemplateSecRel.TemplateID
	s objUserTemSecRelation.Code =AUserTemplateSecRel.Code
	s objUserTemSecRelation.Name =AUserTemplateSecRel.Name
	s objUserTemSecRelation.SectionCode =AUserTemplateSecRel.SectionCode
	s objUserTemSecRelation.SectionName =AUserTemplateSecRel.SectionName
	s objUserTemSecRelation.Status =AUserTemplateSecRel.Status

	if (objUserTemSecRelation.%Save())
	{
	    s ret=objUserTemSecRelation.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objUserTemSecRelation.%Close()
	q ret
}

/// Desc:       新增用户模板章节关系根据科室模板编码
/// Creator:    yejian
/// Createdate: 2019-2-19
/// Input:      aTemplateID 模板ID
/// 			aUserTemCode 科室模板编码
///             aSectionCodes S001#患者基本信息^S002#主诉^S003#现病史^S004#既往史^S005#个人史^S007#婚姻史^S008#月经史
/// Output:     result 1成功,0失败 
/// debug: w ##Class(EMRservice.BL.BLUserTemplateSectionRelation).UpdateUserTSectionByTemID(1,"S005^|S003^80|S007^83")
ClassMethod AddUserTSectionCodeByUCode(aTemplateID As %String, aUserTemCode As %String, aSectionCodes As %String, AStatus As %String) As %String
{
	
	q:((aTemplateID="")|| (aTemplateID = $c(0))) "0"
	q:((aUserTemCode="")|| (aUserTemCode = $c(0))) "0"
	q:((aSectionCodes="")|| (aSectionCodes = $c(0))) "0"
	q:((AStatus="")|| (AStatus = $c(0))) "0"
	//s ^UpdateUserTSectionByTemID("123") =aTemplateID_","_aUCodeSectionCodes
	s strMrk = 1 
	s strSectionC = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateCodeSection"," "_aTemplateID," "_$zcvt(aUserTemCode,"U"),""))
	q:(strSectionC'="") strMrk
	s objUserTem =##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByCode(aUserTemCode)
	q:(objUserTem="") strMrk
	TSTART
	s intSecNum = $l(aSectionCodes,"^")
	For i=1:1:intSecNum
	{
		s strSectionItem = $p(aSectionCodes,"^",i)
		s strSecCode = $p(strSectionItem,"#",1)
		s strSecName = $p(strSectionItem,"#",2)
		s rowRelationID = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateCodeSection"," "_aTemplateID," "_$zcvt(aUserTemCode,"U")," "_$zcvt(strSecCode,"U"),""))
		if (rowRelationID="")
		{
			s objUserTemSecRelation = ##Class(EMRmeta.UserTemplateSectionRelation).%New()
			s objUserTemSecRelation.TemplateID =aTemplateID
			s objUserTemSecRelation.Code =aUserTemCode
			s objUserTemSecRelation.Name =objUserTem.Name
			s objUserTemSecRelation.SectionCode =strSecCode
			s objUserTemSecRelation.SectionName =strSecName
			s objUserTemSecRelation.Status =AStatus	
			if ('objUserTemSecRelation.%Save())
			{
			   TRollback
			   s strMrk=0
			   q
			}		
		}
	}

	if (strMrk = 0)
	{
	 	TROLLBACK
	}
	else
	{
		TCOMMIT
	}
	q strMrk
}

/// Desc:       发布更新用户模板章节关系根据模板ID（添加新章节，删除删除章节）
/// Creator:    yejian
/// Createdate: 2019-2-19
/// Input:      aTemplateID 模板ID
///             aUCodeSectionCodes 章节知识信息（S001#患者基本信息^S002#主    诉：^S003#入院情况：^S004#入院诊断：^S005#诊疗经过：^S006#出院情况：^S007#出院诊断：^S010#新增章节1^S011#新增章节2^S009#医师签名：.）
/// Output:     result 1成功,0失败 
/// debug: w ##Class(EMRservice.BL.BLUserTemplateSectionRelation).SetUserTSectionCodeByTemID(26,"S021#基本信息^S002#主    诉:^S003#现 病 史:^S004#既往史和其他病史:^S017#过 敏 史:^S010#体格检查:^S011#辅助检查:^S016#BP(mmHg):^S007#诊    断:^S015#处    理:^S013#病情变化及处置:^S008#治疗意见:^S020#医师签名)
ClassMethod SetUserTSectionCodeByTemID(aTemplateID As %String, aSectionCodeNames As %String) As %String
{
	q:((aTemplateID="")||(aSectionCodeNames="")|| (aTemplateID = $c(0))|| (aSectionCodeNames = $c(0))) "0"

	s strMrk = 1 
	s intSectionCount = $l(aSectionCodeNames, "^")
	TSTART
	
	//批量添加新增的章节关系
	s i = 1
	WHILE (i <= intSectionCount) 
	{
		s curSection = $p(aSectionCodeNames, "^", i)
		s strSecCode = $p(curSection,"#",1)
		s strSecName = $p(curSection,"#",2)
		if (strSecCode '= "")
		{
			s UTemCode = ""
			for {
				s UTemCode = $o(^DHCEMRM.UserTemplateI("IdxTemplateCode"," "_aTemplateID,UTemCode))
				q:(UTemCode="")
				s strTemCode = $tr(UTemCode," ")
				s objUseT = ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByCode(strTemCode)
				//如果科室模板已经删除则跳过
				continue:((objUseT="")||(objUseT.Status ="-1"))
				//
				s rowRelationID = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateCodeSection"," "_aTemplateID," "_$zcvt(strTemCode,"U")," "_$zcvt(strSecCode,"U"),""))
				if (rowRelationID="")
				{
					s objUserTemSecRelation = ##Class(EMRmeta.UserTemplateSectionRelation).%New()
					s objUserTemSecRelation.TemplateID =aTemplateID
					s objUserTemSecRelation.Code =strTemCode
					s objUserTemSecRelation.Name =objUseT.Name
					s objUserTemSecRelation.SectionCode =strSecCode
					s objUserTemSecRelation.SectionName =strSecName
					s objUserTemSecRelation.Status ="REFERENCE"	
					if ('objUserTemSecRelation.%Save())
					{
					   TRollback
					   s strMrk=0
					   q
					}		
				}
			}
		}
		s i = i + 1
	 }
	//批量删除基础模板已经删除的章节
	s aSectionCodeNamesNew = "^"_aSectionCodeNames
	s UTemCode = ""
	for {
		s UTemCode = $o(^DHCEMRM.UserTemplateI("IdxTemplateCode"," "_aTemplateID,UTemCode))
		q:(UTemCode="")
		s strTemCode = $tr(UTemCode," ")
		s objUseT = ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByCode(strTemCode)
		//如果科室模板已经删除则跳过
		continue:((objUseT="")||(objUseT.Status ="-1"))
		s strSecCode = ""
		for {
			s strSecCode = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateCodeSection"," "_aTemplateID," "_$zcvt(strTemCode,"U"),strSecCode))
			q:(strSecCode="")
			s strSecCodeNew = "^"_$tr(strSecCode," ")_"#"
			if ('(aSectionCodeNamesNew[strSecCodeNew))
			{
				s rowRelationID = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateCodeSection"," "_aTemplateID," "_$zcvt(strTemCode,"U"),strSecCode,""))
				q:(rowRelationID="")
				s objUserSec = ##class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowRelationID)
				q:(objUserSec="")
				if '(objUserSec.%DeleteId(rowRelationID))
				{
					TROLLBACK
					s strMrk = 0
					q
				}
			
			}
			
		}
	}
	
	//批量添加新增的章节关系到个人模板章节关联表（初始化为继承状态，如需改为替换可在前台编辑个人模板）
	s i = 1
	WHILE (i <= intSectionCount) 
	{
		s curSection = $p(aSectionCodeNames, "^", i)
		s strSecCode = $p(curSection,"#",1)
		s strSecName = $p(curSection,"#",2)
		if (strSecCode '= "")
		{
			s PerTmpID = ""
			for {
				s PerTmpID = $o(^DHCEMRM.ExampleInstanceI("TemplateID"," "_aTemplateID,PerTmpID))
				q:(PerTmpID="")
				s objPerTmp = ##Class(EMRmeta.ExampleInstance).%OpenId(PerTmpID)
				//如果个人模板无效则跳过
				continue:((objPerTmp="")||(objPerTmp.Status '="1"))
				s rowRelationID = $o(^DHCEMRM.ExampleInsSecRelationI("IdxTemplateExampleIDSection"," "_aTemplateID," "_PerTmpID," "_$zcvt(strSecCode,"U"),""))
				if (rowRelationID="")
				{
					s objPersonTemSecRelation = ##Class(EMRmeta.ExampleInsSecRelation).%New()
					s objPersonTemSecRelation.TemplateID=aTemplateID
					s objPersonTemSecRelation.ExampleID =PerTmpID
					s objPersonTemSecRelation.Name = objPerTmp.Name
					s objPersonTemSecRelation.SectionCode =strSecCode
					s objPersonTemSecRelation.SectionName =strSecName
					s objPersonTemSecRelation.Status ="REFERENCE"	
					if ('objPersonTemSecRelation.%Save())
					{
					   TRollback
					   s strMrk=0
					   q
					}		
				}
			}
		}
		s i = i + 1
	 }

	//批量删除个人模板中，基础模板已经删除的章节
	s aSectionCodeNamesNew = "^"_aSectionCodeNames
	s PerTmpID = ""
	for {
		s PerTmpID = $o(^DHCEMRM.ExampleInstanceI("TemplateID"," "_aTemplateID,PerTmpID))
		q:(PerTmpID="")
		s objPerTmp = ##Class(EMRmeta.ExampleInstance).%OpenId(PerTmpID)
		//如果个人模板无效则跳过
		continue:((objPerTmp="")||(objPerTmp.Status '="1"))
		s strSecCode = ""
		for {
			s strSecCode = $o(^DHCEMRM.ExampleInsSecRelationI("IdxTemplateExampleIDSection"," "_aTemplateID," "_PerTmpID,strSecCode))
			q:(strSecCode="")
			s strSecCodeNew = "^"_$tr(strSecCode," ")_"#"
			//当前模板章节中不包含已存储的章节即认为章节已删除
			if ('(aSectionCodeNamesNew[strSecCodeNew))
			{
				//删除个人模板章节继承关系表
				s rowRelationID = $o(^DHCEMRM.ExampleInsSecRelationI("IdxTemplateExampleIDSection"," "_aTemplateID," "_PerTmpID,strSecCode,""))
				q:(rowRelationID="")
				s objPerSecRela = ##class(EMRmeta.ExampleInsSecRelation).%OpenId(rowRelationID)
				q:(objPerSecRela ="")
				if '(objPerSecRela.%DeleteId(rowRelationID))
				{
					TROLLBACK
					s strMrk = 0
					q
				}

				//删除个人模板章节存储表
				s PerSecID = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",PerTmpID,strSecCode,""))
				q:(PerSecID="")
				s objPerSec = ##class(EMRmeta.ExampleInstanceSection).%OpenId(PerSecID)
				q:(objPerSec="")
				if '(objPerSec.%DeleteId(PerSecID))
				{
					TROLLBACK
					s strMrk = 0
					q
				}
			}
			
		}
	}

	if (strMrk = 0)
	{
		TROLLBACK
		quit "0"
	}
	//返回
	TCOMMIT
	q "1"
}

/// 修改用户模板科室
ClassMethod ModUserTemplateSection(AUserTemplateSecRel As EMRservice.entity.EUserTemplateSectionRelation) As %String
{
	s ret = 1
	
	s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCodeSection"," "_$zcvt(AUserTemplateSecRel.Code,"U")," "_$zcvt(AUserTemplateSecRel.SectionCode,"U"),""))
	q:(rowID = "") ret
	s objUserTemSecRelation = ##Class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowID)
	s objUserTemSecRelation.SectionName =AUserTemplateSecRel.SectionName
	s objUserTemSecRelation.Status =AUserTemplateSecRel.Status
	if (objUserTemSecRelation.%Save())
	{
	    s ret=objUserTemSecRelation.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objUserTemSecRelation.%Close()
	q ret
}

ClassMethod ModUserTemSecStatusByUCode(strUserCode As %String, SectionCodeList As %String, AStatus As %String) As %String
{
	s strMrk = "1"
	TStart
	q:((SectionCodeList = "")||(strUserCode = "")||(AStatus="")) strMrk
	s SectionCode = ""
	s rowID = ""
	for {
		s SectionCode = $o(^DHCEMRM.UserTemplateRelationI("IdxCodeSection"," "_$zcvt(strUserCode,"U"),SectionCode))
		q:(SectionCode = "")
		s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxCodeSection"," "_$zcvt(strUserCode,"U"),SectionCode,rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowID)
		q:(objUserTemSec = "")
		s curSectionCode = "^"_SectionCode_"^"
		s curSectionCode = $tr(curSectionCode," ")
		
		//纯文本或者不包含在章节编码字符集中
		if ((SectionCode ="")||'(SectionCodeList [ curSectionCode))
		{
			s objUserTemSec.Status = AStatus
			if ('objUserTemSec.%Save())
			{
				TROLLBACK
				s strMrk = 0
				q
			}
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
	 }
	 else
	 {
		TCOMMIT
	 }
	q strMrk
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String
{
	s ret = 1
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.UserTemplateSectionRelation).%OpenId(RowID)
	q:(RowID="") ret
	if '(obj.%DeleteId(RowID))
	{
		s ret = 0	
	}
	d obj.%Close()
	
	q ret
}

/// Desc:       模板发布批量更新科室模板章节关系信息
/// Creator:    yejian
/// Createdate: 2019-2-19
/// Input:      aTemplateID 模板ID
///             aUCodeSectionCodes 章节知识信息（sectionCode^kbbaseid或""|sectionCode^kbbaseid或""...）
/// Output:     result 1成功,0失败 
/// debug: w ##Class(EMRservice.BL.BLUserTemplateSectionRelation).UpdateUserTSectionByTemID(1,"S005^|S003^80|S007^83")
ClassMethod DelUserTSectionCodeByTemID(aTemplateID As %String, aSectionCode As %String) As %String
{
	
	q:((aTemplateID="")|| (aTemplateID = $c(0))) "0"
	//s ^UpdateUserTSectionByTemID("123") =aTemplateID_","_aUCodeSectionCodes
	s strMrk = 1 
	TSTART
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateSecCode",aTemplateID," "_$zcvt(aSectionCode,"U"),rowID))
		q:(rowID="")
		s objUserSec = ##class(EMRmeta.UserTemplateSectionRelation).%OpenId(rowID)
		q:(objUserSec="")
		if '(objUserSec.%DeleteId(rowID))
		{
			TROLLBACK
			s strMrk = 0
			q
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
	 }
	 else
	 {
		TCOMMIT
	 }
	q strMrk
}

/// 将旧的数据初始化到科室模板章节关系表中
/// creator: yejian
/// CreateDate: 2020-3-12
/// Input:     
/// Debug: d ##Class(EMRservice.BL.BLUserTemplateSectionRelation).MoveUserTemplateSectionRelations()
ClassMethod MoveUserTemplateSectionRelations()
{
	s totCount = 0
	s objMetaData = ##class(%GlobalBinaryStream).%New()
	s rowUseID = ""
	for {
		s rowUseID = $o(^DHCEMRM.UserTemplateD(rowUseID))
		q:(rowUseID="")
		s objUserTem = ##Class(EMRmeta.UserTemplate).%OpenId(rowUseID)
		//如果科室模板已经删除则跳过
		continue:((objUserTem="")||(objUserTem.Status ="-1"))
		s TemplateID = objUserTem.TemplateID
		s userTemName = objUserTem.Name
		s userTemCode = objUserTem.Code
		
		s objTemplate = ##class(EMRmeta.Template).%OpenId(TemplateID)
		continue:(objTemplate="")
		s AVersionNum = objTemplate.PublishVersion
		s sMetaData = ##class(EMRservice.BL.BLTemplateVersion).GetMetaData(TemplateID,AVersionNum)
	
		d objMetaData.CopyFrom(sMetaData)
		s strSections = ##class(EMRservice.BL.BLUserTemplateSectionRelation).GetDocumentContent(objMetaData)
		s intSecNum = $l(strSections,"^")
		For i=1:1:intSecNum
	 	{
			s strSectionItem = $p(strSections,"^",i)
			s strSecCode = $p(strSectionItem,"#",1)
			s strSecName = $p(strSectionItem,"#",2)
			s rowRelationID = $o(^DHCEMRM.UserTemplateRelationI("IdxTemplateCodeSection"," "_TemplateID," "_$zcvt(userTemCode,"U")," "_$zcvt(strSecCode,"U"),""))
			if (rowRelationID="")
			{
				s rowSecID = ""
				s rowSecID = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(userTemCode,"U")," "_$zcvt(strSecCode,"U"),rowSecID))
				s strStatus = "REFERENCE" 
				if (rowSecID'="")
				{
					s objUserTemSection = ##Class(EMRmeta.UserTemplateSection).%OpenId(rowSecID)
					s ActiveFlag = objUserTemSection.ActiveFlag
					s strStatus = $case(ActiveFlag,"1":"REPLACE",:"REFERENCE")
				}

				if (("67"=userTemCode)&&("S009"=strSecCode))
				{
					s tests = ""
				}
				s objUserTemSecRelation = ##Class(EMRmeta.UserTemplateSectionRelation).%New()
				s objUserTemSecRelation.TemplateID =TemplateID
				s objUserTemSecRelation.Code =userTemCode
				s objUserTemSecRelation.Name =userTemName
				s objUserTemSecRelation.SectionCode =strSecCode
				s objUserTemSecRelation.SectionName =strSecName
				s objUserTemSecRelation.Status =strStatus
				s sc = objUserTemSecRelation.%Save()
				s totCount= totCount+1		
			}
		}
		
	}
	w "Summary: "_totCount
	q
}

/// 将旧的个人模板数据初始化到个人模板章节关系表中
/// creator: 
/// CreateDate: 2020-5-19
/// Input:     
/// Debug: d ##Class(EMRservice.BL.BLUserTemplateSectionRelation).MovePerSonTemplateSectionRelations()
ClassMethod MovePerSonTemplateSectionRelations()
{
	s totCount = 0
	s objMetaData = ##class(%GlobalBinaryStream).%New()
	s rowUseID = ""
	for {
		s rowUseID = $o(^DHCEMRM.ExampleInstanceD(rowUseID))
		q:(rowUseID="")

		s objPersonTem = ##Class(EMRmeta.ExampleInstance).%OpenId(rowUseID)
		continue:((objPersonTem="")||(objPersonTem.Status '="1"))
		
		s personTemID = rowUseID
		s personTemName = objPersonTem.Name
		s TemplateID = objPersonTem.TemplateID
		s objTemplate = ##class(EMRmeta.Template).%OpenId(TemplateID)
		continue:(objTemplate="")
		
		s AVersionNum = objTemplate.PublishVersion
		s sMetaData = ##class(EMRservice.BL.BLTemplateVersion).GetMetaData(TemplateID,AVersionNum)
		d objMetaData.CopyFrom(sMetaData)
		s strSections = ##class(EMRservice.BL.BLUserTemplateSectionRelation).GetDocumentContent(objMetaData)
		s intSecNum = $l(strSections,"^")
		For i=1:1:intSecNum
	 	{
			s strSectionItem = $p(strSections,"^",i)
			s strSecCode = $p(strSectionItem,"#",1)
			s strSecName = $p(strSectionItem,"#",2)
			s rowRelationID = $o(^DHCEMRM.ExampleInsSecRelationI("IdxTemplateExampleIDSection"," "_TemplateID," "_personTemID," "_$zcvt(strSecCode,"U"),""))
			if (rowRelationID="")
			{
				s rowSecID = ""
				s rowSecID = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",personTemID," "_$zcvt(strSecCode,"U"),rowSecID))
				s strStatus = "REFERENCE" 
				if (rowSecID'="")
				{
					s objPersonTemSection = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowSecID)
					s status = objPersonTemSection.Status
					s:(status = "1") strStatus= "REPLACE"
				}
				s objPersonTemSecRelation = ##Class(EMRmeta.ExampleInsSecRelation).%New()
				s objPersonTemSecRelation.ExampleID = personTemID
				s objPersonTemSecRelation.Name = personTemName
				s objPersonTemSecRelation.SectionCode = strSecCode
				s objPersonTemSecRelation.SectionName = strSecName
				s objPersonTemSecRelation.Status = strStatus
				s objPersonTemSecRelation.TemplateID = TemplateID
				s sc = objPersonTemSecRelation.%Save()
				s totCount= totCount+1	
			}
		}
		
	}
	w "Summary: "_totCount
	q
}

/// 输出格式：S001#患者基本信息^S002#主诉^S003#现病史^S004#既往史^S005#个人史^S007#婚姻史^S008#月经史
ClassMethod GetDocumentContent(argStream As %GlobalBinaryStream) As %String
{
	s strSections = ""
	q:(argStream.Size <= 0) strSections
	s sc =##class(%XML.XPATH.Document).CreateFromStream(argStream,.scatterData)
	q:($$$ERROR(sc)) strSections
	s sc = scatterData.EvaluateExpression("/MetaData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) strSections
	s count = sections.GetAt(1).Value
	s footer = ""
	for i=1:1:count
	{
		set sc=scatterData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Code","@Code",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))		
		s sectionCode = result.GetAt(1).Value	
		continue:((sectionCode="Header")||(sectionCode="Footer"))
		s sc = scatterData.EvaluateExpression("/MetaData/Component/Section["_i_"]/Code","@DisplayName",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s sectionName = result.GetAt(1).Value
		if ((sectionName[":")||(sectionName["："))
		{
			s sectionName = $tr(sectionName,":","")
			s sectionName = $tr(sectionName,"：","")
		}
		
		s strSection = sectionCode_"#"_sectionName
		
		s strSections =$case(strSections,"":strSection,:strSections_"^"_strSection)
	}

	q strSections
}

}
