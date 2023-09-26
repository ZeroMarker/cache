/// Creator:郭荣勇
/// date: 2019-07-17
/// description:MDT系统统一封装接口实现类
Class DHCDoc.Interface.Inside.MDT.ServiceMethod Extends DHCDoc.Util.RegisteredObject
{

ClassMethod FindRBASListExecute(ByRef qHandle As %Binary, AdmLoc As %String, AdmDoc As %String, AmdDateFrom As %String, AdmDateTo As %String, AppMethCode As %String = "", HospitalID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s ^tmpgry("FindRBASListExecute")=AdmLoc_","_AdmDoc_","_AmdDateFrom_","_AdmDateTo_","_AppMethCode
 	s:AppMethCode="" AppMethCode="DOC"
 	//提取可用的资源
 	s ResRowId=+$o(^RB("RES",0,"CTPCP",AdmDoc,AdmLoc,0))
 	if ResRowId'=0  d
 	.f AdmDate=AmdDateFrom:1:AdmDateTo  d
	..s ASSessStartTime="" f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	...s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	....s RESEPMarkFlag=##class(web.DHCRBResource).GetEPMarkFlag(ResRowId)
	....s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	....Q:(status="TR")||(status="PS")
	....Q:(status="S")
	....Q:(status="AUD")
	....s ASRowId=ResRowId_"||"_ASChildSub
	....s ASIrregularFlag=$p($g(^RBAS(ResRowId,ASChildSub)),"^",13)
	....q:(ASIrregularFlag="A")
	....s asApptTotal = $p($g(^RBAS(ResRowId,ASChildSub)),"^",2)
	....q:(+asApptTotal=0)
	....s asqueno=$P(^RBAS(ResRowId,ASChildSub,"DHC"),"^",4)
	....s NormalQueueNoStr=$P(asqueno,$C(1),1)
	....s AddQueueNoStr=$P(asqueno,$C(1),2)
	....s ASDate=$p($g(^RBAS(+ResRowId,ASChildSub)),"^",1)
	....s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	....s TRDesc=""
	....i TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	....s SessStartTime=$p($g(^RBAS(+ResRowId,ASChildSub)),"^",4)
	....s SessEndTime=$p($g(^RBAS(+ResRowId,ASChildSub)),"^",5)
	....s TRange=..%ZT(SessStartTime,2)_"-"_..%ZT(SessEndTime,2)
	....s DocDesc=$P(^CTPCP($P(^RB("RES",+ResRowId),"^",2),1),"^",2)
	....s RoomDR=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
	....s WaitingAddress=$$getWaitingAddress(RoomDR,$p(^RB("RES",ResRowId),"^",1))
	....s rtn=$$getNormalMesage()
	....s AllNum=$P(rtn,"-",1)
	....s Usered=$P(rtn,"-",2)
	....s CanDo=$P(rtn,"-",3)
	....s ASDate=..%ZD(ASDate)
	....d OutMesageFindRBASList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutMesageFindRBASList
	set Data=$lb(ASRowId,TRRowId,TRDesc,ASDate,AllNum,Usered,CanDo,TRange,DocDesc,WaitingAddress)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
getNormalMesage()
	;正号串中预约情况 返回 总数-已用-剩余
	s AllAppNum=0
	s ArriveCount=0,CanDo=0
	for i=1:1:$l(NormalQueueNoStr,",") {
 		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
 		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
 		s QueueNo=$P(SingleQueueNoStr,":",1)
 		s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
 		s AllAppNum=AllAppNum+1
 		s returnallow=##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus,"",HospitalID)
 		if ((QueueNoStatus=0)||(returnallow=0)){
		 	s CanDo=CanDo+1
		}else{
	 		s ArriveCount=ArriveCount+1
	 	}
			 	
	}
	Q:AllAppNum=0 ""
	q AllAppNum_"-"_ArriveCount_"-"_CanDo
getWaitingAddress(RoomDr,DepDr)
	s WaitingAddress=""
	i RoomDr'="" {
		s Room=$p($g(^CTLOC(RoomDr)),"^",2)
		i (Room["-"){
			s Room=$p(Room,"-",2)
		}
		;地址
		s WaitingAddress=$p($g(^CTLOC(RoomDr)),"^",16)
		s RoomNo=$P(WaitingAddress,",",2)
		;取地址必须放在取诊室号后面
		s WaitingAddress=$P(WaitingAddress,",",1)
	}elseif DepDr'=""{
		s WaitingAddress=$p($g(^CTLOC(DepDr)),"^",16)
		s RoomNo=$P(WaitingAddress,",",2)
		;i RoomNo'="" s Room=RoomNo
		;取地址必须放在取诊室号后面
		s WaitingAddress=$P(WaitingAddress,",",1)
	}
	
	Q WaitingAddress
}

ClassMethod OPRegist(PatientID As %String, ASRowId As %String, AdmReason As %String, FeeStr As %String, PayModeCode As %String, UserID As %String, GroupID As %String, LoginLocId As %String, LoginHospId As %String) As %String
{
	s QueueNo=""
	i FeeStr="" s FeeStr="0||0||0||0||0||0"
	s AccRowId=""
	s user=UserID
	s group=GroupID
	s AdmType=""
	s DiagnosCatRowId="",FreeRegFlag="",FreeCheckFlag="",RegfeeRowId="",InsuJoinStr="",DiscountFactor="",APPTRowId=""
	s UnBillFlag="Y"
	s TabPCLRowID="",ApptMethodCode="",SourceType="",RegConDisId="",RegSource="MDT"
	s RegExpStr="^^^MDT"
	s rtn=##class(web.DHCOPAdmReg).OPRegistBroker(PatientID,ASRowId,AdmReason,QueueNo,FeeStr,PayModeCode,AccRowId,user,group,AdmType, DiagnosCatRowId, FreeRegFlag, FreeCheckFlag, RegfeeRowId, InsuJoinStr, DiscountFactor, APPTRowId,UnBillFlag,"","","","",LoginHospId,"","",RegSource,RegExpStr)
	if ($P($G(rtn),"$",1)=0){
		s Jsonstr=$P($G(rtn),"$",2)
		s InputObj={}.%FromJSON(Jsonstr)
		s obj=InputObj.%Get(0)
		s EpisodeID=obj.AdmNo
		s rtn="0$"_EpisodeID
		}
	q rtn
}

ClassMethod ChangeDate(AdmId As %String, OEORIStr As %String, NewRBASId As %String, UserID As %String) As %String
{
	;和使用哪个号源池有关系
	s RegType="NOR",AppMethodCode="WIN"
	;1.更新就诊日期
	;2.更新医嘱日期
	q:(NewRBASId="") "-1^NewRBASId不能为空"
	s NewDate=$p(^RBAS(+NewRBASId,$p(NewRBASId,"||",2)),"^",1)
	s NewTimeRangeDR=$p(^RBAS(+NewRBASId,$p(NewRBASId,"||",2),"DHC"),"^",17)
	s secDesc=""
	TS
	&sql(Update SQLUser.PA_Adm set PAADM_AdmDate=:NewDate where PAADM_RowId=:AdmId)
	i SQLCODE {
		TRO
		Quit SQLCODE_"^更新就诊日期失败,错误描述:"_$g(%mdiag(1))
	}
	s quitOEORI=""
	for i=1:1:$l(OEORIStr,"^") {
		s oneOEORI=$P(OEORIStr,"^",i)
		continue:oneOEORI=""
		&sql(Update SQLUser.OE_OrdItem set OEORI_SttDat=:NewDate where OEORI_RowId=:oneOEORI)
		i SQLCODE s quitOEORI=oneOEORI quit
	}
	i quitOEORI'="" {
		TRO
		Quit SQLCODE_"^更新医嘱(OEORI:"_quitOEORI_")日期失败,错误描述:"_$g(%mdiag(1))
	}
	;处理挂号资源的回归与占用
	s APPTRowIdStr=##class(web.DHCRBAppointment).GetAppByAdm(AdmId)
	s OldAPPTRowId=$p(APPTRowIdStr,"^",1)
	
	s Admi=AdmId
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	s regfeeRBASRowId=$Listget(^User.DHCRegistrationFeeD(RegFeeRowId),18)
	s RegfeeQueueNo=$Listget(^User.DHCRegistrationFeeD(RegFeeRowId),8)
	i regfeeRBASRowId'="" {
		;找改约到的日期的医生出诊记录
		s newRBASId=NewRBASId
		;判断序号是否可用,如果不可用,返回当前可用序号;如果当前无可用序号,需要增加出诊资源限额
		s QueueNo=##class(web.DHCRBAppointment).GetSpecSeqNo(newRBASId,RegfeeQueueNo,RegType,AppMethodCode)
		i QueueNo=0 {
			s QueueNo=##class(web.DHCRBAppointment).GetSeqNo(newRBASId,RegType,"",AppMethodCode)
			i QueueNo=0 {
				Tro
				Quit "-101^当前选择的出诊资源无可用序号,需要增加出诊资源出诊限额."
			}
			s secDesc="原序号为"_RegfeeQueueNo_",改约后的序号变更为:"_QueueNo
		}
		
		;将原资源的占用序号还原到未用状态
		d ##class(web.DHCRBAppointment).RestoreSeqNo(regfeeRBASRowId,RegfeeQueueNo,"0")
		i OldAPPTRowId'="" {
			;1、对于新资源，移植预约数据；2、对于原预约数据，删除预约记录；
			s TransRet=$$TransAppRecode(OldAPPTRowId,newRBASId)
			i TransRet {
				Tro
				Quit "-102^移植预约数据失败,错误描述:"_$g(%mdiag(1))
			}
		}
		;更新挂号表数据
		&sql(Update SQLUser.DHCRegistrationFee set RegfeeRBASDr=:newRBASId,RegfeeNo=:QueueNo,RegfeeTimeRangeDr=:NewTimeRangeDR where ID=:RegFeeRowId)
		i SQLCODE {
			Tro
			Quit "-103^修改DHCRegistrationFee表数据失败,错误描述:"_$g(%mdiag(1))
		}
		;修改对列表数据
		&sql(Update SQLUser.DHCQueue set QueNo=:QueueNo where QuePaadmDr=:AdmId)
		i SQLCODE {
			Tro
			Quit "-104^修改DHCQueue表数据失败,错误描述:"_$g(%mdiag(1))
		}
	}
	TC
	
	quit 0_"^"_secDesc
TransAppRecode(OldAPPTRowId,NewScheduleID)
	K PLIST
	&sql(select * into :PLIST() from SQLUser.RB_Appointment where APPT_RowId=:OldAPPTRowId)
	K PLIST(0),PLIST(1),PLIST(2)
	s PLIST(0)=NewScheduleID
	&sql(Insert into SQLUser.RB_Appointment VALUES :PLIST())
	i 'SQLCODE &sql(delete from SQLUser.RB_Appointment where APPT_RowId=:OldAPPTRowId)
	quit SQLCODE
}

ClassMethod CancelOPRegist(AdmId As %String = "", UserRowId As %String = "", GroupRowId As %String = "", LogonLocRowId As %String = "", ReturnReasonDr As %String = "", LoginHospId As %String = "") As %String
{
	s Admi=AdmId
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	Q:RegFeeRowId="" "notFindRegFeeRowId"
	s NewInvoiceId="",ReturnMR=""
	q ##class(web.DHCOPAdmReg).CancelOPRegist(RegFeeRowId,UserRowId,GroupRowId,LogonLocRowId,NewInvoiceId,"","",LoginHospId)
}

ClassMethod StopOrd(OrdList, UserID, ReasonDr As %String = "", ReasonDesc As %String = "") As %String
{
	s retCode=0
	s PinNum="",PWFlag="N"
	for i=1:1:$l(OrdList,"^") {
		set OrderItemStr=$p(OrdList,"^",i)
		set oeitm=$p(OrderItemStr,"!",1)
		if oeitm="" Continue
		set retCode=##class(appcom.OEOrdItem).Cancel(oeitm,UserID)
		Q:retCode'=0
	}
	q retCode
}

/// 患者当前号别是否收费
/// ##class(DHCDoc.Interface.Inside.MDT.ServiceMethod).CheckForAdmReg(Adm, HospID)
ClassMethod CheckForAdmReg(Adm, HospID)
{
	s OEORDRowId=$O(^OEORD(0,"Adm",Adm,""))
	q:OEORDRowId="" ""
	s OEORIChildsub=0
	s Flag=1
	for {
		s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub))
		Q:OEORIChildsub=""
		S OEORIItmMastDR=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
		s SubType=##Class(web.DHCOPAdmReg).GetRegArcimBillSubType(OEORIItmMastDR,HospID)
		if (SubType'="NotRegFee"){
			s OrdBilled=##class(web.DHCBillInterface).IGetOrdItmBilled(OEORDRowId_"||"_OEORIChildsub)
			s OrdBilledCode=$p(OrdBilled,"^",1)
			s OrdBilled=$p(OrdBilled,"^",2)
			if (OrdBilled="未收费") {
				s Flag=0
			}
		}
	}
	q Flag
}

}
