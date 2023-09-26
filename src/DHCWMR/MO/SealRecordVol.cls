/// 病案封存病案卷表
Class DHCWMR.MO.SealRecordVol Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MO.SealRecord [ Cardinality = parent, Inverse = ChildVol ];

/// 病案卷
Property RVolumeDr As DHCWMR.SS.Volume;

/// 病案卷 索引
Index IndexVolumeDr On RVolumeDr;

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  更新病案封存病案卷表
/// Table：       DHCWMR.MO.SealRecordVol
/// Input：       InputStr ：Parref^SubId^DHCWMR.SS.Volume.ID
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.SealRecordVol).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return

	Set Parref 			= $p(aInputStr,aSeparate,1)
	Set SubID			= $p(aInputStr,aSeparate,2)
	Set VolumeID		= $p(aInputStr,aSeparate,3)
	Quit:(Parref="")||(VolumeID="") return
	
	Set objParref = ##class(DHCWMR.MO.SealRecord).GetObjById(Parref)
	Quit:'$IsObject(objParref) return

	Set objVolume = ##class(DHCWMR.SS.Volume).GetObjById(VolumeID)
	Quit:'$IsObject(objVolume) return
	
	If SubID="" {
		Set obj=##class(DHCWMR.MO.SealRecordVol).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.SealRecordVol).%OpenId(Parref_"||"_SubID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref			= objParref
	Set obj.RVolumeDr		= objVolume		
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  取病病案封存病案卷表
/// Table：       DHCWMR.MO.SealRecordVol
/// Input：       Id : DHCWMR.MO.SealRecordVol.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.SealRecordVol).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.SealRecordVol
{
	new (aId)
	quit:'##class(DHCWMR.MO.SealRecordVol).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MO.SealRecordVol).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-10-14
/// Description:  删除病案封存病案卷表
/// Table：       DHCWMR.MO.SealRecordVol
/// Input：       Id : DHCWMR.MO.SealRecordVol.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.SealRecordVol).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RVolumeDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("VOL")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("VOL")</IdLocation>
<IndexLocation>^DHCWMR.MO.SealRecordI("VOL")</IndexLocation>
<StreamLocation>^DHCWMR.MO.SealRecordVolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
