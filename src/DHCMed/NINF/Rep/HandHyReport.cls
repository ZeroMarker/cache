/// 名称: DHCMed.NINF.Rep.HandHyReport
/// 描述: 手卫生依从性报告
/// 编写者：zhufei
/// 编写日期: 2013-06-18
Class DHCMed.NINF.Rep.HandHyReport Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 更新日志
Relationship ChildLog As DHCMed.NINF.Rep.HandHyReportLog [ Cardinality = children, Inverse = ParRef ];

/// 科室 指向CT_Loc
Property HHRObsLoc As %String(TRUNCATE = 1);

/// 观察日期
Property HHRObsDate As %Date;

/// 观察时间
Property HHRObsTime As %Time;

/// 观察员 指向SS_User
Property HHRObsUser As %String(TRUNCATE = 1);

/// 专业/职业（医生、护士、护工、保洁员）("NINFHandHyStIdentity")
Property HHRStIdentity As DHCMed.SS.Dictionary;

/// 工号（观察对象）
Property HHRStInitials As %String(TRUNCATE = 1);

/// 姓名（观察对象）
Property HHRStName As %String(TRUNCATE = 1);

/// 手卫生指针("NINFHandHyPoint")
Property HHRPoint As DHCMed.SS.Dictionary;

/// 手卫生措施("NINFHandHyAction")
Property HHRAction As DHCMed.SS.Dictionary;

/// 手卫生正确性("NINFHandHyActionRit")
Property HHRActionRit As DHCMed.SS.Dictionary;

/// 报告日期
Property HHRRepDate As %Date;

/// 报告时间
Property HHRRepTime As %Time;

/// 报告科室 指向CT_Loc
Property HHRRepLoc As %String(TRUNCATE = 1);

/// 报告人 指向SS_User
Property HHRRepUser As %String(TRUNCATE = 1);

/// 报告状态("NINFHandHyReportStatus")
Property HHRRepStatus As DHCMed.SS.Dictionary;

/// 备注
Property HHRResume As %String(TRUNCATE = 1);

Index IndexObsDateLoc On (HHRObsDate As Exact, HHRObsLoc As Exact);

Index IndexRepDateLoc On (HHRRepDate As Exact, HHRRepLoc As Exact);

/// Creator：     zhufei
/// CreatDate：   2013-06-18
/// Description:  取手卫生依从性报告
/// Table：       DHCMed.NINF.Rep.HandHyReport
/// Input：       DHCMed.NINF.Rep.HandHyReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.HandHyReport).GetObjById("1")
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.HandHyReport
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.HandHyReport).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2013-06-18
/// Description:  更新手卫生依从性报告
/// Table：       DHCMed.NINF.Rep.HandHyReport
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.HandHyReport).Update("","")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ID=$p(aInput,aSeparate,1)
	If ((ID="undefined")||(ID="")) {
		Set obj=##class(DHCMed.NINF.Rep.HandHyReport).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.HandHyReport).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.HHRObsLoc=$p(aInput,aSeparate,2)
	Set ObsDate=$p(aInput,aSeparate,3)
	Set:ObsDate["-" ObsDate=$zdh(ObsDate,3)
	Set obj.HHRObsDate=ObsDate
	Set ObsTime=$p(aInput,aSeparate,4)
	Set:ObsTime[":" ObsTime=$zth(ObsTime,2)
	Set obj.HHRObsTime=ObsTime
	Set obj.HHRObsUser=$p(aInput,aSeparate,5)
	Set obj.HHRStIdentity=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,6))
	Set obj.HHRStInitials=$p(aInput,aSeparate,7)
	Set obj.HHRStName=$p(aInput,aSeparate,8)
	Set obj.HHRPoint=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,9))
	Set obj.HHRAction=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,10))
	Set obj.HHRActionRit=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,11))
	Set RepDate=+$h
	Set RepTime=$p($h,",",2)
	Set RepLoc=$p(aInput,aSeparate,12)
	Set RepUser=$p(aInput,aSeparate,13)
	Set RepStatus=$p(aInput,aSeparate,14)
	Set Resume=$p(aInput,aSeparate,15)
	If ((ID="undefined")||(ID="")) {
		Set obj.HHRRepDate=RepDate
		Set obj.HHRRepTime=RepTime
		Set obj.HHRRepLoc=RepLoc
		Set obj.HHRRepUser=RepUser
	}
	Set obj.HHRRepStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatus)
	Set obj.HHRResume=Resume
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		
		//更新日志
		Set UpdateLog=obj.%Id()_"^"_RepLoc_"^"_RepUser_"^"_RepStatus_"^"_Resume
		Set flg=##Class(DHCMed.NINF.Rep.HandHyReportLog).Update(UpdateLog,"^")
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
<Value>HHRObsLoc</Value>
</Value>
<Value name="3">
<Value>HHRObsDate</Value>
</Value>
<Value name="4">
<Value>HHRObsTime</Value>
</Value>
<Value name="5">
<Value>HHRObsUser</Value>
</Value>
<Value name="6">
<Value>HHRStIdentity</Value>
</Value>
<Value name="7">
<Value>HHRStInitials</Value>
</Value>
<Value name="8">
<Value>HHRStName</Value>
</Value>
<Value name="9">
<Value>HHRPoint</Value>
</Value>
<Value name="10">
<Value>HHRAction</Value>
</Value>
<Value name="11">
<Value>HHRActionRit</Value>
</Value>
<Value name="12">
<Value>HHRRepDate</Value>
</Value>
<Value name="13">
<Value>HHRRepTime</Value>
</Value>
<Value name="14">
<Value>HHRRepLoc</Value>
</Value>
<Value name="15">
<Value>HHRRepUser</Value>
</Value>
<Value name="16">
<Value>HHRRepStatus</Value>
</Value>
<Value name="17">
<Value>HHRResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF("HandHy")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF("HandHy")</IdLocation>
<IndexLocation>^DHCMed.NINFi("HandHy",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.HandHyReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
