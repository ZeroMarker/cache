Class web.DHCDocHLYYDHC Extends DHCDoc.Util.RegisteredObject
{

/// Creator:    nk 
/// CreatDate:	2023.02.13
/// Description:医为审方系统-获取审方信息
/// Input:		EpisodeID:就诊表Rowid;  Action:应用场景（CheckRule：用药审查,EduRule 用药指导，Audit 处方审核）
/// 				OrderItemStr:待审核医嘱串;  HLYYLayOut:OEOrd(医嘱录入)/CMOEOrd(中草药录入)
/// 			ExpStr:扩展串,用户id^科室id^院区id^安全组^系统模式(用于区分互联网医院,窗口可为空)
/// Return:		审方信息,JSON格式
/// Others:		w ##class(web.DHCDocHLYYDHC).GetPrescInfo("43","Audit",$lg(^tmplog("GetPrescInfo"),3),$lg(^tmplog("GetPrescInfo"),4),$lg(^tmplog("GetPrescInfo"),5))
ClassMethod GetPrescInfo(EpisodeID As %String, Action As %String, OrderItemStr As %String, HLYYLayOut As %String, ExpStr As %String)
{
	s $zt="GetPrescInfoErr"
	s ^tmplog("GetPrescInfo")=$lb(EpisodeID,Action,OrderItemStr,HLYYLayOut,ExpStr)
    ;1.病人基本信息
	s PatientObj=..GetPatientObj(EpisodeID,Action,ExpStr)
	;2.病人诊断信息
	s ScreenDiagList=..GetScreenDiagList(EpisodeID)
	;3.病人过敏信息
	s ScreenAllergenList=..GetScreenAllergenList(EpisodeID)
	;4.病人手术信息
	s ScreenOperationsList=..GetOperationsList(EpisodeID)
	
	;5.病人药品信息
	if (HLYYLayOut="CMOEOrd") {
		s OrderItemStr=..ConvertCMOEOrdToOEOrd(EpisodeID,OrderItemStr)
	}
	s SysMode=$p(ExpStr,"^",5)
	if (SysMode="NetHosp") {
		if ..%IsValidMethod("web.DHCDocHLYYMK","ConvertNetHospOrdToOEOrd"){
			s OrderItemStr=##class(web.DHCDocHLYYMK).ConvertNetHospOrdToOEOrd(OrderItemStr,ExpStr)
		}
	}
	s StartSeqNo=0
	s ScreenDrugList=..GetScreenDrugList(EpisodeID,OrderItemStr,ExpStr,.StartSeqNo) ;这里StartSeqNo用于获取之后已审核医嘱的起始序号
	;6.病人已审核医嘱信息
	if Action'="Audit"{
		s HisOrderStr=""
		if +StartSeqNo>0{
			s HisOrderStr=..GetVerifiedOrderInfo(EpisodeID,"R")
		}
		s HisOrderList=..GetScreenDrugList(EpisodeID,HisOrderStr,ExpStr,StartSeqNo) ;这里StartSeqNo用于设置已审核医嘱的起始序号
	}else{
		s HisOrderList={}	
	}
	;输出审方信息
	s PrescObj={}
	s PrescObj.Patient=PatientObj
	s PrescObj.ScreenDiagList=ScreenDiagList
	s PrescObj.ScreenAllergenList=ScreenAllergenList
	s PrescObj.ScreenOperationsList=ScreenOperationsList
	s PrescObj.ScreenDrugList=ScreenDrugList
	s PrescObj.HisOrderList=HisOrderList
	;
	s PrscJson=PrescObj.%ToJSON()
	Q PrscJson
GetPrescInfoErr
	s $zt=""
	s ErrObj={}
	s ErrObj.ResultCode="-1"
	s ErrObj.ResultContent="医为合理用药程序GetPrescInfo异常:"_$ze
	;
	s ErrJson=ErrObj.%ToJSON()
	Q ErrJson
}

/// Creator:	nk
/// CreatDate:	2023.02.13
/// Description:医为合理用药-获取病人基本信息
/// Input:		EpisodeID:就诊表Rowid;  ExpStr:扩展串,用户id^科室id^院区id^系统模式(用于区分互联网医院,窗口可为空)
/// Return:		病人基本信息,对象格式
/// Others:		w ##class(web.DHCDocHLYYDHC).GetPatientObj("43","1^1^2^1").%ToJSON()
ClassMethod GetPatientObj(EpisodeID As %String, Action As %String, ExpStr As %String) As %DynamicObject
{
	s PatientObj={}
	s UserID=$p(ExpStr,"^",1)
	s LocID=$p(ExpStr,"^",2)
	s HospitalID=$p(ExpStr,"^",3)
	s GroupID=$p(ExpStr,"^",4)
	s AdtMsgID=$p(ExpStr,"^",6)
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Q:PatientID="" PatientObj
	;病人编号
	s PatientNo=$P($g(^PAPER(PatientID,"PAT",1)),"^",1)
    s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
    s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
    if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
    else  s PatientSex=""
    s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
    s PatientBirthday=$ZD($G(PatientDOB),3)
    
    ;身高(厘米)  体重(公斤)  体温(摄氏度)
	s HeightCM="",WeighKG="",Temperature=""
    s BloodPress=""    // 血压  
    s SpecGrpsIDStr="",SpecGrpsDesc=""    //特殊人群 
    s DiagOtherInfo=##class(web.DHCDocDiagnosEntryV8).GetDiagOtherInfo(EpisodeID)
	if (DiagOtherInfo'="") {
		s BPSystolic=$p(DiagOtherInfo,$c(1),6)
		s BPDiastolic=$p(DiagOtherInfo,$c(1),7)
		s WeighKG=$p(DiagOtherInfo,$c(1),8)
		s SpecGrpsIDStr=$p(DiagOtherInfo,$c(1),9)
		s HeightCM=$p(DiagOtherInfo,$c(1),11)
		s Temperature=$p(DiagOtherInfo,$c(1),15)
		s BloodPress=BPSystolic_"~"_BPDiastolic
	}
    s AdmReason=$P($g(^PAADM(EpisodeID,1)),"^",7)    
    s PAAdmReason=""  // 费别 (医保,自费) 
    s:AdmReason'="" PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
    s ProfessProp=""  // 职业
    s OccupationDR=$p($g(^PAPER(PatientID,"PER",2)),"^",6)
    s:OccupationDR'="" ProfessProp=$p($g(^CT("OCC",OccupationDR)),"^",2)
    s PatType=""  // 患者类别(门诊,住院,急诊) 
    s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
    s PatType=$CASE(PAAdmType,"E":"急诊","O":"门诊","I":"住院")
    s EpisodeLocID=$p($g(^PAADM(EpisodeID)),"^",4)
    s EpisodeLocCode=$p($g(^CTLOC(EpisodeLocID)),"^",1)
    s EpisodeLocDesc=$p($g(^CTLOC(EpisodeLocID)),"^",2)
    s PatLoc=EpisodeLocDesc  // 就诊科室
    s AdmDocCodeDR=$p($g(^PAADM(EpisodeID)),"^",9)
	s DocDesc=""
	if (AdmDocCodeDR'=""){
		s DocDesc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
	}
    s MainDoc=DocDesc  							// 主管医生
    s HOSPDESC=$p(^CT("HOSP",HospitalID),"^",2) // 医院(登录信息)
    s Profess="" 								// 职称(登录用户)
    s GROUPDESC=$p(^SSU("SSGRP",GroupID),"^",1) // 安全组  
    s CTLOCDESC=$p(^CTLOC(LocID),"^",2) 		// 登录科室 2020/12/1
    s USERNAME=$p(^SSU("SSUSR",UserID),"^",2) 	// 登录用户  2020/12/1
    s SpecGrpsAry=[]
    if (SpecGrpsIDStr'="") {
		for loop=1:1:$l(SpecGrpsIDStr,"^"){
			s SpecGrpId=$p(SpecGrpsIDStr,"^",loop)
			continue:SpecGrpId=""
			s desc=$p($g(^CT("CTSPECR",SpecGrpId)),"^",2)
			do SpecGrpsAry.%Push(desc)
			if SpecGrpsDesc=""{
				s SpecGrpsDesc=desc
			}else{
				s SpecGrpsDesc=SpecGrpsDesc_$c(1)_desc
			}
		}
    }
	
	s PatientObj.MsgID=""					//日志监测id	必需
	s PatientObj.AdtMsgID=AdtMsgID			//日志监测id	必需
	s PatientObj.Action=Action				//应用场景（CheckRule：用药审查,EduRule 用药指导，Audit 处方审核）必需
	s PatientObj.PatName = PatientName		// 病人姓名
	s PatientObj.SexProp = PatientSex		// 性别
	s PatientObj.AgeProp = PatientBirthday	// 出生年月
	s PatientObj.Height = HeightCM			// 身高
	s PatientObj.Weight = WeighKG			// 体重
	s PatientObj.BillType= PAAdmReason		//费别 (医保,自费)	必需
	s PatientObj.BloodPress= BloodPress		//血压	必需
	s PatientObj.SpecGrps= SpecGrpsAry		//特殊人群	必需
	s PatientObj.ProfessProp= ProfessProp	//职业	必需
	s PatientObj.PatType= PatType			//就诊类型(门诊,住院,急诊)	必需
	s PatientObj.PatLoc= PatLoc				//就诊科室	必需
	s PatientObj.MainDoc= MainDoc			//主管医生	必需
	s PatientObj.Group= GROUPDESC	 		//安全组-描述(登录信息)	必需(2020/12/1)
	s PatientObj.Hospital= HOSPDESC			//医院-描述(登录信息)	必需(2020/12/1)
	s PatientObj.LgCtLoc = CTLOCDESC		//登录科室-描述(登录信息)	必需(2020/12/1)
	s PatientObj.LgUser = USERNAME			//登录用户-描述(登录信息)	必需(2020/12/1)
	s PatientObj.Profess = ""				//职称-描述(登录信息)	必需(2020/12/1)
	s PatientObj.EpisodeID = EpisodeID		//就诊ID	必需
	Q PatientObj
}

/// 获取诊断信息  
ClassMethod GetScreenDiagList(AdmId As %String)
{
	s ScreenDiagList={}
	s Diagnoses=[]
	s MRAdmRowid=$p($g(^PAADM(AdmId)),"^",61)
	i MRAdmRowid'="" {
		s i=0
		s obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
		For {
			Quit:'obj.Next()
            s Desc=obj.Data("MRDIAICDCodeDRDesc")
            s Rowid=obj.Data("ID")
            s CodeRowId=obj.Data("MRDIAICDCodeDR")
            continue:CodeRowId=""   //lgl+诊断只填描述也能过去导致
            i CodeRowId'="" {
	            s DiagObj={}
                s Code=$P(^MRC("ID",CodeRowId),"^",4)
                s Code=$tr(Code,$c(0),"")
                s DiagObj.id=Code
                s DiagObj.item=Desc
                do Diagnoses.%Push(DiagObj)
                do DiagObj.%Close()
            }
        }

    }
	s ScreenDiagList.Diagnoses=Diagnoses
	b ;ScreenMedCondList.%ToJSON()
	Q ScreenDiagList
}

/// 获取过敏信息  
ClassMethod GetScreenAllergenList(EpisodeID As %String)
{
	s ScreenAllergenList={}
	s Allergens=[]
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
		s AllergenObj={}
		;过敏源序号(同次参与审查必须唯一)
		;s ScreenAllergenObj.Index=PatientID_"||"_ChildSub
		;过敏源编码
		s AllergenObj.id=$g(AllerCode)
		;过敏源名称
		s AllergenObj.item=$g(AllerName)
		do Allergens.%Push(AllergenObj)
		do AllergenObj.%Close()
	}
	s ScreenAllergenList.Allergens=Allergens
	b ;ScreenAllergenList.%ToJSON()
	
	Q ScreenAllergenList
}

/// 获取手术信息 
ClassMethod GetOperationsList(EpisodeID As %String)
{
	s ScreenOperationsList={}
	s Operations=[]
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s OperationsInfo=""
	s opaRowid=0 
    for {
		s opaRowid=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaRowid))
		Q:opaRowid=""
		s opaStatus=$p($g(^DHCANOPArrange(opaRowid)),"^",27)
		continue:(opaStatus="D")||(opaStatus="C")
		s anaRowid=$p($g(^DHCANOPArrange(opaRowid)),"^",2)	;手术麻醉Id
		continue:anaRowid=""
		s anaopSub=0
		for {
			s anaopSub=$o(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub))
			Q:anaopSub=""
			s curOperId=$p($g(^OR(+anaRowid,"ANA",$p(anaRowid,"||",2),"OP",anaopSub)),"^",6)	;手术表id
			continue:curOperId=""
			;手术id
			s Operationid=anaRowid_"||"_anaopSub
			;手术编码
			s Operationcode=$p($g(^ORC("OPER",curOperId)),"^",14)
			;手术名称
			s Operationname=$p($g(^ORC("OPER",curOperId)),"^",2)
			
			s OperationsObj={}
			;过敏源编码
			s OperationsObj.id=$g(AllerCode)
			;过敏源名称
			s OperationsObj.item=$g(AllerName)
			do Operations.%Push(OperationsObj)
			do OperationsObj.%Close()
		}
	}
	s ScreenOperationsList.Operations=Operations
	b ;ScreenOperationsList.%ToJSON()
	
	Q ScreenOperationsList
}

/// 获取待插入的医嘱信息
ClassMethod GetScreenDrugList(EpisodeID As %String, OrderItemStr As %String, ExpStr As %String, ByRef StartSeqNo As %String = "1")
{
	s ScreenDrugList={}
	s OrderDrugs=[]
	if OrderItemStr=""{
		s ScreenDrugList.OrderDrugs=OrderDrugs
		Q ScreenDrugList
	}
	s PAADMRegConDisDR=""
	i EpisodeID'="" {
		s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
		s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
		s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	}
	s UserID=$p(ExpStr,"^",1)
	s HospitalID=$p(ExpStr,"^",3)
	s OrdersInfo=""
	k MasterSeqNo
	for ItemSeq=1:1:$l(OrderItemStr,$c(1)) {
		s OrderItemOne=$p(OrderItemStr,$c(1),ItemSeq)
		continue:OrderItemOne=""
		s ARCIMRowId=""
		s OrderType=$p(OrderItemOne,"^",2)
		if (OrderType="Verify") {
			;已审核医嘱必须传入医嘱id
			s OEORIRowid=$p(OrderItemOne,"^",1)
			continue:OEORIRowid=""
			s OrderRowid=+OEORIRowid
			s ChildSub=$p(OEORIRowid,"||",2)
			s ARCIMRowId=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",2)
			s SeqNo=ChildSub+(+StartSeqNo)
			;给药频率
			s DrugFreq="",DrugFreqFactor=1
			s FreqRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",4)
			if (FreqRowid'=""){
				s DrugFreqFactor=$p(^PHCFR(FreqRowid),"^",2)
				s DrugFreq=$p(^PHCFR(FreqRowid),"^",3)
			}
	        ;每次给药剂量
	        s Unit="",DayDose=""
			s OnceDose=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",1)
			s OrderFreqTimeDoseStr=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",59)
			i OrderFreqTimeDoseStr'=""{
				s FreqTimeDoseStr=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdDoseQty(OEORIRowid)
				for loopDose=1:1:$l(FreqTimeDoseStr,"-"){
					s onceFreqTimeDose=$p(FreqTimeDoseStr,"-",loopDose)
					s:onceFreqTimeDose>(+OnceDose) OnceDose=onceFreqTimeDose
					s DayDose=DayDose+onceFreqTimeDose
				}	
			}else{
				s DayDose=+OnceDose*DrugFreqFactor	
			}
			s DoseUOMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",3)
			if (DoseUOMRowid'="") s Unit=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
	        ;给药途径
			s DrugPreMet=""
			s InstrRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",7)
			if (InstrRowid'="") s DrugPreMet=$p($g(^PHCIN(InstrRowid)),"^",2)
			
			;疗程
			s Treatment=""
			s DurRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,2)),"^",6)
			if (DurRowid'="") s Treatment=$p($g(^PHCDU(DurRowid)),"^",3)
			;关联序号
			s LinkOrdItem=$p($g(^OEORD(OrderRowid,"I",ChildSub,11)),"^",39)
	        s LinkSeqNo=""
	        if (LinkOrdItem'=""){
				s LinkOrdItemNo=$p(LinkOrdItem,"||",2)
	            s LinOrdItemL(LinkOrdItemNo)=+$g(LinOrdItemL(LinkOrdItemNo))+1
	            s LinkSeqNo=LinkOrdItemNo_"."_$g(LinOrdItemL(LinkOrdItemNo))
	        }
			//医嘱时间
			s OrderDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",7)
			s OrderSttDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",9)
			if (OrderDate="") s OrderDate=OrderSttDate
			s:OrderDate'="" OrdDate=$zd(OrderDate,3)
			s:OrderSttDate'="" OrderSttDate=$zd(OrderDate,3)
			s IsFirstUseProp=""
			;给药速度
			s DurgSpeedProp=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",17)
	        ;给药速度单位
	        s DrugSpeedPropUnit=""
			s FlowRateUnitDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,6)),"^",8)
			if (FlowRateUnitDR'="") s DrugSpeedPropUnit=$p($g(^OEC("SFR",FlowRateUnitDR)),"^",2)
			s OrdEndDate=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",34)
	        s:OrdEndDate'="" OrdEndDate=$zd(OrdEndDate,3)
	        s OrdSeNum=$p($g(^OEORD(OrderRowid,"I",ChildSub,"DHC")),"^",75)
	        s OrdPriorityDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",8)
	        s OrdRecDeptID=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",6)
	        s OrderPackQty=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",4)
	        s OrderRealType=""
			s ItemCatDR=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
			i ItemCatDR'="" s OrderRealType=$P(^ARC("IC",ItemCatDR),"^",7)
			i OrderRealType'="R"{
				s DoseqtySum=$p($g(^OEORD(OrderRowid,"I",$p(ChildSub,"||",2),1)),"^",12)
				s:DoseqtySum'="" OrderPackQty=DoseqtySum
			}
			s OrderPackUOMRowid=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OEORIRowid)
			s OrdSkinTest=##class(PHA.COM.Order).OeoriSkinTestVal(OrderRowid,ChildSub)
			s OrdSkinTest=$case(OrdSkinTest,-2:"阳性",:"")
			s OrdToatlPrice=##Class(web.DHCDocOrderCommon).GetOEORIPrice(OEORIRowid)
		}
		elseif(OrderType="R"){
	        s SeqNo=$p(OrderItemOne,"^",20)
	        ;药品ID
			s ARCIMRowId=$p(OrderItemOne,"^",1)
			continue:ARCIMRowId=""
			;给药频率
			s DrugFreq="",DrugFreqFactor=1
			s FreqRowid=$p(OrderItemOne,"^",15)
			if (FreqRowid'=""){
				s DrugFreq=$p(^PHCFR(FreqRowid),"^",3)
				s DrugFreqFactor=$p(^PHCFR(FreqRowid),"^",2)
			}
	        ;每次给药剂量
			s OnceDose=$p(OrderItemOne,"^",12)
			s FreqTimeDoseStr=$p(OrderItemOne,"^",70)
			s DayDose=""
			if FreqTimeDoseStr'=""{
				for loopDose=1:1:$l(FreqTimeDoseStr,"!"){
					s oneFreqTimeDose=$p(FreqTimeDoseStr,"!",loopDose)
					s onceFreqTimeDose=$p(oneFreqTimeDose,"$",2)
					s:onceFreqTimeDose>(+OnceDose) OnceDose=onceFreqTimeDose
					s DayDose=DayDose+onceFreqTimeDose
				}	
			}else{
				s DayDose=+OnceDose*DrugFreqFactor	
			}
			s DoseUOMRowid=$p(OrderItemOne,"^",13)
			s Unit=""
			s:DoseUOMRowid'="" Unit=$p($g(^CT("UOM",DoseUOMRowid)),"^",2)
	        ;给药途径
			s DrugPreMet=""
			s InstrRowid=$p(OrderItemOne,"^",17)
			if (InstrRowid'="") s DrugPreMet=$p($g(^PHCIN(InstrRowid)),"^",2)
			;疗程
			s Treatment=""
			s DurRowid=$p(OrderItemOne,"^",16)
			if (DurRowid'="") s Treatment=$p($g(^PHCDU(DurRowid)),"^",3)
			;关联序号
			s LinkSeqNo=""
			s OrderMasterSeqNo=$p(OrderItemOne,"^",19)
			if (OrderMasterSeqNo'=""){
	            s MasterSeqNo(OrderMasterSeqNo)=+$g(MasterSeqNo(OrderMasterSeqNo))+1
	            s LinkSeqNo=OrderMasterSeqNo_"."_$g(MasterSeqNo(OrderMasterSeqNo))
	        }
	        ;医嘱开始时间
			s OrderSttDate=$p(OrderItemOne,"^",4)
			;医嘱时间
			s OrdDate=$p(OrderItemOne,"^",46)
			s IsFirstUseProp=""
			;给药速度
			s DurgSpeedProp=$p(OrderItemOne,"^",36)
	        ;给药速度单位
	        s DrugSpeedPropUnit=""
			s FlowRateUnitDR=$p(OrderItemOne,"^",45)
			if (FlowRateUnitDR'="") s DrugSpeedPropUnit=$p($g(^OEC("SFR",FlowRateUnitDR)),"^",2)
			s OrdEndDate=$p(OrderItemOne,"^",26)
			if (StartSeqNo<SeqNo) s StartSeqNo=SeqNo
			s OrdSeNum=$p(OrderItemOne,"^",87)
			s OrdPriorityDR=$p(OrderItemOne,"^",3)
			s OrdRecDeptID=$p(OrderItemOne,"^",8)
			s OrderPackQty=$P(OrderItemOne,"^",6)
			s DoseQtySum=$p(OrderItemOne,"^",14)
			s OrderPackUOMRowid=$p(OrderItemOne,"^",55)
			s OrdSkinTest=""
			s OrderSttDate=..%SysDate()
		}
		
		continue:ARCIMRowId=""
		s (FormProp,RecDeptCode,RecDeptName,PriorityDesc,OrderPackUOM)=""
		;药品名称
		s PhCode=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",1)
		s PhDesc=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",2)
		;剂型
		s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowId)
        s FormProp=""
        s:InciRowid'="" FormProp=##class(web.DHCSTCOMMONSRV).GetForm(InciRowid)
		s DrugType=##Class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ARCIMRowId,HospitalID)
		s DrugType=$case(DrugType,3:"ZYYP",:"XY")
		if $g(OrdPriorityDR)'=""{
			s PriorityDesc=$p($g(^OECPR(OrdPriorityDR)),"^")
		}
		if $g(OrdRecDeptID)'=""{
			s RecDeptCode=$p(^CTLOC(OrdRecDeptID),"^",1)
			s RecDeptName=$p(^CTLOC(OrdRecDeptID),"^",2)
		}
		if $g(OrderPackUOMRowid)'=""{
			s OrderPackUOM=$P($g(^CT("UOM",OrderPackUOMRowid)),"^",2)
			s OrderPackUOM=$p(OrderPackUOM,"(",1)
		}
		s PatType="", InsType="", LinkTo="", OEPrice=""
		s ExpStrin="^^"_EpisodeID_"^"_""_"^"_HospitalID
		s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowId, OrderSttDate, OrdPriorityDR, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,OrderPackUOMRowid,ExpStrin)
		s ItemPrice=$fn($P(retPrice,"^",1),"",4)
		if $g(OrdToatlPrice)=""{
			s OrdToatlPrice=ItemPrice*OrderPackQty	
		}

		s ItemOrderObj={}
		s ItemOrderObj.OrdSeNum=OrdSeNum 		//	流水号	必需 
		s ItemOrderObj.ArciMastId=ARCIMRowId 	//	医嘱项ID	必需 
		s ItemOrderObj.DrugType=DrugType 		//	西药 :XY, 中药饮片：ZYYP
		s ItemOrderObj.SeqNo=SeqNo 				//	医嘱序号	必需
		s ItemOrderObj.PhCode=PhCode			//	药品编码(医嘱项编码)
		s ItemOrderObj.PhDesc=PhDesc 			//	药品名称	必需
		s ItemOrderObj.FormProp=FormProp 		//	剂型	必需
		s ItemOrderObj.OnceDose=OnceDose 		//	单次剂量	必需
		s ItemOrderObj.Unit=Unit 				//	单次剂量单位	必需
		s ItemOrderObj.DayDose=DayDose 			//	每日剂量	必需
		s ItemOrderObj.DrugPreMet=DrugPreMet 	//	用法	必需
		s ItemOrderObj.DrugFreq=DrugFreq 		//	频次	必需
		s ItemOrderObj.Treatment=Treatment 		//	疗程	必需
		s ItemOrderObj.id=PhCode 				//	标识	必需
		s ItemOrderObj.LinkSeqNo=LinkSeqNo 		//	关联序号(1, 1.1, 1.2)	必需
		s ItemOrderObj.OrdDate=OrdDate 			//	医嘱日期	必需
		s ItemOrderObj.IsFirstUseProp=IsFirstUseProp 		//	是否首次(首次/非首次)	必需
		s ItemOrderObj.DurgSpeedProp=DurgSpeedProp 			//	给药速度	必需
		s ItemOrderObj.DrugSpeedPropUnit=DrugSpeedPropUnit 	//	给药速度单位	必需
		s ItemOrderObj.OrdEndDate=OrdEndDate 				//	医嘱停止日期	必需(2020/12/17增加)
		s ItemOrderObj.OrdStartDate=OrderSttDate		;医嘱开始日期
		s ItemOrderObj.OrderPackQty=OrderPackQty		;数量
		s ItemOrderObj.OrderPackQtyUnit=OrderPackUOM	;数量单位
		s ItemOrderObj.SkinTest=OrdSkinTest				;皮试结果
		s ItemOrderObj.OrderPriority=PriorityDesc		;医嘱优先级
		s ItemOrderObj.RecDeptCode=RecDeptCode			;接收科室代码
		s ItemOrderObj.RecDeptName=RecDeptName			;接收科室描述
		s ItemOrderObj.OrdQuaty=OrderPackQty			;数量
		s ItemOrderObj.OrdPrice=ItemPrice				;单价
		s ItemOrderObj.OrdToatlPrice=OrdToatlPrice		;总价
		do OrderDrugs.%Push(ItemOrderObj)
		do ItemOrderObj.%Close()
				
		s InsertOrder=SeqNo_"^"_PhDesc_"^"_FormProp_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq
		s InsertOrder=InsertOrder_"^"_Treatment_"^"_PhCode_"^"_LinkSeqNo_"^"_OrdDate_"^"_IsFirstUseProp
		s InsertOrder=InsertOrder_"^"_DurgSpeedProp_"^"_DrugSpeedPropUnit_"^"_OrdEndDate_"^"_ARCIMRowId
        s InsertOrder=InsertOrder_"^"_DayDose
        i OrdersInfo="" s OrdersInfo=InsertOrder
		e  s OrdersInfo=OrdersInfo_$C(1)_InsertOrder
	}
	
	s ScreenDrugList.OrderDrugs=OrderDrugs
	b ;ScreenDrugList.%ToJSON()
	
	Q ScreenDrugList
}

/// 获取已经审核的医嘱信息
/// Description:获取已审核医嘱信息
/// Input:		EpisodeID:就诊表Rowid  FindType:解析类型(R:药品,L:检验,S:检查)
/// Return:		医嘱信息
/// Others:		w ##class(web.DHCDocHLYYDHC).GetVerifiedOrderInfo("87","")
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

/// Creator:      
/// CreatDate:    2020-12-20
/// Description:  判断是否是药品医嘱
/// Input:        ARCIMRowid:医嘱项id
/// Return:       Y:是  N:不是
/// Others:		  w ##class(web.DHCDocHLYYHZYY).CheckIsDrugItem("1||1")
ClassMethod CheckIsDrugItem(ARCIMRowid As %String) As %String
{
	s DrugFlag="N"
	Q:ARCIMRowid="" DrugFlag
	s ItemCatDr=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	Q:ItemCatDr="" DrugFlag
	s OrderType=$p($g(^ARC("IC",ItemCatDr)),"^",7)
	if (OrderType="R") s DrugFlag="Y"
	Q DrugFlag
}

/// Creator:      
/// CreatDate:    2020-12-12
/// Description:  将待审核草药数据串拼接成待审核西药数据串
/// Input:        EpisodeID:就诊表RowId  CMOEOrdStr:待审核草药数据串
/// Return:       待审核西药数据串
/// Others:       w ##class(web.DHCDocHLYYHZYY).ConvertCMOEOrdToOEOrd("4415774",$p(^lj("ConvertCMOEOrdToOEOrd"),",",2))
ClassMethod ConvertCMOEOrdToOEOrd(EpisodeID As %String, CMOEOrdStr As %String) As %String
{
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
    s OrderMasterSeqNo=""
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
		s cellPosi=$p(CMItemOne,"^",8)
		s OrderCoverMainIns=$p(CMItemOne,"^",10)
		s SerialNum=$p(CMItemOne,"^",15)
		s CalPrescNo=$p(CMItemOne,"^",16)
		s CalPrescSeqNo=$p(CMItemOne,"^",17)
		s OrderSeqNo=cellPosi ;EpisodeID_"!"_PrescStartDate_"!"_PrescStartTime_"!"_ItemSeq
		s:ItemSeq=1 OrderMasterSeqNo=cellPosi ;EpisodeID_"!"_PrescStartDate_"!"_PrescStartTime
		;拼接数据
		s OEOrdOne=ARCIMRowid_"^"_OrderType_"^"_PrescPriorRowid_"^"_PrescStartDate_"^"_PrescStartTime_"^"_PackQty_"^"_UnitPrice	;1-7
		s OEOrdOne=OEOrdOne_"^"_PrescRecDepRowid_"^"_PrescAdmReason_"^"_""_"^"_PrescNotes_"^"_DoseQty_"^"_DoseUOMRowid_"^"_""	;8-14
		s OEOrdOne=OEOrdOne_"^"_PrescFreqRowid_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_""_"^"_OrderMasterSeqNo_"^"_OrderSeqNo	;15-20
		s OEOrdOne=OEOrdOne_"^"_""_"^"_PhSpecInstr_"^"_OrderCoverMainIns	;21-23
		s $p(OEOrdOne,"^",30)=PrescEmergency
		s $p(OEOrdOne,"^",46)=PrescStartDate
		s $p(OEOrdOne,"^",47)=PrescStartTime
		s $p(OEOrdOne,"^",55)=DoseUOMRowid
		s $p(OEOrdOne,"^",87)=SerialNum
		;
		if (OEOrdStr="") s OEOrdStr=OEOrdOne
		else  s OEOrdStr=OEOrdStr_$c(1)_OEOrdOne
	}
	Q OEOrdStr
}

/// Creator:      
/// CreatDate:    2021-3-30
/// Description:  审核医嘱后,调用新产品组保存接口
/// Input:        EpisodeID:就诊表RowId  OrderStr:审核返回医嘱串  ExpStr:扩展串,用户id^msgID:(唯一标识)
/// Return:       新产品组返回信息
ClassMethod SaveHLYYInfo(EpisodeID As %String, FeedBackStr As %String, ExpStr As %String = "")
{
	s UserId = $p(ExpStr,"^",1)
	s MsgId = $p(ExpStr,"^",2)
	s Date=$zd(+$h,3)
	s Time=$zt($p($h,"2"),1)
	s userType=""
	s fbret=##class(web.DHCCKBService).SaveOeordFeedBack(FeedBackStr)	
	Q fbret
	;q ##Class(web.DHCCKBService).FeedBack(MsgId, UserId, Date, Time, OrderStr, userType)
}

}
