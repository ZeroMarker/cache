/// CTOR: QP
/// DATE: 2017-07-04
/// DESC: 抗菌药物版本-4.1.0之后，用于portal中处理抗菌药物(KSS-V4.1.0 ++)
Class DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP  bmz修改方法名称2018-11-5
/// DATE: 2017-07-05
/// DESC: 查询当前医生待审核抗菌药物列表
/// SERV: D02.06.01服务
/// EXEC: d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService","D020601AntAppList","ys01","false")
Query D020601AntAppList(UserCode As %String, IfUsePushData As %String = "") As DtPortal.Query(ROWSPEC = "ind,AppRowid,PAAdm,Loc,unDoType,PatientID,businessId,bedNo,PAAdmNo,PAPMINO,PatName,PatSex,OrderName,phcformdesc,PoisonLevel,UsePurposeDesc,Reason,infPart,DAUPOPerDesc,InstrDesc,AppSdate,orderDays,AppTime,AppUserName,MedicareNo,Submission,PoisonCode,ConAttitude,AttitudeDr,Age,AdmReason,consultDr,isConsult,consultNum,AuthProcess,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,logonGroupID,logonHospID")
{
}

ClassMethod D020601AntAppListExecute(ByRef qHandle As %Binary, UserCode As %String, IfUsePushData As %String = "") As %Status
{
	n (qHandle,UserCode,IfUsePushData)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	
	s (AppRowid,PAAdm,Loc,PatientID,businessId,bedNo,PAAdmNo,PAPMINO,PatName,PatSex,OrderName,phcformdesc,PoisonLevel,UsePurposeDesc,Reason,infPart,DAUPOPerDesc,InstrDesc,AppSdate,orderDays,AppTime,AppUserName,MedicareNo,Submission,PoisonCode,ConAttitude,AttitudeDr,Age,AdmReason,consultDr)=""
  	if UserCode=""  s qHandle=$lb(0,repid,0) q $$$OK
	set UserID=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	i UserID="" 	Quit $$$OK
	
	
	if (IfUsePushData="true"){
		set messageData=##class(DtPortal.Doctor.D02ClinicPrompt.D0200CommonService).GetMessageDataByType(UserID,"1046")
		set bizObjIdStr=messageData.GetValue("bizObjId")
		s totalLen=$l(bizObjIdStr,"^")
		f i=1:1:totalLen d
		.s curBizObjId=$p(bizObjIdStr,"^",i)
		.s businessId=curBizObjId
		.s AppRowid=$p(curBizObjId,"-",1)
		.q:+AppRowid=0
		.d getPatInfoByCV
	}else{
		s days=##Class(DtPortal.Common.PublicService).getValueByCode("UNDOANTBIOTICSDAYS")
		s sdate=+$h-days
		s edate=+$h
		
		Set LocStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(UserCode)
		if LocStr=""  Set qHandle=$lb(0,repid,0) q $$$OK
		
		s docid=##class(DtPortal.Common.PublicService).GetDocIDByUserCode(UserCode)
		if docid=""  Set qHandle=$lb(0,repid,0) q $$$OK
		
		set type="ALL"
		Set object = ##class(%ResultSet).%New("DHCAnt.Serve.ComQuery:QryUnAuditList")
		Do object.Execute(UserCode, LocStr, type, $ZD(sdate,3), $ZD(edate,3))
		
		While (object.Next()) {
			//b ;01
			s AppRowid=object.Data("AppRowid")
			//locID,episodeID,patName,unDoType,
			s locID=object.Data("locID")
			s PAAdm=object.Data("episodeID")
			s patName=object.Data("patName")
			s unDoType=object.Data("unDoType")
			//OrderName,phcformdesc,PoisonLevel,UsePurpseDesc,
			s OrderName=object.Data("OrderName")
			s phcformdesc=object.Data("phcformdesc")
			s PoisonLevel=object.Data("PoisonLevel")
			s UsePurposeDesc=object.Data("UsePurpseDesc")
			//Reason,infPart,DAUPOPerDesc,InstrDesc,AppSdate,
			s Reason=object.Data("Reason")
			s infPart=object.Data("infPart")
			s DAUPOPerDesc=object.Data("DAUPOPerDesc")
			s InstrDesc=object.Data("InstrDesc")
			s AppSdate=object.Data("AppSdate")
			//orderDays,AppTime,AppUserName,Submission,ConsultStatus
			s orderDays=object.Data("orderDays")
			s AppTime=object.Data("AppTime")
			s AppUserName=object.Data("AppUserName")
			s Submission=object.Data("Submission")
			s ConsultStatus=object.Data("ConsultStatus")
			d getPatInfoByCV
		}
		
		
	
	}
	
	
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

getPatInfoByCV
	
	s appstatu=$p(^DHCDAA("ANT",AppRowid),"^",12)
	q:(appstatu="U")||(appstatu="C")||(appstatu="R")
	s curProcess=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",36)
	s AuthProcess=..GetCurAuthStep(curProcess,appstatu)	;审核流程
	
		
	s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	s bedNo=$p(patInfoStr,"^",1)
	s PatName=$p(patInfoStr,"^",2)
	s PatSex=$p(patInfoStr,"^",3)
	s Age=$p(patInfoStr,"^",4)
	s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	s PAPMINO=$p(patInfoStr,"^",7) 
	set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	i locID'="" s Loc=$p(^CTLOC(locID),"^",2)
	i Loc["-"  S Loc=$p(Loc,"-",2)


	
	//获取打开电子病历所需要的参数
	set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(PAAdm)
	set EMRDocID=$p(EMRinfo,"^",1)
	set EMRInstanceID=$p(EMRinfo,"^",2)
	set locID=$p(EMRinfo,"^",3)
	set PatientID=$p(EMRinfo,"^",4)
	set EMREpisodeID=$p(EMRinfo,"^",5)
	
	s logonInfo=##class(DtPortal.Doctor.D00CommonService).getUserGroupHosp(UserCode,locID)
	//w !,logonInfo
	s logonGroupID=$p(logonInfo,"^",1)
	s logonHospID=$p(logonInfo,"^",2)
	d outputrow
	
	q

outputrow
	Set ^||CacheTemp(repid,ind)=$lb(ind,AppRowid,PAAdm,Loc,unDoType,PatientID,businessId,bedNo,PAAdmNo,PAPMINO,PatName,PatSex,OrderName,phcformdesc,PoisonLevel,UsePurposeDesc,Reason,infPart,DAUPOPerDesc,InstrDesc,AppSdate,orderDays,AppTime,AppUserName,MedicareNo,Submission,PoisonCode,ConAttitude,AttitudeDr,Age,AdmReason,consultDr,isConsult,consultNum,AuthProcess,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,logonGroupID,logonHospID)
	Set ind=ind+1
	quit
}

ClassMethod AntAppListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AntAppListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^||CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AntAppListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AntAppListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^||CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^||CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2017-07-04
/// DESC: 抗菌药物审核
/// IN	: usercode：工号
/// 		  aaid: 申请id
/// 		  action:确认和拒绝操作 (R/U)
/// 			  bizObjId:消息业务id
/// SERV: D02.07.03服务
/// EXEC: w ##class(DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService).D020602VerifyApply(001,495,"U")
ClassMethod D020602VerifyApply(usercode, aaid, action, bizObjId, IfUsePushData As %String = "false") As DtPortal.OutPut
{
	n (usercode,aaid,action,bizObjId,IfUsePushData)
	if (IfUsePushData="false"){
		q ##class(DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService).VerifyApply(usercode,aaid,action)
	}
	
	
	
	#Dim ret As DtPortal.OutPut
	s ret = ##class(DtPortal.OutPut).%New()
	s $zt = "ErrMsg"
	
	TS
	Set ret.status = 1
	Set ret.errMSG = ""
		
	s curDate=+$H
	s curTime=$P($H,",",2)
	s userCode=$$ALPHAUP^SSUTIL4(usercode)
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userCode,0))
		
	s isEmergency=$p(^DHCDAA("ANT",aaid,1),"^",23)
	s admId=$p(^DHCDAA("ANT",aaid),"^",1)
	i (action="R"){
		s msgRtn=##class(DHCAnt.KSS.Extend.MessageTip).SendMsgInPortal(userId,aaid,bizObjId,"RU")
		i msgRtn=0 d ErrMsg2
		//i isEmergency=1 d 	;ErrMsg3
		//.s ret.data = "该申请为越级使用申请，请及时联系医生，及时更换药品"
		//e  s ret.data = 0
		TCommit
		 s ret.data = 0
		Q ret
		
	}else{
		s msgRtn=##class(DHCAnt.KSS.Extend.MessageTip).SendMsgInPortal(userId,aaid,bizObjId,"SH")
	 	i msgRtn=0 d ErrMsg
	 	
		TCommit
		s ret.data = 0
		// Set ret.data = objMessage
		Q ret
	}

	
ErrMsg
	TRollBack
	Set ret.status = -1
	Set ret.errMSG = "审核失败"
	Set ret.data = ""
	Quit ret
	
ErrMsg2
	TRollBack
	Set ret.status = -1
	Set ret.errMSG = "拒绝失败"
	Set ret.data = ""
	Quit ret
	
ErrMsg3
	;Set ret.status = -1
	;Set ret.errMSG = "该申请为越级使用申请，请及时联系医生，及时更换药品"
	Set ret.data = "该申请为越级使用申请，请及时联系医生，及时更换药品"
	;Quit ret
}

/// CTOR: QP
/// DATE: 2017-07-05
/// DESC: 得到会诊医生的会诊结果
/// EXEC: w ##class(DtPortal.Doctor.ClinicPrompt.UndoAntBioticsService).GetConsultResult(542)
ClassMethod GetConsultResult(conDr As %String) As %String
{
	n (conDr)
	s attitude="",attitudetsy=""
	s obj=##class(User.DHCConsultation).%OpenId(conDr)
	i $ISObject(obj){
		s attitudetsy=obj.attitudetsy  //抗菌药
    	s attitude=$S(attitudetsy=1:"同意",attitudetsy=2:"不同意",attitudetsy="":"需要会诊")	
	}
    q attitudetsy_"^"_attitude
}

/// CTOR: QP
/// DATE: 2017-07-05
/// DESC: 
/// EXEC: w ##class(DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService).GetDrgForm(542)
ClassMethod GetDrgForm(ARCIMRowid As %String) As %String
{
	n (ARCIMRowid)
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	q $g(DrgFormRowid)
}

/// CTOR: QP
/// DATE: 2017-07-05
/// DESC: 得到会诊医生的会诊结果
/// EXEC: w ##class(DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService).GetConsultResult(542)
ClassMethod BuildConsultInfo(AppRowid As %String, consultNum As %String) As %String
{
	n (AppRowid,consultNum)
	s mRtn=""
	q:AppRowid="" mRtn
	q:consultNum=0 mRtn
	s separator="^"
	s separator2="!"
	s consultDr=$p(^DHCDAA("ANT",AppRowid,1),"^",22)
	s ConAttitudeStr=..GetConsultResult(consultDr)
	s AttitudeDr=$p(ConAttitudeStr,"^",1)
	s ConAttitude=$p(ConAttitudeStr,"^",2)
	
	s consultDrStr=consultDr
	s ConAttitudeStr=ConAttitude
	s AttitudeDrStr=AttitudeDr
	
	i ((consultNum=2)||(consultNum>2)) d
	.s consultDr2=$p($g(^DHCDAA("ANT",AppRowid,1)),"^",26)
	.s ConAttitudeStr2=..GetConsultResult(consultDr2)
	.s AttitudeDr2=$p(ConAttitudeStr2,"^",1)
	.s ConAttitude2=$p(ConAttitudeStr2,"^",2)
	.s consultDrStr=consultDrStr_separator_consultDr2
	.s AttitudeDrStr=AttitudeDrStr_separator_AttitudeDr2
	.s ConAttitudeStr=ConAttitudeStr_separator_ConAttitude2
	
	i consultNum=3 d
	.s consultDr3=$p(^DHCDAA("ANT",AppRowid,1),"^",29)
	.s ConAttitudeStr3=..GetConsultResult(consultDr3)
	.s AttitudeDr3=$p(ConAttitudeStr3,"^",1)
	.s ConAttitude3=$p(ConAttitudeStr3,"^",2)
	.s consultDrStr=consultDrStr_separator_consultDr3
	.s AttitudeDrStr=AttitudeDrStr_separator_AttitudeDr3
	.s ConAttitudeStr=ConAttitudeStr_separator_ConAttitude3
	
	s mRtn=consultDrStr_separator2_AttitudeDrStr_separator2_ConAttitudeStr
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-07-05
/// DESC: 得到当前的审核步骤
/// EXEC: w ##class(DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService).GetConsultResult(542)
ClassMethod GetCurAuthStep(curProcess As %String, appstatu As %String) As %String
{
	n (curProcess,appstatu)
	s mRtn=""
	q:(appstatu="")||(curProcess="") mRtn
	
	i appstatu="A" d
	.i curProcess["F" s mRtn="科室预审"
	.e  i curProcess["S" s mRtn="科室审核"
	.e  i curProcess["U" s mRtn="最终审核"
	.e  s mRtn="会诊"	//
	
	i appstatu="F" d
	.i curProcess["S" s mRtn="科室审核"
	.e  i curProcess["U" s mRtn="最终审核"
	.e  s mRtn="会诊"
	
	i appstatu="H" d
	.i curProcess["S" s mRtn="科室审核"
	.e  s mRtn="最终审核"
	
	i appstatu="S" s mRtn="最终审核"
	i (appstatu="R")||(appstatu="U")||(appstatu="C") s mRtn="无需审核"
	
	q mRtn
}

/// creator    :  shp
/// date       :  20140716
/// description:  审核抗菌药物申请---不走推送版本
/// debug      :w ##class(DtPortal.Doctor.D02ClinicPrompt.D0206UndoAntService).VerifyApply(001,495,"U")
ClassMethod VerifyApply(usercode, AppID, Status) As DtPortal.OutPut
{
	n (usercode,AppID,Status)
	
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	Set $ZT = "ErrSendMessage"
	
	s isemergency=$p(^DHCDAA("ANT",AppID,1),"^",23)
	i (isemergency=1)&&(Status="R"){
		D ErrSendMessage10 
		quit ret
	}else{
		TStart
		s CurrentDate=+$H
		s CurrentTime=$P($H,",",2)
		s UserCode=$$ALPHAUP^SSUTIL4(usercode)
		s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
		&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus=:Status,AA_AuditUser_DR=:UserID,AA_AuditDate=:CurrentDate,
	 		AA_AuditTime=:CurrentTime,AA_LastUpdateUser=:UserID,AA_LastUpdateDate=:CurrentDate,AA_LastUpdateTime=:CurrentTime
	 	where AA_Rowid=:AppID)
	 	i (Status="U")&&(SQLCODE'=0)  d ErrSendMessage
	 	i (Status="R")&&(SQLCODE'=0)  d ErrSendMessage11
		TCommit
		
		//增加抗菌药审核消息推送 update by chengpeng
		//start
		//set epsoidID=$p(^DHCDAA("ANT",AppID),"^",1)
		//set rtnNew=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000021",AppID,2,epsoidID)
		//end
		
		Set ret.status = 1
		Set ret.errMSG = ""
	
		// 可以是简单类型
		Set ret.data = SQLCODE
		// 也可以是一个对象
		// Set ret.data = objMessage
		
		Quit ret
		
	}

	
ErrSendMessage
	
	TRollBack
	Set ret.status = -1
	Set ret.errMSG = "审核失败"
	Set ret.data = ""
	Quit ret
ErrSendMessage10
	
	Set ret.status = -1
	Set ret.errMSG = "该申请为越级使用申请，请及时联系医生，及时更换药品"
	Set ret.data = ""
	Quit ret
ErrSendMessage11

	TRollBack
	Set ret.status = -1
	Set ret.errMSG = "拒绝失败"
	Set ret.data = ""
	Quit ret
}

}
