/// Creator:	yejian
/// CreatDate:  2019-4-15
/// Desc:		电子病历数据采集接口
Class EMRservice.InterfaceService.EMRRecordCollectInterface Extends %RegisteredObject
{

/// 机构编码
Parameter HOSCode = 401021275;

/// 机构编码
Parameter HOSName = "北京中医医院延庆医院";

/// 6.6.1入院记录_基本信息（t_inhosp）
/// Creator:    yejian
/// CreateDate: 2019-5-8	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","InHospitalRecord","2015-12-05","2015-12-05")
Query InHospitalRecord(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,marital_code,marital_name,nation_code,nation_name,occup_name,occup_code,tcm_mark,diag_no,depart_no,depart_name,medi_rec_no,hospital_no,bed_no,room_no,ward_name,inhosp_time,accept_doct_no,accept_doct_name,chief_doct_name,chief_doct_no,main_doct_name,main_doct_no,inhosp_doct_name,inhosp_doct_no,chief_complaint,now_dis_his,past_dis_his,person_his,marital_his,menses_his,family_his,infect_his,vacc_his,transfuse_blood_his,allergic_his,proc_his,medi_his_relator_name,inhosp_path_code,inhosp_path_name,pat_speaker_relate_name,pat_speaker_relate_code,statement_reliable_mark,infectivity_mark,assist_check_res,skin_check_res,four_tcm_observ_res,therapeutic_treat,breathe_rate,pulse_rate,height,sbp,dbp,body_temperat,weight,health_case_mark,general_check_res,abdominal_check_res,anus_check_res_descr,spine_aZBorm_check_res,skin_mucosa_check_res,limbs_check_res,aedea_check_res,neck_check_res,head_check_res,phys_mental_check_res,lymph_check_res_descr,chest_check_res,upload_time") [ SqlProc ]
{
}

ClassMethod InHospitalRecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.13.01"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,maritalcode,maritalname,nationcode,nationname,occupname,occupcode,tcmmark,diagno,departno,departname,medirecno,hospitalno,bedno,roomno,wardname,inhosptime,acceptdoctno,acceptdoctname,chiefdoctname,chiefdoctno,maindoctname,maindoctno,inhospdoctname,inhospdoctno,chiefcomplaint,nowdishis,pastdishis,personhis,maritalhis,menseshis,familyhis,infecthis,vacchis,transfusebloodhis,allergichis,prochis,medihisrelatorname,inhosppathcode,inhosppathname,patspeakerrelatename,patspeakerrelatecode,statementreliablemark,infectivitymark,assistcheckres,skincheckres,fourtcmobservres,therapeutictreat,breatherate,pulserate,height,sbp,dbp,bodytemperat,weight,healthcasemark,generalcheckres,abdominalcheckres,anuscheckresdescr,spineaZBormcheckres,skinmucosacheckres,limbscheckres,aedeacheckres,neckcheckres,headcheckres,physmentalcheckres,lymphcheckresdescr,chestcheckres,uploadtime)=""

	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s departdr=$p(^PAADM(AEpisodeID),"^",4)
			s departno=$p($g(^CTLOC(departdr)),"^",1)  //科室代码
			s departname=$p($g(^CTLOC(departdr)),"^",1) //科室名称
			s CurrentWardDR=$p(^PAADM(AEpisodeID),"^",70)
	        s:CurrentWardDR'="" wardname=$p(^PAWARD(CurrentWardDR),"^",2)  //病区名称
	        s CurrentRoomDR=$p(^PAADM(AEpisodeID),"^",69)
		    s roomno=""
	        i CurrentRoomDR'="" d
	        .s roomno=$p(^PAROOM(CurrentRoomDR),"^")  //病房号
	        s:roomno="" roomno="-"
	        s CurrentBedDR=$p(^PAADM(AEpisodeID),"^",73)
			s bedno=""
	        i CurrentBedDR'="" d
	        .s bedno=$p($g(^PAWARD($p(CurrentBedDR,"||"),"BED",$p(CurrentBedDR,"||",2))),"^") //病床号 
	        s:bedno="" bedno="-"
			s AdmDocCodeDR=$p(^PAADM(AEpisodeID),"^",9)
	        s acceptdoctname="",acceptdoctno=""
	        i AdmDocCodeDR'="" d
	        .s acceptdoctno=$p(^CTPCP(AdmDocCodeDR,1),"^") //接诊医生编号 
	        .s acceptdoctname=$p(^CTPCP(AdmDocCodeDR,1),"^",2)  //接诊医生签名
	        s medirecno=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(argPapmiDR,"I","") //住院病案号
	        s hospitalno=$p(^PAADM(AEpisodeID),"^",81) //住院号
	        s inhosppath=##class(web.DHCENS.Method.Query.InHospRegister).GetAdmSource(AEpisodeID) 
		    s inhosppathcode=$p($g(inhosppath),"^",1)
	        s inhosppathname=$p($g(inhosppath),"^",2)
	        i inhosppathcode="" s inhosppathcode="9" s inhosppathname="门诊"
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname= arr.GetAt("HDSD00.13.039")
			//性别代码	N1	必填
			s gendercode= arr.GetAt("HDSD00.13.096")
			//性别名称	AN..20	必填
			s gendername= arr.GetAt("HDSD00.13.318")
			//年龄(岁)	N1..3	
			s ageyear= arr.GetAt("HDSD00.13.047")
			//年龄(月)	N1..2	
			s agemonth= arr.GetAt("HDSD00.13.048")
			//年龄(天)	N1..2	
			s ageday= arr.GetAt("HDSD00.13.316")
			//婚姻状况代码	N2	必填
			s maritalcode = arr.GetAt("HDSD00.13.040")
			//婚姻状况名称	AN..20	必填
			s maritalname= arr.GetAt("HDSD00.13.324")
			//民族代码	N2	必填
			s nationcode = arr.GetAt("HDSD00.13.046")
			//民族名称	AN..20	必填
			s nationname= arr.GetAt("HDSD00.13.325")
			//职业类别名称	AN..50	必填
			s occupname= arr.GetAt("HDSD00.13.327")
			s:occupname="" occupname="其他"
			//职业类别代码	AN..30	必填
			s occupcode = arr.GetAt("HDSD00.13.110")
			s:occupcode="" occupcode="90"
			//中医标志	T/F	必填
			s tcmmark= "1"
			//就诊流水号	AN..32	必填
			s diagno= $p(^PAADM(AEpisodeID),"^",81)
			//入院科室编号	AN..20	必填
			;s departno= ""
			//入院科室名称	AN..50	必填
			;s departname= ""
			//病案号	AN..32	必填
			;s medirecno= ""
			//住院号	AN..32	必填
			;s hospitalno = arr.GetAt("HDSD00.13.116")
			//病床号	AN..64	必填
			;s bedno = arr.GetAt("HDSD00.13.001")
			//病房号	AN..30	必填
			;s roomno = arr.GetAt("HDSD00.13.002")
			//病区名称	AN..100	必填
			;s wardname = arr.GetAt("HDSD00.13.003")
			//入院日期时间	DT15	必填
			s inhosptime = arr.GetAt("HDSD00.13.057")
			//接诊医师编号	AN..64	
			;s acceptdoctno = arr.GetAt("HDSD00.13.326")
			//接诊医师签名	AN..50	
			;s acceptdoctname = arr.GetAt("HDSD00.13.044")
			//主任医师签名	AN..50	必填
			s chiefdoctname ="-" //arr.GetAt("HDSD00.13.113")
			//主任医师编号	AN..64	必填
			s chiefdoctno= "-" //arr.GetAt("HDSD00.13.317")
			//主治医师签名	AN..50	必填
			s maindoctname = arr.GetAt("HDSD00.13.323")
			i maindoctname="" s maindoctname="-"
			//主治医师编号	AN..64	必填
			s maindoctno= "-" //arr.GetAt("HDSD00.13.323")
			//住院医师签名	AN..50	必填
			s inhospdoctname = arr.GetAt("HDSD00.13.322")
			i inhospdoctname="" s inhospdoctname="-"
			//住院医师编号	AN..64	必填
			s inhospdoctno = "-" //arr.GetAt("HDSD00.13.322")
			//主诉	AN..100	必填
			s chiefcomplaint = arr.GetAt("HDSD00.13.114")
			s:chiefcomplaint="" chiefcomplaint="-"
			//现病史	AN..200	必填
			s nowdishis = arr.GetAt("HDSD00.13.095")
			s:nowdishis="" nowdishis="-"
			//疾病史(含外伤)	AN..1000	必填
			s pastdishis = arr.GetAt("HDSD00.13.042")
			//个人史	AN..1000	有则必填
			s personhis = arr.GetAt("HDSD00.13.036")
			//婚育史	AN..1000	有则必填
			s maritalhis = arr.GetAt("HDSD00.13.041")
			//月经史	AN..1000	有则必填
			s menseshis = arr.GetAt("HDSD00.13.106")
			//家族史	AN..200	有则必填
			s familyhis = arr.GetAt("HDSD00.13.043")
			//传染病史	AN..200	有则必填
			s infecthis = arr.GetAt("HDSD00.13.028")
			//预防接种史	AN..200	有则必填
			s vacchis = arr.GetAt("HDSD00.13.105")
			//输血史	AN..200	有则必填
			s transfusebloodhis = arr.GetAt("HDSD00.13.066")
			//过敏史	AN..200	有则必填
			s allergichis = arr.GetAt("HDSD00.13.037")
			//手术史	AN..200	有则必填
			s prochis = arr.GetAt("HDSD00.13.065")
			//病史陈述者姓名	AN..50	
			s medihisrelatorname = arr.GetAt("HDSD00.13.004")
			//入院途径代码	N1	必填
			;s inhosppathcode= ""
			//入院途径名称	AN..50	必填
			;s inhosppathname= ""
			//陈述者与患者的关系名称	AN..50	
			s patspeakerrelatename=  arr.GetAt("HDSD00.13.321")
			//陈述者与患者的关系代码	N..3	
			s patspeakerrelatecode = arr.GetAt("HDSD00.13.009")
			//陈述内容可靠标志	T/F	
			s statementreliablemark = arr.GetAt("HDSD00.13.008")
			//患者传染性标志	T/F	
			s infectivitymark = arr.GetAt("HDSD00.13.038")
			//辅助检查结果	AN..200	必填
			s assistcheckres = arr.GetAt("HDSD00.13.035")
			s:assistcheckres="" assistcheckres="-"
			//皮肤检查描述	AN..200	
			s skincheckres = arr.GetAt("HDSD00.13.081")
			//中医“四诊”观察结果	AN..1000	
			s fourtcmobservres = arr.GetAt("HDSD00.13.112")
			//治则治法	AN..1000	
			s therapeutictreat = arr.GetAt("HDSD00.13.111")
			//呼吸频率(次/min)	N..6	必填
			s breatherate =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"breath")  //arr.GetAt("HDSD00.13.077")
			//脉率(次/min)	N2..6	必填
			s pulserate =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"pulse") //arr.GetAt("HDSD00.13.080")
			//身高(cm)	N4..5,1	必填
			s height =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"height") // arr.GetAt("HDSD00.13.083")
			i height="" s height="-"
			//收缩压(mmHg)	N2..6	必填
			s sbp =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"sysPressure") // arr.GetAt("HDSD00.13.085")
			//舒张压(mmHg)	N2..6	必填
			s dbp =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"diaPressure") // arr.GetAt("HDSD00.13.086")
			//体温(℃)	N4,1	必填
			s bodytemperat =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"temperature") // arr.GetAt("HDSD00.13.088")
			//体重(kg)	N3..9,2	必填
			s weight =##Class(Nur.CommonInterface.Temperature).getFirstItemValue(AEpisodeID,"weight") //arr.GetAt("HDSD00.13.089")
			s:weight="" weight="-"
			//一般健康状况标志	T/F	必填
			s healthcasemark ="1" //arr.GetAt("HDSD00.13.104")
			//一般状况检查结果	AN..2000	必填
			s generalcheckres = arr.GetAt("HDSD00.13.094")
			i generalcheckres="" s generalcheckres="无"
			//腹部检查结果	AN..2000	
			s abdominalcheckres = arr.GetAt("HDSD00.13.075")
			//肛门指诊检查结果描述	AN..200	
			s anuscheckresdescr = arr.GetAt("HDSD00.13.076")
			//脊柱检查结果	AN..200	
			s spineaZBormcheckres = arr.GetAt("HDSD00.13.078")
			//皮肤和黏膜检查结果	AN..200	
			s skinmucosacheckres = arr.GetAt("HDSD00.13.081")
			//四肢检查结果	AN..200	
			s limbscheckres = arr.GetAt("HDSD00.13.087")
			//外生殖器检查结果描述	AN..200	
			s aedeacheckres = arr.GetAt("HDSD00.13.092")
			//颈部检查结果	AN..200	
			s neckcheckres = arr.GetAt("HDSD00.13.079")
			//头部及其器官检查结果	AN..200	
			s headcheckres = arr.GetAt("HDSD00.13.091")
			//神经系统检查结果	AN..200	
			s physmentalcheckres = arr.GetAt("HDSD00.13.084")
			//全身浅表淋巴结检查结果	AN..200	
			s lymphcheckresdescr = arr.GetAt("HDSD00.13.082")
			//体格检查--胸部检查结果	AN..200	
			s chestcheckres = arr.GetAt("HDSD00.13.093")
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
			continue:patientname=""
			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,
											ageday,maritalcode,maritalname,nationcode,nationname,occupname,occupcode,tcmmark,diagno,departno,
											departname,medirecno,hospitalno,bedno,roomno,wardname,inhosptime,acceptdoctno,acceptdoctname,chiefdoctname,
											chiefdoctno,maindoctname,maindoctno,inhospdoctname,inhospdoctno,chiefcomplaint,nowdishis,pastdishis,personhis,maritalhis,
											menseshis,familyhis,infecthis,vacchis,transfusebloodhis,allergichis,prochis,medihisrelatorname,inhosppathcode,inhosppathname,
											patspeakerrelatename,patspeakerrelatecode,statementreliablemark,infectivitymark,assistcheckres,skincheckres,fourtcmobservres,therapeutictreat,breatherate,pulserate,
											height,sbp,dbp,bodytemperat,weight,healthcasemark,generalcheckres,abdominalcheckres,anuscheckresdescr,spineaZBormcheckres,
											skinmucosacheckres,limbscheckres,aedeacheckres,neckcheckres,headcheckres,physmentalcheckres,lymphcheckresdescr,chestcheckres,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod InHospitalRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InHospitalRecordExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod InHospitalRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InHospitalRecordExecute ]
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

/// 6.6.1.1入院记录_诊断（t_inhosp_diag）
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","InHospitalRecordDiag","2019-03-05","2019-03-05")
Query InHospitalRecordDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,inhosp_name,inhosp_code,is_tcm_diag,diag_name_type_code,diag_name_type_name,diag_name,diag_code,diag_time,diag_doct_name,diag_doct_no,upload_time") [ SqlProc ]
{
}

ClassMethod InHospitalRecordDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GetErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRow
    Quit $$$OK
OutputRow
    s i=""
    f  s i=$o(^CacheTMP("InHospitalRecordDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("InHospitalRecordDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s inhospname       =$p(data,"^",3)
    .s inhospcode       =$p(data,"^",4)
    .s istcmdiag        =$p(data,"^",5)
    .s diagnametypecode =$p(data,"^",6)
    .s diagnametypename =$p(data,"^",7)
    .s diagcodedn       =$p(data,"^",8)
    .s diagcode         =$p(data,"^",9)
    .s diagtime         =$p(data,"^",10)
    .s diagdoctname     =$p(data,"^",11)
    .s diagdoctno       =$p(data,"^",12)
    .s uploadtime       =$p(data,"^",13)


	.s data = $lb(businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("InHospitalRecordDiag",ret)
    q
}

ClassMethod InHospitalRecordDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InHospitalRecordDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod InHospitalRecordDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InHospitalRecordDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.1.2入院记录_中医证候（t_inhosp_tcm_sympt）
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","InHospitalRecordtcmDiag","2019-03-05","2019-03-05")
Query InHospitalRecordtcmDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,sympt_tcm_name,sympt_tcm_code,diag_time,upload_time") [ SqlProc ]
{
}

ClassMethod InHospitalRecordtcmDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GettmcErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRowtcm
    Quit $$$OK
OutputRowtcm
    s i=""
    f  s i=$o(^CacheTMP("InHospitalRecordtcmDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("InHospitalRecordtcmDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s sympttcmname     =$p(data,"^",3)
    .s sympttcmcode     =$p(data,"^",4)
    .s diagtime         =$p(data,"^",5)
    .s uploadtime       =$p(data,"^",6)


	.s data = $lb(businessno,dataid,sympttcmname,sympttcmcode,diagtime,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("InHospitalRecordtcmDiag",ret)
    q
}

ClassMethod InHospitalRecordtcmDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InHospitalRecordtcmDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod InHospitalRecordtcmDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InHospitalRecordtcmDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.2出院记录_基本信息（t_outhosp）
/// Creator:    tx
/// CreateDate: 2019-5-22	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_touthosp("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","touthosp","2015-12-05","2015-12-05")
Query touthosp(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,marital_code,marital_name,nation_code,nation_name,tcm_mark,whether_guaran_patients,medi_rec_no,main_doct_name,main_doct_no,chief_doct_name,chief_doct_no,diag_no,hospital_no,bed_no,room_no,ward_name,depart_no,depart_name,super_doct_no,super_doct_name,inhosp_doct_name,inhosp_doct_no,sign_time,positive_auxiliary_res,treat_res_name,treat_res_code,treat_process_descr,fact_hospital_day,inhosp_time,inhosp_case,outhosp_time,doct_ad,outhosp_case,outhosp_sympt_descr,therapeutic_treat,drug_use_tcm_way,tcm_medi_decoction_method,upload_time") [ SqlProc ]
{
}

ClassMethod touthospExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.16"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,maritalcode,maritalname,nationcode,nationname,tcmmark,whetherguaranpatients,medirecno,maindoctname,maindoctno,chiefdoctname,chiefdoctno,diagno,hospitalno,bedno,roomno,wardname,departno,departname,superdoctno,superdoctname,inhospdoctname,inhospdoctno,signtime,positiveauxiliaryres,treatresname,treatrescode,treatprocessdescr,facthospitalday,inhosptime,inhospcase,outhosptime,doctad,outhospcase,outhospsymptdescr,therapeutictreat,drugusetcmway,tcmmedidecoctionmethod,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
 			s ageyear=..GetAgeyear(AEpisodeID)
 			s agemonth=..GetAgemonth(AEpisodeID)
 			s ageday=..GetAgeday(AEpisodeID)
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname = arr.GetAt("HDSD00.16.019")
			q:(patientname="")
			//性别代码	N1	必填
			s strgendercode = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.124","HDSD00.12")
			s gendercode = $case(arr.GetAt("HDSD00.16.041"),"":strgendercode,:arr.GetAt("HDSD00.16.041"))
			//性别名称	AN..20	必填
			s strgendername = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.586","HDSD00.12")
			s gendername = strgendername
			//婚姻状况代码 N2..5 有则必填 
			s maritalcode= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.057","HDSD00.12")
			//婚姻状况名称 AN..50 有则必填
			s maritalname = ..Getmaritalname(maritalcode)
			//民族代码 N2..5 有则必填 
			s nationcode= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.088","HDSD00.12")
			//民族名称 AN..50 有则必填
			s nationname= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.590","HDSD00.12")
			//中医标志 T/F 必填
			s tcmmark ="1"
			//是否医保患者
			s whetherguaranpatients = ..Getwhetherguaranpatients(AEpisodeID)
			//病案号 AN..36 必填
			s medirecno =##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PAPMIDR,"I","") //住院病案号
			//主治医师签名 AN..50	必填
			s maindoctname= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.165","HDSD00.12")
			s:maindoctname="" maindoctname="-"
			//主治医师编号 AN..64	必填
			s maindoctno= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.577","HDSD00.12")
			//主任医师签名 AN..50	必填
			s chiefdoctname= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.164","HDSD00.12")
			s:chiefdoctname="" chiefdoctname="-"
			//主任医师编号 AN..64	必填
			s chiefdoctno= ""
			//就诊流水号	AN..32	必填
			s diagno =$p(^PAADM(AEpisodeID),"^",81)
			//住院号	AN..32	必填
			s strhospitalno=$p(^PAADM(AEpisodeID),"^",81) 
			s hospitalno= $case(arr.GetAt("HDSD00.16.052"),"":strhospitalno,:arr.GetAt("HDSD00.16.052"))
			//病床号	AN..64	必填		    
	        s bedno =..GetBedno(AEpisodeID)        
			//病房号	AN..30	必填
			s roomno =..GetRoomno(AEpisodeID)
			//病区名称	AN..100	必填
			s wardname =..GetWardName(AEpisodeID)
		
			//科室编号	AN..64	有则必填
			
			s departno=..Getdepartno(AEpisodeID)
			//科室名称	AN..100	有则必填
			s departname=..Getdepartname(AEpisodeID)
			
			//上级医师编号	AN..64	必填
			s superdoctno= "-"
			//上级医师签名	AN..50	必填
			s superdoctname="-" //arr.GetAt("HDSD00.16.035")
			//住院医师签名	AN..50	有则必填
			s inhospdoctname= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.168","HDSD00.12")
			s:inhospdoctname="" inhospdoctname="-"
			//住院医师编号	AN..64	有则必填
			s inhospdoctno= ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.578","HDSD00.12")
			//签名日期时间	DT15	必填
			s signtime=$zd(+$h,3)  //arr.GetAt("HDSD00.16.028")
			//阳性辅助检查结果	AN..2000	有则必填
			s positiveauxiliaryres= arr.GetAt("HDSD00.16.042")
			//治疗结果名称	AN..1000	必填
			s treatresname = ..Gettreatresname(AEpisodeID)
			//治疗结果代码	N1..4	必填
			s treatrescode = ..Gettreatrescode(AEpisodeID)
			//诊疗过程描述	AN..2000	必填
			s treatprocessdescr= arr.GetAt("HDSD00.16.045")
			//实际住院天数	N..7	必填
			s facthospitalday=$p(^PAADM(AEpisodeID),"^",17)-$p(^PAADM(AEpisodeID),"^",6)
			//入院日期时间	DT15	必填
			s inhosptime= $zd($p(^PAADM(AEpisodeID),"^",6),3)_" "_ $zt($p(^PAADM(AEpisodeID),"^",7),1)
			//入院情况	AN..200	必填
			s inhospcase= arr.GetAt("HDSD00.16.030")
			//出院日期时间	DT15	必填
			s outhosptime= $zd($p(^PAADM(AEpisodeID),"^",17),3)_" "_ $zt($p(^PAADM(AEpisodeID),"^",18),1)
			//出院医嘱	AN..200	必填
			s doctad= arr.GetAt("HDSD00.16.007")
			s:doctad="" doctad="-"
			//出院情况	AN..200	必填
			s outhospcase= arr.GetAt("HDSD00.16.004")
			s:outhospcase="" outhospcase="-"
			//出院时症状与体征	AN..200	有则必填
			s outhospsymptdescr= arr.GetAt("HDSD00.16.006")
			//治则治法	AN..1000	有则必填
			s therapeutictreat= arr.GetAt("HDSD00.16.048")
			//中药用药方法	AN..100	有则必填
			s drugusetcmway= arr.GetAt("HDSD00.16.050")
			//中药煎煮方法	AN..100	有则必填
			s tcmmedidecoctionmethod= arr.GetAt("HDSD00.16.049")
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,maritalcode,maritalname,nationcode,nationname,tcmmark,whetherguaranpatients,medirecno,maindoctname,maindoctno,chiefdoctname,chiefdoctno,diagno,hospitalno,bedno,roomno,wardname,departno,departname,superdoctno,superdoctname,inhospdoctname,inhospdoctno,signtime,positiveauxiliaryres,treatresname,treatrescode,treatprocessdescr,facthospitalday,inhosptime,inhospcase,outhosptime,doctad,outhospcase,outhospsymptdescr,therapeutictreat,drugusetcmway,tcmmedidecoctionmethod,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod touthospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = touthospExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod touthospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = touthospExecute ]
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

/// 6.6.2.1出院记录_诊断（t_outhosp_diag）
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","outhosDiag","2019-03-05","2019-03-05")
Query outhosDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,inhosp_name,inhosp_code,is_tcm_diag,diag_name_type_code,diag_name_type_name,diag_name,diag_code,diag_time,diag_doct_name,diag_doct_no,upload_time") [ SqlProc ]
{
}

ClassMethod outhosDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GetErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRowouthosDiag
    Quit $$$OK
OutputRowouthosDiag
    s i=""
    f  s i=$o(^CacheTMP("InHospitalRecordDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("InHospitalRecordDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s inhospname       =$p(data,"^",3)
    .s inhospcode       =$p(data,"^",4)
    .s istcmdiag        =$p(data,"^",5)
    .s diagnametypecode =$p(data,"^",6)
    .s diagnametypename =$p(data,"^",7)
    .s diagcodedn       =$p(data,"^",8)
    .s diagcode         =$p(data,"^",9)
    .s diagtime         =$p(data,"^",10)
    .s diagdoctname     =$p(data,"^",11)
    .s diagdoctno       =$p(data,"^",12)
    .s uploadtime       =$p(data,"^",13)


	.s data = $lb(businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("InHospitalRecordDiag",ret)
    q
}

ClassMethod outhosDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = outhosDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod outhosDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = outhosDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.2.2出院记录_中医证候（t_outhosp_tcm_sympt）
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","outhostcmDiag","2019-03-05","2019-03-05")
Query outhostcmDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,sympt_tcm_name,sympt_tcm_code,diag_time,upload_time") [ SqlProc ]
{
}

ClassMethod outhostcmDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GettmcErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRowouthostcmDiag
    Quit $$$OK
OutputRowouthostcmDiag
    s i=""
    f  s i=$o(^CacheTMP("InHospitalRecordtcmDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("InHospitalRecordtcmDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s sympttcmname     =$p(data,"^",3)
    .s sympttcmcode     =$p(data,"^",4)
    .s diagtime         =$p(data,"^",5)
    .s uploadtime       =$p(data,"^",6)


	.s data = $lb(businessno,dataid,sympttcmname,sympttcmcode,diagtime,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("InHospitalRecordtcmDiag",ret)
    q
}

ClassMethod outhostcmDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = outhostcmDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod outhostcmDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = outhostcmDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.2.3出院记录_手术操作（t_outhosp_proc）
/// Creator:    yejian
/// CreateDate: 2019-5-9	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_touthospproc("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","touthospproc","2015-12-05","2015-12-05")
Query touthospproc(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,proc_start_time,observ_res,proc_course,proc_cut_union_class_name,proc_cut_union_class_code,anaes_way_code,anaes_way_name,proc_code,proc_name,proc_cut_type_name,proc_cut_type_code,upload_time") [ SqlProc ]
{
}

ClassMethod touthospprocExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.06.02"
	s (businessno,dataid,procstarttime,observres,proccourse,proccutunionclassname,proccutunionclasscode,anaeswaycode,anaeswayname,proccode,procname,proccuttypename,proccuttypecode,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s arrIns=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据主键	AN..64	必填
			s dataid = AEpisodeID
			s key =""
			for {
				s key = arrIns.Next(key)
				q:(key = "")
				s arr = arrIns.GetAt(key)
				//麻醉观察结果	AN..2000	必填
				s observres = "无"
				//手术及操作编码	AN..20	必填
				s proccode = arr.GetAt("HDSD00.06.074")
				//continue:(proccode="")
				//手术及操作名称	AN..100	必填
				s procname = arr.GetAt("HDSD00.06.079")
				
				//手术及操作开始时间	DT15	必填
				s procstarttime=arr.GetAt("HDSD00.06.078")
				s:procstarttime="" procstarttime="-"
				//手术切口类别代码	N..2	必填
				s proccuttypecode = arr.GetAt("HDSD00.06.075")
				
				//切口愈合等级代码	N..2	必填
				s proccutunionclasscode = ""
				
				//切口愈合等级名称	AN..100	必填
				s proccutunionclassname = ""
				
				//麻醉方法代码	N..5	必填
				s anaeswaycode = arr.GetAt("HDSD00.06.044")
				
				//麻醉方法名称	AN..50	必填
				s anaeswayname = arr.GetAt("HDSD00.06.309")
				
				//手术切口类别名称	AN..20	必填
				s proccuttypename = arr.GetAt("HDSD00.06.081")
				
				//手术过程	AN..1000	必填
				s proccourse =arr.GetAt("HDSD00.06.073")
				s:proccourse="" proccourse="-"
				
				//数据采集时间	DT15	必填
				s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
				s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
				continue:procname=""

				set ^CacheTemp(repid, ind) = $LB(businessno,dataid,procstarttime,observres,proccourse,
												proccutunionclassname,proccutunionclasscode,anaeswaycode,anaeswayname,proccode,
												procname,proccuttypename,proccuttypecode,uploadtime)
				set ind = ind + 1
			}
		}
	}
	Quit $$$OK
}

ClassMethod touthospprocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = touthospprocExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod touthospprocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = touthospprocExecute ]
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

/// 6.6.4.2中医住院病案首页_手术操作（t_tcm_inmedi_proc）
/// Creator:    yejian
/// CreateDate: 2019-5-9	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_ttcminmediproc("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","ttcminmediproc","2019-03-05","2019-03-10")
Query ttcminmediproc(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,proc_code,proc_name,proc_time,proc_level_code,proc_level_name,operator_no,operator_name,assist1_no,assist1_name,oassist2_no,oassist2_name,proc_cut_type_code,proc_cut_type_name,proc_cut_union_class_code,proc_cut_union_class_name,anaes_doct_no,anaes_doct_name,anaes_way_code,anaes_way_name,operator_pre_diag_code,operator_pre_diag_name,operator_after_diag_code,operator_after_diag_name,upload_time") [ SqlProc ]
{
}

ClassMethod ttcminmediprocExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.12"
	s (businessno,dataid,proccode,procname,proctime,proclevelcode,proclevelname,operatorno,operatorname,assist1no,assist1name,oassist2no,oassist2name,proccuttypecode,proccuttypename,proccutunionclasscode,proccutunionclassname,anaesdoctno,anaesdoctname,anaeswaycode,anaeswayname,operatorprediagcode,operatorprediagname,operatorafterdiagcode,operatorafterdiagname,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据主键	AN..64	必填
			//s dataid = AEpisodeID
			set OperStr=##class(DHCWMR.IO.OutService).IGetFrontPageICDAll(AEpisodeID,"O")
			Set OperLen =$L(OperStr,$c(1))
			s j=0
			for i=1:1:OperLen {
				Set OperItem=$P(OperStr,$c(1),i)
				Continue:OperItem=""
			    //数据主键	AN..64	必填
			    s dataid = AEpisodeID_"_"_$p(OperItem,$c(2),1)_"_"_proctime_"_"_j
			    s j=j+1
				//手术及操作编码	AN..20	必填
				Set proccode=$p(OperItem,$c(2),1)
				continue:(proccode="")
				
				//手术及操作名称	AN..100	必填
				Set procname=$p(OperItem,$c(2),2)
				
				//手术及操作日期时间	DT15	必填
				s proctime  = $p(OperItem,$c(2),3)
				
				//手术切口类别代码	N..2	必填
				s proccuttypecode =$p(OperItem,$c(2),6)
				s:proccuttypecode="/" proccuttypecode=""
				
				//切口愈合等级代码	N..2	必填
				s proccutunionclasscode = $p(OperItem,$c(2),6)
				s:proccutunionclasscode="/" proccutunionclasscode=""
				
				//切口愈合等级名称	AN..100	必填
				s proccutunionclassname = $p(OperItem,$c(2),7)
				s:proccutunionclassname="/" proccutunionclassname=""
				
				//麻醉方法代码	N..5	必填
				s anaeswaycode = $p(OperItem,$c(2),10)

				//麻醉方法名称	AN..50	必填
				s anaeswayname = $p(OperItem,$c(2),11)

				//手术切口类别名称	AN..100	
				s proccuttypename = $p(OperItem,$c(2),7)
				s:proccuttypename="/" proccuttypename=""
							
				//手术级别代码	AN..20	必填
				s proclevelcode = $p(OperItem,$c(2),19)

				//手术级别名称	AN..100	必填
				s proclevelname = $p(OperItem,$c(2),20)
					
				//手术者编码	AN..32	必填
				s operatorno = $p(OperItem,$c(2),8)
				s:operatorno="" operatorno="-"

				//手术者姓名	AN..50	必填
				s operatorname = $p(OperItem,$c(2),9)

				//Ⅰ助编码	AN..32	必填
				s assist1no = $p(OperItem,$c(2),13)

				//Ⅰ助姓名	AN..50	必填
				s assist1name = $p(OperItem,$c(2),14)

				//Ⅱ助编码	AN..32	必填
				s oassist2no = $p(OperItem,$c(2),15)

				//Ⅱ助姓名	AN..50	必填
				s oassist2name = $p(OperItem,$c(2),16)

				//麻醉医师编码	AN..100	
				s anaesdoctno = $p(OperItem,$c(2),17)
				//麻醉医师姓名	AN..50	
				s anaesdoctname = $p(OperItem,$c(2),18)
				//术前诊断编码	AN..20	必填
				s operatorprediagcode = "" //arr.GetAt("HDSD00.12.777")
				s:operatorprediagcode="" operatorprediagcode="-"
				//术前诊断名称	AN..100	必填
				s operatorprediagname = arr.GetAt("HDSD00.12.777")
				//术后诊断代码	AN..20	必填
				s operatorafterdiagcode ="" // arr.GetAt("HDSD00.12.777")
				//术后诊断名称	AN..100	必填
				s operatorafterdiagname = arr.GetAt("HDSD00.12.777")
				//数据采集时间	DT15	必填
				s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
				s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
				
			
				
				set ^CacheTemp(repid, ind) = $LB(businessno,dataid,proccode,procname,proctime,proclevelcode,proclevelname,operatorno,operatorname,assist1no,
												assist1name,oassist2no,oassist2name,proccuttypecode,proccuttypename,proccutunionclasscode,proccutunionclassname,anaesdoctno,anaesdoctname,anaeswaycode,
												anaeswayname,operatorprediagcode,operatorprediagname,operatorafterdiagcode,operatorafterdiagname,uploadtime)
				set ind = ind + 1
			}
		}
	}
	Quit $$$OK
}

ClassMethod ttcminmediprocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ttcminmediprocExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod ttcminmediprocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ttcminmediprocExecute ]
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

/// 6.6.4中医住院病案首页_基本信息（t_tcm_inhosp_medi_rec）
/// Creator:    yejian
/// CreateDate: 2019-5-17	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_ttcminhospmedirec("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","ttcminhospmedirec","2015-12-05","2015-12-05")
Query ttcminhospmedirec(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,diag_no,patient_name,gender_code,gender_name,age_year,age_month,age_day,birth_date,card_type_code,card_type_name,card_value,inhosp_times,inhosp_day,preo_inhosp_day,id_card_type_code,id_card_type_name,id_card_value,nationality_code,nationality_name,nation_code,nation_name,marital_code,marital_name,occup_code,occup_name,work_place_name,work_place_telephone,work_place_detail,work_addr_state,work_addr_city,work_addr_county,work_addr_town,work_addr_street,work_addr_house_number,work_addr_postalcode,telephone,contactor_name,contactor_type_code,contactor_type_name,contactor_telephone,contactor_place_detail,contactor_addr_state,contactor_addr_city,contactor_addr_county,contactor_addr_town,contactor_addr_street,contactor_addr_house_number,contactor_addr_postalcode,newborn_birth_weight,newborn_inhosp_weight,birth_addr_detail,brith_addr_state,brith_addr_city,brith_addr_county,brith_addr_postalcode,birth_place_detail,birth_place_state,birth_place_city,now_addr_detail,now_addr_state,now_addr_city,now_addr_county,now_addr_town,now_addr_street,now_addr_house_number,now_addr_postalcode,account_addr_detail,account_addr_state,account_addr_city,account_addr_county,account_addr_town,account_addr_street,account_addr_house_number,account_addr_postalcode,inhosp_time,inhosp_path_code,inhosp_path_name,inhosp_depart_code,inhosp_depart_name,inhosp_ward_name,inhosp_room_no,inhosp_bed_no,inhosp_code,inhosp_name,admission_situation_code,admission_situation_name,treat_res_code,treat_res_name,outhosp_time,outhosp_depart_code,outhosp_depart_name,outhosp_ward_name,outhosp_room_no,outhosp_bed_no,transfer_depart,transfer_reason,transfuse_variety_code,transfuse_variety_name,transfuse_blood_num,transfuse_blood_unit,transfuse_reaction_type_code,transfuse_reaction_type_name,case_conform_code,case2_conform_code,case3_conform_code,case4_conform_code,case5_conform_code,three_days_conf_diagnosis,nosocomial_infection,nosocomial_infection_name,infect_mark,infect_his,dead_pat_autopsy_mark,drug_allergic_his_mark,allergic_symptom_date,allergic_drug_code,allergic_drug_name,abo_code,abo_name,rh_code,rh_name,leave_hospital_way_code,leave_hospital_way_name,plan_accept_org_code,plan_accept_org_name,outhosp_day31_again_mark,outhosp_day31_again_aim,inhosp_pat_rescue_times,inhosp_pat_rescue_success_times,rescue_solution,intensive_care_case,intensive_care_name,enter_intensive_care_time,quit_intensive_care_time,intensive_care_name2,enter_intensive_care_time2,quit_intensive_care_time2,craniocereb_before_coma_day,craniocereb_before_coma_hour,craniocereb_before_coma_min,craniocereb_after_coma_day,craniocereb_after_coma_hour,craniocereb_after_coma_min,impl_clin_path_markcode,impl_clin_path_markname,med_org_medic_mark,tmc_treat_equip_mark,tmc_treat_techno_mark,dialectical_care_mark,inhosp_critical_mark,treatment_category_code,treatment_category_name,resi_disease_status_code,resi_disease_status_name,death_time,medi_rec_quality_code,medi_rec_quality_name,qcdate_time,quality_doct_no,quality_doct_name,quality_nurse_no,quality_nurse_name,depart_chief_doct_no,depart_chief_doct_name,chief_doct_no,chief_doct_name,ain_doct_no,ain_doct_name,inhosp_doct_no,inhosp_doct_name,duty_nurse_no,duty_nurse_name,refresher_doct_no,refresher_doct_name,intern_doct_no,intern_doct_name,coder_name,upload_time") [ SqlProc ]
{
}

ClassMethod ttcminhospmedirecExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.12"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,diagno,patientname,gendercode,gendername,ageyear,agemonth,ageday,birthdate,cardtypecode,cardtypename,cardvalue,inhosptimes,inhospday,preoinhospday,idcardtypecode,idcardtypename,idcardvalue,nationalitycode,nationalityname,nationcode,nationname,maritalcode,maritalname,occupcode,occupname,workplacename,workplacetelephone,workplacedetail,workaddrstate,workaddrcity,workaddrcounty,workaddrtown,workaddrstreet,workaddrhousenumber,workaddrpostalcode,telephone,contactorname,contactortypecode,contactortypename,contactortelephone,contactorplacedetail,contactoraddrstate,contactoraddrcity,contactoraddrcounty,contactoraddrtown,contactoraddrstreet,contactoraddrhousenumber,contactoraddrpostalcode,newbornbirthweight,newborninhospweight,birthaddrdetail,brithaddrstate,brithaddrcity,brithaddrcounty,brithaddrpostalcode,birthplacedetail,birthplacestate,birthplacecity,nowaddrdetail,nowaddrstate,nowaddrcity,nowaddrcounty,nowaddrtown,nowaddrstreet,nowaddrhousenumber,nowaddrpostalcode,accountaddrdetail,accountaddrstate)=""
	s (accountaddrcity,accountaddrcounty,accountaddrtown,accountaddrstreet,accountaddrhousenumber,accountaddrpostalcode,inhosptime,inhosppathcode,inhosppathname,inhospdepartcode,inhospdepartname,inhospwardname,inhosproomno,inhospbedno,inhospcode,inhospname,admissionsituationcode,admissionsituationname,treatrescode,treatresname,outhosptime,outhospdepartcode,outhospdepartname,outhospwardname,outhosproomno,outhospbedno,transferdepart,transferreason,transfusevarietycode,transfusevarietyname,transfusebloodnum,transfusebloodunit,transfusereactiontypecode,transfusereactiontypename,caseconformcode,case2conformcode,case3conformcode,case4conformcode,case5conformcode,threedaysconfdiagnosis,nosocomialinfection,nosocomialinfectionname,infectmark,infecthis,deadpatautopsymark,drugallergichismark,allergicsymptomdate,allergicdrugcode,allergicdrugname,abocode,aboname,rhcode,rhname,leavehospitalwaycode,leavehospitalwayname,planacceptorgcode,planacceptorgname,outhospday31againmark,outhospday31againaim,inhosppatrescuetimes,inhosppatrescuesuccesstimes,rescuesolution,intensivecarecase,intensivecarename,enterintensivecaretime,quitintensivecaretime,intensivecarename2,enterintensivecaretime2,quitintensivecaretime2,craniocerebbeforecomaday,craniocerebbeforecomahour,craniocerebbeforecomamin,craniocerebaftercomaday,craniocerebaftercomahour,craniocerebaftercomamin,implclinpathmarkcode,implclinpathmarkname,medorgmedicmark,tmctreatequipmark,tmctreattechnomark,dialecticalcaremark,inhospcriticalmark,treatmentcategorycode,treatmentcategoryname,residiseasestatuscode,residiseasestatusname,deathtime,medirecqualitycode,medirecqualityname,qcdatetime,qualitydoctno,qualitydoctname,qualitynurseno,qualitynursename,departchiefdoctno,departchiefdoctname,chiefdoctno,chiefdoctname,aindoctno,aindoctname,inhospdoctno,inhospdoctname,dutynurseno,dutynursename,refresherdoctno,refresherdoctname,interndoctno,interndoctname,codername,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//就诊流水号
			s diagno= $p(^PAADM(AEpisodeID),"^",81)
			//患者姓名	AN..50	必填
			s patientname= arr.GetAt("HDSD00.12.125")
			q:patientname=""
			//性别代码
			s gendercode= arr.GetAt("HDSD00.12.124")
			//性别名称
			s gendername= arr.GetAt("HDSD00.12.586")
			//年龄(岁)
			s ageyear=  arr.GetAt("HDSD00.12.091")
			//年龄(月)
			s agemonth= arr.GetAt("HDSD00.12.092")
			//年龄(天)
			s ageday= arr.GetAt("HDSD00.12.807")
			//出生日期
			s birthdate= arr.GetAt("HDSD00.12.015")
			//就诊卡类型代码
			s cardtypecode= ""
			//就诊卡类型名称
			s cardtypename= ""
			//就诊卡号码
			s cardvalue= ""
			//住院次数
			s inhosptimes= arr.GetAt("HDSD00.12.166")
			//住院天数
			s inhospday= arr.GetAt("HDSD00.12.098")
			//术前住院天数
			s preoinhospday= ""
			//证件类别代码
			s idcardtypecode="01" //arr.GetAt("HDSD00.12.056")
			//证件类别名称
			s idcardtypename= "居民身份证"
			//证件号码
			s idcardvalue= arr.GetAt("HDSD00.12.055")
			//国籍代码
			s nationalitycode= arr.GetAt("HDSD00.12.043")
			//国籍名称
			s nationalityname= arr.GetAt("HDSD00.12.563")
			//婚姻状况代码
			s maritalcode= arr.GetAt("HDSD00.12.057")
			//婚姻状况名称
			s maritalname = ..Getmaritalname(maritalcode)
			
			//s maritalname= arr.GetAt("HDSD00.12.587")
			//民族代码
			s nationcode= arr.GetAt("HDSD00.12.088")
			//民族名称
			s nationname= arr.GetAt("HDSD00.12.590")
			//职业类别代码
			s occupcode= arr.GetAt("HDSD00.12.140")
			s:occupcode="" occupcode="90"
			//职业类别名称
			s occupname= arr.GetAt("HDSD00.12.564")
			s:occupname="" occupname="其他"
			//工作单位名称
			s workplacename= arr.GetAt("HDSD00.12.036")
			//工作单位电话号码
			s workplacetelephone= arr.GetAt("HDSD00.12.041")
			//工作单位地址-全
			s workplacedetail= arr.GetAt("HDSD00.12.1191")
			//工作单位地址-省(自治区、直辖市)
			s workaddrstate="" //arr.GetAt("HDSD00.12.036")
			//工作单位地址-市(地区、州)
			s workaddrcity= "" //arr.GetAt("HDSD00.12.027")
			//工作单位地址-县(区)
			s workaddrcounty= arr.GetAt("HDSD00.12.038")
			//工作单位地址-乡(镇、街道办事处)
			s workaddrtown= arr.GetAt("HDSD00.12.039")
			//工作单位地址-村(街、路、弄等)
			s workaddrstreet= arr.GetAt("HDSD00.12.034")
			//工作单位地址-门牌号码
			s workaddrhousenumber= arr.GetAt("HDSD00.12.035")
			//工作单位地址-邮政编码
			s workaddrpostalcode= arr.GetAt("HDSD00.12.040")
			//电话号码
			s telephone= arr.GetAt("HDSD00.12.033")
			//联系人姓名
			s contactorname= arr.GetAt("HDSD00.12.072")
			//联系人关系代码
			s contactortypecode= arr.GetAt("HDSD00.12.073")
			//联系人关系名称
			s contactortypename= arr.GetAt("HDSD00.12.562")
			//联系人电话号码
			s contactortelephone=  arr.GetAt("HDSD00.12.071")
			//联系人地址-全
			s contactorplacedetail=  arr.GetAt("HDSD00.12.565")
			//联系人地址-省(自治区、直辖市)
			s contactoraddrstate="" //arr.GetAt("HDSD00.12.067")
			//联系人地址-市(地区、州)
			s contactoraddrcity=  arr.GetAt("HDSD00.12.068")
			//联系人地址-县(区)
			s contactoraddrcounty=  arr.GetAt("HDSD00.12.069")
			//联系人地址-乡(镇、街道办事处)
			s contactoraddrtown= arr.GetAt("HDSD00.12.070")
			//联系人地址-村(街、路、弄等)
			s contactoraddrstreet= arr.GetAt("HDSD00.12.065")
			//联系人地址-门牌号码
			s contactoraddrhousenumber= arr.GetAt("HDSD00.12.066")
			//联系人地址-邮政编码
			s contactoraddrpostalcode= ""
			//新生儿出生体重(g)
			s newbornbirthweight= arr.GetAt("HDSD00.12.122")
			//新生儿入院体重(g)
			s newborninhospweight= arr.GetAt("HDSD00.12.123")
			//出生地址-全
			s birthaddrdetail= arr.GetAt("HDSD00.12.012")_" "_arr.GetAt("HDSD00.12.013")_" "_arr.GetAt("HDSD00.12.014")
			//出生地-省(自治区、直辖市)
			s brithaddrstate= arr.GetAt("HDSD00.12.012")
			//出生地-市(地区、州)
			s brithaddrcity= arr.GetAt("HDSD00.12.013")
			//出生地-县(区)
			s brithaddrcounty= arr.GetAt("HDSD00.12.014")
			//出生地址-邮政编码
			s brithaddrpostalcode= ""
			//籍贯地址-全
			s birthplacedetail= arr.GetAt("HDSD00.12.058")_" "_arr.GetAt("HDSD00.12.059")
			//籍贯-省(自治区、直辖市)
			s birthplacestate= arr.GetAt("HDSD00.12.058")
			//籍贯-市(地区、州)
			s birthplacecity= arr.GetAt("HDSD00.12.059")
			//现住地址-全
			s nowaddrdetail= arr.GetAt("HDSD00.12.115")
			//现住址址-省(自治区、直辖市)
			s nowaddrstate= arr.GetAt("HDSD00.12.117")
			//现住址-市(地区、州)
			s nowaddrcity= arr.GetAt("HDSD00.12.118")
			//现住址-县(区)
			s nowaddrcounty= arr.GetAt("HDSD00.12.119")
			//现住址-乡(镇、街道办事处)
			s nowaddrtown= arr.GetAt("HDSD00.12.120")
			//现住址-村(街、路、弄等)
			s nowaddrstreet= arr.GetAt("HDSD00.12.115")
			//现住址-门牌号码
			s nowaddrhousenumber= arr.GetAt("HDSD00.12.116")
			//现住地址-邮政编码
			s nowaddrpostalcode= arr.GetAt("HDSD00.12.121")
			//户口地址-全
			s accountaddrdetail= arr.GetAt("HDSD00.12.1229")
			//户口地址-省(自治区、直辖市)
			s accountaddrstate= arr.GetAt("HDSD00.12.050")
			//户口地址-市(地区、州)
			s accountaddrcity= arr.GetAt("HDSD00.12.051")
			//户口地址-县(区)
			s accountaddrcounty= arr.GetAt("HDSD00.12.052")
			//户口地址-乡(镇、街道办事处)
			s accountaddrtown= arr.GetAt("HDSD00.12.053")
			//户口地址-村(街、路、弄等)
			s accountaddrstreet= arr.GetAt("HDSD00.12.048")
			//户口地址-门牌号码
			s accountaddrhousenumber= arr.GetAt("HDSD00.12.049")
			//户口地址-邮政编码
			s accountaddrpostalcode= arr.GetAt("HDSD00.12.054")
			//入院日期时间
			s inhosptime= arr.GetAt("HDSD00.12.096")
			//入院途径代码
			s inhosppathcode= arr.GetAt("HDSD00.12.097")
			//入院途径名称
			s inhosppathname= arr.GetAt("HDSD00.12.591")			 
			//入院科室代码
			s departdr=$p(^PAADM(AEpisodeID),"^",4)
			s inhospdepartcode= $case(arr.GetAt("HDSD00.12.1004"),"":$p($g(^CTLOC(departdr)),"^",1),:arr.GetAt("HDSD00.12.1004"))
			//入院科室名称
			s inhospdepartname= $case(arr.GetAt("HDSD00.12.095"),"":$p($g(^CTLOC(departdr)),"^",1),:arr.GetAt("HDSD00.12.095"))
			//入院病区名称
			s inhospwardname= ..GetWardName(AEpisodeID)
			//入院病房号
			s strroomno=..GetRoomno(AEpisodeID)
			s inhosproomno= $case(arr.GetAt("HDSD00.12.094"),"":strroomno,:arr.GetAt("HDSD00.12.094"))
			//入院床号
			s inhospbedno= ..GetBedno(AEpisodeID)
			//入院病情代码
			s inhospcode="" //arr.GetAt("HDSD00.12.027")
			//入院病情名称
			s inhospname="" //arr.GetAt("HDSD00.12.028")
			//治疗结果代码
			s treatrescode= ""
			//治疗结果名称
			s treatresname= ""
			//出院日期时间
			s outhosptime= arr.GetAt("HDSD00.12.020")
			//出院科室代码
			s strDept = ##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
			s outhospdepartcode= $p(strDept,"^",2)
			//出院科室名称
			s outhospdepartname= $p(strDept,"^",3)
			//出院病区名称
			s outhospwardname= arr.GetAt("HDSD00.12.018") //..GetWardName(AEpisodeID)
			//出院病房号
			s outhosproomno= arr.GetAt("HDSD00.12.018")
			//出院床号
			s outhospbedno= "" //..GetBedno(AEpisodeID)
			//转科科别
			s transferdepart= arr.GetAt("HDSD00.12.171")
			//转科原因
			s transferreason= ""
			//患者传染性标志
			s infectmark= ""
			//传染病史
			s infecthis= ""
			//死亡患者尸检标志
			s deadpatautopsymark= arr.GetAt("HDSD00.12.110")
			//药物过敏史标志
			s drugallergichismark= arr.GetAt("HDSD00.12.131")
			s:drugallergichismark="无" drugallergichismark=1
			s:drugallergichismark="有" drugallergichismark=2
			//过敏症状出现日期
			s allergicsymptomdate= ""
			//药物过敏源代码
			s allergicdrugcode="" //arr.GetAt("HDSD00.12.044")
			//药物过敏源名称
			s allergicdrugname=arr.GetAt("HDSD00.12.044")
			//肿瘤T分期名称
			s tumorstagingt= arr.GetAt("HDSD00.12.725")
			//肿瘤N分期名称
			s tumorstagingn= arr.GetAt("HDSD00.12.726")
			//肿瘤M分期名称
			s tumorstagingm= arr.GetAt("HDSD00.12.727")
			//ABO血型代码
			s abocode= arr.GetAt("HDSD00.12.003")
			//ABO血型名称
			s aboname= arr.GetAt("HDSD00.12.597")
			//Rh血型代码
			s rhcode=  arr.GetAt("HDSD00.12.004")
			//Rh血型名称
			s rhname=  arr.GetAt("HDSD00.12.598")
			s:rhname="阳" rhname="阳性"
			s:rhname="阴" rhname="阴性"
			//离院方式代码
			s leavehospitalwaycode= arr.GetAt("HDSD00.12.064")
			//离院方式名称
			s leavehospitalwayname= arr.GetAt("HDSD00.12.603")
			//拟接收医疗机构代码
			s planacceptorgcode= ""
			//拟接收医疗机构名称
			s planacceptorgname= arr.GetAt("HDSD00.12.089")
			//出院31天内再住院标志
			s outhospday31againmark= arr.GetAt("HDSD00.12.016")
			s:outhospday31againmark="无" outhospday31againmark="0"
			s:outhospday31againmark="有" outhospday31againmark="1"
			//出院31天内再住院目的
			s outhospday31againaim= arr.GetAt("HDSD00.12.017")
			//住院患者抢救次数
			s inhosppatrescuetimes= arr.GetAt("HDSD00.12.569")
			//住院患者抢救成功次数
			s inhosppatrescuesuccesstimes=arr.GetAt("HDSD00.12.570")
			//抢救措施
			s rescuesolution= ""
			//有无重症监护
			s intensivecarecase="1"  //arr.GetAt("HDSD00.12.1036")
			//重症监护室名称1
			s intensivecarename= arr.GetAt("HDSD00.12.546")
			//进入重症监护室时间1
			s enterintensivecaretime= arr.GetAt("HDSD00.12.547")
			//退出重症监护室时间1
			s quitintensivecaretime= arr.GetAt("HDSD00.12.548")
			//重症监护室名称2
			s intensivecarename2= arr.GetAt("HDSD00.12.549")
			//进入重症监护室时间2
			s enterintensivecaretime2= arr.GetAt("HDSD00.12.550")
			//退出重症监护室时间2
			s quitintensivecaretime2= arr.GetAt("HDSD00.12.551")
			//颅脑损伤患者入院前昏迷时间-d
			s craniocerebbeforecomaday= arr.GetAt("HDSD00.12.077")
			//颅脑损伤患者入院前昏迷时间-h
			s craniocerebbeforecomahour= arr.GetAt("HDSD00.12.078")
			//颅脑损伤患者入院前昏迷时间-min
			s craniocerebbeforecomamin= arr.GetAt("HDSD00.12.079")
			//颅脑损伤患者入院后昏迷时间-d
			s craniocerebaftercomaday= arr.GetAt("HDSD00.12.074")
			//颅脑损伤患者入院后昏迷时间-h
			s craniocerebaftercomahour= arr.GetAt("HDSD00.12.075")
			//颅脑损伤患者入院后昏迷时间-min
			s craniocerebaftercomamin= arr.GetAt("HDSD00.12.076")
			//实施临床路径标志代码
			s implclinpathmarkcode= arr.GetAt("HDSD00.12.099")
			s:implclinpathmarkcode="中" implclinpathmarkcode="1"
			s:implclinpathmarkcode="西" implclinpathmarkcode="2"
			s:implclinpathmarkcode="否" implclinpathmarkcode="3"
			s:implclinpathmarkcode="" implclinpathmarkcode="3"
			//实施临床路径标志名称
			s implclinpathmarkname= arr.GetAt("HDSD00.12.1016")
			s:implclinpathmarkname="" implclinpathmarkname="否"
			//住院期间危重标识
			s inhospcriticalmark= arr.GetAt("HDSD00.12.567")
			//住院者疾病状态代码
			s residiseasestatuscode= ""
			//住院者疾病状态名称
			s residiseasestatusname=""
			//诊断符合情况代码
			s diagmatchcode=arr.GetAt("HDSD00.12.818")
			//诊断符合情况名称
			s diagmatchname=arr.GetAt("HDSD00.12.817")
			//死亡日期时间
			s deathtime= ""
			//病案质量代码
			s medirecqualitycode= arr.GetAt("HDSD00.12.008")
			//病案质量名称
			s medirecqualityname= arr.GetAt("HDSD00.12.899")
			//质控日期时间
			s qcdatetime= arr.GetAt("HDSD00.12.142")
			//质控医师编码
			s qualitydoctno= arr.GetAt("HDSD00.12.583")
			//质控医师姓名
			s qualitydoctname= arr.GetAt("HDSD00.12.143")
			//质控护士编码
			s qualitynurseno=  arr.GetAt("HDSD00.12.584")
			//质控护士姓名
			s qualitynursename= arr.GetAt("HDSD00.12.141")
			//科主任编码
			s departchiefdoctno= arr.GetAt("HDSD00.12.575")
			//科主任姓名
			s departchiefdoctname= arr.GetAt("HDSD00.12.063")
			s:departchiefdoctname="" departchiefdoctname="-"
			//主任医师编码
			s chiefdoctno= arr.GetAt("HDSD00.12.576")
			//主任医师姓名
			s chiefdoctname= arr.GetAt("HDSD00.12.164")
			s:chiefdoctname="" chiefdoctname="-"
			//主治医师编码
			s aindoctno=arr.GetAt("HDSD00.12.577")
			//主治医师姓名
			s aindoctname= arr.GetAt("HDSD00.12.165")
			s:aindoctname="" aindoctname="-"
			//住院医师编码
			s inhospdoctno= arr.GetAt("HDSD00.12.578")
			//住院医师姓名
			s inhospdoctname= arr.GetAt("HDSD00.12.168")
			s:inhospdoctname="" inhospdoctname="-"
			//责任护士编码
			s dutynurseno= arr.GetAt("HDSD00.12.579")
			//责任护士姓名
			s dutynursename= arr.GetAt("HDSD00.12.135")
			s:dutynursename="" dutynursename="-"
			//进修医师编码
			s refresherdoctno= arr.GetAt("HDSD00.12.580")
			//进修医师姓名
			s refresherdoctname= arr.GetAt("HDSD00.12.061")
			//实习医师编码
			s interndoctno= arr.GetAt("HDSD00.12.581")
			//实习医师姓名
			s interndoctname= arr.GetAt("HDSD00.12.100")
			//编码员姓名
			s codername= arr.GetAt("HDSD00.12.005")
			//-------
			//入院时情况代码	AN..20
			s admissionsituationcode =""     //arr.GetAt("HDSD00.12.883")
			//入院时情况名称	AN..100
			s admissionsituationname ="" //arr.GetAt("HDSD00.12.884")
			//输血品种代码	AN..2
			s transfusevarietycode =arr.GetAt("HDSD00.12.898")
			//输血品种名称	AN..100
			s transfusevarietyname = arr.GetAt("HDSD00.12.897")
			//输血量	N..4
			s transfusebloodnum = arr.GetAt("HDSD00.12.999")
			//输血量计量单位	AN..10
			s transfusebloodunit = ""
			//输血反应类型代码	AN..20
			s transfusereactiontypecode = arr.GetAt("HDSD00.12.601")
			//输血反应类型名称	AN..100
			s transfusereactiontypename = arr.GetAt("HDSD00.12.602")
			//诊断符合情况1	AN..2
			s caseconformcode ="1" //arr.GetAt("HDSD00.12.964")
			//诊断符合情况2	AN..2
			s case2conformcode ="1" //arr.GetAt("HDSD00.12.963")
			//诊断符合情况3	AN..2
			s case3conformcode ="1" //arr.GetAt("HDSD00.12.2034")
			//诊断符合情况4	AN..2
			s case4conformcode ="1"  //arr.GetAt("HDSD00.12.2037")
			//诊断符合情况5	AN..2
			s case5conformcode ="1"  //arr.GetAt("HDSD00.12.2038")
			//是否3日内确诊	AN..3
			s threedaysconfdiagnosis = ""
			//医院感染名称	AN..200
			s nosocomialinfectionname ="" //arr.GetAt("HDSD00.12.843")
			//是否院内感染	AN..3
			s nosocomialinfection = "" //strnosocomialinfection
			//使用医疗机构中药制剂标志	AN..3
			s medorgmedicmark = arr.GetAt("HDSD00.12.101")
			s:medorgmedicmark="是" medorgmedicmark="1"
			s:medorgmedicmark="否" medorgmedicmark="0"
			s:medorgmedicmark="" medorgmedicmark="0"
			//使用中医诊疗设备标志	AN..3
			s tmctreatequipmark = arr.GetAt("HDSD00.12.103")
			s:tmctreatequipmark="是" tmctreatequipmark="1"
			s:tmctreatequipmark="否" tmctreatequipmark="0"
			s:tmctreatequipmark="" tmctreatequipmark="0"
			//使用中医诊疗技术标志	AN..3
			s tmctreattechnomark = arr.GetAt("HDSD00.12.102")
			s:tmctreattechnomark="是" tmctreattechnomark="1"
			s:tmctreattechnomark="否" tmctreattechnomark="0"
			s:tmctreattechnomark="" tmctreattechnomark="0"
			//辨证施护标志	AN..3
			s dialecticalcaremark = arr.GetAt("HDSD00.12.2074")
			s:dialecticalcaremark="" dialecticalcaremark="-"
			//治疗类别代码	AN..20
			s treatmentcategorycode = arr.GetAt("HDSD00.12.144")
			s:treatmentcategorycode="中医" treatmentcategorycode="1"
			s:treatmentcategorycode="中西医" treatmentcategorycode="2"
			s:treatmentcategorycode="西医" treatmentcategorycode="3"
			s:treatmentcategorycode="" treatmentcategorycode="2"
			//治疗类别名称	AN..100
			s:treatmentcategorycode="1" treatmentcategoryname = "中医"
			s:treatmentcategorycode="2" treatmentcategoryname = "中西医"
			s:treatmentcategorycode="3" treatmentcategoryname = "西医"
			s:treatmentcategorycode="" treatmentcategorycode="中西医"
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,diagno,patientname,gendercode,gendername,ageyear,
			agemonth,ageday,birthdate,cardtypecode,cardtypename,cardvalue,inhosptimes,inhospday,preoinhospday,idcardtypecode,idcardtypename,
			idcardvalue,nationalitycode,nationalityname,nationcode,nationname,maritalcode,maritalname,occupcode,occupname,workplacename,
			workplacetelephone,workplacedetail,workaddrstate,workaddrcity,workaddrcounty,workaddrtown,workaddrstreet,workaddrhousenumber,
			workaddrpostalcode,telephone,contactorname,contactortypecode,contactortypename,contactortelephone,contactorplacedetail,
			contactoraddrstate,contactoraddrcity,contactoraddrcounty,contactoraddrtown,contactoraddrstreet,contactoraddrhousenumber,
			contactoraddrpostalcode,newbornbirthweight,newborninhospweight,birthaddrdetail,brithaddrstate,brithaddrcity,brithaddrcounty,
			brithaddrpostalcode,birthplacedetail,birthplacestate,birthplacecity,nowaddrdetail,nowaddrstate,nowaddrcity,nowaddrcounty,
			nowaddrtown,nowaddrstreet,nowaddrhousenumber,nowaddrpostalcode,accountaddrdetail,accountaddrstate,accountaddrcity,accountaddrcounty,
			accountaddrtown,accountaddrstreet,accountaddrhousenumber,accountaddrpostalcode,inhosptime,inhosppathcode,inhosppathname,inhospdepartcode,
			inhospdepartname,inhospwardname,inhosproomno,inhospbedno,inhospcode,inhospname,admissionsituationcode,admissionsituationname,treatrescode,
			treatresname,outhosptime,outhospdepartcode,outhospdepartname,outhospwardname,outhosproomno,outhospbedno,transferdepart,transferreason,
			transfusevarietycode,transfusevarietyname,transfusebloodnum,transfusebloodunit,transfusereactiontypecode,transfusereactiontypename,
			caseconformcode,case2conformcode,case3conformcode,case4conformcode,case5conformcode,threedaysconfdiagnosis,nosocomialinfection,
			nosocomialinfectionname,infectmark,infecthis,deadpatautopsymark,drugallergichismark,allergicsymptomdate,allergicdrugcode,allergicdrugname,
			abocode,aboname,rhcode,rhname,leavehospitalwaycode,leavehospitalwayname,planacceptorgcode,planacceptorgname,outhospday31againmark,
			outhospday31againaim,inhosppatrescuetimes,inhosppatrescuesuccesstimes,rescuesolution,intensivecarecase,intensivecarename,
			enterintensivecaretime,quitintensivecaretime,intensivecarename2,enterintensivecaretime2,quitintensivecaretime2,craniocerebbeforecomaday,
			craniocerebbeforecomahour,craniocerebbeforecomamin,craniocerebaftercomaday,craniocerebaftercomahour,craniocerebaftercomamin,
			implclinpathmarkcode,implclinpathmarkname,medorgmedicmark,tmctreatequipmark,tmctreattechnomark,dialecticalcaremark,inhospcriticalmark,
			treatmentcategorycode,treatmentcategoryname,residiseasestatuscode,residiseasestatusname,deathtime,medirecqualitycode,medirecqualityname,
			qcdatetime,qualitydoctno,qualitydoctname,qualitynurseno,qualitynursename,departchiefdoctno,departchiefdoctname,chiefdoctno,chiefdoctname,
			aindoctno,aindoctname,inhospdoctno,inhospdoctname,dutynurseno,dutynursename,refresherdoctno,refresherdoctname,interndoctno,interndoctname,codername,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod ttcminhospmedirecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ttcminhospmedirecExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod ttcminhospmedirecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ttcminhospmedirecExecute ]
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

/// 6.6.12首次病程记录_基本信息（t_first_dis_course）
/// Creator:    yejian
/// CreateDate: 2019-5-17	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_tfirstdiscourse("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","tfirstdiscourse","2015-12-05","2015-12-05")
Query tfirstdiscourse(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,tcm_mark,diag_no,hospital_no,bed_no,room_no,ward_name,depart_no,depart_name,super_doct_no,super_doct_name,inhosp_doct_name,inhosp_doct_no,rec_fill_out_time,chief_complaint,four_tcm_observ_res,case_feature,diag_accord,treat_plan,therapeutic_treat,upload_time") [ SqlProc ]
{
}

ClassMethod tfirstdiscourseExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.14.01"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,tcmmark,diagno,hospitalno,bedno,roomno,wardname,departno,departname,superdoctno,superdoctname,inhospdoctname,inhospdoctno,recfillouttime,chiefcomplaint,fourtcmobservres,casefeature,diagaccord,treatplan,therapeutictreat,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s departdr=$p(^PAADM(AEpisodeID),"^",4)
			s departno=$p($g(^CTLOC(departdr)),"^",1)  //科室代码
			s departname=$p($g(^CTLOC(departdr)),"^",1) //科室名称
			s CurrentWardDR=$p(^PAADM(AEpisodeID),"^",70)
	        s:CurrentWardDR'="" wardname=$p(^PAWARD(CurrentWardDR),"^",2)  //病区名称
	        s CurrentRoomDR=$p(^PAADM(AEpisodeID),"^",69)
		    s roomno=""
	        i CurrentRoomDR'="" d
	        .s roomno=$p(^PAROOM(CurrentRoomDR),"^")  //病房号
	        s:roomno="" roomno="-"
	        s CurrentBedDR=$p(^PAADM(AEpisodeID),"^",73)
			s bedno=""
	        i CurrentBedDR'="" d
	        .s bedno=$p($g(^PAWARD($p(CurrentBedDR,"||"),"BED",$p(CurrentBedDR,"||",2))),"^") //病床号 
	        s:bedno="" bedno="-"
			s AdmDocCodeDR=$p(^PAADM(AEpisodeID),"^",9)
	        s acceptdoctname="",acceptdoctno=""
	        i AdmDocCodeDR'="" d
	        .s acceptdoctno=$p(^CTPCP(AdmDocCodeDR,1),"^") //接诊医生编号 
	        .s acceptdoctname=$p(^CTPCP(AdmDocCodeDR,1),"^",2)  //接诊医生签名
	        s medirecno=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(argPapmiDR,"I","") //住院病案号
	        s hospitalno=$p(^PAADM(AEpisodeID),"^",81) //住院号
	        s inhosppath=##class(web.DHCENS.Method.Query.InHospRegister).GetAdmSource(AEpisodeID) 
		    s inhosppathcode=$p($g(inhosppath),"^",1)
	        s inhosppathname=$p($g(inhosppath),"^",2)
	        i inhosppathcode="" s inhosppathcode="9" s inhosppathname="门诊"
			
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname= arr.GetAt("HDSD00.14.030")
			q:(patientname="")
			//性别代码	N1	必填
			s gendercode= arr.GetAt("HDSD00.14.115")
			//性别名称	AN..20	必填
			s gendername= arr.GetAt("HDSD00.14.306")
			//年龄(岁)	N1..3	
			s ageyear= arr.GetAt("HDSD00.14.074")
			//年龄(月)	N1..2	
			s agemonth= arr.GetAt("HDSD00.14.075")
			//年龄(天)	N1..2	
			s ageday= arr.GetAt("HDSD00.14.303")
			//中医标志	T/F	必填
			s tcmmark= "1"
			//就诊流水号	AN..32	必填
			s diagno= $p(^PAADM(AEpisodeID),"^",81)
			//住院号	AN..36	必填
			;s hospitalno = arr.GetAt("HDSD00.14.140")
			//病床号	AN..64	必填
			s bedno = ..GetBedno(AEpisodeID)
			//病房号	AN..30	必填
			s roomno = ..GetRoomno(AEpisodeID)
			//病区名称	AN..100	必填
			s wardname =..GetWardName(AEpisodeID)
			
			//科室编号	AN..64	必填
			s strdepartno=..Getdepartno(AEpisodeID)
			s departno= $case(arr.GetAt("HDSD00.14.307"),"":strdepartno,:arr.GetAt("HDSD00.14.307"))
			//科室名称	AN..100	必填
			s strdepartname=..Getdepartname(AEpisodeID)
			s departname = $case(arr.GetAt("HDSD00.14.062"),"":strdepartname,:arr.GetAt("HDSD00.14.062"))
			//上级医师编号	AN..64	必填
			s superdoctno= $case(arr.GetAt("HDSD00.14.330"),"":"-",:arr.GetAt("HDSD00.14.330"))
			//上级医师签名	AN..50	必填
			s superdoctname =$case(arr.GetAt("HDSD00.14.086"),"":"-",:arr.GetAt("HDSD00.14.086"))
			//住院医师签名	AN..50	必填
			s inhospdoctname = $case(arr.GetAt("HDSD00.14.141"),"":"-",:arr.GetAt("HDSD00.14.141"))
			//住院医师编号	AN..64	必填
			s inhospdoctno= $case(arr.GetAt("HDSD00.14.308"),"":"-",:arr.GetAt("HDSD00.14.308"))
			//记录日期时间	DT15	必填
			s recfillouttime = arr.GetAt("HDSD00.14.046")
			//主诉	AN..2000	有则必填
			s chiefcomplaint = arr.GetAt("HDSD00.14.137")
			//中医“四诊”观察结果	AN..1000	有则必填
			s fourtcmobservres = arr.GetAt("HDSD00.14.129")
			//病例特点	AN..2000	有则必填
			s casefeature = arr.GetAt("HDSD00.14.005")
			//诊断依据	AN..2000	有则必填
			s diagaccord = arr.GetAt("HDSD00.14.119")
			//诊疗计划	AN..2000	有则必填
			s treatplan = arr.GetAt("HDSD00.14.122")
			//治则治法	AN..1000	有则必填
			s therapeutictreat = arr.GetAt("HDSD00.14.125")
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,tcmmark,diagno,hospitalno,bedno,roomno,wardname,departno,departname,superdoctno,superdoctname,inhospdoctname,inhospdoctno,recfillouttime,chiefcomplaint,fourtcmobservres,casefeature,diagaccord,treatplan,therapeutictreat,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod tfirstdiscourseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = tfirstdiscourseExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod tfirstdiscourseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = tfirstdiscourseExecute ]
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

/// 6.6.11 24h内入出院记录_基本信息（t_iohosp_in24h）
/// Creator:    yejian
/// CreateDate: 2019-5-17	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_tiohospin24h("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","tiohospin24h","2015-12-05","2015-12-05")
Query tiohospin24h(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,tcm_mark,diag_no,marital_code,marital_name,nation_code,nation_name,occup_name,occup_code,medi_rec_no,hospital_no,bed_no,room_no,ward_name,accept_doct_no,accept_doct_name,chief_doct_name,chief_doct_no,main_doct_name,main_doct_no,inhosp_doct_name,inhosp_doct_no,chief_complaint,four_tcm_observ_res,therapeutic_treat,inhosp_time,depart_no,depart_name,inhosp_case,outhosp_time,outhosp_depart_name,outhosp_depart_no,outhosp_case,sympt_descr,treat_process_descr,now_dis_his,medi_his_relator_name,pat_speaker_relate_name,pat_speaker_relate_code,statement_reliable_mark,outhosp_doct_ad_time,outhosp_doct_ad_no,outhosp_doct_ad_name,outhosp_doct_ad,upload_time") [ SqlProc ]
{
}

ClassMethod tiohospin24hExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.13.02"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,tcmmark,diagno,maritalcode,maritalname,nationcode,nationname,occupname,occupcode,medirecno,hospitalno,bedno,roomno,wardname,acceptdoctno,acceptdoctname,chiefdoctname,chiefdoctno,maindoctname,maindoctno,inhospdoctname,inhospdoctno,chiefcomplaint,fourtcmobservres,therapeutictreat,inhosptime,departno,departname,inhospcase,outhosptime,outhospdepartname,outhospdepartno,outhospcase,symptdescr,treatprocessdescr,nowdishis,medihisrelatorname,patspeakerrelatename,patspeakerrelatecode,statementreliablemark,outhospdoctadtime,outhospdoctadno,outhospdoctadname,outhospdoctad,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s departdr=$p(^PAADM(AEpisodeID),"^",4)
			s departno=$p($g(^CTLOC(departdr)),"^",1)  //科室代码
			s departname=$p($g(^CTLOC(departdr)),"^",1) //科室名称
			s CurrentWardDR=$p(^PAADM(AEpisodeID),"^",70)
	        s:CurrentWardDR'="" wardname=$p(^PAWARD(CurrentWardDR),"^",2)  //病区名称
	        s CurrentRoomDR=$p(^PAADM(AEpisodeID),"^",69)
		    s roomno=""
	        i CurrentRoomDR'="" d
	        .s roomno=$p(^PAROOM(CurrentRoomDR),"^")  //病房号
	        s:roomno="" roomno="-"
	        s CurrentBedDR=$p(^PAADM(AEpisodeID),"^",73)
			s bedno=""
	        i CurrentBedDR'="" d
	        .s bedno=$p($g(^PAWARD($p(CurrentBedDR,"||"),"BED",$p(CurrentBedDR,"||",2))),"^") //病床号 
	        s:bedno="" bedno="-"
			s AdmDocCodeDR=$p(^PAADM(AEpisodeID),"^",9)
	        s acceptdoctname="",acceptdoctno=""
	        i AdmDocCodeDR'="" d
	        .s acceptdoctno=$p(^CTPCP(AdmDocCodeDR,1),"^") //接诊医生编号 
	        .s acceptdoctname=$p(^CTPCP(AdmDocCodeDR,1),"^",2)  //接诊医生签名
	        s medirecno=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(argPapmiDR,"I","") //住院病案号
	        s hospitalno=$p(^PAADM(AEpisodeID),"^",81) //住院号
	        s inhosppath=##class(web.DHCENS.Method.Query.InHospRegister).GetAdmSource(AEpisodeID) 
		    s inhosppathcode=$p($g(inhosppath),"^",1)
	        s inhosppathname=$p($g(inhosppath),"^",2)
	        i inhosppathcode="" s inhosppathcode="9" s inhosppathname="门诊"
			
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname= arr.GetAt("HDSD00.13.039")
			q:patientname=""
			//性别代码	N1	必填
			s gendercode= arr.GetAt("HDSD00.13.096")
			//性别名称	AN..20	必填
			s gendername= arr.GetAt("HDSD00.13.318")
			//年龄(岁)	N1..3	
			s ageyear= arr.GetAt("HDSD00.13.047")
			//年龄(月)	N1..2	
			s agemonth= arr.GetAt("HDSD00.13.048")
			//年龄(天)	N1..2	
			s ageday= arr.GetAt("HDSD00.13.316")
			//中医标志	T/F	必填
			s tcmmark= "1"
			//就诊流水号	AN..32	必填
			s diagno= $p(^PAADM(AEpisodeID),"^",81)
			
			//婚姻状况代码	N2	必填
			s maritalcode = arr.GetAt("HDSD00.13.040")
			//婚姻状况名称	AN..20	必填
			s maritalname= arr.GetAt("HDSD00.13.324")
			//民族代码	N2	必填
			s nationcode = arr.GetAt("HDSD00.13.046")
			//民族名称	AN..20	必填
			s nationname= arr.GetAt("HDSD00.13.325")
			//职业类别名称	AN..50	必填
			s occupname= arr.GetAt("HDSD00.13.327")
			s:occupname="" occupname="其他"
			//职业类别代码	AN..30	必填
			s occupcode = arr.GetAt("HDSD00.13.110")
			s:occupcode="" occupcode="90"
			//病案号	AN..32	必填
			s medirecno=..Getmedirecno(AEpisodeID) 
			//住院号	AN..32	必填
			;s hospitalno=$p(^PAADM(AEpisodeID),"^",81)
			//病床号	AN..64	必填
	        ;s bedno=..GetBedno(AEpisodeID)
			//病房号	AN..30	必填
	        ;s roomno=..GetRoomno(AEpisodeID)
			//病区名称	AN..100	必填
 			;S wardname=..GetWardName(AEpisodeID)
	        //接诊医师编号	AN..64	
	        ;s strDoc = ##Class(EPRservice.HISInterface.PatientInfoAssist).MainDoc(AEpisodeID)
	        ;s acceptdoctno=..Getacceptdoctno(AEpisodeID)
			//接诊医师签名	AN..50	
			;s acceptdoctname=..Getacceptdoctname(AEpisodeID)
			//主任医师签名	AN..50	必填
			s chiefdoctname =$case(arr.GetAt("HDSD00.13.113"),"":"-",:arr.GetAt("HDSD00.13.113")) //arr.GetAt("HDSD00.13.113")
			//主任医师编号	AN..64	必填
			s chiefdoctno= $case(arr.GetAt("HDSD00.13.317"),"":"-",:arr.GetAt("HDSD00.13.317")) //arr.GetAt("HDSD00.13.317")
			//主治医师签名	AN..50	必填
			s maindoctname = $case(arr.GetAt("HDSD00.13.115"),"":"-",:arr.GetAt("HDSD00.13.115")) //arr.GetAt("HDSD00.13.115")
			//主治医师编号	AN..64	必填
			s maindoctno= $case(arr.GetAt("HDSD00.13.323"),"":"-",:arr.GetAt("HDSD00.13.323")) //arr.GetAt("HDSD00.13.323")
			//住院医师签名	AN..50	必填
			s inhospdoctname = $case(arr.GetAt("HDSD00.13.322"),"":"-",:arr.GetAt("HDSD00.13.322")) //arr.GetAt("HDSD00.13.322")
			//住院医师编号	AN..64	必填
			s inhospdoctno = $case(arr.GetAt("HDSD00.13.117"),"":"-",:arr.GetAt("HDSD00.13.117")) //arr.GetAt("HDSD00.13.322")
			//主诉	AN..100	必填
			s chiefcomplaint = arr.GetAt("HDSD00.13.114")
			//中医“四诊”观察结果	AN..1000	
			s fourtcmobservres = arr.GetAt("HDSD00.13.112")
			//治则治法	AN..1000	
			s therapeutictreat = arr.GetAt("HDSD00.13.111")
			//入院日期时间	DT15	必填
			s inhosptime = arr.GetAt("HDSD00.13.057")
			//入院科室编号	AN..20	必填
			s departno=..Getdepartno(AEpisodeID)
			//入院科室名称	AN..50	必填
			s departname=..Getdepartname(AEpisodeID)
			//入院情况	AN..2000	必填
			s inhospcase = arr.GetAt("HDSD00.13.056")
			//出院日期时间	DT15	必填
			s outhosptime = arr.GetAt("HDSD00.13.011")
			//出院科室名称	AN..100	必填
			s outhospdepartname = ""
			//出院科室编号	AN..64	必填
			s outhospdepartno = ""
			//出院情况	AN..2000	有则必填
			s outhospcase = arr.GetAt("HDSD00.13.010")
			//症状描述	AN..2000	有则必填
			s symptdescr = arr.GetAt("HDSD00.13.108")
			//诊疗过程描述	AN..2000	有则必填
			s treatprocessdescr = arr.GetAt("HDSD00.13.107")
			//现病史	AN..2000	有则必填
			s nowdishis = arr.GetAt("HDSD00.13.095")
			//病史陈述者姓名	AN..50	有则必填
			s medihisrelatorname = arr.GetAt("HDSD00.13.004")
			//陈述者与患者的关系名称	AN..50	有则必填
			s patspeakerrelatename = ""
			//陈述者与患者的关系代码	N..3	有则必填
			s patspeakerrelatecode = arr.GetAt("HDSD00.13.009")
			//陈述内容可靠标志	T/F	有则必填
			s statementreliablemark = arr.GetAt("HDSD00.13.008")
			//出院医嘱开立时间	DT15	必填
			s outhospdoctadtime = arr.GetAt("HDSD00.13.014")
			//出院医嘱开立人编号	AN..64	必填
			s outhospdoctadno = arr.GetAt("HDSD00.13.013")
			//出院医嘱开立人签名	AN..50	必填
			s outhospdoctadname = arr.GetAt("HDSD00.13.013")
			//出院医嘱	AN..2000	必填
			s outhospdoctad = arr.GetAt("HDSD00.13.012")
			
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,tcmmark,diagno,maritalcode,maritalname,nationcode,nationname,occupname,occupcode,medirecno,hospitalno,bedno,roomno,wardname,acceptdoctno,acceptdoctname,chiefdoctname,chiefdoctno,maindoctname,maindoctno,inhospdoctname,inhospdoctno,chiefcomplaint,fourtcmobservres,therapeutictreat,inhosptime,departno,departname,inhospcase,outhosptime,outhospdepartname,outhospdepartno,outhospcase,symptdescr,treatprocessdescr,nowdishis,medihisrelatorname,patspeakerrelatename,patspeakerrelatecode,statementreliablemark,outhospdoctadtime,outhospdoctadno,outhospdoctadname,outhospdoctad,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod tiohospin24hClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = tiohospin24hExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod tiohospin24hFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = tiohospin24hExecute ]
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

/// 死亡记录_基本信息(t_death_record)
/// Creator:    yejian
/// CreateDate: 2019-5-17	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_tdeathrecord("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","tdeathrecord","2015-12-05","2015-12-05")
Query tdeathrecord(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,diag_type_code,diag_type_name,diag_no,hospital_no,room_no,bed_no,ward_name,depart_no,depart_name,chief_doct_name,chief_doct_no,chief_doct_name_time,main_doct_name,main_doct_no,main_doct_name_time,inhosp_doct_name,inhosp_doct_no,inhosp_doct_name_time,inhosp_time,death_time,inhosp_case,treat_process_descr,autopsy_family_agree_mark,dire_death_reason_code,dire_death_reason_name,upload_time") [ SqlProc ]
{
}

ClassMethod tdeathrecordExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.14.14"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,diagtypecode,diagtypename,diagno,hospitalno,roomno,bedno,wardname,departno,departname,chiefdoctname,chiefdoctno,chiefdoctnametime,maindoctname,maindoctno,maindoctnametime,inhospdoctname,inhospdoctno,inhospdoctnametime,inhosptime,deathtime,inhospcase,treatprocessdescr,autopsyfamilyagreemark,diredeathreasoncode,diredeathreasonname,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname = arr.GetAt("HDSD00.14.030")
			q:(patientname="")
			//性别代码	N1	必填
			s strgendercode = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.124","HDSD00.12")
			s gendercode = $case(arr.GetAt("HDSD00.14.115"),"":strgendercode,:arr.GetAt("HDSD00.14.115"))
			//性别名称	AN..20	必填
			s strgendername = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.586","HDSD00.12")
			s gendername = strgendername
			//年龄(岁)	N1..3	
			s ageyear ="" //..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.091","HDSD00.12")
			//年龄(月)	N1..2	
			s agemonth = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.092","HDSD00.12")
			//年龄(天)	N1..2	
			s ageday = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.807","HDSD00.12")
			//就诊类型代码	N1	必填
			s diagtypecode = $p(^PAADM(AEpisodeID),"^",2)
			//就诊类型名称	AN..10	必填
			s:diagtypecode="O" diagtypename="门诊"
			s:diagtypecode="E" diagtypename="急诊"
			s:diagtypecode="I" diagtypename="住院"
			//就诊流水号	AN..32	必填
			s diagno =$p(^PAADM(AEpisodeID),"^",81)
			//病案号	AN..32	必填
			s medirecno=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(argPapmiDR,"I","")
			//住院号	AN..32	必填
			s hospitalno=$p(^PAADM(AEpisodeID),"^",81) 
			//病床号	AN..64	必填
	        s bedno= ..GetBedno(AEpisodeID)
			//病房号	AN..30	必填
	        s roomno=..GetRoomno(AEpisodeID)
			//病区名称	AN..100	必填
 			S wardname= ..GetWardName(AEpisodeID)
	   
			//科室编号	AN..64	有则必填
			s departno=..Getdepartno(AEpisodeID)
			//科室名称	AN..100	有则必填
			s departname=..Getdepartname(AEpisodeID)
			//主任医师签名	AN..50	必填
			s chiefdoctname= $case(arr.GetAt("HDSD00.14.136"),"":"-",:arr.GetAt("HDSD00.14.136"))
			//主任医师编号	AN..64	必填
			s chiefdoctno = ""
			//主任医师签名时间	DT15	有则必填
			s chiefdoctnametime= arr.GetAt("HDSD00.14.076")
			//主治医师签名	AN..50	必填
			s maindoctname= arr.GetAt("HDSD00.14.138")
			s:maindoctname="" maindoctname="-"
			//主治医师编号	AN..64	必填
			s maindoctno = "-"
			//主治医师签名时间	DT15	有则必填
			s maindoctnametime= arr.GetAt("HDSD00.14.076")
			//住院医师签名	AN..50	有则必填
			s inhospdoctname= $case(arr.GetAt("HDSD00.14.141"),"":"-",:arr.GetAt("HDSD00.14.141"))
			//住院医师编号	AN..64	有则必填
			s inhospdoctno = ""
			//住院医师签名时间	DT15	有则必填
			s inhospdoctnametime= arr.GetAt("HDSD00.14.076")
			//入院时间	DT15	有则必填
			s inhosptime= arr.GetAt("HDSD00.14.081")
			//死亡时间	DT15	必填
			s deathtime= $zd(deathdate,3)
			//入院情况	AN..500	有则必填
			s inhospcase= arr.GetAt("HDSD00.14.080")
			//诊疗过程描述	AN..1000	有则必填
			s treatprocessdescr= arr.GetAt("HDSD00.14.120")
			//家属是否同意尸体解剖标志	T/F	有则必填
			s autopsyfamilyagreemark= arr.GetAt("HDSD00.14.047")
			//直接死亡原因编码	AN..50	必填
			s diredeathreasoncode="-" //arr.GetAt("HDSD00.14.123")
			//直接死亡原因名称	AN..100	必填
			s diredeathreasonname= arr.GetAt("HDSD00.14.107")
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,diagtypecode,diagtypename,diagno,hospitalno,roomno,bedno,wardname,departno,departname,chiefdoctname,chiefdoctno,chiefdoctnametime,maindoctname,maindoctno,maindoctnametime,inhospdoctname,inhospdoctno,inhospdoctnametime,inhosptime,deathtime,inhospcase,treatprocessdescr,autopsyfamilyagreemark,diredeathreasoncode,diredeathreasonname,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod tdeathrecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = tdeathrecordExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod tdeathrecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = tdeathrecordExecute ]
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

/// 6.6.9.1死亡记录_诊断(t_deathr_diag)
/// Creator:    tx
/// CreateDate: 2019-6-4	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","deathrDiag","2019-03-05","2019-03-05")
Query deathrDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,inhosp_name,inhosp_code,is_tcm_diag,diag_name_type_code,diag_name_type_name,diag_name,diag_code,diag_time,diag_doct_name,diag_doct_no,upload_time") [ SqlProc ]
{
}

ClassMethod deathrDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GetdeathDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRowouthosDiag
    Quit $$$OK
OutputRowouthosDiag
    s i=""
    f  s i=$o(^CacheTMP("DeathRecordDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("DeathRecordDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s inhospname       =$p(data,"^",3)
    .s inhospcode       =$p(data,"^",4)
    .s istcmdiag        =$p(data,"^",5)
    .s diagnametypecode =$p(data,"^",6)
    .s diagnametypename =$p(data,"^",7)
    .s diagcodedn       =$p(data,"^",8)
    .s diagcode         =$p(data,"^",9)
    .s diagtime         =$p(data,"^",10)
    .s diagdoctname     =$p(data,"^",11)
    .s diagdoctno       =$p(data,"^",12)
    .s uploadtime       =$p(data,"^",13)


	.s data = $lb(businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("DeathRecordDiag",ret)
    q
}

ClassMethod deathrDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = deathrDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod deathrDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = deathrDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.7出院小结_基本信息(t_outhosp_sum)
/// Creator:    yejian
/// CreateDate: 2019-5-17	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_touthospsum("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","touthospsum","2015-12-05","2015-12-05")
Query touthospsum(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,diag_no,hospital_no,bed_no,room_no,ward_name,depart_no,depart_name,super_doct_no,super_doct_name,inhosp_doct_name,inhosp_doct_no,sign_time,positive_auxiliary_res,treat_res_name,treat_res_code,treat_process_descr,fact_hospital_day,inhosp_time,inhosp_case,outhosp_time,doct_ad,outhosp_case,outhosp_sympt_descr,therapeutic_treat,drug_use_tcm_way,tcm_medi_decoction_method,upload_time") [ SqlProc ]
{
}

ClassMethod touthospsumExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.16"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,diagno,hospitalno,bedno,roomno,wardname,departno,departname,superdoctno,superdoctname,inhospdoctname,inhospdoctno,signtime,positiveauxiliaryres,treatresname,treatrescode,treatprocessdescr,facthospitalday,inhosptime,inhospcase,outhosptime,doctad,outhospcase,outhospsymptdescr,therapeutictreat,drugusetcmway,tcmmedidecoctionmethod,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
 			s ageyear=..GetAgeyear(AEpisodeID)
 			s agemonth=..GetAgemonth(AEpisodeID)
 			s ageday=..GetAgeday(AEpisodeID)
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname = arr.GetAt("HDSD00.16.019")
			q:(patientname="")
			//性别代码	N1	必填
			s strgendercode = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.124","HDSD00.12")
			s gendercode = $case(arr.GetAt("HDSD00.16.041"),"":strgendercode,:arr.GetAt("HDSD00.16.041"))
			//性别名称	AN..20	必填
			s strgendername = ..GetStdDataByGlossary(AEpisodeID,"HDSD00.12.586","HDSD00.12")
			s gendername = strgendername
	
			//就诊流水号	AN..32	必填
			s diagno =$p(^PAADM(AEpisodeID),"^",81)
			//住院号	AN..32	必填
			s strhospitalno=$p(^PAADM(AEpisodeID),"^",81) 
			s hospitalno= $case(arr.GetAt("HDSD00.16.052"),"":strhospitalno,:arr.GetAt("HDSD00.16.052"))
			//病床号	AN..64	必填		    
	        s bedno = ..GetBedno(AEpisodeID)	        
			//病房号	AN..30	必填
			s roomno = ..GetRoomno(AEpisodeID)
			//病区名称	AN..100	必填
			s wardname=..GetWardName(AEpisodeID)
			//科室编号	AN..64	有则必填
			s departno = ..Getdepartno(AEpisodeID)
			//科室名称	AN..100	有则必填
			s departname=..Getdepartname(AEpisodeID)
			
			//上级医师编号	AN..64	必填
			s superdoctno= "-"
			//上级医师签名	AN..50	必填
			s superdoctname="-" //arr.GetAt("HDSD00.16.035")
			//住院医师签名	AN..50	有则必填
			s inhospdoctname= $case(arr.GetAt("HDSD00.16.053"),"":"-",:arr.GetAt("HDSD00.16.053"))
			//住院医师编号	AN..64	有则必填
			s inhospdoctno = "-"
			//签名日期时间	DT15	必填
			s signtime=$zd(+$h,3)  //arr.GetAt("HDSD00.16.028")
			//阳性辅助检查结果	AN..2000	有则必填
			s positiveauxiliaryres= arr.GetAt("HDSD00.16.042")
			//治疗结果名称	AN..1000	必填
			s treatresname =..Gettreatresname(AEpisodeID)
			//治疗结果代码	N1..4	必填
			s treatrescode =..Gettreatrescode(AEpisodeID)
			//诊疗过程描述	AN..2000	必填
			s treatprocessdescr= arr.GetAt("HDSD00.16.045")
			s:treatprocessdescr="" treatprocessdescr="-"
			//实际住院天数	N..7	必填
			s facthospitalday=$p(^PAADM(AEpisodeID),"^",17)-$p(^PAADM(AEpisodeID),"^",6)
			//入院日期时间	DT15	必填
			s inhosptime= $zd($p(^PAADM(AEpisodeID),"^",6),3)_" "_ $zt($p(^PAADM(AEpisodeID),"^",7),1)
			//入院情况	AN..200	必填
			s inhospcase= arr.GetAt("HDSD00.16.030")
			//出院日期时间	DT15	必填
			s outhosptime= $zd($p(^PAADM(AEpisodeID),"^",17),3)_" "_ $zt($p(^PAADM(AEpisodeID),"^",18),1)
			//出院医嘱	AN..200	必填
			s doctad= arr.GetAt("HDSD00.16.007")
			s:doctad="" doctad="-"
			//出院情况	AN..200	必填
			s outhospcase= arr.GetAt("HDSD00.16.004")
			s:outhospcase="" outhospcase="-"
			//出院时症状与体征	AN..200	有则必填
			s outhospsymptdescr= arr.GetAt("HDSD00.16.006")
			//治则治法	AN..1000	有则必填
			s therapeutictreat= arr.GetAt("HDSD00.16.048")
			//中药用药方法	AN..100	有则必填
			s drugusetcmway= arr.GetAt("HDSD00.16.050")
			//中药煎煮方法	AN..100	有则必填
			s tcmmedidecoctionmethod= arr.GetAt("HDSD00.16.049")
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,diagno,hospitalno,bedno,roomno,wardname,departno,departname,superdoctno,superdoctname,inhospdoctname,inhospdoctno,signtime,positiveauxiliaryres,treatresname,treatrescode,treatprocessdescr,facthospitalday,inhosptime,inhospcase,outhosptime,doctad,outhospcase,outhospsymptdescr,therapeutictreat,drugusetcmway,tcmmedidecoctionmethod,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod touthospsumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = touthospsumExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod touthospsumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = touthospsumExecute ]
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

/// 6.6.7.1出院小结_诊断(t_outhossum_diag)
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","outhossumDiag","2019-03-05","2019-03-05")
Query outhossumDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,inhosp_name,inhosp_code,is_tcm_diag,diag_name_type_code,diag_name_type_name,diag_name,diag_code,diag_time,diag_doct_name,diag_doct_no,upload_time") [ SqlProc ]
{
}

ClassMethod outhossumDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GetErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRow
    Quit $$$OK
OutputRow
    s i=""
    f  s i=$o(^CacheTMP("InHospitalRecordDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("InHospitalRecordDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s inhospname       =$p(data,"^",3)
    .s inhospcode       =$p(data,"^",4)
    .s istcmdiag        =$p(data,"^",5)
    .s diagnametypecode =$p(data,"^",6)
    .s diagnametypename =$p(data,"^",7)
    .s diagcodedn       =$p(data,"^",8)
    .s diagcode         =$p(data,"^",9)
    .s diagtime         =$p(data,"^",10)
    .s diagdoctname     =$p(data,"^",11)
    .s diagdoctno       =$p(data,"^",12)
    .s uploadtime       =$p(data,"^",13)


	.s data = $lb(businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("InHospitalRecordDiag",ret)
    q
}

ClassMethod outhossumDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = outhossumDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod outhossumDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = outhossumDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.7.2出院小结_中医证候(t_outhossum_tcm_sympt)
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","outhossumtcmDiag","2019-03-05","2019-03-05")
Query outhossumtcmDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,sympt_tcm_name,sympt_tcm_code,diag_time,upload_time") [ SqlProc ]
{
}

ClassMethod outhossumtcmDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GettmcErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRowtcm
    Quit $$$OK
OutputRowtcm
    s i=""
    f  s i=$o(^CacheTMP("InHospitalRecordtcmDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("InHospitalRecordtcmDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s sympttcmname     =$p(data,"^",3)
    .s sympttcmcode     =$p(data,"^",4)
    .s diagtime         =$p(data,"^",5)
    .s uploadtime       =$p(data,"^",6)


	.s data = $lb(businessno,dataid,sympttcmname,sympttcmcode,diagtime,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("InHospitalRecordtcmDiag",ret)
    q
}

ClassMethod outhossumtcmDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = outhossumtcmDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod outhossumtcmDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = outhossumtcmDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.2.3出院小结_手术操作(t_outhossum_proc)
/// Creator:    yejian
/// CreateDate: 2019-5-9	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_touthossumproc("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","touthossumproc","2015-12-05","2015-12-05")
Query touthossumproc(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,proc_start_time,observ_res,proc_course,proc_cut_union_class_name,proc_cut_union_class_code,anaes_way_code,anaes_way_name,proc_code,proc_name,proc_cut_type_name,proc_cut_type_code,upload_time") [ SqlProc ]
{
}

ClassMethod touthossumprocExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.06.02"
	s (businessno,dataid,procstarttime,observres,proccourse,proccutunionclassname,proccutunionclasscode,anaeswaycode,anaeswayname,proccode,procname,proccuttypename,proccuttypecode,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s arrIns=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据主键	AN..64	必填
			s dataid = AEpisodeID
			s key =""
			for {
				s key = arrIns.Next(key)
				q:(key = "")
				s arr = arrIns.GetAt(key)
				//麻醉观察结果	AN..2000	必填
				s observres = "无"
				//手术及操作编码	AN..20	必填
				s proccode = arr.GetAt("HDSD00.06.074")
				//continue:(proccode="")
				//手术及操作名称	AN..100	必填
				s procname = arr.GetAt("HDSD00.06.079")
				
				//手术及操作开始时间	DT15	必填
				s procstarttime=arr.GetAt("HDSD00.06.078")
				s:procstarttime="" procstarttime="-"
				//手术切口类别代码	N..2	必填
				s proccuttypecode = arr.GetAt("HDSD00.06.075")
				
				//切口愈合等级代码	N..2	必填
				s proccutunionclasscode = ""
				
				//切口愈合等级名称	AN..100	必填
				s proccutunionclassname = ""
				
				//麻醉方法代码	N..5	必填
				s anaeswaycode = arr.GetAt("HDSD00.06.044")
				
				//麻醉方法名称	AN..50	必填
				s anaeswayname = arr.GetAt("HDSD00.06.309")
				
				//手术切口类别名称	AN..20	必填
				s proccuttypename = arr.GetAt("HDSD00.06.081")
				
				//手术过程	AN..1000	必填
				s proccourse =arr.GetAt("HDSD00.06.073")
				s:proccourse="" proccourse="-"
				//数据采集时间	DT15	必填
				s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
				s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
				continue:procname=""
				set ^CacheTemp(repid, ind) = $LB(businessno,dataid,procstarttime,observres,proccourse,
												proccutunionclassname,proccutunionclasscode,anaeswaycode,anaeswayname,proccode,
												procname,proccuttypename,proccuttypecode,uploadtime)
				set ind = ind + 1
			}
		}
	}
	Quit $$$OK
}

ClassMethod touthossumprocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = touthossumprocExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod touthossumprocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = touthossumprocExecute ]
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

/// 6.6.5门急诊（留观）病历_基本信息(t_emer_medi_rec)
/// Creator:    yejian
/// CreateDate: 2019-5-18	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_temermedirec("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","temermedirec","2018-12-05","2018-12-05")
Query temermedirec(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,upload_status_mark,data_rank,org_code,org_name,patient_name,gender_code,gender_name,age_year,age_month,age_day,birth_date,diag_type_code,diag_type_name,occup_name,occup_code,work_place_name,diag_no,pat_no,diag_time,depart_no,depart_name,doct_no,doct_name,chief_complaint,allergic_his_mark,allergic_his,now_dis_his,past_his,his_record_time,medi_his_relator_name,pat_speaker_relate_name,pat_speaker_relate_code,four_tcm_observ_res,discriminate_accord,therapeutic_treat,consideration,process_guide_ad,recipel_drug_amount,is_observe,upload_time") [ SqlProc ]
{
}

ClassMethod temermedirecExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.03.01"
	s (businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,birthdate,diagtypecode,diagtypename,occupname,occupcode,workplacename,diagno,patno,diagtime,departno,departname,doctno,doctname,chiefcomplaint,allergichismark,allergichis,nowdishis,pasthis,hisrecordtime,medihisrelatorname,patspeakerrelatename,patspeakerrelatecode,fourtcmobservres,discriminateaccord,therapeutictreat,consideration,processguidead,recipeldrugamount,isobserve,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("PAADM_AdmDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s PAPMIDR=$p(^PAADM(AEpisodeID),"^")
			s Birth=$P($G(^PAPER(PAPMIDR,"ALL")),"^",6)  //出生日期
			s PAADMAdmDate=$p(^PAADM(AEpisodeID),"^",6)
    		s AgeStr=$$CalAge^at182(Birth,PAADMAdmDate,"","","") //年龄 
 			s ageyear=$P(AgeStr,"|",12)
 			s agemonth=$P(AgeStr,"|",13)
 			s ageday=$P(AgeStr,"|",14)
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据上传标识	N1	必填
			s uploadstatusmark= "0"
			//数据保密等级	N1	必填
			s datarank= "1"
			//机构代码	AN..22	必填
			s orgcode= ..#HOSCode
			//机构名称	AN..70	必填
			s orgname= ..#HOSName
			//患者姓名	AN..50	必填
			s patientname = arr.GetAt("HDSD00.03.017")
			//性别代码	N1	必填
			s gendercode =..Getgendercode(AEpisodeID)
			//性别名称	AN..20	必填
			s gendername = ..Getgendername(AEpisodeID)
			//年龄(岁)	N1..3	
			s ageyear =..GetAgeyear(AEpisodeID)
			//年龄(月)	N1..2	
			s agemonth = ..GetAgemonth(AEpisodeID)
			//年龄(天)	N1..2	
			s ageday = ..GetAgeday(AEpisodeID)
			//出生日期	D8	有则必填
			s birthdate = $zd($p($g(^PAPER(argPapmiDR,"ALL")),"^",6),3)
			//就诊类型代码	N1	必填
			s diagtypecode = $p(^PAADM(AEpisodeID),"^",2)

			//就诊类型名称	AN..10	必填
			s:diagtypecode="O" diagtypename="门诊"
			s:diagtypecode="E" diagtypename="急诊"
			//职业类别名称	AN..50	有则必填
			s occupname = ""

			//职业类别代码	AN..30	有则必填
			s occupcode = ""
			//工作单位名称	AN..100	有则必填
			s workplacename = ""
			//就诊流水号	AN..32	必填
			s diagno =$p(^PAADM(AEpisodeID),"^",81)
			//门(急)诊号	AN..36	必填
			s patnodr = $p(^PAADM(AEpisodeID),"^",1)
			s patno= $p(^PAPER(patnodr,"PAT",1),"^")
			//就诊时间	DT15	必填
			s diagtime =$zd($p(^PAADM(AEpisodeID),"^",6),3)
			
			//科室编号	AN..64	有则必填
			s departno=..Getdepartno(AEpisodeID)
			//科室名称	AN..100	有则必填
			s departname=..Getdepartname(AEpisodeID)
			//首诊医师编号	AN..64	必填
			s doctno = ..Getdoctno(AEpisodeID)
			//首诊医师签名	AN..50	必填
			s doctname=..Getdoctname(AEpisodeID)
			//主诉	AN..2000	必填
			s chiefcomplaint = arr.GetAt("HDSD00.03.057")
			s:chiefcomplaint="" chiefcomplaint="-"
			//过敏史标志	T/F	必填
			s allergichismark = "0"
			//过敏史	AN..2000	有则必填
			s allergichis = arr.GetAt("HDSD00.03.014")
			//现病史	AN..2000	有则必填
			s nowdishis = arr.GetAt("HDSD00.03.038")
			//既往史	AN..2000	有则必填
			s pasthis = arr.GetAt("HDSD00.03.021")
			//病史记录时间	DT15	有则必填
			s hisrecordtime = arr.GetAt("HDSD00.03.020")
			//病史陈述者姓名	AN..50	有则必填
			s medihisrelatorname = ""
			//陈述者与患者的关系名称	AN..50	有则必填
			s patspeakerrelatename = ""
			//陈述者与患者的关系代码	N..3	有则必填
			s patspeakerrelatecode = ""
			//中医“四诊”观察结果	AN..1000	有则必填
			s fourtcmobservres = arr.GetAt("HDSD00.03.057")
			//辨证依据	AN..1000	有则必填
			s discriminateaccord = arr.GetAt("HDSD00.03.001")
			//治则治法	AN..1000	有则必填
			s therapeutictreat = arr.GetAt("HDSD00.03.056")
			//注意事项	AN..2000	有则必填
			s consideration = arr.GetAt("HDSD00.03.058")
			//处理及指导意见	AN..2000	必填
			s processguidead = "-"
			//处方药品金额	N..11,2	有则必填
			s recipeldrugamount = ""
			//是否留观	T/F	必填
			s isobserve = "0"
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
			i patientname'="" d 
			.set ^CacheTemp(repid, ind) = $LB(businessno,uploadstatusmark,datarank,orgcode,orgname,patientname,gendercode,gendername,ageyear,agemonth,ageday,birthdate,diagtypecode,diagtypename,occupname,occupcode,workplacename,diagno,patno,diagtime,departno,departname,doctno,doctname,chiefcomplaint,allergichismark,allergichis,nowdishis,pasthis,hisrecordtime,medihisrelatorname,patspeakerrelatename,patspeakerrelatecode,fourtcmobservres,discriminateaccord,therapeutictreat,consideration,processguidead,recipeldrugamount,isobserve,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod temermedirecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = temermedirecExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod temermedirecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = temermedirecExecute ]
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

/// 门急诊（留观）病历_诊断(t_emr_diag)
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","temrDiag","2019-03-05","2019-03-05")
Query temrDiag(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "business_no,data_id,inhosp_name,inhosp_code,is_tcm_diag,diag_name_type_code,diag_name_type_name,diag_name,diag_code,diag_time,diag_doct_name,diag_doct_no,upload_time") [ SqlProc ]
{
}

ClassMethod temrDiagExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:StartDate=$c(0) StartDate=""
    s:EndDate=$c(0) EndDate=""
    s:StartDate'="" StartDate=$zdh(StartDate,3)
    s:EndDate'="" EndDate=$zdh(EndDate,3)
    s ret=..GetOPErDiag(StartDate,EndDate)
    q:ret="" $$$OK
    
    d OutputRow
    Quit $$$OK
OutputRow
    s i=""
    f  s i=$o(^CacheTMP("OpHospitalRecordDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("OpHospitalRecordDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s inhospname       =$p(data,"^",3)
    .s inhospcode       =$p(data,"^",4)
    .s istcmdiag        =$p(data,"^",5)
    .s diagnametypecode =$p(data,"^",6)
    .s diagnametypename =$p(data,"^",7)
    .s diagcodedn       =$p(data,"^",8)
    .s diagcode         =$p(data,"^",9)
    .s diagtime         =$p(data,"^",10)
    .s diagdoctname     =$p(data,"^",11)
    .s diagdoctno       =$p(data,"^",12)
    .s uploadtime       =$p(data,"^",13)


	.s data = $lb(businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("OpHospitalRecordDiag",ret)
    q
}

ClassMethod temrDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = temrDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod temrDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = temrDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.5.2门急诊（留观）病历_中医证候(t_emr_tcm_sympt)
/// Creator:    tx
/// CreateDate: 2019-5-21	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","temrtcmDiag","2019-03-05","2019-03-05")
Query temrtcmDiag(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,sympt_tcm_name,sympt_tcm_code,diag_time,upload_time") [ SqlProc ]
{
}

ClassMethod temrtcmDiagExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set ind=1
    s:AStartDate=$c(0) AStartDate=""
    s:AEndDate=$c(0) AEndDate=""
    s:AStartDate'="" AStartDate=$zdh(AStartDate,3)
    s:AEndDate'="" AEndDate=$zdh(AEndDate,3)
    s ret=..GeOPttmcErDiag(AStartDate,AEndDate)
    q:ret="" $$$OK
    
    d OutputRowtcm
    Quit $$$OK
OutputRowtcm
    s i=""
    f  s i=$o(^CacheTMP("OPHospitalRecordtcmDiag",ret,i))  q:i=""  d
    .s data=$g(^CacheTMP("OPHospitalRecordtcmDiag",ret,i))
    .s businessno       =$p(data,"^",1)
    .s dataid           =$p(data,"^",2)
    .s sympttcmname     =$p(data,"^",3)
    .s sympttcmcode     =$p(data,"^",4)
    .s diagtime         =$p(data,"^",5)
    .s uploadtime       =$p(data,"^",6)


	.s data = $lb(businessno,dataid,sympttcmname,sympttcmcode,diagtime,uploadtime)
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    k ^CacheTMP("OPHospitalRecordtcmDiag",ret)
    q
}

ClassMethod temrtcmDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = temrtcmDiagExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod temrtcmDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = temrtcmDiagExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 6.6.5.7门急诊（留观）病历_抢救记录(t_emr_resc)
/// Creator:    yejian
/// CreateDate: 2019-5-17	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_temrresc("2018-03-05","2018-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","temrresc","2015-12-05","2015-12-05")
Query temrresc(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,rescue_stop_time,rescue_start_time,emer_rescue_rec,join_rescue_list,upload_time") [ SqlProc ]
{
}

ClassMethod temrrescExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.03.02"
	s (businessno,dataid,rescuestoptime,rescuestarttime,emerrescuerec,joinrescuelist,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据主键	AN..64	必填
			s dataid= AEpisodeID
			//抢救开始日期时间	DT15	必填
			s rescuestarttime= arr.GetAt("HDSD00.03.029")
			q:(rescuestarttime="")
			//抢救结束日期时间	DT15	必填
			s rescuestoptime= arr.GetAt("HDSD00.03.028")
			//急诊抢救记录描述	AN..2000	必填
			s emerrescuerec= arr.GetAt("HDSD00.03.019")
			//参加抢救人员名单	AN..100	必填
			s joinrescuelist= arr.GetAt("HDSD00.03.002")
			//数据采集时间	DT15	必填
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")

			set ^CacheTemp(repid, ind) = $LB(businessno,dataid,rescuestoptime,rescuestarttime,emerrescuerec,joinrescuelist,uploadtime)
			set ind = ind + 1
		}
	}
	Quit $$$OK
}

ClassMethod temrrescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = temrrescExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod temrrescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = temrrescExecute ]
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

/// 6.6.4.1中医住院病案首页_诊断（t_tcm_inmedi_diag）
/// Creator:    cpj
/// CreateDate: 2019-5-20	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_ttcminmediagnose("2019-03-01","2018-03-01")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","ttcminmediagnose","2019-03-05","2019-03-10")
Query ttcminmediagnose(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no:%String,data_id:%String,medi_mark:%String,aster_slave_diagnosis_mark:%String,emergency_diag_code:%String,emergency_diag_name:%String,emergency_tcm_name_code:%String,emergency_tcm_name_name:%String,diagnostic_time:%String,diagnostic_type_code:%String,diagnostic_type_name:%String,diag_code:%String,diag_name:%String,inhosp_code:%String,inhosp_name:%String,other_diag_code:%String,other_diag_name:%String,other_inhosp_code:%String,other_inhosp_name:%String,tcm_name_code:%String,tcm_name_name:%String,tcm_inhosp_code:%String,tcm_inhosp_name:%String,tcm_syndrome_code:%String,tcm_syndrome_name:%String,other_tcm_name_code:%String,other_tcm_name_name:%String,other_tcm_inhosp_code:%String,other_tcm_inhosp_name:%String,other_tcm_syndrome_code:%String,other_tcm_syndrome_name:%String,damage_poison_extern_dis_code:%String,damage_poison_extern_dis_name:%String,injury_poison_extern_reason:%String,pathology_no:%String,duty_doct_no:%String,duty_doct_name:%String,upload_time") [ SqlProc ]
{
}

ClassMethod ttcminmediagnoseExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.12"

	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s (businessno,dataid,medimark,asterslavediagnosismark,emergencydiagcode,emergencydiagname,emergencytcmnamecode,emergencytcmnamename,diagnostictime,diagnostictypecode,diagnostictypename,diagcode,diagname,inhospcode,inhospname,otherdiagcode,otherdiagname,otherinhospcode,otherinhospname,tcmnamecode,tcmnamename,tcminhospcode,tcminhospname,tcmsyndromecode,tcmsyndromename,othertcmnamecode,othertcmnamename,othertcminhospcode,othertcminhospname,othertcmsyndromecode,othertcmsyndromename,damagepoisonexterndiscode,damagepoisonexterndisname,injurypoisonexternreason,pathologyno,dutydoctno,dutydoctname,uploadtime)=""
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据主键	AN..64	必填
			s dataid = AEpisodeID
			//中西医诊断标识 medi_mark	AN..3	
			s medimark=""
			//主从诊断标识 aster_slave_diagnosis_mark	AN..3
			s asterslavediagnosismark=""
			;set AEpisodeID=123230
			set DiagStr=##class(DHCWMR.IO.OutService).IGetFrontPageICDAll(AEpisodeID,"D")
			Set DiagLen =$L(DiagStr,$c(1))
			for i=1:1:DiagLen {
				Set DiagItem=$P(DiagStr,$c(1),i)
				Continue:DiagItem=""
			    //数据主键	AN..64	必填
			    ;Set dataid = AEpisodeID_"_"_$p(DiagItem,$c(2),1)
			    
			    s flag=$p(DiagItem,$c(2),10)
				if flag="门急诊诊断（西医）" {
					s emergencydiagcode=emergencydiagcode_"&"_$p(DiagItem,$c(2),1) ;门急诊西医诊断编码
					s emergencydiagname=emergencydiagname_"&"_$p(DiagItem,$c(2),2) ;门急诊西医诊断名称
				} 
				if flag="门急诊诊断（中医）" {
					s emergencytcmnamecode=emergencytcmnamecode_"&"_$p(DiagItem,$c(2),1) ;门急诊中医诊断编码
					s emergencytcmnamename=emergencytcmnamename_"&"_$p(DiagItem,$c(2),2) ;门急诊中医诊断名称
				}
				
				if flag="主要诊断" {
					s diagcode=diagcode_"&"_$p(DiagItem,$c(2),1) ;主要诊断编码
					s diagname=diagname_"&"_$p(DiagItem,$c(2),2) ;主要诊断名称
					s inhospcode=inhospcode_"&"_$p(DiagItem,$c(2),5) ;主要诊断入院病情代码
					s inhospname=inhospname_"&"_$p(DiagItem,$c(2),6) ;主要诊断入院病情名称
				}
				if flag="其他诊断" {
					s otherdiagcode=otherdiagcode_"&"_$p(DiagItem,$c(2),1) ;其他诊断编码
					s otherdiagname=otherdiagname_"&"_$p(DiagItem,$c(2),2) ;其他诊断编码
					//i otherdiagname="" {s otherdiagname=$p(DiagItem,$c(2),2)}
					//else {s otherdiagname=otherdiagname_"&"_$p(DiagItem,$c(2),2)} ;其他诊断名称
					s otherinhospcode=otherinhospcode_"&"_$p(DiagItem,$c(2),5) ;其他诊断入院病情代码
					s otherinhospname=otherinhospname_"&"_$p(DiagItem,$c(2),6) ;其他诊断入院病情名称
				}
				if flag="出院中医主病" {
					s tcmnamecode=tcmnamecode_"&"_$p(DiagItem,$c(2),1) ;中医主病编码
					s tcmnamename=tcmnamename_"&"_$p(DiagItem,$c(2),2) ;中医主病名称
					s tcminhospcode=tcminhospcode_"&"_$p(DiagItem,$c(2),5) ;中医主病入院病情代码
					s tcminhospname=tcminhospname_"&"_$p(DiagItem,$c(2),6) ;中医主病入院病情名称
				}
				if flag="出院中医主证" {
					s othertcmnamecode=othertcmnamecode_"&"_$p(DiagItem,$c(2),1) ;中医主证编码
					s othertcmnamename=othertcmnamename_"&"_$p(DiagItem,$c(2),2) ;中医主证编码
					//i othertcmnamename="" {s othertcmnamename=$p(DiagItem,$c(2),2) }
					//else {s othertcmnamename=othertcmnamename_"&"_$p(DiagItem,$c(2),2)} ;中医主证名称
					s othertcminhospcode=othertcminhospcode_"&"_$p(DiagItem,$c(2),5) ;中医主病入院病情代码
					s othertcminhospname=othertcminhospname_"&"_$p(DiagItem,$c(2),6) ;中医主病入院病情名称
				}
				if flag="损伤中毒诊断" {
					s damagepoisonexterndiscode=damagepoisonexterndiscode_"&"_$p(DiagItem,$c(2),1) ;损伤中毒诊断编码
					s damagepoisonexterndisname=damagepoisonexterndisname_"&"_$p(DiagItem,$c(2),2) ;损伤中毒诊断名称
				}
			}
			
			//门急诊诊断代码 emergency_diag_code	AN..20
			s:emergencydiagcode'="" emergencydiagcode=$e(emergencydiagcode,2,$l(emergencydiagcode)) ;门急诊西医诊断编码
			//门急诊诊断名称 emergency_diag_name	AN..100	
			s:emergencydiagname'="" emergencydiagname=$e(emergencydiagname,2,$l(emergencydiagname)) ;门急诊西医诊断名称
			
			//门急诊中医病名代码 emergency _tcm_name_code AN..20
			s:emergencytcmnamecode'="" emergencytcmnamecode=$e(emergencytcmnamecode,2,$l(emergencytcmnamecode)) ;门急诊中医诊断编码
			//门急诊中医病名名称 emergency _tcm_name_name AN..100
			s:emergencytcmnamename'="" emergencytcmnamename=$e(emergencytcmnamename,2,$l(emergencytcmnamename)) ;门急诊中医诊断名称
			//诊断时间 diagnostic_time	DT15	必填
			s diagnostictime=""
			//门急诊诊断类型代码 diagnostic_type_code AN..20
			s diagnostictypecode=""
			//门急诊诊断类型名称 diagnostic_type_name AN..100
			s diagnostictypename=""
			//住院主诊断编码 diag_code AN..20 必填
			s:diagcode'="" diagcode=$e(diagcode,2,$L(diagcode)) ;主要诊断编码
			//住院主诊断名称 diag_name AN..20 必填
			s:diagname'="" diagname=$e(diagname,2,$L(diagname)) ;主要诊断名称
			//住院主诊断入院病情代码 inhosp_code  必填
			s:inhospcode'="" inhospcode=$e(inhospcode,2,$L(inhospcode)) ;主要诊断入院病情代码
			//住院主诊断入院病情名称 inhosp_name  必填
			s:inhospname'="" inhospname=$e(inhospname,2,$L(inhospname)) ;主要诊断入院病情名称
			//其他诊断代码 other_diag_code 必填
			s:otherdiagcode'="" otherdiagcode=$e(otherdiagcode,2,$L(otherdiagcode)) ;其他诊断编码
			//其他诊断名称 other_diag_name 必填
			s:otherdiagname'="" otherdiagname=$e(otherdiagname,2,$L(otherdiagname))  ;其他诊断名称
			// 其他入院病情代码 other_inhosp_code 必填
			s:otherinhospcode'="" otherinhospcode=$e(otherinhospcode,2,$L(otherinhospcode)) ;其他诊断入院病情代码
			// 其他入院病情名称 other_inhosp_name 必填
			s:otherinhospname'="" otherinhospname=$e(otherinhospname,2,$L(otherinhospname))  ;其他诊断入院病情名称
			// 住院中医主病名代码 tcm_name_code
			s:tcmnamecode'="" tcmnamecode=$e(tcmnamecode,2,$L(tcmnamecode)) ;中医主病编码
			// 住院中医主病名名称 tcm_name_name
			s:tcmnamename'="" tcmnamename=$e(tcmnamename,2,$L(tcmnamename)) ;中医主病名称
			//住院中医主病入院病情代码
			s:tcminhospcode'="" tcminhospcode=$e(tcminhospcode,2,$L(tcminhospcode)) ;中医主病入院病情代码
			//住院中医主病入院病情名称
			s:tcminhospname'="" tcminhospname=$e(tcminhospname,2,$L(tcminhospname)) ;中医主病入院病情名称
			// 中医证候代码
			s tcmsyndromecode=""
			//中医证候名称
			S tcmsyndromename=""
			//住院其他中医病名代码
			s:othertcmnamecode'="" othertcmnamecode=$e(othertcmnamecode,2,$L(othertcmnamecode)) ;中医主证编码
			//住院其他中医病名名称
			s:othertcmnamename'="" othertcmnamename=$e(othertcmnamename,2,$L(othertcmnamename)) ;中医主证名称
			//住院其他中医入院病情代码
			s:othertcminhospcode'="" othertcminhospcode=$e(othertcminhospcode,2,$L(othertcminhospcode)) ;中医主证入院病情代码
			//住院其他中医入院病情名称
			s:othertcminhospname'="" othertcminhospname=$e(othertcminhospname,2,$L(othertcminhospname)) ;中医主证入院病情名称
			//住院其他中医证候代码
			s othertcmsyndromecode=""
			//住院其他中医证候名称
			s othertcmsyndromename=""
			//损伤中毒的外部原因疾病代码
			s:damagepoisonexterndiscode'="" damagepoisonexterndiscode=$e(damagepoisonexterndiscode,2,$L(damagepoisonexterndiscode))  ;损伤中毒诊断编码
			//损伤中毒的外部原因疾病名称
			s:damagepoisonexterndisname'="" damagepoisonexterndisname=$e(damagepoisonexterndisname,2,$L(damagepoisonexterndisname))  ;损伤中毒诊断名称
			//损伤中毒的外部原因
			s injurypoisonexternreason="" ;损伤中毒的外部原因
			//病理号
			s pathologyno= arr.GetAt("HDSD00.12.009")	//病理号
			//责任医师编码
			s dutydoctno=""		//责任医师编码
			//责任医师姓名
			s dutydoctname=""	//责任医师姓名
			//数据采集时间
			s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
			s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
			
			
			set ^CacheTemp(repid, ind) = $LB(businessno,dataid,medimark,asterslavediagnosismark,emergencydiagcode,emergencydiagname,emergencytcmnamecode,emergencytcmnamename,diagnostictime,diagnostictypecode,diagnostictypename,diagcode,diagname,inhospcode,inhospname,otherdiagcode,otherdiagname,otherinhospcode,otherinhospname,tcmnamecode,tcmnamename,tcminhospcode,tcminhospname,tcmsyndromecode,tcmsyndromename,othertcmnamecode,othertcmnamename,othertcminhospcode,othertcminhospname,othertcmsyndromecode,othertcmsyndromename,damagepoisonexterndiscode,damagepoisonexterndisname,injurypoisonexternreason,pathologyno,dutydoctno,dutydoctname,uploadtime)
			set ind = ind + 1
		}
	}

	Quit $$$OK
}

ClassMethod ttcminmediagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ttcminmediagnoseExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod ttcminmediagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ttcminmediagnoseExecute ]
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

/// 6.6.4.3中医住院病案首页_费用（t_tcm_inmedi_expenses）
/// Creator:    tx
/// CreateDate: 2019-5-20	
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     Dateset:接口数据
/// call EMRservice_InterfaceService.EMRRecordCollectInterface_ttcminmefee("2019-03-05","2019-04-05")
/// d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRRecordCollectInterface","ttcminmefee","2019-03-05","2019-03-10")
Query ttcminmefee(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "business_no,data_id,inhosp_all_amount,personal_cost_amount,payment_term_code,payment_term_name,mater_check_medi_amount,recovery_amount,other_amount,mater_proc_medi_amount,medi_en_amount,medi_en_antibiosis_amount,blood_product_albumin_amount,blood_product_cf_amount,blood_product_globulin_amount,blood_product_cell_amount,blood_product_amount,diag_pathology_amount,diag_clinic_proj_amount,diag_lab_amount,diag_iconography_amount,diag_noproc_treat_proj_amount,treat_noproc_clin_phys_amount,treat_proc_treat_amount,treat_proc_anaes_amount,treat_proc_amount,mater_treat_medi_amount,medi_tcm_herb_amount,medi_tcm_patent_drug_amount,treat_tcm_amount,medi_service_care_amount,medi_service_other_amount,medi_service_medi_amount,medi_service_operate_amount,cn_different_treat_expense,cn_tcm_consult_expense,medical_cn_diag_expense,tradit_medical_cn_diag_expense,orthop_medical_cn_diag_expense,acup_moxi_medical_cn_expense,massage_medical_cn_expense,anorect_medical_cn_expense,special_medical_cn_expense,other_medical_cn_expense,allocat_proces_cn_expense,dialect_different_expense,tradit_prepar_cn_expense,upload_time") [ SqlProc ]
{
}

ClassMethod ttcminmefeeExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//术语目录内部标示符
	s AGlossaryCategoryID = "HDSD00.12"
	s (businessno,dataid,inhospallamount,personalcostamount,paymenttermcode,paymenttermname,matercheckmediamount,recoveryamount,otheramount,materprocmediamount,medienamount,medienantibiosisamount,bloodproductalbuminamount,bloodproductcfamount,bloodproductglobulinamount,bloodproductcellamount,bloodproductamount,diagpathologyamount,diagclinicprojamount,diaglabamount,diagiconographyamount,diagnoproctreatprojamount,treatnoprocclinphysamount,treatproctreatamount,treatprocanaesamount,treatprocamount,matertreatmediamount,meditcmherbamount,meditcmpatentdrugamount,treattcmamount,mediservicecareamount,mediserviceotheramount,mediservicemediamount,mediserviceoperateamount,cndifferenttreatexpense,cntcmconsultexpense,medicalcndiagexpense,traditmedicalcndiagexpense,orthopmedicalcndiagexpense,acupmoximedicalcnexpense,massagemedicalcnexpense,anorectmedicalcnexpense,specialmedicalcnexpense,othermedicalcnexpense,allocatprocescnexpense,dialectdifferentexpense,traditpreparcnexpense,uploadtime)=""
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)
	i EndDate<StartDate Set qHandle=$lb(0,repid,0)	Quit $$$OK
	
	s AEpisodeID=""

	f tmpdate=+StartDate:1:+EndDate
	{
		s AEpisodeID=""
		for{
			s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID))
			q:(AEpisodeID = "")
			s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
			s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
			//住院号
			s strpaid = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(AEpisodeID)
			//登记号
			s strpno = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(strpaid)
			//s strRe  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_"CG37"))
			//continue:(strRe = "")
			s arr=##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,AGlossaryCategoryID)
			//业务编号	AN..64	必填
			s businessno= ..#HOSCode_"_"_AEpisodeID
			//数据主键	AN..64	必填
			s dataid = AEpisodeID
			s paymenttermcode= arr.GetAt("HDSD00.12.132")
			s paymenttermname= arr.GetAt("HDSD00.12.585")
			s (inhospallamount,personalcostamount,matercheckmediamount,recoveryamount,otheramount,materprocmediamount,medienamount,medienantibiosisamount,bloodproductalbuminamount,bloodproductcfamount,bloodproductglobulinamount,bloodproductcellamount,bloodproductamount,diagpathologyamount,diagclinicprojamount,diaglabamount,diagiconographyamount,diagnoproctreatprojamount,treatnoprocclinphysamount,treatproctreatamount,treatprocanaesamount,treatprocamount,matertreatmediamount,meditcmherbamount,meditcmpatentdrugamount,treattcmamount,mediservicecareamount,mediserviceotheramount,mediservicemediamount,mediserviceoperateamount,cndifferenttreatexpense,cntcmconsultexpense,medicalcndiagexpense,traditmedicalcndiagexpense,orthopmedicalcndiagexpense,acupmoximedicalcnexpense,massagemedicalcnexpense,anorectmedicalcnexpense,specialmedicalcnexpense,othermedicalcnexpense,allocatprocescnexpense,dialectdifferentexpense,traditpreparcnexpense,uploadtime)=""
			Set CostStr=##class(web.DHCBillInterface).IGetTarMRCateFee(AEpisodeID,"","N","")
			Set TotalFees=$p(CostStr,$c(3),1)
			;Set inhospallamount=$p(TotalFees,"^",1) 
			Set personalcostamount=$p(TotalFees,"^",2)	//自费用
			s chargeitm=##class(web.SendAdmInfo).IGetTarItemCate(AEpisodeID,"","TMCNew","^^^^")
			i chargeitm'="" d
    		.s Length=$L(chargeitm,"!")
			.s inhospallamount=0 
			.f p=1:1:Length d
			..s TmpStr=$p(chargeitm,"!",p)
			..s ChargeCode=$p(TmpStr,"^",1)
			..s ChargeDesc=$p(TmpStr,"^",3)
			..s ChargeMoney=$p(TmpStr,"^",4)
			..if (ChargeCode="23")||(ChargeCode="44") d ;诊查费 床位费
			...s mediservicemediamount=ChargeMoney	
			..else  if ChargeCode="45" d ;挂号费
			...s RegFee=ChargeMoney
			..;else  if ChargeCode="44" d ;床位费
			...;s BedFee=ChargeMoney
			..else  if ChargeCode="11" d ;中医辨证论治费
			...s cndifferenttreatexpense=ChargeMoney
			..else  if ChargeCode="12" d ;中医辨证论治会诊费
			...s cntcmconsultexpense=ChargeMoney
			..else  if (ChargeCode="13")||(ChargeCode="46") d ;一般治疗费 输氧费
			...s mediserviceoperateamount=ChargeMoney
			..;else  if ChargeCode="47" d ;护理治疗费
			...;s NursingFee=ChargeMoney
			..;else  if ChargeCode="42" d ;监护及辅助呼吸设备费 
			...;s EquipmentFee=ChargeMoney
			..;else  if ChargeCode="46" d ;输氧费 
			...;s OxygenFee=ChargeMoney
			..else  if (ChargeCode="9")||(ChargeCode="47") d ;护理费 ;护理治疗费
			...s mediservicecareamount=ChargeMoney
			..else  if (ChargeCode="6")||(ChargeCode="37")||(ChargeCode="42")||(ChargeCode="36")||(ChargeCode="50") d ;其他费 ;核素检查；监护及辅助呼吸设备费；接生费；其他费用
			...s mediserviceotheramount=ChargeMoney
			..else  if ChargeCode="49" d ;病理费
			...s diagpathologyamount=ChargeMoney
			..else  if ChargeCode="41" d ;化验费
			...s diaglabamount=ChargeMoney
			..;else  if ChargeCode="37" d ;核素检查 
			...;s NuclideFee=ChargeMoney
			..else  if (ChargeCode="39")||(ChargeCode="40") d ;超声费 放射费
			...s diagiconographyamount=ChargeMoney
			..;else  if ChargeCode="40" d ;放射费
			...;s EmissionFee=ChargeMoney
			..else  if ChargeCode="24" d ;一般检查费 
			...s diagclinicprojamount=ChargeMoney
			..else  if ChargeCode="8" d ;临床物理治疗费
			...s treatnoprocclinphysamount=ChargeMoney
			..else  if (ChargeCode="38")||(ChargeCode="26")||(ChargeCode="35") d ;核素治疗 特殊治疗费 精神治疗费 
			...s diagnoproctreatprojamount=ChargeMoney
			..;else  if ChargeCode="26" d ;特殊治疗费 
			...;s SpecialFee=ChargeMoney
			..;else  if ChargeCode="35" d ;精神治疗费 
			...;s SpiritTreatFee=ChargeMoney
			..else  if ChargeCode="48" d ;麻醉费
			...s treatprocanaesamount=ChargeMoney
			..else  if ChargeCode="7" d ;手术费
			...s treatprocamount=ChargeMoney
			..else  if ChargeCode="25" d ;介入治疗费
			...s treatproctreatamount=ChargeMoney
			..else  if ChargeCode="27" d ;中医诊断
			...s medicalcndiagexpense=ChargeMoney
			..else  if ChargeCode="29" d ;中医骨伤
			...s orthopmedicalcndiagexpense=ChargeMoney
			..else  if ChargeCode="30" d ;针刺与灸法
			...s acupmoximedicalcnexpense=ChargeMoney
			..else  if ChargeCode="31" d ;中医推拿治疗
			...s massagemedicalcnexpense=ChargeMoney
			..else  if ChargeCode="32" d ;中医肛肠治疗 
			...s anorectmedicalcnexpense=ChargeMoney
			..else  if ChargeCode="33" d ;中医特色治疗
			...s specialmedicalcnexpense=ChargeMoney
			..else  if ChargeCode="34" d ;中药煎药费 
			...s othermedicalcnexpense=ChargeMoney
			..else  if ChargeCode="21" d ;中药特殊调配加工
			...s allocatprocescnexpense=ChargeMoney
			..else  if ChargeCode="22" d ;辨证施膳
			...s dialectdifferentexpense=ChargeMoney
			..;else  if ChargeCode="36" d ;接生费 
			...;s DeliveryFee=ChargeMoney
			..else  if ChargeCode="10" d ;康复费
			...s recoveryamount=ChargeMoney
			..else  if ChargeCode="28" d ;中医治疗费 中医外治
			...s treattcmamount=ChargeMoney
			..else  if ChargeCode="3" d ;抗菌药物费
			...s medienantibiosisamount=ChargeMoney
			..else  if ChargeCode="2" d ;西药费
			...s medienamount=ChargeMoney
			..else  if ChargeCode="1" d ;中成药费
			...s meditcmpatentdrugamount=ChargeMoney
			..else  if ChargeCode="4" d ;中草药费
			...s meditcmherbamount=ChargeMoney
			..else  if ChargeCode="5" d ;输血费
			...s bloodproductamount=ChargeMoney
			..else  if ChargeCode="17" d ;白蛋白类制品费
			...s bloodproductalbuminamount=ChargeMoney
			..else  if ChargeCode="18" d ;球蛋白类制品费
			...s bloodproductglobulinamount=ChargeMoney
			..else  if ChargeCode="19" d ;凝血因子类制品费
			...s bloodproductcfamount=ChargeMoney
			..else  if ChargeCode="20" d ;细胞因子类制品费
			...s bloodproductcellamount=ChargeMoney
			..else  if ChargeCode="14" d ;检查用一次性医用材料费
			...s matercheckmediamount=ChargeMoney
			..else  if ChargeCode="15" d ;治疗用一次性医用材料费
			...s matertreatmediamount=ChargeMoney
			..;else  if ChargeCode="43" d ;介入用一次性医用材料费
			...;s InterMaterialFee=ChargeMoney
			..else  if (ChargeCode="16")||(ChargeCode="43") d ;手术用一次性医用材料费 介入用一次性医用材料费
			...s materprocmediamount=ChargeMoney
			..;s inhospallamount=inhospallamount+ChargeMoney
			..s inhospallamount=matercheckmediamount+recoveryamount+otheramount+materprocmediamount+medienamount+medienantibiosisamount+bloodproductalbuminamount+bloodproductcfamount+bloodproductglobulinamount+bloodproductcellamount+bloodproductamount+diagpathologyamount+diagclinicprojamount+diaglabamount+diagiconographyamount+diagnoproctreatprojamount+treatnoprocclinphysamount+treatproctreatamount+treatprocanaesamount+treatprocamount+matertreatmediamount+meditcmherbamount+meditcmpatentdrugamount+treattcmamount+mediservicecareamount+mediserviceotheramount+mediservicemediamount+mediserviceoperateamount+cndifferenttreatexpense+cntcmconsultexpense+medicalcndiagexpense+traditmedicalcndiagexpense+orthopmedicalcndiagexpense+acupmoximedicalcnexpense+massagemedicalcnexpense+anorectmedicalcnexpense+specialmedicalcnexpense+othermedicalcnexpense+allocatprocescnexpense+dialectdifferentexpense+traditpreparcnexpense

				
				//数据采集时间 upload_time	DT15	必填
				s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
				s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
		
				
				
				set ^CacheTemp(repid, ind) = $LB(businessno,dataid,inhospallamount,personalcostamount,paymenttermcode,paymenttermname,matercheckmediamount,recoveryamount,otheramount,materprocmediamount,medienamount,medienantibiosisamount,bloodproductalbuminamount,bloodproductcfamount,bloodproductglobulinamount,bloodproductcellamount,bloodproductamount,diagpathologyamount,diagclinicprojamount,diaglabamount,diagiconographyamount,diagnoproctreatprojamount,treatnoprocclinphysamount,treatproctreatamount,treatprocanaesamount,treatprocamount,matertreatmediamount,meditcmherbamount,meditcmpatentdrugamount,treattcmamount,mediservicecareamount,mediserviceotheramount,mediservicemediamount,mediserviceoperateamount,cndifferenttreatexpense,cntcmconsultexpense,medicalcndiagexpense,traditmedicalcndiagexpense,orthopmedicalcndiagexpense,acupmoximedicalcnexpense,massagemedicalcnexpense,anorectmedicalcnexpense,specialmedicalcnexpense,othermedicalcnexpense,allocatprocescnexpense,dialectdifferentexpense,traditpreparcnexpense,uploadtime)
				set ind = ind + 1
			}
		}
	
	Quit $$$OK
}

ClassMethod ttcminmefeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ttcminmefeeExecute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod ttcminmefeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ttcminmefeeExecute ]
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

/// Desc:	获取指定术语值
/// Input：	AEpisodeID : 就诊指针
/// 		AGlossaryInternalID : 指定术语内部标识符
/// Output:	术语值
/// Debug:	w ..GetStdDataByGlossary("315","HDSD00.11.050","HDSD00.12")
ClassMethod GetStdDataByGlossary(AEpisodeID As %String, AGlossaryInternalID As %String, ACategoryInternalID As %String) As %String
{
	q:(AEpisodeID="")||(AGlossaryInternalID="")||(ACategoryInternalID="") ""
	s ret = ""
	s glossaryID = $O(^DHCEPRM.GlossaryI("IdxGlossaryID"," "_AGlossaryInternalID,""))
	q:(glossaryID="")
	s strDataValues = ""
	s glossaryID = $tr(glossaryID," ","")
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	s templateCategoryID = "" // ##Class(EMRservice.BL.BLScatterData).GetGlossaryTemplateIDS(ACategoryInternalID)
	if (templateCategoryID="")
	{
		s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	}
	q:(templateCategoryID="") ret
	//获取InstanceID集合
	s InstanceIDS = ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID)
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) ret
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
	
		//通过注册号，术语rowId获取业务数据
		s strDataValues =##Class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
		;continue:(strDataValues = "")
	 	s strDataValue=strDataValues
		s deName = objGlossary.Name
		s deName = $p(deName," ",2)
		s strInternalID = objGlossary.InternalID
		//关联标准数据元标识符
		S strMetaID = objGlossary.MetaID
		s strDescription = objGlossary.Description
		
		//如果没有关联数据元标示符，直接返回业务值
		if ((strMetaID = "") || (strMetaID=$char(0)))
		{
			continue
		}
		//通过数据元标识符取数据元
		s derowID = ""
		s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
		if (derowID = "")
		{
			s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
		}
		s strDataType =""
		s strDEVID = ""
		s strFormat = ""
		if (derowID '= "")
		{
			s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
			s strDataType = objCurDataE.DataType
			s strFormat = objCurDataE.Format
			//数据元允许值标识符
			s strDEVID = objCurDataE.DEVID
		}
		//通过术语子集取数据类型
		s itemRowID = ""
		s strValueType = ""
		s itemCode = ""
		s templateID = ""
		s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
		if (itemRowID '= "")
		{
			s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
			s strValueType = objGlossaryItem.ValueType
			s itemCode = objGlossaryItem.ItemCode
			s templateID = objGlossaryItem.TemplateID
		}
		//判断是否有数据元映射关系
		s devCategoryID = ""
		s sysCode = ""
		s categroyName = ""
		s MaprowID= ""
		//通过数据元允许值标识符取映射关系
		if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
		{
			//通过数据元允许值取允许值范畴名字
			s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
			if (devCategoryID '="")
			{
			s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
			s categroyName = objdevCategory.Name
			}
			//如果允许值范畴名字为空，则名字等于数据元允许值标识符
			if (categroyName="")
			{
				s categroyName = strDEVID
			}
			//如果术语集业务数据不为空,则通新索引处理!
			if (strDataValue'="")
			{
				if (strValueType="C")
				{
					s IndexMaprowID = MaprowID
					s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_strDataValue,MaprowID))
					s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
				}
				if (strValueType="V")
				{
					s IndexMaprowID = MaprowID
					s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_strDataValue,MaprowID))
					s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
				}
		
				if (MaprowID '= "")
				{		
					s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
					s strDataValue = objMap.DEVDes
					s sysCode = objMap.DEVID
				}
			}
		}
		//判断数据类型
		if ((strDataType'="")&(strDataValue'=""))
		{
			s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
		}
		//判断数据元数据格式
		if ((strFormat'="")&(strDataValue'=""))
		{
			if (sysCode'=""){
			s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
			}
			else
			{
				s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
			}
		}
		if ((sysCode = "")&(strDataValue'="")&(strValueType = "C"))
		{
			s sysCode = strDataValue
			s strDataValue = " "
		}
		//处理按ValueType返回结果
		s strDataValues = $s(strValueType="VANDC":strDataValue,strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:strDataValue)
	}
	q strDataValues
}

/// Desc：	取病床号，
ClassMethod GetBedno(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
    s bedno=""
    s BedId=$P($g(^PAADM(AEpisodeID)),"^",73)
    s:(BedId'="") bedno=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
    
    s:bedno="" bedno="-"
    q bedno
}

/// Desc：	取病房号，
ClassMethod GetRoomno(AEpisodeID As %String) As %String
{
	q:(($d(AEpisodeID)=0)||(AEpisodeID="")) ""
	s CurrentRoomDR=$p(^PAADM(AEpisodeID),"^",69)
    s roomno=""
    i CurrentRoomDR'="" d
    .s roomno=$p(^PAROOM(CurrentRoomDR),"^") 
    q roomno
}

/// Desc：	取病区名，
ClassMethod GetWardName(AEpisodeID As %String) As %String
{
	s wardname = ""
	s CurrentWardDR=$p(^PAADM(AEpisodeID),"^",70)
	s:CurrentWardDR'="" wardname=$p(^PAWARD(CurrentWardDR),"^",2)
	q wardname
}

/// Desc：	科室编号
ClassMethod Getdepartno(AEpisodeID As %String) As %String
{
	s departno = ""
	s departdr=$p(^PAADM(AEpisodeID),"^",4)
	s departno=$p($g(^CTLOC(departdr)),"^",1)
	q departno
}

/// Desc：	科室名称
ClassMethod Getdepartname(AEpisodeID As %String) As %String
{
	s departname = ""
	s departdr=$p(^PAADM(AEpisodeID),"^",4)
	s departname=$p($g(^CTLOC(departdr)),"^",1)
	q departname
}

/// 取住院中西医诊断
/// w ..GetErDiag("","")
ClassMethod GetErDiag(StartDate As %String, EndDate As %String) As %String
{
	s:StartDate=$c(0) StartDate=""
    s:EndDate=$c(0) EndDate=""
    s:StartDate="" StartDate=+$h-1
    s:EndDate="" EndDate=+$h-1
    s:StartDate["-" StartDate=$zdh(StartDate,3)
    s:EndDate["-" EndDate=$zdh(EndDate,3)  
	s AEpisodeID=""
    s i=0
	s (businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)=""
	f tmpdate = StartDate:1:EndDate d
	.s AEpisodeID=""
	.f  s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID)) q:AEpisodeID=""   d 
	..s admtype=$P($g(^PAADM(AEpisodeID)),"^",2)
	..q:admtype'="I"
	..s businessno= ..#HOSCode_"_"_AEpisodeID
    ..s MainMRAdmDR=$P($g(^PAADM(AEpisodeID)),"^",61)
    ..s j=0
   	..s MRDIAChildsub="" f  s MRDIAChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub))   q:MRDIAChildsub=""  d
    ...q:MRDIAChildsub=0
    ...s MRDIADocCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",4)
    ...s diagdoctname="-",diagdoctno="-"
    ...i MRDIADocCodeDR'="" d
    ....s diagdoctname=$p(^CTPCP(MRDIADocCodeDR,1),"^",2)
    ....s diagdoctno=$p(^CTPCP(MRDIADocCodeDR,1),"^")
   	...s diagname=$g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"DES",1))
    ...s diagtime=$zd($p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",7),3) //诊断时间
   	...s ICDCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",1)
    ...s diagcategorycode=1,diagcategoryname="西医",diagcode="",diagcodedn="",diseasecode="",diseasename=""
    ...i ICDCodeDR="" d
    ....s diagcode="",diagcodedn=""
    ...i ICDCodeDR'="" d
    ....s diagcode=$p(^MRC("ID",ICDCodeDR),"^",1)
    ....s diagcodedn=$p(^MRC("ID",ICDCodeDR),"^",2)
    ....s diagcategorycode=$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"2",:"1")
    ....s diagcategoryname =$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"中医",:"西医")
    ....s issympttcm=$p(^MRC("ID",ICDCodeDR),"^",13)
    ...q:issympttcm="Y"
    ...s istcmdiag="0"
    ...i diagcategoryname="中医" s istcmdiag="1"
    ...s TYPChildsub="" f  s TYPChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub)) q:TYPChildsub=""  d
    ....s DTYPRowId=$p(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub),"^")
    ....s diagnametypecode=$p(^MRC("DTYP",DTYPRowId),"^")
    ....s diagnametypename=$p(^MRC("DTYP",DTYPRowId),"^",2)
    ...;q:diagnametypecode="DIS"
    ...s dataid =AEpisodeID_"_"_j
    ...s j=j+1
    ...s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	...s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
    ...q:diagcodedn=""
	...s ^CacheTMP("InHospitalRecordDiag",$j,i)=businessno_"^"_dataid_"^"_inhospname_"^"_inhospcode_"^"_istcmdiag_"^"_diagnametypecode_"^"_diagnametypename_"^"_diagcodedn_"^"_diagcode_"^"_diagtime_"^"_diagdoctname_"^"_diagdoctno_"^"_uploadtime
    ...s i=i+1
    q $j
}

/// 取死亡患者中西医诊断
/// w ..GetdeathDiag("","")
ClassMethod GetdeathDiag(StartDate As %String, EndDate As %String) As %String
{
	s:StartDate=$c(0) StartDate=""
    s:EndDate=$c(0) EndDate=""
    s:StartDate="" StartDate=+$h-1
    s:EndDate="" EndDate=+$h-1
    s:StartDate["-" StartDate=$zdh(StartDate,3)
    s:EndDate["-" EndDate=$zdh(EndDate,3)  
	s AEpisodeID=""
    s i=0
	s (businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)=""
	f tmpdate = StartDate:1:EndDate d
	.s AEpisodeID=""
	.f  s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID)) q:AEpisodeID=""   d 
	..s admtype=$P($g(^PAADM(AEpisodeID)),"^",2)
	..q:admtype'="I"
	..s papmi=$P($g(^PAADM(AEpisodeID)),"^",1)
	..s patdesceased=$P($g(^PAPER(papmi,"ALL")),"^",12)
	..q:patdesceased'="Y"
	..s businessno= ..#HOSCode_"_"_AEpisodeID
    ..s MainMRAdmDR=$P($g(^PAADM(AEpisodeID)),"^",61)
    ..s j=0
   	..s MRDIAChildsub="" f  s MRDIAChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub))   q:MRDIAChildsub=""  d
    ...q:MRDIAChildsub=0
    ...s MRDIADocCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",4)
    ...s diagdoctname="-",diagdoctno="-"
    ...i MRDIADocCodeDR'="" d
    ....s diagdoctname=$p(^CTPCP(MRDIADocCodeDR,1),"^",2)
    ....s diagdoctno=$p(^CTPCP(MRDIADocCodeDR,1),"^")
   	...s diagname=$g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"DES",1))
    ...s diagtime=$zd($p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",7),3) //诊断时间
   	...s ICDCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",1)
    ...s diagcategorycode=1,diagcategoryname="西医",diagcode="",diagcodedn="",diseasecode="",diseasename=""
    ...i ICDCodeDR="" d
    ....s diagcode="",diagcodedn=""
    ...i ICDCodeDR'="" d
    ....s diagcode=$p(^MRC("ID",ICDCodeDR),"^",1)
    ....s diagcodedn=$p(^MRC("ID",ICDCodeDR),"^",2)
    ....s diagcategorycode=$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"2",:"1")
    ....s diagcategoryname =$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"中医",:"西医")
    ....s issympttcm=$p(^MRC("ID",ICDCodeDR),"^",13)
    ...q:issympttcm="Y"
    ...s istcmdiag="0"
    ...i diagcategoryname="中医" s istcmdiag="1"
    ...s TYPChildsub="" f  s TYPChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub)) q:TYPChildsub=""  d
    ....s DTYPRowId=$p(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub),"^")
    ....s diagnametypecode=$p(^MRC("DTYP",DTYPRowId),"^")
    ....s diagnametypename=$p(^MRC("DTYP",DTYPRowId),"^",2)
    ...;q:diagnametypecode="DIS"
    ...s dataid =AEpisodeID_"_"_j
    ...s j=j+1
    ...s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	...s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
    ...q:diagcodedn=""
	...s ^CacheTMP("DeathRecordDiag",$j,i)=businessno_"^"_dataid_"^"_inhospname_"^"_inhospcode_"^"_istcmdiag_"^"_diagnametypecode_"^"_diagnametypename_"^"_diagcodedn_"^"_diagcode_"^"_diagtime_"^"_diagdoctname_"^"_diagdoctno_"^"_uploadtime
    ...s i=i+1
    q $j
}

/// 取住院中医证候
/// w ..GettmcErDiag("","")
ClassMethod GettmcErDiag(StartDate As %String, EndDate As %String) As %String
{
	s:StartDate=$c(0) StartDate=""
    s:EndDate=$c(0) EndDate=""
    s:StartDate="" StartDate=+$h-1
    s:EndDate="" EndDate=+$h-1
    s:StartDate["-" StartDate=$zdh(StartDate,3)
    s:EndDate["-" EndDate=$zdh(EndDate,3) 
	s AEpisodeID=""
	s i=0
	s (businessno,dataid,sympttcmname,sympttcmcode,diagtime,uploadtime)=""
	f tmpdate = StartDate:1:EndDate d
	.s AEpisodeID=""
	.f  s AEpisodeID= $o(^PAADMi("DischDate",tmpdate,AEpisodeID)) q:AEpisodeID=""   d 
	..s admtype=$P($g(^PAADM(AEpisodeID)),"^",2)
	..q:admtype'="I"
	..s businessno= ..#HOSCode_"_"_AEpisodeID
    ..s MainMRAdmDR=$P($g(^PAADM(AEpisodeID)),"^",61)
    ..s j=0
   	..s MRDIAChildsub="" f  s MRDIAChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub))   q:MRDIAChildsub=""  d
    ...q:MRDIAChildsub=0
    ...s MRDIADocCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",4)
    ...s diagdoctname="-",diagdoctno="-"
    ...i MRDIADocCodeDR'="" d
    ....s diagdoctname=$p(^CTPCP(MRDIADocCodeDR,1),"^",2)
    ....s diagdoctno=$p(^CTPCP(MRDIADocCodeDR,1),"^")
   	...s diagname=$g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"DES",1))
    ...s diagtime=$zd($p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",7),3) //诊断时间
   	...s ICDCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",1)
    ...s diagcategorycode=1,diagcategoryname="西医",diagcode="",diagcodedn="",diseasecode="",diseasename=""
    ...i ICDCodeDR="" d
    ....s sympttcmcode="",sympttcmname=""
    ...i ICDCodeDR'="" d
    ....s sympttcmcode=$p(^MRC("ID",ICDCodeDR),"^",1)
    ....s sympttcmname=$p(^MRC("ID",ICDCodeDR),"^",2)
    ....s diagcategorycode=$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"2",:"1")
    ....s diagcategoryname =$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"中医",:"西医")
    ....s issympttcm=$p(^MRC("ID",ICDCodeDR),"^",13)
    ...q:issympttcm="N"
    ...s TYPChildsub="" f  s TYPChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub)) q:TYPChildsub=""  d
    ....s DTYPRowId=$p(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub),"^")
    ....s diagnametypecode=$p(^MRC("DTYP",DTYPRowId),"^")
    ...q:diagnametypecode="DIS"
    ....s diagnametypename=$p(^MRC("DTYP",DTYPRowId),"^",2)
    ...s dataid =AEpisodeID_"_"_j
    ...s j=j+1
    ...s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	...s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
    ...q:sympttcmname=""
	...s ^CacheTMP("InHospitalRecordtcmDiag",$j,i)=businessno_"^"_dataid_"^"_sympttcmname_"^"_sympttcmcode_"^"_diagtime_"^"_uploadtime
    ...s i=i+1
    q $j
}

/// 取门急诊中西医诊断
/// w ..GetOPErDiag("2019-03-01","2019-03-31")
ClassMethod GetOPErDiag(StartDate As %String, EndDate As %String) As %String
{

	s:StartDate=$c(0) StartDate=""
    s:EndDate=$c(0) EndDate=""
    s:StartDate="" StartDate=+$h-1
    s:EndDate="" EndDate=+$h-1
    s:StartDate["-" StartDate=$zdh(StartDate,3)
    s:EndDate["-" EndDate=$zdh(EndDate,3) 
	s i=0
	s AEpisodeID=""
	s (businessno,dataid,inhospname,inhospcode,istcmdiag,diagnametypecode,diagnametypename,diagcodedn,diagcode,diagtime,diagdoctname,diagdoctno,uploadtime)=""
	f tmpdate = StartDate:1:EndDate d
	.s AEpisodeID=""
	.f  s AEpisodeID= $o(^PAADMi("PAADM_AdmDate",tmpdate,AEpisodeID)) q:AEpisodeID=""   d 
	..s admtype=$P($g(^PAADM(AEpisodeID)),"^",2)
	..q:admtype="I"
	..s businessno= ..#HOSCode_"_"_AEpisodeID
    ..s MainMRAdmDR=$P($g(^PAADM(AEpisodeID)),"^",61)
    ..s j=0
   	..s MRDIAChildsub="" f  s MRDIAChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub))   q:MRDIAChildsub=""  d
    ...q:MRDIAChildsub=0
    ...s MRDIADocCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",4)
    ...s diagdoctname="-",diagdoctno="-"
    ...i MRDIADocCodeDR'="" d
    ....s diagdoctname=$p(^CTPCP(MRDIADocCodeDR,1),"^",2)
    ....s diagdoctno=$p(^CTPCP(MRDIADocCodeDR,1),"^")
   	...s diagname=$g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"DES",1))
    ...s diagtime=$zd($p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",7),3) //诊断时间
   	...s ICDCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",1)
    ...s diagcategorycode=1,diagcategoryname="西医",diagcode="",diagcodedn="",diseasecode="",diseasename=""
    ...s istcmdiag="0",issympttcm=""
    ...i ICDCodeDR="" d
    ....s diagcode="",diagcodedn=""
    ...i ICDCodeDR'="" d
    ....s diagcode=$p(^MRC("ID",ICDCodeDR),"^",1)
    ....s diagcodedn=$p(^MRC("ID",ICDCodeDR),"^",2)
    ....s diagcategorycode=$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"2",:"1")
    ....s diagcategoryname =$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"中医",:"西医")
    ....s issympttcm=$p($g(^MRC("ID",ICDCodeDR)),"^",13)
    ...q:issympttcm="Y"
    ...i diagcategoryname="中医" s istcmdiag="1"
    ...s TYPChildsub="" f  s TYPChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub)) q:TYPChildsub=""  d
    ....s DTYPRowId=$p(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub),"^")
    ....s diagnametypecode=$p(^MRC("DTYP",DTYPRowId),"^")
    ....s diagnametypename=$p(^MRC("DTYP",DTYPRowId),"^",2)
    ...q:diagnametypecode="DIS"
    ...s dataid =AEpisodeID_"_"_j
    ...s j=j+1
    ...s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	...s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
    ...q:diagcodedn=""
	...s ^CacheTMP("OpHospitalRecordDiag",$j,i)=businessno_"^"_dataid_"^"_inhospname_"^"_inhospcode_"^"_istcmdiag_"^"_diagnametypecode_"^"_diagnametypename_"^"_diagcodedn_"^"_diagcode_"^"_diagtime_"^"_diagdoctname_"^"_diagdoctno_"^"_uploadtime
    ...s i=i+1
    q $j
}

/// 取门急诊中医证候
/// w ##class(EMRservice.InterfaceService.EMRRecordCollectInterface).GeOPttmcErDiag("","")
ClassMethod GeOPttmcErDiag(StartDate As %String, EndDate As %String) As %String
{
	s:StartDate=$c(0) StartDate=""
    s:EndDate=$c(0) EndDate=""
    s:StartDate="" StartDate=+$h-1
    s:EndDate="" EndDate=+$h-1
    s:StartDate["-" StartDate=$zdh(StartDate,3)
    s:EndDate["-" EndDate=$zdh(EndDate,3)  
	s AEpisodeID=""
	s i=0
	s (businessno,dataid,sympttcmname,sympttcmcode,diagtime,uploadtime)=""
	f tmpdate = StartDate:1:EndDate d
	.s AEpisodeID=""
	.f  s AEpisodeID= $o(^PAADMi("PAADM_AdmDate",tmpdate,AEpisodeID)) q:AEpisodeID=""   d
	..s admtype=$P($g(^PAADM(AEpisodeID)),"^",2)
	..q:admtype="I"
	..s businessno= ..#HOSCode_"_"_AEpisodeID
    ..s MainMRAdmDR=$P($g(^PAADM(AEpisodeID)),"^",61)
    ..s j=0
   	..s MRDIAChildsub="" f  s MRDIAChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub))   q:MRDIAChildsub=""  d
    ...q:MRDIAChildsub=0
    ...s MRDIADocCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",4)
    ...s diagdoctname="-",diagdoctno="-"
    ...i MRDIADocCodeDR'="" d
    ....s diagdoctname=$p(^CTPCP(MRDIADocCodeDR,1),"^",2)
    ....s diagdoctno=$p(^CTPCP(MRDIADocCodeDR,1),"^")
   	...s diagname=$g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"DES",1))
    ...s diagtime=$zd($p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",7),3) //诊断时间
   	...s ICDCodeDR=$p($g(^MR(MainMRAdmDR,"DIA",MRDIAChildsub)),"^",1)
    ...s diagcategorycode=1,diagcategoryname="西医",diagcode="",diagcodedn="",diseasecode="",diseasename=""
    ...i ICDCodeDR="" d
    ....s sympttcmcode="",sympttcmname=""
    ...i ICDCodeDR'="" d
    ....s sympttcmcode=$p(^MRC("ID",ICDCodeDR),"^",1)
    ....s sympttcmname=$p(^MRC("ID",ICDCodeDR),"^",2)
    ....s diagcategorycode=$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"2",:"1")
    ....s diagcategoryname =$case($p(^MRC("ID",ICDCodeDR),"^",15),"Y":"中医",:"西医")
    ....s issympttcm=$p(^MRC("ID",ICDCodeDR),"^",13)
    ...q:issympttcm="N"
    ...s TYPChildsub="" f  s TYPChildsub=$o(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub)) q:TYPChildsub=""  d
    ....s DTYPRowId=$p(^MR(MainMRAdmDR,"DIA",MRDIAChildsub,"TYP",TYPChildsub),"^")
    ....s diagnametypecode=$p(^MRC("DTYP",DTYPRowId),"^")
    ...q:diagnametypecode="DIS"
    ....s diagnametypename=$p(^MRC("DTYP",DTYPRowId),"^",2)
    ...s dataid =AEpisodeID_"_"_j
    ...s j=j+1
    ...s curDate = $ZDATE($h,3)_" "_ $ZTIME($PIECE($H,",",2),1)
	...s uploadtime= ##Class(EPRservice.BOScatterData).GetDataByFormat(curDate,"DT15","1")
    ...q:sympttcmname=""
	...s ^CacheTMP("OPHospitalRecordtcmDiag",$j,i)=businessno_"^"_dataid_"^"_sympttcmname_"^"_sympttcmcode_"^"_diagtime_"^"_uploadtime
    ...s i=i+1
    q $j
}

/// Desc：	取病年龄(年)，
ClassMethod GetAgeyear(AEpisodeID As %String) As %String
{
	s PAPMIDR=$p(^PAADM(AEpisodeID),"^")
	s Birth=$P($G(^PAPER(PAPMIDR,"ALL")),"^",6)  //出生日期
	s PAADMAdmDate=$p(^PAADM(AEpisodeID),"^",6)
	s AgeStr=$$CalAge^at182(Birth,PAADMAdmDate,"","","") //年龄 
	s ageyear=$P(AgeStr,"|",12)
	q ageyear
}

/// Desc：	取病年龄(月)，
ClassMethod GetAgemonth(AEpisodeID As %String) As %String
{
	s PAPMIDR=$p(^PAADM(AEpisodeID),"^")
	s Birth=$P($G(^PAPER(PAPMIDR,"ALL")),"^",6)  //出生日期
	s PAADMAdmDate=$p(^PAADM(AEpisodeID),"^",6)
	s AgeStr=$$CalAge^at182(Birth,PAADMAdmDate,"","","") //年龄 
	s agemonth=$P(AgeStr,"|",13)
	q agemonth
}

/// Desc：	取病年龄(天)，
ClassMethod GetAgeday(AEpisodeID As %String) As %String
{
	s PAPMIDR=$p(^PAADM(AEpisodeID),"^")
	s Birth=$P($G(^PAPER(PAPMIDR,"ALL")),"^",6)  //出生日期
	s PAADMAdmDate=$p(^PAADM(AEpisodeID),"^",6)
	s AgeStr=$$CalAge^at182(Birth,PAADMAdmDate,"","","") //年龄 
	s ageday=$P(AgeStr,"|",14)
	q ageday
}

/// Desc：	婚姻状况名称，
ClassMethod Getmaritalname(maritalcode As %String) As %String
{
	//婚姻状况名称 AN..50 有则必填
	s maritalname = ""
	s:maritalcode="10" maritalname="未婚"
	s:maritalcode="20" maritalname="已婚"
	s:maritalcode="21" maritalname="初婚"
	s:maritalcode="22" maritalname="再婚"
	s:maritalcode="23" maritalname="复婚"
	s:maritalcode="30" maritalname="丧偶"
	s:maritalcode="40" maritalname="离婚"
	s:maritalcode="90" maritalname="未说明的婚姻状况"
	q maritalname
}

/// Desc：	是否医保患者
ClassMethod Getwhetherguaranpatients(AEpisodeID As %String) As %String
{
	//是否医保患者
	s whetherguaranpatients= ""
	s PAADMAdmReasonDR=$p(^PAADM(AEpisodeID,1),"^",7)
	s whetherguaranpatients= $p($g(^PAC("ADMREA",PAADMAdmReasonDR)),"^",9)
	s:whetherguaranpatients="" whetherguaranpatients="0" 
	q whetherguaranpatients
}

/// Desc：	治疗结果名称
ClassMethod Gettreatresname(AEpisodeID As %String) As %String
{
	//治疗结果名称
	s treatresname= ""
	s DisconId=$p(^PAADM(AEpisodeID),"^",49)
    i DisconId'="" s treatresname=$p(^PAC("DISCON",DisconId),"^",2)
	q treatresname
}

/// Desc： 治疗结果代码
ClassMethod Gettreatrescode(AEpisodeID As %String) As %String
{
	//治疗结果代码
	s treatrescode= ""
	s DisconId=$p(^PAADM(AEpisodeID),"^",49)
    i DisconId'="" s treatrescode=$p(^PAC("DISCON",DisconId),"^",1)
	q treatrescode
}

/// Desc： 病案号
ClassMethod Getmedirecno(AEpisodeID As %String) As %String
{
	//治疗结果代码
	s medirecno= ""
	s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
    s medirecno=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(argPapmiDR,"I","")
	q medirecno
}

/// Desc： 接诊医生编号 
ClassMethod Getacceptdoctno(AEpisodeID As %String) As %String
{
	//接诊医生编号 
	s acceptdoctno= ""
	s AdmDocCodeDR=$p(^PAADM(AEpisodeID),"^",9)
    s acceptdoctno=""
    i AdmDocCodeDR'="" d
    .s acceptdoctno=$p(^CTPCP(AdmDocCodeDR,1),"^") //接诊医生编号 
	q acceptdoctno
}

/// Desc： 接诊医生签名 
ClassMethod Getacceptdoctname(AEpisodeID As %String) As %String
{
	//接诊医生签名 
	s acceptdoctname= ""
	s AdmDocCodeDR=$p(^PAADM(AEpisodeID),"^",9)
    s acceptdoctname=""
    i AdmDocCodeDR'="" d
    .s acceptdoctname=$p(^CTPCP(AdmDocCodeDR,1),"^",2)  //接诊医生签名 
	q acceptdoctname
}

/// Desc： 性别代码
ClassMethod Getgendercode(AEpisodeID As %String) As %String
{
	//性别代码
	s gendercode= ""
	s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
	s gendercodedr= $p($g(^PAPER(argPapmiDR,"ALL")),"^",7)
	s gendercode = $p($g(^CT("SEX",gendercodedr)),"^",1)
	q gendercode
}

/// Desc： 性别名称
ClassMethod Getgendername(AEpisodeID As %String) As %String
{
	//性别名称
	s gendername= ""
	s argPapmiDR=$p(^PAADM(AEpisodeID),"^",1)
	s gendercodedr= $p($g(^PAPER(argPapmiDR,"ALL")),"^",7)
	s gendername = $p($g(^CT("SEX",gendercodedr)),"^",2)
	q gendername
}

/// Desc： 首诊医师编号
ClassMethod Getdoctno(AEpisodeID As %String) As %String
{
	//首诊医师编号
	s doctno= ""
	s doctnodr = $p($g(^PAADM(AEpisodeID)),"^",9)
	i doctnodr'="" s doctno=$p($g(^CTPCP(doctnodr,1)),"^",1)
	s:doctno="" doctno="-"	
	q doctno
}

/// Desc： 首诊医师签名
ClassMethod Getdoctname(AEpisodeID As %String) As %String
{
	//首诊医师签名
	s doctname= ""
	s doctnodr = $p($g(^PAADM(AEpisodeID)),"^",9)	
	i doctnodr'="" s doctname = $p($g(^CTPCP(doctnodr,1)),"^",2)
	s:doctname="" doctname="-"
	q doctname
}

}
