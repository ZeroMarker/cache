/// 名称: DtPortal.MD.MD40TodayOIData
/// 描述: 根据时间段获取门诊住院数据
/// 编写者:DanPJ
/// 编写日期:2020-12-04
Class DtPortal.MD.MD40TodayOIData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// MD40.01.01	根据账单日期获取门诊、住院指标数据
/// DanPJ 2020-12-04
/// 输出字段:索引、门诊人次、门诊费用、门诊次均费用、入院人次、入院费用、入院次均费用、出院人次、急诊人次、急诊费用、急诊次均费用、门诊账单费用、门诊账单人次、门诊账单次均费用、住院账单费用、住院账单人次、住院账单次均费用、急诊账单费用、急诊账单人次、急诊账单次均费用
/// output:ind,OPNum,OPFee,OPAverage,InHosNum,InHosFee,InHosAverage,DischargeNum,EPNum,EPFee,EPAverage,BilldOPatFee,BilldOPatients,BOPAverage,BilldIPatFee,BilldIPatients,BIPAverage,BilldEPatFee,BilldEPatients,BEPAverage
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD40TodayOIData","MD400101","2020-12-03","2020-12-03","")
Query MD400101(StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,OPNum,OPFee,OPAverage,InHosNum,InHosFee,InHosAverage,DischargeNum,EPNum,EPFee,EPAverage,BilldOPatFee,BilldOPatients,BOPAverage,BilldIPatFee,BilldIPatients,BIPAverage,BilldEPatFee,BilldEPatients,BEPAverage") [ SqlProc ]
{
}

ClassMethod MD400101Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "") As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	
	kill ^TEMPDHCPORMD40101($j,"PBAdmDr")
	if ((StartDate="")||(EndDate=""))  set StartDate=+$H,EndDate=+$H
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	set (OPFee,EPFee,InHosFee,InHosAverage,OPAverage,EPAverage)=0.0000	//门诊费用、急诊费用、入院账单费用、门诊账单费用
	set (OPNum,EPNum,InHosNum,DischargeNum)=0							//门诊人次、急诊人次、入院人次、出院人次
	set (BilldIPatients,BilldOPatients,BilldEPatients)=0				//住院账单人次、门诊账单人次、急诊账单人次
	set (BilldIPatFee,BilldOPatFee,BilldEPatFee)=0.0000					//住院账单费用、门诊账单费用、急诊账单费用
	set (BIPAverage,BOPAverage,BEPAverage)=0.0000						//住院账单次均费用、门诊账单次均费用、急诊账单次均费用
	
	

	//根据账单日期获取费用信息
	//^DHCPB(0,"BILLDATE",{PBD_BillDate},{DHC_PatientBill.PB_RowId},{DHC_PatBillOrder.PBO_ChildSub},{PBD_ChildSub})
	for PBDBillDate=StartDate:1:EndDate {
		set PBRowId=""
		for {
			set PBRowId=$o(^DHCPB(0,"BILLDATE",PBDBillDate,PBRowId))	
			quit:PBRowId=""												//DHC_PatientBill账单主表的Id
			
			set PBAdmDr=$P($G(^DHCPB(PBRowId)),"^",1)					//PA_Adm表中的RowId，就诊号
			continue:PBAdmDr=""
				
			set PAADMType=$P($G(^PAADM(PBAdmDr)),"^",2)					//就诊类型
			continue:PAADMType=""
			set PAADMDepCodeDR=$P($G(^PAADM(+PBAdmDr)),"^",4)					//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
		
			set ^TEMPDHCPORMD40101($j,"PBAdmDr",PBAdmDr)=1					//保存就诊号,去掉重复的就诊号
			
			set PBOChildSub=""
			for {
				set PBOChildSub=$o(^DHCPB(0,"BILLDATE",PBDBillDate,PBRowId,PBOChildSub))
				quit:PBOChildSub=""										//DHC_PatBillOrder病人医嘱费用明细表
				
				set PBDChildSub=""
				for {
					set PBDChildSub=$o(^DHCPB(0,"BILLDATE",PBDBillDate,PBRowId,PBOChildSub,PBDChildSub))
					quit:PBDChildSub=""									//DHC_PatBillDetails账单收费项目明细表
					
					//^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub})
					set PBDTotalAmount=$P($G(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub)),"^",7)	//发生费用总数
					
					//保存门诊、急诊、住院患者发生费用总数
					set:PAADMType="I" BilldIPatFee=BilldIPatFee+$G(PBDTotalAmount)			//住院账单发生费用总数
					set:PAADMType="O" BilldOPatFee=BilldOPatFee+$G(PBDTotalAmount)			//门诊账单发生费用总数
					set:PAADMType="E" BilldEPatFee=BilldEPatFee+$G(PBDTotalAmount)			//急诊账单发生费用总数
				}	
			}
		}	
	}
	
	//获取各就诊类型的账单患者人数
	set PBAdmId=""
	for {
		set PBAdmId=$o(^TEMPDHCPORMD40101($j,"PBAdmDr",PBAdmId))
		quit:PBAdmId=""
		
		set AdmType=$P($G(^PAADM(PBAdmId)),"^",2)									//就诊类型
		continue:AdmType=""	
		set PAADMDepCodeDR=$P($G(^PAADM(+PBAdmId)),"^",4)					//获取就诊科室
		continue:PAADMDepCodeDR=""
		set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
		continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
		set:AdmType="I" BilldIPatients=BilldIPatients+1								//住院账单人次
		set:AdmType="O" BilldOPatients=BilldOPatients+1								//门诊账单人次
		set:AdmType="E" BilldEPatients=BilldEPatients+1								//急诊账单人次
	}
	
	if BilldOPatients'=0 set BOPAverage=$fn(BilldOPatFee/BilldOPatients,"",2)		//门诊账单发生的次均费用
	else  set BOPAverage=$fn(0,"",2)
	
	if BilldIPatients'=0 set BIPAverage=$fn(BilldIPatFee/BilldIPatients,"",2)		//住院账单发生的次均费用
	else  set BIPAverage=$fn(0,"",2)
	
	if BilldEPatients'=0 set BEPAverage=$fn(BilldEPatFee/BilldEPatients,"",2)		//急诊账单发生的次均费用
	else  set BEPAverage=$fn(0,"",2)
	//是否包含不在床的患者  1-包含   其他-不包含
	s IfContainWaitPat=##Class(DtPortal.Common.PublicService).getValueByCode("IFCONTAINWAITPAT")
	//门诊人次、入院患者
	for AdmDate=StartDate:1:EndDate {
		set AdmRowId=""
		for {
			set AdmRowId=$O(^PAADMi("PAADM_AdmDate",AdmDate,AdmRowId))
			quit:AdmRowId=""
			
			set PAADMDepCodeDR=$P($G(^PAADM(+AdmRowId)),"^",4)					//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
			
			set PAADMType=$P($G(^PAADM(+AdmRowId)),"^",2)						//就诊类型	
			
			if ((PAADMType="I")&&(IfContainWaitPat'="1")){ //非1只取在床的患者
				s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(AdmRowId)
				continue:patInBed'=1   //过滤不在床位
			}
			
			set:PAADMType="I" InHosNum=InHosNum+1								//入院人数
			set:PAADMType="O" OPNum=OPNum+1										//门诊人数
			set:PAADMType="E" EPNum=EPNum+1										//急诊人数
			
			
			
			//^DHCPB(0,"ADM",{PB_Adm_Dr},{PB_RowId})
			set PBRowId=""
			for {
				set PBRowId=$o(^DHCPB(0,"ADM",AdmRowId,PBRowId))
				quit:PBRowId=""	
				
				//^DHCPB({DHC_PatientBill.PB_RowId},"O",{PBO_ChildSub})
				set PBOChildSub=""
				for {
					set PBOChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub))	
					quit:PBOChildSub=""
					
					//^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub})
					set PBDChildSub=""
					for {
						set PBDChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))	
						quit:PBDChildSub=""
						
						continue:$G(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub))=""							//过滤数据为空
					
						//^DHCPB({DHC_PatientBill.PB_RowId},"O",{DHC_PatBillOrder.PBO_ChildSub},"D",{PBD_ChildSub})	
						set PBDTotalAmount=$P($G(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub)),"^",7)		//获取账单费用
						
						set:PAADMType="I" InHosFee=InHosFee+$G(PBDTotalAmount)									//入院账单费用
						set:PAADMType="O" OPFee=OPFee+$G(PBDTotalAmount)										//门诊账单费用
						set:PAADMType="E" EPFee=EPFee+$G(PBDTotalAmount)										//急诊账单费用
					}
				}
			}
		}
	}
		
	//出院患者数量
	//^PAADMi("DisDateT",{PAADM_Type},{PAADM_DischgDate},{PAADM_RowID})
	for AdmDisDate=StartDate:1:EndDate {
		set DisAdmRowId=""
		for {
			set DisAdmRowId=$o(^PAADMi("DisDateT","I",AdmDisDate,DisAdmRowId))
			quit:DisAdmRowId=""
			set PAADMDepCodeDR=$P($G(^PAADM(+DisAdmRowId)),"^",4)					//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
			set DischargeNum=DischargeNum+1											//出院人数
		}	
	}
	
	if OPNum'=0 set OPAverage=$fn(OPFee/OPNum,"",2)									//门诊次均费用
	else  set OPAverage=$fn(0,"",2)
	
	if InHosNum'=0 set InHosAverage=$fn(InHosFee/InHosNum,"",2)						//入院次均费用
	else  set IPAverage=$fn(0,"",2)
	
	if EPNum'=0 set EPAverage=$fn(EPFee/EPNum,"",2)									//急诊次均费用
	else  set EPAverage=$fn(0,"",2)
	
	s BilldIPatFee=$fn(+BilldIPatFee/10000,"",2)
	s BilldOPatFee=$fn(+BilldOPatFee/10000,"",2)
	s BilldEPatFee=$fn(+BilldEPatFee/10000,"",2)
	s InHosFee=$fn(+InHosFee/10000,"",2)
	s OPFee=$fn(+OPFee/10000,"",2)
	s EPFee=$fn(+EPFee/10000,"",2)
	
	set ^||CacheTemp(repid,ind)=$lb(ind,OPNum,OPFee,OPAverage,InHosNum,InHosFee,InHosAverage,DischargeNum,EPNum,EPFee,EPAverage,BilldOPatFee,BilldOPatients,BOPAverage,BilldIPatFee,BilldIPatients,BIPAverage,BilldEPatFee,BilldEPatients,BEPAverage)
	set ind=ind+1
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

/// MD40.01.02	出院患者信息
/// DanPJ 2020-12-04 
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD40TodayOIData","MD400102","2020-12-03","2020-12-03","")
Query MD400102(StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,Name,Sex,Age,MedicareNo,RegNo,PatientID,LocDesc,WardDesc,DocDesc,NurseDesc,DiagnoseDesc,InDay,DischgDate") [ SqlProc ]
{
}

ClassMethod MD400102Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HospitalId As %String = "") As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
		
	if ((StartDate="")||(EndDate=""))  set StartDate=+$H,EndDate=+$H
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	//出院患者数量
	//^PAADMi("DisDateT",{PAADM_Type},{PAADM_DischgDate},{PAADM_RowID})
	for AdmDisDate=StartDate:1:EndDate {
		set DisAdmRowId=""
		for {
			set DisAdmRowId=$o(^PAADMi("DisDateT","I",AdmDisDate,DisAdmRowId))
			quit:DisAdmRowId=""
			
			set PAADMDepCodeDR=$P($G(^PAADM(+DisAdmRowId)),"^",4)		//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
			
			set PatInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(+DisAdmRowId)
			set Name=$p(PatInfoStr,"^",2)								//姓名
			set Sex=$p(PatInfoStr,"^",3)								//性别
			set Age=$p(PatInfoStr,"^",4)								//年龄
			set MedicareNo=$p(PatInfoStr,"^",5) 						//病案号
			set AdmReason=$p(PatInfoStr,"^",6)							//费用类别
			set RegNo=$p(PatInfoStr,"^",7)								//登记号
			set PatientID=$p(PatInfoStr,"^",8)							//病人ID
			set LocDesc=$p(PatInfoStr,"^",9)							//病人科室
			set WardDesc=$p(PatInfoStr,"^",10)							//病人病区
			set DocDesc=$p(PatInfoStr,"^",11)							//主管医生
			set NurseDesc=$p(PatInfoStr,"^",12)						//主管护士
			
			set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(+DisAdmRowId)				//诊断
			set InDay=##class(DtPortal.Common.PaadmService).getInDayByOutPat(+DisAdmRowId)						//住院天数
			set DischgDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(+DisAdmRowId)		//出院时间
			set DischgDate=$zd($p(DischgDateTimeStr,"^",1),3)
			set DischgTime=$zt($p(DischgDateTimeStr,"^",2),2)
			set DischgDate=DischgDate_"&nbsp;"_DischgTime
		
			Set ^||CacheTemp(repid,ind)=$lb(ind,Name,Sex,Age,MedicareNo,RegNo,PatientID,LocDesc,WardDesc,DocDesc,NurseDesc,DiagnoseDesc,InDay,DischgDate)
			Set ind=ind+1
		}
	}
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

/// MD40.01.03	入院、门诊、急诊患者信息
/// DanPJ 2020-12-04 Type:I--住院,O--门诊,E--急诊
/// d ##class(%ResultSet).RunQuery("DtPortal.MD.MD40TodayOIData","MD400103","2020-12-03","2020-12-03","I","")
Query MD400103(StartDate As %String = "", EndDate As %String = "", Type As %String, HospitalId As %String = "") As DtPortal.Query(ROWSPEC = "ind,BedNum,Name,Sex,Age,MedicareNo,AdmReason,RegNo,PatientID,UserID,AdmDocDesc,NurseDesc,InDay,AdmDateTime,CareLevel,VitalSignStr,EMRDocID,EMRInstanceID,LocID") [ SqlProc ]
{
}

ClassMethod MD400103Execute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Type As %String, HospitalId As %String = "") As %Status
{
	set repid=$I(^||CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	set startTime=$P($H,",",2)
	
	quit:Type="" $$$OK
		
	if ((StartDate="")||(EndDate=""))  set StartDate=+$H,EndDate=+$H
	else  set StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
	
	//根据配置医嘱code取医嘱ID,全部护理
	set ArcIDsNur=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)
	//是否包含不在床的患者  1-包含   其他-不包含
	s IfContainWaitPat=##Class(DtPortal.Common.PublicService).getValueByCode("IFCONTAINWAITPAT")
	//患者信息
	//^PAADMi("NNType",{PAADM_Type},{PAADM_AdmDate},{PAADM_RowID})
	for AdmDate=StartDate:1:EndDate {
		set AdmRowId=""
		for {
			set AdmRowId=$o(^PAADMi("NNType",Type,AdmDate,AdmRowId))
			quit:AdmRowId=""
			
			if ((Type="I")&&(IfContainWaitPat'="1")){ //非1只取在床的患者
				s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(AdmRowId)
				continue:patInBed'=1   //过滤不在床位
			}
			
			set PAADMDepCodeDR=$P($G(^PAADM(+AdmRowId)),"^",4)					//获取就诊科室
			continue:PAADMDepCodeDR=""
			set CTLOCHospitalDR=$P($G(^CTLOC(PAADMDepCodeDR)),"^",22)			//科室所属院区
			continue:((HospitalId'="")&&(HospitalId'=CTLOCHospitalDR))			//过滤院区
			
			set PatInfo=##class(DtPortal.Common.PaadmService).GetPatInfo(+AdmRowId)
			set Name=$p(PatInfo,"^",2)											//姓名
			set Sex=$p(PatInfo,"^",3)											//性别
			set Age=$p(PatInfo,"^",4)											//年龄
			set MedicareNo=$p(PatInfo,"^",5)									//病案号
			set AdmReason=$p(PatInfo,"^",6)										//费用类别
			set BedNum=$p(PatInfo,"^",1)										//床号
			set RegNo=$p(PatInfo,"^",7)    										//登记号
 			set AdmDocDesc=$p(PatInfo,"^",11)									//主管医生
			set NurseDesc=$p(PatInfo,"^",12)									//主管护士
			set DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(+AdmRowId)			//住院诊断
			set InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(+AdmRowId)					//住院天数
			
			if (Type'="I"){
				set AdmDateTimeStr=$P($g(^PAADM(AdmRowId)),"^",6)_"^"_$P($g(^PAADM(AdmRowId)),"^",7)		//入院时间
			}else{
				set AdmDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(+AdmRowId)		//入院时间
			}
			set AdmDateTime=$zd($P(AdmDateTimeStr,"^",1),3)_"&nbsp;"_$zt($P(AdmDateTimeStr,"^",2),2)
			//护理级别
			set CareLevel=##class(DtPortal.Common.PaadmService).IsHaveArc(+AdmRowId,ArcIDsNur)
			
			//生命体征
			set VitalSign=""
			Set VitalSignStr=##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(+AdmRowId)
			if VitalSignStr="^^^^^" set VitalSignStr=""
			if VitalSignStr'="" s VitalSignStr="T:"_$p(VitalSignStr,"^",1)_"℃ ,"_"P:"_$p(VitalSignStr,"^",2)_"次/分 ,"_"R:"_$p(VitalSignStr,"^",3)_"次/分 ,"_"BP:"_$p(VitalSignStr,"^",4)_"/"_$p(VitalSignStr,"^",5)	
			
			//获取打开电子病历所需要的参数
			set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(+AdmRowId)
			set EMRDocID=$p(EMRinfo,"^",1)
			set EMRInstanceID=$p(EMRinfo,"^",2)
			set LocID=$p(EMRinfo,"^",3)
			set PatientID=$p(EMRinfo,"^",4)
			set EMREpisodeID=$p(EMRinfo,"^",5)	
			set CPDocID=$p($g(^PAADM(+AdmRowId)),"^",9)     //主管医生
			set:CPDocID'="" UserID=$O(^SSU("SSUSR",0,"CTPCP",CPDocID,""),-1)
			set ^||CacheTemp(repid,ind)=$lb(ind,BedNum,Name,Sex,Age,MedicareNo,AdmReason,RegNo,PatientID,UserID,AdmDocDesc,NurseDesc,InDay,AdmDateTime,CareLevel,VitalSignStr,EMRDocID,EMRInstanceID,LocID)
			set ind=ind+1					
		}
	}
	
	w "Time="_($P($H,",",2)-startTime),!	
	Quit $$$OK
}

}
