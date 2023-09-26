Class web.DHCINSUSetlInfo Extends %RegisteredObject
{

/// ///////////////////////////////////////////////////////////////////////////////////////////
/// 4101-1 结算清单信息-单行信息－－结算信息
/// 	一次就诊多次结算时，结算清单是否合并，要项目经理和医院核实 20210322。
/// ##Class(web.DHCINSUSetlInfo).GetPatEprValueByCode(EpisodeID,InsuDivID,InputOBJ)
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// 	InputOBJ:没有用删除
/// 负责人：交付中心、计费医保、电子病历共同完成（包含费用信息、病历首页信息）
ClassMethod GetPatEprValueByCode(EpisodeID, InsuDivID = "", ExpStr) As %ArrayOfDataTypes
{
	s setlinfo=##class(%ArrayOfDataTypes).%New()
	d setlinfo.SetAt("-1","Sucess")
	q:InsuDivID="" setlinfo
	s PBRowID = ""
	s PrtRowID = "" 
	s SeqNo="1"
	d GetPatInfo
	
	//普通电子病历首页和中医病历首页处理
	//增加函数8.0以前版没有
	s templateId=$p(##Class(EMRservice.BL.BLScatterData).GetGlossaryTemplateIDS("HDSD00.12"),"^",1)
	s saveEmrRtn=0
	s:templateId'="" saveEmrRtn=##Class(EMRservice.BOPrivAssist).GetSavedInfo(EpisodeID,templateId,"")
	s saveEmrRtn=$p(saveEmrRtn,",",1)
	i saveEmrRtn>0 s categoryDesc="HDSD00.12"
	e  s categoryDesc="HDSD00.11"
	
	//电子病历病历首页接口--找电子病历核实是不是全集
	s emrObj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,categoryDesc)
    //s emrObj=##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(EpisodeID,categoryDesc) //老项目
	s setlId=$p($g(^DHCINDIV(InsuDivID)),"^",8)
	s mdtrtId=$p($g(^DHCINDIV(InsuDivID)),"^",30)
	s PBRowID=$p($g(^DHCINDIV(InsuDivID)),"^",3)
	s PrtRowID=$p($g(^DHCINDIV(InsuDivID)),"^",4)
	d setlinfo.SetAt(mdtrtId,"mdtrt_id")						//就诊ID
	d setlinfo.SetAt(setlId,"setl_id")							//结算ID	--如果合并，就诊ID和结算ID怎么传？ 20210322。
	d setlinfo.SetAt($g(^||PatInfo("HisCode")),"fixmedins_code")	//定点医药机构编号
	d setlinfo.SetAt($g(^||PatInfo("HospName")),"fixmedins_name")	//定点医药机构名称
	d setlinfo.SetAt($g(^||PatInfo("InsuLevel")),"hi_setl_lv")		//医保结算等级
	s papmiId=$g(^||PatInfo("PatientID"))
	s insuAdmId=$g(^||PatInfo("InsuAdmID"))
	s insuDate=$g(^||PatInfo("InsuDate"))
    s insuTime=$g(^||PatInfo("InsuTime"))
    s admType=$g(^||PatInfo("AdmType"))
    s locId=$p($g(^PAADM(EpisodeID)),"^",4)
    s hospId=""
    s:locId'="" hospId=$p($g(^CTLOC(locId)),"^",22)
    //s insuDate=$g(^||PatInfo("InsuUser"))
    //s insuDate=$g(^||PatInfo("InsuInfo"))
	s insuCardNo=""
	i insuAdmId'="" s insuCardNo=$p($g(^DHCINADM(insuAdmId)),"^",2)
	d setlinfo.SetAt(insuCardNo,"hi_no")						//医保编号
	s insuDateTime=""
	s:(insuDate'="")&&(insuTime'="") insuDateTime=$zd(insuDate,3)_" "_$zt(insuTime)
	d setlinfo.SetAt(insuDateTime,"dcla_time")					//结算清单上报时间
	s cardTypeCode=""
	s cardTypeId=$p($g(^PAPER(papmiId,"PAT",3)),"^",7)
	i cardTypeId'="" s cardTypeCode=$p($g(^PAC("CARD",cardTypeId)),"^",1)
	d setlinfo.SetAt(cardTypeCode,"patn_cert_type")				//患者证件类别
	s insuType=""
	i insuAdmId'="" d
	.s insuType=$p($g(^DHCINADM(insuAdmId)),"^",36)             //险种类型
	.q:insuType=""
	d setlinfo.SetAt(insuType,"hi_type")						//医保类型

	d setlinfo.SetAt($g(^||PatInfo("InsuAdmStates")),"insuplc")	//参保地-待确定必填
	d setlinfo.SetAt("","sp_psn_type")							//特殊人员类型-待确定(字典表9.193)
	b ;1
	i $Isobject(emrObj)
	{
		s medicareNo=emrObj.GetAt(categoryDesc_".006")
		d setlinfo.SetAt(medicareNo,"medcasno")					//病案号
		s patName=emrObj.GetAt(categoryDesc_".110")
		d setlinfo.SetAt(patName,"psn_name")					//姓名
		s sex=emrObj.GetAt(categoryDesc_".109")
		d setlinfo.SetAt(sex,"gend")							//性别
		s birthDate=emrObj.GetAt(categoryDesc_".014")
		i (birthDate'="")&&(birthDate'["-")&&($l(birthDate)=8){
			s $e(birthDate,6)=$e(birthDate,6)_"-"
			s $e(birthDate,4)=$e(birthDate,4)_"-"
		}
		d setlinfo.SetAt(birthDate,"brdy")						//出生日期
		s ageYear=emrObj.GetAt(categoryDesc_".079")
		s ageYear=$tr(ageYear,"Y","")
		d setlinfo.SetAt(ageYear,"age")							//年龄(岁)
		s country=emrObj.GetAt(categoryDesc_".563")
		d setlinfo.SetAt(country,"ntly")						//国籍
		s ageDay=emrObj.GetAt(categoryDesc_".807")
		s ageDay=$tr(ageDay,"Y","")
		i ageYear>=1 s ageDay=0
		d setlinfo.SetAt(ageDay,"nwb_age")						//(年龄不足1周岁)年龄(天)
		s nation=emrObj.GetAt(categoryDesc_".590")
		d setlinfo.SetAt(nation,"naty")							//民族-未找到对照关系
		s certNo=emrObj.GetAt(categoryDesc_".048")
		d setlinfo.SetAt(certNo,"certno")						//患者证件号码
		s occuption=emrObj.GetAt(categoryDesc_".125")
		d setlinfo.SetAt(occuption,"prfs")						//职业-未找到对照关系
		s curAddress=emrObj.GetAt(categoryDesc_".102")_emrObj.GetAt(categoryDesc_".103")_emrObj.GetAt(categoryDesc_".104")_emrObj.GetAt(categoryDesc_".101")
		i curAddress="!!!" s curAddress=""
		d setlinfo.SetAt(curAddress,"curr_addr")				//现住址
		s empName=emrObj.GetAt(categoryDesc_".035")
		d setlinfo.SetAt(empName,"emp_name")					//单位名称
		s empAddress=emrObj.GetAt(categoryDesc_".035")
		d setlinfo.SetAt(empAddress,"emp_addr")					//单位地址
		s empPhone=emrObj.GetAt(categoryDesc_".034")
		d setlinfo.SetAt(empPhone,"emp_tel")					//单位电话
		s postCode=emrObj.GetAt(categoryDesc_".106")
		d setlinfo.SetAt(postCode,"poscode")					//邮编
		s conerName=emrObj.GetAt(categoryDesc_".065")
		d setlinfo.SetAt(conerName,"coner_name")				//联系人姓名
		s relationShip=emrObj.GetAt(categoryDesc_".066")
		d setlinfo.SetAt(relationShip,"patn_rlts")				//与患者关系-未找到对照关系
		s conerAddress=emrObj.GetAt(categoryDesc_".059")
		d setlinfo.SetAt(conerAddress,"coner_addr")				//联系人地址
		s conerPhone=emrObj.GetAt(categoryDesc_".064")
		d setlinfo.SetAt(conerPhone,"coner_tel")				//联系人电话
		d setlinfo.SetAt("","nwb_adm_type")						//新生儿入院类型-待确定
		s bithWeight=emrObj.GetAt(categoryDesc_".107")
		i bithWeight="" s bithWeight=0
		d setlinfo.SetAt(bithWeight,"nwb_bir_wt")				//新生儿出生体重
		s admWeigth=emrObj.GetAt(categoryDesc_".108")
		i admWeigth="" s admWeigth=0
		d setlinfo.SetAt(admWeigth,"nwb_adm_wt")				//新生儿入院体重
		
		s inMedType=$s(admType="I":1,1:"")
		d setlinfo.SetAt(inMedType,"ipt_med_type")				//住院医疗类型-待确定(字典表9.90)
		s admWay=emrObj.GetAt(categoryDesc_".086")
		d setlinfo.SetAt(admWay,"adm_way")						//入院途径
		s treatType=emrObj.GetAt(categoryDesc_".914")
		d setlinfo.SetAt(treatType,"trt_type")					//治疗类别-无对照
		s admDateTime=emrObj.GetAt(categoryDesc_".085")
		i admDateTime["T",admDateTime'["-",admDateTime'[":"
		{
			s admDateTime=$replace(admDateTime,"T"," ")
			s $e(admDateTime,13)=$e(admDateTime,13)_":"
			s $e(admDateTime,11)=$e(admDateTime,11)_":"
			s $e(admDateTime,6)=$e(admDateTime,6)_"-"
			s $e(admDateTime,4)=$e(admDateTime,4)_"-"
		}
		d setlinfo.SetAt(admDateTime,"adm_time")				//入院时间
		s admLoc=emrObj.GetAt(categoryDesc_".1004")
		s admLoc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon00A",admLoc,6)
		;b ;123456
		d setlinfo.SetAt(admLoc,"adm_caty")						//入院科别
		s transLoc=emrObj.GetAt(categoryDesc_".907")
		s transLoc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon00A",transLoc,6)
		i emrObj.GetAt(categoryDesc_".908")'="" s transLoc=transLoc_"→"_##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon00A",emrObj.GetAt(categoryDesc_".908"),6)
		i emrObj.GetAt(categoryDesc_".909")'="" s transLoc=transLoc_"→"_##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon00A",emrObj.GetAt(categoryDesc_".909"),6)
		d setlinfo.SetAt(transLoc,"refldept_dept")				//转科科别
		s disDateTime=emrObj.GetAt(categoryDesc_".019")
		i disDateTime["T",disDateTime'["-",disDateTime'[":"
		{
			s disDateTime=$replace(disDateTime,"T"," ")
			s $e(disDateTime,13)=$e(disDateTime,13)_":"
			s $e(disDateTime,11)=$e(disDateTime,11)_":"
			s $e(disDateTime,6)=$e(disDateTime,6)_"-"
			s $e(disDateTime,4)=$e(disDateTime,4)_"-"
		}
		d setlinfo.SetAt(disDateTime,"dscg_time")				//出院时间
		s disLoc=emrObj.GetAt(categoryDesc_".1005")
		s disLoc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("deptCon00A",disLoc,6)
		;b ;1234567
		d setlinfo.SetAt(disLoc,"dscg_caty")					//出院科别
		s admDay=emrObj.GetAt(categoryDesc_".087")
		d setlinfo.SetAt(admDay,"act_ipt_days")					//实际住院天数
		d setlinfo.SetAt("","vent_used_dura")					//呼吸机使用时长-待确定暂为空
		s timeStr1=emrObj.GetAt(categoryDesc_".070")_"/"_emrObj.GetAt(categoryDesc_".071")_"/"_emrObj.GetAt(categoryDesc_".072")
		i timeStr1="//" s timeStr1=""
		i timeStr1="—/—/—" s timeStr1=""
		d setlinfo.SetAt(timeStr1,"pwcry_bfadm_coma_dura")		//颅脑损伤患者入院前昏迷时长
		s timeStr2=emrObj.GetAt(categoryDesc_".067")_"/"_emrObj.GetAt(categoryDesc_".068")_"/"_emrObj.GetAt(categoryDesc_".069")
		i timeStr2="//" s timeStr2=""
		i timeStr2="—/—/—" s timeStr2=""
		d setlinfo.SetAt(timeStr2,"pwcry_afadm_coma_dura")		//颅脑损伤患者入院后昏迷时长
		
		s disWay=emrObj.GetAt(categoryDesc_".057")
		d setlinfo.SetAt(disWay,"dscg_way")						//离院方式
		s acpHospName=emrObj.GetAt(categoryDesc_".078")
		i acpHospName="" s acpHospName=emrObj.GetAt(categoryDesc_".545")
		d setlinfo.SetAt(acpHospName,"acp_medins_name")			//拟接收机构名称
		d setlinfo.SetAt(acpHospName,"acp_optins_code")			//拟接收机构代码
		
		s admin31Flag=emrObj.GetAt(categoryDesc_".015")
		d setlinfo.SetAt(admin31Flag,"days_rinp_flag_31")		//出院31天内再住院计划标志-无对照
		s admin31Reason=emrObj.GetAt(categoryDesc_".016")
		d setlinfo.SetAt(admin31Reason,"days_rinp_pup_31")		//出院31天内再住院目的
		s admDocName=emrObj.GetAt(categoryDesc_".141")
		d setlinfo.SetAt(admDocName,"chfpdr_name")				//主诊医师姓名
		s admDocCode=emrObj.GetAt(categoryDesc_".578")
		i (admDocCode="")&&(admDocName'="") 
		{   s CTCPId=""
			s CTCPId=$o(^CTPCP(0,"Decs",admDocName,CTCPId))
			s:CTCPId'="" admDocCode=$p($G(^CTPCP(CTCPId,1)),"^",1)
		}
		d setlinfo.SetAt(admDocCode,"chfpdr_code")				//主诊医师代码
	}
	else{
		s medicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmiId,admType,hospId,.errmsg)
		d setlinfo.SetAt(medicareNo,"medcasno")					//病案号
		
		s patName=$p($g(^PAPER(papmiId,"ALL")),"^")
		d setlinfo.SetAt(patName,"psn_name")					//姓名
		s sex=$p($g(^PAPER(papmiId,"ALL")),"^",7)
		s:sex'="" sex=$p($g(^CT("SEX",sex)),"^",1)
		d setlinfo.SetAt(sex,"gend")							//性别
		s birthDate=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		s:birthDate'="" birthDate=$zd(birthDate,3)
		d setlinfo.SetAt(birthDate,"brdy")						//出生日期
		s ageYear=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
		d setlinfo.SetAt(+$p(ageYear,"岁",1),"age")				//年龄(岁)
		s country=emrObj.GetAt(categoryDesc_".036")
		s country =$p($g(^PAPER(papmiId,"PER",1)),"^",8) 		//国籍
    	s:country'="" country=$p($g(^CT("COU",country)),"^",2) 
		d setlinfo.SetAt(country,"ntly")						//国籍
		s ageDay=0
		d setlinfo.SetAt(ageDay,"nwb_age")						//(年龄不足1周岁)年龄(天)
		s nation=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
    	s:nation'="" nation=$p($g(^CT("NAT",nation)),"^",2)
		d setlinfo.SetAt(nation,"naty")							//民族-未找到对照关系
		s certNo=$p($g(^PAPER(papmiId,"ALL")),"^",9)
		d setlinfo.SetAt(certNo,"certno")						//患者证件号码
		;s occuption=$p($g(^PAPER(papmiId,"PER",2)),"^",6)
    	;s:occuption'="" occuption=$p($g(^CT("OCC",occuption)),"^",2)
		;d setlinfo.SetAt(occuption,"prfs")						//职业-未找到对照关系
		s occuption=emrObj.GetAt(categoryDesc_".125")
		s:occuption="" occuption="90"
		d setlinfo.SetAt(occuption,"prfs")
		s curAddress=##Class(EMRservice.HISInterface.PatientInfoAssist).ResidentAddressNew(papmiId,hospId)
		i curAddress="!!!" s curAddress=""
		d setlinfo.SetAt(curAddress,"curr_addr")				//现住址
		s empName=$p($g(^PAPER(papmiId,"PER",4)),"^",18) 
		d setlinfo.SetAt(empName,"emp_name")					//单位名称
		s empAddress=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkAddress(papmiId,hospId)
		d setlinfo.SetAt(empAddress,"emp_addr")					//单位地址
		s empPhone=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkPhone(papmiId,hospId)
		d setlinfo.SetAt(empPhone,"emp_tel")					//单位电话
		s postCode=##Class(EMRservice.HISInterface.PatientInfoAssist).WorkPostCode(papmiId,hospId)
		d setlinfo.SetAt(postCode,"poscode")					//邮编
		s conerName=$p($g(^PAPER(papmiId,"PER",2)),"^",13)
		d setlinfo.SetAt(conerName,"coner_name")				//联系人姓名
		s relationShip=$p($g(^PAPER(papmiId,"EMP")),"^",4)
		s:relationShip'="" relationShip=$p($g(^CT("RLT",relationShip)),"^",1)
		d setlinfo.SetAt(relationShip,"patn_rlts")				//与患者关系-未找到对照关系
		s conerAddress=$p($g(^PAPER(papmiId,"PER",1)),"^",1)
		d setlinfo.SetAt(conerAddress,"coner_addr")				//联系人地址
		s conerPhone=$p($g(^PAPER(papmiId,"ALL")),"^",4)
		d setlinfo.SetAt(conerPhone,"coner_tel")				//联系人电话
		
		d setlinfo.SetAt("","nwb_adm_type")						//新生儿入院类型-待确定
		s bithWeight=""
		i bithWeight="" s bithWeight=0
		d setlinfo.SetAt(bithWeight,"nwb_bir_wt")				//新生儿出生体重
		s admWeigth=""
		i admWeigth="" s admWeigth=0
		d setlinfo.SetAt(admWeigth,"nwb_adm_wt")				//新生儿入院体重
		
		s inMedType=$s(admType="I":1,1:"")
		d setlinfo.SetAt(inMedType,"ipt_med_type")				//住院医疗类型-待确定(字典表9.90)
		
		s admWay=$p($g(^PAADM(EpisodeID)),"^",10)  ;入院途径
		s:admWay'="" admWay=$p($g(^PAC("ADSOU",admWay)),"^",1)
		d setlinfo.SetAt(admWay,"adm_way")						//入院途径
		s treatType=""
		d setlinfo.SetAt(treatType,"trt_type")					//治疗类别-无对照
		s admDateTime=""
		s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
    	s admTime=$p($g(^PAADM(EpisodeID)),"^",7)
    	s:(admDate'="")&&(admTime'="") admDateTime=$zd(admDate,3)_" "_$zt(admTime)
		d setlinfo.SetAt(admDateTime,"adm_time")				//入院时间
		s admLoc=""
		s transLoc=""
		s tranSub=0,lastLocID=""
		f  s tranSub=$o(^PAADM(EpisodeID,"TRANS",tranSub)) q:tranSub=""  d
		.s tranLocID=$p($g(^PAADM(EpisodeID,"TRANS",tranSub)),"^",6)
		.q:tranLocID=""
		.q:(lastLocID'="")&&(lastLocID=tranLocID)
		.s tranLocCode=$p($g(^CTLOC(tranLocID)),"^",1)
		.s:admLoc'="" transLoc=$s(transLoc="":tranLocCode,1:transLoc_"→"_tranLocCode)
		.s:admLoc="" admLoc=tranLocCode
		.s lastLocID=tranLocID
		d setlinfo.SetAt(admLoc,"adm_caty")						//入院科别
		d setlinfo.SetAt(transLoc,"refldept_dept")				//转科科别
		s disDateTime=""
		s disDate=$p($g(^PAADM(EpisodeID)),"^",17)
    	s disTime=$p($g(^PAADM(EpisodeID)),"^",18)
    	s:(disDate'="")&&(disTime'="") disDateTime=$zd(disDate,3)_" "_$zt(disTime)
		d setlinfo.SetAt(disDateTime,"dscg_time")				//出院时间
		d setlinfo.SetAt($g(^||PatInfo("AdmLocCode")),"dscg_caty")	//出院科别
		s admDay=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(EpisodeID)
		s admDay=$p(admDay,"^",3)	
		i admDay=0 s admDayret="0"
		d setlinfo.SetAt(admDay,"act_ipt_days")					//实际住院天数
		d setlinfo.SetAt("","vent_used_dura")					//呼吸机使用时长-待确定暂为空
		s timeStr1=""
		d setlinfo.SetAt(timeStr1,"pwcry_bfadm_coma_dura")		//颅脑损伤患者入院前昏迷时长
		s timeStr2=""
		d setlinfo.SetAt(timeStr2,"pwcry_afadm_coma_dura")		//颅脑损伤患者入院后昏迷时长
		
		s disWay=""
		s mrAdmID=$p($g(^PAADM(EpisodeID)),"^",61)
		s:mrAdmID'="" disWay=$p($g(^MR(mrAdmID,"PRO",1)),"^",10)
		s:disWay'="" disWay=$p($g(^PAC("DISCON",disWay)),"^",1)
		d setlinfo.SetAt(disWay,"dscg_way")						//离院方式
		s acpHospName=""
		d setlinfo.SetAt(acpHospName,"acp_medins_name")			//拟接收机构名称
		d setlinfo.SetAt(acpHospName,"acp_optins_code")			//拟接收机构代码
		
		s admin31Flag=""
		d setlinfo.SetAt(admin31Flag,"days_rinp_flag_31")		//出院31天内再住院计划标志-无对照
		s admin31Reason=""
		d setlinfo.SetAt(admin31Reason,"days_rinp_pup_31")		//出院31天内再住院目的
		s admDocName="",admDocCode=""
		s admDoc=$p(^PAADM(EpisodeID),"^",9)
		i admDoc'="" s admDocCode=$p($g(^CTPCP(admDoc,1)),"^",1),admDocName=$p($g(^CTPCP(admDoc,1)),"^",2)
		d setlinfo.SetAt(admDocName,"chfpdr_name")				//主诊医师姓名
		d setlinfo.SetAt(admDocCode,"chfpdr_code")				//主诊医师代码
	}
	
	//特病诊断相关
	s opspFlag=""
	i insuAdmId'="" s opspFlag=$p($g(^DHCINADM(insuAdmId)),"^",14)
	d setlinfo.SetAt("","opsp_diag_caty")						//门诊慢特病诊断科别
	d setlinfo.SetAt("","opsp_mdtrt_date")						//门诊慢特病就诊日期	
	d setlinfo.SetAt("","otp_wm_dise")							//门（急）诊西医诊断
	d setlinfo.SetAt("","wm_dise_code")							//西医诊断疾病代码
	d setlinfo.SetAt("","otp_tcm_dise")							//门（急）诊中医诊断-待确定
	d setlinfo.SetAt("","tcm_dise_code")						//中医诊断代码-待确定
	s diagCount=0
	f i=1:1:7
	{
	 	s diagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"D/"_i)
	 	continue:diagStr=""
	 	s len=$l(diagStr,$c(1))
	 	s diagCount=diagCount+len
	}
	d setlinfo.SetAt(diagCount,"diag_code_cnt")					//诊断代码计数-待确定
	i opspFlag=14 d												//个性化判断?
	.d setlinfo.SetAt($g(^||PatInfo("admLocCode")),"otp_wm_dise")					
	.d:$g(^||PatInfo("admDate"))'="" setlinfo.SetAt($zd($g(^||PatInfo("admDate")),3),"wm_dise_code")			
	s dialogInfo=##class(DHCWMR.IO.OutService).IGetFrontPageICD(EpisodeID,"D/6",1)
	i dialogInfo'="" d
	.d setlinfo.SetAt($p(dialogInfo,$c(2),2),"otp_wm_dise")		
	.d setlinfo.SetAt($p(dialogInfo,$c(2),1),"wm_dise_code")
	s oprnCount=0
	f i=1:1:2
	{
	 	s operatorInfo=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"O/"_i)
	 	continue:operatorInfo=""
	 	s len=$l(operatorInfo,$c(1))
	 	s oprnCount=oprnCount+len
	}
	d setlinfo.SetAt(oprnCount,"oprn_oprt_code_cnt")			//手术操作代码计数
	d setlinfo.SetAt("","bld_cat")								//输血品种-暂时为空
	d setlinfo.SetAt("","bld_amt")								//输血量长-暂时为空
	d setlinfo.SetAt("","bld_unt")								//输血计量单位-暂时为空
	s Lvt=##class(web.FG.fenggui).getLevelCareDays(EpisodeID,"2609||1")
	d setlinfo.SetAt(Lvt,"spga_nurscare_day")					//特级护理天数-待确定
	s Lv1=##class(web.FG.fenggui).getLevelCareDays(EpisodeID,"2608||1")
	d setlinfo.SetAt(Lv1,"lv1_nurscare_days")					//一级护理天数-待确定
	s Lv2=##class(web.FG.fenggui).getLevelCareDays(EpisodeID,"2606||1")
	d setlinfo.SetAt(Lv2,"scd_nurscare_days")					//二级护理天数-待确定
	s Lv3=##class(web.FG.fenggui).getLevelCareDays(EpisodeID,"2605||1")
	d setlinfo.SetAt(Lv3,"lv3_nurscare_days")					//三级护理天数-待确定
	
	//收费相关
	s billInfo=""
	i PBRowID'=""
	{
		s prtRowId=$o(^DHCINVPRTZY(0,"AR",PBRowID,""),-1)
		s:prtRowId'="" billInfo=..GetEInvBillNoStr("IP",prtRowId,"E")
		s pbDateFrom=$p($g(^DHCPB(PBRowID)),"^",6)
		s:pbDateFrom'="" pbDateFrom=$zd(pbDateFrom,3)
		s pbDateTo=$p($g(^DHCPB(PBRowID)),"^",7)
		s:pbDateTo'="" pbDateTo=$zd(pbDateTo,3)
	}
	else{
		s:PrtRowID'="" billInfo=..GetEInvBillNoStr("OP",PrtRowID,"E")
		s pbDateFrom=$p($g(^DHCINVPRT(PrtRowID)),"^",5)
		s:pbDateFrom'="" pbDateFrom=$zd(pbDateFrom,3)
		s pbDateTo=$p($g(^DHCINVPRT(PrtRowID)),"^",5)
		s:pbDateTo'="" pbDateTo=$zd(pbDateTo,3)
	}
	;s billInfo="1^2^3^4^5"
	d setlinfo.SetAt($p(billInfo,"^",1),"bill_code")			//票据代码
	d setlinfo.SetAt($p(billInfo,"^",2),"bill_no")				//票据号码
	d setlinfo.SetAt($p(billInfo,"^",5),"biz_sn")				//业务流水号
	
	s insudivinfo=##class(web.DHCINSUPort).GetDivInfoForINV("","",InsuDivID,"")
	;0^医保类型^医保编号^医保结算总金额^医保统筹基金支付^其他支付^个人账户支付^个人现金支付^个人自付^个人自费^
	s (pbSelfPaid,pbOwnPaid,accountPaid,psnPaid)=0
	;s pbSelfPaid=+$p($g(^DHCINDIV(InsuDivID)),"^",55)
	;s pbOwnPaid=+$p($g(^DHCINDIV(InsuDivID)),"^",54)
	;s psnPaid=+$p($g(^DHCINDIV(InsuDivID)),"^",15)
	;s accountPaid=+$p($g(^DHCINDIV(InsuDivID)),"^",19)
	i $p(insudivinfo,"^",1)=0 d
	.s pbSelfPaid=$p(insudivinfo,"^",9)
	.s pbOwnPaid=$p(insudivinfo,"^",10)
	.s accountPaid=$p(insudivinfo,"^",7)
	.s psnPaid=$p(insudivinfo,"^",8)
	
	d setlinfo.SetAt(pbDateFrom,"setl_begn_date")				//结算开始日期
	d setlinfo.SetAt(pbDateTo,"setl_end_date")					//结算结束日期
	d setlinfo.SetAt(pbSelfPaid,"psn_selfpay")					//个人自付
	d setlinfo.SetAt(pbOwnPaid,"psn_ownpay")					//个人自费
	d setlinfo.SetAt(accountPaid,"acct_pay")					//个人账户支出
	d setlinfo.SetAt(psnPaid,"psn_cashpay")						//个人现金支付
	
	d setlinfo.SetAt("3","hi_paymtd")							//医保支付方式-暂时传3
	d setlinfo.SetAt($g(^||PatInfo("AdmPlaceCode")),"hsorg")		//医保机构-待确认
	d setlinfo.SetAt($g(^||PatInfo("InsuSubUser")),"hsorg_opter")							//医保机构经办人-待确认
	d setlinfo.SetAt($g(^||PatInfo("InsuSubGroup")),"medins_fill_dept")	//医疗机构填报部门-待确认
	d setlinfo.SetAt($g(^||PatInfo("InsuSubUser")),"medins_fill_psn")		//医疗机构填报人-待确认
	
	d setlinfo.SetAt("0","Sucess")
	b ; zw setlinfo
	q setlinfo
	
GetPatInfo
	k ^||PatInfo
	s curDate=$zd(+$h,3)
    s curTime=$zt($p($h,",",2))
    s curDateTime=curDate_" "_curTime
	s timeStr=$tr(curDateTime," -:","")
	s ^||PatInfo("CurDate")=curDate
	s ^||PatInfo("CurTime")=curTime
	s ^||PatInfo("CurDateTime")=curDateTime
	s ^||PatInfo("TimeStr")=timeStr
	s ^||PatInfo("HisCode")=""
	s ^||PatInfo("AdmPlaceCode")=""
	s ^||PatInfo("InsuLevel")=3
	s ^||PatInfo("InsuSubGroup")=1
	s ^||PatInfo("InsuSubUser")=1
    s ^||PatInfo("HospName")="test"
    s ^||PatInfo("SignPass")=""
    s ^||PatInfo("signUser")=""
    
	s papmId=+$g(^PAADM(EpisodeID))
	s ^||PatInfo("PatientID")=papmId
	s admType=$p($g(^PAADM(EpisodeID)),"^",2)
	s ^||PatInfo("AdmType")=admType
	s locId=$p($g(^PAADM(EpisodeID)),"^",4)
	s ^||PatInfo("AdmLocID")=locId
	s admLocCode=$p($g(^CTLOC(locId)),"^",1)
	s admLocDesc=$p($g(^CTLOC(locId)),"^",2)
	s ^||PatInfo("AdmLocCode")=admLocDesc
    s hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(locId)
    s hospName=##class(web.UDHCHospitalGroup).getHospitalName(hospId)
    s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
    s admTime=$p($g(^PAADM(EpisodeID)),"^",7)
    s ^||PatInfo("AdmDate")=admDate
    s ^||PatInfo("AdmTime")=admTime
    s ^||PatInfo("HospID")=hospId
    s ^||PatInfo("HospName")=hospName
    s insuAdmId=$p($g(^DHCINDIV(InsuDivID)),"^",2)
	s insuDate=$p($g(^DHCINDIV(InsuDivID)),"^",16)
	s insuTime=$p($g(^DHCINDIV(InsuDivID)),"^",17)
	s insuUser=$p($g(^DHCINDIV(InsuDivID)),"^",21)
	s insuInfo=..GetInsuSignInfo(insuUser,insuDate,hospId)
	s ^||PatInfo("InsuAdmID")=insuAdmId
    s ^||PatInfo("InsuDate")=insuDate
    s ^||PatInfo("InsuTime")=insuTime
    s ^||PatInfo("InsuUser")=insuUser
    s ^||PatInfo("InsuInfo")=insuInfo
	s insuAdmStates=""
	i insuAdmId'="" s insuAdmStates=$p($g(^DHCINADM(insuAdmId)),"^",4)
	s ^||PatInfo("InsuAdmStates")=insuAdmStates
	;q ^||PatInfo
}

/// 源程序##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBillNoStr    取电子发票信息
ClassMethod GetEInvBillNoStr(PayAdmType As %String, HISPrtRowID As %String, IUDPrintType As %String = "E") As %String
{
	q:(PayAdmType="")||(HISPrtRowID="")||(IUDPrintType="") ""
	
	s ID=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey", PayAdmType, HISPrtRowID, IUDPrintType, ""),-1)
	q:ID="" ""
	s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ID)
	s EInvFlg=objUpDetail.EInvFlg
	q:EInvFlg="" ""
	s BillBatchCode=objUpDetail.IUDBillBatchCode			;票据代码
	s BillNo=objUpDetail.IUDBillBatchNo						;票据号码
	s Random=objUpDetail.IUDCheckCode						;校验码
	s EInvNo=objUpDetail.EinvprtNo
	s BillBusNo=objUpDetail.IUDBusNo						;业务流水号
	s EInvStr=BillBatchCode_"^"_BillNo_"^"_Random_"^"_EInvNo_"^"_BillBusNo
	q EInvStr
}

/// 4101-2 门诊慢特病诊断信息-多行信息，需要修改
/// ##Class(web.DHCINSUSetlInfo).GetPatEprValueByCode(EpisodeID,InsuDivID,insuAdmRowid,SeqNo,PatInfo)
/// 临床慢特病诊断信息（取得医生下的诊断）
/// 负责人：交付中心、计费医保（可能每个项目都要修改）
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// 	insuAdmRowid:医保就诊登记表ID
/// 	ExpStr:扩展参数
ClassMethod GetPatOPSPDiseInfo(EpisodeID, InsuDivID = "", insuAdmRowid, ExpStr As %String) As %ListOfDataTypes
{
	s ret=##class(%ListOfDataTypes).%New()
	d ret.SetAt("-1","没有数据")
	s insuAdmRowid=""
	i InsuDivID'="" d
	.s insuAdmRowid=$p(^DHCINDIV(InsuDivID),"^",2)
	
	s opspFlag=""
	i insuAdmRowid'="" s opspFlag=$p($g(^DHCINADM(insuAdmRowid)),"^",14)
	;s opspFlag=14 ;test,
	i opspFlag=14
	{
		s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
		;s mradm=20 ;test
		f sub=1:1:$g(^MR(mradm,"DIA",0)) d
		.s icdId=$p($g(^MR(mradm,"DIA",sub)),"^",1)
		.q:icdId=""
		.s diagTypeId=$p($g(^MR(mradm,"DIA",sub,"TYP",1)),"^",1)
		.q:diagTypeId=""
		.s diagType=$P($g(^MRC("DTYP",diagTypeId)),"^",1)			//诊断类型
		.s diagCode=$p($g(^MRC("ID",icdId)),"^",1)   				//诊断代码
		.s diagDesc=$p($g(^MRC("ID",icdId)),"^",2)   				//诊断描述
		.s objSingle=##class(%ArrayOfDataTypes).%New()
		.d objSingle.SetAt(diagDesc,"diag_name")					//诊断代码
		.d objSingle.SetAt(diagCode,"diag_code")					//诊断描述
		.d objSingle.SetAt("","oprn_oprt_code")						//手术操作代码
		.d objSingle.SetAt("","oprn_oprt_name")						//手术操作名称
		.d ret.Insert(objSingle)
		d ret.SetAt("0","Sucess")
	}
	q ret
}

/// 4101-5  iteminfo  收费项目信息 （计费医保组）
/// 入参:BillDr 住院账单表rowid，PrtDr 门诊发票表rowid，InDivDr 医保结算表rowid，AdmDr 就诊rowid，(四选一)  ？？
/// 	 ExpStr 扩展参数 暂空
/// 出参:MedChrgitm:医疗收费项目类别,AmtSum:金额,ClaaSumfeeSum:甲类费用合计,ClabAmtSum:乙类费用合计,FulamtOwnpayAmtSum:全自费金额合计,OthAmtSum:其他金额合计
/// 出参:
/// MedChrgitm:医疗收费项目类别,
/// AmtSum:金额,
/// ClaaSumfeeSum:甲类费用合计,
/// ClabAmtSum:乙类费用合计,
/// FulamtOwnpayAmtSum:全自费金额合计,
/// OthAmtSum:其他金额合计
/// 注意事项：要是核实是  收费项目明细 还是按收费项目分类汇总  liusf  2021 03 28
/// (PrtDr="")&&(BillDr="")&&(InDivDr="")&&(AdmDr="")    这个四个参数哪里来的  liusf
/// 负责人：交付中心、计费医保共同完成     ；根据当地医保程序修改
Query GetPatFeeItemInfo(BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As websys.Query(ROWSPEC = "MedChrgitm:%String,AmtSum,ClaaSumfeeSum,ClabAmtSum,FulamtOwnpayAmtSum,OthAmtSum,SetlId,MdtrtId,JsdId") [ SqlProc ]
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUSetlInfo","GetPatFeeItemInfo","2127118","","","","")
/// 
ClassMethod GetPatFeeItemInfoExecute(ByRef qHandle As %Binary, BillDr As %String = "", PrtDr As %String = "", InDivDr As %String = "", AdmDr As %String = "", ExpStr As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)  
    s ^TMPZMC("GetPatFeeItemInfo")=BillDr_","_PrtDr_","_InDivDr
    s HisDesc="",HisCode="",UnitPrice="",Quality="",Amount=""
    q:(PrtDr="")&&(BillDr="")&&(InDivDr="")&&(AdmDr="") $$$OK
	q:(PrtDr'="")&&($d(^DHCINVPRT(PrtDr))=0) $$$OK
	q:(BillDr'="")&&($d(^DHCPB(BillDr))=0) $$$OK
	if BillDr'="" {
		q:$d(^DHCINDIV("0","DHCPB",BillDr))=0 $$$OK
		s InsuDivDr=$o(^DHCINDIV("0","DHCPB",BillDr,""),-1)
	}
	if PrtDr'="" {
		q:$d(^DHCINDIV("0","DHCInvPrt",PrtDr))=0 $$$OK
		s InsuDivDr=$o(^DHCINDIV("0","DHCInvPrt",PrtDr,""),-1)
	}
	if InDivDr'="" {
		q:$d(^DHCINDIV(InDivDr))=0 $$$OK
		s InsuDivDr=InDivDr
	}
	if AdmDr'="" {
		q:$d(^DHCINDIV("0","Paadm",AdmDr))=0 $$$OK
		s InsuDivDr=$o(^DHCINDIV("0","Paadm",AdmDr,""),-1)
	}
	q:InsuDivDr="" $$$OK
	k Sort("InsuIteminfo",InsuDivDr)
	s InsuDivInfo=$g(^DHCINDIV(InsuDivDr))
	s SetlId=$p(InsuDivInfo,"^",8)
	;s SetlId=$p(InsuDivInfo,"^",69)
	s MdtrtId=$p(InsuDivInfo,"^",30)
	s JsdId=$p($g(^DHCINDIV(InsuDivDr)),"^",67)   //医保结算单流水号 每个项目不一样需要修改


	s INDISRowid=""
	f  s INDISRowid=$o(^DHCINDIS("0","DivideDr",InsuDivDr,INDISRowid)) q:INDISRowid=""  d
	.s INDISInfo=$g(^DHCINDIS(INDISRowid))
	.s INSUItmDr=$p(INDISInfo,"^",4)	;
	.s TarItmDr=$p(INDISInfo,"^",3)
	.s INDISINSUXMLB=$p(INDISInfo,"^",10)
	.s INDISQty=+$p(INDISInfo,"^",11)
	.s INDISPrice=$p(INDISInfo,"^",12)
	.s INDISAmount=+$p(INDISInfo,"^",13)
	.s INDISTarCate=$p(INDISInfo,"^",14)
	.s INDISScale=$p(INDISInfo,"^",15)	;自付比例
	.s INDISFund=$p(INDISInfo,"^",16)
	.s INDISSelf=+$p(INDISInfo,"^",17)	;先行自付
	.s INDISDemo1=+$p(INDISInfo,"^",26)	;全自费
	.s INDISDemo2=+$p(INDISInfo,"^",27)	;符合范围
	.s INDISDemo3=+$p(INDISInfo,"^",28)	;超限
	.s TARISubCateDr=$P(^DHCTARI(TarItmDr),"^",4)
	.s TARISubCate=$P(^DHCTarC("SC",TARISubCateDr),"^",1)
	.//s INDISDemo4=$p(INDISInfo,"^",29)	;医疗收费项目   ;根据当地当地程序修改
	.s INDISDemo4 = ##class(web.INSUDicDataCom).GetDicByCodeAndInd("medchrgitmtypeCon00A",TARISubCate,6)
	.s:INDISDemo4="" INDISDemo4="14"	;14其他费
	
	.s (ClaaSumfee,ClabAmt,FulamtOwnpayAmt,OthAmt)=0
	.i INDISINSUXMLB="01"||INDISINSUXMLB="甲类" d
	..s ClaaSumfee=INDISAmount	; 甲类费用        ;3 28  每个地方要修改
	.e  i INDISINSUXMLB="02"||INDISINSUXMLB="乙类" d
	..s ClabAmt=INDISAmount	    ; 乙类费用        ;3 28  每个地方要修改
	.e   d
	..s OthAmt=INDISAmount                        ;3 28  每个地方要修改
	.i $d(Sort("InsuIteminfo",InsuDivDr,INDISDemo4))=0 d
	..s Sort("InsuIteminfo",InsuDivDr,INDISDemo4)=INDISDemo4_"^"_INDISAmount_"^"_ClaaSumfee_"^"_ClabAmt_"^"_FulamtOwnpayAmt_"^"_OthAmt
	.e  d
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",2)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",2)+INDISAmount
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",3)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",3)+ClaaSumfee
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",4)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",4)+ClabAmt
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",5)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",5)+FulamtOwnpayAmt
	..s $p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",6)=+$p(Sort("InsuIteminfo",InsuDivDr,INDISDemo4),"^",6)+OthAmt
	
	s MedChrgitm=""
	f  s MedChrgitm=$o(Sort("InsuIteminfo",InsuDivDr,MedChrgitm)) q:MedChrgitm=""  d
	.s AmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",2)
	.s ClaaSumfeeSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",3)
	.s ClabAmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",4)
	.s FulamtOwnpayAmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",5)
	.s OthAmtSum=$p(Sort("InsuIteminfo",InsuDivDr,MedChrgitm),"^",6)
    .d InsuIteminfoBuild
    
    Quit $$$OK
    
InsuIteminfoBuild
    set Data=$lb(MedChrgitm,AmtSum,ClaaSumfeeSum,ClabAmtSum,FulamtOwnpayAmtSum,OthAmtSum,SetlId,MdtrtId,JsdId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// 4101-手术操作信息-多行信息  6 oprninfo  手术操作信息
/// 编目后数据  （病案编目组和开发）
/// 负责人：交付中心、病案编目组共同完成
/// ##Class(web.DHCINSUSetlInfo).GetPatEprValueByCode(EpisodeID,InsuDivID,PBRowID,SeqNo,PatInfo)
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// 	PBRowID:账单号
ClassMethod GetOprnInfo(EpisodeID, InsuDivID = "", PBRowID, ExpStr As %String) As %ListOfDataTypes
{
	;s EpisodeID=988 ;test
	s DataRow=0  ; 3 28
	s ret=##class(%ListOfDataTypes).%New()
	d ret.SetAt("-1","没有数据")
	s SetlId="",MdtrtId="",JsdId=""
	if InsuDivID'=""
	{
	 s InsuDivInfo=$g(^DHCINDIV(InsuDivID))
	 s SetlId=$p(InsuDivInfo,"^",8)
	 ;s SetlId=$p(InsuDivInfo,"^",69)
	 s MdtrtId=$p(InsuDivInfo,"^",30)
	 s JsdId=$p($g(^DHCINDIV(InsuDivID)),"^",67) //结算单流水号
	}
	f i=1:1:2
	{
	 	s operatorInfo=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"O/"_i)
	 	;s operatorInfo="oprnoprtcodetest"_$c(2)_"oprnoprtnametest"_$c(2)_"oprnoprtdatetest" ;test
	 	continue:operatorInfo=""
	 	s DataRow=DataRow+1  ;3 28
	 	s len=$l(operatorInfo,$c(1))
	 	f j=1:1:len
	 	{
		 	s singleInfo=$p(operatorInfo,$c(1),j)
		 	continue:singleInfo=""
		 	s objSingle=##class(%ArrayOfDataTypes).%New()
		 	s:num>0 oprnoprttype="0"
		 	;s oprnoprtname=$p(singleInfo,$c(2),2)
		 	s oprnoprtcode=$p(singleInfo,$c(2),1)
		 	;b ;ywc123123
		 	s oprnoprtname=$p(##Class(web.DHCINSUSetlInfo).OprationTrascation(oprnoprtcode),"^",2)
		 	s oprnoprtcode=$p(##Class(web.DHCINSUSetlInfo).OprationTrascation(oprnoprtcode),"^",1)
		 	
			d objSingle.SetAt(oprnoprttype,"oprn_oprt_type")							//手术操作类别		;xubaobao 2021 04 20医院要求第一个手术传1，其他传0
			d objSingle.SetAt(oprnoprtname,"oprn_oprt_name")		//手术操作名称
			d objSingle.SetAt(oprnoprtcode,"oprn_oprt_code")		//手术操作代码
		
			d objSingle.SetAt($p(singleInfo,$c(2),3),"oprn_oprt_date")		//手术操作日期
			d objSingle.SetAt($p(singleInfo,$c(2),10),"anst_way")			//麻醉方式
			d objSingle.SetAt($p(singleInfo,$c(2),9),"oper_dr_name")		//术者医师姓名
			s operdrcode=$p(singleInfo,$c(2),8)
			s:operdrcode="" operdrcode=..GetUserCodeByName($p(singleInfo,$c(2),9))
			;b ;operdrcode
			d objSingle.SetAt(operdrcode,"oper_dr_code")					//术者医师代码
			d objSingle.SetAt($p(singleInfo,$c(2),18),"anst_dr_name")		//麻醉医师姓名
			s anstdrcode=$p(singleInfo,$c(2),18)
			s:anstdrcode="" anstdrcode=..GetUserCodeByName($p(singleInfo,$c(2),18))
			d objSingle.SetAt(anstdrcode,"anst_dr_code")					//麻醉医师代码
			d objSingle.SetAt(SetlId,"setl_id")					
			d objSingle.SetAt(MdtrtId,"mdtrt_id")	
			d objSingle.SetAt(j,"oprn_seq")							         //手术序号		
			d objSingle.SetAt(JsdId,"jsd_id")						         //结算单ID		
			d ret.Insert(objSingle)
	 	}
	 	d ret.SetAt("0","Sucess")
	}
	if DataRow=0  d
	.s objSingle=##class(%ArrayOfDataTypes).%New() 
	.d objSingle.SetAt("无编目手术数据","oprn_oprt_name")		//诊断名称
	.d objSingle.SetAt("无编目手术数据","oprn_oprt_code")		//诊断代码
	.d ret.Insert(objSingle)
	.d ret.SetAt("0","Sucess")
	q ret
}

ClassMethod GetUserCodeByName(Name)
{
	q:Name="" ""
	s Name=$$ALPHAUP^SSUTIL4(Name)
	s rowID=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,""))
	q:rowID="" ""
	q $p($g(^SSU("SSUSR",rowID)),"^",1)
}

/// 4101-基金支付信息-多行信息  2- payinfo基金支付信息
///  每个项目要新开发（计费医保组）(要重新设计)
///  负责人：交付中心、计费医保共同完成
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// 	PBRowID:账单号
/// ##Class(web.DHCINSUSetlInfo).GetPatEprValueByCode(EpisodeID,InsuDivID,PBRowID,SeqNo,PatInfo)
ClassMethod GetPatPayInfo(EpisodeID, InsuDivID = "", PBRowID, ExpStr As %String) As %ArrayOfDataTypes
{
	
	//w !,"EpisodeID=",EpisodeID,"InsuDivID=",InsuDivID,"=","GetPatPayInfo"
	s payinfo=##class(%ListOfDataTypes).%New()
	;d payinfo.SetAt("-1","没有数据")
	;s objSingle=##class(%ArrayOfDataTypes).%New()
	;d objSingle.SetAt("-105","fund_pay_type")					//基金支付类型      ；+2021 03 28 liusf
	;d objSingle.SetAt("取基金信息错误","fund_payamt")					//基金支付金额    ；+2021 03 28 liusf
	;d payinfo.Insert(objSingle)                      ;+2021 03 28 liusf
 	i InsuDivID="" s InsuDivID=-9999
	s info=$p($g(^DHCINDIV(InsuDivID)),"^",51)
	q:info="" payinfo
	q:info=0 payinfo
	;s info="paycode1|||10$paycode2||||20"
	s len=$l(info,"$")
	f i=1:1:len{
		s single=$p(info,"$",i)
		continue:single=""
		s code=$p(single,"|",1)
		continue:code=""
		s amount=$p(single,"|",4)
		s objSingle=##class(%ArrayOfDataTypes).%New()
		d objSingle.SetAt(code,"fund_pay_type")					//基金支付类型
		d objSingle.SetAt(amount,"fund_payamt")					//基金支付金额
		d payinfo.Insert(objSingle)
		d payinfo.SetAt("0","Sucess")
	}
	q payinfo
}

/// 
/// 4101-住院诊断信息-多行信息  4 diseinfo 住院诊断信息  7 icuinfo  重症监护信息 编目之后数据
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// 	PBRowID:账单号
/// 程序开发调试负责人（实施和病案编目组）
/// w ##class(web.DHCINSUSetlInfo).GetPatDiseInfo(1287278,"151849","",1,"")
/// ##Class(web.DHCINSUSetlInfo).GetPatEprValueByCode(EpisodeID,InsuDivID,PBRowID,SeqNo,PatInfo)
ClassMethod GetPatDiseInfo(EpisodeID As %String, InsuDivID = "", PBRowID, ExpStr As %String) As %ListOfDataTypes
{
	;s ^TMPZMC("GetPatDiseInfo")=EpisodeID_"_"_InsuDivID
	s DataRow=0  ;liusf 3 28
	s SetlId="",MdtrtId="",JsdId=""
	if InsuDivID'=""
	{
	 s InsuDivInfo=$g(^DHCINDIV(InsuDivID))
	 ;s SetlId=$p(InsuDivInfo,"^",69)
	 s SetlId=$p(InsuDivInfo,"^",8)
	 s MdtrtId=$p(InsuDivInfo,"^",30)
	 s JsdId=$p($g(^DHCINDIV(InsuDivID)),"^",67) //结算单流水号 每个项目可能不一样 需要修改
	}
	s ret=##class(%ListOfDataTypes).%New()
	s eFlag="N"
	;f i=1:1:7
	f i=1:1:1
	{
	 	s diagStr=##class(DHCWMR.FPService.OutputSrv).GetFrontPageICDAll(EpisodeID,"D/"_i)
	 	;b ;s diagStr="testdiagcode"_$c(2)_"testdeagdesc"_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2)_$c(2) ;test2021
	 	continue:diagStr=""
	 	s len=$l(diagStr,$c(1))
	 	f j=1:1:len
	 	{
		 	;b ;1
		 	
		 	s singleInfo=$p(diagStr,$c(1),j)
		 	
		 	continue:singleInfo=""
		 	s diagtype=1 ;$p(singleInfo,$c(2),9)
		 	;add by xubaobao 2021 05 24 诊断类型对照
		 	;s diagtype=$Case(diagtype,"1":"1",:"2")
		 	;b ;99999999999999999
		 	;add 去除重复诊断
		 	s DiagCode=$p(singleInfo,$c(2),1)
		 	s ^TempDiag("DiagCode",DiagCode)=$p(singleInfo,$c(2),2)_"^"_$p(singleInfo,$c(2),5)
		 	s maindiagflag="0"
		 	s objSingle=##class(%ArrayOfDataTypes).%New()
			d objSingle.SetAt($p(singleInfo,$c(2),2),"diag_name")		//诊断名称
			d objSingle.SetAt($p(singleInfo,$c(2),1),"diag_code")		//诊断代码
			;d objSingle.SetAt($p(singleInfo,$c(2),9),"diag_type")		//诊断类别
			d objSingle.SetAt(diagtype,"diag_type")		//诊断类别
			d objSingle.SetAt($p(singleInfo,$c(2),5),"adm_cond_type")	//入院病情类型
			d objSingle.SetAt(SetlId,"setl_id")
			d objSingle.SetAt(MdtrtId,"mdtrt_id")
			d objSingle.SetAt(JsdId,"jsd_id")
			d objSingle.SetAt(num,"zdxh_id")
			//b ;j
			d ret.Insert(objSingle)
	 	}
	 }
	 
	 ;从global里面取值
	 	s DiagCode="0"
	 	for  s DiagCode=$o(^TempDiag("DiagCode",DiagCode)) q:DiagCode=""  d
	 	  .s DiagInfo=$g(^TempDiag("DiagCode",DiagCode))
	 	  .s maindiagflag="0",diagtype="1"
		  .s objSingle=##class(%ArrayOfDataTypes).%New()
		  .d objSingle.SetAt($p(DiagInfo,"^",1),"diag_name")		//诊断名称
	   	  .d objSingle.SetAt(DiagCode,"diag_code")		//诊断代码
	      .d objSingle.SetAt(diagtype,"diag_type")		//诊断类别
		  .d objSingle.SetAt($p(DiagInfo,"^",2),"adm_cond_type")	//入院病情类型
		  .i (diagtype="1")&&(eFlag="Y") d 
		  ..;b ;
		  ..s maindiagflag="0"      //辅诊断都输出为0
		  ..d objSingle.SetAt(maindiagflag,"maindiag_flag")	//入院病情类型
		  ..d ret.Insert(objSingle)
		  .e  d
		  ..i diagtype="1" d
		  ...s maindiagflag="1",eFlag="Y"
		  ...d objSingle.SetAt(maindiagflag,"maindiag_flag")	//入院病情类型
		  ...d ret.Insert(objSingle)
		  
	s ^TMPZMC("GetPatDiseInfo","rtn")=ret
	q ret
}

/// 4101 病案首页输入节点（重症监护信息icuinfo）7 icuinfo  重症监护信息
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// d ##class(%ResultSet).RunQuery("web.SETlInfo","GetPatICUInfoList","4409","644","")
/// ExpStr:扩展信息串，^分割。医疗机构组织机构代码^^^
/// 取得手麻组数据
/// 负责人：交付中心、手麻组共同完成
/// 出参说明？？？？？？？
Query GetPatICUInfoList(EpisodeID As %String, InsuDivID = "", ExpStr As %String = "") As websys.Query(ROWSPEC = "icu_code,icu_desc,icu_codeid,inDate,inTime,inpool_icu_time,outDate,outTime,out_icu_time,medins_orgcode,back_icu,vali_flag,stayTime,WardType") [ SqlProc ]
{
}

ClassMethod GetPatICUInfoListExecute(ByRef qHandle As %Binary, EpisodeID As %String, InsuDivID = "", ExpStr As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
 	s ^TMPZMC("GetPatICUInfoList")=EpisodeID_"_"_InsuDivID
	if (EpisodeID="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s admNo=$p($g(^PAADM(EpisodeID)),"^",81)
	s setlId="",mdtrtId="",psnNo=""
	s:InsuDivID'="" setlId=$p($g(^DHCINDIV(InsuDivID)),"^",8)
	s:InsuDivID'="" mdtrtId=$p($g(^DHCINDIV(InsuDivID)),"^",30)
	s:InsuDivID'="" psnNo=$p($g(^DHCINDIV(InsuDivID)),"^",18)
	;s mdtrtsn=$g(PatInfo("HisCode"))_admNo
	s medinsOrgcode=$p(ExpStr,"^",1)	;医疗机构组织机构代码
	s mdtrtsn=medinsOrgcode_admNo  
	;s EpisodeID="163" ;test
	s WardType="1"
 	s rowId="",sum=""
 	f  
 	{
 		s rowId=$o(^DHCICUArrange(0,"Adm",EpisodeID,rowId))
 		q:rowId=""
		s icuCodeID=""						//重症监护室代码
		s icuCodeID=$p($g(^DHCICUArrange(rowId)),"^",2)
		s icuCode="",icuDesc=""
		s:icuCodeID'="" icuCode=$p($g(^CTLOC(icuCodeID)),"^",1)
		s:icuCodeID'="" icuDesc=$p($g(^CTLOC(icuCodeID)),"^",2)
		s inDate="",inTime=""
		s inDateTime=""						//监护室进入日期时间
		s inDate=$p($g(^DHCICUArrange(rowId)),"^",6)
		s inTime=$p($g(^DHCICUArrange(rowId)),"^",8)
		s inDateTimes=(inDate*86400)+inTime
		s:inDate'="" inDate=$zd(inDate,3)
		s:inTime'="" inTime=$zt(inTime)
		s inDateTime=inDate_" "_inTime

		s outDateTime=""					//监护室退出日期时间
		s outDate=$p($g(^DHCICUArrange(rowId)),"^",45)
		
		s outTime=$p($g(^DHCICUArrange(rowId)),"^",46)
		s outDateTimes=(outDate*86400)+outTime
		s:outDate'="" outDate=$zd(outDate,3)
		s:outTime'="" outTime=$zt(outTime)
		s outDateTime=outDate_" "_outTime

		i (outDateTime="")||(outDateTime=" ")
		{
		    s outDate=$p($g(^DHCICUArrange(rowId)),"^",7)
		    s:outDate'="" outDate=$zd(outDate,3)
		    s outTime=$p($g(^DHCICUArrange(rowId)),"^",9)
		    s:outTime'="" outTime=$zt(outTime)
			s outDateTime=outDate_" "_outTime
		}
		
		
		s backFlag=""								//是否重返重症监护室
		s sum=sum+1
		i (sum>1)
		{
			s backFlag="是"
		}
		else
		{
			s backFlag="否"	
		}
		s stayTime=""
		i (outDateTimes>0)&&(inDateTimes>0)
		{
			s time=outDateTimes-inDateTimes
			s day=time\86400
			s hour=(time#86400)\3600
			s min=(time#3600)\60
			s:(day>0)||(hour>0)||(min>0) stayTime=day_"/"_hour_"/"_min
		}
		s valiFlag=1
		;s hmpgsn=admNo_##class(web.DHCInsuPlatform.Common).AddZero(rowId,12)
		s hmpgsn=admNo_$e("0000000000000000000000000000000000000000000",1,12-$l(rowId))
		d OutPutICUInfoList	
 	}
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutPutICUInfoList
     ;缺少说明
	set Data=$lb(icuCode,icuDesc,icuCodeID,inDate,inTime,inDateTime,outDate,outTime,outDateTime,medinsOrgcode,backFlag,valiFlag,stayTime,mdtrtsn,mdtrtId,psnNo,hmpgsn,WardType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInsuSignInfo(UserID = "", InDate = "", HospID = "")
{

	q:(UserID="")||(InDate="") ""
	s ret=""
	s rowId=""
	f  s rowId=$O(^DHCINSUSSGN("0","USERDR",UserID,"DATE",InDate,rowId),-1)  q:(rowId="")||(ret'="")  d
	.s signInfo=$g(^DHCINSUSSGN(rowId))
	.q:signInfo=""
	.s activeFlag=$P(signInfo,"^",13)
	.q:activeFlag'=1
	.s curHospID=$P(signInfo,"^",18)
	.;q:(HospID'="")&&(HospID'=curHospID)
	.s ret=signInfo
	q ret
}

/// 2021年3月2日 14:36
/// 2021年3月2日
/// w ##class(web.DHCINSUSetlInfo).GetDateFormat("2021年3月2日 14:36")
/// w ##class(web.DHCINSUSetlInfo).GetDateFormat("2021年3月2日")
ClassMethod GetDateFormat(DateF) As %String
{
	
	    s birthDateT = $P($g(DateF), " ",2)
	    s:birthDateT'="" birthDateT=$tr(birthDateT_":00",":","")
	    s birthDateY = $p(DateF,"年",1)
		s birthDateM ="00"_$P( $p(DateF,"年",2),"月",1)
		s lenM=$l(birthDateM)
		s birthDateD ="00"_(+$P( $p(DateF,"年",2),"月",2))
		s lenD=$l(birthDateD)
		s birthDate = birthDateY_$e(birthDateM,lenM-1,lenM)_$e(birthDateD,lenD-1,lenD)
		
	q birthDate_birthDateT
}

/// add by xubaobao 
/// 2021-05-02
/// 自费病人费用明细信息上传
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUSetlInfo","OwnSettleDetailInfo","OP","5056042")
/// d ##class(%ResultSet).RunQuery("web.DHCINSUSetlInfo","OwnSettleDetailInfo","IP","150800")
/// mdtrtsn,iptotpno,medtype,chrgbchno,feedetlsn,psncerttype,certno,psnname,feeocurtime,cnt,pric,detitemfeesumamt,medlistcodg,medinslistcodg,medinslistname,medchrgitmtype,prodname,bilgdeptcodg,bilgdeptname,bilgdrcodg,bilgdrname,ccorddeptcodg,ccorddeptname,ordersdrcodg,ordersdrname,tcmdrugusedway,etipflag,etiphospcode,dscgtkdrugflag,memo
Query OwnSettleDetailInfo(Adm As %String, prtrowid As %String, feedetlsn As %String) As websys.Query(ROWSPEC = "mdtrt_sn,ipt_otp_no,med_type,chrg_bchno,feedetl_sn,psn_cert_type,certno,psn_name,fee_ocur_time,cnt,pric,det_item_fee_sumamt,med_list_codg,medins_list_codg,medins_list_name,med_chrgitm_type,prodname,bilg_dept_codg,bilg_dept_name,bilg_dr_codg,bilg_dr_name") [ SqlProc ]
{
}

ClassMethod OwnSettleDetailInfoExecute(ByRef qHandle As %Binary, Adm As %String, prtrowid As %String, feedetlsn As %String) As %Status
{
	s ^xbb("OwnSettleDetailInfo")=Adm_","_prtrowid_","_feedetlsn
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	if (feedetlsn="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	if (Adm="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	if (prtrowid="") Set qHandle=$lb(0,repid,0) Quit $$$OK

	s admType=$p(^PAADM(Adm),"^",2)
	s admType=$case(admType,"I":"IP",:"OP")
	s AdmReasonDR=$p(^PAADM(Adm,1),"^",7) //病人计费类别
	s papmi=$p($g(^PAADM(Adm)),"^",1)		;病人id
	
	s InsuType=##class(web.DHCINSUPort).GetDicByCodeAndInd("AdmReasonDrToTariType",AdmReasonDR,6)	
	s DocID=$p(^PAADM(Adm),"^",9)
	q:DocID="" $$$OK
	s DocCode=$p(^CTPCP(DocID,1),"^",1) //医生号
	s DocDesc=$p(^CTPCP(DocID,1),"^",2) //医生
	s DocUnit=$p(^CTPCP(DocID,2),"^",8)  //医生资格证书号 20180712 DingSH		add by xubaobao 2021 03 05 国家医保新增
	s DocDesc=$replace(DocDesc,"[","【")
	s DocDesc=$replace(DocDesc,"]","】")
	s mdtrtsn=Adm									;就医流水号				--->就诊id
	s iptotpno=$p(^PAPER(papmi,"PAT",1),"^",2)		;住院/门诊号		--->登记号
	s medtype=""									;医疗类别	
	s chrgbchno=admType_prtrowid					;收费批次号		--->业务类型+发票id
	s psncerttype="1"								;人员证件类型
	s certno=$p(^PAPER(papmi,"ALL"),"^",9)			;证件号码
	s psnname=$p(^PAPER(papmi,"ALL"),"^",1)			;人员姓名
	
	s DepID=$p(^PAADM(Adm),"^",4)
	q:DepID="" $$$OK
	s Depcode=$p($g(^CTLOC(DepID)),"^",1) //科室编号
	s DepDesc=$p($g(^CTLOC(DepID)),"^",2) //科室
	
	
	// 取账单明细信息
	s BillDr=$p(feedetlsn,"||",1)
	s PBOSub=$p(feedetlsn,"||",2)
	s PBDSub=$p(feedetlsn,"||",3)
	q:('$d(^DHCPB(BillDr,"O",PBOSub)))||($d(^DHCPB(BillDr,"O",PBOSub))=10)
	//取每一条医嘱的PBO_Arcim_Dr
	s PBOARCIMDR=$p($g(^DHCPB(BillDr,"O",PBOSub)),"^",3)
	//取每一条医嘱的PBO_OEORI_Dr
	s PBOOEORIDR=$p($g(^DHCPB(BillDr,"O",PBOSub)),"^",4)
	s PBOOrdExecDr=$p($g(^DHCPB(BillDr,"O",PBOSub)),"^",20)	//执行记录的rowid
	s OEORDInfo=$$GetOEORDInfo^DHCINSUFacade(PBOOEORIDR)
	s OEORDInfoExt=$$GetOEORDInfoExt^DHCINSUFacade(PBOOEORIDR,PBOOrdExecDr)
	s bilgdeptcodg=$p(OEORDInfo,"",16)					   ;开单科室编码
	s bilgdeptname=$p(OEORDInfo,"",17)					   ;开单科室名称
	i bilgdeptcodg="" d
	.s bilgdeptcodg=Depcode
	.s bilgdeptname=DepDesc
	s bilgdeptcodg=##CLASS(web.DHCINSUPort).GetDicByCodeAndInd("deptCon00A",bilgdeptcodg,6)
	s bilgdrcodg=$p(OEORDInfo,"",4)						   ;开单医生编码
	s bilgdrname=$p(OEORDInfo,"",5)						   ;开单医师姓名
	s bilgdrname=$replace(bilgdrname,"[","【")
	s bilgdrname=$replace(bilgdrname,"]","】")
	i bilgdrcodg="" d
	.s bilgdrcodg=DocCode
	.s bilgdrname=DocDesc
	s ccorddeptcodg=bilgdeptcodg					   ;受单科室编码
	s ccorddeptname=bilgdeptname				   ;受单科室名称
	s ordersdrcodg=bilgdrcodg					   	   ;受单医生编码
	s ordersdrname=bilgdrname						   ;受单医师姓名
	s PatBillDetailsInfo=$g(^DHCPB(BillDr,"O",PBOSub,"D",PBDSub))
	;s feedetlsn=PBDDr
	s BillDate=$zd($p(PatBillDetailsInfo,"^",11),3)	
    s BillTime=$zt($p(PatBillDetailsInfo,"^",12))
    s feeocurtime=BillDate_" "_BillTime  
    s PBDTarDr=$p(PatBillDetailsInfo,"^",3)				;收费项id
    s pric=$p(PatBillDetailsInfo,"^",4)						;单价
	s cnt=$p(PatBillDetailsInfo,"^",5)						;数量
	s detitemfeesumamt=$p(PatBillDetailsInfo,"^",7)						;金额
	s TariInsuFlag=$p($$QueryByCode^DHCINSUDicData("TariInsuFlag",InsuType),"^",6)   //取收费项是否与其他收费项关联的标志  add by lilizhi 2013-03-05
 	s TarItemInsuInfo=$$GetConInfo^DHCINSUTarContrast(PBDTarDr,InsuType,BillDate,TariInsuFlag)
 	s medlistcodg=$p(TarItemInsuInfo,"^",3)					   ;医疗目录编码
 	s medinslistcodg=$p($g(^DHCTARI(PBDTarDr)),"^",1)              ;医药机构目录编码
	s medinslistname=$p($g(^DHCTARI(PBDTarDr)),"^",2)              ;医药机构目录名称
	s medinslistname=$replace(medinslistname,"[","【")
	s medinslistname=$replace(medinslistname,"]","】")
	s medchrgitmtype=$p(TarItemInsuInfo,"^",1)					   ;医疗收费项目类别
	s prodname=$p(TarItemInsuInfo,"^",4)						   ;商品名
	s tcmdrugusedway=""						   ;中药使用方式
	s etipflag=""						   	   ;外检标志
	s etiphospcode=""						   ;外检医院编码
	s dscgtkdrugflag=""						   ;出院带药标志
	s memo=""						   		   ;备注
	d BuildOwnDetail

	Quit $$$OK
BuildOwnDetail	
	set Data=$lb(mdtrtsn,iptotpno,medtype,chrgbchno,feedetlsn,psncerttype,certno,psnname,feeocurtime,cnt,pric,detitemfeesumamt,medlistcodg,
	medinslistcodg,medinslistname,medchrgitmtype,prodname,bilgdeptcodg,bilgdeptname,bilgdrcodg,bilgdrname,ccorddeptcodg,ccorddeptname,
	ordersdrcodg,ordersdrname,tcmdrugusedway,etipflag,etiphospcode,dscgtkdrugflag,memo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 手术临时对照  add by fg
/// w ##Class(web.DHCINSUSetlInfo).OprationTrascation("55.2300x001")
ClassMethod OprationTrascation(Oprationcode)
{
	q:Oprationcode="" ""
	s OprationCodeGJtwo="",OprationNameGJtwo=""
	/// 如下注释的if写法不可取
    //i Oprationcode="00.0100" s OprationCodeGJtwo="00.0100",OprationNameGJtwo="头和颈部血管治疗性超声"
    //i Oprationcode="00.0101" s OprationCodeGJtwo="00.0101",OprationNameGJtwo="头部血管治疗性超声"
    //i Oprationcode="00.0102" s OprationCodeGJtwo="00.0102",OprationNameGJtwo="颈部血管治疗性超声"
    //i Oprationcode="00.0200" s OprationCodeGJtwo="00.0200",OprationNameGJtwo="心脏治疗性超声"
    s OprationInfo=##class(web.DHCINSUPort).GetContrastInfoByHisCode("Oprationcode","00A")
    s OprationCodeGJtwo = $P($g(OprationInfo),"^",5)
    s OprationCodeGJtwo = $P($g(OprationInfo),"^",6)
    q OprationCodeGJtwo_"^"_OprationNameGJtwo
}

/// 4104接口json参数赋值  
/// +20230303 HanZH 
ClassMethod Get4104ParamJson(SetlYm, SetlId, PsnNo, ErrLv, RetnFlag, PageNum, PageSize) As %ArrayOfDataTypes
{
	s Param=##class(%ArrayOfDataTypes).%New()
	d Param.SetAt(SetlYm,"setl_ym")
	d Param.SetAt(SetlId,"setl_id")
	d Param.SetAt(PsnNo,"psn_no")
	d Param.SetAt(ErrLv,"err_lv")
	d Param.SetAt(RetnFlag,"retn_flag")
	d Param.SetAt(PageNum,"page_num")
	d Param.SetAt(PageSize,"page_size")
	q Param
}

/// 4104接口出参保存临时global 
/// 	+20230303 HanZH 
/// d ##class(web.DHCINSUSetlInfo).Save4104RtnJson("1", "122", "Json")
ClassMethod Save4104RtnJson(UserId, Job, ParamJsonStr) As %ArrayOfDataTypes
{
	q:$g(Job)="" "-1^保存到临时Global失败：Job为空"
	q:$g(UserId)="" "-1^保存到临时Global失败：UserId为空"
	q:$g(ParamJsonStr)="" "-1^保存到临时Global失败：Json为空"
	s ParamJson=##class(web.INSUCacheJSON).Decode(ParamJsonStr)
	s OutputObj=ParamJson.GetAt("output")
	s Counts=OutputObj.GetAt("recordCounts") ;总记录数
	s Pages=OutputObj.GetAt("pages") ;总页数
	s DataObj=OutputObj.GetAt("data") ;数据列表
	;重新组装数据
	for row=1:1:DataObj.Size {
		s RowObj=DataObj.GetAt(row)
		s NewRowObj=##class(%ArrayOfDataTypes).%New()
		d NewRowObj.SetAt(RowObj.GetAt("fixmedins_code"),"fixmedins_code")
		d NewRowObj.SetAt(RowObj.GetAt("psn_no"),"psn_no")
		d NewRowObj.SetAt(RowObj.GetAt("psn_cert_type"),"psn_cert_type")
		d NewRowObj.SetAt(RowObj.GetAt("cert_no"),"cert_no")
		d NewRowObj.SetAt(RowObj.GetAt("qltctrl_rslt"),"qltctrl_rslt")
		d NewRowObj.SetAt(RowObj.GetAt("setl_id"),"setl_id")
		d NewRowObj.SetAt(RowObj.GetAt("psn_name"),"psn_name")
		d NewRowObj.SetAt(RowObj.GetAt("err_lv"),"err_lv")
		d NewRowObj.SetAt(RowObj.GetAt("setl_ym"),"setl_ym")
		d NewRowObj.SetAt(RowObj.GetAt("qltctrl_ver"),"qltctrl_ver")
		d NewRowObj.SetAt(RowObj.GetAt("fixmedins_name"),"fixmedins_name")
		s DetailsArr=RowObj.GetAt("detailinfo")
		for sub=1:1:DetailsArr.Size {
			s DetailObj=DetailsArr.GetAt(sub)
			d NewRowObj.SetAt(DetailObj.GetAt("err_lv"),"sub_err_lv")
			d NewRowObj.SetAt(DetailObj.GetAt("qltctrl_chk_rslt"),"qltctrl_chk_rslt")
			d NewRowObj.SetAt(DetailObj.GetAt("init_val"),"init_val")
			d NewRowObj.SetAt(DetailObj.GetAt("exam_data_fld"),"exam_data_fld")
			d NewRowObj.SetAt(DetailObj.GetAt("retn_flag"),"retn_flag")
			s ^CacheTemp4104(UserId,Job,$I(^||NewIndex))=##class(web.INSUCacheJSON).Encode(NewRowObj)
		}
	}
	q:$g(^||NewIndex)>1 "1^"_Counts_"^"_Pages
	q "-3^保存到临时Global失败：Json数据有误："_ParamJsonStr
}

Query Query4104(UserId As %String, Job As %String) As websys.Query(ROWSPEC = "psnno:%String,certno:%String,psnname,setlid,setlym,fixmedinscode,fixmedinsname,psncerttype,qltctrlrslt,errlv,qltctrlver,suberrlv,qltctrlchkrslt,initval,examdatafld,retnflag,papno:%String,medNo:%String") [ SqlProc ]
{
}

/// 取4104接口出参保存的临时global数据
/// 	+20230303 HanZH 
/// d ##class(%ResultSet).RunQuery("web.DHCINSUSetlInfo","Query4104",16335,8896)
ClassMethod Query4104Execute(ByRef qHandle As %Binary, UserId As %String, Job As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:($g(UserId)="") $$$OK
	q:($g(Job)="") $$$OK
	s index="",papno=""
	for {
		s index=$o(^CacheTemp4104(UserId,Job,index)) q:index=""
		s JsonStr=$g(^CacheTemp4104(UserId,Job,index))
		continue:JsonStr=""
		s JsonObj=##class(web.INSUCacheJSON).Decode(JsonStr)
		s psnno="'"_JsonObj.GetAt("psn_no")
		s certno="'"_JsonObj.GetAt("cert_no")
		s psnname=JsonObj.GetAt("psn_name")
		s setlid=JsonObj.GetAt("setl_id")
		s setlym=JsonObj.GetAt("setl_ym")
		s fixmedinscode=JsonObj.GetAt("fixmedins_code")
		s fixmedinsname=JsonObj.GetAt("fixmedins_name")
		s psncerttype=JsonObj.GetAt("psn_cert_type")
		s qltctrlrslt=JsonObj.GetAt("qltctrl_rslt")
		s errlv=JsonObj.GetAt("err_lv")
		s qltctrlver=JsonObj.GetAt("qltctrl_ver")
		s suberrlv=JsonObj.GetAt("sub_err_lv")
		s qltctrlchkrslt=JsonObj.GetAt("qltctrl_chk_rslt")
		s initval=JsonObj.GetAt("init_val")
		s examdatafld=JsonObj.GetAt("exam_data_fld")
		s retnflag=JsonObj.GetAt("retn_flag")
		s INPAYRowid="",INPAYAdmDr="",papmi="",papno="",szyh="",zycs=""
		s INPAYRowid=$o(^DHCINDIV("0","Djlsh0",setlid,INPAYRowid))
		
		i INPAYRowid'="" d
		.s INPAYAdmDr=$p(^DHCINDIV(INPAYRowid),"^",1)
		.i +$g(INPAYAdmDr)'=0 d
		..s papmi=$p(^PAADM(INPAYAdmDr),"^",1)
		..i +$g(papmi)'=0 d
		...s papno="'"_$p(^PAPER(papmi,"PAT",1),"^",1)
		...s szyh=$$GetPapmiMedtare^DHCWLCommon(papmi)
		...s zycs=$p(^PAADM(INPAYAdmDr),"^",29)
		...s medNo=szyh_"X"_zycs
		s setlid="'"_setlid
		s ^CacheTemp(repid,ind)=$lb(psnno,certno,psnname,setlid,setlym,fixmedinscode,fixmedinsname,psncerttype,qltctrlrslt,errlv,qltctrlver,suberrlv,qltctrlchkrslt,initval,examdatafld,retnflag,papno,medNo)
		s ind=ind+1
	}
	q $$$OK
}

}
