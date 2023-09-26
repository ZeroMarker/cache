/// 名称: DHCWMR.MRService.ImportDataByTR
/// 描述: 导入同仁编目数据接口服务
/// 编写者：zhufei
/// 编写日期: 2015-08-27
Class DHCWMR.MRService.ImportDataByTR Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCWMR.MRService.ImportDataByTR).Test()
ClassMethod Test()
{
	New
	Set indT=0
	For {
		Set indT=$o(^TMP("MRFPage",indT))
		Quit:indT=""
		
		Set PatInfo=$g(^TMP("MRFPage",indT,1))
		Set DiagInfo=$g(^TMP("MRFPage",indT,2))
		Set OperInfo=$g(^TMP("MRFPage",indT,3))
		Set FeeInfo=$g(^TMP("MRFPage",indT,4))
		Set OtherInfo=$g(^TMP("MRFPage",indT,5))
		Set flg=..Service(PatInfo, DiagInfo, OperInfo, FeeInfo, OtherInfo)
		If flg>0 {
			Set obj=##class(DHCWMR.MR.FrontPage).GetObjById(flg)
			If $IsObject(obj) {
				Kill:obj.FPEpisodeID'="" ^TMP("MRFPage",indT)
			}
			w flg,!
		}
	}
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2015-09-17
/// Description:  导入同仁编目数据接口服务
/// Table：       
/// Input：       aPatInfo ：病人信息="..."
///               aDiagInfo ：诊断信息="..."
///               aOperInfo ：手术信息="..."
///               aFeeInfo ：费用信息="..."
///               aOtherInfo ：其他信息="..."
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCWMR.MRService.ImportDataByTR).Service()
ClassMethod Service(aPatInfo As %String, aDiagInfo As %String, aOperInfo As %String, aFeeInfo As %String, aOtherInfo As %String) As %String
{
	New (aPatInfo, aDiagInfo, aOperInfo, aFeeInfo, aOtherInfo)
	Set return=0
	Quit:(aPatInfo="")||(aDiagInfo="") return
	/*
	Set indT=$i(^TMP("MRFPage"))
	Set ^TMP("MRFPage",indT,1)=aPatInfo
	Set ^TMP("MRFPage",indT,2)=aDiagInfo
	Set ^TMP("MRFPage",indT,3)=aOperInfo
	Set ^TMP("MRFPage",indT,4)=aFeeInfo
	Set ^TMP("MRFPage",indT,5)=aOtherInfo
	Quit return
	*/
	Set $ZT="ServiceErr"
	
	Set PatName=$p(aPatInfo,"^",1)
	Set Sex=$p(aPatInfo,"^",2)
	Set Sex=$s(Sex=1:"男",Sex=2:"女",Sex=0:"未知",Sex=9:"未说明",1:"")
	Set Birthday=$p(aPatInfo,"^",3)        //2015-07-01
	Set MrNo=$p(aPatInfo,"^",39)
	Set AdmitDateTime=$p(aPatInfo,"^",41)  //2015-07-01 08:35:00
	Set AdmitDate=$p(AdmitDateTime," ",1)
	Set:AdmitDate'="" AdmitDate=$zdh(AdmitDate,3)
	Set AdmitTime=$p(AdmitDateTime," ",2)
	Set:AdmitTime'="" AdmitTime=$zth(AdmitTime,1)
	Set DischDateTime=$p(aPatInfo,"^",45)  //2015-07-06 14:06:00
	Set DischDate=$p(DischDateTime," ",1)
	Set:DischDate'="" DischDate=$zdh(DischDate,3)
	Set DischTime=$p(DischDateTime," ",2)
	Set:DischTime'="" DischTime=$zth(DischTime,1)
	Set EpisodeID=..GetEpisodeID(MrNo,PatName,Sex,Birthday,AdmitDate,DischDate)
	If EpisodeID="" {
		Set PatientID=""
		Set ADMNo=MrNo_"!"_PatName_"!"_Sex_"!"_Birthday_"!"_AdmitDateTime_"!"_DischDateTime
		Set HospID=""
		Set IsError=1
	} Else {
		Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
		Set ADMNo=$p($g(^PAADM(EpisodeID)),"^",81)
		Set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
		Set HospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
		Set IsError=0
	}
	
	Set return="-100^保存主表记录错误"
	Set InputStr=""
	Set $p(InputStr,"^",1)=EpisodeID
	Set $p(InputStr,"^",2)=PatientID
	Set $p(InputStr,"^",3)=ADMNo
	Set $p(InputStr,"^",4)=HospID
	Set $p(InputStr,"^",5)="W"
	Set $p(InputStr,"^",6)=DischDate
	Set $p(InputStr,"^",7)=DischTime
	Set $p(InputStr,"^",8)=DischDate
	Set $p(InputStr,"^",9)=DischTime
	Set $p(InputStr,"^",10)=1
	Set $p(InputStr,"^",11)=DischDate
	Set $p(InputStr,"^",12)=DischTime
	Set $p(InputStr,"^",13)=1
	Set $p(InputStr,"^",14)=IsError
	Set MRFPageID=##class(DHCWMR.MRService.FrontPageSrv).Save(InputStr)
	If MRFPageID<1 {
		Set ErrCode="-100"
		Set ErrText="主记录更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).Save("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,"")
		Quit return
	}
	
	Set return="-200^保存诊断信息错误"
	Set flg=..SaveDiagInfo(MRFPageID,aDiagInfo)
	Quit:(+flg)<1 return
	
	Set return="-300^保存手术信息错误"
	Set flg=..SaveOperInfo(MRFPageID,aOperInfo)
	Quit:(+flg)<0 return
	
	Set return="-400^保存病人信息错误"
	Set flg=..SavePatInfo(MRFPageID,aPatInfo,aOtherInfo,aDiagInfo)
	Quit:(+flg)<1 return
	
	Set return="-500^保存费用信息错误"
	Set flg=..SaveFeeInfo(MRFPageID,aFeeInfo)
	Quit:(+flg)<0 return
	
	Set return="-600^保存重症监护信息错误"
	Set flg=..SaveICUInfo(MRFPageID,aFeeInfo)
	Quit:(+flg)<0 return
	
	Set return=MRFPageID
	Quit return
	
ServiceErr
	Set ErrCode="-999"
	Set ErrText="程序运行错误"
	Set Error=$ZError
	Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,"")
	Quit "-999^"_$ZError
}

ClassMethod SaveDiagInfo(aMRFPageID As %String, aDiagInfo As %String) As %String
{
	New (aMRFPageID,aDiagInfo)
	Set return=0
	Quit:aDiagInfo="" return
	
	//初始化诊断记录
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).InitICD(aMRFPageID)
	If flg<0 {
		Set ErrCode="-201"
		Set ErrText="初始化诊断记录错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).InitICD("""_aMRFPageID_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
	}
	
	//ABDS = ABDS & "$" & ABD01C & "^" & ABD01N & "^" & ABD03C
	//DiagInfo = ABA01C & "^" & ABA01N & "!" & ABC01C & "^" & ABC01N & "^" & ABC03C & "!" & ABDS & "!" & ABF01C & "^" & ABF01N & "^" & ABF04 & "!" & ABF02C & "^" & ABF03C & "!" & ABG01C & "^" & ABG01N & "^" & ABH01C & "^" & ABH0201C & "^" & ABH0202C & "^" & ABH0203C & "^" & ABH03C
	
	Kill arrDiagnos
	Set tmp=$p(aDiagInfo,"!",1)
	Set ICD10=$p(tmp,"^",1)
	Set ICDDesc=$p(tmp,"^",2)
	Set arrDiagnos(1,1)=$lb("门（急）诊诊断名称",ICDDesc,ICD10,"","","","")
	
	Set tmp=$p(aDiagInfo,"!",2)
	Set ICD10=$p(tmp,"^",1)
	Set ICDDesc=$p(tmp,"^",2)
	Set AdmitCond=$p(tmp,"^",3)
	set inHospDesc=##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC002002",AdmitCond)
	Set arrDiagnos(2,1)=$lb("主要诊断",ICDDesc,ICD10,inHospDesc,AdmitCond,"","")
	
	Set tmpList=$p(aDiagInfo,"!",3)
	For ind=1:1:$l(tmpList,"$") {
		Set tmp=$p(tmpList,"$",ind)
		Continue:tmp=""
		Set ICD10=$p(tmp,"^",1)
		Set ICDDesc=$p(tmp,"^",2)
		Set AdmitCond=$p(tmp,"^",3)
		set inHospDesc=##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC002002",AdmitCond)
		Set arrDiagnos(3,ind)=$lb("其他诊断",ICDDesc,ICD10,inHospDesc,AdmitCond,"","")
	}
	
	Set tmp=$p(aDiagInfo,"!",4)
	Set ICD10=$p(tmp,"^",1)
	Set ICDDesc=$p(tmp,"^",2)
	Set BLH=$p(tmp,"^",3)         //病理号
	Set ZGZDYJRC=$p(tmp,"^",4)    //最高诊断依据代码
	Set FHCDRC=$p(tmp,"^",5)      //分化程度编码
	Set arrDiagnos(4,1)=$lb("病理诊断",ICDDesc,ICD10,"","","","")
	
	Set tmp=$p(aDiagInfo,"!",6)
	Set ICD10=$p(tmp,"^",1)
	Set ICDDesc=$p(tmp,"^",2)
	Set arrDiagnos(5,1)=$lb("损伤、中毒的外部原因",ICDDesc,ICD10,"","","","")
	
	Set tmp=$p(aDiagInfo,"!",7)
	Set ZLFQRC=$p(tmp,"^",1)      //肿瘤分期是否不详
	Set ZLFQT=$p(tmp,"^",2)       //肿瘤分期 T
	Set ZLFQN=$p(tmp,"^",3)       //肿瘤分期 N
	Set ZLFQM=$p(tmp,"^",4)       //肿瘤分期 M
	Set ZLFQJB=$p(tmp,"^",5)      //0～Ⅳ肿瘤分期
	
	Set xType=""
	For {
		Set xType=$o(arrDiagnos(xType))
		Quit:xType=""
		Set xInd=0
		For {
			Set xInd=$o(arrDiagnos(xType,xInd))
			Quit:xInd=""
			Set tmp=$g(arrDiagnos(xType,xInd))
			Continue:tmp=""
			Continue:$list(tmp,2)=""
			Set InputStr=""
			Set $p(InputStr,"^",1)=aMRFPageID
			Set $p(InputStr,"^",2)=""
			Set $p(InputStr,"^",3)=$list(tmp,1)  //TypeDesc
			Set $p(InputStr,"^",4)=""
			Set $p(InputStr,"^",5)=""
			Set $p(InputStr,"^",6)=$list(tmp,2)  //ICDDesc
			Set $p(InputStr,"^",7)=$list(tmp,3)  //ICD10
			Set $p(InputStr,"^",8)=$list(tmp,4)  //AdmitCondDesc
			Set $p(InputStr,"^",9)=$list(tmp,5)  //AdmitCondCode
			Set $p(InputStr,"^",10)=$list(tmp,6) //DischCondDesc
			Set $p(InputStr,"^",11)=$list(tmp,7) //DischCondCode
			Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICD(InputStr)
			If flg<0 {
				Set ErrCode="-200"
				Set ErrText="诊断记录更新错误"
				Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICD("""_InputStr_""")"
				Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
				Set return=-1
			}
		}
	}
	Kill arrDiagnos
	
	Quit:return<0 return
	
	Set return=1
	Quit return
}

ClassMethod SaveOperInfo(aMRFPageID As %String, aOperInfo As %String) As %String
{
	New (aMRFPageID,aOperInfo)
	Set return=0
	Quit:aOperInfo="" return
	
	//初始化手术记录
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).InitOper(aMRFPageID)
	If flg<0 {
		Set ErrCode="-301"
		Set ErrText="初始化手术记录错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).InitOper("""_aMRFPageID_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
	}
	
	//ACA09S = ACA09S & "$" & ACA0901C & "@" & ACA0901N & "@" & ACA0903C
	//OperInfo = OperInfo & "!" & ACA01 & "^" & ACA11 & "^" & ACA02 & "^" & ACA03 & "^" & ACA04 & "^" & ACA06C & "^" & ACA07C & "^" & ACA08 & "^" & ACA10C & "^" & ACA09S
	
	Kill arrOperation
	Set POIndex=0
	For ind=1:1:$l(aOperInfo,"!") {
		Set tmp=$p(aOperInfo,"!",ind)
		Continue:tmp=""
		Set SttDateTime=$p(tmp,"^",1)
		Set SttDate=$p(SttDateTime," ",1)
		Set SttTime=$p(SttDateTime," ",2)
		Set EndDateTime=$p(tmp,"^",2)
		Set EndDate=$p(EndDateTime," ",1)
		Set EndTime=$p(EndDateTime," ",2)
		Set OperatorTxt=$p(tmp,"^",3)
		Set Assistant1Txt=$p(tmp,"^",4)
		Set Assistant2Txt=$p(tmp,"^",5)
		Set NarcosisTypeCode=$p(tmp,"^",6)
		Set CutTypeCode=$p(tmp,"^",7)
		Set NarcosisDocTxt=$p(tmp,"^",8)
		Set OperLevelCode=$p(tmp,"^",9)
		Set tmpList=$p(tmp,"^",10)
		For indO=1:1:$l(tmpList,"$") {
			Set tmpO=$p(tmpList,"$",indO)
			Continue:tmpO=""
			Set ICD10=$p(tmpO,"@",1)
			Set ICDDesc=$p(tmpO,"@",2)
			Set TypeCode=$p(tmpO,"@",3)
			Set TypeDesc=$s(TypeCode=1:"手术",TypeCode=2:"操作",1:"")
			s OperLevel=##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC003002",OperLevelCode)
			s NarcosisType=##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC003004",NarcosisTypeCode)
			s CutType=##class(DHCWMR.MRService.FPRangeSrv).GetDescByCode("RC003005",CutTypeCode)
			Set POIndex=POIndex+1	
			;Set arrOperation(1,POIndex)=$lb(TypeDesc,ICDDesc,ICD10,SttDate,OperLevel,OperLevelCode,OperatorTxt,Assistant1Txt,Assistant2Txt,NarcosisType,NarcosisTypeCode,CutType,CutTypeCode,NarcosisDocTxt)
			Set arrOperation(1,POIndex)=$lb(TypeDesc,ICDDesc,ICD10,SttDateTime,OperLevel,OperLevelCode,OperatorTxt,Assistant1Txt,Assistant2Txt,NarcosisType,NarcosisTypeCode,CutType,CutTypeCode,NarcosisDocTxt,EndDateTime)
		}
	}
	
	Set xType=""
	For {
		Set xType=$o(arrOperation(xType))
		Quit:xType=""
		Set xInd=0
		For {
			Set xInd=$o(arrOperation(xType,xInd))
			Quit:xInd=""
			Set tmp=$g(arrOperation(xType,xInd))
			Continue:tmp=""
			Continue:$list(tmp,2)=""
			Set InputStr=""
			Set $p(InputStr,"^",1)=aMRFPageID
			Set $p(InputStr,"^",2)=""
			Set $p(InputStr,"^",3)=$list(tmp,1)    //TypeDesc
			Set $p(InputStr,"^",4)=""
			Set $p(InputStr,"^",5)=""
			Set $p(InputStr,"^",6)=$list(tmp,2)    //ICDDesc
			Set $p(InputStr,"^",7)=$list(tmp,3)    //ICD10
			Set $p(InputStr,"^",8)=$list(tmp,4)    //SttDate
			Set $p(InputStr,"^",9)=$list(tmp,5)    //OperLevelDesc
			Set $p(InputStr,"^",10)=$list(tmp,6)   //OperLevelCode
			Set $p(InputStr,"^",11)=$list(tmp,7)   //OperatorTxt
			Set $p(InputStr,"^",12)=$list(tmp,8)   //Assistant1Txt
			Set $p(InputStr,"^",13)=$list(tmp,9)   //Assistant2Txt
			Set $p(InputStr,"^",14)=$list(tmp,10)  //NarcosisTypeDesc
			Set $p(InputStr,"^",15)=$list(tmp,11)  //NarcosisTypeCode
			Set $p(InputStr,"^",16)=$list(tmp,12)  //CutTypeDesc
			Set $p(InputStr,"^",17)=$list(tmp,13)  //CutTypeCode
			Set $p(InputStr,"^",18)=$list(tmp,14)  //NarcosisDocTxt
			Set $p(InputStr,"^",26)=$list(tmp,15)  //EndDateTime
			Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveOper(InputStr)
			If flg<0 {
				Set ErrCode="-300"
				Set ErrText="手术记录更新错误"
				Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveOper("""_InputStr_""")"
				Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
				Set return=-1
			}
		}
	}
	Kill arrOperation
	
	Quit:return<0 return
	
	Set return=1
	Quit return
}

ClassMethod SavePatInfo(aMRFPageID As %String, aPatInfo As %String, aOtherInfo As %String, aDiagInfo As %String) As %String
{
	New (aMRFPageID,aPatInfo,aOtherInfo,aDiagInfo)
	Set return=0
	Quit:aPatInfo="" return
	
	//PatInfo = AAA01 & "^" & AAA02C & "^" & AAA03 & "^" & AAA04 & "^" & AAA05C & "^" & AAA40 & "^" & AAA42 & "^" & AAA06C & "^" & AAA07 & "^" & AAA08C & "^" & AAA09 & "^" & AAA10 & "^" & AAA11 & "^" & AAA43 & "^" & AAA44 & "^" & AAA45 & "^" & AAA46 & "^" & AAA47 & "^" & AAA13C & "^" & AAA33C & "^" & AAA14C & "^" & AAA48 & "^" & AAA49 & "^" & AAA50 & "^" & AAA16C & "^" & AAA36C & "^" & AAA51 & "^" & AAA17C & "^" & AAA18C & "^" & AAA19 & "^" & AAA20 & "^" & AAA21C & "^" & AAA22 & "^" & AAA23C & "^" & AAA24 & "^" & AAA25 & "^" & AAA26C & "^" & AAA27 & "^" & AAA28 & "^" & AAA29 & "^" & AAB01 & "^" & AAB02C & "^" & AAB03 & "^" & AAB06C & "^" & AAC01 & "^" & AAC02C & "^" & AAC03 & "^" & AAC04 & "^" & AAD01C
	//OtherInfo = AEB02C & "^" & AEB01 & "^" & AED01C & "^" & AED02 & "^" & AED03 & "^" & AED04 & "^" & AEE01 & "^" & AEE02 & "^" & AEE03 & "^" & AEE11 & "^" & AEE09 & "^" & AEE04 & "^" & AEE05 & "^" & AEE07 & "^" & AEE08 & "^" & AEE10 & "^" & AEG01C & "^" & AEG02C & "^" & AEG04 & "^" & AEG05 & "^" & AEG06 & "^" & AEG07 & "^" & AEG08 & "^" & AEJ01 & "^" & AEJ02 & "^" & AEJ03 & "^" & AEJ04 & "^" & AEJ05 & "^" & AEJ06 & "^" & AEKS & "^" & AEL01 & "^" & AENS & "^" & AEM01C & "^" & AEM02 & "^" & AEM03C & "^" & AEM04 & "^" & AEI01C & "^" & AEI09 & "^" & AEI10 & "^" & AEI08
	
	Set tmp=$p(aDiagInfo,"!",4)
	Set BLH=$p(tmp,"^",3)         //病理号
	Set ZGZDYJRC=$p(tmp,"^",4)    //最高诊断依据代码
	Set FHCDRC=$p(tmp,"^",5)      //分化程度编码
	
	Set tmp=$p(aDiagInfo,"!",6)
	Set ZLFQRC=$p(tmp,"^",1)      //肿瘤分期是否不详
	Set ZLFQT=$p(tmp,"^",2)       //肿瘤分期 T
	Set ZLFQN=$p(tmp,"^",3)       //肿瘤分期 N
	Set ZLFQM=$p(tmp,"^",4)       //肿瘤分期 M
	Set ZLFQJB=$p(tmp,"^",5)      //0～Ⅳ肿瘤分期
	
	
	Set InputStr=""
	Set $p(InputStr,"^",1)   = aMRFPageID
	Set $p(InputStr,"^",2)   = ""
	Set $p(InputStr,"^",3)   = ""  //医疗机构名称
    Set $p(InputStr,"^",4)   = ""  //医疗机构组织机构代码
    Set $p(InputStr,"^",5)   = ""  //医疗付费方式
    Set $p(InputStr,"^",6)   = $p(aPatInfo,"^",37)  //医疗付费方式代码
    Set $p(InputStr,"^",7)   = $p(aPatInfo,"^",38)  //健康卡号
    Set $p(InputStr,"^",8)   = $p(aPatInfo,"^",40)  //住院次数
    Set $p(InputStr,"^",9)   = $p(aPatInfo,"^",39)  //病案号
    Set $p(InputStr,"^",10)  = $p(aPatInfo,"^",1)  //姓名
    Set $p(InputStr,"^",11)  = ""  //性别
    Set $p(InputStr,"^",12)  = $p(aPatInfo,"^",2)  //性别代码
    Set $p(InputStr,"^",13)  = $p(aPatInfo,"^",3)  //出生日期
    Set $p(InputStr,"^",14)  = $p(aPatInfo,"^",4)  //年龄（岁）
    Set tmpDay=$p(aPatInfo,"^",6)
    If tmpDay'="" {
	    Set $p(InputStr,"^",15)  = $fn(((+tmpDay)/30),"",2)  //年龄（月）
	}
    Set $p(InputStr,"^",16)  = ""  //国籍描述
    Set $p(InputStr,"^",17)  = $p(aPatInfo,"^",5)  //国籍代码
    Set $p(InputStr,"^",18)  = ""  //新生儿出生体重（g）
    Set $p(InputStr,"^",19)  = $p(aPatInfo,"^",7)  //新生儿入院体重（g）
    Set $p(InputStr,"^",20)  = ""  //出生地-详细地址
    Set $p(InputStr,"^",21)  = $p(aPatInfo,"^",11)  //出生地-省（自治区、直辖市）
    Set $p(InputStr,"^",22)  = ""  //出生地-省（区、市）编码
    Set $p(InputStr,"^",23)  = $p(aPatInfo,"^",12)  //出生地-市（地区、州）
    Set $p(InputStr,"^",24)  = ""  //出生地-市编码
    Set $p(InputStr,"^",25)  = $p(aPatInfo,"^",13)  //出生地-县（区）
    Set $p(InputStr,"^",26)  = ""  //出生地-县编码
    Set $p(InputStr,"^",27)  = ""  //籍贯-详细地址
    Set $p(InputStr,"^",28)  = $p(aPatInfo,"^",14)  //籍贯-省（自治区、直辖市）
    Set $p(InputStr,"^",29)  = ""  //籍贯-省（区、市）编码
    Set $p(InputStr,"^",30)  = $p(aPatInfo,"^",15)  //籍贯-市（地区、州）
    Set $p(InputStr,"^",31)  = ""  //籍贯-市编码
    Set $p(InputStr,"^",32)  = ""  //民族
    Set $p(InputStr,"^",33)  = $p(aPatInfo,"^",8)  //民族代码
    Set $p(InputStr,"^",34)  = $p(aPatInfo,"^",9)  //患者身份证件号码
    Set $p(InputStr,"^",35)  = ""  //职业描述
    Set $p(InputStr,"^",36)  = $p(aPatInfo,"^",29)  //职业类别代码
    Set $p(InputStr,"^",37)  = ""  //婚姻状况
    Set $p(InputStr,"^",38)  = $p(aPatInfo,"^",10)  //婚姻状况代码
    Set $p(InputStr,"^",39)  = ""  //现住址-详细地址
    Set $p(InputStr,"^",40)  = $p(aPatInfo,"^",22)  //现住址-省（自治区、直辖市）
    Set $p(InputStr,"^",41)  = ""  //现住址-省（区、市）编码
    Set $p(InputStr,"^",42)  = $p(aPatInfo,"^",23)  //现住址-市（地区、州）
    Set $p(InputStr,"^",43)  = ""  //现住址-市编码
    Set $p(InputStr,"^",44)  = $p(aPatInfo,"^",24)  //现住址-县（区）
    Set $p(InputStr,"^",45)  = $p(aPatInfo,"^",25)  //现住址-县编码
    Set $p(InputStr,"^",46)  = $p(aPatInfo,"^",26)  //现住址-其他
    Set $p(InputStr,"^",47)  = $p(aPatInfo,"^",27)  //电话号码
    Set $p(InputStr,"^",48)  = $p(aPatInfo,"^",28)  //现住址-邮政编码
    Set $p(InputStr,"^",49)  = ""  //户口地址-详细地址
    Set $p(InputStr,"^",50)  = $p(aPatInfo,"^",16)  //户口地址-省（区、市）
    Set $p(InputStr,"^",51)  = ""  //户口地址-省（区、市）编码
    Set $p(InputStr,"^",52)  = $p(aPatInfo,"^",17)  //户口地址-市
    Set $p(InputStr,"^",53)  = ""  //户口地址-市编码
    Set $p(InputStr,"^",54)  = $p(aPatInfo,"^",18)  //户口地址-县
    Set $p(InputStr,"^",55)  = $p(aPatInfo,"^",19)  //户口地址-县编码
    Set $p(InputStr,"^",56)  = $p(aPatInfo,"^",20)  //户口地址-其他
    Set $p(InputStr,"^",57)  = $p(aPatInfo,"^",21)  //户口地址-邮政编码
    Set $p(InputStr,"^",58)  = $p(aPatInfo,"^",30)  //工作单位及地址
    Set $p(InputStr,"^",59)  = $p(aPatInfo,"^",31)  //工作单位电话号码
    Set $p(InputStr,"^",60)  = $p(aPatInfo,"^",32)  //工作单位地址-邮政编码
    Set $p(InputStr,"^",61)  = $p(aPatInfo,"^",33)  //联系人姓名
    Set $p(InputStr,"^",62)  = ""  //联系人与患者的关系描述
    Set $p(InputStr,"^",63)  = $p(aPatInfo,"^",34)  //联系人与患者的关系代码
    Set $p(InputStr,"^",64)  = $p(aPatInfo,"^",35)  //联系人地址-完整地址
    Set $p(InputStr,"^",65)  = $p(aPatInfo,"^",36)  //联系人电话号码
    Set $p(InputStr,"^",66)  = ""  //入院途径
    Set $p(InputStr,"^",67)  = $p(aPatInfo,"^",44)  //入院途径代码
    Set $p(InputStr,"^",68)  = ""  //治疗类别
    Set $p(InputStr,"^",69)  = ""  //治疗类别代码
    Set $p(InputStr,"^",70)  = $p($p(aPatInfo,"^",41)," ",1)  //入院日期
    Set $p(InputStr,"^",71)  = $p($p(aPatInfo,"^",41)," ",2)  //入院时间(时)
    Set $p(InputStr,"^",72)  = ""  //入院科别
    Set $p(InputStr,"^",73)  = $p(aPatInfo,"^",42)  //入院科别代码
    Set $p(InputStr,"^",74)  = $p(aPatInfo,"^",43)  //入院病房
    Set $p(InputStr,"^",75)  = ""  //入院病房编码
    Set $p(InputStr,"^",76)  = ""  //转科科别
    Set $p(InputStr,"^",77)  = $p(aPatInfo,"^",49)  //转科科别编码
    Set $p(InputStr,"^",78)  = $p($p(aPatInfo,"^",45)," ",1)  //出院日期
    Set $p(InputStr,"^",79)  = $p($p(aPatInfo,"^",45)," ",2)  //出院时间(时)
    Set $p(InputStr,"^",80)  = ""  //出院科别
    Set $p(InputStr,"^",81)  = $p(aPatInfo,"^",46)  //出院科别代码
    Set $p(InputStr,"^",82)  = $p(aPatInfo,"^",47)  //出院病房
    Set $p(InputStr,"^",83)  = ""  //出院病房编码
    Set $p(InputStr,"^",84)  = $p(aPatInfo,"^",48)  //实际住院天数
    Set $p(InputStr,"^",85)  = ""  //实施临床路径
    Set $p(InputStr,"^",86)  = ""  //实施临床路径标志代码
    Set $p(InputStr,"^",87)  = ""  //使用医疗机构中药制剂标志
    Set $p(InputStr,"^",88)  = ""  //使用中医诊疗设备标志
	Set $p(InputStr,"^",89)  = ""  //使用中医诊疗技术标志
	Set $p(InputStr,"^",90)  = ""  //辨证施护标志
	Set $p(InputStr,"^",91)  = ""  //入院情况描述
    Set $p(InputStr,"^",92)  = ""  //入院情况代码
    Set $p(InputStr,"^",93)  = ""  //入院后确诊日期
    Set $p(InputStr,"^",94)  = BLH  //病理号
    Set $p(InputStr,"^",95)  = ""  //病理号2
    Set $p(InputStr,"^",96)  = ""  //病理号3
    Set $p(InputStr,"^",97)  = ""  //HBs-Ag描述
    Set $p(InputStr,"^",98)  = ""  //HBs-Ag代码
    Set $p(InputStr,"^",99)  = ""  //HCV-Ab描述
    Set $p(InputStr,"^",100) = ""  //HCV-Ab代码
    Set $p(InputStr,"^",101) = ""  //HIV-Ab描述
    Set $p(InputStr,"^",102) = ""  //HIV-Ab代码
    Set $p(InputStr,"^",103) = ""  //门诊与出院
    Set $p(InputStr,"^",104) = ""  //门诊与出院代码
    Set $p(InputStr,"^",105) = ""  //入院与出院
    Set $p(InputStr,"^",106) = ""  //入院与出院代码
    Set $p(InputStr,"^",107) = ""  //术前与术后
    Set $p(InputStr,"^",108) = ""  //术前与术后代码
    Set $p(InputStr,"^",109) = ""  //临床与病理
    Set $p(InputStr,"^",110) = ""  //临床与病理代码
    Set $p(InputStr,"^",111) = ""  //放射与病理
    Set $p(InputStr,"^",112) = ""  //放射与病理代码
    Set $p(InputStr,"^",113) = ""  //抢救次数
    Set $p(InputStr,"^",114) = ""  //成功次数
    Set $p(InputStr,"^",115) = $p(aOtherInfo,"^",1)  //药物过敏标志
	Set $p(InputStr,"^",116) = $p(aOtherInfo,"^",2)  //过敏药物
    Set $p(InputStr,"^",117) = $p(aOtherInfo,"^",37)  //死亡患者尸检标志
    Set $p(InputStr,"^",118) = ""  //手术、治疗、检查、诊断是否为本院第一例
    Set $p(InputStr,"^",119) = ""  //是否随诊
    Set $p(InputStr,"^",120) = ""  //随诊年数
    Set $p(InputStr,"^",121) = ""  //随诊月数
    Set $p(InputStr,"^",122) = ""  //随诊周数
    Set $p(InputStr,"^",123) = ""  //示教病历
    Set $p(InputStr,"^",124) = ""  //ABO血型
    Set $p(InputStr,"^",125) = $p(aOtherInfo,"^",17)  //ABO血型代码
    Set $p(InputStr,"^",126) = ""  //Rh血型
    Set $p(InputStr,"^",127) = $p(aOtherInfo,"^",18)  //Rh血型代码
    Set $p(InputStr,"^",128) = ""  //是否有输血反应代码
    Set $p(InputStr,"^",129) = $p(aOtherInfo,"^",19)  //红细胞
    Set $p(InputStr,"^",130) = $p(aOtherInfo,"^",20)  //血小板
    Set $p(InputStr,"^",131) = $p(aOtherInfo,"^",21)  //血浆
    Set $p(InputStr,"^",132) = $p(aOtherInfo,"^",22)  //全血
    Set $p(InputStr,"^",133) = $p(aOtherInfo,"^",23)  //其它_输血
    Set $p(InputStr,"^",134) = $p(aOtherInfo,"^",7)  //科主任签名
	Set $p(InputStr,"^",135) = $p(aOtherInfo,"^",8)  //主任（副主任）医师签名
	Set $p(InputStr,"^",136) = $p(aOtherInfo,"^",9)  //主治医师签名
	Set $p(InputStr,"^",137) = $p(aOtherInfo,"^",12)  //住院医师签名
	Set $p(InputStr,"^",138) = $p(aOtherInfo,"^",16)  //责任护士签名
	Set $p(InputStr,"^",139) = $p(aOtherInfo,"^",13)  //进修医师签名
	Set $p(InputStr,"^",140) = ""  //研究生实习医师
    Set $p(InputStr,"^",141) = $p(aOtherInfo,"^",14)  //实习医师签名
	Set $p(InputStr,"^",142) = $p(aOtherInfo,"^",15)  //编码员签名
	Set $p(InputStr,"^",143) = ""  //病案质量描述
    Set $p(InputStr,"^",144) = $p(aOtherInfo,"^",3)  //病案质量代码
    Set $p(InputStr,"^",145) = $p(aOtherInfo,"^",4)  //质控医师签名
	Set $p(InputStr,"^",146) = $p(aOtherInfo,"^",5)  //质控护士签名
	Set $p(InputStr,"^",147) = $p(aOtherInfo,"^",6)  //质控日期
    Set $p(InputStr,"^",148) = ""  //离院方式
    Set $p(InputStr,"^",149) = $p(aOtherInfo,"^",33)  //离院方式代码
    Set $p(InputStr,"^",150) = $p(aOtherInfo,"^",34)  //转入医院名称
    Set $p(InputStr,"^",151) = $p(aOtherInfo,"^",34)  //转入社区服务机构/乡镇卫生院名称
    Set $p(InputStr,"^",152) = $p(aOtherInfo,"^",35)  //出院31d内再住院
    Set $p(InputStr,"^",153) = $p(aOtherInfo,"^",36)  //出院31d内再住院目的
    Set $p(InputStr,"^",154) = $p(aOtherInfo,"^",24)  //颅脑损伤患者入院前昏迷时间-d
    Set $p(InputStr,"^",155) = $p(aOtherInfo,"^",25)  //颅脑损伤患者入院前昏迷时间-h
    Set $p(InputStr,"^",156) = $p(aOtherInfo,"^",26)  //颅脑损伤患者入院前昏迷时间-min
    Set $p(InputStr,"^",157) = $p(aOtherInfo,"^",27)  //颅脑损伤患者入院后昏迷时间-d
    Set $p(InputStr,"^",158) = $p(aOtherInfo,"^",28)  //颅脑损伤患者入院后昏迷时间-h
    Set $p(InputStr,"^",159) = $p(aOtherInfo,"^",29)  //颅脑损伤患者入院后昏迷时间-min
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveAdm(InputStr)
	If flg<0 {
		Set ErrCode="-400"
		Set ErrText="病人信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveAdm("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
		Set return=-1
	} Else {
		Set return=flg
	}
	Quit return
}

ClassMethod SaveFeeInfo(aMRFPageID As %String, aFeeInfo As %String) As %String
{
	New (aMRFPageID,aFeeInfo)
	Set return=0
	Quit:aFeeInfo="" return
	
	//FeeInfo = ADA01 & "^" & ADA0101 & "^" & ADA11 & "^" & ADA21 & "^" & ADA22 & "^" & ADA23 & "^" & ADA24 & "^" & ADA25 & "^" & ADA26 & "^" & ADA27 & "^" & ADA28 & "^" & ADA13 & "^" & ADA15 & "^" & ADA12 & "^" & ADA29 & "^" & ADA03 & "^" & ADA30 & "^" & ADA31 & "^" & ADA32 & "^" & ADA07 & "^" & ADA08 & "^" & ADA33 & "^" & ADA34 & "^" & ADA35 & "^" & ADA36 & "^" & ADA37 & "^" & ADA38 & "^" & ADA02 & "^" & ADA39 & "^" & ADA09 & "^" & ADA10 & "^" & ADA04 & "^" & ADA40 & "^" & ADA41 & "^" & ADA42 & "^" & ADA43 & "^" & ADA44 & "^" & ADA05 & "^" & ADA06 & "^" & ADA20
	
	Set InputStr=""
	Set $p(InputStr,"^",1)  = aMRFPageID
	Set $p(InputStr,"^",2)  = ""
	Set $p(InputStr,"^",3)  = $p(aFeeInfo,"^",1)    //住院总费用
	Set $p(InputStr,"^",4)  = $p(aFeeInfo,"^",2)    //住院总费用-自付金额
	Set $p(InputStr,"^",5)  = $p(aFeeInfo,"^",3)    //综合医疗服务类-一般医疗服务费
	Set $p(InputStr,"^",6)  = $p(aFeeInfo,"^",9)    //综合医疗服务类-一般医疗服务费-中医辨证论治费
	Set $p(InputStr,"^",7)  = ""    //综合医疗服务类-一般医疗服务费-中医辨证论治会诊费
	Set $p(InputStr,"^",8)  = $p(aFeeInfo,"^",10)    //综合医疗服务类-一般治疗操作费
	Set $p(InputStr,"^",9)  = $p(aFeeInfo,"^",16)    //综合医疗服务类-护理费
	Set $p(InputStr,"^",10) = ""    //综合医疗服务类-其他费用
	Set $p(InputStr,"^",11) = $p(aFeeInfo,"^",22)    //诊断类-病理诊断费
	Set $p(InputStr,"^",12) = $p(aFeeInfo,"^",21)    //诊断类-实验室诊断费
	Set $p(InputStr,"^",13) = $p(aFeeInfo,"^",4)    //诊断类-影像学诊断费
	Set $p(InputStr,"^",14) = ""    //诊断类-临床诊断项目费
	Set $p(InputStr,"^",15) = ""    //治疗类-非手术治疗项目费
	Set $p(InputStr,"^",16) = $p(aFeeInfo,"^",5)    //治疗类-非手术治疗项目费-临床物理治疗费
	Set $p(InputStr,"^",17) = ""    //治疗类-手术治疗费
	Set $p(InputStr,"^",18) = $p(aFeeInfo,"^",13)    //治疗类-手术治疗费-麻醉费
	Set $p(InputStr,"^",19) = $p(aFeeInfo,"^",14)    //治疗类-手术治疗费-手术费
	Set $p(InputStr,"^",20) = $p(aFeeInfo,"^",8)    //康复类-康复费
	Set $p(InputStr,"^",21) = ""  //中医类-中医诊断费
	Set $p(InputStr,"^",22) = ""  //中医类-中医治疗费
	Set $p(InputStr,"^",23) = ""  //中医类-中医治疗费-中医外治费
	Set $p(InputStr,"^",24) = ""  //中医类-中医治疗费-中医骨伤费
	Set $p(InputStr,"^",25) = ""  //中医类-中医治疗费-针刺与灸法费
	Set $p(InputStr,"^",26) = ""  //中医类-中医治疗费-中医推拿治疗费
	Set $p(InputStr,"^",27) = ""  //中医类-中医治疗费-中医肛肠治疗费
	Set $p(InputStr,"^",28) = ""  //中医类-中医治疗费-中医特殊治疗费
	Set $p(InputStr,"^",29) = ""  //中医类-中医其他费
	Set $p(InputStr,"^",30) = ""  //中医类-中医其他费-中医特殊调配加工费
	Set $p(InputStr,"^",31) = ""  //中医类-中医其他费-辨证施膳费
	Set $p(InputStr,"^",32) = $p(aFeeInfo,"^",32)    //西药类-西药费
	Set $p(InputStr,"^",33) = $p(aFeeInfo,"^",33)    //西药类-西药费-抗菌药物费用
	Set $p(InputStr,"^",34) = $p(aFeeInfo,"^",38)    //中药类-中成药费
	Set $p(InputStr,"^",35) = ""  //中药类-中成药费-医疗机构中药制剂费
	Set $p(InputStr,"^",36) = $p(aFeeInfo,"^",39)    //中药类-中草药费
	Set $p(InputStr,"^",37) = $p(aFeeInfo,"^",31)    //血液和血液制品类-血费
	Set $p(InputStr,"^",38) = $p(aFeeInfo,"^",34)    //血液和血液制品类-白蛋白类制品费
	Set $p(InputStr,"^",39) = $p(aFeeInfo,"^",35)    //血液和血液制品类-球蛋白类制品费
	Set $p(InputStr,"^",40) = $p(aFeeInfo,"^",36)    //血液和血液制品类-凝血因子类制品费
	Set $p(InputStr,"^",41) = $p(aFeeInfo,"^",37)    //血液和血液制品类-细胞因子类制品费
	Set $p(InputStr,"^",42) = $p(aFeeInfo,"^",27)    //耗材类-检查用一次性医用材料费
	Set $p(InputStr,"^",43) = $p(aFeeInfo,"^",26)    //耗材类-治疗用一次性医用材料费
	Set $p(InputStr,"^",44) = $p(aFeeInfo,"^",24)    //耗材类-手术用一次性医用材料费
	Set $p(InputStr,"^",45) = $p(aFeeInfo,"^",40)    //其他类-其他费
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveFees(InputStr)
	If flg<0 {
		Set ErrCode="-500"
		Set ErrText="费用信息更新错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveFees("""_InputStr_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
		Set return=-1
	} Else {
		Set return=flg
	}
	Quit return
}

ClassMethod SaveICUInfo(aMRFPageID As %String, aOtherInfo As %String) As %String
{
	New (aMRFPageID,aOtherInfo)
	Set return=0
	Quit:aOtherInfo="" return
	
	//初始化重症监护记录
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).InitICU(aMRFPageID)
	If flg<0 {
		Set ErrCode="-601"
		Set ErrText="初始化重症监护记录错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).InitICU("""_aMRFPageID_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
	}
	
	//AEKS = AEKS & "$" & AEK01C & "@" & AEK02 & "@" & AEK03
	//OtherInfo = AEB02C & "^" & AEB01 & "^" & AED01C & "^" & AED02 & "^" & AED03 & "^" & AED04 & "^" & AEE01 & "^" & AEE02 & "^" & AEE03 & "^" & AEE11 & "^" & AEE09 & "^" & AEE04 & "^" & AEE05 & "^" & AEE07 & "^" & AEE08 & "^" & AEE10 & "^" & AEG01C & "^" & AEG02C & "^" & AEG04 & "^" & AEG05 & "^" & AEG06 & "^" & AEG07 & "^" & AEG08 & "^" & AEJ01 & "^" & AEJ02 & "^" & AEJ03 & "^" & AEJ04 & "^" & AEJ05 & "^" & AEJ06 & "^" & AEKS & "^" & AEL01 & "^" & AENS & "^" & AEM01C & "^" & AEM02 & "^" & AEM03C & "^" & AEM04 & "^" & AEI01C & "^" & AEI09 & "^" & AEI10 & "^" & AEI08
	
	Set ICUInfo=$p(aOtherInfo,"!",30)
	Quit:ICUInfo="" return
	For indI=1:1:$l(ICUInfo,"$") {
		Set tmp=$p(ICUInfo,"^",indI)
		Continue:tmp=""
		Set LocCode=$p(tmp,"^",1)
		Set SttDateTime=$p(tmp,"^",2)
		Set SttDate=$p(SttDateTime," ",1)
		Set SttTime=$p(SttDateTime," ",2)
		Set EndDateTime=$p(tmp,"^",3)
		Set EndDate=$p(EndDateTime," ",1)
		Set EndTime=$p(EndDateTime," ",2)
		Set TypeDesc="ICU"
		
		Set InputStr=""
		Set $p(InputStr,"^",1)=aMRFPageID
		Set $p(InputStr,"^",2)=""
		Set $p(InputStr,"^",3)=TypeDesc      //TypeDesc
		Set $p(InputStr,"^",4)=""
		Set $p(InputStr,"^",5)=""
		Set $p(InputStr,"^",6)=""            //LocDesc
		Set $p(InputStr,"^",7)=LocCode       //LocCode
		Set $p(InputStr,"^",8)=SttDate       //SttDate
		Set $p(InputStr,"^",9)=SttTime       //SttTime
		Set $p(InputStr,"^",10)=EndDate       //EndDate
		Set $p(InputStr,"^",11)=EndTime      //EndTime
		Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICU(InputStr)
		If flg<0 {
			Set ErrCode="-200"
			Set ErrText="重症监护记录更新错误"
			Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICU("""_InputStr_""")"
			Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
			Set return=-1
		}
	}
	Quit:return<0 return
	
	Set return=1
	Quit return
}

/// w ##Class(DHCWMR.MRService.ImportDataByTR).GetEpisodeID("1001889","季道霞","女","","2015-07-01 08:35:00","2015-07-06 14:06:00")
ClassMethod GetEpisodeID(aMrNo As %String, aPatName As %String, aSex As %String, aBirthday As %String, aAdmitDate As %String, aDischDate As %String) As %String
{
	New (aMrNo,aPatName,aSex,aBirthday,aAdmitDate,aDischDate)
	Set return=""
	Quit:(aMrNo="")||(aAdmitDate="") return
	
	Set:aBirthday["-" aBirthday=$zdh(aBirthday,3)
	Set aAdmitDate=$p(aAdmitDate," ",1)
	Set:aAdmitDate["-" aAdmitDate=$zdh(aAdmitDate,3)
	Set aDischDate=$p(aDischDate," ",1)
	Set:aDischDate["-" aDischDate=$zdh(aDischDate,3)
	Quit:(aAdmitDate="")||(aDischDate="") return
	Set aPatName=$tr(aPatName," ","")
	
	Kill arrPatientID
	Set MRVersion=+$g(^DHCWMR.SS.VersionC)
	If MRVersion=3 {
		//新版本病案系统表
		Set xMrType=0
		For {
			Set xMrType=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrType))
			Quit:xMrType=""
			Set MrTypeDesc=$listget($g(^DHCWMR.SS.MrTypeD(xMrType)),3)
			Continue:MrTypeDesc'["住院"
			
			Set xMainID=0
			For {
				Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",xMrType," "_aMrNo,1,xMainID))
				Quit:xMainID=""
				Set IsActive=$listget($g(^DHCWMR.SS.MainD(xMainID)),6)
				Continue:IsActive'=1
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
					Quit:xVolID=""
					Set IsActive=$listget($g(^DHCWMR.SS.VolumeD(xVolID)),14)
					Continue:IsActive'=1
					
					Set xSub=0
					For {
						Set xSub=$o(^DHCWMR.SS.VolumeD(xVolID,"P",xSub))
						Quit:xSub=""
						
						Set PatientID=$listget($g(^DHCWMR.SS.VolumeD(xVolID,"P",xSub)),2)
						Continue:PatientID=""
						Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
						Set PatName=$tr(PatName," ","")
						Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
						Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
						Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
						Continue:(aPatName'="")&(PatName'=aPatName)
						Continue:(aSex'="")&(Sex'="")&(Sex'[aSex)
						//Continue:(aBirthday'="")&(Birthday'="")&(Birthday'=aBirthday)
						Set arrPatientID(PatientID)=""
					}
				}
			}
		}
	} Else {
		//老版本病案系统表
		//^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
		Set xMrType=""
		For {
			Set xMrType=$o(^DHCWMRMAIN(0,"TypeNO",xMrType))
			Quit:xMrType=""
			Set MrTypeDesc=$p($g(^DHCWMRDIC(xMrType)),"^",3)
			Continue:MrTypeDesc'["住院"
			
			//安贞病案号特殊处理
			If '$d(^DHCWMRMAIN(0,"TypeNO",xMrType,aMrNo)) {
				Set aMrNo=##Class(DHCWMR.SSService.CommonSrv).RegNoCon(aMrNo)
			}
			
			Set xID=0
			For {
				Set xID=$o(^DHCWMRMAIN(0,"TypeNO",xMrType,aMrNo,xID))
				Quit:xID=""
				
				Set IsActive=$p($g(^DHCWMRMAIN(xID)),"^",6)
				Continue:IsActive'="Y"
				Set PatientID=$p($g(^DHCWMRMAIN(xID)),"^",3)
				Continue:PatientID=""
				Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
				Set PatName=$tr(PatName," ","")
				Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
				Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
				Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
				Continue:(aPatName'="")&(PatName'=aPatName)
				Continue:(aSex'="")&(Sex'="")&(Sex'[aSex)
				//Continue:(aBirthday'="")&(Birthday'="")&(Birthday'=aBirthday)
				Set arrPatientID(PatientID)=""
			}
		}
	}
	
	//根据病案号查找病人ID
	Set tmpMrNo=$$ALPHAUP^SSUTIL4(aMrNo)
	Set:tmpMrNo="" tmpMrNo=aMrNo
	Set xPatientID=0
	For {
		Set xPatientID=$o(^PAPERi("Medicare1",tmpMrNo,xPatientID))
		Quit:xPatientID=""
		
		Set PatientID=xPatientID
		Continue:PatientID=""
		Set PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
		Set PatName=$tr(PatName," ","")
		Set Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
		Set:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
		Set Birthday=$p($g(^PAPER(PatientID,"ALL")),"^",6)
		Continue:(aPatName'="")&(PatName'=aPatName)
		Continue:(aSex'="")&(Sex'="")&(Sex'[aSex)
		//Continue:(aBirthday'="")&(Birthday'="")&(Birthday'=aBirthday)
		Set arrPatientID(PatientID)=""
	}
	
	//同时检查入院日期和出院日期
	Set EpisodeID=""
	Set xPatientID=0
	For {
		Set xPatientID=$o(arrPatientID(xPatientID))
		Quit:xPatientID=""
		Quit:EpisodeID'=""
		
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAPERdr(xPatientID,"ADM","I",xPaadm))
			Quit:xPaadm=""
			Quit:EpisodeID'=""
			
			Set tAdmDate=$p($g(^PAADM(xPaadm)),"^",6)
			Set tDisDate=$p($g(^PAADM(xPaadm)),"^",17)
			Continue:aAdmitDate'=tAdmDate
			Continue:aDischDate'=tDisDate
			Set EpisodeID=xPaadm
		}
	}
	
	If EpisodeID="" {
		//只检查入院日期
		Set xPatientID=0
		For {
			Set xPatientID=$o(arrPatientID(xPatientID))
			Quit:xPatientID=""
			Quit:EpisodeID'=""
			
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAPERdr(xPatientID,"ADM","I",xPaadm))
				Quit:xPaadm=""
				Quit:EpisodeID'=""
				
				Set tAdmDate=$p($g(^PAADM(xPaadm)),"^",6)
				Continue:aAdmitDate'=tAdmDate
				Set EpisodeID=xPaadm
			}
		}
	}
	
	If EpisodeID="" {
		//只检查出院日期
		Set xPatientID=0
		For {
			Set xPatientID=$o(arrPatientID(xPatientID))
			Quit:xPatientID=""
			Quit:EpisodeID'=""
			
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAPERdr(xPatientID,"ADM","I",xPaadm))
				Quit:xPaadm=""
				Quit:EpisodeID'=""
				
				Set tDisDate=$p($g(^PAADM(xPaadm)),"^",17)
				Continue:aDischDate'=tDisDate
				Set EpisodeID=xPaadm
			}
		}
	}
	Kill arrPatientID
	
	Set return=EpisodeID
	Quit return
}

Storage Default
{
<Data name="ImportDataByTRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MRSer563.ImportDataByTRD</DataLocation>
<DefaultData>ImportDataByTRDefaultData</DefaultData>
<IdLocation>^DHCWMR.MRSer563.ImportDataByTRD</IdLocation>
<IndexLocation>^DHCWMR.MRSer563.ImportDataByTRI</IndexLocation>
<StreamLocation>^DHCWMR.MRSer563.ImportDataByTRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
