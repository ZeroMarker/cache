/// 名称:	EMR.DOC.HISInterface.PatientInfoAssist
/// 描述:	电子病历取HIS信息接口类
/// 编写者：	yejian
/// 编写日期: 	2020-12-28
Class EMR.DOC.HISInterface.PatientInfoAssist Extends %RegisteredObject
{

/// 1 武汉第一医院
Parameter HospitalWHDYYY = "WHDYYY";

/// 2 北京积水潭医院 ok
Parameter HospitalBJJSTYY = "BJJSTYY";

/// 3 安徽省立医院
Parameter HospitalAHSLYY = "AHSLYY";

/// 4 安徽心脑心血医院
Parameter HospitalAHXNXGYY = "AHXNXGYY";

/// 5 西安交大口腔医院
Parameter HospitalXAJDKQYY = "XAJDKQYY";

/// 6 粤北人民医院 ok
Parameter HospitalYBRMYY = "YBRMYY";

/// 7 北京协和医院
Parameter HospitalBJXHYY = "BJXHYY";

/// 8 北京妇产医院
Parameter HospitalBJFCYY = "BJFCYY";

/// 9 北京地坛医院
Parameter HospitalBJDTYY = "BJDTYY";

/// 10 医科院肿瘤医院
Parameter HospitalYKYZLYY = "YKYZLYY";

Parameter NoTransDept = "无";

/// Desc：	取患者指针(PatientID)，not different from hospitals
/// Table:	PA_Adm.PAADM_PAPMI_DR
/// Others：被下列模板引用
ClassMethod GetPapmiDR(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s retValue = ""
	s retValue = $P($g(^PAADM(argAdmId)),"^",1)
	q:(retValue '= "") retValue

	//华西医院：global节点中的数据丢失，但sql语句可以查询出数据
	&sql(select PAADM_PAPMI_DR into :retValue from SQLUser.PA_Adm where PAADM_RowId = :argAdmId)
	q retValue
}

/// Desc:	出生日期【内部格式】
/// Others：not different from hospitals 
ClassMethod Birthday(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	s Birthday=""
	
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	s Birthday=$P($G(^PAPER(argPapmiDR,"ALL")),"^",6)
	
	q Birthday
}

/// Desc:	入院日期时间【Cache内部格式】
/// Table：	PA_Adm.PAADM_AdmDate，PA_Adm.PAADM_AdmTime
/// Output: date_","_time
ClassMethod AdmDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s admdatetime="",admdate="",admtime=""
	
	/*
	// not different from hospitals
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s admdate=$P($G(^PAADM(argAdmId)),"^",6)
	s admtime=$P($G(^PAADM(argAdmId)),"^",7)
	if (admdate'="")&&(admtime'="") 
	{
		s admdatetime=admdate_","_admtime
	}*/
	//统一入院时间接口，增加住院患者判定规则。
	s AdmType=$p($g(^PAADM(argAdmId)),"^",2)
	q:(AdmType="") ""
	if (AdmType="I")
	{
		s admdatetime=##class(web.DHCDischargeHistory).GetAdminDateTime(argAdmId)
		s:(admdatetime'="^") admdatetime=$tr(admdatetime,"^",",")
		s:(admdatetime="^") admdatetime=""
	}
	else
	{
		s admdate=$P($G(^PAADM(argAdmId)),"^",6)
		s admtime=$P($G(^PAADM(argAdmId)),"^",7)
		s admdatetime=admdate_","_admtime
	}
	
	q admdatetime
}

/// Create:	liuyunfei 
/// Input:  argAdmId:	Pa_Adm.PAADM_RowId
/// Output:	就诊时间
/// Desc:	根据就诊ID获取就诊时间
/// Debug:	w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetDiagAdmDate(179)
ClassMethod GetDiagAdmDate(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s diagDateTime=""
	//就诊时间
	s diagdate=$P($G(^PAADM(argAdmId)),"^",6)
	s diagtime=$P($G(^PAADM(argAdmId)),"^",7)
	s diagDateTime=diagdate_","_diagtime
	s:(diagDateTime=",") diagDateTime=""
	q diagDateTime
}

/// Create:	liuyunfei 
/// Input:  argAdmId:	Pa_Adm.PAADM_RowId
/// Output:	入院时间
/// Desc:	根据就诊ID获取入院时间(住院取入院时间标准接口)
/// Debug:	w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetAdmDate(179)
ClassMethod GetAdmDate(argAdmId As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s admDateTime=""
	//入院时间
	s admDateTime=##class(web.DHCDischargeHistory).GetAdminDateTime(argAdmId)
	s:(admDateTime'="^") admDateTime=$tr(admDateTime,"^",",")
	s:(admDateTime="^") admDateTime=""
	q admDateTime
}

/// Create:	liuyunfei 
/// Output:	入院时间
/// Desc:	IP地址^会话ID^在线状态^计算机名^计算机MAC
/// Debug:	w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetClientInfo()
ClassMethod GetClientInfo(aLoginID As %String = "") As %String
{
	s clientInfo = ""
	/*
	q:(##class(%Dictionary.CompiledClass).%ExistsId("User.DHCClientLogin") = "0") clientInfo
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("User.DHCClientLogin||GetInfo") = "0") clientInfo
	s clientInfo = ##Class(User.DHCClientLogin).GetInfo()
	//去掉Session信息
	if (RowId="") && $d(%session) {
		Set RowId = $g(%session.Data("LOGON.SSUSERLOGINID"))
	}
	*/
	q:(aLoginID="") ""
	Quit ^SST("LOG",aLoginID,"ADDR")
	q clientInfo
}

/// Create:	guozongtao 
/// Input:	argPapmiDr:	Pa_PatMas.Papmi_RowId
/// 		argAdmId:	Pa_Adm.PAADM_RowId
/// 		argAdmDate: Pa_Adm.PAADM_AdmDate
/// 		argAdmTime: Pa_Adm.PAADM_AdmTime
/// Output:	年龄显示字符串
/// Desc:	根据病人ID和就诊ID获取病人年龄
/// Debug:	w ##class(EMR.DOC.HISInterface.PatientInfoAssist).Age(277,701,64266,50856)
ClassMethod Age(argPapmiDr As %String, argAdmId As %String, argAdmDate As %String, argAdmTime As %String) As %String
{
	s ReturnValue=""
	
	//增加医院id入参
	s HospitalID="",LocID=""
	s LocID=..CurrentDept(argAdmId)
	if LocID="" quit ReturnValue
	s hospitalID=$piece($get(^CTLOC($p(LocID,"^",1))),"^",22)


	//调用年龄统一接口
	s ReturnValue = ##class(web.DHCBillInterface).GetPapmiAge(argPapmiDr,argAdmId,hospitalID,argAdmDate,argAdmTime)
	
	q ReturnValue
}

/// Desc: 病案年龄 
/// Input: $$CalAge^at182的返回值
/// Output: 	age>1岁，返回：N_"^"_岁
/// 			age<1岁，返回：1^岁
/// Others: Belong to ClassMethod Age
ClassMethod GetRecordAge(tmpAge As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""

	//定义变量
	s RecordAge="",RecordAgeUnit=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	
	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{		
		//病案年龄(岁)
		s RecordAge=tmpAgeYear ,RecordAgeUnit="岁"
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{			
			//病案年龄(岁)
			s RecordAge=1 ,RecordAgeUnit="岁"
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{				
				//病案年龄(岁)
				s RecordAge=1 ,RecordAgeUnit="岁"
			} 
			elseif (tmpAgeDay=0)
			{
				//病案年龄(岁)
				s RecordAge=1 ,RecordAgeUnit="岁"
			}  
		}
	}
	else
	{
		q ""
	}
	s RecordAge=RecordAge_"^"_RecordAgeUnit
	
	q RecordAge
}

/// Desc: 	新生儿年龄 
/// Input:	tmpAge: $$CalAge^at182的返回值
/// 	 	argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// Output:  age>1岁，返回：空值
/// 			age<1岁，返回：N天
/// Others: Belong to ClassMethod Age
ClassMethod GetBabyAge(tmpAge As %String, argBirthday As %String, argAdmDate As %String) As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""

	//定义变量
	s BabyAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
	}
	elseif (tmpAgeYear=0)
	{
		//年龄小于1岁 计算天数
		/*s BabyAge=(argAdmDate-argBirthday)
		
		//校验ClinicAge
		if BabyAge=0
		{
			s BabyAge=BabyAge+1
		}
		s BabyAge=BabyAge_"天"*/
		if (tmpAgeMonth>0)
		{			
			if (tmpAgeDay>0)
			{		
				//新生儿年龄(月 日/30)		
				s BabyAge=tmpAgeMonth_" "_tmpAgeDay_"/30"
			} 
			elseif (tmpAgeDay=0)
			{
				//新生儿年龄(月 日/30)
				s BabyAge=tmpAgeMonth
			} 
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{				
				//新生儿年龄(岁)
				s BabyAge=tmpAgeDay
			} 
			elseif (tmpAgeDay=0)
			{
				q ""
			}  
		}		
	}
	else
	{
		q ""
	}
	
	q BabyAge
}

/// Desc: 	临床年龄 / 自然年龄
/// Input：	tmpAge：$$CalAge^at182的返回值
/// 			argBirthday: 出生日期
/// 	 	argAdmDate：就诊日期
/// 	 	argCondition: 一般为14岁
/// 	 	argDetail：
/// Output： age>argCondition，返回：N岁 
/// 			1<=age<argCondition, 返回：N岁N月 
/// 			age<1岁，返回：N天
/// Others:	Belong to ClassMethod Age   
ClassMethod GetClinicAge(tmpAge As %String, argBirthday As %String, argAdmDate As %String, argCondition As %String = "14", argDetail As %String = "N") As %String
{
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	q:($d(argBirthday)=0)||(argBirthday="") ""
	q:($d(argAdmDate)=0)||(argAdmDate="") ""
	q:(argCondition<0)||(argCondition>200) ""

	//定义变量  argDetail  argCondition  argFormat
	s ClinicAge=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""

	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
			
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
		if (tmpAgeYear<argCondition)
		{
		 	if (tmpAgeMonth'=0)
			{
				s ClinicAge=tmpAgeYear_"岁"_tmpAgeMonth_"月"
			}
			elseif (tmpAgeMonth=0)
			{
				s ClinicAge=tmpAgeYear_"岁"
			}
		}
		elseif (tmpAgeYear>=argCondition)
		{
			s ClinicAge=tmpAgeYear_"岁"
		}
	}
	elseif (tmpAgeYear=0)
	{
		//年龄小于1岁 计算天数
		s ClinicAge=(argAdmDate-argBirthday)
	
		//校验ClinicAge
		if ClinicAge=0
		{
			s ClinicAge=ClinicAge+1
		}
		s ClinicAge=ClinicAge_"天"
	}
	else
	{
		q ""
	}
	
	q ClinicAge
}

/// Desc: Trakcare年龄 
/// Intput：$$CalAge^at182的返回值
/// Output：	age>1岁，返回：N岁
/// 			1月<age<1岁，返回：N月 
/// 			age<1月，返回：N天
/// Others：Belong to ClassMethod Age
ClassMethod GetTrakAge(tmpAge As %String) As %String
{
	//b "s"
	//入参检查
	q:($d(tmpAge)=0)||(tmpAge="") ""
	
	//定义变量
	s TrakAge="",TrakAgeUnit=""
	s tmpAgeYear="",tmpAgeMonth="",tmpAgeDay=""
	
	//获取年月日初始值
	s tmpAgeYear=$p(tmpAge,"|",12)
	s tmpAgeMonth=$p(tmpAge,"|",13)
	s tmpAgeDay=$p(tmpAge,"|",14)
	
	//年龄逻辑判断
	if (tmpAgeYear>0)
	{
		//Trak年龄(N岁)
		s TrakAge=tmpAgeYear ,TrakAgeUnit="岁"
		s TrakAge=TrakAge_TrakAgeUnit
	}
	elseif (tmpAgeYear=0)
	{
		if (tmpAgeMonth>0)
		{
			//Trak年龄(N月)
			s TrakAge=tmpAgeMonth ,TrakAgeUnit="月"
			s TrakAge=TrakAge_TrakAgeUnit
		}
		elseif (tmpAgeMonth=0)
		{
			if (tmpAgeDay>0)
			{
				//Trak年龄(N日)
				s TrakAge=tmpAgeDay ,TrakAgeUnit="天"
				s TrakAge=TrakAge_TrakAgeUnit
			} 
			elseif (tmpAgeDay=0)
			{
				//Trak年龄(N日)
				s TrakAge=1 ,TrakAgeUnit="天"
				s TrakAge=TrakAge_TrakAgeUnit
			}  
		}
	}
	else
	{
		q ""
	}
	
	q TrakAge
}

/// Desc:	性别，not different from hospitals
/// Output:	RowId^Code^Desc
/// Others:	被下列模块引用
ClassMethod Gender(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s genderDR="",gender="",gendercode=""

	q:($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11) ""
	s genderDR=$P($G(^PAPER(argPaperDR,"ALL")),"^",7)
	if genderDR'="" 
	{ 
		s gendercode=$P($g(^CT("SEX",genderDR)),"^",1)
		s gender=$P($g(^CT("SEX",genderDR)),"^",2)
		s gender=genderDR_"^"_gendercode_"^"_gender
	}

	q gender
}

/// Desc: 	护理单元，即护理病区
/// Output：RowId^Code^Desc
/// Others: 被下列模块引用
ClassMethod CareUnit(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue=""
	
	s wardDR=$P($g(^PAADM(argAdmId)),"^",70)
	if wardDR'="" 
	{
		s WardCode=$p($g(^PAWARD(wardDR)),"^",1)
		s WardDesc=$p($g(^PAWARD(wardDR)),"^",2)
		if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s retValue=wardDR_"^"_WardCode_"^"_WardDesc
	}
	
	q retValue
}

/// Desc: 	用于默认模板控制,取所有权限, 建议使用PrivAll代替
/// Return："PrivAll"
/// Others：被下列模块引用
ClassMethod InterfgetPrivAll()
{
	s PrivStatus="PrivAll"
	q PrivStatus
}

/// Desc:	当前科室(即出院科室)
/// Return：RowId^Code^Desc
/// Others：被下列模块引用
ClassMethod CurrentDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s CurrentDept=""
	
	s DeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	if DeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(DeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(DeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s CurrentDept=DeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	q CurrentDept
}

/// Desc: 临时科室
/// Return: RowId^Code^Desc
/// Others: 被下列模块引用
ClassMethod TempDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s dept=""
	
	s deptDR=$P($g(^PAADM(argAdmId)),"^",74)
	if deptDR'="" 
	{	
		s deptDesc=$p($g(^CTLOC(deptDR)),"^",2)
		s deptCode=$p($g(^CTLOC(deptDR)),"^",1)
		if $l(deptDesc,"-")>1 {s deptDesc=$p($g(deptDesc),"-",2)}
		s dept=deptDR_"^"_deptCode_"^"_deptDesc
	}

	q dept
}

/// Desc:	病人费用类型
/// Input:	argType {"D":Desc,"C":Code,"ALL":PayTypeDR_"^"_PayTypeCode_"^"_PayTypeDesc}
ClassMethod PayType(argAdmId As %String, argType As %String = "D") As %String
{
	//病人费用类型
	//SQL:PAC_AdmReason

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argType)=0)||(argType="") ""
	
	s (PayTypeCode,PayTypeDesc,PayTypeDR)=""
	
	s PayTypeDR=$p($g(^PAADM(argAdmId,1)),"^",7)
	q:(PayTypeDR="") ""
	
	if (argType ="C")
	{
		s PayType = $p($g(^PAC("ADMREA",PayTypeDR)),"^",1)
	}
	elseif (argType ="D")
	{
		s PayType=$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	}
	elseif (argType ="ALL")
	{
		s PayType = PayTypeDR_"^"_$p($g(^PAC("ADMREA",PayTypeDR)),"^",1)_"^"_$p($g(^PAC("ADMREA",PayTypeDR)),"^",2)
	}

	q PayType
}

/// Desc: 诊断信息，诊断的优先原则为：出院诊断>主要诊断>入院诊断
/// Input: argAdmId: 就诊rowid
/// Return: RowId^诊断代码^诊断描述
ClassMethod DiagnosInfo(argAdmId As %String) As %String
{
	q:(argAdmId="") ""
	
	s retDiagnos = ""
	s diagnosID = ""
	
	//出院诊断
	s disDiagTypeID = $O(^MRC("DTYP",0,"Code","DIS",""))  
	if (disDiagTypeID '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, disDiagTypeID)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//主要诊断
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	if (mainDiagTypeId '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, mainDiagTypeId)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//入院诊断
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))
	s tmpid = $O(^MRC("DTYP",0,"Code","C008",""))
	if (tmpid '= "")
	{
		if admDiagTypeId = ""
		{	s admDiagTypeId = tmpid}
		else
		{	s admDiagTypeId = admDiagTypeId_"^"_tmpid}
	}
	if (admDiagTypeId '= "")
	{
		s diagIDs = ..GetTypedDiagnosID(argAdmId, admDiagTypeId)
		if diagIDs '= ""
		{
			s diagnosID = $P(diagIDs, "^", 1)
			s retDiagnos = ..GetDiagnosWithNote(diagnosID)
		}
	}
	q:(retDiagnos '= "") retDiagnos
	
	//门诊诊断
	s opDiagTypeId =  $O(^MRC("DTYP",0,"Code","OP","")) 
	q:(opDiagTypeId = "") retDiagnos
	s diagIDs = ..GetTypedDiagnosID(argAdmId, opDiagTypeId)
	q:(diagIDs = "") retDiagnos
	
	s diagnosId = $P(diagIDs, "^", 1)
	s retDiagnos = ..GetDiagnosWithNote(diagnosId)
	q:(retDiagnos '= "") retDiagnos
	q retDiagnos
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetTypedDiagnosID(argEpisodeID As %String, argMRCDiagnosTypeID As %String) As %String
{
	q:(argMRCDiagnosTypeID = "") ""
	
	s ret = ""
	
	s mrAdmDR = $p($g(^PAADM(argEpisodeID)),"^",61)
	q:(mrAdmDR = "") ""
	
	s mrcDiagnosTypeIDString = "^"_argMRCDiagnosTypeID_"^"
	
	s mrDiaChildsub = "0"
	for {
		s mrDiaChildsub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub))
		q:(mrDiaChildsub="")
		
		s typeChildSub = 0
		for {
			s typeChildSub = $o(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub))
			q:(typeChildSub = "")
			
			s mrcDiagTypID = $p($g(^MR(mrAdmDR,"DIA",mrDiaChildsub,"TYP",typeChildSub)),"^",1)
			continue:(mrcDiagTypID = "")
			
			//判断是否为待选诊断类型
			continue:('$f(mrcDiagnosTypeIDString, "^"_mrcDiagTypID_"^"))
			
			s mrDiagnosID = mrAdmDR_"||"_mrDiaChildsub
			if ret = ""
			{	s ret = mrDiagnosID}
			else
			{	s ret = ret_"^"_mrDiagnosID}	
		}
	}
	q ret
}

/// 	Desc:	取诊断信息
/// 	Input:	argMRDiagnosID : MR_Adm.MRADM_RowId||MR_Diagnos.MRDIA_Childsub
/// 	Return：RowId^诊断代码^诊断描述(诊断备注)
ClassMethod GetDiagnosWithNote(argMRDiagnosID) As %String
{
	s mrAdmID = $P(argMRDiagnosID, "||", 1)
	s mrDiaChildSub = $P(argMRDiagnosID, "||", 2)
	q:(mrAdmID = "")||(mrDiaChildSub = "") ""
	s icdCode="",icdDesc = ""
	s icdid = $p($g(^MR(mrAdmID,"DIA",mrDiaChildSub)),"^",1)
	if (icdid '= "") 
	{
		s icdCode = $p($g(^MRC("ID",icdid)),"^",4)
		s icdDesc = $p($g(^MRC("ID",icdid)),"^",2)
	}
	s diagNote=$g(^MR(mrAdmID,"DIA",mrDiaChildSub,"DES",1))
	if (diagNote '= "") 
	{	s icdDesc = icdDesc_"("_diagNote_")"}	
	
	s diagPrefix=$p($g(^MR(mrAdmID,"DIA",mrDiaChildSub,1)),"^",26)
	if (diagPrefix '= "") 
	{	s icdDesc = diagPrefix_icdDesc}	
	
	
	q icdid_"^"_icdCode_"^"_icdDesc
}

/// Desc:	从系统参数中取医院名称
/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).HospitalName(50)
ClassMethod HospitalName(argAdm As %String = "")
{
	//s retValue = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName")
	//q retValue
	s HospitalID="",LocID=""
	s LocID=..CurrentDept(argAdm)
	if LocID="" quit HospitalID
	s HospitalID=$piece($get(^CTLOC($p(LocID,"^",1))),"^",22)
	s Hospital=$p($g(^CT("HOSP",HospitalID)),"^",2)   
	quit Hospital
}

/*/// Desc:	电子病历界面需要显示的病案号信息
ClassMethod IPRecordNoInfo(argAdmId As %String, argHospital As %String = "") As %String
{
	
	s recordNo = ""
	
	if (argHospital = ..#HospitalWHDYYY)
	{
		s recordNo = ##class(web.DHCWMRInterface.ReceiptSrv).GetMrNo(argAdmId,"","7")
	}
	
	if ($g(recordNo) = "") 
	{
		s papmiDR = ..GetPapmiDR(argAdmId)
		s recordNo = ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(argAdmId)
	}
    
    if (+recordNo<0)    //<+>2013-05-14 guozongtao 病案号接口返回值小于0时为异常信息，电子病历中，显示为“”
    {
		s recordNo=""
	}
	q recordNo
}*/
/// Desc:	住院病案号 
/// Table:	PA_PatMas.PAPMI_Medicare
ClassMethod IPRecordNoInfo(argAdmId As %String, argHospital As %String = "")
{
 	s recordNo = ""
	
	s recordNo = ..GetMRNoByEpisodeID(argAdmId)	

	q recordNo
}

/// Desc:	住院病案号 
/// Table:	PA_PatMas.PAPMI_Medicare
ClassMethod IPRecordNo(argPapmiDR As %String, argHospital As %String = "")
{
 
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	s recordNo = ""
	// 其它医院使用默认字段
	s recordNo = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByPatientID(argPapmiDR)	
	
	q recordNo
}

/// Desc：	取患者登记号，not different from hospitals
/// Table:	PA_PatMas.PAPMI_IPNo
/// Others：被下列模块引用
/// 		
ClassMethod GetPapmiNo(argPapmiDR As %String) As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	q $P($g(^PAPER(argPapmiDR,"PAT",1)),"^",1)
}

/// Desc:	姓名，not different from hospitals 
/// Others：被下列模块引用
/// 		[病案质控]
/// ModifyDate: 2009-08-06
/// ModifyDesc: 去掉姓名两端的空格	
ClassMethod Name(argPaperDR As %String) As %String
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s name=""
	
	q:($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11) ""
	s name=$P($G(^PAPER(argPaperDR,"ALL")),"^",1)
	
	//去掉姓名两端的空格，保证英文姓名正常显示。
	s name = $zstrip(name,"<>"," ")
		
	q name
}

/// Desc:	取 CT_LocLinkLocation 科室与病区的对应关系
/// 	  	用于[操作权限]，如一个大病区包括多个科室或治疗组，登录某治疗组，具有本大病区病历的操作权限
/// Return：^CurrentDeptDR^LinkLoc1DR^LinkLoc2DR^
/// Others：被下列模块引用
/// 		[操作权限]EMRservice.Privilege.BOPrivAssist
/// Debug:  w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).CurrentDeptLinkLoc(201871)
ClassMethod CurrentDeptLinkLoc(argAdmId As %String) As %String
{
	// Table: CT_LocLinkLocation
	// Global: ^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})

	q:($d(argAdmId)=0)||(argAdmId="") ""
	s CurrentDeptLinkLoc=""
	s CurrentDept="",CurrentDeptDR="",VarLocDR="",VarLocString=""
	
	s CurrentDept=..DisDept(argAdmId,..HospitalName())
	s CurrentDeptDR=$p($g(CurrentDept),"^",1)
	q:(CurrentDeptDR = "") ""
	f  s VarLocDR=$o(^CTLOC(CurrentDeptDR,"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
	. s VarLocString=VarLocString_"^"_VarLocDR
	
	i $l(VarLocString,"^")=2 
	{ 
		f  s VarLocDR=$o(^CTLOC($p(VarLocString,"^",2),"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
		. s VarLocString=VarLocString_"^"_VarLocDR
	}
	s CurrentDeptLinkLoc=CurrentDeptDR_VarLocString
	s CurrentDeptLinkLoc="^"_CurrentDeptLinkLoc_"^"
	
	q CurrentDeptLinkLoc
}

/// Desc:	通过患者所在科室的RowID,取 CT_LocLinkLocation 科室与病区的对应关系
/// Input:	
/// Output:	
/// Others:	Table CT_LocLinkLocation / Global ^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
/// Test:	d ##class(EMR.DOC.HISInterface.PatientInfoAssist).CurDeptLinkLocByDept(argDeptId)
ClassMethod CurDeptLinkLocByDept(argDeptId As %String) As %String
{
	//b "s"
	//入参检查
	q:($d(argDeptId)=0)||(argDeptId="") ""

	//定义变量
	s CurrentDeptLinkLoc=""
	s CurrentDept="",CurrentDeptDR="",VarLocDR="",VarLocString=""
	s CurrentDeptDR=argDeptId

	//程序处理
	f  s VarLocDR=$o(^CTLOC(CurrentDeptDR,"LINK",0,"Loc",VarLocDR)) q:VarLocDR=""  d
	. s VarLocString=VarLocString_"^"_VarLocDR

	s CurrentDeptLinkLoc="^"_CurrentDeptDR_VarLocString_"^"

	q CurrentDeptLinkLoc
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc: 	PA_Adm.PAADM_ADMNo
ClassMethod GetEpisodeNo(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	q $P($g(^PAADM(argAdmId)),"^",81)
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	门诊病案号 
/// Table:	PA_Person.PAPER_GovernCardNo
ClassMethod OPRecordNo(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s recordNo=""

	//积水潭医院病案号第一位可能是字母, 要去掉
	if argHospital=..#HospitalBJJSTYY 
	{
		s recordNo=$p($g(^PAPER(argPapmiDR,"PER",4)),"^",4)
		if ((recordNo?1L.N)||(recordNo?1U.N)) {s recordNo=$e(recordNo,2,$l(recordNo))}
		q recordNo
	}
	
	// 其它医院使用默认字段
	q:($d(^PAPER(argPaperDR,"PER",4))'=1) ""
	s recordNo=$P($g(^PAPER(argPaperDR,"PER",4)),"^",4)
	
	q recordNo
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	急诊病案号 
/// Table:	DHC_Person.PAPER_FCMedicareCode1
ClassMethod EPRecordNo(argPaperDR As %String, argHospital As %String = "")
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s recordNo=""
	
	s emedicareDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if emedicareDR'=""
	{
		q:($d(^DHCPERSON(emedicareDR))'=1) ""
		s recordNo=$p($g(^DHCPERSON(emedicareDR)),"^",5)
	}

	q recordNo
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	医保号
ClassMethod InsuranceNo(argAdmId As %String, argHospital As %String) As %String
{
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="")||(argHospital="") ""
	s insuranceNo="", argPapmiDR=""  
	
	if (argHospital=..#HospitalAHSLYY)||(argHospital=..#HospitalAHXNXGYY)||(argHospital=..#HospitalXAJDKQYY)
	{
		s insuranceNo=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(argAdmId)
		if ($p(insuranceNo,"!",1)'="1") {s insuranceNo=""}
		else {
		 s insuranceNo=$p(insuranceNo,"!",2)
		 s insuranceNo=$p(insuranceNo,"^",3)
		}
		q insuranceNo
	}
	if (argHospital=..#HospitalYBRMYY)||(argHospital=..#HospitalBJJSTYY)	
	{
		s insuranceNo=##class(web.INSUAdmInfoCtl).QueryAdmInfo(argAdmId)
		if ($p(insuranceNo,"^",11)="") {s insuranceNo=""}
		else {s insuranceNo=$p(insuranceNo,"^",11)}
		q insuranceNo
	}
	
	// 下列医院取默认字段：Pa_Person -> PAPER_Name
	// 北京地坛医院	 
	s argPapmiDR =..GetPapmiDR(argAdmId)
	//20180312 lifb 薛工提供新的接口
	//if argPapmiDR'=""{s insuranceNo=$P($G(^PAPER(argPapmiDR,"ALL")),"^",19)}
	//18.1.1 add 医保号新位置： $P($G(^PAPER(argPapmiDR,"PAT",3)),"^",12)
	if argPapmiDR'=""{s insuranceNo=$P($G(^PAPER(argPapmiDR,"PAT",3)),"^",12)}
	q insuranceNo
	
	
	q insuranceNo
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	身份证号
/// Table:	PA_Person.PAPER_ID
/// Others：not different from others
ClassMethod IDCard(argPaperDR As %String)
{
	q:($d(argPaperDR)=0)||(argPaperDR="") ""
	s idcard=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	s idcard=$P($G(^PAPER(argPaperDR,"ALL")),"^",9)
	
	q idcard
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Description:获取证件类型
/// Table:		[SQLUSER.PA_PatMas]PAPMI_CardType_DR -> [SQLUSER.PAC_CardType]CARD_Desc
ClassMethod CardType(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardTypeDR="",CARDDesc=""
	
	s CardTypeDR=$P($g(^PAPER(argPapmiDR,"ALL",3)),"^",7)
	if (CardTypeDR'="") 
	{
		s CARDDesc = $p($g(^PAC("CARD",CardTypeDR)),"^",2)
	}
	s CardType=CARDDesc
			
	q CardType
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Description:获取证件号码
/// Table:		[SQLUSER.PA_PatMas]PAPMI_DVAnumber
ClassMethod CardNumber(argPapmiDR As %String) As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	q:(($d(^PAPER(argPapmiDR,"ALL"))'=1)&&($d(^PAPER(argPapmiDR,"ALL"))'=11)) ""
	
	s CardNumber=""
	
	s CardNumber =$P($g(^PAPER(argPapmiDR,"ALL",3)),"^",6)
			
	q CardNumber
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	婚姻状态
/// Output:	RowId^Code^Desc
ClassMethod Marriage(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s maritalDR="",marital=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	if argHospital=..#HospitalBJJSTYY	//北京积水潭
	{	s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",1)}
	else
	{
		s maritalDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",3)
	}
	
	if maritalDR'=""  
	{
		s code = $p($g(^CT("MAR",maritalDR)),"^",1)
		s desc = $p($g(^CT("MAR",maritalDR)),"^",2)
		s marital=maritalDR_"^"_code_"^"_desc
	}
	
	q marital
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	籍贯
/// Output:	
/// Debug: ##Class(EMR.DOC.HISInterface.PatientInfoAssist).Native(105785)
ClassMethod Native(argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
	s Native=""
	
	//PAPER_Province_Birth_DR
	s ProvinceDR = $P($g(^PAPER(argPapmiDR,"PER",2)),"^",11)
	//add by wangli 2012-12-25
	i $g(ProvinceDR)="" s ProvinceDR = $P($g(^PAPER(argPapmiDR,"PER",4)),"^",2)
	//PAPER_CityBirth_DR
	s CityDR =$P($g(^PAPER(argPapmiDR,"ALL")),"^",18) 
	//add by wangli 2012-12-25
    i $G(CityDR)=""  s CityDR =$P($g(^PAPER(argPapmiDR,"PER",1)),"^",5) 
	
	if (ProvinceDR'="")&&(CityDR'="")
	{
		//省份信息
		s ProvinceCode=$P($g(^CT("PROV",ProvinceDR)),"^",1)
		s ProvinceDesc = $P($g(^CT("PROV",ProvinceDR)),"^",2)
		i $l(ProvinceDesc,"-")'=1 {s ProvinceDesc=$p($g(ProvinceDesc),"-",2)} 
		//城市信息
		s CityCode = $p($g(^CT("CIT",CityDR)),"^",1)
		s CityDesc = $p($g(^CT("CIT",CityDR)),"^",2)
		i ($l(CityDesc,"-")>1) {s CityDesc=$p($g(CityDesc),"-",2)}	
		//整理返回值
		s Native = ProvinceDR_"^"_ProvinceCode_"^"_ProvinceDesc
		s Native = Native_"!"_CityDR_"^"_CityCode_"^"_CityDesc
	}		
	
	q Native
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc：	2012新出生地-20120324 Add by Liaowp
/// Output：省!市!区!详细地址
/// 20120418 wangwentao update 20120711 WWT CHECKOK
ClassMethod BirthPlaceNew(argPapmiDR As %String, argHospital As %String = "BJXHYY") As %String
{
	q:($d(argPapmiDR)=0)||(argPapmiDR="") ""
	

	s birthPlace="",DHCPersonDR=0
	s DHCPersonDR = $o(^DHCPERSON(0,"PAPERSON",argPapmiDR,DHCPersonDR)) q:(DHCPersonDR="") ""
	 
	q:(($d(^DHCPERSON(DHCPersonDR))'=1)&&($d(^DHCPERSON(DHCPersonDR))'=11)) ""

	//新户口地址字段 存储不同 需特殊处理
	if ($ZCVT(argHospital,"U")=..#HospitalBJXHYY)
	{
		//医生站郭荣勇确认以协和为准 
		//新出生地字段
		s (provinceDR,cityBirthDR,blockBirthDR,detailAddressDR)=""
		//DHC_Person.PAPER_BirthProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",13)
		//DHC_Person.PAPER_BirthCityDR
		s cityBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",14)
		//DHC_Person.PAPER_BirthAreadr
		s blockBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",15)
		//DHC_Person.PAPER_BirthAddress
		s detailAddressDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",16)
	}
	else
	{
		//新出生地字段
		s (provinceDR,cityBirthDR,blockBirthDR,detailAddressDR)=""
		//DHC_Person.PAPER_BirthProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",14)
		//DHC_Person.PAPER_BirthCityDR
		s cityBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",15)
		//DHC_Person.PAPER_BirthAreadr
		s blockBirthDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",16)
		//DHC_Person.PAPER_BirthAddress
		s detailAddressDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",17)
	}
	
	s birthProvince="",birthCity="",birthBlock="",birthDetail=""
	
	if (provinceDR'="")
	{	
		s birthProvinceDesc = $p($g(^CT("PROV",provinceDR)),"^",2)
		i $l(birthProvinceDesc,"-")'=1 {s birthProvinceDesc=$p($g(birthProvinceDesc),"-",2)} 
		s birthProvinceCode = $p($g(^CT("PROV",provinceDR)),"^",1)
		s birthProvince = provinceDR_"^"_birthProvinceCode_"^"_birthProvinceDesc
	}
	if (cityBirthDR'="")
	{
		s birthCityDesc = $p($g(^CT("CIT",cityBirthDR)),"^",2)
		i $l(birthCityDesc,"-")'=1 {s birthCityDesc=$p($g(birthCityDesc),"-",2)} 
		s birthCityCode = $p($g(^CT("CIT",cityBirthDR)),"^",1)
		s birthCity = cityBirthDR_"^"_birthCityCode_"^"_birthCityDesc
	}	
	if (blockBirthDR'="")	
	{
		s birthBlockDesc = $p($g(^CT("CITAREA",blockBirthDR)),"^",2)
		i $l(birthBlockDesc,"-")'=1 {s birthBlockDesc=$p($g(birthBlockDesc),"-",2)} 
		s birthBlockCode = $p($g(^CT("CITAREA",blockBirthDR)),"^",1)
		s birthBlock = blockBirthDR_"^"_birthBlockCode_"^"_birthBlockDesc		
	}
	if (detailAddressDR'="")	
	{
		s birthDetail = detailAddressDR	
	}
	
	s birthPlace = birthProvince_"!"_birthCity_"!"_birthBlock_"!"_birthDetail
	
	s:(birthPlace="!!!") birthPlace=""
	
	q birthPlace
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	2012新现住址-20120324 Add by Liaowp
/// 20120711 WWT CHECKOK
ClassMethod ResidentAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s residentaddr=""
	s birthPlace="",curprovinceDR="",curcityDR="",curblockDR=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	
	//新现住址字段
	//PAPER_CT_Province_DR
	s curprovinceDR = $p($g(^PAPER(argPaperDR,"PER",4)),"^",2)
	//PAPER_CityCode_DR
	s curcityDR = $p($g(^PAPER(argPaperDR,"PER",1)),"^",5)
	//PAPER_CityArea_DR
	s curblockDR = $p($g(^PAPER(argPaperDR,"PER",4)),"^",9)
	
	s curCity="",curProvince="", curBlock=""
	
	if (curprovinceDR'="")
	{	
		s curProvinceDesc = $p($g(^CT("PROV",curprovinceDR)),"^",2)
		i $l(curProvinceDesc,"-")'=1 {s curProvinceDesc=$p($g(curProvinceDesc),"-",2)} 
		s curProvinceCode = $p($g(^CT("PROV",curprovinceDR)),"^",1)
		s curProvince = curprovinceDR_"^"_curProvinceCode_"^"_curProvinceDesc
	}
	if (curcityDR'="")
	{
		s curCityDesc = $p($g(^CT("CIT",curcityDR)),"^",2)
		i $l(curCityDesc,"-")'=1 {s curCityDesc=$p($g(curCityDesc),"-",2)} 
		s curCityCode = $p($g(^CT("CIT",curcityDR)),"^",1)
		s curCity = curcityDR_"^"_curCityCode_"^"_curCityDesc
	}	
	if (curblockDR'="")	
	{
		s curBlockDesc = $p($g(^CT("CITAREA",curblockDR)),"^",2)
		i $l(curBlockDesc,"-")'=1 {s curBlockDesc=$p($g(curBlockDesc),"-",2)} 
		s curBlockCode = $p($g(^CT("CITAREA",curblockDR)),"^",1)
		s curBlock = curblockDR_"^"_curBlockCode_"^"_curBlockDesc		
	}

	s residentaddr=$g(^PAPER(argPaperDR,"PER","ADD",1))
	s residentaddr = curProvince_"!"_curCity_"!"_curBlock_"!"_residentaddr
	
	q residentaddr
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	2012新户口地址-20120324 Add by Liaowp
/// Output：省!市!区!详细地址
/// 20120418 wangwentao update  20120711 WWT CHECKOK
ClassMethod HuKouAddressNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	
	s DHCPersonDR=0
	s DHCPersonDR = $o(^DHCPERSON(0,"PAPERSON",argPaperDR,DHCPersonDR)) q:(DHCPersonDR="") ""
	 
	q:(($d(^DHCPERSON(DHCPersonDR))'=1)&&($d(^DHCPERSON(DHCPersonDR))'=11)) ""
	
	s (provinceDR,cityHuKouDR,blockHukouDR,streetHukou)=""
	//新户口地址字段 存储不同 需特殊处理
	if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
	{
		//新户口地址字段
		//DHC_Person.PAPER_HouseProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",18)
		//DHC_Person.PAPER_HouseCityDR
		s cityHuKouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",19)
		//DHC_Person.PAPER_HouseAreaDR
		s blockHukouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",20)
		//DHC_Person.PAPER_HouseAddress
		s streetHukou = $p($g(^DHCPERSON(DHCPersonDR)),"^",21)
	}
	else
	{
		//医生站郭荣勇确认以协和为准
		//新户口地址字段
		//DHC_Person.PAPER_HouseProvinceDR
		s provinceDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",17)
		//DHC_Person.PAPER_HouseCityDR
		s cityHuKouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",18)
		//DHC_Person.PAPER_HouseAreaDR
		s blockHukouDR = $p($g(^DHCPERSON(DHCPersonDR)),"^",19)
		//DHC_Person.PAPER_HouseAddress
		s streetHukou = $p($g(^DHCPERSON(DHCPersonDR)),"^",20)
	}	
	
	if (streetHukou="")
	{
		//PA_Person.PAPER_StName
		//详细地址存了两个位置 故进行处理 
		s addressNum=$o(^PAPER(argPaperDR,"PER","ADD",""),-1)
		s streetHukou=$g(^PAPER(argPaperDR,"PER","ADD",addressNum))
	}
	
	s HuKouCity="",HuKouProvince="", HuKouBlock="",HuKouStreet="",HuKouaddr=""

	if (provinceDR'="")
	{	
		s HuKouProvinceDesc = $p($g(^CT("PROV",provinceDR)),"^",2)
		i $l(HuKouProvinceDesc,"-")'=1 {s HuKouProvinceDesc=$p($g(HuKouProvinceDesc),"-",2)} 
		s HuKouProvinceCode = $p($g(^CT("PROV",provinceDR)),"^",1)
		s HuKouProvince = provinceDR_"^"_HuKouProvinceCode_"^"_HuKouProvinceDesc
	}
	if (cityHuKouDR'="")
	{
		s HuKouCityDesc = $p($g(^CT("CIT",cityHuKouDR)),"^",2)
		i $l(HuKouCityDesc,"-")'=1 {s HuKouCityDesc=$p($g(HuKouCityDesc),"-",2)} 
		s HuKouCityCode = $p($g(^CT("CIT",cityHuKouDR)),"^",1)
		s HuKouCity = cityHuKouDR_"^"_HuKouCityCode_"^"_HuKouCityDesc
	}	
	if (blockHukouDR'="")	
	{
		s HuKouBlockDesc = $p($g(^CT("CITAREA",blockHukouDR)),"^",2)
		i $l( HuKouBlockDesc,"-")'=1 {s HuKouBlockDesc=$p($g( HuKouBlockDesc),"-",2)} 
		s HuKouBlockCode = $p($g(^CT("CITAREA",blockHukouDR)),"^",1)
		s HuKouBlock = blockHukouDR_"^"_HuKouBlockCode_"^"_HuKouBlockDesc		
	}
	s HuKoutaddr = HuKouProvince_"!"_HuKouCity_"!"_HuKouBlock_"!"_streetHukou
	s:(HuKoutaddr="!!!") HuKoutaddr =""
	q HuKoutaddr
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	职业
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Occupation(argPaperDR As %String, argHospital As %String = "", argCDType As %String = "", argCDCode As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s retValue = ""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	s occupationDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",6)
	i occupationDR'=""  
	{
		s occupationcode=$p($g(^CT("OCC",occupationDR)),"^",1)
		s occupationdesc=$p($g(^CT("OCC",occupationDR)),"^",2)
		i ($l(occupationdesc,"-")>1) {s occupationdesc=$p($g(occupationdesc),"-",2)}
		s retValue=occupationDR_"^"_occupationcode_"^"_occupationdesc
		
		//通过入参判断是否进行数据替换处理
		if (argCDType'="") 
		{
			s relation=..GetCustomDictionaryLinkByCode(argCDType,argCDCode)
			s relation=relationDR_"^"_relation
		}
	}	
	q retValue
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetCustomDictionaryLinkByCode("RelationGB/T4761","5")
ClassMethod GetCustomDictionaryLinkByCode(paraCtmDictType As %String, paraCtmDictCode As %String, argType As %String = "ALL") As %String
{

 s relationDR="",relationcode="",relationdesc=""
 
 k SQLCODE
 &sql(SELECT TOP 1 CtmDictLinkCode ,CtmDictLink into :relationcode,:relationdesc FROM EMRmeta.CustomDictionary WHERE CtmDictType = :paraCtmDictType AND CtmDictCode=:paraCtmDictCode)
 
	if (argType ="C")
	{
		s DictCode = relationcode
	}
	elseif (argType ="D")
	{
		s DictCode = relationdesc
	}
	elseif (argType ="ALL")
	{
		s DictCode = relationcode_"^"_relationdesc
	}

 	s:(SQLCODE'=0) DictCode=""
 
 QUIT DictCode
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	民族
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Nation(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s retValue=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	s nationDR=$P($G(^PAPER(argPaperDR,"PER",2)),"^",1)
	q:(nationDR="") ""
	s code=$p($g(^CT("NAT",nationDR)),"^",1)
	s desc=$p($g(^CT("NAT",nationDR)),"^",2)
	if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
	s retValue=nationDR_"^"_code_"^"_desc
	
	q retValue
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	国籍
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod Country(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s retValue = ""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""	
	s countryDR=$P($G(^PAPER(argPaperDR,"PER",1)),"^",8)
	if (countryDR '= "")
	{
		s code = $p($g(^CT("COU",countryDR)),"^",1)
		s desc=$p($g(^CT("COU",countryDR)),"^",2)
		if $l(desc,"-")>1 {s desc=$p($g(desc),"-",2)}
		s retValue=countryDR_"^"_code_"^"_desc	
	}
	q retValue
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	医疗付款方式SQL(病案首页)
ClassMethod PayModeLink(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s PayTypeCode=..PayType(argAdmId,"C"),PayModeLink=""
	
	s PayModeLink = ..GetCustomDictionaryLinkByCode("DHCEPRVPayModeLink",PayTypeCode,"D")
	
	q PayModeLink
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	移动电话
/// Table：	PA_Person.PAPER_MobPhone
/// Others：not different from hospitals
ClassMethod MobilePhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s mobilephone=""
	
	s mobilephone=$P($G(^PAPER(argPaperDR,"PER",4)),"^",21)
	///急诊留观患者查看基本信息，存在联系电话。扩充原有接口
	s:(mobilephone="") mobilephone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",11)
	
	q mobilephone
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	联系人姓名
/// Table：	PA_Person.PAPER_ForeignId
/// Others: not different from hospitals
ClassMethod LinkmanName(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s linkman=""
	
	q:(($d(^PAPER(argPaperDR,"PER",2))'=1)&&($d(^PAPER(argPaperDR,"PER",2))'=11)) ""
	s linkman=$P($G(^PAPER(argPaperDR,"PER",2)),"^",13)
	
	q linkman
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	联系人关系
/// Output：RowId^Code^Desc
/// Table：	PA_Person.PAPER_CTRLT_DR -> SQLUser.CT_Relation
/// Other:	argCDType = RelationGB/T4761
ClassMethod LinkmanRelation(argPaperDR As %String, argHospital As %String = "", argCDType As %String = "", argCDCode As %String = "") As %String
{
	q:($d(argPaperDR)=0)||($d(argHospital)=0)||(argPaperDR="")||(argHospital="") ""
	s relationDR="",relation="",relationcode="",relationdesc=""
	
	q:(($d(^PAPER(argPaperDR,"EMP"))'=1)&&($d(^PAPER(argPaperDR,"EMP"))'=11)) ""
	s relationDR=$P($G(^PAPER(argPaperDR,"EMP")),"^",4)
	if relationDR'=""
	{
		s relationcode=$p($g(^CT("RLT",relationDR)),"^",1)
	  	s relationdesc=$p($g(^CT("RLT",relationDR)),"^",2)
		s relation=relationDR_"^"_relationcode_"^"_relationdesc
		
		//通过入参判断是否进行数据替换处理
		if (argCDType'="") 
		{
			s relation=..GetCustomDictionaryLinkByCode(argCDType,argCDCode)
			s relation=relationDR_"^"_relation
		}
	}
	q relation
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	联系人地址
/// Table:	PA_Person.PAPER_ForeignAddress
/// Others:	not different from hospitals
ClassMethod LinkmanAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s address=""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
	s address=$P($G(^PAPER(argPaperDR,"PER",1)),"^",1)
	s address=..ChangeHenggangType(address)
	q address
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	联系人电话
/// Talbe:	PA_Person.PAPER_ForeignPhone
ClassMethod LinkmanPhone(argPaperDR As %String, argHospital As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s phone=""
	
	q:(($d(^PAPER(argPaperDR,"ALL"))'=1)&&($d(^PAPER(argPaperDR,"ALL"))'=11)) ""
	s phone=$P($G(^PAPER(argPaperDR,"ALL")),"^",4)	

	q phone
}

/// Creator:	Candyxu
/// CreatDate:	2014-3-12
/// Desc:	工作地址
ClassMethod WorkAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s workaddr=""
	
	q:(($d(^PAPER(argPaperDR,"PER",4))'=1)&&($d(^PAPER(argPaperDR,"PER",4))'=11)) ""
	s workaddr=$P($G(^PAPER(argPaperDR,"PER",4)),"^",18)
	s workaddr=..ChangeHenggangType(workaddr)
	q workaddr
}

/// Desc:	工作电话
/// Table:	默认字段是：PA_Person.PAPER_TelO
/// 		个别项目是：PA_Person.PAPER_TelH
ClassMethod WorkPhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:($d(argPaperDR)=0)||($d(argHospital)=0)||(argPaperDR="")||(argHospital="") ""
	s workphone=""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
	
	if (argHospital=..#HospitalBJDTYY)||(argHospital=..#HospitalYBRMYY)			
	{	
		//北京地坛医院,粤北人民医院
		s workphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",11)	//PA_Person.PAPER_TelH
	}	
	else
	{
		//北京积水潭
		s workphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",9)	//PA_Person.PAPER_TelO
	}	
	s workphone=..ChangeHenggangType(workphone)
	q workphone
}

/// Desc:	工作地址邮编
/// Table:	DHC_Person.PAPER_Comment2 	User.DHCPerson.cls 
ClassMethod WorkPostCode(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s workpostalcodeDR="",workpostalcode=""

	
	s workpostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if workpostalcodeDR'=""
	{
		s workpostalcode=$p($g(^DHCPERSON(workpostalcodeDR)),"^",7)
	}	
	
	if argHospital=..#HospitalYKYZLYY			//医科院肿瘤医院
	{
		//PA_Person.PAPER_Name6
		s workpostalcode=$p($g(^PAPER(argPaperDR,"ALL")),"^",22)
	}
	q workpostalcode
}

/// Desc:	户口地址
/// Table:	PA_Person.PAPER_StName
ClassMethod HuKouAddress(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukouaddress=""	
	
	//默认字段
	//地坛医院
	q:(($d(^PAPER(argPaperDR,"PER","ADD",1))'=1)&&($d(^PAPER(argPaperDR,"PER","ADD",1))'=11)) ""
	s hukouaddress=$G(^PAPER(argPaperDR,"PER","ADD",1))	
	q hukouaddress
}

/// Desc:	户口电话
/// Table:	默认字段是：PA_Person.PAPER_TelH
/// 		个别项目是：PA_Person.PAPER_TelO
ClassMethod HuKouPhone(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukouphone=""
	
	q:(($d(^PAPER(argPaperDR,"PER",1))'=1)&&($d(^PAPER(argPaperDR,"PER",1))'=11)) ""
	
	if argHospital=..#HospitalBJJSTYY			//北京积水潭
	{	s hukouphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",9)}	//PA_Person.PAPER_TelO
	else
	{	s hukouphone=$P($G(^PAPER(argPaperDR,"PER",1)),"^",11)}	//PA_Person.PAPER_TelH
	
	q hukouphone
}

/// Desc:	户口邮编
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment1 	User.DHCPerson.cls 
ClassMethod HuKouPostCode(argPaperDR As %String, argHospital As %String) As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s hukoupostalcodeDR="",hukoupostalcode=""

	s hukoupostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if hukoupostalcodeDR'=""
	{
		s hukoupostalcode=$p($g(^DHCPERSON(hukoupostalcodeDR)),"^",9)
	}	
	
	if argHospital=..#HospitalYKYZLYY			//医科院肿瘤医院
	{
		//PA_Person.PAPER_ForeignPostCode
		s hukoupostalcode=$p($g(^PAPER(argPaperDR,"PER",2)),"^",8)
	}	
	s hukoupostalcode=..ChangeHenggangType(hukoupostalcode)
	q hukoupostalcode
}

/// Desc:	现住址邮编
/// Output:	邮编
/// Table:	DHC_Person.PAPER_Comment2 	User.DHCPerson.cls 对应第8个节点[作废]
/// Table:	DHC_Person.PAPER_Comment1 	User.DHCPerson.cls 医生站郭荣勇确认以协和为准 
/// 20120418 wangwentao update  20120711 WWT CHECKOK
/// w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).ResidentPostCodeNew(1)
ClassMethod ResidentPostCodeNew(argPaperDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPaperDR)=0)||(argPaperDR="")) ""
	s residentpostalcodeDR="",residentpostalcode=""

	s residentpostalcodeDR=$o(^DHCPERSON(0,"PAPERSON",argPaperDR,""))
	if residentpostalcodeDR'=""
	{
		if ($ZCVT(argHospital,"U")=..#HospitalBJFCYY)
		{
			//DHC_Person.PAPER_Comment2
			s residentpostalcode=$p($g(^DHCPERSON(residentpostalcodeDR)),"^",8)
		}
		else
		{
			//DHC_Person.PAPER_Comment1
			s residentpostalcode=$p($g(^DHCPERSON(residentpostalcodeDR)),"^",8)
		}		
	}
	s residentpostalcode=..ChangeHenggangType(residentpostalcode)	
	q residentpostalcode
}

ClassMethod ChangeHenggangType(aReturnStr As %String = "") As %String
{
	q:(aReturnStr="") ""
	s ret="─"
	s ret=$tr(aReturnStr,"-","─")
	q ret
}

/// Desc: 	patient's doctor in charge，not different from hospitals
/// Return: SSUSR_Initials
/// Others：被下列模块引用
/// 		[操作权限]EMR.DOC.HISInterface.PatientInfoAssist
ClassMethod SSUsrInCharge(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s doc="",ssusrid=""
	s doc=$P($g(^PAADM(argAdmId)),"^",9)
	i doc'="" {
		s ssusrid=$o(^SSU("SSUSR",0,"CTPCP",doc,""))
	}
	q ssusrid
}

/// Desc:	主管医师 or 管床医生 (同入院医生)
/// Others:	not different from hospitals 
ClassMethod MainDoc(argAdmId As %String, aLangID As %String = "20") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s mainDoc=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s docDR = $P($G(^PAADM(argAdmId)),"^",9)
	q:(docDR="") ""
	s docCode=$p($g(^CTPCP(docDR,1)),"^",1)
	s docName=$p($g(^CTPCP(docDR,1)),"^",2)
	s docName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("User.SSUser","SSUSRName",docName,aLangID)
	s mainDoc=docDR_"^"_docCode_"^"_docName
	
	q mainDoc
}

/// Desc: 	出院日期时间(护士结算)
/// Output：date_","_time【Cache内部格式】
/// Others：not different from hospitals
ClassMethod DisDateTime(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""

	/*
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",17)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",18)
	q:((dischgdate="")||(dischgtime="")) ""
	*/
	
	//统一入院时间接口，增加住院患者判定规则。
	
	s AdmType=$p($g(^PAADM(argAdmId)),"^",2)
	q:(AdmType="") ""
	
	if (AdmType="I")
	{
		//统一出院时间接口
		s dischgdatetime=##class(web.DHCDischargeHistory).GetDischargeDateTime(argAdmId)
		s:(dischgdatetime'="^") dischgdatetime=$tr(dischgdatetime,"^",",")
		s:(dischgdatetime="^") dischgdatetime=""
	}
	else
	{
		s dischgdate=$P($G(^PAADM(argAdmId)),"^",17)
		s dischgtime=$P($G(^PAADM(argAdmId)),"^",18)
		q:((dischgdate="")||(dischgtime="")) ""
		s dischgdatetime = dischgdate_","_dischgtime
	}
		
	q dischgdatetime
}

/// 20140912 start
/// Desc:	入院医生 
/// Output:	RowId^医生代码^医生描述
/// Table:	PA_Adm.PAADM_AdmDocCodeDR
/// 		AdmDoctorDR is CT_CareProv RowID
ClassMethod AdmDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s admdoctorDR="",admdoctor="",admdoctorcode=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s AdmDoctorDR=$P($g(^PAADM(argAdmId)),"^",9)
	if AdmDoctorDR'=""
	{
		s admdoctorcode=$P($g(^CTPCP(AdmDoctorDR,1)),"^",1)
		s admdoctor=$P($g(^CTPCP(AdmDoctorDR,1)),"^",2)
		s admdoctor=AdmDoctorDR_"^"_admdoctorcode_"^"_admdoctor
	}
 
	q admdoctor
}

/// Desc:	主管护士 
/// Output:	RowId^护士代码^护士描述
/// Table:	DHC_PA_Adm.DHCADM_MainNurse_Dr
ClassMethod AdmNurse(argAdmId As %String, argHospital As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s DHCPaadmRowId=0,admNurseDR="",admNurse="",admNursecode=""
	;q:(($d(^DHCPAAdm(0,"PAAdm",argAdmId))'=1)&&($d(^DHCPAAdm(0,"PAAdm",argAdmId))'=11)) ""
	s DHCPaadmRowId=$o(^DHCPAAdm(0,"PAAdm",argAdmId,DHCPaadmRowId))
	q:((DHCPaadmRowId=0)||(DHCPaadmRowId="")) ""
	s admNurseDR=$P($g(^DHCPAAdm(DHCPaadmRowId)),"^",2)
	if admNurseDR'=""
	{
		s admNursecode=$P($g(^CTPCP(admNurseDR,1)),"^",1)
		s admNurse=$P($g(^CTPCP(admNurseDR,1)),"^",2)
		s admNurse=admNurseDR_"^"_admNursecode_"^"_admNurse
	}
 
	q admNurse
}

/// Desc:	带组医生 
/// Output:	RowId^医生代码^医生描述
/// Table:	PA_Adm.PAADM_AdmDocCodeDR
ClassMethod MasterDoctor(argAdmId As %String, argHospital As %String) As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s Masterdoctor=""
	
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s Loc="",Doctor="",PAAdmDocCodeDR=""
	Set Loc=$P($g(^PAADM(argAdmId)),"^",4)
	Set Doctor=$P($g(^PAADM(argAdmId)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=Doctor_"^"_$P($g(^CTPCP(Doctor,1)),"^",1)_"^"_$P($g(^CTPCP(Doctor,1)),"^",2)  //就诊医生
    Else  Set PAAdmDocCodeDR=""
	if ((Doctor'="")&&(Loc'="")) {s Masterdoctor=..GetHadeUniteDoc(Doctor,Loc)}
    if ((Doctor'="")&&(Loc="")) {s Masterdoctor=PAAdmDocCodeDR} //取到就诊医生所在组的组长
	
	/*if admdoctorDR'=""
	{
		s admdoctorcode=$P($g(^CTPCP(admdoctorDR,1)),"^",1)
		s admdoctor=$P($g(^CTPCP(admdoctorDR,1)),"^",2)
		s admdoctor=admdoctorDR_"^"_admdoctorcode_"^"_admdoctor
	}*/
 
	q Masterdoctor
}

/// creator:李相宗
/// date:2011-11-30
/// desc:得到病人就诊医生的所在组的组长
/// input:CTLOCRowId就诊科室ID	DoctorID就诊医生ID
/// outPut:DocMessage 就诊医生所在组的组长和DocID
/// debug:w ##class(web.DHCDocInPatientList).GetHadeUniteDoc("810","1595")
ClassMethod GetHadeUniteDoc(DoctorID As %String, CTLOCID As %String) As %Status
{
	
    s date=+$P($H,",",1)
 	s Str=""
	s SSUSRCareProvDR=DoctorID
    s CTMUChildsub=0  f  s CTMUChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub)) q:(CTMUChildsub="")||(Str'="")  d
    .s CTMUActiveFlag=$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",3)
    .q:CTMUActiveFlag'="Y"  //单元是激活状态
    .s DateFrom1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",4) //单元没有过期，有效状态
    .q:((date<DateFrom1)&&(DateFrom1'=0))
    .s DateTo1=+$P(^CTLOC(CTLOCID,"MU",CTMUChildsub),"^",5)
    .q:(date>DateTo1)&&(DateTo1'=0)
    .s IsExist=0,LeaderDoctorDR=""
 	.s MUCPChildsub=0 f  s MUCPChildsub=$O(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub)) q:(MUCPChildsub="")  d
 	..s MUCPDoctorDR=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",1) 
	..if (MUCPDoctorDR=SSUSRCareProvDR) s IsExist=1
	..s MUCPLeaderFlag=$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",2) //取组长标志
	..s DateFrom2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",5)
	..q:((date<DateFrom2)&&(DateFrom2'=0)) //单元中的用户没有超出有效期
	..s DateTo2=+$p(^CTLOC(CTLOCID,"MU",CTMUChildsub,"CP",MUCPChildsub),"^",6)
	..q:((date>DateTo2)&&(DateTo2'=0))
	..if (MUCPLeaderFlag="Y") s LeaderDoctorDR=MUCPDoctorDR
	.i (IsExist=1)&&(LeaderDoctorDR'="") s Str=CTLOCID_"||"_CTMUChildsub_"^"_LeaderDoctorDR //_"^"_MUCPDoctorDR_"^"_SSUSRCareProvDR
	if (Str="") s Docdesc=DoctorID_"^"_$P($g(^CTPCP(DoctorID,1)),"^",1)_"^"_$P($g(^CTPCP(DoctorID,1)),"^",2)
	else  s Docdesc=$P(Str,"^",2)_"^"_$P($g(^CTPCP($P(Str,"^",2),1)),"^",1)_"^"_$P($g(^CTPCP($P(Str,"^",2),1)),"^",2)
	q Docdesc
}

/// Desc:	取护理天数信息
/// Output：特级护理天数^一级护理天数^二级护理天数^三级护理天数^ICU护理天数^CCU护理天数
ClassMethod CareDays(argAdmId As %String, caredesc0 As %String = "", caredesc1 As %String = "", caredesc2 As %String = "", caredesc3 As %String = "", icudesc As %String = "", ccudesc As %String = "", argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	//默认值兼容
	s:((caredesc0="")&&(caredesc1="")&&(caredesc2="")&&(caredesc3="")&&(icudesc="")&&(ccudesc="")) caredesc0="特级护理",caredesc1="一级护理",caredesc2="二级护理",caredesc3="三级护理",icudesc="重症监护",ccudesc="CCU护理常规"
		
	s caredays=$$getCareDays^EPR(argAdmId,caredesc0,caredesc1,caredesc2,caredesc3,icudesc,ccudesc,argHospital)
	
	q caredays
}

/// Desc: 当前护理级别
/// Input: argItmMastDRStr 格式为 ^ItmMastDR1^ItmMastDR2^ItmMastDR3^...^
/// Example:     w ##Class(EPRservice.TestAndTools.EPRTest).CareClass(171380)
ClassMethod CareClass(argAdmId As %String, argItmMastDRStr As %String, argHospital As %String = "") As %String
{
	
	//&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
	//select * from ARC_ItemCat where arcic_ordcat_dr =''
	//OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
	//OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
	//[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItmMastDRStr)=0)||(argItmMastDRStr="") ""

	s CareClass=""
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""
	
    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(CareClass'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(CareClass'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. //Check OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast] 
	  .. q:($f(argItmMastDRStr,"^"_OEORIItmMastDR_"^")=0)
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s CareClass=ARCIMDesc
	  
	q CareClass
}

/// Desc: 根据医生的CTPCPRowID取其主任医师
/// Input: CTPCPRowID 
/// Example: w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetChiefDoc(180)
ClassMethod GetChiefDoc(CTPCPRowID As %String) As %String
{
	s ChiefUserID = ""
	s ChiefUserName = ""
	s AUserID = ""
	for 
	{
		s AUserID = $O(^SSU("SSUSR",0,"CTPCP",CTPCPRowID,AUserID))
		q:(AUserID = "")
		
		s PowerUserID = ""
		&sql(select ParRef into:PowerUserID from EMRmeta.ChildUsers where UserID = :AUserID)
		if (PowerUserID '= "")
		{
			s PowerUserObj = ##Class(EMRmeta.PowerUser).%OpenId(PowerUserID)
			continue:(PowerUserObj = "")
			s UserLevel = PowerUserObj.UserLevel
			if (UserLevel = "Chief")
			{
				s ChiefUserID = PowerUserObj.UserID
				s UserObj = ##class(User.SSUser).%OpenId(ChiefUserID)
				continue:(UserObj = "")
				s ChiefUserName = UserObj.SSUSRName
				do UserObj.%Close()
				s UserObj = ""
			}
			do PowerUserObj.%Close()
			s PowerUserObj = ""
		}
		
	}
	q ChiefUserID_"^"_ChiefUserName
}

/// Desc:	根据身份证号获取PatientID
/// Debug: w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetPapmiDRByIDCard("")	
ClassMethod GetPapmiDRByIDCard(argIDCard As %String) As %String
{
	q:(($d(argIDCard)=0)||(argIDCard="")) ""
	s ReturnValue="",PAPMI=""
	s PAPMI=$O(^PAPERi("DVA",argIDCard,""))
	if (PAPMI = "")
	{
		s PAPMI=$O(^PAPERi("PAPMI_ICPPBC",argIDCard_"Z",""))
	}
	if (PAPMI'="")
	{
		s ReturnValue=PAPMI
	}
	q ReturnValue
}

/// Desc:	根据医保号获取PapmiDR  add by niucaicai
ClassMethod GetPapmiDRByInsuranceNo(AMedicalInsuranceNo As %String, AHospitalName As %String) As %String
{
	q:(AMedicalInsuranceNo="")||(AHospitalName="") ""
	s PapmiDRStr=""
	if (AHospitalName = "ZGYDYFY")
	{
		//可能一个医保号对应多个PapmiDR,以^分割
		s PapmiDRStr = ##class(web.DHCINSUPatInfo).GetPapmiNoByInsuID(AMedicalInsuranceNo)
		//s PapmiDRStr = "1"
	}
	q PapmiDRStr
}

/// Creator:	wangwentao
/// CreatDate:	20120614
/// Description:获取诊断通过诊断类型
/// Table:		/
/// Input:		argAdmId: 就诊rowid
/// 				ADiagType DIS:出院诊断 M:门诊诊断 PRE:入院诊断 C008:初步诊断 Died:死亡诊断
/// 				ADiagNote:是否显示诊断备注
/// 				ADiagEPRNew:取新诊断的顺序和等级 "N|Y":不取等级只取顺序 "Y|Y":又取等级又取顺序 "N|N":不取等级不取顺序		
/// Output:		RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Others:		/	
/// Example:	
/// 				DHC-APP>w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","N","N|N")
/// 				5^A02.003^阿哥拉沙门氏菌肠炎!17^A06.401^阿米巴性肝脓肿
/// 				DHC-APP>w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","Y","N|N")
/// 				5^A02.003^阿哥拉沙门氏菌肠炎(1111111)!17^A06.401^阿米巴性肝脓肿(2222222)!19^A06.901^阿米巴病(3333333)
/// 				DHC-APP>w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","Y","N|Y")
/// 				522^C71.901^鞍上区恶性肿瘤(5555555)!212^B24.001^艾滋病(4444444)!19^A06.901^阿米巴病(3333333)
/// 				DHC-APP>w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetDiagnosByType(2,"DIS","Y","Y|Y")
/// 				2||522^C71.901^鞍上区恶性肿瘤(5555555)!1||212^B24.001^艾滋病(4444444)!3||19^A06.901^阿米巴病(3333333)
ClassMethod GetDiagnosByType(argAdmId As %String, ADiagType As %String = "", ADiagNote As %String = "Y", ADiagEPRNew As %String = "N|Y") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(ADiagType)=0)||(ADiagType="") ""
	
	//诊断类型
	q:(ADiagType'="DIS")&&(ADiagType'="M")&&(ADiagType'="PRE")&&(ADiagType'="C008")&&(ADiagType'="Died") ""
	
	s retValue = ""
	
	//取表 MRC_DiagnosType 中诊断类型对应的RowId 		
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code",ADiagType,""))  
	q:(admDiagTypeId = "") ""
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	//初始化Global
	k:($p(ADiagEPRNew,"|",2)="Y") ^CacheTempDHCEPRDebug("EMR.DOC.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId)
	
	//诊断处理
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为诊断类型
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//判断诊断备注
				if (ADiagNote="Y")
				{
					s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
					if (diagNote '= "") 
					{	
						s mricdDesc = mricdDesc_"("_diagNote_")"
					}
				}
				
				//判断新诊断层级和顺序
				if ($p(ADiagEPRNew,"|",2)="Y")
				{
					s diagEPRNew=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR"))
					q:(diagEPRNew = "")

					s diagLevel = $p(diagEPRNew,"^",1)
					s diagNum = $p(diagEPRNew,"^",2)

					s retValueNew = mricdid_"^"_mricdCode_"^"_mricdDesc
					
					if ($p(ADiagEPRNew,"|",1)="Y")
					{ 
						s ^CacheTempDHCEPRDebug("EMR.DOC.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId,diagNum)=diagLevel_"||"_retValueNew
					}
					else
					{
						s ^CacheTempDHCEPRDebug("EMR.DOC.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId,diagNum)=retValueNew
					}	
				}
				else
				{
					if (retValue = "")
					{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
					else
					{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
				}
			}
		}
	}
	
	//处理新诊断层级和顺序数据
	if ($p(ADiagEPRNew,"|",2)="Y")
	{
		s diagNum = 0 ,tmpDiagValue="",DiagValue =""
		for {
			s diagNum=$o(^CacheTempDHCEPRDebug("EMR.DOC.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId,diagNum))
			q:(diagNum="")
			
			s tmpDiagValue=^(diagNum)
			
			if (DiagValue="")
			{
				 s DiagValue = tmpDiagValue
			}
			else
			{
				s DiagValue = DiagValue_"!"_tmpDiagValue
			}
		}
		s retValue = DiagValue
		
		k ^CacheTempDHCEPRDebug("EMR.DOC.HISInterface.PatientInfoAssist","GetDiagnosByType",argAdmId)	
	}

	
	q retValue
}

/// Desc:   按诊断顺序输入出诊断内容
/// Input:  MRADMID 就诊ID
///         ICDType 区分中西医，不填取全部
///         DiagnosTypeCode 诊断类型，不填取全部
/// OutPut: Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MainMRDiagnoeRowId
///         多个以$(1)分割
/// Debug:  w ##Class(EMR.DOC.HISInterface.PatientInfoAssist)GetMRDiagnoseList(76)
ClassMethod GetMRDiagnoseList(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %String
{
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" {
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",$ZCVT(DiagnosTypeCode,"U"),0))
	}
	s Sub=0
	for  s Sub=$o(^MR(MRADMID,"DIA",Sub)) q:Sub=""  d
	.s Str=^(Sub)
	.s Rowid=MRADMID_"||"_Sub
	.s CodeRowid=$P(Str,"^",1)
	.s MRDiagnosDate=$P(Str,"^",7)
	.s MRdiagnosTime=$P(Str,"^",8)
	.s MRCIDCode="",Desc="",MRDesc=""
	.if (CodeRowid'="") d
	..s MRCIDCode=$P(^MRC("ID",CodeRowid),"^",4)
	..s Desc=$P(^MRC("ID",CodeRowid),"^",2)
	.s MRDescDr=$O(^MR(MRADMID,"DIA",Sub,"DES",""),-1)
	.if (+MRDescDr'=0) d
	..s MRDesc=$g(^MR(MRADMID,"DIA",Sub,"DES",MRDescDr))
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I +MRdiagnosNoteSubRowid'=0 Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.I MRDiagnosDate'="" Set MRDiagnosDate=$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=$zt(MRdiagnosTime,2)
	.s BillFlag1="" 
	.s BillFlag3=""
	.s DiagnosCat=""
	.i CodeRowid'="" d
	..s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
	..s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	..
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
	.Q:(ICDType="1")&&(DiagnosCat="西医")
	.Q:(ICDType="2")&&(DiagnosCat'="西医")
	.//Q:(ICDType'="1")&&(BillFlag3="Y")
	.
	.;s ^tan("MRDesc",$P(Rowid,"||",2))=MRDesc_"^"_$LISTVALID(MRDesc)
	.if ($LISTVALID(MRDesc)'=0)&&(MRDesc'="") s MRDesc=$LIST(MRDesc,1)
	.;s ^tan("MRDesc",$P(Rowid,"||",2),1)=""
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s MainMRDiagnoeRowId=$P($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",15)
	.s:MainMRDiagnoeRowId'="" DiagnosNumber=$P($G(^MR($P(MainMRDiagnoeRowId,"||",1),"DIA",$P(MainMRDiagnoeRowId,"||",2),"EPR")),"^",2)
	.
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=$zd(DIAOnsetDate,3) //取发病日期
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
    .;If RetStr'="" Set RetStr=RetStr_$c(1)_Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate
	.;if RetStr="" Set RetStr=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate
	.if DiagnosNumber="" s DiagnosNumber=$g(^MR(+Rowid,"DIA",0))+1
	.
	.
	.I MRDiagnosTypeDr'="" Set DiagnosTypeNum=$G(^MRC("DTYP",MRDiagnosTypeDr,"DHC"))
	.s:+$G(DiagnosTypeNum)=0 DiagnosTypeNum=99999	
	.s TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,Rowid)=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MainMRDiagnoeRowId
	
	//按顺序输出设置
	s TempDia=""
	s DiagnosTypeNum=""
	for {
		s DiagnosTypeNum=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum))
		q:DiagnosTypeNum=""
		s DiagnosNumber=""
		f  {
			s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber)) 
			Q:DiagnosNumber=""  d
			s Temprowid="" f {
				s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,Temprowid))
				q:Temprowid=""
				i RetStr="" s RetStr=TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,Temprowid)
				e  s RetStr=RetStr_$c(1)_TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,Temprowid)
			}
		}
	}
	k TempArr("FindDiagnos",$j)
	q RetStr
}

/// Desc: 当前膳食级别
/// Input: argItemCatDRStr 格式为 ^ItemCatDR1^ItemCatDR2^ItemCatDR3^...^
ClassMethod HadFoodTreatment(argAdmId As %String, argItemCatDRStr As %String, argHospital As %String = "") As %String
{
	//&sql(select top 1 * from OE_OrdItem where oeori_oeord_parref ='50594' and OEORI_ItmMast_DR -> arcim_itemcat_dr = '217' and OEORI_ItemStat_DR <>'4' )
	//select * from ARC_ItemCat where arcic_ordcat_dr =''
	//OE_OrdItem	^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub}) 
	//OE_Order		^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
	//[ARC_ItmMast]OEORIItmMastDR->[ARC_ItemCat]ARCIM_ItemCat_DR				
	//[ARCIM_ItemCat_DR	1	10]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[ARCIM_Desc	1	2]^ARCIM({ARCIM_Subscript},{ARCIM_Version}) 
	//[OEORI_ItemStat_DR	1	13]^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})  
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argItemCatDRStr)=0)||(argItemCatDRStr="") ""

	s FoodTreatment=""
	s OEORDRowId="",OEORIChdsub="",OEORIItmMastDR="",OEORIItmMastDRsub="",ARCIMItemCatDR="",OEORIItemStatDR="",ARCIMDesc=""

    f  s OEORDRowId=$o(^OEORD(0,"Adm",argAdmId,OEORDRowId)) q:((OEORDRowId="")||(FoodTreatment'=""))  d
    . //Get Max OEORIChdsub Add 1
    . s OEORIChdsub=$g(^OEORD(OEORDRowId,"I",0))+1
	. f  s OEORIChdsub=$o(^OEORD(OEORDRowId,"I",OEORIChdsub),-1) q:((OEORIChdsub="")||(FoodTreatment'=""))  d  
	  .. //Get OE_OrdItem.OEORI_ItemStat_DR[OEC_OrderStatus]
	  .. s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",13)
	  .. q:(OEORIItemStatDR=4)
	  .. //Get OE_OrdItem.OEORI_ItmMast_DR[ARC_ItmMast]
	  .. s OEORIItmMastDR= $p($g(^OEORD(OEORDRowId,"I",OEORIChdsub,1)),"^",2)
	  .. q:(OEORIItmMastDR="")
	  .. s OEORIItmMastDRsub=$p(OEORIItmMastDR,"||",1)
	  .. //Get OE_OrdItem.ARCIM_ItemCat_DR[ARC_ItemCat]
	  .. s ARCIMItemCatDR=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",10)
	  .. q:($f(argItemCatDRStr,"^"_ARCIMItemCatDR_"^")=0)
	  .. s ARCIMDesc=$p($g(^ARCIM(OEORIItmMastDRsub,1,1)),"^",2)
	  .. s FoodTreatment=ARCIMDesc
	  
	q FoodTreatment
}

/// Creator：Liaowp 
/// CreateDate: 2009-11-04
/// Desc: 获取病人过敏记录，For Get Allergy info from doctor status
/// Input: PatientID 病人登记rowid  flag 处理 "注射用头孢美唑钠|[1.0g/瓶]"
/// Output：过敏描述1,过敏描述2
/// Debug:w ##class(EMR.DOC.HISInterface.PatientInfoAssist).EPRGetAllergy(274902)
ClassMethod EPRGetAllergy(PatientID As %String, flag As %String = "")
{
	s ret="",AllergyStr=""
	
	;病人过敏记录 PA_Allergy
	s chl=0 f  s chl=$O(^PAPER(PatientID,"ALG",chl)) q:chl=""  d
	.s s=$G(^PAPER(PatientID,"ALG",chl))
	.s ALGStatus=$P(s,"^",8)
	.Q:ALGStatus="I"
	.s ALGTypeDR=$P(s,"^",9) ;自定义 PAC_Allergy
	.s ALGPHCGEDR=$P(s,"^",4) ;通用名 PHC_Generic
	.s ALGPHCDMDR=$P(s,"^",27) ;药学项 PHC_DrgMast
	.s ALGSeverityDR=$P(s,"^",21) ;过敏程度 PAC_AllergySeverity
	.i ALGSeverityDR'="" s ALGSeverityCode=$P($g(^PAC("ALRGSEV",ALGSeverityDR)),"^",1)
	.;
	.i (ALGTypeDR'="") d
	..s ALGDesc=$P(^PAC("ALG",ALGTypeDR),"^",2)
	..i ($L(ALGDesc,"-")>1) d
	...s ALGDesc=$p(ALGDesc,"-",2)
	..i (AllergyStr="") d
	...s AllergyStr=ALGDesc
	..e  d
	...s AllergyStr=AllergyStr_","_ALGDesc
	
	.;
	.i (ALGPHCGEDR'="") d
	..s ALGPHCGEDesc=$P(^PHCGE("GE",ALGPHCGEDR),"^",2)
	..i ($L(ALGPHCGEDesc,"-")>1) d
	...s ALGPHCGEDesc=$p(ALGPHCGEDesc,"-",2)
	..i (AllergyStr="") d
	...s AllergyStr=ALGPHCGEDesc
	..e  d
	...s AllergyStr=AllergyStr_","_ALGPHCGEDesc
	
	.;
	.i (ALGPHCDMDR'="") d
	..s ALGPHCDMDesc=$P(^PHCD(ALGPHCDMDR,1),"^",2)
	..i ($L(ALGPHCDMDesc,"-")>1) d
	...s ALGPHCDMDesc=$p(ALGPHCDMDesc,"-",2)
	...s:(flag="Y") ALGPHCDMDesc =$p(ALGPHCDMDesc,"|",1)
	..i (AllergyStr="") d
	...s:(flag="Y") ALGPHCDMDesc =$p(ALGPHCDMDesc,"|",1)
	...s AllergyStr=ALGPHCDMDesc
	..e  d
	...s:(flag="Y") ALGPHCDMDesc =$p(ALGPHCDMDesc,"|",1)
	...s AllergyStr=AllergyStr_","_ALGPHCDMDesc

	Q AllergyStr
}

/// Desc: 按医嘱优先级取医嘱明细
/// Input: argAdmId:就诊rowid
/// argPriorityDesc:医嘱优先级描述(即刻医嘱，临时医嘱，长期医嘱，出院带药，自备药即刻，自备药长期),空值表示取所有
/// argStDate:起始日期，Cache内部格式，若为空表示取所有
/// argEndDate：结束日期，Cache内部格式，若为空表示取所有
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetOrdersByPriority("56","临时医嘱")
ClassMethod GetOrdersByPriority(argAdmId As %String, argPriorityDesc As %String, argStDate As %String = "", argEndDate As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retVal = ""
	
	//医嘱名称，包装总量，包装单位，用法，单次计量，单次计量单位，频次,医嘱备注,医嘱状态
	s (OrderName,PackQty,PackUOM,Useage,DoseQty,DoseUOM,Frequcy,OrderDepProcNote,StatDR) = ""
	
	//转换医嘱优先级描述
	s priorityId = "ALL"
	if (argPriorityDesc '= "")
	{
	//s priorityId = ^OECPR(0,"Desc",argPriorityDesc,"")
	s tmpid=""
	&sql(select OECPR_RowId into :tmpid from SQLUser.OEC_Priority
	where OECPR_Desc = :argPriorityDesc)
	if (tmpid '= "") s priorityId = tmpid
	}
	
	q:(priorityId="")
	
	//取医嘱表[OE_Order]的rowid
	s oeordId = $O(^OEORD(0,"Adm",argAdmId,""))
	q:(oeordId="") ""
	
	//遍历医嘱项表[OE_OrdItem]
	s oeoriSub = 0
	for {
		s oeoriSub = $O(^OEORD(oeordId,"I",oeoriSub))
		q:(oeoriSub="")
	
		//医嘱日期是否满足条件[OE_OrdItem.OEORI_Date]
		s oeoriDate = $P($G(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
		if ((argStDate'="")&&(argEndDate'="")&&((oeoriDate<argStDate)||(oeoriDate>argEndDate)))
		{ continue}
	
		//医嘱优先级类别是否满足条件
		if (priorityId '= "ALL")
		{
		s oeoriPriorityDR = $P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
		if (priorityId '= oeoriPriorityDR) continue
		}
	
		//医嘱是否执行 
		/*
		s itemStatDR = $P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)
		if (itemStatDR = "") continue
		s statCode = $P($G(^OEC("OSTAT",itemStatDR)),"^",1)
		if (statCode '= "V")&&(statCode '= "E") continue 
		*/
		//取医嘱明细
		//PHCFR_Desc1 英文频次
		//PHCFR_Desc2 中文频次
		s oeoriRowid = oeordId_"||"_oeoriSub, OrderName=""
		&sql(SELECT OEORI_ItmMast_DR->ARCIM_Desc,OEORI_QtyPackUOM,
		OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc,OEORI_Instr_DR->PHCIN_Desc2,
		OEORI_DoseQty,OEORI_Unit_DR->CTUOM_Desc,
		OEORI_PHFreq_DR->PHCFR_Desc2,
		OEORI_ItemStat_DR
		INTO :OrderName,:PackQty,:PackUOM,:Useage,:DoseQty,:DoseUOM,:Frequcy,:StatDR
		From SQLUser.OE_OrdItem
		WHERE OEORI_Rowid = :oeoriRowid)
		//过滤撤销状态的出院带药医嘱  20141209
		continue:(StatDR=2)
		//格式如下：
		//[医嘱名称] X [总量][总理单位] / [用法] [单次计量] [单次计量单位] [频次]
		//氯化钠注射液 ([0.9%100ml]) X 15瓶 / 静脉滴注 每次100ml Q8h
		s OrderDepProcNote=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))
		if ($g(OrderDepProcNote)'="")
		{
			s tmpValue = OrderName_" X "_PackQty_PackUOM_" / "_Useage_" "_DoseQty_" "_DoseUOM_" "_Frequcy_" ("_OrderDepProcNote_")"
		}
		else
		{
			s tmpValue = OrderName_" X "_PackQty_PackUOM_" / "_Useage_" "_DoseQty_" "_DoseUOM_" "_Frequcy
		}
		if retVal=""
		{ s retVal = tmpValue}
		else
		{ s retVal = retVal_$c(13)_tmpValue}
	
	}
	
	q retVal
	
	/* 医生工作站相关的方法报错
	//取所有医嘱明细
	//web.DHCOEOrdItem:GetOrderItems 的返回值如下：
	//"Rowid:%String,OrderName:%String,StartDate:%String,Priority:%String,Status:%String,PackQty:%
	
	String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%
	
	String,OrderType:%String,Spec:%String,UserAddName:%String,LabEpisodeNo:%String,orcat:%
	
	String,orcatdesc:%String,RecDepAdress,DepProcNotes:%String,StatusCode:%String,ExecuteTime:%String")
	s rs = ##class(%ResultSet).%New("web.DHCOEOrdItem:GetOrderItems")
	s sc = rs.Execute(argAdmId,"0")
	q:(sc'=1) ""
	
	//遍历所有医嘱，取满足医嘱优先级条件的医嘱
	while (rs.Next())
	{
	//是否满足医嘱优先级要求
	s priority = rs.Data("Priority")
	if (priority '= argPriorityDesc) continue
	
	//是否满足时间要求
	if (argStDate '= "")&&(argEndDate '= "")
	{
	s sttDate = rs.Data("StartDate")
	if (sttDate = "") continue
	if ($zdh(sttDate,3) < argStDate) continue
	if ($zdh(sttDate,3) > argEndDate) continue
	}
	
	s orderName = rs.Data("OrderName")
	if retVal=""
	{ s retVal = orderName}
	else
	{ s retVal = retVal_$c(13,10)_orderName}
	}
	
	q retVal
	*/
}

/// Creator: Liaowp BJXHYY
/// Desc: 引用 web.DHCBldReqLabInfo
/// Output: BG_"^"_Rh_"^"_RBC_"^"_HCT_"^"_HGB_"^"_PLT_"^"_ALT_"^"_HBsAg_"^"_AntiHBs_"^"_HBeAg_"^"_AntiHBe_"^"_AntiHBc_"^"_AntiHCV_"^"_AntiHIV_"^"_MD
/// Test: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetLabBldInfoNew(50035)
ClassMethod GetLabBldInfoNew(admId As %String, LabItemID As %String = "") As %String
{

	s papmiId=+^PAADM(admId)
	
	
	  
	  s BG="",Rh="",PLT="",ALT="",HBsAg="",AntiHBs="",HBeAg="",AntiHBe="",AntiHBc="",AntiHCV="",AntiHIV="",MD=""
	  s RBC="",HCT="",HGB="",PLT=""
	  
	  
	  s retStr="^^^^^^^^^^^^^^^^^^"
	  s strQueryName = "DHCLIS.DHCBDAgreeFormInterface||QryBTResultByAdmNoSCode"
	  s strQueryRes =##Class(EMR.DOC.COM.ClassDefine).CheckQueryExist(strQueryName)
	  q:(strQueryRes="0") retStr
	  s LabItemSDCode = "ABO^RH^RBC^HCT^HGB^PLT^ALT^HBSAG^HBSAB^HBEAG^HBEAB^HBCAB^HCVAB^HIVAB^TPAB^HGB^PT^APTT^FIB"
	  for i=1:1:$l(LabItemSDCode,"^")
	  {
		  
		s tmpSDCode = $p(LabItemSDCode,"^",i)
		
		s tmpValue = ""
		s ds = ##Class(%ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryBTResultByAdmNoSCode")
		d ds.Execute(admId,tmpSDCode,"","","","","","","","","","","","","")
		
		
		while(ds.%Next()'=0)
		{
			s tmpValue = ds.Data("Result")
			s $p(retStr,"^",i) = tmpValue	
		} 
			  
	  }
	  
	  q retStr
}

/// Desc:	新病案费用信息：按照费用大类 一般24项
/// Output：
/// Others：
ClassMethod InPatCostTrakCareNew(argAdmId As %String, argHospital As %String = "") As %String
{
	s retValue = ""
	q:(($d(argAdmId)=0)||(argAdmId="")) retValue
	
	s feeDataContent = "Total^总费用^0.00!"
	s feeDataContent = feeDataContent_"一般医疗服务费^一般医疗服务费^0.00!"
	s feeDataContent = feeDataContent_"一般治疗操作费^一般治疗操作费^0.00!"
	s feeDataContent = feeDataContent_"护理费^护理费^0.00!"
	s feeDataContent = feeDataContent_"其他费^其他费^0.00!"
	s feeDataContent = feeDataContent_"病理诊断费^病理诊断费^0.00!"
	s feeDataContent = feeDataContent_"实验室诊断费^实验室诊断费^0.00!"
	s feeDataContent = feeDataContent_"影像学诊断费^影像学诊断费^0.00!"
	s feeDataContent = feeDataContent_"临床诊断项目费^临床诊断项目费^0.00!"
	s feeDataContent = feeDataContent_"非手术治疗项目费^非手术治疗项目费^0.00!"
	s feeDataContent = feeDataContent_"手术治疗费^手术治疗费^0.00!"
	s feeDataContent = feeDataContent_"康复费^康复费^0.00!"
	s feeDataContent = feeDataContent_"中医治疗费^中医治疗费^0.00!"
	s feeDataContent = feeDataContent_"西药费^西药费^0.00!"
	s feeDataContent = feeDataContent_"中成药费^中成药费^0.00!"
	s feeDataContent = feeDataContent_"中草药费^中草药费^0.00!"
	s feeDataContent = feeDataContent_"血费^血费^0.00!"
	s feeDataContent = feeDataContent_"白蛋白类制品费^白蛋白类制品费^0.00!"
	s feeDataContent = feeDataContent_"球蛋白类制品费^球蛋白类制品费^0.00!"
	s feeDataContent = feeDataContent_"凝血因子类制品费^凝血因子类制品费^0.00!"
	s feeDataContent = feeDataContent_"细胞因子类制品费^细胞因子类制品费^0.00!"
	s feeDataContent = feeDataContent_"检查用一次性医用材料费^检查用一次性医用材料费^0.00!"
	s feeDataContent = feeDataContent_"治疗用一次性医用材料费^治疗用一次性医用材料费^0.00!"
	s feeDataContent = feeDataContent_"手术用一次性医用材料费^手术用一次性医用材料费^0.00!"
	s feeDataContent = feeDataContent_"其他费用^其他费用^0.00"
	
	s MCFeeData = ##CLASS(web.DHCBillInterface).IGetTarItemCate(argAdmId,"","TMCNew","^^^^")
	s totalnum = 0
	for i=1:1:$l(MCFeeData,"!")
	{
		s tmpFeeData = $p(MCFeeData,"!",i)
		s tmpFeeCode = $p(tmpFeeData,"^",2)	
		//精确2位小数
		s tmpFeeNum = $j($p(tmpFeeData,"^",4),0,2)
		//计算总费用
		s totalnum = +$g(totalnum)+ tmpFeeNum
		//更改初始化字符串中的值。
		
		for j=1:1:$l(feeDataContent,"!")
		{
			s initFeeData = $p(feeDataContent,"!",j)
			s initFeeCode = $p(initFeeData,"^",2)
			continue:(initFeeCode'=tmpFeeCode)
			
			//更新费用值信息
			s updateFeeInfo = tmpFeeCode_"^"_tmpFeeCode_"^"_tmpFeeNum	
			s $p(feeDataContent,"!",j) = updateFeeInfo
		}
			
	}
	
	
	s totalnum = $j(totalnum,0,2)
	s TotalFee = ..InPatPayCostTotal(argAdmId)
	
	
	
	if (TotalFee'=totalnum) 
	{
		s retValue = "异常信息:总费用与费用类汇总数额不符，请验证接口后使用"
	}
	else
	{
		//更新总费用
		s updateTotalFeeInfo = "Total^总费用^"_TotalFee
		s $p(feeDataContent,"!",1) = updateTotalFeeInfo
		s retValue = feeDataContent
	}
	
	q retValue
}

/// Desc:	新病案费用信息：按照费用子类 一般38项
/// Output:	
/// Others:
ClassMethod InPatCostTrakCareSubNew(argAdmId As %String, argHospital As %String = "") As %String
{
	s retValue = ""
	q:(($d(argAdmId)=0)||(argAdmId="")) retValue
	
	s feeDataContent = "Total^总费用^0.00!"
	s feeDataContent = feeDataContent_"自付金额^自付金额^0.00!"
	s feeDataContent = feeDataContent_"一般医疗服务费^一般医疗服务费^0.00!"
	s feeDataContent = feeDataContent_"一般治疗操作费^一般治疗操作费^0.00!"
	s feeDataContent = feeDataContent_"护理费^护理费^0.00!"
	s feeDataContent = feeDataContent_"其他费^其他费^0.00!"
	s feeDataContent = feeDataContent_"病理诊断费^病理诊断费^0.00!"
	s feeDataContent = feeDataContent_"实验室诊断费^实验室诊断费^0.00!"
	s feeDataContent = feeDataContent_"影像学诊断费^影像学诊断费^0.00!"
	s feeDataContent = feeDataContent_"临床诊断项目费^临床诊断项目费^0.00!"
	s feeDataContent = feeDataContent_"非手术治疗项目费^非手术治疗项目费^0.00!"
	s feeDataContent = feeDataContent_"临床物理治疗费^临床物理治疗费^0.00!"
	s feeDataContent = feeDataContent_"手术治疗费^手术治疗费^0.00!"
	s feeDataContent = feeDataContent_"麻醉费^麻醉费^0.00!"
	s feeDataContent = feeDataContent_"手术费^手术费^0.00!"
	s feeDataContent = feeDataContent_"康复费^康复费^0.00!"
	s feeDataContent = feeDataContent_"中医治疗费^中医治疗费^0.00!"
	s feeDataContent = feeDataContent_"西药费^西药费^0.00!"
	s feeDataContent = feeDataContent_"抗菌药物费^抗菌药物费^0.00!"
	s feeDataContent = feeDataContent_"中成药费^中成药费^0.00!"
	s feeDataContent = feeDataContent_"中草药费^中草药费^0.00!"
	s feeDataContent = feeDataContent_"血费^血费^0.00!"
	s feeDataContent = feeDataContent_"白蛋白类制品费^白蛋白类制品费^0.00!"
	s feeDataContent = feeDataContent_"球蛋白类制品费^球蛋白类制品费^0.00!"
	s feeDataContent = feeDataContent_"凝血因子类制品费^凝血因子类制品费^0.00!"
	s feeDataContent = feeDataContent_"细胞因子类制品费^细胞因子类制品费^0.00!"
	s feeDataContent = feeDataContent_"检查用一次性医用材料费^检查用一次性医用材料费^0.00!"
	s feeDataContent = feeDataContent_"治疗用一次性医用材料费^治疗用一次性医用材料费^0.00!"
	s feeDataContent = feeDataContent_"手术用一次性医用材料费^手术用一次性医用材料费^0.00!"
	s feeDataContent = feeDataContent_"其他费用^其他费用^0.00"
	
	s MCFeeData = ##CLASS(web.DHCBillInterface).IGetTarItemCate(argAdmId,"","MCNew","^^^^")
	s totalnum = 0
	for i=1:1:$l(MCFeeData,"!")
	{
		s tmpFeeData = $p(MCFeeData,"!",i)
		s tmpFeeCode = $p(tmpFeeData,"^",2)	
		//精确2位小数
		s tmpFeeNum = $j($p(tmpFeeData,"^",4),0,2)
		//计算总费用
		s totalnum = +$g(totalnum)+ tmpFeeNum
		//更改初始化字符串中的值。
		
		for j=1:1:$l(feeDataContent,"!")
		{
			s initFeeData = $p(feeDataContent,"!",j)
			s initFeeCode = $p(initFeeData,"^",2)
			continue:(initFeeCode'=tmpFeeCode)
			
			//更新费用值信息
			s updateFeeInfo = tmpFeeCode_"^"_tmpFeeCode_"^"_tmpFeeNum	
			s $p(feeDataContent,"!",j) = updateFeeInfo
		}
			
	}
	s totalnum = $j(totalnum,0,2)
	s TotalFee = ..InPatPayCostTotal(argAdmId)
	
	
	
	if (TotalFee'=totalnum) 
	{
		s retValue = "异常信息:总费用与费用类汇总数额不符，请验证接口后使用"
	}
	else
	{
		//更新总费用
		s updateTotalFeeInfo = "Total^总费用^"_TotalFee
		s $p(feeDataContent,"!",1) = updateTotalFeeInfo
		
		s updateSelfPayInfo = "自付金额^自付金额^"_..InPatSelfPayCost(argAdmId)
		s $p(feeDataContent,"!",2) = updateSelfPayInfo
		
		s retValue = feeDataContent
	}
	
	q retValue
}

/// Desc:	
/// Output:	##class(EMR.DOC.HISInterface.PatientInfoAssist).InPatSelfPayCost(Adm)
/// Others:
ClassMethod InPatSelfPayCost(argAdmId As %String, argHospital As %String = "") As %String
{
	s retValue = ""
	q:(($d(argAdmId)=0)||(argAdmId="")) retValue
	
	s PatfeeInfo = ##Class(web.DHCBillInterface).IGetDepAndBalnace(argAdmId)
	s selfPay = $j($p(PatfeeInfo,"^",4),0,2)
	s retValue=selfPay
	
	q retValue
}

/// Desc:	
/// Output:	##class(EMR.DOC.HISInterface.PatientInfoAssist).InPatPayCostTotal(Adm)
/// Others:
ClassMethod InPatPayCostTotal(argAdmId As %String, argHospital As %String = "") As %String
{
	s retValue = ""
	q:(($d(argAdmId)=0)||(argAdmId="")) retValue
	
	///编号24测试总费用不符，
	///编号11测试总费用信息与合计子类一致。
	
	///接口编号24
	///s PatfeeInfo = ##class(web.DHCBillInterface).IGetpatFeeInfo(argAdmId,1)
	///s totalCost = $j($p(PatfeeInfo,"^",1),0,2)
	
	///接口编号11
	s PatfeeInfo = ##Class(web.DHCBillInterface).IGetDepAndBalnace(argAdmId)
	s totalCost = $j($p(PatfeeInfo,"^",3),0,2)
	
	s retValue=totalCost
	
	q retValue
}

/// ------------------------GetClinicDiagInfo配套接口Start-------------------
///   20140912 end
/// Creator:	wangwentao
/// CreatDate:	20090606
/// Description:获取诊断信息
/// Table:		/
/// Input:		西医诊断(argTypeId=1) 中医诊断(argTypeId=2) 中医辩证(argTypeId=3) 全部诊断(argTypeId="")
/// 				argDiagCode {RowID,ICD10}
/// Output:		/
/// Return:		/
/// Others:		SQL MR_Diagnos
/// 				^MR(argAdmId,"DIA",0)
/// 				^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub})
/// 				MRDIA_SignSym_DR   note 10  中医辨证 BJZYYY  -> Table is  MRC_DiagnosSignSymptom 
/// 				Table is  MRC_DiagnosSignSymptom ^MRC("DSYM",{DSYM_RowId}) 	
/// 				SQL MRC_ICDDx
/// 				^MRC("ID",{MRCID_RowId})    Table is  MRC_ICDDx 
/// 				MRCID_ICD9CM_Code  note 4
/// 				MRCID_Desc_        note 2
/// 				MRCID_BillFlag3    note 15  区别 中医诊断 西医诊断
/// 				如果诊断备注diagnote不为空，则取诊断备注信息
/// 				SQLUser.MR_Diagtype
/// 				SQLUser.MRC_DiagnosType
/// 				SQLUser.MR_Diagnos
/// 				SQLUser.DHC_MRDiagnos
/// Example:		
ClassMethod GetDiagnos(argAdmId As %String, argTypeId As %String = "", argDiagCode As %String = "ICD10") As %String
{
	//通过argAdmId 取PAADM_MainMRADM_DR
	s MRAdmId="" 
	s MRAdmId=$p($g(^PAADM(argAdmId)),"^",61)

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:(MRAdmId="") ""
	q:($d(^MR(MRAdmId,"DIA"))'=10) ""
	s diagstr="",diagstr2="",diagstr3="",diag="",diagdesc="",diagcode="",diagnote="",diagDR="",diagsub="0",diagflag="",diagsymDR=""
	
	f  s diagsub=$o(^MR(MRAdmId,"DIA",diagsub)) q:diagsub=""  d
	. s diagDR=$p($g(^MR(MRAdmId,"DIA",diagsub)),"^",1)
	. s diagsymDR=$p($g(^MR(MRAdmId,"DIA",diagsub)),"^",10)
	. //兼容仅写诊断备注不选择诊断库的情况 并修改diagdesc diagflag取值
	. //q:(diagDR="")
	. //兼容diagcode取ICD10或RowID
	. s:($ZCVT(argDiagCode,"U")="ICD10") diagcode=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",4),1:"")
	. s:($ZCVT(argDiagCode,"U")="ROWID") diagcode=$s(diagDR'="":diagDR,1:"")
	. s diagdesc=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",2),1:"")
	. s diagflag=$s(diagDR'="":$p($g(^MRC("ID",diagDR)),"^",15),1:"")
	. s diagnote=$g(^MR(MRAdmId,"DIA",diagsub,"DES",1))
	. i diagflag'="Y" d
	. . i diagnote'="" d
	. . . s diag=diagDR_"^"_diagcode_"^"_diagdesc_"("_diagnote_")"_"!"
	. . e  d  
	. . . s diag=diagDR_"^"_diagcode_"^"_diagdesc_"!" 
	. . s diagstr=diagstr_diag
	. e  d 
	. . i diagsymDR'="" d
	. . . s diagsym=diagDR_"^"_$p($g(^MRC("DSYM",diagsymDR)),"^",1)_"^"_$p($g(^MRC("DSYM",diagsymDR)),"^",2)_"!" 
	. . . s diagstr3=diagstr3_diagsym
	. . i diagnote'="" d  
	. . . s diag=diagDR_"^"_diagcode_"^"_diagdesc_"("_diagnote_")"_"!"
	. . e  d  
	. . . s diag=diagDR_"^"_diagcode_"^"_diagdesc_"!" 
	. . s diagstr2=diagstr2_diag
	
	// WM
	if argTypeId="1"
	{
		s diagstr=diagstr
	}
	// TCM
	elseif argTypeId="2"
	{
		s diagstr=diagstr2
		s diagstr=..CheckRepeatDiag(argAdmId,diagstr)
	}
	// SYM
	elseif argTypeId="3"
	{
		s diagstr=diagstr3
	}
	// ALL
	else 
	{
		s diagstr=diagstr_diagstr2
	}
	
	q diagstr
}

/// ##Class(EPRservice.TestAndTools.DevTest).CheckRepeat()
ClassMethod CheckRepeatDiag(argAdmId As %String, argDiagStr As %String) As %String
{

	q:($d(argAdmId)=0)||(argAdmId="") ""
	q:($d(argDiagStr)=0)||(argDiagStr="") ""
	
	
	s DiagStr="",Diag="",DiagNo=""
	
	s tmpDiagStr=argDiagStr,Adm=argAdmId
	
	s tmpNode="",i=""
	
	
	k ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA")
	
	if tmpDiagStr'=""
	{
		//s diagcount=$l(DiagString,"!")-1
		s diagcount=$l(tmpDiagStr,"!")
		f i=1:1:diagcount 
		{
			//b "s"
			s tmpDiag=$p($g(tmpDiagStr),"!",i)
			if tmpDiag'=""
			{
				if $d(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag))'=1
				{
					s ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag)=i_"#"_tmpDiag
				}
			}
		}
		
		
		f i=1:1:diagcount 
		{
			//b "s"
			s tmpDiag=$p($g(tmpDiagStr),"!",i)
			if tmpDiag'=""
			{
				s DiagNo=$p($g(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag)),"#",1)
				s Diag=$p($g(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA",tmpDiag)),"#",2)
				
				
				if $d(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",DiagNo))'=1
				{
					s ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",DiagNo)=Diag
				}
			}
		}

		 f  s tmpNode=$o(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",tmpNode)) quit:tmpNode=""  d
		 . s Diag=$g(^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA",tmpNode))_"!"
		 . s DiagStr=DiagStr_Diag
		 
	
		 k ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"TMPDIA")
		 k ^CacheTempDHCEPRDebug("CheckRepeat",Adm,"DIA")

	}
	
	q DiagStr
}

/// Desc:	出院诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).OutDiagnos("6112")
ClassMethod OutDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中出院诊断对应的RowId 
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))  
	q:(admDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
	
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s IsMainDiagnosFlag=$p(^MR(mainmradmdr,"DIA",mrdiachildsub,1),"^",20)
			q:(IsMainDiagnosFlag="Y")
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为出院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/*
/// Desc:	主要诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MainDiagnos("65")
ClassMethod MainDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s mainDiagTypeId = ""
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	q:(mainDiagTypeId = "") ""
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}
*/
/// Desc:	主要诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MainDiagnos("6112")
ClassMethod MainDiagnos(argAdmId As %String) As %String
{
	
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	s mainDiagTypeId = ""
	s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))
	q:(mainDiagTypeId = "") ""
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s IsMainDiagnosFlag=$p(^MR(mainmradmdr,"DIA",mrdiachildsub,1),"^",20)
			q:(IsMainDiagnosFlag="N")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为出院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				q:(mricdid = "") 
	
				s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{	s mricdDesc = mricdDesc_"("_diagNote_")"}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
		}
	}
	
	q retValue
}

/// Desc:	入院诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：入院诊断类型id
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Upate: 	2010-12-29 入院诊断类型增加 C008
ClassMethod AdmDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId    
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))          //PRE 初步诊断
	//s tmpid1 = $O(^MRC("DTYP",0,"Code","PRE3ZYZD",""))            //PRE-3-ZYZD 中医诊断 
	s tmpid2 = $O(^MRC("DTYP",0,"Code","M1XYZD",""))              //M-1-XYZD 西医诊断  
	//s admDiagTypeId = admDiagTypeId_"^"_tmpid2_"^"_tmpid1
	s admDiagTypeId = admDiagTypeId_"^"_tmpid2
	q:(admDiagTypeId = "") ""
	
	s admDiagTypeId = "^"_admDiagTypeId_"^"
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")

			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为入院诊断
			if ($find(admDiagTypeId, "^"_typmrcdiagtyp_"^"))
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
					s mricdBillFlag1 = $p($g(^MRC("ID",mricdid)),"^",13)
					s mricdBillFlag3 = $p($g(^MRC("ID",mricdid)),"^",15)
				}
				else {
					s Questionnaire=$P($G(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",22)
					s mricdCode = ""
					s mricdDesc = ""
					s mricdBillFlag1 = ""
					//"中医" Questionnaire为2；"证型" Questionnaire为3
					s mricdBillFlag3 = "Y"
					//"西医" Questionnaire为1
					s:(Questionnaire=1) mricdBillFlag3 = "N"
				}
					
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				//zengweishan 添加级别和顺序号
				s leve=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",1)
				s sequence=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve_"^"_mricdBillFlag3}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve_"^"_mricdBillFlag3}
			}
		}
	}
	
	q retValue
}

/// ------------------------GetClinicDiagInfo配套接口End-------------------
/// ------------------------GetATDInfo配套接口Start-------------------
/// Desc:	入院日期时间(分床时间)【Cache内部格式】
/// Table：
/// Output：date_","_time
ClassMethod AdmDateTimeInBed(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",bed="",admdatetime="",admdate="",admtime=""
	s admdatetimeinbed=""

	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.q:(bed="")
	.s admdate=$p(^PAADM(argAdmId,"TRANS",TRANSChildsub),"^",1)
	.s admtime=$p(^PAADM(argAdmId,"TRANS",TRANSChildsub),"^",2)
	if (admdate'="")&&(admtime'="") 
	{
		s admdatetimeinbed=admdate_","_admtime
	}
	
	q admdatetimeinbed
}

/// Desc：	入院科室【返回: RowId^Code^Desc】
/// Table：	
/// OutPut:	RowId^Code^Desc
/// Others: not different from hospitals
ClassMethod AdmDept(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s TRANSChildsub="",locDR="",tmplocDR="",bed="",admdept="",DeptDesc="",DeptCode=""
	
	// 遍历转科记录，取入院科室
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s tmplocDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",6)
	.if tmplocDR'="" {s locDR=tmplocDR}
		
	if locDR'="" 
	{	
		s DeptCode=$p($g(^CTLOC(locDR)),"^",1)
		s DeptDesc=$p($g(^CTLOC(locDR)),"^",2)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s admdept=locDR_"^"_DeptCode_"^"_DeptDesc		
	}
	
	q admdept
}

/// Desc:	入院病区【RowId^Code^Desc】
/// Table：	
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
ClassMethod AdmWard(argAdmId As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",WardCode="",wardDR="",bed="",WardDesc="",admward=""
	
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s wardDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",9)
	if wardDR'="" 
	{
		if (argHospital="BJXHYY")
		{
			s admward=..GetShortWard(wardDR)
			}
		else
		{
			s WardCode=$p($g(^PAWARD(wardDR)),"^",1)
			s WardDesc=$p($g(^PAWARD(wardDR)),"^",2)
			if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
			s admward=wardDR_"^"_WardCode_"^"_WardDesc
		}
			
	}
	
	q admward
}

/// Desc:   入院床号【RowId^Code^Desc】
/// Table：  
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
ClassMethod AdmBed(argAdmId As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
    
    s TRANSChildsub="",WardCode="",wardDR="",bedDR="",WardDesc="",admward=""
    
    f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bedDR'="")  d
    .s bedDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
    .s wardDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",9)  
    q:($d(bedDR)=0)||(bedDR="")||($l(bedDR,"||")<2) ""
    s bedwordrowid = $p(bedDR,"||",1)
    s bedchildsub = $p(bedDR,"||",2)
    
    q:($d(^PAWARD(bedwordrowid,"BED"))'=10) ""
    
    s bedno = $p($g(^PAWARD(bedwordrowid,"BED",bedchildsub)),"^",1)
    
    q bedno
}

/// Desc:	入院病区【RowId^Code^Desc】
/// Table：	SQLUser.PA_AdmTransaction TRANS_Room_DR /SQLUser.PAC_Room
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
/// Test:   ##Class(EMR.DOC.HISInterface.PatientInfoAssist).AdmRoom()
ClassMethod AdmRoom(argAdmId As %String, argHospital As %String = "") As %String
{
	
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s TRANSChildsub="",roomDR="",room="",bed="",RoomCode="",RoomDesc="",admroom=""
	
	f  s TRANSChildsub=$o(^PAADM(argAdmId,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
	.s bed=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",8)
	.s roomDR=$p($g(^PAADM(argAdmId,"TRANS",TRANSChildsub)),"^",7)
	if roomDR'="" 
	{
		s RoomCode=$p($g(^PAROOM(roomDR)),"^",1)
		s RoomDesc=$p($g(^PAROOM(roomDR)),"^",2)
		//if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s admroom=roomDR_"^"_RoomCode_"^"_RoomDesc
	}
	
	q admroom
}

/// Desc:	取病区简写【RowId^Code^Desc】
/// Table：	
/// Output：RowId^Code^Desc
/// Others：not different from hospitals
ClassMethod GetShortWard(argWardDR As %String) As %String
{
	
	q:(($d(argWardDR)=0)||(argWardDR="")) ""
	s admward="",LocDR="",WardCode="",WardDesc=""
	s LocDR=$p($g(^PAWARD(argWardDR)),"^",5)	
	if LocDR'="" 
	{
		s WardCode=$p($g(^CTLOC(LocDR)),"^",1)
		s WardDesc=$p($g(^CTLOC(LocDR)),"^",56)
		if (WardDesc="")
		{
			s WardDesc=$p($g(^CTLOC(LocDR)),"^",2)
			}
		if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
		s admward=LocDR_"^"_WardCode_"^"_WardDesc
	}
	
	q admward
}

/// Desc：	死亡日期时间
/// Ouput：	date，time【内部格式】
/// Others：not different from hospitals 
ClassMethod DeathDateTime(AEpisodeID As %String, argPapmiDR As %String, argHospital As %String = "") As %String
{
	q:(($d(argPapmiDR)=0)||(argPapmiDR="")) ""
		
	//14, '5', '死亡', 'D'
	//15, '9', '其他', NULL
	s mradmid = $p(^PAADM(AEpisodeID),"^",61)
	s conditAtDischID = $p(^MR(mradmid,"PRO",1),"^",10)
	q:(conditAtDischID ="") ""
	s dischDeadFlag = $p(^PAC("DISCON",conditAtDischID),"^",3)
	q:(dischDeadFlag'="D") ""

	s deathdate="",deathtime=""
	s deathdate=$p(^PAPER(argPapmiDR,"ALL"),"^",13)
	s deathtime=$p(^PAPER(argPapmiDR,"ALL"),"^",8)
	q:((deathdate="")||(deathtime="")) ""
	q deathdate_","_deathtime
}

/// Desc:	出院日期时间【统计组.工作量】
/// Other:  ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTimeMR("7","DiTan")
ClassMethod DisDateTimeMR(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	//q:($d(argMeddata)=0)||(argMeddata="") ""
	//q:($d(argWebsrc)=0)||(argWebsrc="") ""
	//q:($d(argHospital)=0)||(argHospital="") ""
	
	//取命名空间
	s NAMESPACES=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NamespaceHIS")
	if NAMESPACES'=""
	{
		s MEDDATA = $p($g(NAMESPACES),"^",1)
		s WEBSRC  = $p($g(NAMESPACES),"^",2)
	    //s LABDATA = $p($g(NAMESPACES),"^",3)
	    //s LABSRC  = $p($g(NAMESPACES),"^",3)
	}
	
	//转命名空间 调用统计组接口
	d $zu(5,MEDDATA)
	s dischgdatetime=""
    s dischgdatetime=$$GetDisAdmDate^DHCMRIPday(argAdmId)
    d $zu(5,WEBSRC)
    
    //转换为标准格式
    if (dischgdatetime'="^")&&(dischgdatetime'="")
    {
	    s dischgdatetime=$tr(dischgdatetime,"^",",")
    }
    else
    {
	    s dischgdatetime=""
	}

    q dischgdatetime
}

/// Desc: 	出院日期时间(医生结算)
/// Output：date_","_time【Cache内部格式】
/// Others：not different from hospitals
ClassMethod DisDateTimeDoctor(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s dischgdatetime="",dischgdate="",dischgtime=""
	s dischgdateyear="",dischgdatemonth="",dischgdateday=""
		
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
	s dischgdate=$P($G(^PAADM(argAdmId)),"^",59)
	s dischgtime=$P($G(^PAADM(argAdmId)),"^",60)
	q:((dischgdate="")||(dischgtime="")) ""

	s dischgdatetime=dischgdate_","_dischgtime
	q dischgdatetime
}

/// Desc:	转科情况
/// Output:	(科室名称->科室名称->...)或(无)
/// Others:	not different from hospitals 
ClassMethod TransDept(argAdmId As %String) As %String
{
	//入参检查
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept="",transStatusDR=""
	
	//最大的childSub节点
	s maxChildSub = $O(^PAADM(argAdmId,"TRANS",""),-1)
	
	s childSub = "0"
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		//扬中项目：索引问题导致轮询到最后一个childSub后，又再次重新开始轮询
		q:(childSub = maxChildSub)
		
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		s transDept = transDept_tmpTransDept
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
		
	q transDept
	
	/*
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s transDept="",tmpTransDept="",lastTransDept=""
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do result.Prepare("select trans_ctloc_dr from PA_AdmTransaction  where trans_parref = ? and trans_status_dr <> 2 and trans_ctloc_dr is not null order by trans_childsub")
	Do result.Execute(argAdmId)
	For  Quit:'result.Next()  Do
	.s tmpTransDept=$p($g(^CTLOC(result.Data("TRANS_CTLOC_DR"))),"^",2)
	.if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p($g(tmpTransDept),"-",2)}
	.q:(tmpTransDept="")
	.if tmpTransDept'=lastTransDept  d
	..s transDept=transDept_tmpTransDept
	..S transDept=transDept_"->"
	.s lastTransDept=tmpTransDept
	if transDept'=""
	{
	 s transDept=$e(transDept,1,$l(transDept)-2)
	 if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
	q transDept
	*/
}

/// Desc:	转科明细
/// Output:	(科室DR^科室名称^日期^时间^病区DR^病区名称->科室DR^科室名称^日期^时间^病区DR^病区名称->...)或(无)
/// 		Update wangwentao 20090901 Update 20100408
/// ModifyDate: 2009-09-12
/// ModifyUser: houj
/// ModifyReson: 使用global实现替代sql实现
ClassMethod TransDeptDetail(argAdmId As %String, argHospital As %String = "") As %String
{
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept="",lastTransWard="",tmpTransWard=""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		//get TRANS_Ward_DR PAC_Ward
		s transPACWardDR = $p($g(^PAADM(argAdmId,"TRANS",childSub+1)),"^",9)
		if transPACWardDR="" continue
		
		s tmpTransWard = $p($g(^PAWARD(transPACWardDR)),"^",2)
		if $l(tmpTransWard,"-")>1 {s tmpTransWard=$p(tmpTransWard,"-",2)}
		if tmpTransDept="" continue
		if tmpTransWard=lastTransWard continue
		
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		
		s transDept = transDept_transCtlocDR_"^"_tmpTransDept_"^"_$zd(startDate,3)_"^"_$zt(startTime)_"^"_transPACWardDR_"^"_tmpTransWard
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
		s lastTransWard=tmpTransWard
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept=..#NoTransDept}
	}
		
	q transDept
}

/// Creator:	zhaopeng
/// CreatDate:	2015-3-02
/// Desc: 	就诊科室
ClassMethod GetEpisodeCTLoc(argAdmId As %String)
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	s deptDR= $P($g(^PAADM(argAdmId)),"^",4)
	s dept=$p($g(^CTLOC(deptDR)),"^",2)
	q $p($g(dept),"-",2)
}

/// Desc:	住院天数
/// Input:	argAdmId: 病人就诊RowID，argHospital:医院标识
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDaysAdm(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""

	s admdate="",admtime="",dischgdate="",dischgtime=""
	s residentdays=""

	//取PapmiDR
	q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""

	s admdate = $p(..AdmDateTime(argAdmId,argHospital),",",1)
	
	s dischgdate=$p(..DisDateTime(argAdmId,argHospital),",",1)
	
	q:((admdate="")||(dischgdate="")) ""
	
	//计算住院天数
	s residentdays = ..ResidentDays(admdate,dischgdate)

	q residentdays
}

/// Desc:	入院次数(Trak中入院病人状态不是Cancel的个数)
/// Others:	not different from hospitals 
ClassMethod InTimes(argAdmId As %String, argHospital As %String = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""	
	
	s admid=0,times=0,papmiDR=""
	
	//PAADM_InPatNo
	s times= $p($g(^PAADM(argAdmId)),"^",29)
	q:(times '="")&&(times '= $C(0)) times
	
	s times = 0
	s papmiDR =..GetPapmiDR(argAdmId)
	q:($d(^PAPERdr(papmiDR,"ADM","I"))'=10) "1"
	for {
		s admid=$o(^PAPERdr(papmiDR,"ADM","I",admid))
		q:((admid="")||(admid>argAdmId))
		// Trak中入院病人状态不是Cancel的个数
		if $d(^PAADMi("PAADM_VisitStatus","C",admid))=0 {s times=times+1}
	}
		
	q times
}

/// Desc:	医政组的入院次数
ClassMethod InTimesWMR(argAdmId As %String, argHospital As %String) As %String
{
	s times=##Class(web.DHCWMRCodingInterface).getPaadmIP(argAdmId)
	q:(times="0") "1"
	q times
}

/// Add by Liaowp 2012-1-15
/// Desc:  取护理组日常生活能力评定量表得分
/// OutPut:Inscore^Outscore
/// DeBug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).PatSelfCareDegree(539)
ClassMethod PatSelfCareDegree(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") "^"
	
	s ScoreStr="^",InScore="",OutScore=""
	s ScoreStr=##class(Nur.DHCMoudDataSub).getshnlpf(argAdmId)
	if (ScoreStr="")
	{
		s ScoreStr="^"
		}
	if (ScoreStr'="^")
	{
		s InScore=$P($P(ScoreStr,"^",1),"|",2)
		s OutScore=$P($P(ScoreStr,"^",2),"|",2)
		s ScoreStr=InScore_"^"_OutScore
		}	
	q ScoreStr
}

/// Desc:	住院天数
/// Input:	argAdmDate: 入院日期(Cache内部格式)，argDischgDate:出院日期(Cache内部格式)
/// Output:	天数
/// Others:	not different from hospitals
ClassMethod ResidentDays(argAdmDate As %String, argDischgDate As %String) As %String
{
	q:($d(argAdmDate)=0)||($d(argDischgDate)=0)||(argAdmDate="")||(argDischgDate="") ""
	s residentdays=""
	
	s residentdays=argDischgDate - argAdmDate
	q:(residentdays<0) ""
 	//不足1天按1天计算
 	q:(residentdays=0) "1"
 	
 	q residentdays
}

/// Desc: 	出院科室(即当前科室)【RowId^Code^Desc】
/// Output：RowId^Code^Desc
/// Others: not different from hospitals
/// ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDept(165,"","2020-04-07 16:17:01") 
ClassMethod DisDept(argAdmId As %String, argHospital As %String = "", argHappenDateTime = "") As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	
	s DeptCode="",DeptDesc="",dischgDeptDR="",dischgDept=""
	
	//s dischgDeptDR=$P($g(^PAADM(argAdmId)),"^",4)
	
	//生成转科数据列
	s ind = $i(^CacheTemp)
	
	s tmpDeptDR = ""
	for
	{
		s tmpDeptDR=$o(^PAADMi("TransLoc",argAdmId,tmpDeptDR))
		q:(tmpDeptDR = "")
		
		s tmpTransID = ""
		for
		{
			s tmpTransID=$o(^PAADMi("TransLoc",argAdmId,tmpDeptDR,tmpTransID))
			q:(tmpTransID="")
			
			s objTrans = $g(^PAADM(argAdmId,"TRANS",tmpTransID))
			s tmpTransDate = $p(objTrans,"^",1)
			s tmpTransTime = $p(objTrans,"^",2)
			s ^CacheTemp(ind,"EMRCurTransDept",tmpTransDate,tmpTransTime,tmpDeptDR)=""
			
		}
	}
	
	//从转科列表中找到与传入时间最近的科室ID
	
	if ((argHappenDateTime'="")&&($d(^CacheTemp(ind,"EMRCurTransDept"))=10))
	{
		s argdate = $zdh($p(argHappenDateTime," ",1),3)
		s argtime = $zth($p(argHappenDateTime," ",2),1)
		
		s tmpDate = $o(^CacheTemp(ind,"EMRCurTransDept",(argdate+1)),-1)


		s tmpTime = $o(^CacheTemp(ind,"EMRCurTransDept",tmpDate,(argtime+1)),-1)
		s:(tmpTime="") tmpTime = $o(^CacheTemp(ind,"EMRCurTransDept",tmpDate,""),-1)
		
		s dischgDeptDR= $o(^CacheTemp(ind,"EMRCurTransDept",tmpDate,tmpTime,""))
	}
	else
	{
		s dischgDeptDR= $P($g(^PAADM(argAdmId)),"^",4)
	}
	
	if dischgDeptDR'="" 
	{	
		s DeptDesc=$p($g(^CTLOC(dischgDeptDR)),"^",2)
		s DeptCode=$p($g(^CTLOC(dischgDeptDR)),"^",1)
		if $l(DeptDesc,"-")>1 {s DeptDesc=$p($g(DeptDesc),"-",2)}
		s dischgDept=dischgDeptDR_"^"_DeptCode_"^"_DeptDesc
	}

	k ^CacheTemp(ind,"EMRCurTransDept")
	
	q dischgDept
}

/// Desc: 出院日期(操作权限使用)
/// Input: argAdmId 就诊rowid，argProductcode 项目标识
/// Output: date, Cache内部格式
/// Debug：##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDatePriv("65")	
ClassMethod DisDatePriv(argAdmId As %String, argProductcode As %String = "") As %String
{
	
	q:(argAdmId="") ""
	s (deathdate,disDateMR,disDate) = ""
	
	//先取死亡日期
	s papmiDR = ..GetPapmiDR(argAdmId)
	if papmiDR '= ""
	{	s deathdate=$p(^PAPER(papmiDR,"ALL"),"^",13)}
	q:(deathdate'="") deathdate
	
	//再取统计组出院日期
	s nameSpace=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("NamespaceHIS",argProductcode)
	if nameSpace'=""
	{
		s medData = $p($g(nameSpace),"^",1)
		s curSpace = $zu(5)
		d $zu(5,medData)
		s iprowid=0 
	 	for {
		  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",argAdmId,iprowid)) 
		  q:(iprowid="")
		  s MRIPDayDr=$p($g(^DHCMRIPDetail(iprowid)),"^",3)
	 	  s disDateMR=$p($g(^MRIPdaily(MRIPDayDr)),"^",6)
	 	}
	 	d $zu(5,curSpace)
	 	q:(disDateMR'="") disDateMR
	}
	
 	//最后取护士结算日期
 	s disDate = $P($G(^PAADM(argAdmId)),"^",17)
 	q disDate
}

/// Desc:  	出院病区【RowId^Code^Desc】
/// Output: RowId^Code^Desc
/// Others：not different from hospitals 
ClassMethod DisWard(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s WardDesc="",WardCode="",dischgWardDR="",dischgWard=""
	
	s dischgWardDR=$P($g(^PAADM(argAdmId)),"^",70)
	if dischgWardDR'="" 
	{
		if (argHospital="BJXHYY")
		{
			s dischgWard=..GetShortWard(dischgWardDR)
			}
		else
		{
			s WardDesc=$p($g(^PAWARD(dischgWardDR)),"^",2)
			s WardCode=$p($g(^PAWARD(dischgWardDR)),"^",1)
			if $l(WardDesc,"-")>1 {s WardDesc=$p($g(WardDesc),"-",2)}
			s dischgWard=dischgWardDR_"^"_WardCode_"^"_WardDesc
		}
	}	
	
	q dischgWard
}

/// Desc:  	出院病区【RowId^Code^Desc】
/// Output: RowId^Code^Desc
/// Others：not different from hospitals 
/// Test:   ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisRoom()
ClassMethod DisRoom(argAdmId As %String, argHospital As %String = "") As %String
{
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	s RoomDesc="",RoomCode="",DisRoomDR="",DisRoom=""
	
	s DisRoomDR=$P($g(^PAADM(argAdmId)),"^",69)
	if DisRoomDR'="" 
	{
		s RoomCode=$p($g(^PAROOM(DisRoomDR)),"^",1)
		s RoomDesc=$p($g(^PAROOM(DisRoomDR)),"^",2)
		//if $l(RoomDesc,"-")>1 {s RoomDesc=$p($g(RoomDesc),"-",2)}
		s DisRoom=DisRoomDR_"^"_RoomCode_"^"_RoomDesc
	}	
	
	q DisRoom
}

/// Desc:	出院床位号
ClassMethod DisBed(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s bedwordrowid="",bedchildsub=""
	s bedDR="",dischgbedno=""

    q:(($d(^PAADM(argAdmId))'=1)&&($d(^PAADM(argAdmId))'=11)) ""
    
	s bedDR=$p($g(^PAADM(argAdmId)),"^",73)
	
	q:($d(bedDR)=0)||(bedDR="")||($l(bedDR,"||")<2) ""
	s bedwordrowid = $p(bedDR,"||",1)
	s bedchildsub = $p(bedDR,"||",2)
	
    q:($d(^PAWARD(bedwordrowid,"BED"))'=10) ""
    
	s dischgbedno = $p($g(^PAWARD(bedwordrowid,"BED",bedchildsub)),"^",1)

 	q dischgbedno
}

/// ------------------------GetATDInfo配套接口End-------------------
/// ------------------------GetCustomInfo配套接口Start-------------------
/// Creator:	wangwentao
/// CreatDate:	2012-10-15
/// Description:获取护理组急诊病人评分 
/// Table:		##class(web.DHCCLScore).GetScoreDetailByAdmAndScoreType(30517,"APACHE")
/// parameter:	AEpisodeID 就诊号 AScoreType 评分类型:CRAMS,GLASG,RTS,GUSTL,ISS,SOFA,MEDS,APACHE,CPugh
/// 			w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatScoreByAdmAndScoreType(30517,"APACHE")
ClassMethod GetPatScoreByAdmAndScoreType(AEpisodeID As %String, AScoreType As %String) As %String
{
	q:($d(AEpisodeID)=0)||(AEpisodeID="") ""
	q:($d(AScoreType)=0)||(AScoreType="") ""
	
	s PatScore=""
	
	//s PatScore =##class(web.DHCCLScore).GetScoreDetailByAdmAndScoreType(AEpisodeID,AScoreType)
			
	q PatScore
}

///      ------------------------GetCustomInfo配套接口End-------------------
/// d ##class(%ResultSet).RunQuery("EMR.DOC.HISInterface.PatientInfoAssist","GetPatOperInfo",8099813)
Query GetPatOperInfo(AEpisodeID As %String) As %Query(ROWSPEC = "status,jzstat,opdate,oproomdes,opordno,regno,patname,sex,age,opname,opdes,opdr,diag,opd,opdoc,locdes,anmethod,andoc,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,AnaesthesiaID,operPosition,OPCategory,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,tDocArriveTime,tOpStartDate,tOpStartTime,tAppCtcpDesc,nurNotes,mzdr,bodsDesc,yg,bg,az,md,qt,ASA,opUnPlanedOperation,FreezingSlice,ash,technical,docNo,astechnical,asdocNo,secastechnical,secasdocNo,patstatus,ico,hz,visitstatus,paweight,address,IsOrNotRelease,Chargestate,qixieno,xunhuino,opstatus,shoushujian,paadmtype,admLocdes,openddatestr,operShiJi,xunhuino1,xunhuino2,locdesGroup,eDeposit,antUsePurpose,andocNo,opInterviewNur")
{
}

ClassMethod GetPatOperInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	 Set repid=$I(^CacheTemp)
     Set ind=1
     Set qHandle=$lb(0,repid,0)
         
    
     s opaId="",j=1
	for 
	{
		
		s opaId=$O(^DHCANOPArrange(0,"Adm",AEpisodeID,opaId)) 
		q:opaId=""
		q:$d(^DHCANOPArrange(opaId))<1
		//初始化数据
		s opdate="",oproomdes="",regno="",patname="",diag="",sex="",yy="",age="",opdes="",locdes="",opd="",mzdoc="",anmethod="",xsh="",xch="",OPCategory="",tAppCtcpDesc="",yg="",bg="",az="",md="",qt="",opdoc="",andoc="",FreezingSlice="",docNo="",technicalid="",technical="",asdocNo="",astechnicalid="",astechnical="",secastechnicalid="",secastechnical="",patStat="",patstatus="",BedId="",PAAdmBed="",visitstatus="",paweight="",address="",IsOrNotRelease="",pbrowid="",pbtype="",Chargestate="",xunhuino="",qixieno="",opstatus="N",xunhuino1="",xunhuino2="",locdesGroup="",eDeposit=""
		s andocNo="",operPosition="",opInterviewNur="",floorId=""
		//手术起始截止时间
		s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
		s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
		s openddate=$P(^DHCANOPArrange(opaId),"^",16)
		s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
		s opdatestr=$s(openddate'="":$ZD(opstdate,3)_" "_$zt(opsttime,2)_"~"_$zd(openddate,3)_" "_$zt(opendtime,2),1:$ZD(opstdate,3)_" "_$zt(opsttime,2))
		s tOpStartDate=$ZD(opstdate,4),tOpStartTime=$zt(opsttime,2) 
		s nurNotes=$g(^DHCANARRAGE("opreq",opaId))
		//是否非计划再次手术
		s opUnPlanedOperation=$P(^DHCANOPArrange(opaId),"^",46) //whl 20120518
		//
		s nurNotes=$g(^DHCANARRAGE("opreq",opaId))            //for xiehe zhangtao 2011
		//
		s FreezingSlice=$P(^DHCANOPArrange(opaId),"^",56)
		s opmem=$P(^DHCANOPArrange(opaId),"^",19) 
		
		s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)         //wkz 071225 S
		s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
		s OpAppDateStr=$zd($G(opAppdate),3)_"  "_$zt($G(opApptime),2)  
		//安排时间
		s arrTime=$P(^DHCANOPArrange(opaId),"^",8)
		s arrDate=$P(^DHCANOPArrange(opaId),"^",7)
		//手术时间如果手术安排时间不为空取手术安排时间，否则取手术起始时间
		i (arrTime'="")  {
			s opdate=$ZD(arrDate,3)_" "_$ZT(arrTime,2)
		}
		else{
			s opdate=$ZD(opstdate,3)_" "_$zt(opsttime,2)
		}
		//手术状态
		s Stat=$P(^DHCANOPArrange(opaId),"^",27)
		//手术状态转译
		i Stat="A" s status="申请"
		i Stat="R" s status="安排"
		i Stat="N" s status="非预约"
		i Stat="I" s status="术中"
		i Stat="P" s status="恢复室"
		i Stat="L" s status="术毕"
		i Stat="F" s status="完成"
		//非完成手术信息不取值
		continue:(Stat'="F")
		
		//手术间、手术间描述
		s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
		s:(oproomdr'="") oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		//手术间信息验证数据正确
		//q:(oproomdr'=oproom)&(oproomdes'="")&(Stat'="A")
		//手术见所在楼层
		s:(oproomdr'="") floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
		s:(floorId'="") oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
		
		//手术台次
		s opordno=$P(^DHCANOPArrange(opaId),"^",26)
		i (opordno'="")&(opordno=1) s opdate="8:30"
		s tmpDateStr=opordno
		i +tmpDateStr=0 {
			s tmpDateStr=""
		}
		else{
			s tmpDateStr=tmpDateStr-1
		}
		//验证admid
		//s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm
		//q:(admId'=EpisodeID)
		s admId=AEpisodeID
		s adm=AEpisodeID
		
		//s hz=$$getorderItemInfo(admId)
                s hz=""
		//支付状态
		s pbrowid=$O(^DHCPB(0,"ADM",adm,pbrowid))
		s:(pbrowid'="") pbtype=$p($g(^DHCPB(pbrowid)),"^",16)
		s Chargestate=$s(pbtype="P":"Y",1:"N")
		//图标
		s ico=""
		//s ico=##class(web.DHCANOPArrange).GetIco(admId)
		//床位信息
		s bedCode="",inPatNo="",admreason=""
		s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
		s paweight=""
		s paweight=##class(web.DHCSTPIVA).GetPatWeight(adm)
		//病区
		s curWardId=$p($g(^PAADM(adm)),"^",70)  
		s curWardId=$p($g(^PAADM(adm)),"^",70)  
		i curWardId'=""{
			s WardDes=$P(^PAWARD(curWardId),"^",1) 
			s address=$p($g(^CTLOC($P(^PAWARD(curWardId),"^",5))),"^",16)
		}
		i (bedSub'="")&(curWardId'="") s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
		s inPatNo=$p($g(^PAADM(adm)),"^",29)
		s admreasondr=$p($g(^PAADM(adm,1)),"^",7)
		i admreasondr'="" { s admreason=$p(^PAC("ADMREA",admreasondr),"^",2) }
		
		//抗原抗体
		s yg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",29)			//OPA_PATestHBsAg  	免疫乙肝表面抗原
		s bg=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",34)			//OPA_PATestHCVAb 	免疫丙型肝炎抗体
		s az=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",35)			//OPA_PATestHivAb 	免疫艾滋病毒抗体
		s md=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",36)			//OPA_PATestTPAb 	免疫梅毒
		s qt=$P($g(^DHCANOPArrange(opaId,"PALab")),"^",2)			//OPA_PATestOther	检其它阴阳性
		i yg="阳性" s yy="乙肝阳性"
		i bg="阳性" s yy=yy_"丙肝阳性"_" "
		i az="阳性" s yy=yy_"艾滋病阳性"_" "
		i md="阳性" s yy=yy_"梅毒阳性"_" "
		i qt="阳性" s yy=yy_"其他阳性"_" "
		
		s patStat=$P(^DHCANOPArrange(opaId),"^",23)
		
		i (Stat="D")&(patStat="") s status="拒绝",patstatus="手术室停手术"
		i (Stat="D")&(patStat="I") s status="撤销",patstatus="申请科室停手术"
		i (Stat="D")&(patStat="A") s status="拒绝",patstatus="麻醉科室停手术"
		
		
		s papmiId=$p($g(^PAADM(admId)),"^",1)
		s paadmtype=$p($g(^PAADM(admId)),"^",2)
		//手术申请者信息
		s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6)  //zt 2011.8.24
	    i appCtcpId'="" s tAppCtcpDesc=##class(web.DHCANOPCom).GetNameById(appCtcpId)
	    s ctcptId=$P($g(^CTPCP(appCtcpId,1)),"^",4)  //ADD MFC 20140106申请手术人员类型
	    s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
		//登记号
		s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		//病案号
		s medCareNo= ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(papmiId)
		//姓名
		s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		
		s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		s age=$$CalAge(birth,opstdate)
		s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
		s admLocId=$p($g(^PAADM(adm)),"^",4)
		i admLocId'="" s admLocdes=$P($g(^CTLOC(admLocId)),"^",2)  //Add mfc 20131217 病人所在科室
		i $l(admLocdes,"-")>1 s admLocdes=$p(admLocdes,"-",2)
		
		//add mfc 20140416急诊病人交押金
		i (paadmtype="E") s eDeposit=##class(web.DHCBillInterface).IGetStayBalance(admId)  
		s jz=$P(^OR(adm,"ANA",chl),"^",32)   						//ANA_SourceType 急诊(E)/择期(B)
		s jzstat=$s(jz="E":"急诊",jz="B":"择期",1:"超时")
		s mzdr=$P(^OR(adm,"ANA",chl),"^",6)        					//ANA_Anaesthetist_Dr 
		//麻醉医师
		s andoc=""
		i mzdr'="" {
			
			s andoc=##class(web.DHCANOPCom).GetNameById(mzdr)
			s andocNo=$tr($p($g(^CTPCP(+mzdr,1)),"^",1)," ","") 		//add mfc 20140520
		}
		s anDocNote=$P(^DHCANOPArrange(opaId),"^",43)
		s opEndDate=$P($g(^OR(adm,"ANA",chl)),"^",41)  //手术结束日期
		s opEndTime=$P($g(^OR(adm,"ANA",chl)),"^",42)  //手术结束时间
		i opEndDate'=""  s opEndDate=$ZD(opEndDate,3)
		i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
		s openddatestr=opEndDate_" "_opEndTime
		s operShiJi=$p($g(^DHCANOPArrange(opaId,"Ext")),"^",30) //实际手术名称
		s operOptionDesc=""
		s operNote=$p(operShiJi,"!",1)
		s operOptionList=$p(operShiJi,"!",2)	
		f i=1:1:$l(operOptionList,"@") 
		{
			s operOption=$p(operOptionList,"@",i)
			s operOptionId=$p(operOption,"|",1)
			i operOptionDesc="" {
				s operOptionDesc=$p(operOption,"|",2)
			}
			else  {
				s operOptionDesc=operOptionDesc_";"_$p(operOption,"|",2)
			}
			s:(operNote="") operShiJi=operOptionDesc
			s:(operNote'="") operShiJi=operNote_";"_operOptionDesc
		}
		s mzsupdoc=""
		s mzsupdr=$P(^OR(adm,"ANA",chl),"^",7)        				;ANA_Supervisor_DR ///ck091203  
		s:(mzsupdr'="") mzdoc=##class(web.DHCANOPCom).GetNameById(mzsupdr)
		
		s anDocAss=""
		s ass=0,surgeonDesc=""
		f  {
			s ass=$o(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)) 
			q:ass=""  
			//麻醉助手
			s mzzsdr=$p($g(^OR(adm,"ANA",chl,"OP",1,"ANASS",ass)),"^",1)
			q:mzzsdr=""
			i anDocAss="" {
				s anDocAss=##class(web.DHCANOPCom).GetNameById(mzzsdr)
			}
			else {
				s anDocAss=anDocAss_" "_##class(web.DHCANOPCom).GetNameById(mzzsdr)
			}
		}
		s:(anDocAss'="") mzdoc=mzdoc_","_anDocAss
		
		//麻醉护士
		s anNurse=""
		s mzNurseId=$P(^OR(adm,"ANA",chl),"^",8)
		s:(mzNurseId'="") anNurse=##class(web.DHCANOPCom).GetNameById(mzNurseId)
		
		//ASA分级
		s ASA=""
	    s ASAId=$P(^OR(adm,"ANA",chl),"^",26)
		s:(ASAId'="") ASA=$P(^ORC("ASA",ASAId),"^",2)
		//ANA_Method	 麻醉方法
		s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)						
		s anmethod=""
		i anmthdr'=""{
			s anmetNum=$l(anmthdr,"|")
			f i=1:1:anmetNum {
				s anmetId=$p(anmthdr,"|",i)
				q:anmetId=""
				s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
				i $P(anmetDesc,"-",2)'="" {s anmetDesc=$P(anmetDesc,"-",2)}
				i anmethod="" {s anmethod=anmetDesc}
				else  {s anmethod=anmethod_","_anmetDesc}
			}
		}
		////+ wxl 090316 合并疾病
		s anCompDesc=""                                        		
		s subchl=0 
		f  {
			s subchl=$O(^OR(adm,"ANA",chl,"COMP",subchl)) 
			q:(subchl="")
			s AnCompDr=$P(^OR(adm,"ANA",chl,"COMP",subchl),"^",1)
			q:AnCompDr=""
			i anCompDesc="" {
				s anCompDesc=$P(^ORC("COMP",AnCompDr),"^",2)
			}
			else  {
				s anCompDesc=anCompDesc_","_$P(^ORC("COMP",AnCompDr),"^",2)
			}
		}		
		s i=0
		s prediag="",diamen="",opdr=""
		s subchl=0 
		f {
			s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) 
			q:(subchl="")
			//ANAOP_Type_DR     ；手术名称
			s opdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",6)       		
			i opdr'=""
			{
				i $P($g(^ORC("OPER",+opdr)),"^",2)'="" 
				{
					i opdes'="" 
					{	
						s opdes=opdes_";" 	 
					}
					s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2) 
				}
			}
			else
			{
				i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'=""
				{
					
					i opdes'="" 
					{
						s opdes=opdes_";"		
					}
					s opdes=opdes_$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))    ///ck091210
				}
			}
			s i=i+1
			q:i>1   ///ck091117
			s sub=subchl
		
			//手术部位
			s bodsIdList=$P(^OR(adm,"ANA",chl,"OP",sub),"^",24) 	 //ypz 070418 	手术部位
		    s bodsList="",bodsDesc=""
	  
		    i bodsIdList'=""
			{
				s bodsIdNum=$l(bodsIdList,"|")
				f j=1:1:bodsIdNum
				{
					s bodsId=$p(bodsIdList,"|",j)
					q:bodsId=""
					s bodsDesc2=$p($g(^OEC("BODS",+bodsId)),"^",2)
					i bodsDesc="" { 
						s bodsDesc=bodsDesc2 
					}
					else {
						 s bodsDesc=bodsDesc_"|"_bodsDesc2 
					}
				}
			}
			//ANAOP_Surgeon_DR   手术医师
			s docdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",8)      		
			s docNo=$tr($p($g(^CTPCP(+docdr,1)),"^",1)," ","")            ;手术医师工号
			s opd=""
			s technicalid=$p($g(^CTPCP(+docdr,1)),"^",10)
			i technicalid'="" s technical=$p($g(^CT("SPC",technicalid)),"^",2) ;术者职称
			i docdr'="" 
			{
				s opdoc=##class(web.DHCANOPCom).GetNameById(docdr)
			}
			else  
			{
				s opdoc=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //CK 091210 手术医生备注(外来手术医生)
			}
			s surgeonDesc=opdoc 
			//ANAOP_PreopDiag_DR 术前诊断  
			s predigdr=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",4)   		
			i predigdr'=""{
				s prediag=$P(^MRC("ID",predigdr),"^",2)
				s diag=$G(prediag)
			}
			else	
			{
				i $g(^OR(adm,"ANA",chl,"TXT",2))'="" 
				{
					s diamen=^OR(adm,"ANA",chl,"TXT",2)  	//ck091210 麻醉表存放诊断备注ANA_Notes
					s diag=$G(diamen)
				}
			}
			s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) 		;ANAOP_CTLOC_DR
			i operLocId'="" 
			{
				s shoushujian=$p(^CTLOC(operLocId),"^",2)
			}
		}
		s ash=""
		s assDocNum=10 //最多显示的助手人数
		i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)'="" 
		{
			s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
		}
		s p=0,list=0,asName=""
		//手动填写OPA_OpDocNote（实习医生1;实习医生2...|主刀|一助|二助|三助|四助|五助...）
		s opaDocNote=$P(^DHCANOPArrange(opaId),"^",42) 
		s len=$l(opaDocNote,"|")
		
		s as=0 
		f  {
			s as=$O(^OR(adm,"ANA",chl,"OP",sub,"ASS",as)) 
			q:(as="")!(p'<assDocNum)
			s asdr=$P(^OR(adm,"ANA",chl,"OP",sub,"ASS",as),"^",1)
			s p=p+1
			q:asdr=""
			s asName=asName_"^"_##class(web.DHCANOPCom).GetNameById(asdr)_","
			//一助工号
			i (p=1) {
				s asdocNo=$tr($p($g(^CTPCP(+asdr,1)),"^",1)," ","")            
				s astechnicalid=$p($g(^CTPCP(+asdr,1)),"^",10)
				// 一助职称
				s:((astechnicalid'="")&(astechnical="")) astechnical=$p($g(^CT("SPC",astechnicalid)),"^",2)
			}
			i (p=2) {
				s secasdocNo=$tr($p($g(^CTPCP(+asdr,1)),"^",1)," ","")            
				s secastechnicalid=$p($g(^CTPCP(+asdr,1)),"^",10)
				// 一助职称
				s:((secastechnicalid'="")&(secastechnical="")) secastechnical=$p($g(^CT("SPC",astechnicalid)),"^",2)
			}
		}
		s:(len>assDocNum+2) len=assDocNum+2
		
		f getLen=3:1:len
		{
			i $p(opaDocNote,"|",getLen)'=""
			{
				s getName=$p(opaDocNote,"|",getLen)
			}
			else{
				s list=list+1
				s getName=$p(asName,"^",list+1)
			}
			s ash=ash_""_getName
		}
			//洗手
		s p=0,xs=0 
		f  {
			s xs=$O(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs)) 
			q:(xs="")!(p=3)
			q:xs>20
			s xsdr=$P(^OR(adm,"ANA",chl,"OP",sub,"SCN",xs),"^",1)
			q:xsdr=""
			s p=p+1
			s xsh=xsh_" "_##class(web.DHCANOPCom).GetNameById(xsdr)
			s qixie=$tr($p($g(^CTPCP(+xsdr,1)),"^",1)," ","")
			q:qixie=""
			//add mfc 20140416 获取多的器械护士工号
			i qixieno="" 
			{
				s qixieno=qixie      
			}
			else
			{
				s qixieno=qixieno_" "_qixie
			}
		}
		//巡回
		s p=0,xc=0 			
		f
		{
			s xc=$O(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc)) 
			q:(xc="")!(p=3)
			q:xc>20
			s xchdr=$P(^OR(adm,"ANA",chl,"OP",sub,"CIRN",xc),"^",1)
			q:xchdr=""
			q:$tr($p($g(^CTPCP(+xchdr,1)),"^",1)," ","")=""
			s xunhui=$tr($p($g(^CTPCP(+xchdr,1)),"^",1)," ","")
			q:xunhui=""
			i xunhuino="" 
			{
				s xunhuino=xunhui      //add mfc 20140416 获取多的巡回护士工号
			}
			else  
			{
				s xunhuino=$G(xunhuino)_" "_xunhui
			}
			s p=p+1	
			s xch=$G(xch)_" "_##class(web.DHCANOPCom).GetNameById(xchdr)
		}		
		s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)		//OPA_ScrubNurseNote	器械护士备注 	
		s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)		//OPA_CirculNurseNote	巡回护士备注
		s j=j+1
		s opd=opd_","_$G(ash)
		
		s sortOpRoomDesc=oproomdes
		s:(oproomdes="") oproomdes="无"
		s sortOpaSeq=opordno
		s:(opordno="") opordno="未排" ;Do OutRow2
		s NeedAnaesthetist=$p($G(^DHCANOPArrange(opaId)),"^",44)
		
		s oprFloor=""
		s operInstrumentId=$P(^DHCANOPArrange(opaId),"^",30)
		s operInstrument=""
		s:(operInstrumentId'="") operInstrument=$P($G(^DHCANC("Instrument",operInstrumentId)),"^",2)
		
		s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
		s anaId=$P(^DHCANOPArrange(opaId),"^",2)
		//s opstatus=$$getOpPayStatus(anaId)
                s opstatus=""
		s anaSub=$P(anaId,"||",2)
		s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",1,"POS",1)),"^")
		i (operPositionId'=""){
			s operPositionIdNum=$l(operPositionId,"|")	
			f j=1:1:operPositionIdNum {
				s oposId=$p(operPositionId,"|",j)
				q:oposId=""
				s oposDesc=$p(^ORC("OPPOS",+oposId),"^",2)
				i operPosition="" { s operPosition=oposDesc }
				else{  s operPosition=operPosition_" "_oposDesc}
			}			
		}
		s OPCategory="",OPCategoryId=""
		s:(opdr'="") OPCategoryId=$p($g(^ORC("OPER",opdr)),"^",7) 
		s:(OPCategoryId'="") OPCategory=$p($g(^ORC("CATEG",OPCategoryId)),"^",2)
		s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)
		s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30)
		s instrument=""
		s:(instrumentDr'="") instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)
		s patWardId1=$P($G(^DHCANOPArrange(opaId)),"^",32)
		
		//初始化患者病区
		s patWard=""
		i patWardId1'="" {
			s patWard=$P($G(^PAWARD(patWardId1)),"^",2) 
			s address=$p($g(^CTLOC($P(^PAWARD(patWardId1),"^",5))),"^",16)
		}
		s:(patWard["-") patWard=$p(patWard,"-",2)
		//患者状态
		s visitstatus=$P($g(^PAADM(adm)),"^",20)
		//状态转换
		s visitstatustemp=visitstatus
		i (visitstatustemp="A")&&(paadmtype'="O") s visitstatus="住院"
		i (visitstatustemp="P") s visitstatus="预约"
		i (visitstatustemp="A")&&(paadmtype="O") s visitstatus="门诊"
		i (visitstatustemp="A")&&(paadmtype="E") s visitstatus="急诊"
		i (visitstatustemp="D") s visitstatus="已出院"
		i (visitstatustemp="C") s visitstatus="撤销"
		//患者床号
		s BedId=$P($g(^PAADM(adm)),"^",73)
	    s:(BedId'="") PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
		//病床地址
	    s:(address'["层") address=address_"层"
	    s address=patWard_"/"_address_"/"_PAAdmBed_"床"
		
		s estiOperDuration=$P($G(^DHCANOPArrange(opaId)),"^",37)
		s:(estiOperDuration'="") estiOperDuration=$ZT(estiOperDuration,2)
		s preDiscussDate=$P($G(^DHCANOPArrange(opaId)),"^",38)
		s preDiscussDate=$ZD(preDiscussDate,4)
		s isExCirculation=$P($G(^DHCANOPArrange(opaId)),"^",36)
		//血型
		s bloodType="不详"
		s bloodTypId=$P(^DHCANOPArrange(opaId),"^",11)
		s:((+bloodTypId'=0)&($d(^PAC("BLDT",+bloodTypId)))) bloodType=$P($G(^PAC("BLDT",bloodTypId)),"^",2)
		
		s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
		s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
		s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)
		s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
		s retReasonId=$P($G(^DHCANOPArrange(opaId)),"^",35)
		i Stat'="D"	s retReasonId=""   ;20120604+dyl
		i retReasonId'=""  s retReason=$p(^ORC("SUSP",retReasonId),"^",2)   //+ ck091212 手术拒绝原因
		e  s retReason=""
		s anaDoctorOrd=$p($G(^DHCANOPArrange(opaId)),"^",48)     	//+ ck091212 麻醉医生收费状态
		i anaDoctorOrd="Y"  s anaDoctorOrd="Y"
		e  s anaDoctorOrd="N"
		
		s anaNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",49)      	//+ ck091212 麻醉护士收费状态
		i anaNurseOrd="Y"  s anaNurseOrd="Y"
		e  s anaNurseOrd="N"
		
		s opNurseOrd=$p($G(^DHCANOPArrange(opaId)),"^",50)       	//+ ck091212 手术护士收费状态
		i opNurseOrd="Y"  s opNurseOrd="Y"
		e  s opNurseOrd="N"
		
		s tPacuBedId=$P($G(^DHCANOPArrange(opaId)),"^",47)		 	//OPA_PacuBed_Dr	麻醉恢复床
		i tPacuBedId'="" s tPacuBed=$p(^DHCANC("OPRoom",tPacuBedId),"^",2)
		e  s tPacuBed=""
		s PACUInDate=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",6) 	//OPA_PACUInDate	入恢复室日期
		i PACUInDate'="" s PACUInDate=$zd(PACUInDate,3)
		s PACUInTime=$P($G(^DHCANOPArrange(opaId,"PACU")),"^",7) 	//OPA_PACUInTime	入恢复室时间
		i PACUInTime'="" s PACUInTime=$zt(PACUInTime)
		s PACUInDateTime=PACUInDate_" "_PACUInTime
		i sortOpRoomDesc="" s sortOpRoomDesc=0
		i sortOpaSeq<10 s sortOpaSeq=0_sortOpaSeq
		s opaSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41)	//OPA_SeqNote
		s appLocId=$P($G(^DHCANOPArrange(opaId)),"^",54)	//OPA_AppLoc_Dr
		s appLocDesc=$P($G(^CTLOC(+appLocId)),"^",2)
		s tDocArriveTime=$P(^DHCANOPArrange(opaId),"^",46)
		s opname=opdes
		i tDocArriveTime'="" s tDocArriveTime=##class(web.DHCANOPCom).ConvertToTime(tDocArriveTime)
		i ash'="" s opdoc=opdoc_","_ash
		s:(scNurNote'="") xsh=xsh_","_scNurNote
		s:(cirNurNote'="") xch=xch_","_cirNurNote
		s statusFlag=0				
		i status="拒绝" s statusFlag=4		
		e  i (opSeqNote["非手术日")&(status'="安排") s statusFlag=1
		e  i (status="安排") s statusFlag=3
		e  i (status="申请") s statusFlag=1
		e  i (status="完成") s statusFlag=2
		e  s statusFlag=1
		s antUsePurpose=""
		//s opInterviewNur=##class(Nur.DHCMoudData).GetVisitUser("DHCNURXH_SQSHFSD",opaId) //Add mfc 20140523术前访视护士(护士站接口)
		s opInterviewNur=""
		//w !,status,jzstat,opdate,oproomdes,opordno,regno,patname,sex,age,opname,opdes,diag,opd,opdoc,locdes,anmethod,andoc,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,AnaesthesiaID,operPosition,OPCategory,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,tDocArriveTime,tOpStartDate,tOpStartTime,tAppCtcpDesc,nurNotes,mzdr,bodsDesc,yg,bg,az,md,qt,ASA,opUnPlanedOperation,FreezingSlice,ash,technical,docNo,astechnical,asdocNo,patstatus,ico,hz,visitstatus,paweight,address,IsOrNotRelease,Chargestate,qixieno,xunhuino,opstatus,shoushujian,paadmtype,admLocdes,openddatestr,operShiJi,xunhuino1,xunhuino2,locdesGroup,eDeposit,antUsePurpose,andocNo,opInterviewNur
		
		//w !,status_"|"_jzstat_"|"_opdate_"|"_oproomdes_"|"_opordno_"|"_regno_"|"_patname_"|"_sex_"|"_age_"|"_opname_"|"_opdes_"|"_diag_"|"_opd_"|"_opdoc_"|"_locdes_"|"_anmethod_"|"_andoc_"|"_mzdoc_"|"_xsh_"|"_xch_"|"_yy_"|"_opaId_"|"_adm_"|"_opdatestr_"|"_OpAppDateStr_"|"_opmem_"|"_isAddInstrument_"|"_instrument_"|"_patWard_"|"_anNurse_"|"_medCareNo_"|"_oproomdr_"|"_oprFloor_"|"_estiOperDuration_"|"_preDiscussDate_"|"_isExCirculation_"|"_bloodType_"|"_opDocNote_"|"_anDocNote_"|"_opSeqNote_"|"_AnaesthesiaID_"|"_operPosition_"|"_OPCategory_"|"_opsttime_"|"_mzsupdoc_"|"_retReason_"|"_anaDoctorOrd_"|"_anaNurseOrd_"|"_opNurseOrd_"|"_inPatNo_"|"_admreason_"|"_tPacuBed_"|"_PACUInDateTime_"|"_scNurNote_"|"_cirNurNote_"|"_anDocAss_"|"_bedCode_"|"_tDocArriveTime_"|"_tOpStartDate_"|"_tOpStartTime_"|"_tAppCtcpDesc_"|"_nurNotes_"|"_mzdr_"|"_bodsDesc_"|"_yg_"|"_bg_"|"_az_"|"_md_"|"_qt_"|"_ASA_"|"_opUnPlanedOperation_"|"_FreezingSlice_"|"_ash_"|"_technical_"|"_docNo_"|"_astechnical_"|"_asdocNo_"|"_patstatus_"|"_ico_"|"_hz_"|"_visitstatus_"|"_paweight_"|"_address_"|"_IsOrNotRelease_"|"_Chargestate_"|"_qixieno_"|"_xunhuino_"|"_opstatus_"|"_shoushujian_"|"_paadmtype_"|"_admLocdes_"|"_openddatestr_"|"_operShiJi_"|"_xunhuino1_"|"_xunhuino2_"|"_locdesGroup_"|"_eDeposit_"|"_antUsePurpose_"|"_andocNo_"|"_opInterviewNur
		d OutputRow
	}
	Quit $$$OK
	
	
OutputRow
     Set Data=$lb(status,jzstat,opdate,oproomdes,opordno,regno,patname,sex,age,opname,opdes,opdr,diag,opd,opdoc,locdes,anmethod,andoc,mzdoc,xsh,xch,yy,opaId,adm,opdatestr,OpAppDateStr,opmem,isAddInstrument,instrument,patWard,anNurse,medCareNo,oproomdr,oprFloor,estiOperDuration,preDiscussDate,isExCirculation,bloodType,opDocNote,anDocNote,opSeqNote,AnaesthesiaID,operPosition,OPCategory,opsttime,mzsupdoc,retReason,anaDoctorOrd,anaNurseOrd,opNurseOrd,inPatNo,admreason,tPacuBed,PACUInDateTime,scNurNote,cirNurNote,anDocAss,bedCode,tDocArriveTime,tOpStartDate,tOpStartTime,tAppCtcpDesc,nurNotes,mzdr,bodsDesc,yg,bg,az,md,qt,ASA,opUnPlanedOperation,FreezingSlice,ash,technical,docNo,astechnical,asdocNo,secastechnical,secasdocNo,patstatus,ico,hz,visitstatus,paweight,address,IsOrNotRelease,Chargestate,qixieno,xunhuino,opstatus,shoushujian,paadmtype,admLocdes,openddatestr,operShiJi,xunhuino1,xunhuino2,locdesGroup,eDeposit,antUsePurpose,andocNo,opInterviewNur)
     Set ^CacheTemp(repid,ind)=Data
     Set ind=ind+1
     Quit
CalAge(IBirth,IToday )
	s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0 s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	q reage

getOpPayStatus(mazuiid)
	s ret="N"
    s count=0
	s oeoriSub=""
	s anaId=mazuiid
	s oeordId=""
	f  s oeordId = $o(^OEORDi(0,"Ana",anaId,oeordId)) q:oeordId=""  d
	.f  s oeoriSub = $o(^OEORDi(0,"Ana",anaId,oeordId, oeoriSub)) q:oeoriSub=""  d
	..//s ordStatCode=##Class(web.DHCANOPCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	..s ordStatCode=""
	
	..q:((ordStatCode'="E") && (ordStatCode'="V"))
	..s count=count+1
	i count>0 s ret="Y"
    q ret
getorderItemInfo(admid)
	s oeordId="",arcimrowid="" ,oeoristtdate="",oeorisub="",flag="N"
	f  {
		s oeordId=$o(^OEORD(0,"Adm",admid,oeordId)) 
		q:oeordId=""
		
		f  {
			s arcimrowid=$o(^OEORDi(0,"ARCIM",oeordId,arcimrowid)) 
			q:arcimrowid=""
			
			//s ordStatCode=##Class(web.DHCANOPCom).GetOrdStatCode(arcimrowid)
			s ordStatCode=""
			q:((ordStatCode'="E") && (ordStatCode'="V")&&arcimrowid'="26521||1")
			s sttDate=$p($g(^OEORD($p(oeordId,"||",1),"I",oeoriSub,$p(oeordId,"||",1))),"^",9) //keep duplicate
			s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
			s flag="Y"_sttDate_sttTime
		}
	}	
    q flag
}

ClassMethod GetPatOperInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatOperInfoExecute ]
{
	 Set repid=$LIST(qHandle,2)
     Kill ^CacheTemp(repid)     
     Quit $$$OK
}

ClassMethod GetPatOperInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatOperInfoExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
     Set repid=$LIST(qHandle,2)
     Set ind=$LIST(qHandle,3)
     Set ind=$o(^CacheTemp(repid,ind))
     If ind="" {                    // if there are no more rows, finish fetching
          Set AtEnd=1
          Set Row=""
     }
     Else      {                    // fetch row
          Set Row=^CacheTemp(repid,ind)
     }
     // Save QHandle
     s qHandle=$lb(AtEnd,repid,ind)
     Quit $$$OK
}

/// Desc： 对照 协和付款方式 为 卫生局付款方式
/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).ConvertPayMode("本院离休")
ClassMethod ConvertPayMode(argPayMode As %String)
{
	s TransPayMode=""
	s:((argPayMode="本院在职")||(argPayMode="本院退休")||(argPayMode="本院特殊")||(argPayMode="本院特殊2(在职)")||(argPayMode="本院特殊2(退休)")||(argPayMode="公费记账")||(argPayMode="本院在职(住院)")||(argPayMode="本院退休(住院)")||(argPayMode="本院特殊2(退休住院)")||(argPayMode="合同单位")||(argPayMode="本院公费(住院)")||(argPayMode="合同单位(住院)")||(argPayMode="特发事件")||(argPayMode="贫困救助")||(argPayMode="普通卫干")) TransPayMode="其他"
	s:((argPayMode="本院离休")||(argPayMode="正部级干部")||(argPayMode="本院医照")||(argPayMode="北京医保公疗医照")||(argPayMode="副部级干部")||(argPayMode="本院离休(住院)")||(argPayMode="副部级(合同)")||(argPayMode="正部级(合同)")||(argPayMode="副部级(非合同)")||(argPayMode="外国专家副部级(住院)")||(argPayMode="正部级(非合同)")||(argPayMode="外国专家副部级")||(argPayMode="京外医保")||(argPayMode="北京城镇医保")||(argPayMode="北京医保退休")) TransPayMode="城镇职工基本医疗保险"
	s:((argPayMode="北京医保特病")||(argPayMode="北京医保")||(argPayMode="北京医保在职")||(argPayMode="北京医保工伤")||(argPayMode="北京医保离休")||(argPayMode="北京医保非红名单")||(argPayMode="北京医保(本院)")||(argPayMode="北京医保公疗医照(本院)")||(argPayMode="北京医保公疗医照(副部级)")||(argPayMode="北京医保公疗医照(本院院士)")) TransPayMode="城镇职工基本医疗保险"
	s:((argPayMode="北京医保老人")||(argPayMode="北京医保学生儿童")||(argPayMode="北京医保大学管理")||(argPayMode="北京医保无业居民")) TransPayMode="城镇居民基本医疗保险"
	s:((argPayMode="公费")||(argPayMode="本院现金结算")||(argPayMode="本院现金结算(住院)")||(argPayMode="科研用药")||(argPayMode="平价普通病人")||(argPayMode="国际医疗部普通病人")||(argPayMode="自费")||(argPayMode="医科院职工")||(argPayMode="医科院学生")||(argPayMode="特需收费")) TransPayMode="全自费"
	s:(argPayMode="外国专家特需病人") TransPayMode="全公费"
	s:(argPayMode="新农合") TransPayMode="新型农村合作医疗"
	s:((argPayMode="商业保险(签约)")||(argPayMode="商业保险(非签约)")||(argPayMode="商业保险")||(argPayMode="签约企业(药费自付)")) TransPayMode="其他社会保险"
	
	q TransPayMode
}

/// Creator:	add by YHY / modi by guozongtao
/// CreatDate:	20150504
/// Description:对照 协和付款方式 为首页中“医疗付费方式”
/// Table:		/
/// Input:		argAdm 就诊号
/// Output:		Code^Desc
/// Others:				
/// Debug:	    w ##class(EMR.DOC.HISInterface.PatientInfoAssist).ConvertPayType("本院离休")
ClassMethod ConvertPayType(argPayMode As %String)
{
	s TransPayType=""
	s:((argPayMode="京外医保")||(argPayMode="北京医保特病")||(argPayMode="副部级干部")||(argPayMode="北京医保公疗医照")||(argPayMode="外国专家特需病人")||(argPayMode="担保个人")||(argPayMode="特发事件")||(argPayMode="担保部门")||(argPayMode="副部级(非合同)")||(argPayMode="副部级(合同)")) TransPayType="9^其他"
	s:((argPayMode="北京医保离休")||(argPayMode="北京医保退休")||(argPayMode="北京医保在职")||(argPayMode="北京医保(超转)")) TransPayType="1^城镇职工基本医疗保险"
	s:((argPayMode="北京城镇医保")||(argPayMode="北京医保老人")||(argPayMode="北京医保学生儿童")||(argPayMode="北京医保无业居民")) TransPayType="2^城镇居民基本医疗保险"
	s:((argPayMode="自费")||(argPayMode="本院现金结算")||(argPayMode="特需收费")||(argPayMode="北京医保非红名单")) TransPayType="7^全自费"
	s:(argPayMode="公费"||(argPayMode="正部级干部")||(argPayMode="本院医照")||(argPayMode="本院在职")||(argPayMode="本院退休")||(argPayMode="本院离休")||(argPayMode="本院特殊")||(argPayMode="本院特殊2（在职）")||(argPayMode="本院特殊2（退休）")||(argPayMode="合同单位")||(argPayMode="医科院职工")||(argPayMode="医科院学生")||(argPayMode="正部级(合同)")||(argPayMode="正部级(非合同)")) TransPayType="6^全公费"
	s:(argPayMode="新农合") TransPayType="3^新型农村合作医疗"
	s:((argPayMode="北京工伤")) TransPayType="8^其他社会保险"
	s:((argPayMode="贫困救助")) TransPayType="4^贫困救助"
	s:((argPayMode="商业保险")||(argPayMode="签约企业(药费自付)")||(argPayMode="签约商业保险（记账）")) TransPayType="5^商业医疗保险"
	q TransPayType
}

/// Creator:	guozongtao
/// CreatDate:	20150504
/// Description:取患者本次住院的住院证上的门诊诊断信息
/// Table:		DHCDocIPBooking 住院证表 
/// Input:		argAdm 就诊号
/// Output:		RowID^Code^Desc
/// Others:				
/// Debug:	    w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetIPBookDiagDict(50352)
ClassMethod GetIPBookDiagDict(argAdm As %String) As %String
{
	q:argAdm=""
	
	s BookID=$o(^DHCDocIPBK(0, "EpisodeIDTo", argAdm, ""),-1)
	q:BookID="" ""_"^"_""_"^"_""
	s IPBookData = $g(^DHCDocIPBK(+BookID))
	s MRCICDDxID=$p(IPBookData,"^",14)
	//q:MRCICDDxID="" ""_"^"_""_"^"_""
	
	if (MRCICDDxID="")
	{ 
		//新版住院证存储ICDList 取第一个诊断ID
		s ICDList = $p(IPBookData,"^",24)
		q:ICDList="" ""_"^"_""_"^"_""
		
		s MRCICDDxID=$p(ICDList,$c(2,2),1)
		
	}
	
	s str=$g(^MRC("ID",MRCICDDxID))
	s Desc=$p(str,"^",2)
	s Code=$p(str,"^",4)
	q MRCICDDxID_"^"_Code_"^"_Desc
}

/// Creator:	guozongtao
/// CreatDate:	20150504
/// Description:获取患者出院状态，如果是死亡,病案首页的【离院方式】绑定值是：5^死亡
/// Table:		/
/// Input:		/
/// Output:		Code^Desc
/// Others:				
/// Debug:	    w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetDisModeMono(1567704)
ClassMethod GetDisModeMono(argAdmId As %String) As %String
{
	s ReturnValue=""
	
	s PapmiDR = $P($g(^PAADM(argAdmId)),"^",1)
	q:(PapmiDR="") ""_"^"_""
		
	s deathdate="",deathtime=""
	s deathdate=$p(^PAPER(PapmiDR,"ALL"),"^",13)
	s deathtime=$p(^PAPER(PapmiDR,"ALL"),"^",8)
	i ((deathdate'="")&&(deathtime'=""))
	{
		s ReturnValue="5^死亡"
	}
	else
	{
		s ReturnValue=""_"^"_""
	}
	q ReturnValue
}

/// Creator:	guozongtao
/// CreatDate:	20150504
/// Description:获取患者病危病重情况，如果医嘱中包含病危、病重医嘱,病案首页的【急危重病例】绑定值是：1^是，否则是：2^否
/// Table:		/
/// Input:		/
/// Output:		Code^Desc
/// Others:		医嘱项：20124||1\20125||1\20126||1\20127||1		
/// Debug:	    w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetCriticallyMono(1567704)
ClassMethod GetCriticallyMono(argAdmId As %String) As %String
{
	s ReturnValue=""
	q:(argAdmId="") "2^否"
	
	s count=0
	s strMethodQuery = "EMRservice.HISInterface.OEOrdInfo||QueryOrderItem"
	s methodQuery = ##Class(EMR.DOC.COM.ClassDefine).CheckQueryExist(strMethodQuery)
	q:(methodQuery="0") "2^否"
	s rs = ##class(%ResultSet).%New("EMRservice.HISInterface.OEOrdInfo:QueryOrderItem")
	s sc = rs.Execute(argAdmId,"20124||1\20125||1\20126||1\20127||1","","Y")
	q:(sc'=1) ""
	
	while (rs.Next())
	{
		s count=count+1
	}
	
	i (+count>0)
	{
		s ReturnValue="1^是"
	}
	else
	{
		s ReturnValue="2^否"
	}

	q ReturnValue
}

/// lfb 20150605
/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetAllInstanceTitles(10462548)
ClassMethod GetAllInstanceTitles(AEpisodeID As %String) As %String
{
	s tmpdate=0,TitleStr=""
	/*
	for 
	{
		s tmpdate=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",tmpdate))
		
		q:tmpdate=""
		s tmptime=""
		for{
			
			s tmptime=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",tmpdate,tmptime))
			q:tmptime=""
			s tmpecrecordID=""
			for{
				s tmpecrecordID=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",tmpdate,tmptime,tmpecrecordID))
				q:tmpecrecordID=""
				s tmpnum=""
				for{
					s tmpnum=$o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime"," "_AEpisodeID," SAVE",tmpdate,tmptime,tmpecrecordID,tmpnum))
					q:tmpnum=""
					
					s InstanceID=tmpecrecordID_"||"_tmpnum
					
					s objIntData=##class(EMRinstance.InstanceData).%OpenId(InstanceID)
					continue:(objIntData="")
					s TitleStr=TitleStr_"^"_objIntData.Title
					d objIntData.%Close()
					s objIntData=""
				
				}
			}
		
		
		}
	}
	*/
	q TitleStr
}

/// Desc:	转科ICU明细
/// Output:	w ##class(EMR.DOC.HISInterface.PatientInfoAssist).TransDeptDetailInCludeICU("9480010")
ClassMethod TransDeptDetailInCludeICU(argAdmId As %String, argHospital As %String = "") As %String
{
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transInfo="",transICUDept="",transWardDesc="",nextTransWard="",beforeTransWard=""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transInfo= ..GettransDeptInfos(argAdmId,childSub)
		continue:(transInfo="")
		s transWardDesc=$p(transInfo,"^",2)
		continue:(transWardDesc=beforeTransWard)
		s beforeTransWard=transWardDesc
		s i=0,newsub="",nextTransWard=""
		if (transWardDesc["ICU")||(transWardDesc["CCU")||(transWardDesc["重症医学科")
		{
			
			s newsub=childSub
			for{
				
				s newsub=$o(^PAADM(argAdmId,"TRANS",newsub))
				q:(newsub="")
				
				s nextTransWard=..GettransDeptInfos(argAdmId,newsub)
				
				continue:(nextTransWard="")
				
				s nextTransWardDesc=$p(nextTransWard,"^",2)
				q:(nextTransWardDesc'=beforeTransWard)
				
				
			}
			
			s transICUDept=transICUDept_transInfo_"^"_$p(nextTransWard,"^",3)_"^"_$p(nextTransWard,"^",4)
			s transICUDept = transICUDept_"->"
		}
		
		
	}
	
	if transICUDept'=""
	{
		s transICUDept=$e(transICUDept,1,*-2)
		
	}
		
	q transICUDept
}

ClassMethod GettransDeptInfos(admid As %String, numid As %String) As %String
{
		s (transGlobal,TRANSTYPCode,TRANSTYPDesc,TarDR,WARDDR,WARDDesc,startDate,startTime,transWardInfo)=""
		s transGlobal=^PAADM(admid,"TRANS",numid)
    	s TarDR= $p(transGlobal,"^",21)
		s:TarDR'="" TRANSTYPCode=$p(^PAC("TRANSTYP",TarDR),"^",1)
		
		s:TarDR'="" TRANSTYPDesc=$p(^PAC("TRANSTYP",TarDR),"^",2)
		q:TRANSTYPCode="T" "" //Transfer  Move "" 
		
		s WARDDR = $p(transGlobal,"^",9)
    	s:WARDDR'="" WARDDesc=$p(^PAWARD(WARDDR),"^",2)
		
		s startDate = $p($g(transGlobal),"^",1)
		s startTime = $p($g(transGlobal),"^",2)
		
		
		
		if $l(WARDDesc,"-")>1 {s WARDDesc=$p(WARDDesc,"-",2)}
		
		
		s transWardInfo = WARDDR_"^"_WARDDesc_"^"_$zd(startDate,3)_"^"_$zt(startTime)
		
		q transWardInfo
}

/// debugger:w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetWSCodeDict("1^09^男","GB/T 2261.1")
ClassMethod GetWSCodeDict(AsourceDict As %String, ADECVMID As %String) As %String
{
	q:(AsourceDict="")||(ADECVMID="") AsourceDict
	s targetDict=""
	s tmpDEVID="",tmpID="",tmpMeaning=""
	s sourceDesc=$p(AsourceDict,"^",3)
	&sql(SELECT ID,DEVID,Meaning into :tmpID,:tmpDEVID,:tmpMeaning FROM EPRmeta.DataElementValues WHERE DECVMID=:ADECVMID and Meaning like "%"_:sourceDesc_"%")
    
	s targetDict=tmpID_"^"_tmpDEVID_"^"_tmpMeaning
	q:(targetDict="^^") AsourceDict
	q targetDict
}

/// ///////////////////////////////////////////////////////////
/// 生命体征取值 Start
/// ///////////////////////////////////////////////////////////
/// 1.入参:	病人就诊ID
/// 2.出参: 生命体征代码|值
/// 3.可根据代码取相应的描述
/// 4.20121028--增加 
/// 	取病人体温单的第一条与最后一条录
/// 	入参:	Parr(病人就诊ID)
/// 	出参:	
/// 	RecDate|2009-09-19^RecTime|10:00:00^Item1|34^Item4|20^Item5|110^Item6|80^Item7|65^
/// 	@RecDate|2011-05-26^RecTime|18:00:00^Item1|37.6^Item4|2221^Item5|1212110^Item6|321390^Item7|^Item9|333^
/// 	20110603 
///     HYD:Item1 体温,Item7 脉搏,Item4 呼吸,Item5 收缩压,Item6 舒张压
/// 5.测试方法：w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatObservations(350319)
ClassMethod GetPatObservations(EpisodeID) As %String
{
 	
	s firstTimeData="",lastTimeData=""
	q:EpisodeID="" "" 
	s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)
	s firstDate= $O(^MR(MRADMROWId,"OBS",0,"Date",0))
	i firstDate'="" s firstTimeData=..GetOneTimeValue(EpisodeID_"^"_firstDate_"^"_1)
	s lastDate= $O(^MR(MRADMROWId,"OBS",0,"Date",""),-1)
	i lastDate'="" s lastTimeData=..GetOneTimeValue(EpisodeID_"^"_lastDate_"^"_2)
	q firstTimeData_"@"_lastTimeData
}

/// 取病人某一天的生命体征
/// 20110603
ClassMethod GetOneTimeValue(Parr) As %String
{
 	
	s EpisodeID=$p(Parr,"^",1)
	s StrDate=$p(Parr,"^",2)
	i StrDate["-" s StrDate=$ZDH(StrDate,3)
	i StrDate["/" s StrDate=$ZDH(StrDate,4)
	s FirstOrLast=$p(Parr,"^",3)
	
	s MotherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
	i MotherAdm'="" s BabyFlag=1
	e  s BabyFlag=""
	if BabyFlag=1
	{ 
		
		s a=..GetSetID("TempERChart")
	}
	else
	{
		
		s a=..GetSetID("TempChart")	
	}
    s tmpcode=""
	s ret=..getVal(a)
	s aa=##class(web.DHCMGNurComm).settmp(ret,.tmpcode)
	s temp="Item14" ;tmpcode("YTemp")  			//体温
	s wultemp="Item22" ;tmpcode("WlTemp")   		//物理降温
	k tmp
	s MRADMROWId=$P(^PAADM(EpisodeID),"^",61)
	s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
	.s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	..s time=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",4)
	..q:time=""
	..s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	..s Desc=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",6)
	..s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	..q:itmcode=""
	..s tmp(time,itmcode)=P1
	..if (Desc'="" )&(itmcode=temp) s tmp(time,wultemp)=Desc
	
	s aa=""
	if FirstOrLast="1"
	{
		s curTime=$O(tmp(""))
		s aa="RecDate|"_$ZD(StrDate,3)_"^RecTime|"_$ZT(curTime)_"^"
		s curCode=""  f  s curCode=$O(tmp(curTime,curCode)) q:curCode=""  d
		.s aa=aa_curCode_"|"_tmp(curTime,curCode)_"^"
	}
	if FirstOrLast="2"
	{
		s curTime=$O(tmp(""),-1)
		s aa="RecDate|"_$ZD(StrDate,3)_"^RecTime|"_$ZT(curTime)_"^"
		s curCode=""  f  s curCode=$O(tmp(curTime,curCode)) q:curCode=""  d
		.s aa=aa_curCode_"|"_tmp(curTime,curCode)_"^"
	}
	q aa
}

// Nur.DHCNurTempSet.cls

ClassMethod GetSetID(code) As %String
{
 //s a=##class(Nur.DHCNurTempSet).GetSetID(code)
  ///1 存数据时取设置  //空白栏不存
  ///2 取数据时GetPatValue
  ///3
  s Code=$ZConvert(code,"U")
  s rw=""  s rw=$O(^Nur.DHCNurTempSetI("Code"," "_Code,rw))
  q rw
}

ClassMethod getVal(id) As %String
{
	s ret=""
	//b
	if id'=""
	{
	s a=##class(Nur.DHCNurTempSet).%OpenId(id)
	s tmp("ChartCode")=a.ChartCode
	s tmp("HPItm")=a.HPItm
	s tmp("LPItm")=a.LPItm
	s tmp("KTemp")=a.KTemp
	s tmp("GTemp")=a.GTemp
	s tmp("YTemp")=a.YTemp
	s tmp("UnTestReason")=a.UnTestReason
	s tmp("Heart")=a.Heart
	s tmp("Puls")=a.Puls
	s tmp("WlTemp")=a.WlTemp
	s tmp("Weight")=a.Weight
	s tmp("GMS")=a.GMS
	s tmp("InOutTime")=a.InOutTime
	s tmp("InOutCode")=a.InOutCode
	s tmp("BlankCode")=a.BlankCode
	s tmp("TimePoint")=a.TimePoint
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

// 诊断排序

// 添加诊断排序

// Input: argDiagStr:诊断字符串

// Return: 诊断字典表ID^ICD编码^诊断描述^诊断顺序号^诊断级别

// 作者:茹毅淳

// 时间:2012-08-06

/// ///////////////////////////////////////////////////////////
/// 生命体征取值 End
/// ///////////////////////////////////////////////////////////
/// ///////////////////////////////////////////////////////////
/// 诊断绑定取值 Start
/// ///////////////////////////////////////////////////////////
ClassMethod DiagSort(argDiagStr As %String) As %String
{
	q:(($p(argDiagStr,"^",6)="")&&($p(argDiagStr,"^",3)="")) ""
	set count=$l(argDiagStr,"!")
	i (count=1)
	{ 
		s retValue=argDiagStr
		q retValue
	}
	
	
	for i=1:1:count
	{
		s DiagStr(i)=$P(argDiagStr,"!",i)
	}
	
	for i=2:1:count
	{
		//处理诊断没有顺序号按照0处理，导致顺序错误。将顺序为空的默认为99
	  s sep=$s($p(DiagStr(i),"^",4)="":99,1:$p(DiagStr(i),"^",4))
	  for j=1:1:(i-1)
	  {
		  //处理诊断没有顺序号按照0处理，导致顺序错误。将顺序为空的默认为99
		   s tmpSep=$s($p(DiagStr(i),"^",4)="":99,1:$p(DiagStr(i),"^",4))
			
				if (sep<tmpSep)
				{
					s tmpDiagStr=DiagStr(i)
					s DiagStr(i)=DiagStr(j)
					s DiagStr(j)=tmpDiagStr
				}
		
		}
	}
		s DiagStr=DiagStr(1)
		for k=2:1:count
		{
		s DiagStr=DiagStr_"!"_DiagStr(k)
		}
	//s DiagStr=..DiagLevel(DiagStr)
	q DiagStr
}

// 诊断分级

// 添加诊断分级

// Input: argDiagStr:诊断字符串

// Return: 诊断顺序号.诊断描述

//        诊断顺序号.诊断描述

//            诊断描述 （二级2诊断）

//        (不是一级诊断时,没有诊断顺序号,在前面空2格)  

// 作者:茹毅淳

// 时间:2012-08-06

// 新增显示格式

// 多增加2个入参:Delimiter1和Delimiter2,用于输入分隔符,调整显示格式

// 格式1:诊断顺序号.诊断描述

//      诊断顺序号.诊断描述

//          诊断描述 （二级2诊断）

// 格式2:诊断顺序号.诊断描述  诊断顺序号.诊断描述  诊断描述（二级2诊断）

// 作者:茹毅淳

// 增加日期:2012-08-08

ClassMethod DiagLevel(argDiagStr As %String, Delimiter1 As %String, Delimiter2 As %String) As %String
{
	q:(($p(argDiagStr,"^",6)="")&&($p(argDiagStr,"^",3)="")) "" 
	 
	set count=$l(argDiagStr,"!")
	s DiagStr="", j=0
	q:(count=1)&($l($P(argDiagStr,"!",1),"\n")>1) Delimiter2_1_"."_$P($P(argDiagStr,"!",1),"^",3)_" "_$P($P(argDiagStr,"!",1),"^",6)_"\n"_"                     "_$p($P(argDiagStr,"!",1),"\n",2)_"\n"_"                     "_$p($P(argDiagStr,"!",1),"\n",3)
	q:(count=1)&($l($P(argDiagStr,"!",1),"\n")<2) Delimiter2_1_"."_$P($P(argDiagStr,"!",1),"^",3)_" "_$P($P(argDiagStr,"!",1),"^",6)
	
	s billFlagList="",billFlagCount=0
	f i=1:1:count
	{
		set tmpBillFlag3=$P($P(argDiagStr,"!",i),"^",6)
		if ($listfind(billFlagList,tmpBillFlag3)=0)
		{
			s billFlagList=billFlagList_$lb(tmpBillFlag3)
		}
		
	}
	s billFlagCount=$ll(billFlagList)
	if billFlagCount=2
	{
		s Delimiter1 =Delimiter1_"    "
	}
	s k=1,j=1,perDiagBillFlag3=""
	
	f i=1:1:count
	{
		set tmpDiag=$P($P(argDiagStr,"!",i),"^",3)
		set tmplev=$P($P(argDiagStr,"!",i),"^",5)
		set tmpBillFlag3=$P($P(argDiagStr,"!",i),"^",6)
		
		if ((tmplev="")||(tmplev="undefined")) {s tmplev=1}
		set mrdesc="" //$P($P(argDiagStr,"!",i),"^",6) //取出诊断注释
		if (+tmplev=1)
		{
			
			s:(perDiagBillFlag3'=tmpBillFlag3) k=1
			if ((k=1)&&(billFlagCount=2)){
				if (tmpBillFlag3="N")
				{
					s DiagStr=DiagStr_"西医诊断:"
				}
				else 
				{
					s DiagStr=DiagStr_"\n中医诊断:"
				}
			}
			
			if (i>1)
			{ set DiagStr=DiagStr_Delimiter1_Delimiter2_k_"."_tmpDiag_" "_mrdesc }
			else
			{ set DiagStr=$s(billFlagCount=2:DiagStr_Delimiter1,1:"")_Delimiter2_"1."_tmpDiag_" "_mrdesc }
			
			if ($l($P(argDiagStr,"!",i),"\n")>1) 
			{
				set DiagStr=DiagStr_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",2)_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",3)
			}
			s k = k + 1
		}
		else
		{
			//set tmpDiag=Delimiter2_tmpDiag_" "_mrdesc
			s:(perDiagLevel=tmplev) j=j+1
			s:(perDiagLevel'=tmplev) j=1
			if (i>1)
			{ set DiagStr=DiagStr_Delimiter1_"          "_j_")"_tmpDiag_mrdesc }
			else 
			{ set DiagStr="          "_j_")"_tmpDiag_mrdesc }	
			
			if ($l($P(argDiagStr,"!",i),"\n")>1) 
			{
				set DiagStr=DiagStr_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",2)_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",3)
			}	
		}
		s perDiagLevel=tmplev
		s perDiagBillFlag3=tmpBillFlag3
	}	
	q DiagStr
}

// 诊断分级

// 添加诊断分级

// Input: argDiagStr:诊断字符串

// Return: 诊断顺序号.诊断描述

//        诊断顺序号.诊断描述

//            诊断描述 （二级2诊断）

//        (不是一级诊断时,没有诊断顺序号,在前面空2格)  

// 作者:茹毅淳

// 时间:2012-08-06

// 新增显示格式

// 多增加2个入参:Delimiter1和Delimiter2,用于输入分隔符,调整显示格式

// 格式1:诊断顺序号.诊断描述

//      诊断顺序号.诊断描述

//          诊断描述 （二级2诊断）

// 格式2:诊断顺序号.诊断描述  诊断顺序号.诊断描述  诊断描述（二级2诊断）

// 作者:茹毅淳

// 增加日期:2012-08-08

ClassMethod DiagLevelForRowMode(argDiagStr As %String, Delimiter1 As %String, Delimiter2 As %String) As %String
{
	q:(($p(argDiagStr,"^",6)="")&&($p(argDiagStr,"^",3)="")) "" 
	 
	set count=$l(argDiagStr,"!")
	s DiagStr="", j=0
	q:(count=1)&($l($P(argDiagStr,"!",1),"\n")>1) Delimiter2_1_"."_$P($P(argDiagStr,"!",1),"^",3)_" "_$P($P(argDiagStr,"!",1),"^",6)_"\n"_"                     "_$p($P(argDiagStr,"!",1),"\n",2)_"\n"_"                     "_$p($P(argDiagStr,"!",1),"\n",3)
	q:(count=1)&($l($P(argDiagStr,"!",1),"\n")<2) Delimiter2_1_"."_$P($P(argDiagStr,"!",1),"^",3)_" "_$P($P(argDiagStr,"!",1),"^",6)
	
	f i=1:1:count
	{
		set k=i-j
		set tmpDiag=$P($P(argDiagStr,"!",i),"^",3)
		set tmplev=$P($P(argDiagStr,"!",i),"^",5)
		
		if ((tmplev="")||(tmplev="undefined")) {s tmplev=1}
		set mrdesc=$P($P(argDiagStr,"!",i),"^",6) //取出诊断注释
		if (+tmplev=1)
		{
			if (i>1)
			{ set DiagStr=DiagStr_Delimiter1_Delimiter2_k_"."_tmpDiag_mrdesc }
			else
			{ set DiagStr=Delimiter2_1_"."_tmpDiag_mrdesc }
			
			if ($l($P(argDiagStr,"!",i),"\n")>1) 
			{
				set DiagStr=DiagStr_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",2)_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",3)
			}
		}
		else
		{
			//set tmpDiag=Delimiter2_tmpDiag_" "_mrdesc
			s j=j+1
			if (i>1)
			{ set DiagStr=DiagStr_Delimiter1_j_")"_tmpDiag_mrdesc }
			else 
			{ set DiagStr="("_j_")."_tmpDiag_mrdesc }	
			
			if ($l($P(argDiagStr,"!",i),"\n")>1) 
			{
				set DiagStr=DiagStr_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",2)_"\n"_"                     "_$p($P(argDiagStr,"!",i),"\n",3)
			}	
		}	 
	}	
	q DiagStr_"。"
}

/// Desc:	入院诊断的中医诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：入院诊断类型id
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
/// Upate: 	2010-12-29 入院诊断类型增加 C008
ClassMethod AdmZYDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId    
	s admDiagTypeId = ""
	//s admDiagTypeId = $O(^MRC("DTYP",0,"Code","PRE",""))          //PRE 初步诊断
	s tmpid1 = $O(^MRC("DTYP",0,"Code","PRE3ZYZD",""))            //PRE-3-ZYZD 中医诊断 
	//s tmpid2 = $O(^MRC("DTYP",0,"Code","PRE1XYZD",""))            //PRE-1-XYZD 西医诊断  
	s admDiagTypeId = tmpid1
	q:(admDiagTypeId = "") ""
	
	s admDiagTypeId = "^"_admDiagTypeId_"^"
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")

			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为入院诊断
			if ($find(admDiagTypeId, "^"_typmrcdiagtyp_"^"))
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
					
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				//zengweishan 添加级别和顺序号
				s leve=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",1)
				s sequence=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve }
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve }
			}
		}
	}
	
	q retValue
}

/// Desc:	补充诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MainDiagnos("65")
ClassMethod BCDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	//s mainDiagTypeId = ""
	//s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	//q:(mainDiagTypeId = "") ""
	
	//取最后诊断里的其他几个诊断 zengweishan
	s mainDiagTypeId = ""
	//s tmpid1 = $O(^MRC("DTYP",0,"Code","M4SWZD",""))          //M-4-SWZD 死亡诊断
	s tmpid4 = $O(^MRC("DTYP",0,"Code","M5BCZD",""))          //M-5-BCZD 补充诊断
	//s tmpid5 = $O(^MRC("DTYP",0,"Code","M6ZYZD",""))          //M-6-ZYZD 中医诊断
	//s mainDiagTypeId = mainDiagTypeId_"^"_tmpid1_"^"_tmpid2_"^"_tmpid3_"^"_tmpid4_"^"_tmpid5
	s mainDiagTypeId = tmpid4
	q:(mainDiagTypeId = "") ""
	s mainDiagTypeId = "^"_mainDiagTypeId_"^"
	//取补充诊断以及修正诊断
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			if ($find(mainDiagTypeId,"^"_typmrcdiagtyp_"^"))	//此处判断是否为补充诊断以及修正诊断 zengweishan
			{
				s themrdiachildsub = mrdiachildsub
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				//q:(mricdid = "") 
	
				//s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				//s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				
				s:((doctoridlast'=doctorid)||(diagDatelast'=diagDate))&&(doctoridlast'="") retValue=retValue_"\n"_doctorlast_"\n"_diagDatelast 		
				
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				//zengweishan 添加级别和顺序号
				s leve=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",1)
				s sequence=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
			}
				s doctoridlast=doctorid
				s diagDatelast=diagDate
				s doctorlast=doctor
		}
	}
	s retValue =retValue_"\n"_doctor_"\n"_diagDate
	q retValue
}

/// Desc:	死亡诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MainDiagnos("65")
ClassMethod SWDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	//s mainDiagTypeId = ""
	//s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	//q:(mainDiagTypeId = "") ""
	
	//取最后诊断里的其他几个诊断 zengweishan
	s mainDiagTypeId = ""
	s tmpid1 = $O(^MRC("DTYP",0,"Code","M4SWZD",""))          //M-4-SWZD 死亡诊断
	//s mainDiagTypeId = mainDiagTypeId_"^"_tmpid1_"^"_tmpid2_"^"_tmpid3_"^"_tmpid4_"^"_tmpid5
	s mainDiagTypeId = tmpid1
	q:(mainDiagTypeId = "") ""
	s mainDiagTypeId = "^"_mainDiagTypeId_"^"
	//取补充诊断以及修正诊断
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			if ($find(mainDiagTypeId,"^"_typmrcdiagtyp_"^"))	//此处判断是否为补充诊断以及修正诊断 zengweishan
			{
				s themrdiachildsub = mrdiachildsub
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				//q:(mricdid = "") 
	
				//s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				//s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				
				s:((doctoridlast'=doctorid)||(diagDatelast'=diagDate))&&(doctoridlast'="") retValue=retValue_"\n"_doctorlast_"\n"_diagDatelast 		
				
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
				s doctoridlast=doctorid
				s diagDatelast=diagDate
				s doctorlast=doctor
		}
	}
	//s retValue =retValue_"\n"_doctor_"\n"_diagDate
	q retValue
}

/// Desc:	中医诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MainDiagnos("65")
ClassMethod ZYDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	//s mainDiagTypeId = ""
	//s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	//q:(mainDiagTypeId = "") ""
	
	//取最后诊断里的其他几个诊断 zengweishan
	s mainDiagTypeId = ""
	s tmpid5 = $O(^MRC("DTYP",0,"Code","M6ZYZD",""))          //M-6-ZYZD 中医诊断
	//s mainDiagTypeId = mainDiagTypeId_"^"_tmpid1_"^"_tmpid2_"^"_tmpid3_"^"_tmpid4_"^"_tmpid5
	s mainDiagTypeId = tmpid5
	q:(mainDiagTypeId = "") ""
	s mainDiagTypeId = "^"_mainDiagTypeId_"^"
	//取补充诊断以及修正诊断
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			if ($find(mainDiagTypeId,"^"_typmrcdiagtyp_"^"))	//此处判断是否为补充诊断以及修正诊断 zengweishan
			{
				s themrdiachildsub = mrdiachildsub
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				//q:(mricdid = "") 
	
				//s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				//s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				
				s:((doctoridlast'=doctorid)||(diagDatelast'=diagDate))&&(doctoridlast'="") retValue=retValue_"\n"_doctorlast_"\n"_diagDatelast 		
				
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				//zengweishan 添加级别和顺序号
				s leve=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",1)
				s sequence=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
			}
				s doctoridlast=doctorid
				s diagDatelast=diagDate
				s doctorlast=doctor
		}
	}
	s retValue =retValue_"\n"_doctor_"\n"_diagDate
	q retValue
}

/// Desc:	门诊诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MZDiagnos("65")
ClassMethod MZDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		continue:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"EPR"))=0)
			
				s themrdiachildsub = mrdiachildsub
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			
	}
	q retValue
}

/// Desc:	出院诊断不带医生和下诊断时间
/// Input:	argAdmId: 就诊rowid
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
ClassMethod OutDiagnosSpa(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中出院诊断对应的RowId 
	//s admDiagTypeId = ""
	//s admDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))  
	//q:(admDiagTypeId = "") ""
	/*
	//取最后诊断里的最后诊断 zengweishan
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))  
	q:(admDiagTypeId = "") ""
	//取最后诊断里的最后诊断
	*/
	//取出院诊断里的主要诊断 zengweishan
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))
	q:(admDiagTypeId = "") ""
	//取出院诊断里的主要诊断
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为出院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				//q:(mricdid = "") 
	
				//s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				//s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				/*
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				*/
				
				s:((doctoridlast'=doctorid)||(diagDatelast'=diagDate))&&(doctoridlast'="") retValue=retValue_"\n"_"                     "_doctorlast_$C(13)_"                     "_diagDatelast 		
					 			
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc}
			}
				s doctoridlast=doctorid
				s diagDatelast=diagDate
				s doctorlast=doctor

		}
	}
	//s retValue =retValue_"\n"_"                     "_doctor_"\n"_"                     "_diagDate
	q retValue
}

/// Desc:	出院诊断
/// Input:	argAdmId: 就诊rowid
/// Output:	RowId^诊断代码^诊断描述!RowId^诊断代码^诊断描述
ClassMethod OutDiagnos1(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中出院诊断对应的RowId 
	
	//取最后诊断里的最后诊断 zengweishan
	s admDiagTypeId = ""
	s admDiagTypeId = $O(^MRC("DTYP",0,"Code","DIS",""))  
	q:(admDiagTypeId = "") ""
	//取最后诊断里的最后诊断
	
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = 0
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			if (typmrcdiagtyp = admDiagTypeId)	//此处判断是否为出院诊断
			{
				s themrdiachildsub = mrdiachildsub
				
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				//q:(mricdid = "") 
	
				//s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				//s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				
				//s:((doctoridlast'=doctorid)||(diagDatelast'=diagDate))&&(doctoridlast'="") retValue=retValue_"\n"_doctorlast_"\n"_diagDatelast 		
					 		
				//zengweishan 添加级别和顺序号
				s leve=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",1)
				s sequence=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",2)
					 			
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
			}
				s doctoridlast=doctorid
				s diagDatelast=diagDate
				s doctorlast=doctor

		}
	}
	//s retValue =retValue_"\n"_doctor_"\n"_diagDate
	q retValue
}

/// Desc:	西医诊断
/// Input:	argAdmId: 就诊rowid， argAdmDiagTypeId：主要诊断类型id
/// Output:	RowId^诊断代码^诊断描述
/// Debug: w ##class(EMR.DOC.HISInterface.PatientInfoAssist).MainDiagnos("65")
ClassMethod XYDiagnos(argAdmId As %String) As %String
{
	q:($d(argAdmId)=0)||(argAdmId="") ""
	s retValue = ""
	
	//取表 MRC_DiagnosType 中入院诊断对应的RowId 
	//s mainDiagTypeId = ""
	//s mainDiagTypeId = $O(^MRC("DTYP",0,"Code","M",""))
	//q:(mainDiagTypeId = "") ""
	
	//取最后诊断里的其他几个诊断 zengweishan
	s mainDiagTypeId = ""
	//s tmpid1 = $O(^MRC("DTYP",0,"Code","M4SWZD",""))          //M-4-SWZD 死亡诊断
	s tmpid2 = $O(^MRC("DTYP",0,"Code","PRE1XYZD",""))          //PRE-1-XYZD 西医诊断
	//s tmpid4 = $O(^MRC("DTYP",0,"Code","M5BCZD",""))          //M-5-BCZD 补充诊断
	//s tmpid5 = $O(^MRC("DTYP",0,"Code","M6ZYZD",""))          //M-6-ZYZD 中医诊断
	//s mainDiagTypeId = mainDiagTypeId_"^"_tmpid1_"^"_tmpid2_"^"_tmpid3_"^"_tmpid4_"^"_tmpid5
	s mainDiagTypeId = tmpid2
	q:(mainDiagTypeId = "") ""
	s mainDiagTypeId = "^"_mainDiagTypeId_"^"
	//取补充诊断以及修正诊断
	
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") ""
	q:($d(^MR(mainmradmdr)) = 0) ""
	
	s (doctorid,diagDate,doctor,doctoridlast,diagDatelast,doctorlast)=""
	
	s themrdiachildsub = ""
	s mrdiachildsub = ""
	for {
		s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
		q:(mrdiachildsub="")
		
		s mrdiagtype = ""
		for {
			q:($d(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP"))=0)
			s mrdiagtype=$o(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype))
			q:(mrdiagtype="")
			
			s typmrcdiagtyp = $p($g(^MR(mainmradmdr,"DIA",mrdiachildsub,"TYP",mrdiagtype)),"^",1)
			//if (typmrcdiagtyp = mainDiagTypeId)	//此处判断是否为主要诊断
			if ($find(mainDiagTypeId,"^"_typmrcdiagtyp_"^"))	//此处判断是否为补充诊断以及修正诊断 zengweishan
			{
				s themrdiachildsub = mrdiachildsub
				s mricdid = $p($g(^MR(mainmradmdr,"DIA",themrdiachildsub)),"^",1)
				//q:(mricdid = "") 
	
				//s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
				//s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				//q:(mricdid = "")   //处理非ICD标准字典的诊断
				if (mricdid '= "") {
					s mricdCode = $p($g(^MRC("ID",mricdid)),"^",4)
					s mricdDesc = $p($g(^MRC("ID",mricdid)),"^",2)
				}
				else {
					s mricdCode = ""
					s mricdDesc = ""
					}
				
				s doctorid=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,1))
				s doctorid=$p(doctorid,"^",18)
				S:(doctorid'="") doctor=$g(^SSU("SSUSR",doctorid))
				S:(doctor'="") doctor=$p(doctor,"^",2)
				s diagDate=$g(^MR(mainmradmdr,"DIA",themrdiachildsub))
				s:(diagDate'="") diagDate=$zd($p(diagDate,"^",7),3)
				
				s:((doctoridlast'=doctorid)||(diagDatelast'=diagDate))&&(doctoridlast'="") retValue=retValue_"\n"_doctorlast_"\n"_diagDatelast 		
				
				
				//20120516 wangwentao add
				s diagNote=$g(^MR(mainmradmdr,"DIA",themrdiachildsub,"DES",1))
				if (diagNote '= "") 
				{
					s:(mricdDesc'="") mricdDesc = mricdDesc_"("_diagNote_")"
					s:(mricdDesc="") mricdDesc = diagNote
				}
				//end
				
				//zengweishan 添加级别和顺序号
				s leve=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",1)
				s sequence=$p($g(^MR(mainmradmdr,"DIA",themrdiachildsub,"EPR")),"^",2)
				
				if (retValue = "")
				{	s retValue = mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
				else
				{	s retValue = retValue_"!"_mricdid_"^"_mricdCode_"^"_mricdDesc_"^"_sequence_"^"_leve}
			}
				s doctoridlast=doctorid
				s diagDatelast=diagDate
				s doctorlast=doctor
		}
	}
	s retValue =retValue_"\n"_doctor_"\n"_diagDate
	q retValue
}

/// ///////////////////////////////////////////////////////////
/// 诊断绑定取值 End
/// ///////////////////////////////////////////////////////////
ClassMethod GetDepartmentHeader(AEpisodeID As %String) As %String
{
	s ret="^^"
	q:(AEpisodeID="") ret
	
	//获取出院科室ID
	s DischLocID= $p(..DisDept(AEpisodeID,""),"^",1)

	//取出院科室的科主任
	
	s DischLocInfo=$g(^CTLOC(DischLocID))
	s DepHeaderID=$p(DischLocInfo,"^",54)
	q:(DepHeaderID="") ret
	s DepHeaderInfo=$g(^SSU("SSUSR",DepHeaderID))
	s DepHeaderName=$p(DepHeaderInfo,"^",2)
	s DepHeaderCode=$p(DepHeaderInfo,"^",1)
	s DepHeaderDict = DepHeaderID_"^"_DepHeaderCode_"^"_DepHeaderName
	q DepHeaderDict
}

ClassMethod GetPrimaryNurse(AEpisodeID As %String) As %String
{
	s ret="^^"
	q:(AEpisodeID="") ret
	
	s PrimaryNurseIDInfo = ##class(NurDWB.GetData).GetPrimaryNurseID(AEpisodeID)
	s FirstPrimaryNurseID = $p(PrimaryNurseIDInfo,"^",1)
	
	q:(FirstPrimaryNurseID="") ret

	s FirstPrimaryNurseInfo=$g(^SSU("SSUSR",FirstPrimaryNurseID))
	s FirstPrimaryNurseName=$p(FirstPrimaryNurseInfo,"^",2)
	s FirstPrimaryNurseCode=$p(FirstPrimaryNurseInfo,"^",1)
	s FirstPrimaryNurseDict = FirstPrimaryNurseID_"^"_FirstPrimaryNurseCode_"^"_FirstPrimaryNurseName
	q FirstPrimaryNurseDict
}

/// Desc:	取指定类型的诊断ID
ClassMethod GetType(AEpisodeID As %String) As %String
{
	s admType = $p($g(^PAADM(AEpisodeID)),"^",2)
	q admType
}

/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetLinkUnitSchemeData(74,"diagnosesLayerV8","PRE")
/// {"name":"diagnosesLayerV8","type":"PRE"}
ClassMethod GetLinkUnitSchemeData(AEpisodeID As %String, ALinkUnitName As %String, ADiagType As %String) As %String
{
	q:(ALinkUnitName="") 0
	//diagnosesLayerV8
	s unitScheme="" ;##class(EMRservice.BL.HyperLink).GetUnitScheme(ALinkUnitName)
	
	
	//通过XPath获取Scheme中各标签内的值
	
	//1.将string转换成XPath对象文档
	s unitScheme=$zcvt(unitScheme,"I","UTF8")
	Set tSC=##class(%XML.XPATH.Document).CreateFromString(unitScheme,.tDoc)
    If $$$ISERR(tSC) {
	    Do $System.OBJ.DisplayError(tSC) Quit 1
	}
	
	/*
		g_refScheme = getRefScheme(g_xml,"scheme>reference>items>item")
		g_separate = $(g_xml).find("scheme>reference>separate").text();
		g_separate = g_separate=="enter"?"\n":g_separate;
		g_schemetype = $(g_xml).find("scheme>reference>style").text();
		g_memosep = $(g_xml).find("scheme>reference>memosep").text();
		var interpunction = $(g_xml).find("scheme>reference>interpunction").text();
		g_interpunction = interpunction.split("^");
		var displaycategory = $(g_xml).find("scheme>reference>category>display").text();
		var categoryseparate = $(g_xml).find("scheme>reference>category>separate").text();
		categoryseparate = categoryseparate=="enter"?"\n":categoryseparate;
		var displaytype = $(g_xml).find("scheme>reference>type>display").text();
		var typeseparate = $(g_xml).find("scheme>reference>type>separate").text();
		typeseparate = typeseparate=="enter"?"\n":typeseparate;
		var tmpnamedate = $(g_xml).find("scheme>reference>namedate").text();
	
	*/
	///////////////////////////////////////////////////
	//2.通过XPath取值
	//初始化变量
	s (separate,schemetype,memosep,interpunction,displaycategory,categoryseparate)=""
    s (displaytype,typeseparate,tmpnamedate)=""
	///////////////////////////////////////////////////
	//2.1 g_separate 解析XPath
	//		g_separate = $(g_xml).find("scheme>reference>separate").text();
	//		g_separate = g_separate=="enter"?"\n":g_separate;
	Set separateContext="/scheme/reference"
    Set separateExpr="separate/text()"
    
    Set separatetSC=tDoc.EvaluateExpression(separateContext,separateExpr,.separateXPathResult)
    If $$$ISERR(separatetSC) Quit "separate_Error" 
    //2.1 获取值结果值
    s separate=..GetXMLPathResults(separateXPathResult)
    s separate = $case(separate,"enter":"\n",:separate)
    
    ///////////////////////////////////////////////////
	//2.2 g_schemetype 解析XPath
	//		g_schemetype = $(g_xml).find("scheme>reference>style").text();
	Set styleContext="/scheme/reference"
    Set styleExpr="style/text()"
    
    Set styletSC=tDoc.EvaluateExpression(styleContext,styleExpr,.styleXPathResult)
    If $$$ISERR(styletSC) Quit "style_Error" 
    //2.2 获取值结果值
    s schemetype=..GetXMLPathResults(styleXPathResult)
    
    
     ///////////////////////////////////////////////////
	//2.3 g_memosep 解析XPath
	//		g_memosep = $(g_xml).find("scheme>reference>memosep").text();
	Set memosepContext="/scheme/reference"
    Set memosepExpr="memosep/text()"
    
    Set memoseptSC=tDoc.EvaluateExpression(memosepContext,memosepExpr,.memosepXPathResult)
    If $$$ISERR(memoseptSC) Quit "memosep_Error" 
    //2.3 获取值结果值
    s memosep=..GetXMLPathResults(memosepXPathResult)
    
    
    ///////////////////////////////////////////////////
	//2.4 g_interpunction 解析XPath
	//		var interpunction = $(g_xml).find("scheme>reference>interpunction").text();
	//		g_interpunction = interpunction.split("^");
	Set interpunctiontContext="/scheme/reference"
    Set interpunctionExpr="interpunction/text()"
    
    Set interpunctiontSC=tDoc.EvaluateExpression(interpunctiontContext,interpunctionExpr,.interpunctionXPathResult)
    If $$$ISERR(interpunctiontSC) Quit "interpunction_Error" 
    //2.4 获取值结果值
    s interpunction=..GetXMLPathResults(interpunctionXPathResult)
    
    
    
    
    ///////////////////////////////////////////////////
	//2.5 displaycategory 解析XPath
	//		var displaycategory = $(g_xml).find("scheme>reference>category>display").text();
	Set displaycategoryContext="/scheme/reference/category"
    Set displaycategoryExpr="display/text()"
    
    Set displaycategorytSC=tDoc.EvaluateExpression(displaycategoryContext,displaycategoryExpr,.displaycategoryXPathResult)
    If $$$ISERR(displaycategorytSC) Quit "displaycategory_Error" 
    //2.5 获取值结果值
    s displaycategory=..GetXMLPathResults(displaycategoryXPathResult)
    
    
    ///////////////////////////////////////////////////
	//2.6 categoryseparate 解析XPath
	//		var categoryseparate = $(g_xml).find("scheme>reference>category>separate").text();
	//		categoryseparate = categoryseparate=="enter"?"\n":categoryseparate;
	Set categoryseparateContext="/scheme/reference/category"
    Set categoryseparateExpr="separate/text()"
    
    Set categoryseparatetSC=tDoc.EvaluateExpression(categoryseparateContext,categoryseparateExpr,.categoryseparateXPathResult)
    If $$$ISERR(categoryseparatetSC) Quit "categoryseparate_Error" 
    //2.6 获取值结果值
    s categoryseparate=..GetXMLPathResults(categoryseparateXPathResult)
    s categoryseparate = $case(categoryseparate,"enter":"\n",:categoryseparate)
    
    
    ///////////////////////////////////////////////////
	//2.7 displaytype 解析XPath
	//		var displaytype = $(g_xml).find("scheme>reference>type>display").text();
	Set displaytypeContext="/scheme/reference/type"
    Set displaytypeExpr="display/text()"
    
    Set displaytypetSC=tDoc.EvaluateExpression(displaytypeContext,displaytypeExpr,.displaytypeXPathResult)
    If $$$ISERR(displaytypetSC) Quit "displaytype_Error" 
    //2.7 获取值结果值
    s displaytype=..GetXMLPathResults(displaytypeXPathResult)
    
    
    ///////////////////////////////////////////////////
	//2.8 categoryseparate 解析XPath
	//		var typeseparate = $(g_xml).find("scheme>reference>type>separate").text();
	//		typeseparate = typeseparate=="enter"?"\n":typeseparate;
	Set typeseparateContext="/scheme/reference/type"
    Set typeseparateExpr="separate/text()"
    
    Set typeseparatetSC=tDoc.EvaluateExpression(typeseparateContext,typeseparateExpr,.typeseparateXPathResult)
    If $$$ISERR(typeseparatetSC) Quit "typeseparate_Error" 
    //2.8 获取值结果值
    s typeseparate=..GetXMLPathResults(typeseparateXPathResult)
    s typeseparate = $case(typeseparate,"enter":"\n",:typeseparate)
    
   
	///////////////////////////////////////////////////
	//2.9 displaytype 解析XPath
	//		var displaytype = $(g_xml).find("scheme>reference>type>display").text();
	Set tmpnamedateContext="/scheme/reference"
    Set tmpnamedateExpr="namedate/text()"
    
    Set tmpnamedatetSC=tDoc.EvaluateExpression(tmpnamedateContext,tmpnamedateExpr,.tmpnamedateXPathResult)
    If $$$ISERR(tmpnamedatetSC) Quit "tmpnamedate_Error" 
    //2.9 获取值结果值
    s tmpnamedate=..GetXMLPathResults(tmpnamedateXPathResult)
    
   	//debugger//
   	/*
   	s resultString="separate:"_separate
   	s resultString=resultString_","_"schemetype:"_schemetype
   	s resultString=resultString_","_"memosep:"_memosep
   	s resultString=resultString_","_"interpunction:"_interpunction
   	s resultString=resultString_","_"displaycategory:"_displaycategory
   	s resultString=resultString_","_"categoryseparate:"_categoryseparate
   	s resultString=resultString_","_"displaytype:"_displaytype
   	s resultString=resultString_","_"typeseparate:"_typeseparate
   	s resultString=resultString_","_"tmpnamedate:"_tmpnamedate
    */
    /*
    MRCIDRowId:MRDIARowId:DiagnosCat:DiagnosType:DiagnosLeavel:DiagnosICDDesc:MainDiagFlag:DiagnosNotes:MRCIDCode:DiagnosStatus:id:DiagnosOnsetDate:DiagnosDate:SyndromeDesc:MRDIAMRDIADR:DiagnosStatusRowId:DiagnosTypeRowId:DiagnosDoctor:DiagnosBodyPart:DiagnosBodyPartRowId:
	6933:6||26:西医:初步诊断:1:高血压病:否::I10.x00:确诊:1:27/12/2018:27/12/2018:::3:3:医生01:::
	6936:6||27:西医:初步诊断:1:高血压I期:否::I10.x03:确诊:2:27/12/2018:27/12/2018:::3:3:医生01:::
	21885:6||28:西医:初步诊断:1:孕3周:否::YZZD3:确诊:3:27/12/2018:27/12/2018:::3:3:医生01:::
	21326:6||29:中医:初步诊断:1:中暑病:否::BNW080:确诊:4:02/01/2019:02/01/2019:::3:3:医生01:::
	22264:6||30:证型:初步诊断:2:&nbsp&nbsp&nbsp&nbsp惊恐证:否::ZBV050:确诊:5:02/01/2019:02/01/2019::6||29:3:3:医生01:::
	23790:6||31:证型:初步诊断:2:&nbsp&nbsp&nbsp&nbsp溃后期:否::ZVM160:确诊:6:02/01/2019:02/01/2019::6||29:3:3:医生01:::
	21848:6||32:中医:初步诊断:1:口疮病:否::BRK060:确诊:7:02/01/2019:02/01/2019:::3:3:医生01:::
	22410:6||33:证型:初步诊断:2:&nbsp&nbsp&nbsp&nbsp血枯证:否:血枯证备注:ZYX020:确诊:8:02/01/2019:02/01/2019::6||32:3:3:医生01:::
	22920:6||34:证型:初步诊断:2:&nbsp&nbsp&nbsp&nbsp寒证类:否::ZBH:确诊:9:02/01/2019:02/01/2019::6||32:3:3:医生01:::
	:6||36:西医:初步诊断:1::否:备注::确诊:10:02/01/2019:02/01/2019:::3:3:医生01:::
    */
    //s rSC = ##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
    s rSC = ##class(%ResultSet).%New("EMR.DOC.HISInterface.PatientInfoAssist:DiagnosList")
    q:(rSC.QueryIsValid()=0) "Query Is Not Exsit"
	d rSC.Execute(AEpisodeID)
	//d rSC.%Next()
	//q rSC.Data("Rt")
	//因ResultSet没法返回到起始位置多次循环，无法满足后续的代码
	//未找到ResultSet中，将当前cusor行的数据拷贝出来的方法。
	//将结果转换成临时数据，易于遍历，取值。
	s rowNum=""
	s ColumnCount=rSC.GetColumnCount()
	s repid=$i(^CacheTemp)
	
	k CacheTemp(repid,"EMRDiagInfo")
	//转换诊断类型
	//MRC_DiagnosType
	//1	DIS	出院诊断	N
	//3	PRE	初步诊断	N
	//4	C008	入院诊断	N
	//5	OP	门诊诊断	N
	s DiagTypeDesc=$case(ADiagType,"PRE":"初步诊断","DIS":"出院诊断","OP":"门诊诊断","C008":"入院诊断")
	

	while rSC.%Next() {
		
		continue:(DiagTypeDesc'= rSC.Data("DiagnosType"))
		
		set rowNum = $i(rowNum)
		s diagData = ##Class(%ArrayOfDataTypes).%New()
		
	 	for column = 1:1:ColumnCount 
	 	{
		 	
			s columnValue = rSC.%GetData(column)
			s columnValue = $tr(columnValue,"&nbsp","")
			s columnName =  rSC.GetColumnName(column)
			d diagData.SetAt(columnValue,columnName)
			
		}
		
		s CacheTemp(repid,"EMRDiagInfo",rowNum) = diagData
	}	
	
	
	s typeList = "",tmpRowID="",ListNum="",ListWithDUNum="",BillFlagList=""
	for
	{
		s tmpRowID=$o(CacheTemp(repid,"EMRDiagInfo",tmpRowID))
		q:(tmpRowID="")
		
		s tmpArray = CacheTemp(repid,"EMRDiagInfo",tmpRowID)
		

		s ItemTypeDesc = tmpArray.GetAt("DiagnosType")
		s ItemBillFlag = $case(tmpArray.GetAt("DiagnosCat"),"西医":"西医",:"中医")
		s ItemDate = tmpArray.GetAt("DiagnosDate")
		s ItemUserName = tmpArray.GetAt("DiagnosDoctor")
		//设定诊断类型临时global
		s:($listfind(BillFlagList,ItemBillFlag)=0) BillFlagList=BillFlagList_$lb(ItemBillFlag)
		
		s CacheTemp(repid,"EMRDiagInfoTypeList",ItemTypeDesc,ItemBillFlag,$i(ListNum)) = tmpArray
		s CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",ItemTypeDesc,ItemBillFlag,ItemDate,ItemUserName,$i(ListWithDUNum)) = tmpArray

	}
	
	s result =""
	if (tmpnamedate = "y")
	{
		s tmpType=""
		for
		{
			s tmpType=$o(CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",tmpType))	
	
			q:(tmpType="")
			if (displaytype = "y")
			{
				s result = result_tmpType_":"_typeseparate
			}
			
			s tmpBillFlag=""
			for
			{
				s tmpBillFlag=$o(CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",tmpType,tmpBillFlag),-1)
				q:(tmpBillFlag="")
				
				if (($ll(BillFlagList) >1) && (displaycategory = "y"))
				{
					s:(tmpType '="") result = result_"    "
					if (tmpBillFlag="西医") 
					{
						s result = result_"西医诊断:"
					}
					else
					{
						s result = result_"中医诊断:"
					}
					
					s result = result_categoryseparate
					
				}
				
				s tmpDate=""
				for
				{
					s tmpDate=$o(CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",tmpType,tmpBillFlag,tmpDate))
					q:(tmpDate="")
					
					s tmpName=""
					for
					{
						s tmpName=$o(CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",tmpType,tmpBillFlag,tmpDate,tmpName))
						q:(tmpName="")
						
						
						s seq = 0
					    s date = ""
					    s name = ""
					    
						s tmpItemID="",tmpItemCount=0
						for
						{
							s tmpItemID=$o(CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",tmpType,tmpBillFlag,tmpDate,tmpName,tmpItemID))
							q:(tmpItemID="")
							
							s tmpDiagItemData = CacheTemp(repid,"EMRDiagInfoTypeListWithDateUser",tmpType,tmpBillFlag,tmpDate,tmpName,tmpItemID)
							
						    s:(type '= "") result = result _ "    "
					    	s:(category '= "") result = result + "    "

						    s seq = seq+1
						    s result = result _ seq
						    
						    s:((seq '= "")&& ($l(interpunction,"^")>0)) result = result _ $p(interpunction,"^",1)
						    
						    s result = result _ tmpDiagItemData.GetAt("DiagnosICDDesc")
						    
						    if (tmpDiagItemData.GetAt("DiagnosStatus") = "疑诊")
						    {
							     s result = result _ "?"
							}
					 		if (tmpDiagItemData.GetAt("DiagnosNotes") '= "")
							{
								if (g_memosep = "()")
								{
									if (tmpDiagItemData.GetAt("MRCIDCode") '= "" = "")
									{
										s result = result + tmpDiagItemData.GetAt("DiagnosNotes")
									}
									else
									{
										s result = result + "("+tmpDiagItemData.GetAt("DiagnosNotes")+")"
									}
								}
								else
								{
									s result = result + tmpDiagItemData.GetAt("DiagnosNotes")
								}
							}
						    //s child = ..getSubData(nameItems[m].children,nameItems[m].BillFlag)
						    if (tmpDiagItemData.GetAt("DiagnosCat") '= "西医") && (child '= "") 
						    {
							    s result = result _"("_child_")"
							}
							else
							{
								if ((schemetype = "layer") && (child '= ""))
								{
									s result = result _ "\n" _ child
								}
								elseif(schemetype = "row")
								{
									s result = result _  child
								}
							}
							s result = result _ separate
							s tmpItemCount= +$g(tmpItemCount)+1
						}
						if (tmpItemCount>0)
						{
							s date = "                      " + tmpDiagItemData.GetAt("DiagnosDate") _ "\n"
							s name = "                      " + tmpDiagItemData.GetAt("DiagnosDoctor") _ "\n"
							s result = result _ name _ date
						}
							
					}
				
				}
				
			}
		}
	}
	else
	{
		
		s tmpType=""
		for
		{
			s tmpType=$o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType))	
			q:(tmpType="")
			if (displaytype = "y")
			{
				s result = result_tmpType_":"_typeseparate
			}
			
			s tmpBillFlag=""
			for
			{
				s tmpBillFlag=$o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag),-1)
				q:(tmpBillFlag="")
				if (($ll(BillFlagList) >1) && (displaycategory = "y"))
				{
					s:((tmpType '="")&&(displaytype = "Y")) result = result_"    "
					if (tmpBillFlag="西医") 
					{
						s result = result_"西医诊断:"
					}
					else
					{
						s result = result_"中医诊断:"
					}
					
					s result = result_categoryseparate
					
					
				}
				s tmpItemID="",seqLevel1="",preDiagLevel=""
				for
				{
					s tmpItemID=$o(CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag,tmpItemID))
					q:(tmpItemID="")
					
					s tmpDiagItemData = CacheTemp(repid,"EMRDiagInfoTypeList",tmpType,tmpBillFlag,tmpItemID)
					s:((tmpType '="")&&(displaytype = "Y")) result = result _ "    "
		            s:("" '= tmpBillFlag) result = result _ "    "
			        s level = tmpDiagItemData.GetAt("DiagnosLeavel")
			        s space = ..getSpace(level,schemetype)
			        
			        s result = result_space
 
			        if (level = 1) 
			        {
			        	s seqLevel1 = $case(seqLevel1,"" :1,:(seqLevel1+1))
			        }
			        else 
			        {
			            s subseq = $case(preDiagLevel, level:(subseq+1) ,: 1) 
			        }
			            
			            
			        s result = result _ $case(level, 1 :seqLevel1 ,: subseq)
			            
					if ($l(interpunction,"^") >0) 
					{
						s result = result _ $p(interpunction,"^",level)
					}
						
					s result = result _ tmpDiagItemData.GetAt("DiagnosICDDesc")
					//诊断状态 疑诊、确诊
					if (tmpDiagItemData.GetAt("DiagnosStatus") = "疑诊")
					{
						s result = result _ "?"
					}
					//备注
					if ((tmpDiagItemData.GetAt("DiagnosNotes") '= "")&&(tmpDiagItemData.GetAt("DiagnosNotes") '= $lb("")))
					{
						
						if (memosep = "()")
						{
							s memoList = tmpDiagItemData.GetAt("DiagnosNotes")
							if (tmpDiagItemData.GetAt("MRCIDCode") = "")
							{
								s result = result _ $list(memoList,1)
							}
							else
							{
								s result = result _ "("_$list(memoList,1)_")"
							}
						}
						else
						{
							s result = result _ memosep _ tmpDiagItemData.GetAt("DiagnosNotes")
						}
			        }
			            
			        s result = result _ separate
			        //定义上一个诊断的级别，用来计数
			        s preDiagLevel = level
				}
				if (schemetype = "row")
				{
					s result = $e(result,1,($l(result)-$l(separate,"^"))) _ "。"
				}
            
			}
		}
	}
			   
    Quit result
}

ClassMethod getSpace(level As %String, schemetype As %String) As %String
{
		s result = ""
		q:(level = 1) result
		
		//s result = $case(schemetype ,"row":"",:"    ")
		
		for i=1:1:(level-1)
		{
			s result = result_$case(schemetype ,"row":"",:"    ")
		}
		q result
}

/// 用来取XPath的具体值
ClassMethod GetXMLPathResults(pResults As %ListOfObjects(CLASSNAME="%XML.XPATH.Result")) As %String
{
    For tI=1:1:pResults.Count()
    {
	    Set tResult=pResults.GetAt(tI)
        Set tValue=tResult.Value
            
        // Test for value being a stream
        If $IsObject(tValue){
             Do tValue.OutputToDevice()
        } else {
             s retValue=tValue
        }
    }
    q retValue
}

/// 复制医生站的类
/// 获取患者本次就诊诊断列表
/// d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosEntryV8","DiagnosList",190)
/// d ##class(%ResultSet).RunQuery("EMR.DOC.HISInterface.PatientInfoAssist","DiagnosList",190)
/// 		if MRDesc'="" 
/// 		{	
/// 			//医生站代码因为MRDesc为字符串，通过$list取值导致绑定数据失败。
/// 			//将代码迁移到电子病历中管理，如果项目存在问题 与医生站代码同步后使用。
/// 			//s MRDesc=$LIST(MRDesc,1)
/// 			s MRDesc=MRDesc
/// 			
/// 		}
Query DiagnosList(MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "") As %Query(ROWSPEC = "MRCIDRowId:%String,MRDIARowId:%String,DiagnosCat:%String,DiagnosType:%String,DiagnosLeavel:%String,DiagnosICDDesc:%String,MainDiagFlag:%String,DiagnosNotes:%String,MRCIDCode:%String,DiagnosStatus:%String,id:%String,DiagnosOnsetDate:%String,DiagnosDate:%String,SyndromeDesc:%String,MRDIAMRDIADR:%String,DiagnosStatusRowId:%String,DiagnosTypeRowId:%String,DiagnosDoctor:%String,DiagnosBodyPart:%String,DiagnosBodyPartRowId:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", LogonCTLocRowId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosEntryV8","DiagnosList","634",,,63)
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(MRADMID="") $$$OK
	
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",repid)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" {
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",DiagnosTypeCode,0))
	}
	s Id=0
	//Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	Set obj=##class(%ResultSet).%New("EMR.DOC.HISInterface.PatientInfoAssist:Find")
	
	d obj.Execute(MRADMID)
	For  
	{
		Quit:'obj.Next()
		s Desc=obj.Data("MRDIAICDCodeDRDesc")
		s Rowid=obj.Data("ID")
		s MRDiagnosTypeDesc=""
		s MRDiagnosTypeDr=""
		S MRdiagnosNoteDr=""
		S MRdiagnosNoteDesc=""
		s MRdiagnosNoteSubRowid=""
		S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
		if SubRowid'="" 
		{
			s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
		}
		Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
		I MRDiagnosTypeDr'="" 
		{
			Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
		}
		S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
		I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
		s MRdiagnosNoteDesc=##class(ext.util.String).EvalJSON(MRdiagnosNoteDesc)
		s CodeRowid=obj.Data("MRDIAICDCodeDR")
		s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
		S MRDiagnosDate=obj.Data("MRDIADate")
		s MRdiagnosTime=obj.Data("MRDIATime")
		s MRAddLocDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
		s MRDIAMRDIADR=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",15)
		I MRDiagnosDate'="" 
		{
			Set MRDiagnosDate=##class(websys.Conversions).DateLogicalToHtml(MRDiagnosDate) //$zd(MRDiagnosDate,3)
		}
		I MRdiagnosTime'="" 
		{
			Set MRdiagnosTime=$zt(MRdiagnosTime,3)
		}
		s BillFlag1="" 
		s BillFlag3=""
		s DiagnosCat=""
		i CodeRowid'=""
		{
			s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
			s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
		
			i BillFlag3'="Y"
			{
				s DiagnosCat="西医"
			}
			elseif (BillFlag3="Y")&&(BillFlag1'="Y")
			{
				s DiagnosCat="中医"
			}
			else
			{
				s DiagnosCat="证型"
			}
		}
		else{
			s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
			
			i Questionnaire=1
			{
				s DiagnosCat="西医"
			}
			elseif (Questionnaire=2)
			{
				s DiagnosCat="中医"
			}
			elseif (Questionnaire=3)
			{
				s DiagnosCat="证型"
			}
			i DiagnosCat="" 
			{
				s DiagnosCat="西医"
			}
		}
		Q:(ICDType="1")&&(BillFlag3'="Y")

		s MainDiagFlag=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
		i MainDiagFlag="Y" 
		{
			s MainDiagFlag="是"
		}
		else
		{  
			s MainDiagFlag="否"
		}
		
		s MRDesc=obj.Data("MRDIADesc")
		
		if MRDesc'="" 
		{	
			//医生站代码因为MRDesc为字符串，通过$list取值导致绑定数据失败。
			//将代码迁移到电子病历中管理，如果项目存在问题 与医生站代码同步后使用。
			//s MRDesc=$LIST(MRDesc,1)
			s MRDesc=MRDesc
			
		}
		
		s DiagStat=""
		s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
		s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
		s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
		s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
		s:DIAOnsetDate'="" DIAOnsetDate=##class(websys.Conversions).DateLogicalToHtml(DIAOnsetDate) //$zd(DIAOnsetDate,3) //取发病日期
	
		if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
		if DiagnosNumber="" s DiagnosNumber=9999 //$g(^MR(3,"DIA",0))+1
		;tanjishan 慢病
		s NCDCode=$p($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DHC")),"^",10)
		s NCDDesc="" //..GetNCDDesc(NCDCode)
		;end
		.;描述有反斜杠会影响前台
		s MRDesc=$replace(MRDesc,"\","")
		s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp&nbsp&nbsp&nbsp" ;根椐级别加空格
    	s Desc=banlkSpace_Desc
    
    	s SyndromeDesc=##class(web.DHCDocDiagnosNew).GetDiaSyndDesc(Rowid)
    	i SyndromeDesc'="" s SyndromeDesc=$tr(SyndromeDesc,","," ")
		//i MainDiagFlag'="" s Desc=Desc_MainDiagFlag
		s DiagnosDoctor=""
	
		s DoctorDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",4)
    	i DoctorDr'="" s DiagnosDoctor=$P($G(^CTPCP(DoctorDr,1)),"^",2)
		s BodyPartDesc=""
    	s BodyPartDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",21)
    	i BodyPartDr'="" s BodyPartDesc=$List(^DHCEMRM.DicDiagnosPositionD(BodyPartDr),3)
		s TempArr("FindDiagnos",repid,DiagnosNumber,$P(Rowid,"||",2))=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MRDIAMRDIADR_"^"_NCDCode_"^"_NCDDesc_"^"_MainDiagFlag_"^"_SyndromeDesc_"^"_DiagStatDr_"^"_MRDiagnosTypeDr_"^"_DiagnosDoctor_"^"_BodyPartDesc_"^"_BodyPartDr
	}
	d obj.Close()
	
	
	//按顺序输出设置
	s TempDia=""
	s DiagnosNumber=0  
	f  {
		s DiagnosNumber=$O(TempArr("FindDiagnos",repid,DiagnosNumber)) 
		Q:DiagnosNumber=""
		s Temprowid=0 
		f {
			s Temprowid=$O(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid))
			q:Temprowid=""
			s DiagnosDesc=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",1)
			s DiagnosValue=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",2)
			s DiagnosCodeRowid=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",3)
			s DiagnosMRDesc=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",4)
			s DiagnosICDCode=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",5)
			s DiagnosType=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",6)
			s DiagnosNote=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",7)
			s DiagnosDate=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",8)
			s DiagnosOnsetDate=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",13)
			s DiagnosLeavel=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",11)
			s DiagStat=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",10)
			s DiagnosCat=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",14)
			s MRDIAMRDIADR=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",15)
			
			s NCDCode=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",16)
			s NCDDesc=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",17)
			s MainDiagFlag=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",18)
			s SyndromeDesc=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",19)
			
			s DiagStatDr=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",20)
			s MRDiagnosTypeDr=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",21)
			s DiagnosDoctor=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",22)
			s BodyPartDesc=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",23)
			s BodyPartDr=$p(TempArr("FindDiagnos",repid,DiagnosNumber,Temprowid),"^",24)
			
			s Id=Id+1
			Do OutputRow1
		}
	}
	k TempArr("FindDiagnos",repid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
     set Data=$lb(DiagnosCodeRowid,DiagnosValue,DiagnosCat,DiagnosType,DiagnosLeavel,DiagnosDesc,MainDiagFlag,DiagnosMRDesc,DiagnosICDCode,DiagStat,Id,DiagnosOnsetDate,DiagnosDate,SyndromeDesc,MRDIAMRDIADR,DiagStatDr,MRDiagnosTypeDr,DiagnosDoctor,BodyPartDesc,BodyPartDr)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
		//
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

Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Date,MRDIATime:%Time,MRDIADesc:%List,MRDIAUpdateUserDRSSUSRName")
{
	
	SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_ICD9CM_Code, MRDIA_Date, MRDIA_Time, MRDIA_Desc, MRDIA_UpdateUser_DR->SSUSR_Name
	FROM SQLUser.MR_Diagnos
	WHERE MRDIA_MRADM_ParRef = :mradm
}

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
	.
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
	.
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
	.
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
	.s TempArr("FindDiagnos",$j,DiagnosTypeNum,DiagnosNumber,IsChild,Rowid)=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_IsChild
	
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

/// Modified by Liuzhongwan
/// Desc     当手麻的接口传来同时做两个或以上手术时，在此将同时手术的数据拆分成多条手术数据
/// w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetANOperInfoSep("1016681")
ClassMethod GetANOperInfoSep(episodeID As %String, stDate As %String = "", endDate As %String = "") As %String
{
	s operInfo = "", tmpoperInfo = ""
	;set endDate1=$H+5             //正常情况下不用加天数，特殊情况下：当打印首页时可能病人还没有出院
	;set:endDate'="" endDate=$zd(endDate1,3)   //
	//临床组接口，获取手术信息流数据
	set stream = ##class(web.DHCANAdaptor).GetANOperation("","",episodeID,"","","","")
	Set reader = ##class(%XML.Reader).%New()
	Set sc=reader.OpenStream(stream)
	quit:($$$ISERR(sc)) ""
	//每个PatInfo节点的信息对应一个web.DHCANInterface类
	Do reader.Correlate("PatInfo","web.DHCANInterface")
	While reader.Next(.operObj,.sc) 
	{
		s OPAStatus = operObj.OPAStatus
		continue:(OPAStatus'="完成")&&(OPAStatus'="术毕")
		
		s OperIDs = operObj.OperId
		s OperNum = $l(OperIDs,"|")
		s tmpoperInfo = ""
		for OperIndex = 1:1:OperNum
		{
			s:(tmpoperInfo'="") tmpoperInfo = tmpoperInfo_"#"
			s tmpoperInfo = tmpoperInfo_operObj.OpDate_"@"	;手术日期 1
			s tmpoperInfo = tmpoperInfo_operObj.OPAStartDateTime_"@"	;手术开始日期 2
			s tmpoperInfo = tmpoperInfo_operObj.OPAEndDateTime_"@"	;手术结束时间 3
			s tmpoperInfo = tmpoperInfo_operObj.PlanOPAStartDateTime_"@"	;计划手术开始时间 4	
			s tmpoperInfo = tmpoperInfo_operObj.PlanOPAEndDateTime_"@"	;计划结束时间 5
			s tmpoperInfo = tmpoperInfo_$p(operObj.OperId,"|",OperIndex)_"@"	//手术码表Id,多个以"|"分割 6
			s tmpoperInfo = tmpoperInfo_$p(operObj.OpName,",",OperIndex)_"@"	;手术名称，多个以","分割 7
			s tmpoperInfo = tmpoperInfo_operObj.ANAOPPreopDiag_"@"	;术前诊断 8
			s tmpoperInfo = tmpoperInfo_operObj.PatName_"@"	;姓名9
			s tmpoperInfo = tmpoperInfo_operObj.Age_"@"	;年龄 10
			s tmpoperInfo = tmpoperInfo_operObj.Sex_"@"	;性别 11
			s tmpoperInfo = tmpoperInfo_operObj.Birthday_"@"	;出生日期 12
			s tmpoperInfo = tmpoperInfo_operObj.PaAdmType_"@"	;病人类型 13
			s tmpoperInfo = tmpoperInfo_operObj.Ward_"@"	;病区 14
			s tmpoperInfo = tmpoperInfo_operObj.Bed_"@"	;床位 15
			s tmpoperInfo = tmpoperInfo_operObj.BedRoom_"@"	;床位所在房间号 16
			s tmpoperInfo = tmpoperInfo_operObj.PatLoc_"@"	;病人所在科室 17
			s tmpoperInfo = tmpoperInfo_operObj.ANAOPSurgeonDR_"@"	;手术医师Id 18
			s tmpoperInfo = tmpoperInfo_operObj.ANAOPSurgeon_"@"	;手术医师 19
			s tmpoperInfo = tmpoperInfo_operObj.AssistantFirstCtcpId_"@"	;一助ID 20
			s tmpoperInfo = tmpoperInfo_operObj.AssistantFirstCtcp_"@"	;一助描述 21
			s tmpoperInfo = tmpoperInfo_operObj.AssistantSecondCtcpId_"@"	;二助ID 22
			s tmpoperInfo = tmpoperInfo_operObj.AssistantSecondCtcp_"@"	;二助描述 23
			s tmpoperInfo = tmpoperInfo_operObj.AnaMethod_"@"	;麻醉方法24
			s tmpoperInfo = tmpoperInfo_operObj.AnaDocCtcpId_"@"	;麻醉医师Id 25
			s tmpoperInfo = tmpoperInfo_operObj.AnaDoctor_"@"	;麻醉医师 26
			s tmpoperInfo = tmpoperInfo_operObj.ScrubNurFirstCtcpId_"@"	;器械护士一 27
			s tmpoperInfo = tmpoperInfo_operObj.ScrubNurFirstCtcp_"@" ;28
			s tmpoperInfo = tmpoperInfo_operObj.ScrubNurSecondCtcpId_"@"	;器械护士二 29
			s tmpoperInfo = tmpoperInfo_operObj.ScrubNurSecondCtcp_"@" ;30
			s tmpoperInfo = tmpoperInfo_operObj.ScrubNurThirdCtcpId_"@"
			s tmpoperInfo = tmpoperInfo_operObj.ScrubNurThirdCtcp_"@"
			s tmpoperInfo = tmpoperInfo_operObj.CirculNurFirstCtcpId_"@"	;巡回护士一 33
			s tmpoperInfo = tmpoperInfo_operObj.CirculNurFirstCtcp_"@" ;34
			s tmpoperInfo = tmpoperInfo_operObj.CirculNurSecondCtcpId_"@"	;巡回护士二 35
			s tmpoperInfo = tmpoperInfo_operObj.CirculNurSecondCtcp_"@"
			s tmpoperInfo = tmpoperInfo_operObj.CirculNurThirdCtcpId_"@"	;巡回护士三 37
			s tmpoperInfo = tmpoperInfo_operObj.CirculNurThirdCtcp_"@"
			s tmpoperInfo = tmpoperInfo_operObj.BodsDesc_"@"	;手术部位 39
			s tmpoperInfo = tmpoperInfo_operObj.OperPosition_"@"	;手术体位40
			s tmpoperInfo = tmpoperInfo_operObj.OPAStatus_"@"	;状态41
			s tmpoperInfo = tmpoperInfo_operObj.StatCode_"@"	;状态代码 42
			s tmpoperInfo = tmpoperInfo_operObj.ANASourceTypeDesc_"@"	;类型 43
			s tmpoperInfo = tmpoperInfo_operObj.OPAPatDeptDr_"@"	;病人所在科室44
			s tmpoperInfo = tmpoperInfo_operObj.OPAAppLocDr_"@"	;申请科室 45
			s tmpoperInfo = tmpoperInfo_operObj.OPAOperLocDr_"@"	;手术室ID 46
			s tmpoperInfo = tmpoperInfo_operObj.OPAAppDate_"@"	;手术申请日期47
			s tmpoperInfo = tmpoperInfo_operObj.EpisodeID_"@"	;就诊号 48
			s tmpoperInfo = tmpoperInfo_operObj.RegNo_"@"	;登记号 49
			s tmpoperInfo = tmpoperInfo_operObj.MedCareNo_"@"	;病案号 50
			s tmpoperInfo = tmpoperInfo_operObj.OpaId_"@"	;手术Id 51
			s tmpoperInfo = tmpoperInfo_operObj.AnaesthesiaID_"@"	;麻醉Id 52
			s tmpoperInfo = tmpoperInfo_operObj.OPAOpRoomDr_"@"	;手术间Id 53
			s tmpoperInfo = tmpoperInfo_operObj.OPAOpRoom_"@"	;手术间描述 54
			s tmpoperInfo = tmpoperInfo_operObj.OPASeq_"@"	;手术台次55
			s tmpoperInfo = tmpoperInfo_operObj.OPAPATestHBsAg_"@" ;乙肝 56
			s tmpoperInfo = tmpoperInfo_operObj.OPAPATestHCVAb_"@"	;丙肝 57
			s tmpoperInfo = tmpoperInfo_operObj.OPAPATestHivAb_"@"	;HIV 58
			s tmpoperInfo = tmpoperInfo_operObj.OPAPATestTPAb_"@"	;梅毒 59
			s tmpoperInfo = tmpoperInfo_operObj.OPAPATestOther_"@"	;其他 60
			s tmpoperInfo = tmpoperInfo_operObj.OPALabResult_"@"	;特殊感染 61
			s tmpoperInfo = tmpoperInfo_$p(operObj.ANAOPBladeTypeId,"|",OperIndex)_"@"	;刀口类型Id,多个以"|"分割 62
			s tmpoperInfo = tmpoperInfo_$p(operObj.ANAOPBladeType,",",OperIndex)_"@"	;刀口类型,多个以","分割 63
			s tmpoperInfo = tmpoperInfo_operObj.OPAArrangeUser_"@"	;安排者 64
			s tmpoperInfo = tmpoperInfo_operObj.OPAArrangeDate_"@"	;安排日期 65
			s tmpoperInfo = tmpoperInfo_operObj.OPAArrangeTime_"@"	;安排时间 66
			s tmpoperInfo = tmpoperInfo_operObj.InRoomTime_"@"	;入室时间 67
			s tmpoperInfo = tmpoperInfo_operObj.LeaveRoomTime_"@"	;离室时间 68
			s tmpoperInfo = tmpoperInfo_operObj.ANAStartDate_"@"	;麻醉开始日期 69
			s tmpoperInfo = tmpoperInfo_operObj.ANAStartTime_"@"	;麻醉开始时间 70
			s tmpoperInfo = tmpoperInfo_operObj.ANAEndDate_"@"	;麻醉结束日期 71
			s tmpoperInfo = tmpoperInfo_operObj.ANAEndTime_"@"	;麻醉结束时间 72
			s tmpoperInfo = tmpoperInfo_operObj.SurgeonStartDate_"@"	;手术医生开始手术日期 73
			s tmpoperInfo = tmpoperInfo_operObj.SurgeonStartTime_"@"	;手术医生开始手术时间 74
			s tmpoperInfo = tmpoperInfo_operObj.SurgeonEndDate_"@"	;手术医生结束手术日期 75
			s tmpoperInfo = tmpoperInfo_operObj.SurgeonEndTime_"@"	;手术医生结束手术时间 76
			s tmpoperInfo = tmpoperInfo_operObj.OPAPACUInTime_"@"	;入恢复室时间 77
			s tmpoperInfo = tmpoperInfo_operObj.OPAPACUOutTime_"@"	;离恢复室时间 78
			s tmpoperInfo = tmpoperInfo_$p(operObj.opLevelId,"|",OperIndex)_"@"	;手术级别Id,多个以"|"分割 79
			s tmpoperInfo = tmpoperInfo_$p(operObj.opLevelDesc,",",OperIndex)_"@"	;手术级别,多个以","分割 80
			s tmpoperInfo = tmpoperInfo_operObj.bloodType_"@"	;血型 81
			s tmpoperInfo = tmpoperInfo_operObj.OPAUseSelfBlood_"@"	;自体血回输 82
			s tmpoperInfo = tmpoperInfo_operObj.OPAExCirculation_"@"	;体外循环 83
			s tmpoperInfo = tmpoperInfo_operObj.ASA_"@"	;ASA分级 84
			s tmpoperInfo = tmpoperInfo_operObj.returnOpe_"@"	;重返手术 85
			s tmpoperInfo = tmpoperInfo_operObj.RejectReason_"@"	;拒绝原因 86
			s tmpoperInfo = tmpoperInfo_operObj.NorInstrument_"@"	;常规器械 87
			s tmpoperInfo = tmpoperInfo_operObj.SpeInstrument_"@"	;特殊器械 88
			;s tmpoperInfo = tmpoperInfo_operObj.StewardScore_"@"	;Steward评分 89
			;s tmpoperInfo = tmpoperInfo_operObj.Analgesia_"@"	;术后镇痛 90
			;s tmpoperInfo = tmpoperInfo_operObj.OperICDCode_"@"	 ;手术ICD码 91
			;s tmpoperInfo = tmpoperInfo_operObj.IsUsedAntibacterials_"@"	;是否预防使用抗菌药物 92
			;s tmpoperInfo = tmpoperInfo_operObj.IsOperaUseFlag_"@"	;是否术中追加使用 93
			;s tmpoperInfo = tmpoperInfo_operObj.Duration_"@"	;预防使用持续时间 94
			;s tmpoperInfo = tmpoperInfo_operObj.PRKillip_"@"	;预防使用持续时间 95
			;s tmpoperInfo = tmpoperInfo_operObj.UsedDrugDateTime	;给药时间 96
		}
		s:(operInfo'="") operInfo = operInfo_"#"
		s operInfo = operInfo_tmpoperInfo
	}
	
	q operInfo
}

/// 转换标准麻醉方式
/// w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).GetAnaMedhodDict("")
ClassMethod GetAnaMedhodDict(ADesc As %String) As %String
{
	q:(ADesc = "") "^^^"
	
	s (RowID,Code) = ""
	&SQL(SELECT ANMET_RowId, ANMET_Code into :RowID,:Code FROM SQLUser.ORC_AnaestMethod WHERE ANMET_Desc = :ADesc)
	
	q RowID_"^"_Code_"^"_ADesc
}

/// 判定是否复诊
/// w ##Class(EMR.DOC.HISInterface.PatientInfoAssist).IsRepeatAdm(1,1)
ClassMethod IsRepeatAdm(PapmiDR As %String, Adm As %String) As %String
{
	s result = "1^初诊"
	q:(PapmiDR="")||(Adm="") result

	s CurDeptDR = ""
	s CurDeptDR = $P($g(^PAADM(Adm)),"^",4)

	s arr = 0,PAADMRowID="",DeptDR = ""
	f PAADMRowID = $O(^PAPERdr(PapmiDR,"ADM","O",PAADMRowID)) q:(PAADMRowID="")  d
	.s DeptDR = $P($g(^PAADM(PAADMRowID)),"^",4)
	.q:(CurDeptDR'=DeptDR)
	.s arr = arr + 1

	s:(arr>1) result="2^复诊"

	q result
}

/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetOperInfoBySSJL(52)
ClassMethod GetOperInfoBySSJL(Adm)
{
	q:(Adm="") ""
	
	s tmpoper="",operInfo="",AOperCode="",AOperDesc="",AOperLevel=""
	
	s ALLOperDate ="" ;##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(Adm,"HDSD00.06.078","0")
	s ALLOperDesc ="" ;##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(Adm,"HDSD00.06.079","0")
	s ALLOperCode = "" ;##Class(EMRservice.BL.BLScatterData).GetDataByGlossaryNew(Adm,"HDSD00.06.074","0")
	
	s Length = $L(ALLOperDate,"/")
	For i = 1:1:Length
	{
		s AOperDesc = $P(ALLOperDesc,"/",i)
		
		For j = 1:1:$L(AOperDesc," ")
		{
			continue:$P(AOperDesc," ",j)=""
			s (OperDesc,OperDict,OperLevel)=""
			
			s OperDesc = $TR($P(AOperDesc," ",j),"[]","")
			s OperRowId = $O(^ORC("OPER",0,"Desc",OperDesc,""))
			if OperRowId'=""
			{
				s OperCode = $P(^ORC("OPER",OperRowId),"^",14)
				s OperDict = OperRowId_"^"_OperCode_"^"_$P(^ORC("OPER",OperRowId),"^",2)
				
				s OperLevelDR = $P(^ORC("OPER",OperRowId),"^",7)
				s OperLevel = OperLevelDR_"^"_$P(^ORC("CATEG",OperLevelDR),"^",1)_"^"_$P(^ORC("CATEG",OperLevelDR),"^",2)
			}
			continue:OperRowId=""
			
			s:tmpoper'="" tmpoper = tmpoper_"#"
			s tmpoper = tmpoper_$P($P(ALLOperDate,"/",i)," ",1)_"@"
			s tmpoper = tmpoper_OperDict_"@"
			s tmpoper = tmpoper_OperLevel
			w tmpoper,!
			
		}
		
		//s:(operInfo'="") operInfo = operInfo_"#"
		//s operInfo = operInfo_tmpoper
		s operInfo = tmpoper
	}
	
	q operInfo
}

/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatObservationsNew(31)
ClassMethod GetPatObservationsNew(EpisodeID) As %String
{
	s ret=""
	q:(EpisodeID="") ret
	S (FirstTemperatur,FirstPulse,FirstHeartbeat,FirstBreath,FirstSysPressure,FirstDiaPressure,FirstWeight,FirstHeight)=""
	S (LastTemperatur,LastPulse,LastHeartbeat,LastBreath,LastSysPressure,LastDiaPressure,LastWeight,LastHeight)=""
	            //体温^脉搏^心率^呼吸^收缩压^舒张压^体重^身高
	s SMTZTemp="temperature^pulse^heartbeat^breath^sysPressure^diaPressure^weight^height"
	for i=1:1:$l(SMTZTemp,"^") {
		S temp=$p(SMTZTemp,"^",i)
		S:(i=1) FirstTemperatur=$$getFirstItemValue(EpisodeID,temp)
		S:(i=2) FirstPulse=$$getFirstItemValue(EpisodeID,temp)
		S:(i=3) FirstHeartbeat=$$getFirstItemValue(EpisodeID,temp)
		S:(i=4) FirstBreath=$$getFirstItemValue(EpisodeID,temp)
		S:(i=5) FirstSysPressure=$$getFirstItemValue(EpisodeID,temp)
		S:(i=6) FirstDiaPressure=$$getFirstItemValue(EpisodeID,temp)
		S:(i=7) FirstWeight=$$getFirstItemValue(EpisodeID,temp)
		S:(i=8) FirstHeight=$$getFirstItemValue(EpisodeID,temp)
		
		S:(i=1) LastTemperatur=$$getLastItemValue(EpisodeID,temp)
		S:(i=2) LastPulse=$$getLastItemValue(EpisodeID,temp)
		S:(i=3) LastHeartbeat=$$getLastItemValue(EpisodeID,temp)
		S:(i=4) LastBreath=$$getLastItemValue(EpisodeID,temp)
		S:(i=5) LastSysPressure=$$getLastItemValue(EpisodeID,temp)
		S:(i=6) LastDiaPressure=$$getLastItemValue(EpisodeID,temp)
		S:(i=7) LastWeight=$$getLastItemValue(EpisodeID,temp)
		S:(i=8) LastHeight=$$getLastItemValue(EpisodeID,temp)
		}
		s FirstRet="体温:"_FirstTemperatur_"^"_"脉搏:"_FirstPulse_"^"_"心率:"_FirstHeartbeat_"^"_"呼吸:"_FirstBreath_"^"_"收缩压:"_FirstSysPressure_"^"_"舒张压:"_FirstDiaPressure_"^"_"体重:"_FirstWeight_"^"_"身高:"_FirstHeight
		s LastRet="体温:"_LastTemperatur_"^"_"脉搏:"_LastPulse_"^"_"心率:"_LastHeartbeat_"^"_"呼吸:"_LastBreath_"^"_"收缩压:"_LastSysPressure_"^"_"舒张压:"_LastDiaPressure_"^"_"体重:"_LastWeight_"^"_"身高:"_LastHeight
		S ret=FirstRet_"@"_LastRet
		Q ret
getFirstItemValue(code,flag)
    s ret=""
	q:(code="") ret
	s ret=##Class(Nur.CommonInterface.Temperature).getFirstItemValue(code,flag)
	q ret
getLastItemValue(code,flag)
	q:(code="") ret
	s ret=##Class(Nur.CommonInterface.Temperature).getLastItemValue(code,flag)
	q ret
}

/// lifengbo
/// 20200427
/// 通过就诊号获取病案号，封装统一接口，产品组内使用
/// debugger:w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(82)
ClassMethod GetMRNoByEpisodeID(AEpisodeID As %String = "") As %String
{
	s returnValue=""
	q:(AEpisodeID="") returnValue
	
	s ErrMsg = ""
	s MedType = $p($g(^PAADM(AEpisodeID)),"^",2)
	
	s returnValue=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(AEpisodeID,MedType,.ErrMsg)
	
	q returnValue
}

/// lifengbo
/// 20200427
/// 通过就诊号获取病案号，封装统一接口，产品组内使用
/// debugger:w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetMRNoByPatientID(AEpisodeID)
ClassMethod GetMRNoByPatientID(APatientID As %String = "") As %String
{
	s returnValue=""
	q:(APatientID="") returnValue
	
	s ErrMsg = ""
	s MedType = "I"
	
	//获取方式
	/*
		s HospitalID=$piece($get(^CTLOC($p(LocID,"^",1))),"^",22)
		s Hospital=$p($g(^CT("HOSP",HospitalID)),"^",2)  
	*/
	s HosptialID = $o(^CT("HOSP",""))
	
	s returnValue=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(APatientID,MedType,HosptialID,.ErrMsg)
	
	q returnValue
}

/// lifengbo
/// 20200427
/// 通过病案号获取PatientID，封装统一接口，产品组内使用
/// debugger:w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetPatientIDByMRNo(AMRNo)
ClassMethod GetPatientIDByMRNo(AMRNo As %String = "") As %String
{
	s returnValue=""
	q:(AMRNo="") returnValue
	 
	s ErrMsg = ""
	
	//获取方式,无就诊号
	s MedType = "I"
	
	//获取方式
	/*
		s HospitalID=$piece($get(^CTLOC($p(LocID,"^",1))),"^",22)
		s Hospital=$p($g(^CT("HOSP",HospitalID)),"^",2)  
	*/
	s HosptialID = $o(^CT("HOSP",0))
	
	s returnValue=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(AMRNo,MedType,HosptialID,.ErrMsg)
	
	q returnValue
}

/// yejian
/// 2020-11-16
/// Desc:	从demo医院数据维护中取医院logo
/// w ##class(EMR.DOC.HISInterface.PatientInfoAssist).HospitalLogo(50)
ClassMethod HospitalLogo(argAdm As %String = "")
{
	s HospitalID="",LocID="",HospitalLogo=""
	s LocID=..CurrentDept(argAdm)
	if LocID="" quit HospitalID
	s HospitalID=$piece($get(^CTLOC($p(LocID,"^",1))),"^",22)
	s HospitalLogo=$g(^CT("HOSP",HospitalID,"IMG"))
	quit HospitalLogo
}

/// Desc:       获取用户名称
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserCode  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetUserNameByCode("YS01")
ClassMethod GetUserNameByCode(aUserCode As %String) As %String
{
	q:(($d(aUserCode)=0)||(aUserCode="")) ""
	
	s strUserName = ""
	s strUserID =$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(aUserCode,"U"),""))
	q:(strUserID = "") strUserName
	s strUserName = $p($g(^SSU("SSUSR",strUserID)),"^",2)
	//&SQL(select ssusr_name into :strUserName  from SQLUser.SS_User where ssusr_initials = :initial)
	q strUserName
}

/// Desc:       根据就诊号获取患者感染四项数据接口
/// Creator:    wangyu
/// CreateDate: 2021-05-08
/// Input:      admId  就诊号
/// OutPut:     感染四项数据
/// Debug:      w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetLabInfo("1")
ClassMethod GetLabInfo(admId As %String, AFlag As %String = "") As %String
{
	s admId = "1"
	s json = ""
    q:admId="" json
    //s admId=$p(admId,"^",2)
    q:$o(^OEORD(0,"Adm",admId,""))="" json
    s labInfoStr=""
    s papmiId=$p($g(^PAADM(admId)),"^",1)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	///s TCSync0="ABO",TCSync1="RH",TCSync6="ALT",TCSync8="HBSAG",TCSync12="ANTIHCV",TCSync13="ANTIHIV",TCSync14="TPHA"
	///S BloodTypeStr=##class(LabService.TCResult).GetTCResultByRegNo(regNo,"ABO")
	///s BloodType=$p(BloodTypeStr,$c(2),3)
	//i BloodType="" s BloodType=$p(BloodType1,"RH",1)
	///S RHBloodTypeStr=##class(LabService.TCResult).GetTCResultByRegNo(regNo,"RH")
	///s RHBloodType=$p(RHBloodTypeStr,$c(2),3)
	///i RHBloodType["阴性" s RHBloodType="阴性(-)"
	///e  i RHBloodType'="" s RHBloodType="阳性(+)"
	///s LabALTStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"ALT")
	///s LabALT=$p(LabALTStr,$c(2),3)
	;乙肝
	s LabHBSAG=""
	s LabHBSAGStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"HBsAg")
	s LabHBSAGValue=$p(LabHBSAGStr,$c(2),3)
	s LabHBSAGRange=$p(LabHBSAGStr,$c(2),6)
	S maxLabHBSAG=$p(LabHBSAGRange,"-",2)
	;i $p(LabHBSAGRange,"~",1)="" s maxLabHBSAG=$p(LabHBSAGRange,"~",2)
	i maxLabHBSAG="" s LabHBSAG=LabHBSAGValue
	e  i ((LabHBSAGValue'="")&(maxLabHBSAG'="")) d
		.i (LabHBSAGValue>maxLabHBSAG) s LabHBSAG="HBsAg:阳性(+)"
		.e  s LabHBSAG="HBsAg:阴性(-)"
	;s:(LabHBSAG'="") labInfoStr=labInfoStr_LabHBSAG_","
	;丙肝
	s LabHCVAB=""	
	s LabHCVABStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"HCV-Ab")
	s LabHCVABValue=$p(LabHCVABStr,$c(2),3)
	s LabHCVABRange=$p(LabHCVABStr,$c(2),6)
	S maxLabHCVAB=$p(LabHCVABRange,"-",2)
	;i $p(LabHBSAGRange,"~",1)="" s maxLabHBSAG=$p(LabHBSAGRange,"~",2)
	i maxLabHCVAB="" s LabHCVAB=LabHCVABValue
	e  i ((LabHCVABValue'="")&(maxLabHCVAB'="")) d
		.i (LabHCVABValue>maxLabHCVAB) s LabHCVAB="HCV-Ab:阳性(+)"
		.e  s LabHCVAB="HCV-Ab:阴性(-)"
	;s:(LabHCVAB'="") labInfoStr=labInfoStr_LabHCVAB_","
	;HIV
	s LabHIVAB = ""
	s LabHIVABStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"HIV-Ab")
	s LabHIVAB=$p(LabHIVABStr,$c(2),3)
	i ((LabHIVAB["大于临界值")!(LabHIVAB["阳性")) s LabHIVAB="HIV-Ab:阳性(+)"
	e  i LabHIVAB'="" s LabHIVAB="HIV-Ab:阴性(-)"
	;s:(LabHIVAB'="") labInfoStr=labInfoStr_LabHIVAB_","
	;梅毒
	s Labchmd=""
	s LabchmdStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"TPAb")
	s LabchmdValue=$p(LabchmdStr,$c(2),3)
	s LabchmdRange=$p(LabchmdStr,$c(2),6)
	S maxLabchmd=$p(LabchmdRange,"-",2)
	;i $p(LabchmdRange,"~",1)="" s maxLabchmd=$p(LabchmdRange,"~",2)
	i maxLabchmd="" s Labchmd=LabchmdValue
	e  i ((LabchmdValue'="")&(maxLabchmd'="")) d
		.i (LabchmdValue>maxLabchmd) s Labchmd="TPAb:阳性(+)"
		.e  s Labchmd="TPAb:阴性(-)"
	;s:(Labchmd'="") labInfoStr=labInfoStr_Labchmd
	
	//s LabHBSAG = "HBsAg:阳性(+)"
	//s LabHCVAB = "HCV-Ab:阴性(-)"
	//s LabHIVAB = "HIV-Ab:阳性(+)"
	//s Labchmd = "TPAb:阳性(+)"
	
	s InfectedStr = LabHBSAG_","_LabHCVAB_","_LabHIVAB_","_Labchmd
	
	s json = ""
	s json = json_"{"
	s json = json_"""LabHBSAG"":"""_LabHBSAG_""","
	s json = json_"""LabHCVAB"":"""_LabHCVAB_""","
	s json = json_"""LabHIVAB"":"""_LabHIVAB_""","
	s json = json_"""Labchmd"":"""_Labchmd_""""
	s json = json_"}"
	if (AFlag ="1")
	{
		q InfectedStr
	}
	else
	{
		q json
	}
}

/// Desc:	取指定就诊号对应的MRAdmID
ClassMethod GetMainMRADMDR(argEpisodeID As %String) As %String
{
	s ret = ""
	q:(argEpisodeID = "") ret
	
	s MainMRADMDR = $p($g(^PAADM(argEpisodeID)),"^",61)
	q:(MainMRADMDR = "") ret
	s ret = MainMRADMDR
	q ret
}

/// Desc:获取患者卡号
/// Creator:    lifengbo
/// CreateDate: 2023-04-13
/// Input:      argEpisodeID  就诊号
/// OutPut:     卡号
/// Debug:      w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetCardNo("1")	
ClassMethod GetCardNo(argEpisodeID As %String) As %String
{
	s ret = ""
	q:(argEpisodeID = "") ret
	s cardNo=""
	s cardRowId = $o(^DHCCARDi("CF",0,"PAPMIDR",argEpisodeID,"")) 
	s:(cardRowId '= "") cardNo = $p(^DHCCARD("CF",cardRowId),"^",2)
	s ret = cardNo
	q ret
}

/// Desc:获取患者保密级别相关信息
/// Creator:    lifengbo
/// CreateDate: 2023-04-13
/// Input:      argEpisodeID  就诊号
/// OutPut:     保密级别相关信息
/// Debug:      w ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetSecurity("1")
ClassMethod GetSecurity(argEpisodeID As %String) As %String
{
	s ret = ""
	q:(argEpisodeID = "") ret
	
	s patientID = ..GetPapmiDR(argEpisodeID)
	
	s PatEncryptLevelStr = ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patientID)
	
	s SecAlias = $P(PatEncryptLevelStr, "^",1)
	s EmployeeFunction = $P(PatEncryptLevelStr, "^",2)
	s SecCode = $P(PatEncryptLevelStr, "^",3)
	s SecDesc = $P(PatEncryptLevelStr, "^",4)

	
	s SecurityData = SecAlias_"^"_EmployeeFunction_"^"_SecCode_"^"_SecDesc

	s ret = SecurityData 
	q ret
}

}
