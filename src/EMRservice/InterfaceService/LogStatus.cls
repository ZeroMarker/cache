Class EMRservice.InterfaceService.LogStatus Extends %RegisteredObject
{

/// Desc:	临床首页是否完成质控医师签名
/// Creator:niucaicai
/// Input:	AEpisodeID : 就诊rowid
/// Return:	1 完成，0 未完成
/// Debug：	w ##Class(EMRservice.InterfaceService.LogStatus).IsClinicFPFQCDocChecked("10080")
ClassMethod IsClinicFPFQCDocChecked(AEpisodeID As %String) As %String
{
	s hasChecked = 0
	
	s fpDocID = ##Class(EMRservice.BOSysOption).GetValueByName("EMRClinicFPDocID")
	q:(fpDocID = "")||(fpDocID = "NULL") hasChecked
	
    s EMRNum = ""
    for {
        s EMRNum = $O(^DHCEMRI.EMRSignI("IdxMain", " "_AEpisodeID, " "_fpDocID, EMRNum))
        q:(EMRNum = "")
        s id = ""
        for {
            s id = $O(^DHCEMRI.EMRSignI("IdxMain", " "_AEpisodeID, " "_fpDocID, EMRNum," QCDOCCHECK",id))
            q:(id = "")
            s obj = ##Class(EMRinstance.EMRSign).%OpenId(id)
            q:(obj = "")
            s:(obj.isSignValid = 1) hasChecked = 1
            q:(hasChecked = 1)
        }
        q:(hasChecked = 1)
    }
	q hasChecked
}

/// Desc:   第一次编目传送日期
///         在前端emr.interface.medical.csy页面上“传送数据”按钮第一次点击的日期时间
/// Creator:lina
/// Input:  AEpisodeID    就诊号
/// Return: medicalDate   第一次编目传送日期(Cache内部格式)
///         medicalTime   第一次编目传送时间(Cache内部格式)
/// Debug： w ##Class(EMRservice.InterfaceService.LogStatus).FirstMedicalDate("10080")
ClassMethod FirstMedicalDate(AEpisodeID As %String) As %String
{
    s result = ""
    q:(AEpisodeID = "") result
    s medicalDate = ""
    s medicalDate = $o(^DHCEMRI.MedicalLogI("IdxEpisodeIDMedicalDateTime"," "_AEpisodeID,medicalDate))
    s medicalTime = ""
    s:(medicalDate '= "") medicalTime = $o(^DHCEMRI.MedicalLogI("IdxEpisodeIDMedicalDateTime"," "_AEpisodeID,medicalDate,medicalTime))
    
    s result = "{""medicalDate"":"""_$tr(medicalDate," ","")_""","
    s result = result_"""medicalTime"":"""_$tr(medicalTime," ","")_"""}"
                
    q result
}

}
