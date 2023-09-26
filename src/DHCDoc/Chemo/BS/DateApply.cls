/// CTOR: QP
/// DATE: 2020-08-07
/// DESC: 化疗日期申请业务类
Class DHCDoc.Chemo.BS.DateApply Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-10-15
/// DESC: 得到阶段显示的日期
/// IN  : ShowFlag： 空html格式，1，日期+描述格式，2日期格式
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage("20||1","","","N",2)
ClassMethod GetDateByStage(PSID, IsView = "", InExt = "", Status = "", ShowFlag = "")
{
	s ^QP("HH",1)=$LB(PSID, IsView , InExt)
	s mRtn="",nRtn="",mRtn2=""
	s CDate=+$h
	s PLID=+PSID,SID=$P(PSID,"||",2)
	s startDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)
	s chemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",21)
	Q:chemoDate="" mRtn
	s chemoDate=##class(DHCDoc.Chemo.COM.Func2).DoChemoDate(chemoDate)
	f i=1:1:$l(chemoDate,",") d
	.s date=$p(chemoDate,",",i)
	.s date=##class(websys.Conversions).DateHtmlToLogical(date)
	.s PDID=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,date,""))
	.s PDStatus=""
	.i PDID'="" s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
	.;Q:PDStatus="N"	;初始状态退出
	.Q:(Status'="")&&(PDStatus'=Status)
	.s statusDesc=##class(DHCDoc.Chemo.COM.Func2).GetDateStatus(PDStatus)
	.s datecolor=##class(DHCDoc.Chemo.COM.Func2).GetDateColor(PDStatus)
	.s dateHTML=##class(websys.Conversions).DateLogicalToHtml(date)
	.s statusDesc=statusDesc_"，"_dateHTML
	.i statusDesc'="" s displayText="<span style='color:"_datecolor_";'>Day"_((date-startDate)+1)_" ("_statusDesc_")</span>"
	.e  s displayText="<span style='color:"_datecolor_";'>Day"_((date-startDate)+1)_"</span>"
	.s Record=date_","_PDStatus_","_PDID_","_displayText
	.i mRtn="" s mRtn=Record
	.e  s mRtn=mRtn_"^"_Record
	.s nDesc="Day"_((date-startDate)+1)
	.i nRtn="" s nRtn=date_","_nDesc
	.e  s nRtn=nRtn_"^"_date_","_nDesc
	.i mRtn2="" s mRtn2=date
	.e  s mRtn2=mRtn2_","_date
	i ShowFlag=1 {
		Q nRtn
	} elseif(ShowFlag=2) {
		Q mRtn2
	} else {
		Q mRtn
	}
}

/// CTOR: QP
/// DATE: 2020-08-07
/// DESC: 得到所选阶段有过申请的日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage("104||1")
ClassMethod GetDateByStageOld(PSID, IsView = "", InExt = "")
{
	s mRtn=""
	s ^QP("GetDateByStage",1)=$LB(PSID,IsView,InExt)
	Q:PSID="" mRtn
	s PLID=+PSID,Sub=$p(PSID,"||",2)
	s startDate=$p(^BS.DOC.Chemo.PlanD(PLID,Sub),"^",3)
	s CDate=+$h
	s CFlag=0
	s date=""
	f  s date=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,date)) q:date=""  d
	.s PDID=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,date,""))
	.q:PDID=""
	.s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
	.Q:PDStatus="N"	;初始状态退出
	.s statusDesc=##class(DHCDoc.Chemo.COM.Func2).GetDateStatus(PDStatus)
	.s datecolor=##class(DHCDoc.Chemo.COM.Func2).GetDateColor(PDStatus)
	.i date=CDate s CFlag=1
	.i statusDesc'="" s displayText="<span style='color:"_datecolor_";'>Day"_((date-startDate)+1)_" ("_statusDesc_")</span>"
	.e  s displayText="<span style='color:"_datecolor_";'>Day"_((date-startDate)+1)_"</span>"
	.s Record=date_","_PDStatus_","_PDID_","_displayText
	.i mRtn="" s mRtn=Record
	.e  s mRtn=mRtn_"^"_Record
	
	i (CFlag=0)&&(IsView'=1) d
	.s CInfo=""
	.s PDID=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,CDate,""))
	.i PDID="" d
	..s statusDesc="未保存"	//	未开立
	..s displayText="Day"_((CDate-startDate)+1)_" ("_statusDesc_")"
	..s CInfo=CDate_",,"_","_displayText
	.e  d
	..s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
	..s statusDesc=##class(DHCDoc.Chemo.COM.Func2).GetDateStatus(PDStatus)
	..s displayText="Day"_((CDate-startDate)+1)_" ("_statusDesc_")"
	..s CInfo=CDate_","_PDStatus_","_PDID_","_displayText
	.i mRtn="" s mRtn=CInfo
	.e  s mRtn=mRtn_"^"_CInfo
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 发送申请
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).Save(^QP("hh",1))
ClassMethod Save(PDAList)
{
	s ^QP("hh",1)=PDAList
	s oeori=$p(PDAList,$c(1),1)
	s startdate=$p(PDAList,$c(1),2)
	s PGIID=$p(PDAList,$c(1),3)
	s Adm=$p(PDAList,$c(1),4)
	s User=$p(PDAList,$c(1),5)
	s Loc=$p(PDAList,$c(1),6)
	s ChemoContainDay=$p(PDAList,$c(1),7)
	s LinkDate=ChemoContainDay
	s PLID=$p(PGIID,"||",1)
	s PSID=PLID_"||"_$p(PGIID,"||",2)
	
	s POID=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:POID="" -136
	;
	s startdate=##class(websys.Conversions).DateHtmlToLogical(startdate)
	i ChemoContainDay="" s ChemoContainDay=startdate
	e  s ChemoContainDay=startdate_","_ChemoContainDay
	;
	s mRtn=1	;
	s FirstPDAID="",LinkPDAID=""
	f i=1:1:$l(ChemoContainDay,",") {
		s CDate=$p(ChemoContainDay,",",i)
		i i=1 {
			;保存医嘱开始日期的申请
			;保存关联日期表
			;d ##class(DHCDoc.Chemo.BS.Date).ChgLinkDate(PDID,LinkDate)
			
		} else {
			continue:CDate=startdate
		}
		
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(CDate,PSID)
		i PDID="" {
			s mRtn=-136	
			Q 
		}
		s HasPDAID=..GetPDAID(PDID)
		i HasPDAID'="" {
			i i=1 {
				s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgPDAID(POID,HasPDAID)	//变更PDAID
			} else {
				s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgLinkPDAID(POID,HasPDAID)	//变更PDAID
			}
			
		}
		continue:(..HasApply(PDID)=1) 	//已存在有效申请，退出
		s NeedLoc=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",30)
		s NeedUser=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",29)
		s ID=""
		i ID="" {
			s a=##class(User.ChemoPlanDateApply).%New(PDID)
			d a.PDAParRefSetObjectId(PDID)
			s a.PDAApplyDate=+$h
			s a.PDAApplyTime=$p($h,",",2)
			d a.PDANeedLocSetObjectId(NeedLoc)
			d a.PDANeedUserSetObjectId(NeedUser)
			d a.PDAApplyUserSetObjectId(User)
			d a.PDAApplyLocSetObjectId(Loc)
			s a.PDAStatus="A"
		} else{
			s a=##class(User.ChemoPlanDateApply).%OpenId(ID)
			s a.PDAStatus=""
		}
		
		s a.PDAAuditDate=+$H
		s a.PDAAuditTime=$p($h,",",2)
		d a.PDAAuditUserSetObjectId(User)
		d a.PDAAuditLocSetObjectId(Loc)
		i '$ISObject(a) {
			s mRtn=-136
			continue
		}
		s sc=a.%Save()
		if ($$$ISERR(sc)) {
			//d $System.Status.DisplayError(sc)
			s mRtn=-136
		} else {
			s mRtn=a.%Id()
		}
		d a.%Close()
		
		i mRtn<=0 {
			Q
		}
		s PDAID=mRtn
		//底下这部分，先不做事务回滚的处理，后期在考虑优化
		i i=1 {
			s FirstPDAID=PDAID
			s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgPDAID(POID,PDAID)	//变更PDAID
		} else {
			i LinkPDAID="" s LinkPDAID=PDAID
			e  s LinkPDAID=LinkPDAID_","_PDAID
			s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgLinkPDAID(POID,PDAID)	//变更PDAID
		}
		//s ^QP("LOG","DateApply.Save","ChgPDAID",oeori)=$LB(POID,PDAID,oeori)
		i mRtn'=0 {s mRtn=-132}
		s mList=User_$C(1)_Loc_$C(1)_"A"
		s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,mList)	//变更日期状态表
		//s ^QP("LOG","DateApply.Save","ChgStatus")=mRtn
		i mRtn'=1 s mRtn=-132
		i i=1 {
			s mRtn=##class(DHCDoc.Chemo.BS.Ext.Message).Send("APP",PDAID,User,Loc,"A")	//发消息
		}
		//s ^QP("LOG","DateApply.Save","SendMessage")=mRtn
		i mRtn'=1 s mRtn=-132
	
	}
	//
	;保存关联日期申请表
	d ##class(DHCDoc.Chemo.BS.Date).ChgLinkPDAID(FirstPDAID,LinkPDAID)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 是否存在有效的申请
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).GetPDAID(77)
ClassMethod GetPDAID(PDID = "")
{
	s mRtn=""
	Q:PDID="" mRtn
	s Sub=""
	f  s Sub=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub)) q:(Sub="")||(mRtn'="")  d
	.s status=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",3)
	.;q:status["R"
	.q:(status["R")||(status["C")
	.s mRtn=PDID_"||"_Sub
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-02-07
/// DESC: 获取申请状态
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).GetPDStatus(514)
ClassMethod GetPDStatus(PDID = "")
{
	s mRtn=""
	Q:PDID="" mRtn
	Q:'$D(^BS.DOC.Chemo.PlanDateD(PDID,"A")) mRtn
	s sub=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",""),-1)
	s mRtn=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",3)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 是否存在有效的申请
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).HasApply(77)
ClassMethod HasApply(PDID = "")
{
	s flag=0
	Q:PDID="" flag=0
	s status=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
	Q:status="S" "-1"
	Q:status="U" "-2"
	s Sub=""
	f  s Sub=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub)) q:(Sub="")||(flag=1)  d
	.s status=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",Sub),"^",3)
	.q:(status["R")||(status["C")
	.s flag=1
	
	Q flag
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 得到本次申请所有的医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).GetApplyOrder("464||1")
ClassMethod GetApplyOrder(PDAID)
{
	s mRtn=""
	Q:PDAID="" mRtn
	
	s PDID=+PDAID
	s POID=""
	f  s POID=$O(^BS.DOC.Chemo.PlanOrderI("PDAID",PDAID,POID)) Q:POID=""  d
	.s xDate=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",3)
	.s PGIID=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	.s oeori=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",1)
	.i mRtn="" s mRtn=oeori
	.e  s mRtn=mRtn_"^"_oeori
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 得到本次申请所有的医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).GetApplyOrder("464||1")
ClassMethod GetApplyOrderNew(PDAID)
{
	s mRtn=""
	Q:PDAID="" mRtn
	
	s node=""
	i $d(^BS.DOC.Chemo.PlanOrderI("PDAID",PDAID)) {
		s node="PDAID"	
	} else {
		i $d(^BS.DOC.Chemo.PlanOrderI("LinkPDAID",PDAID)) {
			s node="LinkPDAID"	
		}
	}
	Q:node="" mRtn
	
	s PDID=+PDAID
	s POID=""
	f  s POID=$O(^BS.DOC.Chemo.PlanOrderI(node,PDAID,POID)) Q:POID=""  d
	.s xDate=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",3)
	.s PGIID=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	.s oeori=$p(^BS.DOC.Chemo.PlanOrderD(POID),"^",1)
	.i mRtn="" s mRtn=oeori
	.e  s mRtn=mRtn_"^"_oeori
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-04
/// DESC: 保存本次医嘱其它日期(ContainDay)的申请
/// IN  : 
/// OUT : 1 成功，<0 失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).SaveContainDayApply("77||10")
ClassMethod SaveContainDayApply(PDAList)
{
	Q:PDAList="" 1
	s oeori=$p(PDAList,$c(1),1)
	s StartDate=$p(PDAList,$c(1),2)
	s PGIID=$p(PDAList,$c(1),3)
	s Adm=$p(PDAList,$c(1),4)
	s User=$p(PDAList,$c(1),5)
	s Loc=$p(PDAList,$c(1),6)
	s ContainDay=$p(PDAList,$c(1),7)
	s PLID=$p(PGIID,"||",1)
	s PSID=PLID_"||"_$p(PGIID,"||",2)
	
	Q:(StartDate="")||(ContainDay="") 1
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s mRtn=1
	f i=1:1:$l(ContainDay,",") {
		Q:mRtn'=1
		s CDate=$p(ContainDay,",",i)
		continue:CDate=StartDate
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(CDate,PSID)
		continue:PDID=""
		s HasPDAID=..GetPDAID(PDID)
		i HasPDAID'="" {
			s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgPDAID(POID,HasPDAID)	//变更PDAID
		}
		continue:(..HasApply(PDID)=1) 	//已存在有效申请，退出
		s NeedLoc=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",30)
		s NeedUser=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",29)
		s ID=""
		i ID="" {
			s a=##class(User.ChemoPlanDateApply).%New(PDID)
			d a.PDAParRefSetObjectId(PDID)
			s a.PDAApplyDate=+$h
			s a.PDAApplyTime=$p($h,",",2)
			d a.PDANeedLocSetObjectId(NeedLoc)
			d a.PDANeedUserSetObjectId(NeedUser)
			d a.PDAApplyUserSetObjectId(User)
			d a.PDAApplyLocSetObjectId(Loc)
			s a.PDAStatus="A"
		} else{
			s a=##class(User.ChemoPlanDateApply).%OpenId(ID)
			s a.PDAStatus=""
		}
		
		s a.PDAAuditDate=+$H
		s a.PDAAuditTime=$p($h,",",2)
		d a.PDAAuditUserSetObjectId(User)
		d a.PDAAuditLocSetObjectId(Loc)
		continue:'$ISObject(a)
		s sc=a.%Save()
		if ($$$ISERR(sc)) {
			//d $System.Status.DisplayError(sc)
			s mRtn=-153
		} else {
			s mRtn=1	//a.%Id()
		}
		d a.%Close()
		
	}
	
	Q mRtn
	
	s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgPDAID(POID,PDAID)	//变更PDAID
	s ^QP("LOG","DateApply.Save","ChgPDAID",oeori)=$LB(POID,PDAID,oeori)
	i mRtn'=0 s mRtn=-132
	s mList=User_$C(1)_Loc_$C(1)_"A"
	s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,mList)	//变更日期状态表
	s ^QP("LOG","DateApply.Save","ChgStatus")=mRtn
	i mRtn'=1 s mRtn=-132
	s mRtn=##class(DHCDoc.Chemo.BS.Ext.Message).Send("APP",PDAID,User,Loc,"A")	//发消息
	s ^QP("LOG","DateApply.Save","SendMessage")=mRtn
	i mRtn'=1 s mRtn=-132
	s ^QP("hh",3)=$LB(POID,PDAID)
	s ^QP("hh",2)=mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 发送申请
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).Save(^QP("hh",1))
ClassMethod SaveOld(PDAList)
{
	s ^QP("hh",1)=PDAList
	s oeori=$p(PDAList,$c(1),1)
	s startdate=$p(PDAList,$c(1),2)
	s PGIID=$p(PDAList,$c(1),3)
	s Adm=$p(PDAList,$c(1),4)
	s User=$p(PDAList,$c(1),5)
	s Loc=$p(PDAList,$c(1),6)
	s ChemoContainDay=$p(PDAList,$c(1),7)
	s PLID=$p(PGIID,"||",1)
	s PSID=PLID_"||"_$p(PGIID,"||",2)
	
	s POID=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	B ;001
	Q:POID="" -136
	
	s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(startdate,PSID)
	B ;002
	Q:PDID="" -136
	s HasPDAID=..GetPDAID(PDID)
	i HasPDAID'="" {
		s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgPDAID(POID,HasPDAID)	//变更PDAID
	}
	q:(..HasApply(PDID)=1) 0	//已存在有效申请，退出
	s NeedLoc=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",30)
	s NeedUser=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",29)
	s ID=""
	i ID="" {
		s a=##class(User.ChemoPlanDateApply).%New(PDID)
		d a.PDAParRefSetObjectId(PDID)
		s a.PDAApplyDate=+$h
		s a.PDAApplyTime=$p($h,",",2)
		d a.PDANeedLocSetObjectId(NeedLoc)
		d a.PDANeedUserSetObjectId(NeedUser)
		d a.PDAApplyUserSetObjectId(User)
		d a.PDAApplyLocSetObjectId(Loc)
		s a.PDAStatus="A"
	} else{
		s a=##class(User.ChemoPlanDateApply).%OpenId(ID)
		s a.PDAStatus=""
	}
	
	s a.PDAAuditDate=+$H
	s a.PDAAuditTime=$p($h,",",2)
	d a.PDAAuditUserSetObjectId(User)
	d a.PDAAuditLocSetObjectId(Loc)
	Q:'$ISObject(a) -136
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		//d $System.Status.DisplayError(sc)
		s mRtn=-136
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q:mRtn<=0 mRtn
	s PDAID=mRtn
	//底下这部分，先不做事务回滚的处理，后期在考虑优化
	s mRtn=##class(DHCDoc.Chemo.BS.Order).ChgPDAID(POID,PDAID)	//变更PDAID
	s ^QP("LOG","DateApply.Save","ChgPDAID",oeori)=$LB(POID,PDAID,oeori)
	i mRtn'=0 s mRtn=-132
	s mList=User_$C(1)_Loc_$C(1)_"A"
	s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,mList)	//变更日期状态表
	s ^QP("LOG","DateApply.Save","ChgStatus")=mRtn
	i mRtn'=1 s mRtn=-132
	s mRtn=##class(DHCDoc.Chemo.BS.Ext.Message).Send("APP",PDAID,User,Loc,"A")	//发消息
	s ^QP("LOG","DateApply.Save","SendMessage")=mRtn
	i mRtn'=1 s mRtn=-132
	s ^QP("hh",3)=$LB(POID,PDAID)
	s ^QP("hh",2)=mRtn
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 插入一条记录
/// IN  : 
/// OUT : 0成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApply).ChgStatus(PDAID,UserID,Loc,Status)
ClassMethod ChgStatus(PDAID, UserID, Loc, Status)
{
	
	s CDate=+$H
	s CTime=$P($H,",",2)
	&SQL(
			UPDATE SQLUser.Chemo_PlanDateApply
			SET PDA_AuditDate=:CDate,PDA_AuditTime=:CTime,
				PDA_Status=:Status,PDA_AuditUser=:UserID,PDA_AuditLoc=:Loc
			WHERE PDA_ID=:PDAID
		)
		q SQLCODE
}

}
