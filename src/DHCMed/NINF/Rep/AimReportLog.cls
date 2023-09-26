/// 名称: DHCMed.NINF.Rep.AimReportLog
/// 描述: 目标性监测报告
/// 编写者：zhufei
/// 编写日期: 2012-05-26
Class DHCMed.NINF.Rep.AimReportLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.AimReport [ Cardinality = parent, Inverse = ChildLog ];

/// 更新科室 指向CT_Loc
Property LogLoc As %String(TRUNCATE = 1);

/// 更新人员 指向SS_User
Property LogUser As %String(TRUNCATE = 1);

/// 更新日期
Property LogDate As %Date;

/// 更新时间
Property LogTime As %Time;

/// 更新状态("NINFAimReportStatus")
Property LogStatus As DHCMed.SS.Dictionary;

/// 模块代码
/// MDR 多重耐药、OPR 手术部位、PICC 中央导管、UC 导尿管、VAP 呼吸机
/// NPICC NICU中央导管、NUC NICU脐静脉、NVNT NICU气管插管
Property LogModule As %String(TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2012-06-10
/// Description:  取目标性监测报告 更新日志
/// Table：       DHCMed.NINF.Rep.AimReportLog
/// Input：       DHCMed.NINF.Rep.AimReportLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.AimReportLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.AimReportLog
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.AimReportLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-10
/// Description:  更新目标性监测报告 更新日志
/// Table：       DHCMed.NINF.Rep.AimReportLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.AimReportLog).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.AimReportLog).%New()
	Set ParRef=$p(aInput,aSeparate,1)
	Set obj.ParRef=##class(DHCMed.NINF.Rep.AimReport).GetObjById(ParRef)
	Set obj.LogModule=$p(aInput,aSeparate,2)
	Set obj.LogLoc=$p(aInput,aSeparate,3)
	Set obj.LogUser=$p(aInput,aSeparate,4)
	Set obj.LogDate=+$h
	Set obj.LogTime=$p($h,",",2)
	Set StatusID=$p(aInput,aSeparate,5)
	Set obj.LogStatus=##class(DHCMed.SS.Dictionary).GetObjById(StatusID)
	
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
<Value>LogModule</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCMed.NINFi("AimRep",0,"Log")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.AimReportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
