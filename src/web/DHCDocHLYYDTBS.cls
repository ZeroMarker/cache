/// 大通合理用药BS版本后台数据的获取或保存
Class web.DHCDocHLYYDTBS Extends web.DHCDocHLYY
{

// w ##class(web.DHCandDaTongInterface).FormatDrgDesc("&><'&")

/// 格式化药学项名称?因为大通的???不允许出现"<"或者">"的字符串
/// 格式化药学项名称?因为大通的???不允许出现"<"或者">"的字符串
/// 格式化药学项名称?因为大通的???不允许出现"<"或者">"的字符串
ClassMethod FormatDrgDesc(instr As %String) As %String
{
	s mystr = instr	
	q:(mystr="") mystr
	s mystr=##class(ext.util.String).Replace(mystr,"&","&amp;")
	s mystr=##class(ext.util.String).Replace(mystr,">","&gt;")
	s mystr=##class(ext.util.String).Replace(mystr,"<","&lt;")
	s mystr=##class(ext.util.String).Replace(mystr,"'","&apos;")
	s mystr=##class(ext.util.String).Replace(mystr,$Char(34),"&quot;")
	Quit mystr
}

/// 大通要点提示
ClassMethod GetDTYDTS(ARCIMRowid As %String) As %String
{
	s Para="<medicine>"_"<his_code>"_"</his_code>"_"</his_code>"_"<his_name>"_"</his_name>"_"</medicine>"
	Quit:ARCIMRowid="" Para
	s DrgFrmRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	i DrgFrmRowid'="" {
		s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
		s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
		s DrgCode=..FormatDrgDesc(DrgCode)
		s DrgDesc=..FormatDrgDesc(DrgDesc)
		s Para="<medicine>"_"<his_code>"_DrgCode_"</his_code><his_name>"_DrgDesc_"</his_name>"_"</medicine>"
	}
 Quit Para
}

/// 大通分析程序
/// OrderStr:OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime+"!"+OEORIRowid;
/// 				医嘱项目ID			单次剂量		单次剂量单位ID			频次ID			疗程ID				用法ID				药学项目ID				组号			医嘱优先级ID		开始日期			开始时间		医嘱ID(仅保存后存在)
/// w ##class(web.DHCandDaTongInterface).GetPrescXML("2328||1!1!12!148!63!58!2328||1!1!4!04/06/2013!16:07","2250401","10118","876")
/// 大通分析程序
/// OrderStr:OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime+"!"+OEORIRowid;
/// 				医嘱项目ID			单次剂量		单次剂量单位ID			频次ID			疗程ID				用法ID				药学项目ID				组号			医嘱优先级ID		开始日期			开始时间		医嘱ID(仅保存后存在)
/// w ##class(web.DHCandDaTongInterface).GetPrescXML("540||1!10!102!1!63!58!540||1!3!3!17/07/2015!11:24","4051868","10118","876")
ClassMethod GetPrescXML(OrderStr As %String, EpisodeID As %String, DocCode As %String, UserID As %String, UploadFlag As %String) As %String
{
	;s OrderStr=%request.Get("Orders")
	;s EpisodeID=%request.Get("EpisodeID")
	;s DocCode=%request.Get("DocCode")
	;s UploadFlag=%request.Get("UploadFlag")
	;s UserID=$g(%session.Data("LOGON.USERID"))
	//s OtherPresc=%request.Get("OtherPresc")
	s ^TemTest111("GetPrescXML",1)=OrderStr_"^"_EpisodeID_"^"_DocCode_"^"_UserID
	
	if OrderStr="" Q ""
	s HospFlag=""
	s EpisodeType=$P(^PAADM(EpisodeID),"^",2)
	if EpisodeType="I" s HospFlag="ip"
	e  s HospFlag="op"
	s TreatType=""
	if EpisodeType="I" s TreatType="400"   ;普通住院
	i EpisodeType="O" s TreatType="100"    ;普通门诊
	i EpisodeType="E" s TreatType="200"    ;急诊

	s OrderRowid=##Class(web.DHCDocOrderEntry).GetPAADMOrderRowid(EpisodeID)
	
	s DHCDTPrescXML=""
	s OtherPresc=DHCDTPrescXML
	
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	;s DocID=$p(^SSU("SSUSR",UserID),"^",14)
	;s DocName=$p($g(^CTPCP(DocID,1)),"^",2)				//医生姓名
	;s DocProvID=$p(^CTPCP(DocID,1),"^",4)				//
	;s DocProvCode=$p(^CT("CPT",DocProvID),"^",1)		//医生代码
	s EpisodeLocID=$p($g(^PAADM(EpisodeID)),"^",4)		//就诊科室
	s EpisodeDate=$p($g(^PAADM(EpisodeID)),"^",6)		//就诊日期
	s EpisodeTime=$p($g(^PAADM(EpisodeID)),"^",7)		//就诊时间
	s EpisodeDate=$ZD(EpisodeDate,3)
	s EpisodeTime=$ZT(EpisodeTime,1)
	s CurentDate=$ZD(+$H,3),CurentTime=$ZT($p($h,",",2),1)
	s HisTime=CurentDate_" "_CurentTime
	s PaadmAdmNo=$p($g(^PAADM(EpisodeID)),"^",81)		//就诊号
	s BedNoID=$p($g(^PAADM(EpisodeID)),"^",73)  		//住院病人床位信息
	i BedNoID'="" s BedNo=$p($g(^PAWARD($p(BedNoID,"||",1),"BED",$p(BedNoID,"||",2))),"^",1)
	i BedNoID="" s BedNo=""
	s EpisodeLocCode=$p($g(^CTLOC(EpisodeLocID)),"^",1)
	s EpisodeLocDesc=$p($g(^CTLOC(EpisodeLocID)),"^",2)
	s PatientName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
	//病人住院号 登记号
	&SQL(Select PAPMI_No,PAPMI_Medicare into :PatientNo,:MedicareNo From SQLUser.PA_PatMas Where PAPMI_Rowid=:PatientID)
	s PatientDOB=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	s PatientBirthday=$ZD($G(PatientDOB),3)
	s PatientSexDr=$P($G(^PAPER(PatientID,"ALL")),"^",7)
	s IDCard=$P($G(^PAPER(PatientID,"PAT",3)),"^",6)
	s papmiCardNo=""
	s CardTypeDesc=""
	s CardType=""
	.s cardrowid="" f  s cardrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,cardrowid)) q:cardrowid=""  d //根据病人信息指针取卡id
	..s cardflag=$p(^DHCCARD("CF",cardrowid),"^",10) //根据卡id取卡有效标志
	..q:(cardflag'="N") //为否则离开
	..s CardTypeDr=$p(^DHCCARD("CF",cardrowid),"^",16)
	..s:CardTypeDr'="" CardTypeDesc=$p($g(^DHCCARDTYPEDef(CardTypeDr)),"^",2)
	..i CardTypeDesc["医保" s CardType=1
	..e  i CardTypeDesc["社保" s CardType=0
	..e  i (CardTypeDesc["银医")!(CardTypeDesc["绑定") s CardType=2
	..e  s CardType=9
 	..s papmiCardNo=$p(^DHCCARD("CF",cardrowid),"^",2) //卡号
	if PatientSexDr'="" s PatientSex=$P($G(^CT("SEX",PatientSexDr)),"^",2)
	else  s PatientSex=""
	s allergicCode=""
	s allergicDesc=""
	s MRDiagnosedat=""
	s MRDiagnos1="",MRDiagnos2="",MRDiagnos3=""
	s MRDiagnos1Desc="",MRDiagnos2Desc="",MRDiagnos3Desc=""
	s MRAdmRowid=$p($g(^PAADM(EpisodeID)),"^",61)
	s Diagnose=""
	;d ##class(%ResultSet).RunQuery("web.MRDiagnos","Find",2)
	i MRAdmRowid'="" {
		s i=0
		Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
		d obj.Execute(MRAdmRowid)
		For  Quit:'obj.Next()  Do
		.s ICDDesc=""
		.s ICDCode=""
		.s ICDType=0
		.s Rowid=obj.Data("ID")
		.s ICDDesc=$g(^MR(+Rowid,"DIA",$p(Rowid,"||",2),"DES",1))
		.s CodeRowid=""   ;lgl+诊断只填描述也能过去导致
		.s CodeRowid=obj.Data("MRDIAICDCodeDR")
		.if CodeRowid'="" d
		..s ICDType=2
		..s ICDCode=$P($G(^MRC("ID",CodeRowid)),"^",4)
		..s ICDDesc=$P($G(^MRC("ID",CodeRowid)),"^",2)
		.s ICDDesc=..FormatDrgDesc(ICDDesc)
	    .s Diagnose=Diagnose_"<diagnose><type>"_ICDType_"</type><name>"_ICDDesc_"</name><code>"_ICDCode_"</code></diagnose>"
		d obj.Close()
	}
	s PAARowid=0
	s allergic=""
	f  s PAARowid=$o(^PAPER(PatientID,"ALG",PAARowid)) q:PAARowid=""  d
	.s PHCDDr=$p($g(^PAPER(PatientID,"ALG",PAARowid)),"^",27)
	.s PHCDDesc=""
	.s PHCDCode=""
	.s:PHCDDr'="" PHCDDesc=$p(^PHCD(PHCDDr,1),"^",2)
	.s:PHCDDr'="" PHCDCode=$p(^PHCD(PHCDDr,1),"^",1)
	.s PAAType=4
	.s allergic=allergic_"<allergic>"_"<type>"_PAAType_"</type>"_"<name>"_PHCDDesc_"</name>"_"<code>"_PHCDCode_"</code>"_"</allergic>"
 	i allergic="" s allergic="<allergic>"_"<type>"_"</type>"_"<name>"_"</name>"_"<code>"_"</code>"_"</allergic>"
 	if Diagnose="" s Diagnose="<diagnose><type></type><name></name><code></code></diagnose>"
	s Para="<details_xml is_upload ="_$Char(34)_UploadFlag_$Char(34)_">"
	
	s Para=Para_"<his_time>"_HisTime_"</his_time>"
	s Para=Para_"<hosp_flag>"_HospFlag_"</hosp_flag>"
	s Para=Para_"<treat_type>"_TreatType_"</treat_type>"
	s Para=Para_"<treat_code>"_EpisodeID_"</treat_code>"
	s Para=Para_"<bed_no>"_BedNo_"</bed_no>"
	
	s Para=Para_"<patient>"
		s Para=Para_"<name>"_PatientName_"</name>"
		s Para=Para_"<birth>"_PatientBirthday_"</birth>"
		s Para=Para_"<sex>"_PatientSex_"</sex>"
		s Para=Para_"<weight></weight>"
		s Para=Para_"<height></height>"
		s Para=Para_"<id_card>"_IDCard_"</id_card>"
		s Para=Para_"<medical_record>"_PatientNo_"</medical_record>"
		s Para=Para_"<card_type>"_CardType_"</card_type>"
		s Para=Para_"<card_code>"_papmiCardNo_"</card_code>"
		s Para=Para_"<pregnant_unit></pregnant_unit>"
   		s Para=Para_"<pregnant></pregnant>"
    
   	 	s Para=Para_"<allergic_data>"
    		s Para=Para_allergic
		s Para=Para_"</allergic_data>"
			
		s Para=Para_"<diagnose_data>"
			s Para=Para_Diagnose
		s Para=Para_"</diagnose_data>"
	s Para=Para_"</patient>"
	s Para=Para_"<prescription_data>"
	s Para3=""
	s GroupNumber=""
	s ItmCount=$l($g(OrderStr),"^")
	
	FOR i=1:1:ItmCount {
	    s OrderStr1=$P(OrderStr,"^",i)
	    
	    Q:OrderStr1=""
	    s ItmID=$P(OrderStr1,"!",1)
	    s DoseQty=$P(OrderStr1,"!",2)
	    s DoseQtyUOM=$P(OrderStr1,"!",3)
	    //医嘱Rowid
	    s OEORIRowid=$P(OrderStr1,"!",12)
	    
	    s DoseQtyUOMDesc=$p(^CT("UOM",DoseQtyUOM),"^",2)
	     //医嘱开始日期
	    s StartDate=$P(OrderStr1,"!",10)
	    i $l(StartDate,"/")=3 s StartDate=$zdh(StartDate,4)
	    i $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	    i StartDate="" s StartDate=$zd(+$h,3)
	    e  s StartDate=$zd(StartDate,3)
	    //医嘱开始时间
	    s StartTime=$P(OrderStr1,"!",11)
	    i StartTime[":" s StartTime=$zth(StartTime,1)
	    i StartTime="" s StartTime=$zt($p($h,",",2))
	    e  s StartTime=$zt(StartTime)
	     s PrescNo=""
	    i OEORIRowid'="" {
		    //如果处方不存在则取预生成的处方号,现在仅协和有预生成的处方号
		    s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",14)
		    i PrescNo="" s PrescNo=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),"DHC")),"^",20)
	    }
	    i PrescNo="" s PrescNo=PaadmAdmNo
	    //频次
	    s Freq=$P(OrderStr1,"!",4)
	    i Freq'="" {
		    s FreqFac=$P($G(^PHCFR(Freq)),"^",2)
		    s FreqCode=$P($G(^PHCFR(Freq)),"^",1)
		}else{
		    s FreqFac=1
		    s FreqCode=""
	    }
	    
	    //疗程
	    s Durationdr=$P(OrderStr1,"!",5)
		i Durationdr'="" {
			s Duration=$p(^PHCDU(Durationdr),"^",2)
		}else{
			s Duration=1
		}
		//用法
	    s Instr=$P(OrderStr1,"!",6)
	    i Instr'="" s InstrCode=$P($G(^PHCIN(Instr)),"^",1) 
	    e  s InstrCode=""
	    
	    s DrgFormRowid=$P(OrderStr1,"!",7)
	    s GroupNumber=$P(OrderStr1,"!",8)
	    
	    //医嘱优先级
	    s PriorType="T"
	    s PriorRowId=$P(OrderStr1,"!",9)
	    i PriorRowId'="" {
		    s PriorCode=$P(^OECPR(PriorRowId),"^",1)
		    if (PriorCode="S")!(PriorCode="OMST") s PriorType="L"
	    }
	    	    
	    i DrgFormRowid'="" {
			s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
			s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
			s DrgDesc=..FormatDrgDesc(DrgDesc)
			s drgform1=+DrgFormRowid
			s drgform2=$p(DrgFormRowid,"||",2)
		 	s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",0))
		 	i leq'="" {
		 		s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
		 		s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
		 		i eqUom'=DoseQtyUOM {
		 			s DoseQty=DoseQty*eqqty
		 			s DoseQtyUOMDesc=$p(^CT("UOM",eqUom),"^",2)
		 		}
		 	}
		 	
		s ARCIMSpec=""
		s INFORemark=""
		s inciRowid=$o(^INCI(0,"ARCIM_DR",+ItmID,""))
		i inciRowid'="" d
		.s itminf=$o(^DHCITMINFO(0,"INCI",inciRowid,""))
		.i itminf'="" s ARCIMSpec=$p($g(^DHCITMINFO(itminf)),"^",27) //规格
		.;s INCICTUOMPurchDR=$p(^INCI(inciRowid,3),"^",6)
		.;s PACKINGSPEC=$p($g(^CT("UOM",INCICTUOMPurchDR)),"^",2)  //包装规格 
		.s INFORemark=$p($g(^DHCITMINFO(itminf)),"^",10)
		 	s Para2="<prescription><id>"_PrescNo_"</id>"_"<reason></reason>"_"<is_current>"_1_"</is_current>"_"<pres_type>"_PriorType_"</pres_type>"_"<pres_time>"_HisTime_"</pres_time>"
		 	
		 	s Para3=Para3_Para2
			s Para3=Para3_"<medicine_data>"
			s Para3=Para3_"<medicine>"
			s Para3=Para3_"<name>"_DrgDesc_"</name>"
			s Para3=Para3_"<his_code>"_DrgCode_"</his_code>"
			s Para3=Para3_"<insur_code>"_"</insur_code>"
			s Para3=Para3_"<approval>"_INFORemark_"</approval>"
			s Para3=Para3_"<spec>"_ARCIMSpec_"</spec>"
			s Para3=Para3_"<group>"_GroupNumber_"</group>"
			S Para3=Para3_"<reason></reason>"
			s Para3=Para3_"<dose_unit>"_DoseQtyUOMDesc_"</dose_unit>"
			s Para3=Para3_"<dose>"_DoseQty_"</dose>"
			s Para3=Para3_"<freq>"_FreqCode_"</freq>"
			s Para3=Para3_"<administer>"_InstrCode_"</administer>"
			if EpisodeType="I" {
				s begintime=StartDate_" "_StartTime
				s Para3=Para3_"<begin_time>"_begintime_"</begin_time><end_time>"_"</end_time>"
			}else{
				s Para3=Para3_"<begin_time>"_"</begin_time><end_time>"_"</end_time>"
			}
			
			if EpisodeType'="I"
			{
				s Para3=Para3_"<days>"_Duration_"</days>"
			}else {
				s Para3=Para3_"<days>"_"</days>"
			}
			s Para3=Para3_"</medicine>"
			s Para3=Para3_"</medicine_data>"
			s Para3=Para3_"</prescription>"
	    }
	}

	if EpisodeType="I" {
		//s Para3=Para3_$$GetIPTodaySavedPresc()
	}

	if (Para3=""){
	    s Para3=Para3_"<prescription><id"_"</id>"_"<reason>""</reason>"_"<is_current>"_1_"</is_current>"_"<pres_type>"_"</pres_type>"_"<pres_time>"_"</pres_time>"
	    s Para3=Para3_"<medicine_data>"
		s Para3=Para3_"<medicine>"
		s Para3=Para3_"<name>"_"</name>"
		s Para3=Para3_"<his_code>"_"</his_code>"
		s Para3=Para3_"<insur_code>"_"</insur_code>"
		s Para3=Para3_"<approval>"_"</approval>"
		s Para3=Para3_"<spec>"_"</spec>"
		s Para3=Para3_"<group>"_"</group>"
		s Para3=Para3_"<reason></reason>"
		s Para3=Para3_"<dose_unit>"_"</dose_unit>"
		s Para3=Para3_"<dose>"_"</dose>"
		s Para3=Para3_"<freq>"_"</freq>"
		s Para3=Para3_"<administer>"_"</administer>"
		s Para3=Para3_"<begin_time>"_"</begin_time><end_time>"_"</end_time>"
		s Para3=Para3_"<days>"_"</days>"
		s Para3=Para3_"</medicine>"
		s Para3=Para3_"</medicine_data>"
		s Para3=Para3_"</prescription>"
	}else{
		//s Para2="<prescription id='新开处方1' type='mz' current='1' >"
		//s Para3=Para2_Para3_"</prescription>"
		
	}
	s Para=Para_Para3_"</prescription_data></details_xml>"
	s ^TemTest111("GetPrescXML",2)=Para
	Quit Para
GetIPTodaySavedPresc()
 s Para4=""
 Set childsub=0 for {
	s childsub=$O(^OEORDi(0,"StDt",+$H,OrderRowid,childsub))
	Quit:childsub=""
	s ItmID=$P(^OEORD(OrderRowid,"I",childsub,1),"^",2)
	
	s OrderType=""
	s subCATEG=$p($g(^ARCIM(+ItmID,1,1)),"^",10)
	i subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	if OrderType'="R" continue
	
	s DoseQty=$P(OrderStr1,"!",2)
	s DoseQtyUOM=$P(OrderStr1,"!",3)
	s DoseQtyUOMDesc=$p(^CT("UOM",DoseQtyUOM),"^",2)

 i Freq'="" {
	    s FreqFac=$P($G(^PHCFR(Freq)),"^",2)
	    s FreqCode=$P($G(^PHCFR(Freq)),"^",1)
	}else{
	    s FreqFac=1
	    s FreqCode=""
 }
	
	s Durationdr=$P(OrderStr1,"!",5)
	s Duration=$p(^PHCDU(Durationdr),"^",2)
	s Instr=$P(OrderStr1,"!",6)
	i Instr'="" s InstrCode=$P($G(^PHCIN(Instr)),"^",1) 
	e  s InstrCode=""
	
	s DrgFormRowid=$P(OrderStr1,"!",7)
	s GroupNumber=$P(OrderStr1,"!",8)
	s PriorRowId=$P(OrderStr1,"!",9)
	
	s PriorType="T"
	i PriorRowId'="" {
	    s PriorCode=$P(^OECPR(PriorRowId),"^",1)
	    if (PriorCode="S")!(PriorCode="OMST") s PriorType=L
	}
	
	i DrgFormRowid'="" {
		s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
		s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
		s DrgDesc=..FormatDrgDesc(DrgDesc)
		s drgform1=+DrgFormRowid
		s drgform2=$p(DrgFormRowid,"||",2)
		s leq=$o(^PHCD(drgform1,"DF",drgform2,"EQ",0))
		i leq'="" {
			s eqrec=^PHCD(drgform1,"DF",drgform2,"EQ",leq)
			s eqUom=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2)
			i eqUom'=DoseQtyUOM {
				s DoseQty=DoseQty*eqqty
				s DoseQtyUOMDesc=$p(^CT("UOM",eqUom),"^",2)
			}
		}

	 	s Para4=Para4_"<prescription id='"_PaadmAdmNo_"' type="""_PriorType_""">"
		s Para4=Para4_"<medicine suspension='false' judge='true'>"
		s Para4=Para4_"<group_number>"_GroupNumber_"</group_number>"
		s Para4=Para4_"<general_name>"_DrgDesc_"</general_name>"
		s Para4=Para4_"<license_number>"_DrgCode_"</license_number>"
		s Para4=Para4_"<medicine_name>"_DrgDesc_"</medicine_name>"
		s Para4=Para4_"<single_dose coef='1'>"_DoseQty_"</single_dose>"
		s Para3=Para3_"<frequency>"_FreqCode_"</frequency>"
		s Para3=Para3_"<times>"_FreqFac_"</times>"
		//s Para4=Para4_"<days>"_Duration_"</days>"
		s Para4=Para4_"<unit>"_DoseQtyUOMDesc_"</unit>"
		s Para4=Para4_"<administer_drugs>"_InstrCode_"</administer_drugs>"
		s begintime=$zd(+$h,3)_" "_$zT($p($h,",",2))
		s Para3=Para3_"<begin_time>"_begintime_"</begin_time><end_time>"_begintime_"</end_time>"
		s Para3=Para3_"<prescription_time>"_begintime_"</prescription_time>"
		s Para4=Para4_"</medicine>"
		s Para4=Para4_"</prescription>"
 }
 }
 Q Para4
}

/// 大通分析保存程序
/// OEOrdItemIDs:已经保存的医嘱串
/// w ##class(web.DHCandDaTongInterface).GetSavePrescXML("2123||1^2123||2^2123||3","196308","DH777777","3879")
ClassMethod GetSavePrescXML(OEOrdItemIDs As %String, EpisodeID As %String, DocCode As %String, UserID As %String) As %String
{
	s ^tmpgry("GetSavePrescXML",1)=$g(OEOrdItemIDs)_","_EpisodeID_","_DocCode_","_UserID
	s SavePrescXML=""
	Q:OEOrdItemIDs="" SavePrescXML
	s OrderStr=""
	f i=1:1:$l(OEOrdItemIDs,"^")-1 {
		s newOrdIdDR=$p($p(OEOrdItemIDs,"^",i),"*",2)
		i newOrdIdDR="" continue
		s newOrd=+newOrdIdDR
		s newChl=$p(newOrdIdDR,"||",2)
		s OrderARCIMRowid=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",2)
		s ItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$P($g(^ARC("IC",ItemCatRowid)),"^",7)
		continue:OrderType'="R"
		s OrderDoseQty=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",1)
		s OrderDoseUOMRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",3)
		s OrderFreqRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",4)
		s OrderDurRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",6)
		s OrderInstrRowid=$p($g(^OEORD(newOrd,"I",newChl,2)),"^",7)
		s OrderDrugFormRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",12)
		i OrderDrugFormRowid=-1 s OrderDrugFormRowid=""
		s MasterSeqNo=$p($g(^OEORD(newOrd,"I",newChl,3)),"^",4)
		i MasterSeqNo["." s MasterSeqNo=$p(MasterSeqNo,".")
		s OrderPriorRowid=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",8)
		s OrderStartDate=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",9)
		s OrderStartTime=$p($g(^OEORD(newOrd,"I",newChl,1)),"^",10)
		s OEORIRowid=newOrdIdDR
		i OrderStr="" s OrderStr=OrderARCIMRowid_"!"_OrderDoseQty_"!"_OrderDoseUOMRowid_"!"_OrderFreqRowid_"!"_OrderDurRowid_"!"_OrderInstrRowid_"!"_OrderDrugFormRowid_"!"_MasterSeqNo_"!"_OrderPriorRowid_"!"_OrderStartDate_"!"_OrderStartTime_"!"_OEORIRowid
		e  s OrderStr=OrderStr_"^"_OrderARCIMRowid_"!"_OrderDoseQty_"!"_OrderDoseUOMRowid_"!"_OrderFreqRowid_"!"_OrderDurRowid_"!"_OrderInstrRowid_"!"_OrderDrugFormRowid_"!"_MasterSeqNo_"!"_OrderPriorRowid_"!"_OrderStartDate_"!"_OrderStartTime_"!"_OEORIRowid
	}
	
	s Para=..GetPrescXML(OrderStr,EpisodeID,DocCode,UserID,1)
	s ^tmpgry("GetSavePrescXML","Para")=Para
	Q Para
}

// w ##class(web.DHCandDaTongInterface).GetBaseInfo(1,2)

ClassMethod GetBaseInfo(LocId As %String, UserId As %String) As %String
{
	s HospCode="",LocDesc="",LocCode="",DocName="",DocCode="",DocType="",DocTypeCode="",CarPrvTpDR=""
	s HospCode=..GetHospitalCode(LocId)
	s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	i LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	s LocCode=$p($g(^CTLOC(LocId)),"^",1)
	s DocId=$p(^SSU("SSUSR",UserId),"^",14)
	s:DocId'="" DocCode=$p($g(^CTPCP(DocId,1)),"^",1)
	s:DocId'="" DocName=$p($g(^CTPCP(DocId,1)),"^",2)
	s:DocId'="" CarPrvTpDR=$p($g(^CTPCP(DocId,1)),"^",4)
	s:CarPrvTpDR'="" DocType=$p($g(^CT("CPT",CarPrvTpDR)),"^",2)
	s:CarPrvTpDR'="" DocTypeCode=$p($g(^CT("CPT",CarPrvTpDR)),"^",1)
	s BaseInfo="<base_xml><source>HIS</source><hosp_code>"_HospCode_"</hosp_code><dept_code>"_LocCode_"</dept_code><dept_name>"_LocDesc_"</dept_name>"
	s BaseInfo=BaseInfo_"<doct><code>"_DocCode_"</code><name>"_DocName_"</name><type>"_DocType_"</type><type_name>"_DocTypeCode_"</type_name ></doct></base_xml>"
	q BaseInfo
}

/// 得到医院代码 HospitalCode
/// w ##class(web.DHCandDaTongInterface).GetHospitalCode(30)
ClassMethod GetHospitalCode(LocDR As %String = "") As %String
{
	q:LocDR="" ""
	s DefaultHosCode=""
	s HospitalCode=""
	s DefaultHosDR=$o(^CT("HOSP",0))
	s DefaultHosCode=$p($g(^CT("HOSP",DefaultHosDR)),"^",1)
	s HospitalDR=$P($G(^CTLOC(LocDR)),"^",22)
	q:HospitalDR="" DefaultHosCode
	s HospitalCode=$p($g(^CT("HOSP",HospitalDR)),"^",1)
	q HospitalCode
}

}
