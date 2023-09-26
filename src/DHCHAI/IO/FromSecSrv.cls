/// 名称: DHCHAI.IO.FromSecSrv
/// 描述: 关于涉密医院的相关操作
/// 编写者：jiangpengpeng
/// 编写日期: 2015-01-23
Class DHCHAI.IO.FromSecSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-01-23
/// Description:  获取病人列表中最高密级
/// Table：       User.DHCSecretLevel
/// Input：       aPatientIDs : 病人ID串
///               aSeparete ：分隔符
/// Return：      密级代码 或 空
/// w ##class(DHCHAI.IO.FromSecSrv).GetMaxSecLevel("")
ClassMethod GetMaxSecLevel(aPatientIDs As %String, aSeparete As %String) As %String
{
	New (aPatientIDs,aSeparete)
	Set return=""
	Quit:(aPatientIDs="")||(aSeparete="") return
	Set MaxSecCode=""
	For ind=1:1:$l(aPatientIDs,aSeparete) {
		Set PatientID=$p(aPatientIDs,aSeparete,ind)
		Continue:PatientID=""
		Set SecretStr=..GetPatEncryptLevel(PatientID,.ErrMsg)
		Continue:SecretStr=""
		Set tmpSecretCode=+$p(SecretStr,"^",3)
		Set:tmpSecretCode>MaxSecCode MaxSecCode=tmpSecretCode
	}
	Set return=MaxSecCode
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-01-23
/// Description:  根据EpisodeID取病人密级信息
/// Table：       User.DHCSecretLevel
/// Input：       EpisodeID
/// Return：      密级信息 或 空
/// w ##class(DHCHAI.IO.FromSecSrv).GetSecInfoByEpisodeID("")
ClassMethod GetSecInfoByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Set SecretStr=..GetPatEncryptLevel(PatientID,.ErrMsg)
	Set return=SecretStr
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-01-23
/// Description:  判断是否涉密项目
/// Table：       ^DHCMed.SS.SecretC
/// Input：       HospitalID : 医院ID
/// Return：      1 或 0
/// w ##class(DHCHAI.IO.FromSecSrv).CheckIsSecret()
ClassMethod CheckIsSecret(aHospitalID As %String = "") As %String
{
	New (aHospitalID)
	Set return=0
	Quit:aHospitalID="" return
	Set return=+$g(^DHCMed.SS.SecretC)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-23
/// Description:  根据PatientID取病人密级信息
/// Table：       User.DHCSecretLevel
/// Input：       PatientID : 病人ID
/// Return：      密级信息 或 空
/// w ##class(DHCHAI.IO.FromSecSrv).GetPatEncryptLevel()
ClassMethod GetPatEncryptLevel(aPatientID As %String, ByRef ErrMsg As %String) As %String
{
	New (aPatientID,ErrMsg)
	Set $ZT="DHCWMRGetPatEncryptLevelErr"
	Set return=##Class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(aPatientID,.ErrMsg)
	Quit return
DHCWMRGetPatEncryptLevelErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2015-01-23
/// Description:  记录事件日志
/// Table：       DHCEventLog
/// Input：       
/// Return：      密级信息 或 空
/// w ##class(DHCHAI.IO.FromSecSrv).EventLog()
ClassMethod EventLog(ModelName, Condition, Content, SecretCode, Success As %String = "Y", UserId = "", IP = "", Mac = "", CName = "", LocId = "", GroupId = "") As %String
{
	Set $ZT="DHCWMREventLogErr"
	Set return=##Class(web.DHCEventLog).EventLog(ModelName, Condition, Content, SecretCode, Success, UserId, IP, Mac, CName, LocId, GroupId)
	Quit return
DHCWMREventLogErr
	Quit ""
}

}
