Class DHCWMR.MQ.DataMaster Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildRecord As DHCWMR.MQ.DataRecord [ Cardinality = children, Inverse = ParRef ];

Relationship ChildRecordI As DHCWMR.MQ.DataRecordI [ Cardinality = children, Inverse = ParRef ];

/// 就诊号
Property EpisodeID As %Integer;

/// 病人信息ID
Property PatientID As %Integer;

/// 数据提取步骤("D|F|S")  出院首页D、首次编目F、二次编目S
Property DFSteps As %String;

/// 出院日期
Property DischDate As %Date;

/// 出院时间
Property DischTime As %Time;

/// 编目日期
Property FPDate As %Date;

/// 编目时间
Property FPTime As %Time;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 是否有效
Property IsActive As %Boolean;

/// 备注
Property Resume As %String;

/// 就诊号索引
Index IndexEpisodeID On EpisodeID [ Unique ];

/// 患者ID索引
Index IndexPatientID On PatientID;

/// 出院日期索引
Index IndexDischDate On DischDate;

/// 编目日期索引
Index IndexFPDate On FPDate;

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  取首页数据主记录
/// Table：       DHCWMR.MQ.DataMaster
/// Input：       ID : DHCWMR.MQ.DataMaster.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.DataMaster).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.DataMaster
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.DataMaster).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.DataMaster).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  更新首页数据主记录
/// Table：       DHCWMR.MQ.DataMaster
/// Input：       InputStr ：首页数据主记录
///               Separate : 分隔符（不允许带"^"）
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataMaster).Update()
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set EpisodeID=$p(aInputStr,aSeparate,1)
	Set PatientID=$p(aInputStr,aSeparate,2)
	Set DFSteps=$p(aInputStr,aSeparate,3)
	Set DischDate=$p(aInputStr,aSeparate,4)
	Set DischTime=$p(aInputStr,aSeparate,5)
	Set FPDate=$p(aInputStr,aSeparate,6)
	Set FPTime=$p(aInputStr,aSeparate,7)
	Set IsActive=$p(aInputStr,aSeparate,8)
	Set Resume=$p(aInputStr,aSeparate,9)
	Quit:(EpisodeID="")||(PatientID="")||(DFSteps="") return
	Quit:(DischDate="")&&(FPDate="") return
	
	Set ID=$o(^DHCWMR.MQ.DataMasterI("IndexEpisodeID",EpisodeID,""))
	If ID="" {
		Set obj=##class(DHCWMR.MQ.DataMaster).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.DataMaster).%OpenId(ID)
		If obj.DFSteps'[DFSteps {
			Set DFSteps=obj.DFSteps_"|"_DFSteps
		}
		If DischDate="" {
			Set DischDate=obj.DischDate
			Set DischTime=obj.DischTime
		}
		If FPDate="" {
			Set FPDate=obj.FPDate
			Set FPTime=obj.FPTime
		}
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EpisodeID=EpisodeID
	Set obj.PatientID=PatientID
	Set obj.DFSteps=DFSteps
	Set obj.DischDate=DischDate
	Set obj.DischTime=DischTime
	Set obj.FPDate=FPDate
	Set obj.FPTime=FPTime
	Set obj.UpdateDate=+$h
	Set obj.UpdateTime=$p($h,",",2)
	Set obj.IsActive=IsActive
	Set obj.Resume=Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  删除首页数据主记录
/// Table：       DHCWMR.MQ.DataMaster
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.DataMaster).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.DataMaster).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DataMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>DFSteps</Value>
</Value>
<Value name="5">
<Value>DischDate</Value>
</Value>
<Value name="6">
<Value>DischTime</Value>
</Value>
<Value name="7">
<Value>FPDate</Value>
</Value>
<Value name="8">
<Value>FPTime</Value>
</Value>
<Value name="9">
<Value>UpdateDate</Value>
</Value>
<Value name="10">
<Value>UpdateTime</Value>
</Value>
<Value name="11">
<Value>IsActive</Value>
</Value>
<Value name="12">
<Value>Resume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MQ.DataMasterD</DataLocation>
<DefaultData>DataMasterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MQ.DataMasterD</IdLocation>
<IndexLocation>^DHCWMR.MQ.DataMasterI</IndexLocation>
<StreamLocation>^DHCWMR.MQ.DataMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
