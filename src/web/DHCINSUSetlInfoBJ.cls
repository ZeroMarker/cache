Class web.DHCINSUSetlInfoBJ Extends %RegisteredObject
{

/// ///////////////////////////////////////////////////////////////////////////////////////////
/// 4101-1 结算清单信息-单行信息－－结算信息
/// 	一次就诊多次结算时，结算清单是否合并，要项目经理和医院核实 20210322。
/// ##Class(web.DHCINSUOutArray).GetPatEprValueByCode(EpisodeID,InsuDivID,InputOBJ)
/// 	EpisodeID:就诊号
/// InsuDivID:医保结算表ID
/// 	InputOBJ:没有用删除
/// 负责人：交付中心、计费医保、电子病历共同完成（包含费用信息、病历首页信息）
/// w ##class(web.DHCINSUSetlInfoBJ).GetPatBaseInfo("13473","","").GetAt("SEX")
/// 	可使用的变量名
/// .d InArgOBJ.SetAt($p(InputInfo,"^",8),"PAADM")
/// .d InArgOBJ.SetAt($p(InputInfo,"^",8),"EpisodeID")
/// 	.d InArgOBJ.SetAt($p(InputInfo,"^",9),"InsuDivID")
/// 	.d InArgOBJ.SetAt($p(InputInfo,"^",9),"InDivDr")
/// 	.d:BILLNo'="" InArgOBJ.SetAt(BILLNo,"BILLNo")
/// zw ##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap("13473","CodeData","医保版^V2.0","医保版^V2.0")
/// 患者基本信息
ClassMethod GetPatBaseInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ArrayOfDataTypes
{
	s ^ZDL("GetPatBaseInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	s OutArray=##class(%ArrayOfDataTypes).%New()
	d OutArray.SetAt("-1","Sucess")
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 
	Set arr=##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap(EpisodeID,"CodeData","医保版^V2.0","医保版^V2.0") //取病案编目数据
	set arrEmr=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(EpisodeID,"HDSD.00.11") //取首页信息

	d OutArray.SetAt("1","M_CLASS")	//医疗类别
	d OutArray.SetAt("1","PATIENT_TYPE")	//病人类别
	d OutArray.SetAt(arr.GetAt("P01.004.01"),"CASE_CODE")	//病案号
	d OutArray.SetAt(arr.GetAt("P01.007.01"),"NAME")	//姓名
	d OutArray.SetAt(arr.GetAt("P01.008.02"),"SEX")	//性别
	d OutArray.SetAt(arr.GetAt("P01.009.01"),"BIRTHDAY")	//出生日期
	d OutArray.SetAt(arr.GetAt("P01.010.01"),"AGE")	//年龄（岁）
	d OutArray.SetAt("","AGE_DAY")	//年龄不足1周岁天数
	d OutArray.SetAt(arrEmr.GetAt("HDSD00.11.036"),"NATIONALITY")	//国籍
	d OutArray.SetAt(arr.GetAt("P01.021.02"),"NATION_CODE")	//民族
	d OutArray.SetAt($p(..GetTypeByAdm(EpisodeID),"^",2),"DOCUMENT_TYPE")	//患者证件类型
	d OutArray.SetAt($p(..GetTypeByAdm(EpisodeID),"^",1),"ID_NUMBER")	//患者证件号码
	d OutArray.SetAt(arr.GetAt("P01.025.01"),"ADD_PROVINCE")	//现住址省（区、市）
	d OutArray.SetAt(arr.GetAt("P01.026.01"),"ADD_CITY")	//现住址市
	d OutArray.SetAt(arr.GetAt("P01.027.01"),"ADD_COUNTY")	//现住址县
	d OutArray.SetAt(arr.GetAt("P01.028.01"),"ADD_OTHER")	//现住址详细地址
	d OutArray.SetAt(arr.GetAt("P01.023.02"),"VOCATION")	//职业
	d OutArray.SetAt(arr.GetAt("P01.036.01"),"UNIT_NAME")	//工作单位名称
	d OutArray.SetAt(arr.GetAt("P01.036.01"),"UNIT_ADDRESS")	//工作单位地址
	d OutArray.SetAt(arr.GetAt("P01.037.01"),"UNIT_PHONE_NUMBER")	//工作单位电话
	d OutArray.SetAt(arr.GetAt("P01.038.01"),"UNIT_ZIP_CODE")	//工作单位邮政编码
	d OutArray.SetAt(arr.GetAt("P01.039.01"),"LINK_NAME")	//联系人姓名
	d OutArray.SetAt(arr.GetAt("P01.040.02"),"LINK_RELATION")	//联系人关系代码
	d OutArray.SetAt("-","LINK_ADD_PROVINCE")	//联系人住址省（区、市）
	d OutArray.SetAt("-","LINK_ADD_CITY")	//联系人住址市
	d OutArray.SetAt("-","LINK_ADD_COUNTY")	//联系人住址县
	d OutArray.SetAt(arr.GetAt("P01.041.01"),"LINK_ADD_OTHER")	//联系人住址详细地址
	d OutArray.SetAt(arr.GetAt("P01.042.01"),"LINK_PHONE_NUMBER")	//联系人电话
	d OutArray.SetAt("","SPEC_PERSON_TYPE")	//特殊人员类型
	d OutArray.SetAt("","BABY_TYPE")	//新生儿入院类型
	d OutArray.SetAt("","BABY_WEIGHT_INHOS")	//新生儿入院体重
	
	d OutArray.SetAt("0","Sucess")

	q OutArray
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetBabyInfo("13473","","")
/// 新生儿信息
ClassMethod GetBabyInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 
	Set arr=##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap(EpisodeID,"CodeData","医保版^V2.0","医保版^V2.0") //取病案编目数据
	set arrEmr=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(EpisodeID,"HDSD.00.11") //取首页信息
	set ^Temp("GetBabyInfo",1)=""
	set ^Temp("GetBabyInfo",2)=""
	set ^Temp("GetBabyInfo",3)=""
	set ^Temp("GetBabyInfo",4)="" 
		s Count=4
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			q:^Temp("GetBabyInfo",sub)=""
			d objSingle.SetAt(^Temp("GetBabyInfo",i),"BABY_WEIGHT_BORN")					
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetSpecTreatInfo("","","")
/// 门诊慢特病诊疗信息
ClassMethod GetSpecTreatInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 

		s Count=1
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			d objSingle.SetAt("诊断科别代码","DIAG_SECTION_CODE")		
			d objSingle.SetAt("就诊日期","DIAG_DATE")	
			d objSingle.SetAt("手术及操作名称","OPERATE_NAME")	
			d objSingle.SetAt("手术及操作代码","OPERATE_CODE")	
			
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetInHosTreatInfo("13473","","").GetAt("CLIN_DIAG_CODE_WEST")
/// 住院治疗信息
ClassMethod GetInHosTreatInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ArrayOfDataTypes
{
	s ^ZDL("GetPatBaseInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	s OutArray=##class(%ArrayOfDataTypes).%New()
	d OutArray.SetAt("-1","Sucess")
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 
	Set arr=##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap(EpisodeID,"CodeData","医保版^V2.0","医保版^V2.0") //取病案编目数据
	set arrEmr=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(EpisodeID,"HDSD.00.11") //取首页信息
	b ;1
	d OutArray.SetAt("1","IN_HOS_TYPE")			//1	住院医疗类别	
	d OutArray.SetAt(arr.GetAt("P01.043.02"),"IN_HOS_MODE")			//2	入院途径	
	d OutArray.SetAt(arrEmr.GetAt("HDSD00.11.592"),"TREAT_TYPE")			//3	治疗类别 HDSD00.11.592	
	d OutArray.SetAt(arr.GetAt("P01.044.01"),"INHOS_DATE")			//4	入院时间	
	d OutArray.SetAt(arr.GetAt("P01.045.02"),"INHOS_SECTION_CODE")			//5	入院科别代码
	//d OutArray.SetAt("1","")		////住院转科信息【PASSED_SECTION_INFO】【可多行】【实际业务不涉及该内容，可不生成PASSED_SECTION_INFO节点】			
	//d OutArray.SetAt("1","")		////PASSED_SECTION_CODE	6.1	转科科别代码	
	d OutArray.SetAt(arr.GetAt("P01.048.01"),"OUT_HOS_DATE")		//7	出院时间	
	d OutArray.SetAt(arr.GetAt("P01.049.02"),"OUT_HOS_SECTION_CODE")		//8	出院科别代码	
	d OutArray.SetAt(arr.GetAt("P01.051.01"),"IN_HOS_DAYS")			//	实际住院天数	
	d OutArray.SetAt(arr.GetAt("D01.002.01"),"CLIN_DIAG_CODE_WEST")			//10	门(急)诊诊断编码(西医)	
	d OutArray.SetAt(arr.GetAt("D01.001.01"),"CLIN_DIAG_NAME_WEST")			//11	门（急）诊诊断名称（西医）	
	d OutArray.SetAt("","CLIN_DIAG_CODE_CN")		//12	门(急)诊诊断编码(中医)	
	d OutArray.SetAt("","CLIN_DIAG_NAME_CN")		//13	门（急）诊诊断名称(中医)	
	d OutArray.SetAt(arr.GetAt("D03.001.01"),"WEST_MAIN_DIAG_NAME")			//14	出院西医主要诊断名称	
	d OutArray.SetAt(arr.GetAt("D03.001.02"),"WEST_MAIN_DIAG_CODE")			//15	出院西医主要诊断疾病代码	
	d OutArray.SetAt(arr.GetAt("D03.006.01"),"WEST_MAIN_DIAG_EVALUE")		//16	西医主要���断入院病情	
	//d OutArray.SetAt("1","")		//西医出院其他诊断信息【WEST_DIAG_INFO】【可多行】【实际业务不涉及该内容，可不生成WEST_DIAG_INFO节点】			
	//d OutArray.SetAt("1","")		//OUT_HOS_DIAG_NAME	17.1	出院西医诊断名称	
	//d OutArray.SetAt("1","")		//OUT_HOS_DIAG_CODE	17.2	疾病代码	
	//d OutArray.SetAt("1","")		//IN_HOS_DIAG_EVALUE	17.3	入院病情	
	d OutArray.SetAt("","CN_MAIN_DIAG_NAME")		//18	出院中医主病诊断名称	
	d OutArray.SetAt("","CN_MAIN_DIAG_CODE")		//19	出院中医主病诊断疾病代码	
	d OutArray.SetAt("","CN_MAIN_DIAG_EVALUE")			//20	中医主病诊断入院病情	
	//d OutArray.SetAt("1","")		//中医出院主症信息【CN_DIAG_INFO】【可多行】【实际业务不涉及该内容，可不生成CN_DIAG_INFO节点】			
	//d OutArray.SetAt("1","")		//OUT_HOS_DIAG_NAME	21.1	出院中医诊断名称	
	//d OutArray.SetAt("1","")		//OUT_HOS_DIAG_CODE	21.2	疾病代码	
	//d OutArray.SetAt("1","")		//IN_HOS_DIAG_EVALUE	21.3	入院病情	
	d OutArray.SetAt(arr.GetAt("O01.001.01"),"MAIN_OPERATE_NAME")		//22	主要手术及操作名称	
	d OutArray.SetAt(arr.GetAt("O01.002.01"),"MAIN_OPERATE_CODE")		//23	主要手术及操作编码	
	d OutArray.SetAt(arr.GetAt("O01.019.01"),"ANESTHESIA_MODE")			//24	麻醉方式	
	d OutArray.SetAt(arr.GetAt("O01.007.01"),"OPE_DOCT_NAME")		//25	术者医师姓名	
	d OutArray.SetAt(..GetDocNumById(arr.GetAt("O01.015.01")),"OPE_DOCT_CODE")		//26	术者医师代码	
	d OutArray.SetAt(arr.GetAt("O01.011.01"),"ANES_DOCT_NAME")			//27	麻醉医师姓名	
	d OutArray.SetAt(..GetDocNumById(arr.GetAt("O01.018.01")),"ANES_DOCT_CODE")			//28	麻醉医师代码	
	d OutArray.SetAt(arr.GetAt("O01.003.01"),"OPERATE_DATE_START")			//29	手术及操作开始时间	
	d OutArray.SetAt(arr.GetAt("O01.005.01"),"OPERATE_DATE_END")		//30	手术及操作结束时间	
	d OutArray.SetAt("","ANES_DATE_START")			//31	麻醉开始时间	
	d OutArray.SetAt("","ANES_DATE_END")		//32	麻醉结束时间	
	//d OutArray.SetAt("1","")		//其他手术及操作信息【OPERATE_INFO】【可多行】【实际业务不涉及该内容，可不生成OPERATE_INFO节点】			
	//d OutArray.SetAt("1","")		//OPERATE_NAME	33.1	手术及操作名称	
	//d OutArray.SetAt("1","")		//OPERATE_CODE	33.2	手术及操作编码	
	//d OutArray.SetAt("1","")		//ANESTHESIA_MODE	33.3	麻醉方式	
	//d OutArray.SetAt("1","")		//OPE_DOCT_NAME	33.4	术者医师姓名	
	//d OutArray.SetAt("1","")		//OPE_DOCT_CODE	33.5	术者医师代码	
	//d OutArray.SetAt("1","")		//ANES_DOCT_NAME	33.6	麻醉医师姓名	
	//d OutArray.SetAt("1","")		//ANES_DOCT_CODE	33.7	麻醉医师代码	
	//d OutArray.SetAt("1","")		//OPERATE_DATE_START	33.8	手术及操作开始时间	
	//d OutArray.SetAt("1","")		//OPERATE_DATE_END	33.9	手术及操作结束时间	
	//d OutArray.SetAt("1","")		//ANES_DATE_START	33.1	麻醉开始时间	
	//d OutArray.SetAt("1","")		//ANES_DATE_END	33.11	麻醉结束时间	
	d OutArray.SetAt("","APNEA_USE_DAYS")			//32	呼吸机使用天数	
	d OutArray.SetAt(arr.GetAt("P01.124.01"),"APNEA_USE_HOURS")			//33	呼吸机使用小时数	
	d OutArray.SetAt(arr.GetAt("P01.125.01"),"APNEA_USE_MINUTES")		//34	呼吸机使用分钟数	
	d OutArray.SetAt(arr.GetAt("P01.076.01"),"BEF_HOS_COMA_DAYS")		//35	颅脑损伤患者入院前昏迷天数	
	d OutArray.SetAt(arr.GetAt("P01.077.01"),"BEF_HOS_COMA_HOURS")			//36	颅脑损伤患者入院前昏迷时小时数	
	d OutArray.SetAt(arr.GetAt("P01.078.01"),"BEF_HOS_COMA_MINUTES")		//37	颅脑损伤患者入院前昏迷分钟数	
	d OutArray.SetAt(arr.GetAt("P01.079.01"),"IN_HOS_COMA_DAYS")		//38	颅脑损伤患者入院后昏迷天数	
	d OutArray.SetAt(arr.GetAt("P01.080.01"),"IN_HOS_COMA_HOURS")		//39	颅脑损伤患者入院后昏迷小时数	
	d OutArray.SetAt(arr.GetAt("P01.081.01"),"IN_HOS_COMA_MINUTES")			//40	颅脑损伤患者入院后昏迷分钟数	
	//d OutArray.SetAt("1","")		//重症监护信息【ICU_INFO】【可多行】【实际业务不涉及该内容，可不生成ICU_INFO节点】			
	//d OutArray.SetAt("1","")		//ICU_TYPE	41.1	重症监护病房类型	
	//d OutArray.SetAt("1","")		//TO_ICU_TIME	41.2	监护室进入日期时间	
	//d OutArray.SetAt("1","")		//OUT_ICU_TIME	41.3	监护室退出日期时间	
	//d OutArray.SetAt("1","")		//IN_ICU_LENGTH	41.4	监护时间	
	//d OutArray.SetAt("1","")		//在院用血信息【USE_BLOOD _INFO】【可多行】【实际业务不涉及该内容，可不生成USE_BLOOD _INFO节点】			
	//d OutArray.SetAt("1","")		//TRANSFUSE_CLASS	42.1	输血品种	
	//d OutArray.SetAt("1","")		//TRANSFUSE_AMOUNT	42.2	输血量	
	//d OutArray.SetAt("1","")		//TRANSFUSE_UNIT	42.3	输血计量单位
	set NurseDay=..GetCareDays(EpisodeID)	
	d OutArray.SetAt($p($p(NurseDay,"^",4),"|",2),"SPEC_NURSE_DAYS")			//43	特级护理天数	
	d OutArray.SetAt($p($p(NurseDay,"^",1),"|",2),"FIRST_NURSE_DAYS")		//44	一级护理天数	
	d OutArray.SetAt($p($p(NurseDay,"^",2),"|",2),"SECOND_NURSE_DAYS")		//45	二级护理天数	
	d OutArray.SetAt($p($p(NurseDay,"^",3),"|",2),"THIRD_NURSE_DAYS")		//46	三级护理天数	
	d OutArray.SetAt(arr.GetAt("P01.070.02"),"OUT_HOS_MODE_CODE")		//47	离院方式代码	
	d OutArray.SetAt(arr.GetAt("P01.149.01"),"TRANS_HOS_NAME")			//48	医嘱转院/社区/卫生院机构名称	
	//d OutArray.SetAt(arr.GetAt("P00650003"),"TRANS_HOS_ID")		//49	医嘱转院/社区/卫生院机构代码	
	d OutArray.SetAt(arr.GetAt("P01.074.02"),"REHOS_PLAN_FLAG")			//50	出院31日内再住院计划标识	
	d OutArray.SetAt(arr.GetAt("P01.075.01"),"REHOS_PLAN_AIM")			//51	31日内计划再住院目的	
	d OutArray.SetAt(..GetDocNumById(arr.GetAt("P01.060.02")),"ATTECNING_CODE")			//52	主诊医师代码	
	d OutArray.SetAt(arr.GetAt("P01.060.01"),"ATTECNING_NAME")			//53	主诊医师姓名	
	d OutArray.SetAt(..GetDocNumByCode(arr.GetAt("P01.062.02")),"PRI_NURSE_CODE")			//54	责任护士代码	
	d OutArray.SetAt(arr.GetAt("P01.062.01"),"PRI_NURSE_NAME")			//55	责任护士姓名	
	

	
	d OutArray.SetAt("0","Sucess")

	q OutArray
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetChargeInfo("","","")
/// 医疗收费信息
ClassMethod GetChargeInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ArrayOfDataTypes
{
	s ^ZDL("GetChargeInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	s OutArray=##class(%ArrayOfDataTypes).%New()
	d OutArray.SetAt("-1","Sucess")
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 
	
	d OutArray.SetAt("业务流水号","BUSINESS_NO")			
	d OutArray.SetAt("票据代码","BILL_CODE")			
	d OutArray.SetAt("票据号码","FEE_NO")				

	d OutArray.SetAt("0","Sucess")

	q OutArray
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetPassedSectionInfo("","","")
/// 住院转科信息
ClassMethod GetPassedSectionInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 
	Set arr=##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap(EpisodeID,"CodeData","医保版^V2.0","医保版^V2.0") //取病案编目数据
	set arrEmr=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(EpisodeID,"HDSD.00.11") //取首页信息
	
	set TransDep=arr.GetAt("P01.047.01")
	if (TransDep'="") {
		s Count=$L(TransDep,",")
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			d objSingle.SetAt($p(TransDep,",",sub),"PASSED_SECTION_CODE")		
			
			d OutList.Insert(objSingle)
		}
	}
		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetWestDiagInfo("13473","","")
/// 西医出院其他诊断信息
ClassMethod GetWestDiagInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = ""
	Set arr=##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap(EpisodeID,"CodeData","医保版^V2.0","医保版^V2.0") //取病案编目数据
	set arrEmr=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(EpisodeID,"HDSD.00.11") //取首页信息
	 
		s Count=21
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			s i=sub
			i (sub<10) {s i="0"_i}
			b ;1
			q:arr.GetAt("D04.001."_i)=""
			d objSingle.SetAt(arr.GetAt("D04.001."_i),"OUT_HOS_DIAG_NAME")	
			d objSingle.SetAt(arr.GetAt("D04.002."_i),"OUT_HOS_DIAG_CODE")	
			d objSingle.SetAt(arr.GetAt("D04.006."_i),"IN_HOS_DIAG_EVALUE")		
			
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetCNDiagInfo("","","")
/// 中医出院主症信息
ClassMethod GetCNDiagInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 

		s Count=2
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			d objSingle.SetAt("","OUT_HOS_DIAG_NAME")	
			d objSingle.SetAt("","OUT_HOS_DIAG_CODE")	
			d objSingle.SetAt("","IN_HOS_DIAG_EVALUE")		
			
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetOperateInfo("13473","","")
/// 其他手术及操作信息
ClassMethod GetOperateInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = ""
	Set arr=##class(MA.IPMR.FPS.DataMasterSrv).GetDataItemValueMap(EpisodeID,"CodeData","医保版^V2.0","医保版^V2.0") //取病案编目数据
	set arrEmr=##class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory(EpisodeID,"HDSD.00.11") //取首页信息 

		s Count=39
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			s i=sub+1
			i (i<10) {s i="0"_i}
			q:arr.GetAt("O01.001"_i)=""
			d objSingle.SetAt(arr.GetAt("O01.001"_i),"OPERATE_NAME")		//手术及操作名称
			d objSingle.SetAt(arr.GetAt("O01.002"_i),"OPERATE_CODE")		//手术及操作编码
			d objSingle.SetAt(arr.GetAt("O01.019"_i),"ANESTHESIA_MODE")		//	麻醉方式
			d objSingle.SetAt(arr.GetAt("O01.007"_i),"OPE_DOCT_NAME")		//术者医师姓名
			d objSingle.SetAt(..GetDocNumById(arr.GetAt("O01.015"_i)),"OPE_DOCT_CODE")		//术者医师代码
			d objSingle.SetAt(arr.GetAt("O01.011"_i),"ANES_DOCT_NAME")		//	麻醉医师姓名
			d objSingle.SetAt(..GetDocNumById(arr.GetAt("O01.018"_i)),"ANES_DOCT_CODE")		//	麻醉医师代码
			d objSingle.SetAt(arr.GetAt("O01.003"_i),"OPERATE_DATE_START")		//	手术及操作开始时间
			d objSingle.SetAt(arr.GetAt("O01.005"_i),"OPERATE_DATE_END")		//手术及操作结束时间
			d objSingle.SetAt("","ANES_DATE_START")		//	麻醉开始时间
			d objSingle.SetAt("","ANES_DATE_END")		//麻醉结束时间
	
			
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetICUInfo("","","")
/// 重症监护信息
ClassMethod GetICUInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 

		s Count=2
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			
			d objSingle.SetAt("","ICU_TYPE")		//重症监护病房类型
			d objSingle.SetAt("","TO_ICU_TIME")		//监护室进入日期时间
			d objSingle.SetAt("","OUT_ICU_TIME")		//监护室退出日期时间
			d objSingle.SetAt("","IN_ICU_LENGTH")		//监护时间

	
			
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// w ##class(web.DHCINSUSetlInfoBJ).GetUseBloodInfo("","","")
/// 在院用血信息
ClassMethod GetUseBloodInfo(EpisodeID, InsuDivID = "", ExpStr = "") As %ListOfDataTypes
{
	s ^ZDL("GetBabyInfo")=EpisodeID_"^"_InsuDivID_"^"_ExpStr
	
	s OutList=##class(%ListOfDataTypes).%New()
	d OutList.SetAt("-1","没有数据")
	
	//q:InsuDivID="" OutArray
	s PBRowID = ""
	s PrtRowID = "" 

		s Count=2
		f sub=1:1:Count
		{
			s objSingle=##class(%ArrayOfDataTypes).%New()
			
			d objSingle.SetAt("","TRANSFUSE_CLASS")		//输血品种
			d objSingle.SetAt("","TRANSFUSE_AMOUNT")		//输血量
			d objSingle.SetAt("","TRANSFUSE_UNIT")		//输血计量单位
	
			
			d OutList.Insert(objSingle)
		}

		d OutList.SetAt("0","Sucess")
	q OutList
}

/// Creator: gzh
/// CreateDate: 2020.1.2
/// Description: 获得到今天各护理级别天数
/// Input: EpisodeID:就诊号
/// Return: 特级护理|0^一级护理|2^二级护理 |0^三级护理 |0
/// Other: w ##Class(Nur.DHCNurInterface).GetCareDays("48247")
/// w ##Class(web.DHCINSUSetlInfoBJ).GetCareDays("13473")
ClassMethod GetCareDays(EpisodeID)
{
	 s str=""
	 s AdmDateTime=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	 i AdmDateTime'="" s AdmDate=$p(AdmDateTime,",",1)
	 s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	 q:AdmDate="" ""
	 s nursingLevel("特级护理")="2835||1"
	 s nursingLevel("一级护理")="2834||1"
	 s nursingLevel("二级护理")="2833||1"
	 s nursingLevel("三级护理")="2832||1"
 
	s name="" f  s name=$o(nursingLevel(name)) q:name=""  d
 	.s arcimIdStr=$g(nursingLevel(name))
	.s num=0
	.f i=1:1:$l(arcimIdStr,"^")  d
	..s arcimId=$p(arcimIdStr,"^",i)
	..f SttDat=AdmDate:1:+$h d
	...s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,SttDat,oeoriSub)) q:oeoriSub=""  d
	....s ordStatDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
	....q:ordStatDR=""
	....s ordStatCode=$p(^OEC("OSTAT",ordStatDR),"^",1)
	....q:(ordStatCode="C")
	....s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	.....s execSttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",1)
	.....q:execSttDate>+$h
	.....s execStatusCode=""
	.....s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
	.....s:execStatusId'="" execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)
	.....q:execStatusCode="D"
	.....s num=num+1
	.i str="" s str=name_"|"_num
	.e  s str=str_"^"_name_"|"_num

	q str
}

ClassMethod GetDocNumByCode(code)
{
	q:code="" "0"
	s (ssid,ssnum)=""
	s ssid=$o(^SSU("SSUSR",0,"SSUSR_Initials",code,""))
	q:ssid="" "0"
	s ssnum=$p(^SSU("SSUSR",ssid),"^",124)
	q ssnum
}

ClassMethod GetDocNumById(DocID)
{
	q:DocID="" "0"
	s ssnum=""
	s ssnum=$p(^SSU("SSUSR",DocID),"^",124)
	q ssnum
}

ClassMethod GetTypeByAdm(EpisodeID)
{
	q:EpisodeID="" ""
	s PAPMIDR = $p(^PAADM(EpisodeID),"^",1)
   	s sfzh=$p(^PAPER(PAPMIDR,"ALL"),"^",9)
   	s zjlxid=$p(^PAPER(PAPMIDR,"ALL"),"^",25)
   	s zjlx=$p(^PAC("CARD",zjlxid),"^",1)
   	q sfzh_"^"_zjlx
}

}
