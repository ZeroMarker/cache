/// 病案借阅病案卷表
Class DHCWMR.MO.CopyRecordVol Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCWMR.MO.CopyRecord [ Cardinality = parent, Inverse = ChildVol ];

/// 病案卷
Property RVolumeDr As DHCWMR.SS.Volume;

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  更新病案借阅病案卷表
/// Table：       DHCWMR.MO.CopyRecordVol
/// Input：       InputStr ID^DHCWMR.MO.CopyRecord.ID^DHCWMR.SS.Volume.ID
///               Separate : 分隔符
/// Return：      返回%Id()值
/// w ##class(DHCWMR.MO.CopyRecordFee).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID 				= $p(aInputStr,aSeparate,1)
	Set Parref			= $p(aInputStr,aSeparate,2)
	Set VolumeID 		= $p(aInputStr,aSeparate,3)
	Quit:(VolumeID="")||(Parref="") return
	
	Set objVolume = ##class(DHCWMR.SS.Volume).GetObjById(VolumeID)
	Quit:'$IsObject(objVolume) return
	
	Set objParref = ##class(DHCWMR.MO.CopyRecord).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ID="" {
		Set obj=##class(DHCWMR.MO.CopyRecordVol).%New()
	} Else {
		Set obj=##class(DHCWMR.MO.CopyRecordVol).%OpenId(ID)
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
/// CreatDate：   2015-08-02
/// Description:  取病案借阅病案卷表
/// Table：       DHCWMR.MO.CopyRecordVol
/// Input：       Id : DHCWMR.MO.CopyRecordVol.ID
/// Return：      返回Object
/// w ##class(DHCWMR.MO.CopyRecordVol).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.MO.CopyRecordVol
{
	new (aId)
	quit:'##class(DHCWMR.MO.CopyRecordVol).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.MO.CopyRecordVol).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     liyi
/// CreatDate：   2015-08-02
/// Description:  删除病案借阅病案卷表
/// Table：       DHCWMR.MO.CopyRecordVol
/// Input：       Id : DHCWMR.MO.CopyRecordVol.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.MO.CopyRecordVol).%DeleteId(aId)
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
<IndexLocation>^DHCWMR.MO.CopyRecordI("VOL")</IndexLocation>
<StreamLocation>^DHCWMR.MO.CopyRecordVolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
