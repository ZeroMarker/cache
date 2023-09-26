/// 名称: DHCMA.CPW.STA.MonthDischData
/// 描述: 临床路径月出院人数记录
/// 编写者：yankai
/// 编写日期: 2021-10-29
Class DHCMA.CPW.STA.MonthDischData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 数据日期(每月第一天)
Property MDDate As %Date;

/// 医院ID
Property MDHospID As %String;

/// 科室ID
Property MDInLocID As %String;

/// 出院人数
Property MDDischCount As %String;

Index IdxofMDDate On (MDDate, MDHospID, MDInLocID) [ Unique ];

/// Creator：     yankai
/// CreatDate：   2021-10-29
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.STA.MonthDischData
/// Input：       DHCMA.CPW.STA.MonthDischData.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.STA.MonthDischData).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.STA.MonthDischData
{
	New (aId)
	Quit:'##class(DHCMA.CPW.STA.MonthDischData).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.STA.MonthDischData).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2021-10-29
/// Description:  生成一条记录
/// Table：       DHCMA.CPW.STA.MonthDischData
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.STA.MonthDischData).Update("65653^2!!1^36!!1^11")
ClassMethod Update(aInputs As %String, aSeparete = "^") As %String
{
	New (aInputs)
	Set return=""
	Quit:aInputs="" return
	
	Set Date           	 = $p(aInputs,"^",1)
	Set HospID           = $p(aInputs,"^",2)
	Set InLocID          = $p(aInputs,"^",3)
	Set DischCount       = $p(aInputs,"^",4)
	
	Set ID=""
	Set ID=$o(^DHCMA.CPW.STA.MonthDischDataI("IdxofMDDate",Date," "_HospID," "_InLocID,ID))
	If (ID'="") {
		Set obj=..GetObjById(ID)
	} Else {
		Set obj=##class(DHCMA.CPW.STA.MonthDischData).%New()
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MDDate = Date
	Set obj.MDHospID = HospID
	Set obj.MDInLocID = InLocID
	Set obj.MDDischCount = DischCount 
	
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

Storage Default
{
<Data name="MonthDischDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MDDate</Value>
</Value>
<Value name="3">
<Value>MDHospID</Value>
</Value>
<Value name="4">
<Value>MDInLocID</Value>
</Value>
<Value name="5">
<Value>MDDischCount</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.STA.MonthDischDataD</DataLocation>
<DefaultData>MonthDischDataDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.STA.MonthDischDataD</IdLocation>
<IndexLocation>^DHCMA.CPW.STA.MonthDischDataI</IndexLocation>
<StreamLocation>^DHCMA.CPW.STA.MonthDischDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
