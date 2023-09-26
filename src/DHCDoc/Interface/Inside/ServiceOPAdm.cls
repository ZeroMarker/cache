/// creator:guorongyong
/// date:2020-06-15
/// desc:和东华医为内部系统的接口类【主要是提供给其他产品组的接口】，仅预约挂号系统相关，本类不收录医生站其他产生线与内部的接口
Class DHCDoc.Interface.Inside.ServiceOPAdm Extends DHCDoc.Util.RegisteredObject
{

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  插入就诊记录
/// Table:        PA_Adm
/// Input:        入参：Para
/// Return:       返回值(就诊Rowid; 空 失败)
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOPAdm).ADMInsert
ClassMethod ADMInsert(Para As %String) As %String [ ProcedureBlock = 0 ]
{
	Q ##class(web.DHCPAADM).ADMInsert(Para)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  退号
/// Table:        PA_Adm
/// Input:        itmjs:空,itmjsex:空,RegFeeRowId:对列表ID,UserRowId:用户ID,GroupRowId:安全组ID,LogonLocRowId:科室ID,ReturnMR:是否退病历本,ReturnReasonDr:退号原因
/// Return:       返回值(结果代码^结果描述) 结果代码为0成功,其他为失败
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOPAdm).CancelOPRegistBroker
ClassMethod CancelOPRegistBroker(itmjs As %String = "", itmjsex As %String = "", RegFeeRowId As %Library.String = "", UserRowId As %Library.String, GroupRowId As %String, LogonLocRowId As %String, ReturnMR As %String = "", ReturnReasonDr As %String = "") As %String
{
	Q ##class(web.DHCOPAdmReg).CancelOPRegistBroker(itmjs,itmjsex,RegFeeRowId,UserRowId,GroupRowId,LogonLocRowId,ReturnMR,ReturnReasonDr)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  更新挂号表发票关联
/// Input:        AdmID:就诊ID,InvoiceId:发票ID,OPBilledOrdStr:结算医嘱串(多个以^分割)
/// Return:       返回值(结果代码^结果描述) 结果代码为0成功,其他为失败
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOPAdm).UpdateRegistionFeeInv
ClassMethod UpdateRegistionFeeInv(AdmID As %String, InvoiceId As %String, OPBilledOrdStr As %String) As %String
{
	Q ##class(web.DHCOPAdmReg).UpdateRegistionFeeInv(AdmID,InvoiceId,OPBilledOrdStr)
}

/// Creator:      宋春莉
/// CreatDate:    2020.08.04
/// Description:  获取挂号凭条所有打印信息
/// Table:        
/// Input:        AdmId:就诊RowId
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOPAdm).GetPrintDataJson(AdmId) 
ClassMethod GetPrintDataJson(AdmId As %String) As %String
{
	Q ##class(web.DHCOPAdmReg).GetPrintDataJson(AdmId)
}

/// Creator:      宋春莉
/// CreatDate:    2020.09.16
/// Description:  门诊病历预约信息接口
/// Table:        
/// Input:        EpisodeID:就诊RowId
/// Return:      
/// Others:       w ##class(DHCDoc.Interface.Inside.ServiceOPAdm).GetPatientAppInfo(EpisodeID) 
ClassMethod GetPatientAppInfo(EpisodeID As %String = "") As %String
{
	q:EpisodeID="" ""
	s patientId=$P(^PAADM(EpisodeID),"^",1)
	
	s AppInfo=""
	&SQL(DECLARE OrdCursor CURSOR FOR
 	SELECT APPT_QueueNo,APPT_AS_ParRef into:QueueNo,:ASRowId FROM SQLUser.RB_Appointment WHERE APPT_PAPMI_DR=:patientId AND APPT_Status="I")
 	&SQL(OPEN OrdCursor)
 	For  &SQL(FETCH OrdCursor) QUIT:(SQLCODE)  do
 	.q:ASRowId="" 
	.s ResRowId=$P(ASRowId,"||",1)
	.s ASChildSub=$P(ASRowId,"||",2)
	.;不排除排班被删除的可能,需先判断排班是否存在
	.Q:'$d(^RBAS(+ResRowId,ASChildSub))
	.;根据释放时间自动释放锁表锁号
	.;d ##Class(web.DHCLockSchedule).UnLockSchedule(ASRowId)
	.;排班日期
	.s ASDate=$P(^RBAS(ResRowId,ASChildSub),"^",1)
	.s nowDate=..%SysDate()
	.s days=ASDate-nowDate
	.q:days>=56
	.s docId=$p(^RB("RES",ResRowId),"^",2)
	.s docDesc=$p(^CTPCP(docId,1),"^",2)
	.s locId=$p(^RB("RES",ResRowId),"^",1)
	.s locDesc=$p(^CTLOC(locId),"^",2)
	.s dateInfo=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(ASRowId,QueueNo)
	.i AppInfo="" d
	..s AppInfo=docDesc_","_locDesc_","_dateInfo
	.e  d
	..s AppInfo=AppInfo_"^"_docDesc_","_locDesc_","_dateInfo
}

/// Creator:      李旭
/// CreatDate:    2023.02.17
/// Description:  通过就诊ID判断是否超过限制就诊时间
/// Input:        AdmID:就诊ID、SessionStr:session串
/// Return:       -1/0/1^描述:异常/没有超出/超出^描述
/// Debugger:     w ##class(DHCDoc.Interface.Inside.ServiceOPAdm).CheckAdmLimitDay(69)
ClassMethod CheckAdmLimitDay(AdmID, SessionStr = "") As %String
{
	s $zt="CheckAdmLimitDay"
	
	s Code=0,LimitInfo=""
	;不受就诊有效天数限制
	s NoAdmValidDaysLimit=0	
	s GroupID=$p(SessionStr,"^",2)
	s:GroupID'="" NoAdmValidDaysLimit=..%GetConfig1("NoAdmValidDaysLimit",GroupID)
	s LimitTimeStr=##class(web.DHCDocOrderCommon).GetVisitTimeToDay(AdmID)
    if (+LimitTimeStr'=0)&&(NoAdmValidDaysLimit'=1) {
	    s LimitDesc=$p(LimitTimeStr,"^",2)
	    s LimitDay=$p(LimitTimeStr,"^",3)
	    s LimitInfo=LimitDay_LimitDesc
	    s Code=1
    }
    
	Q Code_"^"_LimitInfo

CheckAdmLimitDay
	s $zt=""
	Q "-1^"_$ze
}

/// desc:	获取门诊就诊队列状态的不同时间点
/// debug:	d ##class(DHCDoc.Interface.Inside.ServiceOPAdm).GetAdmTimeNodes(8206, .pList)
ClassMethod GetAdmTimeNodes(episodeId As %String = "", ByRef pList)
{
	q:episodeId=""
	// 1. 挂号时间
	s regDate = $p($g(^PAADM(episodeId)), "^", 41)
	s regTime = $p($g(^PAADM(episodeId)), "^", 42)
	s regUserId = $p($g(^PAADM(episodeId)), "^", 43)
	s regDateFmt = $zd(regDate, 3)
	s regTimeFmt = $zt(regTime)
	s regUserName = $p($g(^SSU("SSUSR",regUserId)), "^", 2)
	
	s pList("00",regDateFmt,regTimeFmt,1) = regUserName_"^挂号"
	
	// 2.报到时间、复诊时间
	s queId = $o(^User.DHCQueueI("QuePaadmDrIndex",episodeId,0))
	s queStatSub = 0
	k queStatArr
	for {
		s queStatSub = $o(^DHCQueueStatus(queId, queStatSub))
		q:queStatSub=""
		s queStatDate = $p($g(^DHCQueueStatus(queId,queStatSub)), "^", 1)
		s queStatTime = $p($g(^DHCQueueStatus(queId,queStatSub)), "^", 2)
		s queStatDocId = $p($g(^DHCQueueStatus(queId,queStatSub)), "^", 3)
		s queStatStatusId = $p($g(^DHCQueueStatus(queId,queStatSub)), "^", 4)
		s queStatUserId = $p($g(^DHCQueueStatus(queId,queStatSub)), "^", 5)
		s queStatDateFmt = $zd(queStatDate, 3)
		s queStatTimeFmt = $zt(queStatTime)
		s queStatUserName = ""
		if (+queStatUserId '= 0) {
			s queStatUserName = $p($g(^SSU("SSUSR",queStatUserId)), "^", 2)
		}
		// 等候(诊区不需要报道的是否显示报到时间)
		if (queStatStatusId = 2)&&(queStatSub>1) {
			s pList("02",queStatDateFmt,queStatTimeFmt,$i(queStatArr(queStatStatusId))) = queStatUserName_"^报到"
		}
		// 过号
		if (queStatStatusId = 3) {
			s pList("03",queStatDateFmt,queStatTimeFmt,$i(queStatArr(queStatStatusId))) = queStatUserName_"^过号"
		}
		// 到达
		if (queStatStatusId = 4) {
			s pList("04",queStatDateFmt,queStatTimeFmt,$i(queStatArr(queStatStatusId))) = queStatUserName_"^到达"
		}
		// 退号
		if (queStatStatusId = 5) {
			s pList("05",queStatDateFmt,queStatTimeFmt,$i(queStatArr(queStatStatusId))) = queStatUserName_"^退号"
		}
		// 复诊
		if (queStatStatusId = 1) {
			s pList("01",queStatDateFmt,queStatTimeFmt,$i(queStatArr(queStatStatusId))) = queStatUserName_"^复诊"
		}
	}
}

}
