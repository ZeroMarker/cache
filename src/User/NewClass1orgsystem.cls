Class User.NewClass1orgsystem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator:	HouJian
/// CreateDate:	2009-03-17
/// Desc:		[BOQueryDataService类的病人就诊信息接口]获取病人就诊信息
/// Input： 	argItemName: 就诊信息项的名称，对应于 [维护程序--〉工具--〉就诊数据项维护] 中的 [ADM字段名称]
///        		argEpisodeId: 病人就诊rowid
/// Return：    就诊信息项的Value(不含Code)
ClassMethod GetEpisodeInfoByItemName(argItemName As %String, argEpisodeId As %String) As %String
{
	quit:($d(argItemName)=0||$d(argEpisodeId)=0) ""
	set ReturnValue=""
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PapmiDR= ##class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(argEpisodeId) 
  	
  	///s MeddataName=##class(EPRmeta.SysOption).GetOptionValueByName("Meddata")
	///if MeddataName=""
	///{	s MeddataName="Meddata"}
	///s LabdataName=##class(EPRmeta.SysOption).GetOptionValueByName("Labdata")
	///if LabdataName=""
	///{	s LabdataName="Labdata"}
	
	
	///由就诊项的字段名取值
	if argItemName="EpisodeID"
	{
		set ReturnValue=argEpisodeId
	}
	elseif argItemName="DisDateTime"            ///出院日期,返回cache内部格式,必须
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeId,Hospital)
		set ReturnValue=$p(ReturnValue," ",1)
	}
	elseif argItemName="AdmDateTime"		///入院日期,返回cache内部格式，必须
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeId,Hospital)
		set ReturnValue=$p(ReturnValue," ",1)
	}
	elseif argItemName="PayType"			///付费方式
	{	
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).PayType(argEpisodeId,Hospital)
	}
	elseif argItemName="Gender"				///性别		
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Gender(PapmiDR)
		set ReturnValue=$p(ReturnValue,"^",2)
	}	
	elseif argItemName="MaritalStatus"		///婚姻
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).MaritalStatus(PapmiDR)
		set ReturnValue=$p(ReturnValue,"^",2)
	}		
	elseif argItemName="Birthday"			///出生日期
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)
	}			
	elseif argItemName="Occupation"			///职业
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PapmiDR,Hospital)
		set ReturnValue=$p(ReturnValue,"^",2)
	}				
	elseif argItemName="Age"				///年龄
	{
		//勿用
		s MeddataName=##class(EPRmeta.SysOption).GetOptionValueByName("Meddata")
		if MeddataName=""
		{	s MeddataName="Meddata"}
		set TempBirthDay=##class(EPRservice.HISInterface.PatientInfoAssist).Birthday(PapmiDR)	
  		set TempAdmDate=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeId,Hospital)	
  		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Age(TempBirthDay,TempAdmDate,MeddataName,argEpisodeId)
	}	
	elseif argItemName="Nation"				///民族
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Nation(PapmiDR,Hospital)
		set ReturnValue=$p(ReturnValue,"^",2)
	}	
	elseif argItemName="AdmDept"			///入院科室
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(argEpisodeId)
		s ReturnValue=$p(ReturnValue,"^",2)	 
	}	
	elseif argItemName="AdmWard"			///入院病区
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).AdmWard(argEpisodeId)
		s ReturnValue=$p(ReturnValue,"^",2)	 
	}	
	elseif argItemName="DisDept"			///出院科室
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).DisDept(argEpisodeId)
		s ReturnValue=$p(ReturnValue,"^",2)	 
	}	
	elseif argItemName="DisWard"			///出院病区
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).DisWard(argEpisodeId)
		s ReturnValue=$p(ReturnValue,"^",2)	 
	}	
	elseif argItemName="TransDept"			///转科
	{
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).TransDept(argEpisodeId)
	}	
	elseif argItemName="ResidentDays"		///住院天数
	{
		set TmpAdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeId,Hospital)
		set TmpDisDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeId)
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).ResidentDays(TmpAdmDateTime,TmpDisDateTime)
	}
	elseif argItemName="BloodType"			///血型
	{
		//勿用
		s MeddataName=##class(EPRmeta.SysOption).GetOptionValueByName("Meddata")
		if MeddataName=""
		{	s MeddataName="Meddata"}
		s LabdataName=##class(EPRmeta.SysOption).GetOptionValueByName("Labdata")
		if LabdataName=""
		{	s LabdataName="Labdata"}
		set ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).ImmuneExamBloodType(PapmiDR,Hospital,MeddataName,LabdataName)
	}
	elseif argItemName="PatName"
	{
		s ReturnValue=##class(EPRservice.HISInterface.PatientInfoAssist).Name(PapmiDR)
	}
		
	quit ReturnValue
}

/// d ##Class(EPRservice.SystemData).testpatient()
/// //////////////////////////////////////////////////////[HIS]病人基本信息
ClassMethod GetPatientInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 病人标识号大类
 s papmidr="",paperdr="",RegisterNo="",Medicare="",OMedicare="",EMedicare="",IDCard="",InsuranceNo=""
 
 
 ;EPR> 出院入院情况大类(作用:计算病人年龄)
 s AdmDateTime="",AdmDate="",AdmTime=""
 
 
 ;EPR> 病人基本情况大类
 s Name="",Sex="",Birthday="",ArgBirthday="",Age="",AgeDay="",MedicareAgeYear="",MedicareAge="",MedicareAgeUnit="",Marriage="",Native="",CityBirth="",ProvinceBirth="",Occupation="",Nation="",Nationality="",PayMode="",MoubilePhone=""


 ;EPR> 工作情况/户口情况/联系人情况大类
 s LinkName="",LinkRelation="",LinkAddress="",LinkPhone=""
 s WorkAddress="",WorkTel="",WorkPostalCode=""
 s HuKouAddress="",HuKouTel="",HuKouPostalCode=""



 ;EPR> 病人出入院情况大类
 s AdmDoctor="",AdmDateTime="",AdmDate="",AdmTime="",AdmDateTimeInBed="",AdmDateInBed="",AdmTimeInBed="",InTimes="",AdmDept="",AdmWard="",AdmBed=""
 s DischgDateTime="",DischgDate="",DischgTime="",DischgDept="",DischgWard="",DischgBed=""
 s TransDept="",TransDeptDetail="",TransDeptInterface="",TransDeptFirstTime="",TransDeptFirstDept=""
 s ResidentDays=""
 s DeathDateTime="",DeathDate="",DeathTime=""
 s MRDisDateTime="",MRDisDate="",MRDisTime=""
 
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;EPR> 病人标识号大类
 
 
 
 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)
 
 ;EPR> 登记号 PA_PatMas.PAPMI_No
 s RegisterNo = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiNo(papmidr)
 
 ;EPR> 住院病案号 PA_PatMas.PAPMI_Medicare
 s Medicare = ##class(EPRservice.HISInterface.PatientInfoAssist).IMedicare(papmidr,"DiTan")
 
 ;EPR> 门诊病案号 PA_Person.PAPER_GovernCardNo
 s OMedicare = ##class(EPRservice.HISInterface.PatientInfoAssist).OMedicare(paperdr,"DiTan")

 ;EPR> 急诊病案号 DHC_Person.PAPER_FCMedicareCode1
 s EMedicare = ##class(EPRservice.HISInterface.PatientInfoAssist).EMedicare(paperdr,"DiTan")
 
 ;EPR> 身份证号 PA_Person.PAPER_ID
 s IDCard=##Class(EPRservice.HISInterface.PatientInfoAssist).IDCard(paperdr)
 
 ;EPR> 医保号 PA_Person.PAPER_ID
 s InsuranceNo=##Class(EPRservice.HISInterface.PatientInfoAssist).InsuranceNo(adm,"DiTan")

 
 
 
 
 ;EPR> 出院入院情况大类(作用:计算病人年龄)
 
 
 
 
 ;EPR> 入院日期时间 PAADM_AdmDate And PAADM_AdmTime
 s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(adm,"DiTan")
 i AdmDateTime'="" 
 { 
   ;EPR> 入院日期内部格式
   s AdmDate = $P($G(AdmDateTime)," ",1)
   
   ;EPR> 入院时间内部格式 
   s AdmTime = $P($G(AdmDateTime)," ",2)
 }  
 
 
 
 
 ;EPR> 病人基本情况大类



 
 ;EPR>  姓名 PA_Person.PAPER_Name
 s Name=##Class(EPRservice.HISInterface.PatientInfoAssist).Name(paperdr)

 ;EPR>  性别 PA_Person.PAPER_Sex_DR ->
 s SexDic=""
 s Sex=##Class(EPRservice.HISInterface.PatientInfoAssist).Gender(paperdr,"DiTan")
 i Sex'="" 
 { 
 	s Sex=$p($g(Sex),"^",3)
 	s SexDic=$p($g(Sex),"^",1)_"^"_Sex
 	}
 
 ;EPR> 出生日期 PA_Person.PAPER_Dob
 s Birthday=##Class(EPRservice.HISInterface.PatientInfoAssist).Birthday(papmidr)
 i Birthday'=""
 {
   ;EPR> 出生日期内部格式 PA_Person.PAPER_Dob 
   s ArgBirthday=Birthday
   ;EPR> 出生日期外部格式 PA_Person.PAPER_Dob
   s Birthday=$zd(Birthday,3)
   	 
 }
 
 ;EPR> 病案年龄 Age>=1  Show 岁  Age<1岁  Show 月  Age<1月 Show 天
 ;EPR> 临床年龄 Age>=14 Show 岁  Age<14 Show 岁月  Age<1 Show 天
 s Age = ##class(EPRservice.HISInterface.PatientInfoAssist).Age(ArgBirthday,AdmDate,"DHC-APP",adm,"DiTan")
 i Age'="" 
 { 
   ;EPR> 病案年龄岁
   s MedicareAgeYear = $P($G(Age),"^",5) 
   
   ;EPR> 临床新生儿年龄天
   s AgeDay = $P($G(Age),"^",4) 
   
   ;EPR> 病案年龄单位 
   s MedicareAgeUnit = $P($G(Age),"^",3)
   
   ;EPR> 病案年龄
   s MedicareAge = $P($G(Age),"^",2)
   
   ;EPR> 临床年龄
   s Age = $P($G(Age),"^",1) 
 
 }
 
 ;EPR>  婚姻状况 PA_Person.PAPER_Marital_DR ->
 s Marriage=##Class(EPRservice.HISInterface.PatientInfoAssist).MaritalStatus(paperdr)
 i Marriage'="" { s Marriage= $p($g(Marriage),"^",2) }

 ;EPR>  籍贯/城市/省份  PA_Person.PAPER_Province_Birth_DR And PA_Person.PAPER_CityBirth_DR
 s Native=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(papmidr,"DiTan")
 i Native'=""
 {
   ;EPR>  出生地城市 PA_Person.PAPER_CityBirth_DR ->
   s CityBirth = $p($g(Native),"!",3)
   i CityBirth="^" { s CityBirth="" }
 
   ;EPR>  出生地省份 PA_Person.PAPER_Province_Birth_DR ->
   s ProvinceBirth = $p($g(Native),"!",2)
   i ProvinceBirth="^" { s ProvinceBirth="" }
 
   ;EPR>  籍贯
   s Native = $p($g(Native),"!",1)
 }
 
 ;EPR>  职业 PA_Person.PAPER_Occupation_DR ->
 s Occupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(paperdr,"DiTan")

 ;EPR> 民族 PA_Person.PAPER_Nation_DR -> SQLUser.CT_Nation
 s Nation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(paperdr,"DiTan")
 
 ;EPR>  国籍 PA_Person.PAPER_Country_DR
 s Nationality=##Class(EPRservice.HISInterface.PatientInfoAssist).Nationality(paperdr,"DiTan")

 ;EPR> 付款方式 PAADM_AdmReason_DR -> 
 s PayMode=##Class(EPRservice.HISInterface.PatientInfoAssist).PayType(adm,"DiTan")

 ;EPR>  手机电话 PA_Person.PAPER_MobPhone
 s MoubilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MoubilePhone(paperdr,"DiTan")





 ;EPR> 工作情况/户口情况/联系人情况大类
 
 
 
 
 ;EPR> 联系人姓名 PA_Person.PAPER_ForeignId
 s LinkName = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanName(paperdr,"DiTan")
 
 ;EPR> 联系人关系 PA_Person.PAPER_CTRLT_DR -> SQLUser.CT_Relation
 s LinkRelation = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanRelation(paperdr,"DiTan")

 ;EPR> 联系人地址 PA_Person.PAPER_ForeignAddress
 s LinkAddress = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanAddress(paperdr,"DiTan")
 
 ;EPR> 联系人电话 PA_Person.PAPER_ForeignPhone
 s LinkPhone = ##class(EPRservice.HISInterface.PatientInfoAssist).LinkmanPhone(paperdr,"DiTan")

 ;EPR>  工作单位地址 PA_Person.PAPER_SecondPhone
 s WorkAddress=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkAddress(paperdr,"DiTan")
 
 ;EPR>  工作电话 PA_Person.PAPER_TelH
 s WorkTel=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkPhone(paperdr,"DiTan")
 
 ;EPR>  工作邮编 DHC_Person.PAPER_Comment2
 s WorkPostalCode=##Class(EPRservice.HISInterface.PatientInfoAssist).WorkPostalCode(paperdr,"DiTan")

 ;EPR>  户口所在地址 PA_Person.PAPER_StName
 s HuKouAddress=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouAddress(paperdr,"DiTan")
 
 ;EPR>  户口电话 PA_Person.PAPER_TelO
 s HuKouTel=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouPhone(paperdr,"DiTan")

 ;EPR>  户口邮编 DHC_Person.PAPER_Comment1
 s HuKouPostalCode=##Class(EPRservice.HISInterface.PatientInfoAssist).HuKouPostalCode(paperdr,"DiTan")




 ;EPR> 病人出入院情况大类
 
 
 
 
 ;EPR> 入院医生 PA_Adm.PAADM_AdmDocCodeDR ->
 s AdmDoctor=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDoctor(adm,"DiTan")


 ;EPR> 入院日期时间 PAADM_AdmDate And PAADM_AdmTime
 s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(adm,"DiTan")
 i AdmDateTime'="" 
 { 
   ;EPR> 入院日期
   s AdmDate = $ZD($P($G(AdmDateTime)," ",1),3)
   
   ;EPR> 入院时间 
   s AdmTime = $ZT($P($G(AdmDateTime)," ",2),1)
   
   ;EPR> 入院日期时间
   s AdmDateTime=AdmDate_" "_AdmTime
   s AdmDate =AdmDate_" "_"00:00:00"
 }  
 
 
  ;EPR> 入院日期时间(分配床位) 
 s AdmDateTimeInBed=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTimeInBed(adm,"DiTan")
 i AdmDateTimeInBed'="" 
 { 
   ;EPR> 入院日期(分配床位)
   s AdmDateInBed = $ZD($P($G(AdmDateTimeInBed)," ",1),3)
   
   ;EPR> 入院时间(分配床位)
   s AdmTimeInBed = $ZT($P($G(AdmDateTimeInBed)," ",2),1)
   
   ;EPR> 入院日期时间(分配床位)
   s AdmDateTimeInBed=AdmDateInBed_" "_AdmTimeInBed
 }  

 ;EPR> 入院次数
 s InTimes=##Class(EPRservice.HISInterface.PatientInfoAssist).InTimes(adm,"DiTan") 

 ;EPR> 入院科室
 s AdmDept=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmDept(adm,"DiTan") 

 ;EPR> 入院病区
 s AdmWard=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmWard(adm,"DiTan") 

 ;EPR> 入院床号
 s AdmBed=##Class(EPRservice.HISInterface.PatientInfoAssist).AdmBed(adm) 
 
 
 ;EPR> 转科情况
 s TransDept=##Class(EPRservice.HISInterface.PatientInfoAssist).TransDept(adm) 
 
 
 ;EPR> 转科情况明细
 s TransDeptDetail=##Class(EPRservice.HISInterface.PatientInfoAssist).TransDeptDetail(adm,"DiTan") 


 ;EPR> 转科情况病案接口第一次 转科科室 及 转科时间
 s TransDeptInterface=$p($g(TransDeptDetail),"->",2)
 
 
 s TransDeptFirstDept=$p($g(TransDeptInterface),"^",1)
 
 s TransDeptFirstTime=$p($g(TransDeptInterface),"^",2)


 ;EPR> 出院日期时间 PAADM_DischgDate And PAADM_DischgTime
 s DischgDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DisDateTime(adm,"DiTan")
 s DeathDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).DeathDateTime(paperdr,"DiTan")
 s DisDateTimeMR=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDateTimeMR(adm,"DHC-DATA","DiTan")
 
 i DischgDateTime'="" 
 { 
   ;EPR> 出院日期
   s DischgDate = $ZD($P($G(DischgDateTime)," ",1),3)
   
   ;EPR> 出院时间 
   s DischgTime = $ZT($P($G(DischgDateTime)," ",2),1)
   
   ;EPR> 出院日期时间
   s DischgDateTime=DischgDate_" "_DischgTime
   s DischgDate =DischgDate_" "_"00:00:00"
 } 
 
   i DisDateTimeMR'="" 
 { 
   ;EPR> 统计组[袁旭] 出院日期
   s DischgDate = $ZD($P($G(DisDateTimeMR)," ",1),3)
   
   ;EPR> 统计组[袁旭] 出院时间 
   s DischgTime = $ZT($P($G(DisDateTimeMR)," ",2),1)
   
   ;EPR> 统计组[袁旭] 日期时间
   s DischgDateTime=DischgDate_" "_DischgTime
   s DischgDate =DischgDate_" "_"00:00:00"
 } 
 
  i DeathDateTime'="" 
 { 
   ;EPR> 死亡日期
   s DischgDate = $ZD($P($G(DeathDateTime)," ",1),3)
   
   ;EPR> 死亡时间 
   s DischgTime = $ZT($P($G(DeathDateTime)," ",2),1)
   
   ;EPR> 死亡日期时间
   s DischgDateTime=DischgDate_" "_DischgTime
   s DischgDate =DischgDate_" "_"00:00:00"
 } 


 ;EPR> 出院科室 
 s DischgDept=##Class(EPRservice.HISInterface.PatientInfoAssist).DisDept(adm,"DiTan") 

 ;EPR> 出院病区
 s DischgWard=##Class(EPRservice.HISInterface.PatientInfoAssist).DisWard(adm,"DiTan")

 ;EPR> 出院床号
 s DischgBed=##Class(EPRservice.HISInterface.PatientInfoAssist).DisBed(adm)
 
 ;EPR> 住院天数
 s ResidentDays=##Class(EPRservice.HISInterface.PatientInfoAssist).ResidentDaysAdm(adm,"DiTan")

 s DischgDeptPPP=""


 




 set MQueryPat=$LB("",adm,papmidr,RegisterNo,Medicare,OMedicare,EMedicare,IDCard,InsuranceNo,Name,Sex,Birthday,Age,AgeDay,MedicareAgeYear,MedicareAge,MedicareAgeUnit,Marriage,Native,CityBirth,ProvinceBirth,Occupation,Nation,Nationality,PayMode,MoubilePhone,LinkName,LinkRelation,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostalCode,HuKouAddress,HuKouTel,HuKouPostalCode,AdmDoctor,AdmDateTime,AdmDate,AdmTime,AdmDateTimeInBed,AdmDateInBed,AdmTimeInBed,InTimes,AdmDept,AdmWard,AdmBed,TransDept,TransDeptFirstTime,TransDeptFirstDept,TransDeptDetail,DischgDateTime,DischgDate,DischgTime,DischgDept,DischgWard,DischgBed,ResidentDays,DischgDeptPPP,SexDic)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetPatientInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetPatientInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetPatientInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,RegisterNo:%String,Medicare:%String,OMedicare:%String,EMedicare:%String,IDCard:%String,InsuranceNo:%String,Name:%String,Sex:%String,Birthday:%String,Age:%String,AgeDay:%String,MedicareAgeYear:%String,MedicareAge:%String,MedicareAgeUnit:%String,Marriage:%String,Native:%String,CityBirth:%String,ProvinceBirth:%String,Occupation:%String,Nation:%String,Nationality:%String,PayMode:%String,MoubilePhone:%String,LinkName:%String,LinkRelation:%String,LinkAddress:%String,LinkPhone:%String,WorkAddress:%String,WorkTel:%String,WorkPostalCode:%String,HuKouAddress:%String,HuKouTel:%String,HuKouPostalCode:%String,AdmDoctor:%String,AdmDateTime:%String,AdmDate:%String,AdmTime:%String,AdmDateTimeInBed:%String,AdmDateInBed:%String,AdmTimeInBed:%String,InTimes:%String,AdmDept:%String,AdmWard:%String,AdmBed:%String,TransDept:%String,TransDeptFirstTime:%String,TransDeptFirstDept:%String,TransDeptDetail:%String,DischgDateTime:%String,DischgDate:%String,DischgTime:%String,DischgDept:%String,DischgWard:%String,DischgBed:%String,ResidentDays:%String,DischgDeptPPP:%String,SexDic:%String")
{
}

/// //////////////////////////////////////////////////////[HIS]病人临床信息
ClassMethod GetClinicInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""
 s AdmDateTime="",AdmDate=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)

 ;EPR> 入院日期时间 PAADM_AdmDate And PAADM_AdmTime
 s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(adm,"DiTan")
 i AdmDateTime'="" 
 { 
   ;EPR> 入院日期
   s AdmDate = $ZD($P($G(AdmDateTime)," ",1),3)
 }




 ;EPR> 病人临床信息大类
 

 ;EPR> 诊断
 s Diagcount="",i=""
 s DiagString="",Diag01="",Diag02="",Diag03="",Diag04="",Diag05="",Diag06="",Diag07="",Diag08="",Diag09="",Diag10="",Diag11="",Diag12="",Diag13="",Diag14="",Diag15=""

  s Diagnosis =##Class(EPRservice.HISInterface.PatientInfoAssist).GetDiagnos(adm)
  i Diagnosis'=""
  {
    s diagcount=$l(Diagnosis,"!")
    f i=1:1:diagcount {
	    i i=1  s Diag01=$p($g(Diagnosis),"!",i)
	    i i=2  s Diag02=$p($g(Diagnosis),"!",i)
	    i i=3  s Diag03=$p($g(Diagnosis),"!",i)
	    i i=4  s Diag04=$p($g(Diagnosis),"!",i)
	    i i=5  s Diag05=$p($g(Diagnosis),"!",i)
	    i i=6  s Diag06=$p($g(Diagnosis),"!",i)
	    i i=7  s Diag07=$p($g(Diagnosis),"!",i)
	    i i=8  s Diag08=$p($g(Diagnosis),"!",i)
	    i i=9  s Diag09=$p($g(Diagnosis),"!",i)
	    i i=10 s Diag10=$p($g(Diagnosis),"!",i)
	    i i=11 s Diag11=$p($g(Diagnosis),"!",i)
	    i i=12 s Diag12=$p($g(Diagnosis),"!",i)
	    i i=13 s Diag13=$p($g(Diagnosis),"!",i)
	    i i=14 s Diag14=$p($g(Diagnosis),"!",i)
	    i i=15 s Diag15=$p($g(Diagnosis),"!",i)}
	
	s DiagString=$tr(Diagnosis,"!","，")
	s DiagString = $e(DiagString,1,$l(DiagString)-1)
	
 
 ;w !,"W01"_Diag01,!,"W02"_Diag02,!,"W03"_Diag03,!,"W04"_Diag04,!,"W05"_Diag05,!,"W06"_Diag06,!,"W07"_Diag07,!,"W08"_Diag08,!,"W09"_Diag09,!,"W10"_Diag10,!,"W11"_Diag11,!,"W12"_Diag12,!,"W13"_Diag13,!,"W14"_Diag14,!,"W15"_Diag15
  }
  
  
  
 ;EPR> 护理 
 ;EPR> Care1^Care2^Care3^Care4^Care5^Care6
 ;EPR> 特级护理^一级护理^二级护理^三级护理^ICU护理常规^CCU护理常规^
 s Caredays ="" ,Care1="" ,Care2="" ,Care3="", Care4="" ,Care5="" ,Care6=""
 s Caredays = ##class(EPRservice.HISInterface.PatientInfoAssist).CareDays(adm ,"DiTan","DHC-DATA")
 i (Caredays'="")
 {
 	s Care1 =$p(Caredays ,"^" ,2)
 	s Care2 =$p(Caredays ,"^" ,3)
 	s Care3 =$p(Caredays ,"^" ,4)
 	s Care4 =$p(Caredays ,"^" ,1)
 	s Care5 =$p(Caredays ,"^" ,5)
 	s Care6 =$p(Caredays ,"^" ,6)
 }


 ;EPR> 门诊医嘱(检验检查)(草药处方)(西药处方)
 s Orders="",OrdersLab="",OrdersCheck="",OrdersCheck1="",OrdersCheck2="",OrdersCheck3="",OrdersCheck4=""
 s OrdersCaoYao="",OrdersXiYao=""
 
 ;EPR> 临时医嘱 化验
 s OrdersLab=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(adm,AdmDate,$ZD($H,3),"化验","0")
 
 ;EPR> 临时医嘱 放射检查
 s OrdersCheck1=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(adm,AdmDate,$ZD($H,3),"放射检查","0")
 
 ;EPR> 临时医嘱 物理检查
 s OrdersCheck2=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(adm,AdmDate,$ZD($H,3),"物理检查","0")
 
 ;EPR> 临时医嘱 病理检查费
 s OrdersCheck3=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(adm,AdmDate,$ZD($H,3),"病理检查费","0")
 
 ;EPR> 临时医嘱 内窥镜检查
 s OrdersCheck4=##Class(EPRservice.HISInterface.PatientInfoAssist).GetOrders(adm,AdmDate,$ZD($H,3),"内窥镜检查","0")
 
 
 s OrdersCheck=OrdersLab_OrdersCheck1_OrdersCheck2_OrdersCheck3_OrdersCheck4
 i OrdersCheck'="" { s OrdersCheck= $e( OrdersCheck,1,$l(OrdersCheck)-2) }

 
 
 ;EPR> 临时医嘱 草药
 s OrdersCaoYao="" ;##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersCaoYao(adm)
 

 ;EPR> 临时医嘱 西药
 s OrdersXiYao="" ;##class(EPRservice.HISInterface.PatientInfoAssist).GetOrdersXiYao(adm)
 
 set MQueryPat=$LB("",adm,papmidr,DiagString,Diag01,Diag02,Diag03,Diag04,Diag05,Diag06,Diag07,Diag08,Diag09,Diag10,Diag11,Diag12,Diag13,Diag14,Diag15,Care1,Care2,Care3,Care4,Care5,Care6,OrdersCheck,OrdersCaoYao,OrdersXiYao)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetClinicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetClinicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetClinicInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,DiagString:%String,Diag01:%String,Diag02:%String,Diag03:%String,Diag04:%String,Diag05:%String,Diag06:%String,Diag07:%String,Diag08:%String,Diag09:%String,Diag10:%String,Diag11:%String,Diag12:%String,Diag13:%String,Diag14:%String,Diag15:%String,Care1:%String,Care2:%String,Care3:%String,Care4:%String,Care5:%String,Care6:%String,OrdersCheck:%String,OrdersCaoYao:%String,OrdersXiYao:%String")
{
}

/// //////////////////////////////////////////////////////[HIS]病人检验信息
ClassMethod GetLabInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""
 s AdmDateTime="",AdmDate=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 ;EPR> 入院日期时间 PAADM_AdmDate And PAADM_AdmTime
 s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(adm,"DiTan")
 i AdmDateTime'="" 
 { 
   ;EPR> 入院日期
   s AdmDate = $ZD($P($G(AdmDateTime)," ",1),3)
 }




 ;EPR> 检验项目大类
 
 

 
 set MQueryPat=$LB("",adm,papmidr)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetLabInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetLabInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetLabInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,OrdersLab:%String")
{
}

/// //////////////////////////////////////////////////////[HIS]病人检查信息
ClassMethod GetCheckInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)



 ;EPR> 检查项目大类
 
 
 
 set MQueryPat=$LB("",adm,papmidr,RegisterNo,Medicare,OMedicare,EMedicare,IDCard,InsuranceNo,Name,Sex,Birthday,Age,AgeDay,MedicareAgeYear,MedicareAge,MedicareAgeUnit,Marriage,Native,CityBirth,ProvinceBirth,Occupation,Nation,Nationality,PayMode,MoubilePhone,LinkName,LinkRelation,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostalCode,HuKouAddress,HuKouTel,HuKouPostalCode,AdmDoctor,AdmDateTime,AdmDate,AdmTime,AdmDateTimeInBed,AdmDateInBed,AdmTimeInBed,InTimes,AdmDept,AdmWard,AdmBed,TransDept,TransDeptDetail,DischgDateTime,DischgDate,DischgTime,DischgDept,DischgWard,DischgBed,ResidentDays,Diag01,Diag02,Diag03,Diag04,Diag05,Diag06,Diag07,Diag08,Diag09,Diag10,Diag11,Diag12,Diag13,Diag14,Diag15,Care1,Care2,Care3,Care4,Care5,Care6)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetCheckInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetCheckInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetCheckInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,RegisterNo:%String,Medicare:%String,OMedicare:%String,EMedicare:%String,IDCard:%String,InsuranceNo:%String,Name:%String,Sex:%String,Birthday:%String,Age:%String,AgeDay:%String,MedicareAgeYear:%String,MedicareAge:%String,MedicareAgeUnit:%String,Marriage:%String,Native:%String,CityBirth:%String,ProvinceBirth:%String,Occupation:%String,Nation:%String,Nationality:%String,PayMode:%String,MoubilePhone:%String,LinkName:%String,LinkRelation:%String,LinkAddress:%String,LinkPhone:%String,WorkAddress:%String,WorkTel:%String,WorkPostalCode:%String,HuKouAddress:%String,HuKouTel:%String,HuKouPostalCode:%String,AdmDoctor:%String,AdmDateTime:%String,AdmDate:%String,AdmTime:%String,AdmDateTimeInBed:%String,AdmDateInBed:%String,AdmTimeInBed:%String,InTimes:%String,AdmDept:%String,AdmWard:%String,AdmBed:%String,TransDept:%String,TransDeptDetail:%String,DischgDateTime:%String,DischgDate:%String,DischgTime:%String,DischgDept:%String,DischgWard:%String,DischgBed:%String,ResidentDays:%String,Diag01:%String,Diag02:%String,Diag03:%String,Diag04:%String,Diag05:%String,Diag06:%String,Diag07:%String,Diag08:%String,Diag09:%String,Diag10:%String,Diag11:%String,Diag12:%String,Diag13:%String,Diag14:%String,Diag15:%String,Care1:%String,Care2:%String,Care3:%String,Care4:%String,Care5:%String,Care6:%String")
{
}

/*ClassMethod GetTMCFeeInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 s MQueryPat=$LB("",adm,papmidr)


 ;EPR> 病人费用(病案费用大类)
 s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
 s InPatFee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCare(adm,"DiTan")
 s FeeNum=$l(InPatFee,"!")
 s i=0,FeeList="",tmpFee=""
 f i=1:1:(FeeNum) d
 .s tmpFee=$p(InPatFee,"!",i)
 .i tmpFee'="" {s MQueryPat=MQueryPat_$lb($p($p(InPatFee,"!",i),"^",3))}
 .i i=1 {s CheckTotal=$p($p(InPatFee,"!",i),"^",3)} 
 .i i>1 {s CheckFee=CheckFee+$p($p(InPatFee,"!",i),"^",3)}
 
 ;EPR>费用合计与费用子项审核
 i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
 s MQueryPat=MQueryPat_$lb(CheckFeeTag)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetTMCFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetTMCFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetTMCFeeInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,TMCTotal:%String,TMC01CWF:%String,TMC02ZLF:%String,TMC03XYF:%String,TMC04ZCHYF:%String,TMC05ZCYF:%String,TMC06JCF:%String,TMC07ZCF:%String,TMC08FSF:%String,TMC09HYF:%String,TMC10SXF:%String,TMC11SYF:%String,TMC12JSF:%String,TMC13TWF:%String,TMC14CLF:%String,TMC15YEF:%String,TMC16HLF:%String,TMC17MZF:%String,TMC18QTF:%String,TMC19SSF:%String,TMC20PCF:%String,TMCCheckFeeTag:%String")
{
}*/
/// //////////////////////////////////////////////////////[HIS]病人费用信息病案大类20项
/// //////////////////////////////////////////////////////[HIS]病人费用信息病案大类20项
ClassMethod GetTMCFeeInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 s MQueryPat=$LB("",adm,papmidr)


 ;EPR> 病人费用(病案费用大类)
 s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
 s InPatFee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCare(adm,"DiTan")
 s FeeNum=$l(InPatFee,"!")
 s i=0,FeeList="",tmpFee=""
 f i=1:1:(FeeNum) d
 .s tmpFee=$p(InPatFee,"!",i)
 .i tmpFee'="" {s MQueryPat=MQueryPat_$lb($p($p(InPatFee,"!",i),"^",3))}
 .i i=1 {s CheckTotal=$p($p(InPatFee,"!",i),"^",3)} 
 .i i>1 {s CheckFee=CheckFee+$p($p(InPatFee,"!",i),"^",3)}
 
 ;EPR>费用合计与费用子项审核
 i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
 s MQueryPat=MQueryPat_$lb(CheckFeeTag)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetTMCFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetTMCFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetTMCFeeInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,TMCTotal:%String,TMC01CWF:%String,TMC02HLF:%String,TMC03XYF:%String,TMC04ZCHYF:%String,TMC05ZCYF:%String,TMC06FSF:%String,TMC07HYF:%String,TMC08SYF:%String,TMC09SXF:%String,TMC10ZLF:%String,TMC11SSF:%String,TMC12JSF:%String,TMC13JCF:%String,TMC14MZF:%String,TMC15YEF:%String,TMC16PCF:%String,TMC17QTF:%String,TMC18CLF:%String,TMC19WFY:%String,TMCCheckFeeTag:%String")
{
}

/*ClassMethod GetMCFeeInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 s MQueryPat=$LB("",adm,papmidr)


 ;EPR> 病人费用(病案费用子类)
 s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
 s InPatFee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSub(adm,"DiTan")
 s FeeNum=$l(InPatFee,"!")
 s i=0,FeeList="",tmpFee=""
 f i=1:1:(FeeNum) d
 .s tmpFee=$p(InPatFee,"!",i)
 .i tmpFee'="" {s MQueryPat=MQueryPat_$lb($p($p(InPatFee,"!",i),"^",3))}
 .i i=1 {s CheckTotal=$p($p(InPatFee,"!",i),"^",3)} 
 .i i>1 {s CheckFee=CheckFee+$p($p(InPatFee,"!",i),"^",3)}
 
 ;EPR>费用合计与费用子项审核
 i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
 s MQueryPat=MQueryPat_$lb(CheckFeeTag)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetMCFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetMCFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetMCFeeInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,MCTotal:%String,MC01CWF:%String,MC02TSZLF:%String,MC03YBZLF:%String,MC04HLZLF:%String,MC05HXJF:%String,MC06XYF:%String,MC07ZCHYF:%String,MC08ZCYF:%String,MC09YBJCF:%String,MC10HSF:%String,MC11CSF:%String,MC12BLF:%String,MC13JHYF:%String,MC14ZCF:%String,MC15FSF:%String,MC16HYF:%String,MC17SXF:%String,MC18SYF:%String,MC19JSF:%String,MC20TWF:%String,MC21ZLYYCXYYCLF:%String,MC22SSYYCXYYCLF:%String,MC23JCYYCXYYCLF:%String,MC24FSYYCXYYCLF:%String,MC25YEF:%String,MC26HLF:%String,MC27MZF:%String,MC28QTF:%String,MC29SSF:%String,MC30PCF:%String,MCCheckFeeTag:%String")
{
}*/
/// //////////////////////////////////////////////////////[HIS]病人费用信息病案子类30项
/// //////////////////////////////////////////////////////[HIS]病人费用信息病案子类30项
ClassMethod GetMCFeeInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 s MQueryPat=$LB("",adm,papmidr)


 ;EPR> 病人费用(病案费用子类)
 s InPatFee="" , CheckTotal="",CheckFee="",CheckFeeTag=""
 s InPatFee=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSub(adm,"DiTan")
 s FeeNum=$l(InPatFee,"!")
 s i=0,FeeList="",tmpFee=""
 f i=1:1:(FeeNum) d
 .s tmpFee=$p(InPatFee,"!",i)
 .i tmpFee'="" {s MQueryPat=MQueryPat_$lb($p($p(InPatFee,"!",i),"^",3))}
 .i i=1 {s CheckTotal=$p($p(InPatFee,"!",i),"^",3)} 
 .i i>1 {s CheckFee=CheckFee+$p($p(InPatFee,"!",i),"^",3)}
 
 ;EPR>费用合计与费用子项审核
 i $fn(CheckTotal,"",2)'=$fn(CheckFee,"",2) { s CheckFeeTag="CheckFeeERROR" } else {s CheckFeeTag="CheckFeeOK" }
 s MQueryPat=MQueryPat_$lb(CheckFeeTag)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetMCFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetMCFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetMCFeeInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,MCTotal:%String,MC01CWF:%String,MC02TSZLF:%String,MC03YBZLF:%String,MC04HLZLF:%String,MC05HXJF:%String,MC06XYF:%String,MC07ZCHYF:%String,MC08ZCYF:%String,MC09YBJCF:%String,MC10HSF:%String,MC11CSF:%String,MC12BLF:%String,MC13JHYF:%String,MC14ZCF:%String,MC15FSF:%String,MC16HYF:%String,MC17SXF:%String,MC18SYF:%String,MC19JSF:%String,MC20TWF:%String,MC21ZLYYCXYYCLF:%String,MC22SSYYCXYYCLF:%String,MC23JCYYCXYYCLF:%String,MC24FSYYCXYYCLF:%String,MC25YEF:%String,MC26HLF:%String,MC27MZF:%String,MC28QTF:%String,MC29SSF:%String,MC30PCF:%String,MCCheckFeeTag:%String")
{
}

/// //////////////////////////////////////////////////////[HIS]病人其他信息
ClassMethod GetCustomInfoExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)





 ;EPR> 产科住院病历取门诊初诊病历数据
 s MaternityOutPatStr=""
 
 s MaternityOutPatStr=##class(EPRservice.HISInterface.PatientInfoAssist).GetMaternityOutPatStr(adm,papmidr,DischgDept,AdmDept)




 
 set MQueryPat=$LB("",adm,papmidr,RegisterNo,Medicare,OMedicare,EMedicare,IDCard,InsuranceNo,Name,Sex,Birthday,Age,AgeDay,MedicareAgeYear,MedicareAge,MedicareAgeUnit,Marriage,Native,CityBirth,ProvinceBirth,Occupation,Nation,Nationality,PayMode,MoubilePhone,LinkName,LinkRelation,LinkAddress,LinkPhone,WorkAddress,WorkTel,WorkPostalCode,HuKouAddress,HuKouTel,HuKouPostalCode,AdmDoctor,AdmDateTime,AdmDate,AdmTime,AdmDateTimeInBed,AdmDateInBed,AdmTimeInBed,InTimes,AdmDept,AdmWard,AdmBed,TransDept,TransDeptDetail,DischgDateTime,DischgDate,DischgTime,DischgDept,DischgWard,DischgBed,ResidentDays,Diag01,Diag02,Diag03,Diag04,Diag05,Diag06,Diag07,Diag08,Diag09,Diag10,Diag11,Diag12,Diag13,Diag14,Diag15,Care1,Care2,Care3,Care4,Care5,Care6)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetCustomInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetCustomInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetCustomInfo(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,RegisterNo:%String,Medicare:%String,OMedicare:%String,EMedicare:%String,IDCard:%String,InsuranceNo:%String,Name:%String,Sex:%String,Birthday:%String,Age:%String,AgeDay:%String,MedicareAgeYear:%String,MedicareAge:%String,MedicareAgeUnit:%String,Marriage:%String,Native:%String,CityBirth:%String,ProvinceBirth:%String,Occupation:%String,Nation:%String,Nationality:%String,PayMode:%String,MoubilePhone:%String,LinkName:%String,LinkRelation:%String,LinkAddress:%String,LinkPhone:%String,WorkAddress:%String,WorkTel:%String,WorkPostalCode:%String,HuKouAddress:%String,HuKouTel:%String,HuKouPostalCode:%String,AdmDoctor:%String,AdmDateTime:%String,AdmDate:%String,AdmTime:%String,AdmDateTimeInBed:%String,AdmDateInBed:%String,AdmTimeInBed:%String,InTimes:%String,AdmDept:%String,AdmWard:%String,AdmBed:%String,TransDept:%String,TransDeptDetail:%String,DischgDateTime:%String,DischgDate:%String,DischgTime:%String,DischgDept:%String,DischgWard:%String,DischgBed:%String,ResidentDays:%String,Diag01:%String,Diag02:%String,Diag03:%String,Diag04:%String,Diag05:%String,Diag06:%String,Diag07:%String,Diag08:%String,Diag09:%String,Diag10:%String,Diag11:%String,Diag12:%String,Diag13:%String,Diag14:%String,Diag15:%String,Care1:%String,Care2:%String,Care3:%String,Care4:%String,Care5:%String,Care6:%String")
{
}

/// //////////////////////////////////////////////////////[WMR]首页接口信息
ClassMethod GetWMRInterfaceExecute(ByRef qHandle As %Binary, adm As %String) As %Status
{
 s qHandle=""
 s SQLCODE=0
 
 ;EPR> 系统标识号
 s papmidr="",paperdr=""
 s AdmDateTime="",AdmDate=""

 ;EPR> PA_Adm.PAADM_PAPMI_DR
 s papmidr = $P($g(^PAADM(adm)),"^",1)
 
 ;EPR> PA_Person.PAPER_RowId And PA_PatMas.PAPMI_PAPER_DR
 s paperdr = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPaperDR(papmidr)


 ;EPR> 入院日期时间 PAADM_AdmDate And PAADM_AdmTime
 s AdmDateTime=##class(EPRservice.HISInterface.PatientInfoAssist).AdmDateTime(adm,"DiTan")
 i AdmDateTime'="" 
 { 
   ;EPR> 入院日期
   s AdmDate = $ZD($P($G(AdmDateTime)," ",1),3)
 }



 ;EPR> 与医政管理组病案首页内部接口大类
 
 ;w ##Class(web.DHCWMRCodingInterface).getFrontPageICD(Paadm,GetType,Index)
 ;导出病案编目数据：getFrontPageICD
 ;入参：
 ;  1-Paadm               就诊号
 ;  2-GetType             类型
 ;        D/1:            主要诊断
 ;        D/2:            次要诊断
 ;        D/3:            医院感染诊断
 ;        D/4:            病理诊断
 ;        D/5:            损伤、中毒的外部因素
 ;        D/6:            门急诊诊断
 ;        D/7:            入院诊断
 ;        O/1:            手术
 ;        O/2:            操作
 ;  3-Index               第几条记录
 
 ;EPR> 门诊入院诊断
 
 s Opdiagstr="",Ipdiagstr=""
 s Opdiagcode="",Opdiagdesc=""
 s Ipdiagcode="",Ipdiagdesc=""
 
 s Opdiagstr=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/6",1)
 i Opdiagstr'=""
 {
	  s Opdiagcode		=$p($g(Opdiagstr),$c(2),1)
	  s Opdiagdesc		=$p($g(Opdiagstr),$c(2),2)
	 }
	 
 s Ipdiagstr=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/7",1)
 i Ipdiagstr'=""
 {
	  s Ipdiagcode		=$p($g(Ipdiagstr),$c(2),1)
	  s Ipdiagdesc		=$p($g(Ipdiagstr),$c(2),2)
	 }

 
 ;EPR> 出院诊断
 
 s diagstr1="",diagstr2="",diagstr3="",diagstr4="",diagstr5="",diagstr6="",diagstr7="",diagstr8="",diagstr9="",diagstr10="",diagstr11=""
 s icdcode1="",icddesc1="",CureResult1=""
 s icdcode2="",icddesc2="",CureResult2=""
 s icdcode3="",icddesc3="",CureResult3=""
 s icdcode4="",icddesc4="",CureResult4=""
 s icdcode5="",icddesc5="",CureResult5=""
 s icdcode6="",icddesc6="",CureResult6=""
 s icdcode7="",icddesc7="",CureResult7=""
 s icdcode8="",icddesc8="",CureResult8=""
 s icdcode9="",icddesc9="",CureResult9=""
 s icdcode10="",icddesc10="",CureResult10=""
 s icdcode11="",icddesc11="",CureResult11=""
 

 s diagstr1=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/1",1)
 i diagstr1'=""
 {
	  s icdcode1		=$p($g(diagstr1),$c(2),1)
	  s icddesc1		=$p($g(diagstr1),$c(2),2)
	  s CureResult1		=$p($g(diagstr1),$c(2),3)
	 }

 s diagstr2=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",1)
 i diagstr2'=""
 {
	  s icdcode2		=$p($g(diagstr2),$c(2),1)
	  s icddesc2		=$p($g(diagstr2),$c(2),2)
	  s CureResult2		=$p($g(diagstr2),$c(2),3)
	 }
	 
 s diagstr3=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",2)
 i diagstr3'=""
 {
	  s icdcode3		=$p($g(diagstr3),$c(2),1)
	  s icddesc3		=$p($g(diagstr3),$c(2),2)
	  s CureResult3		=$p($g(diagstr3),$c(2),3)
	 }

 s diagstr4=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",3)
 i diagstr4'=""
 {
	  s icdcode4		=$p($g(diagstr4),$c(2),1)
	  s icddesc4		=$p($g(diagstr4),$c(2),2)
	  s CureResult4		=$p($g(diagstr4),$c(2),3)
	 }

 s diagstr5=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",4)
 i diagstr5'=""
 {
	  s icdcode5		=$p($g(diagstr5),$c(2),1)
	  s icddesc5		=$p($g(diagstr5),$c(2),2)
	  s CureResult5		=$p($g(diagstr5),$c(2),3)
	 }

 s diagstr6=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",5)
 i diagstr6'=""
 {
	  s icdcode6		=$p($g(diagstr6),$c(2),1)
	  s icddesc6		=$p($g(diagstr6),$c(2),2)
	  s CureResult6		=$p($g(diagstr6),$c(2),3)
	 }

 s diagstr7=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",6)
 i diagstr7'=""
 {
	  s icdcode7		=$p($g(diagstr7),$c(2),1)
	  s icddesc7		=$p($g(diagstr7),$c(2),2)
	  s CureResult7		=$p($g(diagstr7),$c(2),3)
	 }

 s diagstr8=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",7)
 i diagstr8'=""
 {
	  s icdcode8		=$p($g(diagstr8),$c(2),1)
	  s icddesc8		=$p($g(diagstr8),$c(2),2)
	  s CureResult8		=$p($g(diagstr8),$c(2),3)
	 }

 s diagstr9=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",8)
 i diagstr9'=""
 {
	  s icdcode9		=$p($g(diagstr9),$c(2),1)
	  s icddesc9		=$p($g(diagstr9),$c(2),2)
	  s CureResult9		=$p($g(diagstr9),$c(2),3)
	 }

 s diagstr10=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",9)
 i diagstr10'=""
 {
	  s icdcode10		=$p($g(diagstr10),$c(2),1)
	  s icddesc10		=$p($g(diagstr10),$c(2),2)
	  s CureResult10	=$p($g(diagstr10),$c(2),3)
	 }

 s diagstr11=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/2",10)
 i diagstr11'=""
 {
	  s icdcode11		=$p($g(diagstr11),$c(2),1)
	  s icddesc11		=$p($g(diagstr11),$c(2),2)
	  s CureResult11	=$p($g(diagstr11),$c(2),3)
	 }


 ;EPR> 病理诊断

  s diagstr12=""
  s icdcode12="",icddesc12=""
  
 s diagstr12=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/3",1)
 i diagstr12'=""
 {
	  s icdcode12		=$p($g(diagstr12),$c(2),1)
	  s icddesc12		=$p($g(diagstr12),$c(2),2)
	 }
  
 
 ;EPR> 损伤、中毒的外部因素诊断
 
 
  s diagstr13=""
  s icdcode13="",icddesc13=""
  
 s diagstr13=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/5",1)
 i diagstr13'=""
 {
	  s icdcode13		=$p($g(diagstr13),$c(2),1)
	  s icddesc13		=$p($g(diagstr13),$c(2),2)
	 }
 
 
 ;EPR> 医院感染诊断
 
 s diagstr14=""
 s icdcode14="",icddesc14="",CureResult14=""
 
 s diagstr14=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"D/4",1)
 i diagstr14'=""
 {
	  s icdcode14		=$p($g(diagstr14),$c(2),1)
	  s icddesc14		=$p($g(diagstr14),$c(2),2)
	  s CureResult14	=$p($g(diagstr14),$c(2),3)
	 }
 
 
 
 ;EPR> 手术情况
 
 s operstr1="",operstr2="",operstr3="",operstr4="",operstr5=""
 s opercode1="",operdesc1="",operdate1="",operdoc1="",operassifir1="",operassistsec1="",cutcode1="",ciccode1="",AnaestMethod1="",Anaestdoc1=""
 s opercode2="",operdesc2="",operdate2="",operdoc2="",operassifir2="",operassistsec2="",cutcode2="",ciccode2="",AnaestMethod2="",Anaestdoc2=""
 s opercode3="",operdesc3="",operdate3="",operdoc3="",operassifir3="",operassistsec3="",cutcode3="",ciccode3="",AnaestMethod3="",Anaestdoc3=""
 s opercode4="",operdesc4="",operdate4="",operdoc4="",operassifir4="",operassistsec4="",cutcode4="",ciccode4="",AnaestMethod4="",Anaestdoc4=""
 s opercode5="",operdesc5="",operdate5="",operdoc5="",operassifir5="",operassistsec5="",cutcode5="",ciccode5="",AnaestMethod5="",Anaestdoc5=""
 
 
 s operstr1=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/1",1)
 i operstr1'=""
 {
	  s opercode1		=$p($g(operstr1),$c(2),1)
	  s operdesc1		=$p($g(operstr1),$c(2),2)
	  s operdate1		=$p($g(operstr1),$c(2),3)
	  s operdoc1		=$p($g(operstr1),$c(2),4)
	  s operassifir1	=$p($g(operstr1),$c(2),5)
	  s operassistsec1	=$p($g(operstr1),$c(2),6)
	  s AnaestMethod1	=$p($g(operstr1),$c(2),7)
	  s cutcode1		=$p($p($g(operstr1),$c(2),8),"/",1)
	  s ciccode1		=$p($p($g(operstr1),$c(2),8),"/",2)
	  s Anaestdoc1		=$p($g(operstr1),$c(2),9)
	 }

 s operstr2=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/1",2)
 i operstr2'=""
 {
	  s opercode2		=$p($g(operstr2),$c(2),1)
	  s operdesc2		=$p($g(operstr2),$c(2),2)
	  s operdate2		=$p($g(operstr2),$c(2),3)
	  s operdoc2		=$p($g(operstr2),$c(2),4)
	  s operassifir2	=$p($g(operstr2),$c(2),5)
	  s operassistsec2	=$p($g(operstr2),$c(2),6)
	  s AnaestMethod2	=$p($g(operstr2),$c(2),7)
	  s cutcode2		=$p($p($g(operstr2),$c(2),8),"/",1)
	  s ciccode2		=$p($p($g(operstr2),$c(2),8),"/",2)
	  s Anaestdoc2		=$p($g(operstr2),$c(2),9)
	 }

 s operstr3=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/1",3)
 i operstr3'=""
 {
	  s opercode3		=$p($g(operstr3),$c(2),1)
	  s operdesc3		=$p($g(operstr3),$c(2),2)
	  s operdate3		=$p($g(operstr3),$c(2),3)
	  s operdoc3		=$p($g(operstr3),$c(2),4)
	  s operassifir3	=$p($g(operstr3),$c(2),5)
	  s operassistsec3	=$p($g(operstr3),$c(2),6)
	  s AnaestMethod3	=$p($g(operstr3),$c(2),7)
	  s cutcode3		=$p($p($g(operstr3),$c(2),8),"/",1)
	  s ciccode3		=$p($p($g(operstr3),$c(2),8),"/",2)
	  s Anaestdoc3		=$p($g(operstr3),$c(2),9)
	 }

 s operstr4=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/1",4)
 i operstr4'=""
 {
	  s opercode4		=$p($g(operstr4),$c(2),1)
	  s operdesc4		=$p($g(operstr4),$c(2),2)
	  s operdate4		=$p($g(operstr4),$c(2),3)
	  s operdoc4		=$p($g(operstr4),$c(2),4)
	  s operassifir4	=$p($g(operstr4),$c(2),5)
	  s operassistsec4	=$p($g(operstr4),$c(2),6)
	  s AnaestMethod4	=$p($g(operstr4),$c(2),7)
	  s cutcode4		=$p($p($g(operstr4),$c(2),8),"/",1)
	  s ciccode4		=$p($p($g(operstr4),$c(2),8),"/",2)
	  s Anaestdoc4		=$p($g(operstr4),$c(2),9)
	 }

 s operstr5=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/1",5)
 i operstr5'=""
 {
	  s opercode5		=$p($g(operstr5),$c(2),1)
	  s operdesc5		=$p($g(operstr5),$c(2),2)
	  s operdate5		=$p($g(operstr5),$c(2),3)
	  s operdoc5		=$p($g(operstr5),$c(2),4)
	  s operassifir5	=$p($g(operstr5),$c(2),5)
	  s operassistsec5	=$p($g(operstr5),$c(2),6)
	  s AnaestMethod5	=$p($g(operstr5),$c(2),7)
	  s cutcode5		=$p($p($g(operstr5),$c(2),8),"/",1)
	  s ciccode5		=$p($p($g(operstr5),$c(2),8),"/",2)
	  s Anaestdoc5		=$p($g(operstr5),$c(2),9)
	 }




	
 
 
 
 ;EPR> 操作情况
 
 s operstr6="",operstr7="",operstr8="",operstr9="",operstr10=""
 s opercode6="",operdesc6="",operdate6="",operdoc6="",operassifir6="",operassistsec6="",cutcode6="",ciccode6="",AnaestMethod6="",Anaestdoc6=""
 s opercode7="",operdesc7="",operdate7="",operdoc7="",operassifir7="",operassistsec7="",cutcode7="",ciccode7="",AnaestMethod7="",Anaestdoc7=""
 s opercode8="",operdesc8="",operdate8="",operdoc8="",operassifir8="",operassistsec8="",cutcode8="",ciccode8="",AnaestMethod8="",Anaestdoc8=""
 s opercode9="",operdesc9="",operdate9="",operdoc9="",operassifir9="",operassistsec9="",cutcode9="",ciccode9="",AnaestMethod9="",Anaestdoc9=""
 s opercode10="",operdesc10="",operdate10="",operdoc10="",operassifir10="",operassistsec10="",cutcode10="",ciccode10="",AnaestMethod10="",Anaestdoc10=""
 
  s operstr6=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/2",1)
 i operstr6'=""
 {
	  s opercode6		=$p($g(operstr6),$c(2),1)
	  s operdesc6		=$p($g(operstr6),$c(2),2)
	  s operdate6		=$p($g(operstr6),$c(2),3)
	  s operdoc6		=$p($g(operstr6),$c(2),4)
	  s operassifir6	=$p($g(operstr6),$c(2),5)
	  s operassistsec6	=$p($g(operstr6),$c(2),6)
	  s AnaestMethod6	=$p($g(operstr6),$c(2),7)
	  ;s cutcode6		=$p($p($g(operstr6),$c(2),8),"/",1)
	  ;s ciccode6		=$p($p($g(operstr6),$c(2),8),"/",2)
	  s Anaestdoc6		=$p($g(operstr6),$c(2),9)
	 }

 s operstr7=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/2",2)
 i operstr7'=""
 {
	  s opercode7		=$p($g(operstr7),$c(2),1)
	  s operdesc7		=$p($g(operstr7),$c(2),2)
	  s operdate7		=$p($g(operstr7),$c(2),3)
	  s operdoc7		=$p($g(operstr7),$c(2),4)
	  s operassifir7	=$p($g(operstr7),$c(2),5)
	  s operassistsec7	=$p($g(operstr7),$c(2),6)
	  s AnaestMethod7	=$p($g(operstr7),$c(2),7)
	  ;s cutcode7		=$p($p($g(operstr7),$c(2),8),"/",1)
	  ;s ciccode7		=$p($p($g(operstr7),$c(2),8),"/",2)
	  s Anaestdoc7		=$p($g(operstr7),$c(2),9)
	 }

 s operstr8=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/2",3)
 i operstr8'=""
 {
	  s opercode8		=$p($g(operstr8),$c(2),1)
	  s operdesc8		=$p($g(operstr8),$c(2),2)
	  s operdate8		=$p($g(operstr8),$c(2),3)
	  s operdoc8		=$p($g(operstr8),$c(2),4)
	  s operassifir8	=$p($g(operstr8),$c(2),5)
	  s operassistsec8	=$p($g(operstr8),$c(2),6)
	  s AnaestMethod8	=$p($g(operstr8),$c(2),7)
	  ;s cutcode8		=$p($p($g(operstr8),$c(2),8),"/",1)
	  ;s ciccode8		=$p($p($g(operstr8),$c(2),8),"/",2)
	  s Anaestdoc8		=$p($g(operstr8),$c(2),9)
	 }

 s operstr9=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/2",4)
 i operstr9'=""
 {
	  s opercode9		=$p($g(operstr9),$c(2),1)
	  s operdesc9		=$p($g(operstr9),$c(2),2)
	  s operdate9		=$p($g(operstr9),$c(2),3)
	  s operdoc9		=$p($g(operstr9),$c(2),4)
	  s operassifir9	=$p($g(operstr9),$c(2),5)
	  s operassistsec9	=$p($g(operstr9),$c(2),6)
	  s AnaestMethod9	=$p($g(operstr9),$c(2),7)
	  ;s cutcode9		=$p($p($g(operstr9),$c(2),8),"/",1)
	  ;s ciccode9		=$p($p($g(operstr9),$c(2),8),"/",2)
	  s Anaestdoc9		=$p($g(operstr9),$c(2),9)
	 }

 s operstr10=##Class(web.DHCWMRCodingInterface).getFrontPageICD(adm,"O/2",5)
 i operstr10'=""
 {
	  s opercode10		=$p($g(operstr10),$c(2),1)
	  s operdesc10		=$p($g(operstr10),$c(2),2)
	  s operdate10		=$p($g(operstr10),$c(2),3)
	  s operdoc10		=$p($g(operstr10),$c(2),4)
	  s operassifir10	=$p($g(operstr10),$c(2),5)
	  s operassistsec10	=$p($g(operstr10),$c(2),6)
	  s AnaestMethod10	=$p($g(operstr10),$c(2),7)
	  ;s cutcode10		=$p($p($g(operstr10),$c(2),8),"/",1)
	  ;s ciccode10		=$p($p($g(operstr10),$c(2),8),"/",2)
	  s Anaestdoc10		=$p($g(operstr10),$c(2),9)
	 }

 
 set MQueryPat=$LB("",adm,papmidr,Opdiagcode,Opdiagdesc,Ipdiagcode,Ipdiagdesc,icdcode1,icddesc1,CureResult1,icdcode2,icddesc2,CureResult2,icdcode3,icddesc3,CureResult3,icdcode4,icddesc4,CureResult4,icdcode5,icddesc5,CureResult5,icdcode6,icddesc6,CureResult6,icdcode7,icddesc7,CureResult7,icdcode8,icddesc8,CureResult8,icdcode9,icddesc9,CureResult9,icdcode10,icddesc10,CureResult10,icdcode11,icddesc11,CureResult11,icdcode12,icddesc12,icdcode13,icddesc13,icdcode14,icddesc14,CureResult14,opercode1,operdesc1,operdate1,operdoc1,operassifir1,operassistsec1,cutcode1,ciccode1,AnaestMethod1,Anaestdoc1,opercode2,operdesc2,operdate2,operdoc2,operassifir2,operassistsec2,cutcode2,ciccode2,AnaestMethod2,Anaestdoc2,opercode3,operdesc3,operdate3,operdoc3,operassifir3,operassistsec3,cutcode3,ciccode3,AnaestMethod3,Anaestdoc3,opercode4,operdesc4,operdate4,operdoc4,operassifir4,operassistsec4,cutcode4,ciccode4,AnaestMethod4,Anaestdoc4,opercode5,operdesc5,operdate5,operdoc5,operassifir5,operassistsec5,cutcode5,ciccode5,AnaestMethod5,Anaestdoc5,opercode6,operdesc6,operdate6,operdoc6,operassifir6,operassistsec6,AnaestMethod6,Anaestdoc6,opercode7,operdesc7,operdate7,operdoc7,operassifir7,operassistsec7,AnaestMethod7,Anaestdoc7,opercode8,operdesc8,operdate8,operdoc8,operassifir8,operassistsec8,AnaestMethod8,Anaestdoc8,opercode9,operdesc9,operdate9,operdoc9,operassifir9,operassistsec9,AnaestMethod9,Anaestdoc9,opercode10,operdesc10,operdate10,operdoc10,operassifir10,operassistsec10,AnaestMethod10,Anaestdoc10)
 
 s qHandle=MQueryPat
 Quit $$$OK
}

ClassMethod GetWMRInterfaceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
	if qHandle'=""
	{
		s Row=qHandle
		s qHandle=""
	}
	else
	{
		s Row = ""
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetWMRInterfaceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientInfoExecute ]
{
 s qHandle="" 
	Quit $$$OK
}

Query GetWMRInterface(adm As %String) As %Query(ROWSPEC = "NULL:%String,AdmID:%String,PapmiDR:%String,Opdiagcode:%String,Opdiagdesc:%String,Ipdiagcode:%String,Ipdiagdesc:%String,icdcode1:%String,icddesc1:%String,CureResult1:%String,icdcode2:%String,icddesc2:%String,CureResult2:%String,icdcode3:%String,icddesc3:%String,CureResult3:%String,icdcode4:%String,icddesc4:%String,CureResult4:%String,icdcode5:%String,icddesc5:%String,CureResult5:%String,icdcode6:%String,icddesc6:%String,CureResult6:%String,icdcode7:%String,icddesc7:%String,CureResult7:%String,icdcode8:%String,icddesc8:%String,CureResult8:%String,icdcode9:%String,icddesc9:%String,CureResult9:%String,icdcode10:%String,icddesc10:%String,CureResult10:%String,icdcode11:%String,icddesc11:%String,CureResult11:%String,icdcode12:%String,icddesc12:%String,icdcode13:%String,icddesc13:%String,icdcode14:%String,icddesc14:%String,CureResult14:%String,opercode1:%String,operdesc1:%String,operdate1:%String,operdoc1:%String,operassifir1:%String,operassistsec1:%String,cutcode1:%String,ciccode1:%String,AnaestMethod1:%String,Anaestdoc1:%String,opercode2:%String,operdesc2:%String,operdate2:%String,operdoc2:%String,operassifir2:%String,operassistsec2:%String,cutcode2:%String,ciccode2:%String,AnaestMethod2:%String,Anaestdoc2:%String,opercode3:%String,operdesc3:%String,operdate3:%String,operdoc3:%String,operassifir3:%String,operassistsec3:%String,cutcode3:%String,ciccode3:%String,AnaestMethod3:%String,Anaestdoc3:%String,opercode4:%String,operdesc4:%String,operdate4:%String,operdoc4:%String,operassifir4:%String,operassistsec4:%String,cutcode4:%String,ciccode4:%String,AnaestMethod4:%String,Anaestdoc4:%String,opercode5:%String,operdesc5:%String,operdate5:%String,operdoc5:%String,operassifir5:%String,operassistsec5:%String,cutcode5:%String,ciccode5:%String,AnaestMethod5:%String,Anaestdoc5:%String,opercode6:%String,operdesc6:%String,operdate6:%String,operdoc6:%String,operassifir6:%String,operassistsec6:%String,AnaestMethod6:%String,Anaestdoc6:%String,opercode7:%String,operdesc7:%String,operdate7:%String,operdoc7:%String,operassifir7:%String,operassistsec7:%String,AnaestMethod7:%String,Anaestdoc7:%String,opercode8:%String,operdesc8:%String,operdate8:%String,operdoc8:%String,operassifir8:%String,operassistsec8:%String,AnaestMethod8:%String,Anaestdoc8:%String,opercode9:%String,operdesc9:%String,operdate9:%String,operdoc9:%String,operassifir9:%String,operassistsec9:%String,AnaestMethod9:%String,Anaestdoc9:%String,opercode10:%String,operdesc10:%String,operdate10:%String,operdoc10:%String,operassifir10:%String,operassistsec10:%String,AnaestMethod10:%String,Anaestdoc10:%String")
{
}

/// //////////////////////////////////////////////////////
Query GetUserInfo(parUserId As %String) As %SQLQuery(CONTAINID = 0)
{
SELECT SSUSR_Name as Name FROM SQLUser.SS_User
 where SSUSR_Rowid=:parUserId
}

ClassMethod CheckEPRInstance(ECRecordId As %String, argGroupItemIDs As %String) As %String
{
		//get all EPR instance data which ECRecord 
		Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
		Set sc = rset.Execute(ECRecordId)
	
		//loop all instance, check if all instances which ID are in argGroupItemIDs are saved,
		//if one is not, then the patient's EPR is unfinished
		s unfinished=0
		While (rset.Next()) {
			;b "s"
			s InstanceId=rset.Get("ID")
			q:(InstanceId="")
			s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
			q:(Instance="")
			
			for i=1:1:$l(argGroupItemIDs,"^") {
				;b "s"
				if ($p(argGroupItemIDs,"^",i)=Instance.GroupItemID)&&(Instance.Status="UnSave") {s unfinished=1}
				q:(unfinished=1)
			}
		}
		Do rset.Close()
	
	q unfinished
}

ClassMethod GetDocUnfinishedEPR(argStartDate As %String, argEndDate As %String, argCategoryID As %String, argGroupItemIDs As %String) As %String
{
	q:($d(argStartDate)=0)||($d(argEndDate)=0)||($d(argCategoryID)=0)||($d(argGroupItemIDs)=0)||(argStartDate="")||(argEndDate="")||(argCategoryID="")||(argGroupItemIDs="") 0
	//get discharged patients list
	s uniqueid=$i(^CacheTemp)
	k ^CacheTempAdmId(uniqueid),^CacheTempUnfinishedEPR(uniqueid)
	s wherestring="dischargedate#>=#"_argStartDate_"^dischargedate#<=#"_argEndDate
	s AdmNum=0
	s AdmNum=##class(EPRservice.Query.BODataQueryService).PrepareAdmIdList(wherestring,uniqueid)
	q:(AdmNum=0) 0
	
	s adm=0,num=0
	//loop every adm
	for {
		s adm=$o(^CacheTempAdmId(uniqueid,adm))
		q:(adm="")
		
		//get patient's name and location
		s papmidr=$P($g(^PAADM(adm)),"^",1)
		s PatName=$P($g(^PAPER(papmidr,"ALL")),"^",1)
		s PatRegNo=$P($g(^PAPER(papmidr,"PAT",1)),"^",1)
		
		s PatientLoc=$p($g(^PAADM(adm)),"^",4) ;PatientLoc=PAADM_DepCode_DR
		s PatientLoc=$p($g(^CTLOC(PatientLoc)),"^",2)
		i $l(PatientLoc,"-")>1 {s PatientLoc=$p(PatientLoc,"-",2)}
		
		s PatientDoc=$P($g(^PAADM(adm)),"^",9) ;PAADM_AdmDocCodeDR
		i PatientDoc'="" s PatientDoc=$P($g(^CTPCP(PatientDoc,1)),"^",2)
		i $l(PatientDoc,"-")>1 {s PatientDoc=$p(PatientDoc,"-",2)}
		
		//get the adm's EPR which CategoryID = argCategoryID (the ID in TemplateCategory)
		s ECRecordId=##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(adm,argCategoryID)
		
		//if there is no ECRecordId, the patient's EPR is unfinished
		if (ECRecordId="") {
			s num=num+1
			;s ^CacheTempUnfinishedEPR(uniqueid,num)=num_"	"_PatientLoc_"	"_PatientDoc_"	"_PatName_"	"_PatRegNo
			;s ^CacheTempUnfinishedEPR(uniqueid,PatientLoc,num)=PatientDoc_"	"_PatRegNo_"	"_PatName
			s ^CacheTempUnfinishedEPR(uniqueid,PatientLoc,PatRegNo,num)=PatName_"	"_PatientDoc
			continue
		}
		
		//get all EPR instance data which ECRecord 
		Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
		Set sc = rset.Execute(ECRecordId)
	
		//loop all instance, check if all instances which ID are in argGroupItemIDs are saved,
		//if one is not, then the patient's EPR is unfinished
		s unfinished=0
		While (rset.Next()) {
			;b "s"
			s InstanceId=rset.Get("ID")
			q:(InstanceId="")
			s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
			q:(Instance="")
			
			for i=1:1:$l(argGroupItemIDs,"^") {
				;b "s"
				if ($p(argGroupItemIDs,"^",i)=Instance.GroupItemID)&&(Instance.Status="UnSave") {s unfinished=1}
				q:(unfinished=1)
			}
		}
		
		Do rset.Close()
		
		//record unfinished info
		if unfinished {
			s num=num+1
			;s ^CacheTempUnfinishedEPR(uniqueid,num)=PatientLoc_": "_PatName_" "_PatRegNo
			;s ^CacheTempUnfinishedEPR(uniqueid,PatientLoc,num)=PatientDoc_"	"_PatRegNo_"	"_PatName
			s ^CacheTempUnfinishedEPR(uniqueid,PatientLoc,PatRegNo,num)=PatName_"	"_PatientDoc
		}
	}
	
	//rearrange the data for sorting by date and patient's loc
	s PatLoc=0,numNew=0
	for {
		s PatLoc=$o(^CacheTempUnfinishedEPR(uniqueid,PatLoc))
		q:(PatLoc="")
		s regno=0,numInLoc=0
		for {
			s regno=$o(^CacheTempUnfinishedEPR(uniqueid,PatientLoc,regno))
			q:(regno="")
			s num=0
			for {
				s num=$o(^CacheTempUnfinishedEPR(uniqueid,PatLoc,regno,num))
				q:(num="")
				s numNew=numNew+1,numInLoc=numInLoc+1
				s ^CacheTempUnfinishedEPR(uniqueid,numNew)=argStartDate_"	"_numNew_"	"_PatLoc_"	"_numInLoc_"	"_regno_"	"_$g(^CacheTempUnfinishedEPR(uniqueid,PatientLoc,regno,num))
			}
		}
	}
	;s numNew=numNew+1
	;s ^CacheTempUnfinishedEPR(uniqueid,numNew)=numNew-1
	
	q uniqueid_"^"_numNew
}

ClassMethod GetGlobalItem(uniqueid As %String, argNum As %String) As %String
{
	q $g(^CacheTempUnfinishedEPR(uniqueid,argNum))
}

/// ClassMethod GetSession(Name As %Library.String)
/// {
/// q %session.Get(Name)
/// }
ClassMethod GetLocWardBedAdmdatetime(adm As %String, ByRef loc As %String, ByRef ward As %String, ByRef bed As %String, ByRef admdate As %String, ByRef admtime As %String)
{
 q:(($d(adm)=0)||(adm="")) ""

 s TRANSChildsub="",loc="",ward="",bed="",tmploc="",admdate="",admtime=""
 f  s TRANSChildsub=$o(^PAADM(adm,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(bed'="")  d
 .s bed=$p($g(^PAADM(adm,"TRANS",TRANSChildsub)),"^",8)
 .s ward=$p($g(^PAADM(adm,"TRANS",TRANSChildsub)),"^",9)
 .s tmploc=$p($g(^PAADM(adm,"TRANS",TRANSChildsub)),"^",6)
 .s admdate=$p($g(^PAADM(adm,"TRANS",TRANSChildsub)),"^",1)
 .s admtime=$p($g(^PAADM(adm,"TRANS",TRANSChildsub)),"^",2)
 .if tmploc'="" {s loc=tmploc}
 q loc_"^"_ward_"^"_bed_"^"_admdate_"^"_admtime
}

/// *****************************************************************
/// **                                                             **
/// **                           测试 代码                         **
/// **                                                             **
/// *****************************************************************
ClassMethod testpatient(adm)
{
	;EPR> d ##Class(EPRservice.SystemData).testpatient()
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetPatientInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod testclinic(adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetClinicInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod testlab(adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetLabInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod testcheck(adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetCheckInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod testtmcfee(adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetTMCFeeInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod testmcfee(adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetPatientInfo")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod testwmr(adm)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.SystemData:GetWMRInterface")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(adm)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

ClassMethod test1(arga As %String)
{
	Set rset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
	Set sc = rset.Execute(arga)
	
	While (rset.Next()) {
		s InstanceId=rset.Get("ID")
		w InstanceId,!
		s Instance=##class(EPRinstance.InstanceData).%OpenId(InstanceId)
		q:(Instance="")
		if Instance.Status="UnSave" {
			w Instance.GroupItemName,!}
	}
	Do rset.Close()
}

/// 说明：
/// 把下面内容拷贝到 EPRservice.SystemData  中，编译
/// 然后在Terminal中执行下面语句
/// w ##class(EPRservice.SystemData).DelErrScatterFormateInfo("58","-4")
/// 其中58是病人就诊RowId，-4是打印时所报的错误数字
/// CreateDate: 2008-09-22
/// CreateUser: houjian@dhcc.com.cn
/// Description: 删除EpisodeID所有ISegment和ITextDesc中的错误格式信息
/// Input：EpisodeID 病人就诊号
/// 	   ErrorNum  打印时报错信息的数字，如-2，-3等
/// Example: w ##class(EPRservice.SystemData).DelErrScatterFormateInfo("58","-4")
ClassMethod DelErrScatterFormateInfo(AEpisodeID As %String, AErrorNum As %String) As %String
{
	quit:((AEpisodeID="")||(AErrorNum="")) "EpisodeID or ErrorNum is null !!!"
	
	s blankeid = " "_AEpisodeID
	
	//清除ISegment中的错误格式信息
	s tid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,""))
	while tid '= ""
	{
		s scode =  $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,""))
		while scode '= ""
		{
			s iid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,""))
			while iid '= ""
			{
				s rowid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,iid,""))
				if rowid '= ""
				{
					do ..DelScaErrFormateInfoById("EPRinstance.ISegment",rowid,AErrorNum)
				}
				
				s iid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode,iid))
			}
			
			s scode =  $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid,scode))
		}
		
		s tid = $O(^DHCEPRI.ISegmentI("IdxForLink",blankeid,tid))
	}
	
	//清除ITextDesc中的错误格式信息
	s tid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,""))
	while tid '= ""
	{
		s tcode =  $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,""))
		while tcode '= ""
		{
			s iid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,""))
			while iid '= ""
			{
				s rowid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,iid,""))
				if rowid '= ""
				{
					do ..DelScaErrFormateInfoById("EPRinstance.ITextDesc",rowid,AErrorNum)
				}
				
				s iid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode,iid))
			}
			
			s tcode =  $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid,tcode))
		}
		
		s tid = $O(^DHCEPRI.ITextDescI("IdxForLink",blankeid,tid))
	}
	
	quit "Succeed !!!"
}

/// CreateDate: 2008-09-22
/// CreateUser: houjian@dhcc.com.cn
/// Description: 删除EpisodeID下某个ISegment和ITextDesc中的错误格式信息
/// Input：AClassName 类名
/// 	   ARowId     
/// 	   ErrorNum   打印时报错信息的数字，如-2，-3等
ClassMethod DelScaErrFormateInfoById(AClassName As %String, ARowId As %String, AErrorNum As %String)
{
	quit:((AClassName=0)||(ARowId="")||(AErrorNum="")) "0"
	
	//错误的格式信息标志
	s tag = "</StartPos><EndPos>"_AErrorNum_"</EndPos><FontStruct>"
		
	s obj = $zobjclassmethod(AClassName,"%OpenId",ARowId)
	if obj '= ""
	{
		//备份流数据
		s len = 32000
		s ^DHCEPRBackupScatterData(AClassName,ARowId) = obj.FormateInfo.Read(.len)
		while (len '= -1)
		{
			s ^DHCEPRBackupScatterData(AClassName,ARowId) = ^DHCEPRBackupScatterData(AClassName,ARowId)_obj.FormateInfo.Read(.len)
		} 
		
		s strTot = ^DHCEPRBackupScatterData(AClassName,ARowId)
		s count = $Length(strTot,"<FormatRange>")
		if (count > 1)   //包含格式信息
		{
			s modifiedStr = ""
			for I = 1:1:count
			{
				s str = $p(strTot,"<FormatRange>",I)
				if $find(str,tag)
				{	s modifiedStr = modifiedStr_$p(str,"</FormatRange>",2)}
				else
				{	
					if I = 1
					{ s modifiedStr = str}
					else
					{ s modifiedStr = modifiedStr_"<FormatRange>"_str}	
				}
			}
			do obj.FormateInfo.Clear()
			do obj.FormateInfo.Write(modifiedStr)
			do obj.%Save()
			w AClassName_" "_ARowId_" Succeed!!!",!		
		}	
	}
	
	quit
}

/// w ##Class(EPRservice.SystemData).TestSaveData(ArgInstancedataID)
/// 作用：数据保存失败后台测试
/// 
ClassMethod TestSaveData(id)
{
	//b "s"
	
	//s obj = ..GetGroupDataByID(id)
	
	s obj = ##class(EPRservice.BOInstanceData).GetDataByID(id)
	
	if obj '= ""
	{
		//Set file=##class(%File).%New("E:\textfile.txt")
		//Do file.Open("RS")
		//Do obj.InstanceData.CopyFrom(file)

		//do ##class(EPRservice.BOInstanceData).SaveData(obj)
		do ##class(EPRservice.BOInstanceData).SaveMultipleData(obj)
	}
	
	w "succeed!"
}

/// d ##class(%ResultSet).RunQuery("EPRservice.SystemData","GetLastInstanceDataInfo","21","54")
Query GetLastInstanceDataInfo(EpisodeID As %String, ChartItemID As %String) As %Query(ROWSPEC = "InstanceData:%String")
{
}

ClassMethod GetLastInstanceDataInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLastInstanceDataInfoExecute ]
{
	if qHandle'=""
	{
	s Row=qHandle
	s qHandle=""
	}
	else
	{
	s Row = ""
	s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetLastInstanceDataInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aChartItemID As %String) As %Status
{
	s qHandle=""
	q:(($d(aEpisodeID)=0)||(aEpisodeID="")||($d(aChartItemID)=0)||(aChartItemID="")) $$$OK
	//初始化返回值
	s retVal = ""
	
	//判断历次病历是否保存过
	s ECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID("", aEpisodeID, aChartItemID)
	q:(ECRecordID="") $$$OK
	
	s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,""))
	q:(listNo="") $$$OK
	
	//取HappenDate、HappenTime在最后的一条记录
	s repid = $I(^CacheTemp)
	while (listNo '= "")
	{
	s instanceid = ECRecordID_"||"_listNo
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
	if (objInstance '= "")&&(objInstance.HappenDate '= "")&&(objInstance.HappenTime '= "")
	{
	s date = objInstance.HappenDate
	s time = objInstance.HappenTime
	s ^CacheTemp(repid, date, time) = instanceid
	}
	s listNo = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ECRecordID,listNo))
	}
	q:($d(^CacheTemp(repid))=0) $$$OK
	
	s date = $O(^CacheTemp(repid,""), -1)
	s time = $O(^CacheTemp(repid,date,""), -1)
	s lastInstanceId = ^CacheTemp(repid, date, time)
	kill ^CacheTemp(repid)
	q:(lastInstanceId="") $$$OK
	
	//得到了最后一条记录的rowid, 取需要的信息
	if (aChartItemID="ML6") //历次病程记录
	{
	s retVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "E0001", lastInstanceId, "V") //和其它需要取的信息
	}
	elseif (aChartItemID=386) //危重护理记录
	{
	s tempVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0009", lastInstanceId, "V") //体温
	s plusVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0010", lastInstanceId, "V") //脉搏
	s breathVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0011", lastInstanceId, "V") //呼吸
	s pressVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0012", lastInstanceId, "V") //血压
	s leftVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0039", lastInstanceId, "V") //左瞳
	s leftlightVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0041", lastInstanceId, "V") //左瞳对光反应
	s rightVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0040", lastInstanceId, "V") //右瞳
	s rightlightVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0042", lastInstanceId, "V") //右瞳对光反应
	s spo2Val = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0037", lastInstanceId, "V") //SPO2
	s mindVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0038", lastInstanceId, "V") //神志
	s incomemodeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0043", lastInstanceId, "V") //入量项目
	s incomeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0044", lastInstanceId, "V") //入量
	s outcomemodeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0051", lastInstanceId, "V") //出量项目
	s outcomeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0047", lastInstanceId, "V") //出量
	s DescVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "E0017", lastInstanceId, "V") //病情记录
	s retVal = "体温:"_tempVal_"℃ 脉搏:"_plusVal_"次/分 呼吸:"_breathVal_"次/分 血压:"_pressVal_"mmHg 左瞳:"_leftVal_"cm 左瞳对光反应:"_leftlightVal_" 右瞳:"_rightVal_"cm 右瞳对光反应:"_rightlightVal_" SPO2:"_spo2Val_"% 神志:"_mindVal_" 入量项目:"_incomemodeVal_" 入量:"_incomeVal_"ml 出量项目:"_outcomemodeVal_" 出量:"_outcomeVal_"ml"_$C(13)_DescVal
	}
	elseif (aChartItemID="ML124") //神经外科危重患者护理记录单
	{
	s tempVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0009", lastInstanceId, "V") //体温
	s plusVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0010", lastInstanceId, "V") //脉搏
	s breathVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0011", lastInstanceId, "V") //呼吸
	s pressVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0012", lastInstanceId, "V") //血压
	s leftVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0039", lastInstanceId, "V") //左瞳
	s leftlightVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0041", lastInstanceId, "V") //左瞳对光反应
	s rightVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0040", lastInstanceId, "V") //右瞳
	s rightlightVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0042", lastInstanceId, "V") //右瞳对光反应
	s spo2Val = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0037", lastInstanceId, "V") //SPO2
	s gcsVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0055", lastInstanceId, "V") //GCS
	s mindVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0059", lastInstanceId, "V") //神志
	s incomemodeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0043", lastInstanceId, "V") //入量项目
	s incomeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0044", lastInstanceId, "V") //入量
	s outcomemodeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "O0051", lastInstanceId, "V") //出量项目
	s outcomeVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "S0047", lastInstanceId, "V") //出量
	s DescVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "E0017", lastInstanceId, "V") //病情记录
	s retVal = "体温:"_tempVal_"℃ 脉搏:"_plusVal_"次/分 呼吸:"_breathVal_"次/分 血压:"_pressVal_"mmHg 左瞳:"_leftVal_"cm 左瞳对光反应:"_leftlightVal_" 右瞳:"_rightVal_"cm 右瞳对光反应:"_rightlightVal_" SPO2:"_spo2Val_"% GCS:"_gcsVal_"分 神志:"_mindVal_" 入量项目:"_incomemodeVal_" 入量:"_incomeVal_"ml 出量项目:"_outcomemodeVal_" 出量:"_outcomeVal_"ml"_$C(13)_DescVal
	}
	elseif (aChartItemID="ML98") //一般护理记录单
	{
	s DescVal = ##class(EPRservice.BOScatterData).GetMultipleScatterData(aEpisodeID, objInstance.TemplateID, "E0026", lastInstanceId, "V") //病情记录
	s retVal= DescVal
	}
	//elseif (aChartItemID=55)
	//{}
	
	
	s myQueryResult = $LB(retVal)
	s qHandle = myQueryResult
	
	Quit $$$OK
}

ClassMethod GetLastInstanceDataInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLastInstanceDataInfoExecute ]
{
	s qHandle=""
	Quit $$$OK
}

}
