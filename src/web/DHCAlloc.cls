Include webimport

IncludeGenerator webimport

Class web.DHCAlloc Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod FindCheckinStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserCode As %Library.String = "")
{
 s LogUserDr=0
 s LogUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(UserCode,"U"),LogUserDr))
 s BoruUseDr=$o(^User.DHCBorUserI("BoruUseDrIndex"," "_LogUserDr,0))
 s BorDr=""
 s Checkin=""
 if BoruUseDr'="" {
	 s BorDr=$List(^User.DHCBorUserD(BoruUseDr),2)
 s Checkin=$List(^User.DHCExaBoroughD(BorDr),6)
 }
 q Checkin
}

ClassMethod FindMarkDocDr(itmjs As %Library.String = "", itmjsex As %Library.String = "", QueID As %Library.String = "")
{
  s TimeRangeStr=##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime()
  &sql(select quedepdr,quemarkdr,QueStateDr,QuePaadmDr into :QueDepDr,:QueMarkDr,:QueStateDr,:QuePaadmDr from dhcqueue where ID=:QueID)
  k MarkDocListArr
  s json="["
  s PAADMAdmDocCodeDR=$p(^PAADM(QuePaadmDr),"^",9)
  s StatusPerName=$List(^User.DHCPerStateD(QueStateDr),4)
  s MarkDocId=0,myIdx=0
  for {
	  s MarkDocId=$o(^User.DHCMarkDocI("MarkddepDrIndex",QueDepDr,MarkDocId)) Q:MarkDocId=""
	  s MarkdDocDr=$lg(^User.DHCMarkDocD(MarkDocId),2)
	  s MarkdMarkDr=$lg(^User.DHCMarkDocD(MarkDocId),3)
	  continue:$d(MarkDocListArr(MarkdDocDr))
	  continue:(StatusPerName'="复诊")&&((MarkdMarkDr'=QueMarkDr)||('$$CheckRBAS(MarkdDocDr,QueDepDr)))
	  continue:(StatusPerName="复诊")&&((PAADMAdmDocCodeDR=MarkdDocDr)||('$$CheckRBAS(MarkdDocDr,QueDepDr)))
	  continue:'$d(^SSU("SSUSR",0,"CTPCP",MarkdDocDr))
	  s DocName=$p($g(^CTPCP(MarkdDocDr,1)),"^",2)
	  s MarkDocListArr(MarkdDocDr)=1
	  s WaitNum=$$FindWaitNum(MarkdDocDr,QueDepDr)
	  s desc=MarkdDocDr_"^"_DocName_"^"_WaitNum
	  if itmjs="GetMarkDocToHUIJson" {
		  s OneJsonData="{""text"":"""_$g(DocName)_""",""id"":"""_$g(MarkdDocDr)_""",""WaitNum"":"""_$g(WaitNum)_""""
		  s OneJsonData=OneJsonData_"}"
		  i myIdx=0 s json=json_OneJsonData
		  e  s json=json_","_OneJsonData
	  }else{
		  s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
		  &javascript<#(retval)#>
	  }
	  s myIdx=myIdx+1
  } 
  k MarkDocListArr	
	/*&sql(DECLARE EmpCursor2 CURSOR FOR
	 select ctpcp_desc,ctpcp_rowid1 into :DocName,:DocDr from dhcmarkdoc,ct_careprov
	 where markdmarkdr=:QueMarkDr and markddepdr=:QueDepDr 
	 and markddocdr=ctpcp_rowid1)
 s desc="N",myIdx=0
 s json="["
	&sql(OPEN EmpCursor2)
 for  &sql(FETCH EmpCursor2) QUIT:SQLCODE  do
 .Q:'$d(^SSU("SSUSR",0,"CTPCP",DocDr)) //过滤掉非实际用户
 .s desc=DocDr_"^"_DocName
 .i itmjs="GetMarkDocToHUIJson" d
 ..s OneJsonData="{""text"":"""_$g(DocName)_""",""id"":"""_$g(DocDr)_""""
 ..s OneJsonData=OneJsonData_"}"
 ..i myIdx=0 d
 ...s json=json_OneJsonData
 ..e  d
 ...s json=json_","_OneJsonData
 .e  d	
 ..s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 ..&javascript<#(retval)#>
 . s myIdx=myIdx+1
 &sql(CLOSE EmpCursor2)*/
 s json=json_"]"   
 i itmjs="GetMarkDocToHUIJson" {
	q json
 }
 q desc
CheckRBAS(MarkdDocDr,QueDepDr)
	s ResRowId=$O(^RB("RES",0,"CTPCP",MarkdDocDr,QueDepDr,0))
	Q:ResRowId="" 0
	s AvailAS=##class(web.DHCRBApptSchedule).GetAvailRA(ResRowId,+$h,"","","","N")
	Q:AvailAS="" 0
	s FindAvailASFlag=0
	for i=1:1:$l(AvailAS,"^") {
		s RBASRowId=$p(AvailAS,"^",i)
		s TRRowId=$P($G(^RBAS(ResRowId,$p(RBASRowId,"||",2),"DHC")),"^",17)
		continue:("!"_TimeRangeStr_"!")'[("!"_TRRowId_"!")
		s FindAvailASFlag=1
		Q
	}
	Q FindAvailASFlag
	
FindWaitNum(MarkdDocDr,QueDepDr)
	s WaitNum=0
	s QueRowId=0, Date=+$h For  {
		Set QueRowId=$O(^User.DHCQueueI("QueDateDeptIndex",Date,QueDepDr,QueRowId))
		Quit:QueRowId=""
		Set PAAdm=$lg(^User.DHCQueueD(QueRowId),11)
		Set QueDoc=$lg(^User.DHCQueueD(QueRowId),5)
		Set QueState=$lg(^User.DHCQueueD(QueRowId),14)
		Set:QueState'="" QueState=$lg(^User.DHCPerStateD(QueState),4)
		continue:(QueState'="等候")&&(QueState'="复诊")
		s DocAdmInclude=##class(web.DHCDocOutPatientList).CheckDocAdmInclude(PAAdm,MarkdDocDr)
		continue:(DocAdmInclude="N")
		s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
		continue:VisitStatus'="A"
		continue:(QueDoc'="")&&(QueDoc'=MarkdDocDr)
		s WaitNum=WaitNum+1
	}
	q WaitNum
}

/// w ##class(web.DHCAlloc).FindPatQueue("","","H108","","所有","","","","","9")
ClassMethod FindPatQueue(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserCode As %Library.String = "", CompName As %Library.String = "", QueryST As %Library.String = "", RoomDr As %Library.String = "", MarkDr As %Library.String = "", PatID As %Library.String = "", PapmiNo As %Library.String = "", Zone As %Library.String = "")
{
 k ^DHCQueue($j)
 s ^DHCQueue(0,"alloc")=0
 s ^tempscl("FindPatQueue")=UserCode_","_UserCode_","_CompName_","_QueryST_","_RoomDr_","_MarkDr_","_PatID_","_PapmiNo_","_Zone
 s QueueDate=..%SysDate()
 s LogUserDr=0
 s Initials=$ZCVT(UserCode,"U")
 s LogUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",Initials,LogUserDr))
 ;如果没有传入诊区ID,则默认获取此用户第一个诊区
 i Zone="" s Zone=..GetFirstExabID(Initials)
 ;没有找到可操作的诊区则退出
 if Zone="" Q "N"
 s BorDr=Zone
 
 ;状态
 s StateDesc=""
 s StateDr=""
 ;f  s StateDr=$o(^User.DHCPerStateD(StateDr)) q:((StateDr="")!(StateDesc=QueryST))  d 
 .;s StateDesc=$List(^User.DHCPerStateD(3),4)
 .;b
 .;q:(StateDesc'=QueryST)
 s Consultation=""
 if QueryST="会诊" {
	 s Consultation=QueryST
	 s QueryST="所有"
 }
 s desc="N"
 s QueDr=""
 f  s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr)) q:QueDr=""   d
 .s QuePersonId=$List(^User.DHCQueueD(QueDr),12)
 .q:(QuePersonId'=PapmiNo)&(PapmiNo'="")  ;xp add,2008-04-17      
 .s QueExaBor=$List(^User.DHCQueueD(QueDr),6)
 .q:(QueExaBor'=BorDr)&&(Consultation'="会诊")
 .s ConsultatFlage=$List(^User.DHCQueueD(QueDr),18) ;会诊标志
 .Q:(Consultation="会诊")&&(ConsultatFlage'="Y")  ;会诊标志用来过滤会诊病人
 .;按顺序取出
 .s PatNo=$List(^User.DHCQueueD(QueDr),12)
 .q:(PatID'=PatNo)&(PatID'="")
 .s PatName=$List(^User.DHCQueueD(QueDr),9)
 .s QueFirstDr=$List(^User.DHCQueueD(QueDr),7)
 .i QueFirstDr=""  d
 ..s FirstCode="02"
 ..s Prior="正常"
 .e  d
 ..s FirstCode=$List(^User.DHCFirstCodeD(QueFirstDr),2) 
 ..s Prior=$List(^User.DHCFirstCodeD(QueFirstDr),4)
 .s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
 .s status=$List(^User.DHCPerStateD(QueStateDr),4)
 .//q:(status'=QueryST)&(QueryST'="所有")
 .q:(status'=QueryST)&&(QueryST'="所有")&&((QueryST'="复诊与等候")||("复诊与等候"'[status))
 .s StatusCode=$List(^User.DHCPerStateD(QueStateDr),2)
 .s SeqNo=$List(^User.DHCQueueD(QueDr),10)
 .s QueRoomDr=$List(^User.DHCQueueD(QueDr),13)
 .s RoomName=""
 .i QueRoomDr'="" d 
 ..i ($d(^CTLOC(QueRoomDr))) s RoomName=$p(^CTLOC(QueRoomDr),"^",2)
 .i QueDr=""
 .q:(RoomDr'=RoomName)&(RoomDr'="") 
 .;**********;xp modify,2008-05-04 *************************
 .s DepmDepDr=""
 .s DepmMarkDr=""
 .i MarkDr'=""  d 
 ..s DepmDepDr=$List(^User.DHCDepMarkD(MarkDr),8)
 ..s DepmMarkDr=$List(^User.DHCDepMarkD(MarkDr),3)
 .s QueueDepDr=$List(^User.DHCQueueD(QueDr),4)
 .s QueueMarkDr=$List(^User.DHCQueueD(QueDr),8)
 .q:(DepmMarkDr'=QueueMarkDr)&(MarkDr'="")
 .q:(DepmDepDr'=QueueDepDr)&(MarkDr'="")
 .s MarkName=$List(^User.DHCQueueD(QueDr),8)
 .i MarkName'="" s MarkName=$p(^CTPCP(MarkName,1),"^",2)
 .;q:(MarkDr'=MarkName)&(MarkDr'="")
 .;**********;xp modify,2008-05-04 *************************
 .set PAAdm=$List(^User.DHCQueueD(QueDr),11)
 .SET mradmdr=$p(^PAADM(PAAdm),"^",61)
 .Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
 .set RegRangeTimeCode=""
 .if RegfeeDr'="" do
 ..set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
 ..i $g(RegRangeTimeDr)'="" d
 ...set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
 ...set RegRangeTimeCode=$p(^DHCTimeRange(RegRangeTimeDr),"^",1)
 ..set MarkName=MarkName_"("_$g(RegRangeTime)_")"
 .if RegRangeTimeCode="" s RegRangeTimeCode="99"
 .s DocName=$List(^User.DHCQueueD(QueDr),5)
 .s DeptDr=$List(^User.DHCQueueD(QueDr),4)
 .s QueID=QueDr
 .s doctemp=QueueDepDr_"^"_QueueMarkDr   ;xp modify,2008-05-04
 .;按号别排序,不同的号别可能名字相同,所以不能直接用号别的名字，应与科室结合作为判断
 .;s doctemp=MarkName   ;按号别排序
 .s ^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID)=PatNo_"^"_PatName_"^"_QueFirstDr_"^"_FirstCode_"^"_Prior_"^"_QueStateDr_"^"_status_"^"_StatusCode_"^"_SeqNo
 .s ^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID)=$g(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID))_"^"_QueRoomDr_"^"_RoomName_"^"_MarkName_"^"_DocName_"^"_Prior_"^"_DeptDr_"^"_QueID_"^"_PAAdm_"^"_mradmdr_"^"_ConsultatFlage

 s count=0
 s RegRangeTimeCode=""
 f  s RegRangeTimeCode=$o(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode)) q:RegRangeTimeCode=""  d
 .s doctemp=""
 .f  s doctemp=$o(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp)) q:doctemp=""  d
 ..s FirstCode="" 
 ..f  s FirstCode=$o(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode)) q:FirstCode=""  d 
 ...s StatusCode=""  
 ...f  s StatusCode=$o(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode)) q:StatusCode=""  d 
 ....s SeqNo=""
 ....f  s SeqNo=$o(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,SeqNo)) q:SeqNo=""  d 
 .....s QueID=""
 .....f  s QueID=$o(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,SeqNo,QueID)) q:QueID=""  d 
 ......s PatNo=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",1)
 ......s PatName=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",2)
 ......s QueFirstDr=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",3)
 ......s TFirstCode=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",4)
 ......s Prior=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",5)
 ......s QueStateDr=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",6)
 ......s status=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",7)
 ......s TStatusCode=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",8)
 ......s TSeqNo=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",9)
 ......s QueRoomDr=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",10)
 ......s RoomName=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",11)
 ......s MarkName=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",12)
 ......s DocName=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",13)
 ......s Prior=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",14)
 ......s DeptDr=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",15)
 ......s TQueID=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",16)
 ......s EpisodeID=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",17)
 ......S mradm=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",18)
 ......s ConsultatFlage=$p(^DHCQueue($j,"DHCAlloc",RegRangeTimeCode,doctemp,FirstCode,StatusCode,+SeqNo,QueID),"^",19)
 ......;判断?输出
 ......;i MarkName'="" s MarkName=$p(^CTPCP(MarkName,1),"^",2)
 ......i DocName'="" s DocName=$p(^CTPCP(DocName,1),"^",2)
 ......i DeptDr'="" d
 .......;s DeptDesc=$P($g(^CTLOC(DeptDr)),"^",43)
 .......;i DeptDesc="" s DeptDesc=$P($g(^CTLOC(DeptDr)),"^",2)
 .......s DeptDesc=$P($g(^CTLOC(DeptDr)),"^",2)
 .......s DeptDesc1=$P(DeptDesc,"-",2)
 .......i DeptDesc1'="" s DeptDesc=DeptDesc1
 ......s PapmiRowid=0  
 ......s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),PapmiRowid)) 
 ......s PatientID=PapmiRowid
 ......s PatName=$p(^PAPER(PapmiRowid,"ALL"),"^",1)
 ......s RBirth=+$p(^PAPER(PapmiRowid,"ALL"),"^",6)
 ......//s RBirth=$p(((+$H-RBirth)/365)+0.5,".")
 ......s RBirth=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PapmiRowid,EpisodeID)
 ......s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
 ......s RSex=$p($g(^CT("SEX",sexid)),"^",2) 
 ......i Prior="正常" s Prior=""
 ......set CardNo=""
 ......set CFRowid=0
 ......f  set CFRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiRowid,CFRowid)) quit:CFRowid=""  d
 .......s CardStatus=$p(^DHCCARD("CF",CFRowid),"^",10)
 .......i CardStatus'="N" set Rtn="1^该卡已作废" quit
 .......s CardNo=$p(^DHCCARD("CF",CFRowid),"^",2)
 ......s desc=CardNo_"^"_PatName_"^"_Prior_"^"_status_"^"_TSeqNo_"^"_RoomName_"^"_MarkName_"^"_DocName_"^"_TQueID_"^"_RBirth_"^"_RSex_"^"_DeptDesc_"^"_PatientID_"^"_EpisodeID_"^"_mradm_"^"_ConsultatFlage
 ......s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 ......&javascript<#(retval)#>
 ......s count=count+1
 ;k ^DHCQueue($j)
 s ^tempztwa("count")=count
 q count
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(%CSP.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod PatAdjDoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", QueID As %Library.String = "", AdjDocDr As %Library.String = "", Usercode As %Library.String = "", GroupID As %Library.String = "")
{
	/*s desc=0
	&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName='退号')
	&sql(update Dhcqueue set quedocdr=:AdjDocDr,operuserid=:Usercode
	 where Id=:QueID and QueStateDr<>:PersDr)
	s desc=desc+SQLCODE
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 &javascript<#(retval)#>
	
	q desc*/
	s desc=0
	&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName='退号')
	&sql(select ID into :StateID from dhcperstate where PersName='等候')
	&sql(select ID into :StateID1 from dhcperstate where PersName='报到')
	&sql(select ID into :StateID2 from dhcperstate where PersName='过号')
	s currentState="", QueDep=""
	&sql(select QueStateDr,QueDepDr into:currentState,:QueDep from Dhcqueue where Id=:QueID)
	s ExabInfo=##class(web.DHCOPAdmReg).GetExabInfo(QueDep,AdjDocDr)
    s ExabDr=$p(ExabInfo,"^",1)
	if (currentState=StateID1)!(currentState=StateID2){
		s AdmId=$lg(^User.DHCQueueD(QueID),11)
		s HospId=$P(##class(web.DHCOPAdmReg).GetCurrentHosp(AdmId,"","",""),"^",1)
	
		s OPAllocReport=+##class(web.DHCOPRegConfig).GetGroupConfig(HospId,GroupID,"OPAllocReport")
		s ErrMsg=""
		if currentState=StateID1 {
			s checkrtn=..CheckForReportRangeTime(AdmId,.ErrMsg)
			q:((checkrtn=1)&&(OPAllocReport=0)) ErrMsg_",不能进行报到!"
		}
		&sql(update Dhcqueue set quedocdr=:AdjDocDr,operuserid=:Usercode,questatedr=:StateID,QueExabDr=:ExabDr
	 where Id=:QueID)
	 	s Type="A"
		if (SQLCODE=0){
		s rtnstr=##class(web.DHCDocOutPatientList).InsertNewQueueNo(AdmId,Type)
		}
	 	
	}else{
		&sql(update Dhcqueue set quedocdr=:AdjDocDr,operuserid=:Usercode,QueExabDr=:ExabDr
	 where Id=:QueID and QueStateDr<>:PersDr)
	}
	
	s desc=desc+SQLCODE
	if (itmjs=""){
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	 	&javascript<#(retval)#>
 	}
	
	q desc
}

ClassMethod PatAgain(itmjs As %Library.String = "", itmjsex As %Library.String = "", QueID As %Library.String = "", UserID As %Library.String = "") As %Library.String
{
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	s DocName=$List(^User.DHCQueueD(QueID),5)
	if (status="退号")||(status="等候")||(DocName=""){
		s id=0,desc1=""
		for {
			s id=$o(^User.DHCPerStateD(id)) Q:id=""
			Q:(desc1'="")
			s persname=$List(^User.DHCPerStateD(id),4)
			s pershowsname=$List(^User.DHCPerStateD(id),6)
			if (pershowsname="") s pershowsname=persname
			if (persname="退号") s desc1=pershowsname
		}
		Q "未就诊或"_desc1_"记录不能进行复诊!"
	}
	
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s desc=0
	&sql(select ID into :RetrunPersDr from  SQLUser.DHCPerState where PersName='退号')
	s desc=desc+SQLCODE
	&sql(select ID into :FirstDr from SQLUser.DHCFirstCode where firstcname='正常')
	s desc=desc+SQLCODE
	&sql(select ID into :StateID from dhcperstate where PersName='复诊')
	s desc=desc+SQLCODE
	&sql(update Dhcqueue set questatedr=:StateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID,queFirstdr=:FirstDr,QueFirstReason=""
	 where Id=:QueID and QueStateDr<>:RetrunPersDr)
	s desc=desc+SQLCODE
	s ^DHCDocAgain(+$H,QueID)=..%SysTime()
	if (itmjs=""){
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 		&javascript<#(retval)#>
 	}
	
	q desc
}

ClassMethod PatArrive(itmjs As %Library.String = "", itmjsex As %Library.String = "", QueID As %Library.String = "", UserID As %Library.String = "", GroupID As %Library.String = "") As %Library.String
{
	q:QueID="" "无队列信息,不能进行报到!"
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	if ((status'="报到")&&(status'="过号")){
		s id=0,desc1="",desc2=""
		for {
			s id=$o(^User.DHCPerStateD(id)) Q:id=""
			Q:(desc1'="")&&(desc2'="")
			s persname=$List(^User.DHCPerStateD(id),4)
			s pershowsname=$List(^User.DHCPerStateD(id),6)
			if (pershowsname="") s pershowsname=persname
			if (persname="报到") s desc1=pershowsname
			if (persname="过号") s desc2=pershowsname
		}
		Q "非【"_desc1_"】或【"_desc2_"】状态的记录不能进行报到!"
	}
	s AdmId=$lg(^User.DHCQueueD(QueID),11)
	S RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmId,0))
	if RegfeeRowId'=""{
		s ASRowid=$LG(^User.DHCRegistrationFeeD(RegfeeRowId),18)
		if ASRowid'=""{
			s ASStatusID=$P($G(^RBAS(+ASRowid,$P(ASRowid,"||",2),"DHC")),"^",10)
			s ASStatusCode=$P($G(^DHCRBCASStatus(+ASStatusID)),"^",1)
			if ASStatusCode="TR"{
				s ASDR=$P($G(^RBAS(+ASRowid,$P(ASRowid,"||",2),"DHC")),"^",12)
				s ASStatusID=$P($G(^RBAS(+ASDR,+$P(ASDR,"||",2),"DHC")),"^",10)
				s ASStatusCode=$P($G(^DHCRBCASStatus(+ASStatusID)),"^",1)
			}
			Q:ASStatusCode="S" "医生已经停诊,不能报到"
		}
	}
	s HospId=$P(##class(web.DHCOPAdmReg).GetCurrentHosp(AdmId,"","",""),"^",1)
	s OPAllocReport=+##class(web.DHCOPRegConfig).GetGroupConfig(HospId,GroupID,"OPAllocReport")
	if (status="报到"){
		s ErrMsg=""
		s checkrtn=..CheckForReportRangeTime(AdmId,.ErrMsg)
		q:((checkrtn=1)&&(OPAllocReport=0)) ErrMsg_",不能进行报到!"
	}
	s Type="A"
	if status="过号" s Type="C"
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s desc=0
	&sql(select ID into :RetrunPersDr from  SQLUser.DHCPerState where PersName='退号')
	s desc=desc+SQLCODE
	&sql(select ID into :StateID from dhcperstate where PersName='等候')
	s desc=desc+SQLCODE
	&sql(update Dhcqueue set questatedr=:StateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID
	 where Id=:QueID and QueStateDr<>:RetrunPersDr)
	s desc=desc+SQLCODE
	if (desc=0){
		s rtnstr=##class(web.DHCDocOutPatientList).InsertNewQueueNo(AdmId,Type)
	}
	if (itmjs=""){
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 		&javascript<#(retval)#>
 	}
	
	q desc
}

ClassMethod PatPrior(itmjs As %Library.String = "", itmjsex As %Library.String = "", QueID As %Library.String = "", QueFirstReason As %Library.String = "", UserID As %Library.String = "", GroupID As %Library.String = "")
{
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s desc=0
	&sql(select ID into :PriorDr from dhcfirstcode where firstcName='优先')
	s desc=desc+SQLCODE
	&sql(select ID into :WaitStateID from dhcperstate where PersName='等候')
	s desc=desc+SQLCODE
	&sql(select ID into :PassStateID from dhcperstate where PersName='过号')
 	s desc=desc+SQLCODE
 	&sql(select ID into :CheckinStateID from dhcperstate where PersName='报到')
	&sql(select questatedr into :patStateDr from Dhcqueue  where Id=:QueID)
	s desc=desc+SQLCODE
	if (patStateDr=CheckinStateID) {
		s AdmId=$lg(^User.DHCQueueD(QueID),11)
		s HospId=$P(##class(web.DHCOPAdmReg).GetCurrentHosp(AdmId,"","",""),"^",1)
		s OPAllocReport=+##class(web.DHCOPRegConfig).GetGroupConfig(HospId,GroupID,"OPAllocReport")
		s checkrtn=..CheckForReportRangeTime(AdmId,.ErrMsg)
		Q:((checkrtn=1)&&(OPAllocReport=0)) ErrMsg_",不能进行报到!"
	    s rtn=..PatArrive(itmjs,itmjsex,QueID,UserID,GroupID)
	    Q:rtn'=0 rtn
	}
	i (patStateDr=PassStateID) {
		&sql(update Dhcqueue set queFirstdr=:PriorDr,questatedr=:WaitStateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID,QueFirstReason =:QueFirstReason where Id=:QueID)
	}else {
		&sql(update Dhcqueue set queFirstdr=:PriorDr,QueFirstReason=:QueFirstReason where Id=:QueID)
	}
	s desc=desc+SQLCODE
	if (itmjs=""){
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	q desc
}

/// creator:guorongyong
/// date:2010-08-16
/// desc:门诊会诊队列插入
ClassMethod ConsultationQueueInsert(Para As %String, ExpStr As %String = "") As %String
{
	;1 改变病人就诊科室和号别,再回原来科室时也需要在分诊护士处以会诊病人查找
	;2 插入队列表
	
	s ret=0
	s EpisodeID=$P(Para,"^",1)
	s RoomDr=$P(Para,"^",2)
	s QueueNo=$P(Para,"^",3)
	
	;s ConsultLocID=$p(ExpStr,"^",1)
	;s ConsultDocID=$p(ExpStr,"^",2)
	;s ConsultFlag=$p(ExpStr,"^",3)
	;s ConsultUserID=$p(ExpStr,"^",4)
	
	TSTART
	/*
	&SQL(Update SQLUSER.PA_ADM set PAADM_DepCode_DR=:DepRowId,PAADM_AdmDocCodeDR=:DocRowId where PAADM_RowID=:EpisodeID)
	s ret=SQLCODE
	if ret=0 {
		s Para=$p(Para,"^",1,3)
		s ret=##class(web.DHCOPAdmReg).QueueInsert(Para)
	}
	*/
	s ret=##class(web.DHCOPAdmReg).QueueInsert(Para,ExpStr)
	if ret=0 {
		TC
	}else{
		Tro
	}
	
	Q ret
}

/// creator:guorongyong
/// date:2010-08-16
/// desc:门诊会诊,通过用户得到诊区内的所有科室
ClassMethod GetBorDepListByUser(BorDr As %String) As %String
{
	s ret=""
	Q:BorDr="" ret
	/*Q:UserID="" ret
	s BoruUseDr=$o(^User.DHCBorUserI("BoruUseDrIndex"," "_UserID,0))
	s BorDr=""
	s Checkin=""
	if BoruUseDr'="" {
		s BorDr=$List(^User.DHCBorUserD(BoruUseDr),2)
		s Checkin=$List(^User.DHCExaBoroughD(BorDr),6)
	}*/
	if BorDr'="" {
		s BorDepRowid=0
		for {
			s BorDepRowid=$O(^User.DHCExaBorDepI("BordBorDrIndex",BorDr,BorDepRowid))
			Q:BorDepRowid=""
			s BordDepDr=$List(^User.DHCExaBorDepD(BorDepRowid),7)
			if BordDepDr="" continue
			s BordDepDesc=$P(^CTLOC(BordDepDr),"^",2)
			if ret="" s ret=BordDepDr_$C(1)_BordDepDesc
			else  s ret=ret_"^"_BordDepDr_$C(1)_BordDepDesc
		}
	}
	
	Q ret
}

/// creator:guorongyong
/// date:2010-08-16
/// desc:门诊会诊,通过用户得到诊区内的所有科室
ClassMethod GetConsultDocListByDepID(DepID As %String) As %String
{
	s ret=""
	Q:DepID="" ret
	s RowId=0 f  Set RowId=$o(^RB("RES",0,"CTLOC",DepID,RowId)) quit:RowId=""  d
	.s CTPCPRowId=$P(^RB("RES",RowId),"^",2)
	.;如果非医生则退出
	.Q:CTPCPRowId=""
	.;判断是否需要排班
	.s ScheSt=$p(^RB("RES",RowId),"^",6)
	.Q:(ScheSt'="Y")
	.s CTPCPDesc=$P(^CTPCP(CTPCPRowId,1),"^",2)
	.if ret="" s ret=CTPCPRowId_$C(1)_CTPCPDesc
	.else  s ret=ret_"^"_CTPCPRowId_$C(1)_CTPCPDesc
	
	Q ret
}

/// creator:guorongyong
/// date:2010-08-16
/// desc:获取此用户可操作的第一个诊区
ClassMethod GetFirstExabID(UserInitials As %String) As %String
{
	Q:UserInitials="" ""
	s FirstExabID=""
	s n=0
	Set RSObj=##Class(%ResultSet).%New("web.DHCAlloc:QueryExaborough")
	If RSObj.QueryIsValid() { 
		Set Status=RSObj.Execute(UserInitials)
		If 'Status Quit
		While (RSObj.Next()) {
		    s n=n+1
			s ResultExabArr(n)=RSObj.GetData(1)
	        
		}
		d RSObj.Close()
	}
	if n>0 {
		s FirstExabID=ResultExabArr(1)
	}
	
	Q FirstExabID
}

ClassMethod QueryExabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExabExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryExabExecute(ByRef qHandle As %Binary, UserId As %String, Zone As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s LogonHospId=%session.Get("LOGON.HOSPID")
	//挂号设置->排班诊室允许跨诊区
	s AllowOpenAllRoms=##class(web.DHCOPRegConfig).GetSpecConfigNode("AllowOpenAllRoms",LogonHospId)
	if (AllowOpenAllRoms=0) {
		s Initials=UserId
		if Initials="" Set qHandle=$lb(0,repid,0) Quit $$$OK
		s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Initials),0))
		;如果没有传入诊区ID,则默认获取此用户第一个诊区
		i Zone="" s Zone=..GetFirstExabID(Initials)
		;没有找到可操作的诊区则退出
		if Zone="" Set qHandle=$lb(0,repid,0) Quit $$$OK
		s IUserId=" "_UserId
		s BorUserId=0
		for {
			s BorUserId=$O(^User.DHCBorUserI("BoruUseDrIndex",IUserId,BorUserId))
			q:BorUserId=""
			s BoruBorDr=$List(^User.DHCBorUserD(BorUserId),2)
			continue:BoruBorDr=""
			continue:(Zone'="")&&(Zone'=BoruBorDr)
			s ExaRoomId=0
			for {
				s ExaRoomId=$o(^User.DHCBorExaRoomI("BordBorDrIndex",BoruBorDr,ExaRoomId))
				q:ExaRoomId=""
				s Obj=##class(User.DHCBorExaRoom).%OpenId(ExaRoomId)
				q:'$IsObject(Obj)
				s BorDr=Obj.BorDrGetObjectId()
				s BorExaRoomDr=Obj.BorExaRoomDr
				if BorExaRoomDr'="" {
					s BorExaRoomHopDr=$p($g(^CTLOC(BorExaRoomDr)),"^",22)
					continue:BorExaRoomHopDr'=LogonHospId
					s BorExaRoom=$p($g(^CTLOC(BorExaRoomDr)),"^",2)
					s LocDateFrom=$p($g(^CTLOC(BorExaRoomDr)),"^",25)
					continue:(LocDateFrom'="")&&(LocDateFrom>+$H)
					s LocDateTo=$p($g(^CTLOC(BorExaRoomDr)),"^",25)
					continue:(LocDateTo'="")&&(LocDateTo<=..%SysDate())
					continue:($P(^CTLOC(BorExaRoomDr),"^",14)'="Y")
					d OutputRowExab
				}
				d Obj.%Close()
			}
		}
	}else{
		s BorExaRoomDr=0
		for {
			s BorExaRoomDr=$o(^CTLOC(0,"LocType","OR",BorExaRoomDr)) q:BorExaRoomDr=""
			s BorExaRoomHopDr=$p($g(^CTLOC(BorExaRoomDr)),"^",22)
			continue:BorExaRoomHopDr'=LogonHospId
			s BorExaRoom=$p(^CTLOC(BorExaRoomDr),"^",2)
			s LocDateFrom=$p($g(^CTLOC(BorExaRoomDr)),"^",25)
			continue:(LocDateFrom'="")&&(LocDateFrom>+$H)
			s LocDateTo=$p($g(^CTLOC(BorExaRoomDr)),"^",25)
			continue:(LocDateTo'="")&&(LocDateTo<=..%SysDate())
			continue:($P(^CTLOC(BorExaRoomDr),"^",14)'="Y")
			d OutputRowExab
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowExab
	set Data=$lb(BorExaRoomDr,BorExaRoom)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryExabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExabExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {
		 Set AtEnd=1
		 Set Row=""
	 }Else{
	 	Set Row=^CacheTemp(repid,ind)
	 }
 	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

Query QueryExab(UserId, Zone) As %Query(CONTAINID = 0, ROWSPEC = "ID:%String,ExarName:%String")
{
}

ClassMethod QueryExaboroughClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExaboroughExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryExaboroughExecute(ByRef qHandle As %Binary, UserId As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Initials=UserId
	if Initials="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Initials),0))
	s IUserId=" "_UserId
	s BorUserId=0
	for {
		s BorUserId=$O(^User.DHCBorUserI("BoruUseDrIndex",IUserId,BorUserId))
		q:BorUserId=""
		s BoruBorDr=$List(^User.DHCBorUserD(BorUserId),2)
		s isDefault=$lg(^User.DHCBorUserD(BorUserId),4)
		if (isDefault'="Y"){
			s isDefault="false"
		}else{
			s isDefault="true"
		}
		continue:'$d(^User.DHCExaBoroughD(BoruBorDr))
		if BoruBorDr'="" {
			s ExabName=$List(^User.DHCExaBoroughD(BoruBorDr),5)
			s isReport=$Lg(^User.DHCExaBoroughD(BoruBorDr),7)
			s isFirst=$Lg(^User.DHCExaBoroughD(BoruBorDr),8)
			s HospitalDr=$Lg(^User.DHCExaBoroughD(BoruBorDr),13)
			continue:HospitalDr'=HospId
			d OutputRowExaborough
		}
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowExaborough
	set Data=$lb(BoruBorDr,ExabName,isDefault,isReport,isFirst)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod QueryExaboroughFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExaboroughExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {
		 Set AtEnd=1
		 Set Row=""
	 }Else{
	 	Set Row=^CacheTemp(repid,ind)
	 }
 	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

Query QueryExaborough(UserId, HospId As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "HIDDEN,exabname:%String,isDefault:%String,isReport:%String,isFirst:%String")
{
}

ClassMethod QueryRoomMarkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRoomMarkExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryRoomMarkExecute(ByRef qHandle As %Binary, UserId As %String, Zone As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Initials=UserId
	if Initials="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s UserId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Initials),0))
	;如果没有传入诊区ID,则默认获取此用户第一个诊区
	i Zone="" s Zone=..GetFirstExabID(Initials)
	;没有找到可操作的诊区则退出
	if Zone="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ID=0
	for {
		s ID=$O(^User.DHCDepMarkI("DepmBorDrIndex",Zone,ID))
		q:ID=""
		s DepmSign=$List(^User.DHCDepMarkD(ID),5)
		continue:DepmSign'="Y"
		s DepDesc="",DocDesc=""
		s DepDr=$List(^User.DHCDepMarkD(ID),8)
		i DepDr'="" s DepDesc=$p($G(^CTLOC(DepDr)),"^",2)
		s DepDesc=##class(web.DHCOPAdmReg).LocDescFormate(DepDesc) //$p(DepDesc,"-",$l(DepDesc,"-"))
		s DocDr=$List(^User.DHCDepMarkD(ID),3)
		I DocDr'="" s DocDesc=$p($G(^CTPCP(DocDr,1)),"^",2)
		continue:'$$checkRBAS(DepDr,DocDr)
		s rtn=..FindTodaydoc(DepDr,DocDr,Zone)  //判断号别今天是否在这个科室诊区出诊
		continue:rtn=0
		s Desc=DepDesc_" "_DocDesc
		d OutputQueryRoomMark
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputQueryRoomMark
	set Data=$lb(ID,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
checkRBAS(depid,markid)
   s RESRowId=$o(^RB("RES",0,"CTPCP",markid,depid,""))
   q:(RESRowId="") 0
   s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
   Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h) 0
   s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
   Q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate()) 0
   s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
   Q:(ScheduleRequired'="Y") 0
   s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
   Q:(CTPCPDR="") 0
   Q:'$D(^CTPCP(CTPCPDR,1)) 0
   s ActiveFlag=$P(^CTPCP(CTPCPDR,1),"^",9)
   Q:(ActiveFlag'="Y") 0
   Q 1
}

ClassMethod QueryRoomMarkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRoomMarkExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {
		 Set AtEnd=1
		 Set Row=""
	 }Else{
	 	Set Row=^CacheTemp(repid,ind)
	 }
 	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

Query QueryRoomMark(UserId, Zone) As %Query(CONTAINID = 1, ROWSPEC = "ID:%String,ctpcp_desc:%String")
{
}

ClassMethod CheckChangeMark(QueID As %Library.String = "")
{
	//  w ##class(web.DHCAlloc).CheckChangeMark(167640)
	s ^DHCXPTest("CheckChange")=QueID
	set changedepdr=""
	&sql(select QueExabDr,QueDepDr,QueMarkDr,QuePaadmDr,changedepdr,questatedr into 
	:QueExabDr,:QueDepDr,:QueMarkD,:AdmDr,:changedepdr,:questatedr
	from dhcqueue  where ID=:QueID)
	
	set persname=""
	&sql(select persname into :persname from dhcperstate
 	where id=:questatedr)
 	
	s DepmState=""
	&sql(select count(ID) into :Count from DHCDepMark
	where DepmBorDr=:QueExabDr and DepmDepDr=:QueDepDr and DepmmarkDr=:QueMarkD)
	//DepmState=2 表示需要二次分诊
	
	
	
	&sql( select count(ID)
 		from DHC_OPChgDepMarkSet
 		where DepSource=(select quedepdr from dhcqueue where id=:QueID)
 		and MarkSource=(select queMarkdr from dhcqueue where id=:QueID))
	
	q:(persname="报到") "E"
	q:(persname="退号") "F"
	s Retcode="A"
	b ;001
	i (changedepdr'="")  d
	.i ((persname="复诊")||(persname="到达")) s Retcode="D"   
	.e  s Retcode="C"	
	e  d 
	.i (Count>0) s Retcode="B"
 	q Retcode
}

ClassMethod Resume(QueID As %Library.String = "")
{
	//  w ##class(web.DHCAlloc).Resume(167640)
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	TS
	&sql(select ID into :StateID from dhcperstate
       where PersName='等候')
           
	&sql(select changedepdr,comm1,quepaadmdr into 
	:changedepdr,:changemarkdr,:QuePaadmdr
	from dhcqueue  where ID=:QueID)
	if (($g(changedepdr)'="")&($g(changemarkdr)'="")&($g(QuePaadmdr)'=""))  do
	.&sql(update dhcqueue set changedepdr=null,comm1=null,quedepdr=:changedepdr,quemarkdr=:changemarkdr,QueStateDr=:StateID,QueDocDr=null,QueCompDr=null,QueRoomDr=null,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID
	where  ID=:QueID)
	.&sql(update Pa_Adm set paadm_depcode_dr=:changedepdr,paadm_admdoccodedr=:changemarkdr
	 where Paadm_rowid=:QuePaadmdr)
	
	i 'SQLCODE  TC
	e  Tro
 	q SQLCODE
}

ClassMethod QueryExabBroker(JSFunName As %String = "", ListName As %String = "", UserId As %String, Zone As %String) As %String
{
	s myIdx=0
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCAlloc:QueryExab")
	do rset.Execute(UserId,Zone)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s BorExaRoomDr=rset.GetData(1)
		s BorExaRoom=rset.GetData(2)
		s mySelFlag=0
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(BorExaRoom),"O","JS")_"','"_$ZCVT($g(BorExaRoomDr),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
		s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
	}
	q 0
}

ClassMethod QueryRoomMarkBroker(JSFunName As %String = "", ListName As %String = "", UserId As %String, Zone As %String) As %String
{
	s myIdx=0
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCAlloc:QueryRoomMark")
	do rset.Execute(UserId,Zone)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s ID=rset.GetData(1)
		s Desc=rset.GetData(2) 
		s mySelFlag=0
		s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(Desc),"O","JS")_"','"_$ZCVT($g(ID),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
		s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
	}
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCAlloc","LookUpExaBorough","te")
Query LookUpExaBorough(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "RowId:%String,Desc:%String")
{
	select ID,ExabName from DHCExaBorough
}

Query FindWeek() As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod FindWeekExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PALocAmount","FindWeek")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ID=0
   	for {
		s ID=$O(^CT("DOW",1,ID))
		q:ID=""
		s Desc=$P(^CT("DOW",1,ID),"^",1)
		s RowId=$P(^CT("DOW",1,ID),"^",2)
		Do OutputRowFindWeek
		
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindWeek
	set Data=$lb($g(RowId),$g(Desc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindWeekClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWeekExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWeekFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWeekExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ///--------------------------
Query FindWeekResource(WeekDay As %String, ExaBorough As %String, ScheduleLinesId As %String, DocMark As %String = "", HospID As %String = "") As %Query(ROWSPEC = "RowId:%String,LocDesc:%String,DocDesc:%String,TRDesc:%String,SessionType:%String,DOWDayDesc:%String")
{
}

ClassMethod FindWeekResourceExecute(ByRef qHandle As %Binary, WeekDay As %String, ExaBorough As %String, ScheduleLinesId As %String, DocMark As %String = "", HospID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCAlloc","FindWeekResource","","","","",9)
	s ^tempscl("FindWeekResource")=WeekDay_","_ExaBorough_","_ScheduleLinesId_","_DocMark_","_HospID
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (ScheduleLinesId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 
	}
	if (HospID="") s HospID=%session.Get("LOGON.HOSPID")
	k DeptArr
	s ExaBorID=0
	s ExaBoroughID=ExaBorough
	if ExaBoroughID'=""{
		for {
			s ExaBorID=$O(^User.DHCExaBorDepI("BordBorDrIndex",ExaBoroughID,ExaBorID))
			q:ExaBorID=""
			s DeptID=$List(^User.DHCExaBorDepD(ExaBorID),7)
			q:DeptID=""
			s DeptArr(DeptID)=""
		}
	}else{
		/*s ExaBoroughID=0
		for {
			s ExaBoroughID=$O(^User.DHCExaBorDepI("BordBorDrIndex",ExaBoroughID))
			Q:ExaBoroughID=""
			for {
				s ExaBorID=$O(^User.DHCExaBorDepI("BordBorDrIndex",ExaBoroughID,ExaBorID))
				q:ExaBorID=""
				s DeptID=$List(^User.DHCExaBorDepD(ExaBorID),7)
				q:DeptID=""
				s DeptArr(DeptID)=""
			}
		}*/
		s AdmTypeStr="O^E"
		for i=1:1:$l(AdmTypeStr,"^"){
			s AdmType=$p(AdmTypeStr,"^",i)
			s myrowid=0
			for  {
				s myrowid=$o(^PAC("ADMLOC",0,"AdmType",AdmType,myrowid)) Q:myrowid=""
				s DeptArr(myrowid)=""
			}
		}
	}
	s DeptID=0
	for {
		s DeptID=$O(DeptArr(DeptID))
		q:DeptID=""
		continue:'$d(^CTLOC(DeptID))
		s LocHpspDr=$p(^CTLOC(DeptID),"^",22)
		continue:LocHpspDr'=HospID
		s DeptDesc=$P(^CTLOC(DeptID),"^",2)
		s ResRowId=0
		for {
			s ResRowId=$O(^RB("RES",0,"CTLOC",DeptID,ResRowId))
			q:ResRowId=""
			s RESDateActiveFrom=$p($g(^RB("RES",ResRowId)),"^",22)
			s RESDateActiveTo=$p($g(^RB("RES",ResRowId)),"^",23)
			s RESScheduleRequired=$p($g(^RB("RES",ResRowId)),"^",6)
			continue:$g(RESScheduleRequired)="N"
			continue:(RESDateActiveFrom'="")&&(RESDateActiveFrom>+$h)
			continue:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h)
			s CTPCPDr=$P(^RB("RES",ResRowId),"^",2)
			continue:(CTPCPDr="")!((DocMark'=CTPCPDr)&&(DocMark'=""))
			continue:'($d(^CTPCP(CTPCPDr,1)))
			continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CarePrv",CTPCPDr,HospID)
			s CTPCPDesc=$P(^CTPCP(CTPCPDr,1),"^",2)
			//s DATEChildsub=$O(^RB("RES",ResRowId,"DATE",""),-1)
			if (ScheduleLinesId'=""){
				continue:'$d(^RB("RES",ResRowId,"DATE",0,"RSL",ScheduleLinesId))
				s DATEChildsub=$O(^RB("RES",ResRowId,"DATE",0,"RSL",ScheduleLinesId,""),-1)
			}
			continue:DATEChildsub=""
			s SESSChildsub=0
			for {
				s SESSChildsub=$o(^RB("RES",ResRowId,"DATE",DATEChildsub,"SESS",SESSChildsub))
				q:SESSChildsub=""
				s DOWDayDr=$P(^RB("RES",ResRowId,"DATE",DATEChildsub,"SESS",SESSChildsub),"^",2)
				continue:DOWDayDr=""
				s DOWDay=$P(^CT("DOW",1,DOWDayDr),"^",2)
				continue:(DOWDay'=WeekDay)&&(WeekDay'="")
				s DOWDayDesc=$P(^CT("DOW",1,DOWDayDr),"^",1)
				s ResDateRess=ResRowId_"||"_DATEChildsub_"||"_SESSChildsub
				s TRRowId=$p(^RB("RES",ResRowId,"DATE",DATEChildsub,"SESS",SESSChildsub),"^",3)
				if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
				e  s TRDesc="其他"
				s SessionTypeDr=$p(^RB("RES",ResRowId,"DATE",DATEChildsub,"SESS",SESSChildsub),"^",9)
				s SessionType=$p($g(^RBC("SESS",SessionTypeDr)),"^",2)
				d OutPutWeekResource
			}
			//s ^RB("RES",{RB_Resource.RES_RowId},"DATE",{RB_ResEffDate.DATE_Childsub},"SESS",{SESS_Childsub})
		}
		
		
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutWeekResource
	set Data=$lb($g(ResDateRess),$g(DeptDesc),CTPCPDesc,TRDesc,SessionType,DOWDayDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindWeekResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWeekResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWeekResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWeekResourceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCAlloc).GetExaboroughDocinfo(12177,"",1,2)
ClassMethod GetExaboroughDocinfo(Userid As %String = "", Locid As %String = "", BorUserId As %String = "", LogonHospId As %String = "")
{
	;s Initials=Userid
	;s Userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Initials),0))
	s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
	s IUserId=" "_Userid
	i BorUserId=""  d
	.s BorUserId=$O(^User.DHCBorUserI("BoruUseDrIndex",IUserId,BorUserId))
	.q:BorUserId=""
	.s BorUserIddr=$list(^User.DHCBorUserD(BorUserId),2)
	e  s BorUserIddr=BorUserId
	q:BorUserId="" "" //操作员诊区对照表ID
	// BorUserIddr诊区
	s BorExaRoomid =0
	s Runt=""
	s ID=""
	s Initials=$p($g(^SSU("SSUSR",Userid)),"^",1)
	k ExaboroughDocArr
	//s Zone=..GetFirstExabID(Initials)
	s AvailSeqNoStr=0
	s TempDep=""
	for{
		//分诊区科室对照
		s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",BorUserIddr,ID)) //Zone
		q:ID=""
		s DepID=$List(^User.DHCExaBorDepD(ID),7)
		continue:DepID=""
		s DetHospDr=$p($g(^CTLOC(DepID)),"^",22)
		continue:(DetHospDr'=LogonHospId)
		i TempDep="" s TempDep="^"_DepID_"^"
		e  s TempDep=TempDep_"^"_DepID_"^"
	}
	for{
		//分诊区诊室对照
		s BorExaRoomid=$o(^User.DHCBorExaRoomI("BordBorDrIndex",BorUserIddr,BorExaRoomid))
		q:BorExaRoomid=""
		s RoomDr=$list(^User.DHCBorExaRoomD(BorExaRoomid),6)
		continue:RoomDr=""
		s RoomDesc=$p($g(^CTLOC(RoomDr)),"^",2)
		s DetHospDr=$p($g(^CTLOC(RoomDr)),"^",22)
		continue:(DetHospDr'=LogonHospId)
		s RoomCompid=0
		for {
			//诊室计算机设置
			s RoomCompid=$o(^User.DHCRoomCompD(RoomCompid))
			q:RoomCompid=""
			s RoomDr1=$list(^User.DHCRoomCompD(RoomCompid),5)
			if RoomDr1'=RoomDr continue 
			s CompIP=$list(^User.DHCRoomCompD(RoomCompid),3) //IP地址
			s obj=..GetIPUser(CompIP) //得到登录CompIP的用户ID^科室ID
			continue:obj=""
			s loc2=""
			s loc2=$p(obj,"^",2)
			s LOGGroupDR=$p(obj,"^",3)
			s locChange="^"_loc2_"^"
			continue:TempDep'[locChange
			s obj=$p(obj,"^",1)
			if obj'="" {
				s UserIddr=$p(obj,"^",1)
				continue:($D(ExaboroughDocArr(+loc2,+UserIddr)))
				s ExaboroughDocArr(+loc2,+UserIddr)=""
				//LocDesc_"^"_DocDesc_"^"_UnArrived_"^"_AgianArrived_"^"_Arrived_"^"_Unreport_"^"_PerPared_"^"_DocId_"^"_Locid_"^"_Arrived1
				s rtn=..GetUseridArrived(UserIddr,loc2,TempDep) 
				s AvailSeqNoStr=..GetAvailSeqNoStr(loc2,UserIddr)
				s LocDesc=""
				if Locid'="" s LocDesc=##class(web.DHCOPAdmReg).LocDescFormate($p(^CTLOC(Locid),"^",2)) //$p($p(^CTLOC(Locid),"^",2),"-",2)
				//if (LocDesc'="") s LocDesc=$e(LocDesc,1,8)
				if rtn=""{
					Set DocId=$p($g(^SSU("SSUSR",UserIddr)),"^",14)
					continue:DocId=""
					s CTPCPCarPrvTpDR = $p(^CTPCP(DocId,1),"^",4)
					if (CTPCPCarPrvTpDR'="") {
						s CTCPTInternalType = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
						continue:CTCPTInternalType'="DOCTOR"
					}
					s ID=""
					s Initials=$p($g(^SSU("SSUSR",Userid)),"^",1)
					//s Zone=..GetFirstExabID(Initials)
					for{
						s ID=$O(^User.DHCDepMarkI("DepmBorDrIndex",BorUserIddr,ID)) //Zone
						q:ID=""
						s DepDesc="",DocDesc=""
						s DepDr=$List(^User.DHCDepMarkD(ID),8)
						i DepDr'="" s DepDesc=$p($G(^CTLOC(DepDr)),"^",2)
						s DepDesc=##class(web.DHCOPAdmReg).LocDescFormate(DepDesc) //$p(DepDesc,"-",$l(DepDesc,"-"))
						s DocDr=$List(^User.DHCDepMarkD(ID),3)
						q:DocId=""
						continue:(DocId'="")&&(DocId'=DocDr)
						s DocDesc=$P($g(^CTPCP(DocDr,1)),"^",2)
						//if (DepDesc'="") s DepDesc=$e(DepDesc,1,8)
						s rtn=DepDesc_"^"_DocDesc_"^"_0_"^"_0_"^"_"^"_0_"^"_"^"_DocId_"^"_DepDr_"^"_0
					}
				}
				if (RoomDesc'="") s RoomDesc=$e(RoomDesc,1,8)
				if (rtn'=""){
					s OneRunt=RoomDesc_"^"_rtn_"^"_CompIP_"^"_AvailSeqNoStr_"^"_LOGGroupDR
					if (LocDesc'=""){
						if $p(rtn,"^",1)=LocDesc{
							if (Runt=""){
								s Runt=OneRunt
							}else{
								s Runt=Runt_"!"_OneRunt
							}
						}
					}else{
					    if (Runt=""){
						    s Runt=OneRunt
					    }else{
						    s Runt=Runt_"!"_OneRunt
						}
					}
				}		
				
			}
		}
	}
	q Runt
}

/// 根据计算机得到用户id\科室id\安全组ID
/// w ##class(web.DHCAlloc).GetIPUser("TYQ-05")
ClassMethod GetIPUser(IP)
{
	q:IP="" ""
	s DHCrowid=""
	s Userdr=""
	s rtn=""
	s IP=$ZCVT(IP,"U")
	;通过计算名查找对应登陆IP;从后向前查找,直接过滤不是今天
	s i=0
	f { 
		s DHCrowid=$o(^SST("LOG",DHCrowid),-1)
		q:DHCrowid=""  
		q:Userdr'=""
		//User.DHCClientLogin
		s IPdr=$p($g(^SST("LOG",DHCrowid,"ADDR")),"^",1) //$p($g(^SST("LOG",DHCrowid,"ADDR")),"^",4)
		s IPdr=$ZCVT(IPdr,"U")
		s date=$p(^SST("LOG",DHCrowid),"^",3)
		q:+date'=..%SysDate()
		continue:IPdr'=IP
		//User.SSUserLogin
		s LOGGroupDR=$p(^SST("LOG",DHCrowid),"^",10)

		s date1=$p(^SST("LOG",DHCrowid),"^",6)
		i date1="" {
			s Userdr=$p(^SST("LOG",DHCrowid),"^",1)
			s rtn=Userdr_"^"_$p($g(^SST("LOG",DHCrowid)),"^",7)_"^"_LOGGroupDR
		}else{
			s Userdr=$p(^SST("LOG",DHCrowid),"^",1)
		}
		
		q:Userdr'=""
		q:rtn'=""
	}
	q rtn
	/*.q:Userdr'=""
	.s date=$p(^SST("LOG",DHCrowid),"^",3)
	.q:+date'=..%SysDate()
	.s date1=$p(^SST("LOG",DHCrowid),"^",6)
	.q:date1'=""
	.s IPdr=$p(^SST("LOG",DHCrowid,"ADDR"),"^",4)
	.q:IPdr'=IP
	.b ;0909
	.s Userdr=$p(^SST("LOG",DHCrowid),"^",1)
	*/
	
	//q Userdr
	/*q:IP="" ""
	s Userdr=""
	s ipuserstr=##class(User.DHCClientLogin).GetUserByClient(IP)
	if (ipuserstr'=""){
		s ipuserstr=$p(ipuserstr,"$",1)
		//取第一个？ 如果一台电脑存在多个在线用户  是否检测错误
		s Userdr=$p(ipuserstr,"^",1)
	}*/
	//q Userdr
}

/// 得到已就诊人数
/// /w ##class(web.DHCAlloc).GetUseridArrived(599,63,"^52^^49^^63^^50^^54^^67^^55^^56^^47^^62^^^^^^106^^87^^444^^445^^428^")
ClassMethod GetUseridArrived(Userid As %String = "", Locid As %String = "", TempDep As %String = "") As %String
{
	s ^temp("GetUseridArrived")=Userid_","_Locid_","_TempDep
	if (Locid'="") {
		s LocHospDr=$p(^CTLOC(Locid),"^",22)
	}
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId($g(LocHospDr))
	q:Userid="" ""
	s rtn=""
	s UnArrived=0
	s Arrived=0
	s Arrived1=0
	s AgianArrived=0
	s Unreport=0
	Set DocId=$p($g(^SSU("SSUSR",Userid)),"^",14)
	q:DocId="" ""
	s CTPCPCarPrvTpDR = $p(^CTPCP(DocId,1),"^",4)
	if (CTPCPCarPrvTpDR'="") {
		s CTCPTInternalType = $p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
		Q:CTCPTInternalType'="DOCTOR" ""
	}
	s QueDepDr=""
	s LocDesc=""
	s Sessiontype2=""
	s AvailSeqNoStr=0
	set QueDr=0
	For  Set QueDr=$O(^User.DHCQueueI("QueMarkDrIndex",+$h,DocId,QueDr)) Quit:QueDr=""  Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	.s QueDate=QueObj.QueDate
	.Set QueMark=QueObj.QueMarkDrGetObjectId()
	.s QueDocDr=QueObj.QueDocDrGetObjectId()
	.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	.Set AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAAdm)
	.Q:AdmHospitalId'=HospID
	.Set QueStatus=QueObj.QueStateDr.PersName
	.Set QueStaShowName=QueObj.QueStateDr.PersShowName
	.s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	.quit:VisitStatus'="A"
	.s Admi=PAAdm
	.s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,0))
	.s obj=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	.s SessionTypeDr="",RBASDr=""
	.if $IsObject(obj.RegfeeSessionTypeDr) s SessionTypeDr=obj.RegfeeSessionTypeDr.%Id()
	.if $IsObject(obj.RegfeeRBASDr) s RBASDr=obj.RegfeeRBASDr.%Id()
	.;s AvailNorSeqNoCount="" //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(RBASDr,"NOR","Y")
	.i SessionTypeDr'="" s Sessiontype2=$P(^RBC("SESS",SessionTypeDr),"^",2)
	.s QueDepDr=QueObj.QueDepDrGetObjectId()
	
	.i QueStatus="等候" s UnArrived=UnArrived+1
	.i (QueStatus="复诊")||(QueStaShowName="回诊") s AgianArrived=AgianArrived+1
	.i QueStatus="到达" s Arrived1=Arrived1+1
	.i QueStatus="过号" s UnArrived=UnArrived+1
	.i QueStatus="报到" s Unreport=Unreport+1 
	
	s DocDesc=$P($g(^CTPCP(DocId,1)),"^",2)
	s QueDr=0
	For  Set QueDr=$O(^User.DHCQueueI("QueDocDrIndex",DocId,QueDr)) Quit:QueDr=""  Do
	.Set QueObj=##Class(User.DHCQueue).%OpenId(QueDr)
	.s QueDate=QueObj.QueDate
	.q:QueDate'=..%SysDate()
	.Set QueMark=QueObj.QueMarkDrGetObjectId()
	.s QueDocDr=QueObj.QueDocDrGetObjectId()
	.q:QueMark=QueDocDr
	.Set PAAdm=QueObj.QuePaadmDrGetObjectId()
	.Set QueStatus=QueObj.QueStateDr.PersName
	.s VisitStatus=$p($g(^PAADM(PAAdm)),"^",20)
	.;s Admi=PAAdm
	.;s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,0))
	.;s obj=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	.;s RBASDr=obj.RegfeeRBASDr.%Id()
	.;s AvailNorSeqNoCount="" //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(RBASDr,"NOR","Y")
	.quit:VisitStatus'="A"
	.s QueDepDr=QueObj.QueDepDrGetObjectId()
	.i QueStatus="等候" s UnArrived=UnArrived+1
	.i QueStatus="回诊" s AgianArrived=AgianArrived+1
	.i QueStatus="到达" s Arrived1=Arrived1+1
	.i QueStatus="过号" s UnArrived=UnArrived+1
	.i QueStatus="报到" s Unreport=Unreport+1 
	
	i QueDepDr'="" d
	.i Locid="" d
	..i ((TempDep'="")&&(TempDep[QueDepDr)) s Locid=QueDepDr
	i Locid'="" s LocDesc=##class(web.DHCOPAdmReg).LocDescFormate($p(^CTLOC(Locid),"^",2))  //$p($p(^CTLOC(Locid),"^",2),"-",2)
	i Locid'=""  d
	.s Sessiontype=..GetOneDocTypeSession(Locid,DocId)
	.;s AvailSeqNoStr=..GetAvailSeqNoStr(Locid,DocId)
	.i ((Sessiontype2="")&&(Sessiontype'="")) s DocDesc=DocDesc_"("_Sessiontype_")"
	.i Sessiontype2'="" s DocDesc=DocDesc_"("_Sessiontype2_")"
	//if (LocDesc'="") s LocDesc=$e(LocDesc,1,8)
	s Arrived=""
	s PerPared=""
	if Locid'="" d
	.s rtn=..FindFirstandLastPaerson(Userid,Locid)
	.s PerPared=""
	.s Arrived=$p(rtn,"^",1)
	.i rtn["^" s PerPared=$p(rtn,"^",2)
	i Locid=""  s rtn=""
	e  s rtn=LocDesc_"^"_DocDesc_"^"_UnArrived_"^"_AgianArrived_"^"_Arrived_"^"_Unreport_"^"_PerPared_"^"_DocId_"^"_Locid_"^"_Arrived1   //_"^"_AvailSeqNoStr
	
	q rtn
}

// LocID As %String, UserID As %String, IPAddress As %String, AllPatient As %String, 

// PatientNo As %String, SurName As %String, StartDate As %Date, EndDate As %Date, ArrivedQue As %String, 

// RegQue As %String, Consultation As %String = "", MarkID As %String = "", CheckName As %String = ""

// w ##class(web.DHCAlloc).FindFirstandLastPaerson(600,63)

ClassMethod FindFirstandLastPaerson(UserID, locid)
{
	s lSeqNo="",Lastname="",fSeqNo="",firstname=""
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(locid , UserID , "" , "", "" , "" , "" , "", "", "", "", "", "RegQue")
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		//未就诊数量不包含说明记录
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		//未就诊数量不包含已到达、完成就诊
		s PatWalkStatus=rs.GetDataByName("WalkStatus")
		continue:PatWalkStatus="到达"
		s fSeqNo=rs.GetDataByName("LocSeqNo")
		s firstname=rs.GetDataByName("PAPMIName")
		Q:firstname'=""
	}
	d rs.Close()
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCDocOutPatientList"
	set rs.QueryName="FindLocDocCurrentAdm"
	set sc=rs.Execute(locid , UserID , "" , "", "" , "" , "" , "", "", "", "", "", "ArrivedQue")
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		//未就诊数量不包含说明记录
		s PatEpisodeID=rs.GetDataByName("EpisodeID")
		continue:PatEpisodeID=""
		//未就诊数量不包含已到达、完成就诊
		s PatWalkStatus=rs.GetDataByName("WalkStatus")
		continue:PatWalkStatus'="到达"
		s lSeqNo=rs.GetDataByName("LocSeqNo")
		s Lastname=rs.GetDataByName("PAPMIName")
		Q:Lastname'=""
	}
	d rs.Close()
	i lSeqNo'="" s lSeqNo=lSeqNo_"号"
	i fSeqNo'="" s fSeqNo=fSeqNo_"号"
	q lSeqNo_Lastname_"^"_fSeqNo_firstname
	/*Set rset=##Class(%ResultSet).%New("web.DHCDocOutPatientList.Findadmquery")
	set firstname=""
	s fSeqNo=""
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(locid,UserID,"等候")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			continue:firstname'=""
			s firstname=rset.Data("PatName")
			s fSeqNo=rset.Data("SeqNum")
			;s fSeqNo="("_fSeqNo_")"
			}
	}
	Set rset=##Class(%ResultSet).%New("web.DHCDocOutPatientList.Findadmquery")
	set Lastname=""
	s lSeqNo=""
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(locid,UserID,"到达")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			//continue:firstname'=""
			s Lastname=rset.Data("PatName")
			s lSeqNo=rset.Data("SeqNum")
			;s lSeqNo="("_lSeqNo_")"
			}
	}*/
}

// 获得一个医生今天专科号的职称，如果没有默认设置的值

ClassMethod GetOneDocTypeSession(Locid As %String = "", DocId As %String = "") As %String
{
	s ^zyl("GetOneDocTypeSession")=Locid_"**"_DocId
	q:Locid="" ""
	q:DocId="" ""
	s resrowid=""  
	s resrowid=$o(^RB("RES",0,"CTPCP",DocId,Locid,resrowid))
	s SessionDesc=""
	i resrowid'=""  d
	.s SessTime=""  f  s SessTime=$o(^RBAS(resrowid,0,"DateSTime",+$h,SessTime)) q:SessTime=""  d
	..s ASChird=""  f  s ASChird=$o(^RBAS(resrowid,0,"DateSTime",+$h,SessTime,ASChird)) q:ASChird=""  d
	...s Sessiontype=$p(^RBAS(resrowid,ASChird),"^",14)
	...i Sessiontype'=""  s SessionDesc=$p(^RBC("SESS",Sessiontype),"^",2)
	i ((SessionDesc="")&&(resrowid'=""))  d
	.s Sessiontype=$p($G(^RB("RES",resrowid,"DHC")),"^",1)
	.i Sessiontype'=""  s SessionDesc=$p(^RBC("SESS",Sessiontype),"^",2)
	q SessionDesc
}

/// w ##class(web.DHCAlloc).GetAvailSeqNoStr("63","600")
ClassMethod GetAvailSeqNoStr(Locid, UserId)
{
	s ^temp("GetAvailSeqNoStr")=Locid_","_UserId
	q:Locid="" ""
	q:UserId="" ""
	s TimeRangeRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime(..%SysTime())
	Set DocId=$p($g(^SSU("SSUSR",UserId)),"^",14)
	q:DocId="" ""
	s resrowid=0  
	s AvailSeqNoStr=0
	s resrowid=$o(^RB("RES",0,"CTPCP",DocId,Locid,resrowid))
	i resrowid'=""  d
	.s SessTime=""  f  s SessTime=$o(^RBAS(resrowid,0,"DateSTime",+$h,SessTime)) q:SessTime=""  d
	..s ASChird=""  f  s ASChird=$o(^RBAS(resrowid,0,"DateSTime",+$h,SessTime,ASChird)) q:ASChird=""  d
	...s Sessiontype=$p(^RBAS(resrowid,ASChird),"^",14)
	...s TRRowId=$P($G(^RBAS(resrowid,ASChird,"DHC")),"^",17)
	...i TRRowId="" s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(SessTime)
	...Q:("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!")
	...s ASRowId=resrowid_"||"_ASChird
	...;s AvailSeqNoStr=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"NOR") //,"Y"
	...s AvailSeqNoStr=##class(web.DHCRBAppointment).GetAvailableNum(ASRowId,"NOR","WIN","","","","","")  
	q AvailSeqNoStr
}

/*
..s rnt=0
	..i (..%SysTime()<=46800)&(..%SysTime()>=0) d
	...i (SessTime<=46800)&(SessTime>=25200) d
	....s rnt=1
	..i (..%SysTime()<=68340)&(..%SysTime()>=46860) d
	...i (SessTime<=68340)&(SessTime>=50400) d
	....s rnt=1
	..s rnt=1
	..q:rnt=0
*/
/// 得到分诊区诊室
ClassMethod QueryExab1(UserId As %String = "", Zone As %String = "") As %String
{
	s Initials=UserId
	;如果没有传入诊区ID,则默认获取此用户第一个诊区
	i Zone="" s Zone=..GetFirstExabID(Initials)
	;没有找到可操作的诊区则退出
	s IUserId=" "_UserId
	s BorUserId=0
	s rtn=""
	for {
		s BorUserId=$O(^User.DHCBorUserI("BoruUseDrIndex",IUserId,BorUserId))
		q:BorUserId=""
		s BoruBorDr=$List(^User.DHCBorUserD(BorUserId),2)
		continue:BoruBorDr=""
		continue:(Zone'="")&&(Zone'=BoruBorDr)
		s ExaRoomId=0
		for {
			s ExaRoomId=$o(^User.DHCBorExaRoomI("BordBorDrIndex",BoruBorDr,ExaRoomId))
			q:ExaRoomId=""
			s Obj=##class(User.DHCBorExaRoom).%OpenId(ExaRoomId)
			q:'$IsObject(Obj)
			s BorDr=Obj.BorDrGetObjectId()
			s BorExaRoomDr=Obj.BorExaRoomDr
			if BorExaRoomDr'="" {
				s BorExaRoom=$p($g(^CTLOC(BorExaRoomDr)),"^",2)
				if (BorExaRoom'="") s BorExaRoom=$e(BorExaRoom,1,8)
				i rtn="" s rtn=BorExaRoom
				e  s rtn=rtn_"^"_BorExaRoom
			}
			d Obj.%Close()
		}
	}
	q rtn
}

// 根据分诊区查找对应的科室

Query FindLocListByBor(UserId As %String, Zone As %String, desc As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "LocId:%String,LocDesc:%String")
{
}

ClassMethod FindLocListByBorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListByBorExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindLocListByBorExecute(ByRef qHandle As %Binary, UserId As %String, Zone As %String, desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	if (UserId="")&&(Zone="") Quit $$$OK
	k LocArr
	if (Zone'=""){
		s ExaBorID=0
		for {
			s ExaBorID=$O(^User.DHCExaBorDepI("BordBorDrIndex",Zone,ExaBorID))
			q:ExaBorID=""
			continue:('$d(^User.DHCExaBorDepD(ExaBorID)))
			s LocId=$List(^User.DHCExaBorDepD(ExaBorID),7)
			continue:LocId=""
			continue:$d(LocArr(LocId))
			s LocArr(LocId)=1
			continue:##class(web.DHCDocCommon).CheckLocIsValid(LocId)=0
			continue:($P(^CTLOC(LocId),"^",14)'="Y")
			s LocDesc=$p(^CTLOC(LocId),"^",2)
			d OutputRowLocList
		}
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}else{
		s BorUserId=0
		for {
			s BorUserId=$O(^User.DHCBorUserI("BoruUseDrIndex"," "_UserId,BorUserId))
			q:BorUserId=""
			s BoruBorDr=$List(^User.DHCBorUserD(BorUserId),2)
			continue:(BoruBorDr="")||('$d(^User.DHCExaBoroughD(BoruBorDr)))
			s ExaBorID=0
			for {
				s ExaBorID=$o(^User.DHCExaBorDepI("BordBorDrIndex",BoruBorDr,ExaBorID))
				q:ExaBorID=""
				continue:('$d(^User.DHCExaBorDepD(ExaBorID)))
				s LocId=$List(^User.DHCExaBorDepD(ExaBorID),7)
				continue:LocId=""
				continue:$d(LocArr(LocId))
			    s LocArr(LocId)=1
				continue:'$d(^CTLOC(LocId))
				continue:##class(web.DHCDocCommon).CheckLocIsValid(LocId)=0
				continue:($P(^CTLOC(LocId),"^",14)'="Y")
				s LocDesc=$p(^CTLOC(LocId),"^",2)
				d OutputRowLocList
			}			
		}
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	k LocArr
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLocList
	q:##class(web.DHCOPAdmReg).CheckLocDesc(LocId,desc)=0
    //set ConnentName=$p(^CTLOC(LocId),"^",43)
    //set LocDesc=ConnentName_" "_LocDesc
	set Data=$lb(LocId,LocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLocListByBorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListByBorExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {
		 Set AtEnd=1
		 Set Row=""
	 }Else{
	 	Set Row=^CacheTemp(repid,ind)
	 }
 	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

// 根据分诊区、科室查找对应的号别

Query FindDocListByBor(UserId As %String, Zone As %String, LocId As %String, desc As %String) As %Query(CONTAINID = 0, ROWSPEC = "DocId:%String,DocDesc:%String")
{
}

ClassMethod FindDocListByBorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocListByBorExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindDocListByBorExecute(ByRef qHandle As %Binary, UserId As %String, Zone As %String, LocId As %String, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	if (UserId="")&&(Zone="") Quit $$$OK
	s desc=$$ALPHAUP^SSUTIL4(desc)
	k DocArr
	if (Zone'=""){
		s ID=0
		for {
			s ID=$o(^User.DHCDepMarkI("DepmBorDrIndex",Zone,ID))
			Q:ID=""
			continue:'$d(^User.DHCDepMarkD(ID))
			s DepmDepDr=$List(^User.DHCDepMarkD(ID),8)
			continue:(DepmDepDr="")||((LocId'="")&&(DepmDepDr'=LocId))
			s DocID=$List(^User.DHCDepMarkD(ID),3)
			s ResRowId=$o(^RB("RES",0,"CTPCP",DocID,DepmDepDr,""))
			continue:(ResRowId="")||($d(DocArr(DocID))||('$d(^RB("RES",ResRowId))))
			//s DocArr(DepmDepDr,ResRowId)=1
			s DocArr(DocID)=1
			s LocDesc=$p(^CTLOC(DepmDepDr),"^",2)
			s DocDesc=$p($g(^CTPCP(DocID,1)),"^",2)
			s DocDesc=DocDesc //_" "_LocDesc
			d OutputRowDocList
			
		}
		k DocArr
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}elseif(LocId'=""){
		s LocDesc=$p(^CTLOC(LocId),"^",2)
		s ResRowId=0
		for {
			s ResRowId=$o(^RB("RES",0,"CTLOC",LocId,ResRowId))
			Q:ResRowId=""
			continue:('$d(^RB("RES",ResRowId)))
			s DocID=$p(^RB("RES",ResRowId),"^",2)
			continue:DocID=""
			continue:'$d(^User.DHCDepMarkI("DepmMarkDrIndex",DocID))
			s DocDesc=$p($g(^CTPCP(DocID,1)),"^",2)
			s DocDesc=DocDesc //_" "_LocDesc
			s DepmDepDr=LocId
			d OutputRowDocList
		}
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}else{
		s ID=0
		for {
			s ID=$O(^User.DHCBorUserI("BoruUseDrIndex"," "_UserId,ID))
			q:ID=""
			s BoruBorDr=$List(^User.DHCBorUserD(ID),2)
			continue:BoruBorDr=""
			continue:'$d(^User.DHCExaBoroughD(BoruBorDr))
			s ID1=0
			for {
				s ID1=$o(^User.DHCDepMarkI("DepmBorDrIndex",BoruBorDr,ID1))
				Q:ID1=""
				continue:'$d(^User.DHCDepMarkD(ID1))
				s DepmDepDr=$List(^User.DHCDepMarkD(ID1),8)
				continue:(DepmDepDr="")||((LocId'="")&&(DepmDepDr'=LocId))
				s DocID=$List(^User.DHCDepMarkD(ID1),3)
				s ResRowId=$o(^RB("RES",0,"CTPCP",DocID,DepmDepDr,""))
				continue:(ResRowId="")||($d(DocArr(DocID))||('$d(^RB("RES",ResRowId))))
				//s DocArr(DepmDepDr,ResRowId)=1
				s DocArr(DocID)=1
				s LocDesc=$p(^CTLOC(DepmDepDr),"^",2)
				s DocDesc=$p($g(^CTPCP(DocID,1)),"^",2)
				s DocDesc=DocDesc //_" "_LocDesc
				d OutputRowDocList
			}
		}
	}
	k DocArr
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDocList
    s code=$p($g(^CTPCP(DocID,1)),"^",1)
	q:($$ALPHAUP^SSUTIL4(DocDesc)'[desc)&&($$ALPHAUP^SSUTIL4(code)'[desc)&&(desc'="")
	set Data=$lb(DocID,DocDesc)
 	Set ^CacheTemp(repid,DepmDepDr_""_DocID)=Data
 	//Set ind=ind+1
	Quit
}

ClassMethod FindDocListByBorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocListByBorExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {
		 Set AtEnd=1
		 Set Row=""
	 }Else{
	 	Set Row=^CacheTemp(repid,ind)
	 }
 	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

/// w ##class(web.DHCAlloc).GetPatSum1("0000000003")
ClassMethod GetPatSum(PersonId As %String, Zone As %String = "", LogonHospId As %String = "", QueueID As %String = "") As %String
{
	s rtn=""
	s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
	if (QueueID'=""){
		s AdmId=$lg(^User.DHCQueueD(QueueID),11)
		s PatientID=$p($g(^PAADM(AdmId)),"^",1)
		Set PersonId=$P(^PAPER(PatientID,"PAT",1),"^",1)
	}
	q:PersonId="" "-1" ;//没有输入登记号
	s Date=..%SysDate()
	s DHCQueueID="" f  s DHCQueueID=$o(^User.DHCQueueI("QuePersonIdIndex"," "_PersonId,DHCQueueID)) q:DHCQueueID=""  d
	.s QueDate=$List(^User.DHCQueueD(DHCQueueID),3)  //日期
	.q:((QueueID'="")&&(QueueID'=DHCQueueID))
	.q:Date'=QueDate
	.s QuePaadmDr=$List(^User.DHCQueueD(DHCQueueID),11)
	.s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(QuePaadmDr)
	.Q:AdmHospitalId'=LogonHospId
	.s QueMarkDr=$List(^User.DHCQueueD(DHCQueueID),8)
	.s QuePatNo=$List(^User.DHCQueueD(DHCQueueID),10)  //挂号顺序
	.s PatName=$List(^User.DHCQueueD(DHCQueueID),9)    // 挂号人姓名
	.s DeptDr=$List(^User.DHCQueueD(DHCQueueID),4)    // 就诊科室
	.s DeptName=$p(^CTLOC(DeptDr),"^",2)
	.s (Sum,FZSum,DHSum)=0
	.s QueStateDr=$List(^User.DHCQueueD(DHCQueueID),14)   // 状态
	.s Str=""
	.i (QueStateDr=1)||(QueStateDr=2) d
	..s QueDocDr=$List(^User.DHCQueueD(DHCQueueID),5)  ;CTCareProv  // 就诊医生
	..i QueDocDr'="" d   // 复诊是数据  指定医生
	...s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",QueDocDr,""))
	...s Str=##class(web.DHCAlloc).GetPatSumByDoc(DeptDr,SSUserID,QueDate,DHCQueueID)
	..e  d
	...s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",QueMarkDr,"")) 
	...if SSUserID'="" d
	....s Str=##class(web.DHCAlloc).GetPatSumByDoc(DeptDr,SSUserID,QueDate,DHCQueueID)
	...e  d
	....s Str=##class(web.DHCAlloc).GetPatSumByMark(DHCQueueID,QueDate,QueMarkDr,Zone)
	.i Str'="" d
	..i rtn="" d
	...s rtn=PatName_"在【"_DeptName_"】$"_QuePatNo_"$"_Str
	..e  d
	...s rtn=rtn_"^"_PatName_"在【"_DeptName_"】$"_QuePatNo_"$"_Str
	
	if rtn="" s rtn="$$0$0$0"
	q rtn
}

/// w ##class(web.DHCAlloc).GetPatSum2(1,"5010",64728,"265")
ClassMethod GetPatSumByDoc(DeptDr, SSUserID, QueDate, DHCQueueID) As %String
{
	s rtn=""
	s ^tempztwa("GetPatSum2")=$lb(DeptDr, SSUserID, QueDate, DHCQueueID)
	Set obj=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
	d obj.Execute(DeptDr,SSUserID,"","","","",QueDate,QueDate,"","","")
	Set repid=$I(^CacheTemp)
	Set index=1
	Set flag=""
	Set (Sum,FZSum,DHSum)=0
	While (obj.Next()){
		//s QueRowId=obj.GetData(42)
		s EpisodeID=obj.GetData(2)
		s QueRowId=0
		i EpisodeID'="" s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,QueRowId))
		if (DHCQueueID=QueRowId){
			//s flag="1"
			q
		}
		//if ((flag="")&&(QueRowId'=DHCQueueID)){
		if (QueRowId'=DHCQueueID){
			s QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
			if (QueStateDr=1){
				s FZSum=FZSum+1
				s Sum=Sum+1
			}
			if (QueStateDr=2){
				s DHSum=DHSum+1
				s Sum=Sum+1
			}
			
		}
	}
	b ;Sum
	/*if (Sum>0){
		s rtn=Sum_"$"_FZSum_"$"_DHSum
	}*/
	s rtn=Sum_"$"_FZSum_"$"_DHSum
	q rtn
}

ClassMethod GetPatSumByMark(DHCQueueID, QueDate, QueMarkDr, Zone As %String = "") As %String
{
	s rtn=""
	s QuePatNo=$List(^User.DHCQueueD(DHCQueueID),10)
	s (Sum,FZSum,DHSum)=0
	if (Zone=""){
		s ID="" f  s ID=$O(^User.DHCQueueI("QueMarkDrIndex",QueDate,QueMarkDr,ID)) q:ID=""  d
		.s QueStateDr=$List(^User.DHCQueueD(ID),14)   ;1 '复诊'   2  '等候'
		.i QueStateDr=1 d
		..q:DHCQueueID=ID
		..s FZSum=FZSum+1
		..s Sum=Sum+1
		.e  i QueStateDr=2 d
		..s PatNo=$List(^User.DHCQueueD(ID),10)
		..i QuePatNo>PatNo d
		...s DHSum=DHSum+1
		...s Sum=Sum+1
	}else{
		if '($d(%session)&&($d(%session.Data))){
			s BorUserId=$O(^User.DHCBorUserI("BoruBorDrIndex",Zone,""),-1)
			if (BorUserId'=""){
				s UserID=$LG(^User.DHCBorUserD(BorUserId),3)
				s UserCode=$P($G(^SSU("SSUSR",+UserID)),"^",1)
			}
		}else{
			s UserCode=%session.Get("LOGON.USERCODE")
		}
		Set rset=##class(%ResultSet).%New("web.DHCAlloc:QueryFindPatQueue")
		do rset.Execute(%session.Get("LOGON.USERCODE"),"","复诊与等候","","","","",Zone)
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s TQueID=rset.GetData(9)
			if (DHCQueueID=TQueID){
				q
			}
			s TMarkDr=$List(^User.DHCQueueD(TQueID),8)
			continue:(TMarkDr'="")&&(QueMarkDr'=TMarkDr)
			if (TQueID'=DHCQueueID){
				s QueStateDr=$List(^User.DHCQueueD(TQueID),14)
				if (QueStateDr=1){
					s FZSum=FZSum+1
					s Sum=Sum+1
				}
				if (QueStateDr=2){
					s DHSum=DHSum+1
					s Sum=Sum+1
				}
			}
		}
		d rset.Close()
	}
	s rtn=Sum_"$"_FZSum_"$"_DHSum
	q rtn
}

ClassMethod GetDHCPerStateFlag(PersonId, QueueID = "") As %String
{
	s rtn="0",ErrMsg=""
	if (QueueID'=""){
		s AdmId=$lg(^User.DHCQueueD(QueueID),11)
		s PatientID=$p($g(^PAADM(AdmId)),"^",1)
		Set PersonId=$P(^PAPER(PatientID,"PAT",1),"^",1)
		}
	if (PersonId="") {
		s rtn="-1"
		s ErrMsg="请输入登记号后进行查询!"
		q rtn_"^"_ErrMsg
	}else{
		s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PersonId,""))
		i PAPMIRowId="" {
			s PatName=""
			s rtn="-1"
			s ErrMsg=PersonId_PatName_"该登记号没有对应患者信息!"
			q rtn_"^"_ErrMsg
		}
		s PatName=$p(^PAPER(PAPMIRowId,"ALL"),"^",1)
	}
	k DHCQuePerStateList
	s Date=..%SysDate()
	s Count=0 //过号/报到队列数量
	s RegedCount=0 //挂号队列数量
	s DHCQueueID="" for {
		s DHCQueueID=$o(^User.DHCQueueI("QuePersonIdIndex"," "_PersonId,DHCQueueID)) q:DHCQueueID=""
		s QueDate=$List(^User.DHCQueueD(DHCQueueID),3)  ;时间
		continue:Date'=QueDate
		s QueMarkDr=$List(^User.DHCQueueD(DHCQueueID),8)
		s DeptDr=$List(^User.DHCQueueD(DHCQueueID),4)    // 就诊科室
		s QueStateDr=$List(^User.DHCQueueD(DHCQueueID),14)
		continue:QueStateDr=5 //过滤退号
		s RegedCount=RegedCount+1
		continue:(QueStateDr'=3)&&(QueStateDr'=7)
		s DHCQuePerStateList(DeptDr,QueMarkDr,QueStateDr)=1
		s Count=Count+1
	}
	s DeptDr=0
	for {
		s DeptDr=$o(DHCQuePerStateList(DeptDr)) Q:DeptDr=""
		s DeptName=$p(^CTLOC(DeptDr),"^",2)
		s QueMarkDr=0
		for {
			s QueMarkDr=$o(DHCQuePerStateList(DeptDr,QueMarkDr)) Q:QueMarkDr=""
			s DocName=$p(^CTPCP(QueMarkDr,1),"^",2)
			s QueStateDr=0
			for {
				s QueStateDr=$o(DHCQuePerStateList(DeptDr,QueMarkDr,QueStateDr)) Q:QueStateDr=""
				if (QueStateDr=3) {
					s OneErrMsg="已过号"
				}
				if (QueStateDr=7) {
					s OneErrMsg="未报到"
				}
			}
		}
		if (ErrMsg="") s ErrMsg=DeptName_" "_DocName_" "_OneErrMsg
		else  s ErrMsg=ErrMsg_"；"_DeptName_" "_DocName_" "_OneErrMsg
	}
	k DHCQuePerStateList
	Q:(Count=1)&&(RegedCount=1) "-1^"_ErrMsg_" 不能进行等候人数查询!"
	if (RegedCount=0) {
		s rtn="-1"
		s ErrMsg="登记号:"_PersonId_" 患者:"_PatName_" 当天没有挂号记录！"
	}
	q rtn_"^"_ErrMsg
}

/// 获取分诊列表query
Query QueryFindPatQueue(UserCode As %Library.String = "", CompName As %Library.String = "", QueryST As %Library.String = "", RoomDr As %Library.String = "", MarkDr As %Library.String = "", PatID As %Library.String = "", PapmiNo As %Library.String = "", Zone As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", TPatName As %Library.String = "", PatPhone As %Library.String = "", QueueNo As %String = "", DocLogonInfo As %String = "") As %Query(ROWSPEC = "CardNo:%String:卡号,PatName:%String:姓名,Prior:%String:优先级,status:%String:状态,TSeqNo:%String:排队号,RoomName:%String:诊室,MarkName:%String:号别,DocName:%String:医生,TQueID:%String,RBirth:%String:年龄,RSex:%String:性别,DeptDesc:%String:科室,PatientID:%String,EpisodeID:%String,mradm:%String,ConsultatFlage:%String:会诊,TFirstReson:%String:优先原因,StatusPerName:%String,AdmDate:%String:就诊日期,AdmWeek:%String:就诊星期,PAADMAdmDocCodeDR:%String,QueDocDr:%String,DeptDr:%String,AsStatusDesc:%String:排班状态,RegFeeDateTime:%String:挂号时间,PatientNo:%String:登记号,QueCompDr:%String,AdivseAdmTime:%String:建议就诊时间,ASNoLimitLoadFlag:%String,PAAdmReMark:%String:患者备注,QueArriveTime:%String:报到时间,QueCallTime:%String:呼叫时间")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCAlloc","QueryFindPatQueue","HS01","","全部","","","","","37","","","","","")
ClassMethod QueryFindPatQueueExecute(ByRef qHandle As %Binary, UserCode As %Library.String = "", CompName As %Library.String = "", QueryST As %Library.String = "", RoomDr As %Library.String = "", MarkDr As %Library.String = "", PatID As %Library.String = "", PapmiNo As %Library.String = "", Zone As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", TPatName As %Library.String = "", PatPhone As %Library.String = "", QueueNo As %String = "", DocLogonInfo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
    s ^tempqujian("QueryFindPatQueue")=$lb(UserCode , CompName, QueryST, RoomDr, MarkDr , PatID , PapmiNo, Zone , StartDate , EndDate , TPatName , PatPhone , QueueNo,DocLogonInfo)
	k ^TEMPQueue($j)
	s QueueDate=..%SysDate()
	s LogUserDr=0
	s Initials=$ZCVT(UserCode,"U")
	s LogUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",Initials,LogUserDr))
	;如果没有传入诊区ID,则默认获取此用户第一个诊区
	i Zone="" s Zone=..GetFirstExabID(Initials)
	;没有找到可操作的诊区则退出
	if Zone="" Q "N"
	s BorDr=Zone
	;状态
	s StateDesc=""
	s StateDr=""
	s Consultation=""
	if QueryST="会诊" {
		s Consultation=QueryST
		s QueryST="所有"
	}
	if QueryST="未报到" {
		s QueryST="报到"
	}
	i QueryST="全部" s QueryST="所有"
	i StartDate'="" s StartDate=..%ZDH(StartDate)
	e  s StartDate=..%SysDate()
	i EndDate'="" s EndDate=..%ZDH(EndDate)
	e  s EndDate=..%SysDate()
	
	if (DocLogonInfo'="")&&(QueryST="复诊与等候") {
		s LogonLocDr=$P(DocLogonInfo,"^",1)
		s LogonDocID=$P(DocLogonInfo,"^",2)
		s LogonCompIP=$P(DocLogonInfo,"^",3)
		s LogonGroupDr=$P(DocLogonInfo,"^",4)
		s LogonHospId=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LogonLocDr)
		s ExpSessionStr=LogonGroupDr_"^"_LogonHospId
		s LogonUserID=$o(^SSU("SSUSR",0,"CTPCP",LogonDocID,""))
		set rs=##class(%ResultSet).%New("web.DHCDocOutPatientList:FindLocDocCurrentAdm")
		set sc=rs.Execute(LogonLocDr , LogonUserID , LogonCompIP , "", "" , "" , "" , "", "", "", "", "", "","",ExpSessionStr)
		s SortNum=0
		while rs.Next(.sc) {
			s EpisodeID=rs.GetDataByName("EpisodeID")
			s QueRowId=rs.GetDataByName("QueRowId")
			s LocSeqNo=rs.GetDataByName("LocSeqNo")
			s SortNum=SortNum+1
			s ^TEMPQueue($j,"DHCAlloc",SortNum,LocSeqNo,QueRowId)=""
		}
	}else{
		f QueueDate=StartDate:1:EndDate {
			d GetOutPutInfo
		}
	
	}
	
	
	
	s SortNum=""
	for{
		s SortNum=$o(^TEMPQueue($j,"DHCAlloc",SortNum))
		q:SortNum=""
		s TSeqNo=""
		for{
			s TSeqNo=$o(^TEMPQueue($j,"DHCAlloc",SortNum,TSeqNo))
			q:TSeqNo=""
			s QueDr=""
			for{
				s QueDr=$o(^TEMPQueue($j,"DHCAlloc",SortNum,TSeqNo,QueDr))
				q:QueDr=""

				s QuePersonId=$List(^User.DHCQueueD(QueDr),12)
				s QueExaBor=$List(^User.DHCQueueD(QueDr),6)
				s ConsultatFlage=$List(^User.DHCQueueD(QueDr),18) ;会诊标志
				s PatNo=$List(^User.DHCQueueD(QueDr),12)
				s PatName=$List(^User.DHCQueueD(QueDr),9)
				s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),0)) 
				s Tel=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11)
				
				s PatientNo = $p($g(^PAPER(PapmiRowid,"PAT",1)), "^", 2)
				s QueFirstDr=$List(^User.DHCQueueD(QueDr),7)
				i QueFirstDr=""  d
				.s FirstCode="02"
				.s Prior="正常"
				e  d
				.s FirstCode=$List(^User.DHCFirstCodeD(QueFirstDr),2) 
				.s Prior=$List(^User.DHCFirstCodeD(QueFirstDr),4)
				s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
				s status=$List(^User.DHCPerStateD(QueStateDr),4)
				
				s StatusCode=$List(^User.DHCPerStateD(QueStateDr),2)
				set PAAdm=$List(^User.DHCQueueD(QueDr),11)
				s SeqNo=$List(^User.DHCQueueD(QueDr),10)
				s NewSeqNoStr=##class(web.DHCDocOutPatientList).GetNewQueueNo(PAAdm)
				if NewSeqNoStr'="" d
				.s SeqNo=$P(NewSeqNoStr,"^",2)
				.if ($P(NewSeqNoStr,"^",3)'="正常") s SeqNo=SeqNo_"("_$P(NewSeqNoStr,"^",3)_")"
				s QueRoomDr=$List(^User.DHCQueueD(QueDr),13)
				s RoomName=""
				i QueRoomDr'="" d 
				.i ($d(^CTLOC(QueRoomDr))) s RoomName=$p(^CTLOC(QueRoomDr),"^",2)
				s QueueDepDr=$List(^User.DHCQueueD(QueDr),4)
				s QueueMarkDr=$List(^User.DHCQueueD(QueDr),8)
				
				s MarkName=$List(^User.DHCQueueD(QueDr),8)
				i MarkName'="" s MarkName=$p(^CTPCP(MarkName,1),"^",2)
				set PAAdm=$List(^User.DHCQueueD(QueDr),11)
				SET mradm=$p(^PAADM(PAAdm),"^",61)
				Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
				set RegRangeTimeCode=""
				set AsStatusDesc = ""
				set (RegFeeDateTime,ASNoLimitLoadFlag,asRowId) = ""
				if RegfeeDr'="" {
					set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
					i $g(RegRangeTimeDr)'="" {
						set RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
						set RegRangeTimeCode=$p(^DHCTimeRange(RegRangeTimeDr),"^",1)
					}
					set MarkName=MarkName_"("_$g(RegRangeTime)_")"
					; 排班状态
					s asRowId = $list(^User.DHCRegistrationFeeD(RegfeeDr), 18)
					i ($g(asRowId)'="")&&($d(^RBAS(+asRowId,+$p(asRowId,"||",2)))) {
						s ASNoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(asRowId)
						s AsStatusId = $p($g(^RBAS(+asRowId,+$p(asRowId,"||",2),"DHC")), "^", 10)
						s AsStatusCode = $p($g(^DHCRBCASStatus(AsStatusId)), "^", 1)
						s AsStatusDesc = $p($g(^DHCRBCASStatus(AsStatusId)), "^", 2)
						i AsStatusCode="TR" {
							s asRId = $p($g(^RBAS(+asRowId,+$p(asRowId,"||",2),"DHC")), "^", 10)
							s rDocDesc = $p($g(^RB("RES",+asRId)), "^", 17)
							s AsStatusDesc = AsStatusDesc_"(替诊:"_rDocDesc_")"
						}
					}
					; 获取挂号时间
					s regFeeDate = $list(^User.DHCRegistrationFeeD(RegfeeDr), 15)
					s regFeeTime = $list(^User.DHCRegistrationFeeD(RegfeeDr), 16)
					s:(regFeeDate'="")&&(regFeeTime'="") RegFeeDateTime = ..%ZD(regFeeDate)_" "_..%ZT(regFeeTime)
				}
				if RegRangeTimeCode="" s RegRangeTimeCode="99"
				
				
				s QueID=QueDr
				s TFirstReson=$Lg(^User.DHCQueueD(QueDr),32)
				s status=$Lg(^User.DHCPerStateD(QueStateDr),6)
				s StatusPerName=$Lg(^User.DHCPerStateD(QueStateDr),4)
				;按号别排序,不同的号别可能名字相同,所以不能直接用号别的名字，应与科室结合作为判断
				s AdmDate=$p(^PAADM(PAAdm),"^",6)
				s AdmWeek=$case($zd(AdmDate,10),1:"星期一",2:"星期二",3:"星期三",4:"星期四",5:"星期五",6:"星期六",0:"星期日",:"")
				s AdmDate=..%ZD(AdmDate) ;$zd(AdmDate,3)
				s PAADMAdmDocCodeDR=$p(^PAADM(PAAdm),"^",9) //就诊表中的初诊医生/挂号时的号别(医生)
				s QueDocDr=$List(^User.DHCQueueD(QueDr),5) //队列表中的就诊医生/指定的医生
				s QueCompDr=$List(^User.DHCQueueD(QueDr),2)
				//报道时间
				s QueArriveTime=""
				s QueChangeSub=""
				f  {
					s QueChangeSub=$O(^DHCQueueStatus(QueDr,QueChangeSub),-1)
					Q:(QueChangeSub="")||(QueArriveTime'="")
					s QueChangeStatuDr=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",4)
					continue:QueChangeStatuDr=""
					s QueChangeBeforeStatuDr=""
					//上条变化是报道且本次状态是等候
					s QueChangeBeforeSub=$O(^DHCQueueStatus(QueDr,QueChangeSub),-1)
					s QueChangeBeforeStatuDesc=""
					if (QueChangeBeforeSub'=""){
						s QueChangeBeforeStatuDr=$P($G(^DHCQueueStatus(QueDr,QueChangeBeforeSub)),"^",4)
						continue:QueChangeBeforeStatuDr=""
						s QueChangeBeforeStatuDesc=$list(^User.DHCPerStateD(QueChangeBeforeStatuDr),4)
					}
					//continue:QueChangeBeforeStatuDesc=""
					s QueChangeStatuDesc=$list(^User.DHCPerStateD(QueChangeStatuDr),4)
					if (QueChangeStatuDesc="等候")&&(QueChangeBeforeStatuDesc="报到"){
						s QueArriveDate=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",1)
						s QueArriveTime=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",2)
						s QueArriveTime = ..%ZD(QueArriveDate)_" "_..%ZT(QueArriveTime)
					}
				}
				//叫号时间
				s QueCallDate=$LG(^User.DHCQueueD(QueDr),33)
				s QueCallTime=$LG(^User.DHCQueueD(QueDr),34)
				if (QueCallTime'="")&&(QueCallDate'=""){
					s QueCallTime = ..%ZD(QueCallDate)_" "_..%ZT(QueCallTime)
				}
				s DocName=""
				s DocDr=$Lg(^User.DHCQueueD(QueDr),5)
				;判断?输出
				i DocDr'="" s DocName=$p(^CTPCP(DocDr,1),"^",2)
				s DeptDr=$Lg(^User.DHCQueueD(QueDr),4)
				i DeptDr'="" d
				.s DeptDesc=$P($g(^CTLOC(DeptDr)),"^",2)
				.s DeptDesc1=$P(DeptDesc,"-",2)
				.i DeptDesc1'="" s DeptDesc=DeptDesc1
				s PatName=$p(^PAPER(PapmiRowid,"ALL"),"^",1)
				s RBirth=+$p(^PAPER(PapmiRowid,"ALL"),"^",6)
				s RBirth=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PapmiRowid,PAAdm,HospID)
				s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
				s RSex=$p($g(^CT("SEX",sexid)),"^",2) 
				i Prior="正常" s Prior=""
				i Prior="优先" s PatName = "(优)"_PatName
				s CardNo=##class(DHCDoc.Common.pa).GetAdmRegCard(PAAdm)
				s:CardNo'="" CardNo=$p(CardNo,"^",1)
				s QueSeqNo=$lg(^User.DHCQueueD(QueID),10)
				s AdivseAdmTime=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(asRowId,QueSeqNo,"")
				if StatusPerName="到达" s AdivseAdmTime=""
				s PAAdmReMark=##class(web.DHCDocInPatientListNew).GetDocReMark(PAAdm)
				d OutPutPatQueue 
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutPatQueue
	set Data=$lb(CardNo,PatName,Prior,status,SeqNo,RoomName,MarkName,DocName,QueDr,RBirth,RSex,DeptDesc,PapmiRowid,PAAdm,mradm,ConsultatFlage,TFirstReson,StatusPerName,AdmDate,AdmWeek,PAADMAdmDocCodeDR,QueDocDr,DeptDr,AsStatusDesc,RegFeeDateTime,PatientNo,QueCompDr,AdivseAdmTime,ASNoLimitLoadFlag,PAAdmReMark,QueArriveTime,QueCallTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetOutPutInfo
	 s desc="N"
	 s QueDr=""
	 f  {
		s QueDr=$o(^User.DHCQueueI("QueDateIndex",QueueDate,QueDr))
		q:QueDr=""
		s QuePersonId=$List(^User.DHCQueueD(QueDr),12)
		continue:(QuePersonId'=PapmiNo)&(PapmiNo'="")  ;xp add,2008-04-17      
		s QueExaBor=$List(^User.DHCQueueD(QueDr),6)
		continue:(QueExaBor'=BorDr)&&(Consultation'="会诊")
		s ConsultatFlage=$List(^User.DHCQueueD(QueDr),18) ;会诊标志
		continue:(Consultation="会诊")&&(ConsultatFlage'="Y")  ;会诊标志用来过滤会诊病人
		;按顺序取出
		s PatNo=$List(^User.DHCQueueD(QueDr),12)
		continue:(PatID'=PatNo)&(PatID'="")
		s PatName=$List(^User.DHCQueueD(QueDr),9)
		continue:(TPatName'="")&((PatName'[TPatName)&&(TPatName'[PatName))
		;联系电话
		s PapmiRowid=0  
		s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),PapmiRowid)) 
		s Tel=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11)
		continue:(PatPhone'="")&(Tel'=PatPhone)
		s QueStateDr=$List(^User.DHCQueueD(QueDr),14)
		s status=$List(^User.DHCPerStateD(QueStateDr),4)
		continue:(status'=QueryST)&&(QueryST'="所有")&&((QueryST'="复诊与等候")||("复诊与等候"'[status))
		set PAAdm=$List(^User.DHCQueueD(QueDr),11)
		s SeqNo=$List(^User.DHCQueueD(QueDr),10)
		s NewSeqNoStr=##class(web.DHCDocOutPatientList).GetNewQueueNo(PAAdm)
		if NewSeqNoStr'="" d
		.s SeqNo=$P(NewSeqNoStr,"^",2)
		continue:(QueueNo'="")&&(QueueNo'=SeqNo)
		s QueRoomDr=$List(^User.DHCQueueD(QueDr),13)
		s RoomName=""
		i QueRoomDr'="" d 
		.i ($d(^CTLOC(QueRoomDr))) s RoomName=$p(^CTLOC(QueRoomDr),"^",2)
		continue:(RoomDr'=RoomName)&(RoomDr'="") 
		s DepmDepDr=""
		s DepmMarkDr=""
		i MarkDr'=""  d 
		.s DepmDepDr=$List(^User.DHCDepMarkD(MarkDr),8)
		.s DepmMarkDr=$List(^User.DHCDepMarkD(MarkDr),3)
		s QueueDepDr=$List(^User.DHCQueueD(QueDr),4)
		s QueueMarkDr=$List(^User.DHCQueueD(QueDr),8)
		continue:(DepmMarkDr'=QueueMarkDr)&(MarkDr'="")
		continue:(DepmDepDr'=QueueDepDr)&(MarkDr'="")
		

		Set RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
		set RegRangeTimeCode=""
		if RegfeeDr'="" do
		.set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
		.i $g(RegRangeTimeDr)'="" d
		..set RegRangeTimeCode=$p(^DHCTimeRange(RegRangeTimeDr),"^",1)
		if RegRangeTimeCode="" s RegRangeTimeCode="99"

		s QueFirstDr=$List(^User.DHCQueueD(QueDr),7)
		i QueFirstDr=""{
			s FirstCode="02"
		}else{
			s FirstCode=$List(^User.DHCFirstCodeD(QueFirstDr),2) 
		}
		s StatusCode=$List(^User.DHCPerStateD(QueStateDr),2)
		s SortNum=##class(web.DHCDocPrescript).LPAD2(RegRangeTimeCode,"0",5)
		s SortNum=SortNum_##class(web.DHCDocPrescript).LPAD2(QueueDepDr,"0",7)
		s SortNum=SortNum_##class(web.DHCDocPrescript).LPAD2(QueueMarkDr,"0",7)
		s SortNum=SortNum_##class(web.DHCDocPrescript).LPAD2(FirstCode,"0",5)
		s SortNum=SortNum_##class(web.DHCDocPrescript).LPAD2(StatusCode,"0",5)
		s ^TEMPQueue($j,"DHCAlloc",SortNum,+SeqNo,QueDr)=""
	}
	Quit
}

ClassMethod QueryFindPatQueueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryFindPatQueueExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryFindPatQueueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryFindPatQueueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// FindTodaydoc根据医生和科室查询今天是否有排版

ClassMethod FindTodaydoc(locdr, Docdr, Zone)
{
	q:locdr="" 0
	q:Docdr="" 0
	//挂号设置->排班诊室允许跨诊区
	s LocHospDr=$p(^CTLOC(locdr),"^",22)
	s AllowOpenAllRoms=##class(web.DHCOPRegConfig).GetSpecConfigNode("AllowOpenAllRoms",LocHospDr)
	s rtn=0
	s Status=""
	s RESRowId="" f  s RESRowId=$o(^RB("RES",0,"CTPCP",Docdr,locdr,RESRowId)) q:RESRowId=""  d
	.s SessStartTime="" f  s SessStartTime=$o(^RBAS(RESRowId,0,"DateSTime",+$h,SessStartTime))  q:SessStartTime=""  d
	..s RESRowIdChird=""  f  s RESRowIdChird=$o(^RBAS(RESRowId,0,"DateSTime",+$h,SessStartTime,RESRowIdChird))  q:RESRowIdChird=""  d
	...s StatusDR=$P($G(^RBAS(+RESRowId,RESRowIdChird,"DHC")),"^",10)
	...s:StatusDR'="" Status=$p(^DHCRBCASStatus(StatusDR),"^",1)
	...Q:(Status="S")||(Status="PS")||(Status="TR")
	...s RoomDR=$P($G(^RBAS(+RESRowId,RESRowIdChird,"DHC")),"^",5)
	...if (RoomDR'="")&&(AllowOpenAllRoms=0)  d
	....s ExaRoomId=$o(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RoomDR,""))
	....if ExaRoomId'=""  d
	.....s Obj=##class(User.DHCBorExaRoom).%OpenId(ExaRoomId)
	.....s BorDr=Obj.BorDrGetObjectId()
	.....if BorDr=Zone s rtn=1
	...else  s rtn=1
	q rtn
}

/// 保存用户上次选择的诊区
ClassMethod SaveLastSelectZone(Userid, Zoneid)
{
	q:((Userid="")||(Zoneid="")) ""
	s ^DHCDocAlloc("SelectZone",Userid)=Zoneid
	q ""
}

/// 得到用户上次选择的诊区
ClassMethod GetLastSelectZone(Userid)
{
	q:Userid="" ""
	s zoneid=""
	s zoneid=$G(^DHCDocAlloc("SelectZone",Userid))
	q zoneid
}

/// 获取对列表呼叫状态
ClassMethod GetQueCalledFlag(QueID)
{
	s QueEverCalled=$List(^User.DHCQueueD(QueID),29)
	Q QueEverCalled
}

/// 判断是否需要报到
/// 需要1，不需要0
/// w ##class(web.DHCAlloc).CheckForQueCheckin(145)
ClassMethod CheckForQueCheckin(QueID)
{
	q:QueID="" 0
	s QueueDepDr=$List(^User.DHCQueueD(QueID),4)
	s QueueMarkDr=$List(^User.DHCQueueD(QueID),8)
	s PAAdm=$List(^User.DHCQueueD(QueID),11)
	s rtn=0,ExabDr=""
	&sql(SELECT ID,depmbordr into :MarkRowid,:ExabDr FROM sqluser.DHCDepMark
         where depmdepdr=:QueueDepDr and depmmarkdr=:QueueMarkDr and DepmSign<>'N')
	if (ExabDr'="") {
		&sql(select ExabTem into :Checkin from SQLUser.DHCExaBorough where ID=:ExabDr)
		if Checkin'="Y"{
		   s Checkin=$list(^User.DHCDepMarkD(MarkRowid),10)
		}
		if Checkin="Y"{s rtn=1}
	}
	if (rtn=0) {
	    s RegfeeDr=$O(^User.DHCRegistrationFeeI("ADM",PAAdm,""))
	    if RegfeeDr'="" {
		 	s RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
		 	if (RegRangeTimeDr'="") {
			 	s TRCheckin=$p($g(^DHCTimeRange(RegRangeTimeDr)),"^",12)
			 	if TRCheckin="Y"{s rtn=1}
			}
		}
	}
	q rtn
}

/// 取消报到
ClassMethod CancleQueCheckin(QueID, UserID)
{
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	if (status'="等候"){
		s id=0,desc1=""
		for {
			s id=$o(^User.DHCPerStateD(id)) Q:id=""
			Q:(desc1'="")
			s persname=$List(^User.DHCPerStateD(id),4)
			s pershowsname=$List(^User.DHCPerStateD(id),6)
			if (pershowsname="") s pershowsname=persname
			if (persname="等候") s desc1=pershowsname
		}
		Q "非【"_desc1_"】状态的记录不能进行取消报到!"
	}
	
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CheckForQueCheckFlag=..CheckForQueCheckin(QueID)
	q:CheckForQueCheckFlag=0 "1^该记录对应号别不需要分诊,不能取消【报到】!"
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s desc=0
	&sql(select ID into :RetrunPersDr from  SQLUser.DHCPerState where PersName='退号')
	s desc=desc+SQLCODE
	&sql(select ID into :StateID from dhcperstate where PersName='报到')
	s desc=desc+SQLCODE
	&sql(update Dhcqueue set questatedr=:StateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID
	 where Id=:QueID and QueStateDr<>:RetrunPersDr)
	s desc=desc+SQLCODE
	//恢复取消报到
	s AdmId=$lg(^User.DHCQueueD(QueID),11)
	s ExabCheckFlag=##class(web.DHCAlloc).GetExaBordFlag(AdmId)
	if (($P(ExabCheckFlag,"^",5)="Y")){
		d ##Class(web.DHCDocOutPatientList).CancleCreatNewQueueNo(AdmId)
		}
	q desc
}

/// 取消复诊
ClassMethod CancleQueAgain(QueID, UserID)
{
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	if (status'="复诊"){
		s id=0,desc1=""
		for {
			s id=$o(^User.DHCPerStateD(id)) Q:id=""
			Q:(desc1'="")
			s persname=$List(^User.DHCPerStateD(id),4)
			s pershowsname=$List(^User.DHCPerStateD(id),6)
			if (pershowsname="") s pershowsname=persname
			if (persname="复诊") s desc1=pershowsname
		}
		Q "非【"_desc1_"】状态的记录不能进行取消复诊!"
	}
	
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s desc=0
	&sql(select ID into :RetrunPersDr from  SQLUser.DHCPerState where PersName='退号')
	s desc=desc+SQLCODE
	&sql(select ID into :FirstDr from SQLUser.DHCFirstCode where firstcname='正常')
	s desc=desc+SQLCODE
	&sql(select ID into :StateID from dhcperstate where PersName='到达')
	s desc=desc+SQLCODE
	&sql(update Dhcqueue set questatedr=:StateID,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID,queFirstdr=:FirstDr,QueFirstReason=NULL
	 where Id=:QueID and QueStateDr<>:RetrunPersDr)
	 s desc=desc+SQLCODE
	q desc
}

/// 取消优先
ClassMethod CanclePrior(QueID, UserID)
{
	s UserID=$g(UserID)
	if UserID="" s UserID=%session.Get("LOGON.USERID")
	s CurDate=..%SysDate()
	s CurTime=..%SysTime()
	s desc=0
	&sql(select ID into :PriorDr from dhcfirstcode where firstcName='正常')
	s desc=desc+SQLCODE
	&sql(select ID into :PassStateID from dhcperstate where PersName='过号')
 	s desc=desc+SQLCODE
	&sql(select questatedr into :patStateDr from Dhcqueue  where Id=:QueID)
	i patStateDr=PassStateID d
	.s desc=desc+SQLCODE
	.&sql(update Dhcqueue set queFirstdr=:PriorDr,QueStateDate=:CurDate,QueStateTime=:CurTime,Operuserid=:UserID where Id=:QueID)
	e  d
	.s desc=desc+SQLCODE
	.&sql(update Dhcqueue set queFirstdr=:PriorDr,QueFirstReason=NULL where Id=:QueID)
	s desc=desc+SQLCODE
	q desc
}

/// 取消指定医生
ClassMethod CancleAdjConfirm(QueID, UserID)
{
	s QueStateDr=$lg(^User.DHCQueueD(QueID),14)
	s StatusPerName=$List(^User.DHCPerStateD(QueStateDr),4)
	s PAAdm=$List(^User.DHCQueueD(QueID),11)
	s PAADMAdmDocCodeDR=$p(^PAADM(PAAdm),"^",9) //就诊表中的初诊医生/挂号时的号别(医生)
	s QueDocDr=$List(^User.DHCQueueD(QueID),5) //队列表中的就诊医生/指定的医生
	s desc=0
	&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName='退号')
	&sql(select ID into :StateID from dhcperstate where PersName='等候')
	&sql(select ID into :StateID1 from dhcperstate where PersName='报到')
	if (StatusPerName="复诊")&&(PAADMAdmDocCodeDR'=QueDocDr){ //复诊指定为其他医生后，取消复诊时对列表修改为就诊医生
		&sql(update Dhcqueue set quedocdr=:PAADMAdmDocCodeDR,operuserid=:UserID where Id=:QueID)
	}else{
		&sql(update Dhcqueue set quedocdr=NULL,operuserid=:UserID where Id=:QueID)
	}
	s desc=desc+SQLCODE
	q desc
}

// into :MarkDesc,:MarkId

Query FindDocMark(ExaBorough As %String) As %SQLQuery(ROWSPEC = "MarkDesc:%String, MarkId:%String")
{
	select DepmMarkDr->CTPCP_Desc,DepmMarkDr from SQLUser.DHCDepMark where DepmBorDr=:ExaBorough group by DepmMarkDr
}

/// Create 20200107 by yl
/// 修改排班模板相关信息
/// Input： SessIdStr(排班id串) SessionType：(职称)
/// Output: 0(成功)  	Other(失败)
ClassMethod UpdateRBResSession(SessId As %String, SessionType As %String) As %String
{
	s ret=0
	q:(SessId="")!(SessionType="") "-100"
	s object = ##class(User.RBResEffDateSession).%OpenId(SessId)
	if $IsObject(object){
		d object.SESSSessionTypeDRSetObjectId(SessionType)
		s sc=object.%Save()
		if $$$ISERR(sc) {
			s ret="-101"
		}
		d object.%Close()
	}

	q ret
}

/// 根据Adm得到该挂号诊区ID及诊区配置
/// 诊区^需要报到^需要填写优先原因^开启查询后自动报到^未报到可就诊^开启报到产生队列号^开启报到迟到惩罚^开启过号惩罚
ClassMethod GetExaBordFlag(Adm)
{
	s ExabDr=""
	s QueID=$o(^User.DHCQueueI("QuePaadmDrIndex",Adm,""))
	i QueID'="" {
		s ExabDr=$list($g(^User.DHCQueueD(QueID)),6)
		if (ExabDr=""){
			s DepId=$List(^User.DHCQueueD(QueID),4)
			s MarkId=$List(^User.DHCQueueD(QueID),8)
			s ExabDrStr=##class(web.DHCOPAdmReg).GetExabInfo(DepId ,MarkId)
			s ExabDr=$P(ExabDrStr,"^",1)
			}
	}
	s rtn=""
	if (ExabDr'=""){
		s CheckIn=$lg(^User.DHCExaBoroughD(ExabDr),6)
		s FristReason=$lg(^User.DHCExaBoroughD(ExabDr),8)
		s AutoCheckIn=$lg(^User.DHCExaBoroughD(ExabDr),7)
		s UnCheckTo=$lg(^User.DHCExaBoroughD(ExabDr),9)
		s CreatQueueNo=$lg(^User.DHCExaBoroughD(ExabDr),10)
		s DelayQueueNo=$lg(^User.DHCExaBoroughD(ExabDr),11)
		s CallDelayQueueNo=$lg(^User.DHCExaBoroughD(ExabDr),12)
		s rtn=ExabDr_"^"_FristReason_"^"_AutoCheckIn_"^"_UnCheckTo_"^"_CreatQueueNo_"^"_DelayQueueNo_"^"_CallDelayQueueNo
		}
	q rtn
}

/// Desc:	判断用户是否对队列记录有报到权限
/// Input:	QueID:队列表ID 
/// 		UserID:操作用户ID 
/// 		Source:判断类型(可本地化判断，比如自助设备和护士分诊可能控制不同，可用此参数区分)
/// Output:	0 可报到  非0 不可报到
/// Debug:  w ##class(web.DHCAlloc).CheckOPAllocReport(331,1,"")
ClassMethod CheckOPAllocReport(QueID As %String, UserID As %String, ByRef ErrMsg As %String = "", Source As %String = "")
{
	if (UserID="")&&($d(%session)){
		s UserID=%session.Get("LOGON.USERID")
	}
	s ret=0
	if (QueID="")!(UserID=""){
		s ret="100"	
		s ErrMsg="QueID或UserID不能为空"
		Q ret
	}
	
	s ExaBorStr=""
	s ExaBorID=0
	for {
		s ExaBorID=$O(^User.DHCBorUserI("BoruUseDrIndex"," "_UserID,ExaBorID))
		Q:ExaBorID=""
		s BoruBorDr=$List(^User.DHCBorUserD(ExaBorID),2)
		continue:BoruBorDr=""
		i ExaBorStr="" {
			s ExaBorStr=BoruBorDr
		}else{
			s ExaBorStr=ExaBorStr_"^"_BoruBorDr
		}
	}
	if (ExaBorStr=""){
		s ret="-100"	
		s ErrMsg="操作用户未分配诊区分诊权限"
		Q ret
	}
	
	if '$d(^User.DHCQueueD(QueID)){
		s ret="-101"
		s ErrMsg="就诊队列ID对应数据不存在"
		Q ret
	}
	s QueExaBorDR=$List(^User.DHCQueueD(QueID),6)
	if QueExaBorDR=""{
		s ret="-102"
		s ErrMsg="该队列记录未取到相应诊区"
		Q ret
	}
	s QueExaBor=$List(^User.DHCExaBoroughD(QueExaBorDR),5)
	if ("^"_ExaBorStr_"^")'[("^"_QueExaBorDR_"^"){
		s ret="-103"
		s ErrMsg="该操作用户未分配"""_QueExaBor_"""报到权限"
		Q ret
	}
	
	s QueDate=$List(^User.DHCQueueD(QueID),3)
	if QueDate'=..%SysDate(){
		s ret="-104"
		s ErrMsg="非当天就诊记录不允许报到"
		Q ret
	} 
	
	s PAAdm=$List(^User.DHCQueueD(QueID),11)
	s VisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	if VisitStatus'="A"{
		s ret="-105"
		s ErrMsg="该记录对应就诊记录已退号"
		Q ret
	}
	
	s QueStateDr=$List(^User.DHCQueueD(QueID),14)
	if QueStateDr=""{
		s ret="-106"
		s ErrMsg="该记录对应队列状态异常"
		Q ret
	}
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	if " 报到 过号 到达 "'[(" "_status_" "){
		s ret="-107"
		s ErrMsg="该记录对应队列状态为"""_status_""",无需报到"
		Q ret
	}
	
	Q ret
}

/// 判断初次报到是否在报到时间之内
/// 0是 1不是
/// w ##class(web.DHCAlloc).CheckForReportRangeTime(2474)
ClassMethod CheckForReportRangeTime(AdmID, ByRef ErrMsg As %String = "")
{
	q:AdmID="" 0
	s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmID,0))
	q:RegfeeRowId="" 0
	s rtn=0
	s RegFeeRBASDr=$List(^User.DHCRegistrationFeeD(RegfeeRowId),18)
	s TimeRangeID=$List(^User.DHCRegistrationFeeD(RegfeeRowId),21)
	s QueueNo=$List(^User.DHCRegistrationFeeD(RegfeeRowId),8)
	s HospId=$P(##class(web.DHCOPAdmReg).GetCurrentHosp(AdmID,"","",""),"^",1)
	s NowTime=..%SysTime()
	s ConfigTimeRangeStr=##class(web.DHCOPRegConfig).GetGroupConfig(HospId,"TimeRangeReport",TimeRangeID)
	if (ConfigTimeRangeStr'=""){
		s UnSplitStartTime=$P($P(ConfigTimeRangeStr,"^",1),"!",2)
		s UnSplitEndTime=$P($P(ConfigTimeRangeStr,"^",2),"!",2)
		if (UnSplitStartTime'=""){
			s UnSplitStartTime=..%ZTH(UnSplitStartTime)
			if (NowTime<UnSplitStartTime ) s rtn=1,ErrMsg="未到报到时间"
		}
		q:rtn=1 rtn
		if (UnSplitEndTime'=""){
			s UnSplitEndTime=..%ZTH(UnSplitEndTime)
			if (NowTime>UnSplitEndTime ) s rtn=1,ErrMsg="已过报到时间"
		}
		q:rtn=1 rtn
		s TRFlag=$p(^RBAS(+RegFeeRBASDr,$P(RegFeeRBASDr,"||",2),"DHC"),"^",19)
		if (TRFlag="Y"){
			s OneEndNoBase=0,MastStartTime="",MastEndTime=""
			s ASTRSub=0 for {
				s ASTRSub=$O(^RBAS(+RegFeeRBASDr,$P(RegFeeRBASDr,"||",2),"ASTR",ASTRSub))
				q:ASTRSub=""
				s starttime=$P(^RBAS(+RegFeeRBASDr,$P(RegFeeRBASDr,"||",2),"ASTR",ASTRSub),"^",1)
				s endtime=$P(^RBAS(+RegFeeRBASDr,$P(RegFeeRBASDr,"||",2),"ASTR",ASTRSub),"^",2)
				s TRLoad=$P(^RBAS(+RegFeeRBASDr,$P(RegFeeRBASDr,"||",2),"ASTR",ASTRSub),"^",3)
				s OneSttNo=OneEndNoBase+1,OneEndNo=OneEndNoBase+TRLoad
				s OneEndNoBase=OneEndNoBase+TRLoad
				if ((QueueNo>=OneSttNo)&&(QueueNo<=OneEndNo)){
					s MastStartTime=starttime
					s MastEndTime=endtime
					q
				}
			}
			s SplitStartTimelist=$P($P(ConfigTimeRangeStr,"^",3),"!",2)
			s SplitStartTime=$P($P(ConfigTimeRangeStr,"^",4),"!",2)
			s SplitEndTimelist=$P($P(ConfigTimeRangeStr,"^",5),"!",2)
			s SplitEndTime=$P($P(ConfigTimeRangeStr,"^",6),"!",2)
			if ((SplitStartTimelist'="")&&(SplitStartTime'="")&&(MastStartTime'="")){
				if (SplitStartTimelist=1) s MastStartTime=MastStartTime-(60*SplitStartTime)
				if (SplitStartTimelist=2) s MastStartTime=MastStartTime+(60*SplitStartTime)
				if (NowTime<MastStartTime ) s rtn=1,ErrMsg="未到报到时间"
			}
			q:rtn=1 rtn
			if ((SplitEndTimelist'="")&&(SplitEndTime'="")&&(MastEndTime'="")){
				if (SplitEndTimelist=1) s MastEndTime=MastEndTime-(60*SplitEndTime)
				if (SplitEndTimelist=2) s MastEndTime=MastEndTime+(60*SplitEndTime)
				if (NowTime>MastEndTime ) s rtn=1,ErrMsg="已过报到时间"
			}
			q:rtn=1 rtn
		}	
	}
	q rtn
}

ClassMethod GetAdmQueueState(EpisodeID)
{
	s PerStatus=""
	&SQL(SELECT QueStateDr->PersName INTO :PerStatus FROM SQLUser.DHCQueue WHERE QuePaadmDr=:EpisodeID)
	Q PerStatus
}

/// Desc:根据排班ID获取当前的等候就诊人数
/// Input:ASRowId 排班ID
/// Output:Sum 待诊人数(复诊 等候 过号 报到)
/// w ##class(web.DHCAlloc).GetAdmWaitSum("101||12")
ClassMethod GetAdmWaitSum(ASRowId)
{
	s Sum=0
	s (QueueID,Zone)=""
	s DeptDr=$p(^RB("RES",+ASRowId),"^",1)
	s DocMarkDr=$p(^RB("RES",+ASRowId),"^",2)
	s AsDate=$P($G(^RBAS(+ASRowId,$p(ASRowId,"||",2))),"^",1)
	s SSUserID=$o(^SSU("SSUSR",0,"CTPCP",DocMarkDr,"")) 
	s StateID="^1^2^3^7^" ;复诊 等候 过号 报到
	s ID="" f  s ID=$O(^User.DHCQueueI("QueMarkDrIndex",AsDate,DocMarkDr,ID)) q:ID=""  d
	.s QueDeptDr=$List(^User.DHCQueueD(ID),4)
	.Q:(QueDeptDr'=DeptDr)
	.s QueStateDr=$List(^User.DHCQueueD(ID),14)
	.Q:(StateID'[("^"_QueStateDr_"^"))
	.s Sum=Sum+1
	Q Sum
}

/// w ##class().GetArriveTimeByAdmNo(AdmNo)
/// "2023-09-05 17:09:10"
ClassMethod GetArriveTimeByAdmNo(AdmNo) As %String
{
	s RowId=0
    s AdmRowId=$o(^PAADMi("No",AdmNo,RowId))
    s RowId=0
    s QueDr=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmRowId,RowId))

    ;s QueArriveDate=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",1)
    ;s QueArriveTime=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",2)
    s QueArriveTime=""
    s QueChangeSub=""
    f  {
        s QueChangeSub=$O(^DHCQueueStatus(QueDr,QueChangeSub),-1)
        Q:(QueChangeSub="")||(QueArriveTime'="")
        s QueChangeStatuDr=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",4)
        continue:QueChangeStatuDr=""
        s QueChangeBeforeStatuDr=""
        //上条变化是报道且本次状态是等候
        s QueChangeBeforeSub=$O(^DHCQueueStatus(QueDr,QueChangeSub),-1)
        s QueChangeBeforeStatuDesc=""
        if (QueChangeBeforeSub'=""){
            s QueChangeBeforeStatuDr=$P($G(^DHCQueueStatus(QueDr,QueChangeBeforeSub)),"^",4)
            continue:QueChangeBeforeStatuDr=""
            s QueChangeBeforeStatuDesc=$list(^User.DHCPerStateD(QueChangeBeforeStatuDr),4)
        }
        //continue:QueChangeBeforeStatuDesc=""
        s QueChangeStatuDesc=$list(^User.DHCPerStateD(QueChangeStatuDr),4)
        //*if (QueChangeStatuDesc="等候")&&(QueChangeBeforeStatuDesc="报到"){
            s QueArriveDate=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",1)
            s QueArriveTime=$P($G(^DHCQueueStatus(QueDr,QueChangeSub)),"^",2)
            s QueArriveTime = ..%ZD(QueArriveDate)_" "_..%ZT(QueArriveTime)
        //}
    }
 	q QueArriveTime
}

}
