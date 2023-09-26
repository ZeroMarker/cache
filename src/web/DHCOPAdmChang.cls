Class web.DHCOPAdmChang Extends DHCDoc.Util.RegisteredObject
{

ClassMethod FindBroker(itmjs As %Library.String = "", AdmDepRowId As %String, AdmDocRowId As %String, CardNo As %String) As %String
{
	s desc=""
	s n=0
	Set rset=##Class(%ResultSet).%New("web.DHCOPAdmChang:Find")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(AdmDepRowId, AdmDocRowId,CardNo)
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

ClassMethod FindExecute(ByRef qHandle As %Binary, AdmDepRowId As %String, AdmDocRowId As %String, CardNo As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCOPAdmChang","Find","","","000765555555")
	s ^guo("FindExecute")=AdmDepRowId_"^"_AdmDocRowId_"^"_CardNo
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
	if CardNo="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s CardRefRowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
	if CardRefRowId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s PatientID=$p(^DHCCARD("CF",CardRefRowId),"^",4)

	//判断是否有公共卡
	s CommonPatientID=""
	s CommonCardNo=##class(web.DHCOPRegConfig).GetSpecConfigNode("CommonCardNo")
	i (CommonCardNo'="") {
		s ExpStr=""_$c(2)_""_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CommonCardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0"){
			s CommonPatientID=$P(ret,"^",8)
		}
	}
	//如果所查找的不是公共卡则退出
	//if (PatientID'=CommonPatientID) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s TCardNo=CardNo
	s ChangNoUser="",ChangNoDate="",ChangNoTime=""
	s TSum=0
 s PaadmRowid="" f  s PaadmRowid=$o(^PAADMi("PAADM_AdmDate",+$H,PaadmRowid)) q:PaadmRowid=""  d
 .s Tmount=0
 .;Q:($g(^RegChangNoLog("LOG",PaadmRowid))="")&&(CheckChange'="true")
 .s createuser=$p($g(^PAADM(PaadmRowid)),"^",43) ;pa_adm.PAADM_CreateUser
 .s refuser=$p($g(^PAADM(PaadmRowid,2)),"^",69)  ;PAADM_SocialWorkername
 .s time=$p($g(^PAADM(PaadmRowid)),"^",7) ;pa_adm.paadm_admtime
 .s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
 .q:VisitStatus="C"
 .s Uptime=$p($g(^PAADM(PaadmRowid,1)),"^",43) ;paadm.paadm_updatetime
 .s DepCodeDR=$p($g(^PAADM(PaadmRowid)),"^",4) ;pa_adm.PAADM_DepCode_DR
 .s AdmDocCodeDR=$p($g(^PAADM(PaadmRowid)),"^",9) ;pa_adm.PAADM_AdmDocCodeDR
 .q:(AdmDepRowId'="")&&(AdmDepRowId'=DepCodeDR)
 .q:(AdmDocRowId'="")&&(AdmDocRowId'=AdmDocCodeDR)
 .s PapmiId=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_patmas.rowid
 .Q:(CommonPatientID'=PapmiId)
 .s Admi=PaadmRowid
 .s RegisFee=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
 .i RegisFee'=""  d
 ..s InvoiceDr=$List(^User.DHCRegistrationFeeD(RegisFee),11)
 ..if InvoiceDr'="" s Tmount=$p(^DHCINVPRT(InvoiceDr),"^",16)
 ..s papmidr=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_adm.paadm_papmi_dr
 ..s TPatName=$p($g(^PAPER(papmidr,"ALL")),"^",1)
 ..s TPatMNo=$p($g(^PAPER(papmidr,"PAT",1)),"^",22) ;PAPMI_Medicare
 ..s TPatNo=$p($g(^PAPER(papmidr,"PAT",1)),"^",1)
 ..s PatCardRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmidr,""))
 ..s TCardNo=$p(^DHCCARD("CF",PatCardRowid),"^",2)
 ..s TLoc=""
 ..i DepCodeDR'=""  d
 ...s TLoc=$p($g(^CTLOC(DepCodeDR)),"^",2) 
 ..i $f(TLoc,"-")'=0  d
 ...s TLoc=$p(TLoc,"-",2)
 ..s TRegDoc=""
 ..i AdmDocCodeDR'=""  s TDoc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
 ..s TArcType=""
 ..s TRegDate=$zd(+$H,3) 
 ..s TTotalFee=$List(^User.DHCRegistrationFeeD(RegisFee),4)  ;RegfeeArcPrice
 ..s TFormFee=0
 ..s TExamFee=$List(^User.DHCRegistrationFeeD(RegisFee),9)  ;RegfeeLookPrice
 ..s TRegFee=TTotalFee-TExamFee
 ..s TRegFee=$j(TRegFee,3,2)
 ..s TExamFee=$j(TExamFee,3,2)
 ..s TUsrCode=$p($g(^SSU("SSUSR",createuser)),"^",1) ;ss_user.ssusr_initials
 ..s TUsrName=$p($g(^SSU("SSUSR",createuser)),"^",2) ;ss_user.ssusr_name
 ..s TRegTime=..%ZT(time,1)
 ..s TRefUsr=""
 ..i refuser'=""  s TRefUsr=$p($g(^SSU("SSUSR",refuser)),"^",1) ;$p($g(^SSU("SSUSR",refuser)),"^",1) ;ss_user.ssusr_initials
 ..s TRefTime=""
 ..i Uptime'=""  s TRefTime=..%ZT(Uptime,1)
 ..s TSeqNo=$List(^User.DHCRegistrationFeeD(RegisFee),8)  ;RegfeeNo
 ..s NewInfo=$p($g(^RegChangNoLog("LOG",PaadmRowid)),"!",2)
 ..;S ChangNoUser=$p($g(^RegChangNoLog("LOG",PaadmRowid)),"^",2) 
 ..;S ChangNoDate=$p($g(^RegChangNoLog("LOG",PaadmRowid)),"^",3)
 ..;s ChangNoDate=$zd(ChangNoDate,3)
 ..;S ChangNoTime=$p($g(^RegChangNoLog("LOG",PaadmRowid)),"^",4)  
 ..;s ChangNoTime=..%ZT(ChangNoTime,1)
 ..d OutputRow9
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9

	set Data=$lb(TRegDate,TLoc,TDoc,TSeqNo,TCardNo,TPatName,Tmount,ChangNoUser,ChangNoDate,ChangNoTime,PaadmRowid)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
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

ClassMethod OPRegArriveTransferBroker(ADMRowid, ChangeNo, UserRowId)
{
	;w ##class(web.DHCOPAdmChang).OPRegArriveTransferBroker("241","000000000003","6")
	s ^guo("OPRegArriveTransferBroker")=ADMRowid_"^"_ChangeNo_"^"_UserRowId
	//开了诊断不可以转号
	s kid=""
	
	s mm=0 f  s mm=$o(^MR(mm)) q:mm=""  d
	.s AdmDr=$p(^MR(mm,"PRO",1),"^",9)
	.q:AdmDr'=ADMRowid
	.s Childsub=0
	.f  s Childsub=$o(^MR(mm,"DIA",Childsub)) q:Childsub=""  d
	..s kid=mm_"||"_Childsub
	
	q:kid'="" "diagnos"
	
	s ^guo("OPRegArriveTransferBroker")=ADMRowid_"^"_ChangeNo_"^"_UserRowId
	s UserName=$p(^SSU("SSUSR",UserRowId),"^",2)
	s CardRefRowId=$o(^DHCCARDi("CF",0,"CardNo",ChangeNo,""),-1)
	Q:CardRefRowId="" "200"
	s PatientID=$p(^DHCCARD("CF",CardRefRowId),"^",4)
	s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	s UpdateDate=..%SysDate()
	s UpdateTime=..%SysTime()
	//取出原来的信息
	s OldPapmi=$p(^PAADM(ADMRowid),"^",1)
	S OldCreatUser=$p(^PAADM(ADMRowid),"^",43)
	S OldCreatDate=$p(^PAADM(ADMRowid),"^",41)
	S OldCreatTime=$p(^PAADM(ADMRowid),"^",42)
	s VisitStatus=$p($g(^PAADM(ADMRowid)),"^",20) 
	q:VisitStatus="C"
	s Admi=ADMRowid
 s RegisFee=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
 q:RegisFee="" "-201"

 &sql(update SQLUser.DHCRegistrationFee set regfeename=:PatName where ID=:RegisFee)
 &sql(update SQLUser.DHCQueue set QueName=:PatName,QuePersonId=:PatientNo where QuePaadmDr=:ADMRowid)
	&sql(update SQLUser.pa_adm set paadm_papmi_dr=:PatientID where paadm_rowid=:ADMRowid)
	if SQLCODE=0 d
	.s ^RegChangNoLog("LOG",ADMRowid)="老信息:"_"^"_OldPapmi_"^"_OldCreatUser_"^"_OldCreatDate_"^"_OldCreatTime_"!"_"新信息:"_"^"_PatientID_"^"_UserName_"^"_UpdateDate_"^"_UpdateTime_"^"_UserRowId
	;s PrintDate=##class(web.DHCOPAdmReg).GetPrintData(RegisFee)
	
	q SQLCODE
}

ClassMethod OPRegDocChangeBroker(AdmDate, OldDocID, NewDocID, LocID, TRangeID, ReplaceSessionTypeID)
{
	;w ##class(web.DHCOPAdmChang).OPRegDocChangeBroker("2008-04-18","23709","22069","1442","1","")
	s ^guo("OPRegDocChangeBroker11")=AdmDate_","_OldDocID_","_NewDocID_","_LocID_","_TRangeID_","_ReplaceSessionTypeID
	s AdmDate=$zdh(AdmDate,3)

	set ResRowID=""
	set ResRowID=$Order(^RB("RES",0,"CTPCP",NewDocID,LocID,ResRowID))
	Q:ResRowID="" 300  //没有资源

	///如果替诊的医生当诊有排班,则不允许替诊
	s AvailRA=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowID,AdmDate,"",TRangeID)
	Q:AvailRA'="" 200
	
	///被替诊的医生没有出诊,则不能被替诊
	set OldResRowID=""
	set OldResRowID=$Order(^RB("RES",0,"CTPCP",OldDocID,LocID,OldResRowID))
	Q:OldResRowID="" 301     //被替诊的医生没有资源
	s OldAvailRA=##class(web.DHCRBApptSchedule).GetAvailRA(OldResRowID,AdmDate,"",TRangeID)
	Q:OldAvailRA="" 201     //被替诊的医生必须是当诊的
	
	
	s SessStartTime=$p(^DHCTimeRange(TRangeID),"^",3)
	s OldScheduleID=$o(^RBAS(OldResRowID,0,"DateSTime",AdmDate,SessStartTime,""))
	;Q:OldScheduleID="" 202   
	s NewScheduleID=$o(^RBAS(ResRowID,0,"DateSTime",AdmDate,SessStartTime,""))
	
	Q:NewScheduleID="" 202  //如果找不到,则说明医生没有排班记录,不需要到此界面操作,可直接用替诊实现.
	s OldScheduleID=OldResRowID_"||"_OldScheduleID
	s NewScheduleID=ResRowID_"||"_NewScheduleID

	TStart
	//Dhc排班记录扩展表User.DHCRBApptSchedule
	set Oldschedule=##class(User.DHCRBApptSchedule).%OpenId(OldScheduleID)
	set NewSchedule=##class(User.DHCRBApptSchedule).%OpenId(NewScheduleID)
	set NewSchedule.ASNoOverbookAllowed=Oldschedule.ASNoOverbookAllowed
	set NewSchedule.ASQueueNo=Oldschedule.ASQueueNo
	set NewSchedule.ASRoomDR=Oldschedule.ASRoomDR
	
	do NewSchedule.ASSessionTypeDRSetObjectId(ReplaceSessionTypeID)
	set NewSchedule.ASClinicGroupDR=Oldschedule.ASClinicGroupDR
	//set NewSchedule.ASStatusDR=Oldschedule.ASStatusDR
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code='R')
	Do NewSchedule.ASStatusDRSetObjectId(ASStatusDR)
	set NewSchedule.ASDateCreate=$piece($h,",",1)
	set NewSchedule.ASTimeCreate=$piece($h,",",2)
	set NewSchedule.ASASDR=Oldschedule.%Id()
	Set sc = NewSchedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	
	 
	//更新被替诊医生排班记录
	&SQL(Select ASS_Rowid into :ASStatusDR from SQLUser.DHC_RBCASStatus Where ASS_Code='TR')
	Do Oldschedule.ASStatusDRSetObjectId(ASStatusDR)
	;Do Oldschedule.ASUserAuthoriseDRSetObjectId(AuditUserID)
	;Do Oldschedule.ASReasonNotAvailDRSetObjectId(ReplaceReasonID)
	set Oldschedule.ASASDR=NewSchedule.%Id() 

	Set sc = Oldschedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}

	set Oldschedule=##class(User.RBApptSchedule).%OpenId(OldScheduleID)
	set Oldschedule.ASLastUpdateDate=..%SysDate()
	set Oldschedule.ASLastUpdateTime=..%SysTime()
	Set sc = Oldschedule.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Trollback
		Quit 100
	}
	/*
	//复制被替诊医生的预约限额
	s err=0
	s AQChild=0  f  s AQChild=$O(^RBAS(+OldScheduleID,$P(OldScheduleID,"||",2),"AQ",AQChild))  q:(AQChild="")!(err=100)  d
	.s APPData=^RBAS(+OldScheduleID,$P(OldScheduleID,"||",2),"AQ",AQChild)
	.s MethodDR=$P(APPData,"^",1)
	.b
 .s Qty=$P(APPData,"^",2)
 .s AQStartNum=$P(APPData,"^",3)
	.s appQty=##class(User.DHCRBApptScheduleAppQty).%OpenId(NewScheduleID)
	.;d appQty.ASQASParRefSetObjectId(NewScheduleID)
	.d appQty.ASQMethodDRSetObjectId(MethodDR)
	.s appQty.ASQQty=Qty
	.s appQty.ASQStartNum=AQStartNum
	.S sc = appQty.%Save()
	.I $$$ISERR(sc) s err=100
	 i err=100 {
	    Tro
		Q 101
	 }
 */
	Tcommit
	
	quit 0
}

Query Find(AdmDepRowId As %String, AdmDocRowId As %String, CardNo As %String) As %Query(ROWSPEC = "TRegDate:%String,TLoc:%String,TDoc:%String,TSeqNo:%String,TCardNo:%String,TPatName:%String,Tmount:%String,ChangNoUser:%String,ChangNoDate:%String,ChangNoTime:%String,TAdmNo:%String")
{
}

ClassMethod GetPatNameByCardNo(CardNo)
{
	s ^guo("GetPatNameByCardNo")=CardNo
	q:CardNo="" ""
	s CardRowId="",PatName=""
	s CardRowId=$O(^DHCCARDi("CF",0,"CardNo",CardNo,CardRowId))
	q:CardRowId="" "此卡号在系统中不存在!"
	s PatID=$p(^DHCCARD("CF",CardRowId),"^",4)
	s PatName=$p(^PAPER(PatID,"ALL"),"^",1)
	q PatName
}

// w ##class(web.DHCOPAdmChang).GetPatMedCode(1)

ClassMethod GetPatMedCode(EpisodeID)
{
	q:EpisodeID="" "^^^"
	s PatDr=$p(^PAADM(EpisodeID),"^",1)
	s RegisterFeeID=""
	s RegisterFeeID=$O(^User.DHCRegistrationFeeI("ADM",EpisodeID,RegisterFeeID))
	s RBASid=""
	if RegisterFeeID'="" s RBASid=$List(^User.DHCRegistrationFeeD(RegisterFeeID),18)
	s PAPERSGMedicareCode1=""
	s PAPERSGMedicareCode2=""
	Set OPMRN="",IPMRN="",RAddress="",YBType="",ret=""
	//if $D(^PAPER(PatDr,"PER",4)) d
	Set OPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"O",$g(%session.Data("LOGON.HOSPID")))   //东院门诊病历号
	set RAddress=$p($g(^PAPER(PatDr,"PER",4)),"^",18) 
	//if $D(^PAPER(PatDr,"PER",1)) d
	Set IPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"I",$g(%session.Data("LOGON.HOSPID"))) //东院住院病历号
	Set DHCPerRowId=$o(^DHCPERSON(0,"PAPERSON",PatDr,""))
	if DHCPerRowId'="" d
    .Set PAPERSGMedicareCode1=$p(^DHCPERSON(DHCPerRowId),"^",5) //西院门诊病历号PAPERFCMedicareCode1
    .Set PAPERSGMedicareCode2=$p(^DHCPERSON(DHCPerRowId),"^",6) //西院住院病历号PAPERFCMedicareCode2
    s ret=OPMRN_"^"_IPMRN_"^"_PAPERSGMedicareCode1_"^"_PAPERSGMedicareCode2_"^"_PatDr_"^"_RBASid
    q ret
}

ClassMethod SendBLCode(ASRowId, UserID, LocID, DYOPMRN, DYIPMRN, SGMedicareCode1, SGMedicareCode2, EpisodeID)
{
	;w ##class(web.DHCOPAdmReg).SendBLCode("12214||233","6","1694","","444","","","41")
	s ^guoooo("SendBLCode")=ASRowId_"^"_UserID_"^"_LocID_"^"_EpisodeID
	Q:($g(ASRowId)="") ""
	s find=0
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s ResRowId=$P(ASRowId,"||",1)
	s ASChild=$P(ASRowId,"||",2)
	s AdmDep=$P($G(^RB("RES",ResRowId)),"^",1)
	s AdmDoc=$P($G(^RB("RES",ResRowId)),"^",2)
	s LLRowid="" f  s LLRowid=$o(^CT("LL",LLRowid)) q:(LLRowid="")||(find=1)  d
	.s LLCode=$p(^CT("LL",LLRowid),"^",1)
	.//判断挂号员和医生所属科室是不是都在同一科室列表内
	.i ($d(^CT("LL",LLRowid,"LOC",0,"Loc",LocID)))&&($d(^CT("LL",LLRowid,"LOC",0,"Loc",AdmDep))) d
	..i ((LLCode="DYKS")&&(AdmType="E")&&((DYOPMRN'="")||(DYIPMRN'="")))||((LLCode="XYKS")&&(AdmType="E")&&((SGMedicareCode1'="")||(SGMedicareCode2'=""))) d
	...s find=1
	..e  i ((LLCode="DYKS")&&(AdmType'="E")&&(DYOPMRN'=""))||((LLCode="XYKS")&&(AdmType'="E")&&(DYOPMRN'="")) d
	...s find=1
	..e  d
	...s find=0 
	.q:find=1
	
	q find
}

ClassMethod SendBLCodeDT(ASRowId, UserID, LocID, DYOPMRN, DYIPMRN, FCMedicareCode1, FCMedicareCode2, EpisodeID)
{
	//地坛医院只要门诊病历号不为空则提示是否要传病历,不用,在JS中处理
	;w ##class(web.DHCOPAdmReg).SendBLCode("12214||233","6","1694","","444","","","41")
	s ^guoooo("SendBLCode")=ASRowId_"^"_UserID_"^"_LocID_"^"_EpisodeID
	Q:($g(ASRowId)="") ""
	s find=0
	s AdmType=$p(^PAADM(EpisodeID),"^",2)
	s ResRowId=$P(ASRowId,"||",1)
	s ASChild=$P(ASRowId,"||",2)
	s AdmDep=$P($G(^RB("RES",ResRowId)),"^",1)
	s AdmDoc=$P($G(^RB("RES",ResRowId)),"^",2)
	i DYOPMRN'="" s find=1
	q find
}

}
