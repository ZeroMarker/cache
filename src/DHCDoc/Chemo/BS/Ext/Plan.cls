/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 化疗单扩展
Class DHCDoc.Chemo.BS.Ext.Plan Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 保存其余周期
/// IN  : 
/// OUT : 0成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Plan).Save("")
ClassMethod SaveOtherStage(PSID)
{
	s mRtn=0
	
	s PLID=+PSID
	s SUB=$p(PSID,"||",2)
	s HasStage=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",1)
	s TPID=$P(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	Q:TPID="" -141
	s TotalStage=##class(DHCDoc.Chemo.COM.Func).GetTPLStage(TPID)
	Q:(TotalStage="")||(TotalStage="0") -141
	f i=1:1:TotalStage {
		Q:mRtn'=0
		continue:i=HasStage
		;保存周期
		s CPSID=..SaveStage(PSID,i)
		continue:CPSID=0	
		i +CPSID<0 {
			s mRtn=-141
			Q
		}
		;保存化疗组和化疗项目
		s result=..SaveALLGroup(CPSID)
		i result'=0 {
			s mRtn=-141
			Q
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 保存化疗组
/// IN  : 
/// OUT : 0成功
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Save("903||1")
ClassMethod SaveALLGroup(PSID As %String)
{
	s err=-1,ok=0
	S PLID=+PSID,SUB=$P(PSID,"||",2)
	s TSID=$P(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",14)
	s TPID=+TSID
	S TSChild=$p(TSID,"||",2)
	s Type=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",1)
	s TotalGNum=##class(DHCDoc.Chemo.COM.Func).GetTPLStageGroups(TSID,Type)
	Q:TotalGNum=0 ok
	f k=1:1:TotalGNum {
		Q:ok'=0
		continue:$d(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,TSChild,k))
		s TGID=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,TSChild,k,""))
		continue:TGID=""
		s TGID=TSID_"||"_TGID
		s PGID=..SaveGroup(PSID,TGID,k)
		i +PGID<0 {
			s ok=-1
			Q
		}
		;保存化疗项目
		s ok=..SaveItem(PGID,TGID)
		Q:ok'=0
		
	}
	
	Q ok
}

/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 保存化项目
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Save("903||1")
ClassMethod SaveItem(PGID As %String, TGID As %String)
{
	s err=-1,ok=0
	s TPID=+TGID
	s TSChild=$p(TGID,"||",2)
	s TGChild=$p(TGID,"||",3)
	s TIChild=""
	s i=0
	f  s TIChild=$O(^CF.DOC.Chemo.TemplateD(TPID,TSChild,TGChild,TIChild)) Q:(TIChild="")||(ok=-1)  d
	.s TIID=TGID_"||"_TIChild
	.s a=##class(User.ChemoTemplateItem).%OpenId(TIID)
	.i '$ISObject(a) s ok=-1
	.s b=##class(User.ChemoPlanItem).%New(PGID)
	.i '$ISObject(b) s ok=-1
	.q:ok=-1
	.s i=i+1
	.s b.PGIArcimDR=a.TPGIArcimDR
	.s b.PGIDosage=a.TPGIDosage
	.s b.PGIDosageUomDR=a.TPGIDosageUomDR
	.s b.PGIFreqDR=a.TPGIFreqDR
	.s b.PGIInstrucDR=a.TPGIInstrucDR
	.s b.PGIDuratDR=a.TPGIDuratDR
	.s b.PGIQty=a.TPGIQty
	.s b.PGIUomDR=a.TPGIUomDR
	.s b.PGILinkItem=a.TPGILinkItem
	.s b.PGINote=a.TPGINote
	.s b.PGIPriorDR=a.TPGIPriorDR
	.s b.PGISimpleDR=a.TPGISimpleDR
	.s b.PGIRemark=a.TPGIRemark
	.s b.PGIRecLoc=a.TPGIRecLoc
	.s b.PGIStage=a.TPGIStage
	.s b.PGIFlowRate=a.TPGIFlowRate
	.s b.PGIFlowRateDR=a.TPGIFlowRateDR
	.s b.PGISkinAction=a.TPGISkinAction
	.s b.PGISkinTest=a.TPGISkinTest
	.s b.PGIMainDrug=a.TPGIMainDrug
	.s b.PGIFormula=a.TPGIFormula
	.s b.PGIBSAUnit=a.TPGIBSAUnit
	.s b.PGIBSAUnitSTD=a.TPGIBSAUnitSTD
	.s b.PGISeqno=i
	.s b.PGIShowDate=a.TPGIShowDate	;需解析日期
	.s sc=b.%Save()
	.i ($$$ISERR(sc)) s ok=-1
	.;e  s ok=b.%Id()
	.d a.%Close()
	.d b.%Close()
	
	Q ok
}

/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 保存化疗组
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Save("903||1")
ClassMethod SaveGroup(PSID As %String, TGID As %String, GroupCode As %String)
{
	s err=-1,ok=0
	s a=##class(User.ChemoTemplateGroup).%OpenId(TGID)
	Q:'$ISObject(a) err
	s b=##class(User.ChemoPlanGroup).%New(PSID)
	Q:'$ISObject(b) err
	d b.PGTplGropSetObjectId(TGID)
	d b.PGParrefSetObjectId(PSID)
	s b.PGCode=GroupCode
	s b.PGDesc=a.TPGDesc
	s b.PGPlanDate=a.TPGPlanDate	;需解析日期
	s b.PGNote=a.TPGNote
	s b.PGVeinFlag=a.TPGVeinFlag
	s b.PGMainDrug=a.TPGMainDrug
	s b.PGStatus="Y"
	s sc=b.%Save()
	if ($$$ISERR(sc)) {
		s ok=-1
	} else {
		s ok=c.%Id()
	}
	d a.%Close()
	d b.%Close()
	
	Q ok
}

/// CTOR: QP
/// DATE: 2020-08-26
/// DESC: 保存周期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.Stage).Save("903||1")
ClassMethod SaveStage(PSID As %String, Stage As %String)
{
	s err=-1,ok=0
	q:PSID="" err
	//s PList=##class(DHCDoc.Chemo.COM.Func).GetClassPropertyList("User.ChemoPlanStage",0)
	s a=##class(User.ChemoPlanStage).%OpenId(PSID)
	Q:'$ISObject(a) err
	s PLID=+PSID
	s TPID=$P(^BS.DOC.Chemo.PlanD(PLID),"^",3)
	;模板没有维护的周期不保存
	Q:'$d(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,Stage)) ok	
	s TSID=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,Stage,""))
	Q:TSID="" err
	s TSID=TPID_"||"_TSID
	s b=##class(User.ChemoTemplateStage).%OpenId(TSID)
	Q:'$ISObject(b) err
	s c=##class(User.ChemoPlanStage).%New(PLID)
	Q:'$ISObject(c) err
	
	;保存
	d c.PSParRefSetObjectId(PLID)
	d c.PSTplStageSetObjectId(TSID)
	s c.PSDesc=b.TSDesc
	s c.PSStage=Stage
	s c.PSStartDate=b.TSStartDate	;需解析日期
	s c.PSEndDate=b.TSEndDate		;需解析日期
	s c.PSNextNum=b.TSNextNum
	s c.PSChemoDate=b.TSChemoDate	;需解析日期
	s c.PSAgreeForm=a.PSAgreeForm
	s c.PSHasGMis=a.PSHasGMis
	s c.PSTreatType=a.PSTreatType
	s c.PSBSA=a.PSBSA
	s c.PSEffect=a.PSEffect
	s c.PSGMisOK=a.PSGMisOK
	s c.PSOKUser=a.PSOKUser
	s c.PSOKDate=a.PSOKDate
	s c.PSOKTime=a.PSOKTime
	s c.PSCancerStage=a.PSCancerStage
	s c.PSSC=a.PSSC
	s c.PSGMisFill=a.PSGMisFill
	s c.PSOhterFill=a.PSOhterFill
	s c.PSPlanTime=a.PSPlanTime
	s sc=c.%Save()
	if ($$$ISERR(sc)) {
		s ok=-1
	} else {
		s ok=c.%Id()
	}
	d a.%Close()
	d b.%Close()
	d c.%Close()
	
	Q ok
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 撤销化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Plan).CancelChemoPlan("1310||1","1311||1,1312||1","12213",4)
ClassMethod CancelChemoPlan(PDAID, LinkPDAID, UserID, InLoc)
{
	/*
		1.判断上级医师是否审核过，审核过，提示不能撤销
		1.作废医嘱
		2.更改所有已保存天数的状态为 暂存状态。
			2.1. PD
			2.2. PDA
		3.
	
	
	*/
	s mRtn=0_"^"
	b ;002
	Q:PDAID="" mRtn
	s PDID=+PDAID,SUB=$P(PDAID,"||",2)
	s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
	//1.能否撤销
	i (PDStatus'="N")&&(PDStatus'="A")&&(PDStatus'="") {
		Q "-1^化疗方案已被审核，不能进行撤销！"	
	}
	i PDStatus="A" {
		s hasAudit=0
		s id=""
		f  s id=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",SUB,"S",id)) Q:(id="")||(hasAudit=1)  d
		.s status=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",SUB,"S",id),"^",1)
		.Q:status="A"
		.s hasAudit=1
		
		i (hasAudit=1) {
			Q "-1^化疗方案已被审核，不能进行撤销！"	
		}

	}
	//TS
	//2. 作废医嘱
	s OrdList=""
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanOrderI("PDAID",PDAID,id)) q:id=""  d
	.s oeori=$p(^BS.DOC.Chemo.PlanOrderD(id),"^",1)
	.q:oeori=""
	.i OrdList="" s OrdList=oeori
	.e  s OrdList=OrdList_"^"_oeori
	
	s ^QP("OrdList")=$lb(OrdList)
	i OrdList'="" {
		
		s mRtn=##class(appcom.OEOrdItem).StopMulti(OrdList,UserID,"","N")
		s ^QP("OrdList","mRtn")=$lb(mRtn)
		//TRO
		Q:mRtn'=0 "-1^医嘱停止失败！"	
	}
	//3. 更改所有已保存天数的状态为 暂存状态。
	//3.1 更新所有天数的状态为N 
	//3.2 [先不做] 插入Chemo_PlanDateApply  Chemo_PlanDateApplyStatus 一条记录为：DC (申请医生撤销) 
	
	s DList=UserID_$C(1)_InLoc_$C(1)_"N"
	s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(PDID,DList)
	i mRtn'=0 {
		//TRO
		Q "-1^更新为暂存状态失败！"
	}
	s mRtn=##class(DHCDoc.Chemo.BS.DateApply).ChgStatus(PDAID,UserID,InLoc,"DC")
	i mRtn'=0 {
		//TRO
		Q "-1^更新为申请医生撤销状态失败！"
	}
	i LinkPDAID'="" {
		f i=1:1:$L(LinkPDAID,",") {
			Q:mRtn'=0
			s CID=$p(LinkPDAID,",",i)	
			s CDID=+CID
			s DList=UserID_$C(1)_InLoc_$C(1)_"N"
			s mRtn=##class(DHCDoc.Chemo.BS.Date).ChgStatus(CDID,DList)
			Q:mRtn'=0 
			s mRtn=##class(DHCDoc.Chemo.BS.DateApply).ChgStatus(CID,UserID,InLoc,"DC")
			Q:mRtn'=0 
		}
	}
	i mRtn'=0 {
		//TRO
		Q "-1^更新为暂存状态失败！"
	}
	//TC
	
	Q "0^撤销成功！"
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 撤销化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Plan).CancelChemoPlanNew("2021-03-20","906||1","12213",4)
ClassMethod CancelChemoPlanNew(SelectDate, PSID, UserID, InLoc)
{
	Q:(SelectDate="")||(PSID="") "0^"
	k PList,HList
	
	//s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(SelectDate,PSID)
	Q:PDID="" "-1^不是申请状态不能进行撤销！"
	s PDAID=##class(DHCDoc.Chemo.BS.DateApply).GetPDAID(PDID)
	Q:PDAID="" "-1^不是申请状态不能进行撤销！"
	s SUB=$P(PDAID,"||",2)
	s LinkPDAID=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",SUB),"^",13)
	d ..DoPSPList(PSID,.PList,.HList)
 	B ;0023
	i $d(PList(PDAID)) {
		i $d(HList(PDAID)) {
			//说明是附属的
			s PDAID=HList(PDAID)
			s LinkPDAID=PList(PDAID)
		} else {
			//说明是主的，不做控制
		}
	} else {
		Q "-1^未找到需要撤销的天数！"
	}
	b ;001
	s mRtn=..CancelChemoPlan(PDAID,LinkPDAID,UserID,InLoc)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-19
/// DESC: 撤销化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Plan).CancelChemoPlan("1310||1","1311||1,1312||1","12213",4)
ClassMethod DoPSPList(PSID, ByRef PList, ByRef HList)
{
	s cDate=""
	f  s cDate=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,cDate))  q:cDate=""  d
	.s PDID=""
	.f  s PDID=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,cDate,PDID)) q:PDID=""  d
	..s sub=""
	..f  s sub=$o(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub)) q:sub=""  d
	...s id=PDID_"||"_sub
	...s status=$p(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",3)
	...Q:status["C"
	...s LinkPDAID=$P(^BS.DOC.Chemo.PlanDateD(PDID,"A",sub),"^",13)
	...d ..SetPList(.PList,.HList,id,LinkPDAID)
}

/// CTOR: QP
/// DATE: 2020-07-09
/// DESC: 组织所有输出List
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Audit).TE()
ClassMethod SetPList(ByRef PList, ByRef HList, PDAID, LinkPDAID)
{
	Q:(PDAID="") 0
	s PList(PDAID)=LinkPDAID
	
	Q:LinkPDAID="" 0
	f i=1:1:$L(LinkPDAID,",") {
		s CID=$P(LinkPDAID,",",i)
		continue:CID=PDAID
		s PList(PDAID,CID)=""
		s HList(CID)=PDAID
	}
	
	Q 0
}

}
