/// CTOR: QP
/// DATE: 2020-06-27
/// DESC: 化疗单医嘱
Class DHCDoc.Chemo.BS.Order Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-27
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).Save("903||1")
ClassMethod Save(mList, ID = "")
{
	i ID="" {
		s a=##class(User.ChemoPlanOrder).%New()
	} else {
		s a=##class(User.ChemoPlanOrder).%OpenId(ID)
	}
	// mList=oeitm_$c(1)_startdate_$c(1)_PGIID_$c(1)_Adm_$c(1)_ARCIMRowid
	s OEORI=$p(mList,$c(1),1)
	s PlanDate=$p(mList,$c(1),2)
	s PGIID=$p(mList,$c(1),3)
	s Admid=$p(mList,$c(1),4)
	s Arcim=$p(mList,$c(1),5)
	s PatientDR=$P(^PAADM(Admid),"^",1)
	s PlanDate=##class(websys.Conversions).DateHtmlToLogical(PlanDate)
	s CDate=+$h
	s CTime=$p($h,",",2)
	s a.POXDate=PlanDate
	d a.POOeoriSetObjectId(OEORI)
	d a.POPlanItemDRSetObjectId(PGIID)
	d a.POArcimSetObjectId(Arcim)
	d a.POAdmSetObjectId(Admid)
	d a.POPatientDRSetObjectId(PatientDR)
	s a.POInsertDate=CDate
	s a.POInsertTime=CTime
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-118"
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 停止化疗方案
/// IN  : 
/// OUT : 0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).Stop()
ClassMethod Stop(UserID, InPLID, PatientID, EpisodeID)
{
	s mRtn=0
	Q:PatientID="" -126
	s OrdList=""
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanOrderI("PatientDR",PatientID,id)) q:id=""  d
	.s itemDR=$P(^BS.DOC.Chemo.PlanOrderD(id),"^",2)
	.q:itemDR=""
	.s PLID=+itemDR
	.q:InPLID'=PLID
	.s oeori=$P(^BS.DOC.Chemo.PlanOrderD(id),"^",1)
	.Q:oeori=""
	.s ord=+oeori,sub=$p(oeori,"||",2)
	.s prescno=$p(^OEORD(ord,"I",sub,1),"^",14)
	.s isAudit=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	.q:isAudit="Y"
	.i OrdList="" s OrdList=oeori
	.e  s OrdList=OrdList_"^"_oeori
	
	i OrdList'="" {
		s mRtn=##class(appcom.OEOrdItem).StopMulti(OrdList,UserID,"","N")
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 更新PDAID
/// IN  : 
/// OUT : 0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).ChgPDAID()
ClassMethod ChgPDAID(POID, PDAID)
{
	Q:(POID="")||(PDAID="") 0
	&SQL(
		UPDATE SQLUser.Chemo_PlanOrder SET PO_PDAID=:PDAID WHERE PO_ID=:POID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 更新LinkPDAID
/// IN  : 
/// OUT : 0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).ChgPDAID()
ClassMethod ChgLinkPDAID(POID, LinkPDAID)
{
	Q:(POID="")||(LinkPDAID="") 0
	s oldLinkPDAID=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",10)
	s ItemDR=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	s NewLinkPDAID=LinkPDAID
	i oldLinkPDAID'="" s NewLinkPDAID=oldLinkPDAID_","_LinkPDAID
	&SQL(
		UPDATE SQLUser.Chemo_PlanOrder SET PO_LinkPDAID=:NewLinkPDAID WHERE PO_ID=:POID
	)
	//手工赋值Global
	s ^BS.DOC.Chemo.PlanOrderI("LinkPDAID",LinkPDAID,POID)=""
	s ^BS.DOC.Chemo.PlanOrderI("LinkPDAIDItemDR",LinkPDAID,ItemDR,POID)=""

	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 停止所选日期的化疗方案
/// IN  : 
/// OUT : 0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).StopDate()
ClassMethod StopDate(PDAID, UserID)
{
	Q:PDAID="" 0
	s OrdList=""
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanOrderI("PDAID",PDAID,id)) q:id=""  d
	.s oeori=$P(^BS.DOC.Chemo.PlanOrderD(id),"^",1)
	.Q:oeori=""
	.s ord=+oeori,sub=$p(oeori,"||",2)
	.s prescno=$p(^OEORD(ord,"I",sub,1),"^",14)
	.s isAudit=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescno)
	.q:isAudit="Y"
	.i OrdList="" s OrdList=oeori
	.e  s OrdList=OrdList_"^"_oeori
	
	i OrdList'="" {
		s mRtn=##class(appcom.OEOrdItem).StopMulti(OrdList,UserID,"","N")
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 化疗方案医嘱相关处理
/// IN  : 
/// OUT : 0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).Exec()
ClassMethod Exec(Adm, OrdItemStr, User, Loc)
{
	
	s mRtn=0
	TS
	f k=1:1:$l(OrdItemStr,"^")-1 {
		Q:mRtn'=0
		s OrdID=$p($p(OrdItemStr,"^",k),"*",2)
		i OrdID="" continue
		continue:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",OrdID))
		//s mRtn=##class(DHCDoc.Chemo.COM.Func2).ChgOrderStatus(OrdID,"I")
		//将日期状态变为已完成
		s mRtn=..SetDateCompelete(OrdID,User,Loc)
		//保持化疗项目信息
		s mRtn=##class(DHCDoc.Chemo.BS.Ext.DateApplyItem).SaveByOrder(OrdID)
    }
    i mRtn'=0{
		TRO
		S ^BS.DOC.Chemo.Log("Error","DHCDoc.Chemo.BS.Order","Exec","Para",Adm)=$lb(OrdItemStr, User, Loc)
		S ^BS.DOC.Chemo.Log("Error","DHCDoc.Chemo.BS.Order","Exec","mRtn")=$lb(mRtn,OrdID)
		Q -139   
	}
    TC
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-14
/// DESC: 保存
/// IN  : 
/// OUT : 0成功，其余失败
/// EXEC: w ##class(DHCDoc.Chemo.BS.Order).SetDateCompelete("14||327","12175","113")
ClassMethod SetDateCompelete(oeori, User, Loc)
{
	s ^QP("Chemo","SetDateCompelete")=$lb(oeori, User, Loc)
	s rtn=0
	Q:oeori="" "-101"
	Q:'$d(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori)) "-101"	
	s POID=$o(^BS.DOC.Chemo.PlanOrderI("Oeori",oeori,""))
	Q:POID="" "-102"
	s ItemDR=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",2)
	Q:ItemDR="" "-103"
	s ChemoDate=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",3)
	Q:ChemoDate="" "-104"
	s PLID=+ItemDR,SUB=$P(ItemDR,"||",2)
	s PSID=PLID_"||"_SUB
	s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(ChemoDate,PSID)
	Q:PDID="" "-105"
	s Status="U"
	s mList=User_$C(1)_Loc_$C(1)_Status
	s Status=$P(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
	B ;001
	i Status'="U" {
		s rtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,mList)
	}
	Q rtn
}

}
