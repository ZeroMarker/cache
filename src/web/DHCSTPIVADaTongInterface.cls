Class web.DHCSTPIVADaTongInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:静脉配液大通接口程序
/// Creator:Liang Qiang
/// CreatDate:2009-10-04
/// 
/// 大通分析程序
ClassMethod GetDaTongPresInfo(OrderStr As %String) As %String
{
	n (OrderStr)
	q:OrderStr="" ""
	s Para=""
	s Para3=""
	s tmpgrpno=""
	s EpisodeDate=+$h
	s EpisodeDate=$zd(EpisodeDate,3)
	s EpisodeTime=$p($h,",",2)
	s EpisodeTime=$zt(EpisodeTime,1)
	s ItmCount=$l($g(OrderStr),"^")
    FOR i=1:1:ItmCount d 
    .s orditm=$p(OrderStr,"^",i)
    .s ord=+orditm
    .s chl=$p(orditm,"||",2)
    .q:(ord=0)||(chl=0)
    .s adm=$p(^OEORD(ord),"^",1)
    .s admtype=$p(^PAADM(adm),"^",2)
    .s UserID=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
    .s doctordr=$p(^SSU("SSUSR",UserID),"^",14)
    .q:doctordr=""
    .;s doctordr=$p(^OEORD(ord),"^",4)
	.s DocCode=$p(^CTPCP(doctordr,1),"^",1)
	.s DocName=$p(^CTPCP(doctordr,1),"^",2)
	.s DocProvID=$p(^CTPCP(doctordr,1),"^",4)
	.s DocProvCode=$p(^CT("CPT",DocProvID),"^",1)
	.s locdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	.s EpisodeLocCode=$p(^CTLOC(locdr),"^",1)
	.s EpisodeLocDesc=$p(^CTLOC(locdr),"^",2)
	.s papmidr=$p(^PAADM(adm),"^",1)
	.s PaadmAdmNo=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(adm,admtype)
	.s PatientNo=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号 (病历卡号)
	.s BedNo=""
	.s beddr=$p(^PAADM(adm),"^",73)
	.i beddr'="" s BedNo=$p($g(^PAWARD(+beddr,"BED",$P(beddr,"||",2))),"^",1)
	.s height=##class(web.DHCSTPIVA).GetPatHeight(adm)
	.s weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
	.s PatientBirthday=""
	.s PatientBirthday=$p($g(^PAPER(papmidr,"ALL")),"^",6)
	.i PatientBirthday'="" s PatientBirthday=$zd(PatientBirthday,3)
	.s PatientName=$p($g(^PAPER(papmidr,"ALL")),"^",1)
	.s PatientSex=""
    .s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
    .s sex=""
    .i sexdr'="" s PatientSex=$p(^CT("SEX",sexdr),"^",2)
    .s allergicCode="" //过敏源代码
	.s allergicDesc="" //过敏源名称
    .s MRDiagnos1="",MRDiagnos2="",MRDiagnos3=""
    .s MRDesc1="",MRDesc2="",MRDesc3=""
	.s MRAdmRowid=$p($g(^PAADM(adm)),"^",61)
	.i MRAdmRowid'="" d
	.s m=0
	.s h=0
	.Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	.d obj.Execute(MRAdmRowid)
	.For  Quit:'obj.Next()  Do
	..s Desc=obj.Data("MRDIAICDCodeDRDesc")
	..s MRDesc=obj.Data("MRDIADesc")
	..s Rowid=obj.Data("ID")
	..s CodeRowid=""   
	..s CodeRowid=obj.Data("MRDIAICDCodeDR")
	..if CodeRowid'="" d
	...s ICDCode=$P($G(^MRC("ID",CodeRowid)),"^",4)
	...s m=m+1
	...i m=1 s MRDiagnos1=ICDCode
	...i m=2 s MRDiagnos2=ICDCode   //诊断代码
	...i m=3 s MRDiagnos3=""
	...s h=h+1
	...i h=1 s MRDesc1=Desc
	...i h=2 s MRDesc2=Desc       //诊断描述
	...i h=3 s MRDesc3=""
	...s MRType=0                   //诊断类型
	.d obj.Close()
	.s Para="<safe>"
	.s Para=Para_"<doctor_information job_number='"_DocCode_"' date='"_EpisodeDate_" "_EpisodeTime_"' />"
	.s Para=Para_"<doctor_name>"_DocName_"</doctor_name>"
	.s Para=Para_"<doctor_type>"_DocProvCode_"</doctor_type>"
	.s Para=Para_"<department_code>"_EpisodeLocCode_"</department_code>"
	.s Para=Para_"<department_name>"_EpisodeLocDesc_"</department_name>"
	.s Para=Para_"<case_id>"_PatientNo_"</case_id>"
	.s Para=Para_"<inhos_code>"_PaadmAdmNo_"</inhos_code>"
	.s Para=Para_"<bed_no>"_BedNo_"</bed_no>"
	.s Para=Para_"<patient_information weight='"_weight_"' height='"_height_"' birth='"_PatientBirthday_"'>"
	.s Para=Para_"<patient_name>"_PatientName_"</patient_name><patient_sex>"_PatientSex_"</patient_sex>"
	.s Para=Para_"<physiological_statms></physiological_statms><boacterioscopy_effect></boacterioscopy_effect>"
	.s Para=Para_"<bloodpressure></bloodpressure><liver_clean></liver_clean>"
	.s Para=Para_"<pregnant></pregnant><pdw></pdw>"
	.s Para=Para_"<allergic_history><case><case_code>"_allergicCode_"</case_code><case_name>"_allergicDesc_"</case_name></case><case><case_code>"_allergicCode_"</case_code><case_name>"_allergicDesc_"</case_name></case><case><case_code>"_allergicCode_"</case_code><case_name>"_allergicDesc_"</case_name></case></allergic_history>"
	.s Para=Para_"<diagnoses><diagnose type='"_0_"' name='"_MRDesc1_"'>"_MRDiagnos1_"</diagnose><diagnose type='"_0_"' name='"_MRDesc2_"'>"_MRDiagnos2_"</diagnose></diagnoses>"
	.s Para=Para_"</patient_information>"
	.s Para=Para_"<prescriptions>"
	.
	.s OrdNo=orditm  //医嘱号
	.s priority=$p(^OEORD(ord,"I",chl,1),"^",8)
	.s priority=$p($g(^OECPR(+priority)),"^",1)
	.s priority="L"
	.
	.s GroupNumber=$p(^OEORD(ord,"I",chl,3),"^",4) //组号
	.i tmpgrpno'="" s GroupNumber=tmpgrpno
	.i tmpgrpno="" s tmpgrpno=GroupNumber
	.S moeori=##class(web.DHCSTPIVA).GetMainOeori(orditm)
	.s GroupNumber=$p(^OEORD(+moeori,"I",$p(moeori,"||",2),3),"^",4)
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))
	.s GenDesc=##class(web.DHCSTCOMMONSRV).getGeneric(inci) //通用名
	.i $f(GenDesc,"-") s GenDesc=$p(GenDesc,"-",2)
	.s DrgCode=$p(^INCI(inci,1),"^",1)
	.s DrgDesc=$p(^INCI(inci,1),"^",2)
	.s DoseQty=$p(^OEORD(ord,"I",chl,2),"^",1) // 剂量
	.s OrderFreqRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
	.s FreqCode=$p($g(^PHCFR(+OrderFreqRowid)),"^",1)
	.s OrderDurRowid=$p($g(^OEORD(ord,"I",chl,2)),"^",6) ;OEORI_Durat_DR
    .s OrderDurFactor=$P($g(^PHCDU(+OrderDurRowid)),"^",2) // 次数
    .s DoseQtyUOMDesc=$p($g(^CT("UOM",+$p(^OEORD(ord,"I",chl,2),"^",3))),"^",2)
    .s InstrCode=$p($g(^PHCIN(+$p(^OEORD(ord,"I",chl,2),"^",7))),"^",1)
    .s oeoridate=$p(^OEORD(ord,"I",chl,3),"^",7)
    .i oeoridate'="" s oeoridate=$zd(oeoridate,3)
	.s oeoritime=$p(^OEORD(ord,"I",chl,1),"^",17)
	.i oeoritime'="" s oeoritime=$zt(oeoritime,1)
	.s orddatetime=oeoridate_" "_oeoritime
	.
	.s ordsdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.i ordsdate'="" s ordsdate=$zd(ordsdate,3)
	.s ordstime=$p(^OEORD(ord,"I",chl,1),"^",10)
	.i ordstime'="" s ordstime=$zt(ordstime,1)
	.s ordsdatetime=ordsdate_" "_ordstime
	.
	.s ordedate=$p(^OEORD(ord,"I",chl,3),"^",34)
	.i ordedate'="" s ordedate=$zd(ordedate,3)
	.s ordetime=$p(^OEORD(ord,"I",chl,2),"^",15)
	.i ordetime'="" s ordetime=$zt(ordetime,1)
	.s ordxdatetime=ordedate_" "_ordetime
	.i admtype="O" s priority="mz"  
	.s current="1"
	.s Para3=Para3_"<prescription id='"_OrdNo_"' type='"_priority_"' current='"_current_"'>"
	.s Para3=Para3_"<medicine suspension='false' judge='true'>"
	.s Para3=Para3_"<group_number>"_GroupNumber_"</group_number>"
	.s Para3=Para3_"<general_name>"_GenDesc_"</general_name>"
	.s Para3=Para3_"<license_number>"_DrgCode_"</license_number>"
	.s Para3=Para3_"<medicine_name>"_DrgDesc_"</medicine_name>"
	.s Para3=Para3_"<single_dose coef='1'>"_DoseQty_"</single_dose>"
	.s Para3=Para3_"<frequency>"_FreqCode_"</frequency>"
	.s Para3=Para3_"<times>"_OrderDurFactor_"</times>"
	.s Para3=Para3_"<unit>"_DoseQtyUOMDesc_"</unit>"
	.s Para3=Para3_"<administer_drugs>"_InstrCode_"</administer_drugs>"
	.s Para3=Para3_"<begin_time>"_ordsdatetime_"</begin_time>"
    .s Para3=Para3_"<end_time>"_ordxdatetime_"</end_time>"
    .s Para3=Para3_"<prescription_time>"_orddatetime_"</prescription_time>" 
	.s Para3=Para3_"</medicine>"_"</prescription>"
	.s Para=Para_Para3_"</prescriptions></safe>"
	.
	Quit Para
}

/// 大通要点提示
ClassMethod GetDTYDTS(OrderItemRowid As %String) As %String
{
	n (OrderItemRowid)
	q 0
	s a=b
	Quit:OrderItemRowid="" "<safe><general_name>"_"</general_name><license_number>"_"</license_number></safe>"
	s Para=""
	s Ord=+OrderItemRowid
	s Chl=$p(OrderItemRowid,"||",2)
	s ARCIMRowid=$p(^OEORD(Ord,"I",Chl,1),"^",2)
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
    i DrgFormRowid'="" d
    .s DrgCode=$p(^PHCD(+DrgFormRowid,1),"^",1)
    .s DrgDesc=$p(^PHCD(+DrgFormRowid,1),"^",2)
    .s Para="<safe><general_name>"_DrgDesc_"</general_name><license_number>"_DrgCode_"</license_number></safe>"
    if Para="" s Para="<safe><general_name>"_"</general_name><license_number>"_"</license_number></safe>"
    Quit Para
}

/// Description:取医嘱串
/// Creator:	LiangQiang
ClassMethod GetDaTongByOrd(orditm) As %String
{
	s str=##class(web.DHCOutPhCommon).GetOrdStrByOrd(orditm)
	q ..GetDaTongPresInfo(str)
}

/// 根据处方号返回医嘱ID串
/// Creator:myq
/// w ##class(web.DHCSTCNTSMAIN).GetOrdID("O13051800032")
ClassMethod GetOrdStrByPrescNo(prescno)
{
   //s ^tmyq("myq")=1
    s ordstr=""
	s ord=""
	s h=0
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s orditm=ord_"||"_chl
	..i ordstr="" s ordstr=orditm 
	..e  d 
	...s ordstr=ordstr_"^"_orditm  
	..s h=h+1
	;q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
   ; s Orditemstr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("Orditemstr",ordstr)
    q ordstr
}

/// 门诊处方大通合理用药获取处方医嘱信息
/// 1335051||13^1335051||14
/// w ##class(web.DHCSTPIVADaTongInterface).GetDaTongOutPresInfo("1335051||13^1335051||14")
ClassMethod GetDaTongOutPresInfo(orditmstr As %String) As %String
{
	//s ^tmyq("GetDaTongOutPresInfo")=orditmstr
	q:orditmstr="undefined" ""
	s ret=""
	s orditm=$p(orditmstr,"^",1)
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
    .f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ..s orditem=ord_"||"_chl
    ..s itmmast=$p(^OEORD(ord,"I",chl,1),"^",2)
    ..s ItemCatDR=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
    ..s ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    ..q:(ordertype'="R")    //按照类型过滤   bianshuai 2014-04-11
    ..s auditflag=$p(^OEORD(ord,"I",chl,7),"^",3)
    ..//q:auditflag'=""    //注释 bianshuai 2014-05-26
    ..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1)
	..q:(oeflag'="V")&(oeflag'="E")
	..s priordr=$p(^OEORD(ord,"I",chl,1),"^",8)
    ..q:priordr="" 
    ..s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ..q:priority["OM" ;自备药
    ..i ret="" d
    ...s ret=orditem
    ..e  d
    ...s ret=ret_"^"_orditem
    ..
    q ..GetDaTongPresInfo(ret)
}

/// Author : MYQ
/// CreatDate : 20160729
/// Description : 根据处方号获取开单医生基本信息串
/// Input : prescno - 处方号
/// w ##class(web.DHCSTPIVADaTongInterface).GetDocBaseInfoByPresc("O16072200003")
ClassMethod GetDocBaseInfoByPresc(prescno As %String) As %String
{
	q:prescno="" ""
	s BascInfoStr=""
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s chl=""
	s:ord'="" chl=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	i chl'="" d
	.s UserID=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
	.s DocLocID=$p($g(^OEORD(ord,"I",chl,1)),"^",3)
	.s BascInfoStr=..GetBaseInfo(DocLocID,UserID)
	
	q BascInfoStr
}

/// 来自武汉普仁版本
ClassMethod GetBaseInfo(LocId As %String, UserId As %String) As %String
{
	s HospCode="",LocDesc="",LocCode="",DocName="",DocCode="",DocType="",DocTypeCode="",CarPrvTpDR=""
	s HospCode="196"  ;..GetHospitalCode(LocId)
	s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	i LocDesc["-" s LocDesc=$p(LocDesc,"-",2)
	s LocCode=$p($g(^CTLOC(LocId)),"^",1)
	s DocId=$p(^SSU("SSUSR",UserId),"^",14)
	s:DocId'="" DocCode=$p($g(^CTPCP(DocId,1)),"^",1)
	s:DocId'="" DocName=$p($g(^CTPCP(DocId,1)),"^",2)
	s:DocId'="" CarPrvTpDR=$p($g(^CTPCP(DocId,1)),"^",4)
	s:CarPrvTpDR'="" DocType=$p($g(^CT("CPT",CarPrvTpDR)),"^",2)
	s:CarPrvTpDR'="" DocTypeCode=$p($g(^CT("CPT",CarPrvTpDR)),"^",1)
	s BaseInfo="<base_xml><source>HIS</source><hosp_code>"_562_"</hosp_code><dept_code>"_LocCode_"</dept_code><dept_name>"_LocDesc_"</dept_name>"
	s BaseInfo=BaseInfo_"<doct><code>"_DocCode_"</code><name>"_DocName_"</name><type>"_DocType_"</type><type_name>"_DocTypeCode_"</type_name ></doct></base_xml>"
	q BaseInfo
}

/// Author : MYQ
/// CreatDate : 20160729
/// Description : 根据处方号获取处方信息串
/// Input : prescno - 处方号
/// w ##class(web.DHCSTPIVADaTongInterface).GetPrescInfoXML("O16072200003")
ClassMethod GetPrescInfoXML(prescno As %String) As %String
{
	s ^tmyq("GetPrescInfoXML")=prescno
	q:prescno="" ""
	s PrescInfoStr=""
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s chl=""
	i ord'="" d
	.s chl=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	.s episodeid=$p(^OEORD(ord),"^",1)
	i chl'="" d
	.s UserID=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
	.s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	.s DocLocID=$p($g(^OEORD(ord,"I",chl,1)),"^",3)
	
	s orderstr=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s oeori=ord_"||"_chl
	..s arcitm=$p($g(^OEORD(ord,"I",chl,1)),"^",2)	//医嘱项id
	..s doseqty=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) 	//剂量
	..s doseuomid=+$p(^OEORD(ord,"I",chl,2),"^",3)	//剂量单位
	..s freqid=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)	//批次
	..s durid=+$p(^OEORD(ord,"I",chl,2),"^",6)		//疗程
	..s instruid=+$p(^OEORD(ord,"I",chl,2),"^",7)	//用法
	..s arc=+arcitm
	..s ver=$p(arcitm,"||",2)
	..s arcphcdrid=$p($g(^ARCIM(arc,ver,1)),"^",12)
	..s drugformid=arcphcdrid
	..;s drugformid=$p($g(^PHCD(+arcphcdrid,"DF",$p(arcphcdrid,"||",2),1)),"^",1)
	..s mastersqlno=+$p(^OEORD(ord,"I",chl,3),"^",4)
	..s mastersqlno=$p(mastersqlno,".",1)
	..s priorid=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..s startdate=+$p(^OEORD(ord,"I",chl,1),"^",9)
	..s:startdate'="" startdate=$zd(startdate,3)
	..s starttime=+$p(^OEORD(ord,"I",chl,1),"^",10)
	..s:starttime'="" starttime=$zt(starttime)
	..s string=arcitm_"!"_doseqty_"!"_doseuomid_"!"_freqid_"!"_durid_"!"_instruid_"!"_drugformid_"!"_mastersqlno_"!"_priorid_"!"_startdate_"!"_starttime_"!"_oeori
	..i orderstr'="" d
	...s orderstr=orderstr_"^"_string
	..e  d
	...s orderstr=string
	
	s PrescInfoStr=..GetPrescXML(orderstr,episodeid,UserCode,UserID,0)
	
	q PrescInfoStr
}

/// 大通分析程序
/// 来自武汉普仁版本
/// OrderStr:OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime+"!"+OEORIRowid;
/// 				医嘱项目ID			单次剂量		单次剂量单位ID			频次ID			疗程ID				用法ID				药学项目ID				组号			医嘱优先级ID		开始日期			开始时间		医嘱ID(仅保存后存在)
/// w ##class(web.DHCandDaTongInterface).GetPrescXML("540||1!10!102!1!63!58!540||1!3!3!17/07/2015!11:24","4051868","10118","876")
ClassMethod GetPrescXML(OrderStr As %String, EpisodeID As %String, DocCode As %String, UserID As %String, UploadFlag As %String) As %String
{

	
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
	&SQL(Select PAPMI_No into :PatientNo From SQLUser.PA_PatMas Where PAPMI_Rowid=:PatientID)
	s MedicareNo=##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(EpisodeID,EpisodeType)
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

/// Author : MaYuqiang
/// CreatDate : 20170220
/// Description : 根据处方号获取处方信息串  
/// 			  来自安医四附院版本_美康4.0
/// Input : prescno - 处方号
/// w ##class(web.DHCSTPIVADaTongInterface).GetPrescDetailInfo("O16120100052")
ClassMethod GetPrescDetailInfo(prescno As %String) As %String
{
	q:prescno="" ""
	s PrescInfoStr=""
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	s chl=""
	i ord'="" d
	.s chl=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	.s episodeid=$p(^OEORD(ord),"^",1)
	i chl'="" d
	.s UserID=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
	.s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	.s DocLocID=$p($g(^OEORD(ord,"I",chl,1)),"^",3)
	
	s orderstr=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s oeori=ord_"||"_chl
	..s arcitm=$p($g(^OEORD(ord,"I",chl,1)),"^",2)	//医嘱项id
	..s doseqty=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) 	//剂量
	..s doseuomid=+$p(^OEORD(ord,"I",chl,2),"^",3)	//剂量单位
	..s freqid=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)	//批次
	..s durid=+$p(^OEORD(ord,"I",chl,2),"^",6)		//疗程
	..s instruid=+$p(^OEORD(ord,"I",chl,2),"^",7)	//用法
	..s arc=+arcitm
	..s ver=$p(arcitm,"||",2)
	..s arcphcdrid=$p($g(^ARCIM(arc,ver,1)),"^",12)
	..s drugformid=arcphcdrid
	..;s drugformid=$p($g(^PHCD(+arcphcdrid,"DF",$p(arcphcdrid,"||",2),1)),"^",1)
	..s mastersqlno=+$p(^OEORD(ord,"I",chl,3),"^",4)
	..s mastersqlno=$p(mastersqlno,".",1)
	..s ordersqlno=$p(mastersqlno,".",2)
	..s priorid=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..s startdate=+$p(^OEORD(ord,"I",chl,1),"^",9)
	..s:startdate'="" startdate=$zd(startdate,3)
	..s starttime=+$p(^OEORD(ord,"I",chl,1),"^",10)
	..s:starttime'="" starttime=$zt(starttime)
	..s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeori,"")) 
	..q:dspID="" 
	..s qty=$p(^DHCOEDISQTY(dspID),"^",5)
	..s inci=$O(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
	..s bUomDr=$p($G(^INCI(inci,1)),"^",10)
    ..s pUomDr=$p($G(^INCI(inci,3)),"^",6)
    ..//s pUomDesc=$p($g(^CT("UOM",+pUomDr)),"^",2)
	..s fac=##Class(web.DHCSTCOMMONSRV).UOMFac(pUomDr,bUomDr)
	..s pQty=inci/fac   			//转化为大单位
	..s string=arcitm_"!"_doseqty_"!"_doseuomid_"!"_freqid_"!"_durid
	..s string=string_"!"_instruid_"!"_drugformid_"!"_priorid_"!"_ordersqlno_"!"_mastersqlno
	..s string=string_"!"_pQty_"!"_pUomDr
	..i orderstr'="" d
	...s orderstr=orderstr_"^"_string
	..e  d
	...s orderstr=string
		
	q orderstr
}

/// Author : MaYuqiang
/// CreatDate : 2017-02-20
/// Description : 根据处方号获取处方信息
/// 			  来自安医四附院版本_美康4.0
/// Input : prescno - 处方号
/// Output : 开医嘱医院id^医嘱录入人id^医嘱录入人名称^开医嘱科室id^开医嘱科室名称
/// w ##class(web.DHCSTPIVADaTongInterface).GetPrescMainInfo("O181023000004")
ClassMethod GetPrescMainInfo(prescno)
{
	q:prescno="" ""
	s orditm=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(orditm'="")  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:(chl="")||(orditm'="")  d
	..s arcitm=$p(^OEORD(ord,"I",chl,1),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",+arcitm,""))
	..s incscdr=$p(^INCI(inci,2),"^",2)
	..q:incscdr=""
	..s scgdr=$o(^DHCSCG("STKCAT",incscdr,""))	
	..q:scgdr=""
	..s scgtype=$p(^DHCSCG(scgdr),"^",3)	//DHC_StkCatGroup
	..q:scgtype'="G"	//过虑掉非药品医嘱
	..s orditm=ord_"||"_chl
	
	q:orditm="" ""
	
	s orddeptid=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),1),"^",3)
	s orddeptdesc="",hospid="",orddeptcode=""
	i orddeptid'="" d
	.s orddeptdesc=$p(^CTLOC(orddeptid),"^",2)	//开单科室
	.s orddeptcode=$p(^CTLOC(orddeptid),"^",1)
	.s hospid=$p(^CTLOC(orddeptid),"^",22)
	s doctorid=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),7),"^",1)	//医嘱录入人
	s doctorname="",doctorcode=""
	i doctorid'="" d
	.s doctorname=$p(^SSU("SSUSR",doctorid),"^",2)
	.s doctorcode=$p(^SSU("SSUSR",doctorid),"^",1)
	s adm=$p(^OEORD(+orditm),"^",1)
	
	q hospid_"^"_doctorid_"^"_doctorname_"^"_orddeptid_"^"_orddeptdesc_"^"_adm_"^"_doctorcode_"^"_orddeptcode
}

/// Author : MaYuqiang
/// CreatDate : 2018-10-24
/// Description : 根据处方号获取处方信息
/// 			  来自安医四附院版本_美康4.0
/// Input : mOeori - 主医嘱id
/// Output : 开医嘱医院id^医嘱录入人id^医嘱录入人名称^开医嘱科室id^开医嘱科室名称
/// w ##class(web.DHCSTPIVADaTongInterface).GetOrderMainInfo("2047||5")
ClassMethod GetOrderMainInfo(mOeori)
{
	q:+mOeori="0" ""
	
	s orddeptid=$p(^OEORD(+mOeori,"I",$p(mOeori,"||",2),1),"^",3)
	s orddeptdesc="",hospid="",orddeptcode=""
	i orddeptid'="" d
	.s orddeptdesc=$p(^CTLOC(orddeptid),"^",2)	//开单科室
	.s orddeptcode=$p(^CTLOC(orddeptid),"^",1)
	.s hospid=$p(^CTLOC(orddeptid),"^",22)
	s doctorid=$p(^OEORD(+mOeori,"I",$p(mOeori,"||",2),7),"^",1)	//医嘱录入人
	s doctorname="",doctorcode=""
	i doctorid'="" d
	.s doctorname=$p(^SSU("SSUSR",doctorid),"^",2)
	.s doctorcode=$p(^SSU("SSUSR",doctorid),"^",1)
	s adm=$p(^OEORD(+mOeori),"^",1)
	
	s inciCode="",inciDesc="",zcyflag=""
	s prescNo = $p($g(^OEORD(+mOeori,"I",$p(mOeori,"||",2),1)),"^",14)
	s arcitm = $p($g(^OEORD(+mOeori,"I",$p(mOeori,"||",2),1)),"^",2)	//医嘱项id
	i arcitm'="" d
	.s inci = +$o(^INCI(0,"ARCIM_DR",+arcitm,""))
	.s inciCode = $p($g(^INCI(inci,1)),"^",1)
	.s inciDesc = $p($g(^INCI(inci,1)),"^",2)
	i prescNo'="" d
	..s quer=$o(^PAQUE1(0,"PrescNo",prescNo,""))
	..i quer'="" d
	...i $d(^PAQUE1(quer,"DHC")) s zcyflag=1 
	
	s retStr = hospid_"^"_doctorid_"^"_doctorname_"^"_orddeptid_"^"_orddeptdesc
	s retStr = retStr_"^"_adm_"^"_doctorcode_"^"_orddeptcode_"^"_inciCode_"^"_inciDesc
	s retStr = retStr_"^"_prescNo_"^"_zcyflag
	q retStr
}

/// Author : MaYuqiang
/// CreatDate : 20181024
/// Description : 根据主医嘱获取医嘱信息串
/// 			  来自安医四附院版本_美康4.0
/// Input : mOeori - 主医嘱id
/// w ##class(web.DHCSTPIVADaTongInterface).GetPrescDetailInfo("O16120100052")
ClassMethod GetOrdDetailByMOrder(mOeori As %String) As %String
{
	q:+mOeori="0" ""
	s orderstr=""
	s ord=+mOeori
	
	i +ord'="0" d
	.s chl=""
	.f  s chl=$o(^OEORDi(0,"OEORI",ord,mOeori,chl)) q:chl=""  d
	..s oeori=ord_"||"_chl
	..s arcitm=$p($g(^OEORD(ord,"I",chl,1)),"^",2)	//医嘱项id
	..s doseqty=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) 	//剂量
	..s doseuomid=+$p(^OEORD(ord,"I",chl,2),"^",3)	//剂量单位
	..s freqid=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)	//批次
	..s durid=+$p(^OEORD(ord,"I",chl,2),"^",6)		//疗程
	..s instruid=+$p(^OEORD(ord,"I",chl,2),"^",7)	//用法
	..s arc=+arcitm
	..s ver=$p(arcitm,"||",2)
	..s arcphcdrid=$p($g(^ARCIM(arc,ver,1)),"^",12)
	..s drugformid=arcphcdrid
	..;s drugformid=$p($g(^PHCD(+arcphcdrid,"DF",$p(arcphcdrid,"||",2),1)),"^",1)
	..s mastersqlno=+$p(^OEORD(ord,"I",chl,3),"^",4)
	..s mastersqlno=$p(mastersqlno,".",1)
	..s ordersqlno=$p(mastersqlno,".",2)
	..s priorid=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..s startdate=+$p(^OEORD(ord,"I",chl,1),"^",9)
	..s:startdate'="" startdate=$zd(startdate,3)
	..s starttime=+$p(^OEORD(ord,"I",chl,1),"^",10)
	..s:starttime'="" starttime=$zt(starttime)
	..s string=arcitm_"!"_doseqty_"!"_doseuomid_"!"_freqid_"!"_durid_"!"_instruid_"!"_drugformid_"!"_priorid_"!"_ordersqlno_"!"_mastersqlno
	..i orderstr'="" d
	...s orderstr=orderstr_"^"_string
	..e  d
	...s orderstr=string
	
	// 以下为主医嘱信息
	s mchl=$p(mOeori,"||",2)
	s arcitm=$p($g(^OEORD(ord,"I",mchl,1)),"^",2)	//医嘱项id
	s doseqty=$j($p(^OEORD(ord,"I",mchl,2),"^",1)," ",3) 	//剂量
	s doseuomid=+$p(^OEORD(ord,"I",mchl,2),"^",3)	//剂量单位
	s freqid=+$p($g(^OEORD(ord,"I",mchl,2)),"^",4)	//批次
	s durid=+$p(^OEORD(ord,"I",mchl,2),"^",6)		//疗程
	s instruid=+$p(^OEORD(ord,"I",mchl,2),"^",7)	//用法
	s arc=+arcitm
	s ver=$p(arcitm,"||",2)
	s arcphcdrid=$p($g(^ARCIM(arc,ver,1)),"^",12)
	s drugformid=arcphcdrid
	s mastersqlno=+$p(^OEORD(ord,"I",mchl,3),"^",4)
	s mastersqlno=$p(mastersqlno,".",1)
	s ordersqlno=$p(mastersqlno,".",2)
	s priorid=+$p(^OEORD(ord,"I",mchl,1),"^",8)
	s startdate=+$p(^OEORD(ord,"I",mchl,1),"^",9)
	s:startdate'="" startdate=$zd(startdate,3)
	s starttime=+$p(^OEORD(ord,"I",mchl,1),"^",10)
	s:starttime'="" starttime=$zt(starttime)
	s string=arcitm_"!"_doseqty_"!"_doseuomid_"!"_freqid_"!"_durid_"!"_instruid_"!"_drugformid_"!"_priorid_"!"_ordersqlno_"!"_mastersqlno
	
	i orderstr'="" d
	.s orderstr=orderstr_"^"_string
	e  d
	.s orderstr=string
		
	q orderstr
}

}
