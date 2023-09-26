/// 名称:     web.DHCAntCVReportTrans
/// 描述:     危急报告处理查询
/// 编写者：  huhm
/// 编写日期: 20120710
Class web.DHCAntCVReportTrans Extends %RegisteredObject
{

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 保存危急报告处理记录
/// Table：        DHC_PanicReport,DHC_PanicReportTrans
/// Input：        危急报告ID,用户,处理,说明,状态
/// Output：       
/// Return：        
/// Others：        其它说明
ClassMethod SaveTransBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RepIdStr As %Library.String = "", User As %Library.String = "", TransStr As %Library.String = "", Status As %Library.String = "")
{
 
  s ^TMPTrans(1)=RepIdStr
  s ^TMPTrans(2)=User
  s ^TMPTrans(3)=TransStr
  s ^TMPTrans(4)=Status
  s ReportType="1"
 s Ret=..SaveTrans(RepIdStr,User,TransStr,Status,ReportType)
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

// 增加处理报告类型 20131009 huhm

ClassMethod SaveTrans(RepIdStr As %String, User As %String, TransStr As %String, Status As %String, ReportType As %String) As %String
{
	//New (RepIdStr,User,TransStr,Status)
	s ^TMPSATRAN=RepIdStr_","_User_","_TransStr_","_Status_","_ReportType
	//Set Config=##Class(websys.Configuration).%OpenId(1)
 	Set MEDDATA="DHC-DATA" //Config.DataNamespace
 	Set LABDATA="LABDATA" //Config.LabDataNamespace
 	Set CurrentNS=$ZNSPACE
 	Set Ret="",retStr=""
 	ZN LABDATA
 	Set Ret=$$save^DHCLABPanicReportTrans(RepIdStr,User,TransStr,Status,ReportType)
 	ZN CurrentNS
 	Quit Ret
}

ClassMethod SaveIPTransBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RepIdStr As %Library.String = "", User As %Library.String = "", DocStr As %Library.String = "", TransMemo As %Library.String = "")
{
 
  s ^TMPIPTrans(1)=RepIdStr
  s ^TMPIPTrans(2)=User
  s ^TMPIPTrans(3)=DocStr
  s ^TMPIPTrans(4)=TransMemo
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 Set Ret="",retStr=""
 ZN LABDATA
 Set Ret=$$save^DHCLABPanicReportTrans(RepIdStr,User,DocStr,TransMemo)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

ClassMethod SaveOPTransBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", RepIdStr As %Library.String = "", User As %Library.String = "", MobPhone As %Library.String = "", TransMemo As %Library.String = "")
{
 
  s ^TMPOPTrans(1)=RepIdStr
  s ^TMPOPTrans(2)=User
  s ^TMPOPTrans(3)=MobPhone
  s ^TMPOPTrans(4)=TransMemo
 Set Config=##Class(websys.Configuration).%OpenId(1)
 Set MEDDATA=Config.DataNamespace
 Set LABDATA=Config.LabDataNamespace
 Set CurrentNS=$ZNSPACE
 Set Ret="",retStr=""
 ZN LABDATA
 Set Ret=$$save^DHCLABPanicReportTrans(RepIdStr,User,"",TransMemo,MobPhone)
 ZN CurrentNS
 s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 &javascript<#(retval)#>
  q Ret
}

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 核对用户名密码
/// Table：        SS_User
/// Input：        用户名,密码
/// Output：       
/// Return：        
/// Others：        其它说明
ClassMethod CheckPwdBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserCode As %Library.String = "", Pwd As %Library.String = "")
{
  	S Ret=..CheckPwd(UserCode,Pwd)
 	s retval=itmjs_"('"_$ZCVT(Ret,"O","JS")_"');"
 	i itmjsex '="""" s retval=retval_itmjsex_"('"_$ZCVT(Ret,"O","JS")_"');"
 	&javascript<#(retval)#>
  	q Ret
}

ClassMethod CheckPwd(UserCode As %String, Pwd As %String) As %String
{
	//New (UserCode,Pwd)
 	Set Config=##Class(websys.Configuration).%OpenId(1)
 	Set MEDDATA=Config.DataNamespace
 	Set LABDATA=Config.LabDataNamespace
 	Set CurrentNS=$ZNSPACE
 	Set Ret="",retStr=""
 	Set UserCode=$zcvt(UserCode,"U")
 	Set UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
 	ZN MEDDATA
 	Set Ret=$$pin^MVBSSUSR(UserId,Pwd)
 	ZN CurrentNS
 	Quit Ret
}

/// Creator：      huhm
/// CreatDate：    20120715
/// Description:： 查询危急报告处理记录
/// Table：        DHC_PanicReport,DHC_PanicReportTrans
/// Input：        检验号
/// Output：       处理                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             时间,处理用户,通知人,联系电话,联系结果
/// Return：         
/// Others：        其它说明
/// 增加报告类型ReportType 20131007 huhm
Query GetTransItem(LabEpis As %String, ReportType As %String) As %Query(ROWSPEC = "TransDT:%String,TransUser:%String,NoticePerson:%String,PhoneNo:%String,Comment:%String")
{
}

ClassMethod GetTransItemExecute(ByRef qHandle As %Binary, LabEpis As %String, ReportType As %String) As %Status
{
 	Set LabEpis=$Get(LabEpis),ReportType=$g(ReportType)
 	i '$l(ReportType) s ReportType=1
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	If '$Length(LabEpis) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	B
	//
	s ord="" f  s ord=$o(^DHCAntCVReport(ReportType,LabEpis,ord)) q:ord=""  d
	.s TranOrd="" f  s TranOrd=$o(^DHCAntCVReport(ReportType,LabEpis,ord,"TR",TranOrd)) q:TranOrd=""  d
	..s str=^DHCAntCVReport(ReportType,LabEpis,ord,"TR",TranOrd)
	..i '$l(str) q
	..s TDate=$p(str,"\",1)
	..s TTime=$p(str,"\",2)
	..s TUser=$p(str,"\",3)
	..s TransDT=""
	..s TransUser=""
	..i $l(TDate),$l(TTime) s TransDT=$zd(TDate,3)_" "_$zt(TTime)
	..i $l(TUser) d
	...s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(TUser,"U"),""))
	...i '$l(UserId) q
	...s TransUser=$p(^SSU("SSUSR",UserId),"^",2)
	..s NoticePerson=$p(str,"\",5)
	..s PhoneNo=$p(str,"\",6)
	..s Comment=$p(str,"\",7)
	..d OutputRow
	//
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow
	set Data=$lb(TransDT,TransUser,NoticePerson,PhoneNo,Comment)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTransItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTransItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTransItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTransItemExecute ]
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

/// CREATOR：  SHP
/// DATE   :   20131215
/// DESCRIPITON: 保存处理结果。
/// DEBUGGER  :W ##CLASS(web.DHCAntCVReportTrans).SaveTransNew("234||1","059","^123^123^已通知","F",1)
ClassMethod SaveTransNew(RepId As %String, User As %String, TransStr As %String = "", Status As %String = "", ReportType As %String = "") As %String
{
	S ^TEMPTRANSREPORTS(1)=RepId
	S ^TEMPTRANSREPORTS(2)=User
	S ^TEMPTRANSREPORTS(3)=TransStr
	S ^TEMPTRANSREPORTS(4)=Status
	S ^TEMPTRANSREPORTS(5)=ReportType
	S ret=""
	s reportID=ReportType_"||"_RepId
  	s ret=$$updateTrans(reportID,User,TransStr,Status)
  	//2016-5-11统一封装处理对外消息
  	d ##class(web.DHCAntCVSend).SendAntCVTrans(reportID,User,TransStr,Status)
  	q ret
insertTrans(reportID,User,TransStr,Status)
	I Status=""  S Status="C"
	s NoticeTime=$p(TransStr,"^",1)
  	s NoticeName=$p(TransStr,"^",2)
  	s PhoneNo=$p(TransStr,"^",3)
  	s TransMemo=$p(TransStr,"^",4)
  	k PLIST
  	S PLIST(0)=reportID
  	s PLIST(3)=+$h
  	s PLIST(4)=$p($h,",",2)
  	s PLIST(5)=User
  	s PLIST(6)=NoticeTime
  	s PLIST(7)=NoticeName
  	s PLIST(8)=PhoneNo
  	s PLIST(9)=TransMemo
  	s PLIST(10)=Status
	i '$l($g(PLIST(2))) s PLIST(2)=$o(^DHCAntCVReport($p(PLIST(0),"||",1),$p(PLIST(0),"||",2),$p(PLIST(0),"||",3),"TR",""),-1)+1
	&SQL(insert into SQLUser.DHC_AntCVReportTrans values :PLIST())
	q SQLCODE
updateTrans(reportID,User,TransStr,Status)
	;s TransID=$o(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3),"TR",""),-1)
	;s TransID=reportID_"||"_TransID
	s NoticeTime=$p(TransStr,"^",1)
  	s NoticeName=$p(TransStr,"^",2)
  	s PhoneNo=$p(TransStr,"^",3)
  	s TransMemo=$p(TransStr,"^",4)
  	s TransAdvice=$p(TransStr,"^",5)
	k PLIST
  	S PLIST(0)=reportID
  	s PLIST(3)=+$h
  	s PLIST(4)=$p($h,",",2)
  	s PLIST(5)=User
  	s PLIST(6)=NoticeTime
  	s PLIST(7)=NoticeName
  	s PLIST(8)=PhoneNo
  	s PLIST(9)=TransMemo
  	s PLIST(10)=Status
  	s PLIST(11)=TransAdvice
  	s PLIST(2)=$o(^DHCAntCVReport($p(PLIST(0),"||",1),$p(PLIST(0),"||",2),$p(PLIST(0),"||",3),"TR",""),-1)+1
  	TS
  	&SQL(insert into SQLUser.DHC_AntCVReportTrans values :PLIST())
 	if SQLCODE{
	 	TRO
	 	q "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"")
	}
 	&sql(update SQLUser.DHC_AntCVReport set DPRP_Status=:Status where DPRP_RowID=:reportID)
 	if SQLCODE {
	 	TRO
	 	q "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"")
	}
 	TC
  	q SQLCODE
}

ClassMethod GetAdmTypeDetByReportID(reportID)
{
	s EpisodeID=$p(^DHCAntCVReport($p(reportID,"||",1),$p(reportID,"||",2),$p(reportID,"||",3)),"\",7)
	set AdmType=$p(^PAADM(EpisodeID),"^",2)
	s AdmTypeDet=AdmType
	if AdmTypeDet="E"{
		if ##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)>0 set AdmTypeDet="EI"
		else  s AdmTypeDet="EO"
	}
	q AdmTypeDet
}

ClassMethod CheckTransOrd(reportID = "", trExecResult = "")
{
	s ToStatus=$s(trExecResult="F":"F",1:"C")  //##class(User.DHCAntCVExecResult).GetToStatus(trExecResult)
	if ToStatus="F" {
		s AdmTypeDet=..GetAdmTypeDetByReportID(reportID)
		s RequireEditOrder=##class(web.DHCAntCVOptions).GetBaseOpt("RequireEditOrder"_AdmTypeDet)
		s TipEditOrder=##class(web.DHCAntCVOptions).GetBaseOpt("TipEditOrder"_AdmTypeDet)
		if (RequireEditOrder=1)||(TipEditOrder=1) {
			s HasTransOrd=##class(web.DHCAntCVReportLink).HasTransOrd(reportID) //开医嘱 关联医嘱
			if HasTransOrd q 1 //已开医嘱
			s HasCstApp=##class(web.DHCAntCVReportLink).HasLink(reportID,"25") //会诊申请
			if HasCstApp q 1
			s HasBldApp=##class(web.DHCAntCVReportLink).HasLink(reportID,"33") //输血申请
			if HasBldApp q 1
			s HasNoNeedOrder=##class(web.DHCAntCVReportLink).HasLink(reportID,"34") //无需医嘱处理
			if HasNoNeedOrder q 1

			if RequireEditOrder=1 q -100  //必须开医嘱，且未写
			if TipEditOrder=1 q -200  //还没开医嘱 提示

		
		}else{
			q 1	
		}
	}
}

ClassMethod GetLatestTransEmr(reportID)
{
	s linkInfo=##class(web.DHCAntCVReportLink).GetLastLink(reportID,2)
	if linkInfo'="" {
		s instanceID=$p(linkInfo,"^",1)
		s isLink=##class(web.DHCAntCVReportLink).IsTransEMR(instanceID) //1^id1$id2$id3
		s reportIDs=$p(isLink,"^",2)
		q instanceID_"$"_$tr(reportIDs,"$","^")
	}
	q ""
}

ClassMethod CheckTransEMR(reportID = "", trExecResult = "")
{
	s ToStatus=$s(trExecResult="F":"F",1:"C")  //##class(User.DHCAntCVExecResult).GetToStatus(trExecResult)
	if ToStatus="F" {
		s AdmTypeDet=..GetAdmTypeDetByReportID(reportID)
		s RequireEditEmr=##class(web.DHCAntCVOptions).GetBaseOpt("RequireEditEmr"_AdmTypeDet)
		s TipEditEmr=##class(web.DHCAntCVOptions).GetBaseOpt("TipEditEmr"_AdmTypeDet)
		s HasTransEmr=##class(web.DHCAntCVReportLink).HasTransEMR(reportID)
		if HasTransEmr q 1 //以写病历
		if RequireEditEmr=1 q -100  //必须写病历，且未写
		if TipEditEmr=1 q -200  //还没写病历 提示
		q 1  //不需要
	}
}

/// 危急值接收
ClassMethod SaveReceive(reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode = "", contactCode = "", pwd = "")
{
	s $zt="SaveReceiveErr"
	s ret=0
	s sessLocId="",sessUser=""
	if $d(%session) {
		s sessUser=%session.Get("LOGON.USERCODE")
		s sessLocId=%session.Get("LOGON.CTLOCID")	
	}
	if usercode="" s usercode=sessUser
	s userid=##class(web.DHCAntCVComm).GetUserIdByCode(usercode)
	q:userid="" "-1^用户不正确"
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("PINOnReceive")=1 {  //接收时验证密码
		s pwdRet=..IsValidaMD5PIN(usercode,pwd)
		if pwdRet'=1 q pwdRet
	}
	if contactCode'="" {
		if ##class(web.DHCAntCVComm).GetUserNameByCode(contactCode,1)'=contact q "-1^请选择联系人"	
	}
	

	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	if (repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) q "-1^reportID="_reportID_",不正确"
	s repStatus=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",9) 
	q:repStatus="D" "-1^危急值已被撤销，无需接收"
	q:repStatus="F" "-1^危急值已被处理，无需接收"
	q:repStatus="Rec" "-1^危急值已被接收，无需再次接收"
	s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",""),-1)+1
	TS
	s obj=##class(User.DHCAntCVReportTrans).%New(reportID)
	d obj.DPRTParRefSetObjectId(reportID)
	s obj.DPRTOrder=trOrder
	s obj.DPRTDate=+$h
	s obj.DPRTTime=+$p($h,",",2)
	s obj.DPRTUserID=usercode
	s obj.DPRTNameOfNotice=contact
	s obj.DPRTLinkPhoneNo=contactTel
	s obj.DPRTComment=contactResultDesc
	s obj.DPRTSendStatus=$case(contactResult,"C":"C","F":"F",:"")  //C-C F-F 其它空
	s obj.DPRTExecResult=contactResult   //ExecResult字段记录选择的联系结果
	s obj.DPRTAdvice=note
	s obj.DPRTSessLoc=sessLocId
	s obj.DPRTOpUserCode=$s(sessUser="":usercode,1:sessUser)
	s obj.DPRTOpType="Rec"
	s obj.DPRTDocCode=contactCode //接收时选择医生
	s sc=obj.%Save()
	if $$$ISERR(sc){
		s ret="-1^"_$system.Status.GetErrorText(sc)
		tro
		q ret
	}
	&sql(update SQLUser.DHC_AntCVReport set DPRP_Status='Rec' where DPRP_RowID=:reportID)
 	if SQLCODE {
	 	s ret= "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"")
	 	tro
	 	q ret
	}
	TC
	d ##class(web.DHCAntCVSend).SendCVReceive(reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode)
	q ret
SaveReceiveErr
	tro
	q "-1^"_$ze
}

/// 危急值转发
ClassMethod SaveFwDoc(reportID, usercode = "", fwLocId = "", fwUserId = "", pwd = "", fwUserId2 = "")
{
	s $zt="SaveFwDocErr"
	if (fwLocId="") q "-1^请选择转发科室"
	if (fwLocId'="")&&((fwLocId'>0)||'$d(^CTLOC(fwLocId))) q "-1^请选择正确的转发科室"
	if (fwUserId'="")&&((fwUserId'>0)||'$d(^SSU("SSUSR",fwUserId))) q "-1^请选择正确的转发医生"
	s ret=0
	s sessLocId="",sessUser=""
	if $d(%session) {
		s sessUser=%session.Get("LOGON.USERCODE")
		s sessLocId=%session.Get("LOGON.CTLOCID")	
	}
	if usercode="" s usercode=sessUser
	s userid=##class(web.DHCAntCVComm).GetUserIdByCode(usercode)
	q:userid="" "-1^用户不正确"
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("PINOnForward")=1 {  //转发时验证密码
		s pwdRet=..IsValidaMD5PIN(usercode,pwd)
		if pwdRet'=1 q pwdRet
	}
	
	if fwUserId=fwUserId2 s fwUserId2=""
	if fwUserId'>0,fwUserId2>0 s fwUserId=fwUserId2,fwUserId2=""
	
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	if (repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) q "-1^reportID="_reportID_",不正确"
	s repStatus=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",9) 
	q:repStatus="D" "-1^危急值已被撤销，无需转发"
	q:repStatus="F" "-1^危急值已被处理，不能转发"
	
	s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",""),-1)+1
	TS
	s obj=##class(User.DHCAntCVReportTrans).%New(reportID)
	d obj.DPRTParRefSetObjectId(reportID)
	s obj.DPRTOrder=trOrder
	s obj.DPRTDate=+$h
	s obj.DPRTTime=+$p($h,",",2)
	s obj.DPRTUserID=usercode
	s obj.DPRTNameOfNotice=""
	s obj.DPRTLinkPhoneNo=""
	s obj.DPRTComment=""
	s obj.DPRTSendStatus=""
	s obj.DPRTAdvice=""
	s obj.DPRTSessLoc=sessLocId
	s obj.DPRTOpUserCode=$s(sessUser="":usercode,1:sessUser)
	s obj.DPRTOpType="FwD"
	d obj.DPRTFwToLocDrSetObjectId(fwLocId)
	d obj.DPRTFwToUserDrSetObjectId(fwUserId)
	d obj.DPRTFwToUserDr2SetObjectId(fwUserId2) ////第二转发人
	s sc=obj.%Save()
	if $$$ISERR(sc){
		s ret="-1^"_$system.Status.GetErrorText(sc)
		tro
		q ret
	}
	
	TC
	d ##class(web.DHCAntCVSend).SendCVForwardDoc(reportID,usercode,fwLocId,fwUserId,fwUserId2)
	q ret
SaveFwDocErr
	tro
	q "-1^"_$ze
}

/// 危急值处理
ClassMethod SaveExec(reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode = "", contactCode = "", pwd = "")
{
	s $zt="SaveExecErr"
	s ret=0
	s sessLocId="",sessUser=""
	if $d(%session) {
		s sessUser=%session.Get("LOGON.USERCODE")
		s sessLocId=%session.Get("LOGON.CTLOCID")
	}
	if usercode="" s usercode=sessUser
	s userid=##class(web.DHCAntCVComm).GetUserIdByCode(usercode)
	q:userid="" "-1^用户不正确"
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("PINOnExec")=1 {  //处理时验证密码
		s pwdRet=..IsValidaMD5PIN(usercode,pwd)
		if pwdRet'=1 q pwdRet
	}
	if contactCode'="" { //如果处理时也是选择联系人的情况 
		if ##class(web.DHCAntCVComm).GetUserNameByCode(contactCode,1)'=contact q "-1^请选择联系人"	
	}
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("ReceiveMode")=4 { //处理时接收
		//处理时接收 无论是验证了处理的密码还是处理时不需要密码  自动接收时不需要再验证密码了
		s recRet=..AutoSaveReceive(reportID,userid,"auto")
	}
	
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	if (repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) q "-1^reportID="_reportID_",不正确"
	s repStatus=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",9)
	q:repStatus="D" "-1^危急值已被撤销，无需处理"
	s ReceiveMode=""
	if ##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCAntCVOptions||GetBaseOpt") s ReceiveMode=##class(web.DHCAntCVOptions).GetBaseOpt("ReceiveMode")
	q:(ReceiveMode>0)&&(repStatus="C") "-1^危急值还未接收，不能处理"
	
	//q:repStatus="F" "-1^危急值已被处理，无需再处理"

	s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",""),-1)+1
	TS
	s obj=##class(User.DHCAntCVReportTrans).%New(reportID)
	d obj.DPRTParRefSetObjectId(reportID)
	s obj.DPRTOrder=trOrder
	s obj.DPRTDate=+$h
	s obj.DPRTTime=+$p($h,",",2)
	s obj.DPRTUserID=usercode
	s obj.DPRTNameOfNotice=contact
	s obj.DPRTLinkPhoneNo=contactTel
	s obj.DPRTComment=contactResultDesc
	s obj.DPRTSendStatus=$case(contactResult,"C":"C","F":"F",:"")  //C-C F-F 其它空
	s obj.DPRTExecResult=contactResult   //ExecResult字段记录选择的联系结果
	s obj.DPRTAdvice=note
	s obj.DPRTSessLoc=sessLocId
	s obj.DPRTOpUserCode=$s(sessUser="":usercode,1:sessUser)
	s obj.DPRTOpType="E"
	s obj.DPRTDocCode=contactCode //如果处理时选择医生
	s sc=obj.%Save()
	if $$$ISERR(sc){
		s ret="-1^"_$system.Status.GetErrorText(sc)
		tro
		q ret
	}
	&sql(update SQLUser.DHC_AntCVReport set DPRP_Status='F',DPRP_IsEnd=1 where DPRP_RowID=:reportID)
 	if SQLCODE {
	 	s ret= "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"")
	 	tro
	 	q ret
	}
	TC
	d ##class(web.DHCAntCVSend).SendCVExec(reportID, contact, contactTel, contactResult, contactResultDesc, note, usercode)
	q ret
SaveExecErr
	tro
	q "-1^"_$ze
}

/// debug:d ##class(%ResultSet).RunQuery("web.DHCAntCVReportTrans","QryTransLog","")
Query QryTransLog(reportID As %String = "", OEOrdItem = "") As websys.Query(CONTAINID = 0, ROWSPEC = "trID,contact,contactTel,conResult,trAdvice,fwLocDesc,fwUserName,trUserName,trOpDT,trOpDesc")
{
}

ClassMethod QryTransLogExecute(ByRef QHandle As %Library.Binary, reportID As %String = "", OEOrdItem = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	s useTrans=0,langId=20
 	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
 	
	if reportID="" {
		s iscv=##class(web.DHCAntCVService).IsCVReport("",OEOrdItem)
		if iscv>0 s reportID=$p(iscv,"^",2)	
	}
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) $$$OK
	
	s trOrder=0
	for {
		s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
		q:trOrder=""
		s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
		s trDate=$p(trInfo,"\",1),trTime=$p(trInfo,"\",2),trUserCode=$p(trInfo,"\",3),trUserId="",trUserName=""
		s:trUserCode'="" trUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(trUserCode),""))
		s:trUserId>0 trUserName=$p(^SSU("SSUSR",trUserId),"^",2)
		
		
		s trOpType=$p(trInfo,"\",16)
		s trOpDesc=$case(trOpType,"Rec":"接收","E":"处理","FwD":"转发","D":"撤销","":"处理",:trOpType)
		s code=$case(trOpType,"Rec":"REC","E":"EXEC","FwD":"FWD","D":"DEL","":"EXEC",:trOpType)
		
		s trOpDT=##class(websys.Conversions).DateLogicalToHtml(trDate)_" "_$zt(trTime)
		s contact=$p(trInfo,"\",5),contactTel=$p(trInfo,"\",6),conResult=$p(trInfo,"\",7)
		s trAdvice=$p(trInfo,"\",9),trAdvice=$replace(trAdvice,"$c(92)","\"),trAdvice=$replace(trAdvice,"$c(94)","^")
		
		s fwLocDesc="",fwUserName=""
		s fwLocDr=$p(trInfo,"\",17)
		s:fwLocDr>0 fwLocDesc=$p($g(^CTLOC(+fwLocDr)),"^",2),fwLocDesc=$p(fwLocDesc,"-",$l(fwLocDesc,"-"))
		s fwUserDr=$p(trInfo,"\",18)
		s:fwUserDr>0 fwUserName=$p($g(^SSU("SSUSR",+fwUserDr)),"^",2)
		
		if useTrans{
			d TransData	
		}
		
		set Data=$lb(reportID_"||"_trOrder,contact,contactTel,conResult,trAdvice,fwLocDesc,fwUserName,trUserName,trOpDT,trOpDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
TransData
	s trOpDesc= ##class(web.DHCAntCVComm).GetProcessTrans(trOpDesc,langId)
	s conResult=##class(web.DHCAntCVComm).GetConResultTrans(conResult,langId)
	s trUserName=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",trUserName,langId)
	s fwUserName=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",fwUserName,langId)
	s fwLocDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",fwLocDesc,langId)
	q
}

/// 危急值撤销
ClassMethod SaveCancel(reportID, opUserCode, opNote, forceFlag = "")
{
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) "-1^错误的危急值ID"_reportID
	s repStatus=$p(^DHCAntCVReport(repType,repLabno,repOrder),"\",9)
	if (forceFlag'=1)&&(repStatus="F") q "-1^危急值已被处理，不能撤销"
	if repStatus="D" q "-1^危急值已被撤销，不用再次撤销" 
	
	s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",""),-1)+1
	TS
	s obj=##class(User.DHCAntCVReportTrans).%New(reportID)
	d obj.DPRTParRefSetObjectId(reportID)
	s obj.DPRTOrder=trOrder
	s obj.DPRTDate=+$h
	s obj.DPRTTime=+$p($h,",",2)
	s obj.DPRTUserID=opUserCode
	s obj.DPRTAdvice=opNote
	s obj.DPRTSessLoc=""
	s obj.DPRTOpUserCode=opUserCode
	s obj.DPRTOpType="D"
	s sc=obj.%Save()
	if $$$ISERR(sc){
		s ret="-1^"_$system.Status.GetErrorText(sc)
		tro
		q ret
	}
	&sql(update SQLUser.DHC_AntCVReport set DPRP_Status='D',DPRP_IsEnd=1 where DPRP_RowID=:reportID)
 	if SQLCODE {
	 	s ret= "-1^"_SQLCODE_$s('SQLCODE:"",SQLCODE'=100:" "_$g(%msg)_" "_$g(%mdiag(1)),1:"")
	 	tro
	 	q ret
	}
	TC
	d ##class(web.DHCAntCVSend).SendCVCancel(reportID,opUserCode,forceFlag)
	q 1
}

ClassMethod GetLatestTransConsultation(reportID)
{
	s linkInfo=##class(web.DHCAntCVReportLink).GetLastLink(reportID,25)
	if linkInfo'="" {
		q $p(linkInfo,"^",1)
		
	}
	q ""
}

ClassMethod GetLatestTransBlood(reportID)
{
	s linkInfo=##class(web.DHCAntCVReportLink).GetLastLink(reportID,"33")
	if linkInfo'="" {
		q $p(linkInfo,"^",1)
		
	}
	q ""
}

ClassMethod IsValidaMD5PIN(usercode, pin)
{
	q:pin="" "-1^密码为空"
	q:usercode="" "-1^用户为空"
	s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	q:userid="" "-1^用户名或密码错误"
	
	s persistPIN=$p($g(^SSU("SSUSR",userid)),"^",15)
	s persistPIN=##class(web.Util.Encryption).MD5HexStr(persistPIN)
	q:persistPIN'=pin "-1^用户名或密码错误"
	
	s SSUSRActive=$p($g(^SSU("SSUSR",userid)),"^",19)
 	q:SSUSRActive'="Y" "-1^用户未启用"
	s datefrom=$p($g(^SSU("SSUSR",userid)),"^",96)
	s dateto=$p($g(^SSU("SSUSR",userid)),"^",97)
	Q:(datefrom'="")&&(datefrom>+$H) "-1^用户未启用"
	Q:(dateto'="")&&(dateto<+$H) "-1^用户未启用"
	q 1
}

/// 自动接收（医生读即接收，处理时自动接收）
ClassMethod AutoSaveReceive(reportID, userid, pwd = "")
{
	s userName=$p(^SSU("SSUSR",userid),"^",2),userCode=$p(^SSU("SSUSR",userid),"^",1)
	
	s repType=$p(reportID,"||",1),repLabno=$p(reportID,"||",2),repOrder=$p(reportID,"||",3)
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s adm=$p(repInfo,"\",7),admLoc=$p(^PAADM(adm),"^",4)
	
	
	s ReceiveContactTel= ##class(web.DHCAntCVOptions).GetBaseOpt("ReceiveContactTel")
	s contactPhone=$case(ReceiveContactTel,
		"DocPhone":##class(web.DHCAntCVComm).GetUserPhone(userid),
		"DocWorkPhone":##class(web.DHCAntCVComm).GetUserWorkPhone(userid),
		"AdmLocPhone":##class(web.DHCAntCVComm).GetLocPhone(admLoc),
		:"")
	
	if ##class(web.DHCAntCVOptions).GetBaseOpt("PINOnReceive")=1,pwd="auto" {  //处理时验证密码
		s persistPIN=$p($g(^SSU("SSUSR",userid)),"^",15)
		s pwd=##class(web.Util.Encryption).MD5HexStr(persistPIN) //自动取密码
	}
	
	s ret=..SaveReceive(reportID,userName,contactPhone,"F","已通知","",userCode,userCode,pwd)
	q ret
}

ClassMethod SaveFirstRead(reportID)
{
	s (UserId,CareProv,CarProvTpDR,Type)=""
	set UserId=%session.Get("LOGON.USERID")
	set CareProv=$p(^SSU("SSUSR",UserId),"^",14)
	i CareProv>0 Set CarProvTpDR = $p($g(^CTPCP(CareProv,1)),"^",4) 
	i CarProvTpDR>0 Set Type = $p($g(^CT("CPT",CarProvTpDR)),"^",4)	
	s ret=##class(web.DHCAntCVReportLink).SaveFirstRead(reportID,UserId)
	if Type="DOCTOR" {
		s ret=##class(web.DHCAntCVReportLink).SaveFirstDocRead(reportID,UserId)
		if ret>0,##class(web.DHCAntCVOptions).GetBaseOpt("ReceiveMode")=3 {  //医生查看即接收
			s ret=..AutoSaveReceive(reportID,UserId,"auto")
		}
	}elseif Type="NURSE" {
		s ret=##class(web.DHCAntCVReportLink).SaveFirstNurRead(reportID,UserId)
	}
	q 1
}

ClassMethod SaveTransNoOrder(reportID, userid)
{
	if userid="",$d(%session) s userid=%session.Get("LOGON.USERID")
	s ret=##class(web.DHCAntCVReportLink).SaveFirstNoOrder(reportID,userid)
	q ret
}

}
