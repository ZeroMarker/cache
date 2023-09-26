/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 抗菌药物碳青霉烯抗菌药物业务控制类-北京版
Class DHCAnt.KSS.Extend.CQMXBJ Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 统一保存CQMX数据
/// IN  : saveType:"ANT","STOP","UNIFY"
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.CQMXBJ).UnifySaveCqmx(^TEMP("QP",1),"UNIFY",^TEMP("QP",2),"")
ClassMethod UnifySaveCqmx(saveUser As %String, saveType As %String, saveInfo As %String, execId As %String) As %String
{
	n (saveUser,saveType,saveInfo,execId)
	S ^TEMP("QP",1)=saveUser
	S ^TEMP("QP",2)=saveInfo
	s mRtn=0
	
 	s CqmxDTO=##class(DHCAnt.Base.Dto.CQMXBJ).%New()
	d CqmxDTO.XMLNodeDeserialize(.CqmxDTO, "CQMXBJ", saveInfo)
	s CurrentDate=+$H,CurrentTime=$p($h,",",2)
	if (execId="") {
		s SaveOBJ=##class(User.DHCAntCQMXModeBJ).%New()
	 }else {
		s SaveOBJ=##class(User.DHCAntCQMXModeBJ).%OpenId(execId)
	}
	
	if (saveType="UNIFY") {
		//
		d SaveOBJ.UnifyFillUserSetObjectId(saveUser)
		s SaveOBJ.UnifyFillDate=CurrentDate
		s SaveOBJ.UnifyFillTime=CurrentTime
		d SaveOBJ.LastUserSetObjectId(saveUser)
		s SaveOBJ.LastDate=CurrentDate
		s SaveOBJ.LastTime=CurrentTime
		//
		d SaveOBJ.AdmidSetObjectId(CqmxDTO.Admid)
		d SaveOBJ.LocidSetObjectId(CqmxDTO.Locid)
		d SaveOBJ.ArcimDrSetObjectId(CqmxDTO.ArcimDr)
		d SaveOBJ.AimDrSetObjectId(CqmxDTO.AimDr)
		d SaveOBJ.ApplyDrSetObjectId(CqmxDTO.ApplyDr)
		d SaveOBJ.FirstDiagnosisDrSetObjectId(CqmxDTO.FirstDiagnosisDr)
		s SaveOBJ.ApacheII=CqmxDTO.ApacheII
		i CqmxDTO.InfectionSite'="" d SaveOBJ.InfectionSiteSetObjectId(CqmxDTO.InfectionSite)
		
		s SaveOBJ.SenseHospital=CqmxDTO.SenseHospital
		d SaveOBJ.InfectionDiagnosisDrSetObjectId(CqmxDTO.InfectionDiagnosisDr)	//10
		d SaveOBJ.IndicationSetObjectId(CqmxDTO.Indication)
		d SaveOBJ.PrescAuthSetObjectId(CqmxDTO.PrescAuth)
		
		s MedicationDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.MedicationDate) 
		s StopMedicationDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.StopMedicationDate) 
		s LabDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.LabDate)
		s ReportDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.ReportDate)
		s TLJLabDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.TLJLabDate)
		s TLJReportDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.TLJReportDate)
		s BDGJLabDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.BDGJLabDate)
		s BDGJReportDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.BDGJReportDate)
		s CGJLabDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.CGJLabDate)
		s CGJReportDate=##class(websys.Conversions).DateHtmlToLogical(CqmxDTO.CGJReportDate)
		
		s SaveOBJ.MedicationDate=MedicationDate
		s SaveOBJ.StopMedicationDate=StopMedicationDate
		s SaveOBJ.MedicationNum=CqmxDTO.MedicationNum
		d SaveOBJ.MedicationEffectSetObjectId(CqmxDTO.MedicationEffect)
		d SaveOBJ.AdjustPlanSetObjectId(CqmxDTO.AdjustPlan)
		s SaveOBJ.Instruction=CqmxDTO.Instruction
		s SaveOBJ.Dose=CqmxDTO.Dose
		s SaveOBJ.EtiologyEvidence=CqmxDTO.EtiologyEvidence	//20
		s SaveOBJ.LabDate=LabDate
		s SaveOBJ.ReportDate=ReportDate
		d SaveOBJ.SpecimenTypeSetObjectId(CqmxDTO.SpecimenType)
		s SaveOBJ.LabResult=CqmxDTO.LabResult
		d SaveOBJ.BacteriaNameSetObjectId(CqmxDTO.BacteriaName)
		s SaveOBJ.CQMXResist=CqmxDTO.CQMXResist
		d SaveOBJ.CQMXResistNameSetObjectId(CqmxDTO.CQMXResistName)
		s SaveOBJ.CQMXMic=CqmxDTO.CQMXMic
		s SaveOBJ.TGCResist=CqmxDTO.TGCResist
		d SaveOBJ.TGCResistNameSetObjectId(CqmxDTO.TGCResistName)	//30
		s SaveOBJ.TGCMic=CqmxDTO.TGCMic
		s SaveOBJ.LabRelateInfectDiag=CqmxDTO.LabRelateInfectDiag
		s SaveOBJ.SideEffect=CqmxDTO.SideEffect
		d SaveOBJ.TLJSpecimenSetObjectId(CqmxDTO.TLJSpecimen)
		s SaveOBJ.TLJLabDate=TLJLabDate
		s SaveOBJ.TLJReportDate=TLJReportDate
		d SaveOBJ.BDGJSpecimenSetObjectId(CqmxDTO.BDGJSpecimen)
		s SaveOBJ.BDGJLabDate=BDGJLabDate
		s SaveOBJ.BDGJReportDate=BDGJReportDate
		d SaveOBJ.CGJSpecimenSetObjectId(CqmxDTO.CGJSpecimen)	//40
		s SaveOBJ.CGJLabDate=CGJLabDate
		s SaveOBJ.CGJReportDate=CGJReportDate
	} elseif (saveType="ANT") {
		
	} elseif (saveType="STOP") {
	
	} else {}
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		Quit "-101"
	}
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2019-04-16
/// DESC: 获取设置
/// IN  : 1:IE 2:Chrome
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCAnt.KSS.Extend.CQMXBJ).GetCqmxInfo(2,2)
ClassMethod GetCqmxInfo(Cqmxid As %String, IsIE As %String)
{
	n (Cqmxid,IsIE)
	s mRtn=""
	Q:Cqmxid="" mRtn
	s BSNoramlEntity=##class(DHCAnt.Util.Common).GetClassPropertyList("DHCAnt.Base.Dto.CQMXBJ")
	s CQMXOBJ=##class(User.DHCAntCQMXModeBJ).%OpenId(Cqmxid)
	s Len=$l(BSNoramlEntity,"^")
	if (IsIE=1) {
		s WebBSNormalDTO=##class(DHCAnt.Base.Dto.CQMXBJ).%New()
		f i=2:1:Len {
			s cName=$p(BSNoramlEntity,"^",i)
			s cValue=$ZOBJPROPERTY(CQMXOBJ, cName)
			i $ISObject(cValue) {
				s cValue=cValue.%Id()
			}
			i (cName="FirstDiagnosisDr")||(cName="InfectionDiagnosisDr") {
				s cValue=cValue_"^"_$p(^MRC("ID",cValue),"^",2)
			}
			s $ZOBJPROPERTY(WebBSNormalDTO, cName)=cValue
		}
		d WebBSNormalDTO.XMLExportToString(.mRtn)
	}elseif (IsIE=2) {
		s mRtn="[{"
		f i=2:1:Len {
			s cName=$p(BSNoramlEntity,"^",i)
			s cValue=$ZOBJPROPERTY(CQMXOBJ, cName)
			i $ISObject(cValue) {
				s cValue=cValue.%Id()
			}
			i (cName="FirstDiagnosisDr")||(cName="InfectionDiagnosisDr") {
				s cValue=cValue_"^"_$p(^MRC("ID",cValue),"^",2)
			}
			i i=2 s mRtn=mRtn_""""_cName_""":"""_cValue_""""
			e  s mRtn=mRtn_","""_cName_""":"""_cValue_""""
			
		}
		s mRtn=mRtn_"}]"
	}else{
		//todo	
	
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 查询CQMX
/// IN  :  
/// OUT : 
/// NOTE:  
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Extend.CQMXBJ","QryCqmxList","")
Query QryCqmxList(inAdmid As %String = "", inSDate As %String = "", inEDate As %String = "") As %Query(ROWSPEC = "Cqmxid,inAdmid,aaid,daupid,arcim,patName,docName,arcimDesc,fillDT,UnifyFillUser,UnifyFillDT,fillFlag")
{
}

ClassMethod QryCqmxListExecute(ByRef qHandle As %Binary, inAdmid As %String = "", inSDate As %String = "", inEDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	//s code=$$ALPHAUP^SSUTIL4(code)
 	if (inAdmid="")  {
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i inSDate'="" s inSDate=##class(websys.Conversions).DateHtmlToLogical(inSDate) 
	i inEDate'="" s inEDate=##class(websys.Conversions).DateHtmlToLogical(inEDate)
	s daupid=""
	f  s daupid=$o(^DAUP("NEWADM",inAdmid,daupid)) q:daupid=""  d
	.s oeori=$p(^DAUP("DAUP",daupid),"^",3)
	.s arcim=$p(^DAUP("DAUP",daupid),"^",21)
	.q:oeori=""
	.q:(..FilterOrdStatus(oeori)=1)
	.//跟进项目情况来定
	.q:(##class(DHCAnt.KSS.Extend.CQMX).IsCqmxOrTgc(arcim,1)=0)
	.s fillDate=$p(^DAUP("DAUP",daupid),"^",4)
	.q:((inSDate'="")&&((fillDate<inSDate)||(fillDate>inEDate)))
	.s arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)	//药品
	.s docid=$p(^DAUP("DAUP",daupid),"^",5)
	.s docName=$p(^SSU("SSUSR",docid),"^",2)	;申请医生
	.s fillTime=$p(^DAUP("DAUP",daupid),"^",14)
	.s fillDate=##class(websys.Conversions).DateLogicalToHtml(fillDate)
	.s fillTime=$zt(fillTime,2)
	.s fillDT=fillDate_" "_fillTime	;填写日期
	.s PapmiDR=$P($G(^PAADM(inAdmid)),"^",1)
	.s patName=$p($G(^PAPER(PapmiDR,"ALL")),"^",1)	;病人姓名
	.s aaid=""
	.i $d(^DHCDAAi(0,"OEORI",oeori)) s aaid=$o(^DHCDAAi(0,"OEORI",oeori,""))
	.s fillFlag=0,UnifyFillUser="",UnifyFillDT="",Cqmxid=""
	.i $d(^BS.ANT.DHCAntCQMXModeBJI("AimDr",daupid)) d
	..s Cqmxid=$o(^BS.ANT.DHCAntCQMXModeBJI("AimDr",daupid,""))
	..s fillFlag=1
	..s cqmxid=$o(^BS.ANT.DHCAntCQMXModeBJI("AimDr",daupid,""))
	..s UnifyFillDate=$p(^BS.ANT.DHCAntCQMXModeBJD(cqmxid),"^",11)
	..s UnifyFillTime=$p(^BS.ANT.DHCAntCQMXModeBJD(cqmxid),"^",12)
	..s UnifyFillUser=$p(^BS.ANT.DHCAntCQMXModeBJD(cqmxid),"^",10)
	..s UnifyFillDate=##class(websys.Conversions).DateLogicalToHtml(UnifyFillDate)
	..s UnifyFillDT=UnifyFillDate_" "_$zt(UnifyFillTime,2)
	..s UnifyFillUser=$p(^SSU("SSUSR",UnifyFillUser),"^",2)
	
	
   	.Do output1
   	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(Cqmxid,inAdmid,aaid,daupid,arcim,patName,docName,arcimDesc,fillDT,UnifyFillUser,UnifyFillDT,fillFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryCqmxListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCqmxListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCqmxListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCqmxListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 过滤医嘱状态
/// IN  : 1：退出
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.CQMXBJ).FilterOrdStatus("59||111")
ClassMethod FilterOrdStatus(oeori As %String) As %String
{
	n (oeori)
	s mRtn=1
	Q:oeori="" mRtn
	s oeoriStatusDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)	//OEC_OrderStatus
	q:oeoriStatusDr="" mRtn
	s oeoriStatusCode=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	i ((oeoriStatusCode'="U")&&(oeoriStatusCode'="C")) s mRtn=0
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 加载不良反应
/// IN  : 
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.CQMXBJ).LoadSideEffect()
ClassMethod LoadSideEffect() As %String
{
	n 
	s mRtn=""
	
	s pdcId="" f  s pdcId=$o(^DHCAntBasePurposeDataConfigI("PDCType","CQMXSideEffect",pdcId)) q:pdcId=""  d
 	.s desc=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",3)	//描述
 	.s code=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",4)	//描述
 	.s active=$p(^DHCAntBasePurposeDataConfigD(pdcId),"^",5)	//描述
 	.q:active'=1
	.i mRtn="" s mRtn=pdcId_"^"_desc_"^"_code
	.e  s mRtn=mRtn_$C(1)_pdcId_"^"_desc_"^"_code
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 获取患者基本信息
/// IN  : 
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.CQMXBJ).GetPatientInfo()
ClassMethod GetPatientInfo(admid As %String, locid As %String = "", arcim = "") As %String
{
	n (admid,locid,arcim)
	s mRtn=""
	q:admid="" mRtn
	s arcimDesc=""
	s:arcim'="" arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
	s patid=$p(^PAADM(admid),"^",1)
	s patName=$p(^PAPER(patid,"ALL"),"^",1)
	s sexid=$p(^PAPER(patid,"ALL"),"^",7)
	s sexDesc=$p(^CT("SEX",sexid),"^",2)
	s age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",patid,admid)
	s admLocid=$p(^PAADM(admid),"^",4)
	s admLoc=$p(^CTLOC(admLocid),"^",2)
	s:admLoc["-" admLoc=$p(admLoc,"-",2)
	s ipno=$p(^PAPER(patid,"PAT",1),"^",1)
	s mradmid=$p(^PAADM(admid),"^",61)
	s diagid="",findFlag=0,inDiagnosis="",icdDr=""
	f  s diagid=$o(^MR(mradmid,"DIA",diagid)) q:(diagid="")||(findFlag=1)  d
	.s icdDr=$p(^MR(mradmid,"DIA",diagid),"^",1)
	.s:icdDr'="" inDiagnosis=$p(^MRC("ID",icdDr),"^",2)
	.s sub=""
	.f  s sub=$o(^MR(mradmid,"DIA",diagid,"TYP",sub)) q:(sub="")||(findFlag=1)  d
	..s typeid=$p(^MR(mradmid,"DIA",diagid,"TYP",sub),"^",1)
	..s typeDesc=$p(^MRC("DTYP",typeid),"^",2)
	..s typeCode=$p(^MRC("DTYP",typeid),"^",1)
	..i (typeDesc["入院")||(typeCode="C008") s findFlag=1
	
	s mRtn=patName_"^"_ipno_"^"_age_"^"_inDiagnosis_"^"_sexDesc_"^"_admLoc_"^"_admLocid_"^"_arcimDesc
	
 	q mRtn
}

}
