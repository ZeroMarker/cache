/// 名称:	EMR.DOC.BL.IStructMacro
/// 描述:	实例数据宏公式打散业务实现（月经生育史）
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.IStructMacro Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存元素打散数据
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
	s TILData = ##Class(EMR.DAO.IStructMacro).GetTureIndexLocation(aEpisodeID)
	k objDoc
	s aData = ##class(EMR.DOC.DTO.NIMacro).%New()
	s scode = ""
	for
	{
		s scode = $o(@TILData@("IdxForUpdate",aDocumentID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s code = ""
		for
		{
			s code = $o(@TILData@("IdxForUpdate",aDocumentID,scode,code))
			q:(code = "")
			s rowId = $o(@TILData@("IdxForUpdate",aDocumentID,scode,code,""))
			s tmpcode = $tr(code," ","")
			s objItem = ##Class(EMR.DAO.IStructMacro).doOpenByID(aEpisodeID,rowId)
			continue:(objItem = "")
			s secTempID = objItem.TemplateID.%Id()
			s aText = ""
			//判断元素是否存在，存在返回1和元素对象，不存在返回0，报错-1
			s isHas = ##class(EMR.DOC.BL.IStructMacro).HasData(aScatterData,tmpscode,tmpcode,.aData) 
			if (isHas=1)
			{
				//模板ID不一致，删除元素
				if (secTempID '= TemplateID)
				{
					s sc = objItem.%DeleteId(rowId)
					if ($$$ISERR(sc))
					{
						s strRes="-1^删除元素打散失败"
						q
					}
				}
				else //更新元素打散
				{
					s strRes =  ##class(EMR.DOC.BL.IStructMacro).UpData(aDocumentID,rowId,aData)
					q:(strRes ["-1")
				}
				
			}
			else //删除元素打散
			{
				s sc = objItem.%DeleteId(rowId)
				if ($$$ISERR(sc))
				{
					s strRes="-1^删除元素打散失败"
					q
				}
			}
			k objItem
		}
	}
	//插入新增的元素打散
	s code = ""
	s count = aScatterData.DataList.Macros.Count()
	for i=1:1:count
	{
		s objItem = aScatterData.DataList.Macros.GetAt(i)
		//排除编码为空数据
		continue:(objItem.Code="")||(objItem.SectionCode="")
		s sectionCode = $zcvt(objItem.SectionCode ,"U")
		s simCode = $zcvt(objItem.Code,"U")
		s simRowID = $o(@TILData@("IdxForUpdate",aDocumentID," "_sectionCode," "_simCode,""))
		if (simRowID = "")
		{
			s strRes = ##class(EMR.DOC.BL.IStructMacro).InsertData(aDocumentID,objItem) 
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
/// 			aSeCode 章节编码
///             aSimCode 元素编码
/// OutPut:     包含 1,	不包含 0，失败 -1^失败信息
/// 			aText 存在输出内容
/// debug:	w ##CLASS(EMR.DOC.BL.IStructMacro)     
ClassMethod HasData(aScatterData As EMR.DOC.DTO.NIScatterData, aSeCode As %String, aSimCode As %String, ByRef aData As EMR.DOC.DTO.NIMacro) As %String
{
	s strRes = 0
	q:((aScatterData.DataList = "")||(aScatterData.DataList.Macros = "")) strRes
	q:(aSeCode="")||(aSimCode="") "-1^元素编码不能为空"
	s count = aScatterData.DataList.Macros.Count()
	for i=1:1:count
	{
		s secCode = $zcvt(aScatterData.DataList.Macros.GetAt(i).SectionCode,"U")
		s simCode = $zcvt(aScatterData.DataList.Macros.GetAt(i).Code,"U")
		if (aSeCode=secCode)&&(simCode=aSimCode)
		{
			s strRes=1
			s aData = aScatterData.DataList.Macros.GetAt(i)
			q
		}
	}
	q strRes
}

/// Desc:       更新数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///            	aData 元素打散对象
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Debug:	w ##class(EMR.DOC.BL.IStructMacro).UpData("1",) 
ClassMethod UpData(aDocumentID As %String, aSimID As %String, aData As EMR.DOC.DTO.NIMacro) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objItem = ##Class(EMR.DAO.IStructMacro).doOpenByID(aEpisodeID,aSimID)
	q:(objItem = "")
	s objItem.DocumentID = objDoc
	s objItem.SectionCode = aData.SectionCode
	s objItem.MacroCode = aData.Code
	s objItem.MacroSourceCode = aData.SourceCode
	s objItem.MacroName = aData.Name		
	s objItem.KBNodeID = aData.KBNodeID 
	s objItem.MacroType = aData.Type
	s objItem.MacroSize = aData.Size
	d objItem.Text.Write(aData.Text)
	s sc = objItem.%Save()
	k objDoc,objItem
	s:($$$ISERR(sc)) strRes="-1^插入打散宏元素失败"
	q strRes
}

/// Desc:       插入数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///            	aData 元素打散对象
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Debug:	w ##class(EMR.DOC.BL.IStructMacro).InsertSectionData("1",) 
ClassMethod InsertData(aDocumentID As %String, aData As EMR.DOC.DTO.NIMacro) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objItem = ##Class(EMR.DAO.IStructMacro).doCreateInstance(aEpisodeID)
	;s objItem = ##Class(EMR.DB.IStructMacro).%OpenId(aEpisodeID,aSimID)
	s objItem.DocumentID = objDoc
	s objItem.EpisodeID = objDoc.EpisodeID
	s objItem.PatientID = objDoc.PatientID
	s objItem.DOCCode = objDoc.DOCCode
	s objItem.SectionCode = aData.SectionCode
	s objItem.EMRCode = aData.EMRCode
	s objItem.TemplateID = objDoc.TemplateID
	s objItem.TemplateVersion = objDoc.TemplateVersion
	s objItem.MacroCode = aData.Code
	s objItem.MacroSourceCode = aData.SourceCode
	s objItem.MacroName = aData.Name		
	s objItem.KBNodeID = aData.KBNodeID 
	s objItem.MacroType = aData.Type
	s objItem.MacroSize = aData.Size
	d objItem.Text.Write(aData.Text)
	s sc = objItem.%Save()
	k objDoc,objItem
	s:($$$ISERR(sc)) strRes="-1^插入打散宏元素失败"
	q strRes
}

}
