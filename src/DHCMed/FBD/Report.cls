/// 名称 : DHCMed.FBD.Report
/// 说明 : 食源性疾病病例监测信息表主表
Class DHCMed.FBD.Report Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildSign As DHCMed.FBD.ReportSign [ Cardinality = children, Inverse = Parref ];

Relationship ChildFood As DHCMed.FBD.ReportFood [ Cardinality = children, Inverse = Parref ];

Relationship ChildSample As DHCMed.FBD.ReportSample [ Cardinality = children, Inverse = Parref ];

/// 就诊号
Property FREpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 基本信息
Property FRPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 食源性疾病
Property FRDiseaseDr As DHCMed.SS.Disease;

/// 食源性疾病备注
Property FRDiseaseText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态("FBDRepStatus")
Property FRStatusDr As DHCMed.SS.Dictionary;

/// 病例编号/卡片编号
Property FRCardNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人基本信息
Property FRPatientObj As DHCMed.FBD.ReportPat;

/// 是否住院
Property FRIsInHosp As %Boolean;

/// 监护人/联系人姓名
Property FRContactor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系方式/联系电话
Property FRTelephone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 单位/工作单位
Property FRCompany As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人属于/所属区域
Property FRAreaDr As DHCMed.SS.Dictionary;

/// 现住址
Property FRCurrAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址省 指向DHCMed.SS.AreaDic
Property FRCurrProvince As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址市 指向DHCMed.SS.AreaDic
Property FRCurrCity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址县 指向DHCMed.SS.AreaDic
Property FRCurrCounty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址乡 指向DHCMed.SS.AreaDic
Property FRCurrVillage As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址街道
Property FRCurrRoad As %String(MAXLEN = 100, TRUNCATE = 1);

/// 患者职业("FBDOccupation")
Property FROccupationDr As DHCMed.SS.Dictionary;

/// 发病日期
Property FRSickDate As %Date;

/// 发病时间
Property FRSickTime As %Time;

/// 就诊日期
Property FRAdmitDate As %Date;

/// 就诊时间
Property FRAdmitTime As %Time;

/// 死亡日期
Property FRDeathDate As %Date;

/// 死亡时间
Property FRDeathTime As %Time;

/// 就诊前是否使用抗生素
Property FRIsUseAnti As %Boolean;

/// 就诊前使用抗生素名称
Property FRUseAntiDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 初步诊断
Property FRPreDiagnos As %String(MAXLEN = 500, TRUNCATE = 1);

/// 既往病史
Property FRAnamnesis As %String(MAXLEN = 500, TRUNCATE = 1);

/// 报告科室 指向CT_Loc
Property FRReportLoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 填表人 指向SS_User
Property FRReportUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 填写日期
Property FRReportDate As %Date;

/// 填写时间
Property FRReportTime As %Time;

/// 审核人 指向SS_User
Property FRCheckUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 审核日期
Property FRCheckDate As %Date;

/// 审核时间
Property FRCheckTime As %Time;

/// 备注
Property FRResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// add 2019-01-10
/// 初步诊断多选
Property FRPreDiagnosDrs As list Of DHCMed.SS.Dictionary;

/// 既往病史多选
Property FRAnamnesisDrs As list Of DHCMed.SS.Dictionary;

/// 检测结果
Property FRExamResult As %String(MAXLEN = 500, TRUNCATE = 1);

/// 接诊医生
Property FRAdmDoctor As %String(MAXLEN = 500, TRUNCATE = 1);

/// 以就诊号为索引
Index IndexEpisodeID On FREpisodeID;

/// 以基本信息为索引
Index IndexPatientID On FRPatientID;

/// 以食源性疾病为索引
Index IndexDisease On FRDiseaseDr;

/// 以填写日期为索引
Index IndexReportDate On (FRReportDate, FRReportTime);

/// 以审核日期为索引
Index IndexCheckDate On (FRCheckDate, FRCheckTime);

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  取食源性疾病信息
/// Table：       DHCMed.FBD.Report
/// Input：       Id : DHCMed.FBD.Report.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.Report).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.Report
{
	New (aID)
	Quit:'##class(DHCMed.FBD.Report).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.Report).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

Method ToString(separete As %String, Languages As %String = "") As %String
{
	new (separete,Languages)
	Set return = ..FREpisodeID_separete
	Set return = return_..FRPatientID_separete
	Set return = return_##class(DHCMed.SS.Disease).GetDiseaseByObj(..FRDiseaseDr,Languages)_separete
	Set return = return_..FRDiseaseText_separete
	Set return = return_..GetDicByObj(..FRStatusDr,Languages)_separete  //5
	Set return = return_..FRCardNo_separete
	Set return = return_..FRPatientObj_separete
	Set return = return_..FRIsInHosp_separete
	Set return = return_..FRContactor_separete
	Set return = return_..FRTelephone_separete               //10
	Set return = return_..FRCompany_separete
	Set return = return_..GetDicByObj(..FRAreaDr,Languages)_separete
	Set return = return_..FRCurrAddress_separete	
	Set CurrProvince = ..FRCurrProvince             
	Set CurrCity     = ..FRCurrCity             
	Set CurrCounty   = ..FRCurrCounty
	Set CurrVillage  = ..FRCurrVillage   
	Set return = return_##class(DHCMed.FBD.Report).GetAreaIdByDesc(CurrProvince,CurrCity,CurrCounty,CurrVillage,separete,Languages)_separete
	Set return = return_..FRCurrRoad_separete
	Set return = return_..GetDicByObj(..FROccupationDr,Languages)_separete
	
	Set SickDate=..FRSickDate                                //20
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set return=return_SickDate_separete
	Set SickTime=..FRSickTime
	Set:SickTime'="" SickTime=$zt(SickTime,1)
	Set return=return_SickTime_separete                       

	Set AdmitDate=..FRAdmitDate
	Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
	Set return=return_AdmitDate_separete
	Set AdmitTime=..FRAdmitTime
	Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	Set return=return_AdmitTime_separete
	
	Set DeathDate=..FRDeathDate
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	Set return=return_DeathDate_separete
	Set DeathTime=..FRDeathTime
	Set:DeathTime'="" DeathTime=$zt(DeathTime,1)
	Set return=return_DeathTime_separete                      //25
	
	Set return = return_..FRIsUseAnti_separete               
	Set return = return_..FRPreDiagnos_separete
	Set return = return_..FRAnamnesis_separete

	Set ReportLocID=..FRReportLoc
	Set ReportLocDesc=$p($g(^CTLOC(+ReportLocID)),"^",2)
	Set:$p(ReportLocDesc,"-",2)'="" ReportLocDesc=$p(ReportLocDesc,"-",2)
	Set ReportLocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,ReportLocDesc)
	
	Set return=return_ReportLocID_separete_ReportLocDesc_separete	 //30
	
	Set ReportUser=..FRReportUser
	Set ReportUserDesc = ""
	If (ReportUser'=""){
		Set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUser)
		If ($IsObject(objUser)){
			Set ReportUserDesc=objUser.Name
			Set ReportUserDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,ReportUserDesc)
		}
	}
	Set return=return_ReportUser_separete_ReportUserDesc_separete                   
	
	Set ReportDate=..FRReportDate
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set return=return_ReportDate_separete
	Set ReportTime=..FRReportTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
	Set return=return_ReportTime_separete

	Set CheckUser=..FRCheckUser
	Set CheckUserDesc = ""
	If (CheckUser'=""){
		Set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+CheckUser)
		If ($IsObject(objUser)){
			Set CheckUserDesc=objUser.Name
			Set CheckUserDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,CheckUserDesc)
		}
	}
	Set return=return_CheckUser_separete_CheckUserDesc_separete  //36
		
	Set CheckDate=..FRCheckDate
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set return=return_CheckDate_separete
	Set CheckTime=..FRCheckTime                            
	Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	Set return=return_CheckTime_separete
	
	Set return = return_..FRResume_separete
	Set return = return_..FRUseAntiDesc_separete                 //40
	
	Set PreDiagnosDrs=..FRPreDiagnosDrs                              //41初步诊断
	Set PreDiagnosDrsList=""
	For ind=1:1:PreDiagnosDrs.Count() {
		Set objDic=PreDiagnosDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set PreDiagnosDrsList=PreDiagnosDrsList_","_objDic.%Id()
	}
	Set:PreDiagnosDrsList'="" PreDiagnosDrsList=$e(PreDiagnosDrsList,2,$l(PreDiagnosDrsList))
	Set return=return_PreDiagnosDrsList_separete
	
	Set AnamnesisDrs=..FRAnamnesisDrs                             //42既往病史
	Set AnamnesisDrsList=""
	For ind=1:1:AnamnesisDrs.Count() {
		Set objDic=AnamnesisDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set AnamnesisDrsList=AnamnesisDrsList_","_objDic.%Id()
	}
	Set:AnamnesisDrsList'="" AnamnesisDrsList=$e(AnamnesisDrsList,2,$l(AnamnesisDrsList))
	Set return=return_AnamnesisDrsList_separete 
	Set return=return_..FRExamResult  _separete                
	Set return=return_..FRAdmDoctor  _separete 
	
	quit return
}

/// Creator:      pylian
/// CreatDate:    2018-10-17
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.FBD.Report
/// Input：       ID:    DHCMed.FBD.Report.ID
/// Return：      返回String
/// w ##class(DHCMed.FBD.Report).GetStringById(18)
ClassMethod GetStringById(aID As %String) As %String
{
	new (aID,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:aID="" return
	
	set obj=##Class(DHCMed.FBD.Report).GetObjById(+aID)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator:      pylian
/// CreatDate:    2018-10-18
/// Description:  根据省市县乡描述获取省市县乡ID
/// Table：       DHCMed.FBD.Report
/// Input：       ID:    DHCMed.FBD.Report.ID
/// Return：      返回String
/// w ##class(DHCMed.FBD.Report).GetAreaIdByDesc("北京市","市辖区","东城区","东华门街道","^")
ClassMethod GetAreaIdByDesc(aProvince As %String, aCity As %String, aCounty As %String, aVillage As %String, aseparete As %String, Languages As %String = "") As %String
{
	New (aProvince,aCity,aCounty,aVillage,aseparete,Languages)
	Set return= ""_$c(1)_aProvince_aseparete_""_$c(1)_aCity_aseparete_""_$c(1)_aCounty_aseparete_""_$c(1)_aVillage  //返回字符串位置固定
	
	//Quit:(aProvince="")||(aCity="")||(aCounty="")||(aVillage="") return

	
    Set (ProvinceID,CityID,CountyID,VillageID)=""
    Set (ProvinceCode,CityCode,CountyCode,VillageCode)=""
	For ind1=10:1:99 {
		Set Code1=ind1
		Set Code1=Code1_"000000"
		
		Set xPID=$o(^DHCMed.SS.AreaDicI("CodeIndex"," "_Code1,0))
		Continue:xPID=""
		Set objPro=##Class(DHCMed.SS.AreaDic).GetObjById(xPID)
		Continue:'$IsObject(objPro)
		Set IsActive=objPro.IsActive
		Continue:IsActive'=1
		Continue:(aProvince="")
		Continue:((aProvince'="")&&($e(objPro.ShortDesc,1,$l(aProvince))'[aProvince))
		Set ProvinceID = xPID
		Set ProvinceCode = objPro.Code
	}

	For ind2=1:1:99 {
		Set Code2=ind2
		Set:$l(Code2)<2 Code2="0"_Code2
		Set Code2=$e(ProvinceCode,1,2)_Code2_"0000"
		
		Set xCID=$o(^DHCMed.SS.AreaDicI("CodeIndex"," "_Code2,0))
		Continue:xCID=""
		Set objCity=##Class(DHCMed.SS.AreaDic).GetObjById(xCID)
		Continue:'$IsObject(objCity)
		Set IsActive=objCity.IsActive
		Continue:IsActive'=1
		Continue:(aCity="")
		Continue:((aCity'="")&&($e(objCity.ShortDesc,1,$l(aCity))'[aCity))
		Set CityID = xCID
		Set CityCode = objCity.Code
	}
	
	For ind3=1:1:99 {
		Set Code3=ind3
		Set:$l(Code3)<2 Code3="0"_Code3
		Set Code3=$e(CityCode,1,4)_Code3_"00"
		
		Set xTID=$o(^DHCMed.SS.AreaDicI("CodeIndex"," "_Code3,0))
		Continue:xTID=""
		Set objCounty=##Class(DHCMed.SS.AreaDic).GetObjById(xTID)
		Continue:'$IsObject(objCounty)
		Set IsActive=objCounty.IsActive
		Continue:IsActive'=1
		Continue:(aCounty="")
		
		Continue:((aCounty'="")&&($e(objCounty.ShortDesc,1,$l(aCounty))'[aCounty))
		Set CountyID = xTID
		Set CountyCode = objCounty.Code
	}
	
	For ind4=1:1:99 {
		Set Code4=ind4
		Set:$l(Code4)<2 Code4="0"_Code4
		Set Code4=$e(CountyCode,1,6)_Code4
		
		Set xVID=$o(^DHCMed.SS.AreaDicI("CodeIndex"," "_Code4,0))
		Continue:xVID=""
		Set objVillage=##Class(DHCMed.SS.AreaDic).GetObjById(xVID)
		Continue:'$IsObject(objVillage)
		Set IsActive=objVillage.IsActive
		Continue:IsActive'=1
		Continue:(aVillage="")
	
		Continue:((aVillage'="")&&($e(objVillage.ShortDesc,1,$l(aVillage))'[aVillage))
	    Set VillageID = xVID
	    Set VillageCode = objVillage.Code
	}

	Set return = ProvinceID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,aProvince)_aseparete_CityID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,aCity)_aseparete_CountyID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,aCounty)_aseparete_VillageID_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,aVillage)		
	Quit return
}

ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  更新食源性疾病信息
/// Table：       DHCMed.FBD.Report
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.Report).Update("","","")
ClassMethod Update(aInputStr As %String, aSeparate As %String, aSepObj As %String) As %String
{
	New (aInputStr,aSeparate,aSepObj)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID=$p(aInputStr,aSeparate,1)
	Set EpisodeID=$p(aInputStr,aSeparate,2)
	Set PatientID=$p(aInputStr,aSeparate,3)
	Set DiseaseID=$p(aInputStr,aSeparate,4)
	Set DiseaseText=$p(aInputStr,aSeparate,5)
	Set StatusID=$p(aInputStr,aSeparate,6)
	Set CardNo=$p(aInputStr,aSeparate,7)
	Set PatientObj=$p(aInputStr,aSeparate,8)
	Set IsInHosp=$p(aInputStr,aSeparate,9)
	Set Contactor=$p(aInputStr,aSeparate,10)
	Set Telephone=$p(aInputStr,aSeparate,11)
	Set Company=$p(aInputStr,aSeparate,12)
	Set AreaID=$p(aInputStr,aSeparate,13)
	Set CurrAddress=$p(aInputStr,aSeparate,14)
	Set CurrProvince=$p(aInputStr,aSeparate,15)
	Set CurrCity=$p(aInputStr,aSeparate,16)
	Set CurrCounty=$p(aInputStr,aSeparate,17)
	Set CurrVillage=$p(aInputStr,aSeparate,18)
	Set CurrRoad=$p(aInputStr,aSeparate,19)
	Set OccupationID=$p(aInputStr,aSeparate,20)
	Set SickDate=$p(aInputStr,aSeparate,21)
	Set SickTime=$p(aInputStr,aSeparate,22)
	Set AdmitDate=$p(aInputStr,aSeparate,23)
	Set AdmitTime=$p(aInputStr,aSeparate,24)
	Set DeathDate=$p(aInputStr,aSeparate,25)
	Set DeathTime=$p(aInputStr,aSeparate,26)
	Set IsUseAnti=$p(aInputStr,aSeparate,27)
	Set PreDiagnos=$p(aInputStr,aSeparate,28)
	Set Anamnesis=$p(aInputStr,aSeparate,29)
	Set ReportLoc=$p(aInputStr,aSeparate,30)
	Set ReportUser=$p(aInputStr,aSeparate,31)
	Set ReportDate=$p(aInputStr,aSeparate,32)
	Set ReportTime=$p(aInputStr,aSeparate,33)
	Set CheckUser=$p(aInputStr,aSeparate,34)
	Set CheckDate=$p(aInputStr,aSeparate,35)
	Set CheckTime=$p(aInputStr,aSeparate,36)
	Set Resume=$p(aInputStr,aSeparate,37)
	Set UseAntiDesc=$p(aInputStr,aSeparate,38)
	Set ExamResult=$p(aInputStr,aSeparate,41)
	Set DiagDoc=$p(aInputStr,aSeparate,42)
	Quit:(EpisodeID="")||(PatientID="")||(ReportLoc="")||(StatusID="") return
	Set PatientObj=##class(DHCMed.FBD.ReportPat).GetPatObj(PatientObj,aSepObj)
	Quit:'$IsObject(PatientObj) return
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	//Quit:(DiseaseID="")||(AreaID="")||(OccupationID="") return
	Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
	Set objArea=##class(DHCMed.SS.Dictionary).GetObjById(AreaID)
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetObjById(OccupationID)
	If (objStatus.Code<3) {
		Quit:'$IsObject(objDisease) return
		Quit:'$IsObject(objArea) return
		Quit:'$IsObject(objOccupation) return
	}
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SickDate)
	Set:(SickTime[":") SickTime=$zth(SickTime,1)
	Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AdmitDate)
	Set:(AdmitTime[":") AdmitTime=$zth(AdmitTime,1)
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DeathDate)
	Set:(DeathTime[":") DeathTime=$zth(DeathTime,1)
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ReportDate)
	Set:(ReportDate="") ReportDate=+$p($h,",",1)
	Set:(ReportTime="") ReportTime=+$p($h,",",2)
	Set:(ReportTime[":") ReportTime=$zth(ReportTime,1)
	//Set:(CheckDate="") CheckDate=+$p($h,",",1)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
	//Set:(CheckTime="") CheckTime=+$p($h,",",2)
	Set:(CheckTime[":") CheckTime=$zth(CheckTime,1)
	If (ID="") {
		Set obj=##class(DHCMed.FBD.Report).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.Report).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.FREpisodeID=EpisodeID
	Set obj.FRPatientID=PatientID
	Set obj.FRDiseaseDr=objDisease
	Set obj.FRDiseaseText=DiseaseText
	Set obj.FRStatusDr=objStatus
	Set obj.FRCardNo=CardNo
	Set obj.FRPatientObj=PatientObj
	Set obj.FRIsInHosp=IsInHosp
	Set obj.FRContactor=Contactor
	Set obj.FRTelephone=Telephone
	Set obj.FRCompany=Company
	Set obj.FRAreaDr=objArea
	Set obj.FRCurrAddress=CurrAddress
	Set obj.FRCurrProvince=CurrProvince
	Set obj.FRCurrCity=CurrCity
	Set obj.FRCurrCounty=CurrCounty
	Set obj.FRCurrVillage=CurrVillage
	Set obj.FRCurrRoad=CurrRoad
	Set obj.FROccupationDr=objOccupation
	Set obj.FRSickDate=SickDate
	Set obj.FRSickTime=SickTime
	Set obj.FRAdmitDate=AdmitDate
	Set obj.FRAdmitTime=AdmitTime
	Set obj.FRDeathDate=DeathDate
	Set obj.FRDeathTime=DeathTime
	Set obj.FRIsUseAnti=IsUseAnti
	Set obj.FRPreDiagnos=PreDiagnos
	Set obj.FRAnamnesis=Anamnesis
	Set obj.FRReportLoc=ReportLoc
	Set obj.FRReportUser=ReportUser
	Set:obj.FRReportDate="" obj.FRReportDate=ReportDate
	Set:obj.FRReportTime="" obj.FRReportTime=ReportTime
	Set obj.FRCheckUser=CheckUser
	Set obj.FRCheckDate=CheckDate
	Set obj.FRCheckTime=CheckTime
	Set obj.FRResume=Resume
	Set obj.FRUseAntiDesc=UseAntiDesc
	Set obj.FRExamResult=ExamResult
	Set obj.FRAdmDoctor=DiagDoc
	
	Set PreDiagnosDrs=$p(aInputStr,aSeparate,39)	        //初步诊断多选
	While (obj.FRPreDiagnosDrs.Count()>0) {
		Do obj.FRPreDiagnosDrs.RemoveAt(1)
	}
	Set PreDiagnosList=""
	For ind=1:1:$length(PreDiagnosDrs,",") {
		Set PreDiagnosDr=$p(PreDiagnosDrs,",",ind)
		Continue:($listfind(PreDiagnosList,PreDiagnosDr)>0)
		Set PreDiagnosList=PreDiagnosList_$lb(PreDiagnosDr)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(PreDiagnosDr)
		Continue:'$IsObject(objDic)
		Do obj.FRPreDiagnosDrs.Insert(objDic)
	}
	Set sc=obj.%Save()
	
	Set AnamnesisDrs=$p(aInputStr,aSeparate,40)	        //既往病史多选
	While (obj.FRAnamnesisDrs.Count()>0) {
		Do obj.FRAnamnesisDrs.RemoveAt(1)
	}
	Set AnamnesisList=""
	For ind=1:1:$length(AnamnesisDrs,",") {
		Set AnamnesisDr=$p(AnamnesisDrs,",",ind)
		Continue:($listfind(AnamnesisList,AnamnesisDrs)>0)
		Set AnamnesisList=AnamnesisList_$lb(AnamnesisDr)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(AnamnesisDr)
		Continue:'$IsObject(objDic)
		Do obj.FRAnamnesisDrs.Insert(objDic)
	}
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  删除食源性疾病信息
/// Table：       DHCMed.FBD.Report
/// Input：       Id : DHCMed.FBD.Report.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.Report).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.Report).%DeleteId(aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// update status user
ClassMethod UpdateStatus(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID=$p(aInputStr,aSeparate,1)
	Set StatusID=$p(aInputStr,aSeparate,2)
	Set CheckUser=$p(aInputStr,aSeparate,3)
	Set CheckDate=$p(aInputStr,aSeparate,4)
	Set CheckTime=$p(aInputStr,aSeparate,5)
	Set Resume=$p(aInputStr,aSeparate,6)
	Quit:(ID="") return
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
	Set:(CheckDate="") CheckDate=+$p($h,",",1)
	Set:(CheckTime="") CheckTime=+$p($h,",",2)
	Set:(CheckTime[":") CheckTime=$zth(CheckTime,1)
	//fix bug 208716 非审核操作保存状态时 不存审核人、审核日期、审核时间
	if (objStatus.Code'=2) {
		Set CheckUser=""
		Set CheckDate=""
		Set CheckTime=""
	}
	If (ID="") {
		Set obj=##class(DHCMed.FBD.Report).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.Report).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.FRStatusDr=objStatus
	Set obj.FRCheckUser=CheckUser
	Set obj.FRCheckDate=+CheckDate
	Set obj.FRCheckTime=+CheckTime
	Set obj.FRResume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FREpisodeID</Value>
</Value>
<Value name="3">
<Value>FRPatientID</Value>
</Value>
<Value name="4">
<Value>FRDiseaseDr</Value>
</Value>
<Value name="5">
<Value>FRDiseaseText</Value>
</Value>
<Value name="6">
<Value>FRStatusDr</Value>
</Value>
<Value name="7">
<Value>FRCardNo</Value>
</Value>
<Value name="8">
<Value>FRPatientObj</Value>
</Value>
<Value name="9">
<Value>FRIsInHosp</Value>
</Value>
<Value name="10">
<Value>FRContactor</Value>
</Value>
<Value name="11">
<Value>FRTelephone</Value>
</Value>
<Value name="12">
<Value>FRCompany</Value>
</Value>
<Value name="13">
<Value>FRAreaDr</Value>
</Value>
<Value name="14">
<Value>FRCurrAddress</Value>
</Value>
<Value name="15">
<Value>FRCurrProvince</Value>
</Value>
<Value name="16">
<Value>FRCurrCity</Value>
</Value>
<Value name="17">
<Value>FRCurrCounty</Value>
</Value>
<Value name="18">
<Value>FRCurrVillage</Value>
</Value>
<Value name="19">
<Value>FRCurrRoad</Value>
</Value>
<Value name="20">
<Value>FROccupationDr</Value>
</Value>
<Value name="21">
<Value>FRSickDate</Value>
</Value>
<Value name="22">
<Value>FRSickTime</Value>
</Value>
<Value name="23">
<Value>FRAdmitDate</Value>
</Value>
<Value name="24">
<Value>FRAdmitTime</Value>
</Value>
<Value name="25">
<Value>FRDeathDate</Value>
</Value>
<Value name="26">
<Value>FRDeathTime</Value>
</Value>
<Value name="27">
<Value>FRIsUseAnti</Value>
</Value>
<Value name="28">
<Value>FRPreDiagnos</Value>
</Value>
<Value name="29">
<Value>FRAnamnesis</Value>
</Value>
<Value name="30">
<Value>FRReportLoc</Value>
</Value>
<Value name="31">
<Value>FRReportUser</Value>
</Value>
<Value name="32">
<Value>FRReportDate</Value>
</Value>
<Value name="33">
<Value>FRReportTime</Value>
</Value>
<Value name="34">
<Value>FRCheckUser</Value>
</Value>
<Value name="35">
<Value>FRCheckDate</Value>
</Value>
<Value name="36">
<Value>FRCheckTime</Value>
</Value>
<Value name="37">
<Value>FRResume</Value>
</Value>
<Value name="38">
<Value>FRUseAntiDesc</Value>
</Value>
<Value name="39">
<Value>FRPreDiagnosDrs</Value>
</Value>
<Value name="40">
<Value>FRAnamnesisDrs</Value>
</Value>
<Value name="41">
<Value>FRExamResult</Value>
</Value>
<Value name="42">
<Value>FRAdmDoctor</Value>
</Value>
</Data>
<DataLocation>^DHCMed.FBD.ReportD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.FBD.ReportD</IdLocation>
<IndexLocation>^DHCMed.FBD.ReportI</IndexLocation>
<StreamLocation>^DHCMed.FBD.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
