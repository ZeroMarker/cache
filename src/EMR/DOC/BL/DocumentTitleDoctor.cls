/// 名称:	EMR.DOC.BL.DocumentTitleDoctor
/// 描述:	标题选择信息业务逻辑
/// 编写者：yejian
/// 编写日期: 2023-5-9
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DocumentTitleDoctor Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取标题选择信息数据
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aEpisodeID:用户ID
/// 				aDocumentID:文档ID
/// 			outJson json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	q ##Class(EMR.DOC.BL.DocumentTitleDoctor).GetTitleDatas("10209",.obj)
ClassMethod GetTitleDatas(aEpisodeID As %String, aDocumentID As %String, ByRef outJson As %DynamicObject) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aDocumentID="") "-1^文档ID不能为空"
	q:(aEpisodeID="") "-1^就诊号不能为空"
	s:(outJson="") outJson = ##class(%DynamicObject).%New()
	s TILDocumentTitleDoctor = ##class(EMR.DAO.DocumentTitleDoctor).GetTureIndexLocation(aEpisodeID)
	s rowID = $o(@TILDocumentTitleDoctor@("IdxDocumentID"," "_aDocumentID,""))
	q:(rowID="") strRes
	s objTitleDatas = ##class(EMR.DAO.DocumentTitleDoctor).doOpenByID(aEpisodeID,rowID)
	s outJson.DocumentID = objTitleDatas.DocumentID
	s outJson.UserID = objTitleDatas.UserID
	s outJson.UserName = objTitleDatas.UserName
	s outJson.UserLevel = objTitleDatas.UserLevel
	s outJson.UserLevelDesc = objTitleDatas.UserLevelDesc
	q strRes
Error
	q "-1^"_"获取标题信息失败:"_$zerror
}

/// Desc:       更新标题选择信息数据
/// Creator:    yejian
/// CreateDate: 2023-5-8
/// Table:		
/// Input: 		aUserID:用户ID
/// 			argOutData json数据
/// Output:     成功：1 失败 -1^失败信息 
/// debug:  	s obj = ##class(%GlobalBinaryStream).%New()     
/// 			q ##Class(EMR.DOC.BL.DocumentTitleDoctor).GetUserDataJson("10209",.obj)
ClassMethod UpTitleDatas(aEpisodeID As %String, aDocumentID As %String, aDoctorID As %String, aDoctorName As %String, aDoctorLevel As %String, aDoctorLevelCode As %String) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aDocumentID="") "-1^文档ID不能为空"
	q:(aDoctorID="")&&(aDoctorLevel="") strRes
	
	s TILDocumentTitleDoctor = ##class(EMR.DAO.DocumentTitleDoctor).GetTureIndexLocation(aEpisodeID)
	s rowID = $o(@TILDocumentTitleDoctor@("IdxDocumentID"," "_aDocumentID,""))
	if (rowID="")
	{
		s objTitleDatas = ##class(EMR.DAO.DocumentTitleDoctor).doCreateInstance(aEpisodeID)
		s objTitleDatas.DocumentID = aDocumentID
		s objTitleDatas.UserID = aDoctorID
		s objTitleDatas.UserName = aDoctorName
		s objTitleDatas.UserLevel = aDoctorLevelCode
		s objTitleDatas.UserLevelDesc = aDoctorLevel
		s sc = objTitleDatas.%Save()
		//保存失败返回0
		s:($$$ISERR(sc)) strRes = "-1^标题选择信息保存失败"
	}
	else
	{
		s objTitleDatas = ##class(EMR.DAO.DocumentTitleDoctor).doOpenByID(aEpisodeID,rowID)
		;s objTitleDatas.DocumentID = aDocumentID
		s objTitleDatas.UserID = aDoctorID
		s objTitleDatas.UserName = aDoctorName
		s objTitleDatas.UserLevel = aDoctorLevelCode
		s objTitleDatas.UserLevelDesc = aDoctorLevel
		s sc = objTitleDatas.%Save()
		//保存失败返回0
		s:($$$ISERR(sc)) strRes = "-1^标题选择信息保存失败"
	}
	q strRes
Error
	q "-1^"_"更新标题选择信息失败:"_$zerror
}

}
