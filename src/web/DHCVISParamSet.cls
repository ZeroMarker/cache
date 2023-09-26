Class web.DHCVISParamSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod MethodUpdate(AreaRefresh As %String = "", Waiting As %String = "", TwoWaiter As %String = "", FtpServerIP As %String = "", FtpUser As %String = "", FtpPassword As %String = "", FtpVoice As %String = "", FtpLog As %String = "", FtpVoiceHeader As %String = "", FtpVoiceMessage As %String = "", Version As %String = "", UpdateAddress As %String = "", BloodVisit As %String = "", BloodWait As %String = "", VoiceRate As %String = "", NoticePop As %String = "", NamePrivacy As %String = "", VoiceCount As %String = "", VoiceSilence As %String = "", MaxshowNum As %String = "", ShowTime As %String = "", Broadcast As %String = "", BroadcastTime As %String = "", chkWaitPaitList As %String) As %String
{
	s ^DHCVISSet("AreaRefresh")=AreaRefresh
	s ^DHCVISSet("DHCVISWaiting")=Waiting
	s ^DHCVISSet("TwoWaiter")=TwoWaiter
	s ^DHCVISSet("Ftp","ServerIP")=FtpServerIP
	s ^DHCVISSet("Ftp","User")=FtpUser
	i FtpPassword'["*"	s ^DHCVISSet("Ftp","Password")=FtpPassword
	s ^DHCVISSet("Ftp","Voice")=FtpVoice
	s ^DHCVISSet("Ftp","Log")=FtpLog
	s ^DHCVISSet("Ftp","VoiceHeader")=FtpVoiceHeader
	s ^DHCVISSet("Ftp","VoiceMessage")=FtpVoiceMessage
	s ^DHCVISSet("Version")=Version
	s ^DHCVISSet("UpdateAddress")=$G(UpdateAddress)
	s ^DHCVISSet("Blood","Visit")=$G(BloodVisit)
	s ^DHCVISSet("Blood","Wait")=$G(BloodWait)
	s ^DHCVISSet("Voice","Rate")=$G(VoiceRate)
	s ^DHCVISSet("NoticePop")=$G(NoticePop)
	s ^DHCVISSet("NamePrivacy")=$G(NamePrivacy)
	s ^DHCVISSet("Voice","VoiceCount")=$G(VoiceCount)
	s ^DHCVISSet("Voice","VoiceSilence")=VoiceSilence
	s ^DHCVISSet("Voice","MaxshowNum")=MaxshowNum
	s ^DHCVISSet("Voice","ShowTime")=ShowTime
	s ^DHCVISSet("Broadcast")=$G(Broadcast)
	s ^DHCVISSet("Voice","BroadcastTime")=BroadcastTime
	s ^DHCVISSet("WaitPaitList")=chkWaitPaitList
	q 0
}

/// w ##class(web.DHCVISParamSet).GetMessege()
ClassMethod GetMessege() As %String
{
	s obj=##class(ext.util.JsonObject).%New()
	d obj.Put("AreaRefresh",$g(^DHCVISSet("AreaRefresh"))).Put("Waiting",$g(^DHCVISSet("DHCVISWaiting"))).Put("TwoWaiter",$g(^DHCVISSet("TwoWaiter")))
	d obj.Put("FtpServerIP",$g(^DHCVISSet("Ftp","ServerIP"))).Put("FtpUser",$g(^DHCVISSet("Ftp","User"))).Put("FtpPassword",$g(^DHCVISSet("Ftp","Password")))
	d obj.Put("FtpVoice",$g(^DHCVISSet("Ftp","Voice"))).Put("FtpLog",$g(^DHCVISSet("Ftp","Log"))).Put("FtpVoiceHeader",$g(^DHCVISSet("Ftp","VoiceHeader")))
	d obj.Put("FtpVoiceMessage",$g(^DHCVISSet("Ftp","VoiceMessage"))).Put("Version",$g(^DHCVISSet("Version"))).Put("UpdateAddress",$g(^DHCVISSet("UpdateAddress")))
	d obj.Put("BloodVisit",$g(^DHCVISSet("Blood","Visit"))).Put("BloodWait",$g(^DHCVISSet("Blood","Wait"))).Put("VoiceRate",$g(^DHCVISSet("Voice","Rate")))
	d obj.Put("NoticePop",$g(^DHCVISSet("NoticePop"))).Put("NamePrivacy",$g(^DHCVISSet("NamePrivacy"))).Put("VoiceCount",$g(^DHCVISSet("Voice","VoiceCount")))
	d obj.Put("VoiceSilence",$g(^DHCVISSet("Voice","VoiceSilence"))).Put("MaxshowNum",$g(^DHCVISSet("Voice","MaxshowNum"))).Put("ShowTime",$g(^DHCVISSet("Voice","ShowTime")))
	d obj.Put("Broadcast",$g(^DHCVISSet("Broadcast"))).Put("BroadcastTime",$g(^DHCVISSet("Voice","BroadcastTime"))).Put("WaitPaitList",$g(^DHCVISSet("WaitPaitList")))
	q obj.Json()
}

}
