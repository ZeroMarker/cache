/// Desc:       范例病历业务类
/// Creator:    Candy
/// CreateDate: 2018-4-4
Class EMRservice.BL.BLExampleInstance Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       范例病例目录树
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
/// Output:     目录流数据
ClassMethod GetDataTree(argUserID As %String, argInstanceID As %String, argUserLocID As %String = "") As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argUserID = "") result
	s templateId = ""
	if (argInstanceID '= "")
	{
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
		s:(objInstance '= "") templateId = objInstance.RealTemplateID
	}
	s objUser = ##class(User.SSUser).%OpenId(argUserID)
	s userName = objUser.SSUSRName
	s text = userName_"的范例病历"
	
	d result.Write("[")
	d result.Write("{")
	d result.Write("""id"":""0""")
	d result.Write(",""text"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(text)_"""")
	d result.Write(",""iconCls"":""user-folder-open""")
	d result.Write(",""attributes"":{""type"":""root""}")
	d result.Write(",""children"":[")
	s cateData = ..GetCategoryData(argUserID,0,templateId)
	d:(cateData.Size >0) result.CopyFrom(cateData)
	s examples = ..GetExampleData(argUserID,0,templateId)
	d:(cateData.Size >0)&&(examples.Size >0) result.Write(",")
	d:(examples.Size >0) result.CopyFrom(examples)
	s shareExamples = ..GetShareData(argUserLocID,templateId)
	d:((cateData.Size >0)||(examples.Size >0))&&(shareExamples.Size >0) result.Write(",")
	d:(shareExamples.Size >0) result.CopyFrom(shareExamples)
	d result.Write("]}")
	d result.Write("]")
	q result
}

/// Desc:       取目录分类数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
///             argParentID 父节点
/// Output:     目录流数据
/// Debug:      s aa = ##Class(EMRservice.BL.BLExampleInstance).GetCategoryData(4133,0)
ClassMethod GetCategoryData(argUserID As %String, argParentID As %String, argTemplateID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New() 
	s seq = ""
	s isShare = "0"
	for
	{
		s seq = $o(^DHCEMRM.ExamInsCategoryI("UserParentSeqence"," "_argUserID,argParentID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.ExamInsCategoryI("UserParentSeqence"," "_argUserID,argParentID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(rowId)
			continue:(obj = "")
			d:(result.Size > 0) result.Write(",")
			d result.Write("{")	
			d result.Write("""id"":"""_rowId_"""")
			d result.Write(",""text"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.Name)_"""")
			d result.Write(",""iconCls"":""user-folder-open""")
			d result.Write(",""attributes"":{""type"":""category""")
			d result.Write(",""parentID"":"""_argParentID_"""")
			d result.Write(",""isShare"":"""_isShare_"""")
			d result.Write(",""py"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.JianpinName)_"""}")
			d result.Write(",""children"":[")
			s child = ..GetCategoryData(argUserID,rowId,argTemplateID)
			d:(child.Size >0) result.CopyFrom(child)
			s examples = ..GetExampleData(argUserID,rowId,argTemplateID)
			d:(child.Size >0)&&(examples.Size >0) result.Write(",")
			d:(examples.Size >0) result.CopyFrom(examples)
			d result.Write("]")	
			d result.Write("}")	
		}
	}
	q result
}

/// Desc:       取范例数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argCategoryID 分类ID
/// Output:     目录流数据
ClassMethod GetExampleData(argUserID As %String, argCategoryID As %String, argTemplateID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argCategoryID = "")
	s isShare = "0"
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID,seq))
		q:(seq = "")
		s rowId = ""
		for
		{
			s rowId = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",argCategoryID,seq,rowId))
			q:(rowId = "")
			s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(rowId)
			continue:(obj = "")
			continue:((argTemplateID '= "")&&(obj.TemplateID '= argTemplateID))
			continue:(obj.UserID '= argUserID)
			d:(result.Size > 0) result.Write(",")
			d result.Write("{")
			d result.Write("""id"":"""_rowId_"""")
			d result.Write(",""text"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.Name)_"""")
			//d result.Write(",""iconCls"":""new-category""")
			d result.Write(",""attributes"":{""type"":""node""")
			d result.Write(",""templateId"":"""_obj.TemplateID_"""")
			d result.Write(",""emrdocId"":"""_obj.EMRDocID_"""")
			d result.Write(",""emrcategoryId"":"""_obj.EMRCategoryID_"""")
			d result.Write(",""documentType"":"""_obj.DocumentType_"""")
			d result.Write(",""chartItemType"":"""_obj.ChartItemType_"""")
			d result.Write(",""docCharacteristic"":"""_obj.DocumentCharacteristic_"""")
			d result.Write(",""isShare"":"""_isShare_"""")
			d result.Write(",""py"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.JianpinName)_"""}")
			d result.Write("}")
		}
	}
	q result
}

/// Desc:       范例章节数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argExampleID 范例ID
/// Output:     章节tree数据流
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).GetSectionData(1)
ClassMethod GetSectionData(argExampleID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argExampleID = "") result
	d result.Write("[")
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleID",argExampleID,rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
		continue:(obj = "")
		d:(result.Size > 1) result.Write(",")
		d result.Write("{")
		d result.Write("""id"":"""_rowId_"""")
		d result.Write(",""text"":"""_obj.SectionName_"""")	
		d result.Write(",""attributes"":{""type"":""section""")
		d result.Write(",""sectionCode"":"""_obj.SectionCode_"""")
		d result.Write("}")
		d result.Write("}")	
	}
	d result.Write("]")
	q result
}

/// Desc:       范例章节文本信息
/// Creator:    Candy
/// CreateDate: 2018-5-21
/// Input:      argExampleID 范例ID
///             argSectionCode 章节代码
/// Output:     章节文本数据流
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).GetSectionText(1,"S0001")
ClassMethod GetSectionText(argExampleID As %String, argSectionCode As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argExampleID = "")||(argSectionCode = "") result
	s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",argExampleID," "_$zcvt(argSectionCode,"U"),""))
	q:(rowId = "") result
	s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
	q:(obj = "") result
	d result.CopyFrom(obj.Text)
	q result
}

/// Desc:       添加范例目录
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
///             argParentID 父目录ID
///             argName 目录名称
/// Output:     成功返回ID ,失败返回空 
/// Debug:      w ##Ckass(EMRservice.BL.BLExampleInstance).AddCategory(4133,0,"范例病历1")
ClassMethod AddCategory(argUserID As %String, argParentID As %String, argName As %String) As %String
{
	s result = ""
	q:(argUserID = "")||(argParentID = "")||(argName = "") result
	s obj = ##Class(EMRmeta.ExampleInstanceCategory).%New()
	s obj.Name = argName
	s obj.JianpinName = ##class(web.DHCINSUPort).GetCNCODE($tr(argName," ",""),4,"")
	s obj.ParentID = argParentID
	s obj.UserID = argUserID
	s obj.Seqence = $case($d(^DHCEMRM.ExamInsCategoryD),0:1,:^DHCEMRM.ExamInsCategoryD+1)
	s obj.Status = 1
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

/// Desc:       修改名称
/// Creator:    Candy
/// CreateDate: 2018-4-19
/// Input:      argRowID rowId
///             argName  修改名称
///             argAction 修改类型
/// Output:     成功返回1 ,失败返回空
ClassMethod ReName(argRowID As %String, argName As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argName = "")||(argAction = "") result
	if (argAction = "category")
	{
		s obj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID)
		q:(obj = "")
		s obj.Name = argName
		s obj.JianpinName = ##class(web.DHCINSUPort).GetCNCODE($tr(argName," ",""),4,"")
	}
	else
	{
		s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(argRowID)
		q:(obj = "")
		s obj.Name = argName
		s obj.JianpinName = ##class(web.DHCINSUPort).GetCNCODE($tr(argName," ",""),4,"")
	}
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.JianpinName
	q result
}

/// Desc:       删除数据
/// Creator:    Candy
/// CreateDate: 2018-4-19
/// Input:      argRowID rowId
///             argAction 修改类型
/// Output:     成功返回1 ,失败返回空
ClassMethod DeleteData(argRowID As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argAction = "") result
	if (argAction = "category")
	{
		//删除个人模板目录
		s sc = ##Class(EMRmeta.ExampleInstanceCategory).%DeleteId(argRowID)
		s:($$$ISOK(sc)) result = 1
		q result
	}
	else
	{
		s flag = 1
		TStart
		//删除个人模板节点主表
		s sc = ##Class(EMRmeta.ExampleInstance).%DeleteId(argRowID)
		if ($$$ISOK(sc))
		{
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleID",argRowID,rowId))
				q:(rowId = "")
				//删除个人模板章节表
				s sesc =  ##Class(EMRmeta.ExampleInstanceSection).%DeleteId(rowId)
				s:($$$ISERR(sesc)) flag = 0
				q:(flag = 0)
			}
		}
		if (flag = 0)
		{
			Trollback
			q result
		}
		else
		{
			s rowId = ""
			for
			{
				s rowId = $o(^DHCEMRM.ExampleInsSecRelationI("IdxExampleID"," "_argRowID,rowId))
				q:(rowId = "")
				//删除个人模板章节关系对照表
				s sesc =  ##Class(EMRmeta.ExampleInsSecRelation).%DeleteId(rowId)
				s:($$$ISERR(sesc)) flag = 0
				q:(flag = 0)
			}
			if (flag = 0)
			{
				Trollback
				q result
			}
			s result = 1
		}
		Tcommit:(result = 1)
	}
	q result
}

/// Desc:       排序交换节点
/// Creator:    Candy
/// CreateDate: 2018-4-19
/// Input:      argRowID1 rowId1
///             argRowID2 rowId2
///             argAction 修改类型
/// Output:     成功返回1 ,失败返回空
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).SwapSequence(1,2,"category")
ClassMethod SwapSequence(argRowID1 As %String, argRowID2 As %String, argAction As %String) As %String
{
	s result = ""
	q:(argRowID1 = "")||(argRowID2 = "") result
 	if (argAction = "category") 
 	{
		s obj1 = ##class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID1)
		s obj2 = ##class(EMRmeta.ExampleInstanceCategory).%OpenId(argRowID2)		
	}
	else 
 	{
		s obj1 = ##class(EMRmeta.ExampleInstance).%OpenId(argRowID1)
		s obj2 = ##class(EMRmeta.ExampleInstance).%OpenId(argRowID2)	 	
	}
	q:((obj1 = "")||(obj2 = "")) result
	 
	s tempSequence = obj1.Seqence
	s obj1.Seqence = obj2.Seqence
	s obj2.Seqence = tempSequence
	
	s $zt = "SwapErrorHandler"
	Tstart
	s scResult = obj1.%Save()
	if $$$ISERR(scResult)
	{
		Trollback
		q result
	}
	s scResultSele = obj2.%Save() 
	if $$$ISERR(scResultSele)
	{
		Trollback
		q result
	}
	
	TCOMMIT
			    
	do obj1.%Close()
	do obj2.%Close()
	
	s result = 1
	q result
	

SwapErrorHandler
	Trollback
	q $zerror
}

/// Desc:       添加范例项
/// Creator:    Candy
/// CreateDate: 2018-4-10
/// Input:      argUserID 用户ID
///             argParentID 父目录ID
/// Output:     成功返回ID ,失败返回空
ClassMethod AddInstanceData(argCategoryID, argName, argInstanceID, argUserID As %String) As %String
{
	s result = ""
	q:(argCategoryID = "")||(argUserID = "")||(argInstanceID = "")||(argName = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") result
	s obj = ##Class(EMRmeta.ExampleInstance).%New()
	s obj.CategoryID = argCategoryID
	s obj.InstanceID = argInstanceID
	s obj.ChartItemType = objInstance.TheECRecord.ChartItemType
	s obj.DocumentCharacteristic = objInstance.TheECRecord.DocumentCharacteristic
	s obj.DocumentType = objInstance.TheECRecord.DocumentType
	s obj.EMRCategoryID = objInstance.TheECRecord.RealCategoryID
	s obj.EMRDocID = objInstance.TheECRecord.RealChartItemID
	s obj.Name = argName
	s obj.JianpinName = ##class(web.DHCINSUPort).GetCNCODE($tr(argName," ",""),4,"")
	s obj.Seqence = $case($d(^DHCEMRM.ExampleInstanceD),0:1,:^DHCEMRM.ExampleInstanceD+1)
	s obj.TemplateID = objInstance.RealTemplateID
	s obj.UserID = argUserID
    s obj.CreateDate = $P($H,",",1)
	s obj.CreateTime = $P($H,",",2)
	s obj.Status = 1
	s obj.TitleCode = objInstance.TitleCode
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

/// Desc:       保存范例病历章节内容
/// Creator:    Candy
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
    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<ScatterData>","</ScatterData>","14")

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
    d obj.ScatterData.CopyFrom(streamScatterData)
    
    if (argInstanceID '= "")
    {
        s sectionRowId = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_argInstanceID," "_$zcvt(argSectionCode,"U"),""))
        if (sectionRowId '= "") 
        {
            s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(sectionRowId)
            d:(objSection '= "") obj.Text.CopyFrom(objSection.Text) 
        }
    }
    s sc = obj.%Save()
	s:($$$ISOK(sc)) result = "1"
	
	q result
}

/// Desc:       取范例病历,首先返回对应该模板数据
/// Creator:    Candy
/// CreateDate: 2018-4-10
/// Input:      argExampleID 范例ID
/// Output:     模板数据流
ClassMethod GetInstanceData(argEpisodeID As %String, argExampleID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s result = ""
	q:(argEpisodeID = "")||(argExampleID = "") result
	s objExample = ##Class(EMRmeta.ExampleInstance).%OpenId(argExampleID)
	q:(objExample = "") result
	s templateId = objExample.TemplateID
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(templateId)
	s version = objTemplate.PublishVersion
	d argOutData.CopyFrom(##Class(EMRservice.BL.BLInstanceData).GetNewDocByTemplateID(templateId,version))
	s InstanceId = ##Class(EMRservice.BL.BLQuotation).QuotationDocument(argEpisodeID,objExample.InstanceID,"","","")	
	s result = InstanceId
	q result
}

/// Desc:       取范例章节流数据
/// Creator:    Candy
/// CreateDate: 2018-4-10
/// Input:      argExampleID 范例ID
///             argSeciotnArray 章节列表
/// Output:     模板数据流
ClassMethod GetExampleSectionXml(argExampleID As %String, argArray As %ArrayOfDataTypes, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s result =  ""
	q:(argExampleID = "")||(argArray.Count()<=0) result

    for i=1:1:argArray.GetAt("params").GetAt("SectionList").Count()
    {
	    s code = argArray.GetAt("params").GetAt("SectionList").GetAt(i).GetAt("Code")
		s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",argExampleID," "_$zcvt(code,"U"),""))
		continue:(rowId = "")
		s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
		continue:(obj = "")
		d:(argOutData.Size >0) argOutData.Write("-----------------------------7da4a26140fde")
		d argOutData.Write("{""SectionCode"":"""_code_"""}$$")
		d argOutData.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
		d argOutData.Write("<Template>")
		d argOutData.Write("<Macros>")
		d argOutData.Write("<Macro/>")
		d argOutData.Write("</Macros>")
		d argOutData.Write("<StructuredBody>")
		d argOutData.CopyFrom(obj.MetaData)
		d argOutData.CopyFrom(obj.ScriptData)
		d argOutData.CopyFrom(obj.MediasData)
		d argOutData.CopyFrom(obj.InitialData)
		d argOutData.CopyFrom(obj.PresentationData)
        d argOutData.CopyFrom(obj.ScatterData)
		d argOutData.Write("</StructuredBody>")
		d argOutData.Write("</Template>") 
	}
	q result
}

/// Desc:       分享范例病历节点
/// Creator:    董璐璐
/// CreateDate: 2019-5-7
/// Input:      argRowID 范例ID
///             argUserID    登录用户
///             argUserLocID 登录科室
/// Output:     成功返回1 ,失败返回空，文件夹之前已分享返回-1
ClassMethod ShareNode(argRowID As %String, argUserID As %String, argUserLocID As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argUserID = "")||(argUserLocID = "") result
	
	s objExample = ##Class(EMRmeta.ExampleInstance).%OpenId(argRowID)
	q:(objExample = "") result
	s templateID = objExample.TemplateID
	q:(templateID = "") result
	
	s objExampleLocID = $o(^DHCEMRM.ExamInsLocI("IdxTemplateLocExample"," "_templateID," "_argUserLocID,argRowID,""))	
    q:(objExampleLocID '= "") -1
    s objExampleLoc = ##Class(EMRmeta.ExampleInstanceLoc).%New()
	s objExampleLoc.ExampleID = argRowID
	s objExampleLoc.CTLocID = argUserLocID 
    s objExampleLoc.UserID = argUserID
    s objExampleLoc.TemplateID = templateID
    s sc = objExampleLoc.%Save()
    s:($$$ISOK(sc)) result = "1"
    d objExampleLoc.%Close()	
	k objExampleLoc
	q result
}

/// Desc:       取共享范例数据
/// Creator:    董璐璐
/// CreateDate: 2019-5-7
/// Input:      argUserLocID 登录科室
///             argTemplateID 模板ID
/// Output:     范例流数据
/// Debug:      s a = ##Class(EMRservice.BL.BLExampleInstance).GetShareData(108,262)
ClassMethod GetShareData(argUserLocID As %String, argTemplateID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(argUserLocID = "")||(argTemplateID = "") result
	s key = $i(^TempShareExampleData)
	k ^TempShareExampleData(key)
	s isShare = "1"
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.ExamInsLocI("IdxTemplateLocExample"," "_argTemplateID," "_argUserLocID,rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(rowId)
		continue:(obj = "")
		s examInsLocID = $o(^DHCEMRM.ExamInsLocI("IdxTemplateLocExample"," "_argTemplateID," "_argUserLocID,rowId,""))
		continue:(examInsLocID = "")
		s examInsLocobj = ##Class(EMRmeta.ExampleInstanceLoc).%OpenId(examInsLocID)
		continue:(examInsLocobj = "")
		s shareUser = examInsLocobj.UserID
		//自己共享的范例不显示在共享文件夹中（注释掉的代码）
		//continue:(argUserID = examInsLocobj.UserID)
		s json = "{"
		s json = json_"""id"":"""_rowId_""""
		s json = json_",""text"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.Name)_""""
		s json = json_",""attributes"":{""type"":""node"""
		s json = json_",""templateId"":"""_obj.TemplateID_""""
		s json = json_",""emrdocId"":"""_obj.EMRDocID_""""
		s json = json_",""emrcategoryId"":"""_obj.EMRCategoryID_""""
		s json = json_",""documentType"":"""_obj.DocumentType_""""
		s json = json_",""chartItemType"":"""_obj.ChartItemType_""""
		s json = json_",""docCharacteristic"":"""_obj.DocumentCharacteristic_""""
		s json = json_",""isShare"":"""_isShare_""""
		s json = json_",""shareUser"":"""_shareUser_""""
		s json = json_",""py"":"""_##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(obj.JianpinName)_"""}"
		s json = json_"}"
		s json = $ZSTRIP(json,"*C")
		s categoryID = obj.CategoryID
		continue:(categoryID = "")
		s ^TempShareExampleData(key,"Example",categoryID,rowId) = json
		
		s cateCount = 0
		for
		{
			q:(categoryID = "0")||(categoryID = "")
			s objCategoryID = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(categoryID)
			q:(objCategoryID = "")
			
			s cateCount =  cateCount + 1
			q:(cateCount > 50)
			
			if ($d(^TempShareExampleData(key,"Category",objCategoryID.ParentID,categoryID)) = "0")
			{
				s ^TempShareExampleData(key,"Category",objCategoryID.ParentID,categoryID) = categoryID
			}
			s categoryID = objCategoryID.ParentID
		}
	}
	
	s text = "共享范例病历"
	d result.Write("{")	
	d result.Write("""id"":""0""")
	d result.Write(",""text"":""共享范例病历""")
	d result.Write(",""iconCls"":""user-folder-open""")
	d result.Write(",""attributes"":{""type"":""category""")
	d result.Write(",""isShare"":"""_isShare_"""")
	d result.Write(",""py"":""gongxiangfanlibingli""}")
	d result.Write(",""children"":[")
	s cateData = ..GetShareCategoryData(key,0)
	d:(cateData.Size >0) result.CopyFrom(cateData)
	s examples = ..GetShareExampleData(key,0)
	d:(cateData.Size >0)&&(examples.Size >0) result.Write(",")
	d:(examples.Size >0) result.CopyFrom(examples)
	d result.Write("]}")
	k ^TempShareExampleData(key)
	q result
}

/// Desc:       取目录分类数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argUserID 用户ID
///             argParentID 父节点
/// Output:     目录流数据
/// Debug:      s a = ##Class(EMRservice.BL.BLExampleInstance).GetShareCategoryData(4133,0)
ClassMethod GetShareCategoryData(key As %String, argParentID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New() 
	q:(key = "")||(argParentID = "") result
	s isShare = "1"
	s rowId = ""
	for
	{
		s rowId = $o(^TempShareExampleData(key,"Category",argParentID,rowId))
		q:(rowId = "")

		s obj = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(rowId)
		continue:(obj = "")
		d:(result.Size > 0) result.Write(",")
		d result.Write("{")	
		d result.Write("""id"":"""_rowId_"""")
		d result.Write(",""text"":"""_obj.Name_"""")
		d result.Write(",""iconCls"":""user-folder-open""")
		d result.Write(",""attributes"":{""type"":""category""")
		d result.Write(",""parentID"":"""_argParentID_"""")
		d result.Write(",""isShare"":"""_isShare_"""")
		d result.Write(",""py"":"""_obj.JianpinName_"""}")
		d result.Write(",""children"":[")
		s child = ..GetShareCategoryData(key,rowId)
		d:(child.Size >0) result.CopyFrom(child)
		s examples = ..GetShareExampleData(key,rowId)
		d:(child.Size >0)&&(examples.Size >0) result.Write(",")
		d:(examples.Size >0) result.CopyFrom(examples)
		d result.Write("]")	
		d result.Write("}")	
	}
	q result
}

/// Desc:       取范例数据
/// Creator:    Candy
/// CreateDate: 2018-4-8
/// Input:      argCategoryID 分类ID
/// Output:     目录流数据
ClassMethod GetShareExampleData(key As %String, argCategoryID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(key = "")||(argCategoryID = "") result

	s rowId = ""
	for
	{
		s rowId = $o(^TempShareExampleData(key,"Example",argCategoryID,rowId))
		q:(rowId = "")
		
		s data = ^TempShareExampleData(key,"Example",argCategoryID,rowId)
		continue:(data = "")
		
		d:(result.Size > 0) result.Write(",")
		d result.Write(data)
	}
	q result
}

/// Desc:       共享范例文件夹迁移数据
/// Creator:    董璐璐
/// CreateDate: 2019-5-7
/// Input:      
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLExampleInstance).ShareExampleCategoryMoveTo()
ClassMethod ShareExampleCategoryMoveTo()
{
	s categoryID = ""
	for
	{
		s categoryID = $o(^DHCEMRM.ExamInsCategoryLocI("IdxCategoryIDCTLocID",categoryID))
		q:(categoryID = "")
		s locID = ""
		for
		{
			s locID = $o(^DHCEMRM.ExamInsCategoryLocI("IdxCategoryIDCTLocID",categoryID,locID))
			q:(locID = "")
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEMRM.ExamInsCategoryLocI("IdxCategoryIDCTLocID",categoryID,locID,rowID))
				q:(rowID = "")
				s objCategoryLoc = ##Class(EMRmeta.ExampleInstanceCategoryLoc).%OpenId(rowID)
				s userID = objCategoryLoc.UserID

				s seq = ""
				for
				{
					s seq = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",categoryID,seq))
					q:(seq = "")
					s exampleID = $o(^DHCEMRM.ExampleInstanceI("CategorySeqence",categoryID,seq,""))
					q:(exampleID = "")
					s obj = ##Class(EMRmeta.ExampleInstance).%OpenId(exampleID)
					continue:(obj = "")
					s templateID = obj.TemplateID
		
					s objExampleLoc = ##Class(EMRmeta.ExampleInstanceLoc).%New()
					s objExampleLoc.ExampleID = exampleID
					s objExampleLoc.CTLocID = objCategoryLoc.CTLocID 
				    s objExampleLoc.UserID = userID
				    s objExampleLoc.TemplateID = templateID
				    s sc = objExampleLoc.%Save()
				    s:($$$ISOK(sc)) result = "1"
				    d objExampleLoc.%Close()	
					k objExampleLoc
				}
			}
		}
	}
}

/// Desc:       取消分享范例病历节点
/// Creator:    董璐璐
/// CreateDate: 2019-5-8
/// Input:      argRowID 范例ID
///             argUserID    登录用户
///             argUserLocID 登录科室
/// Output:     成功返回1 ,失败返回空
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).CancelShareNode(11,4133,190)
ClassMethod CancelShareNode(argRowID As %String, argUserID As %String, argUserLocID As %String) As %String
{
	s result = ""
	q:(argRowID = "")||(argUserID = "")||(argUserLocID = "") result
	
	s objExample = ##Class(EMRmeta.ExampleInstance).%OpenId(argRowID)
	q:(objExample = "") result
	s templateID = objExample.TemplateID
	q:(templateID = "") result
	
	s objExampleLocID = $o(^DHCEMRM.ExamInsLocI("IdxTemplateLocExample"," "_templateID," "_argUserLocID,argRowID,""))	
    q:(objExampleLocID = "") result
    
    s sc = ##class(EMRmeta.ExampleInstanceLoc).%DeleteId(objExampleLocID)
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       移动范例节点
/// Creator:    Lina
/// CreateDate: 2019-5-14
/// Output:     1 成功; 0 失败
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).MoveNode(1,2,0,1,10209)
ClassMethod MoveNode(parentID, nodeID, isBottom, siblingID, userID As %String) As %String
{
    s $zt="ERROR"
        
    s obj=##Class(EMRmeta.ExampleInstance).%OpenId(nodeID)
    s obj.CategoryID=parentID   
    d obj.%Save()   
    if (siblingID ="") { //append
        
    } else {
        s sibling = ##Class(EMRmeta.ExampleInstance).%OpenId(siblingID)
    
        s flag = 0 // 0:向前 1:向后
        s:((isBottom=1) && (obj.Seqence < sibling.Seqence)) flag=1
        s:((isBottom=1) && (obj.Seqence > sibling.Seqence)) flag=0    
        s:((isBottom'=1) && (obj.Seqence < sibling.Seqence)) flag=1
        s:((isBottom'=1) && (obj.Seqence > sibling.Seqence)) flag=0
        s tmpSequence = obj.Seqence
        for {
            if (flag=1) {
                s tmpSequence=$O(^DHCEMRM.ExampleInstanceI("CategorySeqence", parentID, tmpSequence))
            } else {
                s tmpSequence=$O(^DHCEMRM.ExampleInstanceI("CategorySeqence", parentID, tmpSequence),-1)
            }
            q:(tmpSequence="")
            s id=$O(^DHCEMRM.ExampleInstanceI("CategorySeqence", parentID, tmpSequence, ""))
            
            q:(flag=0)&&(isBottom=1)&&(id=siblingID)
            q:(flag=1)&&(isBottom'=1)&&(id=siblingID)
            s sibling = ##Class(EMRmeta.ExampleInstance).%OpenId(id)
            continue:(sibling = "")
            s tmpSequence = sibling.Seqence
            s sibling.Seqence = obj.Seqence
            s obj.Seqence = tmpSequence
            d obj.%Save()
            d sibling.%Save()               
            q:(id=siblingID)
        }   
    }   
    q "1"
ERROR
    q $zerror
}

/// Desc:       移动范例目录
/// Creator:    Lina
/// CreateDate: 2019-5-14
/// Output:     1 成功; 0 失败
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).MoveCategory(1,2,0,"",10209)
ClassMethod MoveCategory(parentID, cateID, isBottom, siblingID, userID As %String) As %String
{
    s $zt="ERROR"

    s cate = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(cateID)  
    q:(cate="") "0"
    s cate.ParentID = parentID
    if (siblingID '="") {   
        s sibling = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(siblingID)
    
        s flag = 0 // 0:向前 1:向后
        s:((isBottom=1) && (cate.Seqence < sibling.Seqence)) flag=1
        s:((isBottom=1) && (cate.Seqence > sibling.Seqence)) flag=0   
        s:((isBottom'=1) && (cate.Seqence < sibling.Seqence)) flag=1
        s:((isBottom'=1) && (cate.Seqence > sibling.Seqence)) flag=0
        s tmpSequence = cate.Seqence
        for {
            if (flag=1) {
                s tmpSequence=$O(^DHCEMRM.ExamInsCategoryI("UserParentSeqence", " "_userID, " "_parentID, tmpSequence))
            } else {
                s tmpSequence=$O(^DHCEMRM.ExamInsCategoryI("UserParentSeqence", " "_userID, " "_parentID, tmpSequence),-1)
            }
            q:(tmpSequence="")
            s id=$O(^DHCEMRM.ExamInsCategoryI("UserParentSeqence", " "_userID, " "_parentID, tmpSequence, ""))
            q:(flag=0)&&(isBottom=1)&&(id=siblingID)
            q:(flag=1)&&(isBottom'=1)&&(id=siblingID)
            s sibling = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(id)
            s tmpSequence = sibling.Seqence
            s sibling.Seqence = cate.Seqence
            s cate.Seqence = tmpSequence
            d cate.%Save()
            d sibling.%Save()               
            q:(id=siblingID)
        }   
    } else {
        s seq=$O(^DHCEMRM.ExamInsCategoryI("UserParentSeqence", " "_userID, " "_parentID, ""),-1)
        if (seq="") {
            d cate.%Save()              
        } else { 
            s id=$O(^DHCEMRM.ExamInsCategoryI("UserParentSeqence", " "_userID, " "_parentID, seq, ""))
            s sibling = ##Class(EMRmeta.ExampleInstanceCategory).%OpenId(id)
            if (cate.Seqence < sibling.Seqence) {
                s tmpSequence = sibling.Seqence
                s sibling.Seqence = cate.Seqence
                s cate.Seqence = tmpSequence
                d cate.%Save()
            }
        }
    }
    
    q "1"
ERROR
    q $zerror
}

/// Desc:       保存范例病历章节内容
/// Creator:    Candy
/// CreateDate: 2018-4-10
/// Input:      argExampleID 范例ID
///             argSectionCode 章节代码
///             argSectionName 章节名称
///             argName 目录名称
/// Output:     成功返回ID ,失败返回空
ClassMethod InsertInstanceDataForPersonalTmp(argExampleID As %String, argSectionCode As %String, argSectionName As %String, argSectionStatus As %String, argInData As %GlobalBinaryStream, argInstanceID As %String) As %String
{
	s $zt="ERRORInsert"
	s result = ""		
    q:(argExampleID = "")||(argInData = "") result 
        
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<MetaData>","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Scripts>","</Scripts>","10")
    s streamPresentationData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<PresentationData>","</PresentationData>","19")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<Medias>","</Medias>","9")
    s streamInitialData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<InitialData>","</InitialData>","14")
    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(argInData,"<ScatterData>","</ScatterData>","14")
    
	TStart

	s SectionRelationID = ..SaveExampleInsSectionRelation(argExampleID,argSectionCode,argSectionName,argSectionStatus)
	if (SectionRelationID = "0")
	{
		TRollback
		q result
	}
	
    s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleIDSectionCode",argExampleID," "_$zcvt(argSectionCode,"u"),""))

    if (rowId = "")
    {
	    //继承状态则不需要存储章节数据
		if (argSectionStatus = "REFERENCE")
		{
			s result = "1"
			TCommit
			q result
		}
		else
		{
			s obj = ##Class(EMRmeta.ExampleInstanceSection).%New()
		}
	}
	else
	{
		//继承状态则不需要存储章节数据
		if (argSectionStatus = "REFERENCE")
		{
			s sesc =  ##Class(EMRmeta.ExampleInstanceSection).%DeleteId(rowId)
			if ($$$ISOK(sesc))
			{
				s result = "1"
				TCommit
				q result
			}
			else
			{
				TRollback
				q result
			}
			
		}
		else
		{
			s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
		}
	}
	
	if (obj = "")
	{
		TRollback
		q result
	}

	s obj.ExampleID = argExampleID
	s obj.SectionCode = argSectionCode
	s obj.SectionName = argSectionName
	s obj.Status = 1  
    d obj.MetaData.CopyFrom(streamMetaData)
    d obj.ScriptData.CopyFrom(streamScriptData)
    d obj.PresentationData.CopyFrom(streamPresentationData)
    d obj.MediasData.CopyFrom(streamMediasData)
    d obj.InitialData.CopyFrom(streamInitialData)
    d obj.ScatterData.CopyFrom(streamScatterData)
	s sectionRowId = $o(^DHCEMRI.ISectionDescI("IdxForUpdate"," "_argInstanceID," "_$zcvt(argSectionCode,"U"),""))
	if (sectionRowId '= "") 
	{
		s objSection = ##Class(EMRinstance.ISectionDesc).%OpenId(sectionRowId)
		d:(objSection '= "") obj.Text.CopyFrom(objSection.Text) 
	}
    s sc = obj.%Save()
	if ($$$ISOK(sc)) 
	{
		s result = "1"
		TCommit
	}
	else
	{
		TRollback
	}
	q result

ERRORInsert
	TRollback
	q result
}

/// Desc:       存储章节继承关系
/// Creator:    
/// CreateDate: 
/// Input:      argExampleID      个人模板ID    EMRmeta.ExampleInstance表ID
/// 			argSectionCode	  章节编码
/// 			argSectionName    章节名称
/// 			argSectionStatus  章节继承状态 REFERENCE 继承，REPLACE 替换
/// Output:     成功返回ID ,失败返回空
ClassMethod SaveExampleInsSectionRelation(argExampleID As %String, argSectionCode As %String, argSectionName As %String, argSectionStatus As %String) As %String
{
	s $zt="ERROR"
	s ret = 0
	q:(argExampleID = "") ret
	
	s ExampleInsSecRelationID = $O(^DHCEMRM.ExampleInsSecRelationI("IdxExampleIDSection"," "_argExampleID," "_argSectionCode,""))
	if (ExampleInsSecRelationID = "")
	{
		s objExampleInsSecRelation = ##Class(EMRmeta.ExampleInsSecRelation).%New()
	}
	else
	{
		s objExampleInsSecRelation = ##Class(EMRmeta.ExampleInsSecRelation).%OpenId(ExampleInsSecRelationID)
	}
	
	s objExample = ##class(EMRmeta.ExampleInstance).%OpenId(argExampleID)
	s templateID = objExample.TemplateID
	s exampleName = objExample.Name
	
	s objExampleInsSecRelation.TemplateID = templateID
	s objExampleInsSecRelation.ExampleID = argExampleID
	s objExampleInsSecRelation.Name = exampleName
	s objExampleInsSecRelation.SectionCode = argSectionCode
	s objExampleInsSecRelation.SectionName = argSectionName
	s objExampleInsSecRelation.Status = argSectionStatus
	s sc = objExampleInsSecRelation.%Save()
	
	if ($$$ISOK(sc))
	{
		s ret=objExampleInsSecRelation.%Id()
	}
	else
	{
		s ret= "0"
	}		

	d objExampleInsSecRelation.%Close()
	q ret

ERROR
	q "0"
}

/// Desc:       范例章节数据
/// Input:      argExampleID 范例ID
/// Output:     章节tree数据流
/// Debug:      w ##Class(EMRservice.BL.BLExampleInstance).GetExampleSectionXmlByExampleID(1)
ClassMethod GetExampleSectionXmlByExampleID(argExampleID As %String, argArray As %ArrayOfDataTypes, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s result =  ""
	q:(argExampleID = "") result

    s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.ExamInsSectionI("ExampleID",argExampleID,rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.ExampleInstanceSection).%OpenId(rowId)
		continue:(obj = "")
		d:(argOutData.Size >0) argOutData.Write("-----------------------------7da4a26140fde")
		d argOutData.Write("{""SectionCode"":"""_obj.SectionCode_"""}$$")
		d argOutData.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
		d argOutData.Write("<Template>")
		d argOutData.Write("<Macros>")
		d argOutData.Write("<Macro/>")
		d argOutData.Write("</Macros>")
		d argOutData.Write("<StructuredBody>")
		d argOutData.CopyFrom(obj.MetaData)
		d argOutData.CopyFrom(obj.ScriptData)
		d argOutData.CopyFrom(obj.MediasData)
		d argOutData.CopyFrom(obj.InitialData)
		d argOutData.CopyFrom(obj.PresentationData)
		d argOutData.Write("</StructuredBody>")
		d argOutData.Write("</Template>") 
	}
	q result
}

}
