/// 名称: DHCHAI.STA.HandHy
/// 描述: 手卫生统计数据
/// 编写者：jiangpengpeng
/// 编写日期: 2018-07-31
Class DHCHAI.STA.HandHy Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 院区
Property ECHospID As %String;

/// 科室
Property ECLocID As %String;

/// 调查时机数
Property ECValue1 As %String;

/// 依从数
Property ECValue2 As %String;

/// 正确数
Property ECValue3 As %String;

/// 职业("HandHyObsType")
Property ECObsTypeDr As DHCHAI.BT.Dictionary;

/// 指征("HandHyOpportunity")
Property ECOpportunityDr As DHCHAI.BT.Dictionary;

/// 调查人数
Property ECPatCount As %String;

/// 时间标记
Property ECTime As %Date;

/// 调查时机
Property ObsTime As %String;

/// 更新日期
Property ECUpdateD As %Date;

/// 更新时间
Property ECUpdateT As %Time;

Index IdxofLoc On (ECHospID As Exact, ECLocID As Exact, ECTime As Exact);

Index IdxofObsOpp On (ECHospID As Exact, ECLocID As Exact, ECTime As Exact, ECObsTypeDr As Exact, ObsTime As Exact, ECOpportunityDr As Exact);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  根据ID取统计结果
/// Table：       DHCHAI.STA.HandHy
/// Input：       aId : DHCHAI.STA.HandHy
/// Return：      返回obj
/// w ##class(DHCHAI.STA.HandHy).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.STA.HandHy
{
	New (aId)
	Quit:'##class(DHCHAI.STA.HandHy).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.STA.HandHy).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  更新统计结果信息
/// Table：       DHCHAI.STA.HandHy
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.STA.HandHy).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID      	= $p(aInputStr,aSeparete,1)
	Set ECHospID    = $p(aInputStr,aSeparete,2)
	Set ECLocID     = $p(aInputStr,aSeparete,3)
	Set ECValue1 	= $p(aInputStr,aSeparete,4)
	Set ECValue2 	= $p(aInputStr,aSeparete,5)
	Set ECValue3    = $p(aInputStr,aSeparete,6)
	Set ECObsType  	= $p(aInputStr,aSeparete,7)
	Set ECOpportunity  	= $p(aInputStr,aSeparete,8)
	Set ECPatCount  	= $p(aInputStr,aSeparete,9)
	Set ECTime  	= $p(aInputStr,aSeparete,10)
	Set ObsTime  	= $p(aInputStr,aSeparete,11)
	Set ECUpdateD  	= +$H
	Set ECUpdateT  	= $p($H,",",2)
	
	
	Set:ID="" ID=$o(^DHCHAI.STA.HandHyI("IdxofObsOpp",ECHospID,ECLocID,ECTime,ECObsType,ObsTime,ECOpportunity,""))
	
	If ID="" {
		Set obj=##class(DHCHAI.STA.HandHy).%New()
	}Else{
		Set obj=##class(DHCHAI.STA.HandHy).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ECHospID   = ECHospID
	Set obj.ECLocID    = ECLocID
	Set obj.ECValue1    = ECValue1
	Set obj.ECValue2   = ECValue2
	Set obj.ECValue3    = ECValue3
	Set obj.ECObsTypeDr   = ##class(DHCHAI.BT.Dictionary).GetObjById(ECObsType)
	Set obj.ECOpportunityDr = ##class(DHCHAI.BT.Dictionary).GetObjById(ECOpportunity)
	Set obj.ECPatCount	   = ECPatCount
	Set obj.ECTime     = ECTime
	Set obj.ObsTime     = ObsTime
	Set obj.ECUpdateD  = ECUpdateD
	Set obj.ECUpdateT  = ECUpdateT
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-06-12
/// Description:  删除统计结果信息
/// Table：       DHCHAI.STA.HandHy
/// Input：       aId : DHCHAI.STA.HandHy.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.STA.HandHy).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.STA.HandHy).%DeleteId(aId)
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
<Data name="HandHyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECHospID</Value>
</Value>
<Value name="3">
<Value>ECLocID</Value>
</Value>
<Value name="4">
<Value>ECValue1</Value>
</Value>
<Value name="5">
<Value>ECValue2</Value>
</Value>
<Value name="6">
<Value>ECValue3</Value>
</Value>
<Value name="7">
<Value>ECObsTypeDr</Value>
</Value>
<Value name="8">
<Value>ECOpportunityDr</Value>
</Value>
<Value name="9">
<Value>ECPatCount</Value>
</Value>
<Value name="10">
<Value>ECTime</Value>
</Value>
<Value name="11">
<Value>ObsTime</Value>
</Value>
<Value name="12">
<Value>ECUpdateD</Value>
</Value>
<Value name="13">
<Value>ECUpdateT</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.STA.HandHyD</DataLocation>
<DefaultData>HandHyDefaultData</DefaultData>
<IdLocation>^DHCHAI.STA.HandHyD</IdLocation>
<IndexLocation>^DHCHAI.STA.HandHyI</IndexLocation>
<StreamLocation>^DHCHAI.STA.HandHyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
