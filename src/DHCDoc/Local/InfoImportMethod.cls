Class DHCDoc.Local.InfoImportMethod Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DHCDoc.Local.InfoImportMethod).ImportPatInfoCache("","","","DEPZZ")
ClassMethod ImportPatInfoCache(BeginID As %String = "", UserInitials As %String, DataNameSpace As %String, PayModeCode As %String) As %String
{
	s CurrNameSpace=$NAMESPACE
	s CurrRunPID=$I(^TEMPgry("ImportPatInfo"))
	s ^TEMPgry("ImportPatInfo",CurrRunPID,"RunTime")=$ZD(+$H,3)_" "_..%ZT(..%SysTime())
	s (Count,SuCount,ErrCount)=0
	zn DataNameSpace
	i +BeginID'=0 s PatientID=BeginID-1
	else  s PatientID=0
	for {
		s PatientID=$O(^PAPER(PatientID))
		q:(PatientID="")
		Continue:'$D(^PAPER(PatientID,"ALL"))
		s Active=$P($G(^PAPER(PatientID,"PAT",1)),"^",6)
		s PatientNo=$P($G(^PAPER(PatientID,"PAT",1)),"^",1)
		continue:(Active="N")
		s Count=Count+1
		///先获取老库的数据内容
		zn CurrNameSpace
		s PatInfo=##Class(DHCDoc.Local.InfoImportMethod).GetPatInfoFromCurrCache(PatientID,DataNameSpace)
		s CardInfo=##Class(DHCDoc.Local.InfoImportMethod).GetCardInfoFromCurrCache(PatientID,DataNameSpace)
		
		s ret=##Class(DHCDoc.Local.InfoImportMethod).SavePatientInfo(PatInfo,CardInfo,UserInitials,PayModeCode)
		if (+ret'=0){
			s J=$I(^TEMPgry("ImportPatInfo",CurrRunPID,"Err"))
			s ^TEMPgry("ImportPatInfo",CurrRunPID,"Err",J)=ret
			s ErrCount=ErrCount+1
		}else{
			s SuCount=SuCount+1
		}
		
		zn DataNameSpace
		
	}
	zn CurrNameSpace
	w "成功数量:"_SuCount_",失败数量:"_ErrCount_",合计数量:"_Count,!
	q 0
}

/// w ##Class(DHCDoc.Local.InfoImportMethod).ImportPatInfoNotCache("DEMO","DEPZZ")
ClassMethod ImportPatInfoNotCache(UserInitials As %String, PayModeCode As %String) As %String
{
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserInitials),0))
	
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="D:\ImportPatInfo.txt"
	w !,"导入中...",!
	s CurrRunPID=$I(^TEMPgry("ImportPatInfo"))
	s ^TEMPgry("ImportPatInfo",CurrRunPID,"RunTime")=$ZD(+$H,3)_" "_..%ZT(..%SysTime())
	s (Count,SuCount,ErrCount)=0
	s ErrMsg=""
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s Count=Count+1
		s PatInfo=$P(line,"##########")
		s CardInfo=$P(line,"##########",2)
		s ret=##Class(DHCDoc.Local.InfoImportMethod).SavePatientInfo(PatInfo,CardInfo,UserInitials,PayModeCode)
		if (+ret'=0){
			s J=$I(^TEMPgry("ImportPatInfo",CurrRunPID,"Err"))
			s ^TEMPgry("ImportPatInfo",CurrRunPID,"Err",J)=ret
			s ErrCount=ErrCount+1
		}else{
			s SuCount=SuCount+1
		}
	}
	w "成功数量:"_SuCount_",失败数量:"_ErrCount_",合计数量:"_Count,!
	q 0
}

ClassMethod ImportAppInfo(UserInitials As %String) As %String
{
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserInitials),0))
	s CommonPatientID=##Class(web.DHCOPAdmReg).GetCommonPatientID()
	s CommonPatientID=$P(CommonPatientID,"^",1)
	/*
	//写日志文件
	Set file=##class(%File).%New("D:\ImportAppInfo.txt")
	set ExistsFlag=##class(%File).Exists("D:\ImportAppInfo.txt")
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	*/
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename="D:\ImportAppInfo.txt"
	w !,"导入中...",!
	s CurrRunPID=$I(^TEMPgry("ImportAppInfo"))
	s ^TEMPgry("ImportAppInfo",CurrRunPID,"RunTime")=$ZD(+$H,3)_" "_..%ZT(..%SysTime())
	s (Count,SuCount,ErrCount)=0
	s ErrMsg=""
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		s Count=Count+1
		Kill AppList
		for i=1:1:$l(line,"^") {
			Set AppList(i)=$p(line,"^",i)
		}
		s LocCode=AppList(1)			;科室代码
		s CTPCPCode=AppList(2)			;号别代码
		s ApptDate=AppList(3)           ;预约日期
		s TRCode=AppList(4)             ;时段代码
		s PatientNo=AppList(5)          ;登记号
		s Name=AppList(6)				;姓名
		s TelH=AppList(7)				;联系电话
		s DVANumber=AppList(8)			;身份证号码
		s CreatAdm=AppList(9)			;是否生成就诊
		s SeqNo=AppList(10)				;就诊序号
		s TRTimeRange=AppList(11)		;就诊分时段信息
		s MethodCode=AppList(12)		;预约方式代码
		if (LocCode="")
			||(CTPCPCode="")
			||(ApptDate="")
			||(TRCode="")
			||(CreatAdm="")
			||((PatientNo="")&&((Name="")||(TelH="")||(DVANumber=""))
			||(MethodCode="")
		){
			d RecordErrMsg("数据不完整，请核对:"_line)
			continue
		}
		s LocDr=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0))
		s CTPCPDr=$O(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CTPCPCode),0))
		s TimeRangeDr=""
		s i=0
		for {
			s i=$O(^DHCTimeRange(i))
			q:(i="")
			if (TRCode=$P(^DHCTimeRange(i),"^",1)){
				s TimeRangeDr=i
				q
			}
		}
		if (LocDr=""){
			d RecordErrMsg("科室信息无效，请核对:"_line)
			continue
		}
		if (CTPCPDr=""){
			d RecordErrMsg("号别信息无效，请核对:"_line)
			continue
		}
		if (TimeRangeDr=""){
			d RecordErrMsg("出诊时段信息无效，请核对:"_line)
			continue
		}
		if (ApptDate'["-"){
			d RecordErrMsg("出诊日期格式不正确，请核对:"_line)
			continue
		}
		s ASDate=$ZDH(ApptDate,3)
		s ASChildSub=""
		s ResRowId=0
		for {
			s ResRowId=$O(^RB("RES",0,"CTPCP",CTPCPDr,LocDr,ResRowId))
			q:(ResRowId="")
			s TmpASChildsub=0
			for {
				s TmpASChildsub=$O(^RBAS(ResRowId,0,"DateTR",ASDate,TimeRangeDr,TmpASChildsub))
				q:(TmpASChildsub="")
				s status=$P($G(^RBAS(ResRowId,TmpASChildsub,"DHC")),"^",10)
				i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
				continue:(status="S")||(status="TR")||(status="PS")
				s ASChildSub=TmpASChildsub
				q:(ASChildSub'="")
			}
			q:(ASChildSub'="")
		}
		if (+ASChildSub=0)||(+ResRowId=0){
			d RecordErrMsg("未找到有效的排班，请核对:"_line)
			continue
		}
		s ASRowId=ResRowId_"||"_ASChildSub
		s PatientID=""
		if (PatientNo'=""){
			s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
			if (PatientID=""){
				d RecordErrMsg("登记号信息无效，请核对:"_line)
				continue
			}
		}
		if (CreatAdm="Y")&&(PatientID=""){
			d RecordErrMsg("创建就诊时，患者登记号必须有效，请核对:"_line)
			continue
		}
		if (PatientID=""){
			
			if (CommonPatientID=""){
				d RecordErrMsg("未维护有效的公共卡")
				continue
			}
			s PatientID=CommonPatientID
		}
		s AppPatInfo=Name_"$"_DVANumber_"$"_TelH
		TS
		s ret=##class(web.DHCOPAdmReg).OPAppBroker("","",PatientID , ASRowId , SeqNo, UserID,AppPatInfo, MethodCode)
		if (+ret'=0){
			TRO
			d RecordErrMsg("导入预约记录失败，代码:"_ret_",请核对:"_line)
			continue
		}
		s ApptRowID=$P(ret,"^",2)
		s QueueNo=$P(ret,"^",3)
		if (CreatAdm="Y"){
			;插入就诊记录
			s ret=..CreatAdm(ApptRowID,UserID)
			if (+ret'=0){
				TRO
				d RecordErrMsg("插入就诊记录失败，代码:"_ret_",请核对:"_line)
				continue
			}
		}
		TC
		s SuCount=SuCount+1
		w "成功",!
	}
	w "成功数量:"_SuCount_",失败数量:"_ErrCount_",合计数量:"_Count,!
	q 0
RecordErrMsg(Msg)
	w Msg,!
	s ErrCount=ErrCount+1
	s Index=$O(^TEMPgry("ImportAppInfo",CurrRunPID,"Err"))
	s ^TEMPgry("ImportAppInfo",CurrRunPID,"Err",Index)=Msg
	q
}

ClassMethod CreatAdm(APPTRowId As %String, UserID As %String) As %String
{
	s RBASRowId=$P(APPTRowId,"||",1,2)
	s ResRowId=+RBASRowId
	s ASChild=$P(RBASRowId,"||",2)
	s AdmDep=$P($G(^RB("RES",ResRowId)),"^",1)
	s AdmDoc=$P($G(^RB("RES",ResRowId)),"^",2)
	s ASStartTime=$P($G(^RBAS(ResRowId,ASChild)),"^",4) 
	s RoomDr=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",5)
	s SessionTypeDr=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",6)
	s RegfeeTimeRangeDr=$P($G(^RBAS(ResRowId,ASChild,"DHC")),"^",17)
	s AdmDate=$p($g(^RBAS(+APPTRowId,+$p(APPTRowId,"||",2))),"^")
	s AdmTime=..%SysTime()
	
	s user=UserID
	s group=$P(^SSU("SSUSR",UserID),"^",5)
	s CreateUser=UserID
	s AdmType="O"
	if AdmType'="E" {
		s IsEmergency=##Class(web.DHCOPAdmReg).IsEmergency(AdmDep)
		if IsEmergency="1" s AdmType="E"
	}
	s PatientID=$P(^RBAS(ResRowId,ASChild,"APPT",$P(APPTRowId,"||",3)),"^",2)
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	s AdmReason=##Class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s QueueNo=$P(^RBAS(ResRowId,ASChild,"APPT",$P(APPTRowId,"||",3)),"^",5)
	s DiagnosCatRowId=""
	s InsuCoDR=""
	s PatAdmissionTp=##Class(web.DHCOPAdmReg).GetPatAdmissionTp(RBASRowId)
	s RegConDisIdPara=PatientID_"^"_RBASRowId_"^"_AdmReason_"^"_""
	s RegConDisId=##Class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	s Para=PatientID_"^"_AdmType_"^"_AdmDate_"^"_AdmTime_"^"_AdmDep_"^"_AdmDoc_"^"_AdmReason_"^"_CreateUser_"^^^^"_PatAdmissionTp_"^^^"_DiagnosCatRowId_"^^^^^"_InsuCoDR_"^"_RegConDisId
	TStart
	s EpisodeID=##class(web.DHCPAADM).ADMInsert(Para)
	i EpisodeID'="" {
	    s err=##Class(web.DHCRBAppointment).AppArrive(APPTRowId,EpisodeID,UserID)
	    i err'=0 {
		    TRollback
			Q "-1^预约取号失败:"_err
	    }
    }else{
		TRollback
		Q "-1^插入就诊记录失败:"_EpisodeID  
	}
	s Fee=0
	s examfee=0
	s InvoiceRowid=""
	
	s CurrDate=..%SysDate(),CurrTime=..%SysTime()
	;s RegfeeTimeRangeDr=##class(web.DHCRBResSession).GetTimeRangeByTime(ASStartTime)
	;插入挂号表 DHCRegistrationFee
	&SQL(insert into SQLUser.DHCRegistrationFee
		(RegfeeAdmDr,RegfeeName,RegfeeArcDr,RegfeeArcPrice,RegfeelookPrice,
		RegfeeBespFlag,RegfeeNo,RegfeeDoFlag,Regfeetemp1,RegfeeDepDr,RegfeeDocDr,
		RegfeeDate,RegfeeTime,RegfeeUserDr,RegfeeSessionTypeDr,RegfeeTimeRangeDr,
		RegfeeRoomDr,RegfeeRBASDr)
		Values(:EpisodeID,:Name,"",:Fee,:examfee,
		'No',:QueueNo,'Yes',:InvoiceRowid,:AdmDep,:AdmDoc,
		:CurrDate,:CurrTime,:user,:SessionTypeDr,:RegfeeTimeRangeDr,:RoomDr,:RBASRowId))
	if SQLCODE {
		TRollback
		Q "-1^插入挂号费用表失败:"_SQLCODE
	}
	s RegfeeRowId=%ROWID
	;插入队列 DHCQueue
	s Para=EpisodeID_"^"_RoomDr_"^"_QueueNo_"^"_user
	s ret=##Class(web.DHCOPAdmReg).QueueInsert(Para)
	if ret {
		TRollback
		Q "-1^插入队列表失败:"_ret
	}
	TC
	q 0
}

/// 从当前命名空间获取病人基本信息串
/// w ##Class(DHCDoc.Local.InfoImportMethod).GetPatInfoFromCurrCache(711)
ClassMethod GetPatInfoFromCurrCache(PatientID As %String, DNameSpace As %String) As %String
{
	s CurrNameSpace=$NAMESPACE
	zn DNameSpace
	//登记号
	s PatientNo=$P($G(^PAPER(PatientID,"PAT",1)),"^",1)
	//paper_dob  生日
	s Dob=$P($G(^PAPER(PatientID,"ALL")),"^",6)
	//paper_name 姓名
	s Name=$P($G(^PAPER(PatientID,"ALL")),"^",1)
	//paper_sex_dr 性别
	s SexDR=$P($G(^PAPER(PatientID,"ALL")),"^",7)
	//语言 paper_langprim_dr
	s LangPrimDR=$P($G(^PAPER(PatientID,"ALL")),"^",10)
	//民族 paper_nation_dr
	s NationDR=$P($G(^PAPER(PatientID,"PER",2)),"^",1)
	//宗教 paper_religion_dr 
	s ReligionDR=$P($G(^PAPER(PatientID,"PER",2)),"^",2)

	//婚姻 paper_marital_dr
	s MaritalDR=$P($G(^PAPER(PatientID,"PER",2)),"^",3)
	//学历关联 paper_education_dr
	s EducationDR=$P($G(^PAPER(PatientID,"PER",2)),"^",5)
	//病人类型 paper_socialstatus_dr
	s SocialStatus=$P($G(^PAPER(PatientID,"PER",1)),"^",10)
	//血型 PAPER_BloodType_DR
	s BloodTypeDR=$P($G(^PAPER(PatientID,"PER",5)),"^",32)
	//邮编 paper_zip_dr
	s ZipDr=$P($G(^PAPER(PatientID,"PER",1)),"^",7)
	//家庭电话 paper_telh
	s TelH=$P($G(^PAPER(PatientID,"PER",1)),"^",11)
	//手机号
	s MobPhone=$P($G(^PAPER(PatientID,"PER",4)),"^",21)
	//单位电话 paper_telo
	s TelO=$P($G(^PAPER(PatientID,"PER",1)),"^",9)
	//工作单位
	s Company=$P($G(^PAPER(PatientID,"PER",4)),"^",18)
	//单位地址 PAPER_NokAddress2
	s NokAddress2=$P($G(^PAPER(PatientID,"NOK")),"^",8)
	//身份证号 paper_id
	s PAPERID=$P($G(^PAPER(PatientID,"ALL")),"^",9)
	s PAPERID=$TR(PAPERID," ","")
	s PAPERID=$TR(PAPERID,$C(1),"")
	///证件号
	s DVANumber=$P($G(^PAPER(PatientID,"PAT",3)),"^",6)
	
	//证件类型
	s PatDocType=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	//s PatYBCode=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)
	s PatYBCode=$P($G(^PAPER(PatientID,"ALL")),"^",19)
	//病案号
	s InMedicare=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
	//s InMedicare=$G(^PAPER(PatientID,"Temp","MrNo"))
	/*
	//这里无法直接调用病案组方法，建议另行运行方法，把病案号写入到患者信息扩展节点，示例程序如下
	s PatientID=""
	for {
		s PatientID=$O(^PAPER(PatientID))
		q:(PatientID="")
		Continue:'$D(^PAPER(PatientID,"ALL"))
		s MrNo=##class(web.DHCDocOrderCommon).GetMrNo("",PatientID,"I",$O(^CT("HOSP",0)))
		continue:(MrNo="")
		s ^PAPER(PatientID,"Temp","MrNo")=MrNo
	}
	*/
	
	s ForeignName=$P($G(^PAPER(PatientID,"PER",2)),"^",13)
	/// 联系人证件类型
	s ForeignCredTypeDr=$P($G(^PAPER(PatientID,"ALL")),"^",25)
	/// 联系人身份正号
	s ForeignIDCard=$P($G(^PAPER(PatientID,"PER",2)),"^",4)
	/// 联系人电话
	s ForeignPhone=$P($G(^PAPER(PatientID,"ALL")),"^",4)
	//住址信息
	s Address=$G(^PAPER(PatientID,"PER","ADD",1))
	//国家 paper_country_dr 
	s CountryDR=$P($G(^PAPER(PatientID,"PER",1)),"^",8)
	//省 paper_ct_province_dr 
	s CTProvince=$P($G(^PAPER(PatientID,"PER",4)),"^",2)
	//城市 paper_citycode_dr
	s CityCodeDR=$P($G(^PAPER(PatientID,"PER",1)),"^",5)
	//现住址区县 PAPER_CityArea_DR
	s CityAreaDR=$P($G(^PAPER(PatientID,"PER",4)),"^",9)
	//籍贯省 PAPER_Province_Birth_DR
	s ProvinceBirthDR=$P($G(^PAPER(PatientID,"PER",2)),"^",11)
	//籍贯市 PAPER_CityBirth_DR
	s CityBirthDR=$P($G(^PAPER(PatientID,"ALL")),"^",18)

	s DHCPatientID=$O(^DHCPERSON(0,"PAPERSON",PatientID,0))
	s (BirthProvince,BirthCity,BirthArea)=""
	i DHCPatientID'="" {
		//出生省PAPER_BirthProvince_DR
		s BirthProvince=$p(^DHCPERSON(DHCPatientID),"^",13)
		//出生市PAPER_BirthCity_DR
		s BirthCity=$p(^DHCPERSON(DHCPatientID),"^",14)
		//出生区县PAPER_BirthArea_dr
		s BirthArea=$p(^DHCPERSON(DHCPatientID),"^",15)
	}
	s (SexDesc,LangPrimDesc,NationDesc,MaritalDesc,CredTypeDesc,BloodTypeDesc,EducationDesc,ZipDesc)=""
	s (ForeignCredTypeDr,ForeignCredTypeDesc,Religiondesc,CountryDesc,CTProvinceDesc,CityCodeDesc,CityAreaDesc)=""
	s (ProvinceBirthDesc,CityBirthDesc)=""
	s (BirthProvinceDesc,BirthCityDesc,BirthAreaDesc)=""

	s:SexDR'="" SexDesc=$P($G(^CT("SEX",SexDR)),"^",2)
	s SexDesc=$CASE(SexDesc,"不详":"未说明性别","未知":"未知性别",:SexDesc)
	s:(LangPrimDR'="") LangPrimDesc=$P(^SS("LAN",LangPrimDR),"^",2)
	s:(EducationDR'="") EducationDesc=$P(^CT("EDU",EducationDR),"^",2)
	s:NationDR'="" NationDesc=$P($G(^CT("NAT",NationDR)),"^",2)
	i NationDesc["-" s NationDesc=$P(NationDesc,"-",2)
	s:(SocialStatus'="") SocialStatus=$P(^CT("SS",SocialStatus),"^",2)
	s:(BloodTypeDR'="") BloodTypeDesc=$P(^PAC("BLDT",BloodTypeDR),"^",2)
	s:MaritalDR'="" MaritalDesc=$P($G(^CT("MAR",MaritalDR)),"^",2)
	s:PatDocType'="" CredTypeDesc=$P($G(^PAC("CARD",PatDocType)),"^",2)
	s:ForeignCredTypeDr'="" ForeignCredTypeDesc=$P($G(^PAC("CARD",ForeignCredTypeDr)),"^",2)
	s:ZipDr'="" ZipDesc=$P($G(^CT("ZIP",ZipDr)),"^",2)
	s:ReligionDR'="" Religiondesc=$p($G(^CT("RLG",ReligionDR)),"^",2)
	s:CountryDR'="" CountryDesc=$P($G(^CT("COU",CountryDR)),"^",2)
	s:CTProvince'="" CTProvinceDesc=$P($G(^CT("PROV",CTProvince)),"^",2)
	s:CityCodeDR'="" CityCodeDesc=$P($G(^CT("CIT",CityCodeDR)),"^",2)
	s:CityAreaDR'="" CityAreaDesc=$P($G(^CT("CITAREA",CityAreaDR)),"^",2)
	s:ProvinceBirthDR'="" ProvinceBirthDesc=$P($G(^CT("PROV",ProvinceBirthDR)),"^",2)
	s:CityBirthDR'="" CityBirthDesc=$P($G(^CT("CIT",CityBirthDR)),"^",2)

	s:CountryDesc["-" CountryDesc=$P(CountryDesc,"-",2)
	s:CTProvinceDesc["-" CTProvinceDesc=$P(CTProvinceDesc,"-",2)
	s:CityCodeDesc["-" CityCodeDesc=$P(CityCodeDesc,"-",2)
	s:CityAreaDesc["-" CityAreaDesc=$P(CityAreaDesc,"-",2)
	s:ProvinceBirthDesc["-" ProvinceBirthDesc=$P(ProvinceBirthDesc,"-",2)
	s:CityBirthDesc["-" CityBirthDesc=$P(CityBirthDesc,"-",2)


	s:BirthProvince'="" BirthProvinceDesc=$P($G(^CT("PROV",BirthProvince)),"^",2)
	s:BirthCity'="" BirthCityDesc=$P($G(^CT("CIT",BirthCity)),"^",2)
	s:BirthArea'="" BirthAreaDesc=$P($G(^CT("CITAREA",BirthArea)),"^",2)
	s:BirthProvinceDesc["-" BirthProvinceDesc=$P(BirthProvinceDesc,"-",2)
	s:BirthCityDesc["-" BirthCityDesc=$P(BirthCityDesc,"-",2)
	s:BirthAreaDesc["-" BirthAreaDesc=$P(BirthAreaDesc,"-",2)
	s left=0
	s myAccRowID=0
	for {
		s myAccRowID=$o(^DHCACDi("AccM",0,"PAPMI",PatientID,myAccRowID))
		q:((myAccRowID=""))
	
		continue:($d(^DHCACD("AccM",myAccRowID))=10)
		s myAccStatus=$p(^DHCACD("AccM",myAccRowID),"^",13)		;AccM_AccStatus
		s myCardNo=$p(^DHCACD("AccM",myAccRowID),"^",4)			;AccM_CardNo
		continue:(myAccStatus'="N")
		s myCFRowID=0
		s myFNCardFlag=0
		f  {
			s myCFRowID=$o(^DHCCARDi("CF",0,"AccNoDR",myAccRowID, myCFRowID))
			q:((myCFRowID="")!(+myFNCardFlag=1))
			s myCardNo=$p(^DHCCARD("CF",myCFRowID),"^",2)
			s myCardActF=$p(^DHCCARD("CF",myCFRowID),"^",10)
			continue:myCardActF'="N"
		}
		s Balance=$p(^DHCACD("AccM",myAccRowID),"^",8)
		s DepPrice=+($p($g(^DHCACD("AccM",myAccRowID)),"^",14))
		s left=Balance-DepPrice
	}
	//住院次数 PA_Person->PAPER_ExemptionNumber
	s AdmTimes=+$p($g(^PAPER(PatientID,"PER",4)),"^",8)
	
	zn CurrNameSpace
	s PatInfo=PatientID_"^"_PatientNo_"^"_Name_"^"_SexDesc_"^"_$ZD(Dob,3)
	s PatInfo=PatInfo_"^"_LangPrimDesc_"^"_NationDesc_"^"_Religiondesc_"^"_MaritalDesc_"^"_EducationDesc
	s PatInfo=PatInfo_"^"_SocialStatus_"^"_BloodTypeDesc_"^"_ZipDesc_"^"_TelH_"^"_TelO
	s PatInfo=PatInfo_"^"_MobPhone_"^"_Company_"^"_PAPERID_"^"_AdmTimes_"^"
	s PatInfo=PatInfo_"^"_"^"_"^"_"^"_"^"
	s PatInfo=PatInfo_"^"_Address_"^"_CredTypeDesc_"^"_DVANumber_"^"_ForeignName_"^"_ForeignCredTypeDesc
	s PatInfo=PatInfo_"^"_ForeignIDCard_"^"_ForeignPhone_"^"_PatYBCode_"^"_InMedicare_"^"_CountryDesc
	;现住省、市、区，出生省、市
	s PatInfo=PatInfo_"^"_CTProvinceDesc_"^"_CityCodeDesc_"^"_CityAreaDesc_"^"_BirthProvinceDesc_"^"_BirthCityDesc
	;出生区，籍贯省、市、区，
	s PatInfo=PatInfo_"^"_BirthAreaDesc_"^"_ProvinceBirthDesc_"^"_CityBirthDesc_"^"_"^"_left
	q PatInfo
}

ClassMethod GetCardInfoFromCurrCache(PatientID As %String, DNameSpace As %String) As %String
{
	s CurrNameSpace=$NAMESPACE
	zn DNameSpace
	s CardInfo=""
	s CFRowID=0
	for {
		s CFRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CFRowID))
		q:(CFRowID="")
		s ActiveFlag=$P(^DHCCARD("CF",CFRowID),"^",10) 
		if (ActiveFlag'="N") {
			continue
		}
		s CardTypeDR=$P(^DHCCARD("CF",CFRowID),"^",16)
		if (CardTypeDR=""){
			continue
		}
		s CardTypeCode=$P(^DHCCARDTYPEDef(CardTypeDR),"^",1)
		s CardNo=$P(^DHCCARD("CF",CFRowID),"^",2)
		s CardINVPRTDR=$P(^DHCCARD("CF",CFRowID),"^",17)
		s FareType=$p($g(^DHCCARDTYPEDef(CardTypeDR)),"^",3)
		s CardInvFee=0
		//if (FareType="C")&&(CardINVPRTDR'=""){
		if (CardINVPRTDR'=""){
			s CIPFlag=$P($G(^DHCCARDINVPRT(CardINVPRTDR)),"^",2)
			if (CIPFlag'="N"){
				s CIPFee=$P($G(^DHCCARDINVPRT(CardINVPRTDR)),"^",3)
				s CardInvFee=CardInvFee+CIPFee
			}
		}
		s SecurityNo=$p(^DHCCARD("CF",CFRowID),"^",3)
		s SecurityNo=##class(web.UDHCAccEnrypt).Decrypt(SecurityNo)
		
		if (CardInfo=""){
			s CardInfo=CardTypeCode_"^"_CardNo_"^"_SecurityNo_"^"_CardInvFee
		}else{
			s CardInfo=CardInfo_"$"_CardTypeCode_"^"_CardNo_"^"_SecurityNo_"^"_CardInvFee
		}
	}
	zn CurrNameSpace
	
	q CardInfo
}

ClassMethod SavePatientInfo(PatInfo As %String, CardInfo As %String, UserInitials As %String, PayModeCode As %String) As %String
{
	s $ZT="SavePatientInfoErr"
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserInitials),0))
	s PayMode=$O(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4(PayModeCode),0))
	
	s SerialsNo=$P(PatInfo,"^",1)			//流水号或PatientID
	s PatientNo=$P(PatInfo,"^",2)			//登记号
	s Name=$P(PatInfo,"^",3)				//姓名
	s SexDesc=$P(PatInfo,"^",4)				//性别
	s Dob=$P(PatInfo,"^",5)					//出生日期
	s LangPrimDesc=$P(PatInfo,"^",6)		//语言
	s NationDesc=$P(PatInfo,"^",7)			//民族
	s Religiondesc=$P(PatInfo,"^",8)		//宗教
	s MaritalDesc=$P(PatInfo,"^",9)			//婚姻
	s EducationDesc=$P(PatInfo,"^",10)		//教育
	s SocialStatus=$P(PatInfo,"^",11)		//社会地位
	s BloodTypeDesc=$P(PatInfo,"^",12)		//血型
	s ZipDesc=$P(PatInfo,"^",13)			//邮编
	s TelH=$P(PatInfo,"^",14)				//联系电话
	s TelO=$P(PatInfo,"^",15)				//单位电话
	s MobPhone=$P(PatInfo,"^",16)			//个人电话
	s Company=$P(PatInfo,"^",17)			//工作单位
	s PAPERID=$P(PatInfo,"^",18)			//身份证号
	s AdmTimes=$P(PatInfo,"^",19)			//住院次数
	
	s Space=$P(PatInfo,"^",20)				//预留
	s Space=$P(PatInfo,"^",21)				//预留
	s Space=$P(PatInfo,"^",22)				//预留
	s Space=$P(PatInfo,"^",23)				//预留
	s Space=$P(PatInfo,"^",24)				//预留
	s Space=$P(PatInfo,"^",25)				//预留
	s Address=$P(PatInfo,"^",26)			//住址
	s CredTypeDesc=$P(PatInfo,"^",27)		//证件类型
	s CredNo=$P(PatInfo,"^",28)				//证件号
	s ForeignName=$P(PatInfo,"^",29)		//联系人姓名
	s ForeignCredTypeDesc=$P(PatInfo,"^",30)	//联系人证件类型
	s ForeignIDCard=$P(PatInfo,"^",31)		//联系人证件号
	s ForeignPhone=$P(PatInfo,"^",32)		//联系人联系方式
	s PatYBCode=$P(PatInfo,"^",33)			//个人医保卡号
	s InMedicare=$P(PatInfo,"^",34)			//病案号
	s CountryDesc=$P(PatInfo,"^",35)		//国籍
	s CTProvinceDesc=$P(PatInfo,"^",36)		//现住省
	s CityCodeDesc=$P(PatInfo,"^",37)		//现住市
	s CityAreaDesc=$P(PatInfo,"^",38)		//现住区
	s BirthProvinceDesc=$P(PatInfo,"^",39)	//出生省
	s BirthCityDesc=$P(PatInfo,"^",40)		//出生市
	s BirthAreaDesc=$P(PatInfo,"^",41)		//出生区
	s ProvinceBirthDesc=$P(PatInfo,"^",42)	//籍贯省
	s CityBirthDesc=$P(PatInfo,"^",43)		//籍贯市
	s AreaBirthDesc=$P(PatInfo,"^",44)		//籍贯区
	s left=$P(PatInfo,"^",45)				//院内账户余额
	
	s myPatLen=+$p(^CF("PATCF",1,3),"^",5)
	s PatientNo=$e("0000000000000000000",1,myPatLen-$l(PatientNo))_PatientNo
	
	s PatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
	s PatObj.PAPMINo=PatientNo
	i $zu(28,Name,6)="" s Name="无"
	s Name=$TR(Name,"-","")
	s Name=$TR(Name,"  ","")
	if (Name=""){
		q "-1^流水号"_SerialsNo_"姓名必填"
	}
	s PatObj.Name=Name
	/// 性别			
	s SexDR=""
	i (SexDesc'=""){
		s SexDR=$O(^CT("SEX",0,"Desc",$$ALPHAUP^SSUTIL4(SexDesc),0))
	}
	if (SexDR=""){
		q "-1^流水号"_SerialsNo_"性别必填"
	}
	s PatObj.Sex=SexDR
	/// 出生日期
	if (Dob=""){
		q "-1^流水号"_SerialsNo_"出生日期必填"
	}
	s PatObj.Birth=Dob
	/*
	s PatObj.Language=LangPrimDR
	s PatObj.ReligionDR=ReligionDR
	*/
	/// 民族 ^SS("LAN",
	s NationDR=""
	i (NationDesc'=""){
		s NationDesc="%"_NationDesc_"%"
		&SQL(SELECT CTNAT_RowId into:NationDR FROM SQLUser.CT_Nation WHERE CTNAT_Desc LIKE :NationDesc)
		if (SQLCODE'=0){
			s NationDR=$O(^CT("NAT",0,"Desc","汉族",0))
		}
	}
	s PatObj.NationDescLookUpRowID=NationDR
	/// 婚姻状况
	s MaritalDR=""
	s:(MaritalDesc'="") MaritalDR=$O(^CT("MAR",0,"Desc",$$ALPHAUP^SSUTIL4(MaritalDesc),0))
	s PatObj.PAPERMarital=MaritalDR
	//学历关联 ^CT("EDU",35)
	//s PatObj.Education=EducationDR
	/// 患者类别， 患者的Social(患者类型)  // ^CT("SS"
	s SocialStatusDr=""
	s:(SocialStatus'="") SocialStatusDr=$O(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(SocialStatus),0))
	i SocialStatusDr="" s SocialStatusDr=$O(^CT("SS",0))
	if (SocialStatusDr=""){
		q "-1^流水号"_SerialsNo_"社会地位必填"
	}
	s PatObj.PatType=SocialStatusDr
	/// 血型  ^PAC("BLDT")
	//s PatObj.BloodType=BloodTypeDR
	/// 代码表邮编 dhc_person.PAPER_Zip_DR
	s ZipLookUpRowID=""
	s:(ZipDesc'="") ZipLookUpRowID=$O(^CT("ZIP",0,"Desc",$$ALPHAUP^SSUTIL4(ZipDesc),0))
	s PatObj.PostCode=ZipLookUpRowID
	/// 家庭电话
	if (TelH=""){
		q "-1^流水号"_SerialsNo_"TelH必填"
	}
	s PatObj.TelHome=TelH
	/// 办公室电话/ 单位电话
	s PatObj.TelOffice=TelO
	/// 手机号
	s PatObj.MobPhone=MobPhone
	/// 工作单位
	s PatObj.Company=Company
	/// 住址
	s PatObj.Address=Address
	/// 证件类型
	s CredTypeDr=""
	s:CredTypeDesc'="" CredTypeDr=$O(^PAC("CARD",0,"Desc",$$ALPHAUP^SSUTIL4(CredTypeDesc),0))
	s PatObj.CredType=CredTypeDr
	/// 证件号码  对应于 PAPATMas表的PAPMI_DVAnumber字段
	s PatObj.CredNo=CredNo
	/// 身份证号
	s PatObj.IDCardNo1=PAPERID
	/// 联系人地址
	s PatObj.ForeignName=ForeignName
	/// 联系人电话
	s PatObj.ForeignPhone=ForeignPhone
	/// 联系人证件类型
	s ForeignCredTypeDr=""
	s:ForeignCredTypeDesc'="" ForeignCredTypeDr=$O(^PAC("CARD",0,"Desc",$$ALPHAUP^SSUTIL4(ForeignCredTypeDesc),0))
	s PatObj.ForeignCredType=ForeignCredTypeDr
	/// 联系人身份正号
	s PatObj.ForeignIDCard=ForeignIDCard
	/// 医保号
	s PatObj.PatYBCode=PatYBCode
	///病案号  PAPMIMedicare
	s PatObj.InMedicare=InMedicare
	/// 国籍
	s CountryDescLookUpRowID=""
	s:CountryDesc'="" CountryDescLookUpRowID=$O(^CT("COU",0,"Desc",$$ALPHAUP^SSUTIL4(CountryDesc),0))
	;&SQL(SELECT CTCOU_RowId into :CountryDescLookUpRowID FROM SQLUser.CT_Country WHERE CTCOU_Desc %STARTSWITH :CountryDesc)
	s PatObj.CountryDescLookUpRowID=CountryDescLookUpRowID
	/// 省份(现住)
	s ProvinceInfoLookUpRowID=""
	s:CTProvinceDesc'="" ProvinceInfoLookUpRowID=$O(^CT("PROV",0,"Desc",$$ALPHAUP^SSUTIL4(CTProvinceDesc),0))
	;&SQL(SELECT PROV_RowId into :ProvinceInfoLookUpRowID FROM SQLUser.CT_Province WHERE PROV_Desc %STARTSWITH :CTProvinceDesc)
	s PatObj.ProvinceInfoLookUpRowID=ProvinceInfoLookUpRowID
	/// 市（现住）
	s CityDescLookUpRowID=""
	s:CityCodeDesc'="" CityDescLookUpRowID=$O(^CT("CIT",0,"Desc",$$ALPHAUP^SSUTIL4(CityCodeDesc),0))
	;&SQL(SELECT CTCIT_RowId into :CityDescLookUpRowID FROM SQLUser.CT_City WHERE CTCIT_Desc %STARTSWITH :CityCodeDesc)
	s PatObj.CityDescLookUpRowID=CityDescLookUpRowID
	
	/// 区（现住）
	s CityAreaLookUpRowID=""
	s:CityAreaDesc'="" CityAreaLookUpRowID=$O(^CT("CITAREA",0,"Desc",$$ALPHAUP^SSUTIL4(CityAreaDesc),0))
	;&SQL(SELECT CITAREA_RowId into :CityAreaLookUpRowID FROM SQLUser.CT_CityArea WHERE CITAREA_Desc %STARTSWITH :CityAreaDesc)
	s PatObj.CityAreaLookUpRowID=CityAreaLookUpRowID
	
	/// 省份(出生)
	s ProvinceBirth=""
	s:BirthProvinceDesc'="" ProvinceBirth=$O(^CT("PROV",0,"Desc",$$ALPHAUP^SSUTIL4(BirthProvinceDesc),0))
	;&SQL(SELECT PROV_RowId into :ProvinceBirth FROM SQLUser.CT_Province WHERE PROV_Desc %STARTSWITH :BirthProvinceDesc)
	s PatObj.ProvinceBirth=ProvinceBirth
	/// 市（出生）
	s CityBirth=""
	s:BirthCityDesc'="" CityBirth=$O(^CT("CIT",0,"Desc",$$ALPHAUP^SSUTIL4(BirthCityDesc),0))
	;&SQL(SELECT CTCIT_RowId into :CityBirth FROM SQLUser.CT_City WHERE CTCIT_Desc %STARTSWITH :BirthCityDesc)
	s PatObj.CityBirth=CityBirth
	/// 区（出生）
	s AreaBirth=""
	s:BirthAreaDesc'="" AreaBirth=$O(^CT("CITAREA",0,"Desc",$$ALPHAUP^SSUTIL4(BirthAreaDesc),0))
	;&SQL(SELECT CITAREA_RowId into :AreaBirth FROM SQLUser.CT_CityArea WHERE CITAREA_Desc %STARTSWITH :BirthAreaDesc)
	s PatObj.AreaBirth=AreaBirth
	
	/// 省(籍贯)
	s ProvinceHome=""
	s:ProvinceBirthDesc'="" ProvinceHome=$O(^CT("PROV",0,"Desc",$$ALPHAUP^SSUTIL4(ProvinceBirthDesc),0))
	;&SQL(SELECT PROV_RowId into :ProvinceHome FROM SQLUser.CT_Province WHERE PROV_Desc %STARTSWITH :ProvinceBirthDesc)
	s PatObj.ProvinceHome=ProvinceHome
	// 市(籍贯)
	s CityHome=""
	s:CityBirthDesc'="" CityHome=$O(^CT("CIT",0,"Desc",$$ALPHAUP^SSUTIL4(CityBirthDesc),0))
	;&SQL(SELECT CTCIT_RowId into :CityHome FROM SQLUser.CT_City WHERE CTCIT_Desc %STARTSWITH :CityBirthDesc)
	s PatObj.CityHome=CityHome
	
	/// 操作用户
	s PatObj.UserDR=UserID
	/// 更新日期
	s PatObj.UpdateDate=..%SysDate()
	/// 更新时间
	s PatObj.UpdateTime=+$P($H,"^",2)
	/// 操作用户
	s PatObj.UserDR=""
	d PatObj.XMLExportToString(.PaPatInfo,"PATMAS")
	
	//-------------卡片信息
	s CardTypeID="",CardInvFee=0,SecurityNo="",CardNo=""
	s CardObj=##class(web.DHCEntity.PCA.CardRef).%New()
	if (CardInfo'=""){
		s CardTypeCode=$P($P(CardInfo,"$"),"^",1)
		s CardNo=$P($P(CardInfo,"$"),"^",2)
		s SecurityNo=$P($P(CardInfo,"$"),"^",3)
		s CardInvFee=$P($P(CardInfo,"$"),"^",4)
		s CardTypeID=..GetCardTypeID(CardTypeCode)
		if (CardNo'="")&&(CardTypeID'=""){
			s CardObj.ActiveFlag="N"
			s CardObj.CardNo=CardNo
			s CardObj.CardTypeDefine=CardTypeID
			s CardObj.ComputerIP=""
			s CardObj.CredNo=PAPERID
			s CardObj.UserDR=UserID
			s CardObj.SecurityNo=SecurityNo
		}
	}
	s SaveCardInfo=""
	d CardObj.XMLExportToString(.SaveCardInfo,"CardRef")
	
	//-------------卡片消费信息
	s CardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
	s CardINVObj.CardFareCost=CardInvFee
	s CardINVObj.PayMode=PayMode
	s CardINVObj.UserDR=UserID
	s CardINVInfo=""
	d CardINVObj.XMLExportToString(.CardINVInfo,"CardINVPRT")
	//-------------配置信息
	s ConfigObj=##class(web.DHCEntity.PCA.CardTypeConfig).%New()
	s myCardRegConfig=##class(web.DHCBL.CARD.CardPATRegConfig).GetCardPatRegConfig()
	s ConfigObj.AccManageFLag=$p(myCardRegConfig, "^", 6)
	s ConfigObj.CardRefFlag=$p(myCardRegConfig, "^", 5)
	s ConfigObj.PatMasFlag=$p(myCardRegConfig, "^", 4)
	
	if (CardTypeID'=""){
		s CardTypeObj=##class(User.DHCCardTypeDef).%OpenId(CardTypeID)
		s ConfigObj.CardAccountRelation=CardTypeObj.CTDCardAccountRelation
		s ConfigObj.CardFareCost=CardInvFee
		s ConfigObj.FareType="NP"
		if (CardInvFee>0){
			s ConfigObj.FareType="C"
		}
		s ConfigObj.GroupRegFlag="PR"
		s ConfigObj.PANoCardRefFlag=CardTypeObj.CTDPANoCardRefFlag
		s ConfigObj.PreCardFlag=CardTypeObj.CTDPreCardFlag
		s ConfigObj.SearchMasFlag=CardTypeObj.CTDSearchMasFlag
		s ConfigObj.StChangeValidateFlag=CardTypeObj.CTDStChangeValidateFlag
		s ConfigObj.SecurityNoFlag=CardTypeObj.CTDSecurityNoFlag
		s ConfigObj.UseINVType=CardTypeObj.CTDUseINVType
	}else{
		////没有卡，只建立病人基本信息	
		s ConfigObj.CardRefFlag="N"
		//建立账户信息
		s ConfigObj.CardAccountRelation="Y"
		
	}
	s ConfigInfo=""
	d ConfigObj.XMLExportToString(.ConfigInfo,"CardTypeConfig")
	///------------账户信息
	s AccObj=##class(web.DHCEntity.PCA.AccManager).%New()
	s AccObj.PassWord=""
	s AccObj.AccountType="P"
	s AccObj.CardNo=CardNo
	s AccObj.CredNo=PAPERID
	//s AccObj.AccMDepPrice=0
	s AccObj.amt=left
	s AccObj.UserDR=UserID
	
	d AccObj.XMLExportToString(.AccInfo,"AccManager")
	///------------支付信息
	s DepositObj=##class(web.DHCEntity.PCA.AccPreDeposit).%New()
	s DepositObj.PayMode=PayMode
	s DepositObj.amt=left
	s DepositObj.UserDR=UserID
	s DepositInfo=""
	//d DepositObj.XMLExportToString(.DepositInfo,"AccManager")
	d DepositObj.XMLExportToString(.DepositInfo,"AccPreDeposit")
	s SepcialInfo=CardObj.SecurityNo_"^"_AccObj.PassWord
	s ExpStr=""
	
	TS
	if (CardNo=""){
		s RtnMain=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(PatObj)
		s PatientID=$P(RtnMain,"^",2)
		s CardRowID=""
	}else{
		s RtnMain=##class(web.DHCBL.CARDIF.ICardRefInfo).SavePCAInfoToServer(ConfigInfo, PaPatInfo, SaveCardInfo, AccInfo, DepositInfo, CardINVInfo, SepcialInfo, ExpStr)
		s PatientID=$P(RtnMain,$C(1),5)
		s CardRowID=$P(RtnMain,$C(1),6)
	}
	if (+RtnMain'=0){
		TRO
		q "-1^流水号"_SerialsNo_"导入第一条数据失败:"_RtnMain_""
	}else{
		&sql(update SQLUSER.PA_Person set PAPER_ExemptionNumber=:AdmTimes where PAPER_RowId=:PatientID)
		
		s AccRowID=""
		if (CardRowID'=""){
			s AccRowID=$P(^DHCCARD("CF",CardRowID),"^",1)
		}
		s ret=0
		for i=2:1:$L(CardInfo,"$") {
			s CardTypeCode=$P($P(CardInfo,"$",i),"^",1)
			s CardNo=$P($P(CardInfo,"$",i),"^",2)
			s SecurityNo=$P($P(CardInfo,"$",i),"^",3)
			s CardInvFee=$P($P(CardInfo,"$",i),"^",4)
			s CardTypeID=..GetCardTypeID(CardTypeCode)
			continue:(CardNo="")||(CardTypeCode="")
			s myCardINVRowID=""
			if (CardInvFee>0){
				s CardINVObj = ##class(web.DHCEntity.PCA.CardINVPRT).%New()
				s CardINVObj.PayMode=PayMode
				s CardINVObj.UserDR=UserID
				s CardINVObj.CardFareCost=CardInvFee
				s CardINVObj.PAPMIRowID = PatientID
				s CardINVObj.Flag="N"
				s ret=##class(web.DHCBL.CARD.UCardINVPRTInfo).SaveCardINVInfo(CardINVObj,CardTypeID)
				if (+ret<0){
					q
				}
				s myCardINVRowID=$p(ret,"^",2)
			}
			
			s CardObj=##class(web.DHCEntity.PCA.CardRef).%New()
			s CardObj.ActiveFlag="N"
			s CardObj.CardNo=CardNo
			s CardObj.CardTypeDefine=CardTypeID
			s CardObj.CredNo=PAPERID
			s CardObj.UserDR=UserID
			s CardObj.SecurityNo=SecurityNo
			s CardObj.PAPMIRowID = PatientID
			s CardObj.CardINVPRTDR=myCardINVRowID
			s CardObj.CFAccNoDR =AccRowID
			s ret=##class(web.DHCBL.CARD.UCardRefInfo).SaveCardInfo(CardObj)
			if (+ret<0){
				q
			}
		}
		
		if (+ret<0){
			TRO
			q "-1^流水号"_SerialsNo_"导入第"_i_"条卡号失败:"_ret_""
		}
		
	}
	TC
	q "0^"_PatientID
SavePatientInfoErr
	if ($TL>0){
		tro
	}
	q "-100^SavePatientInfoErr:"_$ZE
}

ClassMethod GetCardTypeID(CardTypCode As %String) As %String
{
	///&sql(Select CTD_RowID into :CardTypeID From SQLUser.DHC_CardTypeDef Where CTD_Code=:CardTypeCode)
	s ID=""
	s CardTypeID=0
	for{
		s CardTypeID=$O(^DHCCARDTYPEDef(CardTypeID))
		q:(CardTypeID="")
		i CardTypCode=$P(^DHCCARDTYPEDef(CardTypeID),"^",1){
			s ID=CardTypeID
		}
	}
	q ID
}

}
