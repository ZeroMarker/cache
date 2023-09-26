Import SQLUser

Class web.DHCVISVoiceMessage Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCVISVoiceMessage).InsertVoiceMessageWarn("有新医嘱","127.0.0.1")
ClassMethod InsertVoiceMessageWarn(VoiceContent As %String = "", WarnId As %String = "", VoiceRemoteIP As %String = "", VoicePlanDate As %String = "", VoicePlanTime As %String = "") As %String
{
	i VoiceRemoteIP="" s VoiceRemoteIP=WarnId
	s InsertDate=+$H,InsertTime=$P($H,",",2)
	i +VoicePlanDate=0 s VoicePlanDate=InsertDate
	i +VoicePlanTime=0 s VoicePlanTime=InsertTime
	s locId=$p(^DHCVISWarn(WarnId),"^",7)
	s locName=$p($g(^CTLOC(locId)),"^",2)
	s HospitalId=$p(^DHCVISWarn(WarnId),"^",2)
	s hospitalName=$p($g(^CT("HOSP",HospitalId)),"^",2)
	s BuildId=$p(^DHCVISWarn(WarnId),"^",3)
	s bulidName=$p($g(^DHCVISBuild(BuildId)),"^",2)
	s RoomId=$p(^DHCVISWarn(WarnId),"^",6)
	s roomName=$p($g(^DHCVISRoom(RoomId)),"^",2)
	s VoiceState="N"
	s WaitNum=0
	s VoiceContent=hospitalName_"!"_locId_"!"_locName_"!"_roomName_"!"_bulidName
	&SQL(insert into DHC_VIS_VoiceMessage (VoiceContent,VoiceState,VoicePlanDate,VoicePlanTime,VoiceRemoteIP,WarnId,InsertDate,InsertTime) values (:VoiceContent,:VoiceState,:VoicePlanDate,:VoicePlanTime,:VoiceRemoteIP,:WarnId,:InsertDate,:InsertTime))
	i SQLCODE'=0 q "语音消息插入失败!"
	q SQLCODE
}

ClassMethod InsertVoiceMessage(VoiceContent As %String = "", ClientIP As %String = "", VoiceRemoteIP As %String = "", VoicePlanDate As %String = "", VoicePlanTime As %String = "") As %String
{
	q ""
	//i $G(clientIP)="" s clientIP=$ZUTIL(67,15,$JOB)
	i $G(ClientIP)="" d
	.i $D(%session) s ClientIP=%session.Data("REMOTE_ADDR")
	i $G(ClientIP)="" s ClientIP=$ZUTIL(67,15,$JOB)
	q:(VoiceContent="") "语音消息为空!"
	q:((ClientIP="")&&(VoiceRemoteIP="")) "语音消息的来源去向不存在!"
	s ClientId=$O(^DHCVISClienti(0,"ClientIP",ClientIP,""))
	q:ClientId="" "叫号终端未授权!"
	s ServerId=$P($G(^DHCVISClient(ClientId)),"^",1)
	s ClientName=$P($G(^DHCVISClient(ClientId)),"^",3)
	q:ServerId="" "终端未设置语音处理服务!"
	s ServerActive=$P($G(^DHCVISServer(ServerId)),"^",3)
	q:ServerActive'="Y" "语音处理服务不可用!"
	i VoiceRemoteIP="" s VoiceRemoteIP=ClientIP
	s InsertDate=+$H,InsertTime=$P($H,",",2)
	i +VoicePlanDate=0 s VoicePlanDate=InsertDate
	i +VoicePlanTime=0 s VoicePlanTime=InsertTime
	s VoiceState="N"
	s WaitNum=0
	s VoiceId=""
	f  s VoiceId=$O(^DHCVISVoicei(0,"PlanDateIP",VoicePlanDate,"N",VoiceRemoteIP,VoiceId)) q:(VoiceId="")  d
	.s WaitNum=WaitNum+1
	q:WaitNum>10 "语音消息队列超出最大负荷!"
	&SQL(insert into DHC_VIS_VoiceMessage (VoiceContent,VoiceState,VoicePlanDate,VoicePlanTime,VoiceRemoteIP,WarnId,InsertDate,InsertTime) values (:VoiceContent,:VoiceState,:VoicePlanDate,:VoicePlanTime,:VoiceRemoteIP,:ClientIP,:InsertDate,:InsertTime))
	i SQLCODE'=0 q "语音消息插入失败!"
	q SQLCODE
}

/// w ##class(web.DHCVISVoiceMessage).GetVoiceMessage()
ClassMethod GetVoiceMessage(serverIP As %String = "") As %String
{
	q ""
	s RetStr=""
	i serverIP="" s serverIP=$ZUTIL(67,15,$JOB)
	s FtpServerIP=$G(^DHCVISSet("Ftp","ServerIP"))
	s FtpServerDir=$G(^DHCVISSet("Ftp","VoiceMessage"))
	s FtpUser=$G(^DHCVISSet("Ftp","User"))
	s FtpPassword=$G(^DHCVISSet("Ftp","Password"))
	q:(FtpServerIP="")||(FtpServerDir="")||(FtpUser="")||(FtpPassword="") ""
	s FtpParm=FtpServerIP_"*"_FtpUser_"*"_FtpPassword_"*"_FtpServerDir
	s VoicePlanDate=+$H
	s NowTime=$P($H,",",2)
	s VoicePlanTime=""
	f  s VoicePlanTime=$O(^DHCVISVoicei("0","PlanState",VoicePlanDate,"N",VoicePlanTime)) q:((VoicePlanTime="")||(VoicePlanTime>(NowTime+60))||(RetStr'=""))  d
	.s VoiceId=""
	.f  s VoiceId=$O(^DHCVISVoicei("0","PlanState",VoicePlanDate,"N",VoicePlanTime,VoiceId)) q:((VoiceId="")||(RetStr'=""))  d
	..s VoiceStr=$G(^DHCVISVoice(VoiceId))
	..q:VoiceStr=""
	..s VoiceContent=$P(VoiceStr,"^",1)
	..s VoiceRemoteIP=$P(VoiceStr,"^",5)
	..&SQL(Update DHC_VIS_VoiceMessage set VoiceState='Y',UpdateIP=:serverIP,UpdateDate=:VoicePlanDate,UpdateTime=:NowTime where VoiceID=:VoiceId)
	..s VoiceFileName="From"_$TR(serverIP,".")_"To"_$TR(VoiceRemoteIP,".")_"Id"_VoiceId_".wav"
	..s VoiceFile=FtpParm_"#"_VoiceFileName_"*"_VoiceContent
	..s UDPMessage=VoiceRemoteIP_"*msg=callnumber&url=http://"_FtpServerIP_FtpServerDir_VoiceFileName
	..s RetStr=VoiceFile_"^"_UDPMessage
	..
	q RetStr
}

}
