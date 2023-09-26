/// 名称：DHCMed.EPD.ERReportILI
/// 流感样病历标本登记卡信息
/// 编写者：yk
/// 编写日期:2016-01-20
Class DHCMed.EPD.ERReportILI Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = Default ]
{

Relationship ChildLOG As DHCMed.EPD.ILIReportLOG [ Cardinality = children, Inverse = ParRef ];

///  就诊号
/// Pa_PatMas.PAPMI_No
Property EREpisodeID As %String(TRUNCATE = 1);

/// 病人ID
/// Pa_PatMas.PAPMI_RowId
Property ERPatID As %String;

/// 病人登记号
Property ERRegNo As %String;

/// 病人姓名
/// Pa_PatMas.PAPMI_Name
Property ERPatName As %String(TRUNCATE = 1);

/// 病人性别
/// Pa_PatMas.PAPMI_Sex_DR
Property ERPatSex As %String;

/// 出生日期
/// Pa_person.PAPER_Dob
Property ERBirthday As %String(TRUNCATE = 1);

/// 年龄(年)
/// Pa_person.PAPER_AgeYr
Property ERAge As %String;

/// 年龄(月)
/// Pa_person.PAPER_AgeMth
Property ERAgeMonth As %String;

/// 年龄(日)
/// Pa_person.PAPER_AgeDay
Property ERAgeDay As %String;

/// 现住址
Property ERCurrAddress As %String;

/// 现住址省 指向DHCMed.SS.AreaDic
Property ERCurrProvince As DHCMed.SS.AreaDic;

/// 现住址市 指向DHCMed.SS.AreaDic
Property ERCurrCity As DHCMed.SS.AreaDic;

/// 现住址县 指向DHCMed.SS.AreaDic
Property ERCurrCounty As DHCMed.SS.AreaDic;

/// 现住址乡镇街道 指向DHCMed.SS.AreaDic
Property ERCurrTown As DHCMed.SS.AreaDic;

/// 现住址村
Property ERCurrVillage As %String;

/// 联系电话
Property ERTelephone As %String(TRUNCATE = 1);

/// 家长/监护人姓名
Property ERParent As %String(MAXLEN = 100, TRUNCATE = 1);

/// 就诊医生（填报人）
Property ERDoctorName As %String(TRUNCATE = 1);

/// 医生工号
Property ERDoctorNo As %String(TRUNCATE = 1);

/// 发病日期
Property ERSickDate As %Date;

/// 就诊日期
Property ERAdmitDate As %Date;

/// 报告日期
Property ERReportDate As %Date;

/// 报告时间
Property ERReportTime As %Time;

/// 标本类型
Property ERSpecimenType As DHCMed.SS.Dictionary;

/// 标本来源
Property ERSpecimenSource As DHCMed.SS.Dictionary;

/// 标本采集地
Property ERSpecimenClnArea As %String;

/// 爆发事件名称(标本来源为"流感样病例爆发监测"时填写)
Property ERIncident As %String;

/// 就诊科室（上报科室）
Property ERAdmLoc As %String;

/// 就诊医院（上报医院）
Property ERHospital As %String;

/// 报告编号
Property ERReportNum As %String;

/// 报告状态        //1、上报;2、审核;3、删除
Property ERReportStatus As DHCMed.SS.Dictionary;

/// 审核人
Property ERCheckUser As %String;

/// 审核日期
Property ERCheckDate As %Date;

/// 审核时间
Property ERCheckTime As %Time;

/// 审核标志
Property ERCheckFlag As %Boolean;

/// 导出标志
Property ERExportFlag As %Boolean;

/// 导出人
Property ERExportUser As %String;

/// 导出日期
Property ERExportDate As %Date;

/// 导出时间
Property ERExportTime As %Time;

/// 备用字段1
Property ERText1 As %String;

/// 备用字段2
Property ERText2 As %String;

/// 备用字段3
Property ERText3 As %String;

/// 就诊号建立索引
Index EREpisodeIDIndex On EREpisodeID;

/// 报告编号建立索引
Index ERReportNumIndex On ERReportNum;

/// 报告日期建立索引
Index ERReportDateIndex On ERReportDate;

/// 报告日期科室索引
Index ERDateLocIndex On (ERReportDate, ERAdmLoc);

/// Creator：     yk
/// CreatDate：   2016-01-27
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       ID:    DHCMed.EPD.ERReportILI.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ERReportILI).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.EPD.ERReportILI
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.EPD.ERReportILI).%ExistsId(+id) return
	set obj=##Class(DHCMed.EPD.ERReportILI).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

Method ToString(separete As %String, Languages As %String) As %String
{
	new (separete,Languages)
	Set return=..ERReportNum_separete
	Set return=return_..EREpisodeID_separete                  
	Set return=return_..ERPatID_separete
	Set return=return_..ERRegNo_separete
	Set return=return_..ERPatName_separete     //5
	Set return=return_..ERPatSex_separete
	Set birthday=..ERBirthday
	Set:birthday'="" birthday=$zd(birthday,3)
	Set return=return_birthday_separete            //7
	Set return=return_..ERAge_separete
	Set return=return_..ERAgeMonth_separete
	Set return=return_..ERAgeDay_separete            //10
	Set return=return_..ERCurrAddress_separete
	Set return=return_..GetAreaByObj(..ERCurrProvince,Languages,1)_separete   //12
	Set return=return_..GetAreaByObj(..ERCurrCity,Languages,2)_separete
	Set return=return_..GetAreaByObj(..ERCurrCounty,Languages,3)_separete
	Set return=return_..GetAreaByObj(..ERCurrTown,Languages,4)_separete
	Set return=return_..ERCurrVillage_separete
	Set return=return_..ERTelephone_separete     //17
	Set return=return_..ERParent_separete
	Set return=return_..ERDoctorName_separete
	Set return=return_..ERDoctorNo_separete
	Set SickDate=..ERSickDate
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set return=return_SickDate_separete          //21
	Set AdmitDate=..ERAdmitDate
	Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
	Set return=return_AdmitDate_separete         //22
	Set ReportDate=..ERReportDate
	Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set return=return_ReportDate_separete       //23
	Set ReportTime=..ERReportTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,1)
	Set return=return_ReportTime_separete          //24
	Set return=return_..GetDicByObj(..ERSpecimenType,Languages)_separete
	Set return=return_..GetDicByObj(..ERSpecimenSource,Languages)_separete
	Set return=return_..ERSpecimenClnArea_separete     //27
	
	Set AdmLocID=..ERAdmLoc
	set DescStr=$p($g(^CTLOC(+AdmLocID)),"^",2)
	set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
	Set return=return_AdmLocID_separete	      //28  
	Set DescStr = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,DescStr)
	Set return=return_DescStr_separete         //29
	Set HospitalName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,..ERHospital)
	Set:Languages="CH" HospitalName= ##class(web.DHCBL.Authorize.BDPTranslation).GetBeforeTransDesc("User.CTHospital","HOSPDesc","EN",..ERHospital)

	Set return=return_HospitalName_separete          //30
	Set return=return_..GetDicByObj(..ERReportStatus,Languages)_separete        //31	
	Set return=return_..ERCheckUser_separete
	Set CheckDate=..ERCheckDate
	Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
	Set return=return_CheckDate_separete     //33
	Set CheckTime=..ERCheckTime	
	Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	Set return=return_CheckTime_separete        //34	
	Set return=return_..ERIncident_separete
	Set return=return_..ERCheckFlag_separete   
	Set return=return_..ERExportFlag_separete  
	Set return=return_..ERExportUser_separete   //38
	Set return=return_..ERExportDate_separete   
	Set return=return_..ERExportTime_separete 
	Set return=return_..ERText1_separete      //41
	Set return=return_..ERText2_separete
	Set return=return_..ERText3_separete         
	
	quit return
}

/// 通过对象参数取得地址项描述
/// Table: DHCMed.EPD.AreaDic
ClassMethod GetAreaByObj(obj As DHCMed.EPD.AreaDic, Languages As %String = "", aFlag As %String = "") As %String
{
	new (obj,Languages,aFlag)
	set return=""
	quit:'$IsObject(obj) return
	
	if (aFlag=1){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,obj.ShortDesc)	
	}
	if (aFlag=2){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,obj.ShortDesc)
	}
	if (aFlag=3){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,obj.ShortDesc)
	}
	if (aFlag=4){
		Set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,obj.ShortDesc)
	}
	quit return
}

/// 通过对象参数取得字典项描述
/// Table:DHCMed.SS.Dictionary
ClassMethod GetDicByObj(obj As DHCMed.SS.Dictionary, Languages As %String = "") As %String
{
	new (obj,Languages)
	set return=""
	quit:'$IsObject(obj) return
	
	set return=obj.%Id()_$c(1)_##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	quit return
}

/// Creator：     yk
/// CreatDate：   2016-01-30
/// Description:  根据ID取报告主卡信息
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       ID:    DHCMed.EPD.ERReportILI.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ERReportILI).GetStringById(16)
ClassMethod GetStringById(id As %String) As %String
{
	new (id,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCMed.EPD.ERReportILI).GetObjById(+id)
	if $IsObject(obj){
		set return=obj.ToString("^",Languages)
	}
	quit return
}

/// Creator：     yk
/// CreatDate：   2016-01-30
/// Description:  更新主卡信息
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.ERReportILI).Update("23^265^185^1^0000000185^李聪(考试)^女^^24^^^2131^372^595^612^615^21^13143211112^med manager^^2016-03-14^2016-03-21^63998^52505^11364^231^11368^2131^117^北京地坛医院^^^^^^^^^^^^12311","^")
ClassMethod Update(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=0
	quit:aInput="" return
	
	Set ID=$p(aInput,separete,1)
	
	If (ID="") {
		Set obj=##class(DHCMed.EPD.ERReportILI).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.ERReportILI).%OpenId(+ID)
	}
	
	Quit:'$IsObject(obj) return
	Set obj.EREpisodeID=$p(aInput,separete,2)
	Set obj.ERPatID=$p(aInput,separete,3)
	Set ReportStatusID=$p(aInput,separete,4)
	Set obj.ERReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ERReportStatus",ReportStatusID,1)
	Set obj.ERRegNo=$p(aInput,separete,5)
	Set obj.ERPatName=$p(aInput,separete,6)
	Set obj.ERPatSex=$p(aInput,separete,7)
	Set Birthday=$p(aInput,separete,8)
	Set:Birthday'="" obj.ERBirthday=$zdh(Birthday,3)
	Set obj.ERAge=$p(aInput,separete,9)
	Set obj.ERAgeMonth=$p(aInput,separete,10)
	Set obj.ERAgeDay=$p(aInput,separete,11)
	Set obj.ERCurrAddress=$p(aInput,separete,12)
	Set CurrProvinceID=$p(aInput,separete,13)
	Set obj.ERCurrProvince=##class(DHCMed.SS.AreaDic).GetObjById(CurrProvinceID)
	Set CurrCityID=$p(aInput,separete,14)
	Set obj.ERCurrCity=##class(DHCMed.SS.AreaDic).GetObjById(CurrCityID)
	Set CurrCountyID=$p(aInput,separete,15)
	Set obj.ERCurrCounty=##class(DHCMed.SS.AreaDic).GetObjById(CurrCountyID)
	Set CurrTownID=$p(aInput,separete,16)
	Set obj.ERCurrTown=##class(DHCMed.SS.AreaDic).GetObjById(CurrTownID)
	Set obj.ERCurrVillage=$p(aInput,separete,17)
	Set obj.ERTelephone=$p(aInput,separete,18)
	Set obj.ERParent=$p(aInput,separete,19)
	Set obj.ERDoctorName=$p(aInput,separete,20)
	Set obj.ERDoctorNo=$p(aInput,separete,21)
	Set SickDate=$p(aInput,separete,22)
	//mod by liuzhenhe 2019-02-19
	Set obj.ERSickDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(SickDate)
	Set AdmitDate=$p(aInput,separete,23)
	Set obj.ERAdmitDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AdmitDate)
	Set obj.ERReportDate=$p(aInput,separete,24)
	Set obj.ERReportTime=$p(aInput,separete,25)
	Set SpecimenTypeID=$p(aInput,separete,26)
	Set obj.ERSpecimenType=##class(DHCMed.SS.Dictionary).GetObjById(SpecimenTypeID)
	Set SpecimenSourceID=$p(aInput,separete,28)
	Set obj.ERSpecimenSource=##class(DHCMed.SS.Dictionary).GetObjById(SpecimenSourceID)
	Set obj.ERSpecimenClnArea=$p(aInput,separete,27)	
	Set obj.ERIncident=$p(aInput,separete,29)
	Set obj.ERAdmLoc=$p(aInput,separete,30)
	Set obj.ERHospital=$p(aInput,separete,31)
	Set obj.ERCheckUser=$p(aInput,separete,32)
	Set CheckDate=$p(aInput,separete,33)
	Set:CheckDate["-" obj.ERSickDate=$zdh(CheckDate,3)
	Set CheckTime=$p(aInput,separete,34)
	Set:CheckTime[":" obj.ERCheckTime=$zth(CheckTime,1)
	Set obj.ERCheckFlag=$p(aInput,separete,35)
	Set obj.ERExportFlag=$p(aInput,separete,36)
	Set obj.ERExportUser=$p(aInput,separete,37)
	Set obj.ERExportDate=$p(aInput,separete,38)
	Set obj.ERExportTime=$p(aInput,separete,39)
	Set obj.ERText1=$p(aInput,separete,40)
	Set obj.ERText2=$p(aInput,separete,41)
	Set obj.ERText3=$p(aInput,separete,42)
	if ($p(aInput,separete,43)=""){
		Set obj.ERReportNum=##class(DHCMed.EPDService.Service).GetNewRepNo("ILI")  //"未填写"
	}else{
		Set obj.ERReportNum=$p(aInput,separete,43)
	}
		
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yk
/// CreatDate：   2016-01-30
/// Description:  审核报告
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       ID:    DHCMed.EPD.ERReportILI.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ERReportILI).CheckReport(13)
ClassMethod CheckReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.EPD.ERReportILI).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.ERReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ERReportStatus",ReportStatus,1)
	Set obj.ERCheckFlag=1
	Set obj.ERCheckUser=$p(aInput,separete,3)
	Set obj.ERCheckDate=+$H
	Set obj.ERCheckTime=$p($H,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_""
		Set retlog=##class(DHCMed.EPD.ILIReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yk
/// CreatDate：   2016-02-03
/// Description:  打印、导出报告
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       ID:    DHCMed.EPD.ERReportILI.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ERReportILI).PrintReport(1)
ClassMethod ExportReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.EPD.ERReportILI).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set obj.ERExportFlag=1
	Set obj.ERExportUser=$p(aInput,separete,2)
	Set obj.ERExportDate=+$H
	Set obj.ERExportTime=$p(+$H,",",2)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_obj.ERReportStatus.Code
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,2)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set retlog=##class(DHCMed.EPD.ILIReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     yk
/// CreatDate：   2016-02-03
/// Description:  删除报告
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       ID:    DHCMed.EPD.ERReportILI.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.ERReportILI).DeleteReport(1)
ClassMethod DeleteReport(aInput As %String, separete As %String) As %String
{
	new (aInput,separete)
	set return=""
	quit:aInput="" return
	
	Set RepID=$p(aInput,separete,1)
	Set obj=##class(DHCMed.EPD.ERReportILI).GetObjById(RepID)
	Quit:'$IsObject(obj) return
	
	Set ReportStatus=$p(aInput,separete,2)
	Set obj.ERReportStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("ERReportStatus",ReportStatus,1)
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		Set InputStrLOG=RepID
		Set InputStrLOG=InputStrLOG_"^"_obj.ERReportStatus.Code
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,4)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,3)
		Set InputStrLOG=InputStrLOG_"^"_+$H
		Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
		Set InputStrLOG=InputStrLOG_"^"_$p(aInput,separete,5)
		Set retlog=##class(DHCMed.EPD.ILIReportLOG).Update(InputStrLOG,"^")
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator:		yk
/// CreatDate:		2016-03-18
/// Description:	取报告的状态
/// Input:			ReportID
/// Return:			StatusCode
/// w ##class(DHCMed.EPD.ERReportILI).GetReportStatus(1)
ClassMethod GetReportStatus(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	Set objRep=##class(DHCMed.EPD.ERReportILI).GetObjById(+aReportID)
	Quit:'$IsObject(objRep) return

	Set RepStatusID=objRep.ERReportStatus.%Id()
	Set RepStatusCode=objRep.ERReportStatus.Code
	
	Set return=RepStatusCode
	
	Quit return
}

Storage Default
{
<Data name="ERReportILIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EREpisodeID</Value>
</Value>
<Value name="3">
<Value>ERPatientID</Value>
</Value>
<Value name="4">
<Value>ERPatientSex</Value>
</Value>
<Value name="5">
<Value>ERBirthday</Value>
</Value>
<Value name="6">
<Value>ERAge</Value>
</Value>
<Value name="7">
<Value>ERAgeMonth</Value>
</Value>
<Value name="8">
<Value>ERAgeDay</Value>
</Value>
<Value name="9">
<Value>ERCurrAddress</Value>
</Value>
<Value name="10">
<Value>ERCurrProvince</Value>
</Value>
<Value name="11">
<Value>ERCurrCity</Value>
</Value>
<Value name="12">
<Value>ERCurrCounty</Value>
</Value>
<Value name="13">
<Value>ERCurrVillage</Value>
</Value>
<Value name="14">
<Value>ERCurrRoad</Value>
</Value>
<Value name="15">
<Value>ERTelephone</Value>
</Value>
<Value name="16">
<Value>ERContactor</Value>
</Value>
<Value name="17">
<Value>ERDoctorName</Value>
</Value>
<Value name="18">
<Value>ERDoctorCode</Value>
</Value>
<Value name="19">
<Value>ERSickDate</Value>
</Value>
<Value name="20">
<Value>ERAdmitDate</Value>
</Value>
<Value name="21">
<Value>ERReportDate</Value>
</Value>
<Value name="22">
<Value>ERSpecimenType</Value>
</Value>
<Value name="23">
<Value>ERSpecimenSource</Value>
</Value>
<Value name="24">
<Value>ERHospitalCode</Value>
</Value>
<Value name="25">
<Value>ERHospitalDesc</Value>
</Value>
<Value name="26">
<Value>ERResume</Value>
</Value>
<Value name="27">
<Value>ERReportNum</Value>
</Value>
<Value name="28">
<Value>ERReportStatus</Value>
</Value>
<Value name="29">
<Value>ERPatientName</Value>
</Value>
<Value name="30">
<Value>ERPatID</Value>
</Value>
<Value name="31">
<Value>ERRegNo</Value>
</Value>
<Value name="32">
<Value>ERPatName</Value>
</Value>
<Value name="33">
<Value>ERPatSex</Value>
</Value>
<Value name="34">
<Value>ERCurrTown</Value>
</Value>
<Value name="35">
<Value>ERDoctorNo</Value>
</Value>
<Value name="36">
<Value>ERReportTime</Value>
</Value>
<Value name="37">
<Value>ERSpecimenClnArea</Value>
</Value>
<Value name="38">
<Value>ERAdmLoc</Value>
</Value>
<Value name="39">
<Value>ERHospitalName</Value>
</Value>
<Value name="40">
<Value>ERCheckUser</Value>
</Value>
<Value name="41">
<Value>ERCheckDate</Value>
</Value>
<Value name="42">
<Value>ERCheckTime</Value>
</Value>
<Value name="43">
<Value>ERIncident</Value>
</Value>
<Value name="44">
<Value>ERText1</Value>
</Value>
<Value name="45">
<Value>ERText2</Value>
</Value>
<Value name="46">
<Value>ERText3</Value>
</Value>
<Value name="47">
<Value>ERParent</Value>
</Value>
<Value name="48">
<Value>ERHospital</Value>
</Value>
<Value name="49">
<Value>ERCheckFlag</Value>
</Value>
<Value name="50">
<Value>ERExportFlag</Value>
</Value>
<Value name="51">
<Value>ERExportUser</Value>
</Value>
<Value name="52">
<Value>ERExportDate</Value>
</Value>
<Value name="53">
<Value>ERExportTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.ERReportILID</DataLocation>
<DefaultData>ERReportILIDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.ERReportILID</IdLocation>
<IndexLocation>^DHCMed.EPD.ERReportILII</IndexLocation>
<StreamLocation>^DHCMed.EPD.ERReportILIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
