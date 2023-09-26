Import SQLUser

Class web.DHCCKBMedicationOrder Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Description: 获取病人基本信息
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// Input:  	 病人ID(登记号)
/// Return:  	 病人信息，以字符"^"分割,格式为:病人ID(登记号)^姓名^性别ID^性别^年龄^病案号^出生日期^身份证号  
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).GetPatInfoJson("","3")
ClassMethod GetPatInfoJson(PatNo, EpisodeID) As %String
{
	N (PatNo,EpisodeID)
	S PapRowid="",PatName="",SexId="",PatSex="",PatAge="",MedicalNo="",Birthday="",IDCard="",Nationdr="",Countrydr="",PatTelH="",Address="",Weight="" ,Height="", Mradm=""
	S PatDiag="",AdmDate="",AdmTime="",CurWardDesc="",CurWard="",AdmLoc="",AdmCurrRoom="",AdmDoctor="",AdmType="",NurLevel="",AdminDate="",AdminTime="",CurBed="",CurBedcode="",DischgDate="",DischgTime=""	
	S InTimes="",Nation=""
	I EpisodeID'="" D
	.S PapRowid=$p(^PAADM(EpisodeID),"^",1)
	.S AdmDate=$p(^PAADM(EpisodeID),"^",6) 
	.I +AdmDate>0 S AdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdmDate) 
	.S AdmTime=$p(^PAADM(EpisodeID),"^",7) 
	.I +AdmTime>0 S AdmTime=$zt(AdmTime)
	.S PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",","GC") //中医诊断
	.S:PatDiag'="" PatDiag=$p(PatDiag,",",1)
	.S CurWardDesc=""
	.S CurWard=$p(^PAADM(EpisodeID),"^",70)
	.I CurWard'="" S CurWardDesc=$p(^PAWARD(+CurWard),"^",2)
	.S AdmLocId=$p(^PAADM(EpisodeID),"^",4) //科室
	.S:AdmLocId'="" AdmLoc=$p(^CTLOC(AdmLocId),"^",2)
	.S:(AdmLoc'="")&(AdmLoc["-") AdmLoc=$p(AdmLoc,"-",2)	
	.S AdmCurrRoom=$p(^PAADM(EpisodeID),"^",69) //房间号
	.S:AdmCurrRoom'="" AdmCurrRoom=$p(^PAROOM(AdmCurrRoom),"^",2)
	.S AdmDoctor=""
	.S AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9) //医生
	.S:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)	
	.S AdmType=""
	.S AdmTypedr=$p(^PAADM(EpisodeID),"^",2) //就诊形式
	.S AdmType=$S(AdmTypedr="I":"住院",AdmTypedr="O":"门诊",AdmTypedr="E":"急诊",1:"")
	.S NurLevel=""
	.S NurLeveldr=##class(Nur.CommonInterface.Patient).getCareLevel(EpisodeID)
	.S:NurLeveldr'="" NurLevel=$S(NurLeveldr="特级":"特级",NurLeveldr="一级":"一级",NurLeveldr="二级":"二级",NurLeveldr="三级":"三级",1:"")
	.S AdminDate="",AdminTime=""
	.S AdminDateList=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID) ;入院日期
	.S:AdminDateList["^" AdminDate=$p(AdminDateList,"^",1)
	.S:AdminDate'="" AdminDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdminDate) 
	.S:AdminDateList["^" AdminTime=$p(AdminDateList,"^",2)
	.S:AdminTime'="" AdminTime=$zt(AdminTime,1)
	.S CurBedcode=""
	.S CurBed=$p(^PAADM(EpisodeID),"^",73) 
	.I CurBed'="" D  
	..S w=+CurBed,b=$p(CurBed,"||",2) Q:(w="")!(b="")
	..S CurBedcode=$p(^PAWARD(w,"BED",b),"^",1) //床位号
	.S DischgDate="",DischgTime=""
	.S DischgDateList=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID) ;出院日期
	.S:DischgDateList["^" DischgDate=$p(DischgDateList,"^",1) //病人出院日期
	.S:DischgDate'="" DischgDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(DischgDate) 
	.S:DischgDateList["^" DischgTime=$p(DischgDateList,"^",2) //病人出院时间
	.S:DischgTime'="" DischgTime=$zt(DischgTime,1)
	.S InTimes=##class(EMRservice.DAL.GetPaAdmDetail).InTimes(EpisodeID,2) //住院次数
	.S Weight="" ,Height="", Mradm=""
	.S Mradm=$P(^PAADM(EpisodeID),"^",61)
	.I (Mradm'="")&($D(^MR(Mradm,"PRO",1))) D
	..S Weight=$P(^MR(Mradm,"PRO",1),"^",27) 
	..S:+Weight'=0 Weight=Weight_"KG"
	..S Height=$P(^MR(Mradm,"PRO",1),"^",20)
	..S:+Height'=0 Height=Height_"CM"
	..
	E  I PatNo'=""  D
	.S PapRowid=$o(^PAPERi("PAPMI_PatNo",(PatNo),""))
	I PapRowid'=""  D
	.S PatNo=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	.S PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	.S SexId=$p(^PAPER(PapRowid,"ALL"),"^",7) //性别
	.S PatSex=$p(^CT("SEX",SexId),"^",2)
	.;S patAge=+##class(web.DHCSTKUTIL).GetAge(PapRowid)  //年龄
	.S PatAge=##Class(web.DHCSTKUTIL).GetAge(PapRowid)  //年龄    
	.S MedicalNo=$p(^PAPER(PapRowid,"PAT",1),"^",22) //病案号
	.S Birthday=$p(^PAPER(PapRowid,"ALL"),"^",6) //出生日期
	.S:Birthday'="" Birthday=##class(web.DHCADVCOMMON).DateLogicalToHtml(Birthday)
	.S IDCard=$p(^PAPER(PapRowid,"ALL"),"^",9) //身份证号
	.S Nationdr=$p($g(^PAPER(PapRowid,"PER",2)),"^",1)  /// 民族
	.S:Nationdr'="" Nation=$p($g(^CT("NAT",Nationdr)),"^",2)  /// 民族
	.S Countrydr=$p(^PAPER(PapRowid,"PER",1),"^",8) 	 /// 国家
	.S PatTelH=$p(^PAPER(PapRowid,"PER",1),"^",11) 	 /// 电话 
	.S Address=$g(^PAPER(PapRowid,"PER","ADD",1)) 	     /// 家庭住址
	.S PatBill="" /// 费别指针(医疗类别)
	.;S BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)
	.S BillTypeID=$P(^PAPER(PapRowid,"PER",1),"^",10)          
	.S:BillTypeID'="" PatBill=$p($g(^PAC("ADMREA",+BillTypeID)),"^",2)
	.S PatOccupation="",OccupationID=""  ///病人职业
	.S:$d(^PAPER(PapRowid,"PER",2)) OccupationID=$P(^PAPER(PapRowid,"PER",2),"^",6)           
	.S:OccupationID'="" PatOccupation=$p($g(^CT("OCC",OccupationID)),"^",2)

	S tmpObj={}
	S tmpObj.PatNo=PatNo
	S tmpObj.PatName=PatName
	S tmpObj.SexId=SexId
	S tmpObj.PatSex=PatSex
	S tmpObj.PatAge=PatAge
	S tmpObj.MedicalNo=MedicalNo
	S tmpObj.Birthday=Birthday
	S tmpObj.IDCard=IDCard
	S tmpObj.Nationdr=Nationdr
	S tmpObj.Countrydr=Countrydr
	S tmpObj.PatTelH=PatTelH
	S tmpObj.Address=Address
	S tmpObj.Weight=Weight
	S tmpObj.Height=Height
	S tmpObj.PatDiag=PatDiag
	S tmpObj.AdmDate=AdmDate
	S tmpObj.AdmTime=AdmTime
	S tmpObj.CurWardDesc=CurWardDesc
	S tmpObj.CurWard=CurWard
	S tmpObj.AdmLoc=AdmLoc
	S tmpObj.AdmCurrRoom=AdmCurrRoom
	S tmpObj.AdmDoctor=AdmDoctor
	S tmpObj.AdmType=AdmType
	S tmpObj.NurLevel=NurLevel
	S tmpObj.AdminDate=AdminDate
	S tmpObj.AdminTime=AdminTime
	S tmpObj.CurBed=CurBed
	S tmpObj.CurBedcode=CurBedcode
	S tmpObj.DischgDate=DischgDate
	S tmpObj.DischgTime=DischgTime
	S tmpObj.PatBill=PatBill
	S tmpObj.PatOccupation=PatOccupation
	S tmpObj.Nation=Nation
	S tmpObj.InTimes=InTimes
	W tmpObj.%ToJSON()
	Q ""
}

/// Description: 药嘱单界面下拉框
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// w ##class(web.DHCCKBMedicationOrder).jsonMedical(10,1,"MedOrdCookTemper")
ClassMethod jsonMedical(rows, page, desc, model = "")
{
	n (rows, page,desc,model)
	s end = page*rows
	s start=(page-1)*rows+1

	s parId=##class(web.DHCCKBCommon).GetDicIdByCode(desc)

	s firstChild = ""
	s count=0
	k MedicalArr
	f  s firstChild=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parId,firstChild)) q:firstChild=""  d
	.s firstDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(firstChild)),3)
	.i model="EN" s firstDesc=..GetEnTranslation(firstChild)	// 英文模式显示英文翻译名 2021/9/28 qnp
	.s secondChild = ""
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",firstChild)) d
	..f  s secondChild=$o(^CT.CKB.PDSS.CommonDictionI("Parref",firstChild,secondChild)) q:secondChild=""  d
	...s secondDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(secondChild)),3)
	...i model = "EN" s secondDesc=..GetEnTranslation(secondChild)
	...s count=count+1
	...s MedicalArr(count)=firstDesc_"^"_secondDesc
	.e  d
	..s count=count+1
	..s MedicalArr(count)=firstDesc_"^"_firstDesc

	q:count=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	
	s listTitle="value^text"	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() // 输出json前缀串
	s index = ""
	f  s index = $o(MedicalArr(index)) q:index=""  d
	.s listData = MedicalArr(index)
	...q:(index<start)||(index>end)
	.i index=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)

	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) 	// 输出json结尾符	

	q ""
}

/// Description: 药嘱单保存
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).saveOrUpdateMedOrder("","3^111^备注^宜选用砂锅、陶瓷、不锈钢等材料制作的器皿，禁用铁锅、铜锅等金属制器具^一煎^一般方剂^一般需煎煮2次或3次^一般方剂^一般方剂^先煎^undefined^第  二 煎^冷服^饭后服^一日两次^小于1岁的新生儿^脾胃虚寒或胃寒疼痛等患者，服药时不宜吃生冷助寒类食物；^药后啜粥法(服药后喝喝粥，以助药力发散)^用药告知^干燥")
ClassMethod saveOrUpdateMedOrder(ID, DataList)
{
	n (ID,DataList)

	i ID="" D
	.s ID=..InsMedOrderMast(DataList)
	E  D
	.s ID=..UpdMedOrder(ID, DataList)
	Q ID
}

/// Description: 药嘱单保存 新增
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).InsMedOrderMast("","3^111^备注^宜选用砂锅、陶瓷、不锈钢等材料制作的器皿，禁用铁锅、铜锅等金属制器具^一煎^一般方剂^一般需煎煮2次或3次^一般方剂^一般方剂^先煎^undefined^第  二 煎^冷服^饭后服^一日两次^小于1岁的新生儿^脾胃虚寒或胃寒疼痛等患者，服药时不宜吃生冷助寒类食物；^药后啜粥法(服药后喝喝粥，以助药力发散)^用药告知^干燥")
ClassMethod InsMedOrderMast(DataList)
{
	n (DataList)
	s ID = ..InsMedOrder(DataList)
	i ID>0 d ..updateSysNo(ID)
	q ID
}

/// Description: 药嘱单保存 新增
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).InsMedOrderMast("","3^111^备注^宜选用砂锅、陶瓷、不锈钢等材料制作的器皿，禁用铁锅、铜锅等金属制器具^一煎^一般方剂^一般需煎煮2次或3次^一般方剂^一般方剂^先煎^undefined^第  二 煎^冷服^饭后服^一日两次^小于1岁的新生儿^脾胃虚寒或胃寒疼痛等患者，服药时不宜吃生冷助寒类食物；^药后啜粥法(服药后喝喝粥，以助药力发散)^用药告知^干燥")
ClassMethod InsMedOrder(DataList)
{
	n (DataList)
	
	s MOAdmDr=$p(DataList,"^",1)
	s MOSysNo="" 
	s MODate=+$h 
	s MOPrescripNo=$p(DataList,"^",2)
	s MORemarks=$p(DataList,"^",3) 
	s MODecVessel=$p(DataList,"^",4)
	s MOSoakWater=$p(DataList,"^",5)
	s MOSoakTime=$p(DataList,"^",6)
	s MODecTimes=$p(DataList,"^",7)
	s MODecTime=$p(DataList,"^",8)
	s MODecTemp=$p(DataList,"^",9)
	s MODecMethod=$p(DataList,"^",10)
	s MODecFirFried=$p(DataList,"^",11)
	s MODecSecFried=$p(DataList,"^",12)
	s MOMedTemp=$p(DataList,"^",13)
	s MOMedTime=$p(DataList,"^",14)
	s MOMedTimes=$p(DataList,"^",15)
	s MODosage=$p(DataList,"^",16)
	s MOFoodTaboo=$p(DataList,"^",17)
	s MOPostDrugCare=$p(DataList,"^",18)
	s MOMedNotify=$p(DataList,"^",19)
	s MOStorageMethod=$p(DataList,"^",20)
	s SpecialObey=$p(DataList,"^",21)
	s PrescType=$p(DataList,"^",22)
	s MOSoakWater2=$p(DataList,"^",23)
	s MODecTime2=$p(DataList,"^",24)
	
	s MOMattersAttention=$p(DataList,"^",25)
	s MOSyndromeContion=$p(DataList,"^",26)
	s MODietaryTaboos=$p(DataList,"^",27)
	s MOPregMedication=$p(DataList,"^",28)
	s MOChildMedication=$p(DataList,"^",29)
	s MOGeriatricMedication=$p(DataList,"^",30)
	s MODrugInteraction=$p(DataList,"^",31)
	s MOStorMethod=$p(DataList,"^",32)
	s MOToxicityTips=$p(DataList,"^",33)
	s MOHealthTips=$p(DataList,"^",34)
	s MOPrescCompotion=$p(DataList,"^",35)
	s MOPrescSpec=$p(DataList,"^",36)
	s MOPrescNum=$p(DataList,"^",37)
	TSTART
	&SQL(Insert Into CKB_PDSS.MedicationOrder (MO_Adm_Dr,MO_SysNo,MO_Date,MO_PrescripNo,
		MO_Remarks,MO_DecVessel,MO_SoakWater,MO_SoakTime,MO_DecTimes,MO_DecTime,MO_DecTemp,MO_DecMethod,MO_DecFirFried
		,MO_DecSecFried,MO_MedTemp,MO_MedTime,MO_MedTimes,MO_Dosage,MO_FoodTaboo,MO_PostDrugCare,MO_MedNotify,MO_StorageMethod,MO_SpecialObey,
		MO_PrescType,MO_SoakWater2,MODecTime2,
		MO_MattersAttention,MO_SyndromeContion,MO_DietaryTaboos,MO_PregMedication,
		MO_ChildMedication,MO_GeriatricMedication,MO_DrugInteraction,MO_StorMethod,
		MO_ToxicityTips,MO_HealthTips,MO_PrescCompotion,MO_PrescSpec,MO_PrescNum

	) values(:MOAdmDr,:MOSysNo,:MODate,:MOPrescripNo,:MORemarks,:MODecVessel,:MOSoakWater,
		:MOSoakTime,:MODecTimes,:MODecTime,:MODecTemp,:MODecMethod,:MODecFirFried,
		:MODecSecFried,:MOMedTemp,:MOMedTime,:MOMedTimes,:MODosage,:MOFoodTaboo,:MOPostDrugCare,:MOMedNotify,
		:MOStorageMethod,:SpecialObey,:PrescType,:MOSoakWater2,:MODecTime2,
		:MOMattersAttention,:MOSyndromeContion,:MODietaryTaboos,:MOPregMedication,
		:MOChildMedication,:MOGeriatricMedication,:MODrugInteraction,:MOStorMethod,
		:MOToxicityTips,:MOHealthTips,:MOPrescCompotion,:MOPrescSpec,:MOPrescNum
	))
	i SQLCODE=0 D
	.TCOMMIT
	.s result=+%ROWID 
	E  D
	.TROLLBACK
	.s result=SQLCODE
	Q result
}

/// Description: 药嘱单保存 修改
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).InsMedOrderMast("","3^111^备注^宜选用砂锅、陶瓷、不锈钢等材料制作的器皿，禁用铁锅、铜锅等金属制器具^一煎^一般方剂^一般需煎煮2次或3次^一般方剂^一般方剂^先煎^undefined^第  二 煎^冷服^饭后服^一日两次^小于1岁的新生儿^脾胃虚寒或胃寒疼痛等患者，服药时不宜吃生冷助寒类食物；^药后啜粥法(服药后喝喝粥，以助药力发散)^用药告知^干燥")
ClassMethod UpdMedOrder(ID, DataList)
{
	n (ID, DataList)

	s result=""
	s MOAdmDr=$p(DataList,"^",1)
	s MOSysNo=""
	s MOPrescripNo=$p(DataList,"^",2)
	s MORemarks=$p(DataList,"^",3) 
	s MODecVessel=$p(DataList,"^",4)
	s MOSoakWater=$p(DataList,"^",5)
	s MOSoakTime=$p(DataList,"^",6)
	s MODecTimes=$p(DataList,"^",7)
	s MODecTime=$p(DataList,"^",8)
	s MODecTemp=$p(DataList,"^",9)
	s MODecMethod=$p(DataList,"^",10)
	s MODecFirFried=$p(DataList,"^",11)
	s MODecSecFried=$p(DataList,"^",12)
	s MOMedTemp=$p(DataList,"^",13)
	s MOMedTime=$p(DataList,"^",14)
	s MOMedTimes=$p(DataList,"^",15)
	s MODosage=$p(DataList,"^",16)
	s MOFoodTaboo=$p(DataList,"^",17)
	s MOPostDrugCare=$p(DataList,"^",18)
	s MOMedNotify=$p(DataList,"^",19)
	s MOStorageMethod=$p(DataList,"^",20)
	s SpecialObey=$p(DataList,"^",21)
	
	s PrescType=$p(DataList,"^",22)
	s MOSoakWater2=$p(DataList,"^",23)
	s MODecTime2=$p(DataList,"^",24)
	s MOMattersAttention=$p(DataList,"^",25)
	s MOSyndromeContion=$p(DataList,"^",26)
	s MODietaryTaboos=$p(DataList,"^",27)
	s MOPregMedication=$p(DataList,"^",28)
	s MOChildMedication=$p(DataList,"^",29)
	s MOGeriatricMedication=$p(DataList,"^",30)
	s MODrugInteraction=$p(DataList,"^",31)
	s MOStorMethod=$p(DataList,"^",32)
	s MOToxicityTips=$p(DataList,"^",33)
	s MOHealthTips=$p(DataList,"^",34)
	s MOPrescCompotion=$p(DataList,"^",35)
	s MOPrescSpec=$p(DataList,"^",36)
	s MOPrescNum=$p(DataList,"^",37)

	TSTART
	&SQL(update CKB_PDSS.MedicationOrder set MO_Adm_Dr=:MOAdmDr,MO_SysNo=:MOSysNo,MO_PrescripNo=:MOPrescripNo,
		MO_Remarks=:MORemarks,MO_DecVessel=:MODecVessel,MO_SoakWater=:MOSoakWater,MO_SoakTime=:MODecTimes,MO_DecTimes=:MODecTime,MO_DecTime=:MOSoakTime
		,MO_DecTemp=:MODecTemp,MO_DecMethod=:MODecMethod,MO_DecFirFried=:MODecFirFried
		,MO_DecSecFried=:MODecSecFried,MO_MedTemp=:MOMedTemp,MO_MedTime=:MOMedTime,MO_MedTimes=:MOMedTimes,MO_Dosage=:MODosage,MO_FoodTaboo=:MOFoodTaboo,
		MO_PostDrugCare=:MOPostDrugCare,MO_MedNotify=:MOMedNotify,MO_StorageMethod=:MOStorageMethod ,MO_SpecialObey=:SpecialObey
		,MO_PrescType=:PrescType,MO_SoakWater2=:MOSoakWater2,MODecTime2=:MODecTime2
		,MO_MattersAttention=:MOMattersAttention,MO_SyndromeContion=:MOSyndromeContion,MO_DietaryTaboos=:MODietaryTaboos,MO_PregMedication=:MOPregMedication,
		MO_ChildMedication=:MOChildMedication,MO_GeriatricMedication=:MOGeriatricMedication,MO_DrugInteraction=:MODrugInteraction,MO_StorMethod=:MOStorMethod,
		MO_ToxicityTips=:MOToxicityTips,MO_HealthTips=:MOHealthTips,MO_PrescCompotion=:MOPrescCompotion,MO_PrescSpec=:MOPrescSpec,MO_PrescNum=:MOPrescNum
		Where MO_RowID=:ID
	)
	i SQLCODE=0 D
	.TCOMMIT
	.s result=+%ROWID 
	E  D
	.TROLLBACK
	.s result=SQLCODE
	Q result
}

/// Description: 药嘱单保存 更新流水号
/// Creator:     yuliping
/// CreateDate:  2021-05-29
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).updateSysNo()
ClassMethod updateSysNo(ID)
{
	n (ID)
	s result=""
	s sysNo = +$h_ID
	TSTART
	&SQL(update CKB_PDSS.MedicationOrder set MO_SysNo=:sysNo Where MO_RowID=:ID)
	i SQLCODE=0 D
	.TCOMMIT
	.s result=ID
	E  D
	.TROLLBACK
	.s result=SQLCODE
	Q result
}

/// Description: 药嘱单内容
/// Creator:     yuliping
/// CreateDate:  2021-6-09
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).getMedOrder(27)
ClassMethod getMedOrder(ID)
{
	n (ID)
	q:+ID=0 "{}"
	q:'$d(^CKB.PDSS.MedicationOrderD(ID)) "{}"
	
	s DataList = ^CKB.PDSS.MedicationOrderD(ID)
	s EpisodeID=$p(DataList,"^",1)
	s PapRowid=$p(^PAADM(EpisodeID),"^",1)
	s AdmDate=$p(^PAADM(EpisodeID),"^",6) 
	I +AdmDate>0 S AdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdmDate) 
	s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",","GC") //中医诊断
	s:PatDiag'="" PatDiag=$p(PatDiag,",",1)
	s AdmDoctor=""
	s AdmDocCodeDR=$p(^PAADM(EpisodeID),"^",9) //医生
	s AdmLoc=""
	s AdmLocId=$p(^PAADM(EpisodeID),"^",4) //科室
	s:AdmLocId'="" AdmLoc=$p(^CTLOC(AdmLocId),"^",2)
	s:(AdmLoc'="")&(AdmLoc["-") AdmLoc=$p(AdmLoc,"-",2)	

	s:AdmDocCodeDR'="" AdmDoctor=$p(^CTPCP(AdmDocCodeDR,1),"^",2)	
	s PatNo=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	s PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	s SexId=$p(^PAPER(PapRowid,"ALL"),"^",7) //性别
	s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PapRowid)  //年龄    
	s MedicalNo=$p(^PAPER(PapRowid,"PAT",1),"^",22) //病案号
	s Birthday=$p(^PAPER(PapRowid,"ALL"),"^",6) //出生日期
	s:Birthday'="" Birthday=##class(web.DHCADVCOMMON).DateLogicalToHtml(Birthday)
	s IDCard=$p(^PAPER(PapRowid,"ALL"),"^",9) //身份证号
	s PatTelH=$p(^PAPER(PapRowid,"PER",1),"^",11) 	 /// 电话 
	s Address=$g(^PAPER(PapRowid,"PER","ADD",1)) 	     /// 家庭住址
	
	s MOSysNo=$p(DataList,"^",2)  			//系统编号
	s MODate=$p(DataList,"^",3)				//日期
	s MODate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MODate) 	
	s MOPrescripNo=$p(DataList,"^",4)  		//处方号
	s MORemarks=$p(DataList,"^",5)   		//备注
	s MODecVessel=$p(DataList,"^",6)  		//煎煮器皿
	s MOSoakWater=$p(DataList,"^",7)  		//浸泡水量
	s MOSoakTime=$p(DataList,"^",8)  		//浸泡时间
	s MODecTimes=$p(DataList,"^",9)  		//煎煮次数
	s MODecTime=$p(DataList,"^",10)  		//煎煮时间
	s MODecTemp=$p(DataList,"^",11)  		//煎煮温度
	s MODecMethod=$p(DataList,"^",12)  		//特殊煎煮方法
	s MODecFirFried=$p(DataList,"^",13)  	//第一煎
	s MODecSecFried=$p(DataList,"^",14)  	//第二煎
	s MOMedTemp=$p(DataList,"^",15)  		//服药温度
	s MOMedTime=$p(DataList,"^",16)  		//服药时间
	s MOMedTimes=$p(DataList,"^",17)  		//服药次数
	s MODosage=$p(DataList,"^",18)  		//服药剂量
	s MOFoodTaboo=$p(DataList,"^",19)  		//服药食忌
	s MOPostDrugCare=$p(DataList,"^",20)  	//药后护理
	s MOMedNotify=$p(DataList,"^",21)  		//用药告知
	s MOStorageMethod=$p(DataList,"^",22)  	//储存方法
	s MOSpecialObey=$p(DataList,"^",23)  	//特殊服法
	s PrescType=$p(DataList,"^",24)  		//方剂类型
	s MOSoakWater2=$p(DataList,"^",25)  	//浸泡水量(二煎)
	s MODecTime2=$p(DataList,"^",26)  		//煎煮时间(二煎)
	
	s MOMattersAttention=$p(DataList,"^",27) 
	s MOSyndromeContion=$p(DataList,"^",28)
	s MODietaryTaboos=$p(DataList,"^",29)
	s MOPregMedication=$p(DataList,"^",30)
	s MOChildMedication=$p(DataList,"^",31)
	s MOGeriatricMedication=$p(DataList,"^",32)
	s MODrugInteraction=$p(DataList,"^",33)
	s MOStorMethod=$p(DataList,"^",34)
	s MOToxicityTips=$p(DataList,"^",35)
	s MOHealthTips=$p(DataList,"^",36)
	s MOPrescCompotion=$p(DataList,"^",37)
	s MOPrescSpec=$p(DataList,"^",38)
	s MOPrescNum=$p(DataList,"^",39)
	
	
	s tmpObj={}
	s tmpObj.ID=ID
	s tmpObj.PatName=PatName
	s tmpObj.PatNo=PatNo
	s tmpObj.PatSex=PatSex
	s tmpObj.PatAge=PatAge
	s tmpObj.AdmDate=AdmDate
	s tmpObj.AdmLoc=AdmLoc
	s tmpObj.AdmDoctor=AdmDoctor
	s tmpObj.PatDiag=PatDiag
	s tmpObj.IDCard=IDCard
	s tmpObj.Birthday=Birthday
	s tmpObj.PatTelH=PatTelH
	s tmpObj.Address=Address

	s tmpObj.MOSysNo=MOSysNo
	s tmpObj.MODate=MODate
	s tmpObj.MOPrescripNo=MOPrescripNo
	s tmpObj.MORemarks=MORemarks
	s tmpObj.MODecVessel=MODecVessel
	s tmpObj.MOSoakWater=MOSoakWater
	s tmpObj.MOSoakTime=MOSoakTime
	s tmpObj.MODecTimes=MODecTimes
	s tmpObj.MODecTime=MODecTime
	s tmpObj.MODecTemp=MODecTemp
	s tmpObj.MODecMethod=MODecMethod
	s tmpObj.MODecFirFried=MODecFirFried
	s tmpObj.MODecSecFried=MODecSecFried
	s tmpObj.MOMedTemp=MOMedTemp
	s tmpObj.MOMedTime=MOMedTime
	s tmpObj.MOMedTimes=MOMedTimes
	s tmpObj.MODosage=MODosage
	s tmpObj.MOFoodTaboo=MOFoodTaboo
	s tmpObj.MOPostDrugCare=MOPostDrugCare
	s tmpObj.MOMedNotify=MOMedNotify
	s tmpObj.MOStorageMethod=MOStorageMethod
	s tmpObj.MOSpecialObey=MOSpecialObey
	s tmpObj.PrescType = PrescType
	s tmpObj.MOSoakWater2 = MOSoakWater2  	//浸泡水量(二煎)
	s tmpObj.MODecTime2 = MODecTime2		//煎煮时间(二煎)
	
	s tmpObj.MOMattersAttention=MOMattersAttention
	s tmpObj.MOSyndromeContion=MOSyndromeContion
	s tmpObj.MODietaryTaboos=MODietaryTaboos
	s tmpObj.MOPregMedication=MOPregMedication
	s tmpObj.MOChildMedication=MOChildMedication
	s tmpObj.MOGeriatricMedication=MOGeriatricMedication
	s tmpObj.MODrugInteraction=MODrugInteraction
	s tmpObj.MOStorMethod=MOStorMethod
	s tmpObj.MOToxicityTips=MOToxicityTips
	s tmpObj.MOHealthTips=MOHealthTips
	s tmpObj.MOPrescCompotion=MOPrescCompotion
	s tmpObj.MOPrescSpec=MOPrescSpec
	s tmpObj.MOPrescNum=MOPrescNum
	
	w tmpObj.%ToJSON()
	q ""
}

/// Description: 药嘱单列表
/// Creator:     yuliping
/// CreateDate:  2021-6-10
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).listMedOrder(10,1,"2021-09-28^2021-10-28")
ClassMethod listMedOrder(rows = 10, page = 1, params)
{
	n (rows,page,params)
	q:params="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(0) //输出json结尾符
	s End = page*rows
	s Start=(page-1)*rows+1
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s StDate=$p(params,"^",1)    //开始日期
	s EndDate=$p(params,"^",2)   //结束日期
	s patname = $p(params,"^",3) //患者姓名

    s h=0  
	s:StDate'="" StDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(StDate)
	s:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(EndDate)
	q:StDate="" ##class(web.DHCADVJSONCOMMON).getJsonEmptySign(h) //输出json结尾符  //yangyongtao   2017-11-22
	
	s count=0
	w "{""rows"":["
	f date=EndDate:-1:StDate d
	.s MoID=""
	.f  s MoID=$o(^CKB.PDSS.MedicationOrderI("Date",date,MoID)) q:MoID=""  d
	..s Data = ^CKB.PDSS.MedicationOrderD(MoID)
	..s EpisodeID=$p(Data,"^",1)
	..q:EpisodeID=""
	..s MOSysNo=$p(Data,"^",2)  				//系统编号
	..s MODate=$p(Data,"^",3)				//日期
	..s MODate=##class(web.DHCADVCOMMON).DateLogicalToHtml(MODate) 	
	..s PapRowid=$p(^PAADM(EpisodeID),"^",1)
	..s AdmDate=$p(^PAADM(EpisodeID),"^",6) 
	..i +AdmDate>0 s AdmDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(AdmDate) 
	..s AdmLoc=""
	..s AdmLocId=$p(^PAADM(EpisodeID),"^",4) //科室
	..s:AdmLocId'="" AdmLoc=$p(^CTLOC(AdmLocId),"^",2)
	..s:(AdmLoc'="")&(AdmLoc["-") AdmLoc=$p(AdmLoc,"-",2)	
	..s PatNo=$p(^PAPER(PapRowid,"PAT",1),"^",1)  ;PAPMI_IPNo  字段
	..s PatName=$p(^PAPER(PapRowid,"ALL"),"^",1) //姓名
	..q:(patname'="")&&(PatName'[patname)
	..s SexId=$p(^PAPER(PapRowid,"ALL"),"^",7) //性别
	..s PatSex=$p(^CT("SEX",SexId),"^",2)
	..s PatAge=##Class(web.DHCSTKUTIL).GetAge(PapRowid)  //年龄    
	..s IDCard=$p(^PAPER(PapRowid,"ALL"),"^",9) //身份证号
	..s MOPrescripNo=$p(Data,"^",4)  		//处方号
	..s Language = $p(Data,"^",24) 
	..i Language["EN" s Language = "EN"
	..//i (($ascii(Language)>=65)&($ascii(Language)<=90))||(($ascii(Language)>=97)&($ascii(Language)<=122)) s Language = "EN"
	..s:Language'="EN" Language=""	// 增加语言标识
	..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..s tmpObj={}
	..s tmpObj.ID=MoID
	..s tmpObj.PatName=PatName
	..s tmpObj.PatNo=PatNo
	..s tmpObj.PatSex=PatSex
	..s tmpObj.PatAge=PatAge
	..s tmpObj.AdmDate=AdmDate
	..s tmpObj.AdmLoc=AdmLoc
	..s tmpObj.IDCard=IDCard
	..s tmpObj.MOPrescripNo=MOPrescripNo
	..s tmpObj.MODate=MODate
	..s tmpObj.Language=Language
	..w tmpObj.%ToJSON()
	
	w "],""total"":"_count_"}"
	q ""
}

/// Description: 获取字典的英翻译
/// Creator:     qunianpeng
/// CreateDate:  2021-9-28
/// Others: 	 W ##class(web.DHCCKBMedicationOrder).EnglishTranslation(dicID)
ClassMethod GetEnTranslation(dicID)
{
	n (dicID)
	s enDesc = ""
	s enTranslation = ##class(web.DHCCKBCommon).GetDicIdByCode("EnglishTranslation")
	s enDesc = ##class(web.DHCCKBEditProp).QueryAttrValue(dicID,enTranslation)
	i enDesc="" s enDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	
	q enDesc
}

}
