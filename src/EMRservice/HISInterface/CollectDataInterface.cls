Class EMRservice.HISInterface.CollectDataInterface Extends %RegisteredObject
{

/// Desc:非就诊当日修改门诊电子病历后，保病历存时调用科研大数据组待数据采集接口
/// 接口:##class(User.PendingAdmList).Insert(parAdmID,parAdmType,parUpdateDate,parUpdateTime)
/// 接口入参数说明：均不能为空 parAdmID 就诊号 parAdmType 就诊类型，"I"为住院，"O"为门诊 parUpdateDate 提交（变更）日期，数字形式 parUpdateTime 提交（变更）时间，数字形式 
/// Input: AparAdmID 就诊号
/// d ##Class(EMRservice.HISInterface.CollectDataInterface).CollectDataBySave("11185363")
ClassMethod CollectDataBySave(AparAdmID As %String)
{
	q:(AparAdmID = "")
	//获取系统参数IsCollectData，判断是否开启此功能
	s isCollectData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsCollectData","N")
	q:(isCollectData = "N")
	s parAdmType = $ZCVT($p($G(^PAADM(AparAdmID)),"^",2),"U")
	q:(parAdmType '= "O")
	
	s parUpdateDate = $p($h,",",1)
	s parUpdateTime = $p($h,",",2)
	s admDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AparAdmID)
	q:(admDateTime = "")
	s admDate = $p(admDateTime,",",1)
	//门诊电子病历修改日期与就诊日期相差一天才调用接口
	q:(parUpdateDate - admDate < 1)
	
	if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCCSM.EMR.PendingAdmList||Insert") '= "0") {
		d ##class(web.DHCCSM.EMR.PendingAdmList).Insert(AparAdmID,parAdmType,parUpdateDate,parUpdateTime)
	}
}

/// Desc:住院病历点击提交按钮后，调用科研大数据组待数据采集接口
/// 接口:##class(User.PendingAdmList).Insert(parAdmID,parAdmType,parUpdateDate,parUpdateTime)
/// 接口入参数说明：均不能为空 parAdmID 就诊号 parAdmType 就诊类型，"I"为住院，"O"为门诊 parUpdateDate 提交（变更）日期，数字形式 parUpdateTime 提交（变更）时间，数字形式 
/// Input: AparAdmID 就诊号
/// d ##Class(EMRservice.HISInterface.CollectDataInterface).CollectDataBySave("11185363")
ClassMethod CollectDataByComplete(AparAdmID As %String)
{
	q:(AparAdmID = "")
	//获取系统参数IsCollectData，判断是否开启此功能
	s isCollectData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsCollectData","N")
	q:(isCollectData = "N")
	s parAdmType = $ZCVT($p($G(^PAADM(AparAdmID)),"^",2),"U")
	s parUpdateDate = $p($h,",",1)
	s parUpdateTime = $p($h,",",2)
	if (##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCCSM.EMR.PendingAdmList||Insert") '= "0") {
		d ##class(web.DHCCSM.EMR.PendingAdmList).Insert(AparAdmID,parAdmType,parUpdateDate,parUpdateTime)
	}
	q
}

}
