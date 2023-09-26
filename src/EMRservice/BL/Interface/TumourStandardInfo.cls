Class EMRservice.BL.Interface.TumourStandardInfo Extends %RegisteredObject
{

/// Creator：	YK
/// CreateDate：2021-11-04
/// Desc：		入院记录
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetAdmRecordInfo","2020-07-14","2020-07-14")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetAdmRecordInfo("2019-10-01","2019-10-02")
Query GetAdmRecordInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,medical_record_no,inpatient_no,hospitalization_times,record_sn,record_datetime,kps_score,ecog_score,record_text,chief_complaint,current_medhistory,past_medhistory,personal_medhistory,family_history,marriage_birth_history,menstrual_history,systolic_pressure,diastolic_pressure,respiratory_rate,body_temperature,heart_rate,height,weight,body_surface_area,physical_exam,special_exam,auxiliary_exam,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc ]
{
}

ClassMethod GetAdmRecordInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				continue:(objInstance.Title'["入院记录")
				continue:(objInstance.Title["24")
				
	            // 初始化字段
				s (patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,kpsscore,ecogscore,recordtext,chiefcomplaint,currentmedhistory,pastmedhistory,personalmedhistory,familyhistory,marriagebirthhistory,menstrualhistory,systolicpressure,diastolicpressure,respiratoryrate,bodytemperature,heartrate,height,weight,bodysurfacearea,physicalexam,specialexam,auxiliaryexam,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME) = ""
				
				// 通过就诊号取病历信息
				// 登记RowId
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
		        //q:CurrDeptDR'=204
		        
		        // 登记号
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
		        
				s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.13.01")
				
				s patientid = RegisterNo ;	患者ID	患者在本院的唯一标识
				s visitsn = Adm ;	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|住院
				s medicalrecordno = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm) ;	病案号	患者在本院就诊时使用的病案号
				s inpatientno = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm) ;	住院号	患者住院号
				// 住院次数
				s Intimes = ##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm)
				s hospitalizationtimes = Intimes ;	住院次数	
				
				s recordsn = InstanceID ;	入院记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符"|"进行拼接
				s recorddatetime = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) ;	入院记录创建时间	
				s kpsscore = "" ;	KPS评分	Karnofsky功能状态评分标准
				s ecogscore = "" ;	ECOG PS评分	体力状况ECOG评分标准 Zubrod-ECOG-WHO
				s recordtext = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID) ;	文书内容	上传对应完整文书内容(需要包括主诉、现病史、既往史、个人史、婚育史、家族史、月经史、体格检查、专科检查、辅助检查等信息)，如果能够将文书内容拆分或者分开存储，则需要填写下面对应文书内容。
				s chiefcomplaint = arr.GetAt("HDSD00.13.114") ;	主诉	
				s currentmedhistory = arr.GetAt("HDSD00.13.095") ;	现病史	
				s pastmedhistory = arr.GetAt("HDSD00.13.300") ;	既往史	
				s personalmedhistory = arr.GetAt("HDSD00.13.036") ;	个人史	
				s familyhistory = arr.GetAt("HDSD00.13.043") ;	家族史	
				s marriagebirthhistory = arr.GetAt("HDSD00.13.041") ;	婚育史	
				s menstrualhistory = arr.GetAt("HDSD00.13.106") ;	月经史	女性患者需填写
				s systolicpressure = arr.GetAt("HDSD00.13.085") ;	收缩压	单位：mmHg
				s diastolicpressure = arr.GetAt("HDSD00.13.086") ;	舒张压	单位：mmHg
				s respiratoryrate = arr.GetAt("HDSD00.13.077") ;	呼吸	单位：次每分钟
				s bodytemperature = arr.GetAt("HDSD00.13.088") ;	体温	单位：摄氏度
				s heartrate = "" ;	心率	单位：次每分钟
				s height = arr.GetAt("HDSD00.13.083") ;	身高	单位：厘米
				s weight = arr.GetAt("HDSD00.13.089") ;	体重	单位：千克
				s bodysurfacearea = "" ;	体表面积	单位：平方米
				s:(arr.GetAt("HDSD00.13.094")'="") physicalexam = "一般状况检查结果："_arr.GetAt("HDSD00.13.094") ;	体格检查
				s:(arr.GetAt("HDSD00.13.081")'="") physicalexam = physicalexam_"  皮肤和粘膜检查结果："_arr.GetAt("HDSD00.13.081")
				s:(arr.GetAt("HDSD00.13.082")'="") physicalexam = physicalexam_"  全身浅表淋巴检查结果："_arr.GetAt("HDSD00.13.082")
				s:(arr.GetAt("HDSD00.13.091")'="") physicalexam = physicalexam_"  头部及其器官检查结果："_arr.GetAt("HDSD00.13.091")
				s:(arr.GetAt("HDSD00.13.079")'="") physicalexam = physicalexam_"  颈部检查结果："_arr.GetAt("HDSD00.13.079")
				s:(arr.GetAt("HDSD00.13.093")'="") physicalexam = physicalexam_"  胸部检查结果："_arr.GetAt("HDSD00.13.093")
				s:(arr.GetAt("HDSD00.13.075")'="") physicalexam = physicalexam_"  腹部检查结果："_arr.GetAt("HDSD00.13.075")
				s:(arr.GetAt("HDSD00.13.076")'="") physicalexam = physicalexam_"  肛门指诊检查结果："_arr.GetAt("HDSD00.13.076")
				s:(arr.GetAt("HDSD00.13.092")'="") physicalexam = physicalexam_"  外生殖器检查结果："_arr.GetAt("HDSD00.13.092")
				s:(arr.GetAt("HDSD00.13.078")'="") physicalexam = physicalexam_"  脊柱检查结果："_arr.GetAt("HDSD00.13.078")
				s:(arr.GetAt("HDSD00.13.087")'="") physicalexam = physicalexam_"  四肢检查结果："_arr.GetAt("HDSD00.13.087")
				s:(arr.GetAt("HDSD00.13.084")'="") physicalexam = physicalexam_"  神经系统检查结果："_arr.GetAt("HDSD00.13.084")
				s specialexam = arr.GetAt("HDSD00.13.200") ;	专科检查	部分医院为“肿瘤情况”
				s auxiliaryexam = arr.GetAt("HDSD00.13.035") ;	辅助检查
				
				s extenddata1 = "" ;	扩展字段1	用于填写补充信息
				s extenddata2 = "" ;	扩展字段2	用于填写补充信息
				s recordstatus = "1" ;	记录状态	1正常 0作废
				s YYID = InstanceID // 数据唯一标识
				s modifydata=objInstance.ModifyDate
				s modifytime=objInstance.ModifyTime
				s updatedatetime=""
				if modifydata'="" d
				.s updatedatetime=$ZD(modifydata,3)_" "_$ZT(modifytime)
				else 
				.s updatedatetime=$ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime)
				
				s YYUPDATETIME = updatedatetime //$ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
				s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
				
				set ^CacheTemp(repid, ind) = $LB(patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,kpsscore,ecogscore,recordtext,chiefcomplaint,currentmedhistory,pastmedhistory,personalmedhistory,familyhistory,marriagebirthhistory,menstrualhistory,systolicpressure,diastolicpressure,respiratoryrate,bodytemperature,heartrate,height,weight,bodysurfacearea,physicalexam,specialexam,auxiliaryexam,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME)
				set ind = ind + 1
        	}
        }
	}
	
	Quit $$$OK
}

ClassMethod GetAdmRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmRecordInfoExecute ]
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

ClassMethod GetAdmRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-11-04
/// Desc：		入院记录诊断
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetAdmRecordDiagInfo","2020-07-14","2020-07-20")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetAdmRecordDiagInfo("2020-07-14","2020-07-14")
Query GetAdmRecordDiagInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "diag_type,maindiag_mark,DIAG_CODE,DIAG_NAME,record_status,record_datetime,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME,patient_id,visit_sn,FK_YY_ID") [ SqlProc ]
{
}

ClassMethod GetAdmRecordDiagInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				continue:(objInstance.Title'["入院记录")
				continue:(objInstance.Title["24")
				
	            // 初始化字段
				s (diagtype,maindiagmark,DIAGCODE,DIAGNAME,recordstatus,recorddatetime,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID) = ""
				
				// 通过就诊号取病历信息
				// 登记RowId
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
		        //q:CurrDeptDR'=204 
		        
		        // 登记号
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
		        
				s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.13.01")
				s ALLDiagDesc = arr.GetAt("HDSD00.13.023")
				s lenth = $L(ALLDiagDesc,$C(10))
				For iDiag = 1:1:lenth
				{
					s diagtype = "入院初步诊断" // 诊断类型
					s:(iDiag=2) maindiagmark = "否" // 是否主要诊断
					s:(iDiag=1) maindiagmark = "是"
					s DIAGCODE = $P(ALLDiagDesc,$C(10),iDiag) // 诊断编码
					s DIAGNAME = $P(ALLDiagDesc,$C(10),iDiag) // 诊断名称
					s:DIAGCODE'="" DIAGCODE=$tr(DIAGCODE," ","")
					s:DIAGNAME'="" DIAGNAME=$tr(DIAGNAME," ","")
					q:DIAGCODE=""
					s recordstatus = "1" // 记录状态
					s YYID = InstanceID // 数据唯一标识
					s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
					s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
					s recorddatetime=$ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime)
					s patientid = RegisterNo // 患者ID
					s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
					s FKYYID = InstanceID // B051唯一数据标识YYID关联
					s recorddatetime=$ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime)
					set ^CacheTemp(repid, ind) = $LB(diagtype,maindiagmark,DIAGCODE,DIAGNAME,recordstatus,recorddatetime,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID)
					set ind = ind + 1
				}
        	}
        }
	}
	
	Quit $$$OK
}

ClassMethod GetAdmRecordDiagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmRecordDiagInfoExecute ]
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

ClassMethod GetAdmRecordDiagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmRecordDiagInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK、WEP
/// CreateDate：2020-08-28
/// Desc：		病程记录
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetCourseRecordInfo","2020-08-28","2020-08-28")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetCourseRecordInfo("2020-08-28","2020-08-28")
Query GetCourseRecordInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,medical_record_no,inpatient_no,hospitalization_times,record_sn,record_datetime,record_title_code,record_title,record_content,extend_data1,extend_data2,record_status") [ SqlProc ]
{
}

ClassMethod GetCourseRecordInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				continue:(objInstance.TitleCode'="")
				continue:((objInstance.Title'["ICU病程记录")&&(objInstance.Title'["输血记录")&&(objInstance.Title'["接班记录")&&(objInstance.Title'["交班记录")&&(objInstance.Title'["抢救记录")&&(objInstance.Title'["术后病程")&&(objInstance.Title'["手术记录")&&(objInstance.Title'["术前讨论记录")&&(objInstance.Title'["术前小结")&&(objInstance.Title'["阶段小结")&&(objInstance.Title'["病程记录")&&(objInstance.Title'["首次病程")&&(objInstance.Title'["手术记录")&&(objInstance.Title'["患者术后病情再评估记录表"))
				
				s AdmType = $P(^PAADM(Adm),"^",2)
				continue:(AdmType'="I")
				
				s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
		        //q:CurrDeptDR'=204 
		        
				// 登记RowId        [PapmiDR]            PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        // 登记号            [RegisterNo]        PA_PatMas.PAPMI_No
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	        	
	            // 初始化字段
				s (patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,recordtitlecode,recordtitle,recordcontent,extenddata1,extenddata2,recordstatus) = ""
				
				s patientid = RegisterNo    ;	患者ID	患者在本院的唯一标识
				s visitsn = Adm    ;	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|住院
				// 住院病案号
				s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm)
				s medicalrecordno = IPRecordNo    ;	病案号	患者在本院就诊时使用的病案号
				s inpatientno = IPRecordNo    ;	住院号	患者住院号
				// 西医病案首页住院次数
				s Intimes =##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm)
				s hospitalizationtimes = Intimes ;	住院次数	
				s recordsn = InstanceID    ;	病程记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符“|”进行拼接。
				s recorddatetime = $ZD(objInstance.HappenDate,3)_" "_$ZT(objInstance.HappenTime,1)    ;	病程记录时间	"本业务数据在医院系统中的实际产生时间 yyyy-MM-dd HH:mm:ss"
				s recordtitlecode = objInstance.TitleCode    ;	病程记录类型代码	
				s recordtitle = objInstance.Title    ;	病程记录类型	包括首次病程记录、日常病程记录、死亡记录、上级医师查房记录、疑难病例讨论记录、交（接）班记录、转科记录、阶段小结、抢救记录、有创操作记录、会诊记录、术前小结、术前讨论记录、术后病程记录、手术过程描述、化疗小结等
				s recordcontent = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID)    ;	病程记录	
				s extenddata1 = ""    ;	扩展字段1	用于填写补充信息
				s extenddata2 = ""    ;	扩展字段2	用于填写补充信息
				s recordstatus = "1"    ;	记录状态	1正常 0作废
				b ;02
				set ^CacheTemp(repid, ind) = $LB(patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,recordtitlecode,recordtitle,recordcontent,extenddata1,extenddata2,recordstatus)
				set ind = ind + 1
			}
        }
	} 
	
	Quit $$$OK
}

ClassMethod GetCourseRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCourseRecordInfoExecute ]
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

ClassMethod GetCourseRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCourseRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK、WEP
/// CreateDate：2020-08-28
/// Desc：		出院记录
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetDischargeRecordInfo","2020-08-28","2020-08-28")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetDischargeRecordInfo("2020-08-28","2020-08-28")
Query GetDischargeRecordInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,medical_record_no,inpatient_no,hospitalization_times,record_sn,record_datetime,admission_datetime,discharge_order,discharge_datetime,length_of_stay,kps_score,ecog_score,record_text,admission_condition,treatment_info,discharge_condition,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc ]
{
}

ClassMethod GetDischargeRecordInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				continue:(objInstance.Title'["出院记录")
				continue:(objInstance.Title["24")
				
				s AdmType = $P(^PAADM(Adm),"^",2)
				continue:(AdmType'="I")
				
				s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
		        //q:CurrDeptDR'=204 
		        
				// 登记RowId        [PapmiDR]            PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        // 登记号            [RegisterNo]        PA_PatMas.PAPMI_No
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
         
	            // 初始化字段
				s (patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,admissiondatetime,dischargeorder,dischargedatetime,lengthofstay,kpsscore,ecogscore,recordtext,admissioncondition,treatmentinfo,dischargecondition,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME) = ""
				
				s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.16")
				
				s patientid = RegisterNo    ; 	患者ID	患者在本院的唯一标识
				s visitsn = Adm    ; 	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|就诊类型名称
				// 住院病案号
				s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm)
				s medicalrecordno = IPRecordNo    ;	病案号	患者在本院就诊时使用的病案号
				s inpatientno = IPRecordNo    ;	住院号	患者住院号
				// 西医病案首页住院次数
				s Intimes = ##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm)
				s hospitalizationtimes = Intimes ;	住院次数	
				s recordsn = InstanceID    ; 	出院记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符"|"进行拼接。
				s recorddatetime = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime,1)    ; 	出院记录创建时间	
				s admissiondatetime = ##class(EMRmeta.Data.Method.Tools).ToTS(arr.GetAt("HDSD00.16.031"),"3","1")    ; 	入院时间	"本次就诊入院时间yyyy-MM-dd HH:mm:ss"
				s dischargeorder = arr.GetAt("HDSD00.16.007")    ; 	出院医嘱	出院医嘱、随诊要求等
				s dischargedatetime = ##class(EMRmeta.Data.Method.Tools).ToTS(arr.GetAt("HDSD00.16.005"),"3","1")    ; 	出院时间	"本次就诊出院时间yyyy-MM-dd HH:mm:ss"
				s lengthofstay = arr.GetAt("HDSD00.16.036")    ; 	实际住院天数	本次就诊住院总天数
				s kpsscore = ""    ; 	KPS评分	Karnofsky功能状态评分标准
				s ecogscore = ""    ; 	ECOG PS评分	体力状况ECOG评分标准 Zubrod-ECOG-WHO
				s recordtext = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID)    ; 	文书内容	上传对应完整文书内容(出院记录)
				s admissioncondition = arr.GetAt("HDSD00.16.030")    ; 	入院情况	主要症状和体征及辅助检查摘要
				s admissioncondition=$tr(admissioncondition," ","")
				s treatmentinfo = arr.GetAt("HDSD00.16.045")    ; 	诊疗经过	主要治疗方式、方案及病情演变、抢救经过等
				s treatmentinfo=$tr(treatmentinfo," ","")
				s dischargecondition = arr.GetAt("HDSD00.16.004")    ; 	出院情况	出院时病情、主要检查结果及治疗结果等
				s dischargecondition=$tr(dischargecondition," ","")
				s extenddata1 = ""    ; 	扩展字段1	用于填写补充信息
				s extenddata2 = ""    ; 	扩展字段2	用于填写补充信息
				s recordstatus = "1"    ; 	记录状态	1正常 0作废
				s YYID = InstanceID // 数据唯一标识
				s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
				s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
				
				set ^CacheTemp(repid, ind) = $LB(patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,admissiondatetime,dischargeorder,dischargedatetime,lengthofstay,kpsscore,ecogscore,recordtext,admissioncondition,treatmentinfo,dischargecondition,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME)
				set ind = ind + 1
			}
        }
	} 
	
	Quit $$$OK
}

ClassMethod GetDischargeRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDischargeRecordInfoExecute ]
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

ClassMethod GetDischargeRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDischargeRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-11-04
/// Desc：		出院记录诊断
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetDischargeRecordDiagInfo","2020-07-14","2020-07-14")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetDischargeRecordDiagInfo("2020-07-16","2020-07-18")
Query GetDischargeRecordDiagInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "DIAG_TYPE,MAINDIAG_MARK,DIAG_CODE,DIAG_NAME,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME,patient_id,visit_sn,FK_YY_ID") [ SqlProc ]
{
}

ClassMethod GetDischargeRecordDiagInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				continue:(objInstance.Title'["出院记录")
				continue:(objInstance.Title["24")
				
				s AdmType = $P(^PAADM(Adm),"^",2)
				continue:(AdmType'="I")
				
				s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
		        //q:CurrDeptDR'=204 
		        
	            // 初始化字段
				s (diagtype,maindiagmark,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID) = ""
				
				// 通过就诊号取病历信息
				// 登记RowId
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        // 登记号
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
		        
				s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.16")
				s ALLAdmDiagDesc = arr.GetAt("HDSD00.16.032")
				s lenth = $L(ALLAdmDiagDesc,$C(10))
				/**For iDiag = 1:1:lenth
				{
					s DIAGTYPE = "入院诊断" // 诊断类型
					s:(iDiag=2) maindiagmark = "否" // 是否主要诊断
					s:(iDiag=1) maindiagmark = "是"
					s DIAGCODE = $P(ALLAdmDiagDesc,$C(10),iDiag) // 诊断编码
					s DIAGNAME = $P(ALLAdmDiagDesc,$C(10),iDiag) // 诊断名称
					s recordstatus = "1" // 记录状态
					s YYID = InstanceID // 数据唯一标识
					s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
					s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
					s patientid = RegisterNo // 患者ID
					s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
					s FKYYID = InstanceID // B051唯一数据标识YYID关联
					
					set ^CacheTemp(repid, ind) = $LB(DIAGTYPE,MAINDIAGMARK,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID)
					set ind = ind + 1
				}
				**/
				s ALLDisDiagDesc = arr.GetAt("HDSD00.16.008")
				s lenth = $L(ALLDisDiagDesc,$C(10))
				For iDiag = 1:1:lenth
				{
					s DIAGTYPE = "出院诊断" // 诊断类型
					s:(iDiag=2) maindiagmark = "否" // 是否主要诊断
					s:(iDiag=1) maindiagmark = "是"
					s DIAGCODE = $P(ALLDisDiagDesc,$C(10),iDiag) // 诊断编码
					s DIAGNAME = $P(ALLDisDiagDesc,$C(10),iDiag) // 诊断名称
					s:DIAGCODE'="" DIAGCODE=$tr(DIAGCODE," ","")
					s:DIAGNAME'="" DIAGNAME=$tr(DIAGNAME," ","")
					q:DIAGCODE=""
					s recordstatus = "1" // 记录状态
					s YYID = InstanceID_"||"_iDiag // 数据唯一标识
					s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
					s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
					s patientid = RegisterNo // 患者ID
					s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
					s FKYYID = InstanceID // B051唯一数据标识YYID关联
					
					set ^CacheTemp(repid, ind) = $LB(DIAGTYPE,maindiagmark,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID)
					set ind = ind + 1
				}
        	}
        }
	}
	
	Quit $$$OK
}

ClassMethod GetDischargeRecordDiagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDischargeRecordDiagInfoExecute ]
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

ClassMethod GetDischargeRecordDiagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDischargeRecordDiagInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK、WEP
/// CreateDate：2020-08-28
/// Desc：		门诊病历记录
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetOutPatientRecordInfo","2020-08-28","2020-08-28")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetOutPatientRecordInfo("2020-08-28","2020-08-28")
Query GetOutPatientRecordInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "patient_id,visit_sn,visit_type,visit_card_no,outpatient_no,visit_times,visit_datetime,record_sn,record_datetime,record_text,treatment_info,operation_info,chief_complaint,current_medhistory,past_medhistory,personal_medhistory,family_history,marriage_birth_history,menstrual_history,physical_exam,tcm_disease_name,tcm_syndrome_name,diagnose_datetime,extend_data1,extend_data2,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME") [ SqlProc ]
{
}

ClassMethod GetOutPatientRecordInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				s Title = objInstance.Title
				continue:(Title'["门诊病历")
				
				S AdmType =  $p(^PAADM(Adm),"^",2)
				continue:((AdmType'="O")&&(AdmType'="E"))
				
				// 通过就诊号取病历信息
				// 登记RowId        [PapmiDR]            PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        // 登记号            [RegisterNo]        PA_PatMas.PAPMI_No
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
 		
	            // 初始化字段
				s (patientid,visitsn,visittype,visitcardno,outpatientno,visittimes,visitdatetime,recordsn,recorddatetime,recordtext,treatmentinfo,operationinfo,chiefcomplaint,currentmedhistory,pastmedhistory,personalmedhistory,familyhistory,marriagebirthhistory,menstrualhistory,physicalexam,tcmdiseasename,tcmsyndromename,diagnosedatetime,extenddata1,extenddata2,recordstatus) = ""
				
				s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.03.01")
				s AdmDate="",AdmTime="",admissionDateTime=""
			    set AdmDate=$P(^PAADM(Adm),"^",6)
	            set:AdmDate'="" AdmDate=$zd(AdmDate,3)
                set AdmTime=$P(^PAADM(Adm),"^",7)
	            set:AdmTime'="" AdmTime=$zt(AdmTime)
	            set admissionDateTime=AdmDate_" "_AdmTime
				
				s patientid = RegisterNo    ;  	患者ID	患者在本院的唯一标识
				s visitsn = Adm    ;  	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|门诊号|就诊次数|就诊类型。
				s visittype = $CASE(AdmType,"O":"门诊","E":"急诊")    ;  	就诊类型	就诊类型：门诊、急诊
				s visitcardno = RegisterNo    ;  	就诊卡号	患者在本医院就诊时使用的就诊卡号
				s outpatientno = $P(^PAPER(PapmiDR,"PAT",1),"^",22)    ;  	门诊号	患者门诊就诊时对应的门诊号或者病历号
				s visittimes = ..GetOPTimesByAdm(PapmiDR,Adm)    ;  	就诊次数	本院门诊次数
				s visitdatetime = admissionDateTime ;##class(EMRmeta.Data.Method.Tools).ToTS(arr.GetAt("HDSD00.03.023"),"3","1")    ;  	就诊时间	符合【yyyy-MM-dd HH:mm:ss】的格式
				s recordsn = InstanceID    ;  	病历记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符"|"进行拼接。
				s recorddatetime = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime,1)    ;  	病历记录时间	符合【yyyy-MM-dd HH:mm:ss】的格式
				s recordtext = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID)    ;  	病历文书内容	上传对应完整文书内容(需要包括主诉、现病史、既往史、个人史、婚育史、家族史、月经史、体格检查等信息)，如果能够将文书内容拆分或者分开存储，则需要填写下面对应文书内容。
				s treatmentinfo = ""    ;  	诊疗经过	
				s operationinfo = ""    ;  	操作记录	
				s chiefcomplaint = arr.GetAt("HDSD00.03.057")    ;  	主诉	
				s currentmedhistory = arr.GetAt("HDSD00.03.038")    ;  	现病史	
				s pastmedhistory = arr.GetAt("HDSD00.03.021")    ;  	既往史	
				s personalmedhistory = ""    ;  	个人史	
				s familyhistory = arr.GetAt("HDSD00.03.210")    ;  	家族史	
				s marriagebirthhistory = ""    ;  	婚育史	
				s menstrualhistory = ""    ;  	月经史	
				s physicalexam = arr.GetAt("HDSD00.03.037")    ;  	体格检查	
				s tcmdiseasename = arr.GetAt("HDSD00.03.007")    ;  	中医病名	
				s tcmsyndromename = arr.GetAt("HDSD00.03.009")    ;  	中医证候	
				
				s OPDiagInfos = ##class(EMRmeta.Data.Method.Tools).GetMRDiagnoseListForEMR(Adm,"2","OP")
				s OPDiagInfos = OPDiagInfos_$C(1)_##class(EMRmeta.Data.Method.Tools).GetMRDiagnoseListForEMR(Adm,"1","OP")
				s diagnosedatetime = $P($P(OPDiagInfos,$C(1),1),"^",8)_" "_$P($P(OPDiagInfos,$C(1),1),"^",9)    ;  	诊断时间	符合【yyyy-MM-dd HH:mm:ss】的格式
				
				s diagcoden = ""    ;  	诊断编码-N	填写除诊断编码1-10以外的其他诊断编码，两编码之间用“|”隔开。
				s diagnamen = ""    ;  	诊断名称-N	填写除诊断编码1-10以外的其他诊断名称，两诊断之间用“|”隔开。
				s extenddata1 = ""    ;  	扩展字段1	用于填写补充信息
				s extenddata2 = ""    ;  	扩展字段2	用于填写补充信息
				s recordstatus = "1"    ;  	记录状态	1正常 0作废
				s YYID = InstanceID // 数据唯一标识
				s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
				s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
				
				set ^CacheTemp(repid, ind) = $LB(patientid,visitsn,visittype,visitcardno,outpatientno,visittimes,visitdatetime,recordsn,recorddatetime,recordtext,treatmentinfo,operationinfo,chiefcomplaint,currentmedhistory,pastmedhistory,personalmedhistory,familyhistory,marriagebirthhistory,menstrualhistory,physicalexam,tcmdiseasename,tcmsyndromename,diagnosedatetime,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME)
				set ind = ind + 1
			}
        }
	}
	
	Quit $$$OK
}

ClassMethod GetOutPatientRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutPatientRecordInfoExecute ]
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

ClassMethod GetOutPatientRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutPatientRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-11-04
/// Desc：		门诊病历诊断
/// Input:		ASatrtDate —— 开始时间           AEndDate —— 结束时间
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.TumourStandardInfo","GetOPRecordDiagInfo","2020-08-28","2020-08-28")
/// 			CALL EMRservice_BL_Interface.TumourStandardInfo_GetOPRecordDiagInfo("2020-08-28","2020-08-28")
Query GetOPRecordDiagInfo(ASatrtDate As %String, AEndDate As %String) As %Query(ROWSPEC = "MAINDIAG_MARK,DIAG_CODE,DIAG_NAME,record_status,YY_ID,YY_UPDATE_TIME,YY_CREATE_TIME,patient_id,visit_sn,FK_YY_ID") [ SqlProc ]
{
}

ClassMethod GetOPRecordDiagInfoExecute(ByRef qHandle As %Binary, ASatrtDate As %String, AEndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(ASatrtDate="")||(AEndDate="") $$$OK
	
	s StartDate = $ZDH(ASatrtDate,3)
	s EndDate = $ZDH(AEndDate,3)
	
	For iDate = StartDate:1:EndDate
	{
		s TheECRecord = ""
		For
		{
			// ^DHCEMRI.InstanceDataI("IdxModifyDate")
			s TheECRecord=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord))
			q:(TheECRecord="")
			
			s Sub=""
			For
			{
				s Sub=$O(^DHCEMRI.InstanceDataI("IdxModifyDate",iDate,TheECRecord,Sub))
				q:(Sub="")
				
				s InstanceID = $TR(TheECRecord_"||"_Sub," ","")
				s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
				s status = objInstance.Status
				continue:(status'="Save")
				
				s Adm = objInstance.EpisodeID
				S AdmType =  $p(^PAADM(Adm),"^",2)
				continue:((AdmType'="O")&&(AdmType'="E"))
				
				s Title = objInstance.Title
				continue:(Title'["门诊病历")
				
				s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
		        //q:CurrDeptDR'=204 
		        
	            // 初始化字段
				s (MAINDIAGMARK,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID) = ""
				
				// 通过就诊号取病历信息
				// 登记RowId
		        s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
		        // 登记号
		        s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
		      
				s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.03.01")
				s ALLDiagDesc = arr.GetAt("HDSD00.03.005")
				s lenth = $L(ALLDiagDesc,$C(10))
				For iDiag = 1:1:lenth
				{
					s:(iDiag=2) MAINDIAGMARK = "否" // 是否主要诊断
					s:(iDiag=1) MAINDIAGMARK = "是"
					s DIAGCODE = $P(ALLDiagDesc,$C(10),iDiag) // 诊断编码
					s DIAGNAME = $P(ALLDiagDesc,$C(10),iDiag) // 诊断名称
					s recordstatus = "1" // 记录状态
					s YYID = InstanceID_"||"_iDiag // 数据唯一标识
					s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
					s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
					s patientid = RegisterNo // 患者ID
					s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
					s FKYYID = InstanceID // B051唯一数据标识YYID关联
					
					set ^CacheTemp(repid, ind) = $LB(MAINDIAGMARK,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID)
					set ind = ind + 1
				}
        	}
        }
	}
	
	Quit $$$OK
}

ClassMethod GetOPRecordDiagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPRecordDiagInfoExecute ]
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

ClassMethod GetOPRecordDiagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPRecordDiagInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:      入院记录
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:     流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetAdmRecordInfoByID()
ClassMethod GetAdmRecordInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
	
	s Adm = objInstance.EpisodeID
	q:(objInstance.Title'["入院记录") argOutData
	q:(objInstance.Title["24") argOutData
	s objJson  = ##class(%DynamicObject).%New()
    // 初始化字段
	s (patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,kpsscore,ecogscore,recordtext,chiefcomplaint,currentmedhistory,pastmedhistory,personalmedhistory,familyhistory,marriagebirthhistory,menstrualhistory,systolicpressure,diastolicpressure,respiratoryrate,bodytemperature,heartrate,height,weight,bodysurfacearea,physicalexam,specialexam,auxiliaryexam,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME) = ""
	
	// 通过就诊号取病历信息
	// 登记RowId
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
    //q:CurrDeptDR'=204
    
    // 登记号
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
    
	s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.13.01")
	
	s patientid = RegisterNo ;	患者ID	患者在本院的唯一标识
	s visitsn = Adm ;	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|住院
	s medicalrecordno = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm) ;	病案号	患者在本院就诊时使用的病案号
	s inpatientno = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm) ;	住院号	患者住院号
	// 住院次数
	s Intimes = ##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm)
	s hospitalizationtimes = Intimes ;	住院次数	
	
	s recordsn = InstanceID ;	入院记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符"|"进行拼接
	s recorddatetime = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) ;	入院记录创建时间	
	s kpsscore = "" ;	KPS评分	Karnofsky功能状态评分标准
	s ecogscore = "" ;	ECOG PS评分	体力状况ECOG评分标准 Zubrod-ECOG-WHO
	s recordtext = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID) ;	文书内容	上传对应完整文书内容(需要包括主诉、现病史、既往史、个人史、婚育史、家族史、月经史、体格检查、专科检查、辅助检查等信息)，如果能够将文书内容拆分或者分开存储，则需要填写下面对应文书内容。
	s chiefcomplaint = arr.GetAt("HDSD00.13.114") ;	主诉	
	s currentmedhistory = arr.GetAt("HDSD00.13.095") ;	现病史	
	s pastmedhistory = arr.GetAt("HDSD00.13.300") ;	既往史	
	s personalmedhistory = arr.GetAt("HDSD00.13.036") ;	个人史	
	s familyhistory = arr.GetAt("HDSD00.13.043") ;	家族史	
	s marriagebirthhistory = arr.GetAt("HDSD00.13.041") ;	婚育史	
	s menstrualhistory = arr.GetAt("HDSD00.13.106") ;	月经史	女性患者需填写
	s systolicpressure = arr.GetAt("HDSD00.13.085") ;	收缩压	单位：mmHg
	s diastolicpressure = arr.GetAt("HDSD00.13.086") ;	舒张压	单位：mmHg
	s respiratoryrate = arr.GetAt("HDSD00.13.077") ;	呼吸	单位：次每分钟
	s bodytemperature = arr.GetAt("HDSD00.13.088") ;	体温	单位：摄氏度
	s heartrate = "" ;	心率	单位：次每分钟
	s height = arr.GetAt("HDSD00.13.083") ;	身高	单位：厘米
	s weight = arr.GetAt("HDSD00.13.089") ;	体重	单位：千克
	s bodysurfacearea = "" ;	体表面积	单位：平方米
	s:(arr.GetAt("HDSD00.13.094")'="") physicalexam = "一般状况检查结果："_arr.GetAt("HDSD00.13.094") ;	体格检查
	s:(arr.GetAt("HDSD00.13.081")'="") physicalexam = physicalexam_"  皮肤和粘膜检查结果："_arr.GetAt("HDSD00.13.081")
	s:(arr.GetAt("HDSD00.13.082")'="") physicalexam = physicalexam_"  全身浅表淋巴检查结果："_arr.GetAt("HDSD00.13.082")
	s:(arr.GetAt("HDSD00.13.091")'="") physicalexam = physicalexam_"  头部及其器官检查结果："_arr.GetAt("HDSD00.13.091")
	s:(arr.GetAt("HDSD00.13.079")'="") physicalexam = physicalexam_"  颈部检查结果："_arr.GetAt("HDSD00.13.079")
	s:(arr.GetAt("HDSD00.13.093")'="") physicalexam = physicalexam_"  胸部检查结果："_arr.GetAt("HDSD00.13.093")
	s:(arr.GetAt("HDSD00.13.075")'="") physicalexam = physicalexam_"  腹部检查结果："_arr.GetAt("HDSD00.13.075")
	s:(arr.GetAt("HDSD00.13.076")'="") physicalexam = physicalexam_"  肛门指诊检查结果："_arr.GetAt("HDSD00.13.076")
	s:(arr.GetAt("HDSD00.13.092")'="") physicalexam = physicalexam_"  外生殖器检查结果："_arr.GetAt("HDSD00.13.092")
	s:(arr.GetAt("HDSD00.13.078")'="") physicalexam = physicalexam_"  脊柱检查结果："_arr.GetAt("HDSD00.13.078")
	s:(arr.GetAt("HDSD00.13.087")'="") physicalexam = physicalexam_"  四肢检查结果："_arr.GetAt("HDSD00.13.087")
	s:(arr.GetAt("HDSD00.13.084")'="") physicalexam = physicalexam_"  神经系统检查结果："_arr.GetAt("HDSD00.13.084")
	s specialexam = arr.GetAt("HDSD00.13.200") ;	专科检查	部分医院为“肿瘤情况”
	s auxiliaryexam = arr.GetAt("HDSD00.13.035") ;	辅助检查
	
	s extenddata1 = "" ;	扩展字段1	用于填写补充信息
	s extenddata2 = "" ;	扩展字段2	用于填写补充信息
	s recordstatus = "1" ;	记录状态	1正常 0作废
	s YYID = InstanceID // 数据唯一标识
	s modifydata=objInstance.ModifyDate
	s modifytime=objInstance.ModifyTime
	s updatedatetime=""
	if (modifydata'="")
	{
		s updatedatetime=$ZD(modifydata,3)_" "_$ZT(modifytime)
	}
	else
	{ 
		s updatedatetime=$ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime)
	}
	s YYUPDATETIME = updatedatetime //$ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
	s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
	//设置json对象
	s objJson.patientid =patientid
	s objJson.visitsn =visitsn
	s objJson.medicalrecordno =medicalrecordno
	s objJson.inpatientno =inpatientno
	s objJson.hospitalizationtimes =hospitalizationtimes
	s objJson.recorddatetime =recorddatetime
	s objJson.kpsscore =kpsscore
	s objJson.ecogscore =ecogscore
	s objJson.recordtext =recordtext
	s objJson.chiefcomplaint =chiefcomplaint
	s objJson.currentmedhistory =currentmedhistory
	s objJson.pastmedhistory =pastmedhistory
	s objJson.familyhistory =familyhistory
	s objJson.marriagebirthhistory =marriagebirthhistory
	s objJson.menstrualhistory =menstrualhistory
	s objJson.systolicpressure =systolicpressure
	s objJson.diastolicpressure =diastolicpressure
	s objJson.respiratoryrate =respiratoryrate
	s objJson.bodytemperature =bodytemperature
	s objJson.heartrate =heartrate
	s objJson.height =height
	s objJson.weight =weight
	s objJson.bodysurfacearea =bodysurfacearea
	s objJson.physicalexam =physicalexam
	s objJson.specialexam =specialexam
	s objJson.auxiliaryexam =auxiliaryexam
	s objJson.extenddata1 =extenddata1
	s objJson.extenddata2 =extenddata2
	s objJson.recordstatus =recordstatus
	s objJson.YYID =YYID
	s objJson.YYUPDATETIME =YYUPDATETIME
	s objJson.YYCREATETIME =YYCREATETIME
	d objJson.%ToJSON(argOutData)
	q argOutData
}

/// Desc:      入院记录诊断
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:      流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetAdmRecordDiagInfoByID()
ClassMethod GetAdmRecordDiagInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
	
	s Adm = objInstance.EpisodeID
	q:(objInstance.Title'["入院记录") argOutData
	q:(objInstance.Title["24") argOutData
	s objArr  = ##class(%DynamicArray).%New()
    // 初始化字段
	s (diagtype,maindiagmark,DIAGCODE,DIAGNAME,recordstatus,recorddatetime,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID) = ""
	
	// 通过就诊号取病历信息
	// 登记RowId
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
    //q:CurrDeptDR'=204 
    
    // 登记号
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
    
	s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.13.01")
	s ALLDiagDesc = arr.GetAt("HDSD00.13.023")
	s lenth = $L(ALLDiagDesc,$C(10))
	For iDiag = 1:1:lenth
	{
		s objJson  = ##class(%DynamicObject).%New()
		s diagtype = "入院初步诊断" // 诊断类型
		s:(iDiag=2) maindiagmark = "否" // 是否主要诊断
		s:(iDiag=1) maindiagmark = "是"
		s DIAGCODE = $P(ALLDiagDesc,$C(10),iDiag) // 诊断编码
		s DIAGNAME = $P(ALLDiagDesc,$C(10),iDiag) // 诊断名称
		s:DIAGCODE'="" DIAGCODE=$tr(DIAGCODE," ","")
		s:DIAGNAME'="" DIAGNAME=$tr(DIAGNAME," ","")
		q:DIAGCODE=""
		s recordstatus = "1" // 记录状态
		s YYID = InstanceID // 数据唯一标识
		s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
		s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
		s recorddatetime=$ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime)
		s patientid = RegisterNo // 患者ID
		s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
		s FKYYID = InstanceID // B051唯一数据标识YYID关联
		s recorddatetime=$ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime)
		//json赋值
		s objJson.diagtype=diagtype
		s objJson.maindiagmark=maindiagmark
		s objJson.DIAGCODE=DIAGCODE
		s objJson.DIAGNAME=DIAGNAME
		s objJson.recordstatus=recordstatus
		s objJson.recorddatetime=recorddatetime
		s objJson.YYID=YYID
		s objJson.YYUPDATETIME=YYUPDATETIME
		s objJson.patientid=patientid
		s objJson.visitsn=visitsn
		s objJson.FKYYID=FKYYID
		d objArr.%Push(objJson)
	}
	d objArr.%ToJSON(argOutData)
	q argOutData
}

/// Desc:      病程记录
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:      流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetCourseRecordInfoByID()
ClassMethod GetCourseRecordInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
				
	s Adm = objInstance.EpisodeID
	q:(objInstance.TitleCode'="") argOutData
	q:((objInstance.Title'["ICU病程记录")&&(objInstance.Title'["输血记录")&&(objInstance.Title'["接班记录")&&(objInstance.Title'["交班记录")&&(objInstance.Title'["抢救记录")&&(objInstance.Title'["术后病程")&&(objInstance.Title'["手术记录")&&(objInstance.Title'["术前讨论记录")&&(objInstance.Title'["术前小结")&&(objInstance.Title'["阶段小结")&&(objInstance.Title'["病程记录")&&(objInstance.Title'["首次病程")&&(objInstance.Title'["手术记录")&&(objInstance.Title'["患者术后病情再评估记录表"))
	
	s AdmType = $P(^PAADM(Adm),"^",2)
	q:(AdmType'="I") argOutData
	
	s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
    //q:CurrDeptDR'=204 
    
	// 登记RowId        [PapmiDR]            PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    // 登记号            [RegisterNo]        PA_PatMas.PAPMI_No
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s objJson  = ##class(%DynamicObject).%New()
    // 初始化字段
	s (patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,recordtitlecode,recordtitle,recordcontent,extenddata1,extenddata2,recordstatus) = ""
	
	s patientid = RegisterNo    ;	患者ID	患者在本院的唯一标识
	s visitsn = Adm    ;	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|住院
	// 住院病案号
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm)
	s medicalrecordno = IPRecordNo    ;	病案号	患者在本院就诊时使用的病案号
	s inpatientno = IPRecordNo    ;	住院号	患者住院号
	// 西医病案首页住院次数
	s Intimes =##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm)
	s hospitalizationtimes = Intimes ;	住院次数	
	s recordsn = InstanceID    ;	病程记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符“|”进行拼接。
	s recorddatetime = $ZD(objInstance.HappenDate,3)_" "_$ZT(objInstance.HappenTime,1)    ;	病程记录时间	"本业务数据在医院系统中的实际产生时间 yyyy-MM-dd HH:mm:ss"
	s recordtitlecode = objInstance.TitleCode    ;	病程记录类型代码	
	s recordtitle = objInstance.Title    ;	病程记录类型	包括首次病程记录、日常病程记录、死亡记录、上级医师查房记录、疑难病例讨论记录、交（接）班记录、转科记录、阶段小结、抢救记录、有创操作记录、会诊记录、术前小结、术前讨论记录、术后病程记录、手术过程描述、化疗小结等
	s recordcontent = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID)    ;	病程记录	
	s extenddata1 = ""    ;	扩展字段1	用于填写补充信息
	s extenddata2 = ""    ;	扩展字段2	用于填写补充信息
	s recordstatus = "1"    ;	记录状态	1正常 0作废
	//json赋值
	s objJson.patientid =patientid
	s objJson.visitsn =visitsn
	s objJson.medicalrecordno =medicalrecordno
	s objJson.inpatientno =inpatientno
	s objJson.hospitalizationtimes =hospitalizationtimes
	s objJson.recordsn =recordsn
	s objJson.recorddatetime =recorddatetime
	s objJson.recordtitlecode =recordtitlecode
	s objJson.recordtitle =recordtitle
	s objJson.recordcontent =recordcontent
	s objJson.extenddata1 =extenddata1
	s objJson.extenddata2 =extenddata2
	s objJson.recordstatus =recordstatus
	d objJson.%ToJSON(argOutData)
	q argOutData
}

/// Desc:      出院记录
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:      流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetDischargeRecordInfoByID()
ClassMethod GetDischargeRecordInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
				
	s Adm = objInstance.EpisodeID
	q:(objInstance.Title'["出院记录") argOutData
	q:(objInstance.Title["24") argOutData
	
	s AdmType = $P(^PAADM(Adm),"^",2)
	q:(AdmType'="I") argOutData
	
	s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
    //q:CurrDeptDR'=204 
    
	// 登记RowId        [PapmiDR]            PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    // 登记号            [RegisterNo]        PA_PatMas.PAPMI_No
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s objJson  = ##class(%DynamicObject).%New()
    // 初始化字段
	s (patientid,visitsn,medicalrecordno,inpatientno,hospitalizationtimes,recordsn,recorddatetime,admissiondatetime,dischargeorder,dischargedatetime,lengthofstay,kpsscore,ecogscore,recordtext,admissioncondition,treatmentinfo,dischargecondition,extenddata1,extenddata2,recordstatus,YYID,YYUPDATETIME,YYCREATETIME) = ""
	
	s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.16")
	
	s patientid = RegisterNo    ; 	患者ID	患者在本院的唯一标识
	s visitsn = Adm    ; 	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|住院号|住院次数|就诊类型名称
	// 住院病案号
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(Adm)
	s medicalrecordno = IPRecordNo    ;	病案号	患者在本院就诊时使用的病案号
	s inpatientno = IPRecordNo    ;	住院号	患者住院号
	// 西医病案首页住院次数
	s Intimes = ##Class(EMRservice.HISInterface.PatientInfoAssist).InTimes(Adm)
	s hospitalizationtimes = Intimes ;	住院次数	
	s recordsn = InstanceID    ; 	出院记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符"|"进行拼接。
	s recorddatetime = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime,1)    ; 	出院记录创建时间	
	s admissiondatetime = ##class(EMRmeta.Data.Method.Tools).ToTS(arr.GetAt("HDSD00.16.031"),"3","1")    ; 	入院时间	"本次就诊入院时间yyyy-MM-dd HH:mm:ss"
	s dischargeorder = arr.GetAt("HDSD00.16.007")    ; 	出院医嘱	出院医嘱、随诊要求等
	s dischargedatetime = ##class(EMRmeta.Data.Method.Tools).ToTS(arr.GetAt("HDSD00.16.005"),"3","1")    ; 	出院时间	"本次就诊出院时间yyyy-MM-dd HH:mm:ss"
	s lengthofstay = arr.GetAt("HDSD00.16.036")    ; 	实际住院天数	本次就诊住院总天数
	s kpsscore = ""    ; 	KPS评分	Karnofsky功能状态评分标准
	s ecogscore = ""    ; 	ECOG PS评分	体力状况ECOG评分标准 Zubrod-ECOG-WHO
	s recordtext = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID)    ; 	文书内容	上传对应完整文书内容(出院记录)
	s admissioncondition = arr.GetAt("HDSD00.16.030")    ; 	入院情况	主要症状和体征及辅助检查摘要
	s admissioncondition=$tr(admissioncondition," ","")
	s treatmentinfo = arr.GetAt("HDSD00.16.045")    ; 	诊疗经过	主要治疗方式、方案及病情演变、抢救经过等
	s treatmentinfo=$tr(treatmentinfo," ","")
	s dischargecondition = arr.GetAt("HDSD00.16.004")    ; 	出院情况	出院时病情、主要检查结果及治疗结果等
	s dischargecondition=$tr(dischargecondition," ","")
	s extenddata1 = ""    ; 	扩展字段1	用于填写补充信息
	s extenddata2 = ""    ; 	扩展字段2	用于填写补充信息
	s recordstatus = "1"    ; 	记录状态	1正常 0作废
	s YYID = InstanceID // 数据唯一标识
	s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
	s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
	//json赋值
	s objJson.patientid =patientid
	s objJson.visitsn =visitsn
	s objJson.medicalrecordno =medicalrecordno
	s objJson.inpatientno =inpatientno
	s objJson.hospitalizationtimes =hospitalizationtimes
	s objJson.recordsn =recordsn
	s objJson.recorddatetime =recorddatetime
	s objJson.admissiondatetime =admissiondatetime
	s objJson.dischargeorder =dischargeorder
	s objJson.dischargedatetime =dischargedatetime
	s objJson.lengthofstay =lengthofstay
	s objJson.kpsscore =kpsscore
	s objJson.ecogscore =ecogscore
	s objJson.recordtext =recordtext
	s objJson.admissioncondition =admissioncondition
	s objJson.treatmentinfo =treatmentinfo
	s objJson.dischargecondition =dischargecondition
	s objJson.extenddata1 =extenddata1
	s objJson.extenddata2 =extenddata2
	s objJson.recordstatus =recordstatus
	s objJson.YYID =YYID
	s objJson.YYUPDATETIME =YYUPDATETIME
	s objJson.YYCREATETIME =YYCREATETIME
	d objJson.%ToJSON(argOutData)
	q argOutData
}

/// Desc:      出院诊断
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:      流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetDischargeRecordDiagInfoByID()
ClassMethod GetDischargeRecordDiagInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
	
	s Adm = objInstance.EpisodeID
	q:(objInstance.Title'["出院记录") argOutData
	q:(objInstance.Title["24") argOutData
	
	s AdmType = $P(^PAADM(Adm),"^",2)
	q:(AdmType'="I") argOutData
	
	s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
    //q:CurrDeptDR'=204 
    s objArr  = ##class(%DynamicArray).%New()
    // 初始化字段
	s (diagtype,maindiagmark,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID) = ""
	
	// 通过就诊号取病历信息
	// 登记RowId
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    // 登记号
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
    
	s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.16")
	s ALLAdmDiagDesc = arr.GetAt("HDSD00.16.032")
	s lenth = $L(ALLAdmDiagDesc,$C(10))
	
	s ALLDisDiagDesc = arr.GetAt("HDSD00.16.008")
	s lenth = $L(ALLDisDiagDesc,$C(10))
	For iDiag = 1:1:lenth
	{
		s objJson  = ##class(%DynamicObject).%New()
		s DIAGTYPE = "出院诊断" // 诊断类型
		s:(iDiag=2) maindiagmark = "否" // 是否主要诊断
		s:(iDiag=1) maindiagmark = "是"
		s DIAGCODE = $P(ALLDisDiagDesc,$C(10),iDiag) // 诊断编码
		s DIAGNAME = $P(ALLDisDiagDesc,$C(10),iDiag) // 诊断名称
		s:DIAGCODE'="" DIAGCODE=$tr(DIAGCODE," ","")
		s:DIAGNAME'="" DIAGNAME=$tr(DIAGNAME," ","")
		q:DIAGCODE=""
		s recordstatus = "1" // 记录状态
		s YYID = InstanceID_"||"_iDiag // 数据唯一标识
		s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
		s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
		s patientid = RegisterNo // 患者ID
		s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
		s FKYYID = InstanceID // B051唯一数据标识YYID关联
		
		//json赋值
		s objJson.DIAGTYPE=DIAGTYPE
		s objJson.maindiagmark=maindiagmark
		s objJson.DIAGCODE=DIAGCODE
		s objJson.DIAGNAME=DIAGNAME
		s objJson.recordstatus=recordstatus
		s objJson.YYID=YYID
		s objJson.YYUPDATETIME=YYUPDATETIME
		s objJson.YYCREATETIME=YYCREATETIME
		s objJson.patientid=patientid
		s objJson.visitsn=visitsn
		s objJson.FKYYID=FKYYID
		d objArr.%Push(objJson)
	}
	d objArr.%ToJSON(argOutData)
	q argOutData
}

/// Desc:      门诊记录
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:      流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetOutPatientRecordInfoByIDByID()
ClassMethod GetOutPatientRecordInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
	
	s Adm = objInstance.EpisodeID
	s Title = objInstance.Title
	q:(Title'["门诊病历") argOutData
	
	s AdmType =  $p(^PAADM(Adm),"^",2)
	q:((AdmType'="O")&&(AdmType'="E")) argOutData
	
	// 通过就诊号取病历信息
	// 登记RowId        [PapmiDR]            PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    // 登记号            [RegisterNo]        PA_PatMas.PAPMI_No
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s objJson  = ##class(%DynamicObject).%New()
    // 初始化字段
	s (patientid,visitsn,visittype,visitcardno,outpatientno,visittimes,visitdatetime,recordsn,recorddatetime,recordtext,treatmentinfo,operationinfo,chiefcomplaint,currentmedhistory,pastmedhistory,personalmedhistory,familyhistory,marriagebirthhistory,menstrualhistory,physicalexam,tcmdiseasename,tcmsyndromename,diagnosedatetime,extenddata1,extenddata2,recordstatus) = ""
	
	s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.03.01")
	s AdmDate="",AdmTime="",admissionDateTime=""
    set AdmDate=$P(^PAADM(Adm),"^",6)
    set:AdmDate'="" AdmDate=$zd(AdmDate,3)
    set AdmTime=$P(^PAADM(Adm),"^",7)
    set:AdmTime'="" AdmTime=$zt(AdmTime)
    set admissionDateTime=AdmDate_" "_AdmTime
	
	s patientid = RegisterNo    ;  	患者ID	患者在本院的唯一标识
	s visitsn = Adm    ;  	单次就诊唯一标识号	标识一次就诊行为的唯一编号，如果原系统中需多个字段标识，则通过"|"进行拼接。例如，患者ID|门诊号|就诊次数|就诊类型。
	s visittype = $CASE(AdmType,"O":"门诊","E":"急诊")    ;  	就诊类型	就诊类型：门诊、急诊
	s visitcardno = RegisterNo    ;  	就诊卡号	患者在本医院就诊时使用的就诊卡号
	s outpatientno = $P(^PAPER(PapmiDR,"PAT",1),"^",22)    ;  	门诊号	患者门诊就诊时对应的门诊号或者病历号
	s visittimes = ..GetOPTimesByAdm(PapmiDR,Adm)    ;  	就诊次数	本院门诊次数
	s visitdatetime = admissionDateTime ;##class(EMRmeta.Data.Method.Tools).ToTS(arr.GetAt("HDSD00.03.023"),"3","1")    ;  	就诊时间	符合【yyyy-MM-dd HH:mm:ss】的格式
	s recordsn = InstanceID    ;  	病历记录流水号	该值为原系统主键，如果为多字段主键则需要通过分隔符"|"进行拼接。
	s recorddatetime = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime,1)    ;  	病历记录时间	符合【yyyy-MM-dd HH:mm:ss】的格式
	s recordtext = ##Class(EMRmeta.Data.Method.Tools).GetDocumentContentNew(InstanceID)    ;  	病历文书内容	上传对应完整文书内容(需要包括主诉、现病史、既往史、个人史、婚育史、家族史、月经史、体格检查等信息)，如果能够将文书内容拆分或者分开存储，则需要填写下面对应文书内容。
	s treatmentinfo = ""    ;  	诊疗经过	
	s operationinfo = ""    ;  	操作记录	
	s chiefcomplaint = arr.GetAt("HDSD00.03.057")    ;  	主诉	
	s currentmedhistory = arr.GetAt("HDSD00.03.038")    ;  	现病史	
	s pastmedhistory = arr.GetAt("HDSD00.03.021")    ;  	既往史	
	s personalmedhistory = ""    ;  	个人史	
	s familyhistory = arr.GetAt("HDSD00.03.210")    ;  	家族史	
	s marriagebirthhistory = ""    ;  	婚育史	
	s menstrualhistory = ""    ;  	月经史	
	s physicalexam = arr.GetAt("HDSD00.03.037")    ;  	体格检查	
	s tcmdiseasename = arr.GetAt("HDSD00.03.007")    ;  	中医病名	
	s tcmsyndromename = arr.GetAt("HDSD00.03.009")    ;  	中医证候	
	
	s OPDiagInfos = ##class(EMRmeta.Data.Method.Tools).GetMRDiagnoseListForEMR(Adm,"2","OP")
	s OPDiagInfos = OPDiagInfos_$C(1)_##class(EMRmeta.Data.Method.Tools).GetMRDiagnoseListForEMR(Adm,"1","OP")
	s diagnosedatetime = $P($P(OPDiagInfos,$C(1),1),"^",8)_" "_$P($P(OPDiagInfos,$C(1),1),"^",9)    ;  	诊断时间	符合【yyyy-MM-dd HH:mm:ss】的格式
	
	s diagcoden = ""    ;  	诊断编码-N	填写除诊断编码1-10以外的其他诊断编码，两编码之间用“|”隔开。
	s diagnamen = ""    ;  	诊断名称-N	填写除诊断编码1-10以外的其他诊断名称，两诊断之间用“|”隔开。
	s extenddata1 = ""    ;  	扩展字段1	用于填写补充信息
	s extenddata2 = ""    ;  	扩展字段2	用于填写补充信息
	s recordstatus = "1"    ;  	记录状态	1正常 0作废
	s YYID = InstanceID // 数据唯一标识
	s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
	s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
	
	// json赋值
	s objJson.patientid =patientid
	s objJson.visitsn =visitsn
	s objJson.visittype =visittype
	s objJson.visitcardno =visitcardno
	s objJson.outpatientno =outpatientno
	s objJson.visittimes =visittimes
	s objJson.visitdatetime =visitdatetime
	s objJson.recordsn =recordsn
	s objJson.recorddatetime =recorddatetime
	s objJson.recordtext =recordtext
	s objJson.treatmentinfo =treatmentinfo
	s objJson.operationinfo =operationinfo
	s objJson.chiefcomplaint =chiefcomplaint
	s objJson.currentmedhistory =currentmedhistory
	s objJson.pastmedhistory =pastmedhistory
	s objJson.personalmedhistory =personalmedhistory
	s objJson.familyhistory =familyhistory
	s objJson.marriagebirthhistory =marriagebirthhistory
	s objJson.menstrualhistory =menstrualhistory
	s objJson.physicalexam =physicalexam
	s objJson.tcmdiseasename =tcmdiseasename
	s objJson.tcmsyndromename =tcmsyndromename
	s objJson.diagnosedatetime =diagnosedatetime
	s objJson.extenddata1 =extenddata1
	s objJson.extenddata2 =extenddata2
	s objJson.recordstatus =recordstatus
	s objJson.YYID =YYID
	s objJson.YYUPDATETIME =YYUPDATETIME
	s objJson.YYCREATETIME =YYCREATETIME
	d objJson.%ToJSON(argOutData)
	q argOutData
}

/// Desc:      门诊记录诊断
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      InstanceID  实例ID
/// OutPut:      流数据
/// Debug: w ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetOPRecordDiagInfoByID()
ClassMethod GetOPRecordDiagInfoByID(InstanceID As %String) As %Stream
{
	s argOutData = ##Class(%GlobalCharacterStream).%New()
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s status = objInstance.Status
	q:(status'="Save") argOutData
	
	s Adm = objInstance.EpisodeID
	S AdmType =  $p(^PAADM(Adm),"^",2)
	q:((AdmType'="O")&&(AdmType'="E")) argOutData
	
	s Title = objInstance.Title
	q:(Title'["门诊病历") argOutData
	
	s CurrDeptDR=$p($g(^PAADM(Adm)),"^",4)
    //q:CurrDeptDR'=204 
    s objArr  = ##class(%DynamicArray).%New()
    // 初始化字段
	s (MAINDIAGMARK,DIAGCODE,DIAGNAME,recordstatus,YYID,YYUPDATETIME,YYCREATETIME,patientid,visitsn,FKYYID) = ""
	
	// 通过就诊号取病历信息
	// 登记RowId
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(Adm)
    // 登记号
    s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
  
	s arr = ##class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.03.01")
	s ALLDiagDesc = arr.GetAt("HDSD00.03.005")
	s lenth = $L(ALLDiagDesc,$C(10))
	For iDiag = 1:1:lenth
	{
		s objJson  = ##class(%DynamicObject).%New()
		s:(iDiag=2) MAINDIAGMARK = "否" // 是否主要诊断
		s:(iDiag=1) MAINDIAGMARK = "是"
		s DIAGCODE = $P(ALLDiagDesc,$C(10),iDiag) // 诊断编码
		s DIAGNAME = $P(ALLDiagDesc,$C(10),iDiag) // 诊断名称
		s recordstatus = "1" // 记录状态
		s YYID = InstanceID_"||"_iDiag // 数据唯一标识
		s YYUPDATETIME = $ZD(+$H,3)_" "_$ZT($P($H,",",1)) // 数据更新时间(增量采集时间)
		s YYCREATETIME = $ZD(objInstance.CreateDate,3)_" "_$ZT(objInstance.CreateTime) // 数据创建时间
		s patientid = RegisterNo // 患者ID
		s visitsn = Adm // 单次就诊唯一标识号(与b021强关联)
		s FKYYID = InstanceID // B051唯一数据标识YYID关联
		
		// json赋值
		s objJson.MAINDIAGMARK=MAINDIAGMARK
		s objJson.DIAGCODE=DIAGCODE
		s objJson.DIAGNAME=DIAGNAME
		s objJson.recordstatus=recordstatus
		s objJson.YYID=YYID
		s objJson.YYUPDATETIME=YYUPDATETIME
		s objJson.YYCREATETIME=YYCREATETIME
		s objJson.patientid=patientid
		s objJson.visitsn=visitsn
		s objJson.FKYYID=FKYYID
		d objArr.%Push(objJson)
	}
	d objArr.%ToJSON(argOutData)
	q argOutData
}

/// 门诊次数
/// w ##Class(EMRservice.HISInterface.PatientInfoAssist).IsRepeatAdm(1,1)
ClassMethod GetOPTimesByAdm(PapmiDR As %String, Adm As %String) As %String
{
	s arr = "0"
	q:(PapmiDR="")||(Adm="") arr
	
	s arr = 0,PAADMRowID=""
	f PAADMRowID = $O(^PAPERdr(PapmiDR,"ADM","O",PAADMRowID)) q:(PAADMRowID="")  d
	.s arr = arr + 1
	
	q arr
}

}
