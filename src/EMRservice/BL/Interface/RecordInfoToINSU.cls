Class EMRservice.BL.Interface.RecordInfoToINSU Extends %RegisteredObject
{

/// 【----------医保结算清单[4101]信息----------】
/// Creator：	YK
/// CreateDate：2021-12-27
/// Desc：		医保结算清单信息（setlinfo4101）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(EMRservice.BL.Interface.RecordInfoToINSU).setlinfo4101(1902)
ClassMethod setlinfo4101(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:(AEpisodeID="") ret
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (medcasno,psnname,gend,brdy,age,ntly,nwbage,naty,patncerttype,certno,prfs,curraddr,empname,empaddr,emptel,poscode,conername,patnrlts,coneraddr,conertel,nwbbirwt,nwbadmwt,admway,admtime,admcaty,refldeptdept,dscgtime,dscgcaty,actiptdays,otpwmdise,wmdisecode,ventuseddura,pwcrybfadmcomadura,pwcryafadmcomadura,spganurscaredays,lv1nurscaredays,scdnurscaredays,lv3nurscaredays,dscgway,acpmedinsname,acpoptinscode,daysrinpflag31,daysrinppup31,chfpdrname,chfpdrcode,respnurscode) = ""
	
	//扩展参数 ExpDataAry获取部分参数示例
    s (mdtrtId,setlId,fixmedinsName,fixmedinsCode,hiSetlLv,hiNo,insutype,insuAdmdvs,mdtrtareaAdmvs)=""
	if ($IsObject(ExpDataAry))
    {
		//--按照医保接口文档字段命名
		s mdtrtId=ExpDataAry.GetAt("mdtrt_id") //mdtrt_id 就诊ID(非HIS就诊ID)  
		s setlId = ExpDataAry.GetAt("setl_id") //setl_id 结算ID
		s psnno = ExpDataAry.GetAt("psn_no") //psn_no 人员编号
		s fixmedinsName = ExpDataAry.GetAt("fixmedins_name") //fixmedins_name	定点医药机构名称	
		s fixmedinsCode = ExpDataAry.GetAt("fixmedins_code") //fixmedins_code	定点医药机构编号
		s hiSetlLv = ExpDataAry.GetAt("hi_setl_lv") //hi_setl_lv 医保结算等级
		s hiNo = ExpDataAry.GetAt("hi_no") //hi_no 医保编号	
		s insutype = ExpDataAry.GetAt("insutype") //insutype 险种类型  
		s insuAdmdvs = ExpDataAry.GetAt("insu_admdvs") //insu_admdvs 参保所属医保区划
		s mdtrtareaAdmvs = ExpDataAry.GetAt("mdtrtarea_admvs") //mdtrtarea_admvs 就医地医保区划
		
		s billcode = ExpDataAry.GetAt("bill_code") // 票据代码
		s billbillno = ExpDataAry.GetAt("bill_no") // 票据号码
		s billbizsn = ExpDataAry.GetAt("biz_sn") // 业务流水号
		s setlbegndate = ExpDataAry.GetAt("setl_begn_date") // 结算开始日期
		s setlenddate = ExpDataAry.GetAt("setl_end_date") // 结算结束日期
		s psnselfpay = ExpDataAry.GetAt("psn_selfpay") // 个人自付
		s psnownpay = ExpDataAry.GetAt("psn_ownpay") // 个人自费
		s acctpay = ExpDataAry.GetAt("acct_pay") // 个人账户支出
		s psncashpay = ExpDataAry.GetAt("psn_cashpay") // 个人现金支付
		s hipaymtd = ExpDataAry.GetAt("hi_paymtd") // 医保支付方式
		s hsorg = ExpDataAry.GetAt("hsorg") // 医保机构
		s hsorgopter = ExpDataAry.GetAt("hsorg_opter") // 医保机构经办人
		s medinsfilldept = ExpDataAry.GetAt("medins_fill_dept") // 医疗机构填报部门
		s medinsfillpsn = ExpDataAry.GetAt("medins_fill_psn") // 医疗机构填报人
		
		d ret.SetAt(mdtrtId,"mdtrtId")
		d ret.SetAt(setlId,"setlId")
		d ret.SetAt(psnno,"psnno")
		d ret.SetAt(fixmedinsName,"fixmedinsName")
		d ret.SetAt(fixmedinsCode,"fixmedinsCode")
		d ret.SetAt(hiSetlLv,"hiSetlLv")
		d ret.SetAt(hiNo,"hiNo")
		d ret.SetAt(insutype,"insutype")
		d ret.SetAt(insuAdmdvs,"insuAdmdvs")
		d ret.SetAt(mdtrtareaAdmvs,"mdtrtareaAdmvs")
		
		d ret.SetAt(billcode,"billcode")
		d ret.SetAt(billbillno,"billbillno")
		d ret.SetAt(billbizsn,"billbizsn")
		d ret.SetAt(setlbegndate,"setlbegndate")
		d ret.SetAt(setlenddate,"setlenddate")
		d ret.SetAt(psnselfpay,"psnselfpay")
		d ret.SetAt(psnownpay,"psnownpay")
		d ret.SetAt(acctpay,"acctpay")
		d ret.SetAt(psncashpay,"psncashpay")
		d ret.SetAt(hipaymtd,"hipaymtd")
		d ret.SetAt(hsorg,"hsorg")
		d ret.SetAt(hsorgopter,"hsorgopter")
		d ret.SetAt(medinsfilldept,"medinsfilldept")
		d ret.SetAt(medinsfillpsn,"medinsfillpsn")
	}
	
	// 西医住院病案首页
	if (InstanceID'="")
	{
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
		//住院病案首页信息
		s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.11")
		s medcasno = arr.GetAt("HDSD00.11.006") // 病案号
		s psnname = arr.GetAt("HDSD00.11.110") // 人员姓名
		s gend = arr.GetAt("HDSD00.11.586") // 性别
		s brdy = arr.GetAt("HDSD00.11.014") // 出生日期
		s brdy = ..ConvertStandDate(brdy)
		
		//s age = arr.GetAt("HDSD00.11.079") // 年龄
		s INSUAge = ##class(INSU.BL.Interface.DataRpUp).GetAdmAge(AEpisodeID,"","4101")
		s age = $P(INSUAge,"^",1)
		s ntly = arr.GetAt("HDSD00.11.563") // 国籍
		//s nwbage = arr.GetAt("HDSD00.11.080") // （年龄不足1周岁）年龄
		s nwbage = $P(INSUAge,"^",2)
		
		s naty = arr.GetAt("HDSD00.11.590") // 民族
		s patncerttype = "身份证" // 患者证件类别
		s certno = arr.GetAt("HDSD00.11.048") // 证件号码
		s prfs = arr.GetAt("HDSD00.11.564") // 职业
		s curraddr = arr.GetAt("HDSD00.11.102")_"/"_arr.GetAt("HDSD00.11.103")_"/"_arr.GetAt("HDSD00.11.104")_"/"_arr.GetAt("HDSD00.11.105") // 现住址
		s empname = arr.GetAt("HDSD00.11.035") // 单位名称
		s empaddr = arr.GetAt("HDSD00.11.029") // 单位地址
		s emptel = arr.GetAt("HDSD00.11.034") // 单位电话
		s poscode = arr.GetAt("HDSD00.11.033") // 邮编
		s conername = arr.GetAt("HDSD00.11.065") // 联系人姓名
		s patnrlts = arr.GetAt("HDSD00.11.562") // 与患者关系
		s coneraddr = arr.GetAt("HDSD00.11.060") // 联系人地址
		s conertel = arr.GetAt("HDSD00.11.064") // 联系人电话
		s nwbbirwt = arr.GetAt("HDSD00.11.107") // 新生儿出生体重
		s nwbadmwt = arr.GetAt("HDSD00.11.108") // 新生儿入院体重
		s admway = arr.GetAt("HDSD00.11.591") // 入院途径
		s admtime = arr.GetAt("HDSD00.11.085") // 入院时间
		s admtime = ..ConvertStandDate(admtime)
		s admcaty = arr.GetAt("HDSD00.11.084") // 入院科别
		s refldeptdept = arr.GetAt("HDSD00.11.144") // 转科科别
		s dscgtime = arr.GetAt("HDSD00.11.019") // 出院时间
		s dscgtime = ..ConvertStandDate(dscgtime)
		s dscgcaty = arr.GetAt("HDSD00.11.018") // 出院科别
		s actiptdays = arr.GetAt("HDSD00.11.087") // 实际住院天数
		s otpwmdise = arr.GetAt("HDSD00.11.076") // 门（急）诊西医诊断
		s wmdisecode = arr.GetAt("HDSD00.11.075") // 西医诊断疾病代码
		s ventuseddura = arr.GetAt("HDSD00.11.555") // 呼吸机使用时长
		s (day,hour,min) = "0"
		if (ventuseddura<24)
		{
			s day=0
			s hour=$P(ventuseddura,".",1)
			s min=(ventuseddura*60)-(hour*60)
			s min = $P(min,".",1)
		}
		else
		{
			s day=ventuseddura\24
			s hour=$P((ventuseddura#24),".",1)
			s min=((ventuseddura#24)-hour)*60
			s min = $P(min,".",1)
		}
		s ventuseddura = day_"/"_hour_"/"_min
		
		s pwcrybfadmcomadura = arr.GetAt("HDSD00.11.070")_"/"_arr.GetAt("HDSD00.11.071")_"/"_arr.GetAt("HDSD00.11.072") // 颅脑损伤患者入院前昏迷时长
		s pwcryafadmcomadura = arr.GetAt("HDSD00.11.067")_"/"_arr.GetAt("HDSD00.11.068")_"/"_arr.GetAt("HDSD00.11.069") // 颅脑损伤患者入院后昏迷时长
		
		s spganurscaredays = arr.GetAt("HDSD00.11.892") // 特级护理天数
		s lv1nurscaredays = arr.GetAt("HDSD00.11.893") // 一级护理天数
		s scdnurscaredays = arr.GetAt("HDSD00.11.894") // 二级护理天数
		s lv3nurscaredays = arr.GetAt("HDSD00.11.895") // 三级护理天数
		/// Return: 特级护理|0^一级护理|2^二级护理 |0^三级护理 |0
		s allnursecaredays = ##Class(Nur.Interface.OutSide.Med.Order).GetCareDays(AEpisodeID)
		if (allnursecaredays'="")
		{
			s spganurscaredays = $P($P(allnursecaredays,"^",1),"|",2)
			s lv1nurscaredays = $P($P(allnursecaredays,"^",2),"|",2)
			s scdnurscaredays = $P($P(allnursecaredays,"^",3),"|",2)
			s lv3nurscaredays = $P($P(allnursecaredays,"^",4),"|",2)
		}
		s dscgway = arr.GetAt("HDSD00.11.603") // 离院方式
		
		s acpoptinscode = arr.GetAt("HDSD00.11.2615") // 拟接收机构代码 
		s acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",2) // 拟接收机构名称
		s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		if (acpmedinsname="")||(acpmedinsname="-")
		{
			s acpoptinscode = $P(arr.GetAt("HDSD00.11.078"),"^",1) // 拟接收机构代码
			s acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",2) // 拟接收机构名称
			s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		}
		
		s daysrinpflag31 = arr.GetAt("HDSD00.11.015") // 出院31天内再住院计划标志
		s daysrinppup31 = arr.GetAt("HDSD00.11.016") // 出院31天内再住院目的
		s chfpdrname = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3) // 主诊医师姓名
		s chfpdrcode = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",2)	//	主诊医师代码
		
		s opspdiagcaty = admcaty	// 门诊慢特病诊断科别
		s opspmdtrtdate = admtime	// 门诊慢特病就诊日期
		
		// 新增字段
		s sppsntype = "" // 特殊人员类型
		s nwbadmtype = arr.GetAt("HDSD00.11.2398") // 新生儿入院类型
		s iptmedtype = ##class(DHCCL.Product.ForINSU.OperService).GetIfDaySurgeny(AEpisodeID) // 住院医疗类型
		s trttype = "西医" // 治疗类别
		
		s otptcmdise = "" //门（急）诊中医诊断
		s tcmdisecode = "" //中医诊断代码
		
		s diagcodecnt = "0" //诊断代码计数
		s alldiaginfo = ..GetDisDiagose(AEpisodeID)
		s alldiagcode = $P(alldiaginfo,$C(1),1)
		s length = $L(alldiagcode,"^")
		For idiag = 1:1:length
		{
			s diagcode = $P(alldiagcode,"^",idiag)
			continue:(diagcode="")||(diagcode="-")
			s diagcodecnt = diagcodecnt+1
		}
		
		s oprnoprtcodecnt = "0" //手术操作代码计数
		s alloperinfo = ..GetFirstOperInfo(AEpisodeID)
		s allopercode = $P(alloperinfo,$C(1),1)
		s length = $L(allopercode,"^")
		For ioper = 1:1:length
		{
			s opercode = $P(alldiagcode,"^",ioper)
			continue:(opercode="")||(opercode="-")
			s oprnoprtcodecnt = oprnoprtcodecnt+1
		}
		
		s (bldcat,bldamt,bldunt) = ""
		//红细胞
		s bldamt = arr.GetAt("HDSD00.11.994")
		//血小板
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.11.995")
		//血浆
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.11.996")
		//全血
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.11.997")
		//自体血回输
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.11.998")
		s bldcat = "红细胞/血小板/血浆/全血/自体血回输"
		s bldamt = bldamt
		s bldunt = "单位/治疗量/ml/ml/单位"
		
		/*
		// 输血信息:血成分^代码^血量^单位$$血成分^代码^血量^单位
		s ALLBloodInfo = ##Class(DHCLIS.DHCBloodInterface).GetPatCompontsByAdmNo(AEpisodeID)
		s length = $L(ALLBloodInfo,"$$")
		For iblood = 1:1:length
		{
			s BloodInfo = $P(ALLBloodInfo,"$$",iblood)
			s:(bldcat'="") bldcat = bldcat_"/"
			s bldcat = bldcat_$P(BloodInfo,"^",1)
			s:(bldamt'="") bldamt = bldamt_"/"
			s bldamt = bldamt_$P(BloodInfo,"^",3)
			s:(bldunt'="") bldunt = bldunt_"/"
			s bldunt = bldunt_$P(BloodInfo,"^",4)
		}
		*/
		// 责任护士代码
		s respnurscode = ""
		s respnursrowid = arr.GetAt("HDSD00.11.579")
		s:(respnursrowid'="") respnurscode = $p($g(^SSU("SSUSR",respnursrowid)),"^",1)
	}
	elseif (ZYInstanceID'="")
	{
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(ZYInstanceID)
		//中医住院病案首页信息
		s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.12")
		s medcasno = arr.GetAt("HDSD00.12.007") // 病案号
		s psnname = arr.GetAt("HDSD00.12.125") // 人员姓名
		s gend = arr.GetAt("HDSD00.12.586") // 性别
		s brdy = arr.GetAt("HDSD00.12.015") // 出生日期
		s brdy = ..ConvertStandDate(brdy)
		
		//s age = arr.GetAt("HDSD00.12.090") // 年龄
		s INSUAge = ##class(INSU.BL.Interface.DataRpUp).GetAdmAge(AEpisodeID,"","4101")
		s age = $P(INSUAge,"^",1)
		s ntly = arr.GetAt("HDSD00.12.563") // 国籍
		//s nwbage = arr.GetAt("HDSD00.12.091") // （年龄不足1周岁）年龄
		s nwbage = $P(INSUAge,"^",2)
		
		s naty = arr.GetAt("HDSD00.12.590") // 民族
		s patncerttype = "身份证" // 患者证件类别
		s certno = arr.GetAt("HDSD00.12.055") // 证件号码
		s prfs = arr.GetAt("HDSD00.12.564") // 职业
		s curraddr = arr.GetAt("HDSD00.12.117")_arr.GetAt("HDSD00.12.118")_arr.GetAt("HDSD00.12.119")_arr.GetAt("HDSD00.12.120") // 现住址
		s empname = arr.GetAt("HDSD00.12.042") // 单位名称
		s empaddr = arr.GetAt("HDSD00.12.036") // 单位地址
		s emptel = arr.GetAt("HDSD00.12.041") // 单位电话
		s poscode = arr.GetAt("HDSD00.12.040") // 邮编
		s conername = arr.GetAt("HDSD00.12.072") // 联系人姓名
		s patnrlts = arr.GetAt("HDSD00.12.562") // 与患者关系
		s coneraddr = arr.GetAt("HDSD00.12.067") // 联系人地址
		s conertel = arr.GetAt("HDSD00.12.071") // 联系人电话
		s nwbbirwt = arr.GetAt("HDSD00.12.122") // 新生儿出生体重
		s nwbadmwt = arr.GetAt("HDSD00.12.123") // 新生儿入院体重
		s admway = arr.GetAt("HDSD00.12.591") // 入院途径
		s admtime = arr.GetAt("HDSD00.12.096") // 入院时间
		s admtime = ..ConvertStandDate(admtime)
		s admcaty = arr.GetAt("HDSD00.12.095") // 入院科别
		s refldeptdept = arr.GetAt("HDSD00.12.171") // 转科科别
		s dscgtime = arr.GetAt("HDSD00.12.020") // 出院时间
		s dscgtime = ..ConvertStandDate(dscgtime)
		s dscgcaty = arr.GetAt("HDSD00.12.019") // 出院科别
		s actiptdays = arr.GetAt("HDSD00.12.098") // 实际住院天数
		s otpwmdise = arr.GetAt("HDSD00.12.083") // 门（急）诊西医诊断
		s wmdisecode = arr.GetAt("HDSD00.12.082") // 西医诊断疾病代码
		s ventuseddura = arr.GetAt("HDSD00.12.923") // 呼吸机使用时长
		s (day,hour,min) = "0"
		if (ventuseddura<24)
		{
			s day=0
			s hour=$P(ventuseddura,".",1)
			s min=(ventuseddura*60)-(hour*60)
			s min = $P(min,".",1)
		}
		else
		{
			s day=ventuseddura\24
			s hour=$P((ventuseddura#24),".",1)
			s min=((ventuseddura#24)-hour)*60
			s min = $P(min,".",1)
		}
		s ventuseddura = day_"/"_hour_"/"_min
		
		s pwcrybfadmcomadura = arr.GetAt("HDSD00.12.077")_"/"_arr.GetAt("HDSD00.12.078")_"/"_arr.GetAt("HDSD00.12.079") // 颅脑损伤患者入院前昏迷时长
		s pwcryafadmcomadura = arr.GetAt("HDSD00.12.074")_"/"_arr.GetAt("HDSD00.12.075")_"/"_arr.GetAt("HDSD00.12.076") // 颅脑损伤患者入院后昏迷时长
		
		s spganurscaredays = arr.GetAt("HDSD00.12.892") // 特级护理天数
		s lv1nurscaredays = arr.GetAt("HDSD00.12.893") // 一级护理天数
		s scdnurscaredays = arr.GetAt("HDSD00.12.894") // 二级护理天数
		s lv3nurscaredays = arr.GetAt("HDSD00.12.895") // 三级护理天数
		/// Return: 特级护理|0^一级护理|2^二级护理 |0^三级护理 |0
		s allnursecaredays = ##Class(Nur.Interface.OutSide.Med.Order).GetCareDays(AEpisodeID)
		if (allnursecaredays'="")
		{
			s spganurscaredays = $P($P(allnursecaredays,"^",1),"|",2)
			s lv1nurscaredays = $P($P(allnursecaredays,"^",2),"|",2)
			s scdnurscaredays = $P($P(allnursecaredays,"^",3),"|",2)
			s lv3nurscaredays = $P($P(allnursecaredays,"^",4),"|",2)
		}
		s dscgway = arr.GetAt("HDSD00.12.603") // 离院方式
		
		s acpoptinscode = $P(arr.GetAt("HDSD00.12.089"),"^",1) // 拟接收机构代码
		s acpmedinsname = $P(arr.GetAt("HDSD00.12.089"),"^",2) // 拟接收机构名称
		s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		if (acpmedinsname="")||(acpmedinsname="-")
		{
			s acpoptinscode = $P(arr.GetAt("HDSD00.11.078"),"^",1) // 拟接收机构代码
			s acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",2) // 拟接收机构名称
			s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		}
		
		s daysrinpflag31 = arr.GetAt("HDSD00.12.016") // 出院31天内再住院计划标志
		s daysrinppup31 = arr.GetAt("HDSD00.12.017") // 出院31天内再住院目的
		s chfpdrname = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3) // 主诊医师姓名
		s chfpdrcode = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",2)	//	主诊医师代码
		
		s opspdiagcaty = admcaty	// 门诊慢特病诊断科别
		s opspmdtrtdate = admtime	// 门诊慢特病就诊日期
		
		// 新增字段
		s sppsntype = "" // 特殊人员类型
		s nwbadmtype = arr.GetAt("HDSD00.12.") // 新生儿入院类型
		s iptmedtype = ##class(DHCCL.Product.ForINSU.OperService).GetIfDaySurgeny(AEpisodeID) // 住院医疗类型
		s trttype = arr.GetAt("HDSD00.12.144") // 治疗类别
		
		s otptcmdise = arr.GetAt("HDSD00.12.085") //门（急）诊中医诊断
		s tcmdisecode = arr.GetAt("HDSD00.12.084") //中医诊断代码
		
		s diagcodecnt = "0" //诊断代码计数
		s alldiaginfo = ..GetZYDisDiagoseInfo(AEpisodeID)
		s alldiagcode = $P(alldiaginfo,$C(1),1)_"^"_$P(alldiaginfo,$C(1),7)
		s length = $L(alldiagcode,"^")
		For idiag = 1:1:length
		{
			s diagcode = $P(alldiagcode,"^",idiag)
			continue:(diagcode="")||(diagcode="-")
			s diagcodecnt = diagcodecnt+1
		}
		
		s oprnoprtcodecnt = "0" //手术操作代码计数
		s alloperinfo = ..GetZYFirstOperInfo(AEpisodeID)
		s allopercode = $P(alloperinfo,$C(1),1)
		s length = $L(allopercode,"^")
		For ioper = 1:1:length
		{
			s opercode = $P(alldiagcode,"^",ioper)
			continue:(opercode="")||(opercode="-")
			s oprnoprtcodecnt = oprnoprtcodecnt+1
		}
		
		s (bldcat,bldamt,bldunt) = ""
		//红细胞
		s bldamt = arr.GetAt("HDSD00.12.994")
		//血小板
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.12.995")
		//血浆
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.12.996")
		//全血
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.12.997")
		//自体血回输
		s bldamt = bldamt_"/"_arr.GetAt("HDSD00.12.998")
		s bldcat = "红细胞/血小板/血浆/全血/自体血回输"
		s bldamt = bldamt
		s bldunt = "单位/治疗量/ml/ml/单位"
		
		/*
		// 输血信息:血成分^代码^血量^单位$$血成分^代码^血量^单位
		s ALLBloodInfo = ##Class(DHCLIS.DHCBloodInterface).GetPatCompontsByAdmNo(AEpisodeID)
		s length = $L(ALLBloodInfo,"$$")
		For iblood = 1:1:length
		{
			s BloodInfo = $P(ALLBloodInfo,"$$",iblood)
			s:(bldcat'="") bldcat = bldcat_"/"
			s bldcat = bldcat_$P(BloodInfo,"^",1)
			s:(bldamt'="") bldamt = bldamt_"/"
			s bldamt = bldamt_$P(BloodInfo,"^",3)
			s:(bldunt'="") bldunt = bldunt_"/"
			s bldunt = bldunt_$P(BloodInfo,"^",4)
		}
		*/
		// 责任护士代码
		// 责任护士代码
		s respnurscode = ""
		s respnursrowid = arr.GetAt("HDSD00.12.579")
		s:(respnursrowid'="") respnurscode = $p($g(^SSU("SSUSR",respnursrowid)),"^",1)
	}
	// 给数组赋值
	d ret.SetAt(medcasno,"medcasno")
	d ret.SetAt(psnname,"psn_name")
	d ret.SetAt(gend,"gend")
	d ret.SetAt(brdy,"brdy")
	d ret.SetAt(age,"age")
	d ret.SetAt(ntly,"ntly")
	d ret.SetAt(nwbage,"nwb_age")
	d ret.SetAt(naty,"naty")
	d ret.SetAt(patncerttype,"patn_cert_type")
	d ret.SetAt(certno,"certno")
	d ret.SetAt(prfs,"prfs")
	d ret.SetAt(curraddr,"curr_addr")
	d ret.SetAt(empname,"emp_name")
	d ret.SetAt(empaddr,"emp_addr")
	d ret.SetAt(emptel,"emp_tel")
	d ret.SetAt(poscode,"poscode")
	d ret.SetAt(conername,"coner_name")
	d ret.SetAt(patnrlts,"patn_rlts")
	d ret.SetAt(coneraddr,"coner_addr")
	d ret.SetAt(conertel,"coner_tel")
	d ret.SetAt(nwbbirwt,"nwb_bir_wt")
	d ret.SetAt(nwbadmwt,"nwb_adm_wt")
	d ret.SetAt(admway,"adm_way")
	d ret.SetAt(admtime,"adm_time")
	d ret.SetAt(admcaty,"adm_caty")
	d ret.SetAt(refldeptdept,"refldept_dept")
	d ret.SetAt(dscgtime,"dscg_time")
	d ret.SetAt(dscgcaty,"dscg_caty")
	d ret.SetAt(actiptdays,"act_ipt_days")
	d ret.SetAt(otpwmdise,"otp_wm_dise")
	d ret.SetAt(wmdisecode,"wm_dise_code")
	d ret.SetAt(ventuseddura,"vent_used_dura")
	d ret.SetAt(pwcrybfadmcomadura,"pwcry_bfadm_coma_dura")
	d ret.SetAt(pwcryafadmcomadura,"pwcry_afadm_coma_dura")
	d ret.SetAt(spganurscaredays,"spga_nurscare_days")
	d ret.SetAt(lv1nurscaredays,"lv1_nurscare_days")
	d ret.SetAt(scdnurscaredays,"scd_nurscare_days")
	d ret.SetAt(lv3nurscaredays,"lv3_nurscare_days")
	d ret.SetAt(dscgway,"dscg_way")
	d ret.SetAt(acpmedinsname,"acp_medins_name")
	d ret.SetAt(acpoptinscode,"acp_optins_code")
	d ret.SetAt(daysrinpflag31,"days_rinp_flag_31")
	d ret.SetAt(daysrinppup31,"days_rinp_pup_31")
	d ret.SetAt(chfpdrname,"chfpdr_name")
	d ret.SetAt(chfpdrcode,"chfpdr_code")
	d ret.SetAt(opspdiagcaty,"opsp_diag_caty")
	d ret.SetAt(opspmdtrtdate,"opsp_mdtrt_date")
	d ret.SetAt(diagcodecnt,"diag_code_cnt")
	d ret.SetAt(oprnoprtcodecnt,"oprn_oprt_code_cnt")
	d ret.SetAt(nwbadmtype,"nwb_adm_type")
	d ret.SetAt(trttype,"trt_type")
	d ret.SetAt(bldcat,"bld_cat")
	d ret.SetAt(bldamt,"bld_amt")
	d ret.SetAt(bldunt,"bld_unt")
	d ret.SetAt(respnurscode,"resp_nurs_code")
	
	q ret
}

/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		医保结算清单诊断信息（diseinfo4101）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","diseinfo4101","1902")
Query diseinfo4101(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes) As %Query(ROWSPEC = "diag_type,diag_code,diag_name,adm_cond_type,maindiag_flag") [ SqlProc ]
{
}

ClassMethod diseinfo4101Execute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	//s ^Temp("dd")=$g(ExpDataAry)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (diagtype,diagcode,diagname,admcondtype,maindiagflag) = ""
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	
	if (InstanceID'="")
	{
		// 取病案首页所有诊断数据
		s ALLDiagInfo = ..GetDisDiagose(AEpisodeID)
		s ALLDiagCode = $P(ALLDiagInfo,$C(1),1)
		s ALLDiagDesc = $P(ALLDiagInfo,$C(1),2)
		s ALLAdmCondtionCode = $P(ALLDiagInfo,$C(1),3)
		s ALLAdmCondtionDesc = $P(ALLDiagInfo,$C(1),4)
		For iDiag = 1:1:$L(ALLDiagDesc,"^")
		{
			s DiagCode = $P(ALLDiagCode,"^",iDiag)
			continue:(DiagCode="")||(DiagCode="-")
			
			s DiagDesc = $P(ALLDiagDesc,"^",iDiag)
			s ICUDiagInfo = ..GetINSUDiagInfo(AEpisodeID,DiagCode)
			s DiagCode = $P(ICUDiagInfo,"^",1)
			s DiagDesc = $P(ICUDiagInfo,"^",2)
			
			s AdmCondtionCode = $P(ALLAdmCondtionCode,"^",iDiag)
			s AdmCondtionDesc = $P(ALLAdmCondtionDesc,"^",iDiag)
			
			s diagtype = "出院诊断" // 诊断类别
			s diagcode = DiagCode // 诊断代码
			s diagname = DiagDesc // 诊断名称
			s admcondtype = AdmCondtionCode // 入院病情类型
			
			if (iDiag=1)
			{
				s maindiagflag = "1" // 主诊断标志
			}
			else
			{
				s maindiagflag = "2" // 主诊断标志
			}
			
			set ^CacheTemp(repid, ind) = $LB(diagtype,diagcode,diagname,admcondtype,maindiagflag)
			set ind = ind + 1
		}
	}
	elseif (ZYInstanceID'="")
	{
		// 取中医病案首页所有诊断数据
		s ALLDiagInfo = ..GetZYDisDiagoseInfo(AEpisodeID)
		s ALLDiagCode = $P(ALLDiagInfo,$C(1),1)_"^"_$P(ALLDiagInfo,$C(1),7)
		s ALLDiagDesc = $P(ALLDiagInfo,$C(1),2)_"^"_$P(ALLDiagInfo,$C(1),8)
		s ALLAdmCondtionCode = $P(ALLDiagInfo,$C(1),3)_"^"_$P(ALLDiagInfo,$C(1),9)
		s ALLAdmCondtionDesc = $P(ALLDiagInfo,$C(1),4)_"^"_$P(ALLDiagInfo,$C(1),10)
		For iDiag = 1:1:$L(ALLDiagDesc,"^")
		{
			s DiagCode = $P(ALLDiagCode,"^",iDiag)
			continue:(DiagCode="")||(DiagCode="-")
			
			s DiagDesc = $P(ALLDiagDesc,"^",iDiag)
			s ICUDiagInfo = ..GetINSUDiagInfo(AEpisodeID,DiagCode)
			s DiagCode = $P(ICUDiagInfo,"^",1)
			s DiagDesc = $P(ICUDiagInfo,"^",2)
			
			s AdmCondtionCode = $P(ALLAdmCondtionCode,"^",iDiag)
			s AdmCondtionDesc = $P(ALLAdmCondtionDesc,"^",iDiag)
			
			s diagtype = "出院诊断" // 诊断类别
			s diagcode = DiagCode // 诊断代码
			s diagname = DiagDesc // 诊断名称
			s admcondtype = AdmCondtionCode // 入院病情类型
			
			if (iDiag=1)
			{
				s maindiagflag = "1" // 主诊断标志
			}
			else
			{
				s maindiagflag = "2" // 主诊断标志
			}
			
			set ^CacheTemp(repid, ind) = $LB(diagtype,diagcode,diagname,admcondtype,maindiagflag)
			set ind = ind + 1
		}
	}
	
	Quit $$$OK
}

ClassMethod diseinfo4101Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = diseinfo4101Execute ]
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

ClassMethod diseinfo4101Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = diseinfo4101Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		医保结算清单手术信息（oprninfo4101）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","oprninfo4101","1902")
Query oprninfo4101(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "oprn_oprt_type,oprn_oprt_name,oprn_oprt_code,oprn_oprt_date,anst_way,oper_dr_name,oper_dr_code,anst_dr_name,anst_dr_code,oprn_oprt_sn") [ SqlProc ]
{
}

ClassMethod oprninfo4101Execute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (oprnoprttype,oprnoprtname,oprnoprtcode,oprnoprtdate,anstway,operdrname,operdrcode,anstdrname,anstdrcode)=""
	s (OperRowID,Type)=""
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	
	if (InstanceID'="")
	{
		/// OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
		/// 手术及操作编码_$C(1)_手术及操作名称_$C(1)_手术操作日期时间_$C(1)_手术级别代码_$C(1)_手术级别描述_$C(1)_手术切口类别代码_$C(1)_手术切口类别描述_$C(1)_切口愈合等级代码_$C(1)_切口愈合等级描述_$C(1)_手术者代码_$C(1)_手术者姓名_$C(1)_Ⅰ助代码_$C(1)_Ⅰ助姓名_$C(1)_Ⅱ助代码_$C(1)_Ⅱ助姓名_$C(1)_麻醉方式代码_$C(1)_麻醉方式描述_$C(1)_麻醉医师姓名
		s ALLOperInfo = ..GetFirstOperInfo(AEpisodeID)
		s ALLOperCode = $P(ALLOperInfo,$C(1),1)
		s ALLOperDesc = $P(ALLOperInfo,$C(1),2)
		s ALLOperDate = $P(ALLOperInfo,$C(1),3)
		s ALLOperDocCode = $P(ALLOperInfo,$C(1),10)
		s ALLOperDoc = $P(ALLOperInfo,$C(1),11)
		s ALLAnamethodCode = $P(ALLOperInfo,$C(1),16)
		s ALLAnamethodDesc = $P(ALLOperInfo,$C(1),17)
		s ALLAnaDoc = $P(ALLOperInfo,$C(1),18)
		s ALLOperID = $P(ALLOperInfo,$C(1),19)
		For iOper = 1:1:$L(ALLOperDesc,"^")
		{
			s OperCode = $P(ALLOperCode,"^",iOper)
			continue:(OperCode="")||(OperCode="-")
			s OperDesc = $P(ALLOperDesc,"^",iOper)
			/*
			s:(OperCode'="") OperRowID = $O(^ORC("OPER",0,"ICD10",OperCode,""))
			if (OperRowID'="")
			{
				s Type = $P($G(^ORC("OPER",OperRowID,"DHC")),"^",11)
				s:(Type="N") oprnoprttype = "手术" // 手术操作类别
				s:(Type="T") oprnoprttype = "治疗性操作" // 手术操作类别
				s:(Type="D") oprnoprttype = "诊断性操作" // 手术操作类别
			}*/
			if (iOper=1)
			{
				s oprnoprttype = 1	
			}
			else
			{
				s oprnoprttype = 2	
			}
			
			s INSUOperInfo = ..GetINSUOperInfo(AEpisodeID,OperCode)
			s OperCode = $P(INSUOperInfo,"^",1)
			s OperDesc = $P(INSUOperInfo,"^",2)
			
			s OperDate = $P(ALLOperDate,"^",iOper)
			s OperDocCode = $P(ALLOperDocCode,"^",iOper)
			s OperDoc = $P(ALLOperDoc,"^",iOper)
			s AnamethodCode = $P(ALLAnamethodCode,"^",iOper)
			s AnamethodDesc = $P(ALLAnamethodDesc,"^",iOper)
			s AnaDoc = $P(ALLAnaDoc,"^",iOper)
			
			s oprnoprtname = OperDesc // 手术操作名称
			s oprnoprtcode = OperCode // 手术操作代码
			s oprnoprtdate = OperDate // 手术操作日期
			s anstway = AnamethodDesc // 麻醉方式
			s operdrname = OperDoc // 术者医师姓名
			s operdrcode = OperDocCode // 术者医师代码
			s anstdrname = AnaDoc // 麻醉医师姓名
			s anstdrcode = "" // 麻醉医师代码
			&SQL(SELECT SSUSR_Initials into :anstdrcode FROM SQLUSER.SS_user WHERE SSUSR_Name = :anstdrname)
			s oprnoprtsn = $P(ALLOperID,"^",iOper)	//手术ID
			
			set ^CacheTemp(repid, ind) = $LB(oprnoprttype,oprnoprtname,oprnoprtcode,oprnoprtdate,anstway,operdrname,operdrcode,anstdrname,anstdrcode,oprnoprtsn)
			set ind = ind + 1
		}
	}
	elseif (ZYInstanceID'="")
	{
		/// OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
		/// 手术及操作编码_$C(1)_手术及操作名称_$C(1)_手术操作日期时间_$C(1)_手术级别代码_$C(1)_手术级别描述_$C(1)_手术切口类别代码_$C(1)_手术切口类别描述_$C(1)_切口愈合等级代码_$C(1)_切口愈合等级描述_$C(1)_手术者代码_$C(1)_手术者姓名_$C(1)_Ⅰ助代码_$C(1)_Ⅰ助姓名_$C(1)_Ⅱ助代码_$C(1)_Ⅱ助姓名_$C(1)_麻醉方式代码_$C(1)_麻醉方式描述_$C(1)_麻醉医师姓名
		s ALLOperInfo = ..GetZYFirstOperInfo(AEpisodeID)
		s ALLOperCode = $P(ALLOperInfo,$C(1),1)
		s ALLOperDesc = $P(ALLOperInfo,$C(1),2)
		s ALLOperDate = $P(ALLOperInfo,$C(1),3)
		s ALLOperDocCode = $P(ALLOperInfo,$C(1),10)
		s ALLOperDoc = $P(ALLOperInfo,$C(1),11)
		s ALLAnamethodCode = $P(ALLOperInfo,$C(1),16)
		s ALLAnamethodDesc = $P(ALLOperInfo,$C(1),17)
		s ALLAnaDoc = $P(ALLOperInfo,$C(1),18)
		s ALLOperID = $P(ALLOperInfo,$C(1),19)
		For iOper = 1:1:$L(ALLOperDesc,"^")
		{
			s OperCode = $P(ALLOperCode,"^",iOper)
			continue:(OperCode="")||(OperCode="-")
			s OperDesc = $P(ALLOperDesc,"^",iOper)
			/*
			s:(OperCode'="") OperRowID = $O(^ORC("OPER",0,"ICD10",OperCode,""))
			if (OperRowID'="")
			{
				s Type = $P($G(^ORC("OPER",OperRowID,"DHC")),"^",11)
				s:(Type="N") oprnoprttype = "手术" // 手术操作类别
				s:(Type="T") oprnoprttype = "治疗性操作" // 手术操作类别
				s:(Type="D") oprnoprttype = "诊断性操作" // 手术操作类别
			}*/
			if (iOper=1)
			{
				s oprnoprttype = 1	
			}
			else
			{
				s oprnoprttype = 2	
			}
			
			s INSUOperInfo = ..GetINSUOperInfo(AEpisodeID,OperCode)
			s OperCode = $P(INSUOperInfo,"^",1)
			s OperDesc = $P(INSUOperInfo,"^",2)
			
			s OperDate = $P(ALLOperDate,"^",iOper)
			s OperDocCode = $P(ALLOperDocCode,"^",iOper)
			s OperDoc = $P(ALLOperDoc,"^",iOper)
			s AnamethodCode = $P(ALLAnamethodCode,"^",iOper)
			s AnamethodDesc = $P(ALLAnamethodDesc,"^",iOper)
			s AnaDoc = $P(ALLAnaDoc,"^",iOper)
			
			s oprnoprtname = OperDesc // 手术操作名称
			s oprnoprtcode = OperCode // 手术操作代码
			s oprnoprtdate = OperDate // 手术操作日期
			s anstway = AnamethodDesc // 麻醉方式
			s operdrname = OperDoc // 术者医师姓名
			s operdrcode = OperDocCode // 术者医师代码
			s anstdrname = AnaDoc // 麻醉医师姓名
			s anstdrcode = "" // 麻醉医师代码
			&SQL(SELECT SSUSR_Initials into :anstdrcode FROM SQLUSER.SS_user WHERE SSUSR_Name = :anstdrname)
			s oprnoprtsn = $P(ALLOperID,"^",iOper)	//手术ID
			
			set ^CacheTemp(repid, ind) = $LB(oprnoprttype,oprnoprtname,oprnoprtcode,oprnoprtdate,anstway,operdrname,operdrcode,anstdrname,anstdrcode,oprnoprtsn)
			set ind = ind + 1
		}
	}
	
	Quit $$$OK
}

ClassMethod oprninfo4101Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = oprninfo4101Execute ]
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

ClassMethod oprninfo4101Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = oprninfo4101Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		医保结算清单重症监护信息（节点标识：icuinfo4101）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","icuinfo4101","1902")
Query icuinfo4101(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "scs_cutd_ward_type,scs_cutd_inpool_time,scs_cutd_exit_time,scs_cutd_sum_dura") [ SqlProc ]
{
}

ClassMethod icuinfo4101Execute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (scscutdwardtype,scscutdinpooltime,scscutdexittime,scscutdsumdura) = ""
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	
	if (InstanceID'="")
	{
		s ALLICUInfo = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.546","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.547","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.548","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.549","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.550","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.551","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.552","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.553","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.554","0")
	}
	elseif (ZYInstanceID'="")
	{
		s ALLICUInfo = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.546","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.547","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.548","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.549","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.550","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.551","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.552","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.553","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.554","0")	
	}
	For iICU = 1:1:$L(ALLICUInfo,"!")
	{
		// 1/CCU,2/NICU,3/EICU,4/SICU,5/PICU,6/RICU,9/其他
		s scscutdwardtype = $P($P(ALLICUInfo,"!",iICU),"^",1) // 重症监护病房类型
		continue:(scscutdwardtype="")||(scscutdwardtype="-")
		s:(scscutdwardtype["-") scscutdwardtype = $P(scscutdwardtype,"-",1)
		
		s scscutdinpooltime = $P($P(ALLICUInfo,"!",iICU),"^",2) // 重症监护进入时间
		s scscutdinpooltime = ..ConvertStandDate(scscutdinpooltime)
		s scscutdexittime = $P($P(ALLICUInfo,"!",iICU),"^",3) // 重症监护退出时间
		s scscutdexittime = ..ConvertStandDate(scscutdexittime)
		
		s startdate = $ZDH($P(scscutdinpooltime," ",1),3)
		s starttime = $ZTH($P(scscutdinpooltime," ",2))
		s enddate = $ZDH($P(scscutdexittime," ",1),3)
		s endtime = $ZTH($P(scscutdexittime," ",2))
		continue:(startdate="")||(enddate="")
		
		s span = ((enddate-startdate)*24)+((endtime-starttime)/3600)  // 重症监护合计时长
		s span = $FN(span,"",2)
		s (day,hour,min)="0"
		if (span<24)
		{
			s day = "0"
			s hour = $P(span,".",1)
			s min = (span-hour)*60
			s min = $P(min,".",1)
		}
		else
		{
			s day = span\24
			s hour = $P((span#24),".",1)
			s min = ((span#24)-hour)*60
			s min = $P(min,".",1)
		}
		s scscutdsumdura = day_"/"_hour_"/"_min
		
		set ^CacheTemp(repid, ind) = $LB(scscutdwardtype,scscutdinpooltime,scscutdexittime,scscutdsumdura)
		set ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod icuinfo4101Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = icuinfo4101Execute ]
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

ClassMethod icuinfo4101Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = icuinfo4101Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2022-10-12
/// Desc：		输血信息（GetBloodInfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(EMRservice.BL.Interface.RecordInfoToINSU).GetBloodInfo(1902)
ClassMethod GetBloodInfo(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	if (InstanceID'="")
	{
		s (bldcat,bldamt,bldunt) = ""
		//红细胞
		s bldamt = ##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.994","0")
		//血小板
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.995","0")
		//血浆
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.996","0")
		//全血
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.997","0")
		//自体血回输
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.998","0")
		s bldcat = "红细胞/血小板/血浆/全血/自体血回输"
		s bldamt = bldamt
		s bldunt = "单位/治疗量/ml/ml/单位"	
	}
	elseif (ZYInstanceID'="")
	{
		s (bldcat,bldamt,bldunt) = ""
		//红细胞
		s bldamt = ##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.994","0")
		//血小板
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.995","0")
		//血浆
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.996","0")
		//全血
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.997","0")
		//自体血回输
		s bldamt = bldamt_"/"_##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.998","0")
		s bldcat = "红细胞/血小板/血浆/全血/自体血回输"
		s bldamt = bldamt
		s bldunt = "单位/治疗量/ml/ml/单位"	
	}
	
	set Bldinfo=##class(%ListOfDataTypes).%New()
	For i = 1:1:5
	{
		s bldcatvalue = $P(bldcat,"/",i)
		s bldamtvalue = $P(bldamt,"/",i)
		s blduntvalue = $P(bldunt,"/",i)
	    Continue:+bldamtvalue=0
		s data = ##class(%ArrayOfDataTypes).%New()
		d data.SetAt(bldcatvalue,"bld_cat")
		d data.SetAt(bldamtvalue,"bld_amt")
		d data.SetAt(blduntvalue,"bld_unt")
		d Bldinfo.Insert(data)
	}
	
	q Bldinfo
}

/// 【----------医保结算清单[4101]信息----------】
/// 【----------住院病案首页信息[4401]信息----------】
/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		住院病案首页基本信息（baseinfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","baseinfo","1902")
Query baseinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn,mdtrt_id,psn_no,patn_ipt_cnt,ipt_no,medcasno,psn_name,gend,brdy,ntly,ntly_name,nwb_bir_wt,nwb_adm_wt,birplc,napl,naty_name,naty,certno,prfs,mrg_stas,curr_addr_poscode,curr_addr,psn_tel,resd_addr_prov,resd_addr_city,resd_addr_coty,resd_addr_subd,resd_addr_vil,resd_addr_housnum,resd_addr_poscode,resd_addr,empr_tel,empr_poscode,empr_addr,coner_tel,coner_name,coner_addr,coner_rlts_code,adm_way_name,adm_way_code,trt_type_name,trt_type,adm_caty,adm_ward,adm_date,dscg_date,dscg_caty,Refldept_caty_name,dscg_ward,ipt_days,drug_dicm_flag,dicm_drug_name,die_autp_flag,abo_code,abo_name,rh_code,rh_name,die_flag,deptdrt_name,chfdr_name,atddr_name,chfpdr_name,ipt_dr_name,resp_nurs_name,train_dr_name,intn_dr_name,codr_name,qltctrl_dr_name,qltctrl_nurs_name,medcas_qlt_name,medcas_qlt_code,qltctrl_date,dscg_way_name,dscg_way,acp_medins_code,acp_medins_name,dscg_31days_rinp_flag,dscg_31days_rinp_pup,damg_intx_ext_rea,damg_intx_ext_rea_disecode,brn_damg_bfadm_coma_dura,brn_damg_afadm_coma_dura,vent_used_dura,cnfm_date,patn_dise_diag_crsp,patn_dise_diag_crsp_code,ipt_patn_diag_inscp,ipt_patn_diag_inscp_code,dscg_trt_rslt,dscg_trt_rslt_code,medins_orgcode,age,aise,pote_intn_dr_name,hbsag,hcvab,hivab,resc_cnt,resc_succ_cnt,hosp_dise_fsttime,hif_pay_way_name,hif_pay_way_code,med_fee_paymtd_name,medfee_paymtd_code,selfpay_amt,medfee_sumamt,ordn_med_servfee,ordn_trt_oprt_fee,nurs_fee,com_med_serv_oth_fee,palg_diag_fee,lab_diag_fee,rdhy_diag_fee,clnc_dise_fee,nsrgtrt_item_fee,clnc_phys_trt_fee,rgtrt_trt_fee,anst_fee,oprn_fee,rhab_fee,tcm_trt_fee,wm_fee,abtl_medn_fee,tcmpat_fee,tcmherb_fee,blo_fee,albu_fee,glon_fee,clotfac_fee,cyki_fee,exam_dspo_matl_fee,trt_dspo_matl_fee,oprn_dspo_matl_fee,oth_fee,vali_flag,fixmedins_code") [ SqlProc ]
{
}

ClassMethod baseinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (mdtrtsn,mdtrtid,psnno,patniptcnt,iptno,medcasno,psnname,gend,brdy,ntly,ntlyname,nwbbirwt,nwbadmwt,birplc,napl,natyname,naty,certno,prfs,mrgstas,curraddrposcode,curraddr,psntel,resdaddrprov,resdaddrcity,resdaddrcoty,resdaddrsubd,resdaddrvil,resdaddrhousnum,resdaddrposcode,resdaddr,emprtel,emprposcode) = ""
	s (empraddr,conertel,conername,coneraddr,conerrltscode,admwayname,admwaycode,trttypename,trttype,admcaty,admward,admdate,dscgdate,dscgcaty,Refldeptcatyname,dscgward,iptdays,drugdicmflag,dicmdrugname,dieautpflag,abocode,aboname,rhcode,rhname,dieflag,deptdrtname,chfdrname,atddrname,chfpdrname,iptdrname) = ""
	s (respnursname,traindrname,intndrname,codrname,qltctrldrname,qltctrlnursname,medcasqltname,medcasqltcode,qltctrldate,dscgwayname,dscgway,acpmedinscode,acpmedinsname,dscg31daysrinpflag,dscg31daysrinppup,damgintxextrea,damgintxextreadisecode,brndamgbfadmcomadura,brndamgafadmcomadura,ventuseddura,cnfmdate) = ""
	s (patndisediagcrsp,patndisediagcrspcode,iptpatndiaginscp,iptpatndiaginscpcode,dscgtrtrslt,dscgtrtrsltcode,medinsorgcode,age,aise,poteintndrname,hbsag,hcvab,hivab,resccnt,rescsucccnt,hospdisefsttime,hifpaywayname,hifpaywaycode,medfeepaymtdname,medfeepaymtdcode,selfpayamt,medfeesumamt,ordnmedservfee) = ""
	s (ordntrtoprtfee,nursfee,commedservothfee,palgdiagfee,labdiagfee,rdhydiagfee,clncdisefee,nsrgtrtitemfee,clncphystrtfee,rgtrttrtfee,anstfee,oprnfee,rhabfee,tcmtrtfee,wmfee,abtlmednfee,tcmpatfee,tcmherbfee,blofee,albufee,glonfee,clotfacfee,cykifee,examdspomatlfee,trtdspomatlfee,oprndspomatlfee,othfee,valiflag,fixmedinscode) = ""
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	
	if ($IsObject(ExpDataAry))
    {
		s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")  // 就医流水号
		s mdtrtid = ExpDataAry.GetAt("mdtrt_id")  // 就诊ID
		s psnno = ExpDataAry.GetAt("psn_no")  // 人员编号
		s medinsorgcode = ExpDataAry.GetAt("medins_orgcode") // 医疗机构组织机构代码
		s fixmedinscode = ExpDataAry.GetAt("fixmedins_code")  // 定点医药机构编号 必填
    }
    
    if (InstanceID'="")
    {
		s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.11")
		s patniptcnt = arr.GetAt("HDSD00.11.139") // 患者住院次数
		s iptno = IPRecordNo // 住院号
		s medcasno = IPRecordNo // 病案号
		s psnname = arr.GetAt("HDSD00.11.110") // 人员姓名
		s gend = arr.GetAt("HDSD00.11.109") // 性别
		s brdy = arr.GetAt("HDSD00.11.014") // 出生日期
		s brdy = ..ConvertStandDate(brdy)
		s ntly = arr.GetAt("HDSD00.11.036") // 国籍
		s ntlyname = arr.GetAt("HDSD00.11.563") // 国籍名称
		s nwbbirwt = arr.GetAt("HDSD00.11.107") // 新生儿出生体重
		s nwbadmwt = arr.GetAt("HDSD00.11.108") // 新生儿入院体重
		s birplc = arr.GetAt("HDSD00.11.011")_arr.GetAt("HDSD00.11.012")_arr.GetAt("HDSD00.11.013") // 出生地
		s napl = arr.GetAt("HDSD00.11.051")_arr.GetAt("HDSD00.11.052") // 籍贯
		s natyname = arr.GetAt("HDSD00.11.590") // 民族名称
		s naty = arr.GetAt("HDSD00.11.077") // 民族
		s certno = arr.GetAt("HDSD00.11.048") // 证件号码
		s prfs = arr.GetAt("HDSD00.11.564") // 职业  职业代码
		s mrgstas = arr.GetAt("HDSD00.11.587") // 婚姻状态
		s curraddrposcode = arr.GetAt("HDSD00.11.106") // 现住址邮政编码
		s curraddr = arr.GetAt("HDSD00.11.102")_"/"_arr.GetAt("HDSD00.11.103")_"/"_arr.GetAt("HDSD00.11.104")_"/"_arr.GetAt("HDSD00.11.105") // 现住址
		s psntel = arr.GetAt("HDSD00.11.026") // 个人联系电话
		s resdaddrprov = arr.GetAt("HDSD00.11.043") // 户口地址省（自治区、直辖市）
		s resdaddrcity = arr.GetAt("HDSD00.11.044") // 户口地址市（地区）
		s resdaddrcoty = arr.GetAt("HDSD00.11.045") // 户口地址县（区）
		s resdaddrsubd = arr.GetAt("HDSD00.11.046") // 户口地址乡（镇、街道办事处）
		s resdaddrvil = arr.GetAt("HDSD00.11.041") // 户口地址村（街、路、弄等）
		s resdaddrhousnum = arr.GetAt("HDSD00.11.042") // 户口地址门牌号码
		s resdaddrposcode = arr.GetAt("HDSD00.11.047") // 户口地址 邮政编码
		s resdaddr = resdaddrprov_resdaddrcity_resdaddrcoty_resdaddrsubd // 户口地址
		s emprtel = arr.GetAt("HDSD00.11.034") // 工作单位联系电话
		s emprposcode = arr.GetAt("HDSD00.11.033") // 工作单位 邮政编码
		s empraddr = arr.GetAt("HDSD00.11.035") // 工作单位及地址
		s conertel = arr.GetAt("HDSD00.11.064") // 联系人电话
		s conername = arr.GetAt("HDSD00.11.065") // 联系人姓名
		s coneraddr = arr.GetAt("HDSD00.11.060") // 联系人地址
		s conerrltscode = arr.GetAt("HDSD00.11.066") // 与联系人关系代码
		s admwayname = arr.GetAt("HDSD00.11.591") // 入院途径名称
		s admwaycode = arr.GetAt("HDSD00.11.086") // 入院途径代码
		s trttypename = "西医" // 治疗类别名称
		s trttype = "1" // 治疗类别
		s admcaty = arr.GetAt("HDSD00.11.084") // 入院科别
		s admward = arr.GetAt("HDSD00.11.083") // 入院病房
		s admdate = arr.GetAt("HDSD00.11.085") // 入院日期
		s admdate = ..ConvertStandDate(admdate)
		s dscgdate = arr.GetAt("HDSD00.11.019") // 出院日期
		s dscgdate = ..ConvertStandDate(dscgdate)
		s dscgcaty = arr.GetAt("HDSD00.11.018") // 出院科别
		s Refldeptcatyname = arr.GetAt("HDSD00.11.144") // 转科科别名称
		s dscgward = arr.GetAt("HDSD00.11.017") // 出院病房
		s iptdays = arr.GetAt("HDSD00.11.087") // 住院天数
		s drugdicmflag = arr.GetAt("HDSD00.11.116") // 药物过敏标志
		s dicmdrugname = arr.GetAt("HDSD00.11.037") // 过敏药物名称
		s dieautpflag = arr.GetAt("HDSD00.11.095") // 死亡患者尸检标志
		s abocode = arr.GetAt("HDSD00.11.003") // ABO血型代码
		s aboname = arr.GetAt("HDSD00.11.597") // ABO血型名称
		s rhcode = arr.GetAt("HDSD00.11.004") // Rh血型代码
		s rhname = arr.GetAt("HDSD00.11.598") // RH血型
		
		s dscgwayname = arr.GetAt("HDSD00.11.603") // 离院方式名称
		s dscgway = arr.GetAt("HDSD00.11.057") // 离院方式
		s dieflag = "N"
		s:(dscgwayname="死亡") dieflag = "Y" // 死亡标志
		
		s deptdrtname = arr.GetAt("HDSD00.11.056") // 科主任姓名
		s chfdrname = arr.GetAt("HDSD00.11.137") // 主任( 副主任)医师姓名
		s atddrname = arr.GetAt("HDSD00.11.138") // 主治医生姓名
		s chfpdrname = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3) // 主诊医师姓名
		s iptdrname = arr.GetAt("HDSD00.11.141") // 住院医师姓名
		s respnursname = arr.GetAt("HDSD00.11.120") // 责任护士姓名
		s traindrname = arr.GetAt("HDSD00.11.054") // 进修医师姓名
		s intndrname = arr.GetAt("HDSD00.11.088") // 实习医师姓名
		s codrname = arr.GetAt("HDSD00.11.005") // 编码员姓名
		s qltctrldrname = arr.GetAt("HDSD00.11.128") // 质控医师姓名
		s qltctrlnursname = arr.GetAt("HDSD00.11.126") // 质控护士姓名
		s medcasqltname = arr.GetAt("HDSD00.11.899") // 病案质量名称
		s medcasqltcode = arr.GetAt("HDSD00.11.007") // 病案质量代码
		s qltctrldate = arr.GetAt("HDSD00.11.127") // 质控日期
		
		s acpmedinscode = arr.GetAt("HDSD00.11.2615") // 拟接收医疗机构代码
		s acpmedinsname = arr.GetAt("HDSD00.11.078") // 拟接收医疗机构名称 
		s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		if (acpmedinsname="")||(acpmedinsname="-")
		{
			s acpoptinscode = $P(arr.GetAt("HDSD00.11.078"),"^",1) // 拟接收机构代码
			s acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",2) // 拟接收机构名称
			s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		}
		
		s dscg31daysrinpflag = arr.GetAt("HDSD00.11.015") // 出院 31天内再住院计划标志
		s dscg31daysrinppup = arr.GetAt("HDSD00.11.016") // 出院31天内再住院目的
		s damgintxextrea = arr.GetAt("HDSD00.11.096") // 损伤、中毒的外部原因
		s damgintxextreadisecode = arr.GetAt("HDSD00.11.097") // 损伤、中毒的外部原因疾病编码
		s brndamgbfadmcomadura = arr.GetAt("HDSD00.11.070")_"/"_arr.GetAt("HDSD00.11.071")_"/"_arr.GetAt("HDSD00.11.072") // 颅脑损伤患者入院前昏迷时长
		s brndamgafadmcomadura = arr.GetAt("HDSD00.11.067")_"/"_arr.GetAt("HDSD00.11.068")_"/"_arr.GetAt("HDSD00.11.069") // 颅脑损伤患者入院后昏迷时长
		s ventuseddura = arr.GetAt("HDSD00.11.555") // 呼吸机使用时长
		s (day,hour,min) = "0"
		if (ventuseddura<24)
		{
			s day=0
			s hour=$P(ventuseddura,".",1)
			s min=(ventuseddura*60)-(hour*60)
			s min = $P(min,".",1)
		}
		else
		{
			s day=ventuseddura\24
			s hour=$P((ventuseddura#24),".",1)
			s min=((ventuseddura#24)-hour)*60
			s min = $P(min,".",1)
		}
		s ventuseddura = day_"/"_hour_"/"_min
		
		s cnfmdate = arr.GetAt("HDSD00.11.085") // 确诊日期
		s cnfmdate = ..ConvertStandDate(cnfmdate)
		s patndisediagcrsp = "" // 患者疾病诊断对照
		s patndisediagcrspcode = "" // 住院患者疾病诊断对照代码
		s iptpatndiaginscp = "" // 住院患者诊断符合情况
		s iptpatndiaginscpcode = "" // 住院患者诊断符合情况代码
		s dscgtrtrslt = ..GetDscgTrtRslt(AEpisodeID,"DESC") // 出院治疗结果
		s dscgtrtrsltcode = ..GetDscgTrtRslt(AEpisodeID,"CODE") // 出院治疗结果代码
		//s age = arr.GetAt("HDSD00.11.079") // 年龄
		s age=##class(INSU.BL.Interface.DataRpUp).GetAdmAge(AEpisodeID,"","4401")
		
		s aise = $P(..GetAise(AEpisodeID),"^",2) // 过敏源
		s poteintndrname = arr.GetAt("HDSD00.11.088") // 研究生实习医师姓名
		s hbsag = ..GetLisData(AEpisodeID,"HBSAG") // 乙肝表面抗原（HbsAg）
		s hcvab = ..GetLisData(AEpisodeID,"HCVAB") // 丙型肝炎抗体（HCVAb）
		s hivab = ..GetLisData(AEpisodeID,"HIVAB") // 艾滋病毒抗体（hivab）
		s resccnt = arr.GetAt("HDSD00.11.569") // 抢救次数
		s rescsucccnt = arr.GetAt("HDSD00.11.570") // 抢救成功次数
		s hospdisefsttime = "" // 手术、治疗、检查、诊断为本院第一例
		s hifpaywayname = "" // 医保基金付费方式名称
		s hifpaywaycode = "" // 医保基金付费方式代码
		s medfeepaymtdname = arr.GetAt("HDSD00.11.585") // 医疗费用支付方式名称
		s medfeepaymtdcode = arr.GetAt("HDSD00.11.117") // 医疗费用支付方式代码
		
		s arrFee = ##Class(%ArrayOfDataTypes).%New()
		s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(AEpisodeID)
		if (InPatFee'="异常信息:总费用与费用类汇总数额不符，请验证接口后使用")
		{
			s Count=$l(InPatFee,"!")
			f i=1:1:Count 
			{
				s tmpFee=$p(InPatFee,"!",i)
				s FeeType=$p(tmpFee,"^",2)
				s FeeNum=$p(tmpFee,"^",3)
				d arrFee.SetAt(FeeNum,FeeType)
			}
			s medfeesumamt = arrFee.GetAt("总费用")
			s selfpayamt = arrFee.GetAt("自付金额")
			s ordnmedservfee = arrFee.GetAt("一般医疗服务费")
			s ordntrtoprtfee = arrFee.GetAt("一般治疗操作费")
			s nursfee = arrFee.GetAt("护理费")
			s commedservothfee = arrFee.GetAt("其他费")
			s palgdiagfee = arrFee.GetAt("病理诊断费")
			s labdiagfee = arrFee.GetAt("实验室诊断费")
			s rdhydiagfee = arrFee.GetAt("影像学诊断费")
			s clncdisefee = arrFee.GetAt("临床诊断项目费")
			s nsrgtrtitemfee = $FN(arrFee.GetAt("非手术治疗项目费")+arrFee.GetAt("临床诊断项目费"),"",2)
			s clncphystrtfee = arrFee.GetAt("临床物理治疗费")
			s anstfee = arrFee.GetAt("麻醉费")
			s oprnfee = arrFee.GetAt("手术费")
			s rgtrttrtfee = $FN(arrFee.GetAt("手术治疗费")+arrFee.GetAt("麻醉费")+arrFee.GetAt("手术费"),"",2)
			s rhabfee = arrFee.GetAt("康复费")
			s tcmtrtfee = arrFee.GetAt("中医治疗费")
			s abtlmednfee = arrFee.GetAt("抗菌药物费")
			s wmfee = $FN(arrFee.GetAt("西药费")+arrFee.GetAt("抗菌药物费"),"",2)
			s tcmpatfee = arrFee.GetAt("中成药费")
			s tcmherbfee = arrFee.GetAt("中草药费")
			s blofee = arrFee.GetAt("血费")
			s albufee = arrFee.GetAt("白蛋白类制品费")
			s glonfee = arrFee.GetAt("球蛋白类制品费")
			s clotfacfee = arrFee.GetAt("凝血因子类制品费")
			s cykifee = arrFee.GetAt("细胞因子类制品费")
			s examdspomatlfee = arrFee.GetAt("检查用一次性医用材料费")
			s trtdspomatlfee = arrFee.GetAt("治疗用一次性医用材料费")
			s oprndspomatlfee = arrFee.GetAt("手术用一次性医用材料费")
			s othfee = arrFee.GetAt("其他费用")
		}
		s valiflag = "Y" // 有效标志 必填
		
		set ^CacheTemp(repid, ind) = $LB(mdtrtsn,mdtrtid,psnno,patniptcnt,iptno,medcasno,psnname,gend,brdy,ntly,ntlyname,nwbbirwt,nwbadmwt,birplc,napl,natyname,naty,certno,prfs,mrgstas,curraddrposcode,curraddr,psntel,resdaddrprov,resdaddrcity,resdaddrcoty,resdaddrsubd,resdaddrvil,resdaddrhousnum,resdaddrposcode,resdaddr,emprtel,emprposcode,empraddr,conertel,conername,coneraddr,conerrltscode,admwayname,admwaycode,trttypename,trttype,admcaty,admward,admdate,dscgdate,dscgcaty,Refldeptcatyname,dscgward,iptdays,drugdicmflag,dicmdrugname,dieautpflag,abocode,aboname,rhcode,rhname,dieflag,deptdrtname,chfdrname,atddrname,chfpdrname,iptdrname,respnursname,traindrname,intndrname,codrname,qltctrldrname,qltctrlnursname,medcasqltname,medcasqltcode,qltctrldate,dscgwayname,dscgway,acpmedinscode,acpmedinsname,dscg31daysrinpflag,dscg31daysrinppup,damgintxextrea,damgintxextreadisecode,brndamgbfadmcomadura,brndamgafadmcomadura,ventuseddura,cnfmdate,patndisediagcrsp,patndisediagcrspcode,iptpatndiaginscp,iptpatndiaginscpcode,dscgtrtrslt,dscgtrtrsltcode,medinsorgcode,age,aise,poteintndrname,hbsag,hcvab,hivab,resccnt,rescsucccnt,hospdisefsttime,hifpaywayname,hifpaywaycode,medfeepaymtdname,medfeepaymtdcode,selfpayamt,medfeesumamt,ordnmedservfee,ordntrtoprtfee,nursfee,commedservothfee,palgdiagfee,labdiagfee,rdhydiagfee,clncdisefee,nsrgtrtitemfee,clncphystrtfee,rgtrttrtfee,anstfee,oprnfee,rhabfee,tcmtrtfee,wmfee,abtlmednfee,tcmpatfee,tcmherbfee,blofee,albufee,glonfee,clotfacfee,cykifee,examdspomatlfee,trtdspomatlfee,oprndspomatlfee,othfee,valiflag,fixmedinscode)
		set ind = ind + 1
    }
    elseif (ZYInstanceID'="")
    {
	    s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.12")
		s patniptcnt = arr.GetAt("HDSD00.12.166") // 患者住院次数
		s iptno = IPRecordNo // 住院号
		s medcasno = IPRecordNo // 病案号
		s psnname = arr.GetAt("HDSD00.12.125") // 人员姓名
		s gend = arr.GetAt("HDSD00.12.124") // 性别
		s brdy = arr.GetAt("HDSD00.12.015") // 出生日期
		s brdy = ..ConvertStandDate(brdy)
		s ntly = arr.GetAt("HDSD00.12.043") // 国籍
		s ntlyname = arr.GetAt("HDSD00.12.563") // 国籍名称
		s nwbbirwt = arr.GetAt("HDSD00.12.122") // 新生儿出生体重
		s nwbadmwt = arr.GetAt("HDSD00.12.123") // 新生儿入院体重
		s birplc = arr.GetAt("HDSD00.12.012")_arr.GetAt("HDSD00.12.013")_arr.GetAt("HDSD00.12.014") // 出生地
		s napl = arr.GetAt("HDSD00.12.058")_arr.GetAt("HDSD00.12.059") // 籍贯
		s natyname = arr.GetAt("HDSD00.12.590") // 民族名称
		s naty = arr.GetAt("HDSD00.12.088") // 民族
		s certno = arr.GetAt("HDSD00.12.055") // 证件号码
		s prfs = arr.GetAt("HDSD00.12.564") // 职业  职业代码
		s mrgstas = arr.GetAt("HDSD00.12.587") // 婚姻状态
		s curraddrposcode = arr.GetAt("HDSD00.12.121") // 现住址邮政编码
		s curraddr = arr.GetAt("HDSD00.12.117")_arr.GetAt("HDSD00.12.118")_arr.GetAt("HDSD00.12.119")_arr.GetAt("HDSD00.12.120") // 现住址
		s psntel = arr.GetAt("HDSD00.12.033") // 个人联系电话
		s resdaddrprov = arr.GetAt("HDSD00.12.050") // 户口地址省（自治区、直辖市）
		s resdaddrcity = arr.GetAt("HDSD00.12.051") // 户口地址市（地区）
		s resdaddrcoty = arr.GetAt("HDSD00.12.052") // 户口地址县（区）
		s resdaddrsubd = arr.GetAt("HDSD00.12.053") // 户口地址乡（镇、街道办事处）
		s resdaddrvil = arr.GetAt("HDSD00.12.048") // 户口地址村（街、路、弄等）
		s resdaddrhousnum = arr.GetAt("HDSD00.12.049") // 户口地址门牌号码
		s resdaddrposcode = arr.GetAt("HDSD00.12.054") // 户口地址 邮政编码
		s resdaddr = resdaddrprov_resdaddrcity_resdaddrcoty_resdaddrsubd // 户口地址
		s emprtel = arr.GetAt("HDSD00.12.041") // 工作单位联系电话
		s emprposcode = arr.GetAt("HDSD00.12.040") // 工作单位 邮政编码
		s empraddr = arr.GetAt("HDSD00.12.036") // 工作单位及地址
		s conertel = arr.GetAt("HDSD00.12.071") // 联系人电话
		s conername = arr.GetAt("HDSD00.12.072") // 联系人姓名
		s coneraddr = arr.GetAt("HDSD00.12.067") // 联系人地址
		s conerrltscode = arr.GetAt("HDSD00.12.073") // 与联系人关系代码
		s admwayname = arr.GetAt("HDSD00.12.591") // 入院途径名称
		s admwaycode = arr.GetAt("HDSD00.12.097") // 入院途径代码
		s trttypename = $P(arr.GetAt("HDSD00.12.144"),"^",2) // 治疗类别名称
		s trttype = $P(arr.GetAt("HDSD00.12.144"),"^",1) // 治疗类别
		s admcaty = arr.GetAt("HDSD00.12.095") // 入院科别
		s admward = arr.GetAt("HDSD00.12.094") // 入院病房
		s admdate = arr.GetAt("HDSD00.12.096") // 入院日期
		s admdate = ..ConvertStandDate(admdate)
		s dscgdate = arr.GetAt("HDSD00.12.020") // 出院日期
		s dscgdate = ..ConvertStandDate(dscgdate)
		s dscgcaty = arr.GetAt("HDSD00.12.019") // 出院科别
		s Refldeptcatyname = arr.GetAt("HDSD00.12.171") // 转科科别名称
		s dscgward = arr.GetAt("HDSD00.12.018") // 出院病房
		s iptdays = arr.GetAt("HDSD00.12.098") // 住院天数
		s drugdicmflag = arr.GetAt("HDSD00.12.131") // 药物过敏标志
		s dicmdrugname = arr.GetAt("HDSD00.12.044") // 过敏药物名称
		s dieautpflag = arr.GetAt("HDSD00.12.110") // 死亡患者尸检标志
		s abocode = arr.GetAt("HDSD00.12.003") // ABO血型代码
		s aboname = arr.GetAt("HDSD00.12.597") // ABO血型名称
		s rhcode = arr.GetAt("HDSD00.12.004") // Rh血型代码
		s rhname = arr.GetAt("HDSD00.12.598") // RH血型
		
		s dscgwayname = arr.GetAt("HDSD00.12.603") // 离院方式名称
		s dscgway = arr.GetAt("HDSD00.12.064") // 离院方式
		s dieflag = "N"
		s:(dscgwayname="死亡") dieflag = "Y" // 死亡标志
		
		s deptdrtname = arr.GetAt("HDSD00.12.063") // 科主任姓名
		s chfdrname = arr.GetAt("HDSD00.12.164") // 主任( 副主任)医师姓名
		s atddrname = arr.GetAt("HDSD00.12.165") // 主治医生姓名
		s chfpdrname = $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3) // 主诊医师姓名
		s iptdrname = arr.GetAt("HDSD00.12.168") // 住院医师姓名
		s respnursname = arr.GetAt("HDSD00.12.135") // 责任护士姓名
		s traindrname = arr.GetAt("HDSD00.12.061") // 进修医师姓名
		s intndrname = arr.GetAt("HDSD00.12.100") // 实习医师姓名
		s codrname = arr.GetAt("HDSD00.12.005") // 编码员姓名
		s qltctrldrname = arr.GetAt("HDSD00.12.143") // 质控医师姓名
		s qltctrlnursname = arr.GetAt("HDSD00.12.141") // 质控护士姓名
		s medcasqltname = arr.GetAt("HDSD00.12.899") // 病案质量名称
		s medcasqltcode = arr.GetAt("HDSD00.12.008") // 病案质量代码
		s qltctrldate = arr.GetAt("HDSD00.12.142") // 质控日期
		
		s acpmedinscode = $P(arr.GetAt("HDSD00.11.078"),"^",1) // 拟接收医疗机构代码
		s acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",2) // 拟接收医疗机构名称
		s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		if (acpmedinsname="")||(acpmedinsname="-")
		{
			s acpoptinscode = $P(arr.GetAt("HDSD00.11.078"),"^",1) // 拟接收机构代码
			s acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",2) // 拟接收机构名称
			s:(acpmedinsname="") acpmedinsname = $P(arr.GetAt("HDSD00.11.078"),"^",1)
		}
		
		s dscg31daysrinpflag = arr.GetAt("HDSD00.12.016") // 出院 31天内再住院计划标志
		s dscg31daysrinppup = arr.GetAt("HDSD00.12.017") // 出院31天内再住院目的
		s damgintxextrea = arr.GetAt("HDSD00.12.111") // 损伤、中毒的外部原因
		s damgintxextreadisecode = arr.GetAt("HDSD00.12.112") // 损伤、中毒的外部原因疾病编码
		s brndamgbfadmcomadura = arr.GetAt("HDSD00.12.077")_"/"_arr.GetAt("HDSD00.12.078")_"/"_arr.GetAt("HDSD00.12.079") // 颅脑损伤患者入院前昏迷时长
		s brndamgafadmcomadura = arr.GetAt("HDSD00.12.074")_"/"_arr.GetAt("HDSD00.12.075")_"/"_arr.GetAt("HDSD00.12.076") // 颅脑损伤患者入院后昏迷时长
		s ventuseddura = arr.GetAt("HDSD00.12.923") // 呼吸机使用时长
		s (day,hour,min) = "0"
		if (ventuseddura<24)
		{
			s day=0
			s hour=$P(ventuseddura,".",1)
			s min=(ventuseddura*60)-(hour*60)
			s min = $P(min,".",1)
		}
		else
		{
			s day=ventuseddura\24
			s hour=$P((ventuseddura#24),".",1)
			s min=((ventuseddura#24)-hour)*60
			s min = $P(min,".",1)
		}
		s ventuseddura = day_"/"_hour_"/"_min
		
		s cnfmdate = arr.GetAt("HDSD00.12.096") // 确诊日期
		s cnfmdate = ..ConvertStandDate(cnfmdate)
		
		s patndisediagcrsp = "" // 患者疾病诊断对照
		s patndisediagcrspcode = "" // 住院患者疾病诊断对照代码
		s iptpatndiaginscp = "" // 住院患者诊断符合情况
		s iptpatndiaginscpcode = "" // 住院患者诊断符合情况代码
		s dscgtrtrslt = ..GetDscgTrtRslt(AEpisodeID,"DESC") // 出院治疗结果
		s dscgtrtrsltcode = ..GetDscgTrtRslt(AEpisodeID,"CODE") // 出院治疗结果代码
		//s age = arr.GetAt("HDSD00.12.079") // 年龄
		s age=##class(INSU.BL.Interface.DataRpUp).GetAdmAge(AEpisodeID,"","4401")
		
		s aise = $P(..GetAise(AEpisodeID),"^",2) // 过敏源
		s poteintndrname = arr.GetAt("HDSD00.12.100") // 研究生实习医师姓名
		s hbsag = ..GetLisData(AEpisodeID,"HBSAG") // 乙肝表面抗原（HbsAg）
		s hcvab = ..GetLisData(AEpisodeID,"HCVAB") // 丙型肝炎抗体（HCVAb）
		s hivab = ..GetLisData(AEpisodeID,"HIVAB") // 艾滋病毒抗体（hivab）
		s resccnt = arr.GetAt("HDSD00.12.569") // 抢救次数
		s rescsucccnt = arr.GetAt("HDSD00.12.570") // 抢救成功次数
		s hospdisefsttime = "" // 手术、治疗、检查、诊断为本院第一例
		s hifpaywayname = "" // 医保基金付费方式名称
		s hifpaywaycode = "" // 医保基金付费方式代码
		s medfeepaymtdname = arr.GetAt("HDSD00.12.585") // 医疗费用支付方式名称
		s medfeepaymtdcode = arr.GetAt("HDSD00.12.132") // 医疗费用支付方式代码
		
		s arrFee = ##Class(%ArrayOfDataTypes).%New()
		s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(AEpisodeID)
		if (InPatFee'="异常信息:总费用与费用类汇总数额不符，请验证接口后使用")
		{
			s Count=$l(InPatFee,"!")
			f i=1:1:Count 
			{
				s tmpFee=$p(InPatFee,"!",i)
				s FeeType=$p(tmpFee,"^",2)
				s FeeNum=$p(tmpFee,"^",3)
				d arrFee.SetAt(FeeNum,FeeType)
			}
			s medfeesumamt = arrFee.GetAt("总费用")
			s selfpayamt = arrFee.GetAt("自付金额")
			s ordnmedservfee = arrFee.GetAt("一般医疗服务费")+arrFee.GetAt("中医辨证论治费")+arrFee.GetAt("中医辨证论治会诊费")
			s ordntrtoprtfee = arrFee.GetAt("一般治疗操作费")
			s nursfee = arrFee.GetAt("护理费")
			s commedservothfee = arrFee.GetAt("其他费")
			s palgdiagfee = arrFee.GetAt("病理诊断费")
			s labdiagfee = arrFee.GetAt("实验室诊断费")
			s rdhydiagfee = arrFee.GetAt("影像学诊断费")
			s clncdisefee = arrFee.GetAt("临床诊断项目费")
			s nsrgtrtitemfee = $FN(arrFee.GetAt("非手术治疗项目费")+arrFee.GetAt("临床诊断项目费"),"",2)
			s clncphystrtfee = arrFee.GetAt("临床物理治疗费")
			s anstfee = arrFee.GetAt("麻醉费")
			s oprnfee = arrFee.GetAt("手术费")
			s rgtrttrtfee = $FN(arrFee.GetAt("手术治疗费")+arrFee.GetAt("麻醉费")+arrFee.GetAt("手术费"),"",2)
			s rhabfee = arrFee.GetAt("康复费")
			s tcmtrtfee = arrFee.GetAt("中医治疗费")+arrFee.GetAt("中医诊断费")+arrFee.GetAt("中医外治费")+arrFee.GetAt("中医骨伤费")+arrFee.GetAt("针刺与灸法费")+arrFee.GetAt("中医推拿治疗费")+arrFee.GetAt("中医肛肠治疗费")+arrFee.GetAt("中医特殊治疗费")+arrFee.GetAt("中医其他费")+arrFee.GetAt("中医特殊调配加工费")+arrFee.GetAt("辩证施膳费")
			s abtlmednfee = arrFee.GetAt("抗菌药物费")
			s wmfee = $FN(arrFee.GetAt("西药费")+arrFee.GetAt("抗菌药物费"),"",2)
			s tcmpatfee = arrFee.GetAt("中成药费")+arrFee.GetAt("医疗机构中药制剂费")
			s tcmherbfee = arrFee.GetAt("中草药费")
			s blofee = arrFee.GetAt("血费")
			s albufee = arrFee.GetAt("白蛋白类制品费")
			s glonfee = arrFee.GetAt("球蛋白类制品费")
			s clotfacfee = arrFee.GetAt("凝血因子类制品费")
			s cykifee = arrFee.GetAt("细胞因子类制品费")
			s examdspomatlfee = arrFee.GetAt("检查用一次性医用材料费")
			s trtdspomatlfee = arrFee.GetAt("治疗用一次性医用材料费")
			s oprndspomatlfee = arrFee.GetAt("手术用一次性医用材料费")
			s othfee = arrFee.GetAt("其他费用")
		}
		s valiflag = "Y" // 有效标志 必填
		
		set ^CacheTemp(repid, ind) = $LB(mdtrtsn,mdtrtid,psnno,patniptcnt,iptno,medcasno,psnname,gend,brdy,ntly,ntlyname,nwbbirwt,nwbadmwt,birplc,napl,natyname,naty,certno,prfs,mrgstas,curraddrposcode,curraddr,psntel,resdaddrprov,resdaddrcity,resdaddrcoty,resdaddrsubd,resdaddrvil,resdaddrhousnum,resdaddrposcode,resdaddr,emprtel,emprposcode,empraddr,conertel,conername,coneraddr,conerrltscode,admwayname,admwaycode,trttypename,trttype,admcaty,admward,admdate,dscgdate,dscgcaty,Refldeptcatyname,dscgward,iptdays,drugdicmflag,dicmdrugname,dieautpflag,abocode,aboname,rhcode,rhname,dieflag,deptdrtname,chfdrname,atddrname,chfpdrname,iptdrname,respnursname,traindrname,intndrname,codrname,qltctrldrname,qltctrlnursname,medcasqltname,medcasqltcode,qltctrldate,dscgwayname,dscgway,acpmedinscode,acpmedinsname,dscg31daysrinpflag,dscg31daysrinppup,damgintxextrea,damgintxextreadisecode,brndamgbfadmcomadura,brndamgafadmcomadura,ventuseddura,cnfmdate,patndisediagcrsp,patndisediagcrspcode,iptpatndiaginscp,iptpatndiaginscpcode,dscgtrtrslt,dscgtrtrsltcode,medinsorgcode,age,aise,poteintndrname,hbsag,hcvab,hivab,resccnt,rescsucccnt,hospdisefsttime,hifpaywayname,hifpaywaycode,medfeepaymtdname,medfeepaymtdcode,selfpayamt,medfeesumamt,ordnmedservfee,ordntrtoprtfee,nursfee,commedservothfee,palgdiagfee,labdiagfee,rdhydiagfee,clncdisefee,nsrgtrtitemfee,clncphystrtfee,rgtrttrtfee,anstfee,oprnfee,rhabfee,tcmtrtfee,wmfee,abtlmednfee,tcmpatfee,tcmherbfee,blofee,albufee,glonfee,clotfacfee,cykifee,examdspomatlfee,trtdspomatlfee,oprndspomatlfee,othfee,valiflag,fixmedinscode)
		set ind = ind + 1
	}
    
	Quit $$$OK
}

ClassMethod baseinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = baseinfoExecute ]
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

ClassMethod baseinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = baseinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		住院病案首页诊断信息（diseinfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","diseinfo","510")
Query diseinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "palg_no,ipt_patn_disediag_type_code,disediag_type,maindiag_flag,diag_code,diag_name,inhosp_diag_code,inhosp_diag_name,adm_dise_cond_name,adm_dise_cond_code,adm_cond,adm_cond_code,high_diag_evid,bkup_deg,bkup_deg_code,vali_flag,ipt_medcas_hmpg_sn,mdtrt_sn,fixmedins_code") [ SqlProc ]
{
}

ClassMethod diseinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (palgno,iptpatndisediagtypecode,disediagtype,maindiagflag,diagcode,diagname,inhospdiagcode,inhospdiagname,admdisecondname,admdisecondcode,admcond,admcondcode,highdiagevid,bkupdeg,bkupdegcode,valiflag,iptmedcashmpgsn,mdtrtsn) = ""
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	if ($IsObject(ExpDataAry))
    {
		s mdtrtsn = ExpDataAry.GetAt("mdtrt_sn")  // 就医流水号
		s fixmedinscode = ExpDataAry.GetAt("fixmedins_code") //定点医药机构编号
    }
    
    if (InstanceID'="")
    {
		// 取病案首页数据
		s ALLDiagInfo = ..GetDisDiagose(AEpisodeID)
		s ALLDiagCode = $P(ALLDiagInfo,$C(1),1)
		s ALLDiagDesc = $P(ALLDiagInfo,$C(1),2)
		s ALLAdmCondtionCode = $P(ALLDiagInfo,$C(1),3)
		s ALLAdmCondtionDesc = $P(ALLDiagInfo,$C(1),4)
		For iDiag = 1:1:$L(ALLDiagDesc,"^")
		{
			s DiagCode = $P(ALLDiagCode,"^",iDiag)
			continue:(DiagCode="")||(DiagCode="-")
			
			s DiagDesc = $P(ALLDiagDesc,"^",iDiag)
			s ICUDiagInfo = ..GetINSUDiagInfo(AEpisodeID,DiagCode)
			s INSUDiagCode = $P(ICUDiagInfo,"^",1)
			s INSUDiagDesc = $P(ICUDiagInfo,"^",2)
			s AdmCondtionCode = $P(ALLAdmCondtionCode,"^",iDiag)
			s AdmCondtionDesc = $P(ALLAdmCondtionDesc,"^",iDiag)
			s palgno = ##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.008","0")
			
			if (iDiag=1)
			{
				s iptpatndisediagtypecode = "12" // 住院患者疾病诊断类型代码
				s disediagtype = "主要诊断" // 疾病诊断类型
				s maindiagflag = "1" // 主诊断标志
			}
			else
			{
				s iptpatndisediagtypecode = "13" // 住院患者疾病诊断类型代码
				s disediagtype = "次要诊断" // 疾病诊断类型
				s maindiagflag = "0" // 主诊断标志	
			}
			s diagcode = INSUDiagCode // 诊断代码
			s diagname = INSUDiagDesc // 诊断名称
			s inhospdiagcode = DiagCode // 院内诊断代码
			s inhospdiagname = DiagDesc // 院内诊断名称
			s admdisecondname = AdmCondtionDesc // 入院疾病病情名称
			s admdisecondcode = AdmCondtionCode // 入院疾病病情代码
			s admcond = AdmCondtionDesc // 入院病情
			s admcondcode = AdmCondtionCode // 入院时病情代码
			s highdiagevid = "-" // 最高诊断依据
			s bkupdeg = "-" // 分化程度
			s bkupdegcode = "-" // 分化程度代码
			s valiflag = "Y" // 有效标志
			s iptmedcashmpgsn = InstanceID_"||"_iDiag // 住院病案首页流水号
			
			set ^CacheTemp(repid, ind) = $LB(palgno,iptpatndisediagtypecode,disediagtype,maindiagflag,diagcode,diagname,inhospdiagcode,inhospdiagname,admdisecondname,admdisecondcode,admcond,admcondcode,highdiagevid,bkupdeg,bkupdegcode,valiflag,iptmedcashmpgsn,mdtrtsn,fixmedinscode)
			set ind = ind + 1
		}
    }
    elseif (ZYInstanceID'="")
    {
		// 取病案首页数据
		s ALLDiagInfo = ..GetZYDisDiagoseInfo(AEpisodeID)
		s ALLDiagCode = $P(ALLDiagInfo,$C(1),1)_"^"_$P(ALLDiagInfo,$C(1),7)
		s ALLDiagDesc = $P(ALLDiagInfo,$C(1),2)_"^"_$P(ALLDiagInfo,$C(1),8)
		s ALLAdmCondtionCode = $P(ALLDiagInfo,$C(1),3)_"^"_$P(ALLDiagInfo,$C(1),9)
		s ALLAdmCondtionDesc = $P(ALLDiagInfo,$C(1),4)_"^"_$P(ALLDiagInfo,$C(1),10)
		For iDiag = 1:1:$L(ALLDiagDesc,"^")
		{
			s DiagCode = $P(ALLDiagCode,"^",iDiag)
			continue:(DiagCode="")||(DiagCode="-")
			
			s DiagDesc = $P(ALLDiagDesc,"^",iDiag)
			s ICUDiagInfo = ..GetINSUDiagInfo(AEpisodeID,DiagCode)
			s INSUDiagCode = $P(ICUDiagInfo,"^",1)
			s INSUDiagDesc = $P(ICUDiagInfo,"^",2)
			s AdmCondtionCode = $P(ALLAdmCondtionCode,"^",iDiag)
			s AdmCondtionDesc = $P(ALLAdmCondtionDesc,"^",iDiag)
			s palgno = ##class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.009","0")
			
			if (iDiag=1)
			{
				s iptpatndisediagtypecode = "12" // 住院患者疾病诊断类型代码
				s disediagtype = "主要诊断" // 疾病诊断类型
				s maindiagflag = "1" // 主诊断标志
			}
			else
			{
				s iptpatndisediagtypecode = "13" // 住院患者疾病诊断类型代码
				s disediagtype = "次要诊断" // 疾病诊断类型
				s maindiagflag = "0" // 主诊断标志	
			}
			s diagcode = INSUDiagCode // 诊断代码
			s diagname = INSUDiagDesc // 诊断名称
			s inhospdiagcode = DiagCode // 院内诊断代码
			s inhospdiagname = DiagDesc // 院内诊断名称
			s admdisecondname = AdmCondtionDesc // 入院疾病病情名称
			s admdisecondcode = AdmCondtionCode // 入院疾病病情代码
			s admcond = AdmCondtionDesc // 入院病情
			s admcondcode = AdmCondtionCode // 入院时病情代码
			s highdiagevid = "-" // 最高诊断依据
			s bkupdeg = "-" // 分化程度
			s bkupdegcode = "-" // 分化程度代码
			s valiflag = "Y" // 有效标志
			s iptmedcashmpgsn = InstanceID // 住院病案首页流水号
			
			set ^CacheTemp(repid, ind) = $LB(palgno,iptpatndisediagtypecode,disediagtype,maindiagflag,diagcode,diagname,inhospdiagcode,inhospdiagname,admdisecondname,admdisecondcode,admcond,admcondcode,highdiagevid,bkupdeg,bkupdegcode,valiflag,iptmedcashmpgsn,mdtrtsn,fixmedinscode)
			set ind = ind + 1
		} 
	}
	
	Quit $$$OK
}

ClassMethod diseinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = diseinfoExecute ]
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

ClassMethod diseinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = diseinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		住院病案首页手术信息（oprninfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","oprninfo","1902")
Query oprninfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "oprn_oprt_date,oprn_oprt_name,oprn_oprt_code,oprn_oprt_sn,oprn_lv_code,oprn_lv_name,oper_name,asit1_name,asit2_name,sinc_heal_lv,sinc_heal_lv_code,anst_mtd_name,anst_mtd_code,anst_dr_name,OpsId,vali_flag,ipt_medcas_hmpg_sn,mdtrt_sn") [ SqlProc ]
{
}

ClassMethod oprninfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (oprnoprtdate,oprnoprtname,oprnoprtcode,oprnoprtsn,oprnlvcode,oprnlvname,opername,asit1name,asit2name,sincheallv,sincheallvcode,anstmtdname,anstmtdcode,anstdrname,OpsId,valiflag,iptmedcashmpgsn,mdtrtsn) = ""
	
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	
	if ($IsObject(ExpDataAry))
    {
		s mdtrtsn =  ExpDataAry.GetAt("mdtrt_sn") // 就医流水号
    }
    
    if (InstanceID'="")
    {
		/// OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
		/// 手术及操作编码_$C(1)_手术及操作名称_$C(1)_手术操作日期时间_$C(1)_手术级别代码_$C(1)_手术级别描述_$C(1)_手术切口类别代码_$C(1)_手术切口类别描述_$C(1)_切口愈合等级代码_$C(1)_切口愈合等级描述_$C(1)_手术者代码_$C(1)_手术者姓名_$C(1)_Ⅰ助代码_$C(1)_Ⅰ助姓名_$C(1)_Ⅱ助代码_$C(1)_Ⅱ助姓名_$C(1)_麻醉方式代码_$C(1)_麻醉方式描述_$C(1)_麻醉医师姓名
		s ALLOperInfo = ..GetFirstOperInfo(AEpisodeID)
		s ALLOperCode = $P(ALLOperInfo,$C(1),1)
		s ALLOperDesc = $P(ALLOperInfo,$C(1),2)
		s ALLOperDate = $P(ALLOperInfo,$C(1),3)
		s ALLOperLevelCode = $P(ALLOperInfo,$C(1),4)
		s ALLOperLevelDesc = $P(ALLOperInfo,$C(1),5)
		s ALLOperCutCode = $P(ALLOperInfo,$C(1),6)
		s ALLOperCutDesc = $P(ALLOperInfo,$C(1),7)
		s ALLCutHealCode = $P(ALLOperInfo,$C(1),8)
		s ALLCutHealDesc = $P(ALLOperInfo,$C(1),9)
		s ALLOperDocCode = $P(ALLOperInfo,$C(1),10)
		s ALLOperDoc = $P(ALLOperInfo,$C(1),11)
		s ALLFirstAssCode = $P(ALLOperInfo,$C(1),12)
		s ALLFirstAss = $P(ALLOperInfo,$C(1),13)
		s ALLSecondAssCode = $P(ALLOperInfo,$C(1),14)
		s ALLSecondAss = $P(ALLOperInfo,$C(1),15)
		s ALLAnamethodCode = $P(ALLOperInfo,$C(1),16)
		s ALLAnamethodDesc = $P(ALLOperInfo,$C(1),17)
		s ALLAnaDoc = $P(ALLOperInfo,$C(1),18)
		s ALLOpsId = $P(ALLOperInfo,$C(1),19)
		For iOper = 1:1:$L(ALLOperDesc,"^")
		{
			s OperCode = $P(ALLOperCode,"^",iOper)
			continue:(OperCode="")||(OperCode="-")
			
			s OperDesc = $P(ALLOperDesc,"^",iOper)
			s INSUOperInfo = ..GetINSUOperInfo(AEpisodeID,OperCode)
			s OperCode = $P(INSUOperInfo,"^",1)
			s OperDesc = $P(INSUOperInfo,"^",2)
			
			s OperDate = $P(ALLOperDate,"^",iOper)
			s OperLevelCode = $P(ALLOperLevelCode,"^",iOper)
			s OperLevelDesc = $P(ALLOperLevelDesc,"^",iOper)
			s OperCutCode = $P(ALLOperCutCode,"^",iOper)
			s OperCutDesc = $P(ALLOperCutDesc,"^",iOper)
			s CutHealCode = $P(ALLCutHealCode,"^",iOper)
			s CutHealDesc = $P(ALLCutHealDesc,"^",iOper)
			s OperDocCode = $P(ALLOperDocCode,"^",iOper)
			s OperDoc = $P(ALLOperDoc,"^",iOper)
			s FirstAssCode = $P(ALLFirstAssCode,"^",iOper)
			s FirstAss = $P(ALLFirstAss,"^",iOper)
			s SecondAssCode = $P(ALLSecondAssCode,"^",iOper)
			s SecondAss = $P(ALLSecondAss,"^",iOper)
			s AnamethodCode = $P(ALLAnamethodCode,"^",iOper)
			s AnamethodDesc = $P(ALLAnamethodDesc,"^",iOper)
			s AnaDoc = $P(ALLAnaDoc,"^",iOper)
			s OpsId = $P(ALLOpsId,"^",iOper)
			
			s oprnoprtdate = OperDate // 手术操作日期
			s oprnoprtname = OperDesc // 手术操作名称
			s oprnoprtcode = OperCode // 手术操作代码
			s oprnoprtsn = iOper // 手术操作序列号
			s oprnlvcode = OperLevelCode // 手术级别代码
			s oprnlvname = OperLevelDesc // 手术级别名称
			s opername = OperDoc // 手术者姓名
			s asit1name = FirstAss // 助手Ⅰ姓名
			s asit2name = SecondAss // 助手Ⅱ姓名
			s sincheallv = CutHealDesc // 手术切口愈合等级
			s sincheallvcode = CutHealCode // 手术切口愈合等级代码
			s anstmtdname = AnamethodDesc // 麻醉-方法名称
			s anstmtdcode = AnamethodCode // 麻醉-方法代码
			s anstdrname = AnaDoc // 麻醉医师姓名
			if (iOper=1)
			{
				s mainoprnflag = "1" // 主要手术标志
			}
			else
			{
				s mainoprnflag = "0" // 主要手术标志
			}
			
			// 手术ID
			s OpsId = OpsId
			
			s valiflag = "Y" // 有效标志
			s iptmedcashmpgsn = InstanceID // 住院病案首页流水号
			
			set ^CacheTemp(repid, ind) = $LB(oprnoprtdate,oprnoprtname,oprnoprtcode,oprnoprtsn,oprnlvcode,oprnlvname,opername,asit1name,asit2name,sincheallv,sincheallvcode,anstmtdname,anstmtdcode,anstdrname,OpsId,valiflag,iptmedcashmpgsn,mdtrtsn)
			set ind = ind + 1
		}
    }
    elseif (ZYInstanceID'="")
    {
		/// OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
		/// 手术及操作编码_$C(1)_手术及操作名称_$C(1)_手术操作日期时间_$C(1)_手术级别代码_$C(1)_手术级别描述_$C(1)_手术切口类别代码_$C(1)_手术切口类别描述_$C(1)_切口愈合等级代码_$C(1)_切口愈合等级描述_$C(1)_手术者代码_$C(1)_手术者姓名_$C(1)_Ⅰ助代码_$C(1)_Ⅰ助姓名_$C(1)_Ⅱ助代码_$C(1)_Ⅱ助姓名_$C(1)_麻醉方式代码_$C(1)_麻醉方式描述_$C(1)_麻醉医师姓名
		s ALLOperInfo = ..GetZYFirstOperInfo(AEpisodeID)
		s ALLOperCode = $P(ALLOperInfo,$C(1),1)
		s ALLOperDesc = $P(ALLOperInfo,$C(1),2)
		s ALLOperDate = $P(ALLOperInfo,$C(1),3)
		s ALLOperLevelCode = $P(ALLOperInfo,$C(1),4)
		s ALLOperLevelDesc = $P(ALLOperInfo,$C(1),5)
		s ALLOperCutCode = $P(ALLOperInfo,$C(1),6)
		s ALLOperCutDesc = $P(ALLOperInfo,$C(1),7)
		s ALLCutHealCode = $P(ALLOperInfo,$C(1),8)
		s ALLCutHealDesc = $P(ALLOperInfo,$C(1),9)
		s ALLOperDocCode = $P(ALLOperInfo,$C(1),10)
		s ALLOperDoc = $P(ALLOperInfo,$C(1),11)
		s ALLFirstAssCode = $P(ALLOperInfo,$C(1),12)
		s ALLFirstAss = $P(ALLOperInfo,$C(1),13)
		s ALLSecondAssCode = $P(ALLOperInfo,$C(1),14)
		s ALLSecondAss = $P(ALLOperInfo,$C(1),15)
		s ALLAnamethodCode = $P(ALLOperInfo,$C(1),16)
		s ALLAnamethodDesc = $P(ALLOperInfo,$C(1),17)
		s ALLAnaDoc = $P(ALLOperInfo,$C(1),18)
		s ALLOpsId = $P(ALLOperInfo,$C(1),19)
		For iOper = 1:1:$L(ALLOperDesc,"^")
		{
			s OperCode = $P(ALLOperCode,"^",iOper)
			continue:(OperCode="")||(OperCode="-")
			
			s OperDesc = $P(ALLOperDesc,"^",iOper)
			s INSUOperInfo = ..GetINSUOperInfo(AEpisodeID,OperCode)
			s OperCode = $P(INSUOperInfo,"^",1)
			s OperDesc = $P(INSUOperInfo,"^",2)
			
			s OperDate = $P(ALLOperDate,"^",iOper)
			s OperLevelCode = $P(ALLOperLevelCode,"^",iOper)
			s OperLevelDesc = $P(ALLOperLevelDesc,"^",iOper)
			s OperCutCode = $P(ALLOperCutCode,"^",iOper)
			s OperCutDesc = $P(ALLOperCutDesc,"^",iOper)
			s CutHealCode = $P(ALLCutHealCode,"^",iOper)
			s CutHealDesc = $P(ALLCutHealDesc,"^",iOper)
			s OperDocCode = $P(ALLOperDocCode,"^",iOper)
			s OperDoc = $P(ALLOperDoc,"^",iOper)
			s FirstAssCode = $P(ALLFirstAssCode,"^",iOper)
			s FirstAss = $P(ALLFirstAss,"^",iOper)
			s SecondAssCode = $P(ALLSecondAssCode,"^",iOper)
			s SecondAss = $P(ALLSecondAss,"^",iOper)
			s AnamethodCode = $P(ALLAnamethodCode,"^",iOper)
			s AnamethodDesc = $P(ALLAnamethodDesc,"^",iOper)
			s AnaDoc = $P(ALLAnaDoc,"^",iOper)
			s OpsId = $P(ALLOpsId,"^",iOper)
			
			s oprnoprtdate = OperDate // 手术操作日期
			s oprnoprtname = OperDesc // 手术操作名称
			s oprnoprtcode = OperCode // 手术操作代码
			s oprnoprtsn = iOper // 手术操作序列号
			s oprnlvcode = OperLevelCode // 手术级别代码
			s oprnlvname = OperLevelDesc // 手术级别名称
			s opername = OperDoc // 手术者姓名
			s asit1name = FirstAss // 助手Ⅰ姓名
			s asit2name = SecondAss // 助手Ⅱ姓名
			s sincheallv = CutHealDesc // 手术切口愈合等级
			s sincheallvcode = CutHealCode // 手术切口愈合等级代码
			s anstmtdname = AnamethodDesc // 麻醉-方法名称
			s anstmtdcode = AnamethodCode // 麻醉-方法代码
			s anstdrname = AnaDoc // 麻醉医师姓名
			if (iOper=1)
			{
				s mainoprnflag = "1" // 主要手术标志
			}
			else
			{
				s mainoprnflag = "0" // 主要手术标志
			}
			
			// 手术ID
			s OpsId = OpsId
			
			s valiflag = "Y" // 有效标志
			s iptmedcashmpgsn = InstanceID // 住院病案首页流水号
			
			set ^CacheTemp(repid, ind) = $LB(oprnoprtdate,oprnoprtname,oprnoprtcode,oprnoprtsn,oprnlvcode,oprnlvname,opername,asit1name,asit2name,sincheallv,sincheallvcode,anstmtdname,anstmtdcode,anstdrname,OpsId,valiflag,iptmedcashmpgsn,mdtrtsn)
			set ind = ind + 1
		}   
	}
	
	Quit $$$OK
}

ClassMethod oprninfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = oprninfoExecute ]
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

ClassMethod oprninfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = oprninfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Creator：	YK
/// CreateDate：2021-04-29
/// Desc：		住院病案首页185 输入-重症监护信息（节点标识：icuinfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","icuinfo","1902")
Query icuinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "icu_code,inpool_icu_time,out_icu_time,medins_orgcode,nurscare_lv_code,nurscare_lv_name,nurscare_days,back_icu,vali_flag,ipt_medcas_hmpg_sn,mdtrt_sn,fixmedins_code") [ SqlProc ]
{
}

ClassMethod icuinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.11")
	s InstanceID = $P(InstanceID,"^",1)
	// 兼容中医病案首页
	s ZYInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.12")
	s ZYInstanceID = $P(ZYInstanceID,"^",1)
	q:(InstanceID="")&&(ZYInstanceID="") $$$OK
	
	// 初始化字段
	s (icucode,inpoolicutime,outicutime,medinsorgcode,nurscarelvcode,nurscarelvname,nurscaredays,backicu,valiflag,iptmedcashmpgsn,mdtrtsn) = ""
	
	if ($IsObject(ExpDataAry))
    {
		s medinsorgcode = ExpDataAry.GetAt("medins_orgcode")  // 医疗机构组织机构代码
		s mdtrtsn =  ExpDataAry.GetAt("mdtrt_sn")  // 就医流水号
		s fixmedinscode= ExpDataAry.GetAt("fixmedins_code") //定点医药机构编号
    }
    
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	s IPRecordNo = ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID)
	
	if (InstanceID'="")
	{
		s ALLICUInfo=""
		s ALLICUInfo = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.546","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.547","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.548","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.549","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.550","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.551","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.552","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.553","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.11.554","0")
	}
	elseif (ZYInstanceID'="")
	{
		s ALLICUInfo=""
		s ALLICUInfo = ##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.546","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.547","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.548","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.549","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.550","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.551","0")
		s ALLICUInfo = ALLICUInfo_"!"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.552","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.553","0")
		s ALLICUInfo = ALLICUInfo_"^"_##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(AEpisodeID,"HDSD00.12.554","0")
	}
	For iICU = 1:1:$L(ALLICUInfo,"!")
	{
		s icucode = $P($P(ALLICUInfo,"!",iICU),"^",1) // 重症监护室代码
		continue:(icucode="")||(icucode="-")
		
		s inpoolicutime = $TR($TR($TR($P($P(ALLICUInfo,"!",iICU),"^",2),"年","-"),"月","-"),"日","") // 进入监护室时间
		s outicutime = $TR($TR($TR($P($P(ALLICUInfo,"!",iICU),"^",3),"年","-"),"月","-"),"日","") // 退出监护室时间
		
		s ALLCareDays = ##Class(Nur.Interface.OutSide.Med.Order).GetCareDays(AEpisodeID)
		s Length = $L(ALLCareDays,"^")
		For iCare = 1:1:Length
		{
			s CareDay = $P(ALLCareDays,"^",iCare)
			continue:($P(CareDay,"|",2)=0)
			
			s nurscarelvname = $P(CareDay,"|",1) // 护理等级名称
			s:(nurscarelvname="特级护理") nurscarelvcode = "1" // 护理等级代码
			s:(nurscarelvname="一级护理") nurscarelvcode = "2" // 护理等级代码
			s:(nurscarelvname="二级护理") nurscarelvcode = "3" // 护理等级代码
			s:(nurscarelvname="三级护理") nurscarelvcode = "4" // 护理等级代码
			s nurscaredays = $P(CareDay,"|",2) // 护理天数
		}
		
		s backicu = "" // 重返重症监护室标志
		s valiflag = "Y" // 有效标志
		s iptmedcashmpgsn = InstanceID_"||"_iICU // 住院病案首页流水号
		
		set ^CacheTemp(repid, ind) = $LB(icucode,inpoolicutime,outicutime,medinsorgcode,nurscarelvcode,nurscarelvname,nurscaredays,backicu,valiflag,iptmedcashmpgsn,mdtrtsn,fixmedinscode)
		set ind = ind + 1
	}
	
	Quit $$$OK
}

ClassMethod icuinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = icuinfoExecute ]
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

ClassMethod icuinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = icuinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 【----------住院病案首页信息[4401]信息----------】
/// 【----------电子病历上传信息[4701]信息----------】
/// 入院记录
/// Desc:		入院信息（节点标识：adminfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","adminfo","1902")
Query adminfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_sn,mdtrt_id,psn_no,mdtrtsn,name,gend,age,adm_rec_no,wardarea_name,dept_code,dept_name,bedno,adm_time,illhis_stte_name,illhis_stte_rltl,stte_rele,chfcomp,dise_now,hlcon,dise_his,ifet,ifet_his,prev_vcnt,oprn_his,bld_his,algs_his,psn_his,mrg_his,mena_his,fmhis,physexm_tprt,physexm_pule,physexm_vent_frqu,physexm_systolic_pre,physexm_dstl_pre,physexm_height,physexm_wt,physexm_ordn_stas,physexm_skin_musl,physexm_spef_lymph,physexm_head,physexm_neck,physexm_chst,physexm_abd,physexm_finger_exam,physexm_genital_area,physexm_spin,physexm_all_fors,nersys,spcy_info,asst_exam_rslt,tcm4d_rslt,syddclft,syddclft_name,prnp_trt,rec_doc_code,rec_doc_name,ipdr_code,ipdr_name,chfdr_code,chfdr_name,chfpdr_code,chfpdr_name,main_symp,adm_rea,adm_way,apgr,diet_info,growth_deg,mtl_stas_norm,slep_info,sp_info,mind_info,nurt,self_ablt,nurscare_obsv_item_name,nurscare_obsv_rslt,smoke,stop_smok_days,smok_info,smok_day,drnk,drnk_frqu,drnk_day,eval_time,resp_nurs_name,vali_flag") [ SqlProc ]
{
}

ClassMethod adminfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.13.01")
	s InstanceID = $P(InstanceID,"^",1)
	q:(InstanceID="") $$$OK
	
	if ($IsObject(ExpDataAry))
    {
		s mdtrtsn= ExpDataAry.GetAt("mdtrt_id") // 就医流水号
		s mdtrtid= AEpisodeID // 就诊ID
		s psnno= ExpDataAry.GetAt("psn_no") // 人员编号
    }
    
	// 登记RowId
 	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
 	
 	s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.13.01")
	s mdtrtsn= ##class(EMRservice.HISInterface.PatientInfoAssist).IPRecordNoInfo(AEpisodeID) // 住院号
	s name= ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(PapmiDR) // 姓名
	s gend= ##Class(EMRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR,"") // 性别
	if (gend'="") 
	{
		s gend = $p(gend,"^",3)
	}
	//s age= $P(arr.GetAt("HDSD00.13.047"),"岁",1) // 年龄
	s age=##class(INSU.BL.Interface.DataRpUp).GetAdmAge(AEpisodeID,"","4701")
	s admrecno= InstanceID // 入院记录流水号
	
	s tmpAdmWard = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmWard(AEpisodeID,"")
	s wardareaname = $p($g(tmpAdmWard),"^",3) // 病区名称
	
	s deptcode= "" // 科室代码
	s deptname= "" // 科室名称
	s tmpAdmDept=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDept(AEpisodeID,"")
	i tmpAdmDept'=""
 	{
        s deptcode = $p($g(tmpAdmDept),"^",2)   ;科室代码
   		s deptname = $p($g(tmpAdmDept),"^",3)  ; 科室名称
 	}
 	s bedno= ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(AEpisodeID) // 病床号
 	
 	s AdmDateTimeInBed=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),",",1),3)
		s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),",",2),1)
		s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed
	} 
	s admtime= AdmDateTimeInBed // 入院时间
	s illhissttename= arr.GetAt("HDSD00.13.004") // 病史陈述者姓名
	s illhisstterltl= arr.GetAt("HDSD00.13.009") // 陈述者与患者关系代码
	s stterele= arr.GetAt("HDSD00.13.008") // 陈述内容是否可靠标识
	s chfcomp= arr.GetAt("HDSD00.13.114") // 主诉
	s disenow= arr.GetAt("HDSD00.13.095")  // 现病史
	s hlcon= arr.GetAt("HDSD00.13.104") // 健康状况
	s disehis= arr.GetAt("HDSD00.13.042") // 疾病史（含外伤）
	s ifet= arr.GetAt("HDSD00.13.038") // 患者传染性标志
	s ifethis= arr.GetAt("HDSD00.13.028") // 传染病史
	s prevvcnt= arr.GetAt("HDSD00.13.105") // 预防接种史
	s oprnhis= arr.GetAt("HDSD00.13.065") // 手术史
	s bldhis= arr.GetAt("HDSD00.13.066") // 输血史
	s algshis= $P(..GetAise(AEpisodeID),"^",2) // 过敏史
	s psnhis= arr.GetAt("HDSD00.13.036") // 个人史
	s mrghis= arr.GetAt("HDSD00.13.041") // 婚育史
	s menahis= arr.GetAt("HDSD00.13.106") // 月经史
	s fmhis= arr.GetAt("HDSD00.13.043") // 家族史
	s physexmtprt= $P(arr.GetAt("HDSD00.13.088"),"℃",1) // 体格检查–体温（℃）
	s physexmpule= $P(arr.GetAt("HDSD00.13.080"),"次",1) // 体格检查 – 脉率（次 /mi数字）
	s physexmventfrqu= arr.GetAt("HDSD00.13.077") // 体格检查–呼吸频率
	s physexmsystolicpre= arr.GetAt("HDSD00.13.085") // 体格检查 – 收缩压 （mmHg）
	s physexmdstlpre= arr.GetAt("HDSD00.13.086") // 体格检查 – 舒张压 （mmHg）
	s physexmheight= arr.GetAt("HDSD00.13.083") // 体格检查–身高（cm）
	s physexmwt= arr.GetAt("HDSD00.13.089") // 体格检查–体重（kg）
	s physexmordnstas= arr.GetAt("HDSD00.13.094") // 体格检查 – 一般状况 检查结果
	s physexmskinmusl= arr.GetAt("HDSD00.13.081") // 体格检查 – 皮肤和黏膜检查结果
	s physexmspeflymph= arr.GetAt("HDSD00.13.082") // 体格检查 – 全身浅表淋巴结检查结果
	s physexmhead= arr.GetAt("HDSD00.13.091") // 体格检查 – 头部及其器官检查结果
	s physexmneck= arr.GetAt("HDSD00.13.079") // 体格检查 – 颈部检查结果
	s physexmchst= arr.GetAt("HDSD00.13.093") // 体格检查 – 胸部检查结果
	s physexmabd= arr.GetAt("HDSD00.13.075") // 体格检查 – 腹部检查结果
	s physexmfingerexam= arr.GetAt("HDSD00.13.076") // 体格检查 -- 肛门指诊检查结果描述
	s physexmgenitalarea= arr.GetAt("HDSD00.13.092") // 体格检查 -- 外生殖器检查结果
	s physexmspin= arr.GetAt("HDSD00.13.078") // 体格检查 -- 脊柱检查结果
	s physexmallfors= arr.GetAt("HDSD00.13.087") // 体格检查 -- 四肢检查结果
	s nersys= arr.GetAt("HDSD00.13.084") // 体格检查 -- 神经系统检查结果
	s spcyinfo= arr.GetAt("HDSD00.13.118") // 专科情况
	s asstexamrslt= arr.GetAt("HDSD00.13.035") // 辅助检查结果
	s tcm4drslt= "-" // 中医“四诊”观察结果描述
	s syddclft= "-" // 辨证分型代码
	s syddclftname= "-" // 辩证分型名称
	s prnptrt= "-" // 治则治法
	
	// 取签名信息
	s ALLSignInfo = ..GetALLSignfInfo(InstanceID)
	s recdoccode= $P($P(ALLSignInfo,"!",1),"^",1) // 接诊医生编号
	s recdocname= $P($P(ALLSignInfo,"!",1),"^",2) // 接诊医生姓名
	s ipdrcode= $P($P(ALLSignInfo,"!",1),"^",1) // 住院医师编号
	s ipdrname= $P($P(ALLSignInfo,"!",1),"^",2) // 住院医师姓名
	s chfdrcode= $P($P(ALLSignInfo,"!",3),"^",1) // 主任医师编号
	s chfdrname= $P($P(ALLSignInfo,"!",3),"^",2) // 主任医师姓名
	
	s chfpdrcode= $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",2) // 主诊医师代码
	s chfpdrname= $p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3) // 主诊医师姓名
	
	s mainsymp= "-" // 主要症状
	s admrea= "-" // 入院原因
	s admway= "-" // 入院途径
	s apgr= "-" // 评分值(Apgar)
	s dietinfo= "-" // 饮食情况
	s growthdeg= "-" // 发育程度
	s mtlstasnorm= "-" // 精神状态正常标志
	s slepinfo= "-" // 睡眠状况
	s spinfo= "-" // 特殊情况
	s mindinfo= "-" // 心理状态
	s nurt= "-" // 营养状态
	s selfablt= "-" // 自理能力
	s nurscareobsvitemname= "-" // 护理观察项目名称
	s nurscareobsvrslt= "-" // 护理观察结果
	s smoke= "-" // 吸烟标志
	s stopsmokdays= "" // 停止吸烟天数
	s smokinfo= "-" // 吸烟状况
	s smokday= "" // 日吸烟量（支）
	s drnk= "-" // 饮酒标志
	s drnkfrqu= "-" // 饮酒频率
	s drnkday= "" // 日饮酒量（mL）
	s evaltime= "" // 评估日期时间
	s respnursname= "-" // 责任护士姓名
	s valiflag= "Y" // 有效标志
	
	set ^CacheTemp(repid, ind) = $LB(mdtrtsn,mdtrtid,psnno,mdtrtsn,name,gend,age,admrecno,wardareaname,deptcode,deptname,bedno,admtime,illhissttename,illhisstterltl,stterele,chfcomp,disenow,hlcon,disehis,ifet,ifethis,prevvcnt,oprnhis,bldhis,algshis,psnhis,mrghis,menahis,fmhis,physexmtprt,physexmpule,physexmventfrqu,physexmsystolicpre,physexmdstlpre,physexmheight,physexmwt,physexmordnstas,physexmskinmusl,physexmspeflymph,physexmhead,physexmneck,physexmchst,physexmabd,physexmfingerexam,physexmgenitalarea,physexmspin,physexmallfors,nersys,spcyinfo,asstexamrslt,tcm4drslt,syddclft,syddclftname,prnptrt,recdoccode,recdocname,ipdrcode,ipdrname,chfdrcode,chfdrname,chfpdrcode,chfpdrname,mainsymp,admrea,admway,apgr,dietinfo,growthdeg,mtlstasnorm,slepinfo,spinfo,mindinfo,nurt,selfablt,nurscareobsvitemname,nurscareobsvrslt,smoke,stopsmokdays,smokinfo,smokday,drnk,drnkfrqu,drnkday,evaltime,respnursname,valiflag)
	set ind = ind + 1
	Quit $$$OK
}

ClassMethod adminfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = adminfoExecute ]
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

ClassMethod adminfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = adminfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

///  
/// Desc:		诊断信息（节点标识：admdiseinfo）
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","admdiseinfo","1902")
Query admdiseinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "inout_diag_type,maindiag_flag,diag_seq,diag_time,wm_diag_code,wm_diag_name,tcm_dise_code,tcm_dise_name,tcmsymp_code,tcmsymp,vali_flag") [ SqlProc ]
{
}

ClassMethod admdiseinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.13.01")
	s InstanceID = $P(InstanceID,"^",1)
	q:(InstanceID="") $$$OK
	
	s MRADMID = $P(^PAADM(AEpisodeID),"^",61)
	s (inoutdiagtype,maindiagflag,diagseq,diagtime,wmdiagcode,wmdiagname,tcmdisecode,tcmdisename,tcmsympcode,tcmsymp,valiflag)=""
	s tmpAdmDiagDict = ..GetMRDiagnoseListForEMR(MRADMID,"","C008")
	s tmpAdmDiagDict = tmpAdmDiagDict_$C(1)_..GetMRDiagnoseListForEMR(MRADMID,"","PRE")
	if (tmpAdmDiagDict'="") 
	{
	  	s AdmDiagLength = $L(tmpAdmDiagDict,$C(1))
		f i = 1:1:AdmDiagLength
		{
			s diag = $p($g(tmpAdmDiagDict),$C(1),i)
			continue:(diag="")
			s DiagnosCat = $p(diag,"^",14)
			s inoutdiagtype = "Y" // 出入院诊断类别
			s maindiagflag = $p(diag,"^",16) // 主诊断标志
			s:(maindiagflag="") maindiagflag="N"
			s diagseq = i // 诊断序列号
			s diagtime = $p(diag,"^",8)_" "_$p(diag,"^",9) // 诊断时间
			if (DiagnosCat = "西医") 
			{
				s wmdiagcode = $p(diag,"^",5) // 西医诊断编码
				s wmdiagname = $p(diag,"^",1) // 西医诊断名称
			}
			else 
			{
				if (DiagnosCat = "中医") 
				{
				    s tcmdisecode = $p(diag,"^",5) // 中医病名代码
			        s tcmdisename = $p(diag,"^",1) // 中医病名
				}
				else 
				{
				    s tcmsympcode = $p(diag,"^",5) // 中医证候代码
			        s tcmsymp = $p(diag,"^",1) // 中医证候
				}
			}
			s valiflag = "Y" // 有效标志
			
			set ^CacheTemp(repid, ind) = $LB(inoutdiagtype,maindiagflag,diagseq,diagtime,wmdiagcode,wmdiagname,tcmdisecode,tcmdisename,tcmsympcode,tcmsymp,valiflag)
			set ind = ind + 1
		}
	}
	
	Quit $$$OK
}

ClassMethod admdiseinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admdiseinfoExecute ]
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

ClassMethod admdiseinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admdiseinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 首次病程记录
/// Desc:		病程记录（节点标识：coursrinfo） 
/// Input:		就诊号：AEpisodeID
/// 			d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","coursrinfo","1902")
Query coursrinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "dept_code,dept_name,wardarea_name,bedno,rcd_time,chfcomp,cas_ftur,tcm4d_rslt,dise_evid,prel_wm_diag_code,prel_wm_dise_name,prel_tcm_diag_code,prel_tcm_dise_name,prel_tcmsymp_code,prel_tcmsymp,finl_wm_diag_code,finl_wm_diag_name,finl_tcm_dise_code,finl_tcm_dise_name,finl_tcmsymp_code,finl_tcmsymp,dise_plan,prnp_trt,ipdr_code,ipdr_name,prnt_doc_name,vali_flag,codse_rcd_id")
{
}

ClassMethod coursrinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.14.01")
	s InstanceID = $P(InstanceID,"^",1)
	q:(InstanceID="") $$$OK
	
	s (deptcode,deptname,wardareaname,bedno,rcdtime,chfcomp,casftur,tcm4drslt,diseevid,prelwmdiagcode,prelwmdisename,preltcmdiagcode,preltcmdisename,preltcmsympcode,preltcmsymp,finlwmdiagcode,finlwmdiagname,finltcmdisecode,finltcmdisename,finltcmsympcode,finltcmsymp,diseplan,prnptrt,ipdrcode,ipdrname,prntdocname,valiflag,codsercdid)=""
	
	s MRADMID = $P(^PAADM(AEpisodeID),"^",61)
	s objinstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.14.01")
	s deptcode = "" // 科室代码
	s deptname = "" // 科室名称
	s tmpAdmDept=##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDept(AEpisodeID,"")
	i tmpAdmDept'=""
 	{
        s deptcode = $p($g(tmpAdmDept),"^",2)   ;科室代码
   		s deptname = $p($g(tmpAdmDept),"^",3)  ; 科室名称
 	}
 	s tmpAdmWard = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmWard(AEpisodeID,"")
	s wardareaname = $p($g(tmpAdmWard),"^",3) // 病区名称
 	s bedno= ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmBed(AEpisodeID) // 病床号
	s rcdtime = $zd(objinstance.HappenDate,3)_" "_$zt(objinstance.HappenTime) // 记录日期时间
	s chfcomp = arr.GetAt("HDSD00.14.137") // 主诉
	s casftur = arr.GetAt("HDSD00.14.005") // 病例特点
	s tcm4drslt = "-" // 中医“四诊”观察结果
	s diseevid = arr.GetAt("HDSD00.14.119") // 诊断依据
	s AdmDiags = ..GetMRDiagnoseListForEMR(MRADMID,"2","C008")
	s AdmDiags = AdmDiags_$C(1)_..GetMRDiagnoseListForEMR(MRADMID,"2","PRE")
	s prelwmdiagcode = $P($P(AdmDiags,$C(1),1),"^",5) // 初步诊断-西医诊断编码
	s prelwmdisename = $P($P(AdmDiags,$C(1),1),"^",1) // 初步诊断-西医诊断名称
	s preltcmdiagcode = "-" // 初步诊断-中医病名代码
	s preltcmdisename = "-" // 初步诊断-中医病名
	s preltcmsympcode = "-" // 初步诊断-中医证候代码
	s preltcmsymp = "-" // 初步诊断-中医证候
	
	s finlwmdiagcode = "-" // 鉴别诊断-西医诊断编码
	s finlwmdiagname = arr.GetAt("HDSD00.14.052") // 鉴别诊断-西医诊断名称
	s finltcmdisecode = "-" // 鉴别诊断-中医病名代码
	s finltcmdisename = "-" // 鉴别诊断-中医病名
	s finltcmsympcode = "-" // 鉴别诊断-中医证候代码
	s finltcmsymp = "-" // 鉴别诊断-中医证候
	s diseplan = arr.GetAt("HDSD00.14.122") // 诊疗计划
	s prnptrt = "-" // 治则治法
	
	s ALLSignInfo = ..GetALLSignfInfo(InstanceID)
	s ipdrcode =  $P($P(ALLSignInfo,"!",1),"^",1) // 住院医师编号
	s ipdrname = $P($P(ALLSignInfo,"!",1),"^",2) // 住院医师姓名
	if (ipdrname="")
	{
		s ipdrcode =  $P($P(ALLSignInfo,"!",2),"^",1) // 住院医师编号
		s ipdrname = $P($P(ALLSignInfo,"!",2),"^",2) // 住院医师姓名
	}
	s prntdocname = $P($P(ALLSignInfo,"!",3),"^",2) // 上级医师姓名
	s:(prntdocname="") prntdocname = $P($P(ALLSignInfo,"!",2),"^",2)
	s valiflag = "Y" // 有效标志
	
	// 病程记录编号
	s codsercdid = $TR(InstanceID,"|","0")
	
    set ^CacheTemp(repid, ind) = $LB(deptcode,deptname,wardareaname,bedno,rcdtime,chfcomp,casftur,tcm4drslt,diseevid,prelwmdiagcode,prelwmdisename,preltcmdiagcode,preltcmdisename,preltcmsympcode,preltcmsymp,finlwmdiagcode,finlwmdiagname,finltcmdisecode,finltcmdisename,finltcmsympcode,finltcmsymp,diseplan,prnptrt,ipdrcode,ipdrname,prntdocname,valiflag,codsercdid)
	set ind = ind + 1
	Quit $$$OK
}

ClassMethod coursrinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = coursrinfoExecute ]
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

ClassMethod coursrinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = coursrinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:		病情抢救记录
/// Input: 		argEpisodeID 就诊号
/// Desc:  		
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","rescinfo","1902")
Query rescinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "dept,dept_name,wardarea_name,bedno,diag_name,diag_code,cond_chg,resc_mes,oprn_oprt_code,oprn_oprt_name,oprn_oper_part,itvt_name,oprt_mtd,oprt_cnt,resc_begntime,resc_endtime,dise_item_name,dise_ccls,dise_ccls_qunt,dise_ccls_code,mnan,resc_psn_list,proftechttl_code,doc_code,dr_name,vali_flag,resc_id")
{
}

ClassMethod rescinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(AEpisodeID = "") $$$OK
	
	s ValidInstanceIDList = ..GetValidInstanceIDList(AEpisodeID,"66^641")
	q:(ValidInstanceIDList="") $$$OK
	for iInstanceID=1:1:$Length(ValidInstanceIDList,"^")
	{
		s InstanceID = $P(ValidInstanceIDList,"^",iInstanceID)
		continue:(InstanceID="")
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId($TR(InstanceID," ",""))
		continue:(objInstance.Title'["抢救记录")
		
		s (docrowid,dept,deptname,wardareaname,bedno,diagname,diagcode,condchg,rescmes,oprnoprtcode,oprnoprtname,oprnoperpart,itvtname,oprtmtd,oprtcnt,rescbegntime,rescendtime,diseitemname,diseccls,disecclsqunt,disecclscode,mnan,rescpsnlist,proftechttlcode,doccode,drname,valiflag,rescid)=""
		
		s deptname=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.062",InstanceID)	//科室名称
		if (deptname'="")
		{
			s (deptrowid,deptcode)=""
			s:deptname'="" deptrowid=$o(^CTLOC(0,"Desc",deptname,""))
			s:deptrowid'="" deptcode=$p($g(^CTLOC(deptrowid)),"^",1)
			s dept=deptcode	//科室代码
		}
		else
		{
			s DisDept = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
			s dept = $P(DisDept,"^",2) //科室代码
			s deptname = $P(DisDept,"^",3) //科室名称
		}
		
		s wardareaname=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.007",InstanceID)	//病区名称
		if (wardareaname="")
		{
			s tmpAdmWard = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisWard(AEpisodeID,"")
			s wardareaname = $p($g(tmpAdmWard),"^",3) // 病区名称
		}
		s bedno=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.002",InstanceID)	//病床号
		s:(bedno="") bedno= ##Class(EMRservice.HISInterface.PatientInfoAssist).DisBed(AEpisodeID) // 病床号
		
		s MRADMID = $P(^PAADM(AEpisodeID),"^",61)
		s AdmDiags = ..GetMRDiagnoseListForEMR(MRADMID,"2","C008")
		s:(AdmDiags="") AdmDiags =  ..GetMRDiagnoseListForEMR(MRADMID,"2","PRE")
		s diagname=$P($P(AdmDiags,$C(1),1),"^",5)	//诊断名称
		s diagcode=$P($P(AdmDiags,$C(1),1),"^",1)	//诊断代码
		
		s condchg=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.006",InstanceID)	//病情变化情况
		s rescmes=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.077",InstanceID)	//抢救措施
		s oprnoprtcode="-"	//手术操作代码
		s oprnoprtname="-"	//手术操作名称
		s oprnoperpart="-"	//手术及操作目标部位名称
		s itvtname="-"	//介入物名称
		s oprtmtd="-"	//操作方法
		s oprtcnt=""	//操作次数
		s rescbegntime=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.079",InstanceID)	//抢救开始日期时间
		s rescbegntime=..ConvertStandDate(rescbegntime)
		s rescendtime=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.078",InstanceID)	//抢救结束日期时间
		s rescendtime=..ConvertStandDate(rescendtime)
		s diseitemname="-"	//检查/检验项目名称
		s diseccls="-"	//检查/检验结果
		s disecclsqunt=""	//检查/检验定量结果
		s disecclscode="-"	//检查/检验结果代码
		s mnan=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.142",InstanceID)	//注意事项
		s rescpsnlist=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(AEpisodeID,"HDSD00.14.008",InstanceID)	//参加抢救人员名单
		s proftechttlcode="-"	//专业技术职务类别代码
		
		s SignInfo = ..GetSignfInfo(InstanceID)
		s drname=$P(SignInfo,"^",2)	//医师姓名
		s doccode=$P(SignInfo,"^",2) //医师编号
		s valiflag="Y"	//有效标志
		
		// 抢救记录编号
		s rescid = $TR(InstanceID,"|","0")
		
		s data = $lb(dept,deptname,wardareaname,bedno,diagname,diagcode,condchg,rescmes,oprnoprtcode,oprnoprtname,oprnoperpart,itvtname,oprtmtd,oprtcnt,rescbegntime,rescendtime,diseitemname,diseccls,disecclsqunt,disecclscode,mnan,rescpsnlist,proftechttlcode,doccode,drname,valiflag,rescid)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 			
	}
		
	Quit $$$OK
}

ClassMethod rescinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = rescinfoExecute ]
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

ClassMethod rescinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = rescinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:		死亡记录
/// Input: 		AEpisodeID 就诊号
/// Output:		
/// Desc:  		死亡记录相关信息
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","dieinfo","47")	
Query dieinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "dept,dept_name,wardarea_name,bedno,adm_time,adm_dise,adm_info,trt_proc_dscr,die_time,die_drt_rea,die_drt_rea_code,die_dise_name,die_diag_code,agre_corp_dset,ipdr_name,chfpdr_code,chfpdr_name,chfdr_name,sign_time,vali_flag")
{
}

ClassMethod dieinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.14.14")
	s InstanceID = $P(InstanceID,"^",1)
	q:(InstanceID="") $$$OK
	
	s (chfpdrrowid,deptrowid,dept,deptname,wardareaname,bedno,admtime,admdise,adminfo,trtprocdscr,dietime,diedrtrea,diedrtreacode,diedisename,diediagcode,agrecorpdset,ipdrname,chfpdrcode,chfpdrname,chfdrname,signtime,valiflag)=""
	
	s MRADMID = $P(^PAADM(AEpisodeID),"^",61)
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.14.14")
	
	s DisDept = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
	s dept = $P(DisDept,"^",2) //科室代码
	s deptname = $P(DisDept,"^",3) //科室名称
	
	s tmpAdmWard = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisWard(AEpisodeID,"")
	s wardareaname = $p($g(tmpAdmWard),"^",3) // 病区名称
	
	s bedno= ##Class(EMRservice.HISInterface.PatientInfoAssist).DisBed(AEpisodeID) // 病床号
	s AdmDateTimeInBed=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)
	i AdmDateTimeInBed'="" 
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),",",1),3)
		s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed),",",2),1)
		s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed
	}
	s admtime=AdmDateTimeInBed	//入院时间
	
	s AdmDiags = ..GetMRDiagnoseListForEMR(MRADMID,"2","C008")
	s:(AdmDiags="") AdmDiags =  ..GetMRDiagnoseListForEMR(MRADMID,"2","PRE")
	s admdise=$P($P(AdmDiags,$C(1),1),"^",5)	//入院诊断编码
	
	s adminfo=arr.GetAt("HDSD00.14.080") //入院情况
	s trtprocdscr=arr.GetAt("HDSD00.14.120")	//诊疗过程描述
	s dietime=arr.GetAt("HDSD00.14.104")	//死亡时间
	s dietime=..ConvertStandDate(dietime)
	s diedrtrea=arr.GetAt("HDSD00.14.124")	//直接死亡原因名称
	s:(diedrtrea="") diedrtrea="-"
	s diedrtreacode="-"	//直接死亡原因编码
	
	s DisDiags = ..GetMRDiagnoseListForEMR(MRADMID,"2","DIS")
	s diedisename=$P($P(DisDiags,$C(1),1),"^",5)	//死亡诊断名称
	s diediagcode=$P($P(DisDiags,$C(1),1),"^",1)	//死亡诊断编码
	s agrecorpdset="-"	//家属是否同意尸体解剖标志
	
	s ALLSignInfo = ..GetALLSignfInfo(InstanceID)
	s ipdrname=$P($P(ALLSignInfo,"!",1),"^",2)	//住院医师姓名
	s chfpdrname=$p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3)	//主诊医师姓名
	s chfpdrcode=$p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",2)	//主诊医师代码
	s signtime=$P($P(ALLSignInfo,"!",1),"^",3)	//签字日期时间
	if (ipdrname="")
	{
		s ipdrname=$P($P(ALLSignInfo,"!",2),"^",2)	//住院医师姓名
		s chfpdrname=$p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",3)	//主诊医师姓名
		s chfpdrcode=$p(##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(AEpisodeID),"^",2)	//主诊医师代码
		s signtime=$P($P(ALLSignInfo,"!",2),"^",3)	//签字日期时间
	}
	s chfdrname=$P($P(ALLSignInfo,"!",3),"^",2)	//主任医师姓名
	s valiflag="Y"	//有效标志
	
	s data = $lb(dept,deptname,wardareaname,bedno,admtime,admdise,adminfo,trtprocdscr,dietime,diedrtrea,diedrtreacode,diedisename,diediagcode,agrecorpdset,ipdrname,chfpdrcode,chfpdrname,chfdrname,signtime,valiflag)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1 	
	
	Quit $$$OK
}

ClassMethod dieinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = dieinfoExecute ]
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

ClassMethod dieinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = dieinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:		出院记录
/// Input: 		argEpisodeID 就诊号
/// Output:		
/// Desc:  		出院记录相关信息
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","dscginfo","1902")
Query dscginfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "dscg_date,adm_diag_dscr,dscg_dise_dscr,adm_info,trt_proc_rslt_dscr,dscg_info,dscg_drord,caty,rec_doc,main_drug_name,oth_imp_info,vali_flag")
{
}

ClassMethod dscginfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.16")
	s InstanceID = $P(InstanceID,"^",1)
	q:(InstanceID="") $$$OK
	
	s (dscgdate,admdiagdscr,dscgdisedscr,adminfo,trtprocrsltdscr,dscginfo,dscgdrord,caty,recdoc,maindrugname,othimpinfo,valiflag)=""
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
	
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.16")
	s dscgdate=arr.GetAt("HDSD00.16.005")	//出院日期
	s dscgdate=..ConvertStandDate(dscgdate)
	s admdiagdscr=arr.GetAt("HDSD00.16.032")	//入院诊断描述
	s dscgdisedscr=arr.GetAt("HDSD00.16.008")	//出院诊断
	s adminfo=arr.GetAt("HDSD00.16.030")	//入院情况
	s trtprocrsltdscr=arr.GetAt("HDSD00.16.045")	//诊治经过及结果（含手术日期名称及结果）
	s dscginfo=arr.GetAt("HDSD00.16.004")	//出院情况（含治疗效果）
	s dscgdrord=arr.GetAt("HDSD00.16.007")	//出院医嘱
	s DisDept=##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
	s caty=$P(DisDept,"^",3) //科别
	s recdoc=$p($g(^SSU("SSUSR",objInstance.CreateUser)),"^",2)	//记录医师
	s maindrugname="-"	//主要药品名称
	s othimpinfo="-"	//其他重要信息
	s valiflag="Y"	//有效标志
	
	s data = $lb(dscgdate,admdiagdscr,dscgdisedscr,adminfo,trtprocrsltdscr,dscginfo,dscgdrord,caty,recdoc,maindrugname,othimpinfo,valiflag)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1 	
		
	Quit $$$OK
}

ClassMethod dscginfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = dscginfoExecute ]
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

ClassMethod dscginfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = dscginfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 【----------电子病历上传信息[4701]信息----------】
/// 【----------电子病历上传信息[4303]信息----------】
/// Desc:		上报门急诊记录  177
/// Input: 		argEpisodeID 就诊号 
/// Output:		mdtrt_date:就诊日期,chfcomp:主诉,attk_date_time:发病日期时间,mdtrt_rea:就诊原因,illhis:病史,algs:过敏史,aise_code:过敏源代码,phex:查体,disa_info_code:残疾情况代码,symp_name:症状名称,symp_code:症状代码,dspo_opnn:处置意见,dept_code:科室代码,dept_name:科室名称,vali_flag:有效标志
/// Desc:       门急诊病历相关信息
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","caseinfo","2153")
Query caseinfo(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "mdtrt_date,chfcomp,attk_date_time,mdtrt_rea,illhis,algs,aise_code,phex,disa_info_code,symp_name,symp_code,dspo_opnn,dept_code,dept_name,vali_flag")
{
}

ClassMethod caseinfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.03.01")
	s InstanceID = $P(InstanceID,"^",1)
	q:(InstanceID="") $$$OK
	
	s (deptrowid,mdtrtdate,chfcomp,attkdatetime,mdtrtrea,illhis,algs,aisecode,phex,disainfocode,sympname,sympcode,dspoopnn,deptcode,deptname,valiflag,AdmDate)=""
	
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.03.01")
	s chfcomp=arr.GetAt("HDSD00.03.057")       //主诉
	s AdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(AEpisodeID)   		 	
	if AdmDateTime'="" 
	{
		s AdmDate = $P($G(AdmDateTime),",",1)
		s AdmDate = $zd(AdmDate,3) 
		s AdmTime = $P($G(AdmDateTime),",",2)
		s AdmTime = $ZT(AdmTime)
	}
	s mdtrtdate=AdmDate    //就诊日期
	s attkdatetime=AdmDate_" "_AdmTime        //发病日期时间
	s mdtrtrea=$Replace(arr.GetAt("HDSD00.03.005"),$C(10),",")       //就诊原因
	s mdtrtrea=$TR(mdtrtrea," ","")
	s illhis=arr.GetAt("HDSD00.03.038")       //病史
	
	s ALLAiseInfo = ..GetAise(AEpisodeID)
	s algs=$P(ALLAiseInfo,"^",2)      //过敏史
	s aisecode=$P(ALLAiseInfo,"^",1)        //过敏源代码
	s phex=arr.GetAt("HDSD00.03.037")        //查体
	s disainfocode=""        //残疾情况代码
	s sympname=mdtrtrea        //症状名称
	s sympcode=""        //症状代码
	s dspoopnn=$Replace(arr.GetAt("HDSD00.03.050"),$C(10),"；")        //处置意见
	
	s DisDept = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
	s deptname=$P(DisDept,"^",3)    //科室名称
    s deptcode=$P(DisDept,"^",2)	//科室代码
	
	s valiflag="Y"        //有效标志
	
	s data = $lb(mdtrtdate,chfcomp,attkdatetime,mdtrtrea,illhis,algs,aisecode,phex,disainfocode,sympname,sympcode,dspoopnn,deptcode,deptname,valiflag)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1 	
		
	Quit $$$OK
}

ClassMethod caseinfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = caseinfoExecute ]
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

ClassMethod caseinfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = caseinfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 【----------电子病历上传信息[4303]信息----------】
/// 【----------电子病历上传信息[4302]信息----------】
/// Desc:		上报急诊抢救信息
/// Input: 		argEpisodeID 就诊号 
/// Output:		
/// Desc:       急诊病历相关信息
/// Debug:		d ##class(%ResultSet).RunQuery("EMRservice.BL.Interface.RecordInfoToINSU","rescinfo4302","1114")
Query rescinfo4302(AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Query(ROWSPEC = "resc_begntime,resc_endtime,er_resc_rec,resc_psn_list,vali_flag")
{
}

ClassMethod rescinfo4302Execute(ByRef qHandle As %Binary, AEpisodeID As %String, ExpDataAry As %ArrayOfDataTypes = "") As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	q:(AEpisodeID = "") $$$OK
	
	// 获取InstanceID
	s InstanceID = ""
	s ALLInstanceID = ..GetValidInstanceIDListByGlossary(AEpisodeID,"HDSD00.03.02")
	s length = $L(ALLInstanceID,"^")
	For ires = 1:1:length
	{
		s InstanceID = $P(ALLInstanceID,"^",1)
		s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
		continue:(objInstance.Title'["抢救记录")
	}
	q:(InstanceID="") $$$OK
	
	s (rescbegntime,rescendtime,errescrec,rescpsnlist,valiflag)=""
	
	s arr=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AEpisodeID,"HDSD00.03.02")
	s rescbegntime = arr.GetAt("HDSD00.03.029") // 抢救开始时间
	s rescendtime = arr.GetAt("HDSD00.03.028") // 抢救结束时间
	s errescrec = arr.GetAt("HDSD00.03.019") // 急诊抢救记录
	s rescpsnlist = arr.GetAt("HDSD00.03.002") // 参加抢救人员名单
	s valiflag = "Y" // 有效标志
	
	s data = $lb(rescbegntime,rescendtime,errescrec,rescpsnlist,valiflag)
	s ^CacheTemp(repid,ind) = data
	s ind=ind+1 	
	
	Quit $$$OK
}

ClassMethod rescinfo4302Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = rescinfo4302Execute ]
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

ClassMethod rescinfo4302Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = rescinfo4302Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// 【----------电子病历上传信息[4302]信息----------】
/// 【----------工具类方法----------】
/// Creator:  	JC
/// DESC:		获取出院治疗结果
/// input:		就诊号
/// output:		代码^描述
/// DEBUG:		w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetDscgTrtRslt(3,"DESC")
ClassMethod GetDscgTrtRslt(AEpisodeID As %String, AType As %String)
{
	s ret = "^"
	q:(AEpisodeID="") ret
	
	//SELECT PAADM_DischCond_DR, * FROM PA_Adm
    //select * from PAC_DischCondit
    s DischCondDR=$p($g(^PAADM(AEpisodeID)),"^",49)
    q:(DischCondDR="") ret
    
    s Code = "",DISCONDesc = ""
    &sql(SELECT DISCON_Code,DISCON_Desc into Code, DISCONDesc FROM SQLUSER.PAC_DischCondit WHERE DISCON_RowId =:DischCondDR)
    s:(DISCONDesc="稳定") DISCONDesc = "无效"
    s:(DISCONDesc="恶化") DISCONDesc = "未愈"
    s ret = $case(AType,"DESC":DISCONDesc,"CODE":Code,:Code_"^"_DISCONDesc)
    q ret
}

/// Creator:  	JC
/// DESC:		获取过敏原
/// input:		就诊号
/// output:		过敏原描述
/// DEBUG:		w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetAise(3)
ClassMethod GetAise(AEpisodeID As %String)
{
	s AllergenCode = ""
	s AllergenDesc = ""
	//s ret = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetPatAllergyList",AEpisodeID)
	s ds = ##Class(%Library.ResultSet).%New("DHCDoc.Interface.Inside.ServiceAllergy:PatAllergyList")
	d ds.Execute(AEpisodeID)
	While (ds.Next())
	{
		s:AllergenCode'="" AllergenCode = AllergenCode_","
		s AllergenCode = AllergenCode_ds.Data("AllergenCode")
		
		s:AllergenDesc'="" AllergenDesc = AllergenDesc_","
		s AllergenDesc = AllergenDesc_ds.Data("Allergen")
	}
	
	s ret = AllergenCode_"^"_AllergenDesc
	q ret
}

/// Creator:  	JC
/// DESC:		获取检验结果
/// input:		就诊号
/// output:		乙肝表面抗原（HBsAg）
/// DEBUG:		w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetHbsag(3)
ClassMethod GetLisData(AEpisodeID As %String, ALisCode As %String)
{
	s ret = ""
	s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s RegisterNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PapmiDR)
	//d ##Class(%ResultSet).RunQuery("web.DHCENS.STBLL.Method.PostReportInfo","QryTCResultBySync","","0000000012","HBSAG","")
	s ds = ##Class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTCResultBySync")
	d ds.Execute(AEpisodeID,RegisterNo,ALisCode,"") 
	While (ds.Next())
	{
		s ret = ds.Data("TCRes")_ds.Data("Unit")
		q 
	}
	q ret
}

/// Creator:  YK
/// Desc:     根据条件获取有效的InstanceIDList
/// Input:    就诊号Adm、术语集目录Code（以“^”作为分隔符）
/// OutPut:   有效的病例实例ID列表，以“^”作为分割符
/// Debug:    w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetValidInstanceIDListByGlossary(4388,"HDSD00.13.01")
ClassMethod GetValidInstanceIDListByGlossary(AEpisodeID As %String, ACategoryInternalID As %String) As %String
{
	s ret = ""
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	
	s objGlossaryCategory = ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	
	s templateCategoryID = ##Class(EMRservice.BL.BLScatterData).GetGlossaryTemplateIDS(ACategoryInternalID)
	if (templateCategoryID="")
	{
		s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	}
	q:(templateCategoryID="") ret
	
	//获取InstanceID
	s InstanceIDS = ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount=0) ret
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		
		s:(ret'="") ret = ret_"^"
		s ret = ret_AInstanceID
	}
	
	q ret
}

/// Creator:  yejian
/// Desc:     根据条件获取4版的InstanceIDList
/// Input:    就诊号Adm、术语集目录Code（以“^”作为分隔符）
/// OutPut:   有效的病例实例ID列表，以“^”作为分割符
/// Debug:    w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetValidInstanceIDListByGlossary(4388,"HDSD00.13.01")
ClassMethod GetValidInstanceIDListByGlossaryF(AEpisodeID As %String, ACategoryInternalID As %String) As %String
{
	s ret = ""
	s glossaryCategoryID = $O(^CF.EMR.DOC.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	
	s objGlossaryCategory = ##Class(CF.EMR.DOC.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	
	s templateCategoryID = ##Class(EMR.DOC.BL.GlossaryAchieveValue).GetGlossaryTemplateIDS(ACategoryInternalID)
	q:(templateCategoryID="") ret
	
	//获取InstanceID
	s InstanceIDS = ##Class(EMR.DOC.BL.GlossaryAchieveValue).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
	
	s intInsCount = $l(InstanceIDS,"^")
	q:(intInsCount=0) ret
	for i = 1:1:intInsCount
	{
		s AInstanceID = $p(InstanceIDS,"^",i)
		continue:(AInstanceID="")
		
		s:(ret'="") ret = ret_"^"
		s ret = ret_AInstanceID
	}
	
	q ret
}

/// Creator:  YK、WEP
/// Desc:     根据条件获取有效的InstanceIDList
/// Input:    就诊号Adm、病历展现结构的DocIDList（以“^”作为分隔符）
/// OutPut:   有效的病例实例ID列表，以“^”作为分割符
/// Debug:     w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetValidInstanceIDList(1449,"52^460")
ClassMethod GetValidInstanceIDList(Adm As %String, DocIDList As %String) As %String
{
	q:(($d(Adm)=0)||(Adm="")||($TR(DocIDList,"^","")="")||(DocIDList="")) ""
	
	s InstanceIDList = ""
	s ValidInstanceIDList = "^"
	
    for iDocID=1:1:$Length(DocIDList,"^")
    {
        s DocID = $P(DocIDList,"^",iDocID)
        continue:(DocID="")
        s TheECRecord = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",Adm,DocID,""))
        continue:(TheECRecord="")
        
        s LisNo = ""
        For
        {
	        s InstanceID = ""
            s LisNo = $O(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",TheECRecord,LisNo))
            q:(LisNo="")
            s InstanceID = TheECRecord_"||"_LisNo
            s InstanceID = $TR(InstanceID," ","")
            s objInstance = ##class(EMRinstance.InstanceData).%OpenId(InstanceID)
            continue:($IsObject(objInstance)=0)   // add by wep 20191202
            s status = objInstance.Status
            continue:(status'="Save")
			
            // 过滤因同一模板挂到两个界面展示下导致的数据重复
            s tempInstanceID = "^"_InstanceID_"^"
            continue:(ValidInstanceIDList[tempInstanceID)
            s ValidInstanceIDList = ValidInstanceIDList_"^"_tempInstanceID
            
            s:(InstanceIDList'="") InstanceIDList = InstanceIDList_"^"
            s InstanceIDList = InstanceIDList_InstanceID
            do objInstance.%Close()     // add by wep 2020/01/03
        }
    }
    
	q InstanceIDList
}

/// 通过InstanceID获取最后一次签名医师工号^医师姓名^签名日期、签名时间
/// w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetSignfInfo("757||1")
ClassMethod GetSignfInfo(AInstanceID As %String) As %String
{
	q:(AInstanceID="") ""
	
	s SignRowID = "",UserID = "",SignDate = "",Signtime = "",UserCode = "",UserName = ""
	for
	{
		s SignRowID = $O(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,SignRowID),-1)
		q:(SignRowID="")
		
		s SignInfo = ^DHCEMRI.EMRSignD(SignRowID)
		s isSignValid = $List(SignInfo,13)
		continue:(isSignValid = 0)
		
		s UserID = $List(SignInfo,6)
		s UserCode = $P(^SSU("SSUSR",UserID),"^",1)
		s UserName = $P(^SSU("SSUSR",UserID),"^",2)
		
		s SignDate = $ZD($List(SignInfo,9),3)
		s Signtime = $ZT($List(SignInfo,10))
		
		q:(UserID'="")
	}
	/* -- CA 签名
	s SignRowID = "",UserID = "",SignDate = "",Signtime = "",UserCode = "",UserName = ""
	for
	{
		s SignRowID = $O(^DHCEMRCA.EMRSignLogI("IdxInstance"," "_AInstanceID,SignRowID),-1)
		q:(SignRowID="")
		
		s SignInfo = ^DHCEMRCA.EMRSignLogD(SignRowID)
		s isSignValid = $List(SignInfo,12)
		continue:(isSignValid = 0)
		
		s UserID = $List(SignInfo,6)
		s UserCode = $P(^SSU("SSUSR",UserID),"^",1)
		s UserName = $P(^SSU("SSUSR",UserID),"^",2)
		
		s SignDate = $ZD($List(SignInfo,8),3)
		s Signtime = $ZT($List(SignInfo,9))
		
		q:(UserID'="")
	}*/
	
	q UserCode_"^"_UserName_"^"_SignDate_" "_Signtime
}

/// 通过InstanceID获取主任、主治、住院医师签名数据
/// w ##Class(EMRservice.BL.Interface.RecordInfoToINSU).GetALLSignfInfo("758||1")
ClassMethod GetALLSignfInfo(AInstanceID As %String) As %String
{
	q:(AInstanceID="") ""
	
	s SignRowID = "",UserID = ""
	s ResidentID = "",ResidentName = "",ResidentTime = ""
	s AttendingID = "",AttendingName = "",AttendingTime = ""
	s ChiefID = "",ChiefName = "",ChiefTime = ""
	for
	{
		s SignRowID = $O(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,SignRowID))
		q:(SignRowID="")
		
		s SignInfo = ^DHCEMRI.EMRSignD(SignRowID)
		s isSignValid = $List(SignInfo,12)
		continue:(isSignValid = 0)
		
		s SignLevel = $List(SignInfo,7)
		if (SignLevel="residentCheck")
		{
			s UserID = $List(SignInfo,6)
			s ResidentID = $P(^SSU("SSUSR",UserID),"^",1)
			s ResidentName = $P(^SSU("SSUSR",UserID),"^",2)
			s ResidentTime = $ZD($List(SignInfo,8),3)_" "_$ZT($List(SignInfo,3))
		}
		if (SignLevel="attendingCheck")
		{
			s UserID = $List(SignInfo,6)
			s AttendingID = $P(^SSU("SSUSR",UserID),"^",1)
			s AttendingName = $P(^SSU("SSUSR",UserID),"^",2)
			s AttendingTime = $ZD($List(SignInfo,8),3)_" "_$ZT($List(SignInfo,3))
		}
		if (SignLevel="chiefCheck")
		{
			s UserID = $List(SignInfo,6)
			s ChiefID = $P(^SSU("SSUSR",UserID),"^",1)
			s ChiefName = $P(^SSU("SSUSR",UserID),"^",2)
			s ChiefTime = $ZD($List(SignInfo,8),3)_" "_$ZT($List(SignInfo,3))
		}
	}
	
	q ResidentID_"^"_ResidentName_"^"_ResidentTime_"!"_AttendingID_"^"_AttendingName_"^"_AttendingTime_"!"_ChiefID_"^"_ChiefName_"^"_ChiefTime
}

/// 获取患者所有诊断信息
ClassMethod GetMRDiagnoseListForEMR(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %String
{
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" 
	{
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",$ZCVT(DiagnosTypeCode,"U"),0))
	}
	
	s Sub=0
	for  s Sub=$o(^MR(MRADMID,"DIA",Sub)) q:Sub=""  d
	.q:$G(^MR(MRADMID,"DIA",Sub))=""
	.s Str=^(Sub)
	.s Rowid=MRADMID_"||"_Sub
	.s CodeRowid=$P(Str,"^",1)
	.s MRDiagnosDate=$P(Str,"^",7)
	.s MRdiagnosTime=$P(Str,"^",8)
	.I MRDiagnosDate'="" Set MRDiagnosDate=$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=$zt(MRdiagnosTime,2)
	.//取诊断代码、描述
	.s MRCIDCode="",Desc="",MRDesc=""
	.if (CodeRowid'="") d
	..s MRCIDCode=$P(^MRC("ID",CodeRowid),"^",4)
	..s Desc=$P(^MRC("ID",CodeRowid),"^",2)
	.//讲备注拼在诊断描述后
	.s MRDescDr=$O(^MR(MRADMID,"DIA",Sub,"DES",""),-1)
	.if (+MRDescDr'=0) d
	..s MRDesc=$g(^MR(MRADMID,"DIA",Sub,"DES",MRDescDr))
	..s:(($LISTVALID(MRDesc)'=0)&&(MRDesc'="")) MRDesc=$LIST(MRDesc,1)
	..s Desc=Desc_MRDesc
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.//根据诊断类型过滤
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.//取备注
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I +MRdiagnosNoteSubRowid'=0 Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.//根据ICDType 过滤中西医类型诊断：ICDType=1是中医，ICDType=2是西医
	.s BillFlag1="" 
	.s BillFlag3=""
	.s DiagnosCat=""
	.i CodeRowid'="" d
	..s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
	..s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	..i BillFlag3'="Y" d
	...s DiagnosCat="西医"
	..else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
	...s DiagnosCat="中医"
	..else  d
	...s DiagnosCat="证候"
	.e  d
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..i Questionnaire=1 d
	...s DiagnosCat="西医"
	..else  if (Questionnaire=2) d
	...s DiagnosCat="中医"
	..else  if (Questionnaire=3) d
	...s DiagnosCat="证候"
	.Q:(DiagnosCat'="")&&(ICDType="1")&&(DiagnosCat="西医")
	.Q:(DiagnosCat'="")&&(ICDType="2")&&(DiagnosCat'="西医")
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s:(DiagnosNumber="") DiagnosNumber=$P(Rowid,"||",2)
	.
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=$zd(DIAOnsetDate,3) 						//取发病日期
	.//取是否是主要诊断
	.s IsMainDiagnosFlag=$p(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1),"^",20)
	.s:(IsMainDiagnosFlag="Y") DiagnosTypeNum=1
	.s:(IsMainDiagnosFlag'="Y") DiagnosTypeNum=2
    .s IsChild = "N"
	.s TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,IsChild,Rowid)=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_IsChild_"^"_IsMainDiagnosFlag
	
	//按顺序输出设置
	s TempDia=""
	s DiagnosTypeNum=0
	for 
	{
		s DiagnosTypeNum=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum))
		q:DiagnosTypeNum=""
		s DiagnosNumber=0
		for  
		{
			s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber)) 
			Q:DiagnosNumber=""  d
			s TempIsChild = 0
			for 
			{
			    s TempIsChild=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,TempIsChild))
				q:TempIsChild=""
				s Temprowid=0 
				for 
				{
					s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,TempIsChild,Temprowid))
					q:Temprowid=""
					i RetStr="" s RetStr=TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,TempIsChild,Temprowid)
					e  s RetStr=RetStr_$c(1)_TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,TempIsChild,Temprowid)
			    }
		    }
		}
	}
	k TempArr("FindDiagnos",$j)
	
	q RetStr
}

/// Creator：		WEP
/// CreatDate：    	2020-2-14
/// Description: 	构造病案首页诊断记录信息 【西医病案首页】
/// Input： 		Adm:就诊号
/// Output： 		DiagCode_$C(1)_DiagDesc_$C(1)_AdmCondtionCode_$C(1)_AdmCondtionDesc_$C(1)_HealResultCode_$C(1)_HealResultDesc
/// Return： 		诊断编码_$C(1)_诊断描述_$C(1)_入院情况编码_$C(1)_入院情况_$C(1)_出院情况编码_$C(1)_出院情况
/// Others：		w ##class(EMRservice.BL.Interface.RecordInfoToINSU).GetDisDiagose("2485371")
ClassMethod GetDisDiagose(Adm As %String)
{
	// 取病案首页术语集
	s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.11")
	
	// 出院诊断1~20
	s DiagCode = arr.GetAt("HDSD00.11.023")_"^"_arr.GetAt("HDSD00.11.020")_"^"_arr.GetAt("HDSD00.11.307")_"^"_arr.GetAt("HDSD00.11.311")_"^"_arr.GetAt("HDSD00.11.315")
	s DiagCode = DiagCode_"^"_arr.GetAt("HDSD00.11.319")_"^"_arr.GetAt("HDSD00.11.323")_"^"_arr.GetAt("HDSD00.11.327")_"^"_arr.GetAt("HDSD00.11.331")_"^"_arr.GetAt("HDSD00.11.335")
	s DiagCode = DiagCode_"^"_arr.GetAt("HDSD00.11.339")_"^"_arr.GetAt("HDSD00.11.343")_"^"_arr.GetAt("HDSD00.11.347")_"^"_arr.GetAt("HDSD00.11.351")_"^"_arr.GetAt("HDSD00.11.355")
	s DiagCode = DiagCode_"^"_arr.GetAt("HDSD00.11.359")_"^"_arr.GetAt("HDSD00.11.363")_"^"_arr.GetAt("HDSD00.11.367")_"^"_arr.GetAt("HDSD00.11.371")_"^"_arr.GetAt("HDSD00.11.375")
	
	s DiagDesc = arr.GetAt("HDSD00.11.024")_"^"_arr.GetAt("HDSD00.11.021")_"^"_arr.GetAt("HDSD00.11.306")_"^"_arr.GetAt("HDSD00.11.310")_"^"_arr.GetAt("HDSD00.11.314")
	s DiagDesc = DiagDesc_"^"_arr.GetAt("HDSD00.11.318")_"^"_arr.GetAt("HDSD00.11.322")_"^"_arr.GetAt("HDSD00.11.326")_"^"_arr.GetAt("HDSD00.11.330")_"^"_arr.GetAt("HDSD00.11.334")
	s DiagDesc = DiagDesc_"^"_arr.GetAt("HDSD00.11.338")_"^"_arr.GetAt("HDSD00.11.342")_"^"_arr.GetAt("HDSD00.11.346")_"^"_arr.GetAt("HDSD00.11.350")_"^"_arr.GetAt("HDSD00.11.354")
	s DiagDesc = DiagDesc_"^"_arr.GetAt("HDSD00.11.358")_"^"_arr.GetAt("HDSD00.11.362")_"^"_arr.GetAt("HDSD00.11.366")_"^"_arr.GetAt("HDSD00.11.370")_"^"_arr.GetAt("HDSD00.11.374")
	
	// 入院病情1~20
	s AdmCondtionCode = arr.GetAt("HDSD00.11.025")_"^"_arr.GetAt("HDSD00.11.022")_"^"_arr.GetAt("HDSD00.11.308")_"^"_arr.GetAt("HDSD00.11.312")_"^"_arr.GetAt("HDSD00.11.316")
	s AdmCondtionCode = AdmCondtionCode_"^"_arr.GetAt("HDSD00.11.320")_"^"_arr.GetAt("HDSD00.11.324")_"^"_arr.GetAt("HDSD00.11.328")_"^"_arr.GetAt("HDSD00.11.332")_"^"_arr.GetAt("HDSD00.11.336")
	s AdmCondtionCode = AdmCondtionCode_"^"_arr.GetAt("HDSD00.11.340")_"^"_arr.GetAt("HDSD00.11.344")_"^"_arr.GetAt("HDSD00.11.348")_"^"_arr.GetAt("HDSD00.11.352")_"^"_arr.GetAt("HDSD00.11.356")
	s AdmCondtionCode = AdmCondtionCode_"^"_arr.GetAt("HDSD00.11.360")_"^"_arr.GetAt("HDSD00.11.364")_"^"_arr.GetAt("HDSD00.11.368")_"^"_arr.GetAt("HDSD00.11.372")_"^"_arr.GetAt("HDSD00.11.376")
	
	s AdmCondtionDesc = arr.GetAt("HDSD00.11.304")_"^"_arr.GetAt("HDSD00.11.305")_"^"_arr.GetAt("HDSD00.11.309")_"^"_arr.GetAt("HDSD00.11.313")_"^"_arr.GetAt("HDSD00.11.317")
	s AdmCondtionDesc = AdmCondtionDesc_"^"_arr.GetAt("HDSD00.11.321")_"^"_arr.GetAt("HDSD00.11.325")_"^"_arr.GetAt("HDSD00.11.329")_"^"_arr.GetAt("HDSD00.11.333")_"^"_arr.GetAt("HDSD00.11.337")
	s AdmCondtionDesc = AdmCondtionDesc_"^"_arr.GetAt("HDSD00.11.341")_"^"_arr.GetAt("HDSD00.11.345")_"^"_arr.GetAt("HDSD00.11.349")_"^"_arr.GetAt("HDSD00.11.353")_"^"_arr.GetAt("HDSD00.11.357")
	s AdmCondtionDesc = AdmCondtionDesc_"^"_arr.GetAt("HDSD00.11.361")_"^"_arr.GetAt("HDSD00.11.365")_"^"_arr.GetAt("HDSD00.11.369")_"^"_arr.GetAt("HDSD00.11.373")_"^"_arr.GetAt("HDSD00.11.377")
	
	// 出院情况1~20
	s HealResultCode = arr.GetAt("HDSD00.11.806")_"^"_arr.GetAt("HDSD00.11.1132")_"^"_arr.GetAt("HDSD00.11.1134")_"^"_arr.GetAt("HDSD00.11.1136")_"^"_arr.GetAt("HDSD00.11.1138")_"^"_arr.GetAt("HDSD00.11.1140")
	s HealResultCode = HealResultCode_"^"_arr.GetAt("HDSD00.11.1142")_"^"_arr.GetAt("HDSD00.11.1144")_"^"_arr.GetAt("HDSD00.11.1146")_"^"_arr.GetAt("HDSD00.11.1148")_"^"_arr.GetAt("HDSD00.11.1150")
	s HealResultCode = HealResultCode_"^"_arr.GetAt("HDSD00.11.1152")_"^"_arr.GetAt("HDSD00.11.1154")_"^"_arr.GetAt("HDSD00.11.1156")_"^"_arr.GetAt("HDSD00.11.1158")_"^"_arr.GetAt("HDSD00.11.1160")
	s HealResultCode = HealResultCode_"^"_arr.GetAt("HDSD00.11.1162")_"^"_arr.GetAt("HDSD00.11.1164")_"^"_arr.GetAt("HDSD00.11.1166")_"^"_arr.GetAt("HDSD00.11.1168")
	
	s HealResultDesc = arr.GetAt("HDSD00.11.805")_"^"_arr.GetAt("HDSD00.11.1131")_"^"_arr.GetAt("HDSD00.11.1133")_"^"_arr.GetAt("HDSD00.11.1135")_"^"_arr.GetAt("HDSD00.11.1137")_"^"_arr.GetAt("HDSD00.11.1139")
	s HealResultDesc = HealResultDesc_"^"_arr.GetAt("HDSD00.11.1141")_"^"_arr.GetAt("HDSD00.11.1143")_"^"_arr.GetAt("HDSD00.11.1145")_"^"_arr.GetAt("HDSD00.11.1147")_"^"_arr.GetAt("HDSD00.11.1149")
	s HealResultDesc = HealResultDesc_"^"_arr.GetAt("HDSD00.11.1151")_"^"_arr.GetAt("HDSD00.11.1153")_"^"_arr.GetAt("HDSD00.11.1155")_"^"_arr.GetAt("HDSD00.11.1157")_"^"_arr.GetAt("HDSD00.11.1159")
	s HealResultDesc = HealResultDesc_"^"_arr.GetAt("HDSD00.11.1161")_"^"_arr.GetAt("HDSD00.11.1163")_"^"_arr.GetAt("HDSD00.11.1165")_"^"_arr.GetAt("HDSD00.11.1167")
	
	q DiagCode_$C(1)_DiagDesc_$C(1)_AdmCondtionCode_$C(1)_AdmCondtionDesc_$C(1)_HealResultCode_$C(1)_HealResultDesc
}

/// Creator：		WEP
/// CreatDate：    	2020-2-14
/// Description:： 	构造出院诊断信息 【中医病案首页】
/// Table：        	
/// Input： 		Adm:就诊号
/// Output：		西医出院诊断编码_$C(1)_西医出院诊断描述_$C(1)_西医入院病情编码_$C(1)_西医入院病情描述_$C(1)_西医出院情况编码_$C(1)_西医出院情况描述
///  				_$C(1)_中医出院诊断编码_$C(1)_中医出院诊断描述_$C(1)_中医入院病情编码_$C(1)_中医入院病情描述_$C(1)_中医出院情况编码_$C(1)_中医出院情况描述
/// Return： 		
/// Others：		w ##class(EMRmeta.Data.Method.Tools).GetZYDisDiagoseInfo("1449")
ClassMethod GetZYDisDiagoseInfo(Adm As %String)
{
	// 取病案首页术语集
	s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.12")
	
	// 出院西医诊断-主要诊断疾病编码	&&      出院西医诊断-其他诊断疾病编码 1~10
	s DiagCode = arr.GetAt("HDSD00.12.024")_"^"_arr.GetAt("HDSD00.12.021")_"^"_arr.GetAt("HDSD00.12.307")_"^"_arr.GetAt("HDSD00.12.311")_"^"_arr.GetAt("HDSD00.12.315")_"^"_arr.GetAt("HDSD00.12.319")_"^"_arr.GetAt("HDSD00.12.323")_"^"_arr.GetAt("HDSD00.12.327")_"^"_arr.GetAt("HDSD00.12.331")_"^"_arr.GetAt("HDSD00.12.335")_"^"_arr.GetAt("HDSD00.12.339")
	
	// 出院西医诊断-主要诊断名称     &&   出院西医诊断-其他诊断名称 1~10
	s DiagDesc = arr.GetAt("HDSD00.12.025")_"^"_arr.GetAt("HDSD00.12.022")_"^"_arr.GetAt("HDSD00.12.306")_"^"_arr.GetAt("HDSD00.12.310")_"^"_arr.GetAt("HDSD00.12.314")_"^"_arr.GetAt("HDSD00.12.318")_"^"_arr.GetAt("HDSD00.12.322")_"^"_arr.GetAt("HDSD00.12.326")_"^"_arr.GetAt("HDSD00.12.330")_"^"_arr.GetAt("HDSD00.12.334")_"^"_arr.GetAt("HDSD00.12.338")
	
	// 出院西医诊断-主要诊断－入院病情代码     &&      出院西医诊断-其他诊断－入院病情代码 1~10
	s AdmCondtionCode = arr.GetAt("HDSD00.12.026")_"^"_arr.GetAt("HDSD00.12.023")_"^"_arr.GetAt("HDSD00.12.308")_"^"_arr.GetAt("HDSD00.12.312")_"^"_arr.GetAt("HDSD00.12.316")_"^"_arr.GetAt("HDSD00.12.320")_"^"_arr.GetAt("HDSD00.12.324")_"^"_arr.GetAt("HDSD00.12.328")_"^"_arr.GetAt("HDSD00.12.332")_"^"_arr.GetAt("HDSD00.12.336")_"^"_arr.GetAt("HDSD00.12.340")
	
	// 出院诊断-主要诊断入院病情名称         &&         出院诊断-其他诊断入院病情名称 1~10
	s AdmCondtionDesc = arr.GetAt("HDSD00.12.304")_"^"_arr.GetAt("HDSD00.12.305")_"^"_arr.GetAt("HDSD00.12.309")_"^"_arr.GetAt("HDSD00.12.313")_"^"_arr.GetAt("HDSD00.12.317")_"^"_arr.GetAt("HDSD00.12.321")_"^"_arr.GetAt("HDSD00.12.325")_"^"_arr.GetAt("HDSD00.12.329")_"^"_arr.GetAt("HDSD00.12.333")_"^"_arr.GetAt("HDSD00.12.337")_"^"_arr.GetAt("HDSD00.12.341")
	
	// 出院诊断-主要诊断出院情况代码   &&  出院诊断-其他诊断出院情况代码 1~10
	s HealResultCode = arr.GetAt("HDSD00.12.806")_"^"_arr.GetAt("HDSD00.12.1132")_"^"_arr.GetAt("HDSD00.12.1134")_"^"_arr.GetAt("HDSD00.12.1136")_"^"_arr.GetAt("HDSD00.12.1138")_"^"_arr.GetAt("HDSD00.12.1140")_"^"_arr.GetAt("HDSD00.12.1142")_"^"_arr.GetAt("HDSD00.12.1144")_"^"_arr.GetAt("HDSD00.12.1146")_"^"_arr.GetAt("HDSD00.12.1148")_"^"_arr.GetAt("HDSD00.12.1150")

	// 出院诊断-主要诊断出院情况描述   &&&   出院诊断-其他诊断出院情况描述 1~10
	s HealResultDesc = arr.GetAt("HDSD00.12.805")_"^"_arr.GetAt("HDSD00.12.1131")_"^"_arr.GetAt("HDSD00.12.1133")_"^"_arr.GetAt("HDSD00.12.1135")_"^"_arr.GetAt("HDSD00.12.1137")_"^"_arr.GetAt("HDSD00.12.1139")_"^"_arr.GetAt("HDSD00.12.1141")_"^"_arr.GetAt("HDSD00.12.1143")_"^"_arr.GetAt("HDSD00.12.1145")_"^"_arr.GetAt("HDSD00.12.1147")_"^"_arr.GetAt("HDSD00.12.1149")
	
	// 出院中医诊断-主病编码  &&  出院中医诊断-主证编码 1~10
	s ZYDiagCode = arr.GetAt("HDSD00.12.027")_"^"_arr.GetAt("HDSD00.12.032")_"^"_arr.GetAt("HDSD00.12.2006")_"^"_arr.GetAt("HDSD00.12.2009")_"^"_arr.GetAt("HDSD00.12.2012")_"^"_arr.GetAt("HDSD00.12.2015")_"^"_arr.GetAt("HDSD00.12.2018")_"^"_arr.GetAt("HDSD00.12.2021")_"^"_arr.GetAt("HDSD00.12.2024")_"^"_arr.GetAt("HDSD00.12.2027")_"^"_arr.GetAt("HDSD00.12.2030")

	// 出院中医诊断-主病名称  &&  出院中医诊断-主证名称 1~10
	s ZYDiagDesc = arr.GetAt("HDSD00.12.028")_"^"_arr.GetAt("HDSD00.12.030")_"^"_arr.GetAt("HDSD00.12.2005")_"^"_arr.GetAt("HDSD00.12.2008")_"^"_arr.GetAt("HDSD00.12.2011")_"^"_arr.GetAt("HDSD00.12.2014")_"^"_arr.GetAt("HDSD00.12.2017")_"^"_arr.GetAt("HDSD00.12.2020")_"^"_arr.GetAt("HDSD00.12.2023")_"^"_arr.GetAt("HDSD00.12.2026")_"^"_arr.GetAt("HDSD00.12.2029")

	// 173.9入院病情代码 VARCHAR2(1) 必填 参考《入院病情代码》
	// 出院中医诊断－主病－入院病情代码  &&  出院中医诊断－主证－入院病情代码 1~10
	s ZYAdmCondtionCode = arr.GetAt("HDSD00.12.029")_"^"_arr.GetAt("HDSD00.12.031")_"^"_arr.GetAt("HDSD00.12.2007")_"^"_arr.GetAt("HDSD00.12.2010")_"^"_arr.GetAt("HDSD00.12.2013")_"^"_arr.GetAt("HDSD00.12.2016")_"^"_arr.GetAt("HDSD00.12.2019")_"^"_arr.GetAt("HDSD00.12.2022")_"^"_arr.GetAt("HDSD00.12.2025")_"^"_arr.GetAt("HDSD00.12.2028")_"^"_arr.GetAt("HDSD00.12.2031")
	
	// 出院中医诊断－主病－入院病情名称  &&  出院中医诊断－主证－入院病情名称 1~10
	s ZYAdmCondtionDesc = arr.GetAt("HDSD00.12.2032")_"^"_arr.GetAt("HDSD00.12.2033")_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"
	
	// 出院中医诊断－主病－出院情况代码  &&  出院中医诊断-主证-出院情况代码1~10
	s ZYHealResultCode = "^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"
	
	// 出院中医诊断－主病－出院情况名称  &&  出院中医诊断-主证-出院情况名称1~10
	s ZYHealResultDesc = "^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"_"^"
	
	q DiagCode_$C(1)_DiagDesc_$C(1)_AdmCondtionCode_$C(1)_AdmCondtionDesc_$C(1)_HealResultCode_$C(1)_HealResultDesc_$C(1)_ZYDiagCode_$C(1)_ZYDiagDesc_$C(1)_ZYAdmCondtionCode_$C(1)_ZYAdmCondtionDesc_$C(1)_ZYHealResultCode_$C(1)_ZYHealResultDesc
}

/// Creator：		WEP
/// CreatDate：    	2020-2-14
/// Description: 	构造手术记录信息 【西医病案首页】
/// Input： 		Adm:就诊号
/// Output： 		OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
/// Return： 		手术及操作编码_$C(1)_手术及操作名称_$C(1)_手术操作日期时间_$C(1)_手术级别代码_$C(1)_手术级别描述_$C(1)_手术切口类别代码_$C(1)_手术切口类别描述_$C(1)_切口愈合等级代码_$C(1)_切口愈合等级描述_$C(1)_手术者代码_$C(1)_手术者姓名_$C(1)_Ⅰ助代码_$C(1)_Ⅰ助姓名_$C(1)_Ⅱ助代码_$C(1)_Ⅱ助姓名_$C(1)_麻醉方式代码_$C(1)_麻醉方式描述_$C(1)_麻醉医师姓名
/// Others：		w ##class(EMRservice.BL.Interface.RecordInfoToINSU).GetFirstOperInfo("2485371")
ClassMethod GetFirstOperInfo(Adm As %String)
{
	// 取病案首页术语集
	s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.11")
	
	// 手术及操作编码 1~10
	s OperCode = arr.GetAt("HDSD00.11.089")_"^"_arr.GetAt("HDSD00.11.410")_"^"_arr.GetAt("HDSD00.11.425")_"^"_arr.GetAt("HDSD00.11.440")_"^"_arr.GetAt("HDSD00.11.455")_"^"_arr.GetAt("HDSD00.11.470")_"^"_arr.GetAt("HDSD00.11.485")_"^"_arr.GetAt("HDSD00.11.500")_"^"_arr.GetAt("HDSD00.11.515")_"^"_arr.GetAt("HDSD00.11.530")
	// 手术及操作名称 1~10
	s OperDesc = arr.GetAt("HDSD00.11.090")_"^"_arr.GetAt("HDSD00.11.414")_"^"_arr.GetAt("HDSD00.11.429")_"^"_arr.GetAt("HDSD00.11.444")_"^"_arr.GetAt("HDSD00.11.459")_"^"_arr.GetAt("HDSD00.11.474")_"^"_arr.GetAt("HDSD00.11.489")_"^"_arr.GetAt("HDSD00.11.504")_"^"_arr.GetAt("HDSD00.11.519")_"^"_arr.GetAt("HDSD00.11.534")
	
	// 手术及操作开始日期1~10
	s OperDate = arr.GetAt("HDSD00.11.091")_"^"_arr.GetAt("HDSD00.11.411")_"^"_arr.GetAt("HDSD00.11.426")_"^"_arr.GetAt("HDSD00.11.441")_"^"_arr.GetAt("HDSD00.11.456")_"^"_arr.GetAt("HDSD00.11.471")_"^"_arr.GetAt("HDSD00.11.486")_"^"_arr.GetAt("HDSD00.11.501")_"^"_arr.GetAt("HDSD00.11.516")_"^"_arr.GetAt("HDSD00.11.531")
	
	// 手术级别代码 1~10
	s OperLevelCode = arr.GetAt("HDSD00.11.092")_"^"_arr.GetAt("HDSD00.11.413")_"^"_arr.GetAt("HDSD00.11.428")_"^"_arr.GetAt("HDSD00.11.443")_"^"_arr.GetAt("HDSD00.11.458")_"^"_arr.GetAt("HDSD00.11.473")_"^"_arr.GetAt("HDSD00.11.488")_"^"_arr.GetAt("HDSD00.11.503")_"^"_arr.GetAt("HDSD00.11.518")_"^"_arr.GetAt("HDSD00.11.533")
	// 手术级别描述 1~10
	s OperLevelDesc = arr.GetAt("HDSD00.11.605")_"^"_arr.GetAt("HDSD00.11.606")_"^"_arr.GetAt("HDSD00.11.607")_"^"_arr.GetAt("HDSD00.11.608")_"^"_arr.GetAt("HDSD00.11.609")_"^"_arr.GetAt("HDSD00.11.610")_"^"_arr.GetAt("HDSD00.11.611")_"^"_arr.GetAt("HDSD00.11.612")_"^"_arr.GetAt("HDSD00.11.613")_"^"_arr.GetAt("HDSD00.11.614")
	
	// 手术切口类别代码 1~10
	s OperCutCode = arr.GetAt("HDSD00.11.093")_"^"_arr.GetAt("HDSD00.11.421")_"^"_arr.GetAt("HDSD00.11.436")_"^"_arr.GetAt("HDSD00.11.451")_"^"_arr.GetAt("HDSD00.11.466")_"^"_arr.GetAt("HDSD00.11.481")_"^"_arr.GetAt("HDSD00.11.496")_"^"_arr.GetAt("HDSD00.11.511")_"^"_arr.GetAt("HDSD00.11.526")_"^"_arr.GetAt("HDSD00.11.541")
	// 手术切口类别描述 1~10
	s OperCutDesc = arr.GetAt("HDSD00.11.615")_"^"_arr.GetAt("HDSD00.11.617")_"^"_arr.GetAt("HDSD00.11.619")_"^"_arr.GetAt("HDSD00.11.621")_"^"_arr.GetAt("HDSD00.11.623")_"^"_arr.GetAt("HDSD00.11.625")_"^"_arr.GetAt("HDSD00.11.627")_"^"_arr.GetAt("HDSD00.11.629")_"^"_arr.GetAt("HDSD00.11.631")_"^"_arr.GetAt("HDSD00.11.633")
	
	// 切口愈合等级代码 1~10
	s CutHealCode = arr.GetAt("HDSD00.11.082")_"^"_arr.GetAt("HDSD00.11.422")_"^"_arr.GetAt("HDSD00.11.437")_"^"_arr.GetAt("HDSD00.11.452")_"^"_arr.GetAt("HDSD00.11.467")_"^"_arr.GetAt("HDSD00.11.482")_"^"_arr.GetAt("HDSD00.11.497")_"^"_arr.GetAt("HDSD00.11.512")_"^"_arr.GetAt("HDSD00.11.527")_"^"_arr.GetAt("HDSD00.11.542")
	// 切口愈合等级描述 1~10
	s CutHealDesc = arr.GetAt("HDSD00.11.616")_"^"_arr.GetAt("HDSD00.11.618")_"^"_arr.GetAt("HDSD00.11.620")_"^"_arr.GetAt("HDSD00.11.622")_"^"_arr.GetAt("HDSD00.11.624")_"^"_arr.GetAt("HDSD00.11.626")_"^"_arr.GetAt("HDSD00.11.628")_"^"_arr.GetAt("HDSD00.11.630")_"^"_arr.GetAt("HDSD00.11.632")_"^"_arr.GetAt("HDSD00.11.634")
	
	// 手术者代码 1~10
	s OperDocCode = arr.GetAt("HDSD00.11.407")_"^"_arr.GetAt("HDSD00.11.415")_"^"_arr.GetAt("HDSD00.11.430")_"^"_arr.GetAt("HDSD00.11.445")_"^"_arr.GetAt("HDSD00.11.460")_"^"_arr.GetAt("HDSD00.11.475")_"^"_arr.GetAt("HDSD00.11.490")_"^"_arr.GetAt("HDSD00.11.505")_"^"_arr.GetAt("HDSD00.11.520")_"^"_arr.GetAt("HDSD00.11.535")
	// 手术者姓名 1~10
	s OperDoc = arr.GetAt("HDSD00.11.094")_"^"_arr.GetAt("HDSD00.11.416")_"^"_arr.GetAt("HDSD00.11.431")_"^"_arr.GetAt("HDSD00.11.446")_"^"_arr.GetAt("HDSD00.11.461")_"^"_arr.GetAt("HDSD00.11.476")_"^"_arr.GetAt("HDSD00.11.491")_"^"_arr.GetAt("HDSD00.11.506")_"^"_arr.GetAt("HDSD00.11.521")_"^"_arr.GetAt("HDSD00.11.536")
	
	// Ⅰ助代码
	s FirstAssCode = ""
	// Ⅰ助姓名 1~10
	s FirstAss = arr.GetAt("HDSD00.11.001")_"^"_arr.GetAt("HDSD00.11.418")_"^"_arr.GetAt("HDSD00.11.433")_"^"_arr.GetAt("HDSD00.11.448")_"^"_arr.GetAt("HDSD00.11.463")_"^"_arr.GetAt("HDSD00.11.478")_"^"_arr.GetAt("HDSD00.11.493")_"^"_arr.GetAt("HDSD00.11.508")_"^"_arr.GetAt("HDSD00.11.523")_"^"_arr.GetAt("HDSD00.11.538")
	
	// Ⅱ助代码
	s SecondAssCode = ""
	// Ⅱ助姓名 1~10
	s SecondAss = arr.GetAt("HDSD00.11.002")_"^"_arr.GetAt("HDSD00.11.420")_"^"_arr.GetAt("HDSD00.11.435")_"^"_arr.GetAt("HDSD00.11.450")_"^"_arr.GetAt("HDSD00.11.465")_"^"_arr.GetAt("HDSD00.11.480")_"^"_arr.GetAt("HDSD00.11.495")_"^"_arr.GetAt("HDSD00.11.510")_"^"_arr.GetAt("HDSD00.11.525")_"^"_arr.GetAt("HDSD00.11.540")
	
	// 麻醉方式代码 1~10
	s AnamethodCode = arr.GetAt("HDSD00.11.073")_"^"_arr.GetAt("HDSD00.11.423")_"^"_arr.GetAt("HDSD00.11.438")_"^"_arr.GetAt("HDSD00.11.453")_"^"_arr.GetAt("HDSD00.11.468")_"^"_arr.GetAt("HDSD00.11.483")_"^"_arr.GetAt("HDSD00.11.498")_"^"_arr.GetAt("HDSD00.11.513")_"^"_arr.GetAt("HDSD00.11.528")_"^"_arr.GetAt("HDSD00.11.543")
	// 麻醉方式描述 1~10
	s AnamethodDesc = arr.GetAt("HDSD00.11.852")_"^"_arr.GetAt("HDSD00.11.853")_"^"_arr.GetAt("HDSD00.11.854")_"^"_arr.GetAt("HDSD00.11.855")_"^"_arr.GetAt("HDSD00.11.856")_"^"_arr.GetAt("HDSD00.11.857")_"^"_arr.GetAt("HDSD00.11.858")_"^"_arr.GetAt("HDSD00.11.859")_"^"_arr.GetAt("HDSD00.11.860")_"^"_arr.GetAt("HDSD00.11.861")
	
	// 麻醉医师姓名 1~10
	s AnaDoc = arr.GetAt("HDSD00.11.074")_"^"_arr.GetAt("HDSD00.11.424")_"^"_arr.GetAt("HDSD00.11.439")_"^"_arr.GetAt("HDSD00.11.454")_"^"_arr.GetAt("HDSD00.11.469")_"^"_arr.GetAt("HDSD00.11.484")_"^"_arr.GetAt("HDSD00.11.499")_"^"_arr.GetAt("HDSD00.11.514")_"^"_arr.GetAt("HDSD00.11.529")_"^"_arr.GetAt("HDSD00.11.544")
	
	// 手术ID
	s OpsId = arr.GetAt("HDSD00.11.2575")_"^"_arr.GetAt("HDSD00.11.2576")_"^"_arr.GetAt("HDSD00.11.2577")_"^"_arr.GetAt("HDSD00.11.2578")_"^"_arr.GetAt("HDSD00.11.2579")_"^"_arr.GetAt("HDSD00.11.2580")_"^"_arr.GetAt("HDSD00.11.2581")_"^"_arr.GetAt("HDSD00.11.2582")_"^"_arr.GetAt("HDSD00.11.2583")_"^"_arr.GetAt("HDSD00.11.2584")
	
	q OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc_$C(1)_OpsId
}

/// Creator：		WEP
/// CreatDate：    	2020-2-14
/// Description:： 	构造手术记录信息 【中医病案首页】
/// Table：        	
/// Input： 		Adm:就诊号
/// Output： 		OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
/// Return： 		手术及操作编码_$C(1)_手术及操作名称_$C(1)_手术操作日期时间_$C(1)_手术级别代码_$C(1)_手术级别描述_$C(1)_手术切口类别代码_$C(1)_手术切口类别描述_$C(1)_切口愈合等级代码_$C(1)_切口愈合等级描述_$C(1)_手术者代码_$C(1)_手术者姓名_$C(1)_Ⅰ助代码_$C(1)_Ⅰ助姓名_$C(1)_Ⅱ助代码_$C(1)_Ⅱ助姓名_$C(1)_麻醉方式代码_$C(1)_麻醉方式描述_$C(1)_麻醉医师姓名
/// Others：		w ##class(EMRmeta.Data.Method.Tools).GetZYFirstOperInfo("1449")
ClassMethod GetZYFirstOperInfo(Adm As %String)
{
	// 取病案首页术语集
	s arr = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(Adm,"HDSD00.12")
	
	// 174.2手术操作代码 VARCHAR2(36) 必填 手术及操作(ICD-9-CM-3)
	// 手术及操作编码 1~10
	s OperCode = arr.GetAt("HDSD00.12.104")_"^"_arr.GetAt("HDSD00.12.410")_"^"_arr.GetAt("HDSD00.12.425")_"^"_arr.GetAt("HDSD00.12.440")_"^"_arr.GetAt("HDSD00.12.455")_"^"_arr.GetAt("HDSD00.12.470")_"^"_arr.GetAt("HDSD00.12.485")_"^"_arr.GetAt("HDSD00.12.500")_"^"_arr.GetAt("HDSD00.12.515")_"^"_arr.GetAt("HDSD00.12.530")

	// 174.3手术操作名称 VARCHAR2(80) 必填
	// 手术及操作名称 1~10
	s OperDesc = arr.GetAt("HDSD00.12.105")_"^"_arr.GetAt("HDSD00.12.414")_"^"_arr.GetAt("HDSD00.12.429")_"^"_arr.GetAt("HDSD00.12.444")_"^"_arr.GetAt("HDSD00.12.459")_"^"_arr.GetAt("HDSD00.12.474")_"^"_arr.GetAt("HDSD00.12.489")_"^"_arr.GetAt("HDSD00.12.504")_"^"_arr.GetAt("HDSD00.12.519")_"^"_arr.GetAt("HDSD00.12.534")

	// 174.4 手术操作日期时间 NUMBER(14) 必填 格式：yyyymmddhhmiss
	// 手术及操作开始日期1~10
	s OperDate = arr.GetAt("HDSD00.12.106")_"^"_arr.GetAt("HDSD00.12.411")_"^"_arr.GetAt("HDSD00.12.426")_"^"_arr.GetAt("HDSD00.12.441")_"^"_arr.GetAt("HDSD00.12.456")_"^"_arr.GetAt("HDSD00.12.471")_"^"_arr.GetAt("HDSD00.12.486")_"^"_arr.GetAt("HDSD00.12.501")_"^"_arr.GetAt("HDSD00.12.516")_"^"_arr.GetAt("HDSD00.12.531")

	// 174.7手术级别 NUMBER(1) 必填 参考《手术级别》
	// 手术级别代码 1~10
	s OperLevelCode = arr.GetAt("HDSD00.12.107")_"^"_arr.GetAt("HDSD00.12.413")_"^"_arr.GetAt("HDSD00.12.428")_"^"_arr.GetAt("HDSD00.12.443")_"^"_arr.GetAt("HDSD00.12.458")_"^"_arr.GetAt("HDSD00.12.473")_"^"_arr.GetAt("HDSD00.12.488")_"^"_arr.GetAt("HDSD00.12.503")_"^"_arr.GetAt("HDSD00.12.518")_"^"_arr.GetAt("HDSD00.12.533")
	// 手术级别描述 1~10
	s OperLevelDesc = arr.GetAt("HDSD00.12.605")_"^"_arr.GetAt("HDSD00.12.606")_"^"_arr.GetAt("HDSD00.12.607")_"^"_arr.GetAt("HDSD00.12.608")_"^"_arr.GetAt("HDSD00.12.609")_"^"_arr.GetAt("HDSD00.12.610")_"^"_arr.GetAt("HDSD00.12.611")_"^"_arr.GetAt("HDSD00.12.612")_"^"_arr.GetAt("HDSD00.12.613")_"^"_arr.GetAt("HDSD00.12.614")
	
	// 174.8手术切口等级代码 VARCHAR2(1) 必填 参考《手术切口等级》
	// 手术切口类别代码 1~10
	s OperCutCode = arr.GetAt("HDSD00.12.108")_"^"_arr.GetAt("HDSD00.12.421")_"^"_arr.GetAt("HDSD00.12.436")_"^"_arr.GetAt("HDSD00.12.451")_"^"_arr.GetAt("HDSD00.12.466")_"^"_arr.GetAt("HDSD00.12.481")_"^"_arr.GetAt("HDSD00.12.496")_"^"_arr.GetAt("HDSD00.12.511")_"^"_arr.GetAt("HDSD00.12.526")_"^"_arr.GetAt("HDSD00.12.541")
	// 手术切口类别描述 1~10
	s OperCutDesc = arr.GetAt("HDSD00.12.615")_"^"_arr.GetAt("HDSD00.12.617")_"^"_arr.GetAt("HDSD00.12.619")_"^"_arr.GetAt("HDSD00.12.621")_"^"_arr.GetAt("HDSD00.12.623")_"^"_arr.GetAt("HDSD00.12.625")_"^"_arr.GetAt("HDSD00.12.627")_"^"_arr.GetAt("HDSD00.12.629")_"^"_arr.GetAt("HDSD00.12.631")_"^"_arr.GetAt("HDSD00.12.633")
	
	// 174.10切口愈合类别代码 VARCHAR2(1) 必填 参考《切口愈合类别》
	// 切口愈合等级代码 1~10
	s CutHealCode = arr.GetAt("HDSD00.12.093")_"^"_arr.GetAt("HDSD00.12.422")_"^"_arr.GetAt("HDSD00.12.437")_"^"_arr.GetAt("HDSD00.12.452")_"^"_arr.GetAt("HDSD00.12.467")_"^"_arr.GetAt("HDSD00.12.482")_"^"_arr.GetAt("HDSD00.12.497")_"^"_arr.GetAt("HDSD00.12.512")_"^"_arr.GetAt("HDSD00.12.527")_"^"_arr.GetAt("HDSD00.12.542")
	// 切口愈合等级描述 1~10
	s CutHealDesc = arr.GetAt("HDSD00.12.616")_"^"_arr.GetAt("HDSD00.12.618")_"^"_arr.GetAt("HDSD00.12.620")_"^"_arr.GetAt("HDSD00.12.622")_"^"_arr.GetAt("HDSD00.12.624")_"^"_arr.GetAt("HDSD00.12.626")_"^"_arr.GetAt("HDSD00.12.628")_"^"_arr.GetAt("HDSD00.12.630")_"^"_arr.GetAt("HDSD00.12.632")_"^"_arr.GetAt("HDSD00.12.634")
	
	// 174.12 手术者代码 VARCHAR2(30) 必填
	// 手术者代码 1~10
	s OperDocCode = arr.GetAt("HDSD00.12.407")_"^"_arr.GetAt("HDSD00.12.415")_"^"_arr.GetAt("HDSD00.12.430")_"^"_arr.GetAt("HDSD00.12.445")_"^"_arr.GetAt("HDSD00.12.460")_"^"_arr.GetAt("HDSD00.12.475")_"^"_arr.GetAt("HDSD00.12.490")_"^"_arr.GetAt("HDSD00.12.505")_"^"_arr.GetAt("HDSD00.12.520")_"^"_arr.GetAt("HDSD00.12.535")
	// 174.13 手术者姓名 VARCHAR2(50) 必填
	// 手术者姓名 1~10
	s OperDoc = arr.GetAt("HDSD00.12.109")_"^"_arr.GetAt("HDSD00.12.416")_"^"_arr.GetAt("HDSD00.12.431")_"^"_arr.GetAt("HDSD00.12.446")_"^"_arr.GetAt("HDSD00.12.461")_"^"_arr.GetAt("HDSD00.12.476")_"^"_arr.GetAt("HDSD00.12.491")_"^"_arr.GetAt("HDSD00.12.506")_"^"_arr.GetAt("HDSD00.12.521")_"^"_arr.GetAt("HDSD00.12.536")
	
	// 174.14 Ⅰ助姓名 VARCHAR2(50) 必填
	// Ⅰ助代码
	s FirstAssCode = ""
	// Ⅰ助姓名 1~10
	s FirstAss = arr.GetAt("HDSD00.12.001")_"^"_arr.GetAt("HDSD00.12.418")_"^"_arr.GetAt("HDSD00.12.433")_"^"_arr.GetAt("HDSD00.12.448")_"^"_arr.GetAt("HDSD00.12.463")_"^"_arr.GetAt("HDSD00.12.478")_"^"_arr.GetAt("HDSD00.12.493")_"^"_arr.GetAt("HDSD00.12.508")_"^"_arr.GetAt("HDSD00.12.523")_"^"_arr.GetAt("HDSD00.12.538")	

	// 174.15 Ⅱ助姓名 VARCHAR2(50) 必填
	// Ⅱ助代码
	s SecondAssCode = ""
	// Ⅱ助姓名 1~10
	s SecondAss = arr.GetAt("HDSD00.12.002")_"^"_arr.GetAt("HDSD00.12.420")_"^"_arr.GetAt("HDSD00.12.435")_"^"_arr.GetAt("HDSD00.12.450")_"^"_arr.GetAt("HDSD00.12.465")_"^"_arr.GetAt("HDSD00.12.480")_"^"_arr.GetAt("HDSD00.12.495")_"^"_arr.GetAt("HDSD00.12.510")_"^"_arr.GetAt("HDSD00.12.525")_"^"_arr.GetAt("HDSD00.12.540")
	
	// 174.16 麻醉方式 VARCHAR2(2) 必填 参考《麻醉方式》
	// 麻醉方式代码 1~10
	s AnamethodCode = arr.GetAt("HDSD00.12.080")_"^"_arr.GetAt("HDSD00.12.423")_"^"_arr.GetAt("HDSD00.12.438")_"^"_arr.GetAt("HDSD00.12.453")_"^"_arr.GetAt("HDSD00.12.468")_"^"_arr.GetAt("HDSD00.12.483")_"^"_arr.GetAt("HDSD00.12.498")_"^"_arr.GetAt("HDSD00.12.513")_"^"_arr.GetAt("HDSD00.12.528")_"^"_arr.GetAt("HDSD00.12.543")
	
	// 麻醉方式描述 1~10
	s AnamethodDesc = arr.GetAt("HDSD00.12.852")_"^"_arr.GetAt("HDSD00.12.853")_"^"_arr.GetAt("HDSD00.12.854")_"^"_arr.GetAt("HDSD00.12.855")_"^"_arr.GetAt("HDSD00.12.856")_"^"_arr.GetAt("HDSD00.12.857")_"^"_arr.GetAt("HDSD00.12.858")_"^"_arr.GetAt("HDSD00.12.859")_"^"_arr.GetAt("HDSD00.12.860")_"^"_arr.GetAt("HDSD00.12.861")
	
	// 174.17 麻醉医师 VARCHAR2(50) 必填
	// 麻醉医师姓名 1~10
	s AnaDoc = arr.GetAt("HDSD00.12.081")_"^"_arr.GetAt("HDSD00.12.424")_"^"_arr.GetAt("HDSD00.12.439")_"^"_arr.GetAt("HDSD00.12.454")_"^"_arr.GetAt("HDSD00.12.469")_"^"_arr.GetAt("HDSD00.12.484")_"^"_arr.GetAt("HDSD00.12.499")_"^"_arr.GetAt("HDSD00.12.514")_"^"_arr.GetAt("HDSD00.12.529")_"^"_arr.GetAt("HDSD00.12.544")
	
	q OperCode_$C(1)_OperDesc_$C(1)_OperDate_$C(1)_OperLevelCode_$C(1)_OperLevelDesc_$C(1)_OperCutCode_$C(1)_OperCutDesc_$C(1)_CutHealCode_$C(1)_CutHealDesc_$C(1)_OperDocCode_$C(1)_OperDoc_$C(1)_FirstAssCode_$C(1)_FirstAss_$C(1)_SecondAssCode_$C(1)_SecondAss_$C(1)_AnamethodCode_$C(1)_AnamethodDesc_$C(1)_AnaDoc
}

/// Creator：		YK
/// CreatDate：    	2022-4-12
/// Description: 	返回对照后的医保诊断编码和医保诊断描述
/// Input： 		DiagCode:诊断ICD编码
/// Output： 		DiagCode_"^"_DiagDesc
/// Others：		w ##class(EMRservice.BL.Interface.RecordInfoToINSU).GetINSUDiagInfo("2485371")
ClassMethod GetINSUDiagInfo(AEpisodeID As %String, DiagCode As %String)
{
	q:(AEpisodeID="")||(DiagCode="") ""
	
	s DisDept = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
	s DeptRowID = $P(DisDept,"^",1)
	s HospDr = $P(^CTLOC(DeptRowID),"^",22)
	
	s AdmDateTimeInBed=##class(web.DHCDischargeHistory).GetAdminDateTime(AEpisodeID)
	s:(AdmDateTimeInBed="^") AdmDateTimeInBed=""
	if (AdmDateTimeInBed'="")
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),"^",1),3)
	}
	s ActDate = AdmDateInBed
	
	//s DiagCode = $ZCVT(DiagCode,"U")
	s rowid="",DiagRowID=""
	For
	{
		s DiagRowID = $O(^MRC("ID",0,"ICD",DiagCode,DiagRowID),-1)
		q:(DiagRowID="")
		
		s Flag = ##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("SQLUser.MRC_ICDDx",DiagRowID,HospDr,ActDate)
		continue:(Flag'="Y")
		s rowid = DiagRowID
	}
	q:(rowid="") ""
	
	s INSUDiagInfo = ##class(web.DHCINSUPort).GetStdInfoByMRCICDDxRowId(rowid,HospDr,"",ActDate,"")
	q INSUDiagInfo
}

/// Creator：		YK
/// CreatDate：    	2022-4-12
/// Description: 	返回对照后的医保手术编码和医保手术描述
/// Input： 		OperCode:诊断ICD编码
/// Output： 		OperCode_"^"_DiagDesc
/// Others：		w ##class(EMRservice.BL.Interface.RecordInfoToINSU).GetINSUOperInfo("2485371")
ClassMethod GetINSUOperInfo(AEpisodeID As %String, OperCode As %String)
{
	q:(AEpisodeID="")||(OperCode="") ""
	
	s rowid = $O(^ORC("OPER",0,"ICD10",OperCode,""),-1)
	if (rowid="")
	{
		s OperCode = $ZCVT(OperCode,"U")
		s rowid = $O(^ORC("OPER",0,"ICD10",OperCode,""),-1)
	}
	q:(rowid="") ""
	
	s DisDept = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDept(AEpisodeID)
	s DeptRowID = $P(DisDept,"^",1)
	s HospDr = $P(^CTLOC(DeptRowID),"^",22)
	
	s AdmDateTimeInBed=##class(web.DHCDischargeHistory).GetAdminDateTime(AEpisodeID)
	s:(AdmDateTimeInBed="^") AdmDateTimeInBed=""
	if (AdmDateTimeInBed'="")
	{
		s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed),"^",1),3)
	}
	s ActDate = AdmDateInBed
	s INSUOperInfo = ##class(web.DHCINSUPort).GetStdInfoByORCOperRowId(rowid,HospDr,"",ActDate,"1")
	
	q INSUOperInfo
}

/// Creator：		YK
/// CreatDate：    	2022-4-12
/// Description: 	转换标准日期格式
/// Input： 		ADateTime:日期
/// Output： 		
/// Others：		w ##class(EMRservice.BL.Interface.RecordInfoToINSU).ConvertStandDate("2485371")
ClassMethod ConvertStandDate(ADateTime As %String) As %String
{
	q:(ADateTime="") ""
	
	s ret = ""
	
	s ADate = $P(ADateTime," ",1)
	if (ADate["年")||(ADate["月")||(ADate["日")
	{
		s ADate = $TR($TR($TR(ADate,"年","-"),"月","-"),"日","")
	}
	
	s ATime = $P(ADateTime," ",2)
	if (ATime["时")&&(ATime["分")&&(ATime["秒")
	{
		s ATime = $TR($TR($TR(ATime,"时",":"),"分",":"),"秒","")
	}
	elseif (ATime["时")&&(ATime["分")
	{
		s ATime = $TR($TR(ATime,"时",":"),"分","")
	}
	elseif (ATime["时")
	{
		s ATime = $TR(ATime,"时",":")
	}
	
	// 兼容没时间
	s:($L(ATime)=0) ATime = "00:00:00"
	// 兼容只有小时
	s:($L(ATime)=2) ATime = ATime_":00:00"
	// 兼容只有小时/分钟
	s:($L(ATime)=5) ATime = ATime_":00"
	
	s ret = ADate_" "_ATime
	
	q ret
}

}
