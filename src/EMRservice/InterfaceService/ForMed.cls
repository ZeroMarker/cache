Class EMRservice.InterfaceService.ForMed Extends %RegisteredObject
{

/// Desc:传入就诊号AEpisodeID，ADocID(病历展现目录第三层)，ASignType(签名类型)
/// Creator:duan
/// Input:	AEpisodeID : 就诊rowid
/// Return:	1 完成，0 未完成
/// w ##class(EMRservice.InterfaceService.ForMed).isSigned("94","291","chiefCheck")
ClassMethod isSigned(AEpisodeID As %String, ADocID As %String, ASignType As %String) As %String
{
	s hasChecked = 0
	Q:(AEpisodeID=""||ADocID=""||ASignType="") hasChecked
    s EMRNum = ""
    for {
        s EMRNum = $O(^DHCEMRI.EMRSignI("IdxMain", " "_AEpisodeID, " "_ADocID, EMRNum))
        q:(EMRNum = "")
        s id = ""
        for {
            s id = $O(^DHCEMRI.EMRSignI("IdxMain", " "_AEpisodeID, " "_ADocID, EMRNum," "_$zcvt(ASignType,"U"),id))
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

}
