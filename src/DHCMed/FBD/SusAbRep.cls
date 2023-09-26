/// 名称 : DHCMed.FBD.SusAbRep
/// 说明 : 疑似食源性异常病例∕异常健康事件报告卡
Class DHCMed.FBD.SusAbRep Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildSign As DHCMed.FBD.SusAbRepSign [ Cardinality = children, Inverse = Parref ];

/// 就诊号
Property FREpisodeID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 基本信息
Property FRPatientID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主要诊断
Property FRDiseaseDr As DHCMed.SS.Disease;

/// 主要诊断备注
Property FRDiseaseText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告状态("FBDSusAbRepStatus")
Property FRStatusDr As DHCMed.SS.Dictionary;

/// 病例编号/卡片编号
Property FRCardNo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 病人基本信息
Property FRPatientObj As DHCMed.FBD.ReportPat;

/// 是否住院
Property FRIsInHosp As %Boolean;

/// 证件类型
Property FRCardTypeDR As DHCMed.SS.Dictionary;

/// 证件号码
Property FRIdentify As %String(TRUNCATE = 1);

/// 监护人/联系人姓名
Property FRContactor As %String(MAXLEN = 100, TRUNCATE = 1);

/// 联系方式/联系电话
Property FRTelephone As %String(MAXLEN = 100, TRUNCATE = 1);

/// 固定电话
Property FRFixedTel As %String(MAXLEN = 500, TRUNCATE = 1);

/// 户口地址
Property FRRegAddress As %String(TRUNCATE = 1);

/// 户籍地 省
Property FRRegProvinceDr As DHCMed.SS.AreaDic;

/// 户籍地 市
Property FRRegCityDr As DHCMed.SS.AreaDic;

/// 户籍地 县（区）
Property FRRegCountyDr As DHCMed.SS.AreaDic;

/// 户籍地 乡
Property FRRegVillageDr As DHCMed.SS.AreaDic;

/// 户籍地 小区（村）
Property FRRegRoad As %String(TRUNCATE = 1);

/// 现住址
Property FRCurrAddress As %String(MAXLEN = 100, TRUNCATE = 1);

/// 现住址省 指向DHCMed.SS.AreaDic
Property FRCurrProvinceDr As DHCMed.SS.AreaDic;

/// 现住址市 指向DHCMed.SS.AreaDic
Property FRCurrCityDr As DHCMed.SS.AreaDic;

/// 现住址县 指向DHCMed.SS.AreaDic
Property FRCurrCountyDr As DHCMed.SS.AreaDic;

/// 现住址乡 指向DHCMed.SS.AreaDic
Property FRCurrVillageDr As DHCMed.SS.AreaDic;

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

/// 潜伏时间
Property FRLurkTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 上报原因
Property FRcboReasonDr As DHCMed.SS.Dictionary;

/// 初步诊断
Property FRPreDiagnos As %String(MAXLEN = 500, TRUNCATE = 1);

/// 可疑病因
Property FRSusCause As %String(MAXLEN = 500, TRUNCATE = 1);

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

/// add 2019-01-10
/// 初步诊断多选
Property FRPreDiagnosDrs As list Of DHCMed.SS.Dictionary;

/// 可疑病因多选
Property FRSusCauseDrs As list Of DHCMed.SS.Dictionary;

/// 实验室检验结果
Property FRTestResult As %String(MAXLEN = 500, TRUNCATE = 1);

/// 辅助检验结果
Property FRTestAssist As %String(MAXLEN = 500, TRUNCATE = 1);

/// 主要症状
Property FRMainSym As %String(MAXLEN = 500, TRUNCATE = 1);

/// 其他症状
Property FROtherSym As %String(MAXLEN = 500, TRUNCATE = 1);

/// 主要体征
Property FRMainSign As %String(MAXLEN = 500, TRUNCATE = 1);

/// 可疑食品名称
Property FRSusAbFood As %String(MAXLEN = 500, TRUNCATE = 1);

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
/// Table：       DHCMed.FBD.SusAbRep
/// Input：       Id : DHCMed.FBD.SusAbRep.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.SusAbRep).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.SusAbRep
{
	New (aID)
	Quit:'##class(DHCMed.FBD.SusAbRep).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.SusAbRep).%OpenId(aID)
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
	Set return = return_..GetDicByObj(..FRCardTypeDR,Languages)_separete
	Set return = return_..FRIdentify_separete
	Set return = return_..FRIsInHosp_separete
	Set return = return_..FRContactor_separete
	Set return = return_..FRTelephone_separete               //10
	Set return = return_..FRFixedTel_separete
	Set return = return_..FRRegAddress_separete	
	Set return = return_..GetAreaByObj(..FRRegProvinceDr,Languages,1)_separete	         
	Set return = return_..GetAreaByObj(..FRRegCityDr,Languages,2)_separete	    
	Set return = return_..GetAreaByObj(..FRRegCountyDr,Languages,3)_separete	    
	Set return = return_..GetAreaByObj(..FRRegVillageDr,Languages,4)_separete	    	             
	Set return = return_..FRRegRoad_separete   
	Set return = return_..FRCurrAddress_separete
	Set return = return_..GetAreaByObj(..FRCurrProvinceDr,Languages,1)_separete	     	       
	Set return = return_..GetAreaByObj(..FRCurrCityDr,Languages,2)_separete	    	       
	Set return = return_..GetAreaByObj(..FRCurrCountyDr,Languages,3)_separete	   	       
	Set return = return_..GetAreaByObj(..FRCurrVillageDr,Languages,4)_separete		    	       	
	Set return = return_..FRCurrRoad_separete
	Set return = return_..GetDicByObj(..FROccupationDr,Languages)_separete
	
	Set SickDate=..FRSickDate                                //20
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set return=return_SickDate_separete
	Set SickTime=..FRSickTime								//21
	Set:SickTime'="" SickTime=$zt(SickTime,1)
	Set return=return_SickTime_separete                       

	Set AdmitDate=..FRAdmitDate								//22
	Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
	Set return=return_AdmitDate_separete
	Set AdmitTime=..FRAdmitTime								//23
	Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
	Set return=return_AdmitTime_separete
	Set return = return_..FRLurkTime_separete    				//24               				
	Set return = return_..GetDicByObj(..FRcboReasonDr,Languages)_separete  					//25
	           
	Set return = return_..FRPreDiagnos_separete	//27
	Set return = return_..FRSusCause_separete	//28

	Set ReportLocID=..FRReportLoc	
	Set ReportLocDesc=$p($g(^CTLOC(+ReportLocID)),"^",2)
	Set:$p(ReportLocDesc,"-",2)'="" ReportLocDesc=$p(ReportLocDesc,"-",2)
	Set ReportLocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,ReportLocDesc)
			
	Set return=return_ReportLocID_separete_ReportLocDesc_separete	 //29,30
	
	Set ReportUser=..FRReportUser		
	Set ReportUserDesc = ""				
	If (ReportUser'=""){
		Set objUser=##Class(DHCMed.Base.SSUser).GetObjById(+ReportUser)
		If ($IsObject(objUser)){
			Set ReportUserDesc=objUser.Name
			Set ReportUserDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,ReportUserDesc)
		}
	}
	Set return=return_ReportUser_separete_ReportUserDesc_separete //31,32                  
	
	Set ReportDate=..FRReportDate	//33
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set return=return_ReportDate_separete
	Set ReportTime=..FRReportTime	//34
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
	Set return=return_CheckUser_separete_CheckUserDesc_separete  //35,36
		
	Set CheckDate=..FRCheckDate
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
	Set return=return_CheckDate_separete	//37
	Set CheckTime=..FRCheckTime                            
	Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	Set return=return_CheckTime_separete	//38
	Set return = return_..FRMainSym_separete	//
	Set return = return_..FROtherSym_separete	//
	Set return = return_..FRMainSign_separete	//
	Set return = return_..FRSusAbFood_separete	//
	Set return = return_..FRTestResult_separete	//
	Set return = return_..FRTestAssist_separete	//41
	
	Set PreDiagnosDrs=..FRPreDiagnosDrs                              //43初步诊断
	Set PreDiagnosDrsList=""
	For ind=1:1:PreDiagnosDrs.Count() {
		Set objDic=PreDiagnosDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set PreDiagnosDrsList=PreDiagnosDrsList_","_objDic.%Id()
	}
	Set:PreDiagnosDrsList'="" PreDiagnosDrsList=$e(PreDiagnosDrsList,2,$l(PreDiagnosDrsList))
	Set return=return_PreDiagnosDrsList_separete
	
	Set SusCauseDrs=..FRSusCauseDrs                             //44可疑病因
	Set SusCauseDrsList=""
	For ind=1:1:SusCauseDrs.Count() {
		Set objDic=SusCauseDrs.GetAt(ind)
		Continue:'$IsObject(objDic)
		Set SusCauseDrsList=SusCauseDrsList_","_objDic.%Id()
	}
	Set:SusCauseDrsList'="" SusCauseDrsList=$e(SusCauseDrsList,2,$l(SusCauseDrsList))
	Set return=return_SusCauseDrsList_separete                
	
	quit return
}

/// Creator:      pylian
/// CreatDate:    2018-10-17
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.FBD.SusAbRep
/// Input：       ID:    DHCMed.FBD.SusAbRep.ID
/// Return：      返回String
/// w ##class(DHCMed.FBD.SusAbRep).GetStringById(18)
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
	
	set obj=##Class(DHCMed.FBD.SusAbRep).GetObjById(+aID)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator:      pylian
/// CreatDate:    2018-10-18
/// Description:  根据省市县乡描述获取省市县乡ID
/// Table：       DHCMed.FBD.Report
/// Input：       ID:    DHCMed.FBD.SusAbRep.ID
/// Return：      返回String
/// w ##class(DHCMed.FBD.SusAbRep).GetAreaIdByDesc("北京市","市辖区","东城区","东华门街道","^")
ClassMethod GetAreaIdByDesc(aProvince As %String, aCity As %String, aCounty As %String, aVillage As %String, aseparete As %String) As %String
{
	New (aProvince,aCity,aCounty,aVillage,aseparete)
	Set return= ""_$c(1)_aProvince_aseparete_""_$c(1)_aCity_aseparete_""_$c(1)_aCounty_aseparete_""_$c(1)_aVillage  //返回字符串位置固定
	
	Quit:(aProvince="")||(aCity="")||(aCounty="")||(aVillage="") return

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
	
		Continue:((aVillage'="")&&($e(objVillage.ShortDesc,1,$l(aVillage))'[aVillage))
	    Set VillageID = xVID
	    Set VillageCode = objVillage.Code
	}

	Set return = ProvinceID_$c(1)_aProvince_aseparete_CityID_$c(1)_aCity_aseparete_CountyID_$c(1)_aCounty_aseparete_VillageID_$c(1)_aVillage			
	Quit return
}

/// w ##class(DHCMed.FBD.SusAbRep).GetDicByObj()
ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	quit return
}

ClassMethod GetAreaByObj(obj As DHCMed.SS.AreaDic, Languages As %String = "", aflag As %String = "") As %String
{
	new (obj,Languages,aflag)
	set return=""
	quit:'$IsObject(obj) return
	if (aflag=1){
		set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,obj.ShortDesc)	
	}
	if (aflag=2){
		set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,obj.ShortDesc)
	}
	if (aflag=3){
		set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,obj.ShortDesc)
	}
	if (aflag=4){
		set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,obj.ShortDesc)
	}
	quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  更新食源性疾病信息
/// Table：       DHCMed.FBD.SusAbRep
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.SusAbRep).Update("23^7^12^3^11^1247^BJ0100120190139^######100004^1^^13355224477^1^1251^北京市市辖区东城区东华门街道111^北京市^市辖区^东城区^东华门街道^111^1259^2019-11-11^01:00:00^2019-01-31^15:55:11^55^3678^0^^95^^^^^^^^^^^^3224^3669","^","#")
/// w ##class(DHCMed.FBD.SusAbRep).Update("24^352^205^5^病危^1244^BJ0100120190192^#####100092^3689^510125199811133813^1^话说西^1252^02861600531^甘肃省兰州市城关区张掖路街道弗雷尔卓德^甘肃省^兰州市^城关区^张掖路街道^弗雷尔卓德^青海省西宁市城中区饮马街办事处德玛西亚^青海省^西宁市^城中区^饮马街办事处^德玛西亚^3226^1851-01-20^00:01:35^1868-12-13^18:08:52^60529^3676^^^95^^^^^^^全身泛红^无^发热^猪猪贝^发黑^B超^3221^3667","^","#")
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
	Set CardTypeID=$p(aInputStr,aSeparate,9)
	Set Identify=$p(aInputStr,aSeparate,10)
	Set IsInHosp=$p(aInputStr,aSeparate,11)
	Set Contactor=$p(aInputStr,aSeparate,12)
	Set Telephone=$p(aInputStr,aSeparate,13)
	Set FixedTel=$p(aInputStr,aSeparate,14)
	Set RegAddress=$p(aInputStr,aSeparate,15)
	Set RegProvinceID=$p(aInputStr,aSeparate,16)
	Set RegCityID=$p(aInputStr,aSeparate,17)
	Set RegCountyID=$p(aInputStr,aSeparate,18)
	Set RegVillageID=$p(aInputStr,aSeparate,19)
	Set RegRoad=$p(aInputStr,aSeparate,20)
	Set CurrAddress=$p(aInputStr,aSeparate,21)
	Set CurrProvinceID=$p(aInputStr,aSeparate,22)
	Set CurrCityID=$p(aInputStr,aSeparate,23)
	Set CurrCountyID=$p(aInputStr,aSeparate,24)
	Set CurrVillageID=$p(aInputStr,aSeparate,25)
	Set CurrRoad=$p(aInputStr,aSeparate,26)
	Set OccupationID=$p(aInputStr,aSeparate,27)
	Set SickDate=$p(aInputStr,aSeparate,28)
	Set SickTime=$p(aInputStr,aSeparate,29)
	Set AdmitDate=$p(aInputStr,aSeparate,30)
	Set AdmitTime=$p(aInputStr,aSeparate,31)
	Set LurkTime=$p(aInputStr,aSeparate,32)		//新增潜伏时间
	Set cboReasonID=$p(aInputStr,aSeparate,33)		//上报原因
	Set PreDiagnosDrs=$p(aInputStr,aSeparate,34)
	Set SusCauseDrs=$p(aInputStr,aSeparate,35)
	Set ReportLoc=$p(aInputStr,aSeparate,36)
	Set ReportUser=$p(aInputStr,aSeparate,37)
	Set ReportDate=$p(aInputStr,aSeparate,38)
	Set ReportTime=$p(aInputStr,aSeparate,39)
	Set CheckUser=$p(aInputStr,aSeparate,40)
	Set CheckDate=$p(aInputStr,aSeparate,41)
	Set CheckTime=$p(aInputStr,aSeparate,42)
	Set MainSym=$p(aInputStr,aSeparate,43)
	Set OtherSym=$p(aInputStr,aSeparate,44)
	Set MainSign=$p(aInputStr,aSeparate,45)
	Set SusAbFood=$p(aInputStr,aSeparate,46)
	Set TestResult=$p(aInputStr,aSeparate,47)	//实验室检查结果
	Set TestAssist=$p(aInputStr,aSeparate,48)	//辅助检查结果
	Set PreDiagnos=$p(aInputStr,aSeparate,49)
	Set SusCause=$p(aInputStr,aSeparate,50)

	Quit:(EpisodeID="")||(PatientID="")||(ReportLoc="")||(StatusID="") return
	Set PatientObj=##class(DHCMed.FBD.ReportPat).GetPatObj(PatientObj,aSepObj)
	Quit:'$IsObject(PatientObj) return
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Quit:'$IsObject(objStatus) return
	
	//Quit:(DiseaseID="")||(AreaID="")||(OccupationID="") return
	Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
	Set objCardType=##class(DHCMed.SS.Dictionary).GetObjById(CardTypeID)
	Set objOccupation=##class(DHCMed.SS.Dictionary).GetObjById(OccupationID)
	Set objcboReason=##class(DHCMed.SS.Dictionary).GetObjById(cboReasonID)
	
	//户籍地址
	Set objRegProvince=##class(DHCMed.SS.AreaDic).GetObjById(RegProvinceID)
	Set objRegCity=##class(DHCMed.SS.AreaDic).GetObjById(RegCityID)
	Set objRegCounty=##class(DHCMed.SS.AreaDic).GetObjById(RegCountyID)
	Set objRegVillage=##class(DHCMed.SS.AreaDic).GetObjById(RegVillageID)
	//现住址
	Set objCurrProvince=##class(DHCMed.SS.AreaDic).GetObjById(CurrProvinceID)
	Set objCurrCity=##class(DHCMed.SS.AreaDic).GetObjById(CurrCityID)
	Set objCurrCounty=##class(DHCMed.SS.AreaDic).GetObjById(CurrCountyID)
	Set objCurrVillage=##class(DHCMed.SS.AreaDic).GetObjById(CurrVillageID)
	
	If (objStatus.Code<3) {
		Quit:'$IsObject(objDisease) return
		Quit:'$IsObject(objCardType) return
		Quit:'$IsObject(objOccupation) return
		Quit:'$IsObject(objcboReason) return
	}
	
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SickDate)
	Set:(SickTime[":") SickTime=$zth(SickTime,1)
	Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AdmitDate)
	Set:(AdmitTime[":") AdmitTime=$zth(AdmitTime,1)
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ReportDate)
	Set:(ReportDate="") ReportDate=+$p($h,",",1)
	Set:(ReportTime="") ReportTime=+$p($h,",",2)
	Set:(ReportTime[":") ReportTime=$zth(ReportTime,1)
	Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(CheckDate)
	Set:(CheckTime[":") CheckTime=$zth(CheckTime,1)
	
	If (ID="") {
		Set obj=##class(DHCMed.FBD.SusAbRep).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.SusAbRep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.FREpisodeID=EpisodeID
	Set obj.FRPatientID=PatientID
	Set obj.FRDiseaseDr=objDisease
	Set obj.FRDiseaseText=DiseaseText
	Set obj.FRStatusDr=objStatus
	Set obj.FRCardNo=CardNo
	Set obj.FRPatientObj=PatientObj
	Set obj.FRCardTypeDR=objCardType
	Set obj.FRIdentify=Identify
	Set obj.FRIsInHosp=IsInHosp
	Set obj.FRContactor=Contactor
	Set obj.FRTelephone=Telephone
	Set obj.FRFixedTel=FixedTel
	Set obj.FRRegAddress=RegAddress
	Set obj.FRRegProvinceDr=objRegProvince
	Set obj.FRRegCityDr=objRegCity
	Set obj.FRRegCountyDr=objRegCounty
	Set obj.FRRegVillageDr=objRegVillage
	Set obj.FRRegRoad=RegRoad
	Set obj.FRCurrAddress=CurrAddress
	Set obj.FRCurrProvinceDr=objCurrProvince
	Set obj.FRCurrCityDr=objCurrCity
	Set obj.FRCurrCountyDr=objCurrCounty
	Set obj.FRCurrVillageDr=objCurrVillage
	Set obj.FRCurrRoad=CurrRoad
	Set obj.FROccupationDr=objOccupation
	Set obj.FRSickDate=SickDate
	Set obj.FRSickTime=SickTime
	Set obj.FRAdmitDate=AdmitDate
	Set obj.FRAdmitTime=AdmitTime
	Set obj.FRLurkTime=LurkTime
	Set obj.FRcboReasonDr=objcboReason
	Set obj.FRReportLoc=ReportLoc
	Set obj.FRReportUser=ReportUser
	Set obj.FRReportDate=ReportDate
	Set obj.FRReportTime=ReportTime
	Set obj.FRCheckUser=CheckUser
	Set obj.FRCheckDate=CheckDate
	Set obj.FRCheckTime=CheckTime
	Set obj.FRMainSym=MainSign
	Set obj.FROtherSym=OtherSym
	Set obj.FRMainSign=MainSign
	Set obj.FRSusAbFood=SusAbFood
	Set obj.FRTestResult=TestResult
	Set obj.FRTestAssist=TestAssist
	Set obj.FRPreDiagnos=PreDiagnos
	Set obj.FRSusCause=SusCause
	Set PreDiagnosDrs=$p(aInputStr,aSeparate,34)	        //初步诊断多选
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
	
	Set SusCauseDrs=$p(aInputStr,aSeparate,35)	        //既往病史多选
	While (obj.FRSusCauseDrs.Count()>0) {
		Do obj.FRSusCauseDrs.RemoveAt(1)
	}
	Set SusCauseList=""
	For ind=1:1:$length(SusCauseDrs,",") {
		Set SusCauseDr=$p(SusCauseDrs,",",ind)
		Continue:($listfind(SusCauseList,SusCauseDrs)>0)
		Set SusCauseList=SusCauseList_$lb(SusCauseDr)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(SusCauseDr)
		Continue:'$IsObject(objDic)
		Do obj.FRSusCauseDrs.Insert(objDic)
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
/// Input：       Id : DHCMed.FBD.SusAbRep.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.SusAbRep).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.SusAbRep).%DeleteId(aID)
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
		Set obj=##class(DHCMed.FBD.SusAbRep).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.SusAbRep).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.FRStatusDr=objStatus
	Set obj.FRCheckUser=CheckUser
	Set obj.FRCheckDate=+CheckDate
	Set obj.FRCheckTime=+CheckTime
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
<Data name="SusAbRepDefaultData">
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
<Value>FRCardTypeDR</Value>
</Value>
<Value name="11">
<Value>FRIdentify</Value>
</Value>
<Value name="12">
<Value>FRContactor</Value>
</Value>
<Value name="13">
<Value>FRTelephone</Value>
</Value>
<Value name="14">
<Value>FRFixedTel</Value>
</Value>
<Value name="15">
<Value>FRRegAddress</Value>
</Value>
<Value name="16">
<Value>FRRegProvinceDr</Value>
</Value>
<Value name="17">
<Value>FRRegCityDr</Value>
</Value>
<Value name="18">
<Value>FRRegCountyDr</Value>
</Value>
<Value name="19">
<Value>FRRegVillageDr</Value>
</Value>
<Value name="20">
<Value>FRRegRoad</Value>
</Value>
<Value name="21">
<Value>FRCurrAddress</Value>
</Value>
<Value name="22">
<Value>FRCurrProvinceDr</Value>
</Value>
<Value name="23">
<Value>FRCurrCityDr</Value>
</Value>
<Value name="24">
<Value>FRCurrCountyDr</Value>
</Value>
<Value name="25">
<Value>FRCurrVillageDr</Value>
</Value>
<Value name="26">
<Value>FRCurrRoad</Value>
</Value>
<Value name="27">
<Value>FROccupationDr</Value>
</Value>
<Value name="28">
<Value>FRSickDate</Value>
</Value>
<Value name="29">
<Value>FRSickTime</Value>
</Value>
<Value name="30">
<Value>FRAdmitDate</Value>
</Value>
<Value name="31">
<Value>FRAdmitTime</Value>
</Value>
<Value name="32">
<Value>FRLurkTime</Value>
</Value>
<Value name="33">
<Value>FRcboReasonDr</Value>
</Value>
<Value name="34">
<Value>FRPreDiagnos</Value>
</Value>
<Value name="35">
<Value>FRSusCause</Value>
</Value>
<Value name="36">
<Value>FRReportLoc</Value>
</Value>
<Value name="37">
<Value>FRReportUser</Value>
</Value>
<Value name="38">
<Value>FRReportDate</Value>
</Value>
<Value name="39">
<Value>FRReportTime</Value>
</Value>
<Value name="40">
<Value>FRCheckUser</Value>
</Value>
<Value name="41">
<Value>FRCheckDate</Value>
</Value>
<Value name="42">
<Value>FRCheckTime</Value>
</Value>
<Value name="43">
<Value>FRPreDiagnosDrs</Value>
</Value>
<Value name="44">
<Value>FRSusCauseDrs</Value>
</Value>
<Value name="45">
<Value>FRTestResult</Value>
</Value>
<Value name="46">
<Value>FRTestAssist</Value>
</Value>
<Value name="47">
<Value>FRMainSym</Value>
</Value>
<Value name="48">
<Value>FROtherSym</Value>
</Value>
<Value name="49">
<Value>FRMainSign</Value>
</Value>
<Value name="50">
<Value>FRSusAbFood</Value>
</Value>
</Data>
<DataLocation>^DHCMed.FBD.SusAbRepD</DataLocation>
<DefaultData>SusAbRepDefaultData</DefaultData>
<IdLocation>^DHCMed.FBD.SusAbRepD</IdLocation>
<IndexLocation>^DHCMed.FBD.SusAbRepI</IndexLocation>
<StreamLocation>^DHCMed.FBD.SusAbRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
