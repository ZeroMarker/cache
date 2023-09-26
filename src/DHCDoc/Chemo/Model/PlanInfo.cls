/// CTOR: QP
/// DATE: 2020-06-16
/// DESC: 化疗计划信息
Class DHCDoc.Chemo.Model.PlanInfo Extends DHCDoc.Util.RegisteredObject
{

/// 类
Property ClassName As %String;

/// 化疗方案ID
Property PLID As %String;

/// 化疗方案名称
Property PLName As %String;

/// 化疗方案备注
Property PLNote As %String;

/// 检验检查备注
Property PLExamNote As %String;

/// 周期ID
Property PSID As %String;

/// 周期代码
Property PSStage As %String;

/// 周期化疗日期
Property PSDate As %String;

/// 周期下次化疗日期
Property PSNextDate As %String;

/// 周期化疗天数(从周期开始日期计算)
Property PSDay As %String;

/// 周期开始日期
Property PSStartDate As %String;

/// 周期结束日期
Property PSEndDate As %String;

/// 是否签署知情同意书（1已签，2未签）
Property PSAgreeForm As %String;

/// 有无过敏史(1/0)
Property PSHasGMis As %String;

/// 疗效评价
Property PSTreatType As %String;

/// 治疗类别(1新辅助，2辅助，3转移，4复发，5其他)
Property PSTreatTypeNew As %String;

/// 体表面积
Property PSBSA As %String;

/// 不良反应
Property PSEffect As %String;

/// 是否确认过过敏史(1/0)
Property PSGMisOK As %String;

/// 过过敏史确认者
Property PSOKUser As %String;

/// 过过敏史确认日期
Property PSOKDate As %String;

/// 过过敏史确认时间
Property PSOKTime As %String;

/// 癌症分期
Property PSCancerStage As %String;

/// 诊断
Property PSDiagnosis As %String;

// ========================日期信息===========================

/// PDID	
Property PDID As %String;

/// 化疗日期
Property PDDate As %String;

/// 是否按时（1按时,2推迟）
Property PDOnTime As %String;

/// 推迟原因
Property PDDelayReason As %String;

Property PDStatus As %String;

Property PDNeedUser As %String;

Property PDNeedLoc As %String;

Property PDAdmDoc As %String;

Property PDPlanTime As %String;

// ========================模板信息===========================

/// 模板ID
Property TPID As %String;

/// 模板化疗单名称
Property TPName As %String;

/// 模板周期ID
Property TSID As %String;

/// 模板周期代码
Property TSStage As %String;

/// 模板周期化疗日期
Property TSDate As %String;

/// 模板周期化疗天数(从周期开始日期计算)
Property TSDay As %String;

/// 模板周期开始日期
Property TSStartDate As %String;

/// 模板周期结束日期
Property TSEndDate As %String;

// =======================额外信息===========================

/// 已保存的周期串
Property SaveStage As %String;

/// 是否需要化疗
Property NeedPL As %String;

/// 预计化疗日期串
Property PLDateS As %String;

/// 预计化疗总周期
Property PLTotalStage As %String;

// =======================生命体征信息===========================

/// 身高
Property Height As %String;

/// 体重
Property Weight As %String;

/// 体温
Property Temperature As %String;

/// 血压
Property Blood As %String;

/// 脉搏
Property Pulse As %String;

/// 血氧
Property Oxygen As %String;

/// ECOG得分
Property ECOG As %String;

/// 口腔粘膜炎评分	
Property KQScore As %String;

/// 数据来源信息	
Property DataSR As %String;

/// 血清肌酸酐	
Property SC As %String;

/// 年龄	
Property Age As %String;

/// 性别	
Property Sex As %String;

/// BSA	
Property BSA As %String;

/// GFR	
Property GFR As %String;

/// GMisFill	
Property GMisFill As %String;

/// OtherFill	
Property OtherFill As %String;

/// 所选日期是否为当前日期	
Property IsCurDate As %String;

/// 所选日期是否为Day1	
Property IsCurDateDay1 As %String;

/// 是否可以编辑第一天	
Property IsEditDay1 As %String;

/// 化疗方案标题
Property ChemoTitle As %String;

/// 是不是本人的方案
Property IsSelfUser As %String;

// =======================额外信息===========================

/// 医嘱类型
Property ShortOrderPrior As %String;

/// OrderPriorRowid
Property ShortOrderPriorRowid As %String;

/// w ##class(DHCDoc.Chemo.Model.PlanInfo).GetInfo("692||1","CUR","39","1100","2021-01-26","O")
ClassMethod GetInfo(TSID, InType, PatientID, EpisodeID, SelectDate = "", PAAdmType = "", SessionStr = "") As DHCDoc.Chemo.Model.PlanInfo
{
	S ^QP("GetInfo",1)=$LB(TSID, InType, PatientID, EpisodeID,SelectDate,PAAdmType,SessionStr="")
	S MObj=##class(DHCDoc.Chemo.Model.PlanInfo).%New()
	S MObj.ClassName="DHCDoc.Chemo.Model.PlanInfo"
	Q:(TSID="")||(InType="") MObj
	s langid=..%LanguageID()
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",""))
	s OrderPrior=$p(^OECPR(OrderPriorRowid),"^",2)
	s MObj.ShortOrderPrior=OrderPrior
	s MObj.ShortOrderPriorRowid=OrderPriorRowid
	s InUser=$p(SessionStr,"^",1)
	i (InType="CUR")||(InType="HIS") {
		S PLID=$p(TSID,"||",1)
		S PSID=TSID
		S PLObj=##class(User.ChemoPlan).%OpenId(PLID)
		S PSObj=##class(User.ChemoPlanStage).%OpenId(TSID)
		S CTPID=PLObj.PLTemplateDRGetObjectId()
		S PLUser=PLObj.PLOrderUserGetObjectId()
		i PLUser=InUser s MObj.IsSelfUser=1
		e  s MObj.IsSelfUser=0
		s MObj.ChemoTitle=##class(DHCDoc.Chemo.CFG.Template).GetTPLTitle(CTPID)
		S MObj.PLID=PLID
		S MObj.PLName=PLObj.PLName
		s MObj.PLName=##class(User.ChemoTemplate).GetTranByDesc("TPName",MObj.PLName,langid)
		S MObj.PLNote=PLObj.PLNote
		S AmdID=PLObj.PLAdmDRGetObjectId()
		S Diagnosis=##class(DHCDoc.Chemo.COM.CallMethod).GetAllDiagnosis(AmdID)
		S MObj.PDAdmDoc=##class(DHCDoc.Chemo.COM.CallMethod).GetAdmDoc(AmdID)
		S MObj.PSDiagnosis=Diagnosis
		S MObj.PLExamNote=PLObj.PLExamNote
		S MObj.PSID=PSID
		S MObj.PSStage=PSObj.PSStage
		S SelectDateVal=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
		i SelectDateVal=+$H s MObj.IsCurDate=1
		e  s MObj.IsCurDate=0
		S CDate=##class(websys.Conversions).DateLogicalToHtml(+$H)
		i SelectDate'="" S MObj.PSDate=SelectDate
		e  S MObj.PSDate=CDate
		s MObj.IsCurDateDay1=##class(DHCDoc.Chemo.BS.Ext.Process).IsFirstDay(PSID, SelectDate)
		S MObj.PSNextDate=##class(DHCDoc.Chemo.BS.Apply).GetNextDay(TSID)
		S PLDateS=##class(DHCDoc.Chemo.BS.Apply).GetPLDateS(TSID)
		S MObj.PLDateS=PLDateS
		;i PLDateS[CDate s MObj.NeedPL=1
		;e  s MObj.NeedPL=0
		S MObj.PDPlanTime=PSObj.PSPlanTime
		S MObj.PSStartDate=PSObj.PSStartDate
		S MObj.PSEndDate=PSObj.PSEndDate
		s PLDateSNum=##class(websys.Conversions).DateHtmlToLogical(MObj.PSDate)
		S MObj.PSDay=(PLDateSNum-PSObj.PSStartDate+1)
		S MObj.PSAgreeForm=PSObj.PSAgreeForm
		S MObj.PSHasGMis=PSObj.PSHasGMis
		S MObj.PSTreatType=PSObj.PSTreatType
		S MObj.PSTreatTypeNew=PSObj.PSTreatTypeNew
		//S MObj.PSBSA=PSObj.PSBSA
		S MObj.PSEffect=PSObj.PSEffect
		S MObj.PSGMisOK=PSObj.PSGMisOK
		S MObj.PSOKUser=PSObj.PSOKUser
		S MObj.PSOKDate=PSObj.PSOKDate
		S MObj.PSOKTime=PSObj.PSOKTime
		S MObj.PSCancerStage=PSObj.PSCancerStage
		//i MObj.PSCancerStage="" s MObj.PSCancerStage=##class(web.DHCDocDiagnosNew).GetMainDiagTNMByAdm(EpisodeID)
		S MObj.OtherFill=PSObj.PSOhterFill
		S MObj.PDOnTime=PSObj.PSOnTime
		S MObj.PDDelayReason=PSObj.PSDelayReason
		;B ;001
		S MObj.PDDate=""
		;S MObj.PDOnTime=""
		;S MObj.PDDelayReason=""
		S MObj.TPID=PLObj.PLTemplateDRGetObjectId()
		S MObj.PLTotalStage=$p(^CF.DOC.Chemo.TemplateD(MObj.TPID),"^",4)
		//得到化疗日期信息对象
		s PDDate=##class(websys.Conversions).DateHtmlToLogical(MObj.PSDate)
		s PDID=$O(^BS.DOC.Chemo.PlanDateI("PSID",TSID,PDDate,""))
		s Day1LocDoc=##class(DHCDoc.Chemo.COM.Func2).GetDay1LocAndDoc(TSID)
		i Day1LocDoc'="" {
			S MObj.PDNeedLoc=$P(Day1LocDoc,"^",2)
			S MObj.PDNeedUser=$P(Day1LocDoc,"^",1)
		}
		
		if (PDID'="") {
			S MObj.PDID=PDID
			S PDObj=##class(User.ChemoPlanDate).%OpenId(PDID)
			S MObj.Height=PDObj.PDHeight
			S MObj.Weight=PDObj.PDWeight
			S MObj.Temperature=PDObj.PDTemperature
			S MObj.Blood=PDObj.PDBlood
			S MObj.Pulse=PDObj.PDPulse
			S MObj.Oxygen=PDObj.PDOxygen
			S MObj.ECOG=PDObj.PDECOG
			S MObj.KQScore=PDObj.PDKQScore
			S MObj.DataSR=PDObj.PDDataSR
			S MObj.SC=PDObj.PDSC
			S MObj.BSA=PDObj.PDBSA
			S MObj.GFR=PDObj.PDGFR
			S MObj.PDOnTime=PDObj.PDOnTime
			S MObj.PDDelayReason=PDObj.PDDelayReason
			i PDObj.PDGMiSFill="" {
				//S MObj.GMisFill=PSObj.PSGMisFill
			} else {
				S MObj.GMisFill=PDObj.PDGMiSFill
			}
			
			//i MObj.GMisFill="" s MObj.GMisFill=##class(web.DHCDocAllergyEnter).QueryAllergyInfoStr1(PatientID)
			i MObj.PSHasGMis'=1 {
				//i MObj.GMisFill="" s MObj.GMisFill=##class(DHCDoc.Chemo.COM.CallMethod).QueryAllergyInfoStr(PatientID)
				//i MObj.GMisFill'="" s MObj.PSHasGMis=1
			}
			s MObj.PSHasGMis=PDObj.PDHasGMis
			S MObj.PLExamNote=PDObj.PDExamNote
			S MObj.PDStatus=PDObj.PDStatus
			S MObj.PDNeedUser=PDObj.PDNeedUserGetObjectId()
			S MObj.PDNeedLoc=PDObj.PDNeedLocGetObjectId()
			S MObj.PDPlanTime=PDObj.PDPlanTime
			
		} else {
			S VSInfo=##class(DHCDoc.Chemo.COM.CallMethod).GetLastVSInfo(EpisodeID,PAAdmType)
			S MObj.Height=$P(VSInfo,$C(1),1)
			S MObj.Weight=$P(VSInfo,$C(1),2)
			S MObj.Temperature=$P(VSInfo,$C(1),3)
			S MObj.Blood=$P(VSInfo,$C(1),4)
			S MObj.Pulse=$P(VSInfo,$C(1),5)
			S MObj.Oxygen=$P(VSInfo,$C(1),6)
			S MObj.ECOG=$P(VSInfo,$C(1),7)
			S MObj.KQScore=$P(VSInfo,$C(1),8)
			S MObj.DataSR=$P(VSInfo,$C(1),9)
			S SC=##class(DHCDoc.Chemo.COM.CallMethod).GetSCValue(EpisodeID)
			I SC="" S SC=PSObj.PSSC
			S MObj.SC=SC
			S MObj.GMisFill=PSObj.PSGMisFill
			//i MObj.GMisFill="" {
				s MObj.GMisFill=##class(DHCDoc.Chemo.COM.CallMethod).QueryAllergyInfoStr(PatientID)
				i MObj.GMisFill'="" s MObj.PSHasGMis=1
			//}
		}
		if (MObj.PDStatus="S")||(MObj.PDStatus="C")||(MObj.PDStatus="U")||(MObj.PDStatus="Y") {
			s MObj.NeedPL=0
		} else {
			s MObj.NeedPL=1
		}
		
		if (MObj.PDStatus="")||(MObj.PDStatus="N"){
			if (MObj.IsCurDateDay1=1) s MObj.IsEditDay1=1
			e  s MObj.IsEditDay1=0		//不是第一天暂存状态也允许其修改
		} else  {
			s MObj.IsEditDay1=0
			
		}
		S SexDR=$P(^PAPER(PatientID,"ALL"),"^",7)
		S Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
		i SexDR'="" {
			S Sex=$p(^CT("SEX",SexDR),"^",1)
			S MObj.Sex=Sex
		}
		i (Age["月")||(Age["天") {
			S MObj.Age=1	
		} else {
			S MObj.Age=+Age
		} 
		
	} else {
		S TSObj=##class(User.ChemoTemplateStage).%OpenId(TSID)
		I '$ISObject(TSObj) {
			Q MObj
		}
		S Diagnosis=##class(DHCDoc.Chemo.COM.CallMethod).GetAllDiagnosis(EpisodeID)
		S MObj.PDAdmDoc=##class(DHCDoc.Chemo.COM.CallMethod).GetAdmDoc(EpisodeID)
		S MObj.PSDiagnosis=Diagnosis
		
		//得到患者当前的化疗单ID
		s PLID=##class(DHCDoc.Chemo.BS.Apply).GetCurrentPlan(PatientID, EpisodeID)
		s PLID=##class(DHCDoc.Chemo.COM.Func2).GetPLIDByTpl(PLID,TSID)
		s SaveStage=""
		if (PLID'="") {
			s stage=""
			f  s stage=$o(^BS.DOC.Chemo.PlanI("ChemoPlanStage","Stage",PLID,stage)) q:stage=""  d
			.i SaveStage="" s SaveStage=stage
			.e  s SaveStage=SaveStage_","_stage
			
		}
		S TPID=$p(TSID,"||",1)
		S MObj.TPID=TPID
		s MObj.ChemoTitle=##class(DHCDoc.Chemo.CFG.Template).GetTPLTitle(TPID)
		S MObj.TPName=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",3)
		s MObj.TPName=##class(User.ChemoTemplate).GetTranByDesc("TPName",MObj.TPName,langid)
		S MObj.PLTotalStage=$p(^CF.DOC.Chemo.TemplateD(TPID),"^",4)
		S MObj.TSID=TSID
		S MObj.TSStage=TSObj.TSStage
		S MObj.SaveStage=SaveStage
		S MObj.PLID=PLID
		
		S VSInfo=##class(DHCDoc.Chemo.COM.CallMethod).GetLastVSInfo(EpisodeID,PAAdmType)
		S MObj.Height=$P(VSInfo,$C(1),1)
		S MObj.Weight=$P(VSInfo,$C(1),2)
		S MObj.Temperature=$P(VSInfo,$C(1),3)
		S MObj.Blood=$P(VSInfo,$C(1),4)
		S MObj.Pulse=$P(VSInfo,$C(1),5)
		S MObj.Oxygen=$P(VSInfo,$C(1),6)
		S MObj.ECOG=$P(VSInfo,$C(1),7)
		S MObj.KQScore=$P(VSInfo,$C(1),8)
		S MObj.DataSR=$P(VSInfo,$C(1),9)
		S SC=##class(DHCDoc.Chemo.COM.CallMethod).GetSCValue(EpisodeID)
		S MObj.SC=SC
		
		S SexDR=$P(^PAPER(PatientID,"ALL"),"^",7)
		S Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
		i SexDR'="" {
			S Sex=$p(^CT("SEX",SexDR),"^",1)
			S MObj.Sex=Sex
		}
		i (Age["月")||(Age["天") {
			S MObj.Age=1	
		} else {
			S MObj.Age=+Age
		} 
		s MObj.GMisFill=##class(DHCDoc.Chemo.COM.CallMethod).QueryAllergyInfoStr(PatientID)
		;s MObj.GMisFill=##class(web.DHCDocAllergyEnter).QueryAllergyInfoStr1(PatientID)
		i MObj.GMisFill'="" s MObj.PSHasGMis=1	
		s MObj.IsCurDate=0
		s MObj.IsSelfUser=1 //模板都让进行保存操作
	}
	b ;001
	Q MObj
}

}
