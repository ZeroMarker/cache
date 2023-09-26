Class web.DHCOPRegTime Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod sickcall(ASRowId As %String, Time As %String, TRRowId As %String) As %String
{
	;w ##class(web.DHCOPRegTime).sickcall("12214||238","23:00","2")
	k ^guo("sickcall")
	s ^guo("sickcall")=ASRowId_"^"_Time_"^"_TRRowId
	    q:ASRowId=""
	    s ResRowId=$P(ASRowId,"||",1)
	    s ASChild=$P(ASRowId,"||",2)
	    s locrowid=$P($G(^RB("RES",ResRowId)),"^",1)
	    s docrowid=$P($G(^RB("RES",ResRowId)),"^",2)
		s time=..%ZTH(Time,1)
		s week=$zd(+$h,10)
		s nowtime=..%SysTime()
		if week=0 s week=7
		s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	    s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	    s ResRowId=""
	    Set ResRowId=$O(^RB("RES",0,"CTPCP",docrowid,locrowid,ResRowId))         
	    Set DateRowId=""
	    s Sess="",nowregPH="",nowregPHtmp="",rtn=""
	    s RBApptStr=$g(^RBAS(ResRowId,ASChild))
	    s RBApptStartTime=$p(RBApptStr,"^",4)
	    s RBApptEndTime=$p(RBApptStr,"^",5)
	    s RBApptLoad=$p(RBApptStr,"^",8)
 /*If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")||(Sess'="")  d
 .Set DoWeek=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
 .Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
 .If week'=DoWeek Quit 
 .Set Sess=SessRowId
 .;Set NoWeeks=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
 .S Load=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)       ;正号限额
 .s stime=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
 .s etime=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
 .;q:(stime>EndTime)
 */
 if (time>RBApptEndTime)  s rtn="超过医生就诊时间!"
 s regeveryone=(RBApptEndTime-RBApptStartTime)/RBApptLoad
 if regeveryone>300 s regeveryone=300    //如果医生看一个病人大于5分钟,则按5分钟计算诊号
 s nowregPH=(time-RBApptStartTime)/regeveryone
 s nowregPH=$fn(nowregPH,"",0)
 s nowregPH=..GetAvailSeqNoStr(ASRowId,nowregPH)
 if (nowregPH>RBApptLoad)||(nowregPH="") s rtn="已经大于本人限额!"
 
 q nowregPH_"^"_rtn
}

ClassMethod GetAvailSeqNoStr(ASRowId, SeqNo)
{
	//w ##class(web.DHCOPRegTime).GetAvailSeqNoStr("12214||238","11")
	s SingleQueueNo=""
	s ResRowId=$P(ASRowId,"||",1)
	s Childsub=$P(ASRowId,"||",2)
	;无此排班记录
	Q:'$d(^RBAS(ResRowId,Childsub)) "-1"
	s ASDate=$P(^RBAS(ResRowId,Childsub),"^",1)
	
	;取预约号信息
	s AppStartSeqNo=$P(^RBAS(ResRowId,Childsub),"^",10)
	;预约限额
	s APPSeqNoCount=$P(^RBAS(ResRowId,Childsub),"^",2)
	
	i AppStartSeqNo="" s AppStartSeqNo=0
	i APPSeqNoCount="" s AppStartSeqNo=0
	
	 s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	 ;正号串与加号串
	 s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	 s AddQueueNoStr=$P(ASQueueNo,$C(1),2)
	 
	Q:(NormalQueueNoStr="") ""
	s QueueNoStr=""
	for i=1:1:$l(NormalQueueNoStr,",") {
		 	s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 	s QueueNo=$P(SingleQueueNoStr,":",1)
		 	if ((QueueNo=SeqNo)&&((QueueNoStatus=0)||(QueueNoStatus=4))){
		 	s QueueNoStr=QueueNo
		 	Q
		 	}
		 	elseif((QueueNo>SeqNo)&&((QueueNoStatus=0)||(QueueNoStatus=4))){ 
				s QueueNoStr=QueueNo
				Q	
		 	}
		 	else{
		 		continue
		 	}

	 	}
	 q QueueNoStr
}

ClassMethod sicktime(ASRowId As %String, RegNo As %String, TRRowId As %String) As %String
{
	k ^guo
	s ^guo=ASRowId_"^"_RegNo_"^"_TRRowId
	    q:ASRowId=""
	    s exit="No"
	    s ResRowId=$P(ASRowId,"||",1)
	    s ASChild=$P(ASRowId,"||",2)
	    s locrowid=$P($G(^RB("RES",ResRowId)),"^",1)
	    s docrowid=$P($G(^RB("RES",ResRowId)),"^",2)
		s week=$zd(+$h,10)
		s SickTimetmpp=""
		s nowtime=..%SysTime()
		if week=0 s week=7
		s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	    s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	    s ResRowId=""
	    Set ResRowId=$O(^RB("RES",0,"CTPCP",docrowid,locrowid,ResRowId))         
	    Set DateRowId=""
	    s Sess="",nowregPH="",nowregPHtmp=""
      If ResRowId'="" Set DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
 Set SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:(SessRowId="")||(Sess'="")  d
 .Set DoWeek=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
 .Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
 .If week'=DoWeek Quit 
 .Set Sess=SessRowId
 .;Set NoWeeks=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
 .S Load=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)       ;正号限额
 .s stime=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
 .s etime=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
 .;q:(stime>EndTime)
 .s regeveryone=(EndTime-StartTime)/Load
 .s Sicktmp=$fn(regeveryone,"",0)
 .if $p(..%ZT($fn(regeveryone,"",0),2),":",2)>5 s Sicktmp=300
 .S SickTime=Sicktmp*(RegNo-1)
 .s SickTimetmp=StartTime+SickTime
 .s SickTimetmpp=..%ZT(SickTimetmp,2)

 
 q SickTimetmpp
}

ClassMethod GetPInfo(PatId As %String = "")
{
  s dob=$p($g(^PAPER(PatId,"ALL")),"^",6)
  s PAPERAge=$$CalAge^at182(dob,+$H,"","","")  
  s agery=$P(PAPERAge,"|",12)
  s SexDR=$p($g(^PAPER(PatId,"ALL")),"^",7)
  s PatSex=$p(^CT("SEX",SexDR),"^",2)
  s PatName=$p($g(^PAPER(PatId,"ALL")),"^",1)
  
  q PatName_"^"_PatSex_"^"_agery
}

ClassMethod GetdefineStartDate(UserID As %String = "")
{
	s ResRowId=0
	s maxDate=0
	f  s ResRowId=$o(^RB("RES",ResRowId)) q:ResRowId=""  d
	.s locID=$P(^RB("RES",ResRowId),"^",1)
	.s DocID=$P(^RB("RES",ResRowId),"^",2)
	.;q:(UserID'="")&&(('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_locID," "_DocID))))
	.;q:(UserID'="")&&(('##class(web.DHCUserGroup).UserCanDo(UserID,locID,DocID)))
	.q:(UserID'="")&&(('##class(web.DHCUserGroup).UserCanDo(UserID,locID)))
	.s ASDate=""
	.s ASDate=$o(^RBAS(ResRowId,0,"DateSTime",ASDate),-1)
	.if ASDate>maxDate d
	..s maxDate=ASDate
	s OldASDate=..%ZD(maxDate) //$zd(maxDate,4)
	q OldASDate
}

}
