/// 名称: DHCMA.CPW.CP.PathwayEpisRevoke
/// 描述: 临床路径 路径阶段撤销记录
/// 编写者：dengshaopeng
/// 编写日期: 2020-07-15
Class DHCMA.CPW.CP.PathwayEpisRevoke Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 当前路径PathwayID
Property CPPathwayID As %String;

/// 撤销前阶段
Property BefoRevokeEpisID As %String;

/// 阶段撤销人
Property RevokeUser As %String;

/// 撤销日期
Property RevokeDate As %Date;

/// 撤销时间
Property RevokeTime As %Time;

Index IndexofCPPathwayID On CPPathwayID As Exact;

/// Creator：     dengshaopeng
/// CreatDate：   2020-07-15
/// Description:  更新数据
/// Table：       DHCMA.CPW.CP.PathwayEpisRevoke
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.CP.PathwayEpisRevoke).Update(1)
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set ID=$p(aInputStr,aSeparete,1)
	Set CPPathwayID=$p(aInputStr,aSeparete,2)
	Set BefoRevokeEpisID=$p(aInputStr,aSeparete,3)
	Set RevokeUser=$p(aInputStr,aSeparete,4)
		
	Set RevokeDate=+$H
	Set RevokeTime=$p($H,",",2)
	
	Set xEpisRevokeID=""
	For{
		Set xEpisRevokeID = $O(^DHCMA.CPW.CP.PathwayEpisRevokeI("IndexofCPPathwayID",CPPathwayID,xEpisRevokeID))	
		Quit:xEpisRevokeID=""
		Set objRev = ..GetObjById(xEpisRevokeID)
		Quit:'$IsObject(objRev)
		Set ID = objRev.%Id()
		Do objRev.%Close()
	}
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.CP.PathwayEpisRevoke).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.CP.PathwayEpisRevoke).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CPPathwayID=CPPathwayID
	Set obj.BefoRevokeEpisID=BefoRevokeEpisID
	Set obj.RevokeUser=RevokeUser
	Set obj.RevokeDate=RevokeDate
	Set obj.RevokeTime=RevokeTime
	
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

/// Creator：     dengshaopeng
/// CreatDate：   2020-07-15
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.CP.PathwayEpis
/// Input：       aId : DHCMA.CPW.CP.PathwayEpisRevoke
/// Return：      返回obj
/// w ##class(DHCMA.CPW.CP.PathwayEpisRevoke).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.CP.PathwayVar
{
	New (aId)
	Quit:'##class(DHCMA.CPW.CP.PathwayEpisRevoke).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.CP.PathwayEpisRevoke).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// 检查是否允许撤销
/// DHCMA.CPW.CP.PathwayEpisRevoke.CheckIsRevoke()
ClassMethod CheckIsRevoke(aCPPathwayID As %String, aCPPathwayEpisID As %String) As %String
{
	New (aCPPathwayID,aCPPathwayEpisID)
	Set return = 1
	
	Set xEpisRevokeID = ""
	For{
		Set xEpisRevokeID = $o(^DHCMA.CPW.CP.PathwayEpisRevokeI("IndexofCPPathwayID",aCPPathwayID,xEpisRevokeID))
		Quit:xEpisRevokeID=""
		Set obj = ..GetObjById(xEpisRevokeID)
		Quit:'$IsObject(obj)
		Set CPPathwayEpisID = obj.BefoRevokeEpisID
		Set:aCPPathwayEpisID'=CPPathwayEpisID return=0
	}
	Quit return
}

Storage Default
{
<Data name="PathwayEpisRevokeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPPathwayID</Value>
</Value>
<Value name="3">
<Value>BefoRevokeEpisID</Value>
</Value>
<Value name="4">
<Value>RevokeUser</Value>
</Value>
<Value name="5">
<Value>RevokeDate</Value>
</Value>
<Value name="6">
<Value>RevokeTime</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.CP.PathwayEpisRevokeD</DataLocation>
<DefaultData>PathwayEpisRevokeDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.CP.PathwayEpisRevokeD</IdLocation>
<IndexLocation>^DHCMA.CPW.CP.PathwayEpisRevokeI</IndexLocation>
<StreamLocation>^DHCMA.CPW.CP.PathwayEpisRevokeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
