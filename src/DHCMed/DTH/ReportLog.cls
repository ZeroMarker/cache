/// 名称: DHCMed.DTH.ReportLog
/// 描述: 死亡证日志表
/// 编写者: chenrui
/// 编写日期: 2023-04-11
Class DHCMed.DTH.ReportLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 死亡证报告ID
Property DTHReportID As %String;

/// 就诊号
Property EpisodeID As %String;

/// 科室
Property DTHLoc As %String;

/// 日期
Property DTHDate As %Date;

/// 时间
Property DTHTime As %Time;

/// 操作人
Property DTHUser As %String;

/// 修改内容
Property DTHEditContent As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 备注
Property Resume As %String;

/// 状态(DTCReportType)
Property DTHStatus As DHCMed.SS.Dictionary;

Index IndexReportID On DTHReportID As Exact;

Index IndexReportIDDateTime On (DTHReportID As Exact, DTHDate, DTHTime);

Index IndexEpisodeID On EpisodeID As Exact;

/// Creator：     chenrui
/// CreatDate：   2023-04-11
/// Description:  根据ID取死亡证上报日志信息
/// Table：       DHCMed.DTH.ReportLog
/// Input：       aId : DHCMed.DTH.ReportLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.DTH.ReportLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.DTH.ReportLog
{
	New (aId)
	Quit:'##class(DHCMed.DTH.ReportLog).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.DTH.ReportLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenrui
/// CreatDate：   2023-04-11
/// Description:  更新死亡证上报日志信息
/// Table：       DHCMed.DTH.ReportLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DTH.ReportLog).Update("^^^内分泌科^^^医生01^测试1^301^1794","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID			= $p(aInputStr,aSeparete,1)
	Set ReportID	= $p(aInputStr,aSeparete,2)
	Set DTHStatus	= $p(aInputStr,aSeparete,3)
	Set EpisodeID	= $p(aInputStr,aSeparete,4)
	Set DTHLoc		= $p(aInputStr,aSeparete,5)
	Set DTHDate		= $p(aInputStr,aSeparete,6)
	Set DTHTime		= $p(aInputStr,aSeparete,7)
	Set DTHUser		= $p(aInputStr,aSeparete,8)
	Set DTHEditContent = $p(aInputStr,aSeparete,9)
	Set Resume		= $p(aInputStr,aSeparete,10)
	Set objStatus = ##class(DHCMed.SS.Dictionary).GetByTypeCode("DTHRunningState",DTHStatus,"1")
	
	Set:DTHDate'="" DTHDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DTHDate)
	Set:DTHTime[":" DTHTime = $zth(DTHTime,1)
	Set:DTHDate="" DTHDate=+$h
	Set:DTHTime="" DTHTime=$p($h,",",2)
	
	If ID="" {
		Set obj=##class(DHCMed.DTH.ReportLog).%New()
	}Else{
		Set obj=##class(DHCMed.DTH.ReportLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DTHReportID		= ReportID
	Set obj.DTHStatus		= objStatus
	Set obj.EpisodeID		= EpisodeID
	Set obj.DTHLoc			= DTHLoc
	Set obj.DTHDate			= DTHDate
	Set obj.DTHTime			= DTHTime
	Set obj.DTHUser			= DTHUser
	Set obj.DTHEditContent  = DTHEditContent
	Set obj.Resume			= Resume
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2023-04-11
/// Description:  保存传染病上报日志信息(在保存传染病报卡信息前调用，自动识别修改内容)
/// Table：       DHCMed.DTH.ReportLog
/// Input：       aReportStr报告信息 aReportSubStr附卡信息
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.DTH.ReportLog).SaveDTHEditLog("39^246^郭里^20230011^18881^1^0000000246^18岁^男^510125199811133817^11/07/2004^中国^汉族^1561^1548^1524^^测试^^河北省唐山市路北区文化路办事处123^天津市市辖区河东区上杭路街456^测试^1554^18908197558^家属住址或工作单位^20230011^11/04/2023^02:00:00^1539^11-羟化酶缺陷^E25.000x011^^^11-羟化酶缺陷^1^^^^^^^^1590^1582^^^^^^^^^^191^^000116^^E25.000x011^^^^^1675^^^^1678^0^417^418^427^501^^^^^^^^^430^783^1135^1149^1151^^^123^456^^^^^^0")
ClassMethod SaveDTHEditLog(aReportStr As %String, aRepLocDr As %String, aRepUsrDR As %String) As %String
{
	New (aReportStr,aRepLocDr,aRepUsrDR)
	Set return=0
	Quit:aReportStr="" return
	Set separete="^"
	
	Set ReportID	= $p(aReportStr,separete,1)	
	Set DTHStatus	= $p(aReportStr,separete,6)
	Set RepUsrDR = aRepUsrDR
	Set RepLocDr = aRepLocDr
	Set EpisodeID	= $p(aReportStr,separete,72)	
	Set:RepUsrDR="" RepUsrDR = $p(aReportStr,separete,5)	
	Set:RepLocDr="" RepLocDr = $p(aReportStr,separete,54)	
	
	Quit:ReportID="" return
	If '$d(^DHCMed.DTH.ReportLogI("IndexReportID",ReportID)) {		//6草稿 1报卡
		Set return = ##class(DHCMed.DTH.ReportLog).Update("^"_ReportID_"^"_DTHStatus_"^"_EpisodeID_"^"_RepLocDr_"^^^"_RepUsrDR_"^^","^")
		Quit return
	}
	Set EditContent=""	//修改内容
	Set objRep =##class(DHCMed.DTH.Report).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Do AddEditContent("1","","姓名",objRep.Name,$p(aReportStr,separete,3))
	Do AddEditContent("1","","年龄",objRep.Age,$p(aReportStr,separete,8))
	Do AddEditContent("1","","性别",objRep.Sex,$p(aReportStr,separete,9))
	Do AddEditContent("3","","出生日期",objRep.Birthday,$p(aReportStr,separete,11))
	Do AddEditContent("1","","国家/地区",objRep.Country,$p(aReportStr,separete,12))
	Do AddEditContent("1","","民族",objRep.Nation,$p(aReportStr,separete,13))
	Do AddEditContent("4","DTHCardType","证件类型",objRep.CardTypeDR,$p(aReportStr,separete,67))
	Do AddEditContent("1","","证件号码",objRep.Identify,$p(aReportStr,separete,10))
	Do AddEditContent("4","DTHMarriage","婚姻状况",objRep.Marital,$p(aReportStr,separete,14))
	Do AddEditContent("4","DTHEducation","文化程度",objRep.Education,$p(aReportStr,separete,15))
	Do AddEditContent("4","DTHCareer","职业",objRep.Occupation,$p(aReportStr,separete,16))
	Do AddEditContent("1","","工作单位",objRep.Company,$p(aReportStr,separete,18))
	Do AddEditContent("4","DTHPregnancies","妊娠期或终止妊娠42天内",objRep.Pregnancies,$p(aReportStr,separete,19))
	Do AddEditContent("1","","户籍地址",objRep.RegAddress,$p(aReportStr,separete,20))
	Do AddEditContent("1","","现住址",objRep.CurrAddress,$p(aReportStr,separete,21))
	Do AddEditContent("1","","家属姓名",objRep.FamName,$p(aReportStr,separete,22))
	Do AddEditContent("4","DTHFamilyRelation","死者关系",objRep.FamRelation,$p(aReportStr,separete,23))
	Do AddEditContent("1","","联系电话",objRep.FamTel,$p(aReportStr,separete,24))
	Do AddEditContent("1","","家属地址或工作单位",objRep.FamAddr,$p(aReportStr,separete,25))
	Do AddEditContent("4","DTHDeathAddress","死亡地点",objRep.DeathPlace,$p(aReportStr,separete,29))
	Do AddEditContent("1","","(a)直接导致死亡的疾病或情况",objRep.AReason,$p(aReportStr,separete,34))
	Do AddEditContent("1","","(a)ICD10",objRep.AReasonICD,$p(aReportStr,separete,58))
	Do AddEditContent("1","","(a)时间间隔",objRep.AInterval,$p(aReportStr,separete,35))
	Do AddEditContent("4","DTHDeathTimes","(a)时间单位",objRep.ATime,$p(aReportStr,separete,63))
	Do AddEditContent("1","","(b)引起(a)的疾病或情况",objRep.BReason,$p(aReportStr,separete,36))
	Do AddEditContent("1","","(b)ICD10",objRep.BReasonICD,$p(aReportStr,separete,59))
	Do AddEditContent("1","","(b)时间间隔",objRep.BInterval,$p(aReportStr,separete,37))
	Do AddEditContent("4","DTHDeathTimes","(b)时间单位",objRep.BTime,$p(aReportStr,separete,64))
	Do AddEditContent("1","","(c)引起(b)的疾病或情况",objRep.CReason,$p(aReportStr,separete,38))
	Do AddEditContent("1","","(c)ICD10",objRep.CReasonICD,$p(aReportStr,separete,60))
	Do AddEditContent("1","","(c)时间间隔",objRep.CInterval,$p(aReportStr,separete,39))
	Do AddEditContent("4","DTHDeathTimes","(d)时间单位",objRep.CTime,$p(aReportStr,separete,65))
	Do AddEditContent("1","","(d)引起(c)的疾病或情况",objRep.DReason,$p(aReportStr,separete,40))
	Do AddEditContent("1","","(d)ICD10",objRep.DReasonICD,$p(aReportStr,separete,61))
	Do AddEditContent("1","","(d)时间间隔",objRep.DInterval,$p(aReportStr,separete,41))
	Do AddEditContent("4","DTHDeathTimes","(d)时间单位",objRep.DTime,$p(aReportStr,separete,66))
	Do AddEditContent("1","","损伤中毒诊断",objRep.DamageDiagnose,$p(aReportStr,separete,57))
	Do AddEditContent("1","","损伤中毒诊断ICD",objRep.DamageDiagnoseICD,$p(aReportStr,separete,62))
	Do AddEditContent("4","DTHDiagnoseUnit","诊断单位",objRep.DiagnoseUnit,$p(aReportStr,separete,43))
	Do AddEditContent("4","DTHDiagnoseBasis","诊断依据",objRep.DiagnoseBasis,$p(aReportStr,separete,44))
	Do AddEditContent("1","","备注",objRep.ResumeText,$p(aReportStr,separete,45))
	Do AddEditContent("1","","死者生前病史及症状体征",objRep.ExamMedical,$p(aReportStr,separete,46))
	Do AddEditContent("1","","被调查者",objRep.ExamName,$p(aReportStr,separete,47))
	Do AddEditContent("4","DTHFamilyRelation","被调查者与死者关系",objRep.ExamRelation,$p(aReportStr,separete,48))
	Do AddEditContent("1","","被调查者联系电话",objRep.ExamTel,$p(aReportStr,separete,49))
	Do AddEditContent("1","","死因推断",objRep.ExamDeathReason,$p(aReportStr,separete,50))
	Do AddEditContent("1","","联系地址",objRep.ExamAddress,$p(aReportStr,separete,51))
	Do AddEditContent("3","","调查日期",objRep.ExamDate,$p(aReportStr,separete,53))
	
	
	Set:EditContent'="" EditContent=$ListToString(EditContent,$c(1))
	
    Set return = ##class(DHCMed.DTH.ReportLog).Update("^"_ReportID_"^"_DTHStatus_"^"_EpisodeID_"^"_RepLocDr_"^^^"_RepUsrDR_"^"_EditContent_"^","^")
    Quit return
AddEditContent(DataType,DicType,FieldText,OldValue,NewValue)
	//DataType:1文本,2数字,3日期,4字典,5,是否,6字典多选,7单选列表,8多选列表,9复选框,10省市县乡
	If (DataType=2) {
		Set OldValue=+OldValue
		Set NewValue=+NewValue
	} ElseIf (DataType=3) {
		Set OldValue=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OldValue)
		Set NewValue=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(NewValue)
	} ElseIf (DataType=4) {
		Set objNewDic=##class(DHCMed.SS.Dictionary).GetObjById(NewValue)
		Set:$IsObject(OldValue) OldValue=OldValue.Description
		Set:$IsObject(objNewDic) NewValue=objNewDic.Description
	} ElseIf (DataType=5)||(DataType=9) {
		Set OldValue=$s((OldValue["Y")||(OldValue["1"):"是",1:"否")
		Set NewValue=$s((NewValue["Y")||(NewValue["1"):"是",1:"否")
	} ElseIf (DataType=6)||(DataType=7) {
		Set objOldDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,OldValue,"")
		Set objNewDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,NewValue,"")
		Set:$IsObject(objOldDic) OldValue=objOldDic.Description
		Set:$IsObject(objNewDic) NewValue=objNewDic.Description
	} ElseIf (DataType=8) {
		Set OldValueStr=""
		If $Length(OldValue,",") > 0 {
			For Index=1:1:$Length(OldValue,","){
				Set IndOldValue=$p(OldValue,",",Index)
				Continue:IndOldValue=""
				Set objNewDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,IndOldValue,"")
				Set:$IsObject(objNewDic) IndOldValue=objNewDic.Description
				Set OldValueStr=OldValueStr_","_IndOldValue
			}
		}
		Set:OldValueStr'="" OldValueStr=$e(OldValueStr,2,$Length(OldValueStr))
		Set OldValue=OldValueStr
		
		Set NewValueStr=""
		If $Length(NewValue,",") > 0 {
			For Index=1:1:$Length(NewValue,","){
				Set IndNewValue=$p(NewValue,",",Index)
				Continue:IndNewValue=""
				Set objNewDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,IndNewValue,"")
				Set:$IsObject(objNewDic) IndNewValue=objNewDic.Description
				Set NewValueStr=NewValueStr_","_IndNewValue
			}
		}
		Set:NewValueStr'="" NewValueStr=$e(NewValueStr,2,$Length(NewValueStr))
		Set NewValue=NewValueStr
	} ElseIf (DataType=10) {
		Set objOldArea=##class(DHCMed.EPD.AreaDic).GetObjById(OldValue)
		Set:$IsObject(objOldArea) OldValue=objOldArea.ShortDesc
		Set objNewArea=##class(DHCMed.EPD.AreaDic).GetObjById(NewValue)
		Set:$IsObject(objNewArea) NewValue=objNewArea.ShortDesc
	}
	Set:OldValue'=NewValue EditContent=EditContent_$lb(FieldText_":"_OldValue_"->"_NewValue)
}

Storage Default
{
<Data name="ReportLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DTHReportID</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>DTHLoc</Value>
</Value>
<Value name="5">
<Value>DTHDate</Value>
</Value>
<Value name="6">
<Value>DTHTime</Value>
</Value>
<Value name="7">
<Value>DTHUser</Value>
</Value>
<Value name="8">
<Value>DTHEditContent</Value>
</Value>
<Value name="9">
<Value>Resume</Value>
</Value>
<Value name="10">
<Value>DTHStatus</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH.ReportLogD</DataLocation>
<DefaultData>ReportLogDefaultData</DefaultData>
<IdLocation>^DHCMed.DTH.ReportLogD</IdLocation>
<IndexLocation>^DHCMed.DTH.ReportLogI</IndexLocation>
<StreamLocation>^DHCMed.DTH.ReportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
