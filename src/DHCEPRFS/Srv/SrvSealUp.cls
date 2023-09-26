Class DHCEPRFS.Srv.SrvSealUp Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvSealUp";

/// Desc:  获得患者基本信息
/// Creator:liushuang
/// CreateDate:2016-10-13
/// Input:AAdmNo：就诊号、ARegNo：登记号、AName：姓名、AMedRecordID：病案号  
/// OutPut：患者基本就诊信息
ClassMethod GetPatientInfo(AAdmNo As %String, ARegNo As %String, AName As %String, AMedRecordID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AName = $c(0)) AName = ""
	s:(AMedRecordID = $c(0)) AMedRecordID = ""
	s:(AAdmNo = $c(0)) AAdmNo = ""
	s:(ARegNo = $c(0)) ARegNo = ""
	s param = "^"_AName_"^"_AMedRecordID_"^"_AAdmNo_"^"_ARegNo
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.HISInfo.BLEpisodeInfo:GetEpisodeList")
	d obj.SetArgs(param)
	q obj
}

/// Desc:  封存病历
/// Creator:liushuang
/// CreateDate:2016-10-13
/// Input:AEpisodeID：就诊号、ADoc：主治医生、ARemarks：备注、APatientAgent：患者代理人、ARelationship：代理人关系、AMedDepartment：医务处医生、AAgentPhone：代理人电话、APatientName：患者姓名、APatientPhone：患者电话、AVersionNum:封存版本号
/// OutPut：封存结果："-1"、"-2"、"-3"、"-9"表示封存失败，其他为正确
ClassMethod SealUpByAdm(AEpisodeID As %String, ADoc As %String, ARemarks As %String, APatientAgent As %String, ARelationship As %String, AMedDepartment As %String, AAgentPhone As %String, APatientName As %String, APatientPhone As %String, AVersionNum As %String) As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s:(ADoc = $c(0)) ADoc = ""
	s:(ARemarks = $c(0)) ARemarks = ""
	s:(APatientAgent = $c(0)) APatientAgent = ""
	s:(ARelationship = $c(0)) ARelationship = ""
	s:(AMedDepartment = $c(0)) AMedDepartment = ""
	s:(AAgentPhone = $c(0)) AAgentPhone = ""
	s:(APatientName = $c(0)) APatientName = ""
	s:(APatientPhone = $c(0)) APatientPhone = ""
	s:(AVersionNum = $c(0)) AVersionNum = ""
	s AVersionNum = +AVersionNum
	s ret = ##Class(DHCEPRFS.BL.BLSealUp).RegSealUpByAdm(AEpisodeID,ADoc,ARemarks,APatientAgent,ARelationship,AMedDepartment,AAgentPhone,APatientName,APatientPhone,AVersionNum)
	q ret
}

/// Desc:  根据就诊号获取封存信息
/// Creator:liushuang
/// CreateDate:2016-10-13
/// Input:AEpisodeID：就诊号
/// OutPut：患者封存信息
ClassMethod GetSealInfo(AEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID,"DHC")
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLSealUp:GetSealListByAdm")
	d obj.SetArgs(mrEpisodeID)
	q obj
}

/// Desc:  获取医生列表
/// Creator:liushuang
/// CreateDate:2016-10-13
/// OutPut：医生列表
ClassMethod GetDocList() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQueryUser:GetUsers")
	d obj.SetArgs("HIS")
	q obj
}

/// Desc:  通过就诊号得到封存的最后一次版本号（入参EpisodeID）
/// Creator:liushuang
/// CreateDate:2016-10-19
/// OutPut：最新的版本号
ClassMethod GetVersionNum(AEpisodeID As %String) As %Integer [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s ret = ##Class(DHCEPRFS.BL.BLSealUp).GetVersionNum(AEpisodeID)
	q ret
}

/// Desc:  通过就诊号得到是否有孩子（入参EpisodeID）
/// Creator:liushuang
/// CreateDate:2016-10-24
/// OutPut：是否存在孩子
ClassMethod CheckchildEpisodeID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s ret = ##Class(DHCEPRFS.BL.BLSealUp).CheckchildEpisodeID(AEpisodeID)
	q ret
}

/// Desc:  通过就诊号解封
/// Creator:yangpeng
/// CreateDate:2021-5-16
/// OutPut：返回1 成功，0 失败
ClassMethod UnSealByAdm(AEpisodeID, AUnSealUserID) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLSealUp).UnSealByAdm(AEpisodeID,AUnSealUserID)
	q ret
}

}
