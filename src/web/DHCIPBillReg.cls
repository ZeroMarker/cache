Import SQLUser

/// 名称: web.DHCIPBillReg.cls
/// 描述: 住院登记类
/// 编写者: ZhYW
/// 编写日期: 2019-04-08
Class web.DHCIPBillReg Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 查询住院科室
/// Table: PAC_AdmTypeLocation
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillReg", "FindIPDept", "", "2")
Query FindIPDept(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,contactName:%String")
{
}

ClassMethod FindIPDeptExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
  	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "InPatReg", .mulHospAry)
	
	set desc=$$ALPHAUP^SSUTIL4(desc)

	set id=0
	while($o(^PAC("ADMLOC",0,"AdmType","I",id))) {
		set id=$o(^PAC("ADMLOC",0,"AdmType","I",id))
		set data=$g(^CTLOC(id))
		continue:(data="")
		set wardFlag=$p(data,"^",5)
		continue:(wardFlag="Y")
		set hospDR=$p(data,"^",22)
		if ($d(mulHospAry("DL"))) {
			continue:('$d(mulHospAry("DL",hospDR)))
			if ($d(mulHospAry("DL",hospDR,"LOC"))) {
				continue:('$d(mulHospAry("DL",hospDR,"LOC",id)))
			}
		}else {
			continue:('$d(mulHospAry(hospDR)))
		}
		set dateFrom=$p(data,"^",24)
		set dateTo=$p(data,"^",25)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		continue:(##class(web.DHCOPAdmReg).CheckLocDesc(id, desc)'=1)
		set dept=$p(data,"^",2)
		set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
		set contactName=$p(data,"^",43)   //科室检索码
		do OutputDept
	}

	quit $$$OK
OutputDept
	set Data=$lb(id,dept,contactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-07-16
/// Description: 查询病区(有预约时，取预约到的病区，否则取住院证上的病区。没有住院证时取科室关联病区)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillReg", "FindWard", "95", "2")
Query FindWard(deptId As %String, IPBookId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindWardExecute(ByRef qHandle As %Binary, deptId As %String, IPBookId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set job=$j
	kill ^||TMP(job)
	do ..GetWard(IPBookId, deptId, job)
	set id=0
	while($o(^||TMP(job,id))) {
		set id=$o(^||TMP(job,id))
		set ward=$p($g(^PAWARD(id)),"^",2)
		set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
		do OutputWard
	}
	kill ^||TMP(job)

	quit $$$OK
OutputWard
	set Data=$lb(id,ward)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

ClassMethod GetWard(IPBookId As %String, deptId As %String, job As %String) As %String
{
	set wardType=""
	if (+IPBookId'=0) {
		set appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(IPBookId)   //预约床位
 		set err=$p(appBedInfo,"^",1)
 		if (+err=0) {
	 		set deptDR=$p(appBedInfo,"^",2)
	 		if (+deptDR'=0) {
		 		set wardDR=$o(^PAWARD(0,"WARD_LocationDR",deptDR,0))
		 		if (+wardDR'=0) {
			 		set ^||TMP(job,wardDR)=""
			 	}
		 	}
			quit 0    //开启了床位预约时,只取预约的床位
			
	 	}else {
			set docIPBookInfo=##class(web.DHCDocIPBookNew).GetBookMesage(IPBookId)
			set wardDR=$p(docIPBookInfo,"^",12)
			if (+wardDR'=0) {
				set ^||TMP(job,wardDR)=""
			}
			set deptDR=$p(docIPBookInfo,"^",14)
			if (+deptDR'=0) {
				set deptId=deptDR
			}
			set wardType=$p(docIPBookInfo,"^",55)
		}
	}
	set defWard=""
	set rset=##class(%ResultSet).%New("web.DHCDocIPBookNew:CombListFind")
	do rset.Execute("InWard", deptId, defWard, wardType)
	while (rset.Next()) {
		set wardDR=$g(rset.Data("CombValue"))
		continue:($d(^||TMP(job,wardDR)))
		set ^||TMP(job,wardDR)=""
	}
	kill rset
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取默认的入院情况
/// Table: PAC_AdmCategory
/// Input: 
/// Return: "非绿色通道"RowID
/// Debug: w ##class(web.DHCIPBillReg).GetDefAdmCatId()
ClassMethod GetDefAdmCatId()
{
	quit $o(^PAC("ADMCAT",0,"Code","02",0))
}

/// Description: 查询患者就诊记录列表
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillReg","FindAdmList", "1", "237")
Query FindAdmList(patientId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "admNo:%String,regNo:%String,patName:%String,admDate:%String,admTime:%String,admDept:%String,admWard:%String,admBed:%String,admStatus:%String,admId:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, patientId As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (patientId="")  quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "InPatReg", .mulHospAry)
	
  	set regNo=$p($g(^PAPER(patientId,"PAT",1)),"^",1)
	set patName=$p($g(^PAPER(patientId,"ALL")),"^",1)
	
	set adm=0
	while($o(^PAPERdr(patientId,"ADM","I",adm))) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm))
		set admNo=$p(^PAADM(adm),"^",81)
		set admDate=$p(^PAADM(adm),"^",6)
		set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
		set admTime=$p(^PAADM(adm),"^",7)
		set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
		set admDeptDR=$p(^PAADM(adm),"^",4)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
		if ($d(mulHospAry("DL"))) {
			continue:('$d(mulHospAry("DL",admHospDR)))
			if ($d(mulHospAry("DL",admHospDR,"LOC"))) {
				continue:('$d(mulHospAry("DL",admHospDR,"LOC",admDeptDR)))
			}
		}else {
			continue:('$d(mulHospAry(admHospDR)))
		}
		set admDept=$p($g(^CTLOC(admDeptDR)),"^",2)
		set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
		set admWardDR=$p(^PAADM(adm),"^",70)
		set admWard=$p($g(^PAWARD(admWardDR)),"^",2)
		set admWard=##class(User.PACWard).GetTranByDesc("WARDDesc", admWard, langId)
		set admBed=##class(web.DHCBillCommon).GetPatBedCode(adm)
		set visitStatus=$p(^PAADM(adm),"^",20)
		set admStatus=$case(visitStatus,"A":"在院","C":"取消住院","P":"预住院","D":"出院",:"未知")
		set admStatus=##class(websys.Translation).Get("", admStatus, langId)
		do OutputAdmList
	}
 	
	quit $$$OK
OutputAdmList
	set Data=$lb(admNo,regNo,patName,admDate,admTime,admDept,admWard,admBed,admStatus,adm)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-11-20
/// Description: 给HIS界面提供获取患者登记信息
/// Input: patientNo:登记号, medicareNo:病案号, IPBookId:DHCDocIPBooking.RowId, sessionStr:操作员Id^安全组Id^登录科室Id^院区Id
/// Debug: w ##class(web.DHCIPBillReg).GetRegInfoToHtml("0000002112","","489","5^241^222^2^1")
ClassMethod GetRegInfoToHtml(patientNo As %String, medicareNo As %String, IPBookId As %String, sessionStr As %String) As %String
{
	set ^TMP("GetRegInfoToHtml")=$lb(patientNo, medicareNo, IPBookId, sessionStr)
		
    set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	set patientId=..GetPatientID(patientNo, medicareNo, hospId)   //通过登记号、住院号获取患者主索引
	
	#dim stream As %Stream.GlobalCharacter
	set stream=..GetRegInfo(patientId, IPBookId, sessionStr)
	do stream.Rewind()
	do stream.OutputToDevice()
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2019-11-20
/// Description: 获取患者登记信息公共方法
/// Input: patientId:PA_PatMas.RowId, IPBookId:DHCDocIPBooking.RowId, sessionStr:操作员Id^安全组Id^登录科室Id^院区Id
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetRegInfo("2124", "", "5^241^222^2^1")
ClassMethod GetRegInfo(patientId As %String, IPBookId As %String, sessionStr As %String) As %Stream.GlobalCharacter
{
	set ^TMP("GetRegInfo")=$lb(patientId, IPBookId, sessionStr)
	
    set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	set stream=##class(%Stream.GlobalCharacter).%New()

	set jsonObj=##class(%DynamicObject).%New()
	if (patientId="") {
	    do jsonObj.%Set("success", -1).%Set("msg", "患者不存在")
	    do jsonObj.%ToJSON(.stream)
		quit stream
	}

    //判断住院证有效性
    if (IPBookId'="") {
	    set rtnValue=##class(web.DHCBillInterface).IIsIPBook(IPBookId)
	    if (rtnValue'="") {
		    set msg=$case($p(rtnValue,"^",1),
		    	"IPBookErr": "住院证不在有效日期范围内，",
		    	"Admission": "患者正在住院，",
		    	"OnceAdmission": "患者曾住院，",
		    	"NotActive": "此住院证已为无效状态，",
		    			   : "")_"不能办理入院"
		    do jsonObj.%Set("success", -1).%Set("msg", msg)
		    do jsonObj.%ToJSON(.stream)
			quit stream
		}
	}
	
	do jsonObj.%Set("success", 0)
	set episodeId=..GetHospAdmitEpisodeID(patientId, hospId)
	
	set patInfo=..GetPatientInfo(patientId, episodeId, sessionStr)
	do jsonObj.%Set("PatInfo", patInfo)
	set admInfo=..GetAdmInfo(episodeId, sessionStr)
	do jsonObj.%Set("AdmInfo", admInfo)
	set IPBookInfo=..GetIPBookingInfo(IPBookId)
	do jsonObj.%Set("IPBookInfo", IPBookInfo)
	
	do jsonObj.%ToJSON(.stream)
	quit stream
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取患者基本信息
/// Input: patientId: PA_PatMas.RowID, episodeId: PA_Adm.RowID
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetPatientInfo("6","6","12173^241^222^2^20")
ClassMethod GetPatientInfo(patientId As %String, episodeId As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID

	set jsonObj={}
	if (+patientId=0) {
		do jsonObj.%Set("success", -1).%Set("msg", "患者不存在")
		quit jsonObj.%ToJSON()
	}
	do jsonObj.%Set("success", 0)
	do jsonObj.%Set("PatientID", patientId)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patientId, "I", hospId, "")
	do jsonObj.%Set("MedicareNo", mrNo)
	
	&SQL(
		SELECT PAPMI_No, PAPMI_Name, PAPMI_DVAnumber, PAPMI_CardType_DR, PAPMI_HealthFundNo, 
			   PAPMI_DOB
		INTO :patientNo, :patName, :credNo, :credTypeDR, :healthFundNo,
			 :birthDate
		FROM PA_PatMas
		WHERE %ID = :patientId
	)
	//登记号
	do jsonObj.%Set("PatientNo", patientNo)
	//患者姓名
	do jsonObj.%Set("Name", patName)
	//证件号
	do jsonObj.%Set("CredNo", credNo)
	//证件类型
	do jsonObj.%Set("CredType", credTypeDR)
	//医保手册号
	do jsonObj.%Set("HealthFundNo", healthFundNo)
	//出生日期
	set birthDateDisplay=##class(websys.Conversions).DateLogicalToHtml(birthDate)
	do jsonObj.%Set("BirthDate", birthDateDisplay)
	
	&SQL(
		SELECT PAPMI_BirthTime, PAPMI_StreetBirth, PAPMI_StreetHouse, PAPMI_StreetNow, PAPMI_CommunityBirth,
			   PAPMI_CommunityHouse, PAPMI_CommunityNow
		INTO :birthTime, :birthStreet, :houseStreet, :street, :birthCommunity,
			 :houseCommunity, :community
		FROM DHC_PA_PatMas
		WHERE %ID = :patientId
	)
	//出生时间
	do jsonObj.%Set("BirthTime", ##class(websys.Conversions).TimeLogicalToHtml(birthTime))
	//2022-09-05 ZhYW 增加街道(出生)、街道(户口)、街道(现住)
	do jsonObj.%Set("Street", street)             //街道(现住)
	do jsonObj.%Set("BirthStreet", birthStreet)   //街道(出生)
	do jsonObj.%Set("HouseStreet", houseStreet)   //街道(户口)
	//+2022-11-15 ZhYW 增加社区(现住)、社区(出生)、社区(户口)
	do jsonObj.%Set("Community", community)             //社区(现住)
	do jsonObj.%Set("BirthCommunity", birthCommunity)   //社区(出生)
	do jsonObj.%Set("HouseCommunity", houseCommunity)   //社区(户口)
		
	//获取患者年龄
	set rtnValue=##class(web.DHCBillInterface).GetPapmiAge(patientId, episodeId, hospId, , , , 1)
	set age=$p(rtnValue,"||",1)
	set ageYear=$p(rtnValue,"||",2)
	set ageMth=$p(rtnValue,"||",3)
	set ageDate=$p(rtnValue,"||",10)
	set ageHour=$p(rtnValue,"||",11)
	set ageMin=$p(rtnValue,"||",12)
	if (+ageMth'=0) {
		//新生儿超过1个月时不显示"天时分"
		set ageDate=""
		set ageHour=""
		set ageMin=""
	}
	do jsonObj.%Set("Age", age)
	do jsonObj.%Set("AgeYear", ageYear)
	do jsonObj.%Set("BabyAgeDate", ageDate)
	do jsonObj.%Set("BabyAgeHour", ageHour)
	do jsonObj.%Set("BabyAgeMinute", ageMin)
	
	&SQL(
		SELECT PAPER_HCP_DR, PAPER_Sex_DR, PAPER_ID, PAPER_Marital_DR, PAPER_Nation_DR,
			   PAPER_Occupation_DR, PAPER_Province_Birth_DR, PAPER_CityBirth_DR, PAPER_ForeignId, PAPER_CT_Province_DR,
			   PAPER_CityCode_DR, PAPER_Country_DR, PAPER_TelO, PAPER_SocialStatus_DR, PAPER_TelH,
			   PAPER_ForeignAddress, PAPER_ForeignCardTypeDR, PAPER_ForeignCountry, PAPER_SecondPhone, $LISTTOSTRING(PAPER_StName),
			   PAPER_MobPhone, PAPER_CityArea_DR, PAPER_CTRLT_DR, PAPER_ForeignPhone, $LISTTOSTRING(PAPER_Remark),
			   PAPER_AreaHome_DR
		INTO :HCPDR, :sexDR, :IDNo, :maritalDR, :nationDR,
		 	 :occupationDR, :provBirthDR, :cityBirthDR, :foreignName, :provDR,
		 	 :cityDR, :countryDR, :workTel, :socSatDR, :homeTel,
		 	 :foreignAddress, :foreignCredTypeDR, :foreignCredNo, :company, :address,
		 	 :mobPhone, :cityAreaDR, :relationDR, :foreignPhone, :remark,
		 	 :homeAreaDR
		FROM PA_Person
		WHERE %ID = :patientId
	)
	//公费单位
	do jsonObj.%Set("HealthCareProvider", HCPDR)
	//公费证号
	set HCPNo=$p($g(^PAPER(patientId,"DHCINS")),"^",2)
	do jsonObj.%Set("HealthCareCardNo", HCPNo)
	//性别
	do jsonObj.%Set("Sex", sexDR)
	//身份证号
	do jsonObj.%Set("IDNo", IDNo)
	//婚姻状况
	do jsonObj.%Set("Marital", maritalDR)
	//民族
	do jsonObj.%Set("Nation", nationDR)
	//职业
	do jsonObj.%Set("Occupation", occupationDR)
	//省(籍贯)
	do jsonObj.%Set("HomeProv", provBirthDR)
	//市(籍贯)
	do jsonObj.%Set("HomeCity", cityBirthDR)
	//县(籍贯)
	do jsonObj.%Set("HomeArea", homeAreaDR)
	//联系人
	do jsonObj.%Set("ForeignName", foreignName)
	//省(现住)
	do jsonObj.%Set("Province", provDR)
	//市(现住)
	do jsonObj.%Set("City", cityDR)
	//国籍/地区
	do jsonObj.%Set("Country", countryDR)
	//联系电话
	do jsonObj.%Set("WorkTel", workTel)
	//患者类别
	do jsonObj.%Set("SocialStatus", socSatDR)
	//联系电话
	do jsonObj.%Set("HomeTel", homeTel)
	//联系人地址
	do jsonObj.%Set("ForeignAddress", foreignAddress)
	//联系人证件类型
	do jsonObj.%Set("ForeignCredType", foreignCredTypeDR)
	//联系人证件号
	do jsonObj.%Set("ForeignCredNo", foreignCredNo)
	//地址(现住)
	do jsonObj.%Set("Address", address)
	//工作单位
	do jsonObj.%Set("Company", company)
	//手机号
	do jsonObj.%Set("MobPhone", mobPhone)
	//县(现住)
	do jsonObj.%Set("CityArea", cityAreaDR)
	//与患者关系
	do jsonObj.%Set("Relation", relationDR)
	//联系人电话
	do jsonObj.%Set("ForeignPhone", foreignPhone)
	//备注
	do jsonObj.%Set("Remark", remark)
	
	set DHCPersonId=$o(^DHCPERSON(0,"PAPERSON",patientId,0))
	&SQL(
		SELECT PAPER_Comment1, PAPER_Comment2, PAPER_Comment3, PAPER_BirthProvince_DR, PAPER_BirthCity_DR,
			   PAPER_BirthArea_dr, PAPER_BirthAddress, PAPER_HouseProvince_DR, PAPER_HouseCity_DR, PAPER_HouseArea_DR,
			   PAPER_HouseAddress
	 	INTO :cZipCode, :hZipCode, :houseZipCode, :birthProvDR, :birthCityDR,
	 	     :birthAreaDR, :birthAddress, :houseProvDR, :houseCityDR, :houseAreaDR,
	 	     :houseAddress
	 	FROM DHC_Person
		WHERE %ID = :DHCPersonId
	)
	//邮编(工作)
	do jsonObj.%Set("CompanyPostCode", cZipCode)
	//邮编(现住)
	do jsonObj.%Set("PostCode", hZipCode)
	//邮编(户口)
	do jsonObj.%Set("HousePostCode", houseZipCode)
	//省(出生)
	do jsonObj.%Set("BirthProv", birthProvDR)
	//市(出生)
	do jsonObj.%Set("BirthCity", birthCityDR)
	//县(出生)
	do jsonObj.%Set("BirthArea", birthAreaDR)
	//地址(出生)
	do jsonObj.%Set("BirthAddress", birthAddress)
	//省(户口)
	do jsonObj.%Set("HouseProv", houseProvDR)
	//市(户口)
	do jsonObj.%Set("HouseCity", houseCityDR)
	//县(户口)
	do jsonObj.%Set("HouseArea", houseAreaDR)
	//地址(户口)
	do jsonObj.%Set("HouseAddress", houseAddress)

	quit jsonObj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取本院区在院就诊RowId
/// Input: patientId: PA_PatMas.RowID, hospId: CT_Hospital.RowID
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetHospAdmitEpisodeID(421, 2)
ClassMethod GetHospAdmitEpisodeID(patientId As %String, hospId As %String) As %String
{
	set episodeId=""
	quit:(+patientId=0) episodeId
	
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "InPatReg", .mulHospAry)
	
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set admData=$g(^PAADM(adm))
		set admDeptDR=$p(admData,"^",4)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
		if ($d(mulHospAry("DL"))) {
			continue:('$d(mulHospAry("DL",admHospDR)))
			if ($d(mulHospAry("DL",admHospDR,"LOC"))) {
				continue:('$d(mulHospAry("DL",admHospDR,"LOC",admDeptDR)))
			}
		}else {
			continue:('$d(mulHospAry(admHospDR)))
		}
		set visitStatus=$p(admData,"^",20)
		continue:(visitStatus'="A")
		set episodeId=adm
		quit
	}
	quit episodeId
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取患者就诊信息
/// Input: episodeId:PA_Adm.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetAdmInfo("7052","12173^241^222^2^20")
ClassMethod GetAdmInfo(episodeId As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	set langId=$p(sessionStr,"^",5)      //登录语言RowID
	
	set jsonObj={}
	set success=0
	do jsonObj.%Set("EpisodeID", episodeId)
	if (+episodeId=0) {
		do jsonObj.%Set("success", -1).%Set("msg", "患者就诊信息不存在")
		quit jsonObj.%ToJSON()
	}
	do jsonObj.%Set("success", 0)
	//病案号(取就诊信息时取病案号是针对病案号根据就诊生成的情况)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(episodeId, "I", "")
	do jsonObj.%Set("MedicareNo", mrNo)
	&SQL(
		SELECT PAADM_DepCode_DR, PAADM_VisitStatus, PAADM_InPatNo, PAADM_CurrentWard_DR, PAADM_AdmDocCodeDR,
			   PAADM_AdmReason_DR, PAADM_Epissubtype_DR, PAADM_CreateUser, PAADM_CreateUser->SSUSR_Name, PAADM_AdmCateg_DR,
			   PAADM_AdmSrc_DR, PAADM_ReferralPriority_DR, PAADM_AdmDate, PAADM_AdmTime, PAADM_MainMRADM_DR
		INTO :admDeptDR, :visitStatus, :inPatTimes, :admWardDR, :admDocDR,
			 :admReaDR, :admEpisDR, :userDR, :userName, :admCatDR,
			 :admSourceDR, :admRefPriorDR, :admDate, :admTime, :mrAdmDR 
		FROM PA_Adm
		WHERE %ID = :episodeId
	)
	//在院状态
	set statusDesc=$case(visitStatus,"A":"在院","C":"取消住院","P":"预住院","D":"出院",:"未知")
	set statusDesc=##class(websys.Translation).Get("", statusDesc, langId)
	do jsonObj.%Set("VisitStatus", statusDesc)
	//住院次数
	do jsonObj.%Set("InPatTimes", inPatTimes)
	//科室
	do jsonObj.%Set("Dept", admDeptDR)
	//病区
	do jsonObj.%Set("Ward", admWardDR)
	//入院医生
	do jsonObj.%Set("Doctor", admDocDR)
	//就诊费别
	do jsonObj.%Set("AdmReason", admReaDR)
	//就诊子类
	do jsonObj.%Set("EpisSubType", admEpisDR)
	//操作员
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	do jsonObj.%Set("User", userName)
	//入院情况
	do jsonObj.%Set("AdmCategory", admCatDR)
	//入院途径
	do jsonObj.%Set("AdmSource", admSourceDR)
	//入院病情
	do jsonObj.%Set("AdmReferPriority", admRefPriorDR)
	//入院日期
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	do jsonObj.%Set("AdmDate", admDate)
	//入院时间
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	do jsonObj.%Set("AdmTime", admTime)
	
	set editMRDiag=0
	set mrICDCodeDR="", mrDiagRemark="", mrDiagTypeDR=""
	if ('$d(^DHCDocIPBK(0,"EpisodeIDTo",episodeId))) {
		//如果不是根据住院证办理的入院，则显示诊断信息
		set editMRDiag=1
		set mrAdmSub=$s((+mrAdmDR'=0):$o(^MR(mrAdmDR,"DIA",0)),1:"")
		if (+mrAdmSub'=0) {
			set mrICDCodeDR=$p($g(^MR(mrAdmDR,"DIA",mrAdmSub)),"^",1)       //MR_Diagnos.MRDIA_ICDCode_DR
			set mrDiagRemark=$g(^MR(mrAdmDR,"DIA",mrAdmSub,"DES",1))        //MR_Diagnos.MRDIA_Desc
			set mrDiagTypeId=$o(^MR(mrAdmDR,"DIA",mrAdmSub,"TYP",0))
			if (+mrDiagTypeId'=0) {
				set mrDiagTypeDR=$p($g(^MR(mrAdmDR,"DIA",mrAdmSub,"TYP",mrDiagTypeId)),"^",1)
			}
		}
	}
	do jsonObj.%Set("AdmDiagnos", mrICDCodeDR)      //第一条诊断
	do jsonObj.%Set("DiagRemark", mrDiagRemark)     //第一条诊断备注
	if (+mrDiagTypeDR=0) {
		set mrDiagTypeDR=..GetRegDiagTypeId()
	}
	do jsonObj.%Set("DiagnosType", mrDiagTypeDR)   //诊断类型
	do jsonObj.%Set("EditMRDiag", editMRDiag, "boolean")   //+2023-01-19 ZhYW 住院登记页面能否修改诊断

	&SQL(
		SELECT PAADM_RegConDis_DR, PAADM_AdviseDocDr, $LISTTOSTRING(PAADM_Remarks)
		INTO :regCDiscDR, :adviseDocDR, :admRemark
		FROM PA_AdmExt
		WHERE %ID = :episodeId
	)
	//优惠类型
	do jsonObj.%Set("RegConDisc", regCDiscDR)
	//推荐医生
	do jsonObj.%Set("AdviseDoc", adviseDocDR)   //+2022-08-30 ZhYW 增加推荐医生
	//就诊备注(患者便签)
	do jsonObj.%Set("AdmRemark", admRemark)    //+2022-09-02 ZhYW 增加就诊备注(患者便签)

	quit jsonObj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取住院证信息
/// Input: IPBookId: DHCIPBooking.RowID
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetIPBookingInfo(421)
ClassMethod GetIPBookingInfo(IPBookId As %String) As %String
{
	set jsonObj={}
	do jsonObj.%Set("IPBookID", IPBookId)
	do jsonObj.%Set("EditMRDiag", 0, "boolean")   //+2023-01-19 ZhYW 住院登记页面能否修改诊断
	if (+IPBookId=0) {
		do jsonObj.%Set("success", -1).%Set("msg", "住院证信息不存在")
		quit jsonObj.%ToJSON()
	}
	
	set rtnValue=..GetIPBookInfo(IPBookId)
	set episodeIdTo=$p(rtnValue,"^",4)        //转入住院就诊
	set creatUserDR=$p(rtnValue,"^",7)        //开住院证人
	set wardDR=$p(rtnValue,"^",12)
	set deptDR=$p(rtnValue,"^",14)
	set depositSum=$p(rtnValue,"^",18)        //建议押金
	set admRefPriorDR=$p(rtnValue,"^",21)     //入院病情
	set statusDesc=$p(rtnValue,"^",26)        //状态描述
	set admSourceDR=$p(rtnValue,"^",23)       //入院途径
	set docDR=$p(rtnValue,"^",43)
	
	do jsonObj.%Set("success", 0)
	do jsonObj.%Set("EpisodeID", episodeIdTo)
	//2022-08-30 ZhYW 开住院证医生(推荐医生)
	do jsonObj.%Set("AdviseDoc", $s((+creatUserDR'=0):$p($g(^SSU("SSUSR",creatUserDR)),"^",14),1:""))
	do jsonObj.%Set("VisitStatus", statusDesc)
	do jsonObj.%Set("Dept", deptDR)
	do jsonObj.%Set("Ward", wardDR)
	do jsonObj.%Set("Doctor", docDR)
	do jsonObj.%Set("SuggestDepAmt", depositSum)
	
	do jsonObj.%Set("AdmReferPriority", admRefPriorDR)
	do jsonObj.%Set("AdmSource", admSourceDR)
	
	//2020-11-30 ZhYW 判断住院证上的实际入院日期和入院时间
	set bookingInDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetIPBookingInAdmDateTime", IPBookId)
	set bookingInDate=$p(bookingInDateTime,"^",1)
	set bookingInTime=$p(bookingInDateTime,"^",2)
	if (bookingInDate'="") {
		do jsonObj.%Set("AdmDate", bookingInDate)
	}
	if (bookingInTime'="") {
		do jsonObj.%Set("AdmTime", bookingInTime)
	}
	
	quit jsonObj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取患者默认费别
/// Input: patientId: PA_PatMas.RowID, hospId: CT_Hospital.RowID
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetPatDefInsTypeId(839, 2)
ClassMethod GetPatDefInsTypeId(patientId As %String, hospId As %String) As %String
{
	//取最近一次住院就诊取默认费别
	set lastAdm=..GetLastIPAdm(patientId, hospId)
	set admReaDR=$s((+lastAdm'=0):$p($g(^PAADM(lastAdm,1)),"^",7),1:"")
	if ('..IsGetInsTypeOfPACAdm(hospId)) {
		//就诊费别是否取患者类别默认的费别
		quit admReaDR
	}
	//根据患者类别取默认费别
	set socSatDR=$p($g(^PAPER(patientId,"PER",1)),"^",10)   //PA_Person.PAPER_SocialStatus_DR
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_PACADM", hospId)
	set pacAdmDR=0
	while($o(^DHCPACADM(0,"Social",socSatDR,pacAdmDR))&&(admReaDR="")) {
		set pacAdmDR=$o(^DHCPACADM(0,"Social",socSatDR,pacAdmDR))
		set pacAdmData=$g(^DHCPACADM(pacAdmDR))
		set hospDR=$p(pacAdmData,"^",5)
		continue:(hospDR'=defHospId)
		set dateFrom=$p(pacAdmData,"^",3)
		set dateTo=$p(pacAdmData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set pacAdmReaDR=$p(pacAdmData,"^",2)
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", pacAdmReaDR, hospId)
		continue:(showFlag="N")
		set admReaDR=pacAdmReaDR
	}
	quit admReaDR
}

/// Creator: ZhYW
/// CreatDate: 2021-05-20
/// Description: 根据费别取默认患者类别
/// Input: insTypeId:PAC_AdmReason.RowId, hospId:CT_Hospital.RowId
/// Return: DHC_PACADM.RowId
/// Table: DHC_PACADM
/// Debug: w ##class(web.DHCIPBillReg).GetDefSocStatIdByInsType(1, 2)
ClassMethod GetDefSocStatIdByInsType(insTypeId As %String, hospId As %String) As %String
{
	set socStatId=""
	quit:(insTypeId="") socStatId
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_PACADM", hospId)
	set rowId=0
	while($o(^DHCPACADM(0,"AdmReason",insTypeId,rowId))&&(socStatId="")) {
		set rowId=$o(^DHCPACADM(0,"AdmReason",insTypeId,rowId))
		set pacAdmData=$g(^DHCPACADM(rowId))
		set hospDR=$p(pacAdmData,"^",5)
		continue:(hospDR'=defHospId)
		set dateFrom=$p(pacAdmData,"^",3)
		set dateTo=$p(pacAdmData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set socStatId=$p(pacAdmData,"^",1)
	}
  
	quit socStatId
}

/// Creator: ZhYW
/// CreatDate: 2018-06-05
/// Description: 根据住院证ID取住院证信息
/// Input: IPBookID: DHCDocIPBooking.RowID
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetIPBookInfo(421)
ClassMethod GetIPBookInfo(IPBookID As %String) As %String
{
	set rtn=""
	quit:(IPBookID="") rtn
	set rtn=##class(web.DHCDocIPBookNew).GetBookMesage(IPBookID)
	//+2018-07-16 ZhYW 有预约到床位时，取预约的病区
	set appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(IPBookID)   //预约床位
	set err=$p(appBedInfo,"^",1)
	if (+err=0) {
		set deptDR=$p(appBedInfo,"^",2)
		if (+deptDR'=0) {
			set wardDR=$o(^PAWARD(0,"WARD_LocationDR",deptDR,0))
			if (+wardDR'=0) {
				set $p(rtn,"^",12)=wardDR
			}
		}
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 获取患者在院就诊
/// Input: patientId:PA_PatMas.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetAdmitEpisodeID(3)
ClassMethod GetAdmitEpisodeID(patientId As %String) As %String
{
	set episodeId=""
	set lastAdm=$o(^PAPERdr(patientId,"ADM","I",""),-1)
	quit:(+lastAdm=0) episodeId
	
	set admStatus=$p(^PAADM(lastAdm),"^",20)
	if (admStatus="A") {
		set episodeId=lastAdm
		quit episodeId
	}
	
	if (admStatus="D") {
		set disDateInfo=##class(web.DHCDischargeHistory).GetDischargeDateTime(lastAdm)
		set disDate=$p(disDateInfo,"^",1)
		if (disDate>+$h) {
			set episodeId=lastAdm
		}
	}
	quit episodeId
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 通过登记号、住院号获取患者主索引
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetPatientID("0000000147", "500900", "2")
ClassMethod GetPatientID(patientNo As %String, medicareNo As %String, hospId As %String) As %String
{
	set patientId=""
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set patientId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patientNo),0))
		quit patientId
	}
	if (medicareNo'="") {
		set patientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
		quit patientId
	}
	quit patientId
}

/// Description: 判断是否有未出院就诊
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Debug: w ##class(web.DHCIPBillReg).JudgeAdmStatus(3, 2)
ClassMethod JudgeAdmStatus(patientId As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(patientId="") rtn
	
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set visitStatus=$p($g(^PAADM(adm)),"^",20)
		if (visitStatus="P") {
			set rtn=-1_"^"_"患者有预住院状态就诊"
			quit
		}
		set admStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
		continue:(" R B "'[(" "_admStatusCode_" "))
		set rtn=-1_"^"_"患者有"_$case(admStatusCode,"R":"护士撤销出院","B":"费用调整",:"")_"状态就诊"
		quit
	}

	quit rtn
}

/// Description: 判断是否有欠费结算记录
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Return: -1^有欠费结算账单
/// Debug: w ##class(web.DHCIPBillReg).JudgeQFChged(3, 2)
ClassMethod JudgeQFChged(patientId As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(+patientId=0) rtn
	
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:(visitStatus="C")   //过滤退院的就诊
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set amount=##class(web.UDHCJFQFDEAL).getqfamount(adm)
		if (+amount'=0) {
			set rtn=-1_"^"_"患者有欠费结算账单"
			quit
		}
	}
	
	quit rtn
}

/// Description: 判断是否有未结算账单
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Return: -1^有未结算账单
/// Debug: w ##class(web.DHCIPBillReg).JudgeUnChged(3, 2)
ClassMethod JudgeUnChged(patientId As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(+patientId=0) rtn
	
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:(visitStatus="C")   //过滤退院的就诊
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set pb=0
		while($o(^DHCPB(0,"ADM",adm,pb))) {
			set pb=$o(^DHCPB(0,"ADM",adm,pb))
			set pbAmt=$p(^DHCPB(pb),"^",8)
			continue:(+pbAmt=0)
			set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(pb)
			continue:(+prtRowId'=0)
			set rtn=-1_"^"_"患者有未结算账单"
			quit
		}
		quit:(+rtn)
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-11-25
/// Descripton: 入院登记
/// Debug: w ##class(web.DHCIPBillReg).SaveRegInfo("<PAPerson><Address></Address><Age>22岁</Age><City>146</City><CityArea>1389</CityArea><Company></Company><Country>1</Country><ForeignAddress></ForeignAddress><ForeignCredNo></ForeignCredNo><ForeignCredType>20</ForeignCredType><ForeignName></ForeignName><ForeignPhone></ForeignPhone><HealthCareProvider></HealthCareProvider><HomeCity>137</HomeCity><HomeProv>15</HomeProv><HomeTel>15125253636</HomeTel><IDNo></IDNo><Marital></Marital><MobPhone>15125253636</MobPhone><Name>张琳娜</Name><Nation></Nation><Occupation></Occupation><PatientID>2</PatientID><PhotoStream></PhotoStream><Province>15</Province><Relation></Relation><Sex>2</Sex><SocialStatus>1</SocialStatus><WorkTel></WorkTel></PAPerson>","<PAPersonExp><BirthAddress></BirthAddress><BirthArea></BirthArea><BirthCity></BirthCity><BirthDate>2000-06-27</BirthDate><BirthProv></BirthProv><BirthStreet></BirthStreet><BirthTime></BirthTime><CompanyPostCode></CompanyPostCode><CredNo>1122334455</CredNo><CredType>21</CredType><HealthCareCardNo></HealthCareCardNo><HealthFundNo></HealthFundNo><HouseAddress></HouseAddress><HouseArea></HouseArea><HouseCity></HouseCity><HousePostCode></HousePostCode><HouseProv></HouseProv><HouseStreet></HouseStreet><PostCode></PostCode><Remark></Remark><Street></Street></PAPersonExp>", "<PAAdm><AdmCategory>2</AdmCategory><AdmDate>2022-09-16</AdmDate><AdmDiagnos></AdmDiagnos><AdmDiagnosCat></AdmDiagnosCat><AdmReason>1</AdmReason><AdmReferPriority></AdmReferPriority><AdmRemark></AdmRemark><AdmSource></AdmSource><AdmTime>22:56:41</AdmTime><AdviseDoc></AdviseDoc><Bed></Bed><Dept>51</Dept><DiagRemark></DiagRemark><DiagnosType>3</DiagnosType><Doctor></Doctor><EpisSubType></EpisSubType><EpisodeID></EpisodeID><IPBookID></IPBookID><RegConDisc></RegConDisc><Room></Room><SuggestDepAmt></SuggestDepAmt><VisitStatus></VisitStatus><Ward>36</Ward></PAAdm>", "17275^240^2^2", "")
ClassMethod SaveRegInfo(personXML As %String, personExpXML As %String, admXML As %String, sessionStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("PersonXML")=personXML
	set ^TMP("PersonExpXML")=personExpXML
	set ^TMP("AdmXML")=admXML
	set ^TMP("SessionStr")=sessionStr
	
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	set photoStream=$p(expStr,"^",1)      //照片信息(Base64编码串)
	
	set personObj=##class(BILL.IP.DTO.Entity.Reg.PAPerson).%New()
	do personObj.XMLDeserialize(.personObj, personXML)
	if (photoStream'="") {
		set personObj.PhotoStream=photoStream
	}
	
	set personExpObj=##class(BILL.IP.DTO.Entity.Reg.PAPersonExp).%New()
	do personExpObj.XMLDeserialize(.personExpObj, personExpXML)
	
	set admObj=##class(BILL.IP.DTO.Entity.Reg.PAAdm).%New()
	do admObj.XMLDeserialize(.admObj, admXML)
	
	set rtn=0
	set msg="办理入院成功"
	
	//验证保存信息
	set rtnValue=..CheckRegData(.personObj, .personExpObj, .admObj, sessionStr)   //+2022-11-24 ZhYW 改为传引用，是因为在此方法中对某些属性值做了修正
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) quit rtnValue

  	ts
  	
  	set rtnValue=..SavePatInfo(personObj, personExpObj, admObj, sessionStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set patientId=$p(rtnValue,"^",2)
	
	set rtnValue=..SaveAdmInfo(patientId, admObj, sessionStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	set adm=$p(rtnValue,"^",2)
	
	if ($tl>0) tc
	
	set mrNo=""
	//病案接诊、分配病案号
	set rtnValue=##class(DHCWMR.IO.ToOutService).IGroupReceipt(adm, mrNo, ctLocId, userId)
	if ($p(rtnValue,"^",1)'=1) {
		set msg=msg_"，接诊失败。病案组接口[DHCWMR.IO.ToOutService||IGroupReceipt("_$lts($lb(adm, mrNo, ctLocId, userId))_")]失败:"_$tr(rtnValue,"^","＾")_"，请手工接诊"
	}
	
	//+2023-02-23 ZhYW 住院登记后推送服务
	do ##class(BILL.IP.BL.SendSrv).SendRegInfo(adm, sessionStr)
  	
	quit rtn_"^"_msg_"^"_patientId_"^"_adm

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-11-14
/// Description: 保存患者基本信息
/// Input: sessionStr:操作员^安全组^登录科室^登录医院, isUpdtOpt:是否修改操作标识(0:新增, 1:修改)
/// Return: 
ClassMethod SavePatInfo(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, personExpObj As BILL.IP.DTO.Entity.Reg.PAPersonExp, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, sessionStr As %String, isUpdtOpt As %String = 0) As %String
{
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID
	
	set patientId=personObj.PatientID
	
	set patJson={}
	if (+patientId'=0) {
		set patJsonStr=..GetPatientInfo(patientId, admObj.EpisodeID, sessionStr)
		set patJson={}.%FromJSON(patJsonStr)
		set patJson.BirthDate=##class(websys.Conversions).DateHtmlToLogical(patJson.BirthDate)
		set patJson.BirthTime=##class(websys.Conversions).TimeHtmlToLogical(patJson.BirthTime)
	}
	
	set isNewPatient=(+patientId=0)     //是否是新入院患者标识
	
	//+2023-04-11 ZhYW 获取修改前的日志内容数据
	set oldDataJson=""
	if ('isNewPatient) {
		set DHCPersonID=$o(^DHCPERSON(0,"PAPERSON",patientId,0))
		set oldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_patientId_"^"_"User.PAPerson"_$c(2)_patientId_"^"_"User.DHCPAPatMas"_$c(2)_patientId_"^"_"User.DHCPerson"_$c(2)_DHCPersonID)
	}
	
	ts
	
	//2022-10-21 ZhYW 根据配置判断住院次数是否需要递增
	set isIncremental=..IsIncreaseInTimes(admObj.Dept)
	if (+patientId=0) {
		set inPatTimes=(isIncremental=1)       //2022-10-21 ZhYW 入院次数(需要递增时默认为1，否则为0)
		set objectPAPerson=##class(User.PAPerson).%New()
	}else {
		set inPatTimes=$p($g(^PAPER(patientId,"PER",4)),"^",8)
		if (isUpdtOpt=0) {
			set inPatTimes=$i(inPatTimes, (isIncremental=1))    //入院次数需要递增时+1
		}
		set objectPAPerson=##class(User.PAPerson).%OpenId(patientId, 0)
	}
	if ('$isObject(objectPAPerson)) {
		tro
		quit ..GetErrMsg(-1, "患者基本信息表不存在")
	}
	set objectPAPerson.PAPERName=personObj.Name
	set objectPAPerson.PAPERName2=##class(ext.util.String).ToChineseSpell(personObj.Name)
	set perName3=##class(web.DHCINSUPort).GetCNCODE(personObj.Name, 3, "")
	//Name3与Name 公用一个索引，这个为了防止Name3的索引把Name的索引置空，保证在Name有值时，Name3也必须有值
	set objectPAPerson.PAPERName3=$s((perName3'=""):perName3,1:personObj.Name)
	do objectPAPerson.PAPERSexDRSetObjectId(personObj.Sex)
	set objectPAPerson.PAPERID=personObj.IDNo    //身份证号
	do objectPAPerson.PAPERMaritalDRSetObjectId(personObj.Marital)
	set objectPAPerson.PAPERTelH=personObj.HomeTel
	set objectPAPerson.PAPERSecondPhone=personObj.Company
	set objectPAPerson.PAPERTelO=personObj.WorkTel
	do objectPAPerson.PAPERCTProvinceDRSetObjectId(personObj.Province)
	set objectPAPerson.PAPERMobPhone=personObj.MobPhone
	do objectPAPerson.PAPERCityCodeDRSetObjectId(personObj.City)
	do objectPAPerson.PAPERUserUpdateSetObjectId(userId)
	set objectPAPerson.PAPERUpdateDate=+$h
	set objectPAPerson.PAPERUpdateTime=$p($h,",",2)
	//特定值
	set objectPAPerson.PAPEREstDOB="N"
	set objectPAPerson.PAPERIncompleteRegistration="N"
	//
	if (+patientId=0) {
		set objectPAPerson.PAPERDateAdded=+$h
		do objectPAPerson.PAPERUserAddedDRSetObjectId(userId)
		do objectPAPerson.PAPERSocialStatusDRSetObjectId(personObj.SocialStatus)
	}
	do objectPAPerson.PAPERNationDRSetObjectId(personObj.Nation)
	do objectPAPerson.PAPERCountryDRSetObjectId(personObj.Country)
	do objectPAPerson.PAPEROccupationDRSetObjectId(personObj.Occupation)
	do objectPAPerson.PAPERProvinceBirthDRSetObjectId(personObj.HomeProv)   //省(籍贯)
	do objectPAPerson.PAPERCityBirthDRSetObjectId(personObj.HomeCity)       //市(籍贯)
	do objectPAPerson.PAPERAreaHomeDRSetObjectId(personObj.HomeArea)   //+2022-11-15 ZhYW 县(籍贯)
	do objectPAPerson.PAPERCTRLTDRSetObjectId(personObj.Relation)
	set objectPAPerson.PAPERForeignId=personObj.ForeignName
	set objectPAPerson.PAPERForeignPhone=personObj.ForeignPhone
	set objectPAPerson.PAPERForeignAddress=personObj.ForeignAddress
	do objectPAPerson.PAPERForeignCardTypeDRSetObjectId(personObj.ForeignCredType)
	set objectPAPerson.PAPERForeignCountry=personObj.ForeignCredNo
	do objectPAPerson.PAPERCityAreaDRSetObjectId(personObj.CityArea)
	set objectPAPerson.PAPERExemptionNumber=inPatTimes
	do objectPAPerson.PAPERHCPDRSetObjectId(personObj.HealthCareProvider)
	do objectPAPerson.PAPERStName.Clear()
	do objectPAPerson.PAPERStName.Insert(personObj.Address)    //地址(现住)
	set objectPAPerson.PAPERPhoto=personObj.PhotoStream
	if ('objectPAPerson.PAPERHospitalDR) {
		do objectPAPerson.PAPERHospitalDRSetObjectId(hospId)
	}
	do objectPAPerson.PAPERRemark.Clear()
	do objectPAPerson.PAPERRemark.Insert(personExpObj.Remark)   //备注
	set sc=objectPAPerson.%Save()
	set patientId=objectPAPerson.%Id()
	do objectPAPerson.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	set personObj.PatientID=patientId   //+2022-12-13 ZhYW 重新给患者主索引赋值

	set $p(^PAPER(patientId,"DHCINS"),"^",2)=personExpObj.HealthCareCardNo   //公费证号
	
	set objectPatMas=##class(User.PAPatMas).%OpenId(patientId, 0)
	if (isNewPatient) {
		//lock +^PAPER(0,"CNT","I"):0  else  quit ..GetErrMsg(-110, "加锁失败")
		set myMaxNo=$i(^PAPER(0,"CNT","I"))
		//lock -^PAPER(0,"CNT","I")
		set myMaxNo=##class(web.UDHCJFBaseCommon).regnocon(myMaxNo)
		set objectPatMas.PAPMINo=myMaxNo
		set objectPatMas.PAPMIIPNo=myMaxNo
		set objectPatMas.PAPMIOPNo=myMaxNo
	}
	do objectPatMas.PAPMICardTypeDRSetObjectId(personExpObj.CredType)
	set objectPatMas.PAPMIDVAnumber=personExpObj.CredNo
	set objectPatMas.PAPMIHealthFundNo=personExpObj.HealthFundNo
	set objectPatMas.PAPMIDOB=personExpObj.BirthDate
	set objectPatMas.PAPMIActive="Y"
	set sc=objectPatMas.%Save()
	do objectPatMas.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}

	set objectDHCPatMas=##class(User.DHCPAPatMas).%OpenId(patientId, 0)
	set objectDHCPatMas.PAPMIBirthTime=personExpObj.BirthTime     //婴儿出生时间
	//2022-09-05 ZhYW 增加街道(出生)、街道(户口)、街道(现住)
	do objectDHCPatMas.PAPMIStreetBirthSetObjectId(personExpObj.BirthStreet)
	do objectDHCPatMas.PAPMIStreetHouseSetObjectId(personExpObj.HouseStreet)
	do objectDHCPatMas.PAPMIStreetNowSetObjectId(personExpObj.Street)
	//2022-11-15 ZhYW 增加社区(出生)、社区(户口)、社区(现住)
	do objectDHCPatMas.PAPMICommunityBirthSetObjectId(personExpObj.BirthCommunity)
	do objectDHCPatMas.PAPMICommunityHouseSetObjectId(personExpObj.HouseCommunity)
	do objectDHCPatMas.PAPMICommunityNowSetObjectId(personExpObj.Community)
	set sc=objectDHCPatMas.%Save()
	do objectDHCPatMas.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	set DHCPersonID=$o(^DHCPERSON(0,"PAPERSON",patientId,0))
	if (+DHCPersonID=0) {
		set objectDHCPerson=##class(User.DHCPerson).%New()
	}else {
		set objectDHCPerson=##class(User.DHCPerson).%OpenId(DHCPersonID, 0)
	}
	do objectDHCPerson.PAPERPaPersondrSetObjectId(patientId)
	set objectDHCPerson.PAPERComment1=personExpObj.CompanyPostCode        //邮编(工作)
	set objectDHCPerson.PAPERComment2=personExpObj.PostCode               //邮编(现住)
	set objectDHCPerson.PAPERBirthProvinceDR=personExpObj.BirthProv       //省(出生)
	set objectDHCPerson.PAPERBirthCityDR=personExpObj.BirthCity           //市(出生)
	set objectDHCPerson.PAPERBirthAreadr=personExpObj.BirthArea           //县(出生)
	set objectDHCPerson.PAPERBirthAddress=personExpObj.BirthAddress       //地址(出生)
	set objectDHCPerson.PAPERHouseProvinceDR=personExpObj.HouseProv       //省(户口)
	set objectDHCPerson.PAPERHouseCityDR=personExpObj.HouseCity           //市(户口)
	set objectDHCPerson.PAPERHouseAreaDR=personExpObj.HouseArea           //县(户口)
	set objectDHCPerson.PAPERHouseAddress=personExpObj.HouseAddress       //地址(户口)
	set objectDHCPerson.PAPERComment3=personExpObj.HousePostCode          //邮编(户口)
	set sc=objectDHCPerson.%Save()
	do objectDHCPerson.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	//保存修改日志
	if ('isNewPatient) {
		set rtnValue=..SaveUpdtPatLog(personObj, personExpObj, admObj, patJson, userId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	if ($tl>0) tc
	
	if ('isNewPatient) {
		//+2023-04-11 ZhYW 获取修改后的日志内容数据
		set newDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAPatMas"_$c(2)_patientId_"^"_"User.PAPerson"_$c(2)_patientId_"^"_"User.DHCPAPatMas"_$c(2)_patientId_"^"_"User.DHCPerson"_$c(2)_DHCPersonID)
		//调用医生站接口保存修改日志
		do ##class(web.DHCDocDataChangeLog).SaveLog("PA_PatMas#PA_Person#DHC_PA_PatMas#DHC_Person", "User.PAPatMas#User.PAPerson", "患者基本信息", "User.PAPatMas#User.PAPerson_"_patientId, personObj.Name, "U", newDataJson, oldDataJson, userId)
	}
	
	quit ..GetErrMsg(0, patientId)
}

/// Creator: ZhYW
/// CreatDate: 2019-11-14
/// Description: 保存患者就诊信息
ClassMethod SaveAdmInfo(patientId As %String, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID
	
	set inPatTimes=$p($g(^PAPER(patientId,"PER",4)),"^",8)
	//2022-10-21 ZhYW 根据配置判断住院次数是否需要递增
	set isIncremental=..IsIncreaseInTimes(admObj.Dept)
	//配置为"按院区计算住院次数"时根据就诊计算住院次数
	set calcInTimesByHosp=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "CalcInTimesByHosp")
  	if (calcInTimesByHosp="Y") {
	  	set lastAdm=..GetLastIPAdm(patientId, hospId)
	  	set lastAdmTimes=$s((+lastAdm'=0):$p($g(^PAADM(lastAdm)),"^",29),1:0)
	  	set inPatTimes=$i(lastAdmTimes, (isIncremental=1))   //入院次数需要递增时+1
	}

	ts
	
	kill insAdmAry
	set insAdmAry(1)=patientId
	set insAdmAry(2)="I"
	set insAdmAry(3)=admObj.AdmDate
	set insAdmAry(4)=admObj.AdmTime
	set insAdmAry(5)=admObj.Dept
	set insAdmAry(6)=admObj.Doctor
	set insAdmAry(7)=admObj.AdmReason
	set insAdmAry(8)=userId
	set insAdmAry(9)=admObj.Ward
	set insAdmAry(10)=admObj.Room
	set insAdmAry(11)=admObj.Bed
	set insAdmAry(12)=admObj.EpisSubType
	set insAdmAry(13)=admObj.AdmCategory          //入院情况
	set insAdmAry(14)=""
	set insAdmAry(15)=admObj.AdmDiagnosCat        //特病类别关联
	set insAdmAry(16)=""
	set insAdmAry(17)=inPatTimes                  //住院次数
	set insAdmAry(18)=admObj.AdmSource
	set insAdmAry(19)=""
	set insAdmAry(20)=""
	set insAdmAry(21)=admObj.RegConDisc
	set insAdmAry(22)=admObj.AdmReferPriority      //入院病情
	
	set insAdmStr=##class(ext.util.String).Join(.insAdmAry, "^")
	set rtnValue=##class(web.DHCPAADM).ADMInsert(insAdmStr)
	set admId=+rtnValue
	if (admId'>0) tro  quit ..GetErrMsg(-1, "医生站组接口[web.DHCPAADM||ADMInsert("_$lts($lb($tr(insAdmStr,"^","＾")))_")]失败:"_rtnValue)
	
	//+2022-08-30 ZhYW 增加推荐医生
	set objectAdmExt=##class(User.PAAdmExt).%OpenId(admId, 0)
	do objectAdmExt.PAADMAdviseDocDrSetObjectId(admObj.AdviseDoc)      //推荐医生
	do objectAdmExt.PAADMRemarks.Clear()
	do objectAdmExt.PAADMRemarks.Insert(admObj.AdmRemark)    //2022-09-02 ZhYW 就诊备注(患者便签)
	set sc=objectAdmExt.%Save()
	do objectAdmExt.%Close()
	if $$$ISERR(sc) {
		tro
  		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
  	}
	
	//新增长效诊断标识
	set rtnValue=##class(DHCDoc.Interface.Inside.Service).InsertPALongICD(admId, userId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit ..GetErrMsg(rtn, "医生站组接口[DHCDoc.Interface.Inside.Service||InsertPALongICD("_$lts($lb(admId, userId))_")]失败:"_rtnValue)
	
	set rtn=##class(web.DHCDischargeHistory).SaveAdminDateTime(admId, admObj.AdmDate, admObj.AdmTime, 1, admObj.Dept, admObj.Ward)
	if (+rtn=-2) tro  quit ..GetErrMsg(rtn, "护理组接口[web.DHCDischargeHistory||SaveAdminDateTime("_$lts($lb(admId, admObj.AdmDate, admObj.AdmTime, 1, admObj.Dept, admObj.Ward))_")]失败:"_rtnValue)
	
	set objectTrans=##class(User.PAAdmTransaction).%New(admId)
	do objectTrans.TRANSParRefSetObjectId(admId)
	set objectTrans.TRANSStartDate=admObj.AdmDate
	set objectTrans.TRANSStartTime=admObj.AdmTime
	do objectTrans.TRANSCTCPDRSetObjectId(admObj.Doctor)
	do objectTrans.TRANSCTLOCDRSetObjectId(admObj.Dept)
	do objectTrans.TRANSWardDRSetObjectId(admObj.Ward)
	set transReqStatusDR=$o(^PAC("REQST",0,"Code","T",0))    //Transfer
	do objectTrans.TRANSStatusDRSetObjectId(transReqStatusDR)
	set objectTrans.TRANSMain="Y"
	set objectTrans.TRANSUpdateDate=+$h
	set objectTrans.TRANSUpdateTime=$p($h,",",2)
	do objectTrans.TRANSUpdateUserDRSetObjectId(userId)
	set sc=objectTrans.%Save()
	set transactionId=objectTrans.%Id()
	do objectTrans.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	set objectWardAdm=##class(User.PACWardAdm).%New(admObj.Ward)
	do objectWardAdm.WADMParRefSetObjectId(admObj.Ward)
	do objectWardAdm.WADMPAADMDRSetObjectId(admId)
	set objectWardAdm.WADMBookedStatus="O"
	do objectWardAdm.WADMTransDRSetObjectId(transactionId)
	set sc=objectWardAdm.%Save()
	do objectWardAdm.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
  	
	if (+admObj.IPBookID'=0) {
		//更新住院证状态
		set rtnValue=##class(web.DHCDocIPBookingCtl).PatientArrive(admObj.IPBookID, admId, userId)
	  	set rtn=$p(rtnValue,"^",1)
	  	if (+rtn) tro  quit ..GetErrMsg(rtn, "医生站组接口[web.DHCDocIPBookingCtl||PatientArrive("_$lts($lb(admObj.IPBookID, admId, userId))_")]失败:"_rtnValue)
		//将住院证上的诊断带到住院就诊
	  	set rtnValue=##class(web.DHCDocIPBookNew).InserDiagenoseBill(admObj.IPBookID, userId)
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit ..GetErrMsg(rtn, "医生站组接口[web.DHCDocIPBookNew||InserDiagenoseBill("_$lts($lb(admObj.IPBookID, userId, admObj.Doctor))_")]失败:"_rtnValue)
	} else {
		if ((+admObj.AdmDiagnos'=0)||(admObj.DiagRemark'="")) {
			set mrAdmDR=$p(^PAADM(admId),"^",61)
	  		set rtnValue=..InsertOneMRDiagnos(mrAdmDR, admObj.AdmDiagnos, admObj.DiagRemark, admObj.DiagnosType, admObj.Doctor, sessionStr)
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) tro  quit rtnValue
		}
	}

	if ($tl>0) tc
	
	quit ..GetErrMsg(0, admId)
}

/// Creator: ZhYW
/// CreatDate: 2023-01-19
/// Description: 保存诊断
/// Input: mrAdm:MR_Adm.RowId, mrDiagId:MRC_ICDDx.RowId, mrDiaDesc:诊断备注, mrDiagTypeId:诊断类型Id, docId:下诊断医生Id(CT_CareProv.RowId), sessionStr:操作员Id^安全组Id^登录科室Id^登录医院Id
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).InsertOneMRDiagnos()
ClassMethod InsertOneMRDiagnos(mrAdm As %String, mrDiagId As %String, mrDiaDesc As %String, mrDiagTypeId As %String, docId As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID

	set docUserId=$o(^SSU("SSUSR",0,"CTPCP",docId,0))
	set diagStatusDR=$o(^MRC("DSTAT",0,"Code","01",0))
	set rtnValue=##class(web.DHCDocDiagnosEntryV8).InsertOneMRDiagnos(ctLocId, mrAdm, mrDiagId, userId, mrDiaDesc, mrDiagTypeId, "", "", "", "",  "", diagStatusDR, "", docUserId, "N", "", "", "", +$h, "", +$h)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) quit ..GetErrMsg(rtn, "医生站组接口[web.DHCDocDiagnosEntryV8||InsertOneMRDiagnos("_$lts($lb(ctLocId, mrAdm, mrDiagId, userId, mrDiaDesc, mrDiagTypeId, "", "", "", "",  "", diagStatusDR, "", docUserId, "N", "", "", "", +$h, "", +$h))_")]失败:"_rtnValue)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-11-14
/// Description: 获取"初步诊断"类型RowId
/// Table: MRC_DiagnosType
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetRegDiagTypeId()
ClassMethod GetRegDiagTypeId()
{
	quit $o(^MRC("DTYP",0,"Code","PRE",0))
}

/// Creator: ZhYW
/// CreatDate: 2019-11-14
/// Description: 验证保存数据
/// Input: 
/// Return: 
ClassMethod CheckRegData(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, personExpObj As BILL.IP.DTO.Entity.Reg.PAPersonExp, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	//患者类别为空时根据费别取默认的患者类别
	if ((+personObj.SocialStatus=0)&&(+admObj.AdmReason'=0)) {
		set personObj.SocialStatus=..GetDefSocStatIdByInsType(admObj.AdmReason, hospId)
	}
	
	set personExpObj.BirthDate=##class(websys.Conversions).DateHtmlToLogical(personExpObj.BirthDate)
	set personExpObj.BirthTime=##class(websys.Conversions).TimeHtmlToLogical(personExpObj.BirthTime)
	//没有写身份证号时,若所选证件类型为身份证,则身份证号即证件号
	if ((+personExpObj.CredType'=0)&&(personExpObj.CredNo'="")) {
		set credTypeCode=$p($g(^PAC("CARD",+personExpObj.CredType)),"^",1)
		if (credTypeCode="01") {     //"01"为身份证
			set personObj.IDNo=personExpObj.CredNo
		}
	}

	set admObj.AdmDate=$s((admObj.AdmDate=""):+$h, 1:##class(websys.Conversions).DateHtmlToLogical(admObj.AdmDate))
	set admObj.AdmTime=$s((admObj.AdmTime=""):$p($h,",",2), 1:##class(websys.Conversions).TimeHtmlToLogical(admObj.AdmTime))

	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "InPatReg", .mulHospAry)
	
	set patientId=personObj.PatientID
	if (+patientId=0) {
		set regNeedPatientNo=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "regNeedPatientNo")
		quit:(regNeedPatientNo="Y") ..GetErrMsg(-1, "该患者登记号不存在，不能办理入院")
	}
	if (+patientId'=0) {
		set deceased=$p($g(^PAPER(patientId,"ALL")),"^",12)        //死亡状态
		quit:(deceased="Y") ..GetErrMsg(-1, "该患者已死亡，不能办理入院")
		
		set stayToAdmin=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "StayToAdmin")
		if (stayToAdmin="N") {
			set stayStat=##class(web.UDHCJFBaseCommon).GetPatStayStat(patientId)
			quit:(stayStat=1) ..GetErrMsg(-1, "该患者正在留观，不能办理入院")
		}
		//判断患者是否有在院记录
		set admitEpisodeId=..GetAdmitEpisodeID(patientId)
		if (+admitEpisodeId>0) {
			set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(admitEpisodeId)
			set admHospDesc=$s((+admHospDR'=0):$p($g(^CT("HOSP",admHospDR)),"^",2),1:"")
			quit ..GetErrMsg(-1, "该患者正在"_admHospDesc_"住院，不能再办理入院")
		}
		
		//判断患者就诊卡是否是临时卡
		set rtnValue=..CheckTempCardByPAPMI(patientId)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) ..GetErrMsg(-1, $p(rtnValue,"^",2)_"，不能办理入院")
		
		//判断传过来的姓名跟系统是否一样，不一样的话提示先改基本信息再办理入院(防止办理住院时候误更新基本信息)
		set patName=$p($g(^PAPER(patientId,"ALL")),"^",1)
		if ((patName'="")&&(patName'=personObj.Name)) {
			quit ..GetErrMsg(-1, "该患者姓名发生变化，请先修改患者姓名再办理入院")
		}
		//+2022-11-24 ZhYW 有未结账记录时是否能办理入院
		set regCheckUnPay=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "RegCheckUnPay")
		if (regCheckUnPay'="Y") {
			set rtnValue=..JudgeUnChged(patientId, hospId)
			set rtn=$p(rtnValue,"^",1)
			quit:(+rtn) ..GetErrMsg(+rtn, $p(rtnValue,"^",2)_"，不能办理入院")
		}
	}
	
	if (personObj.IDNo'="") {
		set existPatientId=$o(^PAPERi("PAPMI_ICPPBC",$zcvt(personObj.IDNo_"Z","U"),0))
		if ((existPatientId'="")&&(existPatientId'=patientId)) {
			quit ..GetErrMsg(-1, "此身份证已经被使用，不能办理入院")
		}
	}
	
	if (+personExpObj.BirthDate'=0) {
		if ($SYSTEM.SQL.DATEDIFF("dd", personExpObj.BirthDate, +$h)<0) {
			quit ..GetErrMsg(-1, "患者出生日期大于当天，不能办理入院")
		}
		if ($SYSTEM.SQL.DATEDIFF("dd", personExpObj.BirthDate, admObj.AdmDate)<0) {
			quit ..GetErrMsg(-1, "患者入院日期小于出生日期，不能办理入院")
		}
	}
	if (+personExpObj.BirthTime'=0) {
		if ($SYSTEM.SQL.DATEDIFF("ss", personExpObj.BirthDate_","_personExpObj.BirthTime, $h)<0) {
			quit ..GetErrMsg(-1, "患者出生时间大于当前时间，不能办理入院")
		}
		if ($SYSTEM.SQL.DATEDIFF("ss", personExpObj.BirthDate_","_personExpObj.BirthTime, admObj.AdmDate_","_admObj.AdmTime)<0) {
			quit ..GetErrMsg(-1, "患者入院时间小于出生时间，不能办理入院")
		}
	}
	
	quit:(+admObj.Dept=0) ..GetErrMsg(-1, "入院科室为空，不能办理入院")
	quit:(+admObj.Ward=0) ..GetErrMsg(-1, "入院病区为空，不能办理入院")
	quit:(+admObj.AdmReason=0) ..GetErrMsg(-1, "就诊费别为空，不能办理入院")
	
	//2021-08-05 多院区业务受限
	set locHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admObj.Dept)
	if ($d(mulHospAry("DL"))) {
		quit:('$d(mulHospAry("DL",locHospDR))) ..GetErrMsg(-1, "【多院区业务】中未配置可以将患者收治到"_$p(^CT("HOSP",locHospDR),"^",2))
		if ($d(mulHospAry("DL",locHospDR,"LOC"))) {
			quit:('$d(mulHospAry("DL",locHospDR,"LOC",admObj.Dept))) ..GetErrMsg(-1, "【多院区业务】中未配置可以将患者收治到"_$p(^CTLOC(admObj.Dept),"^",2))
		}
	}else {
		quit:('$d(mulHospAry(locHospDR))) ..GetErrMsg(-1, "配置不能跨医院办理入院")
	}
	
	if ((+personObj.SocialStatus'=0)&&(+admObj.AdmReason'=0)) {
		set rtnValue=..CheckSocStatMtchInsType(personObj.SocialStatus, admObj.AdmReason, admObj.Dept)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) ..GetErrMsg(+rtn, $p(rtnValue,"^",2)_"，不能办理入院")
	}

	set appSwitch="N"   //是否开启了床位预约
	if (+admObj.Ward'=0) {
		set wardLocDR=$p($g(^PAWARD(admObj.Ward)),"^",5)
	  	set rtnValue=..GetSexAndAgeByLoc(wardLocDR, personObj.Sex, personObj.AgeYear, personExpObj.BirthDate)
	  	set rtn=$p(rtnValue,"^",1)
	  	quit:(+rtn) ..GetErrMsg(+rtn, $p(rtnValue,"^",2)_"，不能办理入院")
	  	
		set appSwitch=##class(Nur.InService.Interface).ifHospNeedAppByWard(admObj.Ward)
		if ((+admObj.IPBookID=0) || (appSwitch'="Y")) {
			set rtnValue=..AllowRegToWard(admObj.Ward)   //判断病区剩余床位
		  	set rtn=$p(rtnValue,"^",1)
		  	quit:(+rtn) ..GetErrMsg(+rtn, $p(rtnValue,"^",2)_"，不能办理入院")
		}
	}
	if (+admObj.IPBookID=0) {
		set needIPBook=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "RegNeedIPBook")
		quit:(needIPBook="Y") ..GetErrMsg(-1, "该患者没有有效住院证，不能办理入院")
		if (+admObj.Doctor=0) {
			quit:(+admObj.AdmDiagnos'=0) ..GetErrMsg(-1, "录入诊断时，入院医生不能为空")
			quit:(admObj.DiagRemark'="") ..GetErrMsg(-1, "录入诊断备注时，入院医生不能为空")
		}
	}else {
		set isEffective=##class(web.DHCBillInterface).IIsIPBook(+admObj.IPBookID)
		quit:(isEffective'="") ..GetErrMsg(-1, "住院证不在有效日期范围内，不能办理入院")
		
		//开启了床位预约但没有约到时不能登记
		if (appSwitch="Y") {
			set rtnValue=##class(Nur.InService.Interface).ifPatAppBed(+admObj.IPBookID)   //预约床位
			set rtn=$p(rtnValue,"^",1)
			quit:(+rtn) ..GetErrMsg(+rtn, $p(rtnValue,"^",2)_"，不能办理入院")
		}
		
		//若科室开启了住院总签床,住院证状态不是签床不能办理住院登记
		set locBeInHosp=$p($g(^CTLOC(+admObj.Dept)),"^",87)
		if (locBeInHosp="Y") {
			set currentStateDR=$p($g(^DHCDocIPBK(+admObj.IPBookID)),"^",8)     //住院证状态
			if (+currentStateDR'=0) {
				set IPMDICCode=$p($g(^DHCDocIPBDIC(currentStateDR)),"^",1)
				quit:(IPMDICCode'="SignBed") ..GetErrMsg(-1, "科室开启了住院总签床，但住院证状态不是签床，不能办理入院")
			}
		}
	}
	
	//2022-12-05 wzh 住院登记费别最小年龄限制
	if (personObj.AgeYear>0) {
		set rtnValue=..CheckInsTypeAge(admObj.AdmReason, personObj.AgeYear, locHospDR)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) ..GetErrMsg(+rtn, $p(rtnValue,"^",2)_"，不能办理入院")
	}
	
	quit ..GetErrMsg(0, "校验登记信息成功")
}

/// Creator: ZhYW
/// CreatDate: 2019-11-26
/// Description: 取本院区最后一次住院就诊
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hospital.RowId
/// Return: lastAdm:PA_Adm.RowId
/// Debug: w ##class(web.DHCIPBillReg).GetLastIPAdm()
ClassMethod GetLastIPAdm(patientId As %String, hospId As %String) As %String
{
	set lastAdm=""
	quit:(+patientId=0) lastAdm

	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)&&(lastAdm="")) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set admData=$g(^PAADM(adm))
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set visitStatus=$p(admData,"^",20)
		continue:(" C P "[(" "_visitStatus_" "))    //过滤退院和预约记录
		set lastAdm=adm
	}

	quit lastAdm
}

/// Description: 获取某个科室允许的性别和年龄范围
/// Others: 住院登记时做控制
/// Debug: w ##class(web.DHCIPBillReg).GetSexAndAgeByLoc(1, 2, 30, 52961)
ClassMethod GetSexAndAgeByLoc(deptId As %String, sexId As %String, age As %String, birthDate As %String) As %String
{
	set locData=$g(^CTLOC(deptId))
	set ageFrom=$p(locData,"^",49)   //CTLOC_AgeFrom
	set ageTo=$p(locData,"^",50)     //CTLOC_AgeTo
	set sexDR=$p(locData,"^",64)     //CTLOC_WardSingleSex
	
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptId)
	set checkAge=##class(web.DHCBillCommon).GetIPParamConfig(hospId, "RegCheckAge")
	if (checkAge="Y") {
		set ageFrom=..GetBirthDay(ageFrom)
		set ageTo=..GetBirthDay(ageTo)
		if (+age'=0) {
			if (((+ageFrom'=0)&&(birthDate>ageFrom)) || ((+ageTo'=0)&&(birthDate<ageTo))) {
				quit ..GetErrMsg(-1, "该患者的年龄非本病区允许的年龄范围")
			}
		}
	}
	if ((sexDR'="")&&(sexId'="")&&(sexId'=sexDR)) {
		quit ..GetErrMsg(-1, "该患者的性别非本病区允许的性别范围")
	}

	quit 0
}

ClassMethod GetBirthDay(age As %String) As %String
{
	quit:(age="") ""
    set birthday=+$h-(age*365)
    quit birthday
}

/// Creator: ZhYW
/// CreatDate: 2019-04-08
/// Description: 判断该就诊下是否有医嘱
/// Input: episodeId:PA_Adm.RowId
/// Return: =0:无医嘱, =1:有医嘱
/// Debug: w ##class(web.DHCIPBillReg).CheckAdmOrder(1)
ClassMethod CheckAdmOrder(episodeId As %String) As %String
{
	set rtn=0
	quit:(+episodeId=0) rtn
	set ord=$o(^OEORD(0,"Adm",+episodeId,0))
	quit:(+ord=0) rtn
	quit ($o(^OEORD(ord,"I",0))'="")
}

/// Creator: ZhYW
/// CreatDate: 2019-11-25
/// Description: 就诊信息修改
/// Debug: w ##class(web.DHCIPBillReg).UpdateRegInfo(^TMPUpdate("PersonXML"),^TMPUpdate("PersonExpXML"),^TMPUpdate("AdmXML"),^TMPUpdate("SessionStr"), "")
ClassMethod UpdateRegInfo(personXML As %String, personExpXML As %String, admXML As %String, sessionStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMPUpdate("PersonXML")=personXML
	set ^TMPUpdate("PersonExpXML")=personExpXML
	set ^TMPUpdate("AdmXML")=admXML
	set ^TMPUpdate("SessionStr")=sessionStr

	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID
	
	set photoStream=$p(expStr,"^",1)      //照片信息(Base64编码串)
	
	set personObj=##class(BILL.IP.DTO.Entity.Reg.PAPerson).%New()
	do personObj.XMLDeserialize(.personObj, personXML)
	if (photoStream'="") {
		set personObj.PhotoStream=photoStream
	}
	
	set personExpObj=##class(BILL.IP.DTO.Entity.Reg.PAPersonExp).%New()
	do personExpObj.XMLDeserialize(.personExpObj, personExpXML)
	set personExpObj.BirthDate=##class(websys.Conversions).DateHtmlToLogical(personExpObj.BirthDate)
	set personExpObj.BirthTime=##class(websys.Conversions).TimeHtmlToLogical(personExpObj.BirthTime)
	
	set admObj=##class(BILL.IP.DTO.Entity.Reg.PAAdm).%New()
	do admObj.XMLDeserialize(.admObj, admXML)
	set adm=admObj.EpisodeID
	set admObj.AdmDate=##class(websys.Conversions).DateHtmlToLogical(admObj.AdmDate)
	set admObj.AdmTime=##class(websys.Conversions).TimeHtmlToLogical(admObj.AdmTime)
	
	set patientId=personObj.PatientID
	if ((+patientId=0)||('$d(^PAPER(patientId)))) {
		quit ..GetErrMsg(-1, "患者主索引为空，不能修改")
	}
	
 	set rtn=0
 	
	set patJsonStr=..GetPatientInfo(patientId, adm, sessionStr)
	set patJson={}.%FromJSON(patJsonStr)
	set patJson.BirthDate=##class(websys.Conversions).DateHtmlToLogical(patJson.BirthDate)
	set patJson.BirthTime=##class(websys.Conversions).TimeHtmlToLogical(patJson.BirthTime)
	
	//没有写身份证号时,若所选证件类型为身份证,则身份证号即证件号
	if ((+personExpObj.CredType'=0)&&(personExpObj.CredNo'="")) {
		set credTypeCode=$p($g(^PAC("CARD",+personExpObj.CredType)),"^",1)
		if (credTypeCode="01") {     //"01"为身份证
			set personObj.IDNo=personExpObj.CredNo
		}
	}
	if (personObj.IDNo'="") {
		set existPatientId=$o(^PAPERi("PAPMI_ICPPBC",$zcvt(personObj.IDNo_"Z","U"),0))
		if ((existPatientId'="")&&(existPatientId'=patientId)) {
			quit ..GetErrMsg(-1, "此身份证已经被使用")
		}
	}
	
	if (+personExpObj.BirthDate=0) {
		quit ..GetErrMsg(-1, "出生日期不能为空")
	}
	
	if ($SYSTEM.SQL.DATEDIFF("ss", +personExpObj.BirthDate_","_+personExpObj.BirthTime, $h)<0) {
		quit ..GetErrMsg(-1, "出生时间不能大于当前时间")
	}
	
	set isUpdtedPat=..IsUpdtedPatInfo(personObj, personExpObj, patJson)
	
	set isUpdtedAdm=0
	set admJson={}
	if (+adm'=0) {
		//原就诊信息
		set admJsonStr=..GetAdmInfo(adm, sessionStr)
		set admJson={}.%FromJSON(admJsonStr)
		set admJson.AdmDate=##class(websys.Conversions).DateHtmlToLogical(admJson.AdmDate)
		set admJson.AdmTime=##class(websys.Conversions).TimeHtmlToLogical(admJson.AdmTime)
		
		if ($SYSTEM.SQL.DATEDIFF("ss", +personExpObj.BirthDate_","_+personExpObj.BirthTime, admJson.AdmDate_","_admJson.AdmTime)<0) {
			quit ..GetErrMsg(-1, "出生时间不能大于入院时间")
		}

		set isUpdtedAdm=..IsUpdtedAdmInfo(admObj, admJson)
		
		//修改了入院日期、入院时间
		if ($SYSTEM.SQL.DATEDIFF("ss", admObj.AdmDate_","_admObj.AdmTime, admJson.AdmDate_","_admJson.AdmTime)'=0) {
			set rtnValue=..AllowUpdtAdmDatTime(adm)
			set rtn=$p(rtnValue,"^",1)
			quit:(+rtn) rtnValue
		}
		
		if (+admObj.Ward'=0) {
			set wardLocDR=$p($g(^PAWARD(admObj.Ward)),"^",5)
		  	set rtnValue=..GetSexAndAgeByLoc(wardLocDR, personObj.Sex, personObj.AgeYear, personExpObj.BirthDate)
		  	set rtn=$p(rtnValue,"^",1)
		  	quit:(+rtn) rtnValue
		}
		
		//修改了科室/病区
	  	if ((admJson.Dept'=admObj.Dept) || (admJson.Ward'=admObj.Ward)) {
		  	set rtnValue=..AllowUpdtAdmDeptWard(adm)
		  	set rtn=$p(rtnValue,"^",1)
			quit:(+rtn) rtnValue
			
			//修改了病区
			if (admJson.Ward'=admObj.Ward) {
				set rtnValue=..AllowRegToWard(admObj.Ward)   //判断病区剩余床位
			  	set rtn=$p(rtnValue,"^",1)
			  	quit:(+rtn) rtnValue
			}
		}elseif(admJson.Doctor'=admObj.Doctor) {
			//修改了入院医生
			set rtnValue=..AllowUpdtAdmDoc(adm)
			set rtn=$p(rtnValue,"^",1)
			quit:(+rtn) rtnValue
		}
		
		if (admJson.AdmReason'=admObj.AdmReason) {
			set rtnValue=..AllowUpdtAdmReason(adm)
			set rtn=$p(rtnValue,"^",1)
			quit:(+rtn) rtnValue
	  		
	  		if ((+personObj.SocialStatus'=0)&&(+admObj.AdmReason'=0)) {
				set rtnValue=..CheckSocStatMtchInsType(personObj.SocialStatus, admObj.AdmReason, admObj.Dept)
				set rtn=$p(rtnValue,"^",1)
				quit:(+rtn) ..GetErrMsg(-1, $p(rtnValue,"^",2)_"，不能修改费别")
			}
	  	}
		//+2022-03-19 ZhYW 修改诊断验证
		if (+admObj.Doctor=0) {
			quit:(+admObj.AdmDiagnos'=0) ..GetErrMsg(-1, "修改诊断时，入院医生不能为空")
			quit:(admObj.DiagRemark'="") ..GetErrMsg(-1, "修改诊断备注时，入院医生不能为空")
		}
		//+2023-04-11 ZhYW 修改住院次数(只能修改在院的住院次数，而且是最后一个就诊的)
		if (admObj.InPatTimes'=admJson.InPatTimes) {
			set visitStatus=$p($g(^PAADM(adm)),"^",20)
			quit:(visitStatus'="A") ..GetErrMsg(-1, "患者不是在院状态，不能修改住院次数")
			quit:(+admObj.InPatTimes'>0) ..GetErrMsg(-1, "请填写有效的住院次数")
		}
	}
 	quit:(('isUpdtedPat)&&('isUpdtedAdm)) ..GetErrMsg(-1, "患者信息没有变化，不需修改")
	
	ts
	
	if (isUpdtedPat) {
		set rtnValue=..SavePatInfo(personObj, personExpObj, admObj, sessionStr, 1)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	if (isUpdtedAdm) {
		//修改就诊信息
		set rtnValue=..UpdtedAdmInfo(personObj, admObj, admJson, sessionStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	if ($tl>0) tc

	quit ..GetErrMsg(rtn, "修改成功")
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-12-13
/// Description: 判断患者基本信息是否被修改
/// Input: 
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCIPBillReg).IsUpdtedPatInfo()
ClassMethod IsUpdtedPatInfo(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, personExpObj As BILL.IP.DTO.Entity.Reg.PAPersonExp, patJson As %DynamicObject) As %String
{
	quit:(personObj.Name'=patJson.Name) 1
	quit:(personObj.Sex'=patJson.Sex) 1
	quit:(personObj.IDNo'=patJson.IDNo) 1
	quit:(personObj.Marital'=patJson.Marital) 1
	quit:(personObj.HomeTel'=patJson.HomeTel) 1
	quit:(personObj.Company'=patJson.Company) 1
	quit:(personObj.WorkTel'=patJson.WorkTel) 1
	quit:(personObj.Province'=patJson.Province) 1
	quit:(personObj.City'=patJson.City) 1
	quit:(personObj.CityArea'=patJson.CityArea) 1
	quit:(personExpObj.Street'=patJson.Street) 1
	quit:(personExpObj.Community'=patJson.Community) 1
	quit:(personObj.Address'=patJson.Address) 1
	quit:(personObj.MobPhone'=patJson.MobPhone) 1
	quit:(personExpObj.CredNo'=patJson.CredNo) 1
	quit:(personObj.SocialStatus'=patJson.SocialStatus) 1
	quit:(personObj.Nation'=patJson.Nation) 1
	quit:(personExpObj.CredType'=patJson.CredType) 1
	quit:(personObj.Country'=patJson.Country) 1
	quit:(personObj.Occupation'=patJson.Occupation) 1
	quit:(personObj.HomeProv'=patJson.HomeProv) 1
	quit:(personObj.HomeCity'=patJson.HomeCity) 1
	quit:(personObj.HomeArea'=patJson.HomeArea) 1
	quit:(personObj.Relation'=patJson.Relation) 1
	quit:(personObj.ForeignName'=patJson.ForeignName) 1
	quit:(personObj.ForeignPhone'=patJson.ForeignPhone) 1
	quit:(personObj.ForeignAddress'=patJson.ForeignAddress) 1
	quit:(personObj.ForeignCredType'=patJson.ForeignCredType) 1
	quit:(personObj.ForeignCredNo'=patJson.ForeignCredNo) 1
	quit:(personExpObj.Remark'=patJson.Remark) 1
	quit:(personExpObj.BirthDate'=patJson.BirthDate) 1
	quit:(personExpObj.BirthTime'=patJson.BirthTime) 1
	quit:(personExpObj.PostCode'=patJson.PostCode) 1
	quit:(personExpObj.CompanyPostCode'=patJson.CompanyPostCode) 1
	quit:(personObj.HealthCareProvider'=patJson.HealthCareProvider) 1
	quit:(personExpObj.HealthCareCardNo'=patJson.HealthCareCardNo) 1
	quit:(personExpObj.HealthFundNo'=patJson.HealthFundNo) 1
	quit:(personExpObj.BirthProv'=patJson.BirthProv) 1
	quit:(personExpObj.BirthCity'=patJson.BirthCity) 1
	quit:(personExpObj.BirthArea'=patJson.BirthArea) 1
	quit:(personExpObj.BirthStreet'=patJson.BirthStreet) 1
	quit:(personExpObj.BirthCommunity'=patJson.BirthCommunity) 1
	quit:(personExpObj.BirthAddress'=patJson.BirthAddress) 1
	quit:(personExpObj.HouseProv'=patJson.HouseProv) 1
	quit:(personExpObj.HouseCity'=patJson.HouseCity) 1
	quit:(personExpObj.HouseArea'=patJson.HouseArea) 1
	quit:(personExpObj.HouseStreet'=patJson.HouseStreet) 1
	quit:(personExpObj.HouseCommunity'=patJson.HouseCommunity) 1
	quit:(personExpObj.HouseAddress'=patJson.HouseAddress) 1
	quit:(personExpObj.HousePostCode'=patJson.HousePostCode) 1
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-12-13
/// Description: 判断患者就诊信息是否被修改
/// Input: 
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCIPBillReg).IsUpdtedAdmInfo()
ClassMethod IsUpdtedAdmInfo(admObj As BILL.IP.DTO.Entity.Reg.PAAdm, admJson As %DynamicObject) As %String
{
	quit:(admObj.AdmReason'=admJson.AdmReason) 1
	quit:(admObj.EpisSubType'=admJson.EpisSubType) 1
	quit:(admObj.AdmCategory'=admJson.AdmCategory) 1
	quit:(admObj.Dept'=admJson.Dept) 1
	quit:(admObj.Ward'=admJson.Ward) 1
	quit:(admObj.Doctor'=admJson.Doctor) 1
	quit:(admObj.AdmSource'=admJson.AdmSource) 1
	quit:(admObj.AdmReferPriority'=admJson.AdmReferPriority) 1
	quit:(admObj.AdmDate'=admJson.AdmDate) 1
	quit:(admObj.AdmTime'=admJson.AdmTime) 1
	quit:(admObj.RegConDisc'=admJson.RegConDisc) 1
	quit:(admObj.AdviseDoc'=admJson.AdviseDoc) 1    //+2022-08-30 ZhYW 推荐医生
	quit:(admObj.AdmRemark'=admJson.AdmRemark) 1    //+2022-09-02 ZhYW 就诊备注(患者便签)
	quit:(admObj.AdmDiagnos'=admJson.AdmDiagnos) 1  //+2023-01-19 ZhYW 诊断
	quit:(admObj.DiagRemark'=admJson.DiagRemark) 1  //+2023-01-19 ZhYW 诊断备注
	quit:(admObj.InPatTimes'=admJson.InPatTimes) 1  //+2023-04-11 ZhYW 住院次数
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-04-13
/// Description: 验证保存数据
/// Input: 
/// Return: 
ClassMethod CheckRegData1(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, personExpObj As BILL.IP.DTO.Entity.Reg.PAPersonExp, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	set adm=admObj.EpisodeID
	
	quit ..GetErrMsg(0, "校验登记信息成功")
}

/// Creator: ZhYW
/// CreatDate: 2023-04-13
/// Description: 修改就诊信息
/// Input: 
/// Return: 
ClassMethod UpdtedAdmInfo(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, admJson As %DynamicObject, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID

	set patientId=personObj.PatientID
	set adm=admObj.EpisodeID
	
	//+2023-04-11 ZhYW 获取修改前的日志内容数据
	set oldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAAdm"_$c(2)_adm_"^"_"User.PAAdmExt"_$c(2)_adm)
	//
	
	ts

 	set objectAdm=##class(User.PAAdm).%OpenId(adm, 0)
 	do objectAdm.PAADMAdmCategDRSetObjectId(admObj.AdmCategory)
 	set objectAdm.PAADMAdmDate=admObj.AdmDate
 	set objectAdm.PAADMAdmTime=admObj.AdmTime
 	do objectAdm.PAADMAdmReasonDRSetObjectId(admObj.AdmReason)
 	do objectAdm.PAADMEpissubtypeDRSetObjectId(admObj.EpisSubType)
 	set objectAdm.PAADMUpdateDate=+$h
 	set objectAdm.PAADMUpdateTime=$p($h,",",2)
 	do objectAdm.PAADMUpdateUserDRSetObjectId(userId)
 	do objectAdm.PAADMDepCodeDRSetObjectId(admObj.Dept)
 	do objectAdm.PAADMCurrentWardDRSetObjectId(admObj.Ward)
 	do objectAdm.PAADMAdmDocCodeDRSetObjectId(admObj.Doctor)
 	do objectAdm.PAADMAdmSrcDRSetObjectId(admObj.AdmSource)
 	do objectAdm.PAADMReferralPriorityDRSetObjectId(admObj.AdmReferPriority)
 	set objectAdm.PAADMInPatNo=admObj.InPatTimes    //住院次数
	set sc=objectAdm.%Save()
	do objectAdm.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	if (admJson.Dept'=admObj.Dept) {
		set transRowId=""
		set transSub=0
		while($o(^PAADM(adm,"TRANS",transSub))) {
			set transSub=$o(^PAADM(adm,"TRANS",transSub))
			set transSubData=$g(^PAADM(adm,"TRANS",transSub))
			set transCTLocDR=$p(transSubData,"^",6)
			continue:(transCTLocDR="")
			set transRowId=adm_"||"_transSub
			quit
		}
		if (transRowId'="") {
	  		set objectTrans=##class(User.PAAdmTransaction).%OpenId(transRowId, 0)
	  		do objectTrans.TRANSCTLOCDRSetObjectId(admObj.Dept)
	  		set sc=objectTrans.%Save()
	  		do objectTrans.%Close()
	  		if $$$ISERR(sc) {
		  		tro
		  		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		  	}
		  	
		  	set admDateInfo=##class(web.DHCDischargeHistory).GetAdminDateTime(adm)
  			set adminDate=$p(admDateInfo,"^",1)
  			if (adminDate'="") {
	  			set objectAdmExt=##class(User.PAAdmExt).%OpenId(adm, 0)
  				do objectAdmExt.PAADMAdminLocSetObjectId(admObj.Dept)      //更新入院科室
  				set sc=objectAdmExt.%Save()
  				do objectAdmExt.%Close()
  				if $$$ISERR(sc) {
	  				tro
			  		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
			  	}
	  		}
		}
	}
  	
  	if (admObj.Ward'=admJson.Ward) {
	  	set transRowId=""
		set transSub=0
		while($o(^PAADM(adm,"TRANS",transSub))) {
			set transSub=$o(^PAADM(adm,"TRANS",transSub))
			set transSubData=$g(^PAADM(adm,"TRANS",transSub))
			set transWardDR=$p(transSubData,"^",9)
			continue:(transWardDR="")
			set transRowId=adm_"||"_transSub
			quit
		}
		if (transRowId'="") {
			set objectTrans=##class(User.PAAdmTransaction).%OpenId(transRowId, 0)
 			do objectTrans.TRANSWardDRSetObjectId(admObj.Ward)
 			set sc=objectTrans.%Save()
			do objectTrans.%Close()
  			if $$$ISERR(sc) {
	  			tro
	  			quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	  		}
	  		
	  		set admDateInfo=##class(web.DHCDischargeHistory).GetAdminDateTime(adm)
  			set adminDate=$p(admDateInfo,"^",1)
  			if (adminDate'="") {
	  			set objectAdmExt=##class(User.PAAdmExt).%OpenId(adm, 0)
  				do objectAdmExt.PAADMAdminWardSetObjectId(admObj.Ward)
  				set sc=objectAdmExt.%Save()
  				do objectAdmExt.%Close()
  				if $$$ISERR(sc) {
	  				tro
	  				quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	  			}
	  		}
		  	
	  		if (admJson.Ward'="") {
		  		set wardSub=$o(^PAWARDA(0,"WADM",adm,admJson.Ward,0))
		  		if (wardSub'="") {
			  		set wardAdmRowId=admJson.Ward_"||"_wardSub
					set sc=##class(User.PACWardAdm).%DeleteId(wardAdmRowId)
					if $$$ISERR(sc) {
		  				tro
	  					quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		  			}
			  	}
		  	}
		  	
		  	set objectWardAdm=##class(User.PACWardAdm).%New(admObj.Ward)
			do objectWardAdm.WADMParRefSetObjectId(admObj.Ward)
			do objectWardAdm.WADMPAADMDRSetObjectId(admObj.EpisodeID)
			set objectWardAdm.WADMBookedStatus="O"
			do objectWardAdm.WADMTransDRSetObjectId(transRowId)
			set sc=objectWardAdm.%Save()
			do objectWardAdm.%Close()
			if $$$ISERR(sc) {
				tro
  				quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
			}
		}
	}

	//转科记录表里只有两条记录且医生没有开医嘱时可以修改住院医生，更新转科记录表里的第一条记录
  	if (admObj.Doctor'=admJson.Doctor) {
	  	set transSub=$o(^PAADM(adm,"TRANS",0))
	  	if (transSub'="") {
		  	set transRowId=adm_"||"_transSub
		  	set objectTrans=##class(User.PAAdmTransaction).%OpenId(transRowId, 0)
		 	do objectTrans.TRANSCTCPDRSetObjectId(admObj.Doctor)
  			set sc=objectTrans.%Save()
  			do objectTrans.%Close()
  			if $$$ISERR(sc) {
	  			tro
  				quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	  		}
	    }
	}
  	
  	//修改患者费别时，同时修改PA_Adm和DHC_PatientBill表
	if (admObj.AdmReason'=admJson.AdmReason) {
  		set rtnValue=..UpdateAdmReason(adm, admJson.AdmReason, admObj.AdmReason, userId, "")
  		set rtn=$p(rtnValue,"^",1)
  		if (+rtn) tro  quit rtnValue
  	}
	
  	//修改优惠类型、推荐医生、就诊备注信息
  	set objectAdmExt=##class(User.PAAdmExt).%OpenId(adm, 0)
  	do objectAdmExt.PAADMRegConDisDRSetObjectId(admObj.RegConDisc)      //更新优惠类型
  	do objectAdmExt.PAADMAdviseDocDrSetObjectId(admObj.AdviseDoc)       //推荐医生
  	do objectAdmExt.PAADMRemarks.Clear()
	do objectAdmExt.PAADMRemarks.Insert(admObj.AdmRemark)        //2022-09-02 ZhYW 就诊备注(患者便签)
  	set sc=objectAdmExt.%Save()
  	do objectAdmExt.%Close()
  	if $$$ISERR(sc) {
  		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	//+2022-01-19 ZhYW 修改诊断、诊断备注
	if ((admObj.AdmDiagnos'=admJson.AdmDiagnos)||(admObj.DiagRemark'=admJson.DiagRemark)) {
		set rtnValue=..UpdateDiagnos(admObj, sessionStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
	
	//+2023-04-11 ZhYW 修改PA_Person表中的住院次数
	if (admObj.InPatTimes'=admJson.InPatTimes) {
		set objectPAPerson=##class(User.PAPerson).%OpenId(patientId, 0)
	 	set objectPAPerson.PAPERExemptionNumber=admObj.InPatTimes
	 	set sc=objectPAPerson.%Save()
		do objectPAPerson.%Close()
		if $$$ISERR(sc) {
			tro
			quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		}
	}
	
	//修改就诊记录日志
	set rtnValue=..SaveUpdtAdmLog(personObj, admObj, admJson, userId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	if ($tl>0) tc
	
	//获取修改后的日志内容数据
	set newDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.PAAdm"_$c(2)_adm_"^"_"User.PAAdmExt"_$c(2)_adm)
	//调用医生站接口保存修改日志
	do ##class(web.DHCDocDataChangeLog).SaveLog("PA_Adm#PA_AdmExt", "User.PAAdm#User.PAAdmExt", "患者就诊信息", "User.PAAdm#User.PAAdmExt_"_adm, adm, "U", newDataJson, oldDataJson, userId)
	
	quit rtn
}

ClassMethod GetErrMsg(err As %String, msg As %String) As %String
{
	quit err_"^"_msg
}

/// Creator: ZhYW
/// CreatDate: 2022-12-13
/// Description: 修改患者基本信息留痕
/// Input: 
/// Return: =0:保存成功, <>0:保存失败
/// Debug: w ##class(web.DHCIPBillReg).SaveUpdtPatLog()
ClassMethod SaveUpdtPatLog(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, personExpObj As BILL.IP.DTO.Entity.Reg.PAPersonExp, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, patJson As %DynamicObject, userId As %String) As %String
{
	set rtn=0
	quit:(+personObj.PatientID=0) ..GetErrMsg(-1, "参数错误")
	
	if (patJson.Name'=personObj.Name) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Name")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Name).%Set("newValue", personObj.Name)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Sex'=personObj.Sex) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Sex_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Sex).%Set("newValue", personObj.Sex)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.IDNo'=personObj.IDNo) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_ID")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.IDNo).%Set("newValue", personObj.IDNo)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Marital'=personObj.Marital) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Marital_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Marital).%Set("newValue", personObj.Marital)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HomeTel'=personObj.HomeTel) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_TelH")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HomeTel).%Set("newValue", personObj.HomeTel)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Company'=personObj.Company) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_SecondPhone")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Company).%Set("newValue", personObj.Company)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.WorkTel'=personObj.WorkTel) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_TelO")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.WorkTel).%Set("newValue", personObj.WorkTel)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Province'=personObj.Province) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_CT_Province_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Province).%Set("newValue", personObj.Province)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.MobPhone'=personObj.MobPhone) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_MobPhone")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.MobPhone).%Set("newValue", personObj.MobPhone)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.City'=personObj.City) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_CityCode_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.City).%Set("newValue", personObj.City)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.SocialStatus'=personObj.SocialStatus) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_SocialStatus_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.SocialStatus).%Set("newValue", personObj.SocialStatus)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthDate'=personExpObj.BirthDate) {
		set dto={}
		do dto.%Set("tableName", "PA_PatMas").%Set("propName", "PAPMI_DOB")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthDate).%Set("newValue", personExpObj.BirthDate)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthTime'=personExpObj.BirthTime) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_BirthTime")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthTime).%Set("newValue", personExpObj.BirthTime)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Nation'=personObj.Nation) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Nation_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Nation).%Set("newValue", personObj.Nation)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Address'=personObj.Address) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_StName")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Address).%Set("newValue", personObj.Address)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.CredType'=personExpObj.CredType) {
		set dto={}
		do dto.%Set("tableName", "PA_PatMas").%Set("propName", "PAPMI_CardType_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.CredType).%Set("newValue", personExpObj.CredType)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.CredNo'=personExpObj.CredNo) {
		set dto={}
		do dto.%Set("tableName", "PA_PatMas").%Set("propName", "PAPMI_DVAnumber")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.CredNo).%Set("newValue", personExpObj.CredNo)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Country'=personObj.Country) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Country_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Country).%Set("newValue", personObj.Country)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Occupation'=personObj.Occupation) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Occupation_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Occupation).%Set("newValue", personObj.Occupation)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HomeProv'=personObj.HomeProv) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Province_Birth_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HomeProv).%Set("newValue", personObj.HomeProv)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HomeCity'=personObj.HomeCity) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_CityBirth_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HomeCity).%Set("newValue", personObj.HomeCity)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HomeArea'=personObj.HomeArea) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_AreaHome_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HomeArea).%Set("newValue", personObj.HomeArea)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Relation'=personObj.Relation) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_CTRLT_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Relation).%Set("newValue", personObj.Relation)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.ForeignName'=personObj.ForeignName) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_ForeignId")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.ForeignName).%Set("newValue", personObj.ForeignName)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.ForeignPhone'=personObj.ForeignPhone) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_ForeignPhone")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.ForeignPhone).%Set("newValue", personObj.ForeignPhone)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.ForeignAddress'=personObj.ForeignAddress) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_ForeignAddress")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.ForeignAddress).%Set("newValue", personObj.ForeignAddress)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.ForeignCredType'=personObj.ForeignCredType) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_ForeignCardTypeDR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.ForeignCredType).%Set("newValue", personObj.ForeignCredType)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.ForeignCredNo'=personObj.ForeignCredNo) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_ForeignCountry")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.ForeignCredNo).%Set("newValue", personObj.ForeignCredNo)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.Remark'=personExpObj.Remark) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_Remark")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Remark).%Set("newValue", personExpObj.Remark)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.CityArea'=personObj.CityArea) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_CityArea_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.CityArea).%Set("newValue", personObj.CityArea)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.CompanyPostCode'=personExpObj.CompanyPostCode) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_Comment1")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.CompanyPostCode).%Set("newValue", personExpObj.CompanyPostCode)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.PostCode'=personExpObj.PostCode) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_Comment2")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.PostCode).%Set("newValue", personExpObj.PostCode)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HealthFundNo'=personExpObj.HealthFundNo) {
		set dto={}
		do dto.%Set("tableName", "PA_PatMas").%Set("propName", "PAPMI_HealthFundNo")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HealthFundNo).%Set("newValue", personExpObj.HealthFundNo)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HealthCareProvider'=personObj.HealthCareProvider) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "PAPER_HCP_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HealthCareProvider).%Set("newValue", personObj.HealthCareProvider)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HealthCareCardNo'=personExpObj.HealthCareCardNo) {
		set dto={}
		do dto.%Set("tableName", "PA_Person").%Set("propName", "DHCINS")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HealthCareCardNo).%Set("newValue", personExpObj.HealthCareCardNo)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthProv'=personExpObj.BirthProv) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_BirthProvince_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthProv).%Set("newValue", personExpObj.BirthProv)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthCity'=personExpObj.BirthCity) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_BirthCity_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthCity).%Set("newValue", personExpObj.BirthCity)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthArea'=personExpObj.BirthArea) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_BirthArea_dr")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthArea).%Set("newValue", personExpObj.BirthArea)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthAddress'=personExpObj.BirthAddress) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_BirthAddress")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthAddress).%Set("newValue", personExpObj.BirthAddress)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HouseProv'=personExpObj.HouseProv) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_HouseProvince_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HouseProv).%Set("newValue", personExpObj.HouseProv)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HouseCity'=personExpObj.HouseCity) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_HouseCity_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HouseCity).%Set("newValue", personExpObj.HouseCity)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HouseArea'=personExpObj.HouseArea) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_HouseArea_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HouseArea).%Set("newValue", personExpObj.HouseArea)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HouseAddress'=personExpObj.HouseAddress) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_HouseAddress")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HouseAddress).%Set("newValue", personExpObj.HouseAddress)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HousePostCode'=personExpObj.HousePostCode) {
		set dto={}
		do dto.%Set("tableName", "DHC_Person").%Set("propName", "PAPER_Comment3")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HousePostCode).%Set("newValue", personExpObj.HousePostCode)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	//2022-09-05 ZhYW 增加街道(现住)、街道(出生)、街道(户口)修改日志
	if (patJson.Street'=personExpObj.Street) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_StreetNow")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Street).%Set("newValue", personExpObj.Street)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthStreet'=personExpObj.BirthStreet) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_StreetBirth")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthStreet).%Set("newValue", personExpObj.BirthStreet)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HouseStreet'=personExpObj.HouseStreet) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_StreetHouse")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HouseStreet).%Set("newValue", personExpObj.HouseStreet)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	//2022-11-15 ZhYW 增加社区(现住)、社区(出生)、社区(户口)修改日志
	if (patJson.Community'=personExpObj.Community) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_CommunityNow")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.Community).%Set("newValue", personExpObj.Community)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.BirthCommunity'=personExpObj.BirthCommunity) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_CommunityBirth")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.BirthCommunity).%Set("newValue", personExpObj.BirthCommunity)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (patJson.HouseCommunity'=personExpObj.HouseCommunity) {
		set dto={}
		do dto.%Set("tableName", "DHC_PA_PatMas").%Set("propName", "PAPMI_CommunityHouse")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", patJson.HouseCommunity).%Set("newValue", personExpObj.HouseCommunity)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}	

	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-12-13
/// Description: 修改患者就诊信息留痕
/// Input: 
/// Return: =0:保存成功, <>0:保存失败
/// Debug: w ##class(web.DHCIPBillReg).SaveUpdtAdmLog()
ClassMethod SaveUpdtAdmLog(personObj As BILL.IP.DTO.Entity.Reg.PAPerson, admObj As BILL.IP.DTO.Entity.Reg.PAAdm, admJson As %DynamicObject, userId As %String) As %String
{
	set rtn=0
	quit:(+admObj.EpisodeID=0) ..GetErrMsg(-1, "参数错误")
	
	if (admJson.AdmCategory'=admObj.AdmCategory) {
		set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_AdmCateg_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdmCategory).%Set("newValue", admObj.AdmCategory)
		do dto.%Set("userId", userId).%Set("flag", 1)
	  	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.EpisSubType'=admObj.EpisSubType) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_Epissubtype_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.EpisSubType).%Set("newValue", admObj.EpisSubType)
		do dto.%Set("userId", userId).%Set("flag", 1)
	  	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.Dept'=admObj.Dept) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_DepCode_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.Dept).%Set("newValue", admObj.Dept)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	 	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.Ward'=admObj.Ward) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_CurrentWard_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.Ward).%Set("newValue", admObj.Ward)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.Doctor'=admObj.Doctor) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_AdmDocCodeDR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.Doctor).%Set("newValue", admObj.Doctor)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.AdmSource'=admObj.AdmSource) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_AdmSrc_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdmSource).%Set("newValue", admObj.AdmSource)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.AdmReferPriority'=admObj.AdmReferPriority) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_ReferralPriority_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdmReferPriority).%Set("newValue", admObj.AdmReferPriority)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	if (admJson.AdmDate'=admObj.AdmDate) {
		set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_AdmDate")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdmDate).%Set("newValue", admObj.AdmDate)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
  	if (admJson.AdmTime'=admObj.AdmTime) {
	  	set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_AdmTime")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdmTime).%Set("newValue", admObj.AdmTime)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	//+2023-04-13 ZhYW 住院次数
	if (admJson.InPatTimes'=admObj.InPatTimes) {
		set dto={}
		do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_InPatNo")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.InPatTimes).%Set("newValue", admObj.InPatTimes)
		do dto.%Set("userId", userId).%Set("flag", 1)
		set rtnValue=..SaveUpReport(dto.%ToJSON())
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
	}
  	if (admJson.RegConDisc'=admObj.RegConDisc) {
	  	set dto={}
		do dto.%Set("tableName", "PA_AdmExt").%Set("propName", "PAADM_RegConDis_DR")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.RegConDisc).%Set("newValue", admObj.RegConDisc)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	//+2022-08-30 ZhYW 推荐医生
	if (admJson.AdviseDoc'=admObj.AdviseDoc) {
	  	set dto={}
		do dto.%Set("tableName", "PA_AdmExt").%Set("propName", "PAADM_AdviseDocDr")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdviseDoc).%Set("newValue", admObj.AdviseDoc)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}
	//+2022-09-02 ZhYW 就诊备注(患者便签)
	if (admJson.AdmRemark'=admObj.AdmRemark) {
	  	set dto={}
		do dto.%Set("tableName", "PA_AdmExt").%Set("propName", "PAADM_Remarks")
		do dto.%Set("patientId", personObj.PatientID).%Set("episodeId", admObj.EpisodeID)
		do dto.%Set("oldValue", admJson.AdmRemark).%Set("newValue", admObj.AdmRemark)
		do dto.%Set("userId", userId).%Set("flag", 1)
	 	set rtnValue=..SaveUpReport(dto.%ToJSON())
	  	set rtn=$p(rtnValue,"^",1)
		if (+rtn) quit rtnValue
	}

	quit 0
}

/// Description: 保存修改信息日志
/// Debug: w ##class(web.DHCIPBillReg).SaveUpReport()
ClassMethod SaveUpReport(jsonStr As %String) As %String
{
	set $zt="ERROR"
	set dto={}.%FromJSON(jsonStr)
	
	ts
	
	&SQL(
		INSERT INTO DHC_JFUpReport (
			UPR_PAPMI_DR, UPR_Adm_DR, UPR_TableName, UPR_ItemName, UPR_OldValue,
			UPR_NewValue, UPR_User_DR, UPR_Flag
		)
		VALUES (
			:dto.patientId, :dto.episodeId, :dto.tableName, :dto.propName, :dto.oldValue,
			:dto.newValue, :dto.userId, :dto.flag
		)
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit ..GetErrMsg(+rtn, %msg)
	
	if ($tl>0) tc
	
	quit rtn
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-11-25
/// Description: 修改就诊费别
/// Input: adm: PA_Adm.RowId, admReaDrOld: 原费别RowId, admReaDrNew: 新费别RowId, userId: 操作员RowId, expStr: 扩展串以"^"分割(可以为空)
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.DHCIPBillReg).UpdateAdmReason("1","4","1","12173","")
ClassMethod UpdateAdmReason(adm As %String, admReaDrOld As %String, admReaDrNew As %String, userId As %String, expStr As %String = "") As %String
{
	set rtn=0
	set msg="费别修改失败"
	
	quit:(adm="") ..GetErrMsg(-1, msg_"：就诊为空")
    quit:(admReaDrNew="") ..GetErrMsg(-1, msg_"：新费别为空")
    quit:(userId="") ..GetErrMsg(-1, msg_"：操作员为空")
	quit:(admReaDrNew=admReaDrOld) ..GetErrMsg(-1, msg_"：费别未发生变化")
	
	set curDate=+$h
    set curTime=$p($h,",",2)
    set patientId=$p(^PAADM(adm),"^",1)
	
	//判断就诊下未结算账单是否有医保已上传/医保已结算记录，若有则不能修改费别，也不能重新生成账单
	set rtnValue=..GetInsuUpFlagByAdm(adm)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) ..GetErrMsg(rtn, msg_"："_$p(rtnValue,"^",2)_"，不能修改费别")
	
	ts
	
	//更新PA_Adm表的患者类型
	set objectAdm=##class(User.PAAdm).%OpenId(adm, 0)
	do objectAdm.PAADMAdmReasonDRSetObjectId(admReaDrNew)
	set objectAdm.PAADMUpdateDate=curDate
	set objectAdm.PAADMUpdateTime=curTime
	do objectAdm.PAADMUpdateUserDRSetObjectId(userId)
	set sc=objectAdm.%Save()
	do objectAdm.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
    
    //更新账单表的患者类型
    set billId=""
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))&&(rtn=0)) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		continue:(pbData="")
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag'="B")
		set objectPB=##class(User.DHCPatientBill).%OpenId(pb, 0)
		do objectPB.PBPatInsTypeDRSetObjectId(admReaDrNew)
		set sc=objectPB.%Save()
		do objectPB.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)
			set msg=$system.Status.GetErrorText(sc)
			quit
		}
		set billId=$s((billId=""):pb,1:"")    //取未结算账单Id，如果有多个未结算账单，则不重新生成账单
	}
	if (+rtn) tro  quit ..GetErrMsg(rtn, msg)
    
    set dto={}
	do dto.%Set("tableName", "PA_Adm").%Set("propName", "PAADM_AdmReason_DR")
	do dto.%Set("patientId", patientId).%Set("episodeId", adm)
	do dto.%Set("oldValue", admReaDrOld).%Set("newValue", admReaDrNew)
	do dto.%Set("userId", userId).%Set("flag", 1)
	set rtnValue=..SaveUpReport(dto.%ToJSON())
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit ..GetErrMsg(rtn, msg_"：保存修改费别日志失败")
    
    if ($tl>0) tc
	
	//2020-12-22 ZhYW 修改费别时是否重新生成账单
	if (+billId'=0) {
		//取是否重新生成账单配置
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		set rebillFlag=##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.ipbill.charge.main.csp", "UPDATEINSTYPE", "", admHospDR)
		if (+rebillFlag=1) {
			//判断婴儿是否有未结算押金，婴儿有未结算押金时不能重新生成账单
			set babyDepNum=##class(web.DHCIPBillCashier).JudgeBabyDeposit(adm, admHospDR)
			if (+babyDepNum=0) {
				do ##class(web.UDHCJFREBILL).REBILL(adm, billId, userId)
			}
		}
	}

    quit ..GetErrMsg(rtn, "费别修改成功")
}

/// Creator: ZhYW
/// CreatDate: 2019-11-25
/// Description: 修改诊断
/// Input: sessionStr:操作员Id^安全组Id^登录科室Id^登录医院Id
/// Return: 0:成功, <>0:失败
ClassMethod UpdateDiagnos(admObj As BILL.IP.DTO.Entity.Reg.PAAdm, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID

	set rtn=0
	
	set adm=admObj.EpisodeID
    quit:(+adm=0) ..GetErrMsg(-1, "就诊号为空，不能修改诊断")
	quit:(+userId=0) ..GetErrMsg(-1, "操作员为空，不能修改诊断")
	
	&SQL(
		SELECT PAADM_PAPMI_DR, PAADM_MainMRADM_DR, PAADM_VisitStatus
		INTO :patientId, :mrAdm, :visitStatus
		FROM PA_Adm
		WHERE %ID = :adm
	)
    quit:(+patientId=0) ..GetErrMsg(-1, "患者主索引为空，不能修改诊断")
    quit:(+mrAdm=0) ..GetErrMsg(-1, "诊断主索引为空，不能修改诊断")
    quit:(visitStatus'="A") ..GetErrMsg(-1, "该患者不是在院状态，不能修改诊断")
    
	quit:(+admObj.DiagnosType=0) ..GetErrMsg(-1, "诊断类型不能为空")
	quit:((+admObj.AdmDiagnos=0)&&(admObj.DiagRemark="")) ..GetErrMsg(-1, "诊断和诊断备注不能都为空")
    
    &SQL(
    	SELECT COUNT(*)
    	INTO :mrDiagNum
    	FROM MR_Diagnos
    	WHERE MRDIA_MRADM_ParRef = :mrAdm
   	)
    quit:(mrDiagNum>1) ..GetErrMsg(-1, "医生已下诊断，不能修改诊断")

	ts
    
    if (mrDiagNum=0) {
		set rtnValue=..InsertOneMRDiagnos(mrAdm, admObj.AdmDiagnos, admObj.DiagRemark, admObj.DiagnosType, admObj.Doctor, sessionStr)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) tro  quit rtnValue
		if (admObj.DiagnosType'="") {
			set dto={}
			do dto.%Set("tableName", "MR_DiagType").%Set("propName", "TYP_MRCDiagTyp")
			do dto.%Set("patientId", patientId).%Set("episodeId", adm)
			do dto.%Set("oldValue", "").%Set("newValue", admObj.DiagnosType)
			do dto.%Set("userId", userId).%Set("flag", 1)
		  	set rtnValue=..SaveUpReport(dto.%ToJSON())
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) tro  quit rtnValue
		}
		if (admObj.AdmDiagnos'="") {
			set dto={}
			do dto.%Set("tableName", "MR_Diagnos").%Set("propName", "MRDIA_ICDCode_DR")
			do dto.%Set("patientId", patientId).%Set("episodeId", adm)
			do dto.%Set("oldValue", "").%Set("newValue", admObj.AdmDiagnos)
			do dto.%Set("userId", userId).%Set("flag", 1)
			set rtnValue=..SaveUpReport(dto.%ToJSON())
			set rtn=+$p(rtnValue,"^",1)
			if (+rtn) tro  quit rtnValue
		}
		if (admObj.DiagRemark'="") {
			set dto={}
			do dto.%Set("tableName", "MR_Diagnos").%Set("propName", "MRDIA_Desc")
			do dto.%Set("patientId", patientId).%Set("episodeId", adm)
			do dto.%Set("oldValue", "").%Set("newValue", admObj.DiagRemark)
			do dto.%Set("userId", userId).%Set("flag", 1)
			set rtnValue=..SaveUpReport(dto.%ToJSON())
			set rtn=$p(rtnValue,"^",1)
			if (+rtn) tro  quit rtnValue
		}
	}else {
		set mrAdmSub=$o(^MR(mrAdm,"DIA",0))
		if (mrAdmSub'="") {
			set oldDiagId=$p($g(^MR(mrAdm,"DIA",mrAdmSub)),"^",1)
			set diagNoteDR=$g(^MR(mrAdm,"DIA",mrAdmSub,"DES",0))
			set oldDiagNote=$s((diagNoteDR'=""):$g(^MR(mrAdm,"DIA",mrAdmSub,"DES",diagNoteDR)),1:"")
			set diagTypeSub=$o(^MR(mrAdm,"DIA",mrAdmSub,"TYP",0))
			set oldDiagTypeId=$s((diagTypeSub'=""):$p(^MR(mrAdm,"DIA",mrAdmSub,"TYP",diagTypeSub),"^",1),1:"")
			set mrDiagId=mrAdm_"||"_mrAdmSub
			if (oldDiagTypeId'=admObj.DiagnosType) tro  quit ..GetErrMsg(-1, "诊断类型与初始录入的不一致，不能修改诊断")
			
			&SQL(
				UPDATE MR_Diagnos
				SET MRDIA_ICDCode_DR = :admObj.AdmDiagnos, MRDIA_Desc = $LISTBUILD(:admObj.DiagRemark), MRDIA_UpdateUser_DR = :userId, MRDIA_OnsetDate = :curDate
				WHERE %ID = :mrDiagId
			)
			set rtn=SQLCODE
			if (+rtn) tro  quit ..GetErrMsg(rtn, %msg)
			
			if (oldDiagId'=admObj.AdmDiagnos) {
				set dto={}
				do dto.%Set("tableName", "MR_Diagnos").%Set("propName", "MRDIA_ICDCode_DR")
				do dto.%Set("patientId", patientId).%Set("episodeId", adm)
				do dto.%Set("oldValue", oldDiagId).%Set("newValue", admObj.AdmDiagnos)
				do dto.%Set("userId", userId).%Set("flag", 1)
				set rtnValue=..SaveUpReport(dto.%ToJSON())
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) tro  quit rtnValue
			}
			if (oldDiagNote'=admObj.DiagRemark) {
				set dto={}
				do dto.%Set("tableName", "MR_Diagnos").%Set("propName", "MRDIA_Desc")
				do dto.%Set("patientId", patientId).%Set("episodeId", adm)
				do dto.%Set("oldValue", oldDiagNote).%Set("newValue", admObj.DiagRemark)
				do dto.%Set("userId", userId).%Set("flag", 1)
				set rtnValue=..SaveUpReport(dto.%ToJSON())
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) tro  quit rtnValue
			}
		}
	}
    
    if ($tl>0) tc
    
    quit ..GetErrMsg(rtn, "诊断修改成功")

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-11-25
/// Description: 退院
/// Input: episodeId:PA_Adm.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).CancelAdm("3029","12173^241^222^2")
ClassMethod CancelAdm(episodeId As %String, sessionStr As %String) As %String
{
 	set ^TMP("CancelAdm")=$lb(episodeId, sessionStr)

 	set $zt="ERROR"
 	
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID
	
 	set adm=episodeId
 	quit:((adm="")||('$d(^PAADM(adm)))) ..GetErrMsg(-1, "该患者就诊不存在，不能办理退院")
 	
 	set visitStatus=$p($g(^PAADM(adm)),"^",20)
 	quit:(visitStatus'="A") ..GetErrMsg(-1, "该患者不是在院状态，不需办理退院")

	set rtn=0
	set msg="办理退院失败"
	
	//检查医嘱的执行状态和计费状态
	set rtnValue=..CheckOrdExec(adm)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) ..GetErrMsg(-1, $p(rtnValue,"^",2)_"，不能办理退院")

 	set admFeeInfo=##class(web.UDHCJFBaseCommon).GetPatFeeByEpisodeID(adm)
	set admFee=$p(admFeeInfo,"^",1)
 	quit:(+admFee'=0) ..GetErrMsg(-1, "该患者有费用产生，不能办理退院")
 	
 	set depositSum=..GetDepositSum(adm)
 	quit:(+depositSum'=0) ..GetErrMsg(-1, "该患者有未退的押金，请退押金后再办理退院")
 	
 	//判断母婴
 	set conf=##class(web.DHCBillCommon).GetTarParaId(hospId)
 	set newBornToMother=$s((+conf'=0):$p($g(^DHCTarC("CF",conf)),"^",5),1:"")
 	if ($d(^PAADMi("Mother",adm))&&(newBornToMother="Y")) {
	 	set babyAdm=0
	 	while($o(^PAADMi("Mother",adm,babyAdm))) {
		 	set babyAdm=$o(^PAADMi("Mother",adm,babyAdm))
		 	continue:(+babyAdm=0)
		 	set babyVisitStatus=$p($g(^PAADM(babyAdm)),"^",20)
			if (" A D "[(" "_babyVisitStatus_" ")) {
				set rtn=-1         //婴儿在院或者出院母亲不允许退院，避免召回的问题
				quit
			}
		}
	 	quit:(+rtn) ..GetErrMsg(rtn, "有在院或者出院婴儿就诊，母亲不能退院")
	}
 
 	//如果有包床信息，则提示不允许退院，需要取消包床才能退院DHC_PAC_BedStatusChange
 	quit:($d(^PAWARDA(0,"SADM",adm))) ..GetErrMsg(-1, "该患者有包床，请取消包床后再办理退院")
 
 	//如果有门诊费用转住院不允许退院
 	quit:(##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByIPAdm(adm)=1) ..GetErrMsg(-1, "该患者有门诊费用转住院，不能办理退院")
 
 	//如果患者在床不允许退院
 	set ifPatInBed=##class(web.DHCNurseInterface).ifPatInBed(adm)
 	quit:(ifPatInBed="Y") ..GetErrMsg(-1, "该患者尚未清床，不能办理退院")
 	
 	set curDate=+$h
 	set curTime=$p($h,",",2)
 	
 	&SQL(
		SELECT PAADM_PAPMI_DR, PAADM_DepCode_DR, PAADM_InPatNo
		INTO :patientId, :admDeptDR, :inPatTimes
		FROM PA_Adm
		WHERE %ID = :adm
	)
	
 	//2022-10-21 ZhYW 根据配置判断住院次数是否需要递增
	set isIncremental=..IsIncreaseInTimes(admDeptDR)
 	set inPatTimes=$i(inPatTimes, -(isIncremental=1))     //入院次数需要递增时-1，否则-0
 	
 	ts
 	
 	set objectPAPerson=##class(User.PAPerson).%OpenId(patientId, 0)
 	set objectPAPerson.PAPERExemptionNumber=inPatTimes
 	set sc=objectPAPerson.%Save()
	do objectPAPerson.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
 	
 	set objectAdm=##class(User.PAAdm).%OpenId(adm, 0)
 	set objectAdm.PAADMVisitStatus="C"
 	set objectAdm.PAADMCurrent="N"
 	set objectAdm.PAADMUpdateDate=curDate
 	set objectAdm.PAADMUpdateTime=curTime
 	do objectAdm.PAADMUpdateUserDRSetObjectId(userId)
 	set objectAdm.PAADMInPatNo=inPatTimes
 	set sc=objectAdm.%Save()
	do objectAdm.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
 	//更新PA_AdmTransaction表状态
 	set transStatusDR=$o(^PAC("REQST",0,"Code","J",0))    //Rejected
 	set transSub=0
 	while($o(^PAADM(adm,"TRANS",transSub))&&(rtn=0)) {
	 	set transSub=$o(^PAADM(adm,"TRANS",transSub))
	 	set transRowId=adm_"||"_transSub
	 	set objectTrans=##class(User.PAAdmTransaction).%OpenId(transRowId, 0)
	 	do objectTrans.TRANSStatusDRSetObjectId(transStatusDR)
	 	set sc=objectTrans.%Save()
		do objectTrans.%Close()
		if $$$ISERR(sc) {
			set rtn=$system.Status.GetErrorCodes(sc)
			set msg=$system.Status.GetErrorText(sc)
			quit
		}
	}
	if (+rtn) tro  quit ..GetErrMsg(rtn, msg)
	
	set wardDR=$p(^PAADM(adm),"^",70)
 	set bedDR=$p(^PAADM(adm),"^",73)
 	if ((wardDR'="")&&(bedDR="")) {
	 	set wardSubDR=$o(^PAWARDA(0,"WADM",adm,wardDR,""))
	 	//分床在等候区的患者根据room索引来查
	 	if (+wardSubDR=0) {
		 	set wardSubDR=$o(^PAWARDA(0,"RADM",adm,wardDR,""))
		}
	 	set wardAdmRowId=$s((+wardSubDR'=0):(wardDR_"||"_wardSubDR),1:"")
	 	if (wardAdmRowId'="") {
		 	set sc=##class(User.PACWardAdm).%DeleteId(wardAdmRowId)
		 	if $$$ISERR(sc) {
			 	tro
			 	quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
			}
		}
	}else {
 		set bedSubDR=$o(^PAWARDA(0,"ADM",adm,$p(bedDR,"||",1),$p(bedDR,"||",2),""))
 		set bedSubRowId=$s((+bedSubDR'=0):(bedDR_"||"_bedSubDR),1:"")
	 	if (bedSubRowId="") {
		 	tro
			quit ..GetErrMsg(-1, msg_"：患者床位为空")
		}
		//判断床位是否是婴儿床，如果是，则退院成功后要把状态设为"不可见"
		set bedTypeId=$p(^PAWARD(+bedDR,"BED",$p(bedDR,"||",2)),"^",2)
		set isBabyBed=##class(Nur.NIS.Service.Base.Bed).ifBabyBedByBedTypeId(bedTypeId)
		if (isBabyBed="Y") {
			set objectPACBed=##class(User.PACBed).%OpenId(bedDR, 0)
			set objectPACBed.BEDRcFlag="N"
			set sc=objectPACBed.%Save()
			do objectPACBed.%Close()
			if $$$ISERR(sc) {
				tro
				quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
			}
		}
		
		set sc=##class(User.PACBedAdm).%DeleteId(bedSubRowId)
	 	if $$$ISERR(sc) {
		 	tro
		 	quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		}
	}
 	
	if ($d(^DHCDocIPBDIC(0,"TypeCode","IPBookingState","Cancel"))) {
		set rtn=##class(web.DHCDocIPBookingCtl).IUpdateIPBState(adm, "Cancel")
		if (+rtn) tro  quit ..GetErrMsg(rtn, "医生站组接口[web.DHCDocIPBookingCtl||IUpdateIPBState("_$lts($lb(adm, "Cancel"))_")]失败:"_rtn)
	}
 	
	set rtn=##class(web.DHCDischargeHistory).SaveAdminDateTime(adm, "", "", 3, "", "")
	if (+rtn) tro  quit ..GetErrMsg(rtn, "护理组组接口[web.DHCDischargeHistory||SaveAdminDateTime("_$lts($lb(adm, "", "", 3, "", ""))_")]失败:"_rtn)
 	
 	//+2022-04-12 ZhYW 退院的患者床位上的预约信息需作废
 	set IPAppId=..GetIPAppointIDByAdm(adm)   //预约住院表RowId
 	if (IPAppId'="") {
	 	set rtn=##class(Nur.InService.DHCDocIPAppointment).CancleIPAppointment(IPAppId, "", userId)
	 	if (+rtn) tro  quit ..GetErrMsg(rtn, "护理组组接口[Nur.InService.DHCDocIPAppointment||CancleIPAppointment("_$lts($lb(IPAppId, "", userId))_")]失败:"_rtn)
	}
	
	if ($tl>0) tc
 	
 	set msg="办理退院成功"
	//取消接诊、回收病案号
	set rtnValue=##class(DHCWMR.IO.ToOutService).IGroupUnReceipt(adm, ctLocId, userId)
	if ($p(rtnValue,"^",1)'=1) {
		set msg=msg_"，取消接诊失败，病案组接口[DHCWMR.IO.ToOutService||IGroupUnReceipt("_$lts($lb(adm, ctLocId, userId))_")]失败:"_$tr(rtnValue,"^","＾")
	}
	
 	//+2023-02-23 ZhYW 退院后推送服务
	do ##class(BILL.IP.BL.SendSrv).SendDelAdmInfo(adm)

 	quit ..GetErrMsg(rtn, msg)
 	
ERROR
	quit ..AppException()
}

/// Description: 患者信息修改查询
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillReg","FindUpPatList","2022-08-30","2022-09-27","","","","","2","")
Query FindUpPatList(stDate As %String, endDate As %String, patientId As %String, episodeId As %String, userId As %String, patientName As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "Tregno:%String:登记号,Tname:%String:患者姓名,Tadmdate:%String:入院日期,Tadmtime:%String:入院时间,Tdischdate:%String:出院日期,Tdischtime:%String:出院时间,Titmname:%String:修改项目,Tolddesc:%String:原记录,Tnewdesc:%String:新记录,Tupdate:%String:修改日期,Tuptime:%String:修改时间,Tupuser:%String:修改人,Tadmdep:%String:科室,Tadmward:%String:病区,Tbedno:%String:床号,Tflag:%String:来源")
{
}

ClassMethod FindUpPatListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, patientId As %String, episodeId As %String, userId As %String, patientName As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindUpPatList")=$lb(stDate, endDate, patientId, episodeId, userId, patientName, hospId, langId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}

 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
 	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "InPatReg", .mulHospAry)
 	
 	for date=stDate:1:endDate {
	 	set rowId=0
	 	while($o(^DHCJFUPR(0,"date",date,rowId))) {
		 	set rowId=$o(^DHCJFUPR(0,"date",date,rowId))
		 	set data=$g(^DHCJFUPR(rowId))
		 	set papmi=$p(data,"^",1)
			continue:((patientId'="")&&(patientId'=papmi))
			set patName=$p(^PAPER(papmi,"ALL"),"^",1)
		 	continue:((patientName'="")&&(patientName'=patName))
			set admDR=$p(data,"^",2)
		 	continue:((episodeId'="")&&(episodeId'=admDR))
		 	set userDR=$p(data,"^",7)
		 	continue:((userId'="")&&(userId'=userDR))
		 	set userName=$s((+userDR'=0):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
		 	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
		 	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
		 	set admDate="", admTime="", dischDate="", dischTime=""
		 	set admDept="", bedCode="", admWard=""
		 	set admHospDR=""
		 	if (admDR'="") {
			 	set admDeptDR=$p(^PAADM(admDR),"^",4)
				set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
				if ($d(mulHospAry("DL"))) {
					continue:('$d(mulHospAry("DL",admHospDR)))
					if ($d(mulHospAry("DL",admHospDR,"LOC"))) {
						continue:('$d(mulHospAry("DL",admHospDR,"LOC",admDeptDR)))
					}
				}else {
					continue:('$d(mulHospAry(admHospDR)))
				}
				set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2),1:"")
				set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
				set admWardDR=$p(^PAADM(admDR),"^",70)
				set admWard=$s((+admWardDR'=0):$p($g(^PAWARD(admWardDR)),"^",2),1:"")
				set admWard=##class(User.PACWard).GetTranByDesc("WARDDesc", admWard, langId)
			 	set bedCode=##class(web.DHCBillCommon).GetPatBedCode(admDR)
			 	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(admDR)
				set admDate=$p(admInOutDateInfo,"^",1)
				set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
				set admTime=$p(admInOutDateInfo,"^",2)
				set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
				set dischDate=$p(admInOutDateInfo,"^",4)
			 	set dischDate=##class(websys.Conversions).DateLogicalToHtml(dischDate)
			 	set dischTime=$p(admInOutDateInfo,"^",5)
			 	set dischTime=##class(websys.Conversions).TimeLogicalToHtml(dischTime)
			}
			set tableName=$p(data,"^",3)
		 	set itmName=$p(data,"^",4)
		 	continue:(" PAPER_Age PAPER_AgeYr PAPER_AgeMth PAPER_AgeDay "[(" "_itmName_" "))
		 	//continue:(itmName="PAPMI_BirthTime")
		 	set oldValue=$p(data,"^",5)
 			set newValue=$p(data,"^",6)
 			if ((tableName="PA_Person")&&(itmName="PAPER_Name")) {
	 			set itmName=##class(websys.Translation).Get("", "患者姓名", langId)
	 		}
			if ((tableName="PA_Person")&&(itmName="PAPER_Name2")) {
				set itmName=##class(websys.Translation).Get("", "患者拼音码", langId)
			}
		 	if ((tableName="PA_PatMas")&&(itmName="PAPMI_SafetyNetCardNo")) {
			 	set itmName=##class(websys.Translation).Get("", "病历号", langId)
			}
			if ((tableName="PA_Person")&&(itmName="PAPER_Sex_DR")) {
				set itmName=##class(websys.Translation).Get("", "性别", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("SEX",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTSex).GetTranByDesc("CTSEXDesc", oldValue, langId)
				set newValue=$s((+newValue'=0):$p($g(^CT("SEX",newValue)),"^",2),1:"")
				set newValue=##class(User.CTSex).GetTranByDesc("CTSEXDesc", newValue, langId)
			}
			if ((tableName="PA_Person")&&(itmName="PAPER_ID")) {
				set itmName=##class(websys.Translation).Get("", "身份证号", langId)
			}
			if ((tableName="PA_PatMas")&&(itmName="PAPMI_DOB")) {
				set itmName=##class(websys.Translation).Get("", "出生日期", langId)
				set oldValue=##class(websys.Conversions).DateLogicalToHtml(oldValue)
				set newValue=##class(websys.Conversions).DateLogicalToHtml(newValue)
			}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Marital_DR")) {
				set itmName=##class(websys.Translation).Get("", "婚姻状况", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^CT("MAR",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.CTMarital).GetTranByDesc("CTMARDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("MAR",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTMarital).GetTranByDesc("CTMARDesc", newValue, langId)
			}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Religion_DR")) {
				set itmName=##class(websys.Translation).Get("", "宗教", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("RLG",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTReligion).GetTranByDesc("CTRLGDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("RLG",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTReligion).GetTranByDesc("CTRLGDesc", newValue, langId)
			}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_StName")) {
				set itmName=##class(websys.Translation).Get("", "地址(现住)", langId)
			}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_TelH")) {
			 	set itmName=##class(websys.Translation).Get("", "家庭电话", langId)
			}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Zip_DR")) {
				set itmName=##class(websys.Translation).Get("", "邮政编码", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("ZIP",oldValue)),"^",1),1:"")
			 	set newValue=$s((+newValue'=0):$p($g(^CT("ZIP",newValue)),"^",1),1:"")
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_SecondPhone")) {
			 	set itmName=##class(websys.Translation).Get("", "工作单位", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_TelO")) {
		 		set itmName=##class(websys.Translation).Get("", "单位电话", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_CT_Province_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "省(现住)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("PROV",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("PROV",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", newValue, langId)
		 	}
			if ((tableName="PA_Person")&&(itmName="PAPER_CityCode_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "市(现住)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CIT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CIT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", newValue, langId)
		 	}
			if ((tableName="PA_Person")&&(itmName="PAPER_CityArea_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "县(现住)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CITAREA",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CITAREA",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Email")) {
			 	set itmName="email"
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_MobPhone")) {
			 	set itmName=##class(websys.Translation).Get("", "手机", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_SocialStatus_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "患者类别", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("SS",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTSocialStatus).GetTranByDesc("SSDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("SS",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTSocialStatus).GetTranByDesc("SSDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_AdmCateg_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "入院情况", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^PAC("ADMCAT",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.PACAdmCategory).GetTranByDesc("ADMCATDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("ADMCAT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACAdmCategory).GetTranByDesc("ADMCATDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_AdmReason_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "就诊费别", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^PAC("ADMREA",oldValue)),"^",2),1:"")
				set oldValue=##class(User.PACAdmReason).GetTranByDesc("READesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("ADMREA",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACAdmReason).GetTranByDesc("READesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_Epissubtype_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "就诊子类", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^PAC("SUBT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.PACEpisodeSubType).GetTranByDesc("SUBTDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("SUBT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACEpisodeSubType).GetTranByDesc("SUBTDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Nation_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "民族", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("NAT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTNation).GetTranByDesc("CTNATDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("NAT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTNation).GetTranByDesc("CTNATDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_PatMas")&&(itmName="PAPMI_CardType_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "证件类型", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^PAC("CARD",oldValue)),"^",2),1:"")
				set oldValue=##class(User.PACCardType).GetTranByDesc("CARDDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("CARD",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACCardType).GetTranByDesc("CARDDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_PatMas")&&(itmName="PAPMI_DVAnumber")) {
			 	set itmName=##class(websys.Translation).Get("", "证件号码", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Country_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "国籍/地区", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("COU",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCountry).GetTranByDesc("CTCOUDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("COU",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCountry).GetTranByDesc("CTCOUDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Occupation_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "职业", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("OCC",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTOccupation).GetTranByDesc("CTOCCDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("OCC",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTOccupation).GetTranByDesc("CTOCCDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Education_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "学历", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("EDU",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTEducation).GetTranByDesc("EDUDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("EDU",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTEducation).GetTranByDesc("EDUDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_LangPrim_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "语言", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^SS("LAN",oldValue)),"^",2),1:"")
				set oldValue=##class(User.SSLanguage).GetTranByDesc("CTLANDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^SS("LAN",newValue)),"^",2),1:"")
			 	set newValue=##class(User.SSLanguage).GetTranByDesc("CTLANDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_EmplType_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "在职状态", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^PAC("EPE",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.PACEmployeeType).GetTranByDesc("EPEDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("EPE",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACEmployeeType).GetTranByDesc("EPEDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_CTRLT_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "与患者关系", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("RLT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTRelation).GetTranByDesc("CTRLTDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("RLT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTRelation).GetTranByDesc("CTRLTDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_ForeignId")) {
			 	set itmName=##class(websys.Translation).Get("", "联系人", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_ForeignPhone")) {
			 	set itmName=##class(websys.Translation).Get("", "联系人电话", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_ForeignAddress")) {
			 	set itmName=##class(websys.Translation).Get("", "联系人地址", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Remark")) {
			 	set itmName=##class(websys.Translation).Get("", "备注", langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_Province_Birth_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "省(籍贯)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("PROV",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", oldValue, langId)
				set newValue=$s((+newValue'=0):$p($g(^CT("PROV",newValue)),"^",2),1:"")
				set newValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_CityBirth_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "市(籍贯)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CIT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CIT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_AreaHome_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "县(籍贯)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CITAREA",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CITAREA",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", newValue, langId)
		 	}
		 	if ((tableName="PA_PatMas")&&(itmName="PAPMI_DOB")) {
			 	set itmName=##class(websys.Translation).Get("", "出生日期", langId)
			 	set oldValue=##class(websys.Conversions).DateLogicalToHtml(oldValue)
			 	set newValue=##class(websys.Conversions).DateLogicalToHtml(newValue)
		 	}
		 	if (tableName="DHC_PA_PatMas")&&(itmName="PAPMI_BirthTime") {
			 	set itmName=##class(websys.Translation).Get("", "出生时间", langId)
			 	set oldValue=##class(websys.Conversions).TimeLogicalToHtml(oldValue)
		 		set newValue=##class(websys.Conversions).TimeLogicalToHtml(newValue)
		 	}
			if ((tableName="DHC_Person")&&(itmName="PAPER_Comment1")) {
		 		set itmName=##class(websys.Translation).Get("", "邮编(工作)", langId)
		 	}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_Comment2")) {
		 		set itmName=##class(websys.Translation).Get("", "邮编(现住)", langId)
		 	}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_Comment3")) {
		 		set itmName=##class(websys.Translation).Get("", "邮编(户口)", langId)
		 	}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_BirthProvince_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "省(出生)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("PROV",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", oldValue, langId)
				set newValue=$s((+newValue'=0):$p($g(^CT("PROV",newValue)),"^",2),1:"")
				set newValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", newValue, langId)
			}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_BirthCity_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "市(出生)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CIT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CIT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", newValue, langId)
			}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_BirthArea_dr")) {
			 	set itmName=##class(websys.Translation).Get("", "县(出生)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CITAREA",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CITAREA",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", newValue, langId)
			}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_BirthAddress")) {
			 	set itmName=##class(websys.Translation).Get("", "地址(出生)", langId)
		 	}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_HouseProvince_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "省(户口)", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^CT("PROV",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("PROV",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTProvince).GetTranByDesc("PROVDesc", newValue, langId)
			}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_HouseCity_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "市(户口)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CIT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CIT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCity).GetTranByDesc("CTCITDesc", newValue, langId)
			}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_HouseArea_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "县(户口)", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^CT("CITAREA",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CITAREA",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCityArea).GetTranByDesc("CITAREADesc", newValue, langId)
			}
		 	if ((tableName="DHC_Person")&&(itmName="PAPER_HouseAddress")) {
			 	set itmName=##class(websys.Translation).Get("", "地址(户口)", langId)
			}
			if (tableName="PA_PatMas")&&(itmName="PAPMI_HealthFundNo") {
			 	set itmName=##class(websys.Translation).Get("", "医保手册号", langId)
		 	}
			if ((tableName="PA_Person")&&(itmName="PAPER_HCP_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "公费单位", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^CT("HCP",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("HCP",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTHealthCareProvider).GetTranByDesc("HCPDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="DHCINS")) {
			 	set itmName=##class(websys.Translation).Get("", "公费证号", langId)
		 	}
			if ((tableName="PA_Person")&&(itmName="PAPER_ForeignCardTypeDR")) {
			 	set itmName=##class(websys.Translation).Get("", "联系人证件类型", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^PAC("CARD",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.PACCardType).GetTranByDesc("CTPCPDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("CARD",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACCardType).GetTranByDesc("CTPCPDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Person")&&(itmName="PAPER_ForeignCountry")) {
		 		set itmName=##class(websys.Translation).Get("", "联系人证件号", langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_CurrentWard_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "病区", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^PAWARD(oldValue)),"^",2),1:"")
				set oldValue=##class(User.PACWard).GetTranByDesc("WARDDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAWARD(newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACWard).GetTranByDesc("WARDDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_AdmSrc_DR"))  {
			 	set itmName=##class(websys.Translation).Get("", "入院途径", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^PAC("ADSOU",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.PACAdmSource).GetTranByDesc("ADSOUDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("ADSOU",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACAdmSource).GetTranByDesc("ADSOUDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_DepCode_DR")) {
				set itmName=##class(websys.Translation).Get("", "科室", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CTLOC(oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CTLOC(newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_InPatNo")) {
				set itmName=##class(websys.Translation).Get("", "住院次数", langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_AdmDocCodeDR")) {
			 	set itmName=##class(websys.Translation).Get("", "就诊医生", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^CTPCP(oldValue,1)),"^",2),1:"")
			 	set oldValue=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CTPCP(newValue,1)),"^",2),1:"")
			 	set newValue=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", newValue, langId)
		 	}
		 	if (tableName="MR_Diagnos")&&(itmName="MRDIA_ICDCode_DR") {
			 	set itmName=##class(websys.Translation).Get("", "初步诊断", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^MRC("ID",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^MRC("ID",newValue)),"^",2),1:"")
			 	set newValue=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc", newValue, langId)
		 	}
		 	if ((tableName="MR_Diagnos")&&(itmName="MRDIA_Desc")) {
			 	set itmName=##class(websys.Translation).Get("", "诊断备注", langId)
		 	}
		 	if ((tableName="MR_DiagType")&&(itmName="TYP_MRCDiagTyp")) {
			 	set itmName=##class(websys.Translation).Get("", "诊断类型", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^MRC("DTYP",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.MRCDiagnosType).GetTranByDesc("DTYPDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^MRC("DTYP",newValue)),"^",2),1:"")
			 	set newValue=##class(User.MRCDiagnosType).GetTranByDesc("DTYPDesc", newValue, langId)
		 	}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_ReferralPriority_DR")) {
			 	set itmName=##class(websys.Translation).Get("", "入院病情", langId)
			 	set oldValue=$s((+oldValue'=0):$p($g(^PAC("REFPRI",oldValue)),"^",2),1:"")
			 	set oldValue=##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^PAC("REFPRI",newValue)),"^",2),1:"")
			 	set newValue=##class(User.PACReferralPriority).GetTranByDesc("REFPRIDesc", newValue, langId)
		 	}
			if ((tableName="PA_Adm")&&(itmName="PAADM_AdmDate")) {
				set itmName=##class(websys.Translation).Get("", "入院日期", langId)
			 	set oldValue=##class(websys.Conversions).DateLogicalToHtml(oldValue)
				set newValue=##class(websys.Conversions).DateLogicalToHtml(newValue)
			}
		 	if ((tableName="PA_Adm")&&(itmName="PAADM_AdmTime")) {
				set itmName=##class(websys.Translation).Get("", "入院时间", langId)
				set oldValue=##class(websys.Conversions).TimeLogicalToHtml(oldValue, 1)
			 	set newValue=##class(websys.Conversions).TimeLogicalToHtml(newValue, 1)
			}
		 	if ((tableName="PA_AdmExt")&&(itmName="PAADM_RegConDis_DR")) {
				set itmName=##class(websys.Translation).Get("", "优惠类型", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^DHCRCD(oldValue)),"^",2),1:"")
				set oldValue=##class(User.DHCRegConDisCount).GetTranByDesc("RCDDesc", oldValue, langId)
				set newValue=$s((+newValue'=0):$p($g(^DHCRCD(newValue)),"^",2),1:"")
				set newValue=##class(User.DHCRegConDisCount).GetTranByDesc("RCDDesc", newValue, langId)
		 	}
		 	//+2022-08-30 ZhYW 推荐医生
		 	if ((tableName="PA_AdmExt")&&(itmName="PAADM_AdviseDocDr")) {
				set itmName=##class(websys.Translation).Get("", "推荐医生", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CTPCP(oldValue,1)),"^",2),1:"")
				set oldValue=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CTPCP(newValue,1)),"^",2),1:"")
			 	set newValue=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", newValue, langId)
		 	}
		 	//+2022-09-02 ZhYW 就诊备注(患者便签)
		 	if ((tableName="PA_AdmExt")&&(itmName="PAADM_Remarks")) {
				set itmName=##class(websys.Translation).Get("", "就诊备注", langId)
			}
			//+2022-09-05 ZhYW 街道(现住)
		 	if ((tableName="DHC_PA_PatMas")&&(itmName="PAPMI_StreetNow")) {
				set itmName=##class(websys.Translation).Get("", "街道(现住)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("LOCTYPE",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("LOCTYPE",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", newValue, langId)
		 	}
		 	//+2022-09-05 ZhYW 街道(出生)
		 	if ((tableName="DHC_PA_PatMas")&&(itmName="PAPMI_StreetBirth")) {
				set itmName=##class(websys.Translation).Get("", "街道(出生)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("LOCTYPE",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("LOCTYPE",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", newValue, langId)
		 	}
		 	//+2022-09-05 ZhYW 街道(户口)
		 	if ((tableName="DHC_PA_PatMas")&&(itmName="PAPMI_StreetHouse")) {
				set itmName=##class(websys.Translation).Get("", "街道(户口)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("LOCTYPE",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("LOCTYPE",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTLocalityType).GetTranByDesc("LOCTYPEDesc", newValue, langId)
		 	}
		 	//+2022-11-15 ZhYW 社区(现住)
		 	if ((tableName="DHC_PA_PatMas")&&(itmName="PAPMI_CommunityNow")) {
				set itmName=##class(websys.Translation).Get("", "社区(现住)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CTCMUNT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CTCMUNT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", newValue, langId)
		 	}
		 	//+2022-11-15 ZhYW 社区(出生)
		 	if ((tableName="DHC_PA_PatMas")&&(itmName="PAPMI_CommunityBirth")) {
				set itmName=##class(websys.Translation).Get("", "社区(出生)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CTCMUNT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CTCMUNT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", newValue, langId)
		 	}
		 	//+2022-11-15 ZhYW 社区(户口)
		 	if ((tableName="DHC_PA_PatMas")&&(itmName="PAPMI_CommunityHouse")) {
				set itmName=##class(websys.Translation).Get("", "社区(户口)", langId)
				set oldValue=$s((+oldValue'=0):$p($g(^CT("CTCMUNT",oldValue)),"^",2),1:"")
				set oldValue=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", oldValue, langId)
			 	set newValue=$s((+newValue'=0):$p($g(^CT("CTCMUNT",newValue)),"^",2),1:"")
			 	set newValue=##class(User.CTCommunity).GetTranByDesc("CTCMUNTDesc", newValue, langId)
		 	}
		 	set upDate=$p(data,"^",8)
		 	set upDate=##class(websys.Conversions).DateLogicalToHtml(upDate)
		 	set upTime=$p(data,"^",9)
		 	set upTime=##class(websys.Conversions).TimeLogicalToHtml(upTime)
		 	set upFlag=$p(data,"^",10)
		 	set upFlagDesc=$case(upFlag,1:"修改",:"入院")
		 	set upFlagDesc=##class(websys.Translation).Get("", upFlagDesc, langId)
		 	do OutputPatList
		}
	}
 	
	quit $$$OK
    
OutputPatList
	set Data=$lb(regNo,patName,admDate,admTime,dischDate,dischTime,itmName,oldValue,newValue,upDate,upTime,userName,admDept,admWard,bedCode,upFlagDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-06-10
/// Description: 判断患者就诊卡是否是临时卡
/// Input: patientId: PA_PatMas.RowId
/// Return: 0:否，<>0:是
/// Debug: w ##class(web.DHCIPBillReg).CheckTempCardByPAPMI(652)
ClassMethod CheckTempCardByPAPMI(patientId As %String) As %String
{
	set rtn=0
	quit:(+patientId=0) rtn
	
	set rowId=0
	while($o(^DHCCARDi("CF",0,"PAPMIDR",patientId,rowId))) {
		set rowId=$o(^DHCCARDi("CF",0,"PAPMIDR",patientId,rowId))
		set data=$g(^DHCCARD("CF",rowId))
		continue:(data="")
		set isActive=$p(data,"^",10)
		continue:(isActive'="N")
		set cardTypeDR=$p(data,"^",16)
		set cardNo=$p(data,"^",2)
		set rtnValue=##class(web.DHCOPAdmReg).CheckTempCardEffe(cardTypeDR, cardNo)
		if ($p(rtnValue,"^",1)="Y") {
			set rtn=-1_"^"_"患者的就诊卡"_cardNo_"为临时卡"
			quit
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2014-05-22
/// Description: 判断输入日期是否合法
/// Debug: w ##class(web.DHCIPBillReg).ValidateDate("1840-06-19")
ClassMethod ValidateDate(date As %String) As %String
{
	set $zt="ERROR"
	if ($l(date,"/")=3) {
		set dateH=$zdh(date,4)
	}elseif ($l(date,"-")=3) {
		set dateH=$zdh(date,3)
	}else {
		quit "N"
	}
	quit "Y"
ERROR
	set $zt=""
	quit "N"
}

/// Creator: ZhYW
/// CreatDate: 2020-12-03
/// Description: 退院前检查医嘱的执行状态和计费状态
/// Input: adm: PA_Adm.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).CheckOrdExec(3486)
ClassMethod CheckOrdExec(adm As %String) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	set ord=$o(^OEORD(0,"Adm",adm,0))
	quit:(+ord=0) rtn
	
	set itm=0
	while($o(^OEORD(ord,"I",itm))&&(rtn=0)) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set prior=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
		set priorCode=$s((+prior'=0):$p($g(^OECPR(+prior)),"^",1),1:"")
		continue:(priorCode["OM")
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",+statDR)),"^",1),1:"")
		if (" D I U C "'[(" "_statCode_" ")) {
			set rtn=-1_"^"_"患者有未停止的医嘱"
			quit
		}
		//执行记录
		set exec=0
		while($o(^OEORD(ord,"I",itm,"X",exec))&&(rtn=0)) {
			set exec=$o(^OEORD(ord,"I",itm,"X",exec))
			set execData=$g(^OEORD(ord,"I",itm,"X",exec))
			continue:(execData="")
			set billed=$p(execData,"^",6)
			continue:(" TB I "'[(" "_billed_" "))
			set rtn=-1_"^"_"患者有未计费医嘱"
			quit
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2020-12-03
/// Description: 获取住院押金总额
/// Input: adm: PA_Adm.RowId
/// Return: 押金总额
/// Debug: w ##class(web.DHCIPBillReg).GetDepositSum(3486)
ClassMethod GetDepositSum(adm As %String) As %String
{
	set depositSum=0
	set depRowId=0
 	while($o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))) {
	 	set depRowId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,depRowId))
	 	quit:(depRowId="")
	 	set depData=$g(^DHCSFPRINTDETAIL(depRowId))
	 	continue:(depData="")
	 	set depTypeDR=$p(depData,"^",13)
	 	set depTypeCode=$s((+depTypeDR'=0):$p($g(^ARC("ARCDT",depTypeDR)),"^",1),1:"")
	 	continue:(depTypeCode'="01")
	 	set depAmt=$p(depData,"^",6)
	 	set depositSum=$i(depositSum,depAmt)
	}
	set depositSum=$fn(depositSum,"",2)
	
	quit depositSum
}

/// Creator: ZhYW
/// CreatDate: 2020-12-23
/// Description: 判断就诊下未结算账单是否有医保已上传/医保已结算记录，若有则不能修改费别，也不能重新生成账单
/// Input: adm: PA_Adm.RowId
/// Return: =0: 医保未上传/医保没有结算记录; <>0:医保已上传/医保已结算记录
/// Debug: w ##class(web.DHCIPBillReg).GetInsuUpFlagByAdm(3486)
ClassMethod GetInsuUpFlagByAdm(adm As %String) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	
	set pb=0
	while($o(^DHCPB(0,"ADM",adm,pb))) {
		set pb=$o(^DHCPB(0,"ADM",adm,pb))
		set pbData=$g(^DHCPB(pb))
		continue:(pbData="")
		set payedFlag=$p(pbData,"^",16)
		continue:(payedFlag'="B")
		set insuUpFlag=##class(web.DHCINSUPort).GetInsuUpFlag(pb, "")
		if (+insuUpFlag>0) {    //医保未上传、未医保结算时重新生成账单
			set rtn=insuUpFlag_"^"_"账单："_pb_"医保"_$case(insuUpFlag,1:"已上传",2:"已结算",:"")
			quit
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-09-05
/// Description: 判断病区是否可办理入院
/// Input: wardId: PAC_Ward.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillReg).AllowRegToWard(1)
ClassMethod AllowRegToWard(wardId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	quit:(+wardId=0) ..GetErrMsg(-1, "参数错误")
	
	set wardData=$g(^PAWARD(wardId))
	set wardLocDR=$p(wardData,"^",5)  //WARD_LocationDR
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(wardLocDR)
	
	set fullBedAdminCfg=..GetRegParamCfg("FullBedAdmin", hospId)
	quit:(fullBedAdminCfg=1) 0  //配置不校验病区床位是否已满
	
	set bedIdleNum=##class(BILL.Interface.Inside.Invoke).GetWardBedIdleNum(wardId)
	if (bedIdleNum'>0) {
		set ward=$p(wardData,"^",2)       //WARD_Desc
		set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
		quit ..GetErrMsg(-1, ward_"没有可用床位")
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2021-03-17
/// Description: 获取"页面功能配置-住院登记"界面的参数配置
/// Input: hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetRegParamCfg("FullBedAdmin", 2)
ClassMethod GetRegParamCfg(key As %String, hospId As %String) As %String
{
	quit ##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.ipbill.reg.csp", key, "", hospId)
}

/// Creator: ZhYW
/// CreatDate: 2021-05-21
/// Description: 校验患者类别是否与就诊费别对照
/// Input: socStatId:CT_SocialStatus.RowId, insTypeId:PAC_AdmReason.RowId, deptId:CT_Loc.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillReg).CheckSocStatMtchInsType(2)
ClassMethod CheckSocStatMtchInsType(socStatId As %String, insTypeId As %String, deptId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rtn=0
	
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptId)
	set socStatMtchInsTypeCfg=..GetRegParamCfg("SocStatMtchInsType", hospId)
	quit:(+socStatMtchInsTypeCfg=0) rtn
	
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("DHC_PACADM", hospId)
	
	kill admReaAry
	set pacAdmDR=0
	while($o(^DHCPACADM(0,"Social",socStatId,pacAdmDR))) {
		set pacAdmDR=$o(^DHCPACADM(0,"Social",socStatId,pacAdmDR))
		set pacAdmData=$g(^DHCPACADM(pacAdmDR))
		set hospDR=$p(pacAdmData,"^",5)
		continue:(hospDR'=defHospId)
		set dateFrom=$p(pacAdmData,"^",3)
		set dateTo=$p(pacAdmData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set pacAdmReaDR=$p(pacAdmData,"^",2)
		continue:(pacAdmReaDR="")
		set admReaAry(pacAdmReaDR)=""
	}
	quit:($d(admReaAry(insTypeId))) rtn
	kill admReaAry
	
	set socialStatus=$p($g(^CT("SS",socStatId)),"^",2)
	set socialStatus=##class(User.CTSocialStatus).GetTranByDesc("SSDesc", socialStatus, langId)
	set insType=$p($g(^PAC("ADMREA",insTypeId)),"^",2)
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
	quit ..GetErrMsg(-1, "患者类别："_socialStatus_"与就诊费别："_insType_"未对照")
}

/// Creator: ZhYW
/// CreatDate: 2022-04-12
/// Description: 根据住院就诊取预约住院表RowId
/// Input: adm:PA_Adm.RowId
/// Return: DHCDocIPAppointment.RowId
/// Debug: w ##class(web.DHCIPBillReg).GetIPAppointIDByAdm(83)
ClassMethod GetIPAppointIDByAdm(adm As %String) As %String
{
	quit:(+adm=0) ""
	set IPBookId=..GetIPBookIDByIPAdm(adm)
	quit:(+IPBookId=0) ""
	quit $o(^DHCDocIPApp(0,"IPBookingID",IPBookId,0))
}

/// Creator: ZhYW
/// CreatDate: 2022-04-12
/// Description: 根据住院就诊取住院证RowId
/// Input: adm:PA_Adm.RowId
/// Return: DHCDocIPBooking.RowId
/// Debug: w ##class(web.DHCIPBillReg).GetIPBookIDByIPAdm(83)
ClassMethod GetIPBookIDByIPAdm(adm As %String) As %String
{
	quit:(+adm=0) ""
	quit $o(^DHCDocIPBK(0,"EpisodeIDTo",adm,0))
}

/// Creator: ZhYW
/// CreatDate: 2022-09-05
/// Description: 医保登记后是否允许修改费别
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCIPBillReg).AllowUpdtInsTypeAftInsuReg(2)
ClassMethod AllowUpdtInsTypeAftInsuReg(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.YBDJHSFYXXGFB", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2022-10-21
/// Description: 判断是否允许修改就诊科室，病区
/// Input: adm:PA_Adm.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillReg).AllowUpdtAdmDeptWard(3720)
ClassMethod AllowUpdtAdmDeptWard(adm As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	set rtn=..CheckAdmOrder(adm)
	quit:(+rtn) ..GetErrMsg(-1, "已开医嘱，不能修改科室/病区")
	
	set patBedInfo=##class(BILL.Interface.Inside.Invoke).GetIPAssignedBedDate(adm)
	set bedDate=$p(patBedInfo,"^",1)
	quit:(bedDate'="") ..GetErrMsg(-1, "患者已分过床位，不能修改科室/病区")
	
	set rtn=##class(BILL.Interface.Inside.Invoke).IsExistTransLocApp(adm)
	quit:(rtn) ..GetErrMsg(-1, "患者有转科申请，不能修改科室/病区")
	
	set admDate=$p($g(^PAADM(adm)),"^",6)
	quit:(admDate'=+$h) ..GetErrMsg(-1, "已入院患者不能修改科室/病区")
	
	set admDeptDR=$p($g(^PAADM(adm)),"^",4)
	//2022-10-21 ZhYW 根据配置判断住院次数是否需要递增
	set isIncremental=..IsIncreaseInTimes(admDeptDR)
	if ('isIncremental) {
		set admDept=$p($g(^CTLOC(admDeptDR)),"^",2)
		set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
		quit ..GetErrMsg(-1, admDept_"患者不能修改科室/病区")
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-10-21
/// Description: 判断是否允许修改就诊入院医生
/// Input: adm:PA_Adm.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillReg).AllowUpdtAdmDoc(3720)
ClassMethod AllowUpdtAdmDoc(adm As %String) As %String
{
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	set rtn=..CheckAdmOrder(adm)
	quit:(+rtn) ..GetErrMsg(-1, "已开医嘱，不能修改入院医生")
	
	set patBedInfo=##class(BILL.Interface.Inside.Invoke).GetIPAssignedBedDate(adm)
	set bedDate=$p(patBedInfo,"^",1)
	quit:(bedDate'="") ..GetErrMsg(-1, "患者已分过床位，不能修改入院医生")
	
	set rtn=##class(BILL.Interface.Inside.Invoke).IsExistTransLocApp(adm)
	quit:(rtn) ..GetErrMsg(-1, "患者有转科申请，不能修改入院医生")
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-10-21
/// Description: 判断是否允许修改就诊费别
/// Input: adm:PA_Adm.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillReg).AllowUpdtAdmReason(3720)
ClassMethod AllowUpdtAdmReason(adm As %String) As %String
{
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	//+2022-09-06 ZhYW 根据配置控制医保登记后能否修改费别
	set insuRegInfo=##class(web.DHCINSUPort).CheckRegActFlag(adm)   //调用医保接口判断是否已做医保登记
	set isInsuReg=$p(insuRegInfo,"!",1)
	if (isInsuReg="Y") {
  		set isAllowUpdInsType=..AllowUpdtInsTypeAftInsuReg(hospId)
  		quit:(+isAllowUpdInsType=0) ..GetErrMsg(-1, "患者已医保登记，不能修改费别")
  	}
  	
	//修改费别时判断是否有B状态的账单已医保上传/医保已结算
	set rtnValue=..GetInsuUpFlagByAdm(adm)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) ..GetErrMsg(-1, $p(rtnValue,"^",2)_"，不能修改费别")
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-10-21
/// Description: 判断是否允许修改入院日期、入院时间
/// Input: adm:PA_Adm.RowId
/// Return: 0:是, <>0:否
/// Debug: w ##class(web.DHCIPBillReg).AllowUpdtAdmDatTime(3720)
ClassMethod AllowUpdtAdmDatTime(adm As %String) As %String
{
	set patBedInfo=##class(BILL.Interface.Inside.Invoke).GetIPAssignedBedDate(adm)
 	set bedDate=$p(patBedInfo,"^",1)
 	quit:(bedDate'="") ..GetErrMsg(-1, "患者已分过床位，不能修改入院日期/时间")
 	
 	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-10-21
/// Description: 根据配置判断住院次数是否需要递增，只要有一个条件满足，住院次数就不增加
/// Input: deptId:就诊科室Id
/// Return: 1:是, 0:否
/// Others: 后续增加的配置往此方法中增加
/// Debug: w ##class(web.DHCIPBillReg).IsIncreaseInTimes(189)
ClassMethod IsIncreaseInTimes(deptId As %String) As %String
{
	set rtn=##class(web.DHCIPBillReg).ChkDeptIncreaseInTimes(deptId)
	quit:(rtn=0) rtn
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-10-21
/// Description: 根据配置的入院科室判断住院次数是否需要递增
/// Input: deptId:入院科室Id
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCIPBillReg).ChkDeptIncreaseInTimes(189)
ClassMethod ChkDeptIncreaseInTimes(deptId As %String) As %String
{
	set rtn=1
	quit:(+deptId=0) rtn
	
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptId)
	
	set rset=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	do rset.Execute("IPCHRG.IPReg.DJSZYCSBDZDKS", "", "", hospId)
	while (rset.Next()) {
		set id=rset.Get("ID")
		continue:(deptId'=id)
		set rtn=0
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-11-17
/// Description: 登记成功后是否自动打印腕带
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCIPBillReg).IsAutoPrintWrist(2)
ClassMethod IsAutoPrintWrist(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.DJCGHSFZDDYWD", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2022-11-22
/// Description: 患者结算日期天数提醒阈值
/// Input: patientId:PA_PatMas.RowId, insTypeId:PAC_AdmReason.RowId, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).CheckInsChgDays("6336","")
ClassMethod CheckInsChgDays(patientId As %String, insTypeId As %String, hospId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rtn=0
	quit:(+patientId=0) rtn
	
	//取配置
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.HZJSRQTSTXYZ", "", insTypeId, hospId, "")
	set days=##class(%DynamicObject).%FromJSON(jsonStr).ecol1
	quit:(+days=0) rtn
	
	//获取最后一次传入费别的结算记录
	set lastPrtRowId=""
	set prtId=""
	while($o(^DHCINVPRTZY(0,"PAPMI",patientId,prtId),-1)) {
		set prtId=$o(^DHCINVPRTZY(0,"PAPMI",patientId,prtId),-1)
		set prtData=$g(^DHCINVPRTZY(prtId))
		set hospDR=$p(prtData,"^",35)
		continue:(hospDR'=hospId)
		set insTypeDR=$p(prtData,"^",9)
		continue:(insTypeDR'=insTypeId)
		continue:($d(^DHCINVPRTZY(0,"InitInv",prtId)))
		set initInvDR=$p(prtData,"^",13)
		continue:(+initInvDR'=0)
		set lastPrtRowId=prtId
		quit
	}
	quit:(+lastPrtRowId=0) rtn

	set prtDate=$p($g(^DHCINVPRTZY(prtId)),"^",2)
	quit:($SYSTEM.SQL.DATEDIFF("dd", prtDate, +$h)>days) rtn

	set insType=$p(^PAC("ADMREA",insTypeId),"^",2)
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
	quit -1_"^"_"患者在"_days_"天内有"_insType_"结算记录"
}

/// Creator: ZhYW
/// CreatDate: 2022-11-24
/// Description: 住院登记前验证数据合法性
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).CheckRegDataHTML()
ClassMethod CheckRegDataHTML(personXML As %String, personExpXML As %String, admXML As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	set personObj=##class(BILL.IP.DTO.Entity.Reg.PAPerson).%New()
	do personObj.XMLDeserialize(.personObj, personXML)
	
	set personExpObj=##class(BILL.IP.DTO.Entity.Reg.PAPersonExp).%New()
	do personExpObj.XMLDeserialize(.personExpObj, personExpXML)
	
	set admObj=##class(BILL.IP.DTO.Entity.Reg.PAAdm).%New()
	do admObj.XMLDeserialize(.admObj, admXML)
	
	if (admObj.EpisodeID) {
		//校验预住院转住院
		quit ##class(web.DHCBillPreIPAdmTrans).CheckTransData(admObj.EpisodeID, "I", admObj.Dept, admObj.Ward, "", sessionStr)
	}
	//校验入院登记
	quit ..CheckRegData(.personObj, .personExpObj, .admObj, sessionStr)

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2022-11-24
/// Description: 当日出院再入院患者提醒
/// Input: patientId:PA_PatMas.RowId, hospId:CT_Hosptal.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).CheckDischgToday("12467","2")
ClassMethod CheckDischgToday(patientId As %String, hospId As %String) As %String
{
	set rtn=0
	quit:(+patientId=0) rtn
	
	//通用配置->住院收费系统->住院登记->当日出院再入院患者是否提醒
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.DRCYZRYHZSFTX", "", "", hospId, "")
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit:($zcvt($p(cfgData,"^",2),"U")'="YES") rtn
	
	//判断当日是否有出院记录
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:(" C P "[(" "_visitStatus_""))
		set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
		set dischDate=$p(admInOutDateInfo,"^",4)   //出院日期
		continue:(dischDate'=+$h)
		set rtn=-1_"^"_"患者当天有出院记录"
		quit
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-11-24
/// Description: 入院登记前验证患者信息，并且在前端让用户confirm
/// Input: patientId:PA_PatMas.RowId, deptId:CT_Loc.RowId(就诊科室), insTypeId:PAC_AdmReason.RowId(就诊费别)
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).GetPreRegCfrTips("12467","51","1")
ClassMethod GetPreRegCfrTips(patientId As %String, deptId As %String, insTypeId As %String) As %String
{
	set stream=##class(%Stream.GlobalCharacter).%New()
	set aryObj=##class(%DynamicArray).%New()
	if (+patientId=0) {
		do aryObj.%ToJSON(.stream)
		do stream.OutputToDevice()
		quit ""
	}
	set hospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(deptId) //因存在跨院区办理入院情况，故院区需要根据就诊科室获取
	
	set rtnValue=..JudgeUnChged(patientId, hospId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		do LoadToDynAry(+rtn, $p(rtnValue,"^",2))
	}
	
	set rtnValue=..JudgeQFChged(patientId, hospId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		do LoadToDynAry(+rtn, $p(rtnValue,"^",2))
	}
	
	set rtnValue=..JudgeAdmStatus(patientId, hospId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		do LoadToDynAry(+rtn, $p(rtnValue,"^",2))
	}
	
	set rtn=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDisputePatFlag", patientId)
	if (rtn="Y") {
		do LoadToDynAry(-1, "患者是纠纷患者")
	}
	
	set rtn=##class(BILL.Interface.Inside.Service).IHasPendPayOrdByPAPMI(patientId, hospId, 1)
	if (+rtn) {
		do LoadToDynAry(-1, "患者有未补交的[先诊疗后付费]门急诊费用")
	}
	
	set arrearsAmt=##class(web.DHCOPQFPat).GetQFTotal(patientId, hospId)
	if (+arrearsAmt'=0) {
		do LoadToDynAry(-1, "患者存在欠费未补回的门急诊费用"_arrearsAmt_"元")
	}
	
	set rtn=##class(web.UDHCJFBaseCommon).GetPatStayStat(patientId)
	if (+rtn) {
		do LoadToDynAry(-1, "患者正在留观")
	}
	
	set rtnValue=..CheckInsChgDays(patientId, insTypeId, hospId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		do LoadToDynAry(rtn, $p(rtnValue,"^",2))
	}
	
	set rtnValue=..CheckDischgToday(patientId, hospId)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		do LoadToDynAry(rtn, $p(rtnValue,"^",2))
	}
	
	do aryObj.%ToJSON(.stream)
	do stream.OutputToDevice()
	
	quit ""
LoadToDynAry(success, msg)
	set json=##class(%DynamicObject).%New()
	set json.success=success
	set json.msg=msg
	do aryObj.%Push(json)
	quit
}

/// Creator: wzh
/// CreatDate: 2022-12-05
/// Description: 住院登记费别最小年龄限制
/// Input: insTypeId:PAC_AdmReason.RowId, hospId:CT_Hospital.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillReg).CheckInsTypeAge(2)
ClassMethod CheckInsTypeAge(insTypeId As %String, ageYear As %String, hospId As %String, langId As %String = "") As %String
{
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	//通用配置->住院收费系统->住院登记->住院登记费别最小年龄限制
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.ZYDJFBZXNLXZ", "", insTypeId, hospId)
	set age=##class(%DynamicObject).%FromJSON(jsonStr).ecol1
	quit:((+ageYear>=+age)) 0
	
	set insType=$p(^PAC("ADMREA",insTypeId),"^",2)
	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
	quit -1_"^"_"费别为"_insType_"时，限制最小年龄为"_age
}

/// Creator: ZhYW
/// CreatDate: 2022-12-29
/// Description: 是否校验人名合法性
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->住院登记->是否校验患者姓名和联系人姓名合法性
/// Debug: w ##class(web.DHCIPBillReg).IsValidatePersonName(2)
ClassMethod IsValidatePersonName(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.SFXYHZXMHLXRXMHFX", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: WangXQ
/// CreatDate: 2023-02-15
/// Description: 用住院证登记时是否可更改入院科室
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->住院登记->用住院证登记时是否可更改入院科室
/// Debug: w ##class(web.DHCIPBillReg).IsChangeDept(2)
ClassMethod IsChangeDept(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.YZYZDJSSFKGGRYKS", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: WangXQ
/// CreatDate: 2023-03-15
/// Description: 保存绿色通道信息
/// Input: sessionStr: 操作员^安全组^登录科室^登录医院, isUpdtOpt: 是否修改绿色通道信息标识
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(web.DHCIPBillReg).SaveRegExpInfo()
ClassMethod SaveRegExpInfo(regExpXML As %String, sessionStr As %String, isUpdtOpt As %String) As %String
{
	set $zt="ERROR"
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID

	ts

	set regExpObj=##class(BILL.IP.DTO.Entity.Reg.RegExp).%New()
	do regExpObj.XMLDeserialize(.regExpObj, regExpXML)
	set episodeId=regExpObj.EpisodeID
	set regExpID=$o(^BILL.IP.RegExpI("IdxAdm",episodeId,""),-1)
	if (+regExpID=0) {
		set objectRegExp=##class(BILL.IP.RegExp).%New()
		do objectRegExp.CreatDRSetObjectId(userId)
	}else {
		set objectRegExp=##class(BILL.IP.RegExp).%OpenId(regExpID, 0)
		do objectRegExp.UpdtIdSetObjectId(userId)
		set objectRegExp.UpdtDate=+$h
		set objectRegExp.UpdtTime=$p($h,",",2)
	}
	do objectRegExp.PAPMIDRSetObjectId(regExpObj.PatientID)
	do objectRegExp.AdmDRSetObjectId(episodeId)
	set objectRegExp.GreenRecValiDuration=regExpObj.GreenRecValiDuration
	set objectRegExp.GreenRecValiUnit=regExpObj.GreenRecValiUnit
	if (+objectRegExp.GreenRecStDate=0) {
		if (isUpdtOpt="Y") {
			set objectRegExp.GreenRecStDate=+$h
			set objectRegExp.GreenRecStTime=$p($h,",",2)
		}else {
			set objectRegExp.GreenRecStDate=$p(^PAADM(episodeId),"^",6)
			set objectRegExp.GreenRecStTime=$p(^PAADM(episodeId),"^",7)
		}
	}
	set sc=objectRegExp.%Save()
	do objectRegExp.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	if ($tl>0) tc
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: WangXQ
/// CreatDate: 2023-03-17
/// Description: 根据就诊号获取绿色通道信息
/// Input: episodeId: PA_Adm.RowId
/// Return: 绿色通道有效时长^绿色通道有效时长单位
/// Debug: w ##class(web.DHCIPBillReg).GetGreenRecInfo("")
ClassMethod GetGreenRecInfo(episodeId As %String) As %String
{
	quit:(+episodeId=0) ""
	set regExpID=$o(^BILL.IP.RegExpI("IdxAdm",episodeId,""),-1)
	quit:(+regExpID=0) ""
	set greenRecData=$g(^BILL.IP.RegExpD(regExpID))
	set greenRecValiDuration=$lg(greenRecData,6)
	set greenRecValiUnit=$lg(greenRecData,7)
	quit greenRecValiDuration_"^"_greenRecValiUnit
}

/// Creator: ZhYW
/// CreatDate: 2023-03-21
/// Description: 就诊费别是否取患者类别默认的费别
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->住院登记->就诊费别是否取患者类别默认的费别
/// Debug: w ##class(web.DHCIPBillReg).IsGetInsTypeOfPACAdm(2)
ClassMethod IsGetInsTypeOfPACAdm(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.JZFBSFQHZLBMRDFB", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: WangXQ
/// CreatDate: 2023-04-28
/// Description: 自费患者是否允许医保登记
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->住院登记->自费患者是否允许医保登记
/// Debug: w ##class(web.DHCIPBillReg).IsOwnPayCanInsuReg(2)
ClassMethod IsOwnPayCanInsuReg(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPReg.ZFHZSFYXYBDJ", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

}
