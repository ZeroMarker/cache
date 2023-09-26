Class web.DHCDocIPBookNew Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 新住院证类
/// 获取患者信息 患者ID>患者登记号>就诊ID 入参优先集
/// input  患者ID:PatientID,患者登记号:PatientNO,就诊ID:AdmID
/// outPut 患者信息
/// w ##class(web.DHCDocIPBookNew).GetPatDetail(1)
/// outPut:
/// ;患者ID^登记号^姓名^性别^出生日期^年龄^身份证^国家^省^市^婚姻状况^民族^
/// ;手机^联系电话^文化程度^工作单位^^家庭地址^病案号^人员类型^
/// ;联系人姓名^联系人电话^联系人关系^联系人关系ID^患者级别^患者密级
ClassMethod GetPatDetail(PatientID As %String, PatientNO As %String = "", AdmID As %String = "") As %String
{
	Set langid=20
    if ($d(%session)){
        s langid=+$g(%session.Data("LOGON.LANGID"))
        s logonHospID=%session.Get("LOGON.HOSPID")
    }
	s MastPatiD=PatientID
	;登记号
	if (MastPatiD="")&&(PatientNO'="") d
	.s MastPatiD=$o(^PAPERi("PAPMI_PatNo",PatientNO,""),-1) 
	;就诊ID
	if (MastPatiD="")&&(AdmID'="")  d
	.s MastPatiD=$P($G(^PAADM(AdmID)),"^",1)
	s Str=$$GetPatMesage(MastPatiD)
	q Str
GetPatMesage(MastPatiD)
	s PAPMIRowId=MastPatiD
	Q:PAPMIRowId="" ""
	
	s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1) ;姓名
	
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2) ;性别
	s sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",sex,langid)
	
	;出生日期/年龄
	s today=..%SysDate()
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	i birth'="" s birthdate=..%ZD(birth) //$zd(birth,3) 
	s age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PAPMIRowId,AdmID,logonHospID)
	
	;社会地位（人员类型）
	s SocialDESC="" 
	s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10) 
	s:SocialStatusDR'="" SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
	s SocialDESC=##class(User.CTSocialStatus).GetTranByDesc("SSDesc",SocialDESC,langid)
	;省
	s ProvinceDesc=""
	s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
	s ProvinceDR=+ProvinceDR        
	i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
	s ProvinceDesc=##class(User.CTProvince).GetTranByDesc("PROVDesc",ProvinceDesc,langid)
	i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	;市
	s CityBirthDesc=""
	s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
	s CityBirthDR=+CityBirthDR
	i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
	s CityBirthDesc=##class(User.CTCity).GetTranByDesc("CTCITDesc",CityBirthDesc,langid)
	i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
	
	;身份证号码
	s papmiId=$P($G(^PAPER(PAPMIRowId,"ALL")),"^",9 )  ;身份证 证件类型
	if papmiId=""  d
	.s myCredTypeDesc=""
	.s myCredTypeID=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",7)
	.s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	.if myCredTypeDesc["身份证"  d
	..s papmiId=$p($g(^PAPER(PAPMIRowId,"PAT",3)),"^",6)
	s papmiId=$tr(papmiId," ","")
	
	;登记号
	s regno=$p(^PAPER(PAPMIRowId,"PAT",1),"^",2)
	
	;家庭住址,工作单位
	s SecondAddress=$g(^PAPER(PAPMIRowId,"PER","ADD",1))
	s workAdress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)
	
	;联系人关系
	s RelationDesc=""
	s RelationID=$p($g(^PAPER(PAPMIRowId,"EMP")),"^",4)
	s:RelationID'="" RelationDesc=$P($g(^CT("RLT",RelationID)),"^",2)
	s RelationDesc=##class(User.CTRelation).GetTranByDesc("CTRLTDesc",RelationDesc,langid)
	;联系人	
	s RelationName = $p($g(^PAPER(PAPMIRowId,"PER",2)),"^",13)   
	
	;联系人电话
	s RelationPhone=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4) 
	
	;婚姻状况
	s MaritalDesc=""
	s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2)
	s MaritalDesc=##class(User.CTMarital).GetTranByDesc("CTMARDesc",MaritalDesc,langid)
	;民族 
	s nationDesc=""
	s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
	i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
	s nationDesc=##class(User.CTNation).GetTranByDesc("CTNATDesc",nationDesc,langid)
	i $g(nationDesc)'="" {
		i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
	}
	;手机
	s telphone=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",21)
	
	;联系电话
	s Tel=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
	
	
	;文化程度
	s educationDesc=""
	s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
	i educationdr'="" s educationDesc=$p($G(^CT("EDU",+Marital)),"^",2) 
	s educationDesc=##class(User.CTEducation).GetTranByDesc("EDUDesc",educationDesc,langid)
	;??
	s PatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8) 
	s PatCategoryDR=+PatCategoryDR
	i PatCategoryDR'=0 s PatCategoryDesc=$p(^PAC("PCAT",PatCategoryDR),"^",2)
	
	;国家
	s countryDesc=""
	s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
	i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
	s countryDesc=##class(User.CTCountry).GetTranByDesc("CTCOUDesc",countryDesc,langid)
	i $g(ProvinceDesc)=$g(CityBirthDesc) s CityBirthDesc=""
	
	;病案号-获取住院病历号
	s MrNo=##class(web.DHCDocOrderCommon).GetMrNo("",PAPMIRowId,"I","")
	s:MrNo="" MrNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",22) 
	
	
	;病人级别和密级
	s EmployeeFunction="",SecretLevel=""
	s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PAPMIRowId,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
	;患者ID^登记号^姓名^性别^出生日期^年龄^身份证^国家^省^市^婚姻状况^民族^
	;手机^联系电话^文化程度^工作单位^^家庭地址^病案号^人员类型^
	;联系人姓名^联系人电话^联系人关系^联系人关系ID^患者级别^患者密级
	s s=PAPMIRowId_"^"_regno_"^"_$g(name)_"^"_$g(sex)_"^"_$g(birthdate)_"^"_$g(age)
	s s=s_"^"_$g(papmiId)_"^"_$g(countryDesc)_"^"_$g(ProvinceDesc)_"^"_$g(CityBirthDesc)
	s s=s_"^"_$g(MaritalDesc)_"^"_$g(nationDesc)_"^"_$g(telphone)_"^"_$G(Tel)
	s s=s_"^"_$g(educationDesc)_"^"_$g(workAdress)
	s s=s_"^"_$g(PatCategoryDesc)_"^"_$g(SecondAddress)
	s s=s_"^"_$g(MrNo)_"^"_$g(SocialDESC)
	s s=s_"^"_$G(RelationName)_"^"_$G(RelationPhone)_"^"_$G(RelationDesc)_"^"_$G(RelationID)
	s s=s_"^"_$G(EmployeeFunction)_"^"_$G(SecretLevel)
	q s
}

/// creater lxz
/// desc 新住院证comb维护数据公共Comb
/// 类型 CombName 
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookNew","CombListFind","InDoctor",41,"41||1","","","","")
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookNew","CombListFind","InWard",110,"",3,"","","")
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookNew","CombListFind","DHCDocIPBDictory","IPBookingState","","Booking^Cancel","","","")
Query CombListFind(CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "", HospID = "") As %Query(ROWSPEC = "CombDesc:%String,CombValue:%String,selected:%Boolean,Alias:%String")
{
}

ClassMethod CombListFindExecute(ByRef qHandle As %Binary, CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "", HospID = "") As %Status
{
	s:CombName="InWard" ^CombListFind("CombListFind")=CombName_","_Inpute1_","_Inpute2_","_Inpute3_","_Inpute4_","_Inpute5_","_Inpute6
	;s $ZT="ErrorCombListFind"
	Set langid=..%LanguageID()
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	k TempList,TempIdList
	if (CombName="DHCDocIPBDictory"){
		;获取字典数据共工方法
		d PublciDictory
	}elseif(CombName="InCtloc"){
		;住院科室初始化
		d InCtloc
	}elseif(CombName="InWard"){
		;通过科室获取病区
		d InWard
	}elseif(CombName="InBed"){
		;通过病区获取床位
		d InBed
	}elseif(CombName="CTLocMedUnit"){
		;通过病区取医疗单元
		d CTLocMedUnit
	}elseif(CombName="InDoctor"){
		;通过病区取住院医师  或者通过医疗单元取住院医师
		d InDoctor
	}elseif(CombName="AdmInitState"){
		;获取病情数据
		d AdmInitState
	}elseif(CombName="InSorce"){
		;获取入院途径数据
		d InSorce
	}elseif(CombName="DiaStatus"){
		;获取诊断状态
		d DiaStatus
	}elseif(CombName="ReAdmission"){
		;再入院标志
		d ReAdmission
	}elseif(CombName="InAdmReasonData"){
		;入院费别
		d InAdmReason
	}
	
	//统一输出接口
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sub0=0
 	f  s Sub0=$O(TempList(Sub0)) Q:Sub0=""  d
 	.s CombDesc=$P($G(TempList(Sub0)),"^",1)
 	.s CombValue=$P($G(TempList(Sub0)),"^",2)
 	.q:$d(TempIdList(CombValue))
 	.s TempIdList(CombValue)=1
 	.s DefaultComb=$P($G(TempList(Sub0)),"^",3)
 	.s Alias=$P($G(TempList(Sub0)),"^",4)
 	.d OutputRow
 	k TempList,TempIdList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(CombDesc,CombValue,DefaultComb,Alias)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
DiaStatus
	s diaId=0 f  s diaId=$o(^MRC("DSTAT",diaId)) q:diaId=""  d
    .s code=$p(^MRC("DSTAT",diaId),"^",1)
    .s desc=$p(^MRC("DSTAT",diaId),"^",2)
	.s desc =##class(User.MRCDiagnosStatus).GetTranByDesc("DSTATDesc",desc,langid)
    .s JNO=JNO+1
	.s TempList(JNO)=desc_"^"_diaId_"^"_0
	q
ReAdmission
	s Ysel=0,Nsel=0
	s PatId=Inpute1
	i PatId'="" {
		s CheckReAdmssion=..CheckReAdmssion(PatId,15)
		i CheckReAdmssion="Y" s Ysel=1
		e  s Nsel=1
	}
	s TempList(1)="是"_"^"_"Y"_"^"_Ysel
	s TempList(2)="否"_"^"_"N"_"^"_Nsel
	q
InAdmReason
	s PatDr=Inpute1
	s HospID=Inpute2
	s JNO=0
	s CurrDate=+$h
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_PACADM",HospID)
	if $D(^PAPER(PatDr,"PER",1)) d
 	.Set PAPERStateCodeDR=$p(^PAPER(PatDr,"PER",1),"^",10)
 	s myBMRowid=0 f  {
	 	s myBMRowid=$o(^DHCPACADM(0,"Social",PAPERStateCodeDR,myBMRowid)) 
	 	q:myBMRowid=""
		if $D(^DHCPACADM(myBMRowid)) {
			s PACAdmReasonDr=$p(^DHCPACADM(myBMRowid),"^",2)
			s PACHospDr=$p(^DHCPACADM(myBMRowid),"^",5)
			continue:PACHospDr'=HospID
			s StartDate=$p($g(^PAC("ADMREA",PACAdmReasonDr)),"^",3)
			s EndDate=$p($g(^PAC("ADMREA",PACAdmReasonDr)),"^",4)
			continue:(StartDate'="")&&(StartDate>CurrDate)
			continue:(EndDate'="")&&(EndDate<CurrDate)
			s mydes=$p($g(^PAC("ADMREA",PACAdmReasonDr)),"^",2)
			s JNO=JNO+1
			s mydes=##class(User.PACAdmReason).GetTranByDesc("READesc",mydes,langid)
			s TempList(JNO)=mydes_"^"_PACAdmReasonDr_"^"_0
		}
 	}
	q
InSorce
	;获取入院途径数据
	s Type=Inpute1 ;数据类型
	s Default=Inpute2 ;默认数据
	s Display=Inpute3 ;显示数据Code
	s SessLoc=Inpute4
	s IsEmergency=0
	i SessLoc'="" {
		s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(SessLoc)
	}
	s JNO=0
	s ID=0
	f  s ID=$O(^PAC("ADSOU",ID)) Q:ID=""  d
	.s Str=$G(^PAC("ADSOU",ID))
	.s Code=$P(Str,"^",1)
	.s Desc=$P(Str,"^",2)
	.s StDate=$P(Str,"^",4)
	.s EnDate=$P(Str,"^",5)
	.Q:(StDate'="")&&(StDate>+$H)
	.Q:(EnDate'="")&&(EnDate<+$H)
	.s DefaultC=0
	.s:(IsEmergency=0)&&(Desc="门诊") DefaultC=1 ;默认显示,无可用对照code，暂用描述对照
	.s:(IsEmergency=1)&&(Desc="急诊") DefaultC=1 ;默认显示,无可用对照code，暂用描述对照
	.s:(Default'="")&&(Default=Code) DefaultC=1 ;默认显示
	.Q:(Display'="")&&(("^"_Display_"^")'[("^"_Code_"^")) ;显示数据
	.s JNO=JNO+1
	.s TempList(JNO)=Desc_"^"_ID_"^"_DefaultC
	q
	
AdmInitState
	;获取病情数据
	s Type=Inpute1 ;数据类型
	s Default=Inpute2 ;默认数据
	s Display=Inpute3 ;显示数据Code
	s JNO=0
	s ID=0
	f  s ID=$O(^PAC("REFPRI",ID)) Q:ID=""  d
	.s Str=$G(^PAC("REFPRI",ID))
	.s Code=$P(Str,"^",1)
	.s Desc=$P(Str,"^",2)
	.s StDate=$P(Str,"^",8)
	.s EnDate=$P(Str,"^",9)
	.s Desc =##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc",Desc,langid)
	.s DefaultC=0
	.s:(Default'="")&&(Default=Code) DefaultC=1 ;默认显示
	.Q:(Display'="")&&(("^"_Display_"^")'[("^"_Code_"^")) ;显示数据
	.s JNO=JNO+1
	.s TempList(JNO)=Desc_"^"_ID_"^"_DefaultC
	q
InDoctor
	//通过病区取住院医师  或者通过医疗单元取住院医师
	s wardid=+Inpute1
	s CTMURowId=Inpute2
	if (CTMURowId'=""){
		s JNO=0
		s MUCPChild=0 f  s MUCPChild=$o(^CTLOC(+CTMURowId,"MU",$p(CTMURowId,"||",2),"CP",MUCPChild)) q:MUCPChild=""  d
		.s MUCPDateFrom=$p(^CTLOC(+CTMURowId,"MU",$p(CTMURowId,"||",2),"CP",MUCPChild),"^",5)
		.s MUCPDateTo=$p(^CTLOC(+CTMURowId,"MU",$p(CTMURowId,"||",2),"CP",MUCPChild),"^",6)
		.q:((+$H<MUCPDateFrom)&&(MUCPDateFrom'=""))||((MUCPDateTo'="")&&(+$H>MUCPDateTo))
		.s MUCPDoctorDR=$p(^CTLOC(+CTMURowId,"MU",$p(CTMURowId,"||",2),"CP",MUCPChild),"^",1)
		.s MUCPDoctorDesc=""
		.i MUCPDoctorDR'=""  s MUCPDoctorDesc=$p(^CTPCP(MUCPDoctorDR,1),"^",2)
		.Set MUCPDoctorDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MUCPDoctorDesc,langid)
		.s JNO=JNO+1
	    .s TempList(JNO)=MUCPDoctorDesc_"^"_MUCPDoctorDR_"^"_0
	}elseif(wardid'="")&&(CTMURowId=""){
		s JNO=0
		s ResRowId=0 f  s ResRowId=$o(^RB("RES",0,"CTLOC",wardid,ResRowId)) q:ResRowId=""  d
		.s ResDateFrom=$p(^RB("RES",ResRowId),"^",22)
		.s ResDateTo=$p(^RB("RES",ResRowId),"^",23)
		.q:((+$H<ResDateFrom)&&(ResDateFrom'=""))||((ResDateTo'="")&&(+$H>ResDateTo))
		.s InDoctorDR=$p(^RB("RES",ResRowId),"^",2)
		.s InDoctorDesc=""
		.i InDoctorDR'="" s InDoctorDesc=$p(^CTPCP(InDoctorDR,1),"^",2)
		.Set InDoctorDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",InDoctorDesc,langid)
		.s JNO=JNO+1
	    .s TempList(JNO)=InDoctorDesc_"^"_InDoctorDR_"^"_0
	}
	q
CTLocMedUnit
	//通过病区取医疗单元
	s wardid=+Inpute1
	if wardid'=0  d
	.s stdate=..%SysDate()
	.s JNO=0
	.s CTMUChild=0 f  s CTMUChild=$O(^CTLOC(wardid,"MU",CTMUChild)) q:CTMUChild=""  d
	..s CTMUActive=$p(^CTLOC(wardid,"MU",CTMUChild),"^",3)
	..q:CTMUActive'="Y"
	..s CTMUIPFlag=$p(^CTLOC(wardid,"MU",CTMUChild),"^",7)
	..q:CTMUIPFlag'="Y"
	..s CTMUDataFrom=$p(^CTLOC(wardid,"MU",CTMUChild),"^",4)
	..s CTMUDataTo=$p(^CTLOC(wardid,"MU",CTMUChild),"^",5)
	..q:((stdate<CTMUDataFrom)&&(CTMUDataFrom'=""))||((CTMUDataTo'="")&&(stdate>=CTMUDataTo))
	..s CTMUDesc=$p(^CTLOC(wardid,"MU",CTMUChild),"^",2)
	..Set CTMUDesc= ##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUDesc",CTMUDesc,langid)
	..s JNO=JNO+1
	..s TempList(JNO)=CTMUDesc_"^"_wardid_"||"_CTMUChild_"^"_0	
	q
	
InBed
	;通过病区获取床位
	s wardid=+Inpute1
	if wardid'=0  d
	.s stdate=..%SysDate()
	.s JNO=0
	.s bedid="0"  
	.f  s bedid=$o(^PAWARD(wardid,"BED",bedid))  q:bedid=""   d
	..s beddesc=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	..s datefrom=$p(^PAWARD(wardid,"BED",bedid),"^",21)
	..s dateto=$p(^PAWARD(wardid,"BED",bedid),"^",22)
	..s BEDRcFlag=$p(^PAWARD(wardid,"BED",bedid),"^",4)
	..q:(BEDRcFlag'="Y")
	..q:(datefrom'="")&(stdate<datefrom)
	..q:(dateto'="")&(stdate>dateto)
	..s bedrowid=wardid_"||"_bedid
	..s warddesc=$p(^PAWARD(wardid),"^",2)
	..s warddesc=##class(User.PACWard).GetTranByDesc("WARDDesc",warddesc,langid)
	..Q:'$$IsAvailBed(bedrowid)
	..s JNO=JNO+1
	..s TempList(JNO)=beddesc_"^"_bedrowid_"^"_0
	q
InWard
	;通过科室获取病区
	s cLoc=+Inpute1
	;获取病区类型
	s WardFlag=+Inpute3
	s PatientID=Inpute2
	if (PatientID'=""){
		s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
		s DOB=$p(^PAPER(PatientID,"ALL"),"^",6)
		s PatAge=+##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID)
	}
	s LogonHospDr=""
	if (cLoc'=0) {
		s LogonHospDr=$p($g(^CTLOC(cLoc)),"^",22)
	}else{
		if $d(%session) s LogonHospDr=%session.Get("LOGON.HOSPID")
	}
	
	if (WardFlag=1)||(WardFlag=0)  d
	.;显示住院科室关联得本科室下得病区
	.s JNO=0
	.if cLoc'=0  d
	..q:'$d(^CTLOC(+cLoc))
	..s ChildSub=0
	..f  s ChildSub=$o(^CTLOC(+cLoc,"LINK",ChildSub)) q:ChildSub=""  d
	...s cLocRowid=+$g(^CTLOC(+cLoc,"LINK",ChildSub))
	...q:cLocRowid=0
	...q:'$d(^CTLOC(+cLocRowid))
	...q:'$d(^PAWARD(0,"WARD_LocationDR",+cLocRowid))
	...s WARDID=0
	...f  s WARDID=$o(^PAWARD(0,"WARD_LocationDR",+cLocRowid,WARDID)) q:WARDID=""  d
	....q:$p($g(^PAWARD(+WARDID)),"^",6)'="Y"
	....s WardDesc=$p($g(^PAWARD(+WARDID)),"^",2)
	....s WardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",WardDesc,langid)
	....s WardDesc=##class(web.DHCOPAdmReg).LocDescFormate(WardDesc)
	....s JNO=JNO+1
	....s DefaultDis=0
	....S:JNO=1 DefaultDis=1
	....s WardLocationDR=$p($g(^PAWARD(+WARDID)),"^",5)
	....Q:(PatientID'="")&&(##class(web.UDHCJFIPReg).GetSexAndAgeByLoc(WardLocationDR,PatSexDr,PatAge,DOB)'="")
	....s ContactName=$p($g(^CTLOC(WardLocationDR)),"^",43)
	....s CtLocHopDr=$p($g(^CTLOC(WardLocationDR)),"^",22)
	....q:CtLocHopDr'=LogonHospDr
	....s TempList(JNO)=WardDesc_"^"_WARDID_"^"_DefaultDis_"^"_ContactName
	else  if WardFlag=2  d
	.;显示住院科室下维护的其他病区
	.s JNO=0
	.if cLoc'=0  d
	..s linkwardstr=..GetLinkWard(cLoc)
	..f i=1:1:$L(linkwardstr,"!")  d
	...s oneward=$P(linkwardstr,"!",i)
	...Q:oneward=""
	...s wardesc=$P(oneward,"^",1)
	...s wardr=$P(oneward,"^",2)
	...s warddesc=##class(User.PACWard).GetTranByDesc("WARDDesc",warddesc,langid)
	...s JNO=JNO+1
	...s DefaultDis=0
	...;S:JNO=1 DefaultDis=1
	...s WardLocationDR=$p($g(^PAWARD(+wardr)),"^",5)
	...Q:(PatientID'="")&&(##class(web.UDHCJFIPReg).GetSexAndAgeByLoc(WardLocationDR,PatSexDr,PatAge,DOB)'="")
	...s ContactName=$p($g(^CTLOC(WardLocationDR)),"^",43)
	...s CtLocHopDr=$p($g(^CTLOC(WardLocationDR)),"^",22)
	...q:CtLocHopDr'=LogonHospDr
	...s TempList(JNO)=wardesc_"^"_wardr_"^"_DefaultDis_"^"_ContactName
	else  if WardFlag=3  d
	.if cLoc'=0  d
	..;无限制得时候显示所有病区/获取无限制标识
	..s limitfalg=..GetLocCureLimit(cLoc)
	..Q:limitfalg'="Y"
	..s JNO=0
	..k listpx
	..s wardr=0
	..f  s wardr=$O(^PAWARD(wardr)) Q:wardr=""  d
	...Q:'$D(^PAWARD(wardr))||($G(^PAWARD(wardr))="")
	...s warddesc=$P(^PAWARD(wardr),"^",2)
	...s warddesc=##class(User.PACWard).GetTranByDesc("WARDDesc",warddesc,langid)
	...s active=$P(^PAWARD(wardr),"^",6)
	...Q:active'="Y"
	...s adtivedatefrom=$P(^PAWARD(wardr),"^",7)
	...Q:((adtivedatefrom'="")&(adtivedatefrom>+$H))
	...s adtivedateto=$P(^PAWARD(wardr),"^",9)
	...Q:((adtivedateto'="")&(adtivedateto<+$H))
	...s:warddesc["-" warddesc=$P(warddesc,"-",2)
	...Q:warddesc=""
	...s listpx(warddesc,wardr)=""
	..
	..;进行描述排序
	..s sub1=0
	..f  s sub1=$O(listpx(sub1)) Q:sub1=""  d
	...s sub2=0
	...f  s sub2=$O(listpx(sub1,sub2)) Q:sub2=""  d
	....Q:sub2=""
	....s warddesc=sub1
	....s wardr=sub2
	....s JNO=JNO+1
	....s DefaultDis=0
	....s WardLocationDR=$p($g(^PAWARD(+wardr)),"^",5)
	....Q:(PatientID'="")&&(##class(web.UDHCJFIPReg).GetSexAndAgeByLoc(WardLocationDR,PatSexDr,PatAge,DOB)'="")
	....s ContactName=$p($g(^CTLOC(WardLocationDR)),"^",43)
	....s CtLocHopDr=$p($g(^CTLOC(WardLocationDR)),"^",22)
	....q:CtLocHopDr'=LogonHospDr
	....;S:JNO=1 DefaultDis=1
	....s TempList(JNO)=warddesc_"^"_wardr_"^"_DefaultDis_"^"_ContactName
	q
InCtloc
	;获取科室
	s logondr=Inpute1 ;登录科室
	s BookId=Inpute2 ;传入的住院证ID,当住院证ID不为空时，显示全部的科室,防止住院证查询页面查询其他科室开的住院证时住院科室和病区显示为数字
	s logonHosp=$p($g(^CTLOC(logondr)),"^",22)
	if (BookId'="") s configlog=""
	else  s configlog=..GetIPBookLocConfig(logondr)
	s JNO=0
	s rowid=""
	f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","I",rowid))  q:rowid=""  d
	.q:($d(^CTLOC(rowid))=0)
	.q:($p($g(^CTLOC(rowid)),"^",13)'="E")
	.Q:(configlog'="")&(("^"_configlog_"^")'[("^"_rowid_"^"))
	.s CtLocHopDr=$p($g(^CTLOC(rowid)),"^",22)
	.;q:CtLocHopDr'=logonHosp
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",rowid,HospID)
	.s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	.q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
	.s Desc=$p($g(^CTLOC(rowid)),"^",2)
	.Q:(Desc["门诊")
	.q:($P(^CTLOC(rowid),"^",14)'="Y")
	.s Desc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",Desc,langid)
	.i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
	.s ContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s:ContactName["-" ContactName=$p(ContactName,"-",1)
	.s JNO=JNO+1
	.s TempList(JNO)=Desc_"^"_rowid_"^"_0_"^"_ContactName
	.//s TempList(JNO)=Desc_"^"_rowid_"^"_0
	q 
PublciDictory
	;获取对应数据字典中的数据
	s Type=Inpute1 ;数据类型
	s Default=Inpute2 ;默认数据
	s Display=Inpute3 ;显示数据Code
	if (Type'="")  d
	.s JNO=0
	.s ID=0
	.f  s ID=$O(^DHCDocIPBDIC(0,"TYPE",Type,"Y",ID)) Q:ID=""  d
	..Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHCDocIPBDictory",ID,HospID)
	..s Str=$G(^DHCDocIPBDIC(ID))
	..s Code=$P(Str,"^",1)
	..s Desc=$P(Str,"^",2)
	..s StDate=$P(Str,"^",5)
	..s EnDate=$P(Str,"^",6)
	..Set Desc= ##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",Desc,langid)
	..q:(StDate'="")&&(StDate>+$h)
	..q:(EnDate'="")&&(EnDate<+$h)
	..s DefaultC=0
	..s:(Default'="")&&(Default=Code) DefaultC=1 ;默认显示
	..Q:(Display'="")&&(("^"_Display_"^")'[("^"_Code_"^")) ;显示数据
	..s JNO=JNO+1
	..s TempList(JNO)=Desc_"^"_ID_"^"_DefaultC
	q
ErrorCombListFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IsAvailBed(BedRowId)
	s avail=1
	s WardID=$P(BedRowId,"||",1)
	s BedSub=$P(BedRowId,"||",2)
	s BedSTATSub=$o(^PAWARDA(WardID,"BED",BedSub,"STAT",""),-1)
	i BedSTATSub'="",BedSTATSub'=0 d
    .s STATDateTo=$p($g(^PAWARDA(WardID,"BED",BedSub,"STAT",BedSTATSub)),"^",5)
	.s STATTimeTo=$p($g(^PAWARDA(WardID,"BED",BedSub,"STAT",BedSTATSub)),"^",6)
	.if (STATDateTo'="")&((STATDateTo<$p($h,",",1))!((STATDateTo=..%SysDate())&(STATTimeTo<..%SysTime()))) s avail=0
	if avail=1 {
		s BedADMSub=$o(^PAWARDA(WardID,"BED",BedSub,"ADM",""),-1)
		i BedADMSub'="",BedADMSub'=0 {
			s BedADMDr=$p(^PAWARDA(WardID,"BED",BedSub,"ADM",BedADMSub),"^",1)
			i BedADMDr'="" s avail=0
		}
	}
	Q avail
}

ClassMethod CombListFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CombListFindExecute ]
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

ClassMethod CombListFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CombListFindExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取所选就诊的所有ICD诊断
/// w ##class(web.DHCDocIPBookNew).GetAdmICDList(299)
ClassMethod GetAdmICDList(Adm) As %String
{
	Q:Adm="" ""
	s DiaStr=""
	s mrrowid=$p($G(^PAADM(Adm)),"^",61)
	s rs=##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d rs.Execute(mrrowid)
	while rs.Next(){
		s MainMRDiagnoeRowId=rs.GetDataByName("MRDIAMRDIADR")
		continue:MainMRDiagnoeRowId'=""
		s MRDIARowId=rs.GetDataByName("MRDIARowId")
		s Desc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(MRDIARowId)
		s ICDRowid=rs.GetDataByName("MRCIDRowId")
		s DiagnosStatusRowId=rs.GetDataByName("DiagnosStatusRowId")
		s DiagnosStatus=rs.GetDataByName("DiagnosStatus")
		s:DiagnosStatus'="" Desc=Desc_"("_DiagnosStatus_")"
		s DiagnosCat=rs.GetDataByName("DiagnosCat")
		s DiagnosNotes=rs.GetDataByName("DiagnosNotes")
		s DiagnosPrefix=rs.GetDataByName("DiagnosPrefix")
		s SDSInfo=$Replace(rs.GetDataByName("SDSInfo"),"^",$C(1))
		s ChildDiagStr=""
		s ChildSub=0 for{
			s ChildSub=$O(^MR(mrrowid,"DIA",0,"Link",MRDIARowId,ChildSub)) Q:ChildSub=""
			s ChildDesc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(mrrowid_"||"_ChildSub)
			s ChildICDRowid=$P(^MR(mrrowid,"DIA",ChildSub),"^",1)
			s DESSub=$G(^MR(mrrowid,"DIA",ChildSub,"DES",0))
			s Note=$CASE(+DESSub,0:"",:$G(^MR(mrrowid,"DIA",ChildSub,"DES",DESSub)))
			s Prefix=$P($G(^MR(mrrowid,"DIA",ChildSub,1)),"^",26)
			s ChildStr=ChildICDRowid_$C(3)_ChildDesc_$C(3)_Note_$C(3)_Prefix
			i ChildDiagStr="" s ChildDiagStr=ChildStr
			e  s ChildDiagStr=ChildDiagStr_$C(1)_ChildStr
		}
		;格式就为住院证保存的格式，省略掉前台转换过程
		s str=ICDRowid_$C(2)_Desc_$C(2)_DiagnosStatusRowId_$C(2)_DiagnosCat_$C(2)_DiagnosNotes_$C(2)_DiagnosPrefix_$C(2)_SDSInfo_$C(2)_ChildDiagStr
		if DiaStr="" s DiaStr=str
		else  s DiaStr=DiaStr_"!"_str
	}
	Q DiaStr
}

/// 获取就诊信息
ClassMethod GetPatAdmMes(AdmID) As %String
{
	Q:AdmID="" ""
	s AdmDate=$p($g(^PAADM(AdmID)),"^",6)
 	s Admi=AdmID
	S RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	Q:RegfeeRowId="" ""
	s object=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	s QueueNo=object.RegfeeNo
	s InvoiceId=object.Regfeetemp1.%Id()
	s DepID=object.RegfeeDepDr.%Id()
	s MarkDr=object.RegfeeDocDr.%Id()
	s TRRowId=object.RegfeeTimeRangeDr.%Id()
 	s:DepID'="" CTloc=$P(^CTLOC(DepID),"^",2)
 	s:$G(CTloc)["-" CTloc=$P(CTloc,"-",2)
 	s:MarkDr'="" MarkDesc=$p($g(^CTPCP(MarkDr,1)),"^",2)
 	s AdmDoc=$P(^PAADM(AdmID),"^",9) ;设置到达的时候该位置会变为接诊医生 没有接诊为号别
 	s:AdmDoc'="" AdmDocDesc=$p($g(^CTPCP(AdmDoc,1)),"^",2)
 	s DescStr=##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(AdmID)
 	s AdmPatID=$P(^PAADM(AdmID),"^",1)
 	s FindBook="N"
 	s BookID=0
 	f  s BookID=$O(^DHCDocIPBK(0,"EpisodeIDFrom",AdmID,BookID))  Q:(BookID="")||(FindBook="Y")  d
 	.s BookMes=..GetBookMesage(BookID)
 	.s Actuive=$P(BookMes,"^",10)
 	.Q:Actuive'="Y"
 	.s FindBook="Y"
 	;输出数据
 	s:AdmDate'="" AdmDate=..%ZD(AdmDate) //$ZD(AdmDate,3)
 	s AdmLoc=$G(CTloc)
 	s AdmMark=$G(MarkDesc)
 	s AdmDoc=$G(AdmDocDesc)
 	s AdmDias=DescStr
 	s AdmBook=$Case(FindBook,"N":"","Y":"Y","":"")
 	s RtnStr=AdmDate_"^"_AdmLoc_"^"_AdmMark_"^"_AdmDoc_"^"_AdmDias_"^"_AdmPatID_"^"_AdmID_"^"_AdmBook
 	q RtnStr
}

/// 住院证信息列表
/// input 患者ID 创建日期
/// output 住院证信息
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookNew","FindBookList",178,"","",2)
Query FindBookList(PatID As %String, FindBookDateF As %String, FindBookDateN As %String, SortNum As %String = "") As %Query(ROWSPEC = "NO:%String,BName:%String,BStatu:%String,BBDate:%String,BBCTloc:%String,BBWard:%String,BBBed:%String,BBCreaterUser:%String,BBCreaterDate:%String,BBookID:%String,BPatID:%String,BAmdID:%String,ICDListStr:%String,IPBookingNo:%String,AdmInitStateDesc:%String,rjss:%String,BTimeLiness:%String")
{
}

ClassMethod FindBookListExecute(ByRef qHandle As %Binary, PatID As %String, FindBookDateF As %String, FindBookDateN As %String, SortNum As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s NO=0
 	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")

 	i FindBookDateF'="" s FindBookDateF=..%ZDH(FindBookDateF)
 	i FindBookDateN'="" s FindBookDateN=..%ZDH(FindBookDateN)
 	s AdmTypeStr="O^E"
 	Set langid=..%LanguageID()
 	k ListID,^TDHCDOCCONFIGDATA
 
 	if PatID'=""  d
 	.;查找就诊相关的住院证
 	.for i=1:1:$L(AdmTypeStr,"^")  d
 	..s AdmTypeSub=$P(AdmTypeStr,"^",i)
 	..s AdmID=0 
 	..f  s AdmID=$O(^PAPERdr(PatID,"ADM",AdmTypeSub,AdmID)) Q:AdmID=""  d
 	...s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmID)
 	...Q:AdmHospitalId'=HospID
 	...s AdmDate=$p($g(^PAADM(AdmID)),"^",6)
 	...s AdmStatus=$P($g(^PAADM(AdmID)),"^",20)
 	...Q:AdmStatus="C"
 	...s RowID=0
 	...f  s RowID=$O(^DHCDocIPBK(0,"EpisodeIDFrom",AdmID,RowID)) Q:RowID=""  d
 	....if $$CheckMesage(RowID,FindBookDateF,FindBookDateN)  d
 	.....s ListID(RowID)=""
 	.
 	.s RowID=""
 	.f  s RowID=$O(^DHCDocIPBK(0,"PatientID",PatID,RowID),"-1") Q:RowID=""  d
 	..if $$CheckMesage(RowID,FindBookDateF,FindBookDateN)  d
 	...s ListID(RowID)=""
 	.
 	.s RowID=""
 	.f  s RowID=$O(ListID(RowID),-1) Q:RowID=""  d
 	..s BookingDate=$p(^DHCDocIPBK(RowID),"^",10) 
 	..i BookingDate="" s BookingDate=999999
 	..s ^TDHCDOCCONFIGDATA("ZYZ","BBDate")=""
 	..s ^TDHCDOCCONFIGDATA("ZYZ","BBDate",BookingDate,RowID)=""
 	.
 	.s BDate="",sortCode="1"	//1+ 2-
 	.i SortNum=2 s sortCode="-1"
 	.f  s BDate=$O(^TDHCDOCCONFIGDATA("ZYZ","BBDate",BDate),sortCode) Q:BDate=""  d
 	..s RowID=""
 	..f  s RowID=$O(^TDHCDOCCONFIGDATA("ZYZ","BBDate",BDate,RowID)) Q:RowID=""  d
 	...d OutMesage(RowID,langid)
 	.
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
CheckMesage(RowID,FindBookDateF,FindBookDateN)
	Q:'$D(^DHCDocIPBK(RowID)) 0
	s EpisodeIDFrom=$p(^DHCDocIPBK(RowID),"^",2)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeIDFrom)
 	Q:AdmHospitalId'=HospID 0
 	s BookingDate=$p(^DHCDocIPBK(RowID),"^",10) 
 	Q:(FindBookDateF'="")&&(BookingDate<FindBookDateF) 0
	Q:(FindBookDateN'="")&&(BookingDate>FindBookDateN) 0
 	s IsActive=$p(^DHCDocIPBK(RowID),"^",9) ;有效(Y/N)
	Q:IsActive'="Y" 0
	s CurrentStateID=$p(^DHCDocIPBK(RowID),"^",8)
 	s:CurrentStateID'="" BStatu=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",2)
	s:CurrentStateID'="" BStatuCode=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",1)
	Q:("^Cancel^Admission^Void^")[("^"_BStatuCode_"^") 0 ;医生修改的时候只能修改预约 预住院 签床状态的住院证
	q 1
OutMesage(RowID,langid)
	s PatientID=$p(^DHCDocIPBK(RowID),"^",1)
	s EpisodeIDFrom=$p(^DHCDocIPBK(RowID),"^",2)
	s EpisodeIDTo=$p(^DHCDocIPBK(RowID),"^",3)
	s CreatDate=$p(^DHCDocIPBK(RowID),"^",4)
	s CreatTime=$p(^DHCDocIPBK(RowID),"^",5)
	s CreatUser=$p(^DHCDocIPBK(RowID),"^",6)
	s CreatDocID=$p(^DHCDocIPBK(RowID),"^",7)
	s CurrentStateID=$p(^DHCDocIPBK(RowID),"^",8) ;住院证状态
	s IsActive=$p(^DHCDocIPBK(RowID),"^",9) ;有效(Y/N)
	s BookingDate=$p(^DHCDocIPBK(RowID),"^",10) ;预约日期
	s WardId=$p(^DHCDocIPBK(RowID),"^",11) ;病区
	s BedId=$p(^DHCDocIPBK(RowID),"^",12) ;床位
	s DepId=$p(^DHCDocIPBK(RowID),"^",13) ;科室
	s ICDId=$p(^DHCDocIPBK(RowID),"^",14) ;ICD诊断-新版不用
	s ResumeText=$p(^DHCDocIPBK(RowID),"^",15) ;备注
	s MrcContion=$p(^DHCDocIPBK(RowID),"^",16) ;紧急条件-新版不用
	s IPDeposit=$p(^DHCDocIPBK(RowID),"^",17) ;押金
	s Text6=$p(^DHCDocIPBK(RowID),"^",18) ;
	s DiaNotes=$p(^DHCDocIPBK(RowID),"^",19) ;诊断备注
	s InReasn=$p(^DHCDocIPBK(RowID),"^",21) ;操作原因
	s InSource=$p(^DHCDocIPBK(RowID),"^",22) ;入院途径
	s InBedypeT=$p(^DHCDocIPBK(RowID),"^",23) ;床位类型
	s ICDList=$p(^DHCDocIPBK(RowID),"^",24) ;诊断ListICD!ICD
	s AdmInitState=$p($G(^DHCDocIPBK(RowID)),"^",28) ;入院病情
	s IPBookingNo=$p($G(^DHCDocIPBK(RowID)),"^",20) 
	s AdmInitStateDesc=""
	
	s:AdmInitState'="" AdmInitStateDesc=$p($G(^PAC("REFPRI",AdmInitState)),"^",2)
	Set AdmInitStateDesc= ##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc",AdmInitStateDesc,langid)
	s TreatedCode=""
	s Treated=""
	s:EpisodeIDTo'="" Treated=$P($G(^PAADM(EpisodeIDTo,"DHC")),"^",49)
	s:Treated'="" TreatedCode=$P($G(^DHCDocIPBDIC(Treated)),"^",1)
	if TreatedCode="DaySurg" s rjss="是"
	else  s rjss="否"
	s rjss=##class(websys.Translation).Get("doc.ipbookcreate.hui.csp",rjss)
	s ICDListStr=""
	if (ICDList'="") d
	.s LICDList=$L(ICDList,"!")
	.for i=1:1:LICDList  d
	..s ICDSub=$P(ICDList,"!",i)
	..s ICDRowid=$p(ICDSub,$c(2),1)
	..if ICDRowid'=""  d
	...s Desc=$p(^MRC("ID",ICDRowid),"^",2)
	...s Desc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",Desc,langid)
	..e  d
	...s Desc=$p(ICDSub,$c(2),2)
	
	...if ICDListStr="" s ICDListStr=Desc
	...else  s ICDListStr=ICDListStr_","_Desc
	
	;输出---
	s BName=$p($g(^PAPER(PatientID,"ALL")),"^",1) ;姓名
	s BBDate=""
	s:BookingDate'="" BBDate=..%ZD(BookingDate) //$ZD(BookingDate,3) 
	s BBCTloc=""
	s:DepId'="" BBCTloc=$P($g(^CTLOC(DepId)),"^",2)
	s BBCTloc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",BBCTloc,langid)
	i BBCTloc["-" s BBCTloc=$P(BBCTloc,"-",2) 
	s BStatu=""
	s BStatuCode=""
	s:CurrentStateID'="" BStatu=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",2)
	s:CurrentStateID'="" BStatuCode=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",1)
	s BStatu=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc",BStatu,langid)
	s BBWard=""
	s:WardId'="" BBWard=$p($g(^PAWARD(+WardId)),"^",2)
	s BBWard=##class(User.PACWard).GetTranByDesc("WARDDesc",BBWard,langid)
	s BBBed="" 
	s:(BedId'="")&&(+$P(BedId,"||",2)'=0) BBBed=$p($G(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	s BBCreaterUser=""
	s:CreatUser'="" BBCreaterUser=$p($G(^SSU("SSUSR",CreatUser)),"^",2)
	s BBCreaterUser =##class(User.SSUser).GetTranByDesc("SSUSRName",BBCreaterUser,langid)
	s BBCreaterDate=""
	s:CreatDate'="" BBCreaterDate=..%ZD(CreatDate) //$ZD(CreatDate,3)
	s BBookID=RowID
	s BPatID=PatientID
	s BAmdID=EpisodeIDFrom
	s NO=NO+1
	s BTimeLiness=##class(web.DHCBillInterface).IIsIPBook(RowID)
	s BTimeLiness=$case($p(BTimeLiness,"^",1),"IPBookErr":"不在有效时间内","Admission":"正在住院","OnceAdmission":"曾住院","NotActive":"已失效",:"")
	s BTimeLiness=##class(websys.Translation).Get("doc.ipbookcreate.hui.csp",BTimeLiness)
	Do OutputbookRow
	q
OutputbookRow
	set Data=$lb(NO,BName,BStatu,BBDate,BBCTloc,BBWard,BBBed,BBCreaterUser,BBCreaterDate,BBookID,BPatID,BAmdID,ICDListStr,IPBookingNo,AdmInitStateDesc,rjss,BTimeLiness)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBookListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBookListExecute ]
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
}

ClassMethod FindBookListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBookListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取所选就诊的所有ICD诊断
/// input BookID 住院证ID
/// OutPut :
/// 住院证ID 		-1
/// 患者ID			-2
/// 门诊就诊ID 		-3
/// 住院就诊ID		-4
/// 创建日期		-5
/// 创建时间		-6
/// 创建用户		-7
/// 创建医护人员	-8
/// 状态ID			-9
/// 有效标志		-10
/// 预约日期		-11
/// 病区ID			-12
/// 床位ID			-13
/// 科室ID			-14
/// 诊断ICDID		-15
/// 备注			-16
/// 紧急条件(ID)	-17
/// 预交金			-18
/// text6			-19
/// 诊断备注		-20
/// 入院病情ID		-21
/// 操作原因ID		-22
/// 入院途径ID		-23
/// 建议床位类型	-24
/// ICD列表			-25
/// 状态描述		-26 -21ID
/// 创建人描述		-27	-7ID
/// 创建医生描述	-28 -8ID
/// 病区描述		-29	-12ID
/// 床位描述		-30	-13ID
/// 科室描述		-31	-14ID
/// ICD描述			-32	-15ID
/// 入院病情描述	-33	-21ID
/// 操作原因描述	-34	-22ID
/// 入院途径描述	-35	-23ID
/// 建议床位描述	-36	-24ID
/// ICD列表描述和ID -37	(ICD诊断Rowid_$C(2)_诊断描述(已包括诊断前缀、备注与结构化诊断描述)_$C(2)_诊断状态ID
/// 						_$C(2)_诊断类型(中医/西医)_$C(2)_诊断备注_$C(2)_诊断前缀_$C(2)_结构化诊断信息
/// 						_$C(2)_证型串(证型ICDRowid_$C(3)_证型描述_$C(3)_证型备注_$C(3)_证型前缀_$C(1)_...))_"!"_...
/// 最后更新人		-38
/// 最后更新日期	-39
/// 最后更新时间	-40
/// 患者等级ID		-41
/// 医疗单元ID		-42
/// 主治医师ID		-43
/// 收治原则ID		-44
/// 住院证编号		-45
/// 患者等级描述    -46
/// 医疗单元描述	-47
/// 主治医师描述	-48
/// 收治原则描述	-49
/// 医院			-50
/// 医院			-51
/// 是否日			-52
/// 是否外院转来	-53
/// 住院证状态CODE  -54
/// 病区类型		-55 1 本科室 2 本科室关联 3 其他病区
/// 创建科室		-56
/// 创建科室描述	-57 
/// w ##class(web.DHCDocIPBookNew).GetBookMesage(70)
ClassMethod GetBookMesage(BookID) As %String
{
	n (BookID,%session)
	s PatientID=$p(^DHCDocIPBK(BookID),"^",1)
	s EpisodeIDFrom=$p(^DHCDocIPBK(BookID),"^",2)
	s PAAdmDate=""
	s:EpisodeIDFrom'="" PAAdmDate=$p($g(^PAADM(EpisodeIDFrom)),"^",6)
	s:PAAdmDate PAAdmDate=..%ZD(PAAdmDate)
	s EpisodeIDTo=$p(^DHCDocIPBK(BookID),"^",3)
	s CreatDate=$p(^DHCDocIPBK(BookID),"^",4)
	s CreatTime=$p(^DHCDocIPBK(BookID),"^",5)
	s CreatUser=$p(^DHCDocIPBK(BookID),"^",6)
	s CreatDocID=$p(^DHCDocIPBK(BookID),"^",7)
	s CurrentStateID=$p(^DHCDocIPBK(BookID),"^",8) ;住院证状态
	s IsActive=$p(^DHCDocIPBK(BookID),"^",9) ;有效(Y/N)
	s BookingDate=$p(^DHCDocIPBK(BookID),"^",10) ;预约日期
	s WardId=$p(^DHCDocIPBK(BookID),"^",11) ;病区
	s BedId=$p(^DHCDocIPBK(BookID),"^",12) ;床位
	s DepId=$p(^DHCDocIPBK(BookID),"^",13) ;科室
	s ICDId=$p(^DHCDocIPBK(BookID),"^",14) ;ICD诊断-新版不用
	s ResumeText=$p(^DHCDocIPBK(BookID),"^",15) ;备注
	s MrcContion=$p(^DHCDocIPBK(BookID),"^",16) ;紧急条件-新版不用
	s IPDeposit=$p(^DHCDocIPBK(BookID),"^",17) ;押金
	s Text6=$p(^DHCDocIPBK(BookID),"^",18) ;
	s DiaNotes=$p(^DHCDocIPBK(BookID),"^",19) ;诊断备注
	s IPBookingNo=$p(^DHCDocIPBK(BookID),"^",20) ;住院证编号
	s InReasn=$p(^DHCDocIPBK(BookID),"^",21) ;操作原因
	s InSource=$p(^DHCDocIPBK(BookID),"^",22) ;入院途径
	s InBedType=$p(^DHCDocIPBK(BookID),"^",23) ;床位类型
	s ICDList=$p(^DHCDocIPBK(BookID),"^",24) ;诊断ListICD!ICD..
	//s ICDList=..ReLoadBookDiagInfo(ICDList)
	s UpdateUser=$p(^DHCDocIPBK(BookID),"^",25) ;最后一次更新人
	s UpdateDate=$p(^DHCDocIPBK(BookID),"^",26) ;最后一次更新日期
	s UpdateTime=$p(^DHCDocIPBK(BookID),"^",27) ;最后一次更新时间
	s AdmInitState=$p(^DHCDocIPBK(BookID),"^",28) ;入院病情
	s PatitnLevel=$p(^DHCDocIPBK(BookID),"^",29) ;患者等级
	s CTLocMedUnit=$p(^DHCDocIPBK(BookID),"^",30) ;医疗单元
	s InDoctorDR=$p(^DHCDocIPBK(BookID),"^",31) ;主治医师
	s TreatedPrinciple=$p(^DHCDocIPBK(BookID),"^",32) ;收治原则
	s IsDayFlag=$p(^DHCDocIPBK(BookID),"^",33) ;是否日间
	s IsOutTriage=$p(^DHCDocIPBK(BookID),"^",34) ;是否外院转来
	s WardType=$p(^DHCDocIPBK(BookID),"^",35) ;1 本科室 2 本科室关联 3 其他病区
	s CreatLogLocDr=$p(^DHCDocIPBK(BookID),"^",36) ;创建科室
	s InHosTransport=$p(^DHCDocIPBK(BookID),"^",46) ;创建科室
	s ReAdmission=$p(^DHCDocIPBK(BookID),"^",47) ;再入院标志
	s InAdmReasonDr=$p(^DHCDocIPBK(BookID),"^",48) ;入院费别
	s InAdmReason=""
	s:InAdmReasonDr'="" InAdmReason=$p(^PAC("ADMREA",InAdmReasonDr),"^",2)
	;获取相关描述
	s (StateIDDesc,CreatUserDesc,CreatDocIDDesc,WardIdDesc,BedDesc,DepDesc,
	ICDDesc,AdmInitStateDesc,InReasnDesc,InSourceDesc,InBedTypeDesc,UpdateUserDesc,
	PatitnLevelDesc,CTLocMedUnitDesc,InDoctorDesc,TreatedPrincipleDesc,StateIDCode,CreatLogLoc,InHosTransportDesc)=""
	
	s:CreatLogLocDr'="" CreatLogLoc=$P($G(^CTLOC(CreatLogLocDr)),"^",2)	
	s:CurrentStateID'="" StateIDDesc=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",2)
	s:CurrentStateID'="" StateIDCode=$P($G(^DHCDocIPBDIC(CurrentStateID)),"^",1)
	s:BookingDate'="" BookingDate=..%ZD(BookingDate) //$ZD(BookingDate,3)
	s:CreatDate'="" CreatDate=..%ZD(CreatDate) //$ZD(CreatDate,3)
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s:CreatUser'="" CreatUserDesc=$p($G(^SSU("SSUSR",CreatUser)),"^",2)
	s:CreatDocID'="" CreatDocIDDesc=$p($G(^SSU("SSUSR",CreatDocID)),"^",2)
	s:WardId'="" WardIdDesc=$p($g(^PAWARD(+WardId)),"^",2)
	s:WardIdDesc["-" WardIdDesc=$P(WardIdDesc,"-",2)
	s:BedId'=""&&(+$P(BedId,"||",2)'=0) BedDesc=$p($G(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	s:DepId'="" DepDesc=$P($g(^CTLOC(DepId)),"^",2)
	s:DepDesc["-" DepDesc=$P(DepDesc,"-",2)
	s:ICDId'="" ICDDesc=$p(^MRC("ID",ICDId),"^",2)
	s:ICDDesc["-" ICDDesc=$P(ICDDesc,"^",2)
	s:AdmInitState'="" AdmInitStateDesc=$p($G(^PAC("REFPRI",AdmInitState)),"^",2)
	s:InReasn'="" InReasnDesc=$P($G(^DHCDocIPBDIC(InReasn)),"^",2)
	s:InSource'="" InSourceDesc=$P($G(^PAC("ADSOU",InSource)),"^",2)
	s:InBedType'="" InBedTypeDesc=$P($G(^DHCDocIPBDIC(InBedType)),"^",2)
	s:UpdateUser'="" UpdateUserDesc=$p($G(^SSU("SSUSR",UpdateUser)),"^",2)
	s:UpdateDate'="" UpdateDate=..%ZD(UpdateDate) //$ZD(UpdateDate,3)
	s:UpdateTime'="" UpdateTime=..%ZT(UpdateTime,2)
	s:PatitnLevel'="" PatitnLevelDesc=$P($G(^DHCDocIPBDIC(PatitnLevel)),"^",2)
	s:CTLocMedUnit'="" CTLocMedUnitDesc=$p($g(^CTLOC(+CTLocMedUnit,"MU",+$P(CTLocMedUnit,"||",2))),"^",2)
	s:InDoctorDR'="" InDoctorDesc=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
	s:TreatedPrinciple'="" TreatedPrincipleDesc=$P($G(^DHCDocIPBDIC(TreatedPrinciple)),"^",2)
	s:InHosTransport'="" InHosTransportDesc=$P($G(^DHCDocIPBDIC(InHosTransport)),"^",2)
	s ICDListStr=ICDList
	s HospDesc=""
	if (DepId'=""){
		//住院科室对照的医院
		s HospID=$P(^CTLOC(DepId),"^",22)
		s:HospID'="" HospDesc=$P($G(^CT("HOSP",HospID)),"^",2)
	}
	if (HospDesc=""){
		s HospID=$G(^DHCDocConfig("MainHospital"))
		s:HospID'="" HospDesc=$P($G(^CT("HOSP",HospID)),"^",2)
	}
	s CompanyNum=$p(^DHCDocIPBK(BookID),"^",43) ;陪伴人数
	s InAdmDate=$p(^DHCDocIPBK(BookID),"^",44) ;实际入院日期
	if (InAdmDate'="") s InAdmDate=..%ZD(InAdmDate)
	s InAdmTime=$p(^DHCDocIPBK(BookID),"^",45) ;实际入院时间
	if (InAdmTime'="") s InAdmTime=..%ZT(InAdmTime,1)
	//7
	s Str=BookID_"^"_PatientID_"^"_EpisodeIDFrom_"^"_EpisodeIDTo_"^"_CreatDate_"^"_CreatTime_"^"_CreatUser
	//7
	s Str=Str_"^"_CreatDocID_"^"_CurrentStateID_"^"_IsActive_"^"_BookingDate_"^"_WardId_"^"_BedId_"^"_DepId
	//7
	s Str=Str_"^"_ICDId_"^"_ResumeText_"^"_MrcContion_"^"_IPDeposit_"^"_Text6_"^"_DiaNotes_"^"_AdmInitState
	//7
	s Str=Str_"^"_InReasn_"^"_InSource_"^"_InBedType_"^"_ICDList_"^"_StateIDDesc_"^"_CreatUserDesc_"^"_CreatDocIDDesc
	//7
	s Str=Str_"^"_WardIdDesc_"^"_BedDesc_"^"_DepDesc_"^"_ICDDesc_"^"_AdmInitStateDesc_"^"_InReasnDesc_"^"_InSourceDesc
	s Str=Str_"^"_InBedTypeDesc_"^"_ICDListStr_"^"_UpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
	s Str=Str_"^"_PatitnLevel_"^"_CTLocMedUnit_"^"_InDoctorDR_"^"_TreatedPrinciple_"^"_IPBookingNo
	s Str=Str_"^"_PatitnLevelDesc_"^"_CTLocMedUnitDesc_"^"_InDoctorDesc_"^"_TreatedPrincipleDesc_"^"_HospDesc_"^"_PAAdmDate
	s Str=Str_"^"_IsDayFlag_"^"_IsOutTriage_"^"_StateIDCode_"^"_WardType_"^"_CreatLogLocDr_"^"_CreatLogLoc_"^"_CompanyNum_"^"_InAdmDate_"^"_InAdmTime
	s Str=Str_"^"_InHosTransport_"^"_InHosTransportDesc_"^"_ReAdmission_"^"_InAdmReasonDr_"^"_InAdmReason
	q Str
}

/// 查询就诊列表
/// 输入: 患者ID 开始日期 结束日期 
/// 输出：PatID AS %String,AdmDateF As %String,AdmDateN As %String
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPBookNew","FindAdmList","27","","")
Query FindAdmList(PatID As %String, AdmDateF As %String, AdmDateN As %String, LogonHospDr As %String = "") As %Query(ROWSPEC = "NO:%String,AdmDate:%String,AdmLoc:%String,AdmMark:%String,AdmDoc:%String,AdmDias:%String,AdmPatID：%String,AdmID:%String,AdmBook:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, PatID As %String, AdmDateF As %String, AdmDateN As %String, LogonHospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
 	i AdmDateF'="" s AdmDateF=..%ZDH(AdmDateF)
 	i AdmDateN'="" s AdmDateN=..%ZDH(AdmDateN)
 	s AdmTypeStr="O^E"
 	Set langid=..%LanguageID()
 	s NO=0
 	if PatID'=""  d
 	.;获取规定类型下的就诊
 	.s LType=$L(AdmTypeStr,"^")
 	.f i=1:1:LType  d
 	..s AdmTypeSub=$P(AdmTypeStr,"^",i)
 	..s AdmID=0 
 	..f  s AdmID=$O(^PAPERdr(PatID,"ADM",AdmTypeSub,AdmID)) Q:AdmID=""  d
 	...s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmID)
 	...Q:AdmHospitalId'=LogonHospDr
 	...s AdmDate=$p($g(^PAADM(AdmID)),"^",6)
 	...Q:(AdmDateF'="")&&(AdmDate<AdmDateF)
 	...Q:(AdmDateN'="")&&(AdmDate>AdmDateN)
 	...s AdmStatus=$P($g(^PAADM(AdmID)),"^",20)
 	...Q:AdmStatus="C"
 	...s LitAdm(AdmDate,AdmID)=0
 	.;按照日期倒序输出
 	.s DateSub=""
 	.f  s DateSub=$O(LitAdm(DateSub),"-1")  Q:DateSub=""  d
 	..s AdmID=""
 	..f  s AdmID=$O(LitAdm(DateSub,AdmID),"-1")  Q:AdmID=""  d
 	...s AdmDate=$p($g(^PAADM(AdmID)),"^",6)
 	...s Admi=AdmID
	...S RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	...Q:RegfeeRowId=""
	...s object=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	...s QueueNo=object.RegfeeNo
	...s (InvoiceId,DepID,MarkDr,TRRowId)=""
	...if $IsObject(object.Regfeetemp1) s InvoiceId=object.Regfeetemp1.%Id()
	...if $IsObject(object.RegfeeDepDr) s DepID=object.RegfeeDepDr.%Id()
	...if $IsObject(object.RegfeeDocDr) s MarkDr=object.RegfeeDocDr.%Id()
	...if $IsObject(object.RegfeeTimeRangeDr) s TRRowId=object.RegfeeTimeRangeDr.%Id()
 	...s:DepID'="" CTloc=$P(^CTLOC(DepID),"^",2)
 	...if CTloc'="" s CTloc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTloc,langid)
 	...s:$G(CTloc)["-" CTloc=$P(CTloc,"-",2)
 	...s:MarkDr'="" MarkDesc=$p($g(^CTPCP(MarkDr,1)),"^",2)
 	...if MarkDesc'="" Set MarkDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MarkDesc,langid)
 	...s AdmDoc=$P(^PAADM(AdmID),"^",9) ;设置到达的时候该位置会变为接诊医生 没有接诊为号别
 	...s:AdmDoc'="" AdmDocDesc=$p($g(^CTPCP(AdmDoc,1)),"^",2)
 	...if AdmDocDesc'= "" Set AdmDocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",$g(AdmDocDesc),langid)
 	...s DescStr=##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(AdmID)
 	...
 	...s AdmPatID=$P(^PAADM(AdmID),"^",1)
 	...s FindBook="N"
 	...s BookID=0
 	...f  s BookID=$O(^DHCDocIPBK(0,"EpisodeIDFrom",AdmID,BookID))  Q:(BookID="")||(FindBook="Y")  d
 	....s BookMes=..GetBookMesage(BookID)
 	....s Actuive=$P(BookMes,"^",10)
 	....Q:Actuive'="Y"
 	....s StateIDCode=$P(BookMes,"^",54)
 	....Q:StateIDCode="Cancel"
 	....s FindBook="Y"
 	...;输出数据
 	
 	...s:AdmDate'="" AdmDate=..%ZD(AdmDate) //$ZD(AdmDate,3)
 	...s AdmLoc=$G(CTloc)
 	...s AdmMark=$G(MarkDesc)
 	...s AdmDoc=$G(AdmDocDesc)
 	...s AdmDias=DescStr
 	...s AdmBook=$Case(FindBook,"N":"","Y":"Y","":"")
 	...Q:AdmBook="Y"
 	...s NO=NO+1
	...Do OutputRowAdmList
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAdmList
	set Data=$lb(NO,AdmDate,AdmLoc,AdmMark,AdmDoc,AdmDias,AdmPatID,AdmID,AdmBook)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmListExecute ]
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
}

ClassMethod FindAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// desc	保存住院证
/// input 保存住院证信息
/// output	-1 保存失败 住院证ID
/// w ##class(web.DHCDocIPBookNew).SaveBookMeth(^lxz1234)
ClassMethod SaveBookMeth(Instring) As %String
{
	n (Instring,%session)
	s ^lxz("SaveBookMeth")=Instring
	set Rtn="-1"
	set RowID = +$p(Instring, "^",1)
	if RowID=0 {
		s Rtn=..InsertBook(Instring)
	}else{
		Q:'$D(^DHCDocIPBK(RowID)) Rtn
		s Rtn=..UpdateBook(Instring)
	}
	q Rtn
}

/// 新建住院证
ClassMethod InsertBook(Instring) As %String
{
	
	n (Instring,%session)
	set RowID = $p(Instring, "^",1)
	Q:RowID'="" "-1"
	//自动生成住院证单号
    s IPBookingNo=$I(^IPBKC("IPBookingNO",+$h))
    s IPBookingNo=$tr($ZD(+$h,3),"-","")_$E("00000",1,4-$L(IPBookingNo))_IPBookingNo
    
	set PLIST(2)=$p(Instring,"^",2)         ;PatientID       
    set PLIST(3)=$p(Instring,"^",3)         ;门诊就诊PAADM  指向PA_ADM
    set PLIST(4)=$p(Instring,"^",4)         ;住院就诊PAADM  指向PA_ADM
    set CreateDate = $p(Instring,"^",5)
    set:CreateDate="" CreateDate=..%SysDate()
    i CreateDate'="" s CreateDate=..%ZDH(CreateDate)
    //set:(CreateDate'="")&(CreateDate["-") CreateDate=$zdh(CreateDate,3)
    //set:(CreateDate'="")&(CreateDate["/") CreateDate=$zdh(CreateDate,4)
    set PLIST(5)=CreateDate         		;建住院证日期
    set CreateTime = $p(Instring,"^",6)
    set:CreateTime="" CreateTime=..%SysTime()
    set:(CreateTime'="")&(CreateTime[":") CreateTime=..%ZTH(CreateTime,2)
    set PLIST(6)=CreateTime         		;建住院证时间
    set PLIST(7)=$p(Instring,"^",7)         ;建住院证操作员ID 指向SS_User
    set PLIST(8)=$p(Instring,"^",8)         ;建住院证医师ID 指向SS_User
    set PLIST(9)=$p(Instring,"^",9)         ;当前状态ID 指向DHC_MedDictory
    set PLIST(10)=$p(Instring,"^",10)       ;有效状态 Yes/No
    set BookDate = $p(Instring,"^",11)
    //set:(BookDate'="")&(BookDate["-") BookDate=$zdh(BookDate,3)
    //set:(BookDate'="")&(BookDate["/") BookDate=$zdh(BookDate,4)
    i BookDate'="" s BookDate=..%ZDH(BookDate)
    set PLIST(11)=BookDate         			;预约日期    	
    set PLIST(12)=$p(Instring,"^",12)       ;Text1    病区ID	
    set PLIST(13)=$p(Instring,"^",13)       ;Text2    床位ID	
    set PLIST(14)=$p(Instring,"^",14)       ;Text3    科室ID
    set PLIST(15)=$p(Instring,"^",15)       ;Text4	  诊断ID
    set PLIST(16)=$p(Instring,"^",16)       ;备注 
    Set PLIST(17)=$p(Instring,"^",19)		;入院病情 -紧急条件
    Set PLIST(18)=$p(Instring,"^",18)       ;IPDeposit 住院押金
    
    ;新版住院证新增
    set PLIST(21)=IPBookingNo
    set PLIST(22)=$p(Instring,"^",21)		;InReason	操作原因
    set PLIST(23)=$p(Instring,"^",22)		;InSorce 入院途径
    set PLIST(24)=$p(Instring,"^",23)		;InBedType 建议床位
    set PLIST(25)=$p(Instring,"^",24)		;诊断List
    set PLIST(26)=$p(Instring,"^",7)		;最后更新人
    set PLIST(27)=..%SysDate()						;最后更新日期
    set PLIST(28)=..%SysTime()				;最后更新时间
    set PLIST(29)=$p(Instring,"^",20) 		;AdmInitState 入院病情-新
    
    
    set PLIST(30)=$p(Instring,"^",27)      ;患者等级
    set PLIST(31)=$p(Instring,"^",25)      ;医疗单元
    set PLIST(32)=$p(Instring,"^",26)      ;主治医师
    set PLIST(33)=$p(Instring,"^",28)      ;收治原则
    set PLIST(34)=$p(Instring,"^",29)      ;是否日间
    set PLIST(35)=$p(Instring,"^",30)      ;是否外院转来
    set PLIST(36)=$p(Instring,"^",31)      ;病区类型
    set PLIST(37)=$p(Instring,"^",32)      ;登录科室ID
    set PLIST(44)=$p(Instring,"^",33)      ;陪伴人数
    set PLIST(45)=..%ZDH($p(Instring,"^",34))      ;实际入院日期
    s InAdmTime=$p(Instring,"^",35) 
    set PLIST(47)=$p(Instring,"^",36) 
    if (InAdmTime'="") s InAdmTime=..%ZTH(InAdmTime)
    set PLIST(46)=InAdmTime      ;实际入院时间
    set PLIST(48)=$p(Instring,"^",37) 
    set PLIST(49)=$p(Instring,"^",38) 		;入院费别
    TS
    &sql(Insert into SQLUSER.DHCDocIPBooking values :PLIST())
    s RowID =$p(%ROWID,$c(1))
    S Rtn=SQLCODE
    ;如果是外部传入的住院就诊ID以传入的为准
    i ((Rtn=0)&&(+$p(Instring,"^",4))=0) {
    	;如果是预住院,需要插入预住院的就诊记录
    	s CurrentStateCode=""
    	s CurrentStateID=$p(Instring,"^",9)
    	i CurrentStateID'="" s CurrentStateCode=$p(^DHCDocIPBDIC(CurrentStateID),"^",1)
    	i CurrentStateCode="PreInPatient" s Rtn=..UpdatePreInPatient(RowID)
    }
    b ;1
    i Rtn=0 {
	    TC
	    quit RowID
    }else{
	    TRO
	    quit "-1"
    }
}

/// 更新住院证
/// OperType:Cancel 表示是在住院证-住院证列表直接撤销住院证记录
/// w ##class(web.DHCDocIPBookNew).UpdateBook(^lxz("UpdateBook"))
ClassMethod UpdateBook(Instring) As %String
{
	s ^lxz("UpdateBook")=Instring
	n (Instring,OperType,%session)
	k PLIST
	set RowID = $p(Instring, "^",1)
	Q:RowID="" "-1"
	s CurrentStateCode=""
    s CurrentStateID=$p(Instring,"^",9)
    i CurrentStateID'="" s CurrentStateCode=$p(^DHCDocIPBDIC(CurrentStateID),"^",1)
	s EpisodeIDTo=$p(^DHCDocIPBK(RowID),"^",3)
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocIPBooking"_$c(2)_RowID_"^"_"User.DHCDocIPBooking"_$c(2)_RowID)
	s INAdmDr=$p(Instring,"^",4) ;住院ID
    set PLIST(9)=CurrentStateID //$p(Instring,"^",9)         ;当前状态ID 指向DHC_MedDictory
    set PLIST(10)=$p(Instring,"^",10)       ;有效状态 Yes/No
    set BookDate = $p(Instring,"^",11)
    set:BookDate="" BookDate=0    //$p($h,",",1)
    i BookDate'="" s BookDate=..%ZDH(BookDate)
    //set:(BookDate'="")&(BookDate["-") BookDate=$zdh(BookDate,3)
    //set:(BookDate'="")&(BookDate["/") BookDate=$zdh(BookDate,4)
    set PLIST(11)=BookDate         			;预约日期    	
    set PLIST(12)=$p(Instring,"^",12)       ;Text1    病区ID	
    set PLIST(13)=$p(Instring,"^",13)       ;Text2    床位ID	
    set PLIST(14)=$p(Instring,"^",14)       ;Text3    科室ID
    set PLIST(15)=$p(Instring,"^",15)       ;Text4	  诊断ID
    set PLIST(16)=$p(Instring,"^",16)       ;备注 
    Set PLIST(18)=$p(Instring,"^",18)       ;IPDeposit 住院押金
    Set PLIST(17)=$p(Instring,"^",19)		;入院病情 -紧急条件
    ;新版住院证新增
    
    set PLIST(22)=$p(Instring,"^",21)		;InReason	操作原因
    set PLIST(23)=$p(Instring,"^",22)		;InSorce 入院途径
    set PLIST(24)=$p(Instring,"^",23)		;InBedType 建议床位
    set PLIST(25)=$p(Instring,"^",24)		;诊断List
    set PLIST(26)=$p(Instring,"^",7)		;最后更新人
    set PLIST(27)=..%SysDate()						;最后更新日期
    set PLIST(28)=..%SysTime()				;最后更新时间
    set PLIST(29)=$p(Instring,"^",20) 		;AdmInitState 入院病情-新
    
    set PLIST(30)=$p(Instring,"^",27)      ;患者等级
    set PLIST(31)=$p(Instring,"^",25)      ;医疗单元
    set PLIST(32)=$p(Instring,"^",26)      ;主治医师
    set PLIST(33)=$p(Instring,"^",28)      ;收治原则
    set PLIST(34)=$p(Instring,"^",29)      ;是否日间
    set PLIST(35)=$p(Instring,"^",30)      ;是否外院转来
    set PLIST(36)=$p(Instring,"^",31)      ;病区类型
    
    s LogOnLoc=$p(Instring,"^",32)
    set PLIST(44)=$p(Instring,"^",33)      ;陪伴人数
    set PLIST(45)=..%ZDH($p(Instring,"^",34))      ;实际入院日期
    s InAdmTime=$p(Instring,"^",35) 
    if (InAdmTime'="") s InAdmTime=..%ZTH(InAdmTime)
    set PLIST(46)=InAdmTime      ;实际入院时间
    set PLIST(47)=$p(Instring,"^",36) 
    set PLIST(48)=$p(Instring,"^",37) 
    set PLIST(49)=$p(Instring,"^",38) 		;入院费别
    s LogUser=$p(Instring,"^",7)
    s:(+INAdmDr'=0)&&(CurrentStateCode="PreInPatient") PLIST(4)=INAdmDr,EpisodeIDTo=INAdmDr ;如果传入住院ID关联以传入为准
    TS
   
    &sql(Update SQLUSER.DHCDocIPBooking values :PLIST() where Rowid=:RowID)
    S Rtn=SQLCODE
    ;如果是预住院,需要插入预住院的就诊记录-如果住院证上已经存在住院ID在修改住院证时候也不去除.在办理住院的时候处理
    //&&(+EpisodeIDTo=0)&&(+INAdmDr=0)
    i (Rtn=0){
    	i CurrentStateCode="PreInPatient" s Rtn=..UpdatePreInPatient(RowID)
    }
    
    ;撤销住院证同时撤销就诊相关信息(预入院)
    i ((Rtn=0)&(+EpisodeIDTo'=0)&(CurrentStateCode="Cancel")){
	    s Rtn=..CancelPatAdm(+EpisodeIDTo,LogUser)
	    if (Rtn=0) {
		    //修改住院证调用护理组接口，取消预约床位
		    s Rtn=##Class(Nur.InService.Interface).cancelPatAppBed(RowID,LogUser)
	    }
    }
    
   ///修改住院证调用护理组接口，护理组确定是否需要撤销登记信息
   s rtnNur=##Class(Nur.InService.Interface).cancelPatRegister(RowID,LogUser)
   if (rtnNur'=0){
		tro
		q "-1"
   }
   set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCDocIPBooking"_$c(2)_RowID_"^"_"User.DHCDocIPBooking"_$c(2)_RowID)
   set ret=##class(web.DHCDocDataChangeLog).SaveLog("DHCDocIPBooking","User.DHCDocIPBooking","住院证","User.DHCDocIPBooking_"_RowID,"住院证ID","U",NewDataJson,OldDataJson)  

    i Rtn=0 {
	    TC
	    quit RowID
    }else{
	    TRO
	    quit "-1"
    }
}

/// 预住院先生成就诊ID
/// Input	住院证ID
/// output	0 成功 其他失败
ClassMethod UpdatePreInPatient(RowID As %String) As %String
{
	n (RowID,%session)
	s myrtn=0
	s AdmDate=$p(^DHCDocIPBK(RowID),"^",44) ;实际入院日期
	s AdmTime=$p(^DHCDocIPBK(RowID),"^",45) ;实际入院时间
	if (AdmDate="") {
		s AdmDate=..%SysDate(),AdmTime=..%SysTime()
	}
	s AdmType="I"
	;预住院状态
	q:$d(^DHCDocIPBK(RowID))=0 ""
	s VisitusStatus="P"
	s PatientID=$p(^DHCDocIPBK(RowID),"^",1)
	s EpisodeIDFrom=$p(^DHCDocIPBK(RowID),"^",2)
	s EpisodeIDTo=$p(^DHCDocIPBK(RowID),"^",3)
	s CreateUser=$p(^DHCDocIPBK(RowID),"^",6)
	s CurrentStateID=$p(^DHCDocIPBK(RowID),"^",8)
	s WardId=$p(^DHCDocIPBK(RowID),"^",11)
	s BedId=$p(^DHCDocIPBK(RowID),"^",12)
	s DepId=$p(^DHCDocIPBK(RowID),"^",13)
	s DiagnosICDId=$p(^DHCDocIPBK(RowID),"^",14)
	s TreatedPrinciple=$p(^DHCDocIPBK(RowID),"^",32) ;收治原则
	s UpdateUser=$p(^DHCDocIPBK(RowID),"^",25) //最后更新人
	s TreatedPrincipleCode=""
	s:TreatedPrinciple'="" TreatedPrincipleCode=$P($G(^DHCDocIPBDIC(TreatedPrinciple)),"^",1)
	
	s CurrentStateCode=""
	s:CurrentStateID'="" CurrentStateCode=$p(^DHCDocIPBDIC(CurrentStateID),"^",1)
	
	i EpisodeIDTo'="" {
		ts
		s EpisodeIDToVisitusStatus=$P(^PAADM(EpisodeIDTo),"^",20)
		i EpisodeIDToVisitusStatus=VisitusStatus {
			s myrtn=0
			&SQL(update SQLUser.PA_ADM  set PAADM_DepCode_DR=:DepId,PAADM_CurrentWard_DR=:WardId where PAADM_RowID=:EpisodeIDTo)
			s myrtn=SQLCODE
			if (myrtn=0){
				;更新收治原则 日间手术标识
				s TreatedOld=$P($G(^PAADM(EpisodeIDTo,"DHC")),"^",49)
				s TreatedOldCode=""
				s:TreatedOld'="" TreatedOldCode=$P($G(^DHCDocIPBDIC(TreatedOld)),"^",1)
				&SQL(Update SQLUser.PA_AdmExt  set PAADM_IPBTreatedPrinciple_DR=:TreatedPrinciple,PAADM_PreInPatient="Y" where PAADM_RowId=:EpisodeIDTo)
				s myrtn=SQLCODE
				if ((TreatedOldCode="DaySurg")&&(myrtn=0)&&(TreatedOld'=TreatedPrinciple)){
					;撤销就诊上得日间手术标识同时撤销日间手术记录
					s opertionstr=##class(web.DHCANAdaptor).CheckValidDayOper(EpisodeIDTo)
					s opertionflag=$P(opertionstr,"^",1)
					if ((opertionflag="Y")&(myrtn=0)){
						s rtn=##class(web.DHCANAdaptor).CancelDayOper(EpisodeIDTo,UpdateUser)
						if (rtn=1){s myrtn=0}else{s myrtn="-1"}
					}
				}
			}
			
		}
		if myrtn'=0 {
			tro
			q myrtn	
		}else{
			tc	
		}
	
	}else{
		;插入预住院的急诊记录
		s AdmReasonId=""
		s AdmRoom=""
		s AdmDoc=""
		s AdmBed=""
		s Epissubtype=""
		s AdmCate=""
		s AdmRefDocListDR=""
		s AdmDiagnosCatRowId=""
		s AdmInPatNo=""
		s AdmSrcDr=""
		s FirstOrReadmis=""
		s InsuCoRowid=""
		s RegConDisId=""
		s Para=PatientID_"^"_AdmType_"^"_AdmDate_"^"_AdmTime_"^"_DepId_"^"_AdmDoc_"^"_AdmReasonId_"^"_CreateUser_"^"_WardId
		s Para=Para_"^"_AdmRoom_"^"_AdmBed_"^"_Epissubtype_"^"_AdmCate_"^"_AdmRefDocListDR_"^"_AdmDiagnosCatRowId_"^"_""_"^"_AdmInPatNo
		s Para=Para_"^"_AdmSrcDr_"^"_FirstOrReadmis_"^"_InsuCoRowid_"^"_RegConDisId
	
		s IPEpisodeID=##class(web.DHCPAADM).ADMInsert(Para)
		i IPEpisodeID'="" {
			;更新PAADMVisitStatus字段为预住院
			&SQL(Update SQLUser.PA_Adm set PAADM_VisitStatus=:VisitusStatus where PAADM_RowId=:IPEpisodeID)
			s myrtn=SQLCODE
			
			;更新住院证记录的住院就诊ID
			i myrtn=0 {
				&SQL(Update SQLUser.DHCDocIPBooking  set EpisodeIDTo=:IPEpisodeID where RowID=:RowID)
				s myrtn=SQLCODE
			}
			
			;更新收治原则 日间手术标识
			&SQL(Update SQLUser.PA_AdmExt  set PAADM_IPBTreatedPrinciple_DR=:TreatedPrinciple,PAADM_PreInPatient="Y" where PAADM_RowId=:IPEpisodeID)
			s myrtn=SQLCODE
			
				
			s rtn=..InserDiagenose(RowID)
			// 插入长效诊断
			s rtn=##class(DHCDoc.Interface.Inside.Service).InsertPALongICD(IPEpisodeID,UpdateUser)
		}
	}
	
	
	q myrtn
}

/// 填写院前医嘱返回的URL
ClassMethod GetOrderLink(BookID As %String) As %String
{
	s URL=""
	s PatientID=$p(^DHCDocIPBK(BookID),"^",1)
	s EpisodeIDTo=$p(^DHCDocIPBK(BookID),"^",3)
	q:EpisodeIDTo="" ""
	s VisistStatus=$p(^PAADM(EpisodeIDTo),"^",20)
	q:VisistStatus'="P" ""
	s MRAdm=$p(^PAADM(EpisodeIDTo),"^",61)
	s CTLocID=%session.Get("LOGON.CTLOCID")
	;修改为新版住院医嘱录入菜单
	s URL="oeorder.ipbook.csp?&PatientID="_PatientID_"&EpisodeID="_EpisodeIDTo_"&mradm="_MRAdm_"&FixedEpisodeID="_EpisodeIDTo
	;s URL="oeorder.entrysinglelogon.csp?PatientID="_PatientID_"&EpisodeID="_EpisodeIDTo_"&mradm="_MRAdm_"&CTLOC="_CTLocID
	q URL
}

ClassMethod judgePatDepAmt(ADM)
{
	s depAmt=0
	q:ADM="" depAmt
	s sfRowid=""
	f  s sfRowid=$o(^DHCSFPRINTDETAIL(0,"adm",ADM,sfRowid)) q:sfRowid=""  d
	.s status=$p(^DHCSFPRINTDETAIL(sfRowid),"^",8)
	.q:status="2"
	.s dAmt=$p(^DHCSFPRINTDETAIL(sfRowid),"^",6)
	.s depAmt=depAmt+dAmt
	q depAmt
}

/// 保存之前进行监测是否可以保存住院证
/// 
/// w ##class(web.DHCDocIPBookNew).CheckBeforeSave(267,"",1)
ClassMethod CheckBeforeSave(AdmID As %String, BookID As %String, Type As %String, Instring As %String = "", CanDoStatu As %String = "") As %String
{
	s ^tempqujian("CheckBeforeSave")=$lb(AdmID,BookID,Type,Instring,CanDoStatu)
	s HospID=$P(##class(web.DHCOPAdmReg).GetCurrentHosp(AdmID,"","",""),"^",1)
	;验证--允许同一科室有效住院证重复
	s AllowOtherLocBook=..GetIPBookHospConfig("AllowOtherLocBook",HospID)
	;验证--允许跨科室有效住院证重复
	s AllowSameLocBook=..GetIPBookHospConfig("AllowSameLocBook",HospID)
	Set langid=..%LanguageID()
	if Type=1{
		//保存前对就诊进行检测--检测就诊是否可用
		if (AdmID'=""){
			Q:'$D(^PAADM(AdmID)) "-1^无效的就诊记录."
			s VisistStatus=$p(^PAADM(AdmID),"^",20)
			s StayStatusFlag=0
			s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(AdmID)
			if (" 1 "[(" "_StayStatus_" ")) s StayStatusFlag=1
			;急诊留观病人即使非A的就诊状态,也允许开住院证
			if (StayStatusFlag=0)&&(VisistStatus'="A"){
				return "-1^就诊已经无效,请更换就诊记录录入住院!"
			}
			s AdmType=$p(^PAADM(AdmID),"^",2)
			if ((AdmType="I"))
			{
				return "-1^就诊类型为[住院]不能用来办理住院!"
			}
			s FinAdmIn="N"
			s PatID=$p(^PAADM(AdmID),"^",1)
			s Sub1=0 
			f  s Sub1=$O(^PAPERdr(PatID,"ADM","I",Sub1)) Q:((Sub1="")||(FinAdmIn="Y"))  d
			.q:Sub1=""
			.s AdmDate=$p($g(^PAADM(Sub1)),"^",6)
			.s AdmStatus=$P($g(^PAADM(Sub1)),"^",20)
			.Q:AdmStatus'="A"
			.s FinAdmIn="Y"
			q:FinAdmIn="Y" "-1^患者已经是在院状态不能再开住院证!"
			
			;验证--同一次就诊不允许多个有效住院证
			s FindBook="N"
			s PreBookInfo=""
			s ActiveInfoStr=..CheckActiveBookInfo(AdmID,BookID,"TheAdm")
			s FindBook=$p(ActiveInfoStr,$c(2),1)
			s PreBookInfo=$p(ActiveInfoStr,$c(2),2)
			; renyx 增加验证住院证是否在效期内  不在效期内不进行提示
			s BTimeLiness=##class(web.DHCBillInterface).IIsIPBook(BookID)
			Q:(FindBook="Y")&&($p(BTimeLiness,"^",1)'="IPBookErr") "-1^"_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","该次就诊已经存在有效的住院证!")_"^"_PreBookInfo
			 
			;验证--允许同一科室有效住院证重复
			if (AllowSameLocBook=0){
				s ActiveInfoStr=..CheckActiveBookInfo(AdmID,BookID,"SameLoc")
				s FindBook=$p(ActiveInfoStr,$c(2),1)
				s PreBookInfo=$p(ActiveInfoStr,$c(2),2)
			}
			Q:(FindBook="Y")&&($p(BTimeLiness,"^",1)'="IPBookErr") "-1^"_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","不允许同一门诊科室有重复有效住院证!")_"^"_PreBookInfo
	 		
	 		;验证--允许同一科室有效住院证重复
			if (AllowOtherLocBook=0){
				s ActiveInfoStr=..CheckActiveBookInfo(AdmID,BookID,"OtherLoc")
				s FindBook=$p(ActiveInfoStr,$c(2),1)
				s PreBookInfo=$p(ActiveInfoStr,$c(2),2)
			}
			Q:(FindBook="Y")&&($p(BTimeLiness,"^",1)'="IPBookErr") "-1^"_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","不允许有跨科重复有效住院证!")_"^"_PreBookInfo
		}
	}
	elseif (Type=2) {
		///对要保存的住院证信息进行验证
	 	if (Instring'=""){
			s BookID=$p(Instring,"^",1)
			s PatID=$p(Instring,"^",2)
			s PAAdmOP=$p(Instring,"^",3)
			s PAAdmIP=$p(Instring,"^",4)
			s CreateDate=$p(Instring,"^",5)
			s CreateTime=$p(Instring,"^",6)
			s CreaterUser=$p(Instring,"^",7)
			s CreaterDocIDUser=$p(Instring,"^",8)
			s InCurStatu=$p(Instring,"^",9)
			s BookActive=$p(Instring,"^",10)
			s BookDate=$p(Instring,"^",11)
			//set:(BookDate'="")&(BookDate["-") BookDate=$zdh(BookDate,3)
    		//set:(BookDate'="")&(BookDate["/") BookDate=$zdh(BookDate,4)
    		i BookDate'="" s BookDate=..%ZDH(BookDate)
			s InWard=$p(Instring,"^",12)
			s InBed=$p(Instring,"^",13)
			s InCtloc=$p(Instring,"^",14)
			s ICDCode=$p(Instring,"^",15)
			s InResumeText=$p(Instring,"^",16)
			s IPDeposit=$p(Instring,"^",18)
			s MRCCondtion=$p(Instring,"^",19)
			s AdmInitState=$p(Instring,"^",20)
			s InReason=$p(Instring,"^",21)
			s InSorce=$p(Instring,"^",22)
			s InBedType=$p(Instring,"^",23)
			s ICDList=$p(Instring,"^",24)
			s CTLocMedUnit=$p(Instring,"^",25)
			s InDoctor=$p(Instring,"^",26)
			s PatientLevel=$p(Instring,"^",27)
			s TreatedPrinciple=$p(Instring,"^",28)
			s IsDayFlag=$p(Instring,"^",29)
			s IsOutTriage=$p(Instring,"^",30)
			s InAdmDate=$p(Instring,"^",34)
			s InAdmTime=$p(Instring,"^",35)
			s ReAdmission=$p(Instring,"^",37)
			s NewTreatedCode=""
			s:TreatedPrinciple'="" NewTreatedCode=$P($G(^DHCDocIPBDIC(TreatedPrinciple)),"^",1)
			s EpisodeIDTo=""
			s StatuCode=$P($G(^DHCDocIPBDIC(InCurStatu)),"^",1)
			;1、验证实际入院时间不能早于就诊时间 2、若患者存在出生时间，则不能早于出生时间；否则不能早于当前时间24小时
			;3、若已存在预住院记录,验证预住院记录是否存在有效的医嘱并验证开医嘱时间和实际入院时间
            ;4 不可撤销其他科室开的住院证 zhouc
            if (..CheckCanCancel(BookID,$p(Instring,"^",32))'="0"){
                s ErrMsg="不可撤销或修改非本科室开出的住院证!"
				Q "-1^"_ErrMsg
            }

			if (InAdmDate'="")&&(StatuCode'="Cancel") {
				s CheckMessage=##Class(web.DHCDocOrderCommon).CheckOrderDate(PAAdmOP,InAdmDate_" "_InAdmTime)
				if (CheckMessage'=""){
					s PAADMDate=$p($g(^PAADM(PAAdmOP)),"^",6)
					s PAADMTime=$p($g(^PAADM(PAAdmOP)),"^",7)
					s ErrMsg=..%Translate("doc.ipbookcreate.hui.csp","实际入院时间不能早于就诊时间:",langid)_..%ZD(PAADMDate)_" "_..%ZT(PAADMTime,1)
					Q "-1^"_ErrMsg
				}
				s InAdmDate=..%ZDH(InAdmDate)
				s InAdmTime=..%ZTH(InAdmTime)
				if (InAdmDate>+$h)||((InAdmDate=..%SysDate())&&(InAdmTime>..%SysTime())) {
					s ErrMsg="实际入院时间不能晚于当前时间！"
					Q "-1^"_ErrMsg
				}
				s birthDate=##class(web.UDHCJFCOMMON).GetPatBirthDate(PatID)
				s birthTime=##class(web.UDHCJFCOMMON).GetPatBirthTime(PatID)
				if (birthTime'="") {
					if ((InAdmDate=birthDate)&&(InAdmTime<birthTime))||(InAdmDate<birthDate) {
						s ErrMsg=..%Translate("doc.ipbookcreate.hui.csp","实际入院时间不能早于出生时间:",langid)_..%ZD(birthDate)_" "_..%ZT(birthTime,1)
						Q "-1^"_ErrMsg
					}
				}else{
					if (BookID="") {
						s ret=##class(web.DHCOEOrdItem).IsOrdSttExceed($ZD(InAdmDate,4)_" "_..%ZT(InAdmTime),24)
						if (ret=1) {
							s ErrMsg="实际入院时间不能早于当前时间24小时！"
				        	Q "-1^"_ErrMsg
			        	}
		        	}else{
			        	s BookCreateDate=$p(^DHCDocIPBK(BookID),"^",4)
			        	s BookCreateTime=$p(^DHCDocIPBK(BookID),"^",5)
			        	s DifferTime=(BookCreateDate-InAdmDate-1)*24+((BookCreateTime+86400-InAdmTime)/3600)
    					if (DifferTime>24) {
							s ErrMsg=..%Translate("doc.ipbookcreate.hui.csp","实际入院时间不能早于住院证开立时间",langid)_"("_..%ZD(BookCreateDate)_" "_..%ZT(BookCreateTime,1)_")"_..%Translate("doc.ipbookcreate.hui.csp","前24小时！",langid)
				        	Q "-1^"_ErrMsg
			        	}
			        }
				}
				if (PAAdmIP'="") {
					s ErrMsg="",minOEORIDate=0,minOEORITime=0
					s PAAdmIPAdmDate=$p($g(^PAADM(PAAdmIP)),"^",6)
					s OEORDRowId=$o(^OEORD(0,"Adm",PAAdmIP,""))
					if (OEORDRowId'="") {
						for OEORIDate=PAAdmIPAdmDate:1:InAdmDate{
							s OEORIChildsub=0
							for {
								s OEORIChildsub=$o(^OEORDi(0,"ItemDate",OEORIDate,OEORDRowId,OEORIChildsub)) Q:OEORIChildsub=""
								s Stat=$P($G(^OEORD(+OEORDRowId,"I",OEORIChildsub,1)),"^",13)
								s:Stat'="" statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
								continue:(statcode'="V")&&(statcode'="E")
								s OEORITimeOrd=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",17)
								if ((InAdmDate=OEORIDate)&&(InAdmTime<OEORITimeOrd))||(InAdmDate<OEORIDate) {
									s ErrMsg="-1^实际入院时间"
								}
								if (OEORIDate<minOEORIDate)||(minOEORIDate=0) s minOEORIDate=OEORIDate
								if (InAdmTime<minOEORITime)||(minOEORITime=0) s minOEORITime=OEORITimeOrd
							}
							
						}
						Q:ErrMsg'="" ErrMsg_..%Translate("doc.ipbookcreate.hui.csp","不能早于预住院医嘱最早医嘱时间",langid)_"："_..%ZD(minOEORIDate)_" "_..%ZT(minOEORITime,1)
					}
				}
			}
			if ((InWard'="")||(InCtloc'="")){
				s PatientID=$p(^PAADM(AdmID),"^",1)
				s LimitSexMsg=""
				s LimitAgeMsg=""
				if (InCtloc'=""){
					s RegDeptAgeSexFlag=##class(web.DHCOPAdmReg).CheckRegDeptAgeSex("",PatientID,InCtloc)
					s LimitFlag=$P(RegDeptAgeSexFlag,$C(2),1)
					if (LimitFlag'=0){
						s LimitSex=$P(RegDeptAgeSexFlag,$C(2),2)
						s LimitAge=$P(RegDeptAgeSexFlag,$C(2),3)
						//"此科室支持性别【"+AllowSexDesc+"】"
						s:LimitAge'="" LimitAgeMsg=..%Translate("doc.ipbookcreate.hui.csp","此科室支持年龄段",langid)_"【"_LimitAge_"】"
						s:LimitSex'="" LimitSexMsg=..%Translate("doc.ipbookcreate.hui.csp","此科室支持性别",langid)_"【"_LimitSex_"】"
					}
				}
				if (InWard'=""){
					s InWardLoc=$p(^PAWARD(InWard),"^",5)
					s RegDeptAgeSexFlag=##class(web.DHCOPAdmReg).CheckRegDeptAgeSex("",PatientID,InWardLoc)
					s LimitFlag=$P(RegDeptAgeSexFlag,$C(2),1)
					if (LimitFlag'=0){
						s LimitSex=$P(RegDeptAgeSexFlag,$C(2),2)
						s LimitAge=$P(RegDeptAgeSexFlag,$C(2),3)
						//"此科室支持性别【"+AllowSexDesc+"】"
						s:LimitAge'="" LimitAgeMsg=..%Translate("doc.ipbookcreate.hui.csp","此科室支持年龄段",langid)_"此科室支持年龄段【"_LimitAge_"】"
						s:LimitSex'="" LimitSexMsg=..%Translate("doc.ipbookcreate.hui.csp","此科室支持性别",langid)_"此科室支持性别【"_LimitSex_"】"
					}
				}
				s ^Tempqujian("LimitSexMsg")=LimitSexMsg
				q:LimitSexMsg'="" "-1^"_LimitSexMsg
				q:LimitAgeMsg'="" "-1^"_LimitAgeMsg
			}
			if (BookID'=""){
		 		s BookStr=..GetBookMesage(BookID)
		 		s BooStatu=$P(BookStr,"^",26)
		 		s BookStatuCode=$P(BookStr,"^",54)
		 		s EpisodeIDTo=$P(BookStr,"^",4)
		 		if ((BookStatuCode="Admission")||(BookStatuCode="Cancel")||(BookStatuCode="Suspend")||(BookStatuCode="Void")){
			 		q "-1^住院证为["_BooStatu_"]状态,不能进行修改!"
			 		
			 	}
			 	s TreatedOldCode=""
			 	if (EpisodeIDTo'=""){
			 		s AdmStatus=$P($g(^PAADM(EpisodeIDTo)),"^",20)
			 		s TreatedOld=$P($G(^PAADM(EpisodeIDTo,"DHC")),"^",49)
					s:TreatedOld'="" TreatedOldCode=$P($G(^DHCDocIPBDIC(TreatedOld)),"^",1)
			 	}else{
				 	s AdmStatus=""
				}
			 	if (StatuCode="Cancel")&&(AdmStatus="A"){
					q "-1^患者已经住院不允许撤销住院证!"	
				}
				
				s PatDepAm=..judgePatDepAmt(EpisodeIDTo)
				if (StatuCode="Cancel")&&(+PatDepAm>0){
					q "-1^患者已缴押金不允许撤销住院证!"	
				}
				;判断预入院记录的撤销 
				if ((StatuCode="Cancel")&(AdmStatus="P")&(EpisodeIDTo'=""))
				{
					;验证医嘱
					s rtnflag=..CancelCheck(EpisodeIDTo)
					if (rtnflag'=""){
						q "-1^"_rtnflag	
					}
					;撤销得时候验证是否可以撤销
					s opertionstr=##class(web.DHCANAdaptor).CheckValidDayOper(EpisodeIDTo)
					s opertionflag=$P(opertionstr,"^",1)
					s statuoper=$P(opertionstr,"^",2)
					if (opertionflag="Y"){
						
						if (statuoper="A"){
							Q "-1^日间手术申请已经转为正式申请,不能撤销住院证!"
						}
						
						;存在有效得入院记录
						s AuditFlag=##class(web.DHCANAdaptor).CheckDayOperAnAudit(EpisodeIDTo)
						if (AuditFlag="Y"){
							Q "-1^日间手术记录存在有效得麻醉评估,不能撤销住院证!"
						}
					}
					
				}
				if ((BookStatuCode="PreInPatient")&(StatuCode'="Cancel")&(StatuCode'="PreInPatient")){
					q "-1^预入院状态不允更换为撤销以外的状态"	
				}
				
				;预入院状态更新收治原则从日间手术去除状态得时候需要判断麻醉记录
				if ((AdmStatus="P")&(TreatedOldCode="DaySurg")&(NewTreatedCode'="DaySurg")&(EpisodeIDTo'="")){
					;预入院
					s opertionstr=##class(web.DHCANAdaptor).CheckValidDayOper(EpisodeIDTo)
					s opertionflag=$P(opertionstr,"^",1)
					s statuoper=$P(opertionstr,"^",2)
					if (opertionflag="Y"){
						if (statuoper="A"){
							Q "-1^日间手术申请已经转为正式申请不能进行撤销日间手术!"
						}
						;存在有效得入院记录
						s AuditFlag=##class(web.DHCANAdaptor).CheckDayOperAnAudit(EpisodeIDTo)
						if (AuditFlag="Y"){
							Q "-1^日间手术记录存在有效得麻醉评估,不能撤销日间手术!"
						}
					}
				}
				
				//转为有效入院得日间手术患者不允许修改日间手术标记
				if ((TreatedOldCode="DaySurg")&(AdmStatus'="P")&&(NewTreatedCode'="DaySurg")){
					q "-1^患者就诊已经转为有效就诊不能修改日间手术标记"
				}
				
				//当前住院证状态超出可开权限范畴只能撤销 例如:登记,签床，挂起之类。不能修改为申请或者预入院
				if ((CanDoStatu'="")&&(("^"_CanDoStatu_"^")'[("^"_BookStatuCode_"^"))&&(StatuCode'="Cancel")&&(BookStatuCode'=StatuCode)){
					q "-1^当前住院证状态为["_BooStatu_"],不能修改为[撤销]以外的状态!"
					
				}
				
				
				
			}else{
				s TreatedPrincipleCode=""
				s:TreatedPrinciple'="" TreatedPrincipleCode=$P($G(^DHCDocIPBDIC(TreatedPrinciple)),"^",1)
				if ((TreatedPrincipleCode="DaySurg")&(StatuCode'="PreInPatient")){
					q "-1^日间手术患者请选择【预入院】状态,如未开通请联系系统管理员!"	
				}
			}
			if (PatID=""){q "-1^患者信息指针为空!"}
			if (CreaterUser=""){q "-1^用户信息获取错误!"}
			if (ICDList="")&&(StatuCode'="Cancel"){q "-1^请填写入院临床诊断!"}
			if (InCurStatu=""){q "-1^当前状态不能为空!"}
			if (InReason=""){q "-1^操作原因不能为空!"}
			if (InCtloc=""){q "-1^住院科室不能为空!"}
			if (BookDate=""){q "-1^预约日期不能为空!"}
			if (ReAdmission="") {q "-1^15天再入院不能为空!"}
			;普通患者住院病区可以为空预入院必须选择病区
			if ((StatuCode="PreInPatient")&(InWard="")){q "-1^住院病区不能为空,请选择对应的病区!"}
	
			if ((StatuCode="SignBed")&(InWard="")){q "-1^签床状态,需要选择对应的病区!"}
			
			
			Q:StatuCode="Cancel" "0"
			if (AllowOtherLocBook=0)&&(AllowSameLocBook=0) {
				//---验重串---下边对住院证进行验重 住院科室^预约日期^住院证状态^Y有效标志
				s FindSameStr=InCtloc_"^"_BookDate_"^"_InCurStatu_"^"_"Y"
				.;查找患者所对应的所有的住院证
				k ListID
				s AdmTypeStr="O^E"
				if PatID'=""  d
			 	.for i=1:1:$L(AdmTypeStr,"^")  d
			 	..s AdmTypeSub=$P(AdmTypeStr,"^",i)
			 	..s AdmID=0 
			 	..f  s AdmID=$O(^PAPERdr(PatID,"ADM",AdmTypeSub,AdmID)) Q:AdmID=""  d
			 	...s AdmDate=$p($g(^PAADM(AdmID)),"^",6)
			 	...s AdmStatus=$P($g(^PAADM(AdmID)),"^",20)
			 	...Q:AdmStatus="C"
			 	...s RowID=0
			 	...f  s RowID=$O(^DHCDocIPBK(0,"EpisodeIDFrom",AdmID,RowID)) Q:RowID=""  d
			 	....Q:BookID=RowID
			 	.....s ListID(RowID)=""
			 	.s RowID=""
			 	.f  s RowID=$O(^DHCDocIPBK(0,"PatientID",PatID,RowID),"-1") Q:RowID=""  d
			 	..Q:BookID=RowID
			 	..s ListID(RowID)=""
			 	k SameList
			 	s RowID=0
			 	f  s RowID=$O(ListID(RowID)) Q:RowID=""  d
			 	.s BookStr=..GetBookMesage(RowID)
			 	.s FStatu=$P(BookStr,"^",9)
			 	.s Active=$P(BookStr,"^",10)
			 	.s FBookDate=$P(BookStr,"^",11)
			 	.s:FBookDate'="" FBookDate=..%ZDH(FBookDate) //$ZDH(FBookDate,3)
			 	.s FInloc=$P(BookStr,"^",14)
			 	.s IPBookNum=$P(BookStr,"^",45)
			 	.s SetSameStr=FInloc_"^"_FBookDate_"^"_FStatu_"^"_Active ;获取和验重串相同的字段和顺序
			 	.s Sub=$I(SameList(SetSameStr))
			 	.s SameList(SetSameStr,Sub)=RowID_"^"_IPBookNum
			 	
			 	if $D(SameList(FindSameStr)){
				 	q "-1^患者已经存在相同状态的住院证不能重复开具!"
				}
			 }
		 }	
	}
 	q 0
}

/// CTOR: QP
/// DATE: 2018-10-17
/// DESC: 修改患者信息()
/// IN  : 联系电话^联系人电话^联系人^关系 , 家庭住址
/// OUT : 
/// TABL: 
/// EXEC: w ##class(web.DHCDocIPBookNew).SetPatPhoneByPatID(19,"15022786651^1232^哈哈12^180","我想我是一个好人哦2")
ClassMethod SetPatPhoneByPatID(PatientID, Para, Address) As %String
{
	s rtn=1
	s ^TEMP("QP","ZYZ",11)=PatientID_"^"_Para_": "_Address
	s Address=$lb(Address)
	q:PatientID="" rtn
	s OldLogJsonData=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatientID_"^"_"User.PAPerson"_$c(2)_PatientID)
	S patPhone=$p(Para,"^",1)
	S patFPhone=$p(Para,"^",2)
	S patFName=$p(Para,"^",3)
	S patFRelation=$p(Para,"^",4)	//
	S PatCompany=$p(Para,"^",5)
	&sql(
		UPDATE SQLUser.PA_person 
        SET PAPER_TelH=:patPhone,PAPER_ForeignId=:patFName,PAPER_ForeignPhone=:patFPhone,PAPER_CTRLT_DR=:patFRelation,PAPER_StName=:Address,PAPER_SecondPhone=:PatCompany
       	WHERE PAPER_RowId = :PatientID
    )
    if SQLCODE=0{
	    s NewLogJsonData=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_PatientID_"^"_"User.PAPerson"_$c(2)_PatientID)
       	d ##class(web.DHCDocDataChangeLog).SaveLog("PA_PatMas#PA_Person","User.PAPatMas#User.PAPerson","患者基本信息","User.PAPatMas#User.PAPerson_"_PatientID,patFName,"U",NewLogJsonData,OldLogJsonData)
       	Quit 0
    }else{
    	Quit rtn
    }
}

/// 获取病区为预入院病区标识
/// Y 病区为预入院病区 其他为非预入院病区
ClassMethod GetWardPreInPatientFlag(rowid) As %String
{
	Q:rowid="" "N"
	s Flag=$P(^PAWARD(rowid),"^",13)
	q Flag
}

/// 获取住院证字典表明细
ClassMethod GetDHCDocIPBDictory(rowid) As %String
{
	Q:rowid="" ""
	Q $G(^DHCDocIPBDIC(rowid))
}

/// 获取科室收治标识是否允许无限制收治
/// "Y" 允许 其他不允许
/// w ##class(web.DHCDocIPBookNew).GetLocCureLimit(110)
ClassMethod GetLocCureLimit(ctlocdr) As %String
{
	Q:ctlocdr="" "N"
	s CTLOCAllowNoCureLimit=$P($G(^CTLOC(ctlocdr)),"^",86)
	Q CTLOCAllowNoCureLimit
}

/// 获取科室关联得其他病区
/// 传入住院科室返回住院科室关联得其他病区
/// w ##class(web.DHCDocIPBookNew).GetLinkWard(110)
ClassMethod GetLinkWard(ctlocdr) As %String
{
	s linkwardstr=""
	s wardr=0
	f  s wardr=$O(^CTLOC(ctlocdr,"LINKWARD",0,"Ward",wardr)) Q:wardr=""  d
	.s warddesc=$P(^PAWARD(wardr),"^",2)
	.s active=$P(^PAWARD(wardr),"^",6)
	.Q:active'="Y"
	.s adtivedatefrom=$P(^PAWARD(wardr),"^",7)
	.Q:((adtivedatefrom'="")&(adtivedatefrom>+$H))
	.s adtivedateto=$P(^PAWARD(wardr),"^",9)
	.Q:((adtivedateto'="")&(adtivedateto<+$H))
	.s:warddesc["-" warddesc=$P(warddesc,"-",2)
	.if linkwardstr="" s linkwardstr=warddesc_"^"_wardr
	.else  s linkwardstr=linkwardstr_"!"_warddesc_"^"_wardr
	q linkwardstr
}

/// 根据访问类型获取科室
/// w ##class(web.DHCDocIPBookNew).GetLocByType("I")
ClassMethod GetLocByType(TypeList As %String, HospId As %String = "") As %String
{
	;获取科室
	k TempList
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	f itype=1:1:$L(TypeList,"^")  d
	.s loctype=$P(TypeList,"^",itype)
	.if loctype="I"  d
	..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...q:($p($g(^CTLOC(rowid)),"^",13)'="E")
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
    ...Q:(Desc["门诊")
	...q:($P(^CTLOC(rowid),"^",14)'="Y")
    ...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	...q:HospitalDr'=HospId
    ...s TempList(Desc,rowid)=Desc
    ...
    .else  d
    ..s rowid=""
	..f  s rowid=$o(^PAC("ADMLOC",0,"AdmType",loctype,rowid))  q:rowid=""  d
	...q:($d(^CTLOC(rowid))=0)
	...s ActiveDateTo=$p($g(^CTLOC(rowid)),"^",25)
	...q:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
 	...s Desc=$p($g(^CTLOC(rowid)),"^",2)
	...q:($P(^CTLOC(rowid),"^",14)'="Y")
 	...i $p(Desc,"-",2)'="" s Desc=$p(Desc,"-",2)
    ...s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    ...s:ContactName["-" ContactName=$p(ContactName,"-",1)
    ...s HospitalDr=$p($g(^CTLOC(rowid)),"^",22)
	...q:HospitalDr'=HospId
    ...s TempList(Desc,rowid)=Desc
    
    s rtnstr=""
    s sub1=0
    f  s sub1=$O(TempList(sub1)) Q:sub1=""  d
    .s sub2=0
    .f  s sub2=$O(TempList(sub1,sub2)) Q:sub2=""  d
    ..s desc=$G(TempList(sub1,sub2))
    ..s rowid=sub2
    ..i rtnstr="" s rtnstr=desc_"^"_rowid
    ..e  s rtnstr=rtnstr_"!"_desc_"^"_rowid
    q rtnstr
}

/// 设置门诊科室可开住院科室权限
ClassMethod SetIPBookLocConfig(OPLoc As %String, IPLoc As %String, ConfigStr As %String, HospID As %String = "") As %String
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	if (OPLoc'="") {
		s ^DHCDocConfig("CanCreatBook",OPLoc)=IPLoc
		;若门诊科室可开住院科室列表中不包含已设置的默认住院科室,则把默认置空
		s DefaultIPLoc=##class(DHCDoc.DHCDocConfig.CommonFunction).GetDefaultIPBookLoc(OPLoc)
		if (DefaultIPLoc'="") {
			if ("^"_IPLoc_"^")'[("^"_DefaultIPLoc_"^") {
				d ##class(DHCDoc.DHCDocConfig.CommonFunction).SetDefaultIPBookLoc(OPLoc,"")
			}
		}
	}
	if (ConfigStr'=""){
		for i=1:1:$L(ConfigStr,"^"){
			s OneConfig=$P(ConfigStr,"^",i)
			s Code=$P(OneConfig,"!",1)
			s Value=$P(OneConfig,"!",2)
			if (Code="AllowPrintAfterInPat"){
				d ##class(web.DHCDocConfig).SaveConfig2("AllowPrintAfterInPat",Value,HospID)
			}else{
				d ..SetIPBookHospConfig(Code,Value,HospID)
			}
		}
	}
	q 0
}

ClassMethod GetIPBookConfig(HospID As %String = "")
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s rtn=""
	s rtn=..GetIPBookHospConfig("AllowSameLocBook",HospID)_"^"_..GetIPBookHospConfig("AllowOtherLocBook",HospID)
	s rtn=rtn_"^"_..%GetConfig("AllowPrintAfterInPat",HospID)_"^"_..GetIPBookHospConfig("AllowIPBookVisitPDrugOrder",HospID)
	q rtn
}

ClassMethod GetIPBookLocConfig(OPLoc As %String) As %String
{
	Q $G(^DHCDocConfig("CanCreatBook",OPLoc))
}

/// 设置住院证配置
ClassMethod SetIPBookConfig(Code As %String, Value As %String) As %String
{
	s ^DHCDocConfig(Code)=Value
	q 0
}

ClassMethod SetIPBookHospConfig(Code As %String, Value As %String, HospID As %String = "") As %String
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ^DHCDocConfig("Hosp"_HospID,"IPBookConfig",Code)=Value
	q 0
}

ClassMethod GetIPBookHospConfig(Code As %String, HospID As %String = "") As %String
{
	Q ..%GetConfig(Code,HospID)
}

/// 更具就诊检测是否可以撤销住院证
/// 返回为空 可以 不为空不可以撤销
ClassMethod CancelCheck(paadm) As %String
{
	s rtn=..GetPPatOrder(paadm)
	Q:rtn="Y" "预入院就诊存在有效的医嘱记录,请先处理！" 
	q ""
}

/// 查询是否存在有效的 预入院得医嘱
/// w ##class(web.DHCDocIPBookNew).GetPPatOrder(1854)
ClassMethod GetPPatOrder(paadm As %String) As %String
{
	
	s findactive="N"
	Q:paadm="" findactive
	s oeordr=$O(^OEORD(0,"Adm",paadm,0))
	if oeordr'=""  d
	.s oeorditem=0
	.f  s oeorditem=$O(^OEORD(oeordr,"I",oeorditem)) Q:((oeorditem="")||(findactive="Y"))  d
	..s statucode="V"
	..s statudr=$P($G(^OEORD(oeordr,"I",oeorditem,1)),"^",13)
	..if statudr'=""  d
	...s statucode=$p($g(^OEC("OSTAT",statudr)),"^",1)
	..q:((statucode="U")||(statucode="D")||(statucode="C"))
	..s findactive="Y"
	q findactive
}

/// 撤销预入院的就诊记录
ClassMethod CancelPatAdm(paadm As %String, LogUser As %String) As %String
{
	s myrtn=0
	Q:paadm="" myrtn
	s statu=$P(^PAADM(paadm),"^",20)
	;撤销住院证处理预入院记录
	if (statu="P"){
		;更新就诊表状态到C 无效
		s vis="C",read="Y",admdate=..%SysDate(),admtime=..%SysTime()
		s UserName=""
		i LogUser'="" s UserName=$p($g(^SSU("SSUSR",LogUser)),"^",2)  
		&sql(update SQLUser.PA_Adm
		Set PAADM_VisitStatus=:vis,	PAADM_ReadOnly=:read,
		PAADM_UpDateDate=:admdate,	PAADM_UpDateTime=:admtime,
		PAADM_SocialWorkerName=:LogUser,PAADM_UpdateUser_DR=:LogUser
		where PAADM_RowID=:paadm)
		s myrtn=SQLCODE
	}
	
	;撤销就诊,存在有效得日间手术申请撤销手术申请
	s opertionstr=##class(web.DHCANAdaptor).CheckValidDayOper(paadm)
	s opertionflag=$P(opertionstr,"^",1)
	if ((opertionflag="Y")&(myrtn=0)){
		s rtn=##class(web.DHCANAdaptor).CancelDayOper(paadm,LogUser)
		if (rtn=1){s myrtn=0}else{s myrtn="-1"}
	}

	
	
	q myrtn
}

/// 获取日间手术Url
ClassMethod GetBookOpertion(BookDr) As %String
{
	s URL=""
	s rtn=+..HavveActiveOpertion(BookDr)
	if ((rtn=0)||(rtn=1)){
		
		s URL="CIS.AN.DaySurgeryApp.csp?opsId=&EpisodeID="_EpisodeIDTo_"&PatientID="_PatientID_"&MRAdmID=&IsConfirm=N"
		;s URL="oeorder.ipbook.csp?&EpisodeID="_EpisodeIDTo
	}
	q URL
}

/// 判断是否存在有效的日间手术申请
/// -1 无需日间手术身亲
ClassMethod HavveActiveOpertion(BookID) As %String
{
	s rtn="-1"
	Q:+BookID<=0 rtn_"^"_"请选择有效的日间手术住院证! 住院证ID异常:"_BookID
	s PatientID=$p(^DHCDocIPBK(BookID),"^",1)
	s EpisodeIDTo=$p(^DHCDocIPBK(BookID),"^",3)
	q:EpisodeIDTo="" rtn_"^"_"非预入院,无有效就诊!"
	s VisistStatus=$p(^PAADM(EpisodeIDTo),"^",20)
	q:VisistStatus="C" rtn_"^"_"非有效住院证!"
	q:VisistStatus'="P" rtn_"^"_"患者已办理入院,请在住院处填写正常手术申请!"
	s TreatedOld=$P($G(^PAADM(EpisodeIDTo,"DHC")),"^",49)
	s TreatedOldCode=""
	s:TreatedOld'="" TreatedOldCode=$P($G(^DHCDocIPBDIC(TreatedOld)),"^",1)
	Q:TreatedOldCode'="DaySurg" rtn_"^"_"收治原则为非日间手术不能进行手术申请"
	
	s opertionstr=##class(web.DHCANAdaptor).CheckValidDayOper(EpisodeIDTo)
	s opertionflag=$P(opertionstr,"^",1)
	if (opertionflag="Y"){s rtn=1_"^存在有效的手术申请"}
	else{s rtn=0_"^不存在有效的手术申请"}
	q rtn
}

/// 提供给计费组日间手术 撤销住院证有效状态 预入院转门诊
/// w ##class(web.DHCDocIPBookNew).CancelBookStatu(69,6)
ClassMethod CancelBookStatu(BookID, UserDr) As %String
{
	Q:+BookID="" "-1^住院证ID不存在"
	;撤销住院证的有效状态
	s CurrentStateID=$O(^DHCDocIPBDIC(0,"TypeCode","IPBookingState","Cancel",0))	
	Q:CurrentStateID="" "-1^住院证状态不存在" 
	s IsActive="N"
	s Date=..%SysDate()
	s Time=..%SysTime()
	&SQL(Update SQLUser.DHCDocIPBooking  set IsActive=:IsActive,CurrentStateID=:CurrentStateID,UpdateUser=:UserDr,UpdateDate=:Date,UpdateTime=:Time
	 where RowID=:BookID
	)
	s myrtn=SQLCODE	
	q myrtn
}

/// 撤销患者日间手术标识----
/// w ##class(web.DHCDocIPBookNew).CancelDaySurg(69)
ClassMethod CancelDaySurg(EpisodeIDIP, UserDr) As %String
{
	s myrtn=0
	Q:+EpisodeIDIP=0 "-1^传入住院就诊ID"
	s TreatedOldCode=""
	s TreatedOld=$P($G(^PAADM(EpisodeIDIP,"DHC")),"^",49)
	s:TreatedOld'="" TreatedOldCode=$P($G(^DHCDocIPBDIC(TreatedOld)),"^",1)
	if (TreatedOldCode="DaySurg"){
		&SQL(Update SQLUser.PA_AdmExt  set PAADM_IPBTreatedPrinciple_DR=null where PAADM_RowId=:EpisodeIDIP)
		s myrtn=SQLCODE
		s rtnloc=##class(DHCDoc.Log.Common).General("Insert","web.DHCDocIPBookNew","CancelDaySurg","撤销患者日间手术标识",EpisodeIDIP,"EpisodeIDIP:"_EpisodeIDIP_",UserDr:"_UserDr)
	}
	
	s bookdr=$O(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeIDIP,0))
	if (bookdr'=""){
		s rtnbookmes=..GetBookMesage(bookdr)	
		s treated=$P(rtnbookmes,"^",44)
		if (treated'=""){
			s treatedcode=$P($G(^DHCDocIPBDIC(treated)),"^",1)
			if (treatedcode="DaySurg"){
				&SQL(Update SQLUser.DHCDocIPBooking  set TreatedPrinciple=null where RowID=:bookdr)
				s myrtn=SQLCODE
			}
		}
	}
	q myrtn
}

/// 更新住院证状态接口
/// w ##class(web.DHCDocIPBookNew).UpdateBookStatu(169,"Register",4634)
ClassMethod UpdateBookStatu(BookID, StatuCode, UserDr, CancleID = "") As %String
{
	Q:BookID="" "-1^住院证ID不存在"
	Q:StatuCode="" "-1^需要更新状态Code不存在"
	Q:UserDr="" "-1^更新用户不存在"
	s CurrentStateID=$O(^DHCDocIPBDIC(0,"TypeCode","IPBookingState",StatuCode,0))	
	Q:CurrentStateID="" "-1^住院证状态不存在" 
	Q:$G(^DHCDocIPBK(BookID))="" "-1^住院证ID无效"
	
	s nowstatudr=$p(^DHCDocIPBK(BookID),"^",8)
	s nowstatcode=""
	s:nowstatudr'="" nowstatcode=$P(^DHCDocIPBDIC(nowstatudr),"^",1)
	s Admstau=""
	s EpisodeIDTo=$p(^DHCDocIPBK(BookID),"^",3)
	s:EpisodeIDTo'="" Admstau=$P($G(^PAADM(EpisodeIDTo)),"^",20)
	s Date=..%SysDate()
	s Time=..%SysTime()
	
	s CheckCando=$$CheckCando()
	Q:CheckCando'="" "-1^"_CheckCando
	
	;撤销住院证的有效状态
	ts
	if ((StatuCode="Cancel")||(StatuCode="Void")) d
	.s IsActive="N"
	
	
	s rtn=$$UpdateBookStatu()
	if rtn'=0 {
		tro
		q "-1^更新住院证状态失败"_trn
	}
	
	;撤销住院证存在预入院的就诊记录撤销就诊
	if ((EpisodeIDTo'="")&(Admstau="P")&(IsActive="N")){
		s rtn=..CancelPatAdm(+EpisodeIDTo,UserDr)
		if rtn'=0 {
			tro
			q "-1^撤销就诊记录失败,"_rtn	
		}
	}
	;调用护士站接口预约到床位后撤销床位
	if (IsActive="N"){
		s rtn=+##Class(Nur.InService.Interface).ifPatAppBed(BookID)
		if (rtn=0){
			 s rtn=+##Class(Nur.InService.Interface).cancelPatAppBed(BookID,UserDr,CancleID)
			 if (rtn'=0){
				tro
				q "-1^床位撤销失败:"_ rtn
			 }
		}
	}
	
	
	
	
	tc
	q 0
	
CheckCando()

	s cannotdo=""
	
	s IsActive=$p(^DHCDocIPBK(BookID),"^",9) ;
	s:IsActive'="Y" cannotdo="住院证已失效不允许进行状态修改!"
	
	if nowstatcode="Admission" s cannotdo="住院证状态当前状态为住院不予需操作!"
	
	if nowstatcode="Cancel" s cannotdo="住院证状态当前状态为撤销不予需操作!"
	
	if (nowstatcode="Void") s cannotdo="住院证状态当前状态为作废不予需操作!"
	
	if EpisodeIDTo'=""  d
	.if ((Admstau="A")||(Admstau="D"))&("Admission"'=StatuCode)  d
	..s cannotdo="已经存在有效得的住院记录,不允许更新为入院以外得其他状态!"
	
	Q:cannotdo'="" ""
	
	;验证是否可以撤销
	if ((StatuCode="Cancel")||(nowstatcode="Void")) d
	.if Admstau="P"  d
	..s PatDepAm=..judgePatDepAmt(EpisodeIDTo)
	..if (+PatDepAm>0)  d
	...s cannotdo="患者已缴押金不允许撤销、作废住院证!"	
	..
	..s rtnflag=..GetPPatOrder(EpisodeIDTo)
	..if rtnflag="Y"  d
	...s cannotdo="患者存在有效的医嘱记录,请先将医嘱撤销!"
	..	
	..;撤销得时候验证是否可以撤销
	..s opertionstr=##class(web.DHCANAdaptor).CheckValidDayOper(EpisodeIDTo)
	..s opertionflag=$P(opertionstr,"^",1)
	..s statuoper=$P(opertionstr,"^",2)
	..if (opertionflag="Y")  d
	...if (statuoper="A") d
	....s cannotdo="操作失败,日间手术申请已经转为正式申请!"
	..s AuditFlag=##class(web.DHCANAdaptor).CheckDayOperAnAudit(EpisodeIDTo)
	..if (AuditFlag="Y") d
	...s cannotdo="操作失败,日间手术记录存在有效得麻醉评估!"
	q cannotdo

UpdateBookStatu()
	&SQL(Update SQLUser.DHCDocIPBooking  set IsActive=:IsActive,CurrentStateID=:CurrentStateID,UpdateUser=:UserDr,UpdateDate=:Date,UpdateTime=:Time
	 where RowID=:BookID
	)
	s myrtn=SQLCODE	
	q myrtn
}

/// 根据住院证插入
ClassMethod InserDiagenose(BookID As %String) As %String
{
	n (BookID,LogOnLoc,%session)
	s BookMesage=..GetBookMesage(BookID)
	s ipadm=$P(BookMesage,"^",4)
	s creatdate=$P(BookMesage,"^",5)
	s icdlist=$P(BookMesage,"^",25)
	s userdr=$P(BookMesage,"^",7)
	s locdr=$P(BookMesage,"^",56)
	s status=""
	s:ipadm'="" status=$p(^PAADM(ipadm),"^",20)
	s ICDListStr=$P(BookMesage,"^",37)
	if ((status="P")&(ICDListStr'="")){
		s SaveDiagStr=""
		s len=$L(ICDListStr,"!")
		for i=1:1:len{
			s oneIcdInfo=$p(ICDListStr,"!",i)
			continue:oneIcdInfo=""
			s ICDRowid=$p(oneIcdInfo,$C(2),1)
			s DiagnosStatusRowId=$p(oneIcdInfo,$C(2),3)
			s DiagnosCat=$p(oneIcdInfo,$C(2),4)
			s DiagnosNotes=$p(oneIcdInfo,$C(2),5)
			s DiagnosPrefix=$p(oneIcdInfo,$C(2),6)
			s SDSInfo=$p(oneIcdInfo,$C(2),7)
			s ChildDiagStr=$p(oneIcdInfo,$C(2),8)
			
			s SDSTermDR=$p(SDSInfo,$C(1),2)
    		s SDSDisplayIDStr=$p(SDSInfo,$C(1),3)
    		s SDSWordID=$p(SDSInfo,$C(1),4)
    		s SDSNote=$p(SDSInfo,$C(1),5)
			s SyndromeCICDStr="",SyndromeCDescStr=""
			for j=1:1:$L(ChildDiagStr,$C(1)){
				s ChildStr=$P(ChildDiagStr,$C(1),j)
				continue:ChildStr=""
				s ChildICDRowid=$P(ChildStr,$C(3),1)
				s Note=$P(ChildStr,$C(3),3)
				s Prefix=$P(ChildStr,$C(3),4)
				s oneSyndromeCICDStr=ChildICDRowid_$C(2)_"3"_$C(2)_"N"_$C(2)_DiagnosStatusRowId_$C(2)_""_$C(2)_""_$C(2)_""_$C(2)_Prefix
				i (SyndromeCICDStr="")&&(SyndromeCDescStr="") s SyndromeCICDStr=oneSyndromeCICDStr,SyndromeCDescStr=Note
				e  s SyndromeCICDStr=SyndromeCICDStr_"$"_oneSyndromeCICDStr,SyndromeCDescStr=SyndromeCDescStr_"$"_Note
			}
			s diastr="^"_DiagnosNotes_"^"_ICDRowid_"^3^N^"_DiagnosStatusRowId_"^"_creatdate_"^"_SyndromeCICDStr_"^"_SyndromeCDescStr_"^false^^^"_DiagnosPrefix_"^"_SDSTermDR_"^"_SDSDisplayIDStr_"^"_SDSWordID_"^"_SDSNote
			i SaveDiagStr="" s SaveDiagStr=diastr
			e  s SaveDiagStr=SaveDiagStr_$C(1)_diastr
		} 
		if SaveDiagStr'=""{
			s mradm=$p($g(^PAADM(ipadm)),"^",61)
			s AdmPara="^^^^^^^^1^^^"
			s rtn=##class(web.DHCDocDiagnosEntryV8).InsertMRDiagnos(mradm,SaveDiagStr,AdmPara,locdr,userdr)
		}
	}
	q 0
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 获取诊断状态
/// IN  : 
/// OUT : 
/// TABL: PHC_Poison
/// EXEC: w ##class(web.DHCDocIPBookNew).GetDiaStatus("3")
ClassMethod GetDiaStatus(SID As %String)
{
	n (SID)
	s mRtn=""
	q:SID="" mRtn
	s mRtn=$P($g(^MRC("DSTAT",SID)),"^",2)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2018-10-12
/// DESC: 获取诊断状态
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("web.DHCDocIPBookNew","QryDiaStatus")
Query QryDiaStatus() As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod QryDiaStatusExecute(ByRef qHandle As %Binary) As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    s diaId=0 f  s diaId=$o(^MRC("DSTAT",diaId)) q:diaId=""  d
    .s code=$p(^MRC("DSTAT",diaId),"^",1)
    .s desc=$p(^MRC("DSTAT",diaId),"^",2)
    .d DHCAntOut1
    
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
DHCAntOut1
	set Data=$lb(diaId,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryDiaStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiaStatusExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDiaStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiaStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod checkIsExistBook(EpisodeID As %String) As %String
{
	s FindBook="N"
	s BookIDF=0
	f  s BookIDF=$O(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,BookIDF))  Q:(BookIDF="")||(FindBook="Y")  d
	.s BookMes=..GetBookMesage(BookIDF)
	.s InCurStatu=$P(BookMes,"^",9)
	.s StatuCode=$P($G(^DHCDocIPBDIC(InCurStatu)),"^",1)
	.Q:((StatuCode="Cancel")||(StatuCode="Void")||(StatuCode="Admission"))
	.s Actuive=$P(BookMes,"^",10)
	.Q:Actuive'="Y"
	.s FindBook="Y"
	Q:FindBook="Y" "1^该次就诊已经存在有效的住院证!"
	Q ""
}

/// CTOR: 宋春莉
/// DATE: 2019-04-16
/// DESC: 预住院记录转住院时同时更新诊断日期
/// IN  : 
/// OUT : 0 成功 其他失败
/// EXEC: w ##class(web.DHCDocIPBookNew).UpdatePreInPatDiagDate(AdmRowId,UserRowId)
ClassMethod UpdatePreInPatDiagDate(AdmRowId As %String, UserRowId As %String)
{
	n (AdmRowId,UserRowId)
	s Err=0
	Q:AdmRowId="" Err
	s MRAdmRowId=$p(^PAADM(AdmRowId),"^",61)
	Q:MRAdmRowId="" Err
	s CurDate=..%SysDate(),CurTime=..%SysTime()
	TS
	s MRDIAChildsub=0
	f  {
		Q:Err'=0
		s MRDIAChildsub=$o(^MR(MRAdmRowId,"DIA",MRDIAChildsub))
		Q:MRDIAChildsub=""
		s MRDIARowId=MRAdmRowId_"||"_MRDIAChildsub
		
	    s object = ##class(User.MRDiagnos).%OpenId(MRDIARowId)
	    // s object.MRDIAOnsetDate=CurDate
	    s object.MRDIADate=CurDate
   		s object.MRDIATime=CurTime
   		Do object.MRDIAUpdateUserDRSetObjectId(UserRowId)
   		s object.MRDIAUpdateDate=CurDate
   		s object.MRDIAUpdateTime=CurTime
	    s sc = object.%Save()
		If $$$ISERR(sc) {
			 Do $System.Status.DisplayError()
			 s Err="-201^更新诊断表失败,错误信息:"_$ZE
			 Quit 
	   }
	   Do object.%Close()
    }
    if Err=0 TC
    else  TRO
    Q Err
}

// CombDesc:%String,CombValue:%String,selected:%Boolean,Alias:%String

/// w ##class(web.DHCDocIPBookNew).CombListFindJson("InCtloc","6",)
ClassMethod CombListFindJson(CombName As %String, Inpute1 As %String, Inpute2 As %String = "", Inpute3 As %String = "", Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "") As %String
{
	s JsonObj=[]
	Set rset=##class(%ResultSet).%New("web.DHCDocIPBookNew:CombListFind")
	do rset.Execute(CombName,Inpute1,Inpute2,Inpute3,Inpute4,Inpute5,Inpute6)
	While (rset.Next()) {
	    s CombDesc=rset.Data("CombDesc")
	    s CombDesc=##class(websys.Translation).Get("doc.ipbookcreate.hui.csp",CombDesc)
	    s CombValue=rset.Data("CombValue")
	    s selected=rset.Data("selected")
	    s Alias=rset.Data("Alias")
	    s JsonData={}
	    do JsonData.%Set("CombDesc",CombDesc)
	    do JsonData.%Set("CombValue",CombValue)
	    do JsonData.%Set("selected",selected,"number")
	    do JsonData.%Set("Alias",Alias)
	    do JsonObj.%Push(JsonData,"")
	}
	d rset.Close()
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	//s JsonStr=$replace(JsonStr,"""","'")
	q JsonStr
}

Query GetDepConfigList(HospID, ContentDesc) As %Query(ROWSPEC = "RowID,LocDesc,InPatLoc,NeedtoDate,NeedtoPre")
{
}

ClassMethod GetDepConfigListExecute(ByRef qHandle As %Binary, HospID, ContentDesc) As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s RowID=""
 	s ContentDesc=$ZCVT(ContentDesc,"U")
 	for {
	 	s RowID=$O(^CTLOC(RowID))
	 	q:RowID=""
	 	continue:('$d(^PAC("ADMLOC",0,"AdmType","O",RowID)))&&('$d(^PAC("ADMLOC",0,"AdmType","E",RowID)))&&('$d(^PAC("ADMLOC",0,"AdmType","I",RowID)))
	 	s ActiveDateTo=$p($g(^CTLOC(RowID)),"^",25)
	 	Continue:(ActiveDateTo'="")&&(ActiveDateTo<+$h)
	 	s HospitalDr=$p($g(^CTLOC(RowID)),"^",22)
		Continue:HospitalDr'=HospID
		s LocDesc=$p($g(^CTLOC(RowID)),"^",2)
		continue:(ContentDesc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(RowID,ContentDesc))
		continue:($P(^CTLOC(RowID),"^",14)'="Y")
 		i $p(LocDesc,"-",2)'="" s LocDesc=$p(LocDesc,"-",2)
		s InPatLoc=""
		s InPatLocIDStr=$G(^DHCDocConfig("CanCreatBook",RowID))
		if (InPatLocIDStr'=""){
			for i=1:1:$L(InPatLocIDStr,"^"){
				s InPatID=$P(InPatLocIDStr,"^",i)
				s InPatDesc=$p($g(^CTLOC(InPatID)),"^",2)
				i $p(InPatDesc,"-",2)'="" s InPatDesc=$p(InPatDesc,"-",2)
				if (InPatLoc=""){s InPatLoc=InPatDesc}else{s InPatLoc=InPatLoc_","_InPatDesc}
				if (i>5){
					s InPatLoc=InPatLoc_",..."
					q
				} 
			}
		}
		if (InPatLoc="") s InPatLoc="增加"
		s NeedtoDate="N"
		if (("$"_$g(^DHCDocConfig("Hosp"_HospID,"IPBookConfig","needAdmDateLoc"))_"$")[("$"_RowID_"$")) s NeedtoDate="Y"
		s NeedtoPre="N"
		if (("$"_$g(^DHCDocConfig("Hosp"_HospID,"IPBookConfig","needPreLoc"))_"$")[("$"_RowID_"$")) s NeedtoPre="Y"
	 	set Data=$lb(RowID,LocDesc,InPatLoc,NeedtoDate,NeedtoPre)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}

   
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetDepConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepConfigListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveOneLocConfig(HospID, LocID, needAdmDateLoc, needPreLoc)
{
	
	s needAdmDateLocStr=$g(^DHCDocConfig("Hosp"_HospID,"IPBookConfig","needAdmDateLoc"))
	if (needAdmDateLoc="Y"){
		if (("$"_needAdmDateLocStr_"$")[("$"_LocID_"$")){
		}else{
			s needAdmDateLocStr=needAdmDateLocStr_"$"_LocID
		}
	}else{
		if (("$"_needAdmDateLocStr_"$")[("$"_LocID_"$")){
			s NewStr=""
			for i=1:1:$L(needAdmDateLocStr,"$"){
				s Oneloc=$P(needAdmDateLocStr,"$",i)
				continue:Oneloc=LocID
				if NewStr="" s NewStr=Oneloc
				else  s NewStr=NewStr_"$"_Oneloc
			}
			s needAdmDateLocStr=NewStr
		}
	}
	s rtn=..SetIPBookHospConfig("needAdmDateLoc", needAdmDateLocStr,HospID)
	s needPreLocStr=$g(^DHCDocConfig("Hosp"_HospID,"IPBookConfig","needPreLoc"))
	if (needPreLoc="Y"){
		if (("$"_needPreLocStr_"$")[("$"_LocID_"$")){
		}else{
			s needPreLocStr=needPreLocStr_"$"_LocID
		}
	}else{
		if (("$"_needPreLocStr_"$")[("$"_LocID_"$")){
			s NewStr=""
			for i=1:1:$L(needPreLocStr,"$"){
				s Oneloc=$P(needPreLocStr,"$",i)
				continue:Oneloc=LocID
				if NewStr="" s NewStr=Oneloc
				else  s NewStr=NewStr_"$"_Oneloc
			}
			s needPreLocStr=NewStr
		}
	}
	s rtn=..SetIPBookHospConfig("needPreLoc", needPreLocStr,HospID)
	q 0
}

/// 通过PatientID获取是否有切只有一张临时卡
/// w ##class(web.DHCDocIPBookNew).CheckTempCardByPatientID(88)
ClassMethod CheckTempCardByPatientID(PatientID As %String) As %String
{
  Quit:$g(PatientID)="" "N"
  if (PatientID'="") {
	 //q:PatientID="" ""
	 s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	 set Active=$P($g(^PAPER(PatientID,"PAT",1)),"^",6)
	 Q:Active="N" "N"
	 Q:'$d(^DHCCARDi("CF",0,"PAPMIDR",PatientID)) ""
	 Set FindCFType="",FindCFTypeDesc="",FindCardId="",FindCardSecurityNo="",TempCardId="",left=""
	 s CardNum=0
	 Set CFRowId=0
	 for {
		 set CFRowId=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowId)) Q:CFRowId=""
		 set ActiveFlag=$p(^DHCCARD("CF",CFRowId),"^",10)
		 continue:ActiveFlag'="N"
		 s CFIsTemporaryCard=$P(^DHCCARD("CF",CFRowId),"^",29)
		 if (CFIsTemporaryCard="Y") s TempCardId=CFRowId
		 s FindCardId=CFRowId
		 s myAccRowID=$p(^DHCCARD("CF",CFRowId),"^",1)	;myAccRowID
		 if myAccRowID'="" {
			s AccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)
			if (AccStatus="N"){
				s Balance=$p(^DHCACD("AccM",myAccRowID),"^",8)
				s DepPrice=##class(web.UDHCAccManageCLSIF).GetAccMDepPrice(myAccRowID, "","")
				s left=Balance-DepPrice
			}
		}
		s CardNum=CardNum+1
	 }
	 q:(CardNum=1)&&(TempCardId'="") "Y"
	 q "N"
  }
}

/// 通过PatientID判断是否存在急诊抢救和急诊留观
/// w ##class(web.DHCDocIPBookNew).CheckEmerInfo(30)
ClassMethod CheckEmerInfo(PatientID As %String) As %String
{
	q:PatientID="" ""
	s AdmIdBook=""
	s ret=""
	f  s AdmIdBook=$O(^PAPERdr(PatientID,"ADM","E",AdmIdBook)) q:(AdmIdBook="")||(ret'="")  d
	.s ret=##class(web.DHCEMInterfaceCom).IsStayingObsWard(AdmIdBook)
	q ret
}

/// 校验患者是否存在其他就诊记录的有效住院证
/// Input: AdmID:就诊ID
/// 	   BookID:住院证ID
/// 	   Flag:就诊标识：TheAdm/OtherAdm/OtherLoc/SameLoc:本次就诊/其他就诊/不同科室/同一科室
/// 	   AdmTypeStr:就诊类型串
/// Output: "N/Y"_$c(2)_住院证的提示($c(1))
/// w ##class(web.DHCDocIPBookNew).CheckActiveBookInfo(392,"TheAdm")
ClassMethod CheckActiveBookInfo(AdmID, BookID, Flag, AdmTypeStr = "O^E")
{
	n (AdmID,BookID,Flag,AdmTypeStr,%session)
	s ^templx("CheckActiveBookInfo")=$lb(AdmID,BookID,Flag,AdmTypeStr)
	s FindBook="N"
	s FBookInfoStr=""
	s FlagStr="^OtherAdm^OtherLoc^SameLoc^"
	
	s AdmInfo=$g(^PAADM(AdmID))
	s PatID=$p(AdmInfo,"^",1)
	s AdmLoc=$p(AdmInfo,"^",4)
	s AdmHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmID)
	if (Flag="TheAdm"){
		;查询本次就诊是否已存在有效住院证
		s FindPAAdm=AdmID
		do FindAdmBookInfo
	}elseif(FlagStr[("^"_Flag_"^")){
		;查询不同次就诊是否存在有效住院证
		for len=1:1:$L(AdmTypeStr,"^"){
			Q:(FindBook="Y")
			s PaadmType=$p(AdmTypeStr,"^",len)
			s FindPAAdm=""
			for {
				s FindPAAdm=$O(^PAPERdr(PatID,"ADM",PaadmType,FindPAAdm),-1)
				Q:(FindPAAdm="")||(FindBook="Y")
				continue:(FindPAAdm=AdmID)			
				s VisistStatus=$p(^PAADM(FindPAAdm),"^",20)
				s FindAdmHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(FindPAAdm)
				continue:(AdmHosp'=FindAdmHosp)
				s StayStatus=0
				s StayStatus=##class(web.DHCADMVisitStat).GetStayStatus(FindPAAdm)
				continue:((StayStatus=0)&&(VisistStatus'="A"))
				s FindPAAdmLoc=$p($g(^PAADM(FindPAAdm)),"^",4)
				continue:(Flag="OtherLoc")&&(FindPAAdmLoc=AdmLoc)		;允许跨科室有效住院证重复
				continue:(Flag="SameLoc")&&(FindPAAdmLoc'=AdmLoc)		;允许同一科室有效住院证重复
				do FindAdmBookInfo
			}
		}
	}
	q FindBook_$c(2)_FBookInfoStr

FindAdmBookInfo
	s BookIDF=0
	f  s BookIDF=$O(^DHCDocIPBK(0,"EpisodeIDFrom",FindPAAdm,BookIDF))  Q:(BookIDF="")  d
	.Q:(BookID=BookIDF)
	.s BookMes=..GetBookMesage(BookIDF)
	.s InCurStatu=$P(BookMes,"^",9)
	.s StatuCode=$P($G(^DHCDocIPBDIC(InCurStatu)),"^",1)
	.Q:((StatuCode="Cancel")||(StatuCode="Void")||(StatuCode="Admission"))
	.s Actuive=$P(BookMes,"^",10)
	.Q:Actuive'="Y"
	.s BTimeLiness=##class(web.DHCBillInterface).IIsIPBook(BookIDF)
	.q:($p(BTimeLiness,"^",1)="IPBookErr")
	.s FBookInfo=$$GetPreBookInfo(BookMes)
	.i FBookInfoStr'="" s FBookInfoStr=FBookInfoStr_$c(1)_FBookInfo
	.e  s FBookInfoStr=FBookInfo
	.s FindBook="Y"
	Q ""

GetPreBookInfo(BookInfo)
	n (BookInfo,%session)
	Set langid=..%LanguageID()
	s PreInfo=""
	s EpisodeIDTo=$p(BookInfo,"^",4)
	s CCreatDate=$p(BookInfo,"^",5)
	s CCreatTime=$p(BookInfo,"^",6)
	s CCreatUser=$p(BookInfo,"^",27)
	s CCreatUser =##class(User.SSUser).GetTranByDesc("SSUSRName",CCreatUser,langid)
	s CCreatLoc=$p(BookInfo,"^",57)
	i EpisodeIDTo'="" {
		;预住院数据信息
		s AdmInfo=$g(^PAADM(EpisodeIDTo))
		s AdmLocID=$p(AdmInfo,"^",4)
		s AdmDate=$p(AdmInfo,"^",6)
		s AdmDocID=$p(AdmInfo,"^",9)
		s:AdmLocID'="" AdmLocDesc=$p($g(^CTLOC(AdmLocID)),"^",2)
		s:AdmDocID'="" AdmDocDesc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
		s AdmLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",$g(AdmLocDesc),langid)
		Set AdmDocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",$g(AdmDocDesc),langid)
		s PreInfo=" "_CCreatUser_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","于")_CCreatDate_" "_CCreatTime_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","申请了：")_$g(AdmLocDesc)_$g(AdmDocDesc)_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","的住院证信息")
	}else{
		;有效住院证信息
		s AdmLocDesc=$p(BookInfo,"^",29)
		s AdmWardDesc=$p(BookInfo,"^",31)
		s AdmLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",$g(AdmLocDesc),langid)
		s AdmWardDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",$g(AdmWardDesc),langid)
		;s AdmWardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",AdmWardDesc,langid)
		s PreInfo=" "_CCreatUser_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","于")_CCreatDate_" "_CCreatTime_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","申请了：")_$g(AdmWardDesc)_##class(websys.Translation).Get("doc.ipbookcreate.hui.csp","的住院证信息")
	}
	Q PreInfo
}

/// 判断是否可以撤销住院证 当前规则:不可撤销非本科是开出的住院证
/// w ##class(web.DHCDocIPBookNew).CheckCanCancel()
/// 0:可以 -1:不可
ClassMethod CheckCanCancel(BookID, CheckLoc)
{
    q:(BookID="")||(CheckLoc="") "0"
    s CreateLoc=$p($g(^DHCDocIPBK(BookID)),"^",36)
    q:CreateLoc="" "0"

    //不可撤销非验证科室开出的住院证
    q:CheckLoc'=CreateLoc "-1"
    q "0"
}

/// 根据住院证查询
/// /// w ##class(web.DHCDocIPBookNew).GetDiagenose(425)
ClassMethod GetDiagenose(BookID As %String) As %String
{
	n (BookID,LogOnLoc,%session)
	s BookMesage=..GetBookMesage(BookID)
	s ipadm=$P(BookMesage,"^",4)
	s creatdate=$P(BookMesage,"^",5)
	s icdlist=$P(BookMesage,"^",25)
	s userdr=$P(BookMesage,"^",7)
	s locdr=$P(BookMesage,"^",56)
	s status=""
	s:ipadm'="" status=$p(^PAADM(ipadm),"^",20)
	s ICDListStr=$P(BookMesage,"^",37)
	s DiaStr=""
	if ((ICDListStr'="")){
		s SaveDiagStr=""
		s len=$L(ICDListStr,"!")
		for i=1:1:len{
			s oneIcdInfo=$p(ICDListStr,"!",i)
			continue:oneIcdInfo=""
			s ICDRowid=$p(oneIcdInfo,$C(2),1)
			s Desc=$p(oneIcdInfo,$C(2),2)
			s DiagnosStatusRowId=$p(oneIcdInfo,$C(2),3)
			s DiagnosCat=$p(oneIcdInfo,$C(2),4)
			s DiagnosNotes=$p(oneIcdInfo,$C(2),5)
			s DiagnosPrefix=$p(oneIcdInfo,$C(2),6)
			s SDSInfo=$p(oneIcdInfo,$C(2),7)
			s ChildDiagStr=$p(oneIcdInfo,$C(2),8)	
			s SDSTermDR=$p(SDSInfo,$C(1),2)
    		s SDSDisplayIDStr=$p(SDSInfo,$C(1),3)
    		s SDSWordID=$p(SDSInfo,$C(1),4)
    		s SDSNote=$p(SDSInfo,$C(1),5)
			s ChildDiagStr=""
			for j=1:1:$L(ChildDiagStr,$C(1)){
				s ChildStr=$P(ChildDiagStr,$C(1),j)
				continue:ChildStr=""
				s ChildICDRowid=$P(ChildStr,$C(3),1)
				s ChildDesc=$P(ChildStr,$C(3),2)
				s Note=$P(ChildStr,$C(3),3)
				s Prefix=$P(ChildStr,$C(3),4)
				s ChildStr=ChildICDRowid_$C(3)_ChildDesc_$C(3)_Note_$C(3)_Prefix
				i ChildDiagStr="" s ChildDiagStr=ChildStr
				e  s ChildDiagStr=ChildDiagStr_$C(1)_ChildStr
			}
			s str=ICDRowid_$C(2)_Desc_$C(2)_DiagnosStatusRowId_$C(2)_DiagnosCat_$C(2)_DiagnosNotes_$C(2)_DiagnosPrefix_$C(2)_SDSInfo_$C(2)_ChildDiagStr
			if DiaStr="" s DiaStr=str
			else  s DiaStr=DiaStr_"!"_str
		} 
	}
	q DiaStr
}

/// 根据住院证插入
/// w ##class(web.DHCDocIPBookNew).InserDiagenoseBill(BookID,UserID,DocUserId)
ClassMethod InserDiagenoseBill(BookID As %String, UserID As %String, DocUserId As %String = "") As %String
{
	n (BookID,LogOnLoc,UserID,DocUserId,%session)
	s BookMesage=..GetBookMesage(BookID)
	s ipadm=$P(BookMesage,"^",4)
	s creatdate=$P(BookMesage,"^",5)
	s icdlist=$P(BookMesage,"^",25)
	s userdr=$P(BookMesage,"^",7)
	s locdr=$P(BookMesage,"^",56)
	if (DocUserId="") s DocUserId=userdr
	s status=""
	s:ipadm'="" status=$p(^PAADM(ipadm),"^",20)
	s ICDListStr=$P(BookMesage,"^",37)
	b ;333
	if ((ICDListStr'="")){
		s SaveDiagStr=""
		s len=$L(ICDListStr,"!")
		for i=1:1:len{
			s oneIcdInfo=$p(ICDListStr,"!",i)
			continue:oneIcdInfo=""
			s ICDRowid=$p(oneIcdInfo,$C(2),1)
			s DiagnosStatusRowId=$p(oneIcdInfo,$C(2),3)
			s DiagnosCat=$p(oneIcdInfo,$C(2),4)
			s DiagnosNotes=$p(oneIcdInfo,$C(2),5)
			s DiagnosPrefix=$p(oneIcdInfo,$C(2),6)
			s SDSInfo=$p(oneIcdInfo,$C(2),7)
			s ChildDiagStr=$p(oneIcdInfo,$C(2),8)
			
			s SDSTermDR=$p(SDSInfo,$C(1),2)
    		s SDSDisplayIDStr=$p(SDSInfo,$C(1),3)
    		s SDSWordID=$p(SDSInfo,$C(1),4)
    		s SDSNote=$p(SDSInfo,$C(1),5)
			s SyndromeCICDStr="",SyndromeCDescStr=""
			for j=1:1:$L(ChildDiagStr,$C(1)){
				s ChildStr=$P(ChildDiagStr,$C(1),j)
				continue:ChildStr=""
				s ChildICDRowid=$P(ChildStr,$C(3),1)
				s Note=$P(ChildStr,$C(3),3)
				s Prefix=$P(ChildStr,$C(3),4)
				s oneSyndromeCICDStr=ChildICDRowid_$C(2)_"3"_$C(2)_"N"_$C(2)_DiagnosStatusRowId_$C(2)_""_$C(2)_""_$C(2)_""_$C(2)_Prefix
				i (SyndromeCICDStr="")&&(SyndromeCDescStr="") s SyndromeCICDStr=oneSyndromeCICDStr,SyndromeCDescStr=Note
				e  s SyndromeCICDStr=SyndromeCICDStr_"$"_oneSyndromeCICDStr,SyndromeCDescStr=SyndromeCDescStr_"$"_Note
			}
			s diastr="^"_DiagnosNotes_"^"_ICDRowid_"^3^N^"_DiagnosStatusRowId_"^"_creatdate_"^"_SyndromeCICDStr_"^"_SyndromeCDescStr_"^false^^^"_DiagnosPrefix_"^"_SDSTermDR_"^"_SDSDisplayIDStr_"^"_SDSWordID_"^"_SDSNote
			s $p(diastr,"^",18)=DocUserId
			i SaveDiagStr="" s SaveDiagStr=diastr
			e  s SaveDiagStr=SaveDiagStr_$C(1)_diastr
		} 
		if SaveDiagStr'=""{
			s mradm=$p($g(^PAADM(ipadm)),"^",61)
			s AdmPara="^^^^^^^^1^^^"
			s rtn=##class(web.DHCDocDiagnosEntryV8).InsertMRDiagnos(mradm,SaveDiagStr,AdmPara,locdr,UserID)
		}
	}
	q 0
}

/// renyx 由于翻译诊断存储的问题，重新加载诊断
ClassMethod ReLoadBookDiagInfo(ICDList As %String)
{
	n (ICDList,%session)
	Set langid=..%LanguageID()
	for ICDListInd=1:1:$l(ICDList,"!"){
		s ICDSub=$P(ICDList,"!",ICDListInd)
		continue:ICDSub=""
		s ICDRowId=$p(ICDSub,$c(2),1)
		S SID=$p(ICDSub,$c(2),3)
		s SIDesc=""
		s:SID'="" SIDesc=$P($g(^MRC("DSTAT",SID)),"^",2)
		s SIDesc =##class(User.MRCDiagnosStatus).GetTranByDesc("DSTATDesc",SIDesc,langid)
		if (ICDRowId'=""){
			s Desc=$p(^MRC("ID",ICDRowId),"^",2)
			s Desc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",Desc,langid)
			s:SIDesc'="" Desc=Desc_"("_SIDesc_")"
			s $p(ICDSub,$c(2),2)=Desc
			s $P(ICDList,"!",ICDListInd)=ICDSub
		}
		
	}
	q ICDList
}

/// create 20230304 by yuanlei
/// desc:  判断患者Day天内是否存在在院记录
/// input: PatId(患者id), Day(判断天数)
/// output:Y(存在), N(不存在) 
ClassMethod CheckReAdmssion(PatId As %String, Day As %String = "15") As %String
{
	n (PatId, Day)
	s LastDisDate="", CurrDate=+$h
	s AdmId="" f {
		s AdmId=$o(^PAPERdr(PatId,"ADM","I",AdmId),-1)
		q:AdmId=""
		s VisitStatus=$p(^PAADM(AdmId),"^",20)
		s DisDate=$p(^PAADM(AdmId),"^",17)
		i VisitStatus="A" {
			;当前在院则取当前日期
			s LastDisDate=CurrDate
			q
		}
		i DisDate'="" {
			s LastDisDate=DisDate
			q
		}
	}
	if (LastDisDate'="")&&(CurrDate-LastDisDate'>Day) {
		q "Y"
	}
	q "N"
}

Storage Default
{
<Data name="DHCDocIPBookNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDocIPBookNewD</DataLocation>
<DefaultData>DHCDocIPBookNewDefaultData</DefaultData>
<IdLocation>^web.DHCDocIPBookNewD</IdLocation>
<IndexLocation>^web.DHCDocIPBookNewI</IndexLocation>
<StreamLocation>^web.DHCDocIPBookNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
