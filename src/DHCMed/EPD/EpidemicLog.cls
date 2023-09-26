/// 名称: DHCMed.EPD.EpidemicLog
/// 描述: 传染病上报日志信息
/// 编写者: mayanpeng
/// 编写日期: 2021-11-11
Class DHCMed.EPD.EpidemicLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 传染病报告ID
Property EPDReportID As %String;

/// 状态(EpidemicReportStatus)
Property EPDStatus As DHCMed.SS.Dictionary;

/// 科室
Property EPDLoc As %String;

/// 日期
Property EPDDate As %Date;

/// 时间
Property EPDTime As %Time;

/// 操作人
Property EPDUser As %String;

/// 处置意见(删除原因、退回原因等)
Property EPDOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String;

/// 备注
Property Resume As %String;

/// 修改内容
Property EPDEditContent As %String(MAXLEN = 5000, TRUNCATE = 1);

Index IndexReportID On EPDReportID As Exact;

Index IndexReportIDDateTime On (EPDReportID As Exact, EPDDate, EPDTime);

Index IndexEpisodeID On EpisodeID As Exact;

/// Creator：     mayanpeng
/// CreatDate：   2021-11-11
/// Description:  根据ID取传染病上报日志信息
/// Table：       DHCMed.EPD.EpidemicLog
/// Input：       aId : DHCMed.EPD.EpidemicLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.EpidemicLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.EpidemicLog
{
	New (aId)
	Quit:'##class(DHCMed.EPD.EpidemicLog).%ExistsId(aId) ""
	Set obj=##Class(DHCMed.EPD.EpidemicLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     mayanpeng
/// CreatDate：   2021-11-11
/// Description:  更新传染病上报日志信息
/// Table：       DHCMed.EPD.EpidemicLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.EpidemicLog).Update("^^^内分泌科^^^医生01^测试1^301^1794","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID			= $p(aInputStr,aSeparete,1)
	Set ReportID	= $p(aInputStr,aSeparete,2)
	Set StatusCode	= $p(aInputStr,aSeparete,3)
	Set EPDLoc		= $p(aInputStr,aSeparete,4)
	Set EPDDate		= $p(aInputStr,aSeparete,5)
	Set EPDTime		= $p(aInputStr,aSeparete,6)
	Set EPDUser		= $p(aInputStr,aSeparete,7)
	Set EPDOpinion	= $p(aInputStr,aSeparete,8)
	Set EpisodeID	= $p(aInputStr,aSeparete,9)
	Set Resume		= $p(aInputStr,aSeparete,10)
	Set EPDEditContent = $p(aInputStr,aSeparete,11)
	
	Set:EPDDate'="" EPDDate = ##class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EPDDate)
	Set:EPDTime[":" EPDTime = $zth(EPDTime,1)
	Set:EPDDate="" EPDDate=+$h
	Set:EPDTime="" EPDTime=$p($h,",",2)
	
	Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicReportStatus",StatusCode,"")
	
	If ID="" {
		Set obj=##class(DHCMed.EPD.EpidemicLog).%New()
	}Else{
		Set obj=##class(DHCMed.EPD.EpidemicLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EPDReportID	= ReportID
	Set obj.EPDStatus	= objStatus
	Set obj.EPDLoc		= EPDLoc
	Set obj.EPDDate		= EPDDate
	Set obj.EPDTime		= EPDTime
	Set obj.EPDUser		= EPDUser
	Set obj.EPDOpinion	= EPDOpinion
	Set obj.EpisodeID	= EpisodeID
	Set obj.Resume		= Resume
	Set obj.EPDEditContent = EPDEditContent
	
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

/// Creator：     mayanpeng
/// CreatDate：   2022-1-14
/// Description:  保存传染病上报日志信息(在保存传染病报卡信息前调用，自动识别修改内容)
/// Table：       DHCMed.EPD.EpidemicLog
/// Input：       aReportStr报告信息 aReportSubStr附卡信息
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMed.EPD.EpidemicLog).SaveEPDEditLog("","")
ClassMethod SaveEPDEditLog(aReportStr As %String, aReportSubStr As %String) As %String
{
	New (aReportStr,aReportSubStr,%session)
	Set return=0
	Quit:aReportStr="" return
	Set separete=$c(1)
	
	Set ReportID	= $p(aReportStr,separete,1)		;MEPD_Rowid
	Set StatusCode	= $p(aReportStr,separete,16)	;MEPD_Status
	Set RepLocDr	=  %session.Get("LOGON.CTLOCID")
	Set RepUsrDR	= %session.Get("LOGON.USERID")
	Set Opinion		= $p(aReportStr,separete,24)	;MEPD_DelReason
	Set EpisodeID	= $p(aReportStr,separete,30)	;MEPD_TEXT1 就诊号
	Set:RepUsrDR="" RepUsrDR = $p(aReportStr,separete,17)	;MEPD_RepUsr_DR
	Set:RepLocDr="" RepLocDr = $p(aReportStr,separete,14)	;MEPD_Loc_DR
	
	Quit:ReportID="" return
	If '$d(^DHCMed.EPD.EpidemicLogI("IndexReportID",ReportID)) {		//6草稿 1报卡
		Set return = ##class(DHCMed.EPD.EpidemicLog).Update("^"_ReportID_"^"_StatusCode_"^"_RepLocDr_"^^^"_RepUsrDR_"^"_Opinion_"^"_EpisodeID_"^","^")
		Quit return
	}
	Set EditContent=""	//修改内容
	Set objRep =##class(DHCMed.EPD.Epidemic).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.MEPDICDDR) return

	Do AddEditContent("4","EpidemicReportRegion","病人属于",objRep.MEPDArea,$p(aReportStr,separete,3))
	Do AddEditContent("4","Career","人群分类",objRep.MEPDOccupation,$p(aReportStr,separete,4))
	Do AddEditContent("1","","家长姓名",objRep.MEPDFamName,$p(aReportStr,separete,5))
    Set ICDDR=+$p(aReportStr,separete,6)			;MEPD_ICD_DR传染病诊断
	If objRep.MEPDICDDR.%Id()'=ICDDR {
		Set objInfection=##class(DHCMed.EPD.Infection).GetObjById(ICDDR)
		If $IsObject(objInfection) {
			Set EditContent=EditContent_$lb("诊断:"_objRep.MEPDICDDR.MIFDisease_"->"_objInfection.MIFDisease)
		}
	}

	Do AddEditContent("4","EpidemicContact","接触情况",objRep.MEPDIntimateCode,$p(aReportStr,separete,7))
	Do AddEditContent("4","EpdemicType","诊断类型",objRep.MEPDDiagnoseType,$p(aReportStr,separete,8))
	Set MEPDSickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.MEPDSickDate)
	Do AddEditContent("1","","发病日期",MEPDSickDate,$p(aReportStr,separete,9))
	Do AddEditContent("4","EpidemicDiagnoseDegree","病例分类",objRep.MEPDDiagDegree,$p(aReportStr,separete,10))
	Do AddEditContent("4","EpidemicSickQuality","临床严重程度",objRep.MEPDSickKind,$p(aReportStr,separete,12))
	Set MEPDDeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.MEPDDeathDate)
	Do AddEditContent("1","","死亡日期",MEPDDeathDate,$p(aReportStr,separete,13))
	Do AddEditContent("4","REPPLACE","报告位置",objRep.MEPDRepPlace,$p(aReportStr,separete,15))
	Do AddEditContent("1","","备注",objRep.MEPDDemo,$p(aReportStr,separete,23))
	Do AddEditContent("1","","退卡或删除原因",objRep.MEPDDelReason,$p(aReportStr,separete,24))
	Do AddEditContent("1","","联系电话",objRep.MEPDTelPhone,$p(aReportStr,separete,26))
	Do AddEditContent("1","","现住址",objRep.MEPDAddress,$p(aReportStr,separete,27))
	Do AddEditContent("1","","单位(学校)",objRep.MEPDCompany,$p(aReportStr,separete,28))
	Do AddEditContent("1","","户籍地址",objRep.MEPDIDAddress,$p(aReportStr,separete,29))
	Do AddEditContent("1","","诊断日期",objRep.MEPDDiagDateTime,$p(aReportStr,separete,38))
    Do AddEditContent("4","EpidemicCardType","证件类型",objRep.MEPDText4,$p(aReportStr,separete,40))
	Do AddEditContent("1","","有效证件号",objRep.MEPDText5,$p(aReportStr,separete,41))
	Do AddEditContent("1","","其他人群",objRep.MEPDText6,$p(aReportStr,separete,42))
	Do AddEditContent("4","EpidemicSeverity","临床严重程度",objRep.MEPDSeverity,$p(aReportStr,separete,43))
    Do AddEditContent("4","EPDIsCheck","是否为境外输入病例",objRep.MEPDIsInEPD,$p(aReportStr,separete,44))
	Do AddEditContent("1","","入境前居住或旅行的国家或地区",objRep.MEPDContr,$p(aReportStr,separete,45))
	
	//附卡内容
	Set separeteSub=$c(2)
	For intSub=1:1:$l(aReportSubStr,separeteSub) {
		Set subStr=$p(aReportSubStr,separeteSub,intSub)
		Continue:subStr=""
		Set newSubData($p(subStr,$c(1),6)) = $p(subStr,$c(1),4)
	}
	
	Set SubListInfo=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.EPDService.EpidemicSubSrv","QryEpidemicSubInfo",ReportID)
	For indSubInfo=1:1:SubListInfo.Count() {
		Set SubInfo = SubListInfo.GetAt(indSubInfo)
		Continue:SubInfo=""
		Set ItemCode=SubInfo.GetAt("ItemCode")
		Set ItemType=SubInfo.GetAt("ItemType")			//数据格式Code
		Set ItemDic=SubInfo.GetAt("ItemDic")			//字典类型
		Set ItemCaption=SubInfo.GetAt("ItemCaption")
		Set HiddenValue=SubInfo.GetAt("HiddenValue")
		Set ItemValue=SubInfo.GetAt("ItemValue")
		Do:($d(newSubData(ItemCode)))&&(newSubData(ItemCode)'=HiddenValue) AddEditContent(ItemType,ItemDic,ItemCaption,HiddenValue,newSubData(ItemCode))
	}
	Set:EditContent'="" EditContent=$ListToString(EditContent,$c(1))
	
    Set return = ##class(DHCMed.EPD.EpidemicLog).Update("^"_ReportID_"^"_StatusCode_"^"_RepLocDr_"^^^"_RepUsrDR_"^"_Opinion_"^"_EpisodeID_"^^"_EditContent,"^")
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
		Set objOldDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,OldValue,"")
		Set objNewDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(DicType,NewValue,"")
		Set:$IsObject(objOldDic) OldValue=objOldDic.Description
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

/// Creator：     mayanpeng
/// CreatDate：   2021-11-11
/// Description:  删除传染病上报日志信息
/// Table：       DHCMed.EPD.EpidemicLog
/// Input：       aId : DHCMed.EPD.EpidemicLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMed.EPD.EpidemicLog).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMed.EPD.EpidemicLog).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="EpidemicLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPDReportID</Value>
</Value>
<Value name="3">
<Value>EPDStatus</Value>
</Value>
<Value name="4">
<Value>EPDLoc</Value>
</Value>
<Value name="5">
<Value>EPDDate</Value>
</Value>
<Value name="6">
<Value>EPDTime</Value>
</Value>
<Value name="7">
<Value>EPDUser</Value>
</Value>
<Value name="8">
<Value>EPDOpinion</Value>
</Value>
<Value name="9">
<Value>EpisodeID</Value>
</Value>
<Value name="10">
<Value>Resume</Value>
</Value>
<Value name="11">
<Value>EPDEditContent</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.EpidemicLogD</DataLocation>
<DefaultData>EpidemicLogDefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.EpidemicLogD</IdLocation>
<IndexLocation>^DHCMed.EPD.EpidemicLogI</IndexLocation>
<StreamLocation>^DHCMed.EPD.EpidemicLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
