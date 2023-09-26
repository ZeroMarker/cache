/// 名称: DHCWMR.SSService.NewRecordSrv
/// 描述: 病案建档相关服务
/// 编写者：zhufei
/// 编写日期: 2015-09-23
Class DHCWMR.SSService.NewRecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-09-29
/// Description:  保存病历建档费
/// Table：       
/// Input：       aFeeInfo ：收费信息
/// Return：      返回String
/// w ##class(DHCWMR.SSService.NewRecordSrv).SaveNewFee(1,"1^9^117^12")
ClassMethod SaveNewFee(aMainID As %String, aFeeInfo As %String) As %String
{
	New (aMainID,aFeeInfo)
	Set return=0
	Quit:(aMainID="")||(aFeeInfo="") return
	
	Set PayModeID=$p(aFeeInfo,"^",1)   //支付方式
	Set UserID=$p(aFeeInfo,"^",2)      //用户ID
	Set LocID=$p(aFeeInfo,"^",3)       //科室ID
	Set GroupID=$p(aFeeInfo,"^",4)     //安全组ID
	Quit:(PayModeID="")||(UserID="")||(LocID="")||(GroupID="") return
	//建档收费方式，0不收费、1病案收费、2计费收费
	Set HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(LocID)
	Set ReceiptFeeType=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByReceipt",HospID)
	Set ReceiptFeeType=+ReceiptFeeType
	If ReceiptFeeType=0 {
		Set return=1
		Quit return
	}
	Set objMain=##Class(DHCWMR.SS.Main).GetObjById(aMainID)
	Quit:'$IsObject(objMain) return
	Quit:'$IsObject(objMain.SMMrType) return
	Set MainID=objMain.%Id()
	Set MrTypeID=objMain.SMMrType.%Id()
	Set MrNo=objMain.SMMrNo
	
	Set objMFItem=##Class(DHCWMR.MF.FeeItem).GetObjByCode("JD")  //取病案建档收费项目
	Quit:'$IsObject(objMFItem) return
	Set MFItemID=objMFItem.%Id()
	If (ReceiptFeeType=1){
		Set MFPrice=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MrReceiptPrice",HospID)
	}else{
		Set MFPrice=##class(DHCWMR.MF.FeeItem).GetMFPrice(MFItemID,MrTypeID,HospID)
	}
	Quit:MFPrice="" return
	
	//处理修改病案号之后的历史数据
	Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(MainID)
	If HisMainIDs'="" {
		Set flg=##Class(DHCWMR.MF.FeeRecord).UpdateErrorMainDr(HisMainIDs)
	}
	
	Set return=-100
	Set xRecordID=0,RecordID=""
	For {
		Set xRecordID=$o(^DHCWMR.MF.FeeRecordI("IndexMainDr",MainID,xRecordID))
		Quit:xRecordID=""
		Set objRecord=##Class(DHCWMR.MF.FeeRecord).GetObjById(xRecordID)
		Continue:'$IsObject(objRecord)
		Continue:objRecord.FRStatus="C"
		Set RecordID=xRecordID
		Quit
	}
	Quit:RecordID'="" return  //已收费，不允许重复收费
	
	If (ReceiptFeeType=1){
		Set MFAmount= MFPrice
		Set DtlInfo = "$^"_MFPrice_"^"_1
	}
	else{
		Set MFAmount=0
		Set DtlInfo=""
		For indT=1:1:$l(MFPrice,"$") {
			Set TariInfo=$p(MFPrice,"$",indT)
			Continue:TariInfo=""
			Set TarItemID=$p(MFPrice,"^",1)
			Set TarItemCode=$p(MFPrice,"^",2)
			Set TarItemDesc=$p(MFPrice,"^",3)
			Set TarItemPrice=+$p(MFPrice,"^",4)
			Set MFAmount=MFAmount+TarItemPrice
			Set TarItemPrice=$fn(TarItemPrice,"",2)
			Set DtlInfo=DtlInfo_"$"_TarItemID_"^"_TarItemPrice_"^"_1
		}
		Set:DtlInfo'="" DtlInfo=$e(DtlInfo,2,$l(DtlInfo))
		Set MFAmount=$fn(MFAmount,"",2)
	}
	
	Set MainInfo=""
	Set $p(MainInfo,"^",1)=MainID    //病案ID
	Set $p(MainInfo,"^",2)=MFItemID  //收费项
	Set $p(MainInfo,"^",3)=MFAmount  //总金额
	Set $p(MainInfo,"^",4)=PayModeID //支付方式
	Set $p(MainInfo,"^",5)=UserID    //用户ID
	Set $p(MainInfo,"^",6)=LocID     //科室ID
	Set $p(MainInfo,"^",7)=GroupID   //安全组ID
	Set flg=##class(DHCWMR.MFService.FeeRecordSrv).SaveFeeInfo(MainInfo,DtlInfo)
	If (+flg)>0 {
		Set RecordID=flg
		Set InputStr=MainID_"^"_""_"^"_RecordID
		Set flg=##class(DHCWMR.SS.MainFee).Update(InputStr,"^")
		If (+flg)<1 {
			Set return=-2
		} Else {
			Set return=RecordID
		}
	} Else {
		Set return=-1
	}

	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-29
/// Description:  退病历建档费
/// Table：       
/// Input：       aMainID ：病案ID
///               aUserID ：用户ID
///               aLocID ：科室ID
/// Return：      返回String
/// w ##class(DHCWMR.SSService.NewRecordSrv).RetNewFee(1,9,117)
ClassMethod RetNewFee(aMainID As %String, aUserID As %String, aLocID As %String) As %String
{
	New (aMainID,aUserID,aLocID)
	Set return=0
	Quit:(aMainID="")||(aUserID="")||(aLocID="") return
	
	//处理修改病案号之后的历史数据
	Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(aMainID)
	If HisMainIDs'="" {
		Set flg=##Class(DHCWMR.MF.FeeRecord).UpdateErrorMainDr(HisMainIDs)
	}
	
	Set return=-100
	Set xRecordID=0,RecordID=""
	For {
		Set xRecordID=$o(^DHCWMR.MF.FeeRecordI("IndexMainDr",aMainID,xRecordID))
		Quit:xRecordID=""
		Set objRecord=##Class(DHCWMR.MF.FeeRecord).GetObjById(xRecordID)
		Continue:'$IsObject(objRecord)
		Continue:objRecord.FRStatus="C"
		Set RecordID=xRecordID
		Quit
	}
	If RecordID="" {
		Set return=1 //无收费记录，无需退费
	} Else {
		Set return=##class(DHCWMR.MFService.FeeRecordSrv).RetFeeInfo(RecordID,aUserID,aLocID)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-29
/// Description:  更新初诊信息
/// Table：       DHCWMR.SS.Main
/// Input：       MrTypeID ：病案类型
///               MrNo ：病案号
/// Return：      返回String
/// w ##class(DHCWMR.SSService.NewRecordSrv).UpdateFirstInfo(6,"00000003","")
ClassMethod UpdateFirstInfo(aMrTypeID As %String, aMrNo As %String, aFirstInfo As %String, aPatInfo As %String) As %String
{
	New (aMrTypeID, aMrNo, aFirstInfo,aPatInfo)
	Set return=0
	Quit:(aMrTypeID="")||(aMrNo="")||(aFirstInfo="") return
	
	Set FirstHospID = $p(aFirstInfo,"^",1)  //初诊院区
	Set FirstLocID = $p(aFirstInfo,"^",2)   //初诊科室
	Set:FirstLocID'="" FirstHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(FirstLocID)
	Set FirstDocID = $p(aFirstInfo,"^",3)   //初诊医师
	Set FirstDate = $p(aFirstInfo,"^",4)    //初诊日期
	Set:FirstDate["-" FirstDate=$zdh(FirstDate,3)
	Set:FirstDate["/" FirstDate=$zdh(FirstDate,4)
	
	Set FirstAdm = $p(aFirstInfo,"^",5)     //初诊就诊
	Set PatFrom=$p(aFirstInfo,"^",6)
	Set EPPatFrom=$p(aFirstInfo,"^",7)
	Set AdmStatus=$p(aFirstInfo,"^",8)
	
	Set objMain=##class(DHCWMR.SS.Main).GetObjByMrNo(aMrTypeID,aMrNo)
	Quit:'$IsObject(objMain) return
	Set MainID=objMain.%Id()
	Set BuildDate=objMain.SMBuildDate
	Set:BuildDate'="" BuildDate=$zd(BuildDate,3)
	Set BuildTime=objMain.SMBuildTime
	Set:BuildTime'="" BuildTime=$zt(BuildTime,1)
	Set BuildUser=objMain.SMBuildUser
	Set:BuildUser'="" BuildUser=$p($g(^SSU("SSUSR",BuildUser)),"^",2)

	Tstart
	Set flg=##class(DHCWMR.SS.VolPaadm).UpdateByMrNo(aMrTypeID,aMrNo,aPatInfo,aFirstInfo)
	if (+flg<1) TrollBack
	Quit:(+flg<1) return	

	Set InputStr=""
	Set $p(InputStr,"^",1)=objMain.%Id()
	Set $p(InputStr,"^",2)=aMrTypeID
	Set $p(InputStr,"^",3)=aMrNo
	Set $p(InputStr,"^",4)=objMain.SMBuildDate
	Set $p(InputStr,"^",5)=objMain.SMBuildTime
	Set $p(InputStr,"^",6)=objMain.SMIsActive
	Set $p(InputStr,"^",7)=objMain.SMResume      //备注
	Set $p(InputStr,"^",8)=objMain.SMMarker      //特殊标示
	Set $p(InputStr,"^",9)=objMain.SMFileNo      //归档号
	Set $p(InputStr,"^",10)=objMain.SMBarcode    //病案条码
	Set $p(InputStr,"^",11)=objMain.SMBuildUser  //建档人
	Set $p(InputStr,"^",12)=FirstHospID          //初诊院区
	Set $p(InputStr,"^",13)=FirstLocID           //初诊科室
	Set $p(InputStr,"^",14)=FirstDocID           //初诊医生
	Set $p(InputStr,"^",15)=FirstDate            //初诊日期
	Set $p(InputStr,"^",16)=FirstAdm             //初诊就诊
	Set $p(InputStr,"^",17)=PatFrom              //病人来源
	Set $p(InputStr,"^",18)=EPPatFrom            //急诊来源
	Set $p(InputStr,"^",19)=AdmStatus            //就诊状态
	Set $p(InputStr,"^",20)=objMain.SMInitMainDr //指初始记录（修改病案号会记录）
	Set flg=##class(DHCWMR.SS.Main).Update(InputStr,"^")
	if (+flg<1) TrollBack
	Quit:(+flg<1) return
	
	Set return = flg 
	Tcommit
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-29
/// Description:  根据病案类型+医院取费用信息
/// Table：       DHCWMR.MF.FeeItem
/// Input：       MrTypeID ：病案类型
///               HospID ：医院
/// Return：      返回String
/// w ##class(DHCWMR.SSService.NewRecordSrv).GetNewRecordFee(6,1)
ClassMethod GetNewRecordFee(aMrTypeID As %String, aHospID As %String)
{
	New (aMrTypeID,aHospID)
	Set return=0
	Quit:(aMrTypeID="") return
	
	Set MFFeeTypeByReceipt=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MFFeeTypeByReceipt",aHospID)
	Quit:MFFeeTypeByReceipt=0 return
	
	If MFFeeTypeByReceipt=1{
		Set return = ##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MrReceiptPrice",aHospID)
		Quit return
	}

	Set objMFItem=##Class(DHCWMR.MF.FeeItem).GetObjByCode("JD")  //取病案建档收费项目
	Quit:'$IsObject(objMFItem) return
	Set MFItemID=objMFItem.%Id()
	Set MFPrice=##class(DHCWMR.MF.FeeItem).GetMFPrice(MFItemID,aMrTypeID,aHospID)
	Quit:MFPrice="" return
	
	Set MFAmount=0
	For indT=1:1:$l(MFPrice,"$") {
		Set TariInfo=$p(MFPrice,"$",indT)
		Continue:TariInfo=""
		Set TarItemPrice=+$p(TariInfo,"^",4)
		Set MFAmount=MFAmount+TarItemPrice
	}
	Set MFAmount=$fn(MFAmount,"",2)
	Set return=MFAmount
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-29
/// Description:  根据病案类型+病案号取病案信息
/// Table：       DHCWMR.SS.Main
/// Input：       MrTypeID ：病案类型
///               MrNo ：病案号
/// Return：      返回String(多值^分隔)
/// w ##class(DHCWMR.SSService.NewRecordSrv).GetMRInfoByMrNo(6,"00000006")
ClassMethod GetMRInfoByMrNo(aMrTypeID As %String, aMrNo As %String) As %String
{
	New (aMrTypeID,aMrNo)
	Set return=""
	Quit:(aMrTypeID="")||(aMrNo="") return
	
	Set objMain=##class(DHCWMR.SS.Main).GetObjByMrNo(aMrTypeID,aMrNo)
	Quit:'$IsObject(objMain) return
	Set MainID=objMain.%Id()
	Set BuildDate=objMain.SMBuildDate
	//Set:BuildDate'="" BuildDate=$zd(BuildDate,3)		
	Set:BuildDate'="" BuildDate=##class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BuildDate)
	
	Set BuildTime=objMain.SMBuildTime
	Set:BuildTime'="" BuildTime=$zt(BuildTime,1)
	Set BuildUser=objMain.SMBuildUser
	Set:BuildUser'="" BuildUser=$p($g(^SSU("SSUSR",BuildUser)),"^",2)
	
	Set (FirstHospDesc,FirstLocDesc,FirstDocDesc)=""
	Set FirstHospID=objMain.SMFirstHosp
	Set:FirstHospID'="" FirstHospDesc=$p($g(^CT("HOSP",FirstHospID)),"^",2)
	Set FirstLocID=objMain.SMFirstLoc
	Set:FirstLocID'="" FirstLocDesc=$p($g(^CTLOC(FirstLocID)),"^",2)
	Set:$p(FirstLocDesc,"-",2)'="" FirstLocDesc=$p(FirstLocDesc,"-",2)
	Set FirstDocID=objMain.SMFirstDoc
	Set:FirstDocID'="" FirstDocDesc=$p($g(^CTPCP(FirstDocID,1)),"^",2)
	Set FirstDate=objMain.SMFirstDate
	//Set:FirstDate'="" FirstDate=$zd(FirstDate,3)	
	Set:FirstDate'="" FirstDate=##class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FirstDate)
	
	Set FirstAdm=objMain.SMFirstAdm
	
	Set PatFrom=objMain.SMPatFrom
	Set EPPatFrom=objMain.SMEPPatFrom
	Set PatAdmStatus=objMain.SMPatAdmStatus
	Set:$IsObject(PatFrom) PatFrom =PatFrom.%Id()
	Set:$IsObject(EPPatFrom) EPPatFrom =EPPatFrom.%Id()
	Set:$IsObject(PatAdmStatus) PatAdmStatus =PatAdmStatus.%Id()
	
	Set MRMoney=0
	Set Count=objMain.ChildFee.Count()
	For indFee=1:1:Count {
		Set objFee=objMain.ChildFee.GetAt(indFee)
		Continue:'$IsObject(objFee)
		Continue:'$IsObject(objFee.MFRecordDr)
		Continue:objFee.MFRecordDr.FRStatus'="N"
		Set tMoney=objFee.MFRecordDr.FRMoney
		Set MRMoney=MRMoney+tMoney
	}
	Set MRMoney=$fn(MRMoney,"",2)
	
	//处理修改病案号之后的历史数据
	Set HisMainIDs=##class(DHCWMR.SS.Main).GetHisMainByID(MainID)
	If HisMainIDs'="" {
		Set flg=##Class(DHCWMR.MO.LendRecord).UpdateErrorMainDr(HisMainIDs)
	}
	
	Set MRStatus="入库"
	Set MRLocCode="",MRLocDesc=""
	Set MRUserCode="",MRUserName=""
	Set xLRecordID=0
	For {
		Set xLRecordID=$o(^DHCWMR.MO.LendRecordI("IndexMainDr",MainID,xLRecordID))
		Quit:xLRecordID=""
		Set objRecord=##class(DHCWMR.MO.LendRecord).GetObjById(xLRecordID)
		Continue:'$IsObject(objRecord)
		Continue:objRecord.LRStatus'="L"
		Set MRStatus="出库"
		Quit
	}
	
	Set $p(return,"^",1)=MainID
	Set $p(return,"^",2)=BuildDate_" "_BuildTime
	Set $p(return,"^",3)=BuildUser
	Set $p(return,"^",4)=MRMoney
	Set $p(return,"^",5)=MRStatus
	Set $p(return,"^",6)=FirstHospID_"&"_FirstHospDesc
	Set $p(return,"^",7)=FirstLocID_"&"_FirstLocDesc
	Set $p(return,"^",8)=FirstDocID_"&"_FirstDocDesc
	Set $p(return,"^",9)=FirstDate
	Set $p(return,"^",10)=FirstAdm
	Set $p(return,"^",11)=PatFrom
	Set $p(return,"^",12)=EPPatFrom
	Set $p(return,"^",13)=PatAdmStatus
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-29
/// Description:  根据登记号/卡号,病案类型取病人建档基本信息
/// Table：       Pa_PatMas、Pa_Person、DHCWMR_SS.VolPaadm
/// Input：       RegNo ：登记号
///               CardNo ：卡号
/// 				  aMrTypeID：病案类型
/// Return：      返回String(多值^分隔)
/// w ##class(DHCWMR.SSService.NewRecordSrv).GetPatInfo("1","",6)
ClassMethod GetPatInfo(aRegNo As %String, aCardNo As %String, aMrTypeID As %String) As %String
{
	New (aRegNo,aCardNo,aMrTypeID)
	Set return=""
	Quit:(aRegNo="")&&(aCardNo="") return
	Quit:aMrTypeID="" return
	
	If aRegNo'="" {
		Set PatientID=##Class(DHCWMR.SSService.CommonSrv).GetPatientID(aRegNo)
	} Else {
		Set PatientID=##Class(DHCWMR.SSService.CommonSrv).GetPatByCardNo(aCardNo)
	}
	Quit:PatientID="" return
	
	Set RegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)            //登记号
	Set SocStaID=$p($g(^PAPER(PatientID,"PER",1)),"^",10)        //付费方式
	Set:SocStaID'="" SocStaDesc=$p($g(^CT("SS",SocStaID)),"^",2)
	
	//Set SocialNo=$p($g(^PAPER(PatientID,"ALL")),"^",19)      //医保号
	Set SocialNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)      //医保号
	
	Set MedicalNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)       //医联码
	Set MrNo = ##class(DHCWMR.SSService.MrNoSrv).GetMrNoByPatientID(PatientID,aMrTypeID)

	Set xMainID = "",VolumeID=""
	For {
		Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_$zcvt(MrNo,"U"),1,xMainID))
		Quit:xMainID=""
		Continue:VolumeID'=""
		Set xVolumeID=""
		For {
			Set xVolumeID=$o(^DHCWMR.SS.VolumeI("IndexMainDrAct",xMainID,1,xVolumeID))
			Quit:xVolumeID=""
			Continue:VolumeID'=""
			Set VolumeID=xVolumeID
		}
	}
	
	If ($g(VolumeID)=""){
		Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)        //姓名
		Set NameSpell=$p($g(^PAPER(PatientID,"ALL")),"^",2)      //姓名拼音
		Set CardTypeID=$p($g(^PAPER(PatientID,"PAT",3)),"^",7)       //证件类型
		Set:CardTypeID'="" CardTypeDesc=$p($g(^PAC("CARD",CardTypeID)),"^",2)
		Set PersonalID=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)     //身份证号
		Set SexID=$p($g(^PAPER(PatientID,"ALL")),"^",7)          //性别
		Set:SexID'="" SexDesc=$p($g(^CT("SEX",SexID)),"^",2)
		Set MaritalID=$p($g(^PAPER(PatientID,"PER",2)),"^",3)    //婚姻状况
		Set:MaritalID'="" MaritalDesc=$p($g(^CT("MAR",MaritalID)),"^",2)
		Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)       //出生日期		
		Set:Birthday'="" Birthday=##class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(Birthday)
		
		Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,"","","")
		Set OccupationID=$p($g(^PAPER(PatientID,"PER",2)),"^",6)     //职业
		Set:OccupationID'="" OccupationDesc=$p($g(^CT("OCC",OccupationID)),"^",2)
		Set:$g(OccupationDesc)["-" OccupationDesc=$p(OccupationDesc,"-",2)
		Set NationID=$p($g(^PAPER(PatientID,"PER",2)),"^",1)     //民族
		Set:NationID'="" NationDesc=$p($g(^CT("NAT",NationID)),"^",2)
		Set:$g(NationDesc)["-" NationDesc=$p(NationDesc,"-",2)
		Set CountryID=$p($g(^PAPER(PatientID,"PER",1)),"^",8)    //国籍
		Set:CountryID'="" CountryDesc=$p($g(^CT("COU",CountryID)),"^",2)
		Set:$g(CountryDesc)["-" CountryDesc=$p(CountryDesc,"-",2)
		Set dhcpersonid=$o(^DHCPERSON(0,"PAPERSON",PatientID,""))
		Set:+dhcpersonid'=0 BirthProvinceID=$p($g(^DHCPERSON(dhcpersonid)),"^",13)	  //出生地省
		Set:+$g(BirthProvinceID)'=0 BirthProvinceDesc=$p($p($g(^CT("PROV",BirthProvinceID)),"^",2),"-",2)
		Set:+dhcpersonid'=0 BirthCityID=$p($g(^DHCPERSON(dhcpersonid)),"^",14)	  //出生地市
		Set:+$g(BirthCityID)'=0 BirthCityDesc=$p($p($g(^CT("CIT",BirthCityID)),"^",2),"-",2)
		Set:+dhcpersonid'=0 RegistAddr=$p($g(^DHCPERSON(dhcpersonid)),"^",20)       //户口地址
		Set:+dhcpersonid'=0 RegistZIP=$p($g(^DHCPERSON(dhcpersonid)),"^",9) //户口邮编
		Set Company=$p($g(^PAPER(PatientID,"PER",4)),"^",18)     //工作单位
		Set:+dhcpersonid'=0 CompanyZIP=$p($g(^DHCPERSON(dhcpersonid)),"^",7)  //单位邮编
		Set CompanyTel=$p($g(^PAPER(PatientID,"PER",1)),"^",9)   //单位电话
		Set ForeignId=$p($g(^PAPER(PatientID,"PER",2)),"^",13)   //联系人
		Set RelationID=$p($g(^PAPER(PatientID,"EMP")),"^",4)     //联系关系
		Set:RelationID'="" RelationDesc=$p($g(^CT("RLT",RelationID)),"^",2)
		Set ForeignAddr=$p($g(^PAPER(PatientID,"PER",1)),"^",1)  //联系地址
		Set ForeignTel=$p($g(^PAPER(PatientID,"ALL")),"^",4)     //联系电话
	}
	else{		
		Set VolPaadmID =VolumeID_"||" _1
		Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).%OpenId(VolPaadmID)
		
		Set PatName=objVolPaadm.VPPatName        	//姓名
		Set NameSpell=objVolPaadm.VPNameSpell      	//姓名拼音
		Set CardTypeDesc = objVolPaadm.VPCardType 
		If CardTypeDesc'="" {
			Set xCardTypeID=""
			For {
				Set xCardTypeID=$o(^PAC("CARD",xCardTypeID))
				Quit:xCardTypeID=""
				Set:$p($g(^PAC("CARD",xCardTypeID)),"^",2)=CardTypeDesc CardTypeID=xCardTypeID
			}
		}
		Set PersonalID=objVolPaadm.VPIdentityCode   //身份证号
		
		Set SexDesc = objVolPaadm.VPSex
		If SexDesc'="" {
			Set xSexID=""
			For {
				Set xSexID=$o(^CT("SEX",xSexID))
				Quit:xSexID=""
				Set:$p($g(^CT("SEX",xSexID)),"^",2)=SexDesc SexID=xSexID
			}
		}
		Set MaritalDesc = objVolPaadm.VPWedlock
		If MaritalDesc'="" {
			Set xMaritalID=""
			For {
				Set xMaritalID=$o(^CT("MAR",xMaritalID))
				Quit:xMaritalID=""
				Set:$p($g(^CT("MAR",xMaritalID)),"^",2)=MaritalDesc MaritalID=xMaritalID
			}
		}
		Set Birthday=objVolPaadm.VPBirthday       //出生日期	
		Set:Birthday'="" Birthday=##class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(Birthday)
		
		Set Age=objVolPaadm.VPAge
		Set OccupationDesc=objVolPaadm.VPOccupation     //职业
		If OccupationDesc'="" {
			Set xOccupation=""
			For {
				Set xOccupation=$o(^CT("OCC",xOccupation))
				Quit:xOccupation=""
				Set:$p($g(^CT("OCC",xOccupation)),"^",2)=OccupationDesc OccupationID=xOccupation
			}
		}
		Set NationDesc=objVolPaadm.VPNation
		If NationDesc'="" {
			Set xNationID=""
			For {
				Set xNationID=$o(^CT("NAT",xNationID))
				Quit:xNationID=""
				Set:$p($p($g(^CT("NAT",xNationID)),"^",2),"-",2)=NationDesc NationID=xNationID
			}
		}
		Set CountryDesc=objVolPaadm.VPNationality    //国籍
		If CountryDesc'="" {
			Set xCountryID=""
			For {
				Set xCountryID=$o(^CT("COU",xCountryID))
				Quit:xCountryID=""
				Set:$p($p($g(^CT("COU",xCountryID)),"^",2),"-",2)=CountryDesc CountryID=xCountryID
			}
		}
		Set BirthProvinceDesc=objVolPaadm.VPBirthProvince    //出生省
		If BirthProvinceDesc'="" {
			Set xBirthProvinceID=""
			For {
				Set xBirthProvinceID=$o(^CT("PROV",xBirthProvinceID))
				Quit:xBirthProvinceID=""
				Set:$p($p($g(^CT("PROV",xBirthProvinceID)),"^",2),"-",2)=BirthProvinceDesc BirthProvinceID=xBirthProvinceID
			}
		}
		Set BirthCityDesc=objVolPaadm.VPBirthCity   //出生市
		If BirthCityDesc'="" {
			Set xBirthCityID=""
			For {
				Set xBirthCityID=$o(^CT("COU",xBirthCityID))
				Quit:xBirthCityID=""
				Set:$p($p($g(^CT("CIT",xBirthCityID)),"^",2),"-",2)=BirthCityDesc BirthCityID=xBirthCityID
			}
		}
		Set RegistAddr=objVolPaadm.VPRegAddress       //户口地址
		Set RegistZIP=objVolPaadm.VPRegZip   //户口邮编
		Set Company=objVolPaadm.VPCompany      //工作单位
		Set CompanyZIP=objVolPaadm.VPCompanyZip  //单位邮编
		Set CompanyTel=objVolPaadm.VPCompanyTel   //单位电话
		Set ForeignId=objVolPaadm.VPRelativeName    //联系人
		Set RelationDesc=objVolPaadm.VPRelationDesc     //联系关系
		If RelationDesc'="" {
			Set xRelationID=""
			For {
				Set xRelationID=$o(^CT("COU",xRelationID))
				Quit:xRelationID=""
				Set:$p($g(^CT("RLT",xRelationID)),"^",2)=RelationDesc RelationID=xRelationID
			}
		}
		Set ForeignAddr=objVolPaadm.VPRelativeAddress  //联系地址
		Set ForeignTel=objVolPaadm.VPRelativeTel     //联系电话

	}
	Set $p(return,"^",1)=$g(PatientID)
	Set $p(return,"^",2)=$g(RegNo)
	Set $p(return,"^",3)=$g(SocStaID)_"&"_$g(SocStaDesc)
	Set $p(return,"^",4)=$g(SocialNo)
	Set $p(return,"^",5)=$g(MedicalNo)
	Set $p(return,"^",6)=$g(PatName)
	Set $p(return,"^",7)=$g(NameSpell)
	Set $p(return,"^",8)=$g(CardTypeID)_"&"_$g(CardTypeDesc)
	Set $p(return,"^",9)=$g(PersonalID)
	Set $p(return,"^",10)=$g(SexID)_"&"_$g(SexDesc)
	Set $p(return,"^",11)=$g(MaritalID)_"&"_$g(MaritalDesc)
	Set $p(return,"^",12)=$g(Birthday)
	Set $p(return,"^",13)=$g(Age)
	Set $p(return,"^",14)=$g(OccupationID)_"&"_$g(OccupationDesc)
	Set $p(return,"^",15)=$g(NationID)_"&"_$g(NationDesc)
	Set $p(return,"^",16)=$g(CountryID)_"&"_$g(CountryDesc)
	Set $p(return,"^",17)=$g(BirthProvinceID)_"&"_$g(BirthProvinceDesc)
	Set $p(return,"^",18)=$g(BirthCityID)_"&"_$g(BirthCityDesc)
	Set $p(return,"^",19)=$g(RegistAddr)
	Set $p(return,"^",20)=$g(RegistZIP)
	Set $p(return,"^",21)=$g(Company)
	Set $p(return,"^",22)=$g(CompanyZIP)
	Set $p(return,"^",23)=$g(CompanyTel)
	Set $p(return,"^",24)=$g(ForeignId)
	Set $p(return,"^",25)=$g(RelationID)_"&"_$g(RelationDesc)
	Set $p(return,"^",26)=$g(ForeignAddr)
	Set $p(return,"^",27)=$g(ForeignTel)
	Set $p(return,"^",28)=$g(MrNo)

	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-23
/// Description:  查询就诊列表
/// Table：       Pa_Adm
/// Input：       PatientID : 病人ID
///               MrTypeID : 病案类型ID
///               HospID : 医院ID
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.NewRecordSrv","QryAdmByPat",3,6,2)
Query QryAdmByPat(aPatientID As %String, aMrTypeID As %String, aHospID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,AdmType:%String,AdmDate:%String,AdmTime:%String,AdmLocID:%String,AdmLocDesc:%String,AdmDocID:%String,AdmDocDesc:%String,RegDoctor:%String,ConsultRoom:%String,ConsultArea:%String")
{
}

ClassMethod QryAdmByPatExecute(ByRef qHandle As %Binary, aPatientID As %String, aMrTypeID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aPatientID="")||(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) $$$OK
	Set MTAdmType=objMrType.MTAdmType
	
	Set xAdmType=""
	For {
		Set xAdmType=$o(^PAPERdr(aPatientID,"ADM",xAdmType))
		Quit:xAdmType=""
		Continue:MTAdmType'[xAdmType
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAPERdr(aPatientID,"ADM",xAdmType,xPaadm))
			Quit:xPaadm=""
			
			Set EpisodeID=xPaadm
			Set PatientID=aPatientID
			Set AdmType=$p($g(^PAADM(xPaadm)),"^",2)
			Set AdmType=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:AdmType)
			//upadte by pylian 2016-02-18 修改入院时间取值方式
			Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(xPaadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			//Set AdmDate=$p($g(^PAADM(xPaadm)),"^",6)
			//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
			
			//Set AdmTime=$p($g(^PAADM(xPaadm)),"^",7)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			Set AdmLocID=$p($g(^PAADM(xPaadm)),"^",4)
			Set AdmLocDesc=""
			Set:AdmLocID'="" AdmLocDesc=$p($g(^CTLOC(AdmLocID)),"^",2)
			Set:$p(AdmLocDesc,"-",2)'="" AdmLocDesc=$p(AdmLocDesc,"-",2)
			Set AdmDocID=$p($g(^PAADM(xPaadm)),"^",9)
			Set AdmDocDesc=""
			Set:AdmDocID'="" AdmDocDesc=$P($g(^CTPCP(AdmDocID,1)),"^",2)
			Set CheckHospital = ##class(DHCWMR.SSService.HospitalSrv).CheckHospital(AdmLocID,aHospID)
			Continue:CheckHospital=0   //科室是否属于查询医院
			
			//取挂号信息
			Set RegDoctor="",ConsultRoom="",ConsultArea=""
			Set xQueID="",QueID=""
			For {
				Set xQueID=$o(^User.DHCQueueI("QuePaadmDrIndex",xPaadm,xQueID),-1)
				Quit:xQueID=""
				Set QueDocDr=$List(^User.DHCQueueD(xQueID),5)
				Continue:QueDocDr=""
				Set QueID=xQueID
				Quit
			}
			Set:QueID="" QueID=$o(^User.DHCQueueI("QuePaadmDrIndex",xPaadm,""),-1)
			If QueID'="" {
				Set objQue=##Class(User.DHCQueue).%OpenId(QueID)
				If objQue'="" Do objQue.%Close()
				If $IsObject(objQue) {
					If $IsObject(objQue.QueMarkDr) {
						Set RegDocDr=objQue.QueMarkDr.%Id() 	   //号别
						Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2)
						Set RegfeeDr=""
						Set RegfeeDr=$o(^User.DHCRegistrationFeeI("ADM"," "_xPaadm,""))
						If RegfeeDr'="" {
							Set RegRangeTimeDr=$LIST(^User.DHCRegistrationFeeD(RegfeeDr),21)
							Set:RegRangeTimeDr'="" RegRangeTime=$p(^DHCTimeRange(RegRangeTimeDr),"^",2)
							set RegDoctor=RegDoctor_"("_$g(RegRangeTime)_")"
						}
					}
					If $IsObject(objQue.QueRoomDr){
						Set ConsultRoom=objQue.QueRoomDr.CTLOCDesc	//诊室
					}
					If $IsObject(objQue.QueExabDr){
						Set ConsultArea=objQue.QueExabDr.ExabName	//诊区
					}
				}
			}
			
			Set Data=$lb(EpisodeID,PatientID,AdmType,AdmDate,AdmTime,AdmLocID,AdmLocDesc,AdmDocID,AdmDocDesc,RegDoctor,ConsultRoom,ConsultArea)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryAdmByPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmByPatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAdmByPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmByPatExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2015-10-30
/// Description:  打印门诊病案首页
/// Input：       itmjs ：
///               aMrTypeID ：病案类型ID
/// 			  aMrNo：病案号
/// 		      aType：标志：副页/建档 打印
/// Return：      返回打印函数String
/// w ##class(DHCWMR.SSService.NewRecordSrv).PrintOPFrontPage("fillxlSheet",6,"Z000070",1)
ClassMethod PrintOPFrontPage(itmjs As %String, aMrTypeID As %String, aMrNo As %String, aType As %String, aVpVolumeID As %String = "") As %String
{
	New (itmjs,aMrTypeID,aMrNo,aType,aVpVolumeID)
	Set return=0
	Set MRInfo = ..GetMRInfoByMrNo(aMrTypeID,aMrNo)
	Set Papmi = ##class(DHCWMR.SSService.MrNoSrv).GetPatientIDByMrNo(aMrNo,aMrTypeID)
	Quit:+Papmi=0 return
	Set PapmiNo = $p($g(^PAPER(Papmi,"PAT",1)),"^",1)
	Set PatInfo = ##class(DHCWMR.SSService.NewRecordSrv).GetPatInfo(PapmiNo,"",aMrTypeID)
	
	Set BuildDateTime = $p(MRInfo,"^",2)
	Set BuildUser = $p(MRInfo,"^",3)
	Set FirstHospDesc = $p($p(MRInfo,"^",6),"&",2)
	Set FirstDate = $p(MRInfo,"^",9)
	
	//条码
	Set MainID= $p(MRInfo,"^",1)
	Set objMain = ##class(DHCWMR.SS.Main).GetObjById(MainID)
	Set:$IsObject(objMain) BarCode=objMain.SMBarcode
	If (aType=1){
		//首页条码
		Set:BarCode'="" BarCode="*"_BarCode_"*"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($g(BarCode),"O","JS")_"',"_3_",4);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($g(BarCode),"O","JS")_"',"_5_",4);"
		&javascript<#(retval)#>
	}else{
		//副页条码
		Set objVPVolume =##Class(DHCWMR.VP.Volume).GetObjById(aVpVolumeID)
		Set BarCode = objVPVolume.VVBarcode
		Set BarCode="*"_BarCode_"*"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($g(BarCode),"O","JS")_"',"_3_",4);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($g(BarCode),"O","JS")_"',"_5_",4);"
		&javascript<#(retval)#>
		//副页标志
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("F","O","JS")_"',"_4_",14);"
		&javascript<#(retval)#>
	}
	//医保卡号
	Set SocialNo=$p(PatInfo,"^",4)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($g(SocialNo),"O","JS")_"',"_7_",14);"
	&javascript<#(retval)#>

	//门诊,急诊( 120,999 自行就诊)
	Set PatFrom = $p(MRInfo,"^",11)
	Set EPPatFrom = $p(MRInfo,"^",12)
	Set objPatFrom = ##class(DHCWMR.SS.Dictionary).GetObjById(PatFrom)
	If (objPatFrom.SDDesc="急诊"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_9_",10);"
		&javascript<#(retval)#>
		Set objEPPatFrom = ##class(DHCWMR.SS.Dictionary).GetObjById(EPPatFrom)
		If (objEPPatFrom.SDDesc="自行就诊"){
			Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_9_",26);"
			&javascript<#(retval)#>
		}else{
			Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_9_",18);"
			&javascript<#(retval)#>
		}
	}else{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_9_",5);"
		&javascript<#(retval)#>
	}
	//付款方式
	Set SocStaID=$p($p(PatInfo,"^",3),"&",1)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SocStaID,"O","JS")_"',"_11_",10);"
	&javascript<#(retval)#>
	
	//病案号
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(aMrNo,"O","JS")_"',"_6_",31);"
	&javascript<#(retval)#>
	
	//病人姓名
	Set PatName=$p(PatInfo,"^",6)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatName,"O","JS")_"',"_13_",5);"
	&javascript<#(retval)#>
	
	//性别
	Set SexDesc=$p($p(PatInfo,"^",10),"&",2)
	If SexDesc="男"{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(1,"O","JS")_"',"_15_",20);"
		&javascript<#(retval)#>
	}elseif SexDesc="女"{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(2,"O","JS")_"',"_15_",20);"
		&javascript<#(retval)#>
	}else{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(0,"O","JS")_"',"_15_",20);"
		&javascript<#(retval)#>
	}
	//出生日期
	Set BrithDay=$p(PatInfo,"^",12)
	If +BrithDay'=0{
		if BrithDay["/" {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(BrithDay,"/",3),"O","JS")_"',"_15_",32);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(BrithDay,"/",2),"O","JS")_"',"_15_",35);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(BrithDay,"/",1),"O","JS")_"',"_15_",37);"
			&javascript<#(retval)#>
		}
		elseif BrithDay["-" {
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(BrithDay,"-",1),"O","JS")_"',"_15_",32);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(BrithDay,"-",2),"O","JS")_"',"_15_",35);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(BrithDay,"-",3),"O","JS")_"',"_15_",37);"
			&javascript<#(retval)#>
		}
	}
	//年龄
	Set Age=$p(PatInfo,"^",13)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_15_",42);"
	&javascript<#(retval)#>
	//婚姻
	Set MaritalDesc=$p($p(PatInfo,"^",11),"&",2)
	if (MaritalDesc="未婚"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(1,"O","JS")_"',"_17_",5);"
		&javascript<#(retval)#>
	}elseif (MaritalDesc="已婚"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(2,"O","JS")_"',"_17_",5);"
		&javascript<#(retval)#>
	}elseif (MaritalDesc="丧偶"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(3,"O","JS")_"',"_17_",5);"
		&javascript<#(retval)#>
	}elseif (MaritalDesc="离异"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(4,"O","JS")_"',"_17_",5);"
		&javascript<#(retval)#>
	}else{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(9,"O","JS")_"',"_17_",5);"
		&javascript<#(retval)#>
	}
	//职业
	Set OccupationDesc=$p($p(PatInfo,"^",14),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(OccupationDesc,"O","JS")_"',"_17_",24);"
	&javascript<#(retval)#>
	//民族
	Set NationDesc=$p($p(PatInfo,"^",15),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(NationDesc,"O","JS")_"',"_17_",34);"
	&javascript<#(retval)#>
	//国籍
	Set CountryDesc=$p($p(PatInfo,"^",16),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CountryDesc,"O","JS")_"',"_17_",41);"
	&javascript<#(retval)#>
	//出生地省市
	Set BirthProvinceDesc=$p($p(PatInfo,"^",17),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(BirthProvinceDesc,"O","JS")_"',"_19_",6);"
	&javascript<#(retval)#>
	//出生地县
	Set BirthCityDesc=$p($p(PatInfo,"^",18),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(BirthCityDesc,"O","JS")_"',"_19_",15);"
	&javascript<#(retval)#>	
	//证件类型
	Set CardTypeID=$p($p(PatInfo,"^",8),"&",1)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CardTypeID,"O","JS")_"',"_19_",32);"
	&javascript<#(retval)#>
	//证件号码
	Set CardTypeID=$p(PatInfo,"^",9)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CardTypeID,"O","JS")_"',"_19_",37);"
	&javascript<#(retval)#>
	//工作单位地址
	Set Company=$p(PatInfo,"^",21)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Company,"O","JS")_"',"_21_",11);"
	&javascript<#(retval)#>
	//工作单位电话
	Set CompanyTel=$p(PatInfo,"^",23)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CompanyTel,"O","JS")_"',"_21_",30);"
	&javascript<#(retval)#>
	//工作邮编
	Set CompanyZIP=$p(PatInfo,"^",22)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CompanyZIP,"O","JS")_"',"_21_",41);"
	&javascript<#(retval)#>
	//户口地址
	Set RegistAddr=$p(PatInfo,"^",19)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RegistAddr,"O","JS")_"',"_23_",7);"
	&javascript<#(retval)#>
	//户口邮编
	Set RegistZIP=$p(PatInfo,"^",20)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RegistZIP,"O","JS")_"',"_23_",41);"
	&javascript<#(retval)#>
	//联系人姓名
	Set RelationName=$p(PatInfo,"^",24)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RelationName,"O","JS")_"',"_25_",8);"
	&javascript<#(retval)#>
	//联系人关系
	Set RelationDesc=$p($p(PatInfo,"^",25),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RelationDesc,"O","JS")_"',"_25_",21);"
	&javascript<#(retval)#>
	//联系人地址
	Set ForeignAddr=$p(PatInfo,"^",26)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ForeignAddr,"O","JS")_"',"_25_",28);"
	&javascript<#(retval)#>
	//联系人电话
	Set ForeignTel=$p(PatInfo,"^",27)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ForeignTel,"O","JS")_"',"_25_",40);"
	&javascript<#(retval)#>
	//初复诊情况
	Set PatAdmStatus = $p(MRInfo,"^",13)
	Set objAdmStatus = ##class(DHCWMR.SS.Dictionary).GetObjById(PatAdmStatus)
	If (objAdmStatus.SDDesc="初诊"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_27_",7);"
		&javascript<#(retval)#>
	}elseif (objAdmStatus.SDDesc="门诊复诊"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_27_",14);"
		&javascript<#(retval)#>
	}elseif (objAdmStatus.SDDesc="出院后复诊"){
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_27_",22);"
		&javascript<#(retval)#>
	}else{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("√","O","JS")_"',"_27_",30);"
		&javascript<#(retval)#>
	}
	//门诊科室
	Set FirstLocDesc = $p($p(MRInfo,"^",7),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FirstLocDesc,"O","JS")_"',"_27_",36);"
	&javascript<#(retval)#>
	//初诊医师
	Set FirstDocDesc = $p($p(MRInfo,"^",8),"&",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDocDesc,"O","JS")_"',"_29_",7);"
	&javascript<#(retval)#>
	//初诊日期
	Set FirstDate = $p(MRInfo,"^",9)
	Set:FirstDate["/" FirstDate=$p(FirstDate,"/",3)_"年"_$p(FirstDate,"/",2)_"月"_$p(FirstDate,"/",1)_"日"
	Set:FirstDate["-" FirstDate=$p(FirstDate,"-",1)_"年"_$p(FirstDate,"-",2)_"月"_$p(FirstDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FirstDate,"O","JS")_"',"_29_",21);"
	&javascript<#(retval)#>
	//建病历日期
	Set BuildDateTime = $p(MRInfo,"^",2)
	Set:BuildDateTime'="" BuildDateTime=$p(BuildDateTime," ",1)
	Set:BuildDateTime["/" BuildDateTime=$p(BuildDateTime,"/",3)_"年"_$p(BuildDateTime,"/",2)_"月"_$p(BuildDateTime,"/",1)_"日"
	Set:BuildDateTime["-" BuildDateTime=$p(BuildDateTime,"-",1)_"年"_$p(BuildDateTime,"-",2)_"月"_$p(BuildDateTime,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(BuildDateTime,"O","JS")_"',"_29_",35);"
	&javascript<#(retval)#>
	q 1
}

}
