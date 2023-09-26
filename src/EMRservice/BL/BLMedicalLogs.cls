/// Desc:病案首页编目传送数据信息
/// Creator:lina
/// CreatDate:2020-3-4
Class EMRservice.BL.BLMedicalLogs Extends %RegisteredObject
{

/// Desc:   保存编目传送记录
/// Creator:lina
/// Input:  AEpisodeID        就诊号
///         AMedicalDate      编目日期(YY-MM-DD)
///         AMedicalTime      编目时间(HH-MM-SS)
///         AOperateUserID    操作用户ID
///         AOperateUserName  操作用户名称
///         AOperateMachineIP 操作IP地址
/// Return: 1 保存成功，0 保存失败
/// Debug： w ##Class(EMRservice.BL.BLMedicalLogs).SaveSendDataLog("10080","2020-3-4","15:56:26","6","医生01","192.168.2.125")
ClassMethod SaveSendDataLog(AEpisodeID As %String, AMedicalDate As %String, AMedicalTime As %String, AOperateUserID As %String, AOperateUserName As %String, AOperateMachineIP As %String) As %String
{
    s result = "0"
    q:(AEpisodeID = "") result
    s $zt = "Error"
    s obj = ##class(EMRinstance.MedicalLog).%New()
    s obj.EpisodeID = AEpisodeID
    s obj.MedicalDate = $zdh(AMedicalDate,3)
    s obj.MedicalTime = $zth(AMedicalTime)
    s obj.OperateUserID = AOperateUserID
    s obj.OperateUserName = AOperateUserName
    s obj.OperateMachineIP = AOperateMachineIP
    s sc = obj.%Save()
    if ($$$ISOK(sc))
    {

        s result = "1"
    }
    k obj
    q result
     
Error
    q result
}

}
