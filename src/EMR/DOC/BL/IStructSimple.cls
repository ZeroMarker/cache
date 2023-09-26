/// 名称:	EMR.DOC.BL.IStructSimple
/// 描述:	实例数据元素打散业务实现
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.IStructSimple Extends (%RegisteredObject, %XML.Adaptor)
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
	s TILData = ##Class(EMR.DAO.IStructSimple).GetTureIndexLocation(aEpisodeID)
	k objDoc
	s aData = ##class(EMR.DOC.DTO.NISimple).%New()
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
			s objISimple = ##Class(EMR.DAO.IStructSimple).doOpenByID(aEpisodeID,rowId)
			continue:(objISimple = "")
			s secTempID = objISimple.TemplateID.%Id()
			s aText = ""
			//判断元素是否存在，存在返回1和元素内容，不存在返回0，报错-1
			s isHas = ##class(EMR.DOC.BL.IStructSimple).HasData(aScatterData,tmpscode,tmpcode,.aData) 
			if (isHas=1)
			{
				//模板ID不一致，删除元素
				if (secTempID '= TemplateID)
				{
					s sc = objISimple.%DeleteId(rowId)
					if ($$$ISERR(sc))
					{
						s strRes="-1^删除元素打散失败"
						q
					}
				}
				else //更新元素打散
				{
					s strRes =  ##class(EMR.DOC.BL.IStructSimple).UpData(aDocumentID,rowId,aData)
					q:(strRes ["-1")
				}
				
			}
			else //删除元素打散
			{
				s sc = objISimple.%DeleteId(rowId)
				if ($$$ISERR(sc))
				{
					s strRes="-1^删除元素打散失败"
					q
				}
			}
			k objISimple
		}
	}
	//插入新增的元素打散
	s code = ""
	s count = aScatterData.DataList.Simples.Count()
	for i=1:1:count
	{
		s objISimple = aScatterData.DataList.Simples.GetAt(i)
		//排除编码为空数据
		continue:(objISimple.Code="")||(objISimple.SectionCode="")
		s sectionCode = $zcvt(objISimple.SectionCode ,"U")
		s simCode = $zcvt(objISimple.Code,"U")
		s simRowID = $o(@TILData@("IdxForUpdate",aDocumentID," "_sectionCode," "_simCode,""))
		if (simRowID = "")
		{
			s strRes = ##class(EMR.DOC.BL.IStructSimple).InsertData(aDocumentID,objISimple) 
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
/// debug:	w ##CLASS(EMR.DOC.BL.IStructSimple)     
ClassMethod HasData(aScatterData As EMR.DOC.DTO.NIScatterData, aSeCode As %String, aSimCode As %String, ByRef aData As EMR.DOC.DTO.NISimple) As %String
{
	s strRes = 0
	q:((aScatterData.DataList = "")||(aScatterData.DataList.Simples = "")) strRes
	q:(aSeCode="")||(aSimCode="") "-1^元素编码不能为空"
	s count = aScatterData.DataList.Simples.Count()
	for i=1:1:count
	{
		s secCode = $zcvt(aScatterData.DataList.Simples.GetAt(i).SectionCode,"U")
		s simCode = $zcvt(aScatterData.DataList.Simples.GetAt(i).Code,"U")
		if (aSeCode=secCode)&&(simCode=aSimCode)
		{
			s strRes=1
			s aData = aScatterData.DataList.Simples.GetAt(i)
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
/// Debug:	w ##class(EMR.DOC.BL.IStructSimple).UpData("1",) 
ClassMethod UpData(aDocumentID As %String, aSimID As %String, aData As EMR.DOC.DTO.NISimple) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objISimple = ##Class(EMR.DAO.IStructSimple).doOpenByID(aEpisodeID,aSimID)
	q:(objISimple = "")
	s objISimple.DocumentID = objDoc
	s objISimple.SectionCode = aData.SectionCode
	s objISimple.SimpleItemCode = aData.Code
	s objISimple.SimpleItemName = aData.Name		
	s objISimple.KBNodeID = aData.KBNodeID 
	s objISimple.DataRef = aData.DataRef
	s objISimple.DataValue = aData.DataValue
	s objISimple.Separator = aData.Separator
	s objISimple.ValueCode = aData.ValueCode
	s objISimple.Type = aData.Type
	s sc = objISimple.%Save()
	k objDoc,objISimple
	s:($$$ISERR(sc)) strRes="-1^插入打散元素失败"
	q strRes
}

/// Desc:       插入数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///            	aData 元素打散对象
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Debug:	w ##class(EMR.DOC.BL.IStructSimple).InsertSectionData("1",) 
ClassMethod InsertData(aDocumentID As %String, aData As EMR.DOC.DTO.NISimple) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objISimple = ##Class(EMR.DAO.IStructSimple).doCreateInstance(aEpisodeID)
	;s objISimple = ##Class(EMR.DB.IStructSimple).%OpenId(aEpisodeID)
	s objISimple.DocumentID = objDoc
	s objISimple.EpisodeID = objDoc.EpisodeID
	s objISimple.PatientID = objDoc.PatientID
	s objISimple.DOCCode = objDoc.DOCCode
	s objISimple.SectionCode = aData.SectionCode
	s objISimple.EMRCode = aData.EMRCode
	s objISimple.TemplateID = objDoc.TemplateID
	s objISimple.TemplateVersion = objDoc.TemplateVersion
	s objISimple.SimpleItemCode = aData.Code
	s objISimple.SimpleSourceCode = aData.SourceCode
	s objISimple.SimpleItemName = aData.Name		
	s objISimple.KBNodeID = aData.KBNodeID 
	s objISimple.DataRef = aData.DataRef
	s objISimple.DataValue = aData.DataValue
	s objISimple.Separator = aData.Separator
	s objISimple.ValueCode = aData.ValueCode
	s objISimple.Type = aData.Type
	s sc = objISimple.%Save()
	k objDoc,objISimple
	s:($$$ISERR(sc)) strRes="-1^插入打散元素失败"
	q strRes
}

}
