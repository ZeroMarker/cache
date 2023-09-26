Import SQLUser

/// 护理组维护
Class web.DHCDocIPAppointment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// CreatDate：  2014-03-27
/// Description：通过登记号获取病人基本信息和预约住院信息
/// Input：      病人登记号 PAPMINo
/// Return：     病人基本信息和预约住院信息
/// Debug:
ClassMethod GetPatInfoByPAPMINo(PAPMINo As %String) As %String
{
	s ^TMP("PAPMINo")=PAPMINo
	q:PAPMINo="" ""
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
	q:PatientID="" ""
	
	//获取病人基本信息
	//web.DHCBL.Patient.DHCPatientBuilder SearchPatInfoByRowID
	s PatInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(PatientID)
	s PAPMINo=$p(PatInfo,"$",1)
	s PersonInfo=$p(PatInfo,"$",3)
	//姓名、性别、年龄、出生日期、身份证号、民族、婚姻状况、职业、籍贯、病人类型、工作单位、单位地址、单位电话、户口地址、住址、联系人姓名、联系人地址和联系人电话
	s PatName=$p(PersonInfo,"^",1)   //姓名
	s PatSexDr=$p(PersonInfo,"^",2)
	s PatSex=$p(^CT("SEX",PatSexDr),"^",2)    //性别
	s PatAge=$p(PersonInfo,"^",3)    //年龄
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)
	s PatDob=$p(PersonInfo,"^",4)
	s PatDob=$ZD(PatDob,3)    //出生日期
	s PatID=$p(PersonInfo,"^",6)     //身份证号
	
	s PatNationDR=$p(PersonInfo,"^",23)
	s PatNation=""
	if PatNationDR'="" {
		s PatNationDesc=$p(^CT("NAT",PatNationDR),"^",2)
		s PatNation=$p(PatNationDesc,"-",2)   //民族
	}
	
	s PatMaritalDr=$p($g(^PAPER(PatientID,"PER",2)),"^",3)
	s ParMarital=""
	i PatMaritalDr'="" s ParMarital=$p(^CT("MAR",PatMaritalDr),"^",2)  //婚姻状况
	
	s PatOccupationDr=$p(PersonInfo,"^",26)   
	s PatOccupation=""
	if PatOccupationDr'="" {
		s PatOccupationDesc=$p(^CT("OCC",PatOccupationDr),"^",2)
		s PatOccupation=$p(PatOccupationDesc,"-",2) 	//职业
	}
	
	s PatHometown=$p($g(^PAPER(PatientID,"DHC")),"^",32)   //籍贯
	
	s PatTypeDR=$p(PersonInfo,"^",10)
	s PatType=""
	if PatTypeDR'="" s PatType=$p(^CT("SS",PatTypeDR),"^",2)  //病人类型
	
	s PatMobPhone=$p($g(^PAPER(PatientID,"PER",4)),"^",21)
	
	
	s cardType=$p(^PAPER(PatientID,"PAT",3),"^",7)
	i cardType'=1 s PatID=""
	s PatNok=$p(^PAPER(PatientID,"PER",4),"^",18)  //工作单位
	s PatNokAddress=$p($g(^PAPER(PatientID,"NOK")),"^",7)  //单位地址
	s PatNokPhone=$p($g(^PAPER(PatientID,"NOK")),"^",2)  //单位电话
	s PatHousehold=$p($g(^PAPER(PatientID,"DHC")),"^",33)  //户口地址
	
	s PatAddressDr=$o(^PAPER(PatientID,"PER","ADD",0))
	s PatAddress=$g(^PAPER(PatientID,"PER","ADD",PatAddressDr))  //住址
	
	s PatForeign=$p(PersonInfo,"^",16)  //联系人姓名
	s PatForeignAddress=$p(PersonInfo,"^",14)  //联系人地址
	s PatForeignPhone=$p(^PAPER(PatientID,"ALL"),"^",4)  //联系人电话
	s MedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"",$g(%session.Data("LOGON.HOSPID")))
	
	s TelH=$p(^PAPER(PatientID,"PER",1),"^",11)
	
	s PatResultInfo=PatientID_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDob_"^"_PatID_"^"_PatNation_"^"_ParMarital
	s PatResultInfo=PatResultInfo_"^"_PatOccupation_"^"_PatHometown_"^"_PatType_"^"_PatNok_"^"_PatNokAddress
	s PatResultInfo=PatResultInfo_"^"_PatNokPhone_"^"_PatHousehold_"^"_PatAddress_"^"_PatForeign_"^"_PatForeignAddress_"^"_PatForeignPhone_"^"_MedicalNo_"^"_PatMobPhone_"^"_TelH_"^"
	
	//住院科室、住院病区、预约医生、预约日期、预缴押金、专业和病人床位指针
	s AppLoc=""                               //预约科室
	s AppDoc=""
	s AppWard=""                                 //预约病区
	//s AppDoc=$p($g(^DHCDocIPBK(IPBookingID)),"^",)  //预约医生
	s AppDate=""									  //预约日期
	s AppCash="",AppBedNo="",TreatLevel=""
	
	s PatAppInfo=""_"^"_""_"^"_AppLoc_"^"_AppWard_"^"_AppDoc_"^"_AppDate_"^"_AppCash_"^"_"^"_AppBedNo_"^"_TreatLevel
	s ret=PatResultInfo_"$"_PatAppInfo_"$"_PAPMINo
	;s ret=$tr(ret,$c(13),"")
	q ret
}

/// CreatDate：  2014-03-27
/// Description：通过住院证号获取病人基本信息和预约住院信息
/// Input：      病人住院证号 IPBookingNo
/// Return：     病人基本信息和预约住院信息
/// Debug:
ClassMethod GetPatInfoByIPBookingNo(IPBookingNo As %String) As %String
{
	q:IPBookingNo="" "-404"
	s IPBookingID=$o(^DHCDocIPBK(0,"IPBookingNo",IPBookingNo,""))
	q:IPBookingID="" "-404"
	s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",IPBookingID,"")) //预约住院表rowid
	if IPAppID'="" {
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		q:IPAppStatus="B" "-103"   //此住院证已经办理预约
		q:IPAppStatus="Ar" "-100"   //此住院证已经办理在院
		q:IPAppStatus="Al" "-101"   //此住院证已经分配床位
		q:IPAppStatus="C" "-102"    //此住院证已经取消预约
		q:IPAppStatus="H" "-104"   //此住院证已经挂起
	}
	s PatientID=$p($g(^DHCDocIPBK(IPBookingID)),"^",1)
	//获取病人基本信息
	//web.DHCBL.Patient.DHCPatientBuilder SearchPatInfoByRowID
	s PatInfo=##class(web.DHCBL.Patient.DHCPatientBuilder).SearchPatInfoByRowID(PatientID)
	s PAPMINo=$p(PatInfo,"$",1)
	s PersonInfo=$p(PatInfo,"$",3)
	//姓名、性别、年龄、出生日期、身份证号、民族、婚姻状况、职业、籍贯、病人类型、工作单位、单位地址、单位电话、户口地址、住址、联系人姓名、联系人地址和联系人电话
	s PatName=$p(PersonInfo,"^",1)   //姓名
	s PatSexDr=$p(PersonInfo,"^",2)
	s PatSex=$p(^CT("SEX",PatSexDr),"^",2)    //性别
	s PatAge=$p(PersonInfo,"^",3)    //年龄
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)
	s PatDob=$p(PersonInfo,"^",4)
	s PatDob=$ZD(PatDob,3)    //出生日期
	s PatID=$p(PersonInfo,"^",6)     //身份证号
	
	s PatNationDR=$p(PersonInfo,"^",23)
	s PatNation=""
	if PatNationDR'="" {
		s PatNationDesc=$p(^CT("NAT",PatNationDR),"^",2)
		s PatNation=$p(PatNationDesc,"-",2)   //民族
	}
	
	s PatMaritalDr=$p(^PAPER(PatientID,"PER",2),"^",3)
	s ParMarital=""
	i PatMaritalDr'="" s ParMarital=$p(^CT("MAR",PatMaritalDr),"^",2)  //婚姻状况
	
	s PatOccupationDr=$p(PersonInfo,"^",26)   
	s PatOccupation=""
	if PatOccupationDr'="" {
		s PatOccupationDesc=$p(^CT("OCC",PatOccupationDr),"^",2)
		s PatOccupation=$p(PatOccupationDesc,"-",2) 	//职业
	}
	
	s PatHometown=$p($g(^PAPER(PatientID,"DHC")),"^",32)   //籍贯
	
	s PatTypeDR=$p(PersonInfo,"^",10)
	s PatType=""
	if PatTypeDR'="" s PatType=$p(^CT("SS",PatTypeDR),"^",2)  //病人类型
	
	s PatMobPhone=$p(^PAPER(PatientID,"PER",4),"^",21)
	
	s PatNok=$p(^PAPER(PatientID,"PER",4),"^",18)  //工作单位
	s PatNokAddress=$p($g(^PAPER(PatientID,"NOK")),"^",7)  //单位地址
	s PatNokPhone=$p($g(^PAPER(PatientID,"NOK")),"^",2)  //单位电话
	s PatHousehold=$p($g(^PAPER(PatientID,"DHC")),"^",33)  //户口地址
	
	s PatAddressDr=$o(^PAPER(PatientID,"PER","ADD",0))
	s PatAddress=$g(^PAPER(PatientID,"PER","ADD",PatAddressDr))  //住址
	
	s PatForeign=$p(PersonInfo,"^",16)  //联系人姓名
	s PatForeignAddress=$p(PersonInfo,"^",14)  //联系人地址
	s PatForeignPhone=$p(^PAPER(PatientID,"ALL"),"^",4)  //联系人电话
	s MedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatientID,"",$g(%session.Data("LOGON.HOSPID")))
	
	s TelH=$p(^PAPER(PatientID,"PER",1),"^",11)
	
	s MRAdmId="",DiagnosDesc=""
	s PaadmId=$p($g(^DHCDocIPBK(IPBookingID)),"^",2)
	if PaadmId'="" s MRAdmId=$p(^PAADM(PaadmId),"^",61)
	//if MRAdmId'="" s DiagnosDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmId,",")
	s DiagnosDesc=""
	s mrcIcdx=$p($g(^DHCDocIPBK(IPBookingID)),"^",14)
	i mrcIcdx'="" d
	.s DiagnosDesc=$p(^MRC("ID",mrcIcdx),"^",2)
    ;s DiagnosDesc=$p($g(^DHCDocIPBK(IPBookingID)),"^",19)
	s PatResultInfo=PatientID_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDob_"^"_PatID_"^"_PatNation_"^"_ParMarital
	s PatResultInfo=PatResultInfo_"^"_PatOccupation_"^"_PatHometown_"^"_PatType_"^"_PatNok_"^"_PatNokAddress
	s PatResultInfo=PatResultInfo_"^"_PatNokPhone_"^"_PatHousehold_"^"_PatAddress_"^"_PatForeign_"^"_PatForeignAddress_"^"_PatForeignPhone_"^"_MedicalNo_"^"_PatMobPhone_"^"_TelH_"^"_DiagnosDesc
	
	s EpisodeIDFrom=$p($g(^DHCDocIPBK(IPBookingID)),"^",2)
	//住院科室、住院病区、预约医生、预约日期、预缴押金、专业和病人床位指针
	s AppLoc=$p($g(^DHCDocIPBK(IPBookingID)),"^",13)  //预约科室
	s AppDoc=""
	s AppWardDr=$p($g(^DHCDocIPBK(IPBookingID)),"^",11) //预约病区
	s AppWard=$p($g(^PAWARD(AppWardDr)),"^",5)
	s AppDocUser=$p($g(^DHCDocIPBK(IPBookingID)),"^",6)  //预约医生
	s AppDoc=$p(^SSU("SSUSR",AppDocUser),"^",14)
	s AppDate=$p($g(^DHCDocIPBK(IPBookingID)),"^",10)  //10=>4  预约日期=>建证日期
	s AppCash=$p($g(^DHCDocIPBK(IPBookingID)),"^",17)
	s AppBedNo="",Specialty=""
	s TreatLevel=$p($g(^DHCDocIPBK(IPBookingID)),"^",20)  //患者等级
	
	//如果有预约信息调取
	if IPAppID'="" {
		s AppLoc=$p($g(^DHCDocIPApp(IPAppID)),"^",8)  //预约科室
		s AppWard=$p($g(^DHCDocIPApp(IPAppID)),"^",21) //预约病区
		s AppDoc=$p($g(^DHCDocIPApp(IPAppID)),"^",7)  //预约医生
		;s AppDate=$p($g(^DHCDocIPApp(IPAppID)),"^",11)   //预约日期
		s AppCash=$p($g(^DHCDocIPApp(IPAppID)),"^",12)  //预缴押金
		s AppBedNoDr=$p($g(^DHCDocIPApp(IPAppID)),"^",9)  //预约床号
		if AppBedNoDr'="" s AppBedNo=$p(^PAWARD(+AppBedNoDr,"BED",$p(AppBedNoDr,"||",2)),"^",1)
		s Specialty=$p($g(^DHCDocIPApp(IPAppID)),"^",20)  //专业
		s TreatLevel=$p($g(^DHCDocIPApp(IPAppID)),"^",22)  //患者等级
	}
	;s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"
	;q:(ConfigStr[("^"_AppLoc_"^")) "-500"
	s AppDate=$ZD(AppDate,3)
	//住院科室、住院病区、预约医生、预约日期、预缴押金、专业和病人床位指针
	s PatAppInfo=IPBookingID_"^"_IPAppID_"^"_AppLoc_"^"_AppWard_"^"_AppDoc_"^"_AppDate_"^"_AppCash_"^"_Specialty_"^"_AppBedNo_"^"_TreatLevel
	
	s ret=PatResultInfo_"$"_PatAppInfo_"$"_PAPMINo
	;s ret=$tr(ret,$c(13),"")
	q ret
}

/// CreatDate：  2014-03-27
/// Description：保存病人预约住院信息
/// Input：      IPAppointmentInfoStr:病人预约住院信息
/// 			 住院证ID^预约住院表ID^病人ID^操作员ID^预约病区ID^预约科室ID^预约医生ID^预约日期^预缴押金
/// Return：     0:成功
/// Debug:
ClassMethod SavaIPAppoinetmentInfo(IPAppointmentInfoStr As %String, PatientInfo As %String = "") As %String
{
	s IPAppointmentInfoStr=$tr(IPAppointmentInfoStr,"undefined")
	s PatientInfo=$tr(PatientInfo,"undefined")
	
	s ^TMP("SavaIPAppoinetmentInfo")=IPAppointmentInfoStr_","_PatientInfo
	q:IPAppointmentInfoStr=""
	
	s IPBookingDr=$p(IPAppointmentInfoStr,"^",1)
	s IPAppID=$p(IPAppointmentInfoStr,"^",2)
	s PatientID=$p(IPAppointmentInfoStr,"^",3)
	s SSUserID=$p(IPAppointmentInfoStr,"^",4)
	s AppWardID=$p(IPAppointmentInfoStr,"^",5)
	s AppLocID=$p(IPAppointmentInfoStr,"^",6)
	s AppDocID=$p(IPAppointmentInfoStr,"^",7)
	s AppDate=$p(IPAppointmentInfoStr,"^",8)
	s AppCash=$p(IPAppointmentInfoStr,"^",9)
	s Specialty=$p(IPAppointmentInfoStr,"^",10)
	s BookNo=$p(IPAppointmentInfoStr,"^",11)
	s TreatLevel=$p(IPAppointmentInfoStr,"^",12)
	s AppHospital=$p(IPAppointmentInfoStr,"^",13)
	s IfAccompany=$p(IPAppointmentInfoStr,"^",14)
	i AppHospital="" d
	.s AppHospital=$p($g(^CTLOC(AppLocID)),"^",22)
	s AccompanySex=""
	if IfAccompany="Y" s AccompanySex=$p(IPAppointmentInfoStr,"^",15)
	s MRDiagnos=$p(IPAppointmentInfoStr,"^",16)
	
	s acceptDate=$p(IPAppointmentInfoStr,"^",17) //收证日期
	
	i +AppLocID=0 d
	.s AppLocID=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(AppLocID),""))
	i +AppLocID=0 q "科室数据不正确!请重新选择科室"
	s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"
	i (ConfigStr[("^"_AppLocID_"^"))&&(AppLocID'="") q "该科室不能预约!" 
	;q:(PatientID="") "-500"
	
	//验证住院号是否重复
	s BookID=""
	if BookNo'="" {
		s BookID=$o(^DHCDocIPBK(0,"IPBookingNo",BookNo,0))
	}
	q:((IPBookingDr'="")&&(BookID'=IPBookingDr)&&(BookID'="")) "-305"
	q:((IPBookingDr="")&&(BookID'="")) "-305"
	
	s myrtn=0
	
	
	i AppDocID'="" d
	.s AppDocID=$o(^SSU("SSUSR",0,"CTPCP",AppDocID,""))
	if PatientID="" {
		s PAPMIName=$p(PatientInfo,"^",1)
		s PAPMISex=$p(PatientInfo,"^",2)
		s PAPMIAge=$p(PatientInfo,"^",3)
		s PAPMIDOB=$p(PatientInfo,"^",4)
		s PAPERID=$p(PatientInfo,"^",5)
		s PAPERNation=$p(PatientInfo,"^",6)
		s PAPERMaritalCode=$p(PatientInfo,"^",7)
		s PAPERMarital=""
		if PAPERMaritalCode'="" s PAPERMarital=$o(^CT("MAR",0,"Code",PAPERMaritalCode,""))
		s PAPEROccupation=$p(PatientInfo,"^",8)
		s PAPERBirthPlace=$p(PatientInfo,"^",9)
		s PAPERSocialStatus=$p(PatientInfo,"^",10)
		s PAPERMobPhone=$p(PatientInfo,"^",11)
		s PAPERNokName=$p(PatientInfo,"^",12)
		s PAPERNokAddress=$p(PatientInfo,"^",13)
		s PAPERNokPhone=$p(PatientInfo,"^",14)
		s RegisterPlace=$p(PatientInfo,"^",15)
		s Address=$p(PatientInfo,"^",16)
		s PAPERForeignName=$p(PatientInfo,"^",17)
		s PAPERForeignAddress=$p(PatientInfo,"^",18)
		s PAPERForeignPhone=$p(PatientInfo,"^",19)
		s CTRelation=$p(PatientInfo,"^",20)
		s TelH=$p(PatientInfo,"^",21)
		
		;s PatientID=$o(^PAPERi("DVA",PAPERID,""))
		//设置身份校验,有身份证号的患者出生日期与身份证号不符的不能保存
		i (PAPERID'="")&&(PAPMIDOB'=""){
			S Year=$Extract(PAPERID,7,10)
			s Month=$Extract(PAPERID,11,12)
			s Day=$Extract(PAPERID,13,14)
			s PAPMIDOBNum=Year_"-"_Month_"-"_Day
			i PAPMIDOBNum'=PAPMIDOB  q "-306"
		}
		if PatientID="" {
			s myPatObj=##class(web.DHCEntity.PCA.PATMAS).%New()
			s myPatObj.Name=PAPMIName
			s myPatObj.Sex=PAPMISex	
			s myPatObj.Birth=PAPMIDOB
			s myPatObj.IDCardNo1=PAPERID
			s myPatObj.CredType=1
			s myPatObj.CredNo=PAPERID
			s myPatObj.NationDescLookUpRowID=PAPERNation
			s myPatObj.PAPERMarital=PAPERMarital
			s myPatObj.Vocation=PAPEROccupation
			s myPatObj.HomePlace=PAPERBirthPlace
			s myPatObj.PatType=PAPERSocialStatus
			s myPatObj.MobPhone=PAPERMobPhone
			s myPatObj.Company=PAPERNokName
			s myPatObj.TelHome=PAPERNokPhone
			s myPatObj.RegisterPlace=RegisterPlace
			s myPatObj.Address=Address
			s myPatObj.ForeignName=PAPERForeignName
			s myPatObj.ForeignAddress=PAPERForeignAddress
			s myPatObj.ForeignPhone=PAPERForeignPhone
			s myPatObj.CTRelationDR=CTRelation
			s myPatObj.TelHome=TelH
			//PAPERNokAddress  
			s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(myPatObj)
			s PatientID=$p(myrtn,"^",2)
		}
	}
	
	q:(+myrtn'=0) +myrtn
	q:(PatientID="") "-500"
	if TreatLevel="" s TreatLevel=3
	
	s IPAppID=""
	if IPBookingDr'="" s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",IPBookingDr,0))
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	//没有住院证的插入住院证信息
	if IPBookingDr="" {
		s WardID=""
		if AppWardID'="" s WardID=$o(^PAWARD(0,"WARD_LocationDR",AppWardID,""))
		s Instring=""_"^"_PatientID_"^"_""_"^"_""_"^"_AppDate_"^"_CreateTime_"^"_SSUserID_"^"_SSUserID_"^"_8_"^"_"Y"_"^"_AppDate
		s Instring=Instring_"^"_WardID_"^"_""_"^"_AppLocID_"^"_""_"^"_""_"^"_""_"^"_AppCash_"^"_""_"^"_TreatLevel_"^"_""_"^"_BookNo
		s IPBookingDr=##class(web.DHCDocIPBookingCtl).Update(Instring)
		
		//DHCDocIPBKStates和DHCDocIPBKDetail表数据是否也要插入
	}
	
	if IPAppID'="" {
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		if IPAppStatus="Al" q "-300"  //已经分配
		if IPAppStatus="Ar" q "-301"  //已经入院
		if IPAppStatus="C" q "-302"   //已经作废
		;if IPAppStatus="B" q "-303"   //已经预约
		if IPAppStatus="H" q "-304"   //已经挂起
	}
	if AppDate'="" s AppDate=$ZDH(AppDate,3)
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	s CurrentDate=+$h
	s CurrentTime=$p($h,",",2)
	s IPStatus="B"
	
	if AppDate'="" s CreateDate=AppDate
	if acceptDate'="" s CreateDate=$ZDH(acceptDate,3) //收证日期
	
	s AppInDate=""
	s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"
	if (ConfigStr[("^"_AppLocID_"^")) s AppInDate=+$h
	s TimeEnd=$ZTH("17:30:00")
	s CreateTime=$p($h,",",2)
	if CreateTime>TimeEnd s AppInDate=+$h
	//SQL
	if (IPAppID="") {
		
		&SQL(Insert into DHCDocIPAppointment 
		(IPBookingDr,PatientID,CreateDate,CreateTime,CreateUserID,AppDocID,AppLocID,IPStatus,AppCash,LastUpdateDate,LastUpdateTime,Specialty,AppWardID,TeartLevel,AppHospitalID,IfAccompany,AccompanySex,AppDate,PaDiagnos) 
		values 
		(:IPBookingDr,:PatientID,:CreateDate,:CreateTime,:SSUserID,:AppDocID,:AppLocID,:IPStatus,:AppCash,:CurrentDate,:CurrentTime,:Specialty,:AppWardID,:TreatLevel,:AppHospital,:IfAccompany,:AccompanySex,:AppInDate,:MRDiagnos)
		)
		
	}else {
		&SQL(Update DHCDocIPAppointment
		set IPBookingDr=:IPBookingDr,
		PatientID=:PatientID,
		AppDocID=:AppDocID,
		AppLocID=:AppLocID,
		IPStatus=:IPStatus,
		AppCash=:AppCash,
		LastUpdateDate=:CurrentDate,
		LastUpdateTime=:CurrentTime,
		Specialty=:Specialty,
		AppWardID=:AppWardID,
		TeartLevel=:TreatLevel,
		AppHospitalID=:AppHospital,
		IfAccompany=:IfAccompany,
		AccompanySex=:IfAccompany,
		AppDate=:AppInDate,
		PaDiagnos=:MRDiagnos
		where RowID=:IPAppID
		)
	}
	
	i SQLCODE'="0" q "100"
	i SQLCODE="0" {
		s WardID=$o(^PAWARD(0,"WARD_LocationDR",AppWardID,""))
		s $p(^DHCDocIPBK(IPBookingDr),"^",11)=WardID
		s $p(^DHCDocIPBK(IPBookingDr),"^",13)=AppLocID
	}
	q 0
}

/// CreatDate：  2014-03-27
/// Description：作废预约住院记录
/// Input：      IPAppID:DHCDocIPAppointment表RowID
/// 			 CancleID:DHCDocIPCancleReason表RowID
/// Return：     0:成功
/// Debug:
ClassMethod CancleIPAppointment(IPAppIDArr As %String, CancleID As %String) As %String
{
	q:IPAppIDArr=""
	;s ^TMP("CancleIPAppointment")=IPAppIDArr_","_CancleID
	s Count=$l(IPAppIDArr,"^")
	s ret=0
	f i=1:1:Count {
		s IPAppID=$p(IPAppIDArr,"^",i)
		//预约状态判断，入院不能作废，分配要将床位释放返回空床列表
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		q:(IPAppStatus="C") //"-200"  //已经作废
		q:(IPAppStatus="Ar") //"-201"  //已经入院
		s CurrentDate=+$h
		s CurrentTime=$p($h,",",2)
		if (IPAppStatus="Al") {
			s BedRowId=$p($g(^DHCDocIPApp(IPAppID)),"^",9)
			//将分配床位释放  (需要护士站提供方法)
			if BedRowId'="" s ^DHCNurBedManager("AppBed",BedRowId)=0_"^"_CurrentDate
			
			////////////2014-06-06
			s PatientId=$p($g(^DHCDocIPApp(IPAppID)),"^",2)
			s UserId=%session.Get("LOGON.USERID")
			s ret=##class(Nur.DHCBedApointflag).Cancel("C",UserId,PatientId)
			////////////end
		}
		/*
		s $p(^DHCDocIPApp(IPAppID),"^",10)="C"
		s $p(^DHCDocIPApp(IPAppID),"^",13)=CancleID
		s CurrentTime=$h
		s $p(^DHCDocIPApp(IPAppID),"^",16)=+CurrentTime
		s $p(^DHCDocIPApp(IPAppID),"^",17)=$p(CurrentTime,",",2)
		s $p(^DHCDocIPApp(IPAppID),"^",18)=+CurrentTime
		s $p(^DHCDocIPApp(IPAppID),"^",19)=$p(CurrentTime,",",2)
		*/
		
		s IPStatus="C" 
		&SQL(Update DHCDocIPAppointment
			set IPStatus=:IPStatus,
			BedNODr=null,
			AllocateDate=null,
			AllocateTime=null,
			AppDate=null,
			CancleReasonDr=:CancleID,
			CancleDate=:CurrentDate,
			CancleTime=:CurrentTime,
			LastUpdateDate=:CurrentDate,
			LastUpdateTime=:CurrentTime,
			InfoCancelUserID=:UserId
			where RowID=:IPAppID
			)
		s ret=ret+SQLCODE
	}
	q ret
}

/// CreatDate：  2014-03-27
/// Description：分配床位
/// Input：      IPAppID:DHCDocIPAppointment表RowID
/// 				 BedRowId:PAC_Bed表RowID
/// Return：     0:成功
/// Debug:
ClassMethod AllocateIPAppoitment(IPAppID As %String, BedRowId As %String, AppDate As %String, OneDayFlag As %String) As %String
{
	s ^TMP("AllocateIPAppoitment")=IPAppID_","_BedRowId_","_AppDate_","_OneDayFlag
	q:((IPAppID="")||(BedRowId="")) "-404"
	s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
	q:(IPAppStatus="C") "-200"  //已经作废
	q:(IPAppStatus="Ar") "-201"  //已经入院
	q:(IPAppStatus="Al") "-202"  //已经分配
	
	s CurrentDate=+$h
	s CurrentTime=$p($h,",",2)
	
	s AppDate1=$ZDH(AppDate,3)
	q:AppDate1<CurrentDate "-300"
	
	///控制配置的科室不能分配床位
	s AppLocId=$p(^DHCDocIPApp(IPAppID),"^",8)
	s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"
	q:(ConfigStr[("^"_AppLocId_"^")) "-800"
	
	/*
	s $p(^DHCDocIPApp(IPAppID),"^",10)="Al"
	s $p(^DHCDocIPApp(IPAppID),"^",9)=BedRowId
	s CurrentTime=$h
	s $p(^DHCDocIPApp(IPAppID),"^",14)=+CurrentTime
	s $p(^DHCDocIPApp(IPAppID),"^",15)=$p(CurrentTime,",",2)
	s $p(^DHCDocIPApp(IPAppID),"^",18)=+CurrentTime
	s $p(^DHCDocIPApp(IPAppID),"^",19)=$p(CurrentTime,",",2)
	*/
	
	s PatientId=$p($g(^DHCDocIPApp(IPAppID)),"^",2)
	s UserId=%session.Get("LOGON.USERID")
	s endDate=""
	if OneDayFlag=1 s endDate=AppDate
	
	s ret=##class(Nur.DHCBedApointflag).IfBedCanApoint(BedRowId,AppDate,endDate)
	q:ret'=0 "-600"
	
	s ret=##class(Nur.DHCBedApointflag).Save(BedRowId,AppDate,endDate,"V",UserId,PatientId)
	
	q:ret'=0 "-500"
	//床位表占资源 (护士站提供接口)
	s ^DHCNurBedManager("AppBed",BedRowId)=1_"^"_CurrentDate
	s IPStatus="Al"
	
	&SQL(Update DHCDocIPAppointment
		set IPStatus=:IPStatus,
		BedNODr=:BedRowId,
		AppDate=:AppDate1,
		AllocateDate=:CurrentDate,
		AllocateTime=:CurrentTime,
		LastUpdateDate=:CurrentDate,
		LastUpdateTime=:CurrentTime,
		BedDistributeUserID=:UserId
		where RowID=:IPAppID
		)
	
	q SQLCODE
}

ClassMethod CancleAllocateIPAppoitmentByBookId(BoolId As %String) As %String
{
	q:BoolId="" "-100"
	s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",BoolId,0))
	q:IPAppID="" "-200"
	s ret=..CancleAllocateIPAppoitment(IPAppID)
	q ret
}

/// CreatDate：  2014-03-27
/// Description：取消分配
/// Input：      IPAppID:DHCDocIPAppointment表RowID
/// Return：     0:成功
/// Debug:
ClassMethod CancleAllocateIPAppoitment(IPAppIDArr As %String) As %String
{
	q:IPAppIDArr="" "-404"
	
	s Count=$l(IPAppIDArr,"^")
	s ret=0
	f i=1:1:Count {
		s IPAppID=$p(IPAppIDArr,"^",i)
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		q:(IPAppStatus'="Al") //"-100"  //不是分配状态
		
		s CurrentDate=+$h
		s CurrentTime=$p($h,",",2)
		//将分配床位释放  (需要护士站提供方法)
		s BedRowId=$p($g(^DHCDocIPApp(IPAppID)),"^",9)
		s ^DHCNurBedManager("AppBed",BedRowId)=0_"^"_CurrentDate
		
		s PatientId=$p($g(^DHCDocIPApp(IPAppID)),"^",2)
		s UserId=%session.Get("LOGON.USERID")
		s ret=##class(Nur.DHCBedApointflag).Cancel("C",UserId,PatientId)
		
		/*
		s $p(^DHCDocIPApp(IPAppID),"^",10)="B"
		s $p(^DHCDocIPApp(IPAppID),"^",9)=""
		s $p(^DHCDocIPApp(IPAppID),"^",14)=""
		s $p(^DHCDocIPApp(IPAppID),"^",15)=""
		s $p(^DHCDocIPApp(IPAppID),"^",18)=+CurrentDate
		s $p(^DHCDocIPApp(IPAppID),"^",19)=$p(CurrentDate,",",2)
		*/
		s IPStatus="B"
		&SQL(Update DHCDocIPAppointment
			set IPStatus=:IPStatus,
			BedNODr=null,
			AllocateDate=null,
			AllocateTime=null,
			AppDate=null,
			LastUpdateDate=:CurrentDate,
			LastUpdateTime=:CurrentTime
			where RowID=:IPAppID
		)
		s ret=ret+SQLCODE
	}	
	q ret
}

ClassMethod CancleArriveIPAppointment(IPAppId As %String) As %String
{
	q:IPAppId="" "-404"
	s IPAppStatus=$p($g(^DHCDocIPApp(IPAppId)),"^",10)
	q:(IPAppStatus'="Ar") "-100"  //不是入院状态
	
	s CurrentDate=+$h
	s CurrentTime=$p($h,",",2)
	
	s IPStatus="Al"
	&SQL(Update DHCDocIPAppointment
		set IPStatus=:IPStatus,
		EpisodeIDTo=null,
		LastUpdateDate=:CurrentDate,
		LastUpdateTime=:CurrentTime
		where RowID=:IPAppId
	)
	q SQLCODE
}

/// CreatDate：  2014-03-27
/// Description：挂起预约记录
/// Input：      IPAppID:DHCDocIPAppointment表RowID
/// Return：     0:成功
/// Debug:
ClassMethod HangIPAppoitment(IPAppIDArr As %String) As %String
{
	q:IPAppIDArr="" ""
	
	s Count=$l(IPAppIDArr,"^")
	s ret=""
	f i=1:1:Count {
		s IPAppID=$p(IPAppIDArr,"^",i)
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		i ((IPAppStatus'="B")&&(IPAppStatus'="Al")) s ret="状态不对,不能挂起!"
		
		s CurrentDate=+$h
		s CurrentTime=$p($h,",",2)
		s BedRowId=$p($g(^DHCDocIPApp(IPAppID)),"^",9)
		if BedRowId'="" s ^DHCNurBedManager("AppBed",BedRowId)=0_"^"_CurrentDate
		
		s PatientId=$p($g(^DHCDocIPApp(IPAppID)),"^",2)
		s UserId=%session.Get("LOGON.USERID")
		s ret=##class(Nur.DHCBedApointflag).Cancel("C",UserId,PatientId)
		
		s IPStatus="H"
		&SQL(Update DHCDocIPAppointment
			set IPStatus=:IPStatus,
			BedNODr=null,
			AllocateDate=null,
			AllocateTime=null,
			AppDate=null,
			HangStartDate=:CurrentDate,
			LastUpdateDate=:CurrentDate,
			LastUpdateTime=:CurrentTime
			where RowID=:IPAppID
		)
		s ret=ret+SQLCODE
	}
	q ret
}

ClassMethod CancleHangIPAppoitment(IPAppIDArr As %String) As %String
{
	q:IPAppIDArr="" ""
	
	s Count=$l(IPAppIDArr,"^")
	s ret=0
	f i=1:1:Count {
		s IPAppID=$p(IPAppIDArr,"^",i)
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		q:(IPAppStatus'="H") //"-400"
		
		s CurrentDate=+$h
		s CurrentTime=$p($h,",",2)
		s IPStatus="B"
		&SQL(Update DHCDocIPAppointment
			set IPStatus=:IPStatus,
			HangEndDate=:CurrentDate,
			LastUpdateDate=:CurrentDate,
			LastUpdateTime=:CurrentTime
			where RowID=:IPAppID
		)
		s ret=ret+SQLCODE
	}
	q ret
}

/// d ##Class(%ResultSet).RunQuery("web.DHCDocIPAppointment","GetIPAppPatientList","","","","","","","","","","","1","","","")
Query GetIPAppPatientList(IPBookNo As %String, PAPMINO As %String, PatName As %String, BookStartDate As %Date, BookEndDate As %Date, AppDate As %Date, AppWard As %String, AppLoc As %String, AppDoc As %String, IfAllocate As %String, SortMethod As %String = "", DateCondition As %String = "", AccompanySexID As %String = "", PageFlag As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "count:%String,IPAppID:%String,myPAPMINO:%String,myIPBookNo:%String,myBookDate:%String,myPatName:%String,myPatSex:%String,PatType:%String,myAppLoc:%String,myAppDate:%String,BedNo:%String,IPStatus:%String,IPDate:%String,myAppLocDr:%String,BedNoDr:%String,PatAddress:%String,PatMobPhone:%String,TelH:%String,PatNameFlag:%String,AccompanySex:%String,myMedicalNo,myPatAge,myInfoEnterUser,myBedDistributeUser,myInfoCancelUser,CTDoc")
{
}

ClassMethod GetIPAppPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPAppPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetIPAppPatientListExecute(ByRef qHandle As %Binary, IPBookNo As %String, PAPMINO As %String, PatName As %String, BookStartDate As %Date, BookEndDate As %Date, AppDate As %Date, AppWard As %String, AppLoc As %String, AppDoc As %String, IfAllocate As %String, SortMethod As %String = "", DateCondition As %String = "", AccompanySexID As %String = "", PageFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s ^TMP("GetIPAppPatientList")=IPBookNo_","_PAPMINO_","_PatName_","_BookStartDate_","_BookEndDate_","_AppDate_","_AppWard_","_AppLoc_","_AppDoc_","_IfAllocate_","_SortMethod_","_DateCondition_","_AccompanySexID_","_PageFlag
	s PatName=$zu(28,PatName,6)
	i IfAllocate="" s IfAllocate="B"
	i SortMethod="" s SortMethod=1
	s count=1
	s Sortuserid=%session.Data("LOGON.USERID")
	k ^orderbyRegistrationtime(Sortuserid,$j)
	k ^orderbytimeforissuing(Sortuserid,$j)
	k ^orderbyTreatLevel(Sortuserid,$j)
	/*  同仁需求 录入住院证号或登记号查询单个患者信息时，按原来排序跳到目标行
	if IPBookNo'="" {
		s IPBookID=$o(^DHCDocIPBK(0,"IPBookingNo",IPBookNo,0))
		s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",IPBookID,0))
		if IPAppID'="" {
			s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
			if (IPStatus=IfAllocate)  d
			.d OutputRow
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if PAPMINO'="" {
		s PatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINO,0))
		s IPAppID=""
		f  s IPAppID=$o(^DHCDocIPApp(0,"PatientID",PatientID,IPAppID))  q:IPAppID=""  d
		.s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
		.q:(IPStatus'=IfAllocate)
		.d OutputRow
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	*/
	/*  为支持名字模糊查询
	if PatName'="" {
		s PatientID=""
		f  s PatientID=$o(^PAPERi("PAPER_PatName",PatName,PatientID))  q:PatientID=""  d
		.s IPAppID=""
		.f  s IPAppID=$o(^DHCDocIPApp(0,"PatientID",PatientID,IPAppID))  q:IPAppID=""  d
		..s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
		..q:(IPStatus'=IfAllocate)
		..d OutputRow
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	*/
	k ^TMP("IPAppointment",$j)  //$Job包含一个正整数，表示系统所分配给每一个在执行中的进程独一无二的编号。当进程还在的时候，$JOB 的值是不变的。
	
	s CurrentDate=$ZD(+$h,3)
	s CurrentYear=$p(CurrentDate,"-",1)
	s CurrentMonth=$p(CurrentDate,"-",2)
	s CurrentDay=$p(CurrentDate,"-",3)
	s ConditionDate=""
	if (DateCondition=1) {
		if (CurrentMonth>3) {
			s CurrentMonth=CurrentMonth-3
		} else {
			s CurrentMonth=CurrentMonth-3+12
			s CurrentYear=CurrentYear-1
		}
		s ConditionDate=CurrentYear_"-"_CurrentMonth_"-"_CurrentDay
	} elseif (DateCondition=2) {
		if (CurrentMonth>6) {
			s CurrentMonth=CurrentMonth-6
		} else {
			s CurrentMonth=CurrentMonth-6+12
			s CurrentYear=CurrentYear-1
		}
		s ConditionDate=CurrentYear_"-"_CurrentMonth_"-"_CurrentDay
	} elseif (DateCondition=3) {
		s CurrentYear=CurrentYear-1
		s ConditionDate=CurrentYear_"-"_CurrentMonth_"-"_CurrentDay
	} elseif (DateCondition=4) {
		s CurrentYear=CurrentYear-2
		s ConditionDate=CurrentYear_"-"_CurrentMonth_"-"_CurrentDay
	}
	
	if ConditionDate'="" s ConditionDate=$ZDH(ConditionDate,3)
	
	if BookStartDate'="" s BookStartDate=$ZDH(BookStartDate,3)
	if BookEndDate'="" s BookEndDate=$ZDH(BookEndDate,3)
	if AppDate'="" s AppDate=$ZDH(AppDate,3)
	
	//同仁需求 要求所有住院证都要到床管中心处理
	s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"
	
	s IPAppID=""
	;S myMedicalNo=""
	s PatNameCount=0
	f  s IPAppID=$o(^DHCDocIPApp(0,"IPStatus",IfAllocate,IPAppID))  q:IPAppID=""  d
	.s myBookDate=$p(^DHCDocIPApp(IPAppID),"^",4)  //预约生成日期
	.q:((BookStartDate'="")&&(BookStartDate>myBookDate))
	.q:((BookEndDate'="")&&(BookEndDate<myBookDate))
	.s myAppWardDr=$p(^DHCDocIPApp(IPAppID),"^",21)
	.q:((AppWard'="")&&(AppWard'=myAppWardDr))
	.s myAppLocDr=$p(^DHCDocIPApp(IPAppID),"^",8)
	.q:((AppLoc'="")&&(AppLoc'=myAppLocDr))
	.//////q:((PageFlag=1)&&(ConfigStr[("^"_myAppLocDr_"^")))    //同仁需求 要求所有住院证都要到床管中心处理
	.q:(ConfigStr[("^"_myAppLocDr_"^"))
	.s myAppDocDr=$p(^DHCDocIPApp(IPAppID),"^",7)
	.q:((AppDoc'="")&&(AppDoc'=myAppDocDr))
	.s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
	.s myAppDate=$p(^DHCDocIPApp(IPAppID),"^",11)       //预约住院日期
	.q:(AppDate'="")&&(AppDate'=myAppDate)&&((IfAllocate="Al")||(IfAllocate="Ar"))
	.q:(IPStatus'=IfAllocate) 
	.q:((ConditionDate'="")&&(myBookDate>ConditionDate))
	.//new add 姓名过滤
	.s myPatientID=$p(^DHCDocIPApp(IPAppID),"^",2)  
    .s myPatName=$p(^PAPER(myPatientID,"ALL"),"^",1)	   //病人姓名
    .s myPatName2=$p(^PAPER(myPatientID,"ALL"),"^",2)	   //病人姓名简
    .s myPatName=myPatName_myPatName2
    .s myPatName=$zu(28,myPatName,6)
    .s PatName=$zu(28,PatName,6)
    .q:(PatName'="")&(myPatName'[PatName)
    .s myPatSexId=$p(^PAPER(myPatientID,"ALL"),"^",7)
	.q:((AccompanySexID'="")&&(AccompanySexID'=myPatSexId))
    .s myPAPMINO=$p(^PAPER(myPatientID,"PAT",1),"^",2)  //登记号
    .q:(PAPMINO'="")&(myPAPMINO'[PAPMINO)   ///登记号过滤
    .//*******************************
	
	.s myBookDate1=$p(^DHCDocIPApp(IPAppID),"^",4)     //登记日期
	.s myBookTime=$p(^DHCDocIPApp(IPAppID),"^",5)
	.s myIPBookID=$p(^DHCDocIPApp(IPAppID),"^",1)
	.//new add
	.s myIPBookNo=$p($g(^DHCDocIPBK(myIPBookID)),"^",20)
	.q:(IPBookNo'="")&(myIPBookNo'[IPBookNo)  ///住院证号
	.//*******************
    .s myIPBookDate=$p(^DHCDocIPBK(myIPBookID),"^",4) //住院证号、建住院证日期，时间
    .s myIPBookTime=$p(^DHCDocIPBK(myIPBookID),"^",5)  
    .s:myBookDate1="" myBookDate1=+$h
    .s:myBookTime="" myBookTime=$p($h,",",2)
    .s:myIPBookDate="" myIPBookDate=+$h
    .s:myIPBookDate="" myIPBookDate=$p($h,",",2)
    .s myTreatLevel=$p(^DHCDocIPApp(IPAppID),"^",22)  //就诊级别 
    .s:myTreatLevel="" myTreatLevel="3"
	.i SortMethod="1" d
	
	..s ^orderbyRegistrationtime(Sortuserid,$j,myBookDate1,myBookTime,IPAppID)=""  ///登记时间
	.i SortMethod="2" d
	..s ^orderbytimeforissuing(Sortuserid,$j,myIPBookDate,myIPBookTime,IPAppID)=""  ///建证时间
	.i SortMethod["^" d
	..s ^orderbyTreatLevel(Sortuserid,$j,myTreatLevel,myBookDate1,myBookTime,IPAppID)=""  ///就诊级别
	i SortMethod="1"
	{
	s Node1="" f  s Node1=$o(^orderbyRegistrationtime(Sortuserid,$j,Node1)) q:Node1=""  d
	.s Node2="" f  s Node2=$o(^orderbyRegistrationtime(Sortuserid,$j,Node1,Node2)) q:Node2=""  d
	..s IPAppID="" f  s IPAppID=$o(^orderbyRegistrationtime(Sortuserid,$j,Node1,Node2,IPAppID)) q:IPAppID=""  d
	...d GetList
	}
	i SortMethod="2"
	{
	s Node1="" f  s Node1=$o(^orderbytimeforissuing(Sortuserid,$j,Node1)) q:Node1=""  d
	.s Node2="" f  s Node2=$o(^orderbytimeforissuing(Sortuserid,$j,Node1,Node2)) q:Node2=""  d
	..s IPAppID="" f  s IPAppID=$o(^orderbytimeforissuing(Sortuserid,$j,Node1,Node2,IPAppID)) q:IPAppID=""  d
	...d GetList
	}
	i SortMethod["^"
	{
		s Node2=""
		f  s Node2=$o(^orderbyTreatLevel(Sortuserid,$j,$p(SortMethod,"^",2),Node2)) q:Node2=""  d
		.s Node3="" f  s Node3=$o(^orderbyTreatLevel(Sortuserid,$j,$p(SortMethod,"^",2),Node2,Node3)) q:Node3=""  d
		..s IPAppID="" f  s IPAppID=$o(^orderbyTreatLevel(Sortuserid,$j,$p(SortMethod,"^",2),Node2,Node3,IPAppID)) q:IPAppID=""  d
		
		...d GetList
		s Node1=""
		f  s Node1=$o(^orderbyTreatLevel(Sortuserid,$j,Node1)) q:Node1=""  d
		.q:Node1=$p(SortMethod,"^",2)
		.s Node2="" f  s Node2=$o(^orderbyTreatLevel(Sortuserid,$j,Node1,Node2)) q:Node2=""  d
		..s Node3="" f  s Node3=$o(^orderbyTreatLevel(Sortuserid,$j,Node1,Node2,Node3)) q:Node3=""  d
		...s IPAppID="" f  s IPAppID=$o(^orderbyTreatLevel(Sortuserid,$j,Node1,Node2,Node3,IPAppID)) q:IPAppID=""  d
		....d GetList
		}
	
	/*s PageCount=0
	if PatNameCount>1 {
		s Method="" f  s Method=$o(^TMP("IPAppointment",$j,Method))  q:Method=""  d
		.s PatNameFlag=$List(^TMP("IPAppointment",$j,Method),19) //$List缩写为$LI ， 取出一个或者多个列表的元素.$List(L,2,2),取出列表中第二个元素
		.q:PatNameFlag=1
		.s $List(^TMP("IPAppointment",$j,Method),19)=1
		.Set ^CacheTemp(repid,ind)=^TMP("IPAppointment",$j,Method)
		.s PageCount=PageCount+1
		.Set ind=ind+1
	} else {
		s Method="" f  s Method=$o(^TMP("IPAppointment",$j,Method))  q:Method=""  d
		.Set ^CacheTemp(repid,ind)=^TMP("IPAppointment",$j,Method)
		.s PageCount=PageCount+1
		.Set ind=ind+1
	} */
	
 	Set qHandle=$lb(0,repid,0)
 	k ^TMP("IPAppointment",$j)
 	k ^orderbyRegistrationtime(Sortuserid,$j)
	k ^orderbytimeforissuing(Sortuserid,$j)
	k ^orderbyTreatLevel(Sortuserid,$j)
	Quit $$$OK
	d OutputRow
	
GetList
	s myMedicalNo=""

	s myPatientID=$p(^DHCDocIPApp(IPAppID),"^",2)  
	s myPAPMINO=$p(^PAPER(myPatientID,"PAT",1),"^",2)  //登记号
	S myMedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(myPatientID,"",$g(%session.Data("LOGON.HOSPID")))
	s myPatDob=$p(^PAPER(myPatientID,"ALL"),"^",6)
	s myPatAge=##class(web.DHCBillInterface).GetPapmiAge(myPatientID)
	s myPatAge=$p(myPatAge,"^",1)
	;B ;
 	s myIPBookID=$p(^DHCDocIPApp(IPAppID),"^",1)  
	s myIPBookNo="",myIPBookDate=""
	if myIPBookID'="" s myIPBookNo=$p($G(^DHCDocIPBK(myIPBookID)),"^",20) s myIPBookDate=$p(^DHCDocIPBK(myIPBookID),"^",4) s myIPBookTime=$p(^DHCDocIPBK(myIPBookID),"^",5)  //住院证号、建住院证日期，时间
	
	i myIPBookDate="" s myIPBookDate=+$h
	s myBookDate1=$p(^DHCDocIPApp(IPAppID),"^",4)     //登记日期
	s myBookTime=$p(^DHCDocIPApp(IPAppID),"^",5)
	if myBookDate'="" s myBookDate=$ZD(myBookDate1,3)
	s myPatName=$p(^PAPER(myPatientID,"ALL"),"^",1)	   //病人姓名
	s PatNameFlag=1
	if ((PatName'="")&&(myPatName[PatName)) s PatNameFlag=0 s PatNameCount=PatNameCount+1  //q:((PatName'="")&&(myPatName'[PatName))
	
	///同仁需求 录入住院证号或登记号查询单个患者信息时，按原来排序跳到目标行
	s PageIPAppID=""
	if IPBookNo'="" {
		s PageIPBookID=$o(^DHCDocIPBK(0,"IPBookingNo",IPBookNo,0))
		if PageIPBookID'="" s PageIPAppID=$o(^DHCDocIPApp(0,"IPBookingID",PageIPBookID,0))
	}
	///q:(IPBookNo'="")&&(PageIPAppID="")
	if PAPMINO'="" {
		s PagePatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINO,0))
		s PageIPAppID1=""
		f  s PageIPAppID1=$o(^DHCDocIPApp(0,"PatientID",PagePatientID,PageIPAppID1))  q:PageIPAppID1=""  d
		.s PageIPStatus=$p(^DHCDocIPApp(PageIPAppID1),"^",10)
		.q:(PageIPStatus'=IfAllocate)
		.s PageIPAppID=PageIPAppID1
	}
	q:(PAPMINO'="")&&(PageIPAppID="")
	if ((PageIPAppID'="")&&(PageIPAppID=IPAppID)) s PatNameFlag=0 s PatNameCount=PatNameCount+1
	///end
	
	s myPatSexDr=$p(^PAPER(myPatientID,"ALL"),"^",7)
	s myPatSex=$p(^CT("SEX",myPatSexDr),"^",2)
	s PatTypeDr=$p($g(^PAPER(myPatientID,"PER",1)),"^",10)
	s PatType=""
	if PatTypeDr'="" s PatType=$p($g(^CT("SS",PatTypeDr)),"^",2)  //病人类型
	s myAppLocDr=$p(^DHCDocIPApp(IPAppID),"^",8)
	s myAppLocDesc=$p($g(^CTLOC(myAppLocDr)),"^",2)          //预约科室
	s myAppLoc=$p(myAppLocDesc,"-",2)
	s myAppDate=$p(^DHCDocIPApp(IPAppID),"^",11)       //预约住院日期
	if myAppDate'="" s myAppDate=$ZD(myAppDate,3)
	s BedNoDr=$p(^DHCDocIPApp(IPAppID),"^",9)
	s BedNo=""
	if BedNoDr'="" s BedNo=$p(^PAWARD(+BedNoDr,"BED",$p(BedNoDr,"||",2)),"^",1)          //床号
	s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)       //预约状态
	if IPStatus="C" {
		s IPStatus="取消"
		s CancleId=$p(^DHCDocIPApp(IPAppID),"^",13)
		s Cancle=""
		if CancleId'="" s Cancle=$p(^DHCDocIPCR(CancleId),"^",2)
		s IPStatus=IPStatus_"("_Cancle_")"
	}
	
	/// 预约状态转为汉字
	if IPStatus="B" {
		s IPStatus="预约"
	}
	if IPStatus="Al" {
		s IPStatus="分配"
	}
	if IPStatus="Ar" {
		s IPStatus="入院"
		
		/// 入院病人取当前所在床位
		s PaadmId=$p(^DHCDocIPApp(IPAppID),"^",3)
		s BedNoDr=$p(^PAADM(PaadmId),"^",73)
		if BedNoDr'="" s BedNo=$p(^PAWARD(+BedNoDr,"BED",$p(BedNoDr,"||",2)),"^",1)
		///  end
	}
	if IPStatus="H" {
		s IPStatus="挂起"
	}
	///
	
	s PaadmID=$p(^DHCDocIPApp(IPAppID),"^",3)  
	s IPDate=""
	if PaadmID'="" d
	.s IPDate=$p(^PAADM(PaadmID),"^",6)  //入院日期
	.s IPDate=$ZD(IPDate,3)

	.s AdmDate=##class(web.DHCDischargeHistory).GetAdminDateTime(PaadmID)
	.s admDate=$p(AdmDate,"^",1)
	.i admDate'="" s IPDate=$ZD(admDate,3)
	s myTreatLevel=$p(^DHCDocIPApp(IPAppID),"^",22)  //就诊级别
		
	s PatAddressDr=$o(^PAPER(myPatientID,"PER","ADD",0))
	s PatAddress=$g(^PAPER(myPatientID,"PER","ADD",PatAddressDr))  //住址
	
	s PatMobPhone=$p(^PAPER(myPatientID,"PER",4),"^",21)  //联系电话
	s TelH=$p(^PAPER(myPatientID,"PER",1),"^",11)  //家庭电话
	
	s AccompanySexId=$p(^DHCDocIPApp(IPAppID),"^",27)  //陪同人性别
	s AccompanySex=""
	if AccompanySexId'="" s AccompanySex=$p(^CT("SEX",AccompanySexId),"^",2)
	
	s AccompanySexFlag=1
	if (AccompanySexID'="")&&(AccompanySexID=AccompanySexId) s AccompanySexFlag=""
	
	if (AccompanySexId="")&&(AccompanySexID'="")&&(AccompanySexID=myPatSexDr) s AccompanySexFlag=""
	s myBedDistributeUserID=$p(^DHCDocIPApp(IPAppID),"^",29) //床位分配人
	s myBedDistributeUser=""
	i myBedDistributeUserID'="" s myBedDistributeUser=$p(^SSU("SSUSR",myBedDistributeUserID),"^",2)	
	s myInfoCancelUserID=$p(^DHCDocIPApp(IPAppID),"^",30) //预约信息作废人
	s myInfoCancelUser=""
	i myInfoCancelUserID'="" s myInfoCancelUser=$p(^SSU("SSUSR",myInfoCancelUserID),"^",2)
	s myInfoEnterUserID=$p(^DHCDocIPApp(IPAppID),"^",6) //预约信息录入人
	s myInfoEnterUser=""
	i myInfoEnterUserID'="" s myInfoEnterUser=$p(^SSU("SSUSR",myInfoEnterUserID),"^",2)
	///['1', '登记时间'],['2', '开证时间'],['3', '门诊优先'],['4', '急诊优先']
	if SortMethod=2  d
	.///set ^TMP("IPAppointment",$j,AccompanySexFlag_myIPBookDate_myIPBookTime)=$lb(count,IPAppID,myPAPMINO,myIPBookNo,myBookDate,myPatName,myPatSex,PatType,myAppLocDesc,myAppDate,BedNo,IPStatus,IPDate,myAppLocDr,BedNoDr,PatAddress,PatMobPhone,TelH,PatNameFlag,AccompanySex,myMedicalNo,myPatAge,myInfoEnterUser,myBedDistributeUser,myInfoCancelUser)
	if SortMethod=1  d
	.///set ^TMP("IPAppointment",$j,AccompanySexFlag_myBookDate1_myBookTime)=$lb(count,IPAppID,myPAPMINO,myIPBookNo,myBookDate,myPatName,myPatSex,PatType,myAppLocDesc,myAppDate,BedNo,IPStatus,IPDate,myAppLocDr,BedNoDr,PatAddress,PatMobPhone,TelH,PatNameFlag,AccompanySex,myMedicalNo,myPatAge,myInfoEnterUser,myBedDistributeUser,myInfoCancelUser)
	if +SortMethod=3  d   //sortMethod
	.s TreatLevel=$p(SortMethod,"^",2)
	.///if TreatLevel=myTreatLevel set ^TMP("IPAppointment",$j,AccompanySexFlag_1_myIPBookDate_myIPBookTime)=$lb(count,IPAppID,myPAPMINO,myIPBookNo,myBookDate,myPatName,myPatSex,PatType,myAppLocDesc,myAppDate,BedNo,IPStatus,IPDate,myAppLocDr,BedNoDr,PatAddress,PatMobPhone,TelH,PatNameFlag,AccompanySex,myMedicalNo,myPatAge,myInfoEnterUser,myBedDistributeUser,myInfoCancelUser)
	.///if TreatLevel'=myTreatLevel set ^TMP("IPAppointment",$j,AccompanySexFlag_2_myIPBookDate_myIPBookTime)=$lb(count,IPAppID,myIPBookNo,myBookDate,myPatName,myMedicalNo,myPatSex,PatType,myAppLocDesc,myAppDate,BedNo,IPStatus,IPDate,myAppLocDr,BedNoDr,PatAddress,PatMobPhone,TelH,PatNameFlag,AccompanySex,myMedicalNo,myPatAge,myInfoEnterUser,myBedDistributeUser,myInfoCancelUser)
	;Set ^CacheTemp(repid,ind)=Data
	;Set ind=ind+1
	s appDoc=$p(^DHCDocIPApp(IPAppID),"^",7)  //预约医生
	i appDoc'="" s appDoc=$p($G(^SSU("SSUSR",appDoc)),"^",2)
	s count=count+1  //序号
	///q

OutputRow
	/*s myMedicalNo=""
	s myPatientID=$p(^DHCDocIPApp(IPAppID),"^",2)  
	s myPAPMINO=$p(^PAPER(myPatientID,"PAT",1),"^",2)  //登记号
	S myMedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(myPatientID,"",$g(%session.Data("LOGON.HOSPID")))  //病案号
 	s myIPBookID=$p(^DHCDocIPApp(IPAppID),"^",1)  
	s myIPBookNo="",myIPBookDate=""
	if myIPBookID'="" s myIPBookNo=$p(^DHCDocIPBK(myIPBookID),"^",19) s myIPBookDate=$p(^DHCDocIPBK(myIPBookID),"^",4)   //住院证号
	i myIPBookDate="" s myIPBookDate=+$h
	s myBookDate=$p(^DHCDocIPApp(IPAppID),"^",4)     //登记日期
	if myBookDate'="" s myBookDate=$ZD(myBookDate,3)
	s myPatName=$p(^PAPER(myPatientID,"ALL"),"^",1)	   //病人姓名
	s PatNameFlag=1
	//s myPatAge=$p(^PAPER(myPatientID,"ALL"),"^",)
	s myPatSexDr=$p(^PAPER(myPatientID,"ALL"),"^",7)
	s myPatSex=$p(^CT("SEX",myPatSexDr),"^",2)
	s PatTypeDr=$p($g(^PAPER(myPatientID,"PER",1)),"^",10)
	s PatType=""
	if PatTypeDr'="" s PatType=$p(^CT("SS",PatTypeDr),"^",2)  //病人类型
	s myAppLocDr=$p(^DHCDocIPApp(IPAppID),"^",8)
	s myAppLocDesc=$p($g(^CTLOC(myAppLocDr)),"^",2)          //预约科室
	s myAppLoc=$p(myAppLocDesc,"-",2)
	s myAppDate=$p(^DHCDocIPApp(IPAppID),"^",11)       //预约住院日期
	if myAppDate'="" s myAppDate=$ZD(myAppDate,3)
	s BedNoDr=$p(^DHCDocIPApp(IPAppID),"^",9)
	if BedNoDr'="" s BedNo=$p(^PAWARD(+BedNoDr,"BED",$p(BedNoDr,"||",2)),"^",1)          //床号
	s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)       //预约状态
	if IPStatus="C" {
		s IPStatus="取消"
		s CancleId=$p(^DHCDocIPApp(IPAppID),"^",13)
		s Cancle=$p(^DHCDocIPCR(CancleId),"^",2)
		s IPStatus=IPStatus_"("_Cancle_")"
	}
	
	/// 预约状态转为汉字
	if IPStatus="B" {
		s IPStatus="预约"
	}
	if IPStatus="Al" {
		s IPStatus="分配"
	}
	if IPStatus="Ar" {
		s IPStatus="入院"
	}
	if IPStatus="H" {
		s IPStatus="挂起"
	}
	///
	
	s PaadmID=$p(^DHCDocIPApp(IPAppID),"^",3)  
	s IPDate=""
	if PaadmID'="" d
	.s IPDate=$p(^PAADM(PaadmID),"^",6)  //入院日期
	.s IPDate=$ZD(IPDate,3)
	
	s PatAddressDr=$o(^PAPER(myPatientID,"PER","ADD",0))
	s PatAddress=$g(^PAPER(myPatientID,"PER","ADD",PatAddressDr))  //住址
	
	s PatMobPhone=$p(^PAPER(myPatientID,"PER",4),"^",21)
	s TelH=$p(^PAPER(myPatientID,"PER",1),"^",11)
	
	s AccompanySexId=$p(^DHCDocIPApp(IPAppID),"^",27)
	s AccompanySex=""
	if AccompanySexId'="" s AccompanySex=$p(^CT("SEX",AccompanySexId),"^",2)*/
	set Data=$lb(count,IPAppID,myPAPMINO,myIPBookNo,myBookDate,myPatName,myPatSex,PatType,myAppLocDesc,myAppDate,BedNo,IPStatus,IPDate,myAppLocDr,BedNoDr,PatAddress,PatMobPhone,TelH,PatNameFlag,AccompanySex,myMedicalNo,myPatAge,myInfoEnterUser,myBedDistributeUser,myInfoCancelUser,appDoc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	s count=count+1  //序号
	q
}

ClassMethod GetIPAppPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPAppPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIPAppPatientListBroker(IPBookNo As %String, PAPMINO As %String, PatName As %String, BookStartDate As %Date, BookEndDate As %Date, AppDate As %Date, AppWard As %String, AppLoc As %String, AppDoc As %String, IfAllocate As %String, SortMethod As %String = "", DateCondition As %String = "", AccompanySex As %String = "", PageFlag As %String = "") As %String
{
	s value=""
	s Status=0
	Set rs=##Class(%ResultSet).%New("web.DHCDocIPAppointment:GetIPAppPatientList")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(IPBookNo, PAPMINO, PatName, BookStartDate, BookEndDate, AppDate, AppWard, AppLoc, AppDoc, IfAllocate, SortMethod, DateCondition, AccompanySex,PageFlag)
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		While rs.Next() {
			s rowvalue=""
			For col = 1:1:columns {
				;Write rset.GetColumnName(col),":"
				if col=1 set rowvalue=rs.GetData(col)
				e  s rowvalue=rowvalue_"^"_rs.GetData(col)
			}
			if value="" s value=rowvalue
			else  s value=value_"!"_rowvalue
	 	}
		
	}
	q value
}

/// Creator：     zhufei
/// CreatDate：   2010-07-01
/// Description:  查询科室/病区
/// Input：       Type(类型:E-执行科室,W-病区),LocID(关联科室:科室找病区或病区找科室)   LocConfig 为科室配置页面显示传入参数
/// d ##Class(%ResultSet).RunQuery("NK.DHCAppointmentSearch","QryCTLoc","","E","")
Query QryCTLoc(argDesc As %String, argType As %String, argLocID As %String, Hos As %String = "", LocConfig As %String = "") As %Query(ROWSPEC = "CTLocID:%String,CTLocCode:%String,CTLocDesc:%String")
{
}

ClassMethod QryCTLocExecute(ByRef qHandle As %Binary, argDesc As %String, argType As %String, argLocID As %String, Hos As %String = "", LocConfig As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	//add by zf 20110808 增加医院判断
	Set tmp=argLocID
	Set argLocID=$p(tmp,"-",1)
	Set argHospID=$p(tmp,"-",2)
	
	Set:argDesc'="" argDesc=$$ALPHAUP^SSUTIL4(argDesc)
	//^CTLOC({CTLOC_RowID})
	//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub})
	Set CTLocID=0
	For {
		Set CTLocID=$o(^CTLOC(CTLocID))
		Quit:CTLocID=""
		Set tmp=$g(^CTLOC(CTLocID))
		Set CTLocCode=$p(tmp,"^",1)
		Set CTLocDesc=$p(tmp,"^",2)
		Set CTLocType=$p(tmp,"^",13) //Type E-科室，W-病区，D-药房，O-办公室，OP-CT室等
		Continue:(CTLocDesc["停用")
		Continue:(argType'="")&&(CTLocType'=argType)
		Continue:(argLocID'="")&&'$d(^CTLOC(+argLocID,"LINK",0,"Loc",CTLocID))
		Set tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
		Continue:(argDesc'="")&&(tmpLocDesc'[argDesc) //检查运算符右边的串是否包含了左边的串
		//add by zf 20110808 增加医院判断
		Set HospID=$p(tmp,"^",22)
		Continue:(argHospID'="")&&(HospID'=argHospID)
		Continue:(Hos'="")&&(HospID'=Hos)
		//add by mxp 2013-02-21 判断该科室是否为指定的访问类型
		Continue:(argType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","I",CTLocID)))
		///科室配置页面添加代码
		s Config=0
		if LocConfig="1" {
			s ConfigStr="^"_$g(^DHCDocConfig("IPAppLoc"))_"^"
			if (ConfigStr'[("^"_CTLocID_"^")) s Config=1
		}
		Continue:(Config=1)
		///end
		s CTLocDesc1=$p(CTLocDesc,"-",1)
		s CTLocDesc2=$p(CTLocDesc,"-",2)
		s CTLocDesc=CTLocDesc1  ;CTLocDesc2_"-"_
		Set Data=$lb(CTLocID,CTLocCode,CTLocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	//********************************************************
	
	Quit $$$OK
}

ClassMethod QryCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCTLocExecute ]
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

/// Creator:倪康
/// CreatTime：2013-11-14
/// Function:用M程序编写医护人员表(CT_CareProv)的Query查询程序.
/// InPut:医护人员表可根据科室(CT_Loc)代码查询.
/// OutPut:输出有数据字段的所有值,关联字段输出描述.
/// d ##class(%ResultSet).RunQuery("web.DHCDocIPAppointment","FindCTCareProvByLoc",^TMP("FindCTCareProvByLoc"))
Query FindCTCareProvByLoc(CTLoc As %String) As %Query(ROWSPEC = "CTPCPRowId,CTPCPCode,CTPCPDesc")
{
}

ClassMethod FindCTCareProvByLocExecute(ByRef qHandle As %Binary, CTLoc As %String) As %Status
{
	
 	s ^TMP("FindCTCareProvByLoc")=CTLoc
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i CTLoc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s CTLOCRowID=CTLoc
    
    //*****************
    s ResRowId=""
    f  s ResRowId=$o(^RB("RES",0,"CTLOC",CTLOCRowID,ResRowId)) q:(ResRowId="")  d
	.s DocId=$p($G(^RB("RES",ResRowId)),"^",2)
	.q:DocId=""
	.s CTCareDr=$p(^RB("RES",ResRowId),"^",2)
	.s CTPCPRowId=CTCareDr
	.i CTCareDr'="" d
	..s CTPCPCode=$p(^CTPCP(CTCareDr,1),"^",1)
    ..s CTPCPDesc=$p(^CTPCP(CTCareDr,1),"^",2)
    .e  d
    ..s CTPCPCode=""
    ..s CTPCPDesc=""
    .d OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CTPCPRowId,CTPCPCode,CTPCPDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCTCareProvByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTCareProvByLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCTCareProvByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTCareProvByLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CreatDate：  2014-03-27
/// Description：专业
/// Input：      LocID
/// Return：     
/// Debug:
ClassMethod GetLocMedUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocMedUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocIPAppointment","GetLocMedUnit","437")
ClassMethod GetLocMedUnitExecute(ByRef qHandle As %Binary, CTLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1   
 	;s ^TMP("GetLocMedUnit")=CTLocID
 	s CurrentDate=+$h
	if CTLocID'="" d
	.q:($d(^CTLOC(CTLocID))=0)      
	.s CTChildsub=0                                                    
	.s TCTCode=$p(^CTLOC(CTLocID),"^",1)                                    
	.f  s CTChildsub=$o(^CTLOC(CTLocID,"MU",CTChildsub))  q:CTChildsub=""  d
	..s MURowid=CTLocID_"||"_CTChildsub
	..s CTMUCode=$p(^CTLOC(CTLocID,"MU",CTChildsub),"^",1)
	..s CTMUDesc=$p(^CTLOC(CTLocID,"MU",CTChildsub),"^",2) 
	..s TActiveFlag=$p(^CTLOC(CTLocID,"MU",CTChildsub),"^",3)
	..q:TActiveFlag'="Y"
	..s DateFrom=$p(^CTLOC(CTLocID,"MU",CTChildsub),"^",4)
	..q:((DateFrom'="")&&(CurrentDate<DateFrom)) 
	..s DateTo=$p(^CTLOC(CTLocID,"MU",CTChildsub),"^",5)
	..q:((DateTo'="")&&(CurrentDate>DateTo))
	..d BuildCont1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCont1      
	set Data=$lb(CTMUCode,CTMUDesc,MURowid)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetLocMedUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocMedUnitExecute ]
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

Query GetLocMedUnit(CTLocID As %String) As %Query(ROWSPEC = "TCTMUCode:%String,TCTMUDesc:%String,TMURowid:%String")
{
}

/// CreatDate：  2014-03-27
/// Description：获取空床列表
/// Input：      IPAppID:预约住院ID
/// Return：     
/// Debug:
ClassMethod GetEmptyBedList(IPAppID As %String, BedNoDr As %String, ConDate As %String, WardId As %String) As %String
{
	q:IPAppID="" ""
	s ^TMP("GetEmptyBedList")=IPAppID_","_BedNoDr_","_ConDate_","_WardId
	
	s WardDr=$p($g(^DHCDocIPApp(IPAppID)),"^",21)
	if WardDr="" {
		s LocID=$p($g(^DHCDocIPApp(IPAppID)),"^",8)
		s WardDr=$o(^CTLOC(LocID,"LINK",0,"Loc",""))
	}
	s WardID=##class(web.PACWard).GetWardFromLoc(WardDr)
	
	s CurrentDate=$ZD(+$h,3)
	
	s LocID=$p($g(^DHCDocIPApp(IPAppID)),"^",8)
	s value=""
	s Status=0
	if WardId'="" s WardDr=WardId
	Set rs=##Class(%ResultSet).%New("Nur.DHCBedManager:Findbed")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute("","","true","", WardDr, "","true","", CurrentDate, ConDate,BedNoDr)
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		While rs.Next() {
			s rowvalue=""
			For col = 1:1:columns {
				;Write rset.GetColumnName(col),":"
				if col=1 set rowvalue=rs.GetData(col)
				e  s rowvalue=rowvalue_"^"_rs.GetData(col)
			}
			if value="" s value=rowvalue
			else  s value=value_"!"_rowvalue
	 	}
		
	}
	q value
}

/// CreatDate：  2014-03-27
/// Description：通过住院就诊ID获取预约床位
/// Input：      AdmID:PA_Adm ID
/// Return：     
/// Debug:
/// ##class(web.DHCDocIPAppointment).GetBedIDByAdm(PaadmID)
ClassMethod GetBedIDByAdm(PaadmID As %String) As %String
{
	q:PaadmID="" ""
	s Transbed=##class(web.DHCADMQTREC).GetAdmTransBed(PaadmID)
	q:Transbed=1 ""
	s IPBookID=$o(^DHCDocIPBK(0,"EpisodeIDTo",PaadmID,""))
	q:IPBookID="" ""
	s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",IPBookID,0))
	s BedID=""
	if IPAppID'="" s BedID=$p(^DHCDocIPApp(IPAppID),"^",9)
	b ;12
	q BedID
}

ClassMethod GetBedCodeByAdm(PaadmId As %String) As %String
{
	q:PaadmId="" ""
	s BedId=..GetBedIDByAdm(PaadmId)
	s BedCode=""
	if BedId'="" s BedCode=$p(^PAWARD(+BedId,"BED",$p(BedId,"||",2)),"^",1)
	q BedCode
}

/// CreatDate：  2014-03-27
/// Description：病人入院后修改预约住院表中入院就诊id和预约状态
/// Input：      BookID:DHCDocIPBooking表ID
/// 				 PaadmID:PA_Adm ID
/// Return：     
/// Debug:
ClassMethod UpdateIPAppointmentInfo(BookID As %String, PaadmID As %String) As %String
{
	q:BookID="" "-101"
	q:PaadmID="" "-102"
	
	s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",BookID,0))
	q:IPAppID="" "0"  //"-103"
	
	s CurrentDate=+$h
	s CurrentTime=$p($h,",",2)
	/*
	s $p(^DHCDocIPApp(IPAppID),"^",3)=PaadmID
	s $p(^DHCDocIPApp(IPAppID),"^",10)="Ar"
	s $p(^DHCDocIPApp(IPAppID),"^",18)=+CurrentDate
	s $p(^DHCDocIPApp(IPAppID),"^",19)=$p(CurrentDate,",",2)
	*/
	s IPStatus="Ar"
	&SQL(Update DHCDocIPAppointment
		set IPStatus=:IPStatus,
		EpisodeIDTo=:PaadmID,
		LastUpdateDate=:CurrentDate,
		LastUpdateTime=:CurrentTime
		where RowID=:IPAppID
		)
	q SQLCODE
}

/// 预约管理中，获取病人详细信息
/// w ##class(web.DHCDocIPAppointment).GetPatientInfoByIPAppID("20")
ClassMethod GetPatientInfoByIPAppID(IPAppID As %String) As %String
{
	q:IPAppID=""
	;s MedicalNo=""
	;s myPatientID=""
	s myPatientID=$p(^DHCDocIPApp(IPAppID),"^",2)  
	;b ;
	q:myPatientID=""
	s myPatName=$p(^PAPER(myPatientID,"ALL"),"^",1)
	S MedicalNo=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(myPatientID,"",$g(%session.Data("LOGON.HOSPID")))
	s myIPBookID=$p(^DHCDocIPApp(IPAppID),"^",1)  
	s myIPBookNo=""
	if myIPBookID'="" s myIPBookNo=$p(^DHCDocIPBK(myIPBookID),"^",20)
	s myPAPMINO=$p(^PAPER(myPatientID,"PAT",1),"^",2)  //登记号
	s myPatSexDr=$p(^PAPER(myPatientID,"ALL"),"^",7)
	s myPatSex=$p(^CT("SEX",myPatSexDr),"^",2)
	s myPatDob=$p(^PAPER(myPatientID,"ALL"),"^",6)
	s myPatAge=..getpatage(myPatDob,"")
	s PatAge=$p(myPatAge,"^",1)
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(myPatientID)
	s PatTypeDr=$p($g(^PAPER(myPatientID,"PER",1)),"^",10)
	s PatType=""
	if PatTypeDr'="" s PatType=$p(^CT("SS",PatTypeDr),"^",2)  //病人类型
	s myAppLocDr=$p(^DHCDocIPApp(IPAppID),"^",8)
	s myAppLocDesc=$p($g(^CTLOC(myAppLocDr)),"^",2)          //预约科室
	s myAppLoc=$p(myAppLocDesc,"-",2)
	//病区
	s myAppWardDr=$p(^DHCDocIPApp(IPAppID),"^",21)
	s myAppWard=""
	if +myAppWardDr'=0 {
		s myAppWardID=$o(^PAWARD(0,"WARD_LocationDR",myAppWardDr,""))
		s myAppWardDesc=$p($g(^PAWARD(myAppWardID)),"^",2)
		s myAppWard=$p(myAppWardDesc,"-",2)
	}
	s myBookDate=$p(^DHCDocIPApp(IPAppID),"^",4)     //登记日期
	if myBookDate'="" s myBookDate=$ZD(myBookDate,3)
	s myAppDate=$p(^DHCDocIPApp(IPAppID),"^",11)       //预约住院日期
	if myAppDate'="" s myAppDate=$ZD(myAppDate,3)
	//入院日期
	s myPaadmID=$p(^DHCDocIPApp(IPAppID),"^",3)
	s myArriveDate=""
	if myPaadmID'="" {
		s myArriveDate=$p($g(^PAADM(myPaadmID)),"^",6)
	}
	if myArriveDate'="" s myArriveDate=$ZD(myArriveDate,3)
	s BedNoDr=$p(^DHCDocIPApp(IPAppID),"^",9)
	s BedNo=""
	if BedNoDr'="" s BedNo=$p(^PAWARD(+BedNoDr,"BED",$p(BedNoDr,"||",2)),"^",1)          //床号
	s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)       //预约状态
	if IPStatus="B" {
		s IPStatus="预约"
	}
	if IPStatus="Al" {
		s IPStatus="分配"
	}
	if IPStatus="C" {
		s IPStatus="取消"
	}
	if IPStatus="Ar" {
		s IPStatus="入院"}
	if IPStatus="H" {
		s IPStatus="挂起"}
	s PatAddressDr=$o(^PAPER(myPatientID,"PER","ADD",0))
	s PatAddress=$g(^PAPER(myPatientID,"PER","ADD",PatAddressDr))  //住址
	
	s PatMobPhone=$p(^PAPER(myPatientID,"PER",4),"^",21)
	s TelH=$p(^PAPER(myPatientID,"PER",1),"^",11)
	
	s AllocateDate=$p(^DHCDocIPApp(IPAppID),"^",11)
	if AllocateDate'="" s AllocateDate=$ZD(AllocateDate,3)
	
	s AccompanySexId=$p(^DHCDocIPApp(IPAppID),"^",27)
	s AccompanySex=""
	if AccompanySexId'="" s AccompanySex=$p(^CT("SEX",AccompanySexId),"^",2)
		
	s myBedDistributeUserID=$p(^DHCDocIPApp(IPAppID),"^",29) //床位分配人
	s myBedDistributeUser=""
	i myBedDistributeUserID'="" s myBedDistributeUser=$p(^SSU("SSUSR",myBedDistributeUserID),"^",2)	
	s myInfoCancelUserID=$p(^DHCDocIPApp(IPAppID),"^",30) //预约信息作废人
	s myInfoCancelUser=""
	i myInfoCancelUserID'="" s myInfoCancelUser=$p(^SSU("SSUSR",myInfoCancelUserID),"^",2)
	s myInfoEnterUserID=$p(^DHCDocIPApp(IPAppID),"^",6) //预约信息录入人
	s myInfoEnterUser=""
	i myInfoEnterUserID'="" s myInfoEnterUser=$p(^SSU("SSUSR",myInfoEnterUserID),"^",2)
	s ret=MedicalNo_"^"_myPatName_"^"_myIPBookNo_"^"_myPAPMINO_"^"_myPatSex_"^"_PatType_"^"_myAppLoc_"^"_myAppWard
	s ret=ret_"^"_myBookDate_"^"_myAppDate_"^"_myArriveDate_"^"_BedNo_"^"_IPStatus_"^"_""_"^"_PatAddress_"^"_PatMobPhone_"^"_TelH_"^"_AllocateDate_"^"_AccompanySex_"^"_PatAge
	s ret=ret_"^"_myInfoEnterUser_"^"_myBedDistributeUser_"^"_myInfoCancelUser
	q ret
}

Query FindCancleReason(CodeStr As %String, DescStr As %String, HospID) As %Query(ROWSPEC = "RowId,Code,Desc")
{
}

ClassMethod FindCancleReasonExecute(ByRef qHandle As %Binary, CodeStr As %String, DescStr As %String, HospID) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s RowId=0 f  s RowId=$o(^DHCDocIPCR(RowId))  q:RowId=""  d  
	.s curHospID=$p(^DHCDocIPCR(RowId),"^",4)
	.q:HospID'=curHospID
 	.s Code=$p(^DHCDocIPCR(RowId),"^",1)
 	.s Desc=$p(^DHCDocIPCR(RowId),"^",2)
 	.s IsActive=$p(^DHCDocIPCR(RowId),"^",3)
 	.q:IsActive'="Y"
 	.q:((CodeStr'="")&&(CodeStr'=Code))
 	.q:((DescStr'="")&&(DescStr'=Desc))
 	.d OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RowId,Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCancleReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCancleReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCancleReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCancleReasonExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCancleReasonBroker(CodeStr As %String, DescStr As %String, HospID) As %String
{
	s value=""
	s Status=0
	Set rs=##Class(%ResultSet).%New("web.DHCDocIPAppointment:FindCancleReason")
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(CodeStr, DescStr,HospID)
		Set columns = rs.GetColumnCount()
		If 'Status Quit
		While rs.Next() {
			s rowvalue=""
			For col = 1:1:columns {
				;Write rset.GetColumnName(col),":"
				if col=1 set rowvalue=rs.GetData(col)
				e  s rowvalue=rowvalue_"^"_rs.GetData(col)
			}
			if value="" s value=rowvalue
			else  s value=value_"!"_rowvalue
	 	}
		
	}
	q value
}

/// ##class(web.DHCDocIPAppointment).AddCancleReason("Overdue","过期作废","Y")
ClassMethod AddCancleReason(Code As %String, Desc As %String, IsActive As %String = "N", HospID) As %String
{
	q:(Desc="") ""
	s flag=0
	s rowID=0 
	f  s rowID=$o(^DHCDocIPCR(rowID)) q:(rowID=""||flag=1)  d
	.i $p(^DHCDocIPCR(rowID),"^")=Code &&($p(^DHCDocIPCR(rowID),"^",3)="Y")&&($p(^DHCDocIPCR(rowID),"^",4)=HospID) s flag=1

	//此行代码用于保证不同院区新增代码时不会重复。如果已经存在code 但是状态是N，允许插入。 许兴，2022-12-28,需求号：3132411
	if ($o(^DHCDocIPCRi(0,"CancleReasonCode",Code,"IsActive",IsActive,""))'="") s flag=1

	q:flag=1 "-1^代码重复"	 
	&SQL(Insert into DHCDocIPCancleReason 
		(CancleReason_Code,CancleReason_Desc,IsActive,Hosp_Dr) 
		values 
		(:Code,:Desc,:IsActive,:HospID)
		)
	s Rowid=^DHCDocIPCR(0)
	q SQLCODE_"^"_Rowid
}

ClassMethod DeleteCancleReason(RowId As %String) As %String
{
	q:RowId="" ""
	&SQL(update DHCDocIPCancleReason set IsActive="N" where RowID=:RowId)
	q SQLCODE
}

/// w ##class(web.DHCDocIPAppointment).UpdateCancleReason("77","XXCX","出但是")
ClassMethod UpdateCancleReason(RowId As %String, Code As %String, Desc As %String) As %String
{
	q:RowId="" ""
	q:((Code="")||(Desc="")) ""

	s flag=0
	s selctId=$O(^DHCDocIPCRi(0,"CancleReasonCode",Code,"")) 
	//selectid为空：code不存在；不为空&&等于RowId，为当前选中行；不为空&&不等于RowId，code已存在，不允许修改。
	s:((selctId'="")&&(selctId'=RowId)) flag=1
	q:flag=1 "代码重复!"	

	&SQL(update DHCDocIPCancleReason
		set CancleReason_Code=:Code,
		CancleReason_Desc=:Desc
		where ROWID=:RowId	
	)		
	q SQLCODE
}

/// 取消作废
ClassMethod ReCancleIPAppointment(IPAppIDArr As %String) As %String
{
	q:IPAppIDArr="" ""
	
	s Count=$l(IPAppIDArr,"^")
	s ret=0
	f i=1:1:Count {
		s IPAppID=$p(IPAppIDArr,"^",i)
		s IPAppStatus=$p($g(^DHCDocIPApp(IPAppID)),"^",10)
		q:(IPAppStatus'="C") //"-200"  //不是作废状态
		
		s CurrentDate=+$h
		s CurrentTime=$p($h,",",2)
		s IPStatus="B"
		&SQL(Update DHCDocIPAppointment
			set IPStatus=:IPStatus,
			BedNODr=null,
			AllocateDate=null,
			AllocateTime=null,
			CancleReasonDr=null,
			CancleDate=null,
			CancleTime=null,
			LastUpdateDate=:CurrentDate,
			LastUpdateTime=:CurrentTime
			where RowID=:IPAppID
		)
		s ret=ret+SQLCODE
	}
	q ret
}

Query GetPatType(DescStr As %String) As %Query(ROWSPEC = "RowId,Desc")
{
}

ClassMethod GetPatTypeExecute(ByRef qHandle As %Binary, DescStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s REARowid="0"
	f  s REARowid=$o(^PAC("ADMREA",REARowid))  q:REARowid=""  d
	.s READesc=$P(^PAC("ADMREA",REARowid),"^",2)
 	.d OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(REARowid,READesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetBookPatientList(PatientName As %String, CTWardId As %String, CTLocId As %String, CTDocId As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "RowID:%String,patientId:%String,PatName:%String,PatId:%String,IPBookNo:%String,Ward:%String,Loc:%String,Doc:%String")
{
}

ClassMethod GetBookPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBookPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBookPatientListExecute(ByRef qHandle As %Binary, PatientName As %String, CTWardId As %String, CTLocId As %String, CTDocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMP("GetBookPatientList")=PatientName_","_CTWardId_","_CTLocId_","_CTDocId
	s State=8  //预约
	;s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"  //同仁需求 要求所有住院证都要到床管中心处理
	if CTWardId'="" s CTWardId=$o(^PAWARD(0,"WARD_LocationDR",CTWardId,""))
	set RowID="" f  set RowID= $o(^DHCDocIPBK(RowID)) q:RowID=""  d
	.;Quit:$$checkLogonLoc(RowID)=0
	.set strData = $g(^DHCDocIPBK(RowID))
	.;if (DocCreateBookId'="") set UsserId=$p(^DHCDocIPBK(RowID),"^",6) q:UsserId'=DocCreateBookId
	.;q:($p(strData,"^",8)'=State)&(State'="") //状态校验
	.s IPAppID=$o(^DHCDocIPApp(0,"IPBookingID",RowID,""))
	.if IPAppID'="" s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
	.q:(IPAppID'="")   //((IPAppID'="")&&(IPStatus'="B"))
	.s patientId=$p(strData,"^",1)
	.q:patientId=""
	.s PatName=$p(^PAPER(patientId,"ALL"),"^",1)	   //病人姓名
	.q:((PatientName'="")&&(PatName'[PatientName))
	.s PatId=$p(^PAPER(patientId,"ALL"),"^",9)         //身份证号
	.s IPBookNo=$p(^DHCDocIPBK(RowID),"^",20)          //住院证号
	.s LocId=$p($g(^DHCDocIPBK(RowID)),"^",13)         //预约科室
	.;q:(ConfigStr[("^"_$p(strData,"^",13)_"^"))   //同仁需求 要求所有住院证都要到床管中心处理
	.q:((CTLocId'="")&&(LocId'=CTLocId))
	.s LocDesc=""
	.if LocId'="" s LocDesc=$p($g(^CTLOC(LocId)),"^",2)
	.if LocDesc'="" s Loc=$p(LocDesc,"-",2)
	.s WardId=$p($g(^DHCDocIPBK(RowID)),"^",11)        //预约病区
	.q:((CTWardId'="")&&(WardId'=CTWardId))
	.s Ward=""
	.if WardId'="" s Ward=$p($g(^PAWARD(WardId)),"^",2)
	.s SSUser=$p($g(^DHCDocIPBK(RowID)),"^",7)         //预约医生
	.s DocId=""
	.i SSUser'="" d
	..s DocId=$p($g(^SSU("SSUSR",SSUser)),"^",14)
	.q:((CTDocId'="")&&($g(DocId)'=CTDocId))
	.s Doc=""
	.if DocId'="" s Doc=$p($g(^CTPCP(DocId,1)),"^",2)
	.set ^CacheTemp(repid, ind) = $lb(RowID,patientId,PatName,PatId,IPBookNo,Ward,Loc,Doc)
	.set ind = ind + 1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetBookPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBookPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetAcuityList() As %Query(ROWSPEC = "RowId,Desc")
{
}

ClassMethod GetAcuityListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Rowid="0"
 	s CurrentDate=+$h
	f  s Rowid=$o(^CT("ACU",Rowid))  q:Rowid=""  d
	.s DateFrom=$P(^CT("ACU",Rowid),"^",8)
	.q:((DateFrom'="")&&(CurrentDate<DateFrom))
	.s DateTo=$P(^CT("ACU",Rowid),"^",9)
	.q:((DateTo'="")&&(CurrentDate>DateTo))
	.s Desc=$P(^CT("ACU",Rowid),"^",2)
 	.d OutputRow4
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(Rowid,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAcuityListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAcuityListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCDocIPAppointment","GetSortMethodList")
Query GetSortMethodList() As %Query(ROWSPEC = "RowId,Desc")
{
}

ClassMethod GetSortMethodListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Rowid="0"
 	s CurrentDate=+$h
 	s ^TMP("GetSortMethodList",1)=1_"&"_"登记时间"
 	s ^TMP("GetSortMethodList",2)=2_"&"_"开证时间"
	f  s Rowid=$o(^CT("ACU",Rowid))  q:Rowid=""  d
	.s DateFrom=$P(^CT("ACU",Rowid),"^",8)  //就诊级别表CT_Acuity
	.q:((DateFrom'="")&&(CurrentDate<DateFrom))
	.s DateTo=$P(^CT("ACU",Rowid),"^",9)
	.q:((DateTo'="")&&(CurrentDate>DateTo))
	.s Desc=$P(^CT("ACU",Rowid),"^",2)_"优先"
 	.s ^TMP("GetSortMethodList",2+Rowid)="3"_"^"_Rowid_"&"_Desc
 	
 	s RowId="" f  s RowId=$o(^TMP("GetSortMethodList",RowId))  q:RowId=""  d
 	.s Rowid=$p(^TMP("GetSortMethodList",RowId),"&",1)
 	.s Desc=$p(^TMP("GetSortMethodList",RowId),"&",2)
 	.d OutputRow5
 	k ^TMP("GetSortMethodList")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(Rowid,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSortMethodListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSortMethodListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetSortMethodListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSortMethodListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetAllocatePatList(WardId As %String, LocId As %String) As %Query(ROWSPEC = "count:%String,IPAppID:%String,myPAPMINO:%String,myIPBookNo:%String,myBookDate:%String,myPatName:%String,myPatSex:%String,PatType:%String,myAppLoc:%String,myAppDate:%String,BedNo:%String,IPStatus:%String,IPDate:%String,myAppLocDr:%String,BedNoDr:%String,DiagnosDesc:%String")
{
}

ClassMethod GetAllocatePatListExecute(ByRef qHandle As %Binary, WardId As %String, LocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s ^TMP("GetAllocatePatList")=
 	i ((WardId="")&&(LocId="")) Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i WardId="" {
	 	s LinkWardId=0
		f  s LinkWardId=$o(^CTLOC(LocId,"LINK",LinkWardId))	 q:LinkWardId=""  d
		.s LinkLocId=^CTLOC(LocId,"LINK",LinkWardId)
		.s PACWardId=$o(^PAWARD(0,"WARD_LocationDR",LinkLocId,0))
		.if WardId="" s WardId=PACWardId
		.else  s WardId=WardId_"^"_PACWardId
	}
	s WardId="^"_WardId_"^"
	s count=1
	b ;0001
	s IPAppID=""
	f  s IPAppID=$o(^DHCDocIPApp(0,"IPStatus","Al",IPAppID))  q:IPAppID=""  d
	.s BedNoDr=$p(^DHCDocIPApp(IPAppID),"^",9)
	.s AppWardId=$p(BedNoDr,"||",1)
	.;s AppWardToLocId=$p(^PAWARD(AppWardId),"^",5)
	.q:(WardId'[("^"_AppWardId_"^"))
 	.d OutputRow6
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	s myPatientID=$p(^DHCDocIPApp(IPAppID),"^",2)  
	s myPAPMINO=$p(^PAPER(myPatientID,"PAT",1),"^",2)  //登记号
 	s myIPBookID=$p(^DHCDocIPApp(IPAppID),"^",1)  
	s myIPBookNo="",myIPBookDate=""
	if myIPBookID'="" s myIPBookNo=$p(^DHCDocIPBK(myIPBookID),"^",20) s myIPBookDate=$p(^DHCDocIPBK(myIPBookID),"^",4)   //住院证号
	i myIPBookDate="" s myIPBookDate=+$h
	s myBookDate=$p(^DHCDocIPApp(IPAppID),"^",4)     //登记日期
	if myBookDate'="" s myBookDate=$ZD(myBookDate,3)
	s myPatName=$p(^PAPER(myPatientID,"ALL"),"^",1)	   //病人姓名
	s myPatSexDr=$p(^PAPER(myPatientID,"ALL"),"^",7)
	s myPatSex=$p(^CT("SEX",myPatSexDr),"^",2)
	s PatTypeDr=$p($g(^PAPER(myPatientID,"PER",1)),"^",10)
	s PatType=""
	if PatTypeDr'="" s PatType=$p(^CT("SS",PatTypeDr),"^",2)  //病人类型
	s myAppLocDr=$p(^DHCDocIPApp(IPAppID),"^",8)
	s myAppLocDesc=$p($g(^CTLOC(myAppLocDr)),"^",2)          //预约科室
	s myAppLoc=$p(myAppLocDesc,"-",2)
	s myAppDate=$p(^DHCDocIPApp(IPAppID),"^",11)       //预约住院日期
	if myAppDate'="" s myAppDate=$ZD(myAppDate,3)
	s BedNoDr=$p(^DHCDocIPApp(IPAppID),"^",9)
	if BedNoDr'="" s BedNo=$p(^PAWARD(+BedNoDr,"BED",$p(BedNoDr,"||",2)),"^",1)          //床号
	s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)       //预约状态
	if IPStatus="C" {
		s CancleId=$p(^DHCDocIPApp(IPAppID),"^",13)
		s Cancle=$p(^DHCDocIPCR(CancleId),"^",2)
		s IPStatus=IPStatus_"("_Cancle_")"
	}
	s PaadmID=$p(^DHCDocIPApp(IPAppID),"^",3)  
	s IPDate=""
	if PaadmID'="" d
	.s IPDate=$p(^PAADM(PaadmID),"^",6)  //入院日期
	.s IPDate=$ZD(IPDate,3)
	s DiagnosDesc=""
	if (myIPBookID'="") {
		s PaadmId=$p(^DHCDocIPBK(myIPBookID),"^",2)
		if PaadmId'="" {
			s MRAdmId=$p($g(^PAADM(PaadmId)),"^",61)
			s DiagnosDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmId,",")
		}
	}
	
	set Data=$lb(count,IPAppID,myPAPMINO,myIPBookNo,myBookDate,myPatName,myPatSex,PatType,myAppLoc,myAppDate,BedNo,IPStatus,IPDate,myAppLocDr,BedNoDr,DiagnosDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	s count=count+1  //序号
	q
}

ClassMethod GetAllocatePatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllocatePatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAllocatePatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllocatePatListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ChangePatAppInfo(IPAppIDArr As %String, LocId As %String, WardId As %String, DocId As %String) As %String
{
	q:IPAppIDArr="" ""
	;s ^TMP("ChangePatAppInfo")=IPAppIDArr_","_LocId_","_WardId_","_DocId
	s Count=$l(IPAppIDArr,"^")
	
	f i=1:1:Count  {
		s IPAppID=$p(IPAppIDArr,"^",i)
		s SSUser=""
		if DocId'="" s SSUser=$o(^SSU("SSUSR",0,"CTPCP",DocId,""))
		s ConfigStr="^"_^DHCDocConfig("IPAppLoc")_"^"
		i (ConfigStr[("^"_LocId_"^"))&&(LocId'="") s errmsg="该科室不能预约!" q
		if LocId'="" s $p(^DHCDocIPApp(IPAppID),"^",8)=LocId
		if WardId'="" s $p(^DHCDocIPApp(IPAppID),"^",21)=WardId
		if SSUser'="" s $p(^DHCDocIPApp(IPAppID),"^",7)=SSUser
		s IPBookingDr=$p(^DHCDocIPApp(IPAppID),"^",1)
		
		s BookWardID=""
		if WardId'="" s BookWardID=$o(^PAWARD(0,"WARD_LocationDR",WardId,""))
		if BookWardID'="" s $p(^DHCDocIPBK(IPBookingDr),"^",11)=BookWardID
		if LocId'="" s $p(^DHCDocIPBK(IPBookingDr),"^",13)=LocId
	}
	i $g(errmsg)'="" q errmsg
	q 0
}

ClassMethod GetPatInfoByBedId(BedId As %String) As %String
{
	q:BedId="" ""
	s IPAppID="",PatientId=""
	f  s IPAppID=$o(^DHCDocIPApp(0,"IPStatus","Al",IPAppID))  q:((IPAppID="")||(PatientId'=""))  d
	.s AppBedId=$p($g(^DHCDocIPApp(IPAppID)),"^",9)  //预约床号
	.q:(BedId'=AppBedId)
	.s PatientId=$p($g(^DHCDocIPApp(IPAppID)),"^",2)
	.s BookId=$p($g(^DHCDocIPApp(IPAppID)),"^",1)
	
	q:PatientId="" ""
	
	s PatName=$p(^PAPER(PatientId,"ALL"),"^",1)	   //病人姓名
	s PatSexDr=$p(^PAPER(PatientId,"ALL"),"^",7)
	s PatSex=$p(^CT("SEX",PatSexDr),"^",2)
	s PatDOB=$p(^PAPER(PatientId,"ALL"),"^",6)
	s CurrentDate=+$h
	
	s PatDOBYear=$p($ZD(PatDOB,3),"-",1)
	s CurrentYear=$p($ZD(CurrentDate,3),"-",1)
	s PatAge=CurrentYear-PatDOBYear
	s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientId)
	s PaadmId=$p(^DHCDocIPBK(BookId),"^",2)
	s DiagnosDesc=""
	if PaadmId'="" {
		s MRAdmId=$p($g(^PAADM(PaadmId)),"^",61)
		s DiagnosDesc=##class(web.DHCMRDiagnos).GetMRDiagnosDesc(MRAdmId,",")
	}
	q PatName_"^"_PatSex_"^"_PatAge_"^"_DiagnosDesc
}

/// ////////报表Query//////////////
/// d ##Class(%ResultSet).RunQuery("web.DHCDocIPAppointment","IPAppointDailyReport","2014-06-06")
Query IPAppointDailyReport(InputDate As %String) As %Query(ROWSPEC = "AppLocId:%String,LocDesc:%String,AppCount:%String,ArriveCount:%String,OverCount:%String,LostCount:%String,PreWaitCount:%String")
{
}

ClassMethod IPAppointDailyReportExecute(ByRef qHandle As %Binary, InputDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	k ^TMP("IPAppointDailyReport")
 	///^ 1 收住院证人数  2 收入院人数  3 积压数  4 住院流失数  5 日平均待床数
 	//积压数
 	i InputDate'="" s CurrentDate=$ZDH(InputDate,3)
 	i InputDate="" s CurrentDate=+$H
 	s IPAppID=""
	f  s IPAppID=$o(^DHCDocIPApp(0,"IPStatus","B",IPAppID))  q:IPAppID=""  d
 	.s LocId=$p($g(^DHCDocIPApp(IPAppID)),"^",8)
 	.if LocId'="" d
 	..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 	..if CreateDate<CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 	..else  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 	
 	s IPAppID=""
	f  s IPAppID=$o(^DHCDocIPApp(0,"LastUpdateDate",CurrentDate,IPAppID))  q:IPAppID=""  d
 	.s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
 	.if IPStatus="Al" d
 	..s AllocateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",14)
 	..if AllocateDate=CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=$p(^TMP("IPAppointDailyReport",LocId),"^",2)+1
 	..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 	..
 	..if CreateDate<CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 	..else  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 	..
 	.else  if IPStatus="Ar" d
 	..s AllocateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",14)
 	..if AllocateDate=CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=$p(^TMP("IPAppointDailyReport",LocId),"^",2)+1
 	..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 	..
 	..if CreateDate<CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 	..else  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 	..
 	.else  if IPStatus="C" d
 	..s CancleDate=$p($g(^DHCDocIPApp(IPAppID)),"^",16)
 	..if CancleDate=CurrentDate d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",4)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",4)=$p(^TMP("IPAppointDailyReport",LocId),"^",4)+1
 	..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 	..
 	..if CreateDate<CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 	..else  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 	..
 	.else  if IPStatus="H" d
 	..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 	..
 	..if CreateDate<CurrentDate  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 	..else  d
 	...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 	...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 	..
 	
 	s AppLocId=0
 	f  s AppLocId=$o(^TMP("IPAppointDailyReport",AppLocId))  q:AppLocId=""  d
 	.s LocDesc=$p($g(^CTLOC(AppLocId)),"^",2)          //预约科室
	.s LocDesc=$p(LocDesc,"-",2)
 	.s AppCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",1)
 	.if AppCount="" s AppCount=0
 	.s ArriveCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",2)
 	.if ArriveCount="" s ArriveCount=0
 	.s OverCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",3)
 	.if OverCount="" s OverCount=0
 	.s LostCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",4)
 	.if LostCount="" s LostCount=0
 	.s PreWaitCount=OverCount+AppCount-ArriveCount-LostCount
 	.set Data=$lb(AppLocId,LocDesc,AppCount,ArriveCount,OverCount,LostCount,PreWaitCount)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod IPAppointDailyReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPAppointDailyReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IPAppointDailyReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPAppointDailyReportExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query IPAppointMonthReport(InputDate As %String) As %Query(ROWSPEC = "AppLocId:%String,LocDesc:%String,AveVisitCount:%String,LostCountMonth:%String")
{
}

ClassMethod IPAppointMonthReportExecute(ByRef qHandle As %Binary, InputDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TMP("IPAppointMonthReport")=InputDate
 	if InputDate="" s InputDate=$ZD(+$H,3)
 	s month=$p(InputDate,"-",2)
 	s StartDate=+InputDate_"-"_month_"-1"
 	s month=$p(InputDate,"-",2)+1
 	s EndDate=+InputDate_"-"_month_"-1"
 	k ^TMP("IPAppointMonthReport")
 	
 	s StartDate=$ZDH(StartDate,3)
 	s EndDate=$ZDH(EndDate,3)-1
 	///^ 1 待床病人数  2 流失病人总数
	;w EndDate_"^"_StartDate
 	;b
 	f tempDate=StartDate:1:EndDate {
	 	s IPAppID="" f  s IPAppID=$o(^DHCDocIPApp(0,"LastUpdateDate",tempDate,IPAppID)) q:IPAppID=""  d
	 	.s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
	 	.s CancleFlag=0
	 	.s LocId=$p(^DHCDocIPApp(IPAppID),"^",8)
	 	.if IPStatus="C" s CancleFlag=1
	 	.if $g(^TMP("IPAppointMonthReport",LocId))="" d
	 	..if CancleFlag=1 s $p(^TMP("IPAppointMonthReport",LocId),"^",1)=1
	 	.else  d
	 	..if CancleFlag=1 s $p(^TMP("IPAppointMonthReport",LocId),"^",1)=$p(^TMP("IPAppointMonthReport",LocId),"^",1)+1
	 	;..w $p(^TMP("IPAppointMonthReport",LocId),"^",1)
	 	;..b
		k ^TMP("IPAppointDailyReport")
 	///^ 1 收住院证人数  2 收入院人数  3 积压数  4 住院流失数  5 日平均待床数
 	//积压数
 		s CurrentDate=tempDate
 		s IPAppID=""
		f  s IPAppID=$o(^DHCDocIPApp(0,"IPStatus","B",IPAppID))  q:IPAppID=""  d
 		.s LocId=$p($g(^DHCDocIPApp(IPAppID)),"^",8)
 		.if LocId'="" d
 		..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 		..if CreateDate<CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 		..else  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 		//收入院人数
 		s IPAppID=""
		f  s IPAppID=$o(^DHCDocIPApp(0,"LastUpdateDate",CurrentDate,IPAppID))  q:IPAppID=""  d
 		.s IPStatus=$p(^DHCDocIPApp(IPAppID),"^",10)
 		.s CancleFlag=0
 		.if IPStatus="Al" d
 		..s AllocateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",14)
 		..if AllocateDate=CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=$p(^TMP("IPAppointDailyReport",LocId),"^",2)+1
 		..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 		..
 		..if CreateDate<CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 		..else  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 		..
 		.else  if IPStatus="Ar" d
 		..s AllocateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",14)
 		..if AllocateDate=CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",2)=$p(^TMP("IPAppointDailyReport",LocId),"^",2)+1
 		..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 		..
 		..if CreateDate<CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 		..else  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 		..
 		.else  if IPStatus="C" d
 		..s CancleFlag=1
 		..s CancleDate=$p($g(^DHCDocIPApp(IPAppID)),"^",16)
 		..if CancleDate=CurrentDate d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",4)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",4)=$p(^TMP("IPAppointDailyReport",LocId),"^",4)+1
 		..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 		..
 		..if CreateDate<CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 		..else  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 		..
 		.else  if IPStatus="H" d
 		..s CreateDate=$p($g(^DHCDocIPApp(IPAppID)),"^",4)
 		..
 		..if CreateDate<CurrentDate  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",3)=$p(^TMP("IPAppointDailyReport",LocId),"^",3)+1
 		..else  d
 		...if $g(^TMP("IPAppointDailyReport",LocId))="" s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=1
 		...else  s $p(^TMP("IPAppointDailyReport",LocId),"^",1)=$p(^TMP("IPAppointDailyReport",LocId),"^",1)+1
 		..
 		;.w $p(^TMP("IPAppointDailyReport",LocId),"^",1)
 		;.b
 		
 		s AppLocId=0
 		f  s AppLocId=$o(^TMP("IPAppointDailyReport",AppLocId))  q:AppLocId=""  d
 		.s AppCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",1)
 		.if AppCount="" s AppCount=0
 		.s ArriveCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",2)
 		.if ArriveCount="" s ArriveCount=0
 		.s OverCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",3)
 		.if OverCount="" s OverCount=0
 		.s LostCount=$p(^TMP("IPAppointDailyReport",AppLocId),"^",4)
 		.if LostCount="" s LostCount=0
 		.s PreWaitCount=OverCount+AppCount-ArriveCount-LostCount	
 		.s $p(^TMP("IPAppointMonthReport",AppLocId),"^",2)=""
 		.s $p(^TMP("IPAppointMonthReport",AppLocId),"^",2)=$p(^TMP("IPAppointMonthReport",AppLocId),"^",2)+PreWaitCount
 		;.w $p(^TMP("IPAppointMonthReport",AppLocId),"^",2)
 		;.b
	}
	
	s DayCount=EndDate-StartDate+1
	s AppLocId=0
 	f  s AppLocId=$o(^TMP("IPAppointMonthReport",AppLocId))  q:AppLocId=""  d
 	.s LocDesc=$p($g(^CTLOC(AppLocId)),"^",2)          //预约科室
	.s LocDesc=$p(LocDesc,"-",2)
	.s AveVisitCount=$fn($p(^TMP("IPAppointMonthReport",AppLocId),"^",2)/DayCount,"",4)
	.s LostCountMonth=$p(^TMP("IPAppointMonthReport",AppLocId),"^",1)
	.
	.
 	.set Data=$lb(AppLocId,LocDesc,AveVisitCount,LostCountMonth)
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod IPAppointMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IPAppointMonthReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IPAppointMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IPAppointMonthReportExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getpatage(birthdate, admdate)
{
  s agestr=""
  s admdate=$g(admdate)
  i birthdate=""  d
  .s birthdate=+$h
  e  d
  .s birthdate=birthdate
  i admdate'=""  d
  .s enddate=admdate
  e  d
  .s enddate=+$h
  s agestr1=..CalAge(birthdate,enddate)
  s agestr1=$g(agestr1)
  i $length(agestr1,"^")=3  d
  .s yeartmp=$p(agestr1,"^",1)
  .s montmp=$p(agestr1,"^",2)
  .s daytmp=$p(agestr1,"^",3)
  .i yeartmp=0  d
  ..i montmp=0  d
  ...s agestr=daytmp_"天"
  ..e  d
  ...s agestr=montmp_"月"
  .e  d
  ..s agestr=yeartmp
  s agestr=agestr_"^"_agestr1  
  q agestr
}

ClassMethod CalAge(IBirth As %String, IToday As %String)
{
   ;根据出生日期计算年龄
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
	s reage=$p(AgeYr,"|",12)_"^"_AgeMth_"^"_AgeDay
	q reage
}

/// Creator:倪康
/// CreateTime:2014-07-15
/// Function:退院患者预约信息要能还原到入院前的状态
/// Input:住院就诊RowID
ClassMethod RestoreStatuse(EpisodeIDTo As %String)
{
	q:EpisodeIDTo=""
	f  s IPBookingRowID=$o(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeIDTo,IPBookingRowID))  q:IPBookingRowID=""  d
	.f  s IPAppointmentRowID=$o(^DHCDocIPApp(0,"IPBookingID",IPBookingRowID,IPAppointmentRowID)) q:IPAppointmentRowID=""  d
	..s EpisodeIDTo=""     //就诊ID置为空
	..s AllocateDate=""   //分配日期、时间置为空
	..s AllocateTime="" 
	..s LastUpdateDate=+$h   //最后更新日期、时间置为当前
	..s LastUpdateTime=$p($h,",",2)
	..s IPStatus="B" //预约状态置为预约——"B"
	..&sql(Update SQLUSER.DHCDocIPAppointment set EpisodeIDTo=:EpisodeIDTo,AllocateDate=:AllocateDate,AllocateTime=:AllocateTime,LastUpdateDate=:LastUpdateDate,LastUpdateTime=:LastUpdateTime where RowID=:IPAppointmentRowID) 
	q:SQLCODE SQLCODE	
	set InfoGroup=##class(User.DHCDocIPAppointment).%OpenId(IPAppointmentRowID)
	set result=InfoGroup.%Save()
	
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "-101"
	}
	else
	{
		quit "0"	
	}
}

///                                            ///////////end/////////////////

}
