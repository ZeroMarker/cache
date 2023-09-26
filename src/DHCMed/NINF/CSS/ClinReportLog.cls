/// 名称: DHCMed.NINF.CSS.ClinReportLog
/// 描述: 横断面 更新日志
/// 编写者：zhufei
/// 编写日期: 2014-06-05
Class DHCMed.NINF.CSS.ClinReportLog Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.CSS.ClinReport [ Cardinality = parent, Inverse = ChildLog ];

/// 更新科室 指向CT_Loc
Property LogLoc As %String(TRUNCATE = 1);

/// 更新人员 指向SS_User
Property LogUser As %String(TRUNCATE = 1);

/// 更新日期
Property LogDate As %Date;

/// 更新时间
Property LogTime As %Time;

/// Creator：     zhufei
/// CreatDate：   2014-06-05
/// Description:  取横断面 更新日志
/// Table：       DHCMed.NINF.CSS.ClinReportLog
/// Input：       DHCMed.NINF.CSS.ClinReportLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.CSS.ClinReportLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.CSS.ClinReportLog
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.CSS.ClinReportLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-06-05
/// Description:  更新横断面 更新日志
/// Table：       DHCMed.NINF.CSS.ClinReportLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.CSS.ClinReportLog).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set obj=##Class(DHCMed.NINF.CSS.ClinReportLog).%New()
	Set ParRef=$p(aInput,CHR1,1)
	Set obj.ParRef=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(ParRef)
	Set obj.LogLoc=$p(aInput,CHR1,2)
	Set obj.LogUser=$p(aInput,CHR1,3)
	Set obj.LogDate=+$h
	Set obj.LogTime=$p($h,",",2)
	
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
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCMed.NINF.CSS("REP",0,"Log")</IndexLocation>
<StreamLocation>^DHCMed.NINF.CSS.ClinReportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
