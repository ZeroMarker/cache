/// 名称: DHCWMR.SSService.PatientQry
/// 描述: 病案查询服务（病人基本信息查询）
/// 编写者：zhufei
/// 编写日期: 2014-09-20
Class DHCWMR.SSService.PatientQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-20
/// Description:  查询病案卷列表
/// Table：       DHCWMR.SS.Volume
/// Input：       ArgInput : 查询条件
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.PatientQry","QryVolumeList","2^7^500388^^^^^^^^^^")
Query QryVolumeList(aArgInput As %String) As %Query(ROWSPEC = "MainID:%String,VolID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,IdentityCode:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,Company:%String,HomeAddress:%String,RegAddress:%String,RelativeName:%String,ChiefProfessor:%String,Professor:%String,VistingDoctor:%String,ResidentDoctor:%String,EncryptLevel:%String,PatLevel:%String,IsDeath:%String,PreStatus:%String")
{
}

ClassMethod QryVolumeListExecute(ByRef qHandle As %Binary, aArgInput As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aArgInput)
	
	Set aHospID      = $p(aArgInput,"^",1)
	Set aMrTypeID    = $p(aArgInput,"^",2)
	Quit:(aHospID="")||(aMrTypeID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set aMrNo        = $p(aArgInput,"^",3)
	Set aRegNo       = $p(aArgInput,"^",4)
	Set aCardNo      = $p(aArgInput,"^",5)
	Set aPatName     = $p(aArgInput,"^",6)
	Set aPersonalID  = $p(aArgInput,"^",7)
	Set aKeyWord     = $p(aArgInput,"^",8)
	Set aAdmDateFrom = $p(aArgInput,"^",9)
	Set aAdmDateTo   = $p(aArgInput,"^",10)
	Set aDisDateFrom = $p(aArgInput,"^",11)
	Set aDisDateTo   = $p(aArgInput,"^",12)
	Set aLocID       = $p(aArgInput,"^",13)
	Set aWardID      = $p(aArgInput,"^",14)
	
	;Set:aAdmDateFrom["/" aAdmDateFrom=$zdh(aAdmDateFrom,4)
	;Set:aAdmDateFrom["-" aAdmDateFrom=$zdh(aAdmDateFrom,3)
	Set aAdmDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aAdmDateFrom)
	Set aAdmDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aAdmDateTo)
	Set:aAdmDateFrom'="" aAdmDateFrom=+aAdmDateFrom
	;Set:aAdmDateTo["/" aAdmDateTo=$zdh(aAdmDateTo,4)
	;Set:aAdmDateTo["-" aAdmDateTo=$zdh(aAdmDateTo,3)
	Set:aAdmDateTo'="" aAdmDateTo=+aAdmDateTo
	Quit:(aAdmDateFrom="")&&(aAdmDateTo'="") $$$OK
	Quit:(aAdmDateFrom'="")&&(aAdmDateTo="") $$$OK
	;Set:aDisDateFrom["/" aDisDateFrom=$zdh(aDisDateFrom,4)
	;Set:aDisDateFrom["-" aDisDateFrom=$zdh(aDisDateFrom,3)
	Set aDisDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDisDateFrom)
	Set aDisDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDisDateTo)
	Set:aDisDateFrom'="" aDisDateFrom=+aDisDateFrom
	;Set:aDisDateTo["/" aDisDateTo=$zdh(aDisDateTo,4)
	;Set:aDisDateTo["-" aDisDateTo=$zdh(aDisDateTo,3)
	Set:aDisDateTo'="" aDisDateTo=+aDisDateTo
	Quit:(aDisDateFrom="")&&(aDisDateTo'="") $$$OK
	Quit:(aDisDateFrom'="")&&(aDisDateTo="") $$$OK
	
	If aMrNo'="" {
		If $l(aMrNo)=13 { //病案条码
			Set Barcode=aMrNo
			Set BarType=$e(Barcode,1,2)
			If BarType="01" {
				Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
				Quit:MainID="" $$$OK
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",MainID,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			} Else {
				Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
				Quit:VolID="" $$$OK
				
				Set Data=..BuildVolume(VolID)
				Quit:Data="" $$$OK
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		} Else { //病案号
			Set aMrNo=$zcvt(aMrNo,"U")
			Quit:aMrNo="" $$$OK
			Set xMainID=0
			For {
				Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_aMrNo,1,xMainID))
				Quit:xMainID=""
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} ElseIf aRegNo'="" { //登记号
		Set aRegNo=##Class(DHCWMR.SSService.CommonSrv).RegNoCon(aRegNo)
		Quit:aRegNo="" $$$OK
		Set PatientID=$o(^PAPERi("PAPMI_PatNo",aRegNo,0))
		Quit:PatientID="" $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_PatientID,xVolID))
			Quit:xVolID=""
			
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} ElseIf aCardNo'="" { //卡号
		Set PatientID=##Class(DHCWMR.SSService.CommonSrv).GetPatByCardNo(aCardNo)
		Quit:PatientID="" $$$OK
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatientID"," "_PatientID,xVolID))
			Quit:xVolID=""
			
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} ElseIf aPatName'="" {
		Set aPatName=$zcvt(aPatName,"U")  //姓名
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatName"," "_aPatName,xVolID))
			Quit:xVolID=""
			
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		Set PinYin=aPatName  //拼音
		Set xVolID=0,tVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexNameSpell"," "_PinYin,xVolID))
			Quit:xVolID=""
			//fix bug 108625 病案查找输入患者姓名查询出一条记录显示合计为2
			Set tVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexPatName"," "_PinYin,tVolID))
			Quit:(xVolID'="")&&(xVolID=tVolID)
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} ElseIf aPersonalID'="" {  //证件号码、身份证号
		Set xVolID=0
		For {
			Set xVolID=$o(^DHCWMR.SS.VolumeI("VP","IndexIdentityCode"," "_aPersonalID,xVolID))
			Quit:xVolID=""
			
			Set Data=..BuildVolume(xVolID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} ElseIf aKeyWord'="" {  //工作单位、现住址、户籍地址、联系人
		If aAdmDateFrom'="" {
			Set aQueryIndex="IndexBuildDate"
			Set aDateFrom=aAdmDateFrom
			Set aDateTo=aAdmDateTo
		} Else {
			Set aQueryIndex="IndexDischDate"
			Set aDateFrom=aDisDateFrom
			Set aDateTo=aDisDateTo
		}
		Set xStepCode=""
		For {
			Set xStepCode=$o(^DHCWMR.SS.VolumeI(aQueryIndex,xStepCode))
			Quit:xStepCode=""
			Continue:(xStepCode["C")  //临时病历过滤掉
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.VolumeI(aQueryIndex,xStepCode,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI(aQueryIndex,xStepCode,xDate,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} Else {}
	
	Quit $$$OK
}

ClassMethod QryVolumeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolumeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeListExecute ]
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

ClassMethod BuildVolume(aVolID As %String) As %List
{
	Set return=""
	Quit:aVolID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return  //卷无效
	Set objMain=objVol.SVMainDr
	Quit:'$IsObject(objMain) return
	Set MainID = objMain.%Id()
	Quit:objMain.SMIsActive'=1 return  //病案无效
	Quit:'$IsObject(objMain.SMMrType) return
	Quit:objMain.SMMrType.%Id()'=aMrTypeID return  //病案类型不一致
	Quit:'$IsObject(objMain.SMMrType.MTMrClass) return
	
	Set MrClass=objMain.SMMrType.MTMrClass.MCCode
	If (aAdmDateFrom'="")||(aAdmDateTo'="") {
		Set BuildDate=objVol.SVBuildDate
		Quit:BuildDate="" return
		Quit:(aAdmDateFrom'="")&&(aAdmDateFrom>BuildDate) return
		Quit:(aAdmDateTo'="")&&(aAdmDateTo<BuildDate) return
	}
	If (aDisDateFrom'="")||(aDisDateTo'="") {
		Set DischDate=objVol.SVDischDate
		Quit:DischDate="" return
		Quit:(aDisDateFrom'="")&&(aDisDateFrom>DischDate) return
		Quit:(aDisDateTo'="")&&(aDisDateTo<DischDate) return
	}
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	;Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时") //fix bug 6537 by pylian 2015-01-21
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Set AdmLoc=$p(VolAdmStr,",",3)
	Set AdmWard=$p(VolAdmStr,",",4)
	Set AdmHosp=$p(VolAdmStr,",",5)
	If (AdmHosp'="")&&(aHospID'="") {
		Quit:(aHospID'[(","_AdmHosp_",")) return  //检查院区是否符合
	}
	Quit:(aLocID'="")&&(aLocID'=AdmLoc) return
	Quit:(aWardID'="")&&(aWardID'=AdmWard) return
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	Set Age=objVolAdm.VPAge
	Set HomeAddress=objVolAdm.VPHomeAddress  //现住址
	Set RegAddress=objVolAdm.VPRegAddress    //户籍地址
	Set Company=objVolAdm.VPCompany          //工作单位
	Set RelativeName=objVolAdm.VPRelativeName  //联系人姓名
	If aKeyWord'="" {
		Quit:(Company'[aKeyWord)&&(HomeAddress'[aKeyWord)&&(RegAddress'[aKeyWord)&&(RelativeName'[aKeyWord) return
	}
	//update by zhouruimeng 2016-03-15 取首次回收的日期
	Set BackDateTime=##class(DHCWMR.SSService.VolumeSrv).GetBackDate(EpisodeID,"RC")
	Set BackDate=$p(BackDateTime," ",1)
	;Set BackDate=objVol.SVBackDate
	;Set:BackDate'="" BackDate=$zd(BackDate,3)
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set AdmLoc=objVolAdm.VPAdmitDept
	Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	Set AdmWard=objVolAdm.VPAdmitWard
	Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
	Set DischDept=objVolAdm.VPDischDept
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
	Set DischWard=objVolAdm.VPDischWard
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDept'="" AdmLoc=DischDept
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWard'="" AdmWard=DischWard
	Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	Set AdmDate=objVolAdm.VPAdmitDate
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	Set IsDeath = objVolAdm.VPIsDeath
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set ChiefProfessor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.056",.ArrGlossary)	//科主任签名
	Set Professor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.137",.ArrGlossary)	//主任（副主任）医师签名
	Set VistingDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.138",.ArrGlossary)	//主治医师签名
	Set ResidentDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.141",.ArrGlossary)	//住院医师签名
	If (MrClass="O")  //门诊就诊科室和日期为初诊科室和初诊日期
	{
		Set FirstLoc=objMain.SMFirstLoc
		Set AdmLocDesc=$p($g(^CTLOC(+FirstLoc)),"^",2)
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set FirstDate=objMain.SMFirstDate
		;Set AdmDate=$zd(FirstDate,3)
		Set AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FirstDate)
	}
	//add by zhouruimeng 2016-03-15 显示病历的上一个状态
	Set PreStatus=##class(DHCWMR.SSService.VolStatusSrv).GetPremStatus(EpisodeID)
	
	Set return=$lb(MainID,aVolID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age,IdentityCode)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(Company,HomeAddress,RegAddress,RelativeName)
	Set return=return_$lb(ChiefProfessor,Professor,VistingDoctor,ResidentDoctor)
	Set return=return_$lb(EncryptLevel,PatLevel,IsDeath,PreStatus)
	Quit return
}

}
