/// 名称:	EMR.DOC.BL.AdmRecordStatus
/// 描述:	取患者病历提交状态
/// 编写者：yejian
/// 编写日期: 2021-7-15
/// 产品组：电子病历产品组
Class EMR.DOC.BL.AdmRecordStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       取患者病历提交状态
/// Creator:    lifengbo
/// Createdate: 2023-04-17
/// Input：     pEpisodeId 就诊ID
/// Debug:      s argOutData = ##class(%GlobalBinaryStream).%New()
/// 			w ##Class(EMR.DOC.BL.AdmRecordStatus).GetAdmRecordStatus(61,.argOutData)
ClassMethod GetAdmRecordStatus(aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream, aLangid As %String = "20") As %DynamicObject
{
  	s ret=-1
  	q:(aEpisodeID = "") ret
  	s $zt="ERROR"
  	
  	s TILAdmRecordStatus = ##Class(EMR.DAO.AdmRecordStatus).GetTureIndexLocation(aEpisodeID)
	s AdmRecordStatusID=""
	s AdmRecordStatusID = $O(@TILAdmRecordStatus@("IdxEpisodeID",aEpisodeID,AdmRecordStatusID))
	if (AdmRecordStatusID = "") 
	{
		q 1
	}
	
  	s objAdmRecordStatus = ##Class(EMR.DAO.AdmRecordStatus).doOpenByID(aEpisodeID,AdmRecordStatusID)
    if (objAdmRecordStatus '= "")
  	{
  		//获取
  		s CompletedStatus = objAdmRecordStatus.CompletedStatus
  		
  		d argOutData.Write(CompletedStatus)
  	}
  	
	q 1
ERROR
	s $zt = ""
	s error = "-500"
	q error
}

/// Desc:       病历操作日志
/// Creator:    lifengbo
/// CreateDate: 2022-4-17
/// Input:      dtoLog 日志对象
/// OutPut:     成功 当前状态，
/// 			失败 -1^失败信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocLog).AddOperateLog("","",.argOutData)
ClassMethod SaveAdmRecordStatus(dtoItem As EMR.DOC.DTO.AdmRecordStatus, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "errhandle"
	s res = "-1"
	q:((dtoItem.EpisodeID = "")) "-1^Episode不能为空"
	s EpisodeID = dtoItem.EpisodeID.%Id()
	q:(EpisodeID = "") "-1^Episode不能为空"
	
	s TILAdmRecordStatus = ##Class(EMR.DAO.AdmRecordStatus).GetTureIndexLocation(EpisodeID)
	s AdmRecordStatusID=""
	s AdmRecordStatusID = $O(@TILAdmRecordStatus@("IdxEpisodeID",aEpisodeID,AdmRecordStatusID))
	if (AdmRecordStatusID = "") 
	{
		q 1
	}
	
	if (AdmRecordStatusID="")
	{
		s objAdmRecordStatus = ##Class(EMR.DAO.AdmRecordStatus).doCreateInstance()
	}
	else
	{
		s objAdmRecordStatus = ##Class(EMR.DAO.AdmRecordStatus).doOpenByID(EpisodeID,AdmRecordStatusID)
	}
	
  	/// 就诊号
  	s objAdmRecordStatus.EpisodeID= dtoItem.EpisodeID

	/// 病历提交状态（1：提交，0：撤销 -1 退回 -2:召回）
  	s objAdmRecordStatus.CompletedStatus= dtoItem.CompletedStatus

	/// 病历全部完成日期
  	s objAdmRecordStatus.FinishDate= +$h

	/// 病历全部完成时间
  	s objAdmRecordStatus.FinishTime= $p($h,",",2)

	/// 病历提交人
  	s objAdmRecordStatus.UserID= dtoItem.UserID

	/// 操作人IP地址
  	s objAdmRecordStatus.IPAddress= dtoItem.IPAddress

	/// 操作产品模块来源
  	s objAdmRecordStatus.ProductSource= dtoItem.ProductSource
  	
  	s sc = objAdmRecordStatus.%Save()
  	if ($$$ISERR(sc))
  	{
		s ret = $system.OBJ.DisplayError(sc) 
		d argOutData.Write(ret)
		q "-1^"_ret
	}
  	q 1
	
errhandle
	q res_"^"_$zerror
}

}
