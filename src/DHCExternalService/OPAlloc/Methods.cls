Class DHCExternalService.OPAlloc.Methods Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// w ##class(DHCExternalService.OPAlloc.Methods).GetPatInfo("")
ClassMethod GetPatInfo(XMLRequest As %String) As %Stream.GlobalCharacter
{
	s ^TMPSelfRegXML("Request","GetPatInfo")=XMLRequest
	;s XMLRequest="<Request><TradeCode>3300</TradeCode><TransactionId></TransactionId><ExtOrgCode></ExtOrgCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID></ExtUserID><PatientCard></PatientCard><CardType></CardType><PatientID></PatientID><Phone></Phone><IDCardType></IDCardType><IDNo>370285199106144416</IDNo><PatientName>nk</PatientName></Request>"
	s $ZTRAP="GetPatInfoErr"
	s OutputStream=##class(%Stream.GlobalCharacter).%New()
	set flag=##class(%Dictionary.MethodDefinition).%ExistsId("DHCExternalService.RegInterface.SelfRegMethods"_"||"_"GetPatInfo")
 	if (flag=1){
	 	s RetObj=##class(DHCExternalService.RegInterface.SelfRegMethods).GetPatInfo(XMLRequest)
	 	d RetObj.XMLExportToStream(.OutputStream,"Response")
	 	Q OutputStream
 	}
 	Q OutputStream
GetPatInfoErr
	s OutputStream=##class(%Stream.GlobalCharacter).%New()
	s OutputObj=##class(DHCExternalService.OPAlloc.Entity.GetPatInfoRp).%New()
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="GetPatInfo调用异常"_$ZERROR
	d OutputObj.XMLExportToStream(.OutputStream,"Response")
	Q OutputStream
}

/// w ##class(DHCExternalService.RegInterface.SelfRegMethods).QueryAdmOPReg(";<Request><TradeCode>1300</TradeCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID>hs01</ExtUserID><CardType></CardType><PatientCard></PatientCard><PatientID>0000000446</PatientID><ZoneID></ZoneID><AdmNo></AdmNo></Request>")
ClassMethod GetOPAllocReport(XMLRequest As %String) As %Stream.GlobalCharacter
{
	;<Request><TradeCode>1300</TradeCode><ClientType></ClientType><TerminalID></TerminalID><HospitalId></HospitalId><ExtUserID>hs01</ExtUserID><CardType></CardType><PatientCard></PatientCard><PatientID>0000000446</PatientID><ZoneID></ZoneID><AdmNo></AdmNo></Request>
	s $ZTRAP="GetOPAllocReportErr"
	s InputObj=##class(DHCExternalService.OPAlloc.Entity.GetOPAllocReportRq).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	s PatientNo=InputObj.PatientID
	s CardType=InputObj.CardType
	s PatientCard=InputObj.PatientCard
	s ExtUserID=InputObj.ExtUserID
	s MachineID=InputObj.MachineID
	s ZoneID=InputObj.ZoneID
	s AdmNo=InputObj.AdmNo
	s HospitalId=InputObj.HospitalId
	
	s OutputObj=##class(DHCExternalService.OPAlloc.Entity.GetOPAllocReportRp).%New()
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.OPAlloc.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
		d ..SetOutputCode(.OutputObj,"-130001","此自助机对应操作员未配置HIS系统用户")
		q OutputObj
	}
	
	if (PatientCard="")&&(PatientNo="") {
		d ..SetOutputCode(.OutputObj,"-130002","卡号和患者ID号不能同时为空")
		q OutputObj
	}
	s GroupID=##class(DHCExternalService.OPAlloc.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.OPAlloc.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	s myPatientID=""
	if PatientNo'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}else{
		if PatientCard'=""{
			s CFRowid=0
			for {
				s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
				s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
				Continue:CFActive'="N"
				s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
				Continue:(CardType'="")&(CardType'=CFCardTypeDR)
				s myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
			}
		}
	}
	
	if myPatientID="" {
		d ..SetOutputCode(.OutputObj,"-130003","病人记录在系统中不存在")
		q OutputObj
	}
	
	s myPatientNo=$p(^PAPER(myPatientID,"PAT",1),"^",2)
	
	s ExaBorStr=""
	s ExaBorID=0
	for {
		s ExaBorID=$O(^User.DHCBorUserI("BoruUseDrIndex"," "_UserID,ExaBorID))
		Q:ExaBorID=""
		s BoruBorDr=$List(^User.DHCBorUserD(ExaBorID),2)
		continue:BoruBorDr=""
		i ExaBorStr="" {
			s ExaBorStr=BoruBorDr
		}else{
			s ExaBorStr=ExaBorStr_"^"_BoruBorDr
		}
	}
	if ExaBorStr="" {
		d ..SetOutputCode(.OutputObj,"-130004","此自助机对应操作员没有任何诊区分诊权限")
		q OutputObj
	}
	
	;仅能检索当天的队列记录，非当天的也不允许报到
	s SearchDate=..%SysDate()
	Set RecordCount=0
	s QueDr=0
	for {
		s QueDr=$o(^User.DHCQueueI("QuePersonIdIndex"," "_myPatientNo,QueDr)) 
		q:(QueDr="")
		s QuePersonId=$List(^User.DHCQueueD(QueDr),12)
		s QueDate=$List(^User.DHCQueueD(QueDr),3)
	    continue:QueDate'=SearchDate
		s QueExaBorDR=$List(^User.DHCQueueD(QueDr),6)
		if QueExaBorDR'=""{
			s HospitalDr=$Lg(^User.DHCExaBoroughD(QueExaBorDR),13)
			continue:HospitalDr'=HospitalId
			continue:(ZoneID'="")&&(QueExaBorDR'=ZoneID)&&(QueExaBorDR'="")  ;诊区入参不为空时，非本诊区的过滤
		}
		s AutoReportFlag="N",ResultMsg="请正常报到"
		s ret=##class(web.DHCAlloc).CheckOPAllocReport(QueDr,UserID,.ResultMsg,"AutoReport")
		if ret=0{
			s AutoReportFlag="Y"	
		}
		s RtnObj=##class(DHCExternalService.OPAlloc.Entity.List.OPAllocReport).%New()
		s AdmRowid=$List(^User.DHCQueueD(QueDr),11)
		
		Set AdmDate=..%ZD($p(^PAADM(AdmRowid),"^",41))  //挂号日期
		Set PatientID=$p(^PAADM(AdmRowid),"^",1)
		Set PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //病人姓名
		Set AdmitDate=..%ZD($p(^PAADM(AdmRowid),"^",6))       //就诊日期
		Set DepartmentId=$p(^PAADM(AdmRowid),"^",4)    //就诊科室
		Set Department=""
		if DepartmentId'="" Set Department=$p(^CTLOC(DepartmentId),"^",2)
		if (Department["-") set Department=$piece(Department,"-",2)
		Set HospitalName=""
		Set HospitalId=$p(^CTLOC(DepartmentId),"^",22)
		if HospitalId'="" Set HospitalName=$p(^CT("HOSP",HospitalId),"^",2)  //医院
		Set DoctorId=$p(^PAADM(AdmRowid),"^",9)
		Set Doctor=""
		if DoctorId'="" Set Doctor=$p(^CTPCP(DoctorId,1),"^",2)
		Set QueStatus=""
		Set QueStateDr=$List(^User.DHCQueueD(QueDr),14)
		if QueStateDr'=""{
			Set QueStatus=$List(^User.DHCPerStateD(QueStateDr),4)
			Set QueStatusNote=$ListGet(^User.DHCPerStateD(QueStateDr),6)
			if QueStatusNote'="" Set QueStatus=QueStatusNote
		}
		Set QueSeqNo=$List(^User.DHCQueueD(QueDr),10)
		Set QueRoomDr=$List(^User.DHCQueueD(QueDr),13)
	 	Set QueRoomName=""
	 	Set:QueRoomDr'="" QueRoomName=$p($g(^CTLOC(QueRoomDr)),"^",2)
	 	
	 	Set RegFeeRBASDr="",RegRangeTime="",TimeRangeRegInfo=""
	 	Set RegFeeID=$O(^User.DHCRegistrationFeeI("ADM",AdmRowid,""))
	 	
	 	if RegFeeID'="" {
			s RegFeeRBASDr=$List(^User.DHCRegistrationFeeD(RegFeeID),18)
			s RegRangeTimeDr=$P($G(^RBAS(+RegFeeRBASDr,$P(RegFeeRBASDr,"||",2),"DHC")),"^",17)
			i $g(RegRangeTimeDr)'=""{
				set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
			}
			s TimeRangeRegInfo=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(RegFeeRBASDr,QueSeqNo)
		}
		Set WaitingAddress=##class(web.DHCOPAdmReg).GetWaitingAddressInfo(AdmRowid)
		Set RtnObj.AdmQueID=QueDr
		Set RtnObj.AdmDate=AdmDate
		Set RtnObj.QueStatus=QueStatus
		Set RtnObj.PatName=PatName
		Set RtnObj.PatientID=##class(DHCExternalService.OPAlloc.Public).PatientIDToNo(PatientID)
		Set RtnObj.HospitalName=HospitalName
		Set RtnObj.Department=Department
		Set RtnObj.DepartmentCode=DepartmentId
		Set RtnObj.Doctor=Doctor
		Set RtnObj.DoctorCode=DoctorId
		Set RtnObj.QueSeqCode=QueSeqNo
		Set RtnObj.AutoReportFlag=AutoReportFlag
		Set RtnObj.AutoReportMsg=ResultMsg
		Set RtnObj.AdmitAddress=$p(WaitingAddress,"^",1)
		Set RtnObj.QueExamRoom=QueRoomName
		Set RtnObj.RegRangeTime=RegRangeTime
		Set RtnObj.AdmitRange=TimeRangeRegInfo
		if ($IsObject(RtnObj)){
			do OutputObj.ReportInfo.Insert(RtnObj)
			do RtnObj.%Close()
			Set RecordCount=RecordCount+1
		}
	}
		
	if RecordCount'=0{
		s OutputObj.ResultCode="0"
		s OutputObj.ResultContent="查询成功"	
	}else{
		s OutputObj.ResultCode="100"
		s OutputObj.ResultContent="未查询到需报到的就诊记录"	
	}
	Set OutputObj.RecordCount=RecordCount
	q OutputObj
GetOPAllocReportErr
	s OutputObj=##class(DHCExternalService.OPAlloc.Entity.GetOPAllocReportRp).%New()
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="GetOPAllocReport调用异常"_$ZERROR
	Q OutputObj
}

/// 自助报到两种方法：(报到->等候;过号->等候;到达->复诊)
/// w ##class(DHCExternalService.OPAlloc.Methods).OPAllocAutoReport("<Request><TradeCode>1301</TradeCode><ExtOrgCode></ExtOrgCode><ClientType></ClientType><HospitalId>DHSZHYYZY</HospitalId><ExtUserID>hs01</ExtUserID><AdmQueID>2842</AdmQueID><TransactionId></TransactionId><PatientCard></PatientCard><CardType></CardType><PatientID>0000000016</PatientID></Request>")
ClassMethod OPAllocAutoReport(Input As %String) As DHCExternalService.OPAlloc.Entity.OPAllocAutoReportRp
{
	s $zt="OPAllocAutoReportErr"
	s ^TMPSelfRegXML("Request","OPAllocAutoReport")=Input
	s InputObj=##class(DHCExternalService.OPAlloc.Entity.OPAllocAutoReportRt).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
	s ServiceName=InputObj.ServiceName
	s PatientNo=InputObj.PatientID
	s CardType=InputObj.CardType
	s PatientCard=InputObj.PatientCard
	s IDType=InputObj.IDType
	s ExtUserID=InputObj.ExtUserID
	s MachineID=InputObj.MachineID
	s ZoneID=InputObj.ZoneID
	s AdmQueID=InputObj.AdmQueID
	s HospitalId=InputObj.HospitalId
	s CurrTime=..%SysTime()
	s OutputObj=##class(DHCExternalService.OPAlloc.Entity.OPAllocAutoReportRp).%New()
	s HospitalId=##class(DHCExternalService.RegInterface.GetRelate).GetHISHospitalIdFromOuterCode(HospitalId) 
	if HospitalId=""{
		d ..SetOutputCode(.OutputObj,"-100","请传入正确的院区代码.")
		quit OutputObj	
	}
	s UserID=##class(DHCExternalService.OPAlloc.GetRelate).GetUser(ExtUserID,"",HospitalId)
	if (UserID=""){
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="报到失败,此自助机对应操作员未配置HIS系统用户"
		q OutputObj
	}
	
	i AdmQueID=""{
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="报到失败,请传入需报到的就诊队列ID"
		q OutputObj	
	}else{
		if (PatientNo="") {
			s PatientNo=$lg(^User.DHCQueueD(AdmQueID),12)
		}
	}
	
	/*if (PatientCard="")&&(PatientNo="") {
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="报到失败,请传入卡号或患者唯一号以确认患者信息"
		q OutputObj
	}*/
	s GroupID=##class(DHCExternalService.OPAlloc.GetRelate).GetGroup(UserID)
	s BankCode=##class(DHCDoc.Interface.Outside.Config).GetConfigNode(GroupID,"DataCompareExtOrg",HospitalId)
	s CardType=##class(DHCExternalService.OPAlloc.GetRelate).GetHisCardTypeID(CardType,BankCode,"",HospitalId)
	s myPatientID=""
	if PatientNo'=""{
		 s myPatientID=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatientNo,"U"),""))
	}
	else{
		if PatientCard'=""{
			s CFRowid=0
			for {
				s CFRowid=$O(^DHCCARDi("CF",0,"CardNo",PatientCard,CFRowid)) Q:CFRowid=""
				s CFActive=$p(^DHCCARD("CF",CFRowid),"^",10)
				Continue:CFActive'="N"
				s CFCardTypeDR=$p(^DHCCARD("CF",CFRowid),"^",16)
				Continue:(CardType'="")&(CardType'=CFCardTypeDR)
				s myPatientID=$p(^DHCCARD("CF",CFRowid),"^",4)
			}
		}
	}
	
	if myPatientID="" {
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="报到失败,病人记录在系统中不存在"
		q OutputObj
	}
	s myPatientNo=$p(^PAPER(myPatientID,"PAT",1),"^",2)
	
	s ResultMsg=""
	s ret=##class(web.DHCAlloc).CheckOPAllocReport(AdmQueID,UserID,.ResultMsg,"AutoReport")
	if ret'=0{
		s OutputObj.ResultCode=ret
		s OutputObj.ResultContent="报到失败,"_ResultMsg
		q OutputObj
	}
	
	Set PAAdm=$List(^User.DHCQueueD(AdmQueID),11)
	Set AdmPatientID=$p(^PAADM(PAAdm),"^",1)
	if AdmPatientID'=myPatientID{
		s OutputObj.ResultCode="-1"
		s OutputObj.ResultContent="报到失败,传入的患者信息与传入的就诊号对应的患者信息不一致"
		q OutputObj
	}
	
	s QueExaBorDR=$List(^User.DHCQueueD(AdmQueID),6)
	if QueExaBorDR'=""{
		s HospitalDr=$Lg(^User.DHCExaBoroughD(QueExaBorDR),13)
		if HospitalDr'=HospitalId{
			s OutputObj.ResultCode="-1"
			s OutputObj.ResultContent="报到失败,非当前传入院区就诊记录不能报到"
			q OutputObj
		}
		if (ZoneID'="")&&(QueExaBorDR'=ZoneID){
			s OutputObj.ResultCode="-1"
			s OutputObj.ResultContent="报到失败,该队列记录对应诊区与所选诊区不一致"
			q OutputObj
		}
	}
	s QueExaBor=""
	s:QueExaBorDR'="" QueExaBor=$List(^User.DHCExaBoroughD(QueExaBorDR),5)
	s QueFirstDr=$List(^User.DHCQueueD(AdmQueID),7)
	s QueStateDr=$List(^User.DHCQueueD(AdmQueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	s ArriveRtn=0,AlertInfo=""
	if (status="报到") {
		s ArriveRtn=##class(web.DHCAlloc).PatArrive("AutoReport","",AdmQueID,UserID,GroupID)
	}
	elseif (status="到达") {
		s ArriveRtn=##class(web.DHCAlloc).PatAgain("AutoReport","",AdmQueID,UserID)
	}
	elseif (status="过号") {
		;过号状态会置为优先+等候状态
		;s ArriveRtn=##class(web.DHCAlloc).PatPrior("AutoReport","",AdmQueID,UserID)
		s ArriveRtn=##class(web.DHCAlloc).PatArrive("AutoReport","",AdmQueID,UserID,GroupID)
	}
	if ArriveRtn'="0" {
		s AlertInfo="报到失败,错误原因或代码:"_ArriveRtn
		s OutputObj.Tip=AlertInfo
		s OutputObj.ResultCode="-100"
		s OutputObj.ResultContent=AlertInfo
	}else{
		s AlertInfo="报到成功,请您到"_QueExaBor_"外候诊"
		s QueSeqNo=$List(^User.DHCQueueD(AdmQueID),10)
		s flag=##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCDocOutPatientList"_"||"_"GetNewQueueNo")
	 	if (flag=1){
		 	b ;nk=000
			s NewSeqNoStr=##class(web.DHCDocOutPatientList).GetNewQueueNo(PAAdm)
			b ;nk-01
			if NewSeqNoStr'=""{
				s ShowSeqNo=$P(NewSeqNoStr,"^",2)
				s SeqNoStatus=$P(NewSeqNoStr,"^",3)
				if (SeqNoStatus="正常"){
  					s SeqNoStatus=""
				}
				if (ShowSeqNo'=""){
  					s QueSeqNo=ShowSeqNo
				}
				i SeqNoStatus'="" s QueSeqNo=QueSeqNo_"号 "_SeqNoStatus
			}
	 	}
	 	d GetFrontNum
		i OutputObj.FrontNum="" s OutputObj.FrontNum=FrontNumStr
		e  s OutputObj.FrontNum=OutputObj.FrontNum_";"_FrontNumStr
		s AdmitRange=##class(web.DHCDocOutPatientList).GetPrintTimeRange(PAAdm)
		s OutputObj.Tip=AlertInfo
		s OutputObj.ArrivalNo=QueSeqNo
		s OutputObj.ResultCode="0"
		s OutputObj.ResultContent="报到成功"
		s OutputObj.AdmitRange=AdmitRange
	} 	
	
	s PatName=$p(^PAPER(AdmPatientID,"ALL"),"^",1)
	s DOB=$p(^PAPER(AdmPatientID,"ALL"),"^",6)
	i DOB'="" s DOB=$zd(DOB,3)
	s Sex=""
	s SexDR=$p(^PAPER(AdmPatientID,"ALL"),"^",7)
	i SexDR'="" s Sex=$p(^CT("SEX",SexDR),"^",2)
	s DVAnumber=$p(^PAPER(AdmPatientID,"PAT",3),"^",6)
	s OutputObj.PatientID=myPatientNo
	s OutputObj.PatientName=PatName
	s OutputObj.PatientSex=Sex
	q OutputObj
OPAllocAutoReportErr
	s OutputObj=##class(DHCExternalService.OPAlloc.Entity.OPAllocAutoReportRp).%New()
	s OutputObj.ResultCode="-1"
	s OutputObj.ResultContent="报到失败,程序异常,异常原因:"_$ze
	q OutputObj
GetFrontNum
	s FrontNumStr=""
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAAdm)
	s PatSumStr=##class(web.DHCAlloc).GetPatSum(AdmPatientID,QueExaBorDR,AdmHospitalId,AdmQueID)
	for loop=1:1:$l(PatSumStr,"^"){
		s aPatSumStr=$p(PatSumStr,"^",loop)
		continue:aPatSumStr=""
		s DocName=$p(aPatSumStr,"$",1)
		s QuePatNo=$p(aPatSumStr,"$",2)
		s Sum=$p(aPatSumStr,"$",3)
		s FZSum=$p(aPatSumStr,"$",4)
		s DHSum=$p(aPatSumStr,"$",5)
		s FrontNumInfo=DocName_"前面有 "_Sum_" 人。其中复诊为 "_FZSum_" 人，等待为 "_DHSum_" 人。"	
		if FrontNumStr=""{
			s FrontNumStr=FrontNumInfo
		}else{
			s FrontNumStr=FrontNumStr_";"_FrontNumInfo
		}
	}
	quit
	
	s ID=0
	for {
		s ID=$o(^User.DHCQueueI("QueDateDeptIndex",+$h,Admdepcode,ID))
		q:ID=""
		s myQueMarkDr=$List(^User.DHCQueueD(ID),8)
		continue:myQueMarkDr'=QueMarkDr
		Set myQueStateDr=$List(^User.DHCQueueD(ID),14)
		s myStateDesc=""
		if myQueStateDr'="" Set myStateDesc=$List(^User.DHCPerStateD(myQueStateDr),4)
		continue:("到达退号过号")[myStateDesc
		s mySeqNo=$List(^User.DHCQueueD(ID),10)
		s myAdmId=$lg(^User.DHCQueueD(ID),11)
		s mySeqNoStr=##class(web.DHCDocOutPatientList).GetNewQueueNo(myAdmId)
		s mySeqNo=+$P(mySeqNoStr,"^",2)

		continue:(SeqNo'["+")&&(mySeqNo["+")
		if (SeqNo["+")&&(mySeqNo'["+")
		{
			s FrontNum=FrontNum+1
			continue
		}
		if ((+SeqNo)>(+mySeqNo)){
			s FrontNum=FrontNum+1
		}
	}
	q
}

/// 赋值出参标识
ClassMethod SetOutputCode(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String)
{
	s object.ResultCode=ResultCode
	
	if ($d(^oddCOM(object.%ClassName(1),"a","ResultContent"))){
		s object.ResultContent=ResultContent
	}elseif ($d(^oddCOM(object.%ClassName(1),"a","ErrorMsg"))){
		s object.ErrorMsg=ResultContent
	}
}

}
