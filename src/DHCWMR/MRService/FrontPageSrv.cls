/// 名称: DHCWMR.MRService.FrontPageSrv
/// 描述: 住院病案首页服务
/// 编写者：zhufei
/// 编写日期: 2015-08-27
Class DHCWMR.MRService.FrontPageSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存出院首页记录
/// Table：       DHCWMR.MR.FrontPage
/// Input：       aInput ：出院首页记录="就诊号^病人ID^住院号^医院ID^病案类型^出院日期^出院时间^归档日期^归档时间^归档标志^编码日期^编码时间^编码标示"
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).Save()
ClassMethod Save(aInput As %String) As %String
{
	New (aInput)
	Set return=0
	Quit:(aInput="") return
	
	Set MRFPageID=""
	Set EpisodeID=$p(aInput,"^",1)
	Set PatientID=$p(aInput,"^",2)
	Set ADMNo=$p(aInput,"^",3)
	Set HospID=$p(aInput,"^",4)
	Set MRType=$p(aInput,"^",5)
	Set DischDate=$p(aInput,"^",6)
	Set DischTime=$p(aInput,"^",7)
	Set FilingDate=$p(aInput,"^",8)
	Set FilingTime=$p(aInput,"^",9)
	Set IsFiling=+$p(aInput,"^",10)
	Set CodingDate=$p(aInput,"^",11)
	Set CodingTime=$p(aInput,"^",12)
	Set IsCoding=+$p(aInput,"^",13)
	Set IsError=+$p(aInput,"^",14)
	
	If EpisodeID'="" {
		//根据就诊号索引主记录
		Set MRFPageID=$o(^DHCWMR.MR.FrontPageI("IndexEpisodeID"," "_EpisodeID,0))
	} ElseIf ADMNo'="" {
		//根据住院号索引主记录
		Set MRFPageID=$o(^DHCWMR.MR.FrontPageI("IndexADMNo"," "_ADMNo,0))
	} Else {
		//如果无对应就诊记录，如何处理？
	}
	
	If MRFPageID="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)=""
		Set $p(InputStr,"^",2)=EpisodeID
		Set $p(InputStr,"^",3)=PatientID
		Set $p(InputStr,"^",4)=ADMNo
		Set $p(InputStr,"^",5)=HospID
		Set $p(InputStr,"^",6)=MRType
		Set $p(InputStr,"^",7)=DischDate
		Set $p(InputStr,"^",8)=DischTime
		Set $p(InputStr,"^",9)=FilingDate
		Set $p(InputStr,"^",10)=FilingTime
		Set $p(InputStr,"^",11)=IsFiling
		Set $p(InputStr,"^",12)=CodingDate
		Set $p(InputStr,"^",13)=CodingTime
		Set $p(InputStr,"^",14)=IsCoding
		Set $p(InputStr,"^",15)=IsError
		Set return=##Class(DHCWMR.MR.FrontPage).Update(InputStr)
	} Else {
		Set objFp=##class(DHCWMR.MR.FrontPage).GetObjById(MRFPageID)
		Quit:'$IsObject(objFp) return
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=objFp.%Id()
		Set $p(InputStr,"^",2)=objFp.FPEpisodeID
		Set $p(InputStr,"^",3)=objFp.FPPatientID
		Set $p(InputStr,"^",4)=objFp.FPADMNo
		Set $p(InputStr,"^",5)=objFp.FPHospID
		Set $p(InputStr,"^",6)=objFp.FPMRType
		Set $p(InputStr,"^",7)=objFp.FPDischDate
		Set $p(InputStr,"^",8)=objFp.FPDischTime
		Set $p(InputStr,"^",9)=objFp.FPFilingDate
		Set $p(InputStr,"^",10)=objFp.FPFilingTime
		Set $p(InputStr,"^",11)=objFp.FPIsFiling
		Set $p(InputStr,"^",12)=objFp.FPCodingDate
		Set $p(InputStr,"^",13)=objFp.FPCodingTime
		Set $p(InputStr,"^",14)=objFp.FPIsCoding
		Set $p(InputStr,"^",15)=IsError
		
		If CodingDate'="" {
			Set:CodingDate["-" CodingDate=$zdh(CodingDate,3)
			Set:CodingTime[":" CodingTime=$zth(CodingTime,1)
			Set $p(InputStr,"^",12)=+CodingDate
			Set $p(InputStr,"^",13)=+CodingTime
			Set $p(InputStr,"^",14)=+IsCoding
		} ElseIf FilingDate="" {
			Set:FilingDate["-" FilingDate=$zdh(FilingDate,3)
			Set:FilingTime[":" FilingTime=$zth(FilingTime,1)
			Set $p(InputStr,"^",9)=+FilingDate
			Set $p(InputStr,"^",10)=+FilingTime
			Set $p(InputStr,"^",11)=+IsFiling
		} Else {
			Set:DischDate["-" DischDate=$zdh(DischDate,3)
			Set:DischTime[":" DischTime=$zth(DischTime,1)
			Set $p(InputStr,"^",7)=+DischDate
			Set $p(InputStr,"^",8)=+DischTime
		}
		Set:EpisodeID'="" $p(InputStr,"^",2)=EpisodeID
		Set:PatientID'="" $p(InputStr,"^",3)=PatientID
		Set:ADMNo'="" $p(InputStr,"^",4)=ADMNo
		Set:HospID'="" $p(InputStr,"^",5)=HospID
		Set:MRType'="" $p(InputStr,"^",6)=MRType
		Set return=##Class(DHCWMR.MR.FrontPage).Update(InputStr)
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  诊断信息初始化（删除当前就诊下的所有诊断记录）
/// Table：       DHCWMR.MR.FrontPageICD
/// Input：       aMRFPageID ：主记录ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).InitICD(1)
ClassMethod InitICD(aMRFPageID As %String) As %String
{
	New (aMRFPageID)
	Set return=0
	Quit:(aMRFPageID="") return
	
	Set return=1
	Set xSub=0
	For {
		Set xSub=$o(^DHCWMR.MR.FrontPageD(aMRFPageID,"ICD",xSub))
		Quit:xSub=""
		Set flg=##class(DHCWMR.MR.FrontPageICD).DeleteById(aMRFPageID_"||"_xSub)
		Set:flg<1 return=-1
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存诊断信息
/// Table：       DHCWMR.MR.FrontPageICD
/// Input：       aInputStr ：诊断信息="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).SaveICD()
ClassMethod SaveICD(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MRFPageID=$p(aInputStr,"^",1)
	Set FDType=$p(aInputStr,"^",3)
	
	If FDType["主要诊断" {
		Set FDTypeCode="21"
	} ElseIf (FDType["次要诊断")||(FDType["其他诊断")||(FDType["其它诊断") {
		Set FDTypeCode="22"
	} ElseIf (FDType'["中医")&&((FDType["门（急）诊诊断")||(FDType["门(急)诊诊断")||(FDType["门急诊诊断")) {
		Set FDTypeCode="23"
	} ElseIf FDType["入院诊断" {
		Set FDTypeCode="24"
	} ElseIf FDType["病理诊断" {
		Set FDTypeCode="25"
	} ElseIf (FDType["损伤、中毒的外部原因")||(FDType["损伤")||(FDType["中毒") {
		Set FDTypeCode="26"
	} ElseIf (FDType["医院感染诊断")||(FDType["医院感染")||(FDType["院感") {
		Set FDTypeCode="27"
	} ElseIf FDType["主病" {
		Set FDTypeCode="28"
	} ElseIf FDType["主症" {
		Set FDTypeCode="29"
	} ElseIf (FDType["中医")&&((FDType["门（急）诊诊断")||(FDType["门(急)诊诊断")||(FDType["门急诊诊断")) {
		Set FDTypeCode="30"
	} Else {
		Set ErrCode="-202"
		Set ErrText="诊断类型对照错误,诊断类型："_FDType
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICD("""_aInputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,MRFPageID)
		Quit return
	}
	Quit:(MRFPageID="")||(FDTypeCode="") return
	
	Set TypeIndex=$o(^DHCWMR.MR.FrontPageI("ICD","IndexTypeIndex",MRFPageID," "_FDTypeCode,""),-1)
	Set TypeIndex=(+TypeIndex)+1
	Set SerialNumber=$o(^DHCWMR.MR.FrontPageI("ICD","IndexSerialNumber",MRFPageID,""),-1)
	Set SerialNumber=(+SerialNumber)+1
	
	Set $p(aInputStr,"^",3)=FDTypeCode
	Set $p(aInputStr,"^",4)=TypeIndex
	Set $p(aInputStr,"^",5)=SerialNumber
	Set return=##Class(DHCWMR.MR.FrontPageICD).Update(aInputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  手术信息初始化（删除当前就诊下的所有手术记录）
/// Table：       DHCWMR.MR.FrontPageOper
/// Input：       aMRFPageID ：主记录ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).InitOper(1)
ClassMethod InitOper(aMRFPageID As %String) As %String
{
	New (aMRFPageID)
	Set return=0
	Quit:(aMRFPageID="") return
	
	Set return=1
	Set xSub=0
	For {
		Set xSub=$o(^DHCWMR.MR.FrontPageD(aMRFPageID,"OPER",xSub))
		Quit:xSub=""
		Set flg=##class(DHCWMR.MR.FrontPageOper).DeleteById(aMRFPageID_"||"_xSub)
		Set:flg<1 return=-1
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存手术信息
/// Table：       DHCWMR.MR.FrontPageOper
/// Input：       aInputStr ：手术信息="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).SaveOper()
ClassMethod SaveOper(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MRFPageID=$p(aInputStr,"^",1)
	Set FOType=$p(aInputStr,"^",3)
	
	If FOType["手术" {
		Set FOTypeCode="41"
	} ElseIf FOType["操作" {
		Set FOTypeCode="42"
	} Else {
		Set ErrCode="-302"
		Set ErrText="手术类型对照错误,手术类型："_FDType
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveOper("""_aInputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,MRFPageID)
		Quit return
	}
	Quit:(MRFPageID="")||(FOTypeCode="") return
	
	Set TypeIndex=$o(^DHCWMR.MR.FrontPageI("OPER","IndexTypeIndex",MRFPageID," "_FOTypeCode,""),-1)
	Set TypeIndex=(+TypeIndex)+1
	Set SerialNumber=$o(^DHCWMR.MR.FrontPageI("OPER","IndexSerialNumber",MRFPageID,""),-1)
	Set SerialNumber=(+SerialNumber)+1
	
	Set $p(aInputStr,"^",3)=FOTypeCode
	Set $p(aInputStr,"^",4)=TypeIndex
	Set $p(aInputStr,"^",5)=SerialNumber
	Set return=##Class(DHCWMR.MR.FrontPageOper).Update(aInputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存费用信息
/// Table：       DHCWMR.MR.FrontPageFees
/// Input：       aInputStr ：费用信息="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).SaveFees()
ClassMethod SaveFees(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MRFPageID=$p(aInputStr,"^",1)
	Quit:(MRFPageID="") return
	Set ChildSub=$o(^DHCWMR.MR.FrontPageD(MRFPageID,"FEES",0))
	Set $p(aInputStr,"^",2)=ChildSub
	
	Set return=##Class(DHCWMR.MR.FrontPageFees).Update(aInputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存病人信息
/// Table：       DHCWMR.MR.FrontPageAdm
/// Input：       aInputStr ：病人信息="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).SaveAdm()
ClassMethod SaveAdm(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MRFPageID=$p(aInputStr,"^",1)
	Quit:(MRFPageID="") return
	Set ChildSub=$o(^DHCWMR.MR.FrontPageD(MRFPageID,"ADM",0))
	Set $p(aInputStr,"^",2)=ChildSub
	
	Set return=##Class(DHCWMR.MR.FrontPageAdm).Update(aInputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存附页内容及扩展内容
/// Table：       DHCWMR.MR.FrontPageAdd
/// Input：       aInputStr ：附页内容及扩展内容="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).SaveAdd()
ClassMethod SaveAdd(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MRFPageID=$p(aInputStr,"^",1)
	Set PACode=$p(aInputStr,"^",3)
	Set PACode=$tr(PACode,".","")
	Set PACode=$zcvt(PACode,"U")
	Quit:(MRFPageID="")||(PACode="") return
	Set ChildSub=$o(^DHCWMR.MR.FrontPageI("ADD","IndexCode",MRFPageID," "_PACode,0))
	Set $p(aInputStr,"^",2)=ChildSub
	
	Set return=##Class(DHCWMR.MR.FrontPageAdd).Update(aInputStr,"^")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  重症监护信息初始化（删除当前就诊下的所有重症监护记录）
/// Table：       DHCWMR.MR.FrontPageICU
/// Input：       aMRFPageID ：主记录ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).InitICU()
ClassMethod InitICU(aMRFPageID As %String) As %String
{
	New (aMRFPageID)
	Set return=0
	Quit:(aMRFPageID="") return
	
	Set return=1
	Set xSub=0
	For {
		Set xSub=$o(^DHCWMR.MR.FrontPageD(aMRFPageID,"ICU",xSub))
		Quit:xSub=""
		Set flg=##class(DHCWMR.MR.FrontPageICU).DeleteById(aMRFPageID_"||"_xSub)
		Set:flg<1 return=-1
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-09-16
/// Description:  保存重症监护信息
/// Table：       DHCWMR.MR.FrontPageICU
/// Input：       aInputStr ：重症监护信息="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.FrontPageSrv).SaveICU()
ClassMethod SaveICU(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set MRFPageID=$p(aInputStr,"^",1)
	Set FIType=$p(aInputStr,"^",3)
	
	Set FITypeCode="50"
	Quit:(MRFPageID="")||(FITypeCode="") return
	
	Set TypeIndex=$o(^DHCWMR.MR.FrontPageI("ICU","IndexTypeIndex",MRFPageID," "_FITypeCode,""),-1)
	Set TypeIndex=(+TypeIndex)+1
	Set SerialNumber=$o(^DHCWMR.MR.FrontPageI("ICU","IndexSerialNumber",MRFPageID,""),-1)
	Set SerialNumber=(+SerialNumber)+1
	
	Set $p(aInputStr,"^",3)=FITypeCode
	Set $p(aInputStr,"^",4)=TypeIndex
	Set $p(aInputStr,"^",5)=SerialNumber
	Set return=##Class(DHCWMR.MR.FrontPageICU).Update(aInputStr,"^")
	Quit return
}

}
