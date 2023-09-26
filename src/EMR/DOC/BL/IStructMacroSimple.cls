/// 名称:	EMR.DOC.BL.IStructMacroSimple
/// 描述:	实例数据宏子项公式打散业务实现（月经生育史子项）
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.IStructMacroSimple Extends (%RegisteredObject, %XML.Adaptor)
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
	s TILData = ##Class(EMR.DAO.IStructMacroSimple).GetTureIndexLocation(aEpisodeID)
	k objDoc
	s aData = ##class(EMR.DOC.DTO.NIMacroItems).%New()
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
			s type = ""
			for
			{
				s type = $o(@TILData@("IdxForUpdate",aDocumentID,scode,code,type))
				q:(type = "")
				s rowId = $o(@TILData@("IdxForUpdate",aDocumentID,scode,code,type,""))
				s tmpcode = $tr(code," ","")
				s tmptype = $tr(type," ","")
				s objItem = ##Class(EMR.DAO.IStructMacroSimple).doOpenByID(aEpisodeID,rowId)
				continue:(objItem = "")
				s secTempID = objItem.TemplateID.%Id()
				s aText = ""
				//判断元素是否存在，存在返回1和元素对象，不存在返回0，报错-1
				s isHas = ##class(EMR.DOC.BL.IStructMacroSimple).HasData(aScatterData,tmpscode,tmpcode,tmptype,.aData) 
				if (isHas=1)
				{
					//模板ID不一致，删除元素
					if (secTempID '= TemplateID)
					{
						s sc = objItem.%DeleteId(rowId)
						if ($$$ISERR(sc))
						{
							s strRes="-1^删除宏子元素打散失败"
							q
						}
					}
					else //更新元素打散
					{
						s strRes =  ##class(EMR.DOC.BL.IStructMacroSimple).UpData(aDocumentID,rowId,aData)
						q:(strRes ["-1")
					}
					
				}
				else //删除元素打散
				{
					s sc = objItem.%DeleteId(rowId)
					if ($$$ISERR(sc))
					{
						s strRes="-1^删除宏子元素打散失败"
						q
					}
				}
				k objItem
			}
		}
	}
	//插入新增的元素打散
	s code = ""
	s count = aScatterData.DataList.MacroItems.Count()
	for i=1:1:count
	{
		s objItem = aScatterData.DataList.MacroItems.GetAt(i)
		//排除编码为空数据
		continue:(objItem.Code="")||(objItem.SectionCode="")||(objItem.MacroCode="")
		s sectionCode = $zcvt(objItem.SectionCode ,"U")
		s macCode = $zcvt(objItem.MacroCode,"U")
		s Code = $zcvt(objItem.Code,"U")
		s simRowID = $o(@TILData@("IdxForUpdate",aDocumentID," "_sectionCode," "_macCode," "_Code,""))
		if (simRowID = "")
		{
			s strRes = ##class(EMR.DOC.BL.IStructMacroSimple).InsertData(aDocumentID,objItem) 
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
///             aMacCode 宏编码
///             aType 宏子项类型
/// OutPut:     包含 1,	不包含 0，失败 -1^失败信息
/// 			aText 存在输出内容
/// debug:	w ##CLASS(EMR.DOC.BL.IStructMacroSimple).HasData()
ClassMethod HasData(aScatterData As EMR.DOC.DTO.NIScatterData, aSeCode As %String, aMacCode As %String, aCode As %String, ByRef aData As EMR.DOC.DTO.NIMacroItems) As %String
{
	s strRes = 0
	q:((aScatterData.DataList = "")||(aScatterData.DataList.MacroItems = "")) strRes
	q:(aSeCode="")||(aMacCode="")||(aCode="") "-1^编码不能为空"
	s count = aScatterData.DataList.MacroItems.Count()
	for i=1:1:count
	{
		s secCode = $zcvt(aScatterData.DataList.MacroItems.GetAt(i).SectionCode,"U")
		s macCode = $zcvt(aScatterData.DataList.MacroItems.GetAt(i).MacroCode,"U")
		s code = $zcvt(aScatterData.DataList.MacroItems.GetAt(i).Code,"U")
		if (aSeCode=secCode)&&(macCode=aMacCode)&&(code=aCode)
		{
			s strRes=1
			s aData = aScatterData.DataList.MacroItems.GetAt(i)
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
/// Debug:	w ##class(EMR.DOC.BL.IStructMacroSimple).UpData("1",) 
ClassMethod UpData(aDocumentID As %String, aSimID As %String, aData As EMR.DOC.DTO.NIMacroItems) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objItem = ##Class(EMR.DAO.IStructMacroSimple).doOpenByID(aEpisodeID,aSimID)
	q:(objItem = "")
	s objItem.DocumentID = objDoc
	s objItem.SectionCode = aData.SectionCode
	s objItem.MacroCode = aData.MacroCode
	s objItem.MacroSourceCode = aData.MacroSourceCode
	s objItem.MacroItemCode = aData.Code		
	s objItem.KBNodeID = aData.KBNodeID 
	s objItem.Name = aData.Name
	s objItem.Value = aData.Text
	s sc = objItem.%Save()
	k objDoc,objItem
	s:($$$ISERR(sc)) strRes="-1^更新打散宏子元素失败"
	q strRes
}

/// Desc:       插入数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///            	aData 元素打散对象
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Debug:	w ##class(EMR.DOC.BL.IStructMacroSimple).InsertSectionData("1",) 
ClassMethod InsertData(aDocumentID As %String, aData As EMR.DOC.DTO.NIMacroItems) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objItem = ##Class(EMR.DAO.IStructMacroSimple).doCreateInstance(aEpisodeID)
	;s objItem = ##Class(EMR.DB.IStructMacroSimple).%OpenId(aEpisodeID,aSimID)
	s objItem.DocumentID = objDoc
	s objItem.EpisodeID = objDoc.EpisodeID
	s objItem.PatientID = objDoc.PatientID
	s objItem.DOCCode = objDoc.DOCCode
	s objItem.SectionCode = aData.SectionCode
	s objItem.EMRCode = aData.EMRCode
	s objItem.TemplateID = objDoc.TemplateID
	s objItem.TemplateVersion = objDoc.TemplateVersion
	s objItem.MacroCode = aData.MacroCode
	s objItem.MacroSourceCode = aData.MacroSourceCode
	s objItem.MacroItemCode = aData.Code		
	s objItem.KBNodeID = aData.KBNodeID 
	s objItem.Name = aData.Name
	s objItem.Value = aData.Text
	s sc = objItem.%Save()
	k objDoc,objItem
	s:($$$ISERR(sc)) strRes="-1^插入打散宏子元素失败"
	q strRes
}

}
