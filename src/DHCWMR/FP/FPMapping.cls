/// 诊断对照表
Class DHCWMR.FP.FPMapping Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 编目类型
Property FPMFPType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 诊断/手术标记(D)
Property FPMFPMark As %String(MAXLEN = 100, TRUNCATE = 1);

/// 首页诊断/手术ICD10
Property FPMMRICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 首页诊断/手术名称
Property FPMMRICDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 编目诊断/手术ICD10
Property FPMFPICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 编目诊断/手术名称
Property FPMFPICDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 生成日期
Property FPMBuildDate As %Date;

/// 生成时间
Property FPMBuildTime As %Time;

/// 编码员(SS_User.ID)
Property FPMBuildUser As %Time;

/// 审核日期
Property FPMCheckDate As %Date;

/// 审核时间
Property FPMCheckTime As %Time;

/// 审核人(SS_User.ID)
Property FPMCheckUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property FPMIsActive As %Boolean;

/// 备注
Property FPMResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 诊断/手术标记、首页诊断/手术ICD10 索引
Index IndexMarkMRICD10 On (FPMFPMark, FPMMRICD10);

/// 诊断/手术标记、首页诊断/手术名称 索引
Index IndexMarkMRICDDesc On (FPMFPMark, FPMMRICDDesc);

/// 诊断/手术标记、编目诊断/手术ICD10 索引
Index IndexMarkFPICD10 On (FPMFPMark, FPMFPICD10);

/// 诊断/手术标记、编目诊断/手术名称 索引
Index IndexMarkFPICDDesc On (FPMFPMark, FPMFPICDDesc);

/// 诊断/手术标记、生成日期 索引
Index IndexMarkBuildDate On (FPMFPMark, FPMBuildDate);

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  取诊断对照表
/// Table：       DHCWMR.FP.FPMapping
/// Input：       Id : DHCWMR.FP.FPMapping.ID
/// Return：      返回Object
/// w ##class(DHCWMR.FP.FPMapping).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.FP.FPMapping
{
	new (aId)
	quit:'##class(DHCWMR.FP.FPMapping).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.FP.FPMapping).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  更新诊断对照表
/// Table：       DHCWMR.FP.FPMapping
/// Input：       InputStr ：ID^编目类型,诊断/手术标记,首页诊断/手术ICD10^首页诊断/手术名称^编目诊断/手术ICD10^编目诊断/手术名称^生成日期^生成时间^编码员^审核日期^审核时间^审核人^是否有效^备注
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.FP.FPMapping).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	Set ID=$p(aInputStr,aSeparate,1)
	Set FPType=$p(aInputStr,aSeparate,2)
	Set FPMark=$p(aInputStr,aSeparate,3)
	Set MRICD10=$p(aInputStr,aSeparate,4)
	Set MRICDDesc=$p(aInputStr,aSeparate,5)
	Set FPICD10=$p(aInputStr,aSeparate,6)
	Set FPICDDesc=$p(aInputStr,aSeparate,7)
	Set BuildDate=$p(aInputStr,aSeparate,8)
	set:BuildDate["-" BuildDate=$zdh(BuildDate,3)
	set:BuildDate["/" BuildDate=$zdh(BuildDate,4)
	Set BuildTime=$p(aInputStr,aSeparate,9)
	set:BuildTime[":" BuildTime=$zth(BuildTime,1)
	Set BuildUser=$p(aInputStr,aSeparate,10)
	Set CheckDate=$p(aInputStr,aSeparate,11)
	set:CheckDate["-" CheckDate=$zdh(CheckDate,3)
	set:CheckDate["/" CheckDate=$zdh(CheckDate,4)
	Set CheckTime=$p(aInputStr,aSeparate,12)
	set:CheckTime[":" CheckTime=$zth(CheckTime,1)
	Set CheckUser=$p(aInputStr,aSeparate,13)
	Set IsActive=$p(aInputStr,aSeparate,14)
	Set Resume=$p(aInputStr,aSeparate,15)
	
	Quit:(FPType="")||(FPMark="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.FP.FPMapping).%New()
	} Else {
		Set obj=##class(DHCWMR.FP.FPMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.FPMFPType = FPType
	Set obj.FPMFPMark = FPMark
	Set obj.FPMMRICD10 = MRICD10
	Set obj.FPMMRICDDesc = MRICDDesc 
	Set obj.FPMFPICD10 = FPICD10
	Set obj.FPMFPICDDesc = FPICDDesc
	Set obj.FPMBuildDate = BuildDate
	Set obj.FPMBuildTime = BuildTime
	Set obj.FPMBuildUser = BuildUser
	Set obj.FPMCheckDate = CheckDate
	Set obj.FPMCheckTime = CheckTime
	Set obj.FPMCheckUser = CheckUser
	Set obj.FPMIsActive = IsActive
	Set obj.FPMResume = Resume 
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

/// Creator：     liyi
/// CreatDate：   2015-11-26
/// Description:  删除诊断对照表
/// Table：       DHCWMR.FP.FPMapping
/// Input：       Id : DHCWMR.FP.FPMapping.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.FP.FPMapping).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FPMFPType</Value>
</Value>
<Value name="3">
<Value>FPMFPMark</Value>
</Value>
<Value name="4">
<Value>FPMMRICD10</Value>
</Value>
<Value name="5">
<Value>FPMMRICDDesc</Value>
</Value>
<Value name="6">
<Value>FPMFPICD10</Value>
</Value>
<Value name="7">
<Value>FPMFPICDDesc</Value>
</Value>
<Value name="8">
<Value>FPMBuildDate</Value>
</Value>
<Value name="9">
<Value>FPMBuildTime</Value>
</Value>
<Value name="10">
<Value>FPMBuildUser</Value>
</Value>
<Value name="11">
<Value>FPMCheckDate</Value>
</Value>
<Value name="12">
<Value>FPMCheckTime</Value>
</Value>
<Value name="13">
<Value>FPMCheckUser</Value>
</Value>
<Value name="14">
<Value>FPMIsActive</Value>
</Value>
<Value name="15">
<Value>FPMResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.FP.FPMappingD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.FP.FPMappingD</IdLocation>
<IndexLocation>^DHCWMR.FP.FPMappingI</IndexLocation>
<StreamLocation>^DHCWMR.FP.FPMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
