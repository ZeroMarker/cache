/// Creator：		yangyali 
/// CreatDate：		2020-11-3
/// Description：	广东省全民健康数据采集,心电提供数据
Class web.DHCEkg.YB.HealthPlatform Extends %RegisteredObject
{

/// Creator：		yangyali 
/// CreatDate：		2020-11-3
/// Description：	获取心电报告信息，见《广东省全民健康数据采集目录 医疗及运营分册》6.4.1医学影像检查报告（t_check_rec）
/// Input：			StdDate^EndDate 开始日期^结束日期
/// Return：		
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.YB.HealthPlatform","GetEKGReport","2020-11-01^2020-11-01")
/// call web_DHCEkg_YB.HealthPlatform_GetEKGReport("2020-11-01^2020-11-01")
Query GetEKGReport(params As %String) As %Query(ROWSPEC = "check_report_no,diag_no,business_no,org_code,patient_org_no,upload_status_mark,unified_social_credit_code,org_name,patient_name,health_e_code,gender_code,gender_name,birth_date,diag_type_code,diag_type_name,order_rec_form_no,check_rec_no,hospital_no,room_no,bed_no,ward_name,pat_no,telephone,now_addr_descr,critical_state,check_apply_org_name,check_apply_depart_name,check_apply_depart_no,check_apply_depart_name_exp,check_apply_depart_no_exp,appl_doct_no,appl_doct_name,apply_time,check_report_date,check_audit_time,check_proj_category_code,check_proj_category_name,check_report_org_name,check_report_depart_code,check_report_depart_name,check_report_depart_code_exp,check_report_depart_name_exp,report_doct_no,report_doct_name,check_doct_no,check_doct_name,audit_doct_no,audit_doct_name,check_res_obj,check_res_sub,report_clinial_diag,check_type_code,check_type_name,symptom_code,symptom_name,symptom_descri,check_proj_code,check_proj_name,check_proj_code_exp,check_proj_name_exp,check_part_code,check_part_name,check_res_code,check_res_name,check_res,biopsy_site,under_pathol_see,pathological_naked_eye,surgfr_pathdiag_code,surgfr_pathdiag_name,check_res_qual,check_normal_ref_qual,normal_ref_lower_limit,normal_ref_upper_limit,check_index_result,check_index_uint,chief_complaint,symptom_start_time,symptom_stop_time,spe_inspect_mark,frozen,immu_number,check_methed_name,check_report_comment,image_exist_mark,image_uid_addr,image_no,check_equip_model,check_equip_num,instrument_name,update_time,business_gener_time") [ SqlProc ]
{
}

ClassMethod GetEKGReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEKGReportExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEKGReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEKGReportExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetEKGReportExecute(ByRef qHandle As %Binary, params As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s paramStdDate=$p(params,"^",1)
 	s paramEndDate=$p(params,"^",2)
 	
 	i paramStdDate["-" s paramStdDate=$zdh(paramStdDate,3)
	i paramEndDate["-" s paramEndDate=$zdh(paramEndDate,3)
	
	i paramStdDate["/" d
	.s paramStdDate=$replace(paramStdDate,"/","-") 
	.s paramStdDate=$zdh(paramStdDate,3)	
	i paramEndDate["/" d
	.s paramEndDate=$replace(paramEndDate,"/","-")
	.s paramEndDate=$zdh(paramEndDate,3)
	
	i (paramStdDate="") s paramStdDate=$p($h,",",1)
	i (paramEndDate="") s paramEndDate=$p($h,",",1)
	
	new $namespace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	
	s terminal=0
	s arbTime="" ;以审核时间为条件进行查询
	f  s arbTime=$o(^dbo.tblExaminationI("idxArbiterTime",arbTime),-1) q:(arbTime="")!(terminal)  d
	.;w "arbTime :"_arbTime,!
	.q:(arbTime="9999-12-31 23:59:59")!(arbTime=-100000000000000)
	.//以审核时间为条件过滤
	.s arbDate=$zdh($p(arbTime,$c(32),1),3)
	.;w "arbDate :"_arbDate_", paramStdDate :"_paramStdDate_", paramEndDate :"_paramEndDate,!
	.i (arbDate<paramStdDate) s terminal=1 ;审核时间小于查询的起始时间，退出循环
	.q:((arbDate>paramEndDate)!(arbDate<paramStdDate))
	.s QexamId=""
	.f  s QexamId=$o(^dbo.tblExaminationI("idxArbiterTime",arbTime,QexamId),-1) q:(QexamId="")  d
	..;w "QexamId :"_QexamId,!
	..s QexamInfo=$g(^dbo.tblExaminationD(QexamId))
	..q:(QexamInfo="")
	..s statusCode=$listget(QexamInfo,20)
	..;w "statusCode :"_statusCode,!
	..q:((statusCode'="15")&&(statusCode'="17")) ;未审核
	..s reqId=$listget(QexamInfo,19)
	..q:(reqId="")
	..s reqInfo=$g(^dbo.tblRequestD(reqId))
	..q:(reqInfo="")
	..s ordId=$listget(reqInfo,6)
	..q:(ordId="")
	..s examModel=$listget(reqInfo,26)
	..q:(examModel="手动检查")
	..s examId=QexamId
	..//查询检查报告信息	
	..d GetReportInfo
	..//输出	
	..d OutputList
	zn "dhc-app"
 	s qHandle=$lb(0,repid,0)
	q $$$OK


OutputList
	new $namespace
	zn "dhc-app"
	s Data=$lb(checkreportno,diagno,businessno,orgcode,patientorgno,uploadstatusmark,unifiedsocialcreditcode,orgname,
		patientname,healthecode,gendercode,gendername,birthdate,diagtypecode,diagtypename,orderrecformno,checkrecno,
		hospitalno,roomno,bedno,wardname,patno,telephone,nowaddrdescr,criticalstate,checkapplyorgname,
		checkapplydepartname,checkapplydepartno,checkapplydepartnameexp,checkapplydepartnoexp,appldoctno,appldoctname,
		applytime,checkreportdate,checkaudittime,checkprojcategorycode,checkprojcategoryname,checkreportorgname,
		checkreportdepartcode,checkreportdepartname,checkreportdepartcodeexp,checkreportdepartnameexp,reportdoctno,
		reportdoctname,checkdoctno,checkdoctname,auditdoctno,auditdoctname,checkresobj,checkressub,reportclinialdiag,
		checktypecode,checktypename,symptomcode,symptomname,symptomdescri,checkprojcode,checkprojname,
		checkprojcodeexp,checkprojnameexp,checkpartcode,checkpartname,checkrescode,checkresname,checkres,biopsysite,
		underpatholsee,pathologicalnakedeye,surgfrpathdiagcode,surgfrpathdiagname,checkresqual,checknormalrefqual,
		normalreflowerlimit,normalrefupperlimit,checkindexresult,checkindexuint,chiefcomplaint,symptomstarttime,
		symptomstoptime,speinspectmark,frozen,immunumber,checkmethedname,checkreportcomment,imageexistmark,imageuidaddr,
		imageno,checkequipmodel,checkequipnum,instrumentname,updatetime,businessgenertime)
 	;b ; w Data
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	q
	
GetReportInfo
	;b ; 000
	s (checkreportno,diagno,businessno,orgcode,patientorgno,uploadstatusmark,unifiedsocialcreditcode,orgname,patientname)=""
	s (healthecode,gendercode,gendername,birthdate,diagtypecode,diagtypename,orderrecformno,checkrecno,hospitalno,roomno)=""
	s (bedno,wardname,patno,telephone,nowaddrdescr,criticalstate,checkapplyorgname,checkapplydepartname,checkapplydepartno)=""
	s (checkapplydepartnameexp,checkapplydepartnoexp,appldoctno,appldoctname,applytime,checkreportdate,checkaudittime)=""
	s (checkprojcategorycode,checkprojcategoryname,checkreportorgname,checkreportdepartcode,checkreportdepartname)=""
	s (checkreportdepartcodeexp,checkreportdepartnameexp,reportdoctno,reportdoctname,checkdoctno,checkdoctname,auditdoctno)=""
	s (auditdoctname,checkresobj,checkressub,reportclinialdiag,checktypecode,checktypename,symptomcode,symptomname)=""
	s (symptomdescri,checkprojcode,checkprojcode,checkprojname,checkprojcodeexp,checkprojnameexp,checkpartcode)=""
	s (checkpartname,checkrescode,checkresname,checkres,biopsysite,underpatholsee,pathologicalnakedeye,surgfrpathdiagcode)=""
	s (surgfrpathdiagname,checkresqual,checknormalrefqual,normalreflowerlimit,normalrefupperlimit,checkindexresult)=""
	s (checkindexuint,chiefcomplaint,symptomstarttime,symptomstoptime,speinspectmark,frozen,immunumber,checkmethedname)=""
	s (checkreportcomment,imageexistmark,imageuidaddr,imageno,checkequipmodel,checkequipnum,instrumentname,updatetime)=""
	s (businessgenertime)=""

	s examInfo=$g(^dbo.tblExaminationD(examId))
	s reqId=$listget(examInfo,19)
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	s patId=$listget(reqInfo,16)
	s patInfo=$g(^dbo.tblPatientD(patId))
	s checkreportno=examId ;检查报告单编号
	s diagno=$listget(reqInfo,3) ;就诊流水号
	s businessno=$listget(reqInfo,6)_"_"_examId ; 业务编号,机构唯一标识(优先填写社会信用代码，若无社会信用代码则填组织机构代码)+“_”+电子申请单号+“_”+检查报告单编号
	s orgcode="" ; 机构代码
	s patientorgno=$listget(patInfo,20) ; 机构注册的患者编号
	s uploadstatusmark="1" ; 数据上传标识
	s unifiedsocialcreditcode="" ; 统一社会信用代码
	s orgname="" ; 机构名称
	s patientname=$listget(patInfo,16) ; 患者姓名
	s gender=$listget(patInfo,8) ; 性别
	i (gender="f")
	{
		s gendercode="2" ;性别代码
		s gendername="女性" ;性别名称
	}
	elseif (gender="m")
	{
		s gendercode="1" ;性别代码
		s gendername="男性" ;性别名称
	}
	else
	{
		s gendercode="9" ;性别代码
		s gendername="未说明的性别" ;性别名称
	}
	s birthdate=$p($listget(patInfo,3)," ",1) ; 出生日期
	s birthdate=$replace(birthdate,"-","")
	s patSourceCode=$listget(reqInfo,15) ; 病人来源
	i (patSourceCode'="")
	{
		s patSourceId=$o(^dbo.tblDictPatSourceI("idxCode"," "_patSourceCode,""))
		s patSourceName=$listget($g(^dbo.tblDictPatSourceD(patSourceId)),4)
		//就诊类型代码
		s diagtypecode=$CASE(patSourceName,
								"体检":"4",
								"住院":"3",
								"门诊":"1",
								"急诊":"2",
								"其它":"9",
								:"9") 
		//就诊类型名称
		s diagtypename=$CASE(patSourceName,
								"体检":"体检",
								"住院":"住院",
								"门诊":"门诊",
								"急诊":"急诊",
								"其它":"其他",
								:"其他") 
		//住院号
		s hospitalno=$CASE(patSourceName,"住院":$listget(patInfo,11),:"") 
		//门（急）诊号
		s patno=$CASE(patSourceName,"门诊":$listget(patInfo,19),:"") 
	}
	s orderrecformno=$listget(reqInfo,6) ; 医嘱号/电子申请单编号
	s checkrecno=examId ; 检查号
	s bedno=$listget(reqInfo,7) ; 病床号
	s wardname=$listget(reqInfo,22) ; 病区名称
	s telephone=$listget(patInfo,21) ; 个人联系电话号码
	s nowaddrdescr=$listget(patInfo,2) ; 现住址地址完整描述
	s emergencyRcdId=$o(^dbo.tblEmergencyRecordI("idxExaminationID",examId,""))
	//危急值状态：1:是;2:否
	i (emergencyRcdId="") s criticalstate="2"
	e  s criticalstate="1"
	s checkapplydepartnoexp=$listget(reqInfo,9) ; 院内检查申请科室编号
	i (checkapplydepartnoexp'="")
	{
		s deptId=$o(^dbo.tblDictDeptI("idxDeptCode",
						" "_$zcvt(checkapplydepartnoexp,"u"),""))
		i (deptId'="") s checkapplydepartnameexp=$listget($g(^dbo.tblDictDeptD(deptId)),4) ; 院内检查申请科室名称
	}
	s appldoctname=$listget(reqInfo,12) ; 申请医生签名
	s applytime=$listget(reqInfo,18) ; 申请时间
	s applytime=$replace($replace($replace(applytime,"-","")," ",""),":","") ;转换为【YYYYMMDDHH24MISS】格式
	s checkreportdate=$listget(examInfo,17) ; 检查报告时间
	s checkaudittime=$listget(examInfo,6) ; 检查审核时间
	i ((checkreportdate="")!(checkreportdate["9999")) s checkreportdate=checkaudittime
	s checkreportdate=$replace($replace($replace(checkreportdate,"-","")," ",""),":","") ;转换为【YYYYMMDDHH24MISS】格式
	s checkaudittime=$replace($replace($replace(checkaudittime,"-","")," ",""),":","") ;转换为【YYYYMMDDHH24MISS】格式
	s checkprojcategorycode=$listget(reqInfo,11) ; 检查项目大项代码
	i (checkprojcategorycode'="")
	{
		s examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_$zcvt(checkprojcategorycode,"u"),""))
		i (examItemId'="") s checkprojcategoryname=$listget($g(^dbo.tblDictExamItemD(examItemId)),6) ; 检查项目大项代码
	}
	s checkreportdepartcodeexp=$listget(reqInfo,2) ; 院内检查报告科室编号
	i (checkreportdepartcodeexp'="")
	{
		s execDeptId=$o(^dbo.tblDictDeptI("idxDeptCode",
						" "_$zcvt(checkreportdepartcodeexp,"u"),""))
		i (execDeptId'="") s checkreportdepartnameexp=$listget($g(^dbo.tblDictDeptD(execDeptId)),4) ; 院内检查报告科室名称
	}
	s reportUserId=$listget(examInfo,18) ; 报告医师Id
	s arbiterUserId=$listget(examInfo,7) ; 审核医师Id
	s operateUserId=$listget(examInfo,14) ; 检查医师Id
	i ((reportUserId="")!(reportUserId="0")) s reportUserId=arbiterUserId
	i (reportUserId'="")
	{
		s reportdoctno=$listget($g(^dbo.tblUserD(reportUserId)),8) ; 报告医师编号
		s reportdoctname=$listget($g(^dbo.tblUserD(reportUserId)),11) ; 报告医师签名
	}
	i (arbiterUserId'="")
	{
		s auditdoctno=$listget($g(^dbo.tblUserD(arbiterUserId)),8) ; 审核医师编号
		s auditdoctname=$listget($g(^dbo.tblUserD(arbiterUserId)),11) ; 审核医师签名
	}
	i (operateUserId'="")
	{
		s checkdoctno=$listget($g(^dbo.tblUserD(operateUserId)),8) ; 检查医师编号
		s checkdoctname=$listget($g(^dbo.tblUserD(operateUserId)),11) ; 检查医师签名
	}
	s checkresobj=$listget(examInfo,32) ; 检查所见
		i checkresobj'[$c(10) set checkresobj=checkresobj_$c(10) ;2015-08-13
		s D=""
		f i=1:1:$l(checkresobj,$c(10)) d
		.s tmpD=$p(checkresobj,$c(10),i)
		.i (tmpD'="") do
		..i (D="") set D=tmpD
		..e  set D=D_","_tmpD
		;b ;00
		s checkresobj=D
	s checkressub=$listget(examInfo,11) ; 检查结论
		i checkressub'[$c(10) set checkressub=checkressub_$c(10) ;2015-08-13
		s D=""
		f i=1:1:$l(checkressub,$c(10)) d
		.s tmpD=$p(checkressub,$c(10),i)
		.i (tmpD'="") do
		..i (D="") set D=tmpD
		..e  set D=D_","_tmpD
		;b ;00
		s checkressub=D
	i (checkprojcategoryname["多普勒")
	{
		s checktypecode="CD" ; 检查类型代码
		s checktypename="彩色流体多普勒" ; 检查类型名称
	}
	else
	{
		s checktypecode="OT" ; 检查类型代码
		s checktypename="其他" ; 检查类型名称
	}
	s checkprojcode=checkprojcategorycode ; 检查项目代码
	s checkprojname=checkprojcategoryname ; 检查项目名称
	s checkprojcodeexp=checkprojcategorycode ; 医院检查项目编码
	s checkprojnameexp=checkprojcategoryname ; 医院检查项目名称
	s negative=$listget(examInfo,30) ; 阴阳性
	i (negative="阳性")
	{
		s checkrescode="2" ; 检查结果代码
		s checkresname="异常" ; 检查结果名称
	}
	else
	{
		s checkrescode="1" ; 检查结果代码
		s checkresname="正常" ; 检查结果名称
	}
	s imageexistmark="0" ; 是否有影像标记, 0:否; 1:是
	s businessgenertime=checkaudittime ; 业务数据产生时间
	q
}

/// Creator：		yangyali 
/// CreatDate：		2020-11-6
/// Description：	获取心电报告文件信息，见《广东省全民健康数据采集目录 医疗及运营分册》6.4.2医学影像检查文档采集（t_check_file）
/// Input：			StdDate^EndDate 开始日期^结束日期
/// Return：		
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.YB.HealthPlatform","GetEKGReportFile","2020-10-01^2020-11-06")
/// call web_DHCEkg_YB.HealthPlatform_GetEKGReportFile("2020-10-01^2020-11-06")
Query GetEKGReportFile(params As %String) As %Query(ROWSPEC = "order_rec_form_no,check_report_no,business_no,org_code,upload_status_mark,org_name,patient_name,gender_code,gender_name,storage_type,file_type_code,file_type_name,file_name,file_path,file_data,update_time,business_gener_time") [ SqlProc ]
{
}

ClassMethod GetEKGReportFileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEKGReportFileExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetEKGReportFileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEKGReportFileExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetEKGReportFileExecute(ByRef qHandle As %Binary, params As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s paramStdDate=$p(params,"^",1)
 	s paramEndDate=$p(params,"^",2)
 	
 	i paramStdDate["-" s paramStdDate=$zdh(paramStdDate,3)
	i paramEndDate["-" s paramEndDate=$zdh(paramEndDate,3)
	
	i paramStdDate["/" d
	.s paramStdDate=$replace(paramStdDate,"/","-") 
	.s paramStdDate=$zdh(paramStdDate,3)	
	i paramEndDate["/" d
	.s paramEndDate=$replace(paramEndDate,"/","-")
	.s paramEndDate=$zdh(paramEndDate,3)
	
	i (paramStdDate="") s paramStdDate=$p($h,",",1)
	i (paramEndDate="") s paramEndDate=$p($h,",",1)
	
	new $namespace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	
	s terminal=0
	s arbTime="" ;以审核时间为条件进行查询
	f  s arbTime=$o(^dbo.tblExaminationI("idxArbiterTime",arbTime),-1) q:(arbTime="")!(terminal)  d
	.;w "arbTime :"_arbTime,!
	.q:(arbTime="9999-12-31 23:59:59")!(arbTime=-100000000000000)
	.//以审核时间为条件过滤
	.s arbDate=$zdh($p(arbTime,$c(32),1),3)
	.;w "arbDate :"_arbDate_", paramStdDate :"_paramStdDate_", paramEndDate :"_paramEndDate,!
	.i (arbDate<paramStdDate) s terminal=1 ;审核时间小于查询的起始时间，退出循环
	.q:((arbDate>paramEndDate)!(arbDate<paramStdDate))
	.s QexamId=""
	.f  s QexamId=$o(^dbo.tblExaminationI("idxArbiterTime",arbTime,QexamId),-1) q:(QexamId="")  d
	..;w "QexamId :"_QexamId,!
	..s QexamInfo=$g(^dbo.tblExaminationD(QexamId))
	..q:(QexamInfo="")
	..s statusCode=$listget(QexamInfo,20)
	..;w "statusCode :"_statusCode,!
	..q:((statusCode'="15")&&(statusCode'="17")) ;未审核
	..s reqId=$listget(QexamInfo,19)
	..q:(reqId="")
	..s reqInfo=$g(^dbo.tblRequestD(reqId))
	..q:(reqInfo="")
	..s ordId=$listget(reqInfo,6)
	..q:(ordId="")
	..s examModel=$listget(reqInfo,26)
	..q:(examModel="手动检查")
	..s examId=QexamId
	..//查询检查报告信息	
	..d GetReportFile
	..//输出	
	..d OutputFileList
	zn "dhc-app"
 	s qHandle=$lb(0,repid,0)
	q $$$OK


OutputFileList
	new $namespace
	zn "dhc-app"
	s Data=$lb(orderrecformno,checkreportno,businessno,orgcode,uploadstatusmark,orgname,patientname,gendercode,
		gendername,storagetype,filetypecode,filetypename,filename,filepath,filedata,updatetime,businessgenertime)
 	;b ; w Data
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	q
	
GetReportFile
	;b ; 000
	s (orderrecformno,checkreportno,businessno,orgcode,uploadstatusmark,orgname,patientname,gendercode)=""
	s (gendername,storagetype,filetypecode,filetypename,filename,filepath,filedata,updatetime,businessgenertime)=""

	s examInfo=$g(^dbo.tblExaminationD(examId))
	s reqId=$listget(examInfo,19)
	s reqInfo=$g(^dbo.tblRequestD(reqId))
	s patId=$listget(reqInfo,16)
	s patInfo=$g(^dbo.tblPatientD(patId))
	s orderrecformno=$listget(reqInfo,6) ; 医嘱号/电子申请单编号
	s checkreportno=examId ;检查报告单编号
	s businessno=$listget(reqInfo,6)_"_"_examId ; 业务编号,机构唯一标识(优先填写社会信用代码，若无社会信用代码则填组织机构代码)+“_”+电子申请单号+“_”+检查报告单编号
	s orgcode="" ; 机构代码
	s uploadstatusmark="1" ; 数据上传标识
	s orgname="" ; 机构名称
	s patientname=$listget(patInfo,16) ; 患者姓名
	s gender=$listget(patInfo,8) ; 性别
	i (gender="f")
	{
		s gendercode="2" ;性别代码
		s gendername="女性" ;性别名称
	}
	elseif (gender="m")
	{
		s gendercode="1" ;性别代码
		s gendername="男性" ;性别名称
	}
	else
	{
		s gendercode="9" ;性别代码
		s gendername="未说明的性别" ;性别名称
	}
	s storagetype="1" ;存储类型:1、采用ftp非结构文档存 2、采用二进制数据流存储
	s filetypecode="01" ; 文档类型代码
	s filetypename="pdf" ; 文档类型名称
	s pdfFilePath=""	
	s filepathId=""
	s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId),-1)
	i (filepathId'="")
	{
		s fiepathInfo=$g(^dbo.tblFilePathD(filepathId))
		q:(fiepathInfo="")
		s (ftpUrl,volumnCode,volumnId,pdfName)=""
		s pdfName=$listget(fiepathInfo,6)
		s volumnCode=$listget(fiepathInfo,7)
		i ((pdfName'="")&&(volumnCode'=""))
		{
			s filename=pdfName ; 文档名称
			s filename=$p(filename,"/",$l(filename,"/"))
			s volumnId=$o(^dbo.tblDictVolumnI("idxCode"," "_volumnCode,""))
			i (volumnId'="")
			{
				 s ftpUrl=$listget($g(^dbo.tblDictVolumnD(volumnId)),5)
				 s pdfFilePath=ftpUrl_pdfName
			}
		}
	}
	i ($l(filename)>40) s filename=	$e(filename,1,40)
	
	/*	
	s devId=$listget(examInfo,10,"")
	i (devId'="")
	{
		s devInfo=$g(^dbo.tblDeviceD(devId))
		q:(devInfo="")
		s testTypeId=$listget(devInfo,3,"")
		;b ; w testTypeId
		i (testTypeId="1") ;静息类设备，取所有数据记录
		{
			s filepathId=""
			f
			{
				s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId))
				q:(filepathId="")
				s fiepathInfo=$g(^dbo.tblFilePathD(filepathId))
				q:(fiepathInfo="")
				s (ftpUrl,volumnCode,volumnId,pdfName)=""
				s pdfName=$listget(fiepathInfo,6)
				s volumnCode=$listget(fiepathInfo,7)
				i ((pdfName'="")&&(volumnCode'=""))
				{
					s filename=pdfName ; 文档名称
					s filename=$p(filename,"/",$l(filename,"/"))
					s volumnId=$o(^dbo.tblDictVolumnI("idxCode"," "_volumnCode,""))
					i (volumnId'="")
					{
						 s ftpUrl=$listget($g(^dbo.tblDictVolumnD(volumnId)),5)
						 s pdfName=ftpUrl_pdfName
						 i (pdfFilePath'="")
						 {
							 s pdfFilePath=pdfFilePath_"^"_pdfName
						 }
						 else
						 {
							 s pdfFilePath=pdfName
						 }
					}
				}
			}
		}
		else   ;非静息类，只取最新的一条数据
		{
			s filepathId=""
			s avlFilepathId="" ;有效数据
			f
			{
				s filepathId=$o(^dbo.tblFilePathI("idxExaminationID",examId,filepathId))
				q:(filepathId="")
				;b ;w filepathId
				s avlFilepathId=filepathId
			}
			;w "avlFilepathId"_avlFilepathId,!
			q:(avlFilepathId="")
			s fiepathInfo=$g(^dbo.tblFilePathD(avlFilepathId))
			q:(fiepathInfo="")
			s (ftpUrl,volumnCode,volumnId,pdfName)=""
			s pdfName=$listget(fiepathInfo,6)
			s volumnCode=$listget(fiepathInfo,7)
			;w "volumnCode"_volumnCode,!
			;w "pdfName"_pdfName,!
			i ((pdfName'="")&&(volumnCode'=""))
			{
				s filename=pdfName ; 文档名称
				s filename=$p(filename,"/",$l(filename,"/"))
				s volumnId=$o(^dbo.tblDictVolumnI("idxCode"," "_volumnCode,""))
				i (volumnId'="")
				{
					 s ftpUrl=$listget($g(^dbo.tblDictVolumnD(volumnId)),5)
					 s pdfName=ftpUrl_pdfName
					 i (pdfFilePath'="")
					 {
						 s pdfFilePath=pdfFilePath_"^"_pdfName
					 }
					 else
					 {
						 s pdfFilePath=pdfName
					 }
				}
			}
		}
	}
	*/
	;s filename="" ; 文档名称
	s filepath=pdfFilePath ; 文档存储路径
	s filedata="" ; 文档数据
	
	s arbiterTime=$listget(examInfo,6) ; 检查审核时间
	s arbiterTime=$replace($replace($replace(arbiterTime,"-","")," ",""),":","") ;转换为【YYYYMMDDHH24MISS】格式
	s updatetime=$replace($replace($zdt($h,8)," ",""),":","") ;转换为【YYYYMMDDHH24MISS】格式 ; 业务数据更新时间
	s businessgenertime=arbiterTime ; 业务数据产生时间
	
	q
}

}
