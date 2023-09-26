/// 名称:	EMR.DOC.BL.IStructToothSurface
/// 描述:	实例数据医学公式打散业务实现（牙位图牙面）
/// 编写者：	yejian
/// 编写日期: 	2022-11-24
/// 产品组：电子病历产品组
Class EMR.DOC.BL.IStructToothSurface Extends (%RegisteredObject, %XML.Adaptor)
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
	s TILData = ##Class(EMR.DAO.IStructToothSurface).GetTureIndexLocation(aEpisodeID)
	k objDoc
	s aData = ##class(EMR.DOC.DTO.NIToothSurface).%New()
	s scode = ""
	for
	{
		s scode = $o(@TILData@("IdxForUpdate",aDocumentID,scode))
		q:(scode = "")
		s tmpscode = $tr(scode," ","")
		s ticode = ""
		for
		{
			s ticode = $o(@TILData@("IdxForUpdate",aDocumentID,scode,ticode))
			q:(ticode = "")
			s tmpticode = $tr(ticode," ","")
			s tcode = ""
			for
			{
				s tcode = $o(@TILData@("IdxForUpdate",aDocumentID,scode,ticode,tcode))
				q:(tcode = "")
				s tmptcode = $tr(tcode," ","")
				s tscode = ""
				for
				{
					s tscode = $o(@TILData@("IdxForUpdate",aDocumentID,scode,ticode,tcode,tscode))
					q:(tscode = "")
					s rowId = $o(@TILData@("IdxForUpdate",aDocumentID,scode,ticode,tcode,tscode,""))
					s tmptscode = $tr(tscode," ","")
					s objItem = ##Class(EMR.DAO.IStructToothSurface).doOpenByID(aEpisodeID,rowId)
					continue:(objItem = "")
					s secTempID = objItem.TemplateID.%Id()
					s aText = ""
					//判断元素是否存在，存在返回1和元素对象，不存在返回0，报错-1
					s isHas = ##class(EMR.DOC.BL.IStructToothSurface).HasData(aScatterData,tmpscode,tmpticode,tmptcode,tmptscode,.aData) 
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
							s strRes =  ##class(EMR.DOC.BL.IStructToothSurface).UpData(aDocumentID,rowId,aData)
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
	}
	//插入新增的元素打散
	s code = ""
	s count = aScatterData.DataList.ToothSurface.Count()
	for i=1:1:count
	{
		s objItem = aScatterData.DataList.ToothSurface.GetAt(i)
		//排除编码为空数据
		continue:(objItem.ToothImageCode="")||(objItem.SectionCode="")||(objItem.ToothCode="")||(objItem.Code="")
		s sectionCode = $zcvt(objItem.SectionCode ,"U")
		s tImageCode = $zcvt(objItem.ToothImageCode,"U")
		s tCode = $zcvt(objItem.ToothCode,"U")
		s tsCode = $zcvt(objItem.Code,"U")
		s simRowID = $o(@TILData@("IdxForUpdate",aDocumentID," "_sectionCode," "_tImageCode," "_tCode," "_tsCode,""))
		if (simRowID = "")
		{
			s strRes = ##class(EMR.DOC.BL.IStructToothSurface).InsertData(aDocumentID,objItem) 
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
///             aTImageCode 牙位编码
///             aTCode 牙编码
/// 			aTSCode 牙位编码
/// OutPut:     包含 1,	不包含 0，失败 -1^失败信息
/// 			aText 存在输出内容
/// debug:	w ##CLASS(EMR.DOC.BL.IStructToothSurface).HasData()
ClassMethod HasData(aScatterData As EMR.DOC.DTO.NIScatterData, aSeCode As %String, aTImageCode As %String, aTCode As %String, aTSCode As %String, ByRef aData As EMR.DOC.DTO.NIToothSurface) As %String
{
	s strRes = 0
	q:((aScatterData.DataList = "")||(aScatterData.DataList.ToothSurface = "")) strRes
	q:(aSeCode="")||(aTImageCode="")||(aTCode="")||(aTSCode="") "-1^编码不能为空"
	s count = aScatterData.DataList.ToothSurface.Count()
	for i=1:1:count
	{
		s secCode = $zcvt(aScatterData.DataList.ToothSurface.GetAt(i).SectionCode,"U")
		s tImageCode = $zcvt(aScatterData.DataList.ToothSurface.GetAt(i).ToothImageCode,"U")
		s tcode = $zcvt(aScatterData.DataList.ToothSurface.GetAt(i).ToothCode,"U")
		s tscode = $zcvt(aScatterData.DataList.ToothSurface.GetAt(i).Code,"U")
		if (aSeCode=secCode)&&(tImageCode=aTImageCode)&&(tcode=aTCode)&&(tscode=aTSCode)
		{
			s strRes=1
			s aData = aScatterData.DataList.ToothSurface.GetAt(i)
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
/// Debug:	w ##class(EMR.DOC.BL.IStructToothSurface).UpData("1",) 
ClassMethod UpData(aDocumentID As %String, aSimID As %String, aData As EMR.DOC.DTO.NIToothSurface) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objItem = ##Class(EMR.DAO.IStructToothSurface).doOpenByID(aEpisodeID,aSimID)
	q:(objItem = "")
	s objItem.DocumentID = objDoc
	s objItem.SectionCode = aData.SectionCode
	s objItem.ToothImageCode = aData.ToothImageCode
	s objItem.ToothCode = aData.ToothCode	
	s objItem.ToothName = aData.ToothName
	s objItem.Code= aData.Code
	s objItem.Name= aData.Name
	s objItem.Quadrant = aData.Quadrant
	s objItem.Define = aData.Define
	s sc = objItem.%Save()
	k objDoc,objItem
	s:($$$ISERR(sc)) strRes="-1^更新打散牙位元素失败"
	q strRes
}

/// Desc:       插入数据
/// Creator:    yejian
/// CreateDate: 2022-11-24
/// Input:      aDocumentID 实例数据ID
///            	aData 元素打散对象
/// OutPut:     成功 1,	失败 -1^失败信息
/// 			argOutData json数据
/// Debug:	w ##class(EMR.DOC.BL.IStructToothSurface).InsertSectionData("1",) 
ClassMethod InsertData(aDocumentID As %String, aData As EMR.DOC.DTO.NIToothSurface) As %String
{
	s strRes = 1
	s objDoc = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s aEpisodeID =objDoc.EpisodeID.%Id()
	s objItem = ##Class(EMR.DAO.IStructToothSurface).doCreateInstance(aEpisodeID)
	;s objItem = ##Class(EMR.DB.IStructToothSurface).%OpenId(aEpisodeID,aSimID)
	s objItem.DocumentID = objDoc
	s objItem.EpisodeID = objDoc.EpisodeID
	s objItem.PatientID = objDoc.PatientID
	s objItem.DOCCode = objDoc.DOCCode
	s objItem.SectionCode = aData.SectionCode
	s objItem.EMRCode = aData.EMRCode
	s objItem.TemplateID = objDoc.TemplateID
	s objItem.TemplateVersion = objDoc.TemplateVersion
	s objItem.KBNodeID = aData.KBNodeID 
	
	s objItem.ToothImageCode = aData.ToothImageCode	
	s objItem.ToothCode = aData.ToothCode	
	s objItem.ToothName = aData.ToothName
	s objItem.Code= aData.Code
	s objItem.Name= aData.Name
	s objItem.Quadrant = aData.Quadrant
	s objItem.Define = aData.Define
	s sc = objItem.%Save()
	k objDoc,objItem
	s:($$$ISERR(sc)) strRes="-1^插入打散牙位元素失败"
	q strRes
}

}
