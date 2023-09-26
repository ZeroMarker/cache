Class EMRservice.BL.BLAdmMRecordStatusLog Extends %RegisteredObject
{

///  Desc:       添加病历全部完成信息操作日志表数据
///  Input:      AUserID：操作人  AAction：操作动作  ARecordStatusID：EMRinstance.AdmRecordStatus的ID
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatusLog).AddData("230","","")
ClassMethod AddData(AUserID As %String, AAction As %String, ARecordStatusID As %String) As %String
{
	s result = "0"
	q:(AUserID = "")||(AAction = "")||(ARecordStatusID = "") result
	s objLog = ##Class(EMRinstance.AdmMRecordStaLog).%New()
	s objLog.UserID = AUserID
	s objLog.Action = AAction 
	s objLog.RecordStatusID = ARecordStatusID
    s objLog.OperateDate = $p($h,",",1)
    s objLog.OperateTime = $p($h,",",2)
    s sc = objLog.%Save()
    if ($$$ISOK(sc))
    {
	    s result = "1"
    }
    d objLog.%Close()	
	k objLog
	q result
}

}
