/// CTOR: QP
/// DATE: 2020-06-16
/// DESC: 化疗单
Class DHCDoc.Chemo.BS.Plan Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-06-16
/// DESC: 保存化疗单
/// IN  : PGAry: [组信息$C(2)项目信息$C(3)项目信息, ...]
/// OUT : 
/// EXEC: d ##class(DHCDoc.Chemo.BS.Plan).Save("")
ClassMethod Save(InType, SelectDate = "", PLAry, PSAry, PGAry, HDAry, PDAry, ExtPara = "")
{
	s ^QP("SS",1)=$LB(InType,SelectDate,ExtPara)
	TS
	s SaveFlag=$p(ExtPara,"^",1)
	s PAAdmType=$p(ExtPara,"^",2)
	s ToDate=$p(ExtPara,"^",3)
	s SaveAll=$p(ExtPara,"^",4)	//统一暂存标识
	s AdmID=PLAry(7)
	s HDID=##class(DHCDoc.Chemo.BS.HospDose).Save(.HDAry)
	i HDID<0 {
		TRO
		Q HDID
	}
	s PLID=..SavePlan(.PLAry)
	i PLID<0 {
		TRO
		Q PLID
	}
	s PDID=##class(DHCDoc.Chemo.BS.Date).Save(.PDAry,SaveAll)
	i PDID<0 {
		TRO
		Q PDID
	}
	s PAID=##class(DHCDoc.Chemo.BS.AdmLink).Save(PLID,AdmID)
	i PAID<0 {
		TRO
		Q PAID
	}
	s PSID=..SaveStage(.PSAry,PLID)
	i PSID<0 {
		TRO
		Q PSID
	}
	s IsFristDay=##class(DHCDoc.Chemo.BS.Ext.Process).IsFirstDay(PSID, SelectDate)
	s PGIID=..SaveGroup(.PGAry,PSID,InType,SelectDate)
	i PGIID<0 {
		s ABC=^QP("SAVE")
		TRO
		s ^QP("SAVE")=ABC
		Q PGIID
	}
	;保存检查所有暂存必填项
	i SaveFlag=1 {
		s VInfo=..VailidateMultiDays(PSID,PAAdmType)
		s VFlag=$p(VInfo,"^",1)
		i VFlag'=0 {
			TRO
			Q VInfo
		}
	}
	
	//i (IsFristDay=1)&&(InType="CUR") {
	i (InType="CUR") {
		i (IsFristDay=1) { //第一天修改，需要联动变更日期
			
			s rtn=##class(DHCDoc.Chemo.BS.Ext.Process).UpdateStartDate(PSID, ToDate,SelectDate,IsFristDay)
			i rtn'=1 {
				TRO
				Q "-159"	
			}
			
			
		} else {	//不是第一天不需要联动变更，只需变更所选的这一天
			//todo
			//s rtn=##class(DHCDoc.Chemo.BS.Ext.Process).UpdateStartDate(PSID, ToDate)
		}
	}
	//提交时，判断是否有无拒绝的方案，若有则停止医嘱
	i SaveFlag=1 {
		s OrdList=..GetRefueseOrderList(PSID)
		
		S ^QP("hhhh",11)=OrdList
		i OrdList'="" {
			s rtn=##class(appcom.OEOrdItem).StopMulti(OrdList,PLAry(6),"","N")
			i rtn'=0 {
				TRO
				Q "-160"	
			}	
		}
	}
	TC
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-06-16
/// DESC: 保存化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).Save("")
ClassMethod SavePlan(PLAry)
{
	s mRtn=0
	s PLNum=$o(PLAry(""),-1)
	Q:PLNum="" mRtn
	s PLID=PLAry(1)
	i PLID="" {
		s a=##class(User.ChemoPlan).%New()
		d a.PLPatientDRSetObjectId(PLAry(3))
		d a.PLTemplateDRSetObjectId(PLAry(4))
		d a.PLOrderDepSetObjectId(PLAry(5))
		d a.PLOrderUserSetObjectId(PLAry(6))
		d a.PLAdmDRSetObjectId(PLAry(7))
		s a.PLStatus=PLAry(9)
		s a.PLInsertDate=+$H
		s a.PLInsertTime=$p($h,",",2)
	} else{
		s a=##class(User.ChemoPlan).%OpenId(PLID)
	}
	Q:'$ISObject(a) -114
	s a.PLName=PLAry(2)
	s a.PLNote=PLAry(8)
	s a.PLExamNote=PLAry(10)
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		s mRtn=-114
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-06-16
/// DESC: 保存周期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).Save("")
ClassMethod SaveStage(PSAry, PLID)
{
	s mRtn=0
	s PSNum=$o(PSAry(""),-1)
	Q:PSNum="" mRtn
	s PSID=PSAry(1)
	i PSID="" {
		s a=##class(User.ChemoPlanStage).%New(PLID)
		d a.PSParRefSetObjectId(PLID)
		d a.PSTplStageSetObjectId(PSAry(7))
		s a.PSStage=PSAry(2)
		s TPID=$p(^BS.DOC.Chemo.PlanD(PLID),"^",3)
		s sub=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateStage","Stage",TPID,PSAry(2),""))
		s ^QP("SAVE")=sub
		q:sub="" -123
		s a.PSDesc=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",2)
		s startDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",3)
		s startDate=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(startDate,2)
		s a.PSStartDate=startDate
		s endDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",4)
		s endDate=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(endDate,2)
		s a.PSEndDate=endDate
		//S TPID=+PSAry(7),sub=$P(PSAry(7),"||",2)
		s nextNum=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",5)
		s chemoDate=$p(^CF.DOC.Chemo.TemplateD(TPID,sub),"^",6)
		s chemoDate=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(chemoDate,1)
		s a.PSNextNum=nextNum
		s a.PSChemoDate=chemoDate
		
	} else{
		s a=##class(User.ChemoPlanStage).%OpenId(PSID)
	}
	s a.PSAgreeForm=PSAry(3)
	s a.PSHasGMis=PSAry(4)
	s a.PSTreatType=PSAry(5)
	s a.PSEffect=PSAry(6)
	s a.PSCancerStage=PSAry(8)
	s a.PSSC=PSAry(9)
	s a.PSGMisFill=PSAry(10)
	s a.PSOhterFill=PSAry(11)
	s a.PSPlanTime=PSAry(12)
	s a.PSOnTime=PSAry(13)
	s a.PSDelayReason=PSAry(14)
	s a.PSTreatTypeNew=PSAry(15)
	Q:'$ISObject(a) -123
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc) 
		s mRtn=-123
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 保存化疗申请单
/// IN  : PGAry: [组信息$C(2)项目信息$C(3)项目信息, ...]
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).Save("")
ClassMethod SaveGroup(PGAry, PSID = "", InType = "", SelectDate = "")
{
	s mRtn=0
	s PGNum=$o(PGAry(""),-1)
	i PGNum="" s PGNum=0
	Q:(PGNum="")||(PSID="") mRtn
	for j=1:1:PGNum {
		s PGRecord=PGAry(j)
		s PGItem=$p(PGRecord,$C(2),1)
		s PGIStr=$p(PGRecord,$C(2),2)
		s PGID=$p(PGItem,$C(1),1)
		s PGDesc=$p(PGItem,$C(1),8)
		i InType="CUR" {
			s PGID=..GetPGID(PSID,PGDesc,InType)
			S ^QP("SAVE")=$LB(PSID,PGDesc,InType)
			//S ^QP("SAVE")=PGNum
			i PGID="" s mRtn="-142"	//寻找不到PGID
		}
		
		Q:mRtn<0
		
		i PGID="" {
			s b=##class(User.ChemoPlanGroup).%New(PSID)
			d b.PGParrefSetObjectId(PSID)
			//获取模板中的信息
			s PLID=+PSID,CH=$P(PSID,"||",2)
			s cTSID=$p(^BS.DOC.Chemo.PlanD(PLID,CH),"^",14)
			s TPGID=..GetPGID(cTSID,PGDesc,InType)
			s TPID=+TPGID,SID=$P(TPGID,"||",2),SUB=$P(TPGID,"||",3)
			
			s b.PGCode=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",1)
			d b.PGDescSetObjectId(PGDesc)
			d b.PGTplGropSetObjectId(TPGID)
			s b.PGStatus=$p(PGItem,$C(1),6)
			s b.PGMainDrug=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",6)
			s PGPlanDate=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",3)
			s PGPlanDate=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(PGPlanDate,1)
			s b.PGPlanDate=PGPlanDate
			
			/*
			s b.PGCode=$p(PGItem,$C(1),2)
			d b.PGDescSetObjectId($p(PGItem,$C(1),8))
			d b.PGTplGropSetObjectId($p(PGItem,$C(1),5))
			s b.PGStatus=$p(PGItem,$C(1),6)
			s b.PGMainDrug=$p(PGItem,$C(1),7)
			s b.PGPlanDate=$p(PGItem,$C(1),3)
			*/
		} else{
			s b=##class(User.ChemoPlanGroup).%OpenId(PGID)
		}
		i '$ISObject(b) {
			s mRtn=-115
			quit
		}
		s b.PGNote=$p(PGItem,$C(1),4)
		s sc=b.%Save()
		if ($$$ISERR(sc)) {
			s mRtn=-115
			quit
		} else {
			s PGID=b.%Id()
			s Len=$l(PGIStr,$C(3))	
			f k=1:1:Len {
				q:mRtn<0
				s mList=$p(PGIStr,$C(3),k)
				s PGIID=..SaveItem(mList,PGID,SelectDate,InType)
				i PGIID<0  {
					s mRtn=PGIID
					quit
				}else {
					s mRtn=PGIID
				}
			}	
		}
		d b.%Close()
			
	}
	if mRtn>=0 {
		//保存没有医嘱的化疗组
		s mRtn=..SaveBlankGroup(PSID)
		
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 保存化疗申请单
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).Save("")
ClassMethod SaveItem(mList, PGID = "", SelectDate = "", InType = "")
{
	s mRtn=0
	q:mList="" mRtn
	s ItemID=$p(mList,$C(1),1)
	s TplGroupItemDr=$p(mList,$C(1),21)
	i ItemID="" {
		s c=##class(User.ChemoPlanItem).%New(PGID)
		d c.PGIParrefSetObjectId(PGID)
		s c.PGIInitDosage=$p(mList,$C(1),3)
		//根据模板取显示日期
		i TplGroupItemDr'="" {
			s TID=+TplGroupItemDr,SID=$P(TplGroupItemDr,"||",2)
			s CH=$P(TplGroupItemDr,"||",3),CW=$P(TplGroupItemDr,"||",4)
			s showDate=$p(^CF.DOC.Chemo.TemplateD(TID,SID,CH,CW),"^",25)
			s showDate=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(showDate,1)
			s c.PGIShowDate=showDate
		} else {
			s showDate=$p(mList,$C(1),28)
			s defaultDate=SelectDate
			s defaultDate=##class(websys.Conversions).DateLogicalToHtml(SelectDate)
			i showDate="" s showDate=defaultDate	//##class(websys.Conversions).DateLogicalToHtml(+$H)
			e  s showDate=##class(DHCDoc.Chemo.COM.Func2).ParseDayNumToDate(PGID,showDate)
			s c.PGIShowDate=showDate
		}
		s c.PGIBSAUnitSTD=$p(mList,$C(1),29)
	} else{
		s c=##class(User.ChemoPlanItem).%OpenId(ItemID)
		s oldPGIDosage=c.PGIDosage
		s newPGIDosage=$p(mList,$C(1),3)
		i oldPGIDosage'=newPGIDosage {
			//s result=##class(DHCDoc.THPY.BS.Apply).AdjustOrdDose(ItemID)
			//q:result'=0 -119
		}
		s showDate=$p(mList,$C(1),28)
		s showDate=##class(DHCDoc.Chemo.COM.Func2).ParseDayNumToDate(PGID,showDate)
		i showDate'="" {
			s c.PGIShowDate=showDate	
		}
		//保存顺序
		s ISAry(1)=""
		s ISAry(2)=SelectDate
		s ISAry(3)=$p(mList,$C(1),26)
		s PLID=+ItemID,SID=$P(ItemID,"||",2)
		s CPSID=PLID_"||"_SID
		s ISAry(4)=CPSID
		s ISAry(5)=ItemID
		s ISID=##class(DHCDoc.Chemo.BS.Ext.PlanItemSort).Save(.ISAry)
		Q:ISID<0 ISID
	}
	Q:'$ISObject(c) -116
	d c.PGIArcimDRSetObjectId($p(mList,$C(1),2))
	s c.PGIDosage=$p(mList,$C(1),3)
	
	d c.PGIDosageUomDRSetObjectId($p(mList,$C(1),4))
	d c.PGIFreqDRSetObjectId($p(mList,$C(1),5))
	d c.PGIInstrucDRSetObjectId($p(mList,$C(1),6))
	d c.PGIDuratDRSetObjectId($p(mList,$C(1),7))
	i InType'="CUR" s c.PGIQty=""
	e  s c.PGIQty=$p(mList,$C(1),8)
	d c.PGIUomDRSetObjectId($p(mList,$C(1),9))
	s c.PGILinkItem=$p(mList,$C(1),10)
	s c.PGINote=$p(mList,$C(1),11)
	d c.PGIPriorDRSetObjectId($p(mList,$C(1),12))
	s c.PGISimpleDR=$p(mList,$C(1),13)
	s c.PGIRemark=$p(mList,$C(1),14)
	d c.PGIRecLocSetObjectId($p(mList,$C(1),15))
	s c.PGIStage=$p(mList,$C(1),16)
	s c.PGIFlowRate=$p(mList,$C(1),17)
	d c.PGIFlowRateDRSetObjectId($p(mList,$C(1),18))
	s c.PGISkinTest=$p(mList,$C(1),19)
	;s c.PGISkinAction=$p(mList,$C(1),20)
	d c.PGISkinActionSetObjectId($p(mList,$C(1),20))
	d c.PGITplGroupItemSetObjectId(TplGroupItemDr)
	s c.PGIBSAUnit=$p(mList,$C(1),22)
	s c.PGIBSA=$p(mList,$C(1),23)
	s c.PGIFormula=$p(mList,$C(1),24)
	s c.PGIGFR=$p(mList,$C(1),25)
	s c.PGISeqno=$p(mList,$C(1),26)
	s c.PGIMainDrug=$p(mList,$C(1),27)
	//=$p(mList,$C(1),29)
	s sc=c.%Save()
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc) 
		s mRtn=-116
	} else {
		s mRtn=c.%Id()
	}
	d c.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 检查数据
/// IN  : 
/// OUT : 
/// EXEC: d ##class(DHCDoc.Chemo.BS.Plan).Save("")
ClassMethod CheckData(dto, ByRef CheckAry As %String)
{
	
	s CheckAry("msg")="检查通过"
	s CheckAry("success")=1
		
	if (dto.PLName="") {
		s CheckAry("msg")="化疗方案名称必填！"
		s CheckAry("success")=0
		quit
	}
	if (dto.PGStartDate="") {
		s CheckAry("msg")="阶段开始日期不能为空！"
		s CheckAry("success")=0
		quit
	}
	if (dto.PGEndDate="") {
		s CheckAry("msg")="阶段结束日期不能为空！"
		s CheckAry("success")=0
		quit
	}
	
	quit
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 检查数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).ClearData()
ClassMethod ClearData()
{
	&SQL(TRUNCATE TABLE SQLUser.Chemo_Plan)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanStage)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanGroup)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_Plan)
	
	
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 停止化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).StopChemoPlan()
ClassMethod StopChemoPlan(UserID, PLID, PatientID, EpisodeID)
{
	Q:PLID="" -125
	
	s rtn=##class(DHCDoc.Chemo.BS.Order).Stop(UserID,PLID,PatientID,EpisodeID)
	Q:rtn'=0 "-126"
	
	S Status="S"
	&SQL(
		UPDATE SQLUser.Chemo_Plan SET PL_Status=:Status WHERE PL_ID=:PLID
	)
	Q:SQLCODE'=0 "-125"
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-07-03
/// DESC: 删除某化疗方案数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).DelSingleData(8)
ClassMethod DelSingleData(PLID)
{
	Q:PLID="" 0
	
	S PSIDArr="",PGIDArr="",PIIDArr=""
	S SID=""
	f  s SID=$o(^BS.DOC.Chemo.PlanD(PLID,SID)) Q:SID=""  d
	.s PSID=PLID_"||"_SID
	.i PSIDArr="" s PSIDArr=PSID
	.e  s PSIDArr=PSIDArr_","_PSID
	.s sub=""
	.f  s sub=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub)) Q:sub=""  d
	..s PGID=PSID_"||"_sub
	..i PGIDArr="" s PGIDArr=PGID
	..e  s PGIDArr=PGIDArr_","_PGID
	..s id=""
	..f  s id=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub,id)) Q:id=""  d
	...s PIID=PGID_"||"_id
	...i PIIDArr="" s PIIDArr=PIID
	...e  s PIIDArr=PIIDArr_","_PIID
	
	TS
	s mRtn=0
	
	;Item
	f i=1:1:$l(PIIDArr,",") {
		q:mRtn'=0
		s PIID=$P(PIIDArr,",",i)
		&SQL(
			DELETE FROM SQLUser.Chemo_PlanItem WHERE PGI_ID=:PIID
		)
		i SQLCODE'=0 s mRtn=SQLCODE
		
	}
	i (mRtn'=0) {
		TRO
		Q SQLCODE	
	}
	
	;Group
	f i=1:1:$l(PGIDArr,",") {
		q:mRtn'=0
		s PGID=$P(PGIDArr,",",i)
		&SQL(
			DELETE FROM SQLUser.Chemo_PlanGroup WHERE PG_ID=:PGID
		)
		i SQLCODE'=0 s mRtn=SQLCODE
		
	}
	i (mRtn'=0) {
		TRO
		Q SQLCODE	
	}
	
	
	
	;Stage
	f i=1:1:$l(PSIDArr,",") {
		q:mRtn'=0
		s PSID=$P(PSIDArr,",",i)
		&SQL(
			DELETE FROM SQLUser.Chemo_PlanStage WHERE PS_ID=:PSID
		)
		i SQLCODE'=0 s mRtn=SQLCODE
		
	}
	i (mRtn'=0) {
		TRO
		Q SQLCODE	
	}
	
	;Plan
	&SQL(
		DELETE FROM SQLUser.Chemo_Plan WHERE PL_ID=:PLID
	)
	
	i SQLCODE {
		TRO
		Q SQLCODE	
	}
	TC 
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-03
/// DESC: 清除化疗方案业务数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).ClearChemoBSData()
ClassMethod ClearChemoBSData()
{
	&SQL(TRUNCATE TABLE SQLUser.Chemo_Bed)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_HospDose)
	
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanReason)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanItemSort)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanAdmLink)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanItemAdj)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanReason)
	
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanDate)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanDateStatus)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanDateApplyItem)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanDateApply)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanDateApplyStatus)
	
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanOrder)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanItem)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanGroup)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_PlanStage)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_Plan)
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-11-16
/// DESC: 清除化疗方案配置数据
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).ClearChemoBSData()
ClassMethod ClearChemoCFGData()
{
	&SQL(TRUNCATE TABLE SQLUser.Chemo_DrugDic)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_LifeDose)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_ChgReason)
	
	&SQL(TRUNCATE TABLE SQLUser.Chemo_TemplateItem)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_TemplateGroup)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_TemplateStage)
	&SQL(TRUNCATE TABLE SQLUser.Chemo_Template)
	
	Q 1
}

/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 完成化疗方案
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).OkChemoPlan()
ClassMethod OkChemoPlan(UserID, PLID, LocID, PatientID, EpisodeID)
{
	Q:PLID="" -138
	
	S Status="U"
	&SQL(
		UPDATE SQLUser.Chemo_Plan SET PL_Status=:Status WHERE PL_ID=:PLID
	)
	Q:SQLCODE'=0 -138
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-11-02
/// DESC: 删除化疗方案（实际没有删除，增加删除状态）
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).DelChemoPlan("18881","512","191","244","534")
ClassMethod DelChemoPlan(UserID, PLID, LocID, PatientID, EpisodeID)
{
	s ^TEMP("HSY",1)=$LB(UserID, PLID, LocID, PatientID, EpisodeID)
	Q:PLID="" "-147^删除失败！"
	s isdel=..IsDel(PLID)
	Q:isdel=0 "-1^已存在完成日期的方案不允许删除！"
	S Status="D"
	&SQL(
		UPDATE SQLUser.Chemo_Plan SET PL_Status=:Status WHERE PL_ID=:PLID
	)
	Q:SQLCODE'=0 "-147^删除失败！"
	
	Q "0^删除成功"
}

/// CTOR: QP
/// DATE: 2020-11-02
/// DESC: 判断能否删除方案（已经有完成的日期，不允许删除）
/// IN  : 
/// OUT : 1(可删)/0(不可删除)
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).OkChemoPlan()
ClassMethod IsDel(PLID)
{
	s mRtn=1
	s sub=""	
	for {
		s sub=$o(^BS.DOC.Chemo.PlanD(PLID,sub))
		q:(sub="")||(mRtn=0)
		s PSID=PLID_"||"_sub
		s PDDate=""
		for {
			s PDDate=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,PDDate))
			q:(PDDate="")||(mRtn=0)
			s PDID=$o(^BS.DOC.Chemo.PlanDateI("PSID",PSID,PDDate,""))
			q:PDID=""
			s PDStatus=$P(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
			i PDStatus="U" s mRtn=0
		}

	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-08-12
/// DESC: 根据组描述得到组ID
/// IN  : 
/// OUT : 6||1:56||1:HOSP {,…}
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).GetPGID("261||1","62||6","CUR")
ClassMethod GetPGID(PSID, PGDesc, InType)
{
	S ^QP("J")=$LB(PSID, PGDesc, InType)
	s PLID=+PSID
	s SID=$P(PSID,"||",2)
	s mRtn=""
	s id=""
	i (InType="CUR")||(InType="HIS") {
		f  s id=$o(^BS.DOC.Chemo.PlanD(PLID,SID,id)) q:(id="")||(mRtn'="")  d
		.s gDesc=$p(^BS.DOC.Chemo.PlanD(PLID,SID,id),"^",2)
		.i gDesc=PGDesc s mRtn=PSID_"||"_id
	} else {
		f  s id=$o(^CF.DOC.Chemo.TemplateD(PLID,SID,id)) q:(id="")||(mRtn'="")  d
		.s gDesc=$p(^CF.DOC.Chemo.TemplateD(PLID,SID,id),"^",2)
		.i gDesc=PGDesc s mRtn=PSID_"||"_id
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-10-15
/// DESC: 保存空白组
/// IN  : 
/// OUT : 6||1:56||1:HOSP {,…}
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).SaveBlankGroup("240||1")
ClassMethod SaveBlankGroup(PSID)
{
	//获取模板中的信息
	s PLID=+PSID,CH=$P(PSID,"||",2)
	s cTSID=$p(^BS.DOC.Chemo.PlanD(PLID,CH),"^",14)
	s TPID=+cTSID,SID=$P(cTSID,"||",2)
	s id=""
	s tempFlag=0
	f  s id=$o(^CF.DOC.Chemo.TemplateD(TPID,SID,id)) q:(id="")||(tempFlag'=0)  d
	.s hasChild=$o(^CF.DOC.Chemo.TemplateD(TPID,SID,id,""))
	.q:hasChild'=""
	.s TPGDesc=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,id),"^",2)
	.q:TPGDesc=""
	.s hasSave=..GetPGID(PSID,TPGDesc,"CUR")
	.Q:hasSave'=""
	.s TPGID=cTSID_"||"_id
	.s tempFlag=..StorageBlankGroup(PSID,TPGID)	
	.Q:tempFlag'=0
			
	
	Q tempFlag
}

/// CTOR: QP
/// DATE: 2020-10-15
/// DESC: 存储空白组
/// IN  : 
/// OUT : 6||1:56||1:HOSP {,…}
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).SaveBlankGroup("12||1")
ClassMethod StorageBlankGroup(PSID, TPGID)
{
	s b=##class(User.ChemoPlanGroup).%New(PSID)
	d b.PGParrefSetObjectId(PSID)
			
	s TPID=+TPGID,SID=$P(TPGID,"||",2),SUB=$P(TPGID,"||",3)
	s TPGDesc=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",2)
	s b.PGCode=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",1)
	d b.PGDescSetObjectId(TPGDesc)
	d b.PGTplGropSetObjectId(TPGID)
	s b.PGStatus="Y"
	s b.PGMainDrug=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",6)
	s PGPlanDate=$p(^CF.DOC.Chemo.TemplateD(TPID,SID,SUB),"^",3)
	s PGPlanDate=##class(DHCDoc.Chemo.COM.Func).GetTplPlanDate(PGPlanDate,1)
	s b.PGPlanDate=PGPlanDate
	s sc=b.%Save()
	if ($$$ISERR(sc)) {
		Q -143
	} 
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-10-15
/// DESC: 验证周期下所有暂存的天数信息
/// IN  : 
/// OUT : 0 验证通过
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).VailidateMultiDays("452||1")
ClassMethod VailidateMultiDays(PSID, PAAdmType)
{
	;得到所有暂存的天数
	s ^QP("VailidateMultiDays")=$LB(PSID)
	s days=##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage(PSID,"","","N",1)
	Q:days="" "-150^没有暂存状态的天数！"
	;检查是否连续
	s days2=##class(DHCDoc.Chemo.BS.DateApply).GetDateByStage(PSID,"","","N",2)
	i PAAdmType="I" {
		s isLX=##class(DHCDoc.Chemo.BS.Ext.Process).GetIsLX(days2)
		i isLX'=1 {
			//Q "-153^不连续天数不允许保存！"
		}
	}
	;检查必填项是否完整
	s mRtn=0,msg="",isSameLocOrDoc=1 ;审核科室和审核医生是否都相同
	s ALoc="",ADoc=""
	f i=1:1:$l(days,"^") {
		Q:mRtn'=0
		s cInfo=$p(days,"^",i)
		s cDate=$p(cInfo,",",1)	
		s cDesc=$p(cInfo,",",2)
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(cDate,PSID)
		i PDID="" s mRtn="-151",msg="暂存ID为空！"
		Q:PDID=""
		s isMustFill=..CheckMustFill(PDID,PSID)
		s isMust=$p(isMustFill,"^",1)
		s msg=$p(isMustFill,"^",2)
		i isMust=0 s mRtn="-152"
		Q:isMust=0 
		s CLoc=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",30)
		s CDoc=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",29)
		i ALoc="" {
			S ALoc=CLoc,ADoc=CDoc
		}else {
			i (ALoc'=CLoc)||(ADoc'=CDoc) {
				//s mRtn="-161",msg="存在审核科室和审核医生不相同，请检查！"
				//Q	
			}
		}
		
	}
	Q:mRtn'=0 mRtn_"^"_msg
	Q mRtn_"^"_msg
}

/// CTOR: QP
/// DATE: 2020-11-30
/// DESC: 检查必填项
/// IN  : 
/// OUT : 1通过，0不通过
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).CheckMustFill("400")
ClassMethod CheckMustFill(PDID, PSID)
{
	
	s mRtn=1
	
	s PLID=+PSID,SID=$P(PSID,"||",2)
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	;
	
	s POBJ=##class(User.ChemoPlanDate).%OpenId(PDID)
	s NeedUser=POBJ.PDNeedUserGetObjectId()
	s NeedLoc=POBJ.PDNeedLocGetObjectId()
	s OnTime=POBJ.PDOnTime
	S PDDate=POBJ.PDDate
	s DayNum="Day"_(PDDate-SDate+1)
	;s PDDate=##class(websys.Conversions).DateLogicalToHtml(PDDate)
	i OnTime="" {
		s msg=DayNum_"按时或推迟不能为空！"
		Q 0_"^"_msg
	}
	i NeedLoc="" {
		//s msg=DayNum_"审核科室为空！"
		//Q 0_"^"_msg
	}
	i NeedUser="" {
		//s msg=DayNum_"审核医生为空！"
		//Q 0_"^"_msg
	}
	
	
	Q 1_"^"
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 中止化疗医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).StopChemoPlan()
ClassMethod StopOrder(UserID, PatientID, EpisodeID, OrderList)
{
	
	Q:(UserID="")||(OrderList="") -154
	s mRtn=0
	f i=1:1:$l(OrderList,"^") {
		s oeori=$p(OrderList,"^",i)
		S ord=+oeori,ch=$p(oeori,"||",2)
		s statDR=$P(^OEORD(ord,"I",ch,1),"^",13)
		i statDR="" {
			s mRtn="-1"	
			Q
		}
		s statCode=$p(^OEC("OSTAT",statDR),"^",1)
		i statCode="I" {
			s mRtn="-1"	
			Q
		}
	}
	Q:mRtn'=0 mRtn
	
	s mRtn=##class(appcom.OEOrdItem).StopMulti(OrderList,UserID,"","N")
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 医嘱是否有未审核I状态
/// IN  : 
/// OUT : 1 有，0没有
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).HasOrderEqualI()
ClassMethod HasOrderEqualI(OrderList)
{
	s mRtn=0
	
	
	Q:(OrderList="") mRtn
	
	f i=1:1:$l(OrderList,"^") {
		s oeori=$p(OrderList,"^",i)
		S ord=+oeori,ch=$p(oeori,"||",2)
		s rs=##class(PHA.FACE.OUT.Com).LisGetDispensingStat(oeori)
		i rs="N" {
			s mRtn=1	
			Q	
		}
		s statDR=$P(^OEORD(ord,"I",ch,1),"^",13)
		i statDR="" {
			s mRtn=1	
			Q
		}
		s statCode=$p(^OEC("OSTAT",statDR),"^",1)
		i statCode="I" {
			s mRtn=1
			Q
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 获取被拒绝的医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).GetRefueseOrderList()
ClassMethod GetRefueseOrderList(PSID)
{
	s mRtn=""
	//
	s PLID=+PSID,SID=$P(PSID,"||",2)
	s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",21)
	Q:ChemoDate=""
	f i=1:1:$l(ChemoDate,",")	{
		s date=$p(ChemoDate,",",i)
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(date,PSID)
		continue:PDID=""
		//s PDStatus=$p(^BS.DOC.Chemo.PlanDateD(PDID),"^",23)
		s PDStatus=##class(DHCDoc.Chemo.BS.DateApply).GetPDStatus(PDID)
		q:PDStatus'["R"
		s ordStr=..GetDayOrderList(PDID,mRtn)
		i mRtn="" s mRtn=ordStr
		e  s mRtn=mRtn_","_ordStr
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-05-12
/// DESC: 获取某一天的所有医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).GetRefueseOrderList()
ClassMethod GetDayOrderList(PDID, HList = "")
{
	s mRtn=""
	s Node=""
	i $d(^BS.DOC.Chemo.PlanOrderI("PDAID",PDID)) {
		s Node="PDAID"
		
	} elseif $d(^BS.DOC.Chemo.PlanOrderI("LinkPDAID",PDID)) {
		s Node="LinkPDAID"
	} else {
		
	}
	Q:Node="" mRtn
	s id=""
	f  s id=$o(^BS.DOC.Chemo.PlanOrderI(Node,PDID)) q:id=""  d
	.s oeori=$p(^BS.DOC.Chemo.PlanOrderD(id),"^",1)
	.q:oeori=""
	.s hasFlag=##class(DHCDoc.Chemo.COM.Func).InArray(HList,oeori)
	.q:hasFlag=1
	.s ord=+oeori,sub=$p(oeori,"||",2)
	.s statDR=$P(^OEORD(ord,"I",sub,1),"^",13)
	.q:statDR=""
	.s statCode=$p(^OEC("OSTAT"),"^",1)
	.;q:(statCode="D")||(statCode="U")||(statCode="C")
	.Q:statCode'="I"
	.i mRtn="" s mRtn=oeori
	.e  s mRtn=mRtn_","_oeori 
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-22
/// DESC: 将库里面所有模板插入一个新的化疗组,存在不插入
/// IN  : DHCDoc_CT_DefineData
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).InsertGroup("62||8")
ClassMethod InsertGroup(GID)
{
	s TPID=""
	f  s TPID=$O(^CF.DOC.Chemo.TemplateD(TPID)) Q:TPID=""  D
	.s SUB=""
	.f  s SUB=$o(^CF.DOC.Chemo.TemplateD(TPID,SUB)) Q:SUB=""  D
	..s TSID=TPID_"||"_SUB
	..;判断有无改化疗组
	..s hasFlag=..HasGroup(TSID,GID)
	..Q:hasFlag=1
	..;执行插入
	..s mList=..GetMList(TSID,GID)
	..Q:mList=""
	..s mRtn=##class(DHCDoc.Chemo.CFG.Group).Save(TSID,mList)
	
	
	Q 1
}

/// CTOR: QP
/// DATE: 2021-03-22
/// DESC: 判断模板某个周期是否存在该化疗组
/// IN  : 
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).HasGroup("201||1","62||4")
ClassMethod HasGroup(TSID, GID)
{
	s mRtn=0
	s TPID=+TSID,SUB=$p(TSID,"||",2)
	s ID=""
	f  s ID=$o(^CF.DOC.Chemo.TemplateD(TPID,SUB,ID)) Q:(ID="")||(mRtn=1)  D
	.s GDescID=$P(^CF.DOC.Chemo.TemplateD(TPID,SUB,ID),"^",2)
	.Q:GDescID'=GID
	.S mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-22
/// DESC: 判断模板某个周期是否存在该化疗组
/// IN  : 
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).GetMList("201||1")
ClassMethod GetMList(TSID, GID)
{
	s mRtn=""
	s TPID=+TSID,SUB=$p(TSID,"||",2)
	s code=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,SUB,""),-1)
	Q:code="" ""	;空模板不插入
	s ID=$o(^CF.DOC.Chemo.TemplateI("ChemoTemplateGroup","Code",TPID,SUB,code,""))
	Q:ID="" ""
	s code=code+1
	s PlanDate=$P(^CF.DOC.Chemo.TemplateD(TPID,SUB,ID),"^",3)
	s mRtn="^"_code_"^"_GID_"^"_PlanDate_"^N^^N"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-22
/// DESC: 更新化疗模板类型--> 肿瘤内科
/// IN  : 肿瘤内科(新春天)：9，肿瘤内科 100， 肿瘤内科门诊 112
/// OUT : 1/0
/// EXEC: w ##class(DHCDoc.Chemo.BS.Plan).UpdateTPLType("DEP","9","100,112")
ClassMethod UpdateTPLType(Type, Desc, OtherLoc)
{
	
	&SQL(
		UPDATE SQLUser.Chemo_Template
		SET TP_Type=:Type,TP_Desc=:Desc,TP_OtherLoc=:OtherLoc
	)
	Q SQLCODE
}

}
