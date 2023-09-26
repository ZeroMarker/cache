/// CTOR: QP
/// DATE: 2020-06-30
/// DESC: 化疗日期表
Class DHCDoc.Chemo.BS.Date Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-01
/// DESC: 保存
/// IN  : 	
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).Save("")
ClassMethod Save(PDAry, SaveAll = "")
{
	s mRtn=0
	s PDNum=$o(PDAry(""),-1)
	Q:PDNum="" mRtn
	S PSID=PDAry(3)
	s SelectDate=PDAry(6)
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	i SaveAll=1 {
		s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",21)
	} else {
		s ChemoDate=SelectDate
	}
	Q:ChemoDate="" "-128"
	f i=1:1:$l(ChemoDate,",") {
		Q:mRtn<0
		s PDDate=$P(ChemoDate,",",i)
		s PDDate=##class(websys.Conversions).DateHtmlToLogical(PDDate)
		i PDDate=SelectDate {
			s PDID=PDAry(1)
		} else {
			s PDID=..GetPDIDByDate(PDDate,PSID)
			//continue:PDID'=""
			i PDID'="" {
				s CurrentPDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
				//continue:PDID'="R"	
			}
			
			
		}  
		s oldStatus=""
		i PDID="" {
			s a=##class(User.ChemoPlanDate).%New()
			d a.PDPLIDSetObjectId(PDAry(2))
			d a.PDPSIDSetObjectId(PDAry(3))
			d a.PDPatientDRSetObjectId(PDAry(4))
			//s PDDate=PDAry(6)
			//s PDDate=##class(websys.Conversions).DateHtmlToLogical(PDDate)
			s a.PDDate=PDDate
			s a.PDStatus="N"
			
		} else{
			s a=##class(User.ChemoPlanDate).%OpenId(PDID)
			s oldStatus=a.PDStatus
			i oldStatus="R" s a.PDStatus="N"
		}
		d a.PDAdmDRSetObjectId(PDAry(5))
		s a.PDOnTime=PDAry(7)
		s a.PDDelayReason=PDAry(8)
		s a.PDToDate=PDAry(9)
		s a.PDHeight=PDAry(10)
		s a.PDWeight=PDAry(11)
		s a.PDTemperature=PDAry(12)
		s a.PDBlood=PDAry(13)
		s a.PDPulse=PDAry(14)
		s a.PDOxygen=PDAry(15)
		s a.PDECOG=PDAry(16)
		s a.PDKQScore=PDAry(17)
		s a.PDDataSR=PDAry(18)
		s a.PDBSA=PDAry(19)
		s a.PDGFR=PDAry(20)
		s a.PDSC=PDAry(21)
		s a.PDGMiSFill=PDAry(22)
		s a.PDExamNote=PDAry(23)
		s a.PDPlanTime=PDAry(24)
		s a.PDUpdateDate=+$h
		s a.PDUpdateTime=$p($H,",",2)
		d a.PDUpdateLocSetObjectId(PDAry(25))
		d a.PDUpdateUserSetObjectId(PDAry(26))
		d a.PDNeedLocSetObjectId(PDAry(27))
		d a.PDNeedUserSetObjectId(PDAry(28))
		s a.PDHasGMis=PDAry(29)
		
		/*s ATNum=$o(ATAry(""),-1)
		s CDate=+$h,CTime=$p($H,",",2)
		i ATNum'="" {
			if (oldStatus="") {
				s a.PDApplyDate=CDate
				s a.PDApplyTime=CTime
				d a.PDNeedLocSetObjectId(ATAry(1))
				d a.PDNeedUserSetObjectId(ATAry(2))
				s a.PDStatus=ATAry(3)
				d a.PDApplyLocSetObjectId(ATAry(4))
				d a.PDApplyUserSetObjectId(ATAry(5))
			}
		}*/
		i '$ISObject(a) {
			s mRtn= -128
			Q
		}
		s sc=a.%Save()
		if ($$$ISERR(sc)) {
			//d $System.Status.DisplayError(sc)
			s mRtn=-128
			Q
		} else {
			s mRtn=a.%Id()
		}
		d a.%Close()
		
		/*Q:mRtn<=0 mRtn
		//发送消息
		i ATNum'="" {
			if (oldStatus="") {
				s UserID=ATAry(5)
				s LocID=ATAry(4)
				s mRtn=##class(DHCDoc.Chemo.BS.Ext.Message).Send("APP",mRtn,UserID,LocID,"A")
				i mRtn'=1 s mRtn=-132
				
			}
		}*/
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-06
/// DESC: 变更日期表状态
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).ChgStatus("")
ClassMethod ChgStatus(PDID As %String, mList = "")
{
	Q:PDID="" 0
	
	s user=$p(mList,$C(1),1)
	s loc=$p(mList,$C(1),2)
	s status=$p(mList,$C(1),3)
	s cDate=$P($H,",",1)
	s cTime=$P($H,",",2)
	
	&SQL(
		UPDATE SQLUser.Chemo_PlanDate
		SET PD_UpdateDate=:cDate,PD_UpdateTime=:cTime,
			PD_UpdateUser=:user,PD_UpdateLoc=:loc,
			PD_Status=:status
		WHERE PD_ID=:PDID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-07-14
/// DESC: 是否已经审核
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).HasPass("2020-07-14","39||1")
ClassMethod HasPass(PlanDate, PSID)
{
	s mRtn=0
	s ^QP("HasPass")=$LB(PlanDate, PSID)
	Q:(PlanDate=""||PSID="") mRtn
	s PlanDate=##class(websys.Conversions).DateHtmlToLogical(PlanDate)
	s id=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,PlanDate,""))
	q:id="" mRtn
	s status=$p(^BS.DOC.Chemo.PlanDateD(id),"^",23)
	i status="Y" s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-16
/// DESC: 作废化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).Stop("12239","175","27","398")
ClassMethod Cancel(UserID, PDID, PatientID, EpisodeID)
{
	Q:PDID="" -144
	s ^QP("Stop")=$lb(UserID, PDID, PatientID, EpisodeID)
	s PDAID=##class(DHCDoc.Chemo.BS.DateApply).GetPDAID(PDID)
	;Q:PDAID="" -134
	i PDAID'="" {
		s rtn=##class(DHCDoc.Chemo.BS.Order).StopDate(PDAID,UserID)
		Q:rtn'=0 "-145"
	}
	s Status="C"
	&SQL(
		UPDATE SQLUser.Chemo_PlanDate SET PD_Status=:Status WHERE PD_ID=:PDID
	)
	
	Q:SQLCODE'=0 "-144"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-08-07
/// DESC: 停止化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).Stop("12239","175","27","398")
ClassMethod Stop(UserID, PDID, PatientID, EpisodeID)
{
	Q:PDID="" -134
	s ^QP("Stop")=$lb(UserID, PDID, PatientID, EpisodeID)
	s PDAID=##class(DHCDoc.Chemo.BS.DateApply).GetPDAID(PDID)
	;Q:PDAID="" -134
	i PDAID'="" {
		Q -149
		//
		s rtn=##class(DHCDoc.Chemo.BS.Order).StopDate(PDAID,UserID)
		Q:rtn'=0 "-126"
	}
	s Status="S"
	&SQL(
		UPDATE SQLUser.Chemo_PlanDate SET PD_Status=:Status WHERE PD_ID=:PDID
	)
	
	Q:SQLCODE'=0 "-134"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-08-07
/// DESC: 获取PDID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate("2020-08-11","79||1")
ClassMethod GetPDIDByDate(PlanDate, PSID)
{
	Q:PlanDate="" ""
	s PlanDate=##class(websys.Conversions).DateHtmlToLogical(PlanDate)
	s PDID=$O(^BS.DOC.Chemo.PlanDateI("PSID",PSID,PlanDate,""))
	
	Q PDID
}

/// CTOR: QP
/// DATE: 2020-11-02
/// DESC: 停止后停止化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).Stop("12239","175","27","398")
ClassMethod SaveAndStop(PDAry, UserID, PatientID, EpisodeID)
{
	TS
	s PDID=..Save(.PDAry)
	i PDID<=0 {
		TRO
		Q -148
	}
	s rtn=..Stop(UserID,PDID,PatientID,EpisodeID)
	i rtn<0 {
		TRO
		Q rtn	
	}
	TC
	Q rtn
}

/// CTOR: QP
/// DATE: 2020-12-09
/// DESC: 变更关联日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).ChgLinkDate("")
ClassMethod ChgLinkDate(PDID As %String, LinkDate = "")
{
	Q:(PDID="")||(LinkDate="") 0
	s PDate=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",5)
	s LinkDateNew=""
	f i=1:1:$l(LinkDate,",") {
		s date=$p(LinkDate,",",i)
		continue:date=PDate
		i LinkDateNew="" s LinkDateNew=date
		e  s LinkDateNew=LinkDateNew_","_date
	}
	
	&SQL(
		UPDATE 
			SQLUser.Chemo_PlanDate
		SET 
			PD_LinkDate=:LinkDateNew
		WHERE PD_ID=:PDID
	)
	
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-12-09
/// DESC: 变更关联申请ID
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Date).ChgLinkPDAID("")
ClassMethod ChgLinkPDAID(PDAID As %String, LinkPDAID = "")
{
	Q:(PDAID="")||(LinkPDAID="") 0
	
	&SQL(
		UPDATE 
			SQLUser.Chemo_PlanDateApply
		SET 
			PDA_LinkPDAID=:LinkPDAID
		WHERE PDA_ID=:PDAID
	)
	
	Q SQLCODE
}

}
