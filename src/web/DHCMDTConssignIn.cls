Import SQLUser

/// Creator: 		qqa
/// CreateDate: 	2019-04-16
/// Descript: 		mdt签到
Class web.DHCMDTConssignIn Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:qqa
/// CreatDate:2019-04-16
/// Descript:修改MDT签到状态:同一个人同一天所有记录
/// InPut:CstItmID(MDT子表ID),Password(用户密码),SignType(1:不验证,"":验证)
/// OutPut:0/成功,其他/失败
/// w ##class(web.DHCMDTConssignIn).UserConssignIn("26||3","","1","18302")
ClassMethod UserConssignIn(CstItmID, Password, SignType = "", LgUserID = "")
{
	n (CstItmID,Password,SignType,LgUserID)
	
	s ID = +CstItmID
	S CH = $p(CstItmID,"||",2)
	s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)  ;会诊医生
	Q:CareProvID=0 "未获取到会诊专家信息!"
	s UserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	s CstNDate=$p(^DHCMDTCON(ID),"^",8)
	s CurStatID = $p(^DHCMDTCON(ID),"^",12)
	s CurStatCode =  $p(^DHCMDTS(+CurStatID),"^",1)
	s:SignType=1 Password=##class(web.DHCMDTCom).GetUserSignPas(UserID) ///不需输入密码
	;q:CurStatCode'=2 "-99"      ;非发送已经收费状态不允许签到 
	
	
	s Err=0
	ts
	
	s Err = ##class(web.DHCMDTConssignIn).UpdateMdtConssign(CstItmID,Password,LgUserID) ;本次会诊签到
	tro:Err'=0
	q:Err'=0 Err
	
	s Err = ##class(web.DHCMDTConssignIn).UpdateMdtConssignAllDay(CstNDate,CareProvID,Password,LgUserID) ;同步当日其他会诊签到
	tro:Err'=0
	q:Err'=0 Err
	
	tc
	
	;是否全部签到
	s IsConsInAll = ##class(web.DHCMDTCom).IsConssignInAll(+CstItmID)
	q Err_"^"_IsConsInAll
}

/// Creator:qqa
/// CreatDate:2019-06-10
/// Descript:修改MDT签到状态:同一个人同一天所有记录
/// InPut:CstNDate(日期:Cache格式),ProvID(CTCareProv的ID),Password(用户密码)
/// OutPut:0/成功,其他/失败
/// w ##class(web.DHCMDTConssignIn).UpdateMdtConssignAllDay()
ClassMethod UpdateMdtConssignAllDay(CstNDate, ProvID, Password, LgUserID = "")
{
	n (CstNDate,ProvID,Password,LgUserID)
	s Err=0
	q:CstNDate="" ""
	s ID=""
	f  s ID=$o(^DHCMDTCON(0,"NDate",CstNDate,ID)) Q:(ID="")||(Err'=0)  D
	.s CurStatID = $p(^DHCMDTCON(ID),"^",12)
	.q:+CurStatID=0
	.q:'$d(^DHCMDTS(+CurStatID))
	.s CurStatCode = $p(^DHCMDTS(+CurStatID),"^",1)
	.;q:CurStatCode'=2
	.s CH=""
	.f  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:(CH="")||(Err'=0)  D
	..s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)  ;会诊医生
	..q:+ProvID'=+CareProvID
	..s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(ID_"||"_CH)   ;已经签到不需要处理
	..q:IsConssignIn=1
	..s Err = ##class(web.DHCMDTConssignIn).UpdateMdtConssign(ID_"||"_CH,Password,LgUserID) ;未签到设置签到信息
	..s:Err'=0 Err="同步签到,"_Err
	q Err
}

/// Creator:qqa
/// CreatDate:2019-06-10
/// Descript:修改MDT签到状态:同一个人同一天所有记录
/// InPut:CstNDate(日期:Cache格式),ProvID(CTCareProv的ID)
/// OutPut:0/成功,其他/失败
/// w ##class(web.DHCMDTConssignIn).UpdateMdtConssignAllDayNoPas()
ClassMethod UpdateMdtConssignAllDayNoPas(CstNDate, ProvID)
{
	n (CstNDate,ProvID)
	s Err=0
	s UserID= $o(^SSU("SSUSR",0,"CTPCP",+ProvID,""))
	s Password=##class(web.DHCMDTCom).GetUserPas(UserID)	;获取密码
	s Err=..UpdateMdtConssignAllDay(CstNDate, ProvID,Password) ;完成本人此日期所有会诊签到信息
	q Err
}

/// Creator:qqa
/// CreatDate:2019-06-10
/// Descript:修改MDT签到状态
/// InPut:CstItmID(MDT子表ID),Password(用户密码),SignType(1:不验证,"":验证)
/// OutPut:0/成功,其他/失败
/// w ##class(web.DHCMDTConssignIn).UpdateMdtConssign()
ClassMethod UpdateMdtConssign(CstItmID, Password, LgUserID)
{
	n (CstItmID,Password,LgUserID)
	
	s Err=0
	s ID = +CstItmID
	S CH = $p(CstItmID,"||",2)       
	s StatusID = ##class(web.DHCMDTConsult).GetConsStatus(70) ;获取状态ID
	s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	s UserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	s ViliUserPas = ##class(web.DHCMDTCom).ViliUserPassword("",CareProvID,Password) ;验证密码
	q:ViliUserPas'=0 ViliUserPas
	

	s Date =+$h
	s Time =$p($h,",",2)
	s Note = "签到"
	
	s Err= ##Class(web.DHCMDTConsult).InsConsLog(CstItmID,UserID,StatusID,"")
	q:Err'=0 "子记录签到状态插入失败!"
	
	s Ret = ##class(web.DHCMDTCom).IsConssignInAll(ID)   ;判断是否全部为签到状态
	i Ret=1 d
	.s Ret= ##Class(web.DHCMDTConsult).InsMasStatus(ID,StatusID)  ;状态改为签到
	.s:Ret'=0 Err="修改主表状态为签到失败!"
	.q:Err'=0
	.s Ret= ##Class(web.DHCMDTConsult).InsConsLog(ID,LgUserID,StatusID,"")
	.s:Ret'=0 Err="主记录签到状态插入失败!"
	q Err
}

/// w ##class(web.DHCMDTConssignIn).GetUserCstData(6,"ys02")
ClassMethod GetUserCstData(CstID, UserCode, UserId = "")
{
	n (CstID,UserCode,UserId)
	s SSUSRRowId=""
	s:UserId="" SSUSRRowId = $o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	s:UserId'="" SSUSRRowId=UserId
	q:SSUSRRowId="" "-1^用户Code:"_UserCode_"未找到关联的用户"
	s CstItmId=##class(web.DHCMDTConsult).GetCstItmIdByUser(CstID,SSUSRRowId)
	s RetDesc= 0_"^"_"成功"
	s:CstItmId="" RetDesc="-2^此人未在会诊专家队列中!"
	s CH=$p(CstItmId,"||",2)
	s CstDocData="",UserData=""
	s UserName=$p(^SSU("SSUSR",SSUSRRowId),"^",2)
	s UserCareProvID=$p(^SSU("SSUSR",SSUSRRowId),"^",14)
	q:+UserCareProvID=0 "-3^未关联医护人员!"
	s UserPrvTpID=$p($g(^CTPCP(UserCareProvID,1)),"^",4)
	s UserPrvTp=$p($g(^CT("CPT",+UserPrvTpID)),"^",2)
	s UserData=SSUSRRowId_"^"_UserName_"^"_UserPrvTpID_"^"_UserPrvTp_"^"_UserCareProvID
	i CH'="" d
	.s LocDesc=""
	.s LocID=$p(^DHCMDTCON(CstID,"I",CH),"^",1)          /// 科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s PrvTpID="",PrvTp=""
	.s PrvTpID=+$p(^DHCMDTCON(CstID,"I",CH),"^",4)       /// 职称
	.i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s CareProv=""
	.s CareProvID=$p(^DHCMDTCON(CstID,"I",CH),"^",2)     /// 医生
	.s:+CareProvID'=0 CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	.s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(CstItmId)
	.s CstDocData=LocDesc_"^"_PrvTp_"^"_CareProv_"^"_CstItmId_"^"_IsConssignIn
	q RetDesc_","_UserData_","_CstDocData
}

/// w ##class(web.DHCMDTConssignIn).GetLoginLocList("12176")
ClassMethod GetLoginLocList(UserID)
{
	n (UserID)
	q:UserID="" "[]"
	w "["
	s Count=0
	s ChildSub =0
	f  s ChildSub=$o(^SSU("SSUSR",UserID,"OTHLL",ChildSub)) q:ChildSub=""  d
	.s OTHLLRowId=UserID_"||"_ChildSub
	.s OTHLLHospitalDR=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",3)
	.s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",UserID,"OTHLL",ChildSub)),"^",1)
	.s CTLOCDesc=""
	.s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData("id^text",OTHLLCTLOCDR_"^"_CTLOCDesc)
	w "]"
	q ""
}

}
