/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 化疗方案复制相关控制
Class DHCDoc.Chemo.BS.Ext.Copy Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 前台复制周期
/// IN  : 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).CopyStage("877||1")
ClassMethod CopyStage(PSID)
{
	s mRtn=""
	Q:PSID="" "-162"
	TS
	s NewPSID=..CopyPlanStage(PSID)
	i +NewPSID<0 {
		TRO
		Q NewPSID
	}
	B ;002
	s mRtn=..CopyPlanGroup(PSID, NewPSID)
	i mRtn'=1 {
		TRO	
		Q mRtn
	}
	B ;00444444
	TC
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 前台复制日期
/// IN  : 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).CopyDay("877||1","2021-03-11","2021-03-14")
ClassMethod CopyDay(PSID, CopyDate, SeclectDate)
{
	s mRtn="-1"
	s ^QP("CopyDay")=$LB(PSID, CopyDate, SeclectDate)
	Q:((PSID="")||(CopyDate="")||(SeclectDate="")) mRtn
	s CopyDate=##class(websys.Conversions).DateHtmlToLogical(CopyDate)
	s SeclectDate=##class(websys.Conversions).DateHtmlToLogical(SeclectDate)
	s PLID=+PSID,SUB=$p(PSID,"||",2)
	;
	s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",21)
	s SeclectDate=##class(websys.Conversions).DateLogicalToHtml(SeclectDate)
	i ChemoDate="" s ChemoDate=SeclectDate
	e  s ChemoDate=ChemoDate_","_SeclectDate
	;修改周期日期
	s mRtn=..UpdateStageChemoDate(PSID,ChemoDate)
	Q:mRtn'=1 mRtn
	;修改化疗项目日期
	s mRtn=..UpdateAllItemChemoDate(PSID, CopyDate, SeclectDate)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 复制方案周期
/// IN  : 
/// OUT : >0成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).CopyPlanStage()
ClassMethod CopyPlanStage(PSID)
{
	s mRtn=""
	Q:PSID="" mRtn
	s PLID=+PSID,SUB=$P(PSID,"||",2)
	s CopyObj=##class(User.ChemoPlanStage).%OpenId(PSID)
	//s CopyStage=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",1)
	Q:'$ISObject(CopyObj) "-162"
	s SaveObj=##class(User.ChemoPlanStage).%New(PLID)
	s LastStage=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,""),-1)
	Q:LastStage="" "-162"
	s LastSUB=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,LastStage,""))
	Q:LastSUB="" "-162"
	s LastStartDate=$p(^BS.DOC.Chemo.PlanD(PLID,LastSUB),"^",3)
	s LastEndDate=$p(^BS.DOC.Chemo.PlanD(PLID,LastSUB),"^",4)
	s LastTSID=$p(^BS.DOC.Chemo.PlanD(PLID,LastSUB),"^",14)
	;复制对象的信息
	s CopyStartDate=CopyObj.PSStartDate
	s CopyEndDate=CopyObj.PSEndDate
	s CopyNextNum=CopyEndDate-CopyStartDate	;间隔天数
	s CopyChemoDate=CopyObj.PSChemoDate
	;新对象信息
	s NewStartDate=LastEndDate+1
	s NewEndDate=NewStartDate+CopyNextNum
	s NewStage=LastStage+1
	s NewDesc="C"_NewStage
	s NewChemoDate=..GetStageChemoDate(CopyStartDate,CopyChemoDate,NewStartDate)
	//B ;004
	;保存基本信息
	d SaveObj.PSParRefSetObjectId(PLID)
	s SaveObj.PSStage=NewStage
	s SaveObj.PSDesc=NewDesc
	s SaveObj.PSStartDate=NewStartDate
	s SaveObj.PSEndDate=NewEndDate
	s SaveObj.PSChemoDate=NewChemoDate
	s SaveObj.PSTplStage=CopyObj.PSTplStage
	s SaveObj.PSNextNum=CopyObj.PSNextNum
	
	;保存其余信息
	s SaveObj.PSAgreeForm=CopyObj.PSAgreeForm
	s SaveObj.PSHasGMis=CopyObj.PSHasGMis
	s SaveObj.PSTreatType=CopyObj.PSTreatType
	s SaveObj.PSBSA=CopyObj.PSBSA
	s SaveObj.PSEffect=CopyObj.PSEffect
	s SaveObj.PSGMisOK=CopyObj.PSGMisOK
	s SaveObj.PSOKUser=CopyObj.PSOKUser
	s SaveObj.PSOKDate=CopyObj.PSOKDate
	s SaveObj.PSOKTime=CopyObj.PSOKTime
	s SaveObj.PSCancerStage=CopyObj.PSCancerStage
	s SaveObj.PSSC=CopyObj.PSSC
	s SaveObj.PSGMisFill=CopyObj.PSGMisFill
	s SaveObj.PSOhterFill=CopyObj.PSOhterFill
	s SaveObj.PSPlanTime=CopyObj.PSPlanTime
	s SaveObj.PSOnTime=CopyObj.PSOnTime
	s SaveObj.PSDelayReason=CopyObj.PSDelayReason
	s SaveObj.PSTreatTypeNew=CopyObj.PSTreatTypeNew
	
	s sc=SaveObj.%Save()
	if ($$$ISERR(sc)) {
		s mRtn="-162"
	} else {
		s mRtn=SaveObj.%Id()
	}
	d CopyObj.%Close()
	d SaveObj.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 复制化疗组
/// IN  : 
/// OUT : >0成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).CopyPlanGroup()
ClassMethod CopyPlanGroup(PSID, NewPSID)
{
	s mRtn="",Err=0
	s PLID=+PSID,SUB=$P(PSID,"||",2)
	s NPLID=+NewPSID,NSUB=$P(NewPSID,"||",2)
	s CopyStartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	s NewStartDate=$p(^BS.DOC.Chemo.PlanD(NPLID,NSUB),"^",3)
	s CH=0
	f  s CH=$O(^BS.DOC.Chemo.PlanD(PLID,SUB,CH)) Q:(CH="")||(Err=1)  d
	.s PGID=PSID_"||"_CH
	.s CopyObj=##class(User.ChemoPlanGroup).%OpenId(PGID)
	.s SaveObj=##class(User.ChemoPlanGroup).%New(NewPSID)
	.;信息
	.s CopyChemoDate=CopyObj.PGPlanDate
	.s NewChemoDate=..GetStageChemoDate(CopyStartDate,CopyChemoDate,NewStartDate)
	.;保存
	.d SaveObj.PGParrefSetObjectId(NewPSID)
	.s SaveObj.PGCode=CopyObj.PGCode
	.s SaveObj.PGDesc=CopyObj.PGDesc
	.s SaveObj.PGVeinFlag=CopyObj.PGVeinFlag
	.s SaveObj.PGTplGrop=CopyObj.PGTplGrop
	.s SaveObj.PGStatus=CopyObj.PGStatus
	.s SaveObj.PGMainDrug=CopyObj.PGMainDrug
	.s SaveObj.PGNote=CopyObj.PGNote
	.s SaveObj.PGPlanDate=NewChemoDate
	.s sc=SaveObj.%Save()
	.i ($$$ISERR(sc)) s Err=1,mRtn="-163"
	.e  d 
	..s NewPGID=SaveObj.%Id()
	..s rtn=..CopyPlanItem(PGID,NewPGID)
	..i rtn<0 s Err=1,mRtn=rtn
	
	Q:Err=1 mRtn
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 复制化疗项目
/// IN  : 
/// OUT : >0成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).CopyPlanItem()
ClassMethod CopyPlanItem(PGID, NewPGID)
{
	s mRtn=1,Err=0
	s PLID=+PGID,SUB=$P(PGID,"||",2),CH=$P(PGID,"||",3)
	s NPLID=+NewPGID,NSUB=$P(NewPGID,"||",2),NCH=$P(NewPGID,"||",3)
	s CopyStartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	s NewStartDate=$p(^BS.DOC.Chemo.PlanD(NPLID,NSUB),"^",3)
	s ID=0
	f  s ID=$O(^BS.DOC.Chemo.PlanD(PLID,SUB,CH,ID)) Q:(ID="")||(Err=1)  d
	.s PIID=PGID_"||"_ID
	.s CopyObj=##class(User.ChemoPlanItem).%OpenId(PIID)
	.s SaveObj=##class(User.ChemoPlanItem).%New(NewPGID)
	.s ShowDate=CopyObj.PGIShowDate
	.s NewShowDate=..GetStageChemoDate(CopyStartDate,ShowDate,NewStartDate)
	.;保存
	.d SaveObj.PGIParrefSetObjectId(NewPGID)
	.s SaveObj.PGIArcimDR=CopyObj.PGIArcimDR
	.s SaveObj.PGIDosage=CopyObj.PGIDosage
	.s SaveObj.PGIDosageUomDR=CopyObj.PGIDosageUomDR
	.s SaveObj.PGIFreqDR=CopyObj.PGIFreqDR
	.s SaveObj.PGIInstrucDR=CopyObj.PGIInstrucDR
	.s SaveObj.PGIDuratDR=CopyObj.PGIDuratDR
	.s SaveObj.PGIQty=CopyObj.PGIQty
	.s SaveObj.PGIUomDR=CopyObj.PGIUomDR
	.s SaveObj.PGILinkItem=CopyObj.PGILinkItem
	.s SaveObj.PGINote=CopyObj.PGINote
	.s SaveObj.PGIPriorDR=CopyObj.PGIPriorDR
	.s SaveObj.PGISimpleDR=CopyObj.PGISimpleDR
	.s SaveObj.PGIRemark=CopyObj.PGIRemark
	.s SaveObj.PGIRecLoc=CopyObj.PGIRecLoc
	.s SaveObj.PGIStage=CopyObj.PGIStage
	.s SaveObj.PGIFlowRate=CopyObj.PGIFlowRate
	.s SaveObj.PGIFlowRateDR=CopyObj.PGIFlowRateDR
	.s SaveObj.PGISkinTest=CopyObj.PGISkinTest
	.s SaveObj.PGISkinAction=CopyObj.PGISkinAction
	.s SaveObj.PGITplGroupItem=CopyObj.PGITplGroupItem
	.s SaveObj.PGIBSAUnit=CopyObj.PGIBSAUnit
	.s SaveObj.PGIBSA=CopyObj.PGIBSA
	.s SaveObj.PGIMainDrug=CopyObj.PGIMainDrug
	.s SaveObj.PGIFormula=CopyObj.PGIFormula
	.s SaveObj.PGIGFR=CopyObj.PGIGFR
	.s SaveObj.PGIBSAUnitSTD=CopyObj.PGIBSAUnitSTD
	.s SaveObj.PGISeqno=CopyObj.PGISeqno
	.s SaveObj.PGIShowDate=NewShowDate
	.s SaveObj.PGIInitDosage=CopyObj.PGIInitDosage
	.s sc=SaveObj.%Save()
	.i ($$$ISERR(sc)) s Err=1
	.e  d 
	..s mRtn=SaveObj.%Id()
	
	Q:Err=1 "-164"
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 得到周期化疗日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).GetStageChemoDate(65783,"2021-02-08,2021-02-09,2021-02-10",65785)
ClassMethod GetStageChemoDate(StartDate, ChemoDate, NewStartDate)
{
	s mRtn=""
	Q:(StartDate="")||(ChemoDate="")||(NewStartDate="") mRtn
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	//s ChemoDate=##class(websys.Conversions).DateHtmlToLogical(ChemoDate)
	s NewStartDate=##class(websys.Conversions).DateHtmlToLogical(NewStartDate)
	f i=1:1:$l(ChemoDate,",") {
		s CDate=$p(ChemoDate,",",i)	
		continue:CDate=""
		s CDate=##class(websys.Conversions).DateHtmlToLogical(CDate)
		s Num=CDate-StartDate
		s NDate=NewStartDate+Num
		s NDate=##class(websys.Conversions).DateLogicalToHtml(NDate)
		i mRtn="" s mRtn=NDate
		e  s mRtn=mRtn_","_NDate
		
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 修改周期化疗日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).UpdateStageChemoDate("")
ClassMethod UpdateStageChemoDate(PSID, ChemoDate)
{
	Q:PSID="" 1
	&SQL(UPDATE SQLUser.Chemo_PlanStage 
		 SET PS_ChemoDate=:ChemoDate 
		 WHERE PS_ID=:PSID
	)
		 
	Q:SQLCODE'=0 "-165"
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 修改周期化疗日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).UpdateStageChemoDate("")
ClassMethod UpdateItemChemoDate(PIID, ShowDate)
{
	Q:PIID="" 1
	&SQL(UPDATE SQLUser.Chemo_PlanItem 
		 SET PGI_ShowDate=:ShowDate
		 WHERE PGI_ID=:PIID
	)
		 
	Q:SQLCODE'=0 "-165"
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 修改周期化疗日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).UpdateStageChemoDate("")
ClassMethod UpdateAllItemChemoDate(PSID, CopyDate, SeclectDate)
{
	Q:(PSID="")||(CopyDate="")||(SeclectDate="") 1
	s CopyDate=##class(websys.Conversions).DateHtmlToLogical(CopyDate)
	s SeclectDate=##class(websys.Conversions).DateHtmlToLogical(SeclectDate)
	s CopyDateHtml=##class(websys.Conversions).DateLogicalToHtml(CopyDate)
	s SeclectDateHtml=##class(websys.Conversions).DateLogicalToHtml(SeclectDate)
	s PLID=+PSID,SUB=$P(PSID,"||",2)
	s Err=1
	s CH=""
	f  s CH=$O(^BS.DOC.Chemo.PlanD(PLID,SUB,CH)) Q:(CH="")||(Err'=1)  d
	.s ID=""
	.f  s ID=$O(^BS.DOC.Chemo.PlanD(PLID,SUB,CH,ID)) Q:(ID="")||(Err'=1)  d
	..s PGIID=PSID_"||"_CH_"||"_ID
	..s ShowDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB,CH,ID),"^",28)
	..q:ShowDate=""
	..q:ShowDate'[CopyDateHtml
	..s ShowDate=ShowDate_","_SeclectDateHtml
	..s Err=..UpdateItemChemoDate(PGIID,ShowDate)
	
	Q:Err'=1 Err
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-10
/// DESC: 得到可以选择复制的天数
/// IN  : 
/// OUT : 1成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Copy).GetEnableSeclectDay("13||1")
ClassMethod GetEnableSeclectDay(PSID)
{
	s mRtn=""
	Q:PSID="" mRtn
	s PLID=+PSID,SUB=$p(PSID,"||",2)
	
	s StartDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",3)
	s EndDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",4)
	s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SUB),"^",21)
	f date=StartDate:1:EndDate {
		s datehtml=##class(websys.Conversions).DateLogicalToHtml(date)
		s inFlag=##class(DHCDoc.Chemo.COM.Func).InArray(ChemoDate,datehtml)
		continue:inFlag=1
		i mRtn="" s mRtn=datehtml
		e  s mRtn=mRtn_","_datehtml
	}
	
	Q mRtn
}

}
