/// 名称:	EMR.DOC.BL.IStructSection
/// 描述:	实例数据章节打散业务实现
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.IStructSection Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存章节打散数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///             aScatterData 打散数据集合
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Output:     strRes 1成功,-1失败    
ClassMethod Save(aScatterData As EMR.DOC.DTO.NIScatterData, aDocumentID As %String) As %String
{
	s $zt = "ErrorHandler"
	s strRes = 1
	q:(aDocumentID = "") "-1^文档ID不能为空"
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc = "") "-1^获取文档对象失败"
	s TemplateID = objDoc.TemplateID.%Id()
	s aEpisodeID = objDoc.EpisodeID.%Id()
	s TILData = ##Class(EMR.DAO.IStructSection).GetTureIndexLocation(aEpisodeID)
	k objDoc
	s code = "",aData = ##class(EMR.DOC.DTO.NISection).%New()
	for
	{
		s code = $o(@TILData@("IdxForUpdate",aDocumentID,code))
		q:(code = "")
		s rowId = $o(@TILData@("IdxForUpdate",aDocumentID,code,""))
		s tmpcode = $tr(code," ","")
		s objIScetion = ##Class(EMR.DAO.IStructSection).doOpenByID(aEpisodeID,rowId)
		continue:(objIScetion = "")
		s secTempID = objIScetion.TemplateID.%Id()
		//判断章节是否存在，存在返回1和章节内容，不存在返回0，报错-1
		s isHas = ##class(EMR.DOC.BL.IStructSection).HasData(aScatterData,tmpcode,.aData) 
		if (isHas=1)
		{
			//模板ID不一致，删除章节
			if (secTempID '= TemplateID)
			{
				s sc = objIScetion.%DeleteId(rowId)
				if ($$$ISERR(sc))
				{
					s strRes="-1^删除章节打散失败"
					q
				}
			}
			else //更新章节打散
			{
				d objIScetion.Text.Write(aData.Text)
				s sc = objIScetion.%Save()
				if ($$$ISERR(sc))
				{
					s strRes="-1^保存章节打散失败"
					q
				}
			}
			
		}
		else //删除章节打散
		{
			s sc = objIScetion.%DeleteId(rowId)
			if ($$$ISERR(sc))
			{
				s strRes="-1^删除章节打散失败"
				q
			}
		}
		k objIScetion
	}
	//插入新增的章节打散
	s code = ""
	s count = aScatterData.DataList.Sections.Count()
	for i=1:1:count
	{
		s objSection = aScatterData.DataList.Sections.GetAt(i)
		s sectionCode = $zcvt(objSection.Code,"U")
		s secRowID = $o(@TILData@("IdxForUpdate",aDocumentID," "_sectionCode,""))
		if (secRowID = "")
		{
			s strRes = ##class(EMR.DOC.BL.IStructSection).InsertData(aDocumentID,objSection) 
			q:(strRes ["-1")
		}
	}
	q strRes
ErrorHandler
   q strRes_aDocumentID_$zerror
}

/// Desc:       判断是否存在集合
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aScatterData 打散集合
///             aCode 章节编码
/// OutPut:     包含 1,	不包含 0，失败 -1^失败信息
/// 			aText 存在输出内容
/// debug:	w ##CLASS(EMR.DOC.BL.IStructSection)     
ClassMethod HasData(aScatterData As EMR.DOC.DTO.NIScatterData, aCode As %String, ByRef aData As EMR.DOC.DTO.NISection) As %String
{
	s strRes = 0
	q:((aScatterData.DataList = "")||(aScatterData.DataList.Sections = "")) strRes
	q:(aCode="") "-1^章节编码不能为空"
	s count = aScatterData.DataList.Sections.Count()
	for i=1:1:count
	{
		s sectionCode = $zcvt(aScatterData.DataList.Sections.GetAt(i).Code,"U")
		if (aCode=sectionCode)
		{
			s strRes=1
			s aData = aScatterData.DataList.Sections.GetAt(i)
			q
		}
	}
	q strRes
}

/// Desc:       插入数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///            	aSection 章节打散对象
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Debug:	w ##class(EMR.DOC.BL.IStructSection).InsertSectionData("1",) 
ClassMethod InsertData(aDocumentID As %String, aSection As EMR.DOC.DTO.NISection) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objIScetion = ##Class(EMR.DAO.IStructSection).doCreateInstance(aEpisodeID)
	s objIScetion.DocumentID = objDoc
	s objIScetion.EpisodeID = objDoc.EpisodeID
	s objIScetion.PatientID = objDoc.PatientID
	s objIScetion.DOCCode = objDoc.DOCCode
	s objIScetion.SectionCode = aSection.Code
	s objIScetion.EMRCode = aSection.EMRCode
	s objIScetion.SectionName = aSection.Name
	s objIScetion.TemplateID = objDoc.TemplateID
	s objIScetion.TemplateVersion = objDoc.TemplateVersion
	d objIScetion.Text.Write(aSection.Text)
	s sc = objIScetion.%Save()
	k objDoc,objIScetion
	s:($$$ISERR(sc)) strRes="-1^插入打散章节失败"
	q strRes
}

}
