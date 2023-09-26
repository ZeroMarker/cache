/// 名称:	EMR.DOC.BL.AdmPatType
/// 描述:	取患者病历提交状态
/// 编写者：lifengbo
/// 编写日期: 2023-04-18
/// 产品组：电子病历产品组
Class EMR.DOC.BL.AdmPatType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加患者类型
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Input:      aDTOItem  患者类型对象
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 						-200 项目缺失
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.IP.BL.BLPatDisease).AddAdmPatTypeJson()
ClassMethod AddAdmPatTypeJson(aDTOItem As EMR.DOC.DTO.AdmPatType, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-102"
	q:((aDTOItem = "")) "-200"
	
	s TILAdmPatType = ##Class(EMR.DAO.AdmPatType).GetTureIndexLocation(aDTOItem.EpisodeID)
	s AdmPatTypeID=""
	s AdmPatTypeID = $O(@TILAdmPatType@("IdxEpisodeID",aDTOItem.EpisodeID,AdmPatTypeID))
	if (AdmPatTypeID = "") 
	{
		s objAdmPatType = ##Class(EMR.DAO.AdmPatType).doOpenByID(aDTOItem.EpisodeID,AdmPatTypeID)
	}
	else
	{
		s objAdmPatType = ##Class(EMR.DAO.AdmPatType).doCreateInstance()
	}
	
	s objAdmPatType.AppointUserID = ##class(User.SSUser).%OpenId(aDTOItem.AppointUserID)
	s objAdmPatType.EMRDOCDiagnosID = ##class(CF.EMR.DOC.Diagnos).%OpenId(aDTOItem.EMRDOCDiagnosID)
	s objAdmPatType.EpisodeID= ##class(User.PAAdm).%OpenId(aDTOItem.EpisodeID)
	s objAdmPatType.PatType = aDTOItem.PatType
	
	s sc = objAdmPatType.%Save()
	if ('$$$ISOK(sc))
	{
		q "-1^"_strRes
	}
	
	q 1
}

/// Desc:	获取患者病种信息
/// Input:	
/// Return:	患者病种信息
/// Debug:	s argOutData = ##class(%GlobalBinaryStream).%New()
/// 			w ##Class(EMR.IP.BL.BLPatDisease).GetPatDiseaseJson(285,.argOutData)
ClassMethod GetPatDiseaseJson(argEpisodeID As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s jsonArr=[]
	
	s TILAdmPatType = ##Class(EMR.DAO.AdmPatType).GetTureIndexLocation(argEpisodeID)
	s AdmPatTypeID=""
	s AdmPatTypeID = $O(@TILAdmPatType@("IdxEpisodeID",argEpisodeID,AdmPatTypeID))
	if (AdmPatTypeID = "") 
	{
		d jsonArr.%ToJSON(argOutData)
		q 1
	}
	
  	s objAdmPatType = ##Class(EMR.DAO.AdmPatType).doOpenByID(argEpisodeID,AdmPatTypeID)

	
	if (objAdmPatType = "") 
	{
		d jsonArr.%ToJSON(argOutData)
		q 1
	}
	
	s json = {}
	s diseaseCode = objAdmPatType.EMRDOCDiagnosID.DiagnosCode
	s diseaseName = objAdmPatType.EMRDOCDiagnosID.DiagnosName
	
	s json.Code = diseaseCode
	s json.Name = diseaseName
	d json.%ToJSON(argOutData)
	d jsonArr.%Push(json)
	
	q 1
}

}
