Class DHCDoc.Common.pa Extends DHCDoc.Util.RegisteredObject
{

/// 一、取患者信息
/// 1.根据卡号取患者信息
ClassMethod GetPAPMIByCardNo(CardNo As %String, CardType As %String) As %String
{
	s PatientID=""	
	q:(CardNo="")||(CardType="") PatientID
	s myCFRowID=0
	f  {
		s myCFRowID=$o(^DHCCARDi("CF",0,"CardTypeNo",CardType,CardNo, myCFRowID)) 
		q:((myCFRowID="")||(PatientID'=""))
		s myActiveFLag=$p(^DHCCARD("CF",myCFRowID),"^",10)
		continue:(myActiveFLag'="N")
		s PatientID=$p($g(^DHCCARD("CF",myCFRowID)),"^",4)
	}
	q PatientID
}

/// 2.根据身份证号取患者信息(或者其他证件类型)
/// 入参 证件类型，证件号
/// 出参 0!PatientID 存在仅有一位患者 ,1!PatientID^PatientID^.. 存在多位患者 , 2! 不存在患者
ClassMethod GetCredNoByCardID(CredType As %String, CredNo As %Library.String) As %String
{
	s PatientIDStr="" 
	q:(CredNo="")||(CredType="") PatientIDStr
	s CredNo=$ZConvert(CredNo, "U")
	s FindSum=0
	s myPAPMIDR=0
	for{
		s myPAPMIDR=$o(^PAPERi("DVA",CredNo,myPAPMIDR))
		q:(myPAPMIDR="")
		s myCredTypeDR=$p(^PAPER(myPAPMIDR,"PAT",3),"^",7)
		continue:(CredType'="")&&(CredType'=myCredTypeDR)
		i PatientIDStr="" s PatientIDStr=myPAPMIDR
		e  s PatientIDStr=PatientIDStr_"^"_myPAPMIDR
		s FindSum=FindSum+1
	}
	if (FindSum=0){
		s PatientIDStr="2!"
	}elseif (FindSum=1){ s PatientIDStr="0!"_PatientIDStr 
	}else{ s PatientIDStr="1!"_PatientIDStr }
	q PatientIDStr
}

/// 3.取患者基本信息
ClassMethod GetPatBaseInfo(PatientID As %String, HospID As %String = "")
{
	q:PatientID="" "{}"
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s BaseInfo={}
	//姓名
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1) 
	s BaseInfo.Name=Name
	//登记号
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",2)
	s BaseInfo.PatNo=PatNo
	///出生日期
	s BaseInfo.PatDob=..GetPatDob(PatientID)
	///年龄
	s BaseInfo.PatAge=..GetPatAge(PatientID,HospID)
	///性别
	s BaseInfo.PatSex=..GetPatSex(PatientID,HospID)
	///证件号及证件类型
	s CredInfo=..GetCredInfo(PatientID)
	s BaseInfo.CredType=$P(CredInfo,"^",2)
	s BaseInfo.CredNo=$P(CredInfo,"^",1)
	///身份证号
	s BaseInfo.PatBaseCredNo=..GetCredPatientNo(PatientID)
	///患者卡信息
	s CardInfo=..GetActiveCardNo(PatientID)
	s CardObj={}.%FromJSON(CardInfo)
	s BaseInfo.CardInfo=CardObj
	;社会地位（人员类型）
	s SocialDESC="" 
	s SocialStatusDR=$p($g(^PAPER(PatientID,"PER",1)),"^",10) 
	s:SocialStatusDR'="" SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
	s BaseInfo.SocialDESC=SocialDESC
	;省
	s ProvinceDesc=""
	s ProvinceDR=$p($g(^PAPER(PatientID,"PER",2)),"^",11)
	s ProvinceDR=+ProvinceDR        
	i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
	i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s BaseInfo.ProvinceDesc=ProvinceDesc
	;市
	s CityBirthDesc=""
	s CityBirthDR=$p($g(^PAPER(PatientID,"ALL")),"^",18)
	s CityBirthDR=+CityBirthDR
	i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
	i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
	s BaseInfo.CityBirthDesc=CityBirthDesc
	
	;家庭住址,工作单位
	s SecondAddress=$g(^PAPER(PatientID,"PER","ADD",1))
	s workAdress=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
	s BaseInfo.SecondAddress=SecondAddress
	s BaseInfo.workAdress=workAdress
	;联系人关系
	s RelationDesc=""
	s RelationID=$p($g(^PAPER(PatientID,"EMP")),"^",4)
	s:RelationID'="" RelationDesc=$P($g(^CT("RLT",RelationID)),"^",2)
	s BaseInfo.RelationDesc=RelationDesc
	;联系人	
	s RelationName = $p($g(^PAPER(PatientID,"PER",2)),"^",13)   
	s BaseInfo.RelationName=RelationName
	;联系人电话
	s RelationPhone=$p($g(^PAPER(PatientID,"ALL")),"^",4) 
	s BaseInfo.RelationPhone=RelationPhone
	;婚姻状况
	s MaritalDesc=""
	s Marital=$p($g(^PAPER(PatientID,"PER",2)),"^",3)
	i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2)
	s BaseInfo.MaritalDesc=MaritalDesc
	;民族 
	s nationDesc=""
	s nationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)
	i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
	s nationDesc=##class(User.CTNation).GetTranByDesc("CTNATDesc",nationDesc,langid)
	i $g(nationDesc)'="" {
		i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
	}
	s BaseInfo.nationDesc=nationDesc
	;手机
	s telphone=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	s BaseInfo.telphone=telphone
	;联系电话
	s Tel=$p($g(^PAPER(PatientID,"PER",1)),"^",11)
	s BaseInfo.Tel=Tel
	
	;文化程度
	s educationDesc=""
	s educationdr=$p($g(^PAPER(PatientID,"PER",2)),"^",5)
	i educationdr'="" s educationDesc=$p($G(^CT("EDU",+Marital)),"^",2) 
	s BaseInfo.educationDesc=educationDesc
	
	;国家
	s countryDesc=""
	s countrydr=$p($g(^PAPER(PatientID,"PER",1)),"^",8)
	i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
	s BaseInfo.countryDesc=countryDesc
	
	;病案号-获取住院病历号
	s MedicalNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22) 
	s BaseInfo.MedicalNo=MedicalNo
	
	;病人级别和密级
	s EmployeeFunction="",SecretLevel=""
	s EmployeeFunctionDR=$p($g(^PAPER(PatientID,"PER",3)),"^",3)
	if EmployeeFunctionDR'="" s EmployeeFunction=$P($g(^CT("EMF",EmployeeFunctionDR)),"^",2)
	
	s SecCode="",SecDesc="",SecretLevel=""
	s PAPMISecretLevelDR=$p($g(^PAPER(PatientID,"DHC")),"^",30)
	if PAPMISecretLevelDR'="" {
		s SecCode=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),2)
		s SecDesc=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),3)
		s SecretLevel=$List(^User.DHCSecretLevelD(PAPMISecretLevelDR),4)
	}
	s BaseInfo.EmployeeFunction=EmployeeFunction
	s BaseInfo.SecretLevel=SecretLevel
	Q BaseInfo.%ToJSON()
}

/// 3.1 :获取患者出生日期 
ClassMethod GetPatDob(PatientID As %String)
{
	q:PatientID="" ""
	s PatDob=$p(^PAPER(PatientID,"ALL"),"^",6)
	Q:PatDob="" ""
	Q ..%ZD(PatDob) //$zd(PatDob,3)
}

/// 3.2 :获取患者性别
ClassMethod GetPatSex(PatientID As %String)
{
	q:PatientID="" ""
	s PatSexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	if (PatSexDr'="") {
		s PatSex=$p($g(^CT("SEX",PatSexDr)),"^",2)
	}
	Q PatSex
}

/// 3.3 :获取患者年龄
ClassMethod GetPatAge(PatientID As %String, HospID As %String = "")
{
	q:((PatientID="")||(HospID="")) ""
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"",HospID)
	Q Age
}

/// 3.4 :获取患者证件号码及证件类型 
/// 出参 CredNo^CredType
ClassMethod GetCredInfo(PatientID As %String)
{
	q:PatientID="" ""
	s CredType=""
	s myCredTypeID=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	s:myCredTypeID'="" CredType=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
	s CredNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	q CredNo_"^"_CredType
}

/// 3.5 :获取患者身份证
ClassMethod GetCredPatientNo(PatientID As %String)
{
	q:PatientID="" ""
	s papmiId=$P($G(^PAPER(PatientID,"ALL")),"^",9 )  ;身份证 证件类型
	if (papmiId=""){
		s myCredTypeDesc=""
		s myCredTypeID=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)
		s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
		if myCredTypeDesc["身份证"   s papmiId=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	}
	q papmiId
}

/// 3.6 获取患者有效卡
/// 返回 Json  
ClassMethod GetActiveCardNo(PatientID)
{
	q:PatientID="" "[]"
	s CardInfo=[]
	s CardRowID=0
	 for {
		s CardRowID=$O(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CardRowID))
		q:CardRowID=""
		s myActiveFLag=$p(^DHCCARD("CF",CardRowID),"^",10)
		continue:(myActiveFLag'="N")
		s CardNo=$p(^DHCCARD("CF",CardRowID),"^",2)
		s CardType=""
		s CardTypeID=$p(^DHCCARD("CF",CardRowID),"^",16)
		if CardTypeID'=""  s CardType=$P(^DHCCARDTYPEDef(CardTypeID),"^",2)
		s obj={}
		s obj.CardID=CardRowID
		s obj.CardNo=CardNo
		s obj.CardType=CardType
		d CardInfo.%Push(obj)
	 }
	Q CardInfo.%ToJSON()
}

/// 3.7得到默认费别
ClassMethod GetDefaultBillType(PatCatDr As %String) As %String
{
	set AdmReason=""
	i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
	i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
}

/// 3.8得到默认费别通过患者
ClassMethod GetDefaultBillTypeByPa(PatientID As %String) As %String
{
	set AdmReason=""
	s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
	i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
	i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
}

/// 二、取科室，医生(在DHCDoc.Common.base)
/// 三、取排班
/// 4.查询排班
/// 4.1 根据科室医生查询排班 ,调用挂号里查询排班的方法和自助机一致 
/// 入参: 科室ID^用户ID^预约日期(如果是当天则不传)^病人类型^时段ID^医生ID(ct_careprov)
///      ^安全组ID^病人费别^false^传空(上下午)^服务组^是否显示停诊^优惠设置^医院ID^预约方式代码
ClassMethod GetOPDocList(DepStr)
{
	s OPScheduleInfo=[]
	s rs=##Class(%ResultSet).%New("web.DHCOPAdmReg:OPDocList")
	i rs.QueryIsValid() { 
		Set Status=rs.Execute(val)
		Set columns = rs.GetColumnCount()
		If 'Status Quit "[]"
		While rs.Next() {
			s obj={}
			s obj.ASRowId=rs.GetDataByName("ASRowId")
			s obj.MarkDesc=rs.GetDataByName("MarkDesc")
			s obj.Load=rs.GetDataByName("Load")
			s obj.AppLoad=rs.GetDataByName("AppLoad")
			s obj.AddLoad=rs.GetDataByName("AddLoad")
			s obj.AvailSeqNoStr=rs.GetDataByName("AvailSeqNoStr")
			s obj.AvailAddSeqNoStr=rs.GetDataByName("AvailAddSeqNoStr")
			s obj.RoomDesc=rs.GetDataByName("RoomDesc")
			s obj.ClinicGroupDesc=rs.GetDataByName("ClinicGroupDesc")
			s obj.SessionTypeDesc=rs.GetDataByName("SessionTypeDesc")
			s obj.RegFee=rs.GetDataByName("RegFee")
			s obj.RegFeeDr=rs.GetDataByName("RegFeeDr")
			s obj.ExamFee=rs.GetDataByName("ExamFee")
			s obj.ReCheckFee=rs.GetDataByName("ReCheckFee")
			s obj.HoliFee=rs.GetDataByName("HoliFee")
			s obj.HoliFeeDr=rs.GetDataByName("HoliFeeDr")
			s obj.AppFee=rs.GetDataByName("AppFee")
			s obj.AppFeeDr=rs.GetDataByName("AppFeeDr")
			s obj.RoomCode=rs.GetDataByName("RoomCode")
			s obj.DepDesc=rs.GetDataByName("DepDesc")
			s obj.RegedCount=rs.GetDataByName("RegedCount")
			s obj.AppedCount=rs.GetDataByName("AppedCount")
			s obj.AddedCount=rs.GetDataByName("AddedCount")
			s obj.AvailNorSeqNoStr=rs.GetDataByName("AvailNorSeqNoStr")
			s obj.ScheduleStatus=rs.GetDataByName("ScheduleStatus")
			s obj.ScheduleDate=rs.GetDataByName("ScheduleDate")
			s obj.ScheduleDateWeek=rs.GetDataByName("ScheduleDateWeek")
			s obj.TimeRange=rs.GetDataByName("TimeRange")
			s obj.AppedArriveCount=rs.GetDataByName("AppedArriveCount")
			s obj.BorghAlertInfo=rs.GetDataByName("BorghAlertInfo")
			d OPScheduleInfo.%Push(obj)
		}
	}
	Q OPScheduleInfo.%ToJSON()
}

/// 4.2 查询可用排班，
/// 入参 :医生资源ID,时段
ClassMethod GetAvailRA(ResRowId As %String, AdmDate As %Date, AdmTime As %Time, TimeRangeRowId As %String, SelectTRQuery As %String = "", IfAvailFlag As %String = "", ShowStopFlag As %String = "") As %String
{
	s ^tmpguo("GetAvailRA",$h)=ResRowId_","_AdmDate_","_AdmTime_","_TimeRangeRowId_","_SelectTRQuery_","_IfAvailFlag
	;w ##class(web.DHCRBApptSchedule).GetAvailRA(3997,64718,"","",1)	
	s ASRowIdStr="",ASRowId=""
	
	if $L(AdmDate,"/")=3 s AdmDate=$ZDH(AdmDate,4)
	if $L(AdmDate,"-")=3 s AdmDate=$ZDH(AdmDate,3)
	;先按照时段查看，如果时段为空就诊日期为当日按照。则查询当下所有时段。
	;如果不包含的话按照时段包含取应该显示的排班
	if (AdmDate=..%SysDate())&&(TimeRangeRowId="")  {
		s TimeRangeRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange(TimeRangeRowId)
	}
	s NowTime=..%SysTime()
	s ASSessStartTime="" f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	..s StartTime=ASSessStartTime
	..s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	..;Q:(StartTime'="")&&(AdmTime'>StartTime)
	..;Q:(EndTime'="")&&(AdmTime'<EndTime)
	..s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17) //dhcrbapptschedul User.DHCTimeRange
	..i TRRowId="" s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	..s RESEPMarkFlag=##class(web.DHCRBResource).GetEPMarkFlag(ResRowId)
	..s TRDesc=""
	..if TRRowId'="" s TRDesc=$P($G(^DHCTimeRange(TRRowId)),"^",2)
	..s ASStopRegNoFlag=$p($g(^RBAS(ResRowId,ASChildSub,"DHC")),"^",27) //停正号标志
	..Q:(ASStopRegNoFlag="Y")&&(AdmDate>+$h)
	..;--------若查询时段是"当前",判断时段的挂号时间段是否包含当前时间,若包含则显示该排班.----
	..s ASRegTimeRangIsContain=0
	..if (TimeRangeRowId="CUR")&&(TRRowId'="") d
	...i (AdmDate=..%SysDate()) s ASRegTimeRangIsContain=##class(web.DHCRBApptSchedule).ChkRegTimeRangeIsContain(TRRowId)
	...e  s ASRegTimeRangIsContain=##class(web.DHCRBApptSchedule).ChkTimeRangeIsContain(TRRowId)
	..;-----------------当日号别按照挂号开始时间和结束时间检索   ----------------------------------
	..s RegTimeFlag="Y" ;允许查询
	..s OpenFlag="N" ;开启挂号时间标志
	..if ((TRRowId'="")&&(AdmDate=..%SysDate())&&(RESEPMarkFlag'=1)&&(TimeRangeRowId'=""))  d
	...s TRRegSTTime=$P($G(^DHCTimeRange(TRRowId)),"^",9)
	...s TRRegEndTime=$P($G(^DHCTimeRange(TRRowId)),"^",10)
	...if (TRRegSTTime'="")||(TRRegEndTime'="")  d
	....;开启了挂号时间,同步判断排班上得个性出诊截止时间.如果有一个不满足退出
	....s OpenFlag="Y"
	....if (TRRegSTTime'="")&&(NowTime<TRRegSTTime) s RegTimeFlag="N"
	....if (TRRegEndTime'="")&&(NowTime>TRRegEndTime) s RegTimeFlag="N"
	....s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	....if (EndTime'="")&&(NowTime>EndTime) s RegTimeFlag="N"
	....if (RegTimeFlag="Y")&&(TimeRangeRowId'="CUR")&&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!")) s RegTimeFlag="N"
	....if (RegTimeFlag="N")&&(TimeRangeRowId'="CUR")&&(("!"_TimeRangeRowId_"!")[("!"_TRRowId_"!")) s RegTimeFlag="Y"
	..Q:(RegTimeFlag="N")
	..;开启得时候查看预约
	..Q:(AdmDate'=..%SysDate())&(RESEPMarkFlag'=1)&(TimeRangeRowId'="")&(TRRowId'="")&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!"))&(OpenFlag="Y")&(ASRegTimeRangIsContain=0)
	..;未开启还是走原来得时段
	..Q:(RESEPMarkFlag'=1)&(TimeRangeRowId'="")&(TRRowId'="")&(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!"))&(OpenFlag="N")&(ASRegTimeRangIsContain=0)
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	..;过滤停诊和替诊
	..;Q:(status="S")||(status="TR")||(status="PS")
	..Q:(status="TR")||(status="PS")
	..Q:(ShowStopFlag'="1")&&(status="S")
	..//过滤 待审核
	..Q:(status="AUD")
	..//只停诊预约和只停诊正号需求	
	..//Q:(($g(isApp)'="")&&(isApp=1)&&(status="SA"))
	..//Q:(($g(isApp)'="")&&(isApp'=1)&&(status="SP"))
	..s ASIrregularFlag=$p($g(^RBAS(ResRowId,ASChildSub)),"^",13)
	..;默认是不找不规则出诊记录的
	..q:((ASIrregularFlag="A")&&((IfAvailFlag="")||(IfAvailFlag="Y")))
	..s ASRowId=ResRowId_"||"_ASChildSub
	..i ASRowIdStr="" s ASRowIdStr=ASRowId
	..e  s ASRowIdStr=ASRowIdStr_"^"_ASRowId
	
	Q ASRowIdStr
}

/// 4.3 查询单个排班的信息
/// 入参：排班ID,费别指针,病人ID，预约方式Code，挂号优惠设置
ClassMethod GetMarkRegFee(ASRowId As %String, BillTypeDR As %String, PatientID As %String = "", AppMethodCode As %String = "", RegConDisId As %String = "") As %String
{
	 s Load=0
	 s NoAppt=0
	 S Price=""
	 s SessSerRowId=""
	 s ASRowIDInfo={}
	 If ASRowId="" Quit "{}"
	 s ResRowId=$P(ASRowId,"||",1)
	 s ASChildSub=$P(ASRowId,"||",2)
	 ;不排除排班被删除的可能,需先判断排班是否存在
	 Q:'$d(^RBAS(+ResRowId,ASChildSub)) "{}"
	 ;根据释放时间自动释放锁表锁号
	 d ##Class(web.DHCLockSchedule).UnLockSchedule(ASRowId)
	 ;排班日期
	 s ASDate=$P(^RBAS(ResRowId,ASChildSub),"^",1)
	 s ASDateWeek=""
	 i ASDate'="" {
		 s ASDateWeek=##class(web.DHCOPAdmReg).ConvertDateToWeek(ASDate)
		 s ASDate=..%ZD(ASDate) //$ZD(ASDate,3)
	 }
	 
	 if AppMethodCode="" s AppMethodCode="WIN"
	 s AppMethodCodeDR=$O(^RBC("APTM",0,"Code",AppMethodCode,0))
	 ;挂号限额=预约限额+正号限额
	 s Load=$P($G(^RBAS(ResRowId,ASChildSub)),"^",8)
	 ;预约限额
	 s AppLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
	 s WinMethodAppLoad=##class(web.DHCRBAppointment).GetAppSeqNo(ASRowId,AppMethodCode,"") //##class(web.DHCRBAppointment).GetAvailableNum(ASRowId,"APP",AppMethodCode,"")  //##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(ASRowId,"WIN")
	 s AppLoad=WinMethodAppLoad
	 ;加号限额
	 s AddLoad=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",3)
	 
	 ;出诊开始时间取时段
	 s StartTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",4)
	 s TRRowId=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",17)
	 if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	 e  s TRDesc="其他"
	
	 ;诊室,亚专业,出诊级别
	 s RoomDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
	 s RoomDesc=""
	 i RoomDr'="" Set RoomDesc=$p(^CTLOC(RoomDr),"^",2) 
	 s ClinicGroupDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
	 s ClinicGroupDesc=""
	 i ClinicGroupDr'="" s ClinicGroupDesc=$P($G(^RBC("CLGRP",ClinicGroupDr)),"^",2)
	 s SessionClinicGroupDrStr=""
	 s ClinicGroupStr=##class(web.DHCApptScheduleNew).GetClinicGroupDrStr(ASRowId)
	 if ClinicGroupStr'=""{
		s SessionClinicGroupDrStr=$p(ClinicGroupStr,"^",1)
		s ClinicGroupDesc=$p(ClinicGroupStr,"^",2)
	 }
	 s SessionTypeDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",6)
	 s SessionTypeDesc=""
	 i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	 s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	 s statuscode="",statusDesc=""
	 i status'="" {
	 	s statuscode=$P(^DHCRBCASStatus(status),"^",1)
	 	s statusDesc=$P(^DHCRBCASStatus(status),"^",2)
	 }
	 s statusreason=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",11)
	 
	 ;取可用排号和预约排号,加号排号
	 s AvailSeqNoStr=##class(web.DHCRBAppointment).GetAvailableNum(ASRowId,"NOR",AppMethodCode,"") //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"NOR")
	 s AvailAddSeqNo=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"ADD")
	 s AvailAppSeqNo=##class(web.DHCRBAppointment).GetAvailableNum(ASRowId,"APP",AppMethodCode,"")  //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"APP",AppMethodCodeDR)
	 s AvailNorSeqNo=##class(web.DHCRBAppointment).GetAvailableNum(ASRowId,"NORN",AppMethodCode,"")  //##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"NORN")
	 ;s AvailNorSeqNo=""

	 s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCount(ASRowId)
	 s RegedCount=$P(UsedSeqNoCount,"^",1)
	 s AppedCount=$P(UsedSeqNoCount,"^",2)
	 s AddedCount=$P(UsedSeqNoCount,"^",3)
	 s AppedArriveCount=$P(UsedSeqNoCount,"^",4)
	 /*s AppedCount=(+AppedCount)-(+AppedArriveCount)
	 if (AppedCount>=AppLoad){s AvailAppSeqNo="" }*/
	
	  ;取价格
	 s AdmDate=..%SysDate()
	 s AdmReason=BillTypeDR
	 s Price=0,chrhfee=0,holi=0,AppFee=0,OtherFee=0,ReCheckFee=0
	 s PriceArcId="",chrhfeeArcId="",holiId="",AppFeeId="",OtherFeeId=""
	 s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ASRowId,""),"^",1)
	 ;取挂号费和诊查费和节假日挂号费信息
	 s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(ASRowId,AdmReason,HospId)
	 s SerIdStr=##class(web.DHCOPAdmReg).GetCustomScheduleService(PatientID,ASRowId,SerIdStr)
	 if (RegConDisId=""){
		 s RegConDisIdPara=PatientID_"^"_ASRowId_"^"_AdmReason_"^"_""
		 s RegConDisId=##class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	 }
	 
	 s AdmLoc=$p(^RB("RES",ResRowId),"^",1)
	 s AdmType="O"
	 if AdmType'="E" {
		s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(AdmLoc)
		if IsEmergency="1" s AdmType="E"
	 }
	 
	 s PriceExpStr=RegConDisId_"^^^^^^^^"_PatientID_"^"_AdmType
	 i SerIdStr'="" {
		 f i=1:1:$l(SerIdStr,"^") {
			 ;s SerId=$P(SerIdStr,"^",i)
			 ;s ArcimId=$p(^RBC("SER",SerId),"^",1)
			 s ArcimId=$P(SerIdStr,"^",i)
			 s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","","",HospId,PriceExpStr),"^",4)
			 s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,HospId)
			 if RegSerBillSubType="Reg"  d 
			 .set Price=BillPrice+Price
			 if RegSerBillSubType="Check" d
			 .set chrhfee=BillPrice+chrhfee
			 if RegSerBillSubType="Holi" d
			 .set holi=BillPrice+holi
			 if RegSerBillSubType="App" d
			 .set AppFee=BillPrice+AppFee
			 if RegSerBillSubType="Other" d
			 .set OtherFee=BillPrice+OtherFee
			 if RegSerBillSubType="ReCheck" d
			 .set ReCheckFee=BillPrice+ReCheckFee
		 }
	 }
	 s ASRowIDInfo.Load=$g(Load)  
	 s ASRowIDInfo.AppLoad=$g(AppLoad)
	 s ASRowIDInfo.AddLoad=$g(AddLoad)
	 s ASRowIDInfo.AvailSeqNoStr=$g(AvailSeqNoStr)
	 s ASRowIDInfo.AvailAddSeqNo=$g(AvailAddSeqNo)
	 s ASRowIDInfo.RoomDesc=$g(RoomDesc)
	 s ASRowIDInfo.RoomDr=$g(RoomDr)
	 s ASRowIDInfo.ClinicGroupDesc=$g(ClinicGroupDesc)
	 s ASRowIDInfo.ClinicGroupDr=$g(ClinicGroupDr)
	 s ASRowIDInfo.SessionTypeDesc=$g(SessionTypeDesc)
	 s ASRowIDInfo.SessionTypeDr=$g(SessionTypeDr)
	 s ASRowIDInfo.Price=$fn(Price,"-")
	 s ASRowIDInfo.PriceArcId=$g(PriceArcId)
	 s ASRowIDInfo.chrhfee=$fn(chrhfee,"-")
	 s ASRowIDInfo.ReCheckFee=$fn(ReCheckFee,"-")
	 s ASRowIDInfo.holi=$fn(holi,"-")
	 s ASRowIDInfo.holiId=$g(holiId)
	 s ASRowIDInfo.AppFee=$fn(AppFee,"-")
	 s ASRowIDInfo.AppFeeId=$g(AppFeeId)
	 s ASRowIDInfo.OtherFee=$fn(OtherFee,"-")
	 s ASRowIDInfo.TRDesc=$g(TRDesc)
	 s ASRowIDInfo.RegedCount=$g(RegedCount)
	 s ASRowIDInfo.AppedCount=$g(AppedCount)
	 s ASRowIDInfo.AddedCount=$g(AddedCount)
	 s ASRowIDInfo.AvailAppSeqNo=$g(AvailAppSeqNo)
	 s ASRowIDInfo.AvailNorSeqNo=$g(AvailNorSeqNo)
	 s ASRowIDInfo.statusDesc=$g(statusDesc)
	 s ASRowIDInfo.ASDate=$g(ASDate)
	 s ASRowIDInfo.ASDateWeek=$g(ASDateWeek)
	 s ASRowIDInfo.AppedArriveCount=$g(AppedArriveCount)
	 Q ASRowIDInfo.%ToJSON()
}

/// 4.4 查询可用排班数
/// 入参：排班ID,费别指针,病人ID，预约方式Code，挂号优惠设置
ClassMethod GetAvailableNum(RBASId As %String, RegType As %String, APPMethodCode As %String = "", HospitalID As %String = "", StartTime As %String = "", EndTime As %String = "")
{
	q ##class(web.DHCRBAppointment).GetAvailableNum(RBASId , RegType, APPMethodCode , HospitalID , StartTime , EndTime)
}

/// 4.5 查询号源的时间
ClassMethod GetAdmTimeRange(ASRowId, SeqNo, TimePeriod = "") As %String
{
	;w ##class(web.DHCOPAdmReg).GetAdmTimeRange("91||1",1)
	s TimePeriod=##class(web.DHCOPRegConfig).GetSpecConfigNode("AdmTimeRangeCount")
	if +$g(TimePeriod)=0 s TimePeriod=3
	s ASStartTime=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",4) 
	s Load=+$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",8)
	;s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(ASStartTime)
	s TRRowId=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",17)
	Q:TRRowId="" ""
	Q:+Load=0 ""
	s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	/*
	i $e(SeqNo,1)="+"{
		s SessStartTime=EndTime+1800
		Q ..%ZT(SessStartTime,2)_"之前"
	}
	*/
	i $e(SeqNo,1)="+"{
		if (EndTime<=84599){
			s SessStartTime=EndTime+1800
		}else{
			s SessStartTime=EndTime
		}
		Q ..%ZT(SessStartTime,2)_"之前"
	}
	;w Load_"-"_..%ZT(StartTime)_"-"_..%ZT(EndTime),!
	f i=1:1:TimePeriod  {
		if (SeqNo/Load)<=(i/TimePeriod) {
			Quit
		}
	}
	s SingleTime=(EndTime-StartTime)/TimePeriod
	s SessStartTime=StartTime+(SingleTime*(i-1))
	s SessEndTime=StartTime+(SingleTime*i)
	Q ..%ZT(SessStartTime,2)_"-"_..%ZT(SessEndTime,2)
}

/// 四、预约
/// 五、挂号(包含锁号)
/// 六、取挂号、预约信息
/// 6.1 获取挂号信息
/// Debug:w ##class(DHCDoc.Common.pa).GetOPPrintData("4717","","Y","","")
ClassMethod GetOPPrintData(RegfeeRowId As %String = "", AppFlag As %String = "", RePrintFlag = "N", HospID As %String = "", AdmDr As %String = "")
{
	s ^tempqujian("GetOPPrintData")=$lb(RegfeeRowId , AppFlag , RePrintFlag , HospID , AdmDr)
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ret=""
	if ((RegfeeRowId="")&&(AdmDr="")) q ""
	if ((RegfeeRowId="")&&(AdmDr'="")){
		s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmDr,0))
		}
	s RetObj=[]
	s OPPrintData={}
	b ;0933
	s obj=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	if $IsObject(obj){if $IsObject(obj.RegfeeAdmDr)
		s SessionType="",TimeRange="",Room="",RoomAddress="",ExabMemo="",InvoiceId="",RBASDr=""
		s AdmDr=obj.RegfeeAdmDr.%Id()
		s DepDr=obj.RegfeeDepDr.%Id()
		s DocDr=obj.RegfeeDocDr.%Id()
		s UserDr=obj.RegfeeUserDr.%Id()
		s RegDate=obj.RegfeeDate
		s RegTime=..%ZT(obj.RegfeeTime,1)
		if $IsObject(obj.RegfeeSessionTypeDr) s SessionTypeDr=obj.RegfeeSessionTypeDr.%Id()
		if $IsObject(obj.RegfeeTimeRangeDr) s TimeRangeDr=obj.RegfeeTimeRangeDr.%Id()
		s SeqNo=obj.RegfeeNo
		s RoomDr=""
		if $IsObject(obj.RegfeeRoomDr) s RoomDr=obj.RegfeeRoomDr.%Id()
		if $IsObject(obj.Regfeetemp1) s InvoiceId=obj.Regfeetemp1.%Id()
		if $IsObject(obj.RegfeeRBASDr) s RBASDr=obj.RegfeeRBASDr.%Id()
		;取医保的结算信息
		s InsuPayCash="",InsuPayCount="",InsuPayFund="",InsuPayOverallPlanning="",InsuPayOther=""
		s InsuPayCash=obj.RegfeeInsuCash
		s InsuPayCash=$P(InsuPayCash,"!",2)
		s InsuPayCount=obj.RegfeeInsuCount
		s InsuPayCount=$P(InsuPayCount,"!",2)
		s InsuPayFund=obj.RegfeeInsuFund
		s InsuPayFund=$P(InsuPayFund,"!",2)
		s InsuPayOverallPlanning=obj.RegfeeInsuOverallPlanning
		s InsuPayOther=obj.RegfeeInsuOther
		s RegfeeClinicGroupDR=""
		if (obj.RegfeeClinicGroupDR) s RegfeeClinicGroupDR=obj.RegfeeClinicGroupDR.%Id()
		s ClinicGroupCode=""
		s ClinicGroupDesc=""
		s ASLoad="0"
		i RBASDr'="" {
			;code代表打印出的亚专业的描述
			 s ClinicGroupDr=$P($G(^RBAS(+RBASDr,$P(RBASDr,"||",2),"DHC")),"^",7)
			 i ClinicGroupDr'="" s ClinicGroupCode=$P($G(^RBC("CLGRP",ClinicGroupDr)),"^",1)
			 //取出号别正号限额
			 s ASLoad=$p($g(^RBAS(+RBASDr,$p(RBASDr,"||",2))),"^",8)
		}
		if (RegfeeClinicGroupDR'="") s ClinicGroupDesc=$P($G(^RBC("CLGRP",RegfeeClinicGroupDR)),"^",2)
		s DepDesc="",DocDesc="",UserCode="",User="",HospitalDesc=""
		i DepDr'=""{
			s HospitalDesc=$p($g(^CTLOC(DepDr)),"^",22)
			s:HospitalDesc'="" HospitalDesc=$P(^CT("HOSP",HospitalDesc),"^",2)
			s HospitalDesc=HospitalDesc //_"门诊挂号凭证"
			s DepDesc=$p($g(^CTLOC(DepDr)),"^",2)
		}
		i DocDr'="" s DocDesc=$p($g(^CTPCP(DocDr,1)),"^",2)
		s DepDesc1=$P(DepDesc,"-",2)
		i DepDesc1'="" s DepDesc=DepDesc1
		s User=""
		i InvoiceId'="" {
			s:UserDr="" UserDr=$P(^DHCINVPRT(InvoiceId),"^",21)
		}
		i UserDr'="" s UserCode=$p($g(^SSU("SSUSR",UserDr)),"^",1) 
		i UserDr'="" s User=$p($g(^SSU("SSUSR",UserDr)),"^",2)		
		s RoomNo="", RoomFloor=""

		s ExabMemo=##Class(web.DHCOPAdmReg).GetScheduleAddressInfo(RBASDr)
		s RoomNo=$P(ExabMemo,",",2)
		s WaitingAddress=$P(ExabMemo,",",1)
		i SessionTypeDr'="" s SessionType=$P($g(^RBC("SESS",SessionTypeDr)),"^",2)
		s RegDate=$ZD(RegDate,3)
		s RegDateYear=$P(RegDate,"-",1)
		s RegDateMonth=$P(RegDate,"-",2)
		s RegDateDay=$P(RegDate,"-",3)
		s TimeRangeDesc=""
		i TimeRangeDr'="" s TimeRangeDesc=$P(^DHCTimeRange(TimeRangeDr),"^",2)
		s TimeRange=..GetAdmTimeRange(RBASDr,SeqNo)
		s TimeRange=TimeRangeDesc
		if DocDesc[("便民") s TimeRange=""
		i RePrintFlag="Y" s SeqNo=SeqNo_"      (补打)"
		s (CardNo,INVPRTNo)=""
		s PayModeStr=""
		if (InvoiceId'="") {
			//预交金:0,医保账户支付:11
			s INVPRTNo=$P(^DHCINVPRT(InvoiceId),"^",14)
			s PayModeStr=##class(web.DHCOPAdmReg).GetINVPayMode(InvoiceId)
		}
		//如果支付方式不为空,超过20个字节换行,因为考虑到第三方调用,则分为PayModeStr1和PayModeStr2
		s PayModeStr1=""
		s PayModeStr2=""
		if (PayModeStr'=""){
			if ($l(PayModeStr)>20) {s PayModeStr1=$e(PayModeStr,1,20),PayModeStr2=$e(PayModeStr,21,$l(PayModeStr))}
			else{s PayModeStr1=PayModeStr}
		}
		i AdmDr'="" {
			S AdmReason=$P($g(^PAADM(AdmDr,1)),"^",7)
			s PatDr=$P(^PAADM(AdmDr),"^")
			s InMedical=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"",HospID)
			i InMedical["-"  s InMedical=""
			s OPMedcare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"O",HospID)
		    s IPMedcare=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"I",HospID)
			s PatName=$p(^PAPER(PatDr,"ALL"),"^",1)
			;取登记号
			s PatNo=$p(^PAPER(PatDr,"PAT",1),"^",2)
			s AdmDate=$p($g(^PAADM(AdmDr)),"^",6)
			s AdmDateStr=$ZD(AdmDate,3)
			;s AdmDateStr=$e(AdmDateStr,3,10)
			s TransactionNo=$ZD(+$H,8)_" "_UserCode_" "_INVPRTNo
			s CardNo=..GetAdmRegCard(AdmDr)
			s:CardNo'="" CardNo=$p(CardNo,"^",1)
			s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
		}
		
		s BillSum=0,ConRowId="",PBRowId=""
		s AppFee=0,RegFee=0,CheckFee=0,OtherFee=0,HoliFee=0,ReCheckFee=0,MRFee=0,Total=0
		if (InvoiceId'="")	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceId,0))
		;打印挂号费和诊疗费(包括附属的其他费用)
		s TotalRMBDX=""
		i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
		if PBRowId'="" {
			s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
			.s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
			.Q:ArcimId=""
			.s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,HospID)
			.s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
			.i type="App" s AppFee=AppFee+BillSum
			.e  i type="Reg" s RegFee=RegFee+BillSum
			.e  i type="Check" s CheckFee=CheckFee+BillSum
			.e  i type="Holi" s HoliFee=HoliFee+BillSum
			.e  i type="ReCheck" s ReCheckFee=ReCheckFee+BillSum
			.e  i type="MR" s MRFee=MRFee+BillSum
			.e  i type="Other" s OtherFee=OtherFee+BillSum
			s Total=AppFee+RegFee+CheckFee+HoliFee+ReCheckFee+OtherFee+MRFee
			s TotalRMBDX=##class(web.DHCOPAdmReg).RMBDXXZH("","",Total)
		}
		;得到收费项目
		s Regitems=##class(web.DHCOPAdmReg).GetRegitems(AdmDr)
		if AppFlag=1 {
			s DepDesc=""
			s DocDesc=""
			s SessionType=""
			s TimeRange=""
			s RoomFloor=""
			s SeqNo=""
		}
		;支付方式相关的金额全部统一到支付方式信息中PayModeStr1,PayModeStr2
		;如果需要自费金额与医保金额的分别汇总,可以在【医生站设置->本地化参数配置】中设置:^CF.DOC("LocalConfig","OPAdm","InsuPayMode")=医保支付方式^医保基金支付!医保账户支付^^
		s InsuPayMode=##class(DHCDoc.DHCDocConfig.LocalConfig).GetLocalConfigValue("OPAdm","ZFPayMode")
		for i=1:1:$l(PayModeStr,",") {
			s PayModeDesc=$p($p(PayModeStr,",",i),":",1)
			s PayModeAmt=$p($p(PayModeStr,",",i),":",2)
			continue:PayModeDesc=""
			if ("!"_InsuPayMode_"!")[("!"_PayModeDesc_"!") s InsuPayFund=InsuPayFund+PayModeAmt
		}
		s YBPay=InsuPayFund,PersonPay=Total-YBPay
		s YBPay=$j(YBPay,6,2)_"元",PersonPay=$j(PersonPay,6,2)_"元"
		s Total=$j(Total,6,2)_"元"
		//得到分时段信息
		s TimeRangeInfo=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(RBASDr,SeqNo,TimeRangeDesc)
		
		;得到账户余额
		s AccBalance=##class(web.DHCOPChargeAddByOther).GetAccLeftByRegNo("",PatDr)
		if +AccBalance'=0 s AccBalance=""
		else  s AccBalance=$p(AccBalance,"^",2)
		s EmployeeFunction="",SecretLevel=""
		s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatDr,.ErrMsg)
		i PatEncryptLevel'="" {
			s EmployeeFunction=$p(PatEncryptLevel,"^",2)
			s SecretLevel=$p(PatEncryptLevel,"^",1)
		}
		s GreenRecFlag=$P(##class(web.DHCEMInterfaceCom).CheckGreenRecByTime(AdmDr),"^",1)
		s GreenRecFlag=$CASE(GreenRecFlag,1:"绿通",:"")
		///亚专业需要拼上
		s MarkDesc=DocDesc
		if (ClinicGroupDesc'=""){s MarkDesc=MarkDesc_"("_ClinicGroupDesc_")"}
		s OPPrintData.AdmNo=AdmDr
		s OPPrintData.PatName=PatName
		s OPPrintData.RegDep=DepDesc
		s OPPrintData.DocDesc=DocDesc
		s OPPrintData.MarkDesc=MarkDesc
		s OPPrintData.SessionType=SessionType
		s OPPrintData.AdmDateStr=AdmDateStr
		s OPPrintData.TimeRange=TimeRange
		s OPPrintData.TimeD=TimeRange
		//存在分时段信息 显示分时段信息，如果不存在显示挂号大时段
		i TimeRangeInfo'="" s OPPrintData.AdmDate=TimeRangeInfo
		e  s OPPrintData.AdmDate=AdmDateStr_" "_TimeRange
		s OPPrintData.SeqNo=SeqNo
		s OPPrintData.RoomNo=RoomNo
		s OPPrintData.RoomFloor=RoomFloor
		s OPPrintData.UserCode=UserCode
		s OPPrintData.User=User
		s OPPrintData.RegDateYear=RegDateYear
		s OPPrintData.RegDateMonth=RegDateMonth
		s OPPrintData.RegDateDay=RegDateDay
		s OPPrintData.RegTime=RegDateYear_"-"_RegDateMonth_"-"_RegDateDay_" "_TimeRange
		s OPPrintData.TransactionNo=TransactionNo
		s OPPrintData.Total=Total
		s OPPrintData.RegFee=RegFee
		s OPPrintData.AppFee=AppFee
		s OPPrintData.OtherFee=OtherFee
		s OPPrintData.ClinicGroup=ClinicGroupCode
		s OPPrintData.RegTime=RegTime
		s OPPrintData.RBASDr=RBASDr
		s OPPrintData.ExabMemo=ExabMemo
		s OPPrintData.InsuPayCash=InsuPayCash
		s OPPrintData.InsuPayCount=InsuPayCount
		s OPPrintData.InsuPayFund=InsuPayFund
		s OPPrintData.InsuPayOverallPlanning=InsuPayOverallPlanning
		s OPPrintData.InsuPayOther=InsuPayOther
		s OPPrintData.TotalRMBDX=TotalRMBDX
		s OPPrintData.INVPRTNo=INVPRTNo
		s OPPrintData.CardNo=CardNo
		s OPPrintData.cardnoprint=CardNo
		s OPPrintData.Room=Room
		s OPPrintData.AdmReason=AdmReason
		s OPPrintData.Regitems=Regitems
		s OPPrintData.AccBalance=AccBalance
		s OPPrintData.PatNo=PatNo
		s OPPrintData.TimeRangeInfo=TimeRangeInfo
		s OPPrintData.HospName=HospitalDesc
		s OPPrintData.PersonPay=PersonPay
		s OPPrintData.YBPay=YBPay
		s OPPrintData.InMedical=InMedical
		s OPPrintData.RegfeeRowId=RegfeeRowId
		s OPPrintData.EmployeeFunction=EmployeeFunction
		s OPPrintData.OPMedcare=OPMedcare
		s OPPrintData.IPMedcare=IPMedcare
		s OPPrintData.paymoderstr1=PayModeStr1
		s OPPrintData.paymoderstr2=PayModeStr2
		s OPPrintData.GreenRecFlag=GreenRecFlag
		s OPPrintData.AdmType=AdmType
	}
	d RetObj.%Push(OPPrintData)
	Q RetObj.%ToJSON()
}

/// 六、取挂号、预约信息
/// 6.1 获取预约信息
ClassMethod GetAppPrintData(AppARowid As %String) As %String
{
	s ret="",PatName="",CardNo="",TRDesc="",PatSexDR="",PatSex="",APPTTransUserDR="",APPTMethodDR="",APPTLastStatusChangeUserDR=""
	s PatNo="",TimeRangeInfo="",APPTTransUser="",APPTMethod=""
	s RetObj=[]
	s AppInfo={}
	s object=##class(User.RBAppointment).%OpenId(AppARowid)
	if $IsObject(object){
		if $IsObject(object.APPTPAPMIDR) s PAPMIDR=object.APPTPAPMIDR.%Id()
		S APPTStatus=object.APPTStatus
		s APPTQueueNo=object.APPTQueueNo     //诊号
		s APPTAdmDR=object.APPTAdmDR //.%Id
		if $ISOBJECT(APPTAdmDR) {
			s APPTAdmDR=APPTAdmDR.%Id()
		}
		s APPTETA=object.APPTETA
		s APPTTransDate=..%ZD(object.APPTTransDate)   //预约日期
		s APPTTransTime=object.APPTTransTime
		if $IsObject(object.APPTTransUserDR) s APPTTransUserDR=object.APPTTransUserDR.%Id()
		if $IsObject(object.APPTMethodDR) s APPTMethodDR=object.APPTMethodDR.%Id()
		s APPTDateComp=..%ZD(object.APPTDateComp)
		s APPTTimeComp=object.APPTTimeComp
		if $IsObject(object.APPTLastStatusChangeUserDR) s APPTLastStatusChangeUserDR=object.APPTLastStatusChangeUserDR.%Id()
		s APPTLastStatusChangeDate=..%ZD(object.APPTLastStatusChangeDate)
		s APPTLastStatusChangeTime=object.APPTLastStatusChangeTime
		if APPTTransUserDR'=""  s APPTTransUser=$p($g(^SSU("SSUSR",APPTTransUserDR)),"^",1)
		if APPTMethodDR'="" s APPTMethod=$p($g(^RBC("APTM",APPTMethodDR)),"^",2)
		
		//预约医生
		s RESRowid=(+AppARowid)
		s ASChild=$p(AppARowid,"||",2)
		s AdmDate=$P($g(^RBAS(RESRowid,ASChild)),"^",1)
		s AdmDate=..%ZD(AdmDate)
		s StartTime=$P($G(^RBAS(RESRowid,ASChild)),"^",4)
	    s RegfeeTimeRangeDr=$P($G(^RBAS(+AppARowid,$p(AppARowid,"||",2),"DHC")),"^",17)
	    i RegfeeTimeRangeDr'="" s TRDesc=$P(^DHCTimeRange(RegfeeTimeRangeDr),"^",2) 
	    e  s TRDesc="其他" 
	    s SeqNo=APPTQueueNo_" 号("_TRDesc_")"
		
		s Locdesc="",Docdesc=""
		S LocID=$p(^RB("RES",RESRowid),"^",1)
		i LocID'="" s Locdesc=$p(^CTLOC(LocID),"^",2)
		s DOCID=$p(^RB("RES",RESRowid),"^",2)
		i DOCID'="" s Docdesc=$p(^CTPCP(DOCID,1),"^",2)
		
		//建议就诊时间
		s TimeRangeInfo=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(RESRowid_"||"_ASChild,APPTQueueNo,"")
		
		//病人信息
		if (PAPMIDR'=""){
			s CardInfo=..GetCardInfoByPatID(PAPMIDR)
			s CardNo=$p(CardInfo,"^",1)
			s PatName=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
			s PatSexDR=$p($g(^PAPER(PAPMIDR,"ALL")),"^",7)
			i PatSexDR'="" s PatSex=$p(^CT("SEX",PatSexDR),"^",2)
			s PatNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",2) //登记号
		}
		s CommonPatientID=..GetCommonPatientID()
		i (("^"_CommonPatientID_"^")[("^"_PAPMIDR_"^")){
			s PatName=$p($g(^RBAS(RESRowid,ASChild,"APPT",$p(AppARowid,"||",3),"DHC")),"^",1)
		}
		s PatCatDr=$p(^PAPER(PAPMIDR,"PER",1),"^",10)
		s AdmReason=..GetDefaultBillType(PatCatDr)
		s ReAdmFeeFlag=##class(web.DHCOPAdmReg).GetReAdmFeeFlag(PatCatDr,RESRowid_"||"_ASChild)
		s RtnMes=..GetMarkRegFee(RESRowid_"||"_ASChild,AdmReason,PAPMIDR)
		k RtnMesArr
	    d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RtnMes,.RtnMesArr)
		s SessionTypeDesc=$G(RtnMesArr("SessionTypeDesc")) //$P(RtnMes,"^",10) //级别
		s ASDateWeek=$G(RtnMesArr("ASDateWeek")) //$P(RtnMes,"^",29) //星期
		s RegFee=$G(RtnMesArr("Price")) //$P(RtnMes,"^",12)
		s CheckFee=$G(RtnMesArr("chrhfee")) //$P(RtnMes,"^",14)
		s ReCheckFee=$G(RtnMesArr("ReCheckFee")) //$P(RtnMes,"^",15)
		s HoliFee=$G(RtnMesArr("holi")) //$P(RtnMes,"^",16)
		s AppFee=$G(RtnMesArr("AppFee")) //$P(RtnMes,"^",18)
		s OtherFee=$G(RtnMesArr("OtherFee")) //$P(RtnMes,"^",20)
		if ReAdmFeeFlag=1 s Price=RegFee+ReCheckFee+HoliFee+AppFee+OtherFee_"元"
		e  s Price=RegFee+CheckFee+HoliFee+AppFee+OtherFee_"元"
		
		s:APPTTransTime'="" APPTTransTime=..%ZT(APPTTransTime,1)
		s listitem1=""
		s APPPattype=$P($g(^RBAS(RESRowid,ASChild,"APPT",$p(AppARowid,"||",3),"DHC")),"^",15) 
		if ((APPPattype'="")&&(APPPattype'=1)){
			s listitem1="请联系人为父母或者其他关系的患者卡号取号！"
		}
	 	s AppInfo.CardNo=CardNo
	 	s AppInfo.PAPMIDR=PAPMIDR
	 	s AppInfo.PatName=PatName
	 	s AppInfo.PatSex=PatSex
	 	s AppInfo.SeqNo=SeqNo
	 	s AppInfo.APPTQueueNo=APPTQueueNo
	 	s AppInfo.RegDep=Locdesc
	 	s AppInfo.MarkDesc=Docdesc
	 	s AppInfo.APPTTransDate=APPTTransDate
	 	s AppInfo.APPTTransTime=APPTTransTime
	 	s AppInfo.APPDate=APPTTransDate_" "_APPTTransTime
	 	s AppInfo.APPCompDate=APPTTransDate_" "_APPTTransTime
	 	s AppInfo.AdmDate=AdmDate
	 	s AppInfo.APPTLastStatusChangeDate=APPTLastStatusChangeDate
	 	s AppInfo.APPTLastStatusChangeTime=APPTLastStatusChangeTime
	 	s AppInfo.ArriveEndDateTime=APPTLastStatusChangeDate_" "_APPTLastStatusChangeTime
	 	s AppInfo.PatNo=PatNo
	 	s AppInfo.TimeRangeInfo=TimeRangeInfo
	 	s AppInfo.AdmTimeRange=TimeRangeInfo
	 	s AppInfo.UserCode=APPTTransUser
	 	s AppInfo.APPTMethod=APPTMethod
	 	s AppInfo.Total=Price
	 	s AppInfo.SessionType=SessionTypeDesc
	 	s AppInfo.ASDateWeek=ASDateWeek
	 	s AppInfo.listitem2=listitem1
	 }
	d RetObj.%Push(AppInfo)
	Q RetObj.%ToJSON()
}

/// 退号
/// End
/// desc 获取公共卡设置的公共卡ID串以^分割，公共卡是以&分割
ClassMethod GetCommonPatientID(ChoseCommonCardNo As %String = "", HospitalID As %String = "") As %String
{
	//判断是否有公共卡
	s CommonPatientID=""
	s CommonCardNoStr=##class(web.DHCOPRegConfig).GetSpecConfigNode("CommonCardNo",HospitalID)
	i (CommonCardNoStr'="") {
		s CardStrLong=$L(CommonCardNoStr,"&")
		for i=1:1:CardStrLong{
		s CommonCardNo=$P(CommonCardNoStr,"&",i)
		continue:CommonCardNo=""
		s ExpStr=""_$c(2)_""_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CommonCardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		//if (retcode="-201")!(retcode="0"){
			s CommonPatientIDGet=$P(ret,"^",8)
			if CommonPatientID="" s CommonPatientID=CommonPatientIDGet
			else  s CommonPatientID=CommonPatientID_"^"_CommonPatientIDGet
		//}
		}
	}
	Q CommonPatientID
}

/// Desc:获取就诊挂号的渠道
/// Table:PA_AdmExt RBC_ApptType
/// Input:AdmDr 就诊ID
/// OutPut:渠道描述^渠道ID
/// Debug:w ##class(DHCDoc.Common.pa).GetAdmRegType(2155)
ClassMethod GetAdmRegType(AdmDr)
{
	s Type=""
	s RegType=$p($g(^PAADM(AdmDr,"DHC")),"^",9)
	if RegType'=""{
		s RegTypeDesc=$P($g(^RBC("AT",RegType)),"^",2)
		s Type=RegType_"^"_RegTypeDesc
	}
	Q Type
}

/// Desc:获取就诊时使用的就诊卡号 卡类型
/// Table:PA_AdmExt
/// Input:AdmDr 就诊ID
/// OutPut:就诊卡号^卡类型
/// Debug:w ##class(DHCDoc.Common.pa).GetAdmRegCard(2155)
ClassMethod GetAdmRegCard(AdmDr)
{
	s RegCard=""
	s RegCardType=$p($g(^PAADM(AdmDr,"DHC")),"^",68)
	s RegCardNo=$p($g(^PAADM(AdmDr,"DHC")),"^",69)
	if RegCardNo'=""{
		if RegCardType'=""  s CardType=$P($g(^DHCCARDTYPEDef(RegCardType)),"^",2)
		s RegCard=RegCardNo_"^"_CardType
	}else{
		s PatDr=$P($g(^PAADM(AdmDr)),"^")
		;此处应该和登记号检索卡号时保持一致
		s CardInfo=..GetCardInfoByPatID(PatDr)
		s RegCard=$p(CardInfo,"^",1)_"^"_$p(CardInfo,"^",3)
	}
	Q RegCard
}

/// Desc: 通过患者ID获取卡信息
/// Input: PatID:患者ID
/// OutPut: 空或卡号^卡类型ID^卡类型描述^患者ID^姓名^卡ID
/// Debug:w ##class(DHCDoc.Common.pa).GetAdmRegCard(2155)
ClassMethod GetCardInfoByPatID(PatID)
{
	s RegNo=$p(^PAPER(PatID,"PAT",1),"^",1)				
	s CardInfo=##class(web.DHCOPAdmReg).GetCardNoByPatientNo(RegNo)
	Q CardInfo
}

}
