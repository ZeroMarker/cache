/// Desc:       特殊操作日志
/// Creator:    Candy
/// CreateDate: 2017-8-24
Class EMRservice.BL.BLSpecialLog Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       保存特殊操作日志
/// Creator:    Candy
/// CreateDate: 2017-8-24
/// Input:  	   ADocID 目录结构ID
///            AInstanceID 病历ID
///            AUserID 操作者
///            AIP 操作电脑
///            AAction 动作
/// Output:     result 1 成功 
ClassMethod SetLog(ADocID As %String, AInstanceID As %String, AUserID As %String, AIP As %String, AAction As %String) As %String
{
	s $zt = "Error"	
	s result = ""
	q:(AInstanceID = "")||(AUserID = "") result
	s obj = ##Class(EMRinstance.SpecialLog).%New()
	s obj.DocID = ADocID
	s obj.InstanceID = AInstanceID
	s obj.OperateUserID = AUserID
	s obj.OperateMachineIP = AIP
	s obj.OperateDate = $p($h,",",1)
	s obj.OperateTime = $p($h,",",2)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
Error
   q $zerror
}

}
