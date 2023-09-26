/// 美康合理用药的后台数据获取类
Class web.DHCDocHLYYMK Extends (web.DHCDocHLYY, DHCDoc.Util.RegisteredObject) [ ClassType = "", ProcedureBlock ]
{

/// 用于互联网医院,医嘱录入可为空
Parameter ProductCode;

/// Creator:	jm
/// CreatDate:	2022.05.20
/// Description:美康审方系统-获取审方信息
/// Input:		EpisodeID:就诊表Rowid;  OrderItemStr:待审核医嘱串;  HLYYLayOut:OEOrd(医嘱录入)/CMOEOrd(中草药录入)
/// 				ExpStr:扩展串,用户id^科室id^院区id^系统模式(用于区分互联网医院,窗口可为空)
/// Return:		审方信息,JSON格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetPrescInfo("22956816",$lg(^jm("GetPrescInfo"),2),"OEOrd","25137^1157^2^")
ClassMethod GetPrescInfo(EpisodeID As %String, OrderItemStr As %String, HLYYLayOut As %String, ExpStr As %String) As %String
{
	s $zt="GetPrescInfoErr"
	s ^jm("GetPrescInfo")=$lb(EpisodeID,OrderItemStr,HLYYLayOut,ExpStr)
	;1.客户端信息
	s PassClientObj=##class(web.DHCDocHLYYMK).GetPassClientObj(EpisodeID,ExpStr)
	;2.病人基本信息
	s PatientObj=##class(web.DHCDocHLYYMK).GetPatientObj(EpisodeID,ExpStr)
	;3.病人过敏信息
	s ScreenAllergenList=##class(web.DHCDocHLYYMK).GetScreenAllergenList(EpisodeID)
	;4.病人诊断信息
	s ScreenMedCondList=##class(web.DHCDocHLYYMK).GetScreenMedCondList(EpisodeID)
	;5.病人药品信息
	if (HLYYLayOut="CMOEOrd") {
		s OrderItemStr=##class(web.DHCDocHLYYMK).ConvertCMOEOrdToOEOrd(EpisodeID,OrderItemStr)
	}
	s SysMode=$p(ExpStr,"^",4)
	if (SysMode="NetHosp") {
		s OrderItemStr=##class(web.DHCDocHLYYMK).ConvertNetHospOrdToOEOrd(OrderItemStr,ExpStr)
	}
	s ScreenDrugList=##class(web.DHCDocHLYYMK).GetScreenDrugList(EpisodeID,OrderItemStr,ExpStr)
	;6.病人检查申请信息
	s ScreenExamList=##class(web.DHCDocHLYYMK).GetScreenExamLabList(OrderItemStr,ExpStr,"S",EpisodeID)
	;7.病人检验申请信息
	s ScreenLabList=##class(web.DHCDocHLYYMK).GetScreenExamLabList(OrderItemStr,ExpStr,"L",EpisodeID)
	;输出审方信息
	s MKObj={}
	s MKObj.PassClient=PassClientObj
	s MKObj.Patient=PatientObj
	s MKObj.ScreenAllergenList=ScreenAllergenList
	s MKObj.ScreenMedCondList=ScreenMedCondList
	s MKObj.ScreenDrugList=ScreenDrugList
	s MKObj.ScreenExamList=ScreenExamList
	s MKObj.ScreenLabList=ScreenLabList
	;
	s MKJson=MKObj.%ToJSON()
	Q MKJson
GetPrescInfoErr
	s $zt=""
	s MKObj={}
	s MKObj.ResultCode="-1"
	s MKObj.ResultContent="美康合理用药程序异常:"_$ze
	;
	s MKJson=MKObj.%ToJSON()
	Q MKJson
}

/// Creator:	jm
/// CreatDate:	2022.05.20
/// Description:美康审方系统-获取客户端信息
/// Input:		EpisodeID:就诊表Rowid;  ExpStr:扩展串,用户id^科室id^院区id^系统模式(用于区分互联网医院,窗口可为空)
/// Return:		客户端信息,对象格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetPassClientObj("23405471","25137^1157^2^NetHosp").%ToJSON()
ClassMethod GetPassClientObj(EpisodeID As %String, ExpStr As %String) As %DynamicObject
{
	s PassClientObj={}
	s UserID=$p(ExpStr,"^",1)
	s LocID=$p(ExpStr,"^",2)
	s HospitalID=$p(ExpStr,"^",3)
	s SysMode=$p(ExpStr,"^",4)
	;单医院固定传0,区域版本同mc_hosp_match_relation表
	s PassClientObj.HospID="0"
	;医院名称
	s PassClientObj.HospName=$p($g(^CT("HOSP",HospitalID)),"^",2)
	;医生登陆工号
	s PassClientObj.UserId=$p($g(^SSU("SSUSR",UserID)),"^",1)
	;登陆医生姓名
	s PassClientObj.UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	;登陆医生科室编码
	s PassClientObj.DeptID=$p($g(^CTLOC(LocID)),"^",1)
	;登陆医生科室名称
	s PassClientObj.DeptName=$p($g(^CTLOC(LocID)),"^",2)
	;检查模式
	s PassClientObj.CheckMode=SysMode
	;代码
	s PassClientObj.ProductCode=..#ProductCode
	b ;PassClientObj.%ToJSON()
	
	Q PassClientObj
}

/// Creator:	jm
/// CreatDate:	2022.05.20
/// Description:美康审方系统-获取病人基本信息
/// Input:		EpisodeID:就诊表Rowid;  ExpStr:扩展串,用户id^科室id^院区id^系统模式(用于区分互联网医院,窗口可为空)
/// Return:		病人基本信息,对象格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetPatientObj("23405471","25137^1157^2^NetHosp").%ToJSON()
ClassMethod GetPatientObj(EpisodeID As %String, ExpStr As %String) As %DynamicObject
{
	s PatientObj={}
	s UserID=$p(ExpStr,"^",1)
	s LocID=$p(ExpStr,"^",2)
	s HospitalID=$p(ExpStr,"^",3)
	s SysMode=$p(ExpStr,"^",4)
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	;病人编号
	s PatientNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
	s PatientObj.PatCode=PatientNo
	;门诊号/住院号
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (AdmType="I") s InHospNo=##class(web.DHCDocOrderCommon).GetMrNo(EpisodeID,PatientID,AdmType,HospitalID)
	else  s InHospNo=PatientNo
	s PatientObj.InHospNo=InHospNo
	;就诊序号/住院次数
	s PatientObj.VisitCode=EpisodeID
	;病人姓名
	s PatientObj.Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	;病人性别(男,女,不详)
	s PatSexDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
 	if (PatSexDr'="") s PatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
	else  s PatSex="不详"
	s PatientObj.Sex=PatSex
	;出生日期(格式为: YYYY-MM-DD)
	s PatientDob=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s PatientObj.Birthday=$zd(PatientDob,3)
	;身高(厘米)  体重(公斤)  体温(摄氏度)
	s HeightCM="",WeighKG="",Temperature=""		
	s DiagOtherInfo=##class(web.DHCDocDiagnosEntryV8).GetDiagOtherInfo(EpisodeID)
	if (DiagOtherInfo'="") {
		s WeighKG=$p(DiagOtherInfo,$c(1),8)
		s HeightCM=$p(DiagOtherInfo,$c(1),11)
	}
	s PatientObj.HeightCM=HeightCM
	s PatientObj.WeighKG=WeighKG
	s PatientObj.Temperature=Temperature
	;就诊科室编码
	s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
	s PatientObj.DeptCode=$p($g(^CTLOC(AdmDepDr)),"^",1)
	;就诊科室名称
	s PatientObj.DeptName=$p($g(^CTLOC(AdmDepDr)),"^",2)
	;就诊/主管医生编码
	s PatientObj.DoctorCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	;就诊/主管医生姓名
	s PatientObj.DoctorName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	;病人类型(0-出院,1-住院,2-门诊,3-急诊,4-互联网病人)
	s PatStatus="1"
	if (AdmType="O") s PatStatus="2"
	if (AdmType="E") s PatStatus="3"
	if (SysMode="NetHosp") s PatStatus="4"
	s PatientObj.PatStatus=PatStatus
	;是否哺乳(-1-无法获取哺乳状态,0-不是,1-是)  是否妊娠(-1-无法获取妊娠状态,0-不是,1-是) 
	;肝损害程序(-1-无法获取肝损害状态,0-无肝损害,1-存在肝损害,但损害程度不明确,2-轻度,3-中度,4-重度)
	;肾损害程序(-1-无法获取肾损害状态,0-无肾损害,1-存在肾损害,但损害程度不明确,2-轻度,3-中度,4-重度)
	s (IsLactation,IsPregnancy,HepDamageDegree,RenDamageDegree)="-1"
	s SpecialStrCreat=$p(DiagOtherInfo,$c(1),9)
	if (("^"_SpecialStrCreat_"^")[("^"_"16"_"")) s IsLactation="1"
	if (("^"_SpecialStrCreat_"^")[("^"_"17"_"")) s IsPregnancy="1"
	if (("^"_SpecialStrCreat_"^")[("^"_"14"_"")) s HepDamageDegree="2"
	if (("^"_SpecialStrCreat_"^")[("^"_"26"_"")) s HepDamageDegree="4"
	if (("^"_SpecialStrCreat_"^")[("^"_"15"_"")) s RenDamageDegree="2"
	if (("^"_SpecialStrCreat_"^")[("^"_"27"_"")) s RenDamageDegree="4"
	s PatientObj.IsLactation=IsLactation
	s PatientObj.IsPregnancy=IsPregnancy
	s PatientObj.HepDamageDegree=HepDamageDegree
	s PatientObj.RenDamageDegree=RenDamageDegree
	;妊娠开始日期(格式为: YYYY-MM-DD)
	s PregStartDate=$p(DiagOtherInfo,$c(1),12)
	s PatientObj.PregStartDate=PregStartDate
	;审查模板
	s CheckMode="mz"
	if (AdmType="I") s CheckMode="zy"
	if (SysMode="NetHosp") s CheckMode="NetHosp"
	s PatientObj.CheckMode=CheckMode
	;是否采集(1-采集,0-不采集)
	s PatientObj.IsDoSave="1"
	;年龄
	s PatientObj.Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID,HospitalID)
	;费别
	s AdmReasonDr=$P($g(^PAADM(EpisodeID,1)),"^",7)
	s PatientObj.PayClass=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	;入院日期(格式为: YYYY-MM-DD)
	s InHospDate=""
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	if (AdmType="I") s InHospDate=$zd(AdmDate,3)
	s PatientObj.InHospDate=InHospDate
	;出院日期(格式为: YYYY-MM-DD)
	s OutHospDate=$p($g(^PAADM(EpisodeID)),"^",59)
	if (OutHospDate'="") s OutHospDate=$zd(OutHospDate,3)
	s PatientObj.OutHospDate=OutHospDate
	;是否做过病原学检查(0-未做过,1-做过)
	s PatientObj.IsTestEtiology=""
	;身份证号码
	s PatientObj.IDCard=##class(web.DHCDocService).GetIDCardNoByPatientID(PatientID)
	;病人联系电话
	s PatientObj.Telephone=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	;是否加急(0-普通,1-加急)
	s PatientObj.Urgent=""
	;医保类型(0-非医保病人,1-其他医保,2-城镇职工,3-城镇居民)
	s MedicareType="0"
	s AdmSource=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",9)
	if (+AdmSource>0) s MedicareType="1"
	s PatientObj.MedicareType=MedicareType
	;是否禁食(0-不是,>1-是) 
	s PatientObj.IsFast=""
	;病人身份(职业)
	s PatLevel=""
	s OccupationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
	if (OccupationDr'="") s PatLevel=$p($g(^CT("OCC",OccupationDr)),"^",2)
	s PatientObj.PatLevel=PatLevel
	;就医方式(1-普通住院,2-生育住院,3-工伤住院,4-新生儿住院,5-普通门诊,6-特殊门诊,7-单病种住院)
	s medicalcharge="5"
	if (AdmType="I") s medicalcharge="1"
	s PatientObj.medicalcharge=medicalcharge
	;医院级别(1-三级甲等,2-三级乙等,3-三级丙等,4-二级甲等,5-二级乙等,6-二级丙等,7-一级甲等,8-一级乙等,9-一级丙等,10-其他医院)
	s PatientObj.hospitallevel="1"
	;特殊病人超多日用量审批标记(0-未经HIS审批或审批不通过,需要PASS按正常病人审查,1-HIS系统审批通过,病人的所有药品按90天审查) 
	s PatientObj.multidaydosepriv=""
	;住院期间床号
	s bedno=""
	s AdmBedDr=$p($g(^PAADM(EpisodeID)),"^",73)
	if (AdmBedDr'="") s bedno=$p($g(^PAWARD(+AdmBedDr,"BED",$p(AdmBedDr,"||",2))),"^",1)
	s PatientObj.bedno=bedno
	;病人病案号
	s documentno=""
	if (AdmType="I") s documentno=##class(web.DHCDocOrderCommon).GetMrNo(EpisodeID,PatientID,AdmType,HospitalID)
	s PatientObj.documentno=documentno
	;是否透析病人(0-不是,1-是,-1-未知)
	s PatientObj.isdialysis="-1"
	b ;PatientObj.%ToJSON()
	
	Q PatientObj
}

/// Creator:	jm
/// CreatDate:	2022.05.20
/// Description:美康审方系统-获取病人过敏信息
/// Input:		EpisodeID:就诊表Rowid
/// Return:		病人过敏信息(如果是药品过敏,获取药品编码和名称;如果是过敏类名,获取类名编码和名称),对象格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetScreenAllergenList("23405471").%ToJSON()
ClassMethod GetScreenAllergenList(EpisodeID As %String) As %DynamicObject
{
	s ScreenAllergenList={}
	s ScreenAllergens=[]
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s ChildSub=0 for {
		s ChildSub=$o(^PAPER(PatientID,"ALG",ChildSub))
		Q:ChildSub=""
		;过敏记录开关
		s CheckConflict=$p($g(^PAPER(PatientID,"ALG",ChildSub,"DHC")),"^",3)
		;continue:CheckConflict'="Y"
		;是否开启
		s ALGStatus=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",8)
		continue:ALGStatus="I"
		s AllergicRowid=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",9)
		if (AllergicRowid'="") {
			s AllerCode=$p($g(^PAC("ALG",AllergicRowid)),"^",1)
			s AllerName=$p($g(^PAC("ALG",AllergicRowid)),"^",2)
		}else{
			s ExternalID=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",30)
			if (ExternalID'="") {
				s AllerCode=$p($g(^ARCIM(+ExternalID,$p(ExternalID,"||",2),1)),"^",1)
				s AllerName=$p($g(^ARCIM(+ExternalID,$p(ExternalID,"||",2),1)),"^",2)
			}
		}
		s ScreenAllergenObj={}
		;过敏源序号(同次参与审查必须唯一)
		s ScreenAllergenObj.Index=PatientID_"||"_ChildSub
		;过敏源编码
		s ScreenAllergenObj.AllerCode=$g(AllerCode)
		;过敏源名称
		s ScreenAllergenObj.AllerName=$g(AllerName)
		;过敏症状
		s ScreenAllergenObj.AllerSymptom=""
		;
		do ScreenAllergens.%Push(ScreenAllergenObj)
		do ScreenAllergenObj.%Close()
	}
	s ScreenAllergenList.ScreenAllergens=ScreenAllergens
	b ;ScreenAllergenList.%ToJSON()
	
	Q ScreenAllergenList
}

/// Creator:	jm
/// CreatDate:	2022.05.20
/// Description:美康审方系统-获取病人诊断信息
/// Input:		EpisodeID:就诊表Rowid
/// Return:		病人诊断信息,对象格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetScreenMedCondList("23405471").%ToJSON()
ClassMethod GetScreenMedCondList(EpisodeID As %String) As %DynamicObject
{
	s ScreenMedCondList={}
	s ScreenMedConds=[]
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s ChildSub=0 for {
		s ChildSub=$o(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""
		s MRCICDDxDR=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		continue:MRCICDDxDR=""
		s DiseaseCode=$p($g(^MRC("ID",MRCICDDxDR)),"^",4)
		s DiseaseName=$p($g(^MRC("ID",MRCICDDxDR)),"^",2)
		s MRDiagnosDate=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",7)
		s MRDiagnosTime=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",8)
		s ScreenMedCondObj={}
		;诊断序号(同次参与审查必须唯一)
		s ScreenMedCondObj.Index=MRAdmRowid_"||"_ChildSub
		;诊断编码
		s ScreenMedCondObj.DiseaseCode=DiseaseCode
		;诊断名称
		s ScreenMedCondObj.DiseaseName=DiseaseName
		;处方号
		s ScreenMedCondObj.RecipNo=""
		;诊断开始时间(格式为: YYYY-MM-DD HH:NN:SS)
		s ScreenMedCondObj.starttime=$zd(MRDiagnosDate,3)_" "_$zt(MRDiagnosTime,1)
		;诊断结束时间(格式为: YYYY-MM-DD HH:NN:SS)
		s ScreenMedCondObj.endtime=""
		;
		do ScreenMedConds.%Push(ScreenMedCondObj)
		do ScreenMedCondObj.%Close()
	}
	s ScreenMedCondList.ScreenMedConds=ScreenMedConds
	b ;ScreenMedCondList.%ToJSON()
	
	Q ScreenMedCondList
}

/// Creator:	jm
/// CreatDate:	2022.05.23
/// Description:将待审核草药数据串转换成待审核西药数据串
/// Input:		EpisodeID:就诊表RowId  CMOEOrdStr:待审核草药数据串
/// Return:		待审核西药数据串
/// Others:		w ##class(web.DHCDocHLYYMK).ConvertCMOEOrdToOEOrd("23408705","")
ClassMethod ConvertCMOEOrdToOEOrd(EpisodeID As %String, CMOEOrdStr As %String) As %String
{
	s ^jm("ConvertCMOEOrdToOEOrd")=$lb(EpisodeID,CMOEOrdStr)
	s OEOrdStr=""
	s PrescStr=$p(CMOEOrdStr,$C(2),1)
	s CMItemStr=$p(CMOEOrdStr,$c(2),2)
	;解析头信息
	s PrescPriorRowid=$p(PrescStr,"^",1)
	s PrescDurRowid=$p(PrescStr,"^",2)
	s PrescInstrRowid=$p(PrescStr,"^",3)
	s PrescFreqRowid=$p(PrescStr,"^",4)
	s PrescCookMode=$p(PrescStr,"^",5)
	s PrescOrderQty=$p(PrescStr,"^",6)
	s PrescRecDepRowid=$p(PrescStr,"^",7)
	s PrescAdmReason=$p(PrescStr,"^",8)
	s PrescNotes=$p(PrescStr,"^",9)
	s PrescEmergency=$p(PrescStr,"^",10)
	s PrescStartDate=$p(PrescStr,"^",11)
	if (PrescStartDate="") s PrescStartDate=+$h
    else  s PrescStartDate=##class(websys.Conversions).DateHtmlToLogical(PrescStartDate)
    s PrescStartDate=$zd(PrescStartDate,3)
    s PrescStartTime=$p(PrescStr,"^",12)
    if (PrescStartTime="") s PrescStartTime=$p($h,",",2)
    else  s PrescStartTime=##class(websys.Conversions).TimeHtmlToLogical(PrescStartTime)
    s PrescStartTime=$zt(PrescStartTime,1)
    ;解析处方数据
	for ItemSeq=1:1:$l(CMItemStr,$c(1)) {
		s CMItemOne=$p(CMItemStr,$c(1),ItemSeq)
		continue:CMItemOne=""
		s ARCIMRowid=$p(CMItemOne,"^",1)
		continue:ARCIMRowid=""
		s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
		continue:OrderType'="R"
		s DoseQty=$p(CMItemOne,"^",2)
		s DurFactor=$p($g(^PHCDU(PrescDurRowid)),"^",2)
		s PackQty=DoseQty*DurFactor
		s OrderPrice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,+$h,"","","","","","")
		s UnitPrice=$p(OrderPrice,"^",4)
		s DoseUOMRowid=$p(CMItemOne,"^",3)
		if (DoseUOMRowid="") s DoseUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
		if (DoseUOMRowid="") {
			s Phcdf=$P($g(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",12)
			if (Phcdf'="") s DoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
		}
		s PhSpecInstr=$p(CMItemOne,"^",4)
		;s OrderCoverMainIns="Y"
		s OrderCoverMainIns=$p(CMItemOne,"^",10)
		s OrderSeqNo=EpisodeID_"!"_PrescStartDate_"!"_PrescStartTime_"!"_ItemSeq
		s OrderMasterSeqNo=EpisodeID_"!"_PrescStartDate_"!"_PrescStartTime
		;拼接数据
		s OEOrdOne=ARCIMRowid_"^"_OrderType_"^"_PrescPriorRowid_"^"_PrescStartDate_"^"_PrescStartTime_"^"_PackQty_"^"_UnitPrice	;1-7
		s OEOrdOne=OEOrdOne_"^"_PrescRecDepRowid_"^"_PrescAdmReason_"^"_""_"^"_PrescNotes_"^"_DoseQty_"^"_DoseUOMRowid_"^"_""	;8-14
		s OEOrdOne=OEOrdOne_"^"_PrescFreqRowid_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_""_"^"_OrderMasterSeqNo_"^"_OrderSeqNo	;15-20
		s OEOrdOne=OEOrdOne_"^"_""_"^"_PhSpecInstr_"^"_OrderCoverMainIns	;21-23
		s $p(OEOrdOne,"^",30)=PrescEmergency
		s $p(OEOrdOne,"^",46)=PrescStartDate
		s $p(OEOrdOne,"^",47)=PrescStartTime
		s $p(OEOrdOne,"^",55)=DoseUOMRowid
		;
		if (OEOrdStr="") s OEOrdStr=OEOrdOne
		else  s OEOrdStr=OEOrdStr_$c(1)_OEOrdOne
	}
	Q OEOrdStr
}

/// Creator:	jm
/// CreatDate:	2022.05.23
/// Description:将互联网医院待审核医嘱串转换成医嘱录入待审核医嘱串
/// Input:		OrderItemStr:互联网医院待审核医嘱串;
/// Return:		医嘱录入待审核医嘱串
/// Others:		w ##class(web.DHCDocHLYYMK).ConvertNetHospOrdToOEOrd("23408705")
ClassMethod ConvertNetHospOrdToOEOrd(OrderItemStr As %String) As %String
{
	s OEOrdStr=""
	s OrderItemObj=[].%FromJSON(OrderItemStr)
	for i=1:1:OrderItemObj.%Size() {
		s OneItemObj=OrderItemObj.%Get(i-1)
		continue:'$IsObject(OneItemObj)
		s ARCIMRowid=OneItemObj.ARCIMRowid
		continue:ARCIMRowid=""
		s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
		s PriorRowId=OneItemObj.PriorRowId
		s StartDateTime=OneItemObj.StartDateTime
		s StartDate=$p(StartDateTime," ",1)
		s StartTime=$p(StartDateTime," ",2)
		s PackQty=OneItemObj.PackQty
		s UnitPrice=""
		s RecDepRowid=OneItemObj.RecDepRowid
		s BillTypeRowid=OneItemObj.BillTypeRowid
		s DepProcNote=OneItemObj.DepProcNote
		s DoseQty=OneItemObj.DoseQty
		s DoseUOMRowid=OneItemObj.DoseUOMRowid
		s FreqRowid=OneItemObj.FreqRowid
		s DurRowid=OneItemObj.DurRowid
		s InstrRowid=OneItemObj.InstrRowid
		s MasterSeqNo=OneItemObj.MasterSeqNo
		s OrderSeqNo=OneItemObj.SeqNo
		s PhSpecInstr=OneItemObj.PhSpecInstr
		s CoverMainIns=OneItemObj.CoverMainIns
		s NotifyClinician=OneItemObj.NotifyClinician
		s StageCode=OneItemObj.StageCode
		s SpeedFlowRate=OneItemObj.SpeedFlowRate
		s FlowRateUnit=OneItemObj.FlowRateUnit
		s UserReasonId=OneItemObj.UserReasonId
		s FirstDayTimes=OneItemObj.FirstDayTimes
		s PackUOMRowid=OneItemObj.PackUOMRowid
		;拼接数据
		s OEOrdOne=ARCIMRowid_"^"_OrderType_"^"_PriorRowId_"^"_StartDate_"^"_StartTime_"^"_PackQty_"^"_UnitPrice_"^"_RecDepRowid	;1-8
		s OEOrdOne=OEOrdOne_"^"_BillTypeRowid_"^"_""_"^"_DepProcNote_"^"_DoseQty_"^"_DoseUOMRowid_"^"_""_"^"_FreqRowid_"^"_DurRowid	;9-16
		s OEOrdOne=OEOrdOne_"^"_InstrRowid_"^"_""_"^"_MasterSeqNo_"^"_OrderSeqNo_"^"_""_"^"_PhSpecInstr_"^"_CoverMainIns	;17-23
		s $p(OEOrdOne,"^",30)=NotifyClinician
		s $p(OEOrdOne,"^",35)=StageCode
		s $p(OEOrdOne,"^",36)=SpeedFlowRate
		s $p(OEOrdOne,"^",45)=FlowRateUnit
		s $p(OEOrdOne,"^",51)=UserReasonId
		s $p(OEOrdOne,"^",55)=PackUOMRowid
		;
		if (OEOrdStr="") s OEOrdStr=OEOrdOne
		else  s OEOrdStr=OEOrdStr_$c(1)_OEOrdOne
	}
	Q OEOrdStr
}

/// Creator:	jm
/// CreatDate:	2022.05.20
/// Description:美康审方系统-获取病人药品信息
/// Input:		EpisodeID:就诊表Rowid;  OrderItemStr:待审核医嘱串;  ExpStr:扩展串,用户id^科室id^院区id^系统模式(用于区分互联网医院,窗口可为空)
/// Return:		病人药品信息,对象格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetScreenDrugList("23405471","","25137^1157^2^NetHosp").%ToJSON()
ClassMethod GetScreenDrugList(EpisodeID As %String, OrderItemStr As %String, ExpStr As %String) As %DynamicObject
{
	s ScreenDrugList={}
	s ScreenDrugs=[]
	s UserID=$p(ExpStr,"^",1)
	s HospitalID=$p(ExpStr,"^",3)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	;获取已审核医嘱数据(仅返回医嘱id)
	s VerifiedOrderInfo=##class(web.DHCDocHLYYMK).GetVerifiedOrderInfo(EpisodeID,"R")
	if (VerifiedOrderInfo'="") s OrderItemStr=OrderItemStr_$c(1)_VerifiedOrderInfo
	;药品信息(如果本次待审核医嘱没有药品,直接返回空)
	s NowDrugFlag="N"
	for ItemSeqNo=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeqNo)
		continue:OrderItemOne=""
		s ARCIMRowid=""
		s OrderType=$p(OrderItemOne,"^",2)
		if (OrderType="Verify") {
			;已审核医嘱必须传入医嘱id
			s OEORIRowid=$p(OrderItemOne,"^",1)
			continue:OEORIRowid=""
			s ARCIMRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",2)
			s DoseQty=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",1)
			s DoseUOMRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",3)
			s FreqRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",4)
			s InstrRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",7)
			s OrderStDate=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",9)
			s OrderStTime=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",10)
			s StartTime=$zd(OrderStDate,3)_" "_$zt(OrderStTime,1)
			s GroupTag=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),11)),"^",39)
			if (GroupTag="") s GroupTag=OEORIRowid
			s PriorRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",8)
			s OrderDeptId=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),7)),"^",2)
			s OrderUserId=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),7)),"^",1)
			s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
			s PackQty=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),9)),"^",4)
			s PackUOMRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),"DHC")),"^",13)
			s DurRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",6)
			s UseReasonId=$o(^DAUP("OEORI",OEORIRowid,0))
			s OrderStageCode=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),"DHC")),"^",8)
			s SpeedFlowRate=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),3)),"^",17)
			s FlowRateUnitDr=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),6)),"^",8)
			s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(+OEORIRowid,$p(OEORIRowid,"||",2))
			s SkinResult=$case(SkinAbnorm,"Y":1,"N":0,:"")
			s RecDepRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),3)),"^",6)
			s DepProcNotes=$g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),"DEP",1))
			s PhSpecInstr=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",8)
			s FirstDayTimes=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",18)
			s OrderCoverMainIns=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),3)),"^",3)
			s BillTypeRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),11)),"^",18)
		}elseif (OrderType="R"){
			;未审核医嘱只取药品
			s NowDrugFlag="Y"
			s ARCIMRowid=$p(OrderItemOne,"^",1)
			s DoseQty=$p(OrderItemOne,"^",12)
			s DoseUOMRowid=$p(OrderItemOne,"^",13)
			s FreqRowid=$p(OrderItemOne,"^",15)
			s InstrRowid=$p(OrderItemOne,"^",17)
			s OrderStDate=$p(OrderItemOne,"^",4)
			s OrderStTime=$p(OrderItemOne,"^",5)
			s StartTime=OrderStDate_" "_OrderStTime
			s GroupTag=$p(OrderItemOne,"^",19)
			if (GroupTag="") s GroupTag=$p(OrderItemOne,"^",20)
			s PriorRowid=$p(OrderItemOne,"^",3)
			s OrderDeptId=$p(ExpStr,"^",2)
			s OrderUserId=$p(ExpStr,"^",1)
			;处方号拼接规则:患者就诊ID_当前就诊ID下的处方数量+1
			;s PrescNum=+(##class(web.DHCDocHLYYMK).GetAdmPrescNum(EpisodeID))+1
			;s PrescNo=EpisodeID_"_"_$e("000000",1,6-$l(PrescNum))_PrescNum
			s PrescNo=$p(OrderItemOne,"^",88)
			s PackQty=$p(OrderItemOne,"^",6)
			s PackUOMRowid=$p(OrderItemOne,"^",55)
			s DurRowid=$p(OrderItemOne,"^",16)
			s UseReasonId=$p(OrderItemOne,"^",51)
			s OrderStageCode=$p(OrderItemOne,"^",35)
			s SpeedFlowRate=$p(OrderItemOne,"^",36)
			s FlowRateUnitDr=$p(OrderItemOne,"^",45)
			s SkinResult=""
			s RecDepRowid=$p(OrderItemOne,"^",8)
			s DepProcNotes=$p(OrderItemOne,"^",11)
			s PhSpecInstr=$p(OrderItemOne,"^",22)
			s FirstDayTimes=$p(OrderItemOne,"^",33)
			s OrderCoverMainIns=$p(OrderItemOne,"^",23)
			s BillTypeRowid=$replace($p(OrderItemOne,"^",9),$c(10),"")
			if (BillTypeRowid="") s BillTypeRowid=AdmReasonDr
		}
		continue:$g(ARCIMRowid)=""
		s ScreenDrugObj={}
		;医嘱唯一码(本次审查不能重复)
		s ScreenDrugObj.Index=ItemSeqNo
		;医嘱序号
		s ScreenDrugObj.OrderNo=ItemSeqNo
		;药品唯一码
		s ScreenDrugObj.DrugUniqueCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)
		;药品名称
		s ScreenDrugObj.DrugName=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
		;单次用量  给药单位
	    /*s PhDoseQtyUom=##class(web.DHCDocHLYYMK).GetPhDoseQtyUom(ARCIMRowid,DoseQty,DoseUOMRowid)
	    if (PhDoseQtyUom'="") {
		    s DoseQty=$p(PhDoseQtyUom,"^",1)
		    s DoseUOMRowid=$p(PhDoseQtyUom,"^",2)
	    }*/
	    s DoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(DoseUOMRowid)
	    s ScreenDrugObj.DosePerTime=DoseQty
	    s ScreenDrugObj.DoseUnit=DoseUOMDesc
	    ;用药频次
	    s Frequency=""
	    if (FreqRowid'="") s Frequency=$p($g(^PHCFR(FreqRowid)),"^",3)
	    s ScreenDrugObj.Frequency=Frequency
	    ;给药途径编码
	    s ScreenDrugObj.RouteCode=$p($g(^PHCIN(InstrRowid)),"^",2)
	    ;给药途径名称
	    s ScreenDrugObj.RouteName=$p($g(^PHCIN(InstrRowid)),"^",2)
	    ;开嘱时间(格式为: YYYY-MM-DD HH:NN:SS 或者 YYYY-MM-DD)
	    s ScreenDrugObj.StartTime=StartTime
	    ;停嘱时间(格式为: YYYY-MM-DD HH:NN:SS 或者 YYYY-MM-DD)
	    ;门诊处方传空值;住院临时医嘱停嘱时间等于开嘱时间,未停长期医嘱传空值
	    s ScreenDrugObj.EndTime=""
	    ;执行时间(格式为: YYYY-MM-DD HH:NN:SS 或者 YYYY-MM-DD)
	    s ScreenDrugObj.ExecuteTime=""
	    ;成组标识
	    s ScreenDrugObj.GroupTag=GroupTag
		;是否临时医嘱(1-临时医嘱,0-长期医嘱;门诊传0,住院长期医嘱传0,临时医嘱传1)
		s IsTempDrug=1
		if (##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)){
			s IsTempDrug=0
		}
		if (AdmType'="I") s IsTempDrug=0
		s ScreenDrugObj.IsTempDrug=IsTempDrug
		;医嘱类型(0-在用,1-已作废,2-已停嘱,3-出院带药,4-取药医嘱,9-新开)
		s PriorType="9"
		s PriorCode=$p($g(^OECPR(PriorRowid)),"^",1)
	    if (PriorCode="OUT") s PriorType="3"
	    if (PriorCode="ONE") s PriorType="4"
	    if ($g(OEORIRowid)'="") {
		    s PriorType="0"
		    s ItemStatDr=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",13)
			if (ItemStatDr'="") s StatCode=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
			if ($g(StatCode)'="V")&&($g(StatCode)'="E") s PriorType="2"
	    }
	    s ScreenDrugObj.OrderType=PriorType
	    ;就诊科室编码
	    s ScreenDrugObj.DeptCode=$p($g(^CTLOC(OrderDeptId)),"^",1)
		;就诊科室名称
		s ScreenDrugObj.DeptName=$p($g(^CTLOC(OrderDeptId)),"^",2)
		;就诊医生代码
		s ScreenDrugObj.DoctorCode=$p($g(^SSU("SSUSR",OrderUserId)),"^",1)
		;就诊医生姓名
		s ScreenDrugObj.DoctorName=$p($g(^SSU("SSUSR",OrderUserId)),"^",2)
		;处方号		
		if (AdmType="I") s PrescNo=""
		s ScreenDrugObj.RecipNo=PrescNo
		;药品开出数量
		s ScreenDrugObj.Num=PackQty
		;药品开出数量单位
	    s PackUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(PackUOMRowid)
	    s ScreenDrugObj.NumUnit=PackUOMDesc
	    ;用药天数(可用天数)
	    ;s duration=$p($g(^PHCDU(DurRowid)),"^",2)
		s duration=##class(web.DHCDocOrderEntry).CalcDurByArcim(ARCIMRowid,FreqRowid,DurRowid,PackQty,DoseQty,DoseUOMRowid,PackUOMRowid)
		if (AdmType="I")&&(PriorCode'="OUT") s duration=""
		s ScreenDrugObj.duration=duration
	 	;用药目的(1-可能预防,2-可能治疗,3-预防,4-治疗,5-预防+治疗,默认值为0)
		s Purpose=""
		if (UseReasonId'="") {
			s UseReason=$p($g(^DTAUP("AUP",UseReasonId)),"^",2)
			s Purpose=$select(UseReason["预防":3,UseReason["治疗":4,1:0)
		}
		s ScreenDrugObj.Purpose=Purpose
		;药品对应的手术编码
		s ScreenDrugObj.OprCode=""
		;用药时机(空-不能确定是否手术用药,1-术前0.5h以内用药,2-术前0.5-2h内,3-术前大于2h用药,4-术中用药,5-术后用药,6-非手术用药)
		s MediTime=$case(OrderStageCode,"SQ":"","SZ":4,"SH":5,:"")
		s ScreenDrugObj.MediTime=MediTime
		;滴速
		s driprate=""
		if (FlowRateUnitDr'="") {
			s FlowRateUnit=$p($g(^OEC("SFR",FlowRateUnitDr)),"^",2)
			s driprate=SpeedFlowRate_FlowRateUnit
		}
		s ScreenDrugObj.driprate=driprate
		;输液时间(分钟)
		s ScreenDrugObj.driptime=""
		;是否其他历史处方药品信息(1-是,0-不是)
		s IsOtherRecip="0"
		if ($g(OEORIRowid)'="") s IsOtherRecip="1"
		if (OrderUserId=UserID) s IsOtherRecip="0"
		s ScreenDrugObj.IsOtherRecip=IsOtherRecip
		;皮试结果(1-阳性,0-阴性)
		s ScreenDrugObj.skintest=SkinResult
		;药房编码
		s ScreenDrugObj.pharmacycode=$p($g(^CTLOC(RecDepRowid)),"^",1)
		;药房名称
		s ScreenDrugObj.pharmacyname=$p($g(^CTLOC(RecDepRowid)),"^",2)
		;滴速范围
		s ScreenDrugObj.driprange=""
		;是否上级授权(-1-需PASS系统审核,0-未授权,1-已授权) 
		s ScreenDrugObj.doctorpriv=""
		;医嘱备注
		s ScreenDrugObj.Remark=DepProcNotes
		;草药特殊煎煮方法名称
		s ScreenDrugObj.decoction=PhSpecInstr
		;首日用药频次标记(0-无首日频次,>0-首日频次具体值,-1-未知)
		s firstdayfreq="-1"
		if (AdmType="I")&&(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)) {
			s firstdayfreq=FirstDayTimes
		}
		s ScreenDrugObj.firstdayfreq=firstdayfreq
		;剂量类型(0-常规剂量,1-首次剂量,2-维持剂量)
		s ScreenDrugObj.dosetype=""
		;处方慢性病标识(1-慢性病,0-非慢性病,-1-未知)
		s ScreenDrugObj.isChronicDisease=""
		;付费方式(1-医保付费,2-自费,-1-未知)
		s PayClass="-1"
	    if (AdmType="I") {
		    ;s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(ARCIMRowid,AdmReasonDr,HospitalID)
			;s limitFlag=$p(ArcimLinkInsu,"^",4)
			s limitFlag=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ARCIMRowid,AdmReasonDr,HospitalID,"",9)
			if (limitFlag="1") {
				if (OrderCoverMainIns="Y") s PayClass="1"
				else  s PayClass="2"	
			}
	    }else{
    		s AdmSource=$p($g(^PAC("ADMREA",BillTypeRowid)),"^",9)
			if (+AdmSource>0) s PayClass="1"
			else  s PayClass="2"
	    }
		s ScreenDrugObj.PayClass=PayClass
		;
		do ScreenDrugs.%Push(ScreenDrugObj)
		do ScreenDrugObj.%Close()
	}
	if (NowDrugFlag="N") {
		s ScreenDrugs=[]
	}
	s ScreenDrugList.ScreenDrugs=ScreenDrugs
	b ;ScreenDrugList.%ToJSON()
	
	Q ScreenDrugList
}

/// Creator:	jm
/// CreatDate:	2022.05.23
/// Description:获取已审核医嘱信息
/// Input:		EpisodeID:就诊表Rowid  FindType:解析类型(R:药品,L:检验,S:检查)
/// Return:		医嘱信息
/// Others:		w ##class(web.DHCDocHLYYMK).GetVerifiedOrderInfo("23408707","")
ClassMethod GetVerifiedOrderInfo(EpisodeID As %String, FindType As %String = "") As %String
{
	s VerifiedOrderInfo=""
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	Q:OrderRowid="" VerifiedOrderInfo
	k VerifiedOrderArr
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (AdmType="I"){
		;住院:当天在用长期,当天停止且有执行记录长期,当天开具有效临时
		s ExStTime="" for {
			s ExStTime=$o(^OEORDi(0,"Date",OrderRowid,+$h,ExStTime))
			Q:ExStTime=""
			s OrderSub=0 for {
				s OrderSub=$o(^OEORDi(0,"Date",OrderRowid,+$h,ExStTime,OrderSub))
				Q:OrderSub=""
				s ExecSub=0 for {
					s ExecSub=$o(^OEORDi(0,"Date",OrderRowid,+$h,ExStTime,OrderSub,ExecSub))
					Q:ExecSub=""
					s ExecStatusCode=""
					s ExecStatusRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,"X",ExecSub)),"^",16)
					if (ExecStatusRowid'="") s ExecStatusCode=$p($g(^OEC("STAT",ExecStatusRowid)),"^",1)
					continue:ExecStatusCode="D"
					d GetData
				}
			}
		}
	}else{
		;门急诊传入当天所有有效
		s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
		s AdmTypeStr="O^E"
		for j=1:1:$l(AdmTypeStr,"^") {
			s AdmType=$p(AdmTypeStr,"^",j)
			s AdmRowid=0 for {
				s AdmRowid=$o(^PAPERdr(PAPMIRowid,"ADM",AdmType,AdmRowid))
				Q:AdmRowid=""
				s AdmDate=$p($g(^PAADM(AdmRowid)),"^",6)
				continue:AdmDate'=+$h
				s VisitStatus=$p($g(^PAADM(AdmRowid)),"^",20)
				continue:VisitStatus="C"
				s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(AdmRowid)
				continue:OrderRowid=""
				s OrderSub=0 for {
					s OrderSub=$o(^OEORD(OrderRowid,"I",OrderSub))
					Q:OrderSub=""
					s OrderStatusCode=""
					s OrderStatusRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",13)
					if (OrderStatusRowid'="") s OrderStatusCode=$p($g(^OEC("OSTAT",OrderStatusRowid)),"^",1)
					continue:(OrderStatusCode'="V")&&(OrderStatusCode'="E")
					d GetData
				}
			}
		}
	}
	Q VerifiedOrderInfo
GetData
	Q:$d(VerifiedOrderArr(OrderRowid_"||"_OrderSub))
	s VerifiedOrderArr(OrderRowid_"||"_OrderSub)=1
	s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",2)
	Q:ARCIMRowid=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7)
	s ServiceFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)
	Q:(FindType="R")&&(OrderType'="R")
	Q:(FindType="L")&&(OrderType'="L")
	Q:(FindType="S")&&(ServiceFlag'="1")
	;拼接数据(只需要返回医嘱id即可,数据获取放到统一方法里面)
	s OneOrderStr=OrderRowid_"||"_OrderSub_"^"_"Verify"
	if (VerifiedOrderInfo="") s VerifiedOrderInfo=OneOrderStr
	else  s VerifiedOrderInfo=VerifiedOrderInfo_$c(1)_OneOrderStr
	Q
}

/// Creator:	jm
/// CreatDate:	2022.05.25
/// Description:获取患者处方数量
/// Input:		EpisodeID:就诊表Rowid
/// Return:		患者处方数量
/// Others:		w ##class(web.DHCDocHLYYMK).GetAdmPrescNum("22956816")
ClassMethod GetAdmPrescNum(EpisodeID As %String) As %String
{
	Q:EpisodeID="" 0
	s PrescNum=0
	s PrescNoStr=""
	s QUE1Rowid=0 for {
		s QUE1Rowid=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1Rowid))
		Q:QUE1Rowid=""
		s PrescNo=$p($g(^PAQUE1(QUE1Rowid)),"^",14)
		if (PrescNoStr="") {
			s PrescNoStr=PrescNo
			s PrescNum=PrescNum+1
		}elseif (("^"_PrescNoStr_"^")'[("^"_PrescNo_"^")) {
			s PrescNoStr=PrescNoStr_"^"_PrescNo
			s PrescNum=PrescNum+1
		}
	}
	Q PrescNum
}

/// Creator:	jm
/// CreatDate:	2022.05.25
/// Description:根据单次剂量和单位获取对应药学基本单位的数量及单位
/// Input:		ARCIMRowid:医嘱项Rowid;  DoseQty:单次剂量;  DoseUOMRowid:单次剂量单位
/// Return:		药学基本单位对应的数量^药学基本单位
/// Others:		w ##class(web.DHCDocHLYYMK).GetPhDoseQtyUom("46||1","50","269")
ClassMethod GetPhDoseQtyUom(ARCIMRowid As %String, DoseQty As %String, DoseUOMRowid As %String) As %String
{
	Q:(ARCIMRowid="")||(DoseUOMRowid="") ""
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	Q:DrgformRowid="" ""
	s PhDoseUomDr=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),2)),"^",4)
	Q:(DoseUOMRowid=PhDoseUomDr) DoseQty_"^"_DoseUOMRowid
	s PhDoseQty=""
	s DrgformEq=0 for {
		s DrgformEq=$o(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",DrgformEq))
		Q:DrgformEq=""
		s EqUom=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",DrgformEq)),"^",1)
		continue:DoseUOMRowid'=EqUom
		s EqQty=$p($g(^PHCD(+DrgformRowid,"DF",$p(DrgformRowid,"||",2),"EQ",DrgformEq)),"^",2)
		s PhDoseQty=DoseQty/EqQty
	}
	s PhDoseQtyUom=PhDoseQty_"^"_PhDoseUomDr
	Q PhDoseQtyUom
}

/// Creator:	jm
/// CreatDate:	2022.05.24
/// Description:美康审方系统-获取病人检查/检验申请信息
/// Input:		OrderItemStr:待审核医嘱串;  ExpStr:扩展串,用户id^科室id^院区id^系统模式(用于区分互联网医院,窗口可为空)  FindType:解析类型(S:检查,L:检验)
/// Return:		病人检查/检验申请信息,对象格式
/// Others:		w ##class(web.DHCDocHLYYMK).GetScreenExamLabList("","").%ToJSON()
ClassMethod GetScreenExamLabList(OrderItemStr As %String, ExpStr As %String, FindType As %String, EpisodeID As %String = "") As %DynamicObject
{
	if EpisodeID'=""{
		;获取已审核医嘱数据(仅返回医嘱id)
		s VerifiedOrderInfo=##class(web.DHCDocHLYYMK).GetVerifiedOrderInfo(EpisodeID,FindType)
		if (VerifiedOrderInfo'="") s OrderItemStr=OrderItemStr_$c(1)_VerifiedOrderInfo
	}
	s ScreenExamLabList={}
	s ScreenExamLabs=[]
	;检查/检验申请信息
	for ItemSeqNo=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeqNo)
		continue:OrderItemOne=""
		continue:OrderItemOne=""
		s ARCIMRowid=""
		s OrderType=$p(OrderItemOne,"^",2)
		if (OrderType="Verify") {
			;已审核医嘱必须传入医嘱id
			s OEORIRowid=$p(OrderItemOne,"^",1)
			continue:OEORIRowid=""
			s ARCIMRowid=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",2)
			s OrderStDate=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",9)
			s OrderStTime=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",10)
			s StartDateTime=$zdt(OrderStDate_","_OrderStTime,3,1)
			s OrderUserId=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),7)),"^",1)
			s OrderDeptId=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),7)),"^",2)
		}else{
			;待审核医嘱
			s ARCIMRowid=$p(OrderItemOne,"^",1)
		    s OrderStDate=$p(OrderItemOne,"^",4)
			s OrderStTime=$p(OrderItemOne,"^",5)
			s StartDateTime=OrderStDate_" "_OrderStTime
			s OrderUserId=$p(ExpStr,"^",1)
			s OrderDeptId=$p(ExpStr,"^",2)
		}
		Continue:ARCIMRowid'["||"
		s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7)
		s ServiceFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)
		continue:(FindType="S")&&(ServiceFlag'="1")
		continue:(FindType="L")&&(OrderType'="L")
		s ScreenExamLabObj={}
		;检查申请单序号
		s ScreenExamLabObj.RequestNo=ItemSeqNo
		;检查申请项目编码
		s ScreenExamLabObj.LabExamCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)
		;检查申请项目名称
		s ScreenExamLabObj.LabExamName=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	    ;检查申请单下达时间(格式为: YYYY-MM-DD HH:NN:SS)
	    s ScreenExamLabObj.StartDateTime=StartDateTime
	    ;申请科室编码  申请科室名称
		s ScreenExamLabObj.DeptCode=$p($g(^CTLOC(OrderDeptId)),"^",1)
		s ScreenExamLabObj.DeptName=$p($g(^CTLOC(OrderDeptId)),"^",2)
		;申请医生编码  申请医生姓名
		s ScreenExamLabObj.DoctorCode=$p($g(^SSU("SSUSR",OrderUserId)),"^",1)
		s ScreenExamLabObj.DoctorName=$p($g(^SSU("SSUSR",OrderUserId)),"^",2)
		;
		do ScreenExamLabs.%Push(ScreenExamLabObj)
		do ScreenExamLabObj.%Close()
	}
	if (FindType="S") s ScreenExamLabList.ScreenExams=ScreenExamLabs
	if (FindType="L") s ScreenExamLabList.ScreenLabs=ScreenExamLabs
	
	Q ScreenExamLabList
}

/// w ##class(web.DHCDocHLYYMK).GetPrescInfo("21052996",$p(^jm("GetPrescInfo"),"###",2),"25137")
ClassMethod GetPrescInfoOld(EpisodeID As %String, OrderStr As %String, UserID As %String) As %String
{
	s ^jm("GetPrescInfoOld")=EpisodeID_"###"_OrderStr_"###"_UserID
	;患者信息
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	s PatCode=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)	;病人编号
	s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID,"","",""),"^",1)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (AdmType="I") s InHospNo=##class(web.DHCDocOrderCommon).GetMrNo(EpisodeID,PatientID,AdmType,HospId)
	else  s InHospNo=PatCode	;门诊号/住院号
	s VisitCode=EpisodeID	;就诊序号/住院次数
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)	;病人姓名
	s SexDr=$p($g(^PAPER(PatientID,"ALL")),"^",7)
 	if (SexDr'="") s Sex=$p($g(^CT("SEX",SexDr)),"^",2)
	else  s Sex=""		;病人性别
	s PatientDob=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s Birthday=$zd(PatientDob,3)	;出生日期
	s HeightCM="",WeighKG="",Temperature=""		;身高  体重  体温
	s DiagOtherInfo=##class(web.DHCDocDiagnosEntryV8).GetDiagOtherInfo(EpisodeID)
	if (DiagOtherInfo'="") {
		s WeighKG=$p(DiagOtherInfo,$c(1),8)
		s HeightCM=$p(DiagOtherInfo,$c(1),11)
	}
	s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
	s DeptCode=$p($g(^CTLOC(AdmDepDr)),"^",1)	;就诊科室编码
	s DeptName=$p($g(^CTLOC(AdmDepDr)),"^",2)	;就诊科室名称
	s DoctorCode=$p($g(^SSU("SSUSR",UserID)),"^",1)	;就诊/主管医生编码
	s DoctorName=$p($g(^SSU("SSUSR",UserID)),"^",2)	;就诊/主管医生姓名
	s PatStatus="1"		;病人类型
	if (AdmType="O") s PatStatus="2"
	if (AdmType="E") s PatStatus="3"
	s IsLactation="-1"	;是否哺乳
	s IsPregnancy="-1"	;是否妊娠
	s PregStartDate=$p(DiagOtherInfo,$c(1),14)	;妊娠开始日期
	s PregStartDate=##class(websys.Conversions).DateLogicalToHtml(PregStartDate)
	s HepDamageDegree="-1"	;肝损害程序
	s RenDamageDegree="-1"	;肾损害程序
	s SpecialStrCreat=$p(DiagOtherInfo,$c(1),9)
	if (("^"_SpecialStrCreat_"^")[("^"_"16"_"")) s IsLactation="1"
	if (("^"_SpecialStrCreat_"^")[("^"_"17"_"")) s IsPregnancy="1"
	if (("^"_SpecialStrCreat_"^")[("^"_"14"_"")) s HepDamageDegree="2"
	if (("^"_SpecialStrCreat_"^")[("^"_"26"_"")) s HepDamageDegree="4"
	if (("^"_SpecialStrCreat_"^")[("^"_"15"_"")) s RenDamageDegree="2"
	if (("^"_SpecialStrCreat_"^")[("^"_"27"_"")) s RenDamageDegree="4"
	s CheckMode="mz"	;审查模板
	if (AdmType="I") s CheckMode="zy"
	s IsDoSave="1"	;是否采集
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID,HospId)	;年龄
	s AdmReasonDr=$P($g(^PAADM(EpisodeID,1)),"^",7)
	s PayClass=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",2)	;费别
	s InHospDate=""		;入院日期
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	if (AdmType="I") s InHospDate=$zd(AdmDate,3)
	s OutHospDate=$p($g(^PAADM(EpisodeID)),"^",59)
	if (OutHospDate'="") s OutHospDate=$zd(OutHospDate,3)
	s IsTestEtiology=""	;是否做过病原学检查
	s IDCard=##class(web.DHCDocService).GetIDCardNoByPatientID(PatientID)	;身份证号码
	s Telephone=$p($g(^PAPER(PatientID,"PER",1)),"^",11)	;病人联系电话
	s Urgent=""	;是否加急
	s MedicareType="0"	;医保类型
	s AdmSource=$p($g(^PAC("ADMREA",AdmReasonDr)),"^",9)
	if (+AdmSource>0) s MedicareType="1"
	s IsFast=""	;是否禁食
	s PatLevel=""	;病人身份(职业)
	s OccupationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
	if (OccupationDr'="") s PatLevel=$p($g(^CT("OCC",OccupationDr)),"^",2)
	s medicalcharge="5"	;就医方式
	if (AdmType="I") s medicalcharge="1"
	s hospitallevel="1"	;医院级别
	s multidaydosepriv=""	;特殊病人超多日用量审批标记
	s bedno=""	;住院期间床号
	s AdmBedDr=$p($g(^PAADM(EpisodeID)),"^",73)
	if (AdmBedDr'="") s bedno=$p($g(^PAWARD(+AdmBedDr,"BED",$p(AdmBedDr,"||",2))),"^",1)
	s documentno=""		;病人病案号
	if (AdmType="I") s documentno=##class(web.DHCDocOrderCommon).GetMrNo(EpisodeID,PatientID,AdmType,HospId)
	s isdialysis="-1"	;是否透析病人
	s PatInfo=PatCode_"^"_InHospNo_"^"_VisitCode_"^"_Name_"^"_Sex_"^"_Birthday_"^"_HeightCM_"^"_WeighKG		;1-8
	s PatInfo=PatInfo_"^"_DeptCode_"^"_DeptName_"^"_DoctorCode_"^"_DoctorName_"^"_PatStatus_"^"_IsLactation	;9-14
	s PatInfo=PatInfo_"^"_IsPregnancy_"^"_PregStartDate_"^"_HepDamageDegree_"^"_RenDamageDegree_"^"_CheckMode	;15-19
	s PatInfo=PatInfo_"^"_IsDoSave_"^"_Age_"^"_PayClass_"^"_InHospDate_"^"_OutHospDate_"^"_IsTestEtiology	;20-25
	s PatInfo=PatInfo_"^"_IDCard_"^"_Telephone_"^"_Urgent_"^"_MedicareType_"^"_IsFast_"^"_Temperature_"^"_PatLevel	;26-32
	s PatInfo=PatInfo_"^"_medicalcharge_"^"_hospitallevel_"^"_multidaydosepriv_"^"_bedno_"^"_documentno_"^"_isdialysis	;33-38
	;过敏信息(如果是药品过敏,获取药品编码和名称;如果是过敏类名,获取类名编码和名称)
	s AllergyInfo=""
	s ChildSub=0 for {
		s ChildSub=$o(^PAPER(PatientID,"ALG",ChildSub))
		Q:ChildSub=""
		;过敏记录开关
		s CheckConflict=$p($g(^PAPER(PatientID,"ALG",ChildSub,"DHC")),"^",3)
		;continue:CheckConflict'="Y"
		s ALGStatus=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",8)
		continue:ALGStatus="I"
		s Allergy=""
		s AllergicRowid=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",9)
		if (AllergicRowid'="") {
			s AllergicCode=$p($g(^PAC("ALG",AllergicRowid)),"^",1)
			s AllergicDesc=$p($g(^PAC("ALG",AllergicRowid)),"^",2)
		}else{
			s ExternalID=$p($g(^PAPER(PatientID,"ALG",ChildSub)),"^",30)
			if (ExternalID'="") {
				s AllergicCode=$p($g(^ARCIM(+ExternalID,$p(ExternalID,"||",2),1)),"^",1)
				s AllergicDesc=$p($g(^ARCIM(+ExternalID,$p(ExternalID,"||",2),1)),"^",2)
			}
		}
		s AllergenType="USER"
		s AllergenReaction=""
		s Allergy=AllergicCode_"^"_AllergicDesc_"^"_AllergenType_"^"_AllergenReaction
		if (AllergyInfo="") s AllergyInfo=Allergy
		else  s AllergyInfo=AllergyInfo_$c(1)_Allergy
	}
	;诊断信息
	s MedCondInfo=""
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s ChildSub=0 for {
		s ChildSub=$o(^MR(MRAdmRowid,"DIA",ChildSub))
		Q:ChildSub=""
		s ICDDxDr=$p($g(^MR(MRAdmRowid,"DIA",ChildSub)),"^",1)
		continue:ICDDxDr=""
		s MRCode=$p($g(^MRC("ID",ICDDxDr)),"^",4)
		s MRDesc=$p($g(^MRC("ID",ICDDxDr)),"^",2)
		s MedCondType="USER"
		s MedCondStartDate=""
		s MedCondStopDate=""
		s VocabTypeCode=""
		s MedCond=MRCode_"^"_MRDesc_"^"_MedCondType_"^"_MedCondStartDate_"^"_MedCondStopDate_"^"_VocabTypeCode
		if (MedCondInfo="") s MedCondInfo=MedCond
		else  s MedCondInfo=MedCondInfo_$c(1)_MedCond
	}
	;手术信息
	s OperationInfo=""
	;医嘱信息
	s OrderInfo=""
	;处方号拼接规则:患者就诊ID_当前就诊ID下的处方数量+1
	s PrescNum=##class(web.DHCDocHLYYMK).GetAdmPrescNum(EpisodeID)
	s RecipNo=PrescNum+1
	s RecipNo=EpisodeID_"_"_$e("000",1,3-$l(PrescNum))_PrescNum
	if (AdmType="I") s RecipNo=""
	s ItemCount=$l(OrderStr,"^")
 	for i=1:1:ItemCount {
	    s OneOrderStr=$p(OrderStr,"^",i)
	    continue:OneOrderStr=""
	    s Index=$p(OneOrderStr,"!",1)	;医嘱唯一码
	    s OrderNo=$p(OneOrderStr,"!",1)	;医嘱序号
	    s ARCIMRowid=$p(OneOrderStr,"!",2)
	    continue:+ARCIMRowid=0
	    s DrugUniqueCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)	;药品唯一码
	    s DrugName=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)	;药品名称
	    s DosePerTime=$p(OneOrderStr,"!",3)	;单次用量
	    s DoseUnitDr=$p(OneOrderStr,"!",4)	;给药单位
	    s PhDoseQtyUom=##class(web.DHCDocHLYYMK).GetPhDoseQtyUom(ARCIMRowid,DosePerTime,DoseUnitDr)
	    if (PhDoseQtyUom'="") {
		    s DosePerTime=$p(PhDoseQtyUom,"^",1)
		    s DoseUnitDr=$p(PhDoseQtyUom,"^",2)
	    }
	    s DoseUnit=##class(web.DHCDocOrderCommon).GetUOMDesc(DoseUnitDr)
	    s Frequency=""	;用药频次
	    s FreqDr=$p(OneOrderStr,"!",5)
	    if (FreqDr'="") s Frequency=$p($g(^PHCFR(FreqDr)),"^",3)
	    s RouteCode="",RouteName=""	;给药途径编码  给药途径名称
		s InstrDr=$P(OneOrderStr,"!",6)
	    if (InstrDr'="") {
		    s RouteCode=$p($g(^PHCIN(InstrDr)),"^",1)
		    s RouteName=$p($g(^PHCIN(InstrDr)),"^",2)
	    }
	    s StartTime=$p(OneOrderStr,"!",7)	;开嘱时间
		if (StartTime="") s StartTime=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	    s EndTime=""		;停嘱时间
	    s ExecuteTime=""	;执行时间
	    s GroupTag=$p(OneOrderStr,"!",1)	;成组标识
	    s OrderMasterSeqNo=$p(OneOrderStr,"!",8)
	    if (OrderMasterSeqNo'="") s GroupTag=OrderMasterSeqNo
	    s IsTempDrug="1"	;是否临时医嘱
	    s PriorRowId=$p(OneOrderStr,"!",9)
		if (##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowId)){
			s IsTempDrug=0
		}
		s OrderType="9"	;医嘱类型
		s PrioCode=$p($g(^OECPR(PriorRowId)),"^",1)
	    if (PrioCode="OUT") s OrderType="3"
	    if (PrioCode="ONE") s OrderType="4"
		s DeptCode="",DeptName=""	;就诊科室编码  就诊科室名称
	    s OrderDeptId=$p(OneOrderStr,"!",10)
		if (OrderDeptId'="") {
			s DeptCode=$p($g(^CTLOC(OrderDeptId)),"^",1)
			s DeptName=$p($g(^CTLOC(OrderDeptId)),"^",2)
		}
		s DoctorCode="",DoctorName=""	;就诊医生代码  就诊医生姓名
		s OrderUserId=$p(OneOrderStr,"!",11)
		if (OrderUserId'="") {
			s DoctorCode=$p($g(^SSU("SSUSR",OrderUserId)),"^",1)
			s DoctorName=$p($g(^SSU("SSUSR",OrderUserId)),"^",2)
		}
		s RecipNo=RecipNo	;处方号
		s Num=$p(OneOrderStr,"!",13)	;药品开出数量
		s NumUnit=""	;药品开出数量单位
	    s NumUnitDr=$p(OneOrderStr,"!",14)
	 	if (NumUnitDr'="") s NumUnit=$p($g(^CT("UOM",NumUnitDr)),"^",2)
	 	s duration=""	;用药天数
		s DurationDr=$p(OneOrderStr,"!",15)
		if (DurationDr'="") s duration=$p($g(^PHCDU(DurationDr)),"^",2)
		s duration=##class(web.DHCDocOrderEntry).CalcDurByArcim(ARCIMRowid,FreqDr,DurationDr,Num,DosePerTime,DoseUnitDr,NumUnitDr)
		if (AdmType="I")&&(PrioCode'="OUT") s duration=""
		s Purpose=""	;用药目的
		s UserReasonId=$p(OneOrderStr,"!",16)
		if (UserReasonId'="") {
			s UserReason=$p($g(^DTAUP("AUP",UserReasonId)),"^",2)
			s Purpose=$select(UserReason["预防":3,UserReason["治疗":4,1:0)
		}
		s OprCode=""	;药品对应的手术编码
		s OrderStageCode=$p(OneOrderStr,"!",17)
		s MediTime=$case(OrderStageCode,"SQ":"","SZ":4,"SH":5,:"")	;用药时机
		s driprate=""	;滴速
		s SpeedFlowRate=$p(OneOrderStr,"!",18)
		s OrderFlowRateUnit=""
		s OrderFlowRateUnitDr=$p(OneOrderStr,"!",19)
		if (OrderFlowRateUnitDr'="") s OrderFlowRateUnit=$p($g(^OEC("SFR",OrderFlowRateUnitDr)),"^",2)
		if (SpeedFlowRate'="")&&(OrderFlowRateUnit'="") s driprate=SpeedFlowRate_OrderFlowRateUnit
		s driptime=""	;输液时间
		s IsOtherRecip="0"	;是否历史处方药品信息
		s skintest=""	;皮试结果
		s pharmacycode="",pharmacyname=""	;药房编码  药房名称
		s RecLocId=$p(OneOrderStr,"!",20)
		if (RecLocId'="") {
			s pharmacycode=$p($g(^CTLOC(RecLocId)),"^",1)
			s pharmacyname=$p($g(^CTLOC(RecLocId)),"^",2)
		}
		s driprange=""	;滴速范围
		s doctorpriv=""	;是否上级授权
		s Remark=$p(OneOrderStr,"!",21)	;医嘱备注
		s decoction=$p(OneOrderStr,"!",22)	;草药特殊煎煮方法名称
		s firstdayfreq="-1"	;首日用药频次标记
		if (AdmType="I")&&(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowId)) s firstdayfreq=$p(OneOrderStr,"!",23)
		s dosetype=""	;剂量类型
		s ischronicdisease=""	;处方慢性病标识
	    s PayClass="-1"	;付费方式
	    if (AdmType="I") {
		    ;s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(ARCIMRowid,AdmReasonDr,HospId)
			s limitFlag=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(ARCIMRowid,AdmReasonDr,HospId,"",9)
			if (limitFlag="1") {
				s OrderCoverMainIns=$p(OneOrderStr,"!",24)
				if (OrderCoverMainIns="Y") s PayClass="1"
				else  s PayClass="2"	
			} 
	    }else{
		    s OrderCoverMainIns=$p(OneOrderStr,"!",24)
		    if (OrderCoverMainIns="Y") s PayClass="1"
			else  s PayClass="2"
	    }
	    s Order=Index_"^"_OrderNo_"^"_DrugUniqueCode_"^"_DrugName_"^"_DosePerTime_"^"_DoseUnit_"^"_Frequency_"^"_RouteCode_"^"_RouteName	;1-9
		s Order=Order_"^"_StartTime_"^"_EndTime_"^"_ExecuteTime_"^"_GroupTag_"^"_IsTempDrug_"^"_OrderType_"^"_DeptCode_"^"_DeptName		;10-17
		s Order=Order_"^"_DoctorCode_"^"_DoctorName_"^"_RecipNo_"^"_Num_"^"_NumUnit_"^"_duration_"^"_Purpose_"^"_OprCode_"^"_MediTime	;18-26
		s Order=Order_"^"_driprate_"^"_driptime_"^"_IsOtherRecip_"^"_skintest_"^"_pharmacycode_"^"_pharmacyname_"^"_driprange	;27-33
		s Order=Order_"^"_doctorpriv_"^"_Remark_"^"_decoction_"^"_firstdayfreq_"^"_dosetype_"^"_ischronicdisease_"^"_PayClass	;34-40
		if (OrderInfo="") s OrderInfo=Order
		e  s OrderInfo=OrderInfo_$c(1)_Order
	}
	;获取已审核药品信息
	s SavedOrderInfo=##class(web.DHCDocHLYYMK).GetSavedOrderInfo(EpisodeID,UserID)
	if (SavedOrderInfo'="") s OrderInfo=OrderInfo_$c(1)_SavedOrderInfo
	b ;
	Q PatInfo_$c(2)_AllergyInfo_$c(2)_MedCondInfo_$c(2)_OperationInfo_$c(2)_OrderInfo
}

/// 获取已审核药品信息
/// w ##class(web.DHCDocHLYYMK).GetSavedOrderInfo("")
ClassMethod GetSavedOrderInfo(EpisodeID As %String, UserID As %String) As %String
{
	s ^jm("GetSavedOrderInfo")=$lb(EpisodeID,UserID)
	s SavedOrderInfo=""
	s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	Q:OrderRowid="" SavedOrderInfo
	s AdmReasonDr=$P($g(^PAADM(EpisodeID,1)),"^",7)
	s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(EpisodeID,"","",""),"^",1)
	k LoadedOrderArr
	s OrderCount=1000
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (AdmType="I"){
		;住院:当天在用长期,当天停止且有执行记录长期,当天开具有效临时
		s ExStTime="" for {
			s ExStTime=$o(^OEORDi(0,"Date",OrderRowid,+$h,ExStTime))
			Q:ExStTime=""
			s OrderSub=0 for {
				s OrderSub=$o(^OEORDi(0,"Date",OrderRowid,+$h,ExStTime,OrderSub))
				Q:OrderSub=""
				s ExecSub=0 for {
					s ExecSub=$o(^OEORDi(0,"Date",OrderRowid,+$h,ExStTime,OrderSub,ExecSub))
					Q:ExecSub=""
					s ExecStatusCode=""
					s ExecStatusRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,"X",ExecSub)),"^",16)
					if (ExecStatusRowid'="") s ExecStatusCode=$p($g(^OEC("STAT",ExecStatusRowid)),"^",1)
					continue:ExecStatusCode="D"
					d GetData
				}
			}
		}
	}else{
		;门急诊传入当天所有有效
		s PAPMIRowid=$p($g(^PAADM(EpisodeID)),"^",1)
		s AdmTypeStr="O^E"
		for j=1:1:$l(AdmTypeStr,"^") {
			s AdmType=$p(AdmTypeStr,"^",j)
			s AdmRowid=0 for {
				s AdmRowid=$o(^PAPERdr(PAPMIRowid,"ADM",AdmType,AdmRowid))
				Q:AdmRowid=""
				s AdmDate=$p($g(^PAADM(AdmRowid)),"^",6)
				continue:AdmDate'=+$h
				s VisitStatus=$p($g(^PAADM(AdmRowid)),"^",20)
				continue:VisitStatus="C"
				s OrderRowid=##class(web.DHCDocOrderEntry).GetPAADMOrderRowid(AdmRowid)
				continue:OrderRowid=""
				s OrderSub=0 for {
					s OrderSub=$o(^OEORD(OrderRowid,"I",OrderSub))
					Q:OrderSub=""
					s OrderStatusCode=""
					s OrderStatusRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",13)
					if (OrderStatusRowid'="") s OrderStatusCode=$p($g(^OEC("OSTAT",OrderStatusRowid)),"^",1)
					continue:(OrderStatusCode'="V")&&(OrderStatusCode'="E")
					d GetData
				}
			}
		}
	}
	Q SavedOrderInfo
GetData
	Q:$d(LoadedOrderArr(OrderRowid_"||"_OrderSub))
	s LoadedOrderArr(OrderRowid_"||"_OrderSub)=1
	s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",2)
	Q:ARCIMRowid=""
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	s ItemCatType=$p($g(^ARC("IC",ItemCatDR)),"^",7)
	Q:ItemCatType'="R"
	s OrderCount=OrderCount+1
	Q:OrderCount>1100	;避免超长
	s Index=OrderCount		;医嘱唯一码
	s OrderNo=OrderCount	;医嘱序号
	s DrugUniqueCode=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",1)	;药品唯一码
	s DrugName=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)	;药品名称
	s DosePerTime=$p($g(^OEORD(OrderRowid,"I",OrderSub,2)),"^",1)	;单次用量
	s DoseUnitDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,2)),"^",3)	;给药单位
	s PhDoseQtyUom=##class(web.DHCDocHLYYMK).GetPhDoseQtyUom(ARCIMRowid,DosePerTime,DoseUnitDr)
    if (PhDoseQtyUom'="") {
	    s DosePerTime=$p(PhDoseQtyUom,"^",1)
	    s DoseUnitDr=$p(PhDoseQtyUom,"^",2)
    }
	s DoseUnit=##class(web.DHCDocOrderCommon).GetUOMDesc(DoseUnitDr)
	s Frequency=""	;用药频次
	s FreqDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,2)),"^",4)
    if (FreqDr'="") s Frequency=$p($g(^PHCFR(FreqDr)),"^",3)
    s RouteCode="",RouteName=""	;给药途径编码  给药途径名称
    s InstrDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,2)),"^",7)
    if (InstrDr'="") {
	    s RouteCode=$p($g(^PHCIN(InstrDr)),"^",1)
	    s RouteName=$p($g(^PHCIN(InstrDr)),"^",2)
	}
    s SttDate=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",9)
	s SttTime=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",10)
	s StartTime=$zd(SttDate,3)_" "_$zt(SttTime,1)	;开嘱时间
    s EndTime=""		;停嘱时间
	s ExecuteTime=""	;执行时间
	s GroupTag=$p($g(^OEORD(OrderRowid,"I",OrderSub,11)),"^",39)	;成组标识
	if (GroupTag="") s GroupTag=OrderRowid_"||"_OrderSub
	s IsTempDrug="1"	;是否临时医嘱
	s PriorRowId=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",8)
	if (##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowId)){
		s IsTempDrug=0
	}
	s OrderType="0"	;医嘱类型
	s PrioCode=$p($g(^OECPR(PriorRowId)),"^",1)
	if (PrioCode="OUT") s OrderType="3"
	if (PrioCode="ONE") s OrderType="4"
	s ItemStatCode=""
	s ItemStatDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",13)
	if (ItemStatDr'="") s ItemStatCode=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
	if (ItemStatCode'="V")&&(ItemStatCode'="E") s OrderType="2"
	s DeptCode="",DeptName=""	;就诊科室编码  就诊科室名称
	s OrderDeptId=$p($g(^OEORD(OrderRowid,"I",OrderSub,7)),"^",2)
	if (OrderDeptId'="") {
		s DeptCode=$p($g(^CTLOC(OrderDeptId)),"^",1)
		s DeptName=$p($g(^CTLOC(OrderDeptId)),"^",2)
	}
	s DoctorCode="",DoctorName=""	;就诊医生代码  就诊医生姓名
	s OrderUserId=$p($g(^OEORD(OrderRowid,"I",OrderSub,7)),"^",1)
	if (OrderUserId'="") {
		s DoctorCode=$p($g(^SSU("SSUSR",OrderUserId)),"^",1)
		s DoctorName=$p($g(^SSU("SSUSR",OrderUserId)),"^",2)
	}
	s RecipNo=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",14)	;处方号
	if (AdmType="I") s RecipNo=""
	s Num=$p($g(^OEORD(OrderRowid,"I",OrderSub,9)),"^",4)	;药品开出数量
	s NumUnitDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,"DHC")),"^",13)
	s NumUnit=##class(web.DHCDocOrderCommon).GetUOMDesc(NumUnitDr)	;药品开出数量单位
	s duration=""	;用药天数
	s DurationDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,2)),"^",6) 
	if (DurationDr'="") s duration=$p($g(^PHCDU(DurationDr)),"^",2)
	s duration=##class(web.DHCDocOrderEntry).CalcDur(OrderRowid_"||"_OrderSub)
	if (AdmType="I")&&(PrioCode'="OUT") s duration=""
	s Purpose=""	;用药目的
	s UserReasonId=$o(^DAUP("OEORI",OrderRowid_"||"_OrderSub,0))
	if (UserReasonId'="") {
		s UserReason=$p($g(^DTAUP("AUP",UserReasonId)),"^",2)
		s Purpose=$select(UserReason["预防":3,UserReason["治疗":4,1:0)
	}
	s OprCode=""	;药品对应的手术编码
	s OrderStageCode=$p($g(^OEORD(OrderRowid,"I",OrderSub,"DHC")),"^",8)
	s MediTime=$case(OrderStageCode,"SQ":"","SZ":4,"SH":5,:"")	;用药时机
	s driprate=""	;滴速
	s SpeedFlowRate=$p($g(^OEORD(OrderRowid,"I",OrderSub,3)),"^",17) 
	s OrderFlowRateUnit=""
	s OrderFlowRateUnitDr=$p($g(^OEORD(OrderRowid,"I",OrderSub,6)),"^",8)
	if (OrderFlowRateUnitDr'="") s OrderFlowRateUnit=$p($g(^OEC("SFR",OrderFlowRateUnitDr)),"^",2)
	if (SpeedFlowRate'="")&&(OrderFlowRateUnit'="") s driprate=SpeedFlowRate_OrderFlowRateUnit
	s driptime=""	;输液时间
	s IsOtherRecip="1"	;是否历史处方药品信息
	if (OrderUserId=UserID) s IsOtherRecip="0"
	s SkinAbnorm=##class(web.DHCDocMainOrderInterface).GetSkinAbnorm(OrderRowid,OrderSub)
	s skintest=$case(SkinAbnorm,"Y":1,"N":0,:"")	;皮试结果
	s pharmacycode="",pharmacyname=""	;药房编码  药房名称
	s RecLocId=$p($g(^OEORD(OrderRowid,"I",OrderSub,3)),"^",6)
	if (RecLocId'="") {
		s pharmacycode=$p($g(^CTLOC(RecLocId)),"^",1)
		s pharmacyname=$p($g(^CTLOC(RecLocId)),"^",2)
	}
	s driprange=""	;滴速范围
	s doctorpriv=""	;是否上级授权	
	s Remark=$g(^OEORD(OrderRowid,"I",OrderSub,"DEP",1))	;医嘱备注
	s decoction=$p($g(^OEORD(OrderRowid,"I",OrderSub,2)),"^",8)	;草药特殊煎煮方法名称
	s firstdayfreq="-1"	;首日用药频次标记
	if (AdmType="I")&&(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowId)) {
		s firstdayfreq=$p($g(^OEORD(OrderRowid,"I",OrderSub,1)),"^",18)
	}
	s dosetype=""	;剂量类型
	s ischronicdisease=""	;处方慢性病标识	
	s PayClass="-1"	;付费方式
	if (AdmType="I") {
		s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(ARCIMRowid,AdmReasonDr,HospId)
		s limitFlag=$p(ArcimLinkInsu,"^",4)
		if (limitFlag="1") {
			s OrderCoverMainIns=$p($g(^OEORD(OrderRowid,"I",OrderSub,3)),"^",3)
			if (OrderCoverMainIns="Y") s PayClass="1"
			else  s PayClass="2"	
		} 
    }else{
	    s BillTypeRowid=$p($g(^OEORD(OrderRowid,"I",OrderSub,11)),"^",18)
    	s AdmSource=$p($g(^PAC("ADMREA",BillTypeRowid)),"^",9)
		if (+AdmSource>0) s PayClass="1"
		else  s PayClass="2"
    }
    s Order=Index_"^"_OrderNo_"^"_DrugUniqueCode_"^"_DrugName_"^"_DosePerTime_"^"_DoseUnit_"^"_Frequency_"^"_RouteCode_"^"_RouteName	;1-9
	s Order=Order_"^"_StartTime_"^"_EndTime_"^"_ExecuteTime_"^"_GroupTag_"^"_IsTempDrug_"^"_OrderType_"^"_DeptCode_"^"_DeptName		;10-17
	s Order=Order_"^"_DoctorCode_"^"_DoctorName_"^"_RecipNo_"^"_Num_"^"_NumUnit_"^"_duration_"^"_Purpose_"^"_OprCode_"^"_MediTime	;18-26
	s Order=Order_"^"_driprate_"^"_driptime_"^"_IsOtherRecip_"^"_skintest_"^"_pharmacycode_"^"_pharmacyname_"^"_driprange	;27-33
	s Order=Order_"^"_doctorpriv_"^"_Remark_"^"_decoction_"^"_firstdayfreq_"^"_dosetype_"^"_ischronicdisease_"^"_PayClass	;34-40
	if (SavedOrderInfo="") s SavedOrderInfo=Order
	else  s SavedOrderInfo=SavedOrderInfo_$c(1)_Order
	Q
}

}
