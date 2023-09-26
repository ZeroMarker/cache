Class EMRservice.InterfaceService.TemplateService Extends %RegisteredObject
{

/// 导出所有病历模板数据
/// d ##class(EMRservice.InterfaceService.TemplateService).ExportAllTemplate()
ClassMethod ExportAllTemplate(APath As %String = "/tmp/EMRDocument/", AElementType As %String = "Template")
{
	s categoryId=""
	for
	{
		s categoryId = $o(^DHCEMRM.TemplateI("IndexCategoryId",categoryId))
		q:(categoryId="")
		s templateId=""
		for 
		{
			s templateId = $o(^DHCEMRM.TemplateI("IndexCategoryId",categoryId,templateId))
			q:(templateId="")
			
			s objTemplate =""
			s objTemplate = ##class(EMRmeta.Template).%OpenId(templateId)
			continue:(objTemplate = "")
			/// DOC GRID
			s DocumentType = objTemplate.DocumentType
			s ChartItemType =  objTemplate.ChartItemType
			s TemplateProperty = objTemplate.TemplateProperty
			s Description = objTemplate.Description
			s GUID = objTemplate.GUID
			s LastVersion = objTemplate.LastVersion
			s Name = objTemplate.Name
			s PublishVersion = objTemplate.PublishVersion
			s TemplateCategoryID = objTemplate.TemplateCategoryID
			s objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(TemplateCategoryID)
			continue:(objTemplateCategory="")
			s TemplateGroupName = objTemplateCategory.Name
			s Code = objTemplate.Code
			s DisplayName = objTemplate.DisplayName
			
			//////////////TemplateVersion//////////Publish
			s templateVersionId=""
			s templateVersionId = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateId,PublishVersion,templateVersionId))
			continue:(templateVersionId="")
			
			s objTemplateVersion=""
			s objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(templateVersionId)	
			continue:(objTemplateVersion="")
			
			s Author = objTemplateVersion.Author
			s CreateDate = objTemplateVersion.CreateDate
			s CreateTime = objTemplateVersion.CreateTime
			s LastSaveDate = objTemplateVersion.LastSaveDate
			s LastSaveTime = objTemplateVersion.LastSaveTime
			
			s MetaData = ##class(%GlobalBinaryStream).%New()
			d MetaData.CopyFrom(objTemplateVersion.MetaData)
			
			s PresentationData = ##class(%GlobalBinaryStream).%New()
			d PresentationData.CopyFrom(objTemplateVersion.PresentationData)
			
			s GridData = ##class(%GlobalBinaryStream).%New()
			d GridData.CopyFrom(objTemplateVersion.GridData)
			
			s ScriptData = ##class(%GlobalBinaryStream).%New()
			d ScriptData.CopyFrom(objTemplateVersion.ScriptData)
			
			s ScriptData = ##class(%GlobalBinaryStream).%New()
			d ScriptData.CopyFrom(objTemplateVersion.ScriptData)
			
			
			s MediasData = ##class(%GlobalBinaryStream).%New()
			d MediasData.CopyFrom(objTemplateVersion.MediasData)
			
			s InitialData = ##class(%GlobalBinaryStream).%New()
			d InitialData.CopyFrom(objTemplateVersion.InitialData)
			
			s PublicationDate= objTemplateVersion.PublicationDate
			
			s PublicationTime = objTemplateVersion.PublicationTime
			
			s Status= objTemplateVersion.Status
			
			s VersionNumber=objTemplateVersion.VersionNumber
			
			s TemplateSummary= objTemplateVersion.TemplateSummary
			
			
			///输出模板//
			

			s stream = ##Class(%GlobalBinaryStream).%New()

			s templatePropertyCode = "testCode"
			s templatePropertyName = "testName"
		 	s ctPropRowID = $o(^DHCEMRM.CTPropertyI("IdxCode"," "_$zcvt(objTemplate.TemplateProperty,"U"),""))
			s objCTProperty = ##Class(EMRmeta.CTProperty).%OpenId(ctPropRowID)
			if (objCTProperty '= "")
			{
				s templatePropertyCode = $zcvt(objCTProperty.PropertyCode,"O","UTF8")
				s templatePropertyName = $zcvt(objCTProperty.PropertyName,"O","UTF8")
			}
			s code = $ZSTRIP(objTemplate.Code,"*C")  //去特殊字符
			s code = $zcvt(code,"O","UTF8") //转为UTF8码制
			s displayName = $ZSTRIP(objTemplate.DisplayName,"*C") //去特殊字符
			s displayName = $zcvt(displayName,"O","UTF8") //转为UTF8码制
			
			//xml流
			d stream.Write("<?xml version=""1.0"" encoding=""UTF-8""?>")
			d stream.Write("<"_AElementType_">")
			
			d stream.Write("<TemplateName>"_$zcvt(Name,"O","UTF8")_"</TemplateName>")
 		 	d stream.Write("<TemplateDesc>")
 		 	d stream.Write("</TemplateDesc>")
  			d stream.Write("<DocumentType>"_DocumentType_"</DocumentType>")
  
			d stream.Write("<Code Code="""_code_""" DisplayName="""_displayName_"""/>")
			d stream.Write("<TemplateGUID>"_objTemplate.GUID_"</TemplateGUID>")
			d stream.Write("<TemplateType>"_objTemplate.ChartItemType_"</TemplateType>")
			d stream.Write("<TemplateProperty Code="""_templatePropertyCode_""" DisplayName="""_templatePropertyName_"""/>")
			
			
			d stream.Write("<Title Code="""" DisplayName=""""/>")
			
			d stream.Write("<Macros/>")
			  
			//表格文档需要加打印信息
			d:($zcvt(objTemplate.DocumentType,"U") = "GRID") stream.Write("<PrintSetup/>")
			d stream.Write("<StructuredBody>")
			d stream.CopyFrom(MetaData)
			d stream.CopyFrom(ScriptData)
			d stream.CopyFrom(MediasData)
			d stream.CopyFrom(InitialData)
			d stream.CopyFrom(PresentationData)
			d stream.Write("</StructuredBody>")
			if (templateId=4)
			{
				d stream.Write("<BindTemplateIds>466</BindTemplateIds>")
  				d stream.Write("<BindTemplateGuids>8bc16bdd-964d-4379-b920-6d54db550676</BindTemplateGuids>")
  				d stream.Write("<BindTemplateDescs>通用入院记录</BindTemplateDescs>")
			}
			else
			{
				d stream.Write("<BindTemplateIds></BindTemplateIds>")
  				d stream.Write("<BindTemplateGuids></BindTemplateGuids>")
  				d stream.Write("<BindTemplateDescs></BindTemplateDescs>")	
			}
			d stream.Write("</"_AElementType_">") 
			
			
			s AStream=##Class(%FileBinaryStream).%New()
			s AStream.Filename=APath_templateId_"_"_PublishVersion_"_"_Name_".xml"
			d AStream.CopyFrom(stream)
			d AStream.SaveStream()
			d AStream.%Close()
	
		}

	}
}

/// 导出所有病历模板数据
/// d ##class(EMRservice.InterfaceService.TemplateService).ImportTemplateByFile("D:\EMRDocument16\tree.txt")
ClassMethod ImportTemplateByFile(AFilePath As %String)
{

	s length = $l(AFilePath,"\")
	s rootPath = $p(AFilePath,"\",1,length-1)
		
	s Stream=##Class(%FileBinaryStream).%New()
	s Stream.Filename=AFilePath
	
	While 'Stream.AtEnd {
		Set sRec = Stream.ReadLine()
		Set sRec = $zcvt($tr(sRec,$c(13),""),"I","UTF8")
		continue:(sRec = "")

		s xmlFileName = $p(sRec, $c(9), 1)
		s templateId = $p(xmlFileName,"_",1)
		s version= $p(xmlFileName,"_",2)
		s templateName = $p(xmlFileName,"_",3)
		
		s TemplateStream=##Class(%FileBinaryStream).%New()
	 	s TemplateStream.Filename=rootPath_"\"_xmlFileName
	 	w !,xmlFileName
	 	
	 	s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(TemplateStream,"<MetaData","</MetaData>","11")
	    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(TemplateStream,"<Scripts","</Scripts>","10")
	    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(TemplateStream,"<Medias","</Medias>","9")
	    s streamInitialData = ##Class(EMRservice.Parser.StreamData).ParserStream(TemplateStream,"<InitialData","</InitialData>","14")
	    s streamPresentationData = ##Class(EMRservice.Parser.StreamData).ParserStream(TemplateStream,"<PresentationData","</PresentationData>","19") 
	
		s tvId = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_templateId,version,""))
		
		s objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(tvId)
		continue:(objTemplateVersion="")
		
		d objTemplateVersion.MetaData.Clear()
		d objTemplateVersion.MetaData.CopyFrom(streamMetaData)
		
		d objTemplateVersion.ScriptData.Clear()
		d objTemplateVersion.ScriptData.CopyFrom(streamScriptData)
		
		d objTemplateVersion.MediasData.Clear()
		d objTemplateVersion.MediasData.CopyFrom(streamMediasData)
		
		d objTemplateVersion.InitialData.Clear()
		d objTemplateVersion.InitialData.CopyFrom(streamInitialData)
		
		d objTemplateVersion.PresentationData.Clear()
		d objTemplateVersion.PresentationData.CopyFrom(streamPresentationData)
		s sc=objTemplateVersion.%Save()
		
		if ($$$ISERR(sc))
		{
			w !,"error:"_xmlFileName
		}
		
	 	
	}
}

}
