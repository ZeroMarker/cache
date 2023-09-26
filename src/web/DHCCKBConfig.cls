Import sqluser

Class web.DHCCKBConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Author: qunianpeng
/// Desc:	数据配置初始化
/// Table： DHC_CKBCommonDiction
/// Other:  w ##class(web.DHCCKBConfig).Init()
ClassMethod Init()
{
	
	s knowObj={}
	d knowObj.%Set("ModelFlag","实体类别").%Set("AttrFlag","属性类别").%Set("DictionFlag","字典类别").%Set("KnowType","知识类别") 
	
	s itr=knowObj.%GetIterator()
	s ret=1
	while itr.%GetNext(.key,.val){
		s str="^"_key_"^"_val
		s id=##class(web.DHCCKBDiction).SaveDic(str)	
		i id<=0 s ret=0
		q:id<=0		
	}
	
	q $case(ret,1:"初始化成功",:"初始化失败")
}

/// Creator:	qunianpeng
/// CreatDate:	2019-11-13
/// Description:： 用于手动生成规则中的前提条件项目
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).SaveALLRulePrioItm()
ClassMethod SaveALLRulePrioItm()
{
 
	s rule=""	
	f  s rule=$o(^CT.CKB.PDSS.RuleD(rule))  q:rule=""  d
	.d ##class(web.DHCCKBRulePriority).SaveRulePriority(rule)
	
	q 0
}

/// d ##class(web.DHCCKBConfig).InitGlobalData()
ClassMethod InitGlobalData()
{
	s ^mdata("DHCCKBCD")=$o(^DHCCKBCD(""),-1)	//DHC_CKBCommonDiction
	s ^mdata("DHCCKBDLA")=$o(^DHCCKBDLA(""),-1)	//DHC_CKBDicLinkAttr	
	s ^mdata("DHCCKBRULE")=$o(^DHCCKBRULE(""),-1)	//DHCCKBRule
	s ^mdata("DHCCKBRD")=$o(^DHCCKBRD(""),-1)	//	DHCCKBRuleData
	s ^mdata("DHCCKBRULENODE")=$o(^DHCCKBRULENODE(""),-1)	//DHCCKBRuleNode
	s ^mdata("DHCCKBRULEDIC")=$o(^DHCCKBRULEDIC(""),-1)		//DHCCKBRULEDIC
	s ^mdata("DHCCKBRULEDATALOG")=$o(^DHCCKBRULEDATALOG(""),-1)	//DHCCKBRULEDATALOG
	s ^mdata("DHCCKBRULELOG")=$o(^DHCCKBRULELOG(""),-1)	//DHC_CKBRuleLog
	s ^mdata("DHCCKBCC")=$o(^DHCCKBCC(""),-1)	//User.DHCCKBComContrast	
	s ^mdata("DHCCKBDLG")=$o(^DHCCKBDLG(""),-1)	//User.DHCCKBDicLog
	s ^mdata("DHCCKBEXD")=$o(^DHCCKBEXD(""),-1)	//User.DHCCKBExtDiction
	s ^mdata("DHCCKBRULEACTION")=$o(^DHCCKBRULEACTION(""),-1)	// User.DHCCKBRuleAction
	s ^DHCCKBRULEDETAIL(0)=$o(^DHCCKBRULEDETAIL(""),-1)	// User.DHCCKBRuleDetail
	s ^mdata("DHCCKBRULEMAINTAIN")=$o(^DHCCKBRULEMAINTAIN(""),-1) // User.DHCCKBRuleMaintain
	s ^mdata("DHCCKBRULETEXT")=$o(^DHCCKBRULETEXT(""),-1)	// User.DHCCKBRuleText
	s ^mdata("DHCCKBTESTCASETEMP")=$o(^DHCCKBTCT(""),-1)	// User.DHCCKBTestCaseTemp
	s ^mdata("DHCCKBMONFUNLIST")=$o(^DHCCKBMFL(""),-1)			// DHCCKBMonFunList.cls
	s ^mdata("DHCCKBMONMASTER")=$o(^DHCCKBMM(""),-1)	//	DHCCKBMonMaster.cls
	s ^mdata("DHCCKBMONQUELIST")=$o(^DHCCKBMQL(""),-1)	//	DHCCKBMonQueList.cls	
	s ^mdata("DHCCKBMONRULELIST")=$o(^DHCCKBMRL(""),-1)	//	DHCCKBMonRuleList.cls
	s ^mdata("DHCCKBRULECOMPLEXARITH")=$o(^DHCCKBRULECOMPLEXARITH(""),-1)	// DHCCKBRuleComplexArith.cls
	s ^mdata("DHCCKBTEMPLATE")=$o(^DHCCKBTEM(""),-1)	//	DHCCKBTemplate.cls //22
	
	s ^mdata("DHCCKBDLAEXT")=$o(^DHCCKBDLAEXT(""),-1) // ^DHCCKBDLAEXT 外部属性表 User.DHCCKBDicExtLinkAttr 2020/12/123 增加以下
	s ^mdata("DHCCKBFB")=$o(^DHCCKBFB(""),-1) // ^DHCCKBFB 反馈表 User.DHCCKBFeedBack
 	s ^mdata("DHCCKBPLUGINTEMP")=$o(^DHCCKBPTEMP(""),-1) // // 插件模板 DHCCKBPluginTemp.cls
 	s ^mdata("DHCCKBRULECOPYLOG")=$o(^DHCCKBRCL(""),-1) // ^DHCCKBRCL 规则赋值表? User.DHCCKBRuleCopyLog
	s ^mdata("DHCCKBDLAEXT")=$o(^DHCCKBDLAEXT(""),-1)	// // 外部属性表 DHCCKBDicExtLinkAttr.cls
	s ^mdata("User.DHCCKBIgnoreManage")=$o(^DHCCKBIGMAN(""),-1) // 忽略配置 DHCCKBIgnoreManage.cls
	q "初始化成功"
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	用于同步使用项目上的医院信息
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitHosp()
ClassMethod InitHosp()
{
	
	// 东华his,CT_Hospital
	s hospDataId=##class(web.DHCCKBCommon).GetHospitalData()
	q:+hospDataId=0 "同步失败"
	
	s admin=##class(web.DHCCKBCommon).GetDicIdByCode("admin")
	s id=""
	f   s id=$o(^CT("HOSP",id))	q:id=""  d
	.q:id=0	
	.s stDate=$p($g(^CT("HOSP",id)),"^",9)
	.s endDate=$p($g(^CT("HOSP",id)),"^",10)
	.q:(stDate'="")&(stDate>+$h)
	.q:(endDate'="")&(endDate<+$h)
	.TS
	.s code=$p($g(^CT("HOSP",id)),"^",1)
	.s desc=$p($g(^CT("HOSP",id)),"^",2)
	.s hospData="^"_code_"^"_desc_"^"_hospDataId
	.s ret=##class(web.DHCCKBDiction).SaveUpdate(hospData)
	.i ret<=0 tro
	.q:ret<=0 
	.// 存日志
	.s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",ret,"add",admin,"","","","","")
	.i (accFlag'=0)  tro
	.e  tc
	.
	
	q "同步成功"
	
	// 非东华的his,单独做接口
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	用于同步使用项目上的科室信息
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitLoc()
ClassMethod InitLoc()
{
	
	// 东华his,CT_Loc
	s locDataId= ##class(web.DHCCKBCommon).GetLocData()
	q:+locDataId=0 "同步失败" ///^CTLOC({CTLOC_RowID})
	
	s admin=##class(web.DHCCKBCommon).GetDicIdByCode("admin")
	s id=""
	f   s id=$o(^CTLOC(id))	q:id=""  d
	.q:id=0	
	.s stDate=$p($g(^CTLOC(id)),"^",24)
	.s endDate=$p($g(^CTLOC(id)),"^",25)
	.q:(stDate'="")&(stDate>+$h)
	.q:(endDate'="")&(endDate<+$h)
	.Ts
	.s code=$p($g(^CTLOC(id)),"^",1)
	.s desc=$p($g(^CTLOC(id)),"^",2)		
	.s listData="^"_code_"^"_desc_"^"_locDataId
	.s ret=##class(web.DHCCKBDiction).SaveUpdate(listData)	// -98 -99 代码，描述重复
	.s accFlag=""
	.i (+ret>0) d	// 新增
	..// 存日志
	..s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",ret,"add",admin,"","","","","")
	..i (accFlag'=0) tro
	..q:(accFlag'=0)
	..s accFlag=""
	..d SaveAcc		// 授权
	..i (accFlag'=0)  tro
	..q:(accFlag'=0)
	..tc
	.
	.e  i (ret="-98")||(ret="-99")  d  // 已存在 
	..i ret="-98" s ret=##class(web.DHCCKBCommon).GetDicIdByCode(code)
	..i ret="-99" s ret=##class(web.DHCCKBCommon).GetDicIdByDesc(desc)
	..i ret<=0 tro
	..q:ret<=0
	..d SaveAcc		// 授权
	..i (accFlag'=0)  tro
	..q:(accFlag'=0)
	..tc
	.e  d
	..tro	
	
	q "同步成功"

SaveAcc
	// 需要将科室和医院进行关联起来，通过将科室对医院授权进行关联
	s hospId=$p($g(^CTLOC(id)),"^",22)
	s hospCode=$p($g(^CT("HOSP",+hospId)),"^",1)
	s accHospId=##class(web.DHCCKBCommon).GetDicIdByCode(hospCode)	 // 需要授权的医院id
	i +accHospId=0 s accFlag=0
	q:+accHospId=0 "" // 医院id为空,则不授权
	s accFlag=..SaveAloneAcc(ret,accHospId,admin)
	q ""
	// 非东华的his,单独做接口
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	用于同步使用项目上的安全组信息 (安全组单独进行授权)
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitGroup()
ClassMethod InitGroup()
{
	
	// 东华his,SS_Group
	s groupDataId= ##class(web.DHCCKBCommon).GetGroupData()
	q:+locDataId=0 "同步失败" ///^SSU("SSGRP",{SSGRP_RowId})
	
	s admin=##class(web.DHCCKBCommon).GetDicIdByCode("admin")
	s id=""
	f   s id=$o(^SSU("SSGRP",id))	q:id=""  d
	.q:id=0	
	.s code=$p($g(^SSU("SSGRP",id)),"^",1)
	.q:code["停用"
	.Ts
	.s desc=code		
	.s listData="^"_code_"^"_desc_"^"_groupDataId
	.s ret=##class(web.DHCCKBDiction).SaveUpdate(listData)
	.i ret<=0 tro
	.q:ret<=0
	.// 存日志
	.s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",ret,"add",admin,"","","","","")
	.i (accFlag'=0)  tro
	.q:(accFlag'=0)
	.e  tc
	.
		
	q "同步成功"
	
	// 非东华的his,单独做接口
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	用于同步使用项目上的用户信息
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitUser()
ClassMethod InitUser()
{
	
	// 东华his,SS_User
	s userDataId= ##class(web.DHCCKBCommon).GetDocData()
	q:+userDataId=0 "同步失败" ///^SSU("SSUSR",{SSUSR_RowId})
	
	s admin=##class(web.DHCCKBCommon).GetDicIdByCode("admin")
	s id=""
	f   s id=$o(^SSU("SSUSR",id))	q:id=""  d
	.q:id=0	
	.s stDate=$p($g(^SSU("SSUSR",id)),"^",96)
	.s endDate=$p($g(^SSU("SSUSR",id)),"^",97)
	.q:(stDate'="")&(stDate>+$h)
	.q:(endDate'="")&(endDate<+$h)
	.s active=$p($g(^SSU("SSUSR",id)),"^",19)
	.q:active'="Y"
	.Ts
	.s code=$p($g(^SSU("SSUSR",id)),"^",1)
	.s desc=$p($g(^SSU("SSUSR",id)),"^",2)
	.s listData="^"_code_"^"_desc_"^"_userDataId
	.s ret=##class(web.DHCCKBDiction).SaveUpdate(listData)
	.s accFlag=""
	.i (+ret>0) d	// 新增
	..// 存日志
	..s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",ret,"add",admin,"","","","","")
	..i (accFlag'=0)  tro
	..q:(accFlag'=0)
	..s accFlag=""
	..d SaveAccUser		// 授权
	..i (accFlag'=0)  tro
	..q:(accFlag'=0)
	..tc
	.
	.e  i (ret="-98")||(ret="-99")  d  // 已存在 
	..i ret="-98" s ret=##class(web.DHCCKBCommon).GetDicIdByCode(code)
	..i ret="-99" s ret=##class(web.DHCCKBCommon).GetDicIdByDesc(desc)
	..i ret<=0 tro
	..q:ret<=0
	..d SaveAccUser		// 授权
	..i (accFlag'=0)  tro
	..q:(accFlag'=0)
	..tc
	.e  d
	..tro	
	
	q "同步成功"
	// 非东华的his,单独做接口
	
SaveAccUser
	// 需要将科室和医院进行关联起来，通过将科室对医院授权进行关联
	.s hospId=$p($g(^SSU("SSUSR",id)),"^",98)
	.s hospCode=$p($g(^CT("HOSP",+hospId)),"^",1)
	.s accHospId=##class(web.DHCCKBCommon).GetDicIdByCode(hospCode)	 // 需要授权的医院id
	i +accHospId=0 s accFlag=0
	q:+accHospId=0 "" // 医院id为空,则不授权
	s accFlag=..SaveAloneAcc(ret,accHospId,admin)
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	用于同步使用项目上的职称信息(职称单独授权)
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitCarPrv()
ClassMethod InitCarPrv()
{
	// 东华his,CT_CarPrvTp
	s carePrvDataId= ##class(web.DHCCKBCommon).GetCarePrvData()
	q:+carePrvDataId=0 "同步失败" /// ^CT("CPT",{CTCPT_RowId})
	
	s admin=##class(web.DHCCKBCommon).GetDicIdByCode("admin")
	s id=""
	f   s id=$o(^CT("CPT",id))	q:id=""  d
	.q:id=0	
	.s stDate=$p($g(^CT("CPT",id)),"^",5)
	.s endDate=$p($g(^CT("CPT",id)),"^",6)
	.s active=$p($g(^CT("CPT",id)),"^",3)
	.q:(stDate'="")&(stDate>+$h)
	.q:(endDate'="")&(endDate<+$h)
	.q:active'="Y"
	.Ts
	.s code=$p($g(^CT("CPT",id)),"^",1)
	.s desc=$p($g(^CT("CPT",id)),"^",2)	
	.s listData="^"_code_"^"_desc_"^"_carePrvDataId
	.s ret=##class(web.DHCCKBDiction).SaveUpdate(listData)
	.i ret<=0 tro
	.q:ret<=0
	.// 存日志
	.s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",ret,"add",admin,"","","","","")
	.i (accFlag'=0)  tro
	.q:(accFlag'=0)
	.e  tc
	.
	q "同步成功"
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	字典批量授权(职称、安全组)
/// Input:			
/// Other:	w ##class(web.DHCCKBConfig).SaveMulAcc("GroupData","东华标准版数字化医院[分院]")
/// w ##class(web.DHCCKBConfig).SaveMulAcc("CarePrvData","东华标准版数字化医院[分院]")
ClassMethod SaveMulAcc(dataStr, hospital)
{
	n (dataStr,hospital)
	
	q:(dataStr="")||(hospital="") "授权失败"
	s len=$length(dataStr,"^")	
	s admin=##class(web.DHCCKBCommon).GetDicIdByCode("admin")
	
	f i=1:1:len  d
	.s str=$p(dataStr,"^",i)
	.q:str=""
	.s dataId=##class(web.DHCCKBCommon).GetDicIdByCode("GroupData")
	.q:dataId=""
	.s id=""
	.f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",dataId,id))  q:id=""  d	
	..s accHospId=##class(web.DHCCKBCommon).GetDicIdByDesc(hospital)	 // 需要授权的医院id
	..q:+accHospId=0
	..TS
	..s accFlag=""
	..s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",id,"grantAuth",admin,"","","D",accHospId,"","acc")
	..i (accFlag'=0)  tro
	..q:(accFlag'=0)
	..TC
		
	q "授权成功"
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-23
/// Description:： 	字典数据进行医院授权
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitUser(51900,51899,49607)
ClassMethod SaveAloneAcc(id, hospital, user)
{
	n (id,hospital,user)
	
	s ret=0
	s accFlag=##class(web.DHCCKBWriteLog).InsertLogs("DHC_CKBCommonDiction",id,"grantAuth",user,"","","D",hospital,"113.140.81.66","acc")
	i (accFlag'=0)  s ret=1
	
	q ret
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-26
/// Description:： 	初始化超级用户
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).SysUser()
ClassMethod SysUser()
{
	s SysUserList=$lb("东华标准版数字化医院[总院]","东华标准版数字化医院[分院]")
	
	q $listtostring(SysUserList,"^^")
}

/// Creator:		qunianpeng
/// CreatDate:		2020-03-26
/// Description:： 	初始化非系统字典、及是否需要对照标记列表
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitGrantAuthList()
ClassMethod InitGrantAuthList()
{

	/*
	s AuthList=$lb("DrugData")				// 带剂型通用名
	s $list(AuthList,*+1)="DrugProNameData"	// 商品名
	s $list(AuthList,*+1)="GeneralData"		// 通用名
	s $list(AuthList,*+1)="DrugCategoryData" // 药学分类
	s $list(AuthList,*+1)="ingredientData"	// 成分
	s $list(AuthList,*+1)="ExcipientData"	// 辅料
	s $list(AuthList,*+1)="DrugPreMetData"	// 给药途径
	s $list(AuthList,*+1)="DrugFreqData"	// 用药频率
	s $list(AuthList,*+1)="FormData"		// 剂型
	s $list(AuthList,*+1)="DiseaseData"		// 疾病
	s $list(AuthList,*+1)="SymptomData"		// 症状
	s $list(AuthList,*+1)="SpecialPopData"	// 特殊人群
	s $list(AuthList,*+1)="LabData"			// 检验套
	s $list(AuthList,*+1)="LabItmData"		// 检验项
	s $list(AuthList,*+1)="BacteriaData"	// 细菌字典
	s $list(AuthList,*+1)="BacteriaCatData"	// 菌属字典
	//s $list(AuthList,*+1)="UnitData"		// 单位字典
	s $list(AuthList,*+1)="ICDDiagData"		// ICD诊断字典
	*/
	s AuthObj=##class(%Library.DynamicObject).%New()
	d AuthObj.%Set("DrugData","Y") 			// 带剂型通用名
	d AuthObj.%Set("DrugProNameData","Y")	// 商品名
	d AuthObj.%Set("GeneralData","Y")		// 通用名
	d AuthObj.%Set("DrugCategoryData","Y")	// 药学分类
	d AuthObj.%Set("ingredientData","Y")	// 成分
	d AuthObj.%Set("ExcipientData","Y")		// 辅料
	d AuthObj.%Set("DrugPreMetData","Y")	// 给药途径
	d AuthObj.%Set("DrugFreqData","Y")		// 用药频率
	d AuthObj.%Set("FormData","Y")			// 剂型
	d AuthObj.%Set("DiseaseData","Y")		// 疾病
	d AuthObj.%Set("SymptomData","Y")		// 症状
	d AuthObj.%Set("SpecialPopData","Y")	// 特殊人群
	d AuthObj.%Set("LabData","Y")			// 检验套
	d AuthObj.%Set("LabItmData","Y")		// 检验项
	d AuthObj.%Set("BacteriaData","Y")		// 菌属字典
	d AuthObj.%Set("BacteriaData","Y")		// 手术字典	
	d AuthObj.%Set("OperationData","Y")		// ICD诊断字典
	d AuthObj.%Set("ManufacturerData","N")	// 生产企业字典
	d AuthObj.%Set("MedicalTimeData","N")	// 用药时机字典
	d AuthObj.%Set("ProfessData","N")		// 职业字典
	d AuthObj.%Set("FirstUseData","N")		// 是否首次用药字典
	d AuthObj.%Set("OtherNameData","N")		// 别名字典
	d AuthObj.%Set("EnvironReasonData","N")	// 环境因素字典
	d AuthObj.%Set("SexData","N")			// 性别字典
	d AuthObj.%Set("UnitData","N")			// 单位字典
		
	q AuthObj
}

/// Creator:		qunianpeng
/// CreatDate:		2020-04-10
/// Description:： 	初始化知识库中的数据转换关系,形成键值对存储(如:分类<->药品,分类<->成分)
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitDataStore()
ClassMethod InitDataStore()
{
	
	// 数据存储格式:
	// ^DHCCKBDATASTORE("检验"，patid，白细胞）=值
	// ^DHCCKBDATASTORE("过敏"，成分，成分值，分类，分类值）=""

	s wirteFlag = ""
	i $d(^DHCCKBDATASTORE) d	// global若已经存在,再次确认,防止误操作替换项目数据
	.READ !,"(^DHCCKBDATASTORE)已经存在,请确认是否继续存储,确认输入【Y】,取消【N】",!,wirteFlag,!
	
	q:$d(^DHCCKBDATASTORE)&($zcvt(wirteFlag,"U")'="Y") "初始化失败!"
	
	//s PropList=$lb("DrugCategory","GenerNameFormProp","GenerNameProp","ProNameProp","Ingredient","ExcipientProp")
	// 2层转化关系 (如:分类->药品->成分,通用名->药品->成分),中间的承接点都是药品
	d ##class(web.DHCCKBConfig).InitRealtion("DrugCategory","GenerNameFormProp")
	d ##class(web.DHCCKBConfig).InitRealtion("DrugCategory","GenerNameProp")
	d ##class(web.DHCCKBConfig).InitRealtion("DrugCategory","ProNameProp")
	d ##class(web.DHCCKBConfig).InitRealtion("DrugCategory","Ingredient")
	d ##class(web.DHCCKBConfig).InitRealtion("DrugCategory","ExcipientProp")
	
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameFormProp","GenerNameProp")
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameFormProp","ProNameProp")
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameFormProp","ExcipientProp")
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameFormProp","Ingredient")
	
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameProp","ProNameProp")
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameProp","ExcipientProp")
	d ##class(web.DHCCKBConfig).InitRealtion("GenerNameProp","Ingredient")
		
	d ##class(web.DHCCKBConfig).InitRealtion("ProNameProp","Ingredient")
	d ##class(web.DHCCKBConfig).InitRealtion("ProNameProp","ExcipientProp")
	
	d ##class(web.DHCCKBConfig).InitRealtion("Ingredient","ExcipientProp")
	
	d ##class(web.DHCCKBConfig).InitRealtion("Drug","Ingredient")
		
	//d ..InitCatWithIngr()
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2020-04-10
/// Description:： 	初始化知识库中的 属性和属性的 数据转换关系,形成键值对存储，中间承接点是药品,如:成分<药品>分类，通用名<药品>成分,建立的是成分和分类的关系
/// Input:			左侧属性(his),需要建立关系的属性(知识库)
/// Other:	w ##class(web.DHCCKBConfig).InitRealtion()
ClassMethod InitRealtion(Prop, LinkProp)
{
	/*
	*思路: 遍历第一个属性, 找到属性关联的药品(医嘱项), 在找到药品(医嘱项)下面的第二个属性,将两个属性作为store的键值对
	*考虑到过敏源处的成分等,不需要做数据映射,因此键值对的key需要是知识库id, 知识库描述
	*/
	n (Prop,LinkProp)

	s PropId=##class(web.DHCCKBCommon).GetDicIdByCode(Prop)
	s LinkPropId=##class(web.DHCCKBCommon).GetDicIdByCode(LinkProp)
	q:(+PropId=0)||(+LinkPropId=0) ""
	
	s PropDataList=""
	i Prop= "DrugCategory"	d 
	.s PropDataId=##class(web.DHCCKBCommon).GetDrugCategoryData()
	.d ##Class(web.DHCCKBCommon).GetChildCat(.PropDataList,PropDataId,1)	// 获取所有的分类
	e  d 	// 带剂型的通用名/ 通用名/商品名/辅料
	.s PropDataList=##Class(web.DHCCKBCommon).GetDataListByProp(Prop,1)

	q:PropDataList="" ""
	f Index=1:1:$listlength(PropDataList)  d
	.s DataId=$listget(PropDataList,Index)
	.q:+DataId=0
	.i Prop="Drug"	s DrugList=$lb(DataId)	// 用于处理一层关系,如药品,->成分
	.e  s DrugList=##Class(web.DHCCKBCommon).GetCommonDrugListByProp(PropId,DataId,1)	// 获取分类下所有的药品(医嘱项)
	.f DrugIndex=1:1:$listlength(DrugList)	d
	..s DrugId=$listget(DrugList,DrugIndex)
	..q:+DrugId=0
	..// 获取药品下的属性
	..s LinkPropList=""
	..i LinkProp="DrugCategory"	d	// 分类
	...s LinkPropList=##Class(web.DHCCKBCommon).GetPhCat(DrugId,1)
	..e  i LinkProp="Ingredient"	d 			// 成分
	...s LinkPropList=##Class(web.DHCCKBCommon).GetIngredient(DrugId,1)
	..e  d	// 带剂型的通用名/商品名/通用名/辅料
	...s LinkPropList=##Class(web.DHCCKBCommon).GetProValueListByDrug(DrugId,LinkProp,1)
	..
	..// 建立属性和属性的关系(如：成分<>分类)
	..f LinkIndex=1:1:$listlength(LinkPropList)	d
	...s LinkPropId=$listget(LinkPropList,LinkIndex)
	...s LinkPropDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LinkPropId)),3)
	...s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LinkPropId)),5)
	...i +LinkDr'=0 s LinkPropDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LinkDr)),3)		// //^DHCCKBDATASTORE("过敏"，成分，成分值，分类，分类值）=""
	...s ^DHCCKBDATASTORE("HisAllergy",Prop,DataId,LinkProp,LinkPropId)=""		// 分类->成分
	...s ^DHCCKBDATASTORE("HisAllergy",LinkProp,LinkPropId,Prop,DataId)=""		// 成分->分类
	...//s ^DHCCKBDATASTORE("HisAllergy",Prop,DataId,LinkProp,LinkPropDesc)="" 	// 分类->成分描述
	...//s ^DHCCKBDATASTORE("HisAllergy",LinkProp,LinkPropDesc,Prop,DataId)="" 	// 成分描述->分类
	
	q ""
}

/// Creator:		qunianpeng
/// CreatDate:		2020-04-10
/// Description:： 	初始化知识库中的 分类<->成分 数据转换关系,形成键值对存储
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).InitCatWithIngr()
ClassMethod InitCatWithIngr()
{
	/*
	*思路: 遍历分类, 找到分类下关联的药品(医嘱项), 在找到药品(医嘱项)下面的成分,将分类和成分作为store的键值对
	*考虑到过敏源处的成分,不需要做数据映射,因此键值对的key需要是知识库id, 知识库描述
	*/
	
	s CatDataId=##class(web.DHCCKBCommon).GetDrugCategoryData()
	s CatList=""
	d ##Class(web.DHCCKBCommon).GetChildCat(.CatList,CatDataId,1)	// 获取所有的分类
	
	f Index=1:1:$listlength(CatList)  d
	.s CatId=$listget(CatList,Index)
	.q:+CatId=0
	.s DrugList=##Class(web.DHCCKBCommon).GetDrugListByCat(CatId,1)	// 获取分类下所有的药品(医嘱项)
	.f DrugIndex=1:1:$listlength(DrugList)	d
	..s DrugId=$listget(DrugList,DrugIndex)
	..q:+DrugId=0
	..s IngrList=##Class(web.DHCCKBCommon).GetIngredient(DrugId,1)	
	..// 建立分类和成分的关系
	..f IngrIndex=1:1:$listlength(IngrList)	d
	...s IngrId=$listget(IngrList,IngrIndex)
	...s IngrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+IngrId)),3)
	...s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+IngrId)),5)
	...i +LinkDr'=0 s IngrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+LinkDr)),3)		// //^DHCCKBDATASTORE("过敏"，成分，成分值，分类，分类值）=""
	...s ^DHCCKBDATASTORE("HisAllergy","DrugCategory",CatId,"Ingredient",IngrId)=IngrId		// 分类->成分
	...s ^DHCCKBDATASTORE("HisAllergy","DrugCategory",CatId,"Ingredient",IngrDesc)=IngrDesc // 分类->成分描述
	...s ^DHCCKBDATASTORE("HisAllergy","Ingredient",IngrId,"DrugCategory",CatId)=CatId		// 分类->成分
	...s ^DHCCKBDATASTORE("HisAllergy","Ingredient",IngrDesc,"DrugCategory",CatId)=CatId 	// 分类->成分描述
	
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		通过数据的转换关系，获取转换后的等价数据(如：分类<-> 成分)
/// Input:			CatID-药学分类id, flag-(1取id,flag 0 取描述)
/// w ##Class(web.DHCCKBConfig).ChangeItmFromStore(Type,Prop,PropId,PropName,ChangeProp)
ClassMethod ChangeItmFromStore(Type, Prop, PropId, PropName, ChangeProp) As %String
{
	n (Type,Prop,PropId,PropName,ChangeProp)
	
	q:'$d(^DHCCKBDATASTORE(Type,Prop,PropId,PropName)) ""
	
	s RetList=""
	s Value=""
	f  s Value=$o(^DHCCKBDATASTORE(Type,Prop,PropId,PropName,Value))	q:Value=""  d
	.q:(Value=0)||(Value)=""
	.s $list(RetList,*+1)=Value
	
	q RetList
}

/// 导出global： d ##class(web.DHCCKBConfig).ExportGlobal()
/// 导入global： d $SYSTEM.OBJ.ImportDir("D:\CKBGlobal66522_32668_702\","CKBGlobal66522_32668_702.gof")
ClassMethod ExportGlobal()
{
	
	k CList
	k myIdx
	
	//字典表
	s CList($i(CList))="DHCCKBCC.GBL" // 数据对照表 DHCCKBComContrast.cls	
	s CList($i(CList))="DHCCKBCD.GBL" // 知识库码表字典 DHCCKBCommonDiction.cls	
	s CList($i(CList))="DHCCKBDLA.GBL" // 数据关联表
	s CList($i(CList))="DHCCKBDLG.GBL" // 字典日志表
	s CList($i(CList))="DHCCKBEXD.GBL" // 外部代码表

	s CList($i(CList))="DHCCKBRULE.GBL"  // 规则主表
	s CList($i(CList))="DHCCKBRULECOMPLEXARITH.GBL"  // ^DHCCKBRULECOMPLEXARITH 公式表DHC_CKBRuleComplexArith
	s CList($i(CList))="DHCCKBRD.GBL"  // 规则明细表
	s CList($i(CList))="DHCCKBRULEDATALOG.GBL"  // 规则数据日志
 	s CList($i(CList))="DHCCKBRULEDETAIL.GBL" // User.DHCCKBRuleDetail
	s CList($i(CList))="DHCCKBRULEDIC.GBL"		//  规则索引
	s CList($i(CList))="DHCCKBRULELOG.GBL"	// 规则序号日志
	s CList($i(CList))="DHCCKBRULEMAINTAIN.GBL" // 拆分规则中间表 
	s CList($i(CList))="DHCCKBRULENODE.GBL" // 规则节点
	s CList($i(CList))="DHCCKBTEM.GBL"	// 模板表 DHCCKBTemplate.cls
	s CList($i(CList))="DHCCKBRULETEXT.GBL"		// 分词记录表	User.DHCCKBRuleText
 	s CList($i(CList))="DHCCKBTCT.GBL"	//		审查模板表	User.DHCCKBTestCaseTemp
	
	s CList($i(CList))="DHCCKBDLAEXT.GBL"	// ^DHCCKBDLAEXT 外部属性表 User.DHCCKBDicExtLinkAttr 2020/12/123 增加以下
	//s CList($i(CList))="DHCCKBFB.GBL" // ^DHCCKBFB 反馈表 User.DHCCKBFeedBack
	//s CList($i(CList))="DHCCKBMFL.GBL" // ^DHCCKBMFL 监测规则表 User.DHCCKBMonFunList
	//s CList($i(CList))="DHCCKBMM.GBL" // ^DHCCKBMM 监测主表 User.DHCCKBMonMaster
	//s CList($i(CList))="DHCCKBMQL.GBL" // ^DHCCKBMQL 监测明细表 User.DHCCKBMonQueList
	//s CList($i(CList))="DHCCKBMRL.GBL" // ^DHCCKBMRL  User.DHCCKBMonRuleList 
	s CList($i(CList))="DHCCKBRULEACTION.GBL" // ^DHCCKBRULEACTION User.DHCCKBRuleAction
 	s CList($i(CList))="DHCCKBRCL.GBL" // ^DHCCKBRCL 规则赋值表? User.DHCCKBRuleCopyLog
	s CList($i(CList))="DHCCKBPTEMP.GBL" // 插件模板 DHCCKBPluginTemp.cls
	s CList($i(CList))="DHCCKBIGMAN.GBL" // 忽略配置 DHCCKBIgnoreManage.cls
	s CList($i(CList))="DHCCKBDLAEXT.GBL"  // 外部属性表 DHCCKBDicExtLinkAttr.cls
	//s CList($i(CList))="User.DHCCKBComDictionExtD.GBL" // 知识库码表字典扩展表 DHCCKBComDictionExt.cls
	//s CList($i(CList))="User.DHCCKBComDictionExtI.GBL" //
	s CList($i(CList))="User.DHCCKBDiagnosisRelationD.GBL" // User.DHCCKBDiagnosisRelation
	s CList($i(CList))="User.DHCCKBDiagnosisRelationI.GBL"
	s CList($i(CList))="User.DHCCKBDrugLibaryRefD.GBL" // User.DHCCKBDrugLibaryRef
	s CList($i(CList))="User.DHCCKBDrugLibaryRefI.GBL"
	s CList($i(CList))="User.DHCCKBIgnoreDataPoolD.GBL" //User.DHCCKBIgnoreDataPool
	s CList($i(CList))="User.DHCCKBIgnoreDataPoolI.GBL"
	//s CList($i(CList))="^DHCCKBINCRULE.GBL" // //User.DHCCKBIncRule
	s CList($i(CList))="User.DHCCKBGenNIndex.GBL" //  User.DHCCKBGenNIndex	
	s CList($i(CList))="DHCCKBPreconditionDataPool.GBL" //  User.DHCCKBPreconditionDataPool
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)_$zts
	s filename = "D:\CKBGlobal"_time_"new"_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// 导出global： d ##class(web.DHCCKBConfig).ExportGlobaltest()
/// 导入global： d $SYSTEM.OBJ.ImportDir("D:\","CKBGlobal2021-11-0766055,53285.235new.gof")
ClassMethod ExportGlobaltest()
{
	
	k CList
	k myIdx
	
	//字典表
	s CList($i(CList))="DHCCKBRULEDATALOG.GBL" // 数据关联表
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)_$zts
	s filename = "D:\CKBGlobal"_"规则明细日志.gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Author: qunianpeng
/// Time：	2020-10-19
/// Desc:	增加等效单位转换关系(不使用程序增加，手工增加)
/// Table： CT_CKB_PDSS.CommonDiction
/// Other:  w ##class(web.DHCCKBConfig).AutoAddEqualUnit()
ClassMethod AutoAddEqualUnit()
{
	// 思路：
	//	1. 遍历所有的药品，判断药品是否维护了等效单位
	//  2. 判断维护的等效单位中，是否需要进行隐含的单位转换(已有，已有不正确)
	//  3. 新增转换关系
	//  4. 用excel记录新增的转换关系和修改的转换关系
	
	k TmpArr
	
	d ..GetGroupUnitData(.TmpArr)
	
	q ""
}

/// Creator:      qunianpeng
/// CreatDate:    2020-10-19
/// Description:  遍历所有的等效单位,增加隐含的等效单位关系(不使用程序增加，手工增加)
/// Input:		  
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBConfig","ExportEqualUnitData")
/// w ##Class(websys.Query).ToExcel("CKB_Excel01","web.DHCCKBConfig","ExportEqualUnitData")
Query ExportEqualUnitData() As websys.Query(ROWSPEC = "drugId:%String:药品id,drugDesc:%String:药品名称,fUnitDesc:%String:从单位,toUnitDesc:%String:到单位,oldFactor:%String:原系数,newFactor:%String:新系数,linkAttrId:%String:系数关联id,status:%String:标记,fUnit:%String:从单位id,oFactor:%String:到单位id")
{
}

ClassMethod ExportEqualUnitDataExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	// s listData = drugId_"^"_drugDesc_"^"_fUnitDesc_"^"_toUnitDesc_"^"_unitData_"^"_addFlag_"^"_fUnit_"^"_toUnit
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr
	
	d ..GetGroupUnitData(.TmpArr)
	
	Set index=""	
	for  set index=$order(TmpArr("msg",index)) quit:index=""  do
	.set listData=$get(TmpArr("msg",index))
	.set ^CacheTemp(repid,ind)=$listfromstring(listData,"^")
	.set ind=ind+1	
	
	k TmpArr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetGroupUnitData(TmpArr) As %String
{
	n (TmpArr)
	
	s eqUnitProp = ##class(web.DHCCKBCommon).GetEqUnitProp()		// 等效单位
	s eqFromUnitProp = ##class(web.DHCCKBCommon).GetEqFromUnitProp()	// 从单位
	s eqToUnitProp = ##class(web.DHCCKBCommon).GetEqToUnitProp()	// 到单位
	s eqFactorProp = ##class(web.DHCCKBCommon).GetEqFactorProp()	// 系数

	s drugData = ##class(web.DHCCKBCommon).GetDrugData()
	s drugId = ""
	f  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugData,drugId)) q:drugId=""  d
	.//q:drugId'=292
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+drugId,+eqUnitProp))		// 药品没有维护等效单位,删除后这条数据不删除
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+drugId,+eqFromUnitProp))	// 药品没有维护等效单位
	.k TmpArr("realtion")
	.k TmpArr("realtionNew")
	.k TmpArr("eqFactorId")
	.k TmpArr("group")
	.s count = 0
	.// 遍历现有的等效单位数据
	.s linkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	.q:+linkPropId=0
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",eqUnitProp,linkPropId))
	.s linkTempId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+eqUnitProp,+linkPropId,""))
	.s tempId=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkTempId)),4)	// 关联的模板名称
	.q:+tempId=0
	.s unitList = ""
	.s subId=""
	.f  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",tempId,subId))  Q:subId=""  d
	..s dlaRowId=""
	..f  s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,subId,dlaRowId))  Q:dlaRowId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),3)			// 从单位
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)			// 单位值
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),5)				// 备注
	...s dicGroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),6)		// 成组标识
	...s:subId=eqFromUnitProp $p(TmpArr("group",dicGroupFlag),"^",1)=dicAttrId,count=count+1
	...s:subId=eqToUnitProp $p(TmpArr("group",dicGroupFlag),"^",2)=dicAttrId
	...s:subId=eqFactorProp $p(TmpArr("group",dicGroupFlag),"^",3)=dicRes,$p(TmpArr("group",dicGroupFlag),"^",4)=dlaRowId
	.
	.q:count=1	// 只有一个关系,则不不需要转换
	.s TmpArr("drugId")=drugId
	.// 将一个药品的关系进行转换
	.d ..GetUnitRealtion(.TmpArr)
	.// 组织输出信息
	.d ..OutMsg(.TmpArr,drugId)
	q ""
}

/// w ##class(web.DHCCKBConfig).GetUnitRealtion()
ClassMethod GetUnitRealtion(TmpArr) As %String
{
	n (TmpArr)
		
	//k TmpArr
	//s TmpArr("group",1) = "mg^瓶^0.2"	// mg = 10*0.2
	//s TmpArr("group",2) = "瓶^ml^10"
	
	//s TmpArr("group",3) = "mg^瓶^0.2"	// mg = 10*0.2
	//s TmpArr("group",4) = "ml^瓶^0.1"
	
	//s TmpArr("group",5) = "mg^瓶^0.2"	// 瓶 = 2/0.2
	//s TmpArr("group",6) = "mg^ml^2"
	
	//s TmpArr("group",7) = "mg^瓶^0.2"	// 瓶 = 1/2/0.2
	//s TmpArr("group",8) = "ml^mg^0.5"
	//s TmpArr("group",9) = "瓶^mg^5"	// 瓶 = 1/2/0.2
	//s TmpArr("group",10) = "瓶^ml^10"
	//s TmpArr("group",11) = "瓶^g^0.005"	

	s group = ""
	f  s group = $o(TmpArr("group",group)) q:group=""  d
	.s fUnit = $p(TmpArr("group",group),"^",1)
	.s toUnit = $p(TmpArr("group",group),"^",2)
	.s factor = $p(TmpArr("group",group),"^",3)
	.s TmpArr("realtion",+fUnit,+toUnit)=factor	// 组成关系
	.s TmpArr("eqFactorId",+fUnit,+toUnit)=$p(TmpArr("group",group),"^",4)

	s fUnit=""
	f  s fUnit=$o(TmpArr("realtion",fUnit))  q:fUnit=""  d
	.s toUnit=""
	.f  s toUnit=$o(TmpArr("realtion",fUnit,toUnit))  q:toUnit=""  d
	..// 方式1  s TmpArr("mg","瓶")=0.2
	..//		s TmpArr("瓶","ml")=10		// mg =0.2*瓶(10*ml)
	..// 将第二个节点 从 数组第一位遍历，找到联系
	..s changeUnit=""
	..f  s changeUnit=$o(TmpArr("realtion",toUnit,changeUnit))  q:changeUnit=""  d
	...q:fUnit=changeUnit
	...//q:$d(TmpArr("realtion",fUnit,changeUnit))||$d(TmpArr("realtion",changeUnit,fUnit))
	...q:$d(TmpArr("realtionNew",fUnit,changeUnit))||($d(TmpArr("realtionNew",changeUnit,fUnit)))
	...s oldFactor="",exitFlag = 0
	...i $d(TmpArr("realtion",fUnit,changeUnit)) s oldFactor = $g(TmpArr("realtion",fUnit,changeUnit)),exitFlag=1
	...i $d(TmpArr("realtion",changeUnit,fUnit)) s oldFactor = 1/$g(TmpArr("realtion",changeUnit,fUnit)),exitFlag=2
	...s factor = $g(TmpArr("realtion",fUnit,toUnit))*$g(TmpArr("realtion",toUnit,changeUnit))
	...q:+factor=0
	...//s TmpArr("realtion",fUnit,changeUnit)=factor
	...i (exitFlag=1)&(oldFactor'=factor) s TmpArr("realtionNew",fUnit,changeUnit)=$lb(oldFactor,factor,$g(TmpArr("eqFactorId",fUnit,changeUnit)))
	...i (exitFlag=2)&(oldFactor'=(1/factor)) s TmpArr("realtionNew",fUnit,changeUnit)=$lb(oldFactor,1/factor,$g(TmpArr("eqFactorId",changeUnit,fUnit)))
	...i exitFlag=0  s TmpArr("realtionNew",fUnit,changeUnit)=$lb("",factor,"")
	..// 方式2 s TmpArr("mg","瓶")=0.2
	..//       s TmpArr("ml","瓶")=0.1	mg = ml/0.1*0.2
	..// 将第二个节点 从数组的第二位遍历, 找到联系
	..s tmpUnit=""
	..f  s tmpUnit=$o(TmpArr("realtion",tmpUnit))  q:tmpUnit=""  d
	...q:fUnit=tmpUnit
	...q:'$d(TmpArr("realtion",tmpUnit,toUnit))
	...q:$d(TmpArr("realtionNew",fUnit,tmpUnit))||($d(TmpArr("realtionNew",tmpUnit,fUnit)))
	...s oldFactor="",exitFlag = 0
	...i $d(TmpArr("realtion",fUnit,tmpUnit)) s oldFactor = $g(TmpArr("realtion",fUnit,tmpUnit)),exitFlag=1
	...i $d(TmpArr("realtion",tmpUnit,fUnit)) s oldFactor = 1/$g(TmpArr("realtion",tmpUnit,fUnit)),exitFlag=2
	...q:$g(TmpArr("realtion",tmpUnit,toUnit))=""
	...s newfactor = (1/$g(TmpArr("realtion",tmpUnit,toUnit)))*$g(TmpArr("realtion",fUnit,toUnit))
	...q:+newfactor=0
	...//s TmpArr("realtion",fUnit,newUnit)=newfactor
	...i (exitFlag=1)&(oldFactor'=newfactor) s TmpArr("realtionNew",fUnit,tmpUnit)=$lb(oldFactor,newfactor,$g(TmpArr("eqFactorId",fUnit,tmpUnit)))
	...i (exitFlag=2)&(oldFactor'=(1/newfactor)) s TmpArr("realtionNew",tmpUnit,fUnit)=$lb(oldFactor,1/newfactor,$g(TmpArr("eqFactorId",tmpUnit,fUnit)))
	...i exitFlag=0  s TmpArr("realtionNew",fUnit,tmpUnit)=$lb("",newfactor,"")
	..
	..// 方式3 s TmpArr("mg","瓶")=0.2
	..//       s TmpArr("mg","g")=0.001	 g = 0.2*瓶/0.001
	..// 将第一个节点,从数组的第一位遍历,找到联系
	..s newChange=""
	..f  s newChange=$o(TmpArr("realtion",fUnit,newChange))  q:newChange=""  d
	...q:toUnit=newChange
	...//q:$d(TmpArr("realtion",toUnit,newChange))||$d(TmpArr("realtion",newChange,toUnit))
	...q:$d(TmpArr("realtionNew",newChange,toUnit))||($d(TmpArr("realtionNew",toUnit,newChange)))
	...s oldFactor="",exitFlag = 0
	...i $d(TmpArr("realtion",toUnit,newChange)) s oldFactor = $g(TmpArr("realtion",toUnit,newChange)),exitFlag=1
	...i $d(TmpArr("realtion",newChange,toUnit)) s oldFactor = 1/$g(TmpArr("realtion",newChange,toUnit)),exitFlag=2
	...q:$g(TmpArr("realtion",fUnit,newChange))=""
	...s factor = $g(TmpArr("realtion",fUnit,toUnit))/$g(TmpArr("realtion",fUnit,newChange))
	...q:+factor=0
	...//s TmpArr("realtion",newChange,toUnit) = factor
	...i (exitFlag=1)&(oldFactor'=(1/factor)) s TmpArr("realtionNew",newChange,toUnit)=$lb(oldFactor,1/factor,$g(TmpArr("eqFactorId",toUnit,newChange)))
	...i (exitFlag=2)&(oldFactor'=factor) s TmpArr("realtionNew",newChange,toUnit)=$lb(oldFactor,factor,$g(TmpArr("eqFactorId",newChange,toUnit)))
	...i exitFlag=0  s TmpArr("realtionNew",newChange,toUnit)=$lb("",factor,"")
	..// 方式4 s TmpArr("mg","瓶")=0.2
	..//       s TmpArr("g","mg")=1000	g = 0.2*瓶*1000
	..// 将第一个节点，从数组第二位遍历,找到联系
	..s tmpUnit=""
	..f  s tmpUnit=$o(TmpArr("realtion",tmpUnit))  q:tmpUnit=""  d
	...q:tmpUnit=fUnit
	...q:$d(TmpArr("realtionNew",tmpUnit,toUnit))||($d(TmpArr("realtionNew",toUnit,tmpUnit)))
	...s oldFactor="",exitFlag = 0
	...i $d(TmpArr("realtion",toUnit,tmpUnit)) s oldFactor = $g(TmpArr("realtion",toUnit,tmpUnit)),exitFlag=1
	...i $d(TmpArr("realtion",tmpUnit,toUnit)) s oldFactor = 1/$g(TmpArr("realtion",tmpUnit,toUnit)),exitFlag=2
	...s newfactor = $g(TmpArr("realtion",fUnit,toUnit))*($g(TmpArr("realtion",tmpUnit,fUnit)))
	...q:+newfactor=0
	...//s TmpArr("realtion",newUnit,toUnit)=newfactor
	...i (exitFlag=1)&(oldFactor'=(1/newfactor)) s TmpArr("realtionNew",tmpUnit,toUnit)=$lb(oldFactor,1/newfactor,$g(TmpArr("eqFactorId",tmpUnit,toUnit)))
	...i (exitFlag=2)&(oldFactor'=newfactor) s TmpArr("realtionNew",toUnit,tmpUnit)=$lb(oldFactor,newfactor,$g(TmpArr("eqFactorId",toUnit,tmpUnit)))
	...i exitFlag=0  s TmpArr("realtionNew",tmpUnit,toUnit)=$lb("",newfactor,"")

	q ""
}

ClassMethod OutMsg(TmpArr, drugId)
{
	n (TmpArr,drugId)
	// 原始等效单位
	s count = +$g(TmpArr("count"))
	s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s drugDesc=$tr(drugDesc,",","")
	s fUnit = ""
	f  s fUnit=$o(TmpArr("realtion",fUnit))  q:fUnit=""  d
	.s fUnitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+fUnit)),3)
	.s toUnit=""
	.f  s toUnit=$o(TmpArr("realtion",fUnit,toUnit))  q:toUnit=""  d
	..s toUnitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+toUnit)),3)
	..s unitData = $g(TmpArr("realtion",fUnit,toUnit))
	..s linkAttr = $g(TmpArr("eqFactorId",fUnit,toUnit))
	..s addFlag = ""
	..s count=count+1
	..s listData = drugId_"^"_drugDesc_"^"_fUnitDesc_"^"_toUnitDesc_"^"_unitData_"^^"_linkAttr_"^"_addFlag_"^"_fUnit_"^"_toUnit
	..s TmpArr("msg",count)=listData
	
	// 新增等效单位
	s fUnit = ""
	f  s fUnit=$o(TmpArr("realtionNew",fUnit))  q:fUnit=""  d
	.s fUnitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+fUnit)),3)
	.s toUnit=""
	.f  s toUnit=$o(TmpArr("realtionNew",fUnit,toUnit))  q:toUnit=""  d
	..s toUnitDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+toUnit)),3)
	..s unitData = $g(TmpArr("realtionNew",fUnit,toUnit))
	..s addFlag = $case($listget(unitData,2)'="",1:"新增",:"")
	..s unitData = $listtostring(unitData,"^")
	..s count=count+1
	..s listData = drugId_"^"_drugDesc_"^"_fUnitDesc_"^"_toUnitDesc_"^"_unitData_"^"_addFlag_"^"_fUnit_"^"_toUnit
	..s TmpArr("msg",count)=listData
	
	s TmpArr("count")=count
	
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2020-11-26
/// Description:： 用于手动生成全局规则中的前提条件项目
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).SaveGlobalRulePrioItm()
ClassMethod SaveGlobalRulePrioItm()
{
 
 	s globalData = ##class(web.DHCCKBCommon).GetGlobalData()
 	
 	TS
 	s ret=0
 	s dicID = ""
 	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",globalData,dicID))  q:(dicID="")||(ret'=0)  d
 	.s ruleDicId = ""
 	.f  s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicId))	q:(ruleDicId="")||(ret'=0)  d
 	..s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	..s ret=..SavePrioItm(ruleId,dicID)
	..q:ret'=0
	
	i ret'=0 tro
	e  tc
	
	q ret
}

/// Creator:	qunianpeng
/// CreatDate:	2020-11-26
/// Description:： 保存前提条件项目
/// Input:
/// Other:	w ##class(web.DHCCKBConfig).SavePrioItm()
ClassMethod SavePrioItm(rule, libary)
{
	n (rule,libary)
	
	s checkItmListProp=##class(web.DHCCKBCommon).GetCheckItmListProp()
	s ret=0
	
	s parent=""
	f  s parent=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent))  q:parent=""   d  
	.s node=""
	.f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent,node))  q:node=""   d  
	..q:node=0
	..s rulDataID=""
	..f  s rulDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",node,rulDataID))  q:rulDataID=""   d
	...q:rulDataID=0
	...s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(rulDataID)),4)	// 实体/属性
	...s leftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(rulDataID)),5)	// 属性
	...s valueDicId=leftDic
	...s link=+##class(web.DHCCKBRulePriority).GetValueByDicAttr(libary,checkItmListProp,valueDicId)
	...q:link'=0
	...s obj=##class(CT.CKB.PDSS.DicLinkAttr).%New()
	...d obj.DLADicDrSetObjectId(libary)
	...d obj.DLAAttrCodeSetObjectId(checkItmListProp)	
	...d obj.DLAAttrDrSetObjectId(valueDicId)
	...//s obj.DLAResult="Y"
	...s sc=obj.%Save()
	...s:$SYSTEM.Status.IsError(sc) ret=-6	
	
	q ret
}

/// Creator:	qunianpeng
/// CreatDate:	2020-12-03
/// Description:从用法用量的规则中抽取适应症,生成一条适应症规则
/// Input:  
/// Other:	w ##class(web.DHCCKBConfig).AutoMadeDiseaseRule()
ClassMethod AutoMadeDiseaseRule(dicId = "")
{
	n (dicId)
	
	// 1. 遍历所有的药品,遍历其中的用法用量规则,记录下疾病
	// 2. 生成一条只含有疾病的适应症规则, 规则备注,系统自动生成。 用法用量抽取规则
	s userId = "11871"
	s ruleIndic = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")
	s loginInfo = "11871^8^1^289^2"
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()	// 西药字典
	s chineseDrugData= ##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s chHerbalData = ##class(web.DHCCKBCommon).GetChineseHMData()	// 中药饮片
	
	TS
	s err = 0
	s drugId = ""
	F  s drugId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.q:(dicId'="")&(drugId'=dicId)	
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)&(parref'=chHerbalData)	// 中西药
	.s diagList = ""
	.s ruleDicID = ""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")  d
	..s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..s labelDesc = ##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:labelDesc'="用法用量"
	..d ..GetDiagList(.diagList,rule,0)	// 遍历用法用量规则,记录所有不重复的疾病(适应症)
	..
	.s isExistFlag = ..IsExistFlag(drugId)	// 是否抽过过规则
	.s retList = ""
	.i isExistFlag=0 s retList = diagList
	.e  s retList = ..MergeDiag(diagList,drugId,isExistFlag)	// 遍历适应症规则,观察是否已经抽取过规则,若抽取则合并
	.q:retList="" // 抽取过规则,且用法用量中没有新增
	.s ruleObj=..SetRuleObj(retList)
	.q:ruleObj=""
	.k root
	.q:ruleObj.%Get("if").%Size()=0
	.s root={}
	.d root.%Set("rule",ruleObj)
	.s status=""	// 保存
	.s ret=##class(web.DHCCKBRuleSave).save(0,"Release",root.%ToJSON(),userId,drugId_"^"_ruleIndic,loginInfo)	// save方法中,root是json字符串,不成直接传json对象
	.i ret<0 s err=1
	.i ret<0 tro
	.q:+ret<0
	.i ret<0 s err=1
	.i ret<0 tro
	.// 发布
	.//s ret=##class(web.DHCCKBRuleSave).save(ret,"Release",root.%ToJSON(),userId,drugId_"^"_usageId)	// save方法中,root是json字符串,不成直接传json对象
	.//i ret<0 s err=1
	.//i ret<0 tro
	.s ^TMP("DHCCKB","web.DHCCKBConfig","AutoMadeDiseaseRule",drugId,ret)=""

	i err=1 tro
	e  TCOMMIT
	
	q "完成"
	
ERROR11
	set ErrorMsg=$ZE                  //$ZE 获取错误信息
	TROLLBACK	                      //有异常，则回滚事务(Golbal才可以回滚,普通变量不能回滚)
	k ^TMP("DHCCKB","web.DHCCKBConfig","AutoMadeDiseaseRule")
	Quit ErrorMsg		             //返回错误信息
}

/// Creator:	qunianpeng
/// CreatDate:	2020-12-03
/// Description:从用法用量的规则中抽取(疾病)适应症
/// Input:  
/// Other:	w ##class(web.DHCCKBConfig).GetDiagList(diagList,rule)
ClassMethod GetDiagList(diagList, rule, parent)
{
	n (diagList,rule,parent)
	
	s disease = ##class(web.DHCCKBCommon).GetDisease()		// 西医疾病
	s diseaseDesc = ##class(web.DHCCKBCommon).DiseaseDesc()	// 西医疾病名称
	s chineseDis = ##class(web.DHCCKBCommon).ChineseDisease()	// 中医疾病
	s chineseDisName = ##class(web.DHCCKBCommon).ChineseDiseaseName() //中医疾病名称
	s diagPropList=$lb(disease,diseaseDesc,chineseDis,chineseDisName)

	s nodeID = ""
	f  s nodeID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",parent,nodeID)) q:nodeID=""  d
	.q:'$d(^CT.CKB.PDSS.RuleDataI("Node",nodeID))
	.i $d(^CT.CKB.PDSS.RuleNodeI("Parent",rule,"if",nodeID))  d ..GetDiagList(.diagList, rule,nodeID)	
	.s ruleDataID=""
	.f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Node",nodeID,ruleDataID))  q:ruleDataID=""  d
	..s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),5)    /// 关系指针(左)
	..s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4) 
	..s leftID = $case(leftValue="",1:leftDic,:leftValue)
	..q:$lf(diagPropList,leftID)=0	// 只找疾病项目
	..s opSign = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),7) 
	..q:opSign'="Equals"
	..s rightType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),10) 
	..q:rightType'="Constant"
	..s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8) 
	..s parref = $select(leftID=disease:disease,leftID=diseaseDesc:disease,leftID=chineseDis:chineseDis,leftID=chineseDisName:chineseDis,1:0)
	..s diagstr = rightDic_$c(1)_parref
	..q:$lf(diagList,diagstr)=1	// 已经存在的疾病不重复添加
	..s $List(diagList,*+1)=diagstr

	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2020-12-3
/// Description: 判断是否抽取过规则,若抽取过则返回抽取的id,若没抽取过,则返回0
/// Input:  
/// Other:	w ##class(web.DHCCKBConfig).IsExistFlag()
ClassMethod IsExistFlag(drugId)
{
	n (drugId)
	
	s retRule = 0
	s ruleDicID = ""
	f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")||(retRule'=0)  d
	.s rule = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	.s labelDesc = ##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	.q:labelDesc'="适应症"
	.s reMark = $lg($g(^CT.CKB.PDSS.RuleD(rule)),2)
	.s ruleName = $lg($g(^CT.CKB.PDSS.RuleD(rule)),3)
	.q:(reMark'="系统生成")&(ruleName'="用法用量抽取规则")	// 是否生成过规则
	.s retRule = rule	 // 记录抽取规则的id
	
	q retRule
}

/// Creator:	qunianpeng
/// CreatDate:	2020-12-7
/// Description: 适应症已经抽取过规则,是否有新增内容
/// Input:  
/// Other:	w ##class(web.DHCCKBConfig).MergeDiag()
ClassMethod MergeDiag(diagList, dicId, isExistFlag)
{
	n (diagList,dicId,isExistFlag)
	
	s rule = isExistFlag
	
	s newList = ""
	d ..GetDiagList(.newList, rule, 0)	// 获取抽取过的规则里面的疾病
	q:newList="" diagList	
 	s unionList = ##Class(web.DHCCKBCommonUtil).GetUnionList(diagList,newList)	
 	s retList = ""
 	i $listlength(unionList)>$listlength(newList) d
 	.s retList = unionList
 	e  d
 	.s retList = ""

 	q retList
}

/// 值_$c1_所属字典id
/// s diagList=$lb("11"_$c(1)_"22")
/// w ##Class(web.DHCCKBConfig).SetRuleObj("","","","","")
ClassMethod SetRuleObj(diagList)
{
	n (diagList)
	q:(diagList="") ""

	s ruleObj={}
	d ruleObj.%Set("_name","用法用量抽取规则")
	d ruleObj.%Set("remark","系统生成")
	d ruleObj.%Set("then","")
	// else 
	s outProp=##class(web.DHCCKBCommon).GetDicIdByCode("OutPrint")
	s sourceMsg=##class(web.DHCCKBCommon).GetDicIdByCode("SourceMsg")
	s valueObj={}
	d valueObj.%Set("_ruleData","0").%Set("_content","系统生成").%Set("_type","Input")
	s assign={}
	d assign.%Set("_varCategory",$case(+outProp'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(outProp)),3),:"")).%Set("_ruleData","0").%Set("_varCategoryId",outProp).%Set("_var",sourceMsg)
	d assign.%Set("_varLabel",$case(+sourceMsg'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(sourceMsg)),3),:"")).%Set("_datatype","String").%Set("_type","variable")
	d assign.%Set("value",valueObj)
	s elseObj={}.%Set("var-assign",assign)
	d ruleObj.%Set("else",elseObj)
	
	//if 
	s atomArr=[]
	s orArr=[]

	s diagAtomArr=[]
	if ($listlength(diagList)>1) {
		d ..SetDiagAtomArr(.diagAtomArr,diagList)	
		d orArr.%Push({}.%Set("atom",diagAtomArr))
		
	}elseif ($listlength(diagList)=1){
		d ..SetDiagAtomArr(.atomArr,diagList)
	}
	
	s ifObj={}
	if (atomArr.%Size()'=0){
		s andObj={}
		if (atomArr.%Size()=1){
			d andObj.%Set("atom",atomArr.%Get(0))				
		}
		else{			
			d andObj.%Set("atom",atomArr)		
		}		
		if (orArr.%Size()=1){		
			d andObj.%Set("or",orArr.%Get(0))
		}elseif(orArr.%Size()>1){
			d andObj.%Set("or",orArr)
		}			
		d ifObj.%Set("and",andObj)		
	}else{	
		if (orArr.%Size()=1){
			d ifObj.%Set("or",orArr.%Get(0))			
		}elseif (orArr.%Size()>1){
			s andObj={}
			d andObj.%Set("or",orArr)
			d ifObj.%Set("and",andObj)				
		}
	
	}
	
	if ifObj.%Size()'=0 d ruleObj.%Set("if",ifObj)

	
	q ruleObj
}

ClassMethod SetDiagAtomArr(atomArr, dataList)
{
	n (atomArr,dataList)
	// 疾病
	//s dataList=$lb(疾病_$c(1)_父指针,疾病_$c(1)_父指针)
	//s dataList=$lb(疾病_$c(1)_父指针)

 	s ptr=0	
	while $LISTNEXT(dataList,ptr,val){
		k atomObj
		s atomObj={}
		s type="Constant"
		s op="Equals"
		s result=$p(val,$c(1),1)
		s left = $p(val,$c(1),2)
		s leftValue = ""
		k leftObj
		s leftObj={}
		d leftObj.%Set("_varCategory",$lg($g(^CT.CKB.PDSS.CommonDictionD(+left)),3)).%Set("_ruleData","0").%Set("_varCategoryId","").%Set("_type","variable")
		d leftObj.%Set("_varLabel",$case(leftValue'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),2),:"")).%Set("_var",left).%Set("_datatype","String")
		
		k valueObj
		s valueObj={}
		q:type'="Constant"
		if (type="Constant"){	// 字典		
			s dicName=$case(result'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(result)),3),:"")
			d valueObj.%Set("_ruleData","0").%Set("_const-category",result).%Set("_const",result)
			d valueObj.%Set("_const-label",dicName).%Set("_type",type)		

		}
		d atomObj.%Set("left",leftObj)
		d atomObj.%Set("value",valueObj)
		d atomObj.%Set("_op",op)
		if (atomObj.%Size()'=0)	d atomArr.%Push(atomObj)
	}
	
	q ""
}

/// 导出生成适应症规则的药品列表
/// d ##class(%ResultSet).RunQuery("web.DHCCKBConfig","ExportDiseaseRuleDrug") 
/// w ##Class(websys.Query).ToExcel("抽取适应症药品的列表","web.DHCCKBConfig","ExportDiseaseRuleDrug")
Query ExportDiseaseRuleDrug() As websys.Query(ROWSPEC = "f1:%String:药品id,f2:%String:药品代码,f3:%String:药品描述,f4:%String:字典")
{
}

ClassMethod ExportDiseaseRuleDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s drugId = ""
	f  s drugId=$o(^TMP("DHCCKB","web.DHCCKBConfig","AutoMadeDiseaseRule",drugId))  q:drugId=""  d
	.s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),2)
	.s drugName = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.s parrefName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	.set listData=$lb(drugId,drugCode,drugName,parrefName)
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:	qunianpeng
/// CreatDate:	2020-12-7
/// Description: 批量补充规则的唯一标识
/// Input:  
/// Other:	w ##class(web.DHCCKBConfig).AutoSetRuleIdentity()
ClassMethod AutoSetRuleIdentity()
{
	
	s count = 0
	s rule = ""
	f  s rule = $o(^CT.CKB.PDSS.RuleD(rule)) q:rule=""  d
	.Hang 0.00001
	.s identity = "dhcckb,"_$Now()
	.w count,!
	.&sql(update CT_CKB_PDSS.Rule set R_UniqeIdentity=:identity where R_RowId=:rule )
	.s count =count +1
	
	q count
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-27
/// Description: 生成药品->目录->规则的关系
/// Input:  
/// Other:	
/// w ##class(web.DHCCKBConfig).AutoSetDrugLibaryRef()			-- 全部规则
/// w ##class(web.DHCCKBConfig).AutoSetDrugLibaryRef(160)       -- 药品规则
/// w ##class(web.DHCCKBConfig).AutoSetDrugLibaryRef(26857)		-- 全局规则
/// w ##class(web.DHCCKBConfig).AutoSetDrugLibaryRef(234756)    -- 字典规则
ClassMethod AutoSetDrugLibaryRef()
{
	k ^CT.CKB.PDSS.DrugLibaryRefI
	k ^CT.CKB.PDSS.DrugLibaryRefD
	
	/*
	105	DrugData	西药字典	
	108	ingredientData	成分字典	
	49802	GeneralData	化学名字典	
	78200	GeneralFromData	通用名字典	
	81790	ChineseDrugData	中成药字典	
	81862	ChineseHerbalMedicineData	中药饮片字典	
	120094	PrescriptionCopeData	处方应付字典	
	
	49551	DrugLibaryData	药品目录字典	17	  --目录
	75038	用药指导	用药指导	49551 		  --目录
	129805	给药操作指导	给药操作指导	75038 --目录
	130536	液体配置(总)	液体配置(总)	49551 --目录
	235403	RuleUsage(总)	用法用量(总)	49551 --目录
	235406	RuleIndic(总)	适应证(总)	49551	  --目录
	
	110	DrugPreMetData	给药途径字典	-- 字典规则	
	112	FormData	剂型字典			-- 字典规则
	117	SpecialPopData	特殊人群字典 	-- 字典规则
	
	24713	GlobalData	全局规则字典 	-- 全局规则	
	*/
	
	s countRule = 0,errCount=0
	//^CT.CKB.PDSS.RuleDicI("RuleDic",{RD_Rule},{RD_Dic},{RD_RowId})
	//^CT.CKB.PDSS.RuleDicI("Dic",{RD_Dic},{RD_RowId})
	s rule=""
	f  s rule=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule))  q:rule=""  d
	.//q:rule'=641618	
	.d ..SetDrugLibaryRefByRule(rule,.countRule,.errCount)
	/*
	.//q:rule'=63715
	.s newDrugId="",libaryId="",dicParrefId=""
	.s dicId=""
	.f  s dicId = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dicId)) q:dicId=""  d
	..s ruleDicId = ""
	..f  s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dicId,ruleDicId)) q:ruleDicId=""  d
	...s parref = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicId)),4)
	...s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	...// 目录 此种写法不能完全应用于自动生成药品目录关系,因为可能有新增的目录和字典规则
	...i $lf(libaryParList,parrefCode)'=0 s libaryId = dicId
	...// 药品
	...i $lf(drugParrefList,parrefCode)'=0 d 
	....s newDrugId = dicId
	....s dicParrefId = parref
	...// 全局
	...i $lf(dicRuleList,parrefCode)'=0 d 
	....s newDrugId = dicId
	....s libaryId=""
	....s dicParrefId = parref
	.
	.s ruleInfo = $lb(newDrugId,libaryId,rule,dicParrefId)
	.i +newDrugId=0 s errCount = errCount + 1,TmpArr("ErrRule",rule)=ruleInfo
	.q:+newDrugId=0
	.q:$d(^CT.CKB.PDSS.DrugLibaryRefI("DrugRule",newDrugId,rule))	// 防止重复插入数据
	.&sql(insert into DHC_CKBDrugLibaryRef (DLR_Drug_Dr,DLR_Libary_Dr,DLR_Rule_Dr,DLR_DicParref_Dr) values (:newDrugId,:libaryId,:rule,:dicParrefId))
	.i SQLCODE=0  d
	..s countRule = countRule + 1
	..//w countRule,!

	*/
	w "生成规则:"_countRule_"条,  错误规则:"_errCount_"条",!
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-27
/// Description: 生成药品->目录->规则的关系
/// Input:    w ##class(web.DHCCKBConfig).SetDrugLibaryRefByRule(641618)
ClassMethod SetDrugLibaryRefByRule(rule, countRule = 0, errCount = 0)
{
	n (rule,countRule,errCount)
	// 编辑器移动规则时,没有更新此关系表,可能会存在问题
	s $ZT="ErrSetDrugLibaryRefByRule"
	s drugParrefList = $lb("DrugData","ingredientData","GeneralData","GeneralFromData","ChineseDrugData","ChineseHerbalMedicineData","PrescriptionCopeData")
	s libaryParList = $lb("DrugLibaryData","用药指导","给药操作指导","RuleUsage(总)","RuleIndic(总)")
	k TmpLibArr
	s guideId = ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")
	d ##class(web.DHCCKBRuleIndex).QueryAllCatDic(.TmpLibArr,guideId)
	s index = ""
	f  s index = $o(TmpLibArr(index))  q:index=""  d
	.s libCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+index)),2)
	.q:libCode=""
	.s $list(libaryParList,*+1) = libCode
	
	s dicRuleList = $lb("DrugPreMetData","FormData","SpecialPopData","GlobalData") // 字典+全局规则
	k TmpArr
	s newDrugId="",libaryId="",dicParrefId=""
	s dicId=""
	f  s dicId = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dicId)) q:dicId=""  d
	.s ruleDicId = ""
	.f  s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",rule,dicId,ruleDicId)) q:ruleDicId=""  d
	..s parref = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicId)),4)
	..s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	..// 目录 此种写法不能完全应用于自动生成药品目录关系,因为可能有新增的目录和字典规则
	..i $lf(libaryParList,parrefCode)'=0 s libaryId = dicId
	..// 药品
	..i $lf(drugParrefList,parrefCode)'=0 d 
	...s newDrugId = dicId
	...s dicParrefId = parref
	..// 全局
	..i $lf(dicRuleList,parrefCode)'=0 d 
	...s newDrugId = dicId
	...s libaryId=""
	...s dicParrefId = parref
	
	s ruleInfo = $lb(newDrugId,libaryId,rule,dicParrefId)
	i +newDrugId=0 s errCount = errCount + 1,TmpArr("ErrRule",rule)=ruleInfo
	q:+newDrugId=0 ""
	q:$d(^CT.CKB.PDSS.DrugLibaryRefI("DrugRule",newDrugId,rule)) ""	// 防止重复插入数据
	&sql(insert into CT_CKB_PDSS.DrugLibaryRef (DLR_Drug_Dr,DLR_Libary_Dr,DLR_Rule_Dr,DLR_DicParref_Dr) values (:newDrugId,:libaryId,:rule,:dicParrefId))
	i SQLCODE=0  d
	.s countRule = countRule + 1
	.
		
	q ""
ErrSetDrugLibaryRefByRule
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-30
/// Description: 删除药品->目录->规则的关系
/// Input:    w ##class(web.DHCCKBConfig).DeleteDrugLibaryRefByRule(234756)
ClassMethod DeleteDrugLibaryRefByRule(rule)
{
	n (rule)
	
	s $ZT="DeleteDrugLibaryRefByRule"
	q:+rule=0 ""
	&sql(delete from DHC_CKBDrugLibaryRef where DLR_Rule_Dr=:rule)
		
	q SQLCODE
DeleteDrugLibaryRefByRule
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-30
/// Description: 移动药品->目录->规则的关系(移动规则时，重新生药品->目录->规则关系)
/// Input:  	ruleId
/// Other:	
/// w ##class(web.DHCCKBConfig).MoveDrugLibaryRefByRule()
ClassMethod MoveDrugLibaryRefByRule(ruleId)
{
	d ..DeleteDrugLibaryRefByRule(ruleId)
	d ..SetDrugLibaryRefByRule(ruleId)
	
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-28
/// Description:  批量修改兜底规则的级别
/// Input:  
/// Other:	
/// w ##class(web.DHCCKBConfig).AutoUpdateBaseRuleLevel()	
ClassMethod AutoUpdateBaseRuleLevel(queryDrugId = "")
{
	n (queryDrugId)
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s chinaHMDrugData=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片字典
	s levelFlagId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")	// 管理级别id
	s forbidId = ##class(web.DHCCKBCommon).GetDicIdByCode("forbid")	// 管理级别id
	
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.q:(queryDrugId'="")&(drugId'=queryDrugId)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.//q:parref'=chinaHMDrugData	
	.s ruleDicID=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..s ruleStauts=$lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	..//q:ruleStauts'="Release"
	..s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:labelDesc'="用法"
	..s ruleDataID = ""
	..f  s ruleDataID = $o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataID)) q:ruleDataID=""  d
	...s prop = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)
	...q:levelFlagId'=prop	// 不等于管理级别的则退出
	...&sql(update CT_CKB_PDSS.RuleData set RD_RightDic=:forbidId where RD_RowID=:ruleDataID)
	
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-28
/// Description:  批量修改用法用量和用法(兜底)规则的节点关系or 为 and (单次剂量,单次最大量,单次极量,日剂量,日最大量,日剂量出现数量大于2)
/// Input:  
/// Other:	
/// w ##class(web.DHCCKBConfig).UpdateUseRuleNode()	
ClassMethod UpdateUseRuleNode()
{
	
	s drugData=##class(web.DHCCKBCommon).GetDrugData()					// 西药字典
	s chineseDrugData=##class(web.DHCCKBCommon).GetChineseDrugData()	// 中成药字典
	s chinaHMDrugData=##class(web.DHCCKBCommon).GetChineseHMData()		// 中药饮片字典
	
	k ruleArr
	s drugId=""
	F  s drugId=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId)) Q:drugId=""  D
	.//q:drugId'=154
	.//q:(queryDrugId'="")&(drugId'=queryDrugId)
	.s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	.q:(parref'=drugData)&(parref'=chineseDrugData)	// 中西药
	.//q:parref'=chinaHMDrugData	
	.s ruleDicID=""
	.f  s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicID)) 	q:(ruleDicID="")  d
	..s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicID)),2)
	..//q:rule'="357823"
	..s labelDesc=##Class(web.DHCCKBPassNew).GetRuleLabelDesc(rule)
	..q:(labelDesc'="用法")&&(labelDesc'="用法用量")
	..//q:(labelDesc'="用法用量")
	..//q:(labelDesc'="用法")
	..s nodeID=0
	..d ##class(web.DHCCKBConfig).InvRuleData(nodeID,rule,.ruleArr,drugId)	
	
	// 用法用量:2730条
	// 用法:1984条
	s count = 0
	s index = ""
	f  s index = $o(ruleArr(index)) q:index=""  d
	.s count = count + 1
	
	q count
	
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-03-28
/// Description:  批量修改用法用量和用法(兜底)规则的节点关系or 为 and (单次剂量,单次最大量,单次极量,日剂量,日最大量,日剂量出现数量大于2)
/// Input:  
/// Other:	
/// w ##class(web.DHCCKBConfig).InvRuleData()	
ClassMethod InvRuleData(parentID, ruleID, ruleArr, drugId)
{
	n (parentID,ruleID,ruleArr,drugId)
	
	s useDoseList = $lb("DayDose","DayDoseMax","DayDoseLimit","OnceDose","OnceDoseMax","OnceDoseLimit")	
	s nodeID = ""
	F  s nodeID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID,"if",parentID,nodeID)) Q:nodeID=""  D
	.s relType=$lg($g(^CT.CKB.PDSS.RuleNodeD(nodeID)),3)   	// 关系类型
	.//q:'$d(^CT.CKB.PDSS.RuleDataI("Node",nodeID)) 存在空节点 和多余节点
	.s nodeCount = 0
	.s ruleDataID = ""
	.f  s ruleDataID = $o(^CT.CKB.PDSS.RuleDataI("Node",nodeID,ruleDataID))  q:ruleDataID=""  d 
	..s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)
	..s leftDicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),2)
	..i $lf(useDoseList,leftDicCode)>0 d
	...s nodeCount=nodeCount+1
	.
	.i (nodeCount>=2)&(relType="or") d
	..s andRelType = "and"
	..s ruleArr(ruleID) = drugId_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..&sql(update CT_CKB_PDSS.RuleNode set RN_Condition=:andRelType where RN_RowID=:nodeID)
	.
	.q:'$d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID,"if",nodeID))	// 没有子节点
	.d ..InvRuleData(nodeID,ruleID,.ruleArr,drugId)
}

/// Author: 	qunianpeng
/// CreateDate: 2022-04-12
/// Descript: 	获取知识库数据信息并暂存
/// Input：		类型
/// w ##class(web.DHCCKBConfig).SetDataListForCdss()
ClassMethod SetDataListForCdss(loginInfo As %String = "") As %String
{

	n (loginInfo)
	
	s typeList = $lb("DiseaseData","SymptomData")	
	f i=1:1:$ll(typeList)  d
	.s type = $lg(typeList,i)
	.s parref = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	.q:+parref=0
	.s h = 0 
	.s dicID=""   
	.f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))   q:dicID=""  d
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	..q:(0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo))
	..
	..i linkDr'="" d
	...s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	...q:(linkDr'="")&(0=##class(web.DHCCKBCommon).IsShow(linkDr,"DHC_CKBCommonDiction",loginInfo))
	..
	..s data=dicID_"^"_dicCode_"^"_dicDesc
	..q:$d(^TMP("DHCCKB","web.DHCCKBConfig","SetDataListForCdss",type,dicID))
	..s h = h + 1
	..s ^TMP("DHCCKB","web.DHCCKBConfig","SetDataListForCdss",type,dicID)=data
		
	q ""
}

/// Author: 	qunianpeng
/// CreateDate: 2022-07-06
/// Descript: 	清除授权表中的审核项目授权
/// Input：		
/// w ##class(web.DHCCKBConfig).InitPermis()
ClassMethod InitPermis() As %String
{
	s dicType = "DHC_CKBDicLinkAttr"
	s dicTypeCom = "DHC_CKBCommonDiction"
	s fun = "businessAuth"
	s typeList = $lb("U","L","C","D")
	
	f i=1:1:$ll(typeList)  d
	.s type = $lg(typeList,i)
	.&sql(delete from CKB_PDSS.DicLog where DLG_Scope=:type and DLG_Function=:fun and DLG_Dic=:dicType)
	.&sql(delete from CKB_PDSS.DicLog where DLG_Scope=:type and DLG_Function=:fun and DLG_Dic=:dicTypeCom)
	
	k ^CF.CKB.PDSS.GrantAuthD
	k ^CF.CKB.PDSS.GrantAuthI
	
	q "初始化授权成功"
}

/// Description:	数据迁移主程序入口
/// Creator:		LiDong
/// CreateDate:		2022-8-30
/// Input:			字典ID  西药105  中成药81790
/// return:			
/// other:			w ##class(web.DHCCKBConfig).DataTransMain()
/// 数据导出：		d ##class(%ResultSet).RunQuery("web.DHCCKBConfig","ExportDrugData")
ClassMethod DataTransMain()
{
	s DicList=$lb("DrugData","ChineseDrugData")
	s DicLen=$ll(DicList)
	
	f i=1:1:DicLen  d
	.s Dic=$lg(DicList,i)
	.s ID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(Dic),""))
	.s RowID=""
	.f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ID,RowID))  q:RowID=""  d
	..s param=ID_"^"_RowID_"^"_""
	..//q:(RowID'=24451)
	..///请务必确保不要的值的属性Code在第一位，要值的属性Code在第二位
	..///如需添加新的迁移内容，请更新TransOneToTwo方法中拼接串的内容
	..s ListDataf=..CheckRuleContrNew(param,"RuleContrTwo","RuleContr")
	..s ListDatas=..CheckRuleContrNew(param,"InterEach","DrugInterEach")
	..s ListDatat=..CheckRuleContrNew(param,"PhaAction","PhaToxicology")
	..s Retf=..UpdDLAByStatus(ListDataf)
	..s Rets=..UpdDLAByStatus(ListDatas)
	..s Rett=..UpdDLAByStatus(ListDatat)

	q:(Retf=0)&&(Rets=0)&&(Rett=0) "迁移成功"
	q:Retf'=0 "禁忌迁移失败"
	q:Rets'=0 "相互作用迁移失败"
	q:Rett'=0 "药理作用迁移失败"
}

/// Description:	判断属于哪种情况
/// Creator:		LiDong
/// CreateDate:		2022-8-29
/// Input:			药品代码
/// return:			status  1：第一有第二无  2：两个一样  3：两个都有且不同  4：符合情况，不用修改
/// other:			w ##class(web.DHCCKBConfig).CheckRuleContrNew("105^81647^","RuleContrTwo","RuleContr")
ClassMethod CheckRuleContrNew(param, attrf, attrs)
{
	n (param,attrf,attrs)
	s attrValList=""
	s attrList=$lb(attrf,attrs)
	s dicID=$p(param,"^",2)
	s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	s Len=$ll(attrList)
	s tmpArr=""
	f i=1:1:Len d
	.s CDCode=$lg(attrList,i)  ///RuleContrTwo	
	.s CDRowID=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(CDCode),""))
	.s Node =i_CDCode
	.s tmpArr(Node,CDRowID)=""
	.q:+CDRowID=0
	.s linID =""
	.f  s linID = $o(^CT.CKB.PDSS.CommonDictionI("Link",CDRowID,linID)) q:linID=""  d
	..s tmpArr(Node,linID)=""
	s Code =""
	f  s Code = $o(tmpArr(Code))  q:Code=""  d
	.s ID = "",Flag=0
	.f  s ID = $o(tmpArr(Code,ID)) q:((ID="")||(Flag=1))  d
	..s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",ID,dicID,""))
	..s:DLARowID'="" Flag=1
	..q:DLARowID=""
	..s DLAResult=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)
	..i ((DLAResult=$c(10))||(DLAResult=$c(13)))  d
	...s DLAResult=""
	..i attrValList="" d
	...s attrValList=DLAResult_"^"_DLARowID
	..e  d
	...s attrValList=attrValList_"^"_DLAResult_"^"_DLARowID
	s attrValf  =$p(attrValList,"^",1)
	s attrValfID=$p(attrValList,"^",2)
	s attrVals  =$p(attrValList,"^",3)
	s attrValsID=$p(attrValList,"^",4)
	///不要值的有要值的无
	i ((attrValf'="")&&(attrVals=""))  d				
	.s Ret="1"_"^"_attrValf_"^"_attrVals_"^"_attrValfID_"^"_attrValsID_"^"_dicID_"^"_dicCode_"^"_dicDesc_"^"_attrf
	///两个一样
	i ((attrValf'="")&&(attrVals'="")&&(attrValf=attrVals))  d							
	.s Ret="2"_"^"_attrValf_"^"_attrVals_"^"_attrValfID_"^"_attrValsID_"^"_dicID_"^"_dicCode_"^"_dicDesc_"^"_attrf
	///两个都有且不一样
	i ((attrValf'="")&&(attrVals'="")&&(attrValf'=attrVals))  d						
	.s Ret="3"_"^"_attrValf_"^"_attrVals_"^"_attrValfID_"^"_attrValsID_"^"_dicID_"^"_dicCode_"^"_dicDesc_"^"_attrf
	///不要值的无要值的有，符合情况
	i ((attrValf="")&&(attrVals'=""))  d				
	.s Ret="4"_"^"_attrValf_"^"_attrVals_"^"_attrValfID_"^"_attrValsID_"^"_dicID_"^"_dicCode_"^"_dicDesc_"^"_attrf
	///两个都为空
	i ((attrValf="")&&(attrVals=""))  d				
	.s Ret="5"_"^"_attrValf_"^"_attrVals_"^"_attrValfID_"^"_attrValsID_"^"_dicID_"^"_dicCode_"^"_dicDesc_"^"_attrf
	q Ret
}

/// Description:	根据情况进行数据处理
/// Creator:		LiDong
/// CreateDate:		2022-8-29
/// Input:			ListData 状态_"^"_第一个值_"^"_第二个值_"^"_第一个值ID_"^"_第二个值ID_"^"_药品ID_"^"_药品描述
/// Table:			DHC_CKBDicLinkAttr 	
/// return:			0 更新成功
/// other:			w ##class(web.DHCCKBConfig).UpdDLAByStatus("1^有青霉素类药物过敏史者或青霉素皮肤试验阳性患者禁用。^^473689^^152^注射用苄星青霉素120万U（华北制药股份有限公司）^注射用苄星青霉素120万U（华北制药股份有限公司）^RuleContrTwo")
ClassMethod UpdDLAByStatus(ListData)
{
	n (ListData)
	TS
	s Ret=0
	s Status=$p(ListData,"^",1)   		///状态
	s FirstVal=$p(ListData,"^",2)   		///第一个值
	s SecondVal=$p(ListData,"^",3)   		///第二个值
	s FirstID=$p(ListData,"^",4)   		///第一个值ID
	s SecondID=$p(ListData,"^",5)   		///第二个值ID
	s DicID=$p(ListData,"^",6)   		///药品ID
	s DicCode=$p(ListData,"^",7)   		///药品Code
	s DicDesc=$p(ListData,"^",8)   		///药品Desc
	s attrf=$p(ListData,"^",9)   		///标识
	i Status=1  d
	.s Ret=..TransOneToTwo(DicID, FirstVal,FirstID,SecondID,attrf)
	.s Ret=..DeleteLog(FirstID, DicID)
	i Status=2  d
	.s Ret=..UpdOneToNull(DicID, FirstID)
	.s Ret=..DeleteLog(FirstID, DicID)
	i Status=3  d
	.s Ret=..RecordDic(attrf,DicID,DicCode,DicDesc)
	i Status=4  d
	.s Ret=..UpdOneToNull(DicID, FirstID)
	.s Ret=..DeleteLog(FirstID, DicID)
	i Status=5  d
	.s Ret=..UpdOneToNull(DicID, FirstID)
	.s Ret=..DeleteLog(FirstID, DicID)
	i Ret'=0  d
	.TRO
	e  d
	.TC
	q Ret
}

/// Description:	状态为1，迁移第一个数据到第二个里边
/// Creator:		LiDong
/// CreateDate:		2022-8-29
/// Input:			ListData 状态_"^"_第一个值_"^"_第二个值_"^"_第一个值ID_"^"_第二个值ID_"^"_药品名称
/// Table:			DHC_CKBDicLinkAttr 	
/// return:			0 更新成功
ClassMethod TransOneToTwo(DicID, FirstVal, FirstID, SecondID, attrf)
{
	n (DicID, FirstVal,FirstID,SecondID,attrf)
	&SQL(
	DELETE FROM CT_CKB_PDSS.DicLinkAttr
	WHERE DLA_RowID=:FirstID
	)
	i SecondID=""  d
	.i attrf="RuleContrTwo" d
	..s ListData=""_"^"_DicID_"^"_4126_"^"_""_"^"_FirstVal_"^"_""_"^"_""
	.i attrf="InterEach" d
	..s ListData=""_"^"_DicID_"^"_3948_"^"_""_"^"_FirstVal_"^"_""_"^"_""
	.i attrf="PhaAction" d
	..s ListData=""_"^"_DicID_"^"_78004_"^"_""_"^"_FirstVal_"^"_""_"^"_""
	.s Type="textarea",LoginInfo="11871^8^1^289^2",ClientIPAddress="113.140.81.66"
	.s Ret=##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(ListData, Type, LoginInfo, ClientIPAddress)
	e  d
	.&SQL(UPDATE CT_CKB_PDSS.DicLinkAttr SET DLA_Result=:FirstVal WHERE DLA_RowID=:SecondID)
	.s Ret=SQLCODE
	q Ret
}

/// Description:	状态为2，更新第一条数据为空
/// Creator:		LiDong
/// CreateDate:		2022-8-29
/// Input:			ListData 状态_"^"_第一个值_"^"_第二个值_"^"_第一个值ID_"^"_第二个值ID_"^"_药品名称
/// Table:			DHC_CKBDicLinkAttr 	
/// return:			0 更新成功
ClassMethod UpdOneToNull(DicID, FirstID)
{
	n (DicID,FirstID)
	&SQL(
	DELETE FROM CT_CKB_PDSS.DicLinkAttr
	WHERE DLA_RowID=:FirstID
	)
	q SQLCODE
}

/// Description:	状态为3，记录药品名称
/// Creator:		LiDong
/// CreateDate:		2022-8-29
/// Input:			Order,DicValue 	
/// return:			DicValueList
/// ^TMP("RuleContrTwo",81646)
ClassMethod RecordDic(attrf, DicID, DicCode, DicDesc)
{
	n (attrf,DicID,DicCode,DicDesc)
	s ^TMP(attrf,DicID)=DicCode_"^"_DicDesc
	q 0
}

/// Description:	删除药品日志及属性日志
/// Creator:		LiDong
/// CreateDate:		2022-9-1
/// Input:			FirstID,dicID 	
/// return:			0 删除成功 其他  删除失败
ClassMethod DeleteLog(FirstID, dicID)
{
	n (FirstID,dicID)
	&SQL(
	SELECT DLA_Dic_Dr,DLA_AttrCode
	INTO :drugID,:AttrID
	FROM CT_CKB_PDSS.DicLinkAttr
	WHERE DLA_RowID=:FirstID
	)
	i (($d(drugID))&&($d(AttrID)))  d
	.s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugID,AttrID,""))
	q:(('$d(drugID))||('$d(AttrID))) 0
	&SQL(
	DELETE FROM CKB_PDSS.DicLog
	WHERE DLG_Dic="DHC_CKBDicLinkAttr"  AND DLG_Data_Dr=:DicAttrId
	)
	&SQL(
	DELETE FROM CKB_PDSS.DicDataLog
	WHERE DDL_EntyID=:drugID  AND DDL_AttrID=:AttrID
	)
	q SQLCODE
}

/// Creator:      Lidong
/// CreatDate:    2022-9-1
/// Description:  将情况为3的药品信息导出
/// Input:		  ^Tmp(FirstVal,DicID)
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBConfig","ExportDrugData")
/// w ##Class(websys.Query).ToExcel("CKB_Excel","web.DHCCKBConfig","ExportDrugData")
Query ExportDrugData() As websys.Query(ROWSPEC = "dicCode:%String:药品代码,dicCode:%String:药品描述,RuleFlag:%String:禁忌禁忌症,InterFlag:%String:相互药物相互,PhaFlag:%String:药理药理毒理")
{
}

ClassMethod ExportDrugDataExecute(ByRef qHandle As %Binary) As %Status
{
	
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	s attrList=$lb("RuleContrTwo","InterEach","PhaAction")
	s attrLen=$ll(attrList)
	f i=1:1:attrLen  d
	.s val=$lg(attrList,i)
	.s index=""
	.f  s index=$o(^TMP(val,index)) q:index=""  d
	..i val="RuleContrTwo"  d
	...s RuleFlag=1
	...s InterFlag=0
	...s PhaFlag=0
	..i val="InterEach"  d
	...s RuleFlag=0
	...s InterFlag=1
	...s PhaFlag=0
	..i val="PhaAction"  d
	...s RuleFlag=0
	...s InterFlag=0
	...s PhaFlag=1
	..s dicCode=$p(^TMP(val,index),"^",1)
	..s dicDesc=$p(^TMP(val,index),"^",2)
    ..d OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(dicCode,dicDesc,RuleFlag,InterFlag,PhaFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ExportDrugDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ExportDrugDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// 导出global： d ##class(web.DHCCKBConfig).ExportGlobal12()
/// 导入global： d $SYSTEM.OBJ.ImportDir("D:\","DHCCKBDHCCKBCheckRuleBaseData.gof")
ClassMethod ExportGlobal12()
{
	
	k CList
	k myIdx
	
	//字典表
	s CList($i(CList))="DHCCKBCC.GBL" // 数据对照表 DHCCKBComContrast.cls	
	
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)_$zts
	s filename = "D:\DHCCKBCC"_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

}
