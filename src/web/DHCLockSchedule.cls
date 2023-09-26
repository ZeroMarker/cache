Class web.DHCLockSchedule Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// /锁号占用时间 
Parameter LockScheduleTime = 600;

/// 统计占号未缴费的订单数  用于控制单个人挂号的限额
/// w ##class(web.DHCLockSchedule).GetPADayLockCount(11,"499||2009")
ClassMethod GetPADayLockCount(PatientID As %String, ASRowId As %String, HospitalId As %String = "") As %String
{
	n (PatientID,ASRowId,HospitalId)
	if HospitalId=""{
		S HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode("",ASRowId) 	
	}
	s LockScheduleTime=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime",HospitalId))
	s:LockScheduleTime=0 LockScheduleTime=..#LockScheduleTime
	q:(PatientID="")||(ASRowId="") ""
	s ResRowId=+ASRowId
	Q:(ResRowId="")||'$D(^RB("RES",ResRowId)) ""
	s CTLocRowId=$P(^RB("RES",ResRowId),"^",1)
	s CTPCPRowId=$P(^RB("RES",ResRowId),"^",2)
	s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1)
	s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	Q:PatientNo="" ""
	s LockCount=0,LockDocCount=0,LockSameASCount=0
	s Schedule="" f  s Schedule=$o(^CTLS(0,"PatNoSchedule",PatientNo,Schedule)) q:Schedule=""  d
	.Q:(+Schedule="")||('$D(^RB("RES",+Schedule)))
	.s RBASStatus=$P($g(^RBAS(+Schedule,$P(Schedule,"||",2),"DHC")),"^",10)
	.s:RBASStatus'="" RBASStatus=$P(^DHCRBCASStatus(RBASStatus),"^",1)
	.Q:(RBASStatus="S")||(RBASStatus="TR")
	.s DepRowId=$P(^RB("RES",+Schedule),"^",1)
	.s DocRowId=$P(^RB("RES",+Schedule),"^",2)
	.s ScheduleDate=$P($G(^RBAS(+Schedule,$P(Schedule,"||",2))),"^",1)
	.s CTLSRowID="" f  s CTLSRowID=$o(^CTLS(0,"PatNoSchedule",PatientNo,Schedule,CTLSRowID)) q:CTLSRowID=""  d
	..Q:'$d(^CTLS(CTLSRowID))
	..s Activity=$p(^CTLS(CTLSRowID),"^",7)
	..Q:Activity'="Y"
	..s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
	..q:HISAdmDr'=""
	..s LockCount=LockCount+1
	..i (ScheduleDate=ASDate)&&(DepRowId=CTLocRowId)&&(CTPCPRowId=DocRowId) s LockDocCount=LockDocCount+1   //同一个医生
	..i (+ASRowId=+Schedule)  d
	...s UpdateDate=$p(^CTLS(CTLSRowID),"^",4)
	...s UpdateTime=$p(^CTLS(CTLSRowID),"^",5)
	...;过期的订单处理
	...i (UpdateDate<+$H)||((UpdateDate=..%SysDate())&&((..%SysTime()-UpdateTime)>LockScheduleTime))  d
	....s ret=..DisableLockSchedule(CTLSRowID,"N")
	...e  d
	....s LockSameASCount=LockSameASCount+1
	q LockCount_"^"_LockDocCount_"^"_LockSameASCount
}

/// 每次挂号时自动检测订单表里订单,UnLockQueueNo 不为空时为取消单独订单
/// 规则:1.停诊替诊的排班 置 ActiveFlag 为否 
///      2.超时的订单直接删除,并把所占号回归
/// d ##class(web.DHCLockSchedule).UnLockSchedule("481||1160","0000000008","1")
ClassMethod UnLockSchedule(Schedule As %String, PatientNo As %String = "", UnLockQueueNo As %String = "", HospitalId As %String = "", TransactionId As %String = "") As %String
{
	n (Schedule,PatientNo,UnLockQueueNo,HospitalId,TransactionId)
	q:Schedule="" 0
	if HospitalId=""{
		S HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode("",Schedule) 	
	}
	s RBASStatus=$P(^RBAS(+Schedule,$P(Schedule,"||",2),"DHC"),"^",10)
	s:RBASStatus'="" RBASStatus=$P(^DHCRBCASStatus(RBASStatus),"^",1)
	if (PatientNo=""){
		//系统发起过期锁号查询
		for {
			s PatientNo=$o(^CTLS(0,"SchedulePatNo",Schedule,PatientNo))
			Q:PatientNo=""
			s CTLSRowID="" 
			for {
				s CTLSRowID=$o(^CTLS(0,"SchedulePatNo",Schedule,PatientNo,CTLSRowID))
				Q:CTLSRowID=""
				continue:'$D(^CTLS(CTLSRowID))
				d ..UnLockOneOrder(CTLSRowID,HospitalId)
			}
		}
	}elseif TransactionId'=""{
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
		if CTLSRowID'=""{
			s ret=..DisableLockSchedule(CTLSRowID,"N","P")
		}	
	}elseif ((PatientNo'="")&&(UnLockQueueNo'="")){
		//病人主动发起取消锁号
		s RowID=""
		for{
			s RowID=$o(^CTLS(0,"Schedule1",Schedule,UnLockQueueNo,RowID)) q:RowID=""
			s CTLPatNo=$p(^CTLS(RowID),"^",1)
			continue:PatientNo'=CTLPatNo
			s HISAdmDr=$p(^CTLS(RowID),"^",9)
			continue:HISAdmDr'=""
			s ret=..DisableLockSchedule(RowID,"N","P")
		}
	}
	q 0
}

ClassMethod UnLockOneOrder(CTLSRowID As %String, HospitalId As %String = "") As %String
{
	n (CTLSRowID,HospitalId)
	q:(CTLSRowID="")||'$D(^CTLS(CTLSRowID)) 0
	s Schedule=$p(^CTLS(CTLSRowID),"^",2)
	if HospitalId=""{
		S HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode("",Schedule) 	
	}
	
	s LockScheduleTime=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime",HospitalId))
	s:LockScheduleTime=0 LockScheduleTime=..#LockScheduleTime
	
	s Activity=$p(^CTLS(CTLSRowID),"^",7)
	Q:Activity'="Y" 0
	s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
	q:HISAdmDr'="" 0 //已付费的订单不做处理
	
	s LockQueueNo=$p(^CTLS(CTLSRowID),"^",3)
	s UpdateDate=$p(^CTLS(CTLSRowID),"^",4)
	s UpdateTime=$p(^CTLS(CTLSRowID),"^",5)
	
	//使用统一判断接口
	s rtn=..CanRemoveLockByID(CTLSRowID)
	if rtn="Y"  d
	.s ret=..DisableLockSchedule(CTLSRowID,"N")
	/*
	;过期的订单处理
	i (UpdateDate<+$H)||((UpdateDate=..%SysDate())&&((..%SysTime()-UpdateTime)>LockScheduleTime))  d
	.;未支付的订单CT_ActiveFlag置为N,把所占号回归
	.;ps 2015-05-19注，锁号不改变顺序号状态，只插入锁表记录
	.;d ##class(web.DHCRBAppointment).RestoreSeqNo(Schedule,LockQueueNo,0,"")
	.s ret=..DisableLockSchedule(CTLSRowID,"N")
	*/
	q 0
}

// 当前锁号状态是否有效：1表示该号可用,这个锁号已经被解锁，0表示该号不可用，有人已经占了这个号

/// d ##Class(web.DHCLockSchedule).GetLockActive("499||2009",1)
ClassMethod GetLockActive(ScheduleItemCode As %String, LockQueueNo As %String, PatientNo As %String = "") As %String
{
	;s ActiveTimeRange=..#LockScheduleTime
	s ActiveTimeRange=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime"))
	s:ActiveTimeRange=0 ActiveTimeRange=..#LockScheduleTime
	
	;初始变量,默认号可用
	s ActiveFlag=0
	if ($d(^CTLS(0,"Data",ScheduleItemCode,LockQueueNo))){
		s Data=..%SysDate()-1
		for {
			s Data=$o(^CTLS(0,"Data",ScheduleItemCode,LockQueueNo,Data)) q:Data=""
			s RowID=""
			for {
				s RowID=$o(^CTLS(0,"Data",ScheduleItemCode,LockQueueNo,Data,RowID)) q:RowID=""
				s Active=$p(^CTLS(RowID),"^",7)
				continue:Active'="Y"
				s ActiveFlag=$$GetLockActiveAndDisable(RowID)
				b
				;1.ActiveFlag=0表示这个号没人用了,可以被其他人使用
				;2.如果这个号有人用，但是就是本人用的,可视为本人可用
				s myPatientNo=$p($g(^CTLS(RowID)),"^",1)
				if (PatientNo'="")&&(PatientNo=myPatientNo) s ActiveFlag=0
			}
		}
	}
	
	;返回值和ActiveFlag变量的含义相反,此处做转换
	if ActiveFlag=0 q 1
	else  q 0
GetLockActiveAndDisable(RowID)
	s UpdateData=+$p(^CTLS(RowID),"^",4)
	s UpdateTime=+$p(^CTLS(RowID),"^",5)
	s Data=..%SysDate()
	s Time=+..%SysTime()
	s HISAdmDr=$p(^CTLS(RowID),"^",9)
	;q:HISAdmDr'="" 1	//已付费的订单	
	s HISAdmDr=$p(^CTLS(RowID),"^",9)
	if (HISAdmDr'=""){
		s VisitStatus=$P($G(^PAADM(HISAdmDr)),"^",20)
		if (VisitStatus'="C"){
			q 1
		}
	}else{
		//有人占了 有效
		//改为按照有效的解锁时间来看是否可以解锁
		//q:((+Data=+UpdateData)&&(Time<(UpdateTime+ActiveTimeRange))) 1
		s RemoveLockFlag=..CanRemoveLockByID(RowID)
		Q:RemoveLockFlag'="Y" "1"
		//置无效
		s ret=..DisableLockSchedule(RowID,"N","D")
	}
	q 0
}

ClassMethod DisableLockSchedule(RowID As %String, ActiveFlag As %String, UpdateType As %String = "") As %String
{
	s ret=0
	if (ActiveFlag'="N"){
		s CurrentDate=$zd(+$h,3)
		s CurrentTime=..%ZT(..%SysTime())
		s TradNo=$p($g(^CTLS(RowID)),"^",8)
		s TradDate=$p($g(^CTLS(RowID)),"^",4)
		s TradTime=$p($g(^CTLS(RowID)),"^",5)
		s TradDate=$zd(TradDate,3)
		s TradTime=..%ZT(TradTime)
		s RestoreSchedule=$p(^CTLS(RowID),"^",2)
		s RestoreQueueNo=$p(^CTLS(RowID),"^",3)
		s:TradNo'="" ^TMPLogDisableLock("DisableLockSchedule",TradNo)=TradDate_" "_TradTime_" VS "_CurrentDate_" "_CurrentTime
		d:RestoreQueueNo'="" ##class(web.DHCRBAppointment).RestoreSeqNo(RestoreSchedule,RestoreQueueNo,0,"")
		&sql(delete from SQLUser.CT_LockSchedule where CT_LSRowID=:RowID)
		s ret=SQLCODE
	}
	if (ActiveFlag="N"){
		s CurrentDate=..%SysDate()
		s CurrentTime=..%SysTime()
		;默认系统更新
		i UpdateType="" s UpdateType="D"
		s myActiveFlag=$p($g(^CTLS(RowID)),"^",7)
		s RestoreSchedule=$p(^CTLS(RowID),"^",2)
		s RestoreQueueNo=$p(^CTLS(RowID),"^",3)
		if myActiveFlag="Y" d
		.d:RestoreQueueNo'="" ##class(web.DHCRBAppointment).RestoreSeqNo(RestoreSchedule,RestoreQueueNo,0,"")
		.&sql(update SQLUser.CT_LockSchedule set CT_ActiveFlag=:ActiveFlag,CT_LastUpdateDate=:CurrentDate,CT_LastUpdatTime=:CurrentTime,CT_LastUpdatUser=:UpdateType where CT_LSRowID=:RowID)
		.s ret=SQLCODE
	}
	q ret
}

ClassMethod GetAutoRegType(ScheduleItemCode As %String) As %String
{
	n (ScheduleItemCode)
	s ASDate=$P(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2)),"^",1)
	s SessionTypeDr=$p(^RBAS(+ScheduleItemCode,$P(ScheduleItemCode,"||",2),"DHC"),"^",17)
	s SessionTypeDesc="",Desc=""
	i SessionTypeDr'="" s SessionTypeDesc=$P($G(^DHCTimeRange(SessionTypeDr)),"^",2)
	s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(..%SysTime())
	s:TRRowId'="" Desc=$P(^DHCTimeRange(TRRowId),"^",2)
	if ((+ASDate)=(+$h)) {
		/*i ((Desc="上午")&&(SessionTypeDesc="下午")){
			s RegType="NORN"
		}else{
			s RegType="NOR"
		}*/
		s RegType="NOR"
	}elseif((+ASDate)>(+$h)){
		s RegType="APP"
	}
	
	q $g(RegType)
}

/// 判断该号是否可用 1-可用;
/// 	-1-订单不存在；Reg-已被挂；OutActiveTime-超时失效；NotSamePerson-不是本人订单
/// 
/// w ##Class(web.DHCLockSchedule).CheckQueueNoActive("DHC1708081702000016","","","")
ClassMethod CheckQueueNoActive(TransactionId As %String, ScheduleItemCode As %String, LockQueueNo As %String = "", PatientNo As %String = "", HospitalId As %String = "", AddTime As %String = "") As %String
{
	n (TransactionId,ScheduleItemCode,LockQueueNo,PatientNo,HospitalId,AddTime)
	s rtn=1
	q:(TransactionId="") "-100"
	s flag=""
	s ActiveTimeRange=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime"))
	s:ActiveTimeRange=0 ActiveTimeRange=..#LockScheduleTime

	s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
	Q:CTLSRowID="" "-100"
	s LockScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
	s AdmDepId=$P($G(^RB("RES",+LockScheduleItemCode)),"^",1)
	s AdmDepHospId=$p(^CTLOC(AdmDepId),"^",22)
	if (HospitalId'=AdmDepHospId)&&(HospitalId'="") {
		Q "NotCurHosp^"
	}
	s LockQueueNo=$p(^CTLS(CTLSRowID),"^",3)
	s LockPatientNo=$p(^CTLS(CTLSRowID),"^",1)
	Q:(LockScheduleItemCode="") "-101"
	s NoLimitLoadFlag=$p(^RBAS(+LockScheduleItemCode,$p(LockScheduleItemCode,"||",2),"DHC"),"^",31)
	Q:(NoLimitLoadFlag'="Y")&&(LockQueueNo="") "-102"
	
	s UpdateData=+$p(^CTLS(CTLSRowID),"^",4)
	s UpdateTime=+$p(^CTLS(CTLSRowID),"^",5)
	s Data=..%SysDate()
	s Time=+..%SysTime()
	s ActiveFlag=$p(^CTLS(CTLSRowID),"^",7)
	if ActiveFlag'="Y"{
		s rtn="OutActiveTime"
	}else{
		s HISAdmDr=$p(^CTLS(CTLSRowID),"^",9)
		s VisitStatus=""
		if (HISAdmDr'=""){
			s VisitStatus=$P($G(^PAADM(HISAdmDr)),"^",20)
		}
		if (HISAdmDr'="")&&(VisitStatus="A"){
			s rtn="Reg"
		}else{
			//改为统一验证订单是否有效  Y有效未超时 N无效超时超时
			s rtnActive=..IsActiveLock(CTLSRowID,AddTime)
			if (rtnActive="N"){
				s rtn="OutActiveTime"
			}else{
				s LockPatientNo=$p($g(^CTLS(CTLSRowID)),"^",1)
				if (PatientNo'="")&&(LockPatientNo'=PatientNo) s rtn="NotSamePerson"
			}
		}
	}
	if (rtn=1) {
		s LockPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(LockPatientNo,"U"),0))
		s PatCatDr=$p(^PAPER(LockPatientID,"PER",1),"^",10)
		s DefaultBillType=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
		s DocResValue=##Class(web.DHCOPAdmReg).GetMarkRegFee(LockScheduleItemCode,DefaultBillType,LockPatientID)
		s RegFee=$p(DocResValue,"^",12)
		s CheckupFee=$p(DocResValue,"^",14)
		s OtherFee=((+$p(DocResValue,"^",20))+(+$p(DocResValue,"^",15))+(+$p(DocResValue,"^",18))+(+$p(DocResValue,"^",16)))
		s Fee=((+RegFee)+(+CheckupFee)+(+OtherFee)) //总挂号费
	}
	
	q rtn_"^"_LockScheduleItemCode_"!"_LockQueueNo_"!"_LockPatientNo_"!"_$g(Fee)
}

ClassMethod CheckQueueNoActiveBak(TransactionId As %String, ScheduleItemCode As %String, LockQueueNo As %String = "", PatientNo As %String = "") As %String
{
	n (TransactionId,ScheduleItemCode,LockQueueNo,PatientNo)
	s rtn=1
	q:(TransactionId="")&&((ScheduleItemCode="")!(LockQueueNo="")) 0
	s flag=""
	if (TransactionId'=""){
		s CTLSRowID=$o(^CTLS(0,"HISTradNo",TransactionId,""),-1)
		if CTLSRowID'=""{
			s LockScheduleItemCode=$p(^CTLS(CTLSRowID),"^",2)
			s QueueNo=$p(^CTLS(CTLSRowID),"^",3)
			s LockPatientNo=$p(^CTLS(CTLSRowID),"^",1)
			i LockQueueNo="" s LockQueueNo=QueueNo
			i ScheduleItemCode="" s ScheduleItemCode=LockScheduleItemCode
			i PatientNo="" s PatientNo=LockPatientNo
		}else{
			q "-1"	
		}
	}
	q:((ScheduleItemCode="")!(LockQueueNo="")) 0
	
	s ResRowId=$P(ScheduleItemCode,"||",1)
	s Childsub=$P(ScheduleItemCode,"||",2)
	
	s ActiveTimeRange=+(##class(DHCDoc.Interface.Outside.Config).GetConfigNode("","LockActiveTime"))
	s:ActiveTimeRange=0 ActiveTimeRange=..#LockScheduleTime
	if ($d(^CTLS(0,"Data",ScheduleItemCode,LockQueueNo))){
		s Data=..%SysDate()-1
		s flag=""
		f  s Data=$o(^CTLS(0,"Data",ScheduleItemCode,LockQueueNo,Data)) q:Data=""  d
		.s RowID=""
		.f  s RowID=$o(^CTLS(0,"Data",ScheduleItemCode,LockQueueNo,Data,RowID)) q:RowID=""  d
		..s Active=$p(^CTLS(RowID),"^",7)
		..q:Active'="Y"
		..s ActiveFlag=$$GetQueueNoActive(RowID,PatientNo)
		..q:ActiveFlag=1
		..i ActiveFlag="-1" d
		...s flag="OutActiveTime"
		...d ..DisableLockSchedule(RowID,"N")
		..i ActiveFlag="-2" d
		...s flag="NotSamePerson"
		..s HISAdmDr=$p(^CTLS(RowID),"^",9)
		..i ActiveFlag="-3" d
		...s flag="Reg"
		if (flag'=""){
			s rtn=flag
		}
	}else{
		s rtn="-1"	
	}
	q rtn_"^"_ScheduleItemCode_"!"_LockQueueNo_"!"_PatientNo
GetQueueNoActive(RowID,PatientNo)
	s UpdateData=+$p(^CTLS(RowID),"^",4)
	s UpdateTime=+$p(^CTLS(RowID),"^",5)
	s Data=..%SysDate()
	s Time=+..%SysTime()
	s ActiveFlag=$p(^CTLS(RowID),"^",7)
	;q:ActiveFlag'="Y" -1
	s HISAdmDr=$p(^CTLS(RowID),"^",9)
	s VisitStatus=""
	if (HISAdmDr'=""){
		s VisitStatus=$P($G(^PAADM(HISAdmDr)),"^",20)
	}
	Q:(AdmDr'="")&&(VisitStatus="A") -3
	
	//统一使用超时接口
	s RemoveLockFlag=..CanRemoveLockByID(RowID)
	Q:RemoveLockFlag="Y" -1
	//q:'((+Data=+UpdateData)&&(Time<(UpdateTime+ActiveTimeRange))) -1
	
	s myPatientNo=$p($g(^CTLS(RowID)),"^",1)
	q:(PatientNo'="")&&(myPatientNo'=PatientNo) -2
	q 1
}

/// CreatDate:    2019.05.17
/// Description:  通过,获取排号,进行锁号锁表操作（供对外接口锁号使用 自助机、互联网等）
/// Table:        DHC_RBApptSchedule、CT_LockSchedule
/// Input:   必填项：myPatientID病人id、UserID用户id、ASRowId排班id
///          可为空：LockQueueNo排号、HisTradeNo交易流水(存储锁号表流水)、ASTimeRangeFlag分时段标志(",Y,N")、BeginTime分时段开始时间(hh:mm)、EndTime分时段结束时间(hh:mm)
/// Output:  成功:0^排号,失败:非0^失败原因
/// w ##class(web.DHCLockSchedule).GetSeqNo(11,"499||2009")   
ClassMethod GetSeqNo(myPatientID As %String, UserID As %String, ASRowId As %String, LockQueueNo As %String = "", HisTradeNo As %String = "", ASTimeRangeFlag As %String = "", BeginTime As %String = "", EndTime As %String = "") As %String
{
	n (myPatientID,UserID,ASRowId,LockQueueNo,HisTradeNo,ASTimeRangeFlag,BeginTime,EndTime)
	s ScheduleItemCode=ASRowId
	
	//s GroupID=##class(DHCExternalService.RegInterface.GetRelate).GetGroup(UserID)
	s GroupID=$p($g(^SSU("SSUSR",UserID)),"^",5) 
	S AppRegMethodCode=""
	s AppRegMethodRowID=..GetConfigNode(GroupID,"AppRegMethod")
	if AppRegMethodRowID'="" s AppRegMethodCode=$P(^RBC("APTM",AppRegMethodRowID),"^",1)
	if AppRegMethodCode="" s AppRegMethodCode="WIN"
	
	s RegType=..GetAutoRegType(ScheduleItemCode)
	;是否启用分时段
	s LockUseTimeRangeFlag=+..GetConfigNode(GroupID,"LockUseTimeRange")
	if (LockUseTimeRangeFlag=1){
		if (LockQueueNo="")&&(ASTimeRangeFlag="Y")&&((BeginTime="")!(EndTime="")){
			/*TRO
			d ..SetOutputCode(.OutputObj,"-1001511","该排班存在分时段信息,请选择分时段信息")
			q OutputObj*/
		}
		s AdmitRange=BeginTime_"-"_EndTime
		if (ASTimeRangeFlag="Y")&&(LockQueueNo="")&&(BeginTime'="")&&(EndTime'=""){
			s LockQueueNo=..GetSeqNoByTimeRange(ScheduleItemCode,AdmitRange,AppRegMethodCode)
			if +LockQueueNo=0
			{
    			q "-1001512"_"^"_"该时段号源号已挂完"
			}
		}
	}
    if (LockQueueNo="")
    {
		s LockQueueNo=##class(web.DHCRBAppointment).GetSeqNo(ScheduleItemCode,RegType,AppRegMethodCode)
		if +LockQueueNo=0
		{
			q "-1001513"_"^"_"号已挂完"
		}
    }else{
		s LockQueueNo=##class(web.DHCRBAppointment).GetSpecSeqNo(ScheduleItemCode,LockQueueNo,RegType,AppRegMethodCode)
		if +LockQueueNo=0
		{
			if LockUseTimeRangeFlag=1 q "-1001513"_"^"_"该时段号已挂完"
			else  q "-1001513"_"^"_"该号已被他人支付"
		}    
	}
	//s PatientNo=##class(DHCExternalService.CardInterface.CardManager).PatientIDToNo(myPatientID)
	s PatientNo=$P($g(^PAPER(myPatientID,"PAT",1)),"^",1) // 获取登记号
	s:HisTradeNo="" HisTradeNo=..SetLockTradeNo(PatientNo)
	s CurrData=..%SysDate()
	s CurrTime=..%SysTime()
	&sql(insert into SQLUser.CT_LockSchedule (CT_PatNo,CT_Schedule,CT_LockQueueNo,
				CT_UpdateDate,CT_UpdatTime,CT_UserID,CT_ActiveFlag,CT_HisTradeNo) values (:PatientNo,
				:ScheduleItemCode,:LockQueueNo,:CurrData,:CurrTime,:UserID,'Y',:HisTradeNo))
	if SQLCODE 
	{
		q "-1001514"_"^"_"加号失败,稍后请再次尝试"
	}
	q 0_"^"_LockQueueNo
}

/// Description:  分时段排班获取排号
/// CreatDate:    2019.05.17
/// Table:        RB_ApptSchedule、DHC_RBApptSchedule
/// Input:   
/// Output:
/// w ##class(web.DHCLockSchedule).GetSeqNoByTimeRange("1||18","13:00-13:30","WIN") 
ClassMethod GetSeqNoByTimeRange(RBASId As %String, TimeRange As %String, ApptMethodCode As %String = "", HospitalId As %String = "") As %String
{
	n (RBASId,TimeRange,ApptMethodCode,HospitalId)
	if HospitalId=""{
		s HospitalId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",RBASId,""),"^",1)
	}
	s BeginTime=..%ZT(..%ZTH($p(TimeRange,"-",1)),2)
	s EndTime=..%ZT(..%ZTH($p(TimeRange,"-",2)),2)
	s TimeRange=BeginTime_"-"_EndTime
	s SeqNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s ASQueueNo=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s ASDate=$P(^RBAS(ResRowId,Childsub),"^",1)
	s ReturnAllowRegFlag=##class(web.DHCRBAppointment).GetReturnAllowRegFlag(4)
	s RegType=##CLass(web.DHCLockSchedule).GetAutoRegType(RBASId)
	
	if ApptMethodCode="" s ApptMethodCode="WIN"
	s ApptMethodID=""
	s ApptMethodID=$O(^RBC("APTM",0,"Code",ApptMethodCode,0))
	s LockQueueNo=##class(web.DHCRBAppointment).GetSpecSeqNoNew(RBASId,"",RegType,ApptMethodCode,"N",HospitalId,BeginTime,EndTime)
	
	Q LockQueueNo
	
	s NumStr=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",24)
	s TimeStr=$P($g(^RBAS(ResRowId,Childsub,"DHC")),"^",25)
	
	;退号不释放资源并增号出来的号不在分时段内,接口不会返回这些增的号,需解决
	;如果最大的号大于分时段最后一个序号,则将之后的号放在整个大的分时段内
	;那如果本来就不在分时段里的怎么办?
	;比如一共20个号,只有1-10号是在分时段里,增的号还放到大的时段里?那不是本来不在分时段里的11-20号也搞到分时段里了
	/*s LastASTRRegNum=$p(NumStr,"-",$l(NumStr,"-"))
	s LastASTRRegNumA=LastASTRRegNum+1
	S MaxQueueNO=##class(web.DHCRBResourceRule).GetMaxQueueNO(NormalQueueNoStr)
	if MaxQueueNO>LastASTRRegNum{
		s NumStr=NumStr_","_LastASTRRegNumA_"-"_MaxQueueNO
		s TimeStr=TimeStr_","_$p(TimeStr,"-",1)_"-"_$p(TimeStr,"-",$l(TimeStr,"-"))
	}*/
	if (NumStr="")||(TimeStr="")||(TimeStr'[TimeRange){
		q SeqNo
	}
	s Loction=0
	For i=1:1:$Length(TimeStr,","){
		s OneTimeStr=$p(TimeStr,",",i)
		if (TimeRange=OneTimeStr){
			s Loction=i
			q
		}
	}
	if (+Loction=0){
		q SeqNo
	}
	
	s OneNumStr=$p(NumStr,",",Loction)
	s StartNum=$p(OneNumStr,"-",1)
	s EndNum=$p(OneNumStr,"-",2)
	s AvailFlag=0
	For j=StartNum:1:EndNum
	{
		s LockActiveSeqNo=..GetLockActive(RBASId,j)
		s QueueNoInAppFlag=+(##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,j,ApptMethodID))
		if (LockActiveSeqNo'=0)&&(NormalQueueNoStr[(","_j_":0"))||((ReturnAllowRegFlag'=1)&&(NormalQueueNoStr[(","_j_":4")))
		{
			if ((ASDate=..%SysDate())||((ASDate>+$h)&&(QueueNoInAppFlag=1))){
				s SeqNo=j
				q 
			}
		}
		if (j=StartNum){
			s OneNum=$p($p(NormalQueueNoStr,",",1),":",1)
			s OneStatus=$p($p(NormalQueueNoStr,",",1),":",2)
			if (LockActiveSeqNo'=0)&&((OneStatus=0)||((ReturnAllowRegFlag'=1)&&(OneStatus=4)))&&(j=OneNum)
			{
				if ((ASDate=..%SysDate())||((ASDate>+$h)&&(QueueNoInAppFlag=1))){
					s SeqNo=j
					q 
				}
			}
		}
	}
	q SeqNo
}

/// Description:  获取锁号交易流水
/// CreatDate:    2019.05.17      
/// Input:   
/// Output:
/// w ##class(web.DHCLockSchedule).SetLockTradeNo(11) 
ClassMethod SetLockTradeNo(PatientID As %String)
{
	n (CurrDate,CurrTime,PatientID)
	s HospID=$o(^CT("HOSP",0))
	s HospCode=$p(^CT("HOSP",HospID),"^",1)
	s HospCode="DHC"
	s CurrDate=$e($zd(+$h,8),3,8)
	;s CurrDate=$zd(+$h,8)
	s CurrTime=$tr(..%ZT(..%SysTime(),1),":","")
	s tmp="000000"
	s:$l(PatientID)>6 PatientID=$e(PatientID,$l(PatientID)-5,$l(PatientID))
	s FormatPatientID=$e(tmp,1,$l(tmp)-$l(PatientID))_PatientID
	s rtn=HospCode_FormatPatientID_CurrDate_CurrTime
	q rtn
}

ClassMethod GetConfigNode(NodeValue As %String, NodeName As %String) As %String
{
	Q:NodeName="" ""
	if (NodeName="LockNotAllowAdd")!(NodeName="BarCardType")!(NodeName="LockActiveTime")!(NodeName="SelfAdmReason"){
		Q:'$d(^DHCOPRegConfig("ExternalService",NodeName)) ""
		Q $g(^DHCOPRegConfig("ExternalService",NodeName))
	}else{
		Q:NodeValue="" ""
		Q:'$d(^DHCOPRegConfig("ExternalService",NodeValue,NodeName)) ""
		Q $g(^DHCOPRegConfig("ExternalService",NodeValue,NodeName))
	}
}

/// lxz 在业务发起的时候  进行一个订单有效的验证 并增加业务锁定延长时间防止 解锁业务的并发
/// 证订单是否有效  Y有效未超时 N无效超时超时
/// AddTime "00:00:30" 延迟30秒
ClassMethod IsActiveLock(CTLSRowID, AddTime As %String = "") As %String
{
	n (CTLSRowID,AddTime)
	
	//锁记录被删除无效
	if ($g(^CTLS(CTLSRowID))=""){q "N"}
	
	//进行一个订单的超时验证
	s RemoveLock=##class(web.DHCLockSchedule).CanRemoveLockByID(CTLSRowID)
	if (RemoveLock="Y"){
		d ##class(web.DHCLockSchedule).DisableLockSchedule(CTLSRowID,"N")
		q "N"
	}
	
	//将解锁时间在按照传入时间 推迟（三十秒） 保证在推迟时间内(30秒)内的交易操作时间内不被解锁 在 CanRemoveLockByID 接口中使用
	if AddTime'=""  d
	.s AddLockTime=..%SysTime()+..%ZTH(AddTime)
	.&SQL(Update SQLUser.CT_LockSchedule set Ct_ActiveAddTime=:AddLockTime where CT_LSRowID=:CTLSRowID)
	
	//验证订单是否有效 在设置的时候是否被解锁
	s Activity=$p(^CTLS(CTLSRowID),"^",7)
	
	Q:Activity'="Y" "N"
	
	q "Y"
}

/// lxz 是否可以进行超时解锁
/// Y 可以解锁 N 不可以解锁
ClassMethod CanRemoveLockByID(CTLSRowID) As %String
{
	n (CTLSRowID)
	s UpdateDate=$p(^CTLS(CTLSRowID),"^",4)
	s UpdateTime=$p(^CTLS(CTLSRowID),"^",5)
	s UnLockTime=$p(^CTLS(CTLSRowID),"^",14)
	s CtActiveAddTime=$p(^CTLS(CTLSRowID),"^",15) //操作延迟时间
	if +UnLockTime<0 s UnLockTime=0
	s nowtime=..%SysTime()
	s RemoveFlag=..HaveLockTime(UpdateDate,UpdateTime,UnLockTime)
	if (RemoveFlag="Y"){
		if (CtActiveAddTime'=""){
			Q:CtActiveAddTime>nowtime "N"
		}
	}
	q RemoveFlag
}

/// 获取是否超时 Y 超时可以解锁 N 没有超时不能解锁 
/// Input 锁定日期 锁定时间 锁定时常：例15 即需要锁定15分钟
ClassMethod HaveLockTime(LockDate As %String, LockTime As %String, UnLockTime As %String) As %String
{
	n (LockDate,LockTime,UnLockTime)
	;计算已经锁号占用时间长度 是否可以取消锁号
	s UnLockFlag="N"
	Q:UnLockTime=0 UnLockFlag ;为0表示不解锁
	if UnLockTime="" {
		s UnLockTime=..#LockScheduleTime
		s UnLockTime=$fn((UnLockTime/60),"",2)
	}
	
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	;当日锁号
	if (LockDate=NowDate){
		s LockTime=(NowTime-LockTime) ;计算已经锁号的时间
		s:(LockTime<0) LockTime=0
		s LockTime=$fn(LockTime/60,"",2) ;分钟
		if (LockTime>UnLockTime){
			s UnLockFlag="Y"
		}	
	}
	else
	{
		;跨日
		if (NowDate>LockDate){
			s LockTime=$fn(((..%ZTH("23:59:59")-LockTime)+NowTime)/60,"",2)+((NowDate-LockDate-1)*1440) ;分钟
			if (LockTime>UnLockTime){
				s UnLockFlag="Y"
			}	
		}
	}
	q UnLockFlag
}

}
