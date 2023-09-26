Class web.DHCRBAppointment Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 预约取号,需要重写可用号串
ClassMethod AppArrive(APPTRowId As %String, AdmDR As %String, UserDR As %String, HospitalID As %String = "")
{
	Set object =##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s RBASRowId=object.APPTASParRef.%Id()
		s APPTStatus=object.APPTStatus
		;已经取号
		Q:APPTStatus="A" "-201"
		Q:APPTStatus="X" "-202"
		//停止挂号（医生坐诊信息开启停止挂号后，不允许挂号及取号）
		s StopRegFlag=$P($G(^RBAS(+RBASRowId,$P(RBASRowId,"||",2),"DHC")),"^",30)
	   	if (StopRegFlag="Y"){
		   Q "-213"
		   }
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		d object.APPTLastStatusChangeUserDRSetObjectId(UserDR)
		d object.APPTAdmDRSetObjectId(AdmDR)
		s object.APPTStatus="A"
		s sc=object.%Save()
		s MethodDr=object.APPTMethodDR.%Id()
		If $$$ISERR(sc) {
			//Do $System.Status.DisplayError()
			Q 100
		}else{
			s SeqNo=object.APPTQueueNo
			d object.%Close()
			;
			Set StatusCode=3
			Do ..RestoreSeqNo(RBASRowId, SeqNo, StatusCode)
		}
		Q 0
		i MethodDr'="" {
			s MethodCode=$P(^RBC("APTM",MethodDr),"^",1)
			//调用114替诊接口
			s CFIFTeleAppStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFTeleAppStart",HospitalID)
			if MethodCode="TEL" {
				if (CFIFTeleAppStart=1){
					set err=##class(dhcinterface.TeleClient).notifyGetNumber(RBASRowId)
					If err'=0 {
						;Do $System.Status.DisplayError()
					}
				}
			}
		}
		Quit 0
	}
	Q 100
}

/// 违约,需要重写可用号串
ClassMethod AppBreak(APPTRowId) As %String
{
	;w ##class(web.DHCRBAppointment).AppBreak("20||2||9")
	s object=##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		s object.APPTStatus="J"
		;
		s SeqNo=object.APPTQueueNo
		;
		Set sc =object.%Save()
		If $$$ISERR(sc) {
			d object.%Close()
			;Tro
			;Do $System.Status.DisplayError()
		}else{
			d object.%Close()
			;
			Set StatusCode=0
			Set RBASId=$P(APPTRowId,"||",1,2)
			Do ..RestoreSeqNo(RBASId, SeqNo, StatusCode)
			;大屏号别状态服务
			s CFIFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFScreenStart")
			if (CFIFScreenStart=1){
				s FullFlag=##class(web.DHCRBApptSchedule).CheckScheduleFull(RBASId)
				s err=##class(dhcinterface.DoctorApptScheClient).SetScreenDisplayMsg(RBASId,FullFlag)
			}
			Quit 0
		}
	}
	Quit 100
}

/// 退预约,需要重写可用号串
ClassMethod AppCancel(APPTRowId As %String, UserRowId As %String = "", StatusCode As %String = "", HospitalID As %String = "") As %String
{
	s object=##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s APPTStatus=object.APPTStatus
		b ;已经取号
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		i UserRowId'="" d object.APPTLastStatusChangeUserDRSetObjectId(UserRowId)
		s object.APPTStatus="X"
		;
		s SeqNo=object.APPTQueueNo
		
		Set sc =object.%Save()
		If $$$ISERR(sc) {
			d object.%Close()
			Do $System.Status.DisplayError()
		}else{
			d object.%Close()
			;
			if StatusCode="" Set StatusCode="AppCancle"
			Set RBASId=$P(APPTRowId,"||",1,2)
			;Do ..RestoreSeqNo(RBASId, SeqNo, StatusCode,"",HospitalID)
			d ..AppCancelRestoreSeqNo(RBASId, SeqNo, StatusCode ,HospitalID,"")
			Quit 0
		}
	}
	Quit 100
}

/// 恢复预约,需要重写可用号串
ClassMethod AppRestore(APPTRowId As %String, UserRowId As %String = "") As %String
{
	s ^zhou("RestoreAppointment")=APPTRowId_"^"_UserRowId
	s object=##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s APPTStatus=object.APPTStatus
		b ;已经取号
		;Q:APPTStatus="A" "-201"
		;Q:APPTStatus="I" "-203"
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		i UserRowId'="" d object.APPTLastStatusChangeUserDRSetObjectId(UserRowId)
		s object.APPTStatus="A"
		;
		s SeqNo=object.APPTQueueNo
		s AppMethodRowId=""
		if (object.APPTMethodDR) s AppMethodRowId=object.APPTMethodDR.%Id()

		Set sc =object.%Save()
		If $$$ISERR(sc) {
			d object.%Close()
			Do $System.Status.DisplayError()
		}else{
			d object.%Close()
			;
			Set StatusCode=3
			Set RBASId=$P(APPTRowId,"||",1,2)
			Do ..RestoreSeqNo(RBASId, SeqNo, StatusCode,AppMethodRowId)
			Quit 0
		}
	}
	Quit 100
}

/// 取消预约,需要重写可用号串
ClassMethod CancelAppointment(APPTRowId As %String, UserRowId As %String = "", HospitalId As %String = "") As %String
{
	s ^zhou("CancelAppointment")=APPTRowId_"^"_UserRowId
	s object=##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s APPTStatus=object.APPTStatus
		b ;已经取号
		Q:APPTStatus="A" "-201"
		Q:APPTStatus="X" "-202"
		Q:APPTStatus="J" "-203"
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		i UserRowId'="" d object.APPTLastStatusChangeUserDRSetObjectId(UserRowId)
		s object.APPTStatus="X"
		;
		s SeqNo=object.APPTQueueNo
		
		s ASDate=""
		b ;get data
		i $IsObject(object.APPTASParRef) {s ASDate=object.APPTASParRef.ASDate}
		;
		Set sc =object.%Save()
		If $$$ISERR(sc) {
			d object.%Close()
			Do $System.Status.DisplayError()
		}else{
			d object.%Close()
			;
			Set StatusCode=0
			s AppReturnNotAllowRegAdd=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppReturnNotAllowRegAdd",HospitalId)
			i AppReturnNotAllowRegAdd=1 s StatusCode=4
			Set RBASId=$P(APPTRowId,"||",1,2)
			;Do ..RestoreSeqNo(RBASId, SeqNo, StatusCode)
			d ..AppCancelRestoreSeqNo(RBASId, SeqNo, "AppCancle" ,HospitalId,"")
			;大屏号别状态服务
			s CFIFScreenStart=##class(web.DHCOPRegConfig).GetSpecConfigNode("IFScreenStart",HospitalId)
			if (CFIFScreenStart=1)&&(ASDate=..%SysDate()){
				s FullFlag=##class(web.DHCRBApptSchedule).CheckScheduleFull(RBASId)
				set flag=##class(%Dictionary.MethodDefinition).%ExistsId("dhcinterface.DoctorApptScheClient"_"||"_"SetScreenDisplayMsg")
 				if (flag=1){
					s err=##class(dhcinterface.DoctorApptScheClient).SetScreenDisplayMsg(RBASId,FullFlag)
				}
			}
			;平台组接口
			s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDCANCELAPPTSCHEDULEINFO",APPTRowId)
			
			Quit 0
		}
	}
	Quit 100
}

ClassMethod ChangeAppoint(APPTRowId As %String, NewCardNo As %String)
{
	s NewPatientID=##class(web.DHCOPAdmReg).GetPatientIDByCardNo(NewCardNo)
	if NewPatientID="" Q "-201"
	&SQL(Update SQLUser.RB_AppointMent Set APPT_PAPMI_DR=:NewPatientID Where APPT_RowId=:APPTRowId )
	if SQLCODE  Q "-202"
	Q 0
}

ClassMethod FindBroker(itmjs As %Library.String = "", AdmDepRowId As %String, AdmDocRowId As %String, StartDate As %Date, EndDate As %Date, PatientNo As %String, PatientID As %String, AppStatus As %String) As %String
{
	s desc=""
	s n=0
	Set rset=##Class(%ResultSet).%New("web.DHCRBAppointment:Find")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(AdmDepRowId, AdmDocRowId, StartDate, EndDate, PatientNo, PatientID, AppStatus)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			set ret=""
		    For col = 1:1:columns {
			   i ret="" s ret=rset.GetData(col)
		       e  s ret= ret_"^"_rset.GetData(col)
		    
		    }
		    s n=n+1
		    
	       i ret'="" {
		   		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
				&javascript<#(retval)#>
	       }
		}
		d rset.Close()
	}
	Q n
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindExecute(ByRef qHandle As %Binary, AdmDepRowId As %String, AdmDocRowId As %String, StartDate As %Date, EndDate As %Date, PatientNo As %String, PatientID As %String, AppStatus As %String, vRBASID As %String, PatName As %String, PatTel As %String, PatCredNo As %String, TimeRangeRowID As %String, UpdateUser As %String, LogonHospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCRBAppointment","Find","","","","","",22,"")
	set ^zhou("Para4")=AdmDepRowId_","_AdmDocRowId_","_StartDate_","_EndDate_","_PatientNo_","_PatientID_","_AppStatus_","_vRBASID_","_PatName_","_PatTel_","_PatCredNo
	//if (StartDate'="")&&($l(StartDate,"/")=3) set StartDate=$zdh(StartDate,4)
	//if (EndDate'="")&&($l(EndDate,"/")=3) set EndDate=$zdh(EndDate,4)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s num=0
	if (StartDate="")&&(PatientID'="") s StartDate=..%SysDate()
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'=""   s EndDate=..%ZDH(EndDate)
    if (vRBASID'=""){
	    s StartDate="",EndDate=""
	}else{
		if (PatName'="")||(PatTel'="")||(PatCredNo'="") s StartDate=..%SysDate()
	}
	if LogonHospId="" s LogonHospId=$P(UpdateUser,"^",2)
	s UpdateUser=$P(UpdateUser,"^",1)
	s LogonHospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID()
	if (PatientNo'=""){
		s PatientID=##class(web.DHCOPAdmReg).GetPatientIDByNo(PatientNo)
	}
	if (PatientID'=""){
		s:PatName="" PatName=$p(^PAPER(PatientID,"ALL"),"^",1)
		s:PatCredNo="" PatCredNo=$p(^PAPER(PatientID,"ALL"),"^",9)
		s:PatTel="" PatTel=$p(^PAPER(PatientID,"PER",1),"^",11)
	}

	if (StartDate'=""){
		s ResRowId=0  f  s ResRowId=$O(^RBAS("APPT_Date",ResRowId)) Q:ResRowId=""  d
		.s AppDate=(StartDate-1) f  s AppDate=$O(^RBAS("APPT_Date",ResRowId,AppDate)) Q:(AppDate="")!((EndDate'="")&&(+AppDate>EndDate))  d
		..s AppTime="" f  s AppTime=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime)) Q:AppTime=""  d
		...s ASChild=0 f  s ASChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild)) Q:ASChild=""  d
		....s APPChild=0 f  s APPChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild,APPChild)) Q:APPChild=""  d
		.....Q:'$D(^RB("RES",ResRowId))
	    .....Q:(EndDate'="")&(+AppDate>EndDate)
		.....d OutPutRow2
		if ind=1{
			set Data=$lb("")
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}else{
		if (vRBASID'=""){
			s ResRowId=+vRBASID,ASChild=$p(vRBASID,"||",2)
			s APPChild=0 f  s APPChild=$o(^RBAS(ResRowId,ASChild,"APPT",APPChild)) q:APPChild=""  d
			.q:($p(vRBASID,"||",3)'="")&&(APPChild'=$p(vRBASID,"||",3))
			.s AppDate=$P(^RBAS(+ResRowId,ASChild),"^",1)
			.d OutPutRow2
			if ind=1{
				set Data=$lb("")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
		    }
		}else{
		  set Data=$lb("")
		  Set ^CacheTemp(repid,ind)=Data
		  Set ind=ind+1
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow2
	s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	Q:Appt=""
	s DepRowId=$P(^RB("RES",ResRowId),"^",1)
	s DocRowId=$P(^RB("RES",ResRowId),"^",2)
	s DepDesc=$p($g(^CTLOC(DepRowId)),"^",2)
	s DepDesc=..FormatDesc(DepDesc)
	s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
	s CTLOCHospitalDR=$p($g(^CTLOC(DepRowId)),"^",22)
	Q:(CTLOCHospitalDR'=LogonHospId)
	Q:(AdmDepRowId'="")&&(DepRowId'=AdmDepRowId)
	Q:(AdmDocRowId'="")&&(DocRowId'=AdmDocRowId)
	s TRRowId=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",17)
	Q:(TimeRangeRowID'="")&&(TRRowId'=TimeRangeRowID)
	s APPTAdmDR=$P(Appt,"^",4)
	;预约人姓名
	s AppPatientID=$P(Appt,"^",2)
	;Q:'$D(^PAPER(AppPatientID))
	s AppPatientName="",AppPatientNo="",EmployeeFunction="",SecretLevel=""
	Q:(PatientID'="")&&(("^"_CommonPatientID_"^")'[("^"_AppPatientID_"^"))&&(AppPatientID'=PatientID)  ;无卡预约信息始终显示
	if AppPatientID'="" d
	.s AppPatientName=$p(^PAPER(AppPatientID,"ALL"),"^",1)
	.S AppPatientNo=$p(^PAPER(AppPatientID,"PAT",1),"^",1)
	.s PAPERTelH=$p($g(^PAPER(AppPatientID,"PER",1)),"^",11)
	.s AppPatientCredNo=$p($g(^PAPER(AppPatientID,"ALL")),"^",9)
	//最后更新人
	s LastUpdateUser=$P(^RBAS(ResRowId,ASChild,"APPT",APPChild),"^",65)
	if LastUpdateUser="" s LastUpdateUser=$P(^RBAS(ResRowId,ASChild,"APPT",APPChild),"^",11)
	//q:(UpdateUser'="")&&(UpdateUser'=LastUpdateUser)
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(AppPatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",4)
	}
	;Q:(PatientNo'="")&(AppPatientNo'=PatientNo)
	;
	s CardCommonAppInfo="",AppPatTypeDr="",PatientRegNo="",PatientAge=""
	i (("^"_CommonPatientID_"^")[("^"_AppPatientID_"^")){
		s AppPatientName=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",1)
		s AppPatientCredNo=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",8)
		s AppPatientTelH=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",5)
		s APPTCredTypeDR=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",7)
		if (APPTCredTypeDR'="") {
			s APPTCredType=$p(^PAC("CARD",APPTCredTypeDR),"^",2)
		}else{
			s APPTCredTypeDR=$o(^DHCACCCredType("0","Code","01",""))
			s APPTCredType=$p(^PAC("CARD",APPTCredTypeDR),"^",2)
		}
		s PAPERTelH=AppPatientTelH
		s CardCommonAppInfo="证件类型:"_APPTCredType_" 证件号:"_AppPatientCredNo //_",联系电话:"_AppPatientTelH
		Q:(PatName'="")&&(AppPatientName'[PatName)&&(PatName'[AppPatientName)
		Q:(PatTel'="")&&(AppPatientTelH'=PatTel)
		Q:(PatCredNo'="")&&(AppPatientCredNo'=PatCredNo)
		s EmployeeFunction=""
		s SecretLevel=""
		s AppPatTypeDr=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",15)
	}else{
		//PatName As %String, PatTel As %String, PatCredNo
		Q:(PatName'="")&&(AppPatientName'[PatName)&&(PatName'[AppPatientName)
		Q:(PatTel'="")&&(PAPERTelH'=PatTel)
		Q:(PatCredNo'="")&&(AppPatientCredNo'=PatCredNo)
		s PatientRegNo=$p(^PAPER(AppPatientID,"PAT",1),"^",1)
		s PatientAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",AppPatientID,"",LogonHospId)
	}
	s StatusCode=$P(Appt,"^",3)
	;Q:(AppStatus'="")&(AppStatus'=StatusCode)
	;Q:(AppStatus="")&(StatusCode="A") //&(vRBASID="")
	;Q:(StatusCode="J")
	;Q:(StatusCode="X")
	Q:(AppStatus'="")&(AppStatus'[StatusCode)
	s StatusDesc=""
	i StatusCode="I" s StatusDesc="已预约"
	i StatusCode="A" s StatusDesc="已取号"
	i StatusCode="X" s StatusDesc="已取消"
	i StatusCode="J" s StatusDesc="爽约"
	s AdmRowId=$P(Appt,"^",4)
	s QueueNo=$P(Appt,"^",5)
	;
	s ApptTypeRowId=$P(Appt,"^",1)
	s ApptTypeCode=""
	i ApptTypeRowId'="" s ApptTypeCode=$P(^RBC("AT",ApptTypeRowId),"^",1)
	
	;办理预约日期,预约时间,预约办理人
	s TransDate=$P(Appt,"^",8)
	i TransDate'="" s TransDate=..%ZD(TransDate) //$ZD(TransDate,3)
	s TransTime=$P(Appt,"^",9)
	i TransTime'="" s TransTime=..%ZT(TransTime)
	s TransUserDR=$P(Appt,"^",11)
	s TransUserName="",TransUserGroupRowId=""
	i TransUserDR'="" d
	.s TransUserName=$p($g(^SSU("SSUSR",TransUserDR)),"^",2)
	.s TransUserGroupRowId=$P(^SSU("SSUSR",TransUserDR),"^",5)
	Q:(ApptTypeCode="NORN")&&(TransUserGroupRowId'="")&&(TransUserGroupRowId'=%session.Get("LOGON.GROUPID")) 
	;
	s MethodDR=$P(Appt,"^",12)
	s MethodDesc=""
	i MethodDR'="" s MethodDesc=$P(^RBC("APTM",MethodDR),"^",2)
	s AdmType=$P(Appt,"^",13)
	;
	;办理取号日期/取消日期,时间
	s StatusChangeDate=$P(Appt,"^",63)
	i StatusChangeDate'="" s StatusChangeDate=..%ZD(StatusChangeDate) //$ZD(StatusChangeDate,3)
	s StatusChangeTime=$P(Appt,"^",64)
	i StatusChangeTime'="" s StatusChangeTime=..%ZT(StatusChangeTime)
	s StatusChangeUserDR=$P(Appt,"^",65)
	s StatusChangeUserName=""
	i StatusChangeUserDR'="" s StatusChangeUserName=$p($g(^SSU("SSUSR",StatusChangeUserDR)),"^",2)
	q:(UpdateUser'="")&&(UpdateUser'=StatusChangeUserDR)
	if (StatusCode="J") s StatusChangeDate="",StatusChangeTime="",StatusChangeUserName=""
	;接口流水号
	s SystemSession=$P(Appt,"^",69)
	s RegfeeRowId="" 
	i APPTAdmDR'="" s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",APPTAdmDR,""))
	;原诊
	s OldRBASRowId=""
    i RegfeeRowId'="" s OldRBASRowId=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
	;停替诊标志获取
	s RBASStatusDesc="",RBASStatusReason="",TRRBASRowId="",TRDoc=""
 	if $d(^RBAS(ResRowId,ASChild)) d
    .s RBASStatusDr=$P(^RBAS(ResRowId,ASChild,"DHC"),"^",10)
 	.s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 	.s RBASStatusDesc=$P(^DHCRBCASStatus(RBASStatusDr),"^",2)
	.s RBASStatusReasonDr=$P($g(^RBAS(+ResRowId,ASChild,"DHC")),"^",11)
 	.i (RBASStatusReasonDr'="")&&((RBASStatusCode="S")||(RBASStatusCode="PS")||(RBASStatusCode="TR")) s RBASStatusReason=$P(^RBC("NA",RBASStatusReasonDr),"^",2)
 	;如果是被替诊前取号，医生应该替诊前医生
 	if (OldRBASRowId'="")&&$d(^RBAS(+OldRBASRowId,$p(OldRBASRowId,"||",2))) d 
 	.s RBASStatusDr=$P(^RBAS(+OldRBASRowId,$p(OldRBASRowId,"||",2),"DHC"),"^",10)
 	.s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 	.s RBASStatusDesc=$P(^DHCRBCASStatus(RBASStatusDr),"^",2)
 	.s DocRowId=$P(^RB("RES",+OldRBASRowId),"^",2)  
 	.s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
 	.s DocDesc=..FormatDesc(DocDesc)
 	.i RBASStatusCode="TR" d
 	..s TRRBASRowId=$P($G(^RBAS(+OldRBASRowId,$p(OldRBASRowId,"||",2),"DHC")),"^",12)
 	..i (TRRBASRowId'="") d
	...s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
 	...s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
 	..s RBASStatusReasonDr=$P(^RBAS(+OldRBASRowId,$p(OldRBASRowId,"||",2),"DHC"),"^",11)
 	..i RBASStatusReasonDr'="" s RBASStatusReason=$P(^RBC("NA",RBASStatusReasonDr),"^",2)
 	
	s StartTime=$P($G(^RBAS(ResRowId,ASChild)),"^",4)
	s TRRowId=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",17)
	;s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	i TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	e  s TRDesc="其他"
	s DocDesc=DocDesc_"("_TRDesc_")"
 	;被替诊的挂号记录才能显示对应的替诊排班记录RBASStatusCode按照Code来显示
 	i RBASStatusCode="R",OldRBASRowId="" d //替诊后，被替诊的预约记录的排班id修改成替诊医生的，所以预约记录的对应的排班没有被替诊的情况
 	.s TRRBASRowId=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",12)
 	.i (TRRBASRowId'="") d
	..;s DocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
 	..;s DocDesc=$p($g(^CTPCP(DocRowId,1)),"^",2)
 	..;s DocDesc=DocDesc_"("_TRDesc_")"
 	..;s DocRowId=$P(^RB("RES",ResRowId),"^",2)
 	..s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
 	..s TRDoc=$P($g(^CTPCP(TRDocRowId,1)),"^",2)
 	..;s RBASStatusDr=$P(^RBAS(+TRRBASRowId,$p(TRRBASRowId,"||",2),"DHC"),"^",10)
 	..;s RBASStatusDesc=$P(^DHCRBCASStatus(RBASStatusDr),"^",2)
 	..;s RBASStatusReasonDr=$P(^RBAS(+TRRBASRowId,$p(TRRBASRowId,"||",2),"DHC"),"^",11)
 	..;i RBASStatusReasonDr'="" s RBASStatusReason=$P(^RBC("NA",RBASStatusReasonDr),"^",2)
	s ReasonForCancel=""
	s APPTReasonForCancelDR=$P(Appt,"^",28) ;取消预约原因
	if APPTReasonForCancelDR'="" s ReasonForCancel=$P(^RBC("RFC",APPTReasonForCancelDR),"^",2)
	s RBASRowId=ResRowId_"||"_ASChild
	s FeeStr="||||||1"
	s APPTRowId=ResRowId_"||"_ASChild_"||"_APPChild
	s NeedAppFee=##class(web.DHCRBAppointment).NeedAppFee(APPTRowId)
	s FeeStr="1||1||1||0"
	i NeedAppFee="1" s FeeStr="1||1||1||1"
	s PatCatDr=""
	s:AppPatientID'="" PatCatDr=$p($G(^PAPER(AppPatientID,"PER",1)),"^",10)
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	
	s InvoiceId="",ConRowId="",PBRowId=""
	s RegFee=0,CheckFee=0,HoliFee=0,AppFee=0,ReCheckFee=0,OtherFee=0,MRFee=0
	i RegfeeRowId'="" {
		s InvoiceId=$lg(^User.DHCRegistrationFeeD(RegfeeRowId),11)
		i InvoiceId'=""	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceId,0))
		i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
		if PBRowId'="" {
			s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
			.s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
			.Q:ArcimId=""
			.s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,LogonHospId)
			.s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
			.i type="App" s AppFee=AppFee+BillSum
			.e  i type="Reg" s RegFee=RegFee+BillSum
			.e  i type="Check" s CheckFee=CheckFee+BillSum
			.e  i type="Holi" s HoliFee=HoliFee+BillSum
			.e  i type="ReCheck" s ReCheckFee=ReCheckFee+BillSum
			.e  i type="MR" s MRFee=MRFee+BillSum
			.e  i type="Other" s OtherFee=OtherFee+BillSum
		}	
		s Sum=AppFee+RegFee+CheckFee+HoliFee+ReCheckFee+OtherFee+MRFee
	}else {
		s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(RBASRowId,AdmReason,AppPatientID,"","")
		s RegFee=$p(DocResValue,"^",12)
		s CheckFee=$p(DocResValue,"^",14)
		s HoliFee=$p(DocResValue,"^",16)
		s AppFee=$p(DocResValue,"^",18)
		s ReCheckFee=$p(DocResValue,"^",15)
		s OtherFee=$p(DocResValue,"^",20)
		
		s ReAdmFlag=##class(web.DHCOPAdmReg).GetReAdmFeeFlag(AppPatientID,RBASRowId)
		if ReAdmFlag="1",ReCheckFee'=0 s CheckFee=ReCheckFee
		s Sum=HoliFee+CheckFee+RegFee+AppFee+OtherFee
	}
	s Sum=$fn(Sum,"",2)
	s RowId=ResRowId_"||"_ASChild_"||"_APPChild
	s AppDateHTML=..%ZD(AppDate) //$ZD(AppDate,3)
	s SessTypeDr=$p(^RBAS(ResRowId,ASChild,"DHC"),"^",6)
	s SessType=$select(SessTypeDr'="":$p(^RBC("SESS",SessTypeDr),"^",2),1:"")
	s Indseq=AppDate_$E("00000",1,5-$L(DepRowId))_DepRowId_$E("00000",1,5-$L(DocRowId))_DocRowId_$E("00000000",1,5-$L(ind))_ind
	s Data=$lb(RowId,AppDateHTML,AppTime,DepDesc,DocDesc,AppPatientID,AppPatientNo,AppPatientName,StatusCode,StatusDesc,MethodDesc,QueueNo,Sum,RBASStatusDesc,TRDoc,RBASStatusReason,TransDate,TransTime,TransUserName,StatusChangeDate,StatusChangeTime,StatusChangeUserName,SystemSession,RBASStatusCode,CardCommonAppInfo,PAPERTelH,EmployeeFunction,SecretLevel,ReasonForCancel,SessType,AppPatTypeDr,PatientRegNo,PatientAge)
	Set ^CacheTemp(repid,Indseq)=Data
	Set ind=ind+1
	if $G(in1) e  s in1=0
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FormatDesc(Desc As %String)
{
	s Desc1=$P(Desc,"-",2)
	if Desc1'="" s Desc=Desc1
	Q Desc
}

ClassMethod GetAPPMethodCodeByAdm(AdmRowId As %String) As %String
{
	;w ##class(web.DHCRBAppointment).GetAPPMethodCodeByAdm(482)
	s MethodCode=""
	s ResRowId=0  f  s ResRowId=$O(^RBAS("ADM",AdmRowId,ResRowId)) Q:ResRowId=""  d
	.s ASChild=0  f  s ASChild=$O(^RBAS("ADM",AdmRowId,ResRowId,ASChild)) Q:ASChild=""  d
	..s APPChild=0  f  s APPChild=$O(^RBAS("ADM",AdmRowId,ResRowId,ASChild,APPChild)) Q:APPChild=""  d
	...s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	...s MethodDR=$P(Appt,"^",12)
	...s MethodCode=""
	...i MethodDR'="" s MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
	Q MethodCode
}

/// 取得违约次数
ClassMethod GetAppBreakCount(PATRowId As %String) As %String
{
	s Count=0
	s Status="J"
	s ResRowId=0 f  s ResRowId=$O(^PAPERDR(PATRowId,"RB_Appt",Status,ResRowId))  q:ResRowId=""  d
	.s ASChild=0 f  s ASChild=$O(^PAPERDR(PATRowId,"RB_Appt",Status,ResRowId,ASChild))  q:ASChild=""  d 
	..s APPTChildSub=0 f  s APPTChildSub=$O(^PAPERDR(PATRowId,"RB_Appt",Status,ResRowId,ASChild,APPTChildSub))  q:APPTChildSub=""  d
	...Q:'$d(^RBAS(ResRowId,ASChild,"APPT",APPTChildSub))
	...s Count=Count+1
	Q Count
}

ClassMethod GetAppByAdm(AdmRowId As %String) As %String
{
	;w ##class(web.DHCRBAppointment).GetAppByAdm(924)
	s ret=""
	s ResRowId=0  f  s ResRowId=$O(^RBAS("ADM",AdmRowId,ResRowId)) Q:ResRowId=""  d
	.s ASChild=0  f  s ASChild=$O(^RBAS("ADM",AdmRowId,ResRowId,ASChild)) Q:ASChild=""  d
	..s APPChild=0  f  s APPChild=$O(^RBAS("ADM",AdmRowId,ResRowId,ASChild,APPChild)) Q:APPChild=""  d
	...s RowId=ResRowId_"||"_ASChild_"||"_APPChild
	...i ret="" s ret=RowId
	...e  s ret=ret_"^"_RowId
	Q ret
}

/// 计算病人某日的预约数
ClassMethod GetAppCount(PATRowId As %String, AppDate As %Date, ASRowId As %String = "") As %String
{
	;w ##class(web.DHCRBAppointment).GetAppCount(439864,+$H)
	s Count=0,ASCount=0
	s Status=0 f  s Status=$O(^PAPERDR(PATRowId,"RB_Appt",Status))  q:Status=""  d
	.Q:(Status'="A")&&((Status'="I"))
	.s ResRowId=0 f  s ResRowId=$O(^PAPERDR(PATRowId,"RB_Appt",Status,ResRowId))  q:ResRowId=""  d
	..s ASChild=0 f  s ASChild=$O(^PAPERDR(PATRowId,"RB_Appt",Status,ResRowId,ASChild))  q:ASChild=""  d 
	...s APPTChildSub=0 f  s APPTChildSub=$O(^PAPERDR(PATRowId,"RB_Appt",Status,ResRowId,ASChild,APPTChildSub))  q:APPTChildSub=""  d
	....Q:'$d(^RBAS(ResRowId,ASChild,"APPT",APPTChildSub))
	....;预约日期
	....s APPTDateComp=$p($g(^RBAS(ResRowId,ASChild)),"^",1)
	....Q:APPTDateComp'=AppDate
	....s Count=Count+1
	....s CurrASRowId=ResRowId_"||"_ASChild_"||"_APPTChildSub
	....Q:CurrASRowId'=ASRowId
	....s ASCount=ASCount+1
	Q Count_"^"_ASCount
}

/// Description:根据预约渠道代码获取预约渠道ID
/// Input:预约渠道代码
/// Output:预约渠道ID
/// debug:w ##class(web.DHCRBAppointment).GetApptTypeByCode("MDT")
ClassMethod GetApptTypeByCode(ApptTypeCode) As %String
{
	s ApptTypeRowId=""
	if ApptTypeCode'=""{
		s ApptTypeCode=$zcvt(ApptTypeCode,"U")
		if $d(^RBC("AT",0,"Code",ApptTypeCode)){
			s ApptTypeRowId=$o(^RBC("AT",0,"Code",ApptTypeCode,""))	
		}else{
			s RowId=0
			for{
				s RowId=$O(^RBC("AT",RowId)) Q:(RowId="")!(ApptTypeRowId'="")
				s Code=$P(^RBC("AT",RowId),"^",1)
				s Code=$zcvt(Code,"U")
				i (ApptTypeCode=Code){
					s ApptTypeRowId=RowId
				}
			}
		}
	}
	Q ApptTypeRowId
}

/// Description:增加预约号源回归时是否不释放资源并增号配置判断
/// 			预约号源回归时,号源状态仍为2(已预约状态),在web.DHCOPAdmReg.GetMarkRegFee调用的
/// 			web.DHCRBApptSchedule.GetAvailSeqNoStr()方法中增加自动增号操作
/// UpdateBy:nikang
/// UpdateTime:20180317
/// Debug:w ##class(web.DHCRBAppointment).GetReturnAllowRegFlag(2,"Y")
ClassMethod GetReturnAllowRegFlag(QueueNoStr As %String, AppFlag As %String = "", HospitalID As %String = "") As %String
{
	;1 不释放资源,0 释放资源
	;n (QueueNoStatus)
	s RandomTime=$P(QueueNoStr,":",4)
	s RandomDate=$p(QueueNoStr,":",5) 
	s QueueNoStatus=$P(QueueNoStr,":",2)
	i QueueNoStatus="" s QueueNoStatus=QueueNoStr
	if AppFlag'="Y"{
		i QueueNoStatus=0 {
			;未到释放时间，不执行释放
			i RandomTime'="",RandomTime>=$p($h,",",2),RandomDate'="",RandomDate=(+$h) Q 1
			Q 0
		}else{
			;仅处理退号状态
			;Q:QueueNoStatus'=4 1
			q 1
		}
		/*s ReturnNotAllowReg=##class(web.DHCOPRegConfig).GetSpecConfigNode("ReturnNotAllowReg",HospitalID)
		s ReturnNotAllowAdd=##class(web.DHCOPRegConfig).GetSpecConfigNode("ReturnNotAllowAdd",HospitalID)
		i ReturnNotAllowAdd=1 s ReturnNotAllowReg=1
		Q:(ReturnNotAllowReg=1) 1*/
	}else{
		;仅处理预约状态
		Q:QueueNoStatus'=2 1
		;预约回归不释放并增号
		#; s AppReturnNotAllowRegAdd=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppReturnNotAllowRegAdd",HospitalID)	
		#; Q:(AppReturnNotAllowRegAdd=1) 1
		;爽约时按照【主动取消预约】的处理方式进行释放号源，但是无法处理增号释放的方式，只能原号释放或不释放
		;增号释放统一按照原号释放去处理，保障号源能够全部释放出去
		s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateSplitAfterCancelApp",HospitalID)
		Q:(RestoreFlag'=1)&&(RestoreFlag'=3) 1
	}
	
	Q 0
}

ClassMethod GetReturnAllowRegFlagBak(QueueNoStatus As %String) As %String
{
	;1 不释放退号资源,0 释放退号资源
	;n (QueueNoStatus)
	Q:QueueNoStatus'=4 1
	s ReturnNotAllowReg=##class(web.DHCOPRegConfig).GetSpecConfigNode("ReturnNotAllowReg")
	s ReturnNotAllowAdd=##class(web.DHCOPRegConfig).GetSpecConfigNode("ReturnNotAllowAdd")
	i ReturnNotAllowAdd=1 s ReturnNotAllowReg=1
	if (ReturnNotAllowReg=1)&&(QueueNoStatus=4) {
		Q 1
	}else{
		Q 0
	}
}

/// 得到排号
ClassMethod GetSeqNoBak(RBASId As %String, RegType As %String, APPMethodCode As %String = "", UpdateFlag As %String = "") As %String
{
	;w ##class(web.DHCRBAppointment).GetSeqNo("559||24","APP","WIN")
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s APPSeqNoCount=0
	i APPSeqNoCount=0 s AppStartSeqNo=0
	
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s SingleQueueNo=0
	;如果超过延时则返回为空
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
	 	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 	;正号串与加号串
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
		;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
	 	if (StopRegNoFlag="Y") {
		 	if (RegType="NOR"){s RegType="ADD"}
		 	elseif ((RegType="APP")||(RegType="NORN")){
			 	lock -^RBASLOCK(ResRowId,Childsub)
				Q "0"
			}
		}
	 	if (NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")||(RegType="NORN")) {
		 	lock -^RBASLOCK(ResRowId,Childsub)
			Q "0"
	 	}
	 	//b  ;当日挂号取号
	 	i RegType="NOR" {
		 	for i=1:1:$l(NormalQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
				Set AppReturnTime2=AppReturnTime
			 	if QueueNoStatus=2{
					//按分时段里时间来回归
					Set AppReturnTime1=""
					Set ApptRowid=##class(web.DHCOPAdmReg).getApptRowidByQueNo(RBASId,QueueNo)
					if ApptRowid'="" Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(RBASId,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
					if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
					else  Set AppReturnTime2=AppReturnTime 
				}
			 	;未取号和已退号的可用,已经回归的预约的号可挂
			 	i (('..GetReturnAllowRegFlag(QueueNoStatus))||(('..GetReturnAllowRegFlag(QueueNoStatus,"Y"))&&(CurrentTime>AppReturnTime2))){
				 	s SingleQueueNo=QueueNo
				 	/*;如果没有设定预约号段
				 	if (AppStartSeqNo=0){s SingleQueueNo=QueueNo}
				 	else {
					 	;取非预号段内的号
					 	if (QueueNo<AppStartSeqNo)||(QueueNo>(AppStartSeqNo+APPSeqNoCount-1)){
						 	s SingleQueueNo=QueueNo
					 	}
				 	}
				 	*/
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
		 	//如果在正号串里找不到可用号则去加号去找
		 	i SingleQueueNo=0 s RegType="ADD"
	 	}
	 	
	 	i RegType="NORN" {
		 	for i=1:1:$l(NormalQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(QueueNoStatus))){
				 	s SingleQueueNo=QueueNo
				 	if (AppStartSeqNo=0){s SingleQueueNo=QueueNo}
				 	else {
					 	;取非预号段内的号,此处有问题,需单独写方法判断顺序号是否在预约号段记录中
					 	s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo)
					 	if QueueNoInAppFlag'=1 {
						 	s SingleQueueNo=QueueNo
					 	}
				 	}
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	
	 	//b  ;预约取号
	 	i RegType="APP" {
		 	;没有设定预约号信息
		 	if (APPSeqNoCount'=0) {
			 	s ArriveCount=0
			 	s APPQty=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASId,APPMethodCode)
			 	s APPMethodRowId=""
			 	i APPMethodCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
			 	for i=1:1:$l(NormalQueueNoStr,",") {
				 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
				 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 	s QueueNo=$P(SingleQueueNoStr,":",1)
				 	s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
				 	;b ;先统计已预约和已预约取号
				 	i ((QueueNoStatus=2)||(QueueNoStatus=3))&&(QueueNoMethodRowId=APPMethodRowId){
					 	;只取预约号段里的号
					 	s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,APPMethodRowId)
					 	if QueueNoInAppFlag=1 {
						 	s ArriveCount=ArriveCount+1
					 	}
				 	}
			 	}
			 	b ;ArriveCount,APPQty
			 	if (ArriveCount<APPQty){
				 	s AppRange=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodAppRange(RBASId,APPMethodCode)
				 	s IncludeAppRange=$P(AppRange,"^",1)
				 	s ExcludeAppRange=$P(AppRange,"^",2)
				 	;w "AppRange:"_AppRange,!
				 	for i=1:1:$l(NormalQueueNoStr,",") {
					 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
					 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
					 	s QueueNo=$P(SingleQueueNoStr,":",1)
					 	;未取号和已退号的可用
					 	i (('..GetReturnAllowRegFlag(QueueNoStatus))){
						 	;只取预约号段里的号
						 	s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,APPMethodRowId)
						 	i QueueNoInAppFlag=1 s SingleQueueNo=QueueNo
					 	}
					 	S SingleQueueNoStr=SingleQueueNo_":2:"_APPMethodRowId
					 	Q:SingleQueueNo'=0
				 	}
			 	}
		 	}
	 	}
	 	//b  ;加号取号
	 	i RegType="ADD" {
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(QueueNoStatus))){
					s SingleQueueNo=QueueNo
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	//b  ;诊间加号
	 	i RegType="DOCADD" {
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(QueueNoStatus))){
					s SingleQueueNo=QueueNo
			 	}
			 	//S SingleQueueNoStr=SingleQueueNo_":1"
			 	S SingleQueueNoStr=SingleQueueNo_":5"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	i SingleQueueNo'="0",UpdateFlag'="N" {
		 	if (RegType="NOR")!(RegType="APP")!(RegType="NORN"){
			 	s $P(NormalQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
		 	}else{
			 	s $P(AddQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
		 	}
	 	}
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	Q SingleQueueNo
}

/// 得到指定排号
ClassMethod GetSpecSeqNoBak(RBASId As %String, SpecQueueNo As %String, RegType As %String, APPMethodCode As %String = "", UpdateFlag As %String = "") As %String
{
	;w ##class(web.DHCRBAppointment).GetSeqNo("403||1","APP","WIN")
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	;预约限额
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s APPSeqNoCount=0
	i APPSeqNoCount=0 s AppStartSeqNo=0
	
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	;如果超过延时则返回为空
	s SingleQueueNo=0
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
	 	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 	;正号串与加号串
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 	if (NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")||(RegType="NORN")) {
		 	lock -^RBASLOCK(ResRowId,Childsub)
			Q "0"
	 	}
	 	;取加号限额外加号
	 	i ($e(SpecQueueNo,1)="+")  s RegType="ADD"
		;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
	 	if (StopRegNoFlag="Y") {
		 	if (RegType="NOR"){s RegType="ADD"}
		 	elseif ((RegType="APP")||(RegType="NORN")){
			 	lock -^RBASLOCK(ResRowId,Childsub)
				Q "0"
			}
		}
	 	//b ;正常挂号取号
	 	i RegType="NOR" {
		 	for i=1:1:$l(NormalQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
				Set AppReturnTime2=AppReturnTime
			 	if QueueNoStatus=2{
					Set AppReturnTime1=""
					Set ApptRowid=##class(web.DHCOPAdmReg).getApptRowidByQueNo(RBASId,QueueNo)
					if ApptRowid'="" Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(RBASId,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
					if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
					else  Set AppReturnTime2=AppReturnTime 
				}
			 	;未取号和已退号的可用
			 	i ((('..GetReturnAllowRegFlag(QueueNoStatus))||(('..GetReturnAllowRegFlag(QueueNoStatus,"Y"))&&(CurrentTime>AppReturnTime2)))&&(QueueNo=SpecQueueNo)){
				 	s SingleQueueNo=QueueNo
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
		 	//如果在正号串里找不到可用号则去加号去找
		 	i SingleQueueNo=0 s RegType="ADD"
	 	}
	 	i RegType="NORN" {
		 	for i=1:1:$l(NormalQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i ((('..GetReturnAllowRegFlag(QueueNoStatus)))&&(QueueNo=SpecQueueNo)){
				 	if (AppStartSeqNo=0){s SingleQueueNo=QueueNo}
				 	else {
					 	;取非预号段内的号
					 	if (QueueNo<AppStartSeqNo)||(QueueNo>(AppStartSeqNo+APPSeqNoCount-1)){
						 	s SingleQueueNo=QueueNo
					 	}
				 	}
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	//b  ;预约取号
	 	i RegType="APP" {
		 	;没有设定预约号信息
		 	if (APPSeqNoCount'=0) {
			 	s ArriveCount=0
			 	s APPQty=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(RBASId,APPMethodCode)
			 	s APPMethodRowId=""
			 	i APPMethodCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
			 	for i=1:1:$l(NormalQueueNoStr,",") {
				 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
				 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 	s QueueNo=$P(SingleQueueNoStr,":",1)
				 	s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
				 	;b ;先统计已预约和已预约取号
				 	i ((QueueNoStatus=2)||(QueueNoStatus=3))&&(QueueNoMethodRowId=APPMethodRowId){
					 	;只取预约号段里的号
					 	if (QueueNo'<AppStartSeqNo)&&(QueueNo'>(AppStartSeqNo+APPSeqNoCount-1)){
						 	s ArriveCount=ArriveCount+1
					 	}
				 	}
			 	}
			 	b ;ArriveCount,APPQty
			 	if (ArriveCount<APPQty){
				 	s AppRange=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodAppRange(RBASId,APPMethodCode)
				 	s IncludeAppRange=$P(AppRange,"^",1)
				 	s ExcludeAppRange=$P(AppRange,"^",2)
				 	;w "AppRange:"_AppRange,!
				 	for i=1:1:$l(NormalQueueNoStr,",") {
					 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
					 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
					 	s QueueNo=$P(SingleQueueNoStr,":",1)
					 	;未取号和已退号的可用
					 	i (('..GetReturnAllowRegFlag(QueueNoStatus)))&&(QueueNo=SpecQueueNo){
						 	;只取预约号段里的号
						 	if (QueueNo'<AppStartSeqNo)&&(QueueNo'>(AppStartSeqNo+APPSeqNoCount-1)){
							 	;s SingleQueueNo=QueueNo
							 	if IncludeAppRange'="" {
								 	s StartNo=$P(AppRange,$C(1),1)
								 	s EndNo=$P(AppRange,$C(1),2)
								 	if (QueueNo'<StartNo)&&(QueueNo'>EndNo){
									 	s SingleQueueNo=QueueNo
								 	}
							 	}elseif (ExcludeAppRange="" ) {
								 	s SingleQueueNo=QueueNo
							 	}else{
								 	s FindExclude=0
								 	for j=1:1:$l(ExcludeAppRange,$C(2)) {
									 	s SingleAppRange=$P(ExcludeAppRange,"^",$C(2),j)
										s StartNo=$P(SingleAppRange,$C(1),1)
								 		s EndNo=$P(SingleAppRange,$C(1),2)
								 		if (QueueNo'<StartNo)&&(QueueNo'>EndNo){
									 		s FindExclude=1
								 		}
								 		
								 	}
								 	if FindExclude=0 s SingleQueueNo=QueueNo
							 	}
						 	}
					 	}
					 	S SingleQueueNoStr=SingleQueueNo_":2:"_APPMethodRowId
					 	Q:SingleQueueNo'=0
				 	}
			 	}
		 	}
	 	}
	 	//b ;加号取号
	 	i RegType="ADD" {
		 	i (SpecQueueNo="+"){
			 	for i=1:1:$l(AddQueueNoStr,",") {
				 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
				 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 	s QueueNo=$P(SingleQueueNoStr,":",1)
				 	;未取号和已退号的可用
				 	i (('..GetReturnAllowRegFlag(QueueNoStatus))){
						s SingleQueueNo=QueueNo
				 	}
				 	S SingleQueueNoStr=SingleQueueNo_":1"
				 	Q:SingleQueueNo'=0
			 	}
			 	
			 	if (SingleQueueNo=0){
				 	s QueueNo=0,len=0
				 	i AddQueueNoStr'="" {
				 		s len=$l(AddQueueNoStr,",")
				 		s SingleQueueNoStr=$P(AddQueueNoStr,",",len)
				 		s QueueNo=$P(SingleQueueNoStr,":",1)
				 	}
				 	s SingleQueueNo=QueueNo+1
				 	s SingleQueueNo="+"_SingleQueueNo
				 	s i=len+1
				 	S SingleQueueNoStr=SingleQueueNo_":1"
				 	b  ;SingleQueueNoStr
			 	}
		 	}else{
			 	for i=1:1:$l(AddQueueNoStr,",") {
				 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
				 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 	s QueueNo=$P(SingleQueueNoStr,":",1)
				 	;未取号和已退号的可用
				 	i ((('..GetReturnAllowRegFlag(QueueNoStatus)))&&(QueueNo=SpecQueueNo)){
						s SingleQueueNo=QueueNo
				 	}
				 	S SingleQueueNoStr=SingleQueueNo_":1"
				 	Q:SingleQueueNo'=0
			 	}
		 	}
	 	}
	 	//b  ;诊间加号
	 	i RegType="DOCADD" {
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(QueueNoStatus))){
					s SingleQueueNo=QueueNo
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	i SingleQueueNo'="0",UpdateFlag'="N" {
		 	if (RegType="NOR")!(RegType="APP")!(RegType="NORN"){
			 	s $P(NormalQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo

		 	}else{
			 	s $P(AddQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
		 	}
	 	}
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	Q SingleQueueNo
}

/// 建立预约
ClassMethod Insert(Para As %String, SourceType As %String = "", HospitalID As %String = "") As %String
{
    s ^tmpDHCRBAppointment("Insert")=$lb(Para,SourceType,HospitalID)
	;w ##class(web.DHCRBAppointment).Insert("15^424||104^21^O^17473^^DOCADD^^^","","2")
	s rtn=0
	s PatientID=$P(Para,"^",1)
	s RBASId=$P(Para,"^",2)
	s MethodDR=$P(Para,"^",3)
	s AdmType=$P(Para,"^",4)
	s UserDR=$P(Para,"^",5)
	s SpecQueueNo=$P(Para,"^",6)
	s RegType=$P(Para,"^",7)
	s AppPatInfo=$P(Para,"^",8)
	s AppNote=$P(Para,"^",9) ;备注
	s AppNote=$lb(AppNote) ;使用sql插入备注流字段
	s TimeRangeStr=$P(Para,"^",10) ;时段
	s ClinicGroupDr=$P(Para,"^",11)  ;亚专业
	s ApptTypeCode=$P(Para,"^",12)  ;预约渠道
	/**
	*Modiyfy 20230111 为保证预约数据统计准确性。
	*修改方案：
	*1、本方法入参Para扩展字段“预约渠道”，并控制必填且不默认（防止非标版外部预约接口未传入预约渠道导致数据不准确）；
	*2、标版对外预约挂号预约接口、提前挂号接口增加预约渠道入参判定，不能为空，需按照HIS代码表（RBC_ApptType）进行传入，并判断数据准确性。
	*/
	s ApptTypeRowId=##class(web.DHCRBAppointment).GetApptTypeByCode(ApptTypeCode)
	if ApptTypeRowId=""{
		Q "-204"	
	}
	//处理扩展信息
	s (AppPatName,AppPatCredNo,AppPatTel,AppPatAddress,AppPatType,AppPatCredType)=""
	if (AppPatInfo'="") 
	{   s AppPatName=$p(AppPatInfo,"$",1)
		s AppPatCredNo=$p(AppPatInfo,"$",2)
		s AppPatTel=$p(AppPatInfo,"$",3)
		s AppPatAddress=$p(AppPatInfo,"$",4)
		s AppPatType=$p(AppPatInfo,"$",5)
		s AppPatCredType=$p(AppPatInfo,"$",6)
		s CreTypeCode=$p($g(^PAC("CARD",AppPatCredType)),"^",1)
		if (CreTypeCode="01") {
			s AppPatCredNo=$zcvt(AppPatCredNo,"U")
		}
	}
	s EPMark=##class(web.DHCRBResource).GetEPMarkFlag(+RBASId)
	s CurrDate=..%SysDate()
	s CurrTime=..%SysTime()
	s AppStartTime=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppStartTime",HospitalID)
	s AddStartTime=##class(web.DHCOPRegConfig).GetSpecConfigNode("AddStartTime",HospitalID)
	i AppStartTime'="" s AppStartTime=..%ZTH(AppStartTime)
	i AddStartTime'="" s AddStartTime=..%ZTH(AddStartTime)
	s ASDate=$P($G(^RBAS(+RBASId,$p(RBASId,"||",2))),"^",1)
	//如果为预约则从预约号段中取,否则根据传入参数决定(现场号段,加号段)
	if (RegType="")||(RegType="DOC") s RegType="APP"
	s MethodCode=""
	i MethodDR'="" s MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
	
	s objectDHC = ##class(User.DHCRBApptSchedule).%OpenId(RBASId,0)
	s ASStatusCode=objectDHC.ASStatusDR.ASSCode
	s ASNoLimitLoadFlag=objectDHC.ASNoLimitLoadFlag
	d objectDHC.%Close()
	;停诊或替诊的班次则不能预约
	i (ASStatusCode="S")!(ASStatusCode="TR") Q "-203"
		
	Set objectPar = ##class(User.RBApptSchedule).%OpenId(RBASId,0)
	i '$IsObject(objectPar) Q 100
	s ASSessStartTime=objectPar.ASSessStartTime	
	d objectPar.%Close()
	
	Tstart
	s APPTTransDate=..%SysDate()
	s APPTTransTime=..%SysTime()
	;分为不指定诊号和指定诊号两种情况
	s StartTime="",EndTime=""
	if (TimeRangeStr'=""){
		if (TimeRangeStr'["-") {s TimeRangeStr=""}else{
		s StartTime=$P(TimeRangeStr,"-",1)
		s EndTime=$P(TimeRangeStr,"-",2)}
	}
	s QueueNo=""
	i ((SpecQueueNo="")&&(TimeRangeStr="")) s QueueNo=..GetSeqNo(RBASId,RegType,MethodCode,"",HospitalID)
	else  if (SourceType="LOCK")&&(SpecQueueNo'="") s QueueNo=SpecQueueNo
	e  s QueueNo=..GetSpecSeqNo(RBASId,SpecQueueNo,RegType,MethodCode,"",HospitalID,StartTime,EndTime)
	b ;09334
	if (QueueNo="") {
		if (ASNoLimitLoadFlag'="Y"){
			s rtn="-200"
		}
	}elseif (QueueNo="0") {
		s rtn="-201",QueueNo=""
	}elseif (QueueNo="-1") {
		s rtn="-202",QueueNo=""
	}else{
		if ASDate=CurrDate {
			if (AddStartTime'="")&&(CurrTime<AddStartTime)&&(QueueNo["+") s rtn="-403"
		}else{
		    i (AppStartTime'="")&&(CurrTime<AppStartTime)&&(EPMark'=1) s rtn="-402"
		}
	}
	
	i ($p(rtn,"^")=0) {
		&sql(Insert %NOLOCK %nocheck into SQLUser.RB_Appointment(APPT_AS_ParRef,APPT_PAPMI_DR,APPT_Status,APPT_TransDate,
		APPT_TransTime,APPT_AT_DR,APPT_TransUser_DR,APPT_Method_DR,APPT_ETA,APPT_QueueNo,APPT_Remarks) Values(:RBASId,:PatientID,'I',:APPTTransDate,
		:APPTTransTime,:ApptTypeRowId,:UserDR,:MethodDR,:ASSessStartTime,:QueueNo,:AppNote))
		;b ;gry
		If SQLCODE {
			;RBAppointment 保存失败
			s errorText=$ZERROR
			;s ^TMPerrorGlobal("SaveAppoint",+$h,$j,$p($h,",",2))=errorText_",msg:"_$g(%msg)
			s rtn=100_","_errorText_",msg:"_$g(%msg)
		}else{
			s ApptRowid=$p(%ROWID,$c(1))
			
			s rtn="0^"_ApptRowid_"^"_QueueNo
			//插入扩展表信息
			//if (AppPatInfo'="") {
				s RBAppId=ApptRowid
				set object=##class(User.DHCRBAppointment).%OpenId(RBAppId)
				set object.APPTCredNo=$zcvt(AppPatCredNo,"U")
				set object.APPTMobilePhone=AppPatTel
				set object.APPTPatientName=AppPatName
				set object.APPTPatientAddress=AppPatAddress
				set object.APPTPatType=AppPatType
				i AppPatCredType'="" d object.APPTCredTypeDRSetObjectId(AppPatCredType)
				i ClinicGroupDr'="" d object.APPTClinicGroupDrSetObjectId(ClinicGroupDr)
				Set sc = object.%Save()
				If $$$ISERR(sc) s rtn=100
			//}
		}
	}
	
	i $p(rtn,"^",1)'=0 {
		Trollback
		i (SourceType'="LOCK")&&(QueueNo'="") do ..RestoreSeqNo(RBASId,QueueNo,0)
	}else{
		Tcommit
		;平台组接口
		s RBAppId=$p(rtn,"^",2)
		s rtn1=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDTAKEAPPTSCHEDULEINFO",RBAppId)
		;向Portal推送数据,统一由集成平台接口推送
		;d ##class(DtPortal.Doctor.DHCDocComService).SendAppInfoPortal(RBAppId)
	}
	
	Q rtn
}

ClassMethod NeedAppFee(APPTRowId As %String) As %String
{
	;w ##class(web.DHCRBAppointment).NeedAppFee("7||3||1")
	s Code=""
	Set object =##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s ApptTypeRowId=""
		if $IsObject(object.APPTATDR) s ApptTypeRowId=object.APPTATDR.%Id()
		if ApptTypeRowId'="" {
			s Code=$P(^RBC("AT",ApptTypeRowId),"^",1)
		}
	}
	if (Code="NORN") {Q "0"}
	Q "1"
}

/// 恢复排号,撤消挂号或预约时使用
ClassMethod RestoreSeqNo(RBASId As %String, SeqNo As %String, StatusCode As %String, APPMethodRowId As %String = "", HospitalID As %String = "") As %String
{
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s SingleQueueNoAPPMethodRowIdFrist=""
	s OldStatusCode=""
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
	 	s SingleQueueNo=0
	 	s ASQueueNo=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",4)
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 	Q:NormalQueueNoStr=""
	 	s Find=0
	 	for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	s SingleQueueNo=$P(SingleQueueNoStr,":",1)
		 	s SingleQueueNoAPPMethodRowId=$P(SingleQueueNoStr,":",3)
		 	i (SingleQueueNo=SeqNo) {
			 	s Find=1
			 	s SingleQueueNoAPPMethodRowIdFrist=$P(SingleQueueNoStr,":",3)
			 	s OldStatusCode=$P(SingleQueueNoStr,":",2)
				i APPMethodRowId'="" s SingleQueueNoAPPMethodRowId=APPMethodRowId
			 	if (StatusCode'=0)&&(SingleQueueNoAPPMethodRowId'="") {
		 			s $P(NormalQueueNoStr,",",i)=SeqNo_":"_StatusCode_":"_SingleQueueNoAPPMethodRowId
			 	}else{
		 			s $P(NormalQueueNoStr,",",i)=SeqNo_":"_StatusCode
			 	}
		 	}
	 	}
	 	if Find'=1 {
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s SingleQueueNo=$P(SingleQueueNoStr,":",1)
			 	;s SingleQueueNoAPPMethodRowId=$P(SingleQueueNoStr,":",3)
			 	i (SingleQueueNo=SeqNo) {
				 	s Find=1
		 			s $P(AddQueueNoStr,",",i)=SeqNo_":"_StatusCode
			 	}
		 	}
	 	}
	 	if Find=1 {
		 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
		 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
		 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
	 	}
	}
	s ReturnNotAllowAdd=##class(web.DHCOPRegConfig).GetSpecConfigNode("ReturnNotAllowAdd",HospitalID)
	//只有在退号的时候才增加号源
	//加号的退号,不增号
	if (ReturnNotAllowAdd=1)&&(StatusCode="4")&&(SeqNo'["+")&&(OldStatusCode'=2) {
		;退号不释放资源,增加资源数,方法待增加
		d ..AddOneScheduleQueue(RBASId,SingleQueueNoAPPMethodRowIdFrist)
	}
	;预约回归不释放并增号
	s AppReturnNotAllowRegAdd=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppReturnNotAllowRegAdd",HospitalID)
	if (AppReturnNotAllowRegAdd=1)&&(StatusCode=4)&&(SeqNo'["+")&&(OldStatusCode=2) {
		d ..AddOneScheduleQueue(RBASId,SingleQueueNoAPPMethodRowIdFrist)
	}	
	lock -^RBASLOCK(ResRowId,Childsub)
}

/// 退号不释放资源,增加资源数,方法待增加,需加在锁住^RBAS的程序段内
ClassMethod AddOneScheduleQueue(RBASId As %String, APPMethodRowId As %String = "", HospID As %String = "") As %String
{
	;n (RBASId)
	s ResRowId=$p(RBASId,"||",1)
	s Childsub=$p(RBASId,"||",2)
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
 	;正号串与加号串
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s RandomDateTime=""
	s ResoduSeqNoAnyTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("ResoduSeqNoAnyTime",HospID)
	if (ResoduSeqNoAnyTime=1){
		s RandomDateTime=..GetRandomTime(RBASId)
	} 	
	;诊间加号直接增加一个可挂号的号段
 	if NormalQueueNoStr="" {
	 	s j=0
	 	s oneStr=(j+1)_":0"_"::"_RandomDateTime
 	}else{
	 	;找最大顺序号
	 	s maxQueueNo=##class(web.DHCRBResourceRule).GetMaxQueueNO(NormalQueueNoStr)
	 	s j=$l(NormalQueueNoStr,",")
	 	s oneStr=(maxQueueNo+1)_":0"_"::"_RandomDateTime
 	}
 	s QueueNo=$P(oneStr,":",1)
 	s $P(NormalQueueNoStr,",",j+1)=oneStr
 	
 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
 	if (APPMethodRowId'=""){
	 	//s rtn=##class(web.DHCRBApptScheduleAppQty).NewAppMethod(RBASId,APPMethodRowId,1,QueueNo,1)
	}
	//如果有分时段，在最后一个时段增加一个号
	s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)	
	if (TRFlag="Y"){
		s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",""),-1)
		if (ASTRSub'=""){
			s ASTRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
		 	s k=$l(ASTRQueueNoStr,",")
		 	s $P(ASTRQueueNoStr,",",k+1)=oneStr
 			s $P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)=ASTRQueueNoStr
			s $P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)+1
			
		}
		}
 	Q $l(NormalQueueNoStr,",")
}

ClassMethod TransferAppoint(APPTRowId As %String, NewPatientID As %String, UserRowId As %String) As %String
{
	;&SQL(Update SQLUser.RB_AppointMent Set APPT_PAPMI_DR=:NewPatientID Where APPT_RowId=:APPTRowId )
	;if SQLCODE  Q "-202"
	;w ##class(web.DHCRBAppointment).TransferAppoint("634||2||1",1,6)
	s rtn=100
	TS
	s object=##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s APPTStatus=object.APPTStatus
		;已经取号或取消
		if (APPTStatus="A")!(APPTStatus="X"){
			TRO
			Q "-201"
		}
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		i UserRowId'="" d object.APPTLastStatusChangeUserDRSetObjectId(UserRowId)
		s object.APPTStatus="X"
		s SeqNo=object.APPTQueueNo
		s MethodDR=object.APPTMethodDR.%Id()
		s ASSessStartTime=object.APPTETA
		s RBASId=object.APPTASParRef.%Id()
		s ApptTypeRowId=""
		i (object.APPTATDR) s ApptTypeRowId=object.APPTATDR.%Id()
		Set sc =object.%Save()
		If $$$ISERR(sc) {
			d object.%Close()
			TRO
			Q "-202"
			Do $System.Status.DisplayError()
		}else{
			d object.%Close()
			s MethodCode=""
			Set object = ##class(User.DHCRBApptSchedule).%OpenId(RBASId)
			i $IsObject(object) {
				s ASStatusCode=object.ASStatusDR.ASSCode
				d object.%Close()
			}
			;停诊或替诊的班次则不能预约
			if (ASStatusCode="S")!(ASStatusCode="TR") {
				TRO
				Q "-203"
			}
		
			s object=##class(User.RBAppointment).%New(RBASId)
			d object.APPTASParRefSetObjectId(RBASId)
			d object.APPTPAPMIDRSetObjectId(NewPatientID)
			s object.APPTStatus="I"
			s object.APPTTransDate=..%SysDate()
			s object.APPTTransTime=..%SysTime()
			if UserRowId'="" d object.APPTTransUserDRSetObjectId(UserRowId)
			if MethodDR'="" d object.APPTMethodDRSetObjectId(MethodDR)
			if ApptTypeRowId'="" d object.APPTATDRSetObjectId(ApptTypeRowId)
			s object.APPTETA=ASSessStartTime //EstimatedTime
			s object.APPTQueueNo=SeqNo
			Set sc = object.%Save()
			If $$$ISERR(sc) {
				TRO
				Do $System.Status.DisplayError()
				Q "-204"
			}
			s rtn="0^"_object.%Id()_"^"_SeqNo
		}
	}
	TC
	Q rtn
}

// 得到是否本院职工的标志

// 1 是  0不是

ClassMethod IsVipPatient(EmployeeNo)
{
	q:EmployeeNo="" 0
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(EmployeeNo,"U"),""))
	q:UserID'="" UserID
	q 0
}

/// 查找预约记录
Query Find(AdmDepRowId As %String, AdmDocRowId As %String, StartDate As %Date, EndDate As %Date, PatientNo As %String, PatientID As %String, AppStatus As %String, vRBASID As %String, PatName As %String, PatTel As %String, PatCredNo As %String, TimeRangeRowID As %String, UpdateUser As %String, HospID As %String = "") As %Query(ROWSPEC = "RowId:%String,AppDate:%String,AppTime:%String,DepDesc:%String,DocDesc:%String,PatientID:%String,PatientNo:%String,PatientName:%String,StatusCode:%String,StatusDesc:%String,MethodDesc:%String,QueueNo:%String,Sum:%String,RBASStatusDesc:%String,TRDoc:%String,RBASStatusReason:%String,TransDate:%String,TransTime:%String,TransUserName:%String,StatusChangeDate:%String,StatusChangeTime:%String,StatusChangeUserName:%String,SystemSession:%String,RBASStatusCode:%String,CardCommonAppInfo:%String,PAPERTel:%String,EmployeeFunction:%String,SecretLevel:%String,ReasonForCancel:%String,SessType:%String,AppPatTypeDr:%String,PatientRegNo:%String,PatientAge:%String")
{
}

// 计算资源可用预约记录数  guobaoping

ClassMethod GetMethodAppedQty(ASRowId As %String, APPMethodCode As %String, AppStatus As %String = "I") As %String
{
	
 ;w ##class(web.DHCRBAppointment).GetMethodAppedQty("81||1","I")
	s ResRowId=$P(ASRowId,"||",1)
	s ASChild=$P(ASRowId,"||",2)
	s Count=0
	q:'$d(^RBAS(ResRowId,ASChild,"APPT")) Count
	;预约回归时间,优先取科室设置的回归时间
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	//根据科室设置不同的预约号回归时间
	s loc=$P(^RB("RES",ResRowId),"^",1)
	s LocAppReturnTime=""
	i loc'="" s LocAppReturnTime=$P(^CTLOC(loc),"^",46)
	i LocAppReturnTime'="" s AppReturnTime=LocAppReturnTime
	s ASDate=$P(^RBAS(ResRowId,ASChild),"^",1)
	q:(ASDate<=..%SysDate())&&((AppReturnTime<..%SysTime())&&(+AppReturnTime>0)) Count
	
	;s AppReturnTime=..%SysTime()+100
	s APPChild=0 f  s APPChild=$O(^RBAS(ResRowId,ASChild,"APPT",APPChild)) Q:APPChild=""  d
	.Q:'$D(^RB("RES",ResRowId)) 
	.s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	.s MethodDR=$P(Appt,"^",12)
	.s MethodCode=""
	.i MethodDR'="" s MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
	.q:MethodCode=""
	.q:(APPMethodCode'="")&&(("^"_APPMethodCode_"^")'[("^"_MethodCode_"^"))
	.s StatusCode=$P(Appt,"^",3)
	.Q:(AppStatus'="")&(AppStatus'=StatusCode)
	.;Q:(AppStatus="I")&&(AppReturnTime'>..%SysTime())&&(AppReturnTime>0)
	.s Count=Count+1
	Q Count
}

/// 挂号取号检索预约信息GetAppInfo,GetAppInfoNoCard---lxz
/// 检索有卡预约信息 w ##class(web.DHCRBAppointment).GetAppInfo(5105805)
ClassMethod GetAppInfo(PatientId As %String, AdmReason As %String = "", LogonHospID As %String = "", RegConDisId As %String = "", RegType As %String = "") As %String
{
	//ASRowId+"^"+MarkDesc+"^"+TotalFee+"^"+ExamFee+"^"+HoliFee+"^"+AppFee+"^"+DepDesc+"^"+AppDate+"^"+SpecSeqNo+"^"+ReAdmFeeFlag;
	//w ##class(web.DHCRBAppointment).GetAppInfo(2)
	//set ^GetAppInfo=PatientId
	set UserId=%session.Get("LOGON.USERID")
	set GroupRowId=%session.Get("LOGON.GROUPID")
	set UGRowId=$o(^User.DHCUserGroupI("UserNamedr",UserId,0))
	set FindStatus="",NoAuthorityAppInfo="",HasAuthority=1,CardTypeDesc="",CardTypeRowID="",CardRowID=""
    set AdvanceAppAdm=##class(web.DHCOPRegConfig).GetSpecConfigNode("AdvanceAppAdm") //是否可以提前取预约号
    set AlertMessage=""
    s NoAuthorityAppInfo="",AppInfo=""
    s RBAppRowIDStr=""  //过滤重复预约信息
	Set RESRowId=0
	i AdmReason="" s AdmReason=$$DefaultBillType(PatientId)
	s myCredTypeID=$p($g(^PAPER(PatientId,"PAT",3)),"^",7)
	Set AppInfo=""
	For  Set RESRowId=$o(^PAPERDR(PatientId,"RB_Appt","I",RESRowId)) Quit:RESRowId=""  do
	.Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
	.s CTLocHospDr=$p(^CTLOC(DeptDr),"^",22)
	.q:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
	.Set ASChildSub=0
	.For  Set ASChildSub=$o(^PAPERDR(PatientId,"RB_Appt","I",RESRowId,ASChildSub)) Quit:ASChildSub=""  do
	..Set APPTChildSub=0
	..For  Set APPTChildSub=$o(^PAPERDR(PatientId,"RB_Appt","I",RESRowId,ASChildSub,APPTChildSub)) Quit:APPTChildSub=""  do
	...Set ASRowId=RESRowId_"||"_ASChildSub
	...Set RBAppRowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
	...s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
	...Quit:ASDate<+$h
	...Q:((AdvanceAppAdm'=1)&&(ASDate'=..%SysDate())&&(RegType'="APP"))
	...Q:((RBAppRowIDStr'="")&&(("^"_RBAppRowIDStr_"^")[("^"_RBAppRowID_"^")))
	...do OutAppInfo(ASRowId)
	...i RBAppRowIDStr="" d
	....s RBAppRowIDStr=RBAppRowID
	...e  d
	....s RBAppRowIDStr=RBAppRowIDStr_"^"_RBAppRowID
	
	s DVAnumber=$p($g(^PAPER(PatientId,"PAT",3)),"^",6)
	s DVAnumber=$ZCVT(DVAnumber,"U")
	if ((NoAuthorityAppInfo="")&&(AlertMessage="")&&(DVAnumber'="")) {
		;通过身份证号找预约信息
		s RESRowId=0
		for {
			s RESRowId=$O(^RBAS(0,"CredNo",DVAnumber,RESRowId)) Q:RESRowId=""
			Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
			s CTLocHospDr=$p(^CTLOC(DeptDr),"^",22)
			continue:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
			s ASChildSub=0
			for {
				s ASChildSub=$O(^RBAS(0,"CredNo",DVAnumber,RESRowId,ASChildSub)) Q:ASChildSub=""
				s RBASStatusDr=$P($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
				if (RBASStatusDr'="") {
 					s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 					Q:(RBASStatusCode="TR")
 				}
				s APPTChildSub=0
				for {
					s APPTChildSub=$O(^RBAS(0,"CredNo",DVAnumber,RESRowId,ASChildSub,APPTChildSub)) 
					Q:APPTChildSub=""
					s StatusCode=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3) 
					Continue:(StatusCode="A")
					Continue:(StatusCode="J")
					Continue:(StatusCode="X")
					Set ASRowId=RESRowId_"||"_ASChildSub
					Set RBAppRowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
					s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
					continue:ASDate<+$h
					continue:(AdvanceAppAdm'=1)&&(ASDate'=..%SysDate())
					continue:((RBAppRowIDStr'="")&&(("^"_RBAppRowIDStr_"^")[("^"_RBAppRowID_"^")))
					s APPTCredTypeDR=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub,"DHC")),"^",7)
					continue:(myCredTypeID'=APPTCredTypeDR)&&(APPTCredTypeDR'="")
					do OutAppInfo(ASRowId)
					i (RBAppRowIDStr=""){
						s RBAppRowIDStr=RBAppRowID
					}else {
						s RBAppRowIDStr=RBAppRowIDStr_"^"_RBAppRowID
					} 
				}
			}
		}
		
	}
	s ForeignIDCard=$p($g(^PAPER(PatientId,"PER",2)),"^",4)
	s ForeignCredType=$p($g(^PAPER(PatientId,"ALL")),"^",25)
	if ((NoAuthorityAppInfo="")&&(AlertMessage="")&&(ForeignIDCard'="")) {
		;通过联系人身份证号找预约信息
		s RESRowId=0
		for {
			s RESRowId=$O(^RBAS(0,"CredNo",ForeignIDCard,RESRowId)) Q:RESRowId=""
			Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
			s CTLocHospDr=$p(^CTLOC(DeptDr),"^",22)
			continue:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
			s ASChildSub=0
			for {
				s ASChildSub=$O(^RBAS(0,"CredNo",ForeignIDCard,RESRowId,ASChildSub)) Q:ASChildSub=""
				s RBASStatusDr=$P($g(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
				if (RBASStatusDr'="") {
 					s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 					Q:(RBASStatusCode="TR")
 				}
				s APPTChildSub=0
				for {
					s APPTChildSub=$O(^RBAS(0,"CredNo",ForeignIDCard,RESRowId,ASChildSub,APPTChildSub)) 
					Q:APPTChildSub=""
					s APPPattype=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub,"DHC")),"^",15) 
					continue:((APPPattype="")||(APPPattype=1))
					s StatusCode=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3) 
					Continue:(StatusCode="A")
					Continue:(StatusCode="J")
					Continue:(StatusCode="X")
					Set ASRowId=RESRowId_"||"_ASChildSub
					Set RBAppRowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
					s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
					continue:ASDate<+$h
					continue:(AdvanceAppAdm'=1)&&(ASDate'=..%SysDate())
					continue:((RBAppRowIDStr'="")&&(("^"_RBAppRowIDStr_"^")[("^"_RBAppRowID_"^")))
					s APPTCredTypeDR=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub,"DHC")),"^",7)
					continue:(ForeignCredType'=APPTCredTypeDR)&&(APPTCredTypeDR'="")
					do OutAppInfo(ASRowId)
					i (RBAppRowIDStr=""){
						s RBAppRowIDStr=RBAppRowID
					}else {
						s RBAppRowIDStr=RBAppRowIDStr_"^"_RBAppRowID
					} 
				}
			}
		}
		
	}
	
	set count=$Length(NoAuthorityAppInfo,","),tip=""
	for m=1:1:count d
	 .set tempAppInfo=$p(NoAuthorityAppInfo,",",m)
	 .set DocDesc=$p(tempAppInfo,"^",1)
	 .set LocDesc=$p(tempAppInfo,"^",2)
	 .set tip=tip_"  "_DocDesc_","_LocDesc
	if (count>0)&&(NoAuthorityAppInfo'=""){
		 set AppInfo=AppInfo_"NoAuthority"_tip
	 }
	 if (AlertMessage'="")	 
	 {
		s AppInfo=AppInfo_"NoAuthority"_AlertMessage		 
	 }
	Quit AppInfo
OutAppInfo(ASRowId)	
	;强制自费控制(协和)
	;s DepRowId=##class(web.DHCOPAdmReg).GetDepRowIdByASRowId(ASRowId)
	;i ##class(web.DHCDocHardCoded).IsNeedFocusZF(DepRowId,PatientId)=1 s AdmReason=1
	Set DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(ASRowId,AdmReason,PatientId,"",RegConDisId)
	Set DocDr=$p($g(^RB("RES",RESRowId)),"^",2)
	Set HasAuthority=1
	set AppMethodCode="114"
	set AppointmentMethod=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",12)
	set:AppointmentMethod'="" AppMethodCode=$p(^RBC("APTM",AppointmentMethod),"^",1)
	i AppMethodCode=114 d
	.s CardNO=$p($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub,"DHC")),"^",12)
	.i CardNO'="" d
	..s CardRowID=$o(^DHCCARDi("CF",0,"CardNo",CardNO,""))
	..i CardRowID'="" d
	...s CardTypeRowID=$p(^DHCCARD("CF",CardRowID),"^",16)
	...s:CardTypeRowID'="" CardTypeDesc=$p(^DHCCARDTYPEDef(CardTypeRowID),"^",2)
	...s checkResult=##class(web.DHCOPAdmReg).CheckCardAssociation(CardNO)
	...i ((CardTypeDesc["医保")&&(checkResult=0)) d
	....//且患者读就诊卡后为未关联医保卡病人，要给与提示
	....s AlertMessage="CheckCardAssociation"
	Set GroupRes=##class(web.DHCOPRegConfig).GetGroupRes(GroupRowId)
	//Set:$p($g(^SSU("SSGRP",GroupRowId,"DHC")),"^",1)'[RESRowId HasAuthority=0
	s:(GroupRes'="")&&(("!"_GroupRes_"!")'[("!"_RESRowId_"!")) HasAuthority=0
	//没有权限要提示 并且过滤掉没有权限的预约信息
	//Set:UserId'="" FindStatus=$$UserMark(UserId,DocDr)  
	//set:(FindStatus="")&&(UGRowId'="") HasAuthority=0
	S MarkDesc=$p(^CTPCP(DocDr,1),"^",2)
	i $l(MarkDesc,"(")>1 s MarkDesc=$p(MarkDesc,"(",1)
	Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
	Set DepDesc=$P(^CTLOC(DeptDr),"^",2)     //科室
	s RegFeeDr="",ExamFeeDr="",HoliFeeDr="",AppFeeDr=""
	s RegFee=$p(DocResValue,"^",12)
	s CheckFee=$p(DocResValue,"^",14)
	s HoliFee=$p(DocResValue,"^",16)
	s AppFee=$p(DocResValue,"^",18)
	s ReCheckFee=$p(DocResValue,"^",15)
	s OtherFee=$p(DocResValue,"^",20)
	s TRDesc=$p(DocResValue,"^",21)
	s ScheduleDate=$p(DocResValue,"^",28)
	
	s ReAdmFlag=##class(web.DHCOPAdmReg).GetReAdmFeeFlag(PatientId,ASRowId)
	if ReAdmFlag="1",ReCheckFee'=0 s CheckFee=ReCheckFee
	
	s TotalFee=HoliFee+CheckFee+RegFee+AppFee+OtherFee
	s TotalFee=$fn(TotalFee,"",2)
	Set SpecSeqNo=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",5)
	//如果为分时段预约则显示预约的时段
	s TimeRangeRegInfo=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(ASRowId,SpecSeqNo)
	s:TimeRangeRegInfo'="" TRDesc=$p(TimeRangeRegInfo," ",2)
	s Source=$p($g(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",12)
	i Source'="" s Source=$P(^RBC("APTM",Source),"^",2)
	s ClinicGroupDesc=""
	s ClinicGroupDr=$p($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub,"DHC")),"^",18)
	s:ClinicGroupDr'="" ClinicGroupDesc=$p(^RBC("CLGRP",ClinicGroupDr),"^",2)
	s RowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
	;b ;1241
	if HasAuthority=0 do
	.if NoAuthorityAppInfo="" do
	..Set NoAuthorityAppInfo=MarkDesc_"^"_DepDesc
	.else  do
	..Set NoAuthorityAppInfo=NoAuthorityAppInfo_","_MarkDesc_"^"_DepDesc
	else   do
	.if AppInfo="" do
	..Set AppInfo=ASRowId_"^"_MarkDesc_"^"_TotalFee_"^"_CheckFee_"^"_HoliFee_"^"_AppFee_"^"_DepDesc_"^"_ScheduleDate_"^"_SpecSeqNo_"^"_ReAdmFlag_"^"_""_"^"_""_"^"_TRDesc_"^"_Source_"^"_RowID_"^^"_ClinicGroupDr_"^"_ClinicGroupDesc
	.else   do
	..Set AppInfo=AppInfo_","_ASRowId_"^"_MarkDesc_"^"_TotalFee_"^"_CheckFee_"^"_HoliFee_"^"_AppFee_"^"_DepDesc_"^"_ScheduleDate_"^"_SpecSeqNo_"^"_ReAdmFlag_"^"_""_"^"_""_"^"_TRDesc_"^"_Source_"^"_RowID_"^^"_ClinicGroupDr_"^"_ClinicGroupDesc
	
	Q
DefaultBillType(PatientID)
	if PatientID="" Q ""
	set PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	i PatCatDr'="" set DHCPACADMDr=$O(^DHCPACADM(0,"Social",PatCatDr,""))
	set AdmReason=""
	if $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
UserMark(UserId,DocDr)
	s FindStatus=""	
	s UserRowId=0 f  Set UserRowId=$o(^User.DHCUserGroupI("UserNamedr"," "_UserId,UserRowId)) quit:(UserRowId="")!(FindStatus'="")  d
	.s UserDocDr=$list(^User.DHCUserGroupD(UserRowId),2)
	.if (UserDocDr=DocDr) S FindStatus=UserDocDr
	Quit FindStatus
}

/// 检索无卡预约信息  add by guorongyong
ClassMethod GetAppInfoNoCard(SystemSess As %String, AdmReason As %String, LogonHospID As %String = "", RegConDisId As %String = "") As %String
{
	s ^Tempzong("GetAppInfoNoCard")=SystemSess_","_AdmReason
	
	//s ^tmpgry("GetAppInfoNoCard")=SystemSess+"^"+AdmReason
	//w ##class(web.DHCRBAppointment).GetAppInfoNoCard(316652336,14)
	set UserId=%session.Get("LOGON.USERID")
	set GroupRowId=%session.Get("LOGON.GROUPID")
	set UGRowId=$o(^User.DHCUserGroupI("UserNamedr",UserId,0))
	set FindStatus="",NoAuthorityAppInfo="",HasAuthority=1
	set AdvanceAppAdm=##class(web.DHCOPRegConfig).GetSpecConfigNode("AdvanceAppAdm") //是否可以提前取预约号
	
    
    s AppMethodStr=" 114 "
	s DHCAppt=##class(web.DHCOPAdmReg).GetDHCApptByAppSerialNo(SystemSess,AppMethodStr)
	s APPTRowid=$p(DHCAppt,"^",1)
	s AppInfo=""
	if APPTRowid'="" do
	.Set RESRowId=$p(APPTRowid,"||",1)
	.Set ASChildSub=$p(APPTRowid,"||",2)
	.Set APPTChildSub=$p(APPTRowid,"||",3)
	.Set ASRowId=RESRowId_"||"_ASChildSub
	.s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
	.Quit:ASDate<+$h
	.Q:(AdvanceAppAdm'=1)&&(ASDate'=..%SysDate())
	.;非预约状态则退出
	.s StatusCode=$P($G(^RBAS(+ASRowId,ASChildSub,"APPT",APPTChildSub)),"^",3) 
	.Q:(StatusCode="A")
	.Q:(StatusCode="J")
	.Q:(StatusCode="X")
	.;强制自费控制(协和)
	.;s DepRowId=##class(web.DHCOPAdmReg).GetDepRowIdByASRowId(ASRowId)
	.;i ##class(web.DHCDocHardCoded).IsNeedFocusZF(DepRowId,"",AdmReason)=1 s AdmReason=1
	.Set DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(ASRowId,AdmReason,"","",RegConDisId)
	.Set DocDr=$p(^RB("RES",RESRowId),"^",2)
	.Set HasAuthority=1
	.Set:$p(^SSU("SSGRP",GroupRowId,"DHC",LogonHospID),"^",1)'[RESRowId HasAuthority=0
	.//没有权限要提示 并且过滤掉没有权限的预约信息
	.//Set:UserId'="" FindStatus=$$UserMark(UserId,DocDr)  
	.//set:(FindStatus="")&&(UGRowId'="") HasAuthority=0
	.S MarkDesc=$p(^CTPCP(DocDr,1),"^",2)
	.i $l(MarkDesc,"(")>1 s MarkDesc=$p(MarkDesc,"(",1)
	.Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
	.s CTLocHospDr=$p(^CTLOC(DeptDr),"^",22)
	.q:(LogonHospID'="")&&(CTLocHospDr'=LogonHospID)
	.Set DepDesc=$P(^CTLOC(DeptDr),"^",2)     //科室
	.s RegFeeDr="",ExamFeeDr="",HoliFeeDr="",AppFeeDr=""
	.s RegFee=$p(DocResValue,"^",12)
	.s CheckFee=$p(DocResValue,"^",14)
	.s HoliFee=$p(DocResValue,"^",16)
	.s AppFee=$p(DocResValue,"^",18)
	.s ReCheckFee=$p(DocResValue,"^",15)
	.s OtherFee=$p(DocResValue,"^",20)
	.s TRDesc=$p(DocResValue,"^",21)
	.s ScheduleDate=$p(DocResValue,"^",28)
	.s TotalFee=HoliFee+CheckFee+RegFee+AppFee+OtherFee
	.s TotalFee=$fn(TotalFee,"",2)
	.Set SpecSeqNo=$p(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub),"^",5)
	.s Source=$p(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub),"^",12)
	.i Source'="" s Source=$P(^RBC("APTM",Source),"^",2)
	.s RowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
	.if HasAuthority=0 do
	..if NoAuthorityAppInfo="" do
	...Set NoAuthorityAppInfo=MarkDesc_"^"_DepDesc
	..else  do
	...Set NoAuthorityAppInfo=NoAuthorityAppInfo_","_MarkDesc_"^"_DepDesc
	.else   do
	..if AppInfo="" do
	...Set AppInfo=ASRowId_"^"_MarkDesc_"^"_TotalFee_"^"_CheckFee_"^"_HoliFee_"^"_AppFee_"^"_DepDesc_"^"_ScheduleDate_"^"_SpecSeqNo_"^"_0_"^"_""_"^"_""_"^"_TRDesc_"^"_Source_"^"_RowID
	..else   do
	...Set AppInfo=AppInfo_","_ASRowId_"^"_MarkDesc_"^"_TotalFee_"^"_CheckFee_"^"_HoliFee_"^"_AppFee_"^"_DepDesc_"^"_ScheduleDate_"^"_SpecSeqNo_"^"_0_"^"_""_"^"_""_"^"_TRDesc_"^"_Source_"^"_RowID
	set count=$Length(NoAuthorityAppInfo,","),tip=""
	for m=1:1:count d
	 .set tempAppInfo=$p(NoAuthorityAppInfo,",",m)
	 .set DocDesc=$p(tempAppInfo,"^",1)
	 .set LocDesc=$p(tempAppInfo,"^",2)
	 .set tip=tip_"  "_DocDesc_","_LocDesc
	if (count>0)&&(NoAuthorityAppInfo'=""){
		 set AppInfo=AppInfo_"NoAuthority"_tip
	 }
	 
	Quit AppInfo
}

ClassMethod GetBlackListEndDate(PatientId As %String, IDCardNo As %String)
{
	Set LimitAppFlag=0
	if PatientId'="" {
		Set EndDate=""  
		Set PBLRowid=""
		for  Set PBLRowid=$o(^DHCPBL(0,"PAPMI",PatientId,PBLRowid),-1) Quit:(PBLRowid="")||(EndDate'="")  do
		.Set Type=$p(^DHCPBL(PBLRowid),"^",1)
		.Quit:Type'="R"
		.Set EndDate=$p(^DHCPBL(PBLRowid),"^",4)
	}
	if IDCardNo'="" {
		Set PBLRowid=""
		Set EndDate=""
		for  Set PBLRowid=$o(^DHCPBL(0,"IDCardNo",IDCardNo,PBLRowid),-1) Quit:(PBLRowid="")||(LimitAppFlag=1)  do
		.Set Type=$p(^DHCPBL(PBLRowid),"^",1)
		.Quit:Type'="R"
		.Set EndDate=$p(^DHCPBL(PBLRowid),"^",4)
	}
	Quit EndDate
}

/// w ##class(web.DHCRBAppointment).GetLimitAppFlag("","371102199803032323")
ClassMethod GetLimitAppFlag(PatientId As %String, IDCardNo As %String, HospID = "")
{
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_BlackListType",HospID)
	Set LimitAppDays=$p($g(^BlackDateAndCountConfig("Config")),"^",1)
	Set LimitAppFlag=0
	Set LimitAppDate="",PBTypeExeResult=""
	s CommonCardNoId=##class(web.DHCOPAdmReg).GetCommonPatientID()
	if PatientId'=""{
		if (("^"_CommonCardNoId_"^")'[("^"_PatientId_"^")) {
			Set PBLRowid=""
			for  Set PBLRowid=$o(^DHCPBL(0,"PAPMI",PatientId,PBLRowid),-1) Quit:(PBLRowid="")||(LimitAppFlag=1)  do
			.Set Type=$p(^DHCPBL(PBLRowid),"^",1)
			.Quit:Type'="R"
			.Set PBLDate= $p(^DHCPBL(PBLRowid),"^",4)
			.Set Activeflag=$p(^DHCPBL(PBLRowid),"^",8)
			.Quit:Activeflag=0
			.s PBTypeDr=$p(^DHCPBL(PBLRowid),"^",12)
			.s PBTypeExeResult=""
			.q:(PBTypeDr'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_BlackListType",PBTypeDr,HospID))
			.if (PBTypeDr'="")&&($d(^DHCBlackType("DHCBlackType",PBTypeDr))) d
			..s ExecuteCode=$P(^DHCBlackType("DHCBlackType",PBTypeDr),"^",3)
			..i ExecuteCode'="" d
			...s Expression=$tr(ExecuteCode,"&","""")
			...s Expression="s PBTypeExeResult="_Expression
			...X Expression
			.if ((+LimitAppDays=0))||((PBLDate+(+LimitAppDays))>=(+$h))  do
			..Set LimitAppFlag=1
			..Set LimitAppDate=$zd(PBLDate+(+LimitAppDays),3)
			Quit:LimitAppFlag=1 LimitAppFlag_"^"_LimitAppDate_"^"_PBTypeExeResult
		
			Set IDCardNo1=$p(^PAPER(PatientId,"ALL"),"^",9)
			if IDCardNo1'="" {
				Set PBLRowid=""
				for  Set PBLRowid=$o(^DHCPBL(0,"IDCardNo",IDCardNo1,PBLRowid),-1) Quit:(PBLRowid="")||(LimitAppFlag=1)  do
				.Set Type=$p(^DHCPBL(PBLRowid),"^",1)
				.Quit:Type'="R"
				.Set PBLDate= $p(^DHCPBL(PBLRowid),"^",4)
				.Set Activeflag=$p(^DHCPBL(PBLRowid),"^",8)
				.Quit:Activeflag=0
				.s PBTypeDr=$p(^DHCPBL(PBLRowid),"^",12)
				.s PBTypeExeResult=""
				.q:(PBTypeDr'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_BlackListType",PBTypeDr,HospID))
				.if (PBTypeDr'="")&&($d(^DHCBlackType("DHCBlackType",PBTypeDr))) d
				..s ExecuteCode=$P(^DHCBlackType("DHCBlackType",PBTypeDr),"^",3)
				..i ExecuteCode'="" d
				...s Expression=$tr(ExecuteCode,"&","""")
				...s Expression="s PBTypeExeResult="_Expression
				...X Expression
				.if ((+LimitAppDays=0))||((PBLDate+(+LimitAppDays))>=(+$h))  do
				..Set LimitAppFlag=1
				..Set LimitAppDate=$zd(PBLDate+(+LimitAppDays),3)
				Quit:LimitAppFlag=1 LimitAppFlag_"^"_LimitAppDate_"^"_PBTypeExeResult	
			}
		}
	}
	if IDCardNo'="" {
		Set PBLRowid=""
		for  Set PBLRowid=$o(^DHCPBL(0,"IDCardNo",IDCardNo,PBLRowid),-1) Quit:(PBLRowid="")||(LimitAppFlag=1)  do
		.Set Type=$p(^DHCPBL(PBLRowid),"^",1)
		.Quit:Type'="R"
		.Set PBLDate= $p(^DHCPBL(PBLRowid),"^",4)
		.Set Activeflag=$p(^DHCPBL(PBLRowid),"^",8)
		.Quit:Activeflag=0
		.s PBTypeDr=$p(^DHCPBL(PBLRowid),"^",12)
		.q:(PBTypeDr'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_BlackListType",PBTypeDr,HospID))
		.s PBTypeExeResult=""
		.if (PBTypeDr'="")&&($d(^DHCBlackType("DHCBlackType",PBTypeDr))) d
		..s ExecuteCode=$P(^DHCBlackType("DHCBlackType",PBTypeDr),"^",3)
		..i ExecuteCode'="" d
		...s Expression=$tr(ExecuteCode,"&","""")
		...s Expression="s PBTypeExeResult="_Expression
		...X Expression
		.if ((+LimitAppDays=0))||((PBLDate+(+LimitAppDays))>=(+$h))  do
		..Set LimitAppFlag=1
		..Set LimitAppDate=$zd(PBLDate+(+LimitAppDays),3)
		Quit:LimitAppFlag=1 LimitAppFlag_"^"_LimitAppDate_"^"_PBTypeExeResult			
	}
	Quit LimitAppFlag_"^"_LimitAppDate_"^"_PBTypeExeResult
}

/// 统计违约记录,生成黑名单
ClassMethod CreateBreakRecord(StartDate As %Date, TRCode As %String = "") As %String
{
	;w ##class(web.DHCRBAppointment).CreateBreakRecord("2014-12-10","")
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s CurrentTime=..%SysTime()
	s TimeRange=##class(web.DHCRBResSession).GetTimeRangeByCode(TRCode)
	if StartDate="" s StartDate=..%SysDate()-1
	s CommonCardNoId=##class(web.DHCOPAdmReg).GetCommonPatientID()
	s TypeRowid=""
	s TypeR=""
	for {
		s TypeRowid=$O(^DHCBlackType("DHCBlackType",TypeRowid))
		q:TypeRowid=""
		s typedesc=$P(^DHCBlackType("DHCBlackType",TypeRowid),"^",2)
		if typedesc="预约" s TypeR=TypeRowid
		q:TypeR'=""
	}
	k ^DHCBlackListTemp($j)
	k ^DHCBlackListTempIDCard($j)
	s AppDate=StartDate
	s ResRowId=0  f  s ResRowId=$O(^RBAS("APPT_Date",ResRowId)) Q:ResRowId=""  d
	.s AppTime=0 f  s AppTime=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime)) Q:AppTime=""  d
	..s ASChild=0 f  s ASChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild)) Q:ASChild=""  d
	...s APPChild=0 f  s APPChild=$O(^RBAS("APPT_Date",ResRowId,AppDate,AppTime,ASChild,APPChild)) Q:APPChild=""  d
	....Q:'$D(^RB("RES",ResRowId))
	.... ;判断当前排班记录的时段是否是当前时段
	....Set SessStartTime=$P($g(^RBAS(ResRowId,ASChild)),"^",4)
	....Quit:SessStartTime=""
	....Set SessTimeRange=$P($g(^RBAS(ResRowId,ASChild,"DHC")),"^",17)
	....s APPTRowId=ResRowId_"||"_ASChild_"||"_APPChild
	....s APPTStatus=""
	....S object =##class(User.RBAppointment).%OpenId(APPTRowId)
	....i $IsObject(object) {s APPTStatus=object.APPTStatus}
	....;Q:APPTStatus'="I"
	....;判断I或J的 因为可能启用了分时段回归
	....Q:(APPTStatus'="I")&&(APPTStatus'="J")
	....s status=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",10)
	....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	....;过滤停诊和替诊
	....TS
	....i (status="S")||(status="TR") d
	.....s err=..CancelAppointment(APPTRowId)
	....e  d
	.....s err=..AppBreak(APPTRowId)
	....if err tro
	....Q:err
	....Tc
	....;Quit:(status="S")||(status="TR")
	....s Appt=$G(^RBAS(ResRowId,ASChild,"APPT",APPChild))
	....s AppPatientID=$P(Appt,"^",2)
	....;公共卡为无卡预约
	....if ((("^"_CommonCardNoId_"^")'[("^"_AppPatientID_"^"))&&(AppPatientID'="")) do     
	.....s ^DHCBlackListTemp($j,AppPatientID)=""
	....else  do
	.....Set IDCardNo=$P($G(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",8)
	.....Set Name=$P($G(^RBAS(ResRowId,ASChild,"APPT",APPChild,"DHC")),"^",1)
	.....s ^DHCBlackListTempIDCard($j,IDCardNo)=Name
	
	;当前时间小于违约时间不执行违约操作
	s AppBreakLimit=$p($g(^BlackDateAndCountConfig("Config")),"^",2)
	if (AppBreakLimit="")!(AppBreakLimit=0){
		k ^DHCBlackListTemp($j)
		k ^DHCBlackListTempIDCard($j)
		Q 0
	}
	
	;以下是统计爽约次数
	k BlackListCount
	Set PatientId=0
	for  Set PatientId=$o(^DHCBlackListTemp($j,PatientId))  Quit:PatientId=""  do
	.;公共卡
	.Quit:(("^"_CommonCardNoId_"^")[("^"_PatientId_"^"))
	.Set BlackListDate=..GetBlackListEndDate(PatientId,"")
	.Set ResRowid=0
	.for  Set ResRowid=$o(^PAPERDR(PatientId,"RB_Appt","J",ResRowid)) Quit:ResRowid=""  do
	..Set ASChild=0
	..For  Set ASChild=$o(^PAPERDR(PatientId,"RB_Appt","J",ResRowid,ASChild)) Quit:ASChild=""  do
	...Set ASDate=$p(^RBAS(ResRowid,ASChild),"^",1)
	...Set SYConfigDate=$p($g(^BlackDateAndCountConfig("Config")),"^",3)     //生成黑名单的时间范围
    ... ;如果没有维护时间范围且之前无黑名单记录,查找全部爽约记录，若此病人有黑名单记录,则从上次生成黑名单日期之后查询
	...i (+SYConfigDate=0)  Quit:ASDate<BlackListDate
    ...;如果维护了时间范围,则从这个时间范围内查找爽约记录,若此病人有黑名单记录,则从上次生成黑名单日期之后查询   
	...i (+SYConfigDate'=0) Quit:ASDate<((+$h)-SYConfigDate)&&(ASDate<BlackListDate)
	...Set APPChild=0
	...for  Set APPChild=$o(^PAPERDR(PatientId,"RB_Appt","J",ResRowid,ASChild,APPChild)) Quit:APPChild=""  do
	....s BlackListCount(PatientId)=$g(BlackListCount(PatientId))+1
	
	Set ConfigCount=$p($g(^BlackDateAndCountConfig("Config")),"^",2)
	Set PatientId=0
	for  Set PatientId=$o(BlackListCount(PatientId)) Quit:PatientId=""  do
	.Set Count=BlackListCount(PatientId)
	.Quit:Count<ConfigCount
	.s err=..InsertBlackList("R",PatientId,"","","",TypeR,"")

	//公共卡违约(或无卡违约)查找身份信息
	Set IDCardNo=0
	for  Set IDCardNo=$o(^DHCBlackListTempIDCard($j,IDCardNo)) Quit:IDCardNo=""  do  //=Name
	.Set BlackListDate=..GetBlackListEndDate("",IDCardNo)
	.Set RESRowId=0
	.for  Set RESRowId=$o(^RBAS(0,"CredNo",IDCardNo,RESRowId)) Quit:RESRowId=""  do
	..Set ASChildSub=0
	..for  Set ASChildSub=$o(^RBAS(0,"CredNo",IDCardNo,RESRowId,ASChildSub)) Quit:ASChildSub=""  do
	...s ASDate=$P($G(^RBAS(RESRowId,ASChildSub)),"^",1)
	...Set SYConfigDate=$p($g(^BlackDateAndCountConfig("Config")),"^",3) 
	...i (+SYConfigDate=0)  Quit:ASDate<BlackListDate
	...i (+SYConfigDate'=0) Quit:ASDate<((+$h)-SYConfigDate)&&(ASDate<BlackListDate)
	...Set APPTChildSub=0
	...for  s APPTChildSub=$o(^RBAS(0,"CredNo",IDCardNo,RESRowId,ASChildSub,APPTChildSub)) Quit:APPTChildSub=""  do
	....s status=$P($G(^RBAS(RESRowId,ASChildSub,"DHC")),"^",10)
	....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	....Quit:(status="S")!(status="TR")
	....Set AdmStatus=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3)
	....Quit:AdmStatus'="J"
	....s BlackListCountIDCard(IDCardNo)=$g(BlackListCountIDCard(IDCardNo))+1
	Set IDCardNo=0
	for  Set IDCardNo=$o(BlackListCountIDCard(IDCardNo)) Quit:IDCardNo=""  do
	.Set Count=BlackListCountIDCard(IDCardNo)
	.Quit:Count<ConfigCount
	.Set Name=^DHCBlackListTempIDCard($j,IDCardNo)
	.s err=..InsertBlackList("R","",IDCardNo,Name,"",TypeR,"")
	
	k ^DHCBlackListTemp($j)
	k ^DHCBlackListTempIDCard($j)
	
 	Q 1
}

/// Description:黑名单期间若再次出现爽约，自动将黑名单开始时间设置为最新的爽约时间
/// Creator:nikang
/// CreateTime:20180317
/// w ##class(web.DHCRBAppointment).UpdateBlackDate("423||672||4")
ClassMethod UpdateBlackDate(APPTRowID As %String)
{
	s ret=0
	s ResRowId=+APPTRowID
	s ASChild=$p(APPTRowID,"||",2)
	s APPChild=$p(APPTRowID,"||",3)
	Set LimitAppDays=$p($g(^BlackDateAndCountConfig("Config")),"^",1)
	s PatientId=$p($g(^RBAS(ResRowId,ASChild,"APPT",APPChild)),"^",2)
	if PatientId'=""{
		set FindPBLRowid=""
		Set PBLRowid=""
		for  Set PBLRowid=$o(^DHCPBL(0,"PAPMI",PatientId,PBLRowid),-1) Quit:(PBLRowid="")||(FindPBLRowid'="")  do
		.Set Type=$p(^DHCPBL(PBLRowid),"^",1)
		.Quit:Type'="R"
		.Set PBLDate= $p(^DHCPBL(PBLRowid),"^",4)
		.Set Activeflag=$p(^DHCPBL(PBLRowid),"^",8)
		.Quit:Activeflag=0
		.if ((+LimitAppDays=0))||((PBLDate+(+LimitAppDays))>(+$h))  do
		..Set FindPBLRowid=PBLRowid
		if (FindPBLRowid'=""){
			Set object = ##class(User.DHCPAPersonBlackList).%OpenId(FindPBLRowid)
			s object.PBDate=..%SysDate()
			s object.PBTime=..%SysTime()
			Set sc = object.%Save()
			If $$$ISERR(sc) {
				;Do $System.Status.DisplayError()
				s ret=100
			}
			d object.%Close()
		}
		
	}
	Q ret
}

/// w ##class(web.DHCRBAppointment).InsertBlackList("R","","642102198003200063","沙海燕")
ClassMethod InsertBlackList(PBType As %String, PatientID As %String, IDCardNo As %String, Name As %String = "", AddUserID As %String = "", BlackType As %String = "", BlackNote As %String = "", StartDate As %String = "", EndDate As %String = "") As %String
{
	if IDCardNo="" Set IDCardNo=$p(^PAPER(PatientID,"ALL"),"^",9)
	if IDCardNo="" Set IDCardNo=$p(^PAPER(PatientID,"PAT",3),"^",6)
	Set myPBLRowid=""
	Set PBLRowid=""
	set PatientNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	s CheckPatientFlag=##class(web.InExportApp).CheckforBlackList(BlackType,"","",PatientNo,IDCardNo)
	if (CheckPatientFlag'=0){
		s PBLRowid=$P(CheckPatientFlag,"^",2)
	}
	/*if (PatientID'=""){
		for{
			Set myPBLRowid=$o(^DHCPBL(0,"PAPMI",PatientID,myPBLRowid),-1)
			q:(myPBLRowid="")||(PBLRowid'="")
			Set Type=$p(^DHCPBL(myPBLRowid),"^",1)
			continue:Type'="R"
			s PBLRowid=myPBLRowid
		}
	}elseif IDCardNo'="" {
		for{
			Set myPBLRowid=$o(^DHCPBL(0,"IDCardNo",IDCardNo,myPBLRowid),-1)
			q:(myPBLRowid="")||(PBLRowid'="")
			Set Type=$p(^DHCPBL(myPBLRowid),"^",1)
			continue:Type'="R"
			s PBLRowid=myPBLRowid
		}
	}*/
	s Longdate=$P($G(^BlackDateAndCountConfig("Config")),"^",1)
	i StartDate'="" s StartDate=..%ZDH(StartDate)
    i EndDate'=""   s EndDate=..%ZDH(EndDate)
    if (StartDate="") s StartDate=..%SysDate()
    if (EndDate="") s EndDate=..%SysDate()+Longdate
	if (PBLRowid'=""){
		Set object =##class(User.DHCPAPersonBlackList).%OpenId(PBLRowid)
	}else{
		Set object = ##class(User.DHCPAPersonBlackList).%New()
	}
	d object.PBPAPMIDRSetObjectId(PatientID)
	s object.PBType=PBType
	s object.PBDate=..%SysDate()
	s object.PBTime=..%SysTime()
	s object.PBActiveFlag=1
	s object.PBIDCardNo=IDCardNo
	s object.PBIDName=Name
	if AddUserID'="" d object.PBAddUserDrSetObjectId(AddUserID)
	if BlackType'="" d object.PBBlackTypeDrSetObjectId(BlackType)
	s object.PBNote=BlackNote
	s object.PBActiveStartDate=StartDate
	s object.PBActiveEndDate=EndDate
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Tro
		Do $System.Status.DisplayError()
		Q 100
	}
	d object.%Close()
	Q 0
}

/// 爽约
ClassMethod AddAppBreak(APPTRowId As %String, UserDR As %String, HospitalID As %String = "") As %String
{
	;w ##class(web.DHCRBAppointment).AppBreak("20||2||9")
	s object=##class(User.RBAppointment).%OpenId(APPTRowId)
	i $IsObject(object) {
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		s object.APPTStatus="J"
		s object.APPTLastStatusChangeDate=..%SysDate()
		s object.APPTLastStatusChangeTime=..%SysTime()
		if UserDR'="" d object.APPTLastStatusChangeUserDRSetObjectId(UserDR)
		;
		;s SeqNo=object.APPTQueueNo
		;
		Set sc =object.%Save()
		If $$$ISERR(sc) {
			d object.%Close()
			;Tro
			;Do $System.Status.DisplayError()
			Quit 100
		}else{
			d object.%Close()
			;
			/*Set StatusCode=0
			Set RBASId=$P(APPTRowId,"||",1,2)
			Do ..RestoreSeqNo(RBASId, SeqNo, StatusCode)*/
			Do ..UpdateBlackDate(APPTRowId)

			Quit 0
		}
	}
	Quit 0
}

// 512501197506045175

// w ##class(web.DHCRBAppointment).GetAppedCommomInfo("532628197808216311")

ClassMethod GetAppedCommomInfo(CredNo As %String, CredTypeDR As %String = "") As %String
{
	q:CredNo="" "0^^"
	k ^tempComCardAppedInfo($j)
	s CurrentTime=..%SysTime(),Date=0,Time=0,LastAppenTelH="",LastAppenPatName=""
	s ResRowId=0
	f  s ResRowId=$o(^RBAS(0,"CredNo",CredNo,ResRowId)) q:ResRowId=""  d
	.s ASChildSub=0
	.f  s ASChildSub=$o(^RBAS(0,"CredNo",CredNo,ResRowId,ASChildSub)) q:ASChildSub=""  d
	..s APPTChildsub=0
	..f  s APPTChildsub=$o(^RBAS(0,"CredNo",CredNo,ResRowId,ASChildSub,APPTChildsub))   q:APPTChildsub=""  d
	...s AppedInfo=$g(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildsub,"DHC"))
	...q:AppedInfo=""
	...s APPTCredTypeDR=$p($g(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildsub,"DHC")),"^",7)
	...q:((CredTypeDR'="")&&(CredTypeDR'=APPTCredTypeDR))
	...s APPTStatus=$p(AppedInfo,"^",3)
	...q:(APPTStatus="J")||(APPTStatus="X")
	...s TransDate=$P(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildsub),"^",8) //$P(AppedInfo,"^",8)
	...s AdmDate=$P($G(^RBAS(ResRowId,ASChildSub)),"^",1)
	...q:AdmDate<+$h
	...s APPTAdmDR=$p(AppedInfo,"^",4)
	...s APPTQueueNo=$p(AppedInfo,"^",5)
	...Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(ResRowId_"||"_ASChildSub,APPTQueueNo) 
	...if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
	...e  d
	....s AppReturnTime=0
	....s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	....if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	....Set AppReturnTime2=AppReturnTime 
	...q:(APPTAdmDR="")&&(CurrentTime>AppReturnTime2)&&(AdmDate=..%SysDate())
	...s APPTTelH=$p(AppedInfo,"^",5)
	...s APPTPatientName=$p(AppedInfo,"^",1)
	...s TransTime=$P(^RBAS(ResRowId,ASChildSub,"APPT",APPTChildsub),"^",9)
	...i ((TransDate>Date)||((TransDate=Date)&&(TransTime>Time))) s LastAppenTelH=APPTTelH,LastAppenPatName=APPTPatientName s Date=TransDate,Time=TransTime
	...s ^tempComCardAppedInfo($j,ResRowId_"||"_ASChildSub_"||"_APPTChildsub)=APPTTelH_"^"_APPTPatientName
	q:(LastAppenTelH="")&&(LastAppenPatName="") "0^^"
	s DifferenceAppInfo=""
	s ApptRowId=0
	f  s ApptRowId=$o(^tempComCardAppedInfo($j,ApptRowId)) q:ApptRowId=""  d
	.s str=$g(^tempComCardAppedInfo($j,ApptRowId))
	.s APPTTelH=$p(str,"^",1)
	.s APPTPatName=$p(str,"^",2)
	.q:(APPTTelH=LastAppenTelH)&&(APPTPatName=LastAppenPatName)
	.i DifferenceAppInfo="" s DifferenceAppInfo="姓名:"_APPTPatName_"  "_"电话:"_APPTTelH
	.e  s DifferenceAppInfo=DifferenceAppInfo_"<br/>"_"姓名:"_APPTPatName_"  "_"电话:"_APPTTelH
	k ^tempComCardAppedInfo($j)
	q "1"_"^"_LastAppenPatName_"$"_LastAppenTelH_"^"_DifferenceAppInfo
}

/// 修改无卡预约患者姓名身份证号电话
ClassMethod UpDateApptInfo(RBAppId As %String, AppPatCredNo As %String, AppPatTel As %String, AppPatName As %String, AppPatType As %String, AppPatCredType As %String = "")
{
	q:RBAppId="" ""
	set object=##class(User.DHCRBAppointment).%OpenId(RBAppId)
	set object.APPTCredNo=AppPatCredNo
	set object.APPTMobilePhone=AppPatTel
	set object.APPTPatientName=AppPatName
	set object.APPTPatType=AppPatType
	i AppPatCredType'="" d object.APPTCredTypeDRSetObjectId(AppPatCredType)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	q 0
}

/// 得到患者今天是否有爽约记录
/// w ##class(web.DHCRBAppointment).GetAppBreakInfo(1)
ClassMethod GetAppBreakInfo(PatientID As %String, LogonHospID As %String = "")
{
	q:PatientID="" ""
	if (LogonHospID="")&&($d(%session)) s LogonHospID=%session.Get("LOGON.HOSPID")
	s IRBAppRowIDStr="",JRBAppRowIDStr=""  //过滤重复预约信息
	s APPTStatusStr="I^J"
	for i=1:1:$l(APPTStatusStr,"^") d
	.s APPTStatus=$p(APPTStatusStr,"^",i)
	.Set RESRowId=0
	.For  Set RESRowId=$o(^PAPERDR(PatientID,"RB_Appt",APPTStatus,RESRowId)) Quit:RESRowId=""  do
	..Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
	..Set DeptHospDt=$p(^CTLOC(DeptDr),"^",22)
	..Q:(DeptHospDt'=LogonHospID)&&(LogonHospID'=0)
	..Set ASChildSub=0
	..For  Set ASChildSub=$o(^PAPERDR(PatientID,"RB_Appt",APPTStatus,RESRowId,ASChildSub)) Quit:ASChildSub=""  do
	...Set APPTChildSub=0
	...For  Set APPTChildSub=$o(^PAPERDR(PatientID,"RB_Appt",APPTStatus,RESRowId,ASChildSub,APPTChildSub)) Quit:APPTChildSub=""  do
	....Set ASRowId=RESRowId_"||"_ASChildSub
	....Set RBAppRowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
	....s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
	....Quit:ASDate'=..%SysDate()
	....s StatusCode=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3) 
	....if ((("^"_IRBAppRowIDStr_"^")'[("^"_RBAppRowID_"^"))&&(StatusCode="I")) d
	.....i IRBAppRowIDStr="" d
	......s IRBAppRowIDStr=RBAppRowID
	.....e  d
	......s IRBAppRowIDStr=IRBAppRowIDStr_"^"_RBAppRowID
	....if ((("^"_JRBAppRowIDStr_"^")'[("^"_RBAppRowID_"^"))&&(StatusCode="J")) d
	.....i JRBAppRowIDStr="" d
	......s JRBAppRowIDStr=RBAppRowID
	.....e  d
	......s JRBAppRowIDStr=JRBAppRowIDStr_"^"_RBAppRowID
	
	s DVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	s DVAnumber=$ZCVT(DVAnumber,"U")
	if (DVAnumber'=""){
		;通过身份证号找预约信息
		s RESRowId=0
		for {
			s RESRowId=$O(^RBAS(0,"CredNo",DVAnumber,RESRowId)) Q:RESRowId=""
			Set DeptDr=$p(^RB("RES",RESRowId),"^",1)
			Set DeptHospDt=$p(^CTLOC(DeptDr),"^",22)
			continue:(DeptHospDt'=LogonHospID)&&(LogonHospID'=0)
			s ASChildSub=0
			for {
				s ASChildSub=$O(^RBAS(0,"CredNo",DVAnumber,RESRowId,ASChildSub)) Q:ASChildSub=""
				s APPTChildSub=0
				for {
					s APPTChildSub=$O(^RBAS(0,"CredNo",DVAnumber,RESRowId,ASChildSub,APPTChildSub)) 
					Q:APPTChildSub=""
					s StatusCode=$P($G(^RBAS(RESRowId,ASChildSub,"APPT",APPTChildSub)),"^",3) 
					Set ASRowId=RESRowId_"||"_ASChildSub
					Set RBAppRowID=RESRowId_"||"_ASChildSub_"||"_APPTChildSub
					s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
					continue:ASDate'=..%SysDate()
					if ((("^"_IRBAppRowIDStr_"^")[("^"_RBAppRowID_"^"))&&(StatusCode="I")){
						i (IRBAppRowIDStr=""){
							s IRBAppRowIDStr=RBAppRowID
						}else {
							s IRBAppRowIDStr=IRBAppRowIDStr_"^"_RBAppRowID
						} 
					}
					if ((("^"_JRBAppRowIDStr_"^")[("^"_RBAppRowID_"^"))&&(StatusCode="I")){
						i (JRBAppRowIDStr=""){
							s JRBAppRowIDStr=RBAppRowID
						}else {
							s JRBAppRowIDStr=JRBAppRowIDStr_"^"_RBAppRowID
						} 
					}
				}
			}
		}
	}
	s rtnMessage=""
	b ;092323
	for m=1:1:$L(IRBAppRowIDStr,"^"){
		s AppRowid=$P(IRBAppRowIDStr,"^",m)
		q:AppRowid=""
		s QueueNo=$P(^RBAS(+AppRowid,$P(AppRowid,"||",2),"APPT",$P(AppRowid,"||",3)),"^",5)
		
		///---tanjishan 2021-01-02
		s ASQueueNo=$P(^RBAS(+AppRowid,$P(AppRowid,"||",2),"DHC"),"^",4)
	 	;正号串与加号串
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
		s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
		if (QueueNo["+"){
			s LoopQueueNoStr=AddQueueNoStr
		}else{
			s LoopQueueNoStr=NormalQueueNoStr
		}
		s SingleQueueNoStatus=""
		for i=1:1:$l(LoopQueueNoStr,",") {
		 	s LSingleQueueNoStr=$P(LoopQueueNoStr,",",i)
		 	s LQueueNoStatus=$P(LSingleQueueNoStr,":",2)
		 	s LQueueNo=$P(LSingleQueueNoStr,":",1)
		 	;未取号和已退号的可用
		 	i (LQueueNo'=QueueNo){
				continue
		 	}
		 	S SingleQueueNoStatus=LQueueNoStatus
		 	q
	 	}
		if (SingleQueueNoStatus="5"){
			//医生加号，不受预约回归时间限制
			continue
		}
		s HospitalID=##class(DHCDoc.Common.Hospital).GetAffiliatedHospitalId("","","",AppRowid)
		s ResRowId=+AppRowid
		s Childsub=$P(AppRowid,"||",2)
		s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
		if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
		s CurrentTime=..%SysTime()
		Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(ResRowId_"||"_Childsub,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
		if AppReturnTime1'="" Set AppReturnTime=AppReturnTime1
		if (CurrentTime>AppReturnTime) {
			d ##Class(web.DHCRBAppointment).AddAppBreak(AppRowid,"")
			;如果预约不释放资源并增号且当前时间大于回归时间点 则增号
			s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateSplitAfterCancelApp",HospitalID)
			if (RestoreFlag=1){
				Do ..RestoreSeqNo($P(AppRowid,"||",1,2), QueueNo, 0)
			}elseif (RestoreFlag=3){
				s AppMethod=$P(^RBAS(+AppRowid,$P(AppRowid,"||",2),"APPT",$P(AppRowid,"||",3)),"^",12)
				s NormalQueueNoLen=##class(web.DHCRBAppointment).AddOneScheduleQueue(ResRowId_"||"_Childsub,AppMethod)	
			}
		    #; if (##class(web.DHCRBAppointment).GetReturnAllowRegFlag("2","Y")){
			#; 	;置为爽约状态
			#; 	s AppMethod=$P(^RBAS(+AppRowid,$P(AppRowid,"||",2),"APPT",$P(AppRowid,"||",3)),"^",12)
			#; 	s NormalQueueNoLen=##class(web.DHCRBAppointment).AddOneScheduleQueue(ResRowId_"||"_Childsub,AppMethod)	
			#; }
			i (JRBAppRowIDStr=""){
				s JRBAppRowIDStr=RBAppRowID
			}else {
				s JRBAppRowIDStr=JRBAppRowIDStr_"^"_RBAppRowID
			} 
		}
						
	}
	s AppPatientName=$p(^PAPER(PatientID,"ALL"),"^",1)
	for m=1:1:$L(JRBAppRowIDStr,"^"){
		s AppRowid=$P(JRBAppRowIDStr,"^",m)
		q:AppRowid=""
		s DepRowId=$P(^RB("RES",+AppRowid),"^",1)
		s DocRowId=$P(^RB("RES",+AppRowid),"^",2)
		s DepDesc=$p($g(^CTLOC(DepRowId)),"^",2)
		s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
		s QueueNo=$P(^RBAS(+AppRowid,$P(AppRowid,"||",2),"APPT",$P(AppRowid,"||",3)),"^",5)
		if (rtnMessage=""){
			s rtnMessage="患者:"_AppPatientName_"有今天的爽约记录:"_DepDesc_DocDesc_" "_QueueNo_"号"
		}else{
			s rtnMessage=rtnMessage_","_DepDesc_DocDesc_" "_QueueNo_"号"	
		}
	}
	q rtnMessage
}

/// Desc:若排班配置无限制号源，则返回序号为空，需做好判断
/// Output: 空 正常取号(无序号) ; -1 取号失败
/// w ##class(web.DHCRBAppointment).GetSeqNoIfNoLimitLoad("3060||114","APP","DOC","",2)
ClassMethod GetSeqNoIfNoLimitLoad(RBASId As %String, RegType As %String, APPMethodCode As %String = "", HospitalID As %String = "", AllowAddRegFlag As %String = "") As %String
{
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //无限号源
	Q:NoLimitLoadFlag'="Y" -1
	s ASLoad=$p(^RBAS(ResRowId,Childsub),"^",8)
	i APPMethodCode=""  s APPMethodCode="WIN"
	;如果超过延时则返回为空
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
		s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 	;正号串与加号串
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
		;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
	 	if (StopRegNoFlag="Y") {
		 	if (RegType="NOR"){s RegType="ADD"}
		 	elseif ((RegType="APP")||(RegType="NORN")){
			 	lock -^RBASLOCK(ResRowId,Childsub)
				Q "-1"
			}
		}else{
			if ((RegType="NOR")||(RegType="NORN")||(RegType="APP")){
				s RegisterNum=##class(web.DHCRBApptSchedule).GetRegisterNum(RBASId)	
				s RegUsedCount=+$p(RegisterNum,"^",5)
				s AppUsedCount=+$p(RegisterNum,"^",6)
				s AvailableNum=ASLoad-RegUsedCount-AppUsedCount	
				if AvailableNum<=0{
					i (RegType="NOR"){
						s RegType="ADD"
					}else{
					 	lock -^RBASLOCK(ResRowId,Childsub)
						Q "-1"
					}
				}
			}
		}
		i (RegType="ADD") {
			;要取加号号段，且允许加号
			if (AllowAddRegFlag'="N"){
				d GetAddSeqNo
			}else{
				lock -^RBASLOCK(ResRowId,Childsub)
				Q "-1"	
			}
	 	}
	 	i RegType="DOCADD" {
		 	d GetAddSeqNo
	 	}
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	Q SingleQueueNo
GetAddSeqNo
	s AddQueSeqNo=0
 	for i=1:1:$l(AddQueueNoStr,",") {
	 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
	 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
	 	s QueueNo=$P(SingleQueueNoStr,":",1)
	 	;未取号和已退号的可用
	 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
			s AddQueSeqNo=QueueNo
	 	}
	 	if RegType="ADD"{
	 		s SingleQueueNoStr=AddQueSeqNo_":1"
	 	}else{
		 	s SingleQueueNoStr=AddQueSeqNo_":5"
		}
	 	Q:AddQueSeqNo'=0
 	}
 	i AddQueSeqNo'=0 {
	 	s $P(AddQueueNoStr,",",i)=SingleQueueNoStr
	 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
	 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
	 	s SingleQueueNo=AddQueSeqNo
 	}else{
	 	s SingleQueueNo="-1"	
	}
	Q
}

/// w ##class(web.DHCRBAppointment).GetSeqNo("3060||114","APP","DOC","",2)
ClassMethod GetSeqNo(RBASId As %String, RegType As %String, APPMethodCode As %String = "", UpdateFlag As %String = "", HospitalID As %String = "", AllowAddRegFlag As %String = "", ClinicGroupId As %String = "") As %String
{
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s SingleQueueNo=0
	i APPMethodCode=""  s APPMethodCode="WIN"
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //无限号源
	if NoLimitLoadFlag="Y"{
		Q ..GetSeqNoIfNoLimitLoad(RBASId, RegType, APPMethodCode, HospitalID, AllowAddRegFlag)	
	}
	;如果超过延时则返回为空
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
		s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 	;正号串与加号串
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 	s NormalQueueNoStream=##class(%Stream.GlobalCharacter).%New()
		s AddQueueNoStream=##class(%Stream.GlobalCharacter).%New()
		d NormalQueueNoStream.Write(NormalQueueNoStr)
		d AddQueueNoStream.Write(AddQueueNoStr)
		;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
	 	if (StopRegNoFlag="Y") {
		 	if (RegType="NOR"){s RegType="ADD"}
		 	elseif ((RegType="APP")||(RegType="NORN")){
			 	lock -^RBASLOCK(ResRowId,Childsub)
				Q "0"
			}
		}
	 	if (NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")||(RegType="NORN")) {
		 	lock -^RBASLOCK(ResRowId,Childsub)
			Q "0"
	 	}
	 	s i=0
		if ((RegType="NOR")||(RegType="NORN")||(RegType="APP")){
			;先讲目前号的状况放到数组里
			s AppMethodID=""
			i APPMethodCode=""  s APPMethodCode="WIN"
			s AppMethodID=$O(^RBC("APTM",0,"Code",APPMethodCode,0))

			s ASQSub=0 for{
				s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
				Q:ASQSub=""  
				s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
				s ASQQueueArry(ASMethodID)=1
			}
			;先计算总体还剩多少可以挂的号,为保留号留足号源，
			s MethodUsedQty=0,MastLeftQty=0,myMethodUsedQty=0
			s OneQueueNoStr=""
			While 'NormalQueueNoStream.AtEnd {
				s One=NormalQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'NormalQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
				s QueueNo=$P(SingleQueueNoStr,":",1)
				s QueueStatus=$P(SingleQueueNoStr,":",2)
				s MethodID=$P(SingleQueueNoStr,":",3)
				s ReturnAllowRegFlag=..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID)
				if ((MethodID="")) s MethodID=$O(^RBC("APTM",0,"Code","WIN",0))
				if (((QueueStatus=0)&&(ReturnAllowRegFlag))||("123"[QueueStatus)) {
					s myMethodUsedQty=myMethodUsedQty+1
					if ((MethodID=AppMethodID)) s MethodUsedQty=MethodUsedQty+1
					if $G(ASQQueueArry(MethodID,1))="" s ASQQueueArry(MethodID,1)=1
					else  s ASQQueueArry(MethodID,1)=$G(ASQQueueArry(MethodID,1))+1
				}
				if (('ReturnAllowRegFlag)) s MastLeftQty=MastLeftQty+1
				s QueueNoList(QueueNo)=SingleQueueNoStr
			}
			b ;再取对应预约方式的号串
			if (RegType="APP"){
				s StartNo=$p(^RBAS(ResRowId,Childsub),"^",10)
				s:StartNo="" StartNo=1
				s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
				;s EndNo=StartNo+AppQty-1
				s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
				s MastLeftQty=AppQty-myMethodUsedQty
			}else{
				s StartNo=1
				s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
			}
			;算总的能最大预约数，保留号数和其他预约数
			s (AppReserveQty,OtherReservSum,SubMastLeftQty,AppReservSum)=0
			s AppMaxQty=""
			s SumAppMaxQty=$l(NormalQueueNoStr,",")
			if (RegType="APP") s SumAppMaxQty=AppQty
			s ASQSub=0 for{
				s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
				Q:ASQSub=""  
				s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
				continue:ASMethodID=""
				s ASQQueueMethodArry(ASMethodID,"Max")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
				s ASQQueueMethodArry(ASMethodID,"Reserve")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
				s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
				if (RegType'="APP")&&(NowDateFLag'="Y"){
					if (ASMethodID=AppMethodID) {
						if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
							s AppMaxQty=$l(NormalQueueNoStr,",")
						}else{
							s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)}
						s AppReserveQty=0
					}
				}elseif (RegType'="APP")&&(NowDateFLag="Y"){
					if (ASMethodID=AppMethodID) {
						if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
							s AppMaxQty=$l(NormalQueueNoStr,",")
						}else{
							s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
							}
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if AppReservSum<0 s AppReservSum=0
					}else{
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if OneReserveQty<0 s OneReserveQty=0
						s OtherReservSum=OtherReservSum+OneReserveQty
					}
				}else{
					if (ASMethodID=AppMethodID) {
						s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if AppReservSum<0 s AppReservSum=0
					}else{
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if OneReserveQty<0 s OneReserveQty=0
						s OtherReservSum=OtherReservSum+OneReserveQty
					}
				}
			}
			///计算当天可以预约的数量、、、
			s myAppMaxQty=SumAppMaxQty-OtherReservSum-myMethodUsedQty
			if (SumAppMaxQty<0){
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif (SumAppMaxQty<=MethodUsedQty){
			///该预约方式在本次已经超过最大预约限额了
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif ((OtherReservSum>=MastLeftQty)&&(AppReservSum=0)){
			//该排班的剩保留号可用个数大于等于可以挂的个数
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif (+myAppMaxQty<="0")&&(RegType="APP") {
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif (MethodUsedQty>=AppMaxQty)&&(AppMaxQty'="")&&(RegType="APP") {
			///本次预约当前预约方式可使用数
				lock -^RBASLOCK(ResRowId,Childsub)
			}else{
				/*if (MastLeftQty<=SubMastLeftQty){
					lock -^RBASLOCK(ResRowId,Childsub)
					Q "0"
				}*/
				b ;分为分时段的和未分时段的
				s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)	
				i TRFlag="Y" {
					s OneEndNo=0,TRAMMaxQtySum=0,TRAMReserveQtySum=0
					if ($O(^RBAS(ResRowId,Childsub,"ASTR",0))=""){
						s TRNoStr=StartNo_"-"_EndNo
						s TRList("MethodTR",1)=TRNoStr
					}
					s SeqNoOverRangeTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTime",HospitalID)
					s SessTime=..%SysTime()
					s ASDate=$P($G(^RBAS(ResRowId,Childsub)),"^",1)
					if (ASDate>+$H) s SeqNoOverRangeTime=0
					s ASTRSub=0 for {
						s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
						q:ASTRSub=""
						s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
						s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
						s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
						if (TRQueueNoStr'=""){
							s OneSttNo=+$P(TRQueueNoStr,",",1)
							s OneEndNo=+$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
						}
						s starttime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
						s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
						continue:((SeqNoOverRangeTime=1)&&(SessTime>endtime))
						b ;先取出最大号数，保留号数和可挂剩余号数
						s LeftQty=TRLoad,TRAMMaxQty="",TRAMReserveQty="",MethodExistFlag=0
						k TRAMAppQueueArry
						s TRAMSub=0 for{
							s TRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub))
							q:TRAMSub=""
							s TRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
							s TRAMAppQueueArry(TRAMAppMethodID)=1
							s TRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
							s TRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
							s NowDateFLag=$P(^RBC("APTM",TRAMAppMethodID),"^",7)
							if ((RegType'="APP")&&(NowDateFLag'="Y")){
								s TRAMReserveQty=0
								s TRAMMaxQty=TRLoad
							}
							s TRAMAppQueueArry(TRAMAppMethodID,"TRAMMaxQty")=TRAMMaxQty
							s TRAMAppQueueArry(TRAMAppMethodID,"TRAMReserveQty")=TRAMReserveQty
						}
						b ;计算已经挂过号，看是否还有号可以挂
						s TRAMAppMethodIDLeft=0,TRAMUserQty=0
						k TRCGClinicGroupArry
						for oneQueuENo=OneSttNo:1:OneEndNo{
								continue:$g(QueueNoList(oneQueuENo))=""
								s OneMethodID=$P(QueueNoList(oneQueuENo),":",3)
								s Status=$P(QueueNoList(oneQueuENo),":",2)
								s UseClinicGroupID=$P(QueueNoList(oneQueuENo),":",6)
								if (('..GetReturnAllowRegFlag(QueueNoList(oneQueuENo),"",HospitalID))) s TRAMAppMethodIDLeft=TRAMAppMethodIDLeft+1
								if OneMethodID=AppMethodID s TRAMUserQty=TRAMUserQty+1
								if ("123"[Status){
									if $G(TRAMAppQueueArry(OneMethodID,1))=0 s TRAMAppQueueArry(OneMethodID,1)=1
										else  s TRAMAppQueueArry(OneMethodID,1)=$G(TRAMAppQueueArry(OneMethodID,1))+1
									if (UseClinicGroupID'=""){
											s TRCGClinicGroupArry(UseClinicGroupID)=$G(TRCGClinicGroupArry(UseClinicGroupID))+1
											}
								}
						}
						if TRAMAppMethodIDLeft=0 Continue
						;计算这个时段是否还有号可以用
						s ASMethodID="",TRAMAppSubMastLeftQty=0,AppMaxQty=TRLoad,AppReserveQty=0,OneOtherReservSum=0
						for {
							s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
							q:ASMethodID=""
							s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
							if (ASMethodID=AppMethodID) {
								s AppMaxQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMMaxQty"))
								s AppReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
							}else{
								s OneReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
								if OneReserveQty<0 s OneReserveQty=0
								s OneOtherReservSum=OneOtherReservSum+OneReserveQty
							}
						}  
						;计算总保留数和其他分时段保留数 与本时段保留数的联动控制
						s OtherEndNo=0
						s AppMaxLeft=+$g(ASQQueueMethodArry(AppMethodID,"Max"))
						if (AppMaxLeft'=0)&&(RegType="APP"){
							k ConectOtherASTR
							s OtherASTRSub=0 for {
								s OtherASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub))
								q:OtherASTRSub=""
								continue:OtherASTRSub=ASTRSub
								s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",3)
								s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",4)
								s OtherSttNo=OtherEndNo+1,OtherEndNo=OtherEndNo+TRLoad
								if (TRQueueNoStr'=""){
									s OtherSttNo=$P(TRQueueNoStr,",",1)
									s OtherEndNo=$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
								}
								for OtherQueuENo=OtherSttNo:1:OtherEndNo{
									continue:$g(QueueNoList(OtherQueuENo))=""
									s OneMethodID=$P(QueueNoList(OtherQueuENo),":",3)
									s Status=$P(QueueNoList(OtherQueuENo),":",2)
									if ("123"[Status){
										if $G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))=0 s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=1
										else  s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=$G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))+1
									}
								}
								s OtherTRAMSub=0 for{
									s OtherTRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub))
									q:OtherTRAMSub=""
									s OtherTRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",1)
									s OtherTRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",2)
									s OtherTRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",3)
									s ConectOtherASTR(OtherTRAMAppMethodID,"Max",OtherASTRSub)=OtherTRAMMaxQty
									s ConectOtherASTR(OtherTRAMAppMethodID,"Reserve",OtherASTRSub)=OtherTRAMReserveQty
								}
								//if (($G(ConectOtherASTR(AppMethodID,"Max",OtherASTRSub))'="")||($G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))'="")){
									s OtherOneMax=$G(ConectOtherASTR(AppMethodID,"Use",OtherASTRSub))-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
									if (OtherOneMax<=0) s OtherOneMax=0
									s AppMaxLeft=AppMaxLeft-OtherOneMax-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
								//}
							}
							s AppMaxLeft=AppMaxLeft-$G(TRAMAppQueueArry(AppMethodID,1))
							if ((AppMaxLeft<=0)&&(+$g(ASQQueueMethodArry(AppMethodID,"Max"))'=0)) Continue
						}
						///亚专业可用号源
						k CGClinicGroupArry
						s TRCGSub=0 for{
							s TRCGSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub))
							q:TRCGSub=""
							s TRCGClinicGroupId=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
							s TRCGQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
							s CGClinicGroupArry(TRCGClinicGroupId)=$G(CGClinicGroupArry(TRCGClinicGroupId))+TRCGQty
						}
						s ClinicGroupTRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
						for OneQueuENo=OneSttNo:1:OneEndNo{
							continue:$g(QueueNoList(OneQueuENo))=""
							s OneMethodID=$P(QueueNoList(OneQueuENo),":",3)
							s Status=$P(QueueNoList(OneQueuENo),":",2)
							s CGClinicGroupId=$P(QueueNoList(OneQueuENo),":",6)
							if ("123"[Status){
								s ClinicGroupTRLoad=ClinicGroupTRLoad-1
								if (CGClinicGroupId'=""){
									if ($G(CGClinicGroupArry(CGClinicGroupId))>0) s CGClinicGroupArry(CGClinicGroupId)=$G(CGClinicGroupArry(CGClinicGroupId))-1
								}
							}
						}
						s SamGroupID="",SamLoadNub=0
						for{
							s SamGroupID=$O(CGClinicGroupArry(SamGroupID))
							q:SamGroupID=""
							s SamLoadNub=SamLoadNub+$G(CGClinicGroupArry(SamGroupID))
							}
						if (ClinicGroupId'=""){
							s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub+$G(CGClinicGroupArry(ClinicGroupId))
						}else{
							s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub	
						}
						b ;ClinicAvailableNum
						if (ClinicAvailableNum<=0) Continue
						;最后判断是否有号源
						;if ((TRAMUserQty>=AppMaxQty)&&(AppMaxQty'="")) Continue
						continue:(TRAMUserQty>=(+AppMaxQty))
						if ((OneOtherReservSum>=TRAMAppMethodIDLeft)&&(AppReserveQty<=0)) Continue
						//if (TRAMAppMethodIDLeft<=TRAMAppSubMastLeftQty) Continue
						s node=$O(TRList("MethodTR",""),-1)+1
						s TRSttTime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
						s TREndTime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
						s TRList("MethodTR",node)=OneSttNo_"-"_OneEndNo_"^"_TRSttTime_"-"_TREndTime
					 }
						
				}else{
					;没有分时段则
					s TRNoStr=StartNo_"-"_EndNo
					s TRList("MethodTR",1)=TRNoStr
				}
				b ///
				s SingleQueueNo=0
				s node=0 for{
					s node=$O(TRList("MethodTR",node)) 
					q:node=""
					s oneTRNOStr=$p(TRList("MethodTR",node),"^",1)
					s SttNo=$P(oneTRNOStr,"-",1),EddNo=$P(oneTRNOStr,"-",2)
					for QueueNo=SttNo:1:EddNo{
							continue:(QueueNo<StartNo)||(QueueNo>EndNo)
							s QueueNoStatus=$P(QueueNoList(QueueNo),":",2)
							//b  ;当日挂号取号
							i RegType="NOR" {
								if QueueNoStatus=2{
									//按分时段里时间来回归
									Set AppReturnTime1=""
									Set ApptRowid=##class(web.DHCOPAdmReg).getApptRowidByQueNo(RBASId,QueueNo)
									if ApptRowid'="" Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(RBASId,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
									if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
									else  Set AppReturnTime2=AppReturnTime 
								}
								;未取号和已退号的可用,已经回归的预约的号可挂
								i (('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))||(('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"Y",HospitalID))&&(CurrentTime>AppReturnTime2))){
									s SingleQueueNo=QueueNo
								}
							}
							i RegType="NORN" {
								i (('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))){
									s SingleQueueNo=QueueNo
									if (+AppQty=0){s SingleQueueNo=QueueNo}
									else {
										;取非预号段内的号,此处有问题,需单独写方法判断顺序号是否在预约号段记录中
										s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo)
										if QueueNoInAppFlag'=1 {
											s SingleQueueNo=QueueNo
										}
									}
								}
							}
							i RegType="APP" {
								i (('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))){
									b ;只取预约号段里的号
									//s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,AppMethodID)
									//i QueueNoInAppFlag=1 s SingleQueueNo=QueueNo
									s SingleQueueNo=QueueNo
								}
							}
							q:SingleQueueNo'=0
						}
						q:SingleQueueNo'=0
					}
					s OneQueueNoStr=""
					d NormalQueueNoStream.Rewind()
					While 'NormalQueueNoStream.AtEnd {
						s One=NormalQueueNoStream.Read(1)
						i One'="," {
							s OneQueueNoStr=OneQueueNoStr_One
							continue:'NormalQueueNoStream.AtEnd
						}
						s SingleQueueNoStr=OneQueueNoStr
						s OneQueueNoStr=""
						s i=i+1
					 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
						s QueueNo=$P(SingleQueueNoStr,":",1)
						if (QueueNo=SingleQueueNo){
							i RegType="NOR" s SingleQueueNoStr=SingleQueueNo_":1:"_AppMethodID_":::"_ClinicGroupId
							i RegType="NORN" S SingleQueueNoStr=SingleQueueNo_":1:"_AppMethodID_":::"_ClinicGroupId
							i RegType="APP"  S SingleQueueNoStr=SingleQueueNo_":2:"_AppMethodID_":::"_ClinicGroupId
							q 
						}
					}
					
			
			}
		}
		i (SingleQueueNo=0)&&(RegType="NOR")  s RegType="ADD"
		//b  ;加号取号
	 	i (AllowAddRegFlag'="N")&&(RegType="ADD") {
		 	s OneQueueNoStr=""
			While 'AddQueueNoStream.AtEnd {
				s One=AddQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'AddQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
				s i=i+1
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
					s SingleQueueNo=QueueNo
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	//b  ;诊间加号
	 	i RegType="DOCADD" {
		 	s OneQueueNoStr=""
		 	d AddQueueNoStream.Rewind()
			While 'AddQueueNoStream.AtEnd {
				s One=AddQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'AddQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
				s i=i+1
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
					s SingleQueueNo=QueueNo
			 	}
			 	//S SingleQueueNoStr=SingleQueueNo_":1"
			 	S SingleQueueNoStr=SingleQueueNo_":5"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	i SingleQueueNo'="0",UpdateFlag'="N" {
		 	if (RegType="NOR")!(RegType="APP")!(RegType="NORN"){
			 	s $P(NormalQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
		 	}else{
			 	s $P(AddQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
		 	}
	 	}
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	Q SingleQueueNo
}

ClassMethod GetSpecSeqNo(RBASId As %String, SpecQueueNo As %String, RegType As %String, APPMethodCode As %String = "", UpdateFlag As %String = "", HospitalID As %String = "", StartTime As %String = "", EndTime As %String = "", AllowAddRegFlag As %String = "", ClinicGroupId As %String = "") As %String
{
	;w ##class(web.DHCRBAppointment).GetSpecSeqNo("1801||55","","NOR","","",2,"09:30:00","10:00:00")
	s ^tempqujian("GetSpecSeqNoNew")=$lb(RBASId , SpecQueueNo, RegType, APPMethodCode, UpdateFlag, HospitalID,StartTime, EndTime, AllowAddRegFlag, ClinicGroupId)
	s SingleQueueNo=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	;预约限额
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s APPSeqNoCount=0
	i APPSeqNoCount=0 s AppStartSeqNo=0
	
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //无限号源
	if NoLimitLoadFlag="Y"{
		Q ..GetSeqNoIfNoLimitLoad(RBASId, RegType, APPMethodCode, HospitalID, AllowAddRegFlag)	
	}
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	;如果超过延时则返回为空
	s SingleQueueNo=0
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
	 	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 	;正号串与加号串
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 	s NormalQueueNoStream=##class(%Stream.GlobalCharacter).%New()
		s AddQueueNoStream=##class(%Stream.GlobalCharacter).%New()
		d NormalQueueNoStream.Write(NormalQueueNoStr)
		d AddQueueNoStream.Write(AddQueueNoStr)
		s i=0
		
	 	if (NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")||(RegType="NORN")) {
		 	lock -^RBASLOCK(ResRowId,Childsub)
			Q "0"
	 	}
	 	;取加号限额外加号
	 	i ($e(SpecQueueNo,1)="+")  s RegType="ADD"
		;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
	 	if (StopRegNoFlag="Y") {
		 	if (RegType="NOR"){s RegType="ADD"}
		 	elseif ((RegType="APP")||(RegType="NORN")){
			 	lock -^RBASLOCK(ResRowId,Childsub)
				Q "0"
			}
		}
	 	if ((RegType="NOR")||(RegType="NORN")||(RegType="APP")){
			;先讲目前号的状况放到数组里
			s AppMethodID=""
			i APPMethodCode=""  s APPMethodCode="WIN"
			s AppMethodID=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
			s ASQSub=0 for{
				s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
				Q:ASQSub=""  
				s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
				s ASQQueueArry(ASMethodID)=1
				}
			;先计算总体还剩多少可以挂的号,为保留号留足号源，
			s MethodUsedQty=0,MastLeftQty=0,myMethodUsedQty=0
			s OneQueueNoStr=""
			While 'NormalQueueNoStream.AtEnd {
				s One=NormalQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'NormalQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
				s QueueNo=$P(SingleQueueNoStr,":",1)
				s QueueStatus=$P(SingleQueueNoStr,":",2)
				s MethodID=$P(SingleQueueNoStr,":",3)
				s ReturnAllowRegFlag=..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID)
				if ((MethodID="")) s MethodID=$O(^RBC("APTM",0,"Code","WIN",0))
				if (((QueueStatus=0)&&(ReturnAllowRegFlag))||("123"[QueueStatus)) {
					s myMethodUsedQty=myMethodUsedQty+1
					if ((MethodID=AppMethodID)) s MethodUsedQty=MethodUsedQty+1
					if $G(ASQQueueArry(MethodID,1))="" s ASQQueueArry(MethodID,1)=1
					else  s ASQQueueArry(MethodID,1)=$G(ASQQueueArry(MethodID,1))+1
				}
				if (('ReturnAllowRegFlag)) s MastLeftQty=MastLeftQty+1
				s QueueNoList(QueueNo)=SingleQueueNoStr
			}
			;再取对应预约方式的号串
			if (RegType="APP"){
				s StartNo=$p(^RBAS(ResRowId,Childsub),"^",10)
				s:StartNo="" StartNo=1
				s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
				;s EndNo=StartNo+AppQty-1
				s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
				s MastLeftQty=AppQty-myMethodUsedQty
			}else{
				s StartNo=1
				s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
			}
			;算总的能最大预约数，保留号数和其他预约数
			s (AppReserveQty,OtherReservSum,SubMastLeftQty,AppReservSum)=0
			s AppMaxQty=""
			s SumAppMaxQty=$l(NormalQueueNoStr,",")
			if (RegType="APP") s SumAppMaxQty=AppQty
			s ASQSub=0 for{
				s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
				Q:ASQSub=""  
				s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
				continue:ASMethodID=""
				s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
				s ASQQueueMethodArry(ASMethodID,"Max")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
				s ASQQueueMethodArry(ASMethodID,"Reserve")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)

				if (RegType'="APP")&&(NowDateFLag'="Y"){
					if (ASMethodID=AppMethodID) {
						if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
							s AppMaxQty=$l(NormalQueueNoStr,",")
						}else{
							s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)}
						s AppReserveQty=0
					}
				}elseif (RegType'="APP")&&(NowDateFLag="Y"){
					if (ASMethodID=AppMethodID) {
						if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
							s AppMaxQty=$l(NormalQueueNoStr,",")
						}else{
							s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
							}
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if AppReservSum<0 s AppReservSum=0
					}else{
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if OneReserveQty<0 s OneReserveQty=0
						s OtherReservSum=OtherReservSum+OneReserveQty
					}
				}else{
					if (ASMethodID=AppMethodID) {
						s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if AppReservSum<0 s AppReservSum=0
					}else{
						s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
						s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
						if OneReserveQty<0 s OneReserveQty=0
						s OtherReservSum=OtherReservSum+OneReserveQty
					}
				}
			}
			///计算当天可以预约的数量、、、
			s myAppMaxQty=SumAppMaxQty-OtherReservSum-myMethodUsedQty
			if (SumAppMaxQty<0){
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif (SumAppMaxQty<=MethodUsedQty){
			b ///该预约方式在本次已经超过最大预约限额了
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif ((OtherReservSum>=MastLeftQty)&&(AppReservSum=0)){
			//该排班的剩保留号可用个数大于等于可以挂的个数
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif (+myAppMaxQty<="0")&&(RegType="APP") {
				lock -^RBASLOCK(ResRowId,Childsub)
			}elseif (MethodUsedQty>=AppMaxQty)&&(AppMaxQty'="")&&(RegType="APP") {
			///本次预约当前预约方式可使用数
				lock -^RBASLOCK(ResRowId,Childsub)
			}else{
				;分为分时段的和未分时段的
				if ((StartTime'="")&&(EndTime'="")){
					s StartTime=..%ZTH(StartTime)
					s EndTime=..%ZTH(EndTime)
				}
				s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)	
				i TRFlag="Y" {
					s OneEndNo=0,TRAMMaxQtySum=0,TRAMReserveQtySum=0
					if ($O(^RBAS(ResRowId,Childsub,"ASTR",0))=""){
						s TRNoStr=StartNo_"-"_EndNo
						s TRList("MethodTR",1)=TRNoStr
						}
					s SeqNoOverRangeTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTime",HospitalID)
					s SessTime=..%SysTime()
					s ASDate=$P($G(^RBAS(ResRowId,Childsub)),"^",1)
					if (ASDate>+$H) s SeqNoOverRangeTime=0
					s ASTRSub=0 for {
						s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
						q:ASTRSub=""
						s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
						s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
						s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
						if (TRQueueNoStr'=""){
							s OneSttNo=+$P(TRQueueNoStr,",",1)
							s OneEndNo=+$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
						}
						s starttime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
						s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
						b ;0923
						if ((StartTime'="")&&(EndTime'="")){
							continue:((starttime>StartTime)||(EndTime>endtime))
							}
						continue:((SeqNoOverRangeTime=1)&&(SessTime>endtime))
						b ;先取出最大号数，保留号数和可挂剩余号数
						s LeftQty=TRLoad,TRAMMaxQty="",TRAMReserveQty="",MethodExistFlag=0
						k TRAMAppQueueArry
						s TRAMSub=0 for{
							s TRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub))
							q:TRAMSub=""
							s TRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
							s TRAMAppQueueArry(TRAMAppMethodID)=1
							s NowDateFLag=$P(^RBC("APTM",TRAMAppMethodID),"^",7)
							s TRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
							s TRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
							if (RegType'="APP")&&(NowDateFLag'="Y"){
								s TRAMReserveQty=0
								s TRAMMaxQty=TRLoad
							}
							s TRAMAppQueueArry(TRAMAppMethodID,"TRAMMaxQty")=TRAMMaxQty
							s TRAMAppQueueArry(TRAMAppMethodID,"TRAMReserveQty")=TRAMReserveQty
						}
						;计算已经挂过号，看是否还有号可以挂
						s TRAMAppMethodIDLeft=0,TRAMUserQty=0
						k TRCGClinicGroupArry
						for oneQueuENo=OneSttNo:1:OneEndNo{
								continue:$g(QueueNoList(oneQueuENo))=""
								s OneMethodID=$P(QueueNoList(oneQueuENo),":",3)
								s Status=$P(QueueNoList(oneQueuENo),":",2)
								s UseClinicGroupID=$P(QueueNoList(oneQueuENo),":",6)
								if (('..GetReturnAllowRegFlag(QueueNoList(oneQueuENo),"",HospitalID))) s TRAMAppMethodIDLeft=TRAMAppMethodIDLeft+1
								if OneMethodID=AppMethodID s TRAMUserQty=TRAMUserQty+1
								/*s ASMethodID=""
								for{
									s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
									q:ASMethodID=""
									if ((ASMethodID=AppMethodID)&&("123"[Status)) {  
										if $G(TRAMAppQueueArry(ASMethodID,1))=0 s TRAMAppQueueArry(ASMethodID,1)=1
										else  s TRAMAppQueueArry(ASMethodID,1)=$G(TRAMAppQueueArry(ASMethodID,1))+1
									}
								}*/
								if ("123"[Status){
									if $G(TRAMAppQueueArry(OneMethodID,1))=0 s TRAMAppQueueArry(OneMethodID,1)=1
										else  s TRAMAppQueueArry(OneMethodID,1)=$G(TRAMAppQueueArry(OneMethodID,1))+1
									if (UseClinicGroupID'=""){
										s TRCGClinicGroupArry(UseClinicGroupID)=$G(TRCGClinicGroupArry(UseClinicGroupID))+1
									}
								}
						}
						if TRAMAppMethodIDLeft=0  Continue
						;计算这个时段是否还有号可以用
						s ASMethodID="",TRAMAppSubMastLeftQty=0,AppMaxQty=TRLoad,AppReserveQty=0,OneOtherReservSum=0
						for {
							s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
							q:ASMethodID=""
							s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
							if (ASMethodID=AppMethodID) {
								s AppMaxQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMMaxQty"))
								s AppReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
							}else{
								s OneReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
								if OneReserveQty<0 s OneReserveQty=0
								s OneOtherReservSum=OneOtherReservSum+OneReserveQty
							}
							
						}
						;计算总保留数和其他分时段保留数 与本时段保留数的联动控制
						s OtherEndNo=0
						s AppMaxLeft=+$g(ASQQueueMethodArry(AppMethodID,"Max"))
						if (AppMaxLeft'=0)&&(RegType="APP"){
							k ConectOtherASTR
							s OtherASTRSub=0 for {
								s OtherASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub))
								q:OtherASTRSub=""
								continue:OtherASTRSub=ASTRSub
								s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",3)
								s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",4)
								s OtherSttNo=OtherEndNo+1,OtherEndNo=OtherEndNo+TRLoad
								if (TRQueueNoStr'=""){
									s OtherSttNo=$P(TRQueueNoStr,",",1)
									s OtherEndNo=$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
								}
								for OtherQueuENo=OtherSttNo:1:OtherEndNo{
									continue:$g(QueueNoList(OtherQueuENo))=""
									s OneMethodID=$P(QueueNoList(OtherQueuENo),":",3)
									s Status=$P(QueueNoList(OtherQueuENo),":",2)
									if ("123"[Status){
										if $G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))=0 s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=1
										else  s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=$G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))+1
									}
								}
								s OtherTRAMSub=0 for{
									s OtherTRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub))
									q:OtherTRAMSub=""
									s OtherTRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",1)
									s OtherTRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",2)
									s OtherTRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",3)
									s ConectOtherASTR(OtherTRAMAppMethodID,"Max",OtherASTRSub)=OtherTRAMMaxQty
									s ConectOtherASTR(OtherTRAMAppMethodID,"Reserve",OtherASTRSub)=OtherTRAMReserveQty
								}
								//if (($G(ConectOtherASTR(AppMethodID,"Max",OtherASTRSub))'="")||($G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))'="")){
									s OtherOneMax=$G(ConectOtherASTR(AppMethodID,"Use",OtherASTRSub))-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
									if (OtherOneMax<=0) s OtherOneMax=0
									s AppMaxLeft=AppMaxLeft-OtherOneMax-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
								//}
							}
							s AppMaxLeft=AppMaxLeft-$G(TRAMAppQueueArry(AppMethodID,1))
							if ((AppMaxLeft<=0)&&(+$g(ASQQueueMethodArry(AppMethodID,"Max"))'=0)) Continue
						}
						///亚专业可用号源
						k CGClinicGroupArry
						s TRCGSub=0 for{
							s TRCGSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub))
							q:TRCGSub=""
							s TRCGClinicGroupId=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
							s TRCGQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
							s CGClinicGroupArry(TRCGClinicGroupId)=$G(CGClinicGroupArry(TRCGClinicGroupId))+TRCGQty
						}
						s ClinicGroupTRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
						for OneQueuENo=OneSttNo:1:OneEndNo{
							continue:$g(QueueNoList(OneQueuENo))=""
							s OneMethodID=$P(QueueNoList(OneQueuENo),":",3)
							s Status=$P(QueueNoList(OneQueuENo),":",2)
							s CGClinicGroupId=$P(QueueNoList(OneQueuENo),":",6)
							if ("123"[Status){
								s ClinicGroupTRLoad=ClinicGroupTRLoad-1
								if (CGClinicGroupId'=""){
									if ($G(CGClinicGroupArry(CGClinicGroupId))>0) s CGClinicGroupArry(CGClinicGroupId)=$G(CGClinicGroupArry(CGClinicGroupId))-1
								}
							}
						}
						s SamGroupID="",SamLoadNub=0
						for{
							s SamGroupID=$O(CGClinicGroupArry(SamGroupID))
							q:SamGroupID=""
							s SamLoadNub=SamLoadNub+$G(CGClinicGroupArry(SamGroupID))
							}
						if (ClinicGroupId'=""){
							s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub+$G(CGClinicGroupArry(ClinicGroupId))
						}else{
							s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub	
						}
						b ;ClinicAvailableNum
						if (ClinicAvailableNum<=0) Continue
						b ;09332
						;if ((TRAMUserQty>=AppMaxQty)&&(AppMaxQty'="")) Continue
						continue:(TRAMUserQty>=(+AppMaxQty))
						if ((OneOtherReservSum>=TRAMAppMethodIDLeft)&&(AppReserveQty<=0)) Continue
						s node=$O(TRList("MethodTR",""),-1)+1
						s TRSttTime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
						s TREndTime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
						s TRList("MethodTR",node)=OneSttNo_"-"_OneEndNo_"^"_TRSttTime_"-"_TREndTime
						}
					}else{
					;没有分时段则
					s TRNoStr=StartNo_"-"_EndNo
					s TRList("MethodTR",1)=TRNoStr
					}
				///
				s SingleQueueNo=0
				s node=0 for{
					s node=$O(TRList("MethodTR",node)) 
					q:node=""
					s oneTRNOStr=$p(TRList("MethodTR",node),"^",1)
					s SttNo=$P(oneTRNOStr,"-",1),EddNo=$P(oneTRNOStr,"-",2)
					for QueueNo=SttNo:1:EddNo{
							continue:$g(QueueNoList(QueueNo))=""
							continue:(QueueNo<StartNo)||(QueueNo>EndNo)
							s QueueNoStatus=$P(QueueNoList(QueueNo),":",2)
							continue:((SpecQueueNo'=QueueNo)&&(SpecQueueNo'=""))
							//b  ;当日挂号取号
							i RegType="NOR" {
									if QueueNoStatus=2{
										//按分时段里时间来回归
										Set AppReturnTime1=""
										Set ApptRowid=##class(web.DHCOPAdmReg).getApptRowidByQueNo(RBASId,QueueNo)
										if ApptRowid'="" Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(RBASId,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
										if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
										else  Set AppReturnTime2=AppReturnTime 
									}
									;未取号和已退号的可用,已经回归的预约的号可挂
									i (('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))||(('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"Y",HospitalID))&&(CurrentTime>AppReturnTime2))){
										s SingleQueueNo=QueueNo
									}
							}
							i RegType="NORN" {
								i (('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))){
									s SingleQueueNo=QueueNo
									if (+AppQty=0){s SingleQueueNo=QueueNo}
									else {
										;取非预号段内的号,此处有问题,需单独写方法判断顺序号是否在预约号段记录中
										s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo)
										if QueueNoInAppFlag'=1 {
											s SingleQueueNo=QueueNo
										}
									}
								}
							}
							i RegType="APP" {
								i (('..GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))){
									;只取预约号段里的号
									s SingleQueueNo=QueueNo
								}
							}
							q:SingleQueueNo'=0
							
							
						}
						q:SingleQueueNo'=0
					}
					s OneQueueNoStr=""
					d NormalQueueNoStream.Rewind()
					While 'NormalQueueNoStream.AtEnd {
						s One=NormalQueueNoStream.Read(1)
						i One'="," {
							s OneQueueNoStr=OneQueueNoStr_One
							continue:'NormalQueueNoStream.AtEnd
						}
						s SingleQueueNoStr=OneQueueNoStr
						s OneQueueNoStr=""
						s i=i+1
					 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
						s QueueNo=$P(SingleQueueNoStr,":",1)
						if (QueueNo=SingleQueueNo){
							i RegType="NOR" s SingleQueueNoStr=SingleQueueNo_":1:"_AppMethodID_":::"_ClinicGroupId
							i RegType="NORN" S SingleQueueNoStr=SingleQueueNo_":1:"_AppMethodID_":::"_ClinicGroupId
							i RegType="APP"  S SingleQueueNoStr=SingleQueueNo_":2:"_AppMethodID_":::"_ClinicGroupId
							q 
						}
					}
					
			
			}
	 	}
	 	//b ;加号取号
	 	i (AllowAddRegFlag'="N")&&(RegType="ADD") {
		 	i (SpecQueueNo="+"){
			 	s OneQueueNoStr=""
				d AddQueueNoStream.Rewind()
				While 'AddQueueNoStream.AtEnd {
					s One=AddQueueNoStream.Read(1)
					i One'="," {
						s OneQueueNoStr=OneQueueNoStr_One
						continue:'AddQueueNoStream.AtEnd
					}
					s SingleQueueNoStr=OneQueueNoStr
					s OneQueueNoStr=""
					s i=i+1
				 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 	s QueueNo=$P(SingleQueueNoStr,":",1)
				 	;未取号和已退号的可用
				 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
						s SingleQueueNo=QueueNo
				 	}
				 	S SingleQueueNoStr=SingleQueueNo_":1"
				 	Q:SingleQueueNo'=0
			 	}
			 	
			 	if (SingleQueueNo=0){
				 	s QueueNo=0,len=0
				 	i AddQueueNoStr'="" {
				 		s len=$l(AddQueueNoStr,",")
				 		s SingleQueueNoStr=$P(AddQueueNoStr,",",len)
				 		s QueueNo=$P(SingleQueueNoStr,":",1)
				 	}
				 	s SingleQueueNo=QueueNo+1
				 	s SingleQueueNo="+"_SingleQueueNo
				 	s i=len+1
				 	S SingleQueueNoStr=SingleQueueNo_":1"
				 	b  ;SingleQueueNoStr
			 	}
		 	}else{
			 	s OneQueueNoStr=""
				d AddQueueNoStream.Rewind()
				While 'AddQueueNoStream.AtEnd {
					s One=AddQueueNoStream.Read(1)
					i One'="," {
						s OneQueueNoStr=OneQueueNoStr_One
						continue:'AddQueueNoStream.AtEnd
					}
					s SingleQueueNoStr=OneQueueNoStr
					s OneQueueNoStr=""
					s i=i+1
				 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
				 	s QueueNo=$P(SingleQueueNoStr,":",1)
				 	;未取号和已退号的可用
				 	i ((('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID)))&&(QueueNo=SpecQueueNo)){
						s SingleQueueNo=QueueNo
				 	}
				 	S SingleQueueNoStr=SingleQueueNo_":1"
				 	Q:SingleQueueNo'=0
			 	}
		 	}
	 	}
	 	//b  ;诊间加号
	 	i RegType="DOCADD" {
		 	s OneQueueNoStr=""
			d AddQueueNoStream.Rewind()
			While 'AddQueueNoStream.AtEnd {
				s One=AddQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'AddQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
				s i=i+1
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
					s SingleQueueNo=QueueNo
			 	}
			 	S SingleQueueNoStr=SingleQueueNo_":1"
			 	Q:SingleQueueNo'=0
		 	}
	 	}
	 	i SingleQueueNo'="0",UpdateFlag'="N" {
		 	if (RegType="NOR")!(RegType="APP")!(RegType="NORN"){
			 	s $P(NormalQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo

		 	}else{
			 	s $P(AddQueueNoStr,",",i)=SingleQueueNoStr
			 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
			 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
		 	}
	 	}
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	Q SingleQueueNo
}

ClassMethod GetAvailableNumIfNoLimitLoad(RBASId As %String, RegType As %String, APPMethodCode As %String = "", HospitalID As %String = "", AllowAddRegFlag As %String = "") As %String
{
	s AvailableNum=0
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) AvailableNum
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //无限号源
	Q:NoLimitLoadFlag'="Y" AvailableNum
	s ASLoad=$p(^RBAS(ResRowId,Childsub),"^",8)
	i APPMethodCode=""  s APPMethodCode="WIN"
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
 	;正号串与加号串
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
 	if (StopRegNoFlag="Y") {
	 	if (RegType="NOR"){s RegType="ADD"}
	 	elseif ((RegType="APP")||(RegType="NORN")){
		}
	}else{
		s ret=##class(web.DHCRBApptSchedule).GetRegisterNum(RBASId)	
		s RegUsedCount=+$p(ret,"^",5)
		s AppUsedCount=+$p(ret,"^",6)
		s AvailableNum=ASLoad-RegUsedCount-AppUsedCount
	}
	;要取加号号段，且允许加号
	if (AllowAddRegFlag'="N")&&((RegType'="APP")&&(RegType'="NORN")){
		for i=1:1:$l(AddQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	;未取号和已退号的可用
		 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
				s AvailableNum=AvailableNum+1
		 	}
	 	}
	}
	Q AvailableNum
}

/// w ##class(web.DHCRBAppointment).GetAvailableNum("3146||107","NOR","WIN","","","","","")
ClassMethod GetAvailableNum(RBASId As %String, RegType As %String, APPMethodCode As %String = "", HospitalID As %String = "", StartTime As %String = "", EndTime As %String = "", AllowAddRegFlag As %String = "", ClinicGroupId As %String = "")
{
	s ^Tempqujian("GetAvailableNum")=$Lb(RBASId, RegType , APPMethodCode , HospitalID , StartTime, EndTime , AllowAddRegFlag , ClinicGroupId)
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //便捷排班
	if NoLimitLoadFlag="Y"{
		Q ..GetAvailableNumIfNoLimitLoad(RBASId, RegType, APPMethodCode, HospitalID, AllowAddRegFlag)	
	}
	s AvailableNum=0
	i APPMethodCode=""  s APPMethodCode="WIN"
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	;正号串与加号串
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	s NormalQueueNoStream=##class(%Stream.GlobalCharacter).%New()
	s AddQueueNoStream=##class(%Stream.GlobalCharacter).%New()
	d NormalQueueNoStream.Write(NormalQueueNoStr)
	d AddQueueNoStream.Write(AddQueueNoStr)
	;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
	if (StopRegNoFlag="Y") {
		if (RegType="NOR"){s RegType="ADD"}
		elseif ((RegType="APP")||(RegType="NORN")){
			Q "0"
		}
	}
	if (NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")||(RegType="NORN")) {
		Q "0"
	}
	if ((RegType="NOR")||(RegType="NORN")||(RegType="APP")){
		;先讲目前号的状况放到数组里
		s AppMethodID=""
		i APPMethodCode=""  s APPMethodCode="WIN"
		s AppMethodID=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
		s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
		s len=$l(NormalQueueNoStr,",")
		s ASQSub=0 for{
			s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
			Q:ASQSub=""  
			s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
			s ASQQueueArry(ASMethodID)=1
		}
		;先计算总体还剩多少可以挂的号,为保留号留足号源，
		s MethodUsedQty=0,MastLeftQty=0,myMethodUsedQty=0
		s AllUse=0,APPUse=0
		k ClinicGroupArry ///专业组
		s OneQueueNoStr=""
		While 'NormalQueueNoStream.AtEnd {
			s One=NormalQueueNoStream.Read(1)
			i One'="," {
				s OneQueueNoStr=OneQueueNoStr_One
				continue:'NormalQueueNoStream.AtEnd
			}
			s SingleQueueNoStr=OneQueueNoStr
			s OneQueueNoStr=""
			;s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			s QueueNo=$P(SingleQueueNoStr,":",1)
			s QueueStatus=$P(SingleQueueNoStr,":",2)
			s MethodID=$P(SingleQueueNoStr,":",3)
			s ClinicGroupID=$P(SingleQueueNoStr,":",6)
			s ReturnAllowRegFlag=..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID)
			if ((MethodID="")) s MethodID=$O(^RBC("APTM",0,"Code","WIN",0))
			if (((QueueStatus=0)&&(ReturnAllowRegFlag))||("123"[QueueStatus)) {
				if ((MethodID=AppMethodID)) s MethodUsedQty=MethodUsedQty+1
				if $G(ASQQueueArry(MethodID,1))="" s ASQQueueArry(MethodID,1)=1
				else  s ASQQueueArry(MethodID,1)=$G(ASQQueueArry(MethodID,1))+1
				s AllUse=AllUse+1
				if (ClinicGroupID'=""){
					s ClinicGroupArry(ClinicGroupID)=$G(ClinicGroupArry(ClinicGroupID))+1
				}
			}
			if (("23"[QueueStatus) || ((QueueStatus=0)&&(ReturnAllowRegFlag))){
				s APPUse=APPUse+1
			}
			if (('ReturnAllowRegFlag)) s MastLeftQty=MastLeftQty+1
			s QueueNoList(QueueNo)=SingleQueueNoStr
		}
		;b ;再取对应预约方式的号串
		if (RegType="APP"){
			s StartNo=$p(^RBAS(ResRowId,Childsub),"^",10)
			s:StartNo="" StartNo=1
			s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
			;s EndNo=StartNo+AppQty-1
			s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
			s CurrentAppQty=0
			for oneappqueueno=StartNo:1:EndNo{
				continue:$G(QueueNoList(oneappqueueno))=""
				s OneMethodID=$P(QueueNoList(oneappqueueno),":",3)
				s Status=$P(QueueNoList(oneappqueueno),":",2)
				if (Status=0){
					s CurrentAppQty=CurrentAppQty+1
					}
				}
		}else{
			s StartNo=1
			s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
			s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
		}
		;算总的能最大预约数，保留号数和其他预约数
		;s AppQty=EndNo
		s (AppReserveQty,OtherReservSum,SubMastLeftQty,AppReservSum)=0
		s SumAppMaxQty=$l(NormalQueueNoStr,",")
		s AppMaxQty=""
		s ASQSub=0 for{
			s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
			Q:ASQSub=""  
			s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
			continue:ASMethodID=""
			s ASQQueueMethodArry(ASMethodID,"Max")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
			s ASQQueueMethodArry(ASMethodID,"Reserve")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
			s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
			if (RegType'="APP")&&(NowDateFLag'="Y"){
				if (ASMethodID=AppMethodID) {
					if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
						s AppMaxQty=$l(NormalQueueNoStr,",")
					}else{
						s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)}
					s AppReserveQty=0
				}
			}elseif (RegType'="APP")&&(NowDateFLag="Y"){
				if (ASMethodID=AppMethodID) {
					if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
						s AppMaxQty=$l(NormalQueueNoStr,",")
					}else{
						s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
					}
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if AppReservSum<0 s AppReservSum=0
				}else{
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if OneReserveQty<0 s OneReserveQty=0
					s OtherReservSum=OtherReservSum+OneReserveQty
				}
			}else{
				if (ASMethodID=AppMethodID) {
					s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if AppReservSum<0 s AppReservSum=0
				}else{
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if OneReserveQty<0 s OneReserveQty=0
					s OtherReservSum=OtherReservSum+OneReserveQty
				}
			}
		}
		if (SumAppMaxQty<0){
			s AvailableNum=0	
		}elseif ((OtherReservSum>=MastLeftQty)&&(AppReservSum=0)){
			//该排班的剩保留号可用个数大于等于可以挂的个数
			s AvailableNum=0
		}else{
			if ((AppQty'="")&&(MastLeftQty>AppMaxQty)&&(RegType="APP")) {
				s leftOtherLeft=AppQty-OtherReservSum-APPUse
			}else{
				s leftOtherLeft=MastLeftQty-OtherReservSum
			}
			if (leftOtherLeft<0) s leftOtherLeft=0
			if (AppMaxQty'=""){
				s leftAppMaxQty=AppMaxQty-$G(ASQQueueArry(AppMethodID,1)) //-OtherReservSum
				if (leftAppMaxQty>leftOtherLeft){s AvailableNum=leftOtherLeft}else{s AvailableNum=leftAppMaxQty}
			}else{
				s leftAppMaxQty=AppQty-$G(ASQQueueArry(AppMethodID,1)) 
				s AvailableNum=leftOtherLeft
			}
			if ((RegType="APP")&&(AvailableNum>CurrentAppQty)) {s AvailableNum=CurrentAppQty}
			;分为分时段的和未分时段的 
			s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)	
			i ((TRFlag="Y")&&(StartTime'="")&&(EndTime'="")) {
				s NewAvailableNum=0
				s StartTime=..%ZTH(StartTime)
				s EndTime=..%ZTH(EndTime)
				s SeqNoOverRangeTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTime",HospitalID)
				s SessTime=..%SysTime()
				s ASDate=$P($G(^RBAS(ResRowId,Childsub)),"^",1)
				if (ASDate>+$H) s SeqNoOverRangeTime=0
				s OneEndNoBase=0,TRAMMaxQtySum=0,TRAMReserveQtySum=0
				s ASTRSub=0 for {
					s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
					q:ASTRSub=""
					s starttime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
					s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
					s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
					s OneSttNo=OneEndNoBase+1,OneEndNo=OneEndNoBase+TRLoad
					s OneEndNoBase=OneEndNoBase+TRLoad
					s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
					if (TRQueueNoStr'=""){
						s OneSttNo=+$P(TRQueueNoStr,",",1)
						s OneEndNo=+$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
					}
					s LastNo=TRLoad
					continue:((starttime>StartTime)||(EndTime>endtime))
					continue:((SeqNoOverRangeTime=1)&&(SessTime>endtime))
					s TRAMSub=0 for{
						s TRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub))
						q:TRAMSub=""
						s TRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
						s TRAMAppQueueArry(TRAMAppMethodID)=1
						s TRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
						s TRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
						s NowDateFLag=$P(^RBC("APTM",TRAMAppMethodID),"^",7)
						if ((RegType'="APP")&&(NowDateFLag'="Y")){
							s TRAMReserveQty=0
							s TRAMMaxQty=TRLoad
						}
						s TRAMAppQueueArry(TRAMAppMethodID,"TRAMMaxQty")=TRAMMaxQty
						s TRAMAppQueueArry(TRAMAppMethodID,"TRAMReserveQty")=TRAMReserveQty
					}
					s TRAMAppMethodIDLeft=0,TRAMUserQty=0,TRAMAPPUserQty=0
					k TRCGClinicGroupArry
					for oneQueuENo=OneSttNo:1:OneEndNo{
						continue:$G(QueueNoList(oneQueuENo))=""
						s OneMethodID=$P(QueueNoList(oneQueuENo),":",3)
						s Status=$P(QueueNoList(oneQueuENo),":",2)
						s UseClinicGroupID=$P(QueueNoList(oneQueuENo),":",6)
						b ;ddf
						if (('..GetReturnAllowRegFlag(QueueNoList(oneQueuENo),"",HospitalID))) s TRAMAppMethodIDLeft=TRAMAppMethodIDLeft+1
						if OneMethodID=AppMethodID s TRAMUserQty=TRAMUserQty+1
						if ("123"[Status){
							if $G(TRAMAppQueueArry(OneMethodID,1))=0 s TRAMAppQueueArry(OneMethodID,1)=1
							else  s TRAMAppQueueArry(OneMethodID,1)=$G(TRAMAppQueueArry(OneMethodID,1))+1
							s TRAMUserQty=TRAMUserQty+1
							if (UseClinicGroupID'=""){
								s TRCGClinicGroupArry(UseClinicGroupID)=$G(TRCGClinicGroupArry(UseClinicGroupID))+1
								}
						}
						if (("23"[QueueStatus)){
							s TRAMAPPUserQty=TRAMAPPUserQty+1
						}
					}
					if TRAMAppMethodIDLeft=0 Q 
					b ;计算这个时段是否还有号可以用
					s ASMethodID="",TRAMAppSubMastLeftQty=0,SubAppMaxQty=TRLoad,AppReserveQty=0,OtherReservSum=0
					for {
						s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
						q:ASMethodID=""
						s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
						if (ASMethodID=AppMethodID) {
							s SubAppMaxQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMMaxQty"))
							s AppReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
						}else{
							s OneReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
							if OneReserveQty<0 s OneReserveQty=0
							s OtherReservSum=OtherReservSum+OneReserveQty
						}
					}
					s leftOtherLeft=TRAMAppMethodIDLeft-OtherReservSum
					if (SubAppMaxQty'=""){
						s SubleftAppMaxQty=SubAppMaxQty-$G(TRAMAppQueueArry(AppMethodID,1))
						if (SubleftAppMaxQty>leftOtherLeft){s SubAvailableNum=leftOtherLeft}else{s SubAvailableNum=SubleftAppMaxQty}
					}else{
						s SubAvailableNum=leftOtherLeft
					}
					;计算总保留数和其他分时段保留数 与本时段保留数的联动控制
					s OtherEndNo=0
					s AppMaxLeft=+$g(ASQQueueMethodArry(AppMethodID,"Max"))
					if (AppMaxLeft'=0)&&(RegType="APP"){
						k ConectOtherASTR
						s OtherASTRSub=0 for {
							s OtherASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub))
							q:OtherASTRSub=""
							continue:OtherASTRSub=ASTRSub
							s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",3)
							s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",4)
							s OtherSttNo=OtherEndNo+1,OtherEndNo=OtherEndNo+TRLoad
							if (TRQueueNoStr'=""){
								s OtherSttNo=+$P(TRQueueNoStr,",",1)
								s OtherEndNo=+$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
							}
							for OtherQueuENo=OtherSttNo:1:OtherEndNo{
								continue:$g(QueueNoList(OtherQueuENo))=""
								s OneMethodID=$P(QueueNoList(OtherQueuENo),":",3)
								s Status=$P(QueueNoList(OtherQueuENo),":",2)
								if ("123"[Status){
									if $G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))=0 s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=1
									else  s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=$G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))+1
								}
							}
							s OtherTRAMSub=0 for{
								s OtherTRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub))
								q:OtherTRAMSub=""
								s OtherTRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",1)
								s OtherTRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",2)
								s OtherTRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",3)
								s ConectOtherASTR(OtherTRAMAppMethodID,"Max",OtherASTRSub)=OtherTRAMMaxQty
								s ConectOtherASTR(OtherTRAMAppMethodID,"Reserve",OtherASTRSub)=OtherTRAMReserveQty
							}
							//if (($G(ConectOtherASTR(AppMethodID,"Max",OtherASTRSub))'="")||($G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))'="")){
								s OtherOneMax=$G(ConectOtherASTR(AppMethodID,"Use",OtherASTRSub))-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
								if (OtherOneMax<=0) s OtherOneMax=0
								s AppMaxLeft=AppMaxLeft-OtherOneMax-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
							//}
							b ;0334dAppMaxLeft
						}
						s AppMaxLeft=AppMaxLeft-$G(TRAMAppQueueArry(AppMethodID,1))
						b ;AppMaxLeft
						if ((AppMaxLeft<=0)&&(+$g(ASQQueueMethodArry(AppMethodID,"Max"))'=0)) s AvailableNum=0
					}
					b ///
					k CGClinicGroupArry
					s TRCGSub=0 for{
						s TRCGSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub))
						q:TRCGSub=""
						s TRCGClinicGroupId=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
						s TRCGQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
						s ^tempqujian("TRCGClinicGroupId")=$lb(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub)
						if (TRCGClinicGroupId'=""){
							s CGClinicGroupArry(TRCGClinicGroupId)=$G(CGClinicGroupArry(TRCGClinicGroupId))+TRCGQty
						}
					}
					b ;33
					s ClinicGroupTRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
					for OneQueuENo=OneSttNo:1:OneEndNo{
						continue:$g(QueueNoList(OneQueuENo))=""
						s OneMethodID=$P(QueueNoList(OneQueuENo),":",3)
						s Status=$P(QueueNoList(OneQueuENo),":",2)
						s CGClinicGroupId=$P(QueueNoList(OneQueuENo),":",6)
						if ("123"[Status){
							s ClinicGroupTRLoad=ClinicGroupTRLoad-1
							if (CGClinicGroupId'=""){
								b ;33333
								if ($G(CGClinicGroupArry(CGClinicGroupId))>0) s CGClinicGroupArry(CGClinicGroupId)=$G(CGClinicGroupArry(CGClinicGroupId))-1
							}
						}
					}
					b ;66
					s SamGroupID="",SamLoadNub=0
					for{
						s SamGroupID=$O(CGClinicGroupArry(SamGroupID))
						q:SamGroupID=""
						s SamLoadNub=SamLoadNub+$G(CGClinicGroupArry(SamGroupID))
						}
					if (ClinicGroupId'=""){
						s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub+$G(CGClinicGroupArry(ClinicGroupId))
					}else{
						s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub	
					}
					b ;ClinicAvailableNum
					if (ClinicAvailableNum<AvailableNum) s AvailableNum=ClinicAvailableNum
					if ((RegType="APP")&&(leftAppMaxQty<SubAvailableNum)) s SubAvailableNum=leftAppMaxQty
					if (SubAvailableNum<AvailableNum) s AvailableNum=SubAvailableNum
					if AvailableNum<0 s AvailableNum=0
					s NewAvailableNum=AvailableNum
					
				}
				if (NewAvailableNum=0) s AvailableNum=NewAvailableNum
			
			}elseif(TRFlag="Y") {
				s ClinicAvailableNum=0
				s AllCGClinicGroupNum=0
				s ASTRSub=0 for {
					s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
					q:ASTRSub=""
					k CGClinicGroupArry
					s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
					if (TRQueueNoStr'=""){
						s OneSttNo=+$P(TRQueueNoStr,",",1)
						s OneEndNo=+$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
					}
					s TRCGSub=0 for{
						s TRCGSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub))
						q:TRCGSub=""
						s TRCGClinicGroupId=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
						s TRCGQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",2)
						s CGClinicGroupArry(TRCGClinicGroupId)=$G(CGClinicGroupArry(TRCGClinicGroupId))+TRCGQty
					}
					s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
					for OneQueuENo=OneSttNo:1:OneEndNo{
						continue:$g(QueueNoList(OneQueuENo))=""
						s OneMethodID=$P(QueueNoList(OneQueuENo),":",3)
						s Status=$P(QueueNoList(OneQueuENo),":",2)
						s CGClinicGroupId=$P(QueueNoList(OneQueuENo),":",6)
						if ("123"[Status){
							s TRLoad=TRLoad-1
							if (CGClinicGroupId'=""){
								if ($G(CGClinicGroupArry(CGClinicGroupId))>0) s CGClinicGroupArry(CGClinicGroupId)=$G(CGClinicGroupArry(CGClinicGroupId))-1
							}
						}
					}
					s SamGroupID="",SamLoadNub=0
					for{
						s SamGroupID=$O(CGClinicGroupArry(SamGroupID))
						q:SamGroupID=""
						s SamLoadNub=SamLoadNub+$G(CGClinicGroupArry(SamGroupID))
						}
					if (ClinicGroupId'=""){
						s ClinicAvailableNum=ClinicAvailableNum+TRLoad-SamLoadNub+$G(CGClinicGroupArry(ClinicGroupId))
					}else{
						s ClinicAvailableNum=ClinicAvailableNum+TRLoad-SamLoadNub	
					}
				}
				if (ClinicAvailableNum<AvailableNum) s AvailableNum=ClinicAvailableNum
			}
		}
	}
	
	i (AllowAddRegFlag'="N"){
		if (RegType="NOR")&&(StartTime="")&&(EndTime=""){
			s OneQueueNoStr=""
			d AddQueueNoStream.Rewind()
			While 'AddQueueNoStream.AtEnd {
				s One=AddQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'AddQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
			 	;s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
					s AvailableNum=AvailableNum+1
			 	}
			}
		}
		i (RegType="ADD") {
		 	s OneQueueNoStr=""
			d AddQueueNoStream.Rewind()
			While 'AddQueueNoStream.AtEnd {
				s One=AddQueueNoStream.Read(1)
				i One'="," {
					s OneQueueNoStr=OneQueueNoStr_One
					continue:'AddQueueNoStream.AtEnd
				}
				s SingleQueueNoStr=OneQueueNoStr
				s OneQueueNoStr=""
			 	;s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 	s QueueNo=$P(SingleQueueNoStr,":",1)
			 	;未取号和已退号的可用
			 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
					s AvailableNum=AvailableNum+1
			 	}
		 	}
	 	}
	}
	q AvailableNum
}

/// 得到预约限额
/// w ##class(web.DHCRBAppointment).GetAppSeqNo("1||14","APP","WIN","2",30600,32400)
ClassMethod GetAppSeqNo(RBASId As %String, APPMethodCode As %String = "", HospitalID As %String = "")
{
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //便捷排班
	s AvailableNum=0
	i APPMethodCode=""  s APPMethodCode="WIN"
	s AppMethodID=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
	s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
	s ASLoad=$p(^RBAS(ResRowId,Childsub),"^",8)
	if NoLimitLoadFlag="Y"{
		Q ASLoad	
	}
	s AppMaxQty=""
	s ASQSub=0 for{
		s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
		Q:ASQSub=""  
		s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
		if (ASMethodID=AppMethodID) {
			s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
			s AppReserveQty=0
		}
	}
	if (AppMaxQty'="") s AppQty=AppMaxQty
	q AppQty
}

/// Desc:提供给对外预约挂号接口取可用号串的方法,可用号串仅供参考，不作为实际展示的数据，以免引起无解
/// 由web.DHCRBAppointment.cls GetSepcSeqNoNew方法改造而来
/// Debug:w ##class(web.DHCRBAppointment).GetAvailableSeqNoStr("1180||4","NOR","","2","","","Y")
ClassMethod GetAvailableSeqNoStr(RBASId As %String, RegType As %String, APPMethodCode As %String = "", HospitalID As %String = "", StartTime As %String = "", EndTime As %String = "", AllowAddRegFlag As %String = "", ClinicGroupId As %String = "") As %String
{
	s SingleQueueNo=""
	s QueueNoStr=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	Q:'$d(^RBAS(ResRowId,Childsub)) -1
	s RBLocDr=$P(^RB("RES",ResRowId),"^",1)
	if (HospitalID=""){
		s HospitalID=$P(^CTLOC(RBLocDr),"^",22)
	}
	s AppReturnTime=0
	s TRRowId=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",17)
	if TRRowId'="" s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
	s CurrentTime=..%SysTime()
	s StopRegNoFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",27) //停正号
	i APPMethodCode=""  s APPMethodCode="WIN"
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
 	;正号串与加号串
 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	if (NormalQueueNoStr="")&&((RegType="NOR")||(RegType="APP")||(RegType="NORN")) {
		Q QueueNoStr
 	}
	;如果勾选停正号，则不能再预约和挂正号，只能取加号号段
 	if (StopRegNoFlag="Y") {
	 	if (RegType="NOR"){s RegType="ADD"}
	 	elseif ((RegType="APP")||(RegType="NORN")){
			Q QueueNoStr
		}
	}
 	
	if ((RegType="NOR")||(RegType="NORN")||(RegType="APP")){
		;先讲目前号的状况放到数组里
		s AppMethodID=""
		i APPMethodCode=""  s APPMethodCode="WIN"
		s AppMethodID=$O(^RBC("APTM",0,"Code",APPMethodCode,0))
		s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
		s len=$l(NormalQueueNoStr,",")
		s ASQSub=0 for{
			s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
			Q:ASQSub=""  
			s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
			s ASQQueueArry(ASMethodID)=1
		}
		;先计算总体还剩多少可以挂的号,为保留号留足号源
		;当前预约方式已用号数，剩余可用号数，所有已用号数
		s MethodUsedQty=0,MastLeftQty=0,myMethodUsedQty=0
		f i=1:1:len{
			s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
			s QueueNo=$P(SingleQueueNoStr,":",1)
			s QueueStatus=$P(SingleQueueNoStr,":",2)
			s MethodID=$P(SingleQueueNoStr,":",3)
			s ReturnAllowRegFlag=..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID)
			if ((MethodID="")) s MethodID=$O(^RBC("APTM",0,"Code","WIN",0))
			if (((QueueStatus=0)&&(ReturnAllowRegFlag))||("123"[QueueStatus)) {
				s myMethodUsedQty=myMethodUsedQty+1
				if ((MethodID=AppMethodID)) s MethodUsedQty=MethodUsedQty+1
				if $G(ASQQueueArry(MethodID,1))="" s ASQQueueArry(MethodID,1)=1
				else  s ASQQueueArry(MethodID,1)=$G(ASQQueueArry(MethodID,1))+1
			}
			
			if (('ReturnAllowRegFlag)) s MastLeftQty=MastLeftQty+1
			s QueueNoList(QueueNo)=SingleQueueNoStr
		}
		;再取对应预约方式的号串
		if (RegType="APP"){
			s StartNo=$p(^RBAS(ResRowId,Childsub),"^",10)
			s:StartNo="" StartNo=1
			s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
			;s EndNo=StartNo+AppQty-1
			s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
			s MastLeftQty=AppQty-myMethodUsedQty
		}else{
			s StartNo=1
			s EndNo=+$P(NormalQueueNoStr,",",$l(NormalQueueNoStr,","))
		}
		;算总的能最大预约数，保留号数和其他预约数
		;AppReserveQty当前预约方式的保留号数
		;OtherReservSum其他预约方式的保留余号
		;SubMastLeftQty-没用到
		;AppReservSum当前预约方式的保留余号
		;AppMaxQty当前预约方式预约限额，当日窗口取正号限额
		;SumAppMaxQty所有预约方式的预约限额，非预约取正号限额
		s (AppReserveQty,OtherReservSum,SubMastLeftQty,AppReservSum,AppMaxQty)=0
		s AppMaxQty=""
		s SumAppMaxQty=$l(NormalQueueNoStr,",")
		if (RegType="APP") s SumAppMaxQty=AppQty
		s ASQSub=0 
		for{
			s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
			Q:ASQSub=""  
			s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
			continue:ASMethodID=""
			s ASQQueueMethodArry(ASMethodID,"Max")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
			s ASQQueueMethodArry(ASMethodID,"Reserve")=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
			s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
			if (RegType'="APP")&&(NowDateFLag'="Y"){
				if (ASMethodID=AppMethodID) {
					if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
						s AppMaxQty=$l(NormalQueueNoStr,",")
					}else{
						s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
					}
					s AppReserveQty=0
				}
			}elseif (RegType'="APP")&&(NowDateFLag="Y"){
				if (ASMethodID=AppMethodID) {
					if ($O(^RBC("APTM",0,"Code","WIN",0))=ASMethodID){
						s AppMaxQty=$l(NormalQueueNoStr,",")
					}else{
						s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
					}
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if AppReservSum<0 s AppReservSum=0
				}else{
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if OneReserveQty<0 s OneReserveQty=0
					s OtherReservSum=OtherReservSum+OneReserveQty
				}
			}else{
				if (ASMethodID=AppMethodID) {
					s AppMaxQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s AppReservSum=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if AppReservSum<0 s AppReservSum=0
				}else{
					s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
					s OneReserveQty=AppReserveQty-$G(ASQQueueArry(ASMethodID,1))
					if OneReserveQty<0 s OneReserveQty=0
					s OtherReservSum=OtherReservSum+OneReserveQty
				}
			}
		}
		///计算当天可以预约的数量：所有预约方式的预约限额-其他预约方式的保留余号-所有已用号数
		s myAppMaxQty=SumAppMaxQty-OtherReservSum-myMethodUsedQty
		if (SumAppMaxQty<0){
			Q QueueNoStr
		}elseif (SumAppMaxQty<=MethodUsedQty){
			;所有预约方式的预约限额<当前预约方式已用号数
			///该预约方式在本次已经超过最大预约限额了
			;Q QueueNoStr
		}elseif ((OtherReservSum>=MastLeftQty)&&(AppReservSum=0)){
			;其他预约方式的保留余号>剩余可用号数 && 当前预约方式的保留余号
			//该排班的剩保留号可用个数大于等于可以挂的个数
			;Q QueueNoStr
		}elseif (+myAppMaxQty<=0)&&(RegType="APP") {
			Q QueueNoStr
		}elseif (MethodUsedQty>=AppMaxQty)&&(AppMaxQty'="")&&(RegType="APP") {
			///本次预约当前预约方式可使用数
			Q QueueNoStr
		}else{
			;分为分时段的和未分时段的
			if ((StartTime'="")&&(EndTime'="")){
				s StartTime=..%ZTH(StartTime)
				s EndTime=..%ZTH(EndTime)
			}
			s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)	
			i TRFlag="Y" {
				s OneEndNo=0,TRAMMaxQtySum=0,TRAMReserveQtySum=0
				if ($O(^RBAS(ResRowId,Childsub,"ASTR",0))=""){
					s TRNoStr=StartNo_"-"_EndNo
					s TRList("MethodTR",1)=TRNoStr
				}
				s SeqNoOverRangeTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTime",HospitalID)
				s SessTime=..%SysTime()
				s ASDate=$P($G(^RBAS(ResRowId,Childsub)),"^",1)
				if (ASDate>+$H) s SeqNoOverRangeTime=0
				s ASTRSub=0 for {
					s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
					q:ASTRSub=""
					s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
					s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
					s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
					if (TRQueueNoStr'=""){
						s OneSttNo=+$P(TRQueueNoStr,",",1)
						s OneEndNo=+$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
					}
					if ($O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))="")&&(OneEndNo<EndNo){
						s OneEndNo=EndNo		//最后一个时段默认要包含剩余所有的正号
					}
					s starttime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
					s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
					if ((StartTime'="")&&(EndTime'="")){
						continue:((starttime>StartTime)||(EndTime>endtime))
					}
					continue:((SeqNoOverRangeTime=1)&&(SessTime>endtime))
					;先取出最大号数，保留号数和可挂剩余号数
					s LeftQty=TRLoad,TRAMMaxQty="",TRAMReserveQty="",MethodExistFlag=0
					k TRAMAppQueueArry
					s TRAMSub=0 for{
						s TRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub))
						q:TRAMSub=""
						s TRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",1)
						s TRAMAppQueueArry(TRAMAppMethodID)=1
						s NowDateFLag=$P(^RBC("APTM",TRAMAppMethodID),"^",7)
						s TRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",2)
						s TRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRAM",TRAMSub),"^",3)
						if ((RegType'="APP")&&(NowDateFLag'="Y")){
							s TRAMReserveQty=0
							s TRAMMaxQty=TRLoad
						}
						s TRAMAppQueueArry(TRAMAppMethodID,"TRAMMaxQty")=TRAMMaxQty
						s TRAMAppQueueArry(TRAMAppMethodID,"TRAMReserveQty")=TRAMReserveQty
					}
					;b ;计算已经挂过号，看是否还有号可以挂
					s TRAMAppMethodIDLeft=0,TRAMUserQty=0
					for oneQueuENo=OneSttNo:1:OneEndNo{
						continue:$g(QueueNoList(oneQueuENo))=""
						s OneMethodID=$P(QueueNoList(oneQueuENo),":",3)
						s Status=$P(QueueNoList(oneQueuENo),":",2)
						if (('..GetReturnAllowRegFlag(QueueNoList(oneQueuENo),"",HospitalID))) s TRAMAppMethodIDLeft=TRAMAppMethodIDLeft+1
						if OneMethodID=AppMethodID s TRAMUserQty=TRAMUserQty+1
						if ("123"[Status){
							if $G(TRAMAppQueueArry(OneMethodID,1))=0 s TRAMAppQueueArry(OneMethodID,1)=1
							else  s TRAMAppQueueArry(OneMethodID,1)=$G(TRAMAppQueueArry(OneMethodID,1))+1
						}
					}
					if TRAMAppMethodIDLeft=0 Continue
					;计算这个时段是否还有号可以用
					s ASMethodID="",TRAMAppSubMastLeftQty=0,AppMaxQty=TRLoad,AppReserveQty=0,OneOtherReservSum=0
					for {
						s ASMethodID=$O(TRAMAppQueueArry(ASMethodID))
						q:ASMethodID=""
						s NowDateFLag=$P(^RBC("APTM",ASMethodID),"^",7)
						if (ASMethodID=AppMethodID) {
								s AppMaxQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMMaxQty"))
								s AppReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
						}else{
							s OneReserveQty=$g(TRAMAppQueueArry(ASMethodID,"TRAMReserveQty"))-$G(TRAMAppQueueArry(ASMethodID,1))
							if OneReserveQty<0 s OneReserveQty=0
							s OneOtherReservSum=OneOtherReservSum+OneReserveQty
						}
					}
					;计算总保留数和其他分时段保留数 与本时段保留数的联动控制
					s OtherEndNo=0
					s AppMaxLeft=+$g(ASQQueueMethodArry(AppMethodID,"Max"))
					if (AppMaxLeft'=0)&&(RegType="APP"){
						k ConectOtherASTR
						s OtherASTRSub=0 for {
							s OtherASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub))
							q:OtherASTRSub=""
							continue:OtherASTRSub=ASTRSub
							s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",3)
							s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub),"^",4)
							s OtherSttNo=OtherEndNo+1,OtherEndNo=OtherEndNo+TRLoad
							if (TRQueueNoStr'=""){
								s OtherSttNo=$P(TRQueueNoStr,",",1)
								s OtherEndNo=$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
							}
							for OtherQueuENo=OtherSttNo:1:OtherEndNo{
								continue:$g(QueueNoList(OtherQueuENo))=""
								s OneMethodID=$P(QueueNoList(OtherQueuENo),":",3)
								s Status=$P(QueueNoList(OtherQueuENo),":",2)
								if ("123"[Status){
									if $G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))=0 s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=1
									else  s ConectOtherASTR(OneMethodID,"Use",OtherASTRSub)=$G(ConectOtherASTR(OneMethodID,"Use",OtherASTRSub))+1
								}
							}
							s OtherTRAMSub=0 for{
								s OtherTRAMSub=$O(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub))
								q:OtherTRAMSub=""
								s OtherTRAMAppMethodID=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",1)
								s OtherTRAMMaxQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",2)
								s OtherTRAMReserveQty=$P(^RBAS(ResRowId,Childsub,"ASTR",OtherASTRSub,"TRAM",OtherTRAMSub),"^",3)
								s ConectOtherASTR(OtherTRAMAppMethodID,"Max",OtherASTRSub)=OtherTRAMMaxQty
								s ConectOtherASTR(OtherTRAMAppMethodID,"Reserve",OtherASTRSub)=OtherTRAMReserveQty
							}
							//if (($G(ConectOtherASTR(AppMethodID,"Max",OtherASTRSub))'="")||($G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))'="")){
								s OtherOneMax=$G(ConectOtherASTR(AppMethodID,"Use",OtherASTRSub))-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
								if (OtherOneMax<=0) s OtherOneMax=0
								s AppMaxLeft=AppMaxLeft-OtherOneMax-$G(ConectOtherASTR(AppMethodID,"Reserve",OtherASTRSub))
							//}
						}
						s AppMaxLeft=AppMaxLeft-$G(TRAMAppQueueArry(AppMethodID,1))
						if ((AppMaxLeft<=0)&&(+$g(ASQQueueMethodArry(AppMethodID,"Max"))'=0)) Continue
					}
					///亚专业可用号源
					k CGClinicGroupArry
					s TRCGSub=0 for{
						s TRCGSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub))
						q:TRCGSub=""
						s TRCGClinicGroupId=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
						s TRCGQty=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub,"TRCG",TRCGSub),"^",1)
						s CGClinicGroupArry(TRCGClinicGroupId)=$G(CGClinicGroupArry(TRCGClinicGroupId))+TRCGQty
					}
					s ClinicGroupTRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
					for OneQueuENo=OneSttNo:1:OneEndNo{
						continue:$g(QueueNoList(OneQueuENo))=""
						s OneMethodID=$P(QueueNoList(OneQueuENo),":",3)
						s Status=$P(QueueNoList(OneQueuENo),":",2)
						s CGClinicGroupId=$P(QueueNoList(OneQueuENo),":",6)
						if ("123"[Status){
							s ClinicGroupTRLoad=ClinicGroupTRLoad-1
							if (CGClinicGroupId'=""){
								if ($G(CGClinicGroupArry(CGClinicGroupId))>0) s CGClinicGroupArry(CGClinicGroupId)=$G(CGClinicGroupArry(CGClinicGroupId))-1
							}
						}
					}
					s SamGroupID="",SamLoadNub=0
					for{
						s SamGroupID=$O(CGClinicGroupArry(SamGroupID))
						q:SamGroupID=""
						s SamLoadNub=SamLoadNub+$G(CGClinicGroupArry(SamGroupID))
						}
					if (ClinicGroupId'=""){
						s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub+$G(CGClinicGroupArry(ClinicGroupId))
					}else{
						s ClinicAvailableNum=ClinicGroupTRLoad-SamLoadNub	
					}
					b ;ClinicAvailableNum
					if (ClinicAvailableNum<=0) Continue
					;if ((TRAMUserQty>=AppMaxQty)&&(AppMaxQty'="")) Continue
					continue:(TRAMUserQty>=(+AppMaxQty))
					if ((OneOtherReservSum>=TRAMAppMethodIDLeft)&&(AppReserveQty<=0)) Continue
					s node=$O(TRList("MethodTR",""),-1)+1
					s TRSttTime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",1)
					s TREndTime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
					s TRList("MethodTR",node)=OneSttNo_"-"_OneEndNo_"^"_TRSttTime_"-"_TREndTime
				 }
			}else{
				;没有分时段则
				s TRNoStr=StartNo_"-"_EndNo
				s TRList("MethodTR",1)=TRNoStr
			}
			s SingleQueueNo=0
			s node=0 for{
				s node=$O(TRList("MethodTR",node)) 
				q:node=""
				s oneTRNOStr=$p(TRList("MethodTR",node),"^",1)
				s SttNo=$P(oneTRNOStr,"-",1),EddNo=$P(oneTRNOStr,"-",2)
				for QueueNo=SttNo:1:EddNo{
					continue:$G(QueueNoList(QueueNo))=""
					continue:(QueueNo<StartNo)||(QueueNo>EndNo)
					s QueueNoStatus=$P(QueueNoList(QueueNo),":",2)
					i RegType="NORN" {
						i (('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))){
							s SingleQueueNo=QueueNo
							if (+AppQty=0){s RegType="NOR"}
							else {
								;取非预号段内的号,此处有问题,需单独写方法判断顺序号是否在预约号段记录中
								s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo)
								if QueueNoInAppFlag'=1 {
									i QueueNoStr="" s QueueNoStr=QueueNo
			 						e  s QueueNoStr=QueueNoStr_","_QueueNo
								}
							}
						}
					}
					//b  ;当日挂号取号
					i RegType="NOR" {
						if QueueNoStatus=2{
							//按分时段里时间来回归
							Set AppReturnTime1=""
							Set ApptRowid=##class(web.DHCOPAdmReg).getApptRowidByQueNo(RBASId,QueueNo)
							if ApptRowid'="" Set AppReturnTime1=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo(RBASId,QueueNo)   //$g(^RBAS(+ApptRowid,$p(ApptRowid,"||",2),"APPT",$p(ApptRowid,"||",3),"DHCRetTime"))
							if AppReturnTime1'="" Set AppReturnTime2=AppReturnTime1
							else  Set AppReturnTime2=AppReturnTime 
						}
						;未取号和已退号的可用,已经回归的预约的号可挂
						i (('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))||(('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus,"Y",HospitalID))&&(CurrentTime>AppReturnTime2))){
							s SingleQueueNo=QueueNo
							i QueueNoStr="" s QueueNoStr=QueueNo
			 				e  s QueueNoStr=QueueNoStr_","_QueueNo
						}
					}
					
					i RegType="APP" {
						i (('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoList(QueueNo),"",HospitalID))){
							;b ;只取预约号段里的号
							//s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,AppMethodID)
							//i QueueNoInAppFlag=1 s SingleQueueNo=QueueNo
							s SingleQueueNo=QueueNo
							i QueueNoStr="" s QueueNoStr=QueueNo
			 				e  s QueueNoStr=QueueNoStr_","_QueueNo
						}
					}
				}
			}
		}
	}
	i (QueueNoStr="")&&(RegType="NOR")  s RegType="ADD"
	i (AllowAddRegFlag'="N")&&(RegType="ADD") {
	 	for i=1:1:$l(AddQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	;未取号和已退号的可用
		 	i (('..GetReturnAllowRegFlag(SingleQueueNoStr,"",HospitalID))){
				s SingleQueueNo=QueueNo
				i QueueNoStr="" s QueueNoStr=QueueNo
 				e  s QueueNoStr=QueueNoStr_","_QueueNo
		 	}
	 	}
 	}
	Q QueueNoStr
}

/// Author:	xkl
/// Date:	20201009
/// Desc:	取消预约 - 导出预约查询结果对应程序
/// Table:	
/// Input:	
/// Output:	
/// Debug:	d ##class(%ResultSet).RunQuery("web.DHCRBAppointment","ApptFindExport","","","23/12/2020","","","","IAX","","","","","","",2)
/// Others:	封装 Find 方法
Query ApptFindExport(AdmDepRowId As %String, AdmDocRowId As %String, StartDate As %Date, EndDate As %Date, PatientNo As %String, PatientID As %String, AppStatus As %String, vRBASID As %String, PatName As %String, PatTel As %String, PatCredNo As %String, TimeRangeRowID As %String, UpdateUser As %String, LogonHospId As %String = "") As %Library.Query(ROWSPEC = "AppDate:%String:预约日期,DepDesc:%String:科室,DocDesc:%String:医生,SessType:%String:医生职称,MethodDesc:%String:预约方式,QueueNo:%String:诊号,StatusDesc:%String:预约状态,StatusChangeDate:%String:取号/取消日期,StatusChangeTime:%String:取号/取消时间,StatusChangeUserName:%String:取号/取消办理人,PatientName:%String:患者姓名,Sum:%String:金额,RBASStatusDesc:%String:医生状态,RBASStatusReason:%String:停替诊原因,TRDoc:%String:替诊医生,APERTel:%String:预约人电话,CardCommonAppInfo:%String:公共卡预约信息,EmployeeFunction:%String:患者级别,SecretLevel:%String:患者密级,PatientRegNo:%String:登记号,PatientAge:%String:年龄")
{
}

ClassMethod ApptFindExportExecute(ByRef qHandle As %Library.Binary, AdmDepRowId As %String, AdmDocRowId As %String, StartDate As %Date, EndDate As %Date, PatientNo As %String, PatientID As %String, AppStatus As %String, vRBASID As %String, PatName As %String, PatTel As %String, PatCredNo As %String, TimeRangeRowID As %String, UpdateUser As %String, LogonHospId As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("web.DHCRBAppointment:Find")
	d rset.Execute(AdmDepRowId, AdmDocRowId, StartDate, EndDate, PatientNo, PatientID, AppStatus, vRBASID, PatName, PatTel, PatCredNo, TimeRangeRowID, UpdateUser, LogonHospId)
	While (rset.Next()) {
		s AppDate = rset.Data("AppDate")
		s DepDesc = rset.Data("DepDesc")
		s DocDesc = rset.Data("DocDesc")
		s SessType = rset.Data("SessType")
		s MethodDesc = rset.Data("MethodDesc")
		s QueueNo = rset.Data("QueueNo")
		s StatusDesc = rset.Data("StatusDesc")
		s StatusChangeDate = rset.Data("StatusChangeDate")
		s StatusChangeTime = rset.Data("StatusChangeTime")
		s StatusChangeUserName = rset.Data("StatusChangeUserName")
		s PatientName =  rset.Data("PatientName")
		s Sum = rset.Data("Sum")
		s RBASStatusDesc = rset.Data("RBASStatusDesc")
		s RBASStatusReason = rset.Data("RBASStatusReason")
		s TRDoc = rset.Data("TRDoc")
		s PAPERTel = rset.Data("PAPERTel")
		s CardCommonAppInfo = rset.Data("CardCommonAppInfo")
		s EmployeeFunction = rset.Data("EmployeeFunction")
		s SecretLevel = rset.Data("SecretLevel")
		s PatientRegNo = rset.Data("PatientRegNo")
		s PatientAge = rset.Data("PatientAge")
		s OutputList=$lb(AppDate, DepDesc, DocDesc, SessType, MethodDesc, QueueNo, StatusDesc, StatusChangeDate, StatusChangeTime, StatusChangeUserName, PatientName, Sum, RBASStatusDesc, RBASStatusReason, TRDoc, PAPERTel, CardCommonAppInfo, EmployeeFunction, SecretLevel, PatientRegNo,PatientAge)
		d OutputRowApptFind
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRowApptFind
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ApptFindExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ApptFindExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ApptFindExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ApptFindExportFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCRBAppointment).CheckRestoreSeqNo("2||159","1","Return",2)
ClassMethod CheckRestoreSeqNo(RBASId As %String, SeqNo As %String, Type As %String, HospID)
{
	s RestoreFlag=2
	q:((RBASId="")||(SeqNo="")||(Type="")) RestoreFlag
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	if HospID=""  s HospID=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",RBASId,""),"^",1)	
	s ResRowId=+RBASId
	s ASChildSub=$P(RBASId,"||",2)
	s ASDate=$P($G(^RBAS(ResRowId,ASChildSub)),"^",1)
	
	if (ASDate>+$h){
		if (Type="AppCancle"){
			s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("BeforeDateCancelApp",HospID)
		}
		if (Type="Return"){
			s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("BeforeDateReturn",HospID)
		}
	}elseif (ASDate=..%SysDate()){
		s TRFlag=$p(^RBAS(ResRowId,ASChildSub,"DHC"),"^",19)	
		i TRFlag="Y" {
			s NowTime=..%SysTime()
			s OneEndNo=""
			s StartTime=""
			s ASTRSub=0 for {
				s ASTRSub=$O(^RBAS(ResRowId,ASChildSub,"ASTR",ASTRSub))
				q:ASTRSub=""
				s TRLoad=$P(^RBAS(ResRowId,ASChildSub,"ASTR",ASTRSub),"^",3)
				s OneSttNo=OneEndNo+1,OneEndNo=OneEndNo+TRLoad
				s starttime=$P(^RBAS(ResRowId,ASChildSub,"ASTR",ASTRSub),"^",1)
				if ((SeqNo>=OneSttNo)&&(SeqNo<=OneEndNo)){
					s StartTime=starttime
				}
				q:StartTime'=""
				}
			if (NowTime<StartTime){
				if (Type="AppCancle"){
					s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateSplitBeforeCancelApp",HospID)
				}
				if (Type="Return"){
					s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateSplitBeforeReturn",HospID)
				}
			}else{
				if (Type="AppCancle"){
						s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateSplitAfterCancelApp",HospID)
					}
					if (Type="Return"){
						s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateSplitAfterReturn",HospID)
					}
			}
		}else{
			if (Type="AppCancle"){
				s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateUnSplitCancelApp",HospID)
			}
			if (Type="Return"){
				s RestoreFlag=##Class(web.DHCOPRegConfig).GetSpecConfigNode("DateUnSplitReturn",HospID)
			}
		}
	}
	q RestoreFlag
}

ClassMethod AppCancelRestoreSeqNo(RBASId As %String, SeqNo As %String, Type As %String, HospID, APPMethodRowId As %String = "")
{
	q:((RBASId="")||(SeqNo="")||(Type=""))
	s ^tempqujina("AppCancelRestoreSeqNo")=RBASId_","_SeqNo_","_Type_","_HospID
	s RestoreFlag=..CheckRestoreSeqNo(RBASId , SeqNo , Type  ,HospID)
	s OldStatusCode=""
	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s SingleQueueNoAPPMethodRowIdFrist=""
	if RestoreFlag=1 {s StatusCode=0}else{s StatusCode=4}
	s RandomDateTime=""
	s ResoduSeqNoAnyTime=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("ResoduSeqNoAnyTime",HospID)
	if (ResoduSeqNoAnyTime=1){
		s RandomDateTime=..GetRandomTime(RBASId)
	}
	lock +^RBASLOCK(ResRowId,Childsub):10
	i $TEST {
	 	s SingleQueueNo=0
	 	s ASQueueNo=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",4)
	 	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 	s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 	if (NormalQueueNoStr="")&&(AddQueueNoStr=""){
			lock -^RBASLOCK(ResRowId,Childsub)
			Q 	
		}
	 	s Find=0
	 	for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	continue:(SingleQueueNoStr="")
		 	s SingleQueueNo=$P(SingleQueueNoStr,":",1)
		 	s SingleQueueNoAPPMethodRowId=$P(SingleQueueNoStr,":",3)
		 	i (SingleQueueNo=SeqNo) {
			 	s Find=1
			 	s SingleQueueNoAPPMethodRowIdFrist=$P(SingleQueueNoStr,":",3)
			 	s OldStatusCode=$P(SingleQueueNoStr,":",2)
				i APPMethodRowId'="" s SingleQueueNoAPPMethodRowId=APPMethodRowId
			 	if (StatusCode'=0)&&(SingleQueueNoAPPMethodRowId'="") {
		 			s $P(NormalQueueNoStr,",",i)=SeqNo_":"_StatusCode_":"_SingleQueueNoAPPMethodRowId_":"_RandomDateTime
			 	}else{
		 			s $P(NormalQueueNoStr,",",i)=SeqNo_":"_StatusCode_"::"_RandomDateTime
			 	}
		 	}
	 	}
	 	if Find'=1 {
		 	for i=1:1:$l(AddQueueNoStr,",") {
			 	s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 	continue:(SingleQueueNoStr="")
			 	s SingleQueueNo=$P(SingleQueueNoStr,":",1)
			 	;s SingleQueueNoAPPMethodRowId=$P(SingleQueueNoStr,":",3)
			 	i (SingleQueueNo=SeqNo) {
				 	s Find=1
		 			if (StatusCode=0){
			 			s $P(AddQueueNoStr,",",i)=SeqNo_":"_StatusCode_"::"_RandomDateTime
			 		}else{
				 		s $P(AddQueueNoStr,",",i)=SeqNo_":"_StatusCode	
				 	}
			 	}
		 	}
	 	}
	 	if Find=1 {
		 	s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
		 	s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
		 	s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
	 	}
	}
	if ((RestoreFlag=3)&&(SeqNo'["+")) {
		d ..AddOneScheduleQueue(RBASId,SingleQueueNoAPPMethodRowIdFrist,HospID)
	}	
	lock -^RBASLOCK(ResRowId,Childsub)
}

/// 过时段号源不能挂出并增号(增加到最后一个时段)
/// w ##class(web.DHCRBAppointment).SeqNoOverRangeTimeAdd("7||106",2)
ClassMethod SeqNoOverRangeTimeAdd(RBASId, HospID = "")
{
	q:((RBASId="")) ""
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s SeqNoOverRangeTimeAdd=##class(web.DHCOPRegConfig).GetSpecConfigNodeHosp("SeqNoOverRangeTimeAdd",HospID)
	s ResRowId=+RBASId
	s Childsub=$P(RBASId,"||",2)
	s SessTime=..%SysTime()
	s ASDate=$P($G(^RBAS(+RBASId,$p(RBASId,"||",2))),"^",1)
	s CurDate=..%SysDate()
	

	if ((SeqNoOverRangeTimeAdd=1)&&(ASDate=CurDate)){
		s TRFlag=$p(^RBAS(ResRowId,Childsub,"DHC"),"^",19)
		i TRFlag="Y" {
			
			s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",""),-1)
			q:((ASTRSub="")) ""
			s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
			q:(endtime="") ""
			q:(SessTime>endtime) ""		//最后一个时段也小于当前时间时，则不需要处理
			s LastSeqNoOverRangeTime=$G(^RBAS(ResRowId,Childsub,"local","LastSeqNoOverRangeTime"))
			if (LastSeqNoOverRangeTime'=""){
				//每分钟最多处理一次
				if $ZABS(LastSeqNoOverRangeTime-..%SysTime())<60 {
					quit ""
				}
			}
			s ^RBAS(ResRowId,Childsub,"local","LastSeqNoOverRangeTime")=..%SysTime()
			//每分钟最多处理一次
			s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
			;正号串与加号串
			s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
			s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
			s EndSeqNo=""
			s ASTRSub=0 for {
				s ASTRSub=$O(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub))
				q:ASTRSub=""
				s TRLoad=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",3)
				s TRQueueNoStr=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",4)
				s endtime=$P(^RBAS(ResRowId,Childsub,"ASTR",ASTRSub),"^",2)
				if (SessTime>endtime){
					s EndSeqNo=$P(TRQueueNoStr,",",$l(TRQueueNoStr,","))
				}
			}
			
			s AddNumber=0
			if (+EndSeqNo'=""){
				lock +^RBASLOCK(ResRowId,Childsub):10
				i $TEST {
					s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
					;正号串与加号串
					s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
					s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
					for i=1:1:$l(NormalQueueNoStr,",") {
						s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
						s SingleQueueNo=$P(SingleQueueNoStr,":",1)
						s SingleQueueNoStatus=$P(SingleQueueNoStr,":",2)
						i (SingleQueueNoStatus=0)&&(SingleQueueNo<=+EndSeqNo) {
							s $P(NormalQueueNoStr,",",i)=$P(SingleQueueNoStr,":",1)_":7:"_$P(SingleQueueNoStr,":",3)
							S AddNumber=AddNumber+1
						}
						if (SingleQueueNo>+EndSeqNo){
							quit
						}
					}
					if (AddNumber>0){
						s $P(ASQueueNo,$C(1),1)=NormalQueueNoStr
						s $P(ASQueueNo,$C(1),2)=AddQueueNoStr
						s $P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)=ASQueueNo
						for i=1:1:AddNumber {
							d ..AddOneScheduleQueue(RBASId,"",HospID)
						}
					}
				}
				lock -^RBASLOCK(ResRowId,Childsub)
			}
		}
	}
	q ""
}

ClassMethod GetRandomTime(RBASId As %String)
{
	s RandomTime=""
	s CurDate=..%SysDate()
	s CurrTime=..%SysTime()
	s ASDate=$P($G(^RBAS(+RBASId,$p(RBASId,"||",2))),"^",1)
	if (ASDate=CurDate){
		s TRRowId=$P($G(^RBAS(+RBASId,$p(RBASId,"||",2),"DHC")),"^",17)
		s EndTime=86399
		if TRRowId'="" s EndTime=$p($g(^DHCTimeRange(TRRowId)),"^",4)
		if (CurrTime>=EndTime){
			s RandomTime=CurrTime_":"_CurDate
		}else{
			s RandomTime=CurrTime+$random(EndTime-CurrTime)_":"_CurDate
		}
	}else{
		s EndTime=86399
		s RandomTime=CurrTime+$random(EndTime-CurrTime)_":"_CurDate
	}
	q RandomTime
}

/// 校验就诊登记时是否存在当日本科室的预约未取号数据
/// w ##class(web.DHCRBAppointment).CheckRegAppInfo("3",60,"18881^149^60^2^^20^30345")
ClassMethod CheckRegAppInfo(PatientID, RegLocID, SessionStr)
{
	s CheckInfo="",CuDate=+$h
	s HospID=$p(SessionStr,"^",4)
	s AppInfo=..GetAppInfo(PatientID,"",HospID,"","APP")
	
	for len=1:1:$l(AppInfo,","){
		s OneAppInfo=$p(AppInfo,",",len)
		s ASRowId=$p(OneAppInfo,"^",1)
		Continue:ASRowId'["||"
		s AppLocID=$p($g(^RB("RES",+ASRowId)),"^",1)
		s ASDate=$p($g(^RBAS(+ASRowId,$p(ASRowId,"||",2))),"^",1)
		Continue:(RegLocID'="")&&(RegLocID'=AppLocID)
		Continue:ASDate'=CuDate
		s MarkDesc=$p(OneAppInfo,"^",2)
		s LocDesc=$p(OneAppInfo,"^",7)
		s ScheduleDate=$p(OneAppInfo,"^",8)
		s TimeRange=$p(OneAppInfo,"^",13)
		s AppRowID=$p(OneAppInfo,"^",15)
		s Info="预约了"_ScheduleDate_"的"_LocDesc_"的"_MarkDesc_" "_TimeRange_"的号源"
		i CheckInfo="" s CheckInfo=Info
		e  s CheckInfo=CheckInfo_"; "_Info
	}	
	Q:CheckInfo="" "0^无当日预约记录"
	Q "-1^"_CheckInfo
}

}
