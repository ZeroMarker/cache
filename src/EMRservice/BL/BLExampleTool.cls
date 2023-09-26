/// Desc:       范例病历迁移工具类
/// Creator:    yejian
/// CreateDate: 2018-8-6
Class EMRservice.BL.BLExampleTool Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取所有范例病历数据
/// Creator:    yejian
/// CreateDate: 2018-8-6	
/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLExampleTool","GetModelInstanceIDs")
Query GetModelInstanceIDs() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,CategoryID:%String,FPinyin:%String,Sequence:%String,TemplateID:%String,ChartItemID:%String,DocumentType:%String,ChartItemType:%String,CreateUser:%String,Status:%String,TemplateVersion:%String,ModelInsCategoryID:%String")
{
	SELECT ID,Name,CategoryID,FPinyin,Sequence,TemplateID,ChartItemID,DocumentType,ChartItemType,CreateUser,Status,TemplateVersion,ModelInsCategoryID
	FROM EMRmeta.ModelInstanceData where ID > (SELECT max(convert(int,InstanceID)) FROM EMRmeta.ExampleInstance)
}

/// Desc:       添加范例项
/// Creator:    yejian
/// CreateDate: 2018-4-10
/// Input:      argUserID 用户ID
///             argParentID 父目录ID
/// Output:     成功返回ID ,失败返回空
ClassMethod AddInstanceData(argCategoryID, argName, argInstanceID, argUserID As %String) As %String
{
	s result = ""
	q:(argCategoryID = "")||(argUserID = "")||(argInstanceID = "")||(argName = "") result
	
	s objInstance = ##Class(EMRmeta.ModelInstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s obj = ##Class(EMRmeta.ExampleInstance).%New()
	
	if (argCategoryID'="0")
	{
		s ProwID = $o(^DHCEMRM.ExamInsCategoryI("indSeqence",argCategoryID,""))
		s obj.CategoryID = ProwID
	}
	else
	{
		s obj.CategoryID = "0"
	}
	//s obj.CategoryID = "0"
	s obj.InstanceID = argInstanceID
	s obj.ChartItemType = objInstance.ChartItemType
	s obj.DocumentCharacteristic = "0"
	s obj.DocumentType = objInstance.DocumentType
	s obj.EMRCategoryID = objInstance.CategoryID
	s obj.EMRDocID = objInstance.ChartItemID
	s obj.Name = argName
	s obj.JianpinName = ##class(web.DHCINSUPort).GetCNCODE($tr(argName," ",""),4,"")
	s obj.Seqence =objInstance.Sequence //$case($d(^DHCEMRM.ExampleInstanceD),0:1,:^DHCEMRM.ExampleInstanceD+1)
	s obj.TemplateID = objInstance.TemplateID
	s obj.UserID = argUserID
    s obj.CreateDate = $P($H,",",1)
	s obj.CreateTime = $P($H,",",2)
	s obj.Status = 1
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

/// Desc:       保存范例病历章节内容
/// Creator:    yejian
/// CreateDate: 2018-4-10
/// Input:      argExampleID 范例ID
///             argSectionCode 章节代码
///             argSectionName 章节名称
///             argName 目录名称
/// Output:     成功返回ID ,失败返回空
ClassMethod InsertInstanceData(argExampleID As %String, argSectionCode As %String, argSectionName As %String, argInData As %GlobalBinaryStream, argInstanceID As %String) As %String
{
	s result = ""		
    q:(argExampleID = "")||(argInData = "") result 
        
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<MetaData>","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Scripts>","</Scripts>","10")
    s streamPresentationData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<PresentationData>","</PresentationData>","19")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Medias>","</Medias>","9")
    s streamInitialData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<InitialData>","</InitialData>","14")

    s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",argExampleID," "_$zcvt(argSectionCode,"u"),""))
    if (rowId = "")
    {
	    s obj = ##Class(EMRmeta.ExampleInstanceSection).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
	}
	q:(obj = "") result  
	s obj.ExampleID = argExampleID
	s obj.SectionCode = argSectionCode
	s obj.SectionName = argSectionName
	s obj.Status = 1  
    d obj.MetaData.CopyFrom(streamMetaData)
    d obj.ScriptData.CopyFrom(streamScriptData)
    d obj.PresentationData.CopyFrom(streamPresentationData)
    d obj.MediasData.CopyFrom(streamMediasData)
    d obj.InitialData.CopyFrom(streamInitialData)
	//s sectionRowId = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_argInstanceID," "_$zcvt(argSectionCode,"U"),""))
	//q:(sectionRowId = "") result
	//s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(sectionRowId)
	//q:(objSection = "") result   
    //d obj.Text.CopyFrom(objSection.Text)
    s sc = obj.%Save()
	s:($$$ISOK(sc)) result = "1"
	
	q result
}

/// Desc:       迁移旧范例病历目录
/// Creator:    yejian
/// CreateDate: 2018-8-6	
/// d ##Class(EMRservice.BL.BLExampleTool).MoveModleCategory()
ClassMethod MoveModleCategory() As %String
{
	s rest = ""
	s aKBRuleCount =""
	s modRowID = ""
	for {
		s modRowID = $o(^DHCEMRM.ModelInsCategoryD(modRowID))
		q:(modRowID="")
		s objModCategory = ##Class(EMRmeta.ModelInsCategory).%OpenId(modRowID)
		S strUserID = objModCategory.CreateUser
		S strParID = objModCategory.ParentID
		S strSeq = objModCategory.Sequence
		s examRowID = $o(^DHCEMRM.ExamInsCategoryI("UserParentSeqence"," "_strUserID,strParID,strSeq,""))
		if (examRowID="")
		{
			s objExamCategory=##class(EMRmeta.ExampleInstanceCategory).%New()

			s objExamCategory.Name=objModCategory.Name
			if (objModCategory.ParentID'="0")
			{
				s ProwID = $o(^DHCEMRM.ExamInsCategoryI("indSeqence",objModCategory.ParentID,""))
				s objExamCategory.ParentID=ProwID
			}
			else
			{
				s objExamCategory.ParentID=objModCategory.ParentID
			}
			s objExamCategory.JianpinName=objModCategory.FPinyin
			s objExamCategory.Seqence=objModCategory.Sequence
			s objExamCategory.UserID=objModCategory.CreateUser
			s objExamCategory.Status="1"
			s objExamCategory.CreateDate= $ZDATEH($ZDATE($HOROLOG))
			s objExamCategory.CreateTime= $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))

			s sc = objExamCategory.%Save()	
			s aKBRuleCount = aKBRuleCount+1	
		}
	}
	q "成功迁移了范例目录数："_aKBRuleCount
}

}
