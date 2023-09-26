/// 名称: DHCMed.FBDService.PrintSrv
/// 描述: 食源性疾病打印
Class DHCMed.FBDService.PrintSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 打印食源性疾病报告
/// w ##class(DHCMed.FBDService.PrintSrv).FBDReportPrint()
ClassMethod FBDReportPrint(aItmjs As %String, aReportID As %String) As %String
{
	New (aItmjs,aReportID)
	Set return=0
	Set objReport=##class(DHCMed.FBD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^CacheTemp(ZIndex,JIndex,"PrintSign")
	Set return=1,chkY="☑",chkN="□",space="    "	// ☑gou■hei□bai
	
	Set CardNo=objReport.FRCardNo	// 卡号
	Set (StatusID,StatusCode,StatusDesc)=""	// 状态
	Set StatusDr=objReport.FRStatusDr
	If $IsObject(StatusDr) {
		Set StatusID=StatusDr.%Id()
		Set StatusCode=StatusDr.Code
		Set StatusDesc=StatusDr.Description
	}
	Set (DiseaseID,DiseaseDesc,CateID,CateDesc)=""	// 疾病
	Set DiseaseDr=objReport.FRDiseaseDr
	If $IsObject(DiseaseDr) {
		Set DiseaseID=DiseaseDr.%Id()
		Set DiseaseDesc=DiseaseDr.IDDesc
		Set CateDr=DiseaseDr.IDCateDr
		If (CateDr) {
			Set CateID=CateDr.%Id()
			Set CateDesc=CateDr.Description
		}
	}
	Set DiseaseText=objReport.FRDiseaseText
	Set ReportLoc=objReport.FRReportLoc	// 科室
	Set ReportLocDesc=""
	Set objReportLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
	If $IsObject(objReportLoc) {
		Set ReportLocDesc=objReportLoc.Descs
	}
	Set HospitalDr=""
	set:ReportLoc'="" HospitalDr=+$p($g(^CTLOC(+ReportLoc)),"^",22)
	Set (PatName,Sex,Birthday,PersonalID,Nation,OPNo,IPNo)=""
	Set (PatAge,Age,AgeMonth,AgeDay,PapmiNo,AdmType)=""
	Set PatientObj=objReport.FRPatientObj //DHCMed.FBD.ReportPat
	If $IsObject(PatientObj) {
		Set PatName=PatientObj.RPPatName
		Set Sex=PatientObj.RPSex
		Set Birthday=PatientObj.RPBirthday
		Set:Birthday'="" Birthday=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
		Set PersonalID=PatientObj.RPPersonalID
		Set Nation=PatientObj.RPNation
		Set OPNo=PatientObj.RPOPNo
		Set IPNo=PatientObj.RPIPNo
	}
	Set EpisodeID=objReport.FREpisodeID
	Set objPatientAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	If $IsObject(objPatientAdm) {
		Set AdmType=objPatientAdm.AdmType
	}
	Set AdmTypeDesc=$s(AdmType="O":"门诊",AdmType="I":"病房",AdmType="E":"急诊",1:"")
	Set PatientID=objReport.FRPatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient) {
		Set:(PatName="") PatName=objPatient.PatientName
		Set:(Sex="") Sex=objPatient.Sex
		Set:(Birthday="") Birthday=objPatient.Birthday
		Set Age=objPatient.Age
		Set AgeMonth=objPatient.AgeMonth
		Set AgeDay=objPatient.AgeDay
		Set PapmiNo=objPatient.PapmiNo	// 登记号
		If (Age>0) {
			Set PatAge=Age_"岁"
		} ElseIf (AgeMonth>0) {
			Set PatAge=AgeMonth_"月"
		} Else {
			Set PatAge=AgeDay_"天"
		}
	}
	Set SexDesc=chkN_"男"_space_chkN_"女"
	Set $e(SexDesc,$f(SexDesc,Sex)-2)=chkY
	/*Set BirthdayDesc="    年  月  日"
	If (Birthday'="")&&(Birthday'="1840-12-31") {
		Set BirthdayDesc=$p(Birthday,"-",1)_"年"_$p(Birthday,"-",2)_"月"_$p(Birthday,"-",3)_"日"
	}*/
	Set BirthdayDesc=Birthday
	
	Set (OccupationID,OccupationDesc)=""	// 职业
	Set OccupationDr=objReport.FROccupationDr
	If $IsObject(OccupationDr) {
		Set OccupationID=OccupationDr.%Id()
		Set OccupationDesc=OccupationDr.Description
	}
	Set (AreaID,AreaDesc)=""	// 地址
	Set AreaDr=objReport.FRAreaDr
	If $IsObject(AreaDr) {
		Set AreaID=AreaDr.%Id()
		Set AreaDesc=AreaDr.Description
	}
	Set CurrAddress=objReport.FRCurrAddress
	Set CurrProvince=objReport.FRCurrProvince
	Set CurrCity=objReport.FRCurrCity
	Set CurrCounty=objReport.FRCurrCounty
	Set CurrVillage=objReport.FRCurrVillage
	Set CurrRoad=objReport.FRCurrRoad
	Set Address=CurrProvince_CurrCity_CurrCounty_CurrVillage_CurrRoad
	Set (IsInHospDesc,IsUseAntiDesc)=chkN_"是"_space_chkN_"否"
	Set IsInHosp=objReport.FRIsInHosp
	Set IsInHosp=$s(+IsInHosp=1:"是",1:"否")
	Set $e(IsInHospDesc,$f(IsInHospDesc,IsInHosp)-2)=chkY
	Set IsUseAnti=objReport.FRIsUseAnti
	Set IsUseAnti=$s(+IsUseAnti=1:"是",1:"否")
	Set $e(IsUseAntiDesc,$f(IsUseAntiDesc,IsUseAnti)-2)=chkY
	Set UseAntiDesc=objReport.FRUseAntiDesc
	Set Contactor=objReport.FRContactor
	Set Telephone=objReport.FRTelephone
	Set Company=objReport.FRCompany
	Set (SickDT,AdmitDT,DeathDT)="    年  月  日  时"
	Set SickDate=objReport.FRSickDate
	//Set SickDate=$zd(SickDate,3)
	Set SickTime=objReport.FRSickTime
	Set SickTime=$zt(SickTime)
	/*If (SickDate'="1840-12-31") {
		Set SickDT=$p(SickDate,"-",1)_"年"_$p(SickDate,"-",2)_"月"_$p(SickDate,"-",3)_"日"_$p(SickTime,":",1)_"时"
	}*/
	Set:+SickDate'=0 SickDT=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)_" "_$p(SickTime,":",1)_"时"
	Set AdmitDate=objReport.FRAdmitDate
	//Set AdmitDate=$zd(AdmitDate,3)
	Set AdmitTime=objReport.FRAdmitTime
	Set AdmitTime=$zt(AdmitTime)
	/*If (AdmitDate'="1840-12-31") {
		Set AdmitDT=$p(AdmitDate,"-",1)_"年"_$p(AdmitDate,"-",2)_"月"_$p(AdmitDate,"-",3)_"日"_$p(AdmitTime,":",1)_"时"
	}*/
	Set:+AdmitDate'=0 AdmitDT=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)_" "_$p(AdmitTime,":",1)_"时"
	Set DeathDate=objReport.FRDeathDate
	//Set DeathDate=$zd(DeathDate,3)
	Set DeathTime=objReport.FRDeathTime
	Set DeathTime=$zt(DeathTime)
	/*If (DeathDate'="1840-12-31") {
		Set DeathDT=$p(DeathDate,"-",1)_"年"_$p(DeathDate,"-",2)_"月"_$p(DeathDate,"-",3)_"日"_$p(DeathTime,":",1)_"时"
	}*/
	Set:+DeathDate'=0 DeathDT=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)_" "_$p(DeathTime,":",1)_"时"
	Set PreDiagnosDrs=objReport.FRPreDiagnosDrs                              //41初步诊断
	Set PreDiagnosDrsList=""
	For ind=1:1:PreDiagnosDrs.Count() {
		Set objDic=PreDiagnosDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set PreDiagnosDrsList=PreDiagnosDrsList_","_objDic.Description
	}
	Set:PreDiagnosDrsList'="" PreDiagnosDrsList=$e(PreDiagnosDrsList,2,$l(PreDiagnosDrsList))
	Set PreDiagnos= objReport.FRPreDiagnos
	Set:PreDiagnos'="" PreDiagnosDrsList=$replace(PreDiagnosDrsList,"其他",PreDiagnos)
	Set AnamnesisDrs=objReport.FRAnamnesisDrs                             //42既往病史
	Set AnamnesisDrsList=""
	For ind=1:1:AnamnesisDrs.Count() {
		Set objDic=AnamnesisDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set AnamnesisDrsList=AnamnesisDrsList_","_objDic.Description
	}
	Set:AnamnesisDrsList'="" AnamnesisDrsList=$e(AnamnesisDrsList,2,$l(AnamnesisDrsList))
	Set Anamnesis=objReport.FRAnamnesis
	Set:Anamnesis'="" AnamnesisDrsList=$replace(AnamnesisDrsList,"其他",Anamnesis)
	Set (RepUserName,ChkUserName)=""
	Set ReportUser=objReport.FRReportUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
	Set:$IsObject(objRepUser) RepUserName=objRepUser.Name
	Set CheckUser=objReport.FRCheckUser
	Set objChkUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUser)
	Set:$IsObject(objChkUser) ChkUserName=objChkUser.Name
	Set ReportDate=objReport.FRReportDate
	Set ReportDate=$zd(ReportDate,3)
	Set ReportTime=objReport.FRReportTime
	Set ReportTime=$zt(ReportTime)
	Set ReportDT="    年  月  日"
	If (ReportDate'="1840-12-31") {
		Set ReportDT=$p(ReportDate,"-",1)_"年"_$p(ReportDate,"-",2)_"月"_$p(ReportDate,"-",3)_"日"
	}
	Set CheckDate=objReport.FRCheckDate
	Set CheckDate=$zd(CheckDate,3)
	Set CheckTime=objReport.FRCheckTime
	Set CheckTime=$zt(CheckTime)
	Set Resume=objReport.FRResume
	Set HospitalDesc=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalDesc","")
	// 为空取是否没有院区
	if (HospitalDesc=""){
		Set HospitalDesc=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("FBD-HospitalDesc",HospitalDr)
	}
	
	// 1.病例基本信息
	Set row=2
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_32_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"一、病例基本信息"_"',"_row_",1);"
	&javascript<#(retval)#>*/
	// 病历编号
	/*s retval="MergCells(xls,"_row_","_33_","_row_","_38_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"病例编号:"_"',"_row_",33);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_39_","_row_","_48_");"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(CardNo,"O","JS")_"',"_row_",39);"
	&javascript<#(retval)#>
	
	Set row=row+1
	// 门诊号
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"门诊号*:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_7_","_row_","_16_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_16_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(OPNo,"O","JS")_"',"_row_",7);"
	&javascript<#(retval)#>
	// 是否住院
	/*s retval="MergCells(xls,"_row_","_17_","_row_","_22_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_17_","_row_","_22_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"是否住院:"_"',"_row_",17);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_23_","_row_","_32_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_23_","_row_","_32_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(IsInHospDesc,"O","JS")_"',"_row_",23);"
	&javascript<#(retval)#>
	// 住院号
	/*s retval="MergCells(xls,"_row_","_33_","_row_","_38_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_33_","_row_","_38_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"住院号:"_"',"_row_",33);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_39_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_39_","_row_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(IPNo,"O","JS")_"',"_row_",39);"
	&javascript<#(retval)#>
	
	Set row=row+1
	// 姓名
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"姓名*:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_7_","_row_","_16_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_16_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(PatName,"O","JS")_"',"_row_",7);"
	&javascript<#(retval)#>
	// 性别
	/*s retval="MergCells(xls,"_row_","_17_","_row_","_22_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_17_","_row_","_22_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"性别*:"_"',"_row_",17);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_23_","_row_","_32_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_23_","_row_","_32_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(SexDesc,"O","JS")_"',"_row_",23);"
	&javascript<#(retval)#>
	// 监护人姓名
	/*s retval="MergCells(xls,"_row_","_33_","_row_","_38_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_33_","_row_","_38_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"监护人姓名:"_"',"_row_",33);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_39_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_39_","_row_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(Contactor,"O","JS")_"',"_row_",39);"
	&javascript<#(retval)#>
	
	Set row=row+1
	// 身份证号
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"身份证号:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_7_","_row_","_16_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_16_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(PersonalID,"O","JS")_"',"_row_",7);"
	&javascript<#(retval)#>
	// 出生日期
	/*s retval="MergCells(xls,"_row_","_17_","_row_","_22_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_17_","_row_","_22_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"出生日期*:"_"',"_row_",17);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_23_","_row_","_32_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_23_","_row_","_32_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(BirthdayDesc,"O","JS")_"',"_row_",23);"
	&javascript<#(retval)#>
	// 联系方式
	/*s retval="MergCells(xls,"_row_","_33_","_row_","_38_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_33_","_row_","_38_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"联系方式*:"_"',"_row_",33);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_39_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_39_","_row_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(Telephone,"O","JS")_"',"_row_",39);"
	&javascript<#(retval)#>
	
	Set row=row+1
	// 单位
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"单位:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_7_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(Company,"O","JS")_"',"_row_",7);"
	&javascript<#(retval)#>
	
	Set row=row+1
	// 病人属于
	Set frow=row,col=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("FBDReportRegion","1")
	While rs.Next() {
		Set col=col+7
		Set:(col>48) col=7,row=row+1
		Set RegionID=rs.Get("myid")
		Set RegionDesc=rs.Get("Description")
		Set AreaDesc=$s(RegionID=AreaID:chkY,1:chkN)_RegionDesc
		s retval="MergCells(xls,"_row_","_col_","_row_","_(col+6)_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(AreaDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
	}
	Do rs.Close()
	/*s retval="BorderCells(xls,"_frow_","_7_","_row_","_7_",'"_"1"_"');"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_frow_","_48_","_row_","_48_",'"_"2"_"');"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_frow_","_7_","_frow_","_48_",'"_"3"_"');"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_48_",'"_"4"_"');"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_frow_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_frow_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"病人属于*:"_"',"_frow_",1);"
	&javascript<#(retval)#>*/
	
	Set row=row+1
	// 现住地址
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"现住地址*:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_7_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(Address,"O","JS")_"',"_8_",7);"
	&javascript<#(retval)#>
	
	Set row=row+1
	// 患者职业
	Set frow=row,col=0
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("FBDOccupation","1")
	While rs.Next() {
		Set col=col+7
		Set:(col>48) col=7,row=row+1
		Set OccID=rs.Get("myid")
		Set OccDesc=rs.Get("Description")
		Set OccupationDesc=$s(OccID=OccupationID:chkY,1:chkN)_OccDesc
		s retval="MergCells(xls,"_row_","_col_","_row_","_(col+6)_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(OccupationDesc,"O","JS")_"',"_row_","_col_");"
		&javascript<#(retval)#>
	}
	Do rs.Close()
	/*s retval="BorderCells(xls,"_frow_","_7_","_row_","_7_",'"_"1"_"');"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_frow_","_48_","_row_","_48_",'"_"2"_"');"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_frow_","_7_","_frow_","_48_",'"_"3"_"');"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_48_",'"_"4"_"');"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_frow_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_frow_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"患者职业*:"_"',"_frow_",1);"
	&javascript<#(retval)#>*/
	
	Set row=row+1
	// 发病时间
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_6_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_row_","_6_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"发病时间*:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_7_","_row_","_16_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_7_","_row_","_16_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(SickDT,"O","JS")_"',"_row_",7);"
	&javascript<#(retval)#>
	// 就诊时间
	/*s retval="MergCells(xls,"_row_","_17_","_row_","_22_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_17_","_row_","_22_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"就诊时间*:"_"',"_row_",17);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_23_","_row_","_32_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_23_","_row_","_32_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(AdmitDT,"O","JS")_"',"_row_",23);"
	&javascript<#(retval)#>
	// 死亡时间
	/*s retval="MergCells(xls,"_row_","_33_","_row_","_38_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_33_","_row_","_38_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"死亡时间:"_"',"_row_",33);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_39_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_39_","_row_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(DeathDT,"O","JS")_"',"_row_",39);"
	&javascript<#(retval)#>
	
	// 2.主要症状与体征
	Set row=row+1
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"二、主要症状与体征"_"',"_row_",1);"
	&javascript<#(retval)#>*/
	Set rs=##Class(%ResultSet).%New("DHCMed.FBDService.ReportSrv:QryReportSign")
	Do rs.Execute(aReportID)
	While rs.Next() {
		Set Code=rs.Get("Code")
		Set Desc=rs.Get("Desc")
		Set ExtraUnit=rs.Get("ExtraUnit")
		Set ExtraText=rs.Get("ExtraText")
		Set Impl=rs.Get("Impl")
		Set chkImpl=$s(Impl=1:chkY,1:chkN)
		Set SignDesc=chkImpl_Desc
		Set:(ExtraText'="")!(ExtraUnit'="") SignDesc=SignDesc_" "_ExtraText_ExtraUnit
		If $l(Code)=3 {
			//Set SignDesc=$e(SignDesc,2,$l(SignDesc))
			Set ^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3))=Desc	//SignDesc
		} ElseIf $l(Code)=6 {
			Set ^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"x",Code)=SignDesc
		} ElseIf $l(Code)=9 {
			If $d(^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"x",$e(Code,1,6))) {
				Set tmpDesc=$g(^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"x",$e(Code,1,6)))
				Set tmpDesc=$e(tmpDesc,2,$l(tmpDesc))_" : "_SignDesc_" "
				Set ^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"y",$e(Code,1,6))=tmpDesc
				Kill ^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"x",$e(Code,1,6))
			}ElseIf $d(^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"y",$e(Code,1,6))) {
				Set tmpDesc=$g(^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"y",$e(Code,1,6)))
				Set tmpDesc=tmpDesc_SignDesc_" "
				Set ^CacheTemp(ZIndex,JIndex,"PrintSign",$e(Code,1,3),"y",$e(Code,1,6))=tmpDesc
			}
		}
	}
	Do rs.Close()
	Set xCode3=""
	For {
		Set xCode3=$o(^CacheTemp(ZIndex,JIndex,"PrintSign",xCode3))
		Quit:(xCode3="")
		Set row=row+1
		Set frow=row
		Set xType="",tcol=0
		For {
			Set xType=$o(^CacheTemp(ZIndex,JIndex,"PrintSign",xCode3,xType))
			Quit:(xType="")
			Set xCode6="",col=1
			For {
				Set xCode6=$o(^CacheTemp(ZIndex,JIndex,"PrintSign",xCode3,xType,xCode6))
				Quit:(xCode6="")
				If (xType="x") {
					Set col=col+8
					Set:(col>48) row=row+1,col=9
					Set tcol=col+7
				} ElseIf (xType="y") {
					Set row=row+1
					Set col=9
					Set tcol=48
				} Else {
					Continue
				}
				Set xDesc=$g(^CacheTemp(ZIndex,JIndex,"PrintSign",xCode3,xType,xCode6))
				s retval="MergCells(xls,"_row_","_col_","_row_","_tcol_");"
				&javascript<#(retval)#>
				s retval=aItmjs_"(xlSheet,'"_$ZCVT(xDesc,"O","JS")_"',"_row_","_col_");"
				&javascript<#(retval)#>
			}
		}
		s retval="BorderCells(xls,"_frow_","_9_","_row_","_9_",'"_"1"_"');"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_frow_","_48_","_row_","_48_",'"_"2"_"');"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_frow_","_9_","_frow_","_48_",'"_"3"_"');"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_9_","_row_","_48_",'"_"4"_"');"
		&javascript<#(retval)#>
		
		Set xDesc=$g(^CacheTemp(ZIndex,JIndex,"PrintSign",xCode3))
		s retval="MergCells(xls,"_frow_","_1_","_row_","_8_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_frow_","_1_","_row_","_8_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(xDesc,"O","JS")_"',"_frow_",1);"
		&javascript<#(retval)#>
	}
	
	Set row=row+1
	// 就诊前是否使用抗生素
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_14_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"  就诊前是否使用抗生素:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_15_","_row_","_48_");"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(IsUseAntiDesc,"O","JS")_"',"_row_",12);"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(UseAntiDesc,"O","JS")_"',"_row_",25);"
	&javascript<#(retval)#>
	
	// 3.初步诊断
	Set row=row+1
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_8_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"三、初步诊断*:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_9_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_9_","_row_","_48_",'"_"4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(PreDiagnosDrsList,"O","JS")_"',"_row_",9);"
	&javascript<#(retval)#>
	
	// 4.既往病史
	Set row=row+1
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_8_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"四、既往病史:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_9_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_9_","_row_","_48_",'"_"4"_"');"
	&javascript<#(retval)#>*/
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(AnamnesisDrsList,"O","JS")_"',"_row_",9);"
	&javascript<#(retval)#>
	
	// 5.暴露信息
	Set row=row+1
	/*s retval="MergCells(xls,"_row_","_1_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"五、暴露信息"_"',"_row_",1);"
	&javascript<#(retval)#>*/
	
	Set row=row+1	// 表头
	
	/*s retval="MergCells(xls,"_row_","_1_","_(row+1)_","_2_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_(row+1)_","_2_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"序号"_"',"_row_",1);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_3_","_(row+1)_","_8_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_3_","_(row+1)_","_8_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"食品名称*"_"',"_row_",3);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_9_","_(row+1)_","_14_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_9_","_(row+1)_","_14_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"食品品牌"_"',"_row_",9);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_15_","_(row+1)_","_20_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_15_","_(row+1)_","_20_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"生产厂家"_"',"_row_",15);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_21_","_(row+1)_","_25_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_21_","_(row+1)_","_25_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"购买地点*"_"',"_row_",21);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_26_","_(row+1)_","_30_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_26_","_(row+1)_","_30_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"进食场所*"_"',"_row_",26);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_31_","_(row+1)_","_35_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_31_","_(row+1)_","_35_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"进食时间*"_"',"_row_",31);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_36_","_(row+1)_","_38_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_36_","_(row+1)_","_38_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"进食人数*"_"',"_row_",36);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_39_","_(row+1)_","_43_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_39_","_(row+1)_","_43_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"其他人是否发病*"_"',"_row_",39);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_44_","_(row+1)_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_44_","_(row+1)_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"是否采样*"_"',"_row_",44);"
	&javascript<#(retval)#>*/
	
	Set FoodCnt=0
	Set rs=##Class(%ResultSet).%New("DHCMed.FBDService.ReportSrv:QryReportFood")
	Do rs.Execute(aReportID)
	While rs.Next() {
		Set FoodName=rs.Get("FoodName")
		Set FoodBrand=rs.Get("FoodBrand")
		Set Manufacturer=rs.Get("Manufacturer")
		Set WhereToBuy=rs.Get("WhereToBuy")
		Set EatingPlaces=rs.Get("EatingPlaces")
		Set EatingNum=rs.Get("EatingNum")
		Set EatingDT="    年  月  日  时"
		Set EatingDate=rs.Get("EatingDate")
		Set EatingTime=rs.Get("EatingTime")
		/*If (SickDate'="1840-12-31") {
			Set EatingDT=$p(EatingDate,"-",1)_"年"_$p(EatingDate,"-",2)_"月"_$p(EatingDate,"-",3)_"日"_$p(EatingTime,":",1)_"时"
		}*/
		Set:EatingDate'="" EatingDT=EatingDate_" "_$p(EatingTime,":",1)_"时"
		
		Set (IsIncidenceDesc,IsSamplingDesc)=chkN_"是"_chkN_"否"
		Set IsIncidence=rs.Get("IsIncidence")
		Set IsIncidence=$s(+IsIncidence=1:"是",1:"否")
		Set $e(IsIncidenceDesc,$f(IsIncidenceDesc,IsIncidence)-2)=chkY
		Set IsSampling=rs.Get("IsSampling")
		Set IsSampling=$s(+IsSampling=1:"是",1:"否")
		Set $e(IsSamplingDesc,$f(IsSamplingDesc,IsSampling)-2)=chkY
		Set row=row+2,FoodCnt=FoodCnt+1
		//处理多行数据打印保存问题
		s retval="MergCells(xls,"_row_","_1_","_(row+1)_","_2_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(FoodCnt,"O","JS")_"',"_row_",1);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_3_","_(row+1)_","_8_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(FoodName,"O","JS")_"',"_row_",3);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_9_","_(row+1)_","_14_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(FoodBrand,"O","JS")_"',"_row_",9);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_15_","_(row+1)_","_20_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(Manufacturer,"O","JS")_"',"_row_",15);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_21_","_(row+1)_","_25_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(WhereToBuy,"O","JS")_"',"_row_",21);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_26_","_(row+1)_","_30_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(EatingPlaces,"O","JS")_"',"_row_",26);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_31_","_(row+1)_","_35_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(EatingDT,"O","JS")_"',"_row_",31);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_36_","_(row+1)_","_38_");"
		&javascript<#(retval)#>
			s retval=aItmjs_"(xlSheet,'"_$ZCVT(EatingNum,"O","JS")_"',"_row_",36);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_39_","_(row+1)_","_43_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(IsIncidenceDesc,"O","JS")_"',"_row_",39);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_44_","_(row+1)_","_48_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(IsSamplingDesc,"O","JS")_"',"_row_",44);"
		&javascript<#(retval)#>
		
		s retval="BorderCells(xls,"_row_","_1_","_(row+1)_","_48_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
	
	}
	Do rs.Close()
	
	Set row=row+1
	While (FoodCnt<2) {   //没有暴露信息
		Set row=row+1
		Set FoodCnt=FoodCnt+1
		s retval="MergCells(xls,"_row_","_1_","_row_","_2_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_1_","_row_","_2_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_3_","_row_","_8_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_3_","_row_","_8_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_9_","_row_","_14_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_9_","_row_","_14_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_15_","_row_","_20_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_15_","_row_","_20_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_21_","_row_","_25_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_21_","_row_","_25_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_26_","_row_","_30_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_26_","_row_","_30_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_31_","_row_","_35_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_31_","_row_","_35_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_36_","_row_","_38_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_36_","_row_","_38_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_39_","_row_","_43_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_39_","_row_","_43_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_44_","_row_","_48_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_44_","_row_","_48_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
	}
	
	// 6.生物样本采集
	Set row=row+1
	s retval="MergCells(xls,"_row_","_1_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"六、生物样本采集"_"',"_row_",1);"
	&javascript<#(retval)#>
	
	Set row=row+1	// 表头
	
	s retval="MergCells(xls,"_row_","_1_","_(row+1)_","_2_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"序号"_"',"_row_",1);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_3_","_(row+1)_","_11_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"样本编号"_"',"_row_",3);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_12_","_(row+1)_","_27_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"样本类型"_"',"_row_",12);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_28_","_(row+1)_","_30_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"样本数量"_"',"_row_",28);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_31_","_(row+1)_","_36_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"单位"_"',"_row_",31);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_37_","_(row+1)_","_43_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"采样日期"_"',"_row_",37);"
	&javascript<#(retval)#>
	
	s retval="MergCells(xls,"_row_","_44_","_(row+1)_","_48_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"备注"_"',"_row_",44);"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_1_","_(row+1)_","_48_",'"_"1#2#3#4"_"');"
	&javascript<#(retval)#>
	
	Set row=row+1
	Set SampleType=""	//样本类型
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("FBDSampleType","1")
	While rs.Next() {
		Set SampleTypeID=rs.Get("myid")
		Set SampleTypeDesc=rs.Get("Description")
		Set SampleType=SampleType_SampleTypeID_":"_SampleTypeDesc_","
	}
	Set SampleType=$e(SampleType,1,$l(SampleType)-1)
	Do rs.Close()
	Set SampleUnit=""	//样本单位
	Set rs=##Class(%ResultSet).%New("DHCMed.SSService.DictionarySrv:QryDictionary")
	Do rs.Execute("FBDSampleUnit","1")
	While rs.Next() {
		Set SampleUnitID=rs.Get("myid")
		Set SampleUnitDesc=rs.Get("Description")
		Set SampleUnit=SampleUnit_SampleUnitID_":"_SampleUnitDesc_","
	}
	Set SampleUnit=$e(SampleUnit,1,$l(SampleUnit)-1)
	Do rs.Close()
	Set SampleCnt=0
	Set rs=##Class(%ResultSet).%New("DHCMed.FBDService.ReportSrv:QryReportSample")
	Do rs.Execute(aReportID)
	While rs.Next() {
		Set SampleNo=rs.Get("SampleNo")
		Set SampleTypeID=rs.Get("SampleTypeID")
		//Set SampleTypeDesc=rs.Get("SampleTypeDesc")
		Set SampleTypeDesc=""
		For IndType=1:1:$l(SampleType,",") {
			Set tmpType=$p(SampleType,",",IndType)
			Set tmpTypeID=$p(tmpType,":",1)
			Set tmpTypeDesc=$p(tmpType,":",2)
			Set tmpChk=$s(SampleTypeID=tmpTypeID:chkY,1:chkN)
			Set SampleTypeDesc=SampleTypeDesc_tmpChk_tmpTypeDesc	//_" "
		}
		//Set:(SampleTypeDesc'="") SampleTypeDesc=$e(SampleTypeDesc,1,$l(SampleTypeDesc)-1)
		Set SampleNumber=rs.Get("SampleNumber")
		Set SampleUnitID=rs.Get("SampleUnitID")
		//Set SampleUnitDesc=rs.Get("SampleUnitDesc")
		Set SampleUnitDesc=""
		For IndUnit=1:1:$l(SampleUnit,",") {
			Set tmpUnit=$p(SampleUnit,",",IndUnit)
			Set tmpUnitID=$p(tmpUnit,":",1)
			Set tmpUnitDesc=$p(tmpUnit,":",2)
			Set tmpChk=$s(SampleUnitID=tmpUnitID:chkY,1:chkN)
			Set SampleUnitDesc=SampleUnitDesc_tmpChk_tmpUnitDesc	//_" "
		}
		//Set:(SampleUnitDesc'="") SampleUnitDesc=$e(SampleUnitDesc,1,$l(SampleUnitDesc)-1)
		Set SampleDate=rs.Get("SampleDate")
		/*Set SampleDT="    年  月  日"
		If (SampleDate'="1840-12-31") {
			Set SampleDT=$p(SampleDate,"-",1)_"年"_$p(SampleDate,"-",2)_"月"_$p(SampleDate,"-",3)_"日"
		}*/
		Set SampleDT=SampleDate
		Set Resume=rs.Get("Resume")
		Set row=row+1,SampleCnt=SampleCnt+1
		//row-->(row+1) //内容超长，自动换行处理
		s retval="MergCells(xls,"_row_","_1_","_(row+1)_","_2_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(SampleCnt,"O","JS")_"',"_row_",1);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_3_","_(row+1)_","_11_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(SampleNo,"O","JS")_"',"_row_",3);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_12_","_(row+1)_","_27_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(SampleTypeDesc,"O","JS")_"',"_row_",12);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_28_","_(row+1)_","_30_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(SampleNumber,"O","JS")_"',"_row_",28);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_31_","_(row+1)_","_36_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(SampleUnitDesc,"O","JS")_"',"_row_",31);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_37_","_(row+1)_","_43_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(SampleDT,"O","JS")_"',"_row_",37);"
		&javascript<#(retval)#>
		//
		s retval="MergCells(xls,"_row_","_44_","_(row+1)_","_48_");"
		&javascript<#(retval)#>
		s retval=aItmjs_"(xlSheet,'"_$ZCVT(Resume,"O","JS")_"',"_row_",44);"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_1_","_(row+1)_","_48_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
		Set row=row+1    //合并单元格后，多行数据时行需+1

	}
	Do rs.Close()
	
	While (SampleCnt<2) {   //没有生物采集信息
		Set row=row+1
		Set SampleCnt=SampleCnt+1
		s retval="MergCells(xls,"_row_","_1_","_row_","_2_");"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_3_","_row_","_11_");"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_12_","_row_","_27_");"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_28_","_row_","_30_");"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_31_","_row_","_36_");"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_37_","_row_","_43_");"
		&javascript<#(retval)#>
		s retval="MergCells(xls,"_row_","_44_","_row_","_48_");"
		&javascript<#(retval)#>
		s retval="BorderCells(xls,"_row_","_1_","_row_","_48_",'"_"1#2#3#4"_"');"
		&javascript<#(retval)#>
	}
	
	// 7.病例附件
	Set row=row+1
	s retval="MergCells(xls,"_row_","_1_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"七、病例附件"_"',"_row_",1);"
	&javascript<#(retval)#>
	
	// 8.填报机构信息
	Set row=row+1
	s retval="MergCells(xls,"_row_","_1_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"八、填报机构信息"_"',"_row_",1);"
	&javascript<#(retval)#>
	
	Set row=row+1
	//
	s retval="MergCells(xls,"_row_","_1_","_row_","_7_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"医疗机构名称*:"_"',"_row_",1);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_9_","_row_","_20_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_9_","_row_","_20_",'"_"4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(HospitalDesc,"O","JS")_"',"_row_",9);"
	&javascript<#(retval)#>
	//
	s retval="MergCells(xls,"_row_","_22_","_row_","_25_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"填表人:"_"',"_row_",22);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_27_","_row_","_32_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_27_","_row_","_32_",'"_"4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(RepUserName,"O","JS")_"',"_row_",27);"
	&javascript<#(retval)#>
	//
	s retval="MergCells(xls,"_row_","_34_","_row_","_38_");"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_"填写日期:"_"',"_row_",34);"
	&javascript<#(retval)#>
	s retval="MergCells(xls,"_row_","_40_","_row_","_48_");"
	&javascript<#(retval)#>
	s retval="BorderCells(xls,"_row_","_40_","_row_","_48_",'"_"4"_"');"
	&javascript<#(retval)#>
	s retval=aItmjs_"(xlSheet,'"_$ZCVT(ReportDT,"O","JS")_"',"_row_",40);"
	&javascript<#(retval)#>
	
	Kill ^CacheTemp(ZIndex,JIndex,"PrintSign")
	Quit return
}

}
