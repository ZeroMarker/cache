/// 名称: DHCMed.NINF.Rep.EnviHyReportLog
/// 描述: 环境卫生学监测报告 更新日志
/// 编写者：zhufei
/// 编写日期: 2012-08-17
Class DHCMed.NINF.Rep.EnviHyReportLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.EnviHyReport [ Cardinality = parent, Inverse = ChildLog ];

/// 更新科室 指向CT_Loc
Property LogLoc As %String(TRUNCATE = 1);

/// 更新人员 指向SS_User
Property LogUser As %String(TRUNCATE = 1);

/// 更新日期
Property LogDate As %Date;

/// 更新时间
Property LogTime As %Time;

/// 更新状态("NINFEnviHyReportStatus")
Property LogStatus As DHCMed.SS.Dictionary;

/// 备注(记录退回原因或删除原因等)
Property LogResume As %String(MAXLEN = 200, TRUNCATE = 1);

/// 检测项目条码（10位条码）
Property LogBarCode As %String(TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2012-08-17
/// Description:  取环境卫生学监测报告 更新日志
/// Table：       DHCMed.NINF.Rep.EnviHyReportLog
/// Input：       DHCMed.NINF.Rep.EnviHyReportLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.EnviHyReportLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.EnviHyReportLog
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReportLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-08-17
/// Description:  更新环境卫生学监测报告 更新日志
/// Table：       DHCMed.NINF.Rep.EnviHyReportLog
/// Input：       "^"分隔  报告ID——报告科室——报告人——报告状态——备注
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.EnviHyReportLog).Update("2/117/9/0/","/")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	Set obj=##Class(DHCMed.NINF.Rep.EnviHyReportLog).%New()
	Set ParRef=$p(aInput,CHR1,1)
	Set obj.ParRef=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ParRef)
	Set obj.LogLoc=$p(aInput,CHR1,2)
	Set obj.LogUser=$p(aInput,CHR1,3)
	Set obj.LogDate=+$h
	Set obj.LogTime=$p($h,",",2)
	Set StatusID=$p(aInput,CHR1,4)
	
	Set obj.LogStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	Set obj.LogResume=$p(aInput,CHR1,5)
	Set obj.LogBarCode=$p(aInput,CHR1,6)
	
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

/// 取条码对应记录状态
/// w ##Class(DHCMed.NINF.Rep.EnviHyReportLog).CheckCurrStatus("10","")
ClassMethod CheckCurrStatus(aReportID As %String, aBarCode As %String) As %String
{
	New (aReportID,aBarCode)
	Set return=""
	Quit:(aBarCode="")&&(aReportID="") return
	
	If aBarCode'="" {
		Set ReportID=+$e(aBarCode,2,$l(aBarCode)-2)
		Set SubIndex=+$e(aBarCode,$l(aBarCode)-1,$l(aBarCode))
	} Else {
		Set ReportID=aReportID
		Set SubIndex=0
	}
	
	Set objRep=##class(DHCMed.NINF.Rep.EnviHyReport).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Quit:'$IsObject(objRep.EHRRepStatus) return
	Set StatusCode=objRep.EHRRepStatus.Code
	Set StatusDesc=objRep.EHRRepStatus.Description
	
	Quit:'$IsObject(objRep.EnviHyNorm) return
	Set SpecimenNum=objRep.EnviHyNorm.SpecimenNum
	Set SpecimenList=""
	
	Set BarStatus=0
	If (StatusCode="0")||(StatusCode="1") {
		Set BarStatus=1
	} Else {
		Set LogCnt=objRep.ChildLog.Count()
		For indLog=1:1:LogCnt {
			Set objLog=objRep.ChildLog.GetAt(indLog)
			Continue:'$IsObject(objLog)
			Continue:'$IsObject(objLog.LogStatus)
			Set LogStatusCode=objLog.LogStatus.Code
			Continue:StatusCode'=LogStatusCode
			Set LogStatusDesc=objLog.LogStatus.Description
			Set LogBarCode=objLog.LogBarCode
			If LogBarCode="" {
				Set BarStatus=1
			} Else {
				Set LogSubIndex=+$e(LogBarCode,$l(LogBarCode)-1,$l(LogBarCode))
				If (SubIndex>0) {
					Continue:SubIndex'=LogSubIndex
					Set BarStatus=1
				} Else {
					Continue:$listfind(SpecimenList,LogSubIndex)>0
					Set SpecimenList=SpecimenList_$lb(LogSubIndex)
					Set:$listlength(SpecimenList)=SpecimenNum BarStatus=1
				}
			}
			Quit:BarStatus=1
		}
	}
	Set return=StatusCode_"^"_StatusDesc_"^"_BarStatus
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogLoc</Value>
</Value>
<Value name="3">
<Value>LogUser</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>LogStatus</Value>
</Value>
<Value name="7">
<Value>LogResume</Value>
</Value>
<Value name="8">
<Value>LogBarCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCMed.NINFi("EnviRep",0,"Log")</IndexLocation>
<StreamLocation>^DHCMed.NINF493.EnviHyReport5F1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
