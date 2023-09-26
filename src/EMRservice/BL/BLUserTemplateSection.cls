/// 名称：		EMRservice.BL.BLUserTemplateKBConfig
/// 描述：		知识关联用户模板BL层
/// 编写者：	yejian
/// 编写时间：	2016-8-2
Class EMRservice.BL.BLUserTemplateSection Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:		取章节结点
/// Creator:    yejian
/// CreateTime: 2017-11-10
/// Input:		AUserTemplateCode: 用户模板ID
///             ATitleCode: 标题代码
/// OutPut:     Node xml流数据
ClassMethod GetBindSection(AUserTemplateCode As %String, ATitleCode As %String, ByRef OutStream As %GlobalBinaryStream) As %String
{
	s result = ""
	q:(AUserTemplateCode = "") result
	q:((ATitleCode '= "")&&($d(^DHCEMRM.UserTemplateTitleI("IdxCodeAndTitleCode"," "_$zcvt(AUserTemplateCode,"U")," "_$zcvt(ATitleCode,"U")))<=0)) result
	s result = 1
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.UserTemplateSectionI("IdxCode"," "_$zcvt(AUserTemplateCode,"U"),rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.UserTemplateSection).%OpenId(rowId)
		q:(obj = "")
		s setionCode = obj.SectionCode
		//是否替换章节数据，先判断是否维护章节继承关系，如果没有走旧方式，否则根据继承关系判断
		s existRowId = $o(^DHCEMRM.UserTemplateRelationI("IdxCode"," "_$zcvt(AUserTemplateCode,"U"),""))
		if (existRowId="")
		{
			continue:(obj.ActiveFlag=0)
		}
		else
		{
			s relationRowId = $o(^DHCEMRM.UserTemplateRelationI("IdxStatusSection"," "_$zcvt(AUserTemplateCode,"U")," REPLACE"," "_setionCode,""))
			continue:(relationRowId="")
		}
		s tmpStream = ##Class(%GlobalBinaryStream).%New()
		s status = ..GetNodeXML(rowId,tmpStream)
		continue:(status '= 1)
		d:(OutStream.Size > 0) OutStream.Write("-----------------------------7da4a26140fde")
		d OutStream.Write("{""SectionCode"":"""_setionCode_"""}$$")
		d OutStream.CopyFrom(tmpStream)
	}
		
	
	q result
}

/// Desc:       取知识内容xml
/// Creator:    yejian
/// CreateDate: 2014-01-19
/// Input:      ANodeID 知识库ID
/// OutPut:     OutSection 知识库节点xml            
ClassMethod GetNodeXML(AID As %String, ByRef OutSection As %GlobalBinaryStream) As %String
{
	s result = "-1"
	q:(AID = "") result
	s objSection = ##Class(EMRmeta.UserTemplateSection).%OpenId(AID)
	q:(objSection = "") result
	d OutSection.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d OutSection.Write("<Template>")
	  d OutSection.Write("<Macros>")
	  d OutSection.Write("<Macro/>")
	  d OutSection.Write("</Macros>")
      d OutSection.Write("<StructuredBody>")
	    d OutSection.CopyFrom(objSection.MetaData)
	    d OutSection.CopyFrom(objSection.ScriptData)
	    d OutSection.CopyFrom(objSection.MediasData)
	    d OutSection.CopyFrom(objSection.InitialData)
	    d OutSection.CopyFrom(objSection.PresentationData)
	    d OutSection.Write("</StructuredBody>")
	d OutSection.Write("</Template>") 
	q 1
}

/// 根据科室ID获取用户模板
/// /////////用户模板科室////////////
/// Debug:	d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLUserTemplateSection","GetSectionSByUserTempCode","1")
Query GetSectionSByUserTempCode(aCode As %String) As %Query(ROWSPEC = "ID:%Integer,Code:%String,SectionCode:%String,KbBaseID:%String,ActiveFlag:%String")
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
		s rowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCode"," "_$zcvt(aCode,"U"),rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSection).%OpenId(rowID)
		continue:(objUserTemSec = "")
	
		s Code = objUserTemSec.Code
		s SectionCode = objUserTemSec.SectionCode
		s KbBaseID = objUserTemSec.KbBaseID
		s ActiveFlag = objUserTemSec.ActiveFlag
	
		s Data = $lb(rowID,Code,SectionCode,KbBaseID,ActiveFlag)
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

/// 添加用户模板科室
ClassMethod AddUserTemplateSection(AUserTemplateKB As EMRservice.entity.EUserTemplateSection) As %String
{
	s ret = 1

	s objUserTemSection = ##Class(EMRmeta.UserTemplateSection).%New()
	s objUserTemSection.Code =AUserTemplateKB.Code
	s objUserTemSection.SectionCode =AUserTemplateKB.SectionCode
	s objUserTemSection.KbBaseID =AUserTemplateKB.KbBaseID
	s objUserTemSection.ActiveFlag =AUserTemplateKB.ActiveFlag
	if (objUserTemSection.%Save())
	{
	    s ret=objUserTemSection.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objUserTemSection.%Close()
	q ret
}

/// 修改用户模板科室
ClassMethod ModUserTemplateSection(AUserTemplateKB As EMRservice.entity.EUserTemplateSection) As %String
{
	s ret = 1

	s objUserTemSection = ##Class(EMRmeta.UserTemplateSection).%OpenId(AUserTemplateKB.ID)
	;s objUserTemSection.Code =AUserTemplateKB.Code
	;s objUserTemSection.SectionCode =AUserTemplateKB.SectionCode
	s objUserTemSection.KbBaseID =AUserTemplateKB.KbBaseID
	s objUserTemSection.ActiveFlag =AUserTemplateKB.ActiveFlag
	if (objUserTemSection.%Save())
	{
	    s ret=objUserTemSection.%Id()
	}
	else
	{
	   s ret=0
	}		

	d objUserTemSection.%Close()
	q ret
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String
{
	s ret = 1
	q:(RowID="") ret
	//原有数据进行“删除”,将数据ActiveFlag设置为0
	s obj = ##class(EMRmeta.UserTemplateSection).%OpenId(RowID)
	s obj.ActiveFlag = 0
	
	if '(obj.%Save())
	{
		s ret = 0	
	}
	d obj.%Close()
	
	q ret
}

/// 删除章节模板数据
/// Debug: d ##Class(EMRservice.BL.BLUserTemplateSection).SetUserTemSecStatus("25","^S002^S003^S004^S006^S007^S008^")
ClassMethod DelUserTemSecStatus(strUserTemCode As %String, SectionCodeList As %String) As %String
{
	s ret = "1"
	q:((SectionCodeList = "")||(strUserTemCode = "")) ret
	s SectionCode = ""
	s rowID = ""
	for {
		s SectionCode = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(strUserTemCode,"U"),SectionCode))
		q:(SectionCode = "")
		s rowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(strUserTemCode,"U"),SectionCode,rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSection).%OpenId(rowID)
		q:(objUserTemSec = "")
		s curSectionCode = "^"_SectionCode_"^"
		s curSectionCode = $tr(curSectionCode," ")
		
		//纯文本或者不包含在章节编码字符集中
		if ((SectionCodeList [ curSectionCode))
		{
			s objUserTemSec.ActiveFlag = "0"
			if ('objUserTemSec.%Save())
			{
				s ret = "-1"	
			}
		}

	}
	q ret
}

/// 把不包含在SectionCodeList章节节点和关系设为不可用
/// Debug: d ##Class(EMRservice.BL.BLUserTemplateSection).SetUserTemSecStatus("25","^S002^S003^S004^S006^S007^S008^")
ClassMethod SetUserTemSecStatus(strUserTemID As %String, SectionCodeList As %String) As %String
{
	s ret = "1"
	q:((SectionCodeList = "")||(strUserTemID = "")) ret
	s objUserTemplate = ##Class(EMRmeta.UserTemplate).%OpenId(strUserTemID)
	q:(objUserTemplate = "") "-1"
	s SectionCode = ""
	s rowID = ""
	for {
		s SectionCode = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(objUserTemplate.Code,"U"),SectionCode))
		q:(SectionCode = "")
		s rowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(objUserTemplate.Code,"U"),SectionCode,rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSection).%OpenId(rowID)
		q:(objUserTemSec = "")
		s curSectionCode = "^"_SectionCode_"^"
		s curSectionCode = $tr(curSectionCode," ")
		
		//纯文本或者不包含在章节编码字符集中
		if ((SectionCode ="")||'(SectionCodeList [ curSectionCode))
		{
			s objUserTemSec.ActiveFlag = "0"
			if ('objUserTemSec.%Save())
			{
				s ret = "-1"	
			}
		}

	}
	q ret
}

/// Desc:       保存章节用户模板数据
/// Creator:    yejian
/// Createdate: 2017-11-18
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
/// w ##Class(EMRservice.BL.BLUserTemplateSection).SaveUserComposite()
ClassMethod SaveUserSection(argInData As %GlobalBinaryStream, UserTemplateID As %String, SectionCode As %String, BindKBBaseID As %String) As %String
{
	TStart
	s res = "-1"		
    q:((argInData = "")||(UserTemplateID = "")||(SectionCode = "")) result 
        
    s objUserTem = ##Class(EMRmeta.UserTemplate).%OpenId(UserTemplateID)
    q:(objUserTem="") res
    s Code = objUserTem.Code

    s rowSecID = ""
   
    s rowSecID = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(Code,"U")," "_$zcvt(SectionCode,"U"),rowSecID)) 
	if (rowSecID ="")
	{
		s objUserTemSection = ##Class(EMRmeta.UserTemplateSection).%New()
		s objUserTemSection.Code =Code
		s objUserTemSection.SectionCode =SectionCode
		s objUserTemSection.KbBaseID =BindKBBaseID
		s objUserTemSection.ActiveFlag ="1"
		if ('objUserTemSection.%Save())
		{
			TRollback
		   	s res="-1"
		}
		s rowSecID = objUserTemSection.%Id()
	}
	if (rowSecID'="")
	{
    	s res = ..SaveSection(argInData,rowSecID)
    	if (res'="-1")
    	{
	    	TCommit
    	}
	}
    q res
}

/// Desc:       保存知识库模板数据
/// Creator:    candy
/// Createdate: 2014-01-25
/// Input:      argInData 模板文件流
///             TemplateVersionId   
/// Output:     result 1成功,-1失败 
ClassMethod SaveSection(argInData As %GlobalBinaryStream, SectionID As %String) As %String
{
	s result = "-1"		
    q:((SectionID = "")||(argInData = "")) result 
        
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<MetaData","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Scripts>","</Scripts>","10")
    s streamPresentationData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<PresentationData>","</PresentationData>","19")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Medias>","</Medias>","9")
    s streamInitialData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<InitialData>","</InitialData>","14")

    
    s objSection = ##Class(EMRmeta.UserTemplateSection).%OpenId(SectionID)
    q:(objSection = "") result
    
    d objSection.MetaData.CopyFrom(streamMetaData)
    d objSection.ScriptData.CopyFrom(streamScriptData)
    d objSection.PresentationData.CopyFrom(streamPresentationData)
    d objSection.MediasData.CopyFrom(streamMediasData)
    d objSection.InitialData.CopyFrom(streamInitialData)
    s sc = objSection.%Save()

	s:($$$ISOK(sc)) result = "1"
	q result
}

/// 章节第一次处理时，把不包含在CompositeCodeList章节节点和关系设为不可用
/// Debug: s ret = ##Class(EMRservice.BL.BLUserTemplateKBConfig).SetUserTemplateSection(1)
ClassMethod SetUserTemplateSection(AUserTemID As %String, Code As %String, SectionCode As %String, CompositeCodeList As %String, aKey As %String) As %String
{
	s ret = ""
	q:((CompositeCodeList = "")||(Code = "")||(aKey ="")) ret
	s strSecs = $g(^CacheTempEMRUserTemSec(aKey,AUserTemID))
	q:(strSecs = SectionCode) ret
	s ^CacheTempEMRUserTemSec(aKey,AUserTemID) = SectionCode
	
	s CompositeCodeList= "^"_CompositeCodeList_"^"
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection"," "_$zcvt(Code,"U")," "_$zcvt(SectionCode,"U"),rowID))
		q:(rowID = "")
		s objUserTemSec = ##Class(EMRmeta.UserTemplateSection).%OpenId(rowID)
		continue:(objUserTemSec = "")
		
		s Code = objUserTemSec.Code
		s CompositeCode = objUserTemSec.CompositeCode
		s SectionID =objUserTemSec.SectionID
		s curComCode = "^"_CompositeCode_"^"
		//纯文本或者不包含在章节编码字符集中
		if ((CompositeCode ="")||'(CompositeCodeList [ curComCode))
		{
			d ##Class(EMRservice.BL.BLSection).StopOrStartSection(SectionID,"N")
			s objUserTemSec.ActiveFlag = "0"
			s objUserTemSec.Sequence = 0
			d objUserTemSec.%Save()
		}
		else //把排序设置为0
		{
			s objUserTemSec.Sequence = 0
			d objUserTemSec.%Save()
		}
	}
	q ret
}

/// 清理临时global
ClassMethod ClearUserTemSecGlobal(aUserTemID As %String, aUserTKey As %String)
{
	k ^CacheTempEMRUserTemSec(aUserTKey,aUserTemID)
}

/// Desc:       模板发布批量更新科室模板章节关系信息
/// Creator:    yejian
/// Createdate: 2019-2-19
/// Input:      aTemplateID 模板ID
///             aSectionKBs 章节知识信息（sectionCode^kbbaseid或""|sectionCode^kbbaseid或""...）
/// Output:     result 1成功,0失败 
/// debug: w ##Class(EMRservice.BL.BLUserTemplateSection).UpdateUserTSectionByTemID(1,"S005^79|S003^80|S007^83")
ClassMethod UpdateUserTSectionByTemID(aTemplateID As %String, aSectionKBs As %String) As %String
{
	
	q:((aTemplateID="")||(aSectionKBs="")|| (aTemplateID = $c(0))|| (aSectionKBs = $c(0))) "0"
	//s ^UpdateUserTSectionByTemID("123") =aTemplateID_","_aSectionKBs
	s strMrk = 1 
	s intSectionCount = $l(aSectionKBs, "|")
	TSTART
	s aSectionKBs= "|"_aSectionKBs
	//根据模板章节信息更新科室模板章节信息
	if (intSectionCount > 0)
	{
		s UTemCode = ""
		for {
			s UTemCode = $o(^DHCEMRM.UserTemplateI("IdxTemplateCode"," "_aTemplateID,UTemCode))
			q:(UTemCode="")
			s strTemCode = $tr(UTemCode," ")
			s objUseT = ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByCode(strTemCode)
			//如果科室模板已经删除则跳过
			continue:((objUseT="")||(objUseT.Status ="-1"))
			s strSectionCode = ""
			for {
				s strSectionCode = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection",UTemCode,strSectionCode))
				q:(strSectionCode="")
				s rowID = ""
				for {
					s rowID = $o(^DHCEMRM.UserTemplateSectionI("IdxCodeSection",UTemCode,strSectionCode,rowID))
					q:(rowID="")
					s objUserSec = ##class(EMRmeta.UserTemplateSection).%OpenId(rowID)
					q:(objUserSec="")
					//如果章节关了知识库则启用模板章节，并修改对应kbbaseID,否则停用该科室章节
					s strCurSection = "|"_$tr(strSectionCode," ","")_"^"
					if (aSectionKBs [ strCurSection)
					{
						s objUserSec.ActiveFlag = "1"
						s strKBbaseID = $p($p(aSectionKBs,strCurSection,2),"|",1)
						s objUserSec.KbBaseID = strKBbaseID
					}
					else
					{
						s objUserSec.ActiveFlag = "0"
					}
					s sc = objUserSec.%Save()
					if ('sc)
					{
						s strMrk = 0
					}
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

// w ##Class(EMRservice.BL.BLUserTemplateSection).UpdateUserTSectionFlag()

ClassMethod UpdateUserTSectionFlag() As %String
{
	//迁移病种知识库规则
	s totQCount = 0
	s rowID = ""
	for {
		s rowID = $o(^DHCEMRM.UserTemplateSectionD(rowID))
		q:(rowID="")
		s objUserSec = ##class(EMRmeta.UserTemplateSection).%OpenId(rowID)
		q:(objUserSec="")
		continue:((objUserSec.ActiveFlag'="")&&(objUserSec.ActiveFlag="1"))
		s objUserSec.ActiveFlag = "1"
		
		s sc = objUserSec.%Save()
		if (sc)
		{
			s totQCount = totQCount+1
		}
	}
	q "修改数据: "_totQCount_"  "
}

}
