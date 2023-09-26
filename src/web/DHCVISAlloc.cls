Import SQLUser

Class web.DHCVISAlloc Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetActiveFlag(UserId As %String = "", BorDr As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	&SQL(select BoruBorDr into :BoruBorDr from DHCBorUser where BoruUseDr=:UserId)
	i BorDr'="" s BoruBorDr=BorDr
	q:$G(BoruBorDr)="" "诊区未对应叫号服务"
	s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,""))
	q:serverId="" "诊区未对应叫号服务"
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	//q:serverActive'="Y" "服务器未激活"
	q 0
}

ClassMethod GetServerState(UserId As %String = "", BorDr As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	&SQL(select BoruBorDr into :BoruBorDr from DHCBorUser where BoruUseDr=:UserId)
	i BorDr'="" s BoruBorDr=BorDr
	q:$G(BoruBorDr)="" "诊区未对应叫号服务"
	s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,""))
	q:serverId="" "诊区未对应叫号服务"
	s serverActive=$P($G(^DHCVISServer(serverId)),"^",3)
	q:serverActive'="Y" "服务器未激活"
	q 0
}

ClassMethod UpdateServerState(UserId As %String = "", ServerSate As %String = "Y", BorDr As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	&SQL(select BoruBorDr into :BoruBorDr from DHCBorUser where BoruUseDr=:UserId)
	i BorDr'="" s BoruBorDr=BorDr
	q:$G(BoruBorDr)="" "诊区未对应叫号服务"
	s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,""))
	q:serverId="" "诊区未对应叫号服务"
	s serverId=""
	f  s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,serverId)) q:serverId=""  d
	.&SQL(update DHC_VIS_VoiceServer set VIS_ServerActive=:ServerSate where VIS_ServerID=:serverId)
	q 0
}

ClassMethod ChangeBroadContent(UserId As %String = "", BroadContent As %String = "", BorDr As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	&SQL(select BoruBorDr into :BoruBorDr from DHCBorUser where BoruUseDr=:UserId)
	i BorDr'="" s BoruBorDr=BorDr
	q:$G(BoruBorDr)="" "诊区未对应叫号服务"
	s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,""))
	q:serverId="" "诊区未对应叫号服务"
	s serverId=""
	f  s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,serverId)) q:serverId=""  d
	.s ^DHCVISSet("Broad",serverId)=BroadContent
	q "OK"
}

ClassMethod GetBroadContent(UserId As %String = "", BorDr As %String = "") As %String
{
	i UserId="" s UserId=%session.Get("LOGON.USERID")
	&SQL(select BoruBorDr into :BoruBorDr from DHCBorUser where BoruUseDr=:UserId)
	i BorDr'="" s BoruBorDr=BorDr
	q:$G(BoruBorDr)="" "诊区未对应叫号服务"
	s serverId=$O(^DHCVISServeri(0,"LinkBor",BoruBorDr,""))
	q:serverId="" "诊区未对应叫号服务"
	s BroadContent=$G(^DHCVISSet("Broad",serverId))
	q BroadContent
}

ClassMethod GetBeforeWaitNo(QueueID As %String) As %String
{
	s RetValue=""
	s QueObj=##Class(User.DHCQueue).%OpenId(QueueID)
	s EpisodeID=QueObj.QuePaadmDrGetObjectId()
	s LocID=QueObj.QueDepDrGetObjectId()
	s QueMarkDr=QueObj.QueMarkDrGetObjectId()
	q:QueMarkDr="" ""
	s UserID=$O(^SSU("SSUSR",0,"CTPCP",QueMarkDr,""),-1)
	i UserID="" d
	.s QueMarkDr=QueObj.QueDocDrGetObjectId()
	.q:QueMarkDr=""
	.s UserID=$O(^SSU("SSUSR",0,"CTPCP",QueMarkDr,""))
	i UserID="" d
	.s RetValue="请先指定医生!" 
    d QueObj.%Close()
    q:UserID="" RetValue
    s n=0
	s rset=##Class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	i rset.QueryIsValid() { 
		s Status=rset.Execute(LocID, UserID, "", "", "", "", "", "", "", "on")
		i 'Status q
		s columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ret=""
			s AdmID=rset.GetData(2)
		    i AdmID=EpisodeID  q
	        s n=n+1
		}
		d rset.Close()
	}
	q "前面等候人数:"_n_"人"
}

}
