/// CTOR: QP
/// DATE: 2017-03-13
/// VERN: V4.1.3
/// DESC: 抗菌药物消息提示
Class DHCAnt.KSS.Extend.MessageTip Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 是否启用了抗菌药审核物消息提示功能
/// 	  1  启用  0 未启用
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
ClassMethod ComEnableMsgTip(InHosp = "")
{
	n (InHosp,%session)
	s $ZT="Err"
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	s mRtn=0
	s msgTip=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIP",InHosp)
	q:(msgTip="")||(msgTip=0) mRtn
	q 1
}

/// CTOR: QP
/// DATE: 2017-06-23
/// DESC: 发送抗菌药物消息提示
/// 	  Action: send/cacel/exec
/// OUT : 成功返回1，错误返回0
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).SendKSSMsgTip()
ClassMethod SendKSSMsgTip(aaid As %String, process As %String = "", status As %String = "", requser As %String = "", InHosp = "")
{
	n (aaid,process,status,requser,InHosp,%session)
	s ^TEMP("DHCAnt","TEMP","KSS",3)=aaid_","_process_","_status_","_requser
	i InHosp="" {
		i $d(%session) s InHosp=%session.Get("LOGON.HOSPID")
		e  s InHosp=..GetApplyHosp(aaid)
	}
	Q:InHosp="" 0
	s $ZT="Err"
	q:aaid="" 0
	q:'$d(^DHCDAA("ANT",aaid)) 0
	;q:(##class(DHCAnt.KSS.Common.Method).ComIsSend(aaid)=0) 0
	i process="" s process=$p(^DHCDAA("ANT",aaid,1),"^",36)
	i status="" s status=$p(^DHCDAA("ANT",aaid),"^",12)
	s mSperator="-"
	s toUser2=$p(^DHCDAA("ANT",aaid),"^",9)
	s appLoc=$p(^DHCDAA("ANT",aaid,1),"^",25)  
	s msgTipCon=0	//##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIPCON",InHosp)
	s defaultUrl=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("MSRGTIPKSSURL")
	s consultUrl=""	//##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSRGTIPCONURL",InHosp)
	i defaultUrl="" s defaultUrl="dhcant.kss.business.audit.hui.csp"
	i consultUrl="" s consultUrl="dhcconsult.csp"
	s msgTipUrl=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("MSGTIPURL")
	
	s toUserInfo=..GetAllReceiveDoc(aaid,status,appLoc,process,InHosp)
	s toUser=$p(toUserInfo,"!",1)
	s toLocRowId=$p(toUserInfo,"!",2)
	s conFlag=$p(toUserInfo,"!",3)
	i conFlag=1 s defaultUrl=consultUrl
	
	i toLocRowId'="" s toLocRowId=toLocRowId_"|OnlyFlag"
	s toLocRowId2=appLoc_"|OnlyFlag"
	s toMessage=..BuildMessage(1,aaid,status,process)
	s toMessage2=""
	s actionDesc=##class(DHCAnt.Base.MainConfigExcute).GetOSDesc("PTYPE"_status)
	s nextActionDesc=##class(DHCAnt.KSS.Common.Method).GetNextAllStatusDesc(aaid,status,InHosp)
	i ((status="F")||(status="H")||(status="S")) s toMessage2=..BuildMessage(2,aaid,status,process,actionDesc,nextActionDesc)
	s para="AARowid="_aaid_"&Status="_status
	s defaultUrl=defaultUrl_"?"_para
	s BizObjId=aaid_mSperator_status
	;s otherInfoJson="{""linkParam"":"""_para_""",""BizObjId"":"""_BizObjId_"""}"
	i msgTipUrl=1 d
	.s otherInfoJson="{""link"":"""_defaultUrl_""",""BizObjId"":"""_BizObjId_"""}"
	e  d
	.s otherInfoJson="{""BizObjId"":"""_BizObjId_"""}"
	s otherInfoJson2="{""BizObjId"":"""_BizObjId_"""}"
	s msgTipKssCode=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("MSGTIPKSSCODE")
	s msgTipKssResult=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("MSGTIPKSSRESULT")
	s sendCode=msgTipKssCode
	i requser'="" s fromUserRowId=requser
	e  s fromUserRowId=%session.Get("LOGON.USERID")
	s episodeId=$p(^DHCDAA("ANT",aaid),"^",1)
	i $d(%session) s fromUserLoc=%session.Get("LOGON.CTLOCID")
	e  s fromUserLoc=$p(^DHCDAA("ANT",aaid,1),"^",25)
	
	//发送消息
	i (status="R")||(status="U") s sendCode=msgTipKssResult,otherInfoJson=otherInfoJson2
	i conFlag=1 d
	.q:msgTipCon'=1
	.s cnum=$l(toUser,"^")
	.f i=1:1:cnum d
	..s curToUser=$p(toUser,"^",i)
	..s curToLocRowId=$P(toLocRowId,"^",i)
	..s BizObjId=aaid_mSperator_status_mSperator_curToUser
	..i msgTipUrl=1 s otherInfoJson="{""link"":"""_defaultUrl_""",""BizObjId"":"""_BizObjId_"""}"
	..e  s otherInfoJson="{""BizObjId"":"""_BizObjId_"""}"
	..s msgRtn=..Send(toMessage,sendCode,fromUserRowId,episodeId,"",curToUser,otherInfoJson,curToLocRowId,"",fromUserLoc)
	e  d
	.s msgRtn=..Send(toMessage,sendCode,fromUserRowId,episodeId,"",toUser,otherInfoJson,toLocRowId,"",fromUserLoc)
	i toMessage2'="" s msgRtn=..Send(toMessage2,msgTipKssResult,fromUserRowId,episodeId,"",toUser2,otherInfoJson2,toLocRowId2,"",fromUserLoc)	
	
	//执行消息
	i status'="A" d 
	.s prevNode=##class(DHCAnt.KSS.Common.Method).GetPrevNode(aaid,status)
	.i prevNode="" s prevNode=##class(DHCAnt.KSS.Common.Method).GetPrevNodeByKSSLog(aaid,status)
	.q:prevNode=""
	.s objectId=aaid_mSperator_prevNode
	.s execRtn=..Exec("",msgTipKssCode,"","",objectId,fromUserRowId,+$h,$P($h,",",2))
	
	q 1
	
Err
	q 0
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: 处理会诊信息
/// 	  1 成功，0 未成功
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).ComExecConsultMsg()
ClassMethod ComExecConsultMsg(aaid As %String, consuid As %String, conAction As %String = "")
{
	n (aaid,consuid,conAction,%session)
	s $ZT="Err"
	s mSperator="-"
	s mRtn=1
	s msgTipCon=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIPCON")
	s enableMsgTip=##class(DHCAnt.KSS.Extend.MessageTip).ComEnableMsgTip()
	s msgTipKssCode=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIPKSSCODE")
	q:msgTipCon'=1 mRtn
	q:msgTipKssCode="" mRtn
	q:enableMsgTip'=1 mRtn
	s prevNode=##class(DHCAnt.KSS.Common.Method).GetConPrevStatus(aaid)
	i $d(%session) s fromUserRowId=%session.Get("LOGON.USERID")
	e  s fromUserRowId=consuid
	q:prevNode="" mRtn
	s objectId=aaid_mSperator_prevNode_mSperator_consuid
	s ^TEMP("DHCAnt","TEMP","KSS",4)=aaid_","_consuid_","_objectId
	s execRtn=..Exec("",msgTipKssCode,"","",objectId,fromUserRowId,+$h,$P($h,",",2))
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-15
/// DESC: Portal中处理完成发送消息
/// OUT : 成功返回1，错误返回0
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).SendMsgInPortal()
ClassMethod SendMsgInPortal(userid As %String, aaid As %String, bizObjId As %String, action As %String)
{
	n (userid, aaid, bizObjId,action,%session)
	s $ZT="Err"
	s mRtn=1
	
	s curStatus=$p(^DHCDAA("ANT",aaid),"^",12)
	s curProcess=$p($g(^DHCDAA("ANT",aaid,1)),"^",36)
	s auditType=""
	
	i (bizObjId["A") d
	.i curProcess["F" s auditType="KSF"
	.e  i curProcess["S" s auditType="KS"
	.e  i curProcess["U" s auditType="LAST"
	.e  s auditType="CON"	//不做处理,由会诊处理
	
	i (bizObjId["F") d
	.i curProcess["S" s auditType="KS"
	.e  i curProcess["U" s auditType="LAST"
	.e  s auditType="CON"
	
	i (bizObjId["H") d
	.i curProcess["S" s auditType="KS"
	.e  s auditType="LAST"
	
	i (bizObjId["S") s auditType="LAST"
	
	q:(auditType="CON")||(auditType="") mRtn
	s auditRtn=##class(DHCAnt.KSS.MainBusiness).VerifyApply(aaid,auditType,action,userid)
	q:auditRtn'=0 0
	
	q mRtn
}

/// CTOR:	QP
/// DATE:	2017-06-27
/// DESC:	获取接受抗菌消息提示的所有的人员
/// In  :	申请ID:AARowid,当前状态:status,申请科室ID:locid,抗菌药物流程:process
/// Out :	            
/// Exec:   w ##class(DHCAnt.KSS.Extend.MessageTip).GetAllReceiveDoc("389||75")
ClassMethod GetAllReceiveDoc(AARowid As %String, status As %String, locid As %String, process As %String, InHosp = "")
{
	n (AARowid,status,locid,process,InHosp)
 	s mRtn=""
 	q:AARowid="" mRtn
 	q:'$d(^DHCDAA("ANT",AARowid)) mRtn
 	s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
 	s admId=$p(^DHCDAA("ANT",AARowid),"^",1)
 	s appDoc=$p(^DHCDAA("ANT",AARowid),"^",9)
 	s admType=##class(DHCAnt.KSS.Common.Method).GetPAAdmType(admId)
 	s poisonId=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(arcim)
 	s separator2="!"
 	s consultFlag=1
 	
 	i status="A" d
 	.i process["F" s mRtn=..GetLocAuthDoc(locid,admType,poisonId,InHosp)
 	.e  i process["H" s mRtn=(..GetConsultDoc(AARowid))_separator2_consultFlag
 	.e  i process["S" s mRtn=..GetLocAuthDoc(locid,admType,poisonId,InHosp)
 	.e  s mRtn=""	s mRtn=..GetLastAuditDoc(AARowid,admType,poisonId,InHosp)
 	
 	i status="F" d 
 	.i process["H" s mRtn=(..GetConsultDoc(AARowid))_separator2_consultFlag
 	.e  i process["S" s mRtn=..GetLocAuthDoc(locid,admType,poisonId,InHosp)
 	.e  s mRtn=..GetLastAuditDoc(AARowid,admType,poisonId,InHosp)
 	
 	i status="H" d
 	.i process["S" s mRtn=..GetLocAuthDoc(locid,admType,poisonId,InHosp)
 	.e  s mRtn=..GetLastAuditDoc(AARowid,admType,poisonId,InHosp)
 	
 	i status="S" s mRtn=..GetLastAuditDoc(AARowid,admType,poisonId,InHosp)
 	
 	i (status="U")||(status="R") s mRtn=appDoc_separator2_locid
 	
 	q mRtn
}

/// CTOR:	QP
/// DATE:	2017-06-29
/// DESC:	组合消息内容
/// In  :	type:1/2 , 1:发送给下一步的医生，2：发送给申请医生
/// Out :	   
/// TABL: 	PAPatMas,PAADM       
/// Exec:   w ##class(DHCAnt.KSS.Extend.MessageTip).BuildMessage("389||75")
ClassMethod BuildMessage(type As %String, aaid As %String, status As %String, process As %String, actionDesc As %String = "", nextActionDesc As %String = "")
{
	n (aaid,status,type,process,actionDesc,nextActionDesc)

	s mRtn=""	
 	q:aaid="" mRtn
	q:'$d(^DHCDAA("ANT",aaid)) mRtn
	
	s useReasonId=$p(^DHCDAA("ANT",aaid,1),"^",20)
	q:useReasonId="" mRtn
	
	s admId=$p(^DHCDAA("ANT",aaid),"^",1)
	s patMasId=$p(^PAADM(admId),"^",1)
	s patName=$p(^PAPER(patMasId,"ALL"),"^",1)
	
	s arcim=$p(^DHCDAA("ANT",aaid),"^",2)
	s arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
	
	s aimId=$P(^DAUP("DAUP",useReasonId),"^",20)
	s aimDesc=$p(^DHCAntBasePurposeDataConfigD(aimId),"^",3)
	
	s instId=$P(^DAUP("DAUP",useReasonId),"^",10)
	s instDesc=$p(^DHCAntBasePurposeDataConfigD(instId),"^",3)
	
	s partId=$P(^DAUP("DAUP",useReasonId),"^",6)
	s partDesc=$p(^DHCAntBasePurposeDataConfigD(partId),"^",3)
	
	s appUser=$p(^DHCDAA("ANT",aaid),"^",9)
	s appUserName=$p(^SSU("SSUSR",appUser),"^",2)
	
	s auditUserName=""
	s auditUser=$p(^DHCDAA("ANT",aaid,1),"^",10)
	i auditUser'="" s auditUserName=$p(^SSU("SSUSR",auditUser),"^",2)
	
	s currentAuditInfo=##class(DHCAnt.KSS.Common.Method).GetCurrentAuditInfo(aaid)
	s currentAuditUser=$p(currentAuditInfo,"^",1)
	s currentAuditUserName=$p(^SSU("SSUSR",currentAuditUser),"^",2)
	
	i type=1 d
	.i status="A" d
	..i process["F" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您科室预审，谢谢！"
	..e  i process["H" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您会诊，谢谢！"
	..e  i process["S" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您科室审核，谢谢！"
	..e  s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您最终审核，谢谢！"
	
	.i status="F" d
	..i process["H" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您会诊，谢谢！"
	..e  i process["S" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您科室审核，谢谢！"
	..e  s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您最终审核，谢谢！"
	
	.i status="H" d
	..i process["S" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您科室审核，谢谢！"
	..e  s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您最终审核，谢谢！"
	
	.i status="S" s mRtn=appUserName_"给"_patName_"使用【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，需要您最终审核，谢谢！"
	
	.i status="U" s mRtn="很高兴告诉您，您给"_patName_"开了【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，已经被"_auditUserName_"审核通过，谢谢！"
	
	.i status="R" s mRtn="很遗憾通知您，您给"_patName_"开了【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，已经被"_auditUserName_"拒绝了，谢谢！"
	
	i type=2 d
	.s mRtn="很高兴告诉您，您给"_patName_"开了【"_arcimDesc_"】，使用目的为："_aimDesc_"，指征："_instDesc_"，感染部位："_partDesc_"，已经被"_currentAuditUserName_actionDesc_"通过，还需要进行"_nextActionDesc_"，谢谢！" 
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 获取科室有权限的医生
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).GetLocAuthDoc()
ClassMethod GetLocAuthDoc(locid As %String, admType As %String, poisonId As %String, InHosp = "")
{
	n (locid,admType,poisonId,InHosp)
	s mRtn=""
	q:locid="" mRtn
	s separator="^"
	s separator2="!"
	
	s RowId=""
 	f  s RowId=$o(^RB("RES",0,"CTLOC",locid,RowId))  q:RowId=""  d
 	.s doctorId=$p($g(^RB("RES",RowId)),"^",2)  ///医护人员表ID
 	.s authFlag=##class(DHCAnt.KSS.Common.Method).GetDoctorTypePoisonFlag(doctorId,admType,poisonId,InHosp)
	.q:authFlag'=1
	.s ssuid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(doctorId)
	.i mRtn="" s mRtn=ssuid
	.e  s mRtn=mRtn_separator_ssuid
	i mRtn'="" s mRtn=mRtn_separator2_locid
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 获取会诊医生
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).GetConsultDoc()
ClassMethod GetConsultDoc(aaid As %String)
{
	n (aaid)
	s mRtn=""
	q:aaid="" mRtn
	s separator="^"
	s separator2="!"
	s depStr=""
	
	s consultNums=$p(^DHCDAA("ANT",aaid,1),"^",35)
	s consultDoc1=$p($g(^DHCDAA("ANT",aaid,1)),"^",5)
	s consultDoc2=$p($g(^DHCDAA("ANT",aaid,1)),"^",28)
	s consultDoc3=$p($g(^DHCDAA("ANT",aaid,1)),"^",31)
	
	s consultdep1=$p($g(^DHCDAA("ANT",aaid,1)),"^",4)
	s consultdep2=$p($g(^DHCDAA("ANT",aaid,1)),"^",27)
	s consultdep3=$p($g(^DHCDAA("ANT",aaid,1)),"^",30)
	
	i consultDoc1'="" s consultDoc1=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc1)
	i consultDoc2'="" s consultDoc2=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc2)
	i consultDoc3'="" s consultDoc3=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(consultDoc3)
	
	i consultNums=1 s mRtn=consultDoc1,depStr=consultdep1
	i consultNums=2 d
	.s mRtn=consultDoc1_separator_consultDoc2
	.s depStr=consultdep1_separator_consultdep2
	i consultNums=3 d
	.s mRtn=consultDoc1_separator_consultDoc2_separator_consultDoc3
	.s depStr=consultdep1_separator_consultdep2_separator_consultdep3
	
	i mRtn'="" s mRtn=mRtn_separator2_depStr
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-28
/// DESC: 获取最终审核医生
/// 	  
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).GetLastAuditDoc()
ClassMethod GetLastAuditDoc(aaid As %String, admType As %String, poisonId As %String, InHosp = "")
{
	n (aaid,admType,poisonId,InHosp)
	s mRtn=""
	s separator="^"
	s separator2="!"
	s lastDep=$p(^DHCDAA("ANT",aaid,1),"^",37)
	s mRtn=..GetLocAuthDoc(lastDep,admType,poisonId,InHosp)
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2017-06-29
/// DESC: 发送消息
/// 	 
/// OUT : 成功返回1
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).send()
ClassMethod Send(Context, ActionTypeCode, FromUserRowId, EpisodeId = "", OrdItemId = "", ToUserRowId As %String(MAXLEN=30000) = "", OtherInfoJson As %String(MAXLEN=30000) = "", ToLocRowId As %String(MAXLEN=30000) = "", EffectiveDays = "", CreateLoc = "")
{
	n (Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)
	s ^TEMP("DHCAnt","TEMP","KSS",1)=Context_","_ActionTypeCode_","_FromUserRowId_","_EpisodeId_","_OrdItemId_","_ToUserRowId_","_OtherInfoJson_","_ToLocRowId_","_EffectiveDays_","_CreateLoc
	i ActionTypeCode="" s ActionTypeCode=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIPKSSCODE")
	s rtn=##class(websys.DHCMessageInterface).Send(Context,ActionTypeCode,FromUserRowId,EpisodeId,OrdItemId,ToUserRowId,OtherInfoJson,ToLocRowId,EffectiveDays,CreateLoc)
	q:rtn=0 1
	q rtn
}

/// CTOR: QP
/// DATE: 2017-06-29
/// DESC: 执行消息
/// 	 
/// OUT : 成功返回>1
/// EXEC: w ##class(DHCAnt.KSS.Extend.MessageTip).GetLastAuditDoc()
ClassMethod Exec(ToUserId, ActionType, EpisodeId, OEOrdItemId, ObjectId, ExecUserDr = "", ExecDate = "", ExecTime = "")
{
	n (ToUserId, ActionType, EpisodeId, OEOrdItemId, ObjectId, ExecUserDr , ExecDate , ExecTime )
	s ^TEMP("DHCAnt","TEMP","KSS",2)=ToUserId_","_ActionType_","_EpisodeId_","_OEOrdItemId_","_ObjectId_","_ExecUserDr_","_ExecDate_","_ExecTime
	i ActionType="" s ActionType=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIPKSSCODE")
	s rtn=##class(websys.DHCMessageInterface).Exec(ToUserId, ActionType, EpisodeId, OEOrdItemId, ObjectId, ExecUserDr , ExecDate , ExecTime)
	q rtn
}

/// CTOR: QP
/// DATE: 2021-03-29
/// DESC: 获取申请院区
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Bed.AppList).GetArcimDescByCode("GZ00001")
ClassMethod GetApplyHosp(aaid)
{
	s mRtn=""
	Q:aaid="" mRtn
	s AppLoc=$p(^DHCDAA("ANT",aaid,1),"^",25)
	Q:AppLoc="" mRtn
	s mRtn=$p(^CTLOC(AppLoc),"^",22)
	
	Q mRtn
}

}
